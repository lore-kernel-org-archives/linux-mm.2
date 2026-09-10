Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6C9C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406826B0092; Thu, 10 Sep 2026 03:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B60E6B0093; Thu, 10 Sep 2026 03:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE2A6B0095; Thu, 10 Sep 2026 03:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0D5F6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:44:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35CEF140456
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:44:42 +0000 (UTC)
X-FDA: 85197065604.02.A0A89FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 76C0C40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:44:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K/1yX6wY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026280;
	b=OfHZAlDkatuSb1/Ebt85ddArp1XBsPzhrDGbFpbRpS3CQq3A7MaDr15uaAFsvKpqtGvye0
	dP/RdHroaMOdAW8SAy+9jrjqk0WXeA5cS8Qelwv5D76wWjCqW8BTM/zk//YoAveFTg4QHd
	CchxnIXLjoot21a93mZ0iOgxEDC5Pvo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K/1yX6wY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeY2ecBYXILjnJfvlD+aKbn3Fj7q03e1zhdxzP3owm4=;
	b=d1oFIx6mqyrjDsDbMPSds+WW8FXPWmonwZmrcsK8wGk85OD0eQUI286Y59BdTQ6QKDkWSq
	cvYrpilDzqEE58L7QC4zs19ZgIeQ3+C7cXVQzM8nekkG77RujRLNeof2Xekb7+4TFgu7w7
	7cEhVUg/THjS5INWIpSaNtVuHGuGpxw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1A40432D0;
	Thu, 10 Sep 2026 07:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534431F000FF;
	Thu, 10 Sep 2026 07:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026279;
	bh=KeY2ecBYXILjnJfvlD+aKbn3Fj7q03e1zhdxzP3owm4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K/1yX6wYqGx3DlHOpx6z/zg5BRMRmre61T0TfyWVd7E6qvYnkkqKgkjYP8bl+8p4K
	 Fz/WMtRF+bz6n4RmOcAd4SRb1SS9EBF+Wam8pC4EKJqKfHOiVbxbwC1pQW5e72ATWn
	 BTulP01ah/PWT1SKdtfCFZ835ua++8yjbDQgpnWcCbcMaIF7w9F+GCauHPtwyuWqXJ
	 lijRSdW/evnZOnPtk6oD+LlfebWXweMNXh80ckD2iODwAySofHwKwFOi8WKGtUrLXT
	 g84/ydHeHETnkXPU5XSl13qkllkRGo7e+SjUzrHEza8LSKroR1KzNDTpgmyaJ/K89y
	 XOETAU5f/2JTA==
Message-ID: <d24c425e-7913-4f80-987d-7105a8b13432@kernel.org>
Date: Thu, 10 Sep 2026 09:44:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, willy@infradead.org, jannh@google.com,
 paulmck@kernel.org, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-5-surenb@google.com>
 <19e428e5-d8bc-4abb-b052-e23442464cba@kernel.org>
 <CAJuCfpF-xeED3zVL9YyCwrTUxcYXw4s6gVcCYY8p7rx_09mgLg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpF-xeED3zVL9YyCwrTUxcYXw4s6gVcCYY8p7rx_09mgLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76C0C40006
