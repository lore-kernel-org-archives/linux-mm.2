Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4951CFD342
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 18:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5EA06B000A; Mon, 24 Nov 2025 13:06:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A360E6B0023; Mon, 24 Nov 2025 13:06:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BB76B0024; Mon, 24 Nov 2025 13:06:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE716B000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:06:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50B70899BE
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:06:37 +0000 (UTC)
X-FDA: 84146280834.21.C7F8F77
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F50380017
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:06:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=o6Rdh1xd;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764007595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXDaIZ3bmiDQH03ddrGvDU32M+hduvGLa5ls7tuk/5w=;
	b=MAuB3MoaDjIm0NEu7L827oxG9GUoxlYLXEihL8vp0yf6KlaRx/9crHBfbFDoiMhi9oRz/A
	cKiMEMGaKA8KyfwE46UR4l8cSXeblJLiQbZERnI8kaZ8yFPSlRnN9SO+7GGQQ69Y2DN7Sa
	T6nv8decxPyskhAR+t1CnBinXy1iYOo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=o6Rdh1xd;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764007595; a=rsa-sha256;
	cv=none;
	b=DQ/jeMUtqSLGz60Tb7AKQ3B437EmaInaqrx829uQlWJDuPZQjVWfmLWP/OU0nbgtU2GRcq
	T0UdLa3PGe2RkkYcfDB8zyd+v+vkuRCZcemAxGCphaO6uXJ83t1iuPVALa1XBAEbeihouI
	h4Q1kh79s165NpJB2w1aWYb1omLNnj8=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee2014c228so37533541cf.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764007594; x=1764612394; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yXDaIZ3bmiDQH03ddrGvDU32M+hduvGLa5ls7tuk/5w=;
        b=o6Rdh1xdGa4jGGag/YZO7QOyQZfp48GYoM/aLfiRi6NLqtm50DK6dnHaksVSsRs5Y0
         P+SIWucjd4ISkXLq9Eacv++E72B4I0OnGiAQipxS7dj/LWU3y3sF7KVCEbjC/cTo3Lsc
         rlHcD7TdXzFRdTvWuASHKs/V8dpURH3cU7QTgtq4eTN7v79GLM4JzUEacbKYsPBU2hqo
         CoSBAGxs/X+JX+pSyIcvoR5fpgl26j8IjI79nPZd1P1wRSMbEjaOwD5yTV4ZQpgPBdKk
         jyYVUKG/rekpX1931i9f36rDQNKrVEm0PYO1XhpgzBsAeB8jZZXwg/B3jhYHmw+efjMy
         IQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764007594; x=1764612394;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yXDaIZ3bmiDQH03ddrGvDU32M+hduvGLa5ls7tuk/5w=;
        b=fc/DoAzY17iCCgoW3Nx9fgEx1JBfEKM3vTo0hCRKIQzpyJn+ra7LMsP/OqepMru+2R
         iaWPaa8TV8//Mw6OC1t4qViI7uAB5iDy7vINnT51zIsBnXwBK582ZuPQud08XxX6ylgF
         wMkGuxIg6Cg5n6L7z4jtHm1IZmPewiAIPOed2OnyPS4/hw9lYoHtD4bRmYbxAWQzUXI+
         oa5T12MJwK25W1XwfYGNUDgInXp4sSJkPN4Ci2kMAIM2sgNbGmdM38FHect7fw2wu1ZY
         YJMV6NRgvfGlChEX+Flx39HWpug12Y1d1tzZrbdK6upWH2sG6lDQgtSl+iTD7L3VA8mh
         wLXQ==
X-Gm-Message-State: AOJu0YwEJBRpZcwtjJPGuYW3tLxzee4bEBHGEKeycz/8AyQX8jlEKJax
	qbZW79h7O9SJyQU6s3P9T9OgbcsnadY7FDoGuEBecclNgEcYND5b5gWjN5LbAdbzmwc=
