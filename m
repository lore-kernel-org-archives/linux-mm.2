Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811A6606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=b5bKrowq
Received: by kanga.kvack.org (Postfix)
	id 9D5E96B05B5; Mon,  2 Nov 2026 18:46:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987216B05B6; Mon,  2 Nov 2026 18:46:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875096B05B7; Mon,  2 Nov 2026 18:46:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60A216B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:46:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4AA0A7C19
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:30 +0000 (UTC)
X-FDA: 85391815740.20.065FA90
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id C49BCC0003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=b5bKrowq;
	spf=pass (imf28.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793663188;
	b=BbbjfGmHqldNFgPsop3gU/KlF3FqXNi0jMrJX462tsPEjlW7pslVKui525rikDgHMbuG4b
	O0mUvM0+dnFpsPYmYi/RXufuFh1r92XKGJLGFNi+8MV8ioyI34cT2W0dn+B/m1G9QOhD4/
	r7zZh3Bsy1rMEb9RbdMSXgOA6rGAuLU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=b5bKrowq;
	spf=pass (imf28.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793663188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVsB8WaU+J768xlFM3Tj/5btoY4EDvTplUzUOE/dQq8=;
	b=8GZy4UFvMJxgzKpqB9MUQvGq7xce3Oy6/Sd4e8taoQ20gE7nfBXw5mm5S31WCjLmtJzZ5o
	ftRmnKyk0ellfujmvq9N7+v5Vam4lubhK54xfis4NoF/wy2Id4YSLwq1FfyPPNXNF7rq4N
	ckR8/YLKkI3SVILVmMgPjU/3kXf9oL0=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f269e335eso470902485a.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793663188; x=1794267988; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cVsB8WaU+J768xlFM3Tj/5btoY4EDvTplUzUOE/dQq8=;
        b=b5bKrowqcZanjnTQKxEnaCnNx1Wfra+uvZqTjftbpMUC2GF4HCkxM+P9Hjf5+OsWaR
         aFdV0kHmIQ3GnFClz/EEsgSpoKumkl0/vxpjhu/wHOHeFIV482sLosCsC7mGeKFIF2T6
         dhGdo9IdXa1C8JyEV4EtePIjdFmpyVp4U5BSslai/Ws8Yy8WJKsgLkXwDooF27KI5lMG
         AspoSevbA/md7/14SE3r7gHLodvYaG0FVTVWc+wu6mrit73YLu24g6vwJVZ5v9opW9gG
         D/dIkSqvb+kYaxO8NL21tcI3VhiGm43gq/vl0vPwyuAQbBQ9FsHf/yWlxfddczDNc44/
         +iMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793663188; x=1794267988;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cVsB8WaU+J768xlFM3Tj/5btoY4EDvTplUzUOE/dQq8=;
        b=LndO7KLfCxmmlQqTXkmtqUWi7qoB0PMP6ow9qt1mxpVepoqQDuzZntsRAnD5Kb1wOO
         uaOPOf3uZpEuu5PS7ulW82e29PrwtoKlCmo6NTb//ZkLpv8rjtTPa17hpHkzXGH4QFnl
         RFNXPTHPNZJNOYx6uAt5NtV61B9eaem8nHXe/nsWW7OCWVQsUFqgF5R96bdbVzICqgPm
         3gz2pi0heZl20ocu34brIpjxraBbQCUActALCA6MiQiB1/UyM82ddiY2KeHoxK62nRKd
         nRALOKXTRChJGs/aoCTaqHPpMGeWJaEib/iaZ4irNLClyrLeXgO4GHDV6WbRVCdEbeS7
         1IJg==
X-Forwarded-Encrypted: i=1; AKwUvBwpbgv5C/03pB+fEdkswmPFjRwd2kN1fx079ay92Z8WSPFHh8ir2LaKdd0FhDZayd6P5y9wF9a0qA==@kvack.org
X-Gm-Message-State: AFq9FYL6noZ2Rw/LPeBrUm2uDJODX4Z+EliYTIDi9mzKm4AcrZwNEUSZ
	XSzsZ2yXHeWGG/3WRymQIOzsfCo3RrmFy3kzpeUgjMJAQ9+XxW2FQpXbMAgzKjr35EQ=
X-Gm-Gg: AYBFou09PvUE7FOTCJtMFeaUpvOD1+JnBB5Bo6BjUiOVbd88ByQWZgu0On9GqPtfHMT
	HskoXK6pUQzJN84FBMNyXEjvyYWIXiGsUklhZRuO5FZouk0rt7PPwojFjzLQ1CPhW4hAS84qF56
	Bu2ObnzRsi+RDZmcO5khytUlirNrUNfBr8GVE0ka+SkFrqk+7aeEGA0lOiOxbw0ZAcXY9z/IFmu
	otM07st0P/j2K3es02APGng2sokx6EgPvR2KRrZXpTxupbY91P0KnS1yx58fXKsQgF4cOqgwmta
	RZ/Px4VEaw1WmDdd0CPsbuiN9JOoSfSpblZLA8ttEpPna13lLx/4zTxMpI9xk2mzmh5n2AuQmva
	7P/ikz1YGC7WDQnOnmA9RT8Bj3E73nbyaccZzEmkuviBZRFCnDCu5kHHr0O9RU1HJ2QUh/p5D3J
	CR8bNlJio27SzS+iF29QKDqRpPOQuEJjnWdQF731TJ3Awtiq2n92kRHgSvrgRfnbNLXPrwHtwHa
	JAxlU4Hf18tzCcW+6P632g2JjYCSPjyp23RakV46j53iEaenOqPcqdLi29fPV17qpK3B4FLhkSS
	MGG30wOJdgxR0WaYEUAuD50j7tP9zK19Ez7Z1p8iOgWDOw==
X-Received: by 2002:a05:620a:468e:b0:944:d7b:e7a with SMTP id af79cd13be357-944216e8791mr1922571185a.52.1793663187720;
        Mon, 02 Nov 2026 15:46:27 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425ae643dsm940964985a.43.2026.11.02.15.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 15:46:26 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 02 Nov 2026 23:46:00 +0000
Subject: [PATCH v2 4/5] mm/mremap: restore VMA_ACCOUNT_BIT if the unmap
 fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-b4-mremap-pre-split-v2-4-d281dd11ad7d@toxicpanda.com>
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793663165; l=3038;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=hejmPjmhMSSdGHARM6cFYeryiimQU+IQcD7zLm8TXxQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QFtkQRwHHmXutBWwulu883BomkjhRXC3jiAuIqAW0TROZJAzNff2reNlyeD+kDnK0g//fFGgz1p
 jjynoVsultwQ=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Stat-Signature: thoqn5dr785ksi6tm8r44t1p78aik5uo
X-Rspamd-Queue-Id: C49BCC0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793663188-699001
X-HE-Meta: U2FsdGVkX1/DWsJK6V2viRGflMGsXCA4w0oB1l5tTNWRxtcGA08KfFy49BhW4Qt5g8lS8l+U+RJgUfL1E0j285p5CbVIrV4Q2Z9xjZCUw9+H2h9EyWrD1g2GwcV+5vaDRrkZ2rh93SCLPVXHa7BBqf7rVBU1XLTEa1PNhM2tIBB+f9ZdTKuiig8jSdd2UxLkaP4mic+cVeGQOg522cFtoiaDBx7Kgg8u7P4uwrvhAeKt/QHpcYBwQQKLru0DM6r29Af1DKZAzB9kGAXchy2Oht3C6mAXh13P0WYuEAFFk3r9vbrKCLgX+g3woYvF4Ma5I6kS8HjO8fvs5LnZIVJb0obihp6Sf3kBegz/msLvePmGjsD0UcxC3Sosf+FFUhoaHFB2OXunZSzQJYK8fkDYlesQjN5q7MOQohKkzlhczwjThWZZsTpeq63I3AQ4wolv2fhvIP4NJ9m08KFpu48MLiD5cNxQR1H0YmKykA93XJnPkGhMG9ocQyXK2ZQ8/E5HmZIbuqRg+2XPCT6rB0HHC6NnWD2wefqgwihgQKpStNv4ge/eAndksQtt6mQrNiRlZoyZ0YsrqMRX4O1Xh0k4yjsMwf6KwsP6H7HSNmGoCmUSpTNx70cQNjrFzbbXD3m8Nn+hC1YnlsGFpML04gjsXqQex6Gd0u5p2GugByT3sZ9z3GWpw0yqImemyKdvMh/rHa6Cvi8AhHNXLTsuH0lcevoA0/c0XZLaTqYd+neFWUvYxljCuamuBYZ2iQLqBHSw1pUw1zp74E2ynVOCBs1AkVXCqLBJ2Nj8Sm+Nwe7qMoeNZpSLlhLcJLiAGRsfP20EbalEE6kQmKhx+dQ1YLKpMC+mKT9CsMSeeQ7maXAP9cQuMbCfnC5Mb1VXG3z50EFPT9JBkHDDtwO9eSOwIUnJtLET1FPPS/L7Q+altVoSt5qckKdxVyX6vN9Qmo6qo5ZJOiFF9TvFtgVYjsesavK
 usQLJbhB
 RCHd7VEJ01vsStz+KRVLg24ekmNGhVr2mCteHbArcEdRnUpB8WigcG6etLzLMFfkvx5OjwcPIouTfitfkPhTGIFue6wAq6svdNld2B1cZ+Fypw32XqMMEpVktjQCOXUyXKLkWVT3S9F9AhPuUuRuaiPkne6W4Dt8cmhMV+gfa6828Ed3eGfFRkCr08q6CpMXXBFBRc4cMsu8fCtRKrYELH9mbt4NnGu7i5sNQTTB2cmgOYtNwVkrDZjtgt/cOfdIz/7VQkAav6/Tddk8cmOi/06ucw6zB4ZAWc15LHwkuY17BPsyyFMB/NOIEZjDL6FiDFYy0kskX+NMOif8pbU0cDBnCDEZekxcRLqU18OTPiMf8/EkhVLLEXGOWncBD4SFM38RMJXQeNRG+UgqAn0WeE1LMu1sxhwT4o+as
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


