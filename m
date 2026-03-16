Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5277CF30295
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 02:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0516B00FC; Sun, 15 Mar 2026 22:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E566B00FD; Sun, 15 Mar 2026 22:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460C46B00FE; Sun, 15 Mar 2026 22:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 332F96B00FC
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:54:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1D0513C15B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:54:41 +0000 (UTC)
X-FDA: 84550408362.15.234B755
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9656C40003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:54:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PcYz9Mii;
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773629679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czmgvKSkWorSh1qUwUlivcTnGg2JfzlR8yJGfiNC2IU=;
	b=rBRJOXK0/5XW1K+kSVJkdriVKkDd7rYqVt1fwsE1g7ll/ItqiB6LHvLmMOG6Rtj2d/5gCA
	kOf5rQ4vkgTuUhNsInA/+DMfVrbeLMcOirJEPnEnqoFNCOL7BX+glZdl3kfHB1T+zPY3Et
	W7tgkhU3guRriIy4vkLHQRlI09LL2VM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773629679; a=rsa-sha256;
	cv=none;
	b=gD+WL/DHrsa6JPqKjbtDTIxeAYBitY98rg03l/Ve9qoV9pD2Vf30crOAWmodNPwJ6Tijzh
	xUK3aiqdtrSgbopbRMv5dHy58TkEL1AyW7DORFyho5787n3LgBPHEBADgD7xNdPPNlEqqP
	m8UFXvq0Yo5c132HoH4WBOPeM2+T4Zk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PcYz9Mii;
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773629673; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=czmgvKSkWorSh1qUwUlivcTnGg2JfzlR8yJGfiNC2IU=;
	b=PcYz9MiipK+nw1Wrb7m9IAlQObQ3cj+BtdSxkFwj6+H8AwzgdISmzmeHsXTPiJt8N6ecgYH1iVy2qKM2iXWRdQk1UrfiCGBqtZErqm5XluygaOQqc/nN3oCSoBdlkLcfmyXMlp7IE5ZyOfva+6jMyic6p+S1xhn2dDTvbvXWUe4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0X.-KIlz_1773629668;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X.-KIlz_1773629668 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Mar 2026 10:54:30 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,  linux-mm@kvack.org,
  akpm@linux-foundation.org,  mhocko@suse.com,  apopple@nvidia.com,
  axelrasmussen@google.com,  byungchul@sk.com,  cgroups@vger.kernel.org,
  david@kernel.org,  eperezma@redhat.com,  gourry@gourry.net,
  jasowang@redhat.com,  hannes@cmpxchg.org,  joshua.hahnjy@gmail.com,
  Liam.Howlett@oracle.com,  linux-kernel@vger.kernel.org,
  lorenzo.stoakes@oracle.com,  matthew.brost@intel.com,  mst@redhat.com,
  rppt@kernel.org,  muchun.song@linux.dev,  zhengqi.arch@bytedance.com,
  rakie.kim@sk.com,  roman.gushchin@linux.dev,  shakeel.butt@linux.dev,
  surenb@google.com,  virtualization@lists.linux.dev,  weixugc@google.com,
  xuanzhuo@linux.alibaba.com,  yuanchu@google.com,  ziy@nvidia.com,
  kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
In-Reply-To: <c4e5cc3c-5daa-404e-8c55-cface8aa969d@linux.dev> (JP Kobryn's
	message of "Fri, 13 Mar 2026 11:09:58 -0700")
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
	<3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
	<343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
	<874imkpba1.fsf@DESKTOP-5N7EMDA>
	<cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
	<60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
	<c4e5cc3c-5daa-404e-8c55-cface8aa969d@linux.dev>
