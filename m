Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF07CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71F48E0037; Mon,  1 Sep 2025 11:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22E88E0003; Mon,  1 Sep 2025 11:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D418E0037; Mon,  1 Sep 2025 11:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC6D8E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:47:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CEE9BC1F6
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:47:50 +0000 (UTC)
X-FDA: 83841111900.18.001BBA8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 88C03140007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:47:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KvY5e9qt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756741667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hYcrhM82Trwm92UJmr91hDehjIBi5rOZCZSQqow8tc8=;
	b=0XxYxCvivKWPseVCcUZo5kqtwtWZirCI53qfCevjc3LXVTZc1pmINUTKr+cIbVJWiZ++oD
	p/U/+4p9aKfoK1sNzhMNyrUoVh/BBKznh7Y9MieqZFwwTAGA7v/E1+euIi/KUq5cZdm5Ep
	EPhmjupDM9BE2+Jh7g/ZoPKap+OgOlo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KvY5e9qt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756741667; a=rsa-sha256;
	cv=none;
	b=ekTQ756cj9umHE4t9p41AYSArqbrvsYlt9kTlpoGOa1rTSX9GEdxTK5IfnlLLqPTQhO4nn
	uR6Ucq1Zx5J+W2ERbJ+vf9WnBjirIBQpiDbBE6dr9XDITngIiuO7m2LuMZvBvn+H5ycg7u
	ugBVQK3jrOuy2SuvK4Lf6CtfNh43NXw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756741667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hYcrhM82Trwm92UJmr91hDehjIBi5rOZCZSQqow8tc8=;
	b=KvY5e9qt2tyJ87gI8029OgPUiP9hiHxGvsV4omjla13cOw+0V6XDa7T4amK8neAhfmQPS8
	r2OIISo0OwLYeoWdVu6OTM/69VQ9W9Dq6st/OKNXXRWertYjwwFYmyNqivxCcQQW7hRIRo
	E+H7MEqjrpDXD+MIHItezPEP/+yDfSA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-uES1DLCgMYKU5HoDgTsNbw-1; Mon, 01 Sep 2025 11:47:46 -0400
X-MC-Unique: uES1DLCgMYKU5HoDgTsNbw-1
X-Mimecast-MFC-AGG-ID: uES1DLCgMYKU5HoDgTsNbw_1756741665
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b828bed3fso11405485e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756741665; x=1757346465;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hYcrhM82Trwm92UJmr91hDehjIBi5rOZCZSQqow8tc8=;
        b=AfqtvKe7IcXeCH8wRhvP728ge6uiw9h1cOjBzQWQUj4NEgmpsBYnM6iUMm2QPLmEU4
         9NdlVJAjcI6KVJYbLoEmG3FqM+Yq/rM+p4C4/m71Hxs9ut9VvxlngMakLNAiQKKDZD45
         eWFkd/Gplk+Ucn79OLp9x9RsKEb4/eAQTSPJCBIIWWuzYLJtERrsm2zWm59BWBEO6nPi
         Gaif3o9CCQ6VXabQl3lxyY8U7KiXZGmX8W7mtBcN2ODE8wERKQZw8X3/nwb1T/HJZaW4
         NX0HMcDH/m3h4xWwXilikNLX+R+bvEneCnRIw3O2jQMf8bDMgLzd4gwF74ddmX9kU31K
         C7Ww==
X-Forwarded-Encrypted: i=1; AJvYcCWjKyrIyEYLNEGbHGb3AmlFieP/g0gj/ecL07/OBfqSMe9SXsffeqObZ2HEZKel74L/7Kp53tNhUA==@kvack.org
X-Gm-Message-State: AOJu0YzOQdXk8z/4ObspgJ6FYh2AU4hruXT/5zuSjRUEH3VvQbl5d5UV
	1BnAz1uY+9b8arfq9aBteiFpdu3AAdiTBrI36i5lg3/8+7mPFZGXfS04xPJSfR9cRXSoYwJig2S
	ulKV0gYZ7OQQ4tz9KzAMeFOvCyRVO09O7DjLy/GNycmlug81M7KJ3
X-Gm-Gg: ASbGncumVFH7TVF99N2ZU5qSNdMTAtiZ6oogh8P/smZg2AnzcIYK5xKaQn5aqX7NvUy
	Ot1X/4FKdOgiIlwujOTbMnU4qXiZMhJjnrQYypEWK3e21/t3YrIfarVyUbZN3sfK0lkXCmb2ADt
	gljISFuGWdtlzICeAHBQrfFGtmbhvGRqODGE2a3JxJwV0TLqPfPj0UIGHB6seAL4sZWEIlvV4XU
	pevyBcJ3zIUpMITo9qgffT4dOOytHSLeAp8y+R/JEGUIW94mb/j/UR5aQg56+esREHvCwGzq5tA
	R9kkR3rO7X6LTSAnGyFtK6k6/TQZ4XbktUeKQOw2Hvo4wG+Y+nreLNyzFhcSJDPyTmmgvkWlhFE
	C2ywHqaWJkm9GfOcBiSCfYDYMARiUBPRpNQhOGPlIoIRxlWI08blDcoYvswdOb2vtSGA=
