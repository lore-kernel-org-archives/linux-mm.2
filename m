Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFB9606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LilnUsXZ
Received: by kanga.kvack.org (Postfix)
	id A9D436B05BB; Mon,  9 Nov 2026 21:37:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E386B05BC; Mon,  9 Nov 2026 21:37:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C286B05BD; Mon,  9 Nov 2026 21:37:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 709976B05BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:37:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12F4D1A05E7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:37:59 +0000 (UTC)
X-FDA: 85417649478.17.BE57181
Received: from mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24357C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:37:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LilnUsXZ;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.50 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794278277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2GMT6ns6lAtiKIgdp0F30rxirKti0faahCUUE6aPx8=;
	b=FLzOocW9R5cmFgwrbARN2XPEgpYbHWJhT2b+JhJA/45SG8rrHXwQ8Y3Z2iW/2pXczW9e6l
	wE63tuPefWNgITbzwH0Efb/yZN6WRX6F2SW0QB1KaxOoVMaaY8+bbTpWZiEbFwlywXhUA7
	z9KcmnAysavx/r60eMKXfzdGVdN0Mys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794278277;
	b=5WYdPkh61/K14uZR7/HLtCdGLCOWGjmhb6yNncJuEy4ypjfo310JKkGpgvNrjAPsaeqMNI
	F5Oxke24GOLPrvjEakPse5ilmMi7thw35WJoPRGab+JBbLPAWcuznGBODBfXiyK4DwAYev
	Bpo2UhHyJMkYXRp9w24WkPUCu73DBnw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LilnUsXZ;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.50 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m2GMT6ns6lAtiKIgdp0F30rxirKti0faahCUUE6aPx8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794278275; v=1; x=1794883075;
 b=LilnUsXZL3Xf+4uZNFlFCA0NFyx8ZyRAnZXWoAtldaMp4QFaWoUl5+dNQKznCc1uaUxXEbOy
 DoPMElMbcUpeV36QGoIvECA+jTes9arJeDH+46q2PLG00PUdXHx6Rv+rJ0Y5gN8WESqvIToMweN
 ZTe5sScKIC7sYSO3ifPdMVyQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c121729f7cdd5ffe;
	Tue, 10 Nov 2026 02:37:55 +0000
X-Mizu-Trace-ID: c121729f7cdd5ffe
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 3/4] mm/hugetlb: fix NR_HUGETLB accounting for unused
 surplus folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261106100521.30099-4-kaitao.cheng@linux.dev>
Date: Tue, 10 Nov 2026 10:37:39 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Mani Tofigh <mt4022@columbia.edu>,
 Zi Yan <ziy@nvidia.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Chris Down <chris@chrisdown.name>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1B03E14E-9E1D-48DF-9159-D64A12BA57BF@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
 <20261106100521.30099-4-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 24357C0006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1ann6gm8sob41qza93f76g8nufe1iycx
X-Rspam-User: 
X-HE-Tag: 1794278276-706985
X-HE-Meta: U2FsdGVkX1+FfZuITN20EPugZcnHTnlByGwSvx1q4hAzlyeM3O/PRHBqAWYC6RibKzt4tMQDlDndiv5KoAL9O1XTjjfAgz+juhID7ULrnjQsOYJcAYjGEMW/mMoTTfkNPR9wQRoKxRTYKSrp22M50LRKpnBCE1uMMpvlGp3u8v9aFXn7FP2l9DXCfN/upXqVVyNgvWT4rhA8lyX3oJVlsoCeJ/wN0kQ8urNisDRPBnljG6P4m6ryzXTqkp/sRZSzmPzfhyLKUeNNDY7yhwo2xUc/dUjStLJONVWrKdXNZreg0k+PoM/7AiXU3QG+V17Dr4+r/dtJa1VEPXch/i2AeJ/Fd3RoIdOR+50NU3GMAl+/4YTGPgrxEv68VVq0oLPBRZgAAj3Ej+/y2n/FrqvyCcG7hihTFWkEED7a1g+iUVD2YHvmWu6SRh5BkZSZIiUABo/V5zi7uveJNPQaDHK1GPOJzvju7tT4trDWeFHJzvJaQ7iyiQSsy1hnpjtEiRD3HwPyT/g4OrARfjcKUuwZlr+JPTnpVtQH6CZVZS2TwU+VdIO9D1GqZES/J3opIUw5WnrLkiUOmX6FEoEobZLWh1jtBHeX7U4Kaat0uxBi0jYQ8KoewUZHh5byaCSdWIm+5/X1lrgQstoMysOTMwj1YkgJVfQ2iZQFDeTCAcylirDbfdhQ/nMJ6XwdUQNWK/uz1ugCJwhKK3HE2sY0BcbSKM6btBo+KAb84p4Wg7yd9oYAQrmuCyE7rg1tPRkz76Wsy0cB0Qcw8mKgvzCbUspwB2kKZibpP2rOYfWGRkZLMSB3ZHw/vhLEUokHrMjDZIIA4UX6PBFrg/zcL/UP7YIl8O5gNYN3W0VRhYoVuSB7lGNNTHcs8BpfYHt7iqu2ZETNf78k90AvvFzGGymZXAlasJdqonNWykpKZ189HvyJkfbMiUPZWRwz/3UzPikNXvxY4T7L4AmrLWFrHWHuLPo
 L6pICpdp
 rxr+mxL5DcfAxgcgTknVGU2Y2WFBgBV9b8/B9/y2pNgsK+hzq0kZQRO+GavXra1I1NinfUWxjcEyCW+Crpi86k3vdmi6rVa5S2Q/UkezhpX7+E1quBH/MN6PtY1rQObptcNIsqY49odZ3P2/y/Nlv8fU7BKHd3omrnBtD+sP0y257TQLLUyurmC4aPHJIePP78ES4RJWnrl3BFCwVd9G6BVUT1xV0x+CnRySFqs4PkupK3Xo1DMofL2P/mpXt8Y928o9T50B1OVOxQJLOp1fJgEJNH7XKp2ovsrsQZlKtIakdQIGa38mzDdaBb7HEGfl0gUodA/lr/nRkTriKZxMadU7qMIQySwKIlh7NAuvRBUYaS+SY8eO3YzSSQ9W+2JZ/ulkxyM6pcvszsDnOtpQndTSy2Zo7A+2f66z9hyuDe+79MGLs28OeUujQzI+EZZkac3ug
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 6, 2026, at 18:05, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>=20
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>=20
> free_huge_folio() unconditionally decrements NR_HUGETLB, but freshly
> allocated surplus folios can be freed before the counter has been
> incremented.
>=20
> This happens when alloc_surplus_hugetlb_folio() rejects a fresh folio
> after its second surplus limit check. It also happens when
> gather_surplus_pages() frees folios because a reservation cannot be
> satisfied, or because concurrent pool changes leave excess folios
> after the reservation succeeds.
>=20
> These paths leave unmatched decrements, causing HugeTLB usage to be
> underreported and potentially underflowing the counter.
>=20
> Increment NR_HUGETLB before calling free_huge_folio() in both paths
> to balance its unconditional decrement.
>=20
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Closes: =
https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


