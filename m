Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F30CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 18:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D904D8E0006; Sat,  4 Oct 2025 14:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41248E0002; Sat,  4 Oct 2025 14:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56938E0006; Sat,  4 Oct 2025 14:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B15CD8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 14:20:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43AAD1401A7
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 18:20:22 +0000 (UTC)
X-FDA: 83961246684.25.807C049
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 66E9B80010
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 18:20:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jNu/o3V/";
	spf=pass (imf30.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759602020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=TQq0MEIrHpdSYhK7dETL5ftUjveE1l0TzaWQdug9D44=;
	b=EqBIXVRUKaIC03OlyxGkDd3Y10dOisVnRbLWW28HEGi8Xgouypym9FPnrpQrAmsl5lp67Y
	UAKrvp2b0Hp44YKPyYyd3jb9Qe2CGPOj7n1IBIl/FDAtMGT17j2mdjIYF+gSR4EOBhq9h4
	VczWqb/lKjZKIppzxHx/VelBUaA/rbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759602020; a=rsa-sha256;
	cv=none;
	b=oonTWgf4vB/wCBERzFDssYSnk77WETH2XoUpg1IY4rZPpzMiGKk79BSPE26AMLzh+I71Vv
	u2HBEUzbYT91m+qgvR0tHGMW0um0TVGdwx4RH8gE5FjYoMIyJDF95m5TBG4X8AOSfs+hfa
	WAl3dZHY0TbGFm7XHmM0sasZ7g6LD1o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jNu/o3V/";
	spf=pass (imf30.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FCA2456D3;
	Sat,  4 Oct 2025 18:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008A4C4CEF1;
	Sat,  4 Oct 2025 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759602019;
	bh=3Ao1DqyqkA1i/m8PKQMR3M/c5dL4R4NHTfcO1XN4SRw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=jNu/o3V/1RyXAV+QzUBoujOAK/I1pG7TK86i2pNpkmhGI3uxNgtByaPu/CeluxFX0
	 kmnoJM5y6gXV29g3t6Z5Y7xheQJ/U36FWsqbDkdKoZducqVe9p1DCdXUCMn5StWpX6
	 PXGhPbgXBuZ1D51iWPXWIRbKUOk1gJM7zzPrjTzIrOK3QTzO+ZPHF54Gl6fpM99xNN
	 NrzRJQF77BtzGnkRxKfbMI5B9dPjPT0OnYnXEyuc/B2/S1fOiMFJXrnI9AEovdjjLG
	 DcLQqULAcghYIStpaGd582X4gJneY1EgTbEJxKClmbM8DPwgj2N5EptpHDVXi7zedP
	 oHeeIjqrxpkTQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD8A39D0C1A;
	Sat,  4 Oct 2025 18:20:10 +0000 (UTC)
Subject: Re: [GIT PULL] mm/mm_init: simplify deferred initialization of struct
 pages
From: pr-tracker-bot@kernel.org
In-Reply-To: <aODmrlNys5x2LVtl@kernel.org>
References: <aODmrlNys5x2LVtl@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aODmrlNys5x2LVtl@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v6.18-rc1
X-PR-Tracked-Commit-Id: e68f150bc11d0a05cbe984a4e5c0f72a95cae07d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b41048485ee395edbbb69fc83491d314268f7bdb
Message-Id: <175960200955.404121.9390868499394906575.pr-tracker-bot@kernel.org>
Date: Sat, 04 Oct 2025 18:20:09 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Stat-Signature: qcninsfysym5a4joset6m1afpzg11fba
X-Rspamd-Queue-Id: 66E9B80010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759602020-124451
X-HE-Meta: U2FsdGVkX18kgcFS9HHOYauEj+0LbEulLA8vapErAmLbdXMiIGhsTOTBFIR/Bq+OXOfX4gXWu71VXNF1wf4ofwEXdQjoX57MyEe3f4QCUvxkY0yDFYAzgtxDW4bdMiwbnd/9qmA+pklZc/ZuazBBlzDEiazAXTtJjOmTMcEKdx0yGs/Po1pQ8o4J/iq0mnwaBPaA/BJaHejWi/wPWf2v9Q3eljh/VIYdIl6ZXBQ8tCYaaNIm/9Dukdgglkun1hAYT14myN2nCGCJPCg3JBjrCPuFMjF79aK9NqnJRqlWyaJYFeAO231cEdf+bQhn8F/cOpK6gfmXRp/V8eWYJJ9Y6gRy1ciy/7N2GYbi7ILXqnLKvZzmWeYqzVaBH+U7fAeqOLd4ZLVvT8293zxp4nayfAlI/c8+209T2iU9NT0OSa891Hoyw9ZPz7zXIWKSk5DEfValoHS/9ciSds4lNQ51geVrtvYeQYEM9rKrn4R1JgFMUTDWw2ll96rUvNjV3xKPP2e7k5FvsP7qnVq95aiQVM5Jdk06CGJN02lVWyyiNR3VdV+OP39vmVAcNiwONFh51GUgSdqZfoC3Deuzt3rDd2silw9wYqfM/XRvjqTze8j52Z9oRwv3AMj354IUnlaKAKbF4akQIAC7Q3ii9dQP7P8JAct5Cs49xST7svu1GvFnpZhdC9R50/iBzVk59Gno1u/fa99fMQZyvmVS95pG7pkPujTQycFNldfUt1kJyQJ/ls0XZZMXeojX/0VeIZCM0JDHGr+L1JGDrJKFuPUnxO6teKLb/JERnUgACpDGp/xNEbLpr4Dn9v2BTgt9h2otEfZ14WmQHl9Y12ajhnw9S63a01YTWn2HLAeZBhsNW2PN1oSVKpA7DrRbFNKU74eamkgD25L01lUPmemknxiABrkiuSO0k6WbvUIFPd6beCEaC+Jn3O+EiKJbzLEbgZ7TrAWOUjIneB+Pvxj4kjn
 rgfRmV7m
 URETgVSrXJKgXKtK8HZajkiSw3yrd40rDp3jZHxz4WPXWEj9ifAtk/LkeXGK6JCNHCNK45XJYfeVBZQywqVK1X5/dRsO1PjQCF3lnMwyzXjblD1hKdrTyrLYLQWCYPHf1aavNSAmY5m9qmU/2zp4TL3jQSRUXhPsiz/Yrl2mIHbxeI3kVnt6Ym0BreUFCE6DJ06ebe+Ldu6PWCEDkumfChBX5nH86pC4VVvcjGDq9DzIwCDRGtYEaCdhXV2z0YHLVTERyBM/rzgbrMtNsJf5QoECmlWjCtPh8VWpppd0Id2EUPChbHCZ0JuJX0HEfdjMe01Qq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 4 Oct 2025 11:19:42 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v6.18-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b41048485ee395edbbb69fc83491d314268f7bdb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

