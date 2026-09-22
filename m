Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC2B1C982FD
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F0826B00A1; Mon, 21 Sep 2026 22:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8D66B00A2; Mon, 21 Sep 2026 22:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DEBA6B00A4; Mon, 21 Sep 2026 22:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08CB46B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:06:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3ECF0A5ECD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:06:23 +0000 (UTC)
X-FDA: 85239758646.20.40B1812
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id A048240004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:06:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LN98Ar1m;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790042781;
	b=iFUOAtwRDIYMNQPnHGbOnMBf+jM1ni5dpk5sAyr6GufWZE/nS06Hmg324SYEpxRjgzZPlK
	/H9E5R8YsbSpyWg4TLZakAowA+zGFYHWltTDoZ/juI5+UhyIJbJ72+BU/BYa8gYfInrR/+
	egfGw40hX+labbPILV21PKAOt/XYGoU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LN98Ar1m;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790042781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZuDGqAfKWPU0et9rTdG+QCDRw+fAuzKjDCCj1PDWnM=;
	b=U8mQIk5mQzqbdaU8r+Zk6cb1bp65ZAj3P71IkNyBV9xXGBongbePaEc/lG+E2UIbceBJni
	beNHqSFfbYo2Wx2ymHK3yDV5LxWPi/O2lNCXymeJ39e8qWfpP8ZGloaGLiV46Go+hDHmOV
	b1h58vw/k2163+RZOeH+AGjsGYD2FPQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790042780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IZuDGqAfKWPU0et9rTdG+QCDRw+fAuzKjDCCj1PDWnM=;
	b=LN98Ar1mge7h9GxLbx/YwXn2I+Wy3AGHyeN1RzOzyQ/8F6fCW//vbu49MJNXimN7jLcEOI
	BLR0bbXPEHDPEci3mQ569yI29z7oddASTLuiTlQl0EK2t2I5HNMuZxwtih5YPKS6b6vPic
	FFLj2k6giaAV+cmAATrRx5YQ6TLYXXE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-Xiglv933OvyddK8gzinecw-1; Mon, 21 Sep 2026 22:06:18 -0400
X-MC-Unique: Xiglv933OvyddK8gzinecw-1
X-Mimecast-MFC-AGG-ID: Xiglv933OvyddK8gzinecw_1790042778
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-532c2cac078so25733831cf.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790042778; x=1790647578;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IZuDGqAfKWPU0et9rTdG+QCDRw+fAuzKjDCCj1PDWnM=;
        b=eREb1TlHz2Q+JOvpqZKORQOnBAaiBYY5nrTUBwD+PkbzZqAWOREw7yM+dLvPgTOhGJ
         YBs7cRtos3erOStQE+qBtDLHG0coqEBCd6bkuZ55GfCmn4VmeUTV4URWOiPP37ErloJE
         9bR68a5R7mAJUrH5IHOfkQRhOvPtSTykwc2DEOW96ioNLoWUl50s52fNNg2qHsZOuUJ/
         drlyBUDmYWZY/A/U/UEfuACyQYFNNzp9aw9RebM9THwW0g7hFdowaN57Jdc60VDL4zYc
         0y37bfW3h3SYV9gK7egKRnp/gh7bkg3SnIneqsv9HO9/9V40vODNEZTPWXM1DUKEwyPP
         5/5Q==
X-Forwarded-Encrypted: i=1; AKwUvByhpCD9OCSm/QQyh0R1vPW0cyMS0Tslfdvw7XAlAcXFGVV3qwPH7yfL2QGZHcLvEnvakSTgtYlR4Q==@kvack.org
X-Gm-Message-State: AFuF++myntz5zsPZCq50qlbIpN1tqSB67OpRKMymEPsiNow9FAXP+Qi/
	sWUP7h9L4TpM3vunFabcOEbomkqBkaLEArFmv7VvhGtABRzHEnz2Ur5fqfBgxD8x+xlihhxOF9Y
	/NWJbDg0knGC+POeBlIlmyEHJyCA/ZEE9SOTwcBabJIEngawmPDDE
X-Gm-Gg: AYBFou3C05LBk1+SMwSOqbFSYExqfXB5f0PB7mvi6qqcaXR1pk51dop9XqjGwGfo1hD
	Pyhxqu6q4562iQi7d3x33WmlPwPHS7S5Zdr/L/aDwBaHdehBySCedL1p0k6aq3wMI+qTSzmLaup
	ECWvq1qPD17pqLgTr1WkS/TH9du81h7AnW0OB/Xp8Oes3BQcKZz//PN3XQRXGqpCDFld7YzLlqS
	hWm08DGLg/AuW2TQpBPRit9AIgZ5S2QJAdXs542mbZsDMN6U+Iuqc5DCUH5P+FH/WXvPyo/Zhq0
	Vw6R2fdn1y6R/lPzp2l11E0ZVnauQ/xrFaU4QTJF2FR06Yb8eJkDpOuVjYq5H81C2Tm4G1NVZpY
	XxTU=
