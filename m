Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6A6CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 22:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34F46B0404; Fri, 15 Aug 2025 18:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABEC16B0405; Fri, 15 Aug 2025 18:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ADAE6B0406; Fri, 15 Aug 2025 18:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84A816B0404
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:21:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E0871401A3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:21:43 +0000 (UTC)
X-FDA: 83780414886.13.0B00480
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 44950160004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:21:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=otoMbQN3;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755296501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgYtSz7R5teKnHMH10nhKu0C+pGzCAV4oleJjtCiZtI=;
	b=6bx6lvYFjzZjPN/CSMmAeHe57E1twFg/vcwY9NI3U+Dp6UcDUhMsbocZMxjxAtpvXD6z26
	OjiHYjOctWxNDxz/+GqYXCu4H8W+9kM3jD4JAa2sAmJ8W8vCXoWfVzvpFVLgpLzgXcnCGn
	PIxGEs8pNZLY0vSgz8z9cPXhfuijSB0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=otoMbQN3;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755296501; a=rsa-sha256;
	cv=none;
	b=I68XOECFXByap+gZYIFZZNfYsJ42+2PU9Srs22QxGEnm1KVmXIV598zomCzQQ9uJWZ2b9p
	fv8qDYfx+yMRZjZ9SMKcbSvv4wU56SlowjTzPxDfZy7I3KyoDWOJu3Ub6M7MIQsRZK6gYA
	a3IoStgspnaex1CHlkWWyOzbhimoNR8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755296499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rgYtSz7R5teKnHMH10nhKu0C+pGzCAV4oleJjtCiZtI=;
	b=otoMbQN3GkVTU0l/Rh3ZMBeC1r1PX/FjhMh9v/jmTvz7zJkTG+nf02A3nyaSN3V526/+f+
	6fSHjQqp7Qi6g+uNEhTUBDjxZOFxIbwdL0bYSmJUS8sD8wp19zOsANFntwx1bbUJ5o2zJ4
	v6k+sHg3pk3N+F6igLB4JuAc1xtJwb4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  "linux-mm@kvack.org"
 <linux-mm@kvack.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: Regression caused by commit 4687fdbb805a ("mm/filemap: Support
 VM_HUGEPAGE for file mappings")
In-Reply-To: <87plcwdyjs.fsf@linux.dev> (Roman Gushchin's message of "Fri, 15
	Aug 2025 15:12:39 -0700")
References: <87plcw8lyq.fsf@linux.dev> <aJ-gGXNwOMeLBs0W@casper.infradead.org>
	<87plcwdyjs.fsf@linux.dev>
Date: Fri, 15 Aug 2025 15:21:35 -0700
Message-ID: <87bjogdy4w.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44950160004
X-Stat-Signature: 4gimrgiqqiaz89m8ysmt8gpornqts86e
X-Rspam-User: 
X-HE-Tag: 1755296501-591180
X-HE-Meta: U2FsdGVkX1+XCE5RCixyb8Lff27FLiMxOCp8oW9byMSMq5vKYlD04qTusQIXJvb8Os1XJTNy+G/VmQ5TfntGM75ayuZqdmMDG8Q+5O2BeyzDVSknTtoDzWVPvprIAyhnAgwQW6aE7vEHgZNCAn7ZYoE2mEK1tXJvwi9jxgfmO547nSIClv4sQ08Ncm6uKsWr18EqvKbRaUTfInORxeVfM+5f9HDSGXKfbmzdSBFh5eEJInKGP1IyyWDittgmRO2BB0sfC50RG8KvSlHWAuAGjW09eOR75kZGgGlmoaFzLNnz/G2Z+cwjMZpnhf4CD9DWoO6D9CEo4KImpH2rDNGHkqhl2cT3gBfqsB6CUTE8RKox/ieXyQJFP6Cgrp2hVrTJfsreUZQxgViglwtVx3pXdlVocrPbixOnlJ8m6MPC4CtueFavab4WQS8dswky+IjZidOXW3txsFIVIjI8CXr52UXtkhosVUE7xfgDdrqrJ8MwUHNHhQeqLpQH/91fHJba8CBvYuiQKJRvlmlr6sGknt7IZbO6oIxEyPfLH943oAAtFkQ8NiE2QPIAAoTW5P59LTmgSLV35cS1aH+FdR/ddP8twzuhyaMnpBvGxiS3XLLv15IUCRGfCkCoRY16o7V7y93rKI/XkU2Ca+vzo1UMSSz8otydswNOaAS2509NP+5lmlwRvK41WrJ7Nq+6831xIt2ktDss6rXncqPEaxkawgDZkAmdO8eV0/cAK/Tqa2uwWQ5SBx2IwH58bVArMdINMMBiSTCvEEJ8V/Q/Wv4JuFPjgWrcFMCE2LOzZMFVaH5fnBHJ5rlgxBn1RUmJqfTFhOCUHzUqCDJ6lgoHF7HjpdetVxYTOzxdJ9JptMAXe8VBeWz+z1+UO6oiAIGCoBjlziqRFjOkLlu6ATs0mGHzQpzGEPfCT1W6yd+ZL5tdMN6yU2UdlJ1SCzw7Tmzev6ZsrzlVU0qdspkFMBqmXqB
 UUnUe7vJ
 YJmYzWp4atuN19nW5GnxOQ89FggD7hX6KuOWkIsaKAJjz3FDxzJmhL4DcfJDb2SMzHq7nx0PxsV/d+QLp2Ee/uhWH7mrgKFTDWid6QVbm5Yq1s7Qk1/v3g7dwhVsHtL62+2sf9VYIsuOHctsNI9VGEeHl5U/d17kgIoZmc9dIQilvkdKiEEOLOyBLdwkqjZPN0G+yq85ShSqbaHAATFzS81HEieoSwXm//wdkapeok2bX/FN6lg/DHX+FZ4TY2QjqBDRoL5woCMi44Ptk6UVLmR+jIAXQFh7Zg1HL6l6Isghg9xy2PpYJX60wCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Roman Gushchin <roman.gushchin@linux.dev> writes:

> Matthew Wilcox <willy@infradead.org> writes:
>
>> On Fri, Aug 15, 2025 at 11:43:25AM -0700, Roman Gushchin wrote:
>>> The commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file
>>> mappings") causes a regression in our production for containers
>>> which are running short on memory. In some cases they are getting
>>> stuck for hours in a vicious reclaim cycle. Reverting this commit
>>> fixes the problem.
>>> 
>>> As I understand, the intention of the commit is to allocate large folios
>>> whenever possible, and the idea is to ignore device-specific readahead
>>> settings and the mmap_miss logic to achieve that, which makes total
>>> sense.
>>> 
>>> However under a heavy memory pressure there must be a mechanism to
>>> revert to order-0 folios, otherwise the memory pressure is inevitable
>>> increased. Maybe mmap_miss heuristics should still be applied? Any other
>>> ideas how to fix it?
>>
>> What's supposed to happen is that we should have logic like:
>>
>>                         if (order > min_order)
>>                                 alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
>>
>> so we try a little bit to free memory if we can't allocate an order-9
>> folio immediately, but we shouldn't be retrying for hours.  Maybe
>> that got lost somewhere along the line because I don't see it now.
>
> Yeah, I see it in __filemap_get_folio(), but not in ra_alloc_folio().
> I'll prepare a fix for this.

Actually I'm wrong. It's there, hidden in readahead_gfp_mask(), and it's
not conditional on the folio order. However it's not helping/not enough.

