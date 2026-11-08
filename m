Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4B2606A333
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bL9za9zi
Received: by kanga.kvack.org (Postfix)
	id CE22A6B05C3; Sun,  8 Nov 2026 04:04:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B6A6B05C4; Sun,  8 Nov 2026 04:04:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B050C6B05C5; Sun,  8 Nov 2026 04:04:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 737B16B05C3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED68D40457
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:52 +0000 (UTC)
X-FDA: 85411366824.24.22CD1D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3400E140009
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bL9za9zi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCDh0FdJGHHHcm++4vUSEYxnfXFdYYVf2X8ZgoxAVCA=;
	b=B2Ea8MtMkRy3V6IucbmEQDxHQKqZOfOiDoPvUk6KCckO47PB0UHUJHTM+JwbFkNRzAfotx
	WCZZ2jjIfGgdHNhH3Pt0Ver56rm8o9y+g9e3/A7qqN7xfx/BwAom2GAcU0BAaMvmvRLdBU
	QCjfWrLOzp3ygHE7rvLNY3IK5kc5QO4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bL9za9zi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128691;
	b=HSEo7dPJFUsR56la9uf1dSd2P6U0WXdEJsTuG4yjgzNkgpSNO9sE9Js7K+ZOzc7UIQo6uo
	ImINLrMlMF96R9mfpw46YFUELHY7y6w4z8Dsnf+8Cg7igEQkpuPR4I+o2oF469vpsPN8h1
	MKcLOjuX3Qk+IRpUqJTptFMv95QPHIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2B51446BE;
	Sun,  8 Nov 2026 09:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF361F008A3;
	Sun,  8 Nov 2026 09:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128690;
	bh=zCDh0FdJGHHHcm++4vUSEYxnfXFdYYVf2X8ZgoxAVCA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bL9za9ziX7V458bEKKQ9e+tbRc5SidIFKqY8Umw4kkv8inrgSUZnusyctE2cD/try
	 m0OXS5dJqQhMtrvgzcnYchDDRbG8efCtZUZ0i8/cUnmG4EBKg7bSLNugUgqhGq8Nqn
	 lVwrRYKiKpZxAEOOXbZI0wg2ASrDRe/9YoFI+ryey+1tGc9PLeeBu/sBR0fvZ3h2o+
	 Botp0WmwSHfujfTU8EfQhmJaIobIR7LVPcO3y6ZwBxvjTGQcZvEzr1xKH+L8Xwk5cR
	 fh9+Gn9aY0lBRP+DnN7fHfvBTyhP3FLZbAdm0pc3aXGg5Qh0fEThOnsaXGO0LU5dzY
	 GjhlBoPic0Hug==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:40 +0200
Subject: [PATCH 09/14] s390/sclp_sd: Replace __get_free_page() with
 kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-9-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3400E140009
X-Stat-Signature: yi8k8npxksg8kt9678jnm5897zp5z1i4
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794128691-282539
X-HE-Meta: U2FsdGVkX19i/uwRwIsSOEa0wI6RZ0//9oKuoQpD/pRcfZ3sw6C0pqtJZcuaOKS7D/3WsJmIkbyoazW2jmiEGERxFwtrd5npsNLqRAJVz0ueubcG5ch5P5ZCax7WeEhnAJ8rb3TbfQ51aEf//am36iARXp7dzSaaKANPGWfiP4V53RCgv9D16H2fpiWGKjstIucU38tmMU4pHVz2BH8gaoOUsmvv7GkBb7ymV6TlWjKl/9xLUySfQPQEcAT0MYZc2ORjTJ0zNI0nCCKfI15smZT5fzKYOHxCwYZGZ4Ub7fqq37ODUbsELmJXhxPgCF+MerfT6Jdq4477XJ2cQ+POPAjchJHL27o39UviyBQ9qoY8+4ie5tmsrVFH5NelXHOq4fCnlbTgJ+DvQg5MEx/FHQZ96KkTmMdhDh4v3gUVqJVYsvoLD0xngbmuxv9VWOffpEF61V3KhwRt13bbZWFxjVPMVLB6xX1nBo1GwFdP12g483kzrMeydwS8VA/Kzj0C7+WV8w4zu6VVjlVt5y2OzCHm52rw9Y2zSVSfcxdS77nw716P2OMdU6L1FAMszsyrV8djqyISYZySzfg7VAhgbE8zbHZlZVfGz6CobVT+f0a9kNUygTNB2C6unQro1S7435w/UkePed3YmE4u7CtIolvW/Jts1fWjuDLTbsOOUpZapM2s8NNmHWsG0J1yhTCmUjRkj3E+hjeQ6FNOgfIZPpc48OPp1dmLZoqJswj0I9nNzmYHh40QWRwLA8ypr+6YvHdNm3aYNXVW7G+UUUUIDWPQVUGOj5mjGShP/pCipu7+7/HTj5miGPC1iZ73+d1+XjdFlPccKyPHznOAHUqDvpryZiCVwVUor+vTSn7w26zyyWGOzx/TqKTAgXpwj2II24oUiyDH9R/aG9jzLs6wGDpRHFO1Vu2rf9i7bNRKDozfadVDSYcrASg+JC43j4C8O4aYRmq9AV2y8B3njPu
 +Yg/YbKN
 uIOUZW9rbEPqXuS5iegoVJNjj4IFlVms0xYg6gW0/JGoQ0I8pdz/pbvt+OjHSCeZ37Bf+tEPHiXyfcfyZRf/zeu34zGyKUGZi+IzUi1+vV6ZMtpMrGNWqCQtFzSYadahDhWf9yhyRuO4K9eGosJg1MKasZ8YWaJ2pGlmH+/2C1aeDdWuV2rxHRbEu1m+EjiCPUXtdoa0VXMpZrKX9WbQQXpcCOpSYpxq6Qm4nIbQyiCz2Grge3X8lkC3K23m3jqgRO77inEXOc6ifBOUprTlZXsH1tpg/rW9COyF+ZGbpkTpHRvlPxwkx3Sx6Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_sd_store_data() allocates the SCCB used for the SCLP store data
