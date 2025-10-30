Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5399CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105D98E01C9; Thu, 30 Oct 2025 08:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE4C8E007D; Thu, 30 Oct 2025 08:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F35698E01C9; Thu, 30 Oct 2025 08:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEC3C8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:55:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F9EEC0133
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:55:27 +0000 (UTC)
X-FDA: 84054776694.19.C0F1497
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id D0F8740005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:55:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=E5WxgfwP;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761828925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjXAFY7Yf0YuI8Me8mv/zue8i3Kx5a6EOrshoHCz3hk=;
	b=w0cJcWXgmLJ1x88HSu7Ze3mg70flBxBPnUI9xAtVd2mMc2HdFA45coflUxHDyvZ1ndKy94
	lDOtCRusOdD7VidwZ1Tv8ZiJVo8SQW6UEuz0/jj73ZNhWedwwGk1ypz1WwgCLLJj35TJiq
	4Y4u8GL249SrsEKGLV5HIjxl6F4Gzug=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=E5WxgfwP;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761828925; a=rsa-sha256;
	cv=none;
	b=Vgzw8N33NrvUscIXqAacfhsGAzC8MF2a9JpvgI8Ut21A6urVSAm5T06sfPvF63l2BKMgD5
	oYcRD3i9DiMPteM3h4iCf5uEmDduZXab4S3YMRZeCDKJ19KVz+9qQ0maa7KRzc3jryGNpn
	MV9Z4y/gBXmQPamvOjOduPmcZmnBdJg=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ecee8ce926so8819511cf.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761828925; x=1762433725; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AjXAFY7Yf0YuI8Me8mv/zue8i3Kx5a6EOrshoHCz3hk=;
        b=E5WxgfwPQOopwI54TozA01dEbcxzyBScurNbq9E12aZoToJ85/kue5oOKMJ/W00I99
         7oxGRv7+A33ZwzyhSpwyGkLh2XtO2NJNsg5G2ulOf/1DLn9KnIE4AW+U4/iLLziO+MYx
         TMyQIo+tuHL8EZyd4tw6roMFCMdxgacKD+n1W2nDQxijH02P+2tdUVxthUXhCRFKk8sC
         BPxWsnyM93DHEexhDxRPluSdYg69Mie5vi9hQyBey6pDKyaQoYELdMgsWdAfBPlAa+/7
         +/vCs2rJjl9wDuo6V3138bmdblIOIQWMn2V4ymyX90dnMC5kqVH2U3lZFugRT5ZyeCO+
         E/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761828925; x=1762433725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AjXAFY7Yf0YuI8Me8mv/zue8i3Kx5a6EOrshoHCz3hk=;
        b=BlnoY9SGD5Gn7Vm7ZztlY/HczYkZW6fPoxVaSGTm/FF7sgpXIB4jqjdOylCdQMPhG7
         SyMcfwc3fjKsvxlJ7jCxhxOBfsQPohRjP9J1fjD/t3LF1mU8a3dbwBrSlvmNB4aKshGC
         etybMWBJPOw/57C0i2YAQ+M3CpnV+N/m478rGBfXR5HgbPQU8j92g3UeFchNJMHkFm+2
         rhb1pzc7NjWWaziDG7FeZhtLLGPc396MT/nGaHArBhRrJOjHOgfUCK5F9OrW1I1KnKHq
         eWT74ASNieULhHZDS7XD21XwyWSpDyhViaadbHUZHPCx3p6G8PgvaFMzaIcp0kjeAToL
         HUDA==
X-Forwarded-Encrypted: i=1; AJvYcCVs2It9pyf7E8Ea2V627EPPGoSgduq8n/tcscUMdU680l16RU1Zw2dcqgCVwUrVHW+6MlnK36Pseg==@kvack.org
X-Gm-Message-State: AOJu0YyhzExyBj8tzogZGtGTiw5QZAWfevYlJlCFt9t6jLIM49nIXGpg
	0RIGwAJu6nZnbOJEoxSY3KmA33nAJOgKHB14kEOVirbu9NsRocWbo7BaOSIcHCiQbIU=
X-Gm-Gg: ASbGncsHd8O3HQmnpxWkhvbfOzaflKwBgVkeSmlDbF+1/varosE+NzghvtHYvEM3Cc8
	oMV2nLHVXiQvYzWsD0mCQVpHppj+q0Oo7bZED1WPKkVV4CgEGMC2ImdkvSkIS83TpIARjz3Ah/y
	fdFBuOBzJ+9ZuQ/KoLZmQDJ+W0V6c5dnmJE/S7piMYvwmwXS8flYONnFL96fDXTV6L5Kpg8OhDZ
	jtAaGJ3iDrTZH5Hq/BBFWv+yGHlrRlLRikD437sW8V9P6x3CvK1TsIdOOy1/W+vMcLC97Trdz1H
	YVMvhqdOhFS54CGO/gvNVqN9Gg5Ki047GBQm1FmbsalpLWfuRP+zXjV5Uj4/oK9tak7L22EH/nC
	RrOecKv3N6NEFr6l8bERJNlmbMynR/eMaymja63lRmzzFYL9+FRaqXDZ7cPNkV+ID0axtdwXcaC
	mPLTIGE15nU0ODxbZ8jKOcDaNnjlw36ukZ3BcT0a1f3j8e3i1cpfTmmFdj
