Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8114FCAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDFB08E000F; Tue, 23 Sep 2025 04:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7158E0001; Tue, 23 Sep 2025 04:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7928E000F; Tue, 23 Sep 2025 04:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4C138E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:25:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 660531DF2DE
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:25:11 +0000 (UTC)
X-FDA: 83919830022.28.3E0D1FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id F173340002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:25:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N7sSa4VW;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758615909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x97u53GTt2R3N2Pgwrhc5uqxe/T+rOMKjkl/kO4sN+M=;
	b=0plNogqJRfM96V9IpCxcbj7WhSsVdzvLYUlzk4pzXsODKOZBx3z7oxT2se5tlDbrv9qlG2
	AFXuHs2LuaGtSvgDHYkv4hm6aT3GngmHtweuCL8hcRo7sAEwoFV2nsC2SLgnpnumws2hzy
	RpKsOkagfr83nj1bPI4retS1r9VhZPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758615909; a=rsa-sha256;
	cv=none;
	b=Z89pu0agtnc9o38T7PxZUbjo+YMFLSecALHW2pAgZXZT2HsL8VTpVMsf0SnfmBgOJe0O7l
	JOlqTSZstwMLJpZkc7Nzn7tbrjefifkyRD4OOnSyodCdYrlld+xrPw4zXg7i64rzvp1c0u
	TMhr74ne3GHhAREPFcwUSEka6h0Ib98=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N7sSa4VW;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758615908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x97u53GTt2R3N2Pgwrhc5uqxe/T+rOMKjkl/kO4sN+M=;
	b=N7sSa4VW8et4QpF05QRv+1M7iB5DHWvfEP/htfHRJAyAeu+KmazvU7hyc+JxN3T0SM7KYL
	JElpFUXG8bmjC6MHmvUSnhI3bg2JUyHMj/HEVN3HGZG99fofc1cY3tn21s0z7o2MKwxl+v
	N7/9Rs+Nj6NKRop/bKfMDK6LGe4KDg8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-fFq9A8nlMn6xnIUUsnIrDg-1; Tue, 23 Sep 2025 04:25:07 -0400
X-MC-Unique: fFq9A8nlMn6xnIUUsnIrDg-1
X-Mimecast-MFC-AGG-ID: fFq9A8nlMn6xnIUUsnIrDg_1758615906
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee888281c3so1755083f8f.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758615906; x=1759220706;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x97u53GTt2R3N2Pgwrhc5uqxe/T+rOMKjkl/kO4sN+M=;
        b=F2uxaOpnIhWgW3sMC0S+Y4eiIuCeZjwDcugya6xq+5hBtZgGlw+NmEHOGFMzg7AmLR
         HiRAwbIv92TA0x2vXbEZcEjjo8X+m5iVmEkozGUazyQ9lY5K5b30J5Rs5HGdnbtupIjd
         8uJv03RTL/H6cQhOZVydzNJtb4+MNdVqzaznmiEaG2MXJThbH+g/Gv9P3O7/tENY7gVT
         /UI9s4QIKFKnD2BwNqdIMqyImSiKNewdZsr+2bKN/aTvsbiJfLEu7dncMXMGSUa4Xk5y
         qFSATwQbCQ3EQ9pAYU9otbzb5sAWHf+crxmmHfJCsQjM2wvmug0UdCaW9BYgEu8N0sty
         XWgg==
X-Forwarded-Encrypted: i=1; AJvYcCUZu13BTN4ArmusXQE/Kmp76pRyYjnwGJHzELMa31sz/2IXxdZ8XILGstXXrD1HUuWO0e07rSF/7A==@kvack.org
X-Gm-Message-State: AOJu0Yxpyf8oci3Ryphknm2c0PzDcpeaaPP1kTR34iA/x6oSdbu1D2BL
	hktBvieUx0Nb1exxJWsB0/B0Vg2z/ZBO7qm5bAoDhYTi/iezL3mMObbcpett6Q3WzOnIbIMCBl3
	+XcuEzFInZIknB8eJ2SSIffjSNgm2wQjzTV68s1FCFOffaIotS0gF
