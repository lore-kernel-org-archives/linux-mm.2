Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4EFBCA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16DB6B009E; Mon, 12 Oct 2026 11:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF7F6B009F; Mon, 12 Oct 2026 11:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04B86B00A0; Mon, 12 Oct 2026 11:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DEBB6B009E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:09:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09D76160FEB
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:09:06 +0000 (UTC)
X-FDA: 85314307092.08.C7E56BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 124DA1C0009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:09:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPpYf6O9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791817744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BBLP7D5VQ4ig7xnqoWkBX2bQpNScQ1ThBFCaNMPFU4=;
	b=YaoRi37az2lekqtw3tC4Vpwtc62OSH05y/+VOLhsNmfbjMl8C+Lkbz+rAsr2wE0Ebm40e2
	fPcS/68Fssvtf9GYWqgt+KU3fX8ReCqp5mBO2lOAnzCNI7Fl/EEuPFE1TYZrH8W242N6jZ
	3vh/Vtaq0Q6kFmJQuny0ZTj26liddqU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPpYf6O9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791817744;
	b=HtrRWfVBg3tGRTAgyz5FfRZc3CGEjBlRwdYTBZh2zMB3y1Y5rh19zQoT/++tNgWkTMzGS8
	gUO4OwWxr1jYOlUa67qXeEdof+EEFqx8xiz/zUjn+WmJVB8QuOdeiCvW1JJc57wSSjKfp3
	exqnhvkC9oBsLm7AZJ76BPeJiE9a+24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60D62447BE
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403A61F008AB
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791817743;
	bh=7BBLP7D5VQ4ig7xnqoWkBX2bQpNScQ1ThBFCaNMPFU4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cPpYf6O9F3/To/aLYR0Fc8OhbJ2LSTgF2efcWyJV4t78sAbeQzuH+VCDPAS6YJG7L
	 SJGEZt5CbTp1CNozBdI4RjgpEYJsswib5oIRlnv6XKwPxjlo6v8enE1VZaEjDQtM8t
	 HKaZx2BpyOvtaQxFj0BoKo6+h2zsE+R68jyYmF9SnhfDnUESdOM3UpDNDaeURzCsgs
	 zNer0C4hxuw1rkNL5syAyqaRVoHvA8xh3spkmXMnQ7wiEd8BzcbdKLId0mdErQC6IB
	 z5ivxE+4Jl7d+Th3NjngnTntVma67blN1ieX71B4nxQHVBa8ft41kV/e+2gN/LdXnR
	 wnvSlxp9vi4DA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6af9cc73235so1663570a12.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:09:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxAQdmkLSqjzhqyFl1yhVLUVnsX7BIeuEg6vxNsGZFIW5XyLtREYc+WevgGNfb1vNKGRnPKFLIqYw==@kvack.org
X-Gm-Message-State: AFq9FYLeoR5Oj2KJSNVspchKCWQrQVglznMnC5HOkyaiWmPkcVfkamXx
	Uo6NjbSkmls/zEzJaIqCouNpEFWeMOak3LSZzUEMd7TrMTLtifl8QhwuPqsSUFFXLKFql4T0U9m
	E2G4dT3mdW4sLru6wDg3hAO61XJnpw5c=
X-Received: by 2002:a17:906:f58d:b0:c2e:4397:7c82 with SMTP id
 a640c23a62f3a-c31a9d1074emr1078878566b.6.1791817742188; Mon, 12 Oct 2026
 08:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr>
