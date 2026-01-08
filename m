Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EAEECF6BE5
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 08:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF1E6B0092; Thu,  8 Jan 2026 03:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4869E6B0093; Thu,  8 Jan 2026 03:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3276B0095; Thu,  8 Jan 2026 03:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C94B6B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:01:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5CDE13A463
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:01:28 +0000 (UTC)
X-FDA: 84308051856.10.9600749
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id DEB234000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:01:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IXSWAAlC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767859287; a=rsa-sha256;
	cv=none;
	b=GwPOqCpttPJya03geinEyek/Fbk8pX/iztkFTPqxnjn537OyOe7+HX6YihvRXtB8heuNCi
	3CbWuEEl0sXdMETSSnTsjNETjroyFyG08lmoxuzvEOE9gSSi/QKagHmfJB2W0he5O8Nvht
	F1iNSXE2JQnYfLQ31kr479QdBQBv7Bk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IXSWAAlC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767859287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPWeFNb2BnIAye+ssWozHHQ7PYhgDTvEZHc8BmJCF5A=;
	b=aoLogWvBO+Q0gpCKJfRR76wLACXCD8GBQG7lXHMSXY0W1QlOrljCRvs2lA4CvV+f/0MGjx
	rQJc+WPw0weBGQz7dLOFiNJl47N4Mkgqq3UR/4SuGnEYvYfl0BwRh1dvXZup+J64pztUpX
	CC6TGOr8J68NvVy0C2ZcVO7mXOCawVc=
Date: Thu, 8 Jan 2026 08:01:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767859284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VPWeFNb2BnIAye+ssWozHHQ7PYhgDTvEZHc8BmJCF5A=;
	b=IXSWAAlCnENr/yGooVjdkZC26AzQbAHa25u53JiKYHUUWZ/Lvux8AShS6USNksEUHl5jRn
	S1mSdjE1f3301sA1N9+WIqPZs6igtF0FpRDX+D33p4DDmMc7yk3A5C4o8SkdWwil4NGoBQ
	T4KlCvx9KBmaGoVRb0TB29BrMuYDbKE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
References: <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
 <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
 <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DEB234000B
X-Rspamd-Server: rspam03
X-Stat-Signature: 8h8hgcyah833w3prsasnirr9aiqi4jmk
X-Rspam-User: 
X-HE-Tag: 1767859286-304199
X-HE-Meta: U2FsdGVkX1+zt+5UGMfKvI/uoUlhKa5WL4kUB+o4Xpm4TVD7A3QoHNJqvgjEf0lTjTFTwzbgz636QkN8/Jsh/UT24NfqHKBZ+ADUU+9rbRmJ0CgeRyh540lK3ZeshatplXeuf6NPJPA3Y740TKkVQGPiLADiZXe49O9R4BYfpthEXKxrEcCcgOprM4P3TBon2P/DbMl15kM05LjN6tCs1gCIB8eZJvM33c54V/I4Mp6Kel72iCth5N7rtucXeV98dqwi6gxcsMv99O7/7hdcCHLY2Anv+340lpisQoVnSLlPUDas7NnZoEQArr7OsaDCtqzvmRKeyZXx8WARzblAK2hrElWNX1BE+YsGRQdCuwh5ZGekvowFtwbhUOvuP8pgEBGbjVponBAps+M2AJy9SIdKeiK9jQYOW6oNUc56u4pitnH9GCVMbjvhwqCMjBp4FDSCMeurKBnhZIIyb53FQLTXhm2+z75YOgW/B6hA+T/RD3JHpeudeSTQx597QQ1LiSLG484T7k69h0vxtdsipnPU0nuDr2Hr4L2L+2Tro1cFMPu+oBHjuRoOplM8212Ig44sdQM5b+W6GHj3qpPBYhTeXYhJuleMkDEU0r1cyMRENeF2uEvrJKpwj6ppk/LiEXfQ1VQEMv5Edew5gOyx+rBb5qcMvbYg5QKJayZzYlleBuEwqrPd0kRuYkHyhj7hmmQBBoLQ0DR0QqVL6F+mtCX10Fg+0gugQ8R7XWjbhJ8f7+yXHDM1ALYeesKVdoT2E/Cj9Y4MhxhOTpCbbP+Wt74IyPULwkXQcB8tvvwX3LITmCMfX+ZYm8grMjaBGPIuU1xDYMKvJ8mnUloDYCJs8Nzvn9j5i2EU96+fBLfbSFBesB2pnXTfa702GZnu9kRKqHyMF1kGCepM/MyIR0/4OYEp5C6PhTCN2+3dETFz1c6VAMlRDjVIpZV9/hb8IatzcQ9MgKnXiS4VmQfRgs4
 +mbnJRAZ
 lMi0/PT31pLYVhVglC2l3AdX2otstvpMqcOSJ1ZxzD6ftwJtt8LVc0D9cQbxygARh0cqKwVXAsnUeJdS6WigDggF1B1pg7x8q8Z5bmXvEcVWwu99DTR9qZU/ASGGykar7YQ+Ip7R7rV58dlCH1ztrObeird2LbG2zxG6Xs5hE7MKV14pXN/KT61xqRNkjw1sy/Um0p4a9GMdRQV0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 04:37:11PM +0900, Sergey Senozhatsky wrote:
> On (26/01/07 17:12), Yosry Ahmed wrote:
> > On Wed, Jan 07, 2026 at 02:43:42PM +0900, Sergey Senozhatsky wrote:
> > > On (26/01/07 05:39), Yosry Ahmed wrote:
> > > > > On Tue, Jan 06, 2026 at 04:24:45PM +0000, Yosry Ahmed wrote:
> > > [..]
> > > > > Adding native SG support to LZO simply means removing the memcpy that
> > > > > scomp would otherwise have to do.
> > > > 
> > > > Yeah the effort to add native support to compressors can be done
> > > > separately. For zswap, I think the most common compressors are
> > > > actually zstd and LZ4.
> > > 
> > > I think it's the same for chromeos: lz4 (primary) and zstd
> > > (secondary/recompression).  zstd looks very complicated,
> > > not sure if we really want to diverge its codebase from
> > > the upstream (meta github repo).
> > 
> > I think there's value in using SG lists even if we do not have support
> > for lz4 or zstd. We'll remove the memcpy() logic in zsmalloc and the
> > kmap handling memcpy() in zswap if we just pass SG lists from zsmalloc
> > to zswap/zram.
> 
> Yeah I agree, I guess I can cook something up.
> 
> For transition period we can have:
> - current "memcpy" API
>   for zswap
> 
> - SG-list API
> 
> I can vmap either on the zram side or have new zsmalloc vmap API
> (alongside the memcpy and SG-list APIs).
> 
> Once crypto API supports SG-list and algorithms tunables I can
> switch zram over from zcomp to crypto API and remove memcpy and
> vmap APIs from zsmalloc.

IIUC based on Herbert's previous response, crypto and scomp already
support passing in a discontiguous SG-list. So for zswap, if zsmalloc
returns an SG-list, it will just be passed as-is to the crypto API.

If zram can also use the SG-list, then we can completely drop the
memcpy() logic from zsmalloc.

Herbert, please correct me if I am wrong.

