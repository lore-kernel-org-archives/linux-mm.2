Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A858606A33C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=b/Fkqj2b
Received: by kanga.kvack.org (Postfix)
	id B8BDC6B05BB; Mon, 23 Nov 2026 09:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15B46B05BE; Mon, 23 Nov 2026 09:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DDB06B05C6; Mon, 23 Nov 2026 09:02:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECED6B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:02:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8426A1C431B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:02:28 +0000 (UTC)
X-FDA: 85466548776.05.57C3E66
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 888F64000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:02:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="b/Fkqj2b";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795442546;
	b=NR7HLO8jXrc6NTMRzr67ARlEPecrL9QvOYD2om6lBvxVIyjlk+eGm3oMXoKlUboCeuqDad
	MLx3MjedbdDd+vIAnc7rzr0D0iQYqYhEL2GJ8/TSotcniTWoTnxbMIgVlLzPp4ObudgCFW
	/pOlHKaBG7KR6rFlcUdFFbvTM6xkD+U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795442546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3PKiWxJL5rA78k4RAfL19Ict6G9pZhcXRFYMUNqZcE=;
	b=vOWJeJDvcyDDRNSCAaGShiAqv+fFvXP/w4HYf7yPAu51GZKQAlXvB8IZpQtWPjck8hRwwa
	1nLk7/cT9wfUUG01PIt0fqTw/slRdZ+VVSyafMYOPIqD/HdWaM4s8KeAwwU1VblBOnspK4
	m4TQZcunXGgKmUpWVgVgRnCv1dwAD0c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="b/Fkqj2b";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b4d5e645d1so19958417b3.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795442545; x=1796047345; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=K3PKiWxJL5rA78k4RAfL19Ict6G9pZhcXRFYMUNqZcE=;
        b=b/Fkqj2bECOTctNILvX9fzdDH/SYltTjbBGgRLSbP1KoTn/q5d2STzKlCA912QM/kn
         k4UHM+Hx6F8JDIjdnax/5N8Rpet/4lbrMKXzpLxMqqTV7iDZHjz4d2+nMZVWT6Wct2Wv
         MGCA2g01VMMESDFN1OuS3nWtPAUkc3E8GFVI9F/XT950NJkDFUm5clvYX4808UGX0WZj
         SQlhDJUCh+k8JGzZH/FOaQWZjOM+kv/RyQUEGru0HUl0k9rVjE+V8hwIhQ4Fzrjtg8qc
         EgaMbzp1CIdsWXaK3ZubwDMWa2MbUEnb4tqyCkGGeQyWc/X7Wka3XVzO3qaU3fnL0KOP
         YzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442545; x=1796047345;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K3PKiWxJL5rA78k4RAfL19Ict6G9pZhcXRFYMUNqZcE=;
        b=qd1VWXKJc/jneCnW0rS1qMAsC9YeMrEk8d5tzFu+b4W/qfZlsySQkGWHniGAKh2qxn
         eI9lKpcFOwyZYYtv5tNZftwKtilIdSPBnW8Z74jH1+k4l4X4tHlQE0RKZiNhnkwVomuE
         5pQ9nBgU+S7cBu5dosJ7egz9pJZfdm6ZdpSMMxeDIdWwnJwdp/RSgP/HDPTs8wm2K4GP
         jhXdpM0KoD/CfXN9Fciqpi26R7I2qi4778oEcWUlwVFsqJ8RNWfkFndb+T0GBgNtWbK3
         s9ZqIg/slzNrBkFy9khCJLF7xHgRe5oVdAdsyGs2FzoilP/jL9KP4YzWndsa1+RF11Jd
         0qGQ==
X-Forwarded-Encrypted: i=1; AL+hErGkR8wrWStF0I/VzTcjZGPuYOENT0WoQjC+QwEnTJ9chyZEPaz4c/TsBn5CwqBfLpO01LqqdvVDYg==@kvack.org
X-Gm-Message-State: APuU4Z/l53L1MOHH8WqSWyukAkrrycZyl7q4L+9nx0Bx89rBX1EyjpV9
	qn3w8F9mGfE4Hh/bFmYWIS4+Ct+VdjpN+ZL3KCo+9hWZIodBmFf/D+FfnS5qg1O8jFA=
