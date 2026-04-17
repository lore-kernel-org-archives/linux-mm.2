Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BFBF436B4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 022DA6B0119; Fri, 17 Apr 2026 11:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F160B6B011B; Fri, 17 Apr 2026 11:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E049A6B011C; Fri, 17 Apr 2026 11:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE8036B0119
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:08:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FEE0140220
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:08:00 +0000 (UTC)
X-FDA: 84668377920.12.BE6C43B
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 68B9510000E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:07:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TWUg1PPI;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776438478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8hmn8cP8J8LvjQAqTAHhf9pkwu4llVl8k7YZT9Lr2w=;
	b=WGZ1bYlixbveJhdl8NQSURv7tTuadTnvGaLJFZJxGTajsRsoqXMHBpc7BLEpD2rx9BSsyv
	uxlOqoSnYl1CwOijkDWoGq0mSyoM5OEo9IHM/1nnhF6ToNAicNYV/fwZkmcXxZYn0qqW35
	sAx/aMTNz71Yx0HwERq8Jkik7gZVtlc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TWUg1PPI;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776438478; a=rsa-sha256;
	cv=none;
	b=IcKTN20k95RKQqILTOuahz2Sj1GoI7Kj1j+vcZYMuQDdwAj07p4Gem1Q2i/PfXHvYkAnTb
	6+OQE9+JWnEepwFaigXoOKT/iJYGpf7viwlZGKglyeQZWtbx8yxSdxt3vUfGCNd23FiTST
	fCpDmNiim0zKnOXsP08h9S1pZSKCz7o=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-60fd9b71745so294432137.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776438477; x=1777043277; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l8hmn8cP8J8LvjQAqTAHhf9pkwu4llVl8k7YZT9Lr2w=;
        b=TWUg1PPIvWBDS5kNiPtCoM6cDLkX5Fo6ErTKm5T15gn3xDdkgcO/og4tSuwLmjQdVs
         ksHP0q3pnh0WXhc6v/KfExaOiKGPQzztu0aZbWWtk4W86S1fMJ/cJUllK20Bq8LFbVt3
         vPnhcZjnPVKVW8l1Sh877nOWrY8zc+0IqZV24xZeP7AvzaMRueENcbM2Y7W1+hNigJw3
         CD0Os4VAb0KZnZ9BP6sDD4u/wskYYfsMeKaFexPmNI8qXRi02Mz7e4guMFg7K0/W2F0k
         hTdtcXz6g+tG2udhpF+yrxkebYCNsMkBwYECT7zEv3oiZbz8/tosCaksSyGE+Q4rLk5V
         tnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776438477; x=1777043277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l8hmn8cP8J8LvjQAqTAHhf9pkwu4llVl8k7YZT9Lr2w=;
        b=gyQgsUlnszh4AQEj57ifgXBvp6Fev5MoELlogwAPkZaz1lyhhynwcRDtYUj8ezN5GF
         yfzEZzq5rDrWsvMY9ASZeEr4nIEtLcUmR+D5dwHXgRckKS+OvLKmf8M0F+Ax7Est2WYr
         DgirFtGj0EAG5SP10n6bOd35Myd8WGr345PQqs4184EySx0UbGOtsZlA87qB/couko8X
         IhJ4v9WFqiLWHMjoTFKzRyeuLhvcRgUBFf43Sh+FrZ5SCtVOSxE4bqNBQWCVccZGigPI
         bhXyw18xIwoQ6GXY+b0eViWezwZXxRoh+m75oBbu+xyA2nPGtkJEwksBmm8bLB1AugU7
         RU+g==
X-Forwarded-Encrypted: i=1; AFNElJ9gBhbTHQCwSSR+jVnji112H5Wyys73k6AO4HnCWhi0xS4TdpBbCCwVhPoqHzIvUSe9Nq05DlZxMQ==@kvack.org
X-Gm-Message-State: AOJu0YysMg4HLBuFwYCLZ5aCvY7CAS3llSANXeS6JAeywewscawC2A1Y
	5oQosoJFjDybu0APt5CMXqmXUYcOExsDx59WxmIYN1nDAOpCMr0o+x+9Cj5SUUm8r9o=
