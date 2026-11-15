Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BCA606A32F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GfkGcQAA
Received: by kanga.kvack.org (Postfix)
	id 69AB26B05B3; Sun, 15 Nov 2026 15:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672946B05B4; Sun, 15 Nov 2026 15:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B03D6B05B5; Sun, 15 Nov 2026 15:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36A7C6B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:55:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB32E1A083A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:55:23 +0000 (UTC)
X-FDA: 85438558926.17.7E4EA74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22FEE100002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:55:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfkGcQAA;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794776122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52d/RCwDfD/DgbGrt4TUXt6ka8m/3NLeYGrtNO6HoqY=;
	b=i6k4VzE2EZchbCpYciLyNlNp8wBmrSgO1gSA/XSaRV24iFZ1z7kaivD3vHqSksYZLklC0g
	c/1WqUbRL/Jjvq254uZtsVmCvP/wkjUwrHC7ULSG/LN19+DT30iyVuRYmWEj408x5F+KqY
	i1QBvH307pt9hSapFIxNhlf70anQhJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794776122;
	b=3chqoiEJvAedl68Xl8ZBy+oKMWCMyuVX7sKSrDGNKh7d7qJjvPSgMOFc4J6iHR/tA7CauB
	Vx0xOZbqJGyyb0c1sW6ywXTfhC789mznbfbNEB0cpFOOu1rAYkhW/b869A/NyRUGwKUDXl
	FSuKFZsqoKeg1WFSYx2HgxO2CImHi7s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfkGcQAA;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E12966140B;
	Sun, 15 Nov 2026 20:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4342F1F000C4;
	Sun, 15 Nov 2026 20:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794776120;
	bh=52d/RCwDfD/DgbGrt4TUXt6ka8m/3NLeYGrtNO6HoqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfkGcQAA1lblP0vFE18llod9rgiJgby6+DewN9r52r9T2qVLRlusFD2na9MaXyzCx
	 0JCStUgLSKo5/jbQtgZKnNOvbugHkSjSP33tmhRkEFpKTQXyQCG4bgqQTra5I9VC53
	 zFuTuW+z5ic6VK61ybqjl5SBqyiFy6DuSyrMscIRHTVlAvijG9Na+l1K87Tk38GVAE
	 R3/ouO/zf7NpjMs5qtaPHv0CUAMRihvf/kyHu2wC/bMIOvncd0mHvYQiDhAcjFDNnx
	 DNdan1AeCtrOlHqR2L0T10jvVkj+RSFeFyU3tl6pUO3wBl5bLnU/uq7ig0jxqf37oY
	 gOsDlHcep9vsQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/27] mm/damon: let users report their data attribute findings
Date: Sun, 15 Nov 2026 12:55:12 -0800
Message-ID: <20261115205513.99979-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 22FEE100002
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: h9jfcoqioz9gf3rdpnnk9pzktid5s67e
X-Rspam-User: 
X-HE-Tag: 1794776121-998036
X-HE-Meta: U2FsdGVkX1/F7IwFa/kZhGSRvnDVcNamVM8Q1/G4IP1wY4yx/yaB+CboNDk2lDs78YNazP4HiYGeDpYd5EzpknnumPbMbuAP71DwWz3PUnmipcnwLqgxjoR3fYCSnrRtnhTlq/OxfbPmvlWz2jez3PhzCnoR6T18h7e9ABP36jtd6hShSKJjYkZFw32Lh8uBdc8vNzUKTLMM+vIDorTpwf9gx6p9FhMpZ47ZWbIPj88aZChD/zEp+QbIekmaOMrCbCL1o+1swI3HXCNcFAJn/V6IZ7LLG2YH4XfiHbShIOxom1KAjvEpthz5XGaxT8L83dDS9bXfNTMKpMZf1eClyp/LwAjd3BV+Dvpb181F1FL29eiKMp6CnD1gLFEKwIjabU2N4F5JPLuagtL+m8WgknyFouYmBOtY/PNldLHxYWGpu/r07Wey3tgwxN/f+U6zTz7d+tzQNhu11w3OtNobtagpDxTgykD+E8xhGnX8DT2sNdA/VrWbtAAJiMLpYlhk03IlbRqkPCBaqP+wIGQ4NqBCi7CwmIiwGjJ4A7qBDxTgGKsOMyuK+Xv7bg9fX5SqTsjfsJ2od4eICEMBntlxs9BO53/jLgUHTheUN0eZpMhSIrIxBsRNY4IgoE1uChmq+LOuwr0T9m+ggfBU4oju3fS3BplHYHHuyq7MA6M8E0x/xCATB1UI+mCICL2a7J38YfGjnCJjuzFuWitHtLxwy+FUnfHWrk9a/IJtZ0r3jLsS3qwFsk93o0SgECGZZu/AjvaUoWz8/M8RWLD1e/mhMKD3IsFIm7gBK4Z/2iXnxmId3GJDR3jCWYv12hhtxXM0X6bR90P5am0tN+dOMBX4afybc2MH9PGsa1UNExzDvZf5RJ8n/IENlG7a0yVUT8p2RXpONKNSGBWCsFVjpXzbtFo1gzc8W1ldglNTS28DsV9cSHv7CkcusYlMLitNPk1E66iawJoVNHPQ3mdoJko
 X/kPg6Az
 eNPZ0Scsq8hAk6Rh7k1LE3SZ1JT4/8CebnYYGr1LP4HdSg4MiYFL+syItyd8Cyp5JU0zMBVzQ8BfQne+H1AvXVPCZ0et1ms04R31XIoRlacFSf7ZbnVFmu+u/0/YgfIqADjYIxPknM7ovzc3Bld4kWuPA3ZKCUmML8YFQqBLq9rtACi5AEhlyYZQiF3GSsss7qe2CKcI300+0GAX9Vl0zlh7nSxPuXzb0h9NMqXjjuKw+8Mc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 12:28:18 -0800 SJ Park <sj@kernel.org> wrote:

> TL;DR
> =====
> 
> Build a system for letting DAMON-external entities report their data
> attribute findings to DAMON.  Let users report their data attribute
> findings to DAMON using the report system.
> 
[...]
> Ongoing and Future Works
> ========================
> 
> This is a part of the "beyond page table accessed-bit DAMON extension"
> project milestone 2.  This patch series provides the initial and
> essential part of the data attribute report system.

I forgot adding a link for the project.  Please refer to this thread [1] for
more details, plans and status of the project.

[1] https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org


Thanks,
SJ

[...]

