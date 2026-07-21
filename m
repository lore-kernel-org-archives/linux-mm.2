Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599B1C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CD26B007B; Tue, 21 Jul 2026 09:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDD86B008A; Tue, 21 Jul 2026 09:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013126B008C; Tue, 21 Jul 2026 09:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C06A36B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:21:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A72C40141
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:21:00 +0000 (UTC)
X-FDA: 85012844280.21.FE81925
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 65F774000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:20:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BdhXKy2N;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784640058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPNMI+hROZ6ghG2BtxRn6B+jqp/do2+I14JMu7ZMFqE=;
	b=cFGeMxD4tSrS9O97E85yC1MUmtFN5ek/Yxw4pncUksvKfD/KRRss2Lj06ksnqzEUYt/Loi
	ejkxrWskqDrFhO3PzFeRJgleF7w5qhs7Md/FvxqWXQ5Fi5i7IdsPVPmgXZWNcR+Mj+z5uF
	HkEoAg9HUJI0plRUgIh+1F8WnIL0MQ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784640058;
	b=nTdflvf2I6TUItawH9/4l6n2Qurfb0dBf7PK7NH0QSZ/r2PyzDwcHIqyaW85C93miES3NM
	u7p6mW4p6Ewy/v2YfS5Rommx8rSrKMLbCMohfb8A5h608rJGtWY9eOtdrdc3MQRftMUHRt
	JxjZlAetucoGgBhs4UWSO61E34p8AkY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BdhXKy2N;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE8306001A;
	Tue, 21 Jul 2026 13:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2571F000E9;
	Tue, 21 Jul 2026 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784640057;
	bh=ZPNMI+hROZ6ghG2BtxRn6B+jqp/do2+I14JMu7ZMFqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BdhXKy2Nmb2vTapC6oT3qTmTRp4P2Z0MN2oL7Wgkt+Cm5plqDd9SDUS0urWp/X9vw
	 arI2o5qxppIsUdgULuB1Af5yVzZhQpBmlonNTuOLxNOrP7XDuCbId8sbJrg4/9Np8b
	 eodGUEyQx0aEVPW5ZxOukLNS7uTHvH0gHuKmMVFxRHWPMtaU3lOZb5MwEUEnPLFzqf
	 upROZe4MOpdcPtwgWU/kZGLT9ZAI+Y+Pcmz4gcd/iNh/3kIdYGuRZdHn76NI2Lj3x3
	 KG+O3vvwSnbuzoqyP2q7HcKjzfL19ZgOfuryPIhgsdi6FPfyWpmBL59YQWBHVmw+QC
	 +lqZprpl3KcdQ==
Message-ID: <e72f54ee-2ab6-462c-a9b4-4e05c3e85266@kernel.org>
Date: Tue, 21 Jul 2026 15:20:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Omar Sandoval <osandov@osandov.com>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Stephen Brennan <stephen.s.brennan@oracle.com>, SeongJae Park <sj@kernel.org>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
 <976e4d7b-24d6-4047-a405-e86c2feb45d3@kernel.org>
 <1784596208654455.18988.seg@mailgw.kylinos.cn>
 <8f3a6021-0ef0-4ecc-bbe0-0be1c3c6834d@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <8f3a6021-0ef0-4ecc-bbe0-0be1c3c6834d@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 65F774000B
