Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3507BC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF886B00C7; Tue, 14 Jul 2026 13:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0AB6B00C8; Tue, 14 Jul 2026 13:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA766B00CA; Tue, 14 Jul 2026 13:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B66836B00C7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:41:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A4961A0493
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:41:22 +0000 (UTC)
X-FDA: 84988098804.06.3506A65
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id CDF9B18000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:41:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N2D8XYyR;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784050880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XneA0CYM00BRNRTb4B9DVpDpuR42nW+B7bPBHZY/xY=;
	b=O5iVYfmOBlcG5biAn4jlU8v03eAI5pLngqy9+BkaSFK3N59qS3zG49HXx2x9Fl1DpYG0Lb
	6ezrt5S0bOYMayZYkI6sL2yKa25xnYMcWGoiA7hxL9RHe5jAz1nl4jNpWM9Liqk0D6YXBA
	Lhx/Zg9RWOuoj9r4X6C4VxKNYmPRdBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784050880;
	b=Uiqw0wt7ym1yq1uG3QW/SWnkc5mQIYaSi7Ah1nHGTzzIXJUYYXBXeu3BRvV8dYaAyNu3NZ
	ucf71nYlRn7GTnd40+DwHmvefG1GAUNh8h7x5Jv4R2CwoAsYu8DUyfMiB6e6YDlzBdXCSi
	p/k6nesEX/0urjIrqtmWNysbAuxmwsY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N2D8XYyR;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784050879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0XneA0CYM00BRNRTb4B9DVpDpuR42nW+B7bPBHZY/xY=;
	b=N2D8XYyRpmQvchLr2eY0KtkzkawvKNrWmmbd3nla3Acd+LGm1m/6DAlF27Wt5M6hllizC4
	kkBp0v6uWd4B5GhOgZRoyo9IPrdpsCz8PWQJRZ/eEvDaGRZ/MGXya8sOtenkVq+/KyFBah
	qEUcrKqCkESQ1RcKYGGIetug2bgmpfc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-JSXllTO_MquFwX_-7FRfzg-1; Tue, 14 Jul 2026 13:41:18 -0400
X-MC-Unique: JSXllTO_MquFwX_-7FRfzg-1
X-Mimecast-MFC-AGG-ID: JSXllTO_MquFwX_-7FRfzg_1784050878
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8efad04d884so22883876d6.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:41:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784050877; x=1784655677;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0XneA0CYM00BRNRTb4B9DVpDpuR42nW+B7bPBHZY/xY=;
        b=fRINsB6hC0aEG/vIkI9KZ43MzdRj7MRKMeUQUCIh0l6THV55vadXbQv4d6Y3i3BvbN
         iujg0+XNTYfj3Q+pDSkg2R8jdC+DQyk96B1BgX4LIldQIGVaG75gMzzVX31UgceFV8NM
         0YoDeidyM40weRAS/O+cI9RvS/J9fRzFRqw8a1x4ylyDAt2WTdCBFdZ+OSC3DatqBgAX
         RScpiB1YFJdnC14wZNhysDPuuaZFCjoNHK3wCAVnSIBzNQMELITEvho6PLKwS78GupWd
         5k2fGZwNzZBQ+DJfAALPwqcK3lzq85z5aJjopRt4vrygKYWDqwd6khdeLdZuaY1W2SkJ
         Furg==
X-Forwarded-Encrypted: i=1; AHgh+RraCx3ohCHQOrPycPUcsxYTigV4NDdtx/1hph4OkXIIKscgduGtgqaAdgduHCVbOUQNf3NQt6d3Lw==@kvack.org
X-Gm-Message-State: AOJu0YwMFiA32+Kls6Ns2hrINaCRjp1QHUZ9b02lcvMGcQpHsQk0Wozy
	7rQHebxVB0pU/oMpfXVMAM3oNt15hF6D/NGhb+mvHWvIZk+eg436hA6Y3M3ZnCT9clncA9J/tWk
	iS84wZ3gb12snjSBw18y/iIYt2Efrx3Z+bdHpozIoaIvyFFFxnU4B
X-Gm-Gg: AfdE7clVW8oWUypacV2p5DO1n2X9AASixidAALX3QAKlQDNycix54WTFeSUln1ncLnM
	hWCUv6tGOpQNFaGf71rGcEnRwGo8hCoXLD6AbBZcK581Alh5QxRsn2ea4EiniHK14DgQmnxM3qq
	zvquxKuGm12+tYy/n6G5Iu0/jqVBkP6SoAhcRrZObvCEhCTrHK7DbRFpavELLM09vp9AZ8GGX5s
	+47s3LQYWaVMHQRgEpBB9L8QPaib26hBrXlBpJ1+U6jT8IWnkOi4KqD/ptwFNJR4jcjymz7b6BS
	BgunAz34k97tfR95glKPonVuvpQ/3pYOlK0ufkgVotz/iujXV1Q1UxPCZ9nHub2vyF/q9kQZjex
	KAX6VG9+QlOsWOPbC7H2PHQ8/2uCe3qGhItm1gCwRoMn3XOnTChas/dZQjnip903fGWcMzdDF
X-Received: by 2002:a05:6214:130b:b0:8ea:efae:ab26 with SMTP id 6a1803df08f44-903fdd64832mr161430716d6.0.1784050877674;
        Tue, 14 Jul 2026 10:41:17 -0700 (PDT)
X-Received: by 2002:a05:6214:130b:b0:8ea:efae:ab26 with SMTP id 6a1803df08f44-903fdd64832mr161430346d6.0.1784050877267;
        Tue, 14 Jul 2026 10:41:17 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-61-70-49-81-60.dsl.bell.ca. [70.49.81.60])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1fd2bsm175197236d6.27.2026.07.14.10.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 10:41:16 -0700 (PDT)
