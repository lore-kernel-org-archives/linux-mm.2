Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19531E9B369
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6550C6B0005; Mon,  2 Mar 2026 06:09:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8866B0089; Mon,  2 Mar 2026 06:09:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4416B008A; Mon,  2 Mar 2026 06:09:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C74C6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:09:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CABCF13C0DB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:09:08 +0000 (UTC)
X-FDA: 84500851176.16.5D6935C
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7977D120004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:09:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eHpzqh4T;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772449747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALgtyZvM7U+ADKVcCq+vWsLwr98RElyoZqbUR3DonCk=;
	b=Eg9aiFLUuKlslj18MsftdrDv3V5BOABpbwGC8JvrOT94NnR20zWY8z5xW3CP6qGeoBmgDq
	M3ft3SQ5HToXVx6Ffp8AwBPE+39It/2O/iK/gQp4vEkyF/UCGef3WhCC2stoY2+bDfEw0f
	S226VdSR3iwJHjMjy3M2MuLLZSOaHu4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772449747; a=rsa-sha256;
	cv=none;
	b=HA5LkcF/co+Tg+ZDCPDEUcmO+piTfm1DOKtgesUsyVc+175HrNq2QF5Mc5Olnp2aQ9KEo0
	RuslykQg/jL4TrnY3BTWuMLsWk66kcdz0H5z+b5ZOYOt79eALXBGr1fWfYsq9JKeKG6YFv
	Ff/1nIMoTnH5vYTXSbNLVoWq4WXXI24=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eHpzqh4T;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d8771807-c85b-48f6-b5a3-a7f167cc9494@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772449740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ALgtyZvM7U+ADKVcCq+vWsLwr98RElyoZqbUR3DonCk=;
	b=eHpzqh4TQFq6GsbuPnCpe5jSVHJ3YXMxlPIIhBK0jXo03V3jnRz3qkm5dHB/xKaM1ACva+
	2Y8OdZXsjeij5zDj3tbrLBIE+QRNrcPXZM4UgCJcT9WztqxJP4KNtYkPpB8oLLxlIXXWk+
	kq5Y65mqoE25P4/NF5WJQn/9mPcWqZU=
Date: Mon, 2 Mar 2026 11:08:52 +0000
MIME-Version: 1.0
Subject: Re: [RFC v2 00/21] mm: thp: lazy PTE page table allocation at PMD
 split
Content-Language: en-GB
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org,
 fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260226113233.3987674-1-usama.arif@linux.dev>
 <CAA1CXcAYt3OfW_uBTYZgr-dBhg99x=5pUs5uvqtpg+PNJ1KxGQ@mail.gmail.com>
 <1d3a4e8e-9ea0-42e7-b8e7-d92fb27f80f4@linux.dev>
 <CAA1CXcCygvA9uUJjB-+2J00srnHbiNGwbvcbqpRer8Vy8QBxWg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAA1CXcCygvA9uUJjB-+2J00srnHbiNGwbvcbqpRer8Vy8QBxWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7977D120004
X-Stat-Signature: b76mjgd7zrnu8p6ade7zag5zcgq6yfg8
X-Rspam-User: 
X-HE-Tag: 1772449743-377696
X-HE-Meta: U2FsdGVkX1+zyutuc4rk4OIRlb7k5U+Fs4w98vJL/YWL4MxICG/H43E/GTmjadWc/J/4mjzgJiPMUkvhrnHLKtHKYkQqGpiFFpycH2ZRcnHMqcpymCp1aea/fdR2mELjCZmU69Baf7mup7K7RQGz4YdzMYOABeIBdo3DAFxkeXfCNfJwbsdrK+bAfKlT3LgQNnumRophVzQRr5qTez+hsWIAAA+ysgFju3pe9YpLr9P35CTLMsIr7gmYStouSv/FkE07rHyhkDJNqrI3O0jr7+SunUVaelut/+dF07mqBmLX16UhGR5jXqPYO4cqgEX1jyABbXlr6Ef8DxzgvVWT2wcHW0QPoYIydSj/ttbxI9JzHnRDAh8YSUjcawwEO/F4BjGnT3qGXyp8fT3EifKhYW8J20ylcZ8MO2xcCIFnR9B1eEuiLpDa7p6Vm0paBgWzffDJd4AKj3rO6f00g5ww70bz2G1LFGE14QWK9s6SeBMnb0R8Jmh8GFTGxPjbay8UIH9zLbm1L/e9C8aAXj/W/wLCytsoVFHNaZPXnfEaCzbaLpkQ5LTe5Xyzx8Iwigv38hlytxUInpwKYrilbKIdmjHKfHTBdxIKbvf3gUmkCLytcKaz6rBOAKya3HH1fqm46AJtvEwlVHiM8veslNDcRU58UI9TzB6LElADy+i+OKrQvTyH/MgQ8V7stgW0X+F2zzcztczfW9svzRmMC0AHj562mnZffTMx65oPhIohW5JToF6uiZPXh25Rir9QKFNLlie6NcKAX8TQjguxDfNh+Rt+psUVJ8VHqknKjUOXWlzzLuif4TiSKQscTvMvE6ChayyGtgdH/JMEQaEecs8+3Lt+SL0oMp9W1k7Se8sjqniSDN7HcYFwJeYnxplq8H/0hteIUfguy/HC0RL1ygOKfijLYOjCq2xyHWZYpHbI4SN2kyxZ7BnPTw2kf17FvBjA0xB/zXCNx30sUnA2qvu
 KZsM/+PM
 5yoycQNVyuAjMrd7Mv9hNVWkWYJyBVp5VznQ5/tPOV/uM7LonAg0dMuyqe3gOau6PbOcfm3ugZYpbcmkStmAbxYUNBgYRrixqczr4vSaA+CTPi2RmmzZbJLV12bu1zqr0d06tSgA4y2CzDcUEuUtAKM5xTsjMqw5pl08DD/d7CpNCzV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> Thanks for the build and looking into reviewing this. All comments
>> and questions are welcome! I had only tested on x86, and I had a look
>> at the link you shared so its great to know that powerPC and s390 are fine.
> 
> Good news: as you noted all the builds succeeded, and the sanity tests
> dont show any signs of an immediate issue across the architectures.
> I'll proceed to debug kernels, and then performance testing. I will
> try to start reviewing the actual code changes in depth next week :)

Thank you!!

