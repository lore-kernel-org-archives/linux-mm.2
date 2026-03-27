Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8748010BA430
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D777C6B00A7; Fri, 27 Mar 2026 03:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28716B00A9; Fri, 27 Mar 2026 03:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65006B00AB; Fri, 27 Mar 2026 03:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6B1D6B00A7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:32:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FC27BE57B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:32:09 +0000 (UTC)
X-FDA: 84591024378.11.E42FACB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C8BB01C000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:32:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8NLGuLB;
	spf=pass (imf20.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8NLGuLB;
	spf=pass (imf20.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774596728; a=rsa-sha256;
	cv=none;
	b=yZi4JJhBcb37l3+Eo7kLvriF0Lv+9HlWizHAXMUxxVtPQ43xfrjHgclfF50kJVBK37UKyK
	pbhgn17/SPaT+oOqj1LTQdFdy0AIMjCVrJ4ixiAW7MAnRVJqAlsqomiYct3nN55FrFMmvw
	0+t8hjbJWGEktuRCjFCUURIIFOrP7E0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774596727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBgQV30ioA8TQS8PNdlo1Xiq1sv/HScUJH597prdRwA=;
	b=kcWsv6nsNgBEn+/ITBrCS8ib8GcaSqjg3m0bMjbNCm2OT37jZSZiAI3h3RUIp4m9zJ0wRl
	qNZ+dBH8rHz7Ret6Lf+u49lXKBgU4ZIcsrBbXuZkYAboWw9zejw2OzM+HyEmYPw/0QqTiG
	Kf0rEKWjyGWRqamjZgWIifkqHlAwc+8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BADE43791;
	Fri, 27 Mar 2026 07:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202C2C19424;
	Fri, 27 Mar 2026 07:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774596726;
	bh=vEjbAvSvvxunsltEpHCuMGhaMjxhbb7YGvO/XpsR8a4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m8NLGuLBtG8Ow2o7/3Ran4Vah/VVIcLaxJ+USwy/N9t+QRh+sdSTJdt5XbcNvyXfm
	 5g2ABxnx4l+nLsaswGiF418fqoy93qwXc8gOkAtHh9JYpwyt/1KWAaA4oQG8YWbRGp
	 +YKMQPXI20dfP3fz95vTig68mOUEgByrxGQOnYRHrTAiz/HAlHfpIqBLXFRIlMI5IF
	 NG3o56yKEgSybC6vTrA+Wnk9qBqMh73/zvfWbJwWD3Xgoznm7W4FRIRltVIatxBrW3
	 FrscSAb1kM6tjYCMhQE9IkLfOPDotOBqQyi6j4sEb+ncrnjn8uC4+fAa9G4/kWXbuj
	 c0/dTwxDUGs5Q==
Date: Fri, 27 Mar 2026 00:32:04 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zenghongling <zenghongling@kylinos.cn>, dennis@kernel.org,
	tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
	zhongling0719@126.com
Subject: Re: [PATCH] mm/percpu-internal.h: optimise pcpu_chunk_struct to save
 memory
Message-ID: <acYydEjiVVnHSgzT@palisades.local>
References: <20260305073043.571691-1-zenghongling@kylinos.cn>
 <20260326221641.7a2edff04ebb51561c8818e4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326221641.7a2edff04ebb51561c8818e4@linux-foundation.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C8BB01C000A
X-Stat-Signature: jdwcuw11wyn16btqkx41q6ojuaqehjy3
X-Rspam-User: 
X-HE-Tag: 1774596727-639937
X-HE-Meta: U2FsdGVkX1+RRDg6u16c+SdlNW7/PSEigg2QrnFdpBvXuSF//4xCvqwFTBldwkt5wb0QDf8wTSiTsvL0bmp6Xov1koE+7OgDAKWiUCi0QthCfVQ0cggJq4w0pHHZfLdI17mj5t+IL0hNuSvImFiSj4apLRr68xzZeoa2WJJELaOEkDK3gp03v8pk5YWnr+n6GlUauTm9Tg2T/Q5kPCJxBJXWueuETgO/54RqwjH/JBHdLsmcXD4xQroZjs/yre0sHJlgOHNBs2/c5Hv88CDF8mUusJpFbMOTPaC5ocZ44dochAkc+g50cQw+zCmmdCrU5Op3V7tmo4317BQZYSHj8CR8KwT8KCUw6E3sczky75l1eIu2RcAo8ZhVsnwI2ZdycOvmL7xfxM9w4NR23qZ7AW1XatIMeRD7+P6dVMjJIQy1vHeHIbLCvZlaRo0LwhPHf3mOohee7X7yO5pt0ntpuohZgYJYy5dEf1MRcfaSHTpKCp9VOpK9qjxvrp0eOOcpC3K/7KuTCkjxvrg9Zjpxn16Ow7U1vvGdAz3Dqr+2L/EzlRPQ0FN+q3QEk19FImm4KF99GBkzJ7D4fZ8/J4PmlVNoHum0Zmf3Yqa4XPSX5knJ4Jnt9cAIyXYFWwme3WHhKrIR9XWsbwnApoDmha6Pb2huh0JI8NuXh0mxhJer2fCT18Y4qtgTNYTp8tFKNwxFdgHiynjzgRMHJdbLiIlC2ENMcyTnvmGIbUaIbQPjQaKYDnjvIvtr3rHEcX6appqKciS4UdW4cS8QViKaLLAHPqk1et1TBNaytpNz2pHoGhI1ki7Wv+LZPEPCTTrrIvatBnpY+LFXLSm48sPJ0qMpt6HSHTeH90xiUJXqTWE8KG5vZNu3yFnnBQRnIW0dEWoKlV3Rm1TwDzNhF/1tfqF5pAuH38tJ1duGoi72lrjUPTS5RRup4TQIRJIf4E7dDJ7aiu1lpgmuB/Dk4jKh1MB
 Tyzab/Gw
 rUccXfy2SC+DeFocY4XhtxZQ91mSkOtjBzkiO/VzeEdgWgiBENuG+iiFfl9FOArhH7tDxEKAMBGIbycbSBrX1WaioitHNnAVaYP0AQzerEQaQCgmN4yMYbg1kZjSKed47Kd6z41MckWFO8FQ2Gx9uD3ZZejPjpCt++QewswgkWbjzHByrmgGS/o9uxhGqntvxkxFkAi8KmCSGUhR+nY8Lp0FCPYnVqjQ9lkzS/3W/o8ewaUb6wvKVbWKgDZqGgaVnjmvIOd03Pi9zYyipk+ZlZh2S14Fv3ErvVp8x48Nifsh/Cbe1FfQCjxgUGxHRiSfjhQvQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Mar 26, 2026 at 10:16:41PM -0700, Andrew Morton wrote:
> On Thu,  5 Mar 2026 15:30:43 +0800 zenghongling <zenghongling@kylinos.cn> wrote:
> 
> > Subject: [PATCH] mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory
> 
> There is no pcpu_chunk_struct,  I'll change this to "struct pcpu_chunk".
> 
> > Date: Thu,  5 Mar 2026 15:30:43 +0800
> > Sender: owner-linux-mm@kvack.org
> > X-Mailer: git-send-email 2.25.1
> > 
> > The pcpu_chunk_struct has a hole of 4 bytes and pushes the struct to three
> > cachelines.  Relocating the three booleans upwards allows for the struct
> > to only use two cachelines.
> 

Wait, this patch moves `int nr_empty_pop_pages` not 3 booleans?

> before:
> 
> (gdb) p sizeof(struct pcpu_chunk)
> $2 = 256
> 
> after:
> 
> (gdb) p sizeof(struct pcpu_chunk)
> $1 = 192
> 
> That's remarkable.  It was an allmodconfig build which tends to add
> bloat, but the only source-level alteration was this patch.
> 

There is also still PERCPU_STATS at the beginning of the chunk depending
on config, defaults no.

struct pcpu_chunk {
#ifdef CONFIG_PERCPU_STATS
        int                     nr_alloc;       /* # of allocations */
        size_t                  max_alloc_size; /* largest allocation size */
#endif

In my experience this is an order 10s - 100 # of chunks. So this would
save give or take like 4k.

> 
> Another consideration here is that moving members around can have a
> performance impact - it can cause more (or less) cacheline
> invalidations.  I worry that because someone has carefully commented
> all the member offsets, this might have been a consideration.
> 

I'd probably move nr_pages over nr_empty_pop_pages as if you're touching
the populated[] array, you're more likely to touch nr_empty_pop_pages.

> Also I think your patch may have made those comments incorrect?
> 
> 
> Dennis, Tejun, Christoph: I think we want this space saving.  Can
> you please advise?
> 

I don't think it hurts. I'd move nr_pages over nr_empty_pop_pages.

Thanks,
Dennis

