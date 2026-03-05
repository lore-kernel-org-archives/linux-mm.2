Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2584AF3D332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4476B0093; Thu,  5 Mar 2026 11:55:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A12F6B0095; Thu,  5 Mar 2026 11:55:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A316B0096; Thu,  5 Mar 2026 11:55:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 659546B0093
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D731B6FE2
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:55:42 +0000 (UTC)
X-FDA: 84512610924.27.03DA714
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4D3C1A000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:55:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sqNO9UcP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772729740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hT4+PlNJ1Mkp07e5E9uoTzP3KOj0N54uHsOXux45Z6Q=;
	b=y6Md6p+6uACEbNRIqJ+ed97o/72CBUEB1+dKUdLnC+eygAeZSbLR7F50AwBEvsGRk48t9u
	ULbNMkQhHcWegDGwMPpzDHPrBylqjrJPbTpgxU5MldIS07NBec35C9v1PHpkk6iAgGmu6e
	pAThCzXkXSX/yXeizw3yJV1H2Astt9Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sqNO9UcP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772729740; a=rsa-sha256;
	cv=none;
	b=h5q/Y3D7BBHv0UVDzVEiEtAOde79Wz7R1wFNbDkHe8OgE3ZdOo1oyh8fUdcirrv81dwIGd
	2BHj1BDncexQe7NTHGhmbBjmk+IQ5kUyPqEH2sm4SxlrjlVxR6+wkcG3JceNhlBcCtpHER
	VGLTcmk2mwofOZ8S+G3mtkjAAS7brcA=
Message-ID: <6982e9fc-cc17-4d4f-b26e-83997c4bf070@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772729735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hT4+PlNJ1Mkp07e5E9uoTzP3KOj0N54uHsOXux45Z6Q=;
	b=sqNO9UcP0hmtciXBUAu7Ynkl1qEUHh7iFRCJkxQmZwrS5u0cKwu7aFd9qHPcfEcKmuh9E1
	G3X1kE9KcKVzFx69GZouJPdBt6myNS3LdOTaKYGVTad3j9s1CgcwNUA1rBW+5hqn2Y+h4D
	SmDMIzXQmBmMW3/PLs2vrrEchW1oYoA=
Date: Thu, 5 Mar 2026 19:55:22 +0300
MIME-Version: 1.0
Subject: Re: [RFC v2 12/21] mm: thp: handle split failure in device migration
Content-Language: en-GB
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org,
 fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260226113233.3987674-1-usama.arif@linux.dev>
 <20260226113233.3987674-13-usama.arif@linux.dev>
 <CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D3C1A000A
X-Stat-Signature: eoba8g49xdy97m1nsxpixnkeubd4z3yj
X-Rspam-User: 
X-HE-Tag: 1772729738-415996
X-HE-Meta: U2FsdGVkX1/JM4yozz85v5Zo65MDIKG0s+fnwRDvgZencRIvPHTKIMDEIqtuNRb5SMHevmTEY5EDfxGJqferf1mNnuNnCKyi0Eo+BOQwWW0WvVSXTBk8xuhfmXkgshO9YauPhU4gmnpAbX8738B5fp1/DMgaXjSnS4Di9De4UtwsDr8caO188RaXXrAoq0aQUDUBZEEjeC06kGpV5iISf9ulCdM9bQqu9cWKaK2oeU8Kxaey/nch4wxu1oBKEGtKBLAmstLdSx6qociHihUxPqC0BtQJB6uEf9Vukt/NGgXK6KgOWYdV8ZpbneZ5M19L5gNfHJebiZatuI5fsV8iT3C86GXy8Dxf0BoO2sXcJsxlMBawiXDssAc9yIbtgZg3VzCnl0SmG/XDuBJN7Nc+tXCu3XYgRmS9bWeJh0Vr5EtNrZcPlEwrFl98bytXyFLi6I6NUtxGGT21HutYebdTUiP68TqWDYfwfls/T7Q+voCDx5DLgPzeE6OnJR5OiIOljqLK+mB75FngdSidHSCZsIlVKZObVvoGzrVvdql9Vo0eybHrv3g1iBPpKfyOCuMKMRCmFhv2xiq5ebUvf51agbNV32ttXuOXvR/vvX0fxq7kzlalbmbjD4w+G94Cur7cLUFyjZyEzqw7Xr05dya5WO6WD7ozwCAzWaDlbV+3fsgBcbKkOoLZpUeyRnwRuYtkJ/PX7nlso4nWvY+96FVuAcp71jv19Qi6gLQz/S+OKKaxqaVDkvFIFOkk124YKpTDcxl78FyhQ/MXUOY3pe93KKbA8MPTiFIiSNLlAu8tpeMc/WchguvA4eMkoxo1n7Acn5oz0S9lLESa84wjnLkSSa2Zo16yhnoNgTFOd0adtNDJMuObNnBhtsb8HM2/8TZh33DmcEeMuw01DHqMnPKuAGqDvc+vmw/BBtTpexcVZnIj3c6wC9BMdj22rgQ6lLkmM8O+bA+z+yDKEZO1Aqd
 quDp9Fd2
 2MnCpubHAYM0Oakbvuw/jU6vnISfQTJW7cUxtxPODOAWo5Z5yWwnGxUoT9YjDNUhp1qCzQyToMs8RlFGEkPVXzxni3nTEAV0jwkeOOfnz7+czy5iIWaeLkCDGCY0kGy+0U9BfgJMEOtjiWRSGxS5LjP7ajKfd1RX+nfKmMKorF9C80Sw86ovr6ZeiJq3V6KiufgSmqUWwQav5y3DxdeaDy5g1RtSAJdwdsPVUmdHidNrjxsSOMAgfF/Eikaw08s4QpWn2kizjccfS9NRdjIsglLLJl01IJdXAbPaG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/03/2026 21:20, Nico Pache wrote:
> On Thu, Feb 26, 2026 at 4:34 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> Device memory migration has two call sites that split huge PMDs:
>>
>> migrate_vma_split_unmapped_folio():
>>   Called from migrate_vma_pages() when migrating a PMD-mapped THP to a
>>   destination that doesn't support compound pages.  It splits the PMD
>>   then splits the folio via folio_split_unmapped().
>>
>>   If the PMD split fails, folio_split_unmapped() would operate on an
>>   unsplit folio with inconsistent page table state.  Propagate -ENOMEM
>>   to skip this page's migration. This is safe as folio_split_unmapped
>>   failure would be propagated in a similar way.
>>
>> migrate_vma_insert_page():
>>   Called from migrate_vma_pages() when inserting a page into a VMA
>>   during migration back from device memory.  If a huge zero PMD exists
>>   at the target address, it must be split before PTE insertion.
>>
>>   If the split fails, the subsequent pte_alloc() and set_pte_at() would
>>   operate on a PMD slot still occupied by the huge zero entry.  Use
>>   goto abort, consistent with other allocation failures in this function.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/migrate_device.c | 16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 78c7acf024615..bc53e06fd9735 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -909,7 +909,13 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>         int ret = 0;
>>
>>         folio_get(folio);
> 
> Should we be concerned about this folio_get? Are we incrementing a
> reference that was already held if we back out of the split?
> 
> -- Nico



Hi Nico,

Thanks for pointing this out. It spun out to an entire investigation for me [1].

Similar to [1], I inserted trace prints [2] and created a new __split_huge_pmd2
that always returns -ENOMEM. Without folio_put on error [3], we get a refcount of 2.

       hmm-tests-129     [000] .l...     1.485514: __migrate_device_finalize: FINALIZE[0]: src=ffb48827440e8000 dst=ffb48827440e8000 src==dst=1 refcount_src=2 mapcount_src=0 order_src=9 migrate=0 BEFORE remove_migration_ptes
       hmm-tests-129     [000] .l...     1.485517: __migrate_device_finalize: FINALIZE[0]: src=ffb48827440e8000 refcount=3 mapcount=1 AFTER remove_migration_ptes
       hmm-tests-129     [000] .l...     1.485518: __migrate_device_finalize: FINALIZE[0]: src=ffb48827440e8000 refcount=2 AFTER folio_put(src)


With folio_put on error [4], we get a refcount of 1.

       hmm-tests-129     [001] .....     1.492216: __migrate_device_finalize: FINALIZE[0]: src=fff7b8be840f0000 dst=fff7b8be840f0000 src==dst=1 refcount_src=1 mapcount_src=0 order_src=9 migrate=0 BEFORE remove_migration_ptes
       hmm-tests-129     [001] .....     1.492219: __migrate_device_finalize: FINALIZE[0]: src=fff7b8be840f0000 refcount=2 mapcount=1 AFTER remove_migration_ptes
       hmm-tests-129     [001] .....     1.492220: __migrate_device_finalize: FINALIZE[0]: src=fff7b8be840f0000 refcount=1 AFTER folio_put(src)


So we need folio_put for split_huge_pmd_address failure, but NOT for
folio_split_unmapped.


[1] https://lore.kernel.org/all/332c9e16-46c3-4e1c-898e-2cb0a87ba1fc@linux.dev/
[2] https://gist.github.com/uarif1/6abe4bedb85814e9be8d48a4fe742b41
[3] https://gist.github.com/uarif1/f718af2113bc1a33484674b61b9dafcc
[4] https://gist.github.com/uarif1/03c42f2549eaf2bc555e8b03e07a63c8

