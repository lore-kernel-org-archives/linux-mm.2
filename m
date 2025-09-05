Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4CA6CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 06:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED17E8E0008; Fri,  5 Sep 2025 02:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8D88E0001; Fri,  5 Sep 2025 02:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D986F8E0008; Fri,  5 Sep 2025 02:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C850D8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:41:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B344597CC
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:41:33 +0000 (UTC)
X-FDA: 83854250466.18.F7724EA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0B98220005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:41:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EpW1p9MM;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757054491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oF3HN1Q6ZNxZN3c5DymWi4LgFv8yUurotu5FuTflls4=;
	b=pd3HgXqXV9h4xDi6KS8es/ao8iABWps4b5EfafkVOK88aek289z0ZEtnDDvAHsY4Clc4Rt
	Lj8FbVCljAPE3TmOmrQTgbD5ouUaT1n4oVN2DHgdIWPrUFWbY1wfiQ0KaSciqeQVoHzR5z
	zZy2ENiyA5EjY23bfL19a1FNTTI9MmA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EpW1p9MM;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757054491; a=rsa-sha256;
	cv=none;
	b=qMhJvTGKI7HACnQn6IXYok2Vx4rznDMIWcraWlu8gBSosX4rIhMN81uwlHS+hErVBBKXs6
	jNH3+khV/a7kYMOlJl4M92OJ7zo47DvuVUo0AlN82zI0dpTu4axyVEv8/lG8HhXewbbyeT
	w0yXb1i+XgPzz5VYl37eFJrB1Vbhpeg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757054490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oF3HN1Q6ZNxZN3c5DymWi4LgFv8yUurotu5FuTflls4=;
	b=EpW1p9MMbSDUi+SxAEcAL7HZbTLcxXjgKuaRcCee2TDI+3yZ8eGcUiDWKX1LvVr1KMVCwy
	T7qi/fNDlIqPoU6ENhlQYJskkfhBCl2fSkz8yo+wadhzWXbqUY27ziyTlMA8I3rIjIU15r
	IVbvW8HRUhpw8oXoa+xYLYjM4qDzqN4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-aGh6PuTTMn-ZaT691JMZAA-1; Fri, 05 Sep 2025 02:41:29 -0400
X-MC-Unique: aGh6PuTTMn-ZaT691JMZAA-1
X-Mimecast-MFC-AGG-ID: aGh6PuTTMn-ZaT691JMZAA_1757054488
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45cb6d8f42bso15001195e9.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 23:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757054488; x=1757659288;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oF3HN1Q6ZNxZN3c5DymWi4LgFv8yUurotu5FuTflls4=;
        b=wbFrXBzlrb5+21zwLzmWqnBRLdFxRoZfvQfL5dHritiNh0VZ5r9ZbHLCsXFGFD+bBZ
         Nww/VzaTr0taexyWrKl+Sp5IhNjPDa2Xm+6wGHQLdCnsvux27SSMbUaZKj2oYig7XR0m
         61Pq7wMh52fta/0B4P/faPqPOY4HdxXCHFQjzrzuWrKbikZbN/zJfubpEUr+1Pjxif45
         DeCupNRrzD8egnbSTeUuFUj7O1NX3B/yAEsV9CNazBE3yl5BE7lp1XkDFCwdyaO7p8iS
         Rep7EkK4GwD220EvRwUgol7iQEye27/yYwoOW16ENRJuWXvXJei4E07ynDUVFGqSwgaS
         iymw==
X-Forwarded-Encrypted: i=1; AJvYcCX6DgtWIM5/2YiM1Z9nK3r9XMdM3bh/iHbjBaGHBRat5q/NqXAwiabRc4RBAmDaRo3NYVdXCyKIEg==@kvack.org
X-Gm-Message-State: AOJu0YxBLOBlVI42wSbWp1pIcladWmfc2LqPR7236cTrGkJ36PeXWkZ4
	VRwUhTjXE39stS6/jtGHyPfUKxHjfczSreNCG8FTSjojeVqk41ivf4IUYCD7ZYaNZK249IYa65Q
	9Ls6iV7qb5vAdA7A6JCn0Du8wrf8Cv41i2YowT2eN27UYxlapeLe/
