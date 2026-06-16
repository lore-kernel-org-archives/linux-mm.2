Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31DCCD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BCBC6B00A8; Tue, 16 Jun 2026 16:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494DB6B00B4; Tue, 16 Jun 2026 16:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1776B00B6; Tue, 16 Jun 2026 16:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106FF6B00A8
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:55:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9993B1656B0
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:55:51 +0000 (UTC)
X-FDA: 84886982502.13.6AFF8C5
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8B10C0002
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:55:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n6JMByQm;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzBAgympJtYUEU+5A/fuaOCbTXFBDK/+39XU8Cb2Gw0=;
	b=cunqhDQV/MUlOh7d9vmvxmerxdyGOdXYuZRoEd71fgh0dZWK5tsBAeNNowe9/94b9Y9KXN
	p8SpMd1Ej0n8kmr6oVkpIouWVjUTX+C9dJSUQGXzN+D9+PsEAyGPB8XmMky9hZeDtT3NMD
	9104cVSIU9UZTF7CKkkq+R0PQA1Oty0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n6JMByQm;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781643349;
	b=Ffm/PkY6ZLsoNUu3JXqM960Imed78A3RfY53iCq8nlUVokGqaeM7DN/89BglbGKSmaLz5L
	ZPcoJwupKszQ65kV4HkiV6f7l7o9J9gM0fVW4ExKqtSmtRiwnbyfyYWfnlInn7PFjA/+8W
	wM3mR2kcTPqy08pZZ4xj+bDbktCAceg=
Date: Tue, 16 Jun 2026 04:44:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781610299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzBAgympJtYUEU+5A/fuaOCbTXFBDK/+39XU8Cb2Gw0=;
	b=n6JMByQmgnXBs9uYwcuDjqLOej3/SSY5IJg6+zETivRa94jrYvges1yy88DGQpfnU1wfTC
	JtgEGCDMOXGGdJ2z6k+EbIOVRclJsdyL6GJduFnKXhLtBKGlu/g57kP39Qc+frioDcNjsK
	/b0ZHxnp2a5BUzcROVXUjY28bc3A0SU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, kasong@tencent.com, baoquan.he@linux.dev, 
	joshua.hahnjy@gmail.com
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
Message-ID: <ajE2zScfb2yznbGf@linux.dev>
References: <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
 <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev>
 <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev>
 <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B8B10C0002
X-Stat-Signature: 5j4odg79ibk4cinwujr7ospgfyxqsmyx
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781643349-133370
X-HE-Meta: U2FsdGVkX1+1F6RVyXkDFtpxPUei3VVoZGY3qWLFFc/mqSLpQJt8TVWuxMHZLdUzzBtx10LIArCuuq8skzgGS+2UWY7KM9LzDAWbhthm+3/Jou691c/oGGi1XjDdsJ4Qh/F1Un9LV3HPt+5A9hiib1u+gBJuV2My532N34WxHC8IRBxfW+NpROQzgkWBvu1Wg6bEQGw2KLTvveMZTev+TNdSQAh8bJhWbF3d2u7VWF3WpOc6KDhXZbXDnWl6nE0S0DbOmBPZectU7VHAK7jLD/wOdCYQLaBsdIZO44ciWgsIzH/5jI9VA6iS245bPlP4x2zrP2iwDXsuDWyoC8uR0QQd//JYe2AtLcWbRaLNrxgR67JmwB9/Q+z4HhPhGlZAfVeiYoFfLfVdch28KmEZV70JgyQRhdsRH1xfIEy/Q/K1LYr1/BWeMJlukg2wJC6ioEvKOTR/Z+uez6SGN4cAhdXC5OylDwizxNA1aq2l2qEb4UXJZd7JjvWwvVNWtzDiFUfX7bUKNTRK6+yPjjg6nSmnItkRoWjj8vMkbjyAuiaZdvfi3apbdM4EJ1dP49X+ffJK39SkS/2ZzkJSTeGLBqTASo7YjOp/atEdNqtmbLrkPVPWgzWd3nDn0PgE/WZbkXezt3rxPL8UHKE9wFaE8cN6BGN/RU4iPd7Tu4VDMM1E/ZdsWGXbDDk4kfaJ5njwW0bKD2Qr3DiY09H2pwGlzmuu64+YD105XbvkeIQai6dCKRaWtk4+6eweVOc4Ln5qTAlAksVAsHJYvFrclvGSIuTTt4Lfa+10AKdzMm75HwLb7S/u7IuuoxpLM6UKNhppwdN8TlCN2LxVLS2qbwGjBDofquW2mbWv4GF2P8OE96HbXFwmdc/FjeKdLZc6rEgopIzoa4djd0lx0a5YF5NNNsINykyRUMnxwARljsZ0hiQ6XPR2RX0lrZjwRC7HPdGLRCyMJAykRsx/V9SG1u+
 l6ZNh+le
 U/jHEHjJBBut8+5LLYxPBqOzOpuviWVL7ci9bL0M1bEwr346A5/4WJ2wXqK3HmIHHp8BUPDyOJsnr2Sl2+ROsepThsfe1b+wDFxNlniXE9msWuJXs7zvc97E9tuVHvffRwwVY8rP+v+KimEmwqhIgGwUNQY9sDN96JOF+jVcFy/82y9HEIYHm2Zwx6G8Kj/ktvcypIjg/6xWSUP8KqhzaRSNZicEg7KrHnf/kHRlvy8EKxR7LagMx0fJsIVN7y63Y4ZtHIF/ZtuIFDrLtXoqtBZ+ZhDrnV7yyfSnI1xUk2/2SM30mnrM6gjG9JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 10:03:08AM +0900, YoungJun Park wrote:
> On Mon, Jun 15, 2026 at 12:55:09PM -0700, Yosry Ahmed wrote:
> > > In that case, the internal logic could stay roughly the same rather
> > > than counting via a page counter. Something like:
> > >
> > > 1. Change the interface shell: tier.*.max — allow only 0 ~ max.
> > 
> > What about a single interface as I suggested to remain consistent with
> > memory tiering?
> 
> Hello Yosry!
> 
> I agree. As I was implementing the interface for seeing feasibility
> , I reconsidered it. Since swap tiers can be added or removed at runtime, 
> having static memory."tier_name".max files seems unnatural.
> 
> A single interface like `swap.tiers.max` would be better. We can use a
> flat-keyed format (similar to io.weight. same as you suggested)
> 
> echo ["tier_name"] ["0 or max"] > swap.tiers.max
> 
> I am now leaning towards this is a better direction than what I initially
> suggested (memory.swap.tiers and memory.swap.tiers.effective).
> 
> Considering other reviews and Shakeel's reply, I will update my swap tier
> patch accordingly.

I like Yosry's proposal. Let's go with that.

(I am travelling, so will be slow to respond)

