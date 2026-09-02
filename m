Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8093FC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18DA6B0092; Wed,  2 Sep 2026 07:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0BA6B00B4; Wed,  2 Sep 2026 07:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E366B00C8; Wed,  2 Sep 2026 07:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 718C96B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:28:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B6EBA01C5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:28:48 +0000 (UTC)
X-FDA: 85168599936.01.807391C
Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4618E12000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:28:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQ21WYE4;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788348526;
	b=t/RIXI/bJbwzm7YX0Gtv/zWOpxJtAToJ5xLly8B5hEMc7q89NZahtx8Vze2zkkRsa79fR8
	ojVrk+4O6Fsf3bC1l//WhjkYErGMWZAAWF9LeExHKGNGp306Sy5VgdeiGPTnZj2CfgGdXJ
	SR+UnDH/rUW5C8n89JNjrCIqgmQNieU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQ21WYE4;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788348526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uyrmsl3V43OgEQhpn/KJq6OMnR3OGaVgjEiEzJ6DwPY=;
	b=e39LRT6s5Ibao9BSjUs+baDTxjxZvslY24VSqywhKCFdSLqXx40ZOeXDRBvxEhqP83Udkq
	u04yflb1Hxfr/szvbbAji57BLVgHLD2RJmUTOlYp6Fik05IEyY3Gtke26zt8U6XV4AbffC
	HhIiWusRV6UsbCpmQFMnKSSpjLtDO+0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3x2mDZzfQsBjuVb72vf1gz1TkiHlwuxtteD4iYUeP/M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788348522; v=1; x=1788953322;
 b=nQ21WYE4+xmg+AqAtI3A69TmEa6SRGTfGkSs4Ph8d7z1/siaBPESE2ClmM7EsWw0mZrt6e6S
 ON2koRiXa7rcgm4JvloMT+uYidb22nTGoS4IH1uAescbrB3JH+VB7hA+ytjohTExn2FCehDQg8J
 o1BtsEvZR/bRQl97meFNbEXM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 64bff105bd861d77;
	Wed, 02 Sep 2026 11:28:32 +0000
X-Mizu-Trace-ID: 64bff105bd861d77
X-Migadu-Flow: FLOW_OUT
Message-ID: <b066c25a-d3ff-419f-a0ee-e99070ce0788@linux.dev>
Date: Wed, 2 Sep 2026 19:28:28 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH] maple_tree: Annotate lockless pivot reads for KCSAN
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Andrew Ballance <andrewjballance@gmail.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20260826074430.1139325-1-hui.zhu@linux.dev>
 <20260826094147.42e1e71e91a5a537ced30a21@linux-foundation.org>
 <kpzm3pcwxwnzk5kngcsfcybzst5jtyrdcphd3hcpmoc6dbtswq@atn5yddl23qx>
 <f33eaa0c730feb9f598738ff79d98cb25b4b2bcd@linux.dev>
 <ccgj2ukobxzdpypdi45vvapxbot56lsqmqfzzkcyrgnkjetybh@gghifhsc7v4t>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <ccgj2ukobxzdpypdi45vvapxbot56lsqmqfzzkcyrgnkjetybh@gghifhsc7v4t>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d75rq3j61pjbd916o5k1fm9hnwsdj4n5
