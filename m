Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E377FCD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9896B0096; Thu, 21 May 2026 22:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1356B0098; Thu, 21 May 2026 22:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7C46B0099; Thu, 21 May 2026 22:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E55A6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:40:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A6291C0814
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:40:11 +0000 (UTC)
X-FDA: 84793501422.26.5ADB260
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9205BC0002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:40:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rxjQqpPL;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779417609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fm97KPHUVYZqun0p/IlrOCNvbRaK3CQJwbnFDIX8nLA=;
	b=dZLhz8C6O6YcVjXbVY2yxkIhLCpZ85H+nnokfIZsbRbRo5nBVAl1T0e5+vm7iLDJU1G7zv
	svihr3fl8/DIVoZ66MT0DjseAikZ8NyfV4tAYEOdNTrgLEf72As0eSbt/TuhNpH87+9uko
	9PnCyCOI+BHoC2CWzZEnS6jRINJJDa0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rxjQqpPL;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779417609; a=rsa-sha256;
	cv=none;
	b=U1RBF+uFqsvgYq5FykK9lqtAFaRyIB+Mt6QWa71L9LdpLPXP/0vkAxJLOhBN0iCmWbpxIO
	gyf3DbdK+a2TpsJfLfqDIFY+sTCSpWSdvdWJuhlPriM8pJ//1C0DnXTHoH0eQ6LOIOItv+
	U7VGc/Se8ecUbA+OfgckDF4AAHZi1k8=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c7980c060cfso3032900a12.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 19:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779417608; x=1780022408; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fm97KPHUVYZqun0p/IlrOCNvbRaK3CQJwbnFDIX8nLA=;
        b=rxjQqpPLQUoea/Ik4knhj3VpeapWDdRrz8HG5jRVh7Ln4z+eClFcVs53qPzRBOca7N
         5KZz3KE07VxDN3f3V0TlGSScPT5kb2yUNkbh52RP9gmA+u6NWRoit+MNo1jZJgH8kCdU
         FuBFFBsrm6CUSwTospY74VXQ7OZ5JZ1WB4V6rseWoWsSjzMkWnk7zhiGSsATBuRHsR01
         ZlRfScaum9F+WpJtxNUeTEKcOiI9cWh+J7uKSGBpnWI26Pitm/4Wpg5WcgrU6VPYCtTb
         xGML4JbC/451fCr0Gro7vT6WSnCcghOGxYFt/0BVzB2v24HkbSjEVYDoVkBk9SikyvB8
         +qMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779417608; x=1780022408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fm97KPHUVYZqun0p/IlrOCNvbRaK3CQJwbnFDIX8nLA=;
        b=ULh3dikBODiD69LU7uIvVNReR7AlBDJ27pVZMAQJS3ig37U4qOhdkVnmUhT6g55nJo
         nXMk0RpCs9wGqGlqfNKcx59zsiSjhbx1pkYhhyZhHW05JA40Nnwl/uaZ0madKHDajhgC
         VFjnpNK4LRaYeGbkky5EuKBp8lyRTKx7zTq/i/d5se3FhetazmLo60gS26xPeIonRlUE
         HQqb+48UobgGyJynabZgi7lCGkPhtpX4F1d8BMS/hXtUz1ebuXkz9iu6EfnDGzfmITmf
         xWzunuyu/PPIRuBxwJpjFLdBPjoIkXZoHRsesiunte5hWvWrWOf0ot3ZmH1N7+cKJQED
         vQqw==
X-Forwarded-Encrypted: i=1; AFNElJ+DftgpDFGnp565fSPuZety19RgY+aU5kWKQIvxLKdtxWwKO2wxuXCluWysiwZ9/p4PWmOZR0JUsg==@kvack.org
X-Gm-Message-State: AOJu0YxfsmE+8BSVSNrdA5MdRMu5ie9oLfNJ8R/3SE7Uk3C+4HYSHFZa
	c0eF1+/3K5q0CYztXpAX6Mxk8JbbAXEosrRtXFvjNtBbuG78VaaSE7WD
X-Gm-Gg: Acq92OHJFKnPB5mL7nGh8GuyqB5tzuCe5Yct2YMMsIRSxNlp4I/mxEwfwMjyTEhBWLX
	Zj78GMilVmxQSTQnmjjrtSJ3CS77IjzQorSPSDK+cmeHoPVGJu79YRWpwxZcygOAJTb9Czfddvt
	hCMtchtNt0g5CLhHIRIP8Jsw8wGlDDgot1FsUG71B3cEpc+aKr6uoh7WZQeNkTU3slVuD4oMgQR
	NCXyC2b+vZeoNvNNYhsczoQgqQQzRMHcGGPtUEEsMDkpPTQud3VSoHYdEs0kSKgVGhza5ruOtXt
	jMvBKrAvqwQqiSeQaUvaRfGkrxIYDS98L8VVU8wS1fZ8Wfng2YvrvcAMs5ntZ66rN7Ou/xy45pH
	ma0sKDLCAMEfZNsbnLVrEdJ2cOwhJIwGmRGAjIhhK5+imHlcfvJrrSn5v+KWN9fCijLhTg6PDU5
	dfPHEy4NwLWiMgxei5jkvnnvogeLF3+BHMmacOnNmRi6C695ExM2yka+QQLz7goZF2slSHanrN
