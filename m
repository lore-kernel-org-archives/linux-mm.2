Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C182CC5CFEB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E413A6B0167; Wed, 12 Aug 2026 07:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2516B0169; Wed, 12 Aug 2026 07:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE18D6B016A; Wed, 12 Aug 2026 07:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9486B0167
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:32:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECC1B1A0355
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:32:17 +0000 (UTC)
X-FDA: 85092403914.18.AA9A8FE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 21E2F4000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:32:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=lMBLiFDX;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786534336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEO9P1mvess5y0n0KUnCYAeP/+IifPhRXEhfxRdjhi4=;
	b=H2EG0TS/daTZXEi60Mg7fWQ+YByEy5cmMDegHmi9xLz7waWGfFJJHF1Z3/tHZH36PnEeYC
	l0MRHF4Se0V4Mhy1gHEorFcYpndil7xScWyJs6CSUI54VDopThqJ9Awv2h6E4h3TQOYTWV
	ldPSJKn2WhwMoPkJ5Jpfu+SjF0bttog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786534336;
	b=GW2uand62kh86H5FGwIaiesDOhbn0dJ2m+WQN5VULZuYLywdjT46bQDFot2xALZerH1aQr
	qYODUifjSZ4/BqQgXApLQDtWf0WqT4XHUxPpckKs8xg239QSZBrybzVaTgxlNZj55MhwwD
	EngO3GsoKsZ4g6BD8xCMyL3QfziL3BA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=lMBLiFDX;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=eEO9P1mvess5y0n0KUnCYAeP/+IifPhRXEhfxRdjhi4=; b=lMBLiFDXe7xrvPugP2EHgSR/nH
	L6WHW8wD4ND+1rUNkQxYbTMBSHt1nDX8MJINlBdl1vpnF4+Trm6iXThbx/JbiNs51St77PFsP5b1P
	qFxuqyste7/BkihRa9OGHUaMM5LtxY9z0DIeeeXiBG0e673pZr4woHJYRrFP0uawOhd1V4Euojm9+
	znpnH9BeGXEtJLzX8BS9zUAwbro6R/SImQ6IGvRZPZ0w9VOpfq+/aUxFKNjLmm5T7KCAOGW4TyzbU
	w1m2yF2+H7oLYG0P9JN0vOA2dROstVc2+phcoYg65fULWiTk5EBkChKE3BevZm+w3p7ujzUfnWS8W
	v2Vgw5Yg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wu7Bt-004JJP-1k;
	Wed, 12 Aug 2026 11:32:13 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 12 Aug 2026 04:31:52 -0700
Subject: [PATCH v6 2/2] kexec: keep the next kernel off hardware-poisoned
 pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-kexec_posioned-v6-2-e477887086f0@debian.org>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
