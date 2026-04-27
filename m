Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A8B3FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F286B008A; Mon, 27 Apr 2026 11:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6316B0092; Mon, 27 Apr 2026 11:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23816B009E; Mon, 27 Apr 2026 11:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BEE956B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:11:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B76A81C0D9D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:08:54 +0000 (UTC)
X-FDA: 84704668188.01.9ACBFF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C37C1C0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:08:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uR9XjItI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8PlT6fj0xMyuWjkW+CGfI8o224FBRVwpmBUb7a7EoM=;
	b=GCt5yEn0xZF8JmY0Apk1VCbA1mBmhvzT79Qnd2DPpg8ME2zc8jboJqg+/XgtE2voR6J6e+
	p1nkwjlQj4KmoqNo5icwozavF42/FMS/yIUPLdf5I9SonbThFrg6tR1DmG0NYhBJA9MGlQ
	8ixcwy5U9Mn3s3GF2wfyyTcKZSCqk+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302533; a=rsa-sha256;
	cv=none;
	b=ZMzYvvcqCZLx+co0l+TU2WN3VBzTPsKkkJYtneZkDYyB9HeHflLsqOH7r+yCpLbgb/KMQv
	DpGpj0GGqF3nJ7CtAu9+GWDix7earsJ5ShTzQZw95pbFBPlgHvvHCbNFSndB0JGrHH3Ntg
	gEMs8WqS8dKpFTEEGouavCBeblSFuyY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uR9XjItI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF7D1404C4;
	Mon, 27 Apr 2026 15:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE68C19425;
	Mon, 27 Apr 2026 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302531;
	bh=DGNTE2ObghVxBxWjipSbc5ELG8n2Tma9SvBr8kxeivk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uR9XjItIqVDi8Bce3rum/9uj8K9FNsIxp6xDK74Xg+XygXLaqqDTVmbBPlU04KYCE
	 lnQTeWG2aJzRkPLAJqaE1KG1fiKn+DRVpaLAS2JcwqhywMmT8xEUk6g9wXhE4gQFzI
	 oVZ3M4IcLXyZ/dg1Y/ci1u6j49nMsQPFlPhlUBfaPc2mK9SEp7ZyQHqQDz3tqwMTXT
	 gQyHKDQWPNGwg7qKmc+9LHpyb2ud6GUn7Zrboj0IAKWc9iy3U8CbbCKpHRjqVWTi7v
	 LcoC3/F9Rx8Wl6tnTPLSLBA4kI67ZBSKP9M0GN7YrkrnUj7W1iwuwdsTGpImCjBlXW
	 1CZNfSio813pA==
Message-ID: <6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org>
Date: Mon, 27 Apr 2026 17:08:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] mm/slab: make kfree_rcu_nolock() work with sheaves
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 "Paul E . McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Zqiang <qiang.zhang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
 linux-mm <linux-mm@kvack.org>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-6-harry@kernel.org>
 <56381493-214b-406d-9121-f80be7658445@kernel.org>
 <7101d55e-ba43-4df9-a345-2af579f8e940@kernel.org>
 <CAADnVQL6iajm6L+VzqRB4b-u8OPhQSnUASnfciKGeRR4EDOutA@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <CAADnVQL6iajm6L+VzqRB4b-u8OPhQSnUASnfciKGeRR4EDOutA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C37C1C0007
