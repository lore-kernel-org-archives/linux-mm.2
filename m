Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6EB0CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210888E00BE; Fri, 24 Oct 2025 11:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19AD58E0042; Fri, 24 Oct 2025 11:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03AB08E00BE; Fri, 24 Oct 2025 11:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1E838E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:42:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F51E4999A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:42:50 +0000 (UTC)
X-FDA: 84033425700.13.13C1C66
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id E6BA010000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:42:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dASD9Ge0;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761320568; a=rsa-sha256;
	cv=none;
	b=qz9Pgp6FYfIApCrljoQAAIUv0/WedeM/1zXkwRdiMqVL/rZPVgtz+O6O2tbS5uj6+Pid7w
	oOsYJn/UBuK6IbgDX6Ht1xbX9lAlCpswZ2YLkMyQWpcUe5/K5TGS2PFDVUo/SQ/YrmbfNF
	oTkG/yiDPckyRWNTmKnkFCGHAC5i5Fg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dASD9Ge0;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761320568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCFQCFgPLJJHNF45uz8IXNSwQz2ZtuMOkcxhO1VgMIE=;
	b=PUwfQsZMqilr1qMhByMfRVeAn+c4rt/e940HY/0YBlDiilkR6tpiDcE0hIsztL3NUs2TsH
	QNbQ5b1nTptXTG31FvLXhrwVVHMjke05yvx0BuibRvVzzxGyrpnPE4WOFIlXplQ4ABw8hL
	TZuEQTF5YTgKMMrizF+emzxvXEJrbko=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761320567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YCFQCFgPLJJHNF45uz8IXNSwQz2ZtuMOkcxhO1VgMIE=;
	b=dASD9Ge0FG3AlxKsD7WE0YSq8JO51uz0OrPvzXqBLisWqMtuw9j1gaM/buqNvIaSiPr8+0
	2HuwhdTkzaTLjPnAEEI7JAX9J4hSSvq3vSVaHLzYsuk7xoJwxBJp6ZfHeS9VI+JIvYbmS7
	KQr7hFDaGTU7IC24V88ClSCjXU9aMIE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-bVCtk51MPsGSXOD-Iv-alg-1; Fri, 24 Oct 2025 11:42:43 -0400
X-MC-Unique: bVCtk51MPsGSXOD-Iv-alg-1
X-Mimecast-MFC-AGG-ID: bVCtk51MPsGSXOD-Iv-alg_1761320562
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42992cb2ee8so222855f8f.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:42:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761320562; x=1761925362;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YCFQCFgPLJJHNF45uz8IXNSwQz2ZtuMOkcxhO1VgMIE=;
        b=U+6UiCyGwwBfRf/BNf9XLxBYHQUSNgrpsx21t0SGtoQrIFmRP39OAuDRjwdZGMHXIY
         EgtOCxJLu/y6XoKEzD3jEGZJylQNVyPFZ3yDyOtswL8GrYa1fc885jV4vdrVdiXPFa2L
         VYzH4XoYJh/4aOgx234sBtEDkSzF5HA4RUJjViXd9UdWMNkzpFblg0Jc/uDFPiV6WVGL
         GQbLPyADi2TZ2XX9CRc5rR3kCt+tocEaOXQszsYdksbdrOQk0RGY3Rs6+55hKiSUFX0E
         lKFG/8l34ezRFgAqq91IYg9/Gs098czqf9nm8qJZrYJV0CRLWd0MNT51o4GWcDxxtZxO
         sFog==
X-Forwarded-Encrypted: i=1; AJvYcCUN4fSTvDGr5DAKGA0m8cWGvJGzi7vqsJQOxmzJieiYH0eOE00dnkhBx2bx/zFFuOOHjDIvddpLVA==@kvack.org
X-Gm-Message-State: AOJu0YyxmXcM/5kaFkpR7l8pQ/HduQNSyIdPwaXgQ+e07mDcfQL4PUmO
	FqY116SvvPxKGS61OivGHaGOiL9m8Uia5OTX8AhwyJQrQ9BWdRHZD79HVcVVUIN+ShLfyfgYMs7
	AtZKxerVt6Rlp8KD72Y5ZSBVH8RnboA/Dr4ed/ZEP3kdYyLIdSMR+
