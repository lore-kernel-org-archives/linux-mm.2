Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C6C6C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 01:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419496B0099; Sun,  6 Sep 2026 21:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B296B0096; Sun,  6 Sep 2026 21:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290C96B0098; Sun,  6 Sep 2026 21:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 024B16B0093
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:21:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96A4980616
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:21:03 +0000 (UTC)
X-FDA: 85185212406.27.AAD857E
Received: from out-utut-a220.jellyfish.systems (out-utut-a220.jellyfish.systems [198.177.127.220])
	by imf09.hostedemail.com (Postfix) with ESMTP id AAC52140004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:21:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=geXed73b;
	spf=pass (imf09.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.220 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788744062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkjOJ8d9UxyvE5Qfn/krUAerwaGWls6tFKcLFeq5Vko=;
	b=O/StzL9rGHdiXiSuWdKLoicV46vtI/s/9xZz7qHnBBahhQ20HF+gExObLY3T9GV7quDdS5
	IomVStYwGNJZcsHuixMzfOdiVRH43d5OwokjsgZWYuJvbR6LaK0LCoJ60Fp+An8pvYWfKS
	YyOUJQoh6YGcdJGhC1SbwqSpJOtrD6U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=geXed73b;
	spf=pass (imf09.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.220 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788744062;
	b=iTLDkDcDyxe+rIG3apjyd+54NkLUwjlEkj2h+n6PIWpQtVKCElTes+/dJcvfh27x9XPlLw
	cFFF/5t+nS1G7x6kuH+NA1jzQvkF1FvfLmLgaQKwWI7a5c4kDN70wMrzd5Ko7hwbwPcFUO
	BWz6Tu0IOXr5kVxm/hWJCIDMiCJZtcU=
Received: from 192.168.5.3 (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hdTm04Gnxz8sYC;
	Mon, 07 Sep 2026 01:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788744051;
	bh=GkjOJ8d9UxyvE5Qfn/krUAerwaGWls6tFKcLFeq5Vko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geXed73bo5RZf7V0hiBSN9VVo8tY/wf6LuU6zJMz4AorzrH+hKKc+eJJBA73RKjpJ
	 bQMuBMPDDfXfkoPpNh4xqcA3/TtZxU0RqKf2Bd8ogRPnjoEmKGE0VllSsMrkiLZ2y6
	 7aIzum3Xk0vyUXZ88z5b01fKUHRP3nJgmYaADPL/Wa/KEAL7sBYeM/1Dqgn0AvvTKS
	 5h+zgpjMoI3xeyHoXvRzFBk2EjmCgJmap65SWNyqBOU35nvYjxiKUAd9ZahJ9WKFMH
	 FFLoZ80+mGOYUfnFFn8BvY8h0RAGvO7YeQfXT+B9v2On+xgbsYNDtH7B9LVsiXYupr
	 Y+lBKM3/umCaA==
From: Tianyi Chen <hi@tychen.cc>
To: rppt@kernel.org
Cc: Tianyi Chen <hi@tychen.cc>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memblock tests: model the low allocation limit within dummy memory
Date: Mon,  7 Sep 2026 09:20:46 +0800
Message-ID: <178874362960.1415955.6166620868270535729.memblock-review-reply@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <ap3LTQlKTpDbAEJZ@kernel.org>
References: <20260906144011.848898-1-hi@tychen.cc> <ap3LTQlKTpDbAEJZ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Stat-Signature: 677yp3o3pii81aboe3k7ndh6s58z96m8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AAC52140004
X-Rspam-User: 
X-HE-Tag: 1788744061-902500
X-HE-Meta: U2FsdGVkX19zuh59qRp3fO5I60cSrEeiY/REdtpVsGQl/qYGIFhp59FgZKAPoy5/gGn2cu7e7dEHOkH049IPX7W4nm+xFW3/F486OMn4lqEaFBIaaQSdnZBEI2/OMmXTK0rpID+znz0ACGTDeaVMcVMuplXnNogleQuCxhIhaf0nzO1BuVP4TAzr9KiQsSk3Yu9quXxwHSxz+Q6L5L8550x3kPCgH5MYPJzQuh5rawmNqkrO2PJy6sTCUsvz12qMR1kR/md5a0ol78J0BJrBJXFPBt2OaTgl/HiMCXL/J4i19UY1HJsTjdJDjBVFm9yzcEqBWR2YvdAv/yAp4ew+Tzd9I5QTtmI2u/3giSA7zIWPbis8ZvJK0+4bceBQ+ZLfOal0+VbA5xyugzKl8lKVrGvvB5ByamEpsda3Q8+MXs6ByvGC2mRIgDyeQNeiw/Www5dI3sbmqdyCcevHFCVst3bNIq5IPG5UihQAtfCymgYhlcyyZSNOI2xnr8boKW84kqYBTXiK1apAOzqT2ojWh2qRaYry0vklKhVgwfhLE6MkEmfpUd05xNwA9FFjV5rd3BBgoo2caSmtxEgblVR6jnLCgSXo7Amk+vzSzQ/EVNsBxT67dnUx8B93S/e1mR048nTWq77W70d6mo8HPxcPUTeJG11+loJJ6sxr/ZHqyP0fsEKvMt/+nmBJ8xxM/hTdwnKhPxSlQGXxs0BCsXL6nq1xCrm6PN2xEq9X7NCyYfFjptpQN4UMBWW9wCmJvc4EIaj9gEwIotxSYL4Z9b540F+gQWp167LJ/dCh9ITOqYstRAR7AMAw9tAPH+hsr10hUpyiveZU0d9CzpfbrklXV7VcAN/UWxxMvX01kFGkazS0rrR1MeDJhV7AlgMIDR0mJglUChOlydVIUwW0U5V8nT0ekbQi5GnWLwyc+TwqZylhy98cUf56G164jlCGwwZ4J2XNfbG5numgohxmH+C
 5VhDIQP6
 uD6ND/rWi0ZQoosTk/79RCc8vqruTwvKxFbXGgeDNPf8J4M155Oo8ImxjfEyYC5+JREStFsFqrvT3Xl2Jp1u+4Xx6bxz/5Q0OK8UvWfbUqPe3vpbmgVAbKvJgdrklMXVp/oz3Ew20Pe64Rvj076d0tpAtSDSC9mxghZa+5mEm1pyI1ZubEpD/DcwTHfzo/suCCJF7ewVmSdT8wsjd/1Tumo8oMFs++ZD65JBzDtzuaqCi6X5OVfTz0+k8Rv8ZHUAcahEnDmyYmQyDSPSBo1XC1xxdYrNoUkW12TWehIMnCiI8Ui/gVPW5vFxPe39bCDwl8Lo15NGzaOLSTH7iICAjVXjL8vw/004KNWAe0FtQSCPw2NHjK8Fvi7K1uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thank you for reviewing both patches. I have addressed the attribution
and wording in v2:
https://lore.kernel.org/r/178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc

> Shouldn't this be PHYS_MEM_SIZE?

MEM_SIZE is intentional here. setup_memblock() registers only MEM_SIZE
(32 KiB), although malloc() allocates a PHYS_MEM_SIZE (16 MiB) backing
buffer. Splitting the registered range leaves usable memory on both sides
of the limit. PHYS_MEM_SIZE / 2 would put the limit above all registered
memory. The comment, README and commit message now explain this.

On the alignment question in patch 2: the registered base is the malloc()
result, which is not guaranteed to have SMP_CACHE_BYTES alignment
(32 bytes in this simulator). ALIGN() also matches the allocator's
round_up(this_start, align) in __memblock_find_range_bottom_up(); it is
harmless when the base is already aligned.

By "exclusive limit" I meant the first address an allocation must not
use. region_end() is base + size, so equality with the limit is valid.
I have replaced that wording with the allocation's last byte being
immediately below the limit.

You are also right about the reserved-memory comment: reserving low
memory succeeds; the subsequent low-memory allocation must fail. I have
corrected that description. Both patches now use Assisted-by: Codex:GPT-6.

The five configuration combinations described in the cover letter passed
with ASan/UBSan, movable-node mode enabled and disabled, and both allocation
directions. The cover also records the separate, pre-existing BUILD=32
basic_api assertion failure.

Thanks,
Tianyi

