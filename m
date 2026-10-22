Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018BC606A324
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H6LhaWim
Received: by kanga.kvack.org (Postfix)
	id C49836B08AA; Thu, 22 Oct 2026 02:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFAAF6B08AC; Thu, 22 Oct 2026 02:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9036B08AD; Thu, 22 Oct 2026 02:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88ED16B08AA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:27:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A80A1406B9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:27:57 +0000 (UTC)
X-FDA: 85349281794.19.D2E9BB2
Received: from mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C50920005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:27:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H6LhaWim;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792650475;
	b=pQ1dSfZaRfE2pzRwsUleXpZT2km807xaigvnq4Twn0uk0vJlEHlZDY+GLs1+yOaSbMHyE8
	l80fkRR0QejzKsoTl3Czedz621aj/g0HRt0eOP5+29JkEWDOFKd3o39x/jV2Qg7V+W8KX3
	vg+754kE/4X9bcE4CyUsrYz1/61YwBc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H6LhaWim;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792650475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4H4b+3/76q62u3qzX7qZgWwUH08AcwDy4+VDBczMcl0=;
	b=HFsnecwioEQviQ2QoGbaZ6Y0SO6xKOCZkK69/1Iz5ZjjdaOYn4efM/xaKRFLQUEyQLB9JV
	SzReDwRbfIVA+ccxIi2bkDn4L1Z3ycOmKYDtqYZVBxRuwtvYsnviJKD5OpSV4vDjjVLKQY
	v2maRnLpkTKAtHJLvU972ICXZHfX59Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=A7Wi4XPUPqxfH/qhOds5gcalhu0uwexg0PkzlXKTB94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792650474; v=1; x=1793255274;
 b=H6LhaWimV3OoG5UBVym689zsfrNgvksU0eqnLktIyyaEtoC2SplrzEkWnQGTfLATLCXMGkoi
 GAkca39oo3sMvoC2fJ71KfAURoQrdC+lsxi2XqKmgl9BXw8ZIf6WJZcMNsUd3/unY5vkK1TMpAk
 IPomPdmz7ECzNtOAKIwx46M8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id ab1c5c7b2a738680;
	Thu, 22 Oct 2026 06:27:53 +0000
X-Mizu-Trace-ID: ab1c5c7b2a738680
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 03/12] mm: hugetlb_vmemmap: simplify vmemmap head page
 handling
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261022062401.62096-1-lance.yang@linux.dev>
Date: Thu, 22 Oct 2026 14:27:39 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 rppt@kernel.org,
 qi.zheng@linux.dev,
 jthoughton@google.com,
 david@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <79779E11-03B9-41D1-A112-52B7375E10A0@linux.dev>
References: <20261020115824.823278-2-songmuchun@bytedance.com>
 <20261022062401.62096-1-lance.yang@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C50920005
X-Stat-Signature: y1wq5fwgrfyhj4djeik5u9emrwrfksoj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792650475-921909
X-HE-Meta: U2FsdGVkX19ePhZSEXTpaz0WeXNunpdS0iax/r4cymZArtL7NIA9sI1ioL2zsff1NvahqpUJAvRRQCK0vU1n7aLGshaxQkA8J7+kOkMROzYQM1QN+sJ7bxQai5lPtp/6vFCi3ub8UO9y8h2D7L4xIcY8aLJlDKGZ5HeORILdjqp7CJnEfnsHPnQk+R8/5/hkWQOMgMLvVIEIYOXo8NlRvc3vrsYtXEjHnqR71Eta5kBFc6wGdgwgj97SMNBFml5NvG6Js1y4FkvDGaOe2JEXBEkuBkPXICTeAjgtYztRGIDlS4kwxCTyaqmwEQyA2mjkgZDUQC54kgt3Z8r7QknYSbnu4iRPQr68HgTsrYPpoUzoD1NRV2cyxK1KezG9dT1BLRwnYQ5oZfKJx510NVSDrlUIkKF56/aqCgqod8yJRH29Wco99+Xm4HyBa4ig04rWR/iVGcXlWchunFEvZgXxt61ePbU1OQ2EbJpCmPu7ep5vhyWzL2SGS7ef5pHL0all/hYpilljD/6If14ndvhCtxOT7oFwFz9W7zIG6cZb4q4mtmVNb1DtiznGEa1BztLe6wpod1Xux4avY7LRqop1tw7HhYHIruifse1ul4zCCbtuwiXeSqOy7vmS2mIuYDNARshPhYNCvIFIcWneaafiEPPYNa5eZ4qnzickWIhKgKRuA2KPvS8jxv4iANatSordNUaSFp0kI1pJgJYS3arcVv6JoCUCxgXG0bi3ZfnC2qsUPA0P6rxZFL8e/VpFXPsucfAeBhXXRqTkVL6/jQRo+YXBNwH5S9XSArVmpRLGCfVK4Uq0jFLfEI8/HMqmhCKI/N2BHbj44lYDhkKsCoI1h6PzO1gX/I/TW8q3D4NQe7Sh/fmkSIgvzDW6nLCmGf63qCVdQVHcRgiCMN8QVXSAH49uvM21WxKwz9Y6g4eadPUuIbe+FCyKisM+qua2cWpfppZuJVaznnXbu02dVtj
 2TkCENYs
 ixhcYpZ8iMXFaz6fwcp30ze4OgnfyztLoi/NfiImNqMTgk/U04/jdM6hU03zRfXQxMRp0tG+0f3lcUxfP96AkiuIKxtNDaLjXO3gbKsZyASginnPqRXUaHN7OkMEQdoOfECuzyGtHl64vHG2WUPqR27Ht04rCXflCfyMSmPK2SXcq0mEwy1+Tb/6lr2n4Mf1HkjvPPrNRahXa3mKLHjO/jXSRzGHSwGRWnI+a9s2G/Ct/u6rID4/op0RNn8k7i32xcwErWtPqVT9NW+wnpcGiX9ijo7cMVJODrUE7H4O4JAAM8DMrQ4t3jVVcLAVw/InbnQgaImGdLciKOAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 22, 2026, at 14:24, Lance Yang <lance.yang@linux.dev> wrote:
>=20
>=20
> On Tue, Oct 20, 2026 at 07:58:15PM +0800, Muchun Song wrote:
>> The new head page is already tracked on the vmemmap page list before
>> remapping starts.  Passing it separately gives the remap walker two
>> ways to refer to the same page and unnecessarily complicates its
>> interface.
>>=20
>> Use the page list as the single handoff mechanism for the head page,
>> removing the redundant state from the walker.
>>=20
>> No functional change intended.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/hugetlb_vmemmap.c | 17 +++++++----------
>> 1 file changed, 7 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 8b3abb562599..164e93e980bf 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -25,7 +25,6 @@
>> *
>> * @remap_pte: called for each lowest-level entry (PTE).
>> * @nr_walked: the number of walked pte.
>> - * @vmemmap_head: the page to be installed as first in the vmemmap =
range
>> * @vmemmap_tail: the page to be installed as non-first in the vmemmap =
range
>> * @vmemmap_pages: the list head of the vmemmap pages that can be =
freed
>> * or is mapped from.
>> @@ -37,7 +36,6 @@ struct vmemmap_remap_walk {
>>     struct vmemmap_remap_walk *walk);
>>=20
>> unsigned long nr_walked;
>> - struct page *vmemmap_head;
>> struct page *vmemmap_tail;
>> struct list_head *vmemmap_pages;
>>=20
>> @@ -208,10 +206,13 @@ static void vmemmap_remap_pte(pte_t *pte, =
unsigned long addr,
>> pte_t entry;
>>=20
>> /* Remapping the head page requires r/w */
>> - if (unlikely(walk->nr_walked =3D=3D 0 && walk->vmemmap_head)) {
>> + if (unlikely(walk->nr_walked =3D=3D 0)) {
>> + struct page *head;
>> +
>> VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
>>=20
>> - list_del(&walk->vmemmap_head->lru);
>> + head =3D list_first_entry(walk->vmemmap_pages, struct page, lru);
>> + list_del(&head->lru);
>>=20
>> /*
>> * Makes sure that preceding stores to the page contents from
>> @@ -220,7 +221,7 @@ static void vmemmap_remap_pte(pte_t *pte, =
unsigned long addr,
>> */
>> smp_wmb();
>>=20
>> - entry =3D mk_pte(walk->vmemmap_head, PAGE_KERNEL);
>> + entry =3D mk_pte(head, PAGE_KERNEL);
>> } else {
>> VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
>>=20
>> @@ -289,7 +290,6 @@ static int vmemmap_remap_split(unsigned long =
start, unsigned long end)
>> * to remap.
>> * @end: end address of the vmemmap virtual address range that we want =
to
>> * remap.
>> - * @vmemmap_head: the page to be installed as first in the vmemmap =
range
>> * @vmemmap_tail: the page to be installed as non-first in the vmemmap =
range
>> * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is =
callers
>> * responsibility to free pages.
>> @@ -298,7 +298,6 @@ static int vmemmap_remap_split(unsigned long =
start, unsigned long end)
>> * Return: %0 on success, negative error code otherwise.
>> */
>=20
>=20
> /**
>  * vmemmap_remap_free - remap the vmemmap virtual address range =
[@start, @end)
>  * to use @vmemmap_head/tail, then free vmemmap which
>  * the range are mapped to.
>=20
> Nit: could you update the @vmemmap_head/tail comment too, now that the
> head argument is gone?

Good catch! It should be fixed in the next version.

>=20
> Nothing jumped out at me, so
>=20
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thank you, Lance.

Muchun


