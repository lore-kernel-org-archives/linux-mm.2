Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27088CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2327D6B009D; Tue, 23 Jun 2026 14:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2090E6B009E; Tue, 23 Jun 2026 14:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8F96B009F; Tue, 23 Jun 2026 14:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD9686B009D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:02:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49BAA16729E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:02:12 +0000 (UTC)
X-FDA: 84911946504.29.19C9078
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5FBC9C0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:02:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fqIx2fk8;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782237730;
	b=rXKq/ZsjP6KRQChpnJnTwXhVt6OCSRAOCQwda7oV8d4vZlM6orgOOl5y9NPo6smw5OCMOP
	5dmbMfeZEw7ocmDiZIxrjMbosyp11v0cGoRZzUEdSrvCk0HEAU+mQNoXItfi2sv2YWVzK8
	7I8g10LUqs+OEeYpPGhbLmdKN1UnHVs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782237730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trCYdPhQh348weekSBC7Ceo7XQeHFRdxOAyYAHYqFjo=;
	b=oTnuLG2q0rvIpLfoZ3q4abu7stibsqVibkEVC54wIYiAKQzx6fwf4Rb0IX2rwEkE5LjTmK
	ACw0FawVvC+/aQhecciYFh1KaiwsiBop/K4DIz2NU2k1iNkWBoPZydCF+sD8EBShPITk0J
	hMtWxEH4qUAlCDRHo5IFWtqXXpgiNwE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fqIx2fk8;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a11c68ae41so90193eaf.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782237729; x=1782842529; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=trCYdPhQh348weekSBC7Ceo7XQeHFRdxOAyYAHYqFjo=;
        b=fqIx2fk8oqjMPjOZHKnjvWHDVYly7cKZQUJQpFbcYYP6kSXW6sfJFAhSETfV0G2GN8
         wx31KCWcqfpaVcSEjyCokA4ibNxjOwMMbx8s1chnLe4HSYAhTxcf9/uIUqOINXj6h4X9
         oXWuMQlWpcnX893SSTuK2G8/qS2rJunvjlxGXusTovs8NeyzSxS1GmUI+EslJ81IMdT4
         T2c97jO9AjhJqP16wRhNcJpwXpxP+lB+4qwjmsbAcNazpa1N7wi9I4KF85WAUK+Y4bQK
         i1zR6Zqslsy61C1Uw1zNBFf1IxwTElU0xVosRf3tabSsHSnn/53cicv0liJcIZT/SHd8
         mdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782237729; x=1782842529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=trCYdPhQh348weekSBC7Ceo7XQeHFRdxOAyYAHYqFjo=;
        b=pv+pemUb5LI2ya/mBVNEcwBCBsp9S14y0BDQM6CMQ8AVDSqYLBJQba5vxR3xtioADZ
         KFVPu9E/YdhME4iS7qEVYJX6Zssjz+Govmiu6EvnOQ2feZF3fTsxlnXZpQFyYi4911aa
         2cS8Jn4d7X2SmWrDAVHGkn1H8KuVgf/TrqWo0mZ9GfsVNmR6FQc32Qg/qiUiprnWbQ4E
         HxsHW9dzQuAH4sp7jHg7e2Hiqu4+J3Hf1uXv2B6XQSKroZu2/2mXlV4Wy7FZiYkykcjb
         lBng+pSe4RHFQ10U3ej6jQvROaLNKxfOfy+4QkZ/wf/7LIq7E+P7hEcZeeOI3sH1jBBp
         FtOQ==
X-Forwarded-Encrypted: i=1; AFNElJ96nK4cnbxzkzyrQXJAkDodZJ9Bt2TOu4tWfPFrRN6Q8D6P/1n7tdj3aZcGQR0fKT3NJ0Ehkf3llA==@kvack.org
X-Gm-Message-State: AOJu0YyxIMavXY5npB1ZBEw7+bUmvAgbW9X6gSbd8uDwfGxIC1GHSzJY
	7fYzWXuJDIRIPgCuUDYYVb/n8TxAjRP/R0SxPTkkeTNCGjPlEMfPRLnl
