Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF13C4450A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 03:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930A66B008C; Sat, 18 Jul 2026 23:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1066B0092; Sat, 18 Jul 2026 23:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821BB6B0093; Sat, 18 Jul 2026 23:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49FCC6B008C
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 23:55:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C831160534
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 03:55:53 +0000 (UTC)
X-FDA: 85004162586.16.3E3D607
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD33480004
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 03:55:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf30.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784433351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I7SaYhZ94WWaQ6exHrkHLdiRA4LlhUI2bq2iJMex4Ho=;
	b=eNOYuRFvHVF5bpbm+/9nsxMg9vxqBS14IlNRRrN2mmgC849tYxksmuy9Fb8bJ/S9y7OgTZ
	kkV09csvSBtrVZkdUGzMQCqe8mYROxhspbM/UTAWBlOY4jMxwfJvfS3i6NVuxVlvu35SfL
	C+cLgHg1/6Qbaez0Psdb/i+5EClEf3w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf30.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784433351;
	b=RQK56kZpT/JGxsQ2PlblA/k4aWnOXpLJYeWg/bPv+lrOi4w0Ha2ZDVM2xMmp6VqzMbRVzH
	9zmvdhG6e3tc70oQgqv0R6+oCYjkTjZh7GGan0yxnTr4Bv1NPQ90+UykJ56GWJ3nbeyfG0
	bvtha8TzB9o8374gdlOL5opdDi7ZFkE=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h2qYw2TQjz8XrrJ;
	Sun, 19 Jul 2026 11:55:48 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 66J3tf7v034198;
	Sun, 19 Jul 2026 11:55:41 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 19 Jul 2026 11:55:42 +0800 (CST)
X-Zmail-TransId: 2afc6a5c4abe5f7-4ef27
X-Mailer: Zmail v1.0
Message-ID: <202607191155425057lNrNOYTi44E_jmidmtkn@zte.com.cn>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-1-cf24910ef094@kernel.org>
References: 20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org,20260717-b4-scalable-cow-virt-pgoff-v1-1-cf24910ef094@kernel.org
Date: Sun, 19 Jul 2026 11:55:42 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <ljs@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <david@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
        <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
        <jannh@google.com>, <pfalcato@suse.de>, <willy@infradead.org>,
        <jack@suse.cz>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
        <riel@surriel.com>, <harry@kernel.org>, <lance.yang@linux.dev>,
        <kees@kernel.org>, <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
        <npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
        <baohua@kernel.org>, <usama.arif@linux.dev>, <matthew.brost@intel.com>,
        <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
        <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
        <apopple@nvidia.com>, <peterx@redhat.com>, <chengming.zhou@linux.dev>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>, <ljs@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwMS8xNV0gbW0vdm1hOiBpbnRyb2R1Y2UgVk1BIHZpcnR1YWwgcGFnZSBvZmZzZXQgZmllbGQgYW5kIGFkZCBoZWxwZXJz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66J3tf7v034198
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 19 Jul 2026 11:55:48 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5C4AC4.001/4h2qYw2TQjz8XrrJ
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD33480004
X-Stat-Signature: 1oc3zfqu77rfa7qq9dzza1m5xmfjycj8
X-HE-Tag: 1784433350-543173
X-HE-Meta: U2FsdGVkX1/s8QEC0XYvRzdDtql/BEBF7xIUl9CQHfSrp/k1EmC4b1gKin4UAQ2QiK7uMdJtIstP6HEnUAw0CWOjnLSSUdcWIvgLGodqBWbBfaKS5CKKE3CnNwHqXpkWHZwYpbYCp16U147+ILSGKbHVPcbrJwB+XcRZ+obeN+QOb2yu5MbRwHPntHCGMNEh8rwnJptDjnxoGgPvO8NxNXCELuR3oOpgBN29dmQ4OSzQOkkVYFT3ylJ0R7gMcvXl5f1KXIT/eNNPYdIQ25lGuPLrcaHPJ3PHWc5bGbi0eOYWYzdbjh1RXSAr27v0AAOUfFJKlcvKU4cZ7zaUmlcfJUWTi8vfoCRB9D8yq3JPaRDDy0qQ1Fa4+pkyKnA2prKGnDEbLJ7EXb/mmKBmcHIWqS9ytY0ftdud+27qw55uSMRRw8LZvnHLfY4XyeP5OBPJgrKuOm+y0lfR/FVBmzuSSgSi4sMEoCj/4SUc2bUm4nAFbHKtr0hdYhBXaVlkva1tRfTevBuJZabBtM22PsO8LQqWVFghnX45so9jSBb8gglwslnLEl9YePiH5GKuDJDBIMro/CscsM1VRZlnF63LRyWnnERYeJsbylDr97ywuf68t3XKDKFNNlDEwZDm2BK7ZJtH9HxWRpC4ICDbmuf1yCW+X38y0VbiMZgVOjmlTHe/V86njbp78dtciPlkX7I7CSh7I2J6sxtmM/UaLqu4RAvz0hUWHVGYIDOelIl9hKs2SmLwAv1wWghsLIqIIaB9JqcdM4hprWnqKiV6OZPJTkO9tioI7Qz38gL/n9hdzH712n0GepwTj9XYKfaBamKjIdJylVjqMSlvs9UaC1p8RxSAfR9acLLE68+LHc9S5MopBfRiYR4QHLMh8gCsVxSe7w+EBaW8HeyzTsoeT7LMBtWRvFGLGYcDaAWW44vJ4CxZer+hE+4bOaGdI4WBZ91pKeQLps7tH85UY2zdWzA
 fpV5LlDJ
 30wXCFHr9isMAhazSj74cRSByh+oxwu6Mjzw/UPwL/RAna49e2VxrB7eEYwtOR4lU92TsMGPPRaeYDCInv7xuYhRpZwFLSKFwx2Q+AXcdqb5gDFIGoZJZQU5hFbf9en/ou8vz1LKIm9ySoUSR/RQrXorsWKW0keRIBhOQng0t7hCojMmaXZRixtFKrh/rQOB0TchR/WHU/lTiXTcoAWfhs34OyiNFofKUUu5r2vga9nNLCVho3rmQhgw1jUQhBpEBHsXZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This patch establishes fields within the vm_area_struct type to store the