X-Gm-Gg: AeBDieukAHxqdu4GIuGqAC1E5RPSjX6GvcEkeVx3tmCgVALLZTXhL4NbVptEJe5hhI8
	jQX4GxphEIPXWADv035CzBQIIiuDcza9TbnOW7rMAmV8nNS4gi8i0Sfm2g99svyaqmY/elrtnNQ
	BX3jTngunUPGSky0wL4RBbTAbkqnSEZaPigqflJA5sStTMSQBRbv00lNfNI6ZdJMfZSu5yj8+YD
	6xn3r5JrjWtss9X+edZPenHOEssFOPQLRZzjPJ/tk7bEATkkofXQwkc+TyTyMi5CGIWZIMZXSNK
	GDvKG9pnbhR1MvTVdnYJwHz1JEealLRMfnpwiO2WFP5Cpl9WtOdMRFucGYl453aaUNx6zylvgJL
	22ew00+QVa1qdzsbBe11mfKaW0R7P6b+zIyKlBAdZ45iqKHukZRb71L8yxzZam55ksX1GWT27hj
	IPH0VDZRESrIT0x3BKAY25I2+W2NkqAtjd35LXnocrhKLcT+r/bvY6e8kHLcIY1ik+vvTxtgb/4
	3f4ymeOYGNwYoPG03V6
X-Received: by 2002:a05:6102:162a:b0:613:6b44:3fa9 with SMTP id ada2fe7eead31-616f71ff8c8mr1462957137.20.1776438477197;
        Fri, 17 Apr 2026 08:07:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-108-18-109-80.washdc.ftas.verizon.net. [108.18.109.80])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac6c3e7sm13032726d6.13.2026.04.17.08.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 08:07:56 -0700 (PDT)
Date: Fri, 17 Apr 2026 11:07:53 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>,
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
Message-ID: <aeJMyYMQWLyiGTRb@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
 <abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F>
 <2608a03b-72bb-4033-8e6f-a439502b5573@kernel.org>
 <ad0iT4UWka3gMUpu@gourry-fedora-PF4VCD3F>
 <38cf52d1-32a8-462f-ac6a-8fad9d14c4f0@kernel.org>
 <ad-r7hwIdnvKsrh9@gourry-fedora-PF4VCD3F>
 <CAPTztWajm_JLpp9BjRcX=h72r25ELrXeGkOXVachybBxLJGS=g@mail.gmail.com>
 <aeA6aNDpQ-U5UJCs@gourry-fedora-PF4VCD3F>
 <6d4f702c-5ad6-4f84-a73e-c9e34965be98@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d4f702c-5ad6-4f84-a73e-c9e34965be98@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68B9510000E
