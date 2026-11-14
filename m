Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26121606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 16:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=5GANXBKY
Received: by kanga.kvack.org (Postfix)
	id 890236B05B5; Sat, 14 Nov 2026 11:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866D46B05B7; Sat, 14 Nov 2026 11:47:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0EE6B05B8; Sat, 14 Nov 2026 11:47:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 477296B05B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:47:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0B0A40438
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:17 +0000 (UTC)
X-FDA: 85434304914.06.18423E0
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7C46380003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=5GANXBKY;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794674835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4orBA17LG+6yMhJxEwoDee1XxS6KoCjmhb+0Rvf5Gtc=;
	b=JhvBOLzDxS+b0+W/mn1DbhB6JiZKUmzLOST+ck+hlGOHxn6ONRZ53f9zoNT42PyGSxciNj
	iVd4RMSNDd2mJGZm0rXTQElA2y3VmFtnC/VB4z07iTJIIlhYfpZi1fkqe3CH5vUp6+D32x
	CBQ1YAPEIYHuN6a7l8eq90YoU4Q75FY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794674835;
	b=3FnKq69lpTTvBkxobqKEPpxaa6zU+hS76cCHng2+CMTWVgbghfnONWG1fpcdYQd8VGP12P
	QAWe43gUUNwKVx4/JmWVGonF+mhIxmggr4YqZspon94a7HXWyS0ChJmtWn9RCM0LwSg6z4
	ldi1eBJMifeWKamAXlImCZk/HZw3r4E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=5GANXBKY;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jRg5Q5B4dz4xPSF;
	Sun, 15 Nov 2026 00:47:06 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794674826;
	bh=uy3aECGD8Sfpa0HTsqpqvXCqlYoBtRbnXcj1FuuqDpI=;
	h=Date:From:To:Cc:Subject;
	b=5GANXBKYm/HTQXaAzQLIUZTK7QnM+2TZQDcz2vgzNUlwU9D+mnWFErG9kz2kW/kLR
	 DPnSnfrZhrTQR1Z02T5u0XhhtqGdO+WiXuYST6UgwZVxEfLPMzk4VtY1rkweNPz8Jv
	 Y/1EFYeD5NG8XWoUs67D9RnuCWVw0dZnPuxsl63wdE/MVXrfsbi6OntJY/Zk3964f/
	 D1JyqvCTtOmwP9kRDOpKF1RPrLpnEh4R2VjzrhnU0iw2T5j3Uq5H+ykBzhd55WRUoH
	 Jw5E6NoGc+ZR7KOchHKHfgIeluTBGca4pORhAr5I5jxqz0rSHVBinRZ9pYeWIxsDVC
	 nkcGbnbnKQtjg==
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6AEGl4JO089813;
	Sun, 15 Nov 2026 00:47:05 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 00:47:08 +0800 (CST)