X-Gm-Gg: ASbGncvqH4s0GKg00XYiROWtPv0bFsVh/qpBZWvMXhe6t/zo7b1K1WdAPcS/J9d+cqV
	SIQugxD/ZotMTJ0nul7MncJVGZonH7cRxu3ESxQK4pvw3JgvKcE+wAk5uDiVEBoxBOxVaWo9tls
	Tedx8M0CyZwr02AxTyAX1ELVSc35mB7PifV1RxkeiTu1HByIAjccPAk2NzAz5LpwxOnG4Z8v8NR
	atVMiSls2oasNRnkloOxJH/nrOeB9A/AZ0niU7ebU+l0hopz+RFdu75Iafl9uhXNFelGezWrmG9
	guzoYZj18pb0pfG0JaiU7s6kebWJQ7iUp88gScZ7j4fh/DDabBFle8LGRzflU1P//+izpKWXTCG
	X1kgWzxbr0YTRLzxjJwNfJ7EJW2RDn8HfXuSElEYQD05hoRBsC3Wu1Hrm49sRnlcVUOIJlnb7Qr
	zNSxmFlaUHj0/p2trtDg==
X-Google-Smtp-Source: AGHT+IFWc6tOsCzk+0IiOG36im1V7mza8ueIUcm1QKWlvM1lx/mSMvixdmCgGdgOR3e1WgUu0B9JLg==
X-Received: by 2002:ac8:580c:0:b0:4ed:df09:a6a6 with SMTP id d75a77b69052e-4ee58836d7bmr175049861cf.25.1764007593560;
        Mon, 24 Nov 2025 10:06:33 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:400::5:62f9])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e445b28sm104502226d6.1.2025.11.24.10.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 10:06:33 -0800 (PST)
Date: Mon, 24 Nov 2025 11:06:30 -0700
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, kees@kernel.org,
	muchun.song@linux.dev, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, rientjes@google.com, jackmanb@google.com,
	cl@gentwo.org, harry.yoo@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com,
	ming.li@zohomail.com, usamaarif642@gmail.com, brauner@kernel.org,
	oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <aSSepu6NDqS8HHCa@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <de15aca2-a27c-4a9b-b2bf-3f132990cd98@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <de15aca2-a27c-4a9b-b2bf-3f132990cd98@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F50380017
X-Stat-Signature: rr7rxry7xs8rcnidzxftwfuskx15we4r
X-Rspam-User: 
X-HE-Tag: 1764007595-295731
X-HE-Meta: U2FsdGVkX1/kAPDJR5jbwhavqNWJj1iWoPrv3gU1H+CtwP75iMNXViX1zJrp18QBvXB0jJeyFlV/bm/qFRvN3InKgL/9owIhYiXcgx1F7PZ15u8fM9yqhyvzhuUCrVw1w9B1aLP1jPXW4BJYuegMSV9a6A9Pc+GrFb4gwG8hkbiZkZ6T8BVbMfbY6qR51pFlyD/Pm954M1RQ8LGWWwOch8Q7oWBHs4ufa3DK6EQE+L7zLTjoW+SI9JrDdfyUr33a/lKVsvudL27R7id0ZhL1v2fVU0ZKjSdhvhktsw9Xeag8Duv6pgmOGyyBSgyWTNm81W0zqlMVIEZJbUHZBOhtALsRSp/Ory/d9quxu5Ym4JvMFvtLwRMnHFEoIzs4F3kxPb0AYXWJbUbnCQlszpITSikeAILNrH4jqiyX+V2WvL2N+tLN38aKWDr5m7NLBWg6PyfvQkpFU9obCtnugJr2dxS/Vx5x9yTVIfZuEIATVB05+/n615sAoUijflbKMAen9oLiw29H/hqlXoN3Umdr90s+yUJ/JabhDQuqWRX/oFCzfs/edAKsUzjZloYOWp3YFz+EGeaJOKWwJvKfDn3AszinyzP1h6QM6iKXc3NPOur+F4ehqx74ApToRd3PWLe9zAoD2M+KDLutE54wZ5qP4AVWY+PwrrWNJhYigH6AQYCte6MsJki9H6ek1jNdKM/lMDQBG1uNxndvtxnn4sExr8q3qrGsguNC+Aaf/i3YTonHHoWGRyflwCaz90TWSQDa1TUjuv1YIoMb0S6XZpLeuK7HL/c0YCy0Btr0UioaQGISVSG4POEWZE8rUery/OS2B0OOFfScSeAWvQ8GvQL7C76c0LAmlSuZqGkkn37YVOebuO0MLH3f74JpfH9S4K3v6oYlkobXHwiufrXD1d/4Yq41RzOOdUTye+SpGw7NQDZqCKXra4Wq6iK5ryckkLU9FLBUjWUs9Jg+AkyNCk/
 2ZprKnIx
 5LJ8A30KLFj6vljWKrMzrpCSkZHVjRMIwFHfc9Z3qUpY0tAS9zRYUN871s3l65p00pNdF7N1oDG3oCZzeKw/Rd9ivn6AI/TjAFiW2j+5y1g+e3YkWvtcjGtPI9137C4Tigribh54QakQ5xVCwNgQp7MIzsz2cFPFfcubmlwNngkhob5Ba8dVZWbcZg6bVQonw+orQ5OOa2/HxgsQqZSxH7G5AS10wybcsPj8poP1xgCoijrkCADrjWA7GHWXmK1tFfuehrQiJIpudXeIksj+/xGnddOuDvVbf0U94bEmLKIramn8BbDgRTRcvXIxxRinfZ67pdKbsKPEDIK+l91Nmjb1fm3wgc13g69Gp1A+FSddBsi0VMmbRbg4olvjYuSIXbqp/W3G7udgG0Hod8GyTYAGvMjuzED2Ffvpq701Grtg7DyWyvqneOfeElonoQPLOCWBXeYc3jawHjKQcl3pLK1LSPoO2ulVxUt1oC3DPSR1z2rJY2b4kcj/YX5o8Bbu1DKn0Xu34dNJbaz0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 10:19:37AM +0100, David Hildenbrand (Red Hat) wrote:
> [...]
> 

Apologies in advance for the wall of text, both of your questions really
do cut to the core of the series.  The first (SPM nodes) is basically a
plumbing problem I haven't had time to address pre-LPC, the second (GFP)
is actually a design decision that is definitely up in the air.

So consider this a dump of everything I wouldn't have had time to cover
in the LPC session.

> > 3) Addition of MHP_SPM_NODE flag to instruct memory_hotplug.c that the
> >     capacity being added should mark the node as an SPM Node.
> 
> Sounds a bit like the wrong interface for configuring this. This smells like
> a per-node setting that should be configured before hotplugging any memory.
> 

Assuming you're specifically talking about the MHP portion of this.

I agree, and I think the plumbing ultimately goes through acpi and
kernel configs.  This was my shortest path to demonstrate a functional
prototype by LPC.

I think the most likely option simply reserving additional NUMA nodes for
hotpluggable regions based on a Kconfig setting.

I think the real setup process should look like follows:

1. At __init time, Linux reserves additional SPM nodes based on some
   configuration (build? runtime? etc)

   Essentially create:  nodes[N_SPM]

2. At SPM setup time, a driver registers an "Abstract Type" with
   mm/memory_tiers.c  which maps SPM->Type.

   This gives the core some management callback infrastructure without
   polluting the core with device specific nonsense.

   This also gives the driver a change to define things like SLIT
   distances for those nodes, which otherwise won't exist.

3. At hotplug time, memory-hotplug.c should only have to flip a bit
   in `mt_sysram_nodes` if NID is not in nodes[N_SPM].  That logic
   is still there to ensure the base filtering works as intended.


I haven't quite figured out how to plumb out nodes[N_SPM] as described
above, but I did figure out how to demonstrate roughly the same effect
through memory-hotplug.c - hopefully that much is clear.

The problem with the above plan, is whether that "Makes sense" according
to ACPI specs and friends.

This operates in "Ambiguity Land", which is uncomfortable.

======== How Linux ingests ACPI Tables to make NUMA nodes =======
For the sake of completeness:

NUMA nodes are "marked as possible" primarily via entries in the ACPI
SRAT (Static Resource Affinity Table).
https://docs.kernel.org/driver-api/cxl/platform/acpi/srat.html

        Subtable Type : 01 [Memory Affinity]
               Length : 28
     Proximity Domain : 00000001          <- NUMA Node 1

A proximity domain (PXM) is simply a logical grouping of components
according to the OSPM.  Linux takes PXMs and maps them to NUMA nodes.

In most cases (NR_PXM == NR_NODES), but not always.  For example, if
the CXL Early Detection Table (CEDT) describes a CXL memory region for
which there is no SRAT entry, Linux reserves a "Fake PXM" id and
marks that ID as a "possible" NUMA node.

= drivers/acpi/numa/srat.c

int __init acpi_numa_init(void)
{
...
        /* fake_pxm is the next unused PXM value after SRAT parsing */
        for (i = 0, fake_pxm = -1; i < MAX_NUMNODES; i++) {
                if (node_to_pxm_map[i] > fake_pxm)
                        fake_pxm = node_to_pxm_map[i];
        }
        last_real_pxm = fake_pxm;
        fake_pxm++;
        acpi_table_parse_cedt(ACPI_CEDT_TYPE_CFMWS, acpi_parse_cfmws,
                              &fake_pxm);
...
}

static int __init acpi_parse_cfmws(union acpi_subtable_headers *header,
                                   void *arg, const unsigned long table_end)
{
...
        /* No SRAT description. Create a new node. */
        node = acpi_map_pxm_to_node(*fake_pxm);
...
        node_set(node, numa_nodes_parsed);   <- this is used to set N_POSSIBLE
}


Here's where we get into "Specification Ambiguity"

The ACPI spec does not limit (as far as I can see) a memory region from
being associated with multiple proximity domains (NUMA nodes).

Therefore, the OSPM could actually report it multiple times in the SRAT
in order to reserve multiple NUMA node possiblities for the same device.

A further extention to ACPI could be used to mark such Memory PXMs as
"Specific Purpose" - similar to the EFI_MEMORY_SP bit used to mark
memory regions as "Soft Reserved".

(this would probably break quite a lot of existing linux code, which
 a quick browse around gives you the sense that there's an assumption
 a given page can only be affiliated with one possible numa node)

But Linux could also utilize build or runtime settings to add additional
nodes which are reserved for SPM use - but are otherwise left out of
all the default maps.  This at least seems reasonable.

Note: N_POSSIBLE nodes is set at __init time, and is more or less
expected to never change.  It's probably preferable to work with this
restriction, rather than to try to change it.  Many race conditions.

<skippable wall>
================= Spec nonsense for reference ====================
(ACPI 6.5 Spec)
5.2.16.2 Memory Affinity Structure
The Memory Affinity structure provides the following topology information statically to the operating system:
• The association between a memory range and the proximity domain to which it belongs
• Information about whether the memory range can be hot-plugged.


5.2.19 Maximum System Characteristics Table (MSCT)
This section describes the format of the Maximum System Characteristic Table (MSCT), which provides OSPM with
information characteristics of a system’s maximum topology capabilities. If the system maximum topology is not
known up front at boot time, then this table is not present. OSPM will use information provided by the MSCT only
when the System Resource Affinity Table (SRAT) exists. The MSCT must contain all proximity and clock domains
defined in the SRAT.

-- field: Maximum Number of Proximity Domains
   Indicates the maximum number of Proximity Domains ever possible in the system.

   In theory an OSPM could make (MAX_NODES > (NR_NODES in SRAT)) and
   that delta could be used to indicate the presense of SPM nodes.

   This doesn't solve the SLIT PXM distance problem.


6.2.14 _PXM (Proximity)
This optional object is used to describe proximity domain associations within a machine. _PXM evaluates to an integer
that identifies a device as belonging to a Proximity Domain defined in the System Resource Affinity Table (SRAT).
OSPM assumes that two devices in the same proximity domain are tightly coupled.


