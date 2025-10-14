Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55814CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE108E00CB; Tue, 14 Oct 2025 04:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5C38E0005; Tue, 14 Oct 2025 04:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12768E00CB; Tue, 14 Oct 2025 04:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A46B8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:27:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04E2C140776
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:27:11 +0000 (UTC)
X-FDA: 83996039904.12.05D5A47
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id AE44E40002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:27:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fy7NbVJG;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760430428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7oOL3kdYYlknYR47TEXFdShOrQCn0oEFnG9MAYkawAg=;
	b=8fjdNhteBzSQRHLPvaey8482XtExL/YIlw9Ky+55F5zChZSt5ccktJE+bx1rm1+l8FJvb+
	xtxGTWvHDz2UlVSsb6lPDGHZi/+/LWOxqPcWgWHcoCid2+W/mfP53AgRXJFU1ZvJLgxNGr
	mSfGFMyTf6qA/B8iQkbTlMcdrJX3eSs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760430428; a=rsa-sha256;
	cv=none;
	b=4u4uWXab3xRAo2esg3E/C94jKFxrhVkp/Y07AMYXR/wzmmNghjWpqCXWZtZRBgKHb7bdyb
	OgzOIzZoNW9lq9bCNriQ7DxuW3cNNrZ+8XICwmnpku+tYB5+4tehtQNfiDpTc1h+6wNMvX
	+8cXqByBD9sDtR86HmX2wVvV+kdNYBY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Fy7NbVJG;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <4a911279-5e95-499d-a188-dab72d75b6b1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760430426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7oOL3kdYYlknYR47TEXFdShOrQCn0oEFnG9MAYkawAg=;
	b=Fy7NbVJGzcvQp5AxZL9wsPPbNvhZ6Cv2KBbR1jXxS+80Ht4gbiS+kPd6pTdFaKtAiqqKI+
	MPLbmQ4tferMUufytYuujs6TT2k7skGYz4nBWKtog3AHoA7CXk9tQcHO2g5UXEt9w+CkEX
	2KwX3rMtkFa58wxX5TBsLlnCfWOq3Wc=
Date: Tue, 14 Oct 2025 16:26:56 +0800
MIME-Version: 1.0
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251011093054.886460-1-ye.liu@linux.dev>
 <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
 <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
 <d619784b-b967-4795-aad9-6e79d4191b83@lucifer.local>
 <dfc18351-bb77-4099-bcdd-eb2bd4f1bea5@redhat.com>
 <fa2d7db5-688c-4d04-abcd-a60f79a6bb7a@lucifer.local>
 <71803dce-3fa6-494c-a4b1-55d98fc4aadb@suse.cz>
 <bb9cd331-326f-4ddb-8848-60195e41f012@lucifer.local>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <bb9cd331-326f-4ddb-8848-60195e41f012@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: s633qjmycbspshsp6596u1dgzbc7chxa
X-Rspam-User: 
X-Rspamd-Queue-Id: AE44E40002
X-HE-Tag: 1760430428-465131
X-HE-Meta: U2FsdGVkX19/JR6G5sF/kog5kcHYmzchoFQRGXsRFj3hBNFsZvpX70hBO7XQHy84JNi6Zpoae9+Fu/qVNOfJvQDQVC9Sq2OgDJ1l7uJTzPZM+uBhe5l2Uqt8xSaHKVIo2d/MyEdtTw9ss/Q/pspu2yek8QJ5Mj/4Qqrhr2D7xk0UNmHiFzndaQYz+nKisk67oc65aqAQ8tiYRvUQpWtSseBkUWUTmtQPoKtQeYJZ0Tn0A4FQxW1vyhHrhZloY25h9FBpzKULMyF3tVhnbFPjyHDpI/90dZYCdH8yLB3mwj4SiGeBQg21Q5ebwD4mr4fIkLEDWjFWAOjoZGeDnPv3GHLg5Zcd83YaKz+lZWz59wnCCnSNhaQpY88cHrhYKPIjekQq7dzCZIiGzf9vMoDo9HkGGkiehMU8NN3za0qt66Rd8jBAz+zR6A3u1gI2znOg7aVpjDAluNZay5yADcHRGHFo/ouwgAx5Mpmq8xUEkFETktKtEpR/RWs/xWIPdu3EETTegdo+nlKpqDvsMoqj9is/7ZTtxqB5fT50HiG5iGakF4uXZu6Hb7675pHl6N+jfX3PNi19tosWUyleYKqM3daOI6sapSQnqTKKVyxvQb599Xzju0IC7MI1LIDI46GhgfRGN4xrAYR0nhqOMVUbm03QoSSpJUFo9eI1U73M39rjtMZSmm/IqB7ieTr9Tb6MObQVW+BO07OsPVFSHOx3OK1KXCtVMY1o7LN/NSN49w+QZJlduMW943xIShTwFwYls9cYoHPx/XmYD6e2RkHk2yoLAfM1H3VhdInbhg3bepigCBsL16fvyr9Rxy8shVfJIwpk06DSMBECMqfYs9pmGpNqwC4+5f3IOwMKraj7dVh2i178Yqy+iKHOE+/tr1sAOHNch5tOmTHLg7Q+5QuVR/oqNR0vVfKOn8RV2KQLXc6/BYNEbWPWFi/u6mHo+ZsuqAVRuD8C7freObapdq0
 0BSvybLN
 vmvsFSqS1FjUY5mmJYgudg8s9/Ib14iK/4EhDcEiesAfXdKZnz+iuXXfn/jgTzXC7Nh6o5PGYOU2jLgZU7ktkpnvEKJy3fcWxaGrwpjCffq1RyPy7fHCiG2GpBbg9IxpWkdvWYpAamI0VBdCePsHPXbukbX07rmZ8n4fT4kqnkrVUt9ghAZ/E9TdZZO+6WcxNDUET
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/13 21:19, Lorenzo Stoakes 写道:
> On Mon, Oct 13, 2025 at 03:07:18PM +0200, Vlastimil Babka wrote:
>> On 10/13/25 14:57, Lorenzo Stoakes wrote:
>>> FOLL_* flags are an anonymous enum, enum fault_flag is not used as a type
>>> anywhere, nor is vm_fault_reason. So those are both kinda weird as to why we
>>> even name the type (they're in effect anonymous).
>>>
>>> But also 'we do X in the kernel' doesn't mean doing X is right :)
>>
>> I think the example to follow could be GFP flags. Nowadays there's an enum
>> below it, and a layer that adds (__force gfp_t), so you could do similar
>> thing with vm_flags_t.
>>
>> However I'm not sure how compatible is that with Lorenzo's plans.
> 
> That's defining bit values in an anonymous enum so isn't really comparable.
> 
> But what it's doing, ultimately, in broad terms (other than the opaque bitmap
> type I'll be using for VMA flags) is what my changes will do.
> 
> And yeah, trying to do duplicate that is not really a good use of time and will
> conflict with my work.
> 
> Overall I think this change is generally unnecessary given that I'm about to
> radically alter how VMA flags are implemented, and actually will cause me
> problems.
> 
> But as I said before, I'm happy to prioritise the change that specifies the
> flags based on the bit numbers, I actually have it ready more-or-less.
> 

Thanks for the input, everyone.

Lorenzo, I agree with your assessment.
I'll pause on this from my side and wait for your patch.
I'm excited to see the new implementation.

> Cheers, Lorenzo

-- 
Thanks,
Ye Liu


