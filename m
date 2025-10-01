Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE84CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 23:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069728E0005; Wed,  1 Oct 2025 19:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019D38E0002; Wed,  1 Oct 2025 19:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99868E0005; Wed,  1 Oct 2025 19:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D83E18E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:48:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78C89B58F5
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:48:32 +0000 (UTC)
X-FDA: 83951187264.21.268DB7F
Received: from smtp153-168.sina.com.cn (smtp153-168.sina.com.cn [61.135.153.168])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E45B4000E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:48:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=EuNYN5AE;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.168 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759362510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZQWondl07akNaSbykBePufOpb6YbJS3NJLe/Pq4A5Y=;
	b=EJ43insmCLm/s38wPlppz7Pxp6njOVZXabF/dtDL7qdpJK1+DbrUjDTMBlKvB26PyMGjGl
	Vs6wojqHk5EUUfm95hWdlv/Pvwgjsf7oGN1MROMTWmM+0bcnRKmAX7QCP/OM7ELanG7skG
	RQrnOwSSe23n/MDe+ZpkcwNatnSiYKs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=EuNYN5AE;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.168 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759362510; a=rsa-sha256;
	cv=none;
	b=kPt9sCwGh0ngaDg11bslDixMecCqgn78wT4x3sf7yWHH0l38a2mTMPdMmqkDEQmG6o7JDf
	EyMMuy18QBUKlooKPHq6Kf7vIEufgLSQCBo+7+e8tXgBAR01gbmSvf56msxBwrX/6Y5uS5
	vr3BgAv/k4mWO6EjD3S/Qa/ScYlWEtE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1759362509;
	bh=yZQWondl07akNaSbykBePufOpb6YbJS3NJLe/Pq4A5Y=;
	h=From:Subject:Date:Message-ID;
	b=EuNYN5AE/2a5TMA05wqY2dltxyEJg0ixdz3cfAQuo9AvIT9LIpO0T/whKYDNQxrJb
	 HPPbFSLZDF3o4iSrqmxZ9BKMR7D5D6Y7Qb/53TV7rbOpFh3Uu+CEAUf4KlPDhxv7zp
	 ijAJPGghyZqG45vpeoLBtgDJt1oThcX5Xo9DZt4A=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.33) with ESMTP
	id 68DDBDC600002D15; Wed, 2 Oct 2025 07:48:24 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 5327776685137
