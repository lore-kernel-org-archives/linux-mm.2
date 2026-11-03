Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E8E606A339
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=erDD87IF
Received: by kanga.kvack.org (Postfix)
	id DB9BA6B00EF; Mon,  2 Nov 2026 22:21:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68A86B05B1; Mon,  2 Nov 2026 22:21:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C581F6B05B3; Mon,  2 Nov 2026 22:21:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C61D6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:21:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F414F12030C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:21:54 +0000 (UTC)
X-FDA: 85392358548.16.90B1E61
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE241140003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:21:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=erDD87IF;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793676113;
	b=6gh8IlfwM2xHUx87STlGJrXBnRzk+8aeDljafitTiPRmP2OWKJVgIKluRuqeiMTyYs33gp
	4cvgOMc61GW3Nwe6Sg5qvYIe5v0+sijIvEnXo61yK8cgfGMnc82aArrhiVTIOf4Dx0UfrA
	Fw4nVthekl16ktrwfm/LwLP4DxdwIG0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=erDD87IF;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793676113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hpdvsK0Hrmc4uMZchvry04ArqEL30GvpLJeJ7hrgyk=;
	b=rEwfmGJ3J3WinnaZmJCKD9C4IrVzrkUYV1wNknweokgfMs/BThtah9E+lMCyEBx5Itkwh9
	IApkyGUy/q0Lva8HJQ5PEwPhtu6MJ3HVd7pgx0y5p0NpxRFSBBnzJL4sMwKEfUg9+S3sjj
	n/kx16NlLKXlxdV3qjazyg/OsR3EcbQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qpopzn/+LxUuJye0OmBehYq4z85SruAh2igo69vC/Dg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793676111; v=1; x=1794280911;
 b=erDD87IFKhVaekyO+FkeXbc9mEeQmViLGA8XE/RWb51zBlfheRmlnVVYU0Wmwc+ZlKAkmPvB
 cOc0qyXE0+EhzTbyhd1ViLBplk32nT6aJW+oSWguQK/AQo/YkDJ2XGIv25yzGyY/CEfFoxm3YEQ
 uRH0YOAKwU8QWigGa/Qs5VR4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id bb50f4f34a0a70ae;
	Tue, 03 Nov 2026 03:21:50 +0000
X-Mizu-Trace-ID: bb50f4f34a0a70ae
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <aujPACLfTbPJnIJa@kernel.org>
Date: Tue, 3 Nov 2026 11:21:31 +0800
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
Message-Id: <BFFEC8BA-6BEA-48E5-8D40-687A630D3D64@linux.dev>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-5-songmuchun@bytedance.com>
 <179361471104.1337633.3959715900505206111.b4-review@b4>
 <09EF0F81-23CA-4F3C-BA0E-41F34A0AA4B2@linux.dev>
 <aujPACLfTbPJnIJa@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: yjymd1u6tutmu33so9j7jn6nzzrptpse
X-Rspamd-Queue-Id: BE241140003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793676112-337297
X-HE-Meta: U2FsdGVkX197n4/vh5kXCVo7Yya/JEU4hgKkdyveqDl7Cr619LZIvryBs20dC2snO4/32W2nv3lrSrMfqa2RlXbBXZqKg3460uvPj0wbWGdzXOdTgPteA2jnga32EecXvHvdgwYb/s4kYEFwF3H2tDRQiS2rorgsQERluOcDmLOfpmCqKPe2K/eHXU8bdoGhaGq7FT4SFXTyVZkezoCUCqE0nDanVD4mOdWJz2QKcjIPXt8y9O8Ro57/1HJK514R/wrqugaIb2YmnyNOdkOYm3xf6jxYeh3zk4iwsAPui8vAUwH+Bwd7KjZ+59pzhWm1AUFXLklMfHHVzgA5TI6RpmsxKHvsNuTv0DeDdvbq7GypfgzneCdlum9I4IFh4FOX+wK0L3iwPUJD7C5pjwjFcSg7DGurqvUam9YOwwFX5i4+fBpt4fWaaGXhzHQ6vmcxFy6kBExu01pcjVe4rcUgJl4Y0iA1Ork1wacTPtc30maZ0TUp6mFkiK6rTvTL9sjEG2GtqbrKbk8dP997evCTSfMHS61v9w0hlNjuoDMFehFi6bychnZXzXV2z3WRnyLmX2DQ7moim9wwe7rXj8KftRE3bAGTSPv4jal8yC1ec2FZ2L7GTYM9+X4QQBM0x8HGz3wMmOu7cnPk4i7Dqkj4MJRPqFBISLimRh9DJvRiaAOCHJSafZmhWmJf4Vh8aT/i/E5fOJXv33KZU1ziVBeNeZlZGCPSPSE163BMbNXXVxpnmlVhN5+DzeVPXM2ZkTpZOeZmf+++hn/xAZhTOkVJaUs9W48+9KAdvQKrS6jHL6YcqSc9T4DKObXzCiVKtDRTC/+ERVZAyjVz1YRlUd4yRSlQvbHJVi5AeETv6CJYTAwqqk3su8/1Dm9OiOuYfM1lmwjQ6gj8TKkfDtZ8V/hn2CI3iZiAUERXyfGlz9F9ByoGj0tGyo+0mfcL+7i1l8loqEGqaJ1+usE+Mx/NO3Z
 vySo+PD2
 HfsQXVENtsAyOj9IeAOj4WrmOylMUJAHLYLBA/0s2Xgs/hAzH5x59CuGvD+UcDtfFviPdCnF/RsjFpxbwia+m9HjNuQX1wOc59GIAVatIlzfbqa+wTJNODMpCRStizplv4NgIntBJ1oqzOt4f65v+OBSnI34vZETMQAAAY23LFz4kZughPC4SV6E+EPcUO9pIuekevrDzfZy+vxZbb3b1JM2c8aPu+GXLPZVATIyoZTYeAXGLnTBdKbm80wBq7nWAYFjO74wGFNkDcpC940CzeRPCqsqvDGW/UfqIc5dGk1BeRVbjpXiIAbaXmiqRD+G3yaf+NhpwQWmJwlCEXK05pLOCEVovsjrcQwttDxB7+cgugr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 3, 2026, at 01:57, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Mon, Nov 02, 2026 at 08:34:03PM +0800, Muchun Song wrote:
