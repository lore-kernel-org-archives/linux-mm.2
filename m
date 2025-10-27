Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56816CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 22:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50699800A0; Mon, 27 Oct 2025 18:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DED48009B; Mon, 27 Oct 2025 18:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B58800A0; Mon, 27 Oct 2025 18:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31D888009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:29:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BCC7C025A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:29:37 +0000 (UTC)
X-FDA: 84045337194.16.5E03D30
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7F4F38000E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:29:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ul6omC8+;
	spf=pass (imf30.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761604175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8OllJa5cnTv18Hb5rtu0WqFYbEpD7McBb4G8sNHUxU=;
	b=xTYhB1hPklCHrFZC/w9O/HRLa06WIeZRx5NQwJbZRPGkBIieNzY/WjNOeXo/TtQxg3u+Jm
	98bpXfYE0DfaFP/c8k3d/k3rIR9QM80m2Ft5CZOKpcJsoaltQFrWpKm42qOxtRBpILV40Z
	GihQ6g1tTm0BCw6LOrM7Ia3UU5tlQyc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ul6omC8+;
	spf=pass (imf30.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761604175; a=rsa-sha256;
	cv=none;
	b=a78v/UPfGs2l3rgSmx3lMx5+O4h5k6TA78Nr7HZuRk6GjRNMhJfxKUCQRtIdkF2OAdFSUI
	pfDcS54lceoodFevYk/l5qws7Rt/yX7YWf10LZbj9hFSaMWC7JMb3lyzF1t9HS4edqFNZo
	xAF4sAEVsPU/QM+x7kDq0ftpqI97cSc=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-59310014b8eso142540e87.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761604173; x=1762208973; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q8OllJa5cnTv18Hb5rtu0WqFYbEpD7McBb4G8sNHUxU=;
        b=Ul6omC8+fT2pelfpKeNk8fA5cNd7BERVyibGgHeozIJrPEC0bCl2L73O3bZNjagMu+
         SIabTlvLY5i2U/SFQjOn4s/Q+NyqwWKM0dMZ4g7KI6yHhS1moYO3wJDE7vdCgYfZbDUO
         yvnUCeTfb7yH3mmBqmuZznE1HRU7vQay7VTVw8aud9jpGhj/Egp5+q5Mt538c15byxYk
         GkMNwqyGICAh+2bD6v1MstV/yLV3oiSkAZhoyuxuh47VTByl+DIRK9aqyzbnDpDG0Bkc
         kOTs+W9eRlb9wLSLLsj7kBXDdnzLMmSRkRI/Pv9JHVE2Gl4HElew8+9kECMudnXz2x3f
         LL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761604173; x=1762208973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8OllJa5cnTv18Hb5rtu0WqFYbEpD7McBb4G8sNHUxU=;
        b=sjotxWb6JbTPqIOttyBeqyWYup1EOXbS0CBP/0rGRGPcPd1pHSpDisxF9AI/kBgq5b
         vQulIDxbU9GhvF3d3VN0+oDRlMeMHKdmAmUrvXg0/fBrTKxpcJkDUs3S4CoQ2VDt/yXE
         orp9rfdtEOPFBuoQ1sccng7yUHphlkzTLIw7Q3/QEb1pb5LwkzQzaBPZtVLqLRF44cMh
         nwuHXEEmOOBYReYax0VUQUl8Z/SRQYXzfku26T+PH6xZhqQyi9siDFmCKgtFy15edrkw
         sI/rUC9FsbQYGW5GAsf1pAk79eWysKgRzc0RKJIIywQzYtO22AC1qEP/Z86uRH/dthKc
         CJnA==
X-Forwarded-Encrypted: i=1; AJvYcCW9n9AWdhXH4WDGMdsosHDjhe681gf022KV6Fi8MjZIVWUH+b5kBbOSk/VE8HXET6JyHiY0chEUVQ==@kvack.org
X-Gm-Message-State: AOJu0YwRCFECprEYXeXgfbUvvJfYA5ly6QItWe87+6EXyemVVzaFVTvb
	tkkFz9RU9mR/vTh9QMAyrwejDu+GIQVA8tXxXB4r1QxKPW6k4wmSnTOnrCKGlO+1gHQ4rdyaCsB
	LMeND8uXcEP207mkt8TfNVaswvDR6znggRTY6QnV3
X-Gm-Gg: ASbGncuAxOQFBYe1dsZJEYpaxgErVkCMaOEMG4CVPtLoi+j8j0fdr+Fw2tbaDJU1Fyn
	PxSAMMMS/wa7c2sanjIRDwKVG26gFjRyW7xSU5o29p61bmNg/dBd1ukjAslNvpjiaYkseArg8nY
	2KZj+IcbXWFSFak6kBGSC4BJbvBHVQSy/2s0DN8RyRhXus9ermgKG5DtXVRiCW7sSMQE25tj+IF
	U++PyF2xZzE22fp70VOCoGIBayHBYe1wjPb8q/cPz/CjtINdQ8G0lQ9FoBE8mws353JrdQ=
X-Google-Smtp-Source: AGHT+IG3oQ1hLD3e0hS3PRFF5ObbhSTcrKhhLRIEURqvM4Ky9aK8pSzbBQH6dOSSLG+Z8K1fnWad+2c0m7IK5ji+AAc=
X-Received: by 2002:a2e:9a0b:0:b0:376:49b1:7909 with SMTP id
 38308e7fff4ca-379077694a9mr3618351fa.49.1761604173336; Mon, 27 Oct 2025
 15:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com> <20251021000852.2924827-2-pasha.tatashin@soleen.com>
In-Reply-To: <20251021000852.2924827-2-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 15:29:05 -0700
X-Gm-Features: AWmQ_blnDmlMSHWHiBFbsh6uAwbzzxnGfxP2Tc8ntIAjm82iRY3rUDbemvTKIT8
Message-ID: <CALzav=egQiF6tanYxR9Tow7TnT_UK9bNAR_4DQ2P=2EJ+H4ZJA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org, jasonmiu@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F4F38000E
X-Stat-Signature: tjaympxdp1bxoe9nwdw17eb87faiokiu
X-Rspam-User: 
X-HE-Tag: 1761604175-27097
X-HE-Meta: U2FsdGVkX1/zg8SpcTdIOJaDCDDcuE05qvD1ldWTaYJ1e0Iq1cQuJGQ2qdf8f2IdlywnqsvfnfDsKdWPf6odS77/cc7jvefrTKhrcPpvKUN9QvU4G774ur805DAKDtyerP+QbCUWSMJLzMNWc4Ahj4H7Sbl8Yt9ebdnAcq62vj5epTDjilfXTOYBlc6IiD6gCDyVZmuXLIvUFd7858vu0Mowq+9zCL3fiIrwFraWCyPkPsBKZMdej2VJCYFJAR3hC2qABNohbeDGrlz1wkeoZogUhIKGfarxLK2rb+WtjOatP7tpe2rZOeTgFhP+Awu76aFrop2FbtHMLdNzHyyQl7IXsSiRZ8rgd1H3ZqF4hJmLAbodD0GO+UG15C6C4FH8CoNUz8BaUL614x+u9JcPv+FFBuSiB5Keu3ed70EG0zWSZ42dBAjYJcJe893b69m1QxkKb8/OUG1AgPvYKNy0zW5PdX+efVmr+Zfd+WLixpPwYrdBDsNQ7BX84YJQAOITKOYbv/af+07a/ycNBT5nAWnXcCrkTnU1DgfTOkF1ErOChUSvbncDC6pF2z4RKhhrsG2JjyCaIEdENPtGW/d/grh8Iprls3HDDlV1sB1YyBl1TPF46dBkeMe8nB+igBnWJqE9WQpDotiV2WrSy7V6X+n5esX5K/P+oh3yPkAYesw8j+n/MR4Eod8heGNErP24obYQ6mTT95793scbLZrCz2htQlf33t2KGHzhbK0Opd7deXKY2VmrAk+Lv1/OlISGWpBPbS2I/MR7RNpLRu3Lod2UMaUzlhoBEt7gE0jfLUKhEn+DK+BcCriuAwW2an+ZjPGBTMs8ioDVa2XrKpTXrykJfh3GPASdplswPD/Ual7v5xYvV57bSTRdIp4N5wRPIZrGLpKhlkv42SYa70/16Io6kZo+wzeThiBckqoXyHQXXi3QRyScVSxqpknTkVnB9cPgJ5oKfDQdyjYJM6T
 xSG6Kzzs
 RMmToqw/8iUINUGicOOzSFUceWPpEHCk4bM/dnx/Ldug6+8TffnqHtcB3j62tpD3ejrL/ZYNdJrYDHL4rPG+2Te5/txK3qxB7hwJH5g1uEEfTvEtTH4IpLi9utiC44nNVBpXrYI6iOdyDIHhFNSkDRb1OZuqc62acczSDyuMXLx/S3DQ3d2xeJmatrjffRSmqWBO1JDkbimhm2S4gUTUM2w6f5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 5:08=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> It is invalid for KHO metadata or preserved memory regions to be located
> within the KHO scratch area, as this area is overwritten when the next
> kernel is loaded, and used early in boot by the next kernel. This can
> lead to memory corruption.
>
> Adds checks to kho_preserve_* and KHO's internal metadata allocators
> (xa_load_or_alloc, new_chunk) to verify that the physical address of the
> memory does not overlap with any defined scratch region. If an overlap
> is detected, the operation will fail and a WARN_ON is triggered. To
> avoid performance overhead in production kernels, these checks are
> enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.

How many scratch regions are there in practice? Checking
unconditionally seems like a small price to pay to avoid possible
memory corruption. Especially since most KHO preservation should
happen while the VM is still running (so does not have to by
hyper-optimized).

>  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, si=
ze_t sz)
>  {
> -       void *elm, *res;
> +       void *res =3D xa_load(xa, index);
>
> -       elm =3D xa_load(xa, index);
> -       if (elm)
> -               return elm;
> +       if (res)
> +               return res;
> +
> +       void *elm __free(kfree) =3D kzalloc(sz, GFP_KERNEL);

nit: This breaks the local style of always declaring variables at the
beginning of blocks.

