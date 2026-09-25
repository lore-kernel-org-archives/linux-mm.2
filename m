Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A87AC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AD286B008A; Fri, 25 Sep 2026 06:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684D66B008C; Fri, 25 Sep 2026 06:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A986B0092; Fri, 25 Sep 2026 06:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3E56B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:27:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6C3FA679C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:27:18 +0000 (UTC)
X-FDA: 85251907356.30.C61D8C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 38D3E1C0007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:27:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lw16QUas;
	spf=pass (imf21.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790332037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xV0zw0Q7IQMSkiU/SQQ9pgJXpKqIp+csK9nbXVynRnA=;
	b=SsaodnPE0o462gQtdzNPufgvjEroyDfJ/Nm7C8t3BO2BnzlfeL3x5iA3Srek5yNLCxb5YE
	uYplJhhbW457ipDakxll3m3GOcIcU+f+biAbHq2ILDK8rM7W1FrVuccLp/Zxs2cGd7/DOk
	tXHzBDiNdD8AtsDduczapUoN2YbBAY8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lw16QUas;
	spf=pass (imf21.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790332037;
	b=XlHSya/sw1fhlegQdzsau3ivUaEUpM3MJn423y9Mg8dOlWVE1t9JHVXpjBZYEzHbR29TTC
	HSLv5UChDt9J+qascxjeeyVehhEpnbvcI2NvgdnrDAkjULwCluQQ/OUDPRmCrqbCzDqMbC
	8pxf795fNiEAyRLTaBtW3lTsQu+3jSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B88C46022F;
	Fri, 25 Sep 2026 10:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170E31F00893;
	Fri, 25 Sep 2026 10:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790332036;
	bh=xV0zw0Q7IQMSkiU/SQQ9pgJXpKqIp+csK9nbXVynRnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lw16QUasMrbf2ehZFmi/n2e+YyVirGoNCDt9qIoppC/EWnzsSrHZgpJf2Dzi3G0Bg
	 fTF8dg50qvxsnfqwj5isv9/9OQ26pBGFlgGTX2c3tjWfAkZlYr+ibV9lL7t2PymrUw
	 Sbs7vJIewjmd/FjZ6TZcBgkSMpfxCdwIhFLKfY3dMTwCkvedERJrb9vOS+CHBTlmxR
	 XEv4e6qb72JXg7VGfhu2mwDTIJK/h981twA3GD9JfzlE7fT0nvVe5vIOkfYLgYE+NT
	 yp3K6kUQPW4JiyRvKAYUpSBarAxKimWhIdgo0s++JA75szeJjRB+8Iw4AMHvIxOb5d
	 4GOfhapgqlDfg==
Date: Fri, 25 Sep 2026 12:27:09 +0200
From: Gao Xiang <xiang@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Gao Xiang <xiang@kernel.org>, david@kernel.org, muchun.song@linux.dev,
	research@deepseek.com, sj@kernel.org, mst@redhat.com,
	damon@lists.linux.dev, linux-mm@kvack.org,
	virtualization@lists.linux.dev, ryncsn@gmail.com,
	kunwu.chan@gmail.com, lianux.mm@gmail.com, baohua@kernel.org,
	xueyuan.chen21@gmail.com
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Message-ID: <arZMfTVu4t4hdHKD@MacBookPro.fritz.box>
References: <9f63d60c-913e-4e79-9d28-890dd48ef713@kernel.org>
 <20260925081504.23569-1-lance.yang@linux.dev>
 <arZKFznn4Z2LvoJN@MacBookPro.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <arZKFznn4Z2LvoJN@MacBookPro.fritz.box>
X-Stat-Signature: fzdkmk9p395q6ctcrnb1ouf9kwjk6h53
X-Rspamd-Queue-Id: 38D3E1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790332037-701327
X-HE-Meta: U2FsdGVkX1/8BaNTMorupH7dFZTy0/eV22j9Eg6iAHFPCYtRwNPFmqJAGZ/djmjl/TSM4ijlTvqpwcGbfS0QECErIe9HsV0oQj1SlxFJxaMo9qq6F0Av+1zWNek5qNxh9U7JXgmJ+JDhpmP9mV7Z+yaZR5DVHr1MG3ImggjSIZAb6PXyPARXl+3smh1byiApcToUuodseFaJC/f3BFZ7LtrYBe9eawvaBWZLU+6J85KyKCdfnERy7RNqd8gnxcl6K2ej9bpkaR4PnYrNm4a73vjPb0PVwAPRHirx3Fx4icOfqDGYk3Yvt9/7kQbDZxrlstvgT5Q4QSgYvX+ReTagcSnnKuSm0spyPMP3vgOo96+kbAkpT5ceOjvs4BkoAvtBJQLPggnezf8Rwx5Rn5NhOPkoSEoFRnZD6/FNEIZ8+Ku/8Yo18BD5Qz0SODjrzX12DyTWeo+oQdjnX2xHwuH1DRHekCAzdOBLf01I/ZODqPpCBqa84a90P997PlTxRaEXFLnDB2rwB1vc07KuDr4OExyroSNmz6Ef0Ufb7JeWWlzDJ8Ksa55AORvPSDwRRbdHc/dR+jeqhSrXILaUSTatu9MeUfwS1Of/FUlxw1NUQTK6gzLSSrSO3IoPkPslYaaS+FC8ftmAbVgaulHuBBmJ4gQ4QPhKKrVSWOMlVA4le0dDSRN9sulvPasFirpLMBBLgXeJ85VaZoynMfGr5sUdbTw6h+PXz+Gvbp/XjS7Pw7m3l/d0wqlmdn6iNzD4XqS1KkiDIK222BM+HqE4g1hYfFiD3A7fWgdkQRVB4KDr10DA+iR2Wapeq6LT1Hi2lDkiXQ1VhkFt30tF+mvevRf4ELf2jiyBdZjkBDfFpQ1lWbKm3fJdW9FPeidjvYwSGCO4fItt/rNRj6jYMGvRx/kpTZgAM++HFS19um7iHyKr2rYSiIKJZ5KY9pV7Bw/iHaPuZk4tu+IzCvEjai3YtfK
 0KADNUIJ
 gX8v+sC17ZMREFXrNdulJweIsoKGVrAmDwloQjLgqubu/8fUeJPedrny4oXGzbH3LmI6sKjrDxqt+jt2LsC9mJEepfdBIFG9JkiuUOnzW1orFkDmDULQp7GsbWBVzmQiVYreeKOzJ0Rewoi4Vp+IbNByy5QRE2eT2O20sEHKV5VDMoynlLvTXjjHVuXZuosRZEPGoP2krNjSB+LsFDWrRmT2OtxgPuf1zv6BrzHpYuHD5VIZOIssSEwsnytxMk28C4XP8y3X2/XludzMPqJ8lMV1xuRgy1wJmFe3+ky+ddwPYDeDj9VdRpc3huZ2zPfzw0fg2PAmmj3PBA4zW3BQVSGgkYzlUg4qmEohs8G0n8+7JnouN6hQvGF2BRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 12:16:55PM +0200, Gao Xiang wrote:
> Hi,
> 
> On Fri, Sep 25, 2026 at 04:15:04PM +0800, Lance Yang wrote:
> > +Cc DeepSeek and Muchun
> > 
> > On Fri, Sep 25, 2026 at 09:04:41AM +0200, David Hildenbrand (Arm) wrote:
> > >On 9/25/26 07:44, Lance Yang wrote:
> > >> Hi all,
> > >> 
> > >> I was reading DeepSeek's new DSec paper[1] and found a nice use of DAMON
> > >> and virtio-balloon:
> > >> 
> > >> With this kind of workload, an agent may read a file once and never touch
> > >> it again, while those pages remain in the guest page cache. Without memory
> > >> pressure in the guest, they can stay cached even though the host would
> > >> like that memory back ...
> > >> 
> > >> The trick is DAMON + virtio-balloon free-page reporting :) DAMON reclaims
> > >
> > >Heh, I read "virtio-balloon" and thought "balloon inflation/deflation, what year
> > >is it?!". Free-page reporting makes much more sense.
> > >
> > >> cold file pages from the guest page cache; buddy gets a chance to coalesce
> > >> them into reportable blocks, and virtio-balloon passes those blocks to
> > >> Firecracker. Firecracker can then drop the host backing with MADV_DONTNEED.
> > >
> > >When I was at RH we were looking at this issue as well. virtio-pmem was one way
> > >of avoiding the page cache in VM entirely. But it has its own limitations.
> > 
> > YES, they enable virtio-pmem with DAX for the read-only EROFS base-image
> > and toolkit layers, while using DAMON with balloon free-page reporting to
> > reclaim cold file pages from the guest page cache on larger writable disks.
> > 
> > They also point out that the guest must allocate struct page metadata for
> > the entire pmem-backed address range. So virtio-pmem is not free either :)
> > 
> > BTW, Muchun recently posted a pretty cool series for exactly that:
> > 
> > https://lore.kernel.org/linux-mm/20260903122128.12264-1-songmuchun@bytedance.com/
> > 
> > (It shares vmemmap backing until a DAX fault needs private metadata,
> > avoiding the full per-PFN cost up front.)
> > 
> > I have a feeling the DeepSeek team will be watching this one closely :P
> 
> There are several points virtio-pmem RW from my own viewpoints:
> 
>  - It makes the write async I/O synchronously, note that write I/Os are
>    not quite the same as read I/Os (read I/Os are mostly sync). Storage
>    also support multi-queues which can better leverage that, and that is
>    why sometimes brd block device is not good at high-performance nvme
>    for example.
> 
>  - Note that sandbox usually has a memory limit, but dax RW makes the
>    whole rootfs addressable, e.g. if you have 128GiB rootfs, which means
>    you could fault 128GiB on the host, instead of the sandbox memory
>    size, so it might cause some security concern (as long as users
>    shouldn't expect the host memory can be used up to 128GiB + memsize).
> 
>  - It can cause sync 4K faults on the host in the worst case (maybe
>    large folios on the host can improve a bit yet not quite), in
>    constant to the guest memory + THP usage. I don't know how the
>    reclaim overhead is measured currently, but it seems the dsec paper
>    also mentioned in this case.
> 
>  - The guest workload will still use mmap() for many sandbox apps, so
>    `struct page` optimization is just for the optimized case, but not
>    for the worst cases, the malicious VM sandboxes can still take
>    much more `struct page` in the guest.
> 
> There would be better to have some benchmark here for typical RL
> training RW virtio-pmem: but block storage semantics cannot already
> be replaced with the memory semantics.
> 
> I think virtio-pmem RO is useful simply because it can reuse the same
> page cache among multiple sandboxes on the host, which can even
> warm-up other sandbox workloads, although it still has some security
> concern but I guess for RL training it doesn't matter and read is
> almost synchronous unlike writes.

BTW, I've thought about the sandbox writable layers for a while, maybe
EROFS could have its own dedicated efficient writable layers as a
optional feature at some time, but I need to think carefully first
and look forward to get more numbers before landing a premature
implementation to the upstream (memory semantics, storage semantics
or just a overlay + hybrid approaches); also there are some
non-technical points to move forward in this direction.

There are some other important features which are more like low-hanging
fruits, so I'm more in a wait-and-see mode until I get a sensible
direction on this sandboxing scenario.

Thanks,
Gao Xiang

> 
> Thanks,
> Gao Xiang 
> 
> > 
> > >Thanks for sharing!
> > 
> > Cheers!
> 

