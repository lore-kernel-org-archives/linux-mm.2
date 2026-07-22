Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7020C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6A446B008A; Wed, 22 Jul 2026 09:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B046B0096; Wed, 22 Jul 2026 09:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08DF6B0099; Wed, 22 Jul 2026 09:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 983A66B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:19:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BC00A002C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:19:32 +0000 (UTC)
X-FDA: 85016469384.29.AFA265E
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5962BC000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:19:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Hvig5121;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784726370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPPBH/hmuBagyTMjawpVpFd8RmJZZP/xfXgbpwvebxM=;
	b=5uHT29vq0MZ16fLqSJxXOyHGFI6oM38ZiNhlZCbKesjp/2rVwb//C6Rd8MoZhbYkbaNVzX
	hGTT7X+4ynChWbkcJJ23mnE2Pmqno1Tm0hpJYpjGoK3GrbrxYKldBCtxviPkqtBYbbsj4m
	zeVQwPVwtF70e/iBsCCdnGaqiOs4d1w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784726370;
	b=s6zINf/XCXl+gpJD0CVsbMFA+M8m9RhF1ZS7b1vGjaZwnaOQqzo5/yYCh4hzjR2xX7PrKE
	WZCn3brUxc/VEP9jcsB6yIwddljRyi34FoXOnllvxTqkMCSUY2+S9jsw+Voj5/HnJ5GbQL
	r/NQQkFydITNNnriimJkNK5YjxlQPQI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Hvig5121;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-930f618435cso79732785a.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784726369; x=1785331169; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uPPBH/hmuBagyTMjawpVpFd8RmJZZP/xfXgbpwvebxM=;
        b=Hvig512106M2KWa4oTBSz/W7PQ8/9xlPe1NxXUVLvnvvTksMIB64vruV8tKdba3kri
         /0nFvNq3gQvZB5yUFkmnxZrE1oCxS0SxMlnCVwiitiGZ7CMtxCtQp4a3QYZedVS4rN8j
         89tFgEwmoaF8nTVnct1v5W589eiK9ic8SPgT+cZo2B94ggMyg+zuFjaTpkY449J1YwZ8
         GLyuHTx4lWAjWphU9egTj/QFgVJvq2cmIbgIODD21qsP/cyPqqKMz2qij6kKjl9IhxBc
         NrxgMZz0+n28qf9i9SHYPMYQmtH+l2ehqeaxdW4hE037D9YOIYpFFVaJCOytteNABY4+
         i3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784726369; x=1785331169;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uPPBH/hmuBagyTMjawpVpFd8RmJZZP/xfXgbpwvebxM=;
        b=Wfc/h3GKaIwn7lX78HQBr+tGmGLeegQSW8MBqsX8xIiufKPaRV3JzZQ3hTWeIQ23ot
         pMNJPbIRtgmG3T4Jhn65BeQYmDTg5SAx9bRpqMKyuemP2eeqD9kVnWicoVOqU2zv5sir
         yTrTlzXT/D4dUeh8Ooatj1f2HJIEI+w0RTt4XC0/c7Z8odQV/qC/sisXxy19EcDwvKIm
         NkhSMPGFpJUXIAHtf1JwrXGZzpNwcaUxjuf3M9aZLUFKy4tsZ9Hn9Njgqb0yQshqdPR0
         Eg1W1BwmwALRID8jlkD+dF1DnssIa1fet8mUuaoVtBCzOym3TZvAZwwXygfzpm0hFCZx
         xd5w==
X-Gm-Message-State: AOJu0YwxUc26Uwl1v/d4aW/fJ1Ie2qz2LXT+snxoP3EeIxugKOCQhOEL
	TorQKf7YQRKvvbd23vg1wVA/qvjQ3w3HxqGXs/CPHPutSbbHmI9QUgTTYf8+hezpIow=
X-Gm-Gg: AR+sD108VyATh+VhDT13h7E2UUZ+onBlkNpDxMyU/NtIjRCLInxrEhDkJ8X6fwvtdOA
	BoJHNotK+14UzAB+s2PzDWls7tUu02bXXzC3jTjTmg3BiMSTFvV9BQ+PyLZ0srX0qfzZ40SKBGf
	CRC/RC8sl14xjCnQKcWj5INs5ue0dnsUhfP7C4g242jIY3qvpNJjPWEFsPzp5Xu9fyqpkhduez7
	S4CzI2VmcysGAcQNUxDZESOMiX3afQAHhKCdpV18gQtDJRsBNJCgrl8hWdGcH0Oc85obsKxheHB
	1bpwTeL20R39D5XsxTL+YjzpKeq/jvYwo1vDoZr4YZDhQT9ZO1lB3+9M1S4KE/izMtUHR82BByU
	KB/9Yn3P6d2G8GSz0xGakWXchIvDmdGiF5N0BqKfAVqwWTG0SvtmUV55qC8c5rJIJrBXs+/SRia
	55TVmHQHDjqefCANKwfrIG78MqLJ4+ixxkMdt7JInTorbwLFWbKEAZWLWUDQ==
