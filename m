Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F9DCFC50A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 21:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B173E6B0032; Fri, 21 Nov 2025 16:07:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEF56B0062; Fri, 21 Nov 2025 16:07:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04486B0092; Fri, 21 Nov 2025 16:07:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D36C6B0032
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:07:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 470DB567FA
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:07:50 +0000 (UTC)
X-FDA: 84135851100.30.364966E
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 632FD4000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:07:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ien0LKWy;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763759268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Svi+I8ywJ8k5uxtzxqjpEGX4Qh9Fr5IeUT/6ziPIoB4=;
	b=oNxmDz7ICbf2EFDQ+UWR15NOQmSgtX3IrqtUWuL91e7lhvJ47Ub5irOEfSZfenHT7k0ti6
	/GC5q0mQV1hxIuLdLufGULbYeF6OBNeJTOZF7hzFGqw1ygjTPiQsEfZmHkbvZWp5v++GTm
	ZWUzRATf8MdrsBSjGwGne/Zn569Nlww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763759268; a=rsa-sha256;
	cv=none;
	b=c55/zwU7c2nTAbkxsb27pPlU4Qlh+bz59MEKMSxfHdH9xDfLMAmUVhMp0D5VQP8ZKg6wR/
	0Xn4dW1h1YtBW9B49BmqZ6gDinP1cXhqwzFH2SOF41gBbLKSPhYKd4sFETwT4oKxGATBp/
	FYAgIMtAbUNWzvilUGf+W2NX05QIpz8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ien0LKWy;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee257e56aaso22882121cf.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763759267; x=1764364067; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Svi+I8ywJ8k5uxtzxqjpEGX4Qh9Fr5IeUT/6ziPIoB4=;
        b=ien0LKWyjQaD3Ta0W5IElQlVdmeWeYWbCp39vTi31WS0fe7wQLdAPNs4rrQKlyADRg
         6Q2bSvPgMdpJg8MiR8tkLdk92kVkTURSgLS6VzE8ShrpLVANtEjRVsGqs3+kjOrYHfh8
         6aMiRleOow56g/+eRZSLFLG87Xm4A7HlJpIdu4Um45JpA8z6McdhY9KDrACKmKBiWCSs
         xuSmPfaQJrvXrTOod3HlzitCMj27sCC1R/5hP4iMsj0eB54Od2ne0Dhn5cUZBrrVd08O
         JQliYcr2RXomjcfg6Wkzl5mUssyQ56BJF9JlOfJzgerXJyVsvfR7RTCZbtsdFnfckXEN
         Mx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763759267; x=1764364067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Svi+I8ywJ8k5uxtzxqjpEGX4Qh9Fr5IeUT/6ziPIoB4=;
        b=eJiBvBwa/gQvbg8b8E5zmhh7IElp9RQRhGqOHiB/WSkQjJfQRylplwJRoRrcplu2FL
         6K31LfDmg/A5Bjokw068Nmk+ssmti3FS9RQfUjKI0Apx7EAB5rwfhl0s/USHV4md1l45
         ZWwIEvJrdpIv6PC663ScRT/rkT43tSw2WbSQfzbqNVmQ/E1bAZ5899dYsh1qQtq/EE+z
         iZdqt+UQ97VWJDtmVmhXwsNcrfCuwYiLhdyFyJTxWQpY/Qg28OWpGtOf2tvHLolHC3vh
         pfdGh4CVXcxht1Iqfesge+1A9krHiSEP8i/OkK2GnEtt7qDGKfzZ6kM1zoAy5X0wYYbp
         EWMQ==
X-Gm-Message-State: AOJu0YyLggMV+YXRq0hmZPp9fBj4/awqlU5eEHTrHQKT5S77pitWWASg
	f2AyxOkYz00x6UWAct53T7hFna3oDCcWoqp/TRMoDEMkOwwtTZJmd43B1hLDwVoo5EU=
