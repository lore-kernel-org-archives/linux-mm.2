Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCE7606A900
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tc1qTJIz
Received: by kanga.kvack.org (Postfix)
	id B0D426B03E0; Fri, 23 Oct 2026 15:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97E46B03E2; Fri, 23 Oct 2026 15:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962466B03E3; Fri, 23 Oct 2026 15:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 778ED6B03E0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:57:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 103021401FE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:57:44 +0000 (UTC)
X-FDA: 85354951248.14.3FEAE2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 428D814000C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:57:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tc1qTJIz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Azo9CniJ7hsZsJtpNzpBWIhDn9knolxQ2Zz2oL4JH7k=;
	b=rv3QxEBVxVUVzoBv8G4f9lTlDGHqYYilv8IKqXEN8b3MexxvYYL8X8qkzWielY04ZPL8bA
	Y0GURpQVIWgYgwJIwHhMSzUrq4tB3hme8UMEs1vyLk42uPZs+mdmMPY/Yfx3wYmHfErnzE
	c4r/DLtVk1jxMzT+NMfFA35kAkYFJo0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tc1qTJIz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792785462;
	b=A3dCUkuLi3DbBvRuEbxhPKVVlsDwBXPykPCWM1dyTBZP7sJs1OzqgIaeac+dX4/vc0Epnl
	TClytHFITuutH+/ln4a0+6DjkcnMVxQDTE1DXI2EqSKetvJV3TKBGC+R73KgA8VaKxBay+
	Ea8l5hsmVdbIC8C41sWYiyXfVONXjYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60C2160A97;
	Fri, 23 Oct 2026 19:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175841F01825;
	Fri, 23 Oct 2026 19:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785461;
	bh=Azo9CniJ7hsZsJtpNzpBWIhDn9knolxQ2Zz2oL4JH7k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Tc1qTJIztKux8HGU1uapCL7hso0udwYgmvKWx1HZAniT+GDhNXmjoxtBC1DeCXGUL
	 wyHa9Cl0s2Vqzy0MgMr9TCk83X69pHqOf3wKAolPNq3VBpPfjDVbh3P2FJALPRiOvZ
	 HCqoCp7pPZr7Pw0NVkp0IE2zsoHoxJhzv5s9EXp4F5Z6g7hg3l0oxhEq+RD3ubXhL6
	 /C/PM7qq4ZnKZXxFgUPTOMTSz6AbCQe838Z9USBy6rrIhrgu+ZvIl5G76v7iWLA/Qc
	 HMTXLz0NMJxFZ1myxm0k3cU9XfPc5s7ONyLdzLw7KAj4nAqBowXKPVB5BBZvCq/mGf
	 RChJxbr2xDhGA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0766E391B153;
	Fri, 23 Oct 2026 19:57:41 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261019220030.056b79bf972b9d6a9c1aa931@linux-foundation.org>
References: <20261019220030.056b79bf972b9d6a9c1aa931@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261019220030.056b79bf972b9d6a9c1aa931@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk mm/hugetlb.c
X-PR-Tracked-Commit-Id: 2967f3ccdb5fae956f1b085370ec292bab5c7e25
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5fd5e67c7812bc40cd897422c1e0d6dd9ed1e2e
Message-Id: <179278545953.1241373.17245205565850305914.pr-tracker-bot@kernel.org>
Date: Fri, 23 Oct 2026 19:57:39 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 428D814000C
X-Stat-Signature: 3zi3cbkop3wtgqucy36r3hiyhafm4soh
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792785462-59849
X-HE-Meta: U2FsdGVkX19wNAn20ULulDwuEPFpm9JHiH5YVMSX85k1gszq1FpUGg/2Up6BAZmfD1gmvzanWWQE7hwHqcdy9fRCR6Ad1sVnKJ6e/en/iqujNb5pSfM/gaSi9X1ZJifHUj8r37Izariw6CzhjMDd46RlQG37YwCXBiBrgg7sc6jHasCe2rcpsuieGgjKMjMrI3ZFp379rWHAojTX7Dog9vaOQZcqFHeXMTGWUlk08WRyfeHYXpnhS0uRKYF2DodsplaRntgfFwoPDP79p+0lZCDxyPq7fZMmw1IPxZMLi1BnOcfV8e4byTdveEBedxq95pnIiRnGaJD/KVHfKlz5BifSWfnV/jV0iCVgIHNSLWCYSFZD7CKpDtk2AGykP5w7w+T/remIeALsYq2OcT22VNh68Zveq1xdYkJS5parbHL9VoZsb651A9kCR377BMMkmSVbiZ1ZM/cPutI3Z/lTJyh3X4zLqZqh/YmwmdWiBbRcs3CKC24o013a8m5/qCU7PdrtIKE/gzEML0SnS3+4VgUEjTp7t+WKyIsF9qBuORRZ+UQTa652PvhGMl2eNkfaTKz6Zog250v4inkBDb1e/heWtnE4mjcMmWgcqHuO3oYHHMxYCG1aTMsnqN9c33WLuPSzPtKo3CSLOXHzoFE8QQvu3UQgK8RFd86cvhAqFjhIHbIPBw4zhfAh+7e8ZkRhlr2Z3L9oN1gmkziTXfJNLBeMDeqAptuzzCjiQtg+q3qz+0hI3ubMXunyIcNtJmAGH7k2RHGQ0sXuySa0VtFOFq1dmt4i+hrvMbGjmsB8220cx/nFhl9vWqHJFXpzUsrZMiwamIbQC3L8hh3nXpfD2m5NV75y0+xH0EJqx3NXpByyBERj8C0kXLZxFkdXT23fRQw/vAA6bx+qQWXYUgJ0xaABZRZF+nskaPbeQef/hHISqQg4z2K7tjOjP+NTtfK4HLZ9oCHfWahcCyW7qci
 C4oY02aY
 53bNhdX/vkxMy2Wlzeqoh/5FzXwKicaON9STFzVrhkdcFZLjQksUvjDWqGHa5xk7PBQdxRjpujFPHuV+2z/GKJWpBkBC7CqPT1Sq8YfZ28NvBzo0UrVoH7bkXJIfirgzhFL4OPv9zhq6zAmHkBT3wmhiVi9U8Wi2E6TQFsOaVAiNP+XY5fnq+xtPo2QoJBM/5Jt3iv+LcHDdAHEs/gc1cCfLYOF3N2/gzkc+1vp2A6Q7c6Zv5MOse+9iu2uM0rYqo9/ugVE2MUNJlwLhjMAih6of8DKhVUw+r7mIZaZd6u48DPVGS+AxoHjOW+G87R2V/EFvtyKBD7xuHlrH3j22bQ+pxFHxiT/XhAqkbHbp5Xk6hld7azIb6dtaDnsWIZuRLfpaJ+9JTblSAp5HkAyOpq2GO9Gcpzzg5HyY9zBIeF6vtVhJvZAjKVnJ/QWKGESk+SSgv5RccN16RurwbKySqmxwrCFdKoHTec+KeAOCT3aDugBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Mon, 19 Oct 2026 22:00:30 -0700:

> https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk mm/hugetlb.c

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5fd5e67c7812bc40cd897422c1e0d6dd9ed1e2e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

