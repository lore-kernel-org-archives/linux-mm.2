Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650ACC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 08:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8A46B007B; Sat, 25 Jul 2026 04:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0521E6B0088; Sat, 25 Jul 2026 04:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5ED66B008A; Sat, 25 Jul 2026 04:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1E2E6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:08:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 349BBA10A5
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 08:08:56 +0000 (UTC)
X-FDA: 85026573072.26.C25BF1C
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 85AE240009
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 08:08:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf17.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784966934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A1HQ2WW6oiMaD7v3adBeQMgFbzgzo4+aYV4FzZS8x5k=;
	b=wyyTGjvlQrNLSJy+cFMsWoeC2UN+T4MLBg7N+8HV1HJIxzu/XZcTmb/0pG99p3WpYPCXRm
	NxdHRpUSJnAJGVloXA1VNjdlhfkP4xioHgPZSabvfcgLPcwsQCgU4RN9I0UQzCV9AIIuGL
	L85Ynw5N9rFrjoFdRFXMeGlT0ziX8+4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf17.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784966934;
	b=zdoxFRf8gKuWo5LSemzxURhKHZtPtl30IF/46ZOg/rGvG1B9ghJu9HRTF45Nc9Y2ZiKDpE
	wCvKgVBnnXmoL/vqNE53ap0hirvuntv0Lqzm+WIhgbMD8ZKc054V+1CGdiA69d9z+3uanZ
	E9YDJpedhaZVNdN6+TIxKABlOG2yrVI=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h6cv442sWz5B12g;
	Sat, 25 Jul 2026 16:08:48 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 66P88hVb021478;
	Sat, 25 Jul 2026 16:08:43 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 25 Jul 2026 16:08:45 +0800 (CST)
