Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070E9CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFE16B008A; Thu, 15 Oct 2026 22:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F9B6B0092; Thu, 15 Oct 2026 22:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97166B0098; Thu, 15 Oct 2026 22:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 865DD6B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:10:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FB241A01E9
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:10:54 +0000 (UTC)
X-FDA: 85326861228.19.0A78D2B
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1FA94A0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:10:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="S8CockI/";
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792116652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwyzrf1kzeLI1oZB/A5iavIjedkBLc3DM5w/mdrLY5Y=;
	b=VvJWGsL0VjbDJjcjVFxUCTY6K8Iyo4fJ/Ul6jW+mtnbzpLf3LCQ1jEGIogMw2Q7ihWe8w/
	5/SEzniAW3Q1TGAMtITBboYiHpE+79Q4Efrg23I8AZk89l8xC3+Iwxqnjt/OyzkiG74xKG
	gapea3nfFHlVvycQte0xeVJI2WFUAfg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="S8CockI/";
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792116652;
	b=xzB1jJmmG6MQMwtderJVEkGy/SNiLV9wGDt7k+DG7tFIHSE0+GX58zzf8c21aXjijwAH8l
	nqmJomnzynNDidwKHzYsHbum5+YAdbSHGbYHttbm2yEvt2zLb16HNrpXvJJhODVf95LadA
	rE8DuF8/SDy56pVu6qTgyOkLOZ8Peqk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=De18uuNLtNRyygl8Fw06uyfstZGsdRdC2bQXbHUzJrQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792116650; v=1; x=1792721450;
 b=S8CockI/a+kHaAvNBTFLvWLJUPAqb5i5hsiaSbkuogaM77hjr/twkg28EMXNpCoAtrOVlQVM
 vad/wCj9u9MP01d3nQ56cbgPxC5hJsFQqutkeGRbalkoLVLdk7QXEYMwIvYiJIr9Q/dlj1hNksK
 68YGXg0g4yWn42JeQW7Y1cKw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d85f21d1232013b6;
	Fri, 16 Oct 2026 02:10:50 +0000
X-Mizu-Trace-ID: d85f21d1232013b6
X-Migadu-Flow: FLOW_OUT
Message-ID: <b2f925b6-93e6-4b44-bc18-c94a34b381eb@linux.dev>
Date: Fri, 16 Oct 2026 10:10:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio
 that left the swap cache
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
References: <20261015060528.302634-1-jiayuan.chen@linux.dev>
 <20261015184014.715dcdd3a25e18fd4df49e95@linux-foundation.org>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20261015184014.715dcdd3a25e18fd4df49e95@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FA94A0003