> virtual page offset of VMAs.
> 
> The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT if
> they are unfaulted or were not remapped, otherwise it is equal to this
> value at the point of first fault.
> 
> Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
> file-backed VMAs are tracked by their file offset. By adding virtual offset
> as a property of VMAs, we can now track them by their virtual page offset
> instead.
> 
> By tracking this, we provide the means by which to eliminate this
> inconsistency, and more importantly lay the foundations for future work for
> the scalable CoW anonymous rmap rework.
> 
> This patch simply adds the fields and some simple helpers. Subsequent
> patches will update mm code to make use of these fields correctly.
> 
> The fields chosen are packed in the VMA such that, for 64-bit kernel
> builds, no additional space is taken up.

It is not necessarily true that no additional memory will be consumed, as it
depends on whether the baseline kernel has CONFIG_PER_VMA_LOCK enabled.
Moreover, in the future evolution of mm, maintaining this benefit would
require that the layout of struct vm_area_struct before __vm_virt_pgoff_lo
remains unchanged, which seems impractical.

My personal suggestion is: maybe we could simply add an unsigned long field,
say vm_virt_pgoff, without worrying about the increased memory footprint for
now. Additionally, it would be helpful to add some comments clarifying the
difference between this new field and the existing vm_pgoff, to aid understanding.

Thanks,
Xu Xin

> 
> The first field is present on cacheline 0 containing key VMA fields, and
> the second on cacheline 3, which contains file-backed reverse mapping
> fields.
> 
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 59 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mm_types.h        |  4 +++
>  mm/vma.h                        | 14 ++++++++++
>  mm/vma_init.c                   |  1 +
>  tools/testing/vma/include/dup.h | 26 ++++++++++++++++++
>  5 files changed, 104 insertions(+)
> 
> +static inline pgoff_t vma_last_virt_pgoff(const struct vm_area_struct *vma)
> +{
> +	return vma_end_virt_pgoff(vma) - 1;
> +}
> +
>  static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
>  {
>  	return desc->end - desc->start;
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 939b5ea8c9e0..2710628059b1 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -967,6 +967,7 @@ struct vm_area_struct {
>  	 */
>  	unsigned int vm_lock_seq;
>  #endif
> +	unsigned int __vm_virt_pgoff_lo; /* Low 32-bits of virtual pgoff. */
>  	/*
>  	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
>  	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
> @@ -1041,6 +1042,9 @@ struct vm_area_struct {
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	struct lockdep_map vmlock_dep_map;
>  #endif
> +#endif
> +#ifdef CONFIG_64BIT
> +	unsigned int __vm_virt_pgoff_hi;  /* High 32-bits of virtual pgoff. */
>  #endif
>

