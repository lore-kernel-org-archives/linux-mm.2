Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DF0CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8396B0099; Tue,  9 Jun 2026 11:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0226B0098; Tue,  9 Jun 2026 11:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DCF26B0099; Tue,  9 Jun 2026 11:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFBF6B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:12:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14319120686
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:35 +0000 (UTC)
X-FDA: 84860715870.11.CEF49AF
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3F3208000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="dT/Yiqaf";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781017953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSHte4tw4Fe/hwOe0BydbVQDJ1bfJM9PJbtvHiFr8Bw=;
	b=cXFIR11sgt6BUtjDiEgptqDZ3OXmX8A8tm3Flr6E4Wbx2nEScD3tkiQBO/cPfSWyTd53KG
	j8a+rOtAZT/DvoaeM5yc7OGgQI9y2qsXtv5/DofsrZ0vTrPVSlF/O1CkueA25qcQHenC8J
	IbiG7r4HVpqZIn57Bar6oLK2BugzxeM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="dT/Yiqaf";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781017953;
	b=d/al9n9D68cM+N/yWBPXQ6yc0juAPim0r2MHXGOWRw1nXnU0XflXyS+l1gddG4r2yo8K4j
	HIiUa2TO7bG25xCOtq3jjiBLpLKc0CkRuS5TF15SitqL7nsYTcB0UOINn9lVS8ljL66sKY
	RwDdyVyaJZMiEKDWFhNccdZx4oWSZ7g=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-91550dda53cso671032385a.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781017952; x=1781622752; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PSHte4tw4Fe/hwOe0BydbVQDJ1bfJM9PJbtvHiFr8Bw=;
        b=dT/YiqaftXUI/AjJFKZhM8+f247cmuSzwh5JGyzcaHCmNYFGpF0x4EM9N68leU1Qr8
         9tWJBzX8tZVsPJiMWqX/ap7fbpVl2J4qw3RVuxarcVbCZSErBci6DUBEk8Sm+r3xE/6Y
         b+d9zJ2/EcJdSeD3thGWwdDhKO8ws3mGKodvCHTlpSweWoaGsh3cqzFFNhX8eyOOmWLk
         5hsE8/sIEwWJiEemaL4sG0l3FPKDyWVRi1F5ti3JjOmwyPX+ZmiyCaYG62GxVVuz0/ua
         z1+fGySkPFxyq6D2DWjbI7Gw06uSDvGc93HPzCkKA2YdT18awea7EWCQWgV49qpP3+e+
         rGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781017952; x=1781622752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PSHte4tw4Fe/hwOe0BydbVQDJ1bfJM9PJbtvHiFr8Bw=;
        b=rIwsdw3wRV5Sea/mcKDli3sjpOVxvvhUSK4qQJAhLzWf7k3YNKLNC1skneTLXOq/iV
         3A8NjNgRk8AiiKuUWkpbvwBR0VaHoFoXbp6CSd2W0drFPCB2MfTfnA/6SUAlBML8XGlF
         2vyc7XUrjC59oG36AGXo63+ZTTh/SoEM1NMu200pZGLog6O13hXnh1n/SY/tpfSroKQv
         lcmEqPCsdfxSMiWDcFbmT39kxhCx/xFO15w1mIOC5SeCV9TGBL28yeCxOnboHHTOJ0Eb
         YHIHVqz6ecWDARN5a21ilQuUbaVQY626cfmNmEHT/KBwxf6YbT5sy/3OfSqEfcnFmDQp
         QYdQ==
X-Gm-Message-State: AOJu0YwrJH5lmpW1YCvQzYkdDWYqbCwKf84H6sJ4wVO17e9qqYy65ogo
	9sMrfKuKd7g5WX1hF9s60GTjeAOxZAtoCujVHOAg3WB418IRJbHeTaRkq+HJY9F1dIM=
X-Gm-Gg: Acq92OElwKAMxE2pWTNxhtuJ6PH21jwI3DWeuWYLjgc0R02VzDgI1A/wT1l9aPG1jEM
	RPYS+0rgcCJ0rxY0LfeWPmnYg8TRKnDHMeP58aWEBTK0AhcBr4FhdOjOSKwdGD4Sk8lRgjoqdYC
	lErx64ALMQFSrQ1J43GVaHESBiNOC5qS2CjGbbgcD5Z7q1RFsztW/dYcEqOMaaMCSgxYTmo8exd
	GwsINxnUnuheyFAY7O/s54VywF+O626T2OaVO746cqc6rQBNdr97af84TRXjQTpafVLh7sA4Dwe
	zQlDcShvr1ASiHoibKscKp8WW/ZNo0rL5OV55j2CZ4wZNitrLh21HnfbyFq0k2NoroIqXuKR0gr
	MIXj1/a+SoJNXOju0KQjttmmB21RxIa6OB7wROEJo35E/+r7vmM0z1oht3y2FMdx+ejsNUb78iO
	xfUgth/yGPAZglhfJMphyfhOSnr0sWej2gD770jNT2QyXcQEAqBO94Pv7iIgYy6XdT/9IhWyiXJ
	zjFkUG6ufNCaul3bg==
