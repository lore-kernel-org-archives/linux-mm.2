Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57CC3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4876B00A6; Wed,  1 Jul 2026 05:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5456B00A8; Wed,  1 Jul 2026 05:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCDE6B00AD; Wed,  1 Jul 2026 05:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1217D6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:04:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B6371A02B8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:04:02 +0000 (UTC)
X-FDA: 84939620724.08.4393D76
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf17.hostedemail.com (Postfix) with ESMTP id 434744000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:04:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=M8LfqDYd;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=aAtI26ZD
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896641;
	b=Lt4Ao7D29bQeX2RnlISRNihBTDCCe7tG/MasmbJ38iPCmv6NVP6UmRfEdnHhIq4+LDDqXs
	66oDAx4MMHFja39pdzF6enp/ibnxtoHBALC2Y2qQx31ARWN7ynxNxTu79GUPczRxdGVro4
	VAsofdH1vwAwqaw9HrbtwJPwU7ReKNs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2I4SEOxas6X0x5H7zz6wH0Lfb6ZZgh0f8mcYajOzvc4=;
	b=yg33KPz5yRN4vAnH2mphYe9VDLtuPbGqOcImDdQoJg4ec331VbnAe1WcMoNWA536DtQ0S0
	2MyfJEOAI8MU5EcH7xthqnM2EUnuVseRNpnEfwnwQ2eUPN/e4MvFwSEl0aYd7hzkx7HB8+
	G3BMlHuHC31B8Fc9OTh7tOeebAEBk2Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=M8LfqDYd;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=aAtI26ZD;
	spf=none (imf17.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1782896637; x=1783501437;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=2I4SEOxas6X0x5H7zz6wH0Lfb6ZZgh0f8mcYajOzvc4=;
	b=M8LfqDYdrxNmY6wM9ssCGtFKfo1sypg4ZbtkSenfafxQDvH9IMfhD44UynTuwLB9Hw0Qwgfo2ICZu
	 eWUKJC1nUMJOxNA0nFml8AZRouIEJmvI3l3V4ihlgsIuwchepcql0xdoV3ElGLLF/xQzEO1SFlJCkc
	 cYYOyzbyOM4KsieeNmZf3FtPPrqRuwjCOU0Q8+8Gtxjn6klEuht74qQhWj6hwx+BrRM/NXfwDM6qNe
	 eTcuo2bRWcx5vg7tGRgEQyxANAeyjs62txgoWVpDfbmAQGKbwA5VK+KzR3YkAkywY4i6kZZkZ5T9z0
	 G1zVpQgRIMP84CiwE6HCAw3ZZY1XARg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1782896637; x=1783501437;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=2I4SEOxas6X0x5H7zz6wH0Lfb6ZZgh0f8mcYajOzvc4=;
	b=aAtI26ZDbZmqTZCwHgKvV78ZV6Jz/T53rPuFdKmoYl8nQ3SZmDExBtXiXcfeM5nDrzylNZWcSD9kT
	 rKHZcHHAg==
X-HalOne-ID: ca031a73-752b-11f1-9565-314137fccf3e
Received: from localhost.localdomain (c213-102-77-204.bredband.tele2.se [213.102.77.204])
	by mailrelay2.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id ca031a73-752b-11f1-9565-314137fccf3e;
	Wed, 01 Jul 2026 09:03:57 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-mm@kvack.org,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: Re: Re: [PATCH] mempool: optimize mempool resizing
Date: Wed,  1 Jul 2026 11:03:51 +0200
Message-Id: <20260701090351.869635-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260625131738.b7c10540e5c598cc9b60e19d@linux-foundation.org>
References: <20260625131738.b7c10540e5c598cc9b60e19d@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 434744000E
X-Stat-Signature: cnt48bsgzfhrnwdz7j9zkd4j5ieqy91d
X-HE-Tag: 1782896640-266009
X-HE-Meta: U2FsdGVkX1+fDEduCwFtBfhbFfx27nc9x0ZkfT36eYFEwv+X4/B0ovw3AdkUxuTvdrwmoKSTfr7YFnbJr1EPxn/KL8BC6nkB/HgqRK2yjcap8qCWjfigQsgb/97F6VvayKWCvW4y5PY8yDLzPOvogZtU3WI7zU5agupcGgqn7wWUVDFIoNT1VG6d2xpdioy083hWH/pQWnRrAUJjSjFB07MAx+mftLwwcQ2Oxw6ZuWhKUQnKNlxJH6yKmIzyQyA1VDUIVK+gJsRoRDl1Ipt5QkxPrLW7ugJK7szt/fBDDk04Q6cF1MF9AgflWdq/R/w7+6VH4vSr0nd7Qe9a3Vi4sdW+KRO8djx+7BZ+bvdVPv55ZfnXMFcKlTIJl+DjLdUxRtBNj2SY8hpZfjsvf1kHris4kinIES3epIF5Ln9YEAm0tCLF7sY9noh7l/oWm8OMLeDRQ16KLNGrezI5z7qoY/W4G3GmOqyIhn9f6EO/TA1G5g+/kG1ofkRWjxblwfopZXPz0jL03oiM/FaxSaucKW3gCSJ25QVxmLfR51FPaqQBuEuGtWmf60u4i+4ryC4gERXurIbXyKtwcJUc2TXVpW7sWi6fHL+JyX9iQ1GA/vohsBGSrcXyejLpI1UCwIsS57xkzZ7mpFrlNx0mmk/fVlZdxewYx7TGRQ/7iXjwJakHGMDiGb9WeIxitx9adZzRYTn1OBA2Cjpw7aKAh7qbQSdKIRruzjI2DY8dbjQOYTvxwyrSuJOxF7oVzQKvYuZahCLcFRdyz9UdvAp3DYWzGa11CtE5RdmiJauV5M4O7ceXArwi0lb7qlKC+B9TEffXTI7gUKSo9GIL4XhMxkD6CjcSb/sWkN7gR8Lu7Q/YfDC1T7Iyi7r1zEYklEjRgb30Y6IVhV1PqyEvQK2DYfhedEFQI8GMAUwf5CRlcaVBEF9FKv5djUSfgbf2Ts0N8G+rUaln3bMy5C9DXrd55s2
 +lKzma0T
 Od1xC0TEPG0Y5qXOl8+Hx1qcW/ZwSWIiTF9O49mL5HQ4WpM/FQ3MefX2JbdCM3hFnOZuQP7NxcnblXxo50aOCofCdGhK8Ia8cBC9KV6pc95XkRs47DULvTlhInenummN6lwVSPMG/COnR8pHF/3DJdkUrC2UlQm3rpjJrP0Dgxx5+ao/8UXQstOmXYR5s8B2v6ziku9clxxwWkenotbrkmcgIgnLNRfB+mFSHZJ6OUslO9lC2J7q2H6oih0zdNh/+vZOuel+XyVP3dN/oABKxtZ/thQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew,


On Thursday, June 25, 2026 at 10:17:38 pm +02:00, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 25 Jun 2026 21:49:15 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:
> > 
> > From: Vitaly Vul <vitaly.vul@partner.samsung.com>
> > 
> > Resizing mempool to a bigger size currently requires a new allocation and a
> > data copy to a new larger elements array which doesn't go well with the
> > idea of having a fast and deadlock free memory allocations during exreme VM
> > load.
> >
> > This patch introduces a new parameter max_nr for a part of the mempool API,
> > which denotes the maximum size of the pool. With it in place we can avoid
> > any allocations in mempool_resize() since we can either grant the resizing
> > request or reject it basing on thr maximum allowed size of the elements
> > array. For those few users of the mempool API that actually use
> > mempool_resize() it is a clear upgrade because the maximum number of
> > elements is known upfront.
> >
> > Derivative APIs (like mempool_init_kmalloc_pool()) are mostly left intact,
> > substituted by the new mempool_init_kmalloc_resizable_pool() API where the
> > pool is actually meant to be resizable.
> 
> Thanks.
> 
> It would be helpful to have a description of what inspired this work.
> Presumably there is some observed problem in nvme or in zone-blockdev
> use? Can you please describe the problems and also describe what
> effect the patch had upon them?

We are using mempool for a variable number of large buffers, the maximal size of the pool is always known. However, as these buffers are large, we don't want to waste too much memory on a saturated full sized pool.

Besides, it takes a lot of time (seconds!) to saturate such a pool and we would absolutely love to avoid that.

Basing on the above, one can conclude that we're using mempool_resize() quite often. And for that to be efficient, we need to know if we can grow the pool  without having to re-allocate the elements array and copy the data. 

Since all the existing users of mempool_resize() actually know the maximum pool size for their respective cases, the easiest way to implement this is to introduce the hard maximum, and that is what this patch is doing.

<snip>
> Seems strange to return -EINVAL if new_min_nr is too low, but -ENOSPC
> if it is too large.
> 
> Also, (pet peeve), ENOSPC means "No space left on device". If this
> errno ever makes it back to userspace, the operator will be running
> `df' and wondering what the heck happened.

Hmm, I see your point. Let's go with -EiNVAL in both cases.

> Also, AI review had things to say:
> https://sashiko.dev/#/patchset/20260625194915.387663-1-vitaly.wool@konsulko.se

Sashiko is doing a great job indeed. My 2c on that:

1. mempool_create() should create pools with max_nr = max(min_nr*2, 1); and this will be fixed in the next version of the patch.
2. There were no forward-progress guarantees during pool growth in mempool_resize(), this patch just makes things simpler and more obvious.
3. pool->min_nr update will be fixed in the next version of the patch.

Thanks,
Vitaly

