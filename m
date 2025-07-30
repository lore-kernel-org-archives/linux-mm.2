Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE48CC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7A06B008A; Tue, 29 Jul 2025 21:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DDC6B008C; Tue, 29 Jul 2025 21:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BAD66B0092; Tue, 29 Jul 2025 21:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4A66B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:28:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1E341602B1
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:28:54 +0000 (UTC)
X-FDA: 83719196988.04.8D80851
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7732740013
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:28:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rM3lIhv+;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753838932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVXUL3SYY4u26un88JxM93aVATKWntzTTRFMmp2lyOE=;
	b=g6/N9lzX+RDtbcHaRifgb1z3rX7z5xeTyQGtIb6Fieh7cF8SIuyp9Kf3K0EGS2G+i5i9R5
	G/SIgbxXOK/NSIPYGekq/GvrMaIWoUcYkNE9rGCaqqpyFVfq5Ok6j6L0mINlCwqyfAu57+
	3AxPYA0c6+c0Q7emzclfKPIQBuTzArk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753838932; a=rsa-sha256;
	cv=none;
	b=ue4X+/K7fmaivJie1YNIVg4kvy3D0YnPRaXMh2e65eI1jbT6+t7qYtZHvfzAMXYFaezipl
	ZO41DB7Qa5XZiHA/0neBA5if29PPjZMJw+AWn2cbQ1Np+inym2ixWVsYeEood4T2g24qk7
	MMuAozv5HjXGucnTxHj+DP2PHeIF88U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rM3lIhv+;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753838929; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=uVXUL3SYY4u26un88JxM93aVATKWntzTTRFMmp2lyOE=;
	b=rM3lIhv+8qub+ridQ8efp73LGn5n3NU9wy1UAkDxWTOPqZTf6Jde0B536tNL72ZHtbhEDwD28GLn4L3OjjoXPbUPl29/Uw2YqE/eQDVpSRMk6xXYhZd4JkPBVZTeH1yfLqN5uibv/7rITPHaf3wArj28+8PKx6xoU4n+OwVd+D8=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WkSRRoH_1753838927 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 30 Jul 2025 09:28:47 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Ruan Shiyang <ruansy.fnst@fujitsu.com>
Cc: linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  lkp@intel.com,
  akpm@linux-foundation.org,  y-goto@fujitsu.com,  mingo@redhat.com,
  peterz@infradead.org,  juri.lelli@redhat.com,
  vincent.guittot@linaro.org,  dietmar.eggemann@arm.com,
  rostedt@goodmis.org,  mgorman@suse.de,  vschneid@redhat.com,  Ben Segall
 <bsegall@google.com>,  Li Zhijian <lizhijian@fujitsu.com>
