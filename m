Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0416CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 21:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306A88E000C; Sun,  2 Nov 2025 16:38:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE708E0002; Sun,  2 Nov 2025 16:38:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B928E000C; Sun,  2 Nov 2025 16:38:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4B18E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 16:38:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BEBBD5BCB5
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 21:38:18 +0000 (UTC)
X-FDA: 84066980676.05.346BADD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id CB7A8140009
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 21:38:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GE/tL1Ci";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762119497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PsfZDWp7sm7GiaQ3mUuif11By27vnOTDqkh4M/9GDUg=;
	b=iCS1yq1wqoLZqG/jF6ej65O91A9qHbLFZ2jw2i7TYsols9byNTtXJEQvlTQRAE8hb+KmGi
	Gdac5sFDvDIPbKnqsIW88vceQGoLdPne7YA18VKLZakv3DVfHxUWGbODtr2v6NwcTxON4r
	TObjVubCl4ojqJr4J2UvMS2YoWjjvnk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762119497; a=rsa-sha256;
	cv=none;
	b=pBXOotYeiwW7lc6bG9XmbgZeJ+oV6AnM+iMxgRT7750cTojUw/5l4XjuyaYvTE2uDjnNkd
	ENjEhsoUL/umiWRjIKTxiBF6z63JyKoi2HiiGRO4SyXvUhqlK/1JnYQe3i4ra4yp7JRXw3
	PYpP4I4KQQ4mI7vnx8aX+xXscdYkG4E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GE/tL1Ci";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762119496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=PsfZDWp7sm7GiaQ3mUuif11By27vnOTDqkh4M/9GDUg=;
	b=GE/tL1Ci5ciBaLqBKgtzfupTeCnOynNcmLYC8JTFgHzIIQYQurlpR/2aP+wT5nZjB4q/L8
	pqr8iCCY/Bc/y0H9i4yUROtClu6lOq/iRaT93pl6oaDhjsKwFLBewmy5g7qlRCtoqaa00+
	x1Rn+vzq6yBL0RRDhZLXm7QKP/kZz7o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-aS-Aswj2N6ujmVS3fwfQZA-1; Sun,
 02 Nov 2025 16:38:13 -0500
X-MC-Unique: aS-Aswj2N6ujmVS3fwfQZA-1
X-Mimecast-MFC-AGG-ID: aS-Aswj2N6ujmVS3fwfQZA_1762119492
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A78481956053;
	Sun,  2 Nov 2025 21:38:11 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53E4F19560A2;
	Sun,  2 Nov 2025 21:38:09 +0000 (UTC)
