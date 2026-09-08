Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BBF3C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D006B009D; Tue,  8 Sep 2026 06:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD596B009E; Tue,  8 Sep 2026 06:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF236B009F; Tue,  8 Sep 2026 06:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2E026B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:41:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 471851204DA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:41:04 +0000 (UTC)
X-FDA: 85190252448.20.EE09CCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6CA091C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:41:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJrxUBXs;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788864062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MrkOvxvKnW7TUEX38uVtxuQVcubBsW6gHoqh8Zyu5c=;
	b=rEd5pUzTnikfimMDUciy2isRuXQvH5iarllh5W4Bo+SR68EnUd3Kib08wKlJe759w6thgh
	TEEQSf20JGoIkuVP4eT/TBDfXTnf/61wCgkUgJCdUfqg5UewUYsk7IIn6xDxgWhVZY4mnR
	cyUTSRWvtnEMTMp6zMJUDjlLZJ0byA8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LJrxUBXs;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788864062;
	b=k8IuSB79xq2XQtYf0CLggTiw5B71N/rjIKVut7Ui3BwpcrYQ8lWuEIdQDWwjIYuTDbOpwK
	y10wRpTh+3Rdw7lIEHxv3OkyyntrP1EfVeTf7UfDnqyo0rnK3HpElzyjE9upvVu2Xs8Loq
	97pAsWHVPOh6zLFCnjOK050FqntO1Y0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E958D60A93
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AC51F00A3A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788864061;
	bh=6MrkOvxvKnW7TUEX38uVtxuQVcubBsW6gHoqh8Zyu5c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LJrxUBXsVAvOPqhtTrqlfLpRnD0hKsHl8VRmBmzki7DxyLbC4fc2T+uDWT1UtIQ7U
	 skSrgXyav/5XC8vnBy9eQ6SNSF8++sNXF1eBr/QBEEq2B7lMtYXV0LC0odYO2p3m94
	 QUZhuCCiyXD4q+1rf+1dzMh/PktJe78EBbGeZUKJdZmGamNvAoRhFrWGl3OCVbA8YI
	 eoCNYKKcpgL+IRoIg62QKMgxMEatLSIqqJorGAb+Bq0EBPjgRhgatmAWpdYen7Xngy
	 ms4WwD4nbreG5wpyFS8qDoX/Ny5zwyzPvEej5fJ1Dthciu8IKy6DEhjD0aOvEK2dut
	 Dd+CuhksLgMBA==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-939949d9c33so241878185a.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 03:41:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBydrHZ55QUOg1qmD2QStZJqtYLF90ZKa0CBxLU7xg/M2rDKwhBReRtzw62mqxDtAHQeL5efBdZbCA==@kvack.org
X-Gm-Message-State: AFuF++kO4B54lFMtQAySAgsHPkySExhaKw6SgF+1oOCbmZiGFVkBiiJ+
	HcAOWJTapXGvvN9dMWDCVobArJyJ+EkO1mqhUr1NEq6JR05RMXSgttEZ5Zg9R+Ipx7w1dhBGHRj
	mQQXUqiXgrWsNc95sq88X0B0phLQOrrM=
X-Received: by 2002:a05:620a:2903:b0:939:13a7:70f0 with SMTP id
 af79cd13be357-939802f7939mr3057881485a.5.1788864056096; Tue, 08 Sep 2026
 03:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260901190123.3511535-1-noren@nvidia.com> <20260901204449.GK3004@cmpxchg.org>
 <C8541A2F-D6A9-41B0-A3FE-52339A6601F0@nvidia.com> <20260901220917.GM3004@cmpxchg.org>
 <69C018F5-A1C8-47AD-9567-3497AA6808EC@nvidia.com> <20260902160417.GN3004@cmpxchg.org>