X-Received: by 2002:a05:620a:2587:b0:915:9c4b:fdae with SMTP id af79cd13be357-915a9cb2d33mr3324652285a.21.1781017952150;
        Tue, 09 Jun 2026 08:12:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a411333sm2261055685a.46.2026.06.09.08.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:12:31 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:12:29 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
	alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com, apopple@nvidia.com
Subject: Re: [PATCH v4 4/9] mm/memory_hotplug: add
 __add_memory_driver_managed() with online_type arg
Message-ID: <aigtXQsFhJ4SB39t@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-5-gourry@gourry.net>
 <9361f783-5af4-4380-a901-8d330370491a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9361f783-5af4-4380-a901-8d330370491a@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F3208000F
X-Stat-Signature: wkxuer1fz9ajt89fn1x38utioqh398zy
X-Rspam-User: 
X-HE-Tag: 1781017953-521104
X-HE-Meta: U2FsdGVkX1+k2/iXZfyEZsSA5cKeu8tWQs6vlWlRwcXcO/UzjmAe4hWwY4G9jVevDhnAMFIdoKu0qmT3Xu4X/w26LMYb1x10+Wwp2+EzGipjMNci+InxdWTWkX4jhGCIvrFaW073gAp3FId7KeOlHiSDnpWec/HcxWWAYZCtV7TmnyZIce5DxBeU1Tcl+AM/EZyaeIftRFEukBZJuss7wfb3X59Vjc8YQEIHGpZzt61vd0dZI0womYobMevpo19NdINEuCAZ6mJHX35z9QH0vsepPXIohZMRijdvex6wACQ7DqD81RpNbl7HXs0VQM3SQmdL0ZhnY7URxx73zBKnj+4oeByzZ8py0brWLkhj5/Ssc1qFS3qQrFhc/4aNifrblIta55rKT0NX6jai12NtBmlWBLM6cpEy+OM3mn4hCkDvcQdB6VAp9gzSKLhR1n9m1tCuWPmhr1mclsRygvDlZquhLVAIltSOuFD1q/gtkeZB7rLohyNbftq7FYlLsgmg/+54IyNJAcVsd50WzAL5L+p0nHd+dKdqKITajIbz/qDCN2Hg9XJNZcQGDPspexapIwWEhIWy5HAgz97a3+Yoom8WqbFHzORkUfq237V27aEaR6AbqoNGHRlUTS+pzHvEA7pUfxMxUlj9osRCss3bgWx+Ojw/OHxdHRwhhUKBym3mHyWwRUAKqQX2+tn1ZvhiKSdq2rBqkqvZS2+YYk++o3hruFcei7tMIcQ/GXaPkEN4yvx8ziehHmBPoEstCOXxriLU+jaZZf2CkB0MDrM4eCjcL2ksAXAKb5YYReXPHEgn2ZSVT71BEAKGVL9xTa/BJtIqS+vMjOE1Umhf/MnwwQiVUiPvnVK5RtfoRWTsOFrq226MDf6bcRKz7393c7I/PIteKE9NKRuNi+JXErXPeByyxDCPYeNpFhdTQ2EvW+s/PeJZ0A3REgFfytHbYv2f0pyVbrBQbA1Yji+rb0W
 06Yjqo5a
 PpUx68hyAP5DZcFpCPfn+PdTj9ICT0F+67N4csJLlmBUJpfDWbJjTZH+I0HjV9IwiwlsX5klozV5nY73Dp+AS4UVbG5VhdFbWj2p7b8v58vZ6Pd2RDy8RonQXwA078sZSYvuZRGvz4yOfMSrTiyZ4Hymffayi9qZvaoAcVAB6tB+7jPte8HPPDOjtZJIrgqfjxBFzrWGIaeRyZCI7EqyPIvGovK+/3mN7TWXkdUiYY+1oHO1EBREvS5w8WAN2kZq0IZLB8PLtMWCIVtkBofIvg5RJIJ5pKQQuqz5nmn7ANBYBmpFlkpcrbWFkox2oS2rIHk06vSSqoQLK9mxFoboHQJOBEpi2QHxg3po798r9lqAqfMzw/xcINXE4tqXuPEzGkD3w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 11:55:24AM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 23:19, Gregory Price wrote:
> > 
> > diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> > index f059025f8f8b..d3edeb80aadb 100644
> > --- a/include/linux/memory_hotplug.h
> > +++ b/include/linux/memory_hotplug.h
> > @@ -294,6 +294,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
> >  extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
> >  extern int add_memory_resource(int nid, struct resource *resource,
> >  			       mhp_t mhp_flags);
> > +int __add_memory_driver_managed(int nid, u64 start, u64 size,
> > +				const char *resource_name, mhp_t mhp_flags,
> > +				enum mmop online_type);
> 
> We prefer two-tab indent on second parameter line while touching code / adding
> new code.
> 
> Same applies to the other instances below.
> 

Will fix on next spin, thanks!

> 
> Apart from that (still) LGTM.
> 
> -- 
> Cheers,
> 
> David

