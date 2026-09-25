Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 141C3C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317FB6B008C; Fri, 25 Sep 2026 06:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8DD6B0092; Fri, 25 Sep 2026 06:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DED76B0093; Fri, 25 Sep 2026 06:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E961B6B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:17:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8662E1A05A8
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:17:05 +0000 (UTC)
X-FDA: 85251881610.14.4BC5DA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C96FF100003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:17:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtGYEP3N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790331423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FRgt93szZc+4T1rdPLugIec3JqcHLkBElvJ5G6NXcU=;
	b=OSygTRYwnbhabc6egdLg5149GDfAoTjBoYc78CRqFrtvpoh3fKiSLNpVByuIzEn27OuKdr
	rx8NPTgN5ec53ld/nfvnBfi0TopiGWIn6jjiE7kSBxudGGjDX060aORwN9pnL3PHsAWoqS
	2H+DCHv+WZfxrs1lVu9DcLXT8Uuyqvg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtGYEP3N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790331423;
	b=YNSFSPAh6fn+dHd/KUgylEyGWIVoH/Bdm97zERBrCG9dLek7eQ2Mj5/6SayO132tkCgZuf
	2yCUJymZKMenHbyTwYr9DdQs+PfDlADU/um6XeO6aYFueZdqw+k9QXYrl3Ly2YVTCGKYmL
	q2aIEtqcd1W9qSMyitfvLTEUKy87D6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 024EC418F3;
	Fri, 25 Sep 2026 10:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12531F000FF;
	Fri, 25 Sep 2026 10:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790331422;
	bh=3FRgt93szZc+4T1rdPLugIec3JqcHLkBElvJ5G6NXcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AtGYEP3NP6z0cet+t6hAByQryQKCWbDouUCH0PeUQ2awHZkpi+6rIVCMldPWEVSKf
	 9+jSNbe0LOKUAzeRl6KKWc4zt6UY1eTVJStbRPyTDFHesMobiYC1YYyOKZKwZXiZe+
	 D1VAKSQJvXBQHghzF4BkwoqG9ndtKculXbPssvLsU2/ghxmVQdP5/wJk7cXW1HP37+
	 VtWtoJyYlpFBkKngpFsxGclsdb5Rkc11vHzMJOIH9evXPqUS31GAu0J+PaGN1cCUMQ
	 H901LLkjHyVZqFIAnLBWKvxAZbvknfgIrL0gZgQ1koz/76jmaDvFRym5uAYo1h/KT/
	 DPSUorNZqt2Mw==
Date: Fri, 25 Sep 2026 12:16:55 +0200
From: Gao Xiang <xiang@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, muchun.song@linux.dev, research@deepseek.com,
	sj@kernel.org, mst@redhat.com, damon@lists.linux.dev,
	linux-mm@kvack.org, virtualization@lists.linux.dev,
	ryncsn@gmail.com, kunwu.chan@gmail.com, lianux.mm@gmail.com,
	baohua@kernel.org, xueyuan.chen21@gmail.com
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Message-ID: <arZKFznn4Z2LvoJN@MacBookPro.fritz.box>
References: <9f63d60c-913e-4e79-9d28-890dd48ef713@kernel.org>
 <20260925081504.23569-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260925081504.23569-1-lance.yang@linux.dev>
X-Stat-Signature: p6nd9495o48aykquqii4uom9j7tz6gj6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C96FF100003
X-HE-Tag: 1790331423-940244
X-HE-Meta: U2FsdGVkX1/iUIv9k4q9AIIeGoK6plo9I5jpFpw+kPyY+O9wu8cijxJkMXdeN/u1wrpsgYCOiuI+ipw4TDVTO/E7LA3MeNmc0jJfnjgl4TVuNMVDodCmf2ypUM+qY7LDxhziXbnTyHI/EQ7lI4oJogQhaNiudPQkrKtRKo8ziEG4+2yVxyVxrizzYByRU46hIRSa6CoIQIwa2wLiJwkXEkT+MDJ7znrg2+7vj+WBqQLpfvEZi8Fic0ZmFgmzrg9eK5WfvSoEM032+TiftjqjuCM2xZ9JS2p4xY0CyLT/FxJEKCZX1nf6hOhkGXw8wzwpM7fTWJfu/gtxI502FhKzhjlxcmVUSUjKPXg+4FiaXq7Ou83Ml/yZIVUUprj+4xyIgi0/BEsF/X2cy0w9seiXvRZ/ygVIrpym3I4C6+qxOgGqWCZXfDLO1DCRH81E44cAP3f778XYdDeoG7zqQJYUXoc+vXhx12eQGR3OIJ+X44QVbp+f3IL2yoImXU7UkqOiflPbTd9uBHx7N8FXsPXhn8hutT2PnGBjupPB0A2edu/hz7qHevNo18yxW+Y6Sn1rMZjaGhs6kn44+K1SzAKMA6xKz7iWYVxzaqNwRapJhFPJ9pKQpGp4M0373uCBgtJ4TdPY1DmJIlzAY4P/awbA8/0Pw8Se73z4ESFgeHN8D/OpuZ6d/lh6Dg9jDIPOExzm5RgPOKffWtRvr5e48L3ur0q5Au2BVzfx+SraB8/MP/KWroxvT8EZi5DfbGHfFX5+W/g06VHFoGsN7iEPdJ8iYJF3yCNkDnR9mk5rRjRM6QWa0sIC4uYJkG8jX3Rz/QBukB0qr7kB3wK3pwUCzHVCKOmZb/t6+wjBZZlwlPEQUkixmB8pow2xSq3Gn+HnvigXXFm+ysXI7NKcaacnd8+llplxl3lZb+KVaV5Co0PPtUz+3XvG3Qqs9jHW0ZIpPNKmaBVqAr30EHw506EqHKr
 v1JSdvsl
 jBOjC0UxLjor6euKNuIV/GQY2254vK3ggCLIPAmkBdnnf97m+g4la6nS7wlO50MoeL/yMzSJaDgheUIZ3KHbP9m5Itb34hmob+j1zhD17jnKZLXFSVPUsZhf5dScBEdKygHl0EdudAadJq0hRC9ZTZI+67uvCqWqKKlyuJZW35RAVzOy8hvF7TuXNtydxTBc05ND+xQU1tL3OMCeRY8mPi69/PCkAT6qabGV9TRXlAG8ij7BoPtg2pQPlqDoMjdqYtoM1p6L2TXUV7aP+6qAF5kmm/bko/XUITNdqfPg5OZ4Up+sZYNCgBx+fbagJ6sKBe5YNs23Eq7eeQrWS0JoiXRnZDBOqUQIsFCG0CB69B9O91bPEUIDkAaiYDbQbNQXgY4JF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, Sep 25, 2026 at 04:15:04PM +0800, Lance Yang wrote:
