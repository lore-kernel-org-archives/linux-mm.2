Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E10C1C44514
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BEB96B00A3; Thu, 16 Jul 2026 20:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782616B00A4; Thu, 16 Jul 2026 20:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C416B00A5; Thu, 16 Jul 2026 20:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25B516B00A3
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:24:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D281A0382
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:24:45 +0000 (UTC)
X-FDA: 84996372930.08.BADFF66
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9DE81C0002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:24:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TBEMa2LW;
	spf=pass (imf20.hostedemail.com: domain of 3SnZZagUKCPUifkhidlldib.Zljifkru-jjhsXZh.lod@flex--linkl.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3SnZZagUKCPUifkhidlldib.Zljifkru-jjhsXZh.lod@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784247883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BZOgadh0/WAQnS0GZRJ8uTk+OHst0wqYuvkCMlhb4s=;
	b=6YsabjnGMEgBYIeEdIUCvNEVasDrZF04qf0zrUCv+9m7tREnsWqfthTkkyWyzhl8RCp7Jz
	jz7srPxbcEA34r4ecKqMnghup+BceylT/v4eNac49b0PJmo0GrFVaBPHQfgce1ru3F69q4
	DDwtNb356rm56mQ/Efyrv7M1T11QRFI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TBEMa2LW;
	spf=pass (imf20.hostedemail.com: domain of 3SnZZagUKCPUifkhidlldib.Zljifkru-jjhsXZh.lod@flex--linkl.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3SnZZagUKCPUifkhidlldib.Zljifkru-jjhsXZh.lod@flex--linkl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784247883;
	b=goMwYBNLOnt+LmsVQnodVfDV4ISm/qrDdiYL563Y7qL9f3eLMDGZhXm0Mia5rZnZH0FEl0
	dhGZesbzGtF1SCq76sixPK/e49+In1wamj8eVPOGO8xaFv6muqBgvcZjqVygjzIs/SXJBo
	HuwhLHeW/Rbo6W89Oa5LVSCabwsMHhU=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ccb6f6a3f4so18555475ad.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784247883; x=1784852683; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3BZOgadh0/WAQnS0GZRJ8uTk+OHst0wqYuvkCMlhb4s=;
        b=TBEMa2LWLTm7/DrEMAEwphd/+U8yg61l8NHEdr6wjZf99nPeGPFmbOuSJN6kPtZ4Tq
         6+V1A1ZuZJ2m2ZcpeIiPaYvg+zHs41c5YjvtMsnDjDf6oFafxPyRu5WgzXi0PIVji71U
         zkpvIcMtO2lr2EGYp0UTJApsjWuczzK2y8Zf2d8I7gyRrjB+KX64bun27Bkir3B1/01t
         a+1/3giMKsFwYHmUhk223bBQweDpTWw0YZs7KAQ+XfKHkKS4/7bFFXeDqz7MMUpFc2cG
         uyODGOm9xD/iv2v8NuUNPvM/PUsJ8jvKsdJT/5B+NOp6soTSWV2pnwdCwiCxP16XDqD4
         e6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784247883; x=1784852683;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3BZOgadh0/WAQnS0GZRJ8uTk+OHst0wqYuvkCMlhb4s=;
        b=AaDEBVVXlQCPx+8YQ14vTy/ILaq4FKOW6H231a8e67K7QMNOa3OQlg1sZbNHMuWQxh
         ah+eU8dpwAbCDir/g90Mq5zc8r+8Lg0c5K6oM2DLbK7pKdhYrqZXIOc00MFwDzsMKKCE
         hd+ChfEF96SLt4+qeH6Hp4VlfKBorMls9u0PzwNZMIhI0Su5cAWhjofbcVRRDLHR3/0p
         dwXtMhE5MX2rtlT5huJMBN6CW2vpAKUUx/aRKxe6ScCkGEpgB1ELFhBAZo5ZoBOgnluj
         0GuXJEK6yrtDujML7tSwzCHnWJLP3WO10rEwifqQuDTF6L1zeqnpmNshX2NDrtsvyM0D
         S5/Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp1ZtH9WgNuXEkoysbF73SJj8MnwmhV2R2pBr5lQ94VinNdnEplSCrSlvM0QupduR7ZqFZiaK7Q8Q==@kvack.org
X-Gm-Message-State: AOJu0YzouWAXSzEH83Auw046+1QScv4XwitYiDq7V8+q/+jk31A0Wl71
	s+r15He9lOD4vhxa9gXoF0Lt2d5ZORIGBAxqjRmEyxjrWUK+/k62f0nJWPRfZZ3E32BNEanNjUK
	UXQ==
X-Received: from plhv17.prod.google.com ([2002:a17:903:2391:b0:2ce:aea4:5e73])
 (user=linkl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f683:b0:2cc:db7a:251
 with SMTP id d9443c01a7336-2cf1f2561eemr47925045ad.2.1784247882515; Thu, 16
 Jul 2026 17:24:42 -0700 (PDT)
Date: Fri, 17 Jul 2026 00:22:20 +0000
In-Reply-To: <20260717002311.681748-1-linkl@google.com>
Mime-Version: 1.0
References: <20260717002311.681748-1-linkl@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260717002311.681748-2-linkl@google.com>
Subject: [PATCH v2 1/2] mm/page_reporting: use system_freezable_wq to fix UAF
 during suspend
From: Link Lin <linkl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Michael S . Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>
Cc: virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org, Link Lin <linkl@google.com>, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: imyubxac1ko698b4788961anb75zdind
X-Rspamd-Queue-Id: E9DE81C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784247883-439047
X-HE-Meta: U2FsdGVkX1+rY+lsyK92akgQnRKCSNADrLQEZRJCdUloBIF2rISizZP9xzWwLy/om5od8xS1L41QLwq6rHK5PlpiN6t592XdW+zCbkl9Jf6+dYypZE/uioW2DEmwRppzG1Onc9V6sLvYofI61Q/IqSFDF9ajEs2enf6FpVtBupNfKmZ0fbADekp45Rsqa0sVrHVREopbkKYvQOifS3MXEi31QfnK1Lh9kUfauwakt3S3vEOKJctzGlU9ar2x6qxW79brDU+SSo8LD1YYSMT+Jwy5X7wc40A+N+xC/wzKNIHLWyU5InunUnRsO3Jo/zQeSjyhcT2ljtdXDyKno8bLNUcUqv9LwEZqQWvpu2kn0Hln4Le9Ve+FLtgrxkK10vDPzxJO6CQkmWdqIgIsuIVZDIeqFFRzWvQBdfAnLmQftqa/5nGxYGYQ+mr1rPa+i+fhD8s1PIm9y5uFk5QwfCkCDw+7woHvP4V6sE4URed2jCXHBLITEX82wGhLyp4OEyIV2m576g0kVf/vvk3++RJwY+UiVp37cgs3zxuhLuVfMA+6AAcIv8VPKThgT/kKwYhc7b1wqplAkjNY4roXOFEdZjsy4IlUfsYCtvJgnkdOVYPZaGbI3jyHuMAMENCAeo3FM7MbOTywxJkubKL6scxJaiJ2DWTtzEl5qpJzZsYiVmQF+puP0Tdf7/XP9KDzYboj1G2sselRCwDK7aXpikGO6p8tXS81Nh8HsiLtBdD6QswhZAZN0Y684eWsk0lhAGfhYy5KzdYHk2ASghqnVKrPt0khLoX+49vIRiXEwx9FcUn/if8qxmu8i3QDNhpgaK9+tauNMqv5xWqmWeccwkN/q08g9E/2nAcIGnWnvWa0BCkVXkiaXZX2VCjOOfv7fVPxVEGoMRWDbjvluoJoCud/X+ato1JdY6ELHHO/hu68qZ/VWj4TrW0Bz9V2bQ75bavJEzeKFt5PDAQs9XB/YyM
 m/hnRwiY
 cG3KKN5jMkC4DPEh5MivJCetXeD9Mr1Emone4a4/p5AH4bFbEfop8fQLBltkEkJ59eEu41KBwdbegWOMUWdMPorxukOu/x0HPtUVUtNQGGC41TXaPjsf+SmK4m1fWfLr9gOnMT3AcaSmY2diJbju+YPpXTls6vF0398aUwQ5adg0qbDGICnYQ0GdAD98kpymUM/0pmBlreUEEG5QdDNyrj6i2wqZf4FsJVKYpL/uA4/5QnbtmROda2wIne3dl7f9m7iwPbWQxY85pbJGzI6eUhWLSJcJFKKd0BIzYjIvWWzo9jVJ1uM3Hu6cgZhy5gYHRgnbrj3/1xoTJOg3nE0lq8FQ1S/iUoSNFGkGHjZjsLzXGtYzcLTAIyJD5tEVI7hWQwmLhCx7PoR2n8crpFtix0Ajo8JN/z+xcgHtXfOy3utqoJXISKNkc9USJ/vV2Cfy9mKRMx74Zz+lfukWHicStMDrhJ1TjN+1EuxpCd6lyX80oZAUb6quLvY/lfIEe0ksbVWXs1OxPoWsvwl3w8a+IgjzWPDfTUCnFEDyS5IBrXr8xhidantsyCTuH9MW32ktQfTqlFD492U+DYqlFgNNZ9Irc+UsHuMFdOzBX44fQSSgOj42Y6n3o1u7mviLlsRe8/XGst2a6I6uYmHCc5NfIc+VHSt9u1/KfktgxUPgmLmUNiIUNOOcUDbrvNRPyk/tbvAyYSpIIqEmlIyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During PM freeze (e.g. S3 suspend or S4 hibernation), device drivers like
virtio_balloon reset their underlying virtio devices and delete their
virtqueues via vdev->config->del_vqs().

However, page reporting work (page_reporting_process) was scheduled on
the global system_wq. Because system_wq lacks the WQ_FREEZABLE flag, the
PM freezer skips it, leaving page_reporting_process active during
suspend. If pages are freed into the buddy allocator while suspending,
page reporting invokes virtballoon_free_page_report() on deleted
virtqueues:

    [  196.795226] general protection fault, probably for non-canonical address 0xaa1436fe70dae6df: 0000 [#1] SMP NOPTI
    [  196.825967] Workqueue: events page_reporting_process
    [  196.831038] RIP: 0010:virtqueue_add_split+0x233/0x4c0 [virtio_ring]
    [  196.927073] virtballoon_free_page_report+0x3a/0xe0 [virtio_balloon]
    [  196.946943] page_reporting_process+0x370/0x4f0

Fix this by switching page reporting work to system_freezable_wq. This
ensures that the PM freezer pauses page_reporting_process before device
drivers destroy their reporting virtqueues.

This aligns with the driver's existing design. The comment in
virtballoon_freeze() states:
    /*
     * The workqueue is already frozen by the PM core before this
     * function is called.
     */

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Fixes: 924a663f75e2 ("virtio-balloon: Reporting free page reservations")
Cc: stable@vger.kernel.org
Signed-off-by: Link Lin <linkl@google.com>
---
 mm/page_reporting.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 7418f2e500..4dc6f4b852 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -80,7 +80,8 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
 	 * now we are limiting this to running no more than once every
 	 * couple of seconds.
 	 */
-	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+	queue_delayed_work(system_freezable_wq, &prdev->work,
+			   PAGE_REPORTING_DELAY);
 }
 
 /* notify prdev of free page reporting request */
@@ -343,7 +344,8 @@ static void page_reporting_process(struct work_struct *work)
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
-		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+		queue_delayed_work(system_freezable_wq, &prdev->work,
+				   PAGE_REPORTING_DELAY);
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
-- 
2.55.0.229.g6434b31f56-goog


