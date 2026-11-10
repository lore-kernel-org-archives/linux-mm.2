Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D9C606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=gCUC3LYO
Received: by kanga.kvack.org (Postfix)
	id AC0246B05B0; Mon,  9 Nov 2026 21:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71386B05B2; Mon,  9 Nov 2026 21:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987016B05B3; Mon,  9 Nov 2026 21:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69F106B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:16:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C271D120884
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:16:09 +0000 (UTC)
X-FDA: 85417594458.11.D1D16C5
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf22.hostedemail.com (Postfix) with ESMTP id 50FADC0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:16:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=gCUC3LYO;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794276968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HIPwNYvbOarmnCqPR7DA23o7bO4fjUXE8B8nsiUVuw=;
	b=ACN7vAbTn4D0VhYZyE3Cj8b6Y8+hWNerSrg2gkUOsgKHhL4gCsV9maw5TjBEAQArSztdWt
	87yKUzGrJrdFMLhLjGsfjTfSByCt9IRx/znKgZjmTRqTCcSE3IrhsJQQVriKP4pNrWM5uh
	K4nySfeWjXi3vcP3hFTCtFZL3EsE4m8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=gCUC3LYO;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794276968;
	b=23cKE0XviPamF6wmKO9CglDAUaZyMd4C7towvu7d9IaIc4W1LQmP0RqIpdhskWDfkMEDQA
	KUaYapIzbIjz0CTx+csJWw/IDs71o7Z7v+mq+7Ka30oX4VPx0c7SfXG5H+LvB4UHvnhmpo
	1Qk5fv4Hn3WxuKmE+U5Qy0lpmnUKJAs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794276957; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9HIPwNYvbOarmnCqPR7DA23o7bO4fjUXE8B8nsiUVuw=;
 b=gCUC3LYOsR+wYxX/DzTp99RfgGOUN0Yg5EZV0Aag13kLWls0TEv2azhQ34y62yh4khWxEI
 s5e3+F580AOsIhYrktNRcEP5dgGTO4VExo7pezOxN2JT7pmqOFupUEEcqyUfYOdAXd/czW
 Zx+NfmJhL5fB5nuygggfn9/jmE30HyOlyubB9M24g8byqtBcC6h/xWo4ejkddacVa3r2WF
 c3xGV3+gji+yc/nxjlvqgvzM5GiF6627AnqD5GIgD2xRbuY952JvGCsun1JSSftfgSiNto
 vACtI4TlJkRwh73CO7Drfgz2WSQVtWiPklhZ5Xt6EkaeXSq5RkD3+jTu3ATUrw==
