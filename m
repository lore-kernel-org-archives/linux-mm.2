Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F01606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cU6ihKG8
Received: by kanga.kvack.org (Postfix)
	id 1218B6B00EF; Wed, 18 Nov 2026 12:56:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3F16B05B0; Wed, 18 Nov 2026 12:56:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A856B05B1; Wed, 18 Nov 2026 12:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC85E6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:56:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D3EF160851
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:56:11 +0000 (UTC)
X-FDA: 85448993742.05.D7D67DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5956DA000F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:56:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cU6ihKG8;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795024569;
	b=gp9Ymuiz605Nln8SHuz8rSrTR1IbTZeFrzPdoOIHpvBphE6HK88oCG4Xi7T/CkZjl2vgld
	TsQTrSLcYCMd3pDr3/dLHGPZEQaP/dFo7W/rOWvrdXJTkKs/8V/39crjSRUcBJ8GnKW/6u
	LxJaSzKINvrjIOqYeRc0FRQd1t4bsWA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cU6ihKG8;
	spf=pass (imf15.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795024569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CzjLRcrwDq/hxGK1YyQYbZmktQm7XN5YdBQqLzEKlyo=;
	b=FQlFSsIMAM0rJ8QPDVDjno6U9n8O7hctrFGHEEGQlq76xbq9pMYUX91fRsDDZVR7GSvinH
	L0GaAh0+kkaWCYdLMG0Sk8KTIUYXIdKGDhC/dfqlAy5x22DdZ+i4nUObIFzTprkfdHwPYG
	RtQJV9xHc5Krc2x48/5sl86+zjRvzBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6E54635C3;
	Wed, 18 Nov 2026 17:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802891F000C4;
	Wed, 18 Nov 2026 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024568;
	bh=CzjLRcrwDq/hxGK1YyQYbZmktQm7XN5YdBQqLzEKlyo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=cU6ihKG8YQqis+Yy2Bt6ZcRMlUPzhSuLcnPvjQvnN0nombex/BAcUssmZli+do6ok
	 Tp3chEC7FEoPOEnfgXM8Ok9puixKOv9EUzx6YmYO2+UOslrouIwMItMcxug7Ur/1oz
	 jfXg0Fyc/rFDtqRWPgK1XHmM8HDMZcsP/cir/Q8oR0X1KKLGYIx8OINf7CRPM7ZgwQ
	 bBqfwMh0UZfP2FkjFB5aXvS06vJLOsqljQr0vcs4ZpLTNmdVbpKJiAY+HcHtcS/YZb
	 zkr9yEI+VnHjEZIMIhOifFkatKYLseUxpZBop1RMIymSZmNFtTDHGdDkKNYXuSJTLi
	 ZC6h2VWhs4yog==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 774E03808210;
	Wed, 18 Nov 2026 17:56:08 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.4-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261117195935.25bd098c3a99c1331c6ffc01@linux-foundation.org>
References: <20261117195935.25bd098c3a99c1331c6ffc01@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261117195935.25bd098c3a99c1331c6ffc01@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-17-19-55
X-PR-Tracked-Commit-Id: a4e667346a8d91e629a2ca9affc70dc28978f4a1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d866d5bafc5e1417032255002e95f8ec3121754b
Message-Id: <179502456713.1929586.6548525722108404316.pr-tracker-bot@kernel.org>
Date: Wed, 18 Nov 2026 17:56:07 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5956DA000F
X-Stat-Signature: k7ezbamuqtyhec54ip6tu3w83kgiemty
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795024569-310262
X-HE-Meta: U2FsdGVkX1+NW3VCrZVSOMJU8wNh/uHpiwam0fY457xeFfa3+LPzIViOHUrzlMIVm2R1Y26iJVJtB7Pbg7QU8TLlmP/fU5xUFJR1rKqwoR3+TfvmjaZ6H9iLH4wuuq2Jpz5RdNqyjdjHwnyDqhGECO4ipBRiG5u15DFw+erF3m4BXgygr0xaFDlUU5mxfqY9OBV4Ncwptny6sWMEea0srGOvu3PlIaj02DsatHqBQ/vppWxliTE/hJiBFh0niE/QqIxVdEARI9//ScpSkODEpSs10blCymZnWMIV3vmwD+fYJ/fKsg36ANscrs4VQaE59X2weDvy7i9hrGwlohrfI2qy9oKK9Jtz76Wdq0zGfNbG44RSuTUiKQdDl/O8ifmtb3IzDyK/zkw+j9v/UuUgwk03N6SKJF7fDzjMO8Quz+NRIRvghwP2oqsNgycsQD4mi9DOm2MWyfgd7iKup5kafUzAfj8r8tIGdF1DNi3/4v+0v3YJzpjHJlu48+MpqEauxGmRdHJ72WPDDmvPd255Dv2sxqtS4ZMLucBhTxySmwta1SUM/Ns/j6mXgxguT0R90RBVNfHSE5PFgitj0Mml3gNRTWOAc3lTcQ5ohqM4PhZ+0REKb8YXfIdeUfknocYfmc6trLbEprTpDedqXOwuMKKDUoR3JM91qlqaVhuo8w7it5Dk9BItLusm6mPMygZHf8afdKtUHmZNjkSQNWKbFIuFNIUJ9GnN3fObp4mz3SYNfVB0FR14jOb63IybW/dEX5jwe/c015jnn0hai7rExbpT5tLRNprNRiBRr56df9EOT6XntX1DnzgHqvKo15p0KkhKRagXEN0rNDNRwx7nwaPRdPsZJ2Rp6WSNkiDX45UgiwrEvZVZVqHw0GmOqGFCkdh+Ft1S78lx8HS59hbf3/6UJAALFnqKqANq1sZ6SN57tx/ylcMc/hFJoz22q+7N4B7Ye7iSNZkp4w2CooY
 pAVXVRRO
 Piwxm8jsQNLQHCFv2lw1U+P+G11cpWX+PXbRUFhw1+1wkzinOP8+tnJRxYqDjrZSnvQrm/IaOhyLYGBF2q1S8mNJwvnRFNCbSSjZshmFv5MCi0DwwuqDO/yXfrfYHks1dP+NGm2/x2XItEi6SNdYrl7UCtFNh6wig5BeKfVgDIrU2KWAI69lz3WZsJguooPnqw73MIpBLf49wsU/y8LkyFkCq1uanqiiafaIVN6Qkvf/KFVB1WzAfUnbxB90KL88CR2SW40uLGvXQxvkf1iZEjxV5OloojlpDaKOUBcDolnS1/aWuoSBBrWFLudmBiY+JbgfrEIRBw0PfPlL+Q4lOxX9zbbeiRGPhPlVmF9rmFDy5YMIgr5VkPl7ETrfiJIkaAEJeL6/O/U9cNQr9AIa/CWMkVBRSF6DZ8P5NJ4ePuyTdsr/bZ6Ac6YD4qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Tue, 17 Nov 2026 19:59:35 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-17-19-55

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d866d5bafc5e1417032255002e95f8ec3121754b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

