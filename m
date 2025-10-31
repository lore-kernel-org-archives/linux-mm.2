Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E80FCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 13:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADDB38E006F; Fri, 31 Oct 2025 09:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DEA8E0042; Fri, 31 Oct 2025 09:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955238E006F; Fri, 31 Oct 2025 09:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D94C8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:58:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 286CBB996B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:58:25 +0000 (UTC)
X-FDA: 84058564170.24.1BD5D26
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 298DF2000F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:58:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kvDYZJY+;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761919103; a=rsa-sha256;
	cv=none;
	b=rfYck6/cg8/HyVsJx+ncWI5j0OmvQzMKDmdIy3revGenJLT7MWKt7GuP/G/wndB7iENbOn
	opWf6VNCIbkkpYBFmdX38IEgh9Hep0bFELoYYLUL2FfVgYArxQDL4ACxGVS4ganI2PpG1v
	0KXP1OmcjxzT45p5h5GFTLcFKhceNvI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kvDYZJY+;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761919103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4S0mka8jGiqhtu5Z/8KUXJ1hNRdqooEO/ICp8xqPw1s=;
	b=sceJaaVOzc48MW7fYNroDLU1qsBklWfl45ypFq6mj0KT7bPtxeK7dHPbEfstdgMk7NgfaQ
	Xw9XVaGGBZsjnJH3qllxw/KGFv3EWr784C+6AyXlRsfm7U5td7pnknzlpkwhRm2zsyCACZ
	rBitjEXziH2goB+VWYNExCChm5WFk0Y=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4e89de04d62so18699491cf.0
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761919102; x=1762523902; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4S0mka8jGiqhtu5Z/8KUXJ1hNRdqooEO/ICp8xqPw1s=;
        b=kvDYZJY+fl1jbnp25wUTfMn5Gh8gEN+9ATq1N63HGFgzFvHtxmhfiRVJA0ahYz7JhR
         2W00jtmYFVFKLdJN9TDUmDWcf6P9vMk/QnB4aRNE98DS8K+IHIyai1xX/XsMnbaRlc3q
         bO9calWCbYmHduFCCGYo1t2vHNZe0ql//3dDEibl2hLVi+QKgbG0VwYA5qvlDA9Zh2ts
         TE/+VS+8rmOJFDJtecuy9ZBUSps8yeZDNxb335jfgg7Mq2FeMBlUfn2c0x6UbRIItelI
         rGH0BKkA8XG/yQtQrWlLHEQH1QfDpU5NVWpL2QAdEVFlXCme0QK8FtW3m/8w8TSjvWZ5
         WaEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761919102; x=1762523902;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4S0mka8jGiqhtu5Z/8KUXJ1hNRdqooEO/ICp8xqPw1s=;
        b=aIqFfCmBK4VSQzJsXkUEgLFwQJVtTrtIcrjbFQ0A/4ABKiys0QXFAFoeP8+JZUg1Rf
         fr+s5Nl+jk9EDlDPcePrAZZ1Cj1Ly0/G8s0cdfd/WBJob6okLzdSBM8zZeCZKCOQ3fmv
         FmlRYqwY8eXyKaY5Lb8c7cw98v6nYaLvqgtyyEQbiY5K11/zxtNLY2Yz/vcPUc1GGo6f
         Wqx8da+Mrbg8Pj7qWbeS55cOOxSG93fuY4TIJ9oWiwerAsoe8jyrrleVaj80KoJcHCve
         41FzvyigFeYBEfBH7H8bpqYtS9HFpj7fshyPTq9kdRq7+4Vz7pFSDx/WgspSLI7JwaKU
         XnTg==
X-Forwarded-Encrypted: i=1; AJvYcCUmDe6F7r+q1tJAEKQ33UvagWa+9hx+1AmOuTNEhl47LPnTaiGGCQcRCG1X4qqbvgHn2mnrP+rzLg==@kvack.org
X-Gm-Message-State: AOJu0Yw3oFQxAzJM+zg/ZOxHjbwnFTTmDj8Rw2XS3em3L3XnKGPKmbvG
	RgvVTOMTttZLcik1ZRlyxpaOZpr9KMimuc/VGylqNl20Oib65qLdHvvRHIgNjBfWWag=
X-Gm-Gg: ASbGncsz/T3FGndYjYN5CYjWLusdpyN5jwHCRoSZfuJoVgT/jQa07YBng1ASSk+gsW0
	yjMWadDABMDQjv3F68scPr9Q3S2znR36Z7iGCdpUVESn7vB9nopzH7KuA2pG5TAi/OOJaQps2Dl
	pND9y3vESVJYVroTzW6wSc2PmL+1xzR5nCoKQzwsDXt95uj2p6ubneMv3IFRlgBXAOrF+jXynUq
	LruwcuL4lM6wPuqvwpu9W9PmcjwmM3r4OjSyQUyxzLhZdrAN21FhJCRpK1Mb1DlO3oVqTVhks7h
	U1L1lGKCXK3kR7zMdCi/QLXdEpvTsyG4rXVqGC0mp5RopO0u2ZhXyGNlyg2Z4x/t5LoTskrdyab
	2lp9n3r2ePjE0uuRekDjbUg5EUaXdGrirvEwxmg+MBPXb15dWwW46JBmrLMycNEctlZVlwHeOye
	RDDVUUOHqZyNqYXnpVc5p0chS9tQginWiQC8V/6gBo6QrEHYDdQ0vXhC8ym9Q23yCRDoNNRw==
