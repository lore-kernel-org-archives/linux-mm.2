Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55CFECEBF8E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 01:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3048E0031; Sat, 15 Nov 2025 20:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34F88E0005; Sat, 15 Nov 2025 20:47:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE7E8E0031; Sat, 15 Nov 2025 20:47:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B30D68E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 20:47:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53279C0875
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:47:30 +0000 (UTC)
X-FDA: 84114783060.30.DEBB997
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 89FAEC000D
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 01:47:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="KVq753v/";
	spf=pass (imf10.hostedemail.com: domain of 3Ly0ZaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Ly0ZaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763257648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydqY8kHaLqM8e+ckUd1GoyNEbjtXYhx/4GzlhdYJPLg=;
	b=JXEbVLgXfjrBosrY5ZumQuWhkOk5ZTFkNRa3Wb7G5p2E+jO0vz/TDkVt84H7pHWKSjiqd3
	rWrPXkZyiQ1yOSx8JEHNygIeqtd6W7MCqUuFWTfW8iIt5FegtYS43QpcLwV5ihY8DQ0Hfv
	/+GSnaRjWS3MhFtJDdNbkX5AsRtiEkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763257648; a=rsa-sha256;
	cv=none;
	b=IvZSCR2rILypXcY8PwxMHXA/O3Ca08WJrVz3Q/Ex/Lp4lGjOxP36ojTSvixKTuUziu8/O2
	pVxIMWWcoqn/zjOgTMkLcSOgWPHJskSTyvaTKdsSPLKwbAbu1EaBG3Mx0SBFToOPwVu0iz
	jCsDYk8z9Sh7jinnKeEpeO4S+/qxlho=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="KVq753v/";
	spf=pass (imf10.hostedemail.com: domain of 3Ly0ZaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Ly0ZaQgKCD4onfvn3fslttlqj.htrqnsz2-rrp0fhp.twl@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34566e62f16so1412978a91.1
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763257647; x=1763862447; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ydqY8kHaLqM8e+ckUd1GoyNEbjtXYhx/4GzlhdYJPLg=;
        b=KVq753v/zI7uJgIovlEVUSqVshqNq0Nht/210sbq7PY9EIDMnWRM6Q42hzfqXW3mBz
         sefSvZHjWDYsFB5gSBl1r8fmeg4EdExRx6ntFVzq4Km+OFiVsaKBVVeUdQlTjiIuYonc
         q8R1ZorX7Nwn1E2s93RzeujQtysoHle3FXg5JFO5Q9BeuDwPS28Lb70CUWtXxUCa0J0N
         ScKGVBXlquaz96EvQRNNBdm5c0hj9E7bC2y42+LoS7c8/Y0JmcHCmUF1EfzTMuhN7mX3
         felRZsoEzDq70yjqm7wUcCu+5NbFya2x/uzS0KSbbteo2S63QZp3vAdTn1Ta/p0I1t6E
         TdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763257647; x=1763862447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ydqY8kHaLqM8e+ckUd1GoyNEbjtXYhx/4GzlhdYJPLg=;
        b=VgFJ8CXvh84bZ74A4qK9lc6SJiew0eqd9vFcGxWX3ezNzZZCMd281wqP3OOTAxRAR4
         Ux5R2QgVjEGV7Q0vNHApINvidWy4Mx8h7ZVUXkvxReK8DBB5j9xDxalyUGgOSMU23b31
         UERXJdFIHXlD7irJ6SsTgjKj+oWxw49Cq+WSp8s7y3DjI33dGYn80TLJRVdzq20l4uVV
         HZ+1FjkfKGb/Gq/EgsNu5M0EHFZ0TOGeNtFio/9rz5sEfbNQLnJREUMffPaA4BOBKPOI
         g1AV0rqLdA9Lvd/R5Yqx+4qHqbSLLRpPRKa/iVB8ulnz4DG11sCaOtGa0WfEiloEfFgT
         kFag==
X-Forwarded-Encrypted: i=1; AJvYcCWRa83IdVhcsAViVTxd2a7uUe3HXVBB0OZStExEdjsi3KVBqPNFA/MbBHMnFMqglWX42mWzkO/B/g==@kvack.org
X-Gm-Message-State: AOJu0YwHI1rCkLKYVhrismkd/bOmvDMT9Du7P8sBiB4ouEDjR1TtLw6D
	htjK6fkiwplD1mG4n3owYobz18KuSiTRqYIBK2JOAe28ytQEzwmO4CLvVvVo3IPyupYfMgQeehr
	GryRdVPRmduG5PQ==
X-Google-Smtp-Source: AGHT+IG+V3JoR1zxw8jLEaEAc7T7dwC4LvlgdWGc3WKTGU3XOduJztVqaChJIeTyJ4+Ey/Vrzth5e+wjM1k7sA==
X-Received: from pjbnk23.prod.google.com ([2002:a17:90b:1957:b0:343:c010:4493])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3fd0:b0:330:bca5:13d9 with SMTP id 98e67ed59e1d1-343fa732781mr7620970a91.32.1763257647429;
 Sat, 15 Nov 2025 17:47:27 -0800 (PST)
Date: Sun, 16 Nov 2025 01:47:21 +0000
In-Reply-To: <20251116014721.1561456-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20251116014721.1561456-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251116014721.1561456-3-jiaqiyan@google.com>
Subject: [PATCH v1 2/2] mm/memory-failure: avoid free HWPoison high-order folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: nao.horiguchi@gmail.com, linmiaohe@huawei.com, ziy@nvidia.com
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	harry.yoo@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, jane.chu@oracle.com, akpm@linux-foundation.org, 
	osalvador@suse.de, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: aun6jnnhfbdnoax6nzhe8kde6p5qm4xd
X-Rspam-User: 
X-Rspamd-Queue-Id: 89FAEC000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1763257648-445299
X-HE-Meta: U2FsdGVkX18ng/ik5Zq1xuCfHviBtox3aCelSC1t9rkXmZ/NUFIabFaRDrcYGOhDuhmCKAA1XXu9yn0l4/QhLfTg2bQeDUvFIHa8jGj4JSufJXkOCH8fssLD9c21gdsESCru1AFcd6YpA3OgZkavTyobTl9DKGkh7GX6s76dVemTIKQJoNWsKtQ4cSmfagFqH2XtPuyMo7NwJHwFKCUkh6sFWrvblqvG/aRuS2qdGRVjHF0eYD59jgIHuCtkhvybGVfamSOBPS+67bwAuURVp3C9LzKZt77XvE9/Calp59eRZYH8dmg2A4hgKNK8UT1jBSzFiJvSjCGqe3XnOMI+S6z2tYTORbb6Rq6TMuiBWmKRrQuyXg+W8EvLDtSSh7mfdrV1D3hIKQowy0En49IfL+GATNiKBEzaleyU6ZAWyn0ASujiWIG3W5SORe7JrCL2yPQ2CZr0D/KmEJcuOLv4eS4C19umcDHKvMFLDkfkFWfGItsEUClrr0Wda09pmX1sJYPrgGnGVahFNKJpQtQ/CezDtLj+9yXDbefH/1FT0KJav5glmDsh7OG7Csz6lSb0TLAGPU3etMgZ7fAHg3reFbUA0aa4Ho22tH3vCYYCWZqVLu97VWn013hAnXJhcypRCcyGZC29Ui6+JEfg7IJDkCuMpkLmkuTOmLlQkaDqP6WWdQ1Iv49oh/7/HI0dJo4aoOVCXpCvzYnvvUkJISX8+urjRFS7VM8vfvN4h2F/I4eVCZEu41TT97tAZG56jBOWIGVAVI75ZnOPFHCkdQ76SvMR0SKMNiNxvPitzipsGWgkzaBrvAOLVWDxjLPybt8LZrLfxYJqxxKUgsH2sDjpZIqYCJ4HuXj4aOZqBXBXW9o0hUfaRZ24W6wSlJ7RERfmEeZvw1EUB8aTovU+B+gR+HGnp2yWeh5Wr81JpDyDMVoftQcGVpVDgn6u8oGgPAwEQ9Kl92tZUwXwEk2hbrE
 Iuvld4NQ
 8UXbK5G53s6vd9pzLdaoeyRQcS8DCTZLVKo3yMEM1GfnCke1eAx6SSF9pYipl2e6yMZYtjxmEsaqtfz70RDVryyLQ7/r9zcPq+ebdP6m5DDvjvVNegKt0mZo55cavxfWWzUA/DdETngeuEEV9/nFbFjJnoXSCI5c86V4PWIppUjh07bzPEKsn4QpNjg8cY582JH9suEsqxbn9xWIktWuRMY6rZ0WQBcoWSBw5d2xqxSeJ+yMLcTDc+DwwdV/isqaXrX9vhwnNEVgMXr6ovMnUP7/qvMSxyrHCkrUAEVtSWsJGDuHeXGY9qBSTq9CPMVMPnVIpiIuv14g8ffhXm574YgyltapqOHdg2tjNq4Zqk0O5O1teuMVySYWXmL8oTCXwGGjkZMAnxxpIc/qcShUk2gQAjtr+44W61eZVO0+pUwnTzHWQxV+XrHscsuUWYfrh6VPAk3bdRkVV42jTmJQt916Xxpx/GOvS4y4BtvXPq7nyY9s4vhrVNWOfb/+19Q08YtRWAXeIYrw/nxwE9eZhBw2eeQ6Dup7vhi/hEzINkXySUbq/rIYOyKhAOoKtYS9lWWh9JDwlzqIApaF/qHiYzVQVpvp5yf/GXtk/Hfx7RZ0QX3FcuUKmt1kyCUHFExIam9WJhmdcMLw2REvb0TFIYjRa05/hjW/EHFHB+0E4fShxAxnvyNNl5PWnp6xG7tJwKx0s61ycjX2Fo1A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the end of dissolve_free_hugetlb_folio, when a free HugeTLB
folio becomes non-HugeTLB, it is released to buddy allocator
as a high-order folio, e.g. a folio that contains 262144 pages
if the folio was a 1G HugeTLB hugepage.

This is problematic if the HugeTLB hugepage contained HWPoison
subpages. In that case, since buddy allocator does not check
HWPoison for non-zero-order folio, the raw HWPoison page can
be given out with its buddy page and be re-used by either
kernel or userspace.

Memory failure recovery (MFR) in kernel does attempt to take
raw HWPoison page off buddy allocator after
dissolve_free_hugetlb_folio. However, there is always a time
window between freed to buddy allocator and taken off from
buddy allocator.

One obvious way to avoid this problem is to add page sanity
checks in page allocate or free path. However, it is against
the past efforts to reduce sanity check overhead [1,2,3].

Introduce hugetlb_free_hwpoison_folio to solve this problem.
The idea is, in case a HugeTLB folio for sure contains HWPoison
page(s), first split the non-HugeTLB high-order folio uniformly
into 0-order folios, then let healthy pages join the buddy
allocator while reject the HWPoison ones.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net/
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net/
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 include/linux/hugetlb.h |  4 ++++
 mm/hugetlb.c            |  8 ++++++--
 mm/memory-failure.c     | 43 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 8e63e46b8e1f0..e1c334a7db2fe 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -870,8 +870,12 @@ int dissolve_free_hugetlb_folios(unsigned long start_pfn,
 				    unsigned long end_pfn);
 
 #ifdef CONFIG_MEMORY_FAILURE
+extern void hugetlb_free_hwpoison_folio(struct folio *folio);
 extern void folio_clear_hugetlb_hwpoison(struct folio *folio);
 #else
+static inline void hugetlb_free_hwpoison_folio(struct folio *folio)
+{
+}
 static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
 {
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0455119716ec0..801ca1a14c0f0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1596,6 +1596,7 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 						struct folio *folio)
 {
 	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
+	bool has_hwpoison = folio_test_hwpoison(folio);
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
@@ -1638,12 +1639,15 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	 * Move PageHWPoison flag from head page to the raw error pages,
 	 * which makes any healthy subpages reusable.
 	 */
-	if (unlikely(folio_test_hwpoison(folio)))
+	if (unlikely(has_hwpoison))
 		folio_clear_hugetlb_hwpoison(folio);
 
 	folio_ref_unfreeze(folio, 1);
 
-	hugetlb_free_folio(folio);
+	if (unlikely(has_hwpoison))
+		hugetlb_free_hwpoison_folio(folio);
+	else
+		hugetlb_free_folio(folio);
 }
 
 /*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3edebb0cda30b..e6a9deba6292a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2002,6 +2002,49 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	return ret;
 }
 
+void hugetlb_free_hwpoison_folio(struct folio *folio)
+{
+	struct folio *curr, *next;
+	struct folio *end_folio = folio_next(folio);
+	int ret;
+
+	VM_WARN_ON_FOLIO(folio_ref_count(folio) != 1, folio);
+
+	ret = uniform_split_unmapped_folio_to_zero_order(folio);
+	if (ret) {
+		/*
+		 * In case of split failure, none of the pages in folio
+		 * will be freed to buddy allocator.
+		 */
+		pr_err("%#lx: failed to split free %d-order folio with HWPoison page(s): %d\n",
+		       folio_pfn(folio), folio_order(folio), ret);
+		return;
+	}
+
+	/* Expect 1st folio's refcount==1, and other's refcount==0. */
+	for (curr = folio; curr != end_folio; curr = next) {
+		next = folio_next(curr);
+
+		VM_WARN_ON_FOLIO(folio_order(curr), curr);
+
+		if (PageHWPoison(&curr->page)) {
+			if (curr != folio)
+				folio_ref_inc(curr);
+
+			VM_WARN_ON_FOLIO(folio_ref_count(curr) != 1, curr);
+			pr_warn("%#lx: prevented freeing HWPoison page\n",
+				folio_pfn(curr));
+			continue;
+		}
+
+		if (curr == folio)
+			folio_ref_dec(curr);
+
+		VM_WARN_ON_FOLIO(folio_ref_count(curr), curr);
+		free_frozen_pages(&curr->page, folio_order(curr));
+	}
+}
+
 /*
  * Taking refcount of hugetlb pages needs extra care about race conditions
  * with basic operations like hugepage allocation/free/demotion.
-- 
2.52.0.rc1.455.g30608eb744-goog


