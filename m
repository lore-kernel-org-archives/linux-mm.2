Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB5B60A3815
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PzoTH4Ky
Received: by kanga.kvack.org (Postfix)
	id 375456B05BC; Mon,  2 Nov 2026 05:18:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3220E6B05BD; Mon,  2 Nov 2026 05:18:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C53E6B05BE; Mon,  2 Nov 2026 05:18:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E498A6B05BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:18:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B4B1A8A5C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:54 +0000 (UTC)
X-FDA: 85389780588.03.44F649B
Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	by imf30.hostedemail.com (Postfix) with ESMTP id C9FD580007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PzoTH4Ky;
	spf=pass (imf30.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614732;
	b=v0DiO3XiWL7rYo3/RukNsbQHALFRcPCmNTS7wHp5CxVMBTTSRz5t98C8yto1LKR1LHzzCR
	HCK8Sx8XtV/i2b7qGQsFYv2BpHx5tkLnAaFmB/iF/uUo7a5hmgMF5W5ZvMwy5bnJtP99b+
	X2TTmpcvr99om3/US7Ky5+lrtzY0Yp0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PzoTH4Ky;
	spf=pass (imf30.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOA0zqYyWmFskN0gCu/F5291zfD/d1SuvL7/LJWrUO0=;
	b=DvedDe49fJ2I6D2OwLJoh5lUVfFKdLtiws4IuwwKByxVngD6LZJpz0Vb7MyTsHtKb+2iXn
	+QnZX9KpSEaj8GY8XYAGIvAzM957LvV3+DleKp6Yd9hm4CzviB3j8eHZz8d8CQaS3SErEp
	9tHKLsqHiHSp3jx9N0l97E/Y+Tyq7/s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y06hHy2Q0v2jtRGnaYJJ08RCM/zmMrDx1xjhyL2iHp8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793614727; v=1; x=1794219527;
 b=PzoTH4Ky9b06Fib+kcsq2A55/2t437A0fMPhVCak5dkGwxcAcG0fSkRO4JmXzXuTbt7bJSdx
 +134soB/l0xdw1oVwvK14oOHjCpR5sTN3tGkfTi4GDZu4YP5r0E1kiLYEu3YKQNo/m+CMMDnokr
 LMjUXxhTO52g+pzz49Gr2TLs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id bfe08981aebe711e;
	Mon, 02 Nov 2026 10:18:47 +0000
X-Mizu-Trace-ID: bfe08981aebe711e
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: zhaogongyi@bytedance.com
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	riel@redhat.com,
	xu.xin@linux.dev
Subject: Re: [PATCH] mm/ksm: avoid anon_vma UAF during page merging
Date: Mon,  2 Nov 2026 18:18:31 +0800
Message-Id: <20261102101831.218090-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261031182256.40205-1-zhaogongyi@bytedance.com>
References: <20261031182256.40205-1-zhaogongyi@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C9FD580007
X-Stat-Signature: fnkxdeu6so5xhqutqmxn3og6y39cfjtf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793614730-709735
X-HE-Meta: U2FsdGVkX1/xsYmbfUyQh1nZai8kReGzFvqe5GXCS2JwrhV4dVFU39gQpupIMdb9aYgf+FViWagjM+XxE5ZnWH5t2mNYqKbDZ83vwsJjMJiVtMDQDW2u324NudJpeQGAyC2U6Yy44M0tW1QlzfH/sAgQQ53vncDCTqqlhjZJeds1k1yPT/VEdO1bGHi8B2FAwGnGce0Ok/ZWwzNgQQiXB4vXIg4VAmwcaE83VyyGwL51Q6EWY+vOMmIP20cp8wclY286z8fMKSG0crUbSllYmoBr+E2/uaRsjcs5nmAa7WF57LkNB6WXg2TxhpXRF/QaG5p1bW7QezUgsK/RK8Porl+FmsAR/EaamfK2DNyb8xMRx/0F1pnGGu3RP8Nre5aMDgW9KsvTVgXH29cITLfDZcCxUqc8+vz1gbbqyo1ouqpNFJb5HZpgDMJmnAZFkUt9jI8ZjK1fWd0/N8MfcBR9Y2CJlugquZ926f3AOqadTdMeBcvhxBJX5mQb/vpYfcLcWmTN17f9gyHahul75kYCZbx2MlREt0jHLtXiPI2pT8EwgpQkP8PPtBGLEwos02i3uOXB9wPdnz2Oh2es5vKad0g8IaztoE3GYiQxQjRh81chABUfLjyehHrDLIdiD7bYhx/y0ymnjuELYBeaGaf9EFVB589DO9iuuSed0AE7f8Z5mCc6A+urlXenOj4eXdVAHmZHKJ9ferILp2UH8jsk94PGi0mSS2jBrKPM5hst8MxgXUYBsCdMJpffUbD4Oi33f2tNsmIoLmmtCe/Jfx3bjBYvpnSQ1Qh7p2xNIXgfXCZvZkZpN1vJnT3IuiAFM+cUVb18oUT7VqDVIKIjbCnYODwozfnnnvtS0bYTOfOc78L+3kH4289a4pC0ORdjrFCSX6u8Ccf0nm3p4aWPvWBgFQb6eDxjm/qnlSdSvM82/NAsexf0CFOf3qCGzBxRucHYpS8Mm9MfEU15X0r42cK
 HuiSj4XI
 F6yQogEq082eotfRWkcDdMMSpgVW5ulchXjHcjbGcG5IKb6YPF5qEamGJsKUvg3gtI1jaNW27xkn+WuaEI29ErjER/t4fOaFCGhgz7wDMOymPIi0LWiq1V5PCSvAzDXb+1O5AURMF+mZsh3pf9OgpEenMxpkD+u0U6e8Wha+0FiT//9TciBOHfMhlZ6I5w6Z0vvZcpmBSxBnn2L16GVX2eKjQhsv4bB2Ec0bxXmvrY0cAtcwl1Nk+PuvKVU166JMx3U/C3mTPYJV7nzYsiuZQic5+WakYElcOzq5OqHIc1dk0n3rOPtEC8L+rUPo6TIuHYQ7B7ow2JAJE0UU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> KASAN reports a use-after-free in page_address_in_vma() while ksmd
> merges pages. ksmd keeps a folio reference across an mmap_lock drop,
> during which mremap() can remove its last mapping and free its
> anon_vma. page_address_in_vma() then dereferences the stale pointer
> from folio->mapping.
> 
> KSM needs only a candidate address. write_protect_page() checks that
> the PTE maps the folio, and replace_page() verifies the saved PTE
> before replacing it. Compute the candidate from the folio index and
> VMA instead of dereferencing the folio-side anon_vma. Reject KSM
> folios because their page index is not meaningful.
> 
> Fixes: 21d0d443cdc1 ("rmap: resurrect page_address_in_vma anon_vma check")
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
> ---
> Testing:
>   Unpatched mm-new: fixed-pool KSM/mremap reproduced the KASAN UAF.
>   Patched mm-new: the same workload ran for 12 minutes without KASAN,
>   BUG or WARNING; fork/COW KSM smoke passed.

Thanks for the report.

I’d like to ask whether this issue is easy to reproduce on 6.18 since
I suspect the accuracy of the “fixes” tag in the commit description.

Besides, adding an extra folio_test_ksm() check is unneeded, see reasons below. 

> 
>  mm/ksm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index d6f736a..f8af5ee 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1307,7 +1307,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
>  	if (WARN_ON_ONCE(folio_test_large(folio)))
>  		return err;
>  
> -	pvmw.address = page_address_in_vma(folio, folio_page(folio, 0), vma);
> +	pvmw.address = vma_anon_address(vma, folio_pgoff(folio), 1);
>  	if (pvmw.address == -EFAULT)
>  		goto out;
>  
> @@ -1408,7 +1408,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
>  	int err = -EFAULT;
>  	struct mmu_notifier_range range;
>  
> -	addr = page_address_in_vma(folio, page, vma);
> +	addr = vma_anon_address(vma, page_pgoff(folio, page), 1);
>  	if (addr == -EFAULT)
>  		goto out;
>  
> @@ -1515,7 +1515,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
>  	if (page == kpage)			/* ksm page forked */
>  		return 0;
>  
> -	if (!folio_test_anon(folio))
> +	if (!folio_test_anon(folio) || folio_test_ksm(folio))
>  		goto out;

The check folio_test_ksm(folio)) in try_to_merge_one_page is unnecessary, because before
try_to_merge_one_page() is called, cmp_and_merge_page() invokes folio_stable_node(), which already checks
whether this is a KSM page. Only KSM fork pages are allowed to pass through; even if they do pass, they
will ultimately be intercepted by the if (page == kpage) check in try_to_merge_one_page.




