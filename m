Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE46606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 18:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ORZkQSMV
Received: by kanga.kvack.org (Postfix)
	id EF4736B05B0; Fri, 27 Nov 2026 13:11:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4C46B05B1; Fri, 27 Nov 2026 13:11:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93906B05B2; Fri, 27 Nov 2026 13:11:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4656B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:11:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E51FB804A2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:11:46 +0000 (UTC)
X-FDA: 85481692212.11.85EE4BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 18DBB40012
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:11:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORZkQSMV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795803105;
	b=ZJpc8ssefCo4xY4nyDkG0DHAE947H2NxK/jdF2Ub1Kse+1HMt0JBRdMcMX/Lp0LHfVqlEt
	HtGwIPfs2XTypXI1qY04Ih33GwOfV+fXf9Aridd0H8XnTiswCaV0rBSzhrgTyk+oO1weWE
	UjO7QyNcvEohkrx0etAnxFSEIi7UbVM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795803105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=mZI1nHXiLS3LtIS2kyFLrq5IYhVkSmZXb6W3s3piEKI=;
	b=YKtriAm+SMaYNQ9HyKAleiEPPtFaSJdkdO9AsOpXwXQ0UgWvZBltbsn0w8VwUDwtxKWZjX
	3wOMMUD63KDtSM2VWyWjL+3pS9DPN/z0fq9XfJfVCCrnPZcSiZ0Y/9V4bckx4qA3vdHKsV
	zfiYSzebViZFOqZUJlTQPHNjD8qvbrk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORZkQSMV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D6F5605CB;
	Fri, 27 Nov 2026 18:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0193D1F00897;
	Fri, 27 Nov 2026 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795803104;
	bh=mZI1nHXiLS3LtIS2kyFLrq5IYhVkSmZXb6W3s3piEKI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ORZkQSMV07E9+XIB+J+IkZNGUQiMEFejVzwEmAGfyylLHhChzRf+AWGlSmMiP/2id
	 xKdLJRDJuLMQizCDEx5jUR5XNVK9y53TBLmxoTH9dOzUdi/7kAWxYn3TyHDEfcK5Ex
	 Ek984WEiJtwnuAdSESs8SS+2fLOhsTM7XsfPozhkwq8QoAqVT8swmEJUpowkGbyehs
	 hbC8zNxahnpIMjVXEsQx+raUP1imkSLHigmjB3vqUOFp5eEQufwITBt/8vM5MgaBe6
	 cM0k4dIzwNO8KblS4mS/5WUVs18YoHd4WdJpVrUNXvLUukYUN1VgqmI36pS6QGy37i
	 NqlbmcJtC3Rjw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB8C2392704E;
	Fri, 27 Nov 2026 18:11:43 +0000 (UTC)
Subject: Re: [GIT PULL] Core MM fixes for 7.4-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261127085928.3630-1-david@kernel.org>
References: <20261127085928.3630-1-david@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20261127085928.3630-1-david@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc5
X-PR-Tracked-Commit-Id: 450bf6e1e7ece7ea8c0253886a01c663ea7bcc1b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1f1b6ca3145a1179d88b0033a871e4e187da0d4e
Message-Id: <179580310260.1619291.6788259909947175750.pr-tracker-bot@kernel.org>
Date: Fri, 27 Nov 2026 18:11:42 +0000
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 18DBB40012
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fxu16mry7dtjzw6dtdx9npsj5q1fm6nc
X-HE-Tag: 1795803104-2586
X-HE-Meta: U2FsdGVkX196bgonCRxOATgLrVMi7F469ns11Ii0e6lxZQ1WtTq/HKEHdRhmX/AYSEGqjkefdZpAfFVhRVOlAh7EWC4RGhOrhfLZjd82cGMWnG+GRghRXE1UcWqpXwfkvCDBQ7RPsgC46KEzT45032u40+qctII2G1St4nJIDxHZWITRqZp3XX2LAatD/MrHQIFUeUz3Ut22UiNgHBIo0RNz6xi8BYqb5T37/4k/Tn1k9afK7zR8BXVNghHaUbl/GAJCQYduJVNy5nCTEDCX4WnTFUfk5JSBErM6TFtsvs16R2/IstXrEzrq6UwWA4y9MoJxeYQhI6j16Pns4rpgz7PXkovn3AgFkZBNGeA/gTWknmMXya2a6ZmL1grp9xWNZ/gAchdmLWLe1san8v5VcNMwNxYyDrwi2+x4ktvgi/H0KrMWEqvuMUNBoCd29nW8z2m+yQ/t+si5K+5nP/F6Qc6od9QM1Lsxq4ah9uZqKjSTTqrIlMdvhjw3EX9ix8B5yJ++ruEhX6E8Rf/cmXGD+h6+Kv34sQemj21yL1/HWEGlMeyy7tnDPf3y6EFerN+GSMj+qtgLS16kty4/xbJzRIsuDk++C8iFVUPOpX4wtQhSOfZG7+PaO31M/VQ7txfS9x0SiRG7kVOEe7gDhhwuZDdljNLysHfaIvyAgz7fJgxGcY/REZtwVjGo9umW1mTt0YFXWJ7E3Rgvqzi+xbns3IWyYb8vsvNx4AzxWa9xfhyDJCtvYNCww35TZgAsuAMuz5pg807tG3URF6dD4EzIAn+w/Yvh2cXuq/J7SxZPE+Oqykk9/GR/YlOvlG0Yrz4IpgmAWWQ4eclfdIvK0zs48p/K1hRMXGYmwH0LwMwcw0JMsoWryHAAbmVdwJjS7wvV6R5z75e5uAeuH8mKhMqfgCjPwiVEWsbChbcAbWYJOe6AsSQ4Kv75sXWhGxvMZEur39/IvdRpkBPkbonDS0V
 58Dl+3JW
 Wz8/a5e8fxvRJUCkrbvjUbH4CnT+aTygWh/G5PhOUeeMWhEdxwf0nLceDKqf18s52jSV9c6OBe6a3ixZDIgGQrS2DQYj5PHbh3o6Oq2SQje35NT474lOjpJF/k6gSZMnPHrn6Q6d8/KAIDELITHrct/Dtf7OQBVlb5FGaSCFbqdcOy038jGSgZp/D2IO0OULMeeeKd0CGLHIq/joq3lv+f/W6kM0FtNxBhuYBhgw4P2B26Fi2FQX41mA0CJGsl9/mLKDCH+w48qXe1GR3UCNo6DDEsXp0ANSvFYwqjZXuUelLsYFMe91+b0oINP9glHKpm5auzlsq6VwyQ4gjWWH5pu6oxJv8fkxbjvhnieo+8slHTQ0TxGD3BVvYvwpeB/X6ceLYSM+R3CpoaMgwWXItvhlACo6YL1aY/hUIFV0mmxHCWBzJ5TkGtu3XaPYOSugEs6HQ1mHXNxrT9J6gefdbNadL8TCwsGFHrPa9wSeSNtM0oI7brZE0JIKTB27cdX7dl7y/mwXNQVW3bakEyotOX6EeMYzS+SEqA33viAgAF8LSebZMr/UT+u8vWvzo0SfNiJzv0DLCVgZ6bd1WfiwJw7Tt3p5kSpuixlmCT2m3+fxfdc0PhZ9Q+sJHLsiE/mzGSOROX3QVf0VBC/xmIgYLpCGjgznZtsywgaNa0fIMG0h03GuSy35c8pMyigNHkz81+wSNonze4VpLRmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Fri, 27 Nov 2026 09:59:25 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1f1b6ca3145a1179d88b0033a871e4e187da0d4e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

