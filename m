Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13145606A334
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jYlyVwll
Received: by kanga.kvack.org (Postfix)
	id 74A0C6B05D1; Tue, 17 Nov 2026 08:07:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720176B05D2; Tue, 17 Nov 2026 08:07:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F0D6B05D3; Tue, 17 Nov 2026 08:07:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38C546B05D1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:38 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF83540421
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:37 +0000 (UTC)
X-FDA: 85444637754.23.7A3C4EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1B23F40006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYlyVwll;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920856;
	b=6QwLBxh97aSNh8QnXrQT2JB/o2nrqqWa7H8XvG4uNS56D35BPysxs9O4RXXtAC+8Um06O8
	61jJRRB5PK8xbFibeQ9Ee6lNV3QTIzG90ptlYrtqNboYAJFRpGko6iyh3DSobcdx8gsGPj
	3aqzm9MfHKobxQG4CYnIy0eYyppyalw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYlyVwll;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgTNyWXJJEITijdTm//nXFVMQ7qfEthSD5JsfZnL/Co=;
	b=Cf+Rf+TNMuU1wGwzfd8XrqaP4OHUX9xbTCTaW5G4TCmbQdOcYj4ReQLipfcWYi2+MMLeFj
	5FuqML/YlADTpALbQoSL2NfCm1HhVZ0Ca4/Df1MokL9vlHZSicNAN1zxBbkLTlDh2HNXUh
	inUVP7mJKDpgV6X+eN6v/X/ia8X/L6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B10D663490;
	Tue, 17 Nov 2026 13:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C3F1F000C6;
	Tue, 17 Nov 2026 13:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920855;
	bh=LgTNyWXJJEITijdTm//nXFVMQ7qfEthSD5JsfZnL/Co=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jYlyVwllMRqqBz2IQfdVjoT7+cFM4ROU86h+VFinbusD4k3+w0oaHGtQmaBr0Pqrg
	 HCRtNjY0ZHfoz29ADL97Adgii61dewiRwK4qHl0rF3c/v19/TzNigQa6IprsrscoJE
	 67dAqp+utVG5RHLRgC1ROwppdiG676N0UybxP8jVR/K3EQ0DGIRrzAMWWfqDQDxq4i
	 u873O/SesKzjoFN74B/rYsobVlM4zyRWHiU0Xvf0PJ5lmSavlJGgr0isrE327woqeB
	 ThVP7Ab841Y/TG/aJrXEuVymM3NMgXem/GRlq7LTy0PkjTTNzGsSkVbZ7a8zl3q3FZ
	 IA3L6/s1PgTfA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:07:04 +0200
