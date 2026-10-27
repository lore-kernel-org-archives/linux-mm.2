Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61DD606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Syv1OBCV
Received: by kanga.kvack.org (Postfix)
	id 94F976B0723; Tue, 27 Oct 2026 09:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900336B0725; Tue, 27 Oct 2026 09:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4846B0726; Tue, 27 Oct 2026 09:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54C166B0723
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1864A8724
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:28 +0000 (UTC)
X-FDA: 85368425016.27.67F09E7
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8B3AB40005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Syv1OBCV;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106267;
	b=tM/e85q4aOPI2bA1/RgnwTAkGGY798cMpRNsxrEICP1KLEqh2H2+TU+3iTqJIDlex/8NPp
	HGUFLBfdD+WBSdXjCRNHAPXpc+9B5Z5RdVId1D92RAsZYi86EWGNx5I/8IOXwxlA4wZXOC
	GIB7YAno4wIV6v7LgZMrJ/9oDXe0SVo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Syv1OBCV;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gC/pRsYim10huITDmGzR2CXBohnwZSkq49YKoF5hze4=;
	b=WrKs2/XWsJItlf/LMIkAWdA4OhEJApvoi+I/NrACRnpRlWv5ob3wZ7hOXd534I3erMGuUY
	xRhPHWUq43bbmwA4LLtoy/O6jA6ro1rU4cvwSe2tn/gyX8c+5uaXeqQDxBVaY5hE8RBGWx
	Yjf0jDGUItyKaVk3fAzBSMoI/c+f8dE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793106260; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gC/pRsYim10huITDmGzR2CXBohnwZSkq49YKoF5hze4=;
	b=Syv1OBCVvxlQ3xaCIk2I8+H9FP4vQkDT+z4/6mkWV0QuUvs1V1ksuwRsW5Xahy5VgHOTXn/0avR/pHoMSDp/nzdIA4JgRipCOOQLZP0B3iVbJExdACsLlU8Qe/LZ0UYvTurnmRhzfq4uFBmKaS3MYWujcL289pUeiRdTO33i8VQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDdo7mv_1793106258;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDdo7mv_1793106258 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 21:04:19 +0800
Message-ID: <2890601a-e842-4321-94e9-673df94c97a3@linux.alibaba.com>
Date: Tue, 27 Oct 2026 21:04:17 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <d7f009c90b11ded86654885b5ebcb8c9308fa31a.1793067441.git.baolin.wang@linux.alibaba.com>
 <2ba579e8-06fb-41f5-9eb2-f02b2aabe29b@kernel.org>
 <87e32afd-75de-4407-8f0c-fb70b40d5eca@linux.alibaba.com>
 <81ee2c92-f342-4f7f-aacd-d9558e67a980@kernel.org>
 <de0b41fb-4ae2-46a5-afe0-c021134ebba0@linux.alibaba.com>
 <4880d4ff-8486-4e22-9923-bd4f2407b1cb@kernel.org>
 <f41d0720-ca14-4aa3-a2e4-3ba2de3280d0@linux.alibaba.com>
 <3c73fe54-68d8-41f3-8f9f-06c4a1891e01@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <3c73fe54-68d8-41f3-8f9f-06c4a1891e01@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B3AB40005
