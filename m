Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 972B5CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811E26B0099; Tue, 23 Jun 2026 04:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79BF96B009D; Tue, 23 Jun 2026 04:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A426B009E; Tue, 23 Jun 2026 04:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38A2D6B0099
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:35:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA4E0A0384
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:35:13 +0000 (UTC)
X-FDA: 84910517706.24.98FA0EF
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id AD37C40004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:35:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tj+sZrNV;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782203711;
	b=nMTaMp7J6F3CXD5aW5X08CT6Q776jnZvRLOqlC5nPCNFFLyPLQCyljfY3i/3+z7ssuMwrm
	rvUdMK0VrNuitCIK9/+keuwDxdVV8Bw+P0LJd/cMR6VTR0eF4Cp/lw/OSHE6i5B1l9EmMB
	KoNe3RV4O4Wv+0Qu1d292EcAYk4q7G4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782203711;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAp7b6BcU4kkNXCTfexjoDeqwZPOPVgX166JQPj092U=;
	b=e2L50NJRetk8D0tsBljrgVbjOvYQg/gu2ZOXrYHCVFEZgDHGC5bOVn6KV9tlVywNELdMSv
	VIoZG0umRlN8obpHIUPQNePncgE4N6X9p95d9GfLGsAa3R8hygHiu4PRpktsVadu6w1heo
	bQiXjlOLHry+oolkcGBXvZpcIvOMu/M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tj+sZrNV;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-697564cb69eso6916616a12.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782203710; x=1782808510; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAp7b6BcU4kkNXCTfexjoDeqwZPOPVgX166JQPj092U=;
        b=Tj+sZrNVHPqlSZ9n2aO8TUgomf2aLwCxZxeHY4ys/7UFMSzMkNZIuUWyrLeYtx+QVG
         Ju8spz9p7cDTP+TNbpjSkGCKpDjfZCCyY2IyQ7lhj9m8XchNIL/ux959PiO998taB1zN
         8qzinN6THmh5vrWaPAf7LIt7jqJFPHtVUNe0Qzhwy3WiK+xV1l2nuUQ/2zznT/2iZcSe
         REeqY9EjkTahWfGTKuViVBsVZ8VNhrsKzxt3X90tixfYv+Hq7wCb9zk2A9HA6KACNbhT
         CYW6BivuWmHTjnIF8GH8BrL5ta5xi3jrBcRc0INSwA4TGQndZ3Wi79YPbDy3zr6+TpNz
         qfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782203710; x=1782808510;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qAp7b6BcU4kkNXCTfexjoDeqwZPOPVgX166JQPj092U=;
        b=GA1SLHIqGDWCq7rh8FSB8Tb4uu5pqiF+hv8FLD2k9fdwo0+rPPw3ayx53/kXQNIvfX
         GX/4BPq/TLDLZYHwdl59/bW+AovuoF776HmuL2kc7PMVUzandisAkG4vhIzqQErhQ/pJ
         4Lkgv4oCattzpHF8y5KyhdZvzGdJHUE11pxbUVPVqlGrWsfHBt8S1ltRbefpNdOjFQ5g
         /dYR+6KgfvHpNeD8PqV/Iv7PpC0uHAo7FnF7EO6/PJaf1ikAnMusIQbMPmdBer3D9a75
         BcoEIZMnQ4ZfzMHboexuMq7aHOsZCQ9henqwbQ8S/M64t2+mWTVMMCphc5RfgQFUxoZq
         M83Q==
X-Forwarded-Encrypted: i=1; AFNElJ81A2VYfXP4lUpxU/KfzofS25kDfdsj9CwKJTjdLI0KrFcMahhvCS4CWI0t/6ocNHrJG//MHnB0lw==@kvack.org
X-Gm-Message-State: AOJu0YzNxZIafGNrgImBV9LaNjJMCbECLl+BWd48vdtDrdJLwlMCzMig
	2Z4AMBxe0r8Vi5YQXULZ5IVpFbls1RT1GpZ3GQJtxz/JCaPsh+Euo5y1
X-Gm-Gg: AfdE7ckUOFLpTW6oM4EJGyvji3wvuSR32fHLTPNNt2HLkBcC+xbuF+GH5AhbPkRDZYU
	KOn4M5v7/qmfe4MHuy/ReqZ7isbdSveLXkX3RUnX4we0WXAmLLd9UySV9Qi8HkayAi1InYNsBrx
	0eCf5N8mCVGuizn/YlVbxE9MForjubg1siZ6bhjB/P8+5sctsccC6R3dko+Wxxmt6JfFCtKBf/V
	yAo+Ri2Jg+aLFYef1gYRhGENQuzaP3ocphf/9oeDnFBGm1TmN0RxYZzt9DrPr/dbWqmebMTDge1
	kkeE4VSzOuZSvFeSrohx8AgEUEn3wzPL+GsaHzj0JDUzJ5QYDFN/4zOulay4hGxNKMQvwzfctPv
	lbzp8wtXdDmrGIlbS5KvFl+k4vRWBSu8XldUwB54sQMhlV8VrGrDcr+oUvVk6QJWLvXX8Jc5iqq
	3oZTW5nirQBzY=
X-Received: by 2002:a05:6402:2710:b0:697:d645:a9db with SMTP id 4fb4d7f45d1cf-697d645acfamr1333409a12.23.1782203709705;
        Tue, 23 Jun 2026 01:35:09 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6977be640a5sm4022711a12.26.2026.06.23.01.35.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2026 01:35:09 -0700 (PDT)
Date: Tue, 23 Jun 2026 08:35:07 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	izumi.taku@jp.fujitsu.com, linux-mm@kvack.org,
	Yuan Liu <yuan1.liu@intel.com>
