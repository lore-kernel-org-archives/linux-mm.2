Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F00F5C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 14:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC98B6B009B; Fri,  7 Aug 2026 10:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79FE6B009D; Fri,  7 Aug 2026 10:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68E46B009F; Fri,  7 Aug 2026 10:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9C96B009B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:06:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28B77803CB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:06:02 +0000 (UTC)
X-FDA: 85074647364.30.106B2AE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3A5EB1A0006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:06:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GxaLeyYH;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786111560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K3SviOS6dfaElwqZsGFYvgNYmNLpXjvir7qqTUt7Jc4=;
	b=FkjYDjzl62iOm1JqH7IiFDVKRy5HjnrOOryhLQjFZls3ssEkFDm8G4EG3Xr5mivPMfXvxr
	MQyQnF1dBRHhYG1kQ7lywhgwVlSCLRLJw+ID2PBmMILviyx0OfAF1NzWQ1smfTosBN9POf
	EphkkJQz04rs5kBMatHcjqBvtHPvnh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786111560;
	b=vPuqoXuTUWtj+g5UGkpHGlvmmRTpG5f7tsdFG650WQ2V0QBqF4DxVHfD+DDDFrRF5pa7lV
	a7vOM+OpUrIfJUswNPZQXtB4s0ITW+3tdAEcOuV5NxCU44ko6RVAShsIIDLTo9EokS1yX1
	QehCF2Nt7+y4MjA68ItECNoiOFYhCCU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GxaLeyYH;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=K3SviOS6dfaElwqZsGFYvgNYmNLpXjvir7qqTUt7Jc4=; b=GxaLeyYHNZw0HZXIP+vjijRoCE
	zu2xXDts+Z7bKOgH+rIhfwCzToipY6I9hYWKnLvuyR8YdGYhUHHVPxuFgijvThFd05L3QrePApM6u
	yPqvEEHZ10uhsFPwwbz92HtT6SRl0C771gpsnnBasyqcLQcyI976wrnlfXCfLf1V0uUPKNNDS4a+B
	gyiuB9DOlsNRns8ixialnIqyM76s4SP0NXSrWG8IFBs27HHvvREzkSyVpav9wXDEPlpP3hr5MjZU3
	a8Y19qY5ptNbAsJjdV2hUM0pRmrgZ0l750Spl8trqryBEipOtK1XWyTTiILdPKZlYev17NNUfLC3o
	vdz475Pg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wsLCk-000TvW-00;
	Fri, 07 Aug 2026 14:05:47 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 07 Aug 2026 07:05:09 -0700
Subject: [PATCH v4] kexec: keep the next kernel off hardware-poisoned pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-kexec_posioned-v4-1-70d57f14625d@debian.org>
X-B4-Tracking: v=1; b=H4sIABTmdWoC/2XMywqDMBCF4VcJs3bKTOIlddX3KKVEM9pQUIlFW
 orvXhRKL24P5/ufMEoMMkKpnhBlCmPoOyhVmiioL65rBYOHUoEmnVOhC7zKXerz0C9H8VjoqiK
 XcmocQaJgiNKE+xo8nhIFlzDe+vhY+xMv6ztl/1MTIyPnVFv2bKmRg5cquG7XxxaW1qS/vKGN1
 8jY7LVnm2Xc5OnGm4+3ZDbeIKM1zuXihUzGP36e5xdZtS9aLQEAAA==
