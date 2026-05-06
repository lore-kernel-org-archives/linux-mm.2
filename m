Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965F4CD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA966B008C; Wed,  6 May 2026 14:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B876B0092; Wed,  6 May 2026 14:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C696B0093; Wed,  6 May 2026 14:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D79346B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:32:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84A5916030E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:32:39 +0000 (UTC)
X-FDA: 84737840838.25.25EF70A
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6FB2E140018
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:32:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bPOv/6sx";
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778092357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ee78RPNdirR36JOR3boeHs0NejiR2ZzTKCoLjSobKZc=;
	b=MkebcsZeWmHzaQ/ucisGCHUReP32IrOWkFK3HxIn1/lQlHAfEsAyTa2DscCZltxpQ1cyrh
	iE5+KSsJKK+AwHeM5zFOinUXS0yCZBypNTnDT2yqfTUtA2unKL83bKoYwghL9S+XgKCpli
	MKSCmjweZL2oWMJzTtQh0ZitKYdXX7U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bPOv/6sx";
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778092357; a=rsa-sha256;
	cv=none;
	b=LHQ80gEpKM01Fepuldow8j6+kZch3xnZaAyXB1bKbTrPjodZxV7p5g5jX6IVZlfi3txkFP
	E2hm+N/u55FdUB/G5UmuX0j/TKdTitZD5UPZ7e3pR/+bOISzJX/dOjP8InWT8xqlitcAXv
	hyQ7qnAbnpUsim176eZdybBW8hFy0r8=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-393c93a01abso9869771fa.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778092356; x=1778697156; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ee78RPNdirR36JOR3boeHs0NejiR2ZzTKCoLjSobKZc=;
        b=bPOv/6sxCUn1PS4kithGnXKkzZbOPi1XpCEUBTjjpSqWq1pm7Ii1zSpA4Lw3fRRHRP
         5A9ayEIloVAa1OL0QdDujTyaSrrZFzLQazCPFXcjF/okOb437xJ+kHAgGAehzXDtLS67
         2wyj/5ItedxInS9dODN7xgwRe9DmQewY4uKeYmFaGZqKx9lw8iVS9mmC7gGHjEzXGhVM
         pg3Vwn4yl8KXR/WLa+NS9XBfR8oOZwX0lDe+ezpilDVKFVULiEeslUnxzeFzIGAZNvfu
         5JDVowmh7YHv2u7oyEoBCJH6ndlQxsiCAWX3Snqd12in/XTB3WhF/r6VRelKRCy6uA+k
         WouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778092356; x=1778697156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ee78RPNdirR36JOR3boeHs0NejiR2ZzTKCoLjSobKZc=;
        b=tLaHHfKLtzqddOYV//r60pgN3AWDYPkXucQk6YEkr5Nj4aqQbxb5TpNx0qWplJ33z1
         4YOK2Xd/S/yj8FcK7nfY/RocygreK0wyMcvWOwlica2ZBIxydoq+OCivJAgOeNNYdPCy
         lbW8YJ9l7CGurKu0hnvFvpQAssni2boQmhZHhXNLXph8qsxH5XP+yhLtiI3KEEUW00iX
         ikqB+y6CAuPKMFspsbu7HczHUFz02toFqDkxT6K7SA58Zl9H67tZFAOBRfYADT0q1ghl
         B5RwC39lDBwMhs+33hPyX9SPwpkVBv0O9e6xk/lLiOaa2JejFD92sqhzpP+RqZMANgzi
         gytA==
X-Forwarded-Encrypted: i=1; AFNElJ8ajwJGvEtQIT5ul6C+S2jwrhiZ9LkPx5u/d0YjSzBI8S0UO/t+9vjYjmmzpNXAyLwz0jXPGpexKg==@kvack.org
X-Gm-Message-State: AOJu0YwXWRIXR3moj3uu8y9s5+TfUAV4nlx8Le8Ktob2DG4hxLZkStjS
	U9KVzJru1m/oGZ+9A+x93DoAF1QNwMXGSeZ9uBpZVKOJUb+FlsGAI+0j
