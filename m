Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E6AC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328BB6B00D8; Tue, 14 Jul 2026 15:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9876B00DE; Tue, 14 Jul 2026 15:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB1B6B00DF; Tue, 14 Jul 2026 15:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAAAB6B00D8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:16:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 579AFC01EE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:16:58 +0000 (UTC)
X-FDA: 84988339716.04.02AFB93
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8AC6F20005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:16:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mxgDV/6d";
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784056616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ox3+tgSJ/1AGA/fdosn/WLv1EiJf5bYFeotrA4JXv6k=;
	b=Gv2Bcmglq0NDk6shk16kFxgYhD8Ynn4Z0Suubg0buN6NR7rFwyi9W9qOcVbMqCIKBwKqZC
	3MgzNyyp7ClW1P/tUuBQkIOy/f9UV0TA1eUZh4+5iiIzwzJxkFhpN/UqVzJLLzmEH9XIm0
	QMWAJwIF7HqC7ZUF31slwvSJWs3DjTg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mxgDV/6d";
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784056616;
	b=2idHB0qHVskYKFTrgj4iCKJJyXl432139zZhzIDVjG2fjmJjHlqbH+nksgny9B0s2m/DmO
	u65YNcwWazzFjaP6ttGLmB/1/6D5x7+b1vKtzVEU46Z/2Ee0VX3bR/miN8EFpohYBKrDLh
	m0pPZmjLEYCH3btW/a9pObfz1EwfJlg=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6a38e51ae95so1003587eaf.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784056615; x=1784661415; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ox3+tgSJ/1AGA/fdosn/WLv1EiJf5bYFeotrA4JXv6k=;
        b=mxgDV/6dP5b0JgpOZPoA0qcPXIDhrEr6CKfflNG7BfCWs4wO2xjDG8XmsPeUeriHVz
         84YYRDs5Z/LXhUfeBE5u3xHr0YfY9a24VKM6No1MV3k3FMsDuDjvUnPE7WVG//gGUcL/
         LmA3DUcruF5WCC/zFUKy1c6W/r5Vl0dS6iNfeTxtdMVtl9EHqoiCshsrSN9eoSUGtHuo
         vIMfczjBwLkd7o3MxcxZcqp4A5oWVhSY6bhdk95RjmP9ibcpcCVc4Ealye4IaKottp/c
         UGbMnru4LB44ZedArNrGgkGcVjxLodKz6pH2QlEysZ5KAiZeoc1EVBIRM6jg2XwzKuW4
         VETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784056615; x=1784661415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ox3+tgSJ/1AGA/fdosn/WLv1EiJf5bYFeotrA4JXv6k=;
        b=YJ9GSdk+enyvVlnqtEVkgjvft20O3PKPUyYZ7DehOUpIPfkc4dTzOdp4/3bAna3Uz9
         um5vjv+xEQKZ7xxyjXviEQEkURr2I+8gnKMhqu/+Yr8ZrtD2rJczk/wfAMxzwyeizj2Z
         dMg4pbZE0/F4nOp50LDVBiQDzkKkeY25DyePQ+fbn6GpFILIFqcH4oZ+sokdpr6LP/VC
         1/H+LNfPtUQgsCwkjl2JwdnaEfe5lLAbi9tZSvTsUwfF0WCdJsiMLXYUL56oz29TdTvO
         MPwqHk1FtFXQFvJNR4u4ceXUQ+4z1uKG84tspGww7D41dOXRTTNndyxUUPOasG6eO6fC
         OwFA==
X-Gm-Message-State: AOJu0YxBQ/o0+FJ7FNQ8+dfdjlWN8/mnJ5Clgqaq+xOTTmlgaFQC6H+3
	yVki2ljQFFtgmmQTktJ7q+CUTqHIqPrHeZ4FBblEx6Tx21HGQafzu0RG
