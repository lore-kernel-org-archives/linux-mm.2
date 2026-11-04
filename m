Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72C8606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=VInwpyJv
Received: by kanga.kvack.org (Postfix)
	id 8E5496B05B2; Tue,  3 Nov 2026 21:09:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BCF06B05B3; Tue,  3 Nov 2026 21:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D52B6B05B4; Tue,  3 Nov 2026 21:09:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 589556B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:09:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6394BA8232
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:09:21 +0000 (UTC)
X-FDA: 85395804522.18.BB596C6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9F8EE1C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:09:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="VInwpy J";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793758159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PvvmTIC+xa1Yy/jymB0jeQjmM6XsPcLJd3t+U1N/8A=;
	b=2w71yzuPIoPALQVLeAb+H6O0PorGUv5hGa3WWl3+BRPTkN0ZAZL254tuZtAqKt6K1p66Wg
	QGwNsD4UCcJWHJx5LotJiSbwRdgEfe+2BXwn22AF8GHpm0ObWIqVVgt0gKbe7uaUnqlsK2
	DoZzpIUj9d+d4MJxVnF5Lwv88pf2WJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793758159;
	b=H+oTCdAxLvhYGK496UImVh6zktHrEYnDp58ENmu6MA6HcR+S4ZyDJ7Au2A+1dSGuOxvHig
	5VYEWpQkpHMjtdyhCa0OF7AOfPMle8nu77z618lMimHHYCJ/xWn602/FppW3Pz+TPMikxz
	wMFIc/rgxTyprARDtew/utMSeg76yig=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="VInwpy J";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=9PvvmTIC+xa1Yy/jymB0jeQjmM6XsPcLJd3t+U1N/8A=; b=VInwpy
	JvVIXCDo/LHBgZ8Kj6utwxJ8KCGXohr9RwEPTqNExSSE5IObAantbD/wwpsHxhF6nJ32pOLm6t4C7
	hLyv6GgWDgEQtAuvnrcy+U/l/0btfVyaJArEr6Fa5L8OpiU7kYW2WPkKBYk5BDeuj4J9aS9Z02/6k
	KESryuflPEfcTc/zAvl/cvi0m4tmc1+6WtyeQuq9NDGS17j0ZXHMztsf52X6Dbz3u1C88Gb2hOkx7
	i1fwVfaOsdoHiDtQ5PvL4Ir1LxxWcRyH1YRkhVqudffximSsb+f8mqh93ggg8mPw0n0IxU5m/qQNn
	BV6Zf22pb/otl7EVi1GFsESO5E6A==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xOQQR-00000001pVT-0hEE;
	Wed, 04 Nov 2026 02:08:31 +0000
Date: Tue, 3 Nov 2026 21:08:30 -0500
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>, Andrew
 Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, John
 Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Suren
 Baghdasaryan <surenb@google.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org
Subject: Re: [PATCH 8/8] mm/gup: batch contiguous same-folio PTEs into one
 refcount grab
