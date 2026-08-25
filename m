Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FDB0C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B826B009D; Mon, 24 Aug 2026 20:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C736B009F; Mon, 24 Aug 2026 20:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614296B00A0; Mon, 24 Aug 2026 20:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 377A76B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:19:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0BEC1C0F5B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:19:36 +0000 (UTC)
X-FDA: 85137883152.18.D3F2D7D
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9CF6D1C0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:19:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HlJoFHZM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787617174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zI08/Pq8IYiYHARKiGwzqOQw4uoqAVEC7og/atFPetY=;
	b=bSRDmV8DPcO1nGsGoE4irMMOY8qYg8EWxtZKi9UAkNmXc++tkcssNhPNK3Z4cie/eRrGxl
	MwEh5anHYQasL/+Ety0E6OFk0Wr1KX8OSrpX9vMgTs63Fk9SA2Eu5I4X51+/Sg9dYAnlIo
	X2uERYx9Wxf5DEVsUG5fAac/c4ZUKPo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HlJoFHZM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787617174;
	b=H+WLIsRpnKkFqe8hEr4hO+ImQqV30yxORPDPNSdSpu0qSBnNFGdlaav1181bAagxPmR59F
	ED2QliQFU3uQmMqSUtGX+CtO+zLSf35rAgkBjclLPO7GNBvWeQAmvOTFNnX5hplNTokvxq
	E0mKptLFtyaTOSsNya6bS35DwBa5KjU=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c20fb91ed0fso638356566b.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:19:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617173; cv=none;
        d=google.com; s=arc-20260327;
        b=WlkpoGJujrVVOK0weOsvbXIxBj0UCB8zwsrjUl7FOtpbstKVf3qiLwVEDa611eO74H
         nTFOvQMLvbtw4dBLzCdYbY9GUY+x0bLM2ZLXwl+f+VBKWN7+22Nkmp8+dku3sXzFjQ+D
         SrNnXD6KoFPpDtGvN1BXhtFd/jKU7GyObqZ6wI+/pp+RqoXJ2qkVgwkAxGpVA33sa9nY
         jhhDJRHLvN28Tf5S43Uvn562R/BP4c6RpQ2CMX6weSTnMEhUqwFTIjC5DhN/xvRkio3z
         r6qWDEZxSC6T8LtbpAggeoUpaZLMqgcC2+4tY64wUzGFIjks1Ml556Xem72uDOo11vdj
         QVqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zI08/Pq8IYiYHARKiGwzqOQw4uoqAVEC7og/atFPetY=;
        fh=bhCmn7VKbX8dBPAYI9kKB/keYNnh1CPGRTGjbFRttv0=;
        b=I0ybRBlSZ111DJLcK0qf1LeJBuy14Z0DzvyUBZxbmUjB0wehkpj2MKr6ZirjgnQauE
         hNN2QSgzUBVOYibIP5uORwF4FxHC0QdqjLW/U9+ipuUFD1gETG+9BdY9ljW6VVlVg6H1
         ymlcdhPpzGJyEFmlwmXFl/ZYazcONsichkZfzJhVwFtt6A5tqY9szd6KkM8ScA9NAS3N
         P2gsLBidjO4hwU3mKo1NklSRk+IRcsNkXaFXUAeGSidZxAlz8OHzwHwgPY+rCnyptkZo
         yI2IgTSIX+bHrOShpVYp8SeoN2cQ0U1F1irmnDjV+6BsjMK/24Cc9wfr5Nd6ra69PrgO
         PH4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787617173; x=1788221973; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zI08/Pq8IYiYHARKiGwzqOQw4uoqAVEC7og/atFPetY=;
        b=HlJoFHZMy4iSPlpBYzbKc4MtA7pJLdXzOHg6PVcQpsOc3NG4bNaouzMDd8WHAZn5OA
         lWyHbEkThC65gSYrhvskzGQfMSaLrJd5dTADLViatoZCWgPK5q2Rgqng0W+OGCitcVKd
         br3IHs6M2u7CvcQkVm5i3+epbAeY1FRN20fsgf/sZPmwCDLMV3ZQYhx+VZGK6eVrrvhY
         kqL+Wsg/un1Zq439vmHiq/4QnzFb0LMk7gfQjqj5SBzsTMBrj7MJUCrdWTO2cgqWJ9IX
         zJS5hVj/AcKTDh0z7sJy+aA5OB1J7hNTJHPhBi60sJeDWmXlyMnokWn3zlsoFuPVovRT
         WVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617173; x=1788221973;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zI08/Pq8IYiYHARKiGwzqOQw4uoqAVEC7og/atFPetY=;
        b=mMJvWqCCSKZDyruF1BZqtfmaBax4mi8M3x6sB/IGjs24C0z4QnYBezOnHSGzMY7FxX
         bZJS+QJ1/1Jj8mXrVEhtvm+lzy6ykJUlPH9baQMT3/OML1UteODiCeRxjC7wh6scux0p
         p7zhUBIwhunN16a2YMnyVTiW51BleDsKULnIjZ340TrcMl2IF5Z/TL4VO9QA3BopHxBA
         qFudFS6wVt82+NseKr+JbhMoyFhL5URmYWtf7XUbGvInk3iFBur5tcdjRen/koQWoqe3
         Zkd50EpiYdl/g9hR9Cr8WGYs3pwpGro4+tQlOxYRKQIaGpQNx+G8/88LAeO4K5TZ9XTl
         C4dQ==
