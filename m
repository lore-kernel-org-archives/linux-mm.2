Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D576A606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=t1s7ZJQW
Received: by kanga.kvack.org (Postfix)
	id 9B3BC6B05CF; Sat, 14 Nov 2026 02:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933E66B05D1; Sat, 14 Nov 2026 02:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762B36B05D2; Sat, 14 Nov 2026 02:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 537ED6B05CF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF5271401BC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:49 +0000 (UTC)
X-FDA: 85432852218.07.DD091E6
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id 130A920005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=t1s7ZJQW;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640248;
	b=1IeVld3maKFPuJutIXr1pMLfd+DuGFIZNh6ANfH3I31vKIj8jCd/Ylc17LK48J/DqSxRMk
	3nvLS6Aj+3VCesEOfbhKM77WF5nhPC9yBLBKoLWVVFVaniZSHQSN7G/+3h66xW4V0Q5kLj
	6SrxKcwA5GuIQlKRk5s4LJpjd+tqI1U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=t1s7ZJQW;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2WARPg/nf2WwBmWaZN6JnUP4gbZP7FMkF0eRnIkIgZ8=;
	b=IixB2BfRFP6d7dtfDn6cnxtwBnia7Ii1887E8Flt4/9NUyqGJSezyOHF6E+2b1bGOkq/eL
	WA89kROX/j/nQzPN85xq+GOEumcjiee+e9SBYl/ziaJdYRkaUFpbp7hx5jmxKaSCfukevF
	omh1GA/q7IHzaivhIr14ud+Ga4mvaIw=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-94959217274so235902385a.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640247; x=1795245047; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2WARPg/nf2WwBmWaZN6JnUP4gbZP7FMkF0eRnIkIgZ8=;
        b=t1s7ZJQWWXug5e3l5KJ4Wlohqk6+aviYyC1mBYebyOj1348okJFf4LTMV4Evg2FpI9
         +KFDFJa4KicjlSRo8iFjlgEUWUhiSgZpisSeYncPLuwAcEj6C86vfIMPbfgjL3D6Xx/S
         V+YBOflJvL6h5+sTqakfD/MXZiEo8Z3vt9Jp/y3SBMs0yi33JkLrhKaQaN/uhEzi/0rn
         jBY0DekmBDTcjfQreUiZsTa4AD0F/layKvEVAEuaI1nufsdQU4Q1k3fjDtl0xTyJ9kqZ
         qtMqp5vTs8S7I6NpqQ6AZqUIsB5jatj/p4EUKI4htP/QBR6bSSh5ad3xhnkVCy4EeIML
         ofFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640247; x=1795245047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2WARPg/nf2WwBmWaZN6JnUP4gbZP7FMkF0eRnIkIgZ8=;
        b=asPWpn55d2evqNtFRQZQx/81TRG8ypf7neNwzdEeP+tFPD5srJHc71IxhCKKtVHlNc
         Zi50YaV/tXE2Q4it4m12MremV8ILSsQw92jLspmbghnG6ZsgNDM905xary9Y3jX3owRW
         Bwei0gZIFP7vmQI4h6AR7Y6/EAKytkCe5GEGMDNawxkh5+2VIqpwPRBQg7ooh80MUcfL
         SNE6qQWpmqapM4PurP7KqwU0TUj+gHXVQC7VZeA+XV3TV9OhkBn/OJp2llUI0LKc3ZLK
         Lit4I5lpnRaQ1dFRTqFZzXxFraWIvS/pnrpMSRVQAr/TXDWgHdKa89MJsfieMsLVzua9
         vyww==
X-Gm-Message-State: APuU4Z8ZaXxfYdqdG9yZk8tGxnJ3EFRSzTBhWQVEuG4+anQt64vuyfLM
	WWQipM/ysc+63dI08wrFANObLcs66ucCeKKOCR2IXa3rnp/c7KRRHsjxUW21ZUzQharcAlHS/0k
	X//Al
X-Gm-Gg: AYBFou3+PG5fqsgxb3YvCn5UQ5lwoEXqBLe4zm8cd3noL0KzxeW28DGXVtdnYGDKdQ0
	Ncv6C84/9A/qKa26MKXMqtCFhqBJyI0wz+lNKArA9VyWv1fueZQQu/K/OABO37unvICgKNbT6HF
	CkzfOLIMMIgVpyzUFBxtdcGXHqDNkxh2ZkEgevsDfra5iNFQ0vTN/y83wIExH3J3F7+G4GaExW1
	IljrMO5j17HDxeR1bjwQbmd5T1UJv1bbRcMvIEEELIpL21YCwEP/zmrKWQw96xvFIZVUuh4FJcI
	YZbYtBI1lm/ehvQo8BWOocLPv4m7LdYV5mkjVEvUDXWT+c9CDxqcwEWipcV2TyQ8Dnp+dt5cI3C
	AZBKRJxs2jMPV10YorYHkkIS/tnx2haj52ZzVFUyoPfeShncz7mu25j/qWydjUVagj2gXQADtdk
	qRvt/r8BrpIlmdJ+V7SNBaFiM+hkJtdoEacANEMKtcKdAuxVa4dwBXtRo+XyczhNcDkizSl9oWN
	F3uO+zCg6J6JYaAA01dSZxpJgqRP3thHErinI6+OoegacEd1JVRChyWrjFBudGuDFeQJjsbJ1IU
	pEI+CuYfzsB2laucQU7QGOLRGgftb3+jtUyg4knqymR6zxVQWDwlm6VSbgrTLVRHStui/OwbvGi
	thGwhN/6ttKO5OXY=
