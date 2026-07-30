Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF155C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641166B008C; Thu, 30 Jul 2026 11:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2176B0092; Thu, 30 Jul 2026 11:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E19B6B0093; Thu, 30 Jul 2026 11:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 069F36B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:56:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69B7D1C0229
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:56:30 +0000 (UTC)
X-FDA: 85045895340.25.312AB09
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7273212000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:56:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AO8WA0+f;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785426988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QeeiJuN0Sjy8Uw4/dZUmNBcs/fHlw0WPwV83tkIdEVg=;
	b=LtEYC16+KR1U1oT2ptuZBYufWw7XFmCGw8dyfM7VDSNU8N8pGP8Z7xR0F03ReGpFmhNB58
	VvgEHCi4QDPgoukdJgr8kMdPnc3FitQyWTJJw2Ps38VZEr8NlZ2pIDpgjBARZ7IUA4pqtH
	6V9GiCwhSuleXfIOsde8/N5PWb8RgfQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785426988;
	b=UezUj9ib1U3TiV3wYhD867nFjD/6KDRX1GWY3Frh0xy8U/6E3H8/mdgnGW3VSWVeLrRpvp
	RZymwQNFmEk2/iTWx96ANGEevwb2cJnBr813yLnSi9cGHe64/TdR8LWIB41JIiK+1cbq+h
	R93EjcG0ZnXiTSdfdusACTwFxaL7uYU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AO8WA0+f;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=QeeiJuN0Sjy8Uw4/dZUmNBcs/fHlw0WPwV83tkIdEVg=; b=AO8WA0+f8euqq12EwlE6zqlxnv
	bkJcCAEfvbZtCzu2GRYOo/JcSRlVreUSCg6WY9xv4LT6+aQWoSzsnaITVSe64UhU6BhO17W7fwEKq
	JnY4W/TQ2dBGUyxthRtbEOCxmciMfK8cmiDsbBK8Oa96wXKXkD9g47ST3hjmIz0mXMvL9UdRJL4sI
	5hYmedxyI4p71RsrwunJCVuttRx/IepHMHFHSq8QfLHLe9wQl+TknlJfAC15NQrBqQDTLtRm35eHb
	80/EC8q6AOwntSOUPFy6Qf7QjSRrXAyonJ1RlJSTzOKlne0IhGJDpa/G5y7XeLSSdGGa7gpiM0KtQ
	rpye85kA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpT7F-009Lmr-2F;
	Thu, 30 Jul 2026 15:56:14 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 30 Jul 2026 08:55:50 -0700
Subject: [PATCH v2] kexec: keep the next kernel off hardware-poisoned pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-kexec_posioned-v2-1-f92d18551f64@debian.org>
X-B4-Tracking: v=1; b=H4sIAAV0a2oC/13MQQqDMBBA0auEWZuSSUUlq95DpMRk1KGQSFLEI
 rl7Ueim28/nHZApMWUw4oBEG2eOAYzQlQC32DCTZA9GgFa6Ua1u5Yt2cs81niN52epxVLbG+m4
 VVALWRBPvF9gPlYCF8zumz+VveNYf1f1TG0qU2CjXocdOTfTwNLINt5hmGEopXxDXIyytAAAA
X-Change-ID: 20260727-kexec_posioned-72bb0a4143a0
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=6018; i=leitao@debian.org;
 h=from:subject:message-id; bh=5F5DlBsqdP/R/yM6xPT/BGfLDYVW0Qd0O88Or3DcX4g=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqa3QY8WaUST6u3V1yl5vvrupZKusst7u41jay9
 tiljGymnh6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamt0GAAKCRA1o5Of/Hh3
 bQgJD/4qR2Bpc7PQ6Xof+Zl/xPMz2tp0WZ4nlK+s1jkGW1LFYgMOQpX086+gAgiFUKSLQVt2gRp
 plprsrJmOWNBgvWlHgIwEN3TinRH15XCErgM6sar5AT8uHNDs1P9mWnhqHTgKbcAQFoGCWnO9DW
 4F7C7THJHpBigIm6+V+P9FUiOhfRNRIsLNxA8kTI8F6hVT/C1BOM2R11iIXtYAYWZWwZZ49dIXc
 4f1f4F4oRZRbbGwpHX5+H4QRAJCXyUJ6PSacdvG8RkLc2tuLekz9PrQceuxZY3MIzDMGFWvNdya
 a7bUNFu18dnvbwbpLpVXogpS1RI6Dn8UnmHHsaYObUt67fAPTk2laVIBKdltInPGqyw4t2rxGR2
 cLGDKZX0DIyGemo5f87FkrSKMVeROsSqDho03/9yTCRzpJizxitGzlshFe2XCj+Dy9FgBee3ITa
 E/nPuEV/tbqP4DkiKI3gSS951gqT7wCj103x0fKfu7xp8xz8T0eE98B7K25ZRrxTHcgFoXwMn8Z
 fDGl2xeDB5CbC+Fb+WxGREUvtRZW1vom2y0bigxdL8BVR7FGLOyQsPMfKdC3DfuYRjYYXjjauQL
 Wrnh7DzXJU16qI2HdVW1MyXRNMPY1+9tlFb8MLznzSpZxvz6+/oqk2+Zq6wINxkm3VcEBamCe6S
 Q4G3IDtO+A8HIQQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: diafrq91eefi5sbdskw5cdf5umqtufpw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7273212000D