X-Google-Smtp-Source: AGHT+IFUTwsA2dbbxdluP2M6MQtg1EQ3qn+mIRsc6BUtZCrQZJJLWzhdFTNRyqmV7Af8J/4OoxxHWg==
X-Received: by 2002:a05:622a:1985:b0:4e8:a3ed:4c50 with SMTP id d75a77b69052e-4ed30dd6d5bmr40807401cf.24.1761919102031;
        Fri, 31 Oct 2025 06:58:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-880362d7baasm11755356d6.33.2025.10.31.06.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 06:58:21 -0700 (PDT)
Date: Fri, 31 Oct 2025 09:58:18 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: declare VMA flags by bit
Message-ID: <aQTAejgLn8_Er8RF@gourry-fedora-PF4VCD3F>
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <a94b3842778068c408758686fbb5adcb91bdbc3c.1761757731.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a94b3842778068c408758686fbb5adcb91bdbc3c.1761757731.git.lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 298DF2000F
X-Stat-Signature: sf6woftjqfsa31gtm8yzxusk1z434h9p
X-HE-Tag: 1761919102-809402
X-HE-Meta: U2FsdGVkX19ErDQvh5ktSZgtJiVebAnqzeryyJHwwexazoUHUG1106u0FtA/Q7XE8TwkNb744AOCqsnhxzUY0gSoEnYvaGV/jd9w21qfWDU3zq43UhHICd/DJF4dX6eI9p4qc/qoX4rG0c/srYp0gd0HeRm+UuHBEjmigJ5LSLfh/pZo9xm1jzUmZoB9zgUMUprYggoJulUd86OtK0rqDuvgDh1886aZGqF/nSMTLpbr4JboBvOhmRkwNvJQqzVqMIFR1h9MmM6V72Wr1pbHuF0nzsOjcjGtwvua5wGMuc0zSa9NqgBRj4C2k0ZRnrjxlTWDkrfkB/Tq3aypGP+zkWDFR/7YIdleVRVoAIHqYT5xDbedTVA31/vOO2j6cupTarGppISQnPory0FND8KdOVcpBYSfCNBWkefKWm783meEd0inTKb8eP7HJkJkHhODTiQkqlGhn0pOEToZwb+cUJ9vbOSWR31JANHqXIO+2cMH/Q2GDntIFOd32t2C+9S9LtRqJ1uGhH0q6UGRPYmnzSIif+T8YGjSkLDt3JewdIpy9ygoegGpo7KDHZNQuFUGFgbkwVZz8yG27eppCuhoVj7IC1x/O+urYwjj8OiNE0n+/FUPZ6s/DxjxZnhEAuucDw6swPYT7lpNu7JWcqC7wvfsxzW0LbA9Wzz886G24ILEC1y6SfvGTtTKKB1lv2DYK/273T02lunhHOkQ/xv0FdsSO5UrrCHb33XgUp6XngELW65SDn2KlKs0MbNf2aRYGKzfriI8ZcWj7vZojMNPb+3dQF3vxY7ZgxIWY370fQ0VdjuW9hRVFbkdhOrvDkhascLKWBP4EELnV6LqKaFcazPkGGzJMD6MDuT75OPuncsX9n3ZYatUghRnfEhRFOqziOiRYJDK6Dp3piMvPgNhjK+C4Kn6Wh2HltibgqlN9F89uKUjOPOd5RoRog3HRmf8uJzq4kYrJMq7L3dB5hU
 Xub8HzjT
 a1995xxCb2hDjfQXqLhB89IWw1peigtVFMp/o9qT23s1opmIMv3GKlnvBGtK96smKfjOMaO1+WAkvua7iQ6ME4TbomAyJkWIMQgradrbaH1Ji0osshSpTELR3F1CvC8jEvSEUnQy8n5RHtLL+vwjwXLU0JariXTxs43QhMwlIU0gR1TeKmyP9xBAVEhgln9r8aFM+tisGWTzhOukD3RGKc7cqJo1R5g1yyyQvnZ+biyXlTLDtop6gpjOxD/wwppXCtj5k6PHHMfL6J00hnIlSG4ljQtGheD/Qvc6P/dxd1aIWRziUmo1XDbHob7KeC3sbyq/zJZD06r2WDxCbUNsFj2nstoxG6x+zhiHJX5eJUiKbww7fRpwuIAVYTr2GSjnxxUaTQpPzS6erYeQOx6iE5kiJig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 05:49:35PM +0000, Lorenzo Stoakes wrote:
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index db16ed91c269..c113a3eb5cbd 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1182,10 +1182,10 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  		[ilog2(VM_PKEY_BIT0)]	= "",
>  		[ilog2(VM_PKEY_BIT1)]	= "",
>  		[ilog2(VM_PKEY_BIT2)]	= "",
> -#if VM_PKEY_BIT3
> +#if CONFIG_ARCH_PKEY_BITS > 3
>  		[ilog2(VM_PKEY_BIT3)]	= "",
>  #endif
> -#if VM_PKEY_BIT4
> +#if CONFIG_ARCH_PKEY_BITS > 4
>  		[ilog2(VM_PKEY_BIT4)]	= "",
>  #endif
>  #endif /* CONFIG_ARCH_HAS_PKEYS */


I realize this causes some annoying churn, but is it possible/reasonable
to break the no-op ifdefsphagetti fixes into a separate diff?

it makes it easier to see this change:

> -# define VM_PKEY_BIT0  VM_HIGH_ARCH_0
> +#define VM_PKEY_BIT0 VMA_BIT(VMA_PKEY_BIT0_BIT)

~Gregory

