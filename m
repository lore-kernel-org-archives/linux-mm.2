Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 959A2C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8010F6B009F; Tue,  7 Jul 2026 07:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B156B00A0; Tue,  7 Jul 2026 07:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658D66B00A1; Tue,  7 Jul 2026 07:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3495F6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:08:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEA07403EF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:08:15 +0000 (UTC)
X-FDA: 84961706550.21.559EE3A
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6DDE040006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:08:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vvDpW0xf;
	spf=pass (imf12.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783422494;
	b=fcDHttF9R4fRiDs69e2sY4RPjvTqk8yBLhjuPwbdHGAk3NVlXW406qBPljQewo221bqM2s
	MaHhQval6PPlz41y2Tcx44HjT3/IPpey4gWqZsGziufV3pYbAD1UElOMVg7k+0VIKvCL7H
	24ZyZiene15zXrwbHIHXBijuNezF+wM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vvDpW0xf;
	spf=pass (imf12.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783422494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ao7EL9LJmqoFPIpPMnfYLwye1FreZjwPxf1v+Z1e6zw=;
	b=2j7+jFA/hgTIRj8XI3qGMbSnTw1atF03dt+RfgBqzVYoxIei9mXTjtj3Iuw9PYIiR++s/9
	Ymh36OR4qnU/lQeF9ykp8TH1NglxeASnBbVZhZsJ3w34ALV5/1C8rZMjVlKpM4pGkoztjL
	XGaxMlWlf0SFcRM2on2QNqNQjEXCQb0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783422489; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=ao7EL9LJmqoFPIpPMnfYLwye1FreZjwPxf1v+Z1e6zw=;
	b=vvDpW0xf39THN1iby3AmkOxCHrCjvo0mNSoF7bAPlZRcJZ8AiZ6ETV4RBEuXw/GzussjJCDGLxY6jhDOtm/NgJtXq9BYejhFXsnSWZzEz765QESqw4vdFTOcctGDJjNLRo8EVxI8ZQPexWmVveSQulwoTwT9slnSUY17xnYDqj8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X6dH8g._1783422486;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X6dH8g._1783422486 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jul 2026 19:08:07 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Kaitao Cheng
 <kaitao.cheng@linux.dev>
Cc:  Andrew Morton <akpm@linux-foundation.org>,  Zi Yan <ziy@nvidia.com>,
  Matthew Brost <matthew.brost@intel.com>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul Park
 <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,  Alistair Popple
 <apopple@nvidia.com>,  Naoya Horiguchi <nao.horiguchi@gmail.com>,  Andi
 Kleen <ak@linux.intel.com>,  Muchun Song <muchun.song@linux.dev>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Kaitao Cheng
 <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2] mm/migrate: Avoid copying hwpoisoned folios during
 migration
In-Reply-To: <ea713b4c-b248-4191-9ed2-c9e2d0f83ad9@kernel.org> (David
	Hildenbrand's message of "Tue, 7 Jul 2026 12:08:26 +0200")
References: <20260707090136.52904-1-kaitao.cheng@linux.dev>
	<ea713b4c-b248-4191-9ed2-c9e2d0f83ad9@kernel.org>
Date: Tue, 07 Jul 2026 19:08:06 +0800
Message-ID: <87o6gjnjl5.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DDE040006
X-Stat-Signature: oqb4mhkyfzswkcho5kntnez6rjugouzk
X-HE-Tag: 1783422492-986019
X-HE-Meta: U2FsdGVkX18F/3k0dtKCXCAoC+BiN28TiqofvRX9qkUh6RkRJQJ+fWCrm4alrKuuekCsa+6sGY4OtXaNUgg1jN+akHPdRLUUACIFP/wST7+dgJHftd7FJrmFVf3ahrhkHIW2uZPF8BhyLFh1kec/3xS65lvcejmUQI0XvlW2PgzDOZnapwxvYvIl7mPwxPcqyEq9uf3cC/Ql/fK4GGrX9M67Zr6Rb8LGeGtl1Pd+k1Dh6mKZnFYfOsgTsVhh+9ofjnYrsLlXvEcETzqfMz4q6O46BgpRUOUDLKh9Fb7Oj4FNwkM494b9BoKtNht3yuIcuFC3Jc9T56fiTwDkWxVgTt4UvmOXasKYMXnuDpZweZSGOWsROdX5iZ3o2I5J6H9r5ewg4LlDxHm1jBiDhJNulHFpA4FGe+J+I3QgDJeM1UJYGuqDugCBVZ/PdSL6TSkyk0MEMxa873M6TlsSXjjAjScRv4dSs3x7QtRtAfLTT3iKddZ7Qfl+gng14/Som4CQ1CakMp3DM9MUDz4Bf8tu2AvXywXnajVl178O+tktOsV0kKOLrfXLtBEdu+c2+5WXhZD1RO6donyQKFurKcwoqVjOtDncuoPkp0FslBu5fSjOYqo37HU2a+hgLQyJTr+q7XrLQODYaVXuS3oj/Lwp1pDWYMmkOlx7XhQnwALEO4xxz7CGD+liGyX4CO0MGypkXc+ssp4NoN81Eo6istj0+2VD0NT8I++Mz7wCkOY0vRx5bRyiJcjMsK2Bqe3tnTsVPShgo7+GZICjmlSVuD/96Z6Qyzjy1/2p8rTIQvwFCuMGp6EqGQzlYO7kSyhGqQhPHFZJGQVfkmgjk0/BhTRW0UZ19rZId0fKm/DaaG7fC7PAT3HEDwR742nLBqRdgznCfmHbrG2y/usX+m/fOk6AVFHrpclkgli3+KMGfujBBPXRYwpZunpga+hDHGxcZZUa3Rkur0uuffYEJGt7BVt
 XYmi0fXM
 zsfV9RbEvwIQFpH9igWVsQ6AqNzjjF6s1uKXZsLvu+6pX2cum8LVW0YbCEmSHUQJLUSHHCDA4PQVnXLEtGqFGMVhddBfNlrua4bNQyy4sCy3zOzwav65GtBClO4pMP4fTOOw1z4zu31IMMPSpsg2esCJaMNfvePwUYUHeAyffmAmEuxtAGZBLC8JH4S5TiTNpgIuyDTjg+0msnQEfPycwjHLweg9JB2+hJ9VJgM6mINMsA01VX7hTcmMh3S1JCoxmvgbvrvSUeCCbDv59V76k1IvcO5sSdAjSTHU7yktR1wRxkmMCRz7V4fNyg7UJDJen1ObTpANhfyWHaIys7vj9CyVXuDL4HI5NMqlOnxgOLS6RkUavS22g0ffpPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 7/7/26 11:01, Kaitao Cheng wrote:
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>> 
>> The generic folio migration path can copy the source folio after it has
>> been unmapped.  For normal and THP folios this goes through
>> move_to_new_folio(), then the filesystem or anonymous migration callback,
>> and commonly reaches folio_mc_copy().
>> 
>> folio_mc_copy() uses copy_mc_highpage(), but architectures without
>> copy_mc_to_kernel support fall back to copy_highpage().  If the source
>> folio already contains a hwpoisoned page, a normal copy can consume the
>> poisoned memory and trigger a synchronous machine check.
>
> Well, but the code can still race with memory_failure() IIUC, so it's not really
> safe either?

Yes.  So the better way to fix this is to implement copy_mc_to_kernel()
for the target architectures, or to implement the trick in the fallback?

---
Best Regards,
Huang, Ying

