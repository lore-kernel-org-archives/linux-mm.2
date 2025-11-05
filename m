Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF45CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 14:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA50F8E0003; Wed,  5 Nov 2025 09:42:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C3F8E0008; Wed,  5 Nov 2025 09:42:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97FB8E0003; Wed,  5 Nov 2025 09:42:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B87748E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:42:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 661481A038D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:42:31 +0000 (UTC)
X-FDA: 84076819302.20.70B3780
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6F60214001A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:42:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dSGdSvgd;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762353749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCP0hsq/q40gFxNmjoVFcp0QbOx89aTWebuusBQgCaY=;
	b=h0IF632H5zywTFqmMJlJNhlIylF8Ws1mJlRNRuWnkFTgCJyiiTW8+YcM1/dk2p9bQfJ/W2
	KkzorFNAvUtt2intlpbg4S9/Y25S+kIKvKwdeVar0HxWt4MA36o7nVqlvCbSQHa2HNIwqK
	REMb5DQpxhVSVCLfuZspS4X3SMqxwjg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dSGdSvgd;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762353749; a=rsa-sha256;
	cv=none;
	b=y4P20dtB7JfxaB02Wf3rDARAEP0rhvfqm6NAy9Erb4MnSwwaS4UFFgIWslIuNLc0sjAccf
	aGWMboeH2kj7TjUFPLv6uki73MGhMi1fOCKLF3qvKDAgHjG+oXbcQLa+dJaRSVPPPE1/rb
	n/2HevXHvraOP9hGcXNqx7Jq1ZaX24w=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8af121588d9so478622985a.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 06:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762353748; x=1762958548; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gCP0hsq/q40gFxNmjoVFcp0QbOx89aTWebuusBQgCaY=;
        b=dSGdSvgdjZTBYxVK2oaGq8eFqB51VsuZ9x7rDIJoERpXtXqSMwCOXt1Tto0jYERCS1
         ReeeW+GiGCjTW2kIu95NOhLdBDUwD+E1Shh423EgN5L1HDEBWzyIXGU42HnYsChA5IQH
         CcVVbh+eetSrwFST2etNc/3e7K3/rTBxeOeOsH5+CLwqvMdDqckjFjQa0aH2OwTM2xCm
         grgE1BrYBPr4FxKsja3MKP8RISDsKUSQXTLwVLT+0RthSfTDpQmgNPfHZqARruX50D4O
         Vle1l3luO2lbLhQ2RT8LrFh+sbZxuB+dD8rbBDoPufH7AGZyU4oBkoHK5Qap93/3wbPG
         iNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762353748; x=1762958548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCP0hsq/q40gFxNmjoVFcp0QbOx89aTWebuusBQgCaY=;
        b=H6XI9vbTMnqN46je2bvXlx3k/+Y1VpzLpIlN5+ud8Yyxz0PDF1c78d5nU5pnNt3EBd
         6C11IfW2F4taCZsEnEFyP0BYjcMk+S5eg3AX7gqJNU0B1TKYQ3cmdS8Wi5eliWizaPNi
         G2iZDv8XQ0bzYKITaoBhGg3T3GArm/3h3qd3JM15JtSBcV3sn7PqvIT67mfFPMtT/3T4
         r8HoA/0qQimR1o2etH4PeYhz0sWPi42cFZTFP4vOm2EWvmaMc2zkOuRGEKVgl0c25Guv
         tEztl26gnrzSY2cGEsHgmlpEF+g9/mlRFc6AjY5hOu2xxU+bof3Q8LVL+XYJ2RVy1Lys
         NOOw==
X-Forwarded-Encrypted: i=1; AJvYcCVdw0s7W386hW55T0bT6v3ijYx/wt7jWkc31z0ZABtK8kC7ku/mdMKc4uN/s/ZJPpjejk+y73z7AA==@kvack.org
X-Gm-Message-State: AOJu0YzUmcqwUyz/264AekbKEguhOx3vx34jzYUMDT7RQJYL8t0aRil8
	Hnw4oxOML1/ReK8m4E7HnAYM/lBNhB2pydFv3WqNNStfMazvex+H4u8eXJEb0OAKSE0=
X-Gm-Gg: ASbGncsSWAHsmiKOC+qK5BpJE+edd9+7Z13d5Vi9WQp6i52KpodHV4WhPEb7L0bSTNl
	7qY+xAudpnADkcUGh9arVMfhbTtx54cKqQoAZq4jUVpYAgNAYG4eb2VOPkYFl23fvOVSUS8EhFT
	TJpPVq9yswwsx80Rw+OoCjoCvX+eBTmTA5yKCZPKqIvkyI3dvRVjRygqQEzxecqh77zhu8lz1ym
	Q7oqB0u/NMIS0Woo8PO/p488EI+KrYtgn7zjbhGquoVE5EQX6uOdqel9aETzDi/JnrlMRoX89aj
	SAhajapLsIqvsNEVTEJMFxTEdzyOD+bWblnGmZwbDsbKmHe3fE+Z8sg5n0OpVTK8LPc1RwKQyst
	3DYfkgjTM5kRAWKFBAV+B5GGXg/+TKovbYF1Xfc1aXKaZOO1exbdH0Ry9sHHwZCciISgvCKT7Kl
	dFiRrJO456lbLxZwMwkWe/yQ2xrz9Jbv1lh2iTXUA4Ek+0B67vvp3LlgGPSrxjDEO3Ir5buA==
X-Google-Smtp-Source: AGHT+IFOPmymxkVWTStAmI1fSxsEHrX8n+cH3NR2hrKHNMeSwi6zTbwFsDY5mjtR5/Zbzi6pU1fUXg==
X-Received: by 2002:a05:620a:4416:b0:8ab:4ada:9b2f with SMTP id af79cd13be357-8b220b7f441mr375892585a.56.1762353748298;
        Wed, 05 Nov 2025 06:42:28 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b21fc36dbasm239867985a.19.2025.11.05.06.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:42:27 -0800 (PST)
Date: Wed, 5 Nov 2025 09:42:24 -0500
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 02/16] mm: introduce leaf entry type and use to simplify
 leaf entry logic
Message-ID: <aQtiUPwhY5brDrna@gourry-fedora-PF4VCD3F>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c75a316f1b91a502fad718de9b1bb151aafe717.1762171281.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 6F60214001A
X-Stat-Signature: findnujdqbebdgcfqzm1bhsx8kn7nmjk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762353749-977984
X-HE-Meta: U2FsdGVkX18a3ggwjAkuOXboX8WUx9DizuJ7LI1WQDWviLW9FUsBs+vWA0g2lrJ2x4rgKK3d3E7F0CIn2/o+zdkT43ad5yUsrx7Iah33QGI1gkobp+dH2OSylbOfsSBImJiWPSBBx6IcyBD4ar1NEAh/1G/gmX/3+sfy6TgFp61dDi8p8WNLK9bWfl6Zq7w4I5GWMjR5b0ArktN5HDhi9ElFbwKvTg3EcsFwiKX4J1CrGoD1kTPVr9PN6hj17HpwUdu/wygN4iX4rE4V8tpU7yHp9kPt1LqKKoEJP/sqL40WMFcFcVaFqsmMxC86++x7QSIuoftCq8bBEAA37g56+HV+Pzc3WvrT2r/DNEmdQ1GOSLatlO0sZ7iDC/VVk/gdwP41sYjHK4F053LhU9/aWMtZm1g1NlJaHg+mtYiLeTR1NA9er4m3VhaHnFU7Ksr8BBPMYgRn9G6gRRDuX+jT4tXG9XQnuJ6vwQFjPaKLeA/pUI9q4+aR1UkUobs0K4U0zXiq97D56hegY6RFuJ+1if5DkLInt0R9fmsjUzgSMlmWv0C6kkS3Vr0jaCSASPZjeCeYgqWM/4ly5DSY/1a25KzuP+bICUm8lWhtNzKSZ0dvVVpu1nu0qMxCx8TEm1qx4SRC46sUmIPq/XjFTrEOZL1gSPcc/JkRbrM+AQc7eCtnYMU0j/zIR9J4xYXYHd4pvOUgL5d9BFWtgLe8HT8PjWnElMe9znlWjdRs9fPZJZMrL12iHMOJkyuwZOrCbBuCnKnvJYFJRy9SvQoX/Cv9rXYn8q4JbIu5zR7RhdRYTH3QL6014tDVAf7H/l6xulTtJzvRKx/z/HoHFza3DxBRTVBrKa9WRPmNBuZggI9MxXH9gqvEgxv+9uz5ju/RX3d+e5XUUcUEIjkavem/nmcUaXSkMvgNDd7S7Zl+NKac7od0cMXLcM1BL3Gj8HHt/PynbGWsnNsj2NTGQOirzRo
 AJXXc6/y
 GaqKdkCBt58/5Iyd66izuIvv53DwTdaLbIEWPsOzEEuvS6RiaiPPEAJWH9kc6EfzNPwROy0xGQ3B2mZN+FeW61eGdkk7NVomvDxntV5QWSf5dVE3STz6YYDOhKS9UJKR5kQOm+4gPc/+jjXLmB2m0dpYvY9tPh8NvXxHiHKPIzd6uxQm6eaUjup90K7LWKBMd1D7H/DmlFfJqlbb5l49XvK3I7qjOYTdZD9e7z52jm88CwAEW1VWIrbFyKwmaTGLL3/8/sdqhYzrzakZcmm9i46m3UX9hrywhqhMqD8qzm6364ivU/7xE+1o5snXuqOWSlaC/ha1QLUnXKPflWN/zpA7Uo2II2RL/c9oEXBx/h3E+YoK23SQaAY5qSzI8srVsVxDkUETqorxTdQVgXbRtvKyfpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 12:31:43PM +0000, Lorenzo Stoakes wrote:
> +typedef swp_entry_t leaf_entry_t;
> +
> +#ifdef CONFIG_MMU
> +
> +/* Temporary until swp_entry_t eliminated. */
> +#define LEAF_TYPE_SHIFT SWP_TYPE_SHIFT
> +
> +enum leaf_entry_type {
> +	/* Fundamental types. */
> +	LEAFENT_NONE,
> +	LEAFENT_SWAP,
> +	/* Migration types. */
> +	LEAFENT_MIGRATION_READ,
> +	LEAFENT_MIGRATION_READ_EXCLUSIVE,
> +	LEAFENT_MIGRATION_WRITE,
> +	/* Device types. */
> +	LEAFENT_DEVICE_PRIVATE_READ,
> +	LEAFENT_DEVICE_PRIVATE_WRITE,
> +	LEAFENT_DEVICE_EXCLUSIVE,
> +	/* H/W posion types. */
> +	LEAFENT_HWPOISON,
> +	/* Marker types. */
> +	LEAFENT_MARKER,
> +};
> +

Have been browsing the patch set again, will get around a deeper review,
but just wanted to say this is a thing of beauty :]

~Gregory