X-Gm-Gg: AeBDieuEZgF5ZnYgZHQXnPH4yMk0Y86ZK8e3Lq5xGqv7/TwwQmbd4pBATjm4UD60QBI
	VhvXjemiNxLnRgQVGRzTRk1xZ+/s3hpiy27N5bd0gug7Hht8ogd3SdKxTLwN3sYhD7qrMHZFh0s
	TfD3qm8XCFX7XUxgs2oYomcWsXDs2cBDfqnFvka1je1r74bOixh+kFjKk0Ae2k4sNZN8AP+7VH9
	XcNKE6N1HIoyH7jYaq7oJtRrOWXgxiWX8ljGM4x9Xup3Rm6UZxuWzK/lFDSuEmVCYbQldQN54ie
	fz1iGqy1krYqesGGj82JANmHT+4cboUNp7kqEX9cRP/VNoDpbShOmGUqJmGCsbwCGVjEJSvXQIq
	+mp+Un4YiwcvlWjolFw2F8dO7GN2xsGWP72gWWSgWpIplVBC44CXIjdjUupakGT8uiNnuP7DvzA
	SofocEPd25OqQZpjL8HoMpVCj1/7zpHQ==
X-Received: by 2002:a05:651c:984:b0:38c:594e:ffd4 with SMTP id 38308e7fff4ca-393c421098fmr17949201fa.25.1778092355410;
        Wed, 06 May 2026 11:32:35 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500:de96:9acf:5dca:ede4])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39360de22d3sm51399551fa.0.2026.05.06.11.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 11:32:35 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 6 May 2026 20:32:33 +0200
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v12 1/5] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
Message-ID: <afuJQTErzaZmlkhC@pc636>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
 <20260428-vmalloc-shrink-v12-1-3c18c9172eb1@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-vmalloc-shrink-v12-1-3c18c9172eb1@zohomail.in>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6FB2E140018
X-Stat-Signature: hsnsmrygi43nhau1xn1s563q17owpep9
X-HE-Tag: 1778092357-330201
X-HE-Meta: U2FsdGVkX1/J9wmGWrpr+RRUTkTeBbMx92v76QPAYqIIbnSibiSl46iOx/frxoPx5vtu6E0nEnMDmlZpnSmcjaQsNHsui+rIgt6HJ5aHXE5+qUNRBydYn0rVk4ePicIfSzwo+ui4h1FlaHHKAdqcP/s9WTxuvysykEjp1Rxiw5sx5O2fK+fnXO7q1XmPO1VUn8o3NqXAJDpLC6R+4zrSar43m/7yR1ipXu5lkaYDssaqfr17PLXbfq/eWWKS1wMZDiOFzP7DTMVLmEcqsJGNDWXweVySxQsu1BPaOeiEM378rZ+ZyDrktP4e3qwuokthCiqwizhPShHuG79/5tFavfMKiCbzXzcaiq9QFTnBnRtKQZ7Dnj6jmyRUH2NrZh9v2pltC0SR+VEdMbmHtJ6h8FYuzvP6GcRpJHJBV9rgnxBpIzkw9fpEAcF55Q90E6guMMHJyAF7HAKfMdWaxPIcsY6Z5aWg8JzbADN3mg7Fo+i6ZM24HOwIiCImOHHAtPHycSVkDRRBrU8t7GnAplwXtHc76ccj4OexScmu3cI1M96kEPGWwg7DW0tHNUIQrTI/XMm8K2bAVcQZYTN8qwEWXaKeTc/1c+h0FdiU6/QkTDKhFLY/eCz+xIvgcQqyruIc/wko/YBv5IiffF38z7hBPmvBMYD+PsYWQ17iHHkNmA9YtwjxDDWXlKwlOao47Vra7eyyhqe2OiPIZj4IaWz5t769+LhYgOUpWafc8KTYcNd2q6KXDvFcUST2dwoRTkFSbDDMEze4+FKVEicTFAFMGRwuW5lD45iQRDyE7EbtfMsCkWNcfTXXfIhKzeNeNEiDWq2suYygfqdrpnWSe9Ne/bvTaKEufJx59undUndpzip3LwTjV5OlFm75Lgdr+YNnfEJoG3lanuaYGVF8+d/kUyw7OWfa2ct7GLSE/zbtCQ8+9Nec/MxmNEzuPQ4e/ivkZPCoS8XbU1aE2oxhwLa
 A5l3qRFs
 ZspJh4B9cbXa3Cq3417UeDVwDtl/kQWWXtxs83DSsubclWJ1P2gLx5iBbdAIg8Y+dusE8Ojag3q6v8IWCg8cGzh2hS1crht192Sqf1eRbj8Nizx7kP1AKoCDbXgLamv9OLw5TFeaqaV3+9SAcsI8nya5ojCHKZUoAfD0joLpHdnT8mQQdGtQwxeJnzU6BwRq7nvK5Sz2+K011RvCChpEM9kPQL4sXPHzagZrSJaGgKzhkllCHym41PTPwKSyRv4UGZBk7Oh7NLiQtlwDwzrdhKr4etNKMzxGU3KwWQJFXmDAXXmfpuWhXHhOGFZA4u8OkNz9qSbJ2x74lxklMcPmm53r2qbeiFzq5YSv9FOaoQGDAxdKnAI2zToL6m2y/2dy8VcJnRQoM9++Bov2aWvrxfCo0go9MqKg+YNg7XnpVq2Hxd87I1yeXBKCfuiWiIrzLXLSCQmHlLsicEM8aFRXO5fnIuLiJX/a+3WyR4PubFr11dO9kpkamM+cplpy3IpYh5nWdJ1iMm8+TSliFoTmZ+Dn9xxAyXYRZCQCj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 01:54:16AM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Extract page freeing and NR_VMALLOC stat accounting from
