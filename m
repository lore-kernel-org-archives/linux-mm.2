Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36125D1CDAB
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF94B6B0023; Wed,  3 Dec 2025 18:12:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0A86B0024; Wed,  3 Dec 2025 18:12:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE64C6B0027; Wed,  3 Dec 2025 18:12:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 980096B0023
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:12:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEEAC13BB12
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:12:37 +0000 (UTC)
X-FDA: 84179711154.22.EE043BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1BF10180010
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:12:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ECzRbUgV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764803556; a=rsa-sha256;
	cv=none;
	b=YPrfFLnDXOKpn8KmEH1tWSC2e8L2FikWKOpFsS7BqEz0tEnNIJPnTl6aX2jJsyhuEs9VQU
	5qpDq/N5XCy4gWQLm0EH/OxnP3gXiIwuuZNGByGlAVS58utSiNvdE3IQILvmOFENEK+7us
	ulgGTlCFH5Dj2dGY3PUIyyM2VPSLMX8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ECzRbUgV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764803556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hr3jB9Go3x/RAch40IxGQsMdKgsJJif2jT6tO/2YTTQ=;
	b=dAg9Pjg8PzqTo8Mnr7Fc0hAsRkcSdn5anw+zYleT7K9nwix/jzRkUEfUFQByB9c/wUehi9
	r5RltKG6kkTb+Wb7pVQ+UNKbDdLw3v64kV2I1k8gbHVqXdoy13RnXgYJVwKyYFDk5thYuj
	4wSWlzpI8cV5le+dmkV5ji2YKNWPMI8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2F8E4197C;
	Wed,  3 Dec 2025 23:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902DBC4CEF5;
	Wed,  3 Dec 2025 23:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764803554;
	bh=ZPhrI7MQmYmzyNZKm22NDPTdDlwCRn0ToFC4Np+3dp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ECzRbUgVFXorY0hMDmTNqLr5IhX4IhFOBUqyTHrrZfjh2reDMkbKUjcYvDC2pyaqI
	 uKSGmkeqyC/a7wDkblFIVtyLEdS27sug4U8ux09jwZTHCYCNmtbxnpE3DVv7q2LDi6
	 B77fX3Io8g2a3BUlYVzNFTy1S1FHA/d8xXXNJdOqjJn20HByJZ687QFMay7OjyJJgT
	 xgFyK8C6Ytj/XEG36LYEoWq6QWwSEw1YC+cyXq8CdGkTgcmjNK1r+o3IUwtDb2F7C3
	 +Gj57ItT49/fVfUd2NST/8ny+9JMNohAlT6MxME8vdNk8sUcvYFsZSr1OuY4Skry/G
	 7g7EmfZDRiP9g==
Date: Wed, 3 Dec 2025 15:12:34 -0800
From: Kees Cook <kees@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andy Whitcroft <apw@canonical.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>, Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
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
Subject: Re: [PATCH v5 3/4] checkpatch: Suggest kmalloc_obj family for sizeof
 allocations
Message-ID: <202512031511.ACA8A5DB0@keescook>
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-3-kees@kernel.org>
 <f1d2bb84df85237f23ebf6e0f3dfecfd72d615b6.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1d2bb84df85237f23ebf6e0f3dfecfd72d615b6.camel@perches.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BF10180010
X-Stat-Signature: ckkgk3xhm5af8u7oda93ahx67z3exmwc
X-Rspam-User: 
X-HE-Tag: 1764803555-90154
X-HE-Meta: U2FsdGVkX1/1ZOW7/BEFFMgWMs9ejOC4qlHk0/g+kBijkktP52iEjtoBjH+qjHY7lKtwva80ojvFx0vlrx6y5skR+7YxTaXldzx0txLbcrTeT+7AwTOx84EsFFtg2gfPyDLx7kcSoYes2XkejY45Dcgcowj2TxVH95Pkrcymd+lTmQk/zJNtY9APxCBp7Mq6/i3jWhjRh34pF5SRSM4HmAoNcXfLnsr0auw7x4Ew5R5JZ3Ac8BzsSLiOFwIRs6A/MmLKF3hlAsTFvYauyLDzGck8+KZy0aq6BekFI9CIkxytgpo/IIQU6bEES7tC8L7cammoeCzy7zsdNyn518mMHMQxGzoP9kPIqu9PB3gnaTP9ROc7giBzD4oTuNCba+6HkjTsBfNL4PBtG4hyv9GiADLodd5V/WXRYwwk1txJaGQ/lEKMuhGIiHibFsxJKPY/BhRVL/CE0ixni3MG/TGLNXjXrExfr2dpusTckysc+EYcf2H11zFEldIfExe/XETBfD6CP7ckkhQK3WQ6L6CoI9AseStLeQ5CiqaI6eqh9+ig1NaJG7UD2+mvWhhvE7tOl4sU+LVsV1YKXFUKYYFTsFkZLYYJsVjunlMD/heAVoLYHxheUe+HMecvIKgPbDndTyTXg00cwU2VHRZ8LyuMiAoSowhW+32DpkgXjDynDfTYyi5YZRJy4ZBrqTQgOncEckksc81QOWUUvWFnzhLZMoITj/EjHAT2vZq/wuyGtAHWlvXGTZYmBJPhAMZU8eQJcPP+nqf/ZZ7bRwccl9sXztwF9R9SuDmWrvpmNC6A9Olaxrqd9M+ogb36Vn7AAvbVAi5e7wg5GOAUGHboPj46XOU7YeKfNs0gqqFPM8NvSlY+plWPKMywummHgHfSND1mwlIGrzGhl+DGXXzaUbZmVYo74jXX5VlnxlrKz8+mvuwDqNLYeMNhMmSTilz3TnuRVNd4ZTGVz74h15Ooy51
 wXi7de1p
 MqKCnOvQFyX3E26sL5A6j2jB+D2lg/UU7WHZWNQpH0MNSn4pbDkXJx75m6v0pN/rril1nJBcAFy3GslE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 08:51:19PM -0800, Joe Perches wrote:
> On Fri, 2025-11-21 at 17:42 -0800, Kees Cook wrote:
> > To support shifting away from sized allocation towards typed
> > allocations, suggest the kmalloc_obj family of macros when a sizeof() is
> > present in the argument lists.
> []
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -7258,17 +7258,42 @@ sub process {
> >  			    "Prefer $3(sizeof(*$1)...) over $3($4...)\n" . $herecurr);
> >  		}
> >  
> > -# check for (kv|k)[mz]alloc with multiplies that could be kmalloc_array/kvmalloc_array/kvcalloc/kcalloc
> > +# check for (kv|k)[mz]alloc that could be kmalloc_obj/kvmalloc_obj/kzalloc_obj/kvzalloc_obj
> 
> There are _way_ too many of these existing uses to suggest this change
> in existing files so please add '&& !$file' to these tests

The goal would be to also do the proposed treewide change which gets
the vast majority of them converted.

-- 
Kees Cook