X-Change-ID: 20260727-kexec_posioned-72bb0a4143a0
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, pratyush@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=9097; i=leitao@debian.org;
 h=from:subject:message-id; bh=SWLUcI/DF2JhAszQhmn2J1XYAQICne5Kz7Jfs0Ci4Cs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqdeY1kEEZkJGz1XhZQ+IcaILAez7sq3dqPdKGM
 QXOYA6OzZyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCanXmNQAKCRA1o5Of/Hh3
 bWyeD/4zPXn1gQcSq4LJXP5wG6c1SwzSBFOrrPUWDFCNsSYbIfwrDkgXtBHmz7YiAK5oAMfaKeR
 PLCZybD3wwgN2md5wVg6+bKGjvDYZYVgpHlcLeLs9UtICZlI3dQJtVAdLUt9OCLTcf7U36VIQcp
 GtbED8jGl6S+T7rpw1fVx9csCJunaGfM2LWLgqR6vNqt6Bxhzzm4rVeoxmXiurlTDZ2kGM9olJz
 q6EfFlIqEKdTCFW7Gq2JZ0zWhKWL/DLeJCM/RzxWXBZarDQHs3c5jbclYLR3ApCinTqeZV41/7S
 Gyk5Vh1Lg2HdP511r29Jp8o1w5zGUkTzsmqze8CwdKaUDzytRQAz0s2rlVMfI47cihK7x32IIWY
 4FL3hDINkgryiY1K5fL6Rca2eFEckuSE2ywPyV30LCLqYYVonnSaw88wBXQzYyj48icJG/+llY3
 84YlUxbJRUm9ebqzu2OuwZ0XPH3kkFMcVQwfiw3D4AIudmS6Ytl06f21cPFniFY4GPGUgY8xeAw
 2ZUC/H7hMY1UCXCz45aa2bnXiECcGCOJt8uSFxBA6RnYGiPcpTv5oTbPtN4Fw/R9ro+HtRkO0yX
 hUx2ygcacZUmH7d03CaUNuT3SM3tcK1FjypWJFqubND/69b6UjhBHqmJzUFAUU7wDWJbUIxfP1O
 ljVFxeb1lznK6Pw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A5EB1A0006
