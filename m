Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78A5606D80F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=V2HwrWn6
Received: by kanga.kvack.org (Postfix)
	id C7B356B05B5; Thu,  5 Nov 2026 09:02:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B526B05B7; Thu,  5 Nov 2026 09:02:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF04B6B05B5; Thu,  5 Nov 2026 09:02:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 884CC6B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:02:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B3341A0A6C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:25 +0000 (UTC)
X-FDA: 85401230250.27.0D4025C
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1782BA0014
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=V2HwrWn6;
	spf=pass (imf25.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793887343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AjygjqPp+LU8Tpwd/Jn5OR+aQMhYb5drT5DohnvIqA=;
	b=U98IhjDAMYL1o912N5OwqXygWQROweMrDANHnrFlNs5di6KePiE4X13EM+LhInncZXxhJU
	bXTdALSdg5GAsFvYvGD0LJomBMa3w9cqL6y84KGQ1tzL1T4+4A0s9RF8v7GmkLWe6Dd3LF
	zbHlg2ybxNXkwqy8mqoVcVDtK8h/hfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793887343;
	b=YVzVgNVbBJYiZ/XVG35WV4E1OMsK10nqI3izf5IgY1Xrr9IbzW6V8zaowthzvY0nmwmQ1T
	o8uJ9rkMOOvnqIX2lz8Lf4/15Q5Fmp8C2aNljE79ZvfXrTAmElEpKnP2Yiu0nwivwsy0YE
	LDiK5QRIEMViUJ8mN/EimUY/KfhWVlI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=V2HwrWn6;
	spf=pass (imf25.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b0cf2c0785so16410337b3.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 06:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793887342; x=1794492142; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1AjygjqPp+LU8Tpwd/Jn5OR+aQMhYb5drT5DohnvIqA=;
        b=V2HwrWn6WahrNihoWczuBSIeJkaIyUlDqgZixF4MURk72i9K3aMrqlcvyuCe5rhNJ+
         PbWQQTyK28YRTnEcRIGVBeaa8hQArP4GXbuAlr849rls1ecJzolF89B1yXkspIgdS0BY
         5+eMMANZPrbBY3+F6k4rBdiA5IYPE0NBN6meZZy6lf/YK3BO3cLjXeHQmKkMu/g2nEoF
         9ax5qVUik+zC2QrwdieUgGmjZt8bgbx1AE6k6w7TswEoegtEQyZuR7ZWnRpgeUhSBVMS
         Y356N4egU0scL7ye5w/C9yRk5mP5SRV5TeB0/wNt6x/GNSZbe8xkmhrNAmVBIvSAKrgw
         ryIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887342; x=1794492142;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1AjygjqPp+LU8Tpwd/Jn5OR+aQMhYb5drT5DohnvIqA=;
        b=oPuBTwMrGVkcMAlAalrueeD7e9grweagj8LRc5jd+sPjECDlpIR8POeHL+Q/6JNd06
         37IhLQZ7fn3h7k8GzPBC4nNC0VgqAQZ2FNYQrbfjoMfErpJ3e6B60C+XMP6BEjLlB4ms
         kCqtwaozADkfNHeMJv5ClruakEfBgm6n4NHjHaKiJYPV+3oK4LN26I1UtIGX7RkTk0/4
         CYAINiSuYN7zVQ58UjNcNvhkNwfwm8xuFY8eL7n0H5gdiOcSnzjsCG1pNlMEDv+lSnGm
         6zcbc6XQa7xjY6zy4pQXyrUZ1DUFCXoFQWYR0FI5PhG6Q++w+i4ghT8/9IJz4yC1xhRn
         ptaw==
X-Forwarded-Encrypted: i=1; AKwUvBwqFIUWZfiE0Xg0Zxr4fcf4EiN7oJjVOVUn6w6A0gyzCHDEuotAQnsLqJagYrlDp8qwpnaBDoVlcA==@kvack.org
X-Gm-Message-State: APuU4Z+nrN/kuStnKBrItPJx8U5iGLE4X4wUtmXHVVTTUvE8p4wJgF4m
	us6oT2o1GD5EXrVGlPrlCw7/FsYhaXdk7jfYQderC5amZm4hiQy4whvDWNmf+CH9APc=
X-Gm-Gg: AYBFou2jKX0/+PBrPXLdbEw4/RY2aKwY1HufKffJfSam3KMYSLlaIIkd3GBy7iiJwGj
	wyGMXpKGHXYEfFZZ7B1eDZpK8a7KdMNgcHVkG+vsdozqyyUw5ZnEOxkePrgfVWDoGOH6++V67vp
	ZCnSQ0HtcrtAYQpZ1p+6Tmqn4BdWsn9ysO8obqQt/ez4fCUrRKNnzdY1L2hhIHBeLxcyCepfmCX
	fSCkHRCC8+772eHuwdgjUVkBeQC3xQ7FMvUtqOxqDdLIcua5G/M2vX0+tmm0RBPUdqFZcwPHH23
	uQzFA92KSXi5zzBiC7LIoeB/u8rLZlcQy5zfOh0uzDMJH8CjaE80XGuhvzh5JPH06FNxS05RmEY
	6hVLvhSBHAMmsBfsnbSFDUrMJ0jUg96LFg5N609vI4mJwWTgRdMvbM3r3Zs/Xj9OmWDjNJumt+H
	A8SUB1pzX3lY/OrGSi9gBwZuwn44nJHDfaDEjwtAOeMHFRuCUA3UG/6n6gn7pTQQJfRPzNIyJg6
	bQdtxQKz5v9mabc7vvmV1t9Z9ETVnfaomVtE+czND7UMaBZRf/oszmRAdpb3IYbVyEnD0K5RfIN
	w6wQQ3jb0fuYTAyzZlPoGtm0jcMvw6wv8vn0p1b/QuaDjtoKWxWE8X5BkFTHJ/uRXwA=
X-Received: by 2002:a05:690c:5:b0:8b1:8d69:1cc4 with SMTP id 00721157ae682-8b2b674ff05mr119999217b3.63.1793887342119;
        Thu, 05 Nov 2026 06:02:22 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b30999b889sm40810627b3.33.2026.11.05.06.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:02:21 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 05 Nov 2026 14:02:06 +0000
Subject: [PATCH v3 4/5] mm/mremap: restore VMA_ACCOUNT_BIT if the unmap
 fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-b4-mremap-pre-split-v3-4-f8789de76849@toxicpanda.com>
References: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
In-Reply-To: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793887333; l=3151;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=j2bm6JMr2osn8Qe+88i9nwdaizxDIC5HyQtYhwBkr1g=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QOyWWe5JtKQmbZYH+FKKfQ8CJz7E02+qTtiWg7Laf/RYd/R4vg1FA1mwrrJYkicnf3aZKb/30+A
 k/tQgJ/ipPAU=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1782BA0014
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jwoy4b1baytp5bs5djbswwwdjompzs74
X-Rspam-User: 
X-HE-Tag: 1793887342-426876
X-HE-Meta: U2FsdGVkX1/xZ3MhdF33yiihdW0swXHtIlsggtMUQhc1kib3KzVHeEHwzpVUek61Oetbf9icrOYge75fdTJwr37GJ8NqIJxTwvcX/nfw6RszbDkQ60PDM/Rdd122B5sY1zivMaFTYCQrQw8WGY0Z6DlitLaYUlr/u80nKO+fF9VE037wkDn6mRbr83g9qyl6InwwQ3tbpWVBPmk2xmsbTpGN4vgF08RVkX1/RIjVVK7I7xMwiWq8Veyw1NoS7Fwz+0rER9R6E9MqTzqGisxN+flC2qLJinFxynbpV3aCc9Y6a+LNBzEIVVCbLicE9NO6Ew1/ZQR80paah0OJYcmbzwHqQUuxbjKKWNswz0OoOhGfjx9JWbNM7v0+bPuxBgcRNo2KKeNZF5VzRoy9r8j2Z13INreF3kg35l8VNBb1W1su18BsElLpaVj+xrrsGO393lVrHq5yN2EaW/Cl999jbArMKALZE1pqNv16+20oJDCpAqXdCfO6LAYaFJqDEyhUVkSrNo6DVh7pig5IhGZvVQmXsSnSbC/7I84OPE3gsxGFNXKdKkLZCHN3Mubvlrs1xURkaZLxcZKQx3aQdjIqxhMac9N1ddncj57ytr0AHs3cgWDXSeM/UVwx18q2TURmFdFakJlMZMe0TId/hiYc002f0LMr4rF6MBlkTcwYgr8YHz7q1miR96eBkvTciuGMLettOyXsemn7WVZ8DIJJ3QP80PVzz24G7UNLm/EEuY9Kn01DJyUX35BbCCUZ+EhEFkDzOiENsOC201yyhmg0W0lCnnD5yD37vZZoO4DSGy3xarmMJSFZ/Cq+lfZ79RiLCZ3waJDC+3hypkj1R1HYzphuqjl3+7b/VfzA/0Inh/OY4UtZtrQk+F/QSvcG+Cxjer614JrVevXIo0/9Z9Hxx4qKSlXkvjZCRj80tsdM5Hqs/s1BQzRlbN11ATK3xbn6NRYQHBMFaZonDwXJ7Io
 ofgOBnec
 YURJ++ilpWTS6KgF5+nfEcmVl9Ae68G2XXHPd5dCDHg9NgGN9r7ZIPefsfMQFyRY3KcG07cWCDpsQb7gTh+GAzRy3m7v0JOcjwz6/VuTzAekUmukYl83hVZjoLywKWqs6q3PsipylKEbzO180Xqf8sCPOF14x62VZoeksASL81NvG/Pu2gcKNJHmfByra6o7dxeMNWZ/wTP/tOl8B5HWrKzLKgcHGgRqtPAUiUUTAIXvwj0UApbuWFtv8+rIp/nhEUHKvPcLMT6iYxWtcgGkfHtTs4gb4TGBmAkbH65THaw7jFfW0QPczi2qy+ZYPgc3Scimct8/5Oa5SEQoHNg2l3uPAPnDBYsCt4R3j3t6TjQylXqNAz32fZeBC96XPl8555vvHo8YrRnnCNbY0NJ4CeJMi4eYnX8dMqvq4K49mkpFsI4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If the unmap at the end of an mremap() move fails, the source VMA stays
without VMA_ACCOUNT_BIT. Neither munmap() nor exit_mmap() uncharges it
then, so the charge for all of its pages stays in vm_committed_as after
the process is gone.

unmap_source_vma() clears the flag on the whole source VMA before the unmap
and sets it again on the remaining parts afterwards, but its error path
returns without doing so.

This was reproduced with fault injection: each failure on an anonymous
mapping left Committed_AS higher by the size of the whole VMA after
everything was unmapped.

Fix by setting the flag again on everything in the range of the original
VMA, on both paths, with a new helper. A failed unmap may have split the
VMA already, so the helper walks the range.

Fixes: 51df7bcb6151 ("mm/mremap: account memory on do_munmap() failure")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/mremap.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 71c9f335bea8..4d1e446620e2 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1189,6 +1189,19 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	return 0;
 }
 
+/* Set VMA_ACCOUNT_BIT on all VMAs in the range [start, end). */
+static void vma_range_set_account(struct vma_iterator *vmi,
+				  unsigned long start, unsigned long end)
+{
+	struct vm_area_struct *vma;
+
+	vma_iter_set(vmi, start);
+	for_each_vma_range(*vmi, vma, end) {
+		vma_start_write(vma);
+		vma_set_flags(vma, VMA_ACCOUNT_BIT);
+	}
+}
+
 /*
  * Unmap source VMA for VMA move, turning it from a copy to a move, being
  * careful to ensure we do not underflow memory account while doing so if an
@@ -1246,8 +1259,10 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	vrm->vmi_needs_invalidate = true;
 	if (err) {
 		/* OOM: unable to split vma, just get accounts right */
-		if (accountable_move)
+		if (accountable_move) {
 			vm_acct_memory(len >> PAGE_SHIFT);
+			vma_range_set_account(&vmi, vm_start, vm_end);
+		}
 		return;
 	}
 
@@ -1271,28 +1286,10 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	 * | A |     | B |
 	 * |---|     |---|
 	 *
-	 * The VMI is still pointing at addr, so vma_prev() will give us A, and
-	 * a subsequent or lone vma_next() will give as B.
-	 *
-	 * do_vmi_munmap() will have restored the VMI back to addr.
+	 * So reinstate the flag on whatever is left of the range.
 	 */
-	if (accountable_move) {
-		unsigned long end = addr + len;
-
-		if (vm_start < addr) {
-			struct vm_area_struct *prev = vma_prev(&vmi);
-
-			vma_start_write(prev);
-			vma_set_flags(prev, VMA_ACCOUNT_BIT);
-		}
-
-		if (vm_end > end) {
-			struct vm_area_struct *next = vma_next(&vmi);
-
-			vma_start_write(next);
-			vma_set_flags(next, VMA_ACCOUNT_BIT);
-		}
-	}
+	if (accountable_move)
+		vma_range_set_account(&vmi, vm_start, vm_end);
 }
 
 /*

-- 
2.55.0


