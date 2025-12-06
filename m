Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0EFAD3ABC4
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 00:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C1C6B00B7; Fri,  5 Dec 2025 19:19:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E776B00B8; Fri,  5 Dec 2025 19:19:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B220B6B00B9; Fri,  5 Dec 2025 19:19:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A352E6B00B7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:19:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6409B585A5
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:19:34 +0000 (UTC)
X-FDA: 84187137468.17.45146DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9AC9B80012
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:19:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QFGGa8Nf;
	spf=pass (imf02.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764980372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=rnIyhcRr+cBFBAiT/TGxMhODEzhhl+fqbabM0n+rAoo=;
	b=Istbu3HsNu+vNqoqVrxXe/cxS8XfRvPjIkKp8IdBtIKQJgeryeG2F9sF8cNKkTnroQPgec
	P2YlVnrm5JBbjm7VpMh3y6fB+KwBiNxW7zCJ3vrUEUGnCNdT3YsiUUe6uRgWtCCOypvKXF
	f1d/EBS3zKrI1WeAGZRy+2nJwxWx8VQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QFGGa8Nf;
	spf=pass (imf02.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764980372; a=rsa-sha256;
	cv=none;
	b=3M/GY+T4KJrGdTe1VDoHmbYaZOVuki7wPHC6WcLIyh9fcmcPrhj94Z3XJrCK6xs2VaHre1
	Air5sH4KjqBXYcg8ldIlG0oXLHTsAkAEV5mdZuySi27wJ1NL4RostHjhC3W2WShkwOD1A/
	7e66KAiDNG4oSMSUwCxbYaZFyfgaIQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B2BC560010;
	Sat,  6 Dec 2025 00:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB73C116B1;
	Sat,  6 Dec 2025 00:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764980371;
	bh=3etdHXSgtNYaEFUmgruCO24HTvt5AYTu0uxT7IBnUcQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QFGGa8NfLjC1InBOhTibkDHpgzIfL1CyCFJJuoSLwER+CI30Z6Ed8kqDqBCysV0Ow
	 ehy3mpRaC13ofFn0ZG4feletaqBePnlDkOnJWCNnh68c4loysX12Xypo/W1ZEMXAxw
	 q0wpFI9fIj4hzKR/voXXAvOwhvfpo0I/avm4Gw+o2fIoRnoa39VjKSCD7EQ0C3fLbc
	 0Vt2S4hBsziFNDwEXtNS51+jaxWEqfTHFU05dehe1ccAHGdACJzgj51W0gDFkKX39B
	 bMkN4dJbRr1eR2j8m8Is4dCPR9GWlezVuBUMxUNC7IdnINovjJWwLfT4wfgrbyhARn
	 KUSUcgcnJgNKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0E6203808200;
	Sat,  6 Dec 2025 00:16:30 +0000 (UTC)
Subject: Re: [git pull][vfs] tree-in-dcache stuff
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251204064706.GJ1712166@ZenIV>
References: <20251204064706.GJ1712166@ZenIV>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251204064706.GJ1712166@ZenIV>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git tags/pull-persistency
X-PR-Tracked-Commit-Id: eb028c33451af08bb34f45c6be6967ef1c98cbd1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7cd122b55283d3ceef71a5b723ccaa03a72284b4
Message-Id: <176498018885.1869773.11235050751770031700.pr-tracker-bot@kernel.org>
Date: Sat, 06 Dec 2025 00:16:28 +0000
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Ian Kent <raven@themaw.net>, Miklos Szeredi <miklos@szeredi.hu>, NeilBrown <neil@brown.name>, Andreas Hindborg <a.hindborg@kernel.org>, linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, Kees Cook <kees@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Paul Moore <paul@paul-moore.com>, Casey Schaufler <casey@schaufler-ca.com>, linuxppc-dev@lists.ozlabs.org, John Johansen <john.johansen@canonical.com>, selinux@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, Chris Mason <clm@meta.com>
X-Stat-Signature: jj1wqoyqe91tx9rfysok173xw6gzgxmy
X-Rspamd-Queue-Id: 9AC9B80012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764980372-721701
X-HE-Meta: U2FsdGVkX1+eyii3/0nNDbsGoBzihWS+ESa9y/HwUub5/uI95l/IdkclaUJzQokoX+kOVVr4pOkvX5Weu14UJF+nLm4Hg8OE6ebXVkdpTG3arGP5ZWAn8M5/1vYO9uYVR+QEGzlJE/nwuiWWHgNTDm2E3LeKksAG+YMfBKE8eN049lQ9vje9v41uVjEj6qgTb9HLyoLeUxNuOfazZvmomxBlQdTzkeJOpTbyVL4/zNfftNS8/Sh5RdW9tFi1NqLgTE6qnIoXTBkL/IAxb7e2N1tPTWtLW6pO79a3UpIovofSpTGOLPUJW7mBcuTRHkDNvxoQkj9td+cqOCHOQqw12MPHxGvr77VqEj0UE6ZIMiajqIGR1DnFUPPcEFG0qqvgGNaWf3lWO6sStXdvcznj4/5SlSIo3w1e8W49DVEp7YXHqqsxG8P6NczQ1xzXW4myQ8OyVZh3VPIKP7gx+5EssuVN77LpYxS7Ox1RNUkCjrFzBbY/LSA2mah6Y/Fl9D5R7Z55cMAuryhlWDb4nTDLN0NE5S/nCVAjn3LrywkMcQtDlQJIhQjXdq7RG/Lu6tBZ3xN1mSrJdmQd1AwPnBSy1U23bQPG95Crkm3RLskYJoSroajpzdI48ny7uqEkBWqYk/eYXhuzuDm+0A4DAHUT0zArlGM4I9cX2gOSsSSpZbwBocm7BNRwSwW2NnmXLt/rHLWZGPb487DaNH5DF7UlHlUbAea/YXDVTp7BdQF55rd11NKVDOYDD1F5JyFTdF0aUsMKKsxkwUyfODTzoPGlas+Xq9kE3Rw0JRCOreekku34zxldGeMREjgWdev/M3pZ8Htuf5Fd8yAsj9/KO6nDH1fWn+wRf7z5UE0Ga9uvgAWp/vuflj+MGf6EHLPZ9kdQSF/Grg24PfpJ5CGzJ2F2Y8TvuUbJByunsngal8mp/WMbtXyoUEda1wqk30IGQLQWDfnOPzNesLvbXBoibvR
 d5cDdO+H
 jd+496RkQm+tUduvg/KgYyTS1gVEp157G4Vn4BElqdrqtcNJhO1Q3iH570e41KK1ixWz79POLWyW4Sy5G2IW/fXvkgxZNxjgXbh6e7MVdTvB5yDReyBTvPGcegUK8fxof7SjBkuBlDEmv+Ds0PZiQa7+Y7ksmXImiPRhOLI+KPafnhawgO5UnzD1Vyz4BIWGE8znQ80zWoIEO96l34lGqPgept5zB1D1GPSk1tAsi6pqaOBVenFSXQpB8IJc7EXxaSOBATPEXq9we6mGkqfGfBuv71A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 4 Dec 2025 06:47:06 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git tags/pull-persistency

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7cd122b55283d3ceef71a5b723ccaa03a72284b4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

