Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68EB3109446B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 10:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC076B00A5; Sat, 21 Mar 2026 06:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BDF6B00A6; Sat, 21 Mar 2026 06:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B346B00A7; Sat, 21 Mar 2026 06:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1C416B00A5
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:59:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 522A51E035
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:59:03 +0000 (UTC)
X-FDA: 84569772966.26.AD35BE2
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	by imf02.hostedemail.com (Postfix) with ESMTP id 937F480003
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:59:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=ay1U9Hwo;
	spf=pass (imf02.hostedemail.com: domain of kexinsun@smail.nju.edu.cn designates 54.204.34.129 as permitted sender) smtp.mailfrom=kexinsun@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774090741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Lfu5egxXROuCMtf548KGAdRsxhaYPc4cJKPPHCWoA9g=;
	b=hnRL5uNH+p3S9Jx80+n+rLhUZUHPjjvgfCfHJ2gDP0Fxay9hnX/kMPmxQ+WZQtOACWFVWB
	68yFm0rqxHx0c4mujk7rWbAPXFhaWSTlR2NbJYiRgUtP4Hc+ebcWpY3K9sWSp+ODHezOUd
	WFfHwdruZKMOUVlYJPnvmcJv5x9TKM8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774090741; a=rsa-sha256;
	cv=none;
	b=08+0QKzNqhOFHHEFQUXvXe8xwqjZAUyr8G76mI97f8TALEC/oh8DNWYcg9AE6MwxehFUPU
	5PE/mpVzXhva5auN0pcUGkhOl3KLG+51SdKiiVD9/MuR7tvt/Zqv2gTTgIJJiVVk8Hfj6w
	otEIgTKgO2lzlD9oVOfsd7zgfVEKPe4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=ay1U9Hwo;
	spf=pass (imf02.hostedemail.com: domain of kexinsun@smail.nju.edu.cn designates 54.204.34.129 as permitted sender) smtp.mailfrom=kexinsun@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1774090706;
	bh=Lfu5egxXROuCMtf548KGAdRsxhaYPc4cJKPPHCWoA9g=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ay1U9Hwo9ecTXsirvLy5ClfpH+t+eJB8SMlPVOzT4XkPgNb3goHh3sNIQUMjMfj2A
	 kXHKhruc3l9KinpKY4yjq9PoQvXdVSqQRwNPpMJ4ENxQP4cnVUB6pG4Itr7btTrUXN
	 NaoXaTRUg2b8mYo99nydZcYefgYdirOvqkMk7d0I=
X-QQ-mid: esmtpsz10t1774090703t218a5446
X-QQ-Originating-IP: thTW8mE8sLjX1v/ZDwz2FKfAN66ysGzmapCIkwcNwpw=
Received: from localhost.localdomain ( [116.172.93.199])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 21 Mar 2026 18:58:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16276077046948655924
EX-QQ-RecipientCnt: 12
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
To: kees@kernel.org,
	tony.luck@intel.com,
	gpiccoli@igalia.com,
	akpm@linux-foundation.org,
	urezki@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: julia.lawall@inria.fr,
	xutong.ma@inria.fr,
	kexinsun@smail.nju.edu.cn,
	yunbolyu@smu.edu.sg,
	ratnadiraw@smu.edu.sg