X-Gm-Gg: ASbGnct1xV961bEthLqt1jVRMxWw0bS8cA32cEzrgN1n3MBVeGXeoYsC0O7XjPQtdwR
	LF0amRH2Cmr6iMM48ynD2eoEVL7GX412pMDIKVPLB3TPvQtycGNbbD1sIRExtqUpiBl9tD3Z9Lp
	+mBoZv/MFM6dcmW+4qNiC+5714wEp2IKa+bLZJYH46DFe+5NIz1wca9FuHtuNIveLu0o0jKIYDD
	oTOZD/jdL5Gdxxc+3HPzq1GR64dH7MFwRhG2/7NgEABSRkJf38wamNYCOtmT3NN2VPQWiev+It7
	vo3aIUYvuEJjrCevVpBOg15tUjV4AUDL7F/+9kXftgzIbqOkuk5hn2JSi6c28uWk4ZDE7N15fvv
	Y8kpy2NQo8hEqFx07EC60Etqw6Q0eay+6qFy2FmYwycjIiGc1k8y++WUd
X-Received: by 2002:a05:600c:4ec9:b0:45b:7ffa:1bf8 with SMTP id 5b1f17b1804b1-45b934f6a56mr114233045e9.23.1757054487754;
        Thu, 04 Sep 2025 23:41:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEj1Q4ueRZg61r58J+1sq7/RpmSeqvAcWabr/Sq37OcVKAf1elh8/EonCz3Jhepl0SBZP4Cg==
X-Received: by 2002:a05:600c:4ec9:b0:45b:7ffa:1bf8 with SMTP id 5b1f17b1804b1-45b934f6a56mr114232615e9.23.1757054487185;
        Thu, 04 Sep 2025 23:41:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8879cesm316420125e9.12.2025.09.04.23.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 23:41:26 -0700 (PDT)
Message-ID: <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
Date: Fri, 5 Sep 2025 08:41:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>, Jens Axboe <axboe@kernel.dk>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901150359.867252-20-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9CR-krrEGLDUI4xdtg2PrCcy8qhgl6Z7z3AjynXv66o_1757054488
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bmqiiswyqgnrg6ihmd1h796jb6p9smga
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B98220005
X-Rspamd-Server: rspam05
X-HE-Tag: 1757054490-911856
X-HE-Meta: U2FsdGVkX19GRB2QQI4/3Vzil6yw9dvJgv7LVPtEhE01G0bPxSdDoxcjPRV+aps3Xp2+Xorka55dFCE2ZTlEAU2teExjbadzeekKZ8j5EJu9FuJ2W6t9SSEb5n3/J5B5f0xvvVIpwJtJ4Yg3n/lxkh8gtBsZiTHuxGdw1PO8Sb2KetXT/2PwP/zikl9wA/tfIpfuPv4ge4I7D4bxnJj7DkiRITnqT70E2LoYbaYJkO8dgdq4Uj3pYQe7cV7dsk4wdfOPymFZCFPUvEJ5qIFUaGTg23gm7jJbIZZf7VfJ3SVUfNQw3ueSrEplmzu23wZbq6fLZF844AfdKQONEqo4tNX7VKYnXEIbV6ouSY43yw2Jn9ocXCy3XP5xt2tp4TvjojWo8MJ8AXrqtCYAJYj9aN2T+GkX62vDsIpgjz2bJUbwubyEtKiTiwSJib3KZdqE6wBjL2sUowqUtTZfT9pS/q2BHgEg9oQHxdXlbo1ZEKwH3K0iRepGkvpIbqU/M4qALKFt8Vj32adu/sk/ycMaIjxxS4mbrQ3gn7uidbPBNTe2qsFI9g+99BFEaBwraezVIUEsMBh0mBLJS16vvugFHAcyY6061+jot4/EuQSIvVM5h2Yi+3A9/ojIBbSDx7WHi7NnDdf4F2M5UHKhzkQnitopIdjKBIhW4Ag2sprBrKPavQOOnnh4CZx6CKMQTOET+n0em0KxpErQvESUUcVhTxqc78tUBJRkx55sejRmTX9hQEUxb2VHvWg40KnG8/vDaySHZIq0fjqNa8bxoZpGycccsuYi9etOyc+RmXKJMTsh5ujTNwWTl+WJeRyDRJwAfDvgdbpKcOzrwXNfH+OLiw6qVcJPP9VdcLRIt7i6T55mUePXxdTT7bt2fQzWSE/bLPkXP6tVF1SW7czx2dreVo0p3ydvdaKM7KdpP0ZFhtL3fxArNhAsIM/arvY61bs9Acc4j0VuTOMTDoXxchD
 5JQrRn/Q
 xmetjU2E7CzSWPGvzmhJDa+KZnak7Zg9OO8EEiewnrfv6RPbIYItvXFGw3rE+lRO/bUG8rWo93tnMZkCSCw5OavaVgXCrYN3MFWJ/ukTFYrqRWOfySsSsVDXL0XrI5jhB/5sM0itOtWQU78F/GVX9/CvB8+fvyqxurWonN1EIspUBgT1v7/HcFt0yy+7d9aYMuqqFjDMKO2hlIcuDq0nqSzbwdtd1FTj6lAJe96Oj9weQZjfdelKuGVMd/UwCVrB1BVyQzqJ+zIPcx/3HpWhKrgKZMbjDVRrbzsHXxd/MkWVZgA1GOTGRshenR4yuAuvYsKasqZAwqgSCOGVSzm0rllBdDf3Fbo3k9/X3Nl11KRjtqLhJf1T154pZsKxWiCSv7k+saOKtAq/i+Tqe4+o4lnapoW/ts2ikTdvXBJ9TCIt8hHZ216Rhj8QS25Sv6l2eFDCEykoLZhFHSIPMRTcRNZMFwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 17:03, David Hildenbrand wrote:
