Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9052CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1517F8E00F1; Fri, 24 Oct 2025 15:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1014A8E00C9; Fri, 24 Oct 2025 15:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBCE68E00F1; Fri, 24 Oct 2025 15:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D51638E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:07:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5AEA5DE06
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:07:46 +0000 (UTC)
X-FDA: 84033942132.01.EFF9F61
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id D20D780015
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:07:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=m1gP4MJt;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761332864; a=rsa-sha256;
	cv=none;
	b=vxU6jMs/PvgVBMaEPJCuR3lKq+6mD0kORRYDvEAW5QMW0nimg4Oxsgr6Y8eLIASGC994lM
	1RON0EKdOtl2pfTBZywnbgrZ85tCpE/BU/UaerXFqR6y6vtaYwLNt1NMdEhrIkhv+T0XKQ
	BV11aovPEVbfMDYALD93GxFo0D//NHw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=m1gP4MJt;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761332864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5Dh5pou/PyGHQeCBr0c/6aApj2l3K41F6GbY+zS02k=;
	b=3Q6oCtx21IOsLQ8pPJSoSJc4h5nhuJw8S1gGmt4SP7ObylYClfu7lAQCy9k69C8uJW9sqI
	nYUcFQxWpjdq9zR9GQf5UnNY4PWICehBFw8k3ebubs87LzxxIVukGPqYdReaqtTM5ej4FL
	i4WgoC6/20zl/7Br0slx8RKrZ/9SU1A=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4e89183fe47so22824081cf.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761332864; x=1761937664; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5Dh5pou/PyGHQeCBr0c/6aApj2l3K41F6GbY+zS02k=;
        b=m1gP4MJtjCmq9DfE6cb4x0a17fqfQyWoBMUGt6k9swFfimX6rTo+MVomjKkojAS/Zz
         3Pj6ExOeeJxP2yOBt5AlDtQ+5uCmLNVX7cnm/DrskeFur4NhRmkJWHgX0YgIffEGqwG9
         j0qGPHWXmpjjkuUJeUcahU1o9iZiAk2vPesQF5lt3RGFxmvnGEnypX5eQGGblOkzE3ru
         SIdEBwPcyRsIq3AKUQU6cUZZRhNI1kh8aGuD4kQMznFY2mniHT0M5JJsZ+Q9Xbhv8CjA
         KDT9B2fao3Nd3LV++RfjVKfphsb3WvnlG0tg8DBiiJC8dyL9HDl5T+yqt7i5//8e5I2a
         FM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761332864; x=1761937664;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5Dh5pou/PyGHQeCBr0c/6aApj2l3K41F6GbY+zS02k=;
        b=tLENANic1fjgW9u6JJFz+g0KIM6AXTvj2e7kEhpRu0VumU9Rr6rKm+lJwnZ4TL6TT0
         Sz3oULj5vs3ld6sxSOuYwxInJ6EwLWO2ZGZZoo42z9ATNvA3Dw/adNs/gdlvqEqIdCZ1
         xuV+Rkh9dClGCUAUC6DMxRADcE2jT1nPuk9bmED5uJMsObaCBxGp6cs9VCqpc6lSGM7m
         a8LLIla1EQ64vOtySUk6cwa2ncNrOY5NDF2YkfUjRN5PtPZs4yLj3fKnWaDy4HjQeE6l
         xhvP5SeucmqD7aQ1QUM8c0WxexAJAjxAf5dvGvYevULjXvcAVZTMvmbB1c+utUuF7hv5
         5COA==
X-Forwarded-Encrypted: i=1; AJvYcCV8+e7JjWRsm6pNZu10CI7+QZ/8jF1ZSxxVRndQjLPx75zGVlH5ABYdHOp5pUBfxLL1L3ahRQjmVg==@kvack.org
X-Gm-Message-State: AOJu0YzgbJ1NPMAGbKH6SHNOLyHeQFgNzVM0H5hAGPDucMVKrvWBPjHZ
	agXam5moYXqrKi5DGkoKupFtOyB99LqxO1N5XuRG9XfY47FmpAslCc0XKmrAeKkO4Cs=
X-Gm-Gg: ASbGncsNrHr1Qf8sb7h2+FciX0+G4HmVU8YGGYG2aKv3y9bFfP0nccnm19o5JyAbZOF
	7NS3p3azzuVc2jlomGei3QBx0d82w0iiKms46k4COOY4FfG06mh+Z5kzYNI1MC5PqOhyINc1IxM
	WQF3JEZkVNAhT5yEaRLWbJTQyyxvnMljsQ75lnOaqpMkCFRPv6pwbm9sFz4kcMmORpVtm44BDDA
	LPRPV12Z0gxFcmjJkc8CG0zTifOQskrypUA+RFP8nS3aFNvAaVv1wZrQyexN5gYqpyELEyvZtNX
	bfjUkJqk3alTvcjguX8Kg8cFmhCkw17ZcJD4AUwyxmwES7Vs7gGLFKUgH2zBaS9nfYhkWx/pRgA
	x8WtlVyMjFkd6SgbkuZV2d6jSNdLSdeKeRvDSgzE4bt4nh1FfYySI35ybWn89E36lqG72n0LP68
	q5iPfJSYcPYLJM5lOIEor2emkR+yrQxxPj5s8fxPuvzBetnQZobgNRCUXYjou9jFcZF9QMcCIbC
	f1al7Kg