X-Rspam-User: 
X-Stat-Signature: 5f6trd8uh7w9w6wshz1xsbobjtefyzgi
X-HE-Tag: 1792116651-15896
X-HE-Meta: U2FsdGVkX1+9FTDmD6WLXTJcTwZNlY3hMuzDs2lJBKoiCB0lmWbAlCd1p4dKlSuT848jtm7lq7TciK1omjRqoMnIhA7uNappB9vo+bzI13ShAHYkkK7nrYgFAZAHcq73Mo+xdCyPZjslQ6e3bWgviuu0opSEpyu6d6RvFtOCjl6k+hgn5FKmF1Gp0Rd6QeAi6jbCAHgWab6YK2IRJd3xsF+FXN8YcALGFFiB3ENVDGioFbP8eBit9+kin/saI4mCO35Hco+U2j7iIaCTkNhekwYc0E42V0buktHH99epf+YJHVmzBXzQtz4tF40lZ2qiOmVXsElt8d1da6AM5SiGByxoQMXVedwkrCwx5XqsSuLfrcWwolPQ5Y2chH2+zU3jIbRkbRPPY9xeD3HRV1Y3DljrtSFV8TrIPO6iOk1OGVxCYsHTOvS9NTmprFArXj3cdUOcwQap5EJSn/JgLZs6yjNeO/O1srbanw52NSKEzcoy5SrpYyfGVaCSdOWHbCvhhYRlyK8bX4CiLm6y/JwwbdO1vEjmQ8S3t0ClOxLYwGCmnEbmGweNX4640ZNRtLe79zT6h1fAYga7FQIoFsu4YKwircEj4Bv1AQYjZWyFmuBJSbZhsfakPepbP3+cXGeUiR8rj6XE2qCjbb40UPM2D3tI3qVUvP0ypC4jJd0vg/ziM81kY0bsZGhbprpgkA55RD2gZxR9rvL9rkflV7lUdm3AT6BUq8VDgItQ02JXCBZ4SW+ALeVtyJclLvgQqQLXcNlI1dQSEqEUNkFKsOA98xk15n17rqmRA26UELCO1Ww7VZXEFoePwriB/DImbZFcxNsvbvPOqMgFXmQTlwAjSRFPap/xwaI5ZRvCvuXqBgHGtTWF/ZETRngUnhbBS++6qci8gW3UD0frnhUVg2xdHdT+BJdi6ND8tYuBbJMp0UTaWSalaIut8yO2uw5flw1QxMmdMf1YLlCLOSLDQN7
 mif3Rfnp
 xRZR+WKiHdA6WvKzpZXB5xUGFS8imnswCZ4rpHK3bX6042+r6sWll9n2sgYq+Gsmu71zZy3xJewGZEucsaeWbDproHjOIQ2gJAxnakps2oLhrIoclvOZk23bi7p5BCdHCatTvekdUglh7iLQqk2gMXYfs43Ef3WoCAkwyL/CgaeqbFHxSo+AZDl/P/lAFrS+cjjUMvvcUFhQBRLm+8ZQ+daLEWd1J0A9VUh1JrLDR88L4DKkrJLVE/cYwtl9IyVWZN+jAM3tb5t17qPfkBvJp8kYt7cnIv3Krp7P4F1hJDD24tlPzkT2CymN6It3JUZBdLlVGKZByubwIDml8kmtwIfi/4DvgzLl8iD0x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 10/16/26 9:40 AM, Andrew Morton wrote:
> On Thu, 15 Oct 2026 14:05:27 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>
[...]
>
> So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
> takes the folio lock of someone else's page, before
> folio_matches_swap_entry() finds out the folio is not ours.
>
> Recheck the slot after folio_try_get() and retry if it no longer holds
> this folio.
> Thanks.
>
> As always, when fixing a bug please fully describe the worst-case
> userspace-visible runtime effects of that bug.
>
> I asked $LLM for this and was told
>
> : When the race occurs, a swap fault can acquire a reference to a
> : physical page that has been freed and reused for an unrelated purpose,
> : potentially by another process.  The fault handler may then clear that
> : page's PG_readahead/PG_reclaim flag, wait on or acquire its folio lock,
> : and potentially attempt to remove it from an unrelated swap cache.
> :
> : These operations can interfere with unrelated workloads and may cause
> : unexpected stalls, impaired reclaim or writeback, and potentially
> : system hangs.  The subsequent swap-entry validation normally prevents


I don't see a way to a system hang: the folio lock waiter is woken when
the real owner unlocks, so the worst case is a stall. I suggest
dropping "and potentially system hangs".


Writeback itself is not affected, only the PG_reclaim hint on where to
put the folio after writeback. So "impaired reclaim or writeback" ->
"impaired reclaim".

So I'd suggest:

   : When the race occurs, a swap fault can acquire a reference to a
   : physical page that has been freed and reused for an unrelated purpose,
   : potentially by another process.  The fault handler may then clear that
   : page's PG_readahead/PG_reclaim flag, wait on or acquire its folio lock,
   : and potentially attempt to remove it from an unrelated swap cache.
   :
   : These operations can interfere with unrelated workloads and may cause
   : unexpected stalls and impaired reclaim.  The subsequent swap-entry
   : validation normally prevents the wrong folio from being mapped into
   : the faulting process, and neither data corruption nor a kernel crash
   : has been demonstrated.


> : the wrong folio from being mapped into the faulting process, and
> : neither data corruption nor a kernel crash has been demonstrated.
>
> Do you agree with this?  OK with me adding this to your changelog?
>
>> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
> Given the above, I suggest adding cc:stable.
>
> Do you and maintainers agree?


Agreed for me.


