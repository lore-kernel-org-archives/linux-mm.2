Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E33AC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59476B0128; Mon, 11 Aug 2025 04:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B313D6B0129; Mon, 11 Aug 2025 04:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1FB06B012A; Mon, 11 Aug 2025 04:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 903B76B0128
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:41:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D237BAB96
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:12 +0000 (UTC)
X-FDA: 83763831984.19.D06825B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id BDD65A000C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FvBZWi9f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754901670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxLpCqZMNmDoDJ1iE4RjOi057qTqSgyDD/7XZbSrpzs=;
	b=aT5c5zTyRCkDn8fgqTtSpBzlbPV0NQYRhNBrfhERuHYXEzsMLD2LMXNupHRXKW+xzltvEu
	XwvfYNeUdc9u1q+VF/ojgieSvud6sLD1fyuzbp06YIDKOjDx77XwcZM75ViN6Pm9jgGH44
	SLtnr6rd15bpQuif6VvzY5mX5b6xayI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754901670; a=rsa-sha256;
	cv=none;
	b=0j/p4dF22GJ6+Fjrft2mSTplvZq2sVC2G+LywAb1pSMnVEGuUEICnLTvuMuSZP6f4M9AO2
	2+KBcIYSu/5rYcsp+rInwiExDVkfAPTcaQk5ZZL/FCOPLbOJPZymTVzQYyT+qMcKR4mvlS
	dRPPJkIrbb5fpYnhXJujMKtekzC7nyU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FvBZWi9f;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754901669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zxLpCqZMNmDoDJ1iE4RjOi057qTqSgyDD/7XZbSrpzs=;
	b=FvBZWi9fd9w3Nxj/z05qR7de5E+bWNZGCjVDkg8vjPvfT9+LN1wRMKcmXL9pUZeNN/YMXD
	5NtfaDeSR4wg9Kk9u3QEsCy4QWVmxWXN6A9bL8iVNoctrcOq0VPjHQTPsO7Lpm0cLFynBZ
	YatrmTFCY5N+Dl9ZPbJyGUOyx4ZT+po=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-weJodnmCMK-MU8-lg7QyXg-1; Mon, 11 Aug 2025 04:41:07 -0400
X-MC-Unique: weJodnmCMK-MU8-lg7QyXg-1
X-Mimecast-MFC-AGG-ID: weJodnmCMK-MU8-lg7QyXg_1754901666
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-55b947b5586so3546817e87.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:41:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754901665; x=1755506465;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zxLpCqZMNmDoDJ1iE4RjOi057qTqSgyDD/7XZbSrpzs=;
        b=qJr8l4er2s1gFPW+UqrhTWSXWN9xNHEbxx9guykYx2X2F30z9dze3VgDFoAlUtvTIT
         zl0qQNj/P/hbtXFqjTCdErQCkTibrydBOZGK45oefzi44W4xQctomQTUtePWWvYyNJ86
         zeIqJb1nTK3xhfzmFp4UsSyNMKKzQ0W6b7gE/xqDrU5OQbDXZni3aMrHRyal6mJuj93o
         heSKqKwWO5LaQYu9mY4rtDeIkhR+9G/pYAYl6s1GMr4hzir+2gvE/nBt1GQhEnz1NcqU
         IiVogyfhu6rS2uoY2egoNcnHYodkVnBKwxy+f9L6O+YYw0O8oWeyDaFE2dJYVw6uv76M
         4goA==
X-Forwarded-Encrypted: i=1; AJvYcCU5eOS/0A5ap/W63BK1Jhpv7ZF8KD4VxZhtoTrC5GiX4hRqlnS0UB4lwlvA7kGbapiOf8AQP+tWvg==@kvack.org
X-Gm-Message-State: AOJu0YzFIj70efyn1iIuemNwub07OO5vHH8Mda7BMdZPUwtkde77mMgQ
	7f9U8/NIM/wvZCAAbBEnf6SAG521yb3EjpOH7Xfs6Uo/EeUMbcy/YTkJdGKPv146N9bOem6I5NG
	4UAmowlbrdfVDOGKAlMomRFdTHzAD2kAFj6Z9Itz7pVPPf30Use5i
X-Gm-Gg: ASbGncuR/jzdZ0brYfeJP8ensCMm/n2ZQpuU8XPmCbwGU2DUnkqv7O9s+oW5ahd+PAB
	qhhB+FxIjWZuMkPcKhq5cAypUR83MgZ16rZid6O/cmoKtdvxjiqdwirgaRgScPQSozRuAn+Z5u2
	/3bigYao8BnmGo2iRojaIVFWWTUXcyp9T1UoDlhLOakvJORcral65j8jClX75D8eK0OAi+lS3Ef
	ypzqWsQFDcWwaOG3VtTFNFyTZ1l8LKMvFJf3vcu/NMj2Gl9ysXTfUnTUEZtRyp43s50Btbqu73D
	kEJGe2Kdl99uzqL3xAlvsxgI9W28kUrW6Q87nOxPHOu+jcfCL029L25OrW+mkri7duheRd9SBbU
	CrsnZQAKgD/IKJ4aVHwr8zgLLF4cLylCImqNx2uHCuBezz8FAbWyomtMFTtlRfLqieQ8=