Subject: Re: [PATCH] mm/mm_init: fix incorrect node_spanned_pages
Message-ID: <20260623083507.kg7jmd7ofz3awqmq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260622022403.16375-1-richard.weiyang@gmail.com>
 <ajk_l8cT0mIyhs4r@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajk_l8cT0mIyhs4r@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: qhogzskd5e4s3zgiz97ttgcqz668xkkd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD37C40004
X-HE-Tag: 1782203711-365604
X-HE-Meta: U2FsdGVkX1+obeadbhHdZUH7SV0BBDB8hKaEJ0FRtgbDA6233J91aFdn1ndjAcL60lOQwRoJjvO6idNpiDN2/YRc2vtXNFa3TyVJayR+7pDz4s8kZV0VimfE3zJCjL745qA1CTI62/lcwNYbmim9rMAJlg/eEjocn/lp3UZDYG/m+b22VPAFskUd5ShZM74eOb59L6UdzGjxKgepnRf6kj7gfH4Rw9xC0XqgGvEG7tIwPn1MSXHROjgEgqGb7P8MJu4Z8NgT7jzVTVv5naDx6SsIosxbSEtJsk2IW62dt2YI0weSAs5oEDuvG9A1L9XxcvlrXW/uxwNBoLCqWehrF18bDZ2hJNuE6kNQD65P/Iysy3LeDsaNovhvj9HQiKU0flUbqkTROTSgUfGD4Fe3XassDoKYp4zSqIDmADaxZsjrTZXmczp2hmym+JnStXNGfhoUyMKhnjxA5h5r5ty43ZeDsoZU9P/SL8Y1uQuMLPJgE1jkeAKJAznxMjFJz89uYf0UGW8Ff5Tjc65XrRsKEi3F99guUxx4wa6vF9mvYhf28MilNaWATLuhqkdySYE5jqTJ1mzu0w73tJC/XJTf7k0Tayt3mu9H4McC5HnSuMZmhrxn+pbuEm0nYfCRe70Pk+XPHSDDJ3gmzyG0nhWpWK7D96WW6FZHcd6jcwM+tDDJigBXVrYL7tSM+qsYwO4SLH+RDmYFxE+kRF3DVhPNL1KweYYvR/MO/SuLHHB8kmrkGpC+aBWvTkQ+RcN85GuXJ0gb/5AUC2+YH8bo+lLnsBIEIBKGLZAQ68dfcfOB72a4iqJ98Eu23VDDOPN5qldzoFmcO/mUfSZ96eTThSESq8plLE2hZYwgZLG4ahCjhQJhFI7qdsZlM4LJt3djabGJ/P94h/qAyMgGxBwqa45XzaI4sF24n5K7leVyrxkajodd3mMuermbniYSMLewJsmmJlIOWXGfhGWLmuvLKKK
 0nHaZXhY
 qpqUsRbPO1HvddKCxlTLOoWO5Jp+TsAip//YhX6CzMaTJI4zdUlIdw1RihZY8GMNeNuaENToWyLXNNmPkz917ml6agvIG9qcObfmAN24WkEpjAoBTnMG9LLgySI6sBPvL0vv5IqHEBfvCp4JyjEsbreGia7Tr2hEYcAESn+iv1H7hCNpuO2BHcgbCIo5+2GrorPl7/8xWoSTTvbfTiKAwHhu9UTMcszRzbdAbwYdXxUy40Jrw2L9lpwtOwCV7b3e7k7niGKfqtGcRzHnI0XFN6o6hlkFv2DX301vUBIPA0ADKhM4PQkKPfb6yvCrnYT6GDFjribqIo8NZCLnPyzi+pS8HXOGeiWKfemWYyKfgBi0y1bLbRHV5LGzYVF2sL1iYaxdacCfVAD44ZHToFoSENFZsngIithWs7edcKMFjq4DlyH2tXpjGuuBq1VMg/V9dBaPp7sY80Y242o0+5/jzbsEn0IP/pUUnjfwwy2W6NHeD1CQWWQrPmEI81+TKWoWh8p1fgbmf1MBiN5OFzumG93UKww55aCGfBNlrY8BZCq4CDuwmA2pI/xS84jcXmkrXZR5qgub6ANk+adH2DaNWDy+xSKO+WjtoZ2exnE37baUZuntAfLYimNy8Fmfu5Dkgvi7HvshwErWgOlIjfGhKQUCazAhIxvx4rqGJ9VrugXRYanIXIMuUJJBIcpaDvsSzhwXYzE6dASVRR4OLhXeZUzMqM9Ye9fYB8xZ50uxNLxNbf0TqjYSHXsvghC7cc0AHgeYQs3/ccMa1ST4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 04:58:47PM +0300, Mike Rapoport wrote:
>Hi Wei,

Hi, Mike

>
>On Mon, Jun 22, 2026 at 02:24:03AM +0000, Wei Yang wrote:
>> Current node_spanned_pages is got as a summation of all zone's spanned page
>> in calculate_node_totalpages(). Generally this is good, but if we use
>> kernelcore=mirror, it is would be wrong.
>>
>> As we already passed in node_start_pfn and node_end_pfn, fix this by get it
>> from (node_start_pfn - node_end_pfn) directly.
>> 
>> Fixes: 342332e6a925 ("mm/page_alloc.c: introduce kernelcore=mirror option")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Yuan Liu <yuan1.liu@intel.com>
>
>I queued it for now, will push to one of memblock branches after merge
>window closes.
>

After some investigation, I found current mirrored_kernelcore may still affect
memmap_init() in some aspects.

But how to fix is not sure, will prepare an RFC for discussion.

>> ---
>>  mm/mm_init.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>
>-- 
>Sincerely yours,
>Mike.

-- 
Wei Yang
Help you, Help me

