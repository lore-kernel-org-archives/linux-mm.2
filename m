Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2BDECD4F21
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 14:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9846B0088; Sun, 17 May 2026 10:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373BC6B00A4; Sun, 17 May 2026 10:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214606B009E; Sun, 17 May 2026 10:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3A06B0088
	for <linux-mm@kvack.org>; Sun, 17 May 2026 10:06:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B231C1C1944
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:06:03 +0000 (UTC)
X-FDA: 84777085806.02.89F0229
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id D329F40008
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:06:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=f7cWypav;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779026761; a=rsa-sha256;
	cv=none;
	b=fClLWF5TIVPwWKfBAtsBaVIX2gBN0J4uV+nsxKaAxBFRvKpT3Dw8Sc0AM7oShfIMInrECp
	fff29EIw4dC322xiekE7SThZXyUTCg4fAZDLcdFev1lbCIHhMdCbyyltN0IFX/F7O7DH1C
	X2SZznL0ktWfeBOrB8OTwF39pt0xKeA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=f7cWypav;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIRKPR/lC+XE7adaROt+ezeykmbd32sNS3h0a8aSH/4=;
	b=SAvR3XkUs+I2Y4FK4gVGU7SK21ceLrB9w+c9eULlGvGG5hbZAzXoJTg5i7wQPfWVQGVyAH
	sJ+ngrpEMPRzB63Uj0u3uQFgX2d7zSC1jbcU08eMzOs3ZCt0cmiFfqyL50MLumhqtmFpUj
	X+KrFmajg8Frhp68nGNI7T0F81JSRmY=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-514ae601df2so6167021cf.0
        for <linux-mm@kvack.org>; Sun, 17 May 2026 07:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1779026761; x=1779631561; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iIRKPR/lC+XE7adaROt+ezeykmbd32sNS3h0a8aSH/4=;
        b=f7cWypavbJPFs15qntQdPzJAAbu14DQcjTYlggbFoNxyk2laLTRHXko2DqVm70LGTy
         QYW7Li7lG9jUy/EhMXP+sc3PEGYqGbTp8gErI5we5o7LIfuHH0Ekp8FTDNfiIpjU4Aqg
         mRQiCHDk8HC+Eri2f8XZ5vXx8Kytc7TDk2nZIEUZtBF0sLOFjHXWnmIyAX/yfczH30n4
         4HZJl/Rt8KYtuRjZ/xupo/zVqoQyZKxGoCVCdXsk1Vzjwgm1eAXi4UH5aEgTu4a0SP+Z
         lSdoDVOlJ2DbHxCjK4N4aDiy81c2s+FjY9RcfdqecFmKC95E+8z8mLwvNbB7Zcf5i/Cc
         K/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779026761; x=1779631561;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iIRKPR/lC+XE7adaROt+ezeykmbd32sNS3h0a8aSH/4=;
        b=rZXzoCl3yqeCDrLZRvzd6xo1TRmWQd8+lUht58eQ3RoSknBg2Pa5z8OMofC/1PCL4u
         XXYkXZSwcJDhic9D1GMXZeEHcbc4yN8cGmIcsL0Cxrp8uyQ+lN0oc44LtaS+dVTP6kXa
         MwvdQv/M3nzafzZtuEyRv1KuK6YNjZeeCd45/WMl6Jwd5smTR/jeaPSJ/gHRiNf/7DM2
         8+qmqyiF6QgtAuCfxtg8nx3DtQhpYHk3xMQbZx+4CCGA1bv/QxY53Vt4UYWcYKiC1EWI
         4HrAo53fMLYMQQTeG8H4Tqt+eWeIQ4a6KUvTNvxcQqKNIDOZqSxhV0frx4GR3RoydSY4
         uX4w==
X-Gm-Message-State: AOJu0YzD6guYnunBe3S4GF523NOraT0EWFmie4KLWq9xlgRF6S3cYas3
	7ZBkHr9m8YIX48nke9XanwKF2xdau9kJUcYQIr42PWwE21zoA7MBYlKmkq/T/oIZyB0=
