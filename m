Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF20CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEAEE6B00B7; Thu, 21 May 2026 11:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B716B00B9; Thu, 21 May 2026 11:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B066B00BD; Thu, 21 May 2026 11:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 877DA6B00B7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:50:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20E87C237A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:50:04 +0000 (UTC)
X-FDA: 84791863128.23.13D0877
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id EA8A0180012
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:50:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J1P8R7hc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of olvaffe@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=olvaffe@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779378602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rK/n3Tw9QL4BRpAx7ZBlVNDycJ/XQb1vIqALxMVgDtk=;
	b=Z79B3xwT5kcqZd/iG6rrVFZtuLGhhVFsLMgQf+GyxrCn5BaGCK0kshpe+Aj7Ct53By6a0F
	Q8uuvFnZpXMGXDoKmm1XTCcF3zfipSj/mRNSATg+gzhkW/Ngv4XZRI5pImCXTLVFipCSGN
	yCUEiKlAR3qbErZQFUJVY8T878kOE+I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779378602; a=rsa-sha256;
	cv=pass;
	b=yJ1js3EqXytizWuZGFf0dBNfvsyJVDkL+cVlYQBKJ/bvedot2pK4r3z1Chqj225H/k18fH
	GuIcjJ829j+3tv/25biUK4aKx8hvdBFchAQBIfGzs2Y+OjFjDtof/n6l0l5jMr4YBhH4f2
	snGggddvCcdIWoVfNxX0JMvAoocsmY0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J1P8R7hc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of olvaffe@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=olvaffe@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7b6ae2ea4a1so63106497b3.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:50:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779378601; cv=none;
        d=google.com; s=arc-20240605;
        b=liQxzNig/r1tSY6TLBSryu6ReeDjyBLt+r4izgGsy2I4gD9NTkIlJCz9VGwz3yXPvs
         jz9Dumz7U1TFtXJmWvFcjf+AHRpBiGmsYkDill41gTn3ZgQbbfeTeky6ssfMc3s1NVwc
         ORTGoatRaNXMjOGu5DgYpTXfbVNQhLMarSF1+/+4ajdGtysLl/9bKS6HHmcWbJRi7c/E
         bdAw+9cb/jPJXngmRqK7eG3gxGS8Rql07OBHa2/dZyd2hXGiuhW+zBcShnOl9R9QaDM7
         5mwxQDz3/01ITwCPy0nK7W6fDG72XqNp+tfdZYcf7fsSin+vzJXkTFUJPPGFWwNtJXkK
         ysiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rK/n3Tw9QL4BRpAx7ZBlVNDycJ/XQb1vIqALxMVgDtk=;
        fh=0TK4XH+PHmUTowOI5k6Mk/RVQ73eJ+yQRe8yriKaEs4=;
        b=k6KX26IZRP90fEduf/N5oQXdD2du0fifalHZk8e5YmUu8IJqTxdc+gRe4sYkqWCK3M
         TQ4S3AwFzTOeVK7OYS8NWjCmXrqfUdpK8gDvLJaI0XsyqHmacc9gGATHM33p2AIHdAl0
         3QF3UeKK5GCGAPtkWhGTyh3oTyez3kYFEYrR2jcabw5WYGJ3TKn08jz1p8PqFLUGcr+e
         o+PBo9fE+Z3UFqkmRCThPu725quPfQnCd9P6wcTsMmsTHVNI6DKuub8LQYEWs7MgflLf
         iOvTqtaKVGJFjylnHcskwbjR/zYJ7lHA10dXggeLlnQHkb3gR+sadj2XppKMrCmGbB80
         6Rzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779378601; x=1779983401; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rK/n3Tw9QL4BRpAx7ZBlVNDycJ/XQb1vIqALxMVgDtk=;
        b=J1P8R7hcWdcyBr/Qy2UkZrdn2ZG2CU+gpK2XhYBo/E8TqJYSNWM577qTjDVYQXljb8
         5S/vMdAot/0npAQ9nbgfhgEBWwV/rZPA5s60lrtCqlkJStCeIVOnKW2A3hrg4ybQOyJR
         dhbDpo76XPbwm5SqWWqmsAVI0DPcn3yBy9izkqqAIRi/SMmhE8nS1oiiXYbE21ioz1wg
         0mEuslctEBkbKlVMuysFAv5n+dW9dXrsm6q5xBobjG9I3XCoMMzz351QG5xAPC2k1udG
         FeZ/DDNsPCF8IFWys0DLf3gOslnJwH7lLNGzKDuj/GJP5k3ZXDnAP3kfON/Qppn6CGDA
         2gew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779378601; x=1779983401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rK/n3Tw9QL4BRpAx7ZBlVNDycJ/XQb1vIqALxMVgDtk=;
        b=H6J5WvmwntKiHSuzKNkfXBVsnhfHaXAQ4+Df0gPfJTts6X+FLqd6srgudRHoV1dLhf
         PC3BPNNetflYoNlUKjaR1m+Gzbwq+mQtGlPLXCYaxnvr8aRoJyb9kWR2oTIDRGqV2Jn8
         HykcSCYJjdE3YOqmQleHG75YKNvo0UpCXxxo7czN4QPZIKC3wXoOJj2wQlrdxKu307vP
         tv1k10kKyDoNKa5faPF1SwElzAl5pWlXTuMboG8apaEunCrWX6Y3EqvdO+QGGwipSU7a
         uAflMXOB7APVYRtCx5lItxlynBjdmoaZj1rQjB+XKfJm+Pq3X+TiIegnZVeiUMWhpjw3
         bKpA==
