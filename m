Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E769606A33A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=iCtfqv/o
Received: by kanga.kvack.org (Postfix)
	id 917186B05C4; Mon,  9 Nov 2026 04:52:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C86E6B05C5; Mon,  9 Nov 2026 04:52:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DECF6B05C6; Mon,  9 Nov 2026 04:52:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60EBF6B05C4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:52:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78D7BC0601
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:52:47 +0000 (UTC)
X-FDA: 85415116374.12.8C7D16F
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf14.hostedemail.com (Postfix) with ESMTP id D5950100002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:52:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="iCtfqv/o";
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794217965;
	b=XhNTKui8PABjRXvCe+6vNrRmWQCUJpElxrsRzvoaxh5b8pMjyxUxW2mMmCn/hunEkA5XT6
	NtiQWWXgJywwVG67OvMmEapsId1aWlIZFoRXLjccsSj83bjv72jsG46mYf5/uFrWEndATy
	KiNXglGo3Dc+6xtUyi9NJ4fOZxDcV4E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="iCtfqv/o";
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794217965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMQ7EtDkYDjDl+za8vShzpqCW7ypnaRbeTrLqAXEDl0=;
	b=1f90cf7vr4uZgyMj0odQQC69zO5DqWlqOPicmebGAWGR9PH06Rb0uQCdVGygFkeqoU9WPP
	mHsLe0kfe9txr2LKYLiTGazYhzRfURMiPNAfyaTmnABLDaa2oePl17+YqYUX/ChcWcDwaT
	hT3s5jTrb/2qQx5w1AQ+alQvJ4Jwf2k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794217959; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=rMQ7EtDkYDjDl+za8vShzpqCW7ypnaRbeTrLqAXEDl0=;
 b=iCtfqv/oPnFwF/AXfhIcnlCd+GyTk0CNAvfoxYr/JjSc/dXsoUkqPdAa57dpSGvsRmBVWd
 cCGHUDA7vm8Nr35HsTmyhIE4fgLxVYJQU72/3NxPWkE4OiHaAn72r5J6/b1N43RLQe+DmX
 4gQdDUmkqQ6YreZyzVVtYQMpe+vtqEu2dd+eH89MmJgeXvUfebp+kVsbpKgtNrJpwUCie9
 EN7MhdNuHY0wxHdZZnbVypLKyGI0lLzqTr+1U0OS8kQ0zWXSmGUU9WeTKhcCmAwyCcAldp
 JEQIM5SWJ1HY1Em/PSK8yEf01AjT9DTooSHGFLCi7TQOW7zIXrm1gO1SGJYjDg==
Message-Id: <ea9b76c1-ced7-4ef7-a428-7fb3db5c7f4c@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Cc: "Balbir Singh" <balbirs@nvidia.com>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>, 
	<apopple@nvidia.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
