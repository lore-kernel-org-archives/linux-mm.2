Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A550C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE136B0088; Tue, 15 Sep 2026 06:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC73A6B008C; Tue, 15 Sep 2026 06:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D029A6B0092; Tue, 15 Sep 2026 06:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABC716B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:16:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C98261403A2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:16:04 +0000 (UTC)
X-FDA: 85215591048.07.75B6B91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 55C0040008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:16:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L4/VWeIA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1p5u2Zwv/oGa+juGw7P9v9Q6snr+DKkTRIeNmG+WA6k=;
	b=5dUi2+SFxgCC6BtEQRfyN/mEP7LrGFDx1EVeIkNvZuKcQ9F0KapGb2YXE8mUjKxXC5ZoLS
	Uu0uayx2SliW73c77yuBgy1xJgbmUxGPeDsw9puFM6yeYLnAmCTVs+dZ0TS8TVlK2kwLNC
	ihoh9cm+5GBpSI6UHVDur1rOMzY8zu4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467363;
	b=n6siZJxTKLkfIE9xNKJAYAV7cj2+LluBUjfH14ameUjX/0tH4OHlgCvFF3IoXMtkY7NLS8
	Th7CGMyTOEAxl6xpVr8/ld8nrHrMNXEJxsYgD5hGgCWy2iofhHn5zIBvDVqUzx6Q85oj+2
	UxNQhusfsStKItwkXwkxcpyehw+5w+Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L4/VWeIA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 533EB4054F;
	Tue, 15 Sep 2026 10:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316241F000FF;
	Tue, 15 Sep 2026 10:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467362;
	bh=1p5u2Zwv/oGa+juGw7P9v9Q6snr+DKkTRIeNmG+WA6k=;
	h=From:To:Cc:Subject:Date;
	b=L4/VWeIAVDb1IzFKLYX1b/+IaSxpVI3jJNVNJK/KrLJj1lPqvsaKt6sIEY2jrpXAD
	 0EfamwAPKN09SBCxULADG0HVUsCF0rCS2HCanCVTd1rbWN143su7Q4lxoOygf/YdMG
	 gmpMOt76dM4zHxEDdKyeESVM4cBRTLvsUYnLQrTs5DbU2kukNTkkXpAz/Gt/Tk/iuf
	 posWqFnP4N94Pcj9WQq8u9pU/SVeZcqUb4cLlAw/5xtGWJIIaFqQ1tcwu+mIumfEtq
	 gpRaupWOrLyBIin/QWtUIaX+F8bnqKaCnlPxNtRL4BXq1DJjFvA44j4ymwYecbm12j
	 NWTei3CcBR+gg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
Cc: axelrasmussen@google.com,
	baohua@kernel.org,
	baoquan.he@linux.dev,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	yuzhao@google.com,
	Chuanhua Han <hanchuanhua802@gmail.com>
Subject: [PATCH] mm/mglru: restore accidentally removed seq < max_seq check
Date: Tue, 15 Sep 2026 18:15:56 +0800
Message-Id: <20260915101556.50467-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 55C0040008
X-Stat-Signature: a5o7tsz43yh8eezmd9gyd9ow8nxss6df
X-HE-Tag: 1789467363-551850
X-HE-Meta: U2FsdGVkX1/RqZYukJlMY57RGId4qgayFpxKRVdkUy+ufq0YAUbtLdnZ4yPo+5RO7hBAMfbWza7QOnOdyMPBNmH0+dfD6yNhTdA5wXY6BVJpTIFEf4C9a1oJdAjq9ySRirTmkETRu/BvEbkSZWdwX1PnjFBHzmZONG5CwObFAyDIKY0k4pC2iPUf6q0moui/FLOy8sA/W+Bg0TjNJWF57LJ/4Ew1uVM44WIRmWo4TfCGebAG5QXtdHwiyGcit4hUtNt1V5aGC7DSurORzhbf7Vlnpbs994CcthvM1vt+Niryw57pRb5mtIpsUhwfKk7fBfIIWVl5oV9/+x9B1ayXxHQZkDpU9v7MVz+FoA7HzE9wydFY+YFcdKo1ac1BL1rNse1o+NydShQ1BHRv7t87V0kNI7Y8O+JyIoR/XF0pVplzweh2w3seWPzEMDuJeh49sItd8eGLCGh3U5Huav4EmD/M/FuF4PnZSryNo7MfDoeWpOUQ/S3kgKX56dntKsoKFcZQAo/5S5dZrRyMHIvoZZTdy6FKCjiRueTsumENE/wtrX7odvNHtYMtRQ2AYynz0uHjQp2uxo+cy88HLA2RdmR7Or4GgVi8E1o7rx/FKGG24N3m/GCy6JhIC/Gim4UXxG8JO3pH91GNxyFXzjZFsplza/SV9VXGLs/xBUo/NE3Oq9XBthM5wl+sTyYxAvjFW2sKIVEPXyyVT+KuxL3MOcI0qJTB9+LLdt0lZHFYCBRnM93X1F/kmFLangYlg60HwFQSjmDrsNoY93R7AGXLMygEl0gTJmApptGqACydq49SL3L/xNbB8Pb2+6ybq5654Dy354kZfSLhjSD0zTnBS6LW3T95S5PIGq3qPiXo+IiHVOvXqZh5uQHJZe/R0rAsmzVo5KYrK9U9R1cA0ocZVLtWyJbjj+Hwgin6ZVFeOM/4ub8rl8s73jiZhyNG7c5I/yvGaS3Jqbx2bmYL7Wq
 kL9OHMZ2
 GmqV9RYgWeywhGfNeK0afkHfA6heGhGgkImj7hPjiGZAFbxh3lqGIMqo0fZe2MFeQ4VojadKuRoWR5+JC2NvD4TN5bIVtJ+n0wEvR79AHp5qegew2Leih480dT3eafEcXXJycTWUIQtBxIXqZCw7HULRr74OGKfNsEsCQdRD3grbHx9cnw8S31iiqJoHUXJuzU8fam/yKoP3AL/s17+qE3XwFze7h6fPS5mU8g7xYy0uMeOL9AipP/qtl1Kmz2rFFbTdQiuX/7kMW3/8qmvzEJQeTVNDLatXCB9SXuIR/q1wEYHjHjB6QrQPcCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 798c0330c2ca ("mm/mglru: rework aging feedback"),
the following sanity check was accidentally removed:
       if (seq < max_seq)
               return 0;

That means we can perform aging for any value less than or equal to
max_gen_nr.

This has been inconsistent with
Documentation/admin-guide/mm/multigen_lru.rst, which states:

 Users can write the following command to ``lru_gen`` to create a new
 generation ``max_gen_nr+1``:

     ``+ memcg_id node_id max_gen_nr [can_swap [force_scan]]``

The correct semantics are that writing a value smaller than
max_gen_nr should return 0, since the requested generation already
exists.

Fixes: 798c0330c2ca ("mm/mglru: rework aging feedback")
Reported-by: Chuanhua Han <hanchuanhua802@gmail.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5354eb8d3a07..18c4d3595749 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5827,6 +5827,9 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
 {
 	DEFINE_MAX_SEQ(lruvec);
 
+	if (seq < max_seq)
+		return 0;
+
 	if (seq > max_seq)
 		return -EINVAL;
 
-- 
2.39.3 (Apple Git-146)


