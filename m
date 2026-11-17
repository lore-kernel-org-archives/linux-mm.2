Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75FA860A6F57
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mS5UGHdM
Received: by kanga.kvack.org (Postfix)
	id E26466B05C5; Tue, 17 Nov 2026 08:07:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD66A6B05C6; Tue, 17 Nov 2026 08:07:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13B96B05C7; Tue, 17 Nov 2026 08:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3A4A6B05C5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:07:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DA0C1A0435
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:20 +0000 (UTC)
X-FDA: 85444637040.25.DD3AD30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A460740004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:07:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mS5UGHdM;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920838;
	b=jX80HUxOJ67r/o79cvrSm6IZ8eGfdH4cU12vJ2Gt63xw9vO4oyUMOJvING0z8H+iyYBghr
	0RkYNURq71QKZUPMBjF7qnzTnHHvid0w88KSR0tmAt60UgYfSEjIEZJCzD3L7DN+grCGHh
	Cwx7VGlPbmJ1KK25ZGzWzePNI7h8o9M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mS5UGHdM;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iJKQ9g80TKCxV6YWL6c9OznHwGGtVqmigy8uKmIx1U=;
	b=odQr3952AsIS9lxQXXN9k3zj1U7UJNZ5OSP533mN4zPj+IOB2kFgMZGZnsY800kzYGzUeD
	ELDw+UYAg6MfrP/zVg0FJnmwdiVRjHxOdz8JdmTLlC+vbI1SyGoAu3GQ/jNE5juLpqNBR/
	UVpSQ+GEObhlazPYhYoPMqXy+Z4ZXLg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C742634B1;
	Tue, 17 Nov 2026 13:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B021F000C4;
	Tue, 17 Nov 2026 13:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920838;
	bh=2iJKQ9g80TKCxV6YWL6c9OznHwGGtVqmigy8uKmIx1U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mS5UGHdM25I1zvDIW/JSvdij8sfG0xyBzoMKH2NmlGlELEvFwgGM04Ifz8uTl9+mv
	 liwOuPzVlCZ/x0PFIqZUBjILwamoxTHCYk+kgMmRo/BHhbL40yM1n6ZD5z/9nVuTY+
	 /Bal6Pt+cOHec+erubCJFcd3a+zc1EH2ueK/NOnVdNsVvn5WmCgnMWLc3gxWNvGxPJ
	 GXyvaal7RA0oc2B8OSCvDVPGBJNfajf/7ZJPCKX9Zfexfqx58+vXik2EaSixMpw2fr
	 i7zjsaqWFDix8W6Fmff9fcIIjQFNVY3DXTqdXHXqi7gmf8t3E4OQb3uamKmsO5Rhw4
	 vg0eQ255Hum3w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 15:06:58 +0200
Subject: [PATCH v2 06/14] s390/sclp_tty: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-s390-sclp-ready-v2-6-e518c99622c6@kernel.org>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A460740004
X-Stat-Signature: 8q3gbq1njsgz4ymnrcx41jgyo1zp9uus
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794920838-880076
X-HE-Meta: U2FsdGVkX19YZgPQeUeceXrsqAfuKthF6SRzTT5bgAGVOXS+PIU6XLPp2nSV2UV4SVTequ4+PdBtiGixFiKJnsIycsmqZQ1WMvpaFCPY7tAUFPHYLb0/ub8oCUxQy2y9CX0OkjaPjgDcDUWzh4XCjO20FQs4C+y0WJTh0vXLZmps/87bcDDsQyEWZHOZoGqzqgYYeDQ7nZurMI5gq6QMogW8ar8pegyazjckDHjIq40Px817WB/oGPf6SEcewjfC/lg0D0iAS7++aJAmRIrPqCGLnkZkw8Eiu3wH4W1T35AeuNDqowYnqSD4klQFK4ReZm9iDZlr6a5DPZMyjBTaWzmaKcTfMUSZOtKm83zap6oZtnwmb4zvlE6rj0y1bBJ/sFv9MUxlX0zFchjGpu7KQY7JfqT30B/oNhu4EMg5CGG0TUSuajvft6cLwe0Zva0KX+v36q9CTtPSlJxCqlnbSFIgsHrSzTmXw0Z5RO0RdW5fweNyh7zZwyH3TsO/dFZtvguQ/Jxb6jUm0/AtfqboFhIR0OTA5KhgfyR4y0JVbnGaZywMH79rFg2DfgXL+A0pkcPNX2tGHQdYuflom/yMPtrf7mGE8uHnhCaYN0phyABEidCqOFKl4eVmoSuHc86K/gQe+LIUfLaD910D4rJ6TctrBhnWCfKW7NAMvMqj0qHPfTFD37bjHhjnBCI1xSIYqHI3+xUTUnaXVnb4JVcFrLi0XF7vtLmWvJGQcvhSROwH/fQ1OwmqaqILL1+8R/Rd0O57ahmjTE4AfbhKHWF85Ko1btC19jAHoHIr9M1kI2kOQRfJ7rLupoVpj7PLGDCaMXiRXLbHXqmYyX6uAk50NviGHdB2g5wgNReG0FCZ7TISxT/JZAf1GnIjiPojyBknxoLdYcgpRBHb05xb2JNM6JEHv/I2B38gmo1o8z2G9VrnMYJMm0N6sxa+3lvhY6SZv8si3Xng9MtR/UedIeF
 OLCHLyTM
 k+HK0oVoZVld4k4clmkATT+XEGZoHH7dQrW5hAp3OhXQorMjCbWHFsoDhWNd6DowdTmbjRMh+SgDKbzaKF7BaTv3Rm6F+AR74QZlcvxGV59uNMTaHw4gYpF5ziCqhv3EC+yMn+mCBCSY9zSTvP+3UaXj0xeAO2nWwE7fI6OMXTtkuc7b8xD9PCxSRu3CI+hhiaQmtqlZihiVgA0BNYMC1X447Jlj+PM9yhoItY8nPzxnrNCR9/GcGnm//MJZCi/SysspEKw5AcqdA/DDIunSpX29nfIiy/YIg6ic2YysgpzdNJuyNCIAcA4EAX3b1wipb6gst2CuPW7+eSQmIFwIe4oYFuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_tty_init() allocates the SCCBs that are used as the output buffers
of the SCLP line mode terminal.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_tty.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 0a92d08830e7..e36739bd2732 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kmod.h>
+#include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
@@ -497,7 +498,7 @@ static void __init __sclp_tty_free_pages(void)
 
 	list_for_each_safe(page, p, &sclp_tty_pages) {
 		list_del(page);
-		free_page((unsigned long)page);
+		kfree(page);
 	}
 }
 
@@ -525,7 +526,7 @@ sclp_tty_init(void)
 	}
 	/* Allocate pages for output buffering */
 	for (i = 0; i < MAX_KMEM_PAGES; i++) {
-		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 		if (page == NULL) {
 			__sclp_tty_free_pages();
 			tty_driver_kref_put(driver);

-- 
2.53.0


