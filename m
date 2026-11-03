Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD58E606A334
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=karaolidis.com header.i=@karaolidis.com header.a=rsa-sha256 header.s=protonmail3 header.b=eURVgQMl
Received: by kanga.kvack.org (Postfix)
	id 8D1686B05B6; Tue,  3 Nov 2026 04:51:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A966B05B7; Tue,  3 Nov 2026 04:51:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A646B05B8; Tue,  3 Nov 2026 04:51:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 369266B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:51:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9652212036E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:01 +0000 (UTC)
X-FDA: 85393339122.08.9AE9173
Received: from mail-106111.protonmail.ch (mail-106111.protonmail.ch [79.135.106.111])
	by imf03.hostedemail.com (Postfix) with ESMTP id 544A12000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:50:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=eURVgQMl;
	spf=pass (imf03.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.111 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCi8V2XvUFOyb68nKeOHWydr9sYNDskVDmcOf8KHlEQ=;
	b=Rp3mrsRi5btamKmANriXWSyf+2fRPhvrWdLEozHva7ThlVPWmRY3l+s5DwiabwBBF2p0/q
	TBzWr/i1Bhfrw1PTUXpa/kNiUp2PvolbycK/aWWkmkbEihoRXWGOUyCAFXKkytuGu8hQtt
	+GYPP3Goq006vz6At/INiinoJOOtATI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699459;
	b=BhGBlAL6cE33o41IBAx/2Z3vFTJ2tSylND3nYheySmAaEeQTCeGh0OREBwHDnqxllidvo2
	bl5zHBrThD62MEBM+Dz5ToRR1mHWbdHhTLi7X5OGQVrTx8wS+4js+ekUqYlNk4mMkYV4D1
	1fJYBAbbYPWnyKt+zXZkjGXm//YwH/A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=eURVgQMl;
	spf=pass (imf03.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.111 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1793699456; x=1793958656;
	bh=DCi8V2XvUFOyb68nKeOHWydr9sYNDskVDmcOf8KHlEQ=;
	h=From:Date:Subject:Message-Id:References:In-Reply-To:To:Cc:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=eURVgQMlzGm+pkfVW/ALkVz3Uu89Qu/pfKxL3uKVC5/UY2eNfrxtTkSZV+YkCMRQ1
	 CSAObtSQmGhz+Bx6awstIqhlD37FphL52S7+e/yqQzFtVM/8cwg3h5wT/FVbw8qd7E
	 M9LDakSpwX9u87yKB7AIZV6EihImEw+xhAsYTfyUFbKDe8Yx9Y/mjfYq/deyrFpNzT
	 7kmOBnaF2+UAymv0Rz1BWfg9dgz1Y+2bHulyPlYS8lsHmq2ps6HOOy6WMIlfxBeFRT
	 jmiUevGwRgXLCOVucbl06EEq3foxirijMPjUTFAypTABFdzmYLRo1o0gj0Z3iDWEdC
	 7zOPCmg1uywVA==
X-Pm-Submission-Id: 4jJkND1KS7z2ScjH
From: Nikolaos Karaolidis <nick@karaolidis.com>
Date: Tue, 03 Nov 2026 09:50:07 +0000
Subject: [PATCH RFC 1/6] mm/memory_hotplug: add and export
 mhp_memmap_on_memory_nr_pages()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-virtio-mem-memmap-v1-1-308ae1da6240@karaolidis.com>
References: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
In-Reply-To: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
 Hui Zhu <teawater@gmail.com>, 
 Georgi Djakov <georgi.djakov@oss.qualcomm.com>, 
 virtualization@lists.linux.dev, linux-mm@kvack.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Nikolaos Karaolidis <nick@karaolidis.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2723; i=nick@karaolidis.com;
 h=from:subject:message-id; bh=SKZnlo9//zIgPLDsuEamosfk9Ui/ahFJfPVQh8m9rm8=;
 b=owJ4nAFtApL9kA0DAAoB2mjImL9M9YgByyZiAGrprndq8YVUy5FGPQyLlA9QXuue2CziSNCha
 TWPgRM0WQDh6okCMwQAAQoAHRYhBLMZG7EWqsMYjymWX9poyJi/TPWIBQJq6a53AAoJENpoyJi/
 TPWIpQwQALR5vun7/ritq55SSJRaIThf2srfn090RZm6Q7eMDFjCnQiCf1geKEFFL7tqOfMkG41
 AloHVrKNfejnNJGxeXsl/h8wbmwbRferU4vgAE8PMISemGHn4i/MgzoNDQ9m7dcddpSyibZpEFr
 AiVtUT0DoTEh6dB8TiIVQ/7PHW7lnx98o9MspM5bkVu7EoSsG3FhYeL4U+4W8vfYwAX2l7hKLbe
 wEzH5vHoZBHjAqcMHZbfHIcxyUxzKzB4CHelt1WQiCNaOjhmIhkMOXLCQWbBeztQCCg8yZawVKn
 OXXbpiolCwEetxIGvAxaNxJlePvWmUXeBbLX/fxp6wSrkXf7HsmvjmrKasNMslvl3f9zCecTv2P
 6y9ke2btUaFyCVGxuWRjgw1105CjYBpmoDWh0zoeNID5Ocp7K/9bUw6FlLr2JiKkfc6jqV4R4nH
 suqZSRpihb/zFS8smkhVc4qvSs2rq9qwIQ0NCVsVfnY7nlSJ1sTZHWoe+cgtgNt0urmly2iU6cb
 pWlpIklPqRpQI72QGcVL7RqCBtkQLuhaj2IayxI9nyJx9GFsp/2m1c0HUw8Y7PaDBvyxTuAWbAW
 4QLxhHR9CzFYkyf/rQtrWqxBAJhl48FlUPyoZXdvlvMDhgkkVbA2PiwZ9CPxQjY0ly4kAtZu0GY
 qO8jcp1KGsV8B0LtySeco/A==
X-Developer-Key: i=nick@karaolidis.com; a=openpgp;
 fpr=B3191BB116AAC3188F29965FDA68C898BF4CF588
X-Rspamd-Server: rspam06
X-Stat-Signature: r4qaa3j3nxwphaf6s49oso9hnudxwcja
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 544A12000A
X-Rspam-User: 
X-HE-Tag: 1793699459-674294
X-HE-Meta: U2FsdGVkX19qGE2X6hbzcDIwPN4rHk5b7faelpIbFx9flMqTAY71mt3K5PNj8B+97ZcNPQaqS2dV9uK6uFaxSC4P5NMiNFQptbodHCNxvWJDKG2Z+NvWGPt8UP45hBrqe+AY1SMu3HjLKAYcBObjOhSshGFAnX8lSWZDbPqIs+ld1NL2RmXHS8VF2eaStL5X9BKtxfFGkhqzt3KP1hmJV9agRRCTvUeG4GGwjArgUbMpYKPIKy0xNdMttaojEO2lZLvtswuI1tPuchuEfm39neiXqK+33Ei+XPP3ls4h+I3e0aqKJFCdzRYwAbkrDERlj8YPnfbkKBeOo+bTwMrraETvmrugqFXFDa+T/m+CRvp61MGHQorlN3rYC2NsVetx2roqUKfL5y+74iv4UVRg78SPuQpL37LlX/WuxcG/U/7qKVzJzj/I7Jkw5MzmcsbaZyq6RWiuhetZsQJXPjnpUyZJlZSsmeFiKe83DskDIZmQq59oX/+Xn2t7QSmKy59tEBNQw2QvPnLUC88nVl78T0hUtBh/FQX8vwGJlbxcFKqfpWw5bHfLIbJi/XLp3RpJDBdLm5Vy1C2m9bR+z5N6yAhVB86MtitHXmuwlJgwQwHlSOQxt1QCwUE+4enHMvjH+i6/2gT/e5GgsBsTCy1DDbrKc3a+7aOCSK50pJdHxPtcRsmY4zgHObRtY4LP7kVtIOnBpsPYfAwlAo1azyE7YYhEbfKuOxqScZ05U4kcGC/eDDN46EZL6JJaqmWW0UjcGCQDKKvnpfYgNkkgP+OTWvoJ0TSy8mS4cd3LhVtdocd6Ugoy2Han+P95qTndQuZ76ED4PI/zKY4OVj1Y3gOg/LJd9TRF8cPh6uRQnyIycX/Rn6U0g4cWykYH4Fxo1UYIS007L/V1M9mHEimgdR3wDF2ETjVHP6GLgewXn9HEfz0SoitmTrMk8jOWjSilhjwP4wRLdCcUji9F2a5S3Ma
 F8p6Ktj6
 +pEvgJAg0L76Be2esXu9yKEKYUCFU64sea9Sf5ARCk77n20UrnEIPnQdzJj47pDJd/DVC5cY/2482P4GHdKac4zlzxZVviD7vv5UHNBHBXapGCZlqomgrea4nxaq8gwc0xQVvEEO8dX64touBUVVrTVI60AM8lDtmPVc77ysUQ63pqWHjFmJGwriO/NTegpy7yRLwfjrMxg7GlU0/ptluCzE7f+N5zOMTfm4cVCupMCnrCZcijubpa5/cjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

virtio-mem wants to add memory with MHP_MEMMAP_ON_MEMORY. It has to
know at probe time how many pages at the start of each memory block
will host the memmap. Those pages never reach the buddy, so they must
not be fake-offlined, and in Sub Block Mode they must stay plugged while
the memory block is added.

memory_block_memmap_on_memory_pages() returns a non-zero value even if
the core would ignore MHP_MEMMAP_ON_MEMORY, and recomputing the value in
the driver would duplicate the padding of
"memory_hotplug.memmap_on_memory=force". Add a helper that returns the
number of memmap pages, or 0 if the flag would be ignored. Both inputs
are fixed after boot.

Assisted-by: LLM
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
---
 include/linux/memory_hotplug.h |  6 ++++++
 mm/memory_hotplug.c            | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index b39605d30896..1b261d85e69d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -74,6 +74,7 @@ struct mhp_params {
 bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
 struct range mhp_get_pluggable_range(bool need_mapping);
 bool mhp_supports_memmap_on_memory(void);
+unsigned long mhp_memmap_on_memory_nr_pages(void);
 
 /*
  * Zone resizing functions
@@ -220,6 +221,11 @@ static inline bool mhp_supports_memmap_on_memory(void)
 	return false;
 }
 
+static inline unsigned long mhp_memmap_on_memory_nr_pages(void)
+{
+	return 0;
+}
+
 static inline void pgdat_kswapd_lock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_unlock(pg_data_t *pgdat) {}
 static inline void pgdat_kswapd_lock_init(pg_data_t *pgdat) {}
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078a..800011ca194e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1409,6 +1409,21 @@ bool mhp_supports_memmap_on_memory(void)
 }
 EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
+/**
+ * mhp_memmap_on_memory_nr_pages - self-hosted memmap pages per memory block
+ *
+ * Return: the number of pages at the start of each memory block that host its
+ * memmap when adding memory with MHP_MEMMAP_ON_MEMORY, including padding for
+ * "memory_hotplug.memmap_on_memory=force"; or 0 if the flag would be ignored.
+ */
+unsigned long mhp_memmap_on_memory_nr_pages(void)
+{
+	if (!mhp_supports_memmap_on_memory())
+		return 0;
+	return memory_block_memmap_on_memory_pages();
+}
+EXPORT_SYMBOL_GPL(mhp_memmap_on_memory_nr_pages);
+
 static void altmap_free(struct vmem_altmap *altmap)
 {
 	WARN_ONCE(altmap->alloc, "Altmap not fully unmapped");

-- 
2.55.0


