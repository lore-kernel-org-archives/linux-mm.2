Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111BCC44532
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 01:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D7E6B007B; Wed, 22 Jul 2026 21:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5616B0088; Wed, 22 Jul 2026 21:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFCB66B008C; Wed, 22 Jul 2026 21:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94C1A6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:54:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2907DA038F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:54:37 +0000 (UTC)
X-FDA: 85018372194.06.9F51004
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB2F718000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:54:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C+uY7cJC;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784771675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6wjuTbPtxAIgqgnGjPxKaJ4seR3kbUIOBOKDIE0hX0=;
	b=QH1rjyLhkU63F4LVH+LAaFMeXxWFTUWVdLzPp7WegORUX0EgU2bzwgrddFPF35zLNElXRu
	MuonxbeXjzlmG0juDO9ap3GbqidX8B0Y8cLwsdJAeQWGUQ6dv9hk2DwJNwCQjg4T154OLm
	lEB1o/kiYbXgysxpCxfQ9u9wFU2x2II=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C+uY7cJC;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784771675;
	b=y/z6hMjOO816KSDiZ6Itvkqe7cWZ1RCUTGA+4kBHewXbuebfz1zeudIw0lL7muMybdDVgF
	H9HJ7JBM56XAXuhM5++M3zcUavCq6Apn5fWsFSltEiA2F2OTwDQYgLkZF8pw5V/+bCW1kw
	JOtW+a6y3IZwLAneZaxOA3kNTHp/v2o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8518540643;
	Thu, 23 Jul 2026 01:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCAB1F000E9;
	Thu, 23 Jul 2026 01:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784771673;
	bh=N6wjuTbPtxAIgqgnGjPxKaJ4seR3kbUIOBOKDIE0hX0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C+uY7cJC1rLCcXQ9uonp8jtS1Q/1LHUvA2TMk43kckRVih0eSZwmuXLsHwSONPqo6
	 GvAxfZBNdFl5rPvNa5r7NFm2f7Eq6zKdVB/LQP8T91JxGVo3y9K0kulkUhQKib9IBw
	 DvRz6jbpHeyoFaR0+V2GSmOW8bVdbPqttuECU6Kg=
Date: Wed, 22 Jul 2026 18:54:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 0/2] mm: fix node reclaim swappiness handling
Message-Id: <20260722185432.12d549d77cbacd8d5e2829f6@linux-foundation.org>
In-Reply-To: <56fcb7bf-5e0b-46ad-84e5-12b2d00b7a34@linux.dev>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
	<56fcb7bf-5e0b-46ad-84e5-12b2d00b7a34@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB2F718000C
X-Stat-Signature: s41zf8oym54x9fe37fgeaim5fte73nfq
X-HE-Tag: 1784771674-518804
X-HE-Meta: U2FsdGVkX1/UCP4AWjHqpipbSXuBLFd9ZhKVYJPMMJ8BYY6VCv11+QCpIyN6OgU5Oj46I5+BA4byGtbotEoBXCmA8HBsBLuJdPaaXvOTsqZABlPMkOxjMtxA4ZENR0dxRddXmiJU27XCcShk/T/XRRpP8IG5rrNcfYeoq06TsuzvDosDvCjs15GaQ+eAOhir1BQoNmWC1B+O6fqkjRgzENPCqXI5syBgeXTHXmKPjqb/wBQR3wvL3j7rx5yq1oFPruXs112SLli82p5zuVuXVg1QywVlkzUCeT8oF8cYyp6n1w1PK1MA9QvbCpvt8ysti4fBpGNVJS7u+P7FqZeldtyO0vai1vnZaIzFw8h+IZdTHrx7c+Uj98uYhMO/FJvYFYdOdUuh0TXLLiMvMp880AVmLNUuRjLuYx9CVZ2eJUnSVS1UsfomFvydzV4ga2c9S0TdjTfE39SDBbf3bX0s0NNWlUM4cFHkoikP76/4SnDpr9GcN25ERH82P/bJCYV4uBubOOJtAVC3WL0S09LzroW7bEF+1UUXVJoh+2Pl8CeT/2TMDNuzdur6GPOK2pOWGPDvIOuG5jU1xzgLFSG3rBozVvcNOc2bBW2StG9G7q5l+AvJNllkaS2aWKDHucNHaQJ6CtrcgazIyiV6Xm3u+AzWPVD7OehVuA+5FShCOP0kk+S2Ezu2pcGyNF9Vm+oQK5B+JQjmzgNuRk4hdHYa0D3FV4jgoFqb9GuMQXX/EYWHmq/OpO+LsN+L0319X2D9KMOFwD7NLe2u0qSBpixQQMXo4JszDwarkZvACh3dAc8+H8seFIR0BvR5D6CgRP86rlVKZN+vQqDRD9lsxRQ5nauHPkOcIDdev3S7D5b/WrtvRA8hTHWQzSXujH7qJgzOAJ+BJaX62olFlVIVfEdLE+2XDPNRDaK1qqay1CB5fJMNg1TOYUNVPa15uwMb6tYiDT0ETfODLMYcpI4rOnH
 8e70b0b4
 uf0ZSBhU5IsQNWy/TQHm8KYuHZ2YbRaYRdxJxJiwTIRVepO26nV4ECCu7XUTginWX/4Ykf/vNGUebdaOEsrG7IRi9s0e0+rgRcm+qfpupUhDXZ0J7h9eKMscyjqQSAnNnOSkCq1lOVLDi8v0ovA1uXuzvqXDFWSXHgq8qMMO/6FkmX/+WOjVu21H6xbVXZeYy3T0pF4E+fznTsqg7327UDXmIO2A+YK5APFZ2GXX0/j7vTkBbGNeifaT4x2PKLPI+VpQet0Pu/PYyfysI4vAoRTh3vZ/Ws9yScFufcHL5MX0lRoWz6DuVWcMuvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 09:13:27 +0800 Ridong Chen <ridong.chen@linux.dev> wrote:

> >   include/linux/memcontrol.h |  4 ++--
> >   include/linux/swap.h       | 19 -------------------
> >   mm/memcontrol.c            |  4 ++--
> >   mm/swap.h                  | 20 ++++++++++++++++++++
> >   mm/vmscan.c                | 19 +++++++------------
> >   5 files changed, 31 insertions(+), 35 deletions(-)
> > 
> 
> Hello all,
> 
> Can this series be applied?
> 
> Just a reminder in case this gets buried.

Got it, and thanks for the poke.

It seems that kvack.org sent me two of the emails from this 13 email
thread.  This is becoming a problem.

