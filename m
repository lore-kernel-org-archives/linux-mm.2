Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB753606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KfZYqXf9
Received: by kanga.kvack.org (Postfix)
	id 18CD76B05B7; Mon,  2 Nov 2026 07:34:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CFE6B05B8; Mon,  2 Nov 2026 07:34:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07AC96B05B9; Mon,  2 Nov 2026 07:34:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D117D6B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:34:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67DA01C46FD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:34:27 +0000 (UTC)
X-FDA: 85390122174.15.1589EA1
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 341C616000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:34:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KfZYqXf9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHR2wmYq7evlbOMXxZo7N5sGiKLQtqsE8M9Nv0sAcLQ=;
	b=caPQ12U3r0EcYTwxYrBvI7nIGuEq95b4xYIE4q5gGwowhZ7YWSl1u7r7pP+/rmgBauSqA8
	+2njx1yDwUWEM8cUF5ko3iYQj0X+2j+Zq5bsGQkW+wBTRt7c9PyytfI8THUD4cqFekDiEU
	NcVGeSQXBDW4NuyMxm5mg1WADhY8Exk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KfZYqXf9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622865;
	b=27ZMjqLD2M0H5y91VpXwBYXq5mut2k6AYmBpMV5WMzUbP+ErSG+TiDo10rbb/cA2O+CwlR
	hsOTRCAX8vZzcTGFdkYeyyQiMxXV6yWeLCG2gwLScwWvWv/t78gWScJnfgrRfx5sq/34Ig
	FwmjKmcxc7CB1XM975kWsmd87MjQ22s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nTo7J1ByDV3R803n4yFBSPlPgMm0dVzqitGLHvB5604=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793622863; v=1; x=1794227663;
 b=KfZYqXf9llRLeVn0N8NFxC/MEKZkEp81uwCTw/jQud0fGzxtF0ceZtQPRbsLQEl2V/2LJKe+
 u3lHK1xYDz2BgUhh+5fv3yW40aBcdlJPga6DEQxe2cqjlDqTUbZd8HnvGPLHSwTpF/8tf9mwAvb
 AIaVPgkB/jGGSX0DWebEyZMM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 78ee8f4e54d06351;
	Mon, 02 Nov 2026 12:34:23 +0000
X-Mizu-Trace-ID: 78ee8f4e54d06351
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <179361471104.1337633.3959715900505206111.b4-review@b4>
Date: Mon, 2 Nov 2026 20:34:03 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <09EF0F81-23CA-4F3C-BA0E-41F34A0AA4B2@linux.dev>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-5-songmuchun@bytedance.com>
 <179361471104.1337633.3959715900505206111.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 341C616000C
X-Stat-Signature: bja3tz1ctb5t9e3gnrgrxfs5srfxk355
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793622864-499307
X-HE-Meta: U2FsdGVkX1+vNRf6+rmxFS8nwrCY3VbmWhdjMeHyjSP7m1nxmRnFKaSviHYDLz67YA3c0q9t9hGP05aTalQEe5lXeXHJdS1nLvtqGA+R/XH1nysBFYGjq4s6L7CpGPd6aZMvmU8qAFugryN3D1b69P3vV2s52YRQRaxb8RfU4MbytbV4R6R4vIVLCgHDUVxCEz8FwmeYZa80ye5sUZUnj2/pgjMKDCzo1qAlBcAe+CSIO4btXoAm2bUSCx58d4RLSWUwxu84+46n4pGSBH8L/qipsCE73PvkJOsYi4TbuFsFKww40d+owsQHg5L/7wWxqbWURCPmVHE1muVAbc1g4mA94+R0vxe0Uc2eanqXvczQPl3Mx6YrmJlCfVcCLrdUJvltg5SrQ3tzRUyAzbJQhrIYN55zmHlXXzSLUumSUrYavGfjKITEFNUrgoFWqJhRz8XK6wOKrltbB8rG7jBY1zuu6asHnx4roKHV3duOnyXsNjPjbZE4lDJA7lZEUkF6h+JbCJ56K4vvVxJxjSCuvaCt+ZY2Zb1nTV/Gf/eBMRIirm5RlYTxG6B1lSWhf1tfPyO3KRFnWJH9QiSyuavJkAb1XwXMtaFanI844f1aahc8NO4OUR8kcIn2oQhGekX8u0M+2GqHH4KfM1+Z7ctb6W3DGsjaADu/dQdv9PDgtrYp8GPc5ufUQ6004Z74nOH5TDlRQ6GdKzHO/GJF9tfSAyFgAVTn9iZdRUqvdTVYr0zZZhoLbGCT0QJZ6Q2I1qboqt2FRVZf22g+AunxdP0ZK9KEPlVN2dZtqhWnx9y9oAijWtBgQknCAJpgivlW/79/xCha+j6AGxlgrDNX+TItb/GOxZBNBILqp1tyHruq6pUpC9VUVpp1vE9MC42LWpzAJ/MA1mB5Z4h6P+nHb41uk0Tr/65YLVphuNO9c79RrlOw4g6/HVMs9A9yAnaR1XB55ig7ZsHY6UjJl2dvYL5
 RgW2jjS+
 WMGMcB0zF4bUs3s8yk1YexOeNJJBjw/mBIpA/0KNmJDPlXN8ruGMyJD9BZlrx4N0riZ4KElZXw2AS5ZfsN6uQYJ6ggN7f+dhZvq836IWxqbqUX97P+Xqpq/ZCdLwWi+4QXO0ddcGriXJqWnCTbI2uYRvnJ0NVVybsuUJwo6yPXZ3kX3CvFqlnUgjPuW2Zf1lDRLxkuAc51W4eev8pLoICVXbwpXB/XX0Q220PPtVLb0JK/mqEBJRxwBaFDMi3addtegH5j+2z4Yoa2sKC3C+p3eoDs34pLbWNMZ7modORnTawdlt4K0601bPB8jiqjY5I5NCJ5qVo/cbXI8YyVfYJ9kEhP+T5ALPb8VFx0ZNx58JDws8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 2, 2026, at 18:18, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,

