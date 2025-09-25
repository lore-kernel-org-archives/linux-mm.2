Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDCE8CAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241C38E000F; Thu, 25 Sep 2025 14:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219CA8E0001; Thu, 25 Sep 2025 14:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156898E000F; Thu, 25 Sep 2025 14:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0695F8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:52:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0681B9707
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:52:52 +0000 (UTC)
X-FDA: 83928669384.27.46FF9B3
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id D9E12120004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:52:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail2 header.b=VL0Rnr3C;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b=Gge1mCn7;
	spf=pass (imf29.hostedemail.com: domain of me@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=me@elijahs.space;
	dmarc=pass (policy=reject) header.from=elijahs.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758826371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0w+cnl/laqV4R+hmMmgCWTNT9XgwKK666GaukqY77w8=;
	b=pxkqyAkgZrj60x1O6rl0SGUX2TduAVfZ53RXdQPhfi1SatgNWPFlawBDNg3sZGzMKNCx/O
	rTpUkV+XeQ5pSjyADh5YVI3i1+RUqo45+VFmJ090yzHOysZhRvLYGWBfEicFhg2BF4Xc3o
	d7FEW7bYf/tXwuANl/4Khr5Hs0/Wd1I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail2 header.b=VL0Rnr3C;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b=Gge1mCn7;
	spf=pass (imf29.hostedemail.com: domain of me@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=me@elijahs.space;
	dmarc=pass (policy=reject) header.from=elijahs.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758826371; a=rsa-sha256;
	cv=none;
	b=JmpCws1ZYIejh3LeBEgXijYhb4abullwcz9iSAAfc2rd0oNiALCTGW3si7AzNvOBoApLGs
	ikbRSJjGzxe2g3OBVqlMrdIrSEf9+ge5RWs/28ZpzOkTIo1Mmnldwjju3HiOjI0Fr9n6GS
	vcqYnd6SF0y1R0fFcHQ4YHZObdWCsos=
DKIM-Signature: a=rsa-sha256; b=VL0Rnr3CT252ggiJajFl+wGy782COuKaCRn+M0Vx1ghE9d/7xxu3IyiO8W/Ir4CDeA32xB4C/vrzXsoxs77br6fib1WuFh+vNRj+y5lJLlUSlM7HRyb88WufKm4cazfNv5+9Sviocbw6NNuCJApMqGUlhwPX7i8N0oCzOddGxzquwRy8qfeT7NAxePZzqNV3W6ueRfWdvcnB2HYvkuQL4oeec+9dIcvi0ITBI0WGFieHGkDRi06mM13HtMaBx2HI6VzyDJMkLEJAIzhgpZklAiekRxeiYA+7GgsvG+SmE29MNE1CiljMx1y/KEfas2XtAUAM4qNI++Zar5V8gnLO7g==; s=purelymail2; d=elijahs.space; v=1; bh=py1R90auHUwRZcLSo/U4sqM+Pp8Fv3SpehMlnxzLw/4=; h=Received:Date:Subject:From:To;
DKIM-Signature: a=rsa-sha256; b=Gge1mCn7UZnkjPpZQQY2BEihVNsQPCQVv8hJTjwZAahrf9Hw2bQTq3FnnXMZbyILiTqnV1J9SE8eEZJxZqbyianaOJ8oiwoHjkM/7nebnSy3gy1IHh5WF5pt6WydZrqRLFaqt6Da4ToRWfxVLGi/1uMmxvTbmWS5WbQiBJcJueNnplPhaXOXsOrJNFQDqO8uefITIGF0yZ/1ieL6GICKf1ItUrTQvw0D5mj1W8sHC11uw2/cIPK02Rpd3/uA0tM4lqIFdEdK7B87MaZau0TF/2hmtsP0F3bJ+PTkGaT8+0bG0YxrT44bY54tdf0CLvLCPBP0vGWp3ePE0Y8wLQxLcw==; s=purelymail2; d=purelymail.com; v=1; bh=py1R90auHUwRZcLSo/U4sqM+Pp8Fv3SpehMlnxzLw/4=; h=Feedback-ID:Received:Date:Subject:From:To;
Feedback-ID: 26912:4866:null:purelymail
X-Pm-Original-To: linux-mm@kvack.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id -567714660;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Thu, 25 Sep 2025 18:52:20 +0000 (UTC)
Message-ID: <bacf0774-2128-43e8-92cf-6754fb554824@elijahs.space>
Date: Thu, 25 Sep 2025 11:52:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: slab: add basic slab module
From: Elijah <me@elijahs.space>
To: Danilo Krummrich <dakr@kernel.org>
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <73d7d53f-439b-44a9-98ca-0b1c8fbc1661@elijahs.space>
 <DD22FI7F2ZHT.32SL8PXFZZHV3@kernel.org>
 <6e9c820f-070b-409e-ac25-af96b8b962c6@elijahs.space>
 <DD234804U7YK.3S2MBUJSFHF8J@kernel.org>
 <74b3ef24-a307-4d3c-891a-8c5283448b20@elijahs.space>
Content-Language: en-US
Cc: Elijah Wright <git@elijahs.space>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-mm@kvack.org
In-Reply-To: <74b3ef24-a307-4d3c-891a-8c5283448b20@elijahs.space>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D9E12120004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: jm18ti1fdixjw84tbezz9eoc6k8h95nc
X-HE-Tag: 1758826370-437688
X-HE-Meta: U2FsdGVkX19bmwmc/zG2+Ts4Z0sxHAiLpgzQqZSBUE1eDGY5+Ydw7GrvpDi+l9c9d4RsoJE8MhiFKCh4s0lXauOZPeYfFcFJbaYRz86ilnLX8sKCvDXsg8GmMExHrR9iCzr+pYav1qvCI0vHPrQGr5SmdDnNRudVfdKtOB9E3Qk0yfU6DtiKBItPaIF9C6rdx3gV7fcuDqq6785vB84m8/sqrWTt1VnhE7bdjxMlIdBLi7KV5dsFI3hL2aDlEgLme65lXMJYfw2AAFpw3WZmohxLfRwfAaBpTFrBmBBeR5SbJbXc+tlXe4+qwb2U5sJEulYZo6aiylXh95G2KaC1ysK1VRe4EKA+mbUAn/wq/Qu4kXt8EiZI/8e7D+5rKqep4ya4fQZZ1bzi0UuZRLFO5Ag0YruLgtaR5tq9QoneCIDUYlmOoBU3XfBQvI6qEAD6LA9sxjau1koEnhbggSDLCYMAw28++I2tbj4RDENoBrcj400h3AJtxllljBYNsNsMZRUSKS7CVw+xeW1aSnPIu8uxpUwZF5P9nvbnbMCSiYWFAt9rFodXetsklVpZPG2wRLKW1VgVdt4JsARNCMFC6ysCZusD9xOr0K3bXYpzJKu7XygDZ1fEyBXOnC8XceKYQpCY11bYQWnA8mkOVwh8dvhyhyXUd00kyx+a2DNFyuscLm98uYNENEwEyix28F26/EX6RBZuEPWnMxt8trxarwgD270YHmvx32nMB72iSoLGIuZd0c12uSjYoCTDwkU8DQ+qAggCsOOF90XR5ybpRpVMbll/I0p15ydIqgWPtdqM3px3uwFwfbxfHxEtRwyzQADU+IuIahsrGCDTBfHg1toodlhj4ZVZlG2l4L0B3tLrhfRw3GqboKDSdUZ5OpydYo8UD+u8zDUUtJJgPe9BTM7ifsLaOTcJUVsPCUm7btZ/xLyZRSRtvTNN2xaDE1O2k0357tDfmcKy3GgJtPE
 lop0TQ9j
 yU9gI0n/DhhAaO3nMUkf721dtgVttrNrJrqXWndCpkaaxd6515c3kRlqxtkvbgtLn6yDbiCkYPbmzrVgi2bridStN+ABnZmYbwuXEUZ6KJY2cE7SGVT+ptO+KUNMIMdyrJK/D/bh8+3R6KkAxFsfqkzjSvVUQbymwEIK3a0CYpvaqL27EbuiSbIV/2y7AcFwg0VKQR01yIN7lJxwxO2nrgfBGyPr/Rh+56JOY9k8mPq3RNi799xFJ8kiNmImKOz22r6d6dylLv03jbM6F7464u5Ky+8q0ET2K0yaLuhYhwiVkqpVckmxULgcmceBb5a6uVaaCfPbCA0TjtM0S9FPgOiq46mOJkFob647midPoxehFTj/cB0/Q/natKYCFawe9YzhJZ8WF00KzEHuxxjdAifn2FSAFXbB181iOz9xqV+ufiQWKossmfOCrk2IcziW6xUsRzSxKBZ5xJwYvzE6X4Pq3WFKagYfffTwj8DJ0Wn4TkExIR9R43fW99Svzf9Z0Txk+muwbqTt9Lx4WtwbegDYZlmk+L0aPfqj1XJ8mHtl1SbKbQDwtHyQFVogG1Rt3zSA+S397aQpZRXar/YpBc1/Ev2J8v6WijUm6tAcTakw8rETaDislEEmDCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/2025 11:51 AM, Elijah wrote:
> On 9/25/2025 11:15 AM, Danilo Krummrich wrote:
>> What are the other complex issues you are referring to?
> 
> I think I misunderstood what was involved for (4). I was thinking of 
> keeping the extra reference in the object but I think it can be done per 
> CPU. I'm not totally sure how much would be changed in the kernel but no 
> matter the implementation for (4) there will be some complexity
> 
>> I'm not sold on duplicating the Box code just yet. What issues are you 
>> referring
>> to?
> 
> mainly where the cache isn't static. if you have kmem accounting enabled 
> and a ZST that encodes the original cache's address then that would 
> break, unless I'm misunderstanding (3), but that's just an example. I'm 
> just thinking of potential code in the kernel now