X-Received: by 2002:a05:600c:4f45:b0:45b:8b51:b1dd with SMTP id 5b1f17b1804b1-45b8b51b21emr40902485e9.32.1756741664707;
        Mon, 01 Sep 2025 08:47:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcXV513dMRDeVjWWxnGTvxVLODMc/QdAO1OoVbXLMReJ9iKkNuVXWzOcXMqa7piTgCoK5S3A==
X-Received: by 2002:a05:600c:4f45:b0:45b:8b51:b1dd with SMTP id 5b1f17b1804b1-45b8b51b21emr40902295e9.32.1756741664322;
        Mon, 01 Sep 2025 08:47:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b72c55c1bsm250264065e9.10.2025.09.01.08.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:47:43 -0700 (PDT)
Message-ID: <9b21d002-a94b-4c4a-8ceb-cb3fcf96390d@redhat.com>
Date: Mon, 1 Sep 2025 17:47:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/22] kasan: Remove references to folio in
 __kasan_mempool_poison_object()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-21-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250829154728.3397606-21-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qf6mQBPhGTTKX50cIkzHNZ4k5DDI94ewCgpRke3utpU_1756741665
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88C03140007
X-Stat-Signature: mgmyce8fikwi7y9un9r8yjmnow4dr6r3
X-Rspam-User: 
X-HE-Tag: 1756741667-103669
X-HE-Meta: U2FsdGVkX18TQE35XlVqaC6wq9jP29rfvnUqIpNo/u/ppxK42E4/EHH6IGh9Eu9Qdem9rmx/XedCs8UgJcgnh2gxoHUK4xdDXOpb2fNjbiPu4Xdon6nlZokccoSDfHmNBDnUKB+vrxZgL2froPa66G6ZZ6donXR8ha04k6AIIPHNYCaPvgcagNGj2WeCf8W8a/oQQTO2I82AARrzE7cVL6+RvSOBSmdzSrOKsI4WJQG2CevF4BF9ky1w8oD8+8TVMsFQZWKJz1HthtLzh7k9TPK+kkvHnh2zhiwUpQAcaCwwiYjt8xv3tDpMJavbOQJ2VjQ0yTIFAJBGHOp57hUvEQOfChqELB2dOxIZe44IzFs50wiI3wNeeFB7EVmPvWeJcfDmYi9Ym+Gc3bWDBFzJmNsI7FbSd7M7oEaoYulCYRyDe1Atn7PtjXKUU3BfyobSdDYpOkzLR/iomP1ExxzZKWNe1ClUyM1IDDyKyvX+DS1Mhbsm7PM3z+m9ss2PdqvjVOm71emDWtBS59T9gZdOn89/BUT2UUFqaumroAdlUm5zLf7NHSOrUAJsmPdVvFWIFz6ZizfMsqCXFFkGhm4dEBDgKwpVoJLsh5Y6wbYMvI3daOIhjutUf4Y5hYcTHQ/zk9V/k54mocC2pD9FAVdlcpWh72s27wXAilfEALAu72yq1ACFVfF/GXhy5xkqcP742A+Jp7v6SljSObHFOyoW02IGnGdGlU5vtgedhnArlSLXjFORjwgkYejCCkRfVOzOe8Ja84caSE/CUDgjxgMsu7i2rGU5ZtRWUNDZpL8Ex58MDME8e+sY1hwuirliWrQYk9VTeCquL6dCNhlsCfJ2XR/+yT6eBbaDFPcGJtXJ+9+hC+RPMRHSTf7izax+uG/P1ptOw02RRe0xz+nV2+pOQHgW5JV+1dkpfC2av3I2fbxAO9ekVJpF7c+Vj/NLxzHi+a9EsNBlNMATh4i22gT
 DYlm/lDH
 WISi1NaQEeKj8JCj24+hcviht/oHe3qF2nFg/Yw644dd6L22p5NpnI/7h0V1IX/FNtBxGfiw6sXFaoqL1D4Gg5PuOX8U89sldpukDDWYNTZxdcny01LxppMt85nQE8ri762o3tKOLvQRBn7GRMK/T18IAU+oZIxMfV6i7b2TWoORGv6exEnZ+xwPCf1SRgoQrAlkKGPGoAJZlWARvibvnt02BiN3o48wHPIOPQqkBmhOWM5eDy0t9hvvtTDzrGUvvggZi5WhVKYejGAY6wnGgih0diwOcF+jcSosnlQw7tXO+La/a6RmF/MsiYEHGvghbmo7De3KJP3S38D9YTG4VSSNg3TqIRI3TE8l2a+hX6LwPa8NBYmyR4gmtioRDuxOENaGdu/sfdEgAfFufnrd7MZ769JERaenpiLVvs5xQ4qJWe1S7Klrtnvh37bUi2Zy2wiXHhbS0l82LXn7fdOcfxScVsYSmiX5meCin58d6N4fzyTOcUsKcaQ+XH15fMZ09t1JTpfsFc20BQPg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 17:47, Matthew Wilcox (Oracle) wrote:
> In preparation for splitting struct slab from struct page and struct
> folio, remove mentions of struct folio from this function.  We can
> discard the comment as using PageLargeKmalloc() rather than
> !folio_test_slab() makes it obvious.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


