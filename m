Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8EBE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 10:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169F66B0088; Mon, 22 Dec 2025 05:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118B36B0089; Mon, 22 Dec 2025 05:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0236C6B008A; Mon, 22 Dec 2025 05:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E46836B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:20:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9479EB9CF0
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:20:11 +0000 (UTC)
X-FDA: 84246711822.10.FEE867D
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf12.hostedemail.com (Postfix) with ESMTP id B5E2B4000D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:20:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=YExNtzNp;
	spf=pass (imf12.hostedemail.com: domain of alok.rathore@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=alok.rathore@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766398809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFw/FFLjXpV1aTmhrvnbspHZO+4aypiGinSWzi3VTcs=;
	b=DLv/5Nuo/Fc7ohf+j8Ml/u99aOeh25JfNu6be/28kr1T0VpzC2nUG3j4Bx1GpQkapGwus1
	A5bXsxYs9ZB+Dd93ysGUxbJEiyu1Cqdd1lZZ1A3g/AtRixMGvsenrzeMLAKrkpSvBgZLBn
	Kwepa+DxtPoq980Jrk+suuD2bR036Ss=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=YExNtzNp;
	spf=pass (imf12.hostedemail.com: domain of alok.rathore@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=alok.rathore@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766398809; a=rsa-sha256;
	cv=none;
	b=CCXNWxuvfmJDwE8GwTqhF7whYL8NJ/QOhfa/jf0jWdY3OefHaBV7VIPEAbfjM/dO6qtE8T
	70IKrM0inHBixbuothmXULQc3LWuuxcz9qd50DvIIGZ/qdf4DYcd9sClxgXyG+QhjknCJO
	erhdRE0k4gJPlnoQEYbAnEQ5jMt8Vrc=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251222102003epoutp02d8a8b9eff3f11d5f89eb34b1b51cfe25~Dglp2gC2M1164811648epoutp02t;
	Mon, 22 Dec 2025 10:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251222102003epoutp02d8a8b9eff3f11d5f89eb34b1b51cfe25~Dglp2gC2M1164811648epoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1766398803;
	bh=iFw/FFLjXpV1aTmhrvnbspHZO+4aypiGinSWzi3VTcs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YExNtzNpgb/ZELsmpjZ4Hi6x3CSEc07tIGOAXLYh29W4XliI7lkrG/ux51Hn9w31P
	 ePoid/2NPDg0bVKtap3ZOsehSU+7T+ZUORs1hX3BM3/I7Uo888wJe738hgk5ruOtwE
	 pDL5lefA6mhdu0HzODT05t9Ps+WLfGlH61ZIIP1g=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251222102003epcas5p444e057d306fc02ab41075b4458f8710f~Dglpioc2e2320923209epcas5p4G;
	Mon, 22 Dec 2025 10:20:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dZYzl3pN5z6B9m5; Mon, 22 Dec
	2025 10:20:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251222101745epcas5p43ca3a6a59efe996cd62769e8d57bb81d~Dgjo6EToi2922429224epcas5p4k;
	Mon, 22 Dec 2025 10:17:45 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251222101734epsmtip2a9293df1d5ea6e02bbc8d3cc0a8321db~DgjfEfHIV1164911649epsmtip2a;
	Mon, 22 Dec 2025 10:17:34 +0000 (GMT)
Date: Mon, 22 Dec 2025 15:47:21 +0530
From: Alok Rathore <alok.rathore@samsung.com>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, shivankg@amd.com, alokrathore20@gmail.com,
	gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH v4 3/9] mm: Hot page tracking and promotion
Message-ID: <158453976.61766398803526.JavaMail.epsvc@epcpadp1new>
MIME-Version: 1.0
In-Reply-To: <20251206101423.5004-4-bharata@amd.com>
X-CMS-MailID: 20251222101745epcas5p43ca3a6a59efe996cd62769e8d57bb81d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_9fec5_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20251222101745epcas5p43ca3a6a59efe996cd62769e8d57bb81d
References: <20251206101423.5004-1-bharata@amd.com>
	<20251206101423.5004-4-bharata@amd.com>
	<CGME20251222101745epcas5p43ca3a6a59efe996cd62769e8d57bb81d@epcas5p4.samsung.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5E2B4000D
X-Stat-Signature: 54zzxfq1icgbpwxbpimkygwk6jwxaiph
X-Rspam-User: 
X-HE-Tag: 1766398807-548145
X-HE-Meta: U2FsdGVkX185ogvU9LuaHTPCBTLm4CWSdZQwa/L3tcrSZAKywYfpKnG1hqZCKoHhCFx6jsURp9kt6/qGAA6xpWiEYj10qG0foVNR5qKJT8PYa4vrgBiGdo7KXFKjE5mGEiVxxmgEX0HInPnHacLUmIAlrALAh/TOmNlMEbfIoYaeOG0rvkEqXkv/zljU24D5L5J/BePudqYGUGk7Z39o7DKzCOUfC0nXrTGT8qCCMUmFuO61tWxGZxY0vAKW2lwIgEqruZX84AW5cKSjTilT+KFZkt9z9Aug4RGfl15G0qLVzu5w3NzHQDiDi+zsfeanE/nb8M1vW+aOVeM1SluC1q+owGwdA6vUFhU9uPnaD+56kky64id9XrQTuscX2EJprhpsscKrR2V7AlMhYmRiGlpFwYO+VRc12d9zgtXjyVGK7j+VeDuzpsngQH3+EBT8Xm3arG1zZ1r9p4zwfFNvwYDHYc61VPucHqn8EXWUQHr4jV8qIS3qdkVmeBX3oZRmsHOvcwp8nKnC0kfd89e+HU6L1vLS8KIajEeag/nKUYSfoEpweir+2xo4Jc9KAS4AoL5kXiQznaNwRS19pfkYkIvwZkYCnGDEqBTNzMT8pDCBqIANvevqDJoWJ5Z9aYMyNu9Uci1IC+FXpSLwIVqYD9Ei8IO8s8haNcXX8+vhD8Ic48j7kjjstTKve+3SXe5FiQL+iuStixa+9/71oqYS9s9O844P7Ge3xsSCIuGv5M55FFXFt+LpRvKpPGXdY0tFyFsApk2oGesKd+Q7DnQvDccv/NEkl/jdProWX9M6bXvO+gZ2dVm2Hr8uP4oKwzyH+Ets0MEdrcFmNTWzq+tCcbNyHOM2qwuLBfKqwJitamQxuVyf7KSS0ESsLVXDtWx109Ltz/Dl2s/HZmdtQQQhOymGUAu08ehcCIphJutBJCII0F6zAwqzaK+bnp+X8OM4ihWE5Urcy0wT6sq1whC
 d2lGe08H
 oOeVvnAtXyJ43EKF0lpP6/Sf6MhG45u36pNx/zuhWs+qjk/x17BuGhhSjv+xTzcmNMfqxbgbE9jS+b9NTG93LOoIX5P6TwSUCN0W5QdNRbh12i1VXx0r+tJQQjrgZT+ZfJFWTWQjXIU9n7tb1MbSwkloPv4mIdguRjgwdRfEBJmIl7gPDF5Rh2DrhXpfVI4mptuvGgLDmVUAEy8U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_9fec5_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 06/12/25 03:44PM, Bharata B Rao wrote:
>This introduces a sub-system for collecting memory access
>information from different sources. It maintains the hotness
>information based on the access history and time of access.
>
>Additionally, it provides per-lowertier-node kernel threads
>(named kmigrated) that periodically promote the pages that
>are eligible for promotion.
>
>Sub-systems that generate hot page access info can report that
>using this API:
>
>int pghot_record_access(unsigned long pfn, int nid, int src,
>                        unsigned long time)
>
>@pfn: The PFN of the memory accessed
>@nid: The accessing NUMA node ID
>@src: The temperature source (sub-system) that generated the
>      access info
>@time: The access time in jiffies
>
>Some temperature sources may not provide the nid from which
>the page was accessed. This is true for sources that use
>page table scanning for PTE Accessed bit. For such sources,
>the default toptier node to which such pages should be promoted
>is hard coded.
>
>The hotness information is stored for every page of lower
>tier memory in an unsigned long variable that is part of
>mem_section data structure.
>
>kmigrated is a per-lowertier-node kernel thread that migrates
>the folios marked for migration in batches. Each kmigrated
>thread walks the PFN range spanning its node and checks
>for potential migration candidates.
>
>A bunch of tunables for enabling different hotness sources,
>setting target_nid, frequency threshold are provided in debugfs.
>
>Signed-off-by: Bharata B Rao <bharata@amd.com>

<snip>

>+++ b/include/linux/pghot.h
>@@ -0,0 +1,71 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+#ifndef _LINUX_PGHOT_H
>+#define _LINUX_PGHOT_H
>+
>+/* Page hotness temperature sources */
>+enum pghot_src {
>+	PGHOT_HW_HINTS,
>+	PGHOT_PGTABLE_SCAN,
>+	PGHOT_HINT_FAULT,
>+};
>+
>+#ifdef CONFIG_PGHOT
>+/*
>+ * Bit positions to enable individual sources in pghot/records_enabled
>+ * of debugfs.
>+ */
>+enum pghot_src_enabed {
>+	PGHOT_HWHINTS_BIT	= 0,
>+	PGHOT_PGTSCAN_BIT,
>+	PGHOT_HINTFAULT_BIT,
>+	PGHOT_MAX_BIT
>+};
>+
>+#define PGHOT_HWHINTS_ENABLED	BIT(PGHOT_HWHINTS_BIT)
>+#define PGHOT_PGTSCAN_ENABLED	BIT(PGHOT_PGTSCAN_BIT)
>+#define PGHOT_HINTFAULT_ENABLED	BIT(PGHOT_HINTFAULT_BIT)
>+#define PGHOT_SRC_ENABLED_MASK	GENMASK(PGHOT_MAX_BIT - 1, 0)
>+
>+#define PGHOT_DEFAULT_FREQ_WINDOW	(5 * MSEC_PER_SEC)
>+#define PGHOT_DEFAULT_FREQ_THRESHOLD	2
>+
>+#define KMIGRATED_DEFAULT_SLEEP_MS	100
>+#define KMIGRATED_DEFAULT_BATCH_NR	512
>+
>+#define PGHOT_DEFAULT_NODE	0
>+
>+/*
>+ * Bits 0-31 are used to store nid, frequency and time.
>+ * Bits 32-62 are unused now.
>+ * Bit 63 is used to indicate the page is ready for migration.
>+ */
>+#define PGHOT_MIGRATE_READY	63
>+
>+#define PGHOT_NID_WIDTH		10
>+#define PGHOT_FREQ_WIDTH	3
>+/* time is stored in 19 bits which can represent up to 8.73s with HZ=1000 */

If we consider HZ = 1000 then using 19 bit time is coming 8.73 mins. I think by mistake you commented as 8.73 secs.

Suggetion:
If we are targeting to promote page in ~8 secs then 13 bits would be enough, that way we can handle hotness using 32 bits per pfn insead of 64 bits.

#define PGHOT_MIGRATE_READY	31
#define PGHOT_NID_WIDTH		10
#define PGHOT_FREQ_WIDTH	3
/* time is stored in 13 bits which can represent up to 8.19s with HZ=1000 */
#define PGHOT_TIME_WIDTH	13

>+#define PGHOT_TIME_WIDTH	19
>+
>+#define PGHOT_NID_SHIFT		0
>+#define PGHOT_FREQ_SHIFT	(PGHOT_NID_SHIFT + PGHOT_NID_WIDTH)
>+#define PGHOT_TIME_SHIFT	(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
>+
>+#define PGHOT_NID_MASK		((1UL << PGHOT_NID_SHIFT) - 1)
>+#define PGHOT_FREQ_MASK		((1UL << PGHOT_FREQ_SHIFT) - 1)
>+#define PGHOT_TIME_MASK		((1UL << PGHOT_TIME_SHIFT) - 1)

Mask generation of freq, nid and time seems not correct. It should be
  
#define PGHOT_NID_MASK         ((1UL << PGHOT_NID_WIDTH) - 1)
#define PGHOT_FREQ_MASK        ((1UL << PGHOT_FREQ_WIDTH) - 1)
#define PGHOT_TIME_MASK        ((1UL << PGHOT_TIME_WIDTH) - 1)

Can you please have a look?


Regards,
Alok Rathore

------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_9fec5_
Content-Type: text/plain; charset="utf-8"


------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_9fec5_--


