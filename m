Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDD2F531CB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98AFE6B00C4; Mon, 13 Apr 2026 15:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961796B00C8; Mon, 13 Apr 2026 15:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E2B6B00CA; Mon, 13 Apr 2026 15:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 717256B00C4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:41:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16531567C6
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:41:45 +0000 (UTC)
X-FDA: 84654552570.05.488E845
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 463E0120015
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:41:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nr01Vf24;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nr01Vf24;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776109303; a=rsa-sha256;
	cv=none;
	b=i5HBWZs+5SBwMA47afMiwCZxXpns7v1pasZePHNMQ2hPYBiQPDwF+7cWrP3D8FSo02kowF
	vJrFzRj/re870e3wXpgDCRkj/6yepKFHod0TUFhwTEJA0crmGWxjKuLTcGWYoZQfD5MVEo
	FF+1Ld0VOHbzkRsSeDsD96dL4hJz7u0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776109303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANyztBlS8ASp9MHR198GNmIsfqkyGsWGhTyu9QD8TKg=;
	b=KbwISbnTwA2gxsqHPWS1OvtQ87pL1PGknSnNJ0x9tQdzZBm2o1UuVcq9gE2Q/YlmWVRlUH
	Y+0ix5iFJPeMDZ/F2VyQd8iZRhqHf7j+79y50ewtMAuVL3o3TXX0NuHxgCLP5wUd27z6as
	sUS7jqw6lhhZlqXGge72Feac8zK48UM=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8d933da14f0so526795285a.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776109302; x=1776714102; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ANyztBlS8ASp9MHR198GNmIsfqkyGsWGhTyu9QD8TKg=;
        b=nr01Vf24VvBmOrUTLTxbZwSCZGTaMyzNg5MdRN7ASXkm47xz/7uiaEYfU9yWCbk60r
         zanKEh24YT4xMUN/KGrNKNs8zAJ1k/F01tBVg5mq1b1L8c1bj6pMo+nDr5kX9FskZ2ff
         ETsBvovymJFJopALPaA1kgDNvqymmgqO01eZS3vvS8WG8h8III6aWHa+JCQnrDpyZi/T
         P/sfxvPjbWS9lb9pbW+ovCac4WE4TB/CJSZgAdxl3X18omaDDyegiD/TCHkCMEoyCyFm
         cBC4fT4RaulYSXimIRRdhwQ4xffJ9k0NO/kSi+h+y8kV+y9mgeqlcdnll9mH4eUR85CJ
         a4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776109302; x=1776714102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANyztBlS8ASp9MHR198GNmIsfqkyGsWGhTyu9QD8TKg=;
        b=kPejksnvJlYlVpqFL8jJZSNlV6BOrYlQTJa0Cog7flUv6XQ53/tJ7O+qaRHe/NJWg/
         W18Eh6/Kbbz+oM81ngWavoTDpJ00RdSFRaCI5vsXTImGnGD/5j5w7MahP9/qHLTKBb7J
         FX9hrmHbBxgNIaAvosFukMW+8MHGjH8MUw6WoxGjQyt9fis9hFFDcYNh1Bw0AngHp1Xs
         wIQt6CLARWu+n41I7MeQZ9r8qXk4t65VVBK9mI+W7J6AFOiWoYmav25gzkGcG/UBIXYh
         N25/FTqG4LHr006dsZcimapXiEZ5lGE4bszwmCboaQAglfcdhmyiAz+WK2MVpUa6s/MA
         UY2Q==
X-Gm-Message-State: AOJu0YxBa8wJ4vfXkKg3aFHLqX3fmn85xyZCE1YhOInAn5PIvvr0Kh0t
	rzFCu3PfvnO5+dPb+zXxFfkeaSEFmtvIxQERGK6RMrOIFVg+OEMSbTd+m11wgEpafSI=
X-Gm-Gg: AeBDiesL+uLXIyv5Xw5Ef4t1uNx+VknLrYWc7p+7GIm3B+/yjhFjN5wuELPSp4VG+Jg
	Ui1sKEQqwkxViFT1Q7EZgGHPe/A9ZRrZKH2cwMs1EZkOozrf5J9MncobEpZbXKSujLv+/qEFVwH
	TrJEgsdlTldwk3hdgpIrQA0U6yEhV6eYAfgFbWEXipaJ/iaOwm/nsqGoXViOIxH5i1gpLvYCCI2
	/SCmuV3GJf923nbKSo8sNViNYUYNjwZK0sHefSx+/uRrAzcYYWRlNLSsQ4vrLut5a/p5uhe+UoW
	+T3PLWWf794wK+KOj5U8UKTfHAxOmmUnirmbHyPyrZRD7RmBVhjygl1yLbkPX9Q3fnMO+U/sDrN
	Aw6pIfNbI4Fe7fCcUc355+qwWQDTt9wEKJjMSSchJV+MuV4s5zfqjRbDhHGX1/mwnsnw+cXkrUt
	6u9mcV4SKYA9sLXMduINKD1x6WtBZbyRL/vUnn3fKJmGECRmrIuUPNHaXfJQ3JZnLMFTYQoRtmP
	yQBxVGdxZWVeSH8yoPW83UviyIlf0oCvQ==
X-Received: by 2002:a05:620a:440c:b0:8cd:8320:3359 with SMTP id af79cd13be357-8ddcd024831mr2080049985a.9.1776109302203;
        Mon, 13 Apr 2026 12:41:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb5f88c82sm901067685a.2.2026.04.13.12.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:41:41 -0700 (PDT)
