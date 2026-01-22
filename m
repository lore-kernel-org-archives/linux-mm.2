Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F04C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7945E6B0160; Thu, 22 Jan 2026 06:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 750DA6B0162; Thu, 22 Jan 2026 06:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE906B0163; Thu, 22 Jan 2026 06:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CD906B0160
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:43:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 049DD8ACE2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:43:34 +0000 (UTC)
X-FDA: 84359414790.27.524A968
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 291D5A0003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:43:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fLoqvw9Z;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769082213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzPuT7Y9eD4SMA4TJ/n5cBldWGtFSgOh9m5Kf01lyMo=;
	b=ZgOrdbppw78+TJA5JBkRno4kmzu5lA8e+Cuo3gdDEd2fFeKpJNyQ/m9Wrt0D0WthyC/BmO
	44gRxHLO3Tk7w3dqBU1TVH/9FZhQIJkR/d951z8qoFqms3Km69gTCIKWTWViVo5sWgrQTv
	Td4ST70W8B7Om0s23umIzOzfipllNe8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fLoqvw9Z;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769082213; a=rsa-sha256;
	cv=none;
	b=vkeYkm0CbojVIYQjReOKCvldxqsvz+t9KLE0ZZQN3SUKpHyDT4ifuIF5I3xgPDDs3eA5jT
	Qe5jbV6Sun3KoeOr5IN8ntOV/1fLH/sSUlSWXWKXF7jndfvmbLaNdpTHlqpGnOZEG9COc8
	Qb3IMlqcq29DmZdc1Q3to1CsriK33ko=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769082209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pzPuT7Y9eD4SMA4TJ/n5cBldWGtFSgOh9m5Kf01lyMo=;
	b=fLoqvw9ZME5l4IcJ8t5qH63hRwLwGLgIU9ZwopRTmvSipSXBciTztEZcY4UUj/+HIo16ko
	lk+A3QKMKCqa3AD2E6TXGTMLXKDLOx2zihvpvw4K15FZwFNM/vU3Jts5/GSTKoia7eUhHn
	QYmBoKT1bGABgm+zyTu7XB4Id0N25vw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <35B81EA5-D719-4FC4-93C5-674DD5BFDA4F@linux.dev>
Date: Thu, 22 Jan 2026 19:42:47 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <45434FC3-455E-4CE8-9F43-F398D5EC73A9@linux.dev>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-8-kas@kernel.org>
 <71F051F2-5F3B-40A5-9347-BA2D93F2FF3F@linux.dev>
 <aXIJY5irR0obgdQe@thinkstation>
 <35B81EA5-D719-4FC4-93C5-674DD5BFDA4F@linux.dev>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: mr4j3x6g8ryahh71k8hifp96x9borbxc
X-Rspam-User: 
X-Rspamd-Queue-Id: 291D5A0003
X-HE-Tag: 1769082212-863292
X-HE-Meta: U2FsdGVkX1/kuRb2EDChwGr/BPcDlsMrv5EbUQqYxEhVnbpRfZXf7jjMnPi2e7sQxkHuzVe6vStAh7bnP7h4FftIAu11vjPro6JZMtVDss06OrymIrawJ6U+d1AZOL7QUv9GeVxjE7TwXycqVeQMq/r2cKUHV/jDg9zSllnHXZzjY12nZlfA9+aA+5Nwskemee69YfiQUzgUcy8d0O8Bw8XuqTZarzCROsc3RNFIWTZP337cM9X4CqmmvewVhjsUtcnbFWQMyMD20nX2bHh9c5o3X/1tdNVJD/v6PuhlQxFhkrRCntspbWvfHM7KHmnBkka7iW+I3pF+9JZ8sw6Zhk2IwzVpg9aqRBKxhOeWoo4qr9WpUWRKWgOojDRclOATG2rbz8JfQGEyETggNuY2yZ0vkDg+pynltyQ1wUxMYP6REqT3Dw+xxdsIjem/wHbnWBDpqtfU08ZJR6DQJ7OTVyv6DJtG+BCwemXK7f8+0U4fNDkSc1SkbZ4WQnIBDbfCYDrOM7C47tvUaV4TVlf1fVqvtkVhpiu6A9HQMShDeBvQtU1FZFjFrCp1fGCT13MlSlnoGjr4DxqSUQN+tdoeb4v7NIgyBYZXrWpEdy2y7K7hAT3gBocnXvhD+P3eL4fd8MYU/nFLDZJuqiVZ7/O9HbvPcj3I13pqUeZsB9hLQjR4HPeb0+T95S2IdYIEwUOaOhfpj5OxFeT2Dzpyc1axZ4HUmK/yQI2WpnMPhSEHz9JaBoSg5UuIXuMTLcFj/EMIQRLJ1calVzYTUibciZ9BhRFGlgfeAfSNCyBrmhFlC0mmTFw+upA+6gnwgS0w93+OFL3W+JNl1+0MyFwqSEexatci78Hr4ubj6RohGb3R8xhzsocfgcNxSiDeOWLG0lykqNIhB6CdC7l7bmGecbRhJGOx0wDhYA64WtclCf1QvhIUe9BmUIKLJEt8mmFHMqFSkBmXpoTRfb3cxCQdOpv
 8mvCnIU4
 /WerCI7RV7+ZlVMNLVN1ezispoD0uaP265/bDJUyO0SGclknQ1w7rdbiCGwWrnKharLohFyY664LSrllVoHC4QbNQ5UvUwj9+RBCJhGUhMsl0IldxifReNZzxzTys8Dmn9DnMpzOgj8lbuGdCSdIAKkV7ZcnMTDg3gE7uJax6XG7X42i+qzIO+I8ulwYpfvvmItdgiAchH1slrVog/PQC4SMPvpHWNTHNumKQO9Uv17a7By7ffmJcGpA8YIz5Z1CBckSaP+CaldSXXZ8Pbs+8zT0e8uE8Q5zJ/WcHx5ub+p09rudLDQaXEEbYJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 22, 2026, at 19:33, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On Jan 22, 2026, at 19:28, Kiryl Shutsemau <kas@kernel.org> wrote:
>>=20
>> On Thu, Jan 22, 2026 at 11:10:26AM +0800, Muchun Song wrote:
>>>=20
>>>=20
>>>> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
>>>>=20
>>>> If page->compound_info encodes a mask, it is expected that memmap =
to be
>>>> naturally aligned to the maximum folio size.
>>>>=20
>>>> Add a warning if it is not.
>>>>=20
>>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so =
the
>>>> kernel is still likely to be functional if this strict check fails.
>>>>=20
>>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>>> ---
>>>> include/linux/mmzone.h | 1 +
>>>> mm/sparse.c            | 5 +++++
>>>> 2 files changed, 6 insertions(+)
>>>>=20
>>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>>> index 390ce11b3765..7e4f69b9d760 100644
>>>> --- a/include/linux/mmzone.h
>>>> +++ b/include/linux/mmzone.h
>>>> @@ -91,6 +91,7 @@
>>>> #endif
>>>>=20
>>>> #define MAX_FOLIO_NR_PAGES (1UL << MAX_FOLIO_ORDER)
>>>> +#define MAX_FOLIO_SIZE (PAGE_SIZE << MAX_FOLIO_ORDER)
>>>>=20
>>>> enum migratetype {
>>>> MIGRATE_UNMOVABLE,
>>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>>> index 17c50a6415c2..5f41a3edcc24 100644
>>>> --- a/mm/sparse.c
>>>> +++ b/mm/sparse.c
>>>> @@ -600,6 +600,11 @@ void __init sparse_init(void)
>>>> BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>>>> memblocks_present();
>>>>=20
>>>> +  if (compound_info_has_mask()) {
>>>> +  WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
>>>> +     MAX_FOLIO_SIZE / sizeof(struct page)));
>>>=20
>>> I still have concerns about this. If certain architectures or =
configurations,
>>> especially when KASLR is enabled, do not meet the requirements =
during the
>>> boot stage, only specific folios larger than a certain size might =
end up with
>>> incorrect struct page entries as the system runs. How can we detect =
issues
>>> arising from either updating the struct page or making incorrect =
logical
>>> judgments based on information retrieved from the struct page?
>>>=20
>>> After all, when we see this warning, we don't know when or if a =
problem will
>>> occur in the future. It's like a time bomb in the system, isn't it? =
Therefore,
>>> I would like to add a warning check to the memory allocation place, =
for
>>> example:=20
>>>=20
>>> WARN_ON(!IS_ALIGNED((unsigned long)&folio->page, folio_size / =
sizeof(struct page)));
>>=20
>> I don't think it is needed. Any compound page usage would trigger the
>> problem. It should happen pretty early.
>=20
> Why would you think it would be discovered early? If the alignment of =
struct page
> can only meet the needs of 4M pages (i.e., the largest pages that =
buddy can
> allocate), how can you be sure that there will be a similar path using =
CMA
> early on if the system allocates through CMA in the future (after all, =
CMA
> is used much less than buddy)?

Suppose we are more aggressive. If the alignment requirement of struct =
page
cannot meet the needs of 2GB pages (which is an uncommon memory =
allocation
requirement), then users might not care about such a warning message =
after
the system boots. And if there is no allocation of pages greater than or
equal to 2GB for a period of time in the future, the system will have no
problems. But once some path allocates pages greater than or equal to =
2GB,
the system will go into chaos. And by that time, the system log may no
longer have this warning message. Is that not the case?

>=20
>>=20
>> --=20
>> Kiryl Shutsemau / Kirill A. Shutemov



