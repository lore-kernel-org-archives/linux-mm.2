Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C9CC5B56A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 13:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0266B007B; Mon, 10 Aug 2026 09:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133826B008A; Mon, 10 Aug 2026 09:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3DCD6B008C; Mon, 10 Aug 2026 09:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C28E86B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:33:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 568A714016B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:33:43 +0000 (UTC)
X-FDA: 85085452326.21.DC4D58F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5EADD40010
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:33:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZFZuEIqA;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786368821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M4ZuA5M6RkD29gUcHfwnbTxPc3xPq/YfIHf5PjSwt4A=;
	b=fBLM9cTA+ivQPXNQOhJHjGQaV4MmfPS6zSGuIi4chlM59n3RGXG9Kj6xKqR+SUjmmyKNIj
	RlKI8AHZ7CqMl1vSMocm5l7JeZduy7F2Zc59Z7jyPQ9BxbS3bMEclCvIfzps8k+Qx/v9BN
	51/PsQYUfAHlNolYeKVlGXWL3ScFDlI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786368821;
	b=PDMd+s/5Bhkv23s1iapAklDNtqAodXVTEovkidhkBQGVTURDUpWp/K/aHg5/gwMo4oFz0m
	iq1dXREubkFo12Ka2Pf8CYYSK53pEfhmW/FZjMztuanBVTlTjy1R8lUcdMeHxiAM8HM5M7
	8lTrhWg9zC3ZxoXNlGLjtFVunRISc78=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ZFZuEIqA;
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=M4ZuA5M6RkD29gUcHfwnbTxPc3xPq/YfIHf5PjSwt4A=; b=ZFZuEIqATspEl36CdO+8X+D/Tp
	FJ+RU9/NffoQV7DoNjQ1lz9LC3HX9NpIKx40tUM9okP5FfKZMWLhZY+6iVcBY+YninrcCs2v4Bl06
	2piXIB6GZxtjIm/nyivOeuc3TatIyJhNKQ7WF2juk5I5QT45XIUp5kihA15BrFUl5cY9AsykjU2ci
	RSkjHZ+zWCZ+1xewR/PUfUs/rXJotjmonleIxU2TrI+/qDlOxqNZyR24KRgcnTX1RJUqpUgSoMwu1
	+8jqQmPQFWoQ7mvU9ekWP8zv39SbEhb2mWn/tRVMyEifYy3lIiIL4JlOvGx7CEfWIe93bsHBAgcH7
	VUzUqIgA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtQ7t-002mgl-2u;
	Mon, 10 Aug 2026 13:33:15 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 10 Aug 2026 06:32:04 -0700
Subject: [PATCH v5] kexec: keep the next kernel off hardware-poisoned pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
X-B4-Tracking: v=1; b=H4sIANPSeWoC/2XQTWrDMBCG4auIWXuKRv/1qvcopcjWKBEFO8hFp
 ATfvThQmlbb4Xvexdxg41p4g1HcoHIrW1kXGIUdBMznuJwYS4JRgJLKSa88fvCV5/fLegw5oVf
 TJKMho6OEQcClci7Xe/D1bRBwLtvnWr/u/UbH9ScV/qcaISE5OQdKFGTml8RTicvTWk9wtJp68
 Fp2XiFhflaJgrWUnem8/vVB6s5rJAw6RseJpbbUefPou1c0g4ReJuszGads+uP3ff8GpFBJ8m0
 BAAA=
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
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=8448; i=leitao@debian.org;
 h=from:subject:message-id; bh=fcxYIOs/vy8wB7NClKG7Nu5A9xU+96w3y9opFudFG1s=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqedMUVUszL1AO7A8JlMeC+ztg9Q1uQcgOu3BPB
 fI8nGd54LaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCannTFAAKCRA1o5Of/Hh3
 bYxND/92sMdiCE0yNz/tVqsJ0/LCu1nI/zfJHy0MAR+DGopZRIIvPB4XSbwo2BOXRhndIXZoTQN
 BBQscJdTaaAQ/yk1KvlunHo/IeX5YAFYPFJ0DDXb0Ylu/Lir0jIQcLbuLWskyWilaPZmXBQG2k3
 BFuTmKiTCxBs5pXLXaYASXf84evafHYJ+RNxKR/MivLNtd/k5ygvmVZ9Ng2274zlTyECxPLYbzI
 mS8YVciD2dLDcgor8kOcH5KDYVap5/sir9bAV/DqkZODD9y5pGDHqKInIprKB8NtZMzqPb6cfKA
 o5imMImSb7hi7iPsPDxTx+VDvyIDV3JHpIRBrBfkRAgfcsRyDOaiRwh0APzc6G+g59G1rkZkdeK
 Q/vIPHJhrAyVDsBr1ADlnq9mf8TCr9lrslUCZuB4kwIFGwyJxqnUdhkknqfQAQ4XQ/UT1YPpbE5
 01tD6jpA9uAmMwfeb3GkKBR8gNytPy9X0YGExjKmVwhagTbUsCsVMOm+6edONkl8v+Osp1HryxI
 hOAHR+TUUDahoner8Aao/JEC8YT1hORR29uZsWjoyRzHt8009LK0GuK7KJyv4jioXkTIskPGt2S
 I5qdIHbQOPPhnvtSMYrHmXIqf4s+vzhF3RasU72+cXwHZ0wX7CgwlXolCuPxSUOkOxbVNu73kdw
 urlq18A+tv8GN6A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5EADD40010
