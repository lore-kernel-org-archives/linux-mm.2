Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BA6CD4F50
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2075C8E0005; Thu, 13 Nov 2025 03:27:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF648E0003; Thu, 13 Nov 2025 03:27:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F51B8E0005; Thu, 13 Nov 2025 03:27:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0CF78E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:27:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A91E64D3E1
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:27:14 +0000 (UTC)
X-FDA: 84104903988.06.0E05886
Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	by imf10.hostedemail.com (Postfix) with ESMTP id E2BF8C000E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:27:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="v9AoO4/x";
	spf=pass (imf10.hostedemail.com: domain of ywen.chen@foxmail.com designates 203.205.221.235 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763022432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVF40JvW0rvtlK/7YsGxBBkoai1eJAeOfCxgFSzmMNs=;
	b=Mj4GWgQ/hp7NH91p0WCm4xBf4wNtAFVobZdpO9+DCOk62ZB5WTIuWj8ewcCrNynmV/5Lih
	hwkzZ/2FZvZ7OKeKWqtnyOFV/AJXXZIgK2KCxjgABBYFNHL+uI21+ntFr+NNOOd9nnAz3r
	IUiygcV0Je9zxqDUQ3AFUqpPdCd8tXs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763022432; a=rsa-sha256;
	cv=none;
	b=7EofRYLUJbe3M38jXxK4/dZ5i92vzqTsrwtxLbs3AFZtfK1iAI/BPOoZAJkx3DCjT5F4bl
	wynY0IZwfvYUXA4FVv5LkwKtueFxMS871NFwyICddeEk7rSra1I4/LA+veQIArd0SkHt5c
	FPy45hk8Gs8xomOzd6BjpZmeGC945T8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="v9AoO4/x";
	spf=pass (imf10.hostedemail.com: domain of ywen.chen@foxmail.com designates 203.205.221.235 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763022428;
	bh=AVF40JvW0rvtlK/7YsGxBBkoai1eJAeOfCxgFSzmMNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9AoO4/xhdatZfIAkcpeqA/C2uwgWepWQ4qgXPvSr35mXwv5nFEed+zaue0uHrr3+
	 DAckeEzFlBbnRrjSLNHgALe1z6aaX7vJ3GQekJzYsS3M7cfRO+rtWacjhNaEO5IfRF
	 VyPoK2fzb8lR/FAFwTO5D9822ABvID+ZIQ9Y9Jm0=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrszb20-1.qq.com (NewEsmtp) with SMTP
	id 6C5226F4; Thu, 13 Nov 2025 16:27:05 +0800
X-QQ-mid: xmsmtpt1763022425tw34gw48d
Message-ID: <tencent_49B963DEC2577A5762510FF7CF38ADEBF306@qq.com>
X-QQ-XMAILINFO: ON4JYNczNu10K3dFLsf5HglgDmwpEuP5H8XoKG04IMwTQ8yCPpA2mifQWPpYrz
	 o5qgq+eBwXEoSWwWT+yqgrKyYduVhCxX026WfrfLSzist5VcexfZAmplvA/rMWzw/ed4v86o0FVt
	 BIskcAFTKuWZTnvpQTmvPrwsKtcKXSyZOvUcyujZ4CBbQHl0qLfLL2KpA4mx0ILjg7W0b13BZldy
	 aE+7lX98uC7ukkgCGpMMmZoIXxsby/NNoqbskgPcYqHtzUEvDjRMN9LEZL13HZ99a828C+CJL6jw
	 CuR/wjGznU1hlnVpQWA8Z81jHH8VKR6hNNHzQEQi0kghVnIHaTRtpt2tyZZTfJFtM65F8TNT9WqZ
	 tEeq+3G5YjMfY+Tz068PsOh2eCSeUXue2WN6aGB9LpUTktA+odXphwQW47DCOGGT+QsUdklX/n7c
	 F11pIEvY9ZSgPJFR1pAfMzn2YokID++F6k3mowS9xH75TVuvES7Oi+WMlM/ArB4GUHpPhRe21qUb
	 8IVEtcYTBbXGmgsVGoIF4MTbyVvWI3bwnHv/463GOPwqnL+fFo7c6JM5XFg01Kp2iBoGjqm28zot
	 hpxPH6s8hu4IADxAXiGS4Z8I5yujdmOxoBXJV6LEc0t5WNI7N4gYGc9FW+WKs91X3tdhzRxt3ILN
	 HqvG/AP+OSAK7qdeMA7g8p6TdePYbaB26Kdzu739HK3uzaSWG6L2SzEHINyX9+trG8IvQoeuTITx
	 MrypEPn35jsS+jLUhE9StSv2l571etihy/onHzQAv7Uz7S9ScMITFezsmcGlpwmyfXlOQDxC3O7L
	 nDpOW/FV1bqNHNXmItvHR/iyVN8U68lFFdiYxjlwYfpd23LwkKFuVsbPjrN7w7JLGnL84FEGHywd
	 5TDcBxXrQDgJcxjcyYCFOtRlVouNLW6XVdA73uQem/6d13C9/WJ0i5CPQ95MEsOlX3/nHMpc8Df6
	 VMYAoz2/aKv3rkvJnMk0Kw5AJ7uR5qsvM3i/GeAhIVRZwIIBve1zpmHSbkKt3Vg+xQtUx2AcaPUA
	 oo8F8Bl/Znq5G0v3oS0xls21QS7OufUdGDN207iO6p6/UfGuE/K7Tyz9NiXL8SJGpyp+uzbw==
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liumartin@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Date: Thu, 13 Nov 2025 16:27:05 +0800
X-OQ-MSGID: <20251113082705.3325765-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <kyprvtaorfdq3a6fsddaww4jg6ixv253rfonrdv2snyhq4pkuh@zdei5bgqzd3o>
References: <kyprvtaorfdq3a6fsddaww4jg6ixv253rfonrdv2snyhq4pkuh@zdei5bgqzd3o>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rkccg7j9k1pfc5ybuqne16xxmhda33uw
X-Rspam-User: 
X-Rspamd-Queue-Id: E2BF8C000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1763022431-343084
X-HE-Meta: U2FsdGVkX1+e40mUanAZWI3fZJwrJyr6TyNul1QxqT4w/DTcqM/apghGqWF8QyShrVRFWNZJkR2oXOAIBq9ifEZTLoLZJcu4VXImce6KmdXoVZa7SYlWdTpmBSL4v1JeXau7nWUVTQVFJcqJY0xY3vAU86zPNHdr0aUl/AOreCXRuQ7YuktGxxJxFZleCBL4RmSOW+wY/d6uayNJ494qTokxsMTM/UIpnsrDtddcnewCZ7nG0JhK+NcDA5iJeVWVJOa203hbDFCnb3ULxmhzSRP1N5BhYjmJf1Jqvsk0/UtbWo6+xEc21s4HC+x3SdxMb5zJXaPsreQ5UIxyIeMEggMtLg1sMcMxcjHJG8pu8uAdPfBSsCbiOwg+uSIkn+m+iAn2i/QiXnQ2PArxctiATxbfiPBaYakev2BeoL+EhDH9qLteFVR2I7p16+dlyBvFdzSN3ALwuYKMLFpifB9lfZ7uBcsM+mYY0XfOHjPaYF6b/u5trJEt+mAz3Ph/+9yI14bA2OIkyL2OWpbmUVw7+uJWzfmsobtWLS2ymD4e+pZcDSae7+abd5KLMRjRUyX0wfES1fJEOcARmvOJebVR7TOcUP6dJKvEufDEq9CKtKokP7MuVWfoefysaSleucBfQNOxfT18zBeGHFv28QRnrJC6LWmJOJdSXMpQw3nPec7dpK52a6PXo0T+/jXtAVU3BFEBm2uwAPLKBL6/qF+zOg9wPVsU6dn7ghxAtojhZYT95xpRY4I2LM8uhEU2oGE+TFrUXRANqpXwiZfaTMdv9WI2JbndUThzxhzc5ktMADFcSr/Dkc6VBaVhmjx45G+aUwKjox+GealtDRAAUhOx0zBbApewqVyC1TuCLv/4ASy2edoigxeSy9v5LOEDR+XvbqSWOL2BNw5XbZW7DoTaR7NQ56rxxjsnGkMa25RZjYirCNHS0vyYEHciItQ56epaXML9WUVP8Dp0kRPWWoS
 /nKFdmXO
 EwqCNAnJWmbDPqhAvl1A1nSbEAGDuNEHWC/v2s5jvdj36HDXRiABn3IKgNTBOXkr3We2yNpzT6wurNONeH8CB6x7ZWnPF4kf5h7LySqF+y/1xrPk8WCgw2qNkhTZfZPgt2skRVJGCCXT9TrELXa0YbMuWokAow2PptjTtQyAp/DZJ3DpY7LxCYw79K9DtIq5IMWpFfSI5lkKvdkMWDFGCnm9e9vAyuBjepugSny/YTDSK7duP86kbXNtTBZF4zz/aVkmm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/12 21:40), Minchan Kim wrote:

> My preference is [1], which is very close to how current post-processing
> is implemented in zram, w/o complexity that dedicated kthread handling
> introduces and so on.

> [1] https://lore.kernel.org/linux-mm/45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org

Yes, I also agree with this. Introducing threads in writeback will increase
the complexity.


