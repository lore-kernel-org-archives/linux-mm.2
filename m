Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21623CD6E57
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 16:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9406B0156; Sun, 31 May 2026 12:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453216B0159; Sun, 31 May 2026 12:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 341BB6B015A; Sun, 31 May 2026 12:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2102A6B0156
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:59:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCB03A0459
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:59:28 +0000 (UTC)
X-FDA: 84828326016.27.292E3A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 32087100009
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:59:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMsr4u3h;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780246767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrT+q/sFejGms772rTU3bPFIOL/KvZhb0vOS6qeCZ8I=;
	b=Vw1WRiF/j7AcFA8ZUE26zJSGf6zFTBhjYxPMeIiODZEwLTKVi+K/Q+EtU6fOTYUCZdy+cy
	1wUg9goOEdcD1yLvx/cIm4hwW/D+tqdVdr04KlIUkqQyf8njXkovO+Mq9Gah5feKEzNVLL
	3vPtm2Af499xWixz0kTEFmS8Y7gx83c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMsr4u3h;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780246767; a=rsa-sha256;
	cv=none;
	b=JF/6zfCOQgv9i27rH5Vqt1GLHSMQZ+LyEuQ/NCF1mzG8P4aA2md1YkmXEiBD0xsr+DNJMj
	kJ8M4FoSkTfccaZOTYbyvLWOJ8GfDU9A6O2urrr0Pp7Vfu205HYwmY7q6Vy6aXNiedZkmE
	YVcWOZURv8MN+RiNf0mF5K9qIDdBEPw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E853435FC;
	Sun, 31 May 2026 16:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F071F00893;
	Sun, 31 May 2026 16:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780246766;
	bh=nrT+q/sFejGms772rTU3bPFIOL/KvZhb0vOS6qeCZ8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMsr4u3hZLzTZFrTd6WQOzGuUNvqjWRPyTyjgyKhnaYW9wIaCnQVEkMvtMFsCHYmZ
	 QC5/K9t/6KKkHZKrZFzw4ZP4Nw8/pTs3jaS9MG8n3np9c7wQoe8JYI8ibIkV5zrHDL
	 Q9QwZpK1O757FvlkEBqgB4uGZ9n7+rOunVbz1k88uj6OLo/xPf+w9zSPEZcYLrl+RC
	 AOc+WhBYSDGPw5YpwHX1CUgHMWEluii8ttBMIvFJoyeMMI0Sdl4GdyDyYYHNGxeSHT
	 YumtZ55eaTLZ1cSpF3x8pl1FCMV27JWv5shf/05b4Lj1CP9f7SC1Q/NKOxW8HeUyPR
	 yHc54751Te4Pw==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH 5/5] selftests/damon: fix dead code, skipped checks, and broken lookups
Date: Sun, 31 May 2026 09:59:22 -0700
Message-ID: <20260531165923.99684-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531091724.84381-5-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32087100009
X-Stat-Signature: q8wzqkegpkuokrqxzxp8imjyc98k6g4d
X-HE-Tag: 1780246767-801194
X-HE-Meta: U2FsdGVkX1/Ea0D7QiPuzJNCBu7Y9qTcvTe27buWBe5xbM59KNSTIdMXopHKMRl+i6zvN1TVyMSyVASiTnHOpN73IQS/owrLuG/A4+uj9w8lGEUtCVckT6hqoxfxc/zCd6rJFUlbBPbeObUhuh82ZW8h5Rntw5zcsSv8z8xfxZftFtByJb9G/S/FcMIxjaN25PFVKwTTOXNBw9MRqRgwL8UYOnBk/ZrV1N9316JM4an4R1FAdag78wK4YQgMAZNj6qMYfcVOG1GPtiG0sYB3BO+phreVP6cDPSeFRBqjFgR3xySfPU5SRkhAFaNznD+Zw3idQCSRiwonXXd1AzqFEnJLyAAdK2A0de9PTtgo3W/yJF4aE999G4Nu4GysDCGITCQJLODCbTOzqNJ5xWtJkKa5unzMCG9eFht+84GSNQwMPh0woadEHcm2lAjSsEpPXQmX55dSja0GWOA9Q5fc9BigdIQLEPo2RlApKDrJsuuw4GhZKD3V0BkBAD1b9H9LY4R2fEnLlID9KVfiGRie2Med9peRd5C0CqiJl6vcfmyZ6Q+i7q0Hxk9KnNulAqRIQZPMDtqYM6GwN27SuQ7h/FoiaOgX45eTOL1NgqpRho6ssWwIiF/5F6UTB2MhcjkBcWKFRrRsIugfPOpFabDhXKY4GtPfBFuMc8RDVopFXF330eTspyNn6MTgDSh/swvGwvwkGkoEv+9eQsNe2Pxm3I1NF2WCYb6wwxQnSuIRFC3Ohed0zogFKLN1Ed519ztgwsHlYf0G4aB4/x8QYwX1l2fTA0MTe1L44zfKutpvshDCDLGszcCHo7SmlarYSTk7ADy/iIwHM+5fW9xsgK8Zi6nLb1oYG7RwiakXay6SGCJHcojTo7CstEIKZUcYBqHnZB+gR7eulg30wxsJfz6pqDVTM8OrMRM+e2J0mse3tG53mqu6VdpZDALOoSHfxMud5pSAPShGsJu5uir2rqM
 qmq9FdKH
 riu8wGXCLotL8yQOIMPFAIf26kzm+iVScxSNfhPMYxMO6QAdmOGGB8w3At1Z2tfL7QLIO+5c5DYarZkV33qz5Y/9T/xNRfla9mkPCXXtpdpwQuJFCjB2k1R+CxlYj449ZG6FHnaHHYibcSTDAwQAcVhBOg5I0T1eO34aXG0DCZnMj6SduDxX738loqMNYADqMk8pZKcqqacvThT+fXYpBq8HKaGPCfr4bdSdXGEy9ycEZ1NSsHWLMfGE/7Q7UYe36beuevrkkMnz2MMQ5jEU2aMG5BetT/iPiylu1VGeJkzfsGPNhaHXoC9QZk4RiUURTIbHoyUjEG3mhh6AF0eVXZbKY7eCHm5ObVrzs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 May 2026 17:17:24 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:

> From: Kunwu Chan <kunwu.chan@gmail.com>
> 
> 'hugeapge_size' in drgn_dump_damon_status.py was a dead elif branch.
> $fail_reason in sysfs.sh was undefined, silently emptying the error
> message.  'exit' instead of 'exist' in sysfs.sh skipped a file
> existence check.  'nohugeapge' in sysfs.py broke an action dict
> lookup.
> 
> Fix other wrong strings in the same files.

Good eyes!  Thank you for fixing these!

> 
> Co-developed-by: Wang Lian <lianux.mm@gmail.com>
> Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>

Checkpatch.pl will warn as below, and it should be fixed.

WARNING: From:/Signed-off-by: email address mismatch: 'From: Kunwu Chan <kunwu.chan@gmail.com>' != 'Signed-off-by: Kunwu Chan <chentao@kylinos.cn>'

Other than that,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

