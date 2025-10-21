Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B11CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 18:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF568E0003; Tue, 21 Oct 2025 14:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D67F8E0002; Tue, 21 Oct 2025 14:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C61B8E0003; Tue, 21 Oct 2025 14:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F186B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:23:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2DA8160661
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:23:42 +0000 (UTC)
X-FDA: 84022944684.12.8D75DF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2DAFAC000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:23:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UwXLTCDt;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761071020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBrbK9RKibKRT6qgoQrRXFUWF1+5GJaA4FIMjdaH3ww=;
	b=nC+UfLIZGGm/07bIz4rsNL1cIGWDzLVrfOtmdTl4YRlVWsv14PXEgjvgrx2OZy7P9lzsWg
	ZBmIX0HFgmG6qn5vgFCn008lb+Ok4/p4LmJO68rvXOYxcopOKiVSckVFVJj7oOcnWLszIS
	nyG7v/DdVOR9QV11RoyA6m0A5JuqfUQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UwXLTCDt;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761071020; a=rsa-sha256;
	cv=none;
	b=Lmg0ICcliJUvJq6MENnTpew3LPtDUU3cy+rFLjGuXHI/kTT3bdDNTtwfSkMHrg+8lQ1/Ve
	igp7Dzn1vUrGSCiK1FXihoFLb1gQq6msMlKDU5r8Ce6Nb4cpxX2efj8PvBRKqwqaRkQoXb
	HKS+6sApH5pXj0EnWwQULQ/cZqOMe+o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761071019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iBrbK9RKibKRT6qgoQrRXFUWF1+5GJaA4FIMjdaH3ww=;
	b=UwXLTCDtGW6Lgpb5vfnQL3/ulQg1OMu87lBPwC5dfrhPEBmuwLlNS0K4h0OhfOuN9QOlKT
	aavXb6HlBnWgL3Isd/kmn4Ya4FFOCM5d6ZHzlcq0e1VXqH+Ldr5YsIW0CRm/lGc87OY16/
	v46uitNNIV8HZUKavTX23uyZ6iNOMp4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-tdkTvFdHNruXTVT0b9wNcg-1; Tue, 21 Oct 2025 14:23:38 -0400
X-MC-Unique: tdkTvFdHNruXTVT0b9wNcg-1
X-Mimecast-MFC-AGG-ID: tdkTvFdHNruXTVT0b9wNcg_1761071017
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-471125c8bc1so65227065e9.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761071017; x=1761675817;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iBrbK9RKibKRT6qgoQrRXFUWF1+5GJaA4FIMjdaH3ww=;
        b=sWQCDLKtwMb1rNKrLcCzEMDAx1H6eHksRiR+dRXXPYiNbshk1yirsMdo9L5+VG4FlC
         qq0gl/xX/91OP4hkuisRzQBWYsl0vtjGN2XRfmVM2ERYvei83HGCP5/S7Ey/IrqQ2lJo
         YNUO9nzCGuhNbLmldFbvylzW17dSgPRRkZuKDkJDA64xF9ydqA7VwE/MLZ1el3T6+k8L
         UP4yAcrAWcysPocczOF0VbNGPZqDc6plxN0Dc9PGJ0XVmWUjv0RA3sDHVEFrruDHVwcT
         bocGjSIqE13g3a0al0dsroDOkn/mqm7BEZob9eVZrduwL6ri+CORmTdH5ehjFUCk0oDq
         p8qg==
X-Gm-Message-State: AOJu0Ywy95rNvl/DfEqEgGyKLRRo0egMdqKD/K9j+L8hcZM5M7+YmWE3
	eZdrz7Z9rvt6cxt5MWU1LaUsN79a90u7KPkKZB+h86LFFS5e9JTwJiI21a4Vj+c6p1U9s2y1TH0
	aP/RkaSWs038RA9osQrM6Rkvi18Cv+EbHZwep7GbkRL2O5jCQ5Mjt
