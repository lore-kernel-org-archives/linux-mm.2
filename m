Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD73C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF0D6B008A; Tue,  8 Sep 2026 03:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F5D6B0092; Tue,  8 Sep 2026 03:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9376B0093; Tue,  8 Sep 2026 03:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 092696B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:35:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 939E9C0394
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:35:40 +0000 (UTC)
X-FDA: 85189785240.26.1EBDCA2
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf11.hostedemail.com (Postfix) with ESMTP id A0C7040004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:35:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=paDEHvk+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788852938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEtwck+GhzVGnuAmeYI6QR28xLrnmqSNSlv9PEkxITQ=;
	b=fC4Kd+i5NqnNRQSsYIaiiJ+/lctdoX6uCQ8KVPIZ8MknLs8leqHW4NjnwmdKfYGmeWIQum
	R01g4t0XriWw1mWq0YTNnJ5Oxph7hWszFB3/HTQAb+RQjO+hNZkvCfmsPe9CByWPUdrmfs
	XVp2GDW2V36bTSw8kRo85dkP5gbb7R8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788852938;
	b=pyJRuxdZEbOvpNPtoQjWouOZHB0vOWENw8lWNHEtROiIaDWYAEdBSe/vswVWWR0FkCDF5h
	jbkUk73LUpFthRzsj+etcjsoIcVwcLIuyLxofZ5Hf+Jnl5HyuKR2FPaljQVpx+pLmEjEwU
	duRUEEdip1/m+LzU5BkGYZVOdyHSSWY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=paDEHvk+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482e1b30c94so261180f8f.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 00:35:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788852937; cv=none;
        d=google.com; s=arc-20260327;
        b=qswiSym9tNHg9wR2wyjPrTRU7f2z/L6JYX+aT7zsInIbNM97I3xBQejeZ5/j6unQxX
         MPVr9F9CY6/p2+xyrmea8LrP3Yv4+NVSetnnOFmhy2zNT0gti6hZC53tRHaDbXj9qlsK
         75bxsCP1ii8GTX0PBvhsObsGXQ9N1Swlsw1JqlRdTV7JURVkK9Fa1g1hHNAlwWN6Jao7
         QfpR9/xQvMzt5F5kdefPxFmvsAKC4IsRfMeW3LbJ8F4UZWg4dN5ioBEwWLKTqE5pGCwK
         wG/eAoqmjl++JsG/2njbQ+k0a+HI67M/NMCqDIb5po9nUzRllx5j1JjHYtbnRh9qvhKa
         SG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kEtwck+GhzVGnuAmeYI6QR28xLrnmqSNSlv9PEkxITQ=;
        fh=7qTqa0NfLaHElv5AH+mvkX7o1YFOTBXm5My7ARWBRcw=;
        b=T5YQ7xDM3a8EM8NOpOVVLk/vn+aXpx8qAy7XObAzZ4WZS2tx4lksfBTrrUrFtllnF2
         Cytq7OrplXWxAFwo29nlO4kocKHwm+u3qDj+IjwXk1UkQrZI8U4xawFfeuupHg494Gso
         6i6whv5qSfKwHY3FLKvAxHQ7f1WxvKM/MHyLW8tbT88J8tcZaGVR84aySc2UMXF1Oq/q
         s8l1uMrvbVlsSZuC+qfKuODGYgcuy2t+g9e1X7dnnKhYu1gth6Ma1KBeet2loyzhIzH5
         922X0W2ZI9FlYw0WA6/aryxeMA3YGH/MFNLg9S1osqbn6j0K7dAKCPOHwrSbV2I2rHHl
         cc9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788852937; x=1789457737; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kEtwck+GhzVGnuAmeYI6QR28xLrnmqSNSlv9PEkxITQ=;
        b=paDEHvk+Rxu/99ndbbUTZ8jU45M9SemyDzmDmSC41OImyUIqbRxZdZM5g++6O5nIL+
         OlCSal2dWJyPi14me8vUx62hbSRBC+hWAeLK+KSguBLhYpdESYC2eHQKivj/RCFjGmlz
         8VfSFPYc7uZtbiMB+OWSZrbWOWibzkcu3lHlj/drRvDmMPGKIF1ytsGBQK7viIEVFAmC
         RkW4nPmnZ9bLz/6/6I9S2N/WQ38DAZdFfL2bpJJ9hjludaRqiq201ncvPn+cpes4eq5T
         KT8U2UFHFVX88OiZNiyh7VrSKIoXefEqsCe4VqZIQiGXfvSXeKFcb4JtQcTWP3Y1/YLr
         FKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788852937; x=1789457737;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kEtwck+GhzVGnuAmeYI6QR28xLrnmqSNSlv9PEkxITQ=;
        b=aLBv5J7YD7JkLP9rSOcktORNz46P7qe3FQP96jIhkuglriP1QqKcD8f9h9qchRTP3O
         A/Rsdm70FaRib8BSZWtd5IcdZhfvOvkzMYbqEWSvYfpuy6MVVjRwVjQ+1jDIcIGJFN5V
         1NCTySsz410s+1T6dysepc6DAm+3GnUd6lA36GgBduU2rzX1ob37Q0so/AGqTi4bZHIC
         yVBFOByVQ4c/RbekZYqGk+XajveF6EIoleyu5dntuAf2vR2cHZTR/kqRvPYdTp6H5ndQ
         kmmLleADYsGMyp4SV5KpRzHuyuJ354wcwPgHnLaIntPbKEg6HoMls1w5B6O13qPq2cnH
         3RSw==
