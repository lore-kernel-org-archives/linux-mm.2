Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE97C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 17:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8965E6B0088; Thu, 30 Jul 2026 13:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847746B008A; Thu, 30 Jul 2026 13:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784D76B008C; Thu, 30 Jul 2026 13:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5985A6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:06:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD245A0201
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:06:56 +0000 (UTC)
X-FDA: 85046072832.15.A10E91E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B83F120012
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:06:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fmi6LRsr;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785431215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPB2AfdHRdPc2DMRyW0J14/UztpGACDnV2tnp4eKA88=;
	b=wfuiJP7ghtT6fwVFjaN8KykexHNLKXPmVKgIEjArvW5P1LuTNSGCfnK7EhRiy2MqXUP6lt
	WVzpPpQb2UgHbrwoErLK3Yu9tIaUTL0piYihWrbMkQJpiwEhqoL7C2wb1C7tQmloU8KiCW
	3tfNdgYyuYxwJwqPvKq07OEPqzjB7RA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785431215;
	b=xFnveFebcZkWONI9Z8/9FhelxBYfF0mhtEymSdMXZ9lz/r0po7YtdOhIKNLN2qY/KEIrFO
	PZcqV9IbKcZdiSLXTstHn7GdMx7Yqnr3pJMF2vzWdDy/aQONIqh6XG777xxyiqy3wXD6OQ
	nfioTbsWCLwGW3GHD0xwRBPpcTs9OPs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fmi6LRsr;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3F8C600C8;
	Thu, 30 Jul 2026 17:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C241F000E9;
	Thu, 30 Jul 2026 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785431214;
	bh=zPB2AfdHRdPc2DMRyW0J14/UztpGACDnV2tnp4eKA88=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fmi6LRsrjzOgSxVDFLR2UxtKUmOCQRLfUuUUTh+s9POqz1QMZEShNAXSfqc3XKYdr
	 cRBS3TPxYm06L92+Kab2oTiQENBrraxr2Acg6oBG2qpRYQE0axMrhcqrqEbX6cazUL
	 9DSo9ZYklaQ8Lvt9TA/xT/RA0Wlpj4mgr+YMeKLyaCOLuVi99vCBjcrySFkGwqXj4R
	 kmKzfl0BqV+pjdBNMYDRpYzkyAl2xC1iuqmztsNOqCstqndCg8tvY50sFcEkVtCrub
	 tYBtj47X/A7xEqjK2pMKR3H+Hbqs6tKDCgOdOP4vXV/vom1+CsGQPP02kzffjdmZcl
	 N3zhvuP2CTOBw==
Message-ID: <ce8cab15-6236-454f-82e8-44662c789d19@kernel.org>
Date: Thu, 30 Jul 2026 19:06:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use proper PTE accessor in move_ptes()
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Pu Lehui <pulehui@huawei.com>, Andrew Morton <akpm@linux-foundation.org>
References: <20260720141633.501799-1-agordeev@linux.ibm.com>
 <7f60a20f-7293-489b-8539-847fa1b96789@kernel.org>
 <51102823-ceab-499f-8b6a-162e392f864f@kernel.org>
 <b7947b4a-7cbe-4b8c-9ae1-fb45660a7db6-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b7947b4a-7cbe-4b8c-9ae1-fb45660a7db6-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B83F120012
X-Stat-Signature: 8mf5a5do1b3ogf1ixuchurenbetofaex
X-Rspam-User: 
X-HE-Tag: 1785431215-778423
X-HE-Meta: U2FsdGVkX19c1o06f5V77+neMi9eid06PCnX1J59OmQEGZ1RRLLgpVA5GGU9lpz/9MXQKzFDUYJ/KL4xsU9RM7Jf6v9ANR0ZRLcaf0UfIFTjTGApXHIQaJemoATneHWDVX3OEPyTg79bVehR4jNeArvNVkgjxbB/L7KcI6JktrnALRagRWXCNhondrMklSxyFX1NSr9xwZVcbk2yXuks7aZbc94Ri6WhEEbgDgegJif/ylVrCeTd0gAuQON1zUq4HUPFlhWgHWhtxEe1n/5LY4wnQ/7Jz9yONzMxCmG2JquIdjy1G/8I/NFOFXQaV275SXdkf9pPsHEbx204HJIKJb3gTFORv3jx60k6P3JG0ik2ff0eMWrj8A/fy5iRPFdW4rMbpxbpZ4Nnm/9tWgWczYoXXBvQO5MljuxV7Zyj0T+t6oahBocrn5qcIbSCbYKosXFBu82oZrvgkp3dd2rclhsywbRlNNgBG5Fr7jYrXX2edY2R/ubRt541nEc2ATyEzkydtd/nxffG2BmvxfgLIH1gbsbEXHX4CSJBPvu4Wkfte8mT/WvqNq6QkEIqLXJ2MBt9MwSkmhjnZ/t/LcLZYxNO13Ogu4fo35HseS3qKqUUUpbNmflAKrOCyxM2bSbp6Kc1O0aTWE+ilQqcg3kZTmvSw+fKGO08IyxWH66LXNhmqsZdCNjXei9ZCOPQIei+5lRDprk7C7dBu6b/ZOhHu80Yg5N8KLqh1w/pH/VeJ2s/1NcTi4RQeD+TQ58kSj0bI8jR36iUzNcno/tADr5nwJApDp7edm+xi1/GeKiPDDJpNwtm7yCyGAtIF5r69yXH7D9u7cDeyPsStXPbIrBIwuU9Ltn7Uvr8XfcSF/R4U3ppgvkjchFaaaEcH8mEhG5dfjpL79p94yUMeS8yymr4GVUdJI6a2/ar4c+Ezf+cTvlY2e/dxA2xs9SnUegyP+LgallNUtHfzRNDLlWO+bX
 H99gCrBt
 vK7GVtBm2RbsNC5mIB4l+JCgEyFYUU3JOIfqazlfWtIqUTH/UESVgJDHQNtY8QeRGSeVBDXwI6ImTiu1hxbaBTnwVJW2GffFMAbdB8hJo7J8yJ5MLaq3Tb3iavdLQXCzBf4nNWmck7ILJ3Qnrp4P3po13ilRvBKnjD5Ni5hIxdlGe9E2P9mhdWA0t+HA/UZkB81niDcpxkRU5KKaHw5ZIjP0wDyZ5jsWgOaB6/cOJflDlirU1R5pQxPIOlD6OwMV6sgC/potsMkBqxU0ErYWyhxeOnna2RpNJkAlV6IgYvMUh+hxtovmfSi/ue7v6sVuxMJBxS3y/dNbADcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 16:50, Alexander Gordeev wrote:
> On Thu, Jul 30, 2026 at 03:08:04PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/30/26 15:07, David Hildenbrand (Arm) wrote:
>>>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>>
>>
>> Ah, but I think we should drop the Fixes: tag, or am I missing something?
> 
> No, you do not. I confused it with ptep_get_lockless(), so no bugfix
> here. Should I send v2?

I assume Andrew would fixup when applying.

But looks like you missed to CC him? So better send a v1 to make his life easier.

-- 
Cheers,

David