To: "Mike Rapoport" <rppt@kernel.org>
Date: Tue, 10 Nov 2026 10:15:39 +0800
In-Reply-To: <avGvlDENwtgUWv-4@kernel.org>
References: <20261105120615.16817-1-lizhe.67@bytedance.com> <20261105120615.16817-3-lizhe.67@bytedance.com> <au2qhlsxQt3SRwIu@parvat> <ca38db3a-a8fe-47c3-8813-5c3b0ac4b7ac@bytedance.com> <3e5a9f27-ea35-4557-95d1-70ce359e4c92@bytedance.com> <avGVNISvj-v8IN3g@kernel.org> <ea9b76c1-ced7-4ef7-a428-7fb3db5c7f4c@bytedance.com> <avGvlDENwtgUWv-4@kernel.org>
Cc: "Balbir Singh" <balbirs@nvidia.com>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>, 
	<apopple@nvidia.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26af27e5b+7e9f15+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <c82be2c1-b890-42dd-9966-72e6c7a95b25@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Stat-Signature: ctqzwqa3g1uukpmsz1s1otptwqe1a4kd
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 50FADC0006
X-HE-Tag: 1794276967-695189
X-HE-Meta: U2FsdGVkX18fI7S2FVzd9QoNCnY8Mp0CkTpqUXF7fjBWGG8fj/08/HKeHTUWtYsQDXv6kU6azMrqlgnXDemWGnzKY4N7mUqc6A+f+tjTHyzvC05vrsWuUNP/wXHyysL/EJj1kqV3wDbCVLT1wO3R3uK7t8tfHaOJpjtSXVebRy695Bnh1G8nv/bUJhGsCvlQSwklHkJkDisvrx8KWqNA6f3f/HNo0HK/n5+OlPWQ/h6DWKgqAn7us1o2H+idHwsJnfpyfk31cA5xejmtymHLVB+c661Qsqg004vKs8n6oaUJfj35dH12dyPyqsWsR1XhTL+KcjJeqgMg4mbXvFs43V/F0UU4TuB2IbgVYh6pmy0xEE6nWWGwFXj/hrnUR1Gd+qcAxS/4YlYTE10Fc0Xm4XBp4nS8K8vwBG1T6NwnEqmZ5JRrbOaGWHz0IQ87f68KItfSXqSO3y7X5sehKerFQSm/Gu26z6pbv5NHRPrrepCBKKi4Zaa5k6M6TBkwwaH637LadbC3y0YHSWOHTfWDz/K8T1oKSllFfkHOhnosJSxkP1O2waEQ9X+tBF635+vgUFWUvO4yFEZAj4ZTjMWowQa1bMEweSZFwKIo5+OS3YfZbnyjg2d31kL2VWAz7Rnkomi779YY+izdQhzvQa0GfNCuiTkhL7IO8cvDMZvOxxSpYaPXdgYeTpFH8f1AS0nbSANokrAS1BQh2MeNxXRaN2brtPbQSpcReltYzyxD8Ez5PZDjvUALbLcUOJx8AGw2SH6cdeD2nXV3dXtQmnXxbNv8OrAQZbJWlzhbXcdxwl4/BwoPyNebEujN/NTKj/9DxZZ+8+NFi0aK90NoXu+SHB9+NhvLb38sgKz3AHp93SJLXgv/cN7Wc4YqXXaihkuuZfO4bKEudtvWm6KIQcm2zw6yJHUS59UdH/rEuafmjLMJ/zFsuXUyD4gJKfgkO6S4cOU9oRPcCNTmM33G327
 vQBfzKG9
 nDyB50PV0SuyLFal50ig4lAissrG7rcbp/EiYGfUVo5OKqvgztql5/0Uwu6KIMi8l8O9RCCTNS2qmrEj2QWcOJ1hAQy/bp4cV/y8ABq7nmDGSQlb/mCl7IWQe/ddh4N7JXBR9XzFtBxfIWE8vwwtb3wO4aMMue/BK7Gx45l325wu6Sw210ECm/hTu65L1hg8j11uJeCdvQ2t9rprCeAynkj1WvH4FcAM5jCGK5DVUBGtZ98qnpqX4L17INwlU7gRE7vRaRpJfps/PnqFkbAf3e4iBn6zfLEdsr1jT6fHKeZFqMSM/YxQl5eyYpsyF/HDLG9a6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 7:33 PM, Mike Rapoport wrote:
