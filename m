Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC32C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8856B00BA; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B076B00BC; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4769D6B00BD; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1951F6B00BA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DF30C0304
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:12 +0000 (UTC)
X-FDA: 85214535504.23.C687565
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7EC1140003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SiTyrH9s5tAM0G0+4iQ4EEsG4ch4XlZWTf2HT6J/6eA=;
	b=7mfL5xeSjA+Wbo/G7dO7llkHIc7Gy3coiYz9nL2a2kL+6P7EnTIN4gTMpDIMHBCi401KfH
	z0OJEeBqz+PTh3vsxrOIa0hr2fc7gcllXy0dODpunyM/tSoHXFZkQa6D0gAqU2Vg3WpVvi
	mW43kgEoA1tJEHBUahUoev6ERJhcuU0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442231;
	b=OvmtcRv/oiB1+gNF4OU412jgSrWiJn+iZthpgGxPmXVoSSiBNZ+QTR/FJTauq8JSFMh3H2
	tZc8PXq8JrtKlAsTJBNGK+FHpLnPfW05LbHFxWdivtDxx/Wt21m7cjabZajfk43pczHDBT
	pvjmsCV1AMpCpkzKO8UCbTrPpHbN7l8=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:08 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 08/10] PM: hibernate: read the image back a run at a time
Date: Tue, 15 Sep 2026 12:16:56 +0900
Message-Id: <20260915031658.1505680-9-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7EC1140003
X-Stat-Signature: x3gmmcw8711fcj1acq4ez1k8aqxyei36
X-Rspam-User: 
X-HE-Tag: 1789442230-597544
X-HE-Meta: U2FsdGVkX1+H4HvezJLeJYxQ2FJ+Q02i+yGHpL1NjsWsFZF6RrdytanRKdxXyOjV6brV3zHs8+cigBD+41BKUOk0AaSTwERredNxYiH2PWzEJ1kD+Shj7DkQ1E+cyrzhypyha/cc80kahOQKC/4miEg8EnfGv2la8DiG9dQrS18aumoH9l4dXOMIo0BzXzxJcU93Czo1G9V9S/SylYsNIU/CvXPb405FF8jpaApTpms8YufddAREU04CWdBXqkWEORK+yqmozXq/KehiK9D743FMnSfhdnEVwRbMDet5KhTw+qbrgq76hf9/fdzB2A5N2YGlpg27MPmtVw03AxBwEn513M6CSx0cGn48E3cAAQOsPbyo5TIJaStSP2+fX+z+kqPxkqLkPhRKtuWl6d2r8cKjbCv5PWVY4sclJs/x1hBoIq+OVWygIvbE6LQ4YYlsYubaiLcth8rhGi2Malh5MS3rOy3NyV0cJTtSQnkvy/JI47bjsDqqs3MVqrGYr8ER2zcPqTjSk0vCAvTHoJ0qk/5E/ueSlb7WNWn6qGP0uvBCs7+KSwXvhu7ICld7C2xR2MiTDqVSSmUepUevthUyLuTXlGR/8nWjZZXLuBlAOMeO+GcMSyd3xy+LQSxoSeWUsqqpDvRViaOAO3Q6y8vDdNzhAU8EoUqeV+eL8locsth5W4bGKDYRtlUAviTuk2Rjwyh9A9tjnjkHjIhqlRE9ZjVEvjSTKGL5Eib2WG661kviMmccgih8iSpvEzd8AloDt1MRaAiCb15Hzmc79nEHbllGvmafA30Qeud9+r1Ch5o2WmRIAxvWnjcX24E1geFvC075cdstYFnbcLObsMzb8aP7yDn5Fw4l5d703FT4fGfIv4GjpbpIj4fUxO03yYflEG3WIG5lyly8byi93EOl67YSSp+2mnMlg7HUI7oBHvJIFLCyemQctXUt/JrzZweXlV6ittszvrOXXL/7WkT
 /U1zryD9
 xare2Ck9WEgBGsQyjmFW0G5lkw5/wguFxy7m9QUe0/+0QowfIgRBhi1I0nJMFKDV+ww2byFqWFPmDIle/YwwgxKdMyYjjzuV62S29AQOisj6z7XVDIka8zQZmfWrvAMdw6o8Tti8M9X06+NVpfnHW+HRbnBjxYo/1NH2APY3RRdU2EHmRrqPNZwRS88RL3O3mdSPP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The write side now builds one bio per contiguous run.  The read side