X-Gm-Gg: ASbGncvK06pw//Hs5KWQjVOqQFVfUZviwFjqd1zLAdFAx2qkVea9aDXFiTZm/zn1hz8
	g6zTWVGXN2zqhoJXckrrkpbVLMq9cSzvsp6E/MJ9tUWC+fkdgBGVuOzm1RpxPmuN22yjK8YgMEV
	MxY0crQ6w0DvHOPQGL6cjmPeKtX6/tLxydv471sPzIUyGVyiHC2LmYhBZf+w1Xd8QrvN+ai+07b
	p4GorZVE2rdA50FJ3RE8Z0EjN3wFy3Jk4PDvWDthpmyyHRynvphBbCgluP+EUNws3wFv6N5/rQP
	0VqXTg512Uq1UUatYtRRLWn079ASYbLoFj1nw3cefZESDqFLHUvEnfjIIEO2QFK32u5ZH5QuTVD
	TGkAg5WycD8go2FU+U//z3UxofOsi3tlLllX3TPjThSpSbdSTbeexQsDF6YVSQtl14w1zwZP2Y7
	IgPNQ8Pgzf32S8UTI/FLYAVHKE2ny6E+iC2yawgCOqURbWI7VnAWrNyow30wWtFfEXTh/AWg==
X-Google-Smtp-Source: AGHT+IHB54I5/pxWYI0YylL4DbWXryCZhFk7bd7fb71QpMMtzOgbCdkOeFKpCqsEbmreSLGZDE/f8Q==
X-Received: by 2002:a05:622a:c6:b0:4eb:a457:394 with SMTP id d75a77b69052e-4ee587d2ef1mr64635291cf.12.1763759267374;
        Fri, 21 Nov 2025 13:07:47 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48e65e3bsm42420991cf.17.2025.11.21.13.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 13:07:46 -0800 (PST)
Date: Fri, 21 Nov 2025 16:07:35 -0500
From: Gregory Price <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
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
	ying.huang@linux.alibaba.com, mingo@redhat.com,
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
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <aSDUl7kU73LJR78g@gourry-fedora-PF4VCD3F>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <aktv2ivkrvtrox6nvcpxsnq6sagxnmj4yymelgkst6pazzpogo@aexnxfcklg75>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aktv2ivkrvtrox6nvcpxsnq6sagxnmj4yymelgkst6pazzpogo@aexnxfcklg75>
X-Stat-Signature: gkm5ofpd4qs4pjksr4kics4qa4jcrqt1
X-Rspam-User: 
X-Rspamd-Queue-Id: 632FD4000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1763759268-654144
X-HE-Meta: U2FsdGVkX1/uBsxkc8XJZfsOhmo8V7tn5fkBastMwE7FsU+RgI9eP4yDCLIAkxJ+aipXHMiOAQAvW6VbVRkpCE/KRpIKGLy8aNstUYq+Aoc9yVs4s/ZyJ+G483sPGn9/wjaFS/QDc1H8xXsfNK5ypOW6dTmEmYd48O84eagmmphtH7JRoQwjxoQfMHPPuDXF6wqeqh5kXD8N4ByEFWUT7nr9NI9/x2euEFFykpLRju85ichH11+v5cKvZa7kPfKhSLlgCbsD9jpAd2ONJ9/+4tKwcupz5kpxZoJVOjbAqYuQ0zH7rnhKwP9as/GqKeEBGw0jCL9wOM5kZr9cAh39ByN8nVvi/XhzoYjsalKPtj0n3W7WpYrBoilLx6m+LR6nQmzwd9tYFkhWmyktwMbnbKkfZmeQPolqOyH5zeY1b8QbO/c+rjXyhfZHpt6JiVnOTN6XCsK6A08gZe+qASKZANVQ6vPnEdEv7wc1WEI5b6UOSz4kK0GVRDLMvVVJNqvFLN5hUqM02h+IUfeNuViPvB+/mTvyTF6dMQU7Da1nijxAnUguQacuVpw4mHUv3EbA30Jyo1ZT2hRwWBnefWq0XCG5ykgB2RPudM/CBEqteJaqkLbQdW4KPcj3Pej5qbCuHFXm447fWiu8ehRAjip9iddxQYPpk14jaXiMT6Htm8fKnJGRl+zi6TEaA3qwnWvgtoe+Dnhz/5lw5N18fbi1lbWeqQqv4ZdLIbjfkOHG61beaW1mHWXNISs2zA01r4/svTG773H7/Uge7RqvyOyHs3dPyd6/CpxS7uCdyBfgRbo/JLjSUNG0QEoVoVw/CHevPRDkeuEPgdT8od9kFY726krpmWwdjl7nfjNWhL+8ACxFoH0DySXwPFSXRXlMI9/n26MhiVwB/hUOJclIiIb/bXQPOjduyzTPPfDg8lqFTmGI+x5QiTm8ICknNgScadNbg6Dk4XqmdbWOIcWileq
 MqPKuSIO
 CFBO5xrkYL7atOkkzxDuMiuDKViKlh3r5BhvlTxUoDGhyU/F8WZGZ33QxKNVPH1pvOsjEEAOxrXjmYy7fg2wAnjzbBfDvLBLA7Lw9oKcLcC65Y5ufOo0xHX8nPQG/wsZ2V967dl03MedpO0MuVKzydBdEUKgpTQXDMNNsEzx7Iz2TzePSOd+63LPR/25PZocZ46f0q/VkhdBfmoEcltYm6FFnaHc1G+VaEysFx88xKT9sxyfUpvZ9ODOh7iTGyumJG8oIC4FYbYTSpq2SS93s+CerqRWkyOwdO3WP2/09BFsleK8JYmAHE2y/opR/5Rb4yAiOSWGp8uEfCUFXAYRNtL/caAP6UoJ57uUI6wG8aGtJTSvBRjI2vLUmnEOrbPh7pZhUV+1O+Dry6NYUhwSdbMgxdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 06:02:02PM +1100, Alistair Popple wrote:
> 
> I'm interested in the contrast with zone_device, and in particular why
> device_coherent memory doesn't end up being a good fit for this.
> 
> > - Why mempolicy.c and cpusets as-is are insufficient
> > - SPM types seeking this form of interface (Accelerator, Compression)
> 
> I'm sure you can guess my interest is in GPUs which also have memory some people
> consider should only be used for specific purposes :-) Currently our coherent
> GPUs online this as a normal NUMA noode, for which we have also generally
> found mempolicy, cpusets, etc. inadequate as well, so it will be interesting to
> hear what short comings you have been running into (I'm less familiar with the
> Compression cases you talk about here though).
> 

after some thought, talks, and doc readings it seems like the
zone_device setups don't allow the CPU to map the devmem into page
tables, and instead depends on migrate_device logic (unless the docs are
out of sync with the code these days).  That's at least what's described
in hmm and migrate_device.  

Assuming this is out of date and ZONE_DEVICE memory is mappable into
page tables, assuming you want sparse allocation, ZONE_DEVICE seems to
suggest you at least have to re-implement the buddy logic (which isn't
that tall of an ask).

But I could imagine an (overly simplistic) pattern with SPM Nodes:

fd = open("/dev/gpu_mem", ...)
buf = mmap(fd, ...)
buf[0] 
   1) driver takes the fault
   2) driver calls alloc_page(..., gpu_node, GFP_SPM_NODE)
   3) driver manages any special page table masks
      Like marking pages RO/RW to manage ownership.
   4) driver sends the gpu the (mapping_id, pfn, index) information
      so that gpu can map the region in its page tables.
   5) since the memory is cache coherent, gpu and cpu are free to
      operate directly on the pages without any additional magic
      (except typical concurrency controls).

Driver doesn't have to do much in the way of allocationg management.

This is probably less compelling since you don't want general purposes
services like reclaim, migration, compaction, tiering - etc.  

The value is clearly that you get to manage GPU memory like any other
memory, but without worry that other parts of the system will touch it.

I'm much more focused on the "I have memory that is otherwise general
purpose, and wants services like reclaim and compaction, but I want
strong controls over how things can land there in the first place".

~Gregory


