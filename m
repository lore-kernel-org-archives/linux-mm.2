Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BA7CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38ABA6B0098; Fri, 22 May 2026 18:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D056B0099; Fri, 22 May 2026 18:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278D96B009B; Fri, 22 May 2026 18:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3FE6B0098
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:06:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8418120987
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:36 +0000 (UTC)
X-FDA: 84796440792.08.59F1DC3
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id D3E45C0009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WXzfVHbI;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieNLELksxQ12VWfSTE2wcDumq9qPO5WfoZYKitlIUko=;
	b=wh1Zpm1WQeFRZ8QThCR6/mi9fTSToe6elAurgXhO0QlX2bvcYGQSPbd0flCW3n2hHLytGe
	sBDuvzOTr3wTOiD7EJMazFSXha8kUTsBj0XrUzvAgzrCd9KKBkhn3hXK+YKL0zRhn9E0Lk
	XAbS0LeNeEROwoK3Uegho+8z2h/3GBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487594; a=rsa-sha256;
	cv=none;
	b=0duxGO4mJdFAHZ/7umEinhvaQpQOvyIPKpEKgb1wZ8FiSEY49iluaTw6jEUGLgtMPeguLk
	eq7zyH4GGScql4GzwqXC59lcun+PNO82lHWMbg44cbbIY/P6mC/HlkaNA0/wDltEqTyEoc
	Lpbfy0d7Qw+gboFQbIJS4Y23aH2mIt0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WXzfVHbI;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dcd17e19b6so4432623a34.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779487594; x=1780092394; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ieNLELksxQ12VWfSTE2wcDumq9qPO5WfoZYKitlIUko=;
        b=WXzfVHbIX6YhmbEYsMLQGYMy6HEZCLV9uvy/Kp/etvB9OxltlTDTxmOMNBlEAvZM49
         cx6N2eccz7QjEPQXPxRna3JbMBC+qiMBLMUMJ9FzxaXnLyXlc4wxZNi4xacLyjnsaaF7
         gpeHlqPlvQl0J2DtJBop88MNwY+XmN8UDj/sFTaZ7jTnbgljqiZbHe/EZQoWbuGxNGWy
         ++4nKQk0pm8kLaax2mxCUXdab4QIuLqudZKHt5p2Zj6kmmaPe0U8By9vpTR3PzbwpAcx
         pEufio/0Q3c6hQ8/QgVTXCvC3WSDdXr7cdHtDKDbgYEurQOCSPQT0eeSm0c/hGJ4Bn6n
         aBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779487594; x=1780092394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ieNLELksxQ12VWfSTE2wcDumq9qPO5WfoZYKitlIUko=;
        b=TyFbQyZHeySSt2duCNJ7yJtivgcgV7Eg0yGCzdyXEBC2XwQOCrY7Bx/AAj+VBDVfNC
         ofLBZTO+owQEE/JZYOyPVO5wmNyM+B07qSlxd3Jypi5nGrRCcTJrs41V5U/9clYpiOGI
         1hg1kOt72RRGYVsDlSd6Nmc7JqbMxz+Gr9N6sBzPyXgWtvISvDqhVdhyNQzYMetYDaKI
         ttZk9/Mqp4oay17JAt8/1grUInn3gPstRL1Jl9ImEx2nGFZ4dBkWL6Ioo8iN9EZhz4Ur
         qr+KdGzDJ+yZT4wRmjhVhf2rnWR05o83ZrpQ5zNfhGVBljfaOQwociLuc33XOjIU7w4I
         2nyw==
X-Forwarded-Encrypted: i=1; AFNElJ/BsyWycN1aAr6HisAN3RaR/nfK8/OeY+z9DRwdl15J2yBakCho0a3dRLZV2MMc9xk+HUJpa7Fo6g==@kvack.org
X-Gm-Message-State: AOJu0YzihVFtQnBGhjj2WeyJuyA3KXbReuX1R7ns6ugLrL2YrteyQHoh
	GWp81B5SQ9NEsA71mhWcbvCLTE3YjqTSj2t6nNo1qqxSyiFKl4jy71Zl
