Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC76AE9A04B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 19:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D516B0088; Wed, 18 Feb 2026 14:53:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB076B0089; Wed, 18 Feb 2026 14:53:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD1D6B008A; Wed, 18 Feb 2026 14:53:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1306B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 14:53:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ABBFB1402B0
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 19:53:23 +0000 (UTC)
X-FDA: 84458626686.06.61D1A20
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id A522920005
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 19:53:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V/H6/jAe";
	spf=pass (imf13.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771444402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdnOU1vGQA1zKpk8kTMZsw9c7ygfqJl1OhsRupZBpf4=;
	b=Ju+bsqahzx2y5fCguhoCvJezG4bS8q5hbBV+ojzGKsb4SspxhL+hTi5dpIcGxvdRfNywC8
	o88KFuiB6l/BKGPqBxi1BVX6mFVZ2QXdeZaYv7861Q/83dHZaxmdWCTUxEi1TSNFsgvj+S
	JWw7bq1V5y6eDrhrBi9bw1kmZOD5Pho=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="V/H6/jAe";
	spf=pass (imf13.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771444402; a=rsa-sha256;
	cv=none;
	b=aNgK1v1QNi2R8zNmM3UohINpKiay1nqkArC9A9gmYa7UASrGsW+FCqby/0yz+5iBHAu44K
	KqWOnN/b+d32BcNcOwwal/A2Tk5XTZ9qs/SlI5F5GMKRYpdXKiPgRaDhiSTezAL5RDYyF9
	Sfr+mm6eEDNJy0F3fZUAGfJJYFJjkoc=
Message-ID: <2397f4cd-367b-421c-b4f0-9c023f6cd546@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771444398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdnOU1vGQA1zKpk8kTMZsw9c7ygfqJl1OhsRupZBpf4=;
	b=V/H6/jAeNBwT5tg4U5BLn/eRMm0dPifz25S3hPq141ITU5c0PWXjdPTF9DGOYil3JLG5j+
	Zg9OGti2fviCFqs+oDIJ0JIwa/ctAUUTxVZyVwbNDChuLvtnfkczZH1sVIHbZIdXvkl8y9
	O45YbBEP+0PZLGANix+9dkY2yESN61w=
Date: Wed, 18 Feb 2026 11:53:09 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: move pgscan and pgsteal to node stats
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 mst@redhat.com, mhocko@suse.com, vbabka@suse.cz
Cc: apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, rppt@kernel.org, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260218032941.225439-1-jp.kobryn@linux.dev>
 <10434f89-fe2a-4cfc-9b29-1cd2ed2bbb7e@kernel.org>
 <fbcd6770-f555-443c-b5f2-fe5e73722118@linux.dev>
Content-Language: en-US
In-Reply-To: <fbcd6770-f555-443c-b5f2-fe5e73722118@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pp949ricaxoyubzs59hyajsqktd8o69n
X-Rspam-User: 
X-Rspamd-Queue-Id: A522920005
X-Rspamd-Server: rspam01
X-HE-Tag: 1771444401-898519
X-HE-Meta: U2FsdGVkX1+m4CyPDxcY0jDYASog4ViCbbnkFy2UWCZl/NvVv8GrcpSjKdHXDbIXUTPL+pco5bg1DEdafs6B7mrxe5wNYwLFjy6Vy/XuwS0G5W6Pc3GgLZ/ShoRiKUeSWQL8PtKRDsk2DMQmxJFiMPiFmNeafM2pzUzMZd8eDetPbf+AtrRSf9jhRLuXmfesgTZVudQc/m4VS4jFZ097hzlEHR2vJIDwTlZ1XP1L1r7RucsY0jy2eERrYe6hRw7+maxVK8YXEEowzybJKSiq2b3LNO/LcktaTy66eC6hFpJ0ZcZamUoPqN3YDsoSGcRj9f/iv+cGDyPXw6D0Y5x6QOcuLZaMlx9lCmTrivscrH3nWF8LQCAjtaHjJltVoU0Lt3eg67SUC8UfenMOjFrVNWe6SfBm1w8uCXkExmvfAzzznyt3WJjcExaDO5VCuWijC4kPVGlwFEkZ5V3/WHe78qH89BLSieVBhJm+PRY+HzQTlfNXYahVZL4iy0aym9eImXGGYd8rfjkL2bwtNSeVl/utkIoBzux9SY3DVI4TyfbXo1KIn3633OBaqsIlxNWP6vsF5AEcC4NFkXNB0Vv4tSEMq5ZO1xBigCEOTuhMaKZXssW2/P5ZNlRe499jOZRz8PANyz0TcGWxDRMlEVjv3E9qdHIR23ZNs97qJkzBoBTi8l0QY3WOrbn7QFMsM6/sj1jlXiljF95mg758ebhQ6xHSsHfuUqr+bi1MCEABMKyh+b/9yI7bxMhBVBlezyg+e/GtOIlTnAEWxyChVve3fItcl7UcsDhMlaD8id3QihhGG/KdEmZtdh3BdIFlpONpa+nIrMAhHG2T3xW+5fhyZ0q4xE/rwMRgwvdClcaxBQQaiMePWYJeKxXOjRtzaqOSTIX/IEeyytL84n6DYui9b9bhgG5UP+EtZZbNAmt1KD8S1IR8GvDzaTiC4RAhAYXqr+Td7moBmO0ILeO/JUv
 ycyXjEjD
 CBbhDLHkU1H6InWeHqsysNZED9MVlebQ4kqRBk3jvqiwAoAwU4gNSekZepUe1dhtHMn2NxnoVzcZDDinaGaHqEQvOD78SMIsEiO/MKsSaLoDZPOc059oZyEgfwNa2y61LCUJvpwvItJ1FT6OSkEnvfYOW3xxEayfG5iLjgWvcT6ziuNu4DYDXOERHC7H3MfZp1sImz/HZeIndgMlTQZPpMW3ZCx1oP+q9C9d0QA8pYDTze0au4IwIfd+ISQrojfnYYMP3QVmRtEZBUjbFwMtqW182bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 10:02 AM, JP Kobryn (Meta) wrote:
> On 2/18/26 12:54 AM, Vlastimil Babka (SUSE) wrote:
>> On 2/18/26 04:29, JP Kobryn (Meta) wrote:
>>> From: JP Kobryn <jp.kobryn@linux.dev>
>>>
>>> There are situations where reclaim kicks in on a system with free 
>>> memory.
>>> One possible cause is a NUMA imbalance scenario where one or more 
>>> nodes are
>>> under pressure. It would help if we could easily identify such nodes.
>>>
>>> Move the pgscan and pgsteal counters from vm_event_item to 
>>> node_stat_item
>>> to provide per-node reclaim visibility. With these counters as node 
>>> stats,
>>> the values are now displayed in the per-node section of /proc/zoneinfo,
>>> which allows for quick identification of the affected nodes.
>>>
>>> /proc/vmstat continues to report the same counters, aggregated across 
>>> all
>>> nodes. But the ordering of these items within the readout changes as 
>>> they
>>> move from the vm events section to the node stats section.
>>>
>>> Memcg accounting of these counters is preserved. The relocated counters
>>> remain visible in memory.stat alongside the existing aggregate pgscan 
>>> and
>>> pgsteal counters.
>>>
>>> However, this change affects how the global counters are accumulated.
>>> Previously, the global event count update was gated on ! 
>>> cgroup_reclaim(),
>>> excluding memcg-based reclaim from /proc/vmstat. Now that
>>> mod_lruvec_state() is being used to update the counters, the global
>>> counters will include all reclaim. This is consistent with how pgdemote
>>> counters are already tracked.
>>
>> Hm so that leaves PGREFILL (scanned in the active list) the odd one out,
>> right? Not being per-node and gated on !cgroup_reclaim() for global 
>> stats.
>> Should we change it too for full consistency?
> 
> I'm fine with adding coverage for the active list side as well. For
> completeness, I could also include PGDEACTIVATE.

Actually, I see PGDEACTIVATE is not gated so I'll leave that one out.
I'll send v3 and include PGREFILL.