X-Received: by 2002:a05:622a:1aaa:b0:532:9adc:639f with SMTP id d75a77b69052e-532d8e70943mr34418201cf.67.1790042777978;
        Mon, 21 Sep 2026 19:06:17 -0700 (PDT)
X-Received: by 2002:a05:622a:1aaa:b0:532:9adc:639f with SMTP id d75a77b69052e-532d8e70943mr34417901cf.67.1790042777511;
        Mon, 21 Sep 2026 19:06:17 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532e188cef8sm1366671cf.8.2026.09.21.19.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 19:06:17 -0700 (PDT)
Message-ID: <3772f64c-de5f-40b3-914d-48f5e0b0a72a@redhat.com>
Date: Mon, 21 Sep 2026 22:06:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 14/14] mm: thp: always enable mTHP support
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com
References: <20260921102913.2970139-1-usama.arif@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260921102913.2970139-1-usama.arif@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HznLjo1g4J9SQx_DnMQDyLwNBxFFJNVKQpUyR0bRVxc_1790042778
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A048240004
X-Stat-Signature: hu9etqh9f5i5axpyk15bqrgk58wdeyka
X-Rspam-User: 
X-HE-Tag: 1790042780-902028
X-HE-Meta: U2FsdGVkX1/H9On5U5U9tWRPx1vOVdVhfbJh2F221VUf+JMHGipUK3hLWPgKq0frVd67RuTrFsoMs8AQKqaUrCdFDzNA24o906XTyi08is6c3kS6jC0xHJGFh3wu/LWXnxh/zVRqlYBcgXroglzM7j8wbbuzIP/O+pSos3glwvtGt/VM8m1iC+wTlEu6fjOln6iiPtGFOAkPkoi3HqRK0WweoWDtAQtoPK7dHZ4KhuUmFXnCv+3svGMzRfkalFgbTS+wNKqDx3q1Ck4H/wj/vYzuKt8GriM3vwh35wVVc3/zXZV5wQ8eXm1ihffcvtc8JnRtNFvAz3YkrCS/YeFsY3gMkkFfj+y1xUWcnHA5EMUtjz4zrVV44fnANqA+MJXec8L5rNE60UwmyF/+ePzAEF4rG5+GECbIK7x5k+c7Ca7U6/MzWsDHiB7Lr2IFPw0dCbgngu3oMp93QE5ib4883ZWJphvIzTNkHnJXn+tVrblqi6eJv3laEVWwNdlV7LEXAOakhGSoqz/ujT/Nel25oSJJbeMs4YfqIVa09pbRq4hXHMioTJWGgaI8v7IVAuVBGBOPS9KCL3woj0J6fgQ/+P7/H9sxB0HrU+XbJtIhgER2oNwzyDQxSNEDCl1CA3S5iW7kP7L2kMzKUvP9pbiL+lCpJh6oTROIpaDVXcQuuKHwAkt6r6bE9oAPuACSj72lb6mwqCNqrWSHxbahIFUsuJ7pxCSN4cCMGzhDmDg4l2nqiiitprbciLZa4ipn+43Cot5LOUUxhiKPpvWBnzrDIdCrhtCGxkP3YnVi5T5oFKsjmpNcVjA4G2uaitmV8zRcFiDFCQxqssle4Je0Xa3QGHOIr6Xd6WlZFbZCmlE+qyJE1eJdMnm9uqml0hwdqE9tX7I7gmCaR1XUb7Ex7ESZHHwDMnzYFAXv0s8BtIrcSvvmKh/Jlh/jrVQ5Bnlmky3SMclrl+m7F8tNIuGoQtK
 BTGqtvqe
 Cs2sYjCAl4oIxxqAYj9FEhYGNyBOwi52fXo+IJbFWap2bYCxTGBONC1/iFJ1QGMzlyZJzKXufEVEW0+Y6rg6LQTQdzXp/bFQCmeJ38IqDbqZtHZ4R42ByXZ4Wg1WvrUbiI0TIGu01Mdn4muvBwpqr4Pgyv/XkcU6Oqajy0dpP7ipF8FzhSzASvY5L8zqjMkN657fZbyarRoRxWOKMNOJxcLRlECRf3I2twa6pDSKu/NVw3reQsgEIarrGI+NcJvTFNqFx5+a8TXTEYMtmcgfKOEhwcGPHO+I+m0NIG4K4oLgx9jehLSM443KKbMSOwnRe317AgOGke+nWgRil2ahJcFveYRjYdjtAwWXNmys6+Dscvv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 6:29 AM, Usama Arif wrote:
