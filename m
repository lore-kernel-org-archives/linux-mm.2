Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B126CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91ABB6B0005; Wed, 10 Jun 2026 11:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4256B008C; Wed, 10 Jun 2026 11:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744D66B0092; Wed, 10 Jun 2026 11:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 656256B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:00:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17D5D1A015D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:00:57 +0000 (UTC)
X-FDA: 84864315354.05.0933D7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 36FE7A0011
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:00:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lHjoTr7s;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781103655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTuU9FrMu80USEPHZIsR86q72HI9h9O4g+u2c63dTjM=;
	b=FVPK7K/I0FuBiKfEYtoc0F0tQgu1Flcoyo2W45sGV8z7lHQH7UVxsAktRqmFoIwS57oOdn
	xNSm/8DFWA6pGEoLUMKZeN42eDvN72i5IwN2SCPRcR3LnoxP9XyaeboTJJzdEiCtTu3yFZ
	WGoro04sz/JbJ+sa7VIK7WWdYxqeuKg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781103655;
	b=BZc30Jc6qZANchswrSF6bDVrxYAh4tgA1IE0llH/Dq5oQbxxvLb+tFzmk6xlblc+xm8LPZ
	lpqgJLr3UZZgk2EYRjZV2wZlA8LvL04VOO7Lx5gYNuLNYVlMW0c5GWdCVgVBVBvhFHoo2T
	Hw2TMYWsUTcMRAcvmReITfPTX8q7j6Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lHjoTr7s;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D99760172;
	Wed, 10 Jun 2026 15:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B991F00898;
	Wed, 10 Jun 2026 15:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781103654;
	bh=RTuU9FrMu80USEPHZIsR86q72HI9h9O4g+u2c63dTjM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lHjoTr7sIlcC9HNescoIpEPVQhPYNXrrn8kuYOlfh41Cd/1Outqp9FnHfcUeTMY0W
	 iEkxlDCU3g121k8qL8QB4vVFyvlUqmahDpoM0wbD8edNTZvDyu4kC9L/+4efEQZRg9
	 9ug6ej2V7Wp/wLNPpr+vhhwio/AUSHk/cMZ3X0VOJN7l2YevgVwJt4HvwPKD5azCJG
	 3SsQehi0gO+JbVNmV9/lYMQEJp8KkZYPn1kJg0aUkJmJdAkjrHcgY+pbbeBIYzyBH6
	 dVPiOO+/ZBtF/BOxpPF09c9LCbWa+wijIvDfgmdiu0fzJngBcN+9tIejaPyPefGGlK
	 1ZJJoJQDTfZsg==