X-Gm-Gg: Acq92OGm5H77yjISrdhnlnuf6YsCvO/PnjYBWkm+P1hF3pAl/SiDkiKafJE/hkOh+17
	0Kipw/bAQXLUjr066xI+AAMtQbO8WJ7+3FD+S8au5e0IZURzJyT8Xfvf+rDSrGVPNxman+gPaHA
	ghonEnfSXXMo5efyu+1n11owHHV8HskKqNNzpChdE6dRzFiUJCGVmlGy+nfMGAy3GhQ7bSBYL2J
	abzaTXc0VNBIWZ8bQDYKeRrH4OmFjksSxX/Z/2xYl7oGlZAmyMiWslgGTaD/Zlt0imjt7YGmKSn
	Cgh7fVzRGACoMjrKe7Qaus3Epu9yU8tytrl0KwUtuVnXLEXpsxUceVOp6BsnzsBhjU42NrOFKEU
	WDr18jYtyS7z9CFRDsHkMcSZ201eP22KysARgQQ7BDTyRDT/Wd7fEblARAw5vyZ0ESywncYcwsh
	d1Oa9YLDtgocY1J2B9h5zNXkH18Q7xOxmgL7Y3CnCgIaH0ijhIT3zQ
X-Received: by 2002:a05:6830:6d4d:b0:7e1:cbe3:bb1b with SMTP id 46e09a7af769-7e5fea05c4dmr3245063a34.0.1779487593743;
        Fri, 22 May 2026 15:06:33 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6064aa0bbsm1941729a34.12.2026.05.22.15.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 15:06:33 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/7 v2] mm/page_counter: use page_counter_stock in page_counter_try_charge
Date: Fri, 22 May 2026 15:06:20 -0700
Message-ID: <20260522220627.1150804-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
References: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D3E45C0009
X-Stat-Signature: xiwwppjfwhbpu1xkdxuapappesobcn4e
X-Rspamd-Server: rspam06
X-HE-Tag: 1779487594-880229
X-HE-Meta: U2FsdGVkX1/P8BVATq+C3hcnFXFEMFkuaf7h+ZLPt3Ga9I6Pg4lsRlFDjJXrgSkxtMKXKEt7dmDuU6W6T5B6qcEpqdCllHfmUuMgM/r0BZRdeTB6mVImodjCaLCqJMmoytw5I83qfuE/16dpgGiGuqd2l2tZkt6A2oww8YQb6581qHQS0QtbdfppJW8jU1rsPwtLTmdJdrdgpvaOikUIJOUn/4byswThEAOej6fMpbcfuK3McwK2E3FPhakA4u+ePhLw14ve83/Z/7gSPwhI94BU+1Xm39C9Z+wFSgW9AErjpBfc7d3bKofTs02hqgYrXJXSs6GF7HjHjC4DjA2ySPfFWDc5zyD4tX8jZeKwS6DHZZ1f52Czh51Ik52YrXCzJTbE3fooEWcEgSTDm9BEGk634m506kpxdVUVOLs/0pPo9byc/3lxcdqsGTylUt3RS/Qg/VH9ZKPsUETT/TC9BPqd9uAWQhDMz35shmCHPPL05Hi9KtBbp42Q/FcZDWTTHRWPQrLjexrtxT70LO3dvNFvEAwvlvmDINtoKnl4y/7obTE64btfGNc7Ab/Vgci6StknH4e+P/MFSaCl5xIGD3GJnONUmZOYL+JoE0brnb3Wfm1Bg6f5JRiKXV1HySq3pMsGk135pJu3ep0pRLU2122zNGWW9p3aZ21EwExHKX8EYdbCo6TyGr5SFNdRY3Yc+bgQK0oxRokdTcc8A7J0ZdLnv50IHsxuL/L+Qg/RPSDEuDEG4J2dO+0cxRSAuB6bshtM4PA8NFrOYoWDhRYkplCnyAv9DL012npsRc2SL+t162VfDMyypcb2Cwe3DfLW4zJpzpENU2nQxtrM/8oUrGKZD9U4pvUazcaF+jP+E67WrFethcfpJOL9Yjtty0le/0QKYs/COrPsfQQyki2Y5qP7HWabPCDCPsxqZuY0S4foZsZZ5ezQN3lfQ+WUdL4fPnhGD3t6wvsgXXpu1Xh
 7x0hKDp2
 saCsDeWfr0GW9h6cnW9AgcI5YHow8aM1yc2pT3vcDw4Me3PnfQ/1OGa44FSsNngTW3vgFM1/eupznVduAotZ9g7HmsbxkJIYWrBX2ICKZbPNcCvtGukJGxd+gcJDsk8vhJnit4vTuHcLI2DKdS9GOExjZx+pMFIcb+y4VZsnfnAFwoZI2AcTSf+gGLX+wdQPFaHD5rZLw1cQAzfjfexoCh+IsNwhAr1J5AyEvQ7GK7eVsLBHr1DQY4XGU6JjObZOiVgBdhWSvpF9t4V4NK+t7b7cOWrj82mHzcaXaKigilNIz2ywVuKK2nTFJGyVcAt3xYWHXPmTPbXvpY9kOPDDz94UMewePz5O4oc7jHYJCM/RwoufVfv0eCU/dOoBUGvGWZa7aGOSj9g+kOuggz3JSVBWQkcRoMs6FJhYX2AgsD6F8RfB8566i27F6iEpR18SqUQDBlQi1g0Ne1ww7twsCq5MtOvu4acrDXuh8z859+pYF1JC8YkBumzoDtDh7H+PTc0s355BSTUG+XSo0VRwqckOG/6Ix2qQc4uNKK7c+rNc9fyYci2rh8ByOu14eqLfrhd2iqUlU75PgXiMJDg9cpsaVqRD+92ggqfCaDszofijxH9ZPfc+CIft7qXWkZa3SLCShdF9llqb75qlFq+T32Dcqs6JxCmwmjKbycMhcHquQJjW604inJ+75HoL7GxnhjAIt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make page_counter_try_charge() stock-aware. We preserve the same
