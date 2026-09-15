Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCBD3C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21C36B0088; Mon, 14 Sep 2026 22:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2356B008C; Mon, 14 Sep 2026 22:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8C76B0093; Mon, 14 Sep 2026 22:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A44A6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:49:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0EDBA02E7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:49:41 +0000 (UTC)
X-FDA: 85214466162.19.E8D78B4
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E9CA18000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:49:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kDF34Nw8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789440579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zaV0SpzInG7kvQq5azykt5f4k7FtKQ2lMtdYarHFdFY=;
	b=fK3raGQ/Z55fqEL1yu5UpQXrKLjUb9BnwiOfXi34o6drP57LcxvyzVhBHL/MAyPUOrKwOF
	wZH/kimXRoZx1FQ5Vv1VMsfMD6zW8IAkx/FjmihzQPi7cjBV7B4FtOWxef5psIPyJz1NFC
	KoqVSBlTGOFpqCANo6vv+HjZWt8StKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789440579;
	b=oU1Pjzwb/IfOYGAV8PJ53E/tnJ1FLE+XL2VKgLzgUGMUNMnrQgAR5E9ZvbeYyrEk2vq2jE
	tQkiGp8h8krXfDYPVtSw9X/ITmgLUA8r2XiyRqKTT62Pf9gEmVH/2g7JLvWhPolRioUl9T
	hoxwi9zyL5o4Hgfx6v0ly6WBq+REXNE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kDF34Nw8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TPiaJesIqJ7PplIki0xusz3BjPaCRWubAMyDMo7M0qc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789440578; v=1; x=1790045378;
 b=kDF34Nw8gQf1kDIs7+rmXJ+V3Sh/evMeGoxvhaqFrdIJROatbIoFXvIn1Uj5VMEF70+avUvk
 4PYE90JDZBKmIpTf+rfvxemh9p42qmsIJaSUMuVkB2WVK+uV6t8pn/8DEODso2U2GkPgYcrMfeG
 3InQCZrSKFISU394+esk94Z4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 658701ff1c90a0b0;
	Tue, 15 Sep 2026 02:49:38 +0000
X-Mizu-Trace-ID: 658701ff1c90a0b0
X-Migadu-Flow: FLOW_OUT
Message-ID: <af33dfe1-04ef-4bfd-8c79-0593b24c6bdb@linux.dev>
Date: Tue, 15 Sep 2026 10:50:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] alloc_tag: fix a leak and a deadlock around
 shutdown_mem_profiling()
From: Hao Ge <hao.ge@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260817062726.106511-1-hao.ge@linux.dev>
 <20260826203914.347c42aa00081ee9e0eb858a@linux-foundation.org>
 <afa606df-3d5b-47c2-9972-f3e0c2e13c12@linux.dev>
Content-Language: en-US
In-Reply-To: <afa606df-3d5b-47c2-9972-f3e0c2e13c12@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E9CA18000D
X-Stat-Signature: ik1faapkm7ir7ji31paenhkissbawdsk
X-HE-Tag: 1789440579-379769
X-HE-Meta: U2FsdGVkX19akWoNGhpHeBi8PQmJFxZubePoSNR6s5bAeiDdBIYQcImNHXPcp/Nlhl1Q0RJmNy2gE4KB6v4ID4y5sJfrYZ6dMwyE6xx+yMATSeU8U/0RBNsG//ogCD14CM4Cd+oOxG63LzCFcet80VzxOuh8/YlBORF9SYL98+C1vBY2N8WQbY5+pVby5/y/LSRhA3Udk68vCs/GnYkz7Mq7TvMLCrOEaKRmmQkjlTl+vDNyDdUxQDjvPJN3u6kWTcB4xmlhJu3PJuVOLay4nJ3LV1bAc3Ml+ET884Aeuie3TUSaBnaYg73pIer1QyZmk8Y64/i2RZ+G+KSicpzdOc7rzMHBgjM6FCeuERpwiWcJWfX6edmfUlaprP6JxcPtnGknKz4s3GsQFPPufbK1i8xd/4DfO73Fi4GaaZsvpqguPTmncZgBjpwfy4Pg3KN9VJB3/6F0mU7ebcFBzQNV1/u+J1LaVYOS5O7v6EcyzYXC+EUWlzcpIHTIhWLNVc7NnWmA0MUTeV1Dk9t9rr0n2YMRQDOc/ppM2CSFKiUMFPWY6FLtulVWZNVSMD9W8uZpF32ZSgY+VMAEnDBmTzZagTmxs+5T0j9tJjpo7TJatxpXn6WM8ahmYwibWgnpx3D9oWRu+FpAlb8aetfBq6FYJdSlznI7TWpXB55UvJBNrS+8xpdnJXYO2xSBc87+ItOpZI19Z6QnliRBLNBdcw+ytSVx6KY4m3l+THz9Hgd5socn8SuY8arLQGBAuHgAlMyk6W5lHqCEc4YePdz2+KADZeOSOiV2L5Esqw+O8mLVZB+MvDf14WR6tnlPaojQCN2X2xOs+s/zbfqRjeu9e279dDgBgT8/zFru855RMMMO2DujT77BQvdju4e64vJM2IOVGPRD8DOr2EiboPUkpzsmqMEjE1F3V1yuFQV6P0+4XfyKzR1/5W7K0lzTuJ7D/yKLZdgo3PpotO5Rzt3owvk
 4JG/g2nV
 1kIm1JvMUFSJfkfpldKbupck3MLIRikbw7ko+7NF1eZt1LJJ/mU5cli9dAAzVUVtAd38fYBWcnuC9iCu7elvo91J283qoZRh1MT2nF2+qE5FWHL7Z5N7omd2SUHqQpj2CgL9abQe+qki9HIrkZaAHOSVDOvaZAt7DtBLfy6pmfcPW9AEcCj6mk+lWv+v2cLQr31BMIjgyFjnLlXrZV7NzsbjLcwrhFMHtJcGPS+4aPK9XD7ffNHSpKHpK6iWiBWaHyic/alA77AVBAHUoEY+VdGIwfv4DWzITnr6dYYqeUT6e0ZzJAlDVJ/SsaJkxvgtWeMEC7j8OI81e/+WKNJC0OYPfFO8XkUvdX16Q69ghnupijobvmz92/MAgU7ZygsNS94zs/+7bRyUj27qDih6p6dEbVdXnqqx7VlitZX+4E19lDt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren and Andrew