> On Thu, 17 Sep 2026 21:45:35 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:
> 
>> If PMD-sized pages are not supported on an architecture (ie. the
>> arch implements arch_has_pmd_leaves() and it returns false) then the
>> current code disables all THP, including mTHP.
>>
>> This commit fixes this by allowing mTHP to be always enabled for all
>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>> created and their mapping will be disallowed at page-fault time.
>>
>> Similarly, this commit implements the following changes for shmem in
>> shmem_allowable_huge_orders():
>>
>>   - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>>     considered
>>   - Filter out PMD and PUD orders from allowable orders when
>>     PMD-sized pages are not supported by the CPU
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/huge_memory.c | 25 ++++++++++++++++++++-----
>>   mm/shmem.c       | 14 +++++++++-----
>>   2 files changed, 29 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index a06025b87e7c..a2d6de3ea988 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -189,6 +189,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>   	else
>>   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>>   
>> +	if (!pgtable_has_pmd_leaves()) {
>> +		/*
>> +		 * If the CPU does not support PMD leaves, assume for
>> +		 * now that it does not support PUD leaves and disable
>> +		 * both folio orders.
>> +		 */
>> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +	}
>> +
>>   	orders &= supported_orders;
>>   	if (!orders)
>>   		return 0;
>> @@ -196,7 +205,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>   	if (!vma->vm_mm)		/* vdso */
>>   		return 0;
>>   
>> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
>> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>>   		return 0;
>>   
>>   	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>> @@ -979,7 +988,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>>   	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>>   	 * constant so we have to do this here.
>>   	 */
>> -	if (!anon_orders_configured)
>> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>>   		huge_anon_orders_inherit = BIT(PMD_ORDER);
>>   
>>   	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
>> @@ -1001,6 +1010,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>>   	}
>>   
>>   	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>> +	if (!pgtable_has_pmd_leaves()) {
>> +		/*
>> +		 * If the CPU does not support PMD leaves, assume for
>> +		 * now that it does not support PUD leaves and disable
>> +		 * both folio orders.
>> +		 */
>> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>> +	}
>> +
>>   	order = highest_order(orders);
>>   	while (orders) {
>>   		thpsize = thpsize_create(order, *hugepage_kobj);
>> @@ -1091,9 +1109,6 @@ static int __init hugepage_init(void)
>>   	int err;
>>   	struct kobject *hugepage_kobj;
>>   
>> -	if (!pgtable_has_pmd_leaves())
>> -		return -EINVAL;
>> -
> 
> Removing this guard lets start_stop_khugepaged() run on a system
> without PMD leaves. All mTHP orders default to never, but the global always
> or madvise flag still makes hugepage_enabled() return true.
> 
> That starts an idle khugepaged thread and can unnecessarily raise
> min_free_kbytes. Could hugepage_enabled() instead test whether
> an enabled order remains after masking PMD_ORDER when
> pgtable_has_pmd_leaves() is false?

You're right about the issue. Before this series, checking the global
configuration was sufficient to determine if THP was "enabled" as PMD
leaves would always be available (otherwise THP would be shut down).
With this series, we also need to check pgtable_has_pmd_leaves().

I prefer the simple fix below over masking orders in hugepage_enabled():
it's simple and adds the check only in the call site that requires it.

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a3a9e4d93b46..175252a1d729 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -453,7 +453,7 @@ static bool hugepage_enabled(void)
  	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
  	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
  	 */
-	if (hugepage_global_enabled())
+	if (hugepage_global_enabled() && pgtable_has_pmd_leaves())
  		return true;
  	if (anon_hpage_enabled())
  		return true;

> 
>>   	/*
>>   	 * hugepages can't be allocated by the buddy allocator
>>   	 */
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index bc2de3a7c1ea..8c0f7e3efeeb 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2046,11 +2046,14 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>>   	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>>   	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>> -	unsigned int global_orders;
>> +	unsigned int global_orders, disabled_orders = 0;
>>   
>> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
>> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>>   		return 0;
>>   
>> +	if (!pgtable_has_pmd_leaves())
>> +		disabled_orders = BIT(PMD_ORDER);
>> +
>>   	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>>   						  shmem_huge_force, vma, vm_flags);
>>   	/*
>> @@ -2058,7 +2061,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   	 * sysfs configs.
>>   	 */
>>   	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
>> -		return global_orders;
>> +		return global_orders & ~disabled_orders;
>>   
>>   	/*
>>   	 * Following the 'deny' semantics of the top level, force the huge
>> @@ -2072,7 +2075,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   	 * means non-PMD sized THP can not override 'huge' mount option now.
>>   	 */
>>   	if (shmem_huge == SHMEM_HUGE_FORCE)
>> -		return READ_ONCE(huge_shmem_orders_inherit);
>> +		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
>>   
>>   	/* Allow mTHP that will be fully within i_size. */
>>   	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
>> @@ -2083,6 +2086,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   	if (global_orders > 0)
>>   		mask |= READ_ONCE(huge_shmem_orders_inherit);
>>   
>> +	mask &= ~disabled_orders;
>>   	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>>   }
>>   
>> @@ -5630,7 +5634,7 @@ void __init shmem_init(void)
>>   	 * Default to setting PMD-sized THP to inherit the global setting and
>>   	 * disable all other multi-size THPs.
>>   	 */
>> -	if (!shmem_orders_configured)
>> +	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>>   		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>>   #endif
>>   	return;
>> -- 
>> 2.55.0
>>
>>
> 


