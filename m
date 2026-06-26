Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 256D3CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE416B00B1; Fri, 26 Jun 2026 06:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4DA6B00B2; Fri, 26 Jun 2026 06:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD506B00B6; Fri, 26 Jun 2026 06:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9585C6B00B1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:02:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A9A51C6189
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:02:03 +0000 (UTC)
X-FDA: 84921622926.09.098DA97
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 19BCA40009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:02:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=u7SCg5wY;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782468121;
	b=TEZC7SzlGkVRJCFv8xkaG77xukNxlnnB3u6/QCqck0W7C7wM5QdFodQY7oQfjAVHl1m2iK
	6azq0RAZtKJgoS/v0+z7SWu0rcw/btDIx3BXMFipjg/1K3VKM1ks4/z/SNYvoHnxspNu9D
	RElLIL0oky1EQe1N22MXeLfRFmykFP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782468121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+mUD/LNP8qDYzVuVSQPXOxPIzjVPEQiYJsBHPRLl0Q=;
	b=nuQv5an4KAii8vQxD6nPwRd/pk6LA5JvhtDiAsRRMnkjdlZL4wTO6Y+BHe/FaZ+Ekhs06m
	CwoUCXF8sKdmoTvLApBHruXix5Parqb+NK7yVpK6myeeWZFEI1nw9eYSHd8KjdufGReKpe
	SJXQiW1E2ScLxIeoemL0LuvcG3ZmqvQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=u7SCg5wY;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-91562bf6c12so95711885a.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782468120; x=1783072920; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j+mUD/LNP8qDYzVuVSQPXOxPIzjVPEQiYJsBHPRLl0Q=;
        b=u7SCg5wYuSwv2VrybHFQwAYqC5JgZqiXNRHKU+7D3CS655XnYx4Sk8BZZA8cNbnQUQ
         mFOYKFj9OgQlEMPLd6vnEDqMp2Oyb++nBisrr+SheeDy3SXm/P82r2uaaEf05MWEgzZW
         8x83G/yeIp99r3IXmFPvjvt9ohcBACZKKFRmnwW6/0vXL2FEb+8UUX4UOliviItBrV6A
         efBSRR8SIbkvU2NiS0NIF6eFnEDZyuquzS39KFXKSAhQoDhc1ujwudanBOdMUeW+iiSG
         qK1dEL2pi4u1WvUGv4HW5YlhgfgHH00IC7I+FHQUr3AOl9ufHWIBpKkjtUPsGCR23wlC
         qlPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782468120; x=1783072920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j+mUD/LNP8qDYzVuVSQPXOxPIzjVPEQiYJsBHPRLl0Q=;
        b=X3hrhl/gSSmNLeMZA6biCL3O7AuzN/vS9JuRF3LxRb4Er9I3iTVsJ5AHNiRVOTbndJ
         xaXrkub1F/pnxd50YIsnWzwj+1S0MlhehOu/unoXCVGQi0facz1VnFNYuzrfVLFe7pwk
         3SHBPuWrrIz5+lT3jRfU3rco1n0IaJVzLzfnT3mDnweaJGm4R4ucBDBWX2tunv8GLCIB
         KqarHI4CdHNEpK12xzpGGOW+KMGk2uzwnj0ppGMTuNu/MkHqY2gpdDfnafeqdzo6p6iS
         LOap/nP2ShMgaJPm1c3IV2gZ2MnUm1WUAdbQcnSJgGtpcYXr+BeOff6+pzfonRaXZs9i
         1ZfQ==
X-Forwarded-Encrypted: i=1; AFNElJ8UtU5atXHdjniHiuP+dnSu3jCy7hJcscrFVzqS/XTBjYwsJ9UkfIv7V/QJbwMVa2arSod8TBkJ9A==@kvack.org
X-Gm-Message-State: AOJu0Yzs6xGZrffeexffhnF5SrQfg/rhMMrIKqk9i3ypb6ozhaxppbsu
	41qnPkbkrQB6CLMBxAGAmKXJjEhrwm5u2EsvFyANOLSprYfXgff4wKuGVWDTQJQddcc=