still submits a bio per page.

The image is read in the order it was written, so the offsets arrive
in the same runs.  Fill the batch for reads the same way as for
writes.

The compressed path queues reads ahead and then waits on the reads or
on its threads.  Submit the queued reads before those waits, so the
last of them do not wait for more reads to fill the bio.

Reading a 5G image without compression on a VM took 9 to 10% less
time.

Assisted-by: Claude:claude-fable-5
Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 kernel/power/swap.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 34e47c662798..f2fc8495ddf8 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -252,7 +252,7 @@ struct hib_bio_batch {
 	wait_queue_head_t	wait;
 	blk_status_t		error;
 	struct blk_plug		plug;
-	struct bio		*cur;		/* write bio still being filled */
+	struct bio		*cur;		/* the bio still being filled */
 	unsigned int		max_pages;	/* what the device takes at once */
 	unsigned int		nr_pages;	/* what the next bio is sized for */
 };
@@ -308,7 +308,7 @@ static void hib_end_io(struct bio *bio)
 			 (unsigned long long)bio->bi_iter.bi_sector);
 	}
 
-	/* A write bio carries as many pages as the image was contiguous for. */
+	/* A bio carries as many pages as the image was contiguous for. */
 	bio_for_each_segment_all(bv, bio, iter_all) {
 		struct page *page = bv->bv_page;
 
@@ -334,19 +334,18 @@ static int hib_submit_io_sync(blk_opf_t opf, pgoff_t page_off, void *addr)
 }
 
 /*
- * The image goes out a page at a time.  Keep filling one bio for as long as
- * the next page lands right after the last, so that pages that are
- * consecutive on the device reach it as one request rather than as many that
- * the block layer then has to merge.
+ * The image moves a page at a time in either direction.  Keep filling one bio
+ * for as long as the next page lands right after the last, so that pages that
+ * are consecutive on the device reach it as one request rather than as many
+ * that the block layer then has to merge.
  */
 static int hib_submit_io_async(blk_opf_t opf, pgoff_t page_off, void *addr,
 			 struct hib_bio_batch *hb)
 {
 	sector_t sector = page_off * (PAGE_SIZE >> 9);
-	bool write = op_is_write(opf);
 	struct bio *bio;
 
-	if (write && hb->cur) {
+	if (hb->cur) {
 		bool contiguous = bio_end_sector(hb->cur) == sector;
 
 		if (contiguous && hb->cur->bi_vcnt < hb->cur->bi_max_vecs) {
@@ -367,21 +366,13 @@ static int hib_submit_io_async(blk_opf_t opf, pgoff_t page_off, void *addr,
 		hib_submit_cur(hb);
 	}
 
-	bio = bio_alloc(file_bdev(hib_resume_bdev_file),
-			write ? hb->nr_pages : 1, opf,
+	bio = bio_alloc(file_bdev(hib_resume_bdev_file), hb->nr_pages, opf,
 			GFP_NOIO | __GFP_HIGH);
 	bio->bi_iter.bi_sector = sector;
 	bio_add_virt_nofail(bio, addr, PAGE_SIZE);
 	bio->bi_end_io = hib_end_io;
 	bio->bi_private = hb;
-
-	if (write) {
-		hb->cur = bio;
-		return 0;
-	}
-
-	atomic_inc(&hb->count);
-	submit_bio(bio);
+	hb->cur = bio;
 	return 0;
 }
 
@@ -1477,6 +1468,12 @@ static int load_compressed_image(struct swap_map_handle *handle,
 		asked += i;
 		want -= i;
 
+		/*
+		 * Submit the reads queued above now.  Otherwise the last of
+		 * them can wait in the bio until more reads fill it.
+		 */
+		hib_submit_cur(&hb);
+
 		/*
 		 * We are out of data, wait for some more.
 		 */
-- 
2.48.1


