Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F1CCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 18:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39148E000D; Thu,  4 Sep 2025 14:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12558E0003; Thu,  4 Sep 2025 14:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D778E000D; Thu,  4 Sep 2025 14:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 958C78E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:05:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B3285886F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:05:21 +0000 (UTC)
X-FDA: 83852344842.07.EF93B9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 33DD240011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:05:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AsMt3fT0;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757009119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=1C6OpEEtpnFao5UgAtxujgFIWdi0TwzKl6ZATQG3PVs=;
	b=ysU52Tjt7bm1SWblIZIKWWurlOmSONLzbhoWWonezyv66a5+LIKkcYb4DW4KImWk6dWR7+
	vBvytjbPatP49P7xhxjrgS3/MaHZdjU+m6VDjNYb9+ArRuKDGxDEs7hfaRhzuaiHMvv7xT
	CEaoa5T18mpwtQN84qIaYulgsYEKE10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757009119; a=rsa-sha256;
	cv=none;
	b=Dl/xZqE9CKhY3bsNa8aIlBYnHNf0Uk+zuld3w3T03Qt7qMlztcIibRjktSqtxXe3vzAu73
	DK4W9fiQNwg6r9I8UK4/DDvsFtx1AN/8WIE3I0+h2Ijg9mpZH1v7lXxmpSBxncEUmjmu75
	QAIENX+zsUeenPNyUwcamss67ZNuFZM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AsMt3fT0;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16D154337F;
	Thu,  4 Sep 2025 18:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E680FC4CEF0;
	Thu,  4 Sep 2025 18:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757009117;
	bh=8ulsMfA/KMzKbG7c59/17M8ZAo7RjHes/979ig8CJtU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AsMt3fT0X7R+RG7pnW72ce1cRwGeubeoQGIUJsJfvQ2/+oq0+EIkhqpa6zugO4CiF
	 nNQn/s3qUBSrkLM3OEsulmDl2IS38zMyyiME9YrzICwQ8TY/3aOFoUsDHzaRv9rJlC
	 jSs2L3G8si2Y6ZABVogcFcCNa8PlouazAzLvo+8TpBPRPXKHhyqj9fISCWCIkpjwbl
	 MCU98LzT9D+pdJHIYT9MD6S4S2dytQZRIlc7kODqlsPycNzT4bSXaHnX8fnMirbxTS
	 XoRnUKWWILwsVVNe2I5lkzDXg/qE5x74MJ5pG5jYKgwhRq68Phlffw3f7UMvIk2mfo
	 7e+B5kyxs9KUQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB007383BF69;
	Thu,  4 Sep 2025 18:05:23 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 6.17-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <c15d56f1-b1f9-4ed2-8f20-1d8111ac1115@suse.cz>
References: <c15d56f1-b1f9-4ed2-8f20-1d8111ac1115@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <c15d56f1-b1f9-4ed2-8f20-1d8111ac1115@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.17-rc5
X-PR-Tracked-Commit-Id: 850470a8413a8a78e772c4f6bd9fe81ec6bd5b0f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 68f285e2647814754b9ba77b79cb32c9be2146aa
Message-Id: <175700912239.1902706.2859418068871650704.pr-tracker-bot@kernel.org>
Date: Thu, 04 Sep 2025 18:05:22 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33DD240011
X-Stat-Signature: bnodahjw1sgym5bx9okqfxi5xbbd79ke
X-Rspam-User: 
X-HE-Tag: 1757009118-729153
X-HE-Meta: U2FsdGVkX1/VTGiNeCCHuyCu2IDpHFrq0Y4DI/NkEklG6cVwcJUCaYF+0u4nt8YDPLT/qveZojqLYXFs0eY4cUdHIp3D9kZOYEe5XIK0/L+37sswIHEfTRy83lJQQfiof+FAZruBo0gTrt+GUZbqBsOaIEh2XSnUyfCJ+oemrWXeIUHUdnEhZcfZ+jPzbInyDIsct9h9PLLENER4HKpCgZ5AU6ZSK9bixIkruR2HnLAl8TSm81kJllxEAVnonW8i8OSo3WO8UHY4NOpKNwNwcwwNqHTXcXh37ZLerxMHzoXaahm5RjF/qGX5Ar92hJH1zNDjXWeokEXbONdp28jQT9Ng7Y40Sg22pELuZZMP6MD3xKeu/xiLgFQt55dXxr22jMEd7vDoqc1RmKFjQBGHFT7TL/KVNRFxaf7EpX0mXo7GZ5q40za8n7HIb3Ds+HKIUPuqo84ucyQPRdGvOwt+xlnesvVNrkbBMcMT70D9V+/JPagAEh9FZqcnvAg3c8QDoZQbB60ylExp5wg12/axMX8YEfSsLjaqjOy04nXwskBlYf+BG5wCfkx1FR/ZY/JRwOOnQANc7OHjK0btro10Z4VwuIIpf2GdIB2edtctYFaIa7Ec73J34sUKI25cHzbKGgJgWcodiMX7I4hfA0y+KoKxGRt1byPFYRa+rx/dhQ33hyC2vBvf89Qu8eLRoRNVYz6TMrmsx+MUp6MDkjadWjrdqMSz3OiyO/dORStRER3VmrFUaQmoIK44kUyjdD6IHGyRLxEg6tkjmrqDYiW+DkqtrfPqPj5SThwkns6v3ObMnFXxPAJwJA1XxKXqAEWUdCUITgoshAmaCuIYfhxW0j2VbGH36Cd1/2zjAfxaNqRnCihXtmtsDnloreNjZ6eyXwy6/avHpA6As2jzrZNlm37lH+idYW6proCNGjtZ/ZvM21fyqdkIWYArInizu35jkIbWr8e47oQ0EmVtlt5
 9voAaA4u
 hrlJhZRsHnBmFNLYHp13Lwt4VuiMSA43qW/XNlC7rWkxtTp0IEgkSMayfjs8bslwOQkA0PXLuMOtO58SR4VgXo3LX1F9Uuqnx1EoXXUMi2w/EWMzdRXoPjoWGnyO2v6uRtE90gWBQSff2J+6uy7SZ3YuC2aHvhNqR5gHhu3o2G5hZ9jqQf7OoE+/00bwqERUZc5NNVOCGTzyTbAO4LXDC5j61FbnkFW5gQlccHFOrhGmeENiEKHXbSSB6Js1k3gcyX394PRd846iArzhqO2EuNz6ZK3pcsHiPnINVoaQugyHGljGsq8poWX3O93HKGPDAO3MdiIKP8kWFJPvACZVkMS0HfAp62WWGbdCyJOZ17QZ5h0YyxcQX2t49OXCF9zbvjDPtdwJqDbcDP1vs2lxOxh3tlZX8zRtz0xRSqs+v5G3NF0E9fPFY3KQ6zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 4 Sep 2025 10:56:09 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.17-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/68f285e2647814754b9ba77b79cb32c9be2146aa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