X-HE-Tag: 1785426988-335400
X-HE-Meta: U2FsdGVkX18wLjJ9BJ39dzii2qJ8z7C8AQtw5NUNg3nTu1m2KdkCKe9xBFpZ/i3SlfFMbOu7i+tdHpu99xlbDOH6+eRlRlq9GY0J5DtjxlbumydZJ3+G5xdtDppT51DJLHFRhkUsQC2Nbx9JEKWjpHnzpCTu4f/e1bhCu3reEPoSIK76EAfZbvwzf2EP+eB+Hg5n2N+c8kHMmoRiTfF0z/CYR05aDOp7MGxkGoavE/C6uVXw9yIpkpvrH0q0jZ1cdVC7f8weC52xqSs4ttmx3rz6/dHof0dDvLg2CG7BLm4w3OChbcuDuh5oFzOJae4+lxHd+nx8kwiST4GhMptCPTwkgJ8Z9cIfOK5w+DfMUIWF3XQBdVlQ0Qbnwuxy7V1D/Iuaqdfnl68qlz9V/x9at9pf6mszLlPfI15vk5o6D9pp0oKoi5qlBp3trUyT/1bcZKsZIONSFT2u0Cm/FEg362wbvrbvV25RdNxUWA02O9K/8DA4TE70Be9jnGk9MXHJeiUY/8WcZgF+oqIee56goWWsRTJ+X9NOWaV4PmuC8rVJLG837Z5Co/Gn+4PtUaxqm3uChBbjq+9CWT8wm6V3FCp5/5nM+AHJNuJRcYBUjR/1h/79nz8qIHjrUbYVrgvcQL/yu/tBK0pDI5zxTZnwOopjW9v4V32ykxoH7iCMSE5UkvcoK4S4rouUsGp4WYL4hvgloXgUl9rqun0zv9LFiHCnypimiVKxKvuHDAesNYA3GVqFi9BDBPuMelkVW4uLdiCZf8YmpL+pANQWcyHlvvH8vDH+/YEMRV8vGeXcCbdTgdnkoWOV4uMn/qOvQ4gzhPjRwYNceJyGsjT6cbhppE0T5NHGWQw0R+OjHJ9dbZqyJiGFLj4TY0rkUuyeswkhf+1Org8MTpXqTswZwf0w3Z/YYxhUCwLvtcg9Z/HAqS7Vk4iqnqejFRzLoaW59IRTiQi7/sNRIyDYs1Kk82h
 1axvTxr2
 bPcmlvk1C2NW08E4mpK0Ll1yahyE6ycNXDs00RV7x4Vk5mUNQachhNCoLuWx9e9LbqO9NanpkTVbMwT687fWI04++A4qBIznm57RW8MHjE+i1dZHvSDspXX3VbxCWHarH+ePuZxqb/becKZbOhytcpEZg5x/yMq67GnLImuSe0Tp3KluioGAOHdmBR03N77iP1QKQ9I+sBQy8uQoDD4Dp4j4AVfIKCi08HmKziHX3Ab9A13oEmModHRv+ybrhpmrMUKdKcQWUWh3pkWMgy0IYiyISQcCzl+BFPXF76UxjgK6YDXbXAjXtzmrkvTee9tBx040GmnmAVNouAIZPkLBrYe+szTB3ZpJV0XpI3QHmsS4ueWyAXEgNEXCEomYO0047owyhEmUapBHGZngDqkpDMZPy4GT2B2yNSVi+HqS1xbl3tvlVg5KrRggfT/rTSXxDEyKT2WqhxtGSaNu0ZnNMlTQdJg==
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

