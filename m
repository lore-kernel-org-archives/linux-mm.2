Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A5CC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E154B6B008A; Wed,  9 Sep 2026 05:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7516B008C; Wed,  9 Sep 2026 05:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC6E6B0093; Wed,  9 Sep 2026 05:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A50AE6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:55:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0479340162
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:55:11 +0000 (UTC)
X-FDA: 85193765664.01.51C1343
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C152C000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:55:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rJ0azai2;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpTZv98TBCym8APZzjiS1eCA+OF2OQMSUEHKxCalkBI=;
	b=2+aamgOGb0PuC4TW2cy+zee7c+fFZZodOe3D84YzgZlxsREZ0rfuiCtyMF8qHar166m6Xi
	P5a+T2p+9DcSWtJ86A8QzmEwXfEhjwhLXmfbMIS9jkgbV16SaB+GelvGaOcRAeBwsoB7ks
	XIkvf9we15Ah4Kd0XaRgOFSY8EVu6+o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rJ0azai2;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947710;
	b=I5V9NWluVAbTHt3zCy8USQs8+ouuxKxtlLiKib9vr8NjqkAQl2+z4d40adw7P0MJnFZ1OG
	QA0kckB6Ozqu8FIEDrIsIJIo28BiMQGwfzoKJsA3HUACTaqWKkRK4pSzPk8SX9MX3+MhGW
	Oqa5tF9t14qQ4UuZjwDvZ+4yIA/zAhk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788947705; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DpTZv98TBCym8APZzjiS1eCA+OF2OQMSUEHKxCalkBI=;
	b=rJ0azai2gqRBInbl30R5EMya3fcOTo01AKaR2D4sBokSNt+s1dqp30jZLTmXN/ap6K+dI6hIa7xXRiC40tkUtO+1LOzr18WROqFj8y9k8HbrVflrmz97VU6GOvzZAUY15cKzA2HcsVKzESYf00IRR7fMzNgxbw5SbyoukXZ/Tqo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAeWyTK_1788947701;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAeWyTK_1788947701 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 17:55:03 +0800
Message-ID: <4e064b9d-aea9-485a-8547-3830999cff01@linux.alibaba.com>
Date: Wed, 9 Sep 2026 17:55:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/19] selftests/mm: stop khugepaged during the
 MADV_COLLAPSE cases
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-7-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-7-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C152C000B
X-Stat-Signature: cx67pjanmxnhuyrqinru7usnq54wb91x
X-Rspam-User: 
X-HE-Tag: 1788947708-960666
X-HE-Meta: U2FsdGVkX195cNKb9I7ClOn2WAtDx/gmYgGnH4SaZKIanZfAP8CZN8Bv9w6muHK3VMgzcbm6vFyK8FmJWxxQ1fKU2rob8wWdsnpg6g7XmJLmj1leuQvq2njFerq/PNOLcN7c7t3/3xH6l5Tk+BKHk1HHCy75TFoC8BJ41VSYHUJl0MdLEyugeQjYtvuW2prEhTMxNeE5GE+pEke+ic2okMukAiy75VrSgKysM/9mRLxzFo8g22s5Uc3ilBgYDEknH4VDJWjff63NxsnFBUzPDAujKd1WHbMs+cjRGRSF67e4stFMR/qBd7fp8F1y2CSBkvtQWzT6zFoRIeVCJh5Gay54+yN58XWtPAR/yVjUEpxEM9rRv4eQmq3ZCJOGSEZYK6x5tGw2rQPqT1bsL3LUIwTcpk9JF/dQxI/pK6BTpTqNHtJh2/Csazy6N7HTX3JTfcHh4G16hnuv/R53T7AFrPvlYlCSQQUsxEd2JokUtLQA6pVF/wOJn0NxFoKwDD6TsirfRBkv0cHqFphtc8NzvgLRjiBv8SQdBOtNhu3cpTYBtIVNNavSfGSQmW4gda3mcrdg6AHzn2QkyvQ9+z1+MPBaYqmRcYkk8Iac1Fgxog2oEaB2Y4QgK6DERRJJJQWA/c1IC6IslUOe1fKa997ToPN6/SLx6pHsDbkbNwMsYSSY5or4ZbQNaWq5zK/i/iD+ghcdi+yJRbfI2AONEHE0/BJUi8Qa9iChDfZg4vYAlqLxIYg+oeZsoziRtEoxk7PhM/eNw3gnhi5NpGlyI2MTt/YAaK3dfFandIUt6WUBcDZNFBHdD9IGBjxuXqw521chnayeQ8edB+6tSaNaKAEIiuOi3Rnhd36Jyt6aWMhxgrR7g16U23CTTq3qaeetDi16Pb5/mAMUlQIy9/m2dwrQGa5vWgDx8nlXhr7ws0oJAAFo2K2DUGGOMRoF9Sfm8Q28X9ZofDnwy7RcOxr2KFm
 /HiakYrB
 rAOF/+6Vo2p4OyEU46iJXck0QcfsM5rFCV4VG2lYH+ZlpJi0vGO2fRH4342a6+Kx8ENeW17F9OamsrVEzQf18sEbhCaR2jlnZoB/PBmPuqIx8TVcO4VWfPwMzSOw8lSs7JxbYMCR/b7pQ44e6psc0QoylOJaMcJ0whUp98kW6wgbkKnX5KvtMjszfhHzZOLL7LP0At2fSI0z6k07CbuyjwMO0r6rm4n5lm3n6RvPHLo9E9QzB7mMpCWivUzrfZ1AEphdzwg5B6H0epl8C0jJQEMI+op+fJV6XnlaMuhiIbE97Q4Tm9riOwnLilqxSXBZUPkU5bD9z0hHhS+2N1KrUVDWvn/QEsU5MasKfQnkqmJXEUT4oxdpV5E/8Tlv20zmTphbe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
> khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
> It clears the global controls only, which is no longer enough.  A per-order
> control overrides them, and -s, which makes the cases fault in folios of
> one order, leaves that order's control at "always".  khugepaged then
> collapses the very range the case is working on, and the case fails on a
> collapse that was interfered with rather than refused.

Right. So I think the correct fix tag is b7f16963efe7 ("mm/khugepaged: 
run khugepaged for all orders"), because before this commit, khugepaged 
would not try to collapse this range since it only checked whether the 
PMD order was suitable for collapse.

> Clear the per-order controls too, setting them to "inherit" rather than
> "never": khugepaged honours the global never and stays out, while
> MADV_COLLAPSE on shmem still finds an order to build.
> 
> Fixes: 9f0704eae8a4 ("selftests/mm/khugepaged: enlighten for multi-size THP")
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   tools/testing/selftests/mm/khugepaged.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 398430c33872..e9bc8fe8a1f8 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -533,8 +533,8 @@ static bool is_anon(struct mem_ops *ops)
>   static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>   			       struct mem_ops *ops, bool expect)
>   {
> -	int ret;
>   	struct thp_settings settings = *thp_current_settings();
> +	int ret, i;
>   
>   	ksft_print_msg("%s...", msg);
>   
> @@ -547,9 +547,16 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>   	/*
>   	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
>   	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
> +	 *
> +	 * "inherit" rather than "never" so that MADV_COLLAPSE on shmem still
> +	 * finds an order to build.
>   	 */
>   	settings.thp_enabled = THP_NEVER;
>   	settings.shmem_enabled = SHMEM_NEVER;
> +	for (i = 0; i < NR_ORDERS; i++) {
> +		settings.hugepages[i].enabled = THP_INHERIT;
> +		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
> +	}

This looks like a workaround to me. Shouldn't we fix this in shmem 
instead? Since MADV_COLLAPSE is supposed to ignore the THP setting, the 
fix should be something like this?

diff --git a/mm/shmem.c b/mm/shmem.c
index c92ed17dbc4a..e0c0901c34a4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2050,7 +2050,7 @@ unsigned long shmem_allowable_huge_orders(struct 
inode *inode,
         global_orders = shmem_huge_global_enabled(inode, index, write_end,
                                                   shmem_huge_force, 
vma, vm_flags);
         /* Tmpfs huge pages allocation */
-       if (!vma || !vma_is_anon_shmem(vma))
+       if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
                 return global_orders;

         /*