Date: Mon, 16 Mar 2026 10:54:26 +0800
Message-ID: <87sea0o55p.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Stat-Signature: mwjnxbh8uddy4yjjjb4khxcd76iza3u4
X-Rspamd-Queue-Id: 9656C40003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773629676-816645
X-HE-Meta: U2FsdGVkX18q/IsdOJr8bTpMoChSPshzkJ9tG9gQjIuaGYXSpzesh+rO+jYdmQpxDcGoQZhP+pfFO6B0/yeARGqcytvsbP5HeDnHcuWnvWvywbQmyiLOih1nmt2oCBGTP70d3cRDXnCu/d1Dh2HUY+8aI7fOCihS+eYpjvtlkaZw6i2BWjSO8XJLm+71AXCcHCVCoKQibAXB1GOaqSR6oTI3fP15kCi04nX9bexogtg7yN6pLZLLYfb6tr9+crAN7Ie3p1vdUOdm3ho7nPpsXOCZN3SpX805KT15ZYXGjRxrCXOU4rcoYtda7JNrO+aKF/MLQ1iZMzRQd1ONwdg+RrD5OLRGmz0HAQKivbuVwzHV8L5xmbpufFHNFHV/tY5afGAUyQPA/jnLWkEh8UzefFDaZlB+r1OAR3ChTlbn5iITvwjh5Iylk4WQH6AwIMZPth985WKsp5XLrm0qi5U3dx6Kan1weVIW1E1rBJkD4/wI0ERR76aqw7dgxe5pQLpezhwdWIF8rFl+MMF8V//+cXNOmuNhGMt64pcgyRVvmdlFL9Pti0Uc+c0oQXpMEVHjJb1eV5Xm470F68gSDY0pRTZF5yw+2UbxnJg5IC9AZ/+WkzpNXGo856nVE3vsGCYzRmyuiiM1ovqaQPKqQ+VqxAS+5TIUtojMU9P8bdh3AAyjd7EurYgrBLiXx50UYukxVAD2pR+0MWUHIx7sE5JVd4DYmAHDqs1vHWj+8Gl4+cjPyYqolpJ9ymZnvvz9NnwwrfkrJca7p9pF93kFtwosTDkMuBxrR5TxbINXTkIq48KRnpz8rvC5qsK9K91iaL5n3IHHO8VaLW4TQA+U0EasrOuocSv5K7xhbErF4BskpH+YiMJ+E2U3iWxgtYSpW3cYnXocMny2W7X2XtD/nO9Obf6p2Zh/PUjtHaVxyESVmEq9DM/WbTtB3LWBK2/BstaRYftDCpGKvRFVqbY0UP8
 NIbnheNn
 Ux4Kg2u+YtNmBnDLEjNd0EucNKuJETDf2N8zjbbG36OrkotpI/wpYHR68crGLvAc2YnZ2fyoFho1ssnDuxrYRHPBe57gFQR05LqJNsAS7pUGKO6AVf/Bi59CZm6WA43LtxfLeTBLjXbAUqeZKsxn+q+NAaYgyn/Z66I7crVs9t2XvmbuUxae2nF7qE/EJo73XspxIpl22zX7aRyEDheqVGoyzSeZ03k/RDEmSlaEiP9Ep37Tsk/Xgf3JSuyffOUmO4VTgyMBzPRqIK5VdkHuWWo0xbvXJf8JzuEFy31fbLkngFUjAgH8KHjsIIH1jpke0GYQYWLU6j3E2oPtFsrmb/HHnlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:

> On 3/13/26 12:34 AM, Vlastimil Babka (SUSE) wrote:
>> On 3/13/26 07:14, JP Kobryn (Meta) wrote:
>>> On 3/12/26 10:07 PM, Huang, Ying wrote:
>>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>>>
>>>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>>>
>>>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>>>> all policies)? They would follow the same hit/miss/foreign semantics
>>>>> already proposed (visible in quoted text above). This would still
>>>>> provide the otherwise missing signal of whether policy-driven
>>>>> allocations to a node are intentional or fallback.
>>>>>
>>>>> Note that I am also planning on moving the stats off of the memcg so the
>>>>> 3 new counters will be global per-node in response to similar feedback.
>>>>
>>>> Emm, what's the difference between these newly added counters and the
>>>> existing numa_hit/miss/foreign counters?
>>>
>>> The existing counters don't account for node masks in the policies that
>>> make use of them. An allocation can land on a node in the mask and still
>>> be considered a miss because it wasn't the preferred node.
>> That sounds like we could just a new counter e.g. numa_hit_preferred
>> and
>> adjust definitions accordingly? Or some other variant that fills the gap?
>
> It's an interesting thought. Looking into these existing counters more,
> the in-kernel direct node allocations, which don't fall under any
> mempolicy, are also included in these stats. One good example might be
> include/linux/skbuff.h, where __dev_alloc_pages() calls
> alloc_pages_node_noprof(NUMA_NO_NODE, ...) which eventually reaches
> zone_statistics() and increments the stats.

IIUC, the default memory policy is used here, that is, MPOL_LOCAL.

> So if we applied the hit/miss/foreign semantics in this patch to the
> existing counters we would be mixing allocations that are in and out
> of policy, losing the accuracy.
>
> The new 3 counters I last proposed (in an effort to reduce the amount of
> new counters as much as possible) would isolate mempolicy allocs and be
> named to reflect that: numa_mpol_{hit,miss,foreign}.

---
Best Regards,
Huang, Ying