17.2.1 System Resource Affinity Table Definition
The optional System Resource Affinity Table (SRAT) provides the boot time description of the processor and memory
ranges belonging to a system locality. OSPM will consume the SRAT only at boot time. For any devices not in the
SRAT, OSPM should use _PXM (Proximity) for them or their ancestors that are hot-added into the system after boot
up.

The SRAT describes the system locality that all processors and memory present in a system belong to at system boot.
This includes memory that can be hot-added (that is memory that can be added to the system while it is running,
without requiring a reboot). OSPM can use this information to optimize the performance of NUMA architecture
systems. For example, OSPM could utilize this information to optimize allocation of memory resources and the
scheduling of software threads.

=============================================================
</skippable wall>


So TL;DR: Yes, I agree, this logic should __init time configured, but
while we work on that plumbing, the memory-hotplug.c interface can be
used to unblock exploratory work (such as Alistair's GPU interests).

> > 4) Adding GFP_SPM_NODE - which allows page_alloc.c to request memory
> >     from the provided node or nodemask.  It changes the behavior of
> >     the cpuset mems_allowed and mt_node_allowed() checks.
> 
> I wonder why that is required. Couldn't we disallow allocation from one of
> these special nodes as default, and only allow it if someone explicitly
> passes in the node for allocation?
> 
> What's the problem with that?
> 

Simple answer:  We can choose how hard this guardrail is to break.

This initial attempt makes it "Hard":
   You cannot "accidentally" allocate SPM, the call must be explicit.

Removing the GFP would work, and make it "Easier" to access SPM memory.
(There would be other adjustments needed, but the idea is the same).


To do this you would revert the mems_allowed check changes in cpuset
to check mems_allowed always (instead of sysram_nodes).

This would allow a trivial 

   mbind(range, SPM_NODE_ID)

Which is great, but is also an incredible tripping hazard:

   numactl --interleave --all

and in kernel land:

   __alloc_pages_noprof(..., nodes[N_MEMORY])

These will now instantly be subject to SPM node memory.


The first pass leverages the GFP flag to make all these tripping hazards
disappear.  You can pass a completely garbage nodemask into the page
allocator and still rest assured that you won't touch SPM nodes.


So TL;DR: "What do we want here?" (if anything at all)


For completeness, here are the page_alloc/cpuset/mempolicy interactions
which lead me to a GFP flag as the "loosening mechanism" for the filter,
rather than allowing any nodemask to "just work".


Apologies again for the wall of text here, essentially dumping
~6 months of research and prototyping.

====================
There are basically 3 components which interact with each other:

   1) the page allocator nodemask / zone logic
   2) cpuset.mems_allowed
   3) mempolicy (task, vma)

   and now:

   4) GFP_SPM_NODE


=== 1) the page allocator nodemask and zone iteration logic

   - page allocator uses prepare_alloc_pages() to decide what
     alloc_context.nodemask will contain

   - nodemask can be NULL or a set of nodes.

   - for_zone() iteration logic will iterate all zones if mask=NULL
     Otherwise, it skips zones on nodes not present in the mask

   - the value of alloc_context.nodemask may change
     for example it may end up loosened if in an interrupt context or
     if reclaim/compaction/fallbacks are invoked.


Some issues might be obvious:

   It would be bad, for example, for an interrupt to have its allocation
   context loosened to nodes[N_MEMORY] and end up allocating SPM memory

   Capturing all of these scenarios would be very difficult if not
   impossible.



The page allocator does an initial filtering of nodes if nodemask=NULL,
or it defers the filter operation to the allocation logic if a nodemask
is present (or we're in a interrupt context).

static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
                int preferred_nid, nodemask_t *nodemask,
                struct alloc_context *ac, gfp_t *alloc_gfp,
                unsigned int *alloc_flags)
{
...
        ac->nodemask = nodemask;
        if (cpuset_enabled()) {
	...
                if (in_task() && !ac->nodemask)
                        ac->nodemask = &cpuset_current_mems_allowed;
			               ^^^^ current_task.mems_allowed
                else 
                        *alloc_flags |= ALLOC_CPUSET;
			^^^ apply cpuset check during allocation instead
        }
}


