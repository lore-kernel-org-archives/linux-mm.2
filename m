Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D2CEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE9C6B00BD; Tue, 30 Jun 2026 06:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DE36B00BF; Tue, 30 Jun 2026 06:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320E56B00C0; Tue, 30 Jun 2026 06:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06E0D6B00BD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:54:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 889881C33A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:33 +0000 (UTC)
X-FDA: 84936270426.25.70A26E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E3B9CC0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:54:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nUdQL6z8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816872;
	b=hOLh0EOS4hLNl6slrPFhEJger2HLO6QY5bG2s5HyHDgiGglhdGeahG5NBdS2XyuUsY/dRS
	i7wIkexSCKvuYCw+ZW8+ohT3dErvF+FGO4Dv7JQJWeKAdLG751OZhGZX8DAUFwBV96sY9L
	ktBRMJAlVTMtbiiGfAqyVXQe63XNIcc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZrKULHOZCI8ncGNpPaXRQATiyNvBkegtg9+f64SaWk=;
	b=TmjeKpL+OQJPRucIFePzAb7r53+bXwdiXimkFEGvXF2417Or6A2h1dk677h2xqdgp1oM/b
	/d7KVB1pMtMDuF9MqbbDPJYPjacov0h5vP7y+Q76Rv9vRVa6HmdC9MkwbhDICzxOma9jTd
	CB2PlYTo8JJOga7AkzHb9CSOv9gLX7I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nUdQL6z8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D3E84386E;
	Tue, 30 Jun 2026 10:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084581F00A3F;
	Tue, 30 Jun 2026 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816871;
	bh=8ZrKULHOZCI8ncGNpPaXRQATiyNvBkegtg9+f64SaWk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nUdQL6z8kCSrzAcVNyvvv4NATSESaWwYY7FioZQvBxeGiHBtLSpLEi5Zh12SfpD9V
	 c6kqcn+Ycp2k9nYsQiR3fjnHyEpX01Qmgebuaom9NiQv/b00OSjyNH25q6B2aPi+fI
	 TAVk/NEn1hhqbKqlERQiL2Zq985mroLc+kRA1wuz1CeEx2M7aQkKd6hI+bTtqMvwmQ
	 pw66bVWWKgDXxIdVQqK5yWKPNJBLD4nPJDmpJYO0blVgyBFJqJCrBK+kM+//xv9s3c
	 AZH7dyUqOgvbphxcdfEmFzK1F+/dbasFC+HUCECy3zk365KWgJvRKJ1q89ANNKs1qr
	 y5aXyW0Kow0kw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:54:20 +0300
Subject: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
In-Reply-To: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3B9CC0003
X-Rspam-User: 
X-Stat-Signature: jm5sjok733b6tbrainfn7w97dgjwdk4e
X-HE-Tag: 1782816871-296123
X-HE-Meta: U2FsdGVkX18rv06Docmn024BropMSiet/MfB+bQ9IIZEt1wMQuEtvf7cGl/zPANoQCahYEb4/amHgr9LWaa/W2nC09+obMXRQ/au0WMcJGtlTggi0DKM/+OtE9HzEOXPDFQeYqot3PW3uXvSFL6FiPO6L04yCbO4U0x1eyds4yUSdrX71W/CQftE5q5Co/qbNaSRyU8dy1+DZ3X80CDdAUHJpV0TCmDM/E43ncDZcqHVF+vLpOs9Pel5D4fjqFkGrCM1O+aHGiZf6U1tfX2KyVUgKTDJpTC9bHdePIG80lmp/Lsn2hjxfso3zRTjNW2sUa1nnhDtEprtu4g8mBWt+Fodgtsh33WIeJVHwvdlqEf/RCHPDHbNQrPVsVA3u7ymMVRcwI7q8yqku5lvZI/jPtvJMBKj5eq4CVRtoB6Z3nIXMByM+f8Vz9vVsWHjCvyUx8liLfba9x8PIjtqs7aEEPU77rzfhNhS6XNFrCZSNzjeBZqOrSP9ZK+z2Ft6sRFOdOxL3vw8mAdEAVYpg8LuaTWWIosbJdECxrOwFslQIrZIB2CD3gmdudy8gP6IyFobRcO3UW8sp6pviuMoSkJocgW5BNCZwG0XgeAtzlBxu4Wk74eqH7MEQ3KMWm0zscm+XqzTl5/jJYerfrfMYpV6Kp47o9orgVWkOHu59L6PTpsQieXGvYkH8DO8MOSIRYRuWYi9uB24b/5HRE3gGoEVk6l4YlZayLj3Npg+gCucEra/4wJy4ndcfUifPx59hqe3vQZZN56BwAVEOTYy3WJfeqR+lPEpBONPnRsExPGGpE1O+H1JHNGaCs6MtfukszUOsTGqwvMuwvpvAUULXCH6hJCGMmeGhmGO7DHHl6ztB5lJNOky0g6ufUWzA2PoEBF/+tIqXRt1m/Q51u9RtSQ9fuas9dWMopk1o/52FniA5K1y3kcCbir4rz6kJL8a1DZiLW3z55H8V40tF488JqM
 oYnys1a2
 BZctP+PRNWTkN305MxreB59IoLYs6EGQVQ5aGiG86W7GOtwLhX70E9bL5NyBjqyUc49JB1YbTBAjZDrcBRjHDXPGG6mhvEL+t9GRNc+w6oQFfXOas2hxPM+uJ9rKG9YPwMeiXwuiuR0pUDWwqhpQa0g8a6OAN8w6ib6xzrWQa+eDLMUcIln6pAjQEjYrjaV5WIe2UZMLjjzu/FLsKXIYV9VbTgg5k/YuXQ1V0mDmbF3I2Td1OBesLnQJFVkC7QL7FAUPMWXvixRBlmw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

IPR dump machinery allocates memory to save adapter's crash dump using
__get_free_page().

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/scsi/ipr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d207e5e81afe..5a212bfdeec2 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
 	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
 		if (ioa_dump->page_offset >= PAGE_SIZE ||
 		    ioa_dump->page_offset == 0) {
-			page = (__be32 *)__get_free_page(GFP_ATOMIC);
+			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 
 			if (!page) {
 				ipr_trace;
@@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
-		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
+		kfree(dump->ioa_dump.ioa_data[i]);
 
 	vfree(dump->ioa_dump.ioa_data);
 	kfree(dump);

-- 
2.53.0