X-Gm-Gg: ASbGnctKV/3cM7pZaAem5SzyqZVUlkYf3MoWyC0+TyKV0VwkI83nIWbMp7UdlppnhV3
	qLEf0oz6WoJs7dmWNxJKG1foQEE0H4pEFp2l2bp1c8+s2Z3099ztVNb3cOMjXbTWg/OF3eW25cZ
	UDYMtF/lVXoE9xtkIcOa+XFDdRbqot/HTQO/Jp2lahiQGYC37wfpfrk6GbdTLdrllKvyhFD2BVW
	sLlJsZbXfFoGugjuwUHvb4Xl3EzDdIYyvM1W9viqW3Fk4ZzWX1aRUiS7zfcb+9liPhEI0AP/+ZT
	9hebDJsODdgau5m0JmyI67A6GHZKMbLLEXiwUBg3X0EqZFI1HoDk3hr6EEYSPdhrp5dPM/KhcOT
	3jDT4Xy5nLLIU0W5who85uka+0mbVE95jE0J5qcNmLvPfyshOgZYNmY7dUHqRhWBuJKEZEa9Nc4
	iLxnP/G8ZwqVgqnaaRqKshOndZ4XU=
X-Received: by 2002:a05:6000:2689:b0:426:d820:a3f9 with SMTP id ffacd0b85a97d-42704c76535mr18604369f8f.0.1761320562525;
        Fri, 24 Oct 2025 08:42:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPnF0/ru3FWnNa1cDip4fvA/H/2f2hSvDV5kZEbyyXOBfqac/lKNoCd+rrZ3iEhhxjPCZDfA==
X-Received: by 2002:a05:6000:2689:b0:426:d820:a3f9 with SMTP id ffacd0b85a97d-42704c76535mr18604343f8f.0.1761320562141;
        Fri, 24 Oct 2025 08:42:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897f57b7sm9942229f8f.16.2025.10.24.08.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 08:42:40 -0700 (PDT)