X-Gm-Gg: AfdE7cm0VESEbuv3u6CAvv2gaFigOoWZtppu5PgQJZxAA4g2K6i7xYnynAPnf2PrsQ5
	nBOgFYqxTp5EOUkVrEPAVQyf3STkv68fuxJH7yjokccbNTN3dzF0N6hJ8bp1yG+Cb9w5yLXDXbQ
	Mbb/R8Tc8TGDlLtWLb/iz4ToTWg9G1uI40tzH2OVoZxnpzPiVZZcCghV1gAUbUQ5Dwy9xw4VFts
	t76kIKMJwL53H2Okw747Rkk4YEvux2D9zXP545YrlGtRwRRqfZxlJDoKAi8RLEfxGyMV12CBo8u
	ImXiUWCnk9E+BxGuGsEjcez7v8DYdAkIzTcAccNFnqY3RuAbyZ5cAaIFjtTuE4Wd0cRKG+RDvug
	Gkmssw6uFU7leG5GmcuU8hfVLc/YPSVA9bJJL6BfGfgqKf9WuIMMOXXjC1AO0jqsO+3Ke87hyez
	tPXtcKgRtJX3THL6Tudlyu5Q==
X-Received: by 2002:a05:620a:4714:b0:925:dda5:c05e with SMTP id af79cd13be357-9293c5fcea8mr1018783985a.32.1782468120008;
        Fri, 26 Jun 2026 03:02:00 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-926000c0c0csm1111876785a.25.2026.06.26.03.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 03:01:59 -0700 (PDT)
Date: Fri, 26 Jun 2026 06:01:55 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
	dev.jain@arm.com, kasong@tencent.com, lance.yang@linux.dev,
	liam@infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, npache@redhat.com,
	qi.zheng@linux.dev, ryan.roberts@arm.com, shakeel.butt@linux.dev,
	weixugc@google.com, yuanchu@google.com, zhaonanzhe@xiaomi.com,
	ziy@nvidia.com, Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
Message-ID: <aj5OEyV5WsVkwUWt@cmpxchg.org>
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org>
 <4aa8350e-712f-4380-b3bf-2ff06cf2a35d@kernel.org>
 <CAGsJ_4xR0Ge707s8JAfd5Fw10+U+25_nuBGuVayx9qnxR+NnGQ@mail.gmail.com>
 <c29f90c6-2075-43e8-8f0d-0d6718a0f124@kernel.org>
 <aj0u12N_GzGtQT6K@cmpxchg.org>
 <3af41c23-2365-4ac1-b1b9-076b6ef7ae9e@kernel.org>
 <CAGsJ_4wXTpTS4RF=qPs0wvF3UosrOQ7s9-zdXpx4OKGEysf=VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4wXTpTS4RF=qPs0wvF3UosrOQ7s9-zdXpx4OKGEysf=VA@mail.gmail.com>
