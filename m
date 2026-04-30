Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4A8FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2C36B0088; Thu, 30 Apr 2026 10:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64966B008A; Thu, 30 Apr 2026 10:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52BF6B008C; Thu, 30 Apr 2026 10:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A38966B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:53:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91D32A253E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:00:39 +0000 (UTC)
X-FDA: 84715382598.08.3013977
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3AE44140022
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:00:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ah4y0IF5;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777557633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWbWmLupSF1aasSwvHeKUZ8NUkzaQhzFHcG2dLXCb2Y=;
	b=3p4INXvkvPPa0lNCg4/zmDJWP186SZi2fiP1G+9Jrd81inQnIXqG1wGHEj0qEWOKUT0o5G
	oABietMpKo3139OiaePhOF+RtS/Ni5stuyWnjW7KTVHcpL6b0Bi7FJb1iY2b571l32aqof
	cN2YFJx4m+/ry8EofrPt5e8SUUoE9sU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ah4y0IF5;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777557633; a=rsa-sha256;
	cv=pass;
	b=TuL26tV6DE6265C4WUT7Uy+ETualr3FF4Pw8cdjfJb/D7GhKQnjX7QDBorZAYRkvXRyc8y
	hzAgPQyukfVxeDxZOd4vEZgmRPOd6oQf3E8mOmUmCYEC8lBBh5cGRJksP1h1zMmWhvd4sb
	n8/j9iCI9ZFYTxKw3/E5UDB1vnlfzuQ=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12c8cc7a77eso1506251c88.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:00:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777557631; cv=none;
        d=google.com; s=arc-20240605;
        b=Jh2uXhf/5qaywSsqVVE+c8BuIbXBLWj782uHl0tGdUniovahRGLcj0DNch0oFNfAat
         G/RrL70Xi9F4C8yNEMlttEBKhx6RxASBcJf6JBa562axSeMDaiWYbzWckOFr6zuTC+9i
         IV9R24mBrqLfhpRQS0SNGBkRt5CivhTcKh7mFgE8SZhM1wptJvRMnjUK9X/ReS1L4Cri
         uy8F3TXekHorodMqwoPzLldK4ucu7xQ7Fer7OTRP46CUcRYLJ/UzRloXIV10dC+QivXS
         HEzBQZkPYHt6tKn1GsyQvhpgYyOlWaRZrPEeJZFA/+PivWxh8jxug3qAVvZejuBT0bee
         pzSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FWbWmLupSF1aasSwvHeKUZ8NUkzaQhzFHcG2dLXCb2Y=;
        fh=4yztm2V5jx4I7B5uJ9Cg3RQa1uWp7EWNDbAW1d6/BPk=;
        b=DJPYsgTNpRpvClDxvbpuBEffspj9aQyBbuXHF9O2j+mul8lkbaAsBIYZ0WygGhi56A
         3iMNwmxj6PQ9+jalrLPwOQZ/7HY7+nU0RNFtT1uQ4KJkXi1eYyA2HQqcfrLwXjyvtcIS
         asQOgK82pks9uR0KsEyobkCQ32ihKXdfMgunW9ExvmbwMOu0CMw1atzSYfis2OdKz22x
         zYObotfIhHfuPrJjLvFHMK8oQxZEfXl5r7chKNH8ghtHo8EYAa1ZFh8gisbU4noIxoHG
         /1uVDcEvFmTktoVJ7uapltwFNaPQ4JuU5ncMTA+/0/YoKKTUZUHFu9baTKrqqrjYZ9K+
         mTUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777557631; x=1778162431; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FWbWmLupSF1aasSwvHeKUZ8NUkzaQhzFHcG2dLXCb2Y=;
        b=Ah4y0IF5WsYIyWXs7lbdmPDu11mQdFr32DwNWm3NZLOZsi7YiI8dOwyAou/r/57oVL
         Dhsvv95DCa4Yec/3WifzqcMD4xzJhunUPcJPHPRZfW5hfFOUYQaa4gvvr2BD+pEudyZP
         E6RkPfhWQCP/Bz9K5gEtL8nChq76IDL0vImN7rKnI4Lv+E3lUBOdQM189HGdK1zOG28p
         IgkY4ZMF30fJG3l7ahRHrGoXpFnxZiYu7zMjE5SWUuC+p1MR+WDds3e/dYIhof0qIYpA
         m2Ynov5cIWhiO3iyMpOYFtzQAzRxRaJBeDQAya0nZChlleBn4ak3xv87ys20cFjXTEap
         VHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777557631; x=1778162431;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FWbWmLupSF1aasSwvHeKUZ8NUkzaQhzFHcG2dLXCb2Y=;
        b=d91zNWvraYshexBQXfoJFffvawN4Bl0FACmTYUm3vYN+Wx6tuFQDF9FFZau33tVwA2
         D4jp5CPjyAAsLcGopvnBchsjUFb0afy8TFHl5hDiloNTQxA5so3uiKsIpFqj4HY6Mn8O
         X/i2iyJPmaQ/YGtl11c5okTv7thogJi0rTsRgoH4zYDJJg0eQuCbIaA/H3vBm6SFTPd4
         wA3EADIhzqyFI75HZuXxtXbSNjT2+ZNPGnaZlRhRVZi+l4Jte5Fcq/XihxeUdEJ3rBeT
         jLazRUrlttvh1F51zyvTCgMM2PiqNtkI3f202KUqTgNjLBwoyxwMMCZB83VZLeyf74a5
         Oevg==
