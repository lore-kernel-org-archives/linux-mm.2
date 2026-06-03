Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9378ECD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E086B0088; Tue,  2 Jun 2026 22:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E8C6B008A; Tue,  2 Jun 2026 22:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADD36B008C; Tue,  2 Jun 2026 22:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC3906B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:43:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C3DAA01EF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:43:13 +0000 (UTC)
X-FDA: 84837054666.14.E51DF3B
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf02.hostedemail.com (Postfix) with ESMTP id DE26380006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:43:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qIUk5At9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780454592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yjBalMusC7z1Xgp8V8aGUlWtzrk4A/s6uSiB5E9g3wc=;
	b=ZTaPHWdmFl1KMoYnr2KjEWM5S5LlDJZORtEBC8VUr6NuP9YkwTYkzTNOC062WE+Gjopyxu
	0tB0uuVOccgjyq+k04WCIz7kXECn+S00c3UMpZtxB0X5SJOPNYOTrNa9KhazR1Admit9Fy
	npcjPZh9sGzlw3gz1Vh1xORtmJbpbsk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qIUk5At9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780454592;
	b=BmYZLT8X8mOIt7FuIl4jwcjFnXmdRnzUOEVkOnEQK7KwjCAmxYLtJfpNw0HGsXMbLQSGPX
	qUvvdoW31zIqTdUSuUPZvWFEQMHzQTDFDA3R/rxzYSs8bKL75zsQ2p72yUT78e+KMVYzbt
	uW6DQgF+bpQkhKzczsbobbGqxUA6ov8=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780454590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yjBalMusC7z1Xgp8V8aGUlWtzrk4A/s6uSiB5E9g3wc=;
	b=qIUk5At9ThYG7PFryHkApvEi2uFBSRGP7kCANZeq+Zx1eZ8RHEIp0MA+9o9KGotnS18ict
	S56mHDOSvW+4opHm9v8BoZpxPrJvGyqtnJSx9644wWoLU9qpzkagJCGIvwtMyFwc6HQtk4
	3YiFbZnN5zIKFoJcAc5lWpVLDBM4lp8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 15/19] mm/hugetlb_vmemmap: Move bootmem HVO setup to
 early init
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <178041489396.457517.6730523256790632908.b4-review@b4>
Date: Wed, 3 Jun 2026 10:42:33 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org,
 Mike Kravetz <mike.kravetz@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <646C6366-B450-4A28-BE78-97D05562551B@linux.dev>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-16-songmuchun@bytedance.com>
 <178041489396.457517.6730523256790632908.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE26380006
X-Stat-Signature: gnumkj1tdwckpf35j4ckuowx9qb981gy
X-Rspam-User: 
X-HE-Tag: 1780454591-579790
X-HE-Meta: U2FsdGVkX1/5PlYdiotmSbzjc5PsyN/jnFacEd4tYiJ9u4QiTPJq5Ymu1qYyig4G0tIdhRf5ntPBnfXgNFHKRCcJfUN4l93BZG4996bDmcdgc0KKdDIGGTF/c3tz0rDJy+2MJaheAD+mUZarjEczAaTzxDSIPlXj/f/5muJRNcIQ4Qm3E61Jj+03ADiSJ7j8o4HuEAGJXiAEGz1lyNNNVKujDTuZAjEsUMRpTKtiQzcQL5/4JGvUgD2O6AtjCl3K8ovUqZk3V7Ft2DRA6bmIPzfxPLzEkXtJZJb2LlsM5CwGto3o0QkyoeGK13lXQ3vjVZ/R2k8vOwSt6Vhll5ljkN4b78sbGG9qU+WOUV2lrEiarUCfC/yN4gkKnYz+aNz/a0LQuc1KlMD3ISNOq4VsMaNQi1C2AvO7Tn+qzvQzgxdqj70xtDAWgBMjfyKkaHih5aZ4bAlh2z4nVgW/nGyERUnsmLXA+aAsxKBZiGsJoI5p+AbV/oUww+++dL4BUZLmbTp5dS8FOHaba7b+VBlrAAcaDXEyUNvHEsUuKP2YPRSbTYA9/sUQA/4NF4jrTrfq0YzxZluqcg4h/bvhwmR8Ut6CeT5Vt93O+K+2/rh9BYfkCtJWXwCDG8etGlxm/FtzFOuH8xYubqyqWwFXD46pZSYsE4GTcKXYgjQ1Eb7KcsZ8zZgmrwatlxTQ0Z85S2dAEGcSellN3jr0BsUfktKmUFzGVsifS75euam2tych5jph8J8j3dFBS4Z5Vg08nab6NyTyj1v+XsB9n6ZXOYAqAmqKYKtzkc+xnEQx50YZGt7Y/vh+xUIM0h7k0HOklg2r+gOzCA7GOKxRpUYbE81naF/0vydoLaSetRWf8WJeOUwR7QywRKX1kR132TJULAXyaiPPAPmi8ow41gikp09owmubULkdQk6D1Zbh22owPFWMrWu5pqYBzb/U4YdabeaJFWgpd3u6uLTLsfaGvqt
 FLgHUf3a
 B5P9I33phLj7EtC4aULR2PqdPNZdcc39VEQFCy9KfkVEyjEboyGrO76HtIGDteH+YOJL7y3vYXeMStu39KuZvCrXwKvyZJJZsecAQrWCbLHDadwMkoi1ZoAF1HL+tVP0gjyjlLEUjNFoLDkFI5pGvAVBXcq0bnock6yvK/1Sst+Qn/933/sbNxyhit+TEdrbD4haLZv34gxEHnIE3s6LP6v6AOTGJvFN4nc/JZG1VX9VA7yyTZbV6rCPqxpwa6DJW8OYmjoiIxNf3jhhclwJeHnmeNkUxKJwk9yqjPTGLSwfsT9QNgCyk9hfoCeRYovrIPHHXAMt6K087EbrBFYJsmqgnBcwhD3clws+p2U3jxLFTVQB8X/BRf0ZUK+BbzJKomMrcY8+XpfoQbHH9tAndtsF8fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 2, 2026, at 23:41, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Tue, 02 Jun 2026 18:10:35 +0800, Muchun Song =
<songmuchun@bytedance.com> wrote:
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index ea6af85bfec1..464578ee246e 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -745,6 +745,8 @@ static bool =
vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
>> 	return true;
>> }
>>=20
>> +static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn);
>> +
>=20
> Can we please move the entire function rather than add a forward
> declaration?

Yes. Will update next version.

>=20
> Other than that
>=20
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

>=20
> --=20
> Sincerely yours,
> Mike.
>=20