X-Stat-Signature: ubabub83q9e9s738wrrnirkosfoyt5g1
X-Rspamd-Queue-Id: 19BCA40009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782468120-636152
X-HE-Meta: U2FsdGVkX1+ZbwKr+RYsMLrYQ9hCIWmLuXD1XgT8smNooRz0MBnDpzFnRZT2Z1ppCdFFvs74Cb7iSMnPt+2dmC58Cb5qge6qswYZxo3EoRDymhoYy3dN5YhPHpJdDd2IXJegaAZM5CZTyaro/0dXX5GBphjzNxp5f0JtLD6LZKAKySKGWWT5PrIrA2SAuMUElNS2ioXD9fBdig0eesbohKuLEEf9x/vcVu1JemxCn/MsOdFAZYonY4Cw4NppLXDTYeF99NzniWNjGv7T7B0LtdFr7P8FzCm32q5OPFhRlas9C5tFJDMMX0K3uG95AVh6jZkjJ9pBJ/mcXvfjsoc6KVvTCBmCGeLm3D+2S7TXjoPiR7QEED01l0JN37PsgNGDIrXv4b5YxQh4hqnjVhMhWdqMj8vrsr6ULBw5sUtIqbH+zgcROOIiIBNdup7i8XoZbFLNm2B54rcgqjgRre7r5eRyp0Ith2lRkKk+aakIvw28jQPfGOoL+ov5mLCets2vfd39swgbljjXoEaIPg3b3HRhoSv6GE9QYBZpsQptZkk0DUiSlXPMCOIow4b9ekc3jKMDw5HKtrhYQ05VvEYLy2yUaZBKiX9qKm5RN6lxUPTnh2jHD8VmU4m8J9hFrgm8K02TRiJvMuKaV/jDZQpEQexP/2lbxejUGLNFpSK0avMdBHAjDJjAJUBATKcSsD5sJNzAOFjv5F/5cX2ZJYQBtY0bhpPZSCdGF9VFW2Ln+xB/sPguQ1HAdICFpsU1U1QRcH9i3sMC9uGM0ZfRu0hVSA8Ux7i6gljKsNESgG+vMrwnFN+ZIDs8Lj0vFCkbivES0KBqyKmdQLe/LVwky7vlx76l+epXfeyJ+plVBrM3ddHzvY1ZeuL1DEXCD/+fWVegC5oyndOS9VFYyyr3ghz2shcHPySB9GHM+zBjqpziLJ8azE4nmCL+wAilQ8G1havem5paS35NNA3sK6inHHa
 Sc+TL5YO
 3ceUxC4RnYJvpQTYpnQLxu5UcpZXyauTJz4mkEQLzuCbBJfoSGguv6BvpEnmd7D/FJYBXMdfyeI4yexPprmsq4ylfyyLEoaj0/FHJct7ZaX1p7IlFMjaOWkX8joQbXFBf1r2JgM9v7LYxAcEAdaweJfd1nXjt1fi8AO9VMUk67zKkeO4GkkOz4hZTT+E95kto9vYbbXaX62l7iyUwfW2E7G5r0lLvOpLligVWDGm66vEo77sCz7OJVBZA8s7IZvrcfg6eFqgT0OFJnl4KO/NNUbr8s3nZz4zEUxv2zhGy1B5SgctrCKhbNdVl/8V7flAs0W04stECDIWJwXN8pxp900/Jeds0CTlauSc79grztXe2oOeMOeFKsxRwVDAtJLyXuLier06Hi1kpIWkDut2Eqck4gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 02:15:58PM +0800, Barry Song wrote:
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5578,7 +5578,7 @@ int __init mem_cgroup_init(void)
>   *
>   * Returns 0 on success, -ENOMEM on failure.
>   */
> -int __mem_cgroup_try_charge_swap(struct folio *folio)
> +int __mem_cgroup_try_charge_swap(struct folio *folio, long *left_space)
>  {
>         unsigned int nr_pages = folio_nr_pages(folio);
>         struct swap_cluster_info *ci;
> @@ -5611,6 +5611,10 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>                 memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>                 mem_cgroup_private_id_put(memcg, nr_pages);
> +               if (folio_test_large(folio))
> +                       *left_space = mem_cgroup_get_nr_swap_pages(memcg);

It's a bit awkward to walk up the whole hierarchy again when we
already have the counter that failed. Please do something like this
(not tested!), then use page_counter_margin() against @counter:

---

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc87..07b7cb12249c 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -68,6 +68,7 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 	return atomic_long_read(&counter->usage);
 }
 
+long page_counter_margin(struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 772bac21d155..02472008144f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5275,12 +5275,9 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
-	if (mem_cgroup_disabled() || do_memsw_account())
-		return nr_swap_pages;
-	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
-		nr_swap_pages = min_t(long, nr_swap_pages,
-				      READ_ONCE(memcg->swap.max) -
-				      page_counter_read(&memcg->swap));
+	if (!mem_cgroup_disabled() && !do_memsw_account())
+		nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
+
 	return nr_swap_pages;
 }
 
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..a0874f853ae0 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -46,6 +46,22 @@ static void propagate_protected_usage(struct page_counter *c,
 	}
 }
 
+/**
+ * page_counter_margin - remaining usable space within hierarchical limits
+ * @counter: counter
+ */
+long page_counter_margin(struct page_counter *counter)
+{
+	long margin = PAGE_COUNTER_MAX;
+
+	do {
+		long m = READ_ONCE(counter->max) - page_counter_read(counter);
+		margin = min(margin, m);
+	} while ((counter = counter->parent));
+
+	return margin;
+}
+
 /**
  * page_counter_cancel - take pages out of the local counter
  * @counter: counter


