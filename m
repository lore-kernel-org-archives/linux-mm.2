Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32064CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0828E0002; Wed, 24 Sep 2025 05:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677A68E0001; Wed, 24 Sep 2025 05:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4668E0002; Wed, 24 Sep 2025 05:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 457468E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:10:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D643C4355E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:10:44 +0000 (UTC)
X-FDA: 83923573608.15.ACC2AB0
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id DBD7B100009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:10:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X31usdp7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758705043; a=rsa-sha256;
	cv=none;
	b=OO7YYNqquzlIqJap9aSyUBeYqnuUa13IWo1nHjyCz2xfqpI0pALjf3E8jiGmcM963rC7IE
	oFvUtBj+Hz3s/bs/3s5/qlyMMQB0OurIQwsA1/34qct3h7hwfFgGNFKEx0BuGrFSKNI4Em
	cT86kIWUQIW9ZGjjvw/3p49PYcE2Pwo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X31usdp7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758705043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUDySOv7HlKF+HxWT2OI3uXw/DzQu4hAUfLskiKMf/0=;
	b=Y/iTCK6wDANWbqiLhHrXXO8+cy+TH7k0y2MtP7gJI2mEw6sNvxRfwTdPVJnrf94eBVj0We
	l5VbFk2R6wrJQT5ZhEqC2mKmGUC2fBCdqWRaTc50wL4Zs2ck+LIT0ToFXTsJjgTuNp54Ma
	GhbHCFr/Sx3rnL3h0coUBIV2VnvdYXU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758705040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wUDySOv7HlKF+HxWT2OI3uXw/DzQu4hAUfLskiKMf/0=;
	b=X31usdp78cFCydE/T23Kxzp5auuT98YsCa/7QC+DzzcjhZ9cNLbzgf3OHvBQoxaqCa1HnU
	1Kos01djZWNlz7HEv9WtbVRfkDdzNQLcPzWtVm6RQ7BrWVhQSghLLvZGXHCChG2PZ03USa
	9pHOsgKsWxY6wWXuuGVHsVZjJOt+ucU=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: hannes@cmpxchg.org,  hughd@google.com,  mhocko@suse.com,
  shakeel.butt@linux.dev,  muchun.song@linux.dev,  david@redhat.com,
  lorenzo.stoakes@oracle.com,  ziy@nvidia.com,  harry.yoo@oracle.com,
  baolin.wang@linux.alibaba.com,  Liam.Howlett@oracle.com,
  npache@redhat.com,  ryan.roberts@arm.com,  dev.jain@arm.com,
  baohua@kernel.org,  lance.yang@linux.dev,  akpm@linux-foundation.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  cgroups@vger.kernel.org,  Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v2 1/4] mm: thp: replace folio_memcg() with
 folio_memcg_charged()
In-Reply-To: <0ac716fb7fea89ada92ad544f88ca546e43d1f29.1758618527.git.zhengqi.arch@bytedance.com>
	(Qi Zheng's message of "Tue, 23 Sep 2025 17:16:22 +0800")
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
	<0ac716fb7fea89ada92ad544f88ca546e43d1f29.1758618527.git.zhengqi.arch@bytedance.com>
Date: Wed, 24 Sep 2025 09:10:07 +0000
Message-ID: <7ia4plbg6wsw.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DBD7B100009
X-Stat-Signature: k5pxh44957sizrz8hduzswk8spxp3u8a
X-Rspam-User: 
X-HE-Tag: 1758705042-662390
X-HE-Meta: U2FsdGVkX19mtREzpmKcA7XWoNgG4iuUUzI3e2WAipVFgK/q5WuInW0AeEDWXJRBoaecccDwB+BUnLAGn8mOYph4IX+IhRgCtGq9kBrbspF9rHcURRs5gySgue3duBNucTAJQvq4rbHMrpm+j/8tOW+LcBLBj20psXcZDVctagOIk63fIs87XhtZjTzfjk+QmZJNyyjbKoQ8ozWOmFR9lCSyAH6mNhIlVhwZt1RBrd0/6BJuldofytI09+TiypkFn7XkLzw/CV3C9isjIP87qy2JYwXYCID6VRFA+1cRfLAgxpQgLWx6xEtn0xrEFjd2sfath5+QZN6IjKYdOjPVg5YvSX/QU0xvsYWD9Eims6qqzbalejoX/opDgjEDYOdPLsfiwe5Fq98+AmqlUwSNT/KI8OSirbmMFMYmJodm+ZFebyry4LSmgwh6+CiWZCYXCea4UUBGvCb+yxaFfTpU3ta+nb2zr+5qdlC838GN4H6znJAd5dbdGhffuhO/HUxdHrr0lSKshZzlSzscuhcTA8OUWWSwBi2AobrWA/oK6QiasNS/lQnVzKQbKmdDpztXIuwJEo4+UrGqG+ri7a+Y6V18xGtg8G4fWx5QHI5YQDnmONbhzqpZ0J3dTuNp4lFLAxfgVpoiWcVmT/kAvsVSfTKqID3wFvVNG/UaL8WoXHW/ldRLtOqzRXlmYPiQN5zBEFkB0A3KEjSDFasdK9ML/ytCb3poQadoLOLehdRQyzrJ8bhjj9L9O9ZwqXF6uwJKd7xwgBlD4WEGAZNqMPa8ZfDVsUkZTOPI5zIlUwzb/B+2d2z91SKHf3z23BoV+/HZVtFqAOrSb2vE/lRsi3pyARxW9FQ9KhwrxV37TGH9mnqXRCQOyAX3SSettdRPql6qt6hQ15i6cRLvBLo4/q5Kf7lqwlf4FUAjliYNIExlZab3XrY/3+ySobf0Euz9eXO/PP6Rh81FwzzXoH3YmR1
 YMBaF+lR
 bM/KSyktQMF8qfLTwmKW7rYeVeP5apTb0KNoI77o7cMLoyqEObsXHWZDnbpHjR5m4vlo23lKI9g37Iv5MUnJsYWqdvkPTLbFGxdonCwkWligHq6ReselGxFjYq340INqEPz3mOebSWCzZ/pgv1FbxA89Zw/CMFtu3lo1WLB/huBZnvVDmni3Mm+EV8idswhsCIAOiNs6TlpMQJG0XJ9Kn+sbSikKXaN+hqA982H0Je91CHB1MhMgqdcs/DOuUVemz7UBkpJj42y+XorbpWGpHNDnvjOt9c2e9ZJ1JNqmzxSCk2pJJ1MPTM53ysQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Qi Zheng <zhengqi.arch@bytedance.com> writes:

> From: Muchun Song <songmuchun@bytedance.com>
>
> folio_memcg_charged() is intended for use when the user is unconcerned
> about the returned memcg pointer. It is more efficient than folio_memcg().
> Therefore, replace folio_memcg() with folio_memcg_charged().
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>