In-Reply-To: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Breno Leitao <leitao@debian.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com, 
 riel@surriel.com, kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Bradley Morgan <include@grrlz.net>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6504; i=leitao@debian.org;
 h=from:subject:message-id; bh=DngnSfPX8XBe6I/yjyE8XagV4YyZPUZlPnCTWnEo5k4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqfFmsufCoDT5cFM1bcdNKZCitkrQyQY/M2Zqyk
 xSH76lNFveJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCanxZrAAKCRA1o5Of/Hh3
 bdGFD/92nUsa8eZs63kMuOvyNiWyDpQeZzq//w2XgiP+7o6YoTuBSKV85sb0nS3tF+MRwuRswiK
 kb+9r1A32Qkkg1UGU2wnVMKiGJ9+wUejnaLVVYCpsT6oiPRC8Ew5vrbPmFemzhRD4HoiERfXqoy
 i2tF1+0PEsrL4bCpZNgpmYbgZXB5ZMJnGjymNBohy2bwbVCvusbh48Gi599QMoI+QU+/tHo/rdA
 UFMzRqfLcdMeEpV90Vyln3FTcsfm7ten97cC0jCQrzrBtbXHc1jHELYcSuDEs1nkTaFZe8AQGSs
 keyopJCpKyX8dO415r7FmadedOtaaoCC/5HsjBV8Zb1CcP+dKD8FDirBfa7G3F1dPz/oiUZfhLv
 hthfFOhT4/qi1XVIaPFURSqibxmfqUMGNQbcDBT36O0nQr6KlIr5hoF1LNOSeRnluQRjRmCMsbA
 Wje6t8igbkRm/I9JN1sPhOP5EiDZmNlvzqb6gVE1vuQH/9c+k+ga3+vo2CvrVhqRhONgLd9MzdB
 pn4DDzlqht+TGzDyX9bMuZmC6dwDEdvjno0gx041/whLGeoNS3VuxK53s1KA7u2PFfx5M/IoPzS
 XYdiG1bTrs80KIKtacvHg/Rb1SxCSDLzs1VpzLqzhWgDuIPqY2AHmh4Dl5I+EEAVSPZvyq+7q72
 r5jTQEUCzjaONKQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: e7d8i44j9rm4smnb6d9jpxtat715guxf
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 21E2F4000B
X-HE-Tag: 1786534335-421891
X-HE-Meta: U2FsdGVkX1/53zZRe2VFct+XS/N8AB54RoATOpbps9cbECiRmJMB8ryyBMt+lm3Plnmev+ffbdBWND74IxsdS/+SmOfEQJWJD9mD+uUiQYTWeU02PENtVVimYpLaHkp1Te8CtFbHGE4VUv5s5eDX9aj9Quz/uHRU+gij9M59D7J3C4uKqJnwZkgdfm08DtVefg4qrp4hldazxtQaIT6H6xOAUWHtY3v5M0Jp60tFqUJmh41zNZBTla9S2MgL/sr15yWGQdj+2CbkXa9iJOciLG1Lir1v7JF3CcgqdXUkSOrWLpSEVm+8tB/MLfisGpmDHDW4+UhotNyiUqlff2w+lxsSGTf7Np1TFyL0zTXKoCoBm710RTJE0T/4Kg9Ri5md5ybYhMHS0ERHLzqxHU9imDtFH4Wr5b0ARQ76lqGdcfCeHWBlk5xz/xx5tCfIzhBGbvgYViXrKVXPZnaoSn3YbTsPcbxZ7UKR9UOYTyLVuq0dI5tFjgtfHhDAPSfzbiC2uBE7b6c4zTUsyyqVM0TFC/QPkf4+BtliCCCDGQVH+P1B5dzW/D312E59Dz9tU9EiMh+qB7s5uOdPV7DAzLKyVvJdFmV3HcXPlXQPeK7E8RgcGDQQl2g/3CP6dSTXOGx5Qj92kOi5bnKe0KdtMQOwHryEr7QRzgbhxLi6xL5f9VbffNlj1PYBosAsbtpy2W+DvEDVTdFptRprjEB9015T6XALscemyVXSrP49pauC3El2Ofimw/7qIYiDmJZXh1TcHqRHf1jRyAv0buZVZmc8LVOun0QWeMkfP8VjzzzYAs4JbQBxP9t8mxjaBxz7nPMW5TGPma5pyNLrGPlrtU0B+cT7gz5CkAi/G1xvuo/s802eShh8ErosS7q5RBAqgGBKbiPzu4NbmRZwvj7k/pGb/DElJm9C7dNT384FH/SHJCn51+uPyyKdPdUrhuQ512JwMoUxYTbok1wmvhwd4xZ
 EKlygsvQ
 pE5Vni3A0ONCxZbLVQjzMF4XdI4lcfwt6BJG7VEDcy8co0fgLKXv2QrdMQRq+qEwtPLyx/f+7eseV+ETiJ659mkcEvuw8UF0qFhfENtmbXWVWOoNngIV6jTFiMPSrQlNV1SxaJveTqd744PPtr81dOAT3PzCZpqXsBP+umvR5UjWpfUOY4YLV8V5RM8xV2um+NHfEXrtwfymEz6OxN37+LWUrl90Ck0AIetkUr/zv/kl+sx48VNM7FQ4dbYsCbi6rb0aHtDemhSRCeU3aeNzxl+5GmkL+yOXAItVUK1x135DzfyHUqknQhaINJoHYr/ZR9ZmxDTHImZS+cv4ipw0zWjOmmWg7lxtkj6RDDqwrVNyz7uYSnIQJi0l0dWsgyZr6OBw+MVGwb+aHD5jz1OdTWdDx6unti/7Lge2cavJIKyBPr6zcJ/mQqz3UXatnitJk6aY+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory failures (such as unrecoverable ECCs errors) are getting more and
more common. The kernel knows how to handle it while running, marking it
as poisoned (and SIGBUS user tasks).

Poisoned memory is removed from the buddy allocator, but, not from
other places. A current problem is that kexec will load new kernel
on top of a bad/poisoned memory, which is undesirable.

If the next kernel's image, initrd or purgatory lands on a poisoned
frame, the relocation copy puts it on memory that is known bad. The
error happens on the first read from a bad page, and that is what we
want to avoid.

Skip hardware-poisoned frames that were detected by the memory failure
subsystem earlier when placing kexec segments.

