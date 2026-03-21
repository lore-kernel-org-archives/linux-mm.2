Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B17E1094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E2F6B0101; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6EB6B0100; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105D06B0100; Sat, 21 Mar 2026 14:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9DA26B0102
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD6BA551FE
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:56 +0000 (UTC)
X-FDA: 84570848712.21.B11E72C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC4D4180007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NGzkfDeX;
	spf=pass (imf06.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TuKVIsVQ7zRatZNVk/b8mbHQerRYjBrAaKpq9rXc8Vg=;
	b=QBlEPJxH5fVN+l1+7AZLQXqKG+y+Szlxj+RA8TH7jIGFvBcAB7SoOkITQa4oOomFcLOQyM
	q7fLQrQGM5Yw6nJ4CS8QPSnCmIc6ljqZlr7mhhwjfH5DIX5CNWUlJ6MdzPFRb2JbRpLyJ8
	HgyBQ+UiRB4TCsBPo8a2+PWlWYKH9hE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NGzkfDeX;
	spf=pass (imf06.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116354; a=rsa-sha256;
	cv=none;
	b=sLmTmQ1vO9LY16yKALDxjyVMbLFO30Xic7CAMJV6r2iOgEPusqvUDej8NJkAgCpF7cZaG9
	1OhmyeVdRPOaDRecwVCxMxrVATOcqvZNZD0XV28Wkpr8RIfOWpBXJZq+gi32xQkwvCDAPp
	35qk+yFuWaSbUraIEjHPWimgUMjyL4c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8919443B0;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8265BC2BCB4;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116353;
	bh=F2hoV91NbwBi3C2o5LYPDy0mIxp4r6AJcp++KA8Q6AI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NGzkfDeXe1tl5ifK+LffsZUsRVIRJZ95WGHuPK8CHAtkNnEYdGK4/1OcmXsZTZ5ev
	 jiCEzrxrbiJL4OuDiJ6Xhb67NmSXXhvOPfuj0etFIV3MZJ2aqSZLu1zUD6VCQqh4Qk
	 KrdOPcmizeiVQHBtNacJloWPIK3Kvcu+jAoJPRel6CZQ7o4Gxb86uf7Owx7QE6yx6Z
	 GdnCC8SpfiWUfs8ObRygUs7orvqUh0izR0tL/6pb6zhvT+SxbOfWR/g5EicV/i2GH5
	 ghv0TFhTr93M3n6hqocxorG5AVlXNfLETCAWTlF8ar4M0hM3koHng5T/myJ7yd9TCi
	 GXH//BlF7M6Gw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7961A109448F;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 21 Mar 2026 23:35:49 +0530
Subject: [PATCH v6 4/6] mm/vmalloc: protect /proc/vmallocinfo readers with
 READ_ONCE()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260321-vmalloc-shrink-v6-4-062ca7b7ceb2@zohomail.in>
References: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
In-Reply-To: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774116351; l=2501;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=zRiycWT30EskDdJb187oavYNW2pvSidAAoWxjYptHoI=;
 b=Iy7HQsfLM2cG5f52zW/32wxoytcChbH5qmqXDljNno6hiSOpCsM0jsfPSkf4jREnsMI2UYKAj
 oIaHkILF7FEDFDs3hMJoP9lBl/FLGd09YT28gU2s7//g4yA0mPqxrng
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: AC4D4180007
X-Stat-Signature: 7ptkkcjykbut91qtrwy3q964dbxtco13
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774116354-847334
X-HE-Meta: U2FsdGVkX18mV22AlFuFFBEDsMHBNMLypuOH2l6zLQNgh9bD83LCiYkocfAosIBjFcBw4gntfjb/iNziVDA3rfizxOejzTdZpW0rNkeXdirT/bPFzc4Y/HP7FEwmMKFKl3DQ2QP59G+j+PixOpns56OxEYZ48PDvICKOguGVu+u/Y+OPs/BeRHuxIb4VHEjIaYBLx6bqljVpR2BVbWHxKeYbM+WlnQZdb9YbxQyqO9zaFy88DfA9WFXGqdv/FZ1q3nAnN35n+1vTSV9f6Xs5sOarBg15ZUTZhpehrF0Sn6CLWRwtgTjs8CrdjISAaYkGceLeBN2SkLW4xvHBU+5gDZfy00s9uNYV7vEZET24Pz9dLVgIKiN7bb17UjkIVrwIpK+mgkvVJQ9VMu9TGjAVt5p9Es93OjsF5/AoidI5+3AqIJ6BOGTaIg54C9EWW4LNF1eLIC9NCsPXDTwMPGYWq5x05opBUZ2ZLV9LSKTs4fq9SjAVZjlex0atiLRk61/DKmzDZmGkO4o1kJwt75UIB3WvL99uShGBUYwwoHvHc+m9r7UOLHSd7XB15pt0oeo6zPYaqpcSREYUf4KtDmMYot3Kv8W4nH+1Ib65cFQMqJZQQt3VJR+6Bh1DgYYyTH2m31kHdl/A91UNn0Q1la43WRAr7y3ZeZ0XpHbmk3AEE7CpvkkLSE98xTiGs47Aac7hIoZlXIZa1HAEXYx3kXe3SrMOrr/wo9pj5gDIPJ3UQiNoTGGs4jt0a++H12clZNXEEZWTcXrZQAi07+DZ1mO3c21tF9Ta9CPmqIbmlvdTGw08Gbc0G3mAGs2eunEbbpGkIOzwUva0MXRxGj7E7JQl+7bHSXH3G0wanJCaMf6qlEYTv2bIiAGKmjPMw/bH1+RKUa3U0YeVRR7tR99o+kSP1Ff8CWi5FVoa3+l1Ej8RsYb9XeVmwglAwHFuI6QP2Zzi1jow+ipc/whufc5xE0i
 ZIozI15u
 FRXxOj4lAg452QUtU+6dT2sVwMODqj5iG4NrzGwaASAok8E96X574YghUARmuKGDVMxZWgso9xzyKuTrEPWIhWnCS47NXLW7Tx8JDVFPharluMw6BbfXo1VpcaOCtIZpRRR/I3A7ocAOyMpP6zTt+eViNXCG1SHOQdbPPOfxVCne932Y6NJMmGeOVEszmjsBmwMQBfSgPQaatsuFb0rSf9f8I0Vg7M2h3j6O/U6tK+w5J+ZKLu3wfKQ3qaaRNMYVVYfm8e3uGenqY+tV3VRzXXiVbicz+/6pXm5ZUowVHd3ZDJRQPH9qtLG5X3Zl9VJ7jcDADbsyEd5dJZDg/DuAEBTERKiqOHO5n3pfpSvZmw9vVDMiBthr7KZkNTxBDNckY0GV5Qr4F8igvcxuCm4iJdN1wIuVQpi+vKt5f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

The /proc/vmallocinfo readers, specifically show_numa_info() and
vmalloc_info_show(), currently read v->nr_pages and the v->pages
array without any concurrent protection.

In preparation for vrealloc() shrink support, where v->nr_pages can
be decreased and entries in the v->pages array can be nulled out
concurrently, these readers must be protected to prevent use-after-free
or NULL pointer dereferences.

Update show_numa_info() to use READ_ONCE(v->nr_pages) and
READ_ONCE(v->pages[nr]), explicitly checking for NULL before
dereferencing the page. Similarly, update vmalloc_info_show() to
read nr_pages safely to avoid parsing a torn or inconsistent value.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 64f5d1088281..7658fdc087d2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5204,7 +5204,7 @@ bool vmalloc_dump_obj(void *object)
 static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 				 unsigned int *counters)
 {
-	unsigned int nr;
+	unsigned int nr, nr_pages;
 	unsigned int step = 1U << vm_area_page_order(v);
 
 	if (!counters)
@@ -5212,8 +5212,13 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 
 	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-	for (nr = 0; nr < v->nr_pages; nr += step)
-		counters[page_to_nid(v->pages[nr])] += step;
+	nr_pages = READ_ONCE(v->nr_pages);
+	for (nr = 0; nr < nr_pages; nr += step) {
+		struct page *page = READ_ONCE(v->pages[nr]);
+
+		if (page)
+			counters[page_to_nid(page)] += step;
+	}
 	for_each_node_state(nr, N_HIGH_MEMORY)
 		if (counters[nr])
 			seq_printf(m, " N%u=%u", nr, counters[nr]);
@@ -5241,6 +5246,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 	struct vmap_area *va;
 	struct vm_struct *v;
 	unsigned int *counters;
+	unsigned int nr_pages;
 
 	if (IS_ENABLED(CONFIG_NUMA))
 		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
@@ -5270,8 +5276,9 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 			if (v->caller)
 				seq_printf(m, " %pS", v->caller);
 
-			if (v->nr_pages)
-				seq_printf(m, " pages=%d", v->nr_pages);
+			nr_pages = READ_ONCE(v->nr_pages);
+			if (nr_pages)
+				seq_printf(m, " pages=%d", nr_pages);
 
 			if (v->phys_addr)
 				seq_printf(m, " phys=%pa", &v->phys_addr);

-- 
2.43.0