X-Forwarded-Encrypted: i=1; AHgh+RqydW7pD/7ORemzMV/fLqF1zLX+Ptk3JtqXbrZ5LkNis2uC03XgZ20pOFOCtADrWl7FaM52MbHNmw==@kvack.org
X-Gm-Message-State: AFuF++m4upRmU0z48J0s0yd6Dwr7AD4ze+7iwzZC3gnwNiUe8PeagCrl
	VFR3gJGc7FimpBBYjgopmTPrJQ2TKklqjoxf2YqTZTDpv0qKiO2B3K10XUeOEkEnLyeVXAm4wcb
	6GXkKmaKg6oZzTLJNc+jaNHH2b5pfwt1dmnozvhzw
X-Gm-Gg: AR+sD10uwf1p+PMikqj7LBJSKVbNOaCNG9BLeHMRBzAYIbwmr5KPA9SgkoK6WLmhEbR
	ztpbKwUaLLcuVj8HmxTV8t0ksd3yBDYxEeZVCj0OvBTfAGSSXqtVRq6nuP+c6DHotNbT83FIEKI
	ZCupHLN4bVnN8KpTNayJEdktbOL3QtZNY4KATH7j70VWaiGf7wrXOUgfn8/oOeutPTijA09ZIcP
	6yqN1//e2nBxmd8VIp1A1JXvRvtBmpOvuhugHngpDWvGB67OrKrSNfKIQMglP8dvKDXhHWC2AX6
	p2/Sz6VQje1IK8hR084wgmIFRfy6PoBoWHAuqlRBusq4h79CJE0zSBWWzAh4Q/IwJPhko9gVXoE
	7I61nIqj7RXj8S102aadmGC5iirNN8oyqmpX9omkO/nXPbmWmspfv7bsTbbLiTZTw6hfVrlzTfA
	JvIefbTgCy0jk9
X-Received: by 2002:a17:907:3e9a:b0:c15:e118:9b99 with SMTP id
 a640c23a62f3a-c246a6a3e6cmr3322345466b.23.1787617172901; Mon, 24 Aug 2026
 17:19:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-18-jthoughton@google.com> <aoWBPU9XKmKjfLnb@arm.com>