If the next kernel's image, initrd or purgatory lands on poisoned frame,
the relocation copy writes to the bad memory and the machine checks
during the kexec.

Skip hardware-poisoned frames when placing segments: check them in the
kexec_file hole finder so it lays the next kernel down on good memory,
and reject a poisoned destination in sanity_check_segment_list() for
the kexec_load path, which cannot relocate.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- EDITME: describe what is new in this series revision.
- EDITME: use bulletpoints and terse descriptions.
- Link to v1: https://patch.msgid.link/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org
---
 include/linux/mm.h  |  8 ++++++++
 kernel/kexec_core.c | 10 ++++++++++
 kernel/kexec_file.c | 19 +++++++++++++++++++
 mm/memory-failure.c | 28 ++++++++++++++++++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7fabe6c66b4b7..48cad9a519d08 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5192,6 +5192,8 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+bool range_contains_hwpoison(phys_addr_t start, unsigned long size,
+			     phys_addr_t *poison);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
@@ -5204,6 +5206,12 @@ static inline void num_poisoned_pages_inc(unsigned long pfn)
 static inline void num_poisoned_pages_sub(unsigned long pfn, long i)
 {
 }
+
+static inline bool range_contains_hwpoison(phys_addr_t start, unsigned long size,
+					   phys_addr_t *poison)
+{
+	return false;
+}
 #endif
 
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d053..9f6ed3c04299b 100644
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
+		if (range_contains_hwpoison(image->segment[i].mem,
+					    image->segment[i].memsz, NULL))
+			return -EADDRNOTAVAIL;
+	}
+
 	/*
 	 * The destination addresses are searched from system RAM rather than
 	 * being allocated from the buddy allocator, so they are not guaranteed
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 59fb9d71e9d86..95cc981a557be 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -475,6 +475,7 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 {
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
+	phys_addr_t poisoned_addr;
 
 	temp_end = min(end, kbuf->buf_max);
 	temp_start = temp_end - kbuf->memsz + 1;
@@ -504,6 +505,14 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 			continue;
 		}
 
+		if (range_contains_hwpoison(temp_start, temp_end - temp_start + 1,
+					    &poisoned_addr)) {
+			if (poisoned_addr < kbuf->memsz)
+				return 0;
+			temp_start = poisoned_addr - kbuf->memsz;
+			continue;
+		}
+
 		/* We found a suitable memory range */
 		break;
 	} while (1);
@@ -520,6 +529,7 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 {
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
+	phys_addr_t poisoned_addr;
 
 	temp_start = max(start, kbuf->buf_min);
 
@@ -546,6 +556,15 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 			continue;
 		}
 
+		/*
+		 * Avoid placing the next kernel on hardware-poisoned memory.
+		 */
+		if (range_contains_hwpoison(temp_start, temp_end - temp_start + 1,
+					    &poisoned_addr)) {
+			temp_start = poisoned_addr + PAGE_SIZE;
+			continue;
+		}
+
 		/* We found a suitable memory range */
 		break;
 	} while (1);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba8..04a1883d51fda 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -96,6 +96,34 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
 		memblk_nr_poison_sub(pfn, i);
 }
 
+/*
+ * Return true if any online page in [start, start + size) is hardware
+ * poisoned.  On a hit, when @poison is not NULL, @poison is set to the
+ * address of the first poisoned page, which is ugly, but I cannot only
+ * return phys_addr_t, thus this "extra" parameter, instead of returning
+ * the hit.
+ */
+bool range_contains_hwpoison(phys_addr_t start, unsigned long size,
+			     phys_addr_t *poison)
+{
+	unsigned long pfn, end_pfn;
+
+	if (!size || !atomic_long_read(&num_poisoned_pages))
+		return false;
+
+	end_pfn = PHYS_PFN(start + size - 1);
+	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
+		struct page *page = pfn_to_online_page(pfn);
+
+		if (page && PageHWPoison(page)) {
+			if (poison)
+				*poison = PFN_PHYS(pfn);
+			return true;
+		}
+	}
+	return false;
+}
+
 /**
  * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
  * @_name: name of the file in the per NUMA sysfs directory.

---
base-commit: c5e32e86ca02b003f86e095d379b38148999293d
change-id: 20260727-kexec_posioned-72bb0a4143a0

Best regards,
--  
Breno Leitao <leitao@debian.org>


