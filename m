Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CFDBE9904C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 07:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9D46B0005; Fri, 10 Apr 2026 03:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B226B0089; Fri, 10 Apr 2026 03:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0499B6B008A; Fri, 10 Apr 2026 03:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7E9E6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:45:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FB6C1B77E9
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:45:07 +0000 (UTC)
X-FDA: 84641860254.14.5759590
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C35DE40004
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:45:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLT0prWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775807105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ly7znywkofd3JB7DcRaDynC5T65ZOT2rFIFech2jAG8=;
	b=K0Mmwv2kY65SDTgqGcF4qmAvOtY3EORbJbyud0xV812kMmKwxzj+AQtnuLcEErAw43f+ni
	pphqaW/GScxnUjJXYgBk2k5YOI3EPMvkQdApSY/Ac3yEEzcF/SuLtVZsfpcNGEZic1El0A
	fLLduq3si7oGIJpKE+kWk+epqcA+YcQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775807105; a=rsa-sha256;
	cv=none;
	b=ZvKMBJDqZYUGabl8lcKq5YbRzDF1VuW13SQObZ849EcASnGJOwaPDLJ6pzOu9tudkElaTF
	NN/gSNagEp+s7TsE9L73sXCbRrGDLVSHzKJ6ENgM6pgCLpBFzck6A18aXpZ5jtZ1QvJ+P1
	QOKQxi6PIfLrD4u5+5G05knROZAADu4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLT0prWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B300260126;
	Fri, 10 Apr 2026 07:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8123EC19421;
	Fri, 10 Apr 2026 07:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775807104;
	bh=DtPmOk5kJ/H1o3+QUlVWzL6Vnpd4A2X9fTpGymihk4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OLT0prWjcLBJjNG9IaNrY4LsYY74iPhY8gJqZc+q3w3DPqJjCATdr2qsL1x9jS2jT
	 nyGL/NlVRSoOczjSkNjoYNHk7RhOd0FKY3hmmQCN3dpW58ritiaivgq8vTPWIh6rwO
	 MgRL5nfIKqbEGXUeoXiNxZF3REqOq7PWTbQSo/TACVh267ge3wPAigxY4uZugbXNV+
	 +IYxfTiqgngGTk6yVeG3n7zr8ndnw5KeyFjdxzjjAXxGLyQ4XK/Ssmn4patMExm63j
	 sccGpHBFSxccYGV6fhOVfynLRZeGL3FKNzxeRcQygx4GYPlm8y30qv7hao3tshcVBW
	 +nXBaqtdJ0irw==
Message-ID: <c4899f82-caa4-4692-bfdb-7ae4833f30cf@kernel.org>
Date: Fri, 10 Apr 2026 09:44:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/sparse: remove sparse_buffer
To: Muchun Song <muchun.song@linux.dev>, Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260407083951.2823915-1-songmuchun@bytedance.com>
 <b22f0af1-848d-45da-99b2-0c28b740e979@kernel.org>
 <70EF8E41-31A2-4B43-BABE-7218FD5F7271@linux.dev>
 <dcc3b56f-5d4c-4bb0-bfd8-49747df30f47@kernel.org>
 <adfBVc8ohLrtIe3j@kernel.org>
 <BD30B00B-76F4-4984-9B29-9668896E761F@linux.dev>
 <45BF3CAC-2E64-4CA7-A7B8-800FC90930D5@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <45BF3CAC-2E64-4CA7-A7B8-800FC90930D5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C35DE40004
