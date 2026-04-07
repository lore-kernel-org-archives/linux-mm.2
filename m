Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A30FEEF29
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88AFF6B00A4; Tue,  7 Apr 2026 08:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862C26B00A5; Tue,  7 Apr 2026 08:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778606B00A6; Tue,  7 Apr 2026 08:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 672946B00A4
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:31:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39E1F1A05D5
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:31:55 +0000 (UTC)
X-FDA: 84631696590.20.F26DBAB
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2C3FC2000F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:31:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i6gWYOb1;
	spf=pass (imf03.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775565113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iUU8aMOFErMYOti7jC2g4u5xMdEb2bSNbQ3uRpNgOQ=;
	b=VVMGGlHpNXUgxISBjc8sD+KdMHl+NjmnF6cr7ICH/RoDufhNLpknJl4t++TVIF1bGVmFih
	RV3vRG+7gMnAAL6s3EJ/bgvBz9Ynkwc2uT/lcaY3R88IqtbBj9O3xl3iz1x7+yUq9VpRgP
	iabdaUxQbRARwqMpEa3iSmvfyHqIsjA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i6gWYOb1;
	spf=pass (imf03.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775565113; a=rsa-sha256;
	cv=pass;
	b=IlqrhZ+TLH4cf99eKMoiH5jNxI6W+amJ6+Iz3ChkHoCYKSB/X9HjZpqB92qqH1bycf4phF
	PAgURcc50Qshc4ALGDfza8X42JLtbbekajkgXfWgzjS3FhjbSz+Xd6SAeyQxeYT7T0VosD
	s04ngnobjG7R/RpttChN7f8T2+hPV8M=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38de18126e7so32132361fa.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 05:31:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775565111; cv=none;
        d=google.com; s=arc-20240605;
        b=dT6mnWKKgQXCuToAd5fTB9hBrHWMMr1bY1NRHXTYY6cJxjAGALJ9Z+LvkAuQ26VwvC
         NCbzGDKhSy18iTMiuigIsfCkJIsw1U+1SuPX8c3gZo1SISwZS8FthiNeSEZez0H+MqBY
         y7TDjoiSn6zI8vIyU5lpMwWxmTLuaKlTzXycRZA2vxi1VXCHGTj24ytwMh8IMI4ja9x5
         6OELqm3rrxfTstNWnKewlWc+CeBZEkUyKg67uLeTyShj5Z4HQjjp/+XUHRyvqE4tMfrB
         6WHTJGAj28x4Ny5zpK1xBiAPZbXI9axiLAUCr6GSg0hWcosSj4deWXpAoYSv2/tCiar5
         iz0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8iUU8aMOFErMYOti7jC2g4u5xMdEb2bSNbQ3uRpNgOQ=;
        fh=df67bixamv/KEC7el3pxBcAfMXfO95/uwNYez9SDGiU=;
        b=JkBEeLKsCQf6DuvlsmNrrXzRG15z3kp5El+zNgP69FB8Sf1NkuBOqlaN05cNSu0rkL
         rWy1G9u7FgntSYtp+fSrHoIULLrPE6j9H/OFnSB+E1DC8KmuDRYQHvyiADO2C78bbEy1
         uX/mcuMMFhb4vrtaYMp9ct+qb905yRfoymQtzfJQ/16+q3d6Spt5CftfD3yY6r5Sv2Eq
         68SiZgtr/XzwwOKtn2wNvfzS3euzPPplhr4S00m1JXJGsTZSdnwpFQ5N3+JMC9yZDRs7
         xtuJQY+Zd4N+hn9guCCgFIOZzq+kTBjEnuUb0AqiYecicGACfKj4XnUo1OdH8FfoUyER
         wcYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775565111; x=1776169911; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8iUU8aMOFErMYOti7jC2g4u5xMdEb2bSNbQ3uRpNgOQ=;
        b=i6gWYOb1Nier1eWRn2vNFex/RLk0LuD67QBoTMPM/dW6FlivNLa97kLZ1FA1PJFuOc
         thKIhUyhczIRqCdJ/xTOWv24E5phHQ9pMC6n0/Pp6WyIMFoajbuS4zK4vGGofxOyUa3u
         WEnO0A1rhz1aPrNy25Im/Vd0xdIG/2XJwU0ZxWKg2cFuRJytKfMpenwws58LDYQoyi0T
         x8d4sHpyf2xpZtwekwYBQdnyLRc39j1pIAI6KCyfwP+pq1In04imzV7jlawnmvya+ZaE
         TLszKo2kT/5659QLCGfWEseb0FhpLTTrydFSvPnWX0hpzNuGdKQ3th59euw/LHLvoEog
         gpwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775565111; x=1776169911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8iUU8aMOFErMYOti7jC2g4u5xMdEb2bSNbQ3uRpNgOQ=;
        b=jlOqLLpPH7K75rTAAuzG27vRUsBr2httHJslSyYurSbLs0S9VuieUVKhEtlg+YCct/
         sBgdfsO41krrChbtIue8WeZQ77qYW928vPj/UiEqTUfSuFv1Z3YWUXkUCP7SvVXkGjTj
         tOCTqwRxnryDywwpzzD/Yxzrx062+EOwZfCs/gzHboQxyz07C+1i5rh76KUgM/LlyeZw
         cT7ex9CB1NUHpttmVTjePP6mFeRdmKf22E43pyy+SOS7mu67GbbDooEWD8Xft/0+jrgr
         RUnmUO+DWDC4hixOMQhDnfed/F49F+qjk2bhVKj0CCSw0wHVvfZ8Uih3Pv8p1BvWtHKB
         aEVg==
X-Gm-Message-State: AOJu0YyLHMm/m03h75X0FpfpyxYahMpONSXS4wnecaa7XQGs5kSmY0VY
	H6+YkZ1fwl9y8lmp6JQtSvePkWimvPHeonXORkLXxV6grhBGCA1rOK1nQaJ3wWPWOwk7j6f13ZA
	R6/GgAsHgBOGDHjg8ec8KE6pC0pTh0fc=
X-Gm-Gg: AeBDiesa5sENdG8VIoEAbnv79xXHJ6lS/VhXAAUsRYGjbKeGdfLRSFbvBAEMBqghuy7
	K4pCprYxw57S67XfAPayeULWYgOJMwJeCg9sZ0ahIRha6LceYMZRUuQqPkcSMQMGwTPHVQBHJei
	99fs3Q10b+xWyPGlZhrI1VHkNRcR1y9PSgM1bR4jdfXUpCrHjfneVQrs1VYgp0w5f9HHRT5lHKi
	0g84kVfoFo9JcYsCWzQKKqranwoC261kg1JeQq35MrXWhLyGHgkD0pWrniZoJl+YSY6oCffZb7J
	W+GW
X-Received: by 2002:a05:6512:3191:b0:5a2:c9d0:16ba with SMTP id
 2adb3069b0e04-5a337560ab2mr4510281e87.16.1775565110709; Tue, 07 Apr 2026
 05:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260407110002.204755-1-wujianyue000@gmail.com> <adTomi7uPYJebAMD@tiehlicka>
In-Reply-To: <adTomi7uPYJebAMD@tiehlicka>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 7 Apr 2026 20:31:40 +0800
X-Gm-Features: AQROBzAGh6n3Sh61uJP9khgvDC6OCXS_7zY7bDRj-3X40pIrdXVLfXoHgiIYReg
Message-ID: <CAJxJ_jjFonN8m1YsGh8FjMBbiociLiXzE=tS2+=Or4+PnTPr-g@mail.gmail.com>
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	david@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org, 
	bhe@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C3FC2000F
X-Stat-Signature: 4khmmhwwjri6pq9oaxn7n4wa93ju6ohr
X-Rspam-User: 
X-HE-Tag: 1775565112-268287
X-HE-Meta: U2FsdGVkX1+ROwTh0/RwtEE1gzzCdHBhdrkZhJqtS5v4o7iwsCj9k1XLDtPnZmmbUdHMHfwoumv1QJ10s7MJjbppG4yqwZGq79QBFhhu5IKJNWMclHHIoK8jVwi1vT6YofJX9Qyx0oudi6PZML006hfygvsohMnffsgIFYyjJcNhVFi5igPdIl55S1Jtx0UWfRcKQmelrRdpvfaRMV0vK6SiN3kIDTOw0FeUqNY0b9M95lah3l1YVFL4LGZ//Y+daWtP2C+5biwdMY8SJMLoCdwoJVm4uf9wriFgK473iMpMPiNo8ECmIyrgyZHibisHoeeZzTLe/DBcHZ9+ll/96sfw2VosTXYSShobSVHWcePjrkrlu/otngE1pXNDNkQ88dmkUOHUH9ILxuOduWEZUPZTJV9WvMbJTCAOQ+JdXRgWiJ5BCbN4mEuPnY1NDkxZIb/Vwdk02klS5okur3gIDDgZ/HgLPw0alh2LFlnxfCGbkTXBjYsR5peUrtvGtXbk3F83Bx8UEfJvans+DoDcFyWwWZVbg1hubXHaFYXGX2eAW8x95NNSaLA+5iHsLUgWfNhK7sXjzLziQ81+J1jKoE5Gfcd78nKF4aCm5SXETSXpgwH/NI1rAAylLTdkBX/587sZY90rfxQ1ltTzLYOicAcMSwDxLtGafjU707ggMUkZtAtoEbMVjHPtaw7cwBxpj5zwAXZ6j4Okepf7i/qhay/6AgRRt0D0xoiXQjGSUtFOqemjf/mZpsiRgMWQ9ve35tyCBgbcO0MCpKl3knLzFcbkkck8nqglG6VYY4MtvQRUnfpI4+hkHwq2T0OqZYYVD2OoRHb9XGuzLMEmuEnIXy7I4nbvE+mOcY+Tf+YxmhwJ+0GVGjtKJhZxUI3XaqTdZfN656MROlUpGzV0QE21tvcgrwkM3CMQn6fshRAFdPaxy+yqy4IDO6nv61nT+ThOKcqNUABKcoGzJkHF0v0
 xllcS491
 hnfIaBwrZYsk5HA3A3mKuBAUzQAHMDCEbPZ9kbcza+2ZCgyQx+lZt7YzFBYLssQK1ALDlxYoUisHyQHoA+KXzTj4aeFOCkrhV0k33JpEO3scXFqDxRshf2LehJs9ewqvOTBAvwMr94Y0u3+mhqx4RPnEqU+PabOZqud87fLZWoBuRm7n3q80Thx+FB1eMnmenaR51Wc+0XpSEs4Gca/NCPUa6Vh5nregvcQaz1NYGPzPKfn3sqlv5svVUkZFcmIoR5hcY2hGTBzEDCMcGxQ2Gps0gof0w1hVDt+ROBAroAnMhynnftf8r492gdmVwr9czRZuCOcNqq4qxU2If2xKx10awXaN+u/irML/eS1CqO/BeQ/sCJuyqWdV6o7ahNDM7sTJYWIT0SpKiitB9Ybbau29rnN8WG4of+mF3UWzuCQIW91eCfX5JYsuHKWeuTwASwbYm6lYPGnfMKDKYVpxbyyeLuRv8LBJ+6aYR1+N32RiVyXKqVzVS8K7wDUJWrnc/9LPA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/2026 7:20 PM, Michal Hocko wrote:
>
> All that big churn is really worth it? Are there any other reasons than
> "not so appropriate"?
>
> Really if this is not a part of a much bigger plan then NAK.

Hi Michal,

The intent here is to keep generic LRU/reclaim helpers separate from
swap-specific code paths.

The LRU helpers are shared by both file and anonymous memory, whereas
swap.c is meant to host logic tied to swap devices and swap entries.
Placing LRU code there would blur the boundary between general reclaim
and swap, and make the code harder to follow.

Separately, I=E2=80=99ve been looking at routing zram=E2=80=99s swap-slot h=
andling
through swap-owned hooks (e.g., swap_ops / swapon probing), which would
involve swapfile.c and swap.h. That=E2=80=99s likely orthogonal to this LRU
move, but it=E2=80=99s driven by the same goal of clarifying the swap bound=
ary.

Best regards,
Jianyue Wu

