Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D5FFD4F33
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8C36B00A1; Tue, 10 Mar 2026 16:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4A36B00A3; Tue, 10 Mar 2026 16:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F2E6B00A4; Tue, 10 Mar 2026 16:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA92B6B00A1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:18:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B402A1B7669
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:21 +0000 (UTC)
X-FDA: 84531265602.10.515EADD
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5E0BC12000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:18:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uNHjGrUK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fo82tIF5+QnwYHGL8br4DawXmsD1Q8bLn239Zv/oPPQ=;
	b=4zcygAs5DmzGtd8y6SQ5yOrtLwrbW8J9JDwa62jVJmKa4cIbdxwiJhc7ZbT0z7rIteWmMk
	misAHKM2IRbdoXFe+PBLeD8swdX0SheowaLdEKdm7j1qO5VWj7ehawH3Z33GyPWaiDFVhJ
	u7bC29WIzyEujZ6rwDdlMYOFW3xoz/o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uNHjGrUK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173900; a=rsa-sha256;
	cv=none;
	b=CjAz13fnEJwccoUR+MP+qJTzA6hYQwyWEnY7WFOIsg8F3YSOt85lrgkTAwRDbInSJwg4rj
	kRnm4nQMwPJ5Svewd+UBAXEsJFarD8zYiHEsJNy2gm1GoSRE2FBHFF+bGo0iibRNK5i42l
	1GtKanKggvnI+znBRYZc7rpU9sWGf/0=
Date: Tue, 10 Mar 2026 13:18:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773173894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fo82tIF5+QnwYHGL8br4DawXmsD1Q8bLn239Zv/oPPQ=;
	b=uNHjGrUKra94eH3gTyRIEQ0bcFls29b3XMpYdV5WnmB3mrDzx1L4Q+tXUXL/4Wb9sXaraN
	/ghkAe4VwmTQLIRFKVMrm3AcCC4uVXx/6hQBdzMweVM4SBRC/f7T0HdblLTkhXfZRAc47F
	JWHcbPRDUTCvqa4XetG6PebEo03j5wU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftest: memcg: Skp memcg_sock test if address
 family not supported
Message-ID: <abB8Z_IV-8COna8U@linux.dev>
References: <20260310143936.720592-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310143936.720592-1-longman@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5E0BC12000F
X-Stat-Signature: q9tmmq5cb77srin3ob1stunjgdqkfias
X-Rspam-User: 
X-HE-Tag: 1773173898-367610
X-HE-Meta: U2FsdGVkX1+Ow2obXPdoVS5Trrs9dOLqLaU0cRt7hXRhariiyTYWtpSCFKKyJD/GWNCw9T8+FjKonq8gba0EGy7vvBsrTdqDQWbpGbnWl7ViiUuc4wuVOEXQOhccZYFhi19SD6jeXpeiDQrfBtsZE9nT090xNf4HwqFh47Em84kxyG6Q0eNhzgLQyS9mnSGUNNSvTV0m/BA22SoejMH0YoaFOij/pk1LjBftyAMJks8aXLUYOv6UFEITCGLbqlb0ChmdbsgA9CLNqhLm3+Pwr+6FaMd78Xzrjktve36gPWd/UiiywVFvj5OTggl4hgITzCN3iSGyNpImuNkUS5SmJcvNQH0K2fubf3K6dU9wtW4T4mtUdW4Zo93ltwc4ey5NooZz1oEcOIeIpFoNYxJFReHNPkFikOGDt6Y+Qs21cIWLx8iMAPr1pbd2pLfr/5wbnncOLzGLx+Q540YO76i+wOQiZ84q03DN5x54QbbUu3+eJQDaBb9a8aqjdSD0ZATsQNspkt32kHvhrIuKuU9EmxJM8X0gRIG3NL1hvG8z62jk8QQ8TPBR6GAdgz0wMr8Rsqk8gde+zuF2QtnJcAznhSaGV4qRFHyXdsp9ZxHYtlbgjVGcOxxWN7lNXigSdw6WJABQj6+WrA7qAeDixoWvl+HQPk2ELsQUckZ6WqXYqCQhmYNuH/Yq5KixbMU9YLmq1KMMogZYyUmr5+GcYSP1L8n96VwNb/mibXxamqMDi5mgEolnEJlH5LZytaVrgwNsDGkL/vGo0umM7YO5SxG2NrndqOBlYjEnZDtfOKEeRgNnT9tY23HRwYKA5ZXEY2BpNJ3uukrT0nsG3w9eq4ld1rnBRb1a9n5tTkmaitT1zqf7I9j3Bm18gnLOPiGyFvc/Z4jy5P6Zr4IiKXf0Fc6ZJoygnIb/rlDJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 10:39:35AM -0400, Waiman Long wrote:
> The test_memcg_sock test in memcontrol.c sets up an IPv6 socket and
> send data over it to consume memory and verify that memory.stat.sock
> and memory.current values are close.
> 
> On systems where IPv6 isn't enabled or not configured to support
> SOCK_STREAM, the test_memcg_sock test always fails.  When the socket()
> call fails, there is no way we can test the memory consumption and
> verify the above claim. I believe it is better to just skip the test
> in this case instead of reporting a test failure hinting that there
> may be something wrong with the memcg code.
> 
> Fixes: 5f8f019380b8 ("selftests: cgroup/memcontrol: add basic test for socket accounting")
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