X-Forwarded-Encrypted: i=1; AFNElJ8UCVaDkBws6zTKSH9tmLW/uBAcBCM3gXdpFCW50uX88er3lWeg1T6lNR6s0uX9iPw6ADk0k5Wp0Q==@kvack.org
X-Gm-Message-State: AOJu0Yz6o6KwBDsa/Cg2VYmxeCgfQfXl3C/LmrLOgrB1RZLOdKWsUSFr
	PTMMod5qfjPgdS1vJo+w1ePMhzzGuyc1Px4cMLaTTSZmlinEkaZBUAX/M5ZYX6OX4w7liF2BBE+
	y9RVnGRHIVHjMR2A1VL7t8u3QQdG+WJ8=
X-Gm-Gg: Acq92OEKpQYXuAe7aNE2PNorb6YrNLNwFvP9M4lCvpaiBOFcHMs/pbG2+g8PDXbouS2
	UGWWBMCyJfNqhsHzgXtskC/En6mJqQgVv9rRiZtmiAvDtj6Xe1sHLRFDNLum2uVIk2GenetRJ0z
	Xh+pgpuNmmGwAACBlHOHy7T8PYm71IeKFE5OQh7me4f6qaEGyZJkE/wFM+eCnWhWtddY9qAtyXs
	ur5OPuudK65zZjHL9QvHIIaGWgly0p4QIGhU4H7rL8s8KvVOpfLJmVu/a5JLHJpJEGFzTjS8p20
	Wgu8VxMe8QyiN2cRTKWrHVBs6s+VExln3hu7oN4wEsfeJB2o3DMv7QmmcV6S0y+Ypgdbs+ai
X-Received: by 2002:a05:690c:9688:b0:7a6:1df5:c99e with SMTP id
 00721157ae682-7d20cc3bdc0mr37614817b3.30.1779378600877; Thu, 21 May 2026
 08:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260519-panthor-kasan-v2-1-b7384458f076@gmail.com>
 <72bec63c-09f2-4a97-908d-3e6af8e3e0ae@linux.alibaba.com> <CAPaKu7S4JCRiTyYvTgXHKP9osH8yh8YVzXiPQuNVAV9pBZtmuQ@mail.gmail.com>
 <aa244c61-b936-4c53-af7c-2f5190867a7f@linux.alibaba.com> <20260521105148.5497c281@fedora>
