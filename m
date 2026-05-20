Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13361CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2811E6B0095; Wed, 20 May 2026 04:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230276B0096; Wed, 20 May 2026 04:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146136B0098; Wed, 20 May 2026 04:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F21806B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:29:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7673AA0228
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:29:29 +0000 (UTC)
X-FDA: 84787124058.17.90DBD57
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8AED7C0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:29:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mf4Y5h71;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Toc6Hf57MsxqjcmT4Wwv1Dez0FV6nEjIiy/BCwrLaT4=;
	b=kUGHeHC8bLnEveEbtFJ6crFPmRSkU1+qDlKCghgDJGpNsNOFZiA3rEOyMn4TeNuOtyED9Z
	/eIofelsQorAQK0MqkDvFyOkDOjUG/BEZW7kftxqxHT4H9hmPn8j6JZ9HCZcQB9cpW+a1x
	zoJQqsaYKHsOIH4UFi+wQ5WtJ/7Roy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265767; a=rsa-sha256;
	cv=none;
	b=v0fMN6Sembzmb2NL17YKLxwofY827xO9GdJg7gJhJFXPRDW63LrCx3hn3eM3OJ7ZVE2T12
	KrNBD4lJya52QpUnp+xkq5adTcZxZE81mfgIiCSGBTesLHO5d8/KEWXhSbjKJIcOpECNmA
	so/KYryWyk6EIFmhQcTxhov1oFgVYt4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mf4Y5h71;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779265765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Toc6Hf57MsxqjcmT4Wwv1Dez0FV6nEjIiy/BCwrLaT4=;
	b=Mf4Y5h71GBTlwpU539Q7BpbVNRdZ4P70r5Ia7Es3et5LVM7XirXAvHh+DSzRgnXo4Isqhf
	fzM5loPs05h0o8nqF5QaXHMdq3VFxROeF3cusFoOziqnTOf3todhElqflVEhbui9kRCBXr
	mcY0tPrqWBVx11r1sUlF6cEeNOFwu78=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/cma_debug: fix invalid accesses for inactive CMA areas
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <55481a8b-dcfc-4bef-ba59-aa0b43dca88b@kernel.org>
Date: Wed, 20 May 2026 16:28:32 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
Message-Id: <C1420350-1A8F-4470-8E86-F6D3D9F42CD6@linux.dev>
References: <20260520061025.3971821-1-songmuchun@bytedance.com>
 <55481a8b-dcfc-4bef-ba59-aa0b43dca88b@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AED7C0009
X-Rspam-User: 
X-Stat-Signature: c6w3ouzcf1upsw99o9rdpjb4jo5xfjsj
X-HE-Tag: 1779265767-602722
X-HE-Meta: U2FsdGVkX1/M47+m3eYMa5HUUq7xcbfWObVPPb0Dyzt8q1f2nUcxfBzmV5WaQhO05cPuWtD9kTerXDoQ8HLr6DDH2+PhMViRLWjZsVxxP//AEjRdRZzxeorn+qOaUIruGwEbgrz1Yi86lM+bxP7gGP8vPj89kHdDkVjL7iiSBnimsE/UJl8TYbW8QUzUZGHrr0pOhMYy0iA5VxhBnGC0lnOmk8TGbMgMS2VHvIwBENY0AM/jdNXbcpKkB1ePIfLqd0ttijwwxF/0v+CPUq3923K9fPOSgpAAprqBX+htbq42Bc6Z5NvtuFR5BOCaZalK5EwElrBEruRXRh8z++3Jluz/g3nfASQuZwUlTlzEClrtnkwfn7VJ2LpkejpjuHUA8W92hOqVR3wQ5803O+nUCA5BSX7b16n7nR8WB/Fk7uziBTSScnuQaeWYZISD2bt650IAVC+Xa726SfAl8c1f1b4mUd8tNLWaAmvhk0+fJPmitn/uTUQChAg+CQ8nZj2RdElCsQAcTG+bJe9I5ijqQqGHUY1BPCOeskIwsUEokvGC91BSOHfXiMAdsexj0IRlXQqOSKqf9R/fEd6w0p9Ty7ODkNmAlTrrmzka4vYQ9XLI29n4GChx3BcAdGtOMzUATIvTsI0RMlQs+p9Mzrxi2a+R7obhjHtqyjkenSkQld7xS4m3U7YjHh5xMy+7SabsZ1v4IT+LHrIhqIgSNx46Yh/9uELGaZYsHEoLKPzm1RGAreg5kA1ufgRx4bxApBPkCCRNfgNq7B4IwN90AlQ0LL8BiJzLzUFNr3p7SR80cjyhxzNGs5qDL6bHK3NG3dsd33gylIYxUGSOAau2FOiHqT1DoqwiiSwoeaXjuHSSVh5WjaFWE7sz9mHvE+gL6DYCjLLO8m9RuC4MtJKqZYjk/r1BAUMpZHULKsGbsZNW6OXcroLJXlNGtp0kFE/PYsJBGVsISbCfbhrQzdJi8xv
 3DvyyQep
 h3BhS5PWo9M13y96ig+MaCyasKCjOYYfk8ObCcNsqjF2cyKWtMnPCt/INeJSzADUzyYf9nIFg2eBNmmySdob7SA5212cG5+XpPfFB8yMtE+EtTzMEJzXMf9mPOukLQFST34A8mYmaBtyHqDC+/QIm/1kBrhDcAWTtS/c8LvYYJVhZF9eD3a7c67SS0rqqhD8EKFsW6F3eSy4k61XHM0qGCno0LFYOc+nBmlZH8UNcaHDewhWHIo8Ws6jDp49laTSP/vFkE0C2WyC7dQBoOuZb47b8dAcoxGSaKtfBS3FXJ5YxonKnlsOq4FZiamHTSdWEYhnc4xWjzHIXPhUwc0AD8a1X7hq57nJpotcTvSeWUKHSBQHts61ZK2eozf1OGanIAkigk4yrsNV0UVYjzmVMsRTWpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 20, 2026, at 16:19, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 5/20/26 08:10, Muchun Song wrote:
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
>> ---
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

>=20
> cma_sysfs_init() also traverses all cma_area_count. Does it make sense =
to expose
> them there?

It is better to hide them from users. A separate cleanup patch is better =
since
there is no critical issue when accessing those sysfs files.

Thanks,
Muhcun

>=20
> --=20
> Cheers,
>=20
> David



