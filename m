Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80817CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 21:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7C078E000B; Thu,  2 Oct 2025 17:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53388E0005; Thu,  2 Oct 2025 17:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69288E000B; Thu,  2 Oct 2025 17:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3F568E0005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:43:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59C9A44E41
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 21:43:14 +0000 (UTC)
X-FDA: 83954500308.02.F7F6A62
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id A483DC0004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 21:43:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cUUjo54u;
	spf=pass (imf10.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759441392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lPcXFzKT5wVu+oYSVpByRjAYmnWsxgWqvNHhKj+wPuQ=;
	b=EauJ29k11E+eN5YtjQNXf3Hi5P1tjGS8RYiV99CItROZXzYMVsRQZJwtGIqrIih+DqrO1o
	ihlaMTZrPuCrWMQrp5un78cOHWkCtPKE7lF9TkcnYBXnaokviCH2ecIo4Nb/lO4RqlM+RX
	HEnKlvISCPe8TWgXm3syHPUyxmAmuyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759441392; a=rsa-sha256;
	cv=none;
	b=6cbQgxO/DXt+hcSl5KYdisCcJ6BzvBdLW5i9tWTIqJj4BfDTLYCM4zgyQV0eC/00T5l+KZ
	q8dp+EtK5tLaCeQ7qWanm9C8nTzi5S7YF15Yda1K5B2glOJUbqo2GeBw7uGxDfM6R9a9K4
	qacJfk0gtegXQ41FfEbS/ax3WsPYoIs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cUUjo54u;
	spf=pass (imf10.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-269640c2d4bso2173235ad.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 14:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759441391; x=1760046191; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPcXFzKT5wVu+oYSVpByRjAYmnWsxgWqvNHhKj+wPuQ=;
        b=cUUjo54uvStxZAt/srKE8JDpcDJU+eBZ/51s8gHrQ5Bvue3mfb9FTy/hv5WoobKXaV
         9mwvtsN+lW/jegIBhI5U2x+YN2nBU0e8SGjZ5ighTBdSTMk80tgx40QclBiyVinDWoZY
         EndrmOhQf6zKxPbYpqEc/xogvdJfsxOlT9uLKB6KmvE+LOfZP8INRut/+mT7UWBzLPQq
         mtPUGPf6Dpy9m9kDzriqyJtau7RZw84W1SD9BGfam0r6qYg3PPzXPbwNlb0URAk1dsyP
         c42MoUDbUERBxVnMKFakvtGZsegf6gk3b0Bm1RDqcu1dH/DdQ+dr/j00FjiBaTB0DSci
         NHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759441391; x=1760046191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lPcXFzKT5wVu+oYSVpByRjAYmnWsxgWqvNHhKj+wPuQ=;
        b=i+IxjEpJ1A1T8PGhYBgRg4CFJEE2qIaEzV24VShMbayXqLZF7S+yYTmP99oJGNfs4f
         d+/4xhoRJFcTXxxQYJZ8Whrl9syhDo3wm28af/uCkCBnyEeCGUts3xdLQpBQ3l0thnWI
         RZCqJxO9g1GOctjTu8RbcZy6GYAoj4QE65lWcUqUfwInYctSKwOAAW7rFghdIdav7W/b
         W7NclcjZ0eSrQO/TLX2Fa6i7ebB2C6T+xNKikLHUgsQMhd8k78k21kpl0mxJbuFSSRgH
         LqhirCgPzp7BrLFDFVLpr9Gf8qyy10DhnbtsGN+fWfDog05Bq4g3o/WGqEg68AMkvBSd
         PxUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg+s21GcM1Y7+ua8/fwiwmt1m9D+gNfHK2Ym0YO9KldO+NovtZLS6buV35icu+7vFa+fAq+TroEA==@kvack.org
X-Gm-Message-State: AOJu0Yw4JUbYN5o+dKWdOuRx3YPWYE0HLuE0ArO+wvyPG2l32tW4N3p5
	xuuOHE5LAdBmHgPWFiE5LpU7KhLAug9r2gUVVAzjM9fOZBKTzVD7Z8WhDV2JYKJ/AFHwU/ABu+d
	1cbZb0A4sJ/878tY1JcXs49BcCS6EFDk=
X-Gm-Gg: ASbGncsD3mpInIiPUEer6RyVjznNjMgxtsdOaUgk0DMcAiYx0vDMRw06kbnpWqWFali
	4d/yGdvuvg8BEehS8po02HlW2ICqEx+js/bPlRRrfWfZ860LBmsYDELl/Gg/0m6W9SKCl8GmNDs
	br+xEWcqbUHW/NEFDUlTi/bmRXkplTY2y+cBYVbE6u6NSe47KAJB/1aGmoHAXwNByjNhxxldiiZ
	Hp5aJ1DIBzqNgCW/VeAfxtNMeHy/aj0EsRfDMXjureYVJsNI8fcUvlnXE3ZRtMT9mi2HjuXPSaz
	PWSskG5VBfgFNcfxZM7ZGi8UM8q79PU9EuYmlZkSg+gRwSV4+A==
X-Google-Smtp-Source: AGHT+IFZzSxiqDHj6MHdqyQ1Q1hdzZXvFd6lioB0p3uh+24Ijmg973MsU4BcCXMws2SWUfETRmGWtCjrkLphe1TQaL8=
X-Received: by 2002:a17:902:d2ca:b0:288:8c30:f08c with SMTP id
 d9443c01a7336-28e9a5d22c7mr5070435ad.2.1759441391458; Thu, 02 Oct 2025
 14:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <202510030449.VfSaAjvd-lkp@intel.com> <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
In-Reply-To: <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 2 Oct 2025 23:42:59 +0200
X-Gm-Features: AS18NWD7b1CZpOPQhwI0Dn5y2ltKsgZ6GaZnx5tlIYsi0bLzqLKsPKXfvkSWyuI
Message-ID: <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A483DC0004
X-Stat-Signature: gb9hacoge45m77j68mtfisxtbxm41hqc
X-Rspam-User: 
X-HE-Tag: 1759441392-486506
X-HE-Meta: U2FsdGVkX19zd4go4Zc4my+csSt24+tQsCCHHpgqHp4WpkX6Gt3iuC4v+PjtAY2ZGP7otg0Ww1FRX19xBUMl4Ge2YNgwLKrI6Nx13BvJKgKwR7AMvHrgFdjR+btKetKVHCTg36nRqnVRM06RoLCFCwGcqRR9H1hQrNukCQkq/gGQnJKDkBumiu3DtcpAIVA+Q3D/RxhnvJftVxaG6I82ruF3RoFN5GNzDjyq4RncIklyp0EnMtvV0WOC/ifxSOyjtmFMlOZLZC5tHzYhnT6NKDszznBhmgOinFnODM10Cywcsai3IkGQOyHxoJGrw2jtutsdSArmASviLdyiutCvDWDtFqk4gejj7sql48dCO9Arfd6EmbXP+IZTaP1KcdC9LiQv5jLOQ1ZdqOvbGGL9kmlI0qtmKw1GU6C/FWKtRNm1T+xJG8e0NSd8XH8/H68xWYpNG9w41q9vzEl48ao01VvoFNuTF9Mj4eMk2t3p3Ms82dY/1BKwqqXNwVoy89/rYMfBwnd20ceiPVCGF83o1k0/FyKZhpzODTaWHhT95Vo4OcDrevslaX3eUgkqZG8e4n0MBZT9m+Orhyp5dFya+1RQ0dKup11rfQTnhlQs3feDsSHUXkGvfyARDnVb1SCVSl+8l88l8IN7tMBhJuVDJtGoi2RQwtUWs6rBuj168AiYSI7A6NUGGMFYLoojhsZZmrywhibR0diC3KxpGGUCi/bBZgj+gJlUjxWhgCjcmgv9/59HiolOapCNYeXf7rZBdxmmLiTtPQQ3sTKOnBdtTfI4v0RiBOuKgluIQM8p2w7Fdnv31hWji2iGZx2G7IMxUBM7Apu+gbSgSAYkEcgWmrCBD1Kxmbod4ofFTitiIyc+HDmgy54E5B9P7qXXl88oyEseFnPgkTiyWTN5jDhbxQqoLm5KAnZSoxOsqVAOxb4VT57u4bte19u+lCDnvIlGTpOdQKrBRd76lp78ZUX
 +iMef0NN
 JEorwXIzmAjzFLL5z7o8axok9dYpmGvYmqg7hh5THEgDY/r7d5EPmufBNBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 2, 2025 at 11:19=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> No idea.  Let me cc rust-for-linux.
>
> It's a one-line patch:
>
> --- a/include/linux/mm.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise
> +++ a/include/linux/mm.h
> @@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void
>  #define VM_MIXEDMAP    0x10000000      /* Can contain "struct page" and =
pure PFN pages */
>  #define VM_HUGEPAGE    0x20000000      /* MADV_HUGEPAGE marked this vma =
*/
>  #define VM_NOHUGEPAGE  0x40000000      /* MADV_NOHUGEPAGE marked this vm=
a */
> -#define VM_MERGEABLE   0x80000000      /* KSM may merge identical pages =
*/
> +#define VM_MERGEABLE   BIT(31)         /* KSM may merge identical pages =
*/
>
>  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
>  #define VM_HIGH_ARCH_BIT_0     32      /* bit only usable on 64-bit arch=
itectures */

Yeah, non-trivial macros confuse `bindgen`.

For the moment, you can do e.g. [1].

Other times, we have changed `#define`s into `enum`s -- that also works.

I hope that helps.

Cheers,
Miguel

[1]

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helpe=
r.h
index 5128e2f12038..918f4c74067b 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -106,3 +106,5 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =3D XA_PRE=
SENT;

 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
+
+const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE =3D VM_MERGEABLE;