Date: Mon, 13 Apr 2026 15:41:39 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, osalvador@suse.de,
	dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/8] mm/memory-tiers: consolidate memory type dedup into
 mt_get_memory_type()
Message-ID: <ad1G84KdvOmKSRNM@gourry-fedora-PF4VCD3F>
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321150404.3288786-2-gourry@gourry.net>
 <e0e48659-8ce1-496d-8b5a-f6d4416f2ea0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0e48659-8ce1-496d-8b5a-f6d4416f2ea0@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 463E0120015
X-Stat-Signature: r9qahsnpp6c74fshuzta34wijyccce9f
X-Rspam-User: 
X-HE-Tag: 1776109303-54849
X-HE-Meta: U2FsdGVkX1/TtdEWT5Kr3Gn1aGGTDAY9PCvIm5pWR5jvtbHBGwA46kB0irL25ELhRix8C3UyoYiM7ZmN90Tk0CYdF90HV91nJt4mhQGVCvT30Cq6ytAcHDx4wDhrRpzZqS5JrNKVlMpBrRXODHh/tdeRRegYsrfWQegKZ3aZHwNiei2u7616jAoXj41lo9RFRcXQibSnG77L4qFUJks1Ctht81UO/913fz+Wh6E4RWfBYvNY0WY9MIybPjUAWjcU/ZV8FIHUs6MY7rcO+p1qoPpgJpgz8AtJDW5yfF3YftvLVokKhWobmC4hi6eDgLFZr4QX6qFR50Yf2OqhoQ/bOBe4OXvp8zWFu50vexKOOwFmMvKjTWQwf28Nk2ljh2ezsThjkfrPFVIxMlcMEtC/ZOjuLtXC/vW8hU5zU8+bNkTtVhIQZtKkNV6NFCPybNCIMinSuZj+TID+r22r7q8eUYDXVVAJfdxy9Pmk0vwQcpcThT9qpfYTUx+RsK69H2B1425ZtEZnKPeLF11EdgLiVYDq+2j97pPnAZPVHBWJR2dPPDYts4Tdc5h/e2n2M1JRSQf71mnDOUUZS2eEbgPMOZtThsRFJfHNRnoUo1NQorFHfiCLupqvMCyd8qyK1G7dbx8gxTrq2nfYAIKDzTgI78q5UA8Dv8pSI/lfXBs4iMqRx8JuPkx597gYsMQ8bdV15zFp9DQ80GdGzZNWoRTQkijboeQf8e5KFOvP29HuXZj2hXDUyH4qr8m7unEv/XFO0/OjGpm9ucjz2f+qoU0yndudo5dF8w52XaZaHFSSR5dPnDR5OtHBeXK0+ZxFaaj8+3cqqdlPBhJJgP+Fm/7WLGcQv9vYFloJafIiG4Ri/6RV0b2ZMR3bvTem6neOK+d0ssYjqr/efLGsQsNL/cxbKT+t8D8ADj9KlloQWI2sjvQb3F6VgWorVKcwG+Ael/FLLyHkjUUk0x33bRKKs67
 Lri7beWm
 Ze4LRdwBSbQFpFitBudXB4c4CKMy3FKmnawyIAkHsKt0RJzZeOEbrEy4zOTNIQ4oKcuHwyAxW5wD0GGGkdZpcuQ9WgktYrKsUh6y59YsrVMf6OabbMSAj5I6vnJUhXz68woWvI1YX4/+5ophuHgZpHDQQX3In4pt1xJtRu0gGwgFdx7Iw1jesSs9ojRMhCOC1nJVu2evCN3Bk6ANX29pjNAMgXSqyleg0IhTWSoekSA64gBHtyScdCBE4bDrP6E01XBuUnYPR3WlPwKmjHC8cIpr/jp14rF0qz3kk25s1IcrX4wlSP1cBEVyCLpee/X1xzhAIAd0C8EngvP6Zzb5qAAZKLhTKqbse85grTB2JpP0vfE6JWUhU3jKScw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 05:06:35PM +0200, David Hildenbrand (Arm) wrote:
> On 3/21/26 16:03, Gregory Price wrote:
> > Replace per-driver memory type list infrastructure with a single
> > mt_get_memory_type(adist) that deduplicates against the global
> > default_memory_types list under memory_tier_lock.
> > 
> > The per-driver lists (mutex + list_head + find/put wrappers) provided
> > dedup within a single driver, but not across drivers or with the core.
> > Since the number of distinct adist values is bounded and types on
> > default_memory_types are never freed anyway, the per-driver cleanup
> > on module unload was not useful.
> > 
> > Add MEMTIER_DEFAULT_LOWTIER_ADISTANCE to replace the default DAX
> > adistance, since it was really used as a standin for all kmem hotplugged
> > memory.  This at least makes the default tier relationship clearer to
> > other drivers and they can see where to put their memory in relation to
> > the default lower tier.
> 
> Very confusing code.
> 
> What's the purpose of kref_get/kref_put if "the types on
> default_memory_types are never freed anyway" ?
> 

Mostly trying to retain existing functionality rather than delete it.

I think the entire memory_type() infrastructure in memory-tiers.c is
generally very confusing and of dubious value - but i don't know who
out there still depends on it.

> IOW, couldn't init_node_memory_type()/clear_node_memory_type() just
> consume the "adist", and lookup the memory type itself?
> 
> All you'd need is some way in the driver to verify that there is a
> memory type for the given adist, as some kind of prepare step.
> 
> Alternatively, let init_node_memory_type() return an error to get a
> clean interface? :)
> 

tl;dr: yes all of this is true and I will rework it.

~Gregory