X-Forwarded-Encrypted: i=1; AKwUvBxatv+2oEqhWB27swv2MFZXsaRK7rJHE+At7O5QqPp16+hCoqogyooREG5/A4DUotnQeYHqxzBTZQ==@kvack.org
X-Gm-Message-State: AFuF++murhuxxAwc/mAetQ2Ziq52WohADHVc886i9ybia1CCTNn7jY1T
	bnKSwX17JQaANeDV1UUHDmygCnn74WGC/Q7i09+Lt8MM1/S/fUTTwU3F8ZpC6M6M+We/r4UJXRE
	AQX9q1kWNn+c3FVrtStT+d/g58Hk6Vlg=
X-Gm-Gg: AYBFou39eK4wmQ1wnipHZwJ7tgsg4EPDLTx5PLGaKCy41SeMzhdHNb3DGKEmp0hEZF8
	B+QbRWQ96+xlBkrTdbk3mx4jfg7XO9qUuXO49nFLn9NraanqkPh+almjAdWQwSdec3C8tuFHicf
	iwJ/M/xl3V18Gq+mRjSo81R0rxdgLHbmuGSszyMibx0fDTfK7ZfsFLSz00UWmUl71kCBFkgj7St
	q3+Pw86w6MKtEpzY0EWjh5dBPN1XdqZfPgRvXVdzH6gFxm27/t209OjFd/DANHrc1ZPTRc5XBCt
	ja6XbgAHHTw+pA2HYlTCv5Fmzu7LTLN/qW9+S+CzzWjmhJZ33kBhP6OF3eO0+uU0iur0GlbK6B6
	/zPQxdtpE/CGew77pXJREFjol+FVkfA==
X-Received: by 2002:a05:6000:2610:b0:482:ea38:6b80 with SMTP id
 ffacd0b85a97d-485905b6dcamr17746950f8f.1.1788852936749; Tue, 08 Sep 2026
 00:35:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com> <apk8ZRr6do_YAlzf@kernel.org>
 <CA+qSx6wqd5VSR=9yarFFmyN1SyvLJqEHpA7BwmzuxNQTHbS=Xg@mail.gmail.com>
 <ap05ue1pq3TgHOS6@kernel.org> <CA+qSx6y=OaMsvTKUbPP2DOan3Ym6c8L5z60512-tCYeUjLZz3w@mail.gmail.com>
 <ap5Tqu5yswJrj5UM@kernel.org> <69db9546-d14d-4107-96b7-30963292c2bd@kernel.org>
 <ap7L2UEriz6DJfif@kernel.org> <2e8dae0b-d81e-4c5d-b4d5-c80bde07a314@kernel.org>