Message-ID: <690257d2-2126-4a8e-86de-b0882e282431@redhat.com>
Date: Tue, 14 Jul 2026 13:41:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/util: don't read __page_2 for order-1 folios in
 snapshot_page()
To: Aboorva Devarajan <aboorvad@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260708201954.686111-1-aboorvad@linux.ibm.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260708201954.686111-1-aboorvad@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TLEH43Rxh-FLQsIV2mtKmXJWboB_qk7T_Hh0K2bDDcE_1784050878
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CDF9B18000A
X-Stat-Signature: 9abw7r3w1h4ahk8x1wdj4bptjzfp8tf5
X-HE-Tag: 1784050879-351160
X-HE-Meta: U2FsdGVkX1+LQrwAW7EA2JXBLF9LOvtguFrTWvaOrKxPMTWzqct4H8P4L4WadBr6120iUgRFoiGlmYdtXK3R2PAWKvs7I7cY30kFmto9/g/YnGpMGmzEN4VfEV1BUTUGKwaKtXNLuykC9229lZ55+FeTyNoUu+ClN4IWxsv1ATTCw0aonsC5kXNq6grqiPFHBl6rY5dsNT6r3xdC7o0z9Bd2Za1qMXquBagKC1/viXCPGNcK9hwWj63sDPuX/XLpOjaaO3x0JkroQKHg84GtwCTeJEkM44Uy4Ym3ibAnbFTcbySRUf+k8c51TdpYpK2m7edV1yaij37SD9uJfGc4VwMiM4cN7xJOhIyvcpGuiA589vn7CJq6VlGHF2Buh/6FrjTnawalps2OfdHLqNkgELHBsVG/ML33kKxa/YQ5cZg2twciNnupwy1lbvW6a9APWaDe6Duv2mDcK7L6iC8Dd2IkYE0Ts9AhWlFOF8CXtKCqXsXcvcK28bmR9BpHusInzYRIPPqndEVlPYCJ8mjhh2u7bE6ik/umlijoGpNTLoxr5X+Upoq27cCWRifpsNq32ZST027nW+EBKWFN8kaLJKrT6gXitV0XgIQGVXnEjhYGS0AnmE0BhLq4xyLEn/2Alvxq9iiL/xvmapTN4PDcQJMxvt5wrZUon8uiASgJ0hACQWe4pUC+LbgpJiAZyMq8tRx/V5EGHxswQ2VoRVqqzGJXBBtqjm2lPMOWXRPJDVws+t+qDIW7hnopBmSMfGIeyQw7uoLeX2vYVXUxiseV5j+ZR8u/TQ5u1nLAEuZf9B/WfoJxVHjp7kdUhELMXmcvcBOyyQrpmfpGeClxuaye4LVNilnII/yOtHsrpMCjkOomfBljuStnoqEMsRbxUSOZQWOWolCto9kGI7DgUj1jXHNAXTDQXzgues2jxlqsi8IeDHJfzhuO5ab67EleCtZkGlZUwo2FT24tmD6qGwM
 6UzW5r3N
 rG5XEClcboevRsbK8VtG18JAGH8lLT6r2Ck/Z6uFRmEv2l6WxU14PepGsSqpe1Gq8wfN0DzOOrBrxt4BVSBw7sP03yPhE9cW+zbkJphgBOL7i6htTphCvgkTEckuyI2SSmdqq1SH0QnYM1p7VjPULdxRlway/i5MH1YXIjNWvltHBTVryd/mvxOAjaOdlfZu5mwCfRmDWRI3h1AOKfbNpP/gVI4bObTGd8VuQqBwgU5vCMpBsiu7fqI6EcSnC+uuyk21nwKCFOcXe/u+jIynmpHxLQo9bzmxfmrxqpRuGqPiWD/8722WiXxwPuUnbdchsdzUqLUU0EMJwTdX66xvAxUd0ZBr+OFq4MX/yVbvj5vcAXQouIUAUobsx11n0BDVDLxAuuZ9rAf+iGyuzYbvhLWKyAN4xGibuEt2L6GyWb+s2wJLMbmQGmwbafhKqx1+y7KTxZfhHdz1Kgl1bHZnpbtJg21PDsDu6yRkEahNJmyw5xzz7hK/LNNIy60vScIzvMnV2gQjbQbJb/1jCs+kHLQH9+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-08 16:19, Aboorva Devarajan wrote:
> snapshot_page() currently reads __page_2 after checking nr_pages > 1,
> but it should only do so when nr_pages > 2.
> 
> During DLPAR memory remove on a 22 TB ppc64le LPAR, snapshot_page()
> oopsed on the page isolation path while reading an order-1 folio's
> __page_2 from an adjacent absent section (unmapped vmemmap).
> 
> Fix this to avoid reading memmap that doesn't exist (e.g., a vmemmap
> hole).

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> 
> Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
> Cc: stable@vger.kernel.org # v6.15+
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> ---
> v1 -> v2:
>   - Condense the commit message.
>   - Drop the code comment.
> 
>   mm/util.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index af2c2103f0d95..34cb43b3eaa4c 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1353,7 +1353,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>   	if (ps->idx < MAX_FOLIO_NR_PAGES) {
>   		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
>   		nr_pages = folio_nr_pages(&ps->folio_snapshot);
> -		if (nr_pages > 1)
> +		if (nr_pages > 2)
>   			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
>   			       sizeof(struct page));
>   		set_ps_flags(ps, foliop, page);


