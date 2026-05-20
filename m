Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB5ECD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C942F6B0005; Wed, 20 May 2026 03:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C472E6B0088; Wed, 20 May 2026 03:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BB06B008A; Wed, 20 May 2026 03:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0B2E6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:38:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 560291C00F8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:38:30 +0000 (UTC)
X-FDA: 84786995580.12.2924886
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 611C880002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:38:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=guf+lFQy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779262708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9Wf6+1EnvL4wZQtjY/HoofUXLpADwBl0zleq9Tdm84=;
	b=7+bVKiiT30Q+2fOG0egxsw5XSSGwJ3A0Xq/gb0xSprubSJbuh1B+Qk2eBSTnEiKaEIK7pG
	+/rhTGSMemttI413hxrQlCTOUnxpUCAWagpLeyndeNO8yLvkO7YCmMkm8ONrEGRNi1pDLZ
	7eSDxrBVIxJHIbl3/c3xKV4Xjoj2wO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779262708; a=rsa-sha256;
	cv=none;
	b=NmQog5a+5S3P+ntksVgWYA+kUMB3IpOT6AoLuH9erx7gixKZ4xAdqXdfCmxZ+BdymUN7/g
	+3zf7/VqzCIJ7p7PEcUbG/XHT/C5ZlsegF55PzgAXUgbLSQZaz35yv1VFOg+/w3Zyd32hh
	+UaYjvCWIuLv44iul45ANPDdaUvr3yc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=guf+lFQy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779262706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W9Wf6+1EnvL4wZQtjY/HoofUXLpADwBl0zleq9Tdm84=;
	b=guf+lFQyC1RCTuzV3Otmw4kOpcCj/qPP9u1eo5RT962dqQXAvTE7BzDrn7qejVsyAwaWPI
	4vM4H7zfd15REfct9cR5yZwiyQIf3V8R9/JS9Cz+BDABGc/MIrnH8PV+yvMzCcWIFLi8AU
	cMwZU9Ru850/P2jTlZlkrUIqjlR5ykE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/cma_debug: fix invalid accesses for inactive CMA areas
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ag1icL5DPMVXwRta@localhost.localdomain>
Date: Wed, 20 May 2026 15:37:43 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>,
 Stefan Strogin <stefan.strogin@gmail.com>,
 Dmitry Safonov <0x7f454c46@gmail.com>,
 Michal Nazarewicz <mina86@mina86.com>,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BBDB1B2E-32A3-4B52-B1A1-F048B66AE47E@linux.dev>
References: <20260520061025.3971821-1-songmuchun@bytedance.com>
 <ag1icL5DPMVXwRta@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 611C880002
X-Stat-Signature: zgdbuzxpqbh4655i99zi3fus4ezi155m
X-Rspam-User: 
X-HE-Tag: 1779262708-657176
X-HE-Meta: U2FsdGVkX1/NSW1n45miyELinlp7zcbKxNmgGvxlq7AHU4g5PdiPJ2cQayvC/Lq1b2kiF4bok31tnjcwqWg5XDy7pco1uSL0uDfqzRsZJ1uS1rsETkVVqQE9dI2yI2yit8M+N8MUh2xRdT1favZxdY2faDbw72PcW1fBcecFXWupURrSnJfHsj69sbsDieYEC7jE/b3sucwWcqKW4USNufqz2HQs5r34ru6RURQ5PnPGO6JdVxCju7bwY3xjiqD6baAtiYjAajlq8eZ4g/YVSsml9V1VbvnOA2gFFfwYNXRgI3GsOEa2+tumQ2y1RTN48GbHkRJ8HVYhMvt42x050STEt+VsDnmBiVr+KKL9yfzUn0ek3Etil2BK+iVB9uie1V/l7xX67ecYBLZyu6xvlxEvsbIYAKc5fPiZOWGUcXbfbXag4cIwA/l2s4G0RpD2gor8RC90E0+SvBslDdQJV2cCqWJqV8EXJ0rAy7erQ9BNa+8HDHgIlSyXck0DqnpDZblnGfMc0fOOCRH4+M5E139vYKpfcRTPnYnp7Hex656Z6lH4OqhqOEnLsRTQHYbh2W4JIN87I9mB5Mj22/H4JlOgG+0CG9uGXDOHt5F4LHzhAfO1f6K5aFxmFbs4NCga7qvRCMbsa5BL93CcrxQVVXKQvv+VEHdeVcJg+DR4woepbBgYvHnlkjU+VYVUUis3QCC2VCvK+bMube2mY/qRYEmHUVwzEaYZCiBHiyr+EH6KGUXzzVBQE8fcLP8lxk76gcCRA9Eihf8uoMwMjL472stCTN80ze2Lrt5oZLwqKHd47jbgE8FB6OUKaKTIX4DF+5itM+FJLp+TLd0djIT7v+4SloQJDFPBiGZ3c3TLtASHheG5Uw4J377bOhQ+IbNLxxRB5urfIIj9/IS6U0mz/p6Qm8W7d+bHLq9HICcasOkri7848ppUq7ts7GM3b8chHDOUrvU2lSqS8enkJAh
 MzMfdIf3
 X/ST2Y2QCbzNZdQBEki6G2ODoYO4WbQqESIXf8/F6zSgF7iH2+9wH4jXxz0uaQxhWCOZIYytx3XvFdMFdBOhSitRa+MuPYF4pidUL8TO1riQB4lrs2xKG2urYtNZghIgPcQzdc6OLl6CGRhU/POAWDrrq10SVbIjdwQqJD256g9EDKzepYXfnyMK9KrA39nQRYPHylZRUdKH6g3a2nRBU6skytRCX5C4MIcfLPPwaXkBz5j+FP5ApVZ8WXU3zigQJE4GD1hKrecpOQ+y0BLLcC/K6OUtTIZSvAvelzJE5MhY4TNWGLKJOoKRCCGeVMlXrcxmK7oiP0KgmbGpJSi1OHgv1hvIAei03mp+ntUfy5hud0TsrCGo0DRaORKEXFP44qZJLrjIpsmcXaTdhob8lGDSTng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 20, 2026, at 15:27, Oscar Salvador (SUSE) =
<osalvador@kernel.org> wrote:
>=20
> On Wed, May 20, 2026 at 02:10:25PM +0800, Muchun Song wrote:
>> cma_activate_area() can fail after allocating range bitmaps. Its =
cleanup
>> path frees those bitmaps, but only clears cma->count and
>> cma->available_count. It leaves cma->nranges and each range's count =
in
>> place, so cma_debugfs_init() can still register debugfs files for an =
area
>> that never activated successfully.
>>=20
>> That exposes two problems. Reading the bitmap file can make debugfs =
walk a
>> freed range bitmap and trigger an invalid memory access. Reading =
maxchunk
>> can also take cma->lock even though that lock is initialized only on =
the
>> successful activation path.
>>=20
>> Fix this by creating debugfs entries only for CMA areas that reached
>> CMA_ACTIVATED.
>>=20
>> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if =
requested")
>> Fixes: 2e32b947606d ("mm: cma: add functions to get region pages =
counters")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> For the change:
>=20
> Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
>=20
> About Fixes, does this mean that before c009da4258f9 ("mm, cma: =
support
> multiple contiguous ranges, if requested"), this was already =
triggerable
> after 2e32b947606d?

c009da4258f9 introduced the invalid access to bitmap file. 2e32b947606d =
introduced
the invalid access to cma->lock.

This change applies to both issues. So I added two Fixes tags.

Thanks.

>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs



