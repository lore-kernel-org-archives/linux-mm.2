Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D69FD461F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 06:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A146B008C; Thu, 26 Feb 2026 01:43:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5DEB6B0092; Thu, 26 Feb 2026 01:43:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D814E6B0093; Thu, 26 Feb 2026 01:43:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4AB96B008C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:43:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71558BAC99
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:43:21 +0000 (UTC)
X-FDA: 84485666202.13.39AC851
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8D4044000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:43:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HP5Ga7xy;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772088199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gFMs3BNYCLYbp907qyYSrv7ESdIsN4oDF7h/Fu2FJY=;
	b=SXol6FB+bEKiiCR/XuUbqBVoFn+Lmg8WmedyBoRqQvrMkAZ06RwJz1DUmCR5k2WcZTgLe3
	LIrZbDbiokyqtG2z1sQWyu3RMRSp6UHbD2MNIc5fyJYm0Ab6VkOmyA2JlKssHDbwRqFFPS
	zv0pbp9txzqaZjYsPnmqslsg/cGKgrw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HP5Ga7xy;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772088199; a=rsa-sha256;
	cv=none;
	b=8LucG5KU0q3eq16Iu3qupFSNomtBJufff7Qq9GDyjxsrHJdGuAjVUs1y67LG5vFU0IxW7n
	9O5gPS5OKj/2rOI8ACYIumwV8Ujpj6+rS+x0eBYFtuLCsO9i9LUI+bXtjGmaurY/RX90aZ
	DPLQQs8GygB25pbsK/64IPBGR3/KlSk=
Message-ID: <d7bc163c-7dca-4cb5-b522-a6f98ba4b16f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772088196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/gFMs3BNYCLYbp907qyYSrv7ESdIsN4oDF7h/Fu2FJY=;
	b=HP5Ga7xyX4/Ux+VNCIMWTaLmiC52BjFNZ8ZGo2ljwIaNuUW1j9m0tascLyfYdtnFd+8HtH
	Z55p50bo9TBs9IZhmfCIXUiw7Tjqv9UwPTuyH3MtGTAf/qgvQ0w8lku/YcCSGDx40MMllu
	Ogim/cLOLqJMhJFU7U1l3hlNee2bCCo=
Date: Thu, 26 Feb 2026 14:42:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
 <aZ-R87JfacQ2gGq1@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aZ-R87JfacQ2gGq1@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 79tj8tfnuayjoy433p7mr6hjkzh17kj3
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D4044000B
X-HE-Tag: 1772088199-172906
X-HE-Meta: U2FsdGVkX19Rq5InbfE0dZtwMikbXF7aF8q/THQzBLh9OqgU2GR9G0LV1kI7YAB/yRCT/Br3eBewKf8ocJUG6qJ5eyOL3zPAYkjgU+jXRvXxPO1n5ZyOks4NQNDxyVjAfoY6bIhAMUGRah9IW1gkz5crcWVoYW1bYDuFIz8SbaUkTAjpl8srhKqghne2I4tGAGapLY6Ddw/MWcwKz13gJ9t8VBEutWbneBsupJiuGKovhHVPmsP1v1tVwqkpSI+zirsJUBtUiyJ2ljfjKvYJAv3S5gLD2wH7aTGT+lvNVxSMnIsO1bi4LVTuc913nZqbixQWEXRf2A/ZuyaBC/GXEBtr2R4Nplh41SLEWJ1g7VnPqdAupmHBlIRw172YSro2oRPK1k3yL6OP8dBXhhSVR+8LgJNd+KpVOeVXnCwVUuA1h2Uhj0uV/kGLWu9hrJ9aMVY8cDuA56hVO+jhMhZwZk3rNAEs5wHmDbqp4/rveeHJEgvVORQ7ec+cdtBIsdLPTplbmMVa42LHvXSxniGcJacAZ3uX4F/crB+TzJhNMVTav0mXzE6VgOStpOBtNF788aop8bhV5Ka/4SRp2TVHEgbYbqtpxznUTtTXaJZ+1IzKkglgFHCwj6Vw7rgXQsKl/f7gFMO1R3WDeN07yvkUSJCT6qGOa23rT2o6/8Ha65YIZsfhmRtfi8sO0qT5X3gLiEpBRcs2BWqpJ8fn1URmforOgbUsPZxZ6+nk4AQCb9n4qAz7bWcUl7pPkIhaHkAuQJUYvW614ybhOoAK0TaXKW2aUkuzClyuq35C4v/ErFilo7XF618Awb8p8t51+OBzxKpYtceNA3lHKAK9/Yti2skxSDwhax8bwiJSeiEOREj8aCB3aDYWdkwmCC1UOrOfCvKz4mD+wvcyrs19JpsWB8v0HeZTQwEghA2Jt8bVMqAmCtah0vUSIjidz1Ok/oTtR74x7Ggy3+H9dxzU6QM
 AliAgtcX
 5ighJRXOuA6UrRWiecIwsWci/HEQgT/++1SFNjmk3jOu4TO6so651p9U+0romr5JD4gDgjdoE9xva/C1X3FviPnDbL0mbym1PChsNA7U0+4Q2/uhjOLLnRU1TwKHFQfX1O9utn+RJIArlNdPBR71G1CHV+8EWay4nN/TpUg878Ky1t1l/K0G9A1lRY+Yctx/QFx4X4azjyB2CgPrzCLXJ2p3XqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2/26/26 8:25 AM, Shakeel Butt wrote:
> On Wed, Feb 25, 2026 at 06:58:59AM -0800, Yosry Ahmed wrote:
>>> @@ -473,6 +493,29 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>>          return x;
>>>   }
>>>
>>> +#ifdef CONFIG_MEMCG_V1
>>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>> +                                      struct mem_cgroup *parent, int idx)
>>> +{
>>> +       int i = memcg_stats_index(idx);
>>> +       int nid;
>>> +
>>> +       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
>>> +               return;
>>> +
>>> +       for_each_node(nid) {
>>> +               struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>>> +               struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
>>> +               struct mem_cgroup_per_node *parent_pn;
>>> +               unsigned long value = lruvec_page_state_local(child_lruvec, idx);
>>> +
>>> +               parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
>>> +
>>> +               atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
>>> +       }
>>> +}
>>
>> Did you measure the impact of making state_local atomic on the flush
>> path? It's a slow path but we've seen pain from it being too slow
>> before, because it extends the critical section of the rstat flush
>> lock.
> 
> Qi, please measure the impact on flushing and if no impact then no need to do

OK, will try to do it.

> anything as I don't want anymore churn in this series.

Agree.

> 



