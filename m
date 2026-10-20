Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5324C606A330
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=jYdzB7kG
Received: by kanga.kvack.org (Postfix)
	id 5DCA06B0442; Tue, 20 Oct 2026 04:37:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D5C6B044D; Tue, 20 Oct 2026 04:37:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430CA6B044E; Tue, 20 Oct 2026 04:37:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A81D6B0442
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:37:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74157120908
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:37:05 +0000 (UTC)
X-FDA: 85342349610.25.D896B67
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf14.hostedemail.com (Postfix) with ESMTP id 450BC100005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:37:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jYdzB7kG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792485423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47AFo55bTUHeomUi/clfAPlpyaEvHVred+SgTB3/Ous=;
	b=PkerDvQO8SohUKZu4eUYuHcCOEtB4Dd05d4eL5DBnzC7FyPmayeq0cHQly5JJyU5KZt0as
	JCwoWf9GV0kiQpyaFXthxs9wSXVr06Qt+x1docg9jRH1AyCMVj2Q1jIZOg98PN3BTA/kvC
	sffOkkhkR96REDSw9PVWNUECWvPGwo8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jYdzB7kG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792485423;
	b=y5Ht89WQf8VoRfMTB42iMkiKXo1gKULw2A7kMJRuZHSlNFOj8ZQqxb54kU1ZNMHMT040YH
	/2NLBkWEckI5Z0wwILN6mjN+qNo/DdfV2knZoVwU/xbqIqMIBITNRAmYk4bvUadI5pK3CL
	VgT9d1BMa78K5lxfEz+NYOux8x+JzBc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792485416; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=47AFo55bTUHeomUi/clfAPlpyaEvHVred+SgTB3/Ous=;
 b=jYdzB7kGA0Hba7WfCZTIjuRRK7B4iYAqc+zen88TtjpqDyquimI0n5wDlOdftnsMOUovUf
 y00gGqoFL2W2zh32v1e6BYJx6SgkS8UwtARTsPw/hguyUSt0ZgHth/zwOTRCMVVbTJQ2A/
 WwLhQnwqjJ78dfSBMZtAL8kDPmGHYWNcDn7H0vGl6UqJe806oTIVfOldKYijFHQPo30oGS
 GC8jsUi9LndWo7p0WVsj/BW3ketjcA5uPV1y1l8SPMkN/aVGl8PV2lxz4B7tajuoXKxMnz
 mVC1TnTqOzqLfbGsTrOUBF1HxsOHlEZPhtSW7NbSO2ILt9XrchWttFBBSPpxDg==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <atYsvc9gIejcuwew@gremlin>
X-Lms-Return-Path: <lba+26ad72826+f770de+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Tue, 20 Oct 2026 16:36:33 +0800
Message-Id: <661ba8ac-de50-4268-a2f1-3e0a1a228e09@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20261019141401.11927-1-lizhe.67@bytedance.com> <20261019141401.11927-2-lizhe.67@bytedance.com> <atYsvc9gIejcuwew@gremlin>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [RFC 1/2] mm: add source selector to memory.reclaim
User-Agent: Mozilla Thunderbird
X-Rspamd-Queue-Id: 450BC100005
X-Stat-Signature: boaqwnfa6jzad98aq5n8p7pughtak8mk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792485422-437417
X-HE-Meta: U2FsdGVkX18ZkV27o487UxznIObEDmm5Pwiv2zR/JMfJ7GkOJNwYWi7JsJah6L/d6/rOOazELqznGKYrxNW1tX8+hJ2g+y+1a88l1utXBhVtDh7uEUNnUDhNHc6zRKnps3F82FoRuMaA17/jOlynZqF55ZoOLOMBDjufzduNYorxWFI4xEpK7GGWiJvI2cfDCwLOHnTcez3ZVifao0OzLMde4xfV2p3AH00L4CA2ZXO2aUdgIjEvHuun/6hIZYK6F1FCkn1I5YPSn9e6KLIJrkjkzonnc1OyZD/ib/QPJBCuP3VQ4o2gzTvzeT59E46rwUWW2FkOYEatHN01vxMVj6q9nCPSW4JFlpQ0D4q9Mo1b0p6tynIufT5MdyZWkprYS6uY2ekXvPHoi0IcASWn+FdEGJXHf75jt2/GSYiyg6t7MXlKp9q4dfHAMd+KVH4zc+AKIMqf/TX47ADiSYPre9E6Y87RnqDKXjPIborXgfvxHOzpp65yYsfDA4cx4XOwrtC4PcbWvpsty9pJsR0D3RkHFjbwzSD1q9gt5exNdeNgQylgHjHO90r8wG/DosrQ79+TM4fY0yOxPBCRflyoegiQv83x7iNoPFh87qtSZZgafhzmFbpp7XvbUvNn7oCgJ2f0fWvXxq97FmyEeDNGXmw4/yMw5qoBG3HVRpl3fKsxhiehSRDY+OXZ8K3ANlzREfI4BxeC2Y+fi4bm+AjwPdQ8qcFy2Ouc6b9rouqVSb7obw9JIVfSeuMAxvK7tu19Mm5hrJkFjnsENzGJ6VB/Smfjk5KTijYBlfkYkGMeAQcF1duJBvDDCQCVPEMiTpMqx0lXKOrjk3Q+wGlzYOCWkETvVv6uEFuUe2KaVp4yuWX67OHmN1P4LelIBafAc7f1uj1FXUjbXjrDTq943aZrZzRjU3SSBeqnqpG9NvDoXadNYAC9OvjBTlA3dLuN8S3Dzsv3h5H0nm8eSbIPwqp
 xuKOt1Z1
 FiknZLL282b0O3CUbe7dYIghjBhQcQD93ivSJdnaRHfX3XDTHUPCZyU5d/C4XV15Gp6Xv037DGupjbrxzok8P+uujyur5bG83yK4ffsLfTeCEict+YayfY9O689176JVDgIx5nqg4GjHx3QDa3d/PcV31e4tn7vD0Erw5sdBusFPu8ACkLyo92cWEEBPX092/CCHLOmWO42iNHDAhEunU177AepV+mD+2MCU7ArvoitEGdSg26fU3/rvt2w063jNpV5/y6aS9k+ky3l4JOq8IXoeUws/kKWu1sz4AzIY6hhx+f4uorLw6f/N7KS1CKEHgjR1NssFyhG5bLjFxz+mKzlFWeEPssSLF27nEUEp7McG8JfdzP5MLxS4eEimJBZ95qlxBtu2aqJzZipO1d3SHmhmqXT7lAQrdQ2cj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 10:51 PM, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 19, 2026 at 10:14:00PM +0800, Li Zhe wrote:
>> memory.reclaim was added as a generic proactive reclaim
>> interface for memcgs, but memory tiering makes its practical
> ...
>> The source= key is intentionally typed so future selectors can be
>> added without reinterpreting the nodes form. For example, later
>> patches may add source=tier:<selector> or other source types while
>> keeping source=nodes:<nodelist> as the NUMA-node source selector.
> Similar comment for the commit message as below re: simplicity.
>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst | 23 ++++++++++++
>>   mm/internal.h                           |  3 +-
>>   mm/memcontrol-v1.c                      |  6 ++--
>>   mm/memcontrol.c                         | 11 +++---
>>   mm/vmscan.c                             | 48 +++++++++++++++++++++++--
>>   5 files changed, 81 insertions(+), 10 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 86a2a0099178..a016575010ba 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1454,6 +1454,7 @@ The following nested keys are defined.
>>
>>   	  ==========            ================================
>>   	  swappiness            Swappiness value to reclaim with
>> +	  source                Source to apply reclaim pressure to
>>   	  ==========            ================================
>>
>>   	Specifying a swappiness value instructs the kernel to perform
>> @@ -1464,6 +1465,28 @@ The following nested keys are defined.
>>   	The valid range for swappiness is [0-200, max], setting
>>   	swappiness=max exclusively reclaims anonymous memory.
>>
>> +	The source key declares where the normal reclaim aging pipeline is
>> +	applied. It is a typed selector in the form source=<type>:<selector>.
>> +	Currently only source=nodes:<nodelist> is supported. For example::
>> +
>> +	  echo "1G source=nodes:0-1" > memory.reclaim
>> +
>> +	This instructs the kernel to apply reclaim pressure to memory of target
>> +	cgroup that are currently resident on nodes 0 and 1. Reclaim then
>> +	follows the normal reclaim path for selected folios. The source
>> +	selector does not choose a demotion or eviction policy. On tiered
>> +	memory systems, a source node in a non-terminal tier will usually make
>> +	progress through demotion when an allowed demotion target exists. A
>> +	source node in the terminal tier has no demotion target, so successful
>> +	reclaim progress from that source is eviction.
>> +
>> +	The source selector is a source constraint only. It does not select or
>> +	limit demotion targets; those are still chosen by the kernel's memory
>> +	tier demotion policy. Specifying source does not change reclaim
>> +	completion accounting. On tiered memory systems, completion may include
>> +	demotion progress that moves folios away from the selected source nodes
>> +	without reducing memory.current.
>> +
> I'm no cgroup expert so I can't really comment on the concept overall, but can I
> ask please that you try to make this documentation FAR simpler and clearer?
>
> I have no idea what an 'aging pipeline' is, then the paragraphs dive into
> significant detail and I don't see why you would want this or what it's useful
> for?
By "aging pipeline" I meant the combined reclaim behavior that may
demote some folios and evict others, depending on the existing reclaim
policy. But I agree that this wording is confusing here.
>
> You should lead with that, and keep things simple, only introducing detail
> later.
>
> Right now it's 'types:selector' (only 1 trivial example given) -> reclaim
> follows 'normal' path (what is 'normal'?) -> for selected folios (who selects
> them? How is it relevant to _an admin_?) -> source selector (what?) does NOT
> choose a demotion/eviction policy (neither defined in document) -> source node
> in non-terminal etc. etc.
>
> It's very typical of LLM-generated text - it treats the reader as a computer
> with a large mental 'stack' for storing this information.
>
> Humans don't work that way.
>
> The document targets _admins_ and this text strikes me as very very confusing
> for kernel developers, let alone admins.
>
> It also seems to assume a lot of knowledge.
Sorry for the confusion. I will rewrite the cgroup-v2.rst text in v2 to
be much clearer and easier to read.

Thanks,
Zhe
>
> --
> Cheers, Lorenzo

