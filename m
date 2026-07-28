Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B322EC54F4D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 16:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959C66B008C; Tue, 28 Jul 2026 12:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909876B0093; Tue, 28 Jul 2026 12:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8E76B009E; Tue, 28 Jul 2026 12:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D68C6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:28:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE9DA160485
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:28:40 +0000 (UTC)
X-FDA: 85038718800.21.C47E601
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05117180008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:28:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=DKb4Qxec;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785256119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YIer7IVQu6sdXDBXBO4blJvI/i45KO/+dgraC13Eku8=;
	b=XpjEK8KFKNodgh3kkKzi+7GCA0SLAcKi7g63A9tL99Xut+HnZxbrOUYyuQgX55Tsqt9Lwy
	/K1luXSiLABEL6v7Xej/++67Xk/bX4jELB6cwtcfH80D26q1C/hosotpo9ySvygHEtIUlp
	pj425GapRh6EmX1HgpnrQlO6QCkaegg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785256119;
	b=cJoTsAszPbRRO3QZr6rsLqe7heN2qZ37j5pB89/ugpyRolLTBgW/cJEUCwQuGkD8AYRn3v
	aJM1wnk8Rt7K8Pp2T+Q5L/ITu3v2MtzwkPIET1EGV5BtCn0hxuozZ8l9KmCJ2NGkSwbG7P
	B60dFVrPQIwB5q6Hf2gEzFKmboPQ+Fo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=DKb4Qxec;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=YIer7IVQu6sdXDBXBO4blJvI/i45KO/+dgraC13Eku8=; b=DKb4Qxecq624/3T6timyLsyZpz
	WxHtr5FDMHld1HLlrWfglmV1UXJ8OATH9JKGabK6ApTqv3jHjz5nfthLR2xfHcZafjDUCIfExIm9U
	msJ6/kwBQodU0C16Qc7prlbcJTfTKKYPKV/Lv9R7c+ya8E58HxtFyGLb6JwPrC+cTuxFR4cPHQcVo
	7RN4OqE4ym7MJntrHee9dYHO0kb9x+oKTIaenAaHwz4rcd7I7Y8IBTZ9yKywHFiwrBJHJNn5uvR0k
	SFAmPtOmRKWqvoXsaH7gwyKPhTPk1HQvBoUkqeKAArauwwlglL+HY0dJywBzMvpvobTmgYjS8wHue
	naNKKbKA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wokbA-007nlF-03;
	Tue, 28 Jul 2026 16:24:08 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 28 Jul 2026 09:22:57 -0700
Subject: [PATCH] kexec: keep the next kernel off hardware-poisoned pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-kexec_posioned-v1-1-160c81d180fe@debian.org>
X-B4-Tracking: v=1; b=H4sIAGHXaGoC/x3MUQqAIBAFwKss7zvBLBK8SkRobrUEFQohRHeP+
 h/mRuYknOHoRuJLshw7HNUVYVr9vrCSCEcw2nTaGqs2LjyN5/FBjsqaELRv67bxGhXhTDxL+cN
 +eJ4XcMUxy2AAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4769; i=leitao@debian.org;
 h=from:subject:message-id; bh=nQSm5rYV8cjazgSzvHIJfAskSEGBu9DQvzJ0xkXZLw0=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqaNeiZA/VXiwvyo00LoCIEW4X/qMZVed+YMGtk
 aEsqlLrlxSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamjXogAKCRA1o5Of/Hh3
 bcPXD/9Gf4bKeGFEgYJatATA6hZ6ZTE/x4xuWP/vzgqoyCSXNwea3kDhw6x/DWBA7wlC5d67jxE
 yg0NjtHC+3FRc+Ax/+mCjyWlHxzroaHESVsLUBkOviufkhgCpnvU3+alILhY8yPvGHh3r6cRrUx
 ieoLCdWTXHgBPIzvZZTn+Br1lrmyvjvxKVYChiKZZJvq3l4+7EoY49xrBHhnLpoFUPkBcFOrDaU
 LhbLVVp5v8KHZLcOlDh+qjT/Jvlb+Jry6fg4M9URFujcSZbfwl90tN9aazpIBwhmKZ0jFpaKbs1
 hlAeizxQ0/sBQ4qtWvl9QycDzn0QTftbVSUmHmKBBhyiUo2lnADS6zc+IHSiyPNeos5sdcQH0+m
 ozhX2dixp2IoXlkgR37ojd63HPoteWxNALoi4RMUomSEfrercXae88U2crhD+bQn8SegjSH4RNn
 imp6TpWNP7S41laZ2bNBHYfs7K+mE3fyN/QhHD/7nIso61xveRFSmydNjmRue1osvF10/HgsEp4
 QGGMEQhJpEgVHtOLqNGr/efZxWozOBiUODK+mevjoD4mgcL+zMKM+dJicjywpu+o55Mpfhg+j1u
 MwG6Gsgy/tX7CcgtdyzYHij65Yaq571AbD1gNi/kW1XbvRyko9FOXkUoRTrzcgweVGdh7NwICGO
 YSHKrVvala8HXjw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 05117180008
