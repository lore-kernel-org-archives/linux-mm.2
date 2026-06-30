Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4AA3C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 06:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D416B00B0; Tue, 30 Jun 2026 02:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814466B00B1; Tue, 30 Jun 2026 02:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729CD6B00B2; Tue, 30 Jun 2026 02:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 486C36B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:17:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDFE61A02D9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:17:52 +0000 (UTC)
X-FDA: 84935573184.21.A66A4E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id F29FB1C0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:17:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NTSJiOpY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782800271;
	b=f3wooXGqVbBmss1nmCtvF7w+ILl+MacT6bx4gdooxYqnzc4Dk6dA89aewFfIobbYKzkhEc
	SibhhBeSImf4qZKO7XXYgaaWjQA6AUdo0UPswvS1MKp0/4wNshqf85VgQvhCDdrEzarBhB
	9HOs8Ona4SMs52Ody/A9egJJzyWOGZI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782800271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/zuaToZgsUAAf92e9UcfIYMTDUyYKGDMg/03yABotE=;
	b=eL8bmTxn88w06/4hcRAoGgdfTzqvr3WhizHy26IVe03AD4MxpQpNdjEu76jHmG5uw+FF6/
	YWA+TTpGxfrKLz7xWOMSOVeM9Rr8+Luo/LBM7WJUTN7W9Q+Z1rjQf6FCVD95rYQ1nzE/dq
	YODfwD4wUMaJo1rUqO+6oAlm7D3uYCQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NTSJiOpY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01A0D42A61;
	Tue, 30 Jun 2026 06:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED701F000E9;
	Tue, 30 Jun 2026 06:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782800269;
	bh=F/zuaToZgsUAAf92e9UcfIYMTDUyYKGDMg/03yABotE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NTSJiOpY8OZf/2rbPcXkoa2mJoqTdGaqiQiv84Y1gbuMh46I9vnDK61ISSo1wLdBk
	 xLX9mGhoeiLya5LC9Lu5SLqtCn1x0ir3AFnknxSGo+NYJKpw73LemWZ0le6X6Dbp+V
	 eVZjRT85EpQrZlHDk/75OsCJ0lx0BmhLEjo3zgcu8Xj3O2PNi7KuSE5sjOlxSeLWMN
	 JQNqc01ALvmpWFKSViX+XJwmUdgEVApBApgttP+uA4l0JTF42QIpAnZuH4WWngj2qy
	 crmaOlyXYwj2Wxb72ExEPn9YsHw220PcBpMuyHnE+J1nybVa9lOlKrazUpOswEw8hv
	 oa9HejB/972OA==
Message-ID: <5c8ca96b-381a-4fd3-a218-6aaa87a9a3b7@kernel.org>
Date: Tue, 30 Jun 2026 08:17:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <0a309ed3-378e-4d88-95a0-65bf47c5496d@kernel.org>
 <20260629193347-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629193347-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F29FB1C0002