Subject: Re: [PATCH v1] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE counting
In-Reply-To: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com> (Ruan
	Shiyang's message of "Tue, 29 Jul 2025 11:51:01 +0800")
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
Date: Wed, 30 Jul 2025 09:28:45 +0800
Message-ID: <874iuuzctu.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 7732740013
X-Stat-Signature: qu1t5bufg4545fqtzgwm1q4bj3e654eu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753838932-283114
X-HE-Meta: U2FsdGVkX1/AuYENFPhE5o7/MwQhU/svtStPCD2kL5B/deDHXxgiTDNOYAJ+76f7T2Ldu35VQqz4P6QmYf5StrONH7HELWUWplk55YeOTqI/5Pyrbwjh72dXgwwQXtxi6hlNJPYGBi477zSHtwxuJteZvFATQ+d0paL3xAw9bKm2iEfD0tq+3gRIvhWDK6CaqF6okFHljBrnhZYETHu1RdwZx8T7bluoXvzmTpNUwFFGIjXGeEkvol9HyNHhxlIfdO0Obtu3NvPiEdftvE2bPAPI2lLGs7Sh4y7MBeOIkbyuRhVIRuZN18QXfh3Py48ShTl5OIgewnrO5SXVovbtn4Hwpq4lTGmvSgXN+JfFknR4yqFLPlhzO3YFZRR3hxAQHuasDjJpMpb5FNl6Vw6vczSsy6JCYpbiuO3gZToSdz9IwcoOxGcF21DQq1Vug2VPdYWM/DuplEI7XUQLVzyHKjMe+afngl/rmdKfHyhH8SMil1RGB3Nd6zCZfHA0gSCnMpPSEXGcw6esY1zoZBn3l03y42MycmwiwJUEzmoOrDiNAmKC725oEf0EeSOSLwVcRHpUcvnblAvJmLb3ds5SQPMfHoq0kUH7cDebdvO+Jpl/pzV6mK3GAJrmy2AD+18owGrnpwRYGf5SawVWaIFJv4tQfCWiJTsZD1oF2CnrKpN0sl9uWrp+QqC1vs4Wbsxl+G7ECLsSDsnlFVItWVU9csmujqojAiDrHw0TfmVrXBw7XemgXf1W5spVYoC2J1V8bAvEEoO2YcfqrAJNsMlct6+yezHyK7ue8+ayIzM/xJtPiD/DLWWsdGXaE+dlhiqLCSp8IbiSqxGxFDf0+9Mle9TwP83i8j0DqRNONHR73vUyyzEn18QDWdC+bBmGk6Lw8xTFe1nzACQWvDj4YQBoE89NCoz/JkqBcx4RRDtLzh823vUbzIUxKBQRG4OwkEBZmPVy7Xn2GoHqMhc1b/2
 FaDdksqL
 V5rUo6cW32N7xdFVenu0OUw4nweiyatwyqtZXQ2ddomsEBnE2ns33/ravF3w0KJio15hqf4swFKskMjgYN7Ptby4KR24ZgJnFwjPOmnQkAaoOWb+KsGyB3B0SkIIuJ6qRjSOU/uV8PTfFF0qWf3mCeD2lrgfzpec11IntMYeJ5nBdovNK6gNnnfKeTQ45BC+WvSjeTxvlh3wMssaK2DgkEBRvmLG0r+vgnh3Ug/1/RykUYlh9zLA7VW+OHtTjuh5KtnJh28PlAkW3lxWk525SDPpHKqfD1weQFe4r0k9sMl7G4Blgw3/RFacCDABuQfz2s7VDmpgLMDrYmXHjxhp2FYqS6lDY7tqOH9RnNEWsu7Mq6mFhqt3Dvv8sst+j/V+rgGxie/OnpiUtP4bVtoI2bgY/GFOTilZ8acVtoYn4CuUy0afc4HqSGL34B1hg+zOd/pYmwGYy+JifFrLtA7HWtGC+hjCBivoxO8g+YoZoNA0N2rrd+go374cxo3yUOE7vvMVLzApsOtkUPpHBLveSMsv3yGFgnraImRZVbCynSFe1Zl3w7Sh3jAaIg/RBp7ZOdfQSws90WPKStzvpLr8LkMTG/K/vz7AB5DN0IRJV76iKjCjy8fkwQutvdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ruan Shiyang <ruansy.fnst@fujitsu.com> writes:

> Goto-san reported confusing pgpromote statistics where the
> pgpromote_success count significantly exceeded pgpromote_candidate.
>
> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
>  # Enable demotion only
>  echo 1 > /sys/kernel/mm/numa/demotion_enabled
>  numactl -m 0-1 memhog -r200 3500M >/dev/null &
>  pid=$!
>  sleep 2
>  numactl memhog -r100 2500M >/dev/null &
>  sleep 10
>  kill -9 $pid # terminate the 1st memhog
>  # Enable promotion
>  echo 2 > /proc/sys/kernel/numa_balancing
>
> After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
> $ grep -e pgpromote /proc/vmstat
> pgpromote_success 2579
> pgpromote_candidate 0
>
> In this scenario, after terminating the first memhog, the conditions for
> pgdat_free_space_enough() are quickly met, and triggers promotion.
> However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
> not in PGPROMOTE_CANDIDATE.
>
> To solve this confusing statistics, introduce this PGPROMOTE_CANDIDATE_NRL
> to count the missed promotion pages.  And also, not counting these pages
> into PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
> performance of the promotion rate limit.
>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>

LGTM, feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future version.

[snip]

---
Best Regards,
Huang, Ying