X-Stat-Signature: tfz67euoi15xiiny6mm7swjhx71zqumw
X-Rspam-User: 
X-HE-Tag: 1785256118-730443
X-HE-Meta: U2FsdGVkX18FDArK2luQVqajGWdjGZVGFp6Yxyn+y6QkNhgE7Eelhfuu8DbT4AEyXjIDjUYYT0T+p4Avhg53dfx5ri5IuRxo/DiFys2199yC/JfVplDjU0OzScNHj4k2uN3ObmRD2v9Oy/SCcnZVRDCsMN70crdDZ9/plJ3YYCVp2NWRUcEnYxNq7tLtcsCjHnKlG09l6O/RjI8dSqClYLT5mKtVBxMuKKtgmDV40y+2pVzzpPsJr7c6wWkoiVec5s+1NTmRtN9RRMNnOi6o++Cow8XvNGwfpwcJ7LR8LLoqvpn/kQ2grlW7aeUYzjjtCVeqbjKfizmy/9GTLGX4xTnxFq8Wb+09lse8r13IHtsSZOE1RZ6eCn/e1ZjG5dSg1yqXHhgLB1x8YqYpWt+p3golmbNUG3YRjTWLAmuzzt4cIVJJ0Ppq+QPvYjA/NAztsz5E5aJ01K0Zi0bKZtz+KegZNEX451DkJ+nuxysjxKODc9z0PfcMcU1xwgSU5atlo7RnBHzJNihvAltqQ9KFz3+c9BQDLDAJzBwwejo12KfjG28KdLMM5eunpp80NwUJlJTTLLMuTloanz6jinN/7theUTTkGzQap7gOkvasCzRv0zj5NGJxO/4uCQ5x8kaJBgHdXV0iaseGhjT91boXzFDHBfmvLUb8AsHHuIa/r1HKIyo48u4CG/h7CKo9kwsXfNEDqKGZsFFd203suGgeQ9+5jRKl0MyCikKV1Gn97cv3vKfLjcr4pKcIfRJ9taAWZ4rDk7C66qp4HO5pdLIHr3Sbeq3VcYAijGfpAyZX9/hvnZ/1w5/3ZrbI+Z7cMS32kW3NvgwhfthAvYHaJd9ee3L4stNUyFqijwLbhW7G3T6OzWcAv/XJ63NZszjYV59yxY6xWFXzkzZ+/sL0fOBaSEpGUm5OteCk/mvYWAcqJ0jlj6/gx9kHBbZiEm/nYn1jK8sFWP/ijCmmhW0thuD
 st4zqALe
 ddJIXwTmTfmzi57rvAp/Zr624WajKAQEgjZCN3uh5WBTGGgI3zcKJzARjIZ66/7ZwsvuC//NMOS+MQOcT1Ouy+AlW5sDFFa022qbCYFvORrCsKYejItQoaaa+2B24LSLQ7OHqj/AXPuMuCUVP9wElWFmvOHko4C8xRyhaZE/jsjM0I2uXHAydB1a6UlehEJsY9Kp5hsspsHqKv/lVDngcMNURcOon3habZgj4lKHllhixgEBVl5QqMU24sy6t3UxrVw/tn01r66Hc13KzcThY5jERyoaSOoTNfrLm1jTvwFq2Lv7+RVL/6VDbLSyO99YNmt8pxFeXCsXG2m1/oMKPrUVUHggzvKAACZNzcQGnhXK55jOTmGscyX0AeysC9sOHKZqi
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
 include/linux/mm.h  |  6 ++++++
 kernel/kexec_core.c | 10 ++++++++++
 kernel/kexec_file.c | 14 ++++++++++++++
 mm/memory-failure.c | 18 ++++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7fabe6c66b4b7..a89108bcc3f90 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5192,6 +5192,7 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+bool range_contains_hwpoison(phys_addr_t start, unsigned long size);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
@@ -5204,6 +5205,11 @@ static inline void num_poisoned_pages_inc(unsigned long pfn)
 static inline void num_poisoned_pages_sub(unsigned long pfn, long i)
 {
 }
+
+static inline bool range_contains_hwpoison(phys_addr_t start, unsigned long size)
+{
+	return false;
+}
 #endif
 
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index dc770b9a6d053..18793f925835f 100644
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
+					    image->segment[i].memsz))
+			return -EADDRNOTAVAIL;
+	}
+
 	/*
 	 * The destination addresses are searched from system RAM rather than
 	 * being allocated from the buddy allocator, so they are not guaranteed
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 59fb9d71e9d86..cd77350f12f85 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -504,6 +504,13 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 			continue;
 		}
 
+		/* Avoid placing the next kernel on hardware-poisoned memory */
+		if (range_contains_hwpoison(temp_start,
+					    temp_end - temp_start + 1)) {
+			temp_start = temp_start - PAGE_SIZE;
+			continue;
+		}
+
 		/* We found a suitable memory range */
 		break;
 	} while (1);
@@ -546,6 +553,13 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
 			continue;
 		}
 
+		/* Avoid placing the next kernel on hardware-poisoned memory */
+		if (range_contains_hwpoison(temp_start,
+					    temp_end - temp_start + 1)) {
+			temp_start = temp_start + PAGE_SIZE;
+			continue;
+		}
+
 		/* We found a suitable memory range */
 		break;
 	} while (1);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba8..032bb23db7566 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -96,6 +96,24 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
 		memblk_nr_poison_sub(pfn, i);
 }
 
+/*
+ * Check if any page in [start, start + size) has hardware-poisoned segments
+ */
+bool range_contains_hwpoison(phys_addr_t start, unsigned long size)
+{
+	unsigned long pfn, end_pfn;
+
+	if (!size || !atomic_long_read(&num_poisoned_pages))
+		return false;
+
+	end_pfn = PHYS_PFN(start + size - 1);
+	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
+		if (pfn_valid(pfn) && PageHWPoison(pfn_to_page(pfn)))
+			return true;
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


