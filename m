Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9F0CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 03:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244BF6B0005; Sun, 17 May 2026 23:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5EA6B0088; Sun, 17 May 2026 23:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10BD56B008C; Sun, 17 May 2026 23:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F30EC6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:19:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D48590A6F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:19:51 +0000 (UTC)
X-FDA: 84779086182.18.41A763F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id C74921C000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:19:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Rw3p6pZd;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf20.hostedemail.com: domain of liuqiangneo@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=liuqiangneo@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779074389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+R2QSJwrWBhgomsPY/Bqp55QXOlThKM5lqu+wyxBYXw=;
	b=N0dK2lA6y2Azs2Y3shMX4uM0+FEsuSo3Hppjyio0PesvIha5ShcsBHoiPAsd4WKxescvnV
	mCRpp756XhK/r/sXC+gNeeiASUvqgel3abLdwqwS/CeMZuMVMbGJy1HFaeVg9qj8kq0ITt
	4pEJDITOA4vAsMPzwdLzLONZqrdrYhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779074389; a=rsa-sha256;
	cv=none;
	b=fWA3kYOw1WUEyWGDJJj90PTfH9S62hBHj1kNQGMTa+D15/S+8crmSHsrAKzlEFzfFLtI8w
	uYbGlpfNKhJ+Ib7y6R36CN4kU8uR779tkHDix5uRykdB2EqdUmKhTgCXs46NdDp5Aw5cuD
	rc8e/z0FGFBI5kdZI45dBMIcSaaGino=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Rw3p6pZd;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf20.hostedemail.com: domain of liuqiangneo@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=liuqiangneo@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=+R
	2QSJwrWBhgomsPY/Bqp55QXOlThKM5lqu+wyxBYXw=; b=Rw3p6pZdzxxy43lJso
	pCrRvtQuTDjkatshsKUYINRTCP32ixJdNw1D7VcAeMa3WSOUlx+dtvmttpUmfxG9
	xCpVD99BmKQZgj4DhDKPqV/TEcKS7o7r031Yb7RkWTZ075K8sedR7GYPx8uLyolH
	xA/AOIWk1KXdGbIr6NMI3THnw=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDHb8Q_hQpqOhDIEA--.18582S2;
	Mon, 18 May 2026 11:19:30 +0800 (CST)
From: liuqiangneo@163.com
To: apopple@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH v2] lib/test_hmm: Check alloc_page_vma() return value
Date: Mon, 18 May 2026 11:19:03 +0800
Message-ID: <20260518031903.63455-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDHb8Q_hQpqOhDIEA--.18582S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw17XrWDJFW3tw48uw48WFg_yoWkuFc_ur
	4UA3Z0gFy5JF98GF1rtws7JrWFkwsF9FWxu3Z5trW3ua4YvrsFga1DXrsxJa9xGa109FW7
	CrWDAr1fZr9IyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1pwZDUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC+wOO72oKhUP-4AAA3g
X-Rspam-User: 
X-Rspamd-Queue-Id: C74921C000A
X-Rspamd-Server: rspam04
X-Stat-Signature: tymptdrbd49bwteygd5k3n11ah11itun
X-HE-Tag: 1779074388-203420
X-HE-Meta: U2FsdGVkX1+AsG3sTJUl8IIUjUK7so5LU/OyKNlV6f5h1C6lYQ9QTPrkaCD+TIbC3twcdrL68TMXCjbYCu9OsANYIxWqhmXWChQzQDjhHIhIfi2bJDq3TtWzVMC8fudXLkRaQiiQAx8oruG2tPinfG7qXNbZuNfYhl0Sm6ra1F1yCXZp2PmDnGESBAmP9idigW5nZNNIOQ+HIU9QkQtJTfc+u+ZF33ORGmnS6IXzNOGYoqBOhg1rJZilRhIeujtB30Y5j5M/nIFyjwkKT1HDImT6bCNKPETPh8V+8udIsBReyj2XqQa2gnMBqGuCkCCYkngi1vcdZqdP5YUUAr9YSdop/EZ0McPjsDAtodeyZgOigUzzQ76RDJM+y2ZhBUGcpSfXr32FJwpOnmGEazlOVFd+J6sQ9ZZKajjFn6fgE5EZQsGLVJ592Ab43+ZzIQDhFxYbY6gmNZ00MOB0BUKodoFeMkZwriHC3oq4aTPxrORWtagfbYQFwcZmdHfsKMd5QpN3VDPaX3owgpYyJB3F/AZVzuefYjAi2WyoZc7xGEHa+yO/hdxM8trZXqbwK2uVD4S/x69FSsL2p4IRCmL2BkNLumLjUhAZDqAPcv4fFtRKFjGHGvj96uEf8u1Q50HleWAyC0d6u64br3Y68Q50CkpjlHLxn+Am79+jVUhkcP/9oOMQoAn7JnQgQGcHnKuGjt/IBF2A+BxKOszoI5ULmRO90ocvB0hLsBXwo6FJfViMiFqqGGgeZHvCKK0U2G67S+ny4bh68OC6a3+Iv6MeUuZYQfckvCKp77S3HapPOqql1xm3z8y3sZ9dCVD1Agk/w1v7wbKA5hfVfqs4ki15ML8DP7YzTRvLoCHg2T1LF/G1LAdhYxPQkOW9qh+xOrpHImiTtO+flBzgg6XhEz5FZUjjeT4WdekkElwzHzOjheqlcjxH/ZBCUyK8Mws1lOj3DEVgp57Y4w5OOoeVqRp
 BQ8S6cag
 S+Fpha4ll4Ths8YGFXcKeGGj3IZHMf4kGZs0ebw7ZWSRYVQU8t+hVYBJ7QIPIovVF6eM/7vpouZ7zWZ8YJ+5g677GduSjqGg6d/97BIDWK7mL35CLYtYEK1/BYSWOXNc0hWAp/2ZWh6M/Pu36TTxuVgLBi55TcAz8vgqKaUDN8JDuxgGekQ7cn7kn4XldMKY8ZjJ9mDb6MScodyanF49psaFhJud7RfdmFWtC0oxADSy13czlulGfrHvCcM1Ix+heuXSYNa16955EEjQ5FbIiqIGmwPA7/vIA8p/DTnwg+t4Uue2vewP0ddX25akU327m4pUKsNSYHC7tK1gwiqDvTR27jZmLTXsVm5CIdPYQcy6mZ8WVn8jS9BvHqRgYlN8NyOAgn0iCoKnjjQjOEWgPnQFuZcBahkv02dFK8lwyF0c/fXB7fL6T2hvxvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiang Liu <liuqiang@kylinos.cn>

Return VM_FAULT_OOM if page allocation fails, which
avoids a NULL pointer dereference when calling lock_page().

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
v2:
- Add unlock and free allocated pages before return.
- https://lore.kernel.org/all/20260514032345.32256-1-liuqiangneo@163.com/
---
 lib/test_hmm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..90aec4ca2e01 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1063,6 +1063,17 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 			/* Try with smaller pages if large allocation fails */
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+				if (!dpage) {
+					/* Unlock and free pages already allocated. */
+					while (i > 0) {
+						struct page *fpage;
+
+						fpage = migrate_pfn_to_page(dst[--i]);
+						unlock_page(fpage);
+						__free_page(fpage);
+					}
+					return VM_FAULT_OOM;
+				}
 				lock_page(dpage);
 				dst[i] = migrate_pfn(page_to_pfn(dpage));
 				dst_page = pfn_to_page(page_to_pfn(dpage));
-- 
2.43.0


