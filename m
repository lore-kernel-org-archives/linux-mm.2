Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA25D606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=J76GpEuM
Received: by kanga.kvack.org (Postfix)
	id CD03F6B05B0; Mon, 26 Oct 2026 07:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C808E6B05B1; Mon, 26 Oct 2026 07:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBDC16B05BB; Mon, 26 Oct 2026 07:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B68B6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:21:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39FE5406CA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:21:19 +0000 (UTC)
X-FDA: 85364536278.01.B63AACA
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 087D2C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:21:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J76GpEuM;
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8+NqHaT8WqMId4+zcLiP9/gsTgp5OXdEZ3QcQaKSLw=;
	b=hgRWl1exGyqXoJYznM8nLT+9bAm79R2A0XkDHt3kQ/aCBRCtCFrY6SmC0y/doOQRE9q/4j
	uCcINzJMchFDWUAgJxJLWekvhhxLckbckt3acqfdd8lc+HJmx+9zSY3uk2VER863VWBxZh
	Hd9HPmsCuAkYe1xcfOVGNc8U3zCvKMk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J76GpEuM;
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793013677;
	b=disSMhK/BdwQnFF2Wp+43Ulc4oBB/GLuaLTGpMGPY3x1ZEREc+uFv6uCERcD4SCi3LbYPr
	Z/BzY9RxR7U6pXkayjsVmyO54HuZbp4LIXrx0GwfnmhmBNr5BTrsnqvbRs03DlLtEJ4U5K
	ImwnX5kng/QQN1zFXP7Uwff4n4Uz5jU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793013670; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=N8+NqHaT8WqMId4+zcLiP9/gsTgp5OXdEZ3QcQaKSLw=;
	b=J76GpEuMjV8TUYCFDjxzb+1jB5Bv+E4zzawdzXIBONG4o35hLKZKk+VmbttwtIh0pQ8fYjqSseJsl2lFizQ7l9e5fHsTc42evYPAzIwwCer8FcVJ/oDSjx2GLA+yg0lHNSXAlDuwjf4RI2VDNoKdlsGnVTSJTESIP/NeIntLAOc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XDXPkV2_1793013663;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XDXPkV2_1793013663 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 19:21:09 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org,  david@kernel.org,  Kaitao Cheng
 <kaitao.cheng@linux.dev>,  vbabka@kernel.org,  ljs@kernel.org,
  liam@infradead.org,  rppt@kernel.org,  surenb@google.com,
  mhocko@suse.com,  linmiaohe@huawei.com,  nao.horiguchi@gmail.com,
  ziy@nvidia.com,  wangkefeng.wang@huawei.com,  tujinjiang@huawei.com,
  mgorman@techsingularity.net,  chengkaitao@kylinos.cn,
  muchun.song@linux.dev,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