Note here: If cpuset is not enabled, we don't filter!
           patch 05/11 uses mt_sysram_nodes to filter in that scenario

In the actual allocation logic, we use this nodemask (or cpusets) to
filter out unwanted nodes.

static struct page *
get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
                                                const struct alloc_context *ac)
{
        z = ac->preferred_zoneref;
        for_next_zone_zonelist_nodemask(zone, z, ac->highest_zoneidx,
                                        ac->nodemask) {
		^ if nodemask=NULL - iterates ALL zones in all nodes ^
	...
                if (cpuset_enabled() &&
                        (alloc_flags & ALLOC_CPUSET) &&
                        !__cpuset_zone_allowed(zone, gfp_mask))
                                continue;
 		^^^^^^^^  Skip zone if not in mems_allowed ^^^^^^^^^


Of course we could change the page allocator logic more explicitly
to support this kind of scenario.

For example:

   We might add alloc_spm_pages() which checks mems_allowed instead
   of sysram_nodes.

I tried this, and the code duplication and spaghetti it resulted in
was embarassing.  It did work, but adding hundreds of lines to
page_alloc.c, with the risk of breaking something just lead me to
quickly disgarded it. 

It also just bluntly made using SPM memory worse - you just want to
call alloc_pages(nodemask) and be done with it.

This is what lead me to focus on modifying cpuset.mems_allowed and
add global filter logic when cpusets is disabled.



=== 2) cpuset.mems

   - cpuset.mems_allowed is the "primary filter" for most allocations

   - if cpusets is not enabled, basically all nodes are "allowed"

   - cpuset.mems_allowed is an *inherited value*

     child cgroups are restricted by the parent's mems_allowed
     cpuset.effective_mems is the actual nodemask filter.

cpuset.mems_allowed as-is cannot both restrict *AND* allow SPM nodes.

See the filtering functions above:

   If you remove an SPM node from root_cgroup.cpuset.mems_allowed
   to all of its children from using it, you effectively prevent
   ANYTHING from using it:  The node is simply not allowed.

   Since all tasks operate from within a the root context or its
   children - you can never "Allow" the node.

   If you don't remove the SPM node from the root cgroup, you aren't
   preventing tasks in the root cgroup from accessing the memory.


I chose to break mems_allowed into (mems_allowed, sysram_nodes) to:

  a) create simple nodemask=NULL default nodemask filters:
     mt_sysram_nodes, cpuset.sysram_nodes, task.sysram_nodes

  b) Leverage the existing cpuset filtering mechanism in
     mems_allowed() checks

  c) Simplify the non-cpuset filter mechanism to a 2-line change
     in page_alloc.c -- from Patch 04/11:

@@ -3753,6 +3754,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if ((alloc_flags & ALLOC_CPUSET) &&
 		    !cpuset_zone_allowed(zone, gfp_mask))
 			continue;
+		else if (!mt_node_allowed(zone_to_nid(zone), gfp_mask))
+			continue;



page_alloc.c changes are much cleaner and easy to understand this way


=== 3) mempolicy

   - mempolicy allows you change the task or vma node-policy, separate
     from (but restricted by) cpuset.mems

   - there are some policies like interleave which provide (ALL) options
     which create, basically, a nodemask=nodes[N_MEMORY] scenario.

   - This is entirely controllable via userspace.

   - There exists a lot of software out there which makes use of this
     interface via numactl syscalls (set_mempolicy, mbind, etc)

   - There is a global "default" mempolicy which is leveraged when
     task->mempolicy=NULL or vma->vm_policy=NULL.

     The default policy is essentially "Allocate from local node, but
     fallback to any possible node as-needed"


During my initial explorations I started by looking at whether a filter
function could be implemented via the global policy.

It should be somewhat obvious this falls apart completely as soon as you
find the page allocator actually filters using cpusets.

So mempolicies are dead as a candidate for any real isolation mechanism.
It is nothing more than a suggestion at best, and is actually explicitly
ignored by things like reclaim.

   (cough: Mempolicy is dead, long live Memory Policy)

I was also very worried about introducing an SPM Node solution which
presented as an isolation mechanism... which then immediately crashed
and burned when deployed by anyone already using numactl.

