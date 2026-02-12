Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE831ECD6F7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 01:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E502B6B0005; Wed, 11 Feb 2026 20:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E319D6B0089; Wed, 11 Feb 2026 20:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E5B6B008A; Wed, 11 Feb 2026 20:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C58106B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:19:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72C218C24D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:19:50 +0000 (UTC)
X-FDA: 84434047740.16.87C36DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E093716000E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:19:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e1Eq9RLI;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770859188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBefCzpIOFs5UpjVDvr/kjTfriabiXn5rnXGXLZC16c=;
	b=kKJ5B/kCHJbI569abbSiyulRGGTCwkVYkdt74QtbZ9Af9+5eLdkp60U5mquLfwNNsl+0Fo
	Kqcc1k4oTCso+D9GpAo/eVJtFM0/WhfZi0xws3NJV9zJpmYLw3dB3ZFlvyE7l7Q4P/EPnl
	6sXMnYcFyuwJREwN84Iq6yCsb6vyD7g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e1Eq9RLI;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770859188; a=rsa-sha256;
	cv=none;
	b=g1Xm8OZspQPJWiZhPYGTnOyIqr0v3cvgNdJQAHliAN+99U58xS1op1UUbMtsn0KEWouaVy
	R14lL8/i4o5Gc5E0fo2OVuQHYHWJtGw8P/qknisEXU1J8SBL6XHQ0I9D1JrZws4DSx3fb7
	9ph9jGeJ7Qf6YMTHcQcVbvo2cyNY740=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36DB360051;
	Thu, 12 Feb 2026 01:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F045C4CEF7;
	Thu, 12 Feb 2026 01:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770859187;
	bh=CE0Ukx7I9S766e6wj0OwNacMGCL+IoK/RGgAuzl7dHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1Eq9RLIFP3tyml+ksOkj7IqiyH7MmI2lkJeeDo4EshUBYrMVYUl1cJr8/vMcU+RJ
	 S0mmcBuk6K8XZU2KHhfi/f6jEh8PwtKxV72iY9g6fi5RpQnR9OWg9liMYrLQu+Hydj
	 OTvnbAXV7VA32LBkaGTiF3CZTFxxSb5t4w3kEGSG9DOw8pqWuLtTk5jHGImGmAl22U
	 vASxwx5MduqSXuWJBb+adhc5NaplkNBZ1IZ097UL5iaJV4d40vBkdyP1HpH/SnxhhJ
	 nyif5PSh4zYc/q28CTbnDVWbB5aBh4Pam0ed7eOMJsIvx+iGxnXTo9YgXT3K60NVhe
	 tHyvEipd5WzIw==
From: SeongJae Park <sj@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Remove duplicate include of unistd.h
Date: Wed, 11 Feb 2026 17:19:45 -0800
Message-ID: <20260212011945.72787-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260211064311.2981726-1-nichen@iscas.ac.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 7n4wdr64h3t85jfotgu1mw8eidjw9qqj
X-Rspamd-Queue-Id: E093716000E
X-Rspam-User: 
X-HE-Tag: 1770859188-835587
X-HE-Meta: U2FsdGVkX18/CP8m59f41cFwpZ7YdEdy8pIgpSn02rDBN2PtaJmWt9P6Y2bWTPqetryk6F6ayKzdTb3tMHd9bQPVvEFY4Ubf6Jo1fCeFIdmmprqXhpMobwiuv+vFDZs4FS+gCI//mB0ihXxtSi2dv1Zm62faRmeNtv9Dd2+Fw3o5hzNAOmbalDM55j1M6+zp8XJDFIRJYwMzRTKvhXY96xCIg87xUt22rfH6U9R8ykKzaXXC7tSPWkCgaPfbLcjYQz1VqG/Vd0OyN/Jptm6HJmlJQPwS2gMA82RK1WyY+R5KrQiiiHyq8zDbZdx+V6UrG49vg+2f6QrHQsygjvfodofgbm1EnVdaBUCdqikcT5/oPWM1SQRIS+ACgT7RpyVs277rxCxBboKCekB5TzFI9cN0CDHgcpOXZdtcV4C2WNZtpnew3pAANpqzgVEM0tHZlhzD7QBJhn/lXDi5iK47diHMs4HFlC9YXO0w4F+tZY5ffNc1c6lAIvcdlp38Wuy1oALf0bhIvCDms57TDCOTig6U6/uMjP5JpadFIK/lx4DR1ZiAJZ+kj+ecO8p6R+aCAYulwGZaUSXQnX+SrBn3LFWo9VjZk8Zg6shFpKLdYiGIxOxdAINhF2wdDeUjSjDJg+AKoX8EMGEn0Hm0cB2DMNFOLoweFWXPvuelXUNLmxvoAVDV3fjBZwnHHPHsUruyzhw5fsCjm8H88B2+ure/2T5IeHlSprPXwGfUpe+uQDTIXfImzgv0ImvbzzdaFUADEgzf38fVQjON9QOgnmCk5nN/cCHY5Ghw0ziSWrW0oS4s6uD3FQnbFGlhB8BW2Ylx46sSy65hoEOr8y3OKvWUT2kH2Vtd154fEYID9RXMMoH3spwgcScYbtUI7oTMkdxJjC9pClnPcH6qNdPV4YzFk5D+WtQEjuCLRwL+nES0HSUL7nikPvRGM6WsiTuguQOxxh8PXmPMZDIJOvj+I0/
 h03brG4g
 OVlbXQS+gJw6yLa/D93Rg7bRLu3f7tCPFSLkKAyLqd29205ma1RYDElaKE2Ut27Ra3+VtzOYCFT4x/vhaR+0EXOBGtkrcwte2KGYU1wYYrr3Ywa+kB1GqnEhK6TH4rF/ze9SfaqTaAKugYx5Tj7iayzHqH936TF3QFtryM/CAA/fAK92ujRKtl81x80lCEx730qF5FDivooqaRp8dgsPj9uBfyzD2XZDQk3pOPnhKh/JzsEJbY1mNDT8zc/WjNuGoP/MB6iUWEuUxnaTZF3dJu2zb3r3CfSWevWbVvEOzifCBQkk7SI+YCtBgRxEIAaq5c3ezH8Ka8SXZgBFnLClbD9PuvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026 14:43:11 +0800 Chen Ni <nichen@iscas.ac.cn> wrote:

> Remove duplicate inclusion of unistd.h in memory-failure.c to clean up
> redundant code.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

