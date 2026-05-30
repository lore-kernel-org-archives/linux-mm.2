Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E08A4CD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C176B00C8; Sat, 30 May 2026 18:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387C16B00CA; Sat, 30 May 2026 18:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3816B00CB; Sat, 30 May 2026 18:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B68B6B00C8
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:43:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C20B114029A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:43:45 +0000 (UTC)
X-FDA: 84825564810.20.B8718C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE8F5140005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:43:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUVdjpm5;
	spf=pass (imf09.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780181024; a=rsa-sha256;
	cv=none;
	b=fKGmT4bmIlXC588f8mcaTRWAhEU3VHJ+yqbhPeA+YFqfpjLDD38hbJL9SO9s8J24YQ+AK4
	ty0OTbjy16QaKoV2jqmf3RYejo2RsbJ6tDzTx6uLimjEO1teMutT/Aoqpc9TV2otHTc5RN
	COpc7vfzEjE+B39MX6fObQbvnzu5b8U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUVdjpm5;
	spf=pass (imf09.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780181024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=AqHHEDBCPx6eeTdQuLTbUwe3Ba19PriW4VAa7ABkIPE=;
	b=H4QRaE63/8pE/BmBR/4lsKbfxh6zSml1NJ4e8dxFa4eNdpqx/WRHfpJzz5iRhyrdP1vTRP
	uGsGchmaVAvzI+IE/F0elldYTxustZb0jcxPZq4ZMOhPpb1r2FwXaQW4mkU9wvTYhmVjxr
	HuWRLZ/C/+tTmEzv0LAJzptS1NYpvoY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 475804419B;
	Sat, 30 May 2026 22:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AEF1F00893;
	Sat, 30 May 2026 22:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780181023;
	bh=AqHHEDBCPx6eeTdQuLTbUwe3Ba19PriW4VAa7ABkIPE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=HUVdjpm55vVXCd/rXrwyIjaRGzI/fs2NJX0EBQ6KrxBOOuvU6xnttiGhlUzfLbCXd
	 5P1LCXQH84oX1vvDDO27joomvFYSw8kj7jpAuZxWwlCvZ7WEf3DnmvQAWKGn9VrEDz
	 JpHeZRtDluioBAlJ06fdEtZSdjJkYED9uPjWXinXSlCvOIonez1GpaBvVFJarWq7Mj
	 BfW5wXs7pI7DnKmuHrzCoayfxEOE/i4/qPQPlmnx7a2mwwBmOEKlDpL8ta609wtPG6
	 4T/gtosrA9PX4gervwVl8jpkRy6ODC9KCHAIUjC7Jz+xDgon3BpCHf5L/u04D/WHBB
	 1PegnMM4Kecuw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9393739302C0;
	Sat, 30 May 2026 22:43:47 +0000 (UTC)
Subject: Re: [GIT PULL] liveupdate: kho: two regression fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260530171420.1430298-1-rppt@kernel.org>
References: <20260530171420.1430298-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260530171420.1430298-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-fixes-2026-05-30
X-PR-Tracked-Commit-Id: 8fd2f26fa2a33cfe8ac043f976137ecf5b567f03
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9d87d0fc8c8e0a2a2b5026a169db2f270b4828c1
Message-Id: <178018102619.2731103.8401182140479584451.pr-tracker-bot@kernel.org>
Date: Sat, 30 May 2026 22:43:46 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Rspam-User: 
X-Rspamd-Queue-Id: EE8F5140005
X-Rspamd-Server: rspam03
X-Stat-Signature: xs9abqq4xzafqbfgfhh5eakcbsdpku6m
X-HE-Tag: 1780181023-907555
X-HE-Meta: U2FsdGVkX1/mIJlmIawayU+X9B14jXEyYUeyMuHdh1PpWryMghUQY4UbImlydaqhAG9Y8N9WDO6cwn5zSeWzPGjZBgO5nu2gr3Xqy1ij6i4vjBysJZ2QK0fThEr3KUMQZ/BOdgbSmVm+XbyRtKRcUen4A0EDicO4AQ/+oht22HTLMzKyZxRG8V1Yxjj+MbLQVtsOlki5lEVXoNGaJm4hDAgv9daUaI8czomhqhEerpM1Sy6iV4Z5eIBNOIoD/HK6cN9p5bb2vwnjYKB+9jlyEGOoPN+bz6GVd4++mS/y/McJdw2LEr5VGcg0TGFgFs3LTx99bnp5Yk27Dx0Xc7qYGqn2aiBc8+7zVG0SqIU1+Z+AWJUTDsLo4Mj7TD7Mf7gc/VROd7CDbNR48HsJbnN+qvfCZm362N+SpTWlg5R00lY12UcGzeCfLTWNEdyZ5Rnzva+IncLuPj9lzvv3TACGYEZunxBZVpjDG+BDYdUzEbr2lzF1vzipkzznSPX+TsP3DWqDJUMvSJiD3o50M4VAWiyJsw7eIceglAmBW92xvEa6rmeft5AtWwLu4//vvYCJoGkL5dUnXrZYx3NbbW+sh/twmXJG/Nj0KEjMxzb1SPIUMAWijgyPB6Ag24kkQAFQnp964Hv9IJySUxhVpTHFDqs8R2XzlVnEhHbdiOxtyUa5jhEzhk2pi12H3dz09xNzfwBuixZU7nFP/4FwLvNwbsJ0DkAV1WgXOrhJVnM9Ow9okumhjtAHnvr5ejgsfe0vuKGIiTQz4rTIsfkkAVglbcc7c8zqg2R90S9a9sW2Q+gIYqFO+7vks5WPw5e8AsYe1LQqYW6X5BWwKSULy1JD3F8gO7QDK7icioTTCIypDR1yVAZhtvwnKPOb9E2BYByPWU15cxRzk1BlR0rhhkvxHHX6ztrCmNBDAJbM3CoRj2LTRyAolNhd+3B959pQuAMFGLa7azUISX6wMJnl+3k
 dJeL+zGO
 yhDUTjRhAKg8DKl25kvk8tWebH4im8pqYhM0C6k1TMBa3wKKrXswYBWU01RuPdfEB2B+mlTX8Bmv3NozbhmWU8Fr9cDR+iuhdPBmw88+mHVQcV5vrLhDE8g7McWXd5hHkJVAPNNefiqXZL6aWh89f6TEln+3jpL6urzZC97E/GfC1jGwrmrgWnoEKStcuObcqg15g9JKUQfA/PQzu36UCDZtk3EDTToQctDrYSQwd3l37rcf96EBS5+7OvVeKlk4qT4FhvFDNLzhJjAypuV5XuKYehW25AR/QBDncuJi1sNCDvK73t5SJ+21afFuJnVVR66uA+ZcQocW7KKNtK4mdJTiKGrmUwvw5TaMZK72a98aZkBSPIXG/hbCOeVm0XV8fDr0wEWX8APvKUVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 30 May 2026 20:14:20 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-fixes-2026-05-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9d87d0fc8c8e0a2a2b5026a169db2f270b4828c1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