X-Rspam-User: 
X-Stat-Signature: 8oo3afnbrg617x3791cd6nwatd13amhf
X-HE-Tag: 1782800270-616360
X-HE-Meta: U2FsdGVkX1+J7qEePXySzRU/mlTCMTrFrHg66jjy1/JF1b9BxKp3fBCfU0TSJzzZrb20DX/vVzOkiL1fvBqzGnG1M1DxLL4LuLls0ZXg2SCaSttrWN3eswnJCrCHpMj5aJvjjPLET56FiD27QAma+rpSODQv2T+UWm+K0zSVdxPbtQYkw53wg2LVd4LhFSqSUdqxvvjzyUP6yxhY/AJr9M8bgrXxbdLxp/FtyAkKFEY051n9sUe2PW+W3Wnywq8Xg8Y3DI0JXPcXDce6h6/orIs/G3By5ZYgeyhGyG/0xoIKXq63BOrrnuEp6QORJW2Ronqxr5m2cDFNuOFLR2pITKh2rWPmPpiIe1C6yqN6DXxQfR2xlAO2+abVmy4jN3AMpTx9rNW4VuIftD5OHBeq0gKiHykOmn9JsKtdywd9piHQT6+csKKW00um0b+jpgiZq7uUVW4vXgcprKFA8RDUBuHAzjETb19U/Mj5ud0HOIvQVCTzQAhi6IUEr91jrnYiE7e7GG1txePnJctq3oigg67KCdAyv0o96yT8BUDel5hn+2qaaNXSLKWsHtItL0rAY7Tvc+4xcwZoUFrbL6j3ClnbwIRrdkvgV5ixIQobMkn3drKYP1R8eUtC7+IVeLogD7adnP3RA+Vi7Q1rXlcmCMS+hPQhAvAqiEbfY61OP9V47F+GCs0M7reaI/+xQnwAqTFuggCXJxIJt500QSd0sDiRZN7PxQr1qT10IJlRgV0zus9WttA3amSoZEGrQei4eXNTiNAnEmJk8KuW3HlkzuDhJFmggnA+f0HPXWC8exMXMVBi2XUOiLCIdrRFNorGMCG9ESx2StCEE/i9ZuRIdG2U0OhO9yMcz9lKukH2nERvsR/4/Thf73H0mtSswU3s6G8AsLGA5eGv00GYl0rMEiNNnrKCVEb4GyT66U8OC12xadXLCx4S1e1+vEBtZoqG+QShm52A8/eDGuSdace
 V1kKw6vD
 n7Q/+QxX9303akuxKR3Nf2CIYRWi1xQXUF9AW2xQU/f/0WWBQa2pVwnJgPcW/ToPP/GmhC1Md6MH5nrDGLkqzb0qu9+XcIZmfSctcgSSXQhm7AJDO6W7bmRyl/bNyxRE6iQE0UxGwJf4dYzLRAl0CxRRc5YYAVFgri35gasR9TZS16Jp1/fhug7jM/iKueq98eL9gmIS46v7/t1sPN64XYqXDAaP6OYQPQ12JyjnS3PXMS+IvFPHQziVNAx/2/xCm+VzgtBLq7J7+EDGYRdbuQ33NFyVcT89AEGJbiGDDtt2goUNnl386fWOfGWJpTliX7NpZqpahVsf8zxZ2FZ2SonXCpAPQCrcVbcxZD/0UF5BqLsw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 01:34, Michael S. Tsirkin wrote:
> On Mon, Jun 29, 2026 at 11:43:32PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/29/26 23:22, David Hildenbrand (Arm) wrote:
>>> [...]
>>>
>>>
>>> Fully agreed. I was hoping RCU was cheaper (I mean, we were once told that RCU
>>> read side locking is essentially for free ... well in some configs :) )
>>>
>>> The question if we could optimize it reasonably enough ...
>>>
>>>
>>> ... for example, by doing the rcu read lock + unlock around the
>>>
>>> 	for (i = 1; i < (1 << order); i++) {
>>>
>>> loop on the alloc path. But I suspect it's not going to make that much of a
>>> difference.
>>>
>>> I concluded, similar to Andi, that stop_machine() is too big of a hammer.
>>>
>>> I wonder if something could be built out of preempt_disable() and sync SMP
>>> calls. hmm :(
>>
>> Scrap that, shouldn't work I think ...
>>
> 
> Wait a sec, what about call_rcu_tasks? Use that and re-check the bit is
> still set?

So, in essence the idea I had yestarday when it was late was the following:

Assume we

1) Can have a way to guarantee that a function on a CPU cannot execute within
our critical section (while updating the flags)

2) We can request to execute a function on each CPU and wait for completion

I think we could just let each CPU execute our desired action (e.g., try setting
the bit).

E.g.,

	local_irq_save(flags);
	page->flags &= whatever;
	local_irq_restore(flags);

And assume we want to set the bit, do a

	SetPageHWPoison(page);
	smp_call_function(set_hwpoison_smp_sync, page, 1);

whereby

	static void set_hwpoison_smp_sync(void *info)
	{
		SetPageHWPoison(page);
	}


The idea is (that needs double checking) that a CPU will execute the
SetPageHWPoison() either before the local_irq_save() or after the
local_irq_restore(). So it's own non-atomic update cannot get interrupted.

Now, IIUC when it comes to "how expensive is this" I think we have (cheap to
expensive):

1) preempt_disable()
2) rcu_read_lock()
3) local_irq_save()


So the above wouldn't be better than an rcu-based approach we have right now.
We'd need something that relies on disabled preemption only.

Huh, but I read that "anything that disables preemption also marks an RCU-sched
read-side critical section including preempt_disable() and preempt_enable()".

So for our use case we should be able to use preempt_disable() instead of
local_irq_save(). That should already work for your existing implementation.

-- 
Cheers,

David

