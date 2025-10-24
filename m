Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA197CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1086E8E00F2; Fri, 24 Oct 2025 15:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0068E00C9; Fri, 24 Oct 2025 15:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38538E00F2; Fri, 24 Oct 2025 15:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E236A8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:10:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B7305DEF3
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:10:03 +0000 (UTC)
X-FDA: 84033947886.12.48097B4
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C14B180007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:10:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="dzl7/4YF";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761333001; a=rsa-sha256;
	cv=none;
	b=CM3sQag/FDR0LPx8kXFUUufHO4HjpNx+Hq1HgRSl2YQEhhiOj5fNl5gXMNiF8ZLncrEncU
	1duLDIo+ZsSgq6wh3Jj8BH+D3obiXqRQ+1x8v1jNAHeqradco8oS3aErDngT/cOfA4kFyq
	p0Tg7ApwxC7/gc4OfvBx2pZ38EePb5o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="dzl7/4YF";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761333001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4YhT6UkULx0zY0BI31WYEg/XWXtKp76n8KPsV3vFlM=;
	b=gENOQXkkW88ti5WOaBLriwUEvtCQ9j3tRady+qnGxXHfIWDD1tLZWB3Nots/vX1ao/Hng4
	qa9hhBIHzIoDs6xoKQ+q7c4oROn6uq++FAdz8GB9CEGOPwBjPhk4UrVoqNnFOIrIY7EehK
	IKOL/Vs0Y06CxKrteDuIs71SQUb02ZA=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8906eb94264so261911385a.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761333000; x=1761937800; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r4YhT6UkULx0zY0BI31WYEg/XWXtKp76n8KPsV3vFlM=;
        b=dzl7/4YFJQ6zcQaeLwUrl7qrqWiW/z9SaoGF4QtO7OaJwhw4xW4uTnyLnih3c1YW5m
         qmzRB0MxOuA/EQ6jhT1QWLd+tusMpufjIo7Hiw1Dy5u6QtZtgw5SVsdWV8sQPrgwu+jY
         UvJhR09NlfM1HCf6HiiDUyByiVRUIVx8erQG0BFQTYdaKMaGk3glXLLuzQN7LlwlAcJi
         yWsVhvmEMauZ+7EYSp+8cTaKM896BfJftfdxvq4QwHRpJT85ClcgRohBJEgQ4DewKouW
         dqgtEbPCqUVMgmMMD+A7DPL/KTzTINeFt6/kilvBmpzHRTifnDPAuwbzQq/YeA0R07jl
         drPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761333000; x=1761937800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4YhT6UkULx0zY0BI31WYEg/XWXtKp76n8KPsV3vFlM=;
        b=FaRxac2wGb4QiKsTU6dV91UCxnUjU31zbqu35sk2X55yDoNmPphM0h/b1zGD9mL9Lq
         WGbVpDDSe3J1I+wPTAevmHJwvLux9Vs78W6+s98YUfxgsmv37TY5eoPYz1xXLRkb2g91
         XKQL0suzybJbf9R2ov/L9cjhZp1k0sHRzN9i0tl7tXSgVMcID5nNyNpgN+TiffK2rMu5
         MerroN48ZOIudm3yYSXlpJ/tgU/0Yclgwc1MOU5MD8c4bUs6S69KJLSYKFFLoMeFZE+o
         16jkYi8BKVIVWjisTudbGPHIyMNyeQK0XsUsjXgLAFEXPO9sedD+IgSyi4//lh7iwqkc
         D81g==
X-Forwarded-Encrypted: i=1; AJvYcCXpg88puQiz+ztJahgh7MrhsryguYI7HqlEjoo+rgp2zxfxhtWOajn0+XlONWKugu7T8f+UquZshQ==@kvack.org
X-Gm-Message-State: AOJu0Yzb4c2L2oc2l/eUh4HAThFKvJsXUen3Asz2iP0wzFn5UJv2KaAG
	tQBh+RJfFeaOnuyr4z+RnmvTp813P9XQmTeoUivFUuXEHTm97S5cLgorP3Pcp7BZ3Hw=
X-Gm-Gg: ASbGncu9H7wpFM0nlRXCuxSlm+CJotXH/i3AK5EFH1wUzdJKBVVL8LoT7GnyGukRrWN
	w7k5CIYv2JvtzAbB8gHhnbWiTNT/64Mi2L3JEBfk1r5wu/18VpLKFRWo4vwcoWzuS2i9KwX3wXa
	r0LnNFdvs2mDMwm9Ci6wXO7Q12w4gNGuqUWaf4Z3x+SPkoRvL6EY56PXjMdguL8jS3YoZPYHb/c
	91pxrnNMmGtOwC66Cr56OnBekz5Jqp7asm5g1nqYv4bueJlPfX2UwElcXtgRQKNgTx55ojcfhcu
	Oi3so3fjS2uAFfNhm2Vkdd4BBy8+zrUT22T/n5XbV7kzGBcCtnSzFCYa419oUZHDQxLdPRr5KDW
	6MSophfSZJoGbQ+elgOujaOYM20u1Yu5bL0dxNjpPu5K5a5jVzBjYZgb7qkW05gXJnIhG5Sprsq
	QNDV1oyl12zYr8VS4Dg7W37u0LkFZE/FCoJpjFUxzDBjMJ1b89zluoTiSbDxI=
