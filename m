Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD38C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7FA6B008C; Mon, 20 Jul 2026 10:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FD86B0092; Mon, 20 Jul 2026 10:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7F96B0093; Mon, 20 Jul 2026 10:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47C586B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:02:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE036A0258
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:02:51 +0000 (UTC)
X-FDA: 85009320942.05.E7CAFE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2DD1316000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:02:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Djn3dfxO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784556170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKKxZDz+u8LI8/34wYmR2oM7z0KSY/HN/W8OYGduMZk=;
	b=xgwxyNAKx+p3HSrp44SP2PIVM0pd9gEvIRt2Z8EXRmrlTzfvmRhtRVH87kjieCi/PrvOld
	TcTtxMwrHcKg9O7ODgqBul5arQ38jpSiY3eTzTJweKHTpsv0RoEm0fYocRl7L3PK8Ct2Tj
	9L3b9GU8YuymM1eHMSWnm0ltXJ4kkVQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Djn3dfxO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784556170;
	b=GKoO1VR04YGjIGHsG0N/NY8SncYEmc1RiNkY/KIz+LNv/JEk+BM8OHbanDy97ZbemIzPoz
	l1lTXkLEoSYC/GtKYmz3JQg1eH1HSO87SEwZZfbBX8TX3rwN3tjgIgPvq7CNFokk9B6WbY
	NMjxzGl3bIS/ZVjd9J+2mvN6VJPgp+Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77CF260103;
	Mon, 20 Jul 2026 14:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5ED01F000E9;
	Mon, 20 Jul 2026 14:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784556169;
	bh=yKKxZDz+u8LI8/34wYmR2oM7z0KSY/HN/W8OYGduMZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Djn3dfxOSf7mNj+ZvGG0w1kmAwKAGVjg3iwG1qimaK66yMHkvyQ9hRjcQ2wpXoLRt
	 U9QZzHtvoOAMcgxl0MI/3H3z5no5G1ufwRoALeu50vtYeD6kVmdogknz0X1ADi9g5m
	 qqRkAddxQ8PJ8AkkO4jznYwEwtexaJ0FjIzXHLZf4i1J5DJ75O0OHDsou0NtSCK13u
	 Y1xGQ63rzlvBBmo3kjBPDVZ5zB2jdnx2u0IrzMhBgtXCupXpzMc8dJelrWfXS5QA6r
	 REmjt54GuwOq2drvFtSI8iA/WM0REVH5fVTlMm78xhf0Up563EvkvuJ7TQYwArwtss
	 TC+DNe06SxYhQ==
Date: Mon, 20 Jul 2026 07:02:45 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Paul Sherman <shermanpauldylan@gmail.com>
Cc: linux-mm@kvack.org, tj@kernel.org, vbabka@suse.cz, dennis@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/percpu: allow embed allocator when total size fits in
 vmalloc
Message-ID: <al4qhdtunscCLpOG@palisades.local>
References: <20260717231616.9126-1-shermanpauldylan@gmail.com>
 <20260719055928.1939-1-shermanpauldylan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260719055928.1939-1-shermanpauldylan@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2DD1316000B