In-Reply-To: <20260521105148.5497c281@fedora>
From: Chia-I Wu <olvaffe@gmail.com>
Date: Thu, 21 May 2026 08:49:49 -0700
X-Gm-Features: AVHnY4I04KE5Ndy5vtunnW5UXTC8e0QBnXh_a3MYPZJDIKwPgeHkkIxwjMReSjs
Message-ID: <CAPaKu7THqu4=rN26jtjNS5EPvSTzfoMqG5n4bZr_3Rh4ngSvqg@mail.gmail.com>
Subject: Re: [PATCH RFC v2] mm/shmem: set __GFP_SKIP_KASAN for swap_cluster_readahead
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Kairui Song <kasong@tencent.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA8A0180012
X-Stat-Signature: uphb14eq4ypzqtmdkinurefb6511sfje
X-Rspam-User: 
X-HE-Tag: 1779378601-595139
X-HE-Meta: U2FsdGVkX18cnGDYpwys+Kwr/Zrox98jj4nk8+thZd3nxm5MPcggUKQs3l3n6X9EwlkrvVx3eW0JjBQcujlTrcyZKCiVZPyTK2zw6qklOgta8QupMZBUHpiy3QTvxpD1K4TiAoEfA/f+/Ql8Zn6cTo5/BllUv0sS7EQbza+ARKbRZgVPTZWtYcQM1pJbaLiVDRHTF2NaUF1dUvfSKm7FpncfBriVnpdFLDoCRye9LSh/06f+46AD35jYBHPvG/dO2qQN8IDCitu77kS/+alje/BR1qBWEQV443uLeHRLwp1XimjT3gaiKtHpFF6N1eXM3wiHSnZMGzUEadsyglEU3Yzy/ZHM7YK4oyFx2b5bWaGGeXMhEd79NaBZeTcQdbz7VvH3SVSZneR8P4lmWQjfdiQ3hETkJdDpE3lsz4ZLDh4Uk6OCUwdyDcxveJq+Y7SrpEbzgnmwDlsdMeFFasfP2reb+yAlClnitHosBV1RSQ79XkygDpLY8iyKL2PZZ8ywRRy9OIP90ppoKvLEuYffvdtRw3/lcl+Rj2isVZgAJxboIkh5jeHWp8fbuAasCyO+RV2G3G2XVNUT2i9dsYMZ+N8X97luJZkc3QkQbWy9telWkbFcvEVVP5AIi4BAmF3YQ68IuyRg7je+/lTw/L+HyPmPmLwW4ls7SqwTPAcSDcq757QR7VKFChUWoPqv8puQ29sQB6ueT3C+RGy57L/3Z9L+9HVd5LeGAmCh+0sR8l3XorPchqmcwTG9Xgw13vV2NvAdgKSW1TQc3hAcJiH/2e4ao2WVXY0i5rh2zKXx/U0NUcNRVZ3htpAry1r3r+gou2f3NQY93YqBrT853Z93XQGicFSSbhvnRUmLvZ43DbLVVq5ezbIp7P7OJyVN28swdVVaMvb+BXvoLc0R6PVGc8zWj4qmzDXpJB2RB6yiKQK9/MIcish3RCfdaidXESTRvOaJXZJjZRFc49yD5Qm
 rIilgXbE
 kI1VhD2PllsHABqxq1sidFYHJrnJorPoe60IEIzmBwn+PyjnpoCOZs3yagTdazjwEEIyHzxP2tw3Qicrv9wnG7hAZXCa45yjfsRi5hfqfhFkA6zekDia6fVdZAiaT9YoLoc59hd26hxgpBdata0YmGFyZH7eqibDlphNMzdtc+Pz4CMc2BcfKfOMlySP/QWaX9zcYcS+juf+S7to3Htdo+tGGXxAJVPXuYWjoxiyr3rLow7KmgY0wJA9peUo+P+K54Gis9P973Jgz9ytpykYTkgrMsHXpi18T4WT2rvLj9Fgx6UP3VdNHIlOwdD0cciGipHQotQjCBsx9dcn+A0oZT/+4f/dwtpUdXhnl+UulJRrC+GJzFCYNMtM1Wq/CKgTAnhU9uKDkqw7xfK4B5tcyYIhSPjX6a1IpwNPsmNijEbt0zU8wBGgqQwsyPaVZVH65eya8LcPY5Yy3zPOZe/hnxwMQPqo5qNjjpeS0n5siS3GEqo6zjQ+kS+DZVE8zTCX1XeoL+STKQcPUx3mpzYYqwiCxEgyhOC71XuyJzW4VKcsIYXRt08K/cdsbVnSj18FU0Qt61urruYqBYdLfYpcOB5gf6QzcHZHoYAIUb+6cPtpdSUUB7qrOVeDPAJ7TWwDM7bCA/zr3eQFOY+YGyBi6G+581NnCQ5eodlCy36/twKoahFi8TSNc7huniMidyOY1oryupZJWpzOxVFKHFXVaiHhqvj6Q69UF+AZQk2BlC9ZX4oMrlU9QpmzxEISIZSRPQSpnU4vnVooLE3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 1:51=E2=80=AFAM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