To do so, add a helper that reports the first or the last poisoned page
in a range: memory is walked top-down by locate_mem_hole_top_down() and
bottom-up by locate_mem_hole_bottom_up(), so each direction needs a
different answer to stay clear of the poison.

kexec_load() gets its destinations from userspace and cannot move them,
so there sanity_check_segment_list() just rejects a segment that happens
to have a poisoned page.

is_page_hwpoison() also covers hugetlb, so a poisoned hugetlb folio is
skipped as a whole.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
---
 include/linux/mm.h  | 14 ++++++++++++++
 kernel/kexec_core.c | 10 ++++++++++
 kernel/kexec_file.c | 16 ++++++++++++++++
 mm/memory-failure.c | 40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7fabe6c66b4b7..41b923901b193 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5192,6 +5192,8 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+phys_addr_t range_first_hwpoison(phys_addr_t start, unsigned long size);
+phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
@@ -5204,6 +5206,18 @@ static inline void num_poisoned_pages_inc(unsigned long pfn)
 static inline void num_poisoned_pages_sub(unsigned long pfn, long i)
 {
 }
+
+static inline phys_addr_t range_first_hwpoison(phys_addr_t start,
+					       unsigned long size)
+{
+	return PHYS_ADDR_MAX;
+}
+
+static inline phys_addr_t range_last_hwpoison(phys_addr_t start,
+					      unsigned long size)
+{
+	return PHYS_ADDR_MAX;
+}
 #endif
 
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d053..7ee8c9f078f6b 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -212,6 +212,16 @@ int sanity_check_segment_list(struct kimage *image)
 	}
 #endif
 
+	/*
+	 * Reject destinations that land on hardware-poisoned memory: the
+	 * relocation copy would machine-check on the bad frame.
+	 */
+	for (i = 0; i < nr_segments; i++) {
+		if (range_first_hwpoison(image->segment[i].mem,
+					 image->segment[i].memsz) != PHYS_ADDR_MAX)
+			return -EHWPOISON;
+	}
+
 	/*
 	 * The destination addresses are searched from system RAM rather than
 	 * being allocated from the buddy allocator, so they are not guaranteed
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 01a64d98fbcd7..8b0fc8a5d3c36 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -475,6 +475,7 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 {
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
+	phys_addr_t poison;
 
 	temp_end = min(end, kbuf->buf_max);
 	temp_start = temp_end - kbuf->memsz + 1;
@@ -506,6 +507,13 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 			continue;
 		}
 
+		poison = range_first_hwpoison(temp_start, kbuf->memsz);
+		if (poison != PHYS_ADDR_MAX) {
+			/* we hit a poisoned page */
+			temp_start = poison - kbuf->memsz;
+			continue;
+		}
+
 		/* We found a suitable memory range */
 		break;
 	} while (1);
@@ -522,6 +530,7 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 {
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
+	phys_addr_t poison;
 
 	temp_start = max(start, kbuf->buf_min);
 
@@ -548,6 +557,13 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 			continue;
 		}
 
+		poison = range_last_hwpoison(temp_start, kbuf->memsz);
+		if (poison != PHYS_ADDR_MAX) {
+			/* we hit a poisoned page */
+			temp_start = poison + PAGE_SIZE;
+			continue;
+		}
+
 		/* We found a suitable memory range */
 		break;
 	} while (1);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba8..a2ca8df501cae 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -96,6 +96,46 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
 		memblk_nr_poison_sub(pfn, i);
 }
 
+/*
+ * Return the first or the last hardware-poisoned online page in [start,
+ * start + size), or PHYS_ADDR_MAX if the range is clean.
+ */
+static phys_addr_t range_hwpoison(phys_addr_t start, unsigned long size,
+				  bool first)
+{
+	phys_addr_t poison = PHYS_ADDR_MAX;
+	unsigned long pfn, end_pfn;
+
+	if (!size || !atomic_long_read(&num_poisoned_pages))
+		return poison;
+
+	end_pfn = PHYS_PFN(start + size - 1);
+	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
+		struct page *page = pfn_to_online_page(pfn);
+
+		if (page && is_page_hwpoison(page)) {
+			if (first)
+				return PFN_PHYS(pfn);
+
+			poison = PFN_PHYS(pfn);
+		}
+
+		cond_resched();
+	}
+
+	return poison;
+}
+
+phys_addr_t range_first_hwpoison(phys_addr_t start, unsigned long size)
+{
+	return range_hwpoison(start, size, true);
+}
+
+phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)
+{
+	return range_hwpoison(start, size, false);
+}
+
 /**
  * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
  * @_name: name of the file in the per NUMA sysfs directory.

-- 
2.53.0-Meta