X-Received: by 2002:a05:6a21:a343:b0:3a2:dbaa:82ee with SMTP id adf61e73a8af0-3b328caba66mr1544588637.9.1779417608238;
        Thu, 21 May 2026 19:40:08 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85202901e6sm72726a12.2.2026.05.21.19.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 19:40:07 -0700 (PDT)
Date: Fri, 22 May 2026 10:39:59 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kasong@tencent.com, 
	Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v5 12/12] mm, swap: merge zeromap into swap table
Message-ID: <ag_Bt1MpdF4IIXc9@KASONG-MC4>
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
 <20260517-swap-table-p4-v5-12-88ae43e064c7@tencent.com>
 <20260521185204.a109bfcd1e0e8f52135c5ed5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521185204.a109bfcd1e0e8f52135c5ed5@linux-foundation.org>
X-Stat-Signature: qsoyjnaxawe3ggft3y7iy8otty4zc5eq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9205BC0002
X-HE-Tag: 1779417609-905046
X-HE-Meta: U2FsdGVkX19vjLVxfnqOX7KKW7zgPmwV8sKsAZha6ao+N754e+VC4KJW9OwPj/w7qzTayQdUzbtt1eH9AQHGtnky/Ij8G+YCn3Q3dSEBQ18hTrcn4IYVaq2FwxyDLQ9Ys1pHaOjSdVOkKxI6ZavIY2S0DUXfhYNEa3PAapP16GX8iDmN653MHGTif+Ub73gT/dDtbPzzxjMm52ILRkNZGauZD5u3ngOgU2UfMTeVmipLuibd29dGJBeG2QAv/POT3rOkUfJmEdLaR26n9Js6sascYEKP7ek+EQ6bS9a+SFOV+dSabu81Rs2L6rWIfJSVAxRqvLHJZktjV5JGQzysSOuw9VakRDhaLYuI+xWLTdPPSKchubquDIWtg1bd5s3Q9Ep5M1USrzk2b+pcOr2PZMxPblbR4DcCoVNOnFcv8hJIgWBZNQP1POC8orWJG8mOK/JsJ25Wl1df9/OOYqV4dFioE8IS/cCaxeBrR9QVxgZVcOEW+wBZW3Q86rXu49fWBCoOs3AiFf0GeLlhNhxqxIJbcilxsWBepDem65c4NrF6tb5CBjvMAFsA3bywEaseV+5rp1BKS2WIezra1QBiH/L3eSdG0uoxVFFXbL4cappj9r1ZTk/K4WVNvbTsE+Da4rIgW9o3JVwYmyRnc57zlY7KkVW7yY0YKASwmahEaXqkbtcVlItrAODURANWwzbbPJeh/+JPgu9VSgGd3Qu3oqwiAEmN5sE2l0hyfzsu5xhq0rvuOobW9DXg9fM/nuBkiMYvoRTm1oAjBiR3a3b/c1vBGXsb0F9QHrvjrqjlkW9RIkvIAjBSNsAY9NbDvxhrLGCGHgVA6TYi6/bFxTT9ZIjUJAQdaNao+JAWqR/40VitpLUC7w8gStLqKvNGH99Y7iRXHpenR1ceRMwiah6fap/kRTAODvsqPAzuxnReWlIRmX6zIfM7dcJ36fBN/l73PWMrawuljGkd6fd+kls
 aVl4QSk+
 mhuEvwnW12+q0O6dwFsQFIH5YjBe0uu3yTfytlEuBOoF6y3zw1mBsJCM4ESym9ckWx0zw6V1XT4UWu8i0bsAE6AlzyQ5LNRnv1n7dGqpm8qnJwppmUzsuvjNukJo0rsjIAognnQOr8MvnJfpJzcaBvoT4DhbnjaH7tl3sjupunuPnVGC8UrzeAGeufFjynfM9Z7bOyO+giiZ0/WmJoag7c7NSCW8sSYdVyv5J7J+jMXHeRk0EIcUQ8F6Hz6+o9LLrA4hXsSEhUwpN0cAQ6PSv2Pwb4ZwnICreWqeOiRXclIJbb7mKuDw9/yXYHN7oi0XZdxFPcLWW4b/yD3+OxwPKQgNoTGKkysXENIBOZfvyA6d6O7a2lTiIWFZ9sHQVU0attnBVWlsA6mr7YEUCGsjursuTGurilMBMp3+zOgX+dx1v08VgMTcGL5J9Sv6PY/mqblByMmiW+V2qp+MZf5badCQHNV/M4anMdghSOzxgRuFMT1Jt0eJUrRbYxgfCOMub6rvH9uvVASCHWy02GQKUthPgv0Ra0RVMwwu/gfRWcA7znptWQTROkIPt7lx3s5Mrz3KMJEgaP/zilMpMEazAttiZQlSrwrW/BGn6GPw24c9kDLjyTFu6TzuKIt6pPqgpMhy1B9wE3+fOtYEAyXHhIIUA6Qs/FNNi9T1o1FN16HZo7Uf8SWVsOfoBglX9PTAlJvKJSFstZgHmEML/gyjGtv4Rdp5Mro8oB6o0mAUIlizbbmII8DdHSfZQywFhvDR351Wz9boxAwiC2FyFc1ZNxHOVoOakGRmYnNNesh1z6TQEN5aLf6I8Ge156/CJrR2/N9Q3jtww/aex7VGXfOBr60QLiswOe5XBn97ww5spAuHhcvra0Zdx17qiLR9HKBLjaKPDFJ3KqK3rUfMBmY93MqRPmW1IJmdIk0EJI2fG5b1D4lYB2BEh3cndIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 06:52:04PM +0800, Andrew Morton wrote:
> On Sun, 17 May 2026 23:39:51 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:
> 
> > From: Kairui Song <kasong@tencent.com>
> > 
> > By allocating one additional bit in the swap table entry's flags field
> > alongside the count, we can store the zeromap inline
> > 
> > For 64 bit systems, zeromap will store in the swap table, avoiding zeromap
> > allocation. It reduces the allocated memory. That is the happy path.
> > 
> > For certain 32-bit archs, there might not be enough bits in the swap
> > table to contain both PFN and flags. Therefore, conditionally let each
> > cluster have a zeromap field at build time, and use that instead.
> > If the swapfile cluster is not fully used, it will still save memory for
> > zeromap. The empty cluster does not allocate a zeromap. In the worst case,
> > all cluster are fully populated. We will use memory similar to the
> > previous zeromap implementation.
> > 
> > A few macros were moved to different headers for build time struct
> > definition.
> > 
> > ...
> >
> > @@ -469,13 +474,21 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
> >  		VM_WARN_ON_ONCE(ci->memcg_table);
> >  		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
> >  		if (!ci->memcg_table)
> > -			ret = -ENOMEM;
> > +			goto err_free;
> >  	}
> >  #endif
> > -	if (ret)
> > -		swap_cluster_free_table(ci);
> >  
> > -	return ret;
> > +#if !SWAP_TABLE_HAS_ZEROFLAG
> > +	VM_WARN_ON_ONCE(ci->zero_bitmap);
> > +	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> > +	if (!ci->zero_bitmap)
> > +		goto err_free;
> > +#endif
> > +	return 0;
> > +
> > +err_free:
> > +	swap_cluster_free_table(ci);
> > +	return -ENOMEM;
> >  }
> 
> My m68k defconfig warned.  I'll do the below, which looks good enough. 
> Please check.
> 
> Perhaps a custom guard() handler would clean things up here.
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-swap-merge-zeromap-into-swap-table-fix-2
> Date: Thu May 21 06:39:20 PM PDT 2026
> 
> mm/swapfile.c: In function 'swap_cluster_alloc_table':
> mm/swapfile.c:488:1: warning: label 'err_free' defined but not used [-Wunused-label]
>   488 | err_free:
>       | ^~~~~~~~
> 
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Youngjun Park <youngjun.park@lge.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/swapfile.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> --- a/mm/swapfile.c~mm-swap-merge-zeromap-into-swap-table-fix-2
> +++ a/mm/swapfile.c
> @@ -472,22 +472,22 @@ static int swap_cluster_alloc_table(stru
>  	if (!mem_cgroup_disabled()) {
>  		VM_WARN_ON_ONCE(ci->memcg_table);
>  		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
> -		if (!ci->memcg_table)
> -			goto err_free;
> +		if (!ci->memcg_table) {
> +			swap_cluster_free_table(ci);
> +			return -ENOMEM;
> +		}
>  	}
>  #endif
>  
>  #if !SWAP_TABLE_HAS_ZEROFLAG
>  	VM_WARN_ON_ONCE(ci->zero_bitmap);
>  	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> -	if (!ci->zero_bitmap)
> -		goto err_free;
> +	if (!ci->zero_bitmap) {
> +		swap_cluster_free_table(ci);
> +		return -ENOMEM;
> +	}
>  #endif
>  	return 0;
> -
> -err_free:
> -	swap_cluster_free_table(ci);
> -	return -ENOMEM;
>  }
>  
>  /*
> _
> 

Looks good, thank you. The error path is still simple and
straight at the moment.

It will be even better if we also remove the now unused ret
variable as well (this isn't triggering warning yet since Kbuild
don't set unused-but-set-variable by default):

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9712cc862c9c..615d90867111 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -450,7 +450,6 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
-	int ret = 0;
 
 	/* The cluster must be empty and not on any list during allocation. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));

