Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D1DD6406F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 03:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A346B0089; Tue, 16 Dec 2025 22:10:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDE16B008A; Tue, 16 Dec 2025 22:10:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4383C6B008C; Tue, 16 Dec 2025 22:10:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3194E6B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:10:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5CD38B607
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:10:22 +0000 (UTC)
X-FDA: 84227484684.27.0B5D4B0
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9A86C1A000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:10:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KCvIGR+6;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765941021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hbw9zR0xEpNm9A0Pc6HSS0+c52olIIH10RNS2pDgzjs=;
	b=RFivj8jxTEmEqD5uZ6sCru0Snn0W2KsuK/rIHu13qEuuVNf1SNnyUFgcp12RT83PWPYLPG
	+CZc0km11/THzIWqczpQP5uigxy0k8Mnghu/ySYPmIfyiXBWF1DN3gZTuBwakMmMwlYTS2
	TjAy/kROUfSHymQXp9VcCn7easliplw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765941021; a=rsa-sha256;
	cv=none;
	b=QWLiOQfOaUj+Xl9iUEqJkESCDChcyaqUqIZJVGzdfUgjxKbpYUa5TorW+Kia6yToKB0yb1
	kNrk1HaDAeKMaTKttwyIc9/megG/uygGTwxKAuip4Ng8/lQ+3Wv8whv827OFB2GgY2sTf4
	S+WFjxrK4sGIvEjNF1wytnAOLzZxyjY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KCvIGR+6;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Hbw9zR0xEpNm9A0Pc6HSS0+c52olIIH10RNS2pDgzjs=;
	b=KCvIGR+6Fj9i8JqE2aOH3ZT7Ll4mDUiB1+4jFjDbno13RnDEFL0vddTBuxsYXAK8IqvPJfOC5
	eIDGY7bSeSCftA4ReTD2b3uoaCuk7lku20l2CYrd4VQn/ys574cTYHcBCtcueyQfs8WamJAE9sR
	iTfELMeilc1vFhS+AdFbEJk=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dWJcT2PcBz1cyPb;
	Wed, 17 Dec 2025 11:07:05 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 55EFF1401E9;
	Wed, 17 Dec 2025 11:10:07 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Dec 2025 11:10:07 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Dec 2025 11:10:06 +0800
Subject: Re: [PATCH v2 1/3] mm: fixup pfnmap memory failure handling to use
 pgoff
To: <ankita@nvidia.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <jgg@ziepe.ca>,
	<skolothumtho@nvidia.com>, <alex@shazbot.org>, <akpm@linux-foundation.org>,
	<nao.horiguchi@gmail.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
 <20251213044708.3610-2-ankita@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f871d90d-11e0-1719-c946-1c0bf341042a@huawei.com>
Date: Wed, 17 Dec 2025 11:10:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251213044708.3610-2-ankita@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: kk4s8jzd3tbc6roi8b6r5w7fwmn37ajw
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A86C1A000D
X-Rspam-User: 
X-HE-Tag: 1765941019-258811
X-HE-Meta: U2FsdGVkX19y0YL8vqu+ZJHc/U9POKAkl1KUlP6cUXW7AONsc1g9Wfz2wWXlSQoRm3Nh690PrA8MakJDddZg898qA34ySper8tVeEsa4TfJKevUVI5Vwcv42p2CnI+hZINQ/INB3RMxO3+NlKw95A8jePdXhL4qW+HldyEXGGBTXg3KE5E2LJppdvslVPke1ZVAy3+tffgRLsjThJDWxU5Hc5WJQ4dDlX9I3P47t2XO41K0xE7cm4EwOhd+b9JcQWkZnHHujcfc4fkyzmY8NM7gb8IQFe470RySn/dCHYiW9AqydHvBkEC/wpP3Oa2Z9eiTcx4e7oFXPVYgzlaoIcBPrb/TrV5HQjwKHhvGo2+8+H5A8+TxGkJqeIYU6Y1nNplQxAiKlLWmY9TDX7bC0JaoJpbOlFYCZGrnH8y5Z7jYKFckeNULbe7xC7YEHQyXHdB5wZWzVdTYO9azWDrJp4rSge5gfhFdpBGbodfQt+ZcbfTU4/m2E86eXHDQr6grChgfs+U5F8x2fOGZ4LOYEjHjt+iCypgt8Fp0Wmo7IQv78WKbAgTC5CyqHylAXTpENl5wG2L9LBclQ4zIaWMABvr0A4cwpMk3gMpo4CvTsCDm5rgWkNCsE10sgnKmYjeOO4kg7HDFrO0mgsg4yhthfKhXSyvN/bmxpRT5ybMS+rRPdaCmA5lHCTYaQmZ0FmRPFU1WJ4BWZKk0vJhUTG0zO4m5yj6Xdu6vXSPk39oWYsU+MPfYiIzjALBQXUXDeOLllaRrr30GHLFhttHU+oEv6S7tiNgLEzslAA6uiXkrdaB4fm1ivwbv1N5u3nWWqzook2amuGt1cQ9E9KRJT0zCWNN3KIUiY3hjQHEc4J9mYCy472WvcVPqjPwVF7bE/6GkCQeSTJagBAQgbObU9xaMUX5z5/NfSv7qiQvu6dZF1cFZKZeaJA1R0XJ0BJ+GXdnNdkVa8auqmM4PwmbDAte/
 Koephz4T
 RL/m/m1CKL14OrmUAI2XKyi7al3/3sW6WCkKUzjk64lJQYWdTvG3QMfOoiO2WQVl7SxKSq+EN+a9uOeRuFfhxc/XoMdkH8+NcPY4HaKauYeKhLwAxJqwDNmcybWM7jL3fh5eMtLymTga4fJVMfnX+Dz4tmDQP5FwL/kkEMXkCSOj7SivwJdthAN0vbiritvnodd/VbhLVScDSo1jBG+gn9TQOB2Y3JViPuDwrfhQkA+HXt3uMRf1AzU/KpjQFdbItpMHFAQOUgh6pY6okf+VCIwifihIpV+AINUa47FUR0zVWowQ3q4KKAyMHsEpvJVrWGUFOSZ0i8Z0WpsGhycKUXvzDehtamTgdT0zCz8rPZr3O//o8n17ZQyjdBotXZpYxymEhX4wq4Xoylny7kab5MlxtT/l1b+XP7Zlz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/13 12:47, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The memory failure handling implementation for the PFNMAP memory with no
