Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0123C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 11:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4243C6B00C2; Thu,  7 Aug 2025 07:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5346B00C3; Thu,  7 Aug 2025 07:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F11B6B00C4; Thu,  7 Aug 2025 07:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2088E6B00C2
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:25:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E43AE1A0A76
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:25:05 +0000 (UTC)
X-FDA: 83749729770.17.F1DC507
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 053E5A0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:25:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EtActKnJ;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754565904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqfBgbGZxLexl9YPolWTb1p84K6htyylxIPfQDbb+oI=;
	b=7BUSO0GCl/seinnfpg/HU45I8DEt5dOZhM5xGANCjOP0kNR3I0YgdTdhwmxLaB06DDkBmf
	qgdxITNgSuaKtNU6wQfkdXPnr6CudXVc4Zt/yBA03oX/LtdKkENerVSn078/8x6iJaQ83B
	Ob4nzPiEepDoniYuWLJFbviqELt+fkA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EtActKnJ;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754565904; a=rsa-sha256;
	cv=none;
	b=29B+wBCSGTWVSVt6anV70GKpSEnErviFAyr55cAj1gbIKrRJNVU3bayshey8Qybr5ohB7y
	n24fYumaqu9Bc/1b0nKdInPw3X8Bm0O3bSJ8Bdyzyf37FE+k8RUfx8113KnBUSJYG2oMNy
	veFM176bXGksoU1SQELp4rFpTcmm+VM=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b783ea502eso670283f8f.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 04:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754565902; x=1755170702; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zqfBgbGZxLexl9YPolWTb1p84K6htyylxIPfQDbb+oI=;
        b=EtActKnJrV+uC6sAv5YSO+ouVfd3UPB+L4pd1rWa9FsCGqh4IdBwn0wEtjNMRl3FyM
         eUTGxls+lGZVpD36wDpY3efvNm92ZfGSxNOQLQeTn3+5sFTcVk6xr6LVTNOdShx1bro8
         i8WcXw2b9XQtMzrY1q5oUIB2+LrZ1danAGiUCnP3SETG12OMKB6CDCB0d8kHZ7MgKqaY
         /KuQuCy/d/k1opQz2wcb4NJDF6edhfRY2WV3MQtraHwPHg4mkiADlV019hk1LLYSbm6j
         jIveil9i6BzCRpsFPpTARQJdb3j0oNoMiicnfQxZTiiOHcLFxIIqOjeWmZWOiUbpQK7V
         +klw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754565902; x=1755170702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqfBgbGZxLexl9YPolWTb1p84K6htyylxIPfQDbb+oI=;
        b=hP2cB2DYBJJEgdQENLwomcAQjzlUYURYmFi0oHKJNCA1KYCIpJKRFrDLURIlJKO2vH
         bsQdeJk+jHXhaKemuKtix0sEj2ITEI+Re0+Hkn5x2xvQAgQrtrN6wAbEk3Cb7RV6l0Oq
         wh8b3xu28zd4l9COgyTL8w3df9e4YB0M+QeaicGNDzn+kS7g8jzCwfO6S5oTBqP7BAdt
         8/O9KDQCz6TlwoVm4/t7YXTeTSJcEnvDShCEcidG5TtbBXxFniGiqgxSxDUV7jqYkamo
         bXc9gDTVsPsnKlJPnXK1rSJ3JVKLrJsOgmDCLVSz4idfNlqCzw8MpMuHUblV5sDBRpLG
         qGAw==
X-Gm-Message-State: AOJu0Yyw9Ls0pZzhafkindo41pQ8/8iIs+m8Vo9fvl0bSoAOYyR4yDek
	758SqIE/C/R5yzWdV8krtNDN9XJd1YjzU49n73oyukN0mUfu1FbBVJxolDcBDlk6RI0=
