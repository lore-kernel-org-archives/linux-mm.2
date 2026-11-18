Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD31E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=G7ViuwWa
Received: by kanga.kvack.org (Postfix)
	id BCECD6B00EF; Wed, 18 Nov 2026 05:12:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F2A6B05B1; Wed, 18 Nov 2026 05:12:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A992C6B05B8; Wed, 18 Nov 2026 05:12:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 848C16B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:12:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 092731606D8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:12:22 +0000 (UTC)
X-FDA: 85447824924.04.7200AFB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id C9A4220008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:12:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G7ViuwWa;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of jiebin.sun@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=jiebin.sun@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794996740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOvZstlG0NBbv/dzQM6xwLtQ/0sPGNaMMnmH8lqZPgo=;
	b=lCGqU/ICIgIOZe1TGVzvkaaKz5oIjAXhegRNAWHDuYLYbpbHSdNlcVFHc6vhemJJCG7uMj
	XrFt/JKxlCKy3T+zDE/bFxqP0n3EUYoOMllS9XGBh8Ing5PpsIr6ax1ih+7Nu+dt8XJduE
	zsjuMbKbMYqbzC+EekrMaqTNMqEUATY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794996740;
	b=6e8jiXVdKFpBak96MgWvUoYj6cuVjo0T59s4UcFa2McLXt2ZomWaKhqwwjwtyOwyi83rLU
	XYNnGyYYT+ANGehezfGJLsEnd74RXTqwusTpedvF19CM7T2qJDemwTDs2getvGjIkzpxXL
	BWrJOIgHhdWc3KhEkwn0ucPfAmVfOrE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G7ViuwWa;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of jiebin.sun@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=jiebin.sun@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794996739; x=1826532739;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FF5B0ph4nYkrwjb1C6748DuKV0yiQO0WYfTjj9OFyQw=;
  b=G7ViuwWajQav9rOyEN7Dz3bgI7Q1V4bXUGSxQed/cSOx6vzau3ugq1md
   qd7W6s7PBQjHJHLWH9NZdoNuJh7FePxxnOQMn564PKfVLLxl2jeYU5V8e
   0/sAsfeGYZZ47cetnihH40P+TiwpMJ0Q+Jy1bpRQPh1SQPbW9tABCZV6J
   3iWol6PLgYYD9gz0d/9nSFSNLyFlZTEvFGGX+ciJ4IOGF4K6XDo/HyUCt
   vHZmsv5f+6zjXYUEvYB7ZzQvJhGbZXHATjAVb4sahnJ8pjoSFXvmkPYQt
   zUVWoL7tQcZFYVWazzBBdpoQA1Ifv0KbeBznaJZdqztkmqY9+W6ybInjN
   g==;
X-CSE-ConnectionGUID: tMpOWvZXQuCA2Mlf3Dkqbg==
X-CSE-MsgGUID: kGhbk/qNTViv1l213K5Q6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3682650"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3682650"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 02:12:18 -0800
X-CSE-ConnectionGUID: D/5dg/T/T7egAVJfdbIJDg==
X-CSE-MsgGUID: 7vyP09MJSo22wc5qpMf9JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="10052164"
Received: from linux-pnp-gnr-1.sh.intel.com ([10.239.83.186])
  by orviesa007.jf.intel.com with ESMTP; 18 Nov 2026 02:12:15 -0800
From: Jiebin Sun <jiebin.sun@intel.com>
To: akpm@linux-foundation.org,
	bigeasy@linutronix.de
Cc: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	linux-rt-devel@lists.linux.dev,
	tim.c.chen@linux.intel.com,
	tianyou.li@intel.com,
	wangyang.guo@intel.com,
	jiebin.sun@intel.com
