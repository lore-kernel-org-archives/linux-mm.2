Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC165606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=a2iC8BIg
Received: by kanga.kvack.org (Postfix)
	id BF86F6B05B2; Mon,  2 Nov 2026 20:28:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA136B05B4; Mon,  2 Nov 2026 20:28:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74C56B05B5; Mon,  2 Nov 2026 20:28:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 859BA6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:28:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59BD91402DA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:28:45 +0000 (UTC)
X-FDA: 85392073410.06.5BE5C88
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2ED85140007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:28:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a2iC8BIg;
	spf=pass (imf26.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793669323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYiqOA3TF5D8l7p/X4g/neFYYur8zLKr3v5bYCoBZMY=;
	b=oK62tioIzr1CDBZyHL6hb37XMWEF78la8QWEkmKXS7Nuvc+QmOMH/dHvPk5YHzXoCWLMoc
	Pg+WszLptTtF74XjftQYs5SNujIR5AOtnvhOr9cq9Hkgw85LWdEnyZ+WS+MvbajAIDKre1
	DOleOGSNN0yBP8/C3IMYN5m2pIqU5gA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793669323;
	b=cEDpycM81nOEp3+OEVQFxOBd7cQmlSo8meLxrK42W2SvdVKo1pRFilc/hMYj4OMg3/eOpo
	fKGjICk7q8crgpUMOs50LTufpk50d/R9/vYSkpLSSSX/rOb1CjJIMzhN+bBteMPngF5sQI
	lXM87OC4YkWFx9H26Dzod7S/9bdJfeg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a2iC8BIg;
	spf=pass (imf26.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ViW3AR3aucqfjaslib2uPpXkrn3bYgKYm/ie3qj5EvY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793669321; v=1; x=1794274121;
 b=a2iC8BIgro5Y6032BHcbFol1vwo/kIZR2Fvy+Tm5OKERGZxUuNPx+fwCSgxo0mGO64IUugpZ
 JEav5eR6Edm/13yko8Z2YhG5u4GqMAhGPdp7DLKWiKD3mjzhIOzjk1QkVArTTJyL5KNdEZuoX/I
 rlNknM/mqdoEHcQk2K1ddz5o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4a6a12f2aec11156;
	Tue, 03 Nov 2026 01:28:41 +0000
X-Mizu-Trace-ID: 4a6a12f2aec11156
X-Migadu-Flow: FLOW_OUT
Message-ID: <d79c6bd5-68f0-4268-bc4a-7d453acc26ff@linux.dev>
Date: Tue, 3 Nov 2026 09:28:30 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on
 writeback
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
 <CAO9r8zP15iW3ECW2Bs0rfyZrifeisDunLa6qJC43M1RcE16wWQ@mail.gmail.com>
 <auJkvb-Lq0M5Enkz@cmpxchg.org>
 <2bd4f0df-80c7-4d32-ab50-1225681ff6be@linux.dev>
 <CAO9r8zPuDtn1S0g8rDnXNfSdZ6uuH1geXALDN5-X_SZpM_W+wg@mail.gmail.com>
 <aujBMrk-nFaVtPsB@cmpxchg.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <aujBMrk-nFaVtPsB@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 683167izd5k14duaxazioc5cedzks3b3
X-Rspamd-Queue-Id: 2ED85140007
X-Rspam-User: 
X-HE-Tag: 1793669322-798012
X-HE-Meta: U2FsdGVkX1+0IthB7THeJCPw0wQtN0yrrcpdhWM6mxw1Vz+xcIJ491QxPzs35Dyb4uzRt9iS2TczICZeNkiPg649xF4UDuBtt9iDbo/Ei2CLFUmxcNOe+vN4x51XVHfd0aS5dHqo8eRDd5rGDzY5vIMItUcbFDAqXvoOObLxnJqwOMS4rNZoN5xwIOvNdTt0hmaavOPLPdAUJ9Jyg//dTPGgcNsDokwtLSPVlULS9mS7WEEbomhtQWw099KmfHiSpcriKNMnQFZYUCfsaJXGsfyBMsTC3EIrAHOfjIVwArOO4ouXI+hUTVLv9+XbXANj8C1wXRFelF7ynczzUirvNU3H2LMqMvQemWSaYLpGP5z55SbZfeDKzIWiAnaXuYvH2qG6wRydet9/sPcnZ0slumlqtDYwxwXvYNkUkxrBZl1HuGvMvHf/b4zNOpNDJxUEeNqI8H7GOvFdXZf2q7wmVfo0/MiXdxCh2lwdT623Mtc4f5NVce7hT9zPaMMm9W0mc4OFh1KhT255e9+T+22xOC7QujEq0VsyH0PCZ3e+VH2It7cEmt/SHeNDGojNUIHaUkGfxP43Z5u5ndrlr2FayuEdnd9rsG1iGfH9X5sPKiJiBqhQdJYZ9KF2AMwftVdyzJ8NBL7Xc67dvtXvnnNjAK2Hqkzhy8Aa30v/SjEmqI1nCZyL74aCmLVZe6ujZngrKvDk2t3dpTBxZQwh4iOF5yCTKutrNlmSNX1FXXf9rjylkxGWGhKjMvqRPmyRWlhrCIMWup4SiVLPU8QmULusq2t7ppiJ6okuSptlqh8m+mgB5mdMNRsbs4pBLk0MeBpkku82D6XhPI3KfI/TXCmO5/yOKB17RsHRzlc8LFUEe5eJvR97YWOSFcaH7DrEdJH7YfHwBaIsLSQhOk3/44N+OfZqOLr7X1RQgkTRYqV7qvwdRZsecUrWsmrons5nBlhfhOIBNXUNhvfUP5/9MOV
 aH6I91MR
 WbJXVkj4pIux8l7aBfiavD/n7onFZ7zHXFKbdluwOZT7v1TJtBb08S5R0C1toUv5epVZKRydFaAQO0rhwI8G1ntNZIuGd0PFKvv57JGQpfot4ohtVwj62BFzv/fHcvwqS4ut2Wz7N6HbsH/9Oof7mIFlu1I7nxjD1e7snfDpPV7pgNMQqjg/StFPFnxQjFvAAgU6/8Kb+mMR7iNct0pcdGTcQuRtuFHJ1h0fCBKECkJ+rk4fKQ2dvMQ20F6jNaGdieEWoFlLCdFOFT0TRDytOz+Ktue3HwV9tdMwAydGdzUhR7f7G/oryffOmgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/11/3 00:58, Johannes Weiner 写道:
> On Thu, Oct 29, 2026 at 08:10:54AM -0700, Yosry Ahmed wrote:
>> On Wed, Oct 28, 2026 at 9:23 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>
>>>
>>>
>>> 在 2026/10/29 05:10, Johannes Weiner 写道:
>>>> On Wed, Oct 28, 2026 at 12:22:43PM -0700, Yosry Ahmed wrote:
>>>>> On Wed, Oct 28, 2026 at 4:36 AM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>>>>
>>>>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>>>
>>>>>> Successful writeback calls zswap_entry_free(), which removes the entry
>>>>>> from the LRU and decrements both the sublist and node item counts.
>>>>>> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
>>>>>> to decrement the node count again.
>>>>>
>>>>> I wonder if we have a valid use case for adding LRU_REMOVED_COUNTED or
>>>>> LRU_DELETED instead to simply avoid the decrement.
>>>>
>>>> It bugs me that it's the walker, not the callback, that adjusts the
>>>> count. That composes poorly with the normal list manipulation API.
>>>>
>>>> How about pushing the accounting into the isolation callback, which
>>>> can then simply use __list_lru_del()?
>>>>
>>>> The tradeoff is that more things need to be passed into the isolation
>>>> callback, but that seems reasonable. It does make the change noisy,
>>>> however, and we might want something like Kaitao's change as a
>>>> backportable fix first regardless.
>>>
>>> I tried three approaches.
>>>
>>> The first was "pushing the accounting into the isolation callback", as
>>> Johannes Weiner suggested. However, as Johannes's example below also shows,
>>> this would require extensive changes across multiple subsystems. I doubted
>>> that such a broad change would be accepted, so I dropped this approach.
>>>
>>> The second was to add a new flag to enum lru_status, as Yosry Ahmed suggested,
>>> to handle cases like zswap where the callback has already decremented the
>>> count. However, the incorrect lru->node[nid].nr_items value in zswap is only
>>> an accounting issue: I could not find any code that reads this counter for
>>> zswap. Changing a generic interface to fix an accounting error with no
>>> apparent functional impact did not seem worthwhile.
>>>
>>> The third approach is the one implemented in this patch. It keeps the changes
>>> within zswap and fixes the accounting issue, so I think it is appropriate.
>>
>> I honestly think it's a problem with the list_lru API, as Johannes
>> said, walkers compose poorly with the API. So I prefer we either take
>> Johannes's suggestion or add LRU_DELETED, unless there's strong
>> objection to both ideas.
>>
>> FWIW, we don't need a minimal fix for backports, I don't think this
>> needs to be backported at all. As Kaitao said, I don't think the wrong
>> list_lru count is being used anywhere for zswap.
> 
> Good point.
> 
> Ok I will send a proper patch and we can discuss it from there.

My v2 version is almost ready, please give me a moment.

-- 
Thanks
Kaitao Cheng


