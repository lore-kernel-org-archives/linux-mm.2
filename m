Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00927CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 10:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4750C8E0074; Fri, 24 Oct 2025 06:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426448E0042; Fri, 24 Oct 2025 06:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315088E0074; Fri, 24 Oct 2025 06:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18A6C8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:23:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA789893B2
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:23:44 +0000 (UTC)
X-FDA: 84032621568.23.4F01E2B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id D2F9410000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:23:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YKJpUttv;
	spf=pass (imf05.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761301423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTfuG7mkwdAcHRX5d7idU5PTbdJ+nPsDJiTr0D0zK8s=;
	b=Y742I+s/hYIuIopIpwhXBeJ6AYZTErSH+XuMZ+juvitHylr+dxKE2maoh4oJSmmJw4cRBD
	q/+4MjFT3XM7ZJhAgSlZk4Fdb1Bi00LNwh+gjlsezjpAUHRpCMMMVUZi9p7ulp+OHTmWvd
	DWb4sXJIZr/zWhjywjFhWfnxiI7T6Lk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YKJpUttv;
	spf=pass (imf05.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761301423; a=rsa-sha256;
	cv=none;
	b=4ec8hFS7rI5MX/s1tw8JxpyZP0KfS4G9DNffYqJ2ORKMjHXyK4J1k+gdP3qErbi4JSYMbV
	WjTaszBNj3zxcad/6m34pzhqxDxvoNswRLd218hVyPUBxn+9RScMB7rfpDQjyoDkv1lVII
	4D0n70Q3pmblqpe7JD+wdnUHXil5mOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761301422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dTfuG7mkwdAcHRX5d7idU5PTbdJ+nPsDJiTr0D0zK8s=;
	b=YKJpUttv9d0wFS/AYJnWIM1uppM2GKkw2YTtybKVSxJefvTRGrSd2t8usUaaUXfIBgVoO6
	YT5NM4UpfKNgx8SfaXY20STyZvMiLGtg32gHBVZAo69a71HcabeYmlIUnhkJgNi9h2W6su
	mLRgPvLteYaG//5cuFGrU1Ho1/Mwp10=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-xMjsaOJWPMeaC3MMh3OPgw-1; Fri,
 24 Oct 2025 06:23:40 -0400
X-MC-Unique: xMjsaOJWPMeaC3MMh3OPgw-1
X-Mimecast-MFC-AGG-ID: xMjsaOJWPMeaC3MMh3OPgw_1761301418
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EB25196F742;
	Fri, 24 Oct 2025 10:23:36 +0000 (UTC)
Received: from [10.44.32.37] (unknown [10.44.32.37])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57711195398C;
	Fri, 24 Oct 2025 10:23:29 +0000 (UTC)
Date: Fri, 24 Oct 2025 12:23:20 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Askar Safin <safinaskar@gmail.com>
cc: linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, 
    linux-crypto@vger.kernel.org, linux-lvm@lists.linux.dev, 
    lvm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    DellClientKernel <Dell.Client.Kernel@dell.com>, dm-devel@lists.linux.dev, 
    linux-btrfs@vger.kernel.org, Nhat Pham <nphamcs@gmail.com>, 
    Kairui Song <ryncsn@gmail.com>, Pavel Machek <pavel@ucw.cz>, 
    =?ISO-8859-15?Q?Rodolfo_Garc=EDa_Pe=F1as?= <kix@kix.es>, 
    "Rafael J. Wysocki" <rafael@kernel.org>, 
    Eric Biggers <ebiggers@kernel.org>, 
    Lennart Poettering <mzxreary@0pointer.de>, 
    Christian Brauner <brauner@kernel.org>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Milan Broz <milan@mazyland.cz>
Subject: [PATCH] pm-hibernate: flush block device cache when hibernating
In-Reply-To: <4cd2d217-f97d-4923-b852-4f8746456704@mazyland.cz>
Message-ID: <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com>
References: <20251023112920.133897-1-safinaskar@gmail.com> <4cd2d217-f97d-4923-b852-4f8746456704@mazyland.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Stat-Signature: nh6ciyu56ant3ibj3f5hxzd6thz1ejmw
X-Rspamd-Queue-Id: D2F9410000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761301422-938322
X-HE-Meta: U2FsdGVkX18p0Oc65Llt6YMqEKv0Gh/1+7jSNUQIMBCCgz7oMNUoqznsFCroU+66MZPGviLFzuV3DJJs+g1bAJlrl/UlqX6W2stCacCcR5TPdHVpRZdg2tyiNbtSYfJew1oCK6fqjom/8DI09PWUqUIdyGGAQ8uYqdfhIr1txFYYkruTCkJfDgJJOw7J4445kq2Q8ekf9TbhGxM4ELzeKJZk3glH86EBY3SE4snVrcOTXxH2R8DQEnGNxvQtQe8FAqUszQqi0dB81hSIBbygbB9oaIYMDaB1YGeoNAqmC036QzFdmF2dnQGnztHpGZrEhIQt8bGBnx8Raa7Z4u37cIs4o57XheMkOAVk6EYe7U0Gp939ETIFqWYhRqfF29S72w+Tk+ixJ8MqJhPIRA/LHWYJCSDgRGqZdidf6APGvBuwmAaVzcv7kECWont2E/ZGCuOMSb83TbOjBp1JBE5QOHm9MwIZ44rplXhg75rE2hi+/W8KPxTgwaH+a9b0dLoYA3usEw1XluleCQHG+v99f+WTba09frLmfwIDqI7ozwUOqYiM70Chxigi3JLPxgZfEcK9CDYTZC4DPAxtJTh5mYZdLnz/lHVIjnKIyUDkUeDDJFo6LTePy7zghecZg3ojbnK6rrjFlG2iXopV3gnsIzEth0ze/po4W0sc6mPA+14G5Ve1ryLLzxkqg2YHaKqwVPj57jGcOXpK8BWaLV5UiEffh41tcEzTK9dOcGgGrnXXbfrrtW+oTYpfK5awXJVPYdI7Q6rka98n5k9GIIUJmyHKthQcT3koxs1jUq9QGTshWzAN+6TMYvq1vQZ7rI9g/TXAxnx1z5PC+fPkMkib2fCF1zFR41q3+57naxGsWcnZuQJV53yD/Mir1jZdvQq993HRpLC1SRzeh/1Bo89SBxVLnlylFESUxr3q93fSV8qdBafZTOEdhwoyKb68kbFVyOhwvVKyK+0gj+CgwbT
 iJFfJ2Xg
 2WSDTSTXlEGsTvLcv9z8ewb0lz4Kd6rr2Z/fjVahKexcDy5S4KHGGr89OlBdJcUV31bES7cWNL05h4y0NhQHId1ltoYxk/DdBWkHuAUIZQB31y4gbgp+m2tCu5u484menQeT9xHspfV44JdQChJP7My/8wZXy5DITM4xjNqgh1K29VmDstfsmvO114neVA2iQ4z01FIORNf40/Qz61PciMRxCdMOp+KuXfTvtO17GxOOH6Ky+y7ad10UUWeybQJf9B5l9ZXb96p6LMbh9HIhjXpItadLSyiHqPS7bNB8O9IAI1KppZdXcxBBnfCxrPvVIOKceRKlzqbJ7LVQ8/63pi4HBcPcydGg/8LIK4GAn5HZQ5jGuDMZQwezrQwTBJ6XqzokQmhh5EpGJWnI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, 24 Oct 2025, Askar Safin wrote:

> Hi.
> 
> Hibernate to swap located on dm-integrity doesn't work.
> Let me first describe why I need this, then I will describe a bug with steps
> to reproduce
> (and some speculation on cause of the bug).

Hi

Does this patch fix it?

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

There was reported failure that hibernation doesn't work with 
dm-integrity. The reason for the failure is that the hibernation code 
doesn't issue the FLUSH bio - the data still sits in the dm-integrity 
cache and they are lost when poweroff happens.

This commit fixes the suspend code so that it issues flushes before 
writing the header and after writing the header.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Askar Safin <safinaskar@gmail.com>
Link: https://lore.kernel.org/dm-devel/a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com/T/
Cc: stable@vger.kernel.org

---
 kernel/power/swap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c	2025-10-13 21:42:48.000000000 +0200
+++ linux-2.6/kernel/power/swap.c	2025-10-24 12:01:32.000000000 +0200
@@ -320,8 +320,10 @@ static int mark_swapfiles(struct swap_ma
 		swsusp_header->flags = flags;
 		if (flags & SF_CRC32_MODE)
 			swsusp_header->crc32 = handle->crc32;
-		error = hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC,
+		error = hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH,
 				      swsusp_resume_block, swsusp_header);
+		if (!error)
+			error = blkdev_issue_flush(file_bdev(hib_resume_bdev_file));
 	} else {
 		pr_err("Swap header not found!\n");
 		error = -ENODEV;


