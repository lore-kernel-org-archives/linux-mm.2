Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D15606A333
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=SfpUbeic
Received: by kanga.kvack.org (Postfix)
	id 723F46B05C6; Mon, 23 Nov 2026 09:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4366B05C7; Mon, 23 Nov 2026 09:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A44F6B05C9; Mon, 23 Nov 2026 09:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25E506B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:05:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61B2B1A08B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:05:20 +0000 (UTC)
X-FDA: 85466556000.02.A297412
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D51040011
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:05:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SfpUbeic;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795442718;
	b=WpXDqs2upLLp4Q44Pwp9GMe6sGHvuOD5LDxz5/FXBWf/snmW1s4akBJRme8rOHb1U2cr9K
	otpfO6iMZZiyo2+7xu2O46Vl8zIi1LURnwP6Zblx0ZGIGl/C6sUhT7O7cw8Uvhzt5SbIVC
	ueM3JdL33PzD4WEVuELLDWKHj+mfCeE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795442718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njozbmbCn9bcbYemCFYN4fFcerXn8LRoys/sYPRNDos=;
	b=3c09CA4ybv9lBudrVTuXCxKNs6YHaF2FqIr2Xa+JJLXhWO+6z0B3tPBqtRTCeHSjZfkcyT
	+7ZJsf/khM2vO/vYwPuyGBo21Otj0BKfLnJHyjjk853K7JHpgGuZUVtZknsggtIVYujepR
	XYRRKkO3VCDsOLhgjBfqansfKbZqzG4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SfpUbeic;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-67daffde88dso1857618d50.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795442717; x=1796047517; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=njozbmbCn9bcbYemCFYN4fFcerXn8LRoys/sYPRNDos=;
        b=SfpUbeicm7PBr3C8/LCj3yl3SqprgpbWvhR4L2sGdCzCzyqmT3uDYdr7JNWpUOt0rC
         CliFb/Gfx7qX6KCs5Z2i6bByyGLpm8L+L7F4KgvywTXBlpHRxjyTrwF1/9BVmYdM+HTL
         F5jxRVYh1JiP+fkoUn3BfbYFv5YJNzGAqqDIT1jEXscUZajTlpGWrzeI6aC9GE6lzTok
         d/lWVcs3LJc5x5IgioEWe7p7A/gWjJleTqy5KxWQ3evnZVL0bu6NCohYXjJ29W6LoZPh
         Vkef1q1XZKsca8qQa79rr+/cyQhS/gHV3LcnQMkzSjiHHotJM9HIRR3Dd+hrCEU7HkLQ
         FrLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442717; x=1796047517;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=njozbmbCn9bcbYemCFYN4fFcerXn8LRoys/sYPRNDos=;
        b=IsSoaV+ncaX8AX/cvEd1SuWpwkHvZEKHr4/AigfpZ5yNpaJr/qaPhKauxqnKZQO1KB
         oEbwvLG+Qr92VLgUHQZAP9cA/Ljzg4SsIdd/cCeXOIE3u4B2gGLwlt159Oq4Q4g96Vu6
         JkyT+QIp1oqEQS43tltMhG9sAvVryWF0LDCBa9cQk8LIHEInairCs118xpMB1AmR3Kmi
         V6EdeK4yHTxbttwiaP1o+SQp5iTLwb29KVGapvXcHHiAsrqjoQJmxipqW8hYFyjBdwUs
         jWkM0/D5iE05HBh3o9osGzeI2rDuMqYR2Wv8++EVa6En+lMG9OxGV5qzclRBSw1xvW6u
         duqg==
X-Forwarded-Encrypted: i=1; AL+hErG/dmhuCOwNCBJvts2eNNwE2U4u4Ug3K3wC4RzVL50XqV+VJ71KPkfJYz+068V7nVlz2I1ehrIJRw==@kvack.org
X-Gm-Message-State: APuU4Z/C27OcyJXi68qcR+xUtymUiY+euSS8IIhJShOFn7uIsuU24tRm
	vzCwNf1qDFG0XqAEmpjpvmiGVGbD5cTSpXQ/jXl7d2E4NKNc7SMYlwqZT7D2AiQuqaw=
