Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24EC0FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 22:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F876B008A; Tue,  5 May 2026 18:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507C36B0092; Tue,  5 May 2026 18:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F67B6B0093; Tue,  5 May 2026 18:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4476B008A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:21:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D26281A0607
	for <linux-mm@kvack.org>; Tue,  5 May 2026 22:21:40 +0000 (UTC)
X-FDA: 84734789160.24.9633CF8
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA570A0008
	for <linux-mm@kvack.org>; Tue,  5 May 2026 22:21:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oqcEUXIw;
	spf=pass (imf15.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778019698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+bTaNE0dwTN+qN6h1nZ07Pw7t4BRJtO96DbmMB+uZo=;
	b=wbEbmmvI9oLbT/zRUyyOJBgPc3KUcoUkeRz8nwN8ee/busP03ZHiZ7yFE9jvdU5Fh91Oea
	8/Py7f8YNUibo1iVVOrm5uLzROX7kHGpVq7WLc7NrVOnzGKxIxbTcv+OIoHCwbcAA7YiG0
	2CqQN/BmtVex4FWOWMt5B6e3tsUqT6Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oqcEUXIw;
	spf=pass (imf15.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778019698; a=rsa-sha256;
	cv=none;
	b=PQUTWI2fn6FQKBgvHKiXvShMrfXd2qNYlsG+WHcazxZe+1A91cTL453hH9yKgQdw3hOC/G
	xOsbER+k0bpAk4pRXi8V3XkBmHL1UlLG2f58fYIAsc5u6DLTu1y4GzccmFHXZ8VXjwhYWK
	z4KsQGs8a6xaRYRcsry+FRjf3MqXks0=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3870778358aso40555981fa.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 15:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778019697; x=1778624497; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+bTaNE0dwTN+qN6h1nZ07Pw7t4BRJtO96DbmMB+uZo=;
        b=oqcEUXIwompzsYIY6Lb88fszztMH0CQ3NogrK5PRKe01rtA0qrF+tN9PFwjeJomIeF
         GisM+kpfQXdZ2qYPkKyt0ThOdx3ejAEs82R129uH4ruKX8nNvVCuMrn2ZqYdhRy9uLX7
         uN3GxBoCpnalkEI0Nd+8tslyPgXYp62HY9vXBY9sN1aNY+jqXaKphl0Ch/mVez6IrxWD
         Rpoxt0/wZIwKyVkoPKxTz/tu1vPcvSSRw/eC3p+0hCvfDTq/1eY7zJqxDTNEtC5UWJaT
         Z7ILmcWwbwWVu9vpBmdZreuJSPS6tJNpwTSz6errxzogTTYmJA2HRyFQv0K6twc7qQ/g
         AEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778019697; x=1778624497;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e+bTaNE0dwTN+qN6h1nZ07Pw7t4BRJtO96DbmMB+uZo=;
        b=El15dwODcQQh/XGewcNiG6H6w3Gbc0OaXQqyPXMEYCCf1x7u4s36prLgVXnWZzk+Pw
         hJvA7knASPwyRu+bkBZyVDYC33Cgj7RHHn6l6rByWGl1UwjigrjGj3ngVXqdBYRrMLKg
         PyTWh6LUVM0LGwgdaGBiJMQlRnmh1hukFVUqZf6WRBsGj5O4p/N6zVNqYKp0+bF7E4xV
         6nRfj/F5OTSSv6bB+edNR0Se253TpnkhL9d4kQ1wO81nlEer4jFtnA71WgJZy96F6IFr
         1JhuMPMz9WwCYfajvoY0tOFmSBoyNXQWtSLn4mCw6U+KLpfxEtyEiEzxSpNeMmqgKAnr
         kzKQ==
X-Forwarded-Encrypted: i=1; AFNElJ9mCLOaqrkmeHrWP3/ARk0WoNrI180MV0VHhfxVk50M2I28t/VDO7D2i0y1aaz2+UiiBOLJG0VLtg==@kvack.org
X-Gm-Message-State: AOJu0YyaK1yF4mL62kpDBRSuspjCxMZoUqEQFD8MDmVTULLyp3wSFRRd
	Nahq9p27azwMWucnQ912kMFhzMPnWI9gXNHNSC2j8lJjCnFTL6ZRs30h
X-Gm-Gg: AeBDietX+93/1CRHqgFlwd77BrhSqafApZ2PR074QBOAFD0FM+zyPQKk5M0QGOwKBDz
	fZLjGCR3verN9Bx2TdoaHri+K8+Y88+PFePHPVqoRf59ZB0D4MrTEarLPiU6/Hwl3vpWvGGj2zM
	llRwJZs4VPpSja1HDSIQkqnOk6Hguj5CbgoNiY+IUlQjy+ExUi+np3roHnk0xPPB85DljQt7H66
	BC7VtJT1Fyf1Y9x1CKG4kGmKIydSqTuuElFfHSeCb9M9fspKLaQOfDpr+ciW0gk/sJ6TjNBngnH
	DxaNBUxCZonMROQgVieL0gdyBQpr61TOUIJVfCTezCQVfHsqvOeKm1iqD5witrj6RJuO/XKBnf8
	kZQTQG/G8DiLW2bjBrNLuE2vpSYO1bkkc3qra50XllAM5KMY8YCkj9aLFpYaA8/qvNsqCvjz7yv
	Nt/zjeNnkQ3eb46ayhGHAcKXJlS/jNUlXX85bvDTKcUHeyPjLjaxWdeFMkDx1JJSnwMDCQ6p9fZ
	mvTJLaG5G6QCPQCYW4hpj+lbKSpc10pMLsV5oys
X-Received: by 2002:a05:651c:4210:b0:393:8b23:a194 with SMTP id 38308e7fff4ca-393c41cedeemr3503181fa.19.1778019696437;
        Tue, 05 May 2026 15:21:36 -0700 (PDT)
Received: from smtpclient.apple (h-155-4-132-115.NA.cust.bahnhof.se. [155.4.132.115])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3936108fb80sm46308161fa.6.2026.05.05.15.21.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2026 15:21:35 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
Date: Wed, 6 May 2026 00:21:23 +0200
Cc: lsf-pc@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev,
 kernel-team@meta.com,
 gregkh@linuxfoundation.org,
 rafael@kernel.org,
 dakr@kernel.org,
 dave@stgolabs.net,
 jonathan.cameron@huawei.com,
 dave.jiang@intel.com,
 alison.schofield@intel.com,
 vishal.l.verma@intel.com,
 Ira Weiny <ira.weiny@intel.com>,
 dan.j.williams@intel.com,
 longman@redhat.com,
 akpm@linux-foundation.org,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com,
 vbabka@suse.cz,
 rppt@kernel.org,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 osalvador@suse.de,
 ziy@nvidia.com,
 matthew.brost@intel.com,
 joshua.hahnjy@gmail.com,
 rakie.kim@sk.com,
 byungchul@sk.com,
 ying.huang@linux.alibaba.com,
 apopple@nvidia.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 yury.norov@gmail.com,
 linux@rasmusvillemoes.dk,
 mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com,
 tj@kernel.org,
 hannes@cmpxchg.org,
 mkoutny@suse.com,
 jackmanb@google.com,
 sj@kernel.org,
 baolin.wang@linux.alibaba.com,
 npache@redhat.com,
 ryan.roberts@arm.com,
 dev.jain@arm.com,
 baohua@kernel.org,
 lance.yang@linux.dev,
 muchun.song@linux.dev,
 xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev,
 jannh@google.com,
 linmiaohe@huawei.com,
 nao.horiguchi@gmail.com,
 pfalcato@suse.de,
 David Rientjes <rientjes@google.com>,
 shakeel.butt@linux.dev,
 riel@surriel.com,
 harry.yoo@oracle.com,
 cl@gentwo.org,
 roman.gushchin@linux.dev,
 chrisl@kernel.org,
 kasong@tencent.com,
 shikemeng@huaweicloud.com,
 nphamcs@gmail.com,
 bhe@redhat.com,
 zhengqi.arch@bytedance.com,
 terry.bowman@amd.com,
 Yiannis Nikolakopoulos <Yiannis@zptcorp.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <21B8D62E-38AB-4FA5-8942-DA4417A7E7E9@gmail.com>
References: <20260222084842.1824063-1-gourry@gourry.net>
To: Gregory Price <gourry@gourry.net>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA570A0008
X-Stat-Signature: m9595bemi5tupr3wnzdcmt3pdh9k9mi9
X-HE-Tag: 1778019698-644468
X-HE-Meta: U2FsdGVkX182UnWlys/q7d52bxTV8CDnf5SHwfzJFUFUvWBqiod5oLlxgj2IPEcFWhWkMcLAxi61d31o7paw4SxEtR8ouuDFiaM374bNy/QNinsCb2GMOm+MK6EczgU80Op5TOY04lhQ3Eo1JCl6oMgse7wRLVNx7xseA+MRtsFgB1csxeVqA3elrxZ2dZiUr4CdCdGrDZam26PD791LBrcsAK0mUPXdqVQ71cqSUM3Ct6sw2xGPGM8heOy8kvcEl4R0JWZ4j5cKXboT3GVegDm/gy2V/EeOz8dC4+F3d3thQBaVz+V4+B9T3+LkoU0PKwYBthZ1isthKUyGxfXExNuO/iU7dLX5jeKjeQdZRrgBMHbOszgxz704cn/YL2F340MvutdI+PcI4yRG5yCu4J01zWH+BMkAnmVAadFXYwrX1b6eYOVWAhb31fTn1Otq1t08Cazxk3NEuRQF+Fu0R//4cctRiwAz0aNfn1kS2lPO000Op6LlOD2RnhlhrfdxaeZ+ZMPdanH2nBnUDwWkd3OQZBTCMNsJ77iqQ7u6BWOjnyYCTrmuknWllba4sfqZbJdn4EKyb/9x9LgmwXhLyk4F157nGVXAakeNO8n7BliaaRFzXYqs0MaRiZDK3q/b4wSvgXCzmUcJ53NSzDX0Zn195JpnOj0RS9bQz9VchMevzLdgJfDPb2qJ1G4BKkE8CL8beIeqGQcZ63u7nhuD9xsmYCLz22YFHQf4oXy1gyAhmoDt9gOlzdh3Aqk6X+UE22ZlxIVBOmeSjCN+uNb468biuvLdLQCTCKQ3SDWOZsX8l350LMC6InXXeBMtwcsj7p7BqPvyIoft0ywkvvriJ7UxjRkE1BzoQYECW3Rp1JRPExUv4gBO9AFEJHgXeEE0L74eZ4kh0Brmvg7nxw5BsUcUSHg4pMFYRnPpTm8V4wkqL6/JHqoDTt6WkGUKfd/aDbRJLx5HSJmBEaLCzTG
 Jw/UD9ZC
 ROjdSUhLwYYaKVTu7dKhhz4OSsCWaCbjfeaxcgNeiDX/REMO3Ltnqm2Pz1nc7sKH4kIfiiWiuUhYzbzuSWUgbWfIUKPnk+yF5j7VdEs3H5A++HKuVF3LICBt56qX0sat0pAwrhIX6anx0n4mSVSGWopmFv7KCbyqofAz5sJkzRpd6hHkQ+HSg6xJnqGys/tXVgZ9PDSnhUcz37zC/JtV54hZOOGz6WpWw+2tYlvZaQulUT6zqGDUjX+eCadVe9pvgSf6MFkvBn9uddZGUgcPWo/7PEjJOGMzZu+SJQD/tDPejBx55zFWOe1wSOipO+wbSn17jFGQFIbL5P2BdkitGYNQDtaUSg9esik+ahmMU8kjR9XzdCMZFZXpvr25Vy3gOY5AgRUJkCXhoJNm5mkVBCa3gHqqH3S53RH4WABL21Ch5sc4eZ0RwAeL1czibxeNSulUrsEZJlxEtQnklUbfudgzeKiRw65Vt0RwHCRz4Lr0iOlqGnuFufEMHH6ixQ2PGqvGgxXNj58WcrUuVo/TXTEidm/sSv/H6GsmCSdmGqpvmL1JTTWrRSt74Rzsh4qNOAeZ0jIuByJhnULCjVRV/nSX+dA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> On 22 Feb 2026, at 09:48, Gregory Price <gourry@gourry.net> wrote:
>=20
> Topic type: MM
>=20
> Presenter: Gregory Price <gourry@gourry.net>
>=20
> This series introduces N_MEMORY_PRIVATE, a NUMA node state for memory
> managed by the buddy allocator but excluded from normal allocations.
>=20
> I present it with an end-to-end Compressed RAM service (mm/cram.c)
> that would otherwise not be possible (or would be considerably more
> difficult, be device-specific, and add to the ZONE_DEVICE boondoggle).
>=20
>=20
> TL;DR
> =3D=3D=3D
>=20
> N_MEMORY_PRIVATE is all about isolating NUMA nodes and then punching
> explicit holes in that isolation to do useful things we couldn't do
> before without re-implementing entire portions of mm/ in a driver.
>=20
>=20
> /* This is my memory. There are many like it, but this one is mine. */
> rc =3D add_private_memory_driver_managed(nid, start, size, name, =
flags,
>                                       online_type, private_context);
>=20
> page =3D alloc_pages_node(nid, __GFP_PRIVATE, 0);
>=20
> /* Ok but I want to do something useful with it */
> static const struct node_private_ops ops =3D {
>        .migrate_to     =3D my_migrate_to,
>        .folio_migrate  =3D my_folio_migrate,
>        .flags =3D NP_OPS_MIGRATION | NP_OPS_MEMPOLICY,
> };
> node_private_set_ops(nid, &ops);
>=20
> /* And now I can use mempolicy with my memory */
> buf =3D mmap(...);
> mbind(buf, len, mode, private_node, ...);
> buf[0] =3D 0xdeadbeef;  /* Faults onto private node */
>=20
> /* And to be clear, no one else gets my memory */
> buf2 =3D malloc(4096);  /* Standard allocation */
> buf2[0] =3D 0xdeadbeef; /* Can never land on private node */
>=20
> /* But i can choose to migrate it to the private node */
> move_pages(0, 1, &buf, &private_node, NULL, ...);
>=20
> /* And more fun things like this */
>=20
>=20
> Patchwork
> =3D=3D=3D
> A fully working branch based on cxl/next can be found here:
> https://github.com/gourryinverse/linux/tree/private_compression
>=20
> A QEMU device which can inject high/low interrupts can be found here:
> https://github.com/gourryinverse/qemu/tree/compressed_cxl_clean
>=20
> The additional patches on these branches are CXL and DAX driver
> housecleaning only tangentially relevant to this RFC, so i've
> omitted them for the sake of trying to keep it somewhat clean
> here.  Those patches should (hopefully) be going upstream anyway.
>=20
> Patches 1-22: Core Private Node Infrastructure
>=20
>  Patch  1:      Introduce N_MEMORY_PRIVATE scaffolding
>  Patch  2:      Introduce __GFP_PRIVATE
>  Patch  3:      Apply allocation isolation mechanisms
>  Patch  4:      Add N_MEMORY nodes to private fallback lists
>  Patches 5-9:   Filter operations not yet supported
>  Patch 10:      free_folio callback
>  Patch 11:      split_folio callback
>  Patches 12-20: mm/ service opt-ins:
>                   Migration, Mempolicy, Demotion, Write Protect,
>                   Reclaim, OOM, NUMA Balancing, Compaction,
>                   LongTerm Pinning
>  Patch 21:      memory_failure callback
>  Patch 22:      Memory hotplug plumbing for private nodes
>=20
> Patch 23: mm/cram -- Compressed RAM Management
>=20
> Patches 24-27: CXL Driver examples
>  Sysram Regions with Private node support
>  Basic Driver Example: (MIGRATION | MEMPOLICY)
>  Compression Driver Example (Generic)
>=20
Hi,

As I think this is about to be discussed in the conference, I thought
to share some high level comments.

I have tested this for some time on a device with compression (after =
some
necessary fixes for CXL RCD to work, that Greg helped me with).

Overall, the isolation property that this provides is something I deem =
necessary
for this technology. Others are better placed to judge the MM plumbing
itself, but I wanted to say that this functionality is an important =
piece of the puzzle
from the device/use-case side.

For cram itself, as it is in this RFC, I think there is still =
performance and
value left on the table (as noted in the description), but I fully =
understand Gregory=E2=80=99s=20
premise in approaching it this way.

<snip>
>=20
> Future CRAM : Loosening the read-only constraint
> =3D=3D=3D
>=20
> The read-only model is safe but conservative.  For workloads where
> compressed pages are occasionally written, the promotion fault adds
> latency.  A future optimization could allow a tunable fraction of
> compressed pages to be mapped writable, accepting some risk of
> write-driven decompression in exchange for lower overhead.
>=20
> The private node ops make this straightforward:
>=20
>  - Adjust fixup_migration_pte to selectively skip
>    write-protection.
>  - Use the backpressure system to either revoke writable mappings,
>    deny additional demotions, or evict when device pressure rises.
I have some quick hacks playing with these ideas but I haven=E2=80=99t =
had the time
to test it thoroughly and get to something robust yet. I saw in another =
thread
that there is a follow up cooking which looks interesting.

Thanks Greg for pushing this, and I=E2=80=99m happy to test more on HW =
in our lab.

Best,
/Yiannis




