Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22118CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E9A6B009B; Wed, 17 Jun 2026 10:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01FE26B009D; Wed, 17 Jun 2026 10:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2BE56B009E; Wed, 17 Jun 2026 10:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB0816B009B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:03:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BA041C4747
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:03:54 +0000 (UTC)
X-FDA: 84889573188.18.608B21D
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4C1D514000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:03:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="YNkeE/jU";
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781705032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21pxQXdsUMGW+bGknxxPyRxRyaJDV62jMRhp5DnWHkk=;
	b=0u7tX9IMEm6j+GVvsN5kl1quDam0w1KOjIeFWSDjRJeCFi7WOULD16Wtv/znWjFcc60xn5
	bRt0sDxCEnLmClCZ0AsgaaByglVT50f4V+miHMRTsv0yZNm8hPNA0n6ab0oVU0lfo0vyB4
	gfSsLjBPS7A7cgBbwVmTGCiFHzJGIVs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781705032;
	b=6SnP6lwAOnv5w8XHPLxZkH5GIhm16+NsPv8jfZopEPyZh4y/3HNKYIGOKuvXNbA3MiYhQp
	vEXeF9RClaSu1OiO4q6hpKW0JWSy95rxPgXaijycJMmOxoO/kJ5SUj5QkS+fhx4k3LqDpD
	EtUjyX8GSLBbPJDzSm9T+SQMdovaFMA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="YNkeE/jU";
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-516d0db9372so48670131cf.2
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781705031; x=1782309831; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=21pxQXdsUMGW+bGknxxPyRxRyaJDV62jMRhp5DnWHkk=;
        b=YNkeE/jUbajHrBvQq2N4HrfEkARjDhp2VR1/rC9KAgKwHWV2mKsj7KzrrGnvevK10+
         G99IhZ2yTVjuu0lG3R5jqEhghssrXGhJdcqEOSkjqMy3R9OHY2FDq+7L2xTt3rvNhk5u
         Cr6D+S5WCXUQOAzECGMEh3NArwjWaIsaX7LLaRK/3mFaMrejJAjSCVN+5B06RDlsLLaN
         orS/+l2ck/LJtQ1BiF6lZNQ6/8uflDq2LJM2p31i0n8P7oURbpNOKRnx90NuieAKcadL
         GhYjvI/IY+yZmNiKOAvkOTroL0+oTrH6ZQ1b79Ab5PZyF01g6J2jzAqpVMuNkIthfYIk
         yOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781705031; x=1782309831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21pxQXdsUMGW+bGknxxPyRxRyaJDV62jMRhp5DnWHkk=;
        b=JheFf8EVBCjdmwbXLkhBrQqOSizq1ba/7GQClaLKDMuunYKsLWj/Zcr69wcl8U9mjV
         RNxYXKvmSOQmUy7tt+6loIU/HY75RT9Swr4U2qb/6elH4SFTOzHPdk/J6nOLUTC9hXxB
         67a39JDMfTbN4E9uH0EjKGQPNUlXtxZJEKQRb8V1zpvEYSSJP17HnZrT4XbAsp+kK08b
         4wQ1f5xqywJs5JuxQihQGgKrtqBaikNMkHBMy4CFdPP7Gelo7Rk0F3UsypDbjvJ8iU+C
         6EGhZ7zOAUXZdrT87D12QKe254qYJPsrpq1NVH2TLCpkQgx0PhpaVe9ifljyXEUTwlRb
         gq3A==
X-Forwarded-Encrypted: i=1; AFNElJ+Uv43/PQaNLheE3PIMBmYzF4S66E6yt1vtjjpKeWsM1CdkPqYieUIEfa4JskmhhedGax/WYsVkxw==@kvack.org
X-Gm-Message-State: AOJu0Ywg2Rwz+sxQ2qsS5XsSJ1f/7b12a0K0HM2kD8Uc4+mSo5EJkk7A
	BZ6JsxwF1RfVLQplooDBgQuABy565gHR3KO4HomMPNdG5pzB2vjm3mlUNgl5oaQnQAM=
X-Gm-Gg: Acq92OGesli0HavsjKuzTbAxTvCgIBlP8us/xKEaqNIO89frZrTxoOq1ysyuC87gFC0
	3yrrouwc0eE4r14o6uJAvIugFy5exjOSOuC9NEkKQfdIDzM5GajA8xlPGDMGFYCQxadEPNC6NPC
	xjbZKVgZu1ok02W+qC5/zz1gu75v0fHjsTf28yGtLpyLpYnu4H4Tou3PNFtEhqTeCMf60KZGtTk
	uTDhEMdq/ibLD0S5dpY4R0M8xHUpbvoC5ytTdPgL9waRKzI4MfG4aSqNo48Gk/qzLxBxCOvaCvS
	YskHjtIoXBqJPLv5PVdYvVrEkWumWSzvAJmQXH8oRTGzDtQg3Wwnd+hKECyfVhtSaLTGIxqkVnH
	Pp63AdrAIMXf3i6TpjdF8KT9q9M/iqNmarIrVYciSJzhuX/YwQVLS/CaIik8vlNJGf73wKjRXPo
	+z5bbGXFoBHRyj+ivblr+2
X-Received: by 2002:a05:622a:4a89:b0:517:82a1:adf1 with SMTP id d75a77b69052e-519a8de2756mr65756641cf.15.1781705031230;
        Wed, 17 Jun 2026 07:03:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::3:ce0d])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51955b271fbsm134106091cf.22.2026.06.17.07.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 07:03:50 -0700 (PDT)