X-Received: by 2002:a05:620a:460f:b0:92e:8734:b721 with SMTP id af79cd13be357-930b3ee6fa3mr2273972385a.29.1784726369355;
        Wed, 22 Jul 2026 06:19:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a6c1efsm160195685a.38.2026.07.22.06.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 06:19:28 -0700 (PDT)
Date: Wed, 22 Jul 2026 09:19:23 -0400
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
Subject: Re: [PATCH v5 05/36] mm: add ZONELIST_PRIVATE(_NOFALLBACK) for
 N_MEMORY_PRIVATE nodes.
Message-ID: <amDAjb7PpWDnIQcF@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-6-gourry@gourry.net>
 <amC-b5SIkxUCKQ7H@MWDK4CY14F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amC-b5SIkxUCKQ7H@MWDK4CY14F>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5962BC000D
X-Stat-Signature: i1x5mh66oi89w9opjqb3ayp7knjiwptj
X-Rspam-User: 
X-HE-Tag: 1784726370-629035
X-HE-Meta: U2FsdGVkX18bNVv+GR+w3S5tu7b6lP0d5HgprhbINPcfOUuYLkByAl4kmCGi08Qs2wNIGjlDRneN1nzuMVuPfdbzJmlygg8MwOZ2pgmqKyUrsga7c2b8NRe99b6swSwdfWnsRIdOJkrQm/z18+uLdf+b+NYCGcDGWI6kMHMbpIABy0h73OZ3iCIeHJak41QUpTa/8bMLWVAoSZxZJFKR+SNym1WxfRJqe5H8NsIGG7gwTzVw0BfeweZOuy7VDLgQUEUGggNX1/I+CJXfHn1B8F7Vx3nbuAxitp6EAmCeKXlZ15REuK/g8RXV9d4C9h3YP7yBcsfVWqZvSvT6wU+EEw7i52QGD8Q79+aTJuLFbRo3ybUGD5SN+kSDlkUrpXRj8gRd6qFoNFTr5Jc8k4sVDAWQ+N2/uToaI+6AjmsDmLeZ4VrEhMhXrsQXZTJ1mV7CVrZg83MDW4Axo93E/w2llLgSIdiPVlJS1xxArkd9rSh+AVC78I7q1qKh7FqvI4yr9ZFfTNFZUNzLbtPwdFlS8tFsLYxy0r7DjkDxp21nVsOUZb5Q1KhNugF3a1G+ZlI0Ii8vAHQ1SiJEVBZM2rJDnR0wpZNhwLq2UZ8Gs8N7hUF8CLiLSel3OyL2jKvD3LJCkQEBtkuQ2LxKMQwjfbAC5mgXo3Ac0A1M5nM/aNeYJo6/E5OFWiOrlTyU3S5Fcjn9klc/LLs6t0URZSOuxDR1Ufv8bK9gGhdE4uGvMFuE7oiqeqeYzMopbz/9i//wXOEUTLJlTRiY03r+wshkJWfnqTroEwxAB4RUHaOffEtrzYYoLTZu5v81wH4U84aePek4JsKy7D2fTZyLouL1FGbIYnUunhg6GbD1LpaWnkIQpJ+1BfjIhR5mZ0MwBiZddMFrywTAtEWsxtBMQ39uFu9+CaRZ/KcqsHTUe0sIko/6zMPmi+PJkdYeWnHX02K4BB9iOG2GfvsiCi7vKznIqkp
 Yq+BYvSK
 Z3sz1bgK6ZZP0ktP8GAtzPzmY0L7w38wPjmaL/qg0c4ZcZ8COefkTjsFkd5Q9sSxCBkR816SkZsBJsCoCodOvHSz/vCtajafgRxhLbNMnNpC+iYw+dy3bCJ+qNNmiFViSW5IIGdDyZZOy3vYE5u6/wU2wVhQ/cGaKnBfErpMmAVJCPBOkqw+gjVQwn6sbfRI6UUNNn7sq93eOrnb4nTY65fn1lgpzGi2BDgbSGuaRxSUOh4biXD9auf85T7WNATbh/v/Vdnae1aKDDhxvWjJBMKASe6VlxOBbyZPwJkXoXmpshOlanOrX91w2+BLjMxHyD7DLbahKw7JQCeoNPb43ICIOwNbI0X8gFe5l75Q5/zIhVABWqJb3La8LreNgDddT1NoAjyeSyLQyX29hhKf79tqa2hMalgEfmAy/fOLRXemgDNd2gHDFZirUFm2C4EgqogzDHpE/4rGCSIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 09:00:51PM +0800, Richard Cheng wrote:
> On Mon, Jul 20, 2026 at 03:33:59PM +0800, Gregory Price wrote:
> >  static void build_zonelists(pg_data_t *pgdat)
> >  {
> >  	static int node_order[MAX_NUMNODES];
> > +	nodemask_t tier_nodes;
> >  	int local_node = pgdat->node_id;
> >  	int node, nr_nodes = 0;
> >  
> >  	memset(node_order, 0, sizeof(node_order));
> >  
> > +	/*
> > +	 * Zonelists: FALLBACK, NOFALLBACK, PRIVATE
> > +	 *
> > +	 * FALLBACK:   Allocation order for all nodes.  Private nodes have lists
> > +	 *             but never appear as an entry in any list. Allocations
> > +	 *             targeting a private node w/ FALLBACK land on N_MEMORY.
> > +	 *
> > +	 * NOFALLBACK: A list for each node containing only itself.
> > +	 *             Allocations targeting a private node w/ NOFALLBACK
> > +	 *             will always fail (their NOFALLBACK is empty)
> > +	 *
> > +	 * PRIVATE:    (N_MEMORY | N_MEMORY_PRIVATE) - allows access to
> > +	 *             private nodes, and falls back to normal memory unless
> > +	 *             __GFP_THISNODE otherwise constrains it.
> > +	 */
> > +
> >  	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK,
> >  			    true, node_order, &nr_nodes);
> >  	build_thisnode_zonelists(pgdat);
> > @@ -5912,6 +5957,10 @@ static void build_zonelists(pg_data_t *pgdat)
> >  	for (node = 0; node < nr_nodes; node++)
> >  		pr_cont("%d ", node_order[node]);
> >  	pr_cont("\n");
> > +
> > +	nodes_or(tier_nodes, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
> 
> Hi Gregory,
> 
> A question about this part, if my understanding is right,
> ZONELIST_PRIVATE contains all private nodes, should we use some explicit target
> nodemask here to make sure only the targeting owner's private node can be touched?
> 
> Otherwise it might fall back into a different owner's private node.
> 
> --Richard
> 

Zonelists and the constructors here is a bit difficult to understand,
and I see I actually did a poor job of explaining what's going on in
the comments here.  I will fix that up in v6.

Lets say we have the following nodes:
   N_MEMORY :  0 1
   N_MEMORY_PRIVATE : 2 3

The following zonelists would exist:

ZONELIST_FALLBACK[0]   = {0,1}
ZONELIST_FALLBACK[1]   = {1,0}
ZONELIST_FALLBACK[2]   = {0,1}
ZONELIST_FALLBACK[3]   = {0,1}
ZONELIST_NOFALLBACK[0] = {0}
ZONELIST_NOFALLBACK[1] = {1}
ZONELIST_NOFALLBACK[2] = {}
ZONELIST_NOFALLBACK[3] = {}
ZONELIST_PRIVATE[0]    = {0,1}
ZONELIST_PRIVATE[1]    = {1,0}
ZONELIST_PRIVATE[2]    = {2,0,1}  <- no fallback to 3
ZONELIST_PRIVATE[3]    = {3,0,1}  <- no fallback to 2
ZONELIST_PRIVATE_NOFALLBACK[0] = {0}
ZONELIST_PRIVATE_NOFALLBACK[1] = {1}
ZONELIST_PRIVATE_NOFALLBACK[2] = {2} <- __GFP_THISNODE
ZONELIST_PRIVATE_NOFALLBACK[3] = {3} <- __GFP_THISNODE

In the current design, we actually can never fallback to another private
node, and instead if you wanted to - for example - interleave across
said nodes you'd have to do so manually.

I think it's reasonable to later extend zonelist construction to support
such a think like:

ZONELIST_PRIVATE[2] = {2,0,1,3}

Later if such a need arises, but I would say wait for the use case.

~Gregory

