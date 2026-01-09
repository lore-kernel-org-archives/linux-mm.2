Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074A6D26D7B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69ECC6B008A; Fri,  9 Jan 2026 12:31:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655456B0092; Fri,  9 Jan 2026 12:31:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57EC46B0093; Fri,  9 Jan 2026 12:31:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4815F6B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:31:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D60731A04E0
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:31:06 +0000 (UTC)
X-FDA: 84313116132.07.BF2059F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 255FE20008
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:31:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zb3uH6ZB;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40Ey/3HPItE71dh6jwnm5qreFl/HUxRow6GBKJqmy5w=;
	b=x0OyoF0vVsuifR84kt4swTQZmvZYOfEWfDtPTesnwmDJSgHEKLv6buXI8hpi6L7vsXUBsU
	dGvRYkPX180euZEjif2M7BRE8JEC+7zJXVzkPYLmM2/kibnchNWwdoxzLl/ZawpUccK3F0
	SJWf2uCijjvOJQfTzgE9xE+aA381enM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767979865; a=rsa-sha256;
	cv=none;
	b=a+5+CKwIPXDCEmBXG7B+pDQ6Lbnwx9Qke48rjVwifLhNzCw68jMNfMB/kfvIDCBckFT7vJ
	N0unoYG58OBe4xlRxjQNNehNkpYmJZjbCGGclWYmpmDCoUqTjiC7dpdxZSYh5lpHnf1Bpm
	GS7zPyTzstWfP9+l6bBPcORP4fJBl8Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zb3uH6ZB;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F203943CB3;
	Fri,  9 Jan 2026 17:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A50C4CEF1;
	Fri,  9 Jan 2026 17:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767979863;
	bh=YnLjCzKnQER3FuCe6ES9oXxik4owd0B4EMad2UIfiEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zb3uH6ZBwZfeObknlMhLXz6y0O7Yd+lcbqIxtpbkgUGG6UavcGoHaRkBQvHZSNF2n
	 pQStdXJI1VohLDeR1qpGF74WFMxDsP/uXeJR+ObR3RrmnJaCqkS95C+Hw0RpNuFcf5
	 GoPAEEt/X36hy1dO8AoxU3CZSoGH+q/jL1yiONf0HXzyNofTsQ2jvKOxGds4kh8Yhz
	 XVSGdZy9JI1VUWHgjUrbt0jIjhucw841A0LBiPb8vTymFKMiKsqN6rHciHgyobsQQ3
	 nf6x6z0AGWB9ZAu1Tb/cMu8zbewvjfXfN+ipM7+VPadMwl1+2i0KkND8uJpI3Sk4hA
	 Gw6D4gc9Kd9pQ==
Date: Fri, 9 Jan 2026 09:31:03 -0800
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 1/5] slab: Introduce kmalloc_obj() and family
Message-ID: <202601090928.5CFF95F@keescook>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-1-kees@kernel.org>
 <960729bb-0746-4709-a40c-2e254f963deb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960729bb-0746-4709-a40c-2e254f963deb@suse.cz>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 255FE20008
