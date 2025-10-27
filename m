Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEE0CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AADDE8006B; Mon, 27 Oct 2025 12:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DF88000A; Mon, 27 Oct 2025 12:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D1F8006B; Mon, 27 Oct 2025 12:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8311D8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:11:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F8E9129BBA
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:11:51 +0000 (UTC)
X-FDA: 84044385222.28.4E033A6
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 54B34180019
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:11:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UEsxF1Q5;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761581509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUcoeTWEWXvPiJKMdWmX3nawwIDQdRa9/4C7h6Fu0G0=;
	b=i8ewY5GZQiuzPUJCbnKj3hunF8Owpe+tfD6eUiQKiVBwG5IX+pnz7GTNCo+dHnIBpzdIPS
	ltHmd636bjz5e9Qpke2pTWbPAGT5VJCN6PLkDgpXyd3yImEcqE+semtSUp3UV+BkjN4jGZ
	Wz5s5m+ViUNjj1t8lk36BoJvc+QDKAM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UEsxF1Q5;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761581509; a=rsa-sha256;
	cv=none;
	b=2afNsTFTnBqWXrGqHs08zGRmJmnaz0rCEh5BNjmTYqmhbxr6vJ4wO0ypecxTVUY3YYa5uL
	1frYbhdehMwy5GCWhNXg3K7e6kl2ke0zudj/nNZZLeWwD8KDxowAQrzqAHUSZ0UpwMk7EJ
	oAQuwC/pxo+GNoP/5tQs9oruRYIbgY8=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-89e93741839so204207485a.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761581508; x=1762186308; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YUcoeTWEWXvPiJKMdWmX3nawwIDQdRa9/4C7h6Fu0G0=;
        b=UEsxF1Q5mQTDgK2JU+vmevAmSjQ3nQENbTFXDqpmpzfgD0TVciEHo2+PK6T1Wxgn77
         KSe5ZqBEcXyL/VJhi8J06o8SZ8o5HinSebYuP3ShKyyc0Du7aJS7E3oBJ+NoiTAY3Jrv
         CyAXOgS65WhEMMFSNqdTIAFLJeCOpWhWjcSaFPDSmj5ERm2894FzhNPLjwBsVWIWeT84
         +MZaSR/LUiebEQP3gXWerAwTy9zdZljkCFXEn44dtDjuNGoPSTH/QAIcBucuFCBGUp/l
         /va3dBaDpR7qwHSxxYZ2p/7QooHTEc48mRl9SCg+kTHTDRypPcZOZW87VYo7aI24yFXb
         fFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761581508; x=1762186308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUcoeTWEWXvPiJKMdWmX3nawwIDQdRa9/4C7h6Fu0G0=;
        b=XHZxc0IemPSqqimqNApuL+cSrzR77H6iSyaeA9JiKWokKr/ghrJNdbOHemJq2ZXYoB
         o5Do9QmDqqzoWbKb3nylOcbdTUOsUqAKtGgeQGc0VHg9U4SJDkFP7eL9aYfuyKbeq8/x
         sBa8FWWLz275J1Y1u9LuexZYuZckPJc1REqeJGaMTSWxA+KMWPVelewgF/MxckRc1+uE
         2+A5H1AXMCzZMc46Nk3gmTEZ36Xc6gbAYKqxQqg6YCnTfKIG8CBpAug/1yNOETHrKf9B
         iY97JiVJB1SWQwvW0jQ9GTOr1eb0UlTCoYS7EVElDt1BhUYw5R/YA1yyHMGzPldGWbcs
         1gFA==
X-Forwarded-Encrypted: i=1; AJvYcCVm8X6O+/TE6UuXZHAolG0U9vcPWW4oYxJyTHltVGFAGqv7Q0+q0soAu0N6v2aWyHmtK2ufrnSopg==@kvack.org
X-Gm-Message-State: AOJu0Yy4aBWH/M8wi9czX5I3wqEuheTnoSEUqA0HCve0/d3rvwHwADEo
	THEdSE5q2jBCvVas0uF0VVn0tWe6FVGEZrej8mwcEV73mH3F73uvZmM5E5xk8oT1mCU=
X-Gm-Gg: ASbGncvJXpuHQFe/IBbXQDdOSAKNnpB/YFpBbvdpl68odWcZ1lvtIbwquK6oc4xxvyW
	tBfUEBgCP+brWu/1Rd6Rdlqdu6d55hCAtMR485AhcdpxU1wTs1SvWgQin0HfQox1Ml4WuIfkYa+
	+rdvFdgioEwUknyWgSP5wc8i805yRI1EtxsAnobRu0j0VyLawIBAwopByrZPvctNI0+6T+VASqb
	FS8LNhUwFmySHjnn6TvE9+n/sMJpPKn6JxRI/KtppKKQSW+1n0xER9OVBMQsYaoo4amec76oRBZ
	nTK1QwQM/+WxrYWvIXMaljkqsRu3THDVTMnZ/NmsWgrM2Ig5X3+ZheNzFLZPw+lJRZ+2zYvKc7W
	yz9OIzg5wROOh4+qOMGkEbaopvMScg/7cLFxEEIF87h3n1Jz9lw63r++y05vEkg37sCr8ffdBgZ
	lb3wJo32i6hS/5Yfl5PvVZgZSd00ailYYl72Wz9goDmC/hV7eFeTow5DBJ