In-Reply-To: <20261007153915.53429-1-alex@ghiti.fr>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 12 Oct 2026 08:08:49 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNF=OBGcTU7hGfBz-UOm-fv8BDn-yQzH23e=rC4MX1-Uw@mail.gmail.com>
X-Gm-Features: AclHuK_EARe5wJ3XZ38HWc8GNMx8o66_Dm5CG7tcDTb_VWTs7YmeYdTiYMGwQzc
Message-ID: <CAO9r8zNF=OBGcTU7hGfBz-UOm-fv8BDn-yQzH23e=rC4MX1-Uw@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, ryncsn@gmail.com, chrisl@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rrjibqdu7bpbg7sefk44yo94iuhc8s6z
X-Rspam-User: 
X-Rspamd-Queue-Id: 124DA1C0009
X-Rspamd-Server: rspam08
X-HE-Tag: 1791817743-324354
X-HE-Meta: U2FsdGVkX1/wpxSiCHNmikvXDqE3yPPbeGYXyV/0txzKy5JK5AfJng1Sgfe324yfHEjoRhlw++yML/T6FrN/GkKYRabyAha71+SfAqDNX6aMy+p8y6YgVDmf/VTcuXBZ0GTVsAfey+VOA8e5sfFJ6jW9dRsT9aQKNjMutTONh+kev0XLcoRYGRk5OotUkOTMSCD0qQoB49IFLfnDcW2V5vWvnEGWnUvu+M5ZLs4owh3oYWySaHC7zMF3BA9v4/0COnQA0TONM0EI14U9BXFUzDfNOII1sqD6+qnlNR3wgaXBrjbDR83CoAIMHC1xToa0hNBXOPGd8hWv9MPEzJcpq1cPVVeRKfbQiDsXKR53bipdco1xRj+NS1P9jcIpPFGNXj78klosSL5UVkp4sJbWFxmmudvcKaFI4tjLgbdqmTI/3USzb89f96JD3SrNNQD4qfHbIm3v/PWq8kJGsBwGVvVM32z8F0C7uzt9+EtBEbibT8adrZo9E8Nn7fyOacFOwrs33ltiYHXDOqxunYz0lfFMHvCBewNNuWyrWw+Q1FYlGI1Xp9IxplRrvsoH/Ic08ObSHFb1WvoWlIvuDNACNm3i5cMmz3PEF41VZMO2qfqkDUHVYN8oCpGqfbpMxjy44g5xTbsA1IoEiyTakMmAi9V1BStCV2TjktEJPOFu/30vvlpq1MazSNkxFvqfG8vnd9bFIJ/eFMwOOt6M28F7L3UH0JmEPw/NsFmjg5lOcasACEf85JhSSKpn56fQpuFOpyaXiZWIxG5aBII9eQR+ICPEBcHTMANEmhe84Igkq2jxaI4jFNInnztyjI7hhAzUd4Zlw0Ek8R1r2MJ/l2y16m3txseXyJzGI39PW8Sg1RbnEauHNjiFebfzLNyE88aID5+QLazLmYUU0jjynOYpmPnJq0D6unR8sRFfNioSYXLHciKSZmoQWkTOgLbQdno5McjksXBL30oHAooPWhJ
 XC1ziRSK
 NWCmNhTEbsBoN+zbuwbGWvphmeTCdfI2vnrgB2PuZAbUF8XMH+FspQd4WNyAvMZnPCwAFP6NNSVKXYo1rAP72w/xGGQzMhh6fNsXo5sDHP5mPoNxFiVVUlUY6hHi5FDA/wibC+DKjnd9rg2ZUFzd6q017YICB3xbxV/Kv+y05YNTCHA6u8n48rINqIgdW5cmpEufSKJf4veyR45IN6NXpU4JQ4C4QLOfjJF52A3yfTJmLoP0BPoBhESuh/G4Ug0/SyQ52wu1IAGulaqpjnlAt1cdcVgCtsD+n1AtHHtxCvz1zu7mfMj+aF/WdgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 7, 2026 at 8:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wrot=
e:
>
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
>
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shrink=
er
> off, on Sapphire Rapids and 3 iterations.
>
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
>
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp
>
> Similar gains were observed on an AMD EPYC 7D13 host.
>
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
>
> Bypassing swap readahead for zswap therefore makes sense.
>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Acked-by: Yosry Ahmed <yosry@kernel.org>

