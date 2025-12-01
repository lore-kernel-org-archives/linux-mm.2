Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2627AD116E2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 07:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81EB96B0023; Mon,  1 Dec 2025 02:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEEF6B0024; Mon,  1 Dec 2025 02:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE686B0026; Mon,  1 Dec 2025 02:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57AF76B0023
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:46:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58EB013BBBF
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:46:17 +0000 (UTC)
X-FDA: 84170119194.11.BD30EBC
Received: from sender4-of-o55.zoho.com (sender4-of-o55.zoho.com [136.143.188.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B02010000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:46:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=bbY9ibHh;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	spf=pass (imf14.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764575175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7w3dSfaWrYwjp4+7lWC1VjH2NSXdXNvxA1hcZmWSbHc=;
	b=ny6U8LmRaK0UmbIbwxKwjGsj9C9KDZUgdbweqOZft4f04NN6sBNS8AiVXZSWdj5TrgHT69
	QuQcq56iNbcN23zCJ7qqKoEYXCn2fusk184qB7QVGmFv2PB7TrZEIwXmo77GA9teDttMDv
	6IiZdySaoppZyuoeyeUHZ7WrHGTPN/E=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=bbY9ibHh;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	spf=pass (imf14.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764575175; a=rsa-sha256;
	cv=pass;
	b=7mXXOqkTf5V2/eFNxlJ0LWAY3V7GixO+wA2fO3sN3XQrx4qt3y+NkaHKCq0xm6qPp4Dxq6
	f2DhlnuR0WRV2Ss/FiNAPvo+Qc/lBqRMqi5D2Q5xW8Wf/SBV7UJjjRC8O8MRokfAaUExkn
	5NRA2sFR0/j2AwbA4FJK+1qPvA/a+8c=
ARC-Seal: i=1; a=rsa-sha256; t=1764575151; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=RM7FSSWt5ExfvBZPfoyhTHrKSp6ZrNpCaVo7QjvCe4BJHFUwLsGUKV7p+ga0W3+Yl0ht2eWId3X/uDnfV85DDT0qDnmtZOMFwekY9MkQqhyB6JbRR2mmCweIm9tarvkQwncP7M2AoZLoVxiDBgoai9wC/Shmxrv9+RBae6A7+io=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764575151; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7w3dSfaWrYwjp4+7lWC1VjH2NSXdXNvxA1hcZmWSbHc=; 
	b=Lo87pcVh831pbfvXxxZR8Io9dVhXV5WAybxq9BUy0CFW33IHzLRtdKgKJ6sCbEj+OUiG0alF/Wvn8LVojq1tDpklo8STv8vFGCWy/FPZ8Nu+dOS9tQqn9XtsgR0h4HZasCIAgWuWBtUoH48sbFHqRqoPLAPHkw5rq5Iem61hm8I=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764575151;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=7w3dSfaWrYwjp4+7lWC1VjH2NSXdXNvxA1hcZmWSbHc=;
	b=bbY9ibHhMS1qr1Nslgiuwwvt5NShzKJwlwUSbM+Sk+doS+yr+xCksSfvDiT44+Kx
	hKOW0KZrdRyDbgsz3ii1sh2BxDL8yJf/FrpzgXVzLExeV6bV/i4grix3fU32b4A/qXP
	scSKjBMWYtWleF/AbQpBRzL9zkShQXifU3+JYhEc=
Received: by mx.zohomail.com with SMTPS id 1764575148860438.9814188033906;
	Sun, 30 Nov 2025 23:45:48 -0800 (PST)
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: willy@infradead.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: dev.jain@arm.com,
	david@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	shardulsb08@gmail.com,
	janak@mpiricsoftware.com,
	Shardul Bankar <shardul.b@mpiricsoftware.com>
Subject: [PATCH v3] lib: xarray: free unused spare node in xas_create_range()
Date: Mon,  1 Dec 2025 13:15:40 +0530
Message-Id: <20251201074540.3576327-1-shardul.b@mpiricsoftware.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <7a31f01ac0d63788e5fbac15192c35229e1f980a.camel@mpiricsoftware.com>
References: <7a31f01ac0d63788e5fbac15192c35229e1f980a.camel@mpiricsoftware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B02010000B
X-Rspamd-Server: rspam11
X-Stat-Signature: mn7r7qygdwwfuy54njkoi81egsa7bbro
X-HE-Tag: 1764575175-999552
X-HE-Meta: U2FsdGVkX19FQd868fBWQcXMcWKbdoHfExNSeZsO2wnByMnhl/GaYDhXwp4Kujnl45gWEsWfrwgGZdyaw6LZ9nwW5RDTHgJAQlGM6MVGSqHlp/GQP3Snpxkk7HYz83+Pf1HMeZ5CdMrTgd8sVkrYKtWHUvQQUWZmF7BneZomjdNNZdPBDwBOmotde3an6El0aB3k7MoPuFLyk71CD9tZRDruoKduIh2gyRG8/fW0wocOX/vkwavYnddYkWYq7qAZxCsOKivCcVbS7+DgHlxZeJ7oA/3Ulun+OWVd7wH8Tnltx8PNWyuQyV0Lkpe4SWpGROE/FZJjr6RMvTl5KJ4z20cM2zPa48p7puzgRTaN3V+DtPC0+ypWuDLBeO1oHxaO1m/z+H8wKEnlZZqy4LRkj30QSt6aucMw1Y8CBDXSqFypMHOcXNM6laXpaIm8PFTxTpz2xiwqRK2gO92Y4lVqKrioDGurv9k0+xaP5G5BX/1aklalCE7UZrf8VULccEIT0nwA0kMxqD8Gk2TwiJ8zufXfH29SKLkEpO2cBR1a0kfP2MQI5HHglwwzpf+CnBuhoHbTytN35Xxb79RsPgitpzsR6m3UkjU2p3om0co9ALRTnx3FAmeHLN7xOriVoPLxTlSw/1bbiMFrAuceLWihykmBDL+Kc/xGdkqiCIcv0cqXfJTch09ShfErYkc6co0fi08kQl+UgjTPuG3iXwhAqOCLhTit6su4fFxJa1ORWZwhopLptQFLh30+66/1nuUW4nsD3bFEXp+N+dkEGTUVlaf8ugOB+DUZVgZp8WeHDnSGr854wLuwpKyh8xKDwKNtdxH/n49tDqq5gRfLSDmWGYP/EEWj/sZITxVMkaxv4jI4IdVQRklJSpN4f/xFH+5P9a9BWhShLQfWqfMz/vubRTfM5bttTcDetAERzM+QUDm82bsG3dJ2qp9ChyEovEtBNc52i5uzplJhTmZhMOv
 qPLCR2Ll
 vdeIQvpqzQGiPDJ6H9GkD31NysGfl/brW+awppivj7vqqpWmQwfHnv53KObwHTA+w7Fxv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xas_create_range() is typically called in a retry loop that uses
xas_nomem() to handle -ENOMEM errors. xas_nomem() may allocate a spare
xa_node and store it in xas->xa_alloc for use in the retry.

If the lock is dropped after xas_nomem(), another thread can expand the
xarray tree in the meantime. On the next retry, xas_create_range() can
then succeed without consuming the spare node stored in xas->xa_alloc.
If the function returns without freeing this spare node, it leaks.

xas_create_range() calls xas_create() multiple times in a loop for
different index ranges. A spare node that isn't needed for one range
iteration might be needed for the next, so we cannot free it after each
xas_create() call. We can only safely free it after xas_create_range()
completes.

Fix this by calling xas_destroy() at the end of xas_create_range() to
free any unused spare node. This makes the API safer by default and
prevents callers from needing to remember cleanup.

This fixes a memory leak in mm/khugepaged.c and potentially other
callers that use xas_nomem() with xas_create_range().

Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
---
 v3:
 - Move fix from collapse_file() to xas_create_range() as suggested by Matthew Wilcox
 - Fix in library function makes API safer by default, preventing callers from needing
   to remember cleanup
 - Use shared cleanup label that both restore: and success: paths jump to
 - Clean up unused spare node on both success and error exit paths
 v2:
 - Call xas_destroy() on both success and failure
 - Explained retry semantics and xa_alloc / concurrency risk
 - Dropped cleanup_empty_nodes from previous proposal
 lib/xarray.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540c..a924421c0c4c 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -744,11 +744,17 @@ void xas_create_range(struct xa_state *xas)
 	xas->xa_shift = shift;
 	xas->xa_sibs = sibs;
 	xas->xa_index = index;
-	return;
+	goto cleanup;
+
 success:
 	xas->xa_index = index;
 	if (xas->xa_node)
 		xas_set_offset(xas);
+
+cleanup:
+	/* Free any unused spare node from xas_nomem() */
+	if (xas->xa_alloc)
+		xas_destroy(xas);
 }
 EXPORT_SYMBOL_GPL(xas_create_range);
 
-- 
2.34.1