X-Gm-Gg: AZFdTZcx/joB72TtYn9ih8I1W5lxU+bJWRF1E7ZsdCDrfuOvKyDx9RD/kuvoUTrDmNL
	hGrVtpd7fjKQtYrLMedp13jdmxrKSin+UuCARZPe4ahvMPhXr+R0Xplhk7MsBbgiz1Df2Qo2PB9
	hxwEoNfR9jv8vbDlXDxUSnw6FUa+/UUimDURUdmy/ouWfzfKP5b3rjH7AYjGO9MUtl9/KqN2z/8
	giOwr6dgHEddb+VH/tspQVnu5UHLDAeiuk/w0NjLTt0qHUViolglS+De6G18Vy47oJuydCi1bBD
	08phanYiUDppb7oX/r1v3wrZrfVCgnEyHk7Elq55R5gTzw3DYHe/EllB5JY1rYiYHzVYHSYtn0s
	ur+oaBZYvlT00rIj9oszxThJjP4+ZXs3iPAaoifVIkA3QqopSY3m+vfCIVuUwO4u2ZViOE2aDiU
	97G4eVnP9E4h7gqBrmdaMkF3WqbBRIIilr1LLrbiyP8Hatwb6PdKs8nLHBt+mcgktpGI67CnTuK
	jz3TWMtbv3pxvts/iTHODqx1gNYEDLQZYSY0FgzCBoqhg8Jhe6wLqa7h/CvV/ePLc6b/1+MTxHu
	JuRMPAE9/eC3nJKnDVDUCG76VuKQ6yIMVZqR3ZVJ0VHceAcYeOvusB2/7tB/JDGynIo4AEagUEh
	/DO/ywi+oSMHllld2Ys1pp7d1Q9al
X-Received: by 2002:a05:690e:4881:10b0:67c:efb:636c with SMTP id 956f58d0204a3-67df4425656mr2221811d50.51.1795442717363;
        Mon, 23 Nov 2026 06:05:17 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a08552sm106091806d6.34.2026.11.23.06.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:05:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 23/60] mm/damon: restrict DAMON-native folio operations
 to common memory
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: gourry@gourry.net, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
In-Reply-To: <awMcsTqyCgQ0dISw@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-23-74f5f9a115c2@gourry.net>
 <awMcsTqyCgQ0dISw@yury>
