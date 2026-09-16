Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 547A9C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5CD6B00A0; Tue, 15 Sep 2026 22:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566FD6B00A1; Tue, 15 Sep 2026 22:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4583B6B00A2; Tue, 15 Sep 2026 22:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 222616B00A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:37:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFF0AC05F1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:37:11 +0000 (UTC)
X-FDA: 85218063462.02.6A75122
Received: from mta0.migadu.com (out-244.mta0.migadu.com [91.218.175.244])
	by imf28.hostedemail.com (Postfix) with ESMTP id C4A2CC0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:37:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EpH8EBV+;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789526229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqJA5t/6uFUjSma+RvzmZlfLrOAurr9JExGqTkta5fI=;
	b=aBU5tp0nLOc3y7wQUdTBg5Vv3eYJCNPJCSOrx4o8AC5vr78qFNEKV+Z3MlFh5/C3ezUOw8
	Spyup1b4flfZkSMrYz/0hVMUa8YN1djG+RxRgOX76sMMPuRtJQnGWLm2zGvsiM7EOu6kSZ
	mrpZiVBLEynBhC3xaV8llgSEn2aZZl0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EpH8EBV+;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.244 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789526229;
	b=ZxOOP4MyiWYQPMt3NsaPvDbJ3+4QktkvPDXJxfSRYzSzKx9C8HMX+3O6Afb/lsWMR+mYEp
	zm2XcqtzFRZjCd527RR49WSf9cD3Yra4HR5VGJzTQV1p1GWoylQFzqNK/GrZGelTpGEDTK
	KEes5MvcfvRKGylcjpitxvt+ijMXx3s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wKXPU0Wcw6q/lBeMO3JWvwqzNfMGwXt180u3XgCnPIg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789526228; v=1; x=1790131028;
 b=EpH8EBV+ay8NwgXGGEW2zNf2K3i9bMA2mmGYyj0zwd3on3Bz0I0iSdm5eLbG5xil2f8JV3iQ
 K7g8U8kffMph9kgyTL0jcL8BWEvm7r11RBMLGtJiLz2iFTWzMxvDiscpuk4efR+/Fe+ZjI70phD
 eFXEWVgkdzA1J7dHcaATgHj0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 24062d732f8de67d;
	Wed, 16 Sep 2026 02:37:08 +0000
X-Mizu-Trace-ID: 24062d732f8de67d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v3 10/11] mm: memcontrol: constify mem_cgroup_swappiness()
 and mem_cgroup_get_max()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260915-folio_memcg-const-v3-10-c239a6010b58@columbia.edu>
Date: Wed, 16 Sep 2026 10:36:52 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F6DCE04C-6EEF-4C43-A6EC-D87AAE376023@linux.dev>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
 <20260915-folio_memcg-const-v3-10-c239a6010b58@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Stat-Signature: x6h61isx34fk65aku6x89deq4idyok5o
X-Rspamd-Queue-Id: C4A2CC0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789526229-206638
X-HE-Meta: U2FsdGVkX18avkdGWkXP3wb1ZlfpBRh/KSnm8n2ggr6OkzNKQ/w+rq6Sf+0xS8Ga1hgRlwqIa/fBRPWexHFWxGYnEVSNy1OIsTiO8ntQ9WKW83o6wnhsvWZMTnhcqqAnjlK9MLSaoPkant3bLhjCNdlpFzh0lloowOhe9faADN9hWPnpGxkJmPTJh3SEqysP++Lv1fcEFxm8Br4TSl7ppx3NDxw56MNDjcXAYWgOX73HNA+u5xWpOGvDPm/QqEaqt+TofKzwvrEs3IOGQyou/LP8luOeYwa7Ot7PsQt3UOfbAsVXd+/6mnGCbS5GDO9FRon3Iam6NRGwfZjV9jXJeJoASAp+xXPq6Da/JdmFPCafx/BRC6g+ugDxgk6Ys/NFYW3jx8yivBPT/QwW0BdXuNluuTNDjIIrZ9KyEsfr+b0jHKMv0+Xrn+hbcgNZCZp9HY08g6ZNh32E2AYWWPk8oGFLuceYuG2XKA9V/V3TMVm2YWLM9OSuY6erWZx5+CW/lQ0vVq9O89UVKGfqDUT8LZpl12ilMQ4q/zu9Hamu9SpWDijTjGpxX3wdnMPq3EuMmNo7oacE6+8OQv1dVnYtWkOJ7v4uDswlC3Lxbe3/VDliXJbyilDJxY71bY7rZtBnwLvSzi2X/ag89Y3mY5URXBqz/xW0zfxkOY+T+1J83L5UjBiSwGpNjtEakCSKe4nnJ8pLkkE1n77zw1bYBT6F1je9NKuuO5lbH/SglUzEHr9tm9CDegmIqQJreuKhUs2PJm6R+J44Z3uEKQxy1ocKFf4tWcr8IJ7IKaZviP0F5DxOJqpji6hqMY61drJ9R3qr0DjVaw6UshOtqUAbcLNYwylAUDiglxMK7bJwYiDuues1Hbpm+TKY+8OuOpsDieydJX4wFGau6T2UXA7ZtImF9Cj05i3wM0KLiKQ1FU82IHNEV5I65mcBS78yF+ig9XPrGO7PwOegg/SlokFKUx6
 TW7b+OfD
 GtBzAVZccoFOmLa7VNExmBwYS/Rd3f+mYu+NeXmnBRTixzVoISp0/DHMxuxco0Q+F+UQGJfBQnZla77HTxNzpsEUX97CfnfJKrxx0vptJGKqRSiDpNVBV7vQxmymFMEtAmTVsag0/lyF/qW5MwZmFVvHDpOZ+dRx0+ZDo0vSz4aGdRJp8t74j/l/HoG76C51AI1d0EeMoiJ+sAkDzC9+aBMCOOzCcg+hKVNpASIKhSAmOHAzQDtgp2UVEKdZohINgShx5uQ8K9RStbVjnEAjVRRnJHe+/H8j2Abhm3T3qYPd6bLV/g4KwdU8lpR7s8RD7wtDXFUFZtKYIeP27KfxUCxL/fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 07:20, Tal Zussman <tz2294@columbia.edu> wrote:
> 
> Both only read swappiness and the memory limits. Constify them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

