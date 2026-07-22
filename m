Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3344EC4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 20:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173AD6B0092; Wed, 22 Jul 2026 16:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124CF6B0093; Wed, 22 Jul 2026 16:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014066B0096; Wed, 22 Jul 2026 16:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9EE86B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:56:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 584301602E8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:56:54 +0000 (UTC)
X-FDA: 85017621948.10.291E716
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 665ECC0004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:56:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T8IiY7ya;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784753812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DrWtospFmR1X6Ml2Vs8JTWDG5C2VdzRczI8oq8UdJr8=;
	b=YyclIKF4Gq95zs1e7pFB4izv4vLumy/LLf6m6KGaxhx54wRyaLlEV0+yZ6IVnzbfR+e/yQ
	mFWODHK3BHx1hZ/e6plytfxlOw9cgZ+RG2/8v0bBph+dl+Evk6rhmcGG9+9P06IbLbwXPn
	MLrJyk1cf3/9ZnwqSW9R3pLGs6Rsf8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784753812;
	b=WtQ0BCIBZKpSNgGtbw/Ic7PN0awJo3bgxgfeTy2req4+NEMxECJxjw1m/PWyfjgv3A70he
	HmHi+zJaCEpETJVJjtAU1mgzX07ElctTwDZGERbguxcGzTwSEzbidpCZ2vOX1n2kj9NRRL
	uXe44tEboD3HbDUDvcsDVwlmAxW3dzE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=T8IiY7ya;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c2cce930cso91918951cf.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784753811; x=1785358611; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DrWtospFmR1X6Ml2Vs8JTWDG5C2VdzRczI8oq8UdJr8=;
        b=T8IiY7yahLbyBXLPOi2Upt6kBY9dKqqT/TT+oG6D/o+jmO8hWgypE40vO/d9L7pmxz
         p4GgY7ZgAKh+hxG3aDsD/wNjJJCxj69EUlaP07imNMBVps0hvmhpAVoLHlmAcXz4MTZb
         r021MrbcDVWpFSjM/VqIBqyZJb0KPTfd7VcBnW4tKmu8I0ye6oOF/XbYlco1A37M5sLm
         nokpSEJEecCJP5fhx+Q1y2K/lxF5MfVJIT9Q4dIoYeuJgCdXG4z6ZVp8A6rBvl4MeCvk
         n7q/6x6Pq1YeNu52DuIAogJOOeUKRwsuHsceapYvNIt1lWKXw+0R7yotPQ7fRirwsGCs
         TDrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784753811; x=1785358611;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DrWtospFmR1X6Ml2Vs8JTWDG5C2VdzRczI8oq8UdJr8=;
        b=QTScehKxyXdJK9BQn8jcxv0VphgCUDwY9HWaS1ttVPPaLhhkhVhuskC6ptu9jYSdJi
         esUfw+180fHp3RdAINhqcyDJSz1DWhr0fdbClpUMsxfXbJ/cB/VyOiP/0PMoguadYT0c
         HUkOf2TByKg6sZa24gIvWp8r5kYSpm4pS2NuKDPp01624V9gq5CrhDtmDf6nsouuXIgw
         k9H9RizPFTknGaHJ6Z4dz7kvGKrsZzNg1nJ5zAWuzou9GoYyg/3QBYsEB5c2shS7BtCV
         wyDnppS7i6+e4k35papWgGWmKs9pGGxKo8ZpHNEw7x/7Nsb5XtGWDIYq2zyuRGfks36l
         rPsQ==
X-Gm-Message-State: AOJu0YwzLWKY5Rr6CodQpOXfNcQzvW9huxMlqPpAfMPicZgzAHCSlrD4
	sFVBeMCg9wr+o1s4VDBcluyFZWvgnAkWXzKN4V8zMnezM0ukGKXbE5s24EZtDc144ZI=
