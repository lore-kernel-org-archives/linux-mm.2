Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2F57CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0206B0093; Thu, 18 Jun 2026 08:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5F26B0095; Thu, 18 Jun 2026 08:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEBA6B0098; Thu, 18 Jun 2026 08:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA626B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:14:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E49AA0650
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:49:08 +0000 (UTC)
X-FDA: 84892559976.13.4F8AF13
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id ABF08100007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:49:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cab1S8DN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efY1I/Oiy9dWSMH3cgDG7DQ6JvUvP5mGEhX+5hBPKVE=;
	b=gCwW98tdSG6xwV+SQdVkLyPAyr8LIAW8UOyocSjzxqmhgJ51J/4x/9mvZU/OMFsS6GggRo
	9JbKbXdAvViBB3QxFb7XbhhTRUxTaNgt4uxlZQXvO9ap9jlQ3giNO+9LCSBZYAmwYwp6o0
	fg1kP2Ihtdxym1b08esKH3o+UyrYk20=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cab1S8DN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776146;
	b=XqplPgC/8KL9p7ECFVbXRUka+bhkDotrRoqMVU9qyxF4CnOhA3Sv77o64xql61XTF2H1Ry
	D1AI0y7nYvJgfA6SNfmc7uvaKE4o166Cf5ylImgmXo7Wc5imvZhUBWaXp3subGEULnpbf9
	kIaRdiA4YfZXKmxHMyH2SJ23b1xC2o4=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-137dd4cc208so584235c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781776145; x=1782380945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=efY1I/Oiy9dWSMH3cgDG7DQ6JvUvP5mGEhX+5hBPKVE=;
        b=cab1S8DNvJZK5CTmFrk1lvV3CB670pFvpPBERX5JQRXEWUMlIK9U9cu5fashs6nIIA
         BuHyDWdAoZ3DWjtVj3ausN9OxOr4HSUTZBzLzqwgfONrAKLue2zADKOBexERo9FxSVxr
         WoeJdw85eEMKUvGhPRa/FAAuanCbuZ2zpEyfJID10JwFsDHgQotC9EZ9QC09pHrRdMfz
         FhulmjlLEKP2BCnpGguJADqUlGC7lqO9pIrRZH5f9rCecwemrDAX0RA1sslHyfgm9jYp
         qKTdmX6XRci0fqcqSaj+EU51iXn2Ahy48rMd8EQPMgwli4Fxm/6oDf6DAUgVXQNI3Pjd
         NbAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781776145; x=1782380945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=efY1I/Oiy9dWSMH3cgDG7DQ6JvUvP5mGEhX+5hBPKVE=;
        b=ICCrpvPgNS5sGN4HYrqOG06phw0nRMTIJnoCkU77aozjrswSHKmzJcX21YwCdclT4s
         3NW0BPG157pqtZbhZ3d+go91IF4TaAogE17+z5qPgkjNd81iIcjq+JpE3qcLFTbc25CD
         VXzEu6d0dx0btCemLaGjHZ2qwbz85PZeGnLlXt6BQLOgQldsJKWwSbttJmZcNnj4XQf4
         yU26+szWPRziQbtF7FWAHGM/5e/hMj0cRG7IuZ8q/p2yszdg857tzs88dWDrYalZ2WVz
         ReLiq1JujXGvbq4oWgWVd6DG0pzS6Lvc9CePpKDFzsxr/SYxLRSdS4lQQh/F0rZ2e4A8
         XZKw==
X-Forwarded-Encrypted: i=1; AFNElJ+eGHctCXcnzOfxk5ujZkFSdm1Hb8rE7Rjn0EWO5nGpnzZyofAAEn02iOxxigHu9ONrxX/VdG2mrQ==@kvack.org
X-Gm-Message-State: AOJu0Yzi0HSt/UbJwSdzH1RSSfzc7cOiarNdEqthHyH7Vcwy1i3W6xZX
	eqmtVPciuQ2rHSPjml5FiiTw17BJXfyuXatZK77/4hCzIRlYKOeYnys0
