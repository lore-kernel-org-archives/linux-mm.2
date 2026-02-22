Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A890CC624D5
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 09:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD34E6B008C; Sun, 22 Feb 2026 04:31:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81C76B0092; Sun, 22 Feb 2026 04:31:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C808B6B0093; Sun, 22 Feb 2026 04:31:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2A3A6B008C
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 04:31:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57C111A0594
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 09:31:47 +0000 (UTC)
X-FDA: 84471575454.29.054F685
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5D7AE140007
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 09:31:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b=fG5XupDj;
	spf=pass (imf09.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.83 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr;
	dmarc=pass (policy=none) header.from=inria.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771752705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jU7N+0FZIxmxEwn1Lp5kVygLKRMnvrCrP1wvwY45zN8=;
	b=aC/NCLn5/2aUoNbAXkDVQ3rDNN0DG9N86pUyeqXiieIpiakBNGJwPDiGPCnhtpJ3vROmUp
	32hA2/XG2V4Wat8mgQOLOjJztDbxPsfuLvMz84M8ypupu0ZPR15pbkzXyPRTb5Z0QeFdhI
	NS9SkSzvN819BqCUx/mU/DiuZMZN4ZY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b=fG5XupDj;
	spf=pass (imf09.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.83 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr;
	dmarc=pass (policy=none) header.from=inria.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771752705; a=rsa-sha256;
	cv=none;
	b=gOMw7K8K8VPyBJOmvir1mZCBQg6AEQK7CeKLUL61C8wxj8kQtVR3zoaeaAdxYFkMCpJtpt
	mT6vHZWArfJupSbCGPXEXrO+YmXvq2bZOMHf6xIXwQpxfIO68j7nT+Eo5Wd07g5eOnJV2O
	EvtaDN9eCrv7RjjBdA490of848L+pT8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=jU7N+0FZIxmxEwn1Lp5kVygLKRMnvrCrP1wvwY45zN8=;
  b=fG5XupDjBMoGO7fb708vqeI6OVeCTN84B2F345qCuRSbpPLY8zCB1/Ke
   QuC3JP0K3PaMeidqLXldmfcv/5skRO5ymtDel3QVdp4zHpD09ZDOYJKsG
   4h6S6ReTL1GAtuR+7CpQcGEgdpyQZQGsvZ4b8dQ8OWnMjw5Q4bezAW7tu
   8=;
X-CSE-ConnectionGUID: vaOREB1kR4erODUIhCjHtw==
X-CSE-MsgGUID: 48AynL+nT8SXUoCsDo0xsg==
X-IronPort-AV: E=Sophos;i="6.21,304,1763420400"; 
   d="scan'208";a="264582621"
Received: from 231.85.89.92.rev.sfr.net (HELO hadrien) ([92.89.85.231])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2026 10:31:42 +0100
Date: Sun, 22 Feb 2026 10:31:42 +0100 (CET)
From: Julia Lawall <julia.lawall@inria.fr>
To: Eric Biggers <ebiggers@kernel.org>
cc: Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Julia Lawall <Julia.Lawall@inria.fr>, 
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
Subject: Re: [PATCH v6 5/5] coccinelle: Add kmalloc_objs conversion script
In-Reply-To: <20260222041324.GA10695@sol>
Message-ID: <c6ae637-a2de-7919-e9b5-42cd47ddc1a5@inria.fr>
References: <20251203233029.it.641-kees@kernel.org> <20251203233036.3212363-5-kees@kernel.org> <20260222041324.GA10695@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D7AE140007
X-Rspamd-Server: rspam02
X-Stat-Signature: znudidzc9bwmeu38pnfp9ie1ojdsm98g
X-HE-Tag: 1771752705-724118
X-HE-Meta: U2FsdGVkX1+IHxV3yeqgSiVo6cjMK4e7WnO/nybvIFMokgyPPazVoQCn4fmbgDJGgpiSAHwMBpAeIvy3KFgtAsSE3xUes0u/8+L780T0g4LsMj8QcoABezocmns4gV6Wi2pSkPTtNzXV49c1zDfu4VRuJpyVRwe597rEFEIC+ENLaRsrYzL6NGxSiVPA05tlLZmwRG2zJ8zk2QalL6h0Ac4RmTgscE4Y1n2dUr5b/m0Ai1AAhAEeOmiattTOgXJWUDUqd3jDI7UU3DGyAi3ndLaX3FMnBRt8fWG2lhXT0sCZp+jV3p39u7SAMXVI09VsipQDfFA4Z8WX5DawZkr6qbDf0X7TYhWZxPctOD4mtwXoMAESsG3384wW1L/hMyAA7F6hdPNReDxeKJImZ2o9KIoK/9SccB9Rs5fMiXCitUIPhyHYLkEef0o/TRc6icVIfhUa6IQ1KNYsa0nvwWOPYU1QXAqOmGg589FPBfnW2uwqF20v0KMd8KTPfQMyeYcJS2f2/twL2VHA+UCc8aTmOw8qpqhmpOpo5ltJnva1F/xS+ugetSIKSr7OB8NTv0OZTaI1Ym/weHC1oFCzfBpMy4e69EUy2B2J35656mwL39UBClbJNjJdDr3twfvMSB8Dq3tMmWfmTY70Ap76GItm2J4lEYHIA4IIv6KAmTR6gpmO4ztFBuj12YOWPWNDe3eIkSy5bgnGKLj1QAlva5Gxi+Av8kYP9ng1sZAaQ5uT9IpiE0+JVHQdMvJ8zSVeFzWJCfX1s1+09EOVuEsrf8+Y+uB17X8YJAv6Evddue1Srne7dIXwvZNOaPNXC/kLndFfXJt79502ywZy4K+/uYVwQMYRR7I9FwvUBpCUebAJTcmMSvM8Ska5w8D1s+4nvKYCaK6svffIn9S/2stKVIb/cy1hFUHOlIuEsVZMn3SjBnIFrOqHPy0e6IGGE06WihvYME5gXI0Zo3qwA2AdX88
 Lf/1zMjK
 f5CjwpQK2Fza2Fb8qEdKE74SayWUqR/tVh1+Lp4rJ6S4qBqFUu0T/TAVjClG82Yr1xUxlgvYDEn8bFYB+qAJnIBQtnv5EoQvCGnQACgWqEd4L1JHhsG5jHuWdxuu9fOP/FMsYd/s5X83IRyb6Yg/KNRMLOMs6vUPPyqT9fW5C6M1Gvlr26zPdM5GkeZWTqNq498U4Vs489h7DWjvdHYawXhB1/kRQVOFZDdSuBzpNYrhII2DgoN6LFdtFXUhXnfsyKjppNF0PfJe6op3lE93cJ4zvUtHRvM85TZdnDFh32tRUPBlbU6HWkhcyyCLvjSQ0syZ85bXCLl1DIWh/Cc0RbURe/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Sat, 21 Feb 2026, Eric Biggers wrote:

> On Wed, Dec 03, 2025 at 03:30:35PM -0800, Kees Cook wrote:
> > Finds and converts sized kmalloc-family of allocations into the
> > typed kmalloc_obj-family of allocations.
> >
> > Signed-off-by: Kees Cook <kees@kernel.org>
> > ---
> > Cc: Julia Lawall <Julia.Lawall@inria.fr>
> > Cc: Nicolas Palix <nicolas.palix@imag.fr>
> > Cc: cocci@inria.fr
> > ---
> >  scripts/coccinelle/api/kmalloc_objs.cocci | 109 ++++++++++++++++++++++
> >  1 file changed, 109 insertions(+)
> >  create mode 100644 scripts/coccinelle/api/kmalloc_objs.cocci
>
> Is there a way to reproduce commit 69050f8d6d075dc using this semantic
> patch as claimed?  I spend a while installing the latest version of
> spatch (which was quite hard to do due to all the unusual dependencies),
> but it complains that no rules apply:

I guess you would have to write on the command line -D patch?

julia

>
> $ /usr/local/bin/spatch --sp-file scripts/coccinelle/api/kmalloc_objs.cocci --dir . --in-place
> init_defs_builtins: /usr/local/lib/coccinelle/standard.h
> SPECIAL NAMES: adding u8 as a type
> SPECIAL NAMES: adding u16 as a type
> SPECIAL NAMES: adding u32 as a type
> SPECIAL NAMES: adding u64 as a type
> SPECIAL NAMES: adding __u8 as a type
> SPECIAL NAMES: adding __u16 as a type
> SPECIAL NAMES: adding __u32 as a type
> SPECIAL NAMES: adding __u64 as a type
> SPECIAL NAMES: adding uint8_t as a type
> SPECIAL NAMES: adding uint16_t as a type
> SPECIAL NAMES: adding uint32_t as a type
> SPECIAL NAMES: adding uint64_t as a type
> SPECIAL NAMES: adding uchar as a type
> SPECIAL NAMES: adding ushort as a type
> SPECIAL NAMES: adding uint as a type
> SPECIAL NAMES: adding ulong as a type
> SPECIAL NAMES: adding __le16 as a type
> SPECIAL NAMES: adding __le32 as a type
> SPECIAL NAMES: adding __le64 as a type
> SPECIAL NAMES: adding __be16 as a type
> SPECIAL NAMES: adding __be32 as a type
> SPECIAL NAMES: adding __be64 as a type
> SPECIAL NAMES: adding wchar_t as a type
> No rules apply.  Perhaps your semantic patch doesn't contain any +/-/* code, or you have a failed dependency.  If the problem is not clear, try --debug-parse-cocci or check whether any virtual rules (e.g., patch) should be defined.
>

