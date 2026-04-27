Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F75FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740D06B008C; Mon, 27 Apr 2026 09:16:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718446B0092; Mon, 27 Apr 2026 09:16:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 655BB6B0093; Mon, 27 Apr 2026 09:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5600A6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:16:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A54B1A0183
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:16:17 +0000 (UTC)
X-FDA: 84704384394.15.75D7904
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA28B14001A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:16:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777295775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y5uDXAKrEDVB02qRSKzjeiWjCGbxPKF4FbcYs4OIOiw=;
	b=vfMahW95e7TQXU31X42kZW8INIV9yBeVrvkF56gXplYs5uE26Zedw4wtvAdDv61RPtj3jZ
	SUgpoWdAb6RNcZjDKOS/jWji9kQUf/pVauz/vGKOI4FLXr6J5hsny5OLYmDBCx0fstm/yL
	fkJtQ8VQkuS0mnTErJ5pA11jIXOPqm4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777295775; a=rsa-sha256;
	cv=none;
	b=tnKojWQeanRzwiREBKnVawagLBpjrLTKSv9rK0SoFLPGAR+45FS0apnZz20RZ85/gXtdyS
	SuiIJ2SF3OteyqCSqkLXLo5x9F0kfciN5GVFrveZisHrYQuo/QRA0KfYJkDduoRi4++6fQ
	HLn3OsNyl2Sn7lFbY1rOI72tYy1tqkk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g43wn4p6qzJ467g;
	Mon, 27 Apr 2026 21:16:09 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id EDF944058E;
	Mon, 27 Apr 2026 21:16:11 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Apr 2026 16:16:07 +0300
Message-ID: <14036b07-413e-4dcd-a363-e7f834d85da3@huawei-partners.com>
Date: Mon, 27 Apr 2026 16:16:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/19] mm/damon: introduce data attributes monitoring
To: SeongJae Park <sj@kernel.org>
CC: "Liam R. Howlett" <liam@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt
	<rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil
 Babka <vbabka@kernel.org>, <damon@lists.linux.dev>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-trace-kernel@vger.kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EA28B14001A
X-Stat-Signature: ixdg3irwzj5jbenx7tmemqyrnxejmuk1
X-Rspam-User: 
X-HE-Tag: 1777295774-242495
X-HE-Meta: U2FsdGVkX19EbPqM8cgNm1Cdvm03WeTfb9TlV+5457QtB1ao6zphlVZvSrLWxbTzB4NuKXoeuvrLkVzOZUNgneTUta0p8dw6JpruFetxiCKTo9FuVj8ReKphuNZNOhTuiYO+MT5vxPbfcFElyRg/32BcznfGvMmZE8W44fyGSgs2fb8aC0uv57rdgpxN1/6vn+YnABZksikCpqFk36uTrfbrTYleG1stqDTQD7bu9ZPoZxk6TCsybX130oWhjFOjIKfn25Y1pCv1unNXEx0GPXvGnvrsX501YN8leys1H+gP75SLDk4bqixC3I2zv3iCwC4sNojOR5i9W9A4yEzmByYP7GVvje0rGAVdGoj1fNaq6BfFWp3xTY3w5FhowzsGnHs5Ef2HSR7crr7PuWHlZVw4HdZ6TT0AN3SpAuz/nb/5ltpOIK+r8m0VDeuKPevqGhlbLqN6cv36paVh04KIPU6R0FBUxlFgZTCDNvTsdjzBs5zCw1CWXlPV4subn9v87SJ761HkHDbIVnXIDo6fi3qYVAT3K/QZN1pPxnifv/v35uVgJ4hS75EC7BKtpogsy2QjiMINxwnhqiZi7u1SOAp4iYfNVJrlStCy2cPqWvIFizpdbxUecX7T6b0fhph0HHAP5czsdWHKhasdqEMt+henZEuodpe84sPWPpeaF07GwBHChu5ggeFxB9uN/SEFvVqYVQZJxxa5XiL7bHfpSLRq4xV640IrIj+WpcD+gqxsvN2B5jL1zd8Q/75eCg2N09fP7AW1sAiUt5mTIkAiryGcga5ELX2P8XYuZw5B7vh8F1beVc9Gck07eRqfh4Ib+BpG5lQL6jvR+qy+InkIBCbUypnzPXTlz5/2YgW4QjbHPByWCwdEPhs+cWjoNb29TuQZTzdLZVcmUzSF7HsDH5aGLb1HibqDRuLuHUiGZZ6YjbKhhipkzWZA+kGihVo6NgpKDtF6yovfwB2/OAl
 QNmAfVQg
 0g6g5am27kcH1FizYfuSL3cwbJU/cw+NBzP1JgRU5ALxxXej0xfq29IUaEgD5/RYT0rtwSRW8YnLNgIBAsUJXrh1fPZWCo8ywfFuoUwIUyNi+UqIUfQxHR5qdva4xaI1N/ZDepR7ICK8YTHurRTcNTw8dsCTwFV4q9w/31G6VJc8DpS2pr6w74ZwCi6zd1KAEpnWpeh5bVoJ0gfhv1phDtR7+Eo08xjBEvqO2uuth5Qd9K5wSE9JEVgAdCLw1WEUJF2CLVf87Q8xN0zEgIPNeDkg72w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeonJae,