X-Google-Smtp-Source: AGHT+IFJf0BibtsNlfavgV+F1phwUBGZobfoErAK4Dl+j0mvBEo1idyt8ArsRwOA8zB/HM5HTcYQOw==
X-Received: by 2002:a05:620a:4627:b0:8a2:2233:c151 with SMTP id af79cd13be357-8a70118c82fmr40354785a.75.1761581507673;
        Mon, 27 Oct 2025 09:11:47 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f25c8b517sm628453785a.45.2025.10.27.09.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 09:11:47 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vDPow-00000004HUZ-2jWh;
	Mon, 27 Oct 2025 13:11:46 -0300
Date: Mon, 27 Oct 2025 13:11:46 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Leon Romanovsky <leon@kernel.org>,
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
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <20251027161146.GG760669@ziepe.ca>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
X-Stat-Signature: 5bbfxjpqg383amefedxb4mq6awa8c3qe
X-Rspamd-Queue-Id: 54B34180019
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761581509-575522
X-HE-Meta: U2FsdGVkX1/oTWgXBFPBGyHet/9KsqVZjwebjdQ3oFZn1E3jS/oTyVUCv93uoxe9mWbw3s+MjWmWzX4tDu45+yZrXO5uGKE8kfYmqerdomkMYFmpvVlINpt77jvGwmkkwQXKtqwhyzU28WHL8aS6jzbW4wbVDZZBnS/H+I3hu5c7E4aKNnmuJmO8BnthtzR6mJSniKAK3dLrbxhCzCVSq2oGzcrgG8oLzDPUrPmGR3dIx/1mpRM57NuyF+ja375SrQZCHoCjs1iFLIJh4g0zSeE6usbdSitj1N3H4UolFD+qLDWgi42P1EkioJZgcIomK3uG38jB1ne/P3P33W1nc3x4U8UmCUcqW/sW4jr6tyYcSRJTQhmspuwECMypSpIpWls576komsFKm6pTr5e69ijzvAdxOk13soJLhrpYRZu647w94ZINszN09WKeG/yfLBsNw9hFpADJfI9dzMeSrumELKn43qsR/Sm9TVmMd2IJBFA6eTJk7viU+Xc07/MAuM6Sr/HxgE6TdkWey0cvLUgJngjsOzj+3OAbt8ULKI+xZNLsUQ+ISCxoqHA092qFhE5yjKSwDLrYKIN/TkPo0fNF7glG26d/xzhkEcELmcA4eWCQmCJ9HTLCK7AYHmOka3GwDe7rBXeQFRE7J7ALE1nqFVzkRE+lHtZ5H6BkC5Nm2MkYzOETYqaDLbboltnNdsTub00G19ZN187uTc7XPRQiByr1sULVrBpZPZg5PfvjfPNWTO5A2c8QfIbLFBhiCY34ZP6Et1VpL9OsyaCwk2ZJXzQhrZU4p0VfCCJGTJy8ofu/V7IOJT3duZOQCBx/acvNXK6xwLjTqbsVsko5uOzmsOf6aPL/rjXvnzANZ46bRwH1FvhD+8c9T6yfAO20+kI6VCxOQNySk2K4vM/WV0vZkOBQJ/axiayAp9C6Id6pawMRtkGvNj5IujPbmpyPz/IE80Fkk0H9jviAhCG
 CTMD1S2l
 FL1X1jZ1AqnYXL6jIxz4VEXiN4QyrQktG7kKZr1byerg4pjCl5p5ntNVp4+fzqSI+Oh8M9pD/KqK8RDsSjRkDL+isWQ81y032qVjkESirw91Ddjm/ZWjvEU4TEaCIhwEKTlio2NicHzCiI44ZLNS1BM1BCKDdwEFZY4Mnd2SfJm3Ij3uOQDuLiGyHvdpig/0svmreTG2o0CVT9LftM9gFKkduAKtSZ67dW6nOOjkEfvqWqr/tW9mpde38sVPgrtaczppVWlRsJ8D9uvV+EUJXFGPyO6j0iojpnVT6nFgx1IJRLBoYvCRKe88Irx8t0bgSjC7JOqRQAVzMeubWSH6T+7FtxIOfnmyuzo4xAF4pq/Qi9L/sEWJIfyrpC8j7Qzo2hRLj2jlmGdy/E96NX5qm7JusUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 04:37:18PM -0400, Gregory Price wrote:
> On Fri, Oct 24, 2025 at 09:15:59PM +0100, Lorenzo Stoakes wrote:
> > On Fri, Oct 24, 2025 at 03:12:08PM -0400, Gregory Price wrote:
> > 
> > So maybe actually that isn't too bad of an idea...
> > 
> > Could also be
> > 
> > nonpresent_or_swap_t but that's kinda icky...
> 
> clearly we need:
> 
> union {
> 	swp_entry_t swap;
> 	nonpresent_entry_t np;
> 	pony_entry_t pony;
> 	plum_emtry_t beer;
> } leaf_entry_t;
> 
> with
> 
> leaf_type whats_that_pte(leaf_entry_t);

I think if you are going to try to rename swp_entry_t that is a pretty
good idea. Maybe swleaf_entry_t to pace emphasis that it is not used
by the HW page table walker would be a good compromise to the ugly
'non-present entry' term.

Jason