X-Gm-Gg: AR+sD10+lstkcvp84ja2V3ft+cNf4VF3Ex/YnJik0ak863goX+6h7UvV2+EyoJqTqxd
	6DorYMty1g2onhYA9i3XNGZKzrwHvjQyocLs1XsBU3Lqjkdw9/Pl6vZ4lzVS3L1jcMihETt3JtE
	/kIk0/Rs/EW1Xphs7kGxVsURwfOHRaYl+7fNDa8zEwbZrm2ddgaYuzBr0+FGNBXS8ZCUBqIR2rb
	pGOcpOdMPo/1ZXH5b7vVV4xTyHAfdJ+xlrg9kAKYPVNpnvO/fKAUxjMxuBZnEDTNhewwT9r17ZM
	Vxwydqq4E1Fna+luPM/UJfSIfevX/GOTTJBa2e5+7u7HXwdN8FGj9OK/m7UQLpXlAL5kzu90Eok
	sBp7/e49Yty837E8qc8wN2pJBp8IPAdqG0wsmox5vDW7BvevNBJ8JtAJunPMCvfdMqbVc3xb3WO
	kdKG+haekE9DH/gBmF9KwSnBZ2l65gbL573cb3HryMofIJhGyPs0UZskv3NoZv8UuXuE7T
X-Received: by 2002:a05:622a:997:b0:519:5680:1b5 with SMTP id d75a77b69052e-5283de4650emr1484841cf.21.1784753811471;
        Wed, 22 Jul 2026 13:56:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba672806sm29772246d6.0.2026.07.22.13.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 13:56:51 -0700 (PDT)
Date: Wed, 22 Jul 2026 16:56:45 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <amEpR83RtiqstjNs@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <amDL80BSEP6u9XfE@MWDK4CY14F>
 <amDVQopyvolxfX8K@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDVQopyvolxfX8K@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 665ECC0004
X-Stat-Signature: 9ekdqqerz7dte8fp4upx3t8q47gbnau4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784753812-926159
X-HE-Meta: U2FsdGVkX19U7YIDxcUGDaWPLYpOEUHo+9p6JnaeIeMHu008UoeLT1W//QcnuJkKcUNpmOIcbXY+n4+3SfClju7VegtEUIuGeIuAkM+CI41hhHdRmsndfMc1CcH3IWa8IU6iMBBWINLud3r4lDVuIZMcosfi4xvr0RI7f3hpBeytDqC0zgqvaBXZ1FQk6JAYg0XXcT7ceAbINEVb6v3U2z/vpzFYRTdxEQtezrgqL/mU11ntNTHXu4UEFUjSKTwEYdXMC8n5FWVbS2nYluYzcom/RzUqVdOWDUnqyIIIB2pphGs8xVUDX1ht30SjAsAM3bylxenQCyXJbiE0F0drWk5QvWXmRpx8S7lOCN7xc21oyf7aX95zHlgKk9bjNgJyxBD830P+idizBmQHkJfuY/fhGh2R8tNEFzja/NWsw19XWl1AH2SAaAx14Lnxy/QMENzKtNnyZEixcpNnc2CiGOY+y1MluSAsjOHJhiFqQnM5+gjmdhJOylaV9G34Ht9AvOgj9DTc1gv6f72oQdumWv/C1g7WDyae0fe6qf3e62xP9rnWsH2S8fP3yiQVYV+e+mX+xZ3GUvithYBXxW9NKkUT5kfHdk2GwGCD9xYhc2RSyw8UUVn3bRIpBU8ZsZ2ciDO1XBMy0fRFqA3Y3BauxtQiYi3lN3V6g3Ogz6rRDysk4nHRmxRbThUi1mFhT3Mncb1TFad0DdjEK+kMkwup6UlFjAP7RI35Tc7RZ2qvXyCkQRsF+NFMoDo8DaKRHjfoRkIgS5Gf9OPf4TxpfQwxfujN8JODhFDm1+VBoLuowfxEr0kNxs7A3aKrX7a39InOaisd+hcueKJn2RjGbmzMaJfyHUVFridwtHPuPMxFjaqueWu1NcxpaagsFo+B8uHJXS7d6zbPUeAwVUUDAcBZOvABf9gf3LTzY8t3SOmafEBkXV5MVvcolFAxGhNTu+oKD1wCRuriq1qkil6LIra
 8TDTea1K
 sQ4vPhFOnWM9V5ETgxRfHWB7RB2Y6IfmaBK7eqpxnaZHLrbmkZmTT0RRKKSsBr7pbKB5m5BQytdGSOnEYol6BWLoq+JeQ2+ogXUGpfpUhZEjXH2tOt0lOY3XllmdrxwJ/K5l5sqM6kQ5YcNJYm9cUJYNF7qplmFepAJqxEi+r0D6nuvzsj0tDvux38l1+qmvvKcitnAWZdvCb+klR0BCE/NysoWBTnrvAh1dBfD83mE03urDqTnuTI1ch+Q1pY2wq76SZxdOCjgjjVb5ZLUuY3tsMwjA9xdAJnxLVW3yXS9/ug4HjmQB4/Em786cvW5vh+twP71mhIvcIHh7eYPGk7fhUJPLrAUfJ+Z+X/OuDM9rkj6pRqN1WX42F9pJGdMz5iagQhCK0SrjS22k6jeEWC9vTDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 11:40:06AM -0400, Gregory Price wrote:
> On Wed, Jul 22, 2026 at 10:20:00PM +0800, Richard Cheng wrote:
> > 
> > I saw the reply in patch 5, so in fact there's not only one
> > dedicate zonelist, but numerous ?
> > I raise the question because zonelist was supposed to be a
> > global, unbypasssable thing in MM design, but now what you
> > are trying to do is to seperate the whole global list into several
> > parts ?
> > 
> > Can you explain why in current design you don't consider to support
> > something like ZONELIST_PRIVATE[n]={0, .. ,n-1} ? that's my imagination
> > of what a global zonelist should look like, no matter private or non.
> > 
> 
> First let me say that there's nothing that prevents us from doing this,
> and we *could* make this the default case - but this decision was
> intentional by me.
> 

You caught me on something here - I am wrong about my own code.

I described to you how I originally implemented zonelist isolation,
which I walked back when I was testing mempolicy and demotion.

The current code and the comments in the code are correct, we get
the following zonelists.

N_MEMORY : 0,1
N_MEMORY_PRIVATE: 2,3

ZONELIST_PRIVATE[0]     = {0,1,2,3}
ZONELIST_PRIVATE[1]     = {1,0,2,3}
ZONELIST_PRIVATE[2]     = {2,0,1,3}
ZONELIST_PRIVATE[3]     = {3,0,1,2}

Meaning everything except for MPOL_F_RELATIVE_NODES works (because
of cpuset isolation, but more on this in a moment).


So what I shipped here is what you are describing.

Looking back at my notes - I realized a few things that lead me to
walk back that isolation:

1) mempolicy makes more sense this way.
2) reclaim/demotion is easier to implement without isolation.
3) The individual service checks and nodelists handle the rest.
4) It overally just makes more sense.  If something breaks isolation
   it's because there's a bug, not because of a structural issue.

For example in demotion we do this:

demote_folio_list():
    /* Get demotion targets, find the best one, and demote */
    node_get_allowed_targets(pgdat, &allowed_mask);
    target_nid = next_demotion_node(pgdat->node_id, &allowed_mask);
    migrate_pages(demote_folios, alloc_demote_folio, ...);

Where the first step already filters on CAP_DEMOTION.
The result is still clean - no special iterators needed.

What I realized from your questions here is that since i walked back the
zonelist isolation, I think i can actually include any CAP_USER_NUMA
node in cpuset.mems and allow parititioning fairly trivially.

I think this might be the last majority complexity falling out.

Thank you for the questions - this has helped.

~Gregory

