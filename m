Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3C6C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA7C6B009D; Mon,  7 Sep 2026 12:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1E26B009E; Mon,  7 Sep 2026 12:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179E26B009F; Mon,  7 Sep 2026 12:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD84C6B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:19:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4C65A3B41
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:19:40 +0000 (UTC)
X-FDA: 85187476920.27.A509D0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18DF3180006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:19:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ge/5Y2de";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788797979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LN83XCwEw0CeM7tqxYmhu+3et4F7kdFb/J83nVH818=;
	b=rIRf/aBvztdAZ765luNedsKXzT7qqliO50YZK3cdpOEn1ntjA0zX1qdOnERw7kHy4AE4lJ
	qKOAV7JlnyC8yOUUfhOY0tB0XBObvROoHuyuguKyOV9S8bWN5wAr+gPnTCyfez5W0mcKEh
	4JNSxWoF9vtXOqOWWkFbQlrWzW02IeA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788797979;
	b=8o4jP258VHdTEI8Edru9NRogSMargjri7Jdh9h276QbGiXtDgdoUaQP9zmYkKzZs3jjVxP
	q9HS35XyAsTAuBBRVvtsq/LY7SCmrT4QhYYp9BIHsJa1j2SW8zItLQRFDuuqfZMNr1s3Iy
	Iz2ddSzNQ2uEMTNSaR+tnLqD7cqc3xM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ge/5Y2de";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DA2343DB0;
	Mon,  7 Sep 2026 16:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0DC1F00A3A;
	Mon,  7 Sep 2026 16:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788797978;
	bh=2LN83XCwEw0CeM7tqxYmhu+3et4F7kdFb/J83nVH818=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ge/5Y2desrl/XfwFy1P9kpoOoNrn78RFVs6DtfcnprDcBeyMH09VBr6qHacHQVoHb
	 OmGK+t7Wyj9s1XIsPSEJJMlibGxmIqEX5Is8Gya+y8eq/HVMaj+zA3DylFzdL99rIJ
	 qU9ZPOdC1uyZel+sO9ONnEbBdHZSk44DuBvm8lj5XVkMF71eMOwhiwUej50jRuTKi6
	 doku0yv3r9+weHQKLMARhBAVeyvv1l8dp+QRjruUcuND633KxsNFj1M44I9i8UlrhE
	 58hvfOIA/TuvxQfc/chCEnMaAOI4cqVz8xhENYNUkMhJI0asIE69IqgCV8NXJTgOXx
	 bcK0WIXLE82lg==
Message-ID: <4743f22a-c24f-4f93-80f5-3260f29bd410@kernel.org>
Date: Mon, 7 Sep 2026 18:19:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Cedric Le Goater <clg@redhat.com>,
 Saravanan D <saravanand@crusoe.ai>, stable@vger.kernel.org
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
 <DL08J4JGJ4UK.2G92WO0NK8XU3@nvidia.com> <apEzvfGgsvbc3vBI@gremlin>
 <dc52dd1d-f62d-4278-ab4d-95746383fd50@kernel.org> <ap7i1vLkfZj4rbNM@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ap7i1vLkfZj4rbNM@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 18DF3180006
X-Stat-Signature: w8zn6x6ifx8bh5se4m8nsiqugi58yu8h
X-HE-Tag: 1788797978-327690
X-HE-Meta: U2FsdGVkX1/ocis78t92HLF/a+qSjguwP/pSX7/NMfCHthdnlaMIenUJaxfRiwAktyPXDvp3DJKEJ/ziWdDRi02+XG2h7dMAWk561x+GV/CaVleMqsNsPAEBd34fW+M0IL1nydDX2OoiZs91RI1PRIQd4AyYt9I6lF6pV8iqQLT/fG586RWnKjKl6yKo/8W5/tD6F1uaeJcL6bGRuh31Ux6S8YIZfdb1BcCVYRKRMrj1kF+Wpj9fanoICzMq+CEqemZ5jOmBs716MMP4fZG8QWC9YQPBB6Tzvn8Zrfy1tap743nnEQuGWDAxMn5RoSeK3gBpbtoCB3/DXvQAZ/rELgqA5oLcovvsuXjA28wLKsxhgAzwnT6AT8Kf1fOrfqa8ejeVtl9C2083Rfwy2FzskjhUSLCiqRTv+GxS+lofgrAgNsAZKB9VXwy3lhT5MQDUh184UjxYndNZZGV77AT0eTqggnpFtWL5wlmoNTbBkzmmMj7X/ZCUGe11kJCOaw6xJm6d6XOoWBD0KE4ZZgdOG3yxsUC0drFdSvCjY7qPKrG9nVsd3arpn4nHM4eq0z1b2B/Um526NY2wNpwMab/5X6NwKoikZqpmwbbRDJFWiUXaFVfcV/fqcJZJVvH78xWYSodf+ka/SY0k4V7hoSPni5k3ZL7ZrZ7oDokaov9RL5kg7NVy2VQJeonyVB47V0Uw8ouP9skvPHvjB3nWH1EIAc9Fr0l2+/MDKMqjh80MI+tgYrixw3Ckjdy1GKfjwTXBEUAk22vtVVK02dY2jHhRhOyqqY0EJXR04Xd/am1/zhyIn2mg/PRymy82rAFv+FA272+rSyf4MxFmJiIxLeDMls+kQWDh9U2AVgajHDk90BVhm9HLsawl5Wq8pLD/kTl/vdWqIIGur+ZzAZdih4oeqshNBjD1FM7sUgf99Nz+vqhQnTczV/lFgvCsmpxl82D2wAHXiETghiFAF3P921D
 VI69LBJK
 BnSaeo738j3OPyfaJnhIJjtb3uQqkFFhhAXVLXTNVw6U7SZ5yA2IJeFKdzzsfJdzK7WaUVHkH0fcL4jsBJDEm+tksql2qXvKh00+sFXltBNYVzN+YHWDnP9OaP8sVf50LCs1tYGfm4YtH0nc6ZU+zD9nmq0LoDTCn4W7rExEtKAL+pzgaRywOTE7UlixfCc2nmVQH/1LR8BF0KVb5JKF6OZIUjuvDa0ZCwIO+/i+DqgrXLqbRRyaHB0jIqb0iKnseMwYStGLGzAnwkeGXS9tdMIsVxSu5cj/crvXO6aOgXaMn5cge5eR3fF/7YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 18:15, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 07, 2026 at 06:08:31PM +0200, David Hildenbrand (Arm) wrote:
>>
>>>
>>> That's a good idea! Much better thanks.
>>>
>>>
>>> Yeah, it's an annoying one as kinda want to say 'file-backed VMA' but I think
>>> you're right vma_xxx_file() -> vma_file_xxx() is better.
>>>
>>> Andrew - could you fix that up in place?
>>>
>>> Obviously if there's further feedback I can respin as well.
>>
>> Just as a general note I really hate these in-place updates.
>>
>> For a reviewer perspective (like me stumbling over this) this is just a mess.
>>
>> Resending with b4 is as easy as it gets.
> 
> Ack, you are right to be honest, and I do empathise obviously.
> 
> I will respin these in future!
> 
> Let me know if you want me to respin this to make life a bit easier?

Sorry for being grumpy. With 1500 unread mails, playing Hensel and searching for
breadcrumbs in my inbox is hard :D

(I did see some reply from Zi to an mm-unstable patch, but not sure if that was
applied in the end -- or whether Andrew fixed up any of that)

I just saw my reply to my other mail, maybe a v2 would be best :)

-- 
Cheers,

David

