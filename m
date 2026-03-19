Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F1A108E1FE
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 12:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451E26B04A0; Thu, 19 Mar 2026 08:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FBE96B04A2; Thu, 19 Mar 2026 08:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3115A6B04A3; Thu, 19 Mar 2026 08:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 229276B04A0
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:25:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDF8A1A0547
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:25:06 +0000 (UTC)
X-FDA: 84562732212.10.C43F49E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EDBBAC0006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:25:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jeBz6Q50;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773923105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7vZnCAkPhYckmOVufgtlRCvGSgDYPHh9WhiOgCUpLg=;
	b=n3Qg0i6cuol5AuHbJ0uachjmyJLBM/dVy/k//Uo5FIYq740c1RYc63tnJXcdXT+2Mz7Hid
	9+V1R/Hoqdwm//cvQjC5zqJXX2NvUhRpUDhpw1kfGJCBM0l4y+wIchQQz1x9kkCTC04SaK
	Obi1LyPdK/OAPZWhq5p7hvc2OwXpvJQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jeBz6Q50;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773923105; a=rsa-sha256;
	cv=none;
	b=YGNFUNNyV8VioQ/6yD60cykcprM2I3ZgGRwyW4s5XXcklG/rPjpBK6VUgoCHyUHewwgvBD
	biCn1KuTNExbJWPlj6SnPXHF0E99+QM6va3CTTXH9saXsDoVx4HLQ5sqpP22pHt7opACp7
	f5jfh412H1sBug6D5YbkExgSURMRUAw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E425B43FDE;
	Thu, 19 Mar 2026 12:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08821C19424;
	Thu, 19 Mar 2026 12:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773923103;
	bh=13bzW+vPo7JVpd4VWsJORrHbXOeJvVF5Iez9fCR2Qwc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jeBz6Q50mjSmjgk9151OjMDFLSzRv01sldtEhypGx/EDX002oxbnWb3Uf/b8dPRkF
	 bKx35gHS+9UidSbuigAvXWpwHe8oEiUmwCNZGkvg/6G57FbQKgcDau6Ui7CNEClSIe
	 a8T0Wv6xvWoinZ5k/ydhjYz7uV/KkiQuxJ0rYxQhXFaieAaQ3lseKZ303/owLyM6Ro
	 Stmr1Tu2Ft5Cl6bh8JX5JR5RddwSN7sR1q/C3FbedCHDhRYFvqFlQrPfkuoStzp8KC
	 hOsNvQw7MQQb0WXxaPw5GFa5qttx7G74g/ybG4HdLVMgB8q4dxg3TwGH0t+rP3U5Ok
	 ts4AL7zZ72WTA==
Message-ID: <d4eeb9cf-955d-48b6-b76b-f2c5d63f9599@kernel.org>
Date: Thu, 19 Mar 2026 13:25:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] slab: create barns for online memoryless nodes
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
 <4xvvslwdcqafc2yfthpgv7panejdgmbdoueqiqkaeikohjutgx@3imnb6zlk6ew>
 <4659c675-6949-4295-b385-1ab26921a975@kernel.org>
 <jwlqiygxlch5gq6g3vkwynrpndjwcoxwice2hmvim3tvdfubp4@je5ldr7pa5f6>
 <5d10a43f-15d0-4af5-bacb-9924629066a0@kernel.org>
 <7uyhaxzup5b4qslhf4wnbv4qlafulvlpbn5mpalvurxrlaolvf@2tltqo2qmrsj>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <7uyhaxzup5b4qslhf4wnbv4qlafulvlpbn5mpalvurxrlaolvf@2tltqo2qmrsj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EDBBAC0006
