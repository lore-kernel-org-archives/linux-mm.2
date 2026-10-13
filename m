Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E8CCC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820C96B008A; Tue, 13 Oct 2026 12:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1446B00AC; Tue, 13 Oct 2026 12:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7B46B00AD; Tue, 13 Oct 2026 12:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0780C6B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:33:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A096140B31
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:33:33 +0000 (UTC)
X-FDA: 85318148706.27.B26B128
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id ECF781C000B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:33:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vcz4Mnl7;
	spf=pass (imf21.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791909212;
	b=QnsrdwZvPaLLzQexDnhooXSjUql5+fN77iKaHSVZeR0/v+K41Ho977y/qGkx6Wku2ub7ZZ
	0qrCsdquawjWYf0OJQ5iYFeGg8rBOWPjQK12rMoLouQ9UDO1ys0auvf1HSr/4ylvAeSF2E
	ONsnSnLtAe1tGb+84v3Eny0cOHaXuAQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vcz4Mnl7;
	spf=pass (imf21.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791909212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6T2EyX04RGGoQAm4CXmcxngdnZP3I2uya54Wk47L/0Y=;
	b=ZjnfyWEMf/WFS1cEmTl/EodXKN5p/EAAPAFlyzkv5BFb01gu+IylIceXHzzh50cBqmpkh+
	rPpAUdQeIiGVm+PBIon7Y6W102AWsnxWM2Hr+ciK4pEcNM/FIAtUSvk3LSStpF1YEIOlcb
	4IBSRF/+w+m5larhss4T4R9ZyoxHI7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37CC6602C3;
	Tue, 13 Oct 2026 16:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4D51F000FF;
	Tue, 13 Oct 2026 16:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791909210;
	bh=6T2EyX04RGGoQAm4CXmcxngdnZP3I2uya54Wk47L/0Y=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=Vcz4Mnl7SMcC5EofSiSNhkawGfHClWTALjiOo4bER3V4Z0amj7+3YO26sm20FniHx
	 S6Z1wIpgHT+QqLyz5khvTt4j2b5dCgs32N0hAPzfBUyf4YIiSF9Mls15T2xzzqSVuK
	 iFJ4qGpJK0J/7Hao1ozrXxNme8Uw6CLt4bMRmfHPifSg8qXZWTUcFcTrTHcOmtAEVV
	 CZT17t3CpuMVDPcBcUPMrNWpSSwq8pIUnVLDI30ax4iaoWy6eWqvtXvW4JcXq+jESj
	 HYxsbgl/gcyeCjNbw11aa4jo4BN/s4GEwp9mfWD/jMel0RYFlZEvHWhnEjz8MdweiL
	 xvMxsgLunmnZA==
Date: Tue, 13 Oct 2026 18:32:26 +0200 (CEST)
From: Imre Kaloz <kaloz@kernel.org>
To: Harry Yoo <harry@kernel.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, Jann Horn <jannh@google.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: sample slab_state once in
 kmem_cache_destroy()
In-Reply-To: <as4q2WlR7mLhMBpG@thinkstation>
Message-ID: <e4184209-75ee-929d-0103-ca15d5886000@kernel.org>
References: <20260930195110.13296-1-kaloz@kernel.org> <ar5pESlkEMqNsgxv@thinkstation> <aef97b97-0bd7-d720-7f59-8c0078747370@kernel.org> <as4QhUscRVtBzYpm@thinkstation> <481e9a16-cd30-d463-14ee-b5602bcd5a21@kernel.org> <as4q2WlR7mLhMBpG@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECF781C000B
X-Rspam-User: 
X-Stat-Signature: cbophzncuqkubn59xwt5oaj34a1p9mm5
X-HE-Tag: 1791909211-511922
X-HE-Meta: U2FsdGVkX18B+nyDDbHtrqFqz0tufvXKn/IAAnIv2v3d5qTIAh9/+g/6WD6Ha0jXukyBCCDjHHPzB+2vZTR0VdCwwmHpnnQjXoyQX4yC7frY0VKcSy+Q/PnwdMXEWoPH4k0pB3V8rb1Ysr2obJOWgIqzJI5UncobKUw2PMcfi6se9UIV9frnHYweMePYx5T6aNdxSE/reiHUxW7M8yjxT4e5uMNmj66dKsZHZmdm4fSCwpfrZS305Rl4zzaKa1S7aySsYFszn1lXQKnF4f1yUJxaXz6DYigtVZvajdsRLyeBOZ8U52+AUcbrhgDDvgWz604KixyzBEV4Z1/QoKWXZGyibbsNxyyOBrn5AqKnXDfHLg40L1iI9SzMlhsBANCVOIPcSyr9FWqUcp6LrMi+bPP+fX/I6hRLTZV4io8Mc/1ahodYAVxFMKbJd1IRj97PKXfDS2m384Dp8iNMlJ2jBHXZQ+y0BfUNsIi3ANhkb17eGNDlOXUvj0mjxdjAqjqKScdF5t29mOyCl6mGzx7I9pgWm/TngKaGCq+7EdunzNOP53ZszXFKsaRHIAYI1ZTj+pcY9v+2L0QwFVFB4gjL/WnrZAy8YwhCJoMkNSOBa384fSYWS5YfV+ay9wO914GZ2hJh9oQsfEU0mrdAK1rr711UiKv6FDRqplnmtF5ieFSVxC36ENl0xjgIQWc2nF/Yt3ZZHsIoVWzh0FFINwtUc7HKtUsY4U5bVVU3vUcOLwEzJr5ZVPRCe6+y99PG6tQSJuesxN3BRV7XOBFr1aeeqnrSx25gK5TnszVtYYyTA9CGd++YXlzPIet38EbnDN24xCKQ1hqSbQZAMaL9OfksyKAYKoQ2Xmmk+St/Fp+xjtK3dwfrhicWV4f1FHeVu+TkoZesvnS3eoS3ibOwiHJD6caRiJTtGdofxlHyxb2j6fdqSsiUVOzobzjV82FyoYev60a/X1rqwUYBH7Z1eb5
 dybM10xW
 rS0Kv/ajSPnI+ylQOiDXiO8d02arbhV7DCdStjy5C9sdbP0856ftehKTGWICkOe9GNN50c0N26TAwfiP7G20Qa8dcv/dU6fmnTKgS35Pz5sSAeolgEJuHWLK+bMby04hcP65NdyCJ2J0EjuSlOnlHrnx3/Zbysh2EAgRYS8LzvnzF1gCvVOz/9VLp1ktf7X4+Znlff4rcnUWblc1kxdBzP8GKdS98mhu+8J6OPoqBpFEZ3AjHMNA+Knen7Gf952TwT3fr/+MsiAzTwOoA92QbifFOSYzk30KQk5RmA5DtmotzCys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Tue, 13 Oct 2026, Harry Yoo wrote:

<snip>

>>>> There is a related older window: after list_del() and before that
>>>> single read, slab_sysfs_init() could set FULL, skip this cache, and
>>>> the single read would then call both unlink and release on an
>>>> uninitialized kobject.
>>>
>>> No, with this patch slab_sysfs_init() cannot set the state to FULL
>>> because the slab_caches list and slab_state are protected by slab_mutex.
>>>
>>>> I have not hit that, and this patch does not close it.
>>>
>>> I think the patch does close two bugs.
>>>
>>> One introduced by 4ec10268ed98 (reading slab_state twice),
>>> another (reading slab_state outside slab_mutex) introduced by, hmm,
>>> not sure which commit introduced it :) should be very old.
>>
>> You're right, I got that one wrong. Sampling under slab_mutex in the
>> same section as the list_del() means slab_late_init() either sees the
>> cache on the list or we see slab_state < FULL, so the older window is
>> closed too.
>>
>> As for where the outside-mutex read came from, as far as I can tell it's
>> 0495e337b703 ("mm/slab_common: Deleting kobject in kmem_cache_destroy()
>> without holding slab_mutex/cpu_hotplug_lock"). Before that, the unlink
>> and release and their slab_state checks ran in shutdown_cache() under
>> slab_mutex.
>
> 0495e337b703 Probably yes. Not 100% sure.
>
> It's quite messy, reading slab_state has been done inside, switched
> to outside, and back to inside, and so on.
>
> But should be fine as long as we can find the first commit that
> affects -stable kernels (>= 5.10.y)
>
>> SLAB_TYPESAFE_BY_RCU caches were already released from the
>> workfn outside the mutex since 657dc2f97220.
>>
>> Want me to send a v2 with a second Fixes: for 0495e337b703, or is it
>> fine to add it when applying?
>
> Could you please verify fixing which bugs resolves the issue on sparc64
> described in the changelog? Reading it twice, or outside slab_mutex, or
> both?

I tested it. I built five variants of rc7 with a small test that
destroys a SLAB_TYPESAFE_BY_RCU cache while slab_late_init() runs
(same path the floppy bio slab takes), and booted each 10 times on
x86 and 8 times on sparc64. Boots that hit the WARN:

                                              x86     sparc64
   mainline                                   9/10    8/8
   one read, in kmem_cache_release()          9/10    8/8
   unlink check under slab_mutex,
     release still re-reads                   10/10   8/8
   one read under slab_mutex (this patch)     0/10    0/8
   one read right after mutex_unlock()        0/10    0/8

So it takes both. The read that hurts is the one at release time,
after rcu_barrier(); fixing only the double read keeps it, and so
does moving only the unlink check under the mutex. Reading once
right after the unlock didn't trigger it, but that is still racy,
just a much smaller window.

For stable, as far as I can tell the release-side read has been
outside slab_mutex since d50d82faa0c9 ("slub: fix failure when we
delete and create a slab cache") in v4.18, so that would cover
5.10.y. The patch doesn't apply before 6.12, so the older branches
need their own backports.


Best,
Imre

