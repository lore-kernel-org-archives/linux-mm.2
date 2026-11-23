Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78551606A336
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 07:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q3ZHFOLH
Received: by kanga.kvack.org (Postfix)
	id 6A23C6B05B0; Mon, 23 Nov 2026 02:16:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A046B05B1; Mon, 23 Nov 2026 02:16:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5916A6B05B2; Mon, 23 Nov 2026 02:16:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4133D6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:16:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7E39A084B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:16:23 +0000 (UTC)
X-FDA: 85465525446.28.DE898E9
Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id B89FEC0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:16:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q3ZHFOLH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795418182;
	b=RATzCtqILWxpbNw8cXAG4/TfltEaWfP9q/GZxAxK8EqCRALRIS6pHzEmMrJsklKkXGcbNv
	CbYUXIq8kZ82PZUQa2g3sKzQwgCN9efkxAQOcz+cEu6FkO2LLvtmVEm4qUoKNpgLdFC5tE
	ip7P5z55bASZ1v2oYbRd3cXFro1/ddE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795418182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWuSEBbe4RE+BEi4g+bK4UJkZUyNGdpTjGoBgR8/Wcg=;
	b=WPrNVtAgVPj++K7IyTaJU+rmhV1ZUSh7ZLOBpu5NgMO09pVhsjMg6bzDOmSOSwZbZgj801
	2kVcNBYGymd+Aoz1dj+my0SxAJ9/jYQxQkyesPGfQLmmyFewzjC0jXRJCSmVtgLxV8fPky
	KmoVXNA9ecVz/edLm6YgKhk/C0ueUeA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q3ZHFOLH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RmJfjbW9hanTanRMvzBOFEucChAhacO/MlKfSklTaqw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795418180; v=1; x=1796022980;
 b=Q3ZHFOLHQgeWyu8jn9GzKSy5xUH4NNHprAauA0Qa3wLS2LmLxWxDZ7uPzL3xvCghUYTAVKe+
 KdqUBKV+6Eod5KaRbX6DTm1ElzOS1ZYhIAvfMrrQSrjd4eFwkYz/vassKdcZNHoJcrtpHBebwpo
 /oEdcYEP3WYRHEANHtT7wELE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0696a849d2745a18;
	Mon, 23 Nov 2026 07:16:20 +0000
X-Mizu-Trace-ID: 0696a849d2745a18
X-Migadu-Flow: FLOW_OUT
Message-ID: <f4f45970-d917-4fb4-8bae-63c836527888@linux.dev>
Date: Mon, 23 Nov 2026 15:16:11 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/11] mm/hugetlb: drop boot-time HVO handling for
 gigantic folios
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-6-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120100856.16929-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B89FEC0004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9iakx3coc9tciwfzpb1bbeuix4y45sj7
X-HE-Tag: 1795418181-99358
X-HE-Meta: U2FsdGVkX184aKic+xyYT5Qpmr4lcoGrBP5Drej5Wh4pNxANqeMY57o9yeFCAt158N/gi87u7ewkeHGgWsRcP3Yss/M4FxWPmLecTKuhCYvaor9MEYid4t3bT32PrHVH/M4UkxEV/gytaQ3PRAmDDbRWm98BezuD9q5Vtohv5wRJr89VlmcgEPoDxL7Rn2Fi4T0VXxCTHckUC56n/Jqk4qWHPA1StbTWJcLnqvcGNtdILqehIUNefKTedMnx8eLpv0aLLCT+2vBuKhHHJLzREJTF1Fuzp8nnaKcSWV4coxRhCMKSADqKewOJP/HCR4hbKyCBWWLWzEFUTYdmqndFwvKDpHAWVmisHbT2j4sQyzwASVj6Yub3RrYlun/rtLJNKvoL0kkUaopQ55fXmsej/pZWIpe+0TG10ZlYvOAWbG6gxKXCbKaS0RAoubaiZsHgFss7Kjym8oukr6Zu5ELXrDZT8bpVLdTex45kKfSzHI0WgSwpg14pYlmW6AL3FW6cn+LZJow86BeReS+9Flip2tXsXZ8djs2ysg0MlPpXlu0206UYLupRojmp9HCVlMm+N0LerSKg283GIOELVq4Q9B3HjRdWtnFbijmWTfN1G0DHruaZQuNDUJjrxtWbY2phjh6RQMUQqzsWu7wrl/lOcYJpHNRj3yLGQclL7dYm9T2itkLgfdGODIuFCPv9xe5BhI8gTY36c5YCiWPR2SbyJSthIvydhMnL0uP03DXLSjIdYHg102cuf7mFulCaWfu6TnQtlXwUTYZucxbHtnaNTjwoxBUBZtgGf9/Y81kjNAqkGMjTpz3LxswhWEHwV/kF9Eh8d39V+II75C8SwFW9/rRlIbcsy7In2EZfh+2FYVoAY/9OPaMlBqONIYZb1cwVRVRmmK3ePXEnk3Ikr56qnpac5/Lp4tdr1PkB/Fq6smJV7xlrod9D6TKypauLxEj7LEtTiZgoXMbCpN9aqL3
 FYzSuj89
 WiPNNRrrzDOo8KJlFyZ9d+iHxfq8mabGifvFQ4GEjBQwVaJMoWxFmNeMwFWNJsBtuSGN6ghX951XFyWq6IUixdHZROssFB9ws5TinrDUrk6od9uVejBi2T101wnz3o8TcdiWQzmWH2QYDUBNg2CpPUtXJ+0xD8uoUgQl2qIVurBKz7PzLKjZYlkdH17D5NpGOLo3uDb5cP/oYjj6vIPR4OU87w3t5OxRdjesxizystTJ4khK88LJ71eZsi/toJKRiU8eySoefnDRzytSlPd51ho7K9wLKE+DT5mwRhHo21Lcfm0Bbm48gaj1T5XihKIj+jIJNYeJPc1zQBnX+innoE4xRrRcwbUWQWOnlLCkRHa18/YRHGLCJHhhzq4WX+oNIs+7bNm+V84CQDaccBnstLZfa/Jvd+ZtrkOgYiM2G9XV3k00vS3y/NTiblD/YAbrzZf2259o/EAcuYMFv3l4gXuicF3hJjmhzpMyLW40gzd/gT1ya82+JoEi63J8tNrkWhtXH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 6:08 PM, Muchun Song wrote:
> HugeTLB HVO is currently supported on x86-64, riscv64, and LoongArch.
> On x86-64 and riscv64, gigantic HugeTLB pages are larger than the
> section size, so the existing section-based vmemmap optimization
> infrastructure is already sufficient to cover the whole folio.  On
> LoongArch, HugeTLB HVO is supported without gigantic HugeTLB pages.
> 
> Therefore, boot-time HugeTLB HVO folios can rely on the section-based
> vmemmap optimization infrastructure directly, without the extra bulk
> optimization and fallback handling.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb.c         | 25 +++++++------------------
>   mm/hugetlb_vmemmap.c | 19 +------------------
>   2 files changed, 8 insertions(+), 36 deletions(-)
> 

LGTM, so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


