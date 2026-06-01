Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B49CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA096B0387; Mon,  1 Jun 2026 08:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0816B0389; Mon,  1 Jun 2026 08:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E73C6B038A; Mon,  1 Jun 2026 08:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF686B0387
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:38:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF9091A063D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:38:41 +0000 (UTC)
X-FDA: 84831297642.10.5C83C47
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 85BEA18000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:38:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t9X+k6Pk;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780317520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8Q9MsGaEY5Id3cDoyk/LMPpb+cY3ipFpIzkjqGDFMo=;
	b=B30V7R7x1xuH28YMbral1iTSBMWGFRyhWK68/98k77L3cCQYx9rX07SJdH4dV/+iGwhTGS
	5B9b5O85Ydr0KyTyeetMNbfsZhc+s5notnzLYu3i+J9nS95ZuHlAC+hZKO6RFlb0zVgJc6
	7hfbTaLJXQiXV9yHnzS9rLoB6XIwppo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t9X+k6Pk;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780317520; a=rsa-sha256;
	cv=none;
	b=mF8UvVh8KKJ1MAYlNHqoHPhtqthHyeWLVyXkafzaP+raa7oaNDb6VAqqO0iUCq+PuRuCvJ
	RGjtG4PRzSkbdLa0zfGQFfDmn95iQ04zZCiqzDB8OLFTE6j8E1SsYRtMwLCRp6xWzq/AXy
	qlXf7KmjVhfZJS1qVr9PHPF5d1f1NZg=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780317513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8Q9MsGaEY5Id3cDoyk/LMPpb+cY3ipFpIzkjqGDFMo=;
	b=t9X+k6PkHR5WsisChw0O5VpIHYqYLwjr9DFuC/tgFLuN5u0rKS+6y8bhT2MX1ghqTZTr+n
	DuMVk9niJvJLHdW7PBgKF1COtMWreGWe69fkyAbs03os4PWMGg/jK82UDtSe59liiNNRDy
	2uJ7I61UVj726QpKC4J0NufWJLLoJoQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 1/5] mm/sparse-vmemmap: provide generic
 vmemmap_set_pmd() and vmemmap_check_pmd()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <db8d440d-c8a1-4f77-b5d9-00bab8737f12@kernel.org>
Date: Mon, 1 Jun 2026 20:37:42 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Andreas Larsson <andreas@gaisler.com>,
 "David S. Miller" <davem@davemloft.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org,
 loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org,
 Alexandre Ghiti <alex@ghiti.fr>,
 Albert Ou <aou@eecs.berkeley.edu>,
 WANG Xuerui <kernel@xen0n.name>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0D4AF42F-37C5-4A76-9703-44ACC6374C48@linux.dev>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-2-songmuchun@bytedance.com>
 <db8d440d-c8a1-4f77-b5d9-00bab8737f12@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: d3eid6qqsgpjjrh5qwz9ze6wt9d8h5q8
X-Rspamd-Queue-Id: 85BEA18000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780317518-556446
X-HE-Meta: U2FsdGVkX18XM0zhLxPNvc91PjX4E0UVxyZAUm5wTr+HmtTsPpr5+/h8mAVaq4JJjW+YvzQBgZAYEDGv+QmGM5jrjCVkIS8/RcJTpJy1aPX5MWiQeh2YDygmyH7rblNGssVpI6YBf+M0oUJ++DcsnLlLQxGyRESHRSxlYLnmGZg5GIRQaFoEx3BTRmBSpvagsYLO3dxb72uPDfJmLmRJqD/+7plPGq59+YSFwuZicmZV9Rv5+5qMsDscVilMrOhLso3CWMyidfyH/6HXxiwR/8AXZ8OZ6rGm3kfsXB5EZiTaQB8VnWk4PTOuhWSeQi65Alhsh3c84b0Bzsjrkjlgso4CJ3gUHSKrvMmPwZr/xxkDTMO3bz5BLdSSwBjetgTGI6Lbskj4Jb6qAlCSKuEXd6+Atf737ViPss9gU3TRzQeagmT3Yom+tXM6Cx56wQ0jR5mfQacOGk3wCPSFEWXkfwAUYmkWcN/Lbpjv02FhWDtdbaxcASAwa+GmjUepsXXIOKBbZ4gcPagtqdypSkNzqb9MclOdURD0DoaPami8kieYaLWymHdlw0z2igsOopEFWr1UYjzrnGRNgbj2Sz5knlkG6hkUOKK0OzVykac+WWLgeeLhyWYJ3eROkCf74V8IDxuUhAM1F2p7hC8duWK6ZMSzOwa+eipYIg0M303nmmgJwQHMdWAXNJrxXOYYMvtOxC1vpMUq67O1qOjjg74BRW3owB0Gl7qbWebmVFMKvStgTXX8CPIkrV8wkENLtr/coe24889QLk+jjT1RCyksL96Sq0HlK2ebIkLCgIwvCTDCY5TRmxmYYTuv3jB55NEpJwlzSNDAwnzFI1QmumPWq0T45bg3g2tlrgWXNXZ64Ig15hgl2wU1PliQrvyC8qDRCF+3HEvIPaY5R80FymVvkF5wwMBWWzOaG9UkcRs0u5pTe2n2vh/eURwN3lcyxf2ucOZn5EJNz9rVGE06Z4U
 ZMWiklxB
 cCwj/30DKhE0vG6CiA7N+JuWmPClLseaAJ8F5IY71nkqrJOV5P+cgingn0Gs7sPi2nQT9mqpGgGelRfuJ2xXJFyUD88h5hvkOWnPCkvesJKoOycvJu4MrZf3plVm7MMl1WM2ttm86myicq6OCIXrmo8s/y4ikJ2GWTEABwqR6W/L94y9ZzZRIXcfpo2foziGrdSbiAZiF2RklUwkoFkDtiLcaSl8nv6JeTfgGXUFNTK7jG4KnBM8gP/TH5/b3VGx6fIu8F8hXwQZ8HSPFASNw+0gKru+q/hdKw7KY0CLPrYW1P9w+7jsP1SrHVkRt0w+Vmu2X/IdK8umLrVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 1, 2026, at 20:22, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 6/1/26 10:48, Muchun Song wrote:
>> The two weak functions are currently no-ops on every architecture,
>> forcing each platform that needs them to duplicate the same handful
>> of lines.  Provide a generic implementation:
>>=20
>> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL =
protection.
>>=20
>> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
>>  then calls the existing vmemmap_verify() helper.
>>=20
>> Architectures that need special handling can continue to override the
>> weak symbols; everyone else gets the standard version for free.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v2->v3:
>> - Replace BUG_ON() with WARN_ON_ONCE() in vmemmap_set_pmd()
>> ---
>> mm/sparse-vmemmap.c | 7 ++++++-
>> 1 file changed, 6 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index 112ccf9c71ca..99e2be39671b 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -386,12 +386,17 @@ int __meminit vmemmap_populate_hvo(unsigned =
long addr, unsigned long end,
>> void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>>       unsigned long addr, unsigned long next)
>> {
>> + 	WARN_ON_ONCE(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));
>=20
>=20
> Not sure if a VM_WARN_ON_ONCE() would be appropriate. (then, we have =
to move the
> pmd_set_huge() out of the statement).

I think it might be better to keep WARN_ON_ONCE here. This way, we can =
still
monitor for warnings in production while keeping the code simple.

>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

>=20
>=20
> --=20
> Cheers,
>=20
> David



