Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 347A9C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AAF86B008A; Thu, 27 Aug 2026 10:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25BDD6B008C; Thu, 27 Aug 2026 10:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C926B0092; Thu, 27 Aug 2026 10:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D21B56B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:39:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45DF61C1D18
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:39:58 +0000 (UTC)
X-FDA: 85147308876.28.4F81CCF
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf19.hostedemail.com (Postfix) with ESMTP id 521DF1A000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:39:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="G Ahk04v";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KTS04DAs;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787841596;
	b=CP+0pCH1+5u3s4VKofaZUT4/YlMa6mfw6w5vGHZHGOoayFQiDd0DirP2i2oXagIqRVa1Vf
	dj2Ei06Rkxn/oyZ+zcUrTTKMl89jxctWYZdcIaRIbu+8P1gqaBcXby/OJy5xiZhyfHnIaL
	/NCpjrujLuTL8I1ETFN6hc9/5MrPK6E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="G Ahk04v";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=KTS04DAs;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787841596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmXkOSNZs2elL5e5I6wwGuMLGDRA1m2bAQwoveOqBhw=;
	b=s9w9d3hFl5iURHjQCrj/b7FqADMWEG8XnQIkME8hRcdh7Aom8Er7thPD1C/wcXY+9rmOBe
	U5saTzD4aIw6nlGLOqkTtR0Kk/yXTS/zMcKv01ty5bLOwHywey7KgG6WHAcG4CJhsYNIb6
	nEAZrz3GCtyERGv9lszenDtfpJss05c=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id C50DF13801F6;
	Thu, 27 Aug 2026 10:39:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 27 Aug 2026 10:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787841595; x=
	1787848795; bh=PmXkOSNZs2elL5e5I6wwGuMLGDRA1m2bAQwoveOqBhw=; b=G
	Ahk04v63CrJ+SpgTWN8iz9av2sjcR//zMT3jK/NDZHSOuDYMvCR0b2sepjLqvUzw
	fnQth03UC04xWxJujqh8z3XVHFPZWhLwwUjx/T3FPIpDzRGJ+Z2pAItoVw4yksuv
	wUXUhrQiRL4rDXCM45goaKPk1mBCa4J3TSqtZEz3pnpNdQv7rU7pnxkm8BsMj49A
	xeou26pq2Rg15jPT87VZSYEZQAS0v62BxMAW4X3b30jgFWa1Ykc8IRcmIdjvvYA2
	IotjCnvbPG2liHub0ZapYnzSXC/ap+KA44t3RsDDSXnX/CK9EbSaHkwOMaDoqiSM
	3z3Sk1otLOttxz56rsp3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787841595; x=1787848795; bh=PmXkOSNZs2elL5e5I6wwGuMLGDRA1m2bAQw
	oveOqBhw=; b=KTS04DAstGVOk7vSlS9GUDI1PsSHY82XPyiwoorQOX8HsMKNHpo
	vj3jZd7MUyEW0MG1WDUppwArln6yOl/gaLcm7NBYLfrqn2WxS6WQcJZMGSYd+M9a
	u1JrF0FAPUeKv8VD4f8KYhTLUgJEmNXKotJLDwEzYuH5TioyQSzZKtQuPSRS94yj
	HlhkdZ+s72dCLGKpqdTVQThBXXTr5yFq8NV0Pb2NAHPxRQvZnstjdjiGND2zsDlZ
	PnugVhMnx+2IrNVaR9oGrFMabbrFkPUkFUnQ9Zbc9KicbePdqxcXnb5UlA1qfVA9
	EjW/0ru/hAN4BMQDPtCtzhrjl+vosu55xMw==
X-ME-Sender: <xms:O0yQaiuLhgMleZvVqlXPLISzn6TnW0T671KLKhWz0VpNKGLCJhADrQ>
    <xme:O0yQal70Zklq6RVKRcgyI_S-1asWjsxC5Y2rOvfJtApJSkEF24QpOSN4bwupN_bUH
    fX4lxu3nfRNoY6F-I5CxolXF-YPeapRXmRV6KDwWXi1jiCZ_uzIh9E>
X-ME-Received: <xmr:O0yQak4Hd4qqvzdHH2Q4kxNVFNSL_usMApD7EmZJgylWFs0gUfj8fJKK2fs>
X-ME-Proxy-Cause: dmFkZTF53zJdy8C9ak+D2cJrj9KahptHyXqMO+7qTBjWqPFv4Pk/c/sJRfNdF85mEo/adX
    gGLoIYNq0S7yi3kS/l8ebpfkIgIKK1SdvU42cGRonv8sruTt4LMkmMo9+g0mnFIvmDPg4k
    eWP945j6fe3VbMi/dpWFcRHzNTbkUueKwitYhnihwltzPwSBy3IfkPr+C5Vx9/XgWQms98
    F6kE6342UWsZ/hJLg3KLvXXUmv+6iUyFSx1vfUTqQIf1blpoqyvQlGHS+Qoha5LJ2FkDge
    FWPMgiunYlU7+4rekz8ukbbSSaaEgh63pu4dRQ7Qt16Qf4dEoOvUCw26V6rhx4XnHAS+qS
    59jDmXQlOUr3YRknaLDFKcN5BKb3Ro7SMh3XsfdyVLsXbp2f9SHY0vpmslJBgOeJIHPAj4
    P11vo7kSiXcfUGg9dZqm2CnVZPD0QXNFeayfa50kny+dIx+4Dvaf2Iah5kW1NdAH8SkJvF
    plxNdWIbDGt2myJbvrrIke5o514syaFtJLOHU+p5Sfp54ezDNyg3AEHwfgr4QomdE8K3vU
    Z4bc5sKZmv7FdmMWfDt2GLdkiiZfFsB2KeSswgORo4sCkVlERr/NEVo/ZYOPB0WsnUucf2
    q1uzR/4OncAzkvO+Mf/+IDWgOGI84TiVT1iznqMRBoJUhWBsGELiknuXR4FA