> vfree() into a reusable vm_area_free_pages() helper.
> The helper operates on a range [start_idx, end_idx) of pages
> from a vm_struct, making it suitable for both full free (vfree)
> and partial free (upcoming vrealloc shrink).
> 
> Freed page pointers in vm->pages[] are set to NULL
> to prevent stale references when the vm_struct outlives the
> free (as in vrealloc shrink).
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 34 +++++++++++++++++++++++++++-------
>  1 file changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 878c5b7bf837..1073abb6094e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3416,6 +3416,32 @@ void vfree_atomic(const void *addr)
>  		schedule_work(&p->wq);
>  }
>  
> +/*
> + * vm_area_free_pages - free a range of pages from a vmalloc allocation
> + * @vm: the vm_struct containing the pages
> + * @start_idx: first page index to free (inclusive)
> + * @end_idx: last page index to free (exclusive)
> + *
> + * Free pages [start_idx, end_idx) updating NR_VMALLOC stat accounting.
> + * Freed vm->pages[] entries are set to NULL.
> + * Caller is responsible for unmapping (vunmap_range) and KASAN
> + * poisoning before calling this.
> + */
> +static void vm_area_free_pages(struct vm_struct *vm, unsigned int start_idx,
> +			       unsigned int end_idx)
> +{
> +	unsigned int i;
> +
> +	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
> +		for (i = start_idx; i < end_idx; i++)
> +			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
> +	}
> +	free_pages_bulk(vm->pages + start_idx, end_idx - start_idx);
> +
> +	for (i = start_idx; i < end_idx; i++)
> +		vm->pages[i] = NULL;
> +}
> +
>  /**
>   * vfree - Release memory allocated by vmalloc()
>   * @addr:  Memory base address
> @@ -3436,7 +3462,6 @@ void vfree_atomic(const void *addr)
>  void vfree(const void *addr)
>  {
>  	struct vm_struct *vm;
> -	int i;
>  
>  	if (unlikely(in_interrupt())) {
>  		vfree_atomic(addr);
> @@ -3460,12 +3485,7 @@ void vfree(const void *addr)
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
>  
> -	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
> -		for (i = 0; i < vm->nr_pages; i++)
> -			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
> -	}
> -	free_pages_bulk(vm->pages, vm->nr_pages);
> -
> +	vm_area_free_pages(vm, 0, vm->nr_pages);
>  	kvfree(vm->pages);
>  	kfree(vm);
>  }
> 
> -- 
> 2.43.0
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

