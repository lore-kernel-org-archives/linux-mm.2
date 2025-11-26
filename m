Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A01D1038C
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 08:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522636B0006; Wed, 26 Nov 2025 03:29:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA516B000C; Wed, 26 Nov 2025 03:29:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40FB26B000D; Wed, 26 Nov 2025 03:29:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1876B0006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:29:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D936B1312B2
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:29:21 +0000 (UTC)
X-FDA: 84152083722.26.7A5AF4B
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 08FF4120006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:29:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DCRsTbl9;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764145760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpTPqSNb5/1LIA5hUrs72gqy0nx3RKk/281zC2fbaaY=;
	b=fJYudR34Oj/onkti8ks+QZJRzGMViKikO27cytMa7capl0okOW1VHL1oTjd2blpXPsTuWK
	AD/phxnnU8H844t9exSmDp5dh3fkCIKMWu08+L0xuN8ELW0+O5iyJLMyT6fLrR45425Aob
	pvVqwme9wpNAWaf8HI5FYeczujeWn2A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764145760; a=rsa-sha256;
	cv=none;
	b=lif/Bc5gud7wj1FdKTi0l0bHyOOBXHc/KX+8si66A0ZU3rrZKeWxqb/QQI5jemlWu90xsm
	LG1Jq6Ir+GVm2COBad5QbOu+S67Pztlil1LRYcYQlRVEIRLxZSo8aUUAv6ff3byGjBoOrw
	wWt+9E8tSkNiyutsVBabgFg5DWXQlsQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DCRsTbl9;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b2dec4d115so655811585a.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 00:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764145759; x=1764750559; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LpTPqSNb5/1LIA5hUrs72gqy0nx3RKk/281zC2fbaaY=;
        b=DCRsTbl9/SCldhimfBrs4jstabnl5K68fwLX32m9hFChJO08okpId/0NldYMsH5tMy
         TQ0p4tEmpy6xz1n5NiN+/28PUA2kUHKxhAe2XYYrCNuQjOZI6pkGfin9sOzf8oTWRVyS
         kO6bd+Sso14jQX0cq6aZyOwFmbXiQ6wGWpMCjfoW8f9zlfQNYwJWXg3pbLUgUuhakr0T
         yJOurT4yM4Iq8OwE4BiYho3RrwwPX/6IVSYrYh9U/JGagichANxhDpI6oykBeFcijwhH
         q0bEKO6TDOJE0mhre7Ha6rH3pxsZoIIlXcV3gvUfnk+n3UCJzUY5glIi6IGcSBY0boD1
         n7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764145759; x=1764750559;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpTPqSNb5/1LIA5hUrs72gqy0nx3RKk/281zC2fbaaY=;
        b=I0/BMfyLtaFlKwdCeUiXg+gBLoW+qppehwwt6GtQvsaPfEmXJUqCdqcI2HeMIqUF8S
         qSkuFPLU+oIbfumRKUpT6mhHD2onvSh/HiEZrBHqzhNOMu3i4XqoHbY5QojPFdY25TwY
         6zMhD6UKrK1dl334uUFJ59Um7c9cOh7FKaAo3fCyiMQjHcOqubR0vdorFaZFguYe9NhW
         SXTOo4E4k/WaaRQit3qnhLlfbyDqROuwv4smMsDl/xMRT01jhj2fVXI0Bh0kK5MZkWXO
         qIul0kLlu2Watzxtc88gXlNCkW1p9Y9ZA5vpQB+iwnYc8xKd+28FZo/msg4Q751V1Bjo
         gh+A==
X-Gm-Message-State: AOJu0YwT8JH8yHhZSCURg9OmVcbnUA/cLgols1pfCqk8+oHbTzi6aC+l
	/+Yj1B007bmrrV6yxyfTAtd5TGkRpGtx0vOE5fAR4+nfCNuxKy8vsBKLV44qf9XE380=
X-Gm-Gg: ASbGnctYDZTfiB3CFgCrsTuPMGaDcKbdecsXXRja2N9dg56luwkauTVBjXvSL6SW8JF
	qfvFy18W7f0IjcDtHIEZ4D/BZvIDz5vo0bRvouowsM1d+qpisxB/5CWHLuUcZKro3Ot+dkm6KAB
	I9qQekjVeXvlkvnNEfqRmQ34mnEO8FArEOHmlScDswB7uSUmbpkfLi3GFrOPr7rM5k9BZXvldT8
	g6qeXVFlsgMgvVLnioF0jMhLC4edHtID7He/xaiC0pV7vmlRX+VK1WNm6/HfDAEMuOAQm1E9jnj
	vp2texnjvJTI2izsHOvZSj2RjygGw9elip9kvA9L8o2N6KbnlYiUuS5eeH4ilQPo0pGLUl+UiKT
	8P6dUpqKMePzUXdwmdNo0JsIg+Tbyd6fyM8EOY4040/hhr38cf9C4A4PhGqJyPaJtQynGBXFHPg
	8ikY0gl2Nhd18uk9UOgw78S3znuxn7MZ0nz5U4hhqrtzJ305NhmjTz2Ogl6ij7Lo10vx6wKA==