In-Reply-To: <20261026025724.1430747-1-xiangzao@linux.alibaba.com> (Yuanhe
	Shu's message of "Mon, 26 Oct 2026 10:57:24 +0800")
References: <20261026025724.1430747-1-xiangzao@linux.alibaba.com>
Date: Mon, 26 Oct 2026 19:21:02 +0800
Message-ID: <87pkww7lnl.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 087D2C0004
X-Stat-Signature: jnuanjtcp4zrdud45ck5a736jp1o53ec
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793013673-628032
X-HE-Meta: U2FsdGVkX1/xt7PcVwlQC0L22dqHm21lb1TbJ06QOqqVz/Jr9pljxc9/8aPztwm5+WUC/cNgzBPnO3XW5iilQGAAH1rJ9jl7akQdPBVG1MqY6IbI/lpQfO+a9mQbwuSkVJGD948JG+i/30WhHXa5kYbsqx5ywea0pKxzWSUnAkPgWPpmVS55KXWayWgxMx2vNA0E+THXLELqb+eYqsjymL3TWg941pE0gUpaLNBtI0gA8P6Ui7HwsdU2v9zPB2PFih/u7I+KsuVXlmc1CxKkJ6jyGghwysHMyC0nnOIz4NLJ07Qp3sIswTrHqzr6yGwF6kkrQK7Mg6FeWbwEIpIRcakdSevMBCIXkdkRFKtGUIFK3A2ljTElAmj9otFC+db59ZojQfCqB+FXz0MTQexHx1/JiMVGTRoQMyWGZsSQA92LKuQXB8rpnY0pJcUpRMvqn/vA/ZjWJaSlllZYH85C8Qu3kElbb6U/bM0ALK7yoSHX/Ev/83m6anKbZInJjStWXLdNxHRi3wwTJUEshjuLjMTeJKfScBQEgkYZzZZV4iPrUEdMCs7oSAYupEtIPihnjNJ5vuR0ym4o5/PYxou3XDndORF9m8DV5Eai6NAgNNVxyaZcLUY0OJaGQ24BngHAXBBrrEDauXfgrTAppZ1rQFzfXD4qw8+TY+HZN9y2+kkDh7ZVAxmFxyIhEJuTe5T6ejeVFg1jOkhK4SAwt9bcnCc8fJfNm340wEOU61Jq2ETxZo1o2VFduURFb/7HI37l0SMNKVWd0iz9rv9vw4a2IE8w9LSHu/o4BCrcQ/hzCKEP16ZEy/KCouO/GRbIYb22aH6IrUDd3ZsxwS6HPhWLQf4Y/zNqLkvbhlBlLATkAUZ8a9D+XcU0O+dO7A1ovVHnMBskz9K0/pvGg63r1ePNvRPP96Wz+68FQ3ZwJX1ban9A/p4RUtvTBF2hFFPDYdpUR89AHQ3lZ0A8fo0Fw3V
 mKpN3iqJ
 qF3JtmczxZPaCYVG76dqsKPaOh9fJe7Huf6C+RpSVMRUgAzq8huIqsvGpltyBE0M7Xp6ZQnzqYV7u1VgN8D4RVynoRDqdRIh3DhQjwQkD0j9EYPHMmTilt3eEEHki7xnHWuM2NwZHW16j2ZwlcCWi1ejCzmfaIj6FXPhax2tBMcK4XmRzSWugXwQyOpuUBoUvr81N+zx5ZnFo2218+qgNEfYUfXFzpaO0av18xEGA2R90UW4qiwB6PMSYeH/0icwtrTvWGu2IyooJcvcyzUHdLbBZkTFGqaJuWN1bvAZWKj8XY4/oWF03TQQI2eem4EVnTvdj3nkyn0qKT6tOlgV3JsXdVR2HsHirF9IBKbyPDeXI0JgZuqKa1aH25x0qAGNgoe7N6ACELe2XkK+1zyP4qLPjeVwnB6/RS9uxv8dkjgkVxWdPI1LQFH6BD7ljl0DSOeAM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Yuanhe Shu <xiangzao@linux.alibaba.com> writes:

> Where copy_mc_to_kernel is defined, copy_mc_user_highpage() and
> copy_mc_highpage() stop at a hardware error during the copy, report
> the not-copied bytes and queue the source page for memory_failure().
> The !copy_mc fallbacks return 0 after a plain copy instead.  With
> PG_hwpoison set while the data stays readable - software-injected
> poison (MADV_HWPOISON, the debugfs corrupt-pfn injector) or a
> transient hardware error - there is no fault to recover from: the
> copy completes, the destination folio carries no poison marker, and
> the poison is consumed silently, the same poison consumption
> commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
> THP") refused to risk on the split path.

As far as I know, software-injected poison is used for debugging only ,
so I don't think it's that important.  Hardware poison state in DDR is
sticky; that is, even a transient hardware error will cause a permanent
hardware poison state until a reset.

Therefore, the primary value of this patch should be to reduce machine
checks (and panics) during memory copies.  If so, we should place the
check code before copying.

> Check the source folio with folio_contain_hwpoisoned_page() in both
> fallbacks and return PAGE_SIZE, the not-copied-bytes convention of
> the real copy_mc paths, so the callers take their existing error
> paths: the COW and fork paths fail with -EHWPOISON, KSM and
> khugepaged abort, and folio_mc_copy() propagates to the migration
> core, where this composes with the separate migration-side checks.
> On archs with copy_mc this code does not compile.
>
> The check runs after the copy: a check before it would leave open
> the window between itself and the copy.  A flag set before or during
> the copy is caught, whatever state the data is in.  A late software
> injection cannot have corrupted the completed copy, and a synchronous
> hardware error takes an arch without copy_mc down at the access; the
> residue no flag check, before or after, can catch is corruption whose
> hardware report lands after the last check.  Closing that would need
> architecture support, as discussed.
>
> The fallbacks do not queue memory_failure() on refusal: the flag is
> already set, and memory failure either knows about the page or has
> abandoned it.
>
> Suggested-by: "Huang, Ying" <ying.huang@linux.alibaba.com>
> Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
> Assisted-by: LLM
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/
> ---
>  include/linux/highmem.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index d7aac9de1c8a..f90f0c6204a4 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -474,12 +474,21 @@ static inline int copy_mc_user_highpage(struct page *to, struct page *from,
>  					unsigned long vaddr, struct vm_area_struct *vma)
>  {
>  	copy_user_highpage(to, from, vaddr, vma);
> +	/*
> +	 * The flag can be set while the copy runs, so check after it;
> +	 * a flag landing later can no longer have corrupted this copy.
> +	 */
> +	if (folio_contain_hwpoisoned_page(page_folio(from)))
> +		return PAGE_SIZE;

Why not just use PageHWPoison()?

>  	return 0;
>  }
>  
>  static inline int copy_mc_highpage(struct page *to, struct page *from)
>  {
>  	copy_highpage(to, from);
> +	/* Same reasoning as in copy_mc_user_highpage(). */
> +	if (folio_contain_hwpoisoned_page(page_folio(from)))
> +		return PAGE_SIZE;
>  	return 0;
>  }
>  #endif

---
Best Regards,
Huang, Ying

