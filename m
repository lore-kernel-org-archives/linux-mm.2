Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DBDCCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D288E003C; Wed, 15 Oct 2025 10:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D4E8E000A; Wed, 15 Oct 2025 10:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FCDD8E003C; Wed, 15 Oct 2025 10:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F408F8E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:18:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92C6B1601B5
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:17 +0000 (UTC)
X-FDA: 84000553434.08.4189DF1
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9FCFB40017
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iZqrbFPj;
	spf=pass (imf01.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537895; a=rsa-sha256;
	cv=none;
	b=7ysxdv/N2A96e8szdvfGKlZgLadjEH/va7GV0zZOr8drp1fpCttd0vXqi6jPVYopth54+C
	VFCX6/7tEt1tHspjDywGH/G0lyZUysvtvI5+ubFoTc2pNozH4LS48eh0VActc6Lx9Ot0nL
	vkJKcKaT6dp4DvKj3QLN4VQdoYKYxfs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iZqrbFPj;
	spf=pass (imf01.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tfnp2VgNI7X5NDB06OaZAZrurrAWQnxjDDxodnKF9g=;
	b=QXQL90GJ7ghdfKAG9E9dasq0fnL2XIFOrHsgVlbIuauQ8sLA+dDrGMX6m5eQ5hBoAXxV5l
	bLDZWA2yyqkksYc3+Dciy69lJy2Xjlgd/6xZeTOQcIWVB+8vBhL1feZZ0YEU33IfccHWlA
	QRhAFDDLvpK1dCZK4J+Q0W6tk9YWY9Y=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b58445361e8so876424a12.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537894; x=1761142694; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tfnp2VgNI7X5NDB06OaZAZrurrAWQnxjDDxodnKF9g=;
        b=iZqrbFPjvudI4lp7h8GEpeDoW1vhU27MUzrPs2fI/Y7YfjMS/bni+V4zzdMK92bG3U
         W1MRalWqrX5Kwy6bA4viuTK9CUNGu183KDUWPgF9D1kp4wz5mZc9rFF4ILkfZaRfauCq
         Fzl8yNX/w5riNsKWLxsml01ZPPfyw+L6zNiqshD0vtybjta9QseskFmYCh631QTERncp
         tApMdz8fCE/VepfBKRa35wG2cZrnuMw+DtpZ3EHsxsB+FfoYHSP2hkJW3RG9Eq0KFtU/
         1rNG8/zKqsAhMnsuX5O+43dhWU7zYxEnDU9ZaE91PM9BiHTqMIhkiW/bglURdre+US8j
         uUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537894; x=1761142694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1tfnp2VgNI7X5NDB06OaZAZrurrAWQnxjDDxodnKF9g=;
        b=CO+uH8nEMhIsixJm9IUIazs0ndRhHR8SwTHOgVrko5FGrA5YxM62eH8+RIcYSw0Lph
         GV21FiNoKdc3Lpmey2viH4wT5+dUIMGaGjMiriFZt5pvUFR1dunB3eQk7kvJetOroSmW
         QUZcmabf1XP/n9cBA9ICGVzfhsrJcsHwoTHpq15TIJByxLL3V/DGd7qDE0SzdZbArZOm
         g/xSiWBNDA0IarkxpOdbGc4Z5s3CdhQY7eLZPnQ0O1ogKDi6p5nzrkU6VCX5QomfyQBd
         ZlDgT7U99TMwY8m+MIsk+qt6foPIh62phaMm7T/IcYOMN1HE363655Qs8KtnYqcXPDYt
         1jEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqGWOIVhT7xJWRvEUvYdBlAgRC1eECwkn1OqRtdr30eHq8xjyNN04oXeIlVLjnGoJpdHORX7svNw==@kvack.org
X-Gm-Message-State: AOJu0Yy5yp1qnHq1YmicJB3F8W5Jrp3WqulIlpWtb8DhFJWS8ip+mDai
	JsP5kG0X/beO1npIjmya855P3hY+PuaYun4jdrKYATcFm/ov5F2AfFnv
X-Gm-Gg: ASbGncvVREyiFOJEtfLREbP+3PrwHxo+B7nXZXQg6DIMtHQx8VvHc7I1tTG5umhulO6
	PueXDB4NAQwrT7RSgurZFD2A9iITpEFCKxFK/3kYZXuVZIe+f9HGY6hPLTDH3fJoELTX3UOWrbN
	027MOWzsqk06EFW3Vb1F3R9eq4aMLaFP3kr6Smw4r9GFEwhaLPMQWkO85zBDReqDLVTeFRBvJIx
	egziOQ19wCUc6n8EbX/MNcD1Dt0A9i/Aa/jhF8E7JIhEuOlOyJRPaU6EwLE77QPs6O54IHus0Z8
	Q6VpKCQADlHbOn/owx2r7cEQMD+iIz9X66efs9bwQuPTsUi+OC87tGgbnvntrw1K034leccJInb
	Ta2uRg2eUoEdQp/dEQlOjFz9fCT4NKzwRpd4EHC+a32AN4rXbvePDi+Ljjsa/ge0uXZjq2eSAeQ
	lEAV+WAkA6xo03CZ+H
X-Google-Smtp-Source: AGHT+IGaH4Q7yuB3UefbX6fUnOF0Cq4qxYjfR/YqrSeLwExSFoNCC9hfKuz5SVL5H702WlYSyJC/fw==
X-Received: by 2002:a17:902:ecc2:b0:281:fd60:807d with SMTP id d9443c01a7336-290919d5389mr3536805ad.2.1760537894159;
        Wed, 15 Oct 2025 07:18:14 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.18.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:18:12 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v10 mm-new 5/9] mm: thp: enable THP allocation exclusively through khugepaged
Date: Wed, 15 Oct 2025 22:17:12 +0800
Message-Id: <20251015141716.887-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251015141716.887-1-laoar.shao@gmail.com>
References: <20251015141716.887-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jhb7cx1s57detzgh1rcag9qgpnm6w8oz
X-Rspamd-Queue-Id: 9FCFB40017
X-Rspamd-Server: rspam09
X-HE-Tag: 1760537895-751913
X-HE-Meta: U2FsdGVkX1+j1wRRchKe1c7njqOwbWu3t262fAFYA/CbHMIuq53WhJ1B++zy/lpKKE23fi+DK5HTygSOCWHW6MWQUeSCFH9D7zsO8HelQNXUrGkVy5MMu+TOapi2zkI8WYbnYR5/l1v4ZxqhFuOLEZOvvyBwIOiQ028pjHK+kApMt1X80eYMn35gn/N6sXpYknYZBw4XkGfnDLInRI9C0Qdzbu8ufCHF1veAHlILsf40I3PQ0bAWQJWj87IO9FPSd5XgTM6Vc67BFUUcSf6xsRpa3IScr+Kp08Is3YcmVBLhohMk5Iv2iyIg67o+OG27/DjpK2T1/KXoiShQ195sVIYpkpqDcpl2xvso53BYqJ0rg1IoL7odMxyoExiOF33uwbIFBAAsY9lJzNom4/CSGmJ/l3Bbb3oxYxrlsRq3WjlQd+LroSTM0sGll9Bi/CnvAy18zHcJ6htCJyXXSdR7JlIHw/ZSe9SpiOvthF8lapmjf6G3xNh5Nsy9kV9Nwysn93O4/23eIFrIZKJAfFPFgYmUvQYzm0Ya3374qwqA/el8rfWqFYgsunAeZo06RIGKAoOSQf1BRblF8F1hdQG68WbpePruq5LR+z1jvfrp3mz9c6pQGRNgMX3h+OK6B72a6S1FjI1FmCfr7/O9LDBeRuE3tU2DMaDcg/GLQvMEMAJlTA0GSkpdvwwzzXKM9otbClQaI9b1FzN3relU6Q1eNHUXhqoE8fMDfiZRGb31z3XoxD4X0NRPUGssFMpbDjc0juIPxlsp/h4B7qZBKuXy5hpHEtt6CiZocIARzvg3iNmASJX5iHqi4Ct7Vu3NRRsF6Lh1AEkBRtE+5MCx+xXtAQIx6VqFs2HISb6DD8ZIKM3/n2iRd7JIjSsGrsS2qHN6yIGRy1YcTD7Pp6BAyYLCVFzLtGxrWaLXvcDrKcpPlCdNWBlanQMAnRg0twYI7LTQoQmXwcElp2YKvDqf/FM
 vMw0qTU2
 DOlPGs/bH18wO3sKnKep79nEhwxusnLmpYkbOMa4w173zKmfHyAofT8UMGV8TpxyyNKjGoSjkMBf/jBmuHWgiWu4Z3M6s6xByoQCAUBwt1n2S6GV/A1hlTCgX7x0Q5sKS2GucpBpINkY1+5/a6Mae8ZTDNDhHumlbS2GnDGsbQy1LNQKZJQyq8tCf5It2iivmFM4YU2AlapmGrtTekGdTwDdsei1fa9LxH+/ZhsxAaDc6NxAeNZWhJEqEwtjvJJ6CeDeHeexQVv38Q84O1MSDMmW0NhfcwtIePcvDoqJGpHSE3Qno9VtbNH6jTxu6JXMj/ktSYH3AL9tNDYWCUkcxNHC/LwUTRQ72Bf1+YfkqmFZQyKjriPgIqqNqq1KFNayTiC441O2MtWAXNJ781gxCo8gmG3IBRBRcaMs9qPlsGwZcB52276v05fL8kDByuKPEM8lpRCjpsXFP7OVR4NHOzWUI0HM/P0Psf9lGVs59VLiZgK8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged_enter_vma() ultimately invokes any attached BPF function with
the TVA_KHUGEPAGED flag set when determining whether or not to enable
khugepaged THP for a freshly faulted in VMA.

Currently, on fault, we invoke this in do_huge_pmd_anonymous_page(), as
invoked by create_huge_pmd() and only when we have already checked to
see if an allowable TVA_PAGEFAULT order is specified.

Since we might want to disallow THP on fault-in but allow it via
khugepaged, we move things around so we always attempt to enter
khugepaged upon fault.

This change is safe because:
- khugepaged operates at the MM level rather than per-VMA. The THP
  allocation might fail during page faults due to transient conditions
  (e.g., memory pressure), it is safe to add this MM to khugepaged for
  subsequent defragmentation.
- If __thp_vma_allowable_orders(TVA_PAGEFAULT) returns 0, then
  __thp_vma_allowable_orders(TVA_KHUGEPAGED) will also return 0.

While we could also extend prctl() to utilize this new policy, such a
change would require a uAPI modification to PR_SET_THP_DISABLE.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
---
 mm/huge_memory.c |  1 -
 mm/memory.c      | 13 ++++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 08372dfcb41a..2b155a734c78 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1346,7 +1346,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/memory.c b/mm/memory.c
index 58ea0f93f79e..64f91191ffff 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6327,11 +6327,14 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
-		ret = create_huge_pmd(&vmf);
-		if (!(ret & VM_FAULT_FALLBACK))
-			return ret;
+	if (pmd_none(*vmf.pmd)) {
+		if (vma_is_anonymous(vma))
+			khugepaged_enter_vma(vma);
+		if (thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
+			ret = create_huge_pmd(&vmf);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		}
 	} else {
 		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
-- 
2.47.3


