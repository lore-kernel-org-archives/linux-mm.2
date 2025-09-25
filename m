Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0430DCAC5B9
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3B38E000A; Thu, 25 Sep 2025 14:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A45B8E0001; Thu, 25 Sep 2025 14:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492E18E000A; Thu, 25 Sep 2025 14:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33BA78E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:06:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 041E51404A7
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:06:14 +0000 (UTC)
X-FDA: 83928551910.14.7003B51
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2894C180017
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:06:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail2 header.b=oNOqt+jD;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b=Oxmu7ziR;
	spf=pass (imf24.hostedemail.com: domain of me@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=me@elijahs.space;
	dmarc=pass (policy=reject) header.from=elijahs.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758823573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEMquW2VhfwBbRQ0PN5QprbervQms7llwTMOEC02K6M=;
	b=FN1lgcsJAVBiOsKa27+d79FJ8SizcGMp/KSPCXuX24NvMB0T1Yc7QSJXJ5x8mZL07OuevL
	fHPqMZFZ4tsFd9+jIccblz/0o2DcS/oxh1PplMjNM9kkYbNULE3uLqp9pKSRXdXapHdnWa
	eASLgqOlfbOR61Z5Qhgy4GOpS54LHP4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=elijahs.space header.s=purelymail2 header.b=oNOqt+jD;
	dkim=pass header.d=purelymail.com header.s=purelymail2 header.b=Oxmu7ziR;
	spf=pass (imf24.hostedemail.com: domain of me@elijahs.space designates 34.202.193.197 as permitted sender) smtp.mailfrom=me@elijahs.space;
	dmarc=pass (policy=reject) header.from=elijahs.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758823573; a=rsa-sha256;
	cv=none;
	b=oiokcDYH4X+9FiYDizh3Kd3DzHgFn4maw0s+UhIniyontab9jhqfMC1VOv7YYnC/KiVQ3H
	1jUfeALeQ3Wjd+wCIrM6LXNYAyUW9Ci1fy5vl+tKu3R0Zpr1gTgsGWHAYKOPYJMqPbdsNl
	rjnXZiyVQd9r0bx2dtO+67/9FzhbU7Y=
DKIM-Signature: a=rsa-sha256; b=oNOqt+jDKuYSIGBKD9cxjBxpCm8NIvebbDc0jljBmPhPLpXhoVWi3OwBlOg5VRmW9wBVH3ILRyUOlINQACOZUMWJn8FJnf1jWzFMqltZmd1nkNViQMx2xJn/RdRYIBEoJW5A6BJywcPmhx0mGvqdskHLa8fzDUlexYPW3aA30GEqtuH5IkePPeA+6S/1i/9dOISVQTqPTSdGHKS4zkAqv/QimhRFbBXeWScP+CeOlGtgH5wfUaMRCTKvXkeBrLxBe6ho1wZrTyKJM0yZzy32ZOtL0aGj9YcAEdcmgiW/0VKCND4l5iKUrfFIBd7BESeeskipKXznd1e7SIkThoOSmA==; s=purelymail2; d=elijahs.space; v=1; bh=CmcO6yPRehbZY8hICmv2YV+vpfW/5GRkbc8OrqfNrGM=; h=Received:Date:Subject:To:From;
DKIM-Signature: a=rsa-sha256; b=Oxmu7ziRJEoHPkUqFR58Lt01MwS2CZP7Dl5Ke8iLI9KNe7ZW3FlIeQt5EXY+4pXFFs62by46So16eziD4TnYRsMCxFtpJw+98RL/zok3YM2Djm8AtgSVf8DYk8tK6WXY2nuABl/ZtiiXVoFE0VmB/p2OVDOW6e4hyIz/oQjjl+mQT+7dbixp5E27aebnYvie7Li4SkMk9MaHv5yUJ6ptqpAQc1gOSKGvXTkAaY+Gb7uwawGexu56diAE81YCNwGRA7MgX12vjuNFf8yKqxqrWAra68d6WhO1cijcMBSi18DfG2J16ifajNiDeKpXFo1gL0JK1AHPRgqKXYaiJ9266A==; s=purelymail2; d=purelymail.com; v=1; bh=CmcO6yPRehbZY8hICmv2YV+vpfW/5GRkbc8OrqfNrGM=; h=Feedback-ID:Received:Date:Subject:To:From;
Feedback-ID: 26912:4866:null:purelymail
X-Pm-Original-To: linux-mm@kvack.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id -1519375033;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Thu, 25 Sep 2025 18:05:20 +0000 (UTC)
Message-ID: <6e9c820f-070b-409e-ac25-af96b8b962c6@elijahs.space>
Date: Thu, 25 Sep 2025 11:05:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: slab: add basic slab module
To: Danilo Krummrich <dakr@kernel.org>
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
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <73d7d53f-439b-44a9-98ca-0b1c8fbc1661@elijahs.space>
 <DD22FI7F2ZHT.32SL8PXFZZHV3@kernel.org>
Content-Language: en-US
From: Elijah <me@elijahs.space>
In-Reply-To: <DD22FI7F2ZHT.32SL8PXFZZHV3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2894C180017
X-Stat-Signature: 74s91poryuyd4dzyfd8qd8hy53jdx7d4
X-HE-Tag: 1758823573-482387
X-HE-Meta: U2FsdGVkX19LJppRvdgjGjYgoZ7Znw4JJBX2TI/iY8H2hdvZSL4zbCCbpJK/dOqpcoP0kHX+QMn1r9fgiB1frWds5lwHTlVEebtds/1xvYuJ7UDtVxm2z1M3/HtdmT0BWfFQz7Svlwptw26tYg0myHKfBdtz+eHA6n+gE0mn1by0Qw3m++uwBQZPTWaXZIvvB1QVaaFpq+F7wDXRSrswUGR6Php/K0Nv89VRuvFE6zL2oDt5BamQqQETKXkj3fk1hQl/x4GXKnLafUyvAIGBIf46NIRm6IZIW0AvacnRoELzZcDF+nRIeqKhYlRTN8NLu4VogBudCj38vS21S38dXcnDEYZYvwVMlTSHYP2X64xyxWfGn//zK3LZ+ku/UP8Hv6B7DAtrkquYON/nWNcSr10p0y4zWJJwhX1mJV+cNiQkWfCOLOFHaQBJ5oKPqtzyRriU2YrHwdBr77B162IwaUm5ciEhIZrFLQmaUUR9aGq7UL0X01nAZYCw5mfI2FPVqdFvHUw2qzArAYyIkUEItBuCAZl4hV8KeS9DSaHMdhD0/DYmdrhN6627CkSEm9t4EH1dq6vorDpPBj/nEDE+03E1piov1ABiAUiIBc/JNHlaqpY5kizRPvXlECAI24aI7DikWJYbgExg2tbBDX5zA1bRKtMY3ax5aA1rxVoMlEaFTlVIKkjAMVgkjNaUVWps1Oxn8wnABMXy/ytEiJW32ETIVlRWcPE/kNubdth0/ljz2BlViSLxKRbjavuWf8++4ZIsmp+PxhcYp8uk6ZZSsQUpG1wYcnEXlH1X76ep2FpiwMQnBrK/9cbAS6e2lvPbd80rxKuGk8bVDOhFuTAJY36/zeYtQS/+nwkqICs4sFqfcSG5p7axRNTTrciTPBZdLIy5hKtnn0xBbhA1pXP1X1t/HjDAqqV0WgtSD4oo4XxyO8gA0+vXsM/SyVntaX2rQRr3lqyVvnZ6hAj6p7N
 8VKGa99h
 zZfuZ5J5iznHi7kdYYCuoaEABXAzggU2/NNnbZieUshKn0FR4mezgFE+8O/WRutmiz7yC0gAXhS4b0jU7QElPeXZlvpBu+IwYq9Vs1gaqA8AtECrj3yD7/TgypX0WQ/OjsCrU4Ml+koaGftlaWiK54hflwdHyV7/mxvcMfbJnrtQ4RodYpPVd08hfRwdv4+Lg2tzSo3DzPKSKyTgER82z8fKsqRcBpx72MxYIPGypE0ipOlBehicqQLuNf85LM+XhttClV+WqLiYMoZKSV9XLyQiI2zoxX0hsi60lwwFUCQKYPrTKk/s2N8Z2EtF1G9/3Bq8KEOjuQvN9iY5Z7L19vqY/4kXGU+Fys8lCI12UDWscEOLNyvqfDPuVBDVfpuFaC4na6Zfyfo5pAG7MRcCwB+WG2juDk/iHIoO9FJqByiC9jGJMCB1mQB620XVHFQ0dFUYjFN4tx8d4qOwe2M62NlS8Qb6t05NiJMfbQFj/9UB6VjhnOMJE586Qr7JKezx/kEj2xtnG/d6ozB9CZwHETkI1xiZI+8LF1PjOmIs3clDR4xZL2MopIz4ENxzaiLclJjQvZKi145QqTGXzBj6GRHzP11cUYTsZ1pQQ1tf2Rb2XRbqmrn8sbKOvqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/2025 10:43 AM, Danilo Krummrich wrote:

 > Anyways, I'd also like to hear some more opinions, especially 
regarding (4), as
 > mentioned.

ok I just looked it over. I think (4) isn't really viable, the cache 
pointer storage overhead is probably too much (in addition to some 
complex issues). I don't really like having a macro (so (3) basically) 
and I think there are issues with non-static caches, I don't know 
specifically though. obviously (1) doesn't work. (2) is exactly what I 
was thinking specifically for rbtree. IMO the only useful options are 
(2) and (3). I would say maybe implement (2) first and if you want 
macro-generated ZST allocators they can wrap whatever that Box ends up 
being.

 > not having dynamic dispatch for a
kmemcache backed Box is probably not that big of a deal though

I agree