X-Received: by 2002:a05:620a:801c:b0:93e:c12c:fbb7 with SMTP id af79cd13be357-9494bc76c5amr813866785a.68.1794640246800;
        Fri, 13 Nov 2026 23:10:46 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:46 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 20/22] PM: hibernate: size the image from common memory
Date: Sat, 14 Nov 2026 02:09:57 -0500
Message-ID: <20261114070959.3490008-21-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rfnny16jp64my86j8ph1ezippgrk9asr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 130A920005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794640247-349161
X-HE-Meta: U2FsdGVkX19OfAa9TzNLE4ztX+uOgmI1n7C68Jvo+y4fAMyxQ0Iy5eWavAjqiqAzoLQN3/+rE/af97FIk6xgcVVoGMe7h9LOv64CZ2neYrWgwyR696IbXM1IHptsZ9MKzBJ9BzakNeyjYDB+KqTe9m0taNouV+SzJ05GlucbUJQjWuzf+8CMZ7NR6I86Zn/DjyAL0+lY8D9GqeKDOu1TM2LRsLKIq8vKTM+43ntwyo10Col1aLFhYSKAp7mC6YmbUmzSPtpq86TKmXHptWK6yoGdcS8nwDtopAkDW7vKb1oEAkmSWJg4yl70GwUYrwCNcComvXWSgG3pvgz7ZUOacEjCQKmwsdc3gCY2SPDtyfMoJqsnD+lDcWIN9v0cjVLcTEG+RZbuKlgAae37LfABOsSoI4QYMiw10WveVrdbdq3P4JlzFt8CAB7VANK+/3VD68bjLzMblqLEbgHD91m3qYV9u1b/VwoIzFvYKh+aKdTDDaBv+jOSAhQkFLxQwIehLKkCnAe2YG8yA8Oq9KxM66t9xnUwNaOzGnygKXNk8HWwKkfHDIQ+XLDPcEbDVoOwvSmsyFOcbrvfurhMfX4v8Tubwl/wGZMyPlLyvFpR68fapYnuVrPcOEZSvn735TK+FB2aJC7Wk8D0wb5d4GQGL2xNCcC/jY7rzZZ722u1J/riBfCmbZ9D0JfxX6kFbWkZF0WSgjZsQ5NuPc/zrJ39raMMnKCLjkf23zci2Lmt8EQj7zt6VWEVQPA3pvhtQ6wVbdgPvBWrwYbgEnzU7qLOKW+pJWh+smbMtukQcOo4B5+/XmSgTKKuYc4Bva8+rsDA0XQPr7OMJZ0Urhms9Eb9JZCtDzVmPrTKh8XISF4Kwz5WY1WblQTr9Ne+IvJF32WShR2NUIqnXRunRCFXW/yc2tt7fNTy3gTehq04M+257hDlmhTRnZ6rruA2ttKzL9AOEB/WgOYyXg5oCldSc/J
 RRvJ7UEY
 5tyIDxPB8ykw6OUQGqXTr5tTZZgDzVoBcGWXVW6BqUCGSbmVSc9ULj8PF4iTorVWF27B0PKtT++A+i+u7eczi8bRr8qMMuN6x31fGbvKGqf/xO2d9VEH4Fu83wFlE0OkoXDPXyOy/nSo74AzEjpPUZ9V/NPJt3kTNfi3jLUoptUUyALembc3L6yr/cntY93vmbab11hOdmP6fMEh7jDcZRLg8mJsREOv5pJyJniPuQFI6mFPrf9sEd5ql4A2e+MyfhYNv4gqzfp6ivYYCq5soFynNu1syAb14lD6QSiLM62wXhP1wwk5/YnmCs9uZR/yHoYQOrR45HZ2gAokz7tYc6qzf1jPcMAZY7R5jQ3XdvxnQ09jQAp9RVrfiR0gzGthdiykW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hibernate_preallocate_memory() and enough_free_mem() count the free
pages of every populated zone as room for the hibernation image, but
the pages used to store the image can only come from common memory.

Count free pages only in zones on N_MEMORY_COMMON nodes.

The image metadata estimate is a separate sum.  The bitmaps track the
page frames, and every zone's frames are tracked (regardless of node),
so that sum still needs to be calculated for all populated zones.

Every node with memory is common, so hibernation is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/power/snapshot.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d5dba0e50b2eb..8aeb086a3fd3d 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1866,8 +1866,10 @@ int hibernate_preallocate_memory(void)
 	saveable += save_highmem;
 	highmem = save_highmem;
 	size = 0;
-	for_each_populated_zone(zone) {
+	for_each_populated_zone(zone)
 		size += snapshot_additional_pages(zone);
+	/* Image pages come from ordinary allocations. */
+	for_each_populated_zone_state(zone, N_MEMORY_COMMON) {
 		if (is_highmem(zone))
 			highmem += zone_page_state(zone, NR_FREE_PAGES);
 		else
@@ -2011,9 +2013,10 @@ static int enough_free_mem(unsigned int nr_pages, unsigned int nr_highmem)
 	struct zone *zone;
 	unsigned int free = alloc_normal;
 
-	for_each_populated_zone(zone)
+	for_each_populated_zone_state(zone, N_MEMORY_COMMON) {
 		if (!is_highmem(zone))
 			free += zone_page_state(zone, NR_FREE_PAGES);
+	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
 	pr_debug("Normal pages needed: %u + %u, available pages: %u\n",
-- 
2.53.1-Meta