X-Gm-Gg: AZFdTZck5wYBnGjpib8tBhy9k7FQMt8P6JfvrvyuBQa++05XtzdKTVLoC837Xv0fxl2
	KV/imL0ZQP4qBVFv973b0d9eq52GtsyAtC7m63eYp3Bhv5RPc89XxrNAYA0Q99s884UwJlrVw3x
	pyrjMRl4xtLBbkTkN0//xKDHQM+nkBR9dJOIf0picEoqP+CaGRKVgN2GGAdynnZerSVyflZdrnF
	Gim6VmoCMQDj8kv/RzpGmdMp/LzT7H3L+mdCqj8Osgvd7MAd8OzalpSVY6p+LTCBlwZgENTeXDH
	80WGvOd0fFbtB+jdAKBLtAiHmkurUPY+LqQKYHuqfbsTDiYVI/ZbtKwrfI7YvWWwd5SUolAeqTj
	x+6dvjjjJsiEhSsMZkAqum+ElM6AlDzHJhyhs5rzp6n5xXRAe58+jU6MRsKgzUxjbC+ONDXbHvt
	cFAUGzF7oJ5o8u1IxKUzRTlVwF4zR7kWA9+RAwfP6hSKrt3vwATEfKTNU2/4cXJJEluMRY/y6LA
	j+xfDdFQAkGUCh+Xvx/kjb5d/inLXnRlogRKyHUFZudmWerQXSAbGhgeP7rOmnmjuCueJN5PZDy
	lJOsOI+uuQTYkS6KNUCe3xIXYCtz7vfr0gKrAioEd3a1xQt0lW/AUXw/BJEKCJssvoPYbZa6Lah
	ZOTy7c8k=
X-Received: by 2002:a05:690e:1449:b0:67c:b95:6753 with SMTP id 956f58d0204a3-67df451a476mr4209002d50.146.1795442545280;
        Mon, 23 Nov 2026 06:02:25 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9213515f467sm104854846d6.41.2026.11.23.06.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:02:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 18/60] mm/khugepaged: base the recommended
 min_free_kbytes on common memory
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
In-Reply-To: <awMbTMt2M876rTy9@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-18-74f5f9a115c2@gourry.net>
 <awMbTMt2M876rTy9@yury>
