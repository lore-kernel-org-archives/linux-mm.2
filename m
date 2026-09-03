Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13CC6C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2736B00BE; Thu,  3 Sep 2026 02:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5C0F6B00BF; Thu,  3 Sep 2026 02:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23E06B00C0; Thu,  3 Sep 2026 02:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9515F6B00BE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:29:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24ADF12029B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:29:37 +0000 (UTC)
X-FDA: 85171474794.30.AC19E04
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	by imf18.hostedemail.com (Postfix) with ESMTP id 167911C0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:29:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tK8UWHJ7;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788416975;
	b=Ch56MzYIDnJ3ZtuvhWZJF0yHU2VO2V4Cg96eF6L8dqcJkUFKeHCh/Rf/ypT5n8Q41Ps6Ap
	kNJd76yX2OQG7RulZL74e6GOoRD66t2OIyxtc3xwVieMIzPJNGYnzinNhgMUvYUfyD+aEK
	Og6gxI/1+TF8nLp+tWcheSram+9brzQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tK8UWHJ7;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788416975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SG85zpAlWWWxNO0nM/VcfjPJXblZwQfOMQLUui6AIa0=;
	b=juSjmcWd3VR7z+x2rjsFB7jSVapV+jTRV7W6pXLE156hPQX+AwonLtLz8npc77wicfg9uo
	VXj0bEeDB5y3fweGR5jVNWbhiqBp6eG2v0VazwxsXp5vVM4vhzIMWG82qtwpoh+2bb/j1E
	e8izyUVgeFGCCSm4hwkDH+W0l5Fy+LU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=w8ONuXQbe+L8t9TFC6e++AV1NKpgPqVNbxHf6dsgfC4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788416967; v=1; x=1789021767;
 b=tK8UWHJ7Iy4ieHvUcQVd3TPPmhTbyDfWQMFoyzC0eoTzdPGXp+csW9SnqOFY9xujORDI6Fyb
 JVwhAG1+gLKYk+SpAZjXG1HWcXSRVkqqjugKiGNKU4+CyYb6r74bCGIocEHbKvzAA2Wf3Fpd31I
 JgIPastXj5Nbn6xLuKebxFpg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1d69a6012f25cc1f;
	Thu, 03 Sep 2026 06:29:17 +0000
X-Mizu-Trace-ID: 1d69a6012f25cc1f
X-Migadu-Flow: FLOW_OUT
Message-ID: <336b56b2-6a00-4153-8c0f-19272bcea383@linux.dev>
Date: Thu, 3 Sep 2026 14:30:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/4] alloc_tag and module codetag section fixes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, Suren Baghdasaryan <surenb@google.com>,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260902081802.146145-1-hao.ge@linux.dev>
 <20260902150501.d589742ba33d0beeb0cdb21f@linux-foundation.org>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260902150501.d589742ba33d0beeb0cdb21f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ek4xwqt8869ujnsor5iii5gmpd6qef93
