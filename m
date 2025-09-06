Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DF4CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 12:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39138E0001; Sat,  6 Sep 2025 08:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2AF6B0007; Sat,  6 Sep 2025 08:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1078E0001; Sat,  6 Sep 2025 08:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C01806B0006
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 08:57:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4291A85D31
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 12:57:02 +0000 (UTC)
X-FDA: 83858825484.18.FBBEDF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5D7B1160007
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 12:57:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HgAXVKHZ;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757163420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWMVRXks1rLqkDvQiFNTKUdHQ/+BHnhBPzzUSGVSoVA=;
	b=l+kQ9zmmLn9JvJmS22v2UZZxqFfy/7zA2EPsTkHFkEB7CkyMgPD4EYz8LPrbShxxhkoC5w
	7BLH3/xvt2KdE9qDcB5RNPrqm9+GAd10Oy4JEhfG53vgIRjPWKrCwBdF5nqvF2QtUCFNIY
	ajHNMAv+ssUUKnOPUjd8hvSrlh5LEwc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HgAXVKHZ;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757163420; a=rsa-sha256;
	cv=none;
	b=FSJzZtdQse5orZcMO3kmMbE5XL/LawHEnJNB9iZGUFzpLoGp6WlUvGdGe2WPgXMg82ZHxB
	62/10kdjKaa3Aw5B7zXzAUUBaM4tD7zqKQpbTR0a8MfT0htGzNi+k8WhE8cecCaxeVDqdH
	BCbadi/HrRRGfIICHWthc2vQq0A8E6E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 916AD6033A
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 12:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDFAC4CEFB
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 12:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757163419;
	bh=2+CbUHoB1zKzsjwROR9vhcpkdWtjxfGZ7lHc4QKUz2A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HgAXVKHZI2uQF5R5wdjGujNMhMGfRg2iGUWbfmM+FkTMVXbRJ4vsjRJ94XBuNJJzt
	 jaZvmDbb9OAQxcLsrG+19FSXf+gAtVQzrc0+qUYDwew78EtlHNOXmLSeFQHHZLdfI+
	 8PLrGgzZ0xibG6Zni2Xg4XgIOUTUdBdd4pgcHHRlV1GAcM5ZMW5OWDexMTvFtIHemX
	 BdGPz0/MstRjr5mJFnOPBvH1CYURfKIBxbvSCindkzzGouVNxg54TiNaUEPF6ZzPBr
	 LDAeFbRK+qQeQhY5Qa48ss9xtl6jlY7cP5uDMnhxCeygScKUeYDeF2j33g5ZYTWP4D
	 IEXJfJDAovdSA==
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so48135e9.0
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 05:56:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUHr+oTCkfnQpfzZfPYSEZAjz1LSmWBXqdDa7E3eSalp+k3XXghosuEItjwbkFCVNCK3BpdIbo68A==@kvack.org
X-Gm-Message-State: AOJu0YwucaCthbuNtnOOZVNxg9iQgcLBe/K9+vQCEoj/IgG6VBu6gs6B
	XNd4RPQjp5NfOUGulEzSU+oCV4SNhsN4eZplkVs8sfrTpsZoIQREciPkGwiDO2kiA/icDp3pHmR
	3d27p2h0FWJVIh0a4xChygWdnaM9wFx/syeas2tZZ
X-Google-Smtp-Source: AGHT+IEfNnKp45M5qcJUuL7/qRCjDosf5G04QAshQBHa3kDT57AM/PVPd+iJmcobbRI9DLXVVHkKzrE+E8Z9vBogcHs=
X-Received: by 2002:a05:600c:4f50:b0:458:92d5:3070 with SMTP id
 5b1f17b1804b1-45dddad796amr1216725e9.6.1757163417539; Sat, 06 Sep 2025
 05:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330> <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
 <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330> <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
 <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330> <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
 <aLRTyWJN60WEu/3q@yjaykim-PowerEdge-T330> <CACePvbVu7-s1BbXDD4Xk+vBk7my0hef5MBkecg1Vs6CBHMAm3g@mail.gmail.com>
 <aLXEkRAGmTlTGeQO@yjaykim-PowerEdge-T330> <CACePvbXAXbxqRi3_OoiSJKVs0dzuC-021AVaTkE3XOSx7FWvXQ@mail.gmail.com>
 <aLqDkpGr4psGFOcF@yjaykim-PowerEdge-T330> <CAF8kJuPuOWUEMg6C9AnAA-mddgHRjuMVqURrbk6bUHxAmEvgFQ@mail.gmail.com>
In-Reply-To: <CAF8kJuPuOWUEMg6C9AnAA-mddgHRjuMVqURrbk6bUHxAmEvgFQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 6 Sep 2025 05:56:46 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNW2kmxKYRE9t8WvSOad9JkLYt0WSAcFOQ9r9=2=XGc9Q@mail.gmail.com>
X-Gm-Features: AS18NWCEh99GxS8T81OQ6NK4C2x78uuoL8QD9vp2Gdy4X-qQSM3YgnmgvY2sedw
Message-ID: <CAF8kJuNW2kmxKYRE9t8WvSOad9JkLYt0WSAcFOQ9r9=2=XGc9Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
To: YoungJun Park <youngjun.park@lge.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com, 
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>, Kairui Song <ryncsn@gmail.com>, 
	Wei Xu <weixugc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5D7B1160007
