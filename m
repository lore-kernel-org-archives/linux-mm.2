Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA36D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C9E6B0028; Mon, 15 Dec 2025 07:40:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C133F6B002A; Mon, 15 Dec 2025 07:40:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29E46B002B; Mon, 15 Dec 2025 07:40:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A158E6B0028
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:40:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3568556612
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:40:19 +0000 (UTC)
X-FDA: 84221663358.11.58BC629
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 55DCB20011
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:40:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BlNZVG7E;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.214.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765802417; a=rsa-sha256;
	cv=none;
	b=ZU1dNSxY/IOS/3cBpQ1EYuJQZKLc1LIi4T9o3bM/I7FySCaPTgjd7FkMMJTET+oAL9Vp8A
	zMS/h0S1wSt+6NGKF8hisNOh6/4I5WbYgKluAafHDr55CmuihO3sGpEU5SnhsA9Tc6jTi4
	FYHdrjJZs/KcdRvwXFkngUvvPH9xG98=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BlNZVG7E;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.214.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765802417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQ+e85/bUCohfI0SHpL3374mINgtvuKmw5p+42PCaQ0=;
	b=e6hK8BKGCK1L2+hEMN1Oe6IPmK7zZQ5M0sZFYHAJgG/EfCBffLbRdzekXlJBej6AEyr9l8
	fkciDWkVSJRvMjwMyUGuJk+SfvidRuRnN7Mrmwor/RdVGYUlUSNKe/c7NVEDfFWpIkHGsP
	UV7pVqLBxbGLRjLzHZ/susERAJkSecg=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29f102b013fso40780085ad.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1765802416; x=1766407216; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XQ+e85/bUCohfI0SHpL3374mINgtvuKmw5p+42PCaQ0=;
        b=BlNZVG7EyDcTtnXsjOTz1TSEuPp+IoVI7DuKg9Zu51uKdrjpC7Ku2Rco4CNyEVsMAE
         8YL1a4Po9tYwzZw+7KIbhyRqwnHqaJXFjObJhA/U9ffFKXcnabv2VDSxQ8WeNWNMEiCL
         /BDyj59a5NXxpX0RgcrcK8hCdEz+LIXxKGQz6w/lcFH2xQ3wBHVyY+sj0eQZ2kvuV75A
         zFyFiwX9DbTmHnCAcAfQNiHlY8MDws6U6LNMnQICREwrRfsU55lldCvTkwrkhE+wuz7Z
         gVQ8kFUqPrBpepW9OSge+sAe9y2wtWr2ECWuTyJ6/s+0VyOpxHL6k+tZjitR8dmVq3cq
         sJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765802416; x=1766407216;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQ+e85/bUCohfI0SHpL3374mINgtvuKmw5p+42PCaQ0=;
        b=qFBTVc9QhARr/kPVYkuQSKGwRpgd/v9StaMQdWgReXjLFaNZYSdzu0Kyezfnwo9BQd
         M2h0K2hp1ZnZc/H5sMCehOGAwfcPgU3KzfA++j2+QBoAf0JoprQHvpZ1JTRBRRgRs2Tv
         5njXOhvC64G/J5hvUV6SgsrQt6FcFMa/cZHBp7YkGXy83i4r5CXOQavUpmZKObFofvIq
         iFMj+sQbv3Uofo++Ujy7c+hBPG+zmr0/u4ZPuOvLzosyEFQhktje2hiHqS26P53WC8Vz
         ZhQYtvBOP9BXwJzleH3pUhhwcXoRjH29LQdVYKTr414Z9VBJLC3C83PdLcg+TqrkgNKt
         hOOw==
X-Gm-Message-State: AOJu0YwOt/sHXbCJSku8HTX2xi2c3QQLbHhZF/dq7LYiTLn7Wk8cFF/J
	bciygvNkwS1VaPGs3vGi35iQaT6ut14UbZKPYrsI43osYYm1l1Gtale3iI0VYiqKMck=
X-Gm-Gg: AY/fxX4qjISzyfRqFFFaMZU2Ez4XKSEp6qSZSAc3yqQWm94z9r/zGHNJZ2RxxF5PtJf
	Ddej3i9elDKlGM0HEbCBrpmeBAI96gDQ8vn9CheYNApXY8ad7FsGnrvoGPu58Q/g8EqdGJU31oh
	evCB/czQ50kFa9dr22kY4LXEc9/+EeWcyu18c2tCijlYi5NXkAX0WjzV99CtfuO4ptSt7m2WFIA
	NqVENM0mkaLWk0+C/4FrdpgS9pbgOdiuBsC1uTp7/1P9sb30DfYAM8qq4yqWz9OD0KoWr75wySP
	vtNgpxN3lUOSL/vmxpUyiT/HBDueEBPIfO2htyYrbI39zAeDgt5fKG6xBvQnLyMq98SOO3Hfz0i
	rmXooTRd3zi5d/TADhGFcKwpUOYy8Iz5ZA7/rxsNYMjIsAhUMt+XknJrl0ArbJv+Rutnl3Doe+W
	v3+JsoeCzjEVMxd5teK4dY69sjaS7HbA==
X-Google-Smtp-Source: AGHT+IGs9Ux4WT36PFE81Ye+THAzlPoeoI649XuOQnWr/+KqI/OdcXZ3NL6DeXTGnqp6jXKC8WolKA==
X-Received: by 2002:a05:701a:c965:b0:11a:2f10:fa46 with SMTP id a92af1059eb24-11f3484e8cemr6230501c88.0.1765802416021;
        Mon, 15 Dec 2025 04:40:16 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F ([205.220.129.38])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f446460c8sm8475705c88.10.2025.12.15.04.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 04:40:15 -0800 (PST)