X-Google-Smtp-Source: AGHT+IFa87tUftxLW7en98BSp1AWY+Kl/BwNB6G5pnoREpGqN6QyPQ5zvarZ4A1oRBRNtr+ofNzIbw==
X-Received: by 2002:ac8:5a50:0:b0:4ec:b598:2544 with SMTP id d75a77b69052e-4ed15c19a74mr78731841cf.54.1761828923949;
        Thu, 30 Oct 2025 05:55:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba3860692sm110493811cf.30.2025.10.30.05.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 05:55:22 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vESBV-000000058Xq-46nj;
	Thu, 30 Oct 2025 09:55:21 -0300
Date: Thu, 30 Oct 2025 09:55:21 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: declare VMA flags by bit
Message-ID: <20251030125521.GB1204670@ziepe.ca>
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <a94b3842778068c408758686fbb5adcb91bdbc3c.1761757731.git.lorenzo.stoakes@oracle.com>
 <20251029190228.GS760669@ziepe.ca>
 <f1d67c7b-5e08-43b3-b98c-8a35a5095052@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1d67c7b-5e08-43b3-b98c-8a35a5095052@lucifer.local>
X-Stat-Signature: 46pybjrqtipomhhe5etz49tjaoo9yk6m
X-Rspamd-Queue-Id: D0F8740005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761828925-466621
X-HE-Meta: U2FsdGVkX190/CbPyhls+E8swWYo8rW7J29c8V6MdYvjRp+g/Leo6FrOpDt0YYIk6Uo0SDCnRMiiazxaH56DRxb8eiZ8sesW5xRSoqFTzvGJ7DMuPuszvYHN7D6qs9O79CETkTUBjBYyPfJQusoS71KIqz1wl53qa1u1B6krYgMoYG/7E2+HDK9xFmEZlw4PXzWnfKUAUxtPVBYOp/OWX1xQcl49VKSy9DvWfWx9ZRinbtr1TzKvx4hFOu95YSEoHOlvMvB4Wq7gW1ZNPOd0PwAkUpfuE+jIRKPAurv2S+vu17oZ7/m0FqGW+R1ecc3RvnkFNQZ5Od+jpGVbeLFxZ3H7Vdio9z7m+2XgFk9F3UYTsrMyF8FxbyAVAIX0GFWtXgsYZgQZ4hOoiSbFShZRzaK4h3Ng469USO0V6C2B0qu7Mcvwvjd2122n87dyfTdbPDfjEMbSwHiR+F6hOPscpWrWvssUPTaXc6PmVSX59iYR7UtMLFZHeTImVGq5oDci2W/22w9PvlRsRooWCzBK2m+lEQrl9x2KT3WKRsuTn4MOFeX+Y4bgNdkgHhcqQAxQ3fg9DwlfmLFrTRMvTgpY3Oo+qhM+y4kZEvHlak41jCxEjuQuOotIYiY7mDkHZ8O8LqmbXhlPos4aVfP1mUL83yUiuXDOgQIoiDgA2Vl+8tHEkkm8GgiNnEwTLs6SmGpOU4LB0uJ03nCVLnIJm1DCR9Lb/Vd5P90uQvOPzbLp+MSY8vDNCmTWESpRhvfu4it5iiBso6HTp3AxNPg48WrwzZ7n8oto64n03PL+7hUHbkBdNyjLE8rZjKx+vhjuYQJoefcZgA+92iROFyB6N/5mD6RacY73lTFEYH7K9SnbaCobZ1xK+jLyYnd1r0A0trM2cZRoM4syiG/GRJi9vZAeRkC/ecf46WgQyHiCPFePLkKuaYybpcJxlrvVaCWeP0fJM6bW9eeX4mNceyMHP5C
 1UGidCGo
 SisyIe0be6qVKlvHzcCmNCROTK6pi0lrEQvllIwV6dF6UAU5f8+R4K9uDpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 09:07:19AM +0000, Lorenzo Stoakes wrote:
> > >  fs/proc/task_mmu.c               |   4 +-
> > >  include/linux/mm.h               | 286 +++++++++++++++++---------
> > >  tools/testing/vma/vma_internal.h | 341 +++++++++++++++++++++++++++----
> >
> > Maybe take the moment to put them in some vma_flags.h and then can
> > that be included from tools/testing to avoid this copying??
> 
> It sucks to have this copy/paste yeah. The problem is to make the VMA
> userland testing work, we intentionally isolate vma.h/vma.c dependencies
> into vma_internal.h in mm/ and also do the same in the userland component,
> so we can #include vma.c/h in the userland code.
> 
> So we'd have to have a strict requirement that vma_flags.h doesn't import
> any other headers or at least none which aren't substituted somehow in the
> tools/include directory.

I think that's fine, much better than copying it like this..
 
> The issue is people might quite reasonably update include/linux/vma_flags.h
> to do more later and then break all of the VMA userland testing...

If only the selftest build system wasn't such a PITA maybe more people
would run it :(

Jason