X-Gm-Gg: AfdE7cnVSR5E7xlotv9vSaoiSuD6dHQ+cODqwZCYMBj/EzD1GM3sa7A3p1PQkU5b4IS
	xj4fwPNGcP1wzZfsi+is5dCKa0Id6XuGe8oJBRhvgue+MP0BHB1PJSJxkvmz2JirAMCH0gp2mfe
	GkecHtkmnJ34yeaVXhfD+igMg0EcE2pBVlgxcKywRC5Rd5o4sRFsxptsi10G4KchRMLycbX1XjA
	lfpX8lULNpPaq6OyqWA9DyBKggOXlSBnlU4mufwRVBArJLMj+N0+Q1Z8KuS2cR0NAbxjzXfeSFI
	hddICb//8Y/C8H0FzWZaEUzUL/kcyNF1S2P+GlZtdE+avCyvdDu/S7j75gJyy7aII1SpS6qzLHo
	22lM13jb1Ysa/DxF4oyARExStvEasfvBeNP6/uC/23W1vQUzO1NK6Dk6C5XnOPsU2f+cXOZuHOp
	QAoE9maa9zH+xBTzk+ptDtlbIClgqjrs/TBo5HYA0yxzY=
X-Received: by 2002:a05:6820:3082:b0:69d:f855:b748 with SMTP id 006d021491bc7-6a11623b266mr2355735eaf.34.1782237690173;
        Tue, 23 Jun 2026 11:01:30 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a0e9f2a583sm7583532eaf.1.2026.06.23.11.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:01:29 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v4 3/5] mm/page_counter: introduce page_counter_try_charge_stock()
Date: Tue, 23 Jun 2026 11:01:21 -0700
Message-ID: <20260623180124.868655-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
References: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5FBC9C0005
X-Stat-Signature: d5dewzr1p3h3yx31uyqesnydbejmemkm
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782237730-724808
X-HE-Meta: U2FsdGVkX1+3bSjo4Jdi4mhlLSu/aV4VeDYrTbac8cpO8XpkI9BZxxwqnGMbXC6F9HsBUef1CSBuTolHMTd9UTFmuSS7YT4orPc1RxxKX7RyYUPSGay8sK0ACXnvYSpUARTx90Oipvcj8Xz7kTUf+gseKOauUIEYZ8TibBUvhUire127Gk0PE6fgohXvijqch0QUGMrzG0mbr9SdDXgK42dgOE4oliTFXKrMUUtSepP1a2oOt1afndtqIGhQUla5jqWP9+OeSQ7ri7ySY/LxOwq0L7Y5HS8ZOxgRj8mr6kFBLziH2icZphXUpR0YmzHE/iuA6CgYCs0VOSMRztopGdPytMOViyU1Vxy5tn5sdn65UQnoJa3TbQElyLLSV3dA4/MP9y3hKH3NCZcciPOC3erLA2yG/ZYn4bm5EbQssp6XabW6+HjrJ6xMHk7ETUiTzcGsqu+/2ZfzH6dczIVjQ3hN7PwhZQphFunF7RRRUkfJHBP8Qc/Bf96ICBZEyuuhXEphvwTdv54nvKloTYVacMk3UtvpT1B9MkA6FJb55t1xpkD2gSX3BTuYsuLnzWOF8nv10Lv2XPmCMRBexWgFkMLn87xhBtSRBkqy/N6moP/K8zrQHQc+iFs603aLlSU0E2QwI7DxOQTUuiMk9HRan+y8mybFMNUCDtRODRqv86pPv+ploQwuGZ+FTc4GrScdCg2SqDa9y4ipW+PgZlrCz0eDGANch58hnoe1Mw/EN+HPZyjLeWgi5Ox5Dn4f5SwhkIFpk7czPvqAKVI7uA0P1xYyun0ukgJSBhh5SuxXp+aIYBNo4pS93ebsRB4PdfHs0mNUdmDnROIddRNiJspHqyY0TSTP/brdYD61e/UwgrKO55c9A9Ag/dZ4zBBdlALRKVF2b3Lh1VVpSECDNA2cgp01Y32D4HXFYxtDcMnRWsKyA026o3ZXVPgaOtki2tVHM9uW80uRY5XVHo3Xs0p
 LOHxzAND
 RpXUWb9Y0P1bdgMQ+0S5Pj+nGKWS5OPVaQefQpiBQ45BNviIY0YdAMsZuaFd3p4xDO87MoS5b+82P8Y/i1bwDA1BlLyOIIR0sBSJoQH7SurKo/o4wd+tUBSA7VSE+mWp93lu1JhSuhZtI1z/7kz/ehew++TFHbbVgyhU4frxnIFjj7I0970w+s/2819szvZFKjOL/Uvc/snxXGOTqKSi2iBqbcSS5GER2QRPdQJfXznPlanRWooMBT+U7B8JzZW/utzcr+qRjz1yCaB4GcpD/+zzZhBjQxNXM5Ax9wR6zDqhx88AXQ3SSh0WcribdpF4YryiL5VVc5LtOGx+u1+yLuqzfaMjjTSlBgDhu1t7putCv64b+u8NHUw3nYvmACvheLnFp51j7stnLJPb+Z7O4zAxMg4hR+DfwPkhkWCgUgrO4s35paOx0aZdeJDEZYqf3XomoyvZu2crbAz/0l+YUQUDPTbESxz3JU85tqNq2mtpUtHlcR+uwAS9DanZhWC41q+TTW4vh4Uim2UvxqmOAXr/gCe/R2cSHvH7OX9vdzb9DQms6L1MDBLfIxsDklCZFd2zkivs2KOr9RHV/xlaVGcAzVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a stock-aware variant of page_counter_try_charge.

