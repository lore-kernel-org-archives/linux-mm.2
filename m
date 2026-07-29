Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7139DC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 19:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5890C6B008A; Wed, 29 Jul 2026 15:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558196B008C; Wed, 29 Jul 2026 15:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471A86B0092; Wed, 29 Jul 2026 15:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22AC66B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:11:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 962AE1A07D2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:11:41 +0000 (UTC)
X-FDA: 85042758402.23.69B7268
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A95D6180008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:11:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nveK2vs1;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785352299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeAVASLt1xfqzH2kWzyGKnQBktx/E+ICYqy+dRpovE8=;
	b=UkEVcbDvJXpl/YsqQop/Lbzfy510LinQRh34Arucj6G2yByEy8Wio6twxxBuEO8j1uNhOy
	AlogbYuLwm47tFKpr8Y12IXH1geK8n4ZxLoG6abibMdgWfBbRks5incQH9+qqI8WMr6RaU
	WyHKyRF1fSG48GOawmRheu7U0/A4Kk0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785352299;
	b=6FSfzPQshjNM7mND+tE7YhSstHhWusx/E7WbzYlO3d9buyWK9BihXYlLtDPBkUbV42Fx+t
	DASMd/JSwuWUDpfvRiYLbC8AngEfrWQa1Nex+4SHP1ych5sxp9AXgmQpH0ZHPm8eDJsmTO
	veV7ew/YAiWq3siB7fDb1xdfNBCF/HM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nveK2vs1;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C4AC40D84;
	Wed, 29 Jul 2026 19:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACDA1F000E9;
	Wed, 29 Jul 2026 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785352297;
	bh=SeAVASLt1xfqzH2kWzyGKnQBktx/E+ICYqy+dRpovE8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nveK2vs1xLamt1UbpK3AMBM7CbGuT7Ed0jQcN9YMvhn/YiSaiu/kcZ/Q8CKyQlZVs
	 G8reWDb1FZY+GbOUw52iYs5HtRT7h+Pn3GOGbylF7L9DkDMEGoUCMLZDDgUFPAjuUj
	 TwNSMhYBI+xcOCvurACPEi5/Hvm6MPu3XGu9X8qA=
Date: Wed, 29 Jul 2026 12:11:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is
 superseded
Message-Id: <20260729121137.7b451d2d00ca5a389ebeb848@linux-foundation.org>
In-Reply-To: <ammzjkUIADCxO2mP@tiehlicka>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
	<amcT75pLmA0hRUm1@tiehlicka>
	<615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
	<amdkHvSMj95DUri5@tiehlicka>
	<f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
	<ammzjkUIADCxO2mP@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A95D6180008