Update the status of this issue surfaced by Sashiko.


On 2026/8/28 11:11, Hao Ge wrote:
> Hi Andrew
> 
> On 2026/8/27 11:39, Andrew Morton wrote:
>> On Mon, 17 Aug 2026 14:27:24 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>>
>>> Two fixes for issues reported by sashiko:
>>>
>>>   1. percpu counter leak on modules loaded after profiling is disabled.
>>>   2. AB-BA deadlock between module load and /proc/allocinfo readers.
>>>
>>
>> Thanks.  AI review asked two questions.  One pertinent to your
>> alterations and one pertinent to Suren ;)
>>
>> 	https://sashiko.dev/#/patchset/20260817062726.106511-1-hao.ge@linux.dev
>>
>> I'll queue the patchset for 7.3-rc1, with a note-to-self.
> 
> Thanks for the heads up on the sashiko review questions.
> 
> The question on patch 1 (codetag_load_module() error handling)
> has two parts.
> 
> The lost error code issue is already fixed; I sent the patch and
> you queued it. (Thanks).
> 
> For the rollback part:
> 
> I've also seen Sashiko flag this same issue on another of my patches.
> At the moment this case can't actually happen, alloc_tag is our only
> registered codetag type, and codetag_module_init() cleans up its cmod
> from the idr on every failure path, so nothing gets left behind.
> 
> That said, if we ever add a second codetag type down the line, the problem
> Sashiko spotted will become real. I will follow up later to refine this
> logic and make it more robust.
> 

Daniel also raised this issue
https://lore.kernel.org/all/675259f9-c093-439c-a411-1937b23ddaa2@linux.dev/

I do have the relevant fix ready locally. I plan to hold off on the next batch
until we close out this recent chain of fixes. I'll bother you all again when the
time comes.

> The question on patch 2 (async /proc/allocinfo removal racing with
> alloc_tag_init() failure):
> 
> When I first read it, I think the window is unreachable. It requires
> alloc_tag_init() to fail after proc_create() succeeded, and a process
> to open and read /proc/allocinfo in the gap between schedule_work()
> and the work running on system_wq.
> 
> But CONFIG_MEM_ALLOC_PROFILING is a bool, so when enabled alloc_tag is
> always built in and it cannot be a loadable module. Its module_init(alloc_tag_init)
> runs inside do_initcalls(), before /init is exec'd. Failures inside
> alloc_tag_init() are already very unlikely to happen. When the failure
> happens, no normal userspace exists yet.
> 
> That said, I realised the fix would actually be quite simple, we could just
> move proc_create() to the end of alloc_tag_init().
> I am not entirely sure whether we should do this though.
> 
> Suren, what is your opinion?
>

I've been thinking about this quite a bit lately. Defensive programming
is always welcome — there might be edge cases I haven't considered,
or scenarios that could trigger this down the line.
Furthermore, if alloc_tag initialization fails, the corresponding sysctl
entry serves little purpose.

Besides, I've decided to fold these two patches into this series:
https://lore.kernel.org/all/20260908092412.115953-1-hao.ge@linux.dev/

This is because Sashiko keeps flagging this percpu leak.
https://lore.kernel.org/all/20260908094736.2B1A61F00A3A@smtp.kernel.org/
And patch 1 addresses exactly this issue.

We'll fold these two patches into that series and let Sashiko run another
round of review.

Please kindly help review the folded V10 version.

Thanks
Best Regards
Hao

> Thanks
> Best Regards
> Hao
> 

