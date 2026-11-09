Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66340606A320
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=I0ZzmwaZ
Received: by kanga.kvack.org (Postfix)
	id 81B376B05B5; Sun,  8 Nov 2026 22:06:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0F06B05B7; Sun,  8 Nov 2026 22:06:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72EE76B05B8; Sun,  8 Nov 2026 22:06:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44E6A6B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:06:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B13DD1604E0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:06:03 +0000 (UTC)
X-FDA: 85414091406.12.78428C7
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf03.hostedemail.com (Postfix) with ESMTP id 14A8B20002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:06:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=I0ZzmwaZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794193562;
	b=2YvER3upswIf4laPZyP9HONqaHy5TRqHCyDm17zr/cWRA0zLqbNa+fZLPZ1AB+uaHz75kY
	yKb8AQYkpFnCGBtN8x2jCpkZ2Ujg9t2bLkT7xpvcfISeHlJjYrt5sHCrKY3qLkyVgvYHLJ
	FzLB0vo0YpqAfIMtf7UBM1EeGHL/XEo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794193562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQS78PCj6FfdbwzR1JAthRgqg3Mq39AopQfbYGKHtWw=;
	b=cdbsh/K2tfw8Lb9s7yWrHImXr3EqmCX5weY5whAzc6j7lIy0mg1FDSCIuLPuwvG1kkLBuK
	x7VvS8z8tqzkI2hjgkrBeZxh6j8dvb2zUSMMFSxU/4onH8B48OaP9PpNSbiMGTwu80wwb8
	vnTqETuDCBICxAE4M6tSOQ7MK5oTx84=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=I0ZzmwaZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794193555; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=qQS78PCj6FfdbwzR1JAthRgqg3Mq39AopQfbYGKHtWw=;
 b=I0ZzmwaZdQJGUoREKpE01kWH0DO5tLxj29dcLpp32kmORQyTXAo9P82ty2OqtLTEjQe7Z9
 s2hONUeDfi/oI13aA8z18eEPurp70CnbVhlYnQ3lGETYaApjcxVFR6FvJufBzMOydTIN3V
 A6ixzMrm9S9FgfGWZcFadGACnk5dVNvRyaH6EgcTCFMHyvRVfGZ57846vIWm9WaoVih7aw
 sZIL6VOB/BVwFrV30YdG1rfuzY7OlziJlSrPBaPYWYx7PPwmxbjdCHtkIAsKdJbvqmdz0e
 Kl06AXneBuO1g9DAkndd/4J33wsSg8mFy3RnV4bETlWKLUwAzAFaMfGmDdh81A==
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 9 Nov 2026 11:05:36 +0800
X-Lms-Return-Path: <lba+26af13891+698f81+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20261105120615.16817-1-lizhe.67@bytedance.com> <20261105120615.16817-2-lizhe.67@bytedance.com> <au2tQaaMBg3umthq@parvat> <25a188bf-05e4-4f0e-b670-a9dc88195b21@bytedance.com> <f062d92e-a016-447f-926f-bd1b1ce7f106@linux.dev>
To: "Muchun Song" <muchun.song@linux.dev>, 
	"Balbir Singh" <balbirs@nvidia.com>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] mm/mm_init: factor out memmap_init_page_from_template()
In-Reply-To: <f062d92e-a016-447f-926f-bd1b1ce7f106@linux.dev>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Message-Id: <2f9730df-fade-4c5f-a4fe-fd3d43eb8bba@bytedance.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Cc: <osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>, 
	<rppt@kernel.org>, <apopple@nvidia.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
X-Rspamd-Queue-Id: 14A8B20002
X-Rspamd-Server: rspam12
X-Stat-Signature: yy9uemt9h3psckmmxexod9qdwfsegb16
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794193560-916467
X-HE-Meta: U2FsdGVkX1+XlQeIVrb4vZGaPR2ZxH8+SL6Phc/2f0yl7xN0XNIryzg5tdyZ/thLcGlrnBZPU/iiPUy8R3EBPqwqNvpIaRMoeFcQhW52U9cl52kum6tYW/g8LJHzSIN9345KjO4U9/BOOS1jRgq6q9YjLRgvtyGYsLnTiB++IMW1cGw0YHVhiUNrqXZilOPuiOCDqo56VqBjNr4mhTWO2vro+xAanAZtCh2AeOlkOHrmdNloWFbpOrfC+hNoI2zxWWBR/DhRktiy/5jTrYIUQxOU8kTX1w7NFFp52FY5+RhIWlB3ISjTw8Ak3S2N7vdkFGiitUEAPUrGnk2jq+Mxn88ZymyYM8OZIuqDFNd8mJ4vSDngsjQwURK/UYKKaDLNRBIqnHEcl74hB/o6W/YJbDI1YKPsSWSYcFL2iXNeV0Gu7mgiGn2mojgedBHIBQuTxdq5T2BW1+j6bjllMLjrVxSRDgEZ6UVhouHbr0yW+7GhkpM/NYZtYk8U5bnbmiYGoqBkskV8Vsm0xhbGgQSNwksdm5Qx9/HUAXOwQ65ApPForbGLB0R5V/CjxcaaKj553D5PUBcYX/m0Vo+kiiSsimopBUPL6UVP2d+KhQntqeMOJ8j0Nss1MuS7nOE2GMubTqO4NrdysWjW8hDOuVKrypCLQBMG4On1678QRIZ7DW7y89Ej32UxMs73qMMG7WEfLZNopvAaw1nR+fdTi2mkuf718ilxHanFvvlvkP6/TDaRtnatT+Sv0262JkBihsJ5Td0tce4KWdhC+AmKGJucUJFDJ0VrD8MFFvaF+E4OMqjcE7nWxAJ0Y8vmrU9wApn7CIRMxcbTNlitwdJ1oc0kPTGituuT0Bas35yqNck7jP/SO6LY9Hg7KEtzmaODJDRZGhIjzFHfBnx3KJP/VhhYd6FgHxW8bfE4iTNZMU0x5LVU23QtAR9+KwChgnXAv2gwItKV+CjhBb49y1QgSVZ
 ObU3fHew
 ZwoAXQ/7pzMNJiBrYetxF1MyAvvwwOUOxiy1ay/axxDK8WoQkxYznaRFMjpvkUq3XFKUIY26ZsC+MjNv56SQVOtHG2d7xdzgoboxQJNcCCqeuLKKX2XaqwK6OirlH/F7C04peK5S3Lec6YpBB23M3lprJebxpcAol0Js2aKyRYMwTDCL/2HXV44kT3AZkuzz776AGylNJh0hM9X3Iepsoi0gRIJ1gNNCkDSFQAyygpuyfn+2M+f+QsPSKHGlWIC8NU/JD0YTj0B6B2fOFOGlxQlcDYp3vNdCyjFXNj0eRrMEeigZnf/kbNQBic1mkhgmQtI8g7xLVqp5d8D62ekYEL9R00hDE42z9BPyHZ48tqMArS6NvoX9hqLkiaipvtIcNwggqReRcIIUe2MIMyDAbjF3ieHmIYVUJqVOJXh2K97EhvszHu+zr2K+bsCHc97dkhn5r/ryCvhuouJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 10:57 AM, Muchun Song wrote:
>
>
> On 2026/11/9 10:51, Li Zhe wrote:
>> On 11/6/26 6:34 PM, Balbir Singh wrote:
>>> On Thu, Nov 05, 2026 at 08:06:14PM +0800, Li Zhe wrote:
>>>> ZONE_DEVICE memmap initialization already uses a reusable struct page
>>>> template when initializing compound tail pages.=C2=A0 The template mos=
tly
>>>> contains invariant state, but a few fields still depend on the target
>>>> PFN and must be refreshed before copying the template into each
>>>> destination struct page.
>>>>
>>>> Factor that operation into memmap_init_page_from_template() so other
>>>> boot-time memmap initialization paths can reuse the same helper.
>>>>
>>>> No functional change intended.
>>>>
>>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>>> ---
>>>> =C2=A0=C2=A0 mm/mm_init.c | 29 +++++++++++++++--------------
>>>> =C2=A0=C2=A0 mm/mm_init.h |=C2=A0 2 ++
>>>> =C2=A0=C2=A0 2 files changed, 17 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>> index 2a0e782a151d..495e20fbdec0 100644
>>>> --- a/mm/mm_init.c
>>>> +++ b/mm/mm_init.c
>>>> @@ -625,6 +625,17 @@ void __meminit __init_single_page(struct page=20
>>>> *page, unsigned long pfn,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vmemmap_optimization_verify_zone(=
page);
>>>> =C2=A0=C2=A0 }
>>>> =C2=A0=C2=A0 +void __meminit memmap_init_page_from_template(struct pag=
e *page,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, unsigne=
d long zone, struct page *template)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 set_page_section_from_pfn(template, pfn);
>>>> +#ifdef WANT_PAGE_VIRTUAL
>>>> +=C2=A0=C2=A0=C2=A0 if (!is_highmem_idx(zone))
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_address(template,=
 __va(pfn << PAGE_SHIFT));
>>>> +#endif
>>>> +=C2=A0=C2=A0=C2=A0 memcpy_nontemporal(page, template, sizeof(*page));
>>>> +}
>>>> +
>>> Can we make the template a const? Why can't we do
>>>
>>> void __meminit memmap_init_page_from_template(struct page *page,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, unsigned =
long zone,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct page *template)
>>> {
>>> =C2=A0=C2=A0=C2=A0=C2=A0memcpy_nontemporal(page, template, sizeof(*page=
));
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0set_page_section_from_pfn(page, pfn);
>>> #ifdef WANT_PAGE_VIRTUAL
>>> =C2=A0=C2=A0=C2=A0=C2=A0if (!is_highmem_idx(zone))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_address(page, __va(=
pfn << PAGE_SHIFT));
>>> #endif
>>>
>>> That way we don't update template once it is set, if template is r/o,
>>> then we don't need both first page and template in the caller to
>>> be different.
>
> I used to think that too.
>
>> I kept it this way to preserve the memcpy_nontemporal() write pattern:
>> update the PFN-dependent fields in the template first, then copy the
>> final state to the destination page once.
>>
>> If we copy first and then update the destination page, the hot loop
>> would do a non-temporal copy followed by normal stores to the same
>> struct page. That is the pattern this helper avoids.
>
> After thinking it through, that should be the reason. To prevent
> similar confusion for others, I suggest adding a comment here
> explaining why this specific order is used.

Agreed, thanks. I will add a short comment in v2.

Thanks,
Zhe

>
> Thanks.
>
>>
>> Thanks,
>> Zhe
>>>> =C2=A0=C2=A0 #ifdef CONFIG_NUMA
>>>> =C2=A0=C2=A0 /*
>>>> =C2=A0=C2=A0=C2=A0 * During memory init memblocks map pfns to nids. Th=
e search is=20
>>>> expensive and
>>>> @@ -1073,17 +1084,6 @@ static void __ref=20
>>>> __init_zone_device_page(struct page *page, unsigned long pfn,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> =C2=A0=C2=A0 }
>>>> =C2=A0=C2=A0 -static void zone_device_page_init_from_template(struct p=
age *page,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, struct =
page *template)
>>>> -{
>>>> -=C2=A0=C2=A0=C2=A0 set_page_section_from_pfn(template, pfn);
>>>> -#ifdef WANT_PAGE_VIRTUAL
>>>> -=C2=A0=C2=A0=C2=A0 if (!is_highmem_idx(ZONE_DEVICE))
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_page_address(template,=
 __va(pfn << PAGE_SHIFT));
>>>> -#endif
>>>> -=C2=A0=C2=A0=C2=A0 memcpy_nontemporal(page, template, sizeof(*page));
>>>> -}
>>>> -
>>>> =C2=A0=C2=A0 /*
>>>> =C2=A0=C2=A0=C2=A0 * With compound page geometry and when struct pages=
 are stored=20
>>>> in ram most
>>>> =C2=A0=C2=A0=C2=A0 * tail pages are reused. Consequently, the amount o=
f unique=20
>>>> struct pages to
>>>> @@ -1136,8 +1136,8 @@ static void __ref memmap_init_compound(struct=20
>>>> page *head,
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Initialize the re=
maining tail pages from template. */
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (pfn =3D head_pfn + 2; pfn < =
end_pfn; pfn++)
>>>> - zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 &template);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memmap_init_page_from_temp=
late(pfn_to_page(pfn), pfn,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ZONE_DEVICE, &template);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 prep_compound_head(head, order);
>>>> =C2=A0=C2=A0 }
>>>> =C2=A0=C2=A0 @@ -1192,7 +1192,8 @@ void __ref memmap_init_zone_device(=
struct=20
>>>> zone *zone,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (; pfn < end_pfn; pfn +=3D pf=
ns_per_compound) {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page =3D =
pfn_to_page(pfn);
>>>> =C2=A0=C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 zone_device_p=
age_init_from_template(page, pfn, &template);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memmap_init_page_from_temp=
late(page, pfn, ZONE_DEVICE,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 &template);
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 cond_resched();
>>>> diff --git a/mm/mm_init.h b/mm/mm_init.h
>>>> index 0034e37dbabd..22c465122b47 100644
>>>> --- a/mm/mm_init.h
>>>> +++ b/mm/mm_init.h
>>>> @@ -111,5 +111,7 @@ void memblock_free_all(void);
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0 void __meminit __init_single_page(struct pag=
e *page, unsigned=20
>>>> long pfn,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long zone, int nid);
>>>> +void __meminit memmap_init_page_from_template(struct page *page,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long pfn, unsigne=
d long zone, struct page=20
>>>> *template);
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0 #endif /* __MM_MM_INIT_H */
>>>> --=20
>>> Balbir
>

