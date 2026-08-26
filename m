Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE19C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 18:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31376B0092; Wed, 26 Aug 2026 14:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1CF6B0095; Wed, 26 Aug 2026 14:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD06A6B0096; Wed, 26 Aug 2026 14:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 858F96B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:35:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7D94C01DE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:35:49 +0000 (UTC)
X-FDA: 85144274418.22.D55D7E5
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF29F1C0007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:35:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hhDrfRDY;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787769348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHqdE6pA272ScoS7mdb/8aie5HXyJ6//RtsbPPQMm/o=;
	b=6ce1PkpPwEJY8/sw1VeEIUf0VOfVQrs5CGY9Jgr6Vk53XaBHWZmxAD9aRuG4rlNL7c7XlD
	XmqCT6Muze+OcDWDq3rOoQ1xi8Y2VJ6WUXTxKnvT2IqBE7l+VHz/XvnBirqSsglSlrrNrW
	UzkJCexwp9L10IpDdgGBQJDG/7JWYrE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787769348;
	b=cvGmbpRJV3zdbOSFdCF/BSZGpPsUK60jApGe1+lw8MtY9Q8zDH6LvjkXuAnFqCkIxfrRMP
	PFpL4gVhIabeJ7Y9SGJNvZ0NGeiihG5fZY/biQMvrQWfy6JuRBvP6sr7cVu1FY1yxANEgH
	xyDpQaUcs/BSZ1AvB0a0gqxb1Ya+HBs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hhDrfRDY;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZyrhrAm7j38NGOmipO+o+kjkSYfh0FE7Hm9WXO5o6LA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787769346; v=1; x=1788374146;
 b=hhDrfRDYhKkfpSwP9PNCv6Uakdp4iyxNRK9IYGEw6fc0T9fBe+6KkcbdIto8F+rvWFfzIL2a
 LzucZZv8LnyK9Ou0J+wMdvcIkyok/GhLLfVtAgBN6AhAg53uFvt6UiJsUkgSqWFSwHMACzX9dPr
 txGaB6Xr/bs9Cb9Y0gytDlJI=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:b::)
	by smtp.migadu.com with ESMTPS id eb79b8ec4e60aea3;
	Wed, 26 Aug 2026 18:35:45 +0000
X-Mizu-Trace-ID: eb79b8ec4e60aea3
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 11:35:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: remove unused memcg parameter in
 calculate_high_delay()
Message-ID: <ao8x787ZgJvUvhbr@linux.dev>
References: <20260825120153.1405-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825120153.1405-1-hongfu.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF29F1C0007
X-Stat-Signature: zwe8n8ru6pd7zg558rhgszjd7dzzow4h
X-HE-Tag: 1787769347-318734
X-HE-Meta: U2FsdGVkX19r+mzChdSl0f4UIpVRnVYb10WilJmR5MTZxoYg/A3B/zrtFn83GWSt05upgJBb5N0QjO4DTkHS+TVx8KYd/LlgD+JNWmTiRzC15T7t4mEHeZl1BXn4WA9muizW3YqbyxqDYL/bNs105mZC6NKbiXY5+X8GPKIXVr1rs64+1u/oV2iKanKhVxJNFEiAxwpGY2mp8X5Jmuq/6l3tM8kLU7f4U/SfcQffNzalEvHcCOXF1nXlTTmE4p4mf/q5fhtzv9m32mrRhZUzvvZkNdrS7wExfLgvsAPBpMTkjHhZf+4y9fEZAGnXBdgE5X5Wv2CAzzYu6MmZv0m/Y8CFoNCpvtP8YS8mBIbCScs09W/uZx6fgyG+kia/8rB7tvpfthXVGwzJHbY9MRYHpWDBmWBVwtZ+Y2b7sRfuOxnzsmOIYiFki+FoW0yrMu720981x8LHI9HEcQ3iVleH9dnfSjgcFXQ8XsE4FaK4VYELJbBLg0OtMKRVZK7wvdEYEMWANsMTQfOmpIJW5v4jL0xvY3/i8YOGv/KRWT9js52b+ERzTWnUurP+1y1JyzZBFECrn9xlESTUlWSPorHfdGnuXQa1Tb6QjfjYUj46Je5PkOHFGDqRpeuJGR/cKDhVu3mxTJYTyNYF9njysuQtG5TTQst256DOnhxKfB/xRwdFyqM/mPqkB2IglYTJsrfjK6Hp6jUhAsPliBWXUlMdlVefm4u+Jvyw6fgQHJEeFDx48bemme5k+7G9z1rzgpUY/6Vj9A3yntvlbRJE9JW5kSJL18xj/6NDYYBEZUCWvmwkbmb+oFkB3KmAcl9ZiMbpnObwROSjsJrpT30wvexXt3YyXhjmZR32OywHuBOwolk/9kNqkOjyu8GZipR17UNlO7Nqb3r2kRkaZdgKmygZTDJ8WMXJIZ7jESYThySDKOABnwuO/KYX3oAdkVI33OY7YoBosmw58Q4jpWCsmzF
 rFdoLmN8
 zGKs/2fFu4Xqor/T7B/Ogc9pFhtrQ8k66NgbjpFqnv3sdjQfCrPJO0Xs2V2VDoBfdje2TxSd1rlYHJPMLewrVhL7qlVeZEkHOmJeojmr4rxzrb5nN8dVy7SGkbI+ivzzAogkspgygRU4nTWs0ufnjVOC+/lY+5NR4OVnCeHiDtiNZSc24GJ6tsCehx9V/CkaxDPUjJ6Gz+TkJZoltZq18AYw5uN6NC0iFfHvSISuqKjOWzaSR0K3k6lyKQhlOtpaZv2oGnIjikaxiNjwen6+9bNYar43ZwI9nHISIcXx0hY8n/EdkDFFwnpYyXAFuifMr84ey1r5NV0PeNksvwyT/wKakaKLyPZYXv4YKp8DcSqjo1ac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 08:01:53PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The memcg argument of calculate_high_delay() is never referenced in
> its function body. The delay calculation only depends on nr_pages
> and max_overage, and both callers have already obtained max_overage
> from the same memcg.
> 
> Drop this unused parameter and update the two call sites inside
> __mem_cgroup_handle_over_high().
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