X-Gm-Gg: ASbGncvuUWujmk2n4vfJkjRRYMVMItJqfOJFupmfpCe21rChTVEbGs5hK8iN89ty3lM
	YciXBOV8OwQi3aGOLkbnkDy9Q1tHBFgVy8FBsPo0QdHX0NoSKxRG4cZwJKGNGpRBLgKP9XLil+2
	fkSzlZ3T8sJwCxS4Qgu9tlgbyRa+3Lb3LrWp3KVtY8f4IrWNFJdWhyHHQknP341xwcYsgfWbdcS
	rwW6cQqhbdahoUt7+SX/76qy2rdlIblaLbcSyHc4fVi+ShhHoQWfxOiVn0JtMxfnPthln3+LRsJ
	Nb7W3sp9Uem0xpO+KFT78aPldRaKur3uFr4DbLvAKHwI1gwarn/IK1GG76DZoPrb92DcRMVtOAW
	S37jJvntIY3ZSl7MVVGiUiB6khOLRhdY=
X-Received: by 2002:a05:600c:3b03:b0:471:6f4:602a with SMTP id 5b1f17b1804b1-471179068f6mr127341095e9.23.1761071016816;
        Tue, 21 Oct 2025 11:23:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJsWV9wT/NI8q8P0pT3eUfqgv0//dEDo9NEYi5244ajP/UlPoMbe8met5vnilurQ0DtdZeDg==
X-Received: by 2002:a05:600c:3b03:b0:471:6f4:602a with SMTP id 5b1f17b1804b1-471179068f6mr127340965e9.23.1761071016383;
        Tue, 21 Oct 2025 11:23:36 -0700 (PDT)
