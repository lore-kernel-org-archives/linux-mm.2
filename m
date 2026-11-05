Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D42606D810
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=f9SeEat+
Received: by kanga.kvack.org (Postfix)
	id D97736B05B0; Thu,  5 Nov 2026 06:18:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F2A6B05B1; Thu,  5 Nov 2026 06:18:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAEB96B05B2; Thu,  5 Nov 2026 06:18:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABD726B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:18:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E27D40986
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:18:42 +0000 (UTC)
X-FDA: 85400817684.14.1666749
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7AA6D80002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:18:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f9SeEat+;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2GEyfbEk78tmhNg4jjyM+Rv2+cShKrYLmnldxMVg7o=;
	b=WYB6d8SJYmumci2SS8vk25QJta6rF4lRSZaFzuPIwWOYjg8GmKhZr5Ga+X0ifFONjUVrRW
	/xoyL8/AQG58nv18CiTrysEFm15tNEBqd+OqTvQlrW05d9xJG6ypWRqjCMKKwnp4w3AXDA
	Ku5BxSWoxp2Mi4Rzo3VJnFczBzaVifs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=f9SeEat+;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877520;
	b=hfOm+PzGRppkR22NnuY8vz5I7L8Z5E7ODsnYbijQQhQJUjOX+/rOrVMQzsPlCZ2Nw0MO7w
	atCmysQ9WLp3NMZpvtVO7PcdP4RfOUTn/wpS4DwGff3uz7+b7bEPBuMYdNNNQoZ+R8ymxb
	nhLfBso75yPTXrMgX9djMlsrG9rEtbU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793877514; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=e2GEyfbEk78tmhNg4jjyM+Rv2+cShKrYLmnldxMVg7o=;
	b=f9SeEat+8r9laKdlrSgM/bfelNClEYs98d128PTzmLd+27Z89g7IZKoawGg7nuhNZhr/BN3lXphGlDpHjr2ppjtxOOUVoWkGwx28M3gsDfCubo285S0ESfWVKeKhdiBFZe8ksOYE0aXUleCqpVqzcIZqi+6WEfGjP40WQhOkGAY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XE8e9ip_1793877512;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XE8e9ip_1793877512 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 19:18:33 +0800
Message-ID: <39d0d3d6-bd8d-47da-b2f8-d07483a25a6a@linux.alibaba.com>
Date: Thu, 5 Nov 2026 19:18:32 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <20261105045406.39871-1-lance.yang@linux.dev>
 <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
 <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com>
 <8ebb182b-8a01-4d32-8c76-7e4bd9e54ddb@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <8ebb182b-8a01-4d32-8c76-7e4bd9e54ddb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g9rrszqcgdnous1ha3dskwdzsyab6mto
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 7AA6D80002
X-HE-Tag: 1793877518-843188
X-HE-Meta: U2FsdGVkX19/VX5+s4RqI6v6hinkiUlXJprDUj52rlasHlLXaAlzxRPqiw8vGnpjkMuWpHtRo7taiH6b7h4G0O6wDhBKxU3AdzdlwQy0trgaKXWK2U5IqHsCFH68l8T0AFNtFLZueRxJjHPboy1Nf5aQwVHlISzcQQ45uE4aOY1W6WMm/ovhOZyTrDJNOGyOvTk1ObTgdau8e4W2kGgi3A/nZ8YJaH/TcVgLLzEa3vtnQVrkdmrvKTufKxx8UuDR/yh81qz7D2oJbQxPZtK6HgceSVcBd4wUI6mWrb4Dk49wcsSxPP7IgTNPByhest3IY3bcXnRzC/0MGlDl/DveJw4om8nvie2qyoqCmm0xsIVj89CfJu+IVhjrXIO/Rosgkz3pADfty7X4VlTK/bDao7mkl6C8Csmf+8VwbksBc4OERVGEXm0PD6AXTusb3EX0mEOoCzXqoXh5qL4eH9oubwMSjdKkzalJy97V8zCsanz09p8wzyrD9Oz3Sw1/4uha9cYtozldGWlqHhlJQuqNF74W/nHWBz0fmAfVv/+vzIEIu6qKG8qodKdy4FLd1dJIfU93Q2Bef5j+Lt9PNNrkc4EaUDIm8tOZSAsR/fuc0eCMQFZRXnWTp4a1FrP71elmF4G3CKAwozTLEOOU/Ecg8j93zVhV081Jv1T/puFwGHC381MxpMQ67isPv5HCHTgiixp+JYeC9V+/P/f3bIG8FGE7FCQLY6yDlJ5COKZEQogTkBCyTZlMuGZhy1tEyXCE7UvthvSucY1YGCJw8bEpMM0/yYCJCcjG15jRrhcb3fGMrMFfoCgZ1AlqcNLEhIFcOkfDv7e1fMTSP8sAAMEGpq117opzow+7IJGTx4ftUG/ueApAbGpbvRwbaehXTVJ8M7jxOehMcF15TaLJMZWitqwoXt/s8JjVzXwj1KH3JP/qs2EkVVbiqGiDT3eHFZDanh0TxmWxZ0RHxUodA8i
 aznvqXST
 tv6qM1Ra6m4KJaFBiArhH+ynX8WvMGgHVGSenKe7khYLfg5vN0mfGG3aZoO8NI4sJbDJutUv6nCq5dCQWIK+8hFM8BL3RRoHVzENLNkTuT88+9i1+q455zp5vuNefiJa71HCiKbLoghgp2CBcehE1jorM9Yy5OK7/41jwfmhzxG9wwUG9q5InnWd244h0XBEuVA3O1nTBtj1Z5korwEpG6dB8zLAqqz6WL/CyVezyObEONxx+AQ4QBWYpQ3HOXkzFDEotGRc2xcfN5jo0CW+p3hw8qtVsPEOj5f7ZldB9igjxOkNqwvczZsO9xrMT/RYuEgSN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/5/26 6:06 PM, David Hildenbrand (Arm) wrote:
> On 11/5/26 10:00, Baolin Wang wrote:
>> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>>
>> On 11/5/26 1:48 PM, Lance Yang wrote:
>>>
>>>
>>> On 2026/11/5 12:54, Lance Yang wrote:
>>>>
>>>>
>>>> Good catch!
>>>>
>>>>
>>>> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
>>>> PTE table can be reclaimed, so those extra checks can skip synchronization
>>>> that the caller explicitly asked for ;)
>>>
>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>
>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
>>> hit the same race there?
>>
>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which is used
>> to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set, it means the
>> caller can tolerate some racy checks.
>>
>> For this case, I think we should set TTU_SYNC unconditionally in
>> shrink_folio_list(). Barry, what do you think?
> 
> That makes sense. I hope this doesn't throw a big wrench into our reclaim
> performance numbers.
> 
> Can someone benchmark this?

Sure. I'll measure it if no one objects to this change.

> But maybe we should really follow-up with the folio-size based optimization in
> sync_with_folio_pmd_zap(), where we only need a memory barrier (and sufficient
> documentation why something that cannot be PMD-mapped can get away cheaper).

OK. I'll do this later.