Message-ID: <20261103210830.2870eaae@fangorn>
In-Reply-To: <1affac11-da98-40b3-8cc2-6e8374b5ab69@kernel.org>
References: <20261102193026.3860700-1-riel@surriel.com>
	<20261102193026.3860700-9-riel@surriel.com>
	<fa017227-448b-468f-9797-33c02854f018@kernel.org>
	<9d1572bd5e868d3c9d953aa5fae81967cc81ba55.camel@surriel.com>
	<1affac11-da98-40b3-8cc2-6e8374b5ab69@kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: mkuse3m5bmmwdss6rpc13u5aeas6k4fb
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9F8EE1C0004
X-Rspam-User: 
X-HE-Tag: 1793758159-230513
X-HE-Meta: U2FsdGVkX19KbpKeuSGi9PDvhzrXUAHhs9wN+dNGFlGYaT4QvV+EWW8XpJBzp18ZpWfMA52oQt5RZWeMsYxNiBT7xgurwSdSaVlixIvqeiAB+OZWssHVbKZd+wzeWaxGyZMVl6VP1hoqCq/6WpE0NSnfTDIPMzKNnwq4PVX2ivNUsL8GLEOvKOD7NUAvb4YRgsEtUgQfE2Xa/hOntcGe0KwyinvBBc+Gc7NSITo/XLxU00fdewix4DiWQ7eyHXMad/cddJKlOCdWjZUk0S8zjFNvdAsycix03LY6x+Fv5hU9gr770yEBheRKVFEOEKZ02xdW4pR25O0hTPX7wPBXeyuUWhOJ6sWRgzfgvIU3vlPpdOOqEb/VrNBbwRe0JLPXeBmxGhOYnxK4CLt/3H0v32k30ofyneeDZN2enb7lWxYuzmUgr+7MTW+6dzivVNxYqFRnvh2XZnR8TiEh12ZG/bXlsnpEy0MKlKQ1LoK4Oml6Zv0JnM+zdOy0iufjvhdr6NKjL70V/ZCYTTUwxdtrxrxYaZAznG3OmQnztuwRKKcW82OMDGFjQSNZx11ZhcphPGSKeZvmlLNgpDKvrVqXqxnjcvB93Kd0tFdysk17S/E/q/gmle9qNW3rDPiyskhP7+LSj5CfwbvQulvgdb3gCEHEem5DWTfjd29dmk4APOhEoJ1ETGm/ExLarrGmIMRNahmvS30iluIAK/gLg7JGziDInUHd8ggA4NbEZ0W4+3lCv4gqy8G1gYu1p7P66eFCgjRxM+YAYJ6CRraQag4+8FrvL6dMlKhfRu5J6MnTa5UVMpuw3VdhS2vz1GB2ePknKcGSqQYmTbfQPKG3mPMMjuEsltwAPb9UHGkzGJE+HUznJwFKD8bizZMbvjcOU7bL6ouqmN38wcCmU3dq850cxn5WM85IrmRvgID9bOJ7kTflulrYGEmUEJgciCXALSDQE4UYKnDLYHfL0Mn/88P
 6cmhnNwN
 SMyGnNKYdi/BfoAPXE6AtT1zz90cJEJSVo2yZKLZb0BgIJ2RcJWpxbpULGg9uFTy3ioD8i14uCPA4UfcHvp61/8FHMtc2+bFXNcn8H3wYVWW9GyvR4HHl+NWShVhz8LYkmOgY7UAxnKQsLD2g95EaL6kozJSKc3q1xNmtNLfON3BpEExzWOQlPH8f9UtfR+rhPtKZEAMzz5eLQta3jNtBwiTniO1sUq6tQnBClPKYODj3PM7KncZ37+4py/TYRSPBUYT0YFEv0WO+bxaN3yse9WLC9VV9+HkqjIRtfp1EHtHTRqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 3 Nov 2026 17:55:31 +0100
"David Hildenbrand (Arm)" <david@kernel.org> wrote:


> My plan is to get the small series for gup-fast ready, stage that, and then
> build on top of it.
> 
> By then I should have been able to dig through most of your series. The cleanups
> can stay part of this series.
> 
That sounds good. It looks like with this small change below,
GUP-fast and slow GUP can share another helper.

I can fold that into my series as well, or send the cleanups
in a separate series, whatever works best for you.

The PUD and PMD paths do not look as easy to untangle, but
maybe after some more cleanups on each end?

---8<---

diff --git a/mm/gup.c b/mm/gup.c
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -940,14 +940,20 @@
  * run under FOLL_WRITE or FOLL_PIN does need the per-page check, so it stays
  * one page at a time.
+ *
+ * @fpb_flags selects the scan: slow GUP merges young/dirty so
+ * folio_mark_dirty() sees any dirty PTE in the run; fast GUP scans
+ * locklessly and revalidates the run after grabbing it. @vma is only
+ * needed for FPB_MERGE_WRITE and may be NULL otherwise.
  */
 static unsigned long gup_pte_batch_len(struct vm_area_struct *vma,
 		unsigned long address, unsigned long walk_end,
-		struct folio *folio, pte_t *ptep, pte_t *batch_pte, unsigned int flags)
+		struct folio *folio, pte_t *ptep, pte_t *batch_pte,
+		unsigned int flags, fpb_t fpb_flags)
 {
 	unsigned long max;
@@ -961,8 +961,7 @@
 	max = (walk_end - address) >> PAGE_SHIFT;
 	if (max <= 1)
 		return 1;
 
-	/* Merge young/dirty across batch so folio_mark_dirty sees any dirty. */
 	return folio_pte_batch_flags(folio, vma, ptep, batch_pte, max,
-				     FPB_RESPECT_WRITE | FPB_MERGE_YOUNG_DIRTY);
+				     fpb_flags);
 }
@@ -1018,7 +1018,8 @@
 			folio = page_folio(page);
 			batch_pte = pte;
 
 			batch = gup_pte_batch_len(vma, address, walk_end, folio,
-					 ptep, &batch_pte, flags);
+					 ptep, &batch_pte, flags,
+					 FPB_RESPECT_WRITE | FPB_MERGE_YOUNG_DIRTY);
 			ret = gup_grab_folio_pages(folio, page, batch,
 						     pte_dirty(batch_pte), flags,


