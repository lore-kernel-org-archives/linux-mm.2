Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C96BDC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 18:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FEDC6B00A5; Sun,  5 Jul 2026 14:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389486B00A6; Sun,  5 Jul 2026 14:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277A16B00A7; Sun,  5 Jul 2026 14:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDCF96B00A5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:07:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75D5E40175
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:23 +0000 (UTC)
X-FDA: 84955505166.16.F7479C6
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id B18E8180006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:07:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hOuq4mFp;
	spf=pass (imf06.hostedemail.com: domain of 3WJ1KaggKCBc65xD5LxA3BB381.zB985AHK-997Ixz7.BE3@flex--jiaqiyan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3WJ1KaggKCBc65xD5LxA3BB381.zB985AHK-997Ixz7.BE3@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocGv2/ydC5mD1rUx0KODf5OBUXgAG7lxLgoXanxhcGo=;
	b=UsYlyhrZ0+k+FwvwBsTJuUp5ErAWphTNKz+4bpJea4ECo2h5cVKDY/N8p6MNvsmBbasr6t
	bXgLc0tyO8XA6M7ELcyjatB5WvrhhqUDXE4SfDEKMDPMte788leVmqxfT0wXAHYeRQfbW+
	ndI29KmnXonLV4qXTm10/dW9luAM+YM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hOuq4mFp;
	spf=pass (imf06.hostedemail.com: domain of 3WJ1KaggKCBc65xD5LxA3BB381.zB985AHK-997Ixz7.BE3@flex--jiaqiyan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3WJ1KaggKCBc65xD5LxA3BB381.zB985AHK-997Ixz7.BE3@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783274841;
	b=6+bQQ9hfd2Z6xu4ryAPk4rNIRWKEE0mlStRK6IvdVYM2mQLCNsu5DhzBOF9D8fGY5l/cRf
	tj54Xyxh9ynQ/0KFlctfE3KDvydyvty4rUJzVKDhuhUUSJ1cDGVcPMNEges083Ks69IJqf
	RB4AZ0q5J85kpSHTR0rCO1dajP6aUJ4=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8479b45ad08so3782448b3a.3
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 11:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783274841; x=1783879641; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ocGv2/ydC5mD1rUx0KODf5OBUXgAG7lxLgoXanxhcGo=;
        b=hOuq4mFpw9BK9V7lgSANaUnmdGD7qAkafuVeyS86QsMHLkXqw5ZIOyy0uXUFXhLNuy
         z4sZyfHAnAG0OBiR99uPJgJPhtZggcnWA0VqfDD50k0CzH2+kfmaMIJ7b+p9lTgZbE8V
         CiJUsH3Vya4jtAQuBeTHCkCO1GJ3waUbOsCW8Tzzy3kCRMqKfTe56pX4hNxc8mOp5Ec8
         7QU8jq9HpB9nfED/uNGjLChVtzrZzBOvg1mx+NjzNHN16hYZkcd0/mfxDn3NktPBn/iD
         gW1UOCrPXUG2VLeUuebRt24dihAKwQpYd0uPRvBOqqwHzEorpbptiVHv84Ou9JK34akb
         m7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783274841; x=1783879641;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ocGv2/ydC5mD1rUx0KODf5OBUXgAG7lxLgoXanxhcGo=;
        b=Xv/H0PQteuB0jaXatmlitmdu4BeeAYpFmPVKJTDiXokRAxWfwtEOpHPqIGb2JC9OiD
         V1gcrdS1m6T29vzQzW7YpIJjGY5Ex9kiGG75cN95edLHMz/+APsSAUNm6f7W0ngjKe3y
         nHOuE29bQVzzsM+3JvxNqkd5pBilXXZMzgOIzb6RheW2EeSAYWgZff8Sh2arcyIZ+PXh
         3s4cAd3RzG1rdhKkmbQn3qPPdwGJXJ3+QF0vEIH+6W9JPOPYh4TB0r50jBkKO7FGIT40
         iZLeB+V0Hplmnim85c/+yCLVTnfXAr5y3o7nSUtCLnKIwMJrw2+QeScv+J3IO/czGl1S
         i+Uw==
X-Forwarded-Encrypted: i=1; AHgh+RqAqE09fk3AZihA+npsNL1N4jvGRR0JHrmsrvwswDK/WvDU7uXUzTlC2WpENd3Pngz5tyqZp+A8rw==@kvack.org
X-Gm-Message-State: AOJu0YyOrIwRJzOOCOOazLE1S8rMDDccW3InSeF/61OQEAlRMwV9EvM9
	q9Fkwf/SrlDN1tZZRfm9I4SFLtqk5rfg5z5j9POVUrO5/SubKkxgPTzpoAJAEf1XYNK8YH5Cn8n
	vrURLVoxjAcEZuA==
X-Received: from pfbei38.prod.google.com ([2002:a05:6a00:80e6:b0:847:7a66:88f3])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3395:b0:847:9226:e7be with SMTP id d2e1a72fcca58-847f6b5963dmr7532154b3a.0.1783274840178;
 Sun, 05 Jul 2026 11:07:20 -0700 (PDT)
Date: Sun,  5 Jul 2026 18:07:13 +0000
In-Reply-To: <20260705180714.3708947-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260705180714.3708947-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260705180714.3708947-5-jiaqiyan@google.com>
Subject: [PATCH v6 4/5] mm/memory-failure: skip take_page_off_buddy after
 dissolving HWPoison HugeTLB page
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, vbabka@kernel.org
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org, 
	osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	nao.horiguchi@gmail.com, david@kernel.org, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz, 
	rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B18E8180006
X-Stat-Signature: 4dxn3ogoayh38ck3jmuiq9stbqe3m39d
X-HE-Tag: 1783274841-310583
X-HE-Meta: U2FsdGVkX1+PBpNmFJ2EA6WgxWdKGGnUJX/2I7lyruH4H/DlGumVkWReGUvxletJLHApoWCv35BBEhdAmWsKHZzgpT1UEE2UlzX/KbihDccwcx1VItYEGb1Y+ZXQj3KnsSB9L6Vbmby0I1puBzEC+qLraCi+d4MmuFHBughlc6d/9NRbgLU/5t0P+okAN8zRGiwhLDZp1z0343stahnlV3/hGdw8bCXZkib22SwZPZZIZKD/0zT5j59OUCsWc4xtnmLFxIRJZxjrbt1TVBtTYNdtWKvNEy2qP6mQq86YjWLcyjobLNs9z3Fv/EDoGATPNwVhZZABO+uRycSZsePQ5z38RBA+UHzft0J0se0eqO5VeYfFKmYZr4xNmSHOT1q+S/B1nYCknE2dwYrFGBPNxbFURuifVT/FSlyxCRGNcJc7ZBqBQeUMi+KUlC2UbwyNX1BLAayr39NJZjpYcP8bViB6oRv7pDff+n5nzOm8VK97jRSjPKZOCCIrJwA6suf5PDyWQKkLgWCtT2LmMClXLBf3lmAILMM47dR35q/IioJAettefpXxk4bjaCNSMGNFkqVOfnbxq8BnUxfi0T30TQk/7qECXX/yCUeTrzWDIShpQBoSJQPlexLYacLRSYqlWDOR9q49jwp7vKKXU4DDXDqlZNY/AKuhyEy3523+0KPuV7lOEHHPhi5zCO8U00A9+yd/RhMWQMNzgzKVMsHnI0d2t64Yo5c9gsYJGVoUyNe/nzJZKDPhHDn3cMsBc38vIPcOfOv4p+ivHnkr6TiY2Ou/zZ83MDBd7T+PcnO38U6SyKu6ODYH7TnAGzlRecFbFbm2/NX0rz4zfwrvTSEamyxQpROc9P5MyuxAgebSodjcaS5mxPS9LLRD5Hgi/qlDJeLK2WO4/Pnnjhgc4bKnWxsos8aMJTMX+kTGuumGcHQoQSifAuXXpr2dqAaYWc5pa+9kpCrd+LtNVVaLFk/
 jjZGAxXy
 cCMbGqVCKoaJGWiE9Oq8ct233zWueCR6R1DWECPNqxrch4bbUxN0Gh7XJ523wBRNcabM3J9c+QWHjsyzy55pmsipyshGkP3KNkmSQ8oJo0GgS+5eDMaRPRJEoeEB1lNPpHdWr7UjagFc864D2usd3IphX8waiaG2D1XZQ7oCc/DkbfLAxuB4Qu7pqySNZ5/mqEhTSP7qelKWq+oegDZD8fMNZUgSUaTb2cQ/U/XEQVW9E0iM7IxPYI/8oTxNg1b6IgUBvjkMPebaxsDhtRXFaQMgklaCdr566gkV6PHCvF9Jz59RVTqIZxq8FmeOyR4Zky6e2meDJ2HhuNZw+hUA38fMkVJi2hAWAw5oMn9f/zSA0GJuVP4zH02uWpcJCmRegktcTslnfPfIeJ840ljgTLyNipC6WJ8P4bFGvCNpZIJHyilDER4dMFsaWhbsMqSKu07UsWRhxl/moOQlCWKuabJIe74o7VD2pPcnfkTJEqYuqKXUy7JL+Rp5jZHmloF58c0alMQgJp0LvpEHQV6mjiVsmbBw0nSlXPb5q2pc7psqHEQdQGO+IQDl9OnOzfI49kojtJtEYI+g4dYDhQiTHle6VshliwC/12lZIiB13BeTP5QVgaUA4sfbYGyk1NEHbg8JG/5EmuA9yNQPNQCo/dvpipDn0MUvq1DmW8n6nMgnwXzTsv6t8Qumylw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that HWPoison subpage(s) within HugeTLB page will be rejected by
buddy allocator during dissolve_free_hugetlb_folio(), there is no
need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
succeeded returns false, making caller think __page_handle_poison()
failed.

Add __hugepage_handle_poison() and replace __page_handle_poison() at
HugeTLB specific call sites. The being handled HugeTLB page either
is free at the moment of try_memory_failure_hugetlb(), or becomes
free at the moment of me_huge_page().

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3d15b4c1b694..a37b67550718 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -174,6 +174,30 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
 static DEFINE_MUTEX(pfn_space_lock);
 
 /*
+ * Only for a HugeTLB page being handled by memory_failure(). The key
+ * difference to soft_offline() is that, no HWPoison subpage will make
+ * into buddy allocator after a successful dissolve_free_hugetlb_folio(),
+ * so take_page_off_buddy() is unnecessary.
+ */
+static int __hugepage_handle_poison(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	/*
+	 * Can't use dissolve_free_hugetlb_folio() without a reliable
+	 * raw_hwp_list telling which subpage is HWPoison. So do not free
+	 * them to the buddy allocator. dequeue_hugetlb_folio_node_exact()
+	 * will ensure to never re-allocate this hugepage.
+	 */
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+		/* raw_hwp_list becomes unreliable when kmalloc() fails. */
+		return -ENOMEM;
+
+	return dissolve_free_hugetlb_folio(folio);
+}
+
+/*
+ * Only for a free or HugeTLB page being handled by soft_offline().
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
  *   0:   the page is dissolved (if needed) and not taken off from buddy,
@@ -1166,11 +1190,11 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		 * subpages.
 		 */
 		folio_put(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (__hugepage_handle_poison(p)) {
+			res = MF_FAILED;
+		} else {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
-		} else {
-			res = MF_FAILED;
 		}
 	}
 
@@ -2133,11 +2157,11 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 	 */
 	if (res == MF_HUGETLB_FREED) {
 		folio_unlock(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (__hugepage_handle_poison(p)) {
+			res = MF_FAILED;
+		} else {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
-		} else {
-			res = MF_FAILED;
 		}
 		return action_result(pfn, MF_MSG_FREE_HUGE, res);
 	}
-- 
2.55.0.rc0.799.gd6f94ed593-goog


