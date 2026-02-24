Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 306E3EFB810
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691576B0089; Tue, 24 Feb 2026 03:34:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F696B008A; Tue, 24 Feb 2026 03:34:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520A76B008C; Tue, 24 Feb 2026 03:34:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2406B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:34:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA4A01C39E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:34:40 +0000 (UTC)
X-FDA: 84478689120.02.76B1642
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1421940003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:34:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MkbEaysQ;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771922079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znXHW9n/+MokWp37xWDCKYppH1hLZZhDTU4jhuelsIw=;
	b=DEmiHSqZQiiauE7N6XZtzJGPy8klFE4Ub29l3H/G/jMSlrNyQPAQZUwpXBD2tRsiSoRNoy
	EqDElZ5rbI3Lp1VRCQDrxgo6+mk//NX/xmc22xTNWXGq5/mXPljLIczxqFvdgZmkg1Bkvn
	vBhXcFL3Ant5tzcAqtLCKD7Lb33T+1o=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MkbEaysQ;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771922079; a=rsa-sha256;
	cv=pass;
	b=pDYktKvztDToHKxz0DJyIIjJcl8E2TcRYY+fda7UjdYdLPma5yXb9yE7Lp8d8QS9SyM2TP
	ztjjbCDMzDQudk190sg7QrvwH0RO6/p+zdVkfAsz+TNouw2ueP2vIi4+RuxyRX8dwmftwo
	o0Y//4X98kmCROxNai4BvzV7dnH4M9A=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8860d6251bso697580066b.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:34:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771922077; cv=none;
        d=google.com; s=arc-20240605;
        b=fMBSedHiSblluZAEDe3Iqmyei6JCNyWayeRtvkdb38h9d7i+V1GxQZ8cZySkElexIJ
         9X14XV0JOEWO39JJrBfv3XZabUX5MnkrHMBxMtHdfWgWfG+x2t3p2LzFsFephPKw8JLL
         4B1Qw7a+qVj4cZ3XH+VAq9fm4g6CS/Y0f11vtghzQGt2RQZIimvtQalPMUI1ZdOqRBvw
         gzbPZtPcmj+IxMKcjPAE7PpzybZ6WtBabZHBMtYe0+qKho2LrOcEfsbKNbDJ8E7EaFep
         +Lak0U78uZfzaCRBeIqgq6eudFUWiyWOxmPQF/eTYP1KUYQtWC0xMDASqZIuNXdG9Aav
         omfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=znXHW9n/+MokWp37xWDCKYppH1hLZZhDTU4jhuelsIw=;
        fh=1yXP9AGbIpWvpU+iCA5O+gTlqsQWrOM/8LFyy7EjhmQ=;
        b=aqbgNFZlqbWZz6OpIFbnftwh4Q16a2dA6A/lunI3FeDJhlojdmOrsgCBSjVC2lHV1h
         KcjJxq8wZ2DovVfc4EwSjnQ49EOJ8ntr0XWALUGui/hENnqNm5RgILRDlaA14b7MbGG1
         uAAp0Xp10ET26S6nngwaYbcTse3XvUDNMKy8+RzAVteQ68bWo91oqPxDXNRhNYPCatwY
         xIqWSGr5WscGi5CRjMgKR1AwyyxFrDLb86ugJLJtpk+frNh/sc2USpDfVaYi0q/TUWXD
         HDxJ2cBpZoe9tTHdMQYcVTPAfZQEgAHp8U5UBB+jD3r1BCwh5vEfs2L5k/dwf+7aZOsS
         4Glg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771922077; x=1772526877; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=znXHW9n/+MokWp37xWDCKYppH1hLZZhDTU4jhuelsIw=;
        b=MkbEaysQu2cGJKRVRhFNPmg0NaEItWBwTMzSeJU84cHuG5vW+6JWwJ6bk+YCw3+Luz
         GMRFv6yAWp8C8z+RlnQ+YH1aXe/B2UpFMbMiMu6lWjNf4hHwd33xMESmYs2G6p3N8ORf
         CcAcqH7uJwcU+VKzOu3oigCwAn3BDzfZPiK1PIU2DjpSDsKwCdcAvBWLvkwMWqTp4lXt
         wVR6ur9ArwDHP03jf3ubzhIXdKP3zkbHk/Gk5T2Ms0L4K7TgvXTvW9+BmwfOgMNFa+b6
         5zZItYADpsfCRBcFnlveqLaXME0P8Oy0hRpYTGa2yJWi7BTY5/ZvG2fm5vAz15vVGoZP
         3unw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771922077; x=1772526877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=znXHW9n/+MokWp37xWDCKYppH1hLZZhDTU4jhuelsIw=;
        b=XVKUYTTVllssTmrR4YyFkC5Dia3Jp21CeJLBZ7cyNc4BgIXE0jXXs4z56ewMQjudCR
         4FShgUcUeJ55UKTd7Cjur8ODCeBIcEVsk6pHjJVok5SOl2IIx9tfjTai4tPI4IGRRvUq
         rQdggHviRpu89vuDu/392PFexrv8bqoZxozF7cEwVb5elbTLszrYN28c+bE4WjZPiQma
         EU9K1o3UZTnADuzX79x0KWmQl7VKcy++g702jGGYgUP3UPclAQIRwBGSaKS75JCTdEkZ
         3Ed7fpUimcGE1YCB5Ys7Jen6ulu4EV5oCZZ9mz3bL01Pwbr0Zg7sn/4WKWPusNI/Sam+
         TnhQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0HNwAw8EyS3HkaZGE2M96iJCv+/5DV6e9cEMfVuacIb/RHEXczt+J7le5/CgMQNe+L4IK3np2eQ==@kvack.org
