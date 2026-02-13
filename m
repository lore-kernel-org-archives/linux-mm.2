Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC1C1EF99E2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 23:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81696B0005; Fri, 13 Feb 2026 18:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EA86B0088; Fri, 13 Feb 2026 18:45:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10BA6B008A; Fri, 13 Feb 2026 18:45:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C15476B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 18:45:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 604A0591EC
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 23:45:50 +0000 (UTC)
X-FDA: 84441068460.04.1BE5412
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id BD1CAC0002
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 23:45:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GZ6LJlyZ;
	spf=pass (imf28.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771026348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRnShWY8WBzenx6fyoVyl29INCccNk7PeszikWUZXlU=;
	b=MSUY4KCIUhbslKSlMwIvxDlRhdwlG5nezdELx/sridzZmONK+7lhBr3H1fG3kdnstF9FPr
	1nLpu16h1/hpuj3Wr1rSp9zZ0/uB7H/2uZTlimycqp9XelT+TJeBiNkGPz3jUUMZSvR1bz
	HWsHkQsKwdCtisP77r8pSJZNuxB7o7I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GZ6LJlyZ;
	spf=pass (imf28.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771026348; a=rsa-sha256;
	cv=none;
	b=3ZbwRcCZzSpGsODTdyvZO4YoiKD2fe1fTmO9UXZmh6fY6SxdobO7ktPdzvOX7Ch67geNTF
	Q5/HC0X5b8NsuldSO4saSZHhu+4nFTMbsapfB+l6llaW4vQtzumpBDNIviFyklTfeMrnNs
	qvoC0qyn07db+eD7p7Sj0sm0QKw9z5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E8DC860054;
	Fri, 13 Feb 2026 23:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9850FC116C6;
	Fri, 13 Feb 2026 23:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771026347;
	bh=EWfaKJCaJC2GErydog5q9S65WnGr3OmrX5J6uwCpiPk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GZ6LJlyZWLf4CDD5S/zkdrpwC2BXwCpeTxgo1tIB1sIcZco7UXK8Hdj4gaVXMxXwz
	 IyqXcv7lo9oeR//v00ELuNg66qlpw9bzGf7XqxUsNZMUy2EUCuPJfnzRQ1UU8fcLlH
	 XG3ptvUaXIezNwP1k8g2s9vlYWAy5TLqIVLvJpQllknBDZYAWaxwdcpzqzL9a8DSFM
	 vnZGWriKQS6uWTi8U36rK9OmdRe3GVAcGatiya2g+PIQbWFkJZLl68iGfdtr/ckr+d
	 tNCTSaRznDdLmk0AHz72k2L6ZggIyYEgpgkRpO+AMCQt8ZOgVU9i01qo8tS+bjd69S
	 YnCUoqkY9aHvg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 852673811A44;
	Fri, 13 Feb 2026 23:45:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH mm-hotfixes-stable] procfs: fix possible double mmput() in
 do_procmap_query()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177102634133.2575868.4556838261873713161.git-patchwork-notify@kernel.org>
Date: Fri, 13 Feb 2026 23:45:41 +0000
References: <20260210192738.3041609-1-andrii@kernel.org>
In-Reply-To: <20260210192738.3041609-1-andrii@kernel.org>
To: Andrii Nakryiko <andrii@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, surenb@google.com,
 shakeel.butt@linux.dev, ruikai@pwno.io, tglx@kernel.org,
 syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
X-Stat-Signature: wq877ewapx8w6ojrbccqi4ofc3kajsgn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD1CAC0002
X-HE-Tag: 1771026348-44071
X-HE-Meta: U2FsdGVkX1+VL5wNfRBOQultDbB0D2rUcmQh6RmCzuJG7cFOO9/0E4ShqDHG01DTTajEIU20uHgyvt/KnVruodKAYzMFBdTvUtqCLUWjy4UR6iXV3sCr1zlgBJnsRyFfCMgI/ZboPLywESklf8saHoLqvHbejoo51LdYb4JNap6wCuh62ViaqUVls/9+gHUpYjGERB+SPZqj4dRraykzzc+SOLpHrES3FpHcn54WZDtBb+aMgR1zJ4BG78TQD1QujN2JvMvlHuol5tII53yR6U3eF6XXdNEjquSa4LCny9GuyyDSANbjcWq7yhYC/eSLmYCC9JdfPLyeNrwTDo6bAZFiSprg1JGSwK+H+YRO9hYOUewAhKBj/rI5FkvIGrRDiycmwztsrb0xd3Bt4+JCeKaoN/maDDEveQv3cSRZy6CZMXPbLYFe7EVCFERKWU3EjMzrCZo/uVe+AM1/L40wXMSjjl5TOtZozibULtkQh0RlLuBxb13q29Xrs+zsiTvSqCCxjQRnRP5Zp7NxtK0GFwHBKY4ZDSha8YmVDSVEZU0Djo66eZ+ukev7k1NROyqaukqWb13QX3mHjkOlu3GuDgXGLLN/QSoBzs8ERVKDuBnpMaD2YlIZ2r5nPBc3LA/97dMP9wWbsjsrGVOhIx5gZfAl1eM87YHVYEB6Bp6pa8Z90QyLETeco0gjgYG5b8rJOxjS/tM0KcWpYcPRpR25+UO/0Q1WxtcJmEOlrSl3yK8b8ZUjNQEgvYqb6qL7XxDB+bZJDGNhn77wjFGQ9g540smO7zf2UIqZa5IuMFGmxoXBdy51DpYM3WUgWfXR/LjDHhht5AOZcas3+BZ++qVES/NGJREu9PhNp3INmfw8vp5NXXTQ7ejHfnna1U1TCDJRnb5z4O+p37XM4y25sctdBZQ88XXPzKAuKsYaSsuxqOmDuBK+OO7L2VwxRIo2PKejlx22CbStLpIgQkiI0wU
 XVjoxArq
 dAAQJRov557qGc4ETY+fBuAcqHqaaw57Mj/gdA4pNuNraFOXqerEXd3aFuC1NFE9/SoUltLEA4AcLZfiSI9Dz0hlD7c39+JVEgOL98uK9szPbSgNj1xHunSt7vNMZaTUEiSjc48LZ0vEMYryKizpCVI/V8OfFmrAiw4CKJ08Zi7qMDwzJY5uyhS7WPT815ejWUfCQNrK42qA8MJC/wBF+/apwVbQD36j0kAf6p7Ompcc8tGRB38hleTny1iVkZXouSRQFDCJ5nyJNtB3+HbIOjeGeVmuaIzlydyOfaBSd9LTPS68CchI/k9gXboRe3bvI0Q5c8HosNRJAh2Egz+10TjxP7No+TWjIxqFcn3EOJxtdnOH5eg9Qefa+hNbbmP7GPmS+BlXYIqdFIaVMf3E/Av5pLeVEk3vBtTG4BHI7V+G/HOLQJU1doxh5qHBCA3/TP/79Mr2P4ani4TBk6J6PGjH1M2zOZfQmjKhBWEVHBXSjS86f08KFOGbpNVEreXsu2rFYcZwclYa6/PxfpNW5Zcd2S95gT23qlRDr+4+nqDWJakOhrOIi6Bnt2rNwVOqm6j6D45zuBIoqGWCeKw2JfXVv1oNzCwFQOwv/vqX4Y4pU/GFZA6XPNE+iS1fosrGR6IZE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf.git (master)
by Andrew Morton <akpm@linux-foundation.org>:

On Tue, 10 Feb 2026 11:27:38 -0800 you wrote:
> When user provides incorrectly sized buffer for build ID for PROCMAP_QUERY we
> return with -ENAMETOOLONG error. After recent changes this condition happens
> later, after we unlocked mmap_lock/per-VMA lock and did mmput(), so original
> goto out is now wrong and will double-mmput() mm_struct. Fix by jumping
> further to clean up only vm_file and name_buf.
> 
> Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA lock")
> Reported-by: Ruikai Peng <ruikai@pwno.io>
> Reported-by: Thomas Gleixner <tglx@kernel.org>
> Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> 
> [...]

Here is the summary with links:
  - [mm-hotfixes-stable] procfs: fix possible double mmput() in do_procmap_query()
    https://git.kernel.org/bpf/bpf/c/61dc9f776705

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



