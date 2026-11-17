Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECCD2606A893
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=wcMqPt0Q
Received: by kanga.kvack.org (Postfix)
	id CEF1A6B00EF; Tue, 17 Nov 2026 04:21:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F816B05B0; Tue, 17 Nov 2026 04:21:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E926B05B1; Tue, 17 Nov 2026 04:21:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85FD16B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:21:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A3B3803BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:21:35 +0000 (UTC)
X-FDA: 85444068150.13.AB1D8D6
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf10.hostedemail.com (Postfix) with ESMTP id 831F8C000E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:21:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wcMqPt0Q;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794907293;
	b=He2V1frf95Pitt4ApPh6hhERPKDDZt6ErhvUXnRG1dBAqXGrK2y6kldBJRjuQTH8+JmZDr
	PEqWIH44z+q3p81NNhQI9jp87k6/Gatq5+3eaF3Vr7/2xUmckUkjk8bxfFUeik5Aa3YCRy
	YgUy6kdKCwkODCBv3K+fd8g44OqQP6Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=wcMqPt0Q;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794907293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NelY0F3SQaoHpZaa48RfVKojhT0mMWhbxVhRpg0tfCU=;
	b=4CB5mnFb23fJh3jjmkn9AMeFi7bse/0jnfuVJKtXxYlsVUr8A6iC9qAmevTNysJA9cO5kf
	rK4QM2gA/DXXkUdBE/kkoO4cFm9NDgbbcSQ5FSWnMD5/6/cYRGNlWPtnACcp/Cou8P++y0
	w49k6vUpbAYWb2XhfJW3L9KmmkLiSW4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NelY0F3SQaoHpZaa48RfVKojhT0mMWhbxVhRpg0tfCU=;
	b=wcMqPt0QhszyRzva4g7wZmx964J1LB82GE/yeVL9LyN+DZ3q7eziWeveRgCFaAaPBdYeCBQiX
	9FaWQ1vHk5u3RT5eFgJLnfpdsyXTk+FiUTHQg8fFnGbdIKoRqYmksHh6O0iFhakPsKKPB35Ps5S
	cmyonBF0d5EmEbjEKCpSmik=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jTK2j3ctZz12LD4;
	Tue, 17 Nov 2026 17:20:29 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 503DB203AB;
	Tue, 17 Nov 2026 17:21:22 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 17:21:18 +0800
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
To: Breno Leitao <leitao@debian.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<driver-core@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<rmikey@meta.com>, <riel@surriel.com>, <harry@kernel.org>,
	<kernel-team@meta.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
	<osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, <kas@kernel.org>,
	<kexec@lists.infradead.org>, Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	<shakeel.butt@linux.dev>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <869891e5-3f4f-e404-1068-53e6ff169805@huawei.com>
Date: Tue, 17 Nov 2026 17:21:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 831F8C000E
X-Stat-Signature: ki357jijc18if9zrfanmujxr7jh199dn
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794907290-636471
X-HE-Meta: U2FsdGVkX1/G3sxRFc6z2W120R/Z4Mu3bEK4C9FEFg6QS22dq0H/Fx6DSLEeiHzVQZyBXBtEkTk9GOsCPbFo9/RRddMLKh8IHcK0RO9AGbv1t2E655nc+rSoa+X9fqhB4Ea6fkdN+OXZFjz76/qfhrmXlx20/HGEV8EhrZGCEH7jVf5/pgIPQpqFwku8Wuyiq2QLoF/hadrwdG6tUxurT1omguYL5lua6cDZP7XwEzaMKKbxRAsQcZmvhy1WgdadaUsiI/xE22wF4t7HrymZoCYWxl/5Zp/aZsUNw4+RNyl5qCGIkrcNDSuL4aGWiak17ssgYjNzDcvvL3q6AjnSp8iDl0T8DXd0iIUSXK+k5C69dlzho/5is1s+mOXPgmc3sr9iBJIb22NFuBTn5Qpq9Y0CiPUSWghiD/PNp0g+FWloybyOq5ylrSUiFqrF1YI87fSUmy69jgN3VrNTwBv3XoFsVTU06OYKaT1Qd1TGZPs9AnFnNS5Lkz71eHMON4/avovF/3LKOlw1KW3YhL4wjVbS3+tu0Tx54fq346qB8vhnx9ZpeI23Mb6vWZdUBUCL9kYEba3f0gtFU3NnV11GPOmL2tI2r+e22/riWRndFC2wxs/uuthNLhXA3P+htsVxQ9UUeWTTXWMNsfg/H+NmjvPdMRocIYX0MZW2D2lz5DF5t3527SY6iviHduM4fP/1TOsDmaxowbXho0uOWvfFN2J191IrSFENCYd6bM4idAPX4jGDIzsqFyqz+bgFq7hQHakc0afG5GBb83WenvV7dctKntEgEZHKF+cV60Kd+AwBwrccMmGmiH9876bGlL9WEsB/VXp713V0Re4GMAZ00jFTbcICybzXdTnNoKykiHlOvYY4xcmobMfR3MYGdgg8aPgWk+HnMZhb864hXxfgVHiNNxxpqehJWeb4qywQbzGL1RNZHdOcaFsbm938lJ0iszgno/TyfesxK8pXvno
 UX9nfYE1
 p16YeIya50DLfWjTnFq3hdHQBFxlv/c64fcNbRhJgZJHKhXqb1VzQ/MZowSleYOZ8sW5T7onyqFkSC0KEHzGBvCLNfVM657erqtXU7wgiGB5ACyaBYJpSYagHMMYF1jD8p80DPteyvgjPE+PW2Kk0t2nheeYXdbD8JV00RhtHW9BD+kqB+Ka8MtF+y00biVOO1QjDujTke0LUj8wlKUs4Ol3xmDmyjrpYPjF8lEkfv3kxSP95jYQo6IQ4E+VzexLnGUpSnw3QlIqqTu3m0qOmFvr40BqUO32q34NVyuaVNcMnD/e/RbaXnTUn6eNY82nJrnsTm5MLLXQ1Sic7NI9unYr/LzD5hHhyl9L4CApIBf6xiY2bTeaFU9aT57EdICMzKbnNJYhDwxz4+uzbcbn6yvXVUyDZwsCdVPcZfaO2M+lMlwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/10/16 20:15, Breno Leitao wrote:
> A kernel that kexecs inherits the frames its predecessor found
> hardware-poisoned. It has to carry them as PG_hwpoison in its own memmap,
> so that everything that already understands the flag covers them,
> including the kexec segment placement check.
> 
> Add a helper that sets the flag and counts the frame in
> num_poisoned_pages. It runs while the memmap is initialised, before
> memory_dev_init() has run. memblk_nr_poison_inc() divides by
> sections_per_block, which memory_dev_init() sets, so the helper
> increments num_poisoned_pages itself instead of calling
> num_poisoned_pages_inc().
> 
> An inherited frame is a hardware failure like any other, so the helper
> sets hw_memory_failure. Without it, unpoison_memory() accepts the frame,
> clears the flag and drops the last reference, which frees a frame that
> is still bad.
> 
> The helper also counts the frame as managed, as a frame that fails at
> run time stays counted. Memory offlining subtracts every frame of the
> block that is not PageOffline, so a frame that was never counted leaves
> the managed page count too low after an offline.
> 
> The per-node memory failure statistics are not updated. This kernel
> handled no failure, it only inherited one.
> 

Thanks for your patches. :) Some questions below.

> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/internal.h       | 5 +++++
>  mm/memory-failure.c | 8 ++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index da14c56fb24e11..4bd3bbce86e0ad 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1169,6 +1169,7 @@ void SetPageHWPoisonTakenOff(struct page *page);
>  void ClearPageHWPoisonTakenOff(struct page *page);
>  bool take_page_off_buddy(struct page *page);
>  bool put_page_back_buddy(struct page *page);
> +void __init hwpoison_boot_page(struct page *page);
>  struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
>  void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
>  		     struct vm_area_struct *vma, struct list_head *to_kill,
> @@ -1181,6 +1182,10 @@ static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, b
>  {
>  	return -EBUSY;
>  }
> +
> +static inline void hwpoison_boot_page(struct page *page)
> +{
> +}
>  #endif
>  
>  extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a2ca8df501caee..d0d6b184ee469f 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -96,6 +96,14 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
>  		memblk_nr_poison_sub(pfn, i);
>  }
>  
> +void __init hwpoison_boot_page(struct page *page)

Should we add some debug aids to let users know the origin of these hwpoisoned pages?

> +{
> +	SetPageHWPoison(page);

Should we try to hold an extra page refcnt, as memory_failure does?

> +	atomic_long_inc(&num_poisoned_pages);
> +	hw_memory_failure = true;
> +	adjust_managed_page_count(page, 1);

Is what adjust_managed_page_count does inconsistent with what the hwpoison_boot_page
function describes? Should it be factored out?
Also, is adjust_managed_page_count time-consuming? Should we consider batching the calls
to reduce the impact on system boot latency? Maybe I'm overthinking it...

Thanks.
.


