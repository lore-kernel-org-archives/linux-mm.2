Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579C4606A335
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=b7biwU9a
Received: by kanga.kvack.org (Postfix)
	id 46D236B05D5; Thu, 19 Nov 2026 10:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444856B0696; Thu, 19 Nov 2026 10:57:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381396B066C; Thu, 19 Nov 2026 10:57:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14F336B0696
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:57:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1F76C0B2C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:57:22 +0000 (UTC)
X-FDA: 85452323124.04.1BFF869
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id DC817180009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:57:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="b7 biwU9";
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795103841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wL9zRdjFVzJ6psamOgPyoRa5vDWjyqfaLzG25PcBd7c=;
	b=IXVOwmiUD9wWpCbC6AvjHuC3iEhqJo/4liMOGbx4EBP66C4KMeS/bRB5fKUFhE9Tp3vNoD
	YI6bjV2MCTb7LSKH+M6cIwk8OkUGLogM20pEyekc8nXS6JQip3W0wd3TviNDswsXx8TOA8
	TPN4Jb9KKECqJxuQ2l0hm/b8tY4v26A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795103841;
	b=IXCPtOa9izsXsqRNOJ/aGnMHQoPnMiFjGuNDXB5S7NsWkbatHKibdftnsgtaVVVqmQ9cDv
	rWRT1DFJ1geffzlz/n89eQCrBivzKjlUc4Ru3sebJZri4qQrd/g/ScftKMbGsFsuAQ4izG
	tXQ764KAtgaMuNWgd3+i1pe8uaXhxKg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="b7 biwU9";
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=wL9zRdjFVzJ6psamOgPyoRa5vDWjyqfaLzG25PcBd7c=; b=b7
	biwU9atXWkfGHRDy9IQKAM74YE2OHdt0FTL8f2EerLj33tga+sRKjHR0LB8BaxNVVph1T50++h+dX
	5u5M9hoBaL0KfC/jfrgDRj9T7/wRtJrwmSo23gp/vnO+Ik4xNpZYmL9KsZ+TLHCucloLETqBDnbDc
	XfBFApDeoDTNjsdxCZBQuy5kKQWOq3s0sKRK+mtYZday6jScF5i6VbP6+3rbV8Id69y4DVn/Pg2FH
	fHYGPN8ev7ydD6FOcTo7b7ZhDwEDm41KwkK17ylat6jQ2od9Qd9PXcs4DNONLC2hlp2VIVW4GpezA
	Dli9MRIfaoE1GjEIsO9+Qh1f2b0OxBDw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xU4VS-00000005VOH-1Ol8;
	Thu, 19 Nov 2026 15:57:02 +0000
Date: Thu, 19 Nov 2026 10:57:01 -0500
From: Rik van Riel <riel@surriel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, John
 Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Peter Xu <peterx@redhat.com>, "Liam R.
 Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Michal
 Hocko <mhocko@suse.com>
