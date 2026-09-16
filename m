Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 202F2C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 00:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE666B0088; Tue, 15 Sep 2026 20:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B605C6B008C; Tue, 15 Sep 2026 20:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75096B0093; Tue, 15 Sep 2026 20:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 802DF6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:00:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1094816052A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:00:15 +0000 (UTC)
X-FDA: 85217667990.16.27E719B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4BFCFC0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:00:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1C59dYo6;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789516813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsG2UJoJMhrVhGOcp/RTa9rgqpxI7yatSzmwd8yhhxk=;
	b=WxYfLwoa0IFS6nFYZpfjT+/zJgcFmp321nAv1ty4SiOgJnzEhsw9Apk3IV2ope/ZuJsEXh
	ODzoJAhhErIZIqiG+hk8Mx6YbsiAbE/7P/hjTgca1as4MCDDbzXskXHJO36XLAvpooyEQI
	d+b+o3HOzdw/z+CO/7ow78pe+z0k3c4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1C59dYo6;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789516813;
	b=0Be4T55wJTq8rS1mfhWeasWsHaMN+COyZ1Nrl9tdZR8OrbwxUbhrUN7W9L8EGhaj2YQ+QW
	yB7bZUJYZdT2yTBr0GjVs3VplXqkluRUYon7S8DKmXfRmtiWiE0VtJN+ILrKSDTH30+24z
	EEuwNQwbur0VCoQPQ9262ac8lakjNEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 604F460008;
	Wed, 16 Sep 2026 00:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F96F1F000FF;
	Wed, 16 Sep 2026 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789516812;
	bh=lsG2UJoJMhrVhGOcp/RTa9rgqpxI7yatSzmwd8yhhxk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1C59dYo66QV+RKUWZNkNSJKjp2seecbRk2ujMq+oeftUoRIcPPX+1yEcLeM93SJfK
	 jYQVNI7P5FG0EJ4uXrKQCUTc+hoLutKaGcdEzB46e0LhpElLl6z7MS+yfZX2XV3KbF
	 WNG9OJOwPzGbwY25294h3e7JSRzmaBn+ojJclNIo=
Date: Tue, 15 Sep 2026 17:00:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan
 He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil
 Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com,
 kernel-team@meta.com
Subject: Re: [RESEND v7 00/29] mm: PMD-level swap entries for anonymous THPs
Message-Id: <20260915170010.0667b6dee268fb6fb29a3fee@linux-foundation.org>
In-Reply-To: <ae847e8a-8c16-4170-a18c-19adb1a50de2@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
	<20260914203237.7cdfcd4c320470f4ae5cafd2@linux-foundation.org>
	<ae847e8a-8c16-4170-a18c-19adb1a50de2@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4BFCFC0002
X-Stat-Signature: zte958qujw4hks6kcpejpxs1y38jxmqe
X-Rspam-User: 
X-HE-Tag: 1789516813-913162
X-HE-Meta: U2FsdGVkX1/35EpitAWATP6utVjKjOLaaqJ2UpCR8YHb2/i+tc45lKj3IzMaEzxOH3VqU10C3RQXIS/rr+TI0hUnKKGyB1/FUmkF+qTi5nx5iqhs24ZoxRIqYJa8aI/K0Mk+cF6c1BOqxlXxJDWt80jqqPq8jmtPp2CZqnxPiOXV7YCALsbq7kSUIwG2L4vfPKbVJIAnLt9EGkboeYAN9dWropNprShS4H8S+pMHcepOB50oevZNS50MgPEbi3PA0PXYWhLHVxdf4eLrPGmUVJHT570p6pGI6+73gksXt/PP34ePxB6VVPdA5Q7GAaWRqj65j6931I1T+ItrMzE1UgkAjkA7z4bAzG2porVBXTVWmh4uifkCw4SSeQFrrk+/CjzUzQj1LgikC+1KWZKSaz/9m/JGqImeOofAhTGximRebbGi4mpP4E4tK1OPZdhyppg0Qs69R1CpEmQNq9/dvh2X0o1ZLtOmGSEAq5jNGjmCF715h4vIwiJpFlOnOmHR7hOIWcymBqVst8PKOLqY3SfSGYWC4t0b1u6oVTHYOxf3azCmxuoCjEIICbQpfKxdf+Pka1uKV1PPTgs6H82cZE2JpZLsgbG3roHOr9FcRXsLkrwnqB2GR8aepyYGPXNXmVBRcO2q6olVlDfrKGO91eivcHfUxHYiCXDAGw1gSealrtBV6y32U27hH243KkT+wedGfgAZSwyUcpCagNqD0pf73TC1veXVnk9QUvyXo6GgVQvs46ekX9ULPn8+ZIIotrwFHOKWFeZ1lFsl2uhgy0OhMh+Xf0OMpe8hc+e4+Lp2HkWwbqxzhnpKfvCUvBGSGM4/PV+nqAdg/IqN8pB9ToJW3Os2JRFpQOdsgqkUnlpjHMAPsQWzm1eAuGZb2G/ScABqdiBPq1mafYvIyPBKJ71JnBAlv7HUXoJk/W2/l4+C3H0kQtuFot0vtgQl5GUP6e4gWgBQtzx15wrAlfn
 mFRGypVg
 McuNYML8k36bT+RxZPniDkDvfKtMxMuyrwXkhBgL1RVMPMX3kejzj78U9VIVmVW1PCzG/inJUqFqONfVE9gOccD7evNbdy0O5YaMrpc91HeE4tHoGxkXA7fFZiF2SmcLCHoq3tcKDH8XdmRUzfWKH59X2fNi90FvU8mABN7VOFT0/p72KhdZKyymHBvv5jUzwNg/B0dxTo5slf8BhoqiDWjNvwZhKRiPCnFTte85VoXfHq+OEGGCHyldQWA7AaSeyvsvy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 15:09:16 +0100 Usama Arif <usama.arif@linux.dev> wrote:

> 
> Four workers repeatedly write the working set, forcing memory to be
> swapped out and back in. The results below are the medians of five
> interleaved runs per kernel, following one warm-up run:
> 
> Metric                           Baseline median   Patched median   Change
> Aggregate benchmark throughput   584.3 MiB/s       2,408.9 MiB/s    +312.2% (4.12x)
> Elapsed time                     85.43 s           20.72 s          -75.7%
> Major faults                     1,814,699         228,466          -87.4%
> Swap I/O rate                    1.02 GiB/s        4.10 GiB/s       +303.9%
> 
> The results look good as this is a swap-intensive workload.
> It primarily demonstrates the reduction in swap-fault and page-table
> overhead from preserving PMD mappings.
> 
> For long-running workloads, where I believe the series will shine, I expect
> benefits from fewer TLB misses, less khugepaged work as well as less kernel churn
> due to larger folios, although there aren't a lot of benchmarks to test that.
> PMD swap entries also move us closer to eliminating page-table deposits for
> anonymous THPs, which would provide memory savings.
> 

Thanks.  Wow.

This doesn't look totally real-world but it's close enough to indicate
that real people doing real things will see nice benefits from this
change.  As expected - leaving post-swapin thp reassembly to khugepaged
was so lame.

Please add the above info to the [0/N] and maintain it.

(I'm itching to get this moving ahead, but we do need eyes on those
core bits).


