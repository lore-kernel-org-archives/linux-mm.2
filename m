Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112F5606A335
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mGGGrFYI
Received: by kanga.kvack.org (Postfix)
	id 345236B0BE8; Fri, 23 Oct 2026 15:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F60A6B0BEA; Fri, 23 Oct 2026 15:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20BDF6B0BEB; Fri, 23 Oct 2026 15:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F07056B0BE8
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:58:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F1A0401DD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:58:16 +0000 (UTC)
X-FDA: 85354952592.15.89CCE02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9D77540013
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:58:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGGGrFYI;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792785494;
	b=COTcRVI7dK0QRIxDMSjmio4A5vBzOW6BNWNTf+CgrLgMAGgtSBSBP5jwd4KaRkMTx/zVvC
	WlS30nyAGydffZsUZ96vTt0oPeWmGKqQmUVILWGzmcslkgDJ3GQ7bY9vB4q76fpUtbYrwu
	l57XaBkVDU2LyJkU7jthI8tyexqhSIg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGGGrFYI;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=0kB1Eu+OBUcet3f1PztzYQFUl2ZFOUmK+s0rCwLUKcw=;
	b=WS8R4P/nyuClkpkXqCqlepe3JQrqcuym23cm+aKwgoIMZQH4fmXzvuvhLAwkM2+f5bB65v
	5FjRw4M0ol+jmcW3Cxdo+I1XuQTh2X4IWVrZja/+RTAEWqxDvsTiTkmh5yZkU0JEwuJPx3
	a1x8nO6UwsV5Q0hqGPBVrSaFT/40Xu8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3DE644491;
	Fri, 23 Oct 2026 19:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68B91F01825;
	Fri, 23 Oct 2026 19:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785493;
	bh=0kB1Eu+OBUcet3f1PztzYQFUl2ZFOUmK+s0rCwLUKcw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=mGGGrFYIGMqVKqk7/6VAAHYx6RcjgH0tsQSbHjXyGBheHWn2BofKOgbUZ9DvbZBxA
	 Ukc0nOvEGqpsrJgNyXl0rDgAZ7GPQR9X1eTLjjXidaTcl+N8W6VnJRz0sPaNJqYXcj
	 vY2w86uwntIf3muIVDHDMln0pS1FRajIFNLzl3+nISZikeE3uXl3Tb37HltUYHNE0W
	 JVO8z0t6o7qgbF4U8j0Fqo2E8lEUftHojqZy38t08yKH6vLd4N7/Yf8sn2Dz/AimnC
	 Ak0XzguCadW+Vci1qLAdzjBRaP/sNBqWe7lu++FqO0ynql2lVDYmwWMAQZeMaUxcD7
	 RwLiszItRT9bA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BE549391B153;
	Fri, 23 Oct 2026 19:58:13 +0000 (UTC)
Subject: Re: [GIT PULL] Core MM updates for 7.4 (new MM tree)
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261023172100.49643-1-david@kernel.org>
References: <20261023172100.49643-1-david@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261023172100.49643-1-david@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc1
X-PR-Tracked-Commit-Id: 07ae95d933b84db98696f23e24de078b251561ff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2ee2475e15b4ff8fda89a9edcb77dfd871de1386
Message-Id: <179278549235.1241373.11674189443259173093.pr-tracker-bot@kernel.org>
Date: Fri, 23 Oct 2026 19:58:12 +0000
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D77540013
X-Stat-Signature: huzg51qttzkq5jqdwbnk1kaxxurwdcbs
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792785494-342948
X-HE-Meta: U2FsdGVkX1/xKqOm12mYQUNlYJx9uW4cH2pg6rDBcFVzGHWEXPSYQ9L2lYqbKGRk6bloz5yUZmXw1vyNqGCDz3XJ7R0O4cM7g4fyycaXyCQlUwsXL0YQPBo6270gAxWqY1rEndzozhLPMXg7njvePIITgyUVxEhz+mhYu7UyJ8xRN8ygYooYpS12QR2ZNNJHabdEWW9YLvUCYvphtyGPc5NPjtRYpJg9Rjw1LbyWM5hdebIjd1xicoO6qAowRNKCh+gbqqedWSQ4cEd/vzIsX7jJk2yPuHKZrv2PmwjH/mwkNkMoxxCURvJvxnvtgbZ8StuDY4i1gfx/QKHwEQaGVj3k8edcQ/d6ZNpx+NA/kwSd0GNTdJ909JlHKRbDqC8riIl8G3+sQNxnaM6g4Y4SfxhQAGRZ+ZEz6VOWqgsp/VEZEAg2esIoFOYyjdIuh9MSw+WJ/GPY9Z4ubKxdivlU93wm6+xprAJa/mQ5DHcI4nKBHP9acjwsG2JzTb3N+d6gTERql61SZlRD4pgFAfK8w8G0TQ0k2Q5/NU4lUYmiMLMQ47YnfOEms2yr78TLJFCZKgWvVhhlioXK+pGdG0oum9127rE7Bezd6X3YaHCCKefh8WnjYEsqbIOQxRAwvtdc/+4h7pbHcgN+xQKTC0CIiQjIn8+AFNpVYCSeTgCwEbngVTT4EwLxMrtWBVN0NV8uDVpr39VzhV+hoyb2rsMRjM9xkuiMelmyq5B66lHJFzuLSEAZ7BLhCmk2PCHPv6rAliWSA2IYeG8KeVfYM+FEMdBNfPX8pahIUXwdV5qy+JPVS1bb4H7XIvE1CcO5jbkvRH2BtKv8lLgRPPzGezAdxpn1aSENbQPDTE+1kO4WBWyMdKNN+EzSc7rvgL3dUnPjsxzsl30L9mvpzqvdjaj10MtXdqT8usp2MW9E+dXwRuS7cgWwCzeTzwYLYusEuzY+7v2LY3eIoiQytfZLko6
 RnmMC/MO
 jt1ufxpdQLXqNP7Y3mb8GrG0vFLLYYjBEOKhSjsIuULb57iCjFW7cOPe/6hLUrM6lI+Hm+NeTjILvRXKZqnAtYrU5KnLugs4bk5ddAI6X2ZSntV6hJGAhEp8bSd+EdYO/WrjWymfp53ylAr3pKc+YtQ51eGuyVe17HcXoeCrUbIAHB60ADZlon2ort2WRKMf1UCnIYcRhfbgnky1rMBoQDPwXCid1g/zibiK1q843uF4ZZ2+qiOydrSbYfCCRvGurUeNOqykFsrpzQyHNmPXhNIFlk5A33rpHY0hz/LPTWD5nkf8iXS+u0AmGDOW9x1/0tXYNvOUpFGAtlL/pXthOeHjSSLYbQXEPpZ1vzgwyEvYcEOyrGmbsFyNITm53O5k1E+tHh1hhLK+5o1F/opaehsngJAzr2D7LEgp/HKKXR+unFUf+d8S7YgFuLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Fri, 23 Oct 2026 19:20:58 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2ee2475e15b4ff8fda89a9edcb77dfd871de1386

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

