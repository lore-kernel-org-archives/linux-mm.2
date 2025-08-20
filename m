Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0A8CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7946B00B4; Wed, 20 Aug 2025 01:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F486B00B6; Wed, 20 Aug 2025 01:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC2A6B00B7; Wed, 20 Aug 2025 01:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A13C6B00B4
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:41:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26DB91DC431
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:41:15 +0000 (UTC)
X-FDA: 83796037710.23.B7AD353
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5CB18100008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:41:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1JkOaB6i;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyauN4RXiriguN4yWhoJLLR51Coqdmv0ARugHvu5X8M=;
	b=vcaG5DHAzD/Ivl5U3cc86LnbZPYNzEEhXOoXDMifwGlhKqBVwgisrRNHgAB2ifp8HrJmVc
	Vjif+yjL63RgE+W1a8zLYTrJ0Gsds/wU11PCKqBviJgPupSM1YT4hYSXj7ibU8cN9z+3f8
	ahqggTghuQG1RlOR5K1GGfBWBGEMvjE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668473; a=rsa-sha256;
	cv=none;
	b=rLUikApaHZ+yH5+OoEOwgPCMGE/3caOI1dy/x53AHDN4dUeHsQ2QKCNB3jOdorOowKnhzf
	rZGzvMMz90gbIgWqJGnuavb62sE5iZS7Gc56En2A/gIu2VzGBbWygJlhVfcSJfmRJTCTL5
	YsNQUdxUAsp1u3bOOruQmXF2xUpmuCo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1JkOaB6i;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 557474184C;
	Wed, 20 Aug 2025 05:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE618C4CEEB;
	Wed, 20 Aug 2025 05:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755668472;
	bh=sJbRMZ3dzMihdohhvVLrwvHrGo59fz+haIPct8foZ4Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1JkOaB6ia1UgG2tx2yeCD5I6d69KDl5YYU8TGj8hJLynPffr2A2fqGrt4v/GUIkTb
	 UDUItDtyJVtxG/Q5n/egJnaDiez4L9MDZrI12FAhYWS9mzqaHKek0MAq0ahDtwaRx+
	 /Z0cnDDhMFSmJrwf8P3LgXR6mMjKM9ey/BGPXiw4=
Date: Tue, 19 Aug 2025 22:41:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@gogle.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi
 Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in
 batch freeing
Message-Id: <20250819224111.e710eab683b7c7f941c7d1a7@linux-foundation.org>
In-Reply-To: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
References: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CB18100008
X-Stat-Signature: 9n6snruepqdra5mn8k5z3bibahqwn4b4
X-Rspam-User: 
X-HE-Tag: 1755668473-616013
X-HE-Meta: U2FsdGVkX1/daBpd7tySsT1KLNFCTHDthE1lWO8WeFqiDEURxOpt0Mlon9OrQZVv1ZN5b+5nmKo3ClZcPgxdoiIO6PD9lD4FeN7REX7pgdiTm85QGJfmEOFfMvbFeSWXydeL8TlSCkzVdnR/Dz+v+ZcN388Ed7HHepGhGOFNsHK0hYp0oM/k+04cz1gk3WASfuOqGyS2Tnd/M24Mw0SQKRc6ydsRlxXsGjdZmefpHi9YRoUm6w4R56rcgHBxqjBZmvEOidzJIHkBCGocctUoRMgJ0JpIGodfTqNgmpc1XlIWfstNlHuQbSvdz7SwkhUYJBvYpQgoUisw1Rb2f9FF6JYD8xctQi7VAkf0/rBXVBOrZxkvcWhb/Chfs4Qw/r6YaSA3lPPkbN64+twzo7usKma+cJPdgCAHNaQSlZ4dILxe/Uhieqx+C1GrCLo5/HAKJT8l/InzslR0/5kGDvbofLM9xivIUGWGXn1kWlQTbXNeplPQpzCzf5xLHk/S591q4c30431l9a5bVsHxIKhl86NLEcQ/VrpLdYREjcmOVKvcpAhEDXogpb0g0l1k4ECAUVgVerI+4RtO1Cs+MXf4d87tL9j0HdNEzVmHTlQdScReRciBFnP09Tmi0gVzxieFiAh9jEBV0zxRoaAFlRQffyc8S1hjJzwCHG5AGfBKi8YWdBVh6hvRWDYC9Kr7ycgrcYObyBHxJlqMxb0geD3XGyn9Q+SPs+n3AWeKNmxM9THjXu14YrXzg9W4cY/sbEZYpaRSTne5yGi8TQF5U7b5ZdcGIo5TFOyfSJHVo/YHM1pt6V2AUPDjWMBc9YT8154rQ1w6ffHjUpvOT3eAUuCMnC4Xw7K1J6bIBKZ8qp1SxWWoJQH/v5FSlJYw+6ecP5u1VFBKH9ToDiuaiwNI+vCpFqBfYh2kmg1AL0k1On3GYEuCjmmXPbODUKmI+BGX7EcWEXufQLRxmdhRjGz1wAU
 dK02hiU1
 y6Xm0+wFkqb2+U/DnnEEhbHc575UBhkEeJs9wluOvjg5GhN8rKtpPGpMnB79G+giyuGym1/jiDDMm+qXQG9+o6EhMb5M4RgdMHx+qiuZQorbnHrPYWRfXMruZPEjhxbzjVyYkQb6YdH/gTn1ZLa3kTdJp6Z25+vHCngHTtostlZjMYKQbJTK432WLk/XoryHYXAUYKLDMOEI0+lgBmght+I038UEjKPGmQDGPjnbADIinTRxvOCnJHKTbn6785LFe8gFVX/NTVJ6ouACjL0eLfOg4wIQFl08biqgkJnqvL9UQnKt+j8JfBwxO6I/v+qeCdQ6l2lmUokGMmz3JG2CyjnAeKZK91iwfwsDXJJnmXdFkXRdTuP0JZf7OKaEA2lZWQjUj8oqViVwvFMxLyJk6Rybm+sg4OjdrEo0l9clYyuz7maE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 11:58:03 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> While testing workloads with high sustained memory pressure on large machines
> (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> Further investigation showed that the lock in free_pcppages_bulk was being held
> for a long time, even being held while 2k+ pages were being freed.

It would be interesting to share some of those softlockup traces.

We have this CONFIG_PCP_BATCH_SCALE_MAX which appears to exist to
address precisely this issue.  But only about half of the
free_pcppages_bulk() callers actually honor it.

So perhaps the fix is to fix the callers which forgot to implement this?

- decay_pcp_high() tried to implement CONFIG_PCP_BATCH_SCALE_MAX, but
  that code hurts my brain.

- drain_pages_zone() implements it but, regrettably, doesn't use it
  to periodically release pcp->lock.  Room for improvement there.



