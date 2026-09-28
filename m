Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD79C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 04:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF016B0088; Mon, 28 Sep 2026 00:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0036B008A; Mon, 28 Sep 2026 00:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E386B008C; Mon, 28 Sep 2026 00:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 707276B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 00:42:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EFBFA0B62
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:42:02 +0000 (UTC)
X-FDA: 85261923684.19.B5A2544
Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	by imf24.hostedemail.com (Postfix) with ESMTP id 89BDA180002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:41:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lwNnNSls;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.38 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790570520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OVW9hC5UCKC68y9iOXThuN5MokNCxQyIbNLFUKAbKE=;
	b=S/8kpWPqS5YQ6/S/JzWcXWxQPC91i9hLGo+GroU+Q8lzUhh1LbxpEV5/B+zHkhuWnYZQn0
	MfLpt9816TF5qYDX7lFJOUX+G22kss61d1+/c5fghuz6xbzh4SjcofdoiaknJtQABNwLr7
	EQ48nO1f1hNgWHOUrFGvqidn3GiDvWI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lwNnNSls;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.38 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790570520;
	b=1zRsAnS7SrDGIW1LLvtLPeExRwCN7rZsG9xWHQRuzb7ehzK2eU9GTdmh72G5HNZPvlVx11
	cDFXbE8JjgdzIvwUjSbsMlR8WFitx1MHXwHhQTPL/NCKGOFG7cIQPRUTEXAQ+pHVfLTJh6
	fGFmT1HF2ZftjV8NlTkHfPeFlXpFX1Y=
Received: by mail-pz2-f38.google.com with SMTP id d2e1a72fcca58-882f2861859so183014b3a.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790570518; x=1791175318; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0OVW9hC5UCKC68y9iOXThuN5MokNCxQyIbNLFUKAbKE=;
        b=lwNnNSlsk5V3sMaNg6JEouAZ/N66ELq/Fw3BfG805XZzH3MSvP+UdFPZjnqvnEnaWm
         0fayzGiiFdTjGChxzBHspgj85ice74vDhnSxpjYbrnT2IQErVWB+R5seLJAUYAvSOPDv
         VVNA/yqjGrj7Xwvl7asSGtecHX3ArF0GB5yHvBslN/VcC7G1DipKncqvzPqRGjZkLHsK
         4rYqWuNXYy0xWnlvgNjmqQQYf+JLSm+FVogR/D/qxuUqUl7P+Ed5j2S0XV8QPtcs701k
         WvGHRz9PGDILXcp2/ysJ3I/4R8QLzPn/gxPTfyW6B/RLbH1jMF4zN32sLfmbAsFfXsxS
         U4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790570518; x=1791175318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0OVW9hC5UCKC68y9iOXThuN5MokNCxQyIbNLFUKAbKE=;
        b=HSSwMIays1g6QhMiMwUPBuaxG8IyNc3Xummen3BecAysv7ylcyT/XuBmT1dCrNAr7L
         JHAsWwFEJl4TZGVwqcRUca8Gz19NMcqOTU1CiK3iOQEd2XTz4+aMrtbqH8EzawhQPjca
         qVODk4tc/i/JrFDhZ54aIzaXBw4yS8et98L51pJba8zBjkglpJe8C/QSyM4hqvXsPfZX
         7GKeLWRqXzLhC3Du9H2m2/AlypfIgHh1prKcXhf47OzzgAKCfAcvQGcDsku/4Myl/AP7
         ALjzEun46j0RPC/qMMWXh3jJYveRIgZxDWw8WgnWL8J++U2Kgy3ywxdJ1vgvV56IWZ0b
         MqVg==
X-Forwarded-Encrypted: i=1; AKwUvBxgs7j/hJgDS4lP3I3WZBb2jTAwj0wgjLyNULqpdN7nTAOKPgohHMqW+cUMOCG82D5LMCInJ5Wm/A==@kvack.org
X-Gm-Message-State: AFuF++l4Enbm46oWob+Xeb7yIKY7vxlfd9iENZUn1SqQCl1UJDt5Vvod
	hV8qdxBHCOA7otHwnpHs2K4eeRTHpWJD8cSQOE3jYttmWMdfwn32RnWudC23kvzc03A=
X-Gm-Gg: AYBFou3VvbtPx16F2s5m6zatOO/NE399Mg/ljzxX8pMuPiosUyYpzdfujA4pWIrbEsx
	aZ6nPALpEP2nu7YcWIHqrN7NUNkXPRPHOB/cugGGeb+jVWc+jjy/Uar4JzxwkqGVP+EUaor4ckY
	mEobU+hfLhVNmK/86+XY4J8ipOqNEaboFRPXwu4uUOi1HxQZUH3vwFrP/EYT0cOiF1pw9p9HjQe
	YcNdtvMbglnRcJapuYXpXiwlKPBMRHLdhjCpm1+F/foqMjM3heOewokfAMVkpyzcQXgU27nFohr
	Dcu0AHBCeiK88ofZuQExCGVJ7uVmwKOfHnw6GYUUWGKIQSHMacmncQDmIEPw4vh5QUo8L00/7tv
	Ft0IUkkGkuCPR+6AuhWSz8SzCAcl8tIJmzFT+EuprG9DqhX2OQ47kQ5Sd57W+94+t5zjg8HaoAQ
	XP7A/E0WMFY24lYX2XWk0++BFtuWSYk2ub1b+zZ8Uq5BrkNeyyqpBBq7tjm8qWy7eWXVjy0N+b+
	Qg5+f1Ak4c4ZBgUTG3K2Ttu3gQMTg==