Subject: [PATCH] mm: vmalloc: update outdated comment for renamed vread()
Date: Sat, 21 Mar 2026 18:58:20 +0800
Message-Id: <20260321105820.7134-1-kexinsun@smail.nju.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: Mh/GLmXKn76Thx9gOgrY0eLTL0+tZRGFTtqExe6GnGt7rlfsB3gLIMo+
	Q63pQfGCMYStj14fTTcMDruW0xMj4YXZPXDHTaDmXdpMALRkHeHxlDYUaTd7JIERLO3CCBs
	10Hpiu6bjWF4bwcIG881H4l/HzT+VUmGHB5zWkEk/mSJdamsiwjSo1Q5Fh0B018LWYRr3DW
	3BrDnlibuDZgMUPVFgiDSWEgmH1t6rrznHShA9iRhL5ueAglkwv+NsrWKqZesLGEgTtXwK5
	iOiSQd8867RRLSqwyqm4XoTRvjpfx/P2fi7p9dqJ6fuQ85uofhzdEaieKXtpY8+sqCSTMu5
	TS/l2sibthVybZL07AxLS2VGPk3ww/4fnRpairlxryk8WcPZfwAm9+3JnD/RFBs7dS3Nuyv
	fQwoT8LEECs4Jc7qnqM6O1YuRKjplQBNygX1kqkhmAuUBHa4eTx5sXYLerVlzZ1gbeT4utH
	Ob3vEBQmcTWne7MGvWu+/wFuC82Hr0775FyyTQG0kXGOcg3cqYyguhUDTtr3j9GLdYH+dpe
	n6IhpYUZYX3Ia7Z98K+rIAaN9IrfJLTj56fQJwpiyjf1RtKah/D/gJ+KK65VKv82cc038l9
	nSx6TtVzW5UzUCi449Kldp5rzZS0gelCZ/AT1oYMkktwe4+WrCTVYBxvnuAO8+6UExyKhDE
	qMy9arixOaUnbJuNQeHQv+0+Dv60vvA33IPeResESWsm1FHlw7E5O2hLMjKbzJp6Cpzbt6d
	VbeEgEvA8ts0/b3T5Gry98uBLuUPKBVvBol6uJtmBKXXN00M8/2F4A7eUOk/UCLFF3JVARn
	7OXk9XlpOGule7ot05anh2nBUZY1ZCXgyVuL8L1rn3jPLH9f70L3ctrVqSBj484/8408/a5
	Jtd+MM6pXvNoxY5b1okwpcCgnjpiHah0Of3XhwqaFApkvrMbFCPpjIRrFLWtLRRraGOQ7zU
	JUr8SlH7dQcjY/mZDt38OYwm18w24dP1pQirgck19NlZRmRr4K6j+Ww+gnjKGrKOihTX9qt
	jKFQiRNIU6CvTmS8MeDA+DYzhNXHTatHB0h1XYd7VDyBUoTw8S7RV8t90ZcHI=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Stat-Signature: 5w7j3rje78acsob3fatjbm5pgde9p5rt
X-Rspamd-Queue-Id: 937F480003
X-Rspamd-Server: rspam03
X-HE-Tag: 1774090740-600677
X-HE-Meta: U2FsdGVkX18VJ4DoQ6SbJSUpWVU5Ypxf7S1ZSfgPtGEVdL3vqyUvdhiTvpSZNHLk1useUEy37e8ln14xYpILah3kgFbarwS/mldI1RAM75Or4T447IBJirfFczbP7uv/CMSmHIc39gxeu/4JatxZuZwVcHP6Y1Yt/qXI88Kt7Po+Y2midslCSBMaU09EKSM5DghzEQMKZOOJyrCCRbp45NsBYgDQD7d2Sv23V9oBsPcEbX5RC7zu639dLEO6Uu7xzgihCxGjHcZ/m0RuUaKv620mT7Qz5shPLjiElX2otPBFJ7c2VnYJJK+aCreYka2nU0k00RZR6IppFxbvkWLatu+bxrdsXmsfYVm7CEhBfrdBaGMc4Iu5TiQxn5SCkkpSI4Xmw+QRHJVI8lmNoN4zynRoraezKWlwSYWwTIlnD7hzYhMzCAAY5j2b/9i4j1H80/oW165qR+/uHNHIDHlFdnFHt4thhAGXYFN3QrXMytqiDDlhPAvyDGKYO1KHYySt4Q4HSvuoD1Kkh1dIv27+KXorT8ZQPVXnH1F/no+A25+6OiLors95NjkOj1c7BCFtAkEe2wOofV4hNXxM9Hb60Kc8FoLCcPbeoDhOhuWULVfmrCYq+9l/J3skRYHmEt/ITbha5AhM9b30CBSY1N17NWngPcJnAoIS1+mlyRCiozLXnkhh52bC/U9y/DTnwb9iLQV8GLFtTESQfBl3e42wUERHwz5tQPQGl4YFPLyh7o3wZv+LQMeim3KgtNLqNA7xvzGEwmM7j+XC0Jz7HYIrFVHBSeJDKD1/jFbHr8E/f0w+18gOhROCkIPvhZc+6C+IpL1im+tfqP0YgT+PUsuD/3j1BeqvclF7NYPuUT9GNZ6CEkaQj0tLi1bFPR352c50lhrBvHEjmOrjn5fb/Gu5iS8tOFknOioUkqoL/vUXHtZEIZCf+/+MCygdd0zpwSLAuzmvsFseaTO8g4Rp5ux
 f58mtmv3
 wm6QER/Ea1/qPOF2ACubGieT1PZacQUccs45983Ajqgz2BwL5xBAHvn4fx6XKFc+GAuyldipdNFafxc13wqwBQjAHcZKf0qTBCZJIYQlM2WtM/xI2V21nji2FLhFyVWaoUL0tT6E6REQdgz38Fi+gudVErZYGafi5qcpHvlqHJI5+mk1HRqJmCbBFN5vTnf0tnx6Q5zecWNVUzG4ZivGTBnsbxNbB0HsA2FJcAAzUsdu/kK71dQbgsjrO7T4K6U5nqTsXCjk7CtolCommEL9x6ylzebcNdjZrYFIh5AP+87SrwmT9FayjtF1Lyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function vread() was renamed to vread_iter() in commit
