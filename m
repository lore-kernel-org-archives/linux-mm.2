Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843E1C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719A86B0550; Thu, 13 Aug 2026 13:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A21D6B0551; Thu, 13 Aug 2026 13:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A1F6B0552; Thu, 13 Aug 2026 13:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ADCD6B0550
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:01:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FC4D140237
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:01:29 +0000 (UTC)
X-FDA: 85096862298.02.EF0CD24
Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id 31547C001A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:01:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aEqHfNzo;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786640487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KU+CKGrQ53mm0dGwujJU6921+mu5bMMOKfvhSUNRTzs=;
	b=wXhnLGWfx75uoBp/zGeo8LcQ78UVTFwH1SYIlZYu7591NGwZvV9pvKYPYKrYJdnAiTJXP2
	6nz8/mMLnLGkFEuVhoUfutF8qX1eFG2W0D5fb7gTYIEIkPg4Tvb0Tk/hTUW3a2WC4RO2GX
	FlAa5ykpnl4QM0pRbF8bEIvnjIMIZJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786640487;
	b=w3fmWTxrnoVgyzmyJR6iqnuk4VqNkhcZhVegfDG3ZNF6tJWIMeHXkFr0feUp/6oTCRPf+R
	0Md6lgpU1jBoR3+ZER5BB0Y1s0DGVC9V/tW9vtS1lf/RUbVNooApEzbFqZJqTe4+DlslYn
	3/6r6zYaHvpgXVJ/nwgVxM1LUJ963fU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aEqHfNzo;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IC8q4K8Uk8A6ZcbO1N8MmnhqRx/RYea67hNdi4ByC2M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786640482; v=1; x=1787245282;
 b=aEqHfNzoIvCDfrWkqYihGXCwGeugeiLoRs6zokTUSwl/EhRs7jkms7OF91Nz1nZ0rK6bxVhw
 IEKDH5Q/OSwY44D625i1yd+TsPwpE+E14omR5Chvrep8JuvHlV/xpn7r9R6d6z6f3OMIjxsIDLb
 ZzrFAC9CwazpCqL0KcyRTdVw=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:42::)
	by smtp.migadu.com with ESMTPS id ac65b9794b46e62b;
	Thu, 13 Aug 2026 17:01:22 +0000
X-Migadu-Flow: FLOW_OUT
Date: Thu, 13 Aug 2026 10:01:19 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kernel test robot <yi1.lai@intel.com>
Cc: Usama Arif <usama.arif@linux.dev>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Subject: Re: [linux-next:master] [mm/vmpressure]  ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <an34C2N-yqfok2Nn@linux.dev>
References: <202608131743.c6a7dda4-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202608131743.c6a7dda4-lkp@intel.com>
X-Rspam-User: 
X-Stat-Signature: 1pgk446xzetde5zkc1qjke4abnswta1s
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31547C001A
X-HE-Tag: 1786640484-985920
X-HE-Meta: U2FsdGVkX1+nGXrR2MzOZy8tkrHVe2t2h3ZkMOLtVTFL/HXRoFXzFJ+Sii3N2ahYNO5sRw2oVl/PUFhVyfuHKHNuhK2IQSf4rzA9emxdsh8vfS6UmqJMZzVqd35UhV+pk6EAYLuE1d0XIFARDTabTHOb6a8PSwFWATQyEALIKC6sEUS6nKLSe6rb1t+UVWqDkql69qMw9l9MxYoksU82YN7cUCLoQy7L7V9LeBCuVFYZhYOdb/ZcX0w5HV+gVCmxG5gy4+IrpmYAUysy6+sOl0IDNjOEon/5PYE5ydvJJ7RRcWLNNgD0lFHN0YTVJLUvIVkDS8G2el0J1Hy2aFTLK5L1ubM+lvzkqalAL826JFVZLVw/UzFTKDHhbygLlLPbYHfw4L/A0tNY2LaUVeg6UeNFnFKEnETY9uaFk0pKjsEX+kaOQB7YHOrKBV+kACMNOwox6OtWSuV6mejgyy0KZMk4V4F9muXVux5T342gG4N7hqpD+0+rfiu7gNqsxTRifA3MgoD6a3hdkaro/1jaQu+DGcjEf0jFuQSVZVYZI8tykn4X0I7CXlR577RzGTa9Hrb2VACICha/1xpBd4sn+VF02XOMWovkHO1HpKgFMZ1XaoyJ4GeOUpJkqjD8/LE9lxqmbCRKPPX7XUJngSv/pSJOb7mFFKm7upWq1hvO+xgUBRK4JTfy3W5yQvbnks2fR/12LJ0wSq0YTFJvUVDOUyDH5HXWci5Or52HH2kGam4DfQYf8oQ5fEf8yjuXhWfoab1S6JEhHLJfHfhYi85UuMjbxgx0qoF2z5lmaHIw8cDHZAkFHdZCGXXAKAyRr/evq+Oz7xP0RiyxfJpkPB+nsI+pjykdA06Y+R6k/42CeXNhegpGww7ZNhbpph0sM4PvMFDscsoITLTHq7NHIk6cem7viUMCZ5plcthxk0IWSv+K4sDfuf95NXmUO9TqzeaXw7C8mW8xeXas9DDcmG9
 VZMwYQTu
 mAVC9KWKYoo7vDyHz0VKjn+DxJ1sYuybR2D+s770iDt+Z00QKGUZfY39b7YU9VZmki23GYFt6sYl4w9M5Z8yepOgv4y5Hw96GtLVRxA4HFeBSGcCpHN/r6PZppqIzQloBfjlblNjs6ViPWB5FuOK8+40q4S8tZK8J6TObNoZXa8UMsTpArfvsGwgcvI4/rnI/bR6SFzbBDEOUq92b+c8cDOp+JQkJOWXk7OoOpGHYv6/zXN/LNpUnklUbuIz5EKWAC/2c5VAis4+qx7vxQXdWsSIVaFQc53JOM14znuRhPyQLUEviUoEmW7Y7g6VLGFhjz4j/HSrViclJWJuasG4nSBubrS1A7JacdIx8E03o5N2Ltmso2PhdSwaFxhI1TdQXEHWFnBbmlYw06v8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 09:16:22PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:
> 
> commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> in testcase: stress-ng
> version: stress-ng-x86_64-29ce10a2c-1_20260712
> with following parameters:
> 
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: mremap
> 	cpufreq_governor: performance
> 
> 
> 
> config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
> compiler: gcc-14
> test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 

Hi there,

Can you please test the following patch and see if it fixes the regression?


From 84c0b05b3bc5cf73ee66ead75aafb1ad684462c3 Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Thu, 13 Aug 2026 09:38:28 -0700
Subject: [PATCH] memcg: keep vmstats_percpu off the memory_events[] cacheline

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229..e25d5b9a1db8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -246,8 +246,13 @@ struct mem_cgroup {
 	/* handle for "memory.swap.events" */
 	struct cgroup_file swap_events_file;
 
-	/* memory.stat */
+	/* Read-mostly. */
 	struct memcg_vmstats	*vmstats;
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
+	int			kmemcg_id;
+
+	/* Write-hot from here on; do not let it share with the above. */
+	CACHELINE_PADDING(_pad_);
 
 	/* memory.events */
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
@@ -266,9 +271,6 @@ struct mem_cgroup {
 #if BITS_PER_LONG < 64
 	seqlock_t		socket_pressure_seqlock;
 #endif
-	int kmemcg_id;
-
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
-- 
2.53.0-Meta