X-Gm-Gg: AfdE7cm8E2mEedKIAb+ogkbpXuoEgVYfmBdCKmtqoR3xgInv2mD5T5lIzalyUqkEAEx
	VYGtDeOw2Oj9esfHCz4gNFR/5IKAFRLatbZ+8BC4QbtKdd0NLax7YpTC4oqWHBFH+XjACUWeCFl
	zd8qgOkKTcDRQmQaUeOUsiajzh6Kvm/LCwuZ6JPZ9VX0jZs3TMEAp0j5grruLynBAJjUcIwh1is
	f437e92tEFY3b9nF53yFqz+QHZIei3SvBuuFlqpSJw5eni3Pr+SLrE1vd4LkUXQ6ADTjgdB170K
	FbY/rTypBsSQlGBDF+W6I8bz0GIgCpWerlQoRzfaFwIcXbDyFe/3UPFymgWPSOftbYRC++AXwXs
	ecSIhggELQRItNnfXffZvOnsXPC1znSr5E8The40KUO8ssrc9OsQ+J0ODnzd4m2e8QfL+arUxTN
	W3YGEfWBHWYVeK6X2xgyAZy9AHI1ePf1quz5I=
X-Received: by 2002:a05:7022:672b:b0:138:38c7:6adc with SMTP id a92af1059eb24-139970bfa59mr1790051c88.0.1781776145391;
        Thu, 18 Jun 2026 02:49:05 -0700 (PDT)
Received: from localhost.localdomain ([104.28.158.224])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b91a4c7sm18069971c88.8.2026.06.18.02.49.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 02:49:05 -0700 (PDT)
From: Wang Lian <lianux.mm@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: npache@redhat.com,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com
Subject: [RFC PATCH 5/6] mm/damon/vaddr: implement DAMOS_MTHP_SPLIT handler
Date: Thu, 18 Jun 2026 17:48:37 +0800
Message-ID: <20260618094838.32805-6-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260618094838.32805-1-lianux.mm@gmail.com>
References: <20260618094838.32805-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: au6u39fu15s5fta9kwtpi7qaxqm8gd1u
X-Rspamd-Queue-Id: ABF08100007
X-HE-Tag: 1781776146-555632
X-HE-Meta: U2FsdGVkX18Wkw4xua6SAFr/t/RtY1Tc5XD4RI20yGqfvhWibReUF3u9SC+DlU6IZh2Aqes/VaXx1oThYtIooefyMFweXGIEi+0Hlqr9803zCtKdn/LEMFHKCPjvlh5F+qzIvFlJw1CxgmDlDSe4YHDuhI0sJWHEKieCTWNbC2WwBoUkuh2ycm2cwzWg62xWbx9SficwJod133F9RuzuLs9GVObzCF3zOt8SNluJqd2mYLDLf3reEfZjyQRV0ThfoJ65ZdfX2/kFfns6hcn587PKRp5aJD9rxBe+aDSZh5LKJQ3nxZIxpD80RUWTs7HDnLiFZItBQnP9odrUAAPrjcgGR1Slp11xXlKnRWmq1XxBs+/MqgnHUcVENjYKnLmLmrnXTzhU94c5aw1MMTAEFRpqKsDQSD4k/xn2Aj8gj6REi0luakqrBxU5BE1T1FXNOjJpMk/F2LwSW58AfmpSirYqOw3Mdh9wY24A4TZBB3vhfEHo0zH4zC8ijL71wkDe9CC+G7g/byrKLzwB4RVxZcSrlB/qlHkLPL+Jc5KfOEi8lOr/ykNVO0QA0skd/u6JtMriPgL2G9p43hZ01CPuimSNKSmctXBX2MjsJ1723lePF4XxZ2crJJoDqPu6NcI3j7wf3qdrtTbHU7EO+T0RRxMo2lrYcRbRVewBFMinz0iU4zaVeqBJ6UDKoinKsW63fkMeG0qCyQht4COehXObrYhXCOJVW/GdsZ8c6uDUaGnGyO6ef2DNylNcKS50YDpsneqPbwuD4Y7+4iwMx8hGbrum712m5y00b9K1L6PVqTj8w/mlFQ0IFcA8eHyTBPPy3bn/uiRP8ea8dQxk9VKkUQS9B6dVtecRFxgxRZPzWftPyJERive3ujYXxG+lBgfdKKT2AIXt2JNpD4J5L+2zuVy2Uiql8Hb0m10W56wEBqrvpZrB1km7FOY2/djRYG+4ur/02a2F4kw3+sIooWE
 K9BKYXS5
 ZxkJS6eZerMKgbTWzZxvTJtqomH3WgfLTv4datRqQHdkPouP3EsO1uVR1nzS4ELfAwVYnuXinOO6RLA8SqZWclc9kCrXYqieFuTd2oyq4IG7+dgw3CTO9vWCtjfIjnNv1kYUGV5d7r6ANlZK4+I3eNjGwuIJ1KN0zLnTVlNdM9dXIBAdVCcR5pM2UtNbzEVJzRFgq69czFjJnDuKBEsgL4S0+Mp7tB+Zf5xFU36lAD6lcdz7GlAQqC3PAuvUn+ySj/oz9L0nnQO3wUB4jHR/diWb0FHTQrf44F02vcTbnryvb6jvY6CUEHtAn5v8Fmw1TB5BWQGY1HKswr2zOreZ7aDv4JfTtaXizjnqIElAyo8g0zH5wWMvvkQPlrU+yVqtu/oHpFaA5GpcRQMcj//rBaRIAz48PINQEbc6n8YM5aldfHTCftnsBOvFQeaPit0KBWpmqMTuUw4TK98e5EQHFK1XdK9TQyA4O/96ab/Ir5wNX+c9zqfLd6lYGnMepxGeYS9MnlRTWdXZE5G7j/8SjBLMzJmC0EtDZmO1oQZ1zQx+xwLqdKuEFjHP4t3hVF+ST/FmbN4sLJU/0yYS+wi4/9jjV2GEK1WqGqXsXLSF6cobXA4Pt/AnlpjR9BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the DAMOS_MTHP_SPLIT action for vaddr-based DAMON operations.