X-Google-Smtp-Source: AGHT+IHrkcPaJLyTM5pJbJ/XVcfel+4u6gv+3P752b0IEbbyKeVVUPlOZ4xL4VMnAte1FxD358/CqA==
X-Received: by 2002:a05:620a:40c4:b0:85f:82c1:c8b1 with SMTP id af79cd13be357-8907011583dmr3539276185a.46.1761333000331;
        Fri, 24 Oct 2025 12:10:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89c11e631e4sm442634485a.44.2025.10.24.12.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 12:09:59 -0700 (PDT)
Date: Fri, 24 Oct 2025 15:09:57 -0400
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
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 09/12] mm/huge_memory: refactor change_huge_pmd()
 non-present logic
Message-ID: <aPvPBS5H0E9OXEo1@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <282c5f993e61ca57a764a84d0abb96e355dee852.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPvIPqEfnxxQ7duJ@gourry-fedora-PF4VCD3F>
 <2563f7e1-347c-4e62-9c03-98805c6aa446@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2563f7e1-347c-4e62-9c03-98805c6aa446@lucifer.local>
X-Stat-Signature: omtp9qcr36jybu8xxasnfnjy37oqtyag
X-Rspamd-Queue-Id: 6C14B180007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761333001-609678
X-HE-Meta: U2FsdGVkX19iEGl6wVXgIU9rAq3Nvc4F+7idwJtiwiDsBljgbFHQh3eiZW8wLLPJyBnrSO7u4M+Yyk5CKSrstc3bvQt2OKSxJMw9y5B3eHjUr8CAx/XdTF8kDNkiifZjtGUzoHpWeGlCDf1RWKM6s4OSb0On/bBqHrC0b5XRsFJA4Iba53crIaMuzM305x4jisB6QdiMOKicFgF47Ryc70xwgHev3atf2dDExP1P4u0GGtXkJgRsSnuYlXmk/6J+CVvU5990QN9DOWmy7bP0PvX21RMazJs0slq6FHrewtQKCrr4AQcw/EHXB22oCj3iySb4b4uMMMeC01OHvJCHKUvRMgzp6w+tDaZmpWuRS454+D3VY473hvkpQ8sYrMnJKwRZnbJhK5C0qU1YNWSaf5uD3KimAGzd6iSlPGJatrT5bEy/3j9/7Jamj+OhO2jcMPvK/frM+oDXq/FAyqwK4JS8z3VrnhJiDto6U2jXtiBO2CmVUdu9c9huTqmmWEXBWb/HhkP2IPBVI8/aj5uOmU0y1q8yRHAqqLH9ZZ5RxP1Dnlt/ZMwpcJCEEk2BK8G04k8/WE7yfOOq6c9PBAs/vnWgTslymYFqv6cOPO5K2FX6O8G34OBnLmYrvkhBwg/Orjx5OrzBpQfUaHr4IEGbmsb2k1f3baD0qjOqBQfcToLtFFIGLI7mfumgPtFDSxhnM02R4Hhaxq9AcxTSnruB5zp/zsCNHfx79dMkSBZRn0chV6WYd93hClBumn5irb9HPjDG5gFTHMcZ8Y6QDbldcDDRd2NgXQvbnkyRANkb6B/UiiU/O5IIcG/miJ1mwm77I0W2pRUpFub9gkMOOuMBIKMr6Hbx3YCA4Hs09SrSMvc4jU5hxqWfBgJ40axF1qQtanSCmuYRGOPJoC3no+wM+ZeBGbiMMM3JXXNyvEmW2QPw6TTXLSqi8ZtEnkSnvlgkwgQNqLZYaHlcOPbr7Th
 2ZhTBpWo
 r+87Lo/oaAA3aHIvhEAQnFnWqJxctIYPhoJ4s/uCnytPabdej49u2WgpzZKpYMu7kkM7Hg41hNcjprz4SGYf+AOzaIgoFSwrE4OMcVyFhGcvfR4U4cwX0I2mOMVW3FNYrRuld4QimzwkKFSi8vFO9skIHDIZLOQrNOsIcdpwCEpUx/8ckjiV8nCndayGxJBxZWAi24E0nh8baRPmWI7G90jNUuu502K0yyZcgcLeS+3VZkeT01IPHhkgrdypWMUgDXb4yqa/EUIskTg2Ag89cMZ0SBGjpBZQyJNXQtCYXvzSVBBt34KCttX4K+E8gLLMi3YVIjAkjJUfeaB4MUNas0h1hOKVSaSM/6KV41Rh1i7+BRcKACIiFzSq/K9YHBzhi/ygRZkwiOdP0hDz0s12hnFszpvK+uugPtJrN2+2E2aBBrX1CHyynL44oddsbKHzNaBm5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 07:44:41PM +0100, Lorenzo Stoakes wrote:
> On Fri, Oct 24, 2025 at 02:41:02PM -0400, Gregory Price wrote:
> 
> You can see it's equivalent except we rely on compiler removing dead code when
> we use thp_migration_supported() obviously (which is fine)
> 

derp - disregard.  End of the day friday is probably not the time to
be doing core patch reviews :P.

Cheers,
~Gregory

