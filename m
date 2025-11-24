Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D79FCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 16:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50CE6B002D; Mon, 24 Nov 2025 11:12:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28866B002E; Mon, 24 Nov 2025 11:12:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65A96B002F; Mon, 24 Nov 2025 11:12:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B55AC6B002D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:12:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50BD088765
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:12:24 +0000 (UTC)
X-FDA: 84145993008.25.2F5B91F
Received: from sender3-of-o55.zoho.com (sender3-of-o55.zoho.com [136.143.184.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5192CC0014
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:12:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=KZNv80RP;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf10.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764000742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EdBP1XqtHyMX0ny76Q3jYc9Yy634St8QHi/DxGItwc=;
	b=Ss/Vc+65feOAd7mJUahCjmNJBJmNj1drBHDGN1BeQvllgiQ05ugwY7i93sA+7Ty4sXnS2L
	jO/QikZHxicG0I4XuMVV6iATQxkkq4CODoKAuulZh294PHJa1yJtSNZh3/0sN5p9i9gcwX
	4wvuvocWze0Bg+BVeR2yZ7k6B9OPZys=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764000742; a=rsa-sha256;
	cv=pass;
	b=V6M1hTrrXNjwx0wt9gAUycjJcfGMFecV/9XNc0i5G26ViB/myPxWbd25clRqBi+nuWMWmU
	AidpUpFeoIqnPG81bzwiMf9Mb28PXgm6TAApfNvf8YSSoM80Mb01FCNp2JNUOSHh+kRz8a
	Kgq4VJjhfIuCHlrbK9sxgNwEH/nsnnc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=KZNv80RP;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf10.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.184.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Seal: i=1; a=rsa-sha256; t=1764000723; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=BzIOdzUKWIkEnzY4GTl/s/ksHKbba/ShARt1e1tdNJDhv0l7qMdLtYTcOb2BmOJ4cMeDoah5ZeoYE1wYLSCvvYnXx74NhcOvjr+Q+RbeijxeOaxOxyP0HFZg41a9Tb2r2PX938w7TdCr251I2DZ69cbL5JaknYH6h4ttSsAaa/8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764000723; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2EdBP1XqtHyMX0ny76Q3jYc9Yy634St8QHi/DxGItwc=; 
	b=BST2ERv9kICJH/q1jmISFupc+RtXfVan8G9WrPBVwAmmMdLA1JsA8Q+OvROrOKXhsAl4fGfaOQ7ZfeJ5eofsr/ViNo3ZWT5nmzo1NYGBx0sRfIVOgmcq3stO8tAzcH/tjz1AA/vbHOprtr49IjN5lYQB3PxdSXrzyQKk9QvG7ow=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764000723;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=2EdBP1XqtHyMX0ny76Q3jYc9Yy634St8QHi/DxGItwc=;
	b=KZNv80RPi7uab3yqYDUczxIMtzB7tzKMHePs8oKMJ2gt5KiRFmjaFy9AjEUz463M
	WILnT+o+kElPzxUxP7NYe55mVQ719+s8D/3rpUbdvUY2IMTIq4Wbtgoom34KDCb7wQG
	kyUpmU8e+S/q4AxGoyB6XhhqkE49WJ+oFUu/Z184=
Received: by mx.zohomail.com with SMTPS id 176400071990975.64503086294087;
	Mon, 24 Nov 2025 08:11:59 -0800 (PST)
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: linux-mm@kvack.org,
	dev.jain@arm.com,
	david@kernel.org
Cc: linux-kernel@vger.kernel.org,
	syzbot+a785d07959bc94837d51@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	janak@mpiricsoftware.com,
	shardul.b@mpiricsoftware.com,
	shardulsb08@gmail.com
Subject: [PATCH v2] mm: khugepaged: fix memory leak in collapse_file xas retry loop
Date: Mon, 24 Nov 2025 21:41:49 +0530
Message-Id: <20251124161149.1302507-1-shardul.b@mpiricsoftware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <703387c8908a609c3de966574dfcf481c5a97216.camel@mpiricsoftware.com>
References: <703387c8908a609c3de966574dfcf481c5a97216.camel@mpiricsoftware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: qmsp9awqpkyqpnn4quuf31pegrms9rq6
X-Rspam-User: 
X-Rspamd-Queue-Id: 5192CC0014
X-Rspamd-Server: rspam10
X-HE-Tag: 1764000742-708100
X-HE-Meta: U2FsdGVkX1/O6fowKlG/QAF5e5mLLbJMlE3cQiEb1vvsgdMUPmAd0ItYxYsOYHh1ORFBVjVuzFxM2hBs9pQYIk2Lt+Zk7uhiAhmnZ9S517UmRctxnFL0wFNZBnvJQxrNMaeDQzCF8f4Xzstd8y1KxKPOQUAL1gkwfef0E9PBMC1SLhZmjt5xB284bHBZ5SfHn9Xi9Dtw+F+DP8bkh++BXinQ2XW5WT4aA78adIfbS783PlwmD0SQn66lgcVi8UnKFff5m6ZCAbJFWc4d07Jm8TXUnELUXFYpIdhlEmAsELZTSGfk17nnrApJdUK7bPTZxv/O5xrAj8Y+R7DYxR+6YcHNu3YaCX+rgu0OmebleE5Tu7VRFYYVsx5xLDsNdez8ZWS+j0YjdZXqkThp6Yy9CYVPnNOW04TEEr7BPAdakcoNQDmUMKXQa7vB98VKGkGdm2uqs6gzzNOfWxR2jy7th6eziUnybn57jaqAW0IGZR3T6f3TBjYHH307HhOveWMRLYEwP4ldHoFD2mGgIWi64/n9QFkFhoawu3GAOu/Vxnr+WWUoYImbAXmgn+jn8xWnrJntl+/n5ts5v0qyu2spwMJFX3gkn+Szxfu8jB92UDVAoGPkA6u1Vdi+0m4jnMqxHekH4VzsEkUlpQxx8ydWxwCYt19nMQkvGSBV18TgF/DxgTTsNpLP/PWesVsX5Wb1INlr0sFjVED6lux9RwbuXeBMLjAC0SfIorIekQvMhq2OFbRJg7JWc3Ba48hlnM15yLA9wDY8IAuCTvB5YM0paSEXD2Rbsvc61PMWjL12GCMJbB4FlsE2ToSQcejzTkYVqni9HCjtZTXzMkIkF7aTf4TD7pkWWl/M7VieoQqvsaeq6YzGVt3iQWqFh0pnXktk8F3890KbSoFb6urq9Ypq+RhnBVkZsEesr3+iswAr0bbWKoFencCwTS+l7GtIudYQLrpUHKpqsT2EqS3CBiz
 BrYOKUsR
 sD+IMq0Cttg8TIxjUKn8vuZnrwUHqA2c4vjboT8aP5KGRGqywlojJm1navsU6zLDLqMONSAQSELl32SBcpRf9EJqZkIXY/BkieBWzWVd0nSOYj8wJzvWLC0Jq7yVflNlpdmhCR0EKqv8mwqHeHaPbvMFi1KOwAjHM3l/ppJz8nC3e/mFPH2Wj5St4WfK7p13IK5cmSewKToDttBDNjrmroCbIhoWAoTl+AfesQNTOMQGdHu2HD1PUdeY4x2S2ZBCH7264AqKuUDNPQtsShC55lssVgAcx2l2BCyB6fDjrxb3QX2ytB6vTtNede1KCB7tkEsWgRjx8Fw+irakXPMyC/bGJExJ3KHbbx3HySoAzp+vC9/LfAQ8muBHDJwSFCDsKcnRAluiWkl1FLLQ7B1DWrj2ruDQNowJEv0r3NLorrahrPMF+0Ggkrz0rqlxSN6J37WXB/8d3+SrvYLDnbMs3AsrFjDhIHghpqzS8H0iR3tjHqt4DtBWaXJAcgEi2yqhri7PEKoNjjhHX7hcZLKmY8GnBVw5geKAJJkcp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() uses xas_create_range() in a retry loop that calls
xas_nomem() on -ENOMEM and then retries. xas_nomem() may allocate a
spare xa_node and store it in xas->xa_alloc.

If the lock is dropped after xas_nomem(), another thread can expand
the xarray tree in the meantime. On the next retry, xas_create_range()
can then succeed trivially without consuming the node stored in
xas->xa_alloc. If we then either succeed or give up and go to the
rollback path without calling xas_destroy(), that spare node leaks.

Fix this by calling xas_destroy(&xas) in both the success case
(!xas_error(&xas)) and the failure case where xas_nomem() returns
false and we abort. xas_destroy() will free any unused spare node in
xas->xa_alloc and is a no-op if there is nothing left to free.

Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
---
 v2:
 - Call xas_destroy() on both success and failure
 - Explained retry semantics and xa_alloc / concurrency risk
 - Dropped cleanup_empty_nodes from previous proposal

 mm/khugepaged.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..0794a99c807f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1872,11 +1872,14 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	do {
 		xas_lock_irq(&xas);
 		xas_create_range(&xas);
-		if (!xas_error(&xas))
+		if (!xas_error(&xas)) {
+			xas_destroy(&xas);
 			break;
+		}
 		xas_unlock_irq(&xas);
 		if (!xas_nomem(&xas, GFP_KERNEL)) {
 			result = SCAN_FAIL;
+			xas_destroy(&xas);
 			goto rollback;
 		}
 	} while (1);
-- 
2.34.1