Date: Mon, 23 Nov 2026 09:02:22 -0500
Message-Id: <179544254257.412063.6102711886866280853.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User:
X-Rspamd-Queue-Id: 888F64000F
X-Stat-Signature: u1ag94ty99kk3ozb4q9h6mmp9wmcoy5s
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795442546-200693
X-HE-Meta: U2FsdGVkX1/ZO7JbkpLEH4ZxfQlrPz2VIagSt3oPVsopnRKjLE1mrtdm0IVEiPUZI5AudNW2HFEJ9Gg4Q9WdZqs3R7JMtUwR3HBAr7mCtDma1zsfJJ8hEXv37Net2QiIyHmF16Uy50oy7YPsoGnxAF53ixp9d1c8SCFab2aCxbnh1ROxnQjpFN2nCafFfdpAkmlcyuDO/TpQqTp+d7OpwGux37CyMvVN/NwoY6LWQwibibP8KAQA+a/X5+Rl4OFBCu2ByCElaw5NOw84c75VMCdQjHgWEpQQEkfgheSrJ+h83TOIBfgow56MCdouoDXBiQVJBEHBW33Yso5q+U/IyB7LJkehtsWIs9lc91L3uWaHdiW6KpmTn5pHUOld+DsbeTnLYiOGWcToj7A1JHN6FzGsf3PCL5LGNnimLQiSBUlZxYHtx8hqwB+RHWCsOm6YF1nHVehJ/n7zdaVIZvRa+dBVW3er97Gx//3n1EHVpyeLg8suacUBSBDqGrOBJGo9teq3op2VZWy5Z4MLa5rWTgzNUwQ4ytmGv0bXrZlZEguSdBVVpC8tMNcOQ6P2YxjlNQrGYxRK+tPti9qYNJrNzIHIsfJu6FsyGi5IeMWEfAKeeMGeNhSwtCv1Y3OmZJbMoLfwq1zBtUB/Jy8vobifegB+3O6G0ScYqGVxxCwcAFpGxrYSbcdpU/qVCEFzH9DZBtXLNGzekAZ6P80npuQlLcxLGLJrMYDX3LEL/IFzOH5j2FG41/zgqLJu/EtMtjOs1H69Mq6fYmvgjxEgc7ELEVxyQeuSo1fWU/E9PIc2b4gCFNH1aIGSsJD3Y+ahl8aBkUdmNLbUarbaDYajorQRijRsVKH+GMzFeTZiR9rguzNaVRPcl7byZqTgedmuy7GMZJafeqENNP/ZG5s/6rAxAPMhWeyi6DXW9oBPlQup/sSD8ShElzHzNeQX5COUhckbswXcdV6HgqWUbbwiNwX
 oacds2+R
 rDfAfKSJqjwPatX5Tf6mNlLIc5snBN4nal8DuSmWvf6AOFIlKo8GtT3h2h2uRC2sN+IAe0LRuKlqSmioRG7QTdY9VWcWrKzxFGDtBt0Md8ORo5bKW0L6x3hZ1zP5K9yoE6eE39glmJsu9LAM2X2zuR9DF+FTGqmMlRhJPP63HguW7AnQS0oU+JRrf+bnoevJz4hv5utxQe/4mzvqo6GeH2ZBTZbz12+XiIIEjoFE5S5iwmB+4WGhrTFrgO8GxRoNVGG4Xr+cBqafz9HVAQfHCs+23BGcaieAYD+Xy5NWS9ap+xuObdHi8HAwGoWeU+OUpWraoiSkSCGxeJ5jYDUeDnbxV4WkLNlmzVuGmQDD1iCxk6DJSTJU/2yW0SB11KBDE61vIQp5EOyYuOvF/yzvfPZ7FPr0agR1qFGGQRX4eySAxkFI1U23DeV758iRUslgTsXBxg6pb9JMrUXCmc9d8x2X8SXNygWVbgd/laBOGFGzFSIIX4wU8ANWE75Fu72CmFhCBTxySMVD0P5hzoCUOSSf/S2K0JdG6KkXM0gzkGgqXe6baQdlv4E9A31CCdaSMR4nhyYLvxYNgWtPMl/XAnhiKh7SeA+odvj0CWktZ52R2jIE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-22 11:41 -0500, Yury Norov wrote:
> On Fri, Nov 20, 2026 at 01:09:09PM -0500, Gregory Price via B4 Relay wrote:
> > From: "Gregory Price (Meta)" <gourry@gourry.net>
> > 
> > set_recommended_min_free_kbytes() reserves two pageblocks per populated
> > zone to help THP allocations avoid fragmentation. The reserve serves
> > ordinary allocations, which use only common memory, so count only the
> > zones on N_MEMORY_COMMON nodes.
> > 
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> >  mm/khugepaged.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 2dc4245814df..a930d99f89da 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -3151,6 +3151,9 @@ void set_recommended_min_free_kbytes(void)
> >  	}
> >  
> >  	for_each_populated_zone(zone) {
> > +		if (!node_state(zone_to_nid(zone), N_MEMORY_COMMON))
> > +			continue;
> 
> This is the 2nd time you add this check. Maybe fold it into the
> for_each()? Assuming, you keep N_MEMORY meaning unchanged, that would
> look like:
> 
>  #define for_each_populated_zone_state(zone, state)            \
>          for (zone = (first_online_pgdat())->node_zones;       \
>               zone;                                            \
>               zone = next_zone(zone))                          \
>                  if (!populated_zone(zone) ||                  \
>                      !node_state(zone_to_nid(zone), state))    \
>                          ; /* do nothing */                    \
>                  else 
>  
>  #define for_each_populated_n_memory_zone(zone)                \
>             for_each_populated_zone_state(zone, N_MEMORY)
> 
> 

thats reasonable, thanks!

-- 
~Gregory