X-SMAIL-UIID: FC1CA3AB1CD149779B717C7E815BC1F3-20251002-074824-1
From: Hillf Danton <hdanton@sina.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Thu,  2 Oct 2025 07:48:13 +0800
Message-ID: <20251001234814.7896-1-hdanton@sina.com>
In-Reply-To: <20251001153717.2379348-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E45B4000E
X-Rspamd-Server: rspam05
X-Stat-Signature: f4tzzhusbdu7hsy6mx66hnrgn4pyquon
X-Rspam-User: 
X-HE-Tag: 1759362508-993783
X-HE-Meta: U2FsdGVkX18/NBtw0PKFqD8Bpm5ImbdSODiRdz5nypAhrZqhIR6gJz7SVrpyZGN+e37TBmyYpLPmdqkiqB3OA4RoexwL94DvZsSSshaGCvBS8+mxaOOc32YdPIc1Z/4Ik4hj2Am3cU3GVlpjfS43Mh37LWVizCBHRqemLQs+c4ZG8SYvDKq+9Z5W4ttV+/G2k2cetkQgfuYuwqDOy2YQ2LDWivkaNrLfdo4889q+53bZE5MQlLrV4C/ns9wdgoHBqIAQuMZL8YK3u07kudBIIg7IJStvju+gv31qroxML1prgxuQU7/wPCO/4BDWoiqONcYC+KEX+2FnL0yb1WFxaY8ZNRQAgbIazogZioBeFpWtGeRIzeTbDnG60bZrlPp5PoZ/DPgJ89xZrUSqBNWk0W7AE29OBmK7fGnhz8az6fN2Sa+LxrYhneadLxK2E+FK+xpChvR7H9j0aQt/FrSr3qoTIcztJzy6WFtpvRsdfaD3y+UB+fTYbWpuhNsCJKx308w8Y5Uw782rVyOrITL7ZhzxY9NFMEJjHJVoVjgWyoKSzLpGppPs/v7+PWgpY8sqn3fKgpgXHr1DwfmF/L2hCpTsRqZVY0CEAzBxFjQpsh2m8B278gs6PQ5QOgiGeQ5LkHih+oMeCJIfY5allM69QRsYc7JYd7wgMNXBujMt1VxVzYaJz6nBCx24z1XQ/t5vt0NZpO3iGz0Wl7hcoDNZ7ScsCBtHqKltIKtajkneBqy2an5slaOhy5+MBgMGRp0hO8aJMyUmbPs87hzmQGSdIueHjnAX5Su3QZlO7pwapJeBbXMzv8mGixW+GaW2xG1ICzq2lVURlNFICe+T4EgYo9qSrNyYeUf0Y6IkD7p7tFCVBDYOo8pSMI0QlTr5RwhPa0M0/Gfy+iZtmUTI5Qb0GwlldRubUfRVTR4B7jkSFdcEUdwRfz1OrTsYK+ozAXscB6ODTdcnCgEjoX4FiL4
 c9HVw0P0
 PnUbiapavgKkEUlcpZ98pzP7GOlDAQZfXgbNWbNb+7w1S4UilAVjcyqzcQUCBTNVLCenkGGIolNo/gOQNYfom9+zGNljv8PAWh1aYcJ/VrzozqlGcFYX/6FXy/4ajgd0ZxYnbGvFJP5XU/6Zknv5V4r6XzUYdry2U4JEyZKawLRs8GhA18cj8NIx82mrCWgAB6Bxd6g6Q4sKNcpnKtQk8klxSuVUXJ8e3v40Y3i2NWZ5jnMMpc3+36ly8IuLZBMerpOxEyHVClR92cB6Z1RpQ3TGpo487Pm9xCvNduuykHKKKkpUfGm2HEl+CI6MbFMtpTvfxj5aJHTAQFT6YCsAgmtqjjxR9Do/GUGEqstvznn8zGmMgPd+kqT61Zp8G1qRPEKB5vTWjTDOFUYiSZQl5McNUp4GEWRswaboFMOWcjhD6YeWWGEWf/WgJOC6pkB6xqVXXlK6DlUdbjUpxzR9MFPteWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Oct 2025 08:37:16 -0700 Joshua Hahn wrote:
> 
> While I definitely agree that spreading out 1TB across multiple NUMA nodes
> is an option that should be considered, I am unsure if it makes sense to
> dismiss this issue as simply a misconfiguration problem.
> 
> The reality is that these machines do exist, and we see zone lock contention
> on these machines. You can also see that I ran performance evaluation tests
> on relatively smaller machines (250G) and saw some performance gains.
> 
If NUMA node could not be an option, there is still much room in the zone types
for adding new zones on top of the current pcp and zone mechanism to mitigate
zone lock contention, see diff below. Then the issue falls in the config category.

> The other point that I wanted to mention is that simply adding more NUMA
> nodes is not always strictly beneficial; it changes how the scheduler
> has to work, workloads would require more numa-aware tuning, etc.

Feel safe to sit back with Netflix on as PeterZ is taking care of NUMA nodes
and eevdf, haha.

--- x/include/linux/mmzone.h
+++ y/include/linux/mmzone.h
@@ -779,6 +779,9 @@ enum zone_type {
 #ifdef CONFIG_ZONE_DMA32
 	ZONE_DMA32,
 #endif
+#ifdef CONFIG_ZONE_EXP
+	ZONE_EXP0, ZONE_EXP1, ZONE_EXP2, /* experiment */
+#endif
 	/*
 	 * Normal addressable memory is in ZONE_NORMAL. DMA operations can be
 	 * performed on pages in ZONE_NORMAL if the DMA devices support

