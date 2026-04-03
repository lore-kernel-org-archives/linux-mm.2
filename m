Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89A4E7E350
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 09:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D396B008A; Fri,  3 Apr 2026 05:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EC46B008C; Fri,  3 Apr 2026 05:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D454C6B0092; Fri,  3 Apr 2026 05:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C51186B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:06:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 826EA1403CD
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:06:53 +0000 (UTC)
X-FDA: 84616664706.08.4D220E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C3D7B180002
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 09:06:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MS8uxI9t;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775207211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glA10DNVCJ/0IxJjW4eigd5qWorxfgQ/klhE+VT1a2s=;
	b=xyhRxAK6HSvmT6F+aL8xhkZJQRuVEFQQKQRxbGOz29suPwEgbBippjU75yx9AolS61g2sg
	mjPg4m29U40jg1y/u/B81qcpdrbW2+GsW3H0izUvi9Oyom6HIXm5/VZ9J9GnUMBGAr5dqW
	sBgfVlEbPXsiqsCl2+8voizMGcyuaRc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MS8uxI9t;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775207211; a=rsa-sha256;
	cv=none;
	b=5YWyCob5z6wkATfR/rsgLWR3lP7CbSvhbnEfMoLRINt9oYyJL+u4Y4CdlFSsn0MOHwYPCb
	bdF6JOQ6eM5Gr5LHiY+sargLz44TXtvKa2fvmsR+hhkIjkMyyIf8+UKvm9yfEwQnpAhokt
	3TCCFEge5CC4FStPYxEDWfau+2DmEC0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73CD7418AA;
	Fri,  3 Apr 2026 09:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFA2C19424;
	Fri,  3 Apr 2026 09:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775207210;
	bh=8VNTsNLwh4pYRGyy7ABwzKsrV8s7jJb34VRUNiKfiXk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MS8uxI9tVsBgWSxJnntJydZYFQUQRYXC1WVZESGMXFMpfLJ9kWzZanXanp5F24u4U
	 46bggIW0yFZPfhymOcEmbxf5hQw44F/GldAe0aN9PRwbvhWWni/585TjhxIsFWhb/q
	 AccmqfCVCcUqWmmJioOaPcKQWLg4eAxEVq5W9MHAxU4ZkDqIw8rWRQM5GHY9hE0Egh
	 JoBuEiV8Tscb1fOVnof4rS6DdRcgbL7sHOkYR+iI94nEY696sd0ZsV/J0/pA0p1THN
	 oF/4gbTwrmte+i8+VX72e7fzcklktB6dQ6bE8Wy6CyaFxNyogYdcdz5efjqligZYLI
	 qzXk5Pys8Zi2w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Chenghao Duan
 <duanchenghao@kylinos.cn>,  pasha.tatashin@soleen.com,  rppt@kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 7/7] mm/memfd_luo: fix integer overflow in
 memfd_luo_preserve_folios