> +Cc DeepSeek and Muchun
> 
> On Fri, Sep 25, 2026 at 09:04:41AM +0200, David Hildenbrand (Arm) wrote:
> >On 9/25/26 07:44, Lance Yang wrote:
> >> Hi all,
> >> 
> >> I was reading DeepSeek's new DSec paper[1] and found a nice use of DAMON
> >> and virtio-balloon:
> >> 
> >> With this kind of workload, an agent may read a file once and never touch
> >> it again, while those pages remain in the guest page cache. Without memory
> >> pressure in the guest, they can stay cached even though the host would
> >> like that memory back ...
> >> 
> >> The trick is DAMON + virtio-balloon free-page reporting :) DAMON reclaims
> >
> >Heh, I read "virtio-balloon" and thought "balloon inflation/deflation, what year
> >is it?!". Free-page reporting makes much more sense.
> >
> >> cold file pages from the guest page cache; buddy gets a chance to coalesce
> >> them into reportable blocks, and virtio-balloon passes those blocks to
> >> Firecracker. Firecracker can then drop the host backing with MADV_DONTNEED.
> >
> >When I was at RH we were looking at this issue as well. virtio-pmem was one way
> >of avoiding the page cache in VM entirely. But it has its own limitations.
> 
> YES, they enable virtio-pmem with DAX for the read-only EROFS base-image
> and toolkit layers, while using DAMON with balloon free-page reporting to
> reclaim cold file pages from the guest page cache on larger writable disks.
> 
> They also point out that the guest must allocate struct page metadata for
> the entire pmem-backed address range. So virtio-pmem is not free either :)
> 
> BTW, Muchun recently posted a pretty cool series for exactly that:
> 
> https://lore.kernel.org/linux-mm/20260903122128.12264-1-songmuchun@bytedance.com/
> 
> (It shares vmemmap backing until a DAX fault needs private metadata,
> avoiding the full per-PFN cost up front.)
> 
> I have a feeling the DeepSeek team will be watching this one closely :P

There are several points virtio-pmem RW from my own viewpoints:

 - It makes the write async I/O synchronously, note that write I/Os are
   not quite the same as read I/Os (read I/Os are mostly sync). Storage
   also support multi-queues which can better leverage that, and that is
   why sometimes brd block device is not good at high-performance nvme
   for example.

 - Note that sandbox usually has a memory limit, but dax RW makes the
   whole rootfs addressable, e.g. if you have 128GiB rootfs, which means
   you could fault 128GiB on the host, instead of the sandbox memory
   size, so it might cause some security concern (as long as users
   shouldn't expect the host memory can be used up to 128GiB + memsize).

 - It can cause sync 4K faults on the host in the worst case (maybe
   large folios on the host can improve a bit yet not quite), in
   constant to the guest memory + THP usage. I don't know how the
   reclaim overhead is measured currently, but it seems the dsec paper
   also mentioned in this case.

 - The guest workload will still use mmap() for many sandbox apps, so
   `struct page` optimization is just for the optimized case, but not
   for the worst cases, the malicious VM sandboxes can still take
   much more `struct page` in the guest.

There would be better to have some benchmark here for typical RL
training RW virtio-pmem: but block storage semantics cannot already
be replaced with the memory semantics.

I think virtio-pmem RO is useful simply because it can reuse the same
page cache among multiple sandboxes on the host, which can even
warm-up other sandbox workloads, although it still has some security
concern but I guess for RL training it doesn't matter and read is
almost synchronous unlike writes.

Thanks,
Gao Xiang 

> 
> >Thanks for sharing!
> 
> Cheers!