> struct pages is faulty. The VA of the mapping is determined based on the
> the PFN. It should instead be based on the file mapping offset.
> 
> At the occurrence of poison, the memory_failure_pfn is triggered on the
> poisoned PFN. Introduce a callback function that allows mm to translate
> the PFN to the corresponding file page offset. The kernel module using
> the registration API must implement the callback function and provide the
> translation. The translated value is then used to determine the VA
> information and sending the SIGBUS to the usermode process mapped to
> the poisoned PFN.
> 
> The callback is also useful for the driver to be notified of the poisoned
> PFN, which may then track it.
> 
> Fixes: 2ec41967189c ("mm: handle poisoning of pfn without struct pages")
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Thanks for your patch.

> ---
>  include/linux/memory-failure.h |  2 ++
>  mm/memory-failure.c            | 29 ++++++++++++++++++-----------
>  2 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
> index bc326503d2d2..7b5e11cf905f 100644
> --- a/include/linux/memory-failure.h
> +++ b/include/linux/memory-failure.h
> @@ -9,6 +9,8 @@ struct pfn_address_space;
>  struct pfn_address_space {
>  	struct interval_tree_node node;
>  	struct address_space *mapping;
> +	int (*pfn_to_vma_pgoff)(struct vm_area_struct *vma,
> +				unsigned long pfn, pgoff_t *pgoff);
>  };
>  
>  int register_pfn_address_space(struct pfn_address_space *pfn_space);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fbc5a01260c8..c80c2907da33 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2161,6 +2161,9 @@ int register_pfn_address_space(struct pfn_address_space *pfn_space)
>  {
>  	guard(mutex)(&pfn_space_lock);
>  
> +	if (!pfn_space->pfn_to_vma_pgoff)
> +		return -EINVAL;
> +
>  	if (interval_tree_iter_first(&pfn_space_itree,
>  				     pfn_space->node.start,
>  				     pfn_space->node.last))
> @@ -2183,10 +2186,10 @@ void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
>  }
>  EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
>  
> -static void add_to_kill_pfn(struct task_struct *tsk,
> -			    struct vm_area_struct *vma,
> -			    struct list_head *to_kill,
> -			    unsigned long pfn)
> +static void add_to_kill_pgoff(struct task_struct *tsk,
> +			      struct vm_area_struct *vma,
> +			      struct list_head *to_kill,
> +			      pgoff_t pgoff)
>  {
>  	struct to_kill *tk;
>  
> @@ -2197,12 +2200,12 @@ static void add_to_kill_pfn(struct task_struct *tsk,
>  	}
>  
>  	/* Check for pgoff not backed by struct page */
> -	tk->addr = vma_address(vma, pfn, 1);
> +	tk->addr = vma_address(vma, pgoff, 1);
>  	tk->size_shift = PAGE_SHIFT;
>  
>  	if (tk->addr == -EFAULT)
>  		pr_info("Unable to find address %lx in %s\n",
> -			pfn, tsk->comm);
> +			pgoff, tsk->comm);
>  
>  	get_task_struct(tsk);
>  	tk->tsk = tsk;
> @@ -2212,11 +2215,12 @@ static void add_to_kill_pfn(struct task_struct *tsk,
>  /*
>   * Collect processes when the error hit a PFN not backed by struct page.
>   */
> -static void collect_procs_pfn(struct address_space *mapping,
> +static void collect_procs_pfn(struct pfn_address_space *pfn_space,
>  			      unsigned long pfn, struct list_head *to_kill)
>  {
>  	struct vm_area_struct *vma;
>  	struct task_struct *tsk;
> +	struct address_space *mapping = pfn_space->mapping;
>  
>  	i_mmap_lock_read(mapping);
>  	rcu_read_lock();
> @@ -2226,9 +2230,12 @@ static void collect_procs_pfn(struct address_space *mapping,
>  		t = task_early_kill(tsk, true);
>  		if (!t)
>  			continue;
> -		vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
> -			if (vma->vm_mm == t->mm)
> -				add_to_kill_pfn(t, vma, to_kill, pfn);
> +		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
> +			pgoff_t pgoff;

IIUC, all vma will be traversed to find the final pgoff. This might not be a good idea
because rcu lock is held and this traversal might take a really long time. Or am I miss
something?

Thanks.
.