X-Stat-Signature: fhgzpi8rwhabf9fa8ntdpzbfbt1ynr4f
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784640058-207436
X-HE-Meta: U2FsdGVkX19PSyJipqaE51lxZd+Fg6NBsgDVn8+QRjyg9Wn2X8RpQeNK4xHZ07gdewJG98aMcvdmR2ymkDPoXHMLo9mX3AaP64TFEzqcIZyCYBKE7hn0tDg8jnwkv0SyyenUrdctffoJBV861VsL+mVUceBe+56zz7qq60PmNDD227LzRW3QHuwDcTRTtv6RqpLSFaPfH1VxTc3Px1akZLH0YrNUNSYlAJ7Zlqk5gs3JgyM16bsxk4Id0TigHTGlNzx8fz8k9DFQJPIY7SiWPWvIi5ZiC9F8KvkI0rMt5jQZF2EoMNZTqkU/oeu5448VRn8KShlX0Htz5xiZXDfsyqrifb33XIEsU63DEP5XsHc4rignc0T7gAzoQDCQJDbr7JOn9kEhDSrKjPrIcsv9J2TXKU9lTm05/GDQjxMZ7BFJjCaIF8lWtGYO3Vu1SR7AO0cW2bU7WjcbhnmchkldPaAo/D3ZEmLAoZAAjvHPEaIIjylC3qZ6sXcWCIZbGvv9Au74BlaDZsOyAJaYClC+osETQ6hvYrhWNtRx9Vzy1cAylxNi3xgtt24ySbTZXcixGop86iSj+Cky66XasUsKBqW81/2D2hZ2U//lXgA7VbVp8Fx0lZa7Le9YeZ/kldIpC2D4UEhH5ILnIasqdWyC1gEiJE9taOIwWV7WdqcrExTM7SNykMKj53gHa2gSgoJX2/Zmw2CNayssyOHJpPbsoHu7AB+25eM2Kg9h3r4MYipVo4+FfMfesl6k+QSDU75AN62MjY8uUZ5a2whWaeL5cQcuOCz1K8PXY/5pkVGYV1NHNJN8yU2ZsmaXx0M+bOc+sICPPR4sA27D0REVhtgjjBXg/uEiAPHsM2j1Z/f3oPJtU8BHZ3gipHjo/Hrds7iXRCqyJhjOIPPMHJY1Mb9ZYj6c7ey/hq5VU3YJRf8fXIbMn6/yU0OizrAQtT8skV9rbTXVL3CMPy/qFW+pCga
 GGcmyVhp
 gRqHt5W8u1rm0iohMRGvRFLfecB3Dy7VgdWbyYdoyi6TTctaUlMUTJwH3fFA+XRkzhspD3kUjGs2t880szvmOX+IN85EDQXgr8730A9WbzfJGlqvTXlJ2+HVFk+V8k1QpYTxBxyq0fGLBBmcqpyZpjXNHA1mMLb3ZU4Z0RkVx3YHaiqTjb1L/2rNBSxPosySs18djcNHasbDdsRf5Y8OuWXTajSQO14iaPT0UB3LTOWd4PJyyC74mxLLuzoM2POUp0mZbV6kkLmLHq7a9qJcUirR7DoX1EuayZIriXmM28S0wiW1Uc1nrqU/RGph8mSo4suPGDF081U+O1RY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 04:00, Ye Liu wrote:
> 
> 在 2026/7/21 03:58, Omar Sandoval 写道:
>> On Fri, Jul 17, 2026 at 12:00:29PM +0200, Vlastimil Babka (SUSE) wrote:
>>> On 7/15/26 12:10, Vlastimil Babka (SUSE) wrote:
>> FWIW, if these scripts were in the drgn repo with test cases, these
>> breakages would be caught by our CI and someone (usually me) would fix
>> them up promptly :)
> 
> When I first used the drgn tool, I noticed that some scripts were directly      
> merged into the kernel repository, so I merged show_page_info.py into the kernel
> repository as well. Later, I found that merging into the drgn repository was    
> also a good option, so I merged it into the drgn repository as well,            
> and maintain it there. Therefore, I currently use show_page_info.py regularly   
> and update it promptly if I find any issues.                                    

Seems we could remove the in-kernel version then? Besides better regression
testing, I'd assume the scripts in drgn repository can also handle ranges of
kernel versions and not the single one as of the given kernel commit (and
often not really due to undiscovered breakages) which IMHO is much for
useful for using these scripts and tools.


