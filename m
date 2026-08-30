Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7807C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019186B0092; Sun, 30 Aug 2026 03:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C186B0095; Sun, 30 Aug 2026 03:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC0F6B0096; Sun, 30 Aug 2026 03:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE4346B0092
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:59:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CB9D8028F
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:59:20 +0000 (UTC)
X-FDA: 85157185680.04.5E8CCB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7A83580002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:59:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lIw0faM7;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrLDNBRCYN+jXa4vhl3946i3kCe1JZe5SP3/HQaL10U=;
	b=nj0mvOy0cqppECH/meONGIRkctGogrf7bk4M69USOMz1HjHW9Tsd5aApMI4NegoiN3YrJH
	JRO7uf84sMkyXKi7UaNSMEE3cEgx69LIFKkatqEmCjd3RXJQC3D4/BVH2BbExvcLedXNn2
	zfsKpRQAF0F9uhYglB5QmXXztwgEOSs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lIw0faM7;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076758;
	b=Ke6+ezJMF95ZWtNgUwUxswJyhZ116a8UMXR1RRUxvMsLpX855fj+Lpda3SAdaZ2Ya5nGtf
	IhmlavtVKkciR2FHs10B0+g2DRxvncqoZLjPRf4sMi2iagGo9ai+0RvUOfP05c1dGeqmlz
	TZfeAR4Uo3OLX9qYIIypI1Kl39tsc78=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC842600E2
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E3E1F00ADF
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076757;
	bh=NrLDNBRCYN+jXa4vhl3946i3kCe1JZe5SP3/HQaL10U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lIw0faM7AwczaPglu+Ccvr2HXhVNbDDmxWNjJXQ5CjV4eGSR/yPsCnHUn0p9Mg/qc
	 YVgNxuBLmyqhygOdOIphzwelaalJTN36rqN6TCmLGicMk+9y0yevruc6IfODRc0cyR
	 U3zzrMNXe1Putuqul5Ssc94V879+Q2V5g6+af2a9Xy7hIsEBGjQV/6HFr+1Ee11m6l
	 mZiy0JqnURPf2rmZh48RhFX6cuj4XWA0NH7RCsHlEqvtdvyhY8XhvhiWGvcsoacEYf
	 TlpjYailZ0wm6CauWCtPmJMEf5PftYSFlRFfT0BANi3bs4iPpk1DdjKjveXZe40lcF
	 5iRg/W3GhgNMA==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-930f618435cso178088385a.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:59:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqf7f263SU69ABWIohJ06/xAVTXQXohj2cgtN6d8JyI+AISE/WIomyrFgr704EQD32nEGmSC1WNWQ==@kvack.org
X-Gm-Message-State: AFuF++n8IGevbMJ+8jwvGcam+av+PJQuM1fU8JKlbxDMo5qEtCVT0olJ
	74PN1Kk+1itM16J2DK/jnJQiGn5ItSegblnW18chcEzCfCrTj7aDaWV9JIGrZ+nle3mvQ6xCFDy
	KjoDO0yZBr8pE02uWgdYetLfFEJbJhE0=
X-Received: by 2002:a05:620a:29cd:b0:915:a953:4b9c with SMTP id
 af79cd13be357-93913749780mr1843635385a.3.1788076756998; Sun, 30 Aug 2026
 00:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260828110919.1324028-1-ridong.chen@linux.dev> <20260828110919.1324028-2-ridong.chen@linux.dev>
