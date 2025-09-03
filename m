Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8026CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11FB8E0003; Wed,  3 Sep 2025 05:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9178E0001; Wed,  3 Sep 2025 05:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7B68E0003; Wed,  3 Sep 2025 05:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBAA28E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:16:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 871F0140573
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:16:10 +0000 (UTC)
X-FDA: 83847382500.29.C6DD4DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 107D68000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:16:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iX55/DU4";
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756890968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28mDWsENSgMZZFHaEQtMBw/6V7wQ7nnUBzSqOWkE8+k=;
	b=16d+bj8z1rqoG8MqbAnT39kIvJXN5JT+7qTxomJamrSKgj8VYPjHXCWY2vHuNzIFQshX3X
	/RbkZG4durd8DC3AKt9qrpPA6UjXZUobL9eEpcNOU09S5fMjlMO7SZIAZ4Sa6+xuoqSNdE
	XGdM8mXbSxmmH8thRb4UcSN1uQPLYOQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iX55/DU4";
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756890968; a=rsa-sha256;
	cv=none;
	b=2wdIfs2MLQMCMvPn9M3G2Gh5P++JqaTlQHIJdeGwPGuz10rvZ21na2J2qwiKYuZjWIFmX0
	v+I43GHKOHbeIrWaA3XTL834nQeqWu3YivHUvFrY5h3RlIugECF7OxfhcDBhsKPDMjIyB/
	WXeSpn9EdNj2aqdCQeeHfYH8zV7MsDU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756890967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=28mDWsENSgMZZFHaEQtMBw/6V7wQ7nnUBzSqOWkE8+k=;
	b=iX55/DU4mL/ZUXTMtGNZGi4TzEoHSM+CHbQOlOv/CIl/mSV+mk8DXzJ7SNcTRHWcA4vqEr
	ywzx1HwS1O11C9hQscFKJFtLZLFQmV4Mwo4Lif6CTcTc57p5vU9eLl0JHc8J45nhljbjPp
	SdHCOPyiAp+9GU4vMAW7tMtEmva72zE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-X6LhW0WoPTi7jMoj6c5q2w-1; Wed, 03 Sep 2025 05:16:06 -0400
X-MC-Unique: X6LhW0WoPTi7jMoj6c5q2w-1
X-Mimecast-MFC-AGG-ID: X6LhW0WoPTi7jMoj6c5q2w_1756890965
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8af0b8deso17914835e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 02:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756890965; x=1757495765;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=28mDWsENSgMZZFHaEQtMBw/6V7wQ7nnUBzSqOWkE8+k=;
        b=alK/1CyJ5qfC/F9sJnTrSMWwVWqC7B0ygGXEQtKDZArkH4dWbpC5YqpbiafIueIfm4
         mizq4GJ3laL6YdlyZe90SzMYxzlReX6mh5f2yPgbSvPHyXF6hGWll0d+56dorQyq4g2M
         dhGFlB991WpbQYg1hgcTmzJl3y281V0fhxb8z1YGqX/Da+NuInm8W9QjQbck55cd9vDX
         Z5blbIWrRSgBNTEfyfZybjcb9htqEGOpu3Skr6BhcASkbq0eYrpYTbKYP04P/HHEx0FU
         OB5FhmAjP4/diFswtEDKml+0tCpTQKi8u6lweLxHTPOjACbyP/vqvfqwjViWYFWTnU2v
         LzcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoKbnc7ckI8arDQPztBiqRfB/7Z2ObSdW6GPUSo/jQluQU+JAN3mT2q96HeOBvcMYdkjqkAkoWGw==@kvack.org
X-Gm-Message-State: AOJu0YwQpyAtWSjlVMYYnk4yg0B7JGJTzpEJ53Xv0IryGnSWj8jvxlpx
	srjq51V0yCblzwE9/jDMIy013AgaIogpDovQfiBpVBfWWFONepm0nxEXLBH+qP0osTEgbUdXeiD
	Y4QuOIYtGqmed5bJy1XMdI0QG0hc2SKu3aYBGjmYl0JWMPAS2GgZV
X-Gm-Gg: ASbGncuDR/qjy6+a3n46pemrI5qmnlaps+lfChSd4HvXH0o/Var05GoysouTqkSY+L6
	2226EuqQr/57gpDrXiM8Vuqc+8KOUAB5hUH17j5NFjxwhz7W10gqKQkyuy4jHYfP68RjsaKV+YH
	p0Mj84tBp2voryCY7W/ydJWUlcPIb3Xnq+UPA0rD56gALT4Bc4sFftGy54fSvwBCCzSoDRGDrW/
	GVD7TWi/fBaiZjUWR0ee2m7GiZApWkkYZBqSHK4z+vPhK2k5J8ANc1rPSvBfOOPZSWJbDK09Fml
	wRZxvWzsfkcgeKwcoMkQdhspoPGn2nGbBAjKw3FdyQeGlvTHS0sJwrgaMoFX8untAoF+2yjPwlI
	NJsc0XpyC/3Ngei073WFRe64cyDZM7jB5bkWQav5mc3F+RfsEIZKJd8rWACCRyQklpSo=
X-Received: by 2002:a05:600c:1c10:b0:45c:a955:4578 with SMTP id 5b1f17b1804b1-45ca955460emr18060335e9.21.1756890964854;
        Wed, 03 Sep 2025 02:16:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgQS0ZJ2WNoB9BcKgKLIiPqL03Al4yOSnAhbopLaDn9L3S1YASsGLLTM63HWkvStg88m498g==
X-Received: by 2002:a05:600c:1c10:b0:45c:a955:4578 with SMTP id 5b1f17b1804b1-45ca955460emr18060135e9.21.1756890964465;
        Wed, 03 Sep 2025 02:16:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d23b7sm230998375e9.1.2025.09.03.02.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 02:16:04 -0700 (PDT)
Message-ID: <3c283054-b14e-4f36-966f-78cf3bc0f3af@redhat.com>
Date: Wed, 3 Sep 2025 11:16:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] filemap: optimize order0 folio in filemap_map_pages
To: Jinjiang Tu <tujinjiang@huawei.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com
References: <20250903084223.1653192-1-tujinjiang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250903084223.1653192-1-tujinjiang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xhQB80j7NGvyDh3nk4YAqiw2aWxWcC-PgtRzDSJyNAA_1756890965
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 113x1s8p6xg8ae1k1z4apchczb3mw4sn
X-Rspam-User: 
X-Rspamd-Queue-Id: 107D68000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756890967-978456
X-HE-Meta: U2FsdGVkX1/1h/mq049H+0r96Mp7knal0M3HY5Wc3lmadmnJWcYsQDhF6Evqg3G0Z1E/YdSCkaT5muyVsTXhkF0XPZtJtw4f2AX+VvAYdzrE4avz0l21R79VhTMzi9FXDBHgO4EOF8Kb/onbIpvxVOOK4SgkoxsCwwa4Po9lf07rgbQZOS/KzXvBq/nEBynnjaAP/nylLGh9FHkx0lYEDgaJBad5GUK35Z6gVEH1UHk1fbMIQzYSf2m9W7NVDcKFnBXd2pKYVPfMOM56etV2nGrZLd2tfzrvP05le7/mArRGkOhFQ1oh/WbfCBwq5NhZjBXWn/MPNa3iLiuJbuAvlQJbObpbdSdPm9EqKjmainM8ccbX2S44OO6gLRB2K9U8nhEax/1AfdgMDdXnolSuhFMoC8ELoSqxnpeYsHBky6v2E2HNvC4Ei2OHeessD5flXi2JKICaeR6YK28XFcs39XK10PzBYjo784QqUK3Y2QfSyZxzlsNjI1pjgOGuaJMTpRMPxakGs0QLuHJNGC7tnph0nIiRp/96fv6wYPaNAKGqmxxtpJaRtlBUv8y8EWNdi82rymLCPVUcJv1WZ17qcxKcp3aDfojiZHrs9+U+qZJ6rygCs8wg00bZQDoPoiJV9gLtUi6Ibua9ZHr8+WEXvr8XXwalo0PXq6gO6Zbc2xEXE2Ob4PlY8EdDxSefbEALy0HImc2wuYosoN6L/3lcvFpZymIdsK5UFkaZXMZiLhKdlKPZjl5ZP66KNDm4ZKJi0uPmpwRiyIOxIuG4SOTrYXiSuDlZxkd2cvHUOb4ql7lNHaPF/CSpf4V+LiRdinG9BaU8zIH31tRBZHPFgc3rRm4y4cTk0+tTGfHREbOJzWc/MGPkOEXVgzA6b28BucRrb+3lJ5h+6lMBMcw6Mqaii1UhGZBNlsOKTNNu2tLraNYBL+m+c3DoeaJBSQhuhUAepwSFFf/F3Pdsj5wHZPU
 aBWqxBhU
 8+OEHgTFwsf5aH7+7AuLnhb9QKyWuQqNrqeVbGTEEShB2LruHB8PLKFPNIA/lDamP6zF5GQdK5TZ3UvImugu85qPSH+Lu8tYXvsAXWUNxbSMYdTjFZIcj1YgVdkbN7vnejAGooCkmkRZbxCj55LsAtQfCE900k1wS+Wty0Ow18J5/4zsSP+cQxWnvZx4G5DHoy6/yCTZaJPLUuy++/KGEbppq/nw/kDuAalZbdBsbgSROfvV9ndvjIbeHvVXe0K7TOlvxfeN7x3YotvHn/H7s18gsbfU2+Zq1xHXX5iew3+1uA7Spp73dfg/Jlm5ueabz0dvSerbLK4o3mE9qyF9xpeUePjo2xddQxxQjE7nlfJHlJBy8yMzfdO3khaYdmDnLWQ1DUKq9BfXr1rudDQ2+7wPjkirqnsbCXzd5o7TEIZXiTBbQquq8W6C5Tv4WdGCBE0T82rx3et3x4yxk+Qvw/A0nuDptLP+zSp0g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +++ b/mm/filemap.c
> @@ -3693,6 +3693,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>   	}
>   
>   	vmf->pte = old_ptep;
> +	folio_put(folio);
>   
>   	return ret;
>   }
> @@ -3705,7 +3706,7 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>   	struct page *page = &folio->page;
>   
>   	if (PageHWPoison(page))
> -		return ret;
> +		goto out;
>   
>   	/* See comment of filemap_map_folio_range() */
>   	if (!folio_test_workingset(folio))
> @@ -3717,15 +3718,17 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>   	 * the fault-around logic.
>   	 */
>   	if (!pte_none(ptep_get(vmf->pte)))
> -		return ret;
> +		goto out;
>   
>   	if (vmf->address == addr)
>   		ret = VM_FAULT_NOPAGE;
>   
>   	set_pte_range(vmf, folio, page, 1, addr);
>   	(*rss)++;
> -	folio_ref_inc(folio);
> +	return ret;
>   
> +out:
> +	folio_put(folio);

We can use a folio_ref_dec() here

	/* Locked folios cannot get truncated. */
	folio_ref_dec(folio);

>   	return ret;
>   }
>   
> @@ -3785,7 +3788,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>   					nr_pages, &rss, &mmap_miss);
>   
>   		folio_unlock(folio);
> -		folio_put(folio);
>   	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
>   	add_mm_counter(vma->vm_mm, folio_type, rss);
>   	pte_unmap_unlock(vmf->pte, vmf->ptl);


I think we can optimize filemap_map_folio_range() as well:

diff --git a/mm/filemap.c b/mm/filemap.c
index b101405b770ae..d1fcddc72c5f6 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3646,6 +3646,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
                         unsigned long addr, unsigned int nr_pages,
                         unsigned long *rss, unsigned short *mmap_miss)
  {
+       bool ref_from_caller = true;
         vm_fault_t ret = 0;
         struct page *page = folio_page(folio, start);
         unsigned int count = 0;
@@ -3679,7 +3680,9 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
                 if (count) {
                         set_pte_range(vmf, folio, page, count, addr);
                         *rss += count;
-                       folio_ref_add(folio, count);
+                       if (count - ref_from_caller)
+                               folio_ref_add(folio, count - ref_from_caller);
+                       ref_from_caller = false;
                         if (in_range(vmf->address, addr, count * PAGE_SIZE))
                                 ret = VM_FAULT_NOPAGE;
                 }
@@ -3694,13 +3697,19 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
         if (count) {
                 set_pte_range(vmf, folio, page, count, addr);
                 *rss += count;
-               folio_ref_add(folio, count);
+               if (count - ref_from_caller)
+                       folio_ref_add(folio, count - ref_from_caller);
+               ref_from_caller = false;
                 if (in_range(vmf->address, addr, count * PAGE_SIZE))
                         ret = VM_FAULT_NOPAGE;
         }
  
         vmf->pte = old_ptep;
  
+       if (ref_from_caller)
+               /* Locked folios cannot get truncated. */
+               folio_ref_dec(folio);
+
         return ret;
  }


It would save at least a folio_ref_dec(), and in corner cases (only map a single page)
also a folio_ref_add().

-- 
Cheers

David / dhildenb


