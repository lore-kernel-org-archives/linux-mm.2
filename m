Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F347C88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5FE6B00A2; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A826B00A5; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D056B00A2; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1726B00A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3A86120457
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:37 +0000 (UTC)
X-FDA: 85216340874.06.47E8FB8
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf24.hostedemail.com (Postfix) with ESMTP id E95FB180005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GkJqEp1X;
	spf=pass (imf24.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485216;
	b=wyUbNZFoiBts3x7Eb25CPl0FLbIgZT3GZuLb6aNomr9RSieKGNtUl62khtLRTEt2b5PBY2
	lcn8cIaHfVpZ/UeZLfA/3QZZL6OAVmF6qm0KLI4QOE0Hn5FWslp+nRx8slLGfRk8gg7nqC
	dm744GPpLFKAQJB/vKV/pNPRYz1e4EY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GkJqEp1X;
	spf=pass (imf24.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6q4gcoe8kuH2QdxsQJ5k7lgZ2jFMRw97/pDg4Zh17sU=;
	b=v9FfxwJK2rbQSZ8WEwzcMRwQY2Vx/H6Z+f2z+sK8P+TS+T9E4AZslYmCXSQVic/fLvR4wR
	Kd83xcbn32ZcfEDDfgvSugAH186aODYiLB6ENTq3alzOK7bATuIO4R4Nl+lTF495A08kC6
	oaYCJA3D6jCCvKGF54y8kWybwRUOHfc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=6q
	4gcoe8kuH2QdxsQJ5k7lgZ2jFMRw97/pDg4Zh17sU=; b=GkJqEp1X+ZfBaBgGDn
	RPBgeZ26L/i+8J+rRKjjITmUjyWUN2moa6jfYEuBjgmHsztV4vzJ5v3+tLV0/M63
	coXPjQCCbvdq4JzFYHKQ3xJ5N4JsPAfFq2ne8Zxq6XZIDpZ/yu4LomVDh2cnnurz
	IxCrmXER2l3dxuTdJV/cmdeAM=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S5;
	Tue, 15 Sep 2026 23:13:20 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] mm/ksm: use the correct format specifier for max_page_sharing
Date: Tue, 15 Sep 2026 23:12:17 +0800
Message-ID: <20260915151236.5200-4-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S5
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw4DZFWUWF4rKrWrKrWkXrb_yoW3ZrX_Aa
	sFvr1rGw4xKr9I9w409wn3trZ7KayDGr1DWryqvrsIq3yUK3Z5XrWDWrnIvr1q9rWDKr98
	CwnxZ3sFvrZ7WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnG2NtUUUUU==
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xFBOmqpYJFRyAAA32
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E95FB180005
X-Rspam-User: 
X-Stat-Signature: kwu4493eieinmsrjtcoqx4q4mmziuonf
X-HE-Tag: 1789485213-8472
X-HE-Meta: U2FsdGVkX1/Jpuw72FzhU3+IIJKDRP9PvPeSWeBtta6e7OxQfTFy5RQrUYvEnr/BZNGCdTe+67m74yNYfszlKAJDJMZlvjKH5oIaynsGAFna/i3f/F2cpHqAtZpL/pP/hBwzrjfrKk1sPoXM3Jqal9cD3nQaU96VOEYOV551oOEG0y3kNJ2IWlzQBaipBI42zXe0QmqCmO2L3B3UPy11o/LUDW0yn9HbosNFGwameaTDph09ayY/9CnQR/sVxYmLr2XY4o+yFTOcUdbSN6+K+MhuTM144A4M3KBoC/efRhXuuij5PAgQrI3zdvZWrTxbScUzLqG5RLPXybvaZ1Jg/SZuOLvQ3K7r2qPn9q7y8n3QRVx2hakcu1mv6lGeYjhgP+pyoLNSBG5khs+kRBrUvUUqkL5v+oNH1ceXx7q8XF5ghGmjKkIwB00lVXDn8koUuRlqUl40RaVKrTy0uAs4BYkFhX1po4tAXd6j9mDjJet6dVWAuBNZrzlNMSp8sLJ9+z3r1ZY0voKXDzHDs2qRYBb9pUVfX7C6fHTKM7cIC5sFRLTTZ3gGorzkcCnXhduIRfKJ6QBW7FsplNnyLaAlRqAG2CLQP0CA6Gjegk7vtyKOkwquvjD7oGsUgtNX5yEbger/eRRw1RFpSv5JnEdE+mx5S80WKz9wdL0WRo1VTUMsAlSlxlHT60l8OhMOEBw+lJObW+DIoxgQsgib7h/bgPN2EQP8+9MQmrvss8OrBAOCMXBhtISwfyDzkoXynJWdjhQfNwNiWdc1yvbTK30/2EGmnOLuC4nPGnF3k/H4w4dcTx1ZzuAmY3l+UNr7kLS/8TgGk4XY7sODt2sPZDsANovu0ggHM/Pu7uucLk1N3G5SsXvJWlXYwo9g7gJCDj3QjuQnnLtNOWauto1muVbx6VshT+A2292PvCTPZPwHXrHFJyEwbYqJFEQ7mN7kcX3kH+BPRM5gv4rM0QPZE+r
 pblAG1da
 f9PqSj9WBHB4llHL7GC2JjbwDpjBHKht4eIb+hTc5OgnUloW25ubpAanZWSLdxiknZb8p9rQfS83zE6jVFKxiMvvDX51wQ53TVbKS1qo2d+C41zgN4irglH1Qht7rqOVdQzcjBp9/2RySWEkdhZ9reAk+MYeRG+W0XfYhnIaD2ZlLskySbTs/d+pCrev9XoZ9idRUUruykHSt+jQQIkJnblbC7kWALAG5lRWP55+NjnTYPpu3CXD1efCkLyjUUqCFt8pTVojjQC5CPeRLxwkYc5ovHltpI/HpCnmJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Use %d to match the int type of ksm_max_page_sharing. The accepted
values are at least two, so the sysfs output is unchanged.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 1e4d77852fc8..18d037f571d3 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3676,7 +3676,7 @@ KSM_ATTR(use_zero_pages);
 static ssize_t max_page_sharing_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
-	return sysfs_emit(buf, "%u\n", ksm_max_page_sharing);
+	return sysfs_emit(buf, "%d\n", ksm_max_page_sharing);
 }
 
 static ssize_t max_page_sharing_store(struct kobject *kobj,
-- 
2.43.0