X-Gm-Gg: ASbGncuDUgmtM5vev1Ej0AyLNs3mB5uMmuWOSTauc/5z6lcfut9cNDJ4WhJKp5lVnuL
	Qg+nGjiV4bmUkT5cpZVHFRyZnfXohgSZUyB74liEBPOpYPNiku+Pcd+d9340BAXKM70y6Kp6nKc
	fN32wVZqjjWxAz/VE38fY+KDuYZkQYmc1X5syx1nxOKGdS0SwYsQ3teIezM7Uk7XqCbZUmc25zX
	owqcH5lY4eKFmA6LKQZJWt9yt0Yzr8bm8UlHV1dcbM/H5iMX8OlFsykO+8AT45JjpAKEk6vyntE
	TMVHyB8a4yZjTvIQjAf/EY6bwBI9xLExvxIw8a/DLfa4zmeKRE0UzBjE9HVpRqocg6d8/c6ySso
	PRPvFOelx6j5IpB1L/ewoql4zDWJMwNJh6CaXG9MYL6r1YihYhpVej0t2ELqilpJYZA==
X-Received: by 2002:a5d:5f92:0:b0:3f9:6657:d05 with SMTP id ffacd0b85a97d-405c551a369mr1243706f8f.12.1758615905713;
        Tue, 23 Sep 2025 01:25:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECy5ZyUMi86SkAmY3UUEpYt+kdXd66GExl/asl5sc/9lT72Pm81eO5xU3dy52ferMCYaK/cg==
X-Received: by 2002:a5d:5f92:0:b0:3f9:6657:d05 with SMTP id ffacd0b85a97d-405c551a369mr1243681f8f.12.1758615905225;
        Tue, 23 Sep 2025 01:25:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e1ce0f019sm10938525e9.0.2025.09.23.01.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 01:25:04 -0700 (PDT)
