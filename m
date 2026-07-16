Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4BDC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC7B6B014A; Thu, 16 Jul 2026 11:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3C26B0148; Thu, 16 Jul 2026 11:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EC56B014A; Thu, 16 Jul 2026 11:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 995FF6B0145
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:47:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BCA912010B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:58:34 +0000 (UTC)
X-FDA: 84994341348.16.AAA485F
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf12.hostedemail.com (Postfix) with ESMTP id A09ED40004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:58:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b03CyX1d;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784199512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9J2mfzReK0vZRJuzRH9sZHoLpDeO+iBwK/xyDsq7Kc=;
	b=uu5W+dmCQJN1/paN4LyEIjGoXxoPDuRYugnHglzlL5VHKCyMjAN/QW+ezFZ4ImbN6/OI+H
	H+40Hc00f/XN/3lMilm+Gau27hruU/IiTHGVHvaMfPbBzWP2XhqrWeCWgAbEeiiqbL/E6V
	7rBpd5AzpQgRpd5B0jTGX6KdKsDDzb8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b03CyX1d;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784199512;
	b=kCtEnHC6D+bA3QdyYt2hBeW2K1PLhudPToeECecu6JhQIaA/+HGeH0Wa48zJu/pBGqcj9f
	wqKTAxxiW5xEtl8RjA95cvsRZKBB2wE2BWAe5ehsGKkJe7Vd0XPJA69FWm3xyBfDGAFb6i
	I0R28QnSghL50eMS5WBqaPO57pNr5J4=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784199507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9J2mfzReK0vZRJuzRH9sZHoLpDeO+iBwK/xyDsq7Kc=;
	b=b03CyX1dRHhr7QK7K8Bi+z9V2blADechNztWBv2EwWnhnkb7K2qCMQZFZJo4CN+5PaAtZ1
	B2vktp/6aXOjpw4h+ftljMkWMCP7OaSNHlzh8Wj5FBD6NMM7196ofRGOkRdQgh9UzxNAPl
	hFoXhmbaJ5BgN8egRmGkldkt6rsjqOc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 02/17] mm/sparse-vmemmap: track compound page order in
 struct mem_section
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260716101559.2e640e99@pumpkin>
Date: Thu, 16 Jul 2026 18:57:57 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7BE734F3-4B0A-4990-9511-C2274C1CFA51@linux.dev>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-3-songmuchun@bytedance.com>
 <20260716101559.2e640e99@pumpkin>
To: David Laight <david.laight.linux@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9xca4krp56845xioybo4br9ajq7t66ui
X-Rspamd-Queue-Id: A09ED40004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784199511-69194
X-HE-Meta: U2FsdGVkX18XB2elkxQW6kNAc6vdTq1UdZqAPP1hESoLIoVS3FLguOZbT2Kn3wJtTmP25GrkdOcffOEnzf1aXNlx5hNY4Y3p13QAP1MrrkZM35Qx3GE+EYIDPVQLhyU04zxcGxfYHU0wHLYDUtDF6Rnmyszu23Vq9cf8ZH1coMOK3pjEsuWTWBJVKILonyvwWbt9WvYtSbKyMtKhNWxuBXD4uxRzWXzeTnsejH6ZqxIO82uWBVHWpT2nNvihdDCgvE3H6+Lh878bgw3R7egUy/XEyfVnRAGewApYoMGFrJ//EVVD8uTChvnUQYD1131N8YwFfi1/g5IsSLekraG2PUM8ELv+r1JS5/wMlqQePb6oNbJn36z+EOxKzdpchXs5/OUHux6O0QRUbSM7Z5snmnl7+/OHsWastCeNlwiuh5/3h3U6nTUxdz7082IXKa1aRrOVyCHDdkK0hE+hjgDQEM46j1d7wg7wHQasPc+sedy+y4H/Kvruyhj3T6g97G81sQOyT487K8BZYimZZGMt9BWE9zZgexk1tvzHgiZX5qRTYtqI4Glxl92yfyO+K0bkSMgtEInXV8v/q6Xj5Pgr8V9LkAJztg/bOMPFtT7TPvgfbcoo4FHowaafdpSKqQsJrxnGHMB1dDBr+PwQozLJmX6gtj5rmeOzlvV1Jw6tlOsOo0bYm3j6kE4d11alZ+IDq1ig28B0s8s3EMakC2sKUDOcz+Zu7WX0gajA6Z1eJxoB5TiSQznzVI0gTNOSViEkxRbNi7M9tN+dxfDFiLtjblQvyF4goKhYcZX6n80JeHrfbl91jnTjlOJC/DRDP3nvMMyeKstcphngx3VWhQkansIlM0DeTV3oG8XfMNaDAZ3P8rd2wH1SMgEOkW5Je4WQqxweSPNaOBIAuzm8FHYN7xTc6IDNLKvXngsbkhsBC4egxgXs9WL0jY/mdZI/DsIcpUrAH6omZzwkhPw1eVB
 7zxVO7P+
 HQSj0OOedejE4kPb4IH99QwTOGzAJu1Uh0kSkFEIwQgKe7vOtnhn8jbtOARExq6c7zAAcpaeHs+k4+ulTydGAj7n9PzmZSzovLjyWkhxRrRXhzAGHykeG9PS4MC55nBWZdAfHj176ry0kB4+v5pUQCq1/F1czqecH5keVZw3Qg8EuFJFhuMq4gsQRbhYVX6SzYrbDf8r/z4f6/rRZuz60u9yMD2D6dngphz7A4nnIRCzcyqAnP76kiYVxCm0uXTu2NEEd+Q9Ff0v0HRpIXYwcIcKypCRc3LAe/jFiBoDfV0owuLXo/PudKXR0arDF+GJ6tSGT0GZ6qogqS2xmNP1CXFG8IQYYpy27aqAEYP+XtWD2T8nVB4LdOwJpW19vhBGDlMRVilJJAZcOYpXorw1DqN0Xcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 16, 2026, at 17:15, David Laight <david.laight.linux@gmail.com> =