I have since, however, been experimenting with how you might enable
mempolicy to include SPM nodes more explicitly (with the GFP flag).

(attached at the end, completely untested, just conceptual).


=== 4) GFP_SPM_NODE

Once the filtering functions are in place (sysram_nodes), we've hit
a point where absolutely nothing can actually touch those nodes at all.

So that was requirement #1... but of course we do actually want to
allocate this memory, that's the point.  But now we have a choice...

If a node is present in the nodemask, we can:

   1) filter it based on sysram_nodes
      a) cpuset.sysram, or
      b) mt_sysram_nodes

   or

   2) filter it based on mems_allowed
      a) cpuset.effective_mems, or
      b) nodes[N_MEMORY]


The first choice is "Hard Guardrails" - it requires both an explict mask
AND the GFP flag to reach SPM memory.

The second choice is "Soft Guardrails" - more or less any nodemask is
allowed, and we trust the callers to be sane.


The cpuset filter functions already had gfp argument by the way:

bool cpuset_current_node_allowed(int node, gfp_t gfp_mask) {...}


I chose the former for the first pass due to the mempolicy section
above.  If someone has an idea of how to apply this filtering logic
WITHOUT the GFP flag - I am absolutely welcome to suggestions.

My only other idea was separate alloc_spm_pages() interfaces, and that
just felt bad.

~Gregory


---------------  mempolicy extension ----------

mempolicy: add MPOL_F_SPM_NODE

Add a way for mempolicies to access SPM nodes.

Require MPOL_F_STATIC_NODES to prevent the policy mask from being
remapped onto other nodes.

Note: This doesn't work as-is because mempolicies are restricted by
cpuset.sysram_nodes instead of cpuset.mems_allowed, so the nodemask
will be rejected.  This can be changed in the new/rebind mempolicy
interfaces.

Signed-off-by: Gregory Price

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 8fbbe613611a..c26aa8fb56d3 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -31,6 +31,7 @@ enum {
 #define MPOL_F_STATIC_NODES    (1 << 15)
 #define MPOL_F_RELATIVE_NODES  (1 << 14)
 #define MPOL_F_NUMA_BALANCING  (1 << 13) /* Optimize with NUMA balancing if possible */
+#define MPOL_F_SPM_NODE        (1 << 12) /* Nodemask contains SPM Nodes */

 /*
  * MPOL_MODE_FLAGS is the union of all possible optional mode flags passed to
diff --git a/mm/memory.c b/mm/memory.c
index b59ae7ce42eb..7097d7045954 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3459,8 +3459,14 @@ static gfp_t __get_fault_gfp_mask(struct vm_area_struct *vma)
 {
        struct file *vm_file = vma->vm_file;

-       if (vm_file)
-               return mapping_gfp_mask(vm_file->f_mapping) | __GFP_FS | __GFP_IO;
+       if (vm_file) {
+               gfp_t gfp;
+               gfp = mapping_gfp_mask(vm_file->f_mapping) | __GFP_FS | __GFP_IO;
+               if (vma->vm_policy)
+                       gfp |= (vma->vm_policy->flags & MPOL_F_SPM_NODE) ?
+                               __GFP_SPM_NODE : 0;
+               return gfp;
+       }

        /*
         * Special mappings (e.g. VDSO) do not have any file so fake
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e1e8a1f3e1a2..2b4d23983ef8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1652,6 +1652,8 @@ static inline int sanitize_mpol_flags(int *mode, unsigned short *flags)
                return -EINVAL;
        if ((*flags & MPOL_F_STATIC_NODES) && (*flags & MPOL_F_RELATIVE_NODES))
                return -EINVAL;
+       if ((*flags & MPOL_F_SPM_NODE) && !(*flags & MPOL_F_STATIC_NODES))
+               return -EINVAL;
        if (*flags & MPOL_F_NUMA_BALANCING) {
                if (*mode == MPOL_BIND || *mode == MPOL_PREFERRED_MANY)
                        *flags |= (MPOL_F_MOF | MPOL_F_MORON);