On 4/26/2026 11:52 PM, SeongJae Park wrote:
> TL; DR
> ======
> 
> Extend DAMON for monitoring general data attributes other than accesses.
> This is for enabling light-weight page type (e.g., belonging cgroup)
> aware monitoring in short term.  In long term, this will help extending
> DAMON for multiple access events capture primitives (e.g., page faults
> and PMU) and eventually pivotting DAMON to a "Data Attributes Monitoring
> and Operations eNgine" in long term.

Very interesting. Looking forward to seeing this in upstream.

> 
> Background: High Cost of Page Level Properties Monitoring
> =========================================================
> 
> DAMON is initially introduced as a Data Access MONitor.  It has been
> extended for not only access monitoring but also data access-aware
> system operations (DAMOS).  But still the monitoring part is only for
> data accesses.
> 
> Data access patterns is good information, but some users need more
> holistic views.  Particularly, users want to show the access pattern
> information together with the types of the memory.  For example, users
> who work for making huge pages efficiently want to know how much of
> DAMON-found hot/cold regions are backed by huge pages.  Users who run
> multiple workloads with different cgroups want to know how much of
> DAMON-found hot/cold regions belong to specific cgroups.
> 
> For the user demand, we developed a DAMOS extension for page level
> properties based monitoring [1], which has landed on 6.14.  Using the
> feature, users can inform the page level data properties that they are
> interested in, in a flexible format that uses DAMOS filters.  Then,
> DAMON applies the filters to each folio of the entire DAMON region and
> lets users know how many bytes of memory in each DAMON region passed the
> given filters.
> 
> This gives page level detailed and deterministic information to users.
> But, because the operation is done at page level, the overhead is
> proportional to the memory size.  It was useful for test or debugging
> purposes on a small number of machines.  But it was obviously too heavy
> to be enabled always on all machines running the real user workloads.
> For real world workloads, it was recommended to use the feature with
> user-space controlled sampling approaches.  For example, users could do
> the page level monitoring only once per hour, on randomly selected one
> percent of machines of their fleet.  If the runtime and the  size of the
> fleet is long and big enough, it should provide statistically meaningful
> data.
> 
> But users are too busy to implement such controls on their own.
> 
> Data Attributes Monitoring
> ==========================
> 
> Extend DAMON to monitor not only data accesses, but also general data
> attributes.  Do the extension while keeping the main promise of DAMON,
> the bounded and best-effort minimum overhead.
> 
> Allow users to specify what data attributes in addition to the data
> access they want to monitor.  Users can install one 'data probe' per
> data attribute of their interest for this purpose.  The 'data probe'
> should be able to be applied to any memory, and determine if the given
> memory has the appropriate data attribute.  E.g., if memory of physical
> address 42 belongs to cgroup A.  Each 'data probe' is configured with
> filters that are very similar to the DAMOS filters.
> 
> When DAMON checks if each sampling address memory of each region is
> accessed since the last check, it applies data probes if registered.
> Same to the number of access check-positive samples accounting
> (nr_accesses), it accounts the number of each data probe-positive
> samples in another per-region counters array, namely 'probe_hits'. When
> DAMON resets nr_accesses every aggregation interval, it resets
> 'probe_hits' together.
> 
> Users can read 'probe_hits' just before the values are reset.  In this
> way, users can know how many hot/cold memory regions have data
> attributes of their interest.  E.g., 30 percent of this system's hot
> memory is belonging to cgroup A and 80 percent of the hot cgroup A
> memory is backed by huge pages.
> 
> Patches Sequence
> ================
> 
> First eight patches implement the core feature, interface and the
> working support.  Patch 1 introduces data probe data structure, namely
> damon_probe.  Patch 2 extends damon_ctx for installing data probes.
> Patch 3 introduces another data structure for filters of each data
> probe, namely damon_filter.  Patch 4 updates damon_ctx commit function
> to handle the probes.  Patch 5 extends damon_region for the per-region
> per-probe positive samples counter, namely probe_hits.  Patch 6 extends
> damon_operations for applying probes on the underlying DAMON operations
> implementation.  Patch 7 updates kdamond_fn() to invoke the probes
> applying callback.  Patch 8 finally implements the probes support on
> paddr ops.
> 
> Eight changes for user interface (patches 9-16) come next.  Patches 9-13
> implements sysfs directories and files for setting data probes, namely
> probes directory, probe directory, filters directory, filter directory
> and filter directory internal files, respectively.  Patch 14 connects
> the user inputs that are made via the sysfs files to DAMON core.
> Patch 15 implements sysfs files for showing the per-region per-probe
> positive samples count, namely probe_hits.  Patch 16 introduces a new
> tracepoint for showing the counts via tracefs.
> 
> Patch 14 adds a selftest for the sysfs files.
> 
> Patches 15 and 16 documents the design and usage of the new feature,
> respectively.
> 
> Discussions
> ===========
> 
> This allows the page properties monitoring with overhead that is low
> enough to be enabled always on real world workloads.  Because the
> sampling time for access check is reused for data attributes check,  the
> upper-bounded and best-effort minimum overhead of DAMON is kept.
> Because the sampling memory for access check is reused for data
> attributes check, additional overhead is minimum.
> 
> Still DAMOS-based page level properties monitoring should be useful,
> because it provides a deterministic page level information.  When in
> doubt of the sampling based information, running DAMOS-based one
> together and comparing the results would be useful, for debugging and
> tuning.
> 
> Plan for Dropping RFC tag
> =========================
> 
> The user ABI for reading probe_hits is not yet convincing.  It is
> exposed to users by a tracepoint and new sysfs file.  For the
> tracepoint, a new one namely damon:damon_aggregated_v2 is introduced.
> The name is not convincing, and its internal mechanism seems to have
> room to be improved before dropping RFC.  For the sysfs, a file under
> the DAMOS-tried region directory namely 'probe_hits' is added.  Reading
> it returns four probe_hits values with ',' as a separator.  With the
> maximum number of data probes, this should work.  This can make future
> changes of the limit difficult.  I will try to find a better way before
> dropping the RFC tag.  Maybe 'probe_hits/' directory having files of
> name '0' to 'N-1' for each of user-registered 'N' data probes.
> 
> I'm currently hoping to drop the RFC tag by 7.2-rc1.
> 
> Future Works: Short Term
> ========================
> 
> This series is introducing only a single type of data attribute:
> anonymous page.  Once this is landed, I will extend it for
> cgroup-belonging, so that we can do cgroup-level monitoring with low
> overhead.  After that, I may further work on supporting all DAMOS filter
> types.  And as demands are found, we could extend the types.
> 
> This version of implementation is limiting the maximum number of data
> probes to four.  I will try to find a way to remove the limit in future,
> if it is easy to do.  I personally think it should be enough for common
> use cases, though, and therefore not giving high priority at the moment.
> 
> Future Works: Long Term
> =======================
> 
> There are user requests for extending DAMON with detailed access
> information, for example, per-CPUs/threads/read/writes monitoring.  For
> that, I was working [2] on extending DAMON to use page fault events as
> another access check primitives, and making the infrastructure flexible
> for future use of yet another access check primitive.  Actually there is
> another ongoing work [3] for extending DAMON with PMU events.  The
> motivation of the work is reducing the overhead, though.
> 
> In my work [2], I was introducing a new interface for access sampling
> primitives control.  Now I think this data probe interface can be used
> for that, too.  That is, data access becomes just one type of data
> attribute.  Also, pg_idle-confirmed access, page fault-confirmed access,
> and PMU event-confirmed access will be different types of data
> attributes.
> 
> The regions adjustment mechanism is currently working based on the
> access information.  That's because DAMON is designed for data access
> monitoring.  That is, data access information is the primary interest,
> and therefore DAMON adjusts regions in a way that can best-present the
> information.
> 
> Once data access becomes just one of data attributes, there is no reason
> to think data access that special.  There might be some users not
> interested in access at all but want to know the location of memory of
> specific type.  Data probes interface will allow doing that.  Further,
> we could extend the interface to let users set any data attribute as the
> 'primary' attribute.  Then, DAMON will split and merge regions in a way
> that can best-present the 'primary' attributes.
> 
> DAMOS will also be extended, to specify targets based on not only the
> data access pattern, but all user-registered data attributes.  From this
> stage, we may be able to call DAMON as a "Data Attributes Monitoring and
> Operations eNgine".
> 
> [1] https://lore.kernel.org/20250106193401.109161-1-sj@kernel.org
> [2] https://lore.kernel.org/20251208062943.68824-1-sj@kernel.org/
> [3] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com
> 
> SeongJae Park (19):
>   mm/damon/core: introduce struct damon_probe
>   mm/damon/core: embed damon_probe objects in damon_ctx
>   mm/damon/core: introduce damon_filter
>   mm/damon/core: commit probes
>   mm/damon/core: introduce damon_region->probe_hits
>   mm/damon/core: introduce damon_ops->apply_probes
>   mm/damon/core: do data attributes monitoring
>   mm/damon/paddr: support data attributes monitoring
>   mm/damon/sysfs: implement probes dir
>   mm/damon/sysfs: implement probe dir
>   mm/damon/sysfs: implement filters directory
>   mm/damon/sysfs: implement filter dir
>   mm/damon/sysfs: implement filter dir files
>   mm/damon/sysfs: setup probes on DAMON core API parameters
>   mm/damon/sysfs-schemes: implement tried_region/probe_hits file
>   mm/damon: trace probe_hits
>   selftests/damon/sysfs.sh: test probes dir
>   Docs/mm/damon/design: document data attributes monitoring
>   Docs/admin-guide/mm/damon/usage: document data attributes monitoring
> 
>  Documentation/admin-guide/mm/damon/usage.rst |  44 +-
>  Documentation/mm/damon/design.rst            |  37 ++
>  include/linux/damon.h                        |  60 +++
>  include/trace/events/damon.h                 |  41 ++
>  mm/damon/core.c                              | 182 +++++++
>  mm/damon/paddr.c                             |  45 ++
>  mm/damon/sysfs-schemes.c                     |  30 ++
>  mm/damon/sysfs.c                             | 502 +++++++++++++++++++
>  tools/testing/selftests/damon/sysfs.sh       |  48 ++
>  9 files changed, 982 insertions(+), 7 deletions(-)
> 
> 
> base-commit: 8f22aa2e28454419ed2031119ad32ea4a6c9f1f1

My main concern is about potential pollution of sysfs. DAMON is already
complex to set up, with a lot of knobs. Adding more configuration options
may make admin's job more complex.

Do you plan to support this extension in damo user space?

-- 
Asier Gutierrez
Huawei


