Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC9A1CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 22:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06576B0005; Wed, 10 Jun 2026 18:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90CC6B0088; Wed, 10 Jun 2026 18:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D311C6B008C; Wed, 10 Jun 2026 18:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2CA76B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:18:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40B1F8D20C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:18:15 +0000 (UTC)
X-FDA: 84865417350.18.C88A680
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6ABF540007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:18:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="TgAZxh/s";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781129893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1PbvrJxmu0Zl4ziOeo1RdvYlevUlgdJVEfHD2noTRQ=;
	b=15DciM9n1LFnubEGs1c6sPzV2Y6m4BDjg9LctKABHlkZHe19PzpKOd3wLj3s8keLqyjQbf
	G9z/KoiUcBeQit9KruVuK1swD0n7eJTFHxYKBVoICC+dpLDE/URlEFOfS6sKqkTqEHzyAs
	qTJshghtZfdlQT8gYxuAH0HK/MyZPfI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="TgAZxh/s";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781129893;
	b=Fp7uPB5jhwjpiMx53DvKoZh9dGjrI08pPzZARYpH4nCy4N5maFio3yJWApe7elbu4bL4Mn
	Bu2kI/QPP4Y+AdplXNxdXfSObRnn7TuA+uuOdqUW9MbF2+6j+nH/LR/8cLjaxpzTfCZEq3
	Dj6IDrUHmGtnnTYWebPVfRox1/xq2Qw=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-91563abd6a9so353345585a.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781129892; x=1781734692; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j1PbvrJxmu0Zl4ziOeo1RdvYlevUlgdJVEfHD2noTRQ=;
        b=TgAZxh/sTcO5ZQJ6mLxKxA+BxplLqfVPlg0V6RoU1rMpU51dELR8zpOunRfy5uHF2s
         krkMGOL0AFt69zGkIJU12bl2S3NQf6fmu+fW99Q1O0feTOPTmQS4PBai/Hu1pwY2q2Ua
         cH21pdrKZbXRVhQnrrVlVcy4uvd07cs4ayQvNbE6xB2UE2FLHsvHRAAw6nRsLWQEiGRv
         iKnIkNsBzqBFNY7VoEh8emijrFdiTJuFMyutnK4M3oww+P49S8ytA1z7zKKsaS6xaKLy
         nKKBGAzWMs7t2dS+w+ecMPY8dWS0X48cp6WkCxflmepPLg8Sp6xwbDO9wbh3cCV0RqRx
         xdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781129892; x=1781734692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j1PbvrJxmu0Zl4ziOeo1RdvYlevUlgdJVEfHD2noTRQ=;
        b=WTJYDHRxk4CzOXJ19Svu29wCBgbKZwvLMicrCpui0mLNDXts1YxHxN1LfTwMZYHgXc
         ge5q3djWxC3KMrE6zU1meVRGNcKakcETakMpgCFD40c2MHHf0fux16xV+fAPgrvlM+Yi
         CmRbd8hv83U4rBPVSGvpfD6jeC77exDVehBi++r63Ue/dyjsaGpr6gPP4to+HehJqaB1
         nDafb0WsjpbD8IL4d3ttXWE+z41NB/kFpDw36JhSSPmqpoJQp1sy/xW9ZX2c16eRUZlG
         p4cCCIsX0BKZyQOm6VdqBZkspuejmvD1jovLOrFGwLuTzBSlau8p8ahqOT3f6zCp9Kol
         RFaA==
X-Forwarded-Encrypted: i=1; AFNElJ+7Fi83ePY/6PEePJT0f+RlLBcBTM2vKhZZUz4NX76muRjetDi7N3Xft+KEepHPlL7zqMD+yO8tEg==@kvack.org
X-Gm-Message-State: AOJu0YzOTCTEZIRwdnH4fCN6hqlV5oioyCpx+FPIGtEH+fVm+zhAgTlj
	upeDZl7wZ1NpEErjqRDA4aRSE7g/sBQVIX1BGLKSmbeRUvgpYrfn6pmN2GA2GSUOrms=
