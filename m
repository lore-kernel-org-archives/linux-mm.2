Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FEDDC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8603D6B00C1; Mon, 21 Sep 2026 05:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837FC6B00D1; Mon, 21 Sep 2026 05:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774A36B00DD; Mon, 21 Sep 2026 05:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8226B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:57:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9806FC0570
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:57:40 +0000 (UTC)
X-FDA: 85237317480.22.EFA5CAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id CCD51160006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:57:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n4CEEleJ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789984658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kegxLK5Xa2bs3Cf0CvHFhVg7I1jBlelgO0k5ZXmd+8U=;
	b=vpm6NsQtlOGDVfhcoypg5mUy85a6BZ8QgxCrhjQrEJPyKjHbWxtQ2MYxfd7GpbCDOaE5Zb
	LSiKdtGOGMEQjbgFLu9f1iWXirsxrxaDz4PxdVKzFgSRorVkFHQrKNynro9rtCyDRfnlbs
	s28GPqehfbMqx+hBnRgWhP5zm7da3y4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n4CEEleJ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789984658;
	b=et+5FNIKc3OH6lHJF7AWAkchfOJFFFNj5lFXGII72IcItfU1R+yykbJA4KAb9haM2U8QOr
	U5Attnjag8wByBDfHwE/Ctf7gTbGaoWF9h80CQNw8nrr26oXcv8zzHt27imcdji2ZU483a
	wBfc+J7+1S2OacAWrDaxAIZvs78KBjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03D8342BA8;
	Mon, 21 Sep 2026 09:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AD41F000FF;
	Mon, 21 Sep 2026 09:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789984657;
	bh=kegxLK5Xa2bs3Cf0CvHFhVg7I1jBlelgO0k5ZXmd+8U=;
	h=From:Date:Subject:To:Cc;
	b=n4CEEleJPatRciYjxloAv3UxR2CitO2bLF+5DnDH+nxZCOKw2fVEo0AfrFefdj3fd
	 bTfN4tOkVLF4xeEwxx7lDK4WI1v2AbFjBP08Tw5HCs5c/SCBm64G4rFtbt2EnjRkNV
	 lsaTnWW2XZEEIynEBaLEb08HLEHIP4TBFvCMwLv31l8b+l7kNfz7MONouFI4202ub6
	 DRdZyKG59NlKsM+LlyDu+HQBWRsBKgLcezct0xX0JNmX3UVaLikOUav39wcU3qCsO+
	 cRW0+aSlBP+kSdYCuSmI+vQ0bbUBlpHNE2yEKlrWUESq7p+UzIAiZd5oDS32/GECE7
	 1ohKziwONnMqg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 11:57:29 +0200
Subject: [PATCH v4] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-nommu_gup_pin-v4-1-c410041cc479@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIj/sGoC/yXM0QpAMBSA4VfRubayEeZVJDEHR5m1mZS8u+Hyu
 /j/CxxaQgdVdIHFgxxtOiCLI1BzpydkNASDSESeSC6Z3tbVt5M3rSHNhjFPJS9UyUsBoTEWRzq
 /X938dr5fUO3vBO77AQJCSKVxAAAA
X-Change-ID: 20260919-nommu_gup_pin-df63917c8182
To: Andrew Morton <akpm@linux-foundation.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 David Hildenbrand <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3766; i=david@kernel.org;
 h=from:subject:message-id; bh=HxMJunxqlMOF1zZ6l1Ua107s6bmir1eB6BnonPlsO6s=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI2/O+1789v7He6cPbfV1lDve+Sj+Y/PfJV44PfTueEf
 8KrGqfIdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRmV8Z/pl2Nd+bwxx9UGy7
 pfauB1ISljeTkpsaf21M5hD0uf3E4jbDP7uH4u32DfF9CXYxHIYdbusm2hz/sHl3Zt0erQO3Xy6
 +ygUA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCD51160006
