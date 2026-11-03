Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96935606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 13:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=j2fPrjtf
Received: by kanga.kvack.org (Postfix)
	id BE3186B00EF; Tue,  3 Nov 2026 08:31:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93336B05B1; Tue,  3 Nov 2026 08:31:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81596B05B2; Tue,  3 Nov 2026 08:31:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81DDE6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:31:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F40B1140415
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:31:23 +0000 (UTC)
X-FDA: 85393894446.04.8E89896
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf24.hostedemail.com (Postfix) with ESMTP id 85A37180005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:31:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j2fPrjtf;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793712681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqSSouDoyJf0YGFehgWYnnk2xGKwMtREqQQCF8wiudg=;
	b=GOVegi9E8l1An+SE0QL+9GBPkMqlXjuf85AG/S78/W9P4+dt7+vEDGEHdg23bd3+57o75C
	czrnOB97goXKjtlm3eMTu++bY232XZnQIwXHxlReXeJ2bPNUAhrQRwZ5LcLI9QVehiMz6/
	dwYbeK12T64c2j9+Yg9AO9+yu/qQCps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793712681;
	b=YB89nvxdMe68drz8WQviWDIIMpHkLA66jq8ov4Kjbbhc+cBmX7jr1WcNo/ZLJ7P3ToTXgq
	2Jgs1OigFvjehf3r2yQoHt3UJ1yVGGynsw9craqizqa9p2+i+dKX2bp8fgGFVDfY2eWP3b
	0a08NdmMSqtcaJ9vQ65yLqnZjJmGv84=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j2fPrjtf;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793712681; x=1825248681;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hkR8M4AVECxKSn4GYebF87vUMQPK1tTyUqELFgxgqRs=;
  b=j2fPrjtfyShRjm5j/CNXac8RtTuXuKdtijKexJHCexurK055NycSxwTh
   b2nM+QNvxx8IuWr37sEG9WUZ84SCkHo2DG4UZWIZsZPlH8ODY2pPJrswg
   7j9k+i9/V+oSkqpOAwVf/DyE2V/yerf3H9SS50W5wUc3tea70xsToNiz+
   ydRaKyl+YYI9lGMxj1v5wwjr0Pc3lHRa/ayDeoJiSHdQgIXAj3fLn6uEZ
   yetct/EA4iJ6etShjOpyOaXvRDyA1IEQ0mjisymp1imbIpS3+eA25rwbv
   4T5d4tWdA3HLNu1hnZD74r7KitZ30pcwabLc8bbfl5a2KkgsFbfnN4egV
   w==;
X-CSE-ConnectionGUID: Axdyk966T0m4KnO6PHXC7A==
X-CSE-MsgGUID: 1Yd4E9D3TfS+iejVfcX3QQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2429914"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2429914"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 05:31:19 -0800
X-CSE-ConnectionGUID: lTrs3dgKTlWdj0SfnJ8l6A==
X-CSE-MsgGUID: kcSFKz+DTo2hkMUZE0wIXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6542067"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 03 Nov 2026 05:31:12 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOEbU-00000000ilw-1efr;
	Tue, 03 Nov 2026 13:31:08 +0000
Date: Tue, 3 Nov 2026 21:30:46 +0800
From: kernel test robot <lkp@intel.com>
To: Matthew Ruffell <matthew.ruffell@canonical.com>,
	Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/folio, mm/mlock: Don't batch folios in per-CPU
 LRU caches on isolated CPUs