Received: from [192.168.3.141] (p57a1af76.dip0.t-ipconnect.de. [87.161.175.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427e1be5d6csm21253402f8f.0.2025.10.21.11.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 11:23:35 -0700 (PDT)
Message-ID: <2961abe4-d0f7-4cac-8f0e-5db20fb5dfcb@redhat.com>
Date: Tue, 21 Oct 2025 20:23:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64: mte: Do not warn if the page is already tagged in
 copy_highpage()
To: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org,
 syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com,
 Will Deacon <will@kernel.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20251021181353.3842660-1-catalin.marinas@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021181353.3842660-1-catalin.marinas@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: n8BzdkG-hO0gsP57P2DBFVRYuomDlww4tWoRxztOvbI_1761071017
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2DAFAC000D
X-Stat-Signature: 9nawtw4c3yoehcmmhpyfxbbpcsden3g6
X-Rspam-User: 
X-HE-Tag: 1761071020-453908
X-HE-Meta: U2FsdGVkX1+70VPv35u7fwFtYGh1iyw3ca1DSv9v6in/SV/Fzaj9V4nnfShfH+R+EGBsM4wS3o+Vw/n2L772xXftQttYHzVKsz976msJHe8U6uPPbo37DCAVNPg33KIRBit01J6UCbI6XQMeNHyFtYNkyvEEqfuAHQVTxSM2OHwDh/ODU8kQ+dNzQy5fhDME8wYCV87nebEYszzdO969VP7qpikcsAHnUx0AUJOeiLwE35Nj2qYW0DBWw/S9vcpikRHt4HE92bx0HSwHJwGpPUGj9EMtI56BbQtq0CKeL+oUDYQXSxhg0VrifwI03yCKfUXjFb5/2b28b5TtLblzkTfKB1H5DgAkU+QdbMMgJQtqQINd2EA6QoBiwRWih5rckATQ/jr20PGnEpDE6HPs2o4/Mt9k9muLHx6LDb0YjhJ7PZ/qWc6UT1p1FENVetkPzGverv1041TOriagThfQvboogpGsxHbiMHTmoa0cx3XkvbnaAkBFKhWF1t9sa1SLRcl6GMHoZHojxTRyk4VexOM+k/pXit7d4ZLK+Ye72RiXZdBnonG7soQ06n1rCw+LAM8oSHUb4DNSElLh4tDB0+Wn4g+mt1ojdxi6XH6YzTECQFhQhtPFEorpxeQ/J6DHKFQAyc7ntOrDLLGzlAf4v5RhUoEN9sRK/kGOmvV7GOXocfIj+lpzecgTFobz/xHsUzSsEHoD5dJHdPM2gWMIp2GR4/e+4hmt6DWl8E5cesLhD4eWout5UeepGtaGNLyGdmkte4Miq7lWH1U05H6AqGVrvZpz1UBJlm/dyVJf6yilUbgT92DBcGsALzsh/S25FFOmF74ulcx7CJYroQpJ5ELhuI5JzaP4stG9Rau3TMAmK1MfCPMsL4Js9piDEkiAHouJOl0alollsO6r2F4DVhrpfOeb3pnclfHNnZQ0ShJeu4LwgIB0Yz+vtwsbPYVhSQps/gyMT0Coo1w0A2l
 yPz1K3UE
 UMhgsi7g/3NxlzPNIws80nply73OYVHejojWxhrINQiWjV6n4AoZORXhYJj6WHr8+XWlB7lTVoLZyq7cN/2xMZ/7yoVKWPRp/dJvuOJG6enNWOvA4fGX8Nn8t4lOmPnLuVrncJMTzLYR75Gq7NAICMJ6s101/n9Z1IzQMUunLYJC+rv7lDKJA7XHW5ItwUH9rSP6Z9ZXowYqbZrsMmIW+izEVzrYjpTWfW4vGx2fyKUYG7BqjD+CMZBWGd/vPgZFHCLQWFjPlWfBZ1mCSqd+jUJ0B+5Lm02ksf5QLvoQZcDCMKNjsz4ZWlxl2ZGFh3S3wVQrAJSgSkaCgLa4iMK4pgHJ+llVgwyRcB8lsPWmeihUsx2jnipnOYmLJfnNKqwe5nXSC8ehHZM07dDmWx5bhOV0R+5LTnWgR5TmYKB6YJJStaTxGplSunDUr6gFGRY8UEKDmvm5pW+pCcV4tpK2H0v1DnDrcEU6sGQAOa83RaDPX5J199nfJboGs+Hymtvmz145hNZya8iA4hqNbUw3O6wxPHtS4BCtj5afljLv58ahQl8nPg1Ht55H4kzLIUu53gfGibRNbbFY4iOOZRuS89lgTgnCnftVCT3xUi4wBE8KRzR6ZBZShlKBbkrjR4LkqOdmtkRJOXmlE4joKdDqAvygcTL56W6UvWtQu7tBQuIZsM5ZWB/jZu1YhgNCvZOL7vM9RI437cpxdBhjw+dovryOCLDlisfkNLeqpd4HE48g0cOHvn4k34u+3iu4Yd3Hu4RveaQdolZ+HBsI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 20:13, Catalin Marinas wrote:
> The arm64 copy_highpage() assumes that the destination page is newly
> allocated and not MTE-tagged (PG_mte_tagged unset) and warns
> accordingly. However, following commit 060913999d7a ("mm: migrate:
> support poisoned recover from migrate folio"), __folio_mc_copy() is
> called before __folio_migrate_mapping(). If the latter fails (-EAGAIN),
> the copy will be done again to the same destination page. Since
> copy_highpage() already set the PG_mte_tagged flag, this second copy
> will warn.
> 
> Replace the WARN_ON(page already tagged) in the arm64 copy_highpage()
> with a comment.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/68dda1ae.a00a0220.102ee.0065.GAE@google.com
> Cc: <stable@vger.kernel.org> # 6.12.x
> Cc: Will Deacon <will@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   arch/arm64/mm/copypage.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index a86c897017df..40749d0a385c 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -51,8 +51,13 @@ void copy_highpage(struct page *to, struct page *from)
>   		}
>   		folio_set_hugetlb_mte_tagged(dst);
>   	} else if (page_mte_tagged(from)) {
> -		/* It's a new page, shouldn't have been tagged yet */
> -		WARN_ON_ONCE(!try_page_mte_tagging(to));
> +		/*
> +		 * Most of the time it's a new page that shouldn't have been
> +		 * tagged yet. However, folio migration can end up reusing the
> +		 * same page without untagging it. Ignore the warning if the
> +		 * page is already tagged.
> +		 */
> +		try_page_mte_tagging(to);
>   
>   		mte_copy_page_tags(kto, kfrom);
>   		set_page_mte_tagged(to);
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