>>> On Nov 2, 2026, at 18:18, Mike Rapoport <rppt@kernel.org> wrote:
>>>=20
>>> Hi Muchun,
>>=20
>> Hi,
>>=20
>> It's my email client's fault. Let me email it again.
>=20
> Things happen :)
>=20
>>>> Vmemmap page allocation is currently tied to restoring a virtual =
range
>>>> and assumes an empty destination list.  These constraints prevent =
it from
>>>> being reused when pages are requested independently of a vmemmap =
range or
>>>> appended to an existing list.
>>>>=20
>>>> Generalize the allocator and give it an all-or-nothing list =
contract so
>>>> the restore and optimization paths can share the same allocation =
policy.
>>>> This also allows HVO head-page allocation to fail gracefully under =
memory
>>>> pressure without triggering the OOM killer.
>>>>=20
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>>> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
>>>> ---
>>>> v2:
>>>> - Collect Reviewed-by from Lance Yang and Qi Zheng
>>>> ---
>>>> mm/hugetlb_vmemmap.c | 39 ++++++++++++++++++---------------------
>>>> 1 file changed, 18 insertions(+), 21 deletions(-)
>>>>=20
>>>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>>>> index 0e5b2b182d1bf..4b20a8efc0678 100644
>>>> --- a/mm/hugetlb_vmemmap.c
>>>> +++ b/mm/hugetlb_vmemmap.c
>>>> @@ -334,28 +334,26 @@ static int vmemmap_remap_free(unsigned long =
start, unsigned long end,
>>>> 	return ret;
>>>> }
>>>>=20
>>>> -static int alloc_vmemmap_page_list(unsigned long start, unsigned =
long end,
>>>> -				    struct list_head *list)
>>>> +static int alloc_vmemmap_page_list(struct list_head *head, =
unsigned int nr_pages,
>>>> +				    int nid)
>>>=20
>>> Please indent with two tabs, like David likes :)
>>> Applies throughout the series.
>>=20
>> Sure. Should we update scripts/checkpatch.pl in the future for MM,
>> since this script seems to favor the alignment approach?
>=20
> Yes, makes sense to me.=20
>=20
>>>> -	for (i =3D 0; i < nr_pages; i++) {
>>>> -		page =3D alloc_pages_node(nid, gfp_mask, 0);
>>>> -		if (!page)
>>>> -			goto out;
>>>> -		list_add(&page->lru, list);
>>>> +	for (unsigned int i =3D 0; i < nr_pages; i++) {
>>>> +		struct page *page;
>>>> +
>>>> +		page =3D alloc_pages_node(nid, GFP_KERNEL | =
__GFP_RETRY_MAYFAIL, 0);
>>>> +		if (!page) {
>>>=20
>>> I think goto err_do_cleanup is cleaner than ad-hok cleanups
>>=20
>> I=E2=80=99ll use goto style, either is OK for me.
>>=20
>>>=20
>>>> +			memmap_pages_add(i);
>>>=20
>>> This is confusing. Updating counters only to use
>>> free_vmemmap_page_list() seems worse choice than walking the list =
and
>>> __free_page().
>>=20
>> I think the memmap accounting should be done right after each =
successful
>> allocation =E2=80=94 that way, using free_vmemmap_page_list() becomes =
more natural
>> and simple.
>=20
> Why are you against using a loop with a plain __free_page()?

I'm not against. This is probably just my own fixation, I think I've =
fallen
too deeply into the trap of code that looks simple but actually isn't =
that
great. Good thing you pulled me out in time. So I'll use your suggested
approach to fix the problem here.

Thanks,
Muchun

>=20
> We know for sure it's not a reserved page and there is no need in
> free_vmemmap_page().
>=20
> And with memmap_pages_add() per page do a bunch of atomic_long_add()s
> instead of one.
>=20
> BTW, it would have been nice to avoid per-page counters update in
> free_vmemmap_page_list() too, but that's not related to this series.
>=20
>> Somthing like:
>>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index c04f53f708d2..cab9ec14873d 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -207,14 +207,13 @@ static int alloc_vmemmap_page_list(struct =
list_head *head, unsigned int nr_pages
>>=20
>>                page =3D alloc_pages_node(nid, GFP_KERNEL | =
__GFP_RETRY_MAYFAIL, 0);
>>                if (!page) {
>> -                       memmap_pages_add(i);
>>                        free_vmemmap_page_list(&local);
>>                        return -ENOMEM;
>>                }
>> +               memmap_pages_add(1);
>>                list_add(&page->lru, &local);
>>        }
>>        list_splice(&local, head);
>> -       memmap_pages_add(nr_pages);
>>=20
>>        return 0;
>> }
>>=20
>> Thanks for your review, Mike.
>>=20
>> Muchun
>>=20
>>>=20
>>> --=20
>>> Sincerely yours,
>>> Mike.
>>=20
>>=20
>=20
> --=20
> Sincerely yours,
> Mike.