X-Rspam-User: 
X-Stat-Signature: kjd8igfegea5accaxhe87tfmhbgh6unh
X-HE-Tag: 1786368821-188358
X-HE-Meta: U2FsdGVkX1/Rkfz6d/f4t+P+bFgVCxyJNBRmgwGxFczMZStZv9c7wUnAqtj/AAPsQCrb3f32D0RRlxEWuLqJ3pLIhdx8EsGZzR/AvYVNKghes7kQhLk98vJ0LvvoxvM3f1LEmLLLj+eGXfWmQ300cZ5fAmuU+KaLe/BD2aTFUBdSWMauCxzj5kCenlUhKNSV3/uOiDx5ZyKldd3Kqxyuvx1Ux059wfL3XsuD7UkAy2DlhNASv6xl5qAupuZQJZWgM4Q/1Pe5ZrCHlOZywOsLAoJkYEyWTpoqB2wLW1F3OXsezUtUIU4gxBwb8JR8RKF1qMC1V62K06MxjSVt4TWxLp6yxEovrD/F/Tenqyr5srnyL4pGyH5rRkmz5Wmx7lUIIiqGb3J8awfCHSkcSwWsfEwcdKEMbVc4UrjckBxWEyiSf32kfcA4S2Vho5D69yk++Avgbb9hQWfjyLre0vXnQTMt5M7lXmKznY9MHgSB1XSooOb4uE7K/fPeAyHkK1AKpBDOzB+NOMPDUEnv2rad/7GbSeM6M3K/ONayium1kv/9hOAKXBNzXG03+RQO0x9HJbalolC95oFqngWMPjGz3fRAFnHQIdeTExApb9wWXvD7M9+Rd5pYYGSP7a3kERqDoCmsluNCiOUk0ErwgIM1chPCTJLujAu94eJFFspgwj3h6tdyjhMx6OLq9O8NxbJf3HLxCSk58GdCpzEXAri8PS02FzawVofMbhlqdh3glcxsVamOKK1ZFf2OyihCN7GCQL0nr3RahWfOpbbf6FpVAGscF+VY/KD8Kdtd5fNKOxLQheQOOlsCz7+o8/HR5OoNp3mjl20pL5bK0XkMDC6v31diYHDkby9s97jBH8lvqcqFTWBrRp9f2IOvgyMQ7k6MAVz1ynFTVK9lMg4srk1oUm/HU09TC4hrtPQIPEzW2f/nXeosUfZKQT/toaPhQtCux+rZsB8oZrMl7O1JOtD
 WttfIxT5
 2YILWVwih4pQNYKytUUlOMVt0cnX9qHVKkYXNjRC3bHdbo4JWcptZuR9lSUR6k00DaLoF2B0CxLJ5iGqQwAlPoereQ7nI/3nKkh4Gt93cRf1h9kecwYVo9H+brtbdt2X6UiPTQ+jVBRrlCfH0RY1KxfMl65M6giThcDOLP8fGftBPLAz9csl4xuq/bPkJAhLimzqQC2ZzkOz49WWgRyG7niJ57yYI8IVBk28xho8yRFwy8LU3nkQxfxQ8ohBKo0q+wlu6l3sVhZ7nmm7kywonfCzr/dDVwFCcoNPTcuejPTn/cu12c9SyJG6imTHa0JKwaxiRTz4y9pZIl8BKUzV2Z46gGhB+uZMIbwoM3pt8e+JaOYLv+dz8K65VMXf0y6QmlMb51RvI2FtPI9cL60wTFQU+RLS6Q+NMxkJC5Y0JCvb3eNIL7kV1HuZC42jQ65ioLndEFdEXzzNm20HtcAKM9q720GGIxhlmvgcWUL2V81tWVoxN8NbeT5/4jnGTUuE18Jurg8KWoXfPp1HcT8bQXz8+j8B0MsEY59s8wItZw95V/KN5/qu34OurZ0C4rwXYd9DGYrc7V1dYQoAqlMboGyViJYFA6q5eyx7f6/q59P5Lw/Xtabd9Bcy7MWgbe46xSFIXyct7TNtnn/VSNrG8bYoFLBos5KBFP76x5J9usf82l8cVMxL4uPBg8NDZJeKwV8A4dCBNUiwROIF1aEXm6iXnQ0vJDD+rvg1CdetitouL5PJGD3nu3TcZAl7ahAwbeUHLvDM16zkMbEDndlohiA90o7eUW6GI8mep6jIPf5aJu3W1fIR/wY5uVy+dUCQ8dfPWaZk2t9oIGGE=
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

