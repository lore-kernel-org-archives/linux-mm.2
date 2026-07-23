Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E09C4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8FA6B007B; Wed, 22 Jul 2026 23:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143336B0088; Wed, 22 Jul 2026 23:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030B56B008A; Wed, 22 Jul 2026 23:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9DA76B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:45:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37336140385
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:45:20 +0000 (UTC)
X-FDA: 85018651200.28.611EB6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9101BA0003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:45:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kA4N1gHb;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784778318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=762g8kYBk7lElwigO/Zsr8G9z8HnpHqNCurBk1LuKrE=;
	b=cahGAnjhAwdv5wKwPH/YcSZStp5+BgakaUfNhEs0mWOR6tSgjODZeGDvKgRbBbbZp0z6/Y
	BubZ2cKGXyV42tO2xdbRj+x5XqDcscNE3+QBqCJdHO/D5zKW8iZ7YvfMNzATA5H/8uD6si
	6mCrgYevyXSCwSjrMNyGz+fZsqGEPVc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kA4N1gHb;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784778318;
	b=LE4FWr5Me0ExN9X+/8HZBSRVlVGEenuP60Sg9rhfE5dHycvG86ZVQjj/AUXba4/PJPTPxA
	mP9/f2/k0yfmr7OacbfhYMRJx0WX03dRZePdQFuLILKB6TZ0msCgUtByeI5XXAs1H76Ifj
	Cui11yDSjC/vy80pe3Qko7lwL0pKmmw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AA2643979;
	Thu, 23 Jul 2026 03:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173DF1F000E9;
	Thu, 23 Jul 2026 03:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784778317;
	bh=762g8kYBk7lElwigO/Zsr8G9z8HnpHqNCurBk1LuKrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kA4N1gHb3nJw/caFpk+zcO5zBuVRkiwLvH3IZoY/LzrxvYHLB2xd4AoCSsMJKFb1+
	 4pYFxIkozgxBzPHNcBgVh/R0WVsJA48HvhrC6lb10OrV6eNluL8eexI2VL3VaR5Q62
	 XPE38DSIRUbmxpzFH+Eu2hYcB1Xq3jIspibyUH81JZjh/lqNUncn/qWo+2Yv3CJvEz
	 gDxmCOAuNsOt/Bdh6KsLD+jeYMXWpXXs5NlRkIIwWW25vI4UM9fZfgG/8nNf1BI2Ze
	 bB7IcRBHAOSXfOZmPpwPgHRBoIOgQwhKLBbQeP5UPTaZxPjizvwhSvyFWiSKEc7rku
	 JiVIbxaNJNEjw==
From: Kees Cook <kees@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andi Kleen <andi@firstfloor.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] x86/elf: Correct comment for STACK_RND_MASK()
Date: Wed, 22 Jul 2026 20:45:04 -0700
Message-Id: <178477830120.3132185.17815722457437200154.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260722-fix-x86-comment-v1-1-605080af988d@kernel.org>
References: <20260722-fix-x86-comment-v1-1-605080af988d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9101BA0003
X-Rspamd-Server: rspam01
X-Stat-Signature: ddygpf193p6k7tibmeq6r6bc91emz9wh
X-HE-Tag: 1784778318-991203
X-HE-Meta: U2FsdGVkX19cpcj9iQDk0h2ZFWAtYq6HPdh/GOwZnGfde5Z+gTvhFjkTR6xr/bvMkC6VYOeF9xF/GEEjgsGDyiUQd84aUbzpvSVKqw8YOeMk/FosYQLqaNEhwHDAwGiWt76MkTI2RUU1g3ZkzSjXkq6HvNCQ23gmy+1Bzz0/H3rc84PKzDGCZSR8KN8ye+CqXk5vCQD1Eu5qWr1qOfyoQPhTHXwnm+AlCVrc8UpG97JAHavjf+U42ao/91aGGAtLHg4Tto2WtSTLR4VvKqmalcNHVmYslAtlJvVcY4q0Kqg2VJQwoc5wtBNNjxkPGro3OoOTX4mzXO6PWaHRkTMCOllGqWi6McVdVaTVQGu9NCeAyuUfmTY63/y3/E2sDRBzqcZrfHkn0OLA1tvSsEHv5Un1VyR/Hd/zqYv0kWbwbBed6bAHo+VDRZ7JaUIACEC032f+oeo7DE6LyNaDgocpRIkuRS07ITtZMrN4ii2X9UdVZexvx0T0+LQYgV4yl0iw19s030hbZ01AAEs53GPGCtNzOw/QAKJp9q3+J3y5l70NiYg2mjkPL5p0FCxrkbcE83rClb1NaCL0Y0DkyVW8i/hATO4spR3mb3keu2XhQMUsaD4lcbb+UiKuLUvn5sl3QIdlnZDgl/eZqjcwJ0ufgpur1RaocQb9vPkzgXBFItr+gZi3BOcXXqrlmnvs6iUYMotj7xDNs+Nt5tv16YHmgpTxVNfCwepVrzPk5loiY7sQLUYsM/jQNRVW2eijueD8oVDNTynOPFGSYW03EDnVCEg4WK1eMD5imY0BN2uldWRrZIN8jQ/Mgw0dWYB6E/LfHRcj3om2eUlly0VypLd4TNTAH1PfCZ8oUl3ct0gVizjrxb26ckOPBhzpibgDWBeXigcACPtloWuT6tn1U2e+HRVc3S4FkUO0Y1sbo8wZ1jAfFKsWBB39pggEWwdHAWHW5SZqnlE4NuIlrUupHkY
 UH1hZ63x
 FfFlxnqOFQG7FJdk7FhY7yNr7tFG0kWEIxOhEpQVq4mqCDM0DAv/xkNrf+rHXBr3QBL7YFFkX+1QCc9A7FSy4TdE3+DwsSJcutxsj2rZCtvEJKninbyN9y6h7NpAS4rfzJXY96FsztEMluBwqlH+w7mpsvX037o53wubFD5MX+hTlVZNdR5vQtKAanZUqfSZLe0MFH4l96FuO83MNZk9Dy+3HWIN4AjgqAAkDreCdAQjs3MX4b7QI29Rcu3fVaWP0wLO7Cqscvv5mCXiUTQvRww60g4aEeDs/1HZ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 19:44:43 +0100, Lorenzo Stoakes (ARM) wrote:
> Commit 913bd9060195 ("[PATCH] x86_64: Increase the variability of the
> process stack on 64bit architectures"), merged in 2006, increased stack
> randomisation from 8 MiB to an ostensible 1 GiB for 64-bit systems.
> 
> However the commit actually introduced a mask of 0x3fffff * 4 KiB pages
> which provides 16 GiB of randomisation, not 1 GiB.
> 
> [...]

Applied to for-next/execve, thanks!

[1/1] x86/elf: Correct comment for STACK_RND_MASK()
      https://git.kernel.org/kees/c/ab11176bd3a7

Take care,

-- 
Kees Cook


