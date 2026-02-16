Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7BCE7BD80
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 09:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565EF6B0005; Mon, 16 Feb 2026 04:52:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513F86B0088; Mon, 16 Feb 2026 04:52:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416606B0089; Mon, 16 Feb 2026 04:52:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2346B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 04:52:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB3955CADA
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:52:43 +0000 (UTC)
X-FDA: 84449855406.23.AE2CBA1
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 71047A000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:52:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ws0qq2Nu;
	spf=pass (imf15.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771235561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1XmG/hIaACTUgj9EBZ/72IQ5DDq7ji1NcrhuA61/gY=;
	b=1whOsnL9Ess2WNuCu7kuhe8F3M/1mqbFthpSmfAFTDwLu8xj5rgiMZWw1BoKB7y7pbXg3q
	9JhfpHqTvwmSIgJ5XQyS55+B9tZaFj/B96Kp77ab7tQK9fuwW+oLxUmxBmpsGtHSWVugIV
	GJaljxNDuw17h3R5qtChwshMuqT+m4w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ws0qq2Nu;
	spf=pass (imf15.hostedemail.com: domain of pankaj.raghav@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771235561; a=rsa-sha256;
	cv=none;
	b=N4pvXVax6OIFlenyKsEN2K+mykCIwLwqLVQfu5DKvhTNWk62lyUUCFJyNVxlfb1m3gTOTo
	EXTpzDMKklks5pf/JMuTPtIwmNJU6sozwqQtbnk2KhjiCWLb7k7lYY9jf9JkCpW4kET/0G
	tHL9vfLYYe6PqvRvpWTAv2Rs5cGRMrA=
Message-ID: <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771235558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1XmG/hIaACTUgj9EBZ/72IQ5DDq7ji1NcrhuA61/gY=;
	b=ws0qq2Nut0J5hbxl5bHXlf7XQFx3x6Mx6g822LS8NfZJDAE5CxoIZ9x9O5bC1hDcxgJKv9
	VXJglNMvxamiC1cq97YAIcLqaDq0rxOpEM0KYhj5GvQWhh8Wlk9W1wroyXXzGF5v64hdVE
	ild9jTGKiQkQgQ+vAiU8rzs+5/CFKOU=
Date: Mon, 16 Feb 2026 10:52:35 +0100
MIME-Version: 1.0
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
 Andres Freund <andres@anarazel.de>, djwong@kernel.org,
 john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>,
 dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
 gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
 vi.shah@samsung.com
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71047A000D
X-Stat-Signature: pcu8ftixe1w177zgz6bo1y4pemajqcrr
X-Rspam-User: 
X-HE-Tag: 1771235561-894171
X-HE-Meta: U2FsdGVkX1+L7temWXG35XXRLjZqFAqb9na1uKzKHpXEtGvFOW2R9ADdYCbVAn7PvAum1Yt7bQS380I6POGS/Ortlr5/eqoJe2Y3AA4Pur3VOjXsYNrd/bF064H9VibqO66Ek30vOxfrMj0CsWRJuFEvU4+Gr/tAfg+HvHzyj/irGREK9G3Q5Oxb+NMxImfY4zHk143gX8syksFGXeXw2IswDDC6NdaIMEZ0rCwbhJ408jj1x14qZdHAN4jsjuB23J9BVYq8MUbcH08j9k2EFeq6tLEmbRe1+845tKtqGV8xOsGApOirsJDnc49qY7kbeOq4+94iFNgln/3ZaATi9l9xyDO5tZceBI3GXm9ih7uTGBIV3QakhtDZjVvS5XY89bPWWG4ENpTrfxTJQvKU65wf8hGUfT8yGdqLw4U27ocBWglrT5AA+r3YgBG1W8y4CUeZw6wcWsagU4mjH4+4DPJtQB5s3tEsA6X2fnop5xtWM/jUSPATgONkr3mr7/d/rep0kqxlc1GtMAVtEW/1B7A+qyrqdCEViS542QhrLfwTvVDU7pB+h7h61l3kbLX7m4TYwOphlDFJLR/pfBPiXojy67zM1prsx4sXCUim5Ag5CJ7FQyz3tyErA1PSTrQ7dRbuszqRkIbKraWXpTMNmC4ByOmNwDvEKrELeYcV/BuDKCG65NlbZlmb1ezkJQ8o3AO+/iSorWLAS9HiBW4u8FA3mw47vZRiITqjz+f3clL1uh7zVMxELDyTKhrRDotrgAhBXk7d3mu788E2WJdS+JYfIYlW0ee/EIGb94Kglhc/WwRVpHLCR9jIYCgHTmog6OpSzEwBUkcFQSXbJBMe+k/3dwnPzavY+xSWTkmVRnEKC2Tt141sMRqTbZUEw8RIgWNXh6YLbdCWex9LRG+dm721olo0x8/cjcxT0WIPLw42icU8GsJs4KotzTCMmjMHF06/+er8xBlVy3i7gvH
 9K1PvKP8
 TeBD0lsn+jQGP3vduARUg0sksQLiOcXGUMnqj4ncFx2e23ZEoOSG1sy//BN7uRJpZSbkX6T1mkRtIF8vpum7a5Q9I9UyB09hfP+GAqa/1AqCv0XPuMGqyCl47yKGZsOPNYWh1CiyZanilkb7G2C/hmfohiBCZI4l7luK35pV+4nTz3GegHN8IHUH3SDlJ7jmGtvirbak7j6j79jKM1WjPSML5ej9bEWPzqgmbjRAoSr5XXUjI8EERLv4tqjG5goiL5fWBt08icQrxrpllqY/v7xkr/EqIaT1CGuRYrB4D1kSXur1RdSZR8V+RYHNoLnUl5KPrDW19UycL3AQsCDAjD8UtVcPaU1TXkh2m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 14:32, Ojaswin Mujoo wrote:
> On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
>> Hi all,
>>
>> Atomic (untorn) writes for Direct I/O have successfully landed in kernel
>> for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
>> remains a contentious topic, with previous discussions often stalling due to
>> concerns about complexity versus utility.
>>
>> I would like to propose a session to discuss the concrete use cases for
>> buffered atomic writes and if possible, talk about the outstanding
>> architectural blockers blocking the current RFCs[3][4].
> 
> Hi Pankaj,
> 
> Thanks for the proposal and glad to hear there is a wider interest in
> this topic. We have also been actively working on this and I in middle
> of testing and ironing out bugs in my RFC v2 for buffered atomic
> writes, which is largely based on Dave's suggestions to maintain atomic
> write mappings in FS layer (aka XFS COW fork). Infact I was going to
> propose a discussion on this myself :) 
> 

Perfect.

>>
>> ## Use Case:
>>
>> A recurring objection to buffered atomics is the lack of a convincing use
>> case, with the argument that databases should simply migrate to direct I/O.
>> We have been working with PostgreSQL developer Andres Freund, who has
>> highlighted a specific architectural requirement where buffered I/O remains
>> preferable in certain scenarios.
> 
> Looks like you have some nice insights to cover from postgres side which
> filesystem community has been asking for. As I've also been working on
> the kernel implementation side of it, do you think we could do a joint
> session on this topic?
>
As one of the main pushback for this feature has been a valid usecase, the main
outcome I would like to get out of this session is a community consensus on the use case
for this feature.

It looks like you already made quite a bit of progress with the CoW impl, so it
would be great to if it can be a joint session.


>> We currently have RFCs posted by John Garry and Ojaswin Mujoo, and there
>> was a previous LSFMM proposal about untorn buffered writes from Ted Tso.
>> Based on the conversation/blockers we had before, the discussion at LSFMM
>> should focus on the following blocking issues:
>>
>> - Handling Short Writes under Memory Pressure[6]: A buffered atomic
>>   write might span page boundaries. If memory pressure causes a page
>>   fault or reclaim mid-copy, the write could be torn inside the page
>>   cache before it even reaches the filesystem.
>>     - The current RFC uses a "pinning" approach: pinning user pages and
>>       creating a BVEC to ensure the full copy can proceed atomically.
>>       This adds complexity to the write path.
>>     - Discussion: Is this acceptable? Should we consider alternatives,
>>       such as requiring userspace to mlock the I/O buffers before
>>       issuing the write to guarantee atomic copy in the page cache?
> 
> Right, I chose this approach because we only get to know about the short
> copy after it has actually happened in copy_folio_from_iter_atomic()
> and it seemed simpler to just not let the short copy happen. This is
> inspired from how dio pins the pages for DMA, just that we do it
> for a shorter time.
> 
> It does add slight complexity to the path but I'm not sure if it's complex
> enough to justify adding a hard requirement of having pages mlock'd.
> 

As databases like postgres have a buffer cache that they manage in userspace,
which is eventually used to do IO, I am wondering if they already do a mlock
or some other way to guarantee the buffer cache does not get reclaimed. That is
why I was thinking if we could make it a requirement. Of course, that also requires
checking if the range is mlocked in the iomap_write_iter path.

>>
>> - Page Cache Model vs. Filesystem CoW: The current RFC introduces a
>>   PG_atomic page flag to track dirty pages requiring atomic writeback.
>>   This faced pushback due to page flags being a scarce resource[7].
>>   Furthermore, it was argued that atomic model does not fit the buffered
>>   I/O model because data sitting in the page cache is vulnerable to
>>   modification before writeback occurs, and writeback does not preserve
>>   application ordering[8].
>>     -  Dave Chinner has proposed leveraging the filesystem's CoW path
>>        where we always allocate new blocks for the atomic write (forced
>>        CoW). If the hardware supports it (e.g., NVMe atomic limits), the
>>        filesystem can optimize the writeback to use REQ_ATOMIC in place,
>>        avoiding the CoW overhead while maintaining the architectural
>>        separation.
> 
> Right, this is what I'm doing in the new RFC where we maintain the
> mappings for atomic write in COW fork. This way we are able to utilize a
> lot of existing infrastructure, however it does add some complexity to
> ->iomap_begin() and ->writeback_range() callbacks of the FS. I believe
> it is a tradeoff since the general consesus was mostly to avoid adding
> too much complexity to iomap layer.
> 
> Another thing that came up is to consider using write through semantics 
> for buffered atomic writes, where we are able to transition page to
> writeback state immediately after the write and avoid any other users to
> modify the data till writeback completes. This might affect performance
> since we won't be able to batch similar atomic IOs but maybe
> applications like postgres would not mind this too much. If we go with
> this approach, we will be able to avoid worrying too much about other
> users changing atomic data underneath us. 
> 

Hmm, IIUC, postgres will write their dirty buffer cache by combining multiple DB
pages based on `io_combine_limit` (typically 128kb). So immediately writing them
might be ok as long as we don't remove those pages from the page cache like we do in
RWF_UNCACHED.


> An argument against this however is that it is user's responsibility to
> not do non atomic IO over an atomic range and this shall be considered a
> userspace usage error. This is similar to how there are ways users can
> tear a dio if they perform overlapping writes. [1]. 
> 
> That being said, I think these points are worth discussing and it would
> be helpful to have people from postgres around while discussing these
> semantics with the FS community members.
> 
> As for ordering of writes, I'm not sure if that is something that
> we should guarantee via the RWF_ATOMIC api. Ensuring ordering has mostly
> been the task of userspace via fsync() and friends.
> 

Agreed.

> 
> [1] https://lore.kernel.org/fstests/0af205d9-6093-4931-abe9-f236acae8d44@oracle.com/
> 
>>     - Discussion: While the CoW approach fits XFS and other CoW
>>       filesystems well, it presents challenges for filesystems like ext4
>>       which lack CoW capabilities for data. Should this be a filesystem
>>       specific feature?
> 
> I believe your question is if we should have a hard dependency on COW
> mappings for atomic writes. Currently, COW in atomic write context in
> XFS, is used for these 2 things:
> 
> 1. COW fork holds atomic write ranges.
> 
> This is not strictly a COW feature, just that we are repurposing the COW
> fork to hold our atomic ranges. Basically a way for writeback path to
> know that atomic write was done here.
> 
> COW fork is one way to do this but I believe every FS has a version of
> in memory extent trees where such ephemeral atomic write mappings can be
> held. The extent status cache is ext4's version of this, and can be used
> to manage the atomic write ranges. 
> 
> There is an alternate suggestion that came up from discussions with Ted
> and Darrick that we can instead use a generic side-car structure which
> holds atomic write ranges. FSes can populate these during atomic writes
> and query these in their writeback paths. 
> 
> This means for any FS operation (think truncate, falloc, mwrite, write
> ...) we would need to keep this structure in sync, which can become pretty
> complex pretty fast. I'm yet to implement this so not sure how it would
> look in practice though.
> 
> 2. COW feature as a whole enables software based atomic writes.
> 
> This is something that ext4 won't be able to support (right now), just
> like how we don't support software writes for dio.
> 
> I believe Baokun and Yi and working on a feature that can eventually
> enable COW writes in ext4 [2]. Till we have something like that, we
> would have to rely on hardware support.
> 
> Regardless, I don't think the ability to support or not support
> software atomic writes largely depends on the filesystem so I'm not
> sure how we can lift this up to a generic layer anyways.
> 
> [2] https://lore.kernel.org/linux-ext4/9666679c-c9f7-435c-8b67-c67c2f0c19ab@huawei.com/
> 

Thanks for the explanation. I am also planning to take a shot at the CoW approach. I would
be more than happy to review and test if you send a RFC in the meantime.

--
Pankaj


