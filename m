Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE3DCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963488E0100; Fri, 24 Oct 2025 16:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC3A8E00C9; Fri, 24 Oct 2025 16:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B42A8E0100; Fri, 24 Oct 2025 16:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 636C48E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:32:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1185BC0F66
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:32:45 +0000 (UTC)
X-FDA: 84034156290.03.B64405A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2181C1C0006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:32:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTd0Kfig;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761337963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ERzm2O3fAYjVIZAOACzVqKwE8+a9xSIIK4HqwckePTM=;
	b=IsFVqkU818arRSz5ZL9KQG8NJt54ypaEKyUUuJYK1Hg1S5onVtcLJmf0NYaihLGK/agco4
	eOuyAKP86LAfYvyK2Pq8FtwZbU2uY7vsVvgCw4A3o+uNZ3fcDhYvdLEU5Rpuqnr/I1QSoE
	DOTSN6DUDC4iP6Flmxg5oGf7onXDLXQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761337963; a=rsa-sha256;
	cv=none;
	b=7IEORrSnO7VsaTnDdXuV2eQNPpOWCIMqHFu9MJuR7PxAo+cvPo046nmK7plBSfsYxUgn6R
	9eDGvqMX4Og7d229mpj8j+RCFMkJRIcmcEgUWv6BbE4Gv3P6nifHmpritRvBWzmBZlZoHB
	57WCoXjA0N8TRcyR33WRw1DPd/aj850=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTd0Kfig;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC49E43BC6;
	Fri, 24 Oct 2025 20:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC971C4CEF1;
	Fri, 24 Oct 2025 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761337961;
	bh=BZrwf98qxnwxNYWQktGux764UPgT3N3tre1nuWcqYwo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uTd0Kfig6cpOSrjY+oomqckgJWAvBxcekuweN5SjcM/Y/ejmUMOTkdSMDLfEVt3Qk
	 LD33Es6AWza2Wx64KTado9kXw07vW6MyylcijRBkdeLGFbkNEOQHw6Q1h24AHqbtSm
	 T0jrsddKhZHIb6bfdMeQ+kOHv13yOS+q163ipwZIfxcs8YnuAPrq1OjnkSWlhc6sWh
	 /z/0WNi6ls+E4rgZ8I3T1/SQeto+jpzxwMerRegp+Eh8W46C/ExhNjuUishXru9arp
	 QPq+kOIhFcrSgg/u4rHJUb5B0qvYwCPRwaStg/XqxfS8El9Rfgmk1dMysyJSCnDJ7O
	 BxciMwfXhXqHg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE0A0380AA4F;
	Fri, 24 Oct 2025 20:32:22 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 6.18-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <999cee4d-93f3-4c41-b2c2-7c046d4d3653@suse.cz>
References: <999cee4d-93f3-4c41-b2c2-7c046d4d3653@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <999cee4d-93f3-4c41-b2c2-7c046d4d3653@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc3
X-PR-Tracked-Commit-Id: 7f434e1d9a17ca5f567c9796c9c105a65c18db9a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 66cd8e9cb81015a2ec7f9dfb83db7d7915587eef
Message-Id: <176133794129.4053949.3265627509021002796.pr-tracker-bot@kernel.org>
Date: Fri, 24 Oct 2025 20:32:21 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
X-Rspamd-Server: rspam01
X-Stat-Signature: rk4kmim57abuwxncjnu9njzyznxyk3gu
X-Rspam-User: 
X-Rspamd-Queue-Id: 2181C1C0006
X-HE-Tag: 1761337962-402801
X-HE-Meta: U2FsdGVkX19ruC1YXsmova9A1jjILpO2z52dKrB76teK1T+EjFHsNeUI/VJb5iUKhkCmxhKtLJMLHuR+J49nNPNBw57aUjZ04icDRdMdY+fX+6LtnNOIyWEDq1VHkXz51GPaNDeTtp9kpwhZ1X9Y8It27kBeUJAKlqFsdIyJ5GeveJugtnRaYzhJiWJ7lWTdFAvawpLJPqUkpO1FHDu/ypZ+0VW/qvtSvuxjZABNds9lWyFWRmFt/p/v9hqq/yZYa1MVXEjr/ZKAT4Rlpq3rYOfOJhUL5QFBzKqjMtX5Ce2+Y0Eq+C7ZxwBpbzqN9TIkqpxkL/G8tfq0wceiKh4ioU71+RmDSAr7WOzWi2hIlwVmz4H4Vtp4bkuYpTCk2cl/B2zOtOTRs72BtkAP9A9UVsWPCkY3c8YR/w7h2ZHw8WJllgNw/SdxOcweY1y5N0GkItBP61Qz322XHXzucJovL8rbzSiie6R+/fuvo+yXUDC16tAWKo0sQHgx4paHJye5ZGtS+HRF3d8oK5klJTJMP2VZaYVyjIylQtZLQRi7SbY4X+9Mesopl2MguQDxoKlaCe6SJioqfvbzkm191Af5pHHbC0JGbdPQAl1l45dB0ckiCxZVGWAX/m55AO4C0nOL+OHwCyjMiHYZH/ZWa3D2UXwSr660NKbGvoLkgkY/Lz4OCAcgBbfetcpoyxu32ikR4H12sNFEh9ima6HqmQulahFM5FFtD0/T5NhI1oU8RKSpEpJuj7TmAnSGZ+verRgUQxtFHGAN7pIPOu5xPOLY/wpqYKtYQiyGg+TMltl6g4ReupzkqPRUguVdqdO4TvwPNZ81E0aah5PAqiX14yKTGYsKPyA/eeYtNEiK4c9xkHmZn6g1lqFUJSegEOkHrPMKPmhjYuf+1usHKnXyXeNYwU/iytb7I04bwWfbwkzE0Q/e6QbnT36TzJZKlMB1CVFixjjdjJ//6KqMourUj+B
 162C9RFB
 3JOLDo2Dnqc3TntDNsxUpuh3OCvnNDlRFe//ZRwrxome/Uyky2Wy8BKObS9i2Y+5NwEqZ1l1CK4e8zxk3LN1KbZJZkSUAFGfnXZNadUQHEuQRLAAVe+t1arnbNC0CHpR3iLTm1ZiMEnwq7y7rX66b3VCIvPxH8L5m47fI3TVRrMmp4/BPTipjSlnM+uiRFnuYSgyvQdYehkw1LgVeBR8UWAzxlN+dleN5iQp2eM2K66be79OZExDFw2B8rO7TkodVDQPtOfBIbfGIHHIrzDa+bHMMtoVxadxG3AwJAkknirqHz2rO+wPUC2I3maRlWfl2lqk9Qz5ZVtl/nMkLZtQbHh4dh9+tP8uPXdiCkqXUuEKvDceM0XP//PUmFfAoe0BvZPQy4wiA3XREOJ0s+4H5JGRm+3SysHj8ftdbIgQdbp3gWdss+6N05Wv8lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 24 Oct 2025 15:50:47 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/66cd8e9cb81015a2ec7f9dfb83db7d7915587eef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