Subject: [PATCH v2 12/14] s390/sclp_ftp: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-12-e518c99622c6@kernel.org>
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
X-Rspamd-Queue-Id: 1B23F40006
X-Stat-Signature: 3ric39r8b1ppojsraeags9141zmud3c6
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794920855-330141
X-HE-Meta: U2FsdGVkX18j6uF2nns+jDoh9N7SRsxtQmswgBe0Y2PvF4FYxNGmTejMXHhYBmfgtRuf49yH/zR4hE4eDm758znEM69ZZEcmW46jNBeunInlHgXThzboAAMz7pTsb8IChPqmS4ruzsGbcJbmHkibmpFp9sdk4avPOPt5T86dSPsKF+zxKilbsWHyrgYCWl2LL7Jh/cFVLxNzi8VruFC3B9TokvPatenLFJfVqdE/VJgto7DohTOpsWiRiJoL2OaMFMhg8Pnb8gVoBqwJ4G5C8r94Qr40NzSUA97ctmGdgQUYVUL8WSr8n0GxgXDhGWKufDBd2KuoZ71XIfXDfsyCN6gEEXtZXBWW7kTfByK329ARJ/kTr8DZs92B/RJkjA5FDs6oTD2VlSqpCySvUPY/MfzE4V8CnVUtU0Vf77CItHTsnzWuxybAB2nOGSROCEPJ5XP84ujIM59HEkwCtEpBesERIaGK2cOjSMrhBpi3Q9akhLv8X/FMJ7opEgCI1sfSL9A9dws3oQ5NcQhaptYz/IzXhinU+Aiibfcktvp2lbiSlkWsrqRn6RgIgyGe72nx0XnaeRBjzz7pncYWxSoRN7QzAObysEqVA5+brS6FTPH84EXw5nJoEXf0DzdT1ifjIl0rG350KPR9uIUzCb+QTYPqCPW3dyqUHRIQaYL+x4aGH0Zv5kfdX/R0ulSiRCR3hkDz/Jr3iwdzG1xuXt2boM9p6y508fsvCkUg6U1SDSo6Nso0F9TwsipXhvZI9bNI7A98jzGTZlSUj8vttvfB+Ytl9DKgw7yUaj7loaaIksb0QzIQYa8buva9hj1opyX17AQxftq3rtvkJ/OSr52WShxHrF0MYAGTqIIJ6REPl14U2yh0SzkG1H0UlcOvsn1rpza8QaglbN3JGMPOl73WwUgw4H2tvzgh7E+oBZZaeFivaw4/erbCh2g3q7XdYhwDgLHDk+SbHWzSXagrC6j
 uZE/B/5p
 hXSR24Os1wJ9M+byjaW5jrJYHf/LwcHbJUwPzR437bdkz6JRoz6nZ3wlqgpgw4CxTqOFF6Lrhshp/q93dPTqnDNIOYnjfvFk/U0QPJAFupb4DLvVGcsbVLk+4QRzVEDWNoUxyZPvtYg7cQWChCVyMQGy+Jxi0y4xbusRZqGl7hsacAgx1YmOivfOEH5SduRD7iK+ta5eBWGA7a9k0pvDT8LfkzlkaZq7oW9fqMguVCTUuqLB9aWGbPL2PCxDXX7DSd3zEjWVY024LD759xB1TC8gSd+Fbz3g35AA2jpNyG7rY1dq2+1onEOGwsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_ftp_et7() allocates the SCCB used for an HMC file transfer request
and sclp_ftp_startup() allocates the buffer for the SYSIB 2.2.2 stored
by stsi() in the debug code.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

While on it, make the SYSIB 2.2.2 buffer a struct sysinfo_2_2_2 pointer
to get rid of the casts.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_ftp.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/char/sclp_ftp.c b/drivers/s390/char/sclp_ftp.c
index 853492d53953..904a53ecb6ed 100644
--- a/drivers/s390/char/sclp_ftp.c
+++ b/drivers/s390/char/sclp_ftp.c
@@ -93,7 +93,7 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	int rc;
 
 	req = kzalloc_obj(*req);
-	sccb = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!req || !sccb) {
 		rc = -ENOMEM;
 		goto out_free;
@@ -155,7 +155,7 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	}
 
 out_free:
-	free_page((unsigned long) sccb);
+	kfree(sccb);
 	kfree(req);
 	return rc;
 }
@@ -241,7 +241,7 @@ static struct sclp_register sclp_ftp_event = {
 int sclp_ftp_startup(void)
 {
 #ifdef DEBUG
-	unsigned long info;
+	struct sysinfo_2_2_2 *info222;
 #endif
 	int rc;
 
@@ -250,11 +250,9 @@ int sclp_ftp_startup(void)
 		return rc;
 
 #ifdef DEBUG
-	info = get_zeroed_page(GFP_KERNEL);
-
-	if (info != 0) {
-		struct sysinfo_2_2_2 *info222 = (struct sysinfo_2_2_2 *)info;
+	info222 = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
+	if (info222) {
 		if (!stsi(info222, 2, 2, 2)) { /* get SYSIB 2.2.2 */
 			info222->name[sizeof(info222->name) - 1] = '\0';
 			EBCASC_500(info222->name, sizeof(info222->name) - 1);
@@ -262,7 +260,7 @@ int sclp_ftp_startup(void)
 				 info222->lpar_number, info222->name);
 		}
 
-		free_page(info);
+		kfree(info222);
 	}
 #endif	/* DEBUG */
 	return 0;

-- 
2.53.0