In-Reply-To: <20260402105845.f4d375734c0b21a1203fb9c0@linux-foundation.org>
	(Andrew Morton's message of "Thu, 2 Apr 2026 10:58:45 -0700")
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-8-duanchenghao@kylinos.cn>
	<2vxzv7e9ftwd.fsf@kernel.org>
	<20260402105845.f4d375734c0b21a1203fb9c0@linux-foundation.org>
Date: Fri, 03 Apr 2026 09:06:46 +0000
Message-ID: <2vxzqzowe7kp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: C3D7B180002
X-Stat-Signature: 4d97ydbzb7uirnoo97hd79rcg7qtozqk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775207211-555486
X-HE-Meta: U2FsdGVkX19YGmESQwpsZFVv7BmtV1MppFT/5lRB1m0qvdDRzG7TsO/QChC+/Ep81smBYfMda14oDrpE0In3coQ3m9GTnb6hLOPiU4W5U+LHMqqACz24N9wxG+E0Pp3RxJX0pU30TnLMvF6AoNX0EwJlGGeM+I+WusS+QQpAv1gWhySredkUzIuxHAwuw6pDjm186fomim7EKuf3xuMboRHztDqKMkt4kSQ7NKmLTHEMJvRbQWBwsCSDcGO4JzgA5lLhbiwcqfeS3p1uGDMeWrfBI1rT0sJTiq7VtjeYRv7K2wuOhWrpHET2VprWsWABJxEo2MCNqG5NT9Vu0um0YfIk/oehDh5rij/f7EqEo2YgQoO/pDVvT7/9hOw7ZS217seGpJTLYh9DjOc4+y0Cuft2/hT6n/7Yo2elPvhyfqs28eHfTpp2I2c4b37KJmBK/m3rXNJ5HTJSQp7pDbvj6Txck6Puws3LG0fHUplphm0CiateHUvulitbJh7kY5rbt95mTJ9qihzYQMucdVptsWCjSXUAP+sKDKinM+4j3FuMcMPeAXdmjUV7/VgW8vDfU05a4eOUjPA+mOjvzjFYIdC7vdBF431GdRaN/eZtIeGPh+o7rWKyPKcPdij540CE0/MesoH3p5xuMMUnV9Z4Luk2M76ijj4eQjGZNlz/N10y6+Xc7+ZcGX3BAKuBKSEsq1tVc5Zdgq96mtgvHb4lTJfRzEnTtK6JY5Ac1Mg+UwD/C6aktjYtHaaMA6gRgX1LrhaPOhYv+N4U8GT2w+nawwCMQzJeFzdgtOMFfxYnYX9kDpqBK1+YOyUOuAulAlulJZmki28bGXAtooDjmii4+eICvLRWmIGrADTpxKbnDinQmlYk/zNwiCdOYGdwoSceWvVgwtY5kLF9IgSNKPUhUz4+nUsZF7a/Y38vn0B0JCKNaokd8+ut32UbUZxesS53LAYKOQggZhRzSeFgMcG
 nR2wEmkW
 6OP8wiv7115kQl2MbqM/Kr1vxbrBUUfldhWdOVCksgSXMVy3TIh1CJEL5a0/pXSRL5KlVr6PtBgC1XOKQYjEPm0YV3E6+K2IExgi7cJiIRQYHAaBaXr72T12ndtvB8l48qGl3S2GKg2dl8JVS2K/Uxy/4k6YHOwmD+SXYTGbO8PgvvhJADqCDZWjrPVJ4l9SsH5S4pp2Ckc3tmVQ/mYK200vSDRE6H6GCDaM5Axgy9ah2HnigT45yqZCbZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02 2026, Andrew Morton wrote:

> On Thu, 02 Apr 2026 12:06:58 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:
>
>> On Thu, Mar 26 2026, Chenghao Duan wrote:
>> 
>> > In memfd_luo_preserve_folios(), two variables had types that could cause
>> > silent data loss with large files:
>> >
>> > 1. 'size' was declared as 'long', truncating the 64-bit result of
>> >    i_size_read(). On 32-bit systems a 4GB file would be truncated to 0,
>> >    causing the function to return early and discard all data.
>> 
>> As Pasha said, KHO and LUO are not expected to run on 32-bit systems.
>> Plus, since i_size_read() returns loff_t, why use u64 when you can just
>> match the type and just use loff_t (which on 64-bit is long anyway)? I
>> don't get why u64 is any better than long or loff_t.
>> 
>> >
>> > 2. 'max_folios' was declared as 'unsigned int', causing overflow for
>> >    sparse files larger than 4TB. For example, a 16TB+4KB file would
>> >    calculate 0x100000001 folios but truncate to 1 when assigned to
>> >    max_folios, causing memfd_pin_folios() to pin only the first folio.
>> 
>> Using unsigned int was intentional. We pass max_folios to
>> memfd_pin_folios(), which expects an unsigned int. So this change is
>> pointless unless you go and update memfd_pin_folios() too.
>> 
>> I think making memfd_pin_folios() use unsigned long for max_folios makes
>> a lot of sense, so can you please go update that first before making
>> this change? And when you do, please match the type of the argument to
>> the type you use here instead of using u64. This can be a separate,
>> independent patch series.
>
> Thanks.  I'll drop this patch.  The preceding six patches are looking
> well-reviewed and ready to go?

Yes. The first six patches are good to go.

I think the changes in this one can be split off as a separate series
since it will be a bit more involved.

>
> Chenghao, please prepare any update for this patch against the
> preceding six.  Or against tomorrow's mm-unstable or mm-new or
> linux-next.
>

-- 
Regards,
Pratyush Yadav

