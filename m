Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2389ACA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B4E98E001C; Mon, 25 Aug 2025 08:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DFF8E0001; Mon, 25 Aug 2025 08:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6ED8E001C; Mon, 25 Aug 2025 08:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6B68E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:31:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C527084025
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:31:09 +0000 (UTC)
X-FDA: 83815214658.09.23948A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4CFF6180012
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:31:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bnynJcsI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756125067; a=rsa-sha256;
	cv=none;
	b=FByQ137hp8PtcLs1dq34Ni+ZtA3B5N8+0oWSzOGDkxh+JLb4FCAPtcG0cuD/Xpjkn9dBq+
	obXx6xzvjmvePrfNsfx3s29UM4G8EnLNEhaUlqrKtNTEQL8wZZ6sNrysOhqOgOCEn5mT9q
	utF2mn/CDxkC5ZyJBBkoZ3A1sK/EFxQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bnynJcsI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756125067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48cMTSslcB0ziBS4SAU+081Ps38xL0HjCpNxL+9nzl0=;
	b=MgUuPfssYUQw9giEn8vOQfnBJuA6uVIL9qgI5F05JOmpLS6AgIs0acoTEJt+3lTKnkP8Wu
	J5KfBLu9aTZOYKUlUhv5zE+ndQRCWVsZDnTk32bg9LNbyX5T2Or5d872Ta5yrxyNV4+5wH
	hxBFSAbGVfDmamZLtE1L5zrMBZAoo3E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756125066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=48cMTSslcB0ziBS4SAU+081Ps38xL0HjCpNxL+9nzl0=;
	b=bnynJcsIIlGvpV5g4BJqvnLuZVKNuU6i/DGv4o0HpTle+UI+1UnzSJtz2bSVzgTEEdmrgV
	ekEK7ZxGtvGDgTg+dPBUjkdJ5TYMPPq/lcIwmQkjq2d78QHLNCtEGcRFwdUcT9Pu116vE9
	JoNW2j3oEciIbqszydEYJYlSebIG/cA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-TPTqCAcAMRatOC_LwmqnYQ-1; Mon, 25 Aug 2025 08:31:05 -0400
X-MC-Unique: TPTqCAcAMRatOC_LwmqnYQ-1
X-Mimecast-MFC-AGG-ID: TPTqCAcAMRatOC_LwmqnYQ_1756125064
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3c380aa1ac0so1608548f8f.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:31:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756125064; x=1756729864;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=48cMTSslcB0ziBS4SAU+081Ps38xL0HjCpNxL+9nzl0=;
        b=Swm72twUTks80gOF3kn1rJh9jwMQzhHze3eAaU0huYkDnqZkF6gpaaMn9D/eJzq7JJ
         ayF5Oak3XABPL7fcjtm8rgqpoCanurD1WLKrsEbF/4KP3/mBRSGzj8kbpAX3wsbku9xz
         si2ghrVgecW/ZeDyToRuuVBOFnb6Q6qRjr20Prf1BhyILi5QWxMXwIS4WVcy3TMSZtCj
         UdQkT8SyL8/CkZOqVWoQY0tvt+46njMViJ5ytDfmCD6AtkVjfR4UKZtJQM0BiqcLrSM6
         itRHpdZc5lp3eMjeOeDXq6igmxL84aA3Jt7Xdl9Wp2kNia4Q4MkGuFmaw1DhISquBVuB
         hYFQ==
X-Gm-Message-State: AOJu0YxoUrHC5NTuwQM/CeGMIEA4gbdlwuMnNmGezrMEErwrVBEg1iWs
	8ErSDQGBfdm6xg0oshcW8EjVndGLbYrjJS3SBXWpIZ6YOy4GJBtuZVuRlm74f5a8tnitvyj2ZYz
	DnsZUyXYn5+W3IsKNt0li2KUp6lQkZWEk69GpDLP/0FL3iIeNhlgKFAh3YoXg
X-Gm-Gg: ASbGncv4YoWdJSeP4e6y+H8NOeFW4qW95n/cPF7Uaeo/IidtXPOQsZxXdthaslyNI3q
	XANpgn3/uIgKhJfZkH/E+MVyphhgttu15hQ1Zp95TCe5oJ8jZ2XB1huBrR4ANzupM9RpHZDga+m
	J4CqSSgiarbtGUfbhSJdgFfuM1N+lTZgoXcWl+FMIJvj5MhdaG0r4f5mGSEF2DLy8W958R4AnhV
	x5zIM027nXHhSuhSPdpf0jZBCSVyxB1d39eG/mflqVAn3+EOH2w9CvIIkZbn5e5rwzzWI1NUKhm
	spOeiKC/sWX7Pad6LXSKBoNpBS26ypblpM51NA1H9tLZRMWhp0l9a7aeRMFBtu7z3ysrkyn/TZ5
	Km8O8NUguPU9gj5C6jRXVcPWoqBTsaBk+CuNkeBUSiVOO7K0BbwGnIyCkNDxb9mG+PXI=
X-Received: by 2002:a05:6000:40dc:b0:3c9:469d:c087 with SMTP id ffacd0b85a97d-3c9469dc445mr3271490f8f.25.1756125063880;
        Mon, 25 Aug 2025 05:31:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvPKmvGXwFDJWJm849Yt5wXoDEn2seO+ZEF1/8AbV43w5FimZ47X7SqR0IFDLk15EedM+8Mg==
X-Received: by 2002:a05:6000:40dc:b0:3c9:469d:c087 with SMTP id ffacd0b85a97d-3c9469dc445mr3271446f8f.25.1756125063406;
        Mon, 25 Aug 2025 05:31:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b575929a0sm106632785e9.25.2025.08.25.05.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 05:31:02 -0700 (PDT)
Message-ID: <923b279c-de33-44dd-a923-2959afad8626@redhat.com>
Date: Mon, 25 Aug 2025 14:31:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/11] mm/memory: convert print_bad_pte() to
 print_bad_page_map()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, xen-devel@lists.xenproject.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
 Lance Yang <lance.yang@linux.dev>
References: <20250811112631.759341-1-david@redhat.com>
 <20250811112631.759341-9-david@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250811112631.759341-9-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1tfgrEZ80J5sB7pZvvImCtDnXFpVz35rxuVP82td2nY_1756125064
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CFF6180012
X-Stat-Signature: 4odwcabkbnkmpatcu5q7igh684qngujn
X-HE-Tag: 1756125067-84350
X-HE-Meta: U2FsdGVkX1907HVwGmlC33ZmoBFpfbbyet7U1Atp9W5czrR8tkzFKyu7EgBJ4FPjCEHcN3mbvaAbOIZGeEXrLzsChFfwWXE4gIrkBad5K7cCy7bIOFiD77o6vmHbszq3x9PlhuZCWz2dhLEqhOSesgmMRRSh3eOSu/4nfd4FgpSNFzStWWFyubIjkKFA6APnvwHwLfmYFzoNuu2/G13ddKlQcm8l6agBFoDalPZiLilmHfZGjeDISewfk3mL/EpoG6XY3jaHvCi3TVndVxR5gAAg9iz72t8JY1DaakoAK4sQ91fn6cPkOCEViOLphcSO5VUpyFGJWz4SjiUVF+x6YQv6cxtGNO/40AmpQUS8D8zfvnqFDq/lX8vnbH8x1eBp1wE4eSzQmvkACcSHlLyRzUf4vGka/LqKJQYwMFY4RnCxphRTjH+J09KEEeLuGAmEZsVGS26n5KChQDsuAWrmFEmbpcpR0VjEwCf3h1ILxbGaTI7llQ+GAKnOgoGlrUPVK2IGOyquDhhjabpOvkjLBop7DGrW0Nc7BhHXRlnmMvbvQmWSha4h/hSi+tbqpk5KySRsSibyqfSyqgdEGb8PXwp0YQagN2v3uOpSrX1iyDKMZ8A0TEv5675M4+PTqXAuZRBy503AAIeYmtPS3XFCUDzMWE59VG1jwNjFOSI5XVaTkqAc+AnoZ1FHc+9I5yF7cqEDNDMroDkF8iLPhABiSfwHaNzUc/ykspa8L5LWjIOLQqwJMKYrogCNS2nzozvMKcwXwc+CWy3kcRhVF5bEqR/nrwvhfPiJuVjtF5Ag+D03x0Rf8zgbUCc/aUgkpI7rkJXhBEx2gvG543jOKJhpF8HeocyW/rcT4fYk1MIhuMn/Sea5r2R/rEc1Grc3qJSit9XIVoQFvpleV8QprSEbfTJhaf74Fgnll1IgSOyoWQn4jxJgI2gyBJzzWVoC/HW3bunqrgDjRvY5Y/5wvqG
 YaWuzPZm
 XQzLgvu4CRJyo/lr0S6BEX8+dT22Xo8GabO1VKbywEQeQuw8gCp/AIyR0GpprQqLFzhKcqQQfHlUhA/tkt47iD0g6+QMy/B3fml0s8GaBy0FZs+ce9tlUIdzKDe05MGJSliac5ZM2+DYXP7kxidaRYtpE/kirLk0imq/GRBFd1/JKpKp16+IgMOBPK/k2wznh9YoxVM/xMJFopGwrq83955s0aJ5oEMJlj+e7A4ej79nvApzO3lQwFFCmsl/uS3qXtOCDcFMq1qZtpjIEIQNsEK55XSkM49qjH9De67PIdZXgqQpLsodGFn9UGSvR0wqTlSUSNWw6wZYWw9tm4Oj5uVzYLmzVnQHG88UszK70j9QnDtN2wyPPHFe5//o5sGSbhQNsbppwmfV1idj9BYYy1+Zbs1DvU4iNqX/MmxBz/cWeBs50xrdnctMDpt+EvpNHCpThEOVidDXtHMy31sshOm5rlTzb2ZW2t1mJXGNWCnYktkQL44q8Ib0Eyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 13:26, David Hildenbrand wrote:
> print_bad_pte() looks like something that should actually be a WARN
> or similar, but historically it apparently has proven to be useful to
> detect corruption of page tables even on production systems -- report
> the issue and keep the system running to make it easier to actually detect
> what is going wrong (e.g., multiple such messages might shed a light).
> 
> As we want to unify vm_normal_page_*() handling for PTE/PMD/PUD, we'll have
> to take care of print_bad_pte() as well.
> 
> Let's prepare for using print_bad_pte() also for non-PTEs by adjusting the
> implementation and renaming the function to print_bad_page_map().
> Provide print_bad_pte() as a simple wrapper.
> 
> Document the implicit locking requirements for the page table re-walk.
> 
> To make the function a bit more readable, factor out the ratelimit check
> into is_bad_page_map_ratelimited() and place the printing of page
> table content into __print_bad_page_map_pgtable(). We'll now dump
> information from each level in a single line, and just stop the table
> walk once we hit something that is not a present page table.
> 
> The report will now look something like (dumping pgd to pmd values):
> 
> [   77.943408] BUG: Bad page map in process XXX  pte:80000001233f5867
> [   77.944077] addr:00007fd84bb1c000 vm_flags:08100071 anon_vma: ...
> [   77.945186] pgd:10a89f067 p4d:10a89f067 pud:10e5a2067 pmd:105327067
> 
> Not using pgdp_get(), because that does not work properly on some arm
> configs where pgd_t is an array. Note that we are dumping all levels
> even when levels are folded for simplicity.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   include/linux/pgtable.h |  19 ++++++++
>   mm/memory.c             | 104 ++++++++++++++++++++++++++++++++--------
>   2 files changed, 103 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index bff5c4241bf2e..33c84b38b7ec6 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1966,6 +1966,25 @@ enum pgtable_level {
>   	PGTABLE_LEVEL_PGD,
>   };
>   
> +static inline const char *pgtable_level_to_str(enum pgtable_level level)
> +{
> +	switch (level) {
> +	case PGTABLE_LEVEL_PTE:
> +		return "pte";
> +	case PGTABLE_LEVEL_PMD:
> +		return "pmd";
> +	case PGTABLE_LEVEL_PUD:
> +		return "pud";
> +	case PGTABLE_LEVEL_P4D:
> +		return "p4d";
> +	case PGTABLE_LEVEL_PGD:
> +		return "pgd";
> +	default:
> +		VM_WARN_ON_ONCE(1);
> +		return "unknown";
> +	}
> +}

One kernel config doesn't like the VM_WARN_ON_ONCE here, and I don't think we
really need it. @Andrew can you squash:

 From 0b8f6cdfe2c9d96393e7da1772e82048e096a903 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Mon, 25 Aug 2025 14:25:59 +0200
Subject: [PATCH] fixup: mm/memory: convert print_bad_pte() to
  print_bad_page_map()

Let's just drop the warning, it's highly unlikely that we ever run into
this, and if so, there is serious stuff going wrong elsewhere.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  include/linux/pgtable.h | 1 -
  1 file changed, 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 9f0329d45b1e1..94249e671a7e8 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1997,7 +1997,6 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
  	case PGTABLE_LEVEL_PGD:
  		return "pgd";
  	default:
-		VM_WARN_ON_ONCE(1);
  		return "unknown";
  	}
  }
-- 
2.50.1


-- 
Cheers

David / dhildenb