> We can just cleanup the code by calculating the #refs earlier,
> so we can just inline what remains of record_subpages().
> 
> Calculate the number of references/pages ahead of times, and record them
> only once all our tests passed.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   mm/gup.c | 25 ++++++++-----------------
>   1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index c10cd969c1a3b..f0f4d1a68e094 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
>   #ifdef CONFIG_MMU
>   
>   #ifdef CONFIG_HAVE_GUP_FAST
> -static int record_subpages(struct page *page, unsigned long sz,
> -			   unsigned long addr, unsigned long end,
> -			   struct page **pages)
> -{
> -	int nr;
> -
> -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
> -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
> -		pages[nr] = page++;
> -
> -	return nr;
> -}
> -
>   /**
>    * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
>    * @page:  pointer to page to be grabbed
> @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>   	if (pmd_special(orig))
>   		return 0;
>   
> -	page = pmd_page(orig);
> -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
> +	refs = (end - addr) >> PAGE_SHIFT;
> +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>   
>   	folio = try_grab_folio_fast(page, refs, flags);
>   	if (!folio)
> @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>   	}
>   
>   	*nr += refs;
> +	for (; refs; refs--)
> +		*(pages++) = page++;
>   	folio_set_referenced(folio);
>   	return 1;
>   }
> @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>   	if (pud_special(orig))
>   		return 0;
>   
> -	page = pud_page(orig);
> -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
> +	refs = (end - addr) >> PAGE_SHIFT;
> +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
>   
>   	folio = try_grab_folio_fast(page, refs, flags);
>   	if (!folio)
> @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>   	}
>   
>   	*nr += refs;
> +	for (; refs; refs--)
> +		*(pages++) = page++;
>   	folio_set_referenced(folio);
>   	return 1;
>   }

Okay, this code is nasty. We should rework this code to just return the nr and receive a the proper
pages pointer, getting rid of the "*nr" parameter.

For the time being, the following should do the trick:

commit bfd07c995814354f6b66c5b6a72e96a7aa9fb73b (HEAD -> nth_page)
Author: David Hildenbrand <david@redhat.com>
Date:   Fri Sep 5 08:38:43 2025 +0200

     fixup: mm/gup: remove record_subpages()
     
     pages is not adjusted by the caller, but idnexed by existing *nr.
     
     Signed-off-by: David Hildenbrand <david@redhat.com>

diff --git a/mm/gup.c b/mm/gup.c
index 010fe56f6e132..22420f2069ee1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
                 return 0;
         }
  
+       pages += *nr;
         *nr += refs;
         for (; refs; refs--)
                 *(pages++) = page++;
@@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
                 return 0;
         }
  
+       pages += *nr;
         *nr += refs;
         for (; refs; refs--)
                 *(pages++) = page++;


-- 

Cheers

David / dhildenb