X-Gm-Gg: ASbGnctn673WVvnboBqcFj/jxZDilBYg+0q6DiqJqAy5pPYFEViJh2stRtdONqnL7b3
	MNIRUBATAfKl2HH7cWrvOxn2XdqlMPp5w6Nok94HhMIFRlDqXbeHQQl0ZVY/Wfw0LdaFGw3p/b0
	RslMWbFBGm7oqtmqOX9GaYtOzuQX7h3xHiEUKrZhiqWscdBtVkp2UFKHElyLfOvUD8n6i/eygJl
	qaHMTMtxv5eftxiFgrwrDYbb98taPlGIdZhoBldy6r9AIVRev1yUVhvNt283XFlCBZ6/yVXk7td
	FmP/yxssHXZ1gxPc+jaELaDhRdYEvUo+Jx4Ehm9iVKdJK+S/M5Sarbm46s2oJo9w2/kbey24dOW
	2GXbRVH9A3/MOmI+0F8BQqjWsI+2njuF0MdovAmYKzgHTMQ==
X-Google-Smtp-Source: AGHT+IFke9/I6vAWg281k3PGpP+cXL76PFDyxOcVdfRR48mIHmjOc48urydXdscm5wsfvX8iadHkkg==
X-Received: by 2002:a5d:64c2:0:b0:3b7:8ed8:1c80 with SMTP id ffacd0b85a97d-3b8f97bc3e6mr2526097f8f.3.1754565902572;
        Thu, 07 Aug 2025 04:25:02 -0700 (PDT)
Received: from localhost (109-81-80-221.rct.o2.cz. [109.81.80.221])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3abf33sm26573824f8f.7.2025.08.07.04.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 04:25:02 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:25:01 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] mm/vmalloc: Defer freeing partly initialized
 vm_struct
Message-ID: <aJSNDcMxE5BVl6or@tiehlicka>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-7-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-7-urezki@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 053E5A0002
X-Rspamd-Server: rspam06
X-Stat-Signature: tkbwhsppmoz1iw7t5bhsmm8mafqp37rz
X-HE-Tag: 1754565903-169850
X-HE-Meta: U2FsdGVkX19uLTL8NiObLgiuaAFs2hbuSo5fDLFQV0JXW1CnWCUVCdc3DlYdckTEwmb7M7rzj4rDGVqZFwPPgTMX/hrH509fJqbQefj/Gl8U07WAlb5RATLBlkbJNoquA2eBdxDJREruSqGSQw9uVqj70E1s3JuYTojw+oYTYI3SkrhcMuigHMQRI6rRMy2/ecioZh2nXYr/ZJLrWKVdZ7uVUh0I1mxQzJpUcLDlBoWCSImHARVzIXENXArMrTx22LPDHDhlG91hZY4V5ACI7z//JWAZiLgag0Wj9+D021PJuajWUVU8gumNXZSPPz6pyZRgg1nEpvTb66rCn784zAJ5Pz7F9x9pVe4HsjrC2wltcAfMG/grASQBJthXx9v11+OKnREPeIUl9rrzDEgNGek7Etu7SqHgxeNGIrg6a7kZCZTGO6mTWA+0l+/V1lQ2lYftRhffud2pRl6BaM42ESIlRGrFf/PFhMHrhkggbN67HZzTgJVMYKC6OzPEJhuhBvg0VyvokMycv8opTOqbA3PP/Zqh5AszHeUomztDuk553ulmDTj0S1SVmiK7/9JVHdruH4dlH06eoqI32KZCbvTk4Yq4OfILAeQBDDGzg9/O8fl25zedIQRmbGmmdsuv/KaHmMExW9NBfuerTcxMnlVbG5yBEk4mioCgHmhY6QGY/4082yKRxS7M3ngbPKKM86sgvWmTNQgCix+bCwP5juROMSqzH3xosQx4qC3cPXDiccYZTOLyNPIjT4sXLNxJGNjWzfVa+y63DAlq3b6UYBch4Q40pEIHPYYZ5Xafs7neNlUKIAzsdtDYgzhsnH3W+P2CQOyuV2ql41gb4P8PLHldeWrRCENj97KQM3zroQo3CxZKil7vufruXoDjJP3EAyj3/XjcCwa0B+cqhRzVVKBPR31y74TGFfYtyvS3MTfZqeWxKCByl4qcoNf1t5AJYe1eDMpYSSNSFOcOoUQ
 JEqnxeu3
 Fx2mbQ6XBuoVXLVhArmtPR/7Zna+5IIY2VjLZYywnACBfzh9d+HG2j3LfSKzbrEx+K3CN0nXZqKR8Y6qV/6hTJFodleJYgg3XtBietJAlue6YbDeihrSeXRvcIz09zRoaddJFZ2cYVwTiu08N2GSTv1c2/pVss0sRhnEFqPVW8XWw1G6TzK5ow/47PF9p7qULo9tBc5Mx/Ev7OXQdR9rhOzjts1yihL8l1BOL6Wdh+24fy9K3Zc2CWT0yn0tjf0j0J+HH94qIo6ZyFc0jQmUlPvrc3SnNzQC5gm+QwyHI3gt2iJvTW1001wmG42dSRER3V74o8peD7XUOQ5TaJ2bqEGnz12e/wsJ0VWJ+KV66eTKsopCILyghluHLtz4SldbFzf8mtrpR/7pq3KX0BRRIqlrZ1fQQQEWu3ZAi7HW1QnWQZPu3mMELSmBtsUu3qIqvAap12RaCoqx+JkRopq9jwh/9tL8mFq9QqIrc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 07-08-25 09:58:08, Uladzislau Rezki wrote:
> __vmalloc_area_node() may call free_vmap_area() or vfree() on
> error paths, both of which can sleep. This becomes problematic
> if the function is invoked from an atomic context, such as when
> GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.
> 
> To fix this, unify error paths and defer the cleanup of partly
> initialized vm_struct objects to a workqueue. This ensures that
> freeing happens in a process context and avoids invalid sleeps
> in atomic regions.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

LGTM
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/vmalloc.h |  6 +++++-
>  mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index fdc9aeb74a44..b1425fae8cbf 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
>  #endif
>  
>  struct vm_struct {
> -	struct vm_struct	*next;
> +	union {
> +		struct vm_struct *next;	  /* Early registration of vm_areas. */
> +		struct llist_node llnode; /* Asynchronous freeing on error paths. */
> +	};
> +
>  	void			*addr;
>  	unsigned long		size;
>  	unsigned long		flags;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 7f48a54ec108..2424f80d524a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3680,6 +3680,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	return nr_allocated;
>  }
>  
> +static LLIST_HEAD(pending_vm_area_cleanup);
> +static void cleanup_vm_area_work(struct work_struct *work)
> +{
> +	struct vm_struct *area, *tmp;
> +	struct llist_node *head;
> +
> +	head = llist_del_all(&pending_vm_area_cleanup);
> +	if (!head)
> +		return;
> +
> +	llist_for_each_entry_safe(area, tmp, head, llnode) {
> +		if (!area->pages)
> +			free_vm_area(area);
> +		else
> +			vfree(area->addr);
> +	}
> +}
> +
> +/*
> + * Helper for __vmalloc_area_node() to defer cleanup
> + * of partially initialized vm_struct in error paths.
> + */
> +static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
> +static void defer_vm_area_cleanup(struct vm_struct *area)
> +{
> +	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
> +		schedule_work(&cleanup_vm_area);
> +}
> +
>  static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				 pgprot_t prot, unsigned int page_shift,
>  				 int node)
> @@ -3711,8 +3740,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  		warn_alloc(gfp_mask, NULL,
>  			"vmalloc error: size %lu, failed to allocated page array size %lu",
>  			nr_small_pages * PAGE_SIZE, array_size);
> -		free_vm_area(area);
> -		return NULL;
> +		goto fail;
>  	}
>  
>  	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
> @@ -3789,7 +3817,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	return area->addr;
>  
>  fail:
> -	vfree(area->addr);
> +	defer_vm_area_cleanup(area);
>  	return NULL;
>  }
>  
> -- 
> 2.39.5

-- 
Michal Hocko
SUSE Labs

