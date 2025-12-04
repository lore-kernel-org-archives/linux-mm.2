Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FED0D1D89A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0916B0022; Thu,  4 Dec 2025 10:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579866B0026; Thu,  4 Dec 2025 10:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6016B002B; Thu,  4 Dec 2025 10:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 395396B0022
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:01:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF8E4131F85
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:01:58 +0000 (UTC)
X-FDA: 84182103516.07.A6D95B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3A39640009
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:01:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JugDzLsA;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764860517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDbrizOm+VCKIeJYnsuP/TAmfDQOUR16ObMvXOa5v1o=;
	b=a21W04qje/FzmLylrWjww7TKCBTmM3OUTkGh9O6WUS4XBNOeqiV3ha3PqlQfZZ0D5MC7+Z
	PVLc5RdgVoaYp/UB9D4UGsXRwg4MVQe1KZz2/DpXuDUZLuhVMdfGp2iSH++x+bRWrG9IE8
	NywS+723jO6lGIc6PHu6gPZxlUWygvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764860517; a=rsa-sha256;
	cv=none;
	b=61tUTD4kLuiRZsCrJflpqWsiLkAXH1wQMNvL7uzgn8QC0D8JWxWwR6YvaKSx9SjvqIQ3xP
	aDq8qPHIkmMcBC1oZHU4bIDUaTFA70YTTmbgKNmKO5EWludJC1bZOx15PY8lFmCbUBAkda
	vnOC+4RR9h/WjqOx/BNVaPHnI2sWe88=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JugDzLsA;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3B4643F05;
	Thu,  4 Dec 2025 15:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F2BC4CEFB;
	Thu,  4 Dec 2025 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764860515;
	bh=pR2jWjpjbwh4nwMGO8dc0JFboTlxP3WCMbfFWA/9guQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JugDzLsAwewUuWm3RGfQrZU8thoOaR36Rclgz6nb5R1ak0sG6BBGpUJ5bx2X7JKc5
	 slbsVm2TAbf5qd9yifylxOoIS6NVdzgclPhu661zbciYKVNb/PomDtNEefoRE1Bt8s
	 sPevnXvV258BpJwwvlt6MSRFQPlJIOA2wqStB8TAUQskOJH9s5zTDsiAszajhY0840
	 BlZjbynt2Cu5vvMwemEMnbi3Hv4kGId99C/6EboJU9e47hfGI7bkbkpgq+LwK6ISgH
	 9aA2MkwnTFn5ZKasx9YB9PaZO5GZdHNBG4ja0eME+zfat/3FWHFQ1H3ls5/0MK9va9
	 YQfX5PYSoRAhw==
From: SeongJae Park <sj@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/tests/core-kunit: avoid damos_test_commit stack warning
Date: Thu,  4 Dec 2025 07:01:50 -0800
Message-ID: <20251204150151.83380-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251204100403.1034980-1-arnd@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A39640009
X-Stat-Signature: j8gt6a5az7othz863nmkdbqs9tikduft
X-HE-Tag: 1764860517-363257
X-HE-Meta: U2FsdGVkX18PlgKwZF4gv1KnQCkh7wrnTKnwGFu9y/6mG3BfFzeckFBFl/IEcuaPAvI25lUaFH2IT8xB6OfpO3IkUKjXNFsZp2RYMkwpBl2CqZzymtNdagU0HPKE0N8F7iKu1NUIJOKNZZ9B08BB/ysln2hAEg4PmI+GoJUo5ZZXnqwg8D2TZhii6vItfffX0jp2n2jZ62K6jwgXaXVAcUU1A1rizCjhe9OcFBcbXLptWJ9Zh2885YSP6Ac1V1AwVjbcMfQ5SBC7svuRg7kQdzXBl9G39X0SZpsMRIVaGPOSgPwsj9cUcvBygkXvcutSnTgvsMBhOLmIB6nNxZMdi8oH5gMcVWrDWsUPH6kuCt20QF1xhsO8cJpwVfYVkejjkSI3ccmZK6QLo3PUtcjdyQpEc3znTG/yJ5TcIPC3vncCu5n3WPQTok0pQVGCFEgP3QeygAz61IiGTdqSJlp0SZm216v6upQCVf0VQrgdpoGFqaNbLhEki/5YbpCNBGfU68nLZAqAEHHcG7qzID9M3lHSlnn7nvr4s6WGfndfhq7YLTYEGT3Y/mgPqjI0rtbQvqUpPCzffidasnQigIzaLy30WtQjcgG2ifc3K7ZDmIl1Rnelq81JMZu/tnLKgMEa9wyK3/zhkG2yhKxDC1x/myDMuzKnm0jpCyAZnSngaSK64mH4LBfh/P+Qgk/EdLQtoOUsFuSH2UIsbb30lOE063Yck8w5Y7VF+PjcXwFUFFOKQG5Hd1+/9Htm8P5PnkxpL4VWW039VSYCLvq/dF7jj74xKLTwATanDedaBFQah1aQ2qoZSN/qljYI1KdzAgw7hLsMC8E4TkWly+MOwPGaCW5hs4EPohsmgVmABpnlu0wEYYbOLGzrxNLTO5qw4zo+6q0OWtIKFKLN066z7KTgoDw3WEXnMNNoMgFX08GnDUmIDwVQ8ZPXQ6XQ9WcCdyQw3I094BK65WzYPV8bMXK
 6e9/dlwa
 JTK8EpKSdM2XPX96I9PDncEu+HezO08u4XZusJ4ZQ2RFl9pFxOFpzYKKNxL7WytIYtBBnvL5S1cqBNLaDUKoqW437KHnZJDTVHlhpPhnvVIxp3oGlkS5enYY3wmNXlZ5rSvzFo54ulHYXcvRY4f43glW/NMh4RF6X9kj1CkNRxEpC3+58FxyyRe43mUWr0S3Q6lOqGn4GqVBNOK0MsRfNSYpLHKqpbtVMNWON1V+ZmcuYBDfdT1F5Eo4Uofss9U9oXNm4mFCszTXH1GSFv5GSmeJTqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  4 Dec 2025 11:03:54 +0100 Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The newly added damos_test_commit() constructs multiple large structures
> on the stack, which exceeds the warning limit in some cases:
> 
> In file included from mm/damon/core.c:2941:
> mm/damon/tests/core-kunit.h: In function 'damos_test_commit':
> mm/damon/tests/core-kunit.h:965:1: error: the frame size of 1520 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]
> 
> Split this function up into two separate ones that are called sequentially,
> so they can occupy the same stack slots.

Thank you for catching and fixing this, Arnd!

> 
> Fixes: 299a88f6ec13 ("mm/damon/tests/core-kunit: add damos_commit() test")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

