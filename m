Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A519ACA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 17:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077EA8E0009; Sat,  6 Sep 2025 13:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0273F8E0002; Sat,  6 Sep 2025 13:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58858E0009; Sat,  6 Sep 2025 13:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD3CF8E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:19:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F16EC053C
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:19:25 +0000 (UTC)
X-FDA: 83859486690.17.6DCC60B
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id A758820005
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:19:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g/lQ3zxu";
	spf=pass (imf03.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757179163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/VsaAZE8BZZcz6ps/gV/vx/aBIFb7Atd0DyuiuXeeQ=;
	b=F0iFAtwogUeMUznVZfAN2+8f8E/BSm8t2423DZBtQTjW8zAK7Qrprru/60EDBdykaTL0eD
	ibzBm5YOVY/8VwN9xIQ8+5kQw8YFJBQ9BNLuTiynVSUvnipw34JaMy2Kt+ma6lN9gZRGPz
	zcu/LOQJaI99ulV30pQjOGCJ3Q7SrVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757179163; a=rsa-sha256;
	cv=none;
	b=526DUIyL/k31FuqfFTKEIswZGdw44WCdB4ABJP+AKvAHPk4kP/D0DMnNSQy0BN7hJFCZ7w
	EOqdd+fLh3JZbyXb46Y+LAGLbxB6jvZ8HXwHyVSCt6o6qQ+zM6WxoS/1tJExTQ/buxm6AU
	NEZdsL+Foqv80mIXAzgq7mYPaSjA08Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g/lQ3zxu";
	spf=pass (imf03.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3e537dc30c7so1145599f8f.3
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 10:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757179162; x=1757783962; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/VsaAZE8BZZcz6ps/gV/vx/aBIFb7Atd0DyuiuXeeQ=;
        b=g/lQ3zxur2SJ2qVBs79OZCFGyx5rgPdf9RqDJ8cSQxXG0dFYtglS+awLc/GGthPhoC
         vv/udW0SSfVaaPBPQzsXY3yZErfozdRyCQWY9rg3LyTyEHNbg95YX99XCjPPcHe8L4a9
         kNmTshj4vWrjpsKsQpwsRH7yVbNBTp6bk85fom97Sd+1eLLR5VjIGOXyGUxi9zkFVgQB
         m7XpVyIM89phBp8DvorsJujTwDjJiy2L1c29epVk15E2RHcWOtD6BA9YW/GTK3wb2b/s
         p/offFzpwpYv5bUwcuYhHQwinY6KW89KI1aBsg2DOjykql3mMjVfye9CzKqxCAvaFVOS
         +OWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757179162; x=1757783962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/VsaAZE8BZZcz6ps/gV/vx/aBIFb7Atd0DyuiuXeeQ=;
        b=OIR/RKltuqDcRCl6tBHC168eGKMC8i3HBwT1uxNspb6FBZkxcElq20QNijXekwtVAj
         uUkXABfEQX0X4QghqbhJRST5g2FjsDh4lxUOp7Mkqe002UUgLT5PeBk8CEF0zZRLik9M
         KZpKunPfDsqPY4Q2yOVpyKdN8QO0jYDDXLZUYZbBTJvP5ywCfktc3yUGveIZGfrpjBbR
         bfuStzczYDvwK5khKC6fFegC1/FRMBJgh8o2Kbo8jIJ1bTNR19yJ0BhxvtHpbHuoCsiV
         iR/D4yhYO3wY6VEySBbFHWEFdzBCYVuO7QEXw30v9NLxFMfTxe6uaYEdPqNDcMLar87l
         tl5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxW37BwPIArbemljaCY34Zp/fEV93PE9dE3lpMKunyrnqfr8c+6m2zDa0XdfBjPHvONnphr9nSXQ==@kvack.org
X-Gm-Message-State: AOJu0YyF/PiHn9rLBIIphduoQB/6QIOzuPn6IDr1lvyPcnPtVKQ2jL0N
	+N/GgBFFbPCHzGy9Ib8+f87KI6v9r/bVBk36AjK+b6OHBVsJRKjsuOqHQpR3vf5HqZNxcs/maOZ
	iYwIO8EEg3pOx6Oa3FPLezWTX0S4OREk=
X-Gm-Gg: ASbGnct2hjpWzgXWSd2Ud5fxNgLLB1JchrWV2z2F3ChzlG0gH1jpNRIFByM+UAcvxyF
	0gKjGJ6X6R9XI2Tt5/5ZGukPQZHUOKQrqwhoRUXBIOP8qYaPM6xrkKeTGwFv6Tso7NA9OpX2zR/
	A0qTW1l//0OrDsnkycP3xVBBGSZ04IkULeecTvY9P5F2l2i8pzeHjDQ7BEM3Fhxatlt8trVf+ZT
	L6Y1Ut6
X-Google-Smtp-Source: AGHT+IHwMXVmgCNboW6n0WZeFTHhba11a2SFsS8Zt9OQUQAavArl8kiQY3QwMXTXdNAssOnQ/PiGObbIRc/kxueWvOY=
X-Received: by 2002:a5d:64c5:0:b0:3e5:47a9:1c94 with SMTP id
 ffacd0b85a97d-3e645e858b9mr1560400f8f.49.1757179161926; Sat, 06 Sep 2025
 10:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com> <3339d11e69c9127108fe8ef80a069b7b3bb07175.1756151769.git.maciej.wieczor-retman@intel.com>
In-Reply-To: <3339d11e69c9127108fe8ef80a069b7b3bb07175.1756151769.git.maciej.wieczor-retman@intel.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 19:19:11 +0200
X-Gm-Features: AS18NWDcebDXZ0CncnyAGPmg6m7DGHRQKjrUi3A45HP3A_5pPACdVmuNY1mdCAs
Message-ID: <CA+fCnZedGwtMThKjFLcXqJuc6+RD_EskQGvqKhV9Ew4dKdM_Og@mail.gmail.com>
Subject: Re: [PATCH v5 18/19] mm: Unpoison vms[area] addresses with a common tag
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A758820005
X-Stat-Signature: usodhdx69ham3cme8qdos4t5d3bmrbix
X-HE-Tag: 1757179163-666166
X-HE-Meta: U2FsdGVkX19RWxILJ+ZKAYT5zJ2ek4XV+Zmrx0TjviYaLaBhBuJkOBovGrAwMshDwZ0/wjNOaINlVZ7kGG3YBUnFNRvS/XvEzH3zmnks+6imszYOwPutDKINXCKHmJZdT78sPts0bd9HF1OGAHsLDsn9r1erQLSyylYFI1RwPWD9hR040JQEDHyuadTmS+BhWj9Q1S+Jr2O335UTW5UiBhSpfEemE0dUN8WFs1wa9ozzwlzaj+bJ9BORSYB9lmb+bE/p0MwB5cVewUubdnWVIxSfKlL2weXWRvjRSg/KWmoAVuZrmVs4SedcftnDqruMgM4I68sRn3L4Ex0HzcN0hixtCmvshYrD1LcKzvksZXGxqu4SzFkbiOrSJMLuWaQrik+Ibw9wfSHEW2TqH5PkYzJhy+NOTqFVBLiWF22W0VeV8/zJKusZl5G34U34OlVojIC1z2aXo12nCacnHO9usedqSFvcXMhKI4jJyQuZYTWL3o97+qfq8dry7GCgYoYeXl7GcA+kmUc75clgRxRpm3uxtQO6JOgpSghH3vxaWiEEYCQYxRGEvO1nzkXemyxJeodaTg6O5dJMPFTxpW40slAqiMTw22/Dg4AQpf96qGb8UxfPeCHYbMpeQMvTgyglt6jo80MJHv1p7zemo/nj+xgqblTvhyCZKBGowIVrXC6YUPwpR6RT3skflzJYgxCjOfB3N0du88Qo1kJeiE1bEKBhCnC5s5TPbdXEe/cFTSfu4h3+Of/qc/M9u4wTG2rXB5iSKqOQYeyYrHwEDbc0hBRipFUk++OVKIrlBx51BrG63eXpHpjTD+gxWVjyIEOb1TS0s/dldv1yyQJkTxxHK1UN8wpH8Np7Pt9RIgQdmIJMkFWSt++CH7g5kuhkqBa65yzFoUrjUPHUlPnMpxelUOnit2BhLASGt25QRxK8kg8eS+VQ6LFqqOzsXgfRRkS2Gk1ILcx3AXpkF9zRnX9
 mE93HTFs
 GbNYvMy4mWjml676YwSGNbqzGSbLcEBXHF8AuO36xHUtnv+BRWLNGdLIwQFiwmfjKIy9pV4lmjmbzbhOUIxkcKnVI9LyesdkrphjgNwc2WwjrwfTD2J+ejNLwE5G34SIfCJZi/1KQNnVcumrPm+To18q4GmyRSW99Nfp0xoP4hNzVZVbK1xKBgOj8U06zVnNxi/XwnmxX6lNC6gUqzQ3ge1J9VgElxniZr36UX6ZXcg11BKsXZkMr5qTc8oIdgWFy3Sib2maHxnfcspe11jMlk36DMLwXSwZphfzP18p075RctENKRu3a2cxFNUuYnjWr6TXZulFovQrN1TeGSTagNlJ9J1balYcbH6O3HClSOAfZ4Sy58jm5Ytz9Zz+JwpsqmemN/cQDxWqabdHgjMstclMtDBC12SA+qS4SOVn2ISTUysFJFxfT8g0zYn7mx25grpkxpVYWQsiyTBSlPwp+k5IW++QpT7/i9OdKl9KlAL8uMgo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:31=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> The problem presented here is related to NUMA systems and tag-based
> KASAN mode. It can be explained in the following points:
>
>         1. There can be more than one virtual memory chunk.
>         2. Chunk's base address has a tag.
>         3. The base address points at the first chunk and thus inherits
>            the tag of the first chunk.
>         4. The subsequent chunks will be accessed with the tag from the
>            first chunk.
>         5. Thus, the subsequent chunks need to have their tag set to
>            match that of the first chunk.
>
> Unpoison all vms[]->addr memory and pointers with the same tag to
> resolve the mismatch.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Move tagging the vms[]->addr to this new patch and leave refactoring
>   there.
> - Comment the fix to provide some context.
>
>  mm/kasan/shadow.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index b41f74d68916..ee2488371784 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -646,13 +646,21 @@ void __kasan_poison_vmalloc(const void *start, unsi=
gned long size)
>         kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
>  }
>
> +/*
> + * A tag mismatch happens when calculating per-cpu chunk addresses, beca=
use
> + * they all inherit the tag from vms[0]->addr, even when nr_vms is bigge=
r
> + * than 1. This is a problem because all the vms[]->addr come from separ=
ate
> + * allocations and have different tags so while the calculated address i=
s
> + * correct the tag isn't.
> + */
>  void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
>  {
>         int area;
>
>         for (area =3D 0 ; area < nr_vms ; area++) {
>                 kasan_poison(vms[area]->addr, vms[area]->size,
> -                            arch_kasan_get_tag(vms[area]->addr), false);
> +                            arch_kasan_get_tag(vms[0]->addr), false);
> +               arch_kasan_set_tag(vms[area]->addr, arch_kasan_get_tag(vm=
s[0]->addr));
>         }
>  }
>
> --
> 2.50.1
>

Do we need this fix for the HW_TAGS mode too?

