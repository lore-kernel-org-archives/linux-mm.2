Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CDBEC5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 05:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066676B008C; Tue, 25 Aug 2026 01:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016F26B0092; Tue, 25 Aug 2026 01:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EA26B0095; Tue, 25 Aug 2026 01:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C912C6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:43:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5164B140322
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:43:09 +0000 (UTC)
X-FDA: 85138698498.15.AF88919
Received: from mta1.migadu.com (out-63.mta1.migadu.com [95.215.58.63])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8B5A740005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:43:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VzMIlPI1;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.63 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787636587;
	b=Baufro4LOBtS0hEovyzEB4/2v/H2okynM9fE3WnPcJk7wAvlBKEkQVWeBsqKf6u8+r/D3O
	FY7EFGt9DrZ/Ni3arg26CG+AS+yRGuXeTrB0848vJJCoA5h8SMX/lWYF5qHH/X6844h7t3
	EEMKp94hjHzSmKTn+Al6n2x0K3nhCeA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VzMIlPI1;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.63 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787636587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcjl2N5K2V0WQZAdyJmxOIbWiWEmkbZR/Ri2p1CGi5w=;
	b=YRQ3uWFJmwTlEfdq0S1ND42Sm6J+wo3A/fb+GdE2McQ18LgHvxRNP+BolLRwQcfdqy1cws
	nn5HWDULORK05KtUl7tYy1HQzO/4sKRuw9JqQEFUKZKOa8PdyB+0+EkecVNCD9zosmOzMJ
	iRkarif2H8Y70/z1IvuJAdIqhZ152dw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gcjl2N5K2V0WQZAdyJmxOIbWiWEmkbZR/Ri2p1CGi5w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787636582; v=1; x=1788241382;
 b=VzMIlPI1jfvaFMQkZTsPfPuUM3Xk+x7Drlbv4lGTX3p8HhISpJ6mVrFRS+ZQim02phh+HBuV
 /KqMti5jpBmwS5ycCkl9Oa8Sid2FoQoeQQwUKwJtx167uARd8IzrAsPKIVhzeFnEGnthcGl5SH/
 1YQYso81ur+dY/DrF3ThpAUc=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (114.251.196.101)
	by mta10.migadu.com with ESMTPS id 9570901acead3ed9;
	Tue, 25 Aug 2026 05:42:52 +0000
X-Mizu-Trace-ID: 9570901acead3ed9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: fix resv_huge_pages double decrement in memfd
 error path
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260825021013.25672-1-hongfu.li@linux.dev>
Date: Tue, 25 Aug 2026 13:42:33 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 steven.sistare@oracle.com,
 vivek.kasireddy@intel.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6C152511-DA9E-4047-B1AA-94887F7CBEA5@linux.dev>
References: <20260825021013.25672-1-hongfu.li@linux.dev>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Queue-Id: 8B5A740005
X-Rspam-User: 
X-Stat-Signature: dsbgmuurjsqxdnt4mcbncosn8q984yzp
X-Rspamd-Server: rspam06
X-HE-Tag: 1787636585-714119
X-HE-Meta: U2FsdGVkX18AdXCjEBxh52YYkLfCEuoTh3pRK7MOrcIHW72So+SAOXSH+rqpNQGL/IdzqSoDO5S5KPGDweJ+a2eBn0BxovXR3S34laUN++x9/dIcOa4FxisIQClh8+RsvMkxTpW4zvo2VYEIMpNzvq8cPOYwAw1Nw1LGpA+xDrIfnDnwEuoY9BGJ76Q/gmWmymqrflG45tvc0MHuRBFwtuQwsCoAglibxiacBgMLZ7oNoh51ykrfA7zaNPBXAKm5bMlRYgmMNs1lNcIPK4/SSZGHDqm01Uihgv99b3CSOIRquAOO69AXvetsMdTzcdMbYLxhBK90T/EXUQB3j9rzW+D/0RjAsmpQ4OZO++tw807IfxcSZbwxgGL5H0wEdT0txDlRVXR+N3yrrDTEECOYqnTyfnfEDAX91C8TC2bCrE+q2hLWSooDr56JRR89gNf3CfbRcDegr2sSBUXq8kMFztXgag63lnerxGBUaGWDubEaCzaP4B6EWMVqBEbccxf8HHR3mnIBYbg5q5lQlczZXL5sR5AY2vXu3NQmeMGeSW4p/N35lolgUwtJOtWXtzB13AV8cdnaeZanfs6i+0FKQH12DY5CH3lCY12+bNA+PxoFYZ1aFG2XTdf8G8OgNxkdYWyC5qLpHRP3jbpd+OlerNq1BDEsF/WHu9G5bRX4LC7m7wvv1k1BiTBSmkrjVpaFws/QcWdHEMeyapTsCnb/Hzi7ocVzWpBuirT3GS76JJbcb4LyKlm9aDDdm1HbDHXlVeIKl1Aa+JGLuvSro28mhQYeU8lJpkDTen9Np9pG+JLu5Xe9uDC/bp6im75qpthZc+0nPvT4UmHi1eMK7u3ep9BW3LDKR+n+tLu/lCazT0QMdXdr8C2ArR62kc9hYwZwsqTuMf6mMsFobc6wViX3icN3mghGPOfBBFLtWXAKoO2AOOsuPjqXoM8iKxsFo0/BN9el2wKqwfN/lzjXEMT
 gKwhsIRn
 wd9MZ27KE7AdYq98kJZbXeoRk9nPmgq5cvonso0yhHKSwb/LtlBRaws5lbniywPcL8k9YgyEomU385fSX9zir/1W5kfgL65V3VEu+hvwi1ZXHKhHAfA1jYYq5zgvBCCweVhxc/4Q7GRxuVaEpN6gjg4M944YoKUw8SvYFJ8kWqdRGpnvwyRxHf/GKWzVKesR7Tn+X/OQfIeIFjvWg73yGMAmvHPdp+J+LTlSy5K3w2svtQKHBUNTSa+qERG5/gDettyX8EMeMJB10TVs8PcAmWpHru6N2ntj0x60kJFn+2R6RyQ7oyU8TNbp9Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 25, 2026, at 10:10, Hongfu Li <hongfu.li@linux.dev> wrote:
>=20
> From: Hongfu Li <lihongfu@kylinos.cn>
>=20
> alloc_hugetlb_folio_reserve() decrements h->resv_huge_pages when
> dequeuing a folio, but unlike the use_global_reservation handling in
> hugetlb_alloc_folio(), it does not set HPageRestoreReserve on the =
folio.
>=20
> Its sole caller memfd_alloc_folio() pre-allocates a reservation via
> hugetlb_reserve_pages() before allocating. When =
hugetlb_add_to_page_cache()
> fails, folio_put() drops the folio without HPageRestoreReserve set, so
> free_huge_folio() does not restore the reservation. The subsequent
> hugetlb_unreserve_pages() on the err_unresv path decrements the =
counter
> a second time, leaving resv_huge_pages off by one for every failed
> allocation.
>=20
> Set HPageRestoreReserve when consuming the reservation in
> alloc_hugetlb_folio_reserve(). On the error path, free_huge_folio() =
then
> restores the reservation before hugetlb_unreserve_pages() releases it.
> The success path is unaffected, as hugetlb_add_to_page_cache() clears
> the flag once the folio is added to the page cache.
>=20
> Fixes: 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios resv_huge_pages =
leak")
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


