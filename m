Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5607FC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1B36B0098; Fri, 25 Sep 2026 03:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9AD6B0099; Fri, 25 Sep 2026 03:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BFB16B009B; Fri, 25 Sep 2026 03:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16A686B0098
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:06:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9761E80529
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:06:34 +0000 (UTC)
X-FDA: 85251401508.11.51398C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD1B3160008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:06:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WISsPPXZ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790319992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Td8m9iIUt95nKIvnxCfVeaTTefgNaJwnXfzuIyCH6YA=;
	b=TECjHWqGnfiT26pQONz7lmWwweMsjuYN5kAdd2gSX2BpstCaHYkMUnQmhBY52uvC9hZ7Gq
	O63FsHVp/FnCbfM53anxbA4clMU2Nb0nqmEpYUl7CeaXCUYq2PaVelK8nsFg8fKul2wkQ7
	9Dge4anw7QqNGIaY6mf9b+6YzKuJv7s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WISsPPXZ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790319992;
	b=KH1RSG3QeFtRfv2Pz9ud17tCtQaR9ECTxM8bkOPK+fMxcRqYFlx5zbLPSSYu1lfVl60QcQ
	nDucQk4iFQMfiGbi44Y35I3y5D1pKz0F/Z3lqOT/See3Wh19gUXOk/cr+X1ammWDxxFVj5
	J/a9fXwiULH1BAUwK1pUrZrpG7kdskM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F369540DFA;
	Fri, 25 Sep 2026 07:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9E91F000FF;
	Fri, 25 Sep 2026 07:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790319991;
	bh=Td8m9iIUt95nKIvnxCfVeaTTefgNaJwnXfzuIyCH6YA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WISsPPXZP8H+KWyPmwNcqB2cLI2ZXJEgwzx3oexLfVxNWsyzmmXvN4X8DRy2Vd+0I
	 EbneXdraYBYE+MOoiR/pSsF+nWnDojcHw4a550rxBMavXoTTYjVpbThn2Esb1/mPa1
	 ftTV+KJ2N0MN9DcXW9DRciHxSUVosh+k6tNP9jgVW7Ubnbifd096X4PfwCv2j6mhSb
	 g7crbmDfyxCsEpRNoZ284TSxRaTLFPLQZENYhzOhI6bIQAAacSRaLhEQ2DFqzzFLYq
	 swu2jtmpyrg+ODxhunThg21TqJvN6KmpYidVnI9akO+895qOLt3lG+1pA5Zt1norMc
	 HXH6UxWptzoCQ==
Message-ID: <30f58666-a798-4028-a2c3-9eb63612c4cc@kernel.org>
Date: Fri, 25 Sep 2026 09:06:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated
 bit
To: Ilya Gladyshev <ilya.gladyshev@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Linus Torvalds <torvalds@linuxfoundation.org>
Cc: akpm@linux-foundation.org, andrew+netdev@lunn.ch, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, edumazet@google.com, harry.yoo@oracle.com,
 hramamurthy@google.com, ivgorbunov@me.com, joshwash@google.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@suse.cz,
 willy@infradead.org, yuzhao@google.com
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
 <DLFJL5U9DI6F.3QJP9YP0KX636@nvidia.com>
 <56e036665dbeb0a8f51d697220d5ed84f210994c@linux.dev>
 <570cf649-a8bf-4073-be71-207fbb2bef40@kernel.org>
 <CAHk-=wh3LLDV2AMZn1PZcU1o3Na-BNcQtP=LPXouLKPZWaiRdQ@mail.gmail.com>
 <DLO1WIACYFWF.3N01DXYFJLMD0@nvidia.com>
 <a1d5881926dbf4b16dc796fb1da939f32dd42f18@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a1d5881926dbf4b16dc796fb1da939f32dd42f18@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD1B3160008
