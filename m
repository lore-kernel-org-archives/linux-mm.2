Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA049CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68386B0093; Fri,  5 Jun 2026 04:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40116B0095; Fri,  5 Jun 2026 04:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C706B0098; Fri,  5 Jun 2026 04:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7FA46B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:49:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6525E140B0E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:49:36 +0000 (UTC)
X-FDA: 84845235552.09.9EDD668
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 38CE3A0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:49:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qjZBmLwJ;
	spf=pass (imf15.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780649374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YOToXdxhhhdNK71DLVY4SYkIbODfD9tHfsxl+vivDR8=;
	b=Tfim/+3zFmMz2lUKxEOVZB9vX4Aq1iWpNmPr9y5adIyOc7yHaS+x2QdZthz4luKB6eeUFB
	Zf86nPcEWKGhK+E780M3IayslHFczTIqrypHGBGkQUuejzDomZzp2lMQABdDromsW6LwD3
	aMo90QLFierm03MLVD0rX6f+9ZyM8CA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780649374;
	b=ZKVskxdlITvOieg5Eyh5iUGG+qhh7PFdn2Euby4htwH99fQTxKwaB5+ET6U3pFS9OsOcUL
	wsg73AkR31REZ+6NOAm5MV0CCEVH5RLY/a3KC8nOhHq6Irdm8GyTWUYSqkyvhsVCrdTHgl
	FYWFyM1s41oyP0G1a4i+E9MJJMX3H6U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qjZBmLwJ;
	spf=pass (imf15.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <3de3a89b-92f0-4cd2-9f41-8e853eae4e78@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780649372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YOToXdxhhhdNK71DLVY4SYkIbODfD9tHfsxl+vivDR8=;
	b=qjZBmLwJgvsbuvq1fHyyIIcdo6WxEInJqqF3BNOBkvY1ArbkqE+G54aTWf86cZwwFBdXdn
	tr5j+DmrGHYFquCnV9slP+JnPAuV+Jgj5EuAXnT7DAck61kRPkW+plclGgVpgCzomSHQFO
	lsPlG9KHy3eJMYoD4IWUcfjiM2/d8MA=
Date: Fri, 5 Jun 2026 16:48:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/3] mm/percpu: Avoid IO/FS reclaim in backing
 allocations
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Uladzislau Rezki <urezki@gmail.com>,
 Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260604113101.89510-1-kaitao.cheng@linux.dev>
 <20260604113101.89510-4-kaitao.cheng@linux.dev>
 <20260604120709.445c027637b3ad72ad13279a@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260604120709.445c027637b3ad72ad13279a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38CE3A0005
X-Stat-Signature: rdyaaed6mp9swmqqy618rnmasmzngktk
X-HE-Tag: 1780649374-783927
X-HE-Meta: U2FsdGVkX18A/0y5ftKhQBjf0PIGkYhHZww5A1zsFn/nkl6e8jmCntISillRMEtHsD/oQPzg/H+H5BtRFw9OG0fScxfZ1ikHPVjXKOFfgP2O2NIf8dusKeZPy7Nd3Z7yQXHiFsjcsbrmRUl9tAw3bMUjA+iRV0kdv7Wx3yB+RTIjr1OqYwjZ/Eg/8A/OObV5/gjV/1V1OQEHTA/B39GYA8nmBnpTWn1NBXjBcLA3rAJoz9On2FIumBMxUYIjpvpt0h43+wq387OtO/54qfE5iFQdz+QvbMxuz85nDpNw6rrFtQuWz324K3W6gnGFS6Os/inNWtv2J/cg34ZOZKc9sATRj0XD6N2tiBq2V8EAGiY9QzrmFUNV/1sNcadtVvXQdDBfkpglg/H40ClQX1z4Y7bMUGuPBquP7O+H2eWUlpbl/RgTzQJOHjzLSAd3IRGJV6pcFa8ycIATvTz9kVbOfodIY8T8p6qFowy7ZFvdpdYk5/luRoL0Y0hxm+1HwCbGsvujiC6UG/Rx0dD0+kX9iKBAxp79oXeW2lsZMxYlE/Lh/lnZyqjPFG8MfFDuLRRapXWXXFElmRhGyZyTeHFHspxAWx87y48uFBUeN3oBWiNXgmuUE1EmM4sTJrYGqlKKsOaFbrHlfYiJvfzpECdInowznlzo/3Pau/PURNGCTu1EOKjsmvDyLp7giuy983PKZYvZmBtSSrcAwNp0Lv1wuKnI6k/lapJ7lvGxOzHt1nVCf2l0RkU3kquwYczHHaXNqG45EF+e1pWbYeCIk0sCgO04KgCSyHPeouRmDtyyID4Y61B6o+BY4YFnc+vuF9t9unt51iY5CM3Mqo67Dbptt9W8bRLF1oIVzOB8rb/UBMXSwvY92bfxdWsGdDYbn/iKIe3aWfuLrSq4hfENqeiK8ihXvItTjRExilD4ecBy0OTTkD/gJ9WqEOhTn/MRMMLa0EDgOa2Tk+DawjU0jVv
 GC8V/ZvP
 vH50dflvxbJyPu7g8AR3t1cQQ3S8qkQ2JkLFtEBeFZb6ea2JAob041fXMtlgtUwnpOVXRI5g8/yoZ4u1mZRRfCtxbzFZJSaUeNcMooZfG289KpKJgX3cV5tSb1YgWPuS32Wph+gPgm1oGaSMn4SAbI6rVFCbJ8hkdQ9V6C3K4eTR8oey8J88SugOqHsJBYc8nBKNPiYiES52oV1+Aw3P9LjiL45eIQpE1yRDJ1V4g7PUDvaj48zheRRn+K1Etn0x9QMuewGlFBJVAHoFBLA/TYXQzvX4XCM2AbbISlaVscuABWr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/6/5 03:07, Andrew Morton 写道:
> On Thu,  4 Jun 2026 19:31:01 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable
>> allocations atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu
>> allocations to take pcpu_alloc_mutex.  This avoids premature allocation
>> failures, but it also makes the mutex visible to callers from constrained
>> IO/FS contexts.
>>
>> Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
>> pcpu_alloc_mutex. Since the internal allocation is not constrained by
>> NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
>> creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock
>>
>> At the same time, Thread B may already hold an FS lock and then call
>> pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
>> pcpu_alloc_mutex and block, creating the reverse dependency:
>> FS lock -> pcpu_alloc_mutex
>>
>> This can still form a potential deadlock cycle.
>>
>> Avoid the dependency by restricting percpu backing allocations to GFP_NOIO.
>> The public allocation still uses the caller's GFP context to decide whether
>> it may block, but the internal memory allocations performed while
>> pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.
>>
>> ...
>>
>> --- a/mm/percpu.c
>> +++ b/mm/percpu.c
>> @@ -1726,9 +1726,8 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
>>   * @gfp: allocation flags
>>   *
>>   * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
>> - * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
>> - * then no warning will be triggered on invalid or failed allocation
>> - * requests.
>> + * allow blocking, the allocation is atomic. If @gfp has __GFP_NOWARN then no
>> + * warning will be triggered on invalid or failed allocation requests.
>>   *
>>   * RETURNS:
>>   * Percpu pointer to the allocated area on success, NULL on failure.
>> @@ -1749,8 +1748,14 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>>  	size_t bits, bit_align;
>>  
>>  	gfp = current_gfp_context(gfp);
>> -	/* whitelisted flags that can be passed to the backing allocators */
>> -	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
>> +	/*
>> +	 * Whitelisted flags that can be passed to the backing allocators.
> 
> We're supposed to say "allowlist".
> 
>> +	 * Backing allocations under pcpu_alloc_mutex must not recurse into
>> +	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
>> +	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
>> +	 * waits for the same mutex.
>> +	 */
>> +	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
> 
> AI review
> (https://sashiko.dev/#/patchset/20260604113101.89510-1-kaitao.cheng@linux.dev)
> asked why we're currently removing __GFP_NOFAIL here.  There are
> probably good reasons for this, but it would be good to describe them
> in that comment.
> 

This behavior has been present since commit 554fef1c39ee
("percpu: allow select gfp to be passed to underlying allocators"),
which introduced the whitelist for GFP flags passed down to the backing
allocators.

I did a quick AI-assisted scan of the current tree and did not find any
in-tree caller passing __GFP_NOFAIL to pcpu_alloc_noprof() or its
wrappers. So the issue Sashiko described does not appear to be reachable
with current callers.

That said, I agree the semantics are somewhat incomplete: __GFP_NOFAIL
is handled when taking pcpu_alloc_mutex, but it is not propagated through
pcpu_gfp to the backing allocations. If we want to address this
defensively, I think it would be better as a separate patch. Even though it
touches the same line, it fixes a different issue from this change.

-- 
Thanks
Kaitao Cheng


