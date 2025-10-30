Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C9ACCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4DC8E0146; Thu, 30 Oct 2025 08:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACBE8E007D; Thu, 30 Oct 2025 08:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3408E0146; Thu, 30 Oct 2025 08:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5A4D8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:01:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A9B94A54E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:01:08 +0000 (UTC)
X-FDA: 84054639816.13.D3F12F5
Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	by imf02.hostedemail.com (Postfix) with ESMTP id E81CC80002
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:01:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=nVbdWkTz;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf02.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.218.248 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761825666; a=rsa-sha256;
	cv=pass;
	b=F548BTYCF7ZUxcGbIAX48R7akkogw7kvC/kM4DAk5E7Ud81dtTKLnlhRJHxLZ6rq/RHSmm
	Q0Hz0JKK1h9el3FjIAktlPkDZomvUsr7zS1ZGPLHEJBTjnKp253XXzyzFzCpLSToL4WkV9
	JOwU92sXenm2qpPGS7+Eufkc2rdDFpc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=nVbdWkTz;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf02.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.218.248 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761825666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuWMJV1liOd3TUD9avVTueshZ59unlTwwCorV+fKC+A=;
	b=7N4HMyAJcuvqM9fVA6viIoTBoL6l3M8AyltYdsgd5Cv43sCYQvssBGPQ8/JjgdpBd/ieqL
	CEc8toFTlOv9AXKyF+zSeGpfOfrNO31sIOrwqco8C4OOHo+k4oEvAit9tvL0y/5+OGnKVf
	AZW/TjQueWOFulry3dlM1u5m0+YVaL0=
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 29BE76C18B5;
	Thu, 30 Oct 2025 12:01:03 +0000 (UTC)
Received: from fr-int-smtpout27.hostinger.io (trex-green-7.trex.outbound.svc.cluster.local [100.123.217.203])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id BDCF26C0E0C;
	Thu, 30 Oct 2025 12:00:57 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761825659; a=rsa-sha256;
	cv=none;
	b=S0XRe4/6e3EXv0r+q+blYtcUkOAZZ0Z90qSrKO+SWzA2+aSckEl7GL4oZfGCJuvHZxeJfu
	ZVdL/bkce+h2dG0VBzBNgcsa1cXd4HNH9u1eZPPZuokkPEYdTVlwi4fIsVpPRMpnoW9r2E
	6rXsMKUCuBDRLCaO9rt5T8n9aU4RBy5S1wDaSUHGSMOxLxGAwoqY82A6W5/7R+E9jAc71j
	agF0MBeFn0p8nEoDiLOBBQDrdOxkwDYuB4qESC1fbc9bpzNmdY3/nwjCUpXBJ5vz6Rrig0
	VPJIIdCIqFH1+gn2i5hMkncZpl3K5eBEXMDnSecq62ALAUml1reyFsjakt8hPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761825659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuWMJV1liOd3TUD9avVTueshZ59unlTwwCorV+fKC+A=;
	b=KPqFDWot6ePG8G19AtNBoOfwMyfhYg5ddAt0u0VxJ7BMsBWYPywQCV6A7Javk9Y6HO2rrD
	84wxdBY1JicMN46/RPDyNtPvRxqJx28Wh8UTlxcWb9yj1RHxCBweedVCbMSq8gkWaKmNiG
	K4ffZF4o3yqDCPOAgp918SJFN1+p8ga8m/hZpArlub6ZM1+BKyohbxZd/9hijT8ZeUrHXU
	sFJFla9BQVFmf6/9mnpOYxjs9LUmOEk+aLEs1PIxpqJjRO9X1vt8lzzgwx06J+58+8bHn8
	rd3Z1asoklKc8tmejKnOAhRqqu7Uh/Uc9WUFsNrUyAROonCizqXHqDZbJf+rqw==
