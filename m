Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9095C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E806B0093; Sun, 13 Sep 2026 23:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2463B6B0095; Sun, 13 Sep 2026 23:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135CE6B0096; Sun, 13 Sep 2026 23:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE2016B0093
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:34:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65346140F7B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:34:18 +0000 (UTC)
X-FDA: 85210949796.14.5C3B213
Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6EA9F100004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:34:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=quOVkhvj;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789356856;
	b=z29JrFMA+MqpgYbVcZPu/EJ1Tf9+gGIWu8otWD/IPXT479AdXF5mocQCjLUxqNuM8BrxzE
	dL0SuFai2Sj+B8lwNHfgV9Fs5RgrZHp1sI80R5K2wK6btit22MjH2v8gd8D2perhMDCboo
	avCgutnxrKEna/06DzQnD7IekuAS4KE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=quOVkhvj;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789356856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajKAerFFepbwqMhXIfCqb5kXl0cmqS5YGukfG1CDznY=;
	b=Y3hwvvUI0h9/ck1vAxDVopORShma5vCuH8dATePxkCgmJVHvKParBRh9kiCxJtw5QMc/nh
	lDfDZ5jERtwM2ciqWOatLJsTTtGi7UL+8Kd9iuxB4j0SPu7YVrUttD/LSTVUW66Dxni2R+
	El2kDc6TKaldX7mpfu6p/cdiHzP8vaE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GcO7629LLmWdKveTN71W2Hm5N+m1skxoYeOST5aDrko=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789356855; v=1; x=1789961655;
 b=quOVkhvjkgIAyv+cCaLsZXZhIctFJxSfOV0sKiZ22mIcuMjCDn4z5XNF385jQy85Cwv5IkAW
 x0DkSZf63o4CgbfK7GXbduRXa089ONgyggIAuRc7T27BW4NM4+MhCzVxO63zp0zRWDmdaJ8rdKa
 d2Iuk39tME82mh6nv94ZdsQU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6ddbd71e14968a1a;
	Mon, 14 Sep 2026 03:34:15 +0000
X-Mizu-Trace-ID: 6ddbd71e14968a1a
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 14 Sep 2026 11:34:02 +0800
Subject: [PATCH 3/3] mm/vmalloc: extract show_busy_info from
 vmalloc_info_show
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-vmalloc_study-v1-3-526f68559706@linux.dev>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
In-Reply-To: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EA9F100004
X-Stat-Signature: 5otac1m7nsduo5sghnt4f4kx7eutxn8o
X-HE-Tag: 1789356856-596370
X-HE-Meta: U2FsdGVkX19q5/7uCVN/zR5C+06/d0I52Iy/UmRAOiVAVxTuI5rP59mS3RN5+UeCgnIvA62KYLDMD22BXHEsiviiuxu7j/KM5ddShGaZkMCD7PgnO04JoAc6SoulZG94Z/O3VrMbHIO9ZJNDUSz2C0i7rcyueqU8dKDPj8YDydHQvg8PYOGl418UL4R1Ha8vnuPJpm+FSp8oLx22FEIT4V0mFjSCbfyEVkV57Vj0bFS0iwHudzzRDsnU1jUxb2MZCi5SXyYGh1DhXItZB21W7WcMc/qDCeE8CpLRGlxT1iaf6sJv3TT5b5nFc8te1mNaWv9D4f31cr4I3dTfSzrVQjZHUS+PY3ZZ0oLzNilCt1xGxMC4JZZgsBLFtWolnUiybX3AHJieEoW8O951bcLU1KbrDg84yF/S+zCX9uBuXZ5XqPcWCJEU/KnDaEwF2vgEGQoCF/7B/WXKBEhr99wVOtHssvYI2scrCoBz3+9c5s/vHjoeCoXADC6XOJYmRQSwaXA4MdnqQZct+agjxmRH50Yj08TM8E0JboXUUNPr4Sd7SzUv+QITxEo3eaFv1i9dBH0mG+LjdrYNxkpRAfqjBp9Rm+gcR3Mo1ZQKZO2OoYm4VUhWwGQEtSq4aFgE9XklZdcI0dsguQGAklKydDkFxi9ka4u5iO5o8d+sHECnCAMXJ53dMAhE6LY3rjkNOZkcSmnUXUP0Sq2dTgnUCq6ZSmvUUNUKej+0i0fnC3YtlTslJxwVfpW90oOhk7N/AUWcIbmoX0LyZqdMtA0m+f1qIk7x8lLOYlyVi34elx5s248JP8g4wWwuOPmLdMw+ibi+nPwzTvVy3cTx5QXbhg8vASVSFTyHWVSzL5gY7D5GSptiY3yKYCEnJXpB6SQbrjl+Oo4lVcVSDyJ0b4+5Se72j/yxn1aQBdKQQRM8e+0rDYbfzsK7FM5kXwmwj1jn9bUwkkTUQsC9deRfxqsWSj1
 97Y2SCaW
 Mmmo7DrerxyBpXlv/xlrN0xx0SIFDDb/wJqfp7Xvz/H1c/GqMziy4NZifhsOFVoNs/AhWzYGoQg3O+87v7QdZ9NWPXooTodXIdMy83B5XF5MKVFkcJ71CdRKmSOAtZRTVgeEH8+oI/9/UN0mMXeDbDL18UdGiS/GViMYqRDKpwGfiJtdwn1uAv31JTWk8FyaYoDMFMBeXfZlqMhOTL2Y2W9cy35+ybHGrMw5Vm+6X/l4tH7XzaLVTXBOxPJKVfJIbvSp0OjJz+iL3SAWJFVALGXwioA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Extract the busy vmap area iteration into show_busy_info, mirroring
the existing show_purge_info pattern.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 797933ba9451..7638845377f5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5345,12 +5345,12 @@ static void show_purge_info(struct seq_file *m)
 	}
 }
 
-static int vmalloc_info_show(struct seq_file *m, void *p)
+static void show_busy_info(struct seq_file *m)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
 	struct vm_struct *v;
-	unsigned int *counters;
+	unsigned int *counters = NULL;
 
 	if (IS_ENABLED(CONFIG_NUMA))
 		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
@@ -5415,12 +5415,18 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 		spin_unlock(&vn->busy.lock);
 	}
 
+	if (IS_ENABLED(CONFIG_NUMA))
+		kfree(counters);
+}
+
+static int vmalloc_info_show(struct seq_file *m, void *p)
+{
+	show_busy_info(m);
+
 	/*
 	 * As a final step, dump "unpurged" areas.
 	 */
 	show_purge_info(m);
-	if (IS_ENABLED(CONFIG_NUMA))
-		kfree(counters);
 	return 0;
 }
 

-- 
2.25.1