As before with try_charge_memcg, it first tries to satisfy the charge by
consuming the per-cpu stock (and skipping the hierarchical charge). On a
miss, it tries to greedily overcharge up to counter->batch pages to
refill the stock. Finally, if this fails, it tries to charge exactly the
requested number of pages.

The number of pages that were charged to the page_counter is reported
back to the caller, so that stock hits don't trigger memory limit
checks.

The variant is unused for now; memcg is converted in a later patch.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  4 +++
 mm/page_counter.c            | 48 ++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 4abc7fe7c3494..b97b5491447e4 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -84,6 +84,10 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages,
 			     struct page_counter **fail);
+bool page_counter_try_charge_stock(struct page_counter *counter,
+				   unsigned long nr_pages,
+				   struct page_counter **fail,
+				   unsigned long *nr_charged);
 void page_counter_uncharge(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_min(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_set_low(struct page_counter *counter, unsigned long nr_pages);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 6bb48a913a90d..cce3af3f19e03 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -172,6 +172,54 @@ bool page_counter_try_charge(struct page_counter *counter,
 	return false;
 }
 
+bool page_counter_try_charge_stock(struct page_counter *counter,
+				   unsigned long nr_pages,
+				   struct page_counter **fail,
+				   unsigned long *nr_charged)
+{
+	struct page_counter_stock *stock;
+	unsigned long charge = 0;
+	int old;
+
+	if (!counter->stock)
+		goto charge_exact;
+
+	preempt_disable();
+	stock = this_cpu_ptr(counter->stock);
+	old = atomic_read(&stock->nr_pages);
+	while ((unsigned long)old >= nr_pages) {
+		if (atomic_try_cmpxchg(&stock->nr_pages, &old,
+				       old - (int)nr_pages)) {
+			preempt_enable();
+			goto out_success;
+		}
+	}
+	preempt_enable();
+
+	charge = max_t(unsigned long, READ_ONCE(counter->batch), nr_pages);
+	if (charge <= nr_pages)
+		goto charge_exact;
+
+	if (page_counter_try_charge(counter, charge, fail)) {
+		preempt_disable();
+		stock = this_cpu_ptr(counter->stock);
+		atomic_add((int)(charge - nr_pages), &stock->nr_pages);
+		preempt_enable();
+		goto out_success;
+	}
+
+charge_exact:
+	/* stock is not enabled, no need for surplus, or greedy charge failed */
+	charge = nr_pages;
+	if (!page_counter_try_charge(counter, charge, fail))
+		return false;
+
+out_success:
+	if (nr_charged)
+		*nr_charged = charge;
+	return true;
+}
+
 /**
  * page_counter_uncharge - hierarchically uncharge pages
  * @counter: counter
-- 
2.53.0-Meta


