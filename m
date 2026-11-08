Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7DA606A33C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NdrKiZAY
Received: by kanga.kvack.org (Postfix)
	id C74856B05B5; Sun,  8 Nov 2026 03:49:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEFF6B05BA; Sun,  8 Nov 2026 03:49:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C956B05BB; Sun,  8 Nov 2026 03:49:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87CB46B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:49:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0ECF91201EE
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:14 +0000 (UTC)
X-FDA: 85411327428.12.50E81AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6716240007
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NdrKiZAY;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127752;
	b=8f3ZMgRiWz8/EOfIff8b2a7InArXGrKxlFPokBT5fet0/55xoFSR+mQ6ZHZy92xw/K3KY4
	/ygpWHlmMlVMGB0kTmUc+apmXqHUCD5KIvYCDVOOOKknwEAe2bBprIsNpUrgbwvxssC14L
	frN7n19f6m2cZIM/HW+hDvhKAi+voTg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NdrKiZAY;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGNxBWkVhvnkoWITzYnArgAKYt5qHu8eAae1zejckKc=;
	b=Ym1bpWIWUZw6BO+mAg9tmkg4ERiBnSJ1ENBxVTmtPqPWUOmzevE0QGz2Dmt5JZyx62FKT2
	O8/GnU2JXcKMw+QLYw71BStQzx1FRpsVfSnm0D/7cQeAU0S2RbubngN5KlsPYqe++NJB/R
	STSDboHlVriqEF3lwhJtnE+zGr/PJ2Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B99AD43200;
	Sun,  8 Nov 2026 08:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D15F1F0089F;
	Sun,  8 Nov 2026 08:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127751;
	bh=fGNxBWkVhvnkoWITzYnArgAKYt5qHu8eAae1zejckKc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NdrKiZAYWnQSggYG3kKUVOjbqpgcbntIBygXffutm+R+y7Iu8NnA+TW1MkLqaa8DQ
	 zWSTXQrWrjNHAOmQg7gRQF4yNLmjeai/Llm40gbtfdh8NNUVSO8azsrdsaHRufpdh7
	 1NqwUUnv5RBgC1TKurNFVIcfZrAvplYbJGxreDk2FGSxBzrWvnnuVQU3vq8EiMsE2l
	 bm2vbPQuLQzr8J+MlJMCFhTiLbeNdSfe0fvUZv19yKrYJ0txC5SHGDjF6fTIIDfidj
	 4HKvg7c1J96M+93FXMFLlOCYqnTT/fJV5FK6ewVD+GH9JYIFuJr+zcjNBEu6R7pQLB
	 IUZysE8iju+nw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:48:59 +0200
Subject: [PATCH 2/5] s390/vmur: Replace __get_free_page() with kmalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-char-ready-v1-2-3db507722530@kernel.org>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
In-Reply-To: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 4d7gkdjmjyodocwb1ncubhbcfxs75y1z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6716240007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794127752-824599
X-HE-Meta: U2FsdGVkX1/zcncSgaCxSqEIWwQvgN0GFshtJYeDShByx6wG/qMEWvA5dgAupJaTB9oexOJcqH3L6aIcuRHdIAD5sjZ9rO22uW11/IO17zyqUH4KrXh0/NljWYdc5g9ZIhZAoeVaDeRVz34Ipk7sLUwV3GunZsvTkSf4kb6S1v6s7zwmIf2BM1tjA9Wke8oO87e8ObGCaYT9ecUQ1K3uxYC5VUhZx1Zs+J1S3ch+LvUwRyGkWMVS2vhax2R0sqbQhidD3GmqqG1oU9M7VY8rPKqGLfRLMKNEJtuaDWHCYt1jJEKy+mUpimMg1b7L5N4TIpRbirzFN65d7XPJpkBlA4tw58qvCbmGq0bypLcRKHLzCjlPFl0+L7X8wkeUAGEN7P+yF8tByvE3z5yf278cHOXIPMTzkmIUGQcj0krh1maTE08+cWgTjAVaNS7MfBoO74/noENpgdQBLLiJ2Lb6bU/dbwEHYIkndpFfLafxaGJPx9XDZ48RvY7zsF+c934lOhv2hMZ9dabs7dFDqpSsF/Vv9hiqUXQhZq5G8fmoOc2CjPhpzvwfHVGxLkMqD7lvUxze8fZnSPmRqA9N4H2GIgrfcwAHMPUDwM1CZjMI46GexY2R6o3OJwu1wJQ88wiq7OcTZuIwipezImjfBlldHleCiwlKA+n8U2eivIfKhFbIhQ89q1I/zqBDCLduhvQUUwc59eXewHQ174gRAbYwnrzafkD7ZqMu3PJOMpNAP0TzLPQgXkySiUYzQ5rI50TLCnJLTqvOPYV8RvZkmdhDXIBWA2XCV9TC+wDt/r1Cf/7mOEMRfxq3/wJxOhD18Sa+5Yq1NRZnVDDZl0bgPCiHv97yuiMY9lgkJKdvl3r7ciJMPdyh3kEL8/qvB1rPvfju2XzFFq/NkP9hgrhhBgOvl4fTe4sa0ALHJy/22saIDd6AD4OOKiVMwtRIT1Wcm5SLSzSGcKQ0Fx/T5GBw3eN
 sDKuQZr+
 tB/RDV8x0+7H3upwJ+ExPgxVy0PYOdFq0hTPukbOGyS7LMVLB+qnKopLWtrGg4iAnshEs442jOqD+HsQ+HqsH90ol5nMq3P8+VU/0egBgm9IRwDabDEWEYNH77NbFTYDcE2dLp6wJtB0LEyX8NaxIB0CA4gNl+F47+iLTKg/7GtjF7dHJR+KZnI3kxaIs2aujQQzFaGwRbMZTGkU1XUlXoqJXAkACEBuZ6+JO5kMAv4gvWIL7CcRdm1xnid7SIFULt1tzJNvfgLrVI9ImniR4qMoiCMIa5/f9AMUvEdkQmVwRM4UYN41d0FKWIKSVpzVsTG2G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

diag14_read() and verify_uri_device() allocate the buffers that receive
the spool file data returned by z/VM DIAGNOSE 0x14.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/vmur.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index a47a40fac8483..a13839d70eb20 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -529,7 +529,7 @@ static ssize_t diag14_read(struct file *file, char __user *ubuf, size_t count,
 		return rc;
 
 	len = min((size_t) PAGE_SIZE, count);
-	buf = (char *) __get_free_page(GFP_KERNEL | GFP_DMA);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!buf)
 		return -ENOMEM;
 
@@ -556,7 +556,7 @@ static ssize_t diag14_read(struct file *file, char __user *ubuf, size_t count,
 	*offs += copied;
 	rc = copied;
 fail:
-	free_page((unsigned long) buf);
+	kfree(buf);
 	return rc;
 }
 
@@ -621,7 +621,7 @@ static int verify_uri_device(struct urdev *urd)
 	}
 
 	/* open file on virtual reader	*/
-	buf = (char *) __get_free_page(GFP_KERNEL | GFP_DMA);
+	buf = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!buf) {
 		rc = -ENOMEM;
 		goto fail_free_fcb;
@@ -641,7 +641,7 @@ static int verify_uri_device(struct urdev *urd)
 	rc = 0;
 
 fail_free_buf:
-	free_page((unsigned long) buf);
+	kfree(buf);
 fail_free_fcb:
 	kfree(fcb);
 	return rc;

-- 
2.53.0