X-Stat-Signature: 3etkfc5wxz84unix6cqkmure3xe8nsko
X-Rspam-User: 
X-HE-Tag: 1785352299-40389
X-HE-Meta: U2FsdGVkX19UpBG37rV58Buk3fzUB9WF6EnsKF85LiaBf1a7Rroe3WmiCwJUb0bTNGQtTEvj0BYoMv8AizfFF5vzKbQRqIrM92Tu0VBMRKmVHpdyESKHyfyfAUhKkM0NBlwhUJjvwBupto/gldde2TgU9UotwHb1s83eoy6xhI1V6uWiavY0yMxcL3YqQZDKNwSXALy0+h3vfyTNCqDHpve9W6R2scOPjex4mjT7WUOQhRgn608N4jjXUvKdzsmKl6F+9ECOpbRzYIoZTlChinjBJqQRiu2t6lO3YhxXcReqgCTbehoBAFUXviry+XxnZFKFxZjSsHdnNKdOHOhrk4obimACVZrTsJayWGXTeRP9o02WT4oI1UNGFBrKYepFz5QAAAS1vjl1V3fPPesaWoptzEL+9lBp2zoakuH/7ewLECR1DLhb22en8AILh8MwSE6modm3acv3tpFca0ONCqAjry5zNRjm0VzFbNsjl7eOD+nrT9H1PFCy3QNZ3FruyOHFCub+nCSy9Hqej423pez+7No4PtxaxQ39wYhDZMnoQylFpWreJHEiYiWRLQ+nWZNUj33qPCzVvxtYCiTmH3RDwXwDAO7duihBpm0MteFWeas7bogudvTIaIt/AU29jQfs27eES+pKICy1QxNy6BEXTWvTrdIAv7fz3UcdlZh18F499ruEqey+PS227lh00Zh8fc7r2IgbRlcmUcTsyFQn9MsuksP5INeSeF9ia/SjcZxKSLy+5W0tp9xRRmIptMhZ7mjwIOK5fIjRSOuTYN5MgzveMOpX7bByt6NKiRDNR9OGC8pOjBiQxEAUZOf9ACdpA7r5NvvKbf3cLhtTLeqwjweYQo+/kjd99ZCNjtiFYcR1DvdV4n+iL5jkzUfIQki3oQkYiHThDh61brvHCUyzp0FgvYjI6lWT9/x66M+l9+8SNhuE1d8tBvvEpxD7AZ7Rsr+Vd9E//aTx9tR
 7RZerNao
 UXlFWVVe0Zts6eXnbKvtE2BjM5Z3vP0Cs+WgG8gNiQdUQMOaWZ64eEuevdfv9AdDt3na6/1ILqPqrJV6m0f5Rm2/VEREgVw7YLaTqCTglWNxzWVJP+f4Mh9DMjWZyMvQqTVjNrX80DdV/IuChkfwU86WxTaXJQda7Hl/pA7rjn0M8wtari9ZeNFMUxYn59qW7KJprwOOVgXSdOkZQva/V3yAMpbSbup6ZRNbht+5rvoI+gMUnAlB7Oy90tVtClsWnMEHcsg7yKtVRhAnkDDcwHK2VSaz3B0SnmVa4Ko8tiGipyohnm+d0cE+0wsb3XeaphF6PJvkogsMYhxiBMyDmfUbdeZ1H1BUHlsRXmTfixfKSAPzmQ8q3abjxZF0mg7mSk2UT6KOIYPxRNvBt0hkR5q3wCGIT/YS03UWPy/hUU5zTUMaPu9o9q+dkwOnfEefjmeaaNKoQpuZt7mU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 10:02:22 +0200 Michal Hocko <mhocko@suse.com> wrote:

> > > Is this trying to replicate any real workload? One would expect that
> > > writers to limit do some sort of coordination otherwise the exact
> > > behavior is not really well defined.
> > > 
> > 
> > No, this was not motivated by a reported production workload. We found
> > it through automated randomized testing for our cgroup observability
> > work and reduced it to the reproducer above.
> 
> This is an important detail to be mentioned in the changelog. Describing
> motivation for a change is really important, especially if it has direct
> impact in user interface behavior.

I've been adding details to the changelog as they are revealed to us. 
Below is the state of play.

I await maintainer guidance on how to proceed with this!

The worst-case effects look pretty bad actually.  Should I add cc:stable?


From: Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: mm: memcg: stop reclaim when a limit update is superseded
Date: Fri, 24 Jul 2026 10:18:05 +0800

kernfs serializes file operations only per open file, so separate open
files can update the same memory.high or memory.max file concurrently. 
Both handlers store the new limit before synchronous reclaim, but continue
to use the writer's local target in the reclaim loop.  If another writer
raises or removes the limit, the first writer can continue reclaiming
toward a stale target.

For memory.max, this can leave the writer looping indefinitely once
reclaim retries are exhausted.  The OOM path sees sufficient margin under
the current limit and returns true without killing, while the writer still
compares usage against its stale target and records another OOM event.

Check the current limit at the start of each reclaim iteration and stop if
it no longer matches the writer's target.

Reproducer:

Populate a cgroup with anonymous memory and disable swapping.  Lower
memory.max from one open file, then restore it to "max" through another
open file after the new limit becomes visible.

Without the patch, the first writer remains blocked and repeatedly
increments the OOM event counter.  With the patch, it returns normally.

This was not motivated by a reported production workload.  We found it
through automated randomized testing for our cgroup observability work
and reduced it to the reproducer above.

Link: https://lore.kernel.org/20260724021805.1234583-1-guopeng.zhang@linux.dev
Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-stop-reclaim-when-a-limit-update-is-superseded
+++ a/mm/memcontrol.c
@@ -4837,6 +4837,9 @@ static ssize_t memory_high_write(struct
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
 
+		if (high != READ_ONCE(memcg->memory.high))
+			break;
+
 		if (nr_pages <= high)
 			break;
 
@@ -4892,6 +4895,9 @@ static ssize_t memory_max_write(struct k
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
+		if (max != READ_ONCE(memcg->memory.max))
+			break;
+
 		if (nr_pages <= max)
 			break;
 
_