X-Forwarded-Encrypted: i=1; AFNElJ97aKJLgq4q/bgNh2fd9WOKrd894mBdPrf+3DDgqAvcUuZ4Lk9/C5LQIE2kElppODo6c+W97AWUXQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8etosOGdOqXMnjNMCqk98zt4XAchpCxFpYFWVr3aKmgSTqc7a
	we2bx+dFustJk6S9feo8szH1Lmb1FPxi/B0p94hf4sXz4ongoVlDxjeJPeaT3A84PnLSYf8bXD1
	/6EqAFPGl6Sat/qBb+GLAOYpQpxFrpkLIp+F56mgb
X-Gm-Gg: AeBDievGFIvcQZP6ugXFAiCcdceG/SZRvip/FaH4zxVP0VKXlrQhR+eDcdhp8R5VwKP
	1TNchszMyxzepopXW+XzN5cNpY0OeuFaSZDQZiQBup8g/dwrppZZWs/j1Z3QoRzUA7i29YAiQDQ
	tTaMVoxiWpJAwzegywMTjfH8n3qD5nvzvw/RAVYcsZpAU2X5rWpGfkgHSNw378CueNGMHfWfqe/
	dPaIb6sB27S09FQUHgoaBGmi2KAOD51J7dKhDwEEJOQfug2algz8snq6fg6UYXDB73zD681Y+TK
	xOJhSHGrwTOVvYC9djPBNROUQlh18CAD+5oVPoz3hhXYpw4fh1II8lsiQEQ=
X-Received: by 2002:a05:7022:92c:b0:129:1d25:f1da with SMTP id
 a92af1059eb24-12dec602250mr1294888c88.3.1777557630763; Thu, 30 Apr 2026
 07:00:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260424132427.2703076-1-elver@google.com> <20260424132427.2703076-2-elver@google.com>
 <9c321184-9080-4d5c-bd1a-a16cd0bbaed3@kernel.org>
