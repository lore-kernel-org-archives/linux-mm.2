Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0FC9606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 20:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QilmzIUH
Received: by kanga.kvack.org (Postfix)
	id ECCF96B00EF; Tue, 17 Nov 2026 15:16:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D626B05B0; Tue, 17 Nov 2026 15:16:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95BE6B05B1; Tue, 17 Nov 2026 15:16:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD2186B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:16:02 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BD411A0593
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:16:00 +0000 (UTC)
X-FDA: 85445717280.09.609C13E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9B110120003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:15:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QilmzIUH;
	spf=pass (imf29.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794946558;
	b=kRpdaAilQ9sW/NKmObHtthiJzPrig2sMBWFm3KjHUldJEcvQ4olWWZLOPsgQjLJJRnW18a
	nH/B7S8YZ/Es9dporFDDG/JhWqElJURHPATzZIYiUnN3oLs+Mt/CaqsYetHur+bWTdahsh
	ZiheR3CyYFbHAPxWRf8lR1kkw8c16Co=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QilmzIUH;
	spf=pass (imf29.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794946558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=C7QdEoEBNMtBpSoWEAOo7tchBWIERIkQfVXSNEETZBk=;
	b=ZK6pL/Kw3EOtF7DtnxBf7zA7wR9MgR8/ROTke/nb5XO8WzOUZQ1Wp+/42uFZD7FsE40LzS
	VmvLJd7nvLo5R64cxOhEaSvzznD9N2uxdt3T6uIz5gT4pNmBzCRiuQ9vQtN8FLt+NKJumw
	qkyCTKt+HXTX+fZBYRjHfKarpeDR1uk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A47EE43C35;
	Tue, 17 Nov 2026 20:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856C31F000C4;
	Tue, 17 Nov 2026 20:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794946557;
	bh=C7QdEoEBNMtBpSoWEAOo7tchBWIERIkQfVXSNEETZBk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=QilmzIUHcNhn/w/U062PD8TMyx1B45UdLAW6bP45VcaIfP/dN82mKmsQHyddMt8mm
	 g3XcrdqKNJAcLgHeek1tbfCtOhy9BinHu/+B3arF+4Z1TShi49S3ptEDs9x3xaM/jS
	 kluafQ+gIAZVIhrEsu4DiIw5AFRq49pSCvOiYj9vrWbZjrL1rmbp73OOoJ8Vo2ZkI+
	 HPLqYbsi3wBx4hyKW1CUlim3Musq0rDNFwT8koxouWWPr+PQVeXMJgkyx3R5HAyPs9
	 cr6Ul4xbRE52V84oiW3EMuRw3iSE0ufg8kWNoYVqMX2CEYwBQU8h9rO3ebdcDeboeo
	 d78/1lUCVJ6tw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7761A392B1CE;
	Tue, 17 Nov 2026 20:15:57 +0000 (UTC)
Subject: Re: [GIT PULL] Core MM fixes for 7.4-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261117123716.7567-1-david@kernel.org>
References: <20261117123716.7567-1-david@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20261117123716.7567-1-david@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc4
X-PR-Tracked-Commit-Id: 25f5c92e1ac06496679ea229e5c825aa88968efd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 63fdb511c27afcebce797e3db580b3534ddfa639
Message-Id: <179494655601.800029.480627961511135182.pr-tracker-bot@kernel.org>
Date: Tue, 17 Nov 2026 20:15:56 +0000
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Stat-Signature: eib7osw8ujwfg9isn5h9qwb3iqfipict
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B110120003
X-HE-Tag: 1794946558-24663
X-HE-Meta: U2FsdGVkX19QRs4x2+oYB0rFHkLGNvT/EmKbkWuzQ7Wy8AenAcKGh2VzO1JkrRLIRis5J/DWa+UM1xDmmzLDgxYGakpHgjj8HTBNC2b8UHxxhRjZbhmbTNFCkktC2Smuql3+CC9IaOd0P0XEOentDDzo+KLeUcH7WX7vbf8jAV8l6kix38mNM76PQPczpcyNb5+ijG9pEWNg/XnOtAKbuUEFinSRf1qp3vKVo3CYupzq+NJMrBW12oP7WixeegqbVavVSspYFS0dafAVa5WLWG/paSazGaEAH75kw0rA+GPx1xDTfAWlks1jtiEOrxANwAv+7apvKezYNKPecptnu+XkfHhYYMPSqAuLT+3+HgoXBQ8TOydxLqdv46oZGNrhuluVd6xku/dwVk+vhMghU3Tul/kzcDxXXB9MJXDb4VpvTKyZSNfIsuxl6Cxi9izKn3zbX5PLV6pUBggoHlXeu4eDJsWs95l8sP4KvkcLCp3FXxDkYiixdMhkb2toamlyKgJmmP+tS4bY9QkoyYH5m5HwjXwKCYbqisyRjXSoB+X2gjdv/CLCZdcEmE0PMOcJLNBhVkQHoMi0d1j/VcuwyGR681J0ooA/Xz24i9vF9Hcv/Uo+fR7foKjpGhlYzcWKnVbdOaSrZ3KH9QHjkJSTGcXDOjxV8oW+AuVfZJGw9TiIPcJ8nbLrJXPn7xBj0rdeoRa5IJSApSGhnkH3KAWSoFhEBFuTL7vC1yZT/FZR3MEtt6ZC/jmlFC1TuSXe9cpU94ojag+/gBOY1MW08Wgj7IF5Q8W2kvbgwsSjPnT41ALy1gXV5NhZ5TutRuT8alnDsGv9X3iQiDcRFyj56gANgB3xVQK4NyV+VLsxBD5kM5NoXSSHa/FnVCy7XTK0VtrcGm/FxRChMpkilz/IXKwsugnSR1UXqkdaUDPVyfSz7fNU3lVj8J3AOcCBULPM950PBbNFCBjVg7A5mmkLzqQ
 iXFy0btq
 LFnsJ/3SN8VsYe+GBo0piNcQ0Vmd3rrwCckIaXsYAr7BCbC+kCJVsJuZ20E/mVdARPpWU9REhz9Q2M6yRQ7JqCXp9Uf/wwWAm6Bj0sK+0oUImNTG1LMkek5lsznsTKer98qgC6hjIsXQPS7yv2VHjd47jcYgXuqSqg7oRrUoYHA/Q/X0Nm/fvWAWpbzKgYgGbu1UJm99K3T27b7UFf9L4UzEbJkfCroiRIPw1W3eY9LoZUVBPRmYjZn4eRoqWGlXvapDkJ3dqux2va/bgyJc8/DB+3CQenW+uxrrJ2ZhCPqByGNlN2gwsWjp9PHZQYARcEidqnSVJfBvTJe1TrC49hJNc358/34tw0jLT0eJf+RRHAfFCnKuC0mPhECs/MRkfVnZ4a5XW8pcyD5a/oaRu2Sk1mMlh84GIAVeKLW0KYC8s2KDuPLBdkvv3pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Tue, 17 Nov 2026 13:37:14 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/63fdb511c27afcebce797e3db580b3534ddfa639

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

