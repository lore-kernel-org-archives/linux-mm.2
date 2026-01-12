Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EDEC9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8CE66B0089; Mon, 12 Jan 2026 10:26:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40116B009B; Mon, 12 Jan 2026 10:26:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D776B009E; Mon, 12 Jan 2026 10:26:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9474A6B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:26:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2942EC1F5B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:26:22 +0000 (UTC)
X-FDA: 84323688204.16.5DB6C7C
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	by imf22.hostedemail.com (Postfix) with ESMTP id 47536C0009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:26:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=B6HmmAeI;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.194 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231580; a=rsa-sha256;
	cv=none;
	b=t1fqWciizVQ5SnLg8jl49vwPycx2RvmVFNZU/P/nT1wmqsMBbtvcYwXqOUrJeIn1cjuHwJ
	zaoe/VaLcTCwvnDxEKWQMpJsn7/jAm2krax0Co+t8M2I6H5A9T/B3nvATQa7lmYPJfT6NR
	slGk6hTMXm895948m5FWPJIgn1oJcwU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=B6HmmAeI;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.194 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57UuhljdncFCr/JytocOWEZRWmlPR6Nv3ccaWVm2VXI=;
	b=ptVxWKvw4/Fwltdirv80Kwaa7X5yQmVIrI6CLlJ2kdrI7WDpm0nzFy+U8k7kEaCLetrm0l
	P6Dg8LD/R6IlfI/UA3CDBGDN+Lcl1++AbhwLJV5f5x8Ku8nek0VPRKs+K87+r96Pb/r/pT
	SGGPDoZA1CU7M+R+ywfXYLFTVgHkQtU=
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-8b2d32b9777so985263185a.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768231579; x=1768836379; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=57UuhljdncFCr/JytocOWEZRWmlPR6Nv3ccaWVm2VXI=;
        b=B6HmmAeIgmaj1K+5krKHU8oSudXsJgf5i67y85fJdOL8KLRqlf1ratrnhjNCha0jsn
         g42xoY3a06bEvAI8zLV+5OfMvKdfrF/Ja7JeEzGRuByd3PgFzncm8R73ZF0xwPufSKPD
         xrCYK9IgrbwYyQnnuxMBMhxtjClEqq+Hp8Ki/Z1v00BlTlHkQJroBd6LeeytDppF7qPx
         0HSNAGZMaZJVs9JqZdAUZlJ+esL7WgZ0n4qRtBXAcciJVXQvkZJK6oroKm5Jr/rT/m9O
         +5Z7IR8Ww3+Jlj434TiDF9DtaH1sAdEkwNsxXlf4LHPZoeO4tqeKL0mw6DymL0Avooc4
         YzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768231579; x=1768836379;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57UuhljdncFCr/JytocOWEZRWmlPR6Nv3ccaWVm2VXI=;
        b=MUAutLnSFtOsXe46R0NZyTbnaLC0wOIOqEsxgB4USZTe6hUxQ+BSkBYKiLY1b4O+LE
         smSo21tpiGehL7CnvEZxAWlM83NPdDa/1QLiYE8F8rEZRSsVswUn4ul/uE4IOTtnO6+7
         66QpTkLTuCFgHWB9ISqZug9dTLpWjUqyxBopmSeSQhMy8HRoroJu06fMyTUUnm9terU0
         Y5SOywOnwn8Mr+0ieCsYhnydKx8fqA/HaMzecRnoR2d+NisW9A/25HTOHRyHbDbAw7ZM
         6Xzf2Tq88sWXuzvJJY+1JRQWtzcCf5UrttO7jVhXOMWIENz+hG8LydKEkv2bFRdBiyVE
         QD3w==
X-Gm-Message-State: AOJu0YwW1jD14PEm42mUwbvrfLyWZ7QDD/9Hwrzn8MNWB60lOEpZuV8x
	lHUqdcMtvnC+XK9aWt6sTJcMwv+HcVJzVAFxvQ2MCmNKn/nHu3FL5ue+yUzmGPri7Oc=
