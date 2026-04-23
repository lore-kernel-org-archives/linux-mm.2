Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEBBFDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225276B0088; Thu, 23 Apr 2026 17:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FCD26B008A; Thu, 23 Apr 2026 17:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A436B008C; Thu, 23 Apr 2026 17:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 053886B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:18:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B489D14052E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:18:31 +0000 (UTC)
X-FDA: 84691084422.26.4A0C20D
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id C06144000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:18:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PHWzdwYz;
	spf=pass (imf07.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Srz0VVxSUmFDt3GZ0OvBMTfIQB4Mjhfb10ZHRE2XCCA=;
	b=5FBvKLV6D0m8qCPTD/BSrbR+57cD1U0C2E6+K4xQ5Mg+uxupgOXxGyq6T60TJvfFgevoh8
	252GALA95+6L/izjAsFYsxN1U/sCyk6Ssfr4wE1kStcBGKPB5QvNEYz3wq8bRO8yCwoqgl
	QGqy8Orrhq6sCE2qit0osL9dUfxeBNk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979110; a=rsa-sha256;
	cv=none;
	b=le4f0jfJwLtw3PO4G0NrwX8I0XDwRGeKbr4twuZkCGR+sPw9GCv9hKlNMaDj4vsYqlA/Wt
	sC3XpVW7MTsTgRd2Jma8sexBFwGYs3Oo5LRCh3qcjKQuwL01gGfbpqg+mblaMI9Sx53d2T
	gRXMrBskKauevsY/JpqLSGaI+iZrVwk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PHWzdwYz;
	spf=pass (imf07.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <31f1f2a2-3fcd-4a65-94b4-f1f2921b2e8d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776979107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Srz0VVxSUmFDt3GZ0OvBMTfIQB4Mjhfb10ZHRE2XCCA=;
	b=PHWzdwYzJQP0OZJwISY2XdMOKhws/SbUmpkvrE7hH/PPmbpHFx06vc23C9lh8bA4H3H2Ml
	amAhh3EeFuZQBF0VDFuqOU7n+XE4520Wyek+Y3FSCErpnvvmRIjxuPF+TpgARc/85h0QQ+
	cJzWEosBgSiHAdJ4sdf+mUtbA67AmCU=
Date: Thu, 23 Apr 2026 14:18:16 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org,
 mhocko@suse.com, willy@infradead.org, hannes@cmpxchg.org, riel@surriel.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, youngjun.park@lge.com,
 qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
 <aepdmTw2tPJ9oMc3@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <aepdmTw2tPJ9oMc3@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mmx6d6guqqajp5xats48yjj84rpr6az7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C06144000A
X-Rspam-User: 
X-HE-Tag: 1776979109-730585
X-HE-Meta: U2FsdGVkX1/UWDeZOAzmVVIbDVJAE3rcgoV21iekco8l/4D8+7awOOBx3fLFmwneNOyrtnA/lwc10IEeOHvJ3pCztsN3FxFDV0cJ529fc1xRD0AflR9kxaxMC8ZREzg77FMXDOSm+J62mC3GpDKM8exjaLF3yi1gtopLbuuJHLNt4qNBtnEJ9vsN8OT3ISUpy8dQ4unIx3eri8HKcVnR6jv9rZ6gqMK1t8YmLHpq2LGPalU+SN7wHEaHIsy9Yrp0uwPv+oZ70sdSnFx0R+RPxvpxxRcWujftt32ekQWIjQ+ltfUtL2AvZj0mrluv9OBnNj+hM+sxhtZGMUuBY4xi1hpYjvv7lV6+RCp9Ajmfqo7kQgfk+LZimeqDDp6sPX18WXljfJhnKQod/z7K5c59V74YpZ1wOiVNZtbIX3QXDDfCSD0HbXfbn5HPZub/mtthgMim4bhHc68x7dORX4Lycp93U+62tXNUZf92kre/MeB94c6mxWd7MgGodu4HEPsAMxQKnnw04pV8SnmHIWPhTl28erLsxIKWCTCK0rPp08nS60BICkxThE5sSdiuPnhHYjG98V69uPF7GekASh0EbiGQfBnwkZfVuFU5w+tfMEtB/zMnWKZqJ8zEJ7R3ZvO77yC24KdNQbdQ0gVX9WHxilHff4BG4e6QKH+4A9uZyiItrU4XaS8Et6+E7CY55wh2oqMDcmxxeU5/n79uF1F8fON+wWnvWx5ZvcOD/z3o82o+oRBv6DFJBDQZQmjAgyPkt5zJOkNFrHEiUOG7oH13EqFf586KdRY7GM+1HJEtWJvrIS3zBpof8jtW1tBjvIqlO1JSUdu2YCgKgibL1oz2RHqq/QXyPCVjDmxjrD+zO7Sqj0fA1qP1NH4+q8NHgXyR+byHFUpd/aSwfmnkrJ3p2umPZmxLq3BGoEKJ6f5DdM+akSStT55xymwkVDntwEzlgStAbcqA+T92cpTWiDx
 bdnan2zo
 r5+4SqDHV7mgU2ICbHulH+Vpsp6No1X4fcji7nnnuvwLhTpLPXx2KPfEIut4XDYi9oEx5Km9tuwyupXPKs+005QRAvf/yTms3OIikeAw4VPh3jRzkOTX++iqUNEUcYpyDQNBGlJu+Kg2I5dmLwMN7b36V3J22T/aszk7KhUmfos1t8PeE2RNA2+W2zZLSMcmMHcuO89iuZ4k+TvX6TOCWtsr5k4h5IWmkMB92DlHHMgouAa2Q3nDRBx3+TTl0+PDwdX95
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 11:46 AM, Shakeel Butt wrote:
> On Thu, Apr 23, 2026 at 09:43:07AM -0700, JP Kobryn (Meta) wrote:
>> Of all observable lruvec lock contention in our fleet, we find that ~24%
>> occurs when dead folios are present in lru_add batches at drain time.
> 
> So, when they were added to the percpu lru cache, they were alive but during
> their stay in lru cache, they were freed (last non-lrucache ref dropped) or
> somehow we are adding folio where the caller drops the reference just after
> adding to percpu lru cache e.g. folio_putback_lru() ?

Both scenarios can occur. Whether all callers put the folio while it is
on the per-cpu batch or putback drops ref from 2 to 1, the batch ref
is what remains.

[...]
> 
> Overall the code looks good but I do wonder if we can add something similar to
> folio_add_lru() and if that would be enough.

folio_add_lru() is how it gets onto the batch. But it's still alive at
that point - at least one caller ref.

