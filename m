Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E6DCCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 02:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B748E0009; Tue,  4 Nov 2025 21:41:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF34B8E0002; Tue,  4 Nov 2025 21:41:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09088E0009; Tue,  4 Nov 2025 21:41:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEA6C8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 21:41:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4327DC0121
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:41:47 +0000 (UTC)
X-FDA: 84075003054.09.7B00343
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4753710000E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:41:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVlTxwiA;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762310505;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViiTvlr9WUOouJ2tSO6oIz/u1XimAQZsK9c62kBG2uQ=;
	b=7q6aYgYa/lGfKfUxxGoog+63+hmGr24/pQZZU9E1OC6lW7z1O+ceE51QQ80GThcfqpXKtb
	rJ551WbRvFHRmKeyGsnt00F7jW8GIESc/3hIon+hSeMNnXp94Y28RjWcM/Yhq8WflCbyag
	KwIwr3uuHFJWGkA4JaNduCoxtNwFG+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762310505; a=rsa-sha256;
	cv=none;
	b=xdznz6sDzYjoz/sDoudNlkxYUA1mzzrHS6DOQVevY0uUeEnMBYzkAls+l3WCmIUFYf5chM
	OFt1BoeTDhfKIrgAtTbKv/cvrTyrNODhDCB0zOuwOjdX+YOHI7VCRVVIoGcOKvJ2ZE0Ius
	hKMuBiCQZtYQn7dAshQ2FgpNqMF6L0U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVlTxwiA;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-641018845beso1012244a12.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 18:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762310504; x=1762915304; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViiTvlr9WUOouJ2tSO6oIz/u1XimAQZsK9c62kBG2uQ=;
        b=mVlTxwiA1La3SICPhG0rFIl+FAw+C8cDrHkGiYGB8j8BpgAGj8oWu2XBVl+ryf3nRP
         SYW66NCKJmG3b++BGzshE6/v+wN0XZPwPUD0nTen+oitGdivMEhO9ZROB4UmIUu9wx9Y
         XQm3SSdOgARbH2T7FDS4dRdnpJEY/xbMktcLz5VtPnnC1xZw6yogsvqtJmzpDHBGc2eD
         GHcDodDNVhScNY+sRRzXa7ZLKPdz660amP+tEkVOPF8xlaXBrWgRLiiV6FtPM207Tc1t
         2nM0MUGRQFKebMBe0mkVA26MJ+xDag94WTfKzZ0g5kFI2ObayUmsdRgrRpAJrEXgtoRg
         qAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762310504; x=1762915304;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ViiTvlr9WUOouJ2tSO6oIz/u1XimAQZsK9c62kBG2uQ=;
        b=XI4jwym8OiwzoCIkCKipWhmRK4gCNuOZKY/N+Bws0Y+4sI0+XTgxCyHxC4GhqXD5bh
         2nY/WKdmljaiV7zoYDPpi2flmGaUmm3P2p2eWHejyhU8uokgXaUwZep8R3EcuFJi7a1d
         F64c8JDozUyEgWNDj1sOP6cO0FcyhuTg+JhSmtN5MCKt7r3qMenWnsb/TBJ26Ziv1bUy
         /PHET2llQoGfLfPrXQw4qkespv36zMckxuxv82L98JE1016IQJKwV0z7wx8iWw78tUMF
         fXqdeUI1yVk2gN/bqB8gYAVCw3H4up2W2/vVCMqRCxeXViCeT4GaeGk7BfP1NSXXIDSL
         8O+w==
X-Forwarded-Encrypted: i=1; AJvYcCW/R75/4+jotMBP/xF3yHBUdJneESOJRnWvRRseFLbpsDij9zj77gkzDZCCbirhV5TjZSf0CKWVPA==@kvack.org
X-Gm-Message-State: AOJu0YxeU9GhrlznL2ySA+cPSdmYR7U4OsX0YfbO4xOaj9CbEQ1oI2k+
	B7rZtKx4wqls6QZ0/GTsby8OXhYuGIvlhiACDeDQTXC+x8m8uvFP7bt2
X-Gm-Gg: ASbGncszLx2AiLB3N6NKfwcxgGeW1Fdx7o8IZEqnbOJZWQ9dSQv1tfjB9q/IvV5Dk6G
	J9/RHVyV64LR+an8YmqVZgbihlsvm14zaYO0IZ3cKpCQYzfmWplHt2+7Q8BQDgzf8Iifu5G+Rou
	xCKczNbakInJsx3Aua5ik99YB5afmswY5jEZ7/1EoFGqIDpdF3w7Bh2ZgQkhKbRJVXJ1h2QV0Zx
	EQwQ4j+zNh2GzcQ0YjVFGUmDubQauiPoVGGD9XRG3nf3crRckFefiQWOkb1j1Rfqh6D30ZKtkg0
	lUvs5h4FTI+Fz14TN9MlrAzJ7ExWclAcy1ufXHFL3S1CCknbrQy1UF6diC1U6Igfu1pTIMTkhgw
	5kP48jMQGN1wfSpEnc/8oDJqzvPa5dQGmOArEpb0Liq7lKj4hnHtC56d0HJrjIPJ4HnCI+FbtMS
	QpH5SbwPCtdQ==
X-Google-Smtp-Source: AGHT+IEhst8qtfGo16G97VsH5MJRSalariFjSPTu9KPWOjxNsyChIg/n4Cvg6QvPn/kA2H/rBkbMGQ==
X-Received: by 2002:a05:6402:450f:b0:640:9b62:a8bb with SMTP id 4fb4d7f45d1cf-64105a44a6amr1195466a12.22.1762310503278;
        Tue, 04 Nov 2025 18:41:43 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-640e6a5c7e5sm3420577a12.24.2025.11.04.18.41.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Nov 2025 18:41:41 -0800 (PST)
Date: Wed, 5 Nov 2025 02:41:40 +0000
From: Wei Yang <richard.weiyang@gmail.com>
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
	Gregory Price <gourry@gourry.net>,
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
Subject: Re: [PATCH 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
Message-ID: <20251105024140.kmxo4dltsl6toyil@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4753710000E
X-Stat-Signature: ge17i1qwby9w4t1k3ejfegsf6meck3i6
X-HE-Tag: 1762310505-594227
X-HE-Meta: U2FsdGVkX19VXf9kaHMI/lGgGQhATGvRdbCeoZH4chmIHCqWTEqYd6d9lm4JPcd0Z30znMZ+zvmTargmVnmOs+u6hv8mxKTj37FXrZUhp+UWpU1/v9Cx5Di7KxItWfu2RvXiXG+zcLt5EuEJr3flkvUz0UnLmattrKRFEARiFhYiT6x0uBtHWAu83sXHFY1z6t5a02l6PN9lkZvyHh4UVVxJKCbGynrabsPpKQxf8v0WL5broKsTRQw+tLGEuor+nm5LVhfruNWld0p667QEbaIvvsRNd6oJ4ml30BIdNoN4jK0eFMlqu+J9wBYqe1oQhq45TXyWVDty8uW/BLQ9bHLo2fjAbKyBFQBZAshPyKKjddAiHhm8WOhnie+ap4ov0yDjWFAG8Q1Ip/bC4NFuWKWjKt7QSc33qm/4iAq9udQ7crNHEbUUhJud3q+2Hda1fv9f5HP9YN+T2t+e1glK6jj21RGFavQbtRvpr5jAruzah6xTo2mNQSvV68eoWOIuz8aN7ljkbxZGTVNA7rfwi6gxI5ovOk5+o5zSi5mrzWtxO/eru9Ri+wtuThOyZ5UKMJgmntszT458pjo9c+DXSFXq6RmWtrldXvH8Mds+d1FlQfzZnCwYjHkCsRjaiSRrHSXZNCugSEt1e1yeHOb/53J2ClR1tvwsLuo0ZTOZLiMEJWypeE1Qla/au0SidVW7zgETWvQpSFaQyq5Psd5ybpWrLzsrtJoM5ptv8EFXQUyJYKqm3tfRDHMLLrBj/QX8Urmm+o5PP3U7dcfbtUn+87zLxtxWvfq20ZokK+seiDKKebqJEsAxUVMFTFEgSl7I9ccyUcISIkM21E4YCcG5VXwAHXmRlYFylQ8TkxCS676BEmXw7QspI8LFn1KyHvsWRG4j14yHAb2941jdQj3usMF9Fml2D9ksm6WJYqHjkTxRbAVPKh7Idmj3X24ng4YBWMOLZu9VE4T28L7NdP/
 sORUIztF
 YxP87L4qZHI5YC62T6qpne4Nkyfd/A47JxDYe38yjivIt5a2CyP0mXgFoYG86l5A41SKyGX7syVSiWtJgxJVABekXoqEcDqNbW+E/efqaPfSF7zo9lrWnEc/9/y7zan+Zx4bhAMiVOApwa9BFRaDCGn/3wiL+iSeZTblZIzwrvSi/0GvWxbgg7h2xxG1r9+VjtY3Llx6xfABgQudbfRXObFphLR/ZOETvXgMp4ZQOJbnB+pTIomf37ELQHFG7ImnKWEYtjEXsWpFlRKmdoahY5Qxbml+cYU911XWD/bc6kYfuYN9ea6D/b2f5kVGp1F1EENJI5DHNPd+fvKNBLHwfkVW9e4NfoodVHt3ajsiECfbueeBBVE97SVQetk3k0+gTP7SD57Kba0FI5lWofhXieyVCaToEVL8TxQ5gjxwFFeIm2Yq7YwkWV/8ru349e8yLP7ywm0GxDxAHBLXhi9Keh0mKscR60q5WnVdSVDkzPCU9Tz9WTojXkSP/5HBytZsGlhd9stWnGIF/vs7piykIheiM0Et/k2abw6QYTdLuC5OGtt1Nea8zK3c7PtjviwGX0/70htmti/lqJ87JOcHxo64LpofwQyFh36uVJheUOxzlWw+dpCdtL5Kx8jEc26bdUuiB9S+FV+duZjIB/cH81sLvc8oUu83Z9mkU+rthsN8pi7SJAbC9ZY91vl3kWSUeYrDLyb0ZaTDg7AlAnZPnZ+N5NxvsINVjtEmlaQp4zWi69XYJEpm4g3AmOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 12:31:41PM +0000, Lorenzo Stoakes wrote:
>There's an established convention in the kernel that we treat leaf page
>tables (so far at the PTE, PMD level) as containing 'swap entries' should
>they be neither empty (i.e. p**_none() evaluating true) nor present
>(i.e. p**_present() evaluating true).
>
>However, at the same time we also have helper predicates - is_swap_pte(),
>is_swap_pmd() - which are inconsistently used.
>
>This is problematic, as it is logical to assume that should somebody wish
>to operate upon a page table swap entry they should first check to see if
>it is in fact one.
>
>It also implies that perhaps, in future, we might introduce a non-present,
>none page table entry that is not a swap entry.
>
>This series resolves this issue by systematically eliminating all use of
>the is_swap_pte() and is swap_pmd() predicates so we retain only the
>convention that should a leaf page table entry be neither none nor present
>it is a swap entry.
>
>We also have the further issue that 'swap entry' is unfortunately a really
>rather overloaded term and in fact refers to both entries for swap and for
>other information such as migration entries, page table markers, and device
>private entries.
>
>We therefore have the rather 'unique' concept of a 'non-swap' swap entry.
>
>This series therefore introduces the concept of 'leaf entries' to eliminate
>this confusion.
>
>A leaf entry in this sense is any page table entry which is non-present,
>and represented by the leaf_entry_t type.
>
>This includes 'none' or empty entries, which are simply represented by an
>zero leaf entry value.
>
>In order to maintain compatibility as we transition the kernel to this new
>type, we simply typedef swp_entry_t to leaf_entry_t.
>
>We introduce a number of predicates and helpers to interact with leaf
>entries in include/linux/leafops.h which, as it imports swapops.h, can be
>treated as a drop-in replacement for swapops.h wherever leaf entry helpers
>are used.
>
>Since leafent_from_[pte, pmd]() treats present entries as they were
>empty/none leaf entries, this allows for a great deal of simplification of
>code throughout the code base, which this series utilises a great deal.
>
>We additionally change from swap entry to leaf entry handling where it
>makes sense to and eliminate functions from swapops.h where leaf entries
>obviate the need for the functions.
>

Hi, Lorenzo

Thanks for the effort on cleanup this, which helps me clearing the confusing
on checking swap entry.


-- 
Wei Yang
Help you, Help me

