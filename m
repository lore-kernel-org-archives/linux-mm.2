Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C177ACA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E6F6B00EC; Thu, 21 Aug 2025 13:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10FBB6B00ED; Thu, 21 Aug 2025 13:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0254A6B00EE; Thu, 21 Aug 2025 13:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E25B56B00EC
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:24:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F88E1DD57F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:24:02 +0000 (UTC)
X-FDA: 83801437524.14.8B17786
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0F425120006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:24:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ufdCprLZ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755797041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbIw01xhbtDYHFhyU27QmmwqjnZV7mfRatfP6A89V7A=;
	b=bwkD1KXI5zzTLmXwv+TJONA1h1tSBd3iS+3fknmT4wRPAWQYVt/bxygAXyRxYXtYgBNe75
	gF3VhgMQXyWmT/b43ODq9IMdCGOEsMCQqDOa+U8mAjmPBIHKhnUrzdWvCnXk1djlAvyzx+
	SjCUESSwbQWbUXSV4iknHqqzC9iQP7M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ufdCprLZ;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755797041; a=rsa-sha256;
	cv=none;
	b=4HP4jF0Ovy2+eG/4wBy48wN9/v0HzrWme8CmTW01OKUAacLNyQ64scbjAyBOjkzoIz1E5C
	zWhAHAAuhc20icb6REDXIHyO9nXIVcaIhp437sSSTcRiTiPt1NCfSPPQ0hFMUSMx5roBD4
	4yzMixPGjGDcJ0wP4wnRuTGNba2cXL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 4F6575C546C;
	Thu, 21 Aug 2025 17:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB20FC4CEEB;
	Thu, 21 Aug 2025 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755797040;
	bh=N3/u8FVbXeMN+Ztt1yO2E2iROrvfabqVIFGfFt13g5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufdCprLZOANSimLEJibjKHExpwhTdbfMQbiiAhkAbxW2wycu8FEba6N/aRbqZlEEj
	 8fSZhFLUGpSOk+jU6NP2VCSGeH9qnRx2+lFdSi4eSnJl0pUyY8SXVCDlkIQhUXnPdX
	 tQ03H+eShqW/Ix4LzVZt7iTHWTdIrbSvmB1pej6b+5FMaGEPPxSD6GPGoner5BQRJU
	 z9orWOvkwuBxFeA4+BNSwDcM8LhBieBHLlcBcSF7j/CE/BwcUmIVOkuDuxNqwbToru
	 n4nIpZU9i/BK4qDZpA2pbT1KXMymrmpVRpM/HbKwrOZbDwIqy1y3P9GhXM6LPR/Uzy
	 iWWXDk7VpUonQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 09/11] Docs/admin-guide/mm/damon/usage: document addr_unit file
Date: Thu, 21 Aug 2025 10:23:58 -0700
Message-Id: <20250821172358.82360-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-10-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F425120006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: pwhuyqa7be3irdx9gwc57zyazkay44nk
X-HE-Tag: 1755797040-799946
X-HE-Meta: U2FsdGVkX1+O5+WcDiYeP6KgDYvm9J7P3Kh6rNiFL6v6xPuwO10pQDf8K5G+IWDWDg07X+6FI3QEFgbnhDqLLIpX+Ry8+rChr3vL2q9NFohuPHaLdtG23Y9+1nmmxWXNivEwJwUBMqllNjcq+ciHh1un93UQHS+7hhey2EW93FNw+SMIzmLVw1CGE/bB4tGNmFWR7NhNvr/5EQ2P8Bpe5pX/Obm9Qg9GLQk4OpABj436GFXAk40qNLQ1cCjYzd5DDMgW4F6z8qYTwZjioND5DwVKK+wqKN7RDhyFhE2WzG7KPbB6Rl2FpGBNFy2erv+uebK/ZLs2kk4jGQCuXWX/xxiAX9A7jfHAf3agKx5piTMhAXzVHZFHGRbJ9AotkOrp1utgsrCPnj0sATiUnWtahLbxhnGc9LBgmWwAnlwcx9x12CBGMi/NqkxX6fLhE8d0bxqzkFj0r+ZJBymoYzhiGiLsu1IKqI3nIgFN9dzomxhUjcRxG85aUhq5XLzmNS60lWsrKm3ouudwL1S81P9YC+BMn9KW2ww/POqAoE+GIDagEU80wdTtpBjpquJpV9sG02ziefB4mV3ebf6NXMV9sLjsg/uIXeZcL2NgFeA+0aHk8RVLc1rEnPcvCUDKgGfgRL4QIxIgNjkznuw4F3t9mjyM1ABqdeqVX2CSBcN7A4wGJKcsv+EPawRbmLDEAPNkq/Z1RHztIUTHnXEbsBMWrfnqIvthGagCQY8ZkEwncpfYIgwMBIq+vWCHcHStY0ToMEmREh/A3mvRWMmosR/quX7PjM6wo9nu1QvuAJjDBXL28TVEVczVcozMA7JMsYQPQ7NKxJvTQoC8uuDXOcZZSNSieX7Avt6yyeOF+FROzseQW+F+99Z8GMf0ap5WapVmj7INXR0Enp9YK4XsmWYGp3Y9WuyZs+YKik5y+ZAPR0HnIifcOXprmu8oXPOpeKitdz7eMxEWTgmDRpqCyGK
 lnSdmFJO
 QP45J8HsdmhjDw6m8KFCeGRVgtM0P1IV+5o4U14NDC6A7iao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:57 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Document addr_unit DAMON sysfs file on DAMON usage document.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