Message-ID: <202611032138.4bxGcYLC-lkp@intel.com>
References: <20261103075940.110308-4-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103075940.110308-4-matthew.ruffell@canonical.com>
X-Stat-Signature: x4crtc83fiho1qqqepkmxetmpqoq9obq
X-Rspamd-Queue-Id: 85A37180005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793712680-619203
X-HE-Meta: U2FsdGVkX18Hkep15N86/7Jl3/lYLZccOW9z+mwKV9BTFz6HtqZ+oNmmpEoO0+ReeuEG5Jxu/ucHXgOskZsrofeqvISAiRFPhtBXiwnPXyXRaFcQ2wntC2y9r6G1XImlRUzweO0JvVxEi7kxgfil7ODvlXvoouJmhAwiLP1zNZR91aNapmlCbm+icQPXCTSC2Ciico0ula/HSe+++Fjm1T5jkSAyinnPNcH5m44D+ipTtn8mwBrFz3mU4LJySpVGBDcQmmPTqyfkqwpPaW33UgCo0r/zeXXG+CNVFVx4S/4U26GS4QBKI7KBYoQdGiOTQAqAv4kKAETCj7cFFL9/Omi1h/z2MhP7V0TyZRrUCQzzk4I7EK6e7U2zd3fR0F3gvyFN0kCXbjapcNfRxQDPr9nYcKL4iRDOBwsP/GN/taML3AreOwmzWUxnLeKflVwtEgLkVs6sw+sazC+xbF0xB5lCGDwz7OCADwKZClRAzZ4Zv5NCeu6KlPAmViKOIsI40iXbtPzHe0Gs5VP8LTmLFYrY1Smn9A/tl4LC6tuDXwTtEWoHoa0UrMhSPJPNNwZ9LxPHgvadhSRKuwdlAzjnuaM1XG6sNa6FPHH1O26zvxmXt6VUGHVSchIXDIcUMCS340QLEC38qqgT1PWqLoW3g/JDeCnHTSUvl4cuJP2eb0cgFXFKohyR5P0iR0wEzElstShrLDQEm2h0hgp8WwSFRiHTbarN9A8U0aaS4Rm9/yAUb/aoKjb0WsQTlXxTpFUWmFcbSE4pkfFRaZP21zHbAjtMVLEu3aOlDdh73Iyi+Lvr+m3TCH3J5ldGFHPS7SPSmxqPbG0uZbCnux3nKZJ/FQHZbg0Q2/Dfxmyq7lHgphbqfvszho1ImBUuLFS9XpunrJzGwmRkiYDJg3UuwOuRZ0HzjDzvLjuLn93/00QwoDFk6U6ZXAlAzFYpukdOu+P90qo5utPA5AjrWvj45cy
 huavJxYU
 5gLeHWkg3pXELfe0NfozTQJC+U0M9gyfScMNPXHmh5hnPaWO12Qt0/V5et0RE/quIDxTPanJ14eE0jPEZxW7IhSSRKeJY6ujpbERi1h/mEEe9UE+yi4RAy6tDR9/JH+vEca+fjZKEL3ONFmNT55hmctPaH4PmmO0mD/WbxlibMrSBJ7op/xUVN3DvpQ7i2m/ZGMQQY5Nf6rWdFogbrQEVhx8UT51qIwb1Eer23Vw/mfNwOLNw5CJD0LDpRLXmDqBN+oEXMfJ8nvZKMs8QP+Rq10uTNotHm8W1eEPZrd3pm4BSN5Qzptb1fTQ86xLS04lSQc5X4VeXK4LggFR9UeO8jhvMr4b8XezfqxPYPPue5cBgsBNvYONMJOmAXpGYs1ln+guVg4fV8tvbdB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Matthew,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Ruffell/sched-isolation-Consider-nohz_full-CPUs-isolated-in-cpu_is_isolated-again/20261103-205935
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261103075940.110308-4-matthew.ruffell%40canonical.com
patch subject: [PATCH 3/6] mm/folio, mm/mlock: Don't batch folios in per-CPU LRU caches on isolated CPUs
config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20261103/202611032138.4bxGcYLC-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261103/202611032138.4bxGcYLC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611032138.4bxGcYLC-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/folio.c: In function '__folio_batch_add_and_move':
>> mm/folio.c:293:13: error: implicit declaration of function 'lru_batching_bypassed' [-Wimplicit-function-declaration]
     293 |         if (lru_batching_bypassed())
         |             ^~~~~~~~~~~~~~~~~~~~~


vim +/lru_batching_bypassed +293 mm/folio.c

   280	
   281	static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
   282			struct folio *folio, move_fn_t move_fn, bool disable_irq)
   283	{
   284		unsigned long flags;
   285	
   286		folio_get(folio);
   287	
   288		if (disable_irq)
   289			local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
   290		else
   291			local_lock(&cpu_fbatches.lock);
   292	
 > 293		if (lru_batching_bypassed())
   294			folio_move_lru_now(folio, move_fn);
   295		else if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
   296				!folio_may_be_lru_cached(folio) || lru_cache_disabled())
   297			folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
   298	
   299		if (disable_irq)
   300			local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
   301		else
   302			local_unlock(&cpu_fbatches.lock);
   303	}
   304	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

