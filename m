Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA7DC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B676B0093; Thu, 17 Sep 2026 16:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39AA96B0095; Thu, 17 Sep 2026 16:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A996B0096; Thu, 17 Sep 2026 16:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9FAC6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:45:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4B2D1404AD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:11 +0000 (UTC)
X-FDA: 85224434022.01.2657263
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0E8FAA000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eRplxUOn;
	spf=pass (imf15.hostedemail.com: domain of 3VFGsagYKCAU13nmfslttlqj.htrqnsz2-rrp0fhp.twl@flex--wyihan.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3VFGsagYKCAU13nmfslttlqj.htrqnsz2-rrp0fhp.twl@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789677910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxlCNYOwsW45BnQIn3JTG+O/SEl/6G4eXS+I5oaCDnU=;
	b=qb84i9onI+Hso/mC2QXf9DEK3vxf11x9E5FdeJnMc0Ru0eSIwR2u+VqRtRrVUDGJNllT3u
	2mG1rzZCiIgwzqQ8jMRaG3e/N33CO95mbAurOz0gOnMs8xHCghKVVRLAKofzjBlb9yDsx0
	AxN8hGEqBy/5kqg+FROqO4MGOWeLXJI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eRplxUOn;
	spf=pass (imf15.hostedemail.com: domain of 3VFGsagYKCAU13nmfslttlqj.htrqnsz2-rrp0fhp.twl@flex--wyihan.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3VFGsagYKCAU13nmfslttlqj.htrqnsz2-rrp0fhp.twl@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789677910;
	b=IXLLjr3yFULqlFpqQNwSFM2XbPpSIdLYcyuKUnNV/66WU+v6WebTydcKlvgV+NPlMwEGWN
	17LNTLLl7MwdRiN66NpkEvomfKfJTWlPzct/8G4cBap/fcfuLUqcnBd3Rnm9tllWCoFs6m
	Ee2wQtMhICXZcUuoRcpNrOZ55T4mqAU=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39de1f85cb2so110300a91.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789677909; x=1790282709; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JxlCNYOwsW45BnQIn3JTG+O/SEl/6G4eXS+I5oaCDnU=;
        b=eRplxUOn1rnewp/nPSK1D9XoRlspLZ+YbHioxXSodf9UZravaMsDCsXDghF4L8XA3E
         PaEmQ3b5Ulb7nlGU20hAc577A5uqvixRiU2z4XCzEF2Wm7ym0RyTaZe9ENtxTdlB/azh
         sTdU4DdbvmmA50BePIJlhCS6BDanlOEXRE7SxXBcq4eiaZK2P7DvUneqP+xE1Efuzf8Z
         xlqbG8ZN2l5FwRboiiP28ghhN49NBeqEOtaK1/oXhQpZ/uD2vgO3TWX7FbB5u+sS2Kuo
         7wMhGw34JdhvO6+dZEGatjNXDzfkSGjoH7mz7v0sddMaqXWZsPsPE/33qFfKnIc4dE6/
         +uBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789677909; x=1790282709;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JxlCNYOwsW45BnQIn3JTG+O/SEl/6G4eXS+I5oaCDnU=;
        b=FNjePksHrspLK4dQ1Lk8RGXUSZgfIcsa4cdVYUctc4pxUiZU611DLewIrhF90kmlO9
         /QGe/o1OwxHJG3WALyZTzysbfgHbnXAlciKizHx4A/NLpUGx62FMTqC75vNdlm8fZGyF
         xxMf7RfkOnpqX8+5hkDY29x4b2TM6fBew+O9O1BGOVyqE10abD1IHr4oaHK7I9tsLrOs
         UDw93do+BBYPM7bo5qt46zTUx0+NpTgd/iHMZ1QDL3wbo2Y9hh11bE88S3L6RUkBS/5E
         +n96zsytjfoYc5w+vx/jD5bro1plLPE95xz+gR1bINMMciS/oITTQepzEe7nq31pj+ne
         JtZg==
X-Forwarded-Encrypted: i=1; AKwUvBwcJ2kO9RtKMJ+sRRBhIZVVKoOzIT4YDE+VVShPohwnjE4TGtSdzZtBr1jymDc7Z9UJqVHNHlbFnA==@kvack.org
X-Gm-Message-State: AFuF++m+KxxHpwAx+oKuMzB1aQEhUjddpyeaULH0Cvm61Yq/WhePX39S
	33sGRlb00wWxlbfB5XkrS5OTxjMjLoP+1Hf2hC3uTuPZwR+3sHD0+FBsryO4wiUpQBUXT7v5bko
	viOhqpw==
X-Received: from pjyd8.prod.google.com ([2002:a17:90a:dfc8:b0:39e:4bdd:a2c8])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d8b:b0:39e:410b:bec4
 with SMTP id 98e67ed59e1d1-39e54dca306mr707986a91.11.1789677908717; Thu, 17
 Sep 2026 13:45:08 -0700 (PDT)
Date: Thu, 17 Sep 2026 20:43:47 +0000
In-Reply-To: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
Mime-Version: 1.0
References: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789677906; l=2541;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=VByVeEjI4LUQrNUSvfcdQ/qkaw2W/Fj0TZtQKNhauZ4=; b=26Q9nOB/cKS3IbZahb3B67Qv7bStXKlTukEhrVZ3ZTwAxnSeS1vUPLqyUMVeJYRB0EYtlJR7z
 gJoC/MAIdDNALDdHkcigEox0KlId9ndvnjep7WAdkFOdJ368ZU4Ehy+
X-Mailer: b4 0.14.3
Message-ID: <20260917-memory-failure-mf-delayed-fix-v6-1-4b00856b5364@google.com>
Subject: [PATCH v6 1/5] mm: memory_failure: Clarify the MF_DELAYED definition
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: 9kns4jjds5ingnnj111oea3rfmp1iwhm
X-Rspamd-Queue-Id: 0E8FAA000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789677909-143776
X-HE-Meta: U2FsdGVkX19RfFv5b1abM5JJiYy/vz6trSsUnbO/U/2Y/imEqN1plW/tWYLPmMZuBku/UQ9ZAZvcxvf6MBwa9ez8qoyJtdDHGiEzJ9JD6pfivjycfW/cEMcewiRFddemkICIS1/OmYR7/xakeKTkfwvexqBbIFgq0EGYujxQV1fpDK/d1mpQfG+1XwqoS5leFQcTq/VDXn8aJOJsmYUmOSY4zoTrpUt++QDQUIlpAVId3wlCcifNHyZSKPcbxc3qp7+dLZezWo0OAAa0F601y6baeSvQMDYaGJjhAXoTy8AiaYC0MOf/9PmRDc4mkQjmB64K5dVYLFwrfcQf6+fhTthaThX8U37u2TGrDC4hUd4G5ph6VSl9kjU8DVl+J14NyPzu4ap+J3tQaBkquCGFKAWSH7FOfjekQU87TkqEJsPxXWxLLRMLnpXPx7mGQRJ6OqtvsGnKRCRILkz4RN5m9pSe7Oq/EliCHy2ngGV2pCdAmRqzdxKEtPRe0NbItUFM3XzlUVPzRO62n1UYCCsJmRV9IuJ2ippgzUcVCVJ16Pzcnx4hXDpaWUO2iRtPw2XjAG0TfjxCE3Nkqy85NhznSuzW0cSup1LYfomz1AhFfUa6frIyNaa0uFjmk23mlGlUkeJTIAYCpTcsM/qrfH4BRe2fKUHfMkLPJcgJ4A/edyQqs1O6dnnk9OC4QsbWu7OeQziEUrjELw8rrRxm0FCfbUqWt8+01mRE5lAjjgVyTiHxPU6W5Ct07M/E1DCmFEn5TfIjQeyqQvOXBrWJuBF/IrIxG/BKwsvLibk1yKVEI9NthJf5d/lJY9T1O9vegnZCbsBmFnVYCYXedQsJgXsQwcDWPzBtVXh4rSVMhmcVKBdNsFdcI7+lrwH7sUgfb14azfBHyiy4DzkMjLfJwlaXzjoK8hmMrb7KOSs8PB9AqaYJcc/irXDn8RA8OWR69y35Rambt9oPQynbHEVBTJP
 /TuSg+QT
 njyaf/wk7XgcQGlkNaSMMF7l0JRw1u8M/Pja9wOiunJa293/+5uNHiH7eg6RMoOb5OlIPOUUwXrAdPnU69+EQZJd8+lYvw18SRugBuxK8/ulG7my4qgZdT30Ek5z4dckhWuOm9HHXTF7nzVNzZom/hcibryIuUeZOcf7bSm/kjCCRG/5qnLfcOQeV10BITutfNaKTNJLa+pIX8jLA9Uf105zVP/UoWL4ayGoENYRsny5x0vQ+uQ2ggxdyJxahq7U1VZMG9jACZLkh2cf3hSokz6ork3519087Hm1Wxf00X+l/ln4yTTe4XvmODkRjphReRcGJRvHOhUChhItSQN3pGFkwpj93dNMA9ULyU12h+O+zngPyGoYvNKFBPrHxhjC1oN6F8S/YGqAGxoK/de3vbVXmGJUPM25HO3h1dtvJW+dbLty2j4a9VNm0oAYx2kv/+YO/9x3ZLSL7uMN738HGe72054BTWnCYNcSGJz7B0Vp34KjtQE30N5V9rtc2M1B/tqfSxFF21AqId7W5xVDrwSgHlALK6QDQ958c1edn50NeaF9jvp6KKMnVSCbhUQUhCEsenQBUJofGqdL0Ni/yy5fJ2OT/Nkq5aI/SAFs3saFiX26ozFmNLGf9ZJmPuPzPeIXU2SeksZxe4I8wDosGQ5WYKcpU4cuOY0CKFn+tnLQLQ3n8+VMgKt6UyPfYjQhmFGiwQIvWGx2tZTaw13/oOhAT2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch clarifies the definition of MF_DELAYED to represent cases
where a folio's removal is initiated but not immediately completed
(e.g., due to remaining metadata references).

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aaf14608b30e..e698d0e9711d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -847,24 +847,25 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 }
 
 /*
- * MF_IGNORED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_IGNORED - The m-f() handler marks the page as PG_hwpoison'ed.
  * But it could not do more to isolate the page from being accessed again,
  * nor does it kill the process. This is extremely rare and one of the
  * potential causes is that the page state has been changed due to
  * underlying race condition. This is the most severe outcomes.
  *
- * MF_FAILED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_FAILED - The m-f() handler marks the page as PG_hwpoison'ed.
  * It should have killed the process, but it can't isolate the page,
  * due to conditions such as extra pin, unmap failure, etc. Accessing
  * the page again may trigger another MCE and the process will be killed
  * by the m-f() handler immediately.
  *
- * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
- * The page is unmapped, and is removed from the LRU or file mapping.
- * An attempt to access the page again will trigger page fault and the
- * PF handler will kill the process.
+ * MF_DELAYED - The m-f() handler marks the page as PG_hwpoison'ed.
+ * It means the page was unmapped and partially isolated (e.g. removed from
+ * file mapping or the LRU) but full cleanup is deferred (e.g. the metadata
+ * for the memory, as in struct page/folio, is still referenced). Any
+ * further access to the page will result in the process being killed.
  *
- * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoison'ed.
  * The page has been completely isolated, that is, unmapped, taken out of
  * the buddy system, or hole-punched out of the file mapping.
  */

-- 
2.55.0.1082.g2b9226bbc0-goog


