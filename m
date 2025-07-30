Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E824BC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 18:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E0E6B0089; Wed, 30 Jul 2025 14:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E51F6B008A; Wed, 30 Jul 2025 14:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722356B0092; Wed, 30 Jul 2025 14:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65B6B6B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:47:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0400133FD7
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:47:40 +0000 (UTC)
X-FDA: 83721814680.10.708E511
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27AC816000F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 18:47:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S4M64qoG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753901259; a=rsa-sha256;
	cv=none;
	b=B58M7RLCE6DEvasCIHHujWgkeiJlyq1kLfdkbxWAXSDQtOtBUq1xgnIDQv+5j0e4ZsQ+OW
	lkrxqZh4l/xE5nfg8iwvjrlvn30ysVcluwmYP/Xmu7d1iHXDw5J35Pn9kjaT88hrDR5ck0
	OBJQKZ4exH/DKej69kXdaQJ7fGkT6II=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S4M64qoG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753901259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=yaDpF7MKLZlNCaWCHoCAFFj1DpocFkix+LI4p2xT28w=;
	b=B//6SwPMztZhE3BznxeSFe9VnaG34GiAX0+ejkARMYIth3rsewz6s9Th3NlD8Tfv2X5Mh8
	7l4J1MYypwHbYjn3Tqgbuh7EcBMfA5T723aS5FuiiCvjNhHqDo1fFJ39goN5w+PiGG+y8o
	DsbK7sVfvDuyiGIJHrzT6VoImbuKACI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6D2041525;
	Wed, 30 Jul 2025 18:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D90C4CEE3;
	Wed, 30 Jul 2025 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753901257;
	bh=K7getUpp6HPWmQC8VsVkURa3c8jDl/KttxgQhok/8hE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=S4M64qoG28vMa8DJ6D6FwDxkQ0rcqqWoeeLlkxdbOBhCCujhbNIHpq4+hi8NIlsCH
	 3fQ5ymtnNyUZ2pUuSmgLvcKkWHHlsexGq9NXBzRwWnd7GVZEe3xYoYkfVVSO2GIzp2
	 RrzfGYJetzZQn7HIUqbiHCDAg7gpXOaPyqAFfEcTetQ1/GJP3dkRJS9Y6lY609Bvn9
	 cWx/UE0fzZeCU1Ny5EJinBUa1gB0VONaCwNK2LMlhJcDV0lJgOou28n2CpKxCmZ7zp
	 CLzR73mKEC/wk4M1KIYkuxGxFPPUjokK/2lTArreCUHamKzkTp5vRiypA2SnwR0yyD
	 QUo1ONZ0/SaWg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB1DB383BF5F;
	Wed, 30 Jul 2025 18:47:54 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <450d3876-90a9-4b1c-8d73-62ac19048991@suse.cz>
References: <450d3876-90a9-4b1c-8d73-62ac19048991@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <450d3876-90a9-4b1c-8d73-62ac19048991@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.17
X-PR-Tracked-Commit-Id: 8185696483dcb29688fc23c45c99d86b73754982
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e8d780dcd957d80725ad5dd00bab53b856429bc0
Message-Id: <175390127353.2433575.8108860167868806042.pr-tracker-bot@kernel.org>
Date: Wed, 30 Jul 2025 18:47:53 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, Bernard Metzler <bernard.metzler@linux.dev>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Howells <dhowells@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27AC816000F
X-Stat-Signature: 5yjtyxgntha59t1awgqigxc6mccwj6ec
X-HE-Tag: 1753901258-747929
X-HE-Meta: U2FsdGVkX18wCGe7gtIY0ImqnzjUZxSStg19L8QW1hHqWhL6KTjv8HfWxa8yqfOQ8ai5auFgS1gdvEJXzO2lND3ipmuBzREn+xtmO//AiKrWBpv3OwKF2Cl1gbAuq0jeKTDIMHt6e/LTnG0Cb/gKVWCY96BlRmTWEIJPc6Uhjzr1arlpYZfjQ1WXYI0lbR78H1bLnS1SNN8Q+BTJS29kTrIqznEx70E2z4P9ywguB84+9neOGANkS+ZjYgEtzt2d/IR2FY3psupUOS6AdohstspcBsG4RqMSrb7vYWrB7A8iy//birBYyPu5DhP8nUGwIYqmQE+JkmkoM6Fpzt/VHQ/Hijhv5rFJookPdI3gXFUbyztGONPhsfArex//FXsm9d7uzLILn3uV4W5EyL5Nby6aVEiYpSEPED5b7CWH53uAy2KGaPDRKPMvgx+XfaihkvBPVnCsxSnJJzKSqyo+OQKpgOZes0aSCHW+zMU+Pnbeh6fxMjAZwSemu16ntZkNWZEj/B9NboALqYfMj+A1NepguuzJIAECvL/C9lReUmNBVfPpzFZLr3neONm3HNkj3F22Xc5vVQem4dxzFllboV9lP+hKCKKd5olczU8v13QHFXE0UNlx5beX5eTmOH7CuNglzeIoOnDOIbhBVgC1wSHTXoLQbwgGEEPadmdIaeXGQptK8wZam+LKpTLS6G126rvBwovERUTrK6CPumfKlWOKTd5Shs+JshFDgTC2MBCtQAmZwEbUlWUGb2zwS/FeirzDSo7dxXFxL+ILlIpEgR+1qVDR5cyygPB7h+oosvNIjQEOIO0CwmW6eCfB2MxhfTlaYj7r9yyimGBhvRve2NvrLI5BDzoIhLlhqEZEo51sU0Hgvj1ra4KKdHlql38A/mtbca5dV5wvIsjMPI+gjSAKUCREvxfEg1xJfgR/sXzG4luRITg78yC94fpBjmci2xjq9nyQxsithXdR55Q
 pQZpDxBu
 iGPUejfjchQbuzX3GPJvosCINrZbP80z3gNZsIFSuV8JW4YOQ31cDS3fgvoyJqQi4+kYRIpk4ByXG/SUF9NMljFUBaorv/B8+4v9Z69nW0VHm2W9EzPTk32iuhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 28 Jul 2025 18:56:40 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e8d780dcd957d80725ad5dd00bab53b856429bc0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