X-Rspamd-Server: rspam04
X-Stat-Signature: ms8gmd3f4he1yscp6xm4wfuqd6mz3c67
X-HE-Tag: 1777302532-747971
X-HE-Meta: U2FsdGVkX19HDSahsEQeWfZR19Ag9+KQfoyccTl6BnMj1ALUGLzvhhx6jSSqw5XMJqlAfLS8XB22UGVPfDopuMHJEnfvDbsZkbU2op+pXU4jrsVunk3HfyARRzMR1BHWyyZx4aT5gKZwD2ENpTFj2+wW+dL/Z2cOlVlDvmHB8mgTz1B4cGdxqd1fnySzAs/X+vCGYggkNLUcwpPUNRS1kw6BPJRUcWcfWwUvE9FylTF/O8rCvkzM5F80LmS9afptKcJW/DPFquJJexg1z8T5Zn/BJkUNQbtsRrxJdnFad+lmCXJztarY7shSMuoP25X5xlp9huRMTbB6TBQYbilAIBECpyzcE5URlEieGceOVZBkaQfKh/qBh8t1ybEcrulRy0OPdPa5/rJUAe12FtNjB1UBkOQmsUSYygtsV1ETJdepRzk0ixzg5tTKXazCerOaaU3xKMG0BjxauTVJRrtzPQuRozLRS6a458dwstzc1VpXPtQiIetnsWwMGFh1T4wrKA4ad+Mq+Aogk8r9DYih5uYIlp46LDqa2rVRr3Z1ILQEkzXJgcSt/oJF0HdA/2rgy7Hx1RTFTK0ScWZ/nkxmlBUvDc/Tk/MZRUztoLRSLELJQ/IXlhTfb6MZz1Ua+HkWxxzySWXZG/1m7Iv3/W6bopIyINRf+CVBi3d1AkaiAn0638iqupBBkM8adYUaAOfwk/GVezBOnqWHEGTs0O4ZjKa3vG9pfmo1vIDH+XYbSdc8pYjAWcZM9bgFu9d2IzK2n8HeL0Z0bzjUV/ieIsqo/oMK25UTGTCHkX/SIowYpwMNf6Sci+g1+3ZI9Kqrd13qQuLlPA4SQ7fLNGNsFU/tx03j+xfDwWQPjlciC+5BcQBFSX5jiAlI1+JH5iC7mU0m/u4ESBofiV/T9chsi3v9qyjU5dKWpNM/MEFwLWQa1Iw4VK0zb4y3F8rQYuRKTmiuWENecLr2ZL3KV8ZK+rP
 FVNwGZ+m
 xW+WO0vEhV0gLaYNgXwFaxCbcSR2vMj3VxIh5M3RDrSnLNv1atEKeS5RkJl+fM8R430nUtNn1QnXfiBpyXiRPXyMFzVYJCvVXNdsAp3MmF2Dgl2fHPh+SziZtmz0WKZY8uWJY9u25pr8CkU3zKR1aaBXCDJTsl3N+9RV81nENZJJTfFNq/h7ZdCabBzIj+YMfkz2uRpJv5o4NLXM+IpFP+6EqOf5Zd16aJky5ajO5XQ8CFk/zauGC/GElTxlvPIoHvMe5RShDMQMmT+c7+ws0/cpP35uN7RQV0J+WOZJ8IZWQLWrxD0wGvjR+lNsW9Vtzd48dpEKVH+M8DHCv56fGwWLxvzHG3epXx1WkjKE0NKzKeb3E/O8vnI0+DClwvBstQeXrtxKqvseKnI59LpZf0F8cQYVzBtodpM2GWZF0KfjSAvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 16:45, Alexei Starovoitov wrote:
> On Mon, Apr 27, 2026 at 2:53 PM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>> >> @@ -5973,6 +5977,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>> >>      if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
>> >>              rcu_sheaf = NULL;
>> >>      } else {
>> >> +            if (unlikely(!allow_spin)) {
>> >> +                    /* call_rcu() cannot be called in an unknown context */
>> >> +                    rcu_sheaf->size--;
>> >> +                    local_unlock(&s->cpu_sheaves->lock);
>> >> +                    goto fail;
>> >> +            }
>>
>> ... this part, so an unconditional allow_spin=false on RT would only fill
>> the rcu_sheaf once and then stop working.
>>
>> However, can we condition this on in_nmi() or something, and pretend the
>> other cases of "unknown context" exist? Installing BPF hooks
>> allocating/freeing memory into call_rcu() internals sounds crazy, no?
> 
> Unfortunately no. People attach to tracepoint lock contention
> which can be inside call_rcu.
> As discussed call_rcu_nolock() is only way forward.

Alright. But we assume those tracepoint-attached callers know to use
kfree_rcu_nolock(), while kfree_rcu() callers under PREEMPT_RT can still
assume it's not called in NMI or tracepoint-attached context, right?

So I think what __kfree_rcu_sheaf() could do is
- with CONFIG_PREEMPT_RT, treat allow_spin == true as allow_spin == false
for purposes of barn_get_empty_sheaf() and to bail out before trying
alloc_empty_sheaf() - this is to avoid any lock activity that's not a trylock.
- allow_spin controls ability to do call_rcu() as above, regardless of
PREEMPT_RT, to avoid it from kfree_rcu_nolock()

