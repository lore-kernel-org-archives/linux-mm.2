Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE4ADC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD706B00C4; Tue, 25 Aug 2026 09:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D426B00C6; Tue, 25 Aug 2026 09:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C406B00C7; Tue, 25 Aug 2026 09:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 955CC6B00C4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:39:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C925A40418
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:39:20 +0000 (UTC)
X-FDA: 85139898480.18.699B794
Received: from mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	by imf27.hostedemail.com (Postfix) with ESMTP id B088540010
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:39:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eYEU2Vl3;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787665159;
	b=Qlhvu8p4S9593n9EoIPY4hgHdSOYmGTuBGNQVgniA/u1OIUuCM5ym/4TnK49+V7hjO4PZc
	T9JKDMyZO3OOSS34Xg2vl3G9S+yeHDv2n0U4hDiJINbtAQOYwtPryPzDmEbSR6oC2wzaGO
	ltwVxQimeJwRKjsjg+bHbznT5FB+dMA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eYEU2Vl3;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787665159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7oXPgIIhkzB+dLa96WMQyErh9iHbDsIlQ9Tg7PfAk58=;
	b=kVbSrMAceA5kmqLRuRTGsSLz0bepCA+EKSfwpFvDtqP3TQld55j8XQoziYu746fuR31z8E
	65nxmRchF2MG7CAeOBW4qQ0BJLPKyvypOH3bF1rcNXHIIqeSSOr05yZoebWaKlDgOb3weg
	aCZvPWvOGfxhodWxbHQiYTNQgi4QQMk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hP+K8Ebe2kc9ztciYZ4PaIPMJflSO6fNgvlSGw26+I0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787665157; v=1; x=1788269957;
 b=eYEU2Vl33X93zUlQ1rBRk0oVLlE3UuL0lfoP2YE3+iD+zF03jaClyqPbGMvx8Fer5wRLzmr7
 tqqhClXz3QKEGr62BfyEWewt1+exyGRpSmPVX6qw37bEPny9M5WkLDkJZne25NxC/fHKAZ0g2qq
 azhQNBl0ckbe4ByfyXz8tRRk=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.254.116.35] (101.126.56.83)
	by smtp.migadu.com with ESMTPS id 4d13fbc4cbc00d6c;
	Tue, 25 Aug 2026 13:39:06 +0000
X-Mizu-Trace-ID: 4d13fbc4cbc00d6c
X-Migadu-Flow: FLOW_OUT
Message-ID: <c5f50310-0fc8-4d87-8567-a6f352d4cd6d@linux.dev>
Date: Tue, 25 Aug 2026 21:38:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/17] mm/hugetlb: localize struct huge_bootmem_page
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-17-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-17-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B088540010
X-Stat-Signature: m3iu5gwoupydudm5kuhqcbkb1himb4tq
X-HE-Tag: 1787665158-624261
X-HE-Meta: U2FsdGVkX1/XzJjomsKkmJhgmMj0/73EW0RDNqT5SuuRmoWwQEKCinoUADcvGTDAXHvrGiqJHqYx4sLGu+VLXtUqRrSJ/Dq++g0LySW9RLvPz0t/Z9TYqhPcRX2DS1SC15JJb9Rf+1M5UFHm9Hiwl4J0MoEUOaHmfyctDQX8uW+P0ydyWpBNeV/c7QjoWev52AmecE7KsB+HZ7KRsk5kQh4pD8jcZekhbVitWENa80RqIqhoZ177zoi3+6k0wZO8IBXfx6ciwzIrC5Y+eQktqywY0LDag2fp/1a8NdOFrBWByj3/nWTfidxM0f+qxWCFI94G4EuD+sMW7ODqcOaqpfGHP9ux9Y2l79b1cXgsdxEB8ndwRTjdtT2uIc4ZnsCc81q+/HpuNsl1A82biHOXstR/sR05LfhwfVaeTPzeNbA/+CzgonIUIPsTxDXjV2nKF2ApjSg5KRGIF0WmVtHYBdpAm9833QMip9f7J/pBRhNTR0fAKwn1+nEonzFZO2raBixyrvv09AfKD54Q6HBSY01UTTtQD8+MEZO5XJUBU7X9rgIfxPJC/+3iEjmidVXqSvXmOAKNppgvtlqb05cOAqNSX9f7s2sQtta/2IXDq7vzqMZ6UK94FL45fi3a9Tv5SZ7h2R0Jgtxi5MTbLIn64fBuJjFalEnV/rp0uXXmaVJ+giDDIoc/ANtpvt17MyUHDbgN86NAgRMpE/LsFiYGiV3qLUFLcFtUGwN4Lac9a5gxR4zdCOP6JD2vy6SM20ktFulRavYVrvgjXg+D6IsMcZDE7LvGDCEh9iu7Z6dNx5QgOEFKGxjDkOs6eVAEhr5eelfjtfhc54ETUyUjRTvhvE2T6sqOWxWRbGnSLjzEWQ3ogrGw+zlBOeVSKkRgdd6oi2GNMZ/zs+ybRgGX5e5jtbS68AK3P/IHNuyZgLKDYs1MfuKJ80wfA8F6yskJnBoGXPm68afOJ9tp9LLPT5d
 CkU/ecnz
 9B2nISCbVV6Lko7PFmWCzb8nlLwV3CDa8FtoKuEVk9JZ0ajdMoqIioHly/J3X9jjniVfq9wqrl7T5JgK+mRNfiDYomgYtSzqScuRhk4rSsjWApDevRIdmq0Qe+E3IJ0r+MTnRSlyOxrlsuPWawYCSYDjjLV8aL9WWESd38glSW4MqSCF56Y8qBsuo3poih89SCbclUzk31xqRCn9zCcdkX3YmbebwfkDG/KbB8SOWJRYjM4Dpp47anDYnVWh2tSEv038/b/TFLDVGPf5xSNyVw9IF9GVw41YfjIElSkE1vjXP9mPF+BfOCoxpoiEkO18NfOKy/e3TNgOUL6ceMpRnMkjHy19ztpNENUe9m/pP8FY4ipyntuuUa8RxiNo8qQUgNLrhCJ8UYRCV9F6mYQaYJhyfNdRra9tS7ORpi+/qqIw4tW2bQlmxuzeFAJc5KpAEYEk5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:46 PM, Muchun Song wrote:
> struct huge_bootmem_page is only used by hugetlb boot-time allocation
> code, but its definition currently lives in mm/internal.h because
> hugetlb_vmemmap_optimize_bootmem_page() takes it as an argument. This
> exposes a hugetlb-specific internal type more broadly than needed.
> 
> Change hugetlb_vmemmap_optimize_bootmem_page() to take the information it
> actually needs. With that interface, mm/hugetlb_vmemmap.h no longer needs
> to include mm/internal.h, and struct huge_bootmem_page can move into
> mm/hugetlb.c.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v2:
> - Pass PFN and order to hugetlb_vmemmap_optimize_bootmem_page() instead
>    of struct hstate and bootmem metadata to simplify the code further
> - Collect Acked-by from Mike Rapoport
> ---
>   mm/hugetlb.c         | 8 +++++++-
>   mm/hugetlb_vmemmap.c | 8 +++-----
>   mm/hugetlb_vmemmap.h | 5 ++---
>   mm/internal.h        | 7 -------
>   4 files changed, 12 insertions(+), 16 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


