Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72699CFD315
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 09:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE71C6B0026; Tue, 25 Nov 2025 04:34:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBE6E6B0030; Tue, 25 Nov 2025 04:34:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB876B0031; Tue, 25 Nov 2025 04:34:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0BE16B0026
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:34:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC2D6C0800
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:34:14 +0000 (UTC)
X-FDA: 84148618428.28.A935755
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E84A40002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:34:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h6BId81C;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764063253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIXBIcuE/ufZqs4idaNhHNCrHT/WUm9D8lp09grNibQ=;
	b=72Co8QMX4wm7h95TS1hOezAg9TET7LDp+QU11U+Rm6sAZFkgVtxqYgudEUSHhOitYk9an9
	3P42OsAVW5Xo+APpb3qX45Yo55btsqEHhSpiT7UOcPCZT8LwirM+M9kLG4T/sApbnbgNnN
	aSbSWl+l0DCKJYaUTySijq6T8SeM8I0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h6BId81C;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764063253; a=rsa-sha256;
	cv=none;
	b=u4Ex1PwTfpDo+nPLkyDrgxBoTI8nQlXPE9DxfJ7SLKcoZYe8sF47zIENK8xqJGsIIOW1LF
	T2YaMIb2B2PFRLwde0V3T1Sc+PfpiYXJIc55rCkSOuPuztM8fep8th7bBdikDXrGoMN4tT
	I2t0XATL/tj5nupaII1PYvgtiLhfONY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D819141951;
	Tue, 25 Nov 2025 09:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568C7C4CEF1;
	Tue, 25 Nov 2025 09:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764063251;
	bh=FcKv+b6xt+QE9/qtKYSh+S6sFbr6sQYUjRnCsWnW6nI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h6BId81CJTZvaXBjQ71EfemBl/x+RWWBbYt5yUML3h8Nj8EhTvE+cK5wyo6EArIig
	 bRr5awJuXrgv8fIa4YdV60RHM+II9dHvnIFtJAEYKNOkLAQV0mOgWgVBGHafsRyTbv
	 PbLJzXkQ111BE/caVlSBwi3WsGu+nrMWBe6MTllN8mwLu3gJgFymkyRVQPyV1vF0yT
	 bnncJbTFKvaNeeiCIfU6hIuEHEwvUt+N//H+o1dySEhWecK4pN7b0LCtpAP8ALnXlO
	 sShy4lfOK29cWRDWJtbNnQHaqTvEFj2dpf3RA++sC0UeaYu8wPmBYNx+oDKPu3VmjU
	 m6ca0XEYQoTJg==
Message-ID: <6833a9b4-5c9a-41cc-b44f-3e3f2592d119@kernel.org>
Date: Tue, 25 Nov 2025 10:34:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
To: Miaohe Lin <linmiaohe@huawei.com>, Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
 <df92a886-069a-450d-a551-dbfc3f629ead@kernel.org>
 <33A929D1-7438-43C1-AA4A-398183976F8F@nvidia.com>
 <34bafd06-250a-4019-8b34-5ddeedea1cb3@kernel.org>
 <66C159D8-D267-4B3B-9384-1CE94533990E@nvidia.com>
 <6cce0756-cfe1-7b39-d81a-ba1b2cb32fb5@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <6cce0756-cfe1-7b39-d81a-ba1b2cb32fb5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1E84A40002
X-Stat-Signature: skpmoub158nowczm6tno59drjx1kmnd4
X-Rspam-User: 
X-HE-Tag: 1764063252-440089
X-HE-Meta: U2FsdGVkX1+P04xRQrDL+oQRcAZn1lZfZnKRcY9MAm9/IojXjCQQfApiXXpyFXRlTXzrz+bEYHISBmULskBqMKIDC1aVIQXnQiUkdxmCODRofBn8NiP69Gk267b485TWi6KoKCzL8I5dSeRPTzJwYzawi3uHDzufLsmNcAZRvYkPi2WviV5JMbFKRwcFOA3N3PutDQ5Uxqyw9SpQgJp/bJXRlQtHxVffVj6ovQe7DXY1tfUXgQmHWXkmJxkL4mTCsdfY7MvRSAGX3RgxvSQXUycNfAWJTtL7dF8lNO/u2HBwyBfoRZbINKPU6EhOQ0RntoCLYaEudupFsTd/2BHzJOH+8rbMmXGFC82NNaTBhYCnQPSub17Drl1wZ+yNhg2TZ0g+x0HHshZrgP/I1XeEt7DXcAcqMucZMN3+Ln6nyphQV1J3jPRND+C9mycZEywXq19i0mZxrkqtzdfs6mo9MiAJwqgFawbUELugkmWa6qxJlA5G5zLA6067jtb8SRI4kN9ScskyDZKrEe3SSMsaMq4Bg2P/OelPLoK9E5XEG/Z05ewS7yoxYJ/UtlTFhIhKgy+zIchsFcILPNO8MEBnVtTRLAAjr+pARP0aP8TCWq3UoiEMvTknR10syELm/sEwRAsm+y5gnZWM1tnhAQhYpBfsKFpBpcAZ6QDPyKgoAVGdJzeE51j4fx1o/SPJG/asKCH7FtGS4jN5ffE1vLkVVO647OovYhmvdTK1XJtcs13qfsl9BG9y4z0xdAT4NVc3NF4MTHKcyW4i+AHCORgG8O1Oq1wOB0w8gaB+C92KJy9+OzF6Rxihg4Xv/9R/IagKRb54TkAz9bpjzB+5z5YVy0ZTvXwCpkNgbNBE8Awt6HLrIZbRWmccY9uwFVB52i+VVbwTAWSNKZuu5VGXDdrsGeBXrgNow6ETDcF/Pw+769gPrCFMJkfUdeLkwOoIsmXx3h6mXVJ7UzeeKkvckzd
 9Ce6iTA6
 W3F1ofAZVjdUI4Rv7SUEmelbikmfOdKeGJCbV59rEDmKaSLbI/DiOD/LhpmJGCiAgjG5vJwj2YHB+vjk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 10:10, Miaohe Lin wrote:
> On 2025/11/25 5:08, Zi Yan wrote:
>> On 24 Nov 2025, at 14:22, David Hildenbrand (Red Hat) wrote:
>>
> 
> <snip>
> 
>>
>> BTW, this page flag reuse is really confusing. I see PG_checked is
>> PG_owner_priv_1 too and __folio_migrate_mapping() uses folio_test_swapcache()
>> to decide the number of i_pages entries. Wouldn’t that cause any issue?
>> ext4 does not release_folio() for migration when PG_checked is set,
>> ubifs clears PG_checked in release_folio(). I have not checked all other FS
>> yet. Maybe later.
> 
> folio_test_swapbacked() is also checked in folio_test_swapcache:
> 
> static __always_inline bool folio_test_swapcache(struct folio *folio)
> {
> 	return folio_test_swapbacked(folio) &&
> 			test_bit(PG_swapcache, folio_flags(folio, 0));
> }
> 
> So IMHO the reuse of this page flag should work fine.

Ahh, thanks for pointing that out. Confusing, as usually the 
folio_test_*() helper are straight bit tests,

All good then :)

-- 
Cheers

David

