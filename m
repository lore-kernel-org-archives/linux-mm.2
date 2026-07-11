Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F430C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 00:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235796B0096; Fri, 10 Jul 2026 20:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E61E6B009B; Fri, 10 Jul 2026 20:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5386B009D; Fri, 10 Jul 2026 20:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCA146B0096
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:11:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E1188FE5C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:11:48 +0000 (UTC)
X-FDA: 84974567496.15.B28C286
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E0BD71C0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:11:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzhPKIOz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783728706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyhyGqRQKroxfW64L6xRU5J7B1yOFnOg9sGO4fxh29w=;
	b=rZj+HedNV7cqlE2p+ZjYHNOrIvGpr2vQQFGyRduyvFFQjUR2C0pF3bbJV7fEn54csf9hE/
	vZ6/GNJz8Hn+ZU3HlAWtx9KfaqSRTc1vIgpwg3v5Tx9sV7CIlg1nCichX8XpEim+USXA7i
	7taJCCRfZJmFPl8ff9b1IYtavDJP8nY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzhPKIOz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783728706;
	b=wyOzT3h+y4p5AFxHwqdUo4OVB5EkkNlmVFSQhti7oZ4Vt/lAp4sJmGJMlm0ccrXvX0+qaF
	HcN4JV5ScDs9BzlM5FPc7cV/sx4Cs02Gndd9y6HJrbjYtll5pHyuTjtkqq75xH6VR0qCtJ
	A2tbBDDIj4nvDrqmLtMUici5Rj8+RRY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42DAD60051;
	Sat, 11 Jul 2026 00:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAD91F000E9;
	Sat, 11 Jul 2026 00:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783728705;
	bh=GyhyGqRQKroxfW64L6xRU5J7B1yOFnOg9sGO4fxh29w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzhPKIOz1/a5ZgRJtwQJsSVMipKqRsxh4xC1SafTDqvlf9fYPhaRnD06UzykQwSmX
	 drMaevmaL/tyy5aP0YNVEb9iN+0zBuTr7yb9tKCaPKLsbw5K24Uz9m9N0FefCz8mX3
	 ka+1TM+AVAGCn0E0mHWuHigsuO6qPCocrN58Cdl8lsehK15UwEP32JmCLhdZZFkL3o
	 QIgo9+NgIbFO4HmGWWGi0y2dh8ZMvV+zcwUL8TVS3+yIkK+p1b4vPl7ExauR9g444Y
	 xOgMzG+ChBvEg80rzrcQcrzVyTwiv7tLHMDQfdtnlUDg3XtEG3EM3+Ai4uVVHDD6j5
	 DaMhRZLa6zrMA==
From: SJ Park <sj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: SJ Park <sj@kernel.org>,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove wb_writeout_inc
Date: Fri, 10 Jul 2026 17:11:38 -0700
Message-ID: <20260711001138.30784-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710051052.1839523-1-hch@lst.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0BD71C0005
X-Stat-Signature: dd3da9wmp4fjwfa1jqdatqyuc9dn1u9s
X-Rspam-User: 
X-HE-Tag: 1783728706-489426
X-HE-Meta: U2FsdGVkX19AVODRp43XqgPHUyVnljjJDNDrfZOM7AVzEAJXAY4LMZSj+WUH58D2zcZDmWwVANypoNZ65pIE+Ws+5osquGZTdh02aKHhosvViFyHJ4tDFrgB/BcXZmYC8XV4VT1hbQSOYzdZTMjZXZ3f2L1wZYYPSCbt2cb4UU1ZYkfMXZw8tcCl0CszrLoNfNPMI6YFxqR9zO85iAoN6lHnyCindacTjy6o0nI/Hqn8GNu+K8lImCxbT/XZCmluUYQWaykK9sbkOLyKTbzLDGA9GS2rQ139Pv89GLWIbilbEuRfEw3/p+K0fxjKqnMn0z7ylD11CQVv01l6s4+fS+klFxPnFccnYufek6v47yvsL5reDgxnCIaIo1+r5Qxr1+UH4LvraJJDWNXTlGSZaMO5PFCwH8dj2S8EsIZstm0HCdAQMVmyS98RMjRTegP24A97TH5GupCcZT7EM0dXrW/WJRo5WJlVU3Ct40ZQqi5JUdomGAAsstLJdEYe8FK/mObTTNgQBWJmXJ+nOXv3bHwmdfwXSXqVg11p0E4Qpk52XpMYM606S347F2XZbmrvuyAUAgNXyAvDMxmtyYKw1NW+PQ9OcyobkDms6IcXiZ9pwzQcYtPhMRHn3HeAVoxv/gobOIKWHSlLSE1iS3iF9gLsT6qyum5t9X9+G9juOqzF120pXyh+IF7VcppWvDInM5WmcwBpEOAtIvnLEeAoIjm4OAhPypL6Nf52HAyZ9bC0dE22xbfOG7TCIwkT5XIzmdmNof6FoqG0ryH/++S/YwkfDPUY0UBbpjL9XL2VfXNUygyvyqxMHzX8PY/CvZh388Q+Lx7hLmwJBSLrkbTPlo1/s2aaiwIGU3MOeMpTapMFKgX9KLroL5LhtsxSRF1k2Cl2ww7xxR77pzcLUuII6nAdKJ2si/+wmCi/Dzfb6Xst3LuiEzfa1mPA6VXEOS29K2zkcQQ2B66EdiLUhCE
 99ytQZve
 LVdkOgYU1ZDup0mSgcXxCQId92x0FNQot1U1DtQPq1exF+ENDDyz2r0gvWMtiHnlB+FkZRzLdRLoGXcdl5uqbUyfRui7Y/14cJYvC7OwU7ts9vEmt5bwko009mBg2FmBZHgnbUvqJiNQv/yQH9rp6EQji9gTxpX17dsJDUAkT2t2h0oJLt9H9x+8yFqcB8nlbxmRCwSHADU1MLx0Gv83aKgJ1mSO/rTtpI5dTu7qVh+8QbVg8MhPsFGnnLuQo4DazMGtWIX/xMsKVUoE4Uiv8Jk426Atcir4zsAFRn0i1NMU/MWw0ohAHyEaNidQOUPmd+2PlHbma1acCyZQ1apqhKoBt5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 07:10:52 +0200 Christoph Hellwig <hch@lst.de> wrote:

> Remove this entirely unused but exported function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

