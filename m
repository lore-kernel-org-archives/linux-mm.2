Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D87F2CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 18:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB298E00F8; Tue, 26 Aug 2025 14:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6CA08E00EC; Tue, 26 Aug 2025 14:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82AB8E00F8; Tue, 26 Aug 2025 14:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B579A8E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:01:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6CFD3140273
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:01:32 +0000 (UTC)
X-FDA: 83819676024.10.249F354
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2B3CF180013
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:01:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WbwWflZK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=martin.lau@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756231290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmKY6MkQc3HKzHukHIfBKw9ER0H4ED2SLHs/o7yHr2Y=;
	b=CsvkBrmsrkHQbW2A4st7D7rVTJo7jytQRIvuKDHNvnJrSKIjnQAIXv8pXWFBva/3sHOuPp
	liNQQt0fvdkz9Tu7bUObvFhZnU2r5ICFtnGXuAqFPHnptBfyW3endAq/h7WqcnaV6mGuaV
	ww9QWNPcbJ1Jeg2GRKAqnWJI7q2pJJI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WbwWflZK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=martin.lau@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756231290; a=rsa-sha256;
	cv=none;
	b=o1SpQbTEHSDk9/rIrOhItoZEw760hQIDagYBlArwzdFG7i8c1J6eVo6ZPmo2FDr+4ABJ2b
	MvaNUFwLMrMgBWV6EhU6YmDkKaCGY8UT/urTZoTj1DK53XZD9UZOn2zz1GutSYG96JJFre
	9ZlGRSjXT3fQw3uHD5/x+qXOD5LUB5o=
Message-ID: <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756231287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmKY6MkQc3HKzHukHIfBKw9ER0H4ED2SLHs/o7yHr2Y=;
	b=WbwWflZK374x9tt80LfgBRf+IupQVf/iyXGr7itPyUkuxFOEpIulPZy5irxj2OhFddyewp
	48ZyQhY8YW43UPn9lr7lxb6cW9QVr9GQoM+Wk+CqjOmpqHpeIKhFrpth1K404H+5bGuROL
	V7o/TTcag4nyOyd97obXf43b1Zl4yHY=
Date: Tue, 26 Aug 2025 11:01:21 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm@kvack.org,
 bpf@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Matt Bobrowski <mattbobrowski@google.com>, Song Liu <song@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev>
 <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <87wm6rwd4d.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2B3CF180013
X-Stat-Signature: a35xougz3mk58m55udd5t9g85qbuki4i
X-Rspam-User: 
X-HE-Tag: 1756231289-793307
X-HE-Meta: U2FsdGVkX196a0ueg0vxE6Tk30ayCbhKE8ecZmiN15K+VEK+572Ro8/JtT0NnVra5WS+abq+j5MGeC1+E6/E9Phbu5lnkLkHRyofl47dEHnUnFUk7Z9YU/eg1lcsGHVw37vkzAqIZhkuprxD5IZYJQsbbl1C/Hzy3RtPaUonjmWP5qSe1Hy7VHDNBKoAR/gO95q/VSvRAet5De8y5jsO0g8uFIEn5f2DM4mdzRdbIpdXoi7SighucSaKmqV6/1h6El9X9O+B1qIJo6LYpXy/CSplKQqFyk+SR2Ekh7A/0ds74u/c1Qvz4r5TQ2QaXM9E8g5cmlcDkOv7/fZ/9pEf2P3N9Jzx+Dadzvy5aqNMUJqAeGuQW/W8uqH1WqcSZCN1W1BRQFTk61NHo5Ilfw6Ae/6clxoH5BkN//jeuxttfq1OYYQ5R7T/GIx1fClbcGWCLMvN6UE1Vlq5qooZDC6s2YfwQxoPRTxeX5LTk6rPxpEvaxoAxDYKKGfkPnGYbhBlNeihfYHoWwP+uxStyQEJkrFBp5fQNFyKtCa9EcVIAbtqRha64sEf8zApvN7VKhUbhH3PR7gP4jkdpYUG7j9HQ8xgiPRhnI2WAjOw0YhCbnvrzccwLVIVlD2yjBLUO+UCMxlQUyHRR58TyC0AnRvSYOQrDMlDbJMUqN2Y7cJvxjrVMiGwWFTf+eOx9QbcnnhmdUi8WsqsYtgieyhsSxpVdaqlzP+pzvkMUL+OTvDYnQf5FUggqk1+03X212EEnG5aoI3iFR78BGRukxt24r3du4lVMuygVZMlIaj+EyA9E+b/k2pzUC5pSAM/2sdgLk18PHRWjKtlAIBgfhvr1CK8G6o2W4A+ZrBHRn2U4XGQSdGenmEpXneNWqLubthrBsD4ru3ROeMEvxB4R514MYIJMcgk25ppb/4Au4/2kN44Oa5coFOX27blJi6tftjA5+NEDSBheTyed29JhXEb3z7
 aT/7sXkW
 H2O8eF1euAv0LBVXARPtz4cwTLsD9hoGUpldO1NiqsYpaPDTDpAFxYD0heAMucayicKS0SLdEJ4uwm5e0oRMCjM1W1e12xBWdI6cEFEiwVW0KuyVj6esbPYsF1cCiAw31rEfV7MmeWpohd0ksQTgwL2oaKFHkOcRcfDoY56tlvQxwAV/4P5Xu8T026Nx+dW3e9zJ92XCOs3Z8DB2RJOIy2LTXi7BGkCOgy7hAlyRIYh806hoZ6n5RDKn5Vi0mKt9zgGvCh7L/1ojBtDO1FomeEVxVGrJfeoc/RWw7tXiOteKeTnDYLczZwaUmmAATOToTLosN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/25 10:00 AM, Roman Gushchin wrote:
> Martin KaFai Lau <martin.lau@linux.dev> writes:
> 
>> On 8/20/25 5:24 PM, Roman Gushchin wrote:
>>>> How is it decided who gets to run before the other? Is it based on
>>>> order of attachment (which can be non-deterministic)?
>>> Yeah, now it's the order of attachment.
>>>
>>>> There was a lot of discussion on something similar for tc progs, and
>>>> we went with specific flags that capture partial ordering constraints
>>>> (instead of priorities that may collide).
>>>> https://lore.kernel.org/all/20230719140858.13224-2-daniel@iogearbox.net
>>>> It would be nice if we can find a way of making this consistent.
>>
>> +1
>>
>> The cgroup bpf prog has recently added the mprog api support also. If
>> the simple order of attachment is not enough and needs to have
>> specific ordering, we should make the bpf struct_ops support the same
>> mprog api instead of asking each subsystem creating its own.
>>
>> fyi, another need for struct_ops ordering is to upgrade the
>> BPF_PROG_TYPE_SOCK_OPS api to struct_ops for easier extension in the
>> future. Slide 13 in
>> https://drive.google.com/file/d/1wjKZth6T0llLJ_ONPAL_6Q_jbxbAjByp/view
> 
> Does it mean it's better now to keep it simple in the context of oom
> patches with the plan to later reuse the generic struct_ops
> infrastructure?
> 
> Honestly, I believe that the simple order of attachment should be
> good enough for quite a while, so I'd not over-complicate this,
> unless it's not fixable later.

I think the simple attachment ordering is fine. Presumably the current link list 
in patch 1 can be replaced by the mprog in the future. Other experts can chime 
in if I have missed things.

Once it needs to have an ordering api in the future, it should probably stay 
with mprog instead of each subsystem creating its own. The inspection tool 
(likely a subcmd in bpftool) can also be created to inspect the struct_ops order 
of a subsystem.