requests.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

While on it, pass the SCCB to sclp_sd_sync() as a typed pointer instead
of an unsigned long.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_sd.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/char/sclp_sd.c b/drivers/s390/char/sclp_sd.c
index c62b2eacdc131..cc0b4481e2bed 100644
--- a/drivers/s390/char/sclp_sd.c
+++ b/drivers/s390/char/sclp_sd.c
@@ -173,7 +173,7 @@ static struct sclp_register sclp_sd_register = {
 
 /**
  * sclp_sd_sync() - Perform Store Data request synchronously
- * @page: Address of work page - must be below 2GB
+ * @sccb: Address of work SCCB - must be below 2GB
  * @eq: Input EQ value
  * @di: Input DI value
  * @sat: Input SAT value
@@ -186,10 +186,9 @@ static struct sclp_register sclp_sd_register = {
  * Return %0 on success and store resulting DSIZE and ESIZE values in
  * @dsize_ptr and @esize_ptr (if provided). Return non-zero on error.
  */
-static int sclp_sd_sync(unsigned long page, u8 eq, u8 di, u64 sat, u64 sa,
+static int sclp_sd_sync(struct sclp_sd_sccb *sccb, u8 eq, u8 di, u64 sat, u64 sa,
 			u32 *dsize_ptr, u32 *esize_ptr)
 {
-	struct sclp_sd_sccb *sccb = (void *) page;
 	struct sclp_sd_listener listener;
 	struct sclp_sd_evbuf *evbuf;
 	int rc;
@@ -291,17 +290,18 @@ static int sclp_sd_sync(unsigned long page, u8 eq, u8 di, u64 sat, u64 sa,
  */
 static int sclp_sd_store_data(struct sclp_sd_data *result, u8 di)
 {
+	struct sclp_sd_sccb *sccb;
 	u32 dsize = 0, esize = 0;
-	unsigned long page, asce = 0;
+	unsigned long asce = 0;
 	void *data = NULL;
 	int rc;
 
-	page = __get_free_page(GFP_KERNEL | GFP_DMA);
-	if (!page)
+	sccb = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
+	if (!sccb)
 		return -ENOMEM;
 
 	/* Get size */
-	rc = sclp_sd_sync(page, SD_EQ_SIZE, di, 0, 0, &dsize, &esize);
+	rc = sclp_sd_sync(sccb, SD_EQ_SIZE, di, 0, 0, &dsize, &esize);
 	if (rc)
 		goto out;
 	if (dsize == 0)
@@ -323,12 +323,12 @@ static int sclp_sd_store_data(struct sclp_sd_data *result, u8 di)
 	}
 
 	/* Get data */
-	rc = sclp_sd_sync(page, SD_EQ_STORE_DATA, di, asce, (u64) data, &dsize,
+	rc = sclp_sd_sync(sccb, SD_EQ_STORE_DATA, di, asce, (u64) data, &dsize,
 			  &esize);
 	if (rc) {
 		/* Cancel running request if interrupted or timed out */
 		if (rc == -ERESTARTSYS || rc == -ETIME) {
-			if (sclp_sd_sync(page, SD_EQ_HALT, di, 0, 0, NULL, NULL)) {
+			if (sclp_sd_sync(sccb, SD_EQ_HALT, di, 0, 0, NULL, NULL)) {
 				pr_warn("Could not stop Store Data request - leaking at least %zu bytes\n",
 					(size_t)dsize * PAGE_SIZE);
 				data = NULL;
@@ -346,7 +346,7 @@ static int sclp_sd_store_data(struct sclp_sd_data *result, u8 di)
 
 out:
 	base_asce_free(asce);
-	free_page(page);
+	kfree(sccb);
 
 	return rc;
 }

-- 
2.53.0