X-Gm-Message-State: AOJu0YzF5Vdffg1iV8cWYzM8Bea5zJurvjUg4tQwgL7ROKmEJV1+tR0Z
	x6ylTSQX1TKnirjdgXKZX8Z2PT//eNNdNcqLKAqXQu9dfxSnuwW3EMfgTziVqSPGYa+cmYGvGSH
	qlnPMjeWCsPBrTFU84MHjCXY8ly6t3zc=
X-Gm-Gg: AZuq6aLyWbF0kVy3vbc9ZQXm6HXIxoDvFLM/4KyiJUMy7SsLm0fwGAeK+A3Ihqy65cv
	OE3B+xwtKIN544eMufsrb9tyuaR2jU02NPvxGd3LFDaWuOetWnatclJYsnr7n14pM3Co/TOhKfx
	Ts0MOPBYk4aLUwhgjvQWmx4cHYbHoel/Tzo4t0miyCSce6R1ycKlMvq0HmAkwcwdAa+Dd03orYy
	wJYkIX0Zw9sVs3USXvhdEip04E1QwC+ZgMVWhvkZU+skGOkAcx+Y0jYzNKL5edCZ7m4+eR3MJnB
	P1NTItECzaKH58sXrlglIcewna4IkS0Cx+YFI/dpDkP8zD1vA24=
X-Received: by 2002:a17:907:5cd:b0:b86:f999:15ba with SMTP id
 a640c23a62f3a-b90819bf271mr738575366b.18.1771922077181; Tue, 24 Feb 2026
 00:34:37 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <20260220-swap-table-p4-v1-8-104795d19815@tencent.com> <aZyCJ6pH4hey-ZoU@cmpxchg.org>