X-Stat-Signature: 7untkxjo1w4rge7mcjntuub5ayw6qwxo
X-Rspam-User: 
X-HE-Tag: 1789984658-430674
X-HE-Meta: U2FsdGVkX1+UJRuFthTINaxJ7hEq0N6uwZZgfa4R6Y1Rhcl2U6+ZTGXpY4I8MH0XAINtSK9ZpObTMNY3H34mlvelsRzjNNkmaR8Dc8/HnDyt1CRIvV1xHewipX3AXNiRiRRX+fnOpiv0qtrfpcnN3Nlq0YYhh90T9gmlGP060+AB7Nxb9vAJgI6NvmRad5pfJfUDpI3IK5SB1Wz9UZnnONWp2J7D0T9DxPX+xOHrU7v1dUC4OI5r+uioRRvs9HYIueNCDimSWvd1/9u5Np9eryFihq19ciGSjck3T2h5/VPFPbOX0ocDAKxwbVrFN5YI176S0ZnGfwyo5jmBEd1nSbZBEKfV573BlfKg6k/CDpEjnyfoYf+I7epcW1B5LEN9ZckcvXvJM9AmMWad6GvBQ3VSkQjkud5JG3cjV9oJXFoQV8/jVv2+YoTO4WpDJinp5ilQgvTTeM2t408JWiAJJ7X3HUfq2QI+tUEJ/IJpIM7EUrxWIYDHqA/3uwWE0sFqRBbeVwR1O6K7ToIlI8QsWHYGRioicB3yKdI2rGpv3mw5Z97I0J5U43oEciePrrdcHwjseDT8qGiA97Egaw0j6YtMmACwZ4ldZaW0OTCy3sTHgLOXFgUBjE2Uz0hNYm93HHUu4Rh/7SaTd9Rz7ETl94yY1zKr4CS43ZLCPg08qM2yD9lEXQdUbLT76zTdZMXau28jDVWU+RMeQ1LWZRjcLX5uhAdc/U1B2LxhCnlEXjS7nyqqzWn/13AmgqpFpruyYsDFNoGsYPfqRWVi9u5IcfoEeMl98GuG4sJjtfEjuESzLVATa5nJVvVaielopPxK0rII3n39bgb/hwa8XnaFnZCZyvaT3TBAbnOsdmepJV2lrSLjcuDxI64Cn1cS9j9opMhk7nieQYw0Oe4wz0AmVLwh8sOmyWuMIcNwbAmxHdV1C7c4JqSOZvImfLfiCckLzu8vEh8+bFBKYfuYOYp
 zXBqd3u6
 SOm0Rmsfddgg/1M2VIluEgYIAA53m7H5MyysOtfM2+B4LgU9rJ0hdd1P1rwfuo9nK+FgND7zqRSLVqpFQHZ2a66q1sSy8c6qOAbybvtnMCqX0zqnOM9TkdR+3R2NHJK34PkgJEUoMdoRv5GoIg6YcvHPJZEYIpTaQ2RaLsKn/OSV3NFtACxinOXtuIDROAAu38h9mHSoJVllQwL32oGjXXfZu3rGKZahZrM+g4133Miq05HA63FVR10dWsWhrimUctvMaYlijtzqWSYENoeHq6BUVjaOwIrMdPGxFrFnc1e4BglGt78vyQ8BFIZZf8aa6GTpYBjMaIgonthOQyHfsaIPP11S+rILPY3lgqpYcV1RvV7i80Txc34duL+dQdDmYJpVMox9LVVlzn4yaJOq+Z8Udx1quN9tE9ttIvaGodFycd31JPiEgdImEVYmUFfl99/2FCqPTe7svN9PvPoiOE0y9oylrKAjbepllVf9acGv5keEHHCR9cS8I5FVbi8nsA50RG+x1wkAx2Ak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
get_page() reference for each page regardless of foll_flags:
	if (pages[i])
		get_page(pages[i]);

This is reached from pin_user_pages*() with FOLL_PIN set.
unpin_user_page() is shared between MMU and NOMMU configurations and
unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.

This means that pin adds 1, and then unpin will subtract 1024.

If a user maps a page (refcount 1), registers it 1023 times as an
io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
the page is freed and returned to the buddy allocator.  The remaining
1022 unpins write into whatever was reallocated, and the user's VMA
still maps the freed page (NOMMU has no MMU to invalidate it).
Reallocating the page for an io_uring pbuf_ring then lets userspace
corrupt the new owner's data through the stale mapping.

Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
symmetric. Keep supporting the traditional behavior where users specify
a pages array but don't set FOLL_GET.

While at it, don't return NULL pointers in the page array,
as this is really not expected for GUP users; instead, just fail and return
-EFAULT.

[ david: support traditional behavior with no FOLL_GET, extend
  description ]

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Reported-by: Anthropic
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
v3 -> v4:
* Put FOLL_GET fixup into the NOMMU __get_user_pages_locked()

I'll queue the updated version after some more review.
---
 mm/gup.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index eb898ea1ee22e..4e9b5ac2cb62e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
 	vm_flags_t vm_flags;
+	int ret, err = -EFAULT;
 	long i;
 
 	if (!nr_pages)
@@ -1999,6 +2000,10 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		*locked = 1;
 	}
 
+	/* See the MMU variant: support the traditional behavior. */
+	if (pages && !(foll_flags & FOLL_PIN))
+		foll_flags |= FOLL_GET;
+
 	/* calculate required read or write permissions.
 	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
@@ -2019,8 +2024,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
-			if (pages[i])
-				get_page(pages[i]);
+			if (!pages[i])
+				break;
+			ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
+			if (unlikely(ret)) {
+				pages[i] = NULL;
+				err = ret;
+				break;
+			}
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -2031,7 +2042,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		*locked = 0;
 	}
 
-	return i ? : -EFAULT;
+	return i ? : err;
 }
 #endif /* !CONFIG_MMU */
 

---

base-commit: 40288c9206c17eb66a603262e06a58d300d0f279

change-id: 20260919-nommu_gup_pin-df63917c8182

--

Cheers,

David


