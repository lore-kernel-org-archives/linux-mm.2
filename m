Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6347C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FB56B008C; Fri, 11 Sep 2026 04:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFFC6B00B8; Fri, 11 Sep 2026 04:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13706B00B9; Fri, 11 Sep 2026 04:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92ACA6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:07:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24BA5140137
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:07:39 +0000 (UTC)
X-FDA: 85200752238.15.DD9E106
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf20.hostedemail.com (Postfix) with ESMTP id 01F441C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:07:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf20.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789114056;
	b=xXM8i/zn2M739/q6XlrMqJ2tw2dEyk496EmoJ7ZtOHJ5O/KtZa/I5OL6Z49q1ys8c/tEJl
	Q3krHsrb+CDSIRuWanub1ZMMWzV4qRBWPPNSfrMEIxySRvqUNDbMWeMFzV/BLbhYIbLvu2
	b5P2Dg9wikSPCPrs/oATLRsOHIMoCxo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf20.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789114056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4NFiyeWr87O9g+NuWRLRfjJKlqAK3AiFV4ya6lu72w=;
	b=R5CN5u/ztDGyHDffn/w3J47Mv37XsvPWiRmrsKOh/FAW3R8i7F79iB9LcLdqGQGWgiKftI
	rnAsap6thKWt9B3NoJbVLB4GbieeTXoEd7NEek1hdYbc/xT5dZMmrntIFYvcrkrXV5QUPt
	oge0FaePEf7OQauGT+1Ed6lHg8oOW6g=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hh6bT5KV0z8Xrrd;
	Fri, 11 Sep 2026 16:07:33 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 68B87Ng4028463;
	Fri, 11 Sep 2026 16:07:23 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 11 Sep 2026 16:07:25 +0800 (CST)
X-Zmail-TransId: 2af96aa3b6bd609-b95f5
X-Mailer: Zmail v1.0
Message-ID: <20260911160725440VlRXkblhz6f7GJgQfbVv3@zte.com.cn>
In-Reply-To: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn
Date: Fri, 11 Sep 2026 16:07:25 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <surenb@google.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDEvNF0gbW0vcGFnZXdhbGs6IGRlbGV0ZSB0aGUgdW51c2VkIG1lbWJlcg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 68B87Ng4028463
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 11 Sep 2026 16:07:33 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA3B6C5.001/4hh6bT5KV0z8Xrrd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 01F441C0003
X-Stat-Signature: ks7dig4qxaxyfhxd6yzyctax77ejx4su
X-HE-Tag: 1789114055-509374
X-HE-Meta: U2FsdGVkX19yXmsDF2N/hmrxwRJm/35+vi4xHVVDAcSxjik9yZra2rFPknwj+YzQzR3kZD5napNu1T8W2DeiL81FPAtDdb+C+2/iOI9J8GmeHlj3nAOiJCxNVML9g4pae7qK1oFnF0yMWvH/h2qQqXE5ioebW5Hb+AX9YL/x3CiQGKQ23caEnd43r51feSDxmrtG6c48IIpFS9ikoFwo+ISWji3NQw7knqfRY/H8OGluiuAXY7HNb3K8jcXkgVup+tpM8QDGULsnf6VJbbViELirkx20gj0Lv1CHiG7eVbUg+BvJscMlvqm5UYAPO3lhNfJ8PHAFZL9T3FTxQeRb+qdrOhkJLOzwnTshtZ2Kcc+d8hPhzGUvP8pq4+a3HtO9UsA60baqfabor5K8EAR2Nq1pvK0jY9tP2nH9XZqV/iVLw9vCSF/Q7zYS35n8AYse7yXDWWjSvvZK4sb9MnFyj2hPYQrkiONwQvN9pDHh4yTXYulZcd8GoG4+iMvD+OI6o2Qk8ZyAG0UOgU+Qhnly5sAQ0MCpT83P2CO/xbPmC4RaIloz3fkH2j2DTECHFQhl8+XcNm/rtdRs3jAZb3WAIHmqmqTPqadS9uVGf9lMpzb3LMwHJ4WWr2Sk/YjfL1IP686wldnfOHehrFPDQJ5EpsW6HCzmq1xlZI2l/THbg3N6Yhfp6KjTYXjcNkT0Yw0H51dFlJ49h3HxuLQbI1H3qXqwb3zblIlAognlxRBOOxLxuTLJUWzfwVmN7q7diJxYfvFQyXugs/9s2s1owKls1QApLMNGn48jW9OcXC6f+GTurDsHBnYRxEQx+PpL9nQeHVRfAP6E8Yv0/oEBAEgqJxIFlavblUqnUpqufrJAEJV5eoMcdR/NVI+eEfuCyQfS8zqG389ayFN39Az02X9kLJlbkGlkndYsBjF8mMxEtAX3segFGmmU/3wtd66VSdUBrZuQbytOR26Sfivn6UO
 WRa+2Ocp
 PN2i+Zg8DodeGXwR8447vBKi4eikkx9ePCWkYjFuu1Tr2N9uKRGFEJayuqVOJD86Oar4DAbIMLc2qHMF47ZtvhqEkAMxt+oLMTLnRmPIEN2WMnfsQ/AlwnFZVf25LWV+kOcp+Kbx3ktuU7LVMKvUhisyXsLZ0BgvFi63I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xu Xin (ZTE) <xu.xin@linux.dev>

The member vma has never been used, we should delete it

Fixes: aa39ca6940f1a ("mm/pagewalk: introduce folio_walk_start() + folio_walk_end()")
Signed-off-by: Xu Xin (ZTE) <xu.xin@linux.dev>
---
 include/linux/pagewalk.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01b..1c397be0d092 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -183,7 +183,6 @@ struct folio_walk {
 		pmd_t pmd;
 	};
 	/* private */
-	struct vm_area_struct *vma;
 	spinlock_t *ptl;
 };

-- 
2.25.1

