Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79FEC55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008A86B0098; Sat,  1 Aug 2026 13:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20E76B0099; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0FC96B009B; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3C3F6B0099
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64DCEA0342
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:09 +0000 (UTC)
X-FDA: 85053404058.24.F7573DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BC8B114000F
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dBhdoT/o";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1TLO1J6QDVVNz5r0BRdl5+1+gHGcHEvIPNqhuz3/rg=;
	b=Si2SELKfDM4tbVX9uyOrOrrftw5wWv4jpwfC4VqMZlTWvdDVgjZzMniAQo9iU7Ia9kU+TM
	AOiQ7E1SdklqlKCLCtZkEIZsc6NGhv9jLWCERNutYUPapfTqAO8aBSxb2MqCYiwCzmi52i
	VXJSkHERZHUUf4/uR/Zcoc71iqWurfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605767;
	b=rV6kDNvyVGsEg7JP5Dcbm8lB8VQo5V559WpDVaSK60EM8hmizxA4XXpKuCZm/Ybe9uqg4l
	43lFaq136wxruozpNa9kl7kJFuAHoniRxI1YlpX1BnnYIF9KLTH771UiQtMQDE7CVbqqIO
	nAobgi/sb0uW3K8XZwHBlCbna8yyof8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dBhdoT/o";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07EC943CA6;
	Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDBA1F00ACF;
	Sat,  1 Aug 2026 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605766;
	bh=o1TLO1J6QDVVNz5r0BRdl5+1+gHGcHEvIPNqhuz3/rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBhdoT/oGy8uRNBe84+vYOBuny3Wc3DU+omPxB8qCyOOhCnd7o9VPHfTLGSr0svTm
	 WIVpXEAo95W2gFYNTc60Q/WrtdVkwUCPxrXFqI0aCS1pvhIFlzieCAPUArKSzS7M7E
	 WiCSPcSHFSaorwfw1JYkCD+X/Z6b8UycD0GVzoa6YTU6LaSH+i8jYQ4BqC3u4nkN50
	 aVM3BZ6dyZVLl5ekBfmG8Qzr27Ok+q7YLzONrQq1/3z9fWr02hCNBH7/Bbv78Ez8kf
	 DORcHdnxEUA7CGYp9TRVu0eCFvk35jcx2SgKzYvpD57ijKfUj4y99iyAUR1EaPkGGM
	 LadBoeJhACBfg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 7/9] mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
Date: Sat,  1 Aug 2026 10:35:50 -0700
Message-ID: <20260801173554.94710-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260801173554.94710-1-sj@kernel.org>
References: <20260801173554.94710-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 43c9f1oi8tphepj4uasxdgw7d1iu4ayt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC8B114000F
X-HE-Tag: 1785605767-488350
X-HE-Meta: U2FsdGVkX185B+CYoL4hpAPAIxGlJ+UK8A74J5YKD9Uab6SDgMdiIFsRY1JpLUU0x64AGq3wqega0yMEp/jaHhY7tDwoEJmkctrMjYdm6P0Xc/JxmZk8cBL36fpNKfF0XakAmkLEsTLWefkQQp1NPHsjT9y1IzvxaCk32DTzhx/1O/JlAr4IEtuxVbiPIxigBXkUIxQUy/z7Vc34+3H4XnBNXJNp+x+mAspn7xONh8L/T9ItkNby6hNN1qMpzjzwLSLtVwVjreoNdE+ixdGDrtkviHOWcaY9TbEbluuBLORlbNx5OpCscy1JTizQZt/C9MwLhhoJSa26Nby1RbBt0Vl/sDbS5HBdvmni6jl3401yZd4DLR7e+jIfqEUtnj6XMowOYtgs4VFdlwQRQ1M9mSRBHRTAz3EQl1ymKX+yi6oY+As0+LpqFYCTC7KlIqxIZWap/iJVr9wdTt0lJidiGc7PIY34gDOL4oeH6YoFVgJnYzLl5sUqb0P/kXU8euDkUl0T9veSzAy3yOe0z8AiD+UfW+wQYJneXGXYJvLNLKzAX6kwEp3MVC3m347d3zNhNJMM9rKfuEfT0Rug9EZOXaZ2aszlPIMsVnRZ6FY/UeZCDNIbK+fw4Q3SOBFWAKhWwNiaGEQpy6QAdhaKT3PL1YbEvCYxeAP9eiXfHqpb8zqbXzIc9DcKkrrFRMtCHTsmliOLSkxVDhlDTRZucZHUvQJlILo6WUPzNnwhKKzD8/k8Y+k+F+6gFs8rT9wu5/6paxVeguczqZ/Ylt7l6ryXg4ghb+Hr4V3bQmpWQTZgLckiirXoVeXLr0KFt4WGwIvDnVEHRzDqK3tEaKuLXpotFd49WbbW6BH7QjyYDpPuGhfFOZbSKZ0ECE351Te+Bi3S8GzE5FqBUKvypAEk/CTjtYVWNct9Ak041zOEaO8yqxpoOlYNnohtLHa6NOCMOvIWDXhUROu78Z4LaxZn7+W
 M7aa77NL
 hk/0JwXxHKYn/7WpMCCAWZQ2r2O7orlhemgK5yYqF/PQyleMSqX1wTlvMCUXx5XCrH5MoWkIX9bohB0CyUx9sTcIYBKymWTM94T01L4IG16z6HxRwl8m5pChSsdc5m8zxO7sz8V+Gd8MbhTUTCLxZ2UrJbivbHd+O+J+K25qKpLV5K7uwjN5XFqe17bNBR0Chkx36oWkNOMKOdpc4VlwTh90zgl7V9l5TZxAIJx0IXo7jycVWlilE59Jo4ItA1xFHGRcMita4bE4f+SMSR9kF1RycfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In an extreme and unlikely situation, si_meminfo_node() might let the
caller show zero total ram.  That could cause a divide by zero in
damon_get_node_mem_bp().  Fix it by setting the totalram one byte in the
case.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260328133216.9697-1-sj@kernel.org

Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3bdbf4fbf7147..269865eb8fbfa 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2816,6 +2816,8 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 	}
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram)
+		i.totalram = 1;
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
-- 
2.47.3

