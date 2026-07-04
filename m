Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D40C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 02:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90306B00B5; Fri,  3 Jul 2026 22:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67916B00B6; Fri,  3 Jul 2026 22:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956B96B00B7; Fri,  3 Jul 2026 22:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 681B16B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 22:45:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D8C0120386
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:45:37 +0000 (UTC)
X-FDA: 84949553514.17.1ED200A
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id B194E140006
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 02:45:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mswa1nkq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783133135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqonFV7bjnqVXMcdhLtm8/HTIUbK1zFVwxuknNkA4QU=;
	b=Ni+VlqOnBZEkCPZDrVa7m0g77CRfPv7Ad/OLUurci4c7G3A/iE9yDlZM69eQcoI+xfhHLK
	kkfRlBbVxJY+F0+Yz7EDErezLysOnyTpPXJEMG2gdc/kW6QGsFF1P+c3orT+ZHvz+M+dwL
	nohEUv96/40Ah7NjRXoRaWooTOyOjvU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mswa1nkq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783133135;
	b=1Mc4pTg0nfFS21fFjaDr1939EzJX78JEBkKdrTK8XXIZT2D4raiqSnxtEwyRTE+XVrQzHx
	dzpUrprwMwGDXigdhjOZsFsggbw6xCBhAn3tmNiSu+h37yH/kLKFoBlAIZ0xthF7YlPw7U
	xksbWG99kZg+/57Z8aMCeUO5tDl0btI=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783133132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqonFV7bjnqVXMcdhLtm8/HTIUbK1zFVwxuknNkA4QU=;
	b=mswa1nkqFQ9QtW9ww/AdCHgZCDLOSfbp5ZssYIQod1f/1WXquwt1AqR9FlNcbAM/qByYWC
	WDeKoy6TZu+m5xdVk3qMyxSAIX//ii+S0Ykra0/6NZBU3aK0O9n0LuIUzYcARqr7E/+b1Y
	xBXBaea+LO3bZ0it+TyRYp/BD2E/NAc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 2/6] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260703114202.365553-3-dev.jain@arm.com>
Date: Sat, 4 Jul 2026 10:44:39 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 ljs@kernel.org,
 david@kernel.org,
 liam@infradead.org,
 riel@surriel.com,
 vbabka@kernel.org,
 harry@kernel.org,
 jannh@google.com,
 lance.yang@linux.dev,
 kas@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 apopple@nvidia.com,
 rcampbell@nvidia.com,
 ziy@nvidia.com,
 matthew.brost@intel.com,
 joshua.hahnjy@gmail.com,
 rakie.kim@sk.com,
 byungchul@sk.com,
 gourry@gourry.net,
 ying.huang@linux.alibaba.com,
 ak@linux.intel.com,
 nao.horiguchi@gmail.com,
 mel@csn.ul.ie,
 j-nomura@ce.jp.nec.com,
 pfalcato@suse.de,
 tglx@kernel.org,
 dave.hansen@intel.com,
 jpoimboe@kernel.org,
 catalin.marinas@arm.com,
 will@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 ryan.roberts@arm.com,
 anshuman.khandual@arm.com,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EF4E3F78-CC4A-45D4-84A8-9F1A16BB752D@linux.dev>
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-3-dev.jain@arm.com>
To: Dev Jain <dev.jain@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B194E140006
X-Stat-Signature: buo6q48aca98zuqzei6t6a1x5xocis79
X-Rspam-User: 
X-HE-Tag: 1783133134-946085
X-HE-Meta: U2FsdGVkX1/INz9V2K3UiqtdrZch64I9DzbjDBngw2XvDxnSulurv2g1hLI+Au7f+wFCq5U8lPKsykXrT3Ac48CY1aaBvECyKF5fYi7AiN5ebZ3B/IPC5TGm7pg/j0Vjb51/fIaxlxmreFtFJHWQxDZtxzCLiomABrf870jVyWIadfQ65l5T2LE0+enWVuYZYMVrY9j4ALxX9o0ElCk3mJPcIBG/oLdPlh0gTKOQAxGE2bwdUdkKpBdAIFcyjX32zLM3/jsX4mshPI5Nuehjn5kQWkLgDix+8P3O9IsQl9nbRqLdbBrMFyl1kmRJxby/SOsSGzGPqhKW3UBpRLDoG5IGV5+eZSt5Eykqcu25K9FGKTOyQHLL2FJm83VW+yomfhtNGwUov9/q4y/UfpYgQUPZPtK6R+VvltWr/kVS0jvCjG33YC9czs1UQIymSn8ulSOTW5RimmW40t9ViRwMTICPUsSTen6F6kSrSos4M3ubKxNRUbcT/4w/c9jiP5RJzoevX60r8EZFWsfHtgRDo4Arq8BdrGA1kMo+ZQy2ncbnuU1OIr2PcWGhkd6w9r+M7Q9D6HpWCwoTLzr1uCh41MXmw3RRg5GweDu4R2HY8A4/S0zjPGL69s7e8i/Mgr2hnneND9HdFc09bChmTd3gjE+JQlcnrDObiMUzs8deOQRzkMcxaO20gdMc+OgxOjVCxaLS6zJFebIO5RhwCwPH+/CTCxIl0Y17uLgJQIolFZl+XBz93b1YT7YnbcoYes3SkOwg3M9XyXXXyBn381zMdw9bjxpQNRj1eZf7ozyiNnRC0YoAPr0++MaH3Jxci8aSFRBIhJ3gR6vxmFOlFsd2S9SAq7Lm+Szq42+X/N8J6G6cG6p1807yTnT4ypdcKql/4oLOUzp4mpd4vmkQUhO+VB1bkV6RH9/CGotoEvsHbqsoBnUkyAwYQSV55wwlL0E4CDhTeVw9Qqq8edi3HSP
 z6NSNy6p
 R1yqcQ2MnFVbRzDMnTzRQMz5WuOxGbd3jB5pybgr+NjwPBR35iN8hQW/wu0l1ll/o06mf7YDISOUS2Jw7XSFKJFbLAg3IAfRz019hftCII2NTvfouAhTDbr2I5UzCoTTb2swPVZs0oiqkzPCDEp/CogS2CYamqyYPEgj81wOb0cWqlN0g+/DBWuqjFRlvg/B+R0L9iX32TqikXd25KfCwNR/13i2KqUCX4zmArdvGmxhX+JgfEiqqXI587Bzck59I0L2kJfsvD3fvd4sJUE8RCavzZmlxhP5zpOeudqgLbQTX7K4uKOgM+r/ubLmE9DBdpySIBOb0r5uA9EWWP1b3Hfy/mDA+NIR6Qg0JDT9uUxftSwCSvfcb6ugHpQZ726BZl8JJdbF1krwS4zSQOB+XbNPHplzJOQZPcUJKDuTl1w2AVuZeZ8WSxSxBw7PdMTNfDscQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 3, 2026, at 19:41, Dev Jain <dev.jain@arm.com> wrote:
>=20
> try_to_unmap_one() handles hugetlb folios when memory failure needs
> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
> case page_vma_mapped_walk() returns the pte pointer to the hugetlb =
folio
> in pvmw.pte, but the code reads it with ptep_get().
>=20
> On arches which provide their own huge_ptep_get() to dereference a =
huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(), =
pte_present()
> etc to misbehave.
>=20
> It is not clear whether this has a trivially visible effect to =
userspace.
>=20
> Just use huge_ptep_get() for dereferencing a huge pte pointer.
>=20
> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use =
page_vma_mapped_walk()")
> Cc: stable@vger.kernel.org
> Reported-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


