Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114C2E98FC2
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 06:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B27E6B0005; Thu,  9 Apr 2026 02:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163BA6B0088; Thu,  9 Apr 2026 02:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079D26B008A; Thu,  9 Apr 2026 02:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E41AE6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:39:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 862C5E02F3
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:39:45 +0000 (UTC)
X-FDA: 84638066730.13.93368AE
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf02.hostedemail.com (Postfix) with ESMTP id 05C8E80010
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:39:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HVruHmuc;
	spf=pass (imf02.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HVruHmuc;
	spf=pass (imf02.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775716784; a=rsa-sha256;
	cv=none;
	b=b7APl6O8dPYVxdLpPemDY1cAWNv9eZe+Yk/IoyT4LAQthQVIpqhXI60j/Y/OwFqN31zgzB
	LleiMIzSfCwZele+IICE9P99beV9vkdAHY506W/UUDt0B0XtvLQIt2ltGd5nM46wQeqU5a
	USAz+nVp5+rsyDFSVmBtrPo96g++rcU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775716783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N78lPjt7aXe7hKjlWFavOXf1wUtS5jIPsg7votAOVsY=;
	b=a2mPs05M8Lh8u64UKpfz4Ls4+dAyF0uiqL4KDPewnrm8W7iiKFTEucVGMTbBjYREKLFd7S
	b+IgkkYyaraknenG3+ZqO1eaqiauXXWP6Pic1o7KMkRKOhEG0t842bS9SWFp8Xq6VO+gkD
	h3vHlNM3lt/j0EUEH0kvVwJgvyTRDko=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775716776; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=N78lPjt7aXe7hKjlWFavOXf1wUtS5jIPsg7votAOVsY=;
	b=HVruHmucQUVbKuHxHBwgZPIWMD1P7I6RppdvhJ9SoyLM5veRQG1ePyYQxQVFxFgdFt3o3NwvjGriIB8QxDSZUtdEiZLg4kZs7If1uJ9mm408MsiZP1QjwyLKbtAHjJ/G8wWX8ukLjKRBCCRtEMQ/VrnGp5JhMjzsXorvVUgV1rI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0hNpcK_1775716754;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X0hNpcK_1775716754 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Apr 2026 14:39:35 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Donet Tom <donettom@linux.ibm.com>,  David Hildenbrand
 <david@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Ingo
 Molnar <mingo@redhat.com>,  Peter Zijlstra <peterz@infradead.org>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ying Huang
 <huang.ying.caritas@gmail.com>,  Juri Lelli <juri.lelli@redhat.com>,  Mel
 Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
In-Reply-To: <se94lry7.ritesh.list@gmail.com> (Ritesh Harjani's message of
	"Thu, 09 Apr 2026 09:12:56 +0530")
References: <20260323094849.3903-1-donettom@linux.ibm.com>
	<87wlyqt52m.fsf@DESKTOP-5N7EMDA>
	<c571bb69-82f2-4346-9f99-6a7258e28a27@linux.ibm.com>
	<87o6k1ubg4.fsf@DESKTOP-5N7EMDA>
	<bd78aaa2-888e-4c27-964b-09f085161224@linux.ibm.com>
	<877bqgvs4k.fsf@DESKTOP-5N7EMDA> <se94lry7.ritesh.list@gmail.com>
Date: Thu, 09 Apr 2026 14:39:12 +0800
Message-ID: <87fr54y6wf.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05C8E80010
X-Stat-Signature: j9343dud9rp3oj1pyfez9jbms5pitf9h
X-Rspam-User: 
X-HE-Tag: 1775716781-616871
X-HE-Meta: U2FsdGVkX1/NOeKZFOpixKez1tvjWW149Xnk+aGCwYR1f8Qcwl+BtYSw5MYqBU3o/7UawHd7fRGId1GWTcSA85VA/muVP1XBg2xRSY4mEY0gSoYh42J8vRlTsDC+54H0ikb+fQzzvHX0AZJCmZUhVM16eFGQ1Wt5qu7Mfo8Gql8zOhTpv6qi3QHMK8YQ7TESEmPwNAadBCZuqOzYk4uYnXLlR6wywJaMDSorGEfOtmkx23xyGPjrBCssWv7HqtE8H7wLnUDcWH2b3EPXcBSvar925oVfdF7iqHvvky+Y8IDaQK2BJmKTEtqxMVLHE/+b2c0CVA0zskenY6XyJ+bcaCOR/2egQ0oTOEvxe0qFxfAcME1y8I7R5RGm1bfDxqqN3o+lvMLKUnFW4N2Ph4hhRwuK8B3r1gMgvnYx6ifDYjpk1GstT613bp2AjS41nqopEqYvpVDtw+k8dBkeV029ZaJ0XxyA9JRalgyVCRcTRTcxbeKIJZjqsvKMHLzF1QBm/t+Rcx7H1o6cHQl58UY8hyYE6V5V0GRUBFgzibzuewTHwI9FQvOIwpudAK5a0BNo80cXKTcbG8LaiLarAdg8BIf4G1jemOyhTXZWPF7X9QHE+JHuDWL+Im/QUnaWjepkbjlSHEZY2gUlZWJtcZY1rcRS9L1jm9U87KRdk46T16lOXA3S19QxmjdGTPTCWUufoSxMH8mKEVai9mUG85xaIVWK54BW0uuGoAXpDc4prqKe5SVUrCLBADtuAONOuPWa2zsfvqueNioPF+ErIEOOK43agKoJ4oJXUFvGODU235UrhY/orVXqpXZcul7DBV+nsRe5sD8kgmFr36uCIaEPngrS/QaUHQryo0mFCNy4q9N/YMh0aaun8j58lTrzCAv9qaSl8GA26NF3wqLVMg5GQ9tMyjHpchIoett64i6u2102F6sMf/9HTmzh04qwW0zhRaMBqiiGqXzycZUD8q/
 RMnL2f4R
 VE4Z0nxgXQp9CFgEnHWFMZxA0n+8XQWQsupRPI9r0GFXDOOp+7z5CLs7vlfRKpsi67+qksuCH/k9ojA9y1B1wCLNW3GkW05Px6xHvX4fJ+zv0kRiD1R7uSkzJ73TVbrrnWgD8a7fQ9WwiTau81r89k7Ky2xSFdhB/k1N5Q3dXWchOdPki+PqroIUFvBES5fljoTCAesWv/G6plLt3OOspqf9yG1sRHbnw6PNepMYqckAOAXU5OjZezWKx6dnUjDCUrsivt95bnX+9PnLczsgIRpYFZjES7zJejVuv6B9K6r4EVHO/dbgBgKiXDviWkUAef4315bhpZKTJG4Xz9YQ1cDnqn8ORMilOpObofahmGyupMj50rmc/HDql2986OrKSGIIa0DHMR1myBXUuKVbsCiPLeBSSPfAwu1CyGaNMKvwRXC8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> "Huang, Ying" <ying.huang@linux.alibaba.com> writes:
>
>>>>>> Donet Tom <donettom@linux.ibm.com> writes:
>>>
>>>
>>> Thanks for the clarification. I was running some experiments where I
>>> only required migration, not promotion. However, I observed that
>>> promotion was still occurring even when NUMA_BALANCING_MEMORY_TIERING
>>> was disabled, which led me to believe it might be a bug, so I reported
>>> it.
>>>
>>> As I understand it, enabling both NUMA_BALANCING_MEMORY_TIERING and
>>> NUMA_BALANCING_NORMAL results in both promotion and migration. Given
>>> this, do you see any concerns with modifying the behavior of
>>> NUMA_BALANCING_NORMAL?
>>>
>>> With this patch, we would have better control over enabling and
>>> disabling promotion independently. I would appreciate your thoughts on
>>> this.
>>
>> IIUC, we change the existing user visible behavior only with strong
>> enough practical reason.
>
> So what I understood from this discussion so far is, we don't have any
> mechanism to do auto-numa base page migration between DRAM -to- DRAM w/o
> triggering promotions too from a lower tiers to higher tiers.
>
> ... This to me sounds more like a broken interface.
>
>> If so, making something conceptually better isn't enough for that.
>>
>
> I think Donet's approach was more towards fixing the problem, then
> making it conceptually better.

To fix a theoretical problem instead of a practical problem?

> So, as of now most of us may not see this
> as a problem, since not many systems have different memory tiers
> attached. But with more widespread CXL adoption and more memory tiers in
> the system, we might require more finer control over auto-numa based
> page migration.

By design, normal NUMA balancing (not memory tiering) should migrate
pages between tiers too.  Because it migrates pages to the node near a
CPU regardless of the memory tiers to optimize NUMA locality.

> But hey, I just wanted to voice out my opinion here. If we think
> changing user visible behavior is going to break existing applications
> and we don't want that - then in that case the reasoning sounds ok to
> me.

---
Best Regards,
Huang, Ying