wrote:
>=20
> On Thu,  2 Jul 2026 17:38:06 +0800
> Muchun Song <songmuchun@bytedance.com> wrote:
>=20
>> HugeTLB and DAX both rely on vmemmap optimization, but sparsemem does
>> not record what compound page order a section is populated with.
>>=20
>> As a result, code that needs this information has to open-code
>> separate handling across users of vmemmap optimization.  It also
>> prevents other memory management code, such as struct page
>> initialization, from skipping initialization of shared vmemmap pages
>> when needed.
>>=20
>> Track the compound page order in struct mem_section and provide small
>> helpers to access it.  A compound page larger than a section =
naturally
>> carries the same order across all covered sections.
>>=20
>> This is a preparatory change for consolidating vmemmap optimization
>> handling and for letting later code make initialization decisions
>> based on the section's compound page order.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> include/linux/mmzone.h | 32 ++++++++++++++++++++++++++++++++
>> 1 file changed, 32 insertions(+)
>>=20
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 1353bcf7b712..bacd89572c5c 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -2015,6 +2015,14 @@ struct mem_section {
>>  */
>> struct page_ext *page_ext;
>> #endif
>> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
>> + 	/*
>> + 	 * The order of compound pages in this section. Typically, the =
section
>> + 	 * holds compound pages of this order; a larger compound page =
will span
>> + 	 * multiple sections.
>> + 	 */
>> + 	unsigned int order;
>> +#endif
>> };
>=20
> That increases the size of the structure by 8 bytes for a value that
> would fit in one (or 16 bytes to maintain power-of-2 size).
> I'm pretty sure this array is big - so that is significant.
>=20
> I've looked up some constants...
> On x86-64 each section is (1 << 27) bytes or 128M.
> A page contains 256 small 'struct mm_section' so covers 32GB of =
physical address.
> That is pretty much the memory limit for a 'normal' system.
> So even doubling the structure size only uses 2 pages for 32GB memory.
> Even packing the structure (or making it 48 bytes) would still use 2 =
pages.
> Of course there are the big servers with TB of memory...
>=20
> A more interesting problem is the size of the 'page pointer' array.
> That is sized for physical addresses right at the top of the 52bits
> supported by 5-level page tables.
> I make that 52-27-8+3 =3D 20 bits or 1MB, doubling to 2MB if struct =
mem_section
> is increased to 32 bytes.
> However, in practise, I suspect that the actual upper limit for =
physical
> addresses is much lower.

That was a truly excellent analysis. It is clear that the memory used by =
the
mem_section occupies a very small percentage of the overall system =
memory.

>=20
> It is also worth noting that CONFIG_PAGE_EXTENSION is a debug option.
> It probably doesn't matter about efficiency if it is enabled.
>=20
> You could change the code to use % instead of & - makes no difference =
if
> the size is a power of 2. That is generally safer.

No problem. My patch 1 has already handled that.

>=20
> Then do:
> #if defined(CONFIG_PAGE_EXTENSION) || defined =
(CONFIG_SPARSEMEM_VMEMMAP)
> 	struct page_ext *page_ext;
> 	unsigned int order;
> #endif
> With an extra comment about keeping power of 2 size for effifiency.

Thanks for the suggestion! I'll use this approach to ensure men_section
is aligned to a power of two again. I'll also add a comment here to =
explain
the reasoning behind this implementation.

I really appreciate your detailed analysis and insights.

Muchun,
Thanks.

>=20
> David



