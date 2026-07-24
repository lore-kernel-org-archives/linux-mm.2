Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3722C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 14:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1EDB6B007B; Fri, 24 Jul 2026 10:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE6B6B0088; Fri, 24 Jul 2026 10:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872356B008A; Fri, 24 Jul 2026 10:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F02A6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:11:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE2FD1C02AF
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:11:04 +0000 (UTC)
X-FDA: 85023856848.21.3969DFE
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3FFFA2000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:11:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf31.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784902262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MikfvCv97mEOefApOotfNAywscEsetuTTqIDlrf1kE8=;
	b=UkCFZv178g/ORLzLrxEnzuGSx/7YjX3LgexNc06ko4VAx4X1/dbcINqYzXn4LncPon4x61
	E4mhpg2IzlLzQ70kHif0mVpfg+iFVopiuDeX1lPOX6hgaUxJaymxXbGKeMXGleKxZbvUPz
	NOo0PG1nNL0j7cj1WZRArdTwxOZwIZE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf31.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784902262;
	b=lzUgmMnoqWE/qJvwcgA/oQ3MGvP34cnOkNnozU2yEEf5R3pPD1cSk+XcqQ7NVkz78sBiWA
	bfSJsibAXJurxFJkNDaJiwbLgBNesXroKTgab9Q+zb599HW+kuBvrB2fAGeiw0ZSd/1x1M
	f4eH6dTkWqwzcpTnPA7r1rs2F4UD1EE=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4h68zN50w9z57DCg;
	Fri, 24 Jul 2026 22:10:56 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 66OEAgtq042932;
	Fri, 24 Jul 2026 22:10:42 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 24 Jul 2026 22:10:45 +0800 (CST)
X-Zmail-TransId: 2af96a637265cff-29079
X-Mailer: Zmail v1.0
Message-ID: <20260724221045574FnnXVxYyUtRhSz3-sGtLr@zte.com.cn>
In-Reply-To: <07adab0f-12cc-4f48-bf23-4aaef67ab405@kernel.org>
References: 20260723182727858gUQJ4TgRU2b6v1kdgpkfV@zte.com.cn,07adab0f-12cc-4f48-bf23-4aaef67ab405@kernel.org
Date: Fri, 24 Jul 2026 22:10:45 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <ast@kernel.org>, <andrii@kernel.org>, <puranjay@kernel.org>,
        <ameryhung@gmail.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>,
        <rostedt@goodmis.org>, <paulmck@kernel.org>, <frederic@kernel.org>,
        <neeraj.upadhyay@kernel.org>, <joelagnelf@nvidia.com>,
        <josh@joshtriplett.org>, <boqun@kernel.org>, <urezki@gmail.com>,
        <mathieu.desnoyers@efficios.com>, <jiangshanlai@gmail.com>,
        <qiang.zhang@linux.dev>, <pfalcato@suse.de>, <surenb@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-rt-devel@lists.linux.dev>, <rcu@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBzbGFiL2Zvci1uZXh0IHY0IDQvOF0gbW0vc2xhYjogZXh0ZW5kIGRlZmVycmVkIGZyZWUgbWVjaGFuaXNtIHRvIGhhbmRsZSByY3Ugc2hlYXZlcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66OEAgtq042932
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 24 Jul 2026 22:10:56 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A637270.000/4h68zN50w9z57DCg
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3FFFA2000C
X-Stat-Signature: 65uesp4g6t5srg7t8jqqem6fnuzpmshj
X-HE-Tag: 1784902262-792429
X-HE-Meta: U2FsdGVkX1/xLjRmWT2u4HOEISHeeynrYpi0nVb6kbBw+K9Aijuo0UvJzrwgOBspsN/lZ6RZPykzgvMxcztb74UQG/dFRGq2AXJv3D4vlZNvV83up3RnyY1xM1a57kxMziOhSe0O7nknhO30VRlZvnZbSXI70VoWr+ALQRTwjlxBelkSe6gNcLZ6BeT0L0JWwvmN0kFTa2zeaejISucmdmXURXJuEKkn4UdDA9gIJNRRpoNSNbxARYHwjs73BgGgMjDjpY7eCBz7TY0TLWkPdgJIw49Rwp6JFrXv1s3J3pweaavwhX4PE6axPupMEAeZFOZ+cZxCMWcqW7vk+hppAoIBz6ahP+jMoBa0RvN3X95WO3vBUvqkSD8wEnP0jklSI/kqrGe3/mpyq6vooK5K+4Usb8NVyIvaHW6Ccv1VJ+Q2LtvcWAWJSHj3kkwhlgv5lkbDtsKQFEFkA2PHMYPWkh+9qm7HFjITdg7VSFPAXmIdT4YMtKloLfAM9+odYdcDfruDNGlsZysf2gNGV7Qns7QriomTr5mqNW7uFe9XcSOH8rcX3tpjDaEqtG+KYrJkOl3nso7Se8W6NDbgf5oLo+oCXGM5r8+tAZH9ODJP20WGMVyzGnVurNSFa8YV6pCcaskoQBBGCVPd3OizO8VlQ9D/53kajvz1SPrysS/qxwZKLBAK07YirFhSMtRvB7bzySNTikeT37VqmV91nZD7tdwjWohr5kzsQDLT8Cw57qcwUNE57SIhsoUN4B8zVR2v8gbfqaXBFh2GohPpf1HY1FwDv4ynnkF0Wm9t8BgpcCc/tFwvV8RjSaE1evST10PU/PtoUV+o6vHu4r7jCmE0Z43Qj5iXpwwZQovE2h1d+8jzT8FceNzR+B/SmdqfrRrFQgmmi1iyxL3SYnrDTwHNsmfwXsRzrkfTZwHVMcgEnUJInKYWRguZrc2t+ehbdMXaTOa1VW7osiCZxoJ5FDR
 8xP5rTq5
 6sN8yIDPB3sSW6CoZ6Scu3sniiPzYcKMGzcLMxgg3wijWu8R1+73WQnzur92aSase8vICQQFRHfExiR2y0mnPfY922rCcJC3+EzPiAQwPQZZ1KI9vBWgJrcwDHlib4tnPj48acjMqvLzbmC5CjMkVDtNl9A2MjKHxAQ4+Iyk2e2OzQrpRj3/5/Ki2arl2ELMBvTwNlJgdoEl+1lTASvc1wLB+dOnmXsqGlWhghQ43oOId7lwg4MaOmXaaUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On 7/23/26 7:27 PM, hu.shengming@zte.com.cn wrote:
> > Harry wrote:
> >> __kfree_rcu_sheaf() cannot invoke call_rcu() when spinning is not
> >> allowed and IRQs are disabled. To relax the limitation, extend the
> >> deferred free fallback so that a full rcu sheaf can be submitted to
> >> call_rcu() via the existing IRQ work.
> >>
> >> Since the deferred mechanism does more than deferred freeing of objects,
> >> rename the struct to deferred_percpu_work and adjust names accordingly.
> >>
> >> When a sheaf is queued on an IRQ work, it is detached from
> >> pcs->rcu_free but call_rcu() is not invoked until the irq_work runs.
> >> To keep the kvfree_rcu barrier's promise, call irq_work_sync() on each
> >> CPU before calling rcu_barrier().
> >>
> >> In the meantime, remove the TODO item as apparently there is no simple
> >> and effective way to achieve that. This is because, unlike sheaves,
> >> kfree_rcu() batches objects from different caches together.
> >>
> >> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> >> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> >> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> >> ---
> >>  mm/slab.h        |  2 +-
> >>  mm/slab_common.c |  7 ++---
> >>  mm/slub.c        | 85 +++++++++++++++++++++++++++++++++-----------------------
> >>  3 files changed, 53 insertions(+), 41 deletions(-)
> >>
> >> diff --git a/mm/slab_common.c b/mm/slab_common.c
> >> index e07b4e6d6679..9c9ae1384f47 100644
> >> --- a/mm/slab_common.c
> >> +++ b/mm/slab_common.c
> >> @@ -551,7 +551,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
> >>      }
> >>  
> >>      /* Wait for deferred work from kmalloc/kfree_nolock() */
> >> -    defer_free_barrier();
> >> +    deferred_work_barrier();
> >>  
> >>      cpus_read_lock();
> >>      mutex_lock(&slab_mutex);
> > 
> > Hi Harry,
> 
> Hi Shengming,
> 
> > I noticed that your fix in [1] serializes defer_free_barrier() to
> > avoid concurrent irq_work_sync() waiters.
> 
> Right.
> 
> > However, this patch still calls the renamed deferred_work_barrier()
> > outside that serialization scope, including the new call sites in
> > kvfree_rcu_barrier_on_cache() and flush_all_rcu_sheaves().
> 
> Good point!
> 
> I didn't _fix_ that as part of this patch since that would be confusing
> and the fix didn't land the mainline or slab yet.

Thanks for the clarification!

> > Is this series expected to depend on [1], with these call sites
> > moved under the same serialization? Or am I missing something?
> 
> I was thinking of rebasing the fixes as there won't be much conflicts,
> nobody except for sashiko complained about this, and we're not going to
> backport them anyway.

Rebasing the fixes sounds good to me.

--
With Best Regards,
Shengming

