Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DA8D185C2
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7620D6B0005; Thu,  8 Jan 2026 05:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70FAA6B0092; Thu,  8 Jan 2026 05:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61BAE6B0093; Thu,  8 Jan 2026 05:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6086B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:36:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDAE01405E7
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:36:14 +0000 (UTC)
X-FDA: 84308441868.07.5D5B771
Received: from mail3-167.sinamail.sina.com.cn (mail3-167.sinamail.sina.com.cn [202.108.3.167])
	by imf28.hostedemail.com (Postfix) with ESMTP id 805F1C0006
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:36:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=mp7H+GJA;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf28.hostedemail.com: domain of zhangdongdong925@sina.com designates 202.108.3.167 as permitted sender) smtp.mailfrom=zhangdongdong925@sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767868573; a=rsa-sha256;
	cv=none;
	b=qEoKn7pLa7hlylDv8faLQzk0Tn/nEpbnOqPY0IAH4j28ql2wTUm2Me45g81a/+NsD3uqVw
	MYpVkKo3oRXuDwi4LWrYRqDi3u4I6AKMdr9hgne4sPUkCkHZ0wF1zN+G5WHFDp/7voIN+c
	qopABDvizDBt7u6HEDs8lt7Rp3DeIvM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=mp7H+GJA;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf28.hostedemail.com: domain of zhangdongdong925@sina.com designates 202.108.3.167 as permitted sender) smtp.mailfrom=zhangdongdong925@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767868573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvlc7vqh4bhdCSEuA5TpLBp3Xu6DhQ+wjbFss0nogZw=;
	b=yERr/4sZoPW9sptczeKDmtA3EiGjFewaqfJlcYcvB6AivNAym3tOmv1tLdp7gkzbH+FRiH
	WcS2mgOCw64tHagbqJCnm9dKDfUeHzNs1p54uIiENzn+Coe3kdLPnMsAJwB1vADVDB93zy
	wxUJljUhm60n50E1YnoUm+hjxoOgHXI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1767868571;
	bh=dvlc7vqh4bhdCSEuA5TpLBp3Xu6DhQ+wjbFss0nogZw=;
	h=Message-ID:Date:Subject:From;
	b=mp7H+GJATBk5LF2AXGKhVS1wIvcm5GYQjKcdKX75BhYevyb4C8qrXKOPSzpdL32SJ
	 qi2Xb8nm4t6fxgneAgz01o1D0JJkdfzGa7dGdZ5CjZ5ibnj6Eipy5hJbdWGht0RqAn
	 r4kmyxplIivAAcfMFQdCOsGSxDxZ83MbUGgQCGic=
X-SMAIL-HELO: [10.189.149.126]
Received: from unknown (HELO [10.189.149.126])([114.247.175.249])
	by sina.com (10.54.253.33) with ESMTP
	id 695F8895000018B3; Thu, 8 Jan 2026 18:36:07 +0800 (CST)
X-Sender: zhangdongdong925@sina.com
X-Auth-ID: zhangdongdong925@sina.com
X-SMAIL-MID: 117396685200
X-SMAIL-UIID: 0A83DA6CFAD5406983CF226D49853D50-20260108-183607-1
Message-ID: <731f6e5b-f678-49ef-ad8e-fe6ff85d5422@sina.com>
Date: Thu, 8 Jan 2026 18:36:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 1/7] zram: introduce compressed data writeback
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Richard Chang <richardycc@google.com>, Minchan Kim <minchan@kernel.org>,
 Brian Geffon <bgeffon@google.com>, David Stevens <stevensd@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>,
 xiongping1@xiaomi.com, huangjianan@xiaomi.com, wanghui33@xiaomi.com
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
 <20251201094754.4149975-2-senozhatsky@chromium.org>
 <40e38fa7-725b-407a-917a-59c5a76dedcb@sina.com>
 <7bnmkuodymm33yclp6e5oir2sqnqmpwlsb5qlxqyawszb5bvlu@l63wu3ckqihc>
 <2663a3d3-2d52-4269-970a-892d71c966bb@sina.com>
 <z22c2qgw2al73yij2ml2hlle2p24twgpmz4jemfqhjoiekc65f@pvap7olsolfp>
 <a527b179-263f-40ad-9d7c-bfa86731bfde@sina.com>
 <luzn25fgin43cnbmvmxwps7isqeq2pt5kfn26jqzly6hbnedlp@ojpw52ldzmuw>