X-Stat-Signature: 5aca31if93ocp57bjqdw3m8fktac1t7p
X-HE-Tag: 1789026280-254974
X-HE-Meta: U2FsdGVkX18qGTap3btwaSZ7qGBeqZN5tPIN891xnOfsKzzyupjBNa+Bp7PwMawNqUmZxJps2Fh/XU0SDwsPHvZTpjFAGTtFcu5k3/dWEvdf62VGtu/kNy6b2zzUtSmu+O/2ohQXW8JpYFqkQnQbtobhS+Ttu+y1o2nn5kLTjXBUcxA7OfC+2DPGa+OL4p5mksp51ZKZvqeCdKDUkzmTDbhXVSHX1DBTLlO1iYnI1bgVYHvGuHxxJ0KHgBooW3FHrlTcRvIdZ45wuLOmug302QJfZXiLsjdZjNjYy4cI/HwSdLUKVR9GGgPSHsSdP9Qv2eWgpd7jc9CGEfbNEppbvkvcHBhzTiokv+zSlkM7SB2hRfZGPqpkHTwCFj2W/mRZE65vGligouUKEzFv5HWSd3bHRi/ZNor9CBel2SzN0UiRVHXqdaYQ+tdhbFiulJ0ZQWLf5MSGzAF9o/3JFDakaMiyNRAp6GZNL1eRBuijDtF4gwQuVJVMRpJkr8rLO1AnRYkzBxkSvYkLP/nLs8hC3nNVd4jNTO+Tm57K+DAbrNrZ1vaNGJMSb2AhNs29n5403QcbdGGUGpAQl7IeZImnGcFOdtelpfmdSiIF7lnuZjLjfmo3bJw2qEzPX0JamIisJgP1+5uCro6u8S125Gl4fCri0qonmJLU4cvbX1YN61sl4B3oNtZcWmYMDIUoUnrlCroWfMGJsAz93hnWSLXkANdm1w+1p3k3SbMNHX+ySme8ijSYvZwsQXz7yPAvCsKW30Be1DJ8MXTjOf3agdzQq3B+47s20L+eiQCfBiECwsneVWT+R1EPpubfyjQWwuTSto1FYYiYAoC4LsX7Xkun0OfcHqEj6LpIDlDLmwskc2cpv74b7tyRhF8OdDAkawOUygR3ih8WsCumrPMkK15LVGfaG7JmAiA2GOxxs5klo3IN0i6YEuKHdrkljw0bzJycjOcp+J7jL1ydSbt18ya
 h1r24r+l
 j8ICtbkbfo3cq4T2sD0737ZS/xxsZx6F5ptYrMrmjiYWLED+tSesSjgi6cs57tJl1X8wZJTjjlYDJQhNuDSSDjdiu+wntQpcUfmdQn/98sX1a4C2Qi1coad2R+/b68nEQkASGkuZMJfx6kKvWenIeaQ129zcCEbBIrLcxv+89MEa9TVaSTpqD7oUZGvypXwAXxTkQ3iC5vo5j6KIIn1MFw1Sf7Z+7RL/wDXhueaKPraN6dq/N6k6T3mQv7y8A24VuSMIXq2HIRqoGS/dvpLjfbLG1KA5dhfkUd6m51jj4wIVIBZg4JhZXmVivpNHvP2pDi0eRV5hgU0e3UO3cWxLJwLmzdx/jq2AHyqGB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 19:58, Suren Baghdasaryan wrote:
> On Wed, Sep 9, 2026 at 10:23 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>>
>>> -     vma_start = vma->vm_start;
>>> -     do {
>>> -             smap_gather_stats(priv, vma, &mss, vma->vm_start);
>>> -             last_vma_end = vma->vm_end;
>>> +     if (!IS_ERR(vma) && vma != get_gate_vma(lock_ctx->mm))
>>> +             vma_start = vma->vm_start;
>>> +
>>> +     while (vma) {
>>> +             if (IS_ERR(vma)) {
>>> +                     ret = PTR_ERR(vma);
>>> +                     goto out_unlock;
>>> +             }
>>> +
>>
>> Can we add a comment whey we break (and not e.g., continue) whenw e hit the gate
>> VMA?
>>
>> (I seriously don't kmow ... should I know? :) )
> 
> The way m_next() is implemented, the gate VMA always placed at the end
> of the address space, so the next VMA will be NULL and we can break
> once we see the gate. But now that I'm looking closer into this code,
> reading smaps_rollup file does not invoke m_next(), so we should never
> encounter a gate VMA (it's not in the maple tree, so for_each_vma()
> should never return it). I think I can remove the special handling for
> that case.
> 
> Thanks for the question, David! It made me realize we can simplify this further.

good! :)

-- 
Cheers,

David