Date: Wed, 17 Jun 2026 10:03:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
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
Message-ID: <ajKpQgfimm-ztnHv@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <ajIb4DJdLGPbMB4V@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajIb4DJdLGPbMB4V@parvat>
X-Rspamd-Queue-Id: 4C1D514000A
X-Rspam-User: 
X-Stat-Signature: bygy87xun739x5xnqqzudx33qhsfrm7n
X-Rspamd-Server: rspam08
X-HE-Tag: 1781705032-629312
X-HE-Meta: U2FsdGVkX1/jT8oE8JW90t3yFDs/rAuT+4SNZ/t/T4vgy1gxvMOkBz0nuSjYLm7wOO9GLntMiONuEiBFqSwJLAzA3rznAlRhH8NVs/GytrQEwGwnAg8Dcqgl2yXXh9zDEMLCDYDSuxm3iXQRc5YhkyeY6T7CLN3nvOHk6zSi5J0EIRrAzeh8mSBdzsxrXv4TJcFafvCmzdFk9xfdfhzNM/tX1JmlMib2wg03kawYzOZVA9qH7goLhcqtWEtJ/5C7YAOUR9QfWCbdD8ZZAhGRoOeuklRN26hbtcsrup4eyZDGe1NZr6UH7GYCob/krVcmhuYkSBOs5vPF4U5hTUVsxlAhWBUfokDFcwfjaMLHXDTlJNI0uLUND/hksD+bwbRYX9f9tAFUlEqYpovHMRWsxnMznjCNUZNklg52OMANxp0Nu075iQZPObA3hkzowkX5/+ZJrhB9D0f66685UDdHjkB6dD+nq1itMiXv7vlZwVONYR7hHGobvZQg1MNidWM4B3+t+XmeWVh7s509CV8GMd71vWzf5tvoY0y741vYyx4CIVpjcvwCFHn6t+J+iY/V4VKuF0UgONbA4dibU8og/OYPuZ3J58UPieAwJ0mCysYXJKgJ7gYuOLPhjYsKPwL9QgLrMSFIitfzLVVuMt8IjLAZBsmkUerwNjD7i79sAnxlsd9olLzs4G0pnNPQ5TrniaotlRfwOzuXHsM05npUBrcyCIm6x65tOhdKka76RvYXb0eYxWFtwAwwcZqaLMtyS5s4qYEY0rQq1ktdu+za3pwYaQp9sIQoxiUPCIYw6EPRq4Kd8LNUdZOVD4uzFF1mvPUTWlyG3nQeGdSvR4iCs8/MQK5WWOzONQ6QJioRqg2O50Tv7b+mQyQNhaxaJfnPvsnjg0JZ7w1Agri1oONn5YBQSdulCPhhOYNDLxaK55C4t+ybEeWEakgWdXg2L6n6EAZp5nCXZWpVz+Z/YSf
 zZ4slZaG
 oB8h5vaLYAlLhyeuU82Tz1FVQYYnjnvmquVqbUFXGzMsGDWbUj/0L/hwNCCMnGDYYhlXp12AKGcVplmkDOEpxjELWwl0J43vqVRoahGn7kBYjXA+6yd4lz3onmy9psIwHd1Cv84M1h4v+M++fVL1LSzEAa39jusPwoMerlnUUKsrpOCP9m1SnQOEkf3n2jjdTuSzakA28CBcE3Bd8E1+7LtU4WHJgsGnNA5SKtcyrBT+h2MlT+xmhMUEyWp0VpnOc33Q5/Tbz7T9H29Ff5j5x6qPziA7bEXY7eFJ3hTXoVnAkp2UYDK2Nb8/CH52zZ4gOaL7hFXLApyYP0ppNURZr8YrF12idBEdrGnIxLCAkuwSEDLUwkl6LyvEPmIte9RAEL2MUctUsLYFwa8pfVipiWIbydj8BVxtcVPX2NWT0UOuxRy9V2SZ91MSx+eatRLCO8qFx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 02:02:47PM +1000, Balbir Singh wrote:
> On Wed, Jun 10, 2026 at 12:37:34PM -0400, Gregory Price wrote:
> > On Wed, Jun 10, 2026 at 05:00:33PM +0200, David Hildenbrand (Arm) wrote:
> > > On 6/10/26 12:41, Gregory Price wrote:
> > > > On Wed, Jun 03, 2026 at 03:00:01PM +1000, Balbir Singh wrote:
> > > > 
> > 
> > For mm/slub.c we can choose to do one of thwo things
> > 
> >   1) 100% refuse slab allocations on private nodes, i.e.:
> > 
> >      kmalloc_node(..., private_nid, __GFP_THISNODE)
> > 
> >      And will fail (return NULL).
> > 
> 
> Doesn't this iterate through N_MEMORY only? N_MEMORY_PRIVATE should not
> be in the regular for_each(...) loops
> 

If a node is in neither FALLBACK nor NOFALLBACK - it is *completely*
unreachable in the current page allocator.

Next RFC I've reduced this to create a ZONELIST_PRIVATE separate from
the ZONELIST_FALLBACK and ZONELIST_NOFALLBACK, and an explicit folio
allocation interface that selects which fallback list to use.

the feedback in the past week has been helpful in honing in on a
solution that I think is generalizable.  Have just been taking the time
to test various behaviors to make sure I haven't been regressing any
userland API/ABIs (mbind, mempolicy, etc).

~Gregory