Date: Mon, 9 Nov 2026 17:52:19 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <avGVNISvj-v8IN3g@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
References: <20261105120615.16817-1-lizhe.67@bytedance.com> <20261105120615.16817-3-lizhe.67@bytedance.com> <au2qhlsxQt3SRwIu@parvat> <ca38db3a-a8fe-47c3-8813-5c3b0ac4b7ac@bytedance.com> <3e5a9f27-ea35-4557-95d1-70ce359e4c92@bytedance.com> <avGVNISvj-v8IN3g@kernel.org>
X-Lms-Return-Path: <lba+26af197e5+98ed77+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [PATCH 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D5950100002
X-Stat-Signature: g65o8j1p5gbyx6wt8x18g8x9mf77yd8p
X-Rspam-User: 
X-HE-Tag: 1794217964-632426
X-HE-Meta: U2FsdGVkX18qCEAWVYcN4nw7d0ygrFwlGmLZRmqZ2t/TcvBacTS+d0LrJtDMEDeENuUXf14Bvh6M6YcWEKSCHLqIRVH+q6Iy0C7kfPz26cr3CTTTex1LDbFQf2KvdjTuf3BZbuWmH4gHUa0xDF7ob/PAR10LeHPdVPDV4d/g5wt/sDRouYycP0YWYQkY25zVO+HzR+34YITkIGQDrsfBFtAl4l7uOevx5+ZuuSnynpRdJ9Pxu4B6a/EZRO1obG0rKWjkC+0f5q+YeliAJV+q1RY+J/ilytJrmIDgpmaP8jCmXgxpzTLoivvcatZdMnc6RwVi+BnCslMFUIkgAPUMwfU8ONiPx1LsSeYvas9KiBPhiU04IAlPq9lQpVGEk8a39ck70oHY0UL9IqcTi/7Tq8VJWO3X+ScLHI3O6TITWImO1LYNyCmM4Wz6aO21QqoX6wvp1TrYykklt2cQU5zhgz9bP9E1DFtfDwGbJIcs+Rm8fkmRky21dUhyL91CQMDSTNuKbcyxNNiwpz+JCnsr0VA1P4iOAFg+c8h5+FfVXLLjMoWMIq4JaPe0iTQ8BuvHAcazoaejtxgsZ9YNqKkKFAH/4OKoVDrV8mxwRtC3gz+4f58LkA96Dt7AHLwgWBdnhmZz3zY27iwFciXIl4VUQAg6AGr+VbOdeXG4Hak+0KoQiONZw8CvIHDEkDcbklBjwrQ6nMsweogXTuKE8PaJSyQ8PJUvG2rtc5bRfsEOiOa6XbdfI64RHwLCzI7SGG8y+Pn44VWYlbyzpyvmIzjUpz0nP6oI7XnlbDp/wEEssa8KS57n9kRDgnMluuKQ8vbcFktPf6bnOvQiZTqyC0dIuapDJApNN3FFYbvzNUmOOW4kA6Y62+dNDrQFAXGDNyy1oMwCjgJMLUFNH664nr3Xj4wTkCFsCVGMXmSSX97jHETFOhnii6h+E+hF4fFbKKaMiDSINBrajNLfn5gMS4d
 HpOxow0M
 6xokKo7X5zAy6zeH5cGnVx+r35b4vsmDVAA95rNz4xzOg5KP85nNVF89vYs9bKXOvsDhY2/L7GgLBo9j8/kza0XCSoxAXEIr/r4FfnyvpKQ5ie8TIsePmqogpQe7XDH/Ki7dRSTaOEFwoqAUvrMCtDO5K6UdZraz9R62DQtg/+YzG8ahZaSAd3iDgr+pvOz87h8vMJuOjOBeJ/2FUKx5XA95cR860R74KlxaY2Kn4Rp4eqkpi6+ZvDx6jxl89ktJuAlKpphbYXSQDxwD/cSnYcxuY67eQ0l/CDfhlpFxXV721Tks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 5:41 PM, Mike Rapoport wrote:
> Hi,
>
> On Mon, Nov 09, 2026 at 05:22:24PM +0800, Li Zhe wrote:
>> On 11/9/26 11:01 AM, Li Zhe wrote:
>>> On 11/6/26 6:23 PM, Balbir Singh wrote:
>>>> On Thu, Nov 05, 2026 at 08:06:15PM +0800, Li Zhe wrote:
>>>>> Boot-time HugeTLB allocation has to initialize tail struct pages itse=
lf
>>>>> when HugeTLB vmemmap optimization (HVO) is unavailable or fails.=C2=
=A0 For
>>>>> gigantic pages, this can cover a large number of tail pages. Most sta=
te
>>>>> installed by __init_single_page() and prep_compound_tail() is identic=
al
>>>>> for every tail page in the same huge page; only PFN-dependent fields
>>>>> need refreshing.
>>>>>
>>>>> Initialize the first tail page normally, copy it into a local templat=
e,
>>>>> then initialize the remaining tails from that template with
>>>>> memmap_init_page_from_template().=C2=A0 This avoids repeatedly doing =
the
>>>>> full
>>>>> __init_single_page() and prep_compound_tail() sequence for state
>>>>> that is
>>>>> identical across tail pages in the same huge page.
>>>>>
>>>>> On an arm64 QEMU/KVM guest using 4K pages and 64 boot-time 1G hugepag=
es
>>>>> (HVO unavailable on arm64 in v7.4-rc1), the measured fallback tail
>>>>> initialization time improved by 36.43%, measured with a temporary
>>>>> jiffies-based printk modeled after the existing timing in
>>>>> memmap_init_zone_device():
>>>>>
>>>>>  =C2=A0=C2=A0 base:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 318.4 ms
>>>>>  =C2=A0=C2=A0 with this patch:=C2=A0 202.4 ms
>>>>>
>>>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>>>> ---
>>>>>  =C2=A0 mm/hugetlb.c | 23 ++++++++++++++++++-----
>>>>>  =C2=A0 1 file changed, 18 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>> index da5d04edf7c1..987f16a5ea27 100644
>>>>> --- a/mm/hugetlb.c
>>>>> +++ b/mm/hugetlb.c
>>>>> @@ -3219,19 +3219,32 @@ static void __init
>>>>> hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum zone_type zone =3D folio_zonenum=
(folio);
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int nid =3D folio_nid(folio);
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page =3D folio_page(foli=
o, start_page_number);
>>>>> +=C2=A0=C2=A0=C2=A0 struct page template;
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long head_pfn =3D folio_pfn(=
folio);
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, end_pfn =3D head_p=
fn + end_page_number;
>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int order =3D huge_page_orde=
r(h);
>>>>>  =C2=A0 +=C2=A0=C2=A0=C2=A0 if (start_page_number >=3D end_page_numbe=
r)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>>> +
>>>> Can this actually happen?
>>>
>>> No, current callers always pass a non-empty range. I kept this to
>>> preserve the old for-loop no-op semantics for an empty range, but it is
>>> not needed here. I will remove it in v2.
>>
>> I need to correct this. A local Sashiko run pointed out that the bootmem
>> fallback caller can pass an empty range on SuperH.
>>
>> SuperH supports a 64M HugeTLB page size, and with 64K base pages
>> pages_per_huge_page(h) is 1024. HUGETLB_VMEMMAP_RESERVE_PAGES is
>> PAGE_SIZE / sizeof(struct page), which can also be 1024 or larger on a
>> 32-bit SuperH configuration.
> If the only difference is unnecessary initialization of the template on S=
uperH,
> we don't care and you can drop that if.


It is not only initializing the local template. The code first
initializes one page with __init_single_page(), prep_compound_tail(),
and set_page_count(), and then copies that page into the template.

So if start_page_number =3D=3D end_page_number =3D=3D pages_per_huge_page(h=
),
the old loop is a no-op, but without the check the new code would update
folio_page(folio, start_page_number), which is outside the HugeTLB
folio.

Thanks,
Zhe

>  =20
>> In that case the old for loop is a no-op. So I will keep the empty-range
>> check in v2, before creating the seed template.
>>
>> Thanks,
>> Zhe