X-Stat-Signature: x7dcznfkk3r4eeixtpqhdqcto3n3rzbu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793106264-19047
X-HE-Meta: U2FsdGVkX1+veYUmWL/bJyJHII+W20DuEciRfpGZHmunIWE4vyadApGmnl4RYgVSe8nE025dpLDilDTx4yDqP/hEIMBUMMnY0Ohtds/uaIGCvCcKLrZ6P+ya5eUxhipU+Iki60Ab2nT8GIz153yCAGxcSyuthBHk2cty2ZG0vE7UkTN41LfLCMRgL8PwKKZs28GI66jWcRTNfVpDp/TKqY1cIkxHplOm2nB99IlynkeOfUo8PGSFvED7PPz923UX7MzXqfwA0MIoCJy0S3nV3++RVmWRfbcY6KLZFpbcCm4cu5DpnSCqHNT+a1hkB1GA6tFPxTjDWPbzashx7bj+cMZY81dNot6eS3955HwIsuyUVaPFNYXd+YaxMVqhjKDAKCB3yVRbwv4r5BKDKE8gh5t5D5OiRzwgmBo2bvETVb3suf5iCUv1JRhROux+Qoan33T3Xhs57kxdiM1OXS6P4QGvAJQA9ZGLshds6KAZm8OpAuc/wJ1mJAQkLFiL1Lh+FuZG6qKx26QlDPRBf682Vs3cU67MDyILLrzEC1xAvgYBQQeU1EF7mOgGV3m/5S4npdPeMey1lPqUJ6+Yp8Eys2t5JZj0orUT7hvzl69/khVNAhSUHbI8bNG+Zn9oRXDREM7qxt40TwOi/YdrSi7TyPYVnH/2SdDyQmIVxkiaXNN66q1gX9MsOsLC1qZdRGkh6BNxn1Qljw52nta3BVVlicUDRHcvSBRr7tMWc+rG/vN0flwna06gBRF9rVHMQzmHyrBKWXRsA7Su7843UT6vsoWNTStQ7rrGya4+mxSpYBfWl0T+W9SRdLq8KKvW7KhExDA/ryY9qRKApFbHPG2L5eeC/vb098rw2iknxcm9ecF0b7Guzy4GgBxoMyZ/vC8gtHmqqKcwtTnnWKIww0EJO2jCaIXITjcdPPVzIC8NJM4lSdsOi4PDiHYTHfSxZ8UK8uXLmzbr5FYcCEmPfVz
 Ng6ZJ88X
 SMd33dZZeQrpfbFwKHw8PYKs/DAXeNs/UrdQJTR0UNZYBmJOjCr2LEt7oU8J3SULoRbrGBw8I9i1n9uA3wQDJPZi1AFAHWkV0/xTHXYrUcbzgaTzFO9FeDa6QXRCl4+Qie3PW0nGQ6d7nlMH3l17oj0E9/34CgwWWKRgqvWSlwyoV5cKhb5/F7aSZ/HhYn9aaBQ01gr7hN3lLY9DtJnJGUJSSbi2IkjHzH8Nvw5HYj9RGuqvqS73nonGyw0BSsCAJOfIFAnSvXIlZNBeYLsXpchRnKB0pUozboV6xVpGyjuVOiPWh2NIFdtJ9H+5OxwsduedS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 8:53 PM, David Hildenbrand (Arm) wrote:
> On 10/27/26 13:50, Baolin Wang wrote:
>>
>>
>> On 10/27/26 6:55 PM, David Hildenbrand (Arm) wrote:
>>> On 10/27/26 11:35, Baolin Wang wrote:
>>>>
>>>>
>>>>
>>>> Sure.
>>>>
>>>>
>>>> IMHO, I'm not a big fan of adding two pmd_none() checks just to avoid an
>>>> uncommon concurrent sync.
>>>
>>> It's what we already had. We had to: one for handling pmd_none() directly and
>>> one for handling zapping while splitting (file THPs).
>>>
>>> We just managed to let the second also handle the final piece of the former.
>>>
>>> Anyhow, let's get this fixed.
>>>
>>> If you think the code is clearer your way (where I disagree)
>>
>> Fair enough. Though I have a different taste, I'd still like to make the
>> maintainer happy.
> 
> Don't worry, it's hard to make me unhappy :)
> 
> (just a bit overloaded right now)
> 
>> I'll send out v6 tomorrow following your suggestion.
>>
> 
> That looks good. 

Thanks.

> Are you planning on following up with the memory barrier
> optimization for smaller folios?

If I can find some time, though I have quite a few pending TODOs now :). 
I don't think this is urgent, so if no one else picks it up, I'll add it 
to my TODO list.

> I hope below doesn't end up in some performance degradation.

This is not a common case, so I think it's fine.

