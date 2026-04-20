Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A65CFF588C7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2156B009D; Mon, 20 Apr 2026 09:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4BF66B009E; Mon, 20 Apr 2026 09:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13316B00A3; Mon, 20 Apr 2026 09:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5E46B009D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:16:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E6461B8EE0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:16:19 +0000 (UTC)
X-FDA: 84678982878.01.ED16807
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id CCEE940014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:16:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T2LV6+Is;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776690977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsatqlpFXZFNi8Kl9ZLgdLvl4wOAHcOCp2o0dzIKpJY=;
	b=LZBloOcttXhfTWFcEA47gKSIxPyFgKgTxUUInEjzoILgBxmjI7j6ITDhgbOQYSn3Xza7qj
	vqrv6zuCcBy9Wa3D9k87ZHM6R/foVMK+QSBWpsfZqTnYObf0LJhRF6yj+moktVfVikpaJ3
	ju6Iolp1jS46+xQuSJHwRtkCw8Ib76g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T2LV6+Is;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776690977; a=rsa-sha256;
	cv=none;
	b=aRg345USHt5DUmZBU8Gjdd4h0SJKIri8NDq1Q3utVj2b6TG07T9cP31HzRXmxPQhVM3Zea
	G0au9A4y2SfAgGC3qQZqooyd9QqJU8P13GnxyJ/lR7hb3wT7Hkn0+pyWW9PSBFi+OJwFzi
	qM2bmXqZ3wiYIsTjvWbiZuZzdlSqEpQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776690974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BsatqlpFXZFNi8Kl9ZLgdLvl4wOAHcOCp2o0dzIKpJY=;
	b=T2LV6+IsNzeXUOci7LW3i7gkiXJBoEaQxrMm8jqfQoQgsCiebwzcF3GmF6j5s+nonfNmAl
	ihVck8om9+Gy2IOQu2HefU5g4FAUS4zaBANZdgWWntieO5VCLJfyqhW7Y5foXCOqj5+976
	y6CLSWU58gqI2rcnbNAfmn6UjTr3xLA=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 03/13] mm/khugepaged: rework max_ptes_* handling with helper functions
Date: Mon, 20 Apr 2026 06:15:48 -0700
Message-ID: <20260420131549.3673619-1-usama.arif@linux.dev>
In-Reply-To: <20260419185750.260784-4-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCEE940014
X-Stat-Signature: wsicmbbq7zs9n3na53w3kyk5t3qzahqc
X-Rspam-User: 
X-HE-Tag: 1776690976-616750
X-HE-Meta: U2FsdGVkX1/ECl5M0JE7ivAfKysBLnOoM7/d20gQvS8sJF43jQVkILoVMepOBjcY4mrr4AVdHz52parszaSum0yEnYJvWzuwYvU0Wx+phqzhJAq8DrjtrxIUICUJWO1DGn84yr7p4Zo44mrD0AzNZL4crfZwWTDIMuH0+DKB9Lfka1Up4IgGtbIlKk/ZDL0QLkirV9Bh56BAgtXIueYbSSNeFHc85+0d9EyMgwmus4xeTXz8ktR9ejd6gvXKKK7tw63yvgwGL4th5tpAN73S07Pp0CXlWA4HRg5YWmLrdPbgs2+Y070wWJsE+eup2xNwk3eVE8tKUrlipX1oVAClSdEb9D6hX79+jc+TVbqeRDF5O7yaYFPK2wPQTZ/lMh/mxNMhZF1k8MT72h9vjdDu+xG8tRL0Voo8dHJD9kSerrsDcdWP9YODq+wosb7RmijpU7kWuTxtWDpk5P0PyzUT83DEFU7xCklAAMmCEQzP1LqZs1bRawaUSO3FeadLG9vXVkkOe/2hM+rZ0aQ9Uo38h2OxJ0EdokeMJXGVMWhVqkyJZxhBfiVsW0KvABrHPNRFSGW8O5G8U9FuBFs4d7mGLUqrqCg8GnvA+606eodqI6Tbljuv0d234BtKi16z4yauMXawfA8LYjwVHrKmANXh4L2VEtnvaJO0N42zrj1g8huaLHDCGhQg5ZVB+DZCj2aIW9KiGE+0LysGIaVQw0yXneI+HWqWorDKzGeg+ITm+0yt7iwt3lQRklaGVJLzqp8LMlif4r2zb2yGhywrwfhOdNu0JpkuFFWmr5Rv0FrrddJvIh5Txf86FDorIV8ottikaOq1I+4+Duk4bmewIwD7Dc0cgWS3KfpS4aktcRF6R7esA7o+TNYDV25dkwE1IYJ83PLLlM6iVrtVLxhIfRvBrArloSNnTn5vHY0ysjTg1XJCDF2Y9r16cFeVGjDH3zDR6M99bLlLS8M2I1Wm4C8
 W/GWYBtT
 TTGwe18kXb7pF9fZtwpTO+E40l9FVB4Rvmxtr1Vlkb5z+DYZ7jIH7+D3wGvfxLaZY1fzz7n8XK2Zk3lHNjaFWAk4xOVgKWADFIjceFrSB8SBeKZh9YP/9UXepwmD2ZoQ5L+wbQ9pRDMfgehi98PVcsPh1wp9L+hEQeUUP4biLxxmATwMja3KT4xSpYxREJ6fmNdpLH0ZZBmEl2KK5+7O4mNfdQA4sYACnaS6jUK5UaYuguI+PRTokloQi3WN9BwJ976vFlRG3JlQEOvvnH89Rqiazg2FJB6HItHNJBXTdyKXE18akY3U5V1F4GS0yQrufIxv6C03oC/VZCX5ZPzbzn2WOy9lU4DN82njIxL3d2fTijdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 12:57:40 -0600 Nico Pache <npache@redhat.com> wrote:

> The following cleanup reworks all the max_ptes_* handling into helper
> functions. This increases the code readability and will later be used to
> implement the mTHP handling of these variables.
> 
> With these changes we abstract all the madvise_collapse() special casing
> (dont respect the sysctls) away from the functions that utilize them. And
> will later in this series to cleanly restrict mTHP collapses behaviors.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 114 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 78 insertions(+), 36 deletions(-)
> 

The old code re-read khugepaged_max_ptes_* on every loop iteration; the new
code snapshots them once per scan call. If userspace writes the sysctl
mid-scan, old behavior reacted within the scan, new behavior uses the value
sampled at entry. This is completely ok IMO, but might be good to call out.

Also might be good to write no functional change intended apart from
above in the commit message?

Acked-by: Usama Arif <usama.arif@linux.dev>


