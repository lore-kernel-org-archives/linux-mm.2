Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63660C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 03:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6462C6B0611; Thu, 13 Aug 2026 23:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625436B0613; Thu, 13 Aug 2026 23:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A706B0614; Thu, 13 Aug 2026 23:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33D836B0611
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:42:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6AFBC02C7
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:42:35 +0000 (UTC)
X-FDA: 85098477870.30.47679D0
Received: from mta1.migadu.com (out-17.mta1.migadu.com [95.215.58.17])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA6FB1C0002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:42:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ddUOcPsH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.17 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786678954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8RDK8rSR+g8zuUeF9ykMlvh7ffttrndl2BRtkoGSes=;
	b=IKJxsxnJcbw5R7XZl701OQVyZqs90DrDM3BXaWmJWIWyfQLai1EekNi9nwqnycjkZ23P0g
	bKnRviUTIbbzUu9U5P111InKrF/IKgBi0M8ISBs6tksTZ90UCbS+kPZuDEDQ5EIxtjvB7e
	i7ZrIIdj7ufBu1PcL9A6q63lVRtgYxU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ddUOcPsH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.17 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786678954;
	b=gYnlS+Kc4nWXGOGmkhgw8ebV2il0CfS4bWeLQb3wvj4ZxwgGGmsLGE48P6AB0atEGJbTgk
	BKbQrsr9yLRTPtuzGUDJeYSpVZUhBILcPWI3J512vDnEHETXOmDO0hqPJxJBmI0z/GavAl
	SxAq3JCIoOVP5iH4XyUqcxijXmF1zaw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SEkZgSN+NXcDybe67t2nMJKIlyyWBLCG1dqID552C8M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786678952; v=1; x=1787283752;
 b=ddUOcPsHpvQISZGrz7xFQnIcd8oz5bEO3mHVuAJ4a8JMB5IjP+geKn7Y7eYtRW/ViUz6ZnIB
 GKPwBhbQWi9dbXh8w0cmZFwjRSHTfP8WtFsMw8iMaxCSkDqT6u0qkOPx2Z9PoDR54LfhpNRgTzT
 KGXvWhlj0rS0hLWvVYTzVi88=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (114.251.196.97)
	by mta10.migadu.com with ESMTPS id e9ad8cb527641a7c;
	Fri, 14 Aug 2026 03:42:22 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v4 1/2] memcg: acquire peaks_lock when reading memory.peak
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260814033005.2481920-2-ridong.chen@linux.dev>
Date: Fri, 14 Aug 2026 11:42:02 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Finkel <davidf@vimeo.com>,
 Tejun Heo <tj@kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5511E37E-62E7-43E5-8A0D-BE95CC88359C@linux.dev>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
 <20260814033005.2481920-2-ridong.chen@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Queue-Id: AA6FB1C0002