X-Gm-Gg: AY/fxX7bjcJscSAkrG/krrI0wJAGN7NuooT44MNN/h6QwRtouVEzR0SONE9kjd0V5b+
	xMNxQOIearZExyePCKga5S3zUR7Nbx7eiln5vxiGceM8Yv2+ALR6h+0fVR8Jb2+m1gb33XcEv7P
	lhLNzdB8CQPA3ZNcpeinaVkctP+2+7rrtMNYrSx8LRHbgFqr73BdMOefim7zMqfAg7mtT+Lo7s8
	bWsWjza4YlEd7g4ew1djn/rjRM4JVRp3GHOhW4hIngTE4Y5xflEsL8QnZqnVh+LQDxTjuY4tdVl
	Hd92hCa6JjmESbu9dGD3kEqF5tA/sjrXucnBDtmzU9xDth/xX/DZOFBPFEf1zPX3TDXfrs+2OlZ
	7xzTzWa1n5mPTcEHCqf80pz1dd+HNJhVf+FlgaTwkM/Jxq777KkMm9hOxmXfc/a378KWQJrIAJB
	Xw2ckNfk7nmZRIcvFddstS1RamXQ8Xe/i+NCWf4aBtvr1b7ZW8+iaMwqG61TRIFKH2jngHUTgEm
	vnSHlLN
X-Google-Smtp-Source: AGHT+IF7YU4wyH5DCnIa1xHNwfOTUxRN3Z3UmWPqqY8/JzoeuGL9L4VducxuPGVH8SICTsnA4+h6Uw==
X-Received: by 2002:a05:620a:318a:b0:8b4:ebbe:ae04 with SMTP id af79cd13be357-8c3893a5c0bmr2745515485a.35.1768231579175;
        Mon, 12 Jan 2026 07:26:19 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f5439cbsm1508794985a.55.2026.01.12.07.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 07:26:18 -0800 (PST)
Date: Mon, 12 Jan 2026 10:25:44 -0500
From: Gregory Price <gourry@gourry.net>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	corbet@lwn.net, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	ziy@nvidia.com, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 5/8] Documentation/admin-guide/cgroups: update
 docs for mems_allowed
Message-ID: <aWUSeFzxouq2vwg8@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-6-gourry@gourry.net>
 <o6eky3g4jyvtc2cy6lk7rjc6or6tcvwbhdarrlpn4geuibvrul@65fygkf6vg44>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <o6eky3g4jyvtc2cy6lk7rjc6or6tcvwbhdarrlpn4geuibvrul@65fygkf6vg44>
X-Rspam-User: 
X-Stat-Signature: h6mh7ce6uakpywpszj1xwuqni6pqxkuk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47536C0009
X-HE-Tag: 1768231580-394053
X-HE-Meta: U2FsdGVkX194PsG25SQw2lpEHQTlTKOJ1LctB4MaNNRdUwkvC7HD6g7Q716AT4izKX+J5Tio/VUC8XMWXLpl3TMrxDXDDbVcvDdpt6RtnI1jrDXoIb4qUD83UMWKVXjGeG1LFcnKSf9jpiFlgHynvpShecK1HrmpRxxnFDadkUAga0TpDCDRByU+NglVKPr/me8FSAEt3boiiGJMZrcz2E1Rkgngt0fEoRHGYLd35lkRf5HKDRzRnNUiiPSauUyq1LNthoRSdT0y8ABh2vZx5PGgigkOl58rRpfGuHptkPJJ3DMoxbTzzitgfigOJbpe19jYkn38ViLzG4avpUHYEgqDA/hVClBK5mYJq5CJVLrxXhci6f5yVYJ2CLIyfu2k5InN0rcmkriyYMz374jW2Q7N/vUUEDGayFHIFwHus9yAcEQtQKr5GvCW1z+/TAYt3kUibCKmitRcl/1ZsbqJ2cKLlTZXd+Wwk/SGbpULKDwlI5FGSTeZBC4JR8a+MvZP8KH01Tefv90fxry1jqzuT+GkcIRj8yoJqDKw1jVRc9UAj4nYEhiR1Rw+Q62GuInWw2cpWHTe6pLMhaHTK+4ObLlReYjF1TH52kj1cZ7E0HE4wKK8cWaxZ0m5OfGJAtku3hqZ4LcEVa2iYC47u3nfcbN/gZqzZ8dRKKIjNc2qVfQADRHNkLXe4n8Y859R2EHrwRvm1YK8+nchcuTm2W+PMLxB+oXxDeI/h0CK98HLvTwf3SG8IpZAee6A2stlA2vVJl7aepgOjjTM/7Eq3ZUukUvKUUNIfHUDuqJLhMSnu94TEQmzHIO/nAh3hXawqtEvk4lrYuJtDe5v6xok58UTFAXpNv6puhpZCcDqemzN7hgwIdWzMWwpTlF8sWzEW2FJP/o+7bOQpxva1FAMezXN0U+UbXX4yKCiML6SaYZH668eUKbA0VAxIoWS94T35TXjQAijiUld8kcnWCJG7cy
 4HapmISh
 Yx+KnyiFNGmt3l7hqbkBunIJNntLt2FBTC3TtCiKSdzggFZ4y/JMB9WiRTHQ9pNR06FnVgjqUKA2+aQWWRh6fibzMFzcb6zo+5uo/mh7GybrYwfxjwqzOERUaSvmnRsti7de25Mm09QfxfDJEfsOt3UbneDfxh1aKgdlAZk7SBrIi8L4aayujG6O8Hkab0cbOCj0z2Dsj6jY51/dxlYghWSQSzRN7IYdfDtyI9UkhWy//cDziuPfOl44170igUMMKZrYkjUzoNrTcFMSphTCZc9p+iAALsN7tDjGKyRSjRCIrFbtJqa+98HWeXp+2CAk+qdZb82YSSKQADpeMGELk3gR5O3YfnpnEMiWEredm/U+c9KWTbi0lywUL/ug5A0XEh2W7V8mgZJH6vKLqlhv61JAEFJsvqs+dequqntJ2cAoXJT9kNP5jttOJ0H/4W5PIrTskJX8j7WHQArYlnNyWMcOe4mrwwVjI3OAJujyMB4AApjZVJZ1xWsoaBBKDQ0/T3ndKmXnqVgW0+r95JucTB10s5Nq1PP5xr13UX3fyXbPjEPU289V1Nkf6PCCIuafFbrGipunNf76lPHIZQM+OyacBq/vbaOe8kCkhEGcMgRs53rgHw2l+0qoiUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 03:30:26PM +0100, Michal Koutný wrote:
> Hello.
> 
> On Thu, Jan 08, 2026 at 03:37:52PM -0500, Gregory Price <gourry@gourry.net> wrote:
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -2530,8 +2530,11 @@ Cpuset Interface Files
> >  	cpuset-enabled cgroups.
> >  
> >  	It lists the onlined memory nodes that are actually granted to
> > -	this cgroup by its parent. These memory nodes are allowed to
> > -	be used by tasks within the current cgroup.
> > +	this cgroup by its parent.  This includes both regular SystemRAM
> > +	nodes (N_MEMORY) and Private Nodes (N_PRIVATE) that provide
> > +	device-specific memory not intended for general consumption.
> > +	Tasks within this cgroup may access Private Nodes using explicit
> > +	__GFP_THISNODE allocations if the node is in this mask.
> 
> Notice that these files are exposed for userspace. Hence I'm not sure
> they'd be able to ask for allocations like this (or even need to know
> about this implementation detail).
>

Fair, I can drop this, the intent is actually to limit user-space
knowledge of this at all.

> >  
> >  	If "cpuset.mems" is empty, it shows all the memory nodes from the
> >  	parent cgroup that will be available to be used by this cgroup.
> > @@ -2541,6 +2544,25 @@ Cpuset Interface Files
> >  
> >  	Its value will be affected by memory nodes hotplug events.
> >  
> > +  cpuset.mems.sysram
> > +	A read-only multiple values file which exists on all
> > +	cpuset-enabled cgroups.
> > +
> > +	It lists the SystemRAM nodes (N_MEMORY) that are available for
> > +	general memory allocation by tasks within this cgroup.  This is
> > +	a subset of "cpuset.mems.effective" that excludes Private Nodes.
> > +
> > +	Normal page allocations are restricted to nodes in this mask.
> > +	The kernel page allocator, slab allocator, and compaction only
> > +	consider SystemRAM nodes when allocating memory for tasks.
> > +
> > +	Private Nodes are excluded from this mask because their memory
> > +	is managed by device drivers for specific purposes (e.g., CXL
> > +	compressed memory, accelerator memory) and should not be used
> > +	for general allocations.
> 
> So I wonder whether the N_PRIVATE nodes should be included in
> cpuset.mems[.effective] at all.

I think it makes the control path easier (both more intuitive and easier
to write in the cpuset code), but I can take another look at this.

Although omitting them from .effective i think prevents the user from
controlling whether their memory ends up on that node. 

i.e. the user might be aware that they have compressed memory on node N,
and they have a cgroup that they don't want on node N - not having it
included in mems.allowed / mems.effective means they can't control this.

> (It resembles CPU isolation to me a bit ~ cpuset.cpus.isolated.)
> Maybe you only want to expose it on the root cpuset cg and inverted like
> cpuset.mems.private?
>

Hm, I had not considered adding the separate mask for .private as
opposed to sysram.

If all we actually need to change is the allowed() callback to check an
additional nodemask, that might end up cleaner.

Thank you, I'll take another look at this piece.

~Gregory

