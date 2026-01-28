Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2722D3F06D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 14:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4772D6B00A7; Wed, 28 Jan 2026 09:21:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F5F6B00A9; Wed, 28 Jan 2026 09:21:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D956B00AC; Wed, 28 Jan 2026 09:21:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F25E6B00A7
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:21:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD9C8D427B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:21:51 +0000 (UTC)
X-FDA: 84381586422.02.CEB7086
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com [209.85.222.193])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC2DD4000C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:21:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lHCFq3eO;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.193 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769610109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFnWufKdjRl1LzlNBH4foXwRJEqqXwbSTG5Sb2CxZBM=;
	b=HQEQOkfO7w8aebiMaAQApVzy6y7Zo1MI/7pyZ5JttLjhmMjCQPsHy+udBG8inRPpXM8j6z
	viLUwNntox7svvHIDrYzqrkj6+2dgSw8exIxHi63dn2aGB3LsxZ2KqkXGlB3WjSnGcjUtz
	t7gnx0dVhdbbsKGqTLtRgg9l5AD+MQM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lHCFq3eO;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.193 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769610109; a=rsa-sha256;
	cv=none;
	b=Dm2aFSfNRbRDOVWbVdRbO5srpYu/iJEwe9OO8WobtKC56DTNuVY9rofXVI/ntdMoVQaJRk
	g5osrbmhz1wEsYn6+fIFIy22pRbLuvQ8g8HTfnv3MrH/WcT+vFsoSmCyjGw0cAAKwep0cC
	Mo3wf/FTNALWxmyBpQ9cuFgNi2UUDtw=
Received: by mail-qk1-f193.google.com with SMTP id af79cd13be357-8c531473fdcso911261285a.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769610109; x=1770214909; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JFnWufKdjRl1LzlNBH4foXwRJEqqXwbSTG5Sb2CxZBM=;
        b=lHCFq3eOzGX0JzFg7LEb/fc28ZFb9d8jHkHG/jY+Swy23pqSsXrK2E3Frh6peEoIh9
         x0gZQAeQQEdzdkf54yX1+ywVoGxUDeNypGexIAYp03Fy+86cxVYZZPCjnZm64ZFZFZlr
         iEDh1hA2YrCmt8N1SNLtXznm7TzQjtZ9010aOs0zlTTTPe692v+Jr+xKdf6uR1TYuB6m
         3Y2gtZxkaUu4eg1Gyyz7rzO7LvZx3n4IaV46WS5xgaNqLbQPxw7OViC0a80Nwp7K3CZO
         xXtksXtbG6YhlpLaQbIbztJlkjpe5tn1veWqiSAZndo1t96q8k6wrNw2I3LzOLX5Snp8
         EuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769610109; x=1770214909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFnWufKdjRl1LzlNBH4foXwRJEqqXwbSTG5Sb2CxZBM=;
        b=gakQcjgnoV72j/QauoU50P/7KWoqTcmoOk6hs8twFZt5FwltON2Apo06AAwCb9+lkA
         hozdA0GiXZIqiIhrECaQ9Q3pzZUPAwxNU0tJQx/tWg9yJrOotBaQ7oZ3ooI48gccgoPt
         fU7Y7v6PZ7XysSxTIkHbiNAgn2t1Gglp87Gmlo1PWc/CqBliW6/hG9Ck1xpE/42SSwnp
         f2ZPcOAtL0ifbg7wgYswHHNX5tjp7zodymAkrtEtgra7glB6BEwUx/20oNP2ccNS/1Xc
         Y6BPQreUCRjDM8zx3x1UVJ+QAyKSvBq00Z0YEVUZDQWY2oqev4hl+yK2XrAyJSVUweMX
         MaIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDRyjWCXld54vI92YgIhUDlzsS/4THO7QtZ96OyifnoTVtXhmtbfDVLWwRPLy9k3/MBpVP2RN8Bw==@kvack.org
X-Gm-Message-State: AOJu0YxMq5YJ1T1uHem3axMQOL/zf9O15Q+IphkBs/EuonWIIpuWmEFy
	LD0KlwR1iKPJoz9LvL2wLGhNSqtLdkpOMncb4GGSeuMm7Sra11nIuI0eLPI3SHATegA=
X-Gm-Gg: AZuq6aI0n7ozzZbLGN/fQtwTfnLZRgwVUxTACR0/P7HEUKjq7Ikekzd0sFOTcvZ2uC1
	s60Uw4al9YI5hwkoSBYWqdpSQzXlW1xs5I6ecY5AmhcDJ6hEDpsAqpB+AfYrq2I4/WEycmQsljh
	/jg6EvatpEVBRarcQwx/5i4Dqt6qkYpxNIpU7VtREBUd3y++nyxiZOkjj7EF3XoRiRU0obJHRDK
	wfozkp6Uz+EB0p8cnszXzafRbDCo0hsC+JE4hfnvoTTrmICmSaljmH1KrMN/6GV/FukwihliWDu
	ApZYHIDfXZDw0fItMlpjMahH9u+BSG356Mqy083vrqJDY8w8+xB/aM8vLWwyRn/NhLHkkhUvbC3
	YX5V+ZiPLf98FjvVWZ95NKgHLlcdSjbeYkEGHIVBU7XAuvRNaDaa5RC5+a7UP0t4+hykZ9+xsNF
	2EfJ+Ky+Z95Ms+7UhOXqWWTxbXKxgwSoFp1+3rNrYzZUD2gBAQ1CK8np5x3+5F/O9TrJqRfgC8j
	jI/uB+T
X-Received: by 2002:a05:620a:5dc4:b0:8c7:139a:bf66 with SMTP id af79cd13be357-8c7139ac6dfmr250534485a.50.1769610108659;
        Wed, 28 Jan 2026 06:21:48 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d49c2bsm186932285a.46.2026.01.28.06.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 06:21:47 -0800 (PST)
