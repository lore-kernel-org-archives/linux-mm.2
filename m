Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67CEDCD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 03:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F9A6B0005; Mon,  8 Jun 2026 23:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8006D6B0088; Mon,  8 Jun 2026 23:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF5A6B008A; Mon,  8 Jun 2026 23:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58CC46B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 23:21:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 061FD16436E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:21:31 +0000 (UTC)
X-FDA: 84858923982.23.8EF17B2
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8DFD2140007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:21:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FZke0vfO;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780975289;
	b=4rqjlkRcM/WWveeGSUVQOeinuU2s3lKSUH6aKj0qObsYj8GgSEsvwMcyXWlDjTcCU53dZt
	wwF/KA5vRUG0os4DASFBx1htOtplB+7JPa/SV1Isu/WUI4tSaP8N3DXkVE4jKVg1s3rVzy
	i1wnf4hESML+LXpzcoxHDuxDFkiINJQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FZke0vfO;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780975289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlehNq+dGhjF8xlBwPq9xUEl93005P8DJEDN49foV2w=;
	b=6YsNbMZuSJ2Qqkcoinkm7lEg35vLNu2x/t5EKS7SskgkhygOgntOqgzDII4CaDYG6G4+YQ
	cApm+OB39xxAv0TVXPlQlIbB+vq9RONXLF6sOsJP/iKiJ4WxPNpZohLrfbjU9mBfxhldJB
	UjBp8dMA+oKFPT1JFBwkl6od1vuGU2M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780975283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xlehNq+dGhjF8xlBwPq9xUEl93005P8DJEDN49foV2w=;
	b=FZke0vfO68yr6RGe+gmExYKpGubD3NRE4r0BoJb/bgJd1TBzspF/AJkmv3vdYQ21xphqqT
	GO3OdzWzK4UGast1YrK+Oz22+ee21ay+UTrsAJ/sfTXt82KPv26klQsKExZBVj2Y82Gykb
	gWOI/qBsQAz01ln6jRz1jxcjWYDh1vs=
From: Lance Yang <lance.yang@linux.dev>
To: hannes@cmpxchg.org
Cc: lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	qi.zheng@linux.dev,
	yosry.ahmed@linux.dev,
	ziy@nvidia.com,
	liam@infradead.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	ryncsn@gmail.com,
	zaslonko@linux.ibm.com,
	gor@linux.ibm.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Date: Tue,  9 Jun 2026 11:20:58 +0800
Message-Id: <20260609032058.23770-1-lance.yang@linux.dev>
In-Reply-To: <ah3MuK3GuimKVORB@cmpxchg.org>
References: <ah3MuK3GuimKVORB@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8DFD2140007
X-Stat-Signature: 3d4ab9cg1ekc3ptq9yfkhku8hfn861id
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780975287-391202
X-HE-Meta: U2FsdGVkX19mqsDG0nIoHh1I3iP5HWzU9huqaPztPBNIpsqgkRpzFvTwpbDWhdHLykSMT6KqGESoWYFLrhsloljNtw+bHnm96p0GvheS2Zc7D2nLBTxW/HJH9Yic1evBnkbm9e4/ZErTgKgXdd1EJdHZfPxUMgj+hg2e4s12dD6SO7BQOaZZnLBvEC8QedU/19Yo49Z70PwRGkbouzm7+vcZMeRim7A+QyM1CxZ1bS5nNcs06QAl1EyDycCElIB8GadXMRMbQCHjR9JdmZYRPNPSFHrbCa7PBeDW4Ze5BomKNY4iBWVhP1HxBz04wPY6p3sT1zQnuZTdVO/NtRcAiDwYi+49G2EBuwI4HEBFkpN4booY2FaV+C4YW11Sx0P3uY6COwpbjL8KUAwD4igH/ZlLI7JP28l10J/Ix+NL9F+sUOoNwRB1mU1tkoCFczrqjSCF6mh5+LO7c/Eew4omBUS36AOw/9O3Lni1j/SRXZNuuGdg83nrAsX5+vm2FYGrbFLbTxzUaS1Iwz6O7LeG+Leoy+Z0wZMVVDU1kKwr12zjzOZnEbyluzXFOvTVYbA0OX3v3aYhwDVWbhas7FrKVCz8O3xX8vwi+cRf8lCjUQE4FKf/8hrmvZ2KfgIioALq4GTSfmXLH9hET9OqZbgQFqsPWza0a4T4LTC9ceK09z0ztckLSI/F8TPikWiPaV1fzJ7QCfHzFxmnQSjAbxp3a05QD2QpYU8mdt0wAFalysBvK1kB3elbNLlj4UiMewBhLN7/L7OTfOIQ5KjfjNtPq5k2HuTBQNoSVzeyESZxGQTZcrLe6QcZIXnZvOWs1yAqGKMS8IwE77Z+w05WjiGmy6GojnhiWl/HNsggPBLtMushvtimWlZfYwZsWtHhtgYzub/njy7crbto5v0yKyoZpT2nIilo423MX/101ohIAfnsVfEdO6A/gqGIObnDBi+fT5WtURWO+spMUearnvr
 RnTXA4SA
 AQSfCk87ZjugJV0O2DMCDtMz4deHDTJ7qSLTev5FUrebIpLVp3MUwlKoy3EHYVYdlw4qlS8WTo79nJmB8VAWHY+uob+29Z46yKp+7jKQ0gZK6r+Z5WtxmAZEzFtoIuk94VNrgGYGT2nQs6yZ0MwuLv+rl+QrGHw4V5r1XvMjbdIvrBTt/Le0ulqpxp5JUtF62RSCI77PpE7Nsn2+nNNDhZjljLUrY/hkzUrfkjLVyI3Gj7hk/Y9T64XYjCXJB2422xqyylnZUNem/Lj5ixY1N0sri7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 01, 2026 at 02:17:28PM -0400, Johannes Weiner wrote:
>On Mon, Jun 01, 2026 at 09:21:35PM +0800, Lance Yang wrote:
>> 
>> On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
>> [...]
>> >diff --git a/mm/swap_state.c b/mm/swap_state.c
>> >index 04f5ce992401..9c3a5cf99778 100644
>> >--- a/mm/swap_state.c
>> >+++ b/mm/swap_state.c
>> >@@ -465,6 +465,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>> > 		return ERR_PTR(-ENOMEM);
>> > 	}
>> > 
>> 
>> Shouldn't this be limited to anon swapin?
>> 
>> e.g. vmf && vma_is_anonymous(vmf->vma)
>> 
>> >+	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>> 
>> __swap_cache_alloc() is also used by shmem direct swapin, so shmem can
>> get here too when handling a large swap entry:
>> 
>> shmem_get_folio_gfp()
>>   shmem_swapin_folio()
>>     shmem_swap_alloc_folio()
>>       swapin_sync()
>>         swap_cache_alloc_folio()
>>           __swap_cache_alloc()
>>             folio_memcg_alloc_deferred()
>
>Good catch, I think you're right. I shouldn't have dismissed that
>branch due to "/* Direct swapin skipping swap cache & readahead */"
>
>> @Baolin please correct me if I got it wrong :)
>> 
>> folio_memcg_alloc_deferred() itself doesn't filter shmem out either; it
>> only allocates the memcg list_lru metadata for deferred_split_lru:
>> 
>> int folio_memcg_alloc_deferred(struct folio *folio)
>> {
>> 	if (mem_cgroup_disabled())
>> 		return 0;
>> 	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
>> }
>> 
>> Since deferred_split_lru only queues anon large folios, doing this for
>> shmem swapin doesn't buy us anything :)
>
>Yes, agreed. I don't think it's a big deal / show stopper in terms of
>user-visible effect, but of course still worth fixing.
>
>I'll send a follow-up patch.

Thanks.

Looks like this has already landed in mm-stable. If you're okay with it,
I can send the follow-up.

From: Lance Yang <lance.yang@linux.dev>
Date: Tue, 9 Jun 2026 10:56:45 +0800
Subject: [PATCH] mm: prepare deferred split metadata only for anon swapin

__swap_cache_alloc() prepares deferred split metadata for large swapcache
folios.

That also covers shmem swapin, because shmem_swap_alloc_folio() can call
swapin_sync() with a large order[1]. But shmem folios are not queued on
the deferred split queue, so preparing the metadata doesn't buy us
anything there.

So let's limit it to anon swapin.

[1] https://lore.kernel.org/all/20260601132135.14272-1-lance.yang@linux.dev/

Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/swap_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9c3a5cf99778..7adac957c2b8 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -465,7 +465,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
+	if (order > 1 && vma && vma_is_anonymous(vma) &&
+	    folio_memcg_alloc_deferred(folio)) {
 		spin_lock(&ci->lock);
 		__swap_cache_do_del_folio(ci, folio, entry, shadow);
 		spin_unlock(&ci->lock);
-- 
2.39.3 (Apple Git-146)