Date: Mon, 23 Nov 2026 09:05:14 -0500
Message-Id: <179544271490.412063.3555696768623975197.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D51040011
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 86mmaeu3fwycjecbfkm7imdbibo97km4
X-Rspam-User:
X-HE-Tag: 1795442718-150041
X-HE-Meta: U2FsdGVkX19XUremyFA6SLo6tqwdm1pRnBG0shS2ywXt30BzuA5Acy2s7gtRXZKw6bZ1VMXwh6tuOKSUBRpkUFxliquGaEfqwvHWEY9kFIDR3MhbfbtYTV1yfKfAz6kAVp1l2EA9WlS7txDkYHz+6B6TU4/GIV4my/oqEAiEkYwkkKyb40ViD5fy4cDE5zR0GG19xQUhx5YZniwUnx+MgDPLYRQ0Qfa032zOi/g7oHHFpz1XuysYOPKgF0YCHB6MbKvdXuXqH/COFsRsti2KoMv5ipaAnM5QJodInvpm52K3VgeJAkrGo7OEfaPa2lWORX3grQGfCSCkWb89Xt2uYVpGJVDFHGv6KYUQ1Jc0cmOrR1idtopZxKbngfd6Is8qX11UMNOALybDF1asFA1j6kcUI1d2q7K/nmapGxdoWuqbhJVzmLmhrdhoPnsVuLtOYUuPSw+6hIBZDYI1WxR6NxWK6akrHPWBq66VyzUEXJbU1Q97c5voqBogftdWk7jh9670EfcWQyxiqsNSPEwH8ppDlXh8IR1v5Ev7Z5gekW+pP7IsCViaIlVkpcFOGVwFoYQVxfmfj0Tnuw57hwhLWC4hb0ZvPGQ/nQZbbTB0ONNGNG30cRDLyNGSVcUV0bHDt35nSXI/gZhMxpX3nSJ2ABhDXN00Gb/2zx9OC0P1WNqIR4H/Ec+czfp7g+zSnugwKh5Wi2tpKBvi3qF6j0QOb2kfaoifqbXkCps/+zohpPKiEA7bcyXi5BnElbPwlhpDW7v21l+L8O/rJFWRSHNMLVifSFDkFlJKXjF+O6X4d+AHKf/aGWIrWo503m9bkhZv5XeoDnddZW/NpuGCv4lIwgNtR3Yj2LwtWsxQYPf+B2gD3Ar1nYO2UZnzFgR0kM7Tw5QutuPX6FrPB08IX68h9DYMejI794dEvVn4WXVEHEVhctyLjev1jnfq7yzl/eQcYw9NEwx3RB8Emz7dsre
 b5Gr35k4
 IdRMcEIGZ44YWhFDCEZoanYYNftaNfq15BOFFvBIK7bqsJ5KCgMTC3wHbBwfEnM/fQn6EVgaSZX9FGr4p9M/oCJ2/CarqejFxGsE7Tj7YhwqV1IJnetiptMsVBOwo2Op9oEJF5HPmgF8DY9+X4dBQoqLABHDIiBBsj4LgNx2z63xEgcBZjiNKLAYXem8dqhoCp8S0ZtdYhURXXb1D4Cg7gI04Glg/pXUrnFQzQn9V08+/ELdsrnDwYjl2nEx2xvYVizZhHB9R+GQoOIYr+wHN3Ja5y7xfOmGcnV6Ry1aw0J9HGAh0EUAaOq44u7cREvIU80hKcIsOFWX/bQq0uKj3tN2njIQFeuxbupntjlImnKws2LTVe6GoopTDgkbzcXUMVg77OH+VQXhJ7Ju4oOu2cX4wQwy+tlHX33E5jBH/onmYcULLxCJbKI377xutoOPazSAI0dPEhBqtANXl3h2OaS0dgq9XHUrRqvC89ulH00XbqBoWLh5S+l9tlH8EHjMMN2SI/8HcrRoilrn/8D6G3JgjnfmDAPygExBO5SCZhVtoenGUiv/NvxBLQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-22 11:47 -0500, Yury Norov wrote:
> On Fri, Nov 20, 2026 at 01:09:14PM -0500, Gregory Price via B4 Relay wrote:
> > From: "Gregory Price (Meta)" <gourry@gourry.net>
> > 
> > DAMON acquires folios to age them, check their accesses, and apply LRU
> > operations and migration. Treat these as general-purpose MM services
> > and restrict them to N_MEMORY_COMMON.
> > 
> > Memory outside N_MEMORY_COMMON can still hold ordinary LRU folios, so
> > it would pass the checks that keep ZONE_DEVICE memory out of these
> > operations.
> > 
> > Treat these folios like ZONE_DEVICE memory.
> > 
> > DAMON cannot acquire such a folio, so it never ages one and virtual
> > address monitoring reports it as accessed, and DAMOS cannot isolate
> > one for migration.
> > 
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> >  mm/damon/ops-common.c | 5 +++--
> >  mm/damon/vaddr.c      | 2 +-
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> > index 15cabc79613b..57201a0c5e3a 100644
> > --- a/mm/damon/ops-common.c
> > +++ b/mm/damon/ops-common.c
> > @@ -17,8 +17,9 @@
> >  
> >  static bool damon_folio_acceptable(struct folio *folio, bool monitor)
> >  {
> > -	return folio_test_lru(folio) ||
> > -		(monitor && folio_test_hugetlb(folio));
> > +	return folio_is_common_memory(folio) &&
> > +		(folio_test_lru(folio) ||
> > +		 (monitor && folio_test_hugetlb(folio)));
> 
> Can you minimize the diff? That would also improve on readability IMO:
> 
>         if (!folio_is_common_memory())
>                 return false;
> 
> 	return folio_test_lru(folio) ||
> 		(monitor && folio_test_hugetlb(folio));

that's reasonable, thanks!

-- 
~Gregory