X-Rspamd-Queue-Id: 4618E12000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788348524-316898
X-HE-Meta: U2FsdGVkX1+ci9zLo9UP4TXnRJZ5GFV+c1sfeX5i9ad/7hnKqKhZCjio/h2U+zF31VdBLyloSikVjb3/dq6gEc6SqrrXpCMQyvQyjI3egGqXb417/hVWAOFDM6q+HZT82plJR5PDeREIEFmyMD0gp+RaDE2yK7/x1Zt0kI3UpREW3Jo4Xo8b5eTIAfit+S+9AAXFkygmq+z8fcrqQ8uOMKC/KUzF3pEsvQUpf3fQ1fXIx2C0G1aNRWxFr/B6RBfsyD16f/qrsRytuFIbcphwqZq4FIcYDtX1Mr/0n96MRL+ofBF5RJZi5jDAuB6Qw5DCD4xPGhW9NrgARkkzjtVX2/uMSuZ16bJ3HHIi1xXyw/IwA2f/cqYDUoD+lkBmN+S2IlemvuiovNz8YnqbjeBj/5fgEvyUStWWHTKAxv/QtAKZfLLJIrha2+q+7ChEN//6WOIi4NhCc5Na5UvQ/6WJrnz31e1aSes0n8ldTnSFcHEkYjwwvavaJlhM1H89SaqkrpYqbxbtkxk5pUqLWW0djFjV0/Q7EEqWJWbdbCCzo1gyMAaD1RyNTzIL3jjUoQ6+xFsBif/LGDfKuVtaCpinmAqgeDM/lUBXYmT+JxYo7KzFEQFfYpOnrncIy+oMzlt1+YFLEPAJWi8fmoDA/gYsOV6LNi6gO+q2wf4ZJpZ60rHuXYXUIOWlqCRw8zgeZO7zIYVm1BNOkehg3Y4OybOMVUymsaz8XGw5Uy+gHN+U0zjX+qqsV4v0MVT/igMXyp941BWJJEQZ5yW7HcVLbGvD93eXxqV5OUIHuUkGxwWcD5951L6ZunLMqPiraLcd/ginPTOycCPTjyKwz19yVR5tyI0m8D3CyJ9WHriId/SrGk+44iBsYTIfKJ7dNhZy6FpBtPYDnEHjKWYlUfZH2oKU9W7dlw4EDUIlIiNsXf3su44BLtaBQBw9Jq5PhyOXsg973aqzRAe2QzmPa+WLWwc
 5pPXhsnE
 70fO6VPb2Wp0WoO+ijCw2rl1LF7C6GOQznrD/hiu9nMHxSWeRiFocJ3R2wt5gMaws30KrNLo5C5chiri9x4iAeln6ygz9XIQBfBkN+DCvV5QXRNG5WvloH4ajj7p75l37va+UbRQ8F8ZgNHYhfsnltyE8k2lGRvA+wU1SznZbwmw/C5JzL7qvz4o8lv2+PO8bXB5UD0lGbpXNRk8Q+eFHCXbeernRmRODf27D6WUf5tScFfm3ZWPODna3w/cMluDraUL6o2MLbzk7qP5pPfw0yaQvra33V1CazOY6Vm58kBytlgnkGp59Viqy9sUFcllpCnbVvui9X33is0v7Z+JgPvUxHJ3waiXEcGl3hwjvYFCRw5rO/wHSTQpzxJkgvmFNdzyPWTVKnZWm5ytgYQhu79mTyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 26/08/27 05:35AM, Hui Zhu wrote:
>>> On 26/08/26 09:41AM, Andrew Morton wrote:
>>>
>>>> On Wed, 26 Aug 2026 15:44:30 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:
>>>>   
>>>>   In RCU mode, replaced maple nodes are marked dead and freed via RCU
>>>>   after the new node has been published. Arming the RCU free writes
>>>>   node->rcu.next and node->rcu.func, which share storage with
>>>>   pivot[0] and pivot[1] (see struct maple_node), while lockless
>>>>   readers may still walk the dead node. These stores therefore race
>>>>   with the pivot loads performed by the walkers.
>>>>   
>>>>   This is harmless: the writer marks the node dead with an smp_wmb()
>>>>   before arming the rcu_head, and the walkers re-check ma_dead_node()
>>>>   after reading the node and restart the walk when the node is dead,
>>>>   so any pivot read that raced with the rcu_head stores is discarded.
>>>>   KCSAN cannot see this protocol and reports the plain accesses, so
>>>>   annotate the lockless pivot reads with data_race() through a new
>>>>   ma_pivot_rcu() helper.
>>>>   
>>>>   Found by fuzzing on a 6.6 kernel; the race still exists on
>>>>   mainline. No functional change intended.
>>>>   
>>>>   
>>>>   Thanks. AI review suggests that the patch is correct, but incomplete?
>>>>   
>>>>   https://sashiko.dev/#/patchset/20260826074430.1139325-1-hui.zhu@linux.dev
>>>>
>>> Yes, this is literally every read of numerous pivots on any reader that
>>> would need something like this. Most code is shared with the writer
>>> side, so we'll have data_race() annotation where it is not needed there.
>>>
>>> I don't like the name of the function and I don't agree that it is worth
>>> doing, especially half of it. If you notice ma_ functions take a maple
>>> node as the first argument, but your new function takes an array pointer
>>> in the node.
>>>
>>> The from address does not agree with the sign-off on the patch.
>>>
>>> I also don't think a benign race needs a Fixes tag?
>>>
>>> It might be worth looking at other ways to calm kcsans down such as the
>>> type qualifier __data_racy, or maybe the makefile option.
>> Hi Liam,
>>
>> __data_racy is defined as volatile for KCSAN kernels, so the qualifier
>> has to propagate to every access site: ma_pivots() would return a
>> volatile pointer, and all the "unsigned long *pivots" locals and helper
>> parameters in maple_tree.c (about 25 sites) would need the qualifier
>> too.
>> It also marks the whole pivot array as racy, while only pivot[0] and
>> pivot[1] actually overlap the rcu_head.
> Isn't your change already using the data_racy annotation on more than
> pivot 0 and 1?  For instance, mas->offset is often passed in and that
> is likely not 0 or 1.

You're right, and I looked into annotating only pivot[0] and pivot[1],
which are the only pivots that overlap the rcu_head of a dead node.

The trouble is that the index being read is only known at run time
(pivots[offset], pivots[mas->offset], ...), so the only way to wrap
just the pivot[0]/pivot[1] reads in data_race() is a run-time check
before each read.

For example, mtree_range_walk() would turn from:
if (pivots[offset] >= mas->index) {
into:
unsigned long pivot;
if (offset < 2)
     pivot = data_race(pivots[offset]);
else
     pivot = pivots[offset];
if (pivot >= mas->index) {
These walks are the lockless hot path (every RCU lookup, including
the page-fault path), so this adds a branch to every pivot read.
data_race() compiles to nothing without CONFIG_KCSAN, so the annotation
itself is free in production kernels, but the branch would cost on every
build.
I don't want to add branches to this core code just to narrow the
annotation, and I'd also rather not widen the suppression to pivots that
never race.


Given that, I'm inclined to drop this patch.
Instead I could add a comment where the rcu_head is armed,
noting that the pivot[0]/pivot[1] reads on the lockless paths are
expected to race and that the resulting KCSAN reports are benign,
so anyone hitting the same report later knows to ignore it.

Does that sound reasonable, or do you have another suggestion?

Best,
Hui


>
> Fair point about the code churn, though.  I don't need every function
> being changed to accept a volatile.
>
>> The Makefile option (KCSAN_SANITIZE_maple_tree.o := n) is a one-liner,
>> but it disables KCSAN for the entire file, so any real data race
>> introduced in maple_tree.c later would go unnoticed.
> KCSAN has never reported anything real to me and that's why I suggested
> turning it off.  After speaking with Paul McKenney on the matter I have
> been convinced to not disable it.
>
> I still don't really see a whole lot of value in annotating the code to
> say a particular race is not an issue - we will have mostly disabled the
> tool by annotation in the end.  And these are most likely going to be
> the areas where we have issues if any arise - ie, some special arch
> corner case that comes up that didn't exist or wasn't in mind during
> annotation.
>
>> Do you think one of these two is still the better choice, or should I
>> keep the current approach and fix the patch according to your review
>> comments?
>>
> I guess respin it and see how it looks with your current path.
>
> Thanks,
> Liam
>