In-Reply-To: <20260828110919.1324028-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 15:59:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wp+O3AX2YQMsU5iHNZX2tYJ1TuSH30eyp=_XeEb2gSrQ@mail.gmail.com>
X-Gm-Features: AcwNN1VSR0ETjAivAghBgogeIeAmAQL0JT7gsTA1npC62VHF_x-d0gDpe0cIFYc
Message-ID: <CAGsJ_4wp+O3AX2YQMsU5iHNZX2tYJ1TuSH30eyp=_XeEb2gSrQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/page_counter: avoid integer overflow in effective_protection()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k5ki7fsyywjtp9uxze5fzpcbpcmnitny
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A83580002
X-Rspam-User: 
X-HE-Tag: 1788076758-475309
X-HE-Meta: U2FsdGVkX1/XcpgzEbqDp3BhwLK/OoErHyS+2MuFby0BSX+Qd2KBxY8rkrTwfXD54txoOr3Nb2KVM66fcIx4t8gdnDinPIZ/YdKdcLLlloYzbhEzdZJkw8u40WAjLe/+zSKMvNl3lYbyGnHofeNHzQ22hucNVsb7F3mjp9TvWUAoyJgY0ang+wrBZ23X0PfswB9gZ9+2IeZJEIGa6YxDXGy0xoL+xFQgpL2J5bdTlV6Grgxa+moSALygjkisPFb8FWCSI6vLMtc3d21SPhCTQGD7FKWbqAZUTYR3e2rESemWcWhJyrgb3PyH9pTbT9i6NhK3v3itI+GMpgkSglZUPWquYSSeKtgCtr4n5UdU6RfDjYH55q9pxepHJ4d8kflhRyhKG1TsvgfBTTo1n7y+Bp7bsu3JrTURxz89TPq5FV0ZWJnKPp52hOioJKTvOnfdMJlsnCrGZRMWkgU3Y2vhy5xQKaHc2QQIL4/W97aNewG+yCrPdkwH/Ee2jvxCNHH5NmMUjFMfvp8/Qx2fe88hGVFl0LnWSmV8svvxZZM9ekHZKi70R29rqvzbav1Qb05SFleVxLWb2qngBft/JV4sE8XIQXLbnQcatKaEWDW6vJ0Dtb5WWqoayasaHbi+mtyLoyuF7tALEYI3T9xlx0gOhspksTyCZDmjAAakremGYhR3fojSz3Uws9XxBrtocPq9AHEvKmDVb9cPjVs8j6PdhOaZy4rMNdn+5YkfPyVOIzY216YPeKBEk4d2unSZdJ2xnWZwVKX6ZDITk4SS1h3Sdioev5u2LlsTlezyxIeB/MqLpfCVmEuMcIJiZpW1jDXJtTv7jFN6iDl2E8N5Blx7uwZF5a6tiQcu9WzhfJEG3MP4LcyiOuwsoSTQ7OJ5vd2Z+p0uUdQnkLHubI9H9KZjwk7Ta5ygCh9uleiqV4p/ZmiA3GlBglfPjp9SYbH4TWqJQ5AUpx9etyqy18W53Kw
 r+pbfi3U
 uEOjHZ9RKZcj/9Ayuo2V7eeYuk/9yqcSfcATakjz2lniuH09GGtP53GhFzrXm3/DYxkGyBkfTc5HO53Pba1V955neQr/aWB45zWwXC5XqTSS7LUm8GxIjFqnJ/pdu2vQqXEKr2iFpj9suci9BYAKiKZPO2mib99Ut2X+MhYobzo8CPTW+NcUqQTrbswLYEgrRtPa0h+C+r+fjjV2zZduH4HPUxGPh7OCd69Wa6tVP8QfrlPIbLdtaf9/ZLb98ZvRBUTSqKZBfrSyXUhKd/pA4qRtkHWbQdSO9imU3avLj9hQAWqzc7XQXESe4J3YvzhuFENB937ztXG4fJz8Vdkq7cQnSfsoEQ1ESr6WDnmch2p0MpQlixEwqO0W03QyH1dgydO0464eDT4XerrRTgKKwRUIUNEqYEY7ngUhi/IT09thrVyOjxVUQ42nDyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 7:09=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> effective_protection() scales a parent's protection by a ratio of page
> counts, e.g. for recursive protection:
>
>         (parent_effective - siblings_protected) * (usage - protected)
>                 / (parent_usage - siblings_protected)
>
> The multiply is done at unsigned long width before dividing. On systems
> with >=3D 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
> protection value and silently breaking memory.min/low enforcement.
>
> Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
> usage and parent_usage are not read atomically (a child is charged
> before its parent), usage - protected can briefly exceed the divisor,
> making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
> the ratio stays <=3D 1.
>
> Reported by the sashiko review tool [1].
>
> [1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@lin=
ux.dev?part=3D1
>
> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low=
/min calculations")
> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