Date: Wed, 28 Jan 2026 09:21:45 -0500
From: Gregory Price <gourry@gourry.net>
To: Michal Hocko <mhocko@suse.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, bingjiao@google.com
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aXobeWtnJVrTmxlV@gourry-fedora-PF4VCD3F>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-4-akinobu.mita@gmail.com>
 <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
 <CAC5umyhoMi_J_Ford2M_1fB-qCuPEDopAK1OF=AisZyDZ8duJQ@mail.gmail.com>
 <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
 <aXndXPMFK2fhLA4p@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXndXPMFK2fhLA4p@tiehlicka>
X-Stat-Signature: q8a1chf5cffyn9xcdbancqo4gf36dazn
X-Rspamd-Queue-Id: BC2DD4000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769610109-87931
X-HE-Meta: U2FsdGVkX1/7EjJ4zBmfUCuLcAvlgqi+WOQer5y67ZC84XyfIqPNTl+xHvFX47Yjh97BGU+8n7pDivhbvSpB9ZUlQ3wjj/OLtLJoZ3vgHGrfb96qLxbjFCfUKK99Lhj5C9hu/w1u1JZf908O0EvEXqzINGZPoirZIlnNP7InMhZhTC0ShRVghsaoL1i/K/zuVsFYzMgUywBhJy+s+O2z28ATEsPyVCv+v+Sy7mF8KMhxAUUtPJw5vYwLQS8XOZc+XC+ntxNGtu1Dm+f+vpbDGDFw6p5SWqu8pMmwG6PKNT3p+1dSN6MGwUI35riB0YcN1mcPqAkGUd21CY+sxw9zG+GIOUbSSpEqCKYY0g17FnqrE0jLHZbL8P8Eo4izUHZCpFuGYQZSIzEohl9AexxBXchs1njdTJ0SDS0pLS72JLJsIxyfuRI0F4k9gQU4wzFvdcPZisEhd2Mj/N8WCh0//elwph0z5rINFDtAEVCMDvGf53u7P85Me5ATFLaw+XsWfM3FMUS19tmq1bgVRJvLCnNE5yJ1GVt3TD1O2vmWMHOr3tvu935J4nqk93jI1dZFe4P3n5eSOaQPVerRrtxDcta7evMAtIo9ItffThaq4D/UUA4cy41CrHw8UiRv66loKEQ7yoUzqiY0CrABBtSAZAsrCraPlWVvO2gp8TizizzKbbIfleBAVww2Nk2wWAl/wjUuNPhSt0EGtusR8tIMfBuOi+hQ1TIXtAuzR1ImuhG7xwqmc4DNzBUnuklxjevSXwr8HStsKo4EEpXxx9r2UGdPjil9ThGoENvhdt9dBSCMetowrbl1dfrVYuePrUh4A13PK95IMGaMvMs8TSVbDhmoiAldqhxSiK4HtP8+bqwhtv1Smsvgk2u48fed9HmlEvfDQAR2n1YSl1mjWMCl9Y7NZqH4I79y9S/e5s/v/uWX930lM+YdaHibQC3pwPW207ucuLqV9MHobclze7J
 icOjNvbv
 c3PsBuvB7prmDW/BhbNI7VRRTa5OSCZsvzJ28hby/h31Z0n/d1MDUW11o6XdMA9gWGEe197tgC4YPA3s0i9IB1webCMJ3dXnqeBj8QMZNtahu31ErpKrR9Gz8MAo7KMWi2vYsbBamIAn92DMVMcna20/NZlxgY8J/HCu3+QuADhREYBEn0pdOVlGUY1nz4wc+xCtkQfnr693DEjck/3Q414UmJdR2e58qcoiVVCp6vOg4rhQfj8VFroxxH2AxVGjHJnAdVGkLBeDljrg+vPXA/GRp0Gg3P6lzHZD6kKRv7pLgL2BrUqnHNdxkdxxRuVzU7vgfPgPjkjwn8oXZRz8HxmN/GODYJFFMBVvI601D8X8g1Ub8nV5/eNSIwJg5ik/3waBmHNou5gm1JZOeYvwXIuyEFT07hOSJFDF7MnPFHLwE4Nbo8dBtNO+8foldorUakUBLtOU64LLNrII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 10:56:44AM +0100, Michal Hocko wrote:
> >                 .gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
> >                         __GFP_NOMEMALLOC | GFP_NOWAIT,
> >         };
> 
> This will trigger kswapd so there will be background reclaim demoting
> from those lower tiers.
> 

given the node is full kswapd will be running, but the above line masks
~__GFP_RECLAIM so it's not supposed to trigger either reclaim path.

> > Any chance you are using hugetlb on this system?  This looks like a
> > clear bug, but it may not be what you're experiencing.
> 
> Hugetlb pages are not sitting on LRU lists so they are not participating
> in the demotion.
> 

I noted in the v4 thread (responded there too) this was the case.
https://lore.kernel.org/linux-mm/aXksUiwYGwad5JvC@gourry-fedora-PF4VCD3F/

But since then we found another path through this code that adds
reclaim back on as well - and i wouldn't be surprised to find more.

the bigger issue is that this fix can cause inversions in transient
pressure situations - and in fact the current code will cause inversions
instead of waiting for reclaim to clear out lower nodes.

The reality is this code probably needs a proper look and detangling.

This has been on my back-burner for a while - i've wanted to sink the 
actual demotion code into memory-tiers.c and provide something like:

... mt_demote_folios(src_nid, folio_list)
{
	/* apply some demotion policy here */
}

~Gregory