X-Stat-Signature: jufb36fhx79oqm4m6x66qrg6tqebk5gb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786678953-849124
X-HE-Meta: U2FsdGVkX18s23mlUAzr2Me/zbf9Anq5kTiwXZmons7zmnMUWuZLhhylqBTqwx2o3aj+1PqmDRSJJdwGyOJ44nt7hLAVWU/e5odyf7CWkfhIrITtZGNrR+FiUNFY7Fcs65weCmngmPlqcsDC8bJFgZ0KT3Bk/YoUiTJ6zPUOynfvi7OdV9rSjZsL9f24oUxqfdWDOwYgcsWVs5B/ruM1M1jyuKFwZih+SLSA7pUcFY4ABbHHVMtShB5xoFq36TdPdtID4EQ7kPPaOR3bUa768cRxa7S475PkGQ8l7ZRrfKNOAtwotypV/RYZw7NWjCLwsbID4sikImcTw5Wml48ivjBZdyKRkEM2XF/kLhUsxsjIg0+VOXF76CnmQ55Ga53P8AuFggd6YXc/YOjCs+si+LVglc2RTyPZQL7yAy251NnT9YEgHMo1A681VnAdpQFlUMOsxBjN2RjHiBkCLhzXVaRJyp1wrzG1mzt65KmrIQDTdfdMdvnIuHevQ6g0ODLYqECEMT+ZMHljXNEU3RbQwpbl6SxZGQxs7Ehhkoz4IKtXm6ZRWqZHu/ZKhKib/AYPJtWEal0AiKUghEf4Jv+46WmyhWzcnMPeNWPB37PqfBW87LxVzDG/pfaoCWxPnYQmUGR+Xjx6gsl/PhAwqqCctioeqoFDH72S99oOE44Jq2aJcXSjBXUHcgomGL3eVi+SDkPKto2tZ7qBc4lFSwg9AeRyHEhGQYlqxLCeB44v9n8D9gFgkO7M6J9zNWSRW1K1HlhdiJsdHcXBdYaSLoP2o+5y/eRmdma8BQFU1JxaT2GABZy0YBALdIpJaUet1/F6etn1Fv6CjmywZpU4t2FlEgex42YPPRXSqOE6K4kRwBNCblc7DUdW+UBFjH/jgAT53rzxWSvgjxJyqcE90z7s4rf2hRnYyQrwh24vfFmpSgngDyZzwhuR1r/mrKBieknI00nDpurOF/oU0n2EudW
 3X0RkrR5
 7p5Ddh6MixUpJx4+mbqxDhWqc7DAXmfnPHJBTbUaA2HpmRvf6JHN/s6mk9nC6XvYe20SYyORQo2RaK2gZTmy1YTGWZrqS8wvuEzKlfQBay6kQoCAhgdsQBkMumZKC860tmAgg10BULS2zuvhZsPGYvK7QOh7oC85AZV39GJlkzAPPB1Rtb419i2ULGJ31qcUGNanozq8XsfumbjKc0Q2AuqSMCklYpKfNNJFU4mcUFMZ3YliXxWxIfdsdwWXEJKv/9mLgzpDdz9d4EELhxxhopxkKAfkHpcx06ug+dHaa81yfpBRO+vZXemR4IGugb72zFHHfeugjIkCIq5/YThtdOdDeBBmJpseLmbRfuAzbfv/SQsAHB25SG/QrjeH8nnlZB2ZekTEcTzEqbWHRMvsw12mF446B6L+BWX4pMCB0KqUXvSdmBL+vkRF2NdlUWc7TZyczXuuggd22JqUTgTfotnlVDrFWjmRyMuzj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 14, 2026, at 11:30, Ridong Chen <ridong.chen@linux.dev> wrote:
>=20
> From: Ridong Chen <chenridong@xiaomi.com>
>=20
> Sashiko reported that a reader can transiently observe a lower peak
> within a race window [1]. peak_show() returns
> max(local_watermark, ofp->value), but peak_write() updates those two
> under peaks_lock while the reader takes no lock. The interleaving is:
>=20
>  writer (reset on fd A)                 reader (fd B)
>  ----------------------                 -------------
>  usage =3D page_counter_read(pc)
>  WRITE_ONCE(local_watermark, usage)
>  // watermark lowered to usage
>                                         lw  =3D =
READ_ONCE(local_watermark)
>                                         // sees the lowered usage
>                                         val =3D READ_ONCE(ofp->value)
>                                         // B's value not updated yet
>                                         return max(lw, val)
>                                         // both low -> low peak
>  WRITE_ONCE(peer_ctx->value, usage)
>  // B updated, but too late
>=20
> Fix it by acquiring peaks_lock when reading the peak, so the reader =
sees
> a consistent snapshot of local_watermark and the per-fd values. The =
same
> race applies to memory.swap.peak, which shares peaks_lock and the
> peak_write() path, so take the lock there as well.
>=20
> [1] =
https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.=
dev?part=3D1
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write =
handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks


