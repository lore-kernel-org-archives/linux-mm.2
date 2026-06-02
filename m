Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7876CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 15:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37CBE6B008C; Tue,  2 Jun 2026 11:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32DC16B0092; Tue,  2 Jun 2026 11:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243636B0093; Tue,  2 Jun 2026 11:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1775D6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:41:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6FB5C3040
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:41:44 +0000 (UTC)
X-FDA: 84835387728.06.32B90AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 091E940014
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:41:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=me0jPRdq;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780414903;
	b=sXIO2Inf2YO6vHgqR1K3QT5aWLONHNysFe2vs9Mrs/jKkUwKqLWtpi5rPh+InnqLH2N8qy
	1eZ/WrqQfziJDN3AOYEz4lgvHJgLwGx7x7YSxOJk+wk+JGj13vn4yNlelZKpZL/040l6WV
	+y5u7TfUo+wHsBqfS10rS82OEyaBv8w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=me0jPRdq;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780414903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDeL5/tHUjTJpeqAIfWOboAboZg65R7Pct0LUws/rMs=;
	b=eY+PFHI/YzGIJ9DSWq2odlnPKua1yfX3jMqtH4MGz1XSxWxgE5vX5zmJtzUWOJj318a/Tj
	2MnvRrgs/TxebkDjnLP1QI8cyilXCZiL5p8EvGxfL+UIKbzQDyl98TOZnCvQEhw1NafGFF
	pTz43uZwNZ4XWCjTi4rj4EUIkavRB0M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A81F402BF;
	Tue,  2 Jun 2026 15:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2291F00893;
	Tue,  2 Jun 2026 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780414901;
	bh=dDeL5/tHUjTJpeqAIfWOboAboZg65R7Pct0LUws/rMs=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=me0jPRdqnYj5C46x8bmjWHIvOjXoVYz0SkW/4T7z6T7OR2Bev2C7GE8dK8iejFgmX
	 rPPsvKBB7LgVWJW8DY6j8/AmrZff7QYT1Aotq5i0IwgzRdcempoD8jLuVXBN9oUupj
	 A0Jxb0YwYK56EsboskstCYohBV1bXPVbCz+Yt5SXojiGrPoa14eyGkGbZKEFz/PM4j
	 9CB8lvlKt2/S88rPxX4vG/cElRl4bq37AplkPCvLm0HEaiT50q5cXecSKSN2CYg0Nc
	 efCraJAOJgznly00AO4p7vjQ7RnyVdICzv2UwJ3ay4bEPKhhchpLUOBsgXmQhF9SEU
	 FAR9K3i3FeSeA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 14/19] mm/hugetlb: Free cross-zone bootmem gigantic
 pages after allocation
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, 
 linuxppc-dev@lists.ozlabs.org, Mike Kravetz <mike.kravetz@oracle.com>
In-Reply-To: <20260602101039.1867613-15-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-15-songmuchun@bytedance.com>
Date: Tue, 02 Jun 2026 18:41:33 +0300
Message-Id: <178041489395.457517.12727427621570734471.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 091E940014
X-Stat-Signature: edk3ku5ey5cnp64uc4tgb4kx8ekrn4t9
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780414902-951278
X-HE-Meta: U2FsdGVkX1/4csyVbhFyejHDOwkRgxKplBzh1E1a2/5c20zjW1kiVhBE3slM9nRCA6xFwCgSeRCZNloWgiQdfKAOv14N60gNCtxx/4FOfDBUw8nR0D9ijVrTX3fS0L2cBX8XEcSRv1p7/TsA1ZoEMKZy3xUw0dY3B8GxRKRnGc+plHuR5kqSUg++AADUznUislhx+x7yDOmzaz7yW0of5pb/66lUwnd3C/aET6Wjs6fULh7llvQ7L7OQo5yEb9tQ2x7cOGEAZmtXu16O0NnICOfi+0SiFQDONbaNzk4gcg75YzjBJCQsQcWDknPIiEjWP6zNgqdtZKj6A8G54aMrXXvHn8K7RksuemOtScToSLZRwqczjDt4vs2KOG0q2rH0MuRsYMDASI/KaAR1fK6CK5jLPzMlT+3mSfQrbzapzqtvz5GrpkhBm2owZWBwI5ynynIP/K8hmozrtQCApdI8ISls0ubHbX38s/AKC+1tOMzBWoeS7pohcNU0O1S1bpTYw9f8av73GdNtjTQFHPcHjFAWBkZAhpV8z03WAgcK9XI6ApoPhvBFgiQTTt2cVq1fq7m1rqQ1BizLFZaFYb0OP8kMhAMs9j99M+aTXgmlxFkqh7uwaV5KK3egIk9pEBLAtzSnjS5ZEvWAkWW01ItktT+DbT7UykPJQCyoSd6LiMkG7uYM6N9Kks4DsH7/cJFmjIqJwAX25iCDvR7nvK+scQZ18rbNxDR8A4dipIMqBQd2LYnuxNJCzNjG6xDwF+Ge3HQasbHVZDtvarON5RPEx682zyBHs246nqsmaGfGT5SM+OLSw4BshPZxUeqsP1nspPVZHxY4hJfyjqffgQt35IjSp9AUICLqQdsg3l455/nICqG2miPcX3Kjno9STWkogK17s/ZxSo7LW8v12o/Ah77hj8mx7BEXtIk3kk1K0AJLpEhwG6w1B+nafnzGM1/azIKPF7YRyfddwlqovdT
 JD48hhJP
 OqXgG0sPOxQTRQk9dixIUhHrT1yeIaOpNAc3nz50NA4vtK8nWrDDMa77m77lZxbPuoL+1Cp5YFJN8pgDN/NEJnJcf+pXJQdGfmcgvZMl9Gj+SC1V9tVkj4sVzjkKGp4VLkUtIo9ZwlKRQxkqYZPuxhUu65QNrLzakR6g/aoxCUEF/OLEtl8MFwS2JMwXPNwcOb6Mb5MVj1iX723qQGincb3sPoNSNdd5Hg7UDhUQQU1+uTJXpXCCVPbFDjytJ1fqZVQiQsEstD6eC3mnQ1ed+Y5tfzmRYM5SPihQC1K8YU+unzJltkdxxithpfwsebAZY/0Il
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Jun 2026 18:10:34 +0800, Muchun Song <songmuchun@bytedance.com> wrote:

Hi Muchun,

>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 5e557c05d80a..218fb1ca45f4 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3073,22 +3076,38 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
> [ ... skip 26 lines ... ]
> +		 * pages belonging to the requested node.
> +		 */
> +		if (WARN_ON_ONCE(nid_request != NUMA_NO_NODE && nid != nid_request))
> +			list_add(&m->list, &huge_boot_pages[nid_request]);
> +		else
> +			list_add(&m->list, &huge_boot_pages[nid]);

Can we just memblock_free() the page that intersects zones here?

Rather than making alloc_bootmem_huge_page() bool (sorry my bad :)) we
can make it return -ENOMEM when memblock_alloc() fails, 0 if the page is
not usable and 1 (i.e. number of allocated gigantic pages) if everything
is fine.

The callers would need a bit of massage, but it still seems simpler to
me than adding them to the list and then walking that list.

-- 
Sincerely yours,
Mike.


