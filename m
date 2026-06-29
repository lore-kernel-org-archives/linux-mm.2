Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D464C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2DB6B0108; Mon, 29 Jun 2026 12:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9E96B010E; Mon, 29 Jun 2026 12:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8286B012E; Mon, 29 Jun 2026 12:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1C76B0108
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:54:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D98AC08AD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:54:20 +0000 (UTC)
X-FDA: 84933548280.27.97CD9D4
Received: from one.firstfloor.org (one.firstfloor.org [65.21.254.221])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC18D40004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:54:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=hoWtijM2;
	spf=pass (imf12.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782752059;
	b=VJlQVknxqH/S4xWdpr8E38VGe9uOZTLhtgEWJOojIVdEG+rU4vy3LnxXjF4whdKNWiR9IJ
	OW7dAN9QSiWFJ9JBxOL1yx+UPO3dxi3YEkpk0OU6I2dU8K/BLAk93v4KJa++hbE+wuuUB9
	F21mzvvDw066PVaCx58PKvgG0dkdNnE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782752059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/pQiZoUMv0onkL3b5U2urgbwPUPyC5DN0rKgL9DusY=;
	b=D87Uot02uSyiyEaVmZpcWMXs2EVrCNZSUlZUNOZnRailacTWqx5frSpDeObceAxxe86A4n
	kDsCb9QIx1vH4Q7WDd5vE6UcsOGzinnptD8iNxoycKETjf37if3V1+qZCkV+zJMQSDykwG
	lX49vdW9KBpSzoEAGtryyx0CaUZGX4w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=hoWtijM2;
	spf=pass (imf12.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
	s=mail; t=1782752056;
	bh=1+OvXKBSJrqCTEswr/10x1x3PFYbvXrrARRRWu8wQWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hoWtijM2AqSbBKMUTZCq6bVkMzzvKzt5LOopBP1s7dAvMu2N3+HakILYwnzl8+PTo
	 +c3Cmh256PoUfNEjUDL35me5A6xvVF8ay7UTiSdT7LmpKCS0ndfTBXyVjUiG3TtRvK
	 4ayK3EgxLineaOIqccO9Xquu2luPFw9fRsywBdnQ=
Received: by one.firstfloor.org (Postfix, from userid 503)
	id 3D29B5EAB0; Mon, 29 Jun 2026 18:54:16 +0200 (CEST)
Date: Mon, 29 Jun 2026 09:54:16 -0700
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <akKjOG6iFhGNTFYC@firstfloor.org>
References: <cover.1782676497.git.mst@redhat.com>
 <akHUboUaYi-OJHFu@firstfloor.org>
 <20260629033608-mutt-send-email-mst@kernel.org>
 <20260629043417-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629043417-mutt-send-email-mst@kernel.org>
X-Rspamd-Queue-Id: BC18D40004
X-Stat-Signature: hy1sk3nf6d1fs4d1u44d7mk4hu3jc9sc
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782752058-924509
X-HE-Meta: U2FsdGVkX196Gq7/J3mdUqoHp3BKA3+JDx6hj2yxUIO5Q416PYxbFsnNeNKw57C1dThLMlhF6hRVyGqbCTzk9XE9XfPhWU1quhnpwkSqzXNQF5/sfynA56vBDKFghE8182vgqihKJRTrw6DObYcF4GQoZfidiyM/slamwv2L1PBvRJMyZSesElhlZwOhtaVsp8hIojngV45DNDMGY6r4i+PMk3up9ejg0L0/gUOC13mpnyP8eTCqtiIIOvfzK24u5O+dmQWpxV+8y89oFBtZllE6adczjfmAn8/sBh6H/Tg4c1nWAkpyLnzaZzBvjezzJpa45oDYPNMhZ70RLbwZkb9DRlou0MFCnk5I4CAP4GxYbyXSI87XJNh11R6whAg378wnUz5J9TttIsuomzryTomPB43Hfpv4gsXdhJUHWjCVSzDYh2ijmJjyMIOlxugwzd7bQ4RC/hV0+e6OsKpiB/IsRbL0h/bhGKnQqGjBenFd43/ZNeJQTBq0mViWaaKdnIcPYle8lsyFnLt6dS81W4s7CRE4A589sBuSmpY0L+iP1IjtcMLBM48YDe8ZFtlx2RSFSic1EQ0XSevASZcmEig9aY88c8n2YXn+LKfe9tCCwGC/UN/3/gStRmp+vzKM/M1p6BzRwrwMqY/4yeVc29To6eI05vgNj2WlmPho1Y0uefZ1rQ6IV6lXQ3cekhzOwTTWCwTz29p37nLIdm2S2FG5yZicIthahLzQDgANUWfMEIbXxd/TF8GP6hqAQK8Es4rDMppyl25fkz/hqy7aZgvGOI6Zp5x2E5CCl0nPsxO516OvN5d7cE1C3vS574vV87/uRcknuiIdRuvY+VwA+CfiTbQcgazXTlN0mXbR4sorKs9FwJQA4x3uf3LEXMKvHseKCVXltwax6nS08tgqlvyqoweDJMVxpQh3ZHoiOR3kI1cmPAuLiVQNS016GKcmgM2mLqKO++5BL1v4gtH
 aVvPUCWh
 4A9UmT0jfBvtH6LOmbuE4wOxmofDPm8z6tNOXVMkO2Fv4TgnDQUI7dR6pVIxiXAhbIX/OJc19vbKWDMi1xnk6wBkrXZmYP48elBGBEMDhtiUjHRpH47zyDJxhl2MpQKMYIM36vtZ7QScluhMoJHiRZyub5GDkdmtqFFU3VX12waama28AWMaaY3P6vH8VhGWaLW+ORFSqNIL3jImafc8Kw7+MmxIJcW4+Ixt+sY3v+N4oBljt5gFUxebVajJiCRgTk8tFIH9VKJ0eoGOf7wgg5u5ibm4HRDkWWUvnoFFUQj+zgq5glnrlAte+SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> However, this was a basic test, when allocating 4k pages. With 2M hugepages:
> 
>                                    insns/iter    cycles/iter
>      -------------------------------------------------------
>        base                       20758 +/- 12.5   191208 +/-1946.6
>        rcu                        20785 +/-  3.7   197108 +/- 132.1
>        atomic                     20727 +/-  6.4   204591 +/- 160.2
> 
>        rcu vs base                  +27 (+0.13%)     +5900 (+3.09%)
>        atomic vs base               -31 (-0.15%)    +13383 (+7.00%)
> 
> and even with THP:
> 
>                                    insns/iter    cycles/iter
>      -------------------------------------------------------
>        base                       27220 +/-  2.8   192151 +/- 483.3
>        rcu                        27248 +/- 30.1   194159 +/-2746.6
>        atomic                     27186 +/-  3.2   200526 +/- 746.2
> 
>        rcu vs base                  +28 (+0.10%)     +2008 (+1.04%)
>        atomic vs base               -34 (-0.12%)     +8374 (+4.36%)
> 
> 
> needs more thought.

Well the alternative is to not bother with RCU, but just wait a bit and
check if the bit stuck and repeat if needed. While that could in theory
livelock it is extremely unlikely (especially if you add a bit of randomization 
to the sleep)

-Andi