>
> On Thu, 21 May 2026 15:05:21 +0800
> Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
>
> > On 5/21/26 1:06 AM, Chia-I Wu wrote:
> > > On Wed, May 20, 2026 at 3:04=E2=80=AFAM Baolin Wang
> > > <baolin.wang@linux.alibaba.com> wrote:
> > >>
> > >> CC Kairui,
> > >>
> > >> On 5/20/26 12:31 PM, Chia-I Wu via B4 Relay wrote:
> > >>> From: Chia-I Wu <olvaffe@gmail.com>
> > >>>
> > >>> swap_cluster_readahead can allocate folios for other mappings. If t=
he
> > >>> gfp flags do not have __GFP_SKIP_KASAN, but the other mappings have
> > >>> PROT_MTE, we can end up with false KASAN errors such as
> > >>>
> > >>>     BUG: KASAN: invalid-access in swap_writepage+0xb0/0x21c
> > >>>     Read at addr f5ffff81aa71dff8 by task WM.task-4/6956
> > >>>     Pointer tag: [f5], memory tag: [f9]
> > >>>
> > >>> In the above example, because __GFP_SKIP_KASAN was missing, KASAN s=
et
> > >>> both pointer tag and memory tag to 0xf5 when swap_cluster_readahead
> > >>> allocated the folio. But the userspace had already set the memory t=
ag to
> > >>> 0xf9 before swapped out. arch_swap_restore restored the memory tag =
back
> > >>> to 0xf9, leading to the mismatch.
> > >>>
> > >>> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> > >>> ---
> > >>> Changes in v2:
> > >>> - set __GFP_SKIP_KASAN for shmem instead of drm/panthor
> > >>> - Link to v1: https://patch.msgid.link/20260512-panthor-kasan-v1-1-=
d8d3e275d71b@gmail.com
> > >>> ---
> > >>>    mm/shmem.c | 5 +++++
> > >>>    1 file changed, 5 insertions(+)
> > >>>
> > >>> diff --git a/mm/shmem.c b/mm/shmem.c
> > >>> index 3b5dc21b323c2..db9130a8c5b76 100644
> > >>> --- a/mm/shmem.c
> > >>> +++ b/mm/shmem.c
> > >>> @@ -1784,6 +1784,11 @@ static struct folio *shmem_swapin_cluster(sw=
p_entry_t swap, gfp_t gfp,
> > >>>        pgoff_t ilx;
> > >>>        struct folio *folio;
> > >>>
> > >>> +     /* swap_cluster_readahead might cross the mapping boundary an=
d
> > >>> +      * allocate pages for other mappings. We have to skip KASAN.
> > >>> +      */
> > >>> +     gfp |=3D __GFP_SKIP_KASAN;
> > >>> +
> > >>>        mpol =3D shmem_get_pgoff_policy(info, index, 0, &ilx);
> > >>>        folio =3D swap_cluster_readahead(swap, gfp, mpol, ilx);
> > >>>        mpol_cond_put(mpol);
> > >>
> > >> If we force __GFP_SKIP_KASAN, would this cause issues for mappings t=
hat
> > >> explicitly should NOT have the flag? and your v1 link already mentio=
ns
> > >> this scenario.
> > > We lose the benefits of kasan hw tags (other modes are not affected)
> > > by forcing the flag.
> > >
> > > The other mappings swap_cluster_readahead can affect are anon
> > > mappings, regular shmem mappings, or gpu shmem mappings. I think only
> > > gpu shmem mappings miss __GFP_SKIP_KASAN. That might not even be
> > > intentional, because gpu shmem mappings pick GFP_HIGHUSER over
> > > GFP_HIGHUSER_MOVABLE to avoid __GFP_MOVABLE. That was before
> > > __GFP_SKIP_KASAN was added to GFP_HIGHUSER_MOVABLE.
> >
> > It sounds like the right approach would be to explicitly set
> > __GFP_SKIP_KASAN for GPU shmem mappings, no? I think having users
> > explicitly set __GFP_SKIP_KASAN makes the implications clearer than
> > having shmem core set it implicitly.
>
> It's a bit of a shame that we have to explicitly set this
> __GFP_SKIP_KASAN flag when we select GFP_HIGHUSER though (means a lot
> of patching to do in drivers/gpu/drm/ basically, because basically
> every driver relying on shmem for its buffer allocation uses this flag).
>
> Also, it feels like KASAN poisoning for these pages would be interesting
> to have since we know we won't allow MTE_PROT on userspace mappings
> anyway. Oh, and some buffers might even be kernel only (no mmap()
> allowed), which makes them even better candidates for poisoning.
>
> >
> > We could also consider adding a VM_WARN in shmem_swapin_cluster() to
> > detect any mappings missing the __GFP_SKIP_KASAN flag.
>
> If the general consensus is that all shmem-backed allocation must have
> __GFP_SKIP_KASAN, yes, it'd make sense to add a VM_WARN.
>
> >
> > > I guess what I am trying to say is these are all user pages. We have
> > > to skip kasan when user pages can be mapped PROT_MTE. The
> >
> > Yes, regular shmem mappings typically default to GFP_HIGHUSER_MOVABLE,
> > while GPU shmem mappings are a special case.
>
> They are not that special, they are just not MOVABLE because the GPU
> might also access the same pages under the hood. If it's assumed that
> any page being exposed through mmap() must have __GFP_SKIP_KASAN, why
> does GFP_HIGHUSER not have that flag too?
It is also about whether PROT_MTE is allowed. This becomes a problem
when both kernel and userspace want to modify the tags stored in MTE.

Another way to achieve the same effect as this patch, but is more
explicit, is to have

#define GFP_HIGHUSER_SWAPPABLE (GFP_HIGHUSER | __GFP_SKIP_KASAN)
#define GFP_HIGHUSER_MOVABLE (GFP_HIGHUSER_SWAPPABLE | __GFP_MOVABLE)

GPU drivers that can swap should use GFP_HIGHUSER_SWAPPABLE. shmem
core can warn about missing __GFP_SKIP_KASAN.

>
> >
> > > justification for gpu shmem mappings is that they cannot be mapped
> > > PROT_MTE. But if readahead can affect non-gpu shmem mappings, it seem=
s
> > > we have to either force __GFP_SKIP_KASAN or to cap/disable readahead.
>
> I'm no MM expert, so it's probably me not understanding how this
> swap-readahead logic is supposed to work, but the whole idea of using
> different flags from those that were requested by the f_mapping seems
> fragile. I mean, this comments proves [1] it's not the first time the
> problem is considered, and I'm wondering why __GFP_SKIP_KASAN should be
> treated differently from zones. Yes, that's an extra copy if the
> SKIP_KASAN flags don't match but the zones do, but in practice, won't
> we have GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE in different zones? Or is
> the problem that, even with a copy, it's already too late to restore
> the flags because they been overwritten during kazan unpoisoning?
arch_swap_restore is called just before shmem_replace_folio. It is a
bit too late right now but I guess it is fixable.

But shmem is not just a victim. It is also an offender to anon
mappings. We would need a similar replacement logic in do_swap_page
for anon mappings.

>
> [1]https://elixir.bootlin.com/linux/v7.0.9/source/mm/shmem.c#L2112

