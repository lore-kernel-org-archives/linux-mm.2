Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B828606A326
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 03:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m1cg3drI
Received: by kanga.kvack.org (Postfix)
	id AD17D6B05B0; Sun, 25 Oct 2026 23:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82AF6B05B1; Sun, 25 Oct 2026 23:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BFB6B05B2; Sun, 25 Oct 2026 23:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB576B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 23:46:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08C5CC0627
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:46:24 +0000 (UTC)
X-FDA: 85363389888.09.D81B89E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 450D940005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:46:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m1cg3drI;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792986382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=8PA9GkfQf2cFoS0ayw2916W2lJqjiT1U9quZNhALY7M=;
	b=y4waqIVnGm8WPFGZtoqVDiSodAiZbEhQ1WTNY9CaH9ZxLaMCMvl27jZWy7vIEVunTGEMRU
	Jxpba7q0tdoB72NeljYYlOR1092qYczpzS/MuL1jdQzpEwW3XDgWiB2erXUdrE2M7/g7oA
	kQXfSJ8yGWp+blbY/kHiXFn8wV7g27g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m1cg3drI;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792986382;
	b=lMqxJSX6q6dehFfxAy0jxjpSa7OReiWe3d6i+Cxrtz3vkYM2xDvevWOphTjG2W3/VT6xhc
	bGhBb+Li6n37lQE7IXbU9b0K3d7HRxpAdh4SFaCvZFpNm3OTsA0L4UC5ac7VGgqLvVIc9r
	oXWyTCcBNJVFyW79MnWds6286B2Skrs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96D58600CB;
	Mon, 26 Oct 2026 03:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D72A1F01825;
	Mon, 26 Oct 2026 03:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792986381;
	bh=8PA9GkfQf2cFoS0ayw2916W2lJqjiT1U9quZNhALY7M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=m1cg3drIxo1khfwcePEIMT5l54AnUfXw6BRWhRgw1NG5ndhvC/r5UpDepyry8rOta
	 R+pUN+PZhVp2p2JnPF6Yqa2LQi0EppKeoOAdk36FWrUHiYD7qgwfFxy4dMzRwTe30x
	 QDO5Y+oqDMuQAL6JKCHkOL/TSxQ7MIRq2uxSQ/PXXMz+xSpDegkYvlBcdZ8VD7MoW8
	 ErRwqUfdp6LUuSktyi2VzqBIH/ipDlNLYxhrdeMqecBImbdqeUCwrY9g2s171zVsCF
	 xUR4XAZmJ/vD6duPwS96tL67qTrhGB8FPGiUGxixrzQH8ozdC5yw9/0vrd2zKMP00J
	 p9P/duBXu+KXQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 4463439EA761;
	Mon, 26 Oct 2026 03:46:21 +0000 (UTC)
Subject: Re: [GIT PULL] kexec: updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261024112155.3384616-1-rppt@kernel.org>
References: <20261024112155.3384616-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <kexec.lists.infradead.org>
X-PR-Tracked-Message-Id: <20261024112155.3384616-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/kexec-v7.4-rc1
X-PR-Tracked-Commit-Id: 833d2b79ed9520e77c5d83eb11644e5239b2c5bb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b3593aba315322d875f295eef8b1a19e24658ba6
Message-Id: <179298637979.2442679.15289838186801073122.pr-tracker-bot@kernel.org>
Date: Mon, 26 Oct 2026 03:46:19 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 450D940005
X-Stat-Signature: dzrcd81cg1179eae8phgjc4z85uio7ny
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792986382-412578
X-HE-Meta: U2FsdGVkX18tszDwBqYTqvVhzibzHV7M3LbxpL2y7hFuEgmd0JonvNiJkTlBXyxd7c5wLcLg+gDYSHXRB22lxY/o300IqJlUKStdO0YJYiQcmT7aFL8H+fE1jsWn38bK6S248EUGMFWQkP7t1nZDwlOo0Dj4TQjPsi6I1ix65jgNryjNQVFHmXH2n94nX0eF0eheC0HVXL8D9nkrVSnbYnj2xxuoFN3aqvIrEwpR+iNXvBavksI8XetYlxjV8wqqYJhSVhuKFfd+2xCa7eU+A9euECwy9TGlBCjYOBXS5ppaG4TUpXBUAUa2NPHsT8X0BurQQsWZIBnJ/DOOdnQUwiIyH6f0LyHPs7kI5VSLG5UiIl1EQBQPCVtvapdgVIE+WisrpFeGkfuF1nJVUj64qNd3WG8+KpF/QHh0kD7KzqS4IyMXwG5ng8h/Bvhlak+X5x1IDGXtjXvJQOk5T4wHQAPy/ygM+KV/RBVs+xvAFT/eW7m3wnPJ/0WGtK/D/HTvg8h5b+SFJjMcv84QU9NHJI2PUtEpuxZ4ezUqACiBvfHfjMLFlwqmtnem8zVZs+hKOaDWF8xRyqN3JyXnOz85BigVWW5RGFGlGTJyG/MTjwb6t5VbHyZoFAgP4afIok4EEeWRj2izgPvH45TrHLgIY8ltFNvez1++j/cEZRkh2KEqfmtzYNU3+79k28EpEoweEJ+/4a18siVGhSIiRTARloOjDvY9RgGPL4PZ682MtXa02pS9vnSwHT7t8DWtaUntjrsnlGtdnYmOgnNbCEdVQr1VPZomvax4xbB+CnH6RQS/26GHLa/MfgVVlEMh3G3Tm8uQja4cmX/uERxQLltjeWr0H7Ap3aqAESQQR+WdfNbtSwiQxENzFOTW+QPIvmg+qfCD+0KRv9OGveBgdPaDwHx1FuIg36HDj/s/qTyIA3MCGQ3cGAmrbaSFtUebfiPSD48gIMbCFyauduusx3q
 IiHTekYS
 moAFG7EQu1u5RQtxo3j2tLmNVGiHlzYLn7ovHxeC6Q7/TT9N1zojIRdqOo+QkP7fADm/HiUrpu6YKa3YD+6kpSV5MU29noYzjnCnaxPZ4b+hy0/0XwcRtgRaJ9Is/qFEaSTQwpblzvQmZkpX7H9PjDhIEa9k1Hf1qOc4p5mcjVh7zLkG9U1amakR4smhC+4f9T+zkO09gEa/G3ZX6QQP8fLQuKALHcCqqG5WVdNZxNsp8Rm/lK7SN9QGrayHQh64ATpoNkkDacGZyI46QjBSffpqFkl3Q/AH+XYqyagNHzO/XU62L7f9GBk0NdBF0UOI1BanSIMPrNhzmg3R+saVZNWCdlGlv5CWkTkYW5r+hz/zCZb1lFa6RaB3xxTavxTQeJv6yQJAMIhctpMDJ1Te5qzqjM+jPpDKcXqR0jaBroHlF2AgBnCdt2NvqAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Sat, 24 Oct 2026 14:21:54 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/kexec-v7.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b3593aba315322d875f295eef8b1a19e24658ba6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

