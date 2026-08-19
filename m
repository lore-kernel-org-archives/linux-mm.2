Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1EEC5DF82
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09F16B008A; Tue, 18 Aug 2026 23:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1826B0093; Tue, 18 Aug 2026 23:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8166B0095; Tue, 18 Aug 2026 23:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4C06B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:28:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B3DB1203FC
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:28:33 +0000 (UTC)
X-FDA: 85116586506.01.83CBDC7
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf06.hostedemail.com (Postfix) with ESMTP id 849D9180005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:28:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xrXl5P7j;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of yeweihua4@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yeweihua4@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787110111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0jydxGS5WCPWvJUv51lmeG0PkjZ1+rQ9tEAfOH2XdXU=;
	b=at1rfbSXh8PfblStqvCNlAzJrv95GPqqyVLz1U6dpog0zt41gF4UCj6b+E509nkgYXP3Tw
	oggX/TXkMpmjRl8V2bQlCE4EWUbsSycm4/NaNHcGUbODCBSjbKzd0MTL/zOVN5iNg1f6zA
	vOX4YMFxj160TohO1UqFDP5ko4Svbfc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xrXl5P7j;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of yeweihua4@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yeweihua4@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787110111;
	b=FMnafIGTjOwjzjs223GnLYNeyvWCG+I/aVkduoslJAz3W1tXh07uAzxYx9q7TN6l+7riC6
	v8tE9hpa+qAUvcI6sl117wAjhBuSgINZWfk2l2T6idSS9Fu4G0VucFmeKrDw1PGoC6hhCz
	77xRcglRN+7RCVNKFmZia3Lhsnu5gg4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0jydxGS5WCPWvJUv51lmeG0PkjZ1+rQ9tEAfOH2XdXU=;
	b=xrXl5P7j+f1zlSYYiXHysQeGpOqo939tAhci0d9j5P52tDI4YydnwHrO+0KKThlol3L7pipxD
	nv/QTMKB841qUfxeyb1i0P99NcbF/RJx42irlx9WEsbQY9uFxUGcwtbl4Nqj2ASsEypDc9MotLE
	kiazCMO8xQjDHcKCjzfE5Rg=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hPsFk1GkvzRhVP;
	Wed, 19 Aug 2026 11:17:46 +0800 (CST)
Received: from whupemo500017.china.huawei.com (unknown [7.152.184.243])
	by mail.maildlp.com (Postfix) with ESMTPS id 7882840579;
	Wed, 19 Aug 2026 11:28:25 +0800 (CST)
Received: from huawei.com (10.67.174.49) by whupemo500017.china.huawei.com
 (7.152.184.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 19 Aug
 2026 11:28:24 +0800
From: Ye Weihua <yeweihua4@huawei.com>
To: <gregkh@linuxfoundation.org>, <brauner@kernel.org>, <kees@kernel.org>
CC: <cve@kernel.org>, <linux-mm@kvack.org>, <yeweihua4@huawei.com>
Subject: [PATCH] CVE-2026-74484: Fix introducing commit via .vulnerable
Date: Wed, 19 Aug 2026 03:01:03 +0000
Message-ID: <20260819030103.422702-1-yeweihua4@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.174.49]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemo500017.china.huawei.com (7.152.184.243)
X-Stat-Signature: uh1zwf63oo1tbxbpi6mhowhk4c7phgnn
X-Rspamd-Queue-Id: 849D9180005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787110110-166400
X-HE-Meta: U2FsdGVkX1+pMsAiZCVCBOApxmWWepGlepkYWzopSVEQYF8il+0b01QZadO9RsH92rIi/vu6diXfIFgO9VB8Lss/6rfoZTubh4A0jiuIO+p0ub4qJiJOe9EK8uOKEIceoVe2EVIa6/k9ITD9iUd+KabLyD3o54iuM9LXNEEP34sOj0bqUfTJjBkWhTiuVrxjQppwPIGy4zVnGY2iQTgr/K4LTHqh32d+6SZkV7g3E/nbseemoyxbr7WLns2opLOcBlMPLekmJrgFyaoQIBpSP8pjB6Wh5KGgUsQPJEEYFO00CLNwErfUBiim5GsiUxsVmYkS/gtYy3WyknWu1eQIlElaalOTcfpk1rhzqzeSB4vCKb3QTbkAOfGQ4Py3X7pd+xgvx3vWntGN1GIgZL35+J55tWGaYZEpGzD0a/8ObQGV3kTd04RR1wueYYCCnLxfwO3hL8RWovvgn9ULb0ru5gDgMmOUtZLscNJVPmhCZ77wnqvXYBZZ+EQGDzJnUzPZnN507RdPTFTJKIZYwwrUB34E6wDrhL9kprDD0qF3q6PR7HtphZtol65uF27rNBjk0gCFAIkZVbs+NM7TfSr2nyH9KHVKz3rCo/NOwnY7ajD+p9IoEAr4kDeLUS5VyuZO1C4FDeGVpAI+6cY3WOgmU0gvkFJszbYl3wdsnD+Atuir3ruMI42Wa6kFo88qvgvAeVgfW5FVg7JoEZ24ivhwYI4cH/U76Q4XWOCaL7DewNKlZXivWzB9g/GDQhJ6TvU9PEJYzJnq8CDb8PTvvyVnVuIeNCv99q+neF1Y60lD60NecTywBh2oDJkV0WVA4BZAPQBThSguaWjShXz0paYgmltjBrqO0CeZEmwQ8VYjmezm1R9bA2jSDESZB7B1PjJslDGn5UYuhA/1Nhnt9Bg0/n6nvzfwZ1UTuDfXOULI3dnhNNCLkxNzQG8KY8e1txCBA6U9cSpCavnyI6z1Lgx
 YugEFmfY
 +YBOAYd2b/E0/4m9sJXwS4W0v6amT0jHvULMZsHJ+RUjTmR5YY38RNGNVc847XTEeyAblD42WrdnOVtfFnfhBas4JTWN20URKHMijf8uzA7HSfWa7FLiayQM7IP4PAq+a9AJ3ALjTGgjF+pF9d4QJ+wvjkIIA8g5BkFJG2pQVUkA2GAG3r6PtBgG9h2ZQAeFPmlYe2qv8XuWfK42iqS3UoHA4bm1/KJTADNAUNYoNQr91rzx7dEAZ8v+Fa1XKeNj+bSnLvY4AhfJehBrYay9b+MrlsCpK9ZkB4VSY1kV0uZGdXNoDpCi0VJY+cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The introduced tag of CVE-2026-74484 is 21ca59b365c0
("binfmt_misc: enable sandboxed mounts", v6.7), not 948b701a607f,
because before sandboxed mounts an unprivileged user or container cannot
trigger the self-referential DoS in a restricted namespace.

Signed-off-by: Ye Weihua <yeweihua4@huawei.com>
---
 cve/published/2026/CVE-2026-74484.vulnerable | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 cve/published/2026/CVE-2026-74484.vulnerable

diff --git a/cve/published/2026/CVE-2026-74484.vulnerable b/cve/published/2026/CVE-2026-74484.vulnerable
new file mode 100644
index 000000000..39fb39f38
--- /dev/null
+++ b/cve/published/2026/CVE-2026-74484.vulnerable
@@ -0,0 +1 @@
+21ca59b365c091d583f36ac753eaa8baf947be6f
-- 
2.34.1


