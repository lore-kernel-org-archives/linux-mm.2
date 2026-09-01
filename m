Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49BAC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2BE6B0183; Tue,  1 Sep 2026 09:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184A26B0185; Tue,  1 Sep 2026 09:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098D36B0187; Tue,  1 Sep 2026 09:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC2C46B0185
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 314E814042C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:41 +0000 (UTC)
X-FDA: 85165235442.06.1384732
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4578480012
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jhxcEplR;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvO9nu/pvwrT8AJnGanMkEVbhfeAa8vp4BSGaiM1GXg=;
	b=RpmPjmxGe6GvYMo7mBI9ndffCCpKQxj5vKbmlGgxvyAXmXqFuSh6RC5jgsGypBSnJxeBos
	ZHHF4NTc9DlEfeyhEisqydBE0I9Tkzrrh869wIlYZqwX830XHR+asofC1nVjYflmIdw/3I
	h3ej/bDtdhYSwbS0q0TYAe5AY8D0l3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268418;
	b=TjVTy5QtqyqjvSfHSNf8ESoatudw4/EjkVZAF1kTR4qokg9GykSWIcOkPZP4A8Ks4iVx4g
	eIT2GWtE69RjrlMERAhQQ48qtMzp7jCEF5dMNyo6hLScJaJxF8uqAVslDAirYGUnpBlsj3
	tVmJ/liT4iTDoHpXOWK5C6j3fO79SyA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jhxcEplR;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95F1C42E83;
	Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CFE1F00A3E;
	Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268417;
	bh=VvO9nu/pvwrT8AJnGanMkEVbhfeAa8vp4BSGaiM1GXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhxcEplR7ISywxsedbUTqGQu7PZiqFsRqLmJ3SUop1iqYrPGKpKqoT674IWzD2tpu
	 vBKhSLCyTbHm0V6fYoTATWVQveKAq2w5X64m/0MQNtP+IiYN93BqNWV2ViAhcMtX1/
	 tqIZdRCnsYz43Xci1FCQr67kw4uCSYAx7jYvLx1WYB3dpyKaQ4+Un1lTsNMSWrmB6W
	 dC8vgFFYVStw3iHBO6BUnogGZQuhtMB3gXe30XaprI60pLphYo6I3Ivlp4/LbIiE1+
	 ibEu3mqQ3WKSz2Cp3lcPTVpM5FnaQu8gT7ZIy2gGykqp8hwfyfGbLKjMaiUtZF0Czp
	 G8fV0gNgBz3nA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/7] mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
Date: Tue,  1 Sep 2026 06:13:24 -0700
Message-ID: <20260901131326.97615-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131326.97615-1-sj@kernel.org>
References: <20260901131326.97615-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iknf5ioaqobjj43it97rtm3fp397wwy7
X-Rspamd-Queue-Id: 4578480012
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788268418-301222
X-HE-Meta: U2FsdGVkX1/lAJjdxoKFVnZMlNqQqTN3XQVGdgvqR6i44cga0qmHrNBmj8sXdUwQVX3uoAylyTsPMkQ3vfPhgTfV34WrPhE8R10dtuUMVfzYlb0pklp7QvaW9AQQhQR4NJGT3uUhmIdJSIb9/Fze45dI5lrMNAoIRme9P4qhOnMNbZXKtyRbomGJDJhOu0ADokcAnaQzgvHxABS0xZklLU2fBcpnY7rcv4OOTmE1+ikoWCxmfjh/z1nN2EBcpw5NBmV+MZDOSpx2q+hqY8zu0UAOEubK1H8i5L90AID0UbviscRjt3A6Cysj7e5eujAt4DoHKkHHvAbqe7/WKZQ38ecw/3dIpoiDsRLTYqPAu5QfDcuIg0nECn2jKg4jCY04Q6mzh1yeoz027tb3rZTgQB566Eyc0K7h1KtwgInvnZEEcGj2cP4GjFVheeVuswsWqi6eWhpUq9Z0deYEoQJJC/XaAwLe6wRApaolBcsb0qWXDcWYFeFjhSRG7iBKmSthhyFEkoTVhLacdCFRo+2epGfOqQGsWRQPHxpMxcANNQwg7qYMX3blPW4im09hQaPHZwyMGe3NRBNViFuOGCgaIOma1gbaZBd4bH+KcopXjlgZG4IexvLAFJiyAHZZWsv2fjhapZjYfMxfW8fUoM58GVvNYTB6WGynfWzA8IPSWL6C9q3wLclZyj9Yg7RY3qtOSfE+8tbyE9CB0NxZJfY24jYbSV48NU5ICU2Y5nkTAutaHkssSf2NPWukKSSvS32AmjOpDX53ZVCd61CH4sR2XbprqLOGUdlstl3Wc40KqFcT4+8vedT8JdEKIlUMrRgbQH+2VG643WGloQfSN8fl8aV9GXW3ct7BnxZANRLrCkjvKM2iUKiCTy3YG78kqNYcIEybfbcA3z2ecKQ4kBs+3J9yjqLnKOGC5vSaCIuumoZDbiZWs4LD/FVWzapaGQCjXlszRlERwCQNplg3lbE
 iJJ6X0wA
 kiLTK2kQfAlW7tjO8N9bOrt78RY6BvLboQ5UR2pHnKNEXCtwudLmprpu9rXk4Zm5gVnKn+7tTPB9HHA7A6MEVF7e5WYDUE+j3pmpYvoj4+MPCjOFbc7RscCV5E8iV2SMeicc6MWFytR+6760CSbNqSeMD9KchUy+YA5L0z0WFXuVO8byDxTu7JTau/44o4SdzNCbbLeCNMLHhLc5yhS6lHjPF1wj+pisasnk0Gt15YvITXENNKhIhBO0m7qyCSSDEoIMzW6H2AZRI2ZiKLiDtpr7UaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_get_in_active_mem_bp() uses the sum of the active and inactive
memory amount as a denominator.  In an extreme and unlikely environment,
active and inactive memory might be zero.  In this case, hence, it
results in a divide by zero problem.  Avoid it by changing the
denominator to one if it is zero, before it is being used.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260721034756.147011-1-sj@kernel.org

Fixes: 4835e2871321 ("mm/damon/core: introduce [in]active memory ratio damos quota goal metric")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3060edf5e4fa6..0df785e72438f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3006,7 +3006,7 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
 	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
-	total = active + inactive;
+	total = max(active + inactive, 1);
 	if (active_ratio)
 		return mult_frac(active, 10000, total);
 	return mult_frac(inactive, 10000, total);
-- 
2.47.3

