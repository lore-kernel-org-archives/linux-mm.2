Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE64D61033
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 06:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BE56B0005; Fri, 30 Jan 2026 01:50:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AEF56B0089; Fri, 30 Jan 2026 01:50:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BAB16B008A; Fri, 30 Jan 2026 01:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 592516B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:50:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 208BB8BF73
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:50:20 +0000 (UTC)
X-FDA: 84387706200.02.CDD0EAD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf22.hostedemail.com (Postfix) with ESMTP id BD094C0007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:50:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jqsQCTJy;
	spf=pass (imf22.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769755817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27ufXsGW3skh0Zqpt+kjwDF4L/+gPwFmN+6drdfpdU8=;
	b=tgMk7iiuDBu9dp81bMKtr2tZ0o0jKvFSrMXZlrLmdZkfWsiKOMJ1My91U84hRGqhhM1sxm
	3wvpCuoBgBU1LyxeA2AXWTIncuBu3ynMQKMo/kROrSe3LBIUWZfw8cz7+zu0ezIXAvWzo3
	A/MXWDR1NC4AK/ZG3gHqDbbsAbpIsAk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jqsQCTJy;
	spf=pass (imf22.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769755817; a=rsa-sha256;
	cv=none;
	b=YgIvAOs9SgN8tn3gU/cl49f9It18Tk1inSlVPV5B0m3tGGGq4nb64ehi+xc23qwcGwUb9f
	PFzOUWtMEYYQXKjksW7p5CGmPPOMK5NYnS8obt+kvxNtVBQwh/IP8wRLXPgO5tFu5hvVXQ
	QO1FRwMV+3DxT+vpofMYFIXng/cQXoo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769755818; x=1801291818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=YXKpjh0EJpqLSUJ/jki6Dyz4NykXUAKico+Ez/AF1IE=;
  b=jqsQCTJy5B+5imIeaWwtxPZrzL3BKOG4UBhW8aZJzK4NdCBIF0DZGpds
   NqnETrLS2RoWTe7wAv+XtIjbNVxw1hNVN1P/2Imp4BX27ModwnAhT63Q0
   /Tm05mlbeopFqIWQQ82RKbv54zEwZY2+OJTkzLF6yZe+Qt6H3ld38quLu
   3NzqnI83tfmvDG/lZV1gijhSWvoqON22/NtFeHbGEVyYuf8+ukROygHMO
   yufoxa4qTD6y908u0TNg4HF39C9BCF9jJQjZ3sbaqhkLv70jEQlCvFsiI
   fU5emHWarEelZ1UJBRMtcjEj/crQoqv99fYHSU0ttEbJ8WNCoiR33EFtk
   g==;
X-CSE-ConnectionGUID: hkoidpnUT0CqW0bwijDh3Q==
X-CSE-MsgGUID: pqyc61ljTXSJLi/U+1X0KQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="81320121"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="81320121"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 22:50:11 -0800
X-CSE-ConnectionGUID: mYaf0TBPRa2ykUmhlHu8pg==
X-CSE-MsgGUID: LrWGv+Y3RriQke2ImZiRkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="208696559"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 29 Jan 2026 22:50:06 -0800
Date: Fri, 30 Jan 2026 15:15:59 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 06/22] slab: add sheaves to most caches
Message-ID: <aXxaryFUrIFo7/hL@intel.com>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
 <aXsLKxukv60p3QWF@intel.com>
 <2cd89ed5-0c8e-43f8-896d-1b7dee047fef@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2cd89ed5-0c8e-43f8-896d-1b7dee047fef@suse.cz>
X-Stat-Signature: pbciuu4ukja57uhxrscujh1p8wwkki7q
X-Rspamd-Queue-Id: BD094C0007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769755817-920454
X-HE-Meta: U2FsdGVkX1/ylIcHLWWRGAcIsGxXadFcKBUsW2yL/snsHCHO7I4n94MK8594P2XkJN57VlBBCVzKI2Y3LwtjwRDpngUvbKZOutNCtBzHobZOCFwpMQX0VYfisZGcWBZP89nmgyKmu1PgJHy2UAAxMID6Vr2Rl0pyRv7q58wRo+1H3EGoBXgwCBrqloAUdc8XB6yuQrZStb+SFOCsMKH/FECWJPhLefznVsOz3aVO9ITHu1jzj+2CVtpaKOUX8ArY7IdFudPXx3MOJU1e1ZCTs/fpjwuvZITKxsjQROuF4VqxwT56OYLFjtpYk7tRJ6zf5SavdSwb4VYOGX2mbjPMu88b45ilE83J0yR4wzf8wosZrbtHl5MbIM87teTQhN/6RGvj+dR8Jueb1jdxA27w7XKwwOgNQBxjvxU4wSVXI8V70h0hDelmPnuDP4FGidQO1sGNzxj+EjT6MKV9oND5F1BjmJpF6iF6+0DsV4bZfgQGKRmR38fk6b6WF3L3ofpvQd4u2yUqydS0k+PS0qNo5lLQeljStEKk8IjmBFctHP5Bh6pPINh1qGX8b+sk8PelouHrtDqBuHxE7mGjHjFGogjtRxy8lN5bmo1ISqQTnwQ/XZkivpmj8G0ALzYapgiltvCahkI8N8DAGqaWwKgz/PslpaTdAegGxh9JEG4s38Y3LioiE+0KwJKACMEs9yd7R0V1wgrxoWoNUHBgQLBuCn2E4262qYB+xXqyrp5AcbpOuGBAZYiyB5NeErFs2z8OQdk7Q4z10Rl7XbTPlf4jfo+NccTCg2c1asPQGNmgu/NyE1ILmh5W+58e8e97FW2k1x3xaNPifeX64OziioTGXQAmnRc8s4h82zhuHGKXbssyQFjd7Ex1rIk3PD3s7txt1opyeWftTZLaIg8VUpce5QbFFY3QnV8Ns68Uu57tynjq6i46GKccwzRc0oa10SeYRkASAe4pi2n6VDHW+Qj
 sr4xsuV4
 D/OSD1YrFPiTQr3pW5zqgp40Cjv0sBQlAu2yyteRtxkF59nVn4R9p3JhJ8pgSqt5QP+Tk8T1gEkFZjzApvC59RPZSNTyIBIITaYOYAyynR3gLWsQaj7bQ/1rOO2lj5MX+H+YBTvJjSg7CbCCPmOyVCvx48adWXnriXgPlYIWmxpUqfxNw9+sQ6X3usmxUgHdLUX3PbXsOCXoKJZN2v8gKCbvfH8HXCrHOPovf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

> > vm_area_cachep's capacity seems to be adjusted to 60 and
> > maple_node_cache keeps 32 as the args setting.
> 
> Good to know. It is a bit larger.
> Hm I could have probably applied the args capacity before doing the roundup
> to make sheaf fill whole kmalloc size. Would add a few object for maple node
> I guess.

Re-considerring this formula:

the nr_objects in set_cpu_partial() in fact represents the half-full
case since it was used to calculate nr_slabs in slub_set_cpu_partial().

Therefore, the maximum capacity of this partial approach should be
nr_objects * 2 (and should actually be even larger, since it doesn't
account for the object on CPU's freelist).

But here, for sheaf, the implicit assumption is that it is completely
full, so that for the maximum capacity of objects per CPU, the sheaf
approach is "half" that of the partial approach.

Is this expected? I'm considering whether we should remove the
¡°divide by two¡± and instead calculate the sheaf capacity based on
half-full assumption (e.h., full main & empty spare).

Thanks,
Zhao



