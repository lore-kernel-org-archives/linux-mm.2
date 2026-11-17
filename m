Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEFB606AF56
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BMM3NMnl
Received: by kanga.kvack.org (Postfix)
	id 091C46B05CC; Tue, 17 Nov 2026 08:07:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043156B05CD; Tue, 17 Nov 2026 08:07:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25216B05CE; Tue, 17 Nov 2026 08:07:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8B736B05CC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 281CA80452
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:29 +0000 (UTC)
X-FDA: 85444637418.11.AF9EAD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6BFBE1C000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMM3NMnl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4aAPS3La36qnAuTPtUQpT52zqdMUZ5MW1Cj8yEUWgM=;
	b=fi1IIBGBxSPf3n+WvfRvZpcHK8E0WE7Oq+EUn/s7Meb9Sq7kDq7trdPGBCmOAc4uOR+QXa
	V0zrtfBwTRPlONpNkQbaptwi1Atnn0vkkU9z+p2UBEOLG5wX2YaVBmH1JQaanLaHMBoWR0
	fVSrTjXBXxtOxPl6ThBHNlaJpjhoYcc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMM3NMnl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920847;
	b=CIi0/JSn8Lc/5rKbUJ9uJnd3xkI5Bu57M4mjVELKJbOJNBubMYvddMG++41lQRo3vpSxq+
	DDUmDXTrsd0Rme0cKrkW05VIlG+729Ck7M0cAjD5dzIhLH8/VGpdR+hx1UvvplclFoi+yk
	fyf78fXPcMjEs8R9musIIgXI8HsSJKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B419634B0;
	Tue, 17 Nov 2026 13:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564571F000CA;
	Tue, 17 Nov 2026 13:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920846;
	bh=Q4aAPS3La36qnAuTPtUQpT52zqdMUZ5MW1Cj8yEUWgM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BMM3NMnl5lZ4Rl5Wx6Pj9BFq+qsgQLIYxsd4DuJ/Y3390AKe7GJSFAHeFtvVM+JU0
	 KqB5UUK//gKrHzo+RGE+RAgfYHU/13DRgDpvSLT8YoNEPHjBTQT576ghUhJyXbXIAW
	 r9kAsbcdgFF7kZ3vr2pdmhbzFGCmR74/WIT/caQugksDOh1QAwGk4KtFNkMexZJfP1
	 59HGjcNCCsCOIRJr/Hdi3GUfuDcY3MaqDPZIWXU9OHJC1Xhb/4UhDpnwlNX3/M/1Qv
	 iYnr1lElTPTvrZF2ZMuSHkRxnW6y+KARdGpAXB/TlozaVMwhXlIoE3wa9J5lHOcGQ0
	 a0cxEU7FnugRw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:07:01 +0200
Subject: [PATCH v2 09/14] s390/sclp_sd: Replace __get_free_page() with
 kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-9-e518c99622c6@kernel.org>
References: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
In-Reply-To: <20261117-s390-sclp-ready-v2-0-e518c99622c6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BFBE1C000A
X-Stat-Signature: xu4u96nwu7ho13azsgzxfuonaxp4wwun
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794920847-345820
X-HE-Meta: U2FsdGVkX1+pdodPv5tTs2dN0OAdr8DYiaWcw7tr3v4H9EMM+/MiuhOqKptX0wuKCF+PhlOJcWKf4i31TuOtSUw2DCVxAf6/xttnbCbhR0ReHKn6s4nX+1y9gBXno5AEZJUAhn0rx1b0pEDcmJqkyDVviuOMADevZwgH2tbN+UJ2Zz970g4X8X6gM6/54obrHMdaOmCbPuQwQoArKjLLMqrvF+QYbLOl0b4nxFszhjYwqMV5O5gL4s31kGy844+0tYr7UHbTVblM44MB92xLY6hdVeTXw93ZMlv3MeOKk28+fE7LcJACC10SaJ9hgR7FWRUCRk/tyWSEBwptiQFfPx7gA4YA1/S2A5jHx64cbiqZazmq6mEZHizmaJDb4l7Vd7G6WWobRibwFtWuDRUp3DiPXmb6VU6QAlwNJA7gq45hw2ffuxmh8cqP3sxKkwe0NazpfJbeQgdH6KIhwVu5e9PBWcDHFsYPDRwh5vfq+CuC1W3xwA2urx8LxB1qqppQBTLzeR1YumOJnuGDCLQ9+OnX82qtuAiZ37iPk3s5hAwM8tPP1whEb/gmclVNUyyz2JP6Zt6K9Ud8xvp9LvFd++sjwKcJCftVQEM8zP+aFg+Qc3uvcE95FS/ln5pOC9clQKupfjEKicY3QN7AdPz6uK8g3Ac7ISix2Gqsu6ONm6bggSKQUo3xs+p/CuSH/O/G2q3pyQHyPbswFR5P0RVczyqYbfgdH5u+4gKXJzLsW46C/Auoec00MT9C0rvwKxTOLy5VtdDmLdDPr9OC5sSodkAtAULEKAI4OIU1wcCdrBr+RCXpGtLAhdEH0kz3b4Bk2NuyGHC+DlIHsem969ufbEZPS7/LVMUeXRxlhCIZE9DYwNC0xiRZ3aoY3oZAHPNJah8BE3gqsYPz/LsHejx9/21wHSYX7I7SyWzgvd1F9PwdanvTjwr9pDS7THXHWXmOarKn1wRPUQsxnSdCHkL
 0WXVSfmx
 VzXP4S2zD1fP5ETUh0mYZdufyELvboJNNBSh59gTyLAEC3zEaasQVhZfmvFC5OUY7IjdFajcPctQ8kWj/9eEOl+3teFfRSu6NSMGGfP5pFQYulpQJNnRqvNVgbrQMphr5Sj5SZR65Tp98fG9AV1eIwARangs+NZPfDaD7/MqAtyuie47fWIi4pUI7C4VU8g/Yn/QdapgSufWsUf9cq9d81XLOLYvl/abnbev5xmJ+xnswlw9gisG4rlaVpw9eu+phqC8DfZ9AIyhbmsBFTkmBeJqbXDSmBL1vM9R/9SCLHqIWLIaTrYkyKcrPzSO08l0ygD2zySaJCFaE/hRSzeAIJVpnsg==
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
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_sd.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/char/sclp_sd.c b/drivers/s390/char/sclp_sd.c
index c62b2eacdc13..cc0b4481e2be 100644
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