Hi,

It's my email client's fault. Let me email it again.

>=20
>> Vmemmap page allocation is currently tied to restoring a virtual =
range
>> and assumes an empty destination list.  These constraints prevent it =
from
>> being reused when pages are requested independently of a vmemmap =
range or
>> appended to an existing list.
>>=20
>> Generalize the allocator and give it an all-or-nothing list contract =
so
>> the restore and optimization paths can share the same allocation =
policy.
>> This also allows HVO head-page allocation to fail gracefully under =
memory
>> pressure without triggering the OOM killer.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
>> ---
>> v2:
>> - Collect Reviewed-by from Lance Yang and Qi Zheng
>> ---
>> mm/hugetlb_vmemmap.c | 39 ++++++++++++++++++---------------------
>> 1 file changed, 18 insertions(+), 21 deletions(-)
>>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 0e5b2b182d1bf..4b20a8efc0678 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -334,28 +334,26 @@ static int vmemmap_remap_free(unsigned long =
start, unsigned long end,
>> return ret;
>> }
>>=20
>> -static int alloc_vmemmap_page_list(unsigned long start, unsigned =
long end,
>> -				    struct list_head *list)
>> +static int alloc_vmemmap_page_list(struct list_head *head, unsigned =
int nr_pages,
>> +				    int nid)
>=20
> Please indent with two tabs, like David likes :)
> Applies throughout the series.

Sure. Should we update scripts/checkpatch.pl in the future for MM,
since this script seems to favor the alignment approach?

>=20
>> {
>> -	gfp_t gfp_mask =3D GFP_KERNEL | __GFP_RETRY_MAYFAIL;
>> -	unsigned long nr_pages =3D (end - start) >> PAGE_SHIFT;
>> -	int nid =3D page_to_nid((struct page *)start);
>> -	struct page *page, *next;
>> -	int i;
>> +	LIST_HEAD(local);
>=20
> Can we use a better name here please? E.g new_pages?

Yahs, make sense.

>=20
>>=20
>> -	for (i =3D 0; i < nr_pages; i++) {
>> -		page =3D alloc_pages_node(nid, gfp_mask, 0);
>> -		if (!page)
>> -			goto out;
>> -		list_add(&page->lru, list);
>> +	for (unsigned int i =3D 0; i < nr_pages; i++) {
>> +		struct page *page;
>> +
>> +		page =3D alloc_pages_node(nid, GFP_KERNEL | =
__GFP_RETRY_MAYFAIL, 0);
>> +		if (!page) {
>=20
> I think goto err_do_cleanup is cleaner than ad-hok cleanups

I=E2=80=99ll use goto style, either is OK for me.

>=20
>> +			memmap_pages_add(i);
>=20
> This is confusing. Updating counters only to use
> free_vmemmap_page_list() seems worse choice than walking the list and
> __free_page().

I think the memmap accounting should be done right after each successful
allocation =E2=80=94 that way, using free_vmemmap_page_list() becomes =
more natural
and simple.

Somthing like:

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c04f53f708d2..cab9ec14873d 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -207,14 +207,13 @@ static int alloc_vmemmap_page_list(struct =
list_head *head, unsigned int nr_pages
=20
                page =3D alloc_pages_node(nid, GFP_KERNEL | =
__GFP_RETRY_MAYFAIL, 0);
                if (!page) {
-                       memmap_pages_add(i);
                        free_vmemmap_page_list(&local);
                        return -ENOMEM;
                }
+               memmap_pages_add(1);
                list_add(&page->lru, &local);
        }
        list_splice(&local, head);
-       memmap_pages_add(nr_pages);
=20
        return 0;
 }

Thanks for your review, Mike.

Muchun

>=20
> --=20
> Sincerely yours,
> Mike.