X-Zmail-TransId: 2afa6a646f0d226-2e19e
X-Mailer: Zmail v1.0
Message-ID: <20260725160845504-gOk3xjMjshwFGEPvJ_lL@zte.com.cn>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org>
References: 20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org,20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org
Date: Sat, 25 Jul 2026 16:08:45 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
        <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
        <mhocko@suse.com>, <jannh@google.com>, <pfalcato@suse.de>,
        <willy@infradead.org>, <jack@suse.cz>, <linmiaohe@huawei.com>,
        <nao.horiguchi@gmail.com>, <riel@surriel.com>, <harry@kernel.org>,
        <lance.yang@linux.dev>, <kees@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <baohua@kernel.org>,
        <usama.arif@linux.dev>, <matthew.brost@intel.com>,
        <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
        <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
        <apopple@nvidia.com>, <peterx@redhat.com>, <chengming.zhou@linux.dev>,
        <arnd@arndb.de>, <gregkh@linuxfoundation.org>, <ljs@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAwMS8xNV0gbW0vdm1hOiBpbnRyb2R1Y2UgVk1BIHZpcnR1YWwgcGFnZSBvZmZzZXQgZmllbGQgYW5kIGFkZCBoZWxwZXJz?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66P88hVb021478
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sat, 25 Jul 2026 16:08:48 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A646F10.000/4h6cv442sWz5B12g
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 85AE240009
X-Stat-Signature: kynbn8e8xczthmwzp1wteoctixetzu68
X-HE-Tag: 1784966932-248710
X-HE-Meta: U2FsdGVkX1/cqagwM828Yyhn/QjB8BaW367jc2YkQbCbrA1E0O8B4+VwAohEveQg0itrpBcN3fAa0wfXtWVAX15ixj3eazImiF5X+S6ignTm/qsae/zg0PWxFNbkp4BDRcgGRIXV9bkJskk20wWK+Z8GkSVkfoF/6vKsBwZfaUBg61FSBBns1klNEhkFHuqSm9VBEdXSN8FqTUXCArAeVpfOx2RPQdFCePpLGz+xNtX1frQh7/23ajcp80RxLYB90FeLPXQf/SGvnExaZPhgKhUgSERNGS4QVpa0Mp3XSAwTh6FO3U9Awh60fJy9oJPgfqWpnTu3viu42e5Gd+pOm6rkKa7ofCbErfoP1VIFOeREj5LJRoP2E19z9PhuYeQXee7xwkbksy/27RRReds3eYonEXfBOCCYm5bUbq9UbyoE3/Dwsfvc0MC7OYrKiDfp7z1LRichGgscpg0vVpWVAbUwV/UC8xC6BxHM2u0VkhnTttKanVj5zEQu41pF8+6UPPBHeerDV01zKe6rZHmVdgo/SoWbORNT9qtr82+PyROcxgxmymV6k+WDoW40hY7MFjui+nxgNVjSD+QpUWZzFxXJP7WVVm2pQG4pa192odoGAHm77lkuoZayoQeEYeAVjW+brR82myGu8vp9uNFYeopMytD4YxcMXb2v/0i+czmHBgzMY9v5vTpqNe8yKs1z9kvQVH/zy4ATxCKeeSTAcCm91k7WAObcldNQzS/f5EQKq+QZFz4rbSiGMmCCVsnxlCYzxOvooPoU5UIEyrgymuD2gez9lJZkvWk4hpkYIBxjNiz9EXSUWXCuoddu4efFSTYJpKlSL6bWlq5ssvgCjNFs0gzxCxk/qRUCcL7K8g6LS61UON9dH/CLn01gVVeS75nr9UoAe7cKwkSxbT30+6K8DDkoPYhUuoZgzfLqNcm/oYqxGAO1Sjnez+vD/oOvdkWqyuSgS4budG7dLJ2
 v9aBsSmB
 zq73QJFCe+PfLzfSuGBNeedcocqZ7t0JtrK/FLUbXH34QZYNXGsteKjpkjXCCt0Og2bhI4uVeP2+9g1F6oty8MD+cYWYvgXRrg2k/rNsGqb+4apJPeuVy7i/5SO72ea+g11y1Wg6DJEYBVQJQcz4Ho+vgetl3Ymf8IL5MNZDbl7ZeLulhBWu+nOmCykbodxdN461ovYgLZt7ffO0JC0K2UrZjegP95Y9wot6VuDuMRNjmHR5UkNyTZ4GU/Xk6FxdMmqhc65E4//Shhdc4AdAwNvqr8Hv3U1wuGdBTNhx2fy+WiagxuHPBWSq+tEUywy7QLKEO
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
> 
> The first field is present on cacheline 0 containing key VMA fields, and
> the second on cacheline 3, which contains file-backed reverse mapping
> fields.
> 
> Given the relative time spent accessing reverse mapping fields as well as
> updating them, there shouldn't be any performance impact here from false
> sharing.
> 
> Update the VMA userland tests to account for this change.
> 
> No callsites are updated yet, so no functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 59 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mm_types.h        | 12 +++++++++
>  mm/vma.h                        | 14 ++++++++++
>  mm/vma_init.c                   |  1 +
>  tools/testing/vma/include/dup.h | 26 ++++++++++++++++++
>  5 files changed, 112 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 87feaa5a2b78..59b98cc60402 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4393,6 +4393,65 @@ static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
>  	return vma_end_pgoff(vma) - 1;
>  }
>  
> +/**
> + * vma_start_virt_pgoff() - Get the virtual page offset of the start of @vma
> + * @vma: The VMA whose virtual page offset is required.
> + *
> + * If unfaulted, then this is vma->vm_start >> PAGE_SHIFT, if faulted then the
> + * virtual page offset at the time of first fault.
> + *
> + * If the VMA is anonymous, this returns the same value as vma_start_pgoff().
> + *
> + * This value is used for tracking MAP_PRIVATE file-backed mappings by their
> + * virtual page offset.
> + *
> + * Returns: The virtual page offset of the start of @vma.
> + */

Thanks. These looks much better to me.

Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>