semantics as the existing stock handling logic in try_charge_memcg:

1. Limit-check against the stock. If there is enough, charge to the
   stock (non-hierarchical) and return immediately.
2. Greedily attempt to fulfill the charge request and fill the stock up
   at the same time via a hierarchical charge.
3. If we fail with this charge, retry again (once) with the exact number
   of pages requested.
4. If we succeed with the greedy attempt, then try to add those extra
   pages to the stock. If that fails (trylock), then uncharge those
   surplus pages hierarchically.

As of this patch, the page_counter_stock is unused, as it has not been
enabled on any memcg yet. No functional changes intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_counter.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index a1a871a9d5c49..e002688bf7f1a 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -121,9 +121,25 @@ bool page_counter_try_charge(struct page_counter *counter,
 			     struct page_counter **fail)
 {
 	struct page_counter *c;
+	unsigned long charge = nr_pages;
+	unsigned long batch = READ_ONCE(counter->batch);
 	bool protection = track_protection(counter);
 	bool track_failcnt = counter->track_failcnt;
 
+	if (counter->stock && local_trylock(&counter->stock->lock)) {
+		struct page_counter_stock *stock = this_cpu_ptr(counter->stock);
+
+		if (stock->nr_pages >= charge) {
+			stock->nr_pages -= charge;
+			local_unlock(&counter->stock->lock);
+			return true;
+		}
+		local_unlock(&counter->stock->lock);
+	}
+
+	charge = max_t(unsigned long, batch, nr_pages);
+
+retry:
 	for (c = counter; c; c = c->parent) {
 		long new;
 		/*
@@ -140,9 +156,9 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
-		new = atomic_long_add_return(nr_pages, &c->usage);
+		new = atomic_long_add_return(charge, &c->usage);
 		if (new > c->max) {
-			atomic_long_sub(nr_pages, &c->usage);
+			atomic_long_sub(charge, &c->usage);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
@@ -163,11 +179,31 @@ bool page_counter_try_charge(struct page_counter *counter,
 				WRITE_ONCE(c->watermark, new);
 		}
 	}
+
+	/* charge > nr_pages implies this page_counter has stock enabled */
+	if (charge > nr_pages) {
+		if (local_trylock(&counter->stock->lock)) {
+			struct page_counter_stock *stock;
+
+			stock = this_cpu_ptr(counter->stock);
+			stock->nr_pages += charge - nr_pages;
+			local_unlock(&counter->stock->lock);
+		} else {
+			page_counter_uncharge(counter, charge - nr_pages);
+		}
+	}
+
 	return true;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+		page_counter_cancel(c, charge);
+
+	if (charge > nr_pages) {
+		/* Retry without trying to grab extra pages to refill stock */
+		charge = nr_pages;
+		goto retry;
+	}
 
 	return false;
 }
-- 
2.53.0-Meta