Message-ID: <18262e42-9686-43c1-8f5f-0595b5a00de1@redhat.com>
Date: Fri, 24 Oct 2025 17:42:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-2-kirill@shutemov.name>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251023093251.54146-2-kirill@shutemov.name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rbAKDpY5RTtB9hwoxXZ3m-YUuz29EYQBxyvaXucl0ms_1761320562
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: x3zptkdmpgfwtwhe8qxynkkk4c4njzu4
X-Rspamd-Queue-Id: E6BA010000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1761320567-481321
X-HE-Meta: U2FsdGVkX181mbeQ46g8s8y56q5Jqq8FsaHcSnGRIGxdBamlNEw/3QNOsM8xRS/c6IokeBrpt9ss/sDrvBfl2AkY234Efa/E+9pn5thkOcJeep7xOcVIEurqy6qSCtXOGz7QeC4IhLrNT+05Ix98IWrTFtYclm7mEbKEURfzidID1psmFvr1XGusw0x1dzxR6BRA6TeDTQ5xG1secxC9Vp3GGrzEX4gpOjc5iLutYsFwPWDLnTjT5EUJJSGR2c+mLU+0XvzpxVgzTzyZ8UmYMKXSF2FrNrVIxEjofHEwrVYR7nfr4sWl8sia+Ofbv6qWiEgh+rbcNvx1/HSUJxtYGow0ZNKr+xWMpbbttkLK6FgGIipVmGGtU/MM2/t8fdu29W6xFr7Z3g3pp9XjsBKfoD3Q5/tndqNMPgfvVuYevMb3isSJaSo5stMh4sLjBtrWFJSp6vmRwYe54eC5clW5fepeQLhcp/oMui+pVSyuipSa89jpBH/qsqymbK4f9P5DwKKtjHTEhuhW58RzshhyGkhJbsEK7kfdrUFdnMQLrNr8kwlRUFd8QaABeOD0bfNjN1ZVy+IsXNfjBi9txuGOHVUHJhZhpdPUDFwx97x7PE4EfH2rdjYO+INN9pNSlBKS+/ae3zWvcsXAREnFiDS8nJPYdvu7QInIpRFplYKrVJ9ETrrJqkOLHRvSLUvAag0XZdtUxjpRlQJk1WI2AKpO+f7Kjo3f8Yh8sQ8IN3k4zfn4JwPwYrf6xf3+yO26BI177LtaA+zf9B0s8INwxgzYcYU1ukj6t/YaKsTCwMyAxjQ4bS7ycsZhO1vul9ZXiy9Q3tkNoICN6FQtOs8egS2yJ7BhKcsRMq2jStC88914+aRCXU6EvgDD0TtFoAmuEOf+pI+91EbQDtSq9E+5uMcmRxsZvxaSz5zFo0gUaFq1Ln5LS9iOgMf6nbCuhYXSqgzMn8bm8rH3GvH9KSF9bMu
 /pvFzA4N
 E0BGC7TsjJlmUYA+52QC2Z0wJ1G3snbr36+wBS0zCzfyoIhRElhRcQb9SO+PWCZHS8fEt1WU0cZm+Dk4rWu6AKIutOWHuvAaAhmIxQmG00jirvle8WGcZNeRmtCM5ciWWJClscwaxqQYYZ71MZ6yl/bOg8cx4SWLZgfS3evXLSbj05ww6zeCZErxSP1lLWGOXeLuZwMn4YieX8/+B9OGWv4RexFjpKDBhMF14FbNJW0wG4Uy762l1IbMXLl0dY0QIOlNNXAC3X/XRhSEVI4+jEGjouZc9MNDY09NyFjtplNXhCMPUZMs+R3tbCMmOiFChxV+SOeXEdwHR/9xI0JJtwZvyLrub/uC7opVsb2lqdyuEbEhhwfWecO0c4gWI/M+1deR92z23s+KWll2+8ljIvsa3zzUZmhhjXyJAGOiDhPGFmzjJ6JILqyEd4KFxErf0safabM/FZZb1azYDEm6m9jFKVwAUH/KooyTffLDuFqmf1P67TuH/TTlm9bqJuT1/zx4K4m/B0W3G4K8XyMeozglRKAyvsIAAwZpamRhK+lW06AXvhIqvoDLJBGZk8ywDa2KE0rr012quU40rpLYRxBaVFoBQI2G/aA8qAc83AqhIUiM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 11:32, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> Recent changes attempted to fault in full folio where possible. They did
> not respect i_size, which led to populating PTEs beyond i_size and
> breaking SIGBUS semantics.
> 
> Darrick reported generic/749 breakage because of this.
> 
> However, the problem existed before the recent changes. With huge=always
> tmpfs, any write to a file leads to PMD-size allocation. Following the
> fault-in of the folio will install PMD mapping regardless of i_size.
> 
> Fix filemap_map_pages() and finish_fault() to not install:
>    - PTEs beyond i_size;
>    - PMD mappings across i_size;
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Reported-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Some of the code in here might deserve some cleanups IMHO :)

[...]

>   	addr0 = addr - start * PAGE_SIZE;
>   	if (folio_within_vma(folio, vmf->vma) &&
> -	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK)) {
> +	    (addr0 & PMD_MASK) == ((addr0 + folio_size(folio) - 1) & PMD_MASK) &&

Isn't this just testing whether addr0 is aligned to folio_size(folio)? 
(given that we don't support folios > PMD_SIZE), like

	IS_ALIGNED(addr0, folio_size(folio))

Anyhow, unrelated to this patch ...



Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


