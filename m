Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7864D4A60E
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482526B0095; Fri, 16 Jan 2026 03:43:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435576B0096; Fri, 16 Jan 2026 03:43:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358D56B0098; Fri, 16 Jan 2026 03:43:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED736B0095
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:43:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 995A1C2209
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:43:06 +0000 (UTC)
X-FDA: 84337187172.28.57BB70E
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf11.hostedemail.com (Postfix) with ESMTP id 06E9840009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:43:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JLOwxzV2;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768552984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvAazmr6dMrme+XeMG64ySoeTZV4DFrMHH7EkzuBwRY=;
	b=e8sYMqBL0yINehVTvSNhguBmyiYo/NVU8vJ+s06bntXuR0Jq31Tx6Rp2ip/x7zPpOwUMtc
	Cd/ZQ1bHQ8PK14GW/EjkhHFnjgbetBWRoTPtedOZBTT6xnNRiJdLUWWXzPXPWqbj1q++X9
	TTBYJd+pX5FIwvn6dIzxV21ZFKRNunM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JLOwxzV2;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768552984; a=rsa-sha256;
	cv=none;
	b=3nLFyMLR1LlKTZlE2//ILQ+RNaHlLlud/v9KZUyxRCFYKeQeltRJYVj7abP2RendYE4PeP
	+Ao0sq08kY3lJAG7uWbHSw/oNE58X01QVCZXEudMzK8u2pyZLtjiy/T2TWn/NcKCrDwYbQ
	CEnykKRl3NG1SMd2RNlTdd8iBr9OtEY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JvAazmr6dMrme+XeMG64ySoeTZV4DFrMHH7EkzuBwRY=; b=JLOwxzV2Urr8h3nR9Uh7dN+w3F
	s7D0/kOGPcqZMREOXgXsSc2MyOJ5ntSqw4KnflB4SiccGK/+f25r+5TAkSWSMPg7DPvll74TobeeV
	c0I4LiG9h9bEzKtrFW/ZPhDbpLGJ77cCFmt66FBkcmOxlfLZi4y9IDu476nuOdxsP6Nmq/ehp/WfM
	wnKEfKzrmQiRV3VWr5pq3DxmQyhleWyD3M77RIm+nizZlfTOaxDy8CJo/8bA/udP1G8IDlFXYRCcB
	xqtDgdjDETWldebzBAMAVGx03iskEBt8qxiDo0S3Nzn0/3ZgYqbbECZCdNCSHpmC0D2tvanL4LCoq
	n65iiYYg==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgfQ3-00000008JgZ-3MEt;
	Fri, 16 Jan 2026 08:43:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 566F630065D; Fri, 16 Jan 2026 09:42:59 +0100 (CET)
Date: Fri, 16 Jan 2026 09:42:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>, Bill Wendling <morbo@google.com>,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Miguel Ojeda <ojeda@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
	Marc Herbert <Marc.Herbert@linux.intel.com>,
	Uros Bizjak <ubizjak@gmail.com>, Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 2/2] memblock: annotate struct memblock_type with
 __counted_by_ptr
Message-ID: <20260116084259.GK830755@noisy.programming.kicks-ass.net>
References: <20251121193957.1655580-1-morbo@google.com>
 <20251121193957.1655580-3-morbo@google.com>
 <202511211525.05CB7E1AEC@keescook>
 <20251122141614.80f1a845cd694b1b470107ca@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122141614.80f1a845cd694b1b470107ca@linux-foundation.org>