X-Rspam-User: 
X-Stat-Signature: r99yrur5qxiyr4g5dzxoiqu9p457y184
X-HE-Tag: 1784556170-333652
X-HE-Meta: U2FsdGVkX1/D3qqbIzclIGsNO48vPUHJzIZYgoJtKPujKCueTe+PxogD1dw4uDxt/8h1ISNAt4jDKVf1FlP3t6MpRL+HwdXDfQh4W+JeCjcpqK9icZQf7IHRbe4Hr3Qy+NVbJR0AvtDIyRfNaikb07K2Z1w3/GOaRtkPbzeM/zvJPcaJJ3MJg1hyzJO3GEBnBlh3BJTk3LhKD/x6zavo2EwkntrU+Oe91H9AK1zuSQ9KB3USf6tjq6m2VG+33rXsH+Mu9raIlGvOf1p1wLMYn2mUdTvRVKO3acgxGWh4lluZJtfO7N+yQt2rpdvN7JzsDeHRTYCdXsdojLAAZ5UTxUD+eooohJJ5/2NQOZuL4mP+3W/pjBSM3NlxIbgsZ0iH7c97cz/ErIOurWjWL8rLDzOhhRGYlV8wank3UbcAUDEkcFBrVCQcR+OD3os3r/nyOupUSxEm7GILL6pqEzYFQOWCuz7AXPEEoFqZOSrjrexnX35wW8bEfBAQfeoISt5B4yx+Q6on4CL94oTZlT2+HyHWkk70WtgRPSH1IY2N7tjuyr1a7PAMm1mZgXRP3n0dVxZmUvBRkgzWWLFA8htzXSI3bSVzaSUI3pF3Fsc/xgE2Ty/ono0gV7Ml9KHm9VIJxXues+NxU7jYQIOTQ/6d04aAM+selJEJbHuGX1nk70HXyyjaNP3lS7m5M+x4UOkXumP6MZTLPHyI26T6UEr2ncgbh0QqZ7RnrBr6Ew3cynDOI9+xHSUswnOuRbtEHu42VPiz3Xud5+ijPuBeE3bKGA2bFBKTIRmElov7WF3nx0D8QMs0aHKSPvzQsCuuI10vAseuGt0NdG+bSKPuUrQ3mmZ6/mpcS0a6LCMYNo8WxYRyNuUKVgALwhnFWbtymoXEFqtTDO1peS98QbsMjxoIa28kLvnvoDViok7w/XfrhjKSt5JyYT0zpK1LZ2cmlRvW9AA11NGVS9DaKnCpA3n
 aBX081+O
 Z5G1Z9Mqhxas4GII7nZD9xDLdzKQBi6zEM5TRTUw6XOMOqLbLOg74EqOzGoLWgsYu6M4RWbU6v+qNBQbEaiuV54M7MKZbYe4htyHINN/MomZPaNb+QfUAvgoMk2t82I04JtoIDOQOhb8b5WvzODi7H+sEdQenc29BEWj0vfJmEbVhjPtfBL5e1sbF5BW5DUdUFrJU+68Q86+7GtTi9l78m+chMB1Yyikp1MqUlWulANvr8n4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Paul,

On Sat, Jul 18, 2026 at 10:59:28PM -0700, Paul Sherman wrote:
> Andrew,
> 
> Thank you for the encouraging words on the initial submission.
> 
> Tejun,
> 
> Further testing on SG2042 (Sv39, 4 NUMA nodes, 128GB) showed that
> the proposed change allows the embedded first chunk to be created
> successfully, but later dynamic chunk population consistently fails
> in pcpu_populate_chunk(), with warnings originating from
> __vmap_pages_range_noflush(). Reverting the patch eliminates those
> warnings on the same hardware.
> 
> Looking through the code, my current understanding is that dynamic
> chunks inherit the first chunk's layout through the shared
> pcpu_unit_offsets[] table, while vmalloc reservations are driven by
> pcpu_group_offsets[]. That led me to wonder whether I've encountered
> a fundamental allocator invariant rather than merely an implementation
> detail.
> 
> Is the requirement that all chunks share a single pcpu_unit_offsets[]
> layout fundamental to the percpu allocator design, or is there an
> intended mechanism for decoupling the embedded first-chunk layout from
> dynamic chunk vmalloc mappings?
> 

Percpu memory is essentially an offset-based virtual address space. We
build the unit and group offsets when setting up the first chunk at
boot, and those offsets remain fixed for the lifetime of the machine.
Consequently, every later chunk must reproduce the same relative virtual
layout.

The embedded first chunk works because its sparse addresses already
exist in the linear map. However, pcpu_setup_first_chunk() saves that
layout in pcpu_group_offsets, which is subsequently passed to
pcpu_get_vm_areas() when creating dynamic chunks. On this machine the
resulting span is larger than the vmalloc area, so allowing the embedded
setup to succeed means that new dynamic chunks will fail once the first
chunk is exhausted.

Machines have grown considerably since this design was introduced.
Supporting an embedded layout like this would probably require a purely
direct-mapped backend, with congruent physical ranges reserved at boot
for future chunks. That may be reasonable for a particular machine if
percpu growth can be bounded and the reservation is small relative to
available memory, but I don´t think it generalizes based solely on the
ratio between chunk size and total memory. We would also need to
guarantee the required physical placement and decide how much space to
reserve for lifetime percpu growth.

As is, this patch isn't correct, but it might inspire new work.

Thanks,
Dennis

> The answer will help determine whether the correct next step is to
> withdraw the patch and instead document the existing invariant, or
> whether there's a larger design direction worth investigating.
> 
> Thanks,
> Paul