X-Stat-Signature: us7tb6bg4wcsrr9gu8m837o44q818t3z
X-HE-Tag: 1776438478-897368
X-HE-Meta: U2FsdGVkX19gxMtJZRUYgy4h4XlhGVI2dwiP92yet79GWk62u7RBNOr1FmNtNLWfSUaa58VS10Y7uk0sCprYcXHJkq2r+sv1PYS6YT/bdN1gz6SsAyAyDImMomXnNyV0pBLnCpdLxgtBBnBiK56TUjz6ToHNv8OYW59ukQqBtLo+q8ErUL2TdqTrqAJ4x3t2dRd/2UhjZENvCxtRgfU3eV+gtCgErAhbume8wRugg62Jc7Y3pMqsBXarU0ZOJ2Alp2Oc0G05UCx0FaAAiPOXZ7BXwTe0L71rg6aDhUctgL4upLD0E5x5pbvZJJ8Fgr7n4xrPCOrYLnnH24NCNThdSSNa4zyFglZy3jefdOtn/ZqjgWYvQy4cw+gBM5P3aEL+d+ZRgnraNN5cWeVrwBoX+4E2hTaukjwQmkQPM3j4qumebsni4GnVjOrELC8WEa0gp+ob52X9e/9X0n6xBlZJYmoeHl1ktiMjGOv7d82wT4NqU2KPLfmtxwFaZR8qFXfBNtFTMqpXhznmWrzmL9fkCiwY73bxYfUftSGjQ22cH+fjjjNFEXcWQgX2ZCn6akcEFpjWyf+gLo22geP5RHBvx/F8ITSoNs8a9XGxj3csI9M1Z0fprYFf1KCCxWxsoRSLXPBIn5Q2GddXJErvh+Xi21IdzCtd6rnS26uKltqq5XKbvcBexr9Lx4br4AwK5C9Vsb3cY6WE3qcBye18LdtWyLXuv+wI+A0MwKMbfR42Pj8Zz/RzySSsiJExqedRht6lVrNZbolvVU824dYx1OdJUKcqeOpMPUuVrMjlEewBN9RzSfdR3dDAwRBFHovRhbo89ltNz3ON4RSeBHQ8cbOuWlEt6LqToyGESVL5uAOJZXESyNjrgowKfTgSwyXZQVB6rsbOSdRdOjUDaPl8tQOJ6Mte6S8GRVDN6cjo/wlfRep4oX+saXN9h7SlzZsLwDMVf43ayagO585tAi0k5LZ
 D95Nc78T
 caMTNpKmsyZC0icKS+EhwhA1hGhDfipjTOQ6QbWowgu/EpNpL7vt2djj4uszqNOARV22EBXPZk85o3aNxwfBisBC5m4spPUBRfCUsrKo50/RRHH+Zc0/1jBrykaeqzny7zCDBU6OYYAMjP05cizciLXqAuP8CrzgREyS/NbGCdt5YF8L4MLXpeV90G6JUSlxMXgi8oiQ73yMv1eEQfsagiUx1fWD1e1QDjrWqwtoQMuocfzNaVStWmXbFv4DnxqZz3aVOnLQq2OQzO5B1XwUgvsXboksDy7TZN+FYgqNgXMRcNOY3qoiLMuuO9CxsJhUTyP7lmXvUyx01rQBDpsstKhV6RhPrFx3aNyLeR+IdCWvK8eDlk2CFMBpzCi4GpJD1RYPPTdEZ9EFZ6sOplGLYFMLeqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 11:50:58AM +0200, David Hildenbrand (Arm) wrote:
> On 4/16/26 03:24, Gregory Price wrote:
> > On Wed, Apr 15, 2026 at 12:47:50PM -0700, Frank van der Linden wrote:
> >>
> > 1GB ZONE_MOVABLE HugeTLBFS Pages is an example weird carve-out, because
> > the memory is in ZONE_MOVABLE to help make 1GB allocations more
> > reliable, but 1GB movable pages were removed from the kernel because
> > they're not easily migrated (and therefore may block hot-unplug).
> > 
> > (Thankfully they're back now, so VMs can live on this memory :P)
> 
> Heh, but longterm-pinning would fail on them (making vfio with VMs
> angry). Similar to CMA hugetlb.
> 

Yeah, depends how you configure things.  As long as you expose those
pages on a separate memfd and online it in ZONE_MOVABLE in the guest
to avoid vfio from touching it - you can have your cake and eat it too.

It's a bit of bodge but it works.

However...

> In the latter case, we should have a way to identify "this allocation is
> actually from the CMA owner, so longterm pinning is perfectly fine".
> Checking the CMA alloc state would be one approach, but that's rather
> nasty. I guess there would be ways to make that work.
> 
> I'd assume that people barely rely on 1GB ZONE_MOVABLE HugeTLBFS Pages
> (iow, mixing kernel-cmdline ZONE_MOVABLE creation with kernel-cmdline
> hugetlb reservation).
> 
> I'll note that there was long long ago a proposal of converting
> ZONE_MOVABLE to "sticky-movable" page blocks. It wouldn't really solve
> this problem, though, where the early boot code just does something
> that's rather stupid.
> 

I have been toying with hotpluggable CMA regions.

Interesting opportunity:

  Hotplug on a private node w/ (RECLAIM | DEMOTION | CMA | HUGETLBFS)

Now you have exactly two enabled consumers:
   1) HugeTLBFS
   2) vmscan.c demotion logic

In this regard, HugeTLBFS is the only one that can reach these pages in
a way that could result in the pages being pinned.

All other pages on the node are - by definition - movable, because they
can only reach the node via migration (demotion).

The system can't do fallback allocations to the node, so it operates a
bit slower as a general purpose memory pool - but if you decide you want
to optimize for that you can unplug/hotplug the memory back to a normal
node in ZONE_MOVABLE - without rebooting.

~Gregory