In-Reply-To: <20260902160417.GN3004@cmpxchg.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 8 Sep 2026 18:40:43 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w-GF06J0kd1X9Hxzfcs3YtpO6KRGLAv1w4j1L1Zt=ibg@mail.gmail.com>
X-Gm-Features: AcwNN1VT6lhf2AnAT1VcPvsMl-I0MnH4-pnEeOyIikJkyUIQO06ZRhqlMrKECeA
Message-ID: <CAGsJ_4w-GF06J0kd1X9Hxzfcs3YtpO6KRGLAv1w4j1L1Zt=ibg@mail.gmail.com>
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>, Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Bo Zhang <zhangbo0325@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hm8s53gow11st6wqn3xbnetqeuxjx657
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6CA091C0002
X-Rspam-User: 
X-HE-Tag: 1788864062-984228
X-HE-Meta: U2FsdGVkX1/toDh7j7hzbwiN8Rj3qlZ9du9JwDMB3j3VkCEnVRqZMqiQGhqxDxeZMxg0r3e4awp6vqVugOhmIrRJ8mOnKVWnNhaOGLqJdA0QydZFqwgtlTiv6+/PwNlMa5M8orXkly6NQbk8PzNEt8vblBPbWMknYFjZFqKhBLxwN+tESPvTfTzqM+m8PtptCHpUKMHAU0JPw/+xoSpqhL1xJUWLWhQwa/dgaC6eDEnT8xWGQmDtfhFoJLrWVI1KTNGYWFHbi0KCYMsQwm/Vgyngb47Yu/NQC0VR3TfztshNxBcLbwCScGRfe4Riw4ip9L2JNz+5I0aKE+lw1dgc21ZEYHj9tuxtIoXMHV/3yyQHVlskDK8gJrC7nhZdjSegmePJqRfgkFFM8aK2N0L3E1bfPl4mOSEv6bwqJrIS9dMqgHpuR0YrMI6Vr/yGFReTijH4hBsb7sF1ffx7zaMvTwN6gm6RiQPWFz/iwrwzMdgg+lQXcaLRVD+t/CdJ+WIiCpyvCUctIaKQMDG0FWnRt+wYI2nHIx+9ypRgksXCRv1rQc00kQW2PJ73BPHjPj2hvHpgUSjvrX+ALBenWXaEnkeUcK6Jrty0KO/FCzfKYnsTrFmlj7Dv50A8wTDyWV7/AwFc5CHuITEc17xA0a9sX0a26NwnmH0ALp3PiAhOK56m+lh9CO8DkgaTPD9oAq3TCmWLesEyUjyzOalNYfhIMG9nwjztAOvW10JxI+M3kuEn5Uprklp7v1loYUwfMwoBiS57t2Sv1roWx2vCi9uIaO0ahzarlh5pI2LpND5bNgx8hVrwcBap9eugVdhYduJFhKdunXKFuGRUaHtgSXY/bFDYwUYoOYCaw9sFlF4DU6UgWWb6l9HSSu3AaS55Naq5qBVsJ2GSFL91WwCHYebzKHJcFJAhKTkRrtJo5Ygp8ORD0CJX2MX8lFvQrlJCJEyRYwZdigTIwwVUdXxk4ts
 UI6AaTXP
 HTkvzEnHADGhzrVmdgtwDt+4o/gAIJFO6VaqfvvMN3Lx20LZexESzBAeMcLPCA0pdYFee4TclALYQMzGhFDn4kgpQqAxgz1I0CTzaoxXIGAsfhvSDUh5m1uMhVxNM/dLgZUaKIi7/i4WcHIAeRbxLtSoRI1YL3LRnG69Wda8CwDPbIOjgTxQ4tXt0x4DM3sFtO35iK/TIGmUYmquvGV9+TpBU5gAgEH6tbtKX3LtI0TWcPAkVszscTRRCpHIAx2nBCfooZtI6UvaZqhVL7+71cWxcFgPf2Fd21gfJUL1E6fZNp/OcrWXFph1Vnd8KsFIQbn7SqbvJ9GCnN5NvKUwp+yoaUTb9moOMY5og3+VbZ1z/m0/ixT4jBJjfLoddjN3nZhzXaaVooZjqD94eTJKJqiO6azF3CLcN6dhzy/BQ57ZajrShnYfW+d5zuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 12:04=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
[...]
>
> The idea is that the pageblock maintains contiguity for the largest
> size you routinely expect to allocate.
>
> The page allocator is very passive right now, and it doesn't work
> super reliably. But even in the current regime, smaller blocks have a
> better chance of containment.
>
> For example, when the ever-growing page cache runs out of movable
> block space, it spills into unmovable free space. When the next
> unmovable request finds no space, it runs LRU reclaim - which is more
> likely to free space in one of the many movable blocks. And so the
> next block is poisoned. Smaller blocks have a better chance of filling
> up natively, means less pressure to spill into incompatible ones.
>
> And the higher min_free_kbytes, the more likely there are still native
> options when the zones are down to the watermarks. E.g. better odds
> there is still unmovable free space, you just need to reclaim some
> movable/reclaimable space elsewhere to satisfy the watermarks.
>
> I've been working on making this more robust with the huge page
> allocator / defrag_mode stuff: instead of falling back and poisoning a
> block, invoke reclaim/compaction to produce a neutral block that can
> be converted entirely.
>
> It's the same idea as the higher min_free_kbytes and watermark
> boosting, but it is more targeted at the end result: readily available
> space in compatible or convertible blocks.
>
> But with that active regime, oversized pageblocks are even
> worse. You'd pay ongoing compaction work to produce a level of
> contiguity that you don't actually need.

Hi Johannes,

This could also be true when running 16KB or other mTHP sizes,
such as 32KB or 64KB, on a system with 4KB base pages and
2MB pageblocks.

Proactive compaction would try to create 2MB pageblocks, even
by migrating mTHPs, but 2MB isn't actually needed for large
folios on the system.

So here is an mTHP-friendly compaction RFC from Bo (Cc: Bo):
https://lore.kernel.org/linux-mm/20260825043833.2659350-1-zhangbo56@xiaomi.=
com/

The idea is to let compaction create mTHP orders rather than
2MB pageblocks, with much lower cost and greater efficiency.

I'd be interested to hear if you have any comments on it.

Best Regards
Barry

