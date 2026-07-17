Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71255C4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C411C6B00A4; Thu, 16 Jul 2026 20:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAEF6B00A5; Thu, 16 Jul 2026 20:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE10D6B00A6; Thu, 16 Jul 2026 20:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 410F56B00A4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:24:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1797160281
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:24:46 +0000 (UTC)
X-FDA: 84996372972.16.2C835A7
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id 101D040008
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:24:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=croXWoyx;
	spf=pass (imf01.hostedemail.com: domain of 3S3ZZagUKCPYjglijemmejc.amkjglsv-kkitYai.mpe@flex--linkl.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3S3ZZagUKCPYjglijemmejc.amkjglsv-kkitYai.mpe@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784247885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvV/YUs48FxJuWf2yjxeyeKt50HRM0qCcCCbR1JgotU=;
	b=LgVbwUuKMwjWxju33zWFs+R3MKpsD6+Z/YIVjnV2Pkahlo5VrThCQ6apBUNUkB87KDQCOQ
	tPdMYtx8x4ExLUDjKSF1HvSbA/KW5io3OB+Udz2Q/cE5HwGnIfOSk1ulpDvRX4v96Ej2Ho
	A7T1gnlVBWxh/TBX4Xybja50AzT4O2g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=croXWoyx;
	spf=pass (imf01.hostedemail.com: domain of 3S3ZZagUKCPYjglijemmejc.amkjglsv-kkitYai.mpe@flex--linkl.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3S3ZZagUKCPYjglijemmejc.amkjglsv-kkitYai.mpe@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784247885;
	b=Sb5VLrHWWpl1GD1kLO1vaenndNslun7HLRHvyTeW2lOfJ1qu3L9LV49ldAGZ2KJ/20kjDF
	eslGGtpjIA2kSVZhBK8b9zCGwqWRbnM4k5+5ZgZ6yNSbqkfzBcj4xYrJgWVM++WJKdppfi
	pELjdKvbf8NzKXMn2hJSRthxLWrlGTk=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c7f385887bso170991995ad.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784247884; x=1784852684; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kvV/YUs48FxJuWf2yjxeyeKt50HRM0qCcCCbR1JgotU=;
        b=croXWoyxnF+L93eWpleDnnyFEX1aqHaAOpyA1aaRIdiy2tAlG4FED+kSBf5jL7jYh5
         Uq3qlMIz39BhKFl5m1tfMjXBYjvDbBlk+CadLO0fOYK9vODZ1TFqGYkHfGS6vWprvrVN
         sjQqmahUHYaV/r1no4PRNrlc9kb6m71uG9lFlamaynK2vfPyyS7raWmn/TUmdANGvXdH
         DD6oixk+ccOKuYa+gCg0e1w1CvxNJQZxGlmu9aQRI37LHO9lQ1yR2YcEkoPtxmuU7sHN
         gqk2SGESRcQAFNUfCQjNbx6go38URHXO89g4pd9dvWb0fGXIuM1Zlvg2x14at8tWRKsB
         VP8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784247884; x=1784852684;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kvV/YUs48FxJuWf2yjxeyeKt50HRM0qCcCCbR1JgotU=;
        b=P/xGFu/eISWKJMOkfcugRP4gx57IzI6dhJW8ppC5RWr3dlu/tmhLAO/Mj2188kVTmG
         u06hsZ/mM53rncrseCHsukHqEXncFchuJCqs903FG0NZpSfcQdj/OW/rH1sRJfqfdeSS
         v63BQ5d4wO8eci0OFCq5fOjzYx4PKQnsMRIdzz2hcLw/6VvY8o3R05Eg/XNGYetTm4RD
         T4CaL064UZ11cU709olY/y7WqBf60xhN+3Cj19J4uWoj+mGK6DA4lTVjZFMWGWtya39P
         bOHXRV92geVU0Ezg7+ItyjNs6lPKtsiK7yt5ttuQOnYcWR7NVauJn/X3AVsSFYJl2XOg
         k7Fg==
X-Forwarded-Encrypted: i=1; AHgh+Rp2uy3+eaKVYHCm6nfoAn4wr2YpndLEDDPEMMuEWq2MNhHag9EtoLCNvSuvgAfgvzcWKHTDHiWKNw==@kvack.org
X-Gm-Message-State: AOJu0YzkDoy9EKGhqFQ/VvFSCxtD32KIAbMDKk2Ka5fb73t0e6aTGZyF
	I5N8Pz8ZLb0YMpywcggqTr9DDFn0HWqAYv5OVY7bJrU5K2Mrq1sSXj5xmkobIt4gA/D7n374+kQ
	bnQ==
X-Received: from pjbds23.prod.google.com ([2002:a17:90b:8d7:b0:389:a1f7:c74d])
 (user=linkl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1345:b0:37f:9ce1:cdb0
 with SMTP id 98e67ed59e1d1-38e4b55aeccmr247935a91.30.1784247883538; Thu, 16
 Jul 2026 17:24:43 -0700 (PDT)
Date: Fri, 17 Jul 2026 00:22:21 +0000
In-Reply-To: <20260717002311.681748-1-linkl@google.com>
Mime-Version: 1.0
References: <20260717002311.681748-1-linkl@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260717002311.681748-3-linkl@google.com>
Subject: [PATCH v2 2/2] virtio_balloon: avoid shrinker execution during PM suspend
From: Link Lin <linkl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Michael S . Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>
Cc: virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org, Link Lin <linkl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 101D040008
X-Stat-Signature: 9smrjg7ranb5zijswgbjew5g8eim7nyu
X-HE-Tag: 1784247884-470651
X-HE-Meta: U2FsdGVkX18GaJOTf1Oic980PREL13LVRMKypLqO60zzocGcbV8d5h8YNufU/35+bczVIAFVhu54Nw47jxisW3n1jd+ww8tNczfHxjomUP0GZwyCTQUEDgZBgePCxm5d15UXRcwZaPeZ2svjdo10m69rj2QDNEO/SayWYjrO4I/jmSgUttV7XDnHAY4IsXAtkgrKcJYdC/pWQ2E+igmudwrlF5rE8Mi7iUAy5UfWjMbam8iyfAMsL7jaVcEha4RW3G7KLYmrC4qM6hVS/PDgniYUuhDmpaMyEgS1DgvrKoUEg1vcAlYQb07volkmJHu062Rdoxqg0tlD71i6TfrRr4rbYEQltHMFAo1XCo8k7aVCR+9BtPfvBjib0sdIDsFi0EikU6n5wQiu1IBP81xXS7ZQ/HaaxxsRJ6GqoI69oHgvIvG5/ZcfzJ93guDFW3SQpTlDsmSnrLLAMGeQAcoainE8ePcLvO2v9Mg6u+sU4n7otp9eqYcSafsqta2/MALd73bpjLWZhH6Ak9zdQUoXCPp0fkY7bZaTU5AH4GP0Xl2IOM/N/1w9nN9tI3Xkp5SuaNhyiVvoxc2KAv5s59OOsWSohAUNsj9UIvSAhC+thVe8G0ifDlStVDrjCM5Ply040NulFC6KS2UppXruJ5SalkEIVAnmH82bsebyHQp9hBljDslaOpX1MctR05/FpHWOXOnZ79xn0S2fVLgBAA4rl6PzD6qy2Nwbne05vbqmap9z5U0kA7TeuMt+JVVWs18nTkB0Cp9XWiCrm2bTdFsyxhdZCzxuoaPtUVKjieuYl7o+mjllnhzcTQyqs0r3kwDHjFl90C/CJaoem2n5MWynH4vLHLvOLkYz7syu8JXaqdRxKNtMMrLObELYkpJdZW4WoIg+JPO4T9KnLIA4pyz4eEtBvQxZGZzOvlHFIMj186JBPGOR5agKL1m2VO2OxBsFazzWs64AJUOeCoCeb5e
 bpRj+9IA
 k7iGWM8TrQDlRNcoO+KXlPlPEFWzc1rYJTmpd2STuN+zdPFxXEo6ZM/6Alol9atK4LJSyksEZ/gtvkrCreSnYQZQ1xyKxox0+3QldbirTOGh/gDii8DMMWWMc6uI+tnDQHzghICndOvn4wJlkQoYGfEcidn+3f3qA2TAkIs9068Bw/WeJcbJtx1rIdbF6EbDhf5zGWUDcyZI66/ZmvRTT+hGX1fKNY+o+opmAj1D38eyrd8CJXR/79J4Ge8ins87+nJ3cpYMHsKoOQGmBxA8iGUhCvedvrEH348WyBZvtQmduBK0s1Udnx2nvtaXAicYsJF0oqhhaBLfh1WVTiRKkYq0Sj2AVWShOCppb02HyBgqASXhMW+CkRq7qx2xGaJRZ0LWzCeh7axYNMxQeVZFmgoP5HZ57Jlj6BAnuVQPA4uoBGzoOV0Bo2p4fpsFhF0eUzqc+MQR3NiKZRRmldSDQiOqmtpdkcFI6gsQISPt6ZqxKMYITi3aRtLyUgZKMR9nLTCDnlTJtnIFG8VCatjoTcGapprE3MkguPWu9hbpSLeQW7ROdKuOkehDp4RQKdJqTlDcpkbIRwg4AzO7IhWLcQDycl5j/xHcp8HRoULAMjlri0gdG6rfJi3g2kdeHEMB699WZzSN0PB0OgVT18WGPnRNS79CfzWFiyU7rdja4aklAZ4mhI4sOfDytpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During PM freeze (e.g. S4 hibernation), virtballoon_freeze() calls
remove_common() which resets the virtio device and deletes all virtqueues.
However, the balloon shrinker remains registered with core MM.

If memory pressure occurs during S4 hibernation image creation/saving, MM
invokes virtio_balloon_shrinker_scan(), which attempts to reclaim free
pages. Although return_free_pages_to_mm() only frees pages back to MM,
reclaiming free pages under memory pressure can trigger page reporting
which might access the deleted reporting virtqueue if it is not yet
frozen, or interact with other parts of the driver in a teardown state.

Avoid this by adding a `suspended` flag to `struct virtio_balloon`. Set
this flag to true in virtballoon_freeze() and false in
virtballoon_restore(). Check this flag in both shrinker callbacks (scan
and count) and return 0 if the device is suspended, preventing any
shrinker execution while virtqueues are deleted. Wrap the lockless reads
in READ_ONCE() and writes in WRITE_ONCE() to prevent compiler
optimization issues and KCSAN data race warnings.

Fixes: 71019de8219b ("virtio_balloon: Add free page hinting support")
Cc: stable@vger.kernel.org
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Link Lin <linkl@google.com>
---
 drivers/virtio/virtio_balloon.c | 49 +++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 088b3a0e6c..38e1166a64 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -68,6 +68,8 @@ struct virtio_balloon {
 	/* Prevent updating balloon when it is being canceled. */
 	spinlock_t stop_update_lock;
 	bool stop_update;
+	/* Prevent shrinker from running while device is suspended. */
+	bool suspended;
 	/* Bitmap to indicate if reading the related config fields are needed */
 	unsigned long config_read_bitmap;
 
@@ -471,9 +473,9 @@ static inline s64 towards_target(struct virtio_balloon *vb)
 	return target - vb->num_pages;
 }
 
-/* Gives back @num_to_return blocks of free pages to mm. */
-static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
-					     unsigned long num_to_return)
+/* Helper: must be called with free_page_list_lock held */
+static unsigned long __return_free_pages_to_mm(struct virtio_balloon *vb,
+					       unsigned long num_to_return)
 {
 	unsigned long num_returned = 0;
 	struct page *page, *next;
@@ -481,8 +483,6 @@ static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
 	if (unlikely(!num_to_return))
 		return 0;
 
-	spin_lock_irq(&vb->free_page_list_lock);
-
 	list_for_each_entry_safe(page, next, &vb->free_page_list, lru) {
 		list_del(&page->lru);
 		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
@@ -490,11 +490,27 @@ static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
 			break;
 	}
 	vb->num_free_page_blocks -= num_returned;
-	spin_unlock_irq(&vb->free_page_list_lock);
 
 	return num_returned;
 }
 
+/* Gives back @num_to_return blocks of free pages to mm. */
+static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
+					     unsigned long num_to_return)
+{
+	unsigned long ret;
+
+	spin_lock_irq(&vb->free_page_list_lock);
+	if (vb->suspended) {
+		spin_unlock_irq(&vb->free_page_list_lock);
+		return 0;
+	}
+	ret = __return_free_pages_to_mm(vb, num_to_return);
+	spin_unlock_irq(&vb->free_page_list_lock);
+
+	return ret;
+}
+
 static void virtio_balloon_queue_free_page_work(struct virtio_balloon *vb)
 {
 	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
@@ -871,6 +887,9 @@ static unsigned long virtio_balloon_shrinker_scan(struct shrinker *shrinker,
 {
 	struct virtio_balloon *vb = shrinker->private_data;
 
+	if (READ_ONCE(vb->suspended))
+		return 0;
+
 	return shrink_free_pages(vb, sc->nr_to_scan);
 }
 
@@ -879,6 +898,9 @@ static unsigned long virtio_balloon_shrinker_count(struct shrinker *shrinker,
 {
 	struct virtio_balloon *vb = shrinker->private_data;
 
+	if (READ_ONCE(vb->suspended))
+		return 0;
+
 	return vb->num_free_page_blocks * VIRTIO_BALLOON_HINT_BLOCK_PAGES;
 }
 
@@ -1089,8 +1111,11 @@ static void remove_common(struct virtio_balloon *vb)
 	update_balloon_size(vb);
 
 	/* There might be free pages that are being reported: release them. */
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
-		return_free_pages_to_mm(vb, ULONG_MAX);
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
+		spin_lock_irq(&vb->free_page_list_lock);
+		__return_free_pages_to_mm(vb, ULONG_MAX);
+		spin_unlock_irq(&vb->free_page_list_lock);
+	}
 
 	/* Now we reset the device so we can clean up the queues. */
 	virtio_reset_device(vb->vdev);
@@ -1133,6 +1158,10 @@ static int virtballoon_freeze(struct virtio_device *vdev)
 	 * The workqueue is already frozen by the PM core before this
 	 * function is called.
 	 */
+	spin_lock_irq(&vb->free_page_list_lock);
+	WRITE_ONCE(vb->suspended, true);
+	spin_unlock_irq(&vb->free_page_list_lock);
+
 	remove_common(vb);
 	return 0;
 }
@@ -1148,6 +1177,10 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	spin_lock_irq(&vb->free_page_list_lock);
+	WRITE_ONCE(vb->suspended, false);
+	spin_unlock_irq(&vb->free_page_list_lock);
+
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	update_balloon_size(vb);
-- 
2.55.0.229.g6434b31f56-goog