> On Mon, Nov 09, 2026 at 05:52:19PM +0800, Li Zhe wrote:
>> On 11/9/26 5:41 PM, Mike Rapoport wrote:
>>> Hi,
>>>
>>> On Mon, Nov 09, 2026 at 05:22:24PM +0800, Li Zhe wrote:
>>>> On 11/9/26 11:01 AM, Li Zhe wrote:
>>>>> On 11/6/26 6:23 PM, Balbir Singh wrote:
>>>>>> On Thu, Nov 05, 2026 at 08:06:15PM +0800, Li Zhe wrote:
>>>>>>> Boot-time HugeTLB allocation has to initialize tail struct pages it=
self
>>>>>>> when HugeTLB vmemmap optimization (HVO) is unavailable or fails.=C2=
=A0 For
>>>>>>> gigantic pages, this can cover a large number of tail pages. Most s=
tate
>>>>>>> installed by __init_single_page() and prep_compound_tail() is ident=
ical
>>>>>>> for every tail page in the same huge page; only PFN-dependent field=
s
>>>>>>> need refreshing.
>>>>>>>
>>>>>>> Initialize the first tail page normally, copy it into a local templ=
ate,
>>>>>>> then initialize the remaining tails from that template with
>>>>>>> memmap_init_page_from_template().=C2=A0 This avoids repeatedly doin=
g the
>>>>>>> full
>>>>>>> __init_single_page() and prep_compound_tail() sequence for state
>>>>>>> that is
>>>>>>> identical across tail pages in the same huge page.
>>>>>>>
>>>>>>> On an arm64 QEMU/KVM guest using 4K pages and 64 boot-time 1G hugep=
ages
>>>>>>> (HVO unavailable on arm64 in v7.4-rc1), the measured fallback tail
>>>>>>> initialization time improved by 36.43%, measured with a temporary
>>>>>>> jiffies-based printk modeled after the existing timing in
>>>>>>> memmap_init_zone_device():
>>>>>>>
>>>>>>>   =C2=A0=C2=A0 base:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 318.4 ms
>>>>>>>   =C2=A0=C2=A0 with this patch:=C2=A0 202.4 ms
>>>>>>>
>>>>>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>>>>>> ---
>>>>>>>   =C2=A0 mm/hugetlb.c | 23 ++++++++++++++++++-----
>>>>>>>   =C2=A0 1 file changed, 18 insertions(+), 5 deletions(-)
>>>>>>>
>>>>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>>>>> index da5d04edf7c1..987f16a5ea27 100644
>>>>>>> --- a/mm/hugetlb.c
>>>>>>> +++ b/mm/hugetlb.c
>>>>>>> @@ -3219,19 +3219,32 @@ static void __init
>>>>>>> hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 enum zone_type zone =3D folio_zone=
num(folio);
>>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int nid =3D folio_nid(folio);
>>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct page *page =3D folio_page(f=
olio, start_page_number);
>>>>>>> +=C2=A0=C2=A0=C2=A0 struct page template;
>>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long head_pfn =3D folio_p=
fn(folio);
>>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, end_pfn =3D hea=
d_pfn + end_page_number;
>>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int order =3D huge_page_o=
rder(h);
>>>>>>>   =C2=A0 +=C2=A0=C2=A0=C2=A0 if (start_page_number >=3D end_page_nu=
mber)
>>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>>>>> +
>>>>>> Can this actually happen?
>>>>> No, current callers always pass a non-empty range. I kept this to
>>>>> preserve the old for-loop no-op semantics for an empty range, but it =
is
>>>>> not needed here. I will remove it in v2.
>>>> I need to correct this. A local Sashiko run pointed out that the bootm=
em
>>>> fallback caller can pass an empty range on SuperH.
>>>>
>>>> SuperH supports a 64M HugeTLB page size, and with 64K base pages
>>>> pages_per_huge_page(h) is 1024. HUGETLB_VMEMMAP_RESERVE_PAGES is
>>>> PAGE_SIZE / sizeof(struct page), which can also be 1024 or larger on a
>>>> 32-bit SuperH configuration.
>>> If the only difference is unnecessary initialization of the template on=
 SuperH,
>>> we don't care and you can drop that if.
>> It is not only initializing the local template. The code first
>> initializes one page with __init_single_page(), prep_compound_tail(),
>> and set_page_count(), and then copies that page into the template.
>>
>> So if start_page_number =3D=3D end_page_number =3D=3D pages_per_huge_pag=
e(h),
>> the old loop is a no-op, but without the check the new code would update
>> folio_page(folio, start_page_number), which is outside the HugeTLB
>> folio.
> A recent patch to arch/sh indicated that hugetlb is never used on sh:
>
> https://lore.kernel.org/linux-mm/auJI2blzfpFD9yLe@kernel.org/
>
> And it seems none of upstream sh defconfigs can hit it.


Thanks for the information. I will drop the empty-range check in v2.

Thanks,
Zhe

>  =20
>> Thanks,
>> Zhe
>>
>>>   =20
>>>> In that case the old for loop is a no-op. So I will keep the empty-ran=
ge
>>>> check in v2, before creating the seed template.
>>>>
>>>> Thanks,
>>>> Zhe