X-Rspamd-Queue-Id: 167911C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788416974-164342
X-HE-Meta: U2FsdGVkX1/d2my6n1P0cHwp3Z+qrorcJTwxRisHs0N4R69jWRl+kCf6QzLMfGZM/N+ylEl0MIz/GK58+9e1IZcXuKeSLPMjmqKqDj1lDWNayJ2ydeHVowXQUIrcUBzlgck5ioHbOSRw1GmGliYBH8fu/yRhOuqU/UDuOH0gk+ys6bQDRJ8EKI87ZdRW52PsrlhbuiHK7lewx50fc4gHO9idUvK6v09IJpiBfZPDKzCFSO3O7L2WfE3nO8KdfY3EMH38Bg2UcaniAngu515/nqBX6Q/9maXawasvJkh0k9x9aoNaC8A6g++BHVHPpQciz+t+5vW9QRDsjgNnwssHWgK8wcrwtvxdzSEUGwM52OzuKXGTjkabhqmVlfrZdTsFXhrMqhyB0OWRXS5x/EU/N/UGVQSKMPUx+lQihniSzRzc31wxlKxmITvFcGaQ/YsGgYXoO/r6N+YxqKNeo5OYeoXJCt1/8msOuBO6XqsSj+2JTes9SB+Xn+IHbRtBIL3GO3Cjt6qLSR0L0Gh/qDWjrYRrkaW9am3jfUV32mWeaTwMcx7N9ayMCtvc/kTK3iTDMNBWyAriYdDNX3vnyO0oQ+8zroGaa6AhcrSd0vhe4ZB2FkI777nsxBuJAZXDdBhHPyrE+gKJEtyCzodyg9EHjpkDIwzrLNg32nGrjXwWkuxbBU/VbG+ypBkYQ4fVXqa/yThtdPjgCQgOD3XrnMfTKUAGZi8/PuOgdP4Zd1ci8Cxmwr0O6l4taTT6f78v3zvOa9oTbJ6A7f5Nn/Y7a2EMcoThVIPXkoOB5rc7Q/vtNpToW2n1bcdySdEbJN6huWzsmrRtpBCrFq7u8MtiITwxLAceTeGvt3aRDoKZsiEFgiVNwUcrzcOp7MppVouh597v5YbqmKdXijMPfXf9Hwhbal5mbcJttLGSfQ+8QXN5h6TdKN++L75cfYnX1NBagKTNDtMHL1bGWLMbYztlcCk
 XTZH2V/8
 5/7SNmERFImATlIVnjwiTDgtYrL6akgT37Y0MjVF1m5eZgg5r8juDYsWIXJpprsEXjCnDt7HHUe3iaXZD3dR5mqgXuW0jRIcjbWu8NPbJB+pC4fyQzwIGuZvRNsoMKzSqE2ritfYnNHcA+6+zKlVrbSF+p9Y23OMHTvcRAa+xxuuUf/+lNM2OnW4JHw50jntKk5t+5+xhe0FgFH8CXHFZqDGqqxaMxng0ZskGxjAKQCTGLWsdIKGZ/DF939xXuAlHcKf7/WGSPL5EpD3nfgDY4l+e57eObxzrJTkW4dFv2GBXPBTT6FouR8Aoh6aob51IP3K8q+Ujn0kIMODuDnR6FElC11xoVm1Jf22DFWfuCdezonFME71fS8VB44aYB8TK4LtWt982wrBWIA4nMDMye3CANg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew


On 2026/9/3 06:05, Andrew Morton wrote:
> On Wed,  2 Sep 2026 16:17:58 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> 
>> I ran into an overflow problem in the module tag area. With profiling
>> toggled off, the overflow check in reserve_module_tags() did not
>> run, a module could load with more tags than the page flags can
>> address, and re-enabling profiling then silently corrupted
>> /proc/allocinfo. On overflow the fix shuts profiling down, releases
>> the reservation and returns -EAGAIN, and the codetag section lands
>> as regular module data in the same load, so the module loads without
>> profiling.
>>
>> Review of the earlier series by Sashiko turned up two more problems.
> 
> Thanks.  Sashiko had a lot more to say, as I assume you've seen:
> 	https://sashiko.dev/#/patchset/20260902081802.146145-1-hao.ge@linux.dev
> 

Thanks.

Initially I was confused why Sashiko didn't review this patch on top of mm‑new.
Some of the issues Sashiko reported have already been fixed in mm‑new.
I checked my old reviews and saw other mm‑module patches were using mm‑new.
That makes me wonder if cross‑module changes follow a different baseline.

No big deal, Sashiko did find two valid problems.

> Also, "Based-on-a-patch-by:" isn't a recognized thing, although it's
> been used ~30 times in the past.
> 
> I'm ambivalent about ad-hoc invention of new tags, although it happens
> a lot.  Perhaps it would be better to do
> 
> 
> 	Based on a patch by Petr Pavlu [1].
> 	...
> 	Link: ... [1]
> 
> ?
OK, will do for the next version.

Thanks
Best Regards
Hao