ARC-Authentication-Results: i=1;
	rspamd-77bb85d8d5-jf6ff;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Befitting-Company: 175df83262db599b_1761825659426_2467219174
X-MC-Loop-Signature: 1761825659426:3308522558
X-MC-Ingress-Time: 1761825659425
Received: from fr-int-smtpout27.hostinger.io (fr-int-smtpout27.hostinger.io
 [148.222.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.217.203 (trex/7.1.3);
	Thu, 30 Oct 2025 12:00:59 +0000
Received: from [IPV6:2804:d59:8970:3b00:5f26:e2da:68e6:2358] (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cy2kY6M1jz2yr5;
	Thu, 30 Oct 2025 12:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761825655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NuWMJV1liOd3TUD9avVTueshZ59unlTwwCorV+fKC+A=;
	b=nVbdWkTzYp+oeqalz7eskZrgKXZFVrPQ9MovDhB5PZxsG3wEK0INDQ3fxt9dxEeT+l4g/Y
	fSQZJoEsTeFa4xluPQTE0vHa9l8ENtmLibmRwHpeHvjO18JJt7AMA33qCS9BnZgNYVoqps
	oijIzV94Jz/1c9sYcW15PtEvyVVmipdcpyzH35uhFx3Xy7eOTEhGO3Fw+BY84ujVp2BVdy
	e/v5fDfz7ECpnmDo8o0qO43JA/Ln0+X0gokePcQZQyBsPLE8Our8wQACLO3bWrvCwdAZpk
	kjnq7hOmrHYppnvI7daNPEceZnKQiXSdSQQ++k1RqN1pfyLx7C2zMyUz6SHfiw==
Message-ID: <728445ef-d1e3-4494-bf73-9d0ccfc95d75@israelbatista.dev.br>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: change type of parameter for memory_notify
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, osandov@osandov.com,
 linux-debuggers@vger.kernel.org
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
 <20251029195617.2210700-4-linux@israelbatista.dev.br>
 <004bb148-a818-43d2-af04-2f2ed85cbd67@lucifer.local>
 <f7dd549e-7dd3-4fdf-89f7-ef6993376809@israelbatista.dev.br>
 <9385ec9c-c002-4781-8f1f-a9eb29b2ff40@redhat.com>
Content-Language: en-US
From: Israel Batista <linux@israelbatista.dev.br>
In-Reply-To: <9385ec9c-c002-4781-8f1f-a9eb29b2ff40@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2025 12:00:53 +0000 (UTC)
X-CM-Analysis: v=2.4 cv=NuiDcNdJ c=1 sm=1 tr=0 ts=69035377 a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=m8KhvXbMWUCy6Yi4DU4A:9 a=QEXdDO2ut3YA:10
X-CM-Envelope: MS4xfIMe2t9eYzfYusouuRAhnHqzUZyToVh2aEy5ZotFemE/q7vTTqYejFJWwuivKR5giJLyI1E1GIlAyhzau91Z68ZzJYEFH32Nf9osUurWdOywyXL5RCKH jOgPl8ZV5AqzdfKl8NmmoNMjC+yK04y5aukJbpQiYDetyPfMq/GkKeL6k3iWQJkiJuqyjAxXt1x53hYB+T31vi8rtXs1twOl09YI/QPVN00zLaIB2brIFRLR 6q2CDFbUajlmgkJ6PxvJ/9BiZpv5CuRg5Bhy8ttMBPadwTnIFYNKJC7F9LZ7XrJXVwfX+S6CfcRfg1TiHonIQsM4GEWSnWHUb9rG3T1EmafNzye3EHO1MSJE JkB3fsnr3MH35+pUjXfiNtq7tCPNTAcas73Ys6oug7BGcMRDDp9+dT4HcZn8N+bAE6QjGmyugmUX6Bm1j/K9UUbxsNW8f+7MsEObUxy4j/6vi8gYZd4bhZsM o9CSkAZ7Aqo+dEFY
X-AuthUser: contato@israelbatista.dev.br
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E81CC80002
X-Stat-Signature: zsajrndinc1i6npzi4ripbxceqnomcet
X-HE-Tag: 1761825664-628923
X-HE-Meta: U2FsdGVkX1/0YtVfTmi49yNBi2zqLWHPDZ0Y1xiZt9VSEVNXJ/ba+4GLqMoFPyKhYWZ74D6r2ln+92M3EnZT/+KO/yvDYMWxaxMBVUqUa+lA2ZpqmjeeccJQqZu0rGQIAtdmYBazT5gS35ova/Wm+eGd+UTUs34jyI7ZVNrBpTtHgyVvhAjbmkEhSdgSiV2cvnFV891qYOPpwgrp8IiycnYafqz9enzzPi93mP80tZ2+T2d0pUCNL6oKFdo2HRcfkZUTvpKqHBAOW/autJaDFZLkKvIKC0F3jhVSacE3GLJWtrFKjDbI5uFFt6TaHZOfV73iXkbExTMy0n34HhdhE5UJeNnJw2B9aISkPiHW9S6nwvdyCcpc+JQ+xULTIi8zpIwLEU3zQNkHPSa9P0tl1NBKac9pavqzq/PSy68NqteQ6KwjPyZyCXAzUHVGy2TAa4bIwdHGkTNTNk/bSVcSwKEKPC8seHq/d510uIjKEDkFkOQeef3YtvU69TDJQuIq94opArO82vXEV7NBSOO0h3X6frZgu+XC2FbXF+otDaL7jb0wGIYEq9CoEotRXsxJXAL+wlk4jKtEGCJGc09zU/S0Wev+pTAFT8/t8NPrnotyealeTRS5J9X28axD96v7s/B45BIjjOe/9T/Ic9s5DBpDmNKs+JH8hBoeRL48VIwI9Ubvlx08YDhCi7ibWwUlUW0jxOQcNdAjqJR/eIH9JP1WY4oiuFhiVAk6TXj+/N0bEsm0kCnz/b6Oj//DyBhOdqvNnPiPlFKiQICcs4UF+yetpEWcQA5Mxuswz96vISSL6ohKAuFL/TKtd3zhyQOdIFSp9R+UA2jK2zUy1PIv/MX3G/SMzvcEu2aSgtuykIjGri8/MRXc+/lqgcX8/erBaz5cTGk1UhNQeGn/irm5802v2gxY5odkRvxIzcCdYwSPqcliZ7Criv1g8wB+VIx4TQD2rQLwoWkD3SnfhxF
 EnMIPomp
 fXT/9xX6tAyH1qwkCgF4+WlckMxZ1Dpst7XUfswPkUz6rQr9NuVMlp8AFQK+mnIdMnet4srlvVD982h4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.023251, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/30/25 08:34, David Hildenbrand wrote:
> On 30.10.25 12:16, Israel Batista wrote:
>>
>>
>> On 10/30/25 07:56, Lorenzo Stoakes wrote:
>>> This seems fine, but I can see a whole bunch of others like:
>>>
>>> kcore_callback()
>>> mm_compute_batch_notifier()
>>> page_ext_callback()
>>> reserve_mem_notiifer()
>>> etc.
>>>
>>> So I think worth chasing all of these down?
>>>
>>
>> Yeah, I figured there were other cases and was originally planning to
>> include them in the patch series. The problem is they are notifier
>> callbacks and changing the type from unsingned long to enum
>> memory_block_state would break compatibility with the type notifier_fn_t
>> found in include/linux/notifier.h:
>>
>> typedef    int (*notifier_fn_t)(struct notifier_block *nb,
>>             unsigned long action, void *data);
>>
>> So I think it's not worth the trouble for now.
> 
> We could just cat from unsigned long -> type at the beginning of all 
> these notifiers to have us then work with the actual type.
> 

Right, that works.

