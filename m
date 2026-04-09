Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2FCCF364AF
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E8E6B008A; Thu,  9 Apr 2026 14:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166386B008C; Thu,  9 Apr 2026 14:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A34E6B0092; Thu,  9 Apr 2026 14:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F26A46B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:24:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86462560C9
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:24:41 +0000 (UTC)
X-FDA: 84639843162.25.A67CEE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C136040003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:24:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C7HMAE1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775759079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2yUfjrS12dXVy2I2I++13aaB8lz5ESIf/F8Z5xPj1xQ=;
	b=h0ZT0atmLsdvL8QTfx665V+YDuCqqkKMBhkN2gKmKzKuAnUbK0pwluiR/OInQGXxHRor7o
	R6r0HFeRPyziN3kBFSk6gTwwz1+kQWeEwO9cV1EguV1M+xhl0FzRFstrP5drFn4bGRruPJ
	xuH1c47Ck68beKJ372imBFRJepvXp6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775759079; a=rsa-sha256;
	cv=none;
	b=Vpk3x0KcI7T3iM7JepiY8PLhV/yCHXdd5I9fFB9+OMYBXgepwDcXkJhlE6Hbm03oMq9h5V
	SFaHAPe1/4Tq6ryrjNEGRLOk/7fawGk9mXYuNnaY7hFxKLoE/5f5c1sipVZvaxow6pSDB0
	hATazf+oSiAncbUNELQsYJJtqiyV5E4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C7HMAE1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBFF9404CF;
	Thu,  9 Apr 2026 18:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAAFC4CEF7;
	Thu,  9 Apr 2026 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775759078;
	bh=2yUfjrS12dXVy2I2I++13aaB8lz5ESIf/F8Z5xPj1xQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C7HMAE1wIjLoFqwoZ9KRCPIpLMD+2AB6gOcofs3RDOghYizSLrg1kz0xFZT7PZ1y0
	 mr7PUIYnq07w+Wo/J3DpzigXjix9c9c3ifQeneJNMl1/35/k8ES7UaGuDJplXgzObY
	 FQb6q0ccPTXBASuY016zzHxrRAbqbv+es0yJ0bM0hIksv79GpkzJVOcry7teBV1PZV
	 AvweqCwYDvKCJ6pcMXD/kLADl09zIB+mHyEjN3BLLMFor4r+FvvaoCpDnGS1zO/LN1
	 q26UgqsPVvxWvSjj0ZFUkYZfTgHT3dxHuQtRfgVamXmbpP0Ue5ovl+mRso7fxRaB6p
	 q7nrpkvTY0/aQ==
Date: Thu, 9 Apr 2026 19:24:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Joseph Salisbury <joseph.salisbury@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
Message-ID: <adfqY3ayAHvACm4q@lucifer>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
 <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
