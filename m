Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD8BC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC6E6B00A1; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51DF56B00A4; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE286B00A2; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17F9E6B00A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7B241A0456
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:37 +0000 (UTC)
X-FDA: 85216340874.21.9707D1B
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0827B80006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=SqjFaPkF;
	spf=pass (imf30.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LN634Sdp2f5j/tm34FDy8iveeBNcOZ65RfXwsn4p7Yw=;
	b=lQEHcsrbaxpIKWb9iJ8rBbSsjYRTrreTsDvnGhb5+SGxKrRepy0heGnJOzsBTB13/Poeap
	HxvgegGZ9qqg6/MHfLh1C1bELHguLXi/lCU02FHze9C5E2qen0Z/8OYnanr0T9iX0JwMh7
	yRVsQE5PdGQ19tWwVnWnVYnJFperZSE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485216;
	b=sjm3exCfgWvU2A1rmXv1jqXMU/FVeM9yLZND+fHzRHgOs7AvKua3e5Sg6n+g3h0b3MmEWk
	57NuiRDLtIL09ggK2F5QNZnlfU+XTXa95I365cv0ZktjFJo0xYZ0yNsyI9swcsP9tGTdYz
	JtU+M7L2eJCRh598vpNT1Dvtn7Maq4c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=SqjFaPkF;
	spf=pass (imf30.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=LN
	634Sdp2f5j/tm34FDy8iveeBNcOZ65RfXwsn4p7Yw=; b=SqjFaPkFYTMDJNibYg
	hXYfjeldUrGC23cll4q+TgLF4nd+90grhHmxL4KJcpEwlSkSyX73DlBcvrqaqBAo
	iNdoZGhCGj+KIFdPNsekyirEqtePchWjkNcXDXyu262u4ViM7cFgcMQ3o4kWqEoj
	KUnsO8H/Ev+OWg39BTx/XX8dI=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S3;
	Tue, 15 Sep 2026 23:13:20 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] mm/ksm: constify ksm_next_page_ops
Date: Tue, 15 Sep 2026 23:12:15 +0800
Message-ID: <20260915151236.5200-2-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw18urW5uF1UZw47tw48Crg_yoW3Xrg_Aw
	12yw4xGrZYkrZayr45ur17tryIg348Gr4DGw1Ivwn8t348t3Z5CF4DGFn7Xr929w4j9r95
	CwnavryYkF4kujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1dWFUUUUUU==
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3BBBOmqpYJCaXAAA3C
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0827B80006
X-Stat-Signature: tk63r7wha75dzsx1x8twu5bfo1yaq93o
X-Rspam-User: 
X-HE-Tag: 1789485213-569305
X-HE-Meta: U2FsdGVkX1/zS/tHTq476sWC1U9aZJX20TIbH61MU2lE2IvmQltPVd516T+FU+kLLB9GYyMlFzbRegYohoAmLiXury9CltIq0n+KuOEHTs6hru1N6XalYanCPNuhvt4Dhe7qoaq8qQsqVA5JTF+KYfpfSPYawx2Z9ODka3tX72RmvRM7cIAPZ8EgG3zK2sH4slSTw4H6bx8RCvMNhYlc1JmRIYZapwfM/lG+0ViK7xj61vSBnM7j7vmyugQACwir6GbHsB2fOt8m4aM1JXoRPgGjMjk3DQnMNbvZnAdHiJAl8ndyctO5L0Vcli8Z+DF7DyDwAeuyCHZZ9aapQLLc1F0lOzLCpe+dGGbjwaK2b94pXNy3Hy7h9FZJC14a4lDKunh1td6MTBPgGX+dRgVJP4F64xUbubXSepsXNXFx3UwI5BsLaYHlfTjTpHyUZX5S+8W1BYrkd/rGJtYcy+SThN4uLWHigMTzR6DN9lqQsKsxJfkzB4rkBPgM/haABSqdAorWwYdfC7G9egV3WruX/apE7r75Q53yaDou3QwHmX8G1j5fd8AG5qbyk+viwoLR9MQ8s3Hd9SC0zSWjzdYm9RmwA348u6ZwMHEsxIoHuW0OQB8dxAmrRQ05xeQsfolzhqeo9TAZHdS5mHcMHHzFOXktJR8ovvoGJONClhIYRKFdSb9izXb4ZVHyIDuunaITCwpA9gQYIPQiuDdajuOlwBTC/WgFKsXoV55270ByM1Ct95CUQbiWgLe/J1BJQf+xw5GV0ZqXvt1iYTvJIZ6qqxstjHVOi7y7omgBxjDTedMcSYnAaiS2B4SSOOybxRumTRGfER01tZdxeggEdA5xyVo5TYgMQcTmTI3mKGPlq4IdpJ59I40g2Mzj3DE/STYAIEGPwJ5HGgf5S6fjky6hNN4HPl8AEApfcK1d9wHDOHm4YPtnFRYaqjpyEMMLD8ogiOwONLwAUh5+FM3q/Df
 sF/AF3iz
 kuhrmY2IWJ8J6I7GvZDxqLEWalP9p9Cw0+YNoq9/XrrdaXZBoVRF3x43m9J/dG33iRLeikoNWyiU4gEqo66SVSWH+3VyIUH14F8sAbCV3qBSkktrL123h6LqQslQ1yNr7tY7dTz3TIdGNAU7MUQU3Sk43oVujV53fX6QP1Qw+j5041B2rlAWoo4Xk1YwJEXVsVvWYTJVmE/wB3zb0pJJHjpwTFHU/gvxwKfIXRm9C4+7zZ+xQ6exqOv7p3JIsfRpgjaE1KXu9PlAw65KwqPhIrnl6a1Vd3EMfWkOJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

ksm_next_page_ops is never modified. Mark it const so it can reside in
read-only memory.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..f637f3baea69 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2603,7 +2603,7 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 	return 1;
 }
 
-static struct mm_walk_ops ksm_next_page_ops = {
+static const struct mm_walk_ops ksm_next_page_ops = {
 	.pmd_entry = ksm_next_page_pmd_entry,
 	.walk_lock = PGWALK_RDLOCK,
 };
-- 
2.43.0