The two hole finders walk in opposite directions, so each asks for the
end of the poison it has to clear: the top-down walk for the first
poisoned page in the window, the bottom-up walk for the last. A poisoned
hugetlb folio counts in full, as hugetlb keeps the flag on the folio and
the poisoned subpages on its raw hwpoison list.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v5:
- Return -EHWPOISON instead of -EADDRNOTAVAIL
- Leverage is_page_hwpoison() instead of per-page check
- Link to v4: https://patch.msgid.link/20260807-kexec_posioned-v4-1-70d57f14625d@debian.org

Changes in v4:
- Anchor the top-down hole finder on the first poisoned page in the
  window and the bottom-up one on the last, so each jumps clear of the
  poison in one step. New range_first_hwpoison(). (Kiryl Shutsemau)
- Count a poisoned hugetlb folio in full: the flag lives on the folio,
  not on the subpages, so the per-pfn scan missed poisoned tail pages.
  (Kiryl Shutsemau)
- Link to v3: https://patch.msgid.link/20260803-kexec_posioned-v3-1-83aa6ede0351@debian.org

Changes in v3:
- Return the address of the last poisoned page in the range, or
  PHYS_ADDR_MAX when it is clean, instead of a bool plus an output
  parameter. Renamed to range_last_hwpoison(). (Pratyush Yadav)
- Add cond_resched() to the scan loop, as a segment can span half of
  memory. (Sashiko)
- Link to v2: https://patch.msgid.link/20260730-kexec_posioned-v2-1-f92d18551f64@debian.org

Changes in v2:
- Change from pfn_to_page() to pfn_to_online_page(). (Miaohe Lin)
- Return the poisoned address once we find a hit, to avoid the O(n^2)
  rescan. (Sashiko)
- Link to v1: https://patch.msgid.link/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org

To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Baoquan He <baoquan.he@linux.dev>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: kexec@lists.infradead.org
---
 include/linux/mm.h  | 14 ++++++++++++++
 kernel/kexec_core.c | 10 ++++++++++
 kernel/kexec_file.c | 18 ++++++++++++++++++
 mm/memory-failure.c | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+)

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
index 59fb9d71e9d86..9ba6cc01af929 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -475,6 +475,7 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 {
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
+	phys_addr_t poison;
 
 	temp_end = min(end, kbuf->buf_max);
 	temp_start = temp_end - kbuf->memsz + 1;
@@ -504,6 +505,15 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 			continue;
 		}
 
+		poison = range_first_hwpoison(temp_start, kbuf->memsz);
+		if (poison != PHYS_ADDR_MAX) {
+			/* we hit a poisoned page */
+			if (poison < kbuf->memsz)
+				return 0;
+			temp_start = poison - kbuf->memsz;
+			continue;
+		}
+
 		/* We found a suitable memory range */
 		break;
 	} while (1);
@@ -520,6 +530,7 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 {
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
+	phys_addr_t poison;
 
 	temp_start = max(start, kbuf->buf_min);
 
@@ -546,6 +557,13 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
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
index a8b03e2920ba8..f3875680e7955 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -96,6 +96,47 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
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
+		cond_resched();
+
+		if (!page || !is_page_hwpoison(page))
+			continue;
+
+		if (first)
+			return PFN_PHYS(pfn);
+
+		poison = PFN_PHYS(pfn);
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

---
base-commit: c5e32e86ca02b003f86e095d379b38148999293d
change-id: 20260727-kexec_posioned-72bb0a4143a0

Best regards,
--  
Breno Leitao <leitao@debian.org>


