Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7ED5C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29F36B00AE; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93CE56B00A3; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2FA6B00A3; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0FD6B00A4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDEFE1C00A5
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
X-FDA: 85147572930.10.AEA9F65
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id E99BE80007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CccpWaUs;
	spf=pass (imf30.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847884;
	b=SHBubvwaBr/rLb3Jv1sIyX1l/6Lokr8kYA+rcvSd+DcOuxq3t9934TSim4oi16cf+bB29U
	RSy1gVE8xpvgWTpqU0frhwNKR3wgy+087bywDFvoQHyPUYPQtF9RF6lnPmxVpBjVWwDpFV
	rDCxLJP6Za6JkE7SIyOqMku8M9oij3g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CccpWaUs;
	spf=pass (imf30.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847884;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUa7pS4OHibv7k1aZNkFDzTCnQ9Tn89o+Rildjw0B6k=;
	b=EZVMOVcTCldQdctT191n3ixPAPpOtHQ1aS3AzvyALO7T+gzJAr2MAesA+pxZGIqCRfzqL3
	8QSOuezs9FcDwtWTv148TULISi5KgUz7Tj6++TqqoYvXxRGU0Pjcg4t1O5MPxf+i/TWyMF
	Pwqc9MnaZrM5Dy4baz5sPqMp6Ic17g8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fUa7pS4OHibv7k1aZNkFDzTCnQ9Tn89o+Rildjw0B6k=;
	b=CccpWaUsRgM2J3CMlge2JDc32pT8dih8KCHNscYv2r+jgWhSa/BbR/8RILkH8O5kbpzttbHXn
	6tbp/SC/chqJ3BbIXL3K7I04ctuktFcHeXy6i4fEkUR+lXXsoWpfO3tQGirIX0pTiGi04wxJ/z+
	pCpZ1bHP36L3Y9WHJC9YEtw=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KF5v67zHnH3h;
	Fri, 28 Aug 2026 00:24:01 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id D049140572;
	Fri, 28 Aug 2026 00:24:37 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:37 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 15/18] arm64: add support of NUMA replication for ptdump
Date: Fri, 28 Aug 2026 00:11:55 +0800
Message-ID: <20260827161158.3618409-16-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E99BE80007
X-Stat-Signature: n6o1jjzxm6o1epc1wj7k4ikaqmhi7znt
X-HE-Tag: 1787847883-74830
X-HE-Meta: U2FsdGVkX18fgy+dxFjOQHcveNixcJfKt1XjoCl7EXpEr6/KzFnH8v7eEzkXLMMiNtWMO1zwKZcLB3kyMT2OKcBXWYYu5SZ/nzW1hjQpswscmWl+YP8FT72l7no/qgFFJHRo8WmmvCf4nBICMLc+gPckQvXMgKD+s6hjsBJ/GsZnlpvrU92mISGiBQvv0m/eC1og4QeGc6Oj6t9xM4Kj9F5ZoZFbs5bNPHIVVyn7F0ce2mFd/IBbrY8I8bEb3vYV44rvpfHG5/ggMHaDZxtPPzY1smzd/9yMiv5FiHYfGhUBccfkzr+hemOqfQr+NdiINXxsmZE879jsLsedN6ip3XaIdSI3je359AlNPw6zIyDqhmna8b+5rFhuoPL0hnWyfbXJUkeyFASr8lx/LONKlPtyfY02r1VLueI5WygzJ2X+qcg1FJi70YrQgEBEnSyJSzM8a8g0Pzj33NBJw8AcU/hKG4rOX68tGrW/46B0bCV/w5kFZ0LIi92S7/TMy4uk5Yx4tY+rryAopjnyeKT3zRCoSu8Y3OVu33o10+F4EtVu+WzihIlbK9bQKVeJl7gbGNPqTXvn7mGEVRPQqbleIdKSt2WzAEJuxX8Nn9R5TAPvyWbg4Yts5cY7CnrX5GjwzrQjrYGSw9JPtW+WFy0Szs5EGiiAiwgKJkNHQuSvUfk4ceEohB3nNFI1wC3bFpUP9UXnZCHZY0eM8bhYkDsx1rQPDhmx7JZMPzX6JZ96dxQ9BRqwGpgPnHYAab84SBWQzJpTnan2GpsaWnySrzmFBdkbTNTtPjohJI6t3hEhtvO+IJx6qrEky1hmpt4AbVmS4OW+PKRShWYj52BlJthwnbHBViA/TMKuqUuZefG3jXb86vR8PBV0mvuWEIyZ3U8ccF9oyRrtUXXrYANXs3U0taEWMCucoBSbARCMqw70y8Xt5kMubl5tXxMzaCX8HrvhNRpQEJrVyUs+yLbSWDJ
 pDvMzP60
 EFsg0u8yd6AQzSa/h5HUixzwp2Vrg4qClU5UBSihLJEoeBHmaBzX+WrCG5vsz3LtTBEEVlUTg+Ilr+6dw5mWIhBhNo2ObbWvj8k3a6TZ6gPTZq7XkKE0oXLHExRLibc19ozbDN9AyuNMK/Y5LAbdL/MaP6JfcyEWjOCvUcqkAiiaLJ9Ar7iBjI/BcetsiCwxMuEEuVRMwurIKQNvlOHLFdNg2xklWYuYm3gB6mgPEfbHyHH1UO1op8X7xOllrurppkh4UUN89ryj9J8U8Z0h/1AoefCsngnrdSWLl6D/+sKFTjJ2ehLvVLar+IS4HF6ouqD5GUDjrXBABPIwkNYazSfAG22TfVvY7emXAgxKuvEC41eL6uGHJ76IbUvTxYbuwGdtpxf+bQm3t7uSp+8dC1ZKoRcKDVIq1a084JE3CdYO9i7fBGVIEmmO3KHfN6b40fMpWdJHl3MizAztk6KFqJaBNmw3JoWpzsVSaHPtdlXExEJIHgKAYZXvc2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 arch/arm64/mm/ptdump.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 5a76c59b5ada..17c4de4b9b3e 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -18,6 +18,7 @@
 #include <linux/ptdump.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
+#include <linux/numa_kernel_replication.h>
 
 #include <asm/fixmap.h>
 #include <asm/kasan.h>
@@ -328,7 +329,7 @@ static struct ptdump_info kernel_ptdump_info __ro_after_init = {
 	.mm		= &init_mm,
 };
 
-bool ptdump_check_wx(void)
+static bool ptdump_check_wx_pgd(struct mm_struct *mm, pgd_t *pgd)
 {
 	struct ptdump_pg_state st = {
 		.seq = NULL,
@@ -353,7 +354,7 @@ bool ptdump_check_wx(void)
 		}
 	};
 
-	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
+	ptdump_walk_pgd(&st.ptdump, mm, pgd);
 
 	if (st.wx_pages || st.uxn_pages) {
 		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found, %lu non-UXN pages found\n",
@@ -367,6 +368,25 @@ bool ptdump_check_wx(void)
 	}
 }
 
+
+#ifdef CONFIG_KERNEL_REPLICATION
+bool ptdump_check_wx(void)
+{
+	bool res = false;
+	int nid;
+
+	for_each_memory_node(nid)
+		res |= ptdump_check_wx_pgd(&init_mm, per_node_pgd(&init_mm, nid));
+
+	return res;
+}
+#else
+bool ptdump_check_wx(void)
+{
+	return ptdump_check_wx_pgd(&init_mm, init_mm->pgd);
+}
+#endif
+
 static int __init ptdump_init(void)
 {
 	u64 page_offset = _PAGE_OFFSET(vabits_actual);
-- 
2.34.1