In-Reply-To: <aoWBPU9XKmKjfLnb@arm.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 24 Aug 2026 17:18:56 -0700
X-Gm-Features: AcwNN1UvsCHgbvBzolQYlq-95gNp0yB_1rsCr8sUqEoaXoE7K7ke-wjKJ-gZEVA
Message-ID: <CADrL8HVLsiuBGj1X+m89WWLUn+nwBEqGQfwixDnqCYm3cjpiTg@mail.gmail.com>
Subject: Re: [PATCH 17/18] arm64: Permit onlining of HVO-incompatible late
 CPUs if HVO is not in use
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9CF6D1C0003
X-Stat-Signature: puxhjr9imt83mkmrh8d1z5t8ryan1aef
X-Rspam-User: 
X-HE-Tag: 1787617174-16263
X-HE-Meta: U2FsdGVkX1+zB9b0SVgrRjNMX27Sa1eLjkv1xC9gTVOcpFQKObtWuOAfvoMZCwCJ3+eFn9hIOcT0IOu5dENynsmZ0dXlFyASknxUU1KVz1g+qM+BacPVDkhaTEH1v3E1FOeiX9NR6M/Kn34Xw1lkQdP/6HJ3KY6AKpd+3XFNcCFtJVJyVymK+F9zWnxzqQV40RRwB0RYARVa6oN7Yva3YPi4ibk4G6siyD7zriUwEq2Q98lCMeKdcWtOrzrk6qncqM2CC42dxqcwvytohNsTOjio3nQmmLfE+gQUHE/KSg+5fVXl/w+CqmLoF92wYgtXStYkvOpCpvxWx7YdJQ1zEA9AXJ64JGgH1owdptqrNmyUOB3/pwTrjq5Wurc0Zt6xLrV050RmW6CRlOEwZVzEMvhnAhwZdisMaiTeJVZfoMv6TOeixiiogtsrZUGDGHMun1TrzvbXLAnJCroQa50AFNZaXe7AP2kVj4q/dTz0kAQisFY97uWBBJeEPecr+59uvkgsXgxOkE1vvUxcdACvtrNXklMeOTBl7G0CkGcc0t7t9QTDhNLlQV+PvzivYPp9FM3wd2HU1n+bWk749wb7bqbvJSK6v11eGRv6Q05et9LfVKNEVUysA3yY9CBgKstUmvnm3YIpa2MIaQNaPMhrvC31DWdQdz/saOK96wkogjWRp9+bq7FyV94l8iSXyyNU642JxrgQJLp5cnYnK6r5iJ3W1hlumh04aS0MxtjNW3tAOxezojTNE9TH1QdwdF08r+7AHEOy6aIY/iUvxbIdfWXZ3LxpBnSrkQV2M4gvJF/Ovet2v88CmVEUXQISgkyixKnI7gy2HsOzy2EsvWcQeYDioL8nqRFug26swhD+yqVfddzuMF0n8FSs77PVGh3mVFiHSV1K47ADVQFcmUE7iiYBQIhIlVblOz7aRXSh74Wu0CrjI+0TFpxWWGcd6gKdYphWPfSiuquj/pTADKv
 MKEn7Ws6
 idmEfwTprpX3dnX8QQSdL1lCIkdJTbwCQ3rxPjB69giai9HNSqfy/4xRonAmfBAmjf/3wjbsozxmLZEIi2jpvQzUwcN84R+6sJ/zW4nSJx2G+UDnwXQaZ5FBUO3VgHbUtdczeJzXZoRYSccV5NA+e7BzSoZRbDMSDXpanj9v44sUpBEVDPlWPsrJ8k8tufpKwDpEWWUnYmes4J4NJrIZCbdzSHHR5RETgerP4jNZoCSFiBQ7nAZpHYn4dXb42DKIssIEoV49UDLUKkJth+bSD7UeBznu31gkJ/2uCgA0BWTI7TAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 3:11=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Wed, Jul 08, 2026 at 03:11:27AM +0000, James Houghton wrote:
> > First, HVO must have ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU so that
> > incompatible CPUs can be onlined if HVO is not in use. The
> > late_cpu_enable() callback is used to check if HVO is truly in use.
> >
> > If the late CPU is incompatible with HVO and HVO is *not* in use, HVO
> > becomes permanently disabled.
> >
> > If the late CPU is incompatible with HVO and HVO *is* in use, the CPU
> > is not onlined.
>
> I haven't looked in detail at the logic here but do we actually care
> about this? We still need to solve the BBML2 requirement around patches
> 12 and 13. BBML2 won't be an optionally late feature for other reasons,
> so such CPUs won't be allowed. This leaves us with HW AF. In mainline,
> the check is done on the sanitised regs but IIRC these can still be
> overridden on late CPU onlining with a warning. We only use this check
> as an optimisation, so not an issue in mainline but can be come
> problematic with HVO.

I just tried reading through cpufeature.c again, and I think, because
`ID_AA64MMFR1_EL1_HAFDBS` is marked as `FTR_STRICT`, we will indeed
get a taint if there is a mismatch for HAFDBS. When this happens, the
sanitized register value should be set to the lowest value. This value
should indeed be safe to use.

ARM64_HW_DBM implies that it's expected for CPUs to have mismatched
support for HAFDBS (indeed, this was the impression I was under as
well), so it seems like a bug that HAFDBS is labeled `FTR_STRICT`.
What do you think?

I still need to work out exactly how cpufeature.c is going to learn
about whether or not HVO has been enabled on the command line
(hugetlb_free_vmemmap=3D1) for the purposes of preventing incompatible
CPUs getting onlined; I'll figure something out.

> If we don't have a strong use-case for mismatched HAFDBS support, I'd
> drop these last patches for now.

I'll drop these last few patches (14-18).

The only caveat is that by doing this, I don't see a way to keep HVO
runtime-enableable. In other words, if the user booted without
specifying `hugetlb_free_vmemmap=3D1` (assuming
HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=3Dn), they cannot dynamically
turn it on after the fact. This is not a problem for me.

