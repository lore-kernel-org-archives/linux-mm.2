Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6338CD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 07:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5EC6B0005; Tue,  5 May 2026 03:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8668B6B008A; Tue,  5 May 2026 03:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755616B008C; Tue,  5 May 2026 03:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6463D6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:45:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CD6616034C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:45:56 +0000 (UTC)
X-FDA: 84732582312.09.A60DB4A
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 43F11100011
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:45:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fO5aEbzd;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777967154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZn9gNDq1rFBKVWAUdRINblw7hBlw9EDaJdQ6N5Sg9E=;
	b=LkYz0A3Z1FF1vSoFGtLb68zmktDlos9mY1b6P2g18g3IA2hqbVQMMURJ+lNdOX+pOoA2Pw
	ntWBiyR8pXhanrfmss41fjYUMMQ7aAagY01PjVsaQpNqEvgb1vVfJad5XFSosx1XFcC8QG
	6lZXZXL9OYOcYhAAm2dcQEOPmqzZSGE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fO5aEbzd;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777967154; a=rsa-sha256;
	cv=none;
	b=50UEM8dLRvoweWfojWQ/YSR/YzKH4Q85YK1osrewDG1ZshiJ1xEYUY1ZF/CXSOgb/GpnsP
	3AQXVNs5iFf0/PgujYQUCaKpTSEeiWSSBnv9R7QFYEbu5wg4/hyUcFynAgU+t/zLemP+ZK
	w4IosDQM0I50nOVoQ5ffkO7QTECAwv4=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d77f6092eso2989308f8f.2
        for <linux-mm@kvack.org>; Tue, 05 May 2026 00:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777967152; x=1778571952; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pZn9gNDq1rFBKVWAUdRINblw7hBlw9EDaJdQ6N5Sg9E=;
        b=fO5aEbzdLbSbtSJnkQFV9aB0EN8I+ueKURV57HHJkEy1rIjY4jgOJS9pRCHlT39d7R
         btf+Kk0/W69c9FJNAqsKKoncfCbgTJpF0MsG2xrKScFpqsy+Kyw8CpOUn/OzYaGnYMog
         WWDqnT0gkqb2Vg+MW08MN/M7EJBobTdaeJHrn821kSAg8MwCw45+PjB40Sq1c91KbvuY
         ur7WxFvJklKANP5ZAfXl+f2kuz10mn/U9mnWP0hKtjlXrM0iGAcCaRlyN7xiwJ1DJ/HC
         Wv5oNYAlRBoh74IPEP3TyO3uvfULcU6LP4i6sjb958jvSXikONLTTmbCaA1a1dMLALT2
         pMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777967152; x=1778571952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pZn9gNDq1rFBKVWAUdRINblw7hBlw9EDaJdQ6N5Sg9E=;
        b=ejeO3b6aDZeovU7un6xAxemVtNg9qPpseEZt13aTW8wN/iyiYC1JzmukIB8+BXSBda
         C6WFj4nZYLZAzCjJ7TSqEnNOLNROmhD8IXbr8SXSvhPkofGliHZCbNLVrandLJ5CTZhZ
         Cb/7RqZg0UclGkvH7Bta9YtAOQymzL/ldidiZgEOV6SKPtkJ1E75g8B1uVjjKvn6wtlm
         1GGEjMIa1Gu1UbBNrhiTKbT1dsrQqUdKJESBgP8v3clXUanxlTX63vU4f59egww3al5B
         jJjjEauQkiBeFBZYkkIj6cZHKhVThp57aEX9JCrd5eKF/u2VWRM3RsUeK12MTIMSfqbu
         t51g==
X-Forwarded-Encrypted: i=1; AFNElJ9phq+SDKbAqUkkhAjGvb0q9eEmrG+EeoNbmDNkFYXx3yDX29yU8IVrbezHnaYzZ5h1+pXbbG4xsw==@kvack.org
X-Gm-Message-State: AOJu0YyiF2cOLmbW3wMkVBrXJwtAdm6fS8hXjK2QO8NnMfTpLxQQ5l+y
	hPftPoqR+kA83MrgQKiUjmyCFqsriAEO3PFvDFQB53Nyp2AttT9O9/YJLbGRTjLp/gM=
X-Gm-Gg: AeBDieuGrxiGWjX/rgN2eZDJW7+vABxLAwS0oeIdrq1Tn2JBZwC/NihTVic/2YaEK71
	lrs/hQRofHk/dpfv8DXcqZ3hrJqZ1x8B6UoGk8WVZWmoYWB+fE9rOBZdQ/GeOS2OXt3cqAu4Jzm
	H0E649WJdOu6nGWBhb+Ad9y4epLe1+IK0f+601kjYLnUPCwPaIDXvxu+g1UKHR06riv2+goJ6WM
	zveKkaqQxPdqMB8oLckcfPeZhZKsXQPkGtKJ2ylxX86DF/C63DLUYYOlr/7qK888AYLA4k2BuTo
	1LeoW4pdp8IqdvwA3i3hxHtR6KZe6xGhJGbxm5GMcRObxejeI2KsUBaHq8si9CQTKAZs46K34fG
	H3cOr3MPWdB1ZONEpNYrHEDHBxKLUY481I73iSPPDjG9Pq+zQ1+DATD8/Fvp298MnPjz0KKXdi6
	4VC1ZY9GtbQsTJmSBrC67E4WkFYYbRhqC4DMukzV2Q/Km3
X-Received: by 2002:a5d:5d87:0:b0:44a:2f78:e873 with SMTP id ffacd0b85a97d-450041b08d5mr3594275f8f.17.1777967152279;
        Tue, 05 May 2026 00:45:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45055d36dacsm2455028f8f.32.2026.05.05.00.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 00:45:51 -0700 (PDT)