Content-Language: en-US
From: zhangdongdong <zhangdongdong925@sina.com>
In-Reply-To: <luzn25fgin43cnbmvmxwps7isqeq2pt5kfn26jqzly6hbnedlp@ojpw52ldzmuw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 805F1C0006
X-Rspamd-Server: rspam03
X-Stat-Signature: jpyr6w88e8cf66yu9qx7bnjq5ms8m775
X-Rspam-User: 
X-HE-Tag: 1767868571-702963
X-HE-Meta: U2FsdGVkX1865QjheCls06Djc2/Ix+vbClmd2SEUvw4C9EoD3JK/nPiLFGVd3Is/VZL27qQzyI1N9m+I0z1DKfZGijh91FcqDhyPCYW+6mI5Tf65MBaSqc65vVATTEWDr/di7wyrlP05EoC3xXSgejBdywUDcDiiQ7MzAN/EPeCiU9fSwtULC3dvovjvKUKhZtQHiwZvLVGI7rk0Z51gKjrnvPjyXhz6FDOLi/wm0V1GkQgQ57Y/NK3loMh1pGXAIj/fzgFAsk91ou/k47UWOUBpqP57ASgzm+XefuvuHD/vF/c5IsMsvdQXGwKsUT0UmzBLY2V7FC1Jq4b4GNnb9Xh+auDbePV2JsFtiReavILt7wQM1WMz9+eP2MxUBMUEr669K0sOuJAJZKl7944PqIV4Q+usV7H677kAx7fO7cKPYu8aVCLysHWfs3tCUvBq3+A72HUVrGxENVEuUTwEpT4FPwfl+Ex7STyo4A/IxECcap0W9A0x7HhxqH7gr44t+ISjkK72fKiNewwk1dntgm2Nqkj9Hs131ZIArQjzxSIw+9UNK8sV3eKBs+K1wtAEsDovWqvzgXamd2n/b5wkNbFsavznVO/nkKkiagcbL+xnKoMsV6szfRCexVeOPYQXbXgE8ovdY2KjbvtmjAUYsOjAI7t9OvZl+SnoldU3XOUTT2mSnIyLn6oFrFIlt6Wc3V2D9do3zFHyvjHpfdqOwIcfPUuFZGPtgFj1a+Qnu2P180CYW/RhLmxQlierLLQS6e7sf0/HS8CNk9kQc65j3bhg1uZ6mtLiKIbyHIATr0sPjs4XLbR7JvCj2E3Gpe0Hm5+/SYcJAnNcAJpHnikw6P3z3PdnaQt3iTncEythYXoONtjyULO9e1hV5zLXd1M5n/WKEJOZcPx9mQFzR8xBZZNGQ+Ey7oCAAscqrrqYUwEIvDbDGnM+hIYCHVaTtd10Mwa50Qqy3HNTp8nbF/L
 QHLKPnO3
 YNEWb2ZtjqXd/GpVFQ20Yr1O3Y1wJ3JAABf1iejHXBG/DHaQpee/Xiq8WaPQoSMIuXy9rNjKVCjDizAT9CDQdHpUea9PJZ+cuAZSn4GRvCqK8EwwW+hhrVy6CUwpKoVIsxZsPofKEvgGdqRO/1sjOtVd/F7ifvKjJDfBil0CmPB9/3FexMqKTTsr1YA3+GTkKdBQ/D4i5Ez858N4XbjalGzxFUQ29oeaRKk/nCp7N3oDrBJj6aYJEnxG9fABzfOs+w/BB3cesjWuZcnhd5xlvu4GbZUxF4IW1qeTZxSKbmQgD8KM6Vi5H15yj8V755wmK6q1Y1dSb1410D2ygT79UmFK7cRyAwTH4wq5eoAUXQGUQi29fIPbay4uJFBJunEx3JAclNWm1rlSImbDRXVoSvs5RP6xn7org+vwy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/8/26 11:39, Sergey Senozhatsky wrote:
> Hi,
> 
> On (26/01/08 10:57), zhangdongdong wrote:
>>> Do you use any strategies for writeback?  Compressed writeback
>>> is supposed to be used for apps for which latency is not critical
>>> or sensitive, because of on-demand decompression costs.
>>>
>>
>> Hi Sergey,
>>
>> Sorry for the delayed reply — I had some urgent matters come up and only
>> got back to this now ;)
> 
> No worries, you reply in a perfectly reasonable time frame.
> 
>> Yes, we do use writeback strategies on our side. The current implementation
>> focuses on batched writeback of compressed data from
>> zram, managed on a per-app / per-memcg basis. We track and control how
>> much data from each app is written back to the backing storage, with the
>> same assumption you mentioned: compressed writeback is primarily
>> intended for workloads where latency is not critical.
>>
>> Accurate prefetching on swap-in is still an open problem for us. As you
>> pointed out, both the I/O itself and on-demand decompression introduce
>> additional latency on the readback path, and minimizing their impact
>> remains challenging.
>>
>> Regarding the workqueue choice: initially we used system_dfl_wq for the
>> read/decompression path. Later, based on observed scheduling latency
>> under memory pressure, we switched to a dedicated workqueue created with
>> WQ_HIGHPRI | WQ_UNBOUND. This change helped reduce scheduling
>> interference, but it also reinforced our concern that deferring
>> decompression to a worker still adds an extra scheduling hop on the
>> swap-in path.
> 
> How bad (and often) is your memory pressure situation?  I just wonder
> if your case is an outlier, so to speak.
> 
> 
> Just thinking aloud:
> 
> I really don't see a path back to atomic zram read/write.  Those
> were very painful and problematic, I do not consider a possibility
> of re-introducing them, especially if the reason is an optional
> feature (which comp-wb is).  If we want to improve latency, we need
> to find a way to do it without going back to atomic read/write,
> assuming that latency becomes unbearable.  But at the same time under
> memory pressure everything becomes janky at some point, so I don't
> know if comp-wb latency is the biggest problem in that case.
> 
> Dunno, *maybe* we can explore a possibility of grabbing both entry-lock
> and per-CPU compression stream before we queue async bio, so that in
> the bio completion we already *sort of* have everything we need.
> However, that comes with a bunch of issues:
> 
> - the number of per-CPU compression streams is limited, naturally,
>    to the number of CPUs.  So if we have a bunch of comp-wb reads we
>    can block all other activities: normal zram reads/writes, which
>    compete for the same per-CPU compressions streams.
> 
> - this still puts atomicity requirements on the compressors.  I haven't
>    looked into, for instance, zstd *de*-compression code, but I know for
>    sure that zstd compression code allocates memory internally when
>    configured to use pre-trained CD-dictionaries, effectively making zstd
>    use GFP_ATOMIC allocations internally, if called from atomic context.
>    Do we have anything like that in decompression - I don't know.  But in
>    general we cannot be sure that all compressors work in atomic context
>    in the same way as they do in non-atomic context.
> 
> I don't know if solving it on zram side alone is possible.  Maybe we
> can get some help from the block layer: some sort of two-stage bio
> submission.  First stage: submit chained bio-s, second stage: iterate
> over all submitted and completed bio-s and decompress the data.  Again,
> just thinking out loud.
> 

Hi Sergey,

My thinking is largely aligned with yours. I agree that relying on zram
alone is unlikely to fully solve this problem, especially without going
back to atomic read/write.

Our current mitigation approach is to introduce a hook at the swap layer
and move decompression there. By doing so, decompression happens in a
fully sleepable context, which avoids the atomic-context constraints
you outlined. This helps us sidestep the core issue rather than trying
to force decompression back into zram completion paths.

For reference, this is the change we are experimenting with:
https://android-review.googlesource.com/c/kernel/common/+/3724447

I also noticed that Richard proposed a similar optimization hook recently:
https://android-review.googlesource.com/c/kernel/common/+/3730147

Regarding your question about memory pressure: our current test case
runs on an 8 GB device, with around 50 apps being launched sequentially.
This creates fairly heavy memory pressure. In earlier tests using an
async kworker-based approach, we observed an average latency of about
1.3 ms,but with tail latencies occasionally reaching 30–100 ms.

If I recall correctly, this issue first became noticeable after a block
layer change was merged; I can try to dig that up and share more details
later.

Best regards,
dongdong