Subject: [PATCH] mm/gup: unshare-check every page of a pte batch
Message-ID: <20261119105701.3f57ac54@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DC817180009
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8ntt3zdeuxrxtsnjdmmfkygfzay71bs6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1795103839-942825
X-HE-Meta: U2FsdGVkX18e3gICTQu3rdjNsZVKYb7zoy6gPop9g3AC1F9wrrjzqZ/pZwZd9HMkslRVobRUqSGR9i5A2wB17qP4h00Esnc1Km+lPH5hNOnb1XNUtpNfxg8UpFLPIOyYqkXQTdXCaQR1RNb5Ojn7mxjmpKxN1n4u8Ers49uO9+R+DKP94X9LJLBvSxu7g6TfR/OVa8oZPrEfRDdRdgVkQbvLMhNw0OrlKUGpdZpwt5NhPNrFNeEQ3NRQmWidtoraZU7ckKoVgSX4qoRf2WODo2W0MXj/aTt39BHC/adf1KJTNaBqJQ4EGhZ1WPNhKbaqD/1ryZwg+2aC2Z+uNXq6jP2nRw3H8xjWOLN1oTM1F0oZkwZbIccHCfMK3E1/33hCuAIm2D53qVq7HgKWJFHbBpZd5jZIxzIPDO4I8+uZZq9r/HbxbZLd9g6zTGTkatjPafJwizjyOxXwHLR5Y5CcHh6N8ZDyHZplZK38TjHkJba1LJsqMWaa45ZLIAcWEYEX0MimzFiqxzsJ6KvbYXFFj2yuyXiDfbhx7qKEwdM7H+pQbrBzXhaRj1HucmGOGP+VNgKjw/GqaVCxFRMbBEMh9SnQUqOgYTG5+h8x8+gYDoB7mc0z1tMW9o79RFoS7O1TjnLHwEV12XJPzBRDFuj4b2SMS9KpKMvFTR9uThk7z2xWSBkx/CsczkPb6YV/wZGmuE6pb0hEn5uU3Olv2ESETIbO57bRxwu891/6PPZTdvzwFMVCsFfb/1Sssok6lUx5wKBVxwxHNQWyo5Q80jSrfNZoTuZV56WIhnSGllrEjfz0mD20HUO0s+IvptGtW37LtAe4IprH27V8HBW2TXRI0UgzAAePqJ2ZeNwKt5RWyTNlsPEjZSfbvlplFrGpoFpCL25z8DxcOGTK4mYvCQeO+83aAyoA9bHAknErfmBG24YvLhGYwEZQISvUDQ3l+w2qCqbVTWPHUxXMgQNAXQV
 GMcQmPbV
 cp3I3ErKYTc8yOtAX/rQ50hyZ+6ezNlHcDsOki9903/yslsO6Y5sIU0kj+dGxGDlRGIJyuscFNkjPGiouo3pl96cjf1oDLOW40KFRXw1q1JoKf9uVQFz1fgWMVDxAcrS0echJu/0GMGYO+qQkxq9Jj8wyB6r6vJBYzzROVPkA3M9t8o3t+uwKwZq7mxOApjRu7NdrhaRhQKPmj8RLwMmTEbVR7qoMfUNPxfk77JoZWE1kmX1gMhE6ujK3bGcsDouW8AAR5A94EmxPt7O0kFx7jbCHoLyIzG56cBUQhmrCOv6oHDKCrSYa5Cks2jpaBxsaFxh6ChE2pJJreynTpLozXXHSCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A write pin over a PTE batch can hand back pages that a later
write fault replaces under the pin holder: the process writes to
the copy, the holder keeps the old page:

    pin holder                          process (mm owner)
    pin all 16 for write
      batch passes unchecked
                                        write to a tail page
                                          fault copies it elsewhere
    read pinned page -> stale

For every FOLL_WRITE call the helper returns the whole run on
the head page's credentials, never reaching the per-page loop below.
After fork, a FOLL_FORCE write unsharing only the head leaves
the tail pages read-only and non-exclusive behind identical
PTEs, which batching (PTE bits only, never the exclusivity flag)
covers at once.

A page pinned for write must be exclusive to the pinning process,
and one vetted PTE proves that for one page only. FOLL_GET and
single-page FOLL_WRITE keep the shortcut; multi-page callers run
the per-page check. Writable batches and GUP-fast are unchanged.

Without this fix, the pin holder sees stale page content,
with it the pin and program address map the same page.

Signed-off-by: Rik van Riel <riel@surriel.com>
---
This fix applies on gup-7.5-ptebatch in mm/core.git

 mm/gup.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b0a0019de80a..6b6e4c6f8144 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -639,15 +639,25 @@ static unsigned long gup_pages_not_requiring_unshare(
 {
 	unsigned int i;
 
+	/* A short term reference does not need the pages to be exclusive. */
+	if (!(flags & FOLL_PIN))
+		return nr_pages;
+
 	/*
-	 * FOLL_WRITE is implicitly handled correctly as the page table entry
-	 * has to be writable -- and if it references (part of) an anonymous
-	 * folio, that part is required to be marked exclusive.
+	 * FOLL_WRITE for a single page is checked by the caller, which
+	 * checked that the page table entry is writable, or FOLL_FORCE
+	 * on an exclusive anonymous page; if it references (part of) an
+	 * anonymous folio, that is exclusive.
 	 */
-	if ((flags & (FOLL_WRITE | FOLL_PIN)) != FOLL_PIN)
+	if ((flags & FOLL_WRITE) && nr_pages == 1)
 		return nr_pages;
 
-	/* folio_test_anon(folio) is stable until folio gets freed. */
+	/*
+	 * Check each page for suitability below. The caller may have
+	 * only checked the page tables.
+	 *
+	 * folio_test_anon(folio) is stable until folio gets freed.
+	 */
 	if (!folio_test_anon(folio)) {
 		/*
 		 * We only care about R/O long-term pining: R/O short-term
-- 
2.56.0