Walk the region in PMD-sized aligned chunks, use folio_walk_start() to
locate THP folios, and call split_folio_to_order() when the folio order
exceeds the target_order.

Unlike COLLAPSE which is limited to anonymous memory via
collapse_huge_page(), split_folio_to_order() supports both anon and
shmem folios.  This is critical for tmpfs THP-backed KVM guest memory,
where cold and hot pages bundled together in a single PMD THP cause
DAMON to overestimate hot regions.

The handler holds mmap_read_lock per chunk for VMA lookup and
folio_walk_start(), then releases it before the next iteration.
split_folio_to_order() does not reacquire mmap locks internally,
so this pattern is safe.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
---
 mm/damon/vaddr.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 2a3757c13bf0..1957e390a277 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -934,6 +934,71 @@ static unsigned long damos_va_collapse(struct damon_target *target,
 	return applied;
 }
 
+static unsigned long damos_va_mthp_split(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+	unsigned long addr, end, chunk_sz;
+	unsigned int target_order = s->target_order;
+	unsigned long applied = 0;
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	struct folio *folio;
+	struct folio_walk fw;
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	chunk_sz = PAGE_SIZE << HPAGE_PMD_ORDER;
+	addr = ALIGN_DOWN(r->ar.start, chunk_sz);
+	end = ALIGN(r->ar.end, chunk_sz);
+
+	while (addr < end) {
+		mmap_read_lock(mm);
+		vma = find_vma(mm, addr);
+		/*
+		 * split_folio_to_order() supports both anon and shmem
+		 * folios, so we accept any VMA that has a folio at @addr.
+		 * This covers important use cases like tmpfs THP-backed
+		 * KVM guest memory where cold and hot pages are bundled
+		 * together in a single PMD THP.
+		 */
+		if (!vma || addr < vma->vm_start)
+			goto unlock;
+
+		folio = folio_walk_start(&fw, vma, addr, 0);
+		if (!folio)
+			goto unlock;
+
+		if (folio_order(folio) > target_order) {
+			if (!folio_trylock(folio)) {
+				folio_walk_end(&fw, vma);
+				goto unlock;
+			}
+			folio_get(folio);
+			folio_walk_end(&fw, vma);
+
+			if (!split_folio_to_order(folio, target_order))
+				applied += chunk_sz;
+
+			folio_unlock(folio);
+			folio_put(folio);
+		} else {
+			folio_walk_end(&fw, vma);
+		}
+
+unlock:
+		*sz_filter_passed += chunk_sz;
+		addr += chunk_sz;
+		mmap_read_unlock(mm);
+		cond_resched();
+	}
+
+	mmput(mm);
+	return applied;
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -967,6 +1032,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
 		return damos_va_stat(t, r, scheme, sz_filter_passed);
+	case DAMOS_MTHP_SPLIT:
+		return damos_va_mthp_split(t, r, scheme,
+					  sz_filter_passed);
 	default:
 		/*
 		 * DAMOS actions that are not yet supported by 'vaddr'.
-- 
2.50.1 (Apple Git-155)


