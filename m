Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E19D637D6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91986B0088; Tue, 16 Dec 2025 16:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E516B0089; Tue, 16 Dec 2025 16:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E2C6B008A; Tue, 16 Dec 2025 16:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1AC86B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:57:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7958F13BB1F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:57:05 +0000 (UTC)
X-FDA: 84226695210.05.5C23B64
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	by imf17.hostedemail.com (Postfix) with ESMTP id B845D40004
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:57:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b=Uc7tUYDM;
	spf=pass (imf17.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.104 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr;
	dmarc=pass (policy=none) header.from=inria.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765922224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hFe0Tf5kPTvVQt6GjVYTuMYv34fhcLZszt7yKbypcE=;
	b=QJuOktxd+afIjCZNrW25Q244ClwU1je8lcvcDFDQCYZqmoMLenpu8B7trRqwaYqRz9Y2+u
	Apm4DTa5iGXzcRKC+5lnLhXC4TXQS9NGcPtf1A6gauQGdpt7eo4GyE7xC9Uzg+pZXNWfvw
	ZFeho9+nSTaACEJGvszA+oB/X3b9lXI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b=Uc7tUYDM;
	spf=pass (imf17.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.104 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr;
	dmarc=pass (policy=none) header.from=inria.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765922224; a=rsa-sha256;
	cv=none;
	b=2vIarp4i8JmK8ZPMoo6HnrTK4bgeSo9OfjWCCJjvvdFpmr5R1OQRsmc0YM3UaEfINpFnzV
	CNb2kDG9dCPqEztrbWVk2meRvBkp8R1IQ78INbQPfdFRNJJsho63XVyPcx+c6pHXwBZRbS
	WRzcXfXwqUxJo3G6f6LxWrtcmUY05ZE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=4hFe0Tf5kPTvVQt6GjVYTuMYv34fhcLZszt7yKbypcE=;
  b=Uc7tUYDMmn6ly3+sR5yBeSg7aAMytJmqsgiFGO3Tp0/evDwuGJk2W+Qf
   0PeO8Evqdk0M5lLuWXMHtNJ8r7MMTQ0VaqoavG010+t8XbP6iwZl2YDO1
   /7WJGLPVSyKvQPZevItFh+22/fLQYb67q9vag2YrC5lbPitFIhkt/PQOX
   I=;
X-CSE-ConnectionGUID: XOW00uDeQLq1zCiinoX62Q==
X-CSE-MsgGUID: f+q89m9cRzC9em7sw3lJKg==
X-IronPort-AV: E=Sophos;i="6.21,154,1763420400"; 
   d="scan'208";a="133900367"
Received: from 231.85.89.92.rev.sfr.net (HELO hadrien) ([92.89.85.231])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 22:56:58 +0100
Date: Tue, 16 Dec 2025 22:56:57 +0100 (CET)
From: Julia Lawall <julia.lawall@inria.fr>
To: Kees Cook <kees@kernel.org>
cc: Vlastimil Babka <vbabka@suse.cz>, Julia Lawall <Julia.Lawall@inria.fr>, 
    Nicolas Palix <nicolas.palix@imag.fr>, cocci@inria.fr, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
    Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
    "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
    Matthew Wilcox <willy@infradead.org>, John Hubbard <jhubbard@nvidia.com>, 
    Joe Perches <joe@perches.com>, Christoph Lameter <cl@linux.com>, 
    Marco Elver <elver@google.com>, Vegard Nossum <vegard.nossum@oracle.com>, 
    Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
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
    Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
    linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, 
    llvm@lists.linux.dev
Subject: Re: [cocci] [PATCH v6 5/5] coccinelle: Add kmalloc_objs conversion
 script
In-Reply-To: <20251203233036.3212363-5-kees@kernel.org>
Message-ID: <bfaeb31e-1b4-4e8-6059-907bb27124e0@inria.fr>
References: <20251203233029.it.641-kees@kernel.org> <20251203233036.3212363-5-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Stat-Signature: 91wa1bj5ojo3e36digdkf3mu8hwg96if
X-Rspam-User: 
X-Rspamd-Queue-Id: B845D40004
X-HE-Tag: 1765922223-638636
X-HE-Meta: U2FsdGVkX1/K2SKZKF2a0IWB01eIQbn4raeVqRY+8+ziLViSb5G9yiqdVuXAJ0y8TbNZNM4/N51WFrhMtfBHF5ezyRioFc3DGLo8LCIYeFKr57y11o0qJoMJQRhos1I3IFDIpMxxY2IQwgneT+482iYId710ly0TfMmmMldqf2rSaI/IqKs5evkso5iXSoUi7Te1FneRkrMlLIdlHPveO908eIi5xvcDh4FqchmDgmYlLp6OAZBIKWwJLigUYBCExp9/e+owGbmO7jauwZLh/QeQtbT8f5xOb+2xrE7ZxeC8aVDY1PxNoJDvPEnaX6fR+8XdKQNBetQ5vs9weflN6Su/Nh44mgpZK4Vvf89T+qn9qVkU2rtzNHWcwZFk/vPW1i7ir2vWzjI+2WJ4Ek3DUHm26ovDqGzXVniWtkvgruCvv2Cs574DWIBF1noBIHt87+Xfd6Plv/PBfpv3MemlzyoX/Kv4BSRSeCQGqNYp5zEhV5szMbiAGHU77ROzSqO22Z40Y/att0Ru2hTdRM/7bQnpxopW9Rd+i4+6M281Zk2reKZIb0gJmebpOScOBEFGNe4Rag9qURhgM0ixeJeRFdvka+5U/cZwkNDHzedMTJge6b7oWW6hyMDoNuBbf5DuXZO7luuBsaP6yOTvTNAZWfGa/jri+8LFBSvoib3Ubwg6lBrcvnuPk9wZ2WFqukzYBsnLU1sd0mIrr+aC6sBsMedesaFPZrxHideLHMgt3HKzG8rGb3hCRJS1tMIVZelmDKAfSnNR6dMpcKy4YZf4FXmb1NMuyX0uMhT+4T4F7kNEI0viNTFfKIho8xOTg4pP4+QX0IgWOrAqiLOrim+cTROTulC44EMHoWip5NTw377sc2Ao6u+vGmkyEYRsC28Y6NqyuvVBDw6FYL4N6VTgcF/lzsXMO4i1SncEmDTvt/Cs70xboPm/8qmASIWH4D+6SkqBI7L8NTnIQUHCM9p
 A7wAofOl
 nfErIyYZ1tKbSHyU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, 3 Dec 2025, Kees Cook wrote:

> Finds and converts sized kmalloc-family of allocations into the
> typed kmalloc_obj-family of allocations.

The combination of the use of a regular expression to find the function
names and the big disjunction makes this unnecessarily slow.  I will try
to propose something shortly.

julia

>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Julia Lawall <Julia.Lawall@inria.fr>
> Cc: Nicolas Palix <nicolas.palix@imag.fr>
> Cc: cocci@inria.fr
> ---
>  scripts/coccinelle/api/kmalloc_objs.cocci | 109 ++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
>  create mode 100644 scripts/coccinelle/api/kmalloc_objs.cocci
>
> diff --git a/scripts/coccinelle/api/kmalloc_objs.cocci b/scripts/coccinelle/api/kmalloc_objs.cocci
> new file mode 100644
> index 000000000000..916cc3a661b9
> --- /dev/null
> +++ b/scripts/coccinelle/api/kmalloc_objs.cocci
> @@ -0,0 +1,109 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/// Use kmalloc_obj family of macros for allocations
> +///
> +// Confidence: High
> +// Options: --include-headers-for-types --all-includes --include-headers --keep-comments
> +
> +virtual patch
> +
> +@initialize:python@
> +@@
> +import sys
> +
> +def alloc_array(name):
> +	func = "FAILED_RENAME"
> +	if name == "kmalloc_array":
> +		func = "kmalloc_objs"
> +	elif name == "kvmalloc_array":
> +		func = "kvmalloc_objs"
> +	elif name == "kcalloc":
> +		func = "kzalloc_objs"
> +	elif name == "kvcalloc":
> +		func = "kvzalloc_objs"
> +	else:
> +		print(f"Unknown transform for {name}", file=sys.stderr)
> +	return func
> +
> +// This excludes anything that is assigning to or from integral types or
> +// string literals. Everything else gets the sizeof() extracted for the
> +// kmalloc_obj() type/var argument. sizeof(void *) is also excluded because
> +// it will need case-by-case double-checking to make sure the right type is
> +// being assigned.
> +@direct depends on patch && !(file in "tools") && !(file in "samples")@
> +typedef u8, u16, u32, u64;
> +typedef __u8, __u16, __u32, __u64;
> +typedef uint8_t, uint16_t, uint32_t, uint64_t;
> +typedef __le16, __le32, __le64;
> +typedef __be16, __be32, __be64;
> +type INTEGRAL = {u8,__u8,uint8_t,char,unsigned char,
> +		 u16,__u16,uint16_t,unsigned short,
> +		 u32,__u32,uint32_t,unsigned int,
> +		 u64,__u64,uint64_t,unsigned long,
> +		 __le16,__le32,__le64,__be16,__be32,__be64};
> +char [] STRING;
> +INTEGRAL *BYTES;
> +type TYPE;
> +expression VAR;
> +expression GFP;
> +expression COUNT;
> +expression FLEX;
> +expression E;
> +identifier ALLOC =~ "^kv?[mz]alloc$";
> +fresh identifier ALLOC_OBJ = ALLOC ## "_obj";
> +fresh identifier ALLOC_FLEX = ALLOC ## "_flex";
> +identifier ALLOC_ARRAY = {kmalloc_array,kvmalloc_array,kcalloc,kvcalloc};
> +fresh identifier ALLOC_OBJS = script:python(ALLOC_ARRAY) { alloc_array(ALLOC_ARRAY) };
> +@@
> +
> +(
> +-	VAR = ALLOC((sizeof(*VAR)), GFP)
> ++	VAR = ALLOC_OBJ(*VAR, GFP)
> +|
> +	ALLOC((\(sizeof(STRING)\|sizeof(INTEGRAL)\|sizeof(INTEGRAL *)\)), GFP)
> +|
> +	BYTES = ALLOC((sizeof(E)), GFP)
> +|
> +	BYTES = ALLOC((sizeof(TYPE)), GFP)
> +|
> +	ALLOC((sizeof(void *)), GFP)
> +|
> +-	ALLOC((sizeof(E)), GFP)
> ++	ALLOC_OBJ(E, GFP)
> +|
> +-	ALLOC((sizeof(TYPE)), GFP)
> ++	ALLOC_OBJ(TYPE, GFP)
> +|
> +	ALLOC_ARRAY(COUNT, (\(sizeof(STRING)\|sizeof(INTEGRAL)\|sizeof(INTEGRAL *)\)), GFP)
> +|
> +	BYTES = ALLOC_ARRAY(COUNT, (sizeof(E)), GFP)
> +|
> +	BYTES = ALLOC_ARRAY(COUNT, (sizeof(TYPE)), GFP)
> +|
> +	ALLOC_ARRAY((\(sizeof(STRING)\|sizeof(INTEGRAL)\|sizeof(INTEGRAL *)\)), COUNT, GFP)
> +|
> +	BYTES = ALLOC_ARRAY((sizeof(E)), COUNT, GFP)
> +|
> +	BYTES = ALLOC_ARRAY((sizeof(TYPE)), COUNT, GFP)
> +|
> +	ALLOC_ARRAY(COUNT, (sizeof(void *)), GFP)
> +|
> +	ALLOC_ARRAY((sizeof(void *)), COUNT, GFP)
> +|
> +-	ALLOC_ARRAY(COUNT, (sizeof(E)), GFP)
> ++	ALLOC_OBJS(E, COUNT, GFP)
> +|
> +-	ALLOC_ARRAY(COUNT, (sizeof(TYPE)), GFP)
> ++	ALLOC_OBJS(TYPE, COUNT, GFP)
> +|
> +-	ALLOC_ARRAY((sizeof(E)), COUNT, GFP)
> ++	ALLOC_OBJS(E, COUNT, GFP)
> +|
> +-	ALLOC_ARRAY((sizeof(TYPE)), COUNT, GFP)
> ++	ALLOC_OBJS(TYPE, COUNT, GFP)
> +|
> +-	ALLOC(struct_size(VAR, FLEX, COUNT), GFP)
> ++	ALLOC_FLEX(*VAR, FLEX, COUNT, GFP)
> +|
> +-	ALLOC(struct_size_t(TYPE, FLEX, COUNT), GFP)
> ++	ALLOC_FLEX(TYPE, FLEX, COUNT, GFP)
> +)
> --
> 2.34.1
>
>