In-Reply-To: <9c321184-9080-4d5c-bd1a-a16cd0bbaed3@kernel.org>
From: Marco Elver <elver@google.com>
Date: Thu, 30 Apr 2026 15:59:52 +0200
X-Gm-Features: AVHnY4L3BCY_keL_qhcVurJjgr2ukKogo3SaEXX5idcPkTjREyzfeKAeC-ucDp0
Message-ID: <CANpmjNN_=g31Eoa+w1NrFALfp1dDBi5oHEZdr_bA_48-tS2M=Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] slab: fix kernel-docs for mm-api
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, 
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AE44140022
X-Rspam-User: 
X-Stat-Signature: 148omt5fr963ppybrmyakastfqbet63k
X-HE-Tag: 1777557632-517450
X-HE-Meta: U2FsdGVkX1/7XaC7Oet5xvCXW7596dAgkfhx6Bc7A+0+r21gwBvNo7+4FaBKtXVIe734++2PU/kVmyYhUsW9n5acWaDHuALTugNA/kUvV3aVt0AXd4g3nJnisf1yV99sjSbgBeCydPtfGks2emeWQlCn7TshnmVnLIEdo65yEcHvJhaublfrsO+SRy4NfR9oiw9pB3SANu28vxSnPz1+qF7mORPnJyply0Hjvq5h2f7HNbojbMnTNTVaff0DMdIkrSdIWFwG+HEQ9XZtg5L6fMo8OvJgpvpYzLLs4NA/p4GWzkwqpTReTE76Ss5P0yWRKp/eTUTKAwdbnu3mMGtmmOZYAUXLwwPHZcvrTwX0MCDzFizNMLa/CivDviRJhl3PEHbwjKRO77H7yJciSQqIx/KUL6dv5GwdEvI4KsTqtjT6v5IyWFnlblkFPnLhyTOtGa58R5kY0E/q4aIQV+UR5RjygrdIrrlOfOJwt9aWdFxpYQAEGF/7U+jt4ljZlyprHWXj9+H1Zr/kT0DdQRO9Eumjpi48uBsQdChOmbbCIBVCqOMRLItT1aVFGHWBd/03rwK1j2AcrWSKgDXv3DXv3mjr8RCmRM6+UOdNoHMcappzeMjaX4Q9isYzrMZkjGuEFafcgT9DTFp3S5cg1M9lKqkwV4kyYIVUedAjgrYrmTRbBUIZ0PV4l8DnALe1vgtYH6B4RamIXaYrjpCM6ptAizkWzAsofc0slSw31N/ZTfByXA5x1JiRI60/B++I+mMI6NTIEMHpZFKXTX/AuE0I37coi2PoendZHB7f+S1KMZMIECJ00zBaqHONaNTmfAEV+zlKsr0ebBWZEn4ZnJCvfaEM9ADPS1p5+5cZZdHmMJcSPULNOxUiTHzVHn2wT66cB9Hjhf6eccrWSaYt9ZK5UXzvhaUrjEl8OXmrhpk3XPSBexSJi/YdKa3u2X4hODAKHyD109X6B/bpjoAyoUz
 B58+dLSz
 5dUJDCW4grvgXP51hv9SR5zrC88RYstBcTg4shXj22rmmmTpndvmBb1dLS0uu20BJvnNd7zA6H+aRcJtykuGe795V+Ks+EjJAI0uo0bTIhXokU0XqsmN5SHrlOSsm1UCDq3YyaTEIaXg/vCX3qbdUF227Z+CBpqPTX6DOyBl8GTwWhjX2CsoS5eQw8Y2wi9tWFAQzOTQ9014IWXDZzOUYQ0pTt2a9Q6kVw6Uji//8q3VV6ltaupc3zIez6aC2P/9DA+N0rkls9YklMkWq5zMa6PZ47JJ5KU0JVE5kYVdx+z5DdVuS3fQ3LiqQRPDxF3uKA4G8+BincvXU6xNhwn25OU8ZW/Ork75MQdoe/D8zreiV6PIsC8LgXLty+eVoB0MdjS7VoR3b25tffpP19HDJzRQaX7EeAk3rNM7HAnasTEbHiaYteqmWOSf4OPej0dSXd+nrmyhnp2f1wIl2cf6nSnbz84p7kAdDoD8cUMJhVU0/6II=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 at 15:40, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>
> On 4/24/26 15:24, Marco Elver wrote:
> > The mm-api kernel-doc comments have been broken for a while, as many
> > documented symbols shifted from being direct function definitions to
> > macros wrapping _noprof implementations during the introduction of
> > allocation tagging (starting with commit 7bd230a26648 "mm/slab: enable
> > slab allocation tagging for kmalloc and friends").
> >
> > When the kernel-doc block remains above the internal implementation
> > function but uses the public API name, the documentation generator fails
> > to associate the documented symbol and generates warnings and fails to
> > emit the documentation.
> >
> > Fix this by:
> >
> > 1. Moving the kernel-doc comment blocks from slub.c to slab.h, placing
> >    them directly above the user-facing macros.
> >
> > 2. Converting the variadic macros for the documented APIs to use
> >    explicit arguments.
> >
> > No functional change intended.
> >
> > Signed-off-by: Marco Elver <elver@google.com>
>
> +Cc Jon
>
> I thought it was supposed to work because the kernel-doc scripts were at the
> time taught by commit 51a7bf0238c2 ("scripts/kernel-doc: drop "_noprof" on
> function prototypes") to handle _noprof. In the current form git grep finds:
>
> tools/lib/python/kdoc/kdoc_parser.py:        suffixes = [ '_noprof' ]
> tools/lib/python/kdoc/xforms_lists.py:        (KernRe("_noprof"), ""),
>
> Doesn't it work for you then?

Ah, I see. So it doesn't work anymore because we add the '_' prefix, too.

I guess the question is if we want to proliferate more kdoc parser
special cases, or just move the docs to the macros. The downside of
macros is that they lose the types in the displayed function
signature.

Preferences?

