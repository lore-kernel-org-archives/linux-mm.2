Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C6B606B2B3
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WJ1qq0pg
Received: by kanga.kvack.org (Postfix)
	id 8C4206B0BE7; Fri, 23 Oct 2026 15:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874A36B0BE8; Fri, 23 Oct 2026 15:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7638F6B0BE9; Fri, 23 Oct 2026 15:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 534FD6B0BE7
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:58:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEE02C0201
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:58:11 +0000 (UTC)
X-FDA: 85354952382.11.F215191
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EFF6C180008
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:58:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WJ1qq0pg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=SoLUd57UpurzCp3TfNrochKgqeTvNyyRQnHVp8etxRw=;
	b=etYOZblOCUGtp24sMIn1QVXappot8K4lc86n61TQzw7FhgEDLc7I0fuy0EXe8Mus1yBHyj
	CfpbbgOzB/xqExiF7s2OrhojWlCtN8m510rjg3h/WdN+VQMuDNHSDgxDRy233uHDZuiEni
	5kwYFliea/K7Z2x7rVmPSC5glDwJtF8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WJ1qq0pg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792785490;
	b=Dr144HmuPBZ/WavjPc0iw5B3PG6n96lDke0PfXU4MPEXHbtJMt4Aatw11WHBmU5lO1xDbT
	e8KWh8KVZedrogMtpu+T5cAnRNqpgDP5BJxgXv3xGyAxqknCdh7jb3VIHdHbn67XQ8RajX
	rJgTPSeC3j/vlgTSyHY/euWb5BEX3kU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D42043B19;
	Fri, 23 Oct 2026 19:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4901F01828;
	Fri, 23 Oct 2026 19:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785488;
	bh=SoLUd57UpurzCp3TfNrochKgqeTvNyyRQnHVp8etxRw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=WJ1qq0pgTQP6p/PgBL1uXk1Nxpqk5rDGgeTaqGJT7hM4te6Tk+yIw9Cy2EQr2wDBu
	 PmowCgiyDFyG56bZSg9gABAOKtpVHfzOLiFUBQyfzMI54aw052D/2UDrSqJRbvaSov
	 sVFvUigNGma3uE0ygFwZnxcfTXl/9qIiTbbU2QA1fQsevaPrD9pa6wzPok2f02f60y
	 4jgsnnbQsCn7EMFqwOYopURxynkq422HW3stKLoGxgjyGdusNQYAewXbXA0CMVBpJl
	 r/+c+3imJmoGkV6nLpOEiENr3jEoLsDR0/M+oMbLIR/HlBrr4KUn4e6rssTYYzRU6G
	 LNPpyPny57TWw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 44681391B153;
	Fri, 23 Oct 2026 19:58:08 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <atoJsKNb5KiE44jl@thinkstation>
References: <atoJsKNb5KiE44jl@thinkstation>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <atoJsKNb5KiE44jl@thinkstation>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.4
X-PR-Tracked-Commit-Id: d15d7703166daf7bd62c844a3cb1b3a6279adb4c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7a78f7ba9f24962c8033e0152bf34a7903ff61ba
Message-Id: <179278548679.1241373.15147187620040740346.pr-tracker-bot@kernel.org>
Date: Fri, 23 Oct 2026 19:58:06 +0000
To: Harry Yoo <harry@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Imre Kaloz <kaloz@kernel.org>, Karl Mehltretter <kmehltretter@gmail.com>, Kees Cook <kees@kernel.org>, Longlong Xia <xialonglong@kylinos.cn>, Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
X-Rspamd-Queue-Id: EFF6C180008
X-Rspam-User: 
X-Stat-Signature: x76o8wpik4w14o6o8tran48a7a1joccf
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792785489-225391
X-HE-Meta: U2FsdGVkX1+9J77s9eMjUwZxXft9xeU1ee0CDbvcrZe9uRWegqUSb55IIlGgWQU0//upy2VoKFDsstrNBrkuAgRFvZw3D/biUbs3xIR2RhvIsaXwdqlp5cKYfwdamdH+s8teSQuIA1GbF8mYfKu59QKCHkuzPS/hL0SDN1Wyg3IIpGJtb1xqxUPkXvRrB/8tE71NqPoQAH5w97ZfsI5Pqviz4YEuK1grZgVD/6jJuI7iORZ5vjBLYqEvmpw9GC6YqdlbHYutacnEcjVfL9Wgu7Urc+vWjpLluP4WXrj/Io0TgqyS3n3XdHyk3iXPAnHQEUM8330Ni/hQNuZq0lzYxasMYW7P0nz+1u1aO4h3cpaS3MUNKrpaPUarsEc1wQMK5BslCi/og9uTZWy6jDXoynavad7P3iW8Nbbczoa0qAMJdW3MqtiTLczrFUAQrgJmjNS9ax4n2up6oLrjP2KGhMqen9qGDSF1tjXvIhTYzQm5R92OyZ8bSt5Q7Z/Y1ckBSnU9vlhs5dPkKkTgOs8F3R4+mJp990HjeZrCFQVlx97NFFWzPOmhrey/ZmPOPFuyaPQtQqWzFsrc7Zoqb7fVVws1RJkSelvEj3HzmvekNvDWMN+8jtW/kioIIef4yR2GbXjoXzN4a0YFpT8SEgpKpukHH4Nb183anJcqscLqP8R2YJblytu94JNCoXnDafcJMxL/wCNiFDxq12ohqy76AQf0WtYtEo2noFLd4PJs1uxqtKRKSR3X7sUf1PvonyzKCUdmgJm9j+KkkCY4cWWQWvYL1VOhYVBSZqwnUZ3ARwYwUCYBF3V/zCWz2+96PQjYbmfhUPbSgRN3Sa/0KchMI7sXAGP1gnjZ5ED9cEnrUqSMJjZSeRh63QKdqBema3wtinWFT8VJdccXkQh4yttbz4Y7FZKCPaHjVKjLFFNtQ1KrqB/pu0nS9XxABKy/IQZca/CTnRBm/O3Uofsg/CT
 DaFzqkFP
 59Za8NmhBlM6TS1vXM+5lyAlFa1xWleQR6fc2KiqmDZQQVuLRXHnyv3zB8HC9ViTlue7EkDeXam3z6pWIU/bhATi9eQiSgbQSh88bX6dm2dtWzyfyEX/kra9iw+r5rM7puuqmJC3TtehIYosP+s+ar7g5s6bnjodqyLMqAPlab8oDU3bfukq7kwol5PtO7hZFvxEW+KohYdeWi0//1XYvCkqZTKCvnh/A3P4fM2sg2xi96fi/AC+VfIRTTXsOxJTSVy2GW4DoTpnGD8MTeKxtcMo1vzJiFqDP0PcYoxY0tUVDcBb9MfoQUV0tXA6BF+JFiFTTsr6zymIIQ5QzK+SMwltGp+q4QdzfOMrxD83ONvlQZAunVw2zqwG4oq7oS50gI2SpL46saTb3Bfkng/JqzrRYAOw1YA2Ls6BryFV2m9o6XNVVbzUhuAIU0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Thu, 22 Oct 2026 14:10:13 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7a78f7ba9f24962c8033e0152bf34a7903ff61ba

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