X-Google-Smtp-Source: AGHT+IGJ10HVaocsCEydg4aVTizi/vMPamVub9HiazMH0e97AeDKtQcVhgmZnH66d5WlxZIy8Zx0/A==
X-Received: by 2002:a05:622a:1453:b0:4e8:a967:953e with SMTP id d75a77b69052e-4eb940ecd89mr41100001cf.24.1761332863649;
        Fri, 24 Oct 2025 12:07:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eb85e917c5sm35169951cf.24.2025.10.24.12.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 12:07:43 -0700 (PDT)
Date: Fri, 24 Oct 2025 15:07:40 -0400
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
Subject: Re: [RFC PATCH 11/12] mm: rename non_swap_entry() to
 is_non_present_entry()
Message-ID: <aPvOfIfcRM0X_RaK@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <a4d5b41bd96d7a066962693fd2e29eb7db6e5c8d.1761288179.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4d5b41bd96d7a066962693fd2e29eb7db6e5c8d.1761288179.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: p46eh3maa1srxnsx847c9wt6hw7s9zq9
X-Rspamd-Queue-Id: D20D780015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761332864-845297
X-HE-Meta: U2FsdGVkX193R6GRA2aNMoQIykYr+PRn4rmxlCSF8tG6MUHwpYV81FMa6TEsxwIWT6xqcAhAX5Akie+IHwQOUJNRnMxpV2VjAVGGE99R/skKXJZZNubADuv182YK2ZeTV04dSN3ZU86Cu97OYMrlpfQwBiQSfyUJPlp+ne07riGo7UGJdzPo9k9DChQhHKnsoWWRBZX+xKYRmOHr4Uw0JgH5BWmqs2IqEqqT4rIYJpL423/Y4cV/PBqRPz2V21HHeViMGDRNGBMez2Hr9RL3aZcW7TIYHl6TPvliFZsC7v3ruUge8/LipwrWejqY/Ph6ungNzWTEWmNNYJUE1IaoMlVWhqci4Uf3czrPeXVB/RANcvmxV3vDTdNRxTYz6RNSP8DGLdCeo/er1VYN7tvFsFmi4Wqup+Z596via01ZB/GxIG43pMIIowZ54x6OnwSx/Rgxq4kyC7MfYOAUHk1itlQABwa+Q6miKYAhFRlhY7v1iC+7vcewDqUqfGrZLBjau3QS1iMzghv7g7tAcYxsWJU8tGzl40SHOOFACC+LVF3mBsM2/7KsDR9LJCV4SefCcDuq3KDgmFL6NKU2Tg8rA2FIGs7LEdes3LQCCRhI28Q2PoPKd+BaksuzcUQ/5+VM7xvmNfmbyQ+tS/fttlrYmKyvDON2ETFvRPuMhL7SUlIg9/Hs2RhkLxgv3Td3Wv6ClWX4iWuYn+QZA36zQ+Tn2Z/G3detdxmaqSKxPny2ZPjYw8jKk4WnemTM/Z5MrHvnFn7l9PEaTcmQqBavrW1AjfkrMTyG7f00bbOvC53jaV6yeDDXDwxjWWmqEivb+B+MNL+sdDdkbMyl3i1z2ttgb/70qOhy9obCQzX1cMp2e+75Q2IFYZlc9rs2QO3pIQlXQAsiIfbz/RukW0jjIBWr4XaZGWky7bNMm9Jigedoz3o+xrHgfNLXswlG9Jn6M8wj7uKd422TTOTQQao05KU
 wAuutOLh
 Ghn+1EKvaGhsvO9AEukdD4u6YnovI5d437c8+4pvOpHSlwx6RqbCSMITffZWuPaa0c/zL2/lXYzCTDeBJmEdxSX/PrBSYO1v1zHB6033WoLKAsJ06OTRBLFRN6yKb0ifU+j/wwamwk1bOInvpUDgg8ivz/ZRMTq/eweg8KKpX7pRfAA2+yucfcrPzIabnLJCsJ6ovfSe0ONvkjV75B3ZSCs6kChH+4HyEseFvIFXSr0r7ahg0W3aeEd0MT4//zYcvwuSeF09XlQOogE/yB7+FToz0Hy6ZpWkR7uVDYPFbsVgItWQ93CuQo2ydZAH3MCmLREiqmflAx+xQU2h8OmR9NdalAVaCFOr/oUGRkdNOKvCWZ7x/CPTYiVISRSDpfSs6jnykr0iRIKLb2g8WepxiVouqI+T/WUV1ackdUBEwMiGj19MwCno+VYOM2rKuIqW7iG1r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 08:41:27AM +0100, Lorenzo Stoakes wrote:
> Referring to non-swap swap entries is simply confusing. While we store
> non-present entries unrelated to swap itself, in swp_entry_t fields, we can
> avoid referring to them as 'non-swap' entries.
> 
--- >8
>  static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
>  {
> -	if (!non_swap_entry(entry))
> +	if (!is_non_present_entry(entry))
>  		dec_mm_counter(mm, MM_SWAPENTS);

I guess the question I have here is whether it's feasible to invert the
logic to avoid the double-negative not-logic.

Anyway, naming is hard. In general I appreciate the additional clarity,
even if we still have some `!is_non_*` logic sprinkled about.

--- addt'l aside semi-unrelated to your patches

I can see where this is going in the long run, but the name of this
function (ptep_zap_swap_entry) is as frustrating as the check for
non_swap_entry(entry).

may as well call it `ptep_zap_leaf_thingy` if it's handling multiple
special entry types.

but renaming even more functions in strange places outside scope here.

---

~Gregory