Date: Mon, 15 Dec 2025 05:38:47 -0700
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
Subject: Re: [RFC PATCH v2 02/11] mm: change callers of __cpuset_zone_allowed
 to cpuset_zone_allowed
Message-ID: <aUABV3sQyaTksz54@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <20251112192936.2574429-3-gourry@gourry.net>
 <dda1fab7-5cb9-4d83-8b60-f4ed75a03aa8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dda1fab7-5cb9-4d83-8b60-f4ed75a03aa8@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 55DCB20011
X-Stat-Signature: 4mkckkn5qyfadzufy1j3ahjuqeg16pju
X-HE-Tag: 1765802417-545938
X-HE-Meta: U2FsdGVkX1+Mpdzt/pkALuf3TP/ERwXMaRBqqwmaFUqLNh2jfYvuDY/VhfKHVZy2PiagkmPjNbwCoxZvfo0vSPPZ0rk3/SQJS72YEFLmvS2iGg4086xTlC8g4RMLrQXvL3kHG2sI4NfMI5KDLSDg5cV4Tyl/dLIKYERPn91I0jah/a+KJqPKUHXQnYHQF2W0ejOBO0Vlzn4ExBJKFhw1RsRIPAA5OyJNPdjhuQL6ZJRKdDLRl29dz5RcUUo1Oay4KQ2+IOToD42mu+au3C6RgKCnTvTPxn/i2g6ZS4mqESzJsnjjcU33kfUkRKwL5PL/vIkdC2KE8l4OAu5kbLcxGhJ4l49FDxkrrbbsFRRwQqq3StmggOqvn4SkOAWWkFU8cXuETVF5M72YEGA1vXJzK4hB2zhnXoAgA6wVeox+Lwx9fPJ4S3F9q1qI2/q11knj+256WiFXK3L3xXvPafIbzAQ8S9eX8aOducDGuoQ1IACBKKCEP1ajOryNAemZ22lZKmczM76da8beV5JVEe7SDwuMJq6CZKzfELEe1XQYsxhMLKedoJNv/UZWKbmFtVe5eITbfoWQ0Cmasb4gCqNJZC4E0Oue5eBkRWonYk9szhwmx2k6ajf6/CR/ZFGYYF6bbN1Rv0xqyB0y+A/Hbp7M17YMeNDUvGRinRHqMPW3yQVlQucs1+wlQq+T+3LtdPme4NddAN+x8B7G+T2eQDcPdXKdK/L1/kiq83hXuw0sCdVMRSgT4GzTeMe8DBmt+yrijVRbF7Q48vN2BR0+UzIcVd/nyshTFEXhsUblpnKgajaidOiIMb9MhsmDF8wTY5AsR+yFvBp3WbVxDdJZBxmzjmFB8r2Q9UaseIGbXq2ugCalNK1kFsmLz+ZdnoSQu87sA79RVBuwmJWJiQjW8NGNtpDh3Lky2aHwBW2H4iFpoksIiarcNEihKxW8obRm21VywSXTqhOftVWFTf3ceGH
 1JKxBcgw
 t8O23WrB1mmkCDtmvRw3XGKsbOwXIDK1jDMnUghS/u96w+vv9W877dVmoZHSiD0+NLAvdscXnCt73c/hqcBrYp5bmwdB6w9woy8M1GxlIDkNVV7WqvKI/5wAE+ABqpXbBRrgFjvLp4jJ4lKGVVzetkUFcpJ3W1dpNmxRZq9y6Wv9V1VrZZ6vYYW0tiqRyllKaH+aJCfK5hHRv1uAg651IZwmGczb8uAXFxWn3sAylliGlhbhqpFEeG3PYZ4eVyyspnghDysFmfuImmHzOZui+TGBVlACkSNRZVPDdoXEV7BzIi7G3F49lyo2yoZOqWD7NBUp2VMLWj7JyC4gSnCuo3Wj1OvdELXgl9Zkd4u4MZwZjwsBtfD5bg32glYhSjgbwUPkSdwyVBJfR02VjC/04gfIAHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 05:14:07PM +1100, Balbir Singh wrote:
> On 11/13/25 06:29, Gregory Price wrote:
> > @@ -2829,10 +2829,9 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
> >  					ac->highest_zoneidx, ac->nodemask) {
> >  		enum compact_result status;
> >  
> > -		if (cpusets_enabled() &&
> > -			(alloc_flags & ALLOC_CPUSET) &&
> > -			!__cpuset_zone_allowed(zone, gfp_mask))
> > -				continue;
> > +		if ((alloc_flags & ALLOC_CPUSET) &&
> > +		    !cpuset_zone_allowed(zone, gfp_mask))
> > +			continue;
> >  
> 
> Shouldn't this become one inline helper -- alloc_flags and cpuset_zone_allowed.
>

I actually went back and took a look at this code and I think there was
a corner case I missed by re-ordering cpusets_enabled and ALLOC_CPUSET
when the GFP flag was added.

I will take another look here and see if it can't be fully abstracted
into a helper, but i remember thinking to myself "Damn, i have to open
code this to deal with the cpusets_disabled case".

Will double check on next version.

> Balbir
> <snip>