Date: Tue, 5 May 2026 08:45:41 +0100
From: Gregory Price <gourry@gourry.net>
To: Arun George/Arun George <arun.george@samsung.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com,
	gost.dev@samsung.com, arungeorge05@gmail.com, cpgs@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <afmgJcFUjQLYxkb5@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <CGME20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0@epcas5p1.samsung.com>
 <1983025922.01777297382206.JavaMail.epsvc@epcpadp2new>
 <ae_i9IlIndumJWN3@gourry-fedora-PF4VCD3F>
 <1891546521.01777455002601.JavaMail.epsvc@epcpadp1new>
 <afIKxG5mJZE6QgpR@gourry-fedora-PF4VCD3F>
 <1891546521.01777901881625.JavaMail.epsvc@epcpadp2new>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1891546521.01777901881625.JavaMail.epsvc@epcpadp2new>
X-Rspam-User: 
X-Rspamd-Queue-Id: 43F11100011
X-Rspamd-Server: rspam06
X-Stat-Signature: te7dyxijbnytuhgcpxaq16kjbydgg17u
X-HE-Tag: 1777967154-271988
X-HE-Meta: U2FsdGVkX191CmSF0n+MQvDjsmD7+rmuHoGZ5v7+R4tUrSwQe/NC9B9aClAgwV852FkP5ZDBSLpfadaLvxpFMpFUrsEBKT0zwZF+I39eKvdyZjxXTH83G64l0nyvP2vwKtQoojugGC3pZ7z+UyCD3oEx/0pHyRykICAX2nqX3Scy6ZDARyogXMXUCayANBvah/CV0Y31P2dNqXBpG2PBx67aTCukgiAOYXxDVAGKJZ3QRyJxgycAbREJ/44yg/79x1Y4i9/OLyKWS7dIFmLoZTVK/mGtgkcVF3ffuvzPiAjEz2Iuj9ejzz6xIB4bKkBrKhKh4pjyV/Ca52SbPTzh3jYAKGCU+MdA7Z4ovV9IOSc3aPmM4dJsDbSIXvKK1Bu/uc/sZCTtJ0Xc+S8yOWGM8ygEzFfqgsoephJt77Co9ASy6mtnEVczm7kI1EW/h2eLdGSofNMJgbB0qb964yNVlfHwwmfp/IWjtBdMJLp+7MPayL/pvHlmx0N0Qd1Tkr0a+NzgvTGqupVZLU/s+x0gXMeD+hzfZfUhahNE4U4fToZAr7YYRLyfjbcDRociJBbb9S+/WVirR2bX8Q4PumKs9W6EwBRNph+dZjd7uOctMddEpiFoq/ZOrXatNvUCM5AjOZFx4Ul+dw2MLM+YhC/wCh8ciYwk+rHHsvCpWfckbmpHkgggoz1qBQFxPxN0doGlBFwkVz9HpV19Hju6nJ0UXajLHehOCTafTttFHIj7Bj5I4EkrDu3UwDXvMqfiXBHltDG7QfreZlQijIAaKHZPtOEwgioC/5p1UPSBQmqJgwHWlqODPeGSPF3cpGJIGI3A2+9qFX8L+Dmiq7vxyYjElvGSc/rJ8CUIZn9eAvjrpdcuNpZDdmDizBVIA2fh/iNNOeGFdbuS2JHg9cZwFic9Ygcjmsv68+xyjxy0TtQTVpFRzQ/qaWUBomSD2p1ETfpC3Eur4YjtesoPR66VXvn
 MaprkJZC
 OKSPchTq/LhsGJQ+lVIlk+s3Gk7d/X3XSjtYfK7uhvtXxCBI7hmuhYX4DU6+vDiNNu3J4LXTuaIbT4Qe9kvtV4vGZk9EzZDkzc10PNy4MFrcWyrQ2ykrZHXTgZ8YMzGcFqwqgWxR7Ot3CYFkQPPBAW6ZlPgKz7hkhwX2nXqxCKlvOCw7zKZVqos76ERVhuaJb/Tqwzs2MpF8zy8ZrnR/as2R0ttnX5iwo0RpQA7VxpPwFYHQusQNMUc1N1elizaS5wR1xvMMvb+mV+RefR4hmZtp10rLl5zLcMGXZjGoyLXUL9nwEx53thq0IehrKpcNACZd0NLhxaP2JrveRHiRVt20gnSURx53bk7YaRC8cR2aZ4qc5lwTLmZrJjCzVvvbuvUUV0ZDTxjHgTKxc6vpoYFYyIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 06:38:54PM +0530, Arun George/Arun George wrote:
> On 29-04-2026 07:12 pm, Gregory Price wrote:
> 
> But I see this 'write budget' (budget in terms of number of write 
> operations that can be handled by the device, not capacity) to be 
> provided by the device in control plane; not by the workloads in the host.
> 

In the scenario i'm talking about, a "write budget" is defined as a
number of pages that are allows to be mapped writable in the page
tables at any given time.

>   1) We can modulate the write budget depending on the actual 
> compressibility in the device (and so workloads data). We don't have to 
> do estimation based on the workloads.
>

Barring the device causing backpressure to increase latency and slow
down writes, modulating a write budget doesn't actually do anything
useful.   Once a page is mapped writable - the CPU is free to write to
that page uncontended.

I think a write budget is "doable" but maybe a bit optimistic for an
MVP.  There are many corner cases to handle, and I would prefer to see
that as an experimental optimization.

>   2) We don't have to do the capacity modulation - as in ballooning or 
> shrinker.
>

You still need capacity modulation in some way to respond to drops in
compression ratio.

~Gregory