X-Gm-Gg: AfdE7cmrIweOjQHlzSWH1AhyfFdZiEpcBbOvY53QJeHS1L/IP0y1iwGKghmZO1sEKKo
	JsCNpoX+kVa0XjvolJnthCT1qOCU4/MD9vyrdW0tnrBDb8EmZFdhx89Ul7t3oTwRwGRSVHSkXRc
	iN/d/VY8ISlS/cWYNURVuBmE/rGW4N/cvDt9Ax2G11SZ5N4Dnf5BQwEe+AAr9uzRItlUUmh+BeT
	Jr6WcVPkTqoge8xLICcdKezFiu7BtHZ8+2uot4Y/xBSajybQcMnCA6xlXReeDcB7V4C/OkCHJXB
	82LuLqnoz5yUK3TTdCSeXmxHtlSz761xVK0qU0bLKnt70J42JEy+Y/dpdd5kH5XDBOHlmNhjO44
	shKdSPhw3Y2Ey+t7dNxtmywCV4+RH5oe/MfxJZ1Ir60wWzZuikbzKHB4DlWfToNKJ1IbnBqdLo9
	rglUj68S9NLqj2AKD3Z3bi4lsijTrYrEYjN9IrGFM5Rg==
X-Received: by 2002:a4a:ee19:0:b0:6a3:9853:acdd with SMTP id 006d021491bc7-6a3da002ed6mr39060eaf.33.1784056615491;
        Tue, 14 Jul 2026 12:16:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcafdf8f2sm15761350a34.11.2026.07.14.12.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 12:16:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memory-tiers: cache top tier nodes
Date: Tue, 14 Jul 2026 12:16:52 -0700
Message-ID: <20260714191653.829251-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <yq5apl0sk383.fsf@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8AC6F20005
X-Stat-Signature: bo3bn17igrjpbbnyb4o1rexs5ss3qk71
X-HE-Tag: 1784056616-35894
X-HE-Meta: U2FsdGVkX18xsfOjw2VNTUrk4mSL7CfK4I8kdqdY9qc+dupoMQ608eB4HplTYe/knmfVhNSOVGqpYTYe9TNYO4C9NiW0wY5DH0QiHRjpqzs9zdbfsHxksLJBuWV4Zs5d3Divm6vvzu39H1iWXRf5768YPMXh/Xhb/y5g/JnSYQbrlBPuOXDlwphexhzJas0ElIgL51JUdiSMktTALop5dnJmiaYpGkSBI/Z22SRR+9HMMLaLGHFRuxVIE8q28CITXa100YWvKMWc9cyQBNHtOMmqQ505x9LWnjb90eAypMWHGZc8bTNNKwSQhwcu1+DO1r1ztOSvA/yzqXuavTz6+Yo0SAFmRXbJxuhbtC9QMH/ajJXBwH0tAZRNdmWHx5zjjwvs5IjExZ5R3WGDu1+NTHaeRHmyhCNLWh0EhKPrmttaQEqJq7aQD4nFHFZqYg3a8sSFnsXyFKJWEl+owoMaXT0mV8WwQ8V60DfzaRLbakPBEL3BBZqy8diHqVd0uRTrfQMeneRx473hSNLlrxzGc5S0+eKFpbFbsoABeqCMI1qUp6/ZE24k25InVtYMxfVcAQg3WOqdNkgMipEqo9bKsh17jMUPFTp3XyYu7+X18QlFxcGYc2CjCxmuC/XBdZj4rzkTnsBYfJe/+lyk/2lNk0ImNMKhudMOjQWGP7iUE/3Wr40Bqspwp9qr7ZYNY2sWPz0xpnt9WlvKpJiFWRJjXcWXk9+8SiCUdhnaQBSBEbS6/zRX4mHydYzfoo2MyEHygiUw3B9b3crt5AKe+xIJdUA+53vxSTNOgowQx9Ezt2IGWOYVFauuJWaGko7g7TlZS8ZJXOJZu4rf92qFBga4jb2FKVEP4R7ewW0prIkNkiWZEH2AVq05QKAYLauk0nTFDj5xstVq7LA90MUuapJM8bakz21Dl9El2F17Uz1TYKV6+0KDZj8NzSdd5ow6S6EZBGpbHJAUHpBo8QMjD3r
 oCx62NiU
 2gZzeryQ3hFloeVHB8FEEHkrQou3kjRE7FVU3dOFGl3/2gvHDilT4X2VpFScGz2aDGS+SBDrFbEQ93Gq7oJldBhX1OhKGKJZJbvE5YB1Q20UnyPeQLeN6Ifrja4od0A8g6u930+Dux5PKvFCF/mwX+avF754Z+MD/SP6tc3P9dz8ZRgUaLDJlAZabdC0QREVVMsaJ9s8DnGIQcsWrVHvQNbLPNF8oS9TYeu04thJ94+uq1vejPskML57QMebxsBS5uF0W5RzK8Gxu1J8Tms8b+xwT1WgdGLMS9aIN/gxCZQ4Y8QwxRqmm5jPTg2ya6rw+Mq+IslK89i9vxi1PB7LC6ZUOot4nMb4JyQIE3HiGD9AHmwedE9g3cUpnFAhxN2fVo5IkcEPv+iqKEBztHYMqq/fOPTc4cCOy/9ireL8a7yIkOsrOIRkrGWiXNQx640QYd4neDm055rx7lLaQdxUXIIaHVZSBgoqLHzkBNXUocSI1N//mpGH3sA5eCTvYC+OOxPQaUvLpaqmLBa949ScmO82YZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 12 Jul 2026 14:13:24 +0530 Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