X-Stat-Signature: 63wz4kofnuq7jbjgqw99h7hytnuwaixw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773923104-484151
X-HE-Meta: U2FsdGVkX19OB/Ra32G0bOKA7Xt+97+Ciz9WSyeLc2H2Iuz6CTC+r0bJSALxJJ7xIM7h/ikDsfBM1FvoWzlMHQ9eRqoLmdDMoCQr2SbHCwCXmSuTimcYfw9DQchWJ6QuYGHkZNl+7v19C0iQBpqlWzlrGSZUqyuMvO7uiKfj/m4gEK+B2pAViiOmatEvys6itA5oLuSHybccYwwDE/RGMbNMiR0xr0dg/8yejZ5FCnmOI9avObiCBv/aEisIDbVry3nW6DLuqSd+jFMqSmpqmfBgl78mhtM2at/k3hKwH9NZaB/eiDvX4VqJsnTpw1liVnZPfq4lxpu1ZqnZZmNmyDdvhtvay/jLuBJovAF34qH70OCMg5N+YVPYZGMKCdji4kp/PQIF6t5PBAfgMFr2Or6rMs3EC8vnXBhyRTuI7Rk1aKjbTFyLGfhZxSkhQprKl/fbfYbY2aLRewc+fMl4F2nNbturCnWyhnxRaHM62AvUSGytZcq96puBbz41zoXDISEwtTJU5Hq2wZAeqw3hUs0sgMP6Z2Pg/POwnMt6gaCgnvz+u3kqmzIXcoe6BMkKIRNq6Bpor7WQpFFdGiiV+fgMTlL3rsknlvV6qFn0DpelvwhDjgCK8yIwhD6WopMlA73vHo1+UNQmw5xAhraBwD0+jkvSUyQ1bI6/TDDH1YrMuCVno8RJoK4kUuzmxA7yOBWRgVyQ1TGde8yWX6ZHPNI9h6P53yo+PYqt1UQUEGP9jd9zTh37EunMjZs5/lAnCQrOItlTiIPA2siZZAbVrvK5t3+zoYrtco+xhACBdWIgLEXTk0aZW4toCJMl8YLKIBFIviIgTr9WQSkbnwI1D/AF4Ck5GT16k5f8SUtlF7EIhG6SZeTdcD2tc6qlt938qxuGF+fMtW4tPXaUYY2Xx2ssO35f4bmeguxbRQW2+Ih9VkeSC8Kiba1Vcy/6eSvZNdgzSaYGmDowJOddBUd
 dKM0ujf+
 MldlM1VK7z7H7x8h0BkYoXYlyjdmdvsQm8oKgq4k203G9V+GTspoocfl3Vf09C0ErGNevzkgptzkN5hRo3NLUrqpyMSSd+Bnk+EbW58tFrmmYzLQ6+pG4E5Tz61vPSpH3TDBlfrG9KfAvwnXMs+OhbUl9KmqdtWahztn2qbO1cFjQMQXsm4QTUMiN1SRYCUmFOXc4E+fR/hydyXZAsHQtwGgt04oxeVoM5wzswpvNWZPCt3xepa4s8vzYWZYrUYRbx75J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 12:27, Hao Li wrote:
> On Thu, Mar 19, 2026 at 10:56:09AM +0100, Vlastimil Babka (SUSE) wrote:
>> > 
>> > Exactly, conceptually, N_NORMAL_MEMORY seems more precise than N_MEMORY. I took
>> > a quick look through the code, though, and it seems that N_NORMAL_MEMORY hasn't
>> > been fully handled in the hotplug code.
>> 
>> Huh you're right, the hotplug code doesn't seem to set it. How much code
>> that we have is broken by that?
> 
> This probably needs a bit more digging.
> 
>> It seems hotplug doesn't handle it since 2007 in commit 37b07e4163f7
>> ("memoryless nodes: fixup uses of node_online_map in generic code"),
>> although the initial support in 7ea1530ab3fd ("Memoryless nodes: introduce
>> mask of nodes with memory") did set it from hotplug.
> 
> Yes, this really is quite an old issue. It looks like we may need to dig
> through the git history a bit more carefully.
> 
> I'd be happy to dig into it further.

Great!

> 
>> 
>> > Given that, I think it makes sense to use N_MEMORY for now, and then switch to
>> > N_NORMAL_MEMORY later once the handling there is improved.
>> 
>> So I'll do this:
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 01ab90bb4622..fb2c5c57bc4e 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -6029,7 +6029,7 @@ static __always_inline bool can_free_to_pcs(struct
>> slab *slab)
>>          * point to the closest node as we would on a proper memoryless node
>>          * setup.
>>          */
>> -       if (unlikely(!node_isset(numa_node, slab_nodes)))
>> +       if (unlikely(!node_state(numa_node, N_MEMORY)))
> 
> Looks good to me.
> 
> I've gone through the full series, including the range-diff updates, and the
> rest looks good to me.
> Feel free to add my rb-tag to three updated patches. Thanks!
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks, updated in slab/for-next

> 
>>                 goto check_pfmemalloc;
>>  #endif
>> 
>> 
>> >> 
>> >> I don't know if with CONFIG_HAVE_MEMORYLESS_NODES it's possible that
>> >> numa_mem_id() (the closest node with memory) would be ZONE_MOVABLE only.
>> >> Maybe let's hope not, and not adjust that part?
>> >> 
>> > 
>> > I think that, in the CONFIG_HAVE_MEMORYLESS_NODES=y case, numa_mem_id() ends up
>> > calling local_memory_node(), and the NUMA node it returns should be one that
>> > can allocate slab memory. So the slab_node == numa_node check seems reasonable
>> > to me.
>> > 
>> > So it seems that the issue being discussed here may only be specific to the
>> > CONFIG_HAVE_MEMORYLESS_NODES=n case.
>> 
>> Great. Thanks!
>> 