In-Reply-To: <2e8dae0b-d81e-4c5d-b4d5-c80bde07a314@kernel.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Tue, 8 Sep 2026 15:35:23 +0800
X-Gm-Features: AcwNN1WRh9Ejy1a6UjKpBEjkYuP25njGh2x0QoOc56jCCHUBW1sbsWwyKaUqbMk
Message-ID: <CA+qSx6ybfqMMNKkAwVgcEga4uzFixXYKLZ-D8FuXmjXpQ9zExA@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org, ljs@kernel.org, 
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0C7040004
X-Stat-Signature: a6n7xmsxxe1ndoz4rwgdbkug6s5yt4b8
X-Rspam-User: 
X-HE-Tag: 1788852938-467545
X-HE-Meta: U2FsdGVkX1+ZX15Ic9tit2g5VyuCJf3xaixAWs2UUBKN0wXzsYkjDrM9ws1rEtrbURJ+7fA5wcFUisSEhMxcfzIUTM34srOGHKtQT5cWAyBIsd/GuWpqklq64G6vN1SSTueOCHMckY6JoL9JFCQuuUAWdzF9+tRcFGZdGmrY4eTQ9nRI48xgPnDjNK6MGEDPudUV652MQqrfB1YdwxMACuQAFv5y2gj4tTK2R69BxHRriYWNiLQElhnzv+uYIbbPGxc1HsR2fxPAAw9A6QVkfWHoJPwuEIr/ZfgrDRKzHFBtvPebenOWew3b8/xWspDISvtkszE8tClmUZqMe0mKGUeUxJGRnhiJbkmf0A0PTpC4W4tWLFQZrt9k5VMxBSW8xgWFAODRM6QRY5fh2XDcoIsbaUTPsIdM7X4TvjX6FT3KI2g1yivj+LW8QrsQwC6wzfWJh+haCNYr0aNOcnuhnLjalr0cH07nmXzFyv9fwrHErOqeUbuA0n7E7FY/88Vu/KaH/3V8doDf420Tag1Cwnoa4JGipcuqNtzznG7BAxkgnz7DK5V5a2ooS5f48E+jJ2vuBOLF/oQITCRcYNLhZysTpM9VUU0mAtwsQ5Lpe0Ce9ik2OuezWnTfv9WTRDRd4yjUMnZZOs8DZR7YI1Sk540daGzYf7fPYhBDxFxHuRwfJixPw0gT0gWWfLC66lRXW0PeGhj6u4zpty7jMQa81470WsShkxoWZD4RMCuSQjcUDX2Z9rEG4eHsyL3ORwAoho+Q8Fxwho5yOshzvgzaHAbVfLvv3JeHhy18Hf9u+uobQ6eIlW20WBEpXzmWzkmhRNSlCr+E//I8CBUODp8cBOpuo13Kp0QJ4HCL+oCzaemtCGiN1FNn0fYVlwpZQq4l7uyZsWSL6IhYBTRozSry4cxL7RT3xx5eLLDnhwj/KoKDtCz45+Z34vKv0s1cgZwJFLI8WnHZ1wIiPwQGHlK
 Lu83JNLN
 xT4kWvhKUVO553H6csE6F6/QyKlpxR9X2ARo7Q26x+/CVK6VDkapBOtcu2GHsWmdxKpoWY/Dik1b5RmaXPXMcrleOFkXENLFds2weXoxdB6Vg0MLzUjo2H7W0DyzCchsdScKXfTSjZVJq5oZhHotRtkxYKa+9SNHRkFXBcDAAVmIHGFkEe4apOcuo49Y8NEZclNURMNyFHdnMBmZzoCTHwy/FJC3VGnYVTYIjhxQo6pbp/F/2btmncAoGvOtGViWKqDzYCH1nxUtdzC4bJWpUMXA2v4S6UDQlBe9ztg4Rh9Bs6D4eu8lyZ1tdQMWlD7z2XkazbZxJ8dQe1qSOhV6uqmiG7Z6QwcccYaJ+dCnRj9LOx/vapehjzLuhnSkQOxl8UDASxajZQ5D5uzvEsoOogzn1F6qHbhJOJ8DrYwTV7JgOas6q6ecfjVJY4OI3O2V6NR9Z6uTOuMkj+J4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 10:48=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/7/26 16:36, Mike Rapoport wrote:
> > On Mon, Sep 07, 2026 at 01:18:42PM +0200, David Hildenbrand (Arm) wrote=
:
> >> On 9/7/26 08:03, Mike Rapoport wrote:
> >>> Hi Xueyuan,
> >>>
> >>>
> >>> And I believe this is an historical artifact rather than necessity. F=
or
> >>> configurations that allow set_direct_map on arm64, change_memory_comm=
on can
> >>> update direct map too, it just need to be implemented there.
> >>>
> >>
> >> Are we sure the other architectures do what we want in their set_memor=
y_ro?
> >
> > It's a zoo right now :(
>
> Yeah, that's why I'm asking :)
>
> > Although most of them do.
> >
> > But we need to sort it out anyway because of increasingly growing deman=
d
> > for modifications of the kernel page tables.
>
> The question really is whether we want to use a single interface for all =
page
> tables.
>
> I quite like a page-based directmap interface. Other page table areas are=
 not
> necessarily page-based. It also expresses which types of operations we ex=
pect on
> the direct map.
>
> One could, of course, use set_memory_ro() internally to implement
> set_direct_map_ro() (and similarly for other variants); but at least
> set_direct_map_*() would have clear, well documented semantics.
>
> >
> > I started something here:
> > https://lore.kernel.org/linux-mm/20260721-generic-set-memory-v0-1-v1-0-=
2c1fc62306b3@kernel.org/
> >
> > Now that x86 CPA is nearly fixed, I can look into the next iteration.
> >
> >> Having a dedicated set_direct_map_ro() with clear (documented ;)) sema=
ntics does
> >> not sound too crazy to me.
> >
> > It's not too crazy, no.
> >
> > Still making arm64 more aligned with x86 and other arches that update t=
he
> > direct/linear map in the set_memory_ro() seem a good thing on it's own.
>
> Right, but I'd much rather user set_memory_ro() later to implement
> set_direct_map_ro() [initially on architectures where we made sure that i=
t
> actually does what we expect? later maybe generically]
>

Hi David, Mike,

Thanks for the discussion. I'll keep the page-based set_direct_map_ro()
interface. :)

Thanks,
Xueyuan

> --
> Cheers,
>
> David