> > node_is_toptier() is called in a few hot paths: task_numa_fault(),
> > should_numa_migrate_memory(), folio_migrate_flags(), etc. Each call
> > takes an RCU read section and performs the tier distance check again.
> >
> > Tieredness for all nodes only changes on memory node hotplugs. Instead
> > of recomputing toptier nodes inside each of the hot paths above, compute
> > it only on memory node hotplug events and cache the results.
> >
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/memory-tiers.c | 36 ++++++++++--------------------------
> >  1 file changed, 10 insertions(+), 26 deletions(-)
> >
> > diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> > index 54851d8a195b0..2e6e02ec1fce4 100644
> > --- a/mm/memory-tiers.c
> > +++ b/mm/memory-tiers.c
> > @@ -71,6 +71,7 @@ bool folio_use_access_time(struct folio *folio)
> >  
> >  #ifdef CONFIG_NUMA_MIGRATION
> >  static int top_tier_adistance;
> > +static nodemask_t toptier_nodes __read_mostly = NODE_MASK_ALL;
> >  /*
> >   * node_demotion[] examples:
> >   *
> > @@ -276,27 +277,7 @@ static struct memory_tier *__node_get_memory_tier(int node)
> >  #ifdef CONFIG_NUMA_MIGRATION
> >  bool node_is_toptier(int node)
> >  {
> > -	bool toptier;
> > -	pg_data_t *pgdat;
> > -	struct memory_tier *memtier;
> > -
> > -	pgdat = NODE_DATA(node);
> > -	if (!pgdat)
> > -		return false;
> > -
> > -	rcu_read_lock();
> > -	memtier = rcu_dereference(pgdat->memtier);
> > -	if (!memtier) {
> > -		toptier = true;
> > -		goto out;
> > -	}
> > -	if (memtier->adistance_start <= top_tier_adistance)
> > -		toptier = true;
> > -	else
> > -		toptier = false;
> > -out:
> > -	rcu_read_unlock();
> > -	return toptier;
> > +	return node_isset(node, toptier_nodes);
> >  }
> >  
> >  void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> > @@ -497,19 +478,22 @@ static void establish_demotion_targets(void)
> >  		}
> >  	}
> >  	/*
> > -	 * Now build the lower_tier mask for each node collecting node mask from
> > -	 * all memory tier below it. This allows us to fallback demotion page
> > -	 * allocation to a set of nodes that is closer the above selected
> > -	 * preferred node.
> > +	 * A node stays toptier unless it belongs to a tier below
> > +	 * top_tier_adistance, while each tier's lower_tier_mask collects the
> > +	 * nodes of every tier below it so demotion page allocation can fall
> > +	 * back to nodes closer to the selected preferred node.
> >  	 */
> > +	toptier_nodes = node_states[N_MEMORY];

Hello Aneesh, thank you very much for your review!

> Won't this result in a larger window where every node_is_toptier() call
> can return an incorrect result? This change would make every memory node
> a top-tier node until the loop below clears them from the toptier_nodes
> nodemask.

Yes, definitely. I think I should have instead constructed a local nodemask
and then swapped it out at the end, I overlooked this part.

> I assume an incorrect result from node_is_toptier() is not too bad, but
> is the performance impact large enough to make this change?

Yes, but I think it's still important to keep it correct.
On the notion of performance impact, it's not too big in the upstream
kernel, but I'm working on a series that adds more hotpaths that
frequently checks whether a folio belongs to a toptier node or not. 
You can read more about it here [1].

Thank you again for your review, I'll send up a fixed version!
Joshua

[1] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/