4c91c07c93bb ("mm: vmalloc: convert vread() to vread_iter()"),
converting from a buffer-based to an iterator-based interface.

Update the kdoc of vread_iter() to reflect the new interface:
replace references to @buf with @iter, drop the stale "kernel's
buffer" requirement, and update the self-reference from vread()
to vread_iter().

Also update the stale vread() reference in pstore's ram_core.c.

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
---
 fs/pstore/ram_core.c |  2 +-
 mm/vmalloc.c         | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index ed97494abf60..738283a85ea2 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -450,7 +450,7 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size,
 		pages[i] = pfn_to_page(addr >> PAGE_SHIFT);
 	}
 	/*
-	 * VM_IOREMAP used here to bypass this region during vread()
+	 * VM_IOREMAP used here to bypass this region during vread_iter()
 	 * and kmap_atomic() (i.e. kcore) to avoid __va() failures.
 	 */
 	vaddr = vmap(pages, page_count, VM_MAP | VM_IOREMAP, prot);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..9ee256884f78 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4575,20 +4575,20 @@ static size_t vmap_ram_vread_iter(struct iov_iter *iter, const char *addr,
  * @count:        number of bytes to be read.
  *
  * This function checks that addr is a valid vmalloc'ed area, and
- * copy data from that area to a given buffer. If the given memory range
+ * copy data from that area to a given iterator. If the given memory range
  * of [addr...addr+count) includes some valid address, data is copied to
- * proper area of @buf. If there are memory holes, they'll be zero-filled.
+ * proper area of @iter. If there are memory holes, they'll be zero-filled.
  * IOREMAP area is treated as memory hole and no copy is done.
  *
  * If [addr...addr+count) doesn't includes any intersects with alive
- * vm_struct area, returns 0. @buf should be kernel's buffer.
+ * vm_struct area, returns 0.
  *
- * Note: In usual ops, vread() is never necessary because the caller
+ * Note: In usual ops, vread_iter() is never necessary because the caller
  * should know vmalloc() area is valid and can use memcpy().
  * This is for routines which have to access vmalloc area without
  * any information, as /proc/kcore.
  *
- * Return: number of bytes for which addr and buf should be increased
+ * Return: number of bytes for which addr and iter should be advanced
  * (same number as @count) or %0 if [addr...addr+count) doesn't
  * include any intersection with valid vmalloc area
  */
-- 
2.25.1


