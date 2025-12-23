Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E5AE6F070
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 09:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6D6F6B0005; Tue, 23 Dec 2025 04:26:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1B806B0089; Tue, 23 Dec 2025 04:26:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A275B6B008A; Tue, 23 Dec 2025 04:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9956B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:26:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 216D960513
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:26:03 +0000 (UTC)
X-FDA: 84250204206.21.CA6DB60
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2FD28A000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:25:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EeWtkoTB;
	spf=pass (imf25.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766481961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZK8R8OMQQPBM9Sk2yhDwBWgXjBTzZb4hyFfIAYWogfw=;
	b=5hDvjjE+BFo0oOGOUOqazXVYB4zfi4DfEFEuiN1e0czKmUPZ6cC8f0mTcJiRhZS/Bik0gz
	3goRrLMPUz1VE0J6D1QftT1hpkeYS4YHWekoys3mvEukx2ZO3L88kW7vWq07Ig565yWSrm
	0KJhB7HZyl5oY69KTHi4tduVmiuqykc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=EeWtkoTB;
	spf=pass (imf25.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766481961; a=rsa-sha256;
	cv=none;
	b=0UYTlNSjDrJbN+ns75XH33ni0cik/R2Zes43d8Hry2unwBmWPY3bzYxvz57MSTjQciYnxM
	6kSh3zvZ9/OWH6mgAhp2bhQTwETKRpFi7flScdb/68I15Y6XNtbHDxihv/bwDopXmFD+RX
	/wp69yrwwhORLEAg9MBUNNT8Yz8YJsc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ZK
	8R8OMQQPBM9Sk2yhDwBWgXjBTzZb4hyFfIAYWogfw=; b=EeWtkoTBb7MspO+ZjJ
	o41GPtbDaOJb5wvH+RTUaEVPT2oJLie+GJs3pzW+7u7iDfPhCRZkvR9WTJg6ZIHL
	cIbwZYwqoH89ml+dy2E5kfF7zQ+WdpqIW+fSDPRqjCC1DHAONwkka2aeocvaLaHN
	6nwSkpGX1Bf7fWHeAwxw4X3II=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgB3S+YIYEpprVv2Ig--.130S2;
	Tue, 23 Dec 2025 17:25:31 +0800 (CST)
From: ranxiaokai627@163.com
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	david@kernel.org,
	luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH] mm/page_owner: fix prematurely released rcu_read_lock()
Date: Tue, 23 Dec 2025 09:25:26 +0000
Message-ID: <20251223092526.140566-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgB3S+YIYEpprVv2Ig--.130S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxWw4kuF15Xw18tw4xGr4kWFg_yoW5AFWfpa
	42k3srG3WUJ3W3X347Wr4vkr15AFn5tr40yFy7K3yjqa12ywnxtryjga4DZry5KryUXrs5
	Jrs5ZF1qvFn8JFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRHv3UUUUUU=
X-Originating-IP: [117.176.243.82]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxgsHU2lKYAtXOAAA3+
X-Stat-Signature: cp4awjedre57xtig3fgnqary4bktgs8a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2FD28A000C
X-HE-Tag: 1766481959-666342
X-HE-Meta: U2FsdGVkX1/L4b2FuLfPcM7yWvEd4TykUZk9XtgaGioKoSgLPZfJby9x/nAY03Oeqh0w+5lgnUeIczFXL317dAIJADT2XNgr9yJ5aICRFaEBrkUNVN8BN3axga9cnoXB3WOHcmRiZHAbbLnMGnNjkTUAl+1AjMiU+l0NAUHmktH0VUvbsW/J0JWCtopIBJNVfuYngx/bCwEmUtH/xdzUkrS8qqC0uRJH9bp5QhYL8aGzeN8EttPlcJM1u4dNytGgKZGvBzvBsLvnxL9Tj7DuTtb88rhtHPXSTQ1iFDd1a5a/BZR7LDERJ5wabXwoFt0dSNckPfBFF6+MwhEttQcB3zULDefvRaCFC00ZsVY6QPOPw3zt3PQHLIZUVsJ84kWQDVGg5qZxrO83eQR1X8hFzncKPUNpgP4dQgIasZcOBsSqf61+FTATKdWvn3uAHY6rj47gF4BSYwYUxy04Uqbaeia+yR30lQCO+1aSL18dGvbA8sI4OkGD+RaHNEAqxafv4eogj2jzwPShu6pV5IeJTRp0ltuUQN07EjpDXJ+6LvA5R11QaefAizKBFTU7MbpdJ2tEOzzsjyyUAwUF9TKIp8+6z7dgglK8AKlXJlsZ1OgnBosrKo0GEfkOPQe4b9egL+YKNWI84wLEfPMcx57eLY5P0b7eWOfQ68uLrGeQteMQ97VhBoDrcJCx3tr4R+vpfyv/kkM+rRq9eA5RBGdIYyhfdWFZzY06Kkxr6MD4MK9MwyiFaeXsVT2WjrecGsC0eAu4YKbEMDZcPpDF4rVbmI+EaRmTF5XDTPWSyHevozz12OBOsd05LaNoVhHhax+3FCHAm7M2lTY83N0ZWtMwXwkzg9mYAtXp+qTQYbW4w+22fQt4zQG/LLRvhXeRf3LQ+pdK7uT2nkC0lI9v1zTbkGCx2dzirFC3N6zq/OaQRjxBqOyZAz9g+iUw/Q/U7MVpqDtnkelINwpd8TuxZHk
 JecyXMaD
 +Gc5z60+FZOzOZF6OVCFwmSPvWCvmGmdZCALR3iDfr39Vh5iYw+AQxK37bkGIxBR+0SRmOpO8DlF8Dc3ZuV7JfmEGIROhpJtFrFeoqDs0u0iLqLVkvwJmumxl66aVGJwf6NMtTv0BR2cDnIaA1bTwmJRgPTG9fKRE1+IS8xDDr/aPt5iSVlc46pytTfeSqVtXTJt8UVLXl5hSKbppz+X/Ed5lCJo5fEUa2lb8Zs721QcVZhNqdVgqgsDZrdXv0IO/g/YxnDB1NDMUgRJuYmJK9gYx9qafCcFmu3O/DCocaQiuwLiICgRJPY8DTj+9KXXNaaOJHD3jLGg59mBFAdVKwp+PLTzXzIyJVbwPuMEOB+D+remvx16lfZGl1sBIZ7kUssooArLLMl9+hDlZZVVeepCXMKP/uP13CSkOVpOSCIdWxB4nowsjV5Tp8rCWeCdyyT8N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

In CONFIG_SPARSEMEM systems, page_ext uses RCU to synchronize with
memory hotplug operations, ensuring page_ext memory won't be freed
due to MEM_OFFLINE during page_ext data access.

Since page_owner is part of page_ext, rcu_read_lock() must be held
continuously throughout the entire page_owner access period and
should not be released midway. Otherwise, it may cause the
use-after-free issue. The sequence is like this:

CPU0                                        CPU1
__folio_copy_owner():                       MEM_OFFLINE:
page_ext = page_ext_get(&old->page);
old_page_owner = ...
page_ext_put(page_ext);

page_ext = page_ext_get(&newfolio->page);
new_page_owner = ...
page_ext_put(page_ext);
                                            __invalidate_page_ext(pfn);
                                            synchronize_rcu();
                                            __free_page_ext(pfn);
old_page_owner->pid
new_page_owner->order   ---> access to freed area

Fixes: 3a812bed3d32a ("mm: page_owner: use new iteration API")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/page_owner.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index b6a394a130ec..5d6860e54be7 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -375,24 +375,25 @@ void __split_page_owner(struct page *page, int old_order, int new_order)
 void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 {
 	struct page_ext *page_ext;
+	struct page_ext *old_page_ext, *new_page_ext;
 	struct page_ext_iter iter;
 	struct page_owner *old_page_owner;
 	struct page_owner *new_page_owner;
 	depot_stack_handle_t migrate_handle;
 
-	page_ext = page_ext_get(&old->page);
-	if (unlikely(!page_ext))
+	old_page_ext = page_ext_get(&old->page);
+	if (unlikely(!old_page_ext))
 		return;
 
-	old_page_owner = get_page_owner(page_ext);
-	page_ext_put(page_ext);
+	old_page_owner = get_page_owner(old_page_ext);
 
-	page_ext = page_ext_get(&newfolio->page);
-	if (unlikely(!page_ext))
+	new_page_ext = page_ext_get(&newfolio->page);
+	if (unlikely(!new_page_ext)) {
+		page_ext_put(old_page_ext);
 		return;
+	}
 
-	new_page_owner = get_page_owner(page_ext);
-	page_ext_put(page_ext);
+	new_page_owner = get_page_owner(new_page_ext);
 
 	migrate_handle = new_page_owner->handle;
 	__update_page_owner_handle(&newfolio->page, old_page_owner->handle,
@@ -414,12 +415,12 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 	 * for the new one and the old folio otherwise there will be an imbalance
 	 * when subtracting those pages from the stack.
 	 */
-	rcu_read_lock();
 	for_each_page_ext(&old->page, 1 << new_page_owner->order, page_ext, iter) {
 		old_page_owner = get_page_owner(page_ext);
 		old_page_owner->handle = migrate_handle;
 	}
-	rcu_read_unlock();
+	page_ext_put(new_page_ext);
+	page_ext_put(old_page_ext);
 }
 
 void pagetypeinfo_showmixedcount_print(struct seq_file *m,
-- 
2.25.1