X-Stat-Signature: xx7sgsoqoobsc64c6iuc4qj1pz4izqtm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775807105-308399
X-HE-Meta: U2FsdGVkX1+zfGg9OK0tSlggQES47vkx4TTqLQvhZwKLHkNp4oq7cmj0SBoqvpXVFXPzEw5PRiEw4KMBBGWb6jQpxAbBlyyTFAq0631b7N2NHSs7wLBjTT/nij1GlBsuaBqwQO/TGhGC7fcpbBdZnadUta62A24VLIcq0CM4EcoWcNCPs72FN9YS/5BMegErjI23b1Eg4dBeekly9hbYcqmIvd0KhoXRw6XnzHjD8rrvo39BjM8vK4ATHTEKbobsP4C1zys1mZw0S2xn2lHdhYDWW7WjZuVX23KX/G/OiYGdnLe+MRizKxwA0r+Egrdd97vM9lagSXkHMNBbSe5sjdqomgX8AEnkNCL/qYPMaAX344f96PLTjfIFD9fslrnyNlhD9FsutRZdAQE0fnNNLYE3gDSMR4BYWpHkmsruQHMFS8W6vO9psC7bIttN9fUt0rEoB988dTYqpBrXBLH7vrWx7nv94P9ULKcB6ac8miXLBuQIkkatLz3ZPlM9SEboL15ojrLEjey/iv4A1GPaFbt4q9qoWMo3ynz0c7QmBhHk/oFJYZJnF58QLSrPDB32vCrJwDg9MYqYzypeH+emGfaeAjVh+7nBFhrVuUDP6bOkyvUoUoBl/Ha9X0Dpkg2hqAizsHKWroPewW3yyHWdh7ZtlyU2KN8kbea9UTtD+OnBafK+veawufYD+w5qXrqOCHwcBgiEZ8uzkcG+3XFAhafJlLF0a+Vp/fANv18BrColMbO/frvRszeBft/gSj/FQl3z695O/TNRKJr7OZY+2/jPvPmNfZH1RMBUIJmZEpH5oDBKhHjMYXXQs7Ws34/oaW6nAvIxS21dcXW4LflmZxkaQ5qlz1Lj9Pm2CtW9h2diutq48rcTKTn/E9HW882Tw+x7o8Pm3fb8/bozZEEIKGTLY5z7dy0iqaFfislRb8o18pGlgjw1GnwM6T3+SZcyW06y2HX/d5tB5UfiGSL
 HKmryH0e
 8iIoJAKXYK/POzgv956zMF2kOXfKVVPNatsENaZLOdX0Ea+YvpOWDqVyOJ95xLx6tbsdpjpjYNjJQUxqB/R7Usn+sgcFM55gkI2UO+AlA+xqk1NzbSvyb6A60VSyTGl6BcA6z45BvOF5dcI2i3hMVYf23nH0KxiSSzhRkg5wqX6gwTBr9jErJT6oyJftwU2P0yxtZjx2EdimGm2an3nI9FP/3BZmupp6LMz2rUSVNclhUUJWqRobKnzUW3FLvskT6sP/HHLNaMV8doG/uDmD/4uw4IPojamnQs0RpK5+OXXt+oYDjTpPnhdfXBjJAs2ufzhAIY92T0Kecl4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 08:05, Muchun Song wrote:
> 
> 
>> On Apr 10, 2026, at 11:07, Muchun Song <muchun.song@linux.dev> wrote:
>>
>>
>>
>>>
>>> Hi,
>>>
>>>
>>> memblock always allocates in order, so if there are no other memblock
>>> allocations between the calls to memmap_alloc(), all these allocations will
>>> be together and they all will be coalesced to a single region in
>>> memblock.reserved.
>>>
>>>
>>> ...
>>>
>>>
>>> memmap_alloc() will be slower than sparse_buffer_alloc(), allocating from
>>> memblock is more involved that sparse_buffer_alloc(), but without
>>> measurements it's hard to tell how much it'll affect overall sparse_init().
>>
>> I ran a test on a 256GB VM, and the results are as follows:
>>
>> With patch:    741,292 ns
>> Without patch: 199,555 ns
>>
>> The performance is approximately 3.7x slower with the patch applied.
> 
> I also tested 512GB of data, and the results were roughly twice that
> of 256GB, so for a 1TB machine, the memory allocation time is only a
> few milliseconds. It seems we don’t need to worry about the 3.7x
> performance drop.

Good. Can you incorporate all that into the patch description?

-- 
Cheers,

David

