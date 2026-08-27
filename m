Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC576C61DCD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3DCE6B00B1; Thu, 27 Aug 2026 05:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15716B00B2; Thu, 27 Aug 2026 05:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53086B00B3; Thu, 27 Aug 2026 05:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FAB76B00B1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:46:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D1C0160349
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:53 +0000 (UTC)
X-FDA: 85146570306.14.788DC1D
Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3732E20007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787824011;
	b=48m7nJuz5g4YmgT8DNhQrm6E2wd5poDX51Agc8F8bQO757UcANO7f07d9HRcLkvYQtFpex
	WDAP9D90ybRCl036/MzGaU5cvjMi9TR+tiq26gsRbz7nN50btj5mpODv9V89fMJLQ9BpEt
	NetqUiR+I1XG0wVZJYd1vgX+rIjn0pE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787824011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2bGARkwiVhgaLtTodc0L68dzWs5UQCdqps4RGr/x/s=;
	b=3N4C+50LMYS6Jtd1xjNrNnhIzCNl4PU2sHZYRQB64UH/XnFQHvBUsDpsgRtG1hSuEtuzXZ
	+wN/JdcLpECarpOSyRYk7MlMa+0JLLoS450S3V+8VKIRppRTAdrsjVM2IXERrqLNJuwAqC
	SsJGIQK8wgKjBopHvR+benDZplHSq9Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.253 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5fce0ac242cbe7aa;
	Thu, 27 Aug 2026 09:46:49 +0000
X-Mizu-Trace-ID: 5fce0ac242cbe7aa
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 15/16] mm, swap: require zswap for xswap devices
Date: Thu, 27 Aug 2026 17:45:05 +0800
Message-ID: <20260827094509.1016740-16-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3732E20007
X-Stat-Signature: 8u8jh69hq8y54xxpxg5zs1mpq6ezmewc
X-HE-Tag: 1787824010-4111
X-HE-Meta: U2FsdGVkX1+tk8OQksX5hwDtLaV+P1mYsWW/8iP5hQOHyIJu2zJ3GaoEBZoDEO8yHj8ux6Ex5MUAeytQYeax//QIg22OZK0oyzkGmeTFxlzmZPQIozzILPXkjdBL9B9MBjIoneNSjduakUmiMlyFWlocA+SJZQtzedyhijDtDm1OZHa/b7tbx/PrBOpDpLkeB13WsKXvboZwZGZgSyTo95l7YwMa2NO7gu41wSxWMei+/dYX6PRMdFPNI5aQRr4ozQJBE2ax6/oSEaAHXEjByBpOghAQQGhrPtgVSp6wn4XFYoyTZKfwwbG466tM0mIFlXgMXp2WRWOEOElRFakYAz0j3zUrPJtrl56EY0wJ9dBQ+W/Lyur9Ovese5rUM7TewPevKy88W1n3N88+AelJjZr+7U6d+Iuamp5BGQ7vwqQW7f64MwtxT1GyvxS9KIwiKwHoX6I6v1EJX/N3je94Pe5jtTaXLCymV+KounVxMu35EnN4b+jrhVCGEMQjgH9di764hb3Bo0igbnuV3cAivqnY8Zd6sgDI87IwY0NYqo8A4t0TX25rlcbJXMRkqlNhPLaYp3yM8+a+01zpxzBomrjBToBMb7II1pX1lyKrP2lHrsmsXkRadke/GPYarCF7mAH1s3tSv4VlW3+VwJoCiGEx4ZNvpT2uRl4ZwsgZMdGvhQLF0chME8rkyRht/LwnZhRg1/5PJmUMyHkr/m3HiGkRQuhdrPxqYFzmr48nO4y80WY0KoexKT28mPDQp29rF16ntcFGSv09PIltuUgQkN4VFB89CouMBJsaqJi/sbSgRqlD96ko6iJLgtzme4fBBI2h0RuwPFfMgY2xvW+aJf6v83H31m9F6TqJfKKyVXMknCVCK3bFdUbAMySdwyR86IEIw9N+v4HIY5C2pGuqtkKNq5H/zPcPRjrxFuydMWPQgmRFKM51FuWXoiMLO9f/WMW2PLYa7dLkmZ9bDXu
 Z4JrwBnd
 1BdJdq3sDzH0kohlMrslKNcKnkgEfq8Wm4V2/C6tb2Ik9WBsQxXOC0OdWEP6loU0sL9eHCEUeIGY5Kesb40N0A1ePrfS+75HT/84T1WcUbxUF4BPkCzkKj/yy/VRE7OUQgD0xxfsJizMCupJjThLAtWN6UShn2h5zNqVF+CSZyICvgsbWUmePEPZ3xC0Dq9ZeYMONQ//gwaI+GwtBialQYh48p472/I0J9iVo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap has no backing storage: swapped-out pages live only in zswap.
Without zswap, swapout always bounces back, so the device would
consume swap entry space without ever freeing memory.  Refuse to
create a device when zswap is unavailable.

Runtime disabling of zswap after creation is safe: existing entries
stay loadable (zswap_load() gates on zswap_never_enabled(), not the
runtime zswap_enabled flag) and new swapouts merely bounce back to
memory without freeing it.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 451b46b747e3..ae0c549cc9aa 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4349,6 +4349,10 @@ static int xswap_create(int percent)
 	if (percent < 1 || percent > 100)
 		return -EINVAL;
 
+	/* xswap has no backing store, it relies on zswap. */
+	if (!zswap_is_enabled())
+		return -EOPNOTSUPP;
+
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
-- 
2.54.0


