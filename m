Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80493606A334
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ITSh4BjZ
Received: by kanga.kvack.org (Postfix)
	id A50AE6B05DE; Mon,  9 Nov 2026 00:57:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB8A6B05DF; Mon,  9 Nov 2026 00:57:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937E56B05E0; Mon,  9 Nov 2026 00:57:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1D06B05DE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:57:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3C6EC05B6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:46 +0000 (UTC)
X-FDA: 85414524132.19.5CB9C3F
Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	by imf12.hostedemail.com (Postfix) with ESMTP id 154FC40006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ITSh4BjZ;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebB8Hm9YJhqZLTIB/BIU80u2OvfAEgQxHB5v4VkTido=;
	b=u8xStN2w+jheFSGJWgTD/NWqBEWrledBPo0SvISH0LIwBQIqQ8eMeiRHclGD3t6MZrIMkW
	pA3B0sVUm5myArH8t7bdKjwOG6/Pn09Ba2Ma6todZ3IeaCuhJJOoHM5Aw8p/xZshiz4+x/
	CwXMnD/W0CUJgFAhlFuTXJ4+7NBRZz4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203865;
	b=pfHA1aEDtZw37Ez+eeQB7m+ayRc0E14MNmwj2FPsbSTMCbe9YMrrOR7lXZFO3zGcujU8C7
	2hHDRBp9vE/DmSBXghh8bwW8Qd8H5//cDTYGjmQXMsdtGos3mhvBoEF17WQJqkb3Ko5YOf
	Ogr+X8spj9FY10bAmnyCbT9HsJkHxss=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ITSh4BjZ;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZTeW0ziV8/P/g9Y3o2HU3l2GCGlpCYxshzszGc/a3ck=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203863; v=1; x=1794808663;
 b=ITSh4BjZZSuTXFFlpt+NaWm8E8akqoztRa1SQh93VFJQaGTU9vGGyTXp2ywBWMIzooNC8buM
 4vs4ZadBTkhm2Pm8wOowr2iJIrbrne5Zx77MK/CyB+Wp8vkGFT2MWhW1NnpRqJbFO7QpDV3qDRV
 7LC8fHWUn7t/KC19+9BYyNMQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 80b09a951c8e8f3b;
	Mon, 09 Nov 2026 05:57:43 +0000
X-Mizu-Trace-ID: 80b09a951c8e8f3b
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 19/19] mm, swap: skip the overcommit probe when removing xswap
Date: Mon,  9 Nov 2026 13:54:55 +0800
Message-ID: <20261109055455.536925-20-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: tpqq8hnecez7a8tw5tf6jc1mf8hk3u9h
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 154FC40006
X-Rspam-User: 
X-HE-Tag: 1794203864-128251
X-HE-Meta: U2FsdGVkX18pYXK2TBHkcgD6KJxQRqnI7R0W34z+kjpmMsXkZVx5X4+6rRaVPn57TnqOw5WT7OpV1uOUCLnRuS/c3cRR16sEziYey1imd72mfF/2P9PqwpQFnF32WfHufNJqmfUpCNB26mTSd49pV1YeyB/TZJDqWcS+bztQFjGppSMUU8C5V2iS9b5HcDmZ26GwVZaZGdaI5SnPT+HFv/gXVtKRl1ocPqAAbToFEjn4HbAZvedq3DAC3SWXaf6SGcRjRnGJRP2yKXzzCA7hhm3inJcdrShOuXbkjc1n4NJK7gFBNz1pzrW4YyO0fisVkKDvAp1t4TyxdOLjDZECh2DjQyktvx5ERp2k3InMxZach0fH1pL5Wy5f+GmbGf773LKum73YndxZrNw7Zsfu6t3+OZ+Np29cyHAb9QGx+Rhh+ILBvGXGdiY2D1dQNY3GjIaOUjMCoP9VFcqfiknZH0Ir9ATjUW4rRh8VkDcSNVb/4Azi/6Ocdh4g/JRqS4N6N07EFs33JdWDp1YJeQHarFUOszmeKHmWzlQI+e7pPhXA45QrQlk1RylwqA+/ccJcF3IT72NAUHJ/h3nKwv1vDToS6uL7CuXvKCL+es8GklAR2vF/0atptw7zW6n6PoAWRhl9jpnTjjO/VQgfADEUDFpeiP8jpFazZ3zvY/q250Jy6ZibBANmvE2wCQb3SHi61SxOYDCsdy5BTO+kRBWiiBEjL0wG+HoZDEfmTRmQK5SSHRzQ39tSfNqOsg7Jd/Ivz1hMAXnOMy3YccJsePcsQCGt4xxSrfT1W3J3o//qkyoW3EyS8jnStsRH9ypdRieI5qk9WwCW6AYETCUlVhOcH1s4q0H/qt3n1y789ZXjCREpvUizr/MwGD39epQtLqVOoSzjMsSZugnimDN6nh0iRTF5IaYTTombMgFQMkilcl4JTWSdoyBU76Gq7np4K2+4yMIUXixpUq2vxz2MKYa
 /TPoZgdi
 D49/sn9WbQ2+bKH4wnsAmhcyRyAyYIMVG/3qRgoUvxuIeEm5Z7fWAySnHKNoaj+RSrluHyNpi5GpYT7x8cwq/JaJWIJSQiEvJJRf+Y4UEG3H7+tPr+roOBlyP+ukd+5AfkGWFJDAGn1cXtscvaHSg9T0BQVF69oPnwBUGgPTyXNdfLf+S1MoGcMrVKZ/DbZ9kNKZT//Urwmo2sZz1vOycVGTQO4YMZjJDX49TrIBNDA5DMlA7X/hgJNfg+O/phxoMHUDsR3YlYp1V2g1fi39pUgztnh7Gwrrdo/pMthqBgKHLWzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

swap_info_remove() probes whether Committed_AS still fits under the
commit limit left after the device's pages are subtracted. An xswap
device's pages are its address space, not backing storage, but they
raised the commit limit at creation. A workload can commit into that
headroom, after which the probe refuses to destroy the device.

Skip the probe for xswap until the overcommit accounting for it is
settled. Real swap devices keep the existing protection.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index efb48ef71611..84b9a8dddff2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3736,10 +3736,17 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
  */
 static int swap_info_remove(struct swap_info_struct *p)
 {
-	if (!security_vm_enough_memory_mm(current->mm, p->pages))
-		vm_unacct_memory(p->pages);
-	else
-		return -ENOMEM;
+	/*
+	 * The device's pages are its address space, not backing storage.
+	 * The commit limit it added may have been committed against, so
+	 * skip the probe until the limit stops counting that space.
+	 */
+	if (!(p->flags & SWP_XSWAP)) {
+		if (!security_vm_enough_memory_mm(current->mm, p->pages))
+			vm_unacct_memory(p->pages);
+		else
+			return -ENOMEM;
+	}
 
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
-- 
2.54.0