X-Received: by 2002:a05:6512:3d23:b0:553:2c58:f973 with SMTP id 2adb3069b0e04-55cc016008fmr2795258e87.52.1754901665512;
        Mon, 11 Aug 2025 01:41:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/fZRrwndjnLBh1r2I7omkHKsEMqLQlX1aVWcSYS/CQSX3iDeImRxXBNUBP1Cm+AH8ex/oMw==
X-Received: by 2002:a05:6512:3d23:b0:553:2c58:f973 with SMTP id 2adb3069b0e04-55cc016008fmr2795212e87.52.1754901664758;
        Mon, 11 Aug 2025 01:41:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5e99e04sm242806725e9.11.2025.08.11.01.41.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 01:41:04 -0700 (PDT)
Message-ID: <2d84e83e-5fca-402b-a01d-811003c2551e@redhat.com>
Date: Mon, 11 Aug 2025 10:41:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] mm/mincore: avoid touching the PTL
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
 Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>,
 Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 linux-kernel@vger.kernel.org
References: <20250807152720.62032-1-ryncsn@gmail.com>
 <20250807152720.62032-4-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250807152720.62032-4-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gC0tyt0eMvwLAlsHm2SHivNbDqUPEepPfqTsdwHSHFA_1754901666
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t5bw4d95tccgxbfmx7zfabeski3enxyy
X-Rspamd-Queue-Id: BDD65A000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754901669-799637
X-HE-Meta: U2FsdGVkX1/opOOBCFjOfrsB0B6e5bBxSn1FgWCiYzWvqCitY2nghv1p/uFxZYK7oMlxv3uLoPArc6JFwovcrGz0a9+7LwttRBkbdAHYMBlO97u0qoeH06T/SEbaPJZeahaOkSVpQoRrrC7e/Zkqix2FAdg8h8j5Sh8y48ggXxNosYI//0O8GWLfejZtZZOnjSzaFlp2a3P0e/0WX5umQ3Q84T4yyvNDIIE68nr//zPmVbQth09KM6XFJ/iAx8coXt181qMGLWdDd4nFzDLU8ilbDXO51ogF47sOqTGNwr7vzrzNpIxIORnE04SbNsLuVVsXvNxpEKKsdf5pAoZ4PkitrUuros1LXNFK3BB1KrOHV7rcLKFXdURpQf0mWwHWYMubjLgb2TkLqYmZur5akvASQCzolCjaYgmADxc8WYaC8m2aslhzyPyanQuQku5KGf6xeVWguMsXYwzzX9ZxuuDxawNYXuC+FUF3F4ms3haZ7txCYEReQlyyQJvoZ4Mwpq1SDuJ9+Nn+QEX9me0/oMBoeffXxAY0X6fNMlZP5+rVPTifUGunatvvaeqcSo826yZvzpXs5q4caCdZk5g3eJAdKHgFXN3mCbjApqNa2R1vZdgOzLg6sIYERk3vfXKa8u0/CyJtxtq7k/RkMhhOj1CT7cXn+IfoVOO5rSoVACJLa/eeDre9DWPlibzMUtHhpjRqowb9zTL2A0rDYLN1Pq8MfD2fPFIarSIU+6bbzYLN2BzhBhXhXDmcHFl39v2uH/B407IzeTt2NgZbQsDv4cU4I3AcRkM/DuIW9EukSpIhxBCqaxBsjHJ/IhNa6dUit4+HsuKHkVsVIVBXedg1VMs35Vlg6v/DBDGMGvEP4iRc3HKI5SJETC/tOVx3qiGEMuXZtVO4jVpbDrEgjBIUkefaHp8JnW0tz8rFy1PXg+/HlrTkPspEPKqD5I1pkI2lwxAi8dz7Xoend2i8eku
 hXjOlxvR
 zxFjwwUouCK1l5QgQVKHuK1VT/P52mhonXEGNNYWs6UqBY96PJvmrzrVDlyaHpeJFbGPI0UPUgpJA52E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 17:27, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> mincore only interested in the existence of a page, which is a
> changing state by nature, locking and making it stable is not needed.
> And now neither mincore_page or mincore_swap requires PTL, this PTL
> locking can be dropped.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/mincore.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 1ac53acac239..cc4460aba1f9 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -153,13 +153,13 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>   		goto out;
>   	}
>   
> -	ptep = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +	ptep = pte_offset_map(pmd, addr);

I agree with Jann, that if we move away from the PTL, we better have a 
very good reason (+performance numbers).

-- 
Cheers,

David / dhildenb