X-Received: by 2002:a05:6a00:3d09:b0:881:236b:748a with SMTP id d2e1a72fcca58-881236b74f5mr3613151b3a.16.1790570518137;
        Sun, 27 Sep 2026 21:41:58 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feae8d827sm3405869b3a.36.2026.09.27.21.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 21:41:57 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH] fixup! mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Mon, 28 Sep 2026 12:41:48 +0800
Message-ID: <20260928044148.3300333-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-8-songmuchun@bytedance.com>
References: <20260927025441.741633-8-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 89BDA180002
X-Rspam-User: 
X-Stat-Signature: hgn71roreuh4firrqxcafwh67huaibjk
X-HE-Tag: 1790570519-593947
X-HE-Meta: U2FsdGVkX18DkAYBkh6iWmcCGA5s58ynU60AA2huXm+ixJMQlvTA78EfNElhvmIfPHU3aw3o9dYhOrDHqrGcFCZr7/2+lHTpQUB9vfKpFBue9irnyMzUuxBGzF5Pw9PVIJ+iDg2ePnLzcgRor4Y9EiAeJknvLt5zwiQ6w5cctMK79+/FYdN6n6grkefQZPUBlPd+bD8vsxomy0feb46nLBMkG0yn1aqkZkwYuJ8zNyzn7G+fGA9V31iAr04sWUKTyUMhAjPqUrxTityKgJkD5haIh5EVk8fu2J7SdoEJ1cYF3YAWFT4s6kM8xZPCj3m5VO28nhCxOlag+ojVkF8PuetdKk9Ss95fk6/y1CLBunH3LnVWvMLjc2l7MqlvqfW72nbj02R7UxsorcWehkHU8uXmaVECNAkXcm6xBjXK4Fr6kU4RIeV6pyVOqNOJvwjipJlJFxfeYqLTDjKwrPW9IppzuEFBITv9tCu2GeLtftTEXeJjPrBdnmAERxqx26GQYZXRZg6o0G3d/RF9GkaTDgsCRMF8YTXnw6LjcAEn7TAbTR9sBw5inCTnu0iqqiDMttOi0czn0WP9tka76kUu6nYFjJbUtVzaPevacyPzztU2Fa8F9UOlqWs9+2sFKYHLurG+VPHztwEao/XtA6BiKK64VbK1PRN62K0ow2ju3bjnbIMNVfM45rlElGuvlduaCFNt4LSIUONvFlvQw4ThVqmGq1NNS6N2q2xoxt0jRoiNVMBWN7JuVWJooUsLaZn+hpsPfSBVkzQzjBeosg/enPqRsxTmvHF6WfevOXJqxClGOhuhS3TXTMcXZCUdpA15n0nyhV9D4YG+LQDJYgK3M5KEUDUOF8tA8Tz/LbSgdM2KwKUuKsNITLl1WTfBjAnWGT1rN4+iT/Zg50xjzuiyhvAxb3EzvWOTYhW0vu8RmAVW6c4g6vX9KPJ613v8Oa6UdMYIGG9VgsjnMABee83
 Z68KMA9m
 homsaKOtcQS8auZjiw5yud6XERA6SZTwa23UXh/NgL1v3yo8tyKRBMMY/xTRXMySWw8ITD68dlY1pOx+P+oxhPC+K33vSSnRjJ+4/JHiLEO9+OTVeTpVYxA0s4cKDNnP57VxZHb0EdCx3c3O1hFYkvEyE7PRYNvusfB4erJnfUMTnu+EwpYD6PvPX5Cl1AuyQUnSASk2zHnKkQbTe2MATjDwlczX4dpr59qpXG8v2wujAP6UU9IzKiIn0kRdRb13TCb2e8Aamu9btxJCOp1i8DFlYQxp2xhGVgTijwQqRBPkr/CH+0KXrkJ1EUoPh90sHy8U7OeHvWdRN/JBUe6gsH3tPfdt5XUxK5sWD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each PTE mapping the shared device DAX tail page takes a page reference.
A sufficiently large range could therefore cycle the reference count back
to zero if population were allowed to continue after it became
non-positive.

Use try_get_page() so further mappings fail once the reference count is no
longer positive. The section population error path tears down mappings
created for the failed section, while the warning makes this currently
impractical limit visible.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b617ff1b985d..66de04f8863b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -278,14 +278,18 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			/*
 			 * When a PTE/PMD entry is freed from the init_mm
 			 * there's a free_pages() call to this page allocated
-			 * above. Thus this get_page() is paired with the
+			 * above. Thus this try_get_page() is paired with the
 			 * put_page_testzero() on the freeing path.
 			 * This can only called by certain ZONE_DEVICE path,
 			 * and through vmemmap_populate_compound_pages() when
 			 * slab is available.
+			 *
+			 * Use try_get_page() to prevent the shared page refcount
+			 * from overflowing.
 			 */
-			if (flags & VMEMMAP_POPULATE_DAX)
-				get_page(pfn_to_page(ptpfn));
+			if ((flags & VMEMMAP_POPULATE_DAX) &&
+			    !try_get_page(pfn_to_page(ptpfn)))
+				return NULL;
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
-- 
2.54.0