X-Stat-Signature: uqhh3q3jbdx3a3owbnaw1bua7xdqc3zj
X-Rspam-User: 
X-Rspamd-Queue-Id: 06E9840009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768552983-187375
X-HE-Meta: U2FsdGVkX192T9q+2kFpbCICyh7Mn3Ygjed9eenXJSqqsPh3gzhrAqGyy0F6z1rOBLTwa20SSZeqMnzFMVO2y/yB8FCqEcGslhtBJ9MRepQ0eeLExbEJEwmkIJ+RWpq7XomWNXfYoWPUCC2r9XIMIBuGLMkveIhodGiEPtpqbwiSGKedvjoImIEoyo3cpnY2V2BcXOb1RXQmhSCNXWnwawYvLPB9Iy9tLlL3+wfBto2Gl/lOpX1CJnazUz0Kpp3FDBaG14gKysVhcgcuppskE0QWCV89MZdJ4hX3QbVX9mSXuVPpWpvVXAbVIjuS/Q66S8Oo2NLTAUNM3qmyYhxwoDSWmuo/I+XMum6Ye80X4oe6yzc942RFW4gGy0fBlJogo4jp8S8y0q/vRCy/MP0ylyRq1EzJf3Qv533WCKPUrIDMzs8WTjZZFf3+YaBgp23kcEslv+Zz4sm2XyeXArR/YhZJaReiiL4ZIZs0VVYGHZ3QREH8wDS2COSzDMN7r8k20jcoakUNXpHNjAAS2SmeIumUUJ/5kgMq6U97XsxGhKRzYFDBEqAumvIt4REsdYqEOQlAq5HOo5AlrG3ZJv+NQeHs2RFtso+hk78xP6mZLzMliw3cXeBVW4iyLmvH1vkrdkJfIsSjrSo0XFf4x025XA2CNgxGgJ9v4uLkZNbirWflKyAOPSsMdD4/QLsDmRd9esPVaMyBhxAyqpxa/2DkATD8VorS0RHNzuR/LLl/esf66wIDlPjHMUeDXWcP2SXnezc5OfMMNfLgMNW3fc7xJZj5fm62lURoVJlZr+2N0FmjYxC2/O/3IIvQJ5kDDTLVYCa6CgXRRWFGK8ck8kBl5qfVMeMdIxeNIeEye+3D8Hhhq6m7FLG2aD02nNjZMYwDxdi9Z+s2qUv7rPoh2GJ3jsPlBSUkgmpvk7f2mD0UCZk1dVCoFaqC5p7EFDUYqbsjBnjEj7O3SBwOBI9dSBy
 2/jS35/b
 xkktmuYGGJONkFt6JxmQHC2bpdJKiXeWERFIjPa4omMtrbALHMQYnhEH2GvX6SL24cSLTfuhBf+WTqmpWQFirWzio08a21T0BGjDdhFLNyKd7GsR2uClyTxs+4yxg8w3c6nVeyS731bpYGy4iaifWzuWcNWdgSdyt3LkTXGZo88HKYD74zjDDI+4l3llNZMEQwuiNrrmhY7KeoS/kCOGrO1bD+DYtVt6Oh6yKay5PxAJjMQEoRe5sIty/APab5Zw3vAuRF0+ICSkapxop4AWPR0QCaIZJoFVl6/rjUZAL2W2XpOczpdDkrGNC2OZQeHqoN9BcmL03ZHvNTPXXuPwQCYBt6dMKa67YBbu1VGT2AcU4IdJxLL5E6c/+rNtXduSkuQdr2gNN9t93rghuB+8Rioz8QNOV6ingkSnchi0FwMVFhlaif4tWtmUFYATMk/FRfsfy1jtHwsSMGE5P50WE9/5OGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 02:16:14PM -0800, Andrew Morton wrote:
> On Fri, 21 Nov 2025 16:30:43 -0800 Kees Cook <kees@kernel.org> wrote:
> 
> > On Fri, Nov 21, 2025 at 07:39:44PM +0000, Bill Wendling wrote:
> > > Add the '__counted_by_ptr' attribute to the 'regions' field of 'struct
> > > memblock_type'. The 'regions' field is an array of 'struct
> > > memblock_region' and its size is tracked by the 'max' field, which
> > > represents the total number of allocated regions.
> > 
> > As part of any counted_by annotation patch, there needs to be discussion
> > in the commit log about how it's been shown to be a safe annotation
> > to make. e.g. in this case, if all allocations of "regions" have a
> > corresponding "max" assignment, etc. If just "git grep" can't find them
> > all, using something like Coccinelle or CodeQL to search for struct
> > memblock_type::regions assignments can work.
> 
> How is anyone to know these things?  I can't find anything about this
> in include/ or Documentation/ or in the relevant commits.
> 
> There should be a comment at the __counted_by() definition site, please.
> 
> And possibly write a Documentation/ file then change checkpatch to
> direct people to that file if they add a counted_by?

There is:

  https://clang.llvm.org/docs/BoundsSafety.html