In-Reply-To: <aZyCJ6pH4hey-ZoU@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Feb 2026 16:34:00 +0800
X-Gm-Features: AaiRm53rAvIIoLImS2kI3nJgno-CbLxDv74dTHqbZXtKN15KdUZ64c26Zb5nj1k
Message-ID: <CAMgjq7Aq5ckraKtNtet8+1ANuqnitFsXxefbDJQZpBxNmaW7Cg@mail.gmail.com>
Subject: Re: [PATCH RFC 08/15] mm, swap: store and check memcg info in the
 swap table
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8bb4fmromt1gkmzwq7pfpamiyc67dki4
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 1421940003
X-HE-Tag: 1771922078-92138
X-HE-Meta: U2FsdGVkX19LKP47wbl3JmQdQKDuSXgYT+BChI4dC3dLiaXtbDO5jo/O3IezOF4OvtuBJol07110aRLSFj/9BqAck3oZjAHX54dWJ7xtWlWCVf3O6CN5zC+hokfx4CvZwJYZ/PvPDfJMPSvUZLaD9MJDr4NHzV+f0WTgQNMOTTK8SX45ELN79ByvVvXev3GG1E8m2V2WDMLju7LdV6KZ62/5QBTGHuoP6blEqJSKr4PO7i5cy2l/ONnOHBpq+k0RElY+lNSwJarqmCEKSa+t/ylrbR1Gkt6rJ9/ZnEtsZrM8Zu/1eShFB1Rb4WyTUSYskHcccuhV+sTeCpQWGLbQDoaobZ46s5t42kPgm99U3Ubs9MqsZZ4E3jRko3gV1sS8YA4IuIj6a4dI6mq5txhkZyIOFwKnnKy2oUQUhy47soD7C5FKlcZDKx3PKgcvHD1LjliWD3T1jKIRlaIqXMYM8kIHmFqwIqQwy80gIU1IdWkuzKDVa3vtplmSNUU/bvoHQcqYGWe8/9Ui0C3foY2g6Jx/ngYDuwCoccBzltFQdEzcHO5uL/sbw/E2y1oBiHc/CvD6FGdB+c6wQXEyRszrOgQgBxojpqElqzu6WcAf2/+e9CNExcS/sRXbD02zsLnQbW3csNtOyJqmQ44DvseuCuu/hpsTOBet8UehBb8GBhxNY4GxexGqXkMFbO9RGN1i4AVTCgCmYHxwVnm9mS3XF64x9RtPkZhq3TTzqA6gTlwIk6RYE3EkmkzUkmaFYnYbCX/rvB13+yNX56zxDo2ExQzk6/E4OWIgxNNhx3/JO5KGEhxXaNCOFFp6giRm3r90pHsgN+i7DgXqQ81Bv/Pji6klQkBF0OBEpuD1+/fFsmNR5WPExvskHZgk3E8gpziwULNh4hkJP3rCpUBTBPRs6kgkyHqaH1gcY7a8FNjizOjCge15v73258yyKj0XPagY10IIcVIkFTqGSnwQeTv
 q/uNeNrU
 rSrDpPi2Qc51eEqsYUS0BWIiJ9yKratoOT2+S5cmP3OR6HBnITG8d0++SUYfmyFupbbKDfOW/DjpzY02876wXwyS4n3YQUmvLiDOHIsMSnU0eBnaMov0y/CEum1c8xbcuHuSBEk3tP93uI3UM5G8tRVb2ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 12:46=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Fri, Feb 20, 2026 at 07:42:09AM +0800, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > To prepare for merging the swap_cgroup_ctrl into the swap table, store
> > the memcg info in the swap table on swapout.
> >
> > This is done by using the existing shadow format.
> >
> > Note this also changes the refault counting at the nearest online memcg
> > level:
> >
> > Unlike file folios, anon folios are mostly exclusive to one mem cgroup,
> > and each cgroup is likely to have different characteristics.
>
> This is not correct.
>
> As much as I like the idea of storing the swap_cgroup association
> inside the shadow entry, the refault evaluation needs to happen at the
> level that drove eviction.
>
> Consider a workload that is split into cgroups purely for accounting,
> not for setting different limits:
>
> workload (limit domain)
> `- component A
> `- component B
>
> This means the two components must compete freely, and it must behave
> as if there is only one LRU. When pages get reclaimed in a round-robin
> fashion, both A and B get aged at the same pace. Likewise, when pages
> in A refault, they must challenge the *combined* workingset of both A
> and B, not just the local pages.
>
> Otherwise, you risk retaining stale workingset in one subgroup while
> the other one is thrashing. This breaks userspace expectations.
>

Hi Johannes, thanks for pointing this out.

I'm just not sure how much of a real problem this is. The refault
challenge change was made in commit b910718a948a which was before anon
shadow was introduced. And shadows could get reclaimed, especially
when under pressure (and we could be doing that again by reclaiming
full_clusters with swap tables). And MGLRU simply ignores the
target_memcg here yet it performs surprisingly well with multiple
memcg setups. And I did find a comment in workingset.c saying the
kernel used to activate all pages, which is also fine. And that commit
also mentioned the active list shrinking, but anon active list gets
shrinked just fine without refault feedback in shrink_lruvec under
can_age_anon_pages.

So in this RFC I just be a bit aggressive and changed it. I can do
some tests with different memory size setup.

If we are not OK with it, then just use a ci->memcg_table then we are
fine, everything is still dynamic but single slot usage could be a bit
higher, 8 bytes to 10 bytes: and maybe find a way later to make
ci->memcg_table NULL and shrink back to 8 bytes with, e.g. MGLRU and
balance the memcg with things like aging feed back maybe (the later
part is just idea but seems doable?).

