Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7AB7FF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 05:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330BC6B008C; Fri,  1 May 2026 01:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA076B0092; Fri,  1 May 2026 01:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F74B6B0093; Fri,  1 May 2026 01:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13C456B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:56:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC7ED1206B1
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:56:13 +0000 (UTC)
X-FDA: 84717790626.25.08902E4
Received: from outbound.ms.icloud.com (p-west3-cluster6-host2-snip4-5.eps.apple.com [57.103.75.78])
	by imf01.hostedemail.com (Postfix) with ESMTP id C36984000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:56:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=tZbUnIyh;
	spf=pass (imf01.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.75.78 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777614971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArO79/Yz+eapuC+lM16m1Ks/IIQXLEjawf2FnZmiyak=;
	b=ZUmx2AVVcM8tUa6EbazR0JUb1bPOGIZfEhdXodVezT6+Ea7I9katTb5gMm1WGkuA+QhFjU
	FCzFRkqRiyHaFgVSsxlar9MntV/dIEja/xT+4l2D+KuDIUZZwdc7SPT4X97H9UO6ePJIfM
	UhdsfvjhXL1OT6el4BFRBfvs7yUUKcg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=tZbUnIyh;
	spf=pass (imf01.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.75.78 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777614971; a=rsa-sha256;
	cv=none;
	b=krlZL3TKPp51QwtMB34FcROZUQnxISaX9zHOEahrrK1dLEYGnSV4AvTHIr2Oet4ifgWC/H
	pbBpEiGiFeJ589mEEVcMM0iWB/C6VQGt6auAVV0M+3Y6nn0v6ZuuviG7ymgWL8y1/Gsv1O
	a7pafJHMhHSJckIRmbJX/3d3BAcGT5Q=
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-8 (Postfix) with ESMTPS id DC7F11800121;
	Fri, 01 May 2026 05:56:07 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhAA0MFWgFeAUEdXwFLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEFEYGVg1dE0wLcwRUB10FXVZQAlpLQBMESgZNXw5eHwQXRhlVBEceXVZeHhkCURxWDVdDVARfUEkMQVBsWgBHF0gdXRlZb1BdHA4EVAddBV1WUAJaS18ZXUUPXwdZBEAMSAJAQwNCL1oXREBBWh9CFEgDWARcBUQBSwReDytGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1777614970; x=1780206970; bh=ArO79/Yz+eapuC+lM16m1Ks/IIQXLEjawf2FnZmiyak=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=tZbUnIyhKNnexWjJln4Drt4H+gH8ytUrTUS/yrjXpdRMs5esjcPvt0CLnM+DJdzrNeO20hxCJAVIxEnrHSMjXcSIo+yy+U4rddKIn8n6frmCrucPYxm9TvDS/XQpr4pPbqmBSgRDYlqOXZwpXDRfGOHLAnq7a40pSMFnnxLBUVN310Gz0XKLVi1hk+rMGIypbTxM5x7uJBbDhuNTdbvHtXraNfMQH60lJJ9ZH5oKGZfGWzLLKnU5fTNAXgW6j/ljF1Oz/baEUZs+fW84vW/xdZKiT62t9cNHUL4C2chxOkLXvmeS1talhJi9Pp9yY831gONhwqgE2s3VEVvBujrrsQ==
Received: from [127.0.0.1] (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-8 (Postfix) with ESMTPSA id 29DFF1800105;
	Fri, 01 May 2026 05:56:01 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Fri, 01 May 2026 13:55:43 +0800
Subject: [PATCH 2/5] mm: add pmd level THP COW parameter in sysfs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260501-thp_cow-v1-2-005377483738@tencent.com>
References: <20260501-thp_cow-v1-0-005377483738@tencent.com>
In-Reply-To: <20260501-thp_cow-v1-0-005377483738@tencent.com>
To: linux-mm@kvack.org
Cc: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>, 
 Kairui Song <kasong@tencent.com>, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777614950; l=5795;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=6KT+jkO3Ka4qq13XkF6ZKbrVSZCH58mT9pcv6pbi+AM=;
 b=6EqPYX+PuZjHQKcfgprsY7mv/V4aWtlZT5R+tTAFWFjcm3SRqGZc571FHO583ASFNuAy4VKv9
 bfvO8YAzKRJAiWshdN8Yi/tyJ1YGxhd+8Aetf4bnkr4rixc/J6Epmga
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Authority-Info-Out: v=2.4 cv=eLQeTXp1 c=1 sm=1 tr=0 ts=69f44079
 cx=c_apl:c_pps:t_out a=qkKslKyYc0ctBTeLUVfTFg==:117 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=GvQkQWPkAAAA:8 a=TpG2_MQqjxLYGlnCjREA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: QJ_jTGQgd7VU-fuApa1pEAzmAa2JxrXm
X-Proofpoint-ORIG-GUID: QJ_jTGQgd7VU-fuApa1pEAzmAa2JxrXm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDA1MyBTYWx0ZWRfXzDCdLi85io6x
 zw1xwnafwpI6yxWcbQmNiFR+UXZuYuFr5NuHXEhRjZdobR/qUemadHorvBwAvPrJyag7CYxQi7/
 X2v6J8DI9M1ZoQW1Pif5PlO83fOAEAhlLAsvvItzBXGuNFzpWdpJpYaGpZKwkHSjaphdiYghllp
 eJNyST2LeJ9wPVc3HiKl91Mxppi5xd7ZzpdeNnHj4G1h35SLwnREeCUXWDWgQX159MnSNc2E12j
 /pc3n27XvqEAGqUCGfxi+nknsxpzjbkbVHoJUtvbZVZW3im4HSCEUku3Q+wHZdINfJ334c0qaxe
 dSm6N5FX2Aro0TcIrwxpRn2v3u8uvak6+ZbQ9MEy1j/rtaxV7Pp7KYw7XUhYxo=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C36984000A
X-Stat-Signature: 3t8gamiiknmiud14khkdtfoq5r8s1guc
X-HE-Tag: 1777614971-877218
X-HE-Meta: U2FsdGVkX19IgZgSB27vWllxUptij4JhI+vcS0Mw+dzN2RJ1Kjlo6RBYlpHvJV3u6M9wci8oO7s9rmGkpJEHh49/fs/jnTyk9NkespdFHbh+NaHera8IcnRdnWzH8G6pYGcIHQ3oAMaQbsi3dfX0szDuy9BE+k15SdHMtt6MgvptZ7SvERSIKv/wyanua2oqvioGktLbZwm0AZS6hFZnz0+bzmQY9OlF/i076YvzWt8MFckImH+jsoAQQKtVyJpmwqfAnx857aGPaTfBr0oivii4POQvtyj3rwZT0ZsQ44xfkDNTyCmNcDBXyZ0QW3q9L1WxesAoyNqWRCvaSTfiaB1rltS75rE3xNv8JBckHbXz4lZtjlTpedMHJOnpd/WV3OtqPhkcZShIqPfIS3Gwyqc7u76Glz3IUlviht8sEM+6T4XCBecvCuYGSnX8qgMyso2S3va2vJ99Qhb2K1jsuxr/vTJNdXZp0kCFT/qraPzf8pTArjeRxuP9/KbhNZppooLE7b2iP4+ZMUr3hkn7PG7uRuOjx8NbBFOY8rT9MZgFT5HZx2hbE3NkGrIc9lN7EUepCYSld+x9lGy+4xpAtpe+iKAbzJjatTr7n1J6vBh9UteRHvaASVastDrRD4/Z+PQgdYk/9SZ8b/jQ5CdEL0QLsfVmImEg3X+5Vtl5EMoNUgos81K/89L/CnJHNC+yIiH8Lb0bXAgP8Fm+hLUmbrtLJGvXN5meKAEzIaQR6AWygM3meIRo6TSNFyfr6Yb0BV696nsas6VrgPbunFeKdn33Axg5u6K+fZxIsdHw/U3nhlOh0rlQhmwQ12fvf1fBhkAvVqhTcU5nE1lxmUa+UchbzL38IeFX2juG/Bb5+lt2YochhRoVV8uPRWabMtTKQ2dIOehlmNUQZe2bfc0vNxk8s5dn7NdTVZKUciY63ckeSMMCD2YdLgKMJVmv5gu1bFyZxjQM0d4gP7kc/8x
 G62HeYjc
 7ZzHgcLKQ7rD3Lssk5NVSyZ/FvQaaZ5cLItBpG6PYBR9odynPivMBs++tQiTsJdtoXi+CCB/tc36iPdu7oBfek1gJeFbNueuhwjY/4j05g7MFAW/a+9sV7+8dTOugdLBnKxJ7qexfGJIqZhTF3RuE45u3SPoKBwsdjwlq0v4s5BuliHEHIiBa0zKBei4bi0CcUI2ccYHulg3Af6dLp6G3I8ibhFNO6vrVPCqR6ZIU/3Gzc+xcBoXjlSieoAwurTFS6ohE5Ph+ThKd9of44ApouFw3Ht5bgCqNHYqD6iJ2D49h8RA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

We would like to use similar logic of huge anonymous page or huge shmem
pages for THP COW: to categorize the strategies into three types: always,
never, madvise. If setting up to always, then we always do THP COW for
all the existing THPs. If setting up to never, then we never do THP COW.
If setting up to madvise, then we follow the setup we introduced in last
commit to decide whether we do COW for each individual vma.

We add TRANSPARENT_HUGEPAGE_COW_FLAG and
TRANSPARENT_HUGEPAGE_REQ_MADV_COW_FLAG that are very similar to
the TRANSPARENT_HUGEPAGE_FLAG and TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG
which are used to decide whether we do anonymous huge page fault when
it permits. And we add sysfs attribute thp_cow_attr as the interface
to choose from the three strategies we mentioned before.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 .../testing/sysfs-kernel-mm-transparent-hugepage   |  1 +
 Documentation/admin-guide/mm/transhuge.rst         | 27 +++++++++++++++
 include/linux/huge_mm.h                            |  2 ++
 mm/huge_memory.c                                   | 39 ++++++++++++++++++++++
 4 files changed, 69 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage b/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
index 7bfbb9cc2c11..43a1af13efe0 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
@@ -11,6 +11,7 @@ Description:
 			- khugepaged
 			- shmem_enabled
 			- use_zero_page
+			- thp_cow
 			- subdirectories of the form hugepages-<size>kB, where <size>
 			  is the page size of the hugepages supported by the kernel/CPU
 			  combination.
diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 0ef13c451ac8..0926651bad0d 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -226,6 +226,33 @@ to "always" or "madvise"), and it'll be automatically shutdown when
 all THP sizes are disabled (when both the per-size anon control and the
 top-level control are "never")
 
+Some workloads may want to do copy on write on the pmd size to acquire the
+tlb benifit when it tries to write on a shared anonymous pmd sized entry.
+They can do so by setting up the thp_cow control. The control is only enabled
+when the global THP controls are set to "always" or "madvise" for the
+specific memory region::
+
+::
+
+	echo always >/sys/kernel/mm/transparent_hugepage/thp_cow
+	echo madvise >/sys/kernel/mm/transparent_hugepage/thp_cow
+	echo never >/sys/kernel/mm/transparent_hugepage/thp_cow
+
+always
+	means that the writing process will always do copy on write on
+	the pmd size. If there is no pmd sized folio available, it will
+	fallback to the pte size.
+
+madvise
+	will do things like ``always`` but only for regions that have
+	used madvise(MADV_THP_COW).
+
+never
+	will not do copy on write on the pmd size no matter what setup
+	is done using madvise. When a process writes on a shared anonymous
+	pmd sized entry, it will just allocate a pte sized page and do copy
+	on write on the pte size.
+
 process THP controls
 --------------------
 
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a0ce8c0b81f5..2a62f0f92f68 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -57,6 +57,8 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
 	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
+	TRANSPARENT_HUGEPAGE_COW_FLAG,
+	TRANSPARENT_HUGEPAGE_REQ_MADV_COW_FLAG,
 };
 
 struct kobject;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1f0d0b780943..babca060feca 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -531,6 +531,44 @@ static ssize_t split_underused_thp_store(struct kobject *kobj,
 static struct kobj_attribute split_underused_thp_attr = __ATTR(
 	shrink_underused, 0644, split_underused_thp_show, split_underused_thp_store);
 
+static ssize_t thp_cow_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	const char *output;
+
+	if (test_bit(TRANSPARENT_HUGEPAGE_COW_FLAG, &transparent_hugepage_flags))
+		output = "[always] madvise never";
+	else if (test_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_COW_FLAG,
+			  &transparent_hugepage_flags))
+		output = "always [madvise] never";
+	else
+		output = "always madvise [never]";
+
+	return sysfs_emit(buf, "%s\n", output);
+}
+
+static ssize_t thp_cow_store(struct kobject *kobj,
+			     struct kobj_attribute *attr,
+			     const char *buf, size_t count)
+{
+	ssize_t ret = count;
+
+	if (sysfs_streq(buf, "always")) {
+		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_COW_FLAG, &transparent_hugepage_flags);
+		set_bit(TRANSPARENT_HUGEPAGE_COW_FLAG, &transparent_hugepage_flags);
+	} else if (sysfs_streq(buf, "madvise")) {
+		clear_bit(TRANSPARENT_HUGEPAGE_COW_FLAG, &transparent_hugepage_flags);
+		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_COW_FLAG, &transparent_hugepage_flags);
+	} else if (sysfs_streq(buf, "never")) {
+		clear_bit(TRANSPARENT_HUGEPAGE_COW_FLAG, &transparent_hugepage_flags);
+		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_COW_FLAG, &transparent_hugepage_flags);
+	} else
+		ret = -EINVAL;
+
+	return ret;
+}
+static struct kobj_attribute thp_cow_attr = __ATTR_RW(thp_cow);
+
 static struct attribute *hugepage_attr[] = {
 	&enabled_attr.attr,
 	&defrag_attr.attr,
@@ -540,6 +578,7 @@ static struct attribute *hugepage_attr[] = {
 	&shmem_enabled_attr.attr,
 #endif
 	&split_underused_thp_attr.attr,
+	&thp_cow_attr.attr,
 	NULL,
 };
 

-- 
2.52.0