X-Rspam-User: 
X-Stat-Signature: 1m84jsgp4n639kc6t9o1p4t6s11ymar7
X-HE-Tag: 1790319992-650447
X-HE-Meta: U2FsdGVkX19DhzqvTqDx2X8FsGTF3wNb3jIjtl/BBl+ZS84Eh+8BrWNbxrudQEtkbfSoWKG0mZczaJGim/80iwIzjeqWr/Jwbm5/do1mUVOxKavTrVirPNftbqpdXV6OkuizDdDyzAktRpzD8SwZSMe6iesJsm8LeeSM4ODCHpHQc+mRSx88uDiFknFvMg1ESvgj6ZnQQbnB3De77/7QcVV+1d4b7HIBVk4Iyk7TOvng30122tRy6DdsuRIStfme+XcTwnMJcVcNWJRsebbIQ37t/0o97unAl2yvoHVOeFgKnzA1pKuFrQIZHOw13L0mKVQD8CBrdp+uKA0/NeSARR+wPwLkmn5jqIDIG5NLdplh73u2IxWtLikqhdorLbSzXL3YMNWwWY3os7CrxnmjxtAwZx34deW1HQ+sQC0PPdV8MmcUW7A5X2Ydey7OzKi/5wP9riuKnjLxKVFEDGykutwwwvXE+3C0f7AsW9xB+5bTA9/iAyXEUcd0iV7Vm4LnYHUEwOilr95xcIhUNO1QLYuzGLKDkkJyrROmjeehSgoxZn6ILpZFesIUinXkUL7RyIOuZB94Kkkr8U6SizXCgD5A4emXgEqj4r1/4VtnBMrVbTMR89kOlI7MV79D4ekgcEFfKHbpwDobwkwCHFcA6sCybOXiGjvNi6R0PuDEMFToXhouCjgE3odzwSpA6h65ExUJG5KW8OoBzjJO0jS7iCoar7RkNCGBlkLKzQPSH73VoHYKqcALVVlAEW00mAd+mBsVORR5bFz+eeLqLBA77bpT+Ic9qaQ50YwCo7wzDeCJwtsoxMHu3uAY/tUuXAL+0W1iDdV2VM77o7jePwMlLMm8mWEeDPNjLicJn/gB5ONDmXkVC7vJDKIIOVUpYsLy+3CvMBDf+/OTCpf4lVVv0NP1jv03ZQiQUXeOZNpC5YLRaeYoAsvoy2i+/wjvq8CQPBEzY4OcO+AB3dVmrkn
 c8Htn56r
 UvsqFJ2jCY2rTsSrdRQvUyH2M+nT+umIMqa3wo23xBc6mK5r8iDuVTN6DvBIRUrJwP8+KzDFYRIpph3nVZb0K2hKKYtzkAZhM/LJ0OSX19buORmYGynNWpEsrdwxHeuIlSmioJnhlV0DMhETpqIDSPuIIgKMIJYc99A/QD7t83YRYfjSg52ejJIHjlY/K2iWc/Xxzw9N4SMjaAz/CW1C+xcXfy4E9CZaFjtzbFOR73umZe7qa9faZGs5XLaphc7ZFF7t8NUZcOOhWst15ltOPxJMQMzQmAN4/sYofuhyuWme96funZKuBD+1pqn2uhV6gl5hpc+edq2H9Z9xSwIafXYWyq5ZLhXVQLyVEy/8TT0yVPMBQRGZvpc7lflcXbqyxlkGkDphctMnJcv2HilDaEv4m7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 09:03, Ilya Gladyshev wrote:
> September 25, 2026 at 5:44 AM, Zi Yan wrote:
>>
>> On Thu Sep 24, 2026 at 4:06 PM EDT, Linus Torvalds wrote:
>>
>>>
>>>
>>>  I think this all needs to be entirely generic to all pages. Agreed.
>>>  Everybody needs to do it right.
>>>
>> It assumes all callers of page_ref_dec_and_test() are free page
>> functions, but there are two exceptions:
>>
>> 1. compaction_free() uses folio_put_testzero(), which calls
>> page_ref_dec_and_test() to put not used migration dst page back to
>> isolated freelist instead of freeing them.
>>
>> 2. virtio_mem_fake_offline_going_offline() drops the last reference of
>> fake-offline pages, so that they can be offline.
>>
>> They will need to be converted to not use page_ref_dec_and_test() in
>> addition to a common page freeing function. And any such future use
>> needs to be banned.
>>
>>>
>>> But I think that in the scenario that Ilya mentioned:
>>>
>>>  Refcount operations as follows (FR = FROZEN):
>>>
>>>  A: DEC 1 -> 0 [ page_ref_dec_and_test() ]
>>>  B: INC 0 -> 1 [ folio_try_get() ] => success
>>>  B: DEC 1 -> 0 [ page_ref_dec_and_test() ]
>>>  B: CAS 0 -> FR [ page_ref_dec_and_test() ]
>>>  B: * deallocates via __folio_put() *
>>>
>>>  C: * re-allocates page *
>>>  C: DEC 1 -> 0 [ page_ref_dec_and_test() ]
>>>  A: CAS 0 -> FR [ page_ref_dec_and_test() ] => success
>>>  A: * deallocates directly via free_frozen_pages() * => BUG
>>>
>>>  the big here is that the de-allocation was done not from the state of
>>>  the *page*, but from the state of who finished it off.
>>>
>>>  So that
>>>
>>>  A: CAS 0 -> FR [ page_ref_dec_and_test() ] => success
>>>
>>>  is not a problem per se. It's a fine case of "we had one single unique
>>>  final free".
>>>
>>>  The failure is that A then goes on to do that
>>>
>>>  "deallocates directly via free_frozen_pages"
>>>
>>>  because A mis-judged the page as having the old stale state that it
>>>  had when *A* was using it.
>>>
>>>  IOW, I think the soluition is either:
>>>
>>>  (a) every user of put_page_testzero(page) agrees tro do exactly the
>>>  same thing and there is no difference between how that final
>>>  "0->FROZEN" is dealt with, so it doesn't matter that A is freeing a
>>>  page that C allocated for something else
>>>
>>>  or
>>>
>>>  (b) the CAS 0 -> FR state sequence always looks at the *page* to
>>>  decide what to do, never at the caller state (ie A will look at
>>>  whatever C wrote when it allocated the page to know how to do that
>>>  final free).
>>>
>>>  Hmm?
>>>
>> Just wonder if we could make 1 -> FROZEN atomic to get rid of the gap.
> 
> Hmmm, I’m afraid that since you need CAS for a safe 1->FR transition,
> it will result in a CAS loop for the decrement itself (like in
> atomic_sub_unless).

I was playing with exact this idea when I was reviewing one of the earlier
versions; didn't manage to make it fly in a nice way :)

-- 
Cheers,

David