X-Stat-Signature: q7sdzbbjoswi8543yxrinn6sk1baea13
X-HE-Tag: 1786111560-409272
X-HE-Meta: U2FsdGVkX1+t+To3dETtqiuk6NrYzw8Q6QhigPRDvlJ0AAmGWsgaReVb2q1FVNe5hDdTDY5uECMaEhIibLrP+sDptHD94YcMPqZ7J3P2DcHBOW2IuDneGvDexr3MBW1YxrRn3zGTFYYt6W4HPRQm642l+DxvvDCTQuMJsCoC4RpBzhyVUWPT5tI077qa5FUoXWm0zzFmbICn+6p0Yb1X397OgBb7YGcGPqJcf1YpvPVuyvrv9uG983gfayVXaZCZVQcchqfN1Lydnkm0LU0SBwlcVuMqw1td5ZoXAWnnnUd8SzJP6xTNGLvX5oGyrcqWLXQvNXMYiAR2pjTP/HMHVzc8vTEK6IdH3i6PzppvxVLX125peTWZyYcoCzP2gocBNHHKwBmKjpXVnpMb/6Zzdj88SHiXBy55Tmtm9VdJbuj73lD2RnOXpL7KjpAtlp/ZYsdGpR16mq2s3lHZVmJPyYoLce/hO37F3JuphbQ6L2CaHDfq9He+psPERs+BCTpjgHL8lYIGqdDjOfZrPNjNvp6LVXw7umcNpEJ0bdL5W9f6ovlHr9PuYS3Cq1TI87x8xc9elahjNKIN48iYJbJdEUpnvAuTyoNv6w+RcoPoTsBv1EULAfossP7lZ7rkHOT9sgbvRwlsTRmV8uZjxoiKiy3RVtGeO3CllzJTGJRvKOoLhuog4f/ltPAzA4T+sCFRqg62QAHDwnswM+SO8O1PcYCfZda3KKh0hxCHglm22L+xQNRYQBRzeJ1Ex9TYWWMGm+CGfsDIzr416QbRznK0QaWvy+KPyuss9+61GbfUE13dk9En/oCqoX/Du/kjSe/4kTUP+QAtnxq8L7nDiyqJCfMGnDb5b+ilhG3nfryTM1c2w4PcZ+R83J4s/DL8cFm36PufqDg85dFSGvcZK8XAewniCII837b2OtqexUXz+nMnduEBxvBrCVm+EpTnc2oj+P2UL3JM1J87zPoMfP7
 X2taG3RM
 ouMRcgsAy0K8IS/UQzEGgaq5WAKcfY2wdplfnPO0kxXU8bRQNcdEAjut/GhAhpDLTYE3LmFL7QxlHOpgqhoHv/ljjb2k2zISD18oJviIHQPLgcmHmA4b0GE8iUYp6vFObLSQSryurXdMsAiD/FRjxi+iLzRbaFgdgJkq+xNED9xRLj0uNnN6/0MCpABRdNzpL55/v2OxXiCTc9EIHx5+opYfJVc7aVkA+bPnJv7JOZRynwsIZB/KNpUHX6HXZ+pvYb1Jz7BAO7+Tf3usG6998hoTWiNXgc+6jHxmibEh63l+3QpAU33Sdm2o8nBHps72Im8Gbmuv5SDEu7xTle8Xg12xAHO37ygh+oNQMPZoZDvQTc+fSBbMk/C7LEWJIEf43Dc7r5m4uw/bTZd98v9VgrndZJsAFw1rZIYte6T1ZJIy+f4WxrTcNM0eObPzTflWM8UrhJ8i6ytWkKt8Hpzfo6hOu9eLCHI/TxzOlEdOoFKUjyPzZSEGUg5q19lPL9bIGk3CN+04bp2cMAbvMODWe/iPoaieE5Zf0z3NMBt4iuNzKUhIJ1NEo0/UmH39zvXgAVB2zBirgoa48MYeQXCQzF+95cMd1zvPjMb7cGWB/jAiC2iprZDe1RSs6LyCwJrtur7TXIvq3pV+GWlPwAJVLZmtBPW/t/Mtz0hH7zgQoqLk9x4lrXoM9ji+mJEPJl9TZ85RCwrbaS7odRuRhSU5xNOVZT3YrmLvrdd5cexncnXUio45iXRrhB5ndaxqwdJDDj7nYkByoiHevbG0zMon67okuD2yZBJJo1+MNSNcpZWUhCK4jd2KUOJn/8v9YyLIBYHYKKvGuOni/NHY=
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
 include/linux/mm.h  | 14 +++++++++++
 kernel/kexec_core.c | 10 ++++++++
 kernel/kexec_file.c | 18 ++++++++++++++
 mm/memory-failure.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 114 insertions(+)

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
index dc770b9a6d053..e097e980b1439 100644
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
+			return -EADDRNOTAVAIL;
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
index a8b03e2920ba8..c485e205fb633 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -96,6 +96,78 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
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
+		struct folio *folio;
+
+		cond_resched();
+
+		if (!page)
+			continue;
+
+		folio = page_folio(page);
+		if (folio_test_hugetlb(folio)) {
+			/*
+			 * hugetlbfs is a bit special, given the poison
+			 * information is at the folio, not at the page
+			 */
+			unsigned long folio_end;
+
+			/*
+			 * No hugetlb_lock: the scan is racy either way, a frame
+			 * can be poisoned right after it. Just don't let a folio
+			 * dissolved under us walk the scan backwards.
+			 */
+			folio_end = folio_pfn(folio) + folio_nr_pages(folio) - 1;
+			folio_end = max(folio_end, pfn);
+
+			if (folio_test_hwpoison(folio)) {
+				if (first)
+					return PFN_PHYS(pfn);
+				poison = PFN_PHYS(min(folio_end, end_pfn));
+			}
+			/* skip all the pfns that belong to hugetlb */
+			pfn = folio_end;
+			continue;
+		}
+
+		if (!PageHWPoison(page))
+			/* page is good, let's go to the next one */
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


