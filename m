Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A930FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 22:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51BD6B0088; Sun, 26 Apr 2026 18:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02766B008A; Sun, 26 Apr 2026 18:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18336B008C; Sun, 26 Apr 2026 18:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC7A6B0088
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 18:06:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AF901A0696
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 22:06:42 +0000 (UTC)
X-FDA: 84702092244.15.D93FD77
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5C8AA1C0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 22:06:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i1Xcpkds;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777241200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xF/9PrWdSCugZscSXWokV8Z5ndKFNcsdESXX37E9bAw=;
	b=TBUy+APk01url94XRNUqYqWTPVTmP331viTx+h+FcIfWDUYLGKmKuvhzHxjf2lx49B1j98
	qOfi1Uhh4lxFneqdcH2Hfu3VFLWwKoru4VxTtxyCiOYCgjhBsvZfs4u+8JMg4MNBsoPfS3
	xfT7Z14dgyy2IMeVWO6HN1VVS5/ZzPY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i1Xcpkds;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777241200; a=rsa-sha256;
	cv=none;
	b=aIoMkE+Lfvo8ieLV6IJ6HhUkvBhzBYDGgY8bIo1faLMyr+ftzlITaIKJdDmmXqJBsfIq21
	5Z7RS3o0LxPAK9hbHIWj8Vu4RFPThZwGqOSNcc55oxEZ0gT2FD1Re05nmlvXMRCu3MnuDz
	ZAtx/+MVK7tZPfkFD/TmM/5Q3DF4TPI=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2b4520f6b32so13516410eec.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777241199; x=1777845999; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xF/9PrWdSCugZscSXWokV8Z5ndKFNcsdESXX37E9bAw=;
        b=i1XcpkdsSphIYeeQzlVngZkcrUw2Ih9317yNi/02zgDKNeJgdunlZn3EyWvgBxtQr6
         /zup5Tf3no3+CjPv28H9syZ6Ig+SrthhFpOo16QnOwhrPPCABE/nWruPKbo9B4PVDwo/
         h0tUkGzshwRU/5zx1+6Ct7zFqULVjV+yI8BYfpGi5Qh0ED5RkH73bDTcv3+MxGs486an
         GHbcAkHdLl3nDs/c1fo5bFioJZgZE+uPU5jpiz3u8dCuVfP+1Jm/puyo6wwDGWDh/5lZ
         y9/kgyvRZRuqlCntX1rRLAAe3ayuAPkjY7by3kgAKPYWMZROegqoFB8J8jp/8pDsJitD
         Z4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777241199; x=1777845999;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xF/9PrWdSCugZscSXWokV8Z5ndKFNcsdESXX37E9bAw=;
        b=jvJBgXq87GUiCMqvmrTkLF4dacgfuYoA+4g8rjg5Mkw+/dfo+ApXWk6xc6ETB7WvoP
         SfeMipeV/+R8Xlb4knvglIrDg114xEZswdpvgZ3zeaiNA2IHzwmsXanQVT24c70mom1C
         mx6fw2PXd5nX1L4MpBHRVcSW767zZHX5wpNApUS4sbMQERKZx7oJiiAENTx5AV1gqu6O
         3wV53OUHEWUdzSNKxNCBszXmhjYzyWrGgCuXroJByCo5JLvUybB6yrMm6SnDO00sHNWO
         wMKRYiWxQYVd9JZL/fHnSponY0cTPb1XECcw/J6efILl7ZwgMwv1rI703ec3iWYbLBCg
         Wang==
X-Forwarded-Encrypted: i=1; AFNElJ92k1skhVTXbUuUyJ2iGxwT4ORvg6ggzvQZx+FWHcVVtFPDh3Cu9YUklPDU2odjtH58apnyqsagHQ==@kvack.org
X-Gm-Message-State: AOJu0YxJela/Hza4RJQvG1gUwmbPNZJs7qlBQRaNXHvIXHDwwFkT+VxO
	P/Y5RmkYSABhjayzVlJdkEKrAfp2r4qBAsVdg86MscB8+BomD10fmK/m