X-Gm-Gg: Acq92OGDm80I6jWKz2N7RIdxDtcbEOk7HyrNu4jOmxvHjPbZhiqzhf82UqEVGcKeJcB
	WRXup+PgYOCLChk8ER/2dzUcVFwZxOV/z28HzKUg14YI9tYo1VpYVVDk8m98SZhWhAWP5IRDULo
	slYGXLEn7z0q3oniCRV+m+3lqIjwINxoQqfi+sRq3tbeJgLi2xUP+NW5QQqcJPTxuTlboZL5j5W
	GKrVLalWRwx0Ecj9aYTLaiKAREd+GKNmdMS6Q6otQLLS0PZgt2clrJCbvp3QRDvBlUZmFVoLP2H
	V8Cvgihym4/rI6lEy+28zluojs0NfndclT1XG7ywa3Z8vEQ565gCLTCKojJvY6aRFPa4UjdFoe1
	zsvURUjUkbM6EhiDJ2EusZWJDyrKn3v/CUWNYZeUPYBLS887UF9K/wov+qdF3TkdT5xrqT0XFMu
	i1fl19e3scscONRFPNfDiEHkCa8AvY0f0JjMrOmlHjaBYF9KfOG31PPebbLHcLcvr/XtNeoVhZX
	7xL6hADr3cp
X-Received: by 2002:a05:622a:15c5:b0:50d:a8f5:1c02 with SMTP id d75a77b69052e-5165a219a43mr174364271cf.41.1779026760702;
        Sun, 17 May 2026 07:06:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5164585fa0asm112385731cf.31.2026.05.17.07.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 07:05:59 -0700 (PDT)
Date: Sun, 17 May 2026 10:05:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <jackmanb@google.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, sj@kernel.org, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, muchun.song@linux.dev,
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, jannh@google.com,
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, pfalcato@suse.de,
	rientjes@google.com, shakeel.butt@linux.dev, riel@surriel.com,
	harry.yoo@oracle.com, cl@gentwo.org, roman.gushchin@linux.dev,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, zhengqi.arch@bytedance.com,
	terry.bowman@amd.com, owner-linux-mm@kvack.org
Subject: Re: [RFC] __GFP_UNMAPPED and __GFP_PRIVATE follow up
Message-ID: <agnLRSpecgsQzNOn@gourry-fedora-PF4VCD3F>
References: <agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F>
 <DIJ5IBGSO0OC.1S6AARO01CD6T@google.com>
 <agdAZQ4sEdGItwc2@gourry-fedora-PF4VCD3F>
 <DIJF01KNX2V6.23MF18D4X99EX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DIJF01KNX2V6.23MF18D4X99EX@google.com>
X-Stat-Signature: cwq85tjgmku3k6ng95hswiqd961dnias
X-Rspam-User: 
X-Rspamd-Queue-Id: D329F40008
X-Rspamd-Server: rspam07
X-HE-Tag: 1779026761-51897
X-HE-Meta: U2FsdGVkX199uaEYk0+OlhiBD5Ndr+bAJaqJ2ATK/B+lhlYzNmCdmsOV+Ge2Tb4qa9PeNiwFBIm6HY9Rj8ueHctzEJB09UEctLvznZcq66NUXimwv4Q6GBkaFCKiQH4IvoMgJKlLSGSZ3MJJNobGeOJdLeL6unLxDKQUG2L5Y8QgvAwqpv0pWnLkkn3gYQzrURDl909fkGve24PfxZl5eTnZeqYs2GLw4W7OgmFPcU4LOa4nxWO2/wZGZdH8tO6lYCeBC0WzUC9u8Rh/Q5w9DUdJztCk/+WyW0StAMGIbY2fD5GgIwlZe9G7JrialcMuEn04I3MlPJSz8WjSN/vE6EskbeU+wgD0RmI5CGnNtZURjY6lxBJ2xrKWK866kCpXsfIb7S4zHhBCK1qkfwbDSm0kOYTOBO0vo7YJ8V4+z57C0n+02SPh3FiS2X4j61t0woDo0bAVSnqqWq8wCTn2UEVcIXFN3hVDGeGvuNBQFDjJ6xB40+Fv7retjsQXwU2ZsHA688XEx1Xeg0goUINoEHW6FG05Mn491VvIAAt3QdvXeM/njTJ7uOZtwvU6ZiI7toEDmEXtGtf4TyCgAltbb7lgAyXtjDXuAwv2GnPY21x+kQH/8T2A4doO4t8UJ8jJh9mEHZj1h++zVcwS1hoE+iD+OhdsRn4g2QWUh7DgMcZT6F/R2Cymg2U/3LvgsL8PW85AeAao/CwLgOkfC/hf0c7z8xVf/88eLbjPoL+gm3gqyB3msIq+vlkITn7Sbhj6li2Z7ACkrrAJBAibMe4xFeU21kZK37YK45cRzwBDgsiZosOLEbh3WO2Hd47djMTYES8CLT1LAkNHkr0dakPwZQMOLJu/Uhvypcj9WMmuyoToI4IcQj9AvVDPIhdJXGht6LtB2PewRwGUele5JURRf9jlpYK2zvRFLAq7VFc1ZwPeSw+Vwb20z6UDYvMQ55byBJl+39qAAb18MiaiPDz
 U75QaUIy
 DNc2Gfr+DLHQDP5HtWiAu6Ik75Go3UAPpSjuJMsO1ipuDahOpOleVjuM0TyGd2n7uiimT7FGhK3qzbVa0+26bMCW5aWM0qnZDtvVVB+AEyLV87m5lpH3yAUaUD7crndie/ODvQhYmO2EXj2nATeWZZqUJmz6RWLPxbrrWFlsUeXre/DNF4BlHVD7itIhIczGaH1VdfxwhRowSPmeBYgNk2bfQTKLW8uWq2plHTk5IIh4ve5vuRG1gKBE9r9DndWUWGImtBa9dtJm4b+cHAl3cb/9GKrcjkG4cVGacezRe+dSKr6QYeciNCGTBC/jfcrP0NDIYx8DYSCMJ82QRSF/Qp8yBGofw+/KXCfJavUV4yOLHGaMoyAxyiJo9aPias0YTvDCHcwp8MH3hOYEsj7qrXBs/4Hzx6JZVUzusev/nq8ntDD1CaB3MEv3MbHPS9GhbGZVfFgvWMIP2X52dK6GvtQLx+d9jJZ21p/3m3DaxM7Zqf+BlUi6ErHQlRKgaN+hZuGO2ri4y9AgESsPIXPBipvM68MAfpNlaCErK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 05:09:21PM +0000, Brendan Jackman wrote:
> On Fri May 15, 2026 at 3:48 PM UTC, Gregory Price wrote:
> > On Fri, May 15, 2026 at 09:43:02AM +0000, Brendan Jackman wrote:
> >
> > I'll have to think about the NODE_DATA replacement.  I don't know if
> > that's really feasible consider that this structure is used statically
> > all over the kernel for runtime node-data lookups from pages/folios.
> 
> Oh yeah I wasn't thinking of replacing it completely, more that the
> global NODE_DATA is the "default" node data (and the pointer field being
> NULL would probably mean to use that), but then private node datas could
> also exist.
>

More accurately - any node in node_state[N_MEMORY].

Any node not in node_state[N_MEMORY] and is essentially invisible to
page_alloc.c by nature of not being in any fallback lists.

In my series I don't add the private node to N_MEMORY, instead add
N_MEMORY_PRIVATE and never add them to the fallback list of normal
nodes, that makes them functionally invisible unless you call
alloc_pages_node() with that node id.

If you stop there, then alloc_pages_node(private_nid, ...) works
exactly the same as it did before (which is actually an issue in my
case, as you still have to contend with other nodemasks containing the
node id still).

So if you wanted to go off testing the page allocator, you could do it
with a private node.  Since otherwise the node gets exempted from the
rest of mm/, you'd just need to make sure to use __GFP_THISNODE so your
allocations fail w/o calling oom infrastructure and handle those
conditions accoridingly.

> 
> I spent a few days trying to solve this in the way that VMA and xarray
> etc have, i.e. by making the page allocator a library and then testing
> it from userspace. I think that would work but it needs much more than a
> few days to make it happen (admittedly, I had tried to do this with AI
> at the time and it failed miserably. Maybe with today's models it would
> work, which could massively accelerate the grunt work of e.g. splitting
> stuff into new files).
> 

I doubt you could get enough parity in userspace to make this a useful
exercise.  All the per-cpu interactions turn into per-thread
interactions, and you'd end up deleting most of what makes page_alloc.c
useful (all the external interactions - reclaim, compaction, oom, etc).

Plus there's cgroup/cpuset and accounting interactions that are
non-trivial.

The more I think about this, the less I think it's a tractable problem
ending in a mergable series.

> But anyway, if you could carve out a distinct node data etc you could just
> write KUnit tests that operate on a completely isolated "instance" of
> the allocator, even though it still runs in a real kernel.

I'm fairly certain private nodes basically already do this - with the
exception of certain global counters (vm stats), and certain global
settings (like you describe above).

~Gregory