X-Google-Smtp-Source: AGHT+IHuUv0EzqPvaVNL3leGpr9lqb8F9vUc6VmdQSLEZ6njqgrsaluCQ4pnfGmE+DrmYi9rZ0TzBg==
X-Received: by 2002:ac8:7c4c:0:b0:4ed:e40c:872d with SMTP id d75a77b69052e-4ee58b12a27mr235496851cf.59.1764145758923;
        Wed, 26 Nov 2025 00:29:18 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee4cbc3c81sm113574331cf.16.2025.11.26.00.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 00:29:17 -0800 (PST)
Date: Wed, 26 Nov 2025 03:29:14 -0500
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	rientjes@google.com, jackmanb@google.com, cl@gentwo.org,
	harry.yoo@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com,
	ming.li@zohomail.com, usamaarif642@gmail.com, brauner@kernel.org,
	oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <aSa6Wik2lZiULBsg@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <48078454-f441-4699-9c50-db93783f00fd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48078454-f441-4699-9c50-db93783f00fd@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 08FF4120006
X-Stat-Signature: te5srzbryp95zsxwgxec35ii6auxuiyu
X-Rspam-User: 
X-HE-Tag: 1764145759-860141
X-HE-Meta: U2FsdGVkX19BlvWeM6UXS1QWcA9ZKBFCLlZQUX7S3lZABY54gOptbsneyv6oXEp4hNINE1rJ1BsY8avOKSvgCwa3b3JwGKlSqAEudNIBUpMsSI1PwzQMgzLv4r1x0InhlVfv3ix7X8EOhxOHnRd4NzKeYVUCfIWngI3H6fcHuMy525JTxdSIGVyvh0Xt0ndo6eiAfULhpbHAaILlc8V/xvfeHO5P2ixQZvZR8k6W0LaC2D6Su6GLVwiJux+jxOHFBXRHdBhHrXwchjdP/3oQMTAxZia5iMB561XmVsGRqVNtJqWY+NJasThbYmwpHL/asbllHc3kwKE0jTYAtWF/uORTeAVV/TLLF1ETUpFfeufenvGVZP7vktqW3uOp4B9Sv4JLaawJ45dQ9pEzjE8F/D7LLQCS0XDaxA7cpz606b8Grg8RKFjVUzqpLVJAYWYFigkKM7hNC6+IYJIdkZ+FLsgDyHb7tKLO6mQMMEIhXV7lMe2VutSgHhj0G9jssAvNL1w5ECEoMCQoRh1viCNEad8ZgbcYPMrgn53tg0NryxOZcSW7F33cbfIZb8sEDZnePNAZqFzqlVci34SmaagjPW7b1narzaWhMqig9ON80eUq4X6zP8qdBgAeaNVj1TirJY1uBJFS9LAtMzIgDIM8GSK+ZN3DQxxzmQp6tuT3j0clzWn++KQuJt/BL5DRJvNuu38z6dbDGJWbjEPy2dvD96Zxe/9UcdqilOsrTOtwIeI7eyDXh+7aOa9LjVMiyYVUsphViWruBC4zvQqVbm61GyXHmzxf7GOSJiLIWGyTprbbwxics/JD9VoLsoZQx+IIJmFn77DiaOoowjyzgT42bhm0rDnAZCUYeY6zy9lmuDCV5mJWovXmO5wMwZ+2Dy+x94rcAhJCiVSnkuhQ7AvxnFQrYQUICrqxLponF98K/4+905uaMI0hJQ4QuDdgrteZNkgrKpEnXBPudlxcVI1
 ymsagXT7
 T612/U0QI9ePLLSyK9ZaguYhHDSowCfNTgOXeKZoVH28GJH89Lh6/5xSmP5WgR7BDE8lRpr3UvAAY1n1h78gYz2NisMQnYsmsFZRE71FYP/z5AaZ6YCzJYkUIFsRZy9RoSLT4L7ts9gvND0jkgc2BeWgMmVWc0RGbTY9RZPtoqR7JhGqKESeB7KA6BTzQb9wKr3+F69lMwjnniNHlua1X/CaPG59FZdT6j/zwvJK8Al4MmlRR4eO8QqCd4IFxxqAb92fjChuH2jTBuYiSBOXwjf7MruOEU0ySrdssMVzHcPIZXUqjZcNWfqPcStpSGjlEQyK5tyBTCtga+0D/662FOEPT0IrkZsqzoC8mOIViOF5ILNmUrhEvxqlGKGGLaLOuMatItQBmGYoCMuiZjGVt5kB9YWiCuhzWkWvLcPzk47Tcm1zBJZ8r7KB1g2q7Xh6co+8FmhBublB9pUyp2swbBiCTu1uCfl4lp+9NrfUpyjvAlERhMkzyE4HAxqeN+Eo27kmQBqcFxBBGQnYqgGo8uCwsu4b1MDhY5Q1y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 02:23:23PM +1100, Balbir Singh wrote:
> On 11/13/25 06:29, Gregory Price wrote:
> > This is a code RFC for discussion related to
> > 
> > "Mempolicy is dead, long live memory policy!"
> > https://lpc.events/event/19/contributions/2143/
> > 
> 
> :)
> 
> I am trying to read through your series, but in the past I tried
> https://lwn.net/Articles/720380/
> 

This is very interesting, I gave the whole RFC a read and it seems you
were working from the same conclusion ~8 years ago - that NUMA just
plainly "Feels like the correct abstraction".

First, thank you, the read-through here filled in some holes regarding
HMM-CDM for me.  If you have developed any other recent opinions on the
use of HMM-CDM vs NUMA-CDM, your experience is most welcome.


Some observations:

1) You implemented what amounts to N_SPM_NODES 

   - I find it funny we separately came to the same conclusion. I had
     not seen your series while researching this, that should be an
     instructive history lesson for readers.

   - N_SPM_NODES probably dictates some kind of input from ACPI table
     extension, drivers input (like my MHP flag), or kernel configs
     (build/init) to make sense.

   - I discussed in my note to David that this is probably the right
     way to go about doing it. I think N_MEMORY can still be set, if
     a new global-default-node policy is created.

   - cpuset/global sysram_nodes masks in this set are that policy.


2) You bring up the concept of NUMA node attributes

   - I have privately discussed this concept with MM folks, but had
     not come around to formalize this.  It seems a natural extension.

   - I wasn't sure whether such a thing would end up in memory-tiers.c
     or somehow abstracted otherwise.  We definitely do not want node
     attributes to imply infinite N_XXXXX masks.


3) You attacked the problem from the zone iteration mechanism as the
   primary allocation filter - while I used cpusets and basically
   implemented a new in-kernel policy (sysram_nodes)

   - I chose not to take that route (omitting these nodes from N_MEMORY)
     precisely because it would require making changes all over the
     kernel for components that may want to use the memory which
     leverage N_MEMORY for zone iteration.

   - Instead, I can see either per-component policies (reclaim->nodes)
     or a global policy that covers all of those components (similar to
     my sysram_nodes).  Drivers would then be responsible to register
     their hotplugged memory nodes with those components accordingly.

   - My mechanism requires a GFP flag to punch a hole in the isolation,
     while yours depends on the fact that page_alloc uses N_MEMORY if
     nodemask is not provided.  I can see an argument for going that
     route instead of the sysram_nodes policy, but I also understand
     why removing them from N_MEMORY causes issues (how do you opt these
     nodes into core services like kswapd and such).

     Interesting discussions to be had.


4)   Many commenters tried pushing mempolicy as the place to do this.
     We both independently came to the conclusion that 

   - mempolicy is at best an insufficient mechanism for isolation due
     to the way the rest of the system is designed (cpusets, zones)

   - at worst, actually harmful because it leads kernel developers to
     believe users view mempolicy APIs as reasonable. They don't.
     In my experience it's viewed as:
         - too complicated (SW doesn't want to know about HW)
         - useless (it's not even respected by reclaim)
         - actively harmful (it makes your code less portable)
	 - "The only thing we have"

Your RFC has the same concerns expressed that I have seen over past
few years in Device-Memory development groups... except that the general
consensus was (in 2017) that these devices were not commodity hardware
the kernel needs a general abstraction (NUMA) to support.

"Push the complexity to userland" (mempolicy), and
"Make the driver manage it." (hmm/zone_device)

Have been the prevailing opinions as a result.

From where I sit, this depends on the assumption that anyone using such
systems is presumed to be sophisticated and empowered enough to accept
that complexity.  This is just quite bluntly no longer the case.

GPUs, unified memory, and coherent interconnects have all become
commodity hardware in the data center, and the "users" here are
infrastructure-as-a-service folks that want these systems to be
some definition of fungible.

~Gregory

