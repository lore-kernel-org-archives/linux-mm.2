Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26AC6D46627
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89FC16B00CB; Thu, 15 Jan 2026 16:40:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877A16B00CC; Thu, 15 Jan 2026 16:40:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7763D6B00CE; Thu, 15 Jan 2026 16:40:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 648E66B00CB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:40:33 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1175BB9B89
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:40:33 +0000 (UTC)
X-FDA: 84335517546.21.A30DEB6
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 35FE040015
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:40:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tu2MC55W;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768513231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NEsY4l4MT9Q6cBqefYtZtOy3s+dR+V7JNDYTBav7MA=;
	b=fxsYnu/benB+qBC8twIiQV8x4I0R7CxA0PxflVQMeJ7D12Ah1eAKRdBqE8wy7O3JqFj19B
	WhzlqhTErz1WweGYGH7aERhUynHPIeqmp7usAK+TixM65OeOCOeV7tcfjQNg4RbcQ36MrL
	YuFcha4fHA6YNxwrBjuxxJFhOKnYSWc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tu2MC55W;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768513231; a=rsa-sha256;
	cv=none;
	b=q33UWZ+M+lQ7ysxf8cV/cbsGOX3KSDEf01CiAMr+aa5qsiKKQOSx0ai/g2tz3ZZqrh/5w9
	Rpf6eYfLchpz7x0K3gHVV/QZmQY4Q1vcf29OZ1GgDY6pszvSwzHAIHo5iWWekS0lcvBwki
	8bAV0+TRRiQmu2nZRjFasHRHdTjC/YI=
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-940c539de8fso896017241.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768513230; x=1769118030; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=4NEsY4l4MT9Q6cBqefYtZtOy3s+dR+V7JNDYTBav7MA=;
        b=Tu2MC55WMLw3jWexEimgvwSXySXr7ipnTDSVxMqsya+4E12zdZfG7MWxkAQS9qKllu
         yMUiJ8o0UHJwRGM0ST2uxEadQoNE+1lN2qnP9o32vigVSIVonWlGIEQSoU4PzqqG0lp4
         S72Paby/JSkYU9AdtczRINIoIZFF4jt0QelsqhUbzWksdaSGbAzKWNgSOEgwoMUUDEzN
         cPjxcL+XetW0M++pwiZoK5453SWHv6SH96gXNnhWg13UtS1yWDpvAAW4096T8BAspNFG
         rzVGbJeWMhjnRoOGbjB0CsDGP4mXnV6UTePd4l+OG/envXcx1sqaNrZ0LTJcgOCJxBoo
         yEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768513230; x=1769118030;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4NEsY4l4MT9Q6cBqefYtZtOy3s+dR+V7JNDYTBav7MA=;
        b=jaowdy8ifoEIaEO9+MUaCvfWP4xpHZT3jzZEo6SakkICShldSAKvCjdHYeatDYDdCS
         cfSBZ8ZkLkYIW87B9byRp9Iluk9Wnub9zG4733aGpGSRyLjKK5/Vlyi5yuFKGtRuU0CU
         O0BWWL+CH/mhnU+qySVbQgrwgjqLdfVaBzElqBqocZAdFTyXFg9ooHbzuP7PQ7tQD/MC
         RjFqS8NAX3EbjSOSxDoy6QZJ2c9vvOIkla18EP85Bsc4bluYXOQe5otqsaS3vOeqgk7G
         B8cwUWH9LlU/WDxStPa+rA+2NhomY1+H2SkaIqH/nw4UCsWOvuC61rbbLvVuxb7OJNO6
         bqcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUEY9CLEQYZCPmtPn/5uXTt2wnhSyv/HGeiW9DM353+cyOTyrwkMVo2+0ZzbMYYw+WM33ZkJU2gA==@kvack.org
X-Gm-Message-State: AOJu0Yyqa2a1V+hPO/cd60cP80VC8jMotDeoxu7TzRYZI8U+tVKch6Mb
	TN3UJ1TzSrzb9TuT85biqX5cb67spJwE51yc9TdmdrvJG7P7WvL7d1PAvaGYgvAyT/gPIQ4Z53b
	kHj2rfdfDfzj0K4owv3KCTqQseG2pxflFf3y/iIZD
X-Gm-Gg: AY/fxX7i/ZB8tzvsxTS4QhWBOIOGlDcRpoUr5WF+vnI3vySfoKsOiZoQTklWn/sJqq7
	ZqzGgEv4y9pxjljzScIKyoSFl4Oxw1zt36RLx23MsGdUQyTeDC+CZj6kwF177KhhqP6Duzd/1R/
	e5PY3+u3daDtAExnVoCGoNbFeUkPVNhxMW4Xfj4l1jrzAIZVXbnP2fLXaoaNS6Y4ZTnz4u2popH
	zaXSEddBmNnw9HqIwckDZQioub7PmSeh+6jIlKj+P6ZWtesotRMrY2WsHnD9c8e/L/J/PP3VzoI
	QMjU7C/4KIC6nt7ujmpJylWVM5H77XHbWjeu
X-Received: by 2002:a05:6102:947:b0:5db:cec7:810b with SMTP id
 ada2fe7eead31-5f1a556dabcmr465899137.29.1768513229577; Thu, 15 Jan 2026
 13:40:29 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:40:28 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:40:28 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260114134510.1835-3-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-3-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 13:40:28 -0800
X-Gm-Features: AZwV_Qj-0gm6vYHJJ3iH96aBpuGEWZXgwnMiQkeNvlZWuDVc-Nc0GygCth2Cvyc
Message-ID: <CAEvNRgGrpv5h04s+btubhUFHo=d6mBFbr2BVrMt=bWuWOztdJQ@mail.gmail.com>
Subject: Re: [PATCH v9 02/13] mm/gup: drop secretmem optimization from gup_fast_folio_allowed
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 35FE040015
X-Stat-Signature: s7k9n1dsx349oztatsjbgtkucbnst4eo
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768513231-365119
X-HE-Meta: U2FsdGVkX1+RsFRf5xm4YWat/cj1KZvk3gcDug2F06IFYYdnJzJ/HHTPG6OkmuS9VABxUEBsaskGnfNZhjN/1waKIdEUfZ7T/A8XjB7z8ER4JB0idzYdtbpbTnBOY1e/nQi5mhyE7EaCRsQvBVIgsswJTf9nqtiJVdBDuLKPZ0hg//JjuAVK910nib0HS3LsAY59cZN+HmRmCORiV0KRmqUs7/WTdcHfM8ZPUfAdK3WjYlvgcsDpunmxTMrWNWEBlEHwSORQi5GmoJfrxEkdtEk2VO/emAnmUZcAv46m1FYN9gHHlELpfnRy5q8yMapPvEKfVcuPK39jBBMjICJDSibiIn3kph7tnLtIqsOUrh+voG15SeHPw99iHpkrORpZs02IeCLr2fjGdUUi8vNyrj7MPt/WpErI43s/7qHAfg4cW27UB0x0/pbrQQgmPQUmaeIqwtSq3aIOI9YN6UJEZgQ/ayNMGYf2KrOkqrdhv9G9G/Ewi2W320hP5IGCMwr4tuqm0NqySrtLnut8J0AOjJHmSidDVlTv1ABFca04LRL5bvDiZ1gTjzQ51q6dKT1rwvxIHaWWymbp+Jr4B2Lsz1NNNtmniDpcsikKXqWaFfV3BixYLm/f8JMr3hc+6ppKN+KTh8u6SSmEoZkQBHJ0EgeluX3nI3q51WjoT7x+FUYEhnxZ+wZy23f8m0KQ/Pyn6qWNwlotyzonpeX3Ve6nfWTeEGOAZgJyZcqEMXiNsrC3qcczd9qgOCtQuG+UTc72LpOZiSiVdLPsHfTmQDU899ga3ocPdS1+qAam/EC3I6J8Imouwo5+NQIpGDjl7e5Gmji1RNiXT81zd9bhNzaPUe7U4O6BY2crQcDz4j1r6A/afUQqqmDsM0Gwnkn1luPWYuOr+2MKYgPD5h1DBNK4OwQhOHCpDU8ioe/jOqSjaNdvyBi+j6BZPIvz7mtZnFv3Ra1K3FmjdFo4lfVVMjK
 IW9QOOaM
 yGt3t1GA3m3rCgUGMX0Pwgr5dvXDDZ3b1o1aZ4jmZIRqu7Y9a3j6175mSYmupDE3ASX6fueDT6rps2KxmwsTYfGesBM3EFkMc4WL7Msu3glje6dLjkUepx1a8Pc/z1EJgmv1urtBZDYV2BUKvZislDZ1pwN/iO5VORjAbCXzEmEAZWIVz6pJTS6GtsiMaqpSSk7rM6pKs/akwT6+HoVrKtLhw32tcqsCt1ptgbxvgwY0GzL2nvyb7F9ZKQhvCSvaXqlCN+1DzLxw1cYgTOe8XIVIk6DsbDkz0KBSOhrLOHuQ6KRMsHCyXsOL4PWMWI9xtmeaUWQF+IozJgpWW80E+rnUmrMuxIiW/WVGEasgttGqENveoumSA4h8J5/wfoxNitbp0KMlmYB0p2cZYDWkB2xJqkqvnDTzlB7YfC7pCKyA3Ref4knGJw4dyx/g/8rwqdVptP27S64ttPvgYaZ2bQCBiWe0pw5ecI0H8E2MOCjrFV0t7g2sj2ojV4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Patrick Roy <patrick.roy@linux.dev>
>
> This drops an optimization in gup_fast_folio_allowed() where
> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
> by default"), so the secretmem check did not actually end up elided in
> most cases anymore anyway.
>
> This is in preparation of the generalization of handling mappings where
> direct map entries of folios are set to not present.  Currently,
> mappings that match this description are secretmem mappings
> (memfd_secret()).  Later, some guest_memfd configurations will also fall
> into this category.
>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  mm/gup.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 95d948c8e86c..9cad53acbc99 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2739,7 +2739,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  {
>  	bool reject_file_backed = false;
>  	struct address_space *mapping;
> -	bool check_secretmem = false;
>  	unsigned long mapping_flags;
>
>  	/*
> @@ -2751,14 +2750,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)

Copying some lines the diff didn't contain:

	/*
	 * If we aren't pinning then no problematic write can occur. A long term
	 * pin is the most egregious case so this is the one we disallow.
	 */
	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))

If we're pinning, can we already return true here? IIUC this function
is passed a folio that is file-backed, and the check if (!mapping) is
just there to catch the case where the mapping got truncated.

Or should we wait for the check where the mapping got truncated? If so,
then maybe we can move this "are we pinning" check to after this check
and remove the reject_file_backed variable?

	/*
	 * The mapping may have been truncated, in any case we cannot determine
	 * if this mapping is safe - fall back to slow path to determine how to
	 * proceed.
	 */
	if (!mapping)
		return false;


>  		reject_file_backed = true;
>
>  	/* We hold a folio reference, so we can safely access folio fields. */
> -
> -	/* secretmem folios are always order-0 folios. */
> -	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
> -		check_secretmem = true;
> -
> -	if (!reject_file_backed && !check_secretmem)
> -		return true;
> -
>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>  		return false;
>
> @@ -2800,7 +2791,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  	 * At this point, we know the mapping is non-null and points to an
>  	 * address_space object.
>  	 */
> -	if (check_secretmem && secretmem_mapping(mapping))
> +	if (secretmem_mapping(mapping))
>  		return false;
>  	/* The only remaining allowed file system is shmem. */
>  	return !reject_file_backed || shmem_mapping(mapping);
> --
> 2.50.1

