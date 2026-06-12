Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC84CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254B36B0005; Fri, 12 Jun 2026 11:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22CBB6B0088; Fri, 12 Jun 2026 11:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1423A6B008C; Fri, 12 Jun 2026 11:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 059C56B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:29:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5098A0181
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:29:45 +0000 (UTC)
X-FDA: 84871645530.03.C2A6B36
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id BB39D20004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:29:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qqmMt9+l;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781278183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGTIoUK/OWYjJAAY1+ZmAOAhqsOqMD1OUbmAHjFef1Y=;
	b=4o+XjXXzKKi8dDhYnlg171ooBKZFgRdnzKxV+TnNzgxrZ4yCIzHaDEJwhSvu5IQpfBcRb/
	VKfIVNF1zX/i/eSUc8efpetycu0rAoFK4HcVqEsAT2WY7K46j3kgP872Q3pRs31dHIPjer
	ubAwpXdRLDXbZXkVU9fodXwdEQDvOVk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qqmMt9+l;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781278183;
	b=PFdkDA4D6WDuZRHiLYtrAuB+9y1hTmnV/OF3S9+rnyefDPPgPN1BnYX9/JYJBgIwqhDxzZ
	6tPCF+Q5l8HDF9xKRgdVrOLHkUthunLyFY2t7sPHvTmY6icNzz1zrjlX/a8UrqvCJ1KRFJ
	9ib+bK0l/cWyrBNHCwqFJDyIYq1AcQE=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5176096116fso12000581cf.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781278183; x=1781882983; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dGTIoUK/OWYjJAAY1+ZmAOAhqsOqMD1OUbmAHjFef1Y=;
        b=qqmMt9+l1QJTytzb1QattfIGbvql57X9s9SWAxn/SELYqFwfZcFdYuKCrOn53uBf63
         JtiDOI7C3c/4gtMvKZVFnV/kMGWK10bNdr8jlsfWTQsE8JXJ0UDfHEYOLMJoDus7TMF1
         9U0uWpmzlVZNu58HOZ/RmwNzmTQ96XZGhaIIHBJIQXcXtRP27JqTmNFLzC14tDS9G9yI
         oQzvzVQ9Zl8sq6AyZDiHw3m5364E0E1Oj+hdDhbzH2mNSSN2Uij++OqLsRyGirf/579I
         337WS2Fmn1xjpvlJUBjlxMt89a79sY9UaxTWFopYhFZR6VvM/ntoTEfdApcDEncp1rWe
         cmxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781278183; x=1781882983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dGTIoUK/OWYjJAAY1+ZmAOAhqsOqMD1OUbmAHjFef1Y=;
        b=pdH/JCc7cdAey0HQ84nkEYJvVFqCsjfZ7PsgeyY8OY/O8UIe8/z4nkVZalScDwHl3o
         SfQwIgwNxA+Cmd6oiuP9ORjTfA2b11OupIcAfD7kboWD0NyU76nNhu6aDIDBC7WbknSu
         qDFSAisphPIUy5Gds0cCNcoiTz2PUwaJ11idotBSk1KiqpudkUVmbsQuH+Q22bCwLg77
         4FKuXvaF+QZsL8xJhfxZ+9wvSRNrAM3CRkwarI72gAK9wMlXQEpbR37vVkA0T2hO4MEo
         7BWGSOGBCyjY6jx6d8blzTc8u28heuZZSa9+3YU5CcXIAcDQFLl319Nu5m35K4n14VyX
         d/DA==
X-Forwarded-Encrypted: i=1; AFNElJ+QQADa0pVmAWe9XI/W85ct6S84VKnpAlQhtcTZcAqYVkeRacYU/eDpH10b5m7WwagRyb+scu+3+g==@kvack.org
X-Gm-Message-State: AOJu0YxyDGQMlFgbr3EuHmos92jHXvXVxGKUelWwg8Ci6GZw3PxhQlms
	PY6uvMJqjZHkMYosdKhLnWQKKLme6Li0G11IqIWNkpjgaRdN2mrDAIa6tgKHmqiQ4dY=
