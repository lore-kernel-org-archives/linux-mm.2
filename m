Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FEBC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE08B6B008C; Thu, 10 Sep 2026 06:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91A16B0095; Thu, 10 Sep 2026 06:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA74D6B0096; Thu, 10 Sep 2026 06:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EEF96B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:11:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 227B316049D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:11:59 +0000 (UTC)
X-FDA: 85197436758.29.E8FBAE7
Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CAB11C000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:11:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bvG1tSfP;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789035117;
	b=2PG6fTA2mp6EQx0/UufJBEQgqHoYA8jRcMzsguX9bCbtkaJgwmChBJd4QFX3VCTJ9saI05
	oENfr4G7cjHILks4vsDFp26mL9FKVlRjuiQN9x5pZbTVpHP6tfQrks795J3duMR7092Uiz
	LoE/lxVZjoiMW+mnVsEZGgxqvLhzZvI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bvG1tSfP;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789035117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=km7EzEbOE3IKmoq5ThQMkHl9qeCnR9DnuHBJn0xWVUk=;
	b=yNJstM2OCk7Mxk6KXsdggvzZJFgR4d3T3x9lKpr9o4VBzobO7J0ARNKfhqiahXOETx5doa
	n2eVgAhZ6E6lKPD34Ff8u/9GmtDXwtBNZ+eE2rL4vAxpMDDht+ZvLSJglMbPpc3kz9fML7
	jo4EhUNHNULMXkzSkeBNIsitabrXd7Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+YiOtMV9LtHLD/hVdNynO6GNFamQnmcFiMsxau6m56I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789035112; v=1; x=1789639912;
 b=bvG1tSfPqXZ/HsMTLiJbbg+qVuiO+f6K+Z6kWsto6B1gKoiLFjB0LxF2pOb2Bym3KHGQk0Pl
 d8sl+ZW0d8T0x5P7G9EmAiQVdKE+aJtQYIRfiOccOvbkPQkdQC9NBBzrXrtwbLO3uK9xZRtM6P6
 b55gx6oZJmYcpbrhlcLyXHxg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 20c1762f2feea230;
	Thu, 10 Sep 2026 10:11:52 +0000
X-Mizu-Trace-ID: 20c1762f2feea230
X-Migadu-Flow: FLOW_OUT
Message-ID: <7975ef1f-8d2d-4be3-b206-7c6326bed2db@linux.dev>
Date: Thu, 10 Sep 2026 11:11:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: zswap: don't fail a large-folio swapin whose range is
 not in zswap
To: Andrew Morton <akpm@linux-foundation.org>
Cc: yosry@kernel.org, chengming.zhou@linux.dev, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com,
 kernel-team@meta.com, stable@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>
References: <20260907161938.1932355-1-usama.arif@linux.dev>
 <20260909194712.706fb2e87a6e59097424c31d@linux-foundation.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260909194712.706fb2e87a6e59097424c31d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4CAB11C000B
X-Stat-Signature: jp7febqezsb3z86psuaubuxdugtzuunc
X-HE-Tag: 1789035115-397612
X-HE-Meta: U2FsdGVkX18Y0cIXY3KXpuKc63LUGhhbqskraYNU1LdHdX+qUcsoKitSQSKrLKg5Hy4iJu+ZqQqx83HhAlcImWJGS3qFfTywB4Owkx4nEvY4Mjl/qPPXZcfAZJUcN2OC+bCOvDLKxtJABLVS6EsIBvyGgFVAw9LZ0KZwiZlEFWpfI9iTfOMcXLSN6ROaVxwOCLwfvLnW3injI9IZe+0eF0n/dUlYhAleMy8LwuEJdPNy80LumEemX5bb4WkeiHwQmIYxCmmmtgNWjK3/te22/EVOWslwuBtCXGJ1/Xa6jPuIPEsK3tdB5kZdZMQLRE8iftw6pNXljappVF1jsCVeTMgHpSDY/uGe0u8Eg9Hnz2zwwhMUB6w7OggWJLla6CEjSARr1tR4LmdVM3BfUEKqi+gIi/eMRfOeE/D4bTk/OcqIdWMFjzKvr1qH8TWNP4F2pLYaWRj4gGckZNh5u+nbyzdJo4N2/m0/0+SIELQr2STMKfU2Zt1Qh3jhzvn0F1PsHVhQqrvGzVG3peyENNnSfy7ukh7zwXZTXd4y/yngUX+rOA0upXb5RKaWOMllrYvorrFEEVfBz1oJ0HeIarmi1YykupOu4MNDC6+2L00xdpVEUbrvSio6s8hT+GL2+xgoFArCxE/FHvR3Hd7KBmxDT7Ab5HL0e26sR2cxmjDkRcRQe1Qvsjhaz9cTGJT9zbRtg0t2muSCbm7YH2/+XVsmE5rKbm8WIKrg2fgRKhMqW9BSyOCmHpjbqTMVXL0cjF+gPgkibPyfXhUqoZFwpIeOXsTjacU9VbKgQ3vH1PLrwLwrEpMFZe45AbK7OB7503zYCaz8CLABpULJWAAHP8TiNr2s7iuatGorUFrTnZGyGWG+kYGl9E72nB35SSUfrLzIMj1nGfA2fuw06tsOKeuytK9Nu6AnvIPbsBP0+/JG7cuglMoArgc3xtGFqi3VVY6H/SUarldxGGaiYzhr3kj
 UdhFuv44
 uQkpIoBZLWX1hKivNEl3zp3GaGSaPrKDMIhR1elJrceY1Eu5RtJGFi9bS+3H9YJItIYzQat7rLE1gg6G3Fnj7SNKJXgxR7nB6oxK5Dh4qffRxEhwibE/6asqaeIdyQAerf2Oi0hfsz0LPpu6/+6HB4O1+WGlekrXB3v+7erVF2klcKXBKtiBV/D9b1xAywpDcUYHU0j95ha1pAMY3uPSfra5aX/5YATQHXixZcH0SCApVVRRbbMPfInTT7OsUO+k7+ooxfXwHnPoX9WXVI5vJiRiu3ftuFvm+m/NtomxE7Nw9oFjoWTHYBBbxSdTcjiA0qcvXvFjFt6xQr7PUif0sp7j6Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/09/2026 03:47, Andrew Morton wrote:
> On Mon,  7 Sep 2026 09:19:38 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> thp_swapin_suitable_orders() and shmem_swap_alloc_folio() sample
>> zswap_never_enabled() to decide whether a swapin may use a large folio.
>> zswap_load() samples the same one-way static key again once the read
>> reaches it.  Nothing serialises the two reads, and in between the task
>> allocates and pins a high-order folio, which can sleep.
>>
>> If zswap is enabled for the first time in that window, a large folio that
>> was correctly permitted reaches zswap_load(), which rejects every large
>> folio with -EINVAL.  swap_read_folio() treats anything other than -ENOENT
>> as "zswap handled it" and skips the backing-device read, so the folio
>> comes back unlocked and not uptodate: SIGBUS for an anonymous fault, -EIO
>> for shmem.  The data is intact on the swap device - it was written there
>> before zswap was ever enabled - and the not-uptodate folio stays in the
>> swap cache, so every retry of the fault fails the same way.  With
>> panic_on_warn the WARN takes the machine down rather than the task.
>>
>> Scan the range instead of rejecting the folio.  The caller has pinned
>> every slot before issuing the read, so zswap cannot start a store or a
>> writeback into the range and the scan is stable.  If nothing in the range
>> is in zswap it is all on the backing device: return -ENOENT and let
>> swap_read_folio() read it.
>>
>> A range that does have a slot in zswap is still refused, because zswap
>> stores large folios as order-0 entries and cannot reconstruct one.  That
>> stays reachable - a slot shared with another task can be stored inside
>> the same window - and refusing is correct, since the alternative is
>> returning the stale device copy.  Report it as -EIO rather than -EINVAL:
>> the request is valid, zswap just cannot serve it.  The only caller
>> distinguishes -ENOENT from everything else, so that part is a
>> documentation fix.
> 
> So to hit this bug the user needs to enable zswap system-wide during a
> teeny race window in the swapin code?
> 
> I suspect nobody has ever hit this and couldn't do so if they tried?


Yes, I think it would be very very difficult to hit this.

It was part of my PMD swap series, where its actually needed for the feature.

I think we can drop cc:stable, unless you think its needed Yosry?
> 
>> Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
>> Cc: stable@vger.kernel.org
> 
> 
> Documentation/process/stable-kernel-rules.rst, with which I agree:
> 
> Rules on what kind of patches are accepted, and which ones are not, into the
> "-stable" tree:
> 
> - It or an equivalent fix must already exist in Linux mainline (upstream).
> - It must be obviously correct and tested.
> - It cannot be bigger than 100 lines, with context.
> - It must follow the
>   :ref:`Documentation/process/submitting-patches.rst <submittingpatches>`
>   rules.
> - It must either fix a real bug that bothers people or just add a device ID.
>   To elaborate on the former:
> 
>   - It fixes a problem like an oops, a hang, data corruption, a real security
>     issue, a hardware quirk, a build error (but not for things marked
>     CONFIG_BROKEN), or some "oh, that's not good" issue.
>   - Serious issues as reported by a user of a distribution kernel may also
>     be considered if they fix a notable performance or interactivity issue.
>     As these fixes are not as obvious and have a higher risk of a subtle
>     regression they should only be submitted by a distribution kernel
>     maintainer and include an addendum linking to a bugzilla entry if it
>     exists and additional information on the user-visible impact.
>   - No "This could be a problem..." type of things like a "theoretical race
>     condition", unless an explanation of how the bug can be exploited is also
>     provided.
>   - No "trivial" fixes without benefit for users (spelling changes, whitespace
>     cleanups, etc).
> 
> 
> If this patch meets the above then its changelog needs an update!