X-Gm-Gg: AeBDievFcHKiMApQ5LcQQMmhKK6WMhaBWnBfbiegp7rj+wpEdKMPShS03NKDprKpS5p
	rsPqdwlYvuj6/zXWeksZAlrvFgZpuEimPytwTcMIvt70OWcM0rG9ztgQMnmGLpfwshnL3pqgvv7
	0ze4Fe4OgVSi1s+Nq8dyFKXRY9tE46BIDDOIas36lF2/cbLVmmHqpFFQ7j13hzv1Mu77MWc2wXq
	52JYAbNNNMW5Nxluh8WtFtmBWHeJ8bROz1HVVEfXJgvZSJYzTKQ4uivjbl1EFrd3hV8d0gSRm4v
	NrJyZEud9xVmaX9xYGEEiCQd1CAiWhN9A2OF1zWSqBnDtfNd4XejXT/4NuhBEUug9Bbu7eFOY55
	e4z5bDxSBx4vum2hynE/JV7IELnDeadNrbKtDtxkwPtuPMVwW/yqfHeNYCmdMh1Qr78Ja5h2cnj
	OdiFXXedaMPF6nKMiTickCPW6TftiG9R7ZrX7skg7Ndt7ohAM=
X-Received: by 2002:a05:7300:8c9f:b0:2e1:e3e6:2909 with SMTP id 5a478bee46e88-2e465487fa5mr21912607eec.9.1777241198958;
        Sun, 26 Apr 2026 15:06:38 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90::47b5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53ac84c38sm42170346eec.13.2026.04.26.15.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 15:06:38 -0700 (PDT)
Date: Sun, 26 Apr 2026 15:06:35 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, linux-mm@kvack.org,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH] mm/page_alloc: add tracepoint for PCP refills
Message-ID: <ae6Ma68umBlqVdSP@fedora>
References: <20260425091335.346504-1-b.suvonov@sjtu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260425091335.346504-1-b.suvonov@sjtu.edu.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C8AA1C0005
X-Stat-Signature: 5qdbkzd1j1agqh61o1a48dydr9odn7et
X-HE-Tag: 1777241200-813043
X-HE-Meta: U2FsdGVkX19FC0Ih8nBiUqxL2tTuvUtu7ShrcNzUxJ3Ia+ltoJoP3wW/MkuFhBW4TH3dwF2E7OWbb1FY4nDuNFmMRo33TE6XVwSMDwjIzV3FEZxjrRvomstyvHntnGxQEOnMLCG94gNoQxRJgDrdvToZwDY+4Bhfw6DKQLKU90hkRP3i20jgQrF+AUwmpoEqOZFGw8oUWdetIeHm5qlN2c5Uxe8CKBXTVptjW5ur6BbiT71n3jUzazUskfgoJg0M4Zev4wPL+ggAU+79LUh/3CmWweL6D+4V40R5hnvvPmVZRx5hHSnCbivEuLrt3xe5M5UM6v/ry+ZU8kzCOn7Fs6KdYZbxYPW65CmUIV0Q0Qmx7r3eD2XFxGeg+YzjiNakrNZlL7tkfG7l4GUpb1gAe9QVJhVu+/9Ni9US6MyteEGdEUSRF8dJ/y/Vfxik9oRKdxYEPFlqKWaLMHgH7LFAyN41Q4NOo0TIr9MEeCGeCRnkWEtRfmcRY/4NBAYow5E7AGqdTnkEb4UqwIewNbT2KGO0GVzwRfi3QC07S6UJ6ObWFkLkATkGaBwy/pjF6tupleC7Ev6nNpYCkomTkQ52WyKIPT34i9cZORHh7nebQrIyArI025Ph0fy5rG6CHXTy6IRrAl+eYI2Dc6vVPhqDdTqGGiOsolRLI1/3KxlYlTUvnY+AMKZs1fNn3pmByOFWDWcBc9P60OHMOrnghiIj+NULCo8jBnpyQYxWOzr4IQgQLdQDJTeJOdEyIXBxLMOcTW2zNnNCTXBPqNwoLJQ0BGzUIdSxohdMczz/nwVaqanlLfdj9/4VJbeTzXEN7jSzC3gdCKVi1hLWq98VjImQsBiJK0OigA37qpbAOw55DIgPyHvrJooWsTLRm5cUdGM4tuFOiWkGtj69x1SuOelM2aipU9BGfflHT33R5DV0BVLgVDCER+bp4/BXpAz0NeGtjTJ/NMXgMn7edFQfwrk
 aELqm4nF
 pV3jqYUeHI8HYzA4sVrR83uDOgGIe9ho6RYDYyQM+VtCJQFmk7FGYhqIAZGg6S0zJ0loWGPHIiZoNCezngy8g57S62X6PEnWlloElv4VI/mLpx2F6A3EFSQVqq9CneOMaUaxrUjlV10FpZXB/sDAHjvea1G64A/lJSaF5DHe8qc/Ogy35cDdbUmKoogqOKbegqB/XASuw29BfS3xfo79pRlhkwngvmeDIgUez05aSV1vdzKcyGv+ykfICSd1Zd2sr54X3wz0ZO7mf+5W0tqOe2K+H7h5gse1jn5QwUEJPkUdSGNmsOwIgV9QHH6hPd55qGASDjAt9YT83jfzlegv5cE2SAHc3JJ32EgIeCrKs+Gr2JICb8WG3nXawG40Cv0G+PMHKzUUBtldli/3LMR81c3DAyX9HjkrnPhQe5PK8mOkHqnouKx5DXGACVG+u6QaClMGUS1yXUUS6EL5Ldft8XIe11BjaCLh4Y1+AwETUtY8ZMqGyNYeAHzKYDRxYxEqI0ap5XNIFWwxGqhXJybgh3I1OSFCmjy/TfNmAY/j4neYlrR6ku65LSnEYgWw2k+DuKiaqcxfBJSfn/30xsnYjhUfN4ayQZnzq7bLslrDjAReIL3momtjIbPKVO4p0N/dkC5kpHH50nWORrfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 05:13:35PM +0800, Bunyod Suvonov wrote:
> The page allocator already has mm_page_pcpu_drain to trace pages
> drained from the per-cpu page lists back to the buddy allocator. There
> is no matching tracepoint for the opposite direction, where
> rmqueue_bulk() refills a PCP list from the buddy allocator.

This sounds like a reasonable idea. Does this tracepoint show us
something that a workload might care about? Not opposed, just curious.

For future versions, would you mind including documentation about it
in Documentation/trace/events-kmem.rst?

> mm_page_alloc_zone_locked is not a good substitute for this. It is
> emitted from __rmqueue_smallest(), which is used both by rmqueue_bulk()
> and by the direct buddy allocation path. Its percpu_refill field is
> derived from the allocation order and migratetype, so it does not
> reliably identify whether the allocation came from a PCP refill.
> 
> Add mm_page_pcpu_refill and emit it from rmqueue_bulk() for each page
> added to the PCP list. The new tracepoint uses the same page, order and
> migratetype fields as mm_page_pcpu_drain, making refill and drain
> activity directly comparable.
> 
> Signed-off-by: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
> ---
>  include/trace/events/kmem.h | 23 +++++++++++++++++++++++
>  mm/page_alloc.c             |  1 +
>  2 files changed, 24 insertions(+)
> 
> diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
> index cd7920c81f85..16985604fc51 100644
> --- a/include/trace/events/kmem.h
> +++ b/include/trace/events/kmem.h
> @@ -243,6 +243,29 @@ DEFINE_EVENT(mm_page, mm_page_alloc_zone_locked,
>  	TP_ARGS(page, order, migratetype, percpu_refill)
>  );
>  
> +TRACE_EVENT(mm_page_pcpu_refill,
> +
> +	TP_PROTO(struct page *page, unsigned int order, int migratetype),
> +
> +	TP_ARGS(page, order, migratetype),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	pfn		)
> +		__field(	unsigned int,	order		)
> +		__field(	int,		migratetype	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pfn		= page ? page_to_pfn(page) : -1UL;
> +		__entry->order		= order;
> +		__entry->migratetype	= migratetype;
> +	),
> +
> +	TP_printk("page=%p pfn=0x%lx order=%d migratetype=%d",
> +		pfn_to_page(__entry->pfn), __entry->pfn,
> +		__entry->order, __entry->migratetype)
> +);
> +
>  TRACE_EVENT(mm_page_pcpu_drain,
>  
>  	TP_PROTO(struct page *page, unsigned int order, int migratetype),
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 65e205111553..a60b73ed39a4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2544,6 +2544,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
>  		 * pages are ordered properly.
>  		 */
>  		list_add_tail(&page->pcp_list, list);
> +		trace_mm_page_pcpu_refill(page, order, migratetype);

If you're trying to trace all pages as they come onto the pcp lists,
should you also account for the free_frozen_page_commit() path?

>  	}
>  	spin_unlock_irqrestore(&zone->lock, flags);
>  
> -- 
> 2.53.0
> 