Message-ID: <9688edb5-f474-49a4-ac84-0702ed3af3a2@redhat.com>
Date: Tue, 23 Sep 2025 10:25:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH linux-next v3 4/6] ksm: make ksm_process_profit available
 on CONFIG_PROCFS=n
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, chengming.zhou@linux.dev, muchun.song@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
References: <20250921231334093OILrn169i655S8Pe0KMUC@zte.com.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250921231334093OILrn169i655S8Pe0KMUC@zte.com.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D5-g91ZBg6wRYaz_HrpKxFeasQUW1_WhBOzuQcTCnZ4_1758615906
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ik7gi4xtgcjmnduofywinye9sj3zf1na
X-Rspamd-Queue-Id: F173340002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758615908-477355
X-HE-Meta: U2FsdGVkX19ZW4krI87Dp+Qy4W674f7qwRDdnsAVaVa2W1ttwFplR6FGsWGNI0btj2A/eIkO+yWp/9vIBjfcV8kT13ki/dCz6TawkKdwVYTtNyWjT+3jikFAd0vwOr6VMgydxTmdWO5aLEc4DdhU+UZ4ulAFCUYZ5nm7E6YeBHweRDqgh4sfYFHm7uEUuWV7r5QQ09mFI/xzvQ5TIB1FWe8wHhcnR4JF0HzYbfGH00lR3CJYOzG8ZC4YBOrVUs0siAA8au00b7bxN6BgYkV/Yl1PAL5N88UFwflsigHfoFoVk6e8aggE9sXGwH9SfHZM8YJGD+31sPxprMSzEJotx+l0B1Axrl4x3eE8jjc4ArlCo+juAtF12tQEcWjq0zH/3Z1K1qCAwGQPCH1Pfub4jYgb9sStmSY8NNJ7szjibBiOSpY2Rwbe7z9gAzBnRnpltILPBd2skIP18jr6QLFSr3hsyfhqoBL/mW6ozr4VzZd/WlMY0Z+wL8NKyGzmp7+8oeZY0Am4OWaozoyO1CLhI2kxCbSz3kJsvf+xHJJ7M6nydqvDdpm0TEMmSoOoaagGmOduF3Av5EfXgPgaJCTjChRt3F2Bg5jHPYPt6gkPxPimFPsEXFz407bsknElmoT/URk1W/x1lueodll14pQm9cO0jFrPRfS7JtliSnzx8gvkYK8vNEV/qPYmKBVQyHCcjsUgttlrOf9pKU/mT8zKMQuLHJ+jxbPYWpoVect7UR/kIgN6m2O+SVIgDprxxS3kMPd+s+wAjkB5KUIbXcBNWrOjHmFEgAKoyTP50iTgUNywFYmoSBDkh0p8fXJEk1tWx9fWUskbfAp8X/wiw8HPIJrFIXrxv5X4jO/tCvV8IE3c2NyIOx975C+4WJ0r9MrPvRzDAR5fHaPMevFZVjs46XP16uEPuoU3qDn+Vx4JYb+TpL4NOotncHV2VEX6r37Bpnx/GInCCAs9/Iu3hv+
 jZVvKU1b
 YPmMPCVEbd8vQeCr/Iq8lejQMYI7vYJCSZV0uOo9GL3jk4euVL/1xr6ALt7mx8EtrQcoHYlN5UJduIzckkYwaDK787msk9fu/VXBpk3xkgbDYBdTCfp44diSKETnnHBfS9PRPwYQGzDZfK8pZa3KKBPDNF0z/a3Ifi64vhGMxjntYzlxUFfV4LYpYg0Ul45V9eLoYY0EOyo9D8Jel3DISkJgrXhVSLhNql86JAHmyeKqkY1F4/tlwRN4tx9rzyVf/UZfgkOQo7VcqsOoqKBNlfaeiJ/zc1HtEqpeQqvxGAJN/Q6xiq1c18i7ZcKLaorZdbjC5Wwn5pMpVNTgNBbxjw7jls0GR89wvaem+xUMr0nDjem0cV9np4qtEjpGin1DhGxU6S3ipLIJcwMpIdZRURV5XDDansjahB2Lwgz3+JdRfj6ALopOwiWPm1I7Iy+TG+0R6OdGbam9z3S59oXVUs6sVZIfDR6x2BrkmSrJR2rMoUJSfpexpFMwqb1OHprK08q9lAN46x2/F5XTkOFFLcKrP2a5Ahbty8Br9jcZrjmdPXcl/dZR+y8z9EgR/NgTCK0bHugQVc20V6DjE4c3VjXbDIlkOvYJLo9zyz0ymec+2Iu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.09.25 17:13, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> This remove the restriction CONFIG_PROCFS=y for the heler function

s/heler/helper.

> ksm_process_profit(), then we can use it for the later patches on
> CONFIG_PROCFS=n.


Better to something like this:

"Let's provide ksm_process_profit() also without CONFIG_PROCFS so we can 
use it from memcg code next."

?

> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/all/202509142046.QatEaTQV-lkp@intel.com/

Both tags should be dropped as there is nothing fixed here.

> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>   mm/ksm.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index e49f4b86ffb0..a68d4b37b503 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3282,7 +3282,6 @@ static void wait_while_offlining(void)
>   }
>   #endif /* CONFIG_MEMORY_HOTREMOVE */
> 
> -#ifdef CONFIG_PROC_FS
>   /*
>    * The process is mergeable only if any VMA is currently
>    * applicable to KSM.
> @@ -3307,7 +3306,6 @@ long ksm_process_profit(struct mm_struct *mm)
>   	return (long)(mm->ksm_merging_pages + mm_ksm_zero_pages(mm)) * PAGE_SIZE -
>   		mm->ksm_rmap_items * sizeof(struct ksm_rmap_item);
>   }
> -#endif /* CONFIG_PROC_FS */
> 
>   #ifdef CONFIG_MEMCG
>   struct memcg_ksm_stat {


-- 
Cheers

David / dhildenb