X-Zmail-TransId: 2afb6af8908cacc-33a99
X-Mailer: Zmail v1.0
Message-ID: <20261115004708909xx05JgB9nXnOCG0zL7h_K@zte.com.cn>
Date: Sun, 15 Nov 2026 00:47:08 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <linux-mm@kvack.org>, <virtualization@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9iYWxsb29uOiBmaXggTlJfQkFMTE9PTl9QQUdFUyBhY2NvdW50aW5nIG9uIG1pZ3JhdGlvbiBmYWlsdXJl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6AEGl4JO089813
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 15 Nov 2026 00:47:06 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF8908A.002/4jRg5Q5B4dz4xPSF
X-Stat-Signature: madxweoeaiaqmpto3ga5geo97bsd8up9
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C46380003
X-HE-Tag: 1794674835-798209
X-HE-Meta: U2FsdGVkX1/SAaOB/RfJ7Wx/VgQpyRrtyoOiO5sqeAtxev73ACZ31Yt9M3Rc/nVNzKl81byIualoFmoa1qnJ0en29LLxGaXWZoupC9+4cRcxWOgrWN66fH+ZNeQZzqwpYnZUY0kps+Ym9WUphdpu6RcEOTToBI76TdKoOqjqrUiYXcHZLyATXVtokTvqYRuzNKLfcBb6McR0jf9HTyo126VTfccXN3URKaykIK1lFGiGAM1c/advooM6bNJGy9Q7/QOeTAPBGEnsV1lZaRE7X2iyO0HFecYhcwD9tnWLVKYhPo57qAtoIqR73HHywOtgWg+GEV9RnxMLG1XOIGEqsGhnAUgig0PtqjasQHT8Cw87hH31cZUR40ZQjcFo7s7tev0/9KqC4JvqTQjSHceXXRbIqJYOI57oyryxpmVqfl8hdYIx4miKVDYPdN5P+IPpLF3w6pxkAv1oDSwLPT+2P+rmZYWAVzJTIZa6D4cavtiqQgnRKVZo9xrVnuB4/cNxXbpj5k7NkNpLvH+5ixNMj5OhO1PqVXmBB2uPgGExXOcq/+K0S7XhLhx8FmH25agW9UqtCpysz9VL21pw1F4rN8/hpW1qgrEyNprkFMtJqsmNNilpKrZO3YeaLW9w7otlgm/3i66uYnCUnQhmC/fn/p8HBDlcCzIx01YcEv+eMKTbUx2GUp4osnv6L8e/5vyq6+J7MbWah0joh3VI9U8XysI859qCakzPx5TdwGI9nsuV8ff/SFX3OL7Ogzp8okGc7rvbP4rqDSiKDIEmZuBzU7oxGfR4lj/55UTVUq7KEgnU449oxz4nQSkON7fqK+EWukiXTOUPlFveJq1f8dHy0WCWvGA6h14tH9NzIzY437F6O1eN1xjPNogr3A++UXAnWKLpn5GSOPiL95vbxQm1PXui2J7rJlSIbhlIZQpKm9oO81sVavgCaeoD2G/v2C86rhdPKaJ1X1qcQRQ8FvY
 kSQc2ypV
 URqhqa0KO2AyF+evE4iOYBQdGpYInGiC9ZbL2W25tSXND0Qlp7+4lZGM+nM1xX5H3pWPH+u+qV2o2c8lGo8YWb7hqG/ZkQ55KjnyyO/mv+4zkxWWRf9mboeH8HSY4mEwAPT1uDac+QQc4o0O23q1FVnFbU0VFbC9PCczdlBWXW9jab77445XlvT6RwJ/V5xGxM9zleyE3SbBeJ2vrBQ3T9oXQ6qd6eBquFO3KLphuzfGmaEG3uGGD94egV9Z++a+65nnOwS1d9ykKm6xLufL8609I7kFuSUjSo8AKim+JJEv0E9go4EQyZET4thd5KM4dMn3+Kc35VSD4KVZtrM/oLeIQxjmVAE+n2ZvpepGXgFZOlQYH8ASjBodCZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/balloon: fix NR_BALLOON_PAGES accounting on migration failure

A balloon driver's -ENOENT migration result means that the old page was
deflated but the replacement was not inflated. vmw_balloon returns this
when its deflate operation succeeds and the subsequent inflate fails.

balloon_page_migrate() accounts the deflation and frees the old page,
but does not decrement NR_BALLOON_PAGES. Each such failure therefore
leaves one extra page in the per-node count, which also contributes to
the Balloon value in /proc/meminfo.

Decrement the counter on the old page's node, matching normal dequeue
accounting.

Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES state")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Build-tested mm/balloon.o with W=1 and CONFIG_BALLOON_MIGRATION=y on
x86_64. The vmw_balloon -ENOENT callback path was reviewed statically.
No VMware hardware or hypervisor runtime test was performed.


 mm/balloon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/balloon.c b/mm/balloon.c
index 96a8f1e20bc66ae46a571a4f51243789bb362925..44c211ba8e6b0b86236ec0e05ca1eb4b9c444a8e 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -313,6 +313,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	} else {
 		/* Old page was deflated but new page not inflated. */
 		__count_vm_event(BALLOON_DEFLATE);
+		dec_node_page_state(page, NR_BALLOON_PAGES);
 
 		if (b_dev_info->adjust_managed_page_count)
 			adjust_managed_page_count(page, 1);

base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
-- 
2.43.0