Subject: Re: [PATCH] lib/percpu_counter: allow concurrent sums with an rwlock
Date: Wed, 18 Nov 2026 18:16:46 +0800
Message-ID: <20261118101646.3192636-1-jiebin.sun@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261115191636.f18859e4dd5f58b9a33e7814@linux-foundation.org>
References: <20261115191636.f18859e4dd5f58b9a33e7814@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9A4220008
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: zza8k7h9r53oxipgsjer7d51guootz7r
X-Rspam-User: 
X-HE-Tag: 1794996738-510039
X-HE-Meta: U2FsdGVkX1+DEKHzmu3D4bvpT/0nCQX+rJlURd9IkMlNQgrS91cc3Y9m6pR48mxY16fLli5kBHhG49aRc9s+rD3ll+kMboWIZLuUdUWe+/mp9NUiZaEVPicYS9WAi4m7EdsFCfPzVcGaybWJxNhjQ29BrDNdZqeoZiopeTALZHUecRDOhqwimIm4lOMsis77oYeIO3v1DvKNO/4PglqauyJq9igEP9s8RkAFW/ePOI07P8TSpuUzZctke8cWqLH5yAUqmZkdYwwi+koP9p5JqzaUxrxZfWw/bfQ8Zyb/LlEgyNSe09/17pvsUCTr89eBWhv0RPTTrCyFP87JZeJRsRvqw8kSIZB3avCtj25ulM+ptdGQbCgjCTDt8xBNJclGJ+Z4dU84bki/44Hcv6c4m5j77dclBijKQl8dYa+vrRlSUR3/SUEXF+IWy+cRXTuXKEW5V0Ihb4c2O4Qtwn5VphP66JC4kOebGtai6Um2xDh6Q1v2fRuv2BBrSV4oPQRP7d5gESs9P3rY+MBn5KvtU647SdMsZSGfNzUYMT9osCcXEgN0RXfFCkW7XfEM7ZaABEEG7k2ZAU92VQPiOu1OwlEpnEGIHpP4EXkG9LIybkWeCpDtC5w/ZVG4wGzgQ3+vQl654zUL6ycQ/yy0fhANZcgJcN+8oLHzq+oHDWc5hJ0+/AjN6lmZid/HgNW6vmFTEg5U5uNefE6wAwgvw53dt+T8qOvzRIjHgCtPL2vipWqaw0uF+oypDC0wu/bbfRkREnH6a81kjjeM2a5LxHOtTcStAuzebCwkH+zNp8Y14xFhLFpQiILl7H+nS9qv700ZIUlWQPlpKyAl1OqglPCpilefwZ+NGAK2x+HRNAG0m/4gzn3AvW/+b1dic2UOTGAMeZUnZHyEFp8wLR3H/REXdZdTA3RM0hdnO2Ut2n4c+0RDmZmoATpB8kUNPBq48WI6L6x5J9cEAxYQyky4JYl
 kDmbHnSn
 qH6O4c0BnJR6ydOtmnwb84gAT+edNtU9MIAKhU528Kq7VPbYyQMGtIynsyp9CBPjZbUMzz6WqVjdhi70r82BoWIWWj+0Rg813E9GlNmX2EFlTAxhmoJvENxfpPUNDRmvPhzWcuMeAzJncVqXcP1cTgg6qvkIwOSLtS30p5WEoaoLz5qGIqLC+aF+RS1ToxntgOgZUbhTRP95TIl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew and Sebastian,

Thanks for the comments and the RT review.

I'll replace the macros with static inline helpers, add the RT comment,
and clarify the practical callers, including percpu_counter_sum_positive(),
in v2.

Interrupt readers can bypass a WAITING writer and delay it if they keep
overlapping. I'm considering the impact this could have on counter
updates. If this needs addressing, we might take the write lock in
__percpu_counter_sum() when called from interrupt context, while keeping
the read lock for ordinary sums.

I also tested buffered writes with fio.

Fio (64 jobs, 3 iterations, 60s each):

  +------+------------+-----------------+---------+
  | Test | Throughput | CPU utilization | Cycles  |
  +------+------------+-----------------+---------+
  | Fio  |     +6.91% |         -40.41% | -40.80% |
  +------+------------+-----------------+---------+

Test configuration: ext4, 32 GiB cgroup memory limit.

Commands:

  sysctl -w vm.dirty_bytes=67108864 \
             vm.dirty_background_bytes=33554432

  fio --name=buffered-write --directory="$TEST_DIR" \
      --ioengine=sync --rw=write --bs=64k --size=256m --numjobs=64 \
      --direct=0 --fallocate=none --time_based=1 --runtime=60 \
      --cpus_allowed=0-31,86-117 --cpus_allowed_policy=split \
      --group_reporting --output-format=json

Thanks,
Jiebin

