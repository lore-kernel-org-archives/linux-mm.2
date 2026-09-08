Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533FFC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E4C6B00A7; Tue,  8 Sep 2026 05:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EBD6B00A9; Tue,  8 Sep 2026 05:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F926B00AA; Tue,  8 Sep 2026 05:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42C946B00A7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:12:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8955404AA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:12:26 +0000 (UTC)
X-FDA: 85190029092.11.5680DA2
Received: from mta1.migadu.com (out-145.mta1.migadu.com [95.215.58.145])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9BDA040007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:12:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H5b7n2t8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.145 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XZu7aifbvatTgEqnvJnf1R0X/PHnQuQQyNt48EL1Sg=;
	b=olv1cTXBPz1w6IM3NP/BYFvyLUusd3AyaSMx1Oj8URw7epOFxnzb3aCJtWRwlP9ufRsSjM
	oRcmQDHn3a9c4T8Brgpp7Y3OumnY56eP86FFMoMRbqN8ezeFPx6iLy9eVMr+8sEYKiPTqp
	l/0iVAOH11HBr8FNCMWySDjecSG4Teo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H5b7n2t8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.145 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858744;
	b=3/oIFGCF/NGlHNsSz7rMbeWtw0O+WaMJKFU7hFYIzLscFnmSo56wMSruWN/lV4XLJl9XfN
	lbj8e5IpayZRWwXy28SrGApmZcJub8WWiLtdJ+aYNjWhqAFozakgv8CN6hLTfKJWN6Fin5
	huEYqB93rIGNveY6ufQzg9rh7Ep6f2o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kxPh0WuMikjVIxMhGlyVx6DHT10KZS3T52C5dULvHFU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788858743; v=1; x=1789463543;
 b=H5b7n2t8xEX7kB8ah1JxYVFXls5FQ2H1W8P3YqZqEeS1p5LmhzsbDAaSEaUxFa0y5wSwH1C+
 eUTJ6GoDjVhtEoBiBu9Cxf3XlEiZw1fWTV+Zw988vIV98UUZoZrjg5w+qJ9l7XZwZkMHaYpP1VQ
 rWWwPJHjD9AG6CFF7XB2SgQk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e6379ba285176541;
	Tue, 08 Sep 2026 09:12:22 +0000
X-Mizu-Trace-ID: e6379ba285176541
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2 09/11] mm/sparse-vmemmap: drop the extra tail page from
 device DAX reservation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <f2f1f7e4-539f-4385-a28b-1fde074cdeca@linux.dev>
Date: Tue, 8 Sep 2026 17:12:07 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EBFFB66B-86A5-43A2-95B2-37964D7D753C@linux.dev>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908030335.96549-10-songmuchun@bytedance.com>
 <f2f1f7e4-539f-4385-a28b-1fde074cdeca@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Stat-Signature: ypup674zmm8fzbbee36zpuumk78ttjp6
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9BDA040007
X-Rspam-User: 
X-HE-Tag: 1788858744-249804
X-HE-Meta: U2FsdGVkX192Qs7zEEORmb+Sc/6V9777RJCsnDRxh/WMrcSo6Fu1hFdQBV7/66i1mUfs8cVENnV3QxpjGYSRlb1eepsrAkSOZYIjvi3DWPWEYhGGq0jFTI3L1dbCYfaE92k1o/r2jHV+uVVldpelpe0p232vkPK1H6Sy4utUuFW40dppSScQ9Zc3+CpcWN3/d+Sp5P6Ow+rZP15kl9oKr6oHL2e2iif3IuZHTQ5jPQOXWI3iQGiLdwqwYCzuWL0Dj9aARw+ruOVBRk/lQ5knqn/hrS+Bg1JpeQahOwqarY4tVR5QtF2OAsbH8NhmZLa7YPzUm1LJT7rD6xHV2plesZgPc53T6D2qlhesds4ia8Y5HKyKXzJm49mE2XZ1rwRLxGqeS5V0oIWM3ODwJkUSSRg8FwtKtvc43OegpQVAZeO6hcLLreF1e3ZjxulNBLLqSvYowf3WHKrIqvnp6xuYXosUut4rCW38eNTu2WtCo+kgcT9XtSfSUU1gSnNZqCk+UdL0TyfdhxtkjmDwd/EedY8AMQNsohUdRvc013Luj5tJKlnj7/MJaTD86MOdZUFV8V2ta/HqDr1eYaTSfAJ5hLhOC7uW3y28n2N403lU4gfdye6bRpHE96hXVrcCkGCRpb/t1GA/fYrOIFUZu1/4A04zRx1vt3wjlBdD8QvtcBvS+IXygNIUvuiwIOMgzSBvkqnO47T0uqqHb0XtD8QCNYcxGAA7Rna+PTz44icYVg3/1GZ1Ni/YuzxpUzrCVvLBkkzTeYZkXvKDm9roXCbIf7pMNWzUoR/fS8Urc/3biJ45KuFUIqC09f5hxtrj6bluYxZdCgfnXOhYGid8A9+nVh6nrOpN548IqGkeZ9Pm5mwQvZx8JbDFLfr0cLAaEezTxCugbrBCCNtdUU75JN62KRN7DiqNKRZHvDmEQjszi6yanV91lcVrbF0a9ZBwruNud28DEJ+iwe2ZPGCSvoS
 qhm6yYW4
 zq+Eq/6wPyTfgAn4esfYhE8FaP6keomFft8AOVupyqYtlpao4Tw13myVa6cnMMFObaH8Y4pEC2+GCDnMPcWC8T9toJZi84NRntlRtk3BxBCdnH3XOYPiGeBynRXEKqDWFXRps+bCzyt2A38rzQj7C0sdO4BJpjVPfwVjgImRCHk3NDUAD7fVUlAgT/cWkdtVTMtWVbek7G4m8wAvvaeEQc+UXr33SOAhgHsRo9077UipK+IxQAltlbJWFf1cEJmtGmhTOuhWQyfQsKqRZgRpbP57LCyX1vO2SbajpmeY8lNMV0ghLUl+iObe/1HB6Ml6FnMJ5atJhYUKxBxWMautEz/bKvsOp4AE+aA/x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 8, 2026, at 17:09, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 9/8/26 11:03 AM, Muchun Song wrote:
>> The device DAX vmemmap population still reserves one extra tail =
vmemmap
>> page after the head page.
>> Drop that extra reservation and let the shared tail page cover all =
tail
>> vmemmap pages after the head page, so DAX follows the same =
reservation
>> model as HugeTLB.
>> This reduces the reserved vmemmap pages for optimized DAX mappings to
>> one and removes the now-unneeded first-tail population from the =
generic
>> and powerpc paths to simplify the code as well.
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>  arch/powerpc/mm/book3s64/radix_pgtable.c | 46 =
++----------------------
>>  include/linux/mm.h                       |  3 +-
>>  mm/mm_init.c                             |  2 +-
>>  mm/sparse-vmemmap.c                      | 13 ++-----
>>  4 files changed, 7 insertions(+), 57 deletions(-)
>=20
> Looks like sashiko's response [1] is a false positive.
>=20
> [1]. =
https://sashiko.dev/#/patchset/20260908030335.96549-1-songmuchun%40bytedan=
ce.com
>=20
> __SetPageReserved() in vmemmap_shared_tail_page() marks the struct =
page
> entries stored inside the shared vmemmap backing page, i.e. the =
metadata
> templates that later represent DEV-DAX tail pages. It does not mark =
the
> struct page of the backing page itself.
>=20
> On hot-remove, free_vmemmap_pages() is called with pte_page(*pte), =
which
> is the backing page. That page is not reserved, so the teardown goes
> through __free_pages(), not free_reserved_pages().
>=20
> Right?

Absolutely right.

>=20
> If so:
>=20
> Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks.