X-Rspamd-Queue-Id: C136040003
X-Stat-Signature: 4q3rcwhkquscqyt7qynuf6c3zehcy95h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775759079-817367
X-HE-Meta: U2FsdGVkX19+Cmw+ket4/kXsWhkXIuh/0sR65LEEhQJ4KVgUfq06aSViyIPGhWQ27NAYowr1jR6Arp4LE2gTyF/jkKRV4bfrTZu6Vn0FzEkTidKNs33Rs3rsH2TM2vNap8j3WQpc+TPY9RPm9zYvxc9sqIGdQ7O+R4QipK/DqCDtLyWfwi479y+9nbJ/tvFGOp0DFqHEn5kA+Ofc2dPkmcbidaslpH7FspruMDFECpTAYG7FK1itabParfzPXsMcW/p/4f8dRLTdlFjc2I7+WLZrXTFlweZ2Lz1Msr2xD4A7QqpNxaadAx8TyurFm199N5cfcB86bjcXIp5VvXC6NRdcqR525SOVaDuIcyrzxDORbAlxdOxpgujF9pZNcpofKXvvu4UhC+31eLI84JqxscUF7advSTc4B+tdODtX0LqHPod1Xd/w4kCCKILJVY7+aM2KQOGwLcV+rR337eY3ad43NumOHC6T3nCyAcUZ9zCU78dQnu+aHtHC3zHZ8JDwZvtpuB9FY/con/E/YxTGXymDma2sgwN+EihYH39rNNhudNFfbJekfck5Omj8RQ8w/x85jNCXopJMI9TtDvyE4Qhq2rViW9Kj8yn537wuR8rPvjKD3AFU+bdRTkgN3/ZfvLD4Pt5BMhhYJ3EYTmNZsVZh3F0SgxGTc6RdK+DH/5E+6zB1cJRz5KSmjioAYkzA06ym43vEPvHD9lN7hNelRHWohAuEa+PVSdAeL9zk8HiufihV/einRsl0X3kAAncRltnCodobpx8f9XgaSbr1oWJBDvcIKkRkI96hsf6WxGxZkLQmIFzH41EklcpK7T1Tfyl8YEZLKDCEA+FiTONkP389lmaJYhaOrXnOZEyPOxtCsMtuQDrzLujlyalCgFb2DIcp3h/Pg8n9L8n724uXJu0WIFnJNS5evQ9at2LBjnq55gmAqISCu/iJMioTu4a8ggbNEnw2tPwrl3TObPq
 bc6lp5PI
 hjABXKrRlfWD4uvsxTZqsZ8vG9Lsx+t+S1bPZRMVpMbrVRfhDhGQkga99psjgfZvOByBlZZjkTIKBS5QbBh0SILcdU5bxftQzhwEth7suuoDeUrsDrHq6js4xILUw8i++U8auJlU2efUaDkKPDXnyK8rsCMW/Wa7BM139E7dXfnMQYJIbLmu1Mq3x7PKaOKVsJL4mSONg7SWmePZg0AbVrlj7rX6pNimcCjp71KonhnFgUOA1Zk2HgzQ/XBaTl/r0w4tj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 10:09:23AM +0200, David Hildenbrand (Arm) wrote:
> >>
> >> It was also found that adding '--mremap-numa' changes the behavior
> >> substantially:
> >
> > "assign memory mapped pages to randomly selected NUMA nodes. This is
> > disabled for systems that do not support NUMA."
> >
> > so this is just sharding your lock contention across your NUMA nodes (you
> > have an lruvec per node).
> >
> >>
> >> stress-ng --mremap 8192 --mremap-bytes 4K --timeout 30 --mremap-numa
> >> --metrics-brief
> >>
> >> mremap 2570798 29.39 8.06 106.23 87466.50 22494.74
> >>
> >> So it's possible that either actual swapping, or the mbind(...,
> >> MPOL_MF_MOVE) path used by '--mremap-numa', removes most of the excessive
> >> system time.
> >>
> >> Does this look like a known MM scalability issue around short-lived
> >> MAP_POPULATE / munmap churn?
> >
> > Yes. Is this an actual issue on some workload?
>
> Same thought, it's unclear to me why we should care here. In particular,
> when talking about excessive use of zero-filled pages.

Yup, I fear that this might also be misleading - stress-ng is designed to
saturate.

When swapping is enabled, it ends up rate-limited by I/O (there is simultanous
MADV_PAGEOUT occurring).

Then you see lower systime because... the system is sleeping more :)

The zero pages patch stops all that, so you throttle on the next thing - the
lruvec lock.

If you group by NUMA node rather than just not-at-all (the default) you
naturally distribute evenly across lruvec locks, because they're per node (+
memcg whatever).

So all this is arbitrary, it is essentially asking 'what do I rate limit on?'

And 'optimising' things to give different outcomes, esp. on things like system
time, doesn't really make sense.

If you absolutely hammer the hell out of the populate/unmap paths, unevenly over
NUMA nodes, you'll see system time explode because now you're hitting up on the
lruvec lock which is a spinlock (has to be due to possible irq context
invocation).

You're not actually asking 'how fast is this in a real workload?' or even a 'how
fast is this microbenchmark?', you're asking 'what does saturating this look
like?'.

So it's rather asking the wrong question, I fear, and a reason why
stress-ng-as-benchmark has to be treated with caution.

I would definitely recommend examining any underlying real-world workload that
is triggering the issue rather than stress-ng, and then examining closely what's
going on there.

This whole thing might be unfortunately misleading, as you observe saturation of
lruvec lock, but in reality it might simply be a manifestation of:

- syscalls on the hotpath
- not distributing work sensibly over NUMA nodes

Perhaps it is indeed an issue with the lruvec that needs attention, but with a
real world usecase we can perhaps be a little more sure it's that rather than
stress-ng doing it's thing :)

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

