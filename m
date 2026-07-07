Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD28C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D106B00B4; Tue,  7 Jul 2026 09:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492EB6B00B5; Tue,  7 Jul 2026 09:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3367C6B00B6; Tue,  7 Jul 2026 09:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE5086B00B4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:50:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71338A03A6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:56 +0000 (UTC)
X-FDA: 84962116512.14.5004742
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id 73AC680005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kNXg8Bh/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432254;
	b=tIGFST7WvVSkwIp9ooWtlQmXnAM9XDlGzFsldZt37fcGGn7DxnWdZq1dR6FAmDRdFJHol3
	3GFfplxNBoJNfjc6M3XpaaUg2gh1SVmLNNgIsOAeghHXZO+buLxYrihvnb/sK1oYxXhPrW
	cD4yB6n4iizYGHmwYD7a/AgyThYZ9nA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kNXg8Bh/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/pD5OdgWh4vEEhKM48CFXryGtzNwFwor3KN08M92Y0=;
	b=uMyTO0rtYZ2wnzLK9IebkJsbx8r9Pt+Wp2Z1mJrAeBW7/9xmXnteeVUEgE2D8Dg8RN4g1X
	3oR5zAKby8exAEt/7ElU9jodP5bcU6YI66ZIU8TJWSNwniTDOI6gYqDaKfBaFdYpzPBVKG
	lP4T4mKeggzUl9xyk5zFHxtCDo2FJtI=
Message-ID: <dd21ee9a-a7a9-46a2-b151-0f5c486772bd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783432252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U/pD5OdgWh4vEEhKM48CFXryGtzNwFwor3KN08M92Y0=;
	b=kNXg8Bh/q9j4Llb5rtZWfxrp9Lr2mMLw00i06Tq8leWaM2xmpar4qi+HxLU7esLXEoV2hT
	lRYT5Gna157c2xqc0Rz7Zhbcegjm1LDQ8bTTfNSUnWM44I5A9LU6MiAs96di/YcXOoMgdY
	DHVW9lVr15gj7wPwJRUzkGHE0XkrPW4=
Date: Tue, 7 Jul 2026 21:50:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Douglas Anderson <dianders@chromium.org>,
 Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>,
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20260703022507.187457-1-leon.hwang@linux.dev>
 <20260703114128-2a7a4723-0060-436b-99d9-7499bd90fa82@linutronix.de>
 <b6f5f3b2-bf62-4b77-9c74-debbed9a4738@linux.dev>
 <20260707122827-2d6c18d3-8e02-4d9a-bb29-2ec46e759645@linutronix.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <20260707122827-2d6c18d3-8e02-4d9a-bb29-2ec46e759645@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 73AC680005
X-Rspam-User: 
X-Stat-Signature: 685x1j66jqqq7rsh6wq8y4yrty19h86k
X-Rspamd-Server: rspam03
X-HE-Tag: 1783432254-659908
X-HE-Meta: U2FsdGVkX1+KLvWFLQ9XBt/mRyt1Zttl8vfNFmJYUsazZthMTiHypCkO8GF3GPm/iy20+X6+P7dfi2nFxJlAuZxaT+d09okdGRM/zOqzI3wFtyLQLtfwoyecdsZWvv1KQwNdRJHPoJ2bxvgHbt2eryMONW/YAPXGjjM7RLoh72Dx1cG4EOL9X6Asl8e7+aCIYsP9toMI5ud4KPqAR7JlPXN3KuhHo1oExTGV+5t406zxewR8vb15oT/usyJVRSwsbD4PTL7DAR4v+lqK+Nw44Hh5Y5EzHFCj4FD2xpiXJIYncFc0U1c60FYml9quv9mEYkC8iYDcrEmOdN+/II68okpXP6i6/e9LXoZY5iF0Y7eaX2FJrRLjuzOe5vWMr4dKwjBPq5xhPxoT2FNpKrwi7Jq/PnOy/bGe8ouGKplm4QCB/ZXQsPNe5xsDBagQ8hq9FBm7F3NVLqQ/HwuCr5qLl+noHxF6dObJ7dBEAQvHY0Zi9Rh1y6xda0XSeDi6YT87ZJCnnZnnDUBO3enq6T/6rxeMbbw426BG+wh8lmI6o+GuPWoh7G6UThUzZv/bXKr/vc3D4NAhYIBTvD6SbpqEev8OLO/xvL/8vSf04XtJ9lPnE8Kg5Lcbricr9APOclbb91C9Di1f9jxSxOCuzK7ER8jGeRBgJE/LC3kCtPFp0kkzWGwwyuiBD87bt47K6pDXSfngsS4NhDhjvJdK6r1Tqef7Q+bxhBkcarGq7svvxdPvPLkcgOkzR+aRGJV5fuX8BnNZo9Fh9b4+wE+eV+ztOrHRVTI/U9IsXsdHg2OmSJ7wZPy+r3InT7i5sSdtxp0dtXk9obbIHQKSxwJii6HS2qySmfjsWEI6+ExoQbELvgZAUPa1t6wSsWCmf6GDL0pf+ls/wXgqpiHpSVbewSHwMWkbyhqUTkyogzHLt67hYe/iARc8RBdFW4lFGoI8ddvUDDr/ClUJu0iWxtnrX8c
 6QJE0TeW
 pSf5u2kZxJ7yKnZxvhdoqhqIG0OW1DyeKbhudI+1dmQmmTNNWwXbO1zjhJM9iQh+lAVD3dWCw4ow2Th3CqB0d7jCioOLPRdahkWPBIaJxC2JHQ71e1RXztZ0bR6OHKixAZ60jqlFglXJTqoGm/KpQHf8No/uUV5eSqd/S7DPVnZthy3vJjmtWwlOs0BIgXWf9IKI+Rae5RvvO9Ug90Q5R51kdULEX1WjkkjqJnb96vPQ1ZLB8n7vzSksb/E+c6ARE0VfryKK95lZSzjTwxsOoC7nHFU3uBAZ22rT3k/Ll91dfxMIMpJZhzBvpyyGWEnusraLo3Ey7b9C5l/jY24lXttGB/Rx4lt6/9bfzTffaFMBdC0U7Wjmj/wXnftj5iI9H5h5N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/7 18:34, Thomas Weißschuh wrote:
> On Fri, Jul 03, 2026 at 11:09:55PM +0800, Leon Hwang wrote:
>> On 2026/7/3 17:44, Thomas Weißschuh wrote:
>>> On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
>>> (...)
>>>
>>>>    The following architectures currently support this feature: x86-64, arm64,
>>>> -  loongarch and s390.
>>>> +  loongarch, riscv, and s390.
>>>
>>> For per-architecture feature documentation we also have
>>> Documentation/features/. Maybe move it there.
>>
>> Better to replace with a reference to the feature doc?
>>
>> +  Refer to :doc:`features/core/mseal_sys_mappings/arch-support` for the
>> +  support status of each architecture.
> 
> It should automatically show up here:
> https://www.kernel.org/doc/html/latest/admin-guide/features.html
> 
> See also Documentation/sphinx/kernel_feat.py
> 
> So I don't think an explicit link is necessary.
> But the maintainers might disagree.
> In my opinion the link should then go to the rendered table entry.
> 

Let us drop the sentence following Pedro's suggestion.

Thanks,
Leon