X-Gm-Gg: Acq92OFOwPgjKcpF/me4NfecxIiVoRfOrrzEhxjdG8InHbH4BpD0plIVSHzCQLO/Y8r
	kghF3uQz+pAYthMifF8gs7r1D/uqsvmjC5bZ6nSaPza0bLX15wOEa87KECHWQCUlQQIx/vxXde9
	RPfxyLIvsvPf5Sex0OVInFyrBJORbwdT5V6PK5qkZ9juDuq0+jTrmbqz5JXKzYR1O8dqOLgh0Hd
	fObBipapfMpvioQrCBLZT4DBUJWWhvTQvYuuTv47xcvqAbZh1WT1efhQwo+EYNKRIL0tIEoOdsj
	5+zNkn6HXriaxdIiK6+fU5z/P31zrbK8CTApvipHfsZhxL/j27RejJxqY/bRRvGJgjcsIup07tq
	YsrU078dKyfOrXcf6U/EpRAryAVwZ1nC8PA6jeLCUPpojEWYWlwjcYv2S0sW9GMADtMw/hddSS3
	lwQr17iuViNWzTnllRymWCEA0sIh67TyGnc9N2cj5Izsgc/WvGuMamBS5M3AoYN2GsgKOPPCSM+
	dO6Ne7UzPILY8sG2Q==
X-Received: by 2002:a05:620a:2993:b0:8f1:5e8f:fff3 with SMTP id af79cd13be357-915a9cc266bmr4381110385a.26.1781129892358;
        Wed, 10 Jun 2026 15:18:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a243041sm2641676685a.18.2026.06.10.15.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 15:18:11 -0700 (PDT)
Date: Wed, 10 Jun 2026 18:18:08 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <ainioCiFo0vI9ohY@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: io91dcbi8pyus63pri6t96o7zg1ni7gb
X-Rspamd-Queue-Id: 6ABF540007
X-HE-Tag: 1781129893-784543
X-HE-Meta: U2FsdGVkX1/q5oDCL9Gn/KPUgROOvuXLDhUl/3GphIAuZ+h9gWsBaIFlDyZDFdJSaHpznN5vaGnzJu36FH7b3Qgy5W3CBT2iDoHp+mUe0WpTcc3g9M7DJw3/bqrGfNbz/25sJWD9XXAAhA0rWCXek+T8Sr5tlIs6QgJCvhkPtXsfE2pzpng4NP6CHeCra/P06/vKn8u+T+Q18+RFjgwhgfQm/nIDrlIZE2+3eRN7QpV+UH2E4htkL1Zobq9Lube/FKaBWSEFvqFdTG9F66bBGTrb/weKlqoSP+BbrrY3npOBqZcU8UgPXkDk/72D6MOHnC89pjVD0tt6kz3R8k7VUriSB8WLBr94acdPUJEfaUhmjRwODl/6l/iLG6NPCsakdslcJDFMKCFYPUA/Yrfhk9x8Q/LoZocFXD+1HPmJ0U7Kni3kq02Eg5zf9fqH28ORA3MrBus8eDjzV+T5/eBnFOuOFyg1emuYSDcheRmEOGxEZaxEqMJsFzoRCMWELVStbCcTzDf+yS8sMwvz0oqqMe3DAsfFQQIVQ1PW/N5qkEjvfnisrhepMMY522ucFLaN2T91xMHYlB8oy2LM2t/vjJw4MAsUEqDOL9xdxN8V3QdqxdGROhBNWRIpWiGP7jGUStSdxthRg820qEA01691/3aplM7nPaxrWJIIRdDXBaUjrslzSKDQjATipRy2281sh0lQPR0nGnQcMlOVccFExsdODKj+LqfYm3E2zfoKBkVah+j9xvl9fvifrNOGzi071bopqZcVuM1r2i0mSODaZmKEGbLOeRlhIa2rklGkhIF7qFVtCSAL67ltIyamzS4ULOuNl66iMTqXeJ249TpK/exyQevTiQKYYZ2Rkcfqg1gGGPKQ6ziZ+S64pMlDh0C3WPiXk6pUGb0evT6IuNH6pa7aJJxqIZ5CbNJxljLczZcAdYb/DWVvZDYw1SiJx77gb5IiIGZ+U6bPN31OR4o
 180RFAxc
 SGiswZC5j/8CASa8GvFvCnca2nkDmv7Ua95AAxwIHmjtmp5i5qJQr5UcJYdOWCmIgtCQW5znRjCmEW4IgZrqtdYFYe8YhB/QzawdTDcqOnyQ9ftZoM2bYtmQJuDiN9d9Urq30+rx+UbOEjJl+bNEP+VHYE3H6wJ2/Z+auxNQG+mEvufFCd0kLh4umIuCSkgtxF9KssgV/CVzPwFuvvS70BkjCr4rScha/siNGEeWYxDKH2q5Y6RKg87MO6zauqcbjgNq+FB19uPHHRhvDrWwpEEJsL92mU9KjslB0h5uwHAi9HbsfXe1jmCweQfnfuJf/HPCSwcnorRFUQAtNQsHrAF+YnRnMbjGy1NWS65m0iF8nSPfgaWP37gP6enwlMldR+mggw58wD0CwbYZKcdhsZSyhwUvs8fw7IidfXa6RWV/s4L8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 08:59:59PM +0200, David Hildenbrand (Arm) wrote:
> 
> At LSF/MM we talked about how GFP flags are bad and how deriving stuff from the
> context might be better. I think there was also talk about how the memalloc_*
> interface might be a better way forward. Maybe we would start giving the
> allocator more context ("we are allocating a folio").
> 
> The following is incomplete (esp. hugetlb stuff I assume), just as some idea:
> 

Ok, this was easier to test than I expected, and hugetlb is indeed a
stickler.  We can't get there 100% with just MEMALLOC_FOLIO, we still
need a MEMALLOC_PRIVATE - specifically because of users like hugetlb.

hugetlb uses __GFP_THISNODE to do its allocations, and all hugetlb
allocations are folio allocations - so the code you shared by itself
does not gate hugetlb from spilling into private nodes.

That means we still need something like this in hugetlb:

  if (node_is_private(nid))
      /* fail allocation */

HOWEVER... if you have MEMALLOC_PRIVATE - you make the allocation
failure a *page allocator* problem, and it serves exactly the same
purpose that __GFP_PRIVATE did.

the resulting code is two lines in my anondax driver:

    unsigned int priv_flags = memalloc_private_save();
    ret = do_anonymous_page_node(vmf, dev_dax->target_node);
    memalloc_private_restore(priv_flags);

No special hugetlb, slab, arch code handling - they all just fail
to allocate / fall back.  If they fail - it means that code is using
a bad nodemask and we need to go fix it (exactly what we want!)

I think additionally, we might be able to repurpose MEMALLOC_PRIVATE
flag for Brendan's needs as well [1].

Their goal (IIRC) was to have a pile of unmapped blocks that could
be opportunistically converted to normal memory, but otherwise left
unmapped and sitting in the buddy.

Same thing - different filter point (blocks vs nodes).

If you set MEMALLOC_PRIVATE - it makes private node allocations
possible, and "private block" access (without conversion) possible.

Otherwise private nodes are unreachable, and private blocks would be
treated like CMA (last-resort stealing, lazy-direct-mapping).

And they stack (private blocks on private nodes :V).

I don't have enough time looking at his proposal, but it seems like we
can kill two birds with one stone on this.

[1] https://lore.kernel.org/linux-mm/agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F/

~Gregory

