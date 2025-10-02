Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1658CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 23:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEA38E0002; Thu,  2 Oct 2025 19:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38278E0001; Thu,  2 Oct 2025 19:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D678E0002; Thu,  2 Oct 2025 19:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEC2B8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 19:51:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68A18C042C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 23:51:36 +0000 (UTC)
X-FDA: 83954823792.01.98AF545
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79852C000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 23:51:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pr1iDt8N;
	spf=pass (imf10.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759449094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=D/siTm0BpFeobJcli4uoCxacgWJXamPajw6yJ6izXq4=;
	b=K9RBkrR1gFK/HGDxThXrQYaxPnd2lslfNs8arS/339m7GTc2xehDDb+lnk623WY0rdh+2R
	ihRHvysAYGTasO2Ex3wDerH9Whs3wr6K7ZLq/T+htzw+kkAr+ZspRnDJ+/Z1bEuSiwZn1K
	Z9FtNErd+8yIL1C1k7JlvSGGsSeyBWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759449094; a=rsa-sha256;
	cv=none;
	b=JdixkG6DRzDd6Nh+nI6hYz6f6UguQYmcPOPycIPNbtjaBymcCzCXiahuRl8WDvvQiqxWZ4
	Ougf3NaPYuccC97V1OiY1K3sIN84T9mn7kCwGOg73HSTOjmE2Vf/6m0+VjJUXxCYhwjfEa
	dgCCWKCG6vRrN1GOSSssp7y3r5QsWu0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pr1iDt8N;
	spf=pass (imf10.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8163D60463;
	Thu,  2 Oct 2025 23:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A78AC4CEF4;
	Thu,  2 Oct 2025 23:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759449093;
	bh=PV4pc4zNAcoB0ElMSzAin8+W0hA4jIwDrxV+2XGbDng=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pr1iDt8NloCfAuM2YDMSDtYEtDN44OUw6iJuKpvmxhh44mgBWRzY6Us/7asFpIMdZ
	 ZFesPh//U5x51Boel+ohUzm+ovGaa6dyKng3t10Opn//epTIaPzB+S9YHb6oPHPN1O
	 m7hzNxrlvYy5Ay1mp7sKm4Q8wGsl96RZLQ2gi/RhlsiXGoXz9PZMU83E1KMuM9Oz5d
	 zbFAX1C1rdBLugg5ZtTA9HMEh/HpveZJswYoLKBr93mIFli52H86C0ERgGKrXwLFEJ
	 vzvy+jb72HBODWHZaxSZ4pqe7EyykoyuWfnAA0YOY0D8zz7K17VPJRldf0biqVbWNx
	 nvopX30KagZag==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3414F39D0C1A;
	Thu,  2 Oct 2025 23:51:26 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 6.18
From: pr-tracker-bot@kernel.org
In-Reply-To: <5dc1b53d-29fb-42f6-9fff-d6b42da17a7f@suse.cz>
References: <5dc1b53d-29fb-42f6-9fff-d6b42da17a7f@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <5dc1b53d-29fb-42f6-9fff-d6b42da17a7f@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18
X-PR-Tracked-Commit-Id: ca74b8cadaad4b179f77f1f4dc3d288be9a580f1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 24d9e8b3c9c8a6f72c8b4c196a703e144928d919
Message-Id: <175944908504.3515818.10469899338669816557.pr-tracker-bot@kernel.org>
Date: Thu, 02 Oct 2025 23:51:25 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, Alexei Starovoitov <ast@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>
X-Stat-Signature: 34txmiq7rzpu6dubbzrpsassntrzh4oa
X-Rspam-User: 
X-Rspamd-Queue-Id: 79852C000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1759449094-947586
X-HE-Meta: U2FsdGVkX198DXn1T910KcSbQj0E88Shq6QLE9Gf+31BPWZwN8hnvOjfip3miN4uKF+UaM+r9DIEKyRkyXAycO1yhckNyyrhprvmKxO6+/gP7lW+lu7wi7CMvlg64TFrS2idjz6In/u85U33TWtX5CjYCOZX+6MK9SA0yG5a9NoqCNC7fdexDSgnSZHRfOQLjSZrcFEygqVTNLSKvEGrqKyLx17QHeFmhIHWmEq250zPNUhy/pthji1cXijlsx/KhUZ9GnnOCX7i3aPiJWImSQznBOmLpBNr52nzmyDsgNVkqH0x6x5xLY/KOxIgKE18grL+uiiYjTSbbOKdxuOWQUpH1ge7N/yf9eoFVkOx/89qni6M9LorIfGQ4R4SAXwJ1GOwGlr+/0qXIm08tNt0Z3Pz4n0p/xH3UODB0LZMZXoqGlvVmft2+h6D7rDzivH/Z7Ya4LdcS6YQsvBxhsyJlDrh4AgL0iJEhQSuB1owoVhGhQULsQqYtCrnNWJ2HZ6dJeRFmwN+++4Z/0l9R7aGS7+NPX39tjW2SuQc5qipxWiSc8opCy4djFV8DDhk3RmLRQirqugVw7vSvTcHOzeqPY0MQLAnJdb17MmFG7R58qDV2FZ4tT+BGGD4y4+P7ILXi1GT/yS/8nSrhLD4nmSlBzN4fnaj+jfECRd9MKqmQ9JTL5abUKxZfWFTweMtISdlC/dzOj/053/FLKJWHh9pMsBYj4BEwJ7wutg2KIVfZV/65AmdEaiBoT4WDCAv2pWDBvNtbJTS0rox+2gMaMeFRVQNpSneSs0h8bKotDm6pPqCE20uunFdP3GjKByIzoArxMvGhFIyTn6heHmvRmUka7H0LSXNLfggYqPQg3xwIVgLXhIm2DMXy/KSI6SOEWeFlVJoOjbWQVw4WoKlT9nPGmN264zVQIsy7PZpCOyvbCyKKIMhW6I+eAdsFi9JfExRl8zckPKDhLhzonEFNnX
 XbvGK4Kf
 YXg+M+I43t1432OA5x1eH5ov+ooCwCb7B2iRfar+brhuUmmAE9xq43rc2uqC/+F2DPVJWI6Ki8qbBz5iwvyCwnBl3y3XFNUhnG1zrNcVFYSk05PMla1dMuU0hBgJPLB/hSAKgOGjDUN5HWUFX1pA2S5Iz6uTuZeu6ZtkCFszZVfSlviV5b5xCuzBQpFYuLygct/6xaOQG2D4w6IzF+joD1bFnj67HdnMaxe6uz5BgDA3RKh8W/uk7z9FtUAhLRI92B9BVrD7TqwK+yauwbvSuzkU/0QiPNiosxN1kbhJ95omkAza7TxIIYSVH1nZmEtN9jtFaP7K+T3aIIP4+yR/RQTY2MCmELqtnIETmqaSpN9HkFA4rTHfhh2GdG5PmtLnFy3H3yI66OA6KTvZwAAVBZbBgvg8IGW3nkQc/4TO1tP4Ui1UGPdLzY0TcsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Tue, 30 Sep 2025 08:29:38 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/24d9e8b3c9c8a6f72c8b4c196a703e144928d919

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