X-Gm-Gg: Acq92OFWv9AENeDZP7DND/Q5ucRfOCwvqqeNCJbmEc9gCcYh7n8QGa38hH+dJ5P1nu0
	FoQhtZCjuR9YMGdbfqo9iBo3q9UxlbzA+OI/Lcb973vxxG18ApBdfX8RVeV1ntFh7kA7ZeBJGBc
	yiZr3oTkZA0qvqiUrB3HH1tWL8+oIrbQ586Mus3BLMoZ8tdbsBzWsacz9mwL+WhNEX8TLcciUwh
	y4RgWy4W1sYjGz/4/OO0XzOSxwLTmVnCwUscKCKL29FCr5atrb48jvuNUp5qFcwFDOEw9RIVtzu
	8Lc65PFrSyAPGJYTsMSv8WWYFgnX1FyTcCufyLZCg8GVvV9JJrIdiB5Ix7zLFyUTcQ33dLjefuU
	YAhcl/FEQE0XdcaB7PXXNX69reS2saZOW82aedLmhP9IRKi2E1nVk1LgvcFmZfnqV9UTKI8VrVa
	li5cfjNbdNZd5RcawlIPYjAC28FTSKC3p0pTdJiZMgoQefdwZ4CiibX246IV911wt4gOPv6CtrR
	iZWY5I=
X-Received: by 2002:a05:622a:1445:b0:516:ce43:f4ee with SMTP id d75a77b69052e-51953395db3mr1534991cf.20.1781278182636;
        Fri, 12 Jun 2026 08:29:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb7ec47asm23782211cf.24.2026.06.12.08.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 08:29:42 -0700 (PDT)
Date: Fri, 12 Jun 2026 11:29:38 -0400
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
Message-ID: <aiwl4kCG814dpX7L@gourry-fedora-PF4VCD3F>
References: <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
 <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BB39D20004
X-Stat-Signature: 9th7hz86q9dhj9e4jjgcma15fg6z9bog
X-Rspam-User: 
X-HE-Tag: 1781278183-3709
X-HE-Meta: U2FsdGVkX1/CrYkQqbYzqbnsjHEHkpy59yTLDKyR8xfQ/6PmWev/e168/Lv/DmnbeDOPfHo9IhtxoJUYaL5bI+GDfcmarJb1/StLseLw+HhY3LTrvg8RPbXTjpX6V7Ow3xZnkMIouZe9AzWv0idvx0r5PdBFya26kmwKQCThW3oaM9oS0XL2zBO4F0jrYNu1RNg2c0geFhanRriYpGergLZaDkaQtp8JaS+MVSAVmpfzVon5veSIr1eeu+3yqR2PAxsX+FG3ON5hwXeMq1aUABPlygRF0KXin2v5CXMGnWZbusncO9c4wisF6+rLezqiuoFp7BQ6MeXZfNZRDzmpwj61D1hBcuVwe6fUDddQWMPwS3lQHmOBAgfwkFV0QTU2yI+vHGj8BFF5Wwb0a2JTw46HTeSHDkeefDdniBpc9qXZBDisV+i7nVMq3vPQskeKYH5yLon4NXXGmjIQi1m4WppeFm0b1wALm4LYsSyUlYpCYhMK7nTnF7ApHtokYgybX/ZaqTrGsPjP12wSGlz0ZsTpPWJEh4xbbDUdhqk+1KHFm+K2gCT3fmdJfyh6bIu5MINovf6YD+DNeBAWgWKOajdKLpFBs/e9EeXje1QeKAqTL/9RnbTtkItwESRVxRIxaeDr/ioUJWZL0sHf3Ewgb+HMw3KnAY6BtFXq4iENAbhNo6ZOmVDpBj1MjsDCEDWmUCKa1uSmwkDkvpUg4lX6HeG3Vlzb8hsflHmUS63wmKnQ0ms7Wg/LdakD5Xxf9dwgZYVYcUryhBNvSK45jc0uO/nTN/R1pqqAo78SZ/r2j1WAVOfZq/5oC+UN0bFbI842sRhmDL/xcNX1rNAMgY7ndLY0FnOQAQyrA7t3kCZQEMN78jiTLTxiWosq+1wdyPc6QrHkAr1spG3WDEywocOaxyB81n0CjueH37CPYeMnGR5DqH7CASFXk88PgrE0gq4HDz8vUR+thUiyciJKMuN
 0sW1qs1a
 Wd0FYYPacElcUHt311It3uIczP+fiL4V6lXlq1JdUjWPXKgPqnjwl3TAZA+5dB1voF6wFy0hH7JXpjfQ4epPrqDFIoye6Y9Xe06k+Z2H9qlgf4plGnnYrU554vapQSF5sanE8VIAcvTzwCLpOmEC4AYxOmQ74L2xvC55rouo0j0sbINpI+xmEYUu9O+fRxVpSwHYRS42+LJG46uBpIwvskcenZ1B655hnpDS5kUrdUmpTH4w2Ay6GjnOsEKibBBgqjl/FA9oKY9t6U/BMhjF9KYSxZsDiWDj9wtyP5AOuTK8asgCnBlvDHD2SEkMb3qc/fnkcC5YoDSQao05SlbtmZEM/7pR2JcbqWg79fTQesYRr627tOis8YJau1muIJ5+RPATd9+F1dSWrMJQRcdm4nomzANME40nGI4r3ioQ4CrfAGZxnOfGv6K7qIKpL4dX3GMDfdlR3I4zey8osbkb8ZPg3PJE4eBlQ/B/ldO/6hW38c4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 04:12:52PM -0400, Gregory Price wrote:
> On Wed, Jun 10, 2026 at 08:59:59PM +0200, David Hildenbrand (Arm) wrote:
> > > 
> > > I understand this question in two ways:
> > > 
> > >   1) Can we disallow PAGE allocation and limit this to FOLIO allocation
> > 
> > Yes. Can we only allow folios to be allocated from private memory nodes. So let
> > me reply to that one below.
> > 
> ... snip ...
> > 
> > At LSF/MM we talked about how GFP flags are bad and how deriving stuff from the
> > context might be better. I think there was also talk about how the memalloc_*
> > interface might be a better way forward. Maybe we would start giving the
> > allocator more context ("we are allocating a folio").
> > 
> > The following is incomplete (esp. hugetlb stuff I assume), just as some idea:
> >
> 
> I will still probably send the next RFC version tomorrow or friday,
> as I want to get some eyes on the __GFP_PRIVATE-less pattern.
> 
> Also, I made a new `anondax` driver which enables userland testing
> of this functionality without any specialty hardware.
> 

(apologies for the length of this email: this will all be covered in
the coming cover letter, but I just wanted to share a bit of a preview)

===

Just another small update - I am planning to post the RFC today once i
get some mild cleanup done.  It will be based on the dax atomic hotplug

https://lore.kernel.org/linux-mm/20260605211911.2160954-1-gourry@gourry.net/

But a couple specific details regarding the memalloc pieces that i've
learned the past couple of days playing with it.

1) memalloc_folio is required to ensure non-folio allocations don't land
   on the private node, even if it happens within a memalloc_private
   context.  Since memalloc_folio may be useful in contexts outside of
   private nodes, I kept this as a separate flag.

   If we think there will *never* be additional users of memalloc_folio,
   then we could fold _folio into _private to save the flag for now and
   add it back when we actually need it.

2) memalloc_private is needed to unlock private nodes, but in the
   original NOFALLBACK-only design, you also needed __GFP_THISNODE.

   This is *highly* restrictive.  I found when playing with mbind that
   MPOL_BIND + __GFP_THISNODE generates a WARN (valid WARN, it normally
   implies a bug). 

   That leads me to #3

3) If a private node is opted into something like Demotion (the node is
   a demotion target) or mbind(), such that normal kernel operation can
   place memory there - it's *pseudo-private*, and should actually land
   in it's own FALLBACK list (reachable without __GFP_THISNODE, but not
   reachable as a normal fallback allocation target).

I'm still playing with this, but I think we can even omit the
__GFP_THISNODE requirement (my initial feeling that __GFP_THISNODE
didn't buy us anything in particular seems to have panned out).

At the end of the day, this makes the whole memalloc_private_save()
pattern a heck of a lot cleaner than trying fiddle with GFP.

I think you will all enjoy how clean the code ends up, and how easily
testable it is.

As a testbed I've implement an anondax (we can discuss naming) that
adds some sample NODE_PRIVATE_OPT_* flags so you can do the following.

I'm including this in the next RFC - but we can hack the entire thing
off (including the OPT flags) if we prefer to just get the base set in
without a new driver as a start.

echo 1 > dax0.0/reclaim   # kswapd and reclaim run normally on this node
echo 1 > dax0.0/demotion  # it is a demotion target
echo 1 > dax0.0/mbind     # mbind() can target this node for anon-vma's
echo 1 > dax0.0/madvise   # allow madvise() to operate on its folios
echo 1 > dax0.0/numa_balance  # allow numa balancing for this node
echo 1 > dax0.0/ltpin     # allow GUP longterm pin to operate normally
echo * > dax0.0/adistance # set the adistance for hotplug time
echo * > dax0.0/hotplug   # same as kmem/hotplug

This also means *existing hardware* can leverage private nodes if
they're capable of generating a dax device.

I've even gotten it such that you can put a private node above dram in
the adistance heirarchy - which means demotion flows downward from
device to CPU, but allocations don't default or fallback there.

This seems *immediately* useful for a variety of use cases.

~Gregory