Date: Sun, 2 Nov 2025 22:38:00 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>
cc: amd-gfx@lists.freedesktop.org, linux-mm@kvack.org
Subject: [PATCH] fix AMDGPU failure with periodic signal
Message-ID: <28850059-0e96-929e-eafc-7e2ca86447b6@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8FcKU1uAv86XtgYED48lMREeSPvNmMLquWcxQBwO62c_1762119492
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: CB7A8140009
X-Rspamd-Server: rspam02
X-Stat-Signature: n4bzueoezmz5f19t9oprqmrk6nazm1qi
X-HE-Tag: 1762119496-372694
X-HE-Meta: U2FsdGVkX1/PK2QAb02/3AG/eAAREwuzp0w4fyS1b6TstNKlXCakIe3E2l3iGw83omAb7aTeMiHYePqfvljaL6iQwNEy8n7gwSB64s3JxIlQc2RSrtAtYCKVw5v+bX6GuboVgdTVlxyWZIxq/uL87bL0e6RFxlbWQoO1co0ZV/2YceC8jrZMwrb5UfdkEFGViiz4jAMzRpKyk+aybCrLt/2flMhHHbIHckFgg3F2hiFtCsPO/4J2ZxsaVbdW2C+uvs8K5IHB/NbkYk5+stn5uXdjgppRsk0XAQVmWICcMdmp7iN3tWbBtFNrVhKi3jvatSiJyH36Ufr6uRLM2BPoBGPT8Bfz7iKpX7R70LnjYlc/aakabZ1+46557qtVGDulAXo/lNaE9DX3G9x0h3vbm7k/5IJxCxYAl0T7lvIDlKM202L/p/GHT9RAxIKaQAt0wVp4OB26JFBwjCsezSGDsD91Sf1oORAliPm6lYWwm3va4pSMYmf4RBLCFarh4lgiEMu/UOKgMjYb4j6ZGCJM1PG4BChOZiZj6TRZOayIAny+3EhmpTNC8WO2cNjRvxDBvurFtnjxQCl3BiEbqvEOip+KnF6Bl8Kid8pSvwKQk1/9e/1Kr8VFImhm2FS3gJq8qjAzwZ7px6eKT7sbftbizsoM9uxVC3BBm0H3rLmfSVBAUfuM9nQoPGAGOchdAqIBo1g6zkoIFPQRDfone2qYcVsEg9LiM33XBj9RgzYy8xKWzupTMEWcq9m0LYmjEBk24tBDVF0ybkbDV6OTHNJ9QnPYeBxabVrAg30V4sJ1vTp5JHW1GBkceKf1hgk2DMY26FHBKHkFSN+NH3z4eF8A04Bq+JEmJ6uPTqhRMkKn2d1+wNjHa+eriArjpB3Xy7w9Kjh6d/gRmV2sKO+u9rctRYnekeeUJUQ3txOlBMu0WPI891JCB7Y7/4xWsrs+BNc36x+MCtBSI5T7WuvEAJz
 gQw2Hf+v
 bH7CUJkZdW/l/g6+ybMhwI3XnAf6//77a5mPcKqHcth3BkmHQ6bMg74XLAD1hKzPNtrifcgpq67r24ulPVAjCgtNSyiFncNA8dobc1cO/yVzoqS+GNZTEe2OtKp7gk0bSjA5ADw/aoiEfFmAlhiDfi82+lANWTo/GyLYNT092ruNODnR0h9af7R+A5Lwb53YLnAqjZaGxhe133N0bbMVjJKwXC/Bk8u4ztR4n8sWGh/69chQ9zQXwmOkvyqKfh4Q8bQogvXmz/oleq4g24ZKn6kE3tT4guVRP4ZVRuEhT0cAv2EH1y5L0MAP8T0lt+vnlC8AwUj/n7rBaZoklHwQXDJ9pRdcw/CAwMLTOhFWKN2Fo0LdqhBMjzSUHwtmmpemDHtRNIuEjIWBpLSTS/zOlPue0YnRZXVvoY3yu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

I have a program that registers a periodic timer that sends SIGALRM with
1ms interval. If I compile a dummy OpenCL kernel while the signal is
triggered, I get these messages:

"amdgpu: init_user_pages: Failed to register MMU notifier: -4"

Apparently, there needs to be fatal_signal_pending.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 mm/vma.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/vma.c
===================================================================
--- linux-2.6.orig/mm/vma.c	2025-10-13 21:42:48.000000000 +0200
+++ linux-2.6/mm/vma.c	2025-11-02 19:54:04.000000000 +0100
@@ -2156,7 +2156,7 @@ static void vm_lock_mapping(struct mm_st
  * mm_take_all_locks() and mm_drop_all_locks are expensive operations
  * that may have to take thousand of locks.
  *
- * mm_take_all_locks() can fail if it's interrupted by signals.
+ * mm_take_all_locks() can fail if it's interrupted by fatal signals.
  */
 int mm_take_all_locks(struct mm_struct *mm)
 {
@@ -2175,14 +2175,14 @@ int mm_take_all_locks(struct mm_struct *
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		vma_start_write(vma);
 	}
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
 				is_vm_hugetlb_page(vma))
@@ -2191,7 +2191,7 @@ int mm_take_all_locks(struct mm_struct *
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
 				!is_vm_hugetlb_page(vma))
@@ -2200,7 +2200,7 @@ int mm_take_all_locks(struct mm_struct *
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->anon_vma)
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)