X-Stat-Signature: 6jjr9pna5zdgmxim9yitinfbfibi5w44
X-Rspam-User: 
X-HE-Tag: 1757163420-286670
X-HE-Meta: U2FsdGVkX1+bOfA65HioCo19KQJwZEYN5bTtgJJc4ORVRLHNSGvQ+KEZhvrKuqhttQGb6Uslxb1mR7K16dz/7i3SVs/2rcnm+Te0dcfuJ+bmgCszvmidAyOUPTokIGGx23Ujx0f1kwM1IxmptqWAr+f92mjkDuSZdp+pGLwrfSHKID2Sc7qt3/hLjH27XZfvBULlcZVVcDRY73f2fAzDc7ph79ZiJj+pag8am4escaIfWk614RAdCkQvQCJkNcn6wygufTfKKKn7cxEV7F7p9dnt1FAJ9S2gN1KNsn7BJg49OVbDUhcL/NbBmVGLNe41xwpqYizqmje8jhh1bT384cyGTuNtfTiaBSthghL75sM2zzacsEup3bgaZNJpfhIey6E6dlBK7+4fR9KwXFTusy7Fob4w1H17i6i2gWGtqN9XAznW45hwQJGucg5jyNeT2KXB013U8nGgXfrqWTj3RZ5SdsLuCSbvLakGjNl7EzWALp95gcHG94n4GjeuDi76K6Ljh+2u9OKx0+EBquU0Fm7b9SW4KFdxkm505+11SM3ZiLsUzVGFtcHv/IJES4GTRzVTcxQRtsXxkbBEpLk8x2RwaUv0QQ3EjaKCipLPo4yLLVlsXAO7uG7pYO4mdXrgdXQaPIrYtGrdDGsG4qyB7Ho8oatnOfCSmoa6KfeX68+CtQtQ3qXzOSx/uEUsOvhGuPrkOZtNdSrrzY/Oih8hkiM+Zm2kz0Bfz4r1f2h0TlXiH6djMC1f5hiRIXa/uHjCMYqOC0Vf+Tz0JgpVzP+MCprtPSrCTmAzOml8Ddnc6yiGXQ6FVupnpyJ2pHWNqFks3fVdtrWlANAAsW8L35CmrsE2LrdEOrRr+ED7Pl/g+VuMs8kYFEgxwSbGzuaI4gx5rtIWma8iVcdMN5RhEmPXdLh1Ipes5zUB5/KjKzD8rPbaVsRt9XyKdop9xetQNyVBEqhJJH2RyUNrEJ1yxVL
 qLES6pIk
 5bzrgxUM9RsZixHWp2wXsHZ4M3hYJRTa/dxtLUPfRv+AAvps9qdfZ1ImAib+G0mJ7Hf6Z1AoRVlcp38HZ0yrm1/2Ns4xPKG7+INLWyVFzZzKFjW6wwlXMBj6HVk77RHWGfB7IzISqbDd+dMA7hGPKosOLYe23fvmR6Mg3n8x6TKLy01QY6bTBIybxyGuTSeA5AYDEOAdrWuAqOnxybFYTU54ZI3NN9SMsBSDPec0qyJvPyT2RCdh206CC0AywdxC9NFZUr6rHAa08dmWlEDgNFwV9PPqeGrEBQGY80PtCyKFm9BqfPDM7CTsG4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 4:45=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
> >   - Mask computation: precompute at interface write-time vs runtime
> >     recomputation. (TBD; preference?)
>
> Let's start with runtime. We can have a runtime and cached with
> generation numbers on the toplevel. Any change will reset the top
> level general number then the next lookup will drop the cache value
> and re-evaluate.

Scratch that cache value idea. I found the run time evaluation can be
very simple and elegant.
Each memcg just needs to store the tier onoff value for the local
swap.tiers operation. Also a mask to indicate which of those tiers
present.
e.g. bits 0-1: default, on bit 0 and off bit 1
       bits 2-3: zswap, on bit 2 and off bit3
       bits 4-6: first custom tier
       ...

The evaluation of the current tier "memcg" to the parent with the
default tier shortcut can be:

        onoff =3D memcg->tiers_onoff;
        mask =3D memcg->tiers_mask;

        for (p =3D memcg->parent; p && !has_default(onoff); p =3D p->parent=
) {
                merge =3D mask | p->tiers_mask;
                new =3D merge ^ mask;
                onoff |=3D p->tiers_onoff & new;
                mask =3D merge;
        }
        if (onoff & DEFAULT_OFF) {
                // default off, look for the on tiers to turn on
        } else {
                // default on, look for the off tiers to turn off
        }

It is an all bit operation that does not need caching at all. This can
take advantage of the short cut of the default tier. If the default
tier overwrite exists, no need to search the parent further.

Chris