X-Rspam-User: 
X-Stat-Signature: 9w3zzf1xmau7iwtjgdgp5kh9r8q8jeo3
X-HE-Tag: 1767979864-742239
X-HE-Meta: U2FsdGVkX19e7Dnpg8oeryA6UKUrqxeqrZxey2w05QdrP5KwrvHj3934BLux5iUbx/Cq7qIYJpxsQS1oWu/2YBordbaI4XbQ0otLbI6hO+yRUl+Xhg4pJ0dsM5W4FQYYU1fh3fencghYNFZ/qpERHXgOEqJGRcuHphuZL0EeH9iEGomgRJTnpdwRALv0VSsP8zhMB4gVQUKF21yV30zv5/lYeb5iztepQymuGpIiWIAoompmYvy46cNDBr8u2OrZx+7Sy8KvEhJ0BLW48vCCW2iC7VA6Yp3BeL93Up250XsIYXrE7uS4WstW6JC1kVWENGEcwdgZtHB9Z29rkc2BkN6k3HFglYtzaJpeWPSuziDybVXKc8uoWjW02HwPTVC8HBQu5b/JMdlJIKUD3/mzK0T6cmBO/pxcyToN4Oenubl5XEkOvCpYIIKlzLRsLP2/VWbN3/14HsIzgt5+txAP5PSbc2ykeJfVSvEj0S9ZqyaFQmD85VCVE1NrcZcxUAhEePg31wKukDBV0HWf49Isf/ZLD8y+J9RfcGFD1lTpWHLHKpV0BrGAbCvjhK8abWrEaklXGqcG7Ksmep/MNJZ1tijUQK+jRUMkKAcNFg1mcQuNFfFDSG7R8KDFyDSFFj+MABaMtUCXrsuUFL5RGkF9yHaQP7Xt1Cd/hq9eTYQa+Zme3CeIiJ5NcjGpr85vRdArwq+PY86VIoOO+UuunrlQT3h6drhpSerUgu0CpeQt3qfxoWtr8hCRzymicfw6qv7MofVZEzDf7eLgds38JZg4OsNCssPROngOphg/OT1htZboKkUDJcQVPmOcjMiOiwIOWBdXcsW9FkPa9nwmgpCYdX1Wo8shZh919XhFVzJh2tHK3bN/YL6gt9gps8wr53pfunT9BSuqYT88DN9Nfh25C55L0Q+pA7O4fLxn+FOw+7v6o8waBbMTUMTIkHP1WN01Be6r+U8BRZgh9pjUmnJ
 WRtRSp7G
 PNowz0L7wJh12jjlL3URwq5f5qSC/KVsQELG3CJ78CrtL3UM2SdXB5/bizgYFiS7lugh4SIu4cElBVaMKPbxkInUBqY1geJvJk4LBdzmmEjE4Ew/kROt9yO+c1yLfAZyq7S1cA5Lv/5o7eExXOjj0fOn7o9TXaiXG9Kfe49+L2u7rdPeBeN6vpqfHusDL28sHPknBWikQOmUu9uTyBrk+UdkC6g1zW238N9vrunCEUnoUvx3Opep0m34hWfv+QqbnlzZBKqzU+XIBhCenexIpeL3wOHZbePn9FVDmWss6KhiOHPRVlC7+cbqvWC1klIjXXO86Xe4Eii4pyO8KRx2IfuvyGFRfXxg3wwnFa0i269c81k1AZdMD6VjPmuEAyUopTnC8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 03:01:00PM +0100, Vlastimil Babka wrote:
> On 12/4/25 00:30, Kees Cook wrote:
> > [...]
> > +/**
> > + * __alloc_objs - Allocate objects of a given type using
> > + * @KMALLOC: which size-based kmalloc wrapper to allocate with.
> > + * @GFP: GFP flags for the allocation.
> > + * @TYPE: type to allocate space for.
> > + * @COUNT: how many @TYPE objects to allocate.
> > + *
> > + * Returns: Newly allocated pointer to (first) @TYPE of @COUNT-many
> > + * allocated @TYPE objects, or NULL on failure.
> > + */
> > +#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
> > +({									\
> > +	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
> 
> I assume with the hardcoded 1 for COUNT, this size_mul() will be eliminated
> by the compiler and not add unnecessary runtime overhead? Otherwise we
> should have two core #define variants.

You're correct: the compiler completely collapses it with 0 runtime
overhead; a variant is not needed.

> I also noted that the existing kmalloc_array() and kvmalloc_array() do
> check_mul_overflow() and return NULL silently on overflow. This AFAIU will
> make SIZE_MAX passed to the underlying kmalloc/kvmalloc and thus will cause
> a warning. That's IMHO a good thing.

Right -- I prefer seeing the SIZE_MAX yelling from the allocator. Should
we change how k*malloc_array() behaves?

-Kees

-- 
Kees Cook

