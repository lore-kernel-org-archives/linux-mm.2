Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C2E10BA421
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 06:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34866B008C; Sat, 28 Mar 2026 02:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5366B0095; Sat, 28 Mar 2026 02:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAD86B0096; Sat, 28 Mar 2026 02:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BDB66B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:47:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB7DC1B98F2
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 06:47:31 +0000 (UTC)
X-FDA: 84594540702.03.69B1824
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf05.hostedemail.com (Postfix) with ESMTP id B2F7B100004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 06:47:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Rd85EZND;
	spf=pass (imf05.hostedemail.com: domain of ljykernel@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ljykernel@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774680450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pmoCep+sNDEX1efVGiWbJUVpyvXC3/IcRIIhGN4hwYc=;
	b=NlgGIZCBBaY6hBsk6I3ba2JHJxe65glE/3SR/c0BvJ5DZtbyislmoyc5IHqqzunHi9dJQr
	JiuT7KYz2f6aN/kYZmy3UOxxvYxjlGE9/VRp8eOSBeXwxYv74WePsiWl59hQmFCTbbRdo7
	sXlSKg3GtJkbhms3CPd0WKQk3R+6wkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774680450; a=rsa-sha256;
	cv=none;
	b=iHtNc9Ub7yGD8pvbTpKXY4dH87G6LTCczSZXsggcbNknAm8RuYuMxuMt5o1R9lPoat17nR
	Wu2OBmTSXKXiUGqyMkQYi3sw86GaX9Anlvm+BkYJbbdh1BYBtmMjN27rGPk9zfZutLCj3B
	XoRmGAnWIdcnFiyJg6nBdfNO4m4Nnsk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Rd85EZND;
	spf=pass (imf05.hostedemail.com: domain of ljykernel@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ljykernel@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=pm
	oCep+sNDEX1efVGiWbJUVpyvXC3/IcRIIhGN4hwYc=; b=Rd85EZNDhfU79qRGe2
	T7mCJdtOFwtFZ8o9gZRxgkaYhSkMCV1Hxsn/8UeCCYkhYSSmiRf3oSXne74jUuF2
	WmDGUwkbtyTL5Z3oTyDf3SByRCQCXtSQUvpeDq6CASy/Qc2Utld5fuVGJzpsw9o4
	OCTf4hzt46qUSL5nyqSti2EmI=
Received: from node-3.domain.tld (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgBXbq1zecdpefzOBA--.2S2;
	Sat, 28 Mar 2026 14:47:20 +0800 (CST)
From: Jiayuan Liang <ljykernel@163.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Jiayuan Liang <ljykernel@163.com>
Subject: [PATCH] mm/page_owner: add warning when stack depth exceeds PAGE_OWNER_STACK_DEPTH
Date: Sun, 29 Mar 2026 05:16:17 +0800
Message-ID: <20260328211617.2985292-1-ljykernel@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgBXbq1zecdpefzOBA--.2S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr45Wr4DXFy7Cw1UCF48Zwb_yoW3trbE93
	43X3Wvkr1ayr9xZw1Ik3ZrJrya9348Ar1kCrnFga1a9rn5tFykXa4vkwnrAr1UXr4agr1q
	krnrZayjk34FqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRtSoGJUUUUU==
X-Originating-IP: [211.103.144.18]
X-CM-SenderInfo: 5om1yvhuqhzqqrwthudrp/xtbC7xjIN2nHeXgeTAAA31
X-Rspamd-Queue-Id: B2F7B100004
X-Stat-Signature: it4req8ok8e3yn6u4rberhm8qrsz7w5a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774680447-243398
X-HE-Meta: U2FsdGVkX19FUjxlvasYK61t4mCzH/jR9eJ1G6VVzOY7MKzSq/815D5flDgQmY4VzXStUY1ZIzV9X5SUO2OZpIJ3DwfVmDrHsato4OwBH61QaVXiqml2ko5jkPz4jjKt6DGdHgqTO/kBBjRa9varavprX1TYTrENTKG/53iiyT6m62uM1XIJnQyAW1d+4RNqdRIb40KGi2+gmop3EZzRH2WYevJnU1BlDNC1hMzA2wOEAI3zQUTFlDYviLpA1FTa5WIuVFTPgexYNE0v88yJTrx4tSZlQ7W5/2LOK908yjKtSbtCEWlBcZPyNEJMQNmT7cnfjS54U+uw7/B/vStWt4KVHquS1Tv9iX77a5hlolfBAWn2rxk7q7YPJnlmihKm/zDlPmDASgzM+IU1GqaHYx0SlPzsRIlWsdzb4nASsZc7zf5cqfA5zqMA4Gnz0dQietRBZiPwjOxjLKoQyKTou47d4FfxxBetc5GiEViRa1u0Nvro/BV472FiJJRt88MUGaLPDFKClMPspAqlR+aWjiaf/dTI4zp03lrhAozcnVilfX1qvykqO2s0MhT2TdmTXuVrr/zI8ANfFRi4HtMXET97rL1TodpwwwYWFbSPhI9ksXbfNRfHZniuOBnBi9Mdl67b/K2rYa8eHE6BQo66PKCFxPZfp4H894VhOHTa/Uxk9N0IE5AW5/fhHNkdk17XnrClDQJu5DqpBdubblqAvKZBJ5feO5ZiRBhiaF0wmb6ws9jhVnax6Vgvnpk4DguQo9Gclo5CplfcAfbtuCW+oSLeNFWYARJ1iLNfe7fce7eA4LJEG/ZQUTZJ29sAZhjnHoWgrQ9lvabrW6wZ2Sy63mCqJKpCCutnyVv3WU6y7QX1D3lDOQTgdNbl2tJTmb/wnOfBPiHB+XlRU806Elv/5hXzUSrd26S5wG1D2YAOe29stdP3Y9MOd7xGceFqwXQ0PvaM0RrVflqsOnWHa2J
 tfgwC1iU
 nwIDStrujrCU7TfXMosEKof5EOSwRVpXMvFxyK7JrX701YHhr9MUbnc4oI883P9WfKdjbFNpGtu0ygI6+uwyC0LgA69OkKV+vl87IpC/aWwUKJxD8bzW46LYIyvXInyst4SoFOTAXOPFqAgP8Jke6rjwOX/mavR5sYDZe7H8ZG0h/MqCsd9aZV4nCI0BG3lQgPpQscsAUugRsE1IaBLFc/qT0x1E0u8YzdVXBfovgI7l0lM37qE9Hf9SZz2lc+IAIpfFuHPwsYVDxI06pXu9yXIB0issaVKIQMjJ4yzlTE6BNswfUAjWF92qs10z9oZx2NnxNhvdp4/vrCVWTP6aV0Q1uCB8u2R9LMDK8qS42J3+FlgGoE4buLBiX3a3Rwri1nEhmx/Mf2BEsEKOgd+ggPxtj1dxIskjuqqN/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/page_owner: warn when stack trace depth hits PAGE_OWNER_STACK_DEPTH limit

Signed-off-by: Jiayuan Liang <ljykernel@163.com>
---
 mm/page_owner.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be5..82c107455 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -163,6 +163,9 @@ static noinline depot_stack_handle_t save_stack(gfp_t flags)
 
        set_current_in_page_owner();
        nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
+       if (nr_entries >= PAGE_OWNER_STACK_DEPTH)
+               pr_warn_ratelimited("page_owner: stack depth %u exceeds limit %u, trace truncated\n",
+                       nr_entries, PAGE_OWNER_STACK_DEPTH);
        handle = stack_depot_save(entries, nr_entries, flags);
        if (!handle)
                handle = failure_handle;
-- 
2.43.0