X-ME-Proxy: <xmx:O0yQagzlYPdZQjm_uAXsaVpHvcN-cc0xZDlHkq3vv8BSdwagkO6WIA>
    <xmx:O0yQamVq_hIP5Z2AH8z9NTmCskelEkMVBoSWJUkS9CbVgY3skQ_eeQ>
    <xmx:O0yQai3Apx8aDt7R-XsmmXBS-OX0HJ17BxVzwL_KMl9zprRcbD3w7A>
    <xmx:O0yQajT0v9pSthDabJj2fmW_p4iPn0Z2-qute18xQxbg-vjX_k_kIA>
    <xmx:O0yQaoHkz18vF1ghtpUQJieRimNGA2ZSr1KLUY5g_RHiYwqn6ouAedMl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 10:39:54 -0400 (EDT)
Date: Thu, 27 Aug 2026 15:39:53 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 03/18] mm/huge_memory: invert folio_ref_freeze() check
 to reduce indentation
Message-ID: <apBL1icEHMt7QcT_@thinkstation>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-3-9b43f5163238@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-swap-thp-cleanup-v3-3-9b43f5163238@tencent.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 521DF1A000C
X-Stat-Signature: adhcmh8bh1a5chntekj1673rc31i3qxr
X-Rspam-User: 
X-HE-Tag: 1787841596-728909
X-HE-Meta: U2FsdGVkX1+IisFWn3N4sx2dM/mrHa/tY2bT5Bifk5+f75BsCfyVSykEf47vnyw6nquDklmWaCB06Sn/upk0CEXWFI0XQauHnel4XvOp6P9MDBPnAcPxB1eqjgqvyxnsvrr/7GcJzSzO6+yLTZW9CzDv38ZJFGI+6hiXd48H6qjlVwrWOeO13ue7CivS2HuPHDxdK1Lf8r5hOOgHcnBpKloExEzdM8HqlItmQ6kpjto7dG7MaZOGtC3R5u4RaRMcG1ZRJAfMGCwOPdG7iNUhRu+yz+Ai/FDlJ5sOUmBVX/DEd+EbSUyqi77K3+LrET1BtzX4TEXfw1LvLftKLuulkGtCt21Ll6TZgwjcS4PVYkDujRNpV0E7H7h/7OmdEPap88gEQqmJmjwL3gRw4y+/dQWerPAqTH92oHrqTmco8UT2/LHz53s+FEnIbYZzHoHlzvd9LaGRGIb9bq5LShDodx/PEipFm8hb4rM8TKZErErZcjrE5qdJSui2HNBqsppTD05u/sw4ISc0Uqa2Gvm9gHh4CPmz9tDqLpD8s7FS2fLVt5IdE9g0S53fDnS7adJgGwSDngIq6QWVHPizjByLNGczDh2+vEV3DG6AE69CNM5AKvkveVQ+BuU/lIjpjWVozpcDQ0pQm2r8OamtqCH7NkyCaeB8yzIHv+xaTmdW/Cw2bnG5E6SkbvtHSN4T4QWAW8DbuUEv1YdJah6Gx8/pM5LAvMjkTfhqMP/vJ7U1PKt1pfo28mC9pi8dBc8betNtxcXRkvHkZL8Cy4f8QZM3Nrq5fpjCOEwbHhMYY1JrjsQV37oa2jVfJIR67/xJrv/BBTggvhz60YbgBNvn8ax5PBZV1OBSifogVdVnxbj1OPU59YpYK9rqaIOfsqB4he3DwBHt9PG2Icbw8NBKA/60TDTVIH1ezeavWrR3HtZZ/p6lI7rCOtDr+Mse+VQqqYbwP2tjdPNPH8e/lbA4JlX
 a5Us8Lmi
 HgrHn2QDePUjxci0FggZQ4cMiTx3VJsLqsq9QVKvdrbgrkoVZoY9zrmxpbg7fV4enylcJ6mifAK1/mVxu6Db12kqYXkLQcQkzADjq5DCrqFHpr3u4K393L73vpjMRGDpaeuiS4v0cT8mS09+i5f99DULEJhDDmrvyi8vYqoDwbmQQ95eVWV6dDBOspo6xvskrs4GYMJDXjk6JGUMob3T1snOGaaDpoQ3Q7se/Bn4yOEsjNaBKSwmobNLeNvNmNsEc8KE7W2bQsa6kz3rhkVBJg7i+b41ffUA7wvvPvbJrXhYhMDyisd0F964WVOceFbP75VWXuxWvqLTG/j0FuepY7rRQtNeANPzImHD+ocGlv1uYL7oJiZe3FdtwITJCFPRFVrkHmAUNzDzClgj8CXv3blzEvyrNrs0GV9EBVAmDSIR37En2pnWdrVyhLDcXCV172YVNhMJBEXz5wHatcc3Xfpe6j9qb04/iW3Hj/o4BI9HsqyyUCw3MSI6/Pp885E+c0BVrs0gzQB5DMJ7Hzu5NMcpXWhI18thZh7nXVg/XRLPKNkCbQxFeKTWXMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:55:16AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Invert the folio_ref_freeze() success check in
> __folio_freeze_and_split_unmapped() to return early on failure, which
> removes one level of indentation from the entire success path.
> 
> This is a pure refactoring with no functional change.  It prepares the
> function to be split into separate helpers for anonymous and
> file-backed folios in a later patch.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Zi already pointed out that it interacts with my change:

https://lore.kernel.org/all/20260826162101.1314941-3-kirill@shutemov.name

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