Message-ID: <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
Date: Wed, 10 Jun 2026 17:00:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
To: Gregory Price <gourry@gourry.net>, Balbir Singh <balbirs@nvidia.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
 kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
 dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
 ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
 linux@rasmusvillemoes.dk, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 muchun.song@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 jannh@google.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 pfalcato@suse.de, rientjes@google.com, shakeel.butt@linux.dev,
 riel@surriel.com, harry.yoo@oracle.com, cl@gentwo.org,
 roman.gushchin@linux.dev, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 zhengqi.arch@bytedance.com, terry.bowman@amd.com
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat> <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat> <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat> <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 36FE7A0011
X-Rspam-User: 
X-Stat-Signature: d6xkypht8dmz4mshhymer49rxdimk86w
X-Rspamd-Server: rspam08
X-HE-Tag: 1781103655-849845
X-HE-Meta: U2FsdGVkX1+QvJIGqLKmGIHk5BjLoKGsgNjUCGi7pUg7+/c6bbqwC079lXmS+4pSjv3zCu1B9qfHcfnbBkAxrmjIqJjRGgoRT/3kSq4sHcGUQga4zMFdz0RHXLjhF68P8lSZN2GTLTIZV0vDfu48XjFRifX700YXf8743mg1Nf0VfDKib8mgcOj+aKg7+2mj2HUqcXDxzbMSpPYx355HcrFhESj83mq/NV6aXQEmRAuldhsB3zAVRnPh9F+krSbjuNBc1JQT2z1NcxBJdModY7j3O6UPLe2ohckBYkVHipzfXt66+1DVBpNEut+zYDWeLCHc7wOvX/GGYlev1ii0+93RuwLYhBgrUdlyE43PLPRAi5J4djrz6tG64yzTDMY3aFMgo8n/y9dWnfzsrQ2QFmCkKTqiFsHMYSxAf6NdjQZ2rSYG9zmM1BeIZE+jd5RDs2+x16yoFO2ejPIb7B/CUOTs5QhFyNOTxIbxcw/GJnKmbskmm5aPDR8oqO9OUV3MgyBlEzxvgLTEW4CnueOVcEHBShcmwUG3FmxoAwNh6hjdICnsIqZntpaQSguxsE3hFd3Q/OvVBsW9P8WHpIXTMqzPDwVfjxK5/4Khnx3YiEpg68V1Eg41VWC4rO+HjGWm/bqjlSGhFPHwJftC9057Y2xNdFXFNzuMTGvKUv6wEPPTCXzfqiwN2XtRKlaraoWsDqC1gCMh+7zjp7CfAtwXfTy2LfrCV8QrYq+u04qb+apy1LMo/A1yLzZHn8T0RVC9GiHltbYJdk+IZ3bAsQRsw2TRlUlbk2YoEzF6Zyaa/hw6tNR62aJFYIqRDCwxz0CY2iKr3u/uCUMHWUEh2T9yhROmK7rmK6NSSdIR6m8Ex3BNqeIkwB2ElHYlVyaE87xOryydmkVsKFl4/zUlgJlGpkGJNcTmmigU3o0iDIdbtet1h0vH5SKn7b3E+fw9mKpt8xiX/gwQoynZKkJ1wuZ
 uJxvI4TT
 1f/m6Yyp/Sc/ENudAIRj7sz2jetiRlE5uTb/a+2Y5lUXV6JVUb+WkqaO2ATk7fzPZ03mQv262uq/6zy0Wa2U4OCPqfAx+oln6It4RIYVyryv/0YwHaruHDgLhXCC8glXZH7VVeCiw0k+Txm+ey5VlY9YzwHsMbQ5lKr24kfOEw2+nIhO7i91lQZrLv6SecnHGjQ65Ze8ggttsbcZb41O0D5dphhPgsUr2Lj7cee3OZ/303qIQRZSND7i8WtE8nfyugFF1ruv4E8ADRPKhFqgrXY8c4RYkgngCRosqXrdNx0h/G45LdIBzOg7f2CbVQMHDPVvgdC2OYYl6Nbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 12:41, Gregory Price wrote:
> On Wed, Jun 03, 2026 at 03:00:01PM +1000, Balbir Singh wrote:
>>>
>>>    __GFP_THISNODE cannot be overloaded to do anything useful here.
>>
>> Let me clarify, I meant to say, let's use a nodemask for allocation
>> and __GFP_THISNODE gets us to the node we desire, if that is the only
>> node. My earlier comment might not have been clear.
>>
> 
> I've been tested an stripped back patch set where I drop all FALLBACK
> entries for private nodes (including for itself) and only keep the
> NOFALLBACK entry for private nodes.
> 
> This effectively isolates the nodes for any allocation without
> __GFP_THISNODE.
> 
> This also precludes these nodes from ever using non-mbind mempolicies,
> which I think is a completely reasonable compromise and something I was
> already expecting we would do.
> 
> Notably: slub.c injects __GFP_THISNODE internally on behalf of kmalloc,
> which causes spillage into private nodes because slub allows private
> nodes in its mask.  I think this is fixable.
> 
> I have to inspect some other __GFP_THISNODE users (hugetlb, some arch
> code, etc), but it seems like fully dropping the FALLBACK entries and
> requiring __GFP_THISNODE might be sufficient.

Sorry, I haven't been able to follow up so far, and not sure if that's what you
are discussing here ...

After the LSF/MM session, I was wondering, whether if we focus on allowing only
folios allocations to end up on private memory nodes for now: could the
__GFP_THISNODE approach work there?

Essentially, disallow any allocations on non-folio paths, and allow folio
allocation only with __GFP_THISNODE set.

I have to find time to read the other mails in this thread, on my todo list.

So sorry if that is precisely what is being discussed here.

-- 
Cheers,

David

