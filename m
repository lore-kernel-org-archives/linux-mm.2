Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB3B2CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 14:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2746B0005; Tue,  2 Jun 2026 10:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362736B0088; Tue,  2 Jun 2026 10:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278A56B008C; Tue,  2 Jun 2026 10:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17A936B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:28:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6CDB1204C2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:28:15 +0000 (UTC)
X-FDA: 84835202550.05.CAC5163
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3CD3980010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:28:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOkcjPza;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780410494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oo+68N6geBT8vGZcIMlRx+xhCMSwCViAAY2ZllIiYBI=;
	b=hiJMHGW7BMIlT6lKMKYeEWZMSrM6oto6tbzFfthsJbztGpnrGKoZ5r7qfxsyDEBYk6ZjeC
	lx310NS6HY1aRNEwswPUe3OE5auOaHKG7keQR1dmJdvD+BAR8E8I4WJ9Kk405H9HY77BcI
	HQ4zmilNmgrqTHPLSD8AKJRrnU/Xzjw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nOkcjPza;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780410494;
	b=zHndztICGOBsL16JJjOT3GRD0xZF0zqwG3k9J8x9BYw+gNN6hpqT9fJuGsEu9nFOfE4RAk
	2M0jNp6A73PJ5ig2Y3pnSpGifvG8AkCXMDQV4Ww0ASXLmkpw1AqORQxySDe96Gx65mgNsj
	937tMM+MOXTrOxGhYOGyBUkZTvF3dTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 283D7438DF;
	Tue,  2 Jun 2026 14:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641C41F00893;
	Tue,  2 Jun 2026 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780410493;
	bh=Oo+68N6geBT8vGZcIMlRx+xhCMSwCViAAY2ZllIiYBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOkcjPzaeHoRMbQCjzph8NC3yziwgLLzhsx4CYtwnG4nn+w5QEMVZmZVTi7nFTadA
	 fS3Rb1k6a1wEjUUdYYZP/16nvuiCyDwVIT7Y5C4VoRJhq4ZqwOGPQ5ayAJO5WzXFtj
	 FTm2WjTeWuarFPuAwTDmFubHWrqw2aEgM/rXOXVbvZV+3nG8kjw2sbQr3dAqoBpLgZ
	 ORaIsvVKeFHEYwo8gb4dPSxRmbjgruRtreulWf14eptXl4rwGF7Zin+cN7KRr20doS
	 XeMudyC0I4slg+Tnl0U6ryClQL4SIV4Y82UXg3GGpv+Etd7/I7JFec4AZSoFZPwZCI
	 PIR1x1wR/z2Gg==
From: SeongJae Park <sj@kernel.org>
To: Ruslan Valiyev <linuxoid@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] selftests/damon: test kdamond refresh_ms
Date: Tue,  2 Jun 2026 07:28:03 -0700
Message-ID: <20260602142804.102210-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602131217.2210912-1-linuxoid@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: fnszsdsam3x1ar9t1gr9oaw4syi39qbq
X-Rspamd-Queue-Id: 3CD3980010
X-HE-Tag: 1780410494-641431
X-HE-Meta: U2FsdGVkX18fNX1cSug0zjzHowVyG+T0OAbRCSA+RHm5+RcMWDxDm+F0z0LcwsTwF2Aa4D2KzAfg8Khw/HPnIr+1fg7lvyWYx72An6MOYJQEci/5Y2FEktpiGt5UY9v3bRrBSLhpYrEVzU0kkZ1tubTfWI392rku8fMcpfnylRFjBSVr1uFgzXZV85WPPRYIKwdaLclCA0YzOJPfWE3kANN+hEyfdOU1xeE/vgDE/Jk8X8nb9cI4lv+EhVNqTMH4y0mY3fWqUiAkeJQBvmzUddLEIfmuYToYjUI7+KGz32bYpFjUjVi3Dkpf43FPZNil2uAs+8g2viQOSUt5CeM3s1URI/8bP7ycAvp5LKqhgf/nxWaD7EYbXxd03wTnKwlxc847c/NVl2Ui34BqRMVthOcFnHoyjeO4OavVDh/0dsoYW1E65dGG2Y8pDGUb0jiwzFyqtelwokMzgBcH0jWLv64SdXKXqVK6wLVMI0z5+IJWIA06pfT0iOAKmN8ND902n5EVCBMS8srljgvlK0vLo02g69Nl+UVw7z5yqFMu4FXuLLVKMexfZ9QAY8BYWZ0p8/JUxslXhfSwniyFAUalMGL115OXsR5aDZ0cDasBvNzXREF1cbkkaiTeTuz1IkZAKqFlrQE7XqzF7mgAzDrV51JB8/38q9cA4BXP2e31+G+rGhq8jofYkU0bZPFDJNidxJovYc4031BoqtscavW73FdDkQEI/937SGwHMwENG4ssNf0tfvNwT2BzWcJ6C8wXkh6aLqXL9eCY0HOw6GNWfwufE+NJdygxRxhh1+/KI/dm1+5g3CIHOb3mMwXT9TliPvIECXJAQEQbT15xD1xtUigjQdi7LBvlpWgRSt+hCQOdmwTX6EDXyYJEjOE55MUnwAxj/w0TrlRRZw+Q9+XI/mfKK8caIe4eBJZTCD96POHDQLyksKLby4xdbqWz5sBsDPpbr2GO+tLwnyA3Ihd
 y5fGsDKL
 qA2xXFKed9AX9aTjAVqzXggX4IOU0bQjStOtblQ1vPXfgR1H+kLtcLbroJlZ7YSaF88RBDI4FePWoTEhZu1PVRStCA5RmHztXyTxQeS3J18llguRqNDrKAw1dPV9YG/gODuLXtNB0WRSZowsK0+gqt85KTM1QxDavnR5wJi6w+qQy11jUIDRUUekLhE9NvLLYQKqRvwrTzn04pr0nJwE8eVYpIjMNXnWfQAgT8DXkASKvpiYv0vf7BJg+sR+Yfx+/cv7wpV8BHZUyyMfLUMMDDycpC5w5T5+wTPcziJqF3GSokeeye2+wp5UADNhbED5VYmjWGTxij8jr7AI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Jun 2026 15:12:15 +0200 Ruslan Valiyev <linuxoid@gmail.com> wrote:

> The kdamond 'refresh_ms' sysfs file makes DAMON periodically update its
> read-only sysfs files (DAMOS stats, tuned monitoring intervals and the
> kdamond pid) on its own, so users don't have to write update keywords
> such as 'update_schemes_stats' to the 'state' file.  It has no selftest
> coverage.
> 
> The first patch adds refresh_ms support to the _damon_sysfs.py test
> control module.  The second adds a test that sets refresh_ms and confirms
> a scheme's stats are updated under sysfs without an explicit update
> request; the test skips on kernels that predate the refresh_ms file.
> 
> Tested on current mainline under a DAMON-enabled kernel: the new test
> passes and the existing DAMON selftests show no new failures.

Thank you for this great contribution, Ruslan! :)

All patches look good.  I therefore added this sereis to damon/next [1] tree.
If this series is not added to mm.git in short term (~1 week?), I will ask
mm.git maintainer (Andrew Morton) to pick this.

Andrew might want us to wait until next rc1 release, though, as
apparently now we want to keep more time on stabilizing mm.git for the next
merge window.  Andrew, please let me know if so.

So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

