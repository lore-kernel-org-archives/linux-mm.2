Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B82CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 12:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E49A8E0028; Mon, 29 Sep 2025 08:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E028E0002; Mon, 29 Sep 2025 08:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF598E0028; Mon, 29 Sep 2025 08:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D64A48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:08:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7856C86D97
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:08:49 +0000 (UTC)
X-FDA: 83942166378.13.0419F82
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3050140004
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:08:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YzxkQUhZ;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759147727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2C8z3BvZ37i+W1qRKrfd4nTUv4+udd1r6DfyndiPFo=;
	b=XIUKYBVHqmCX3H+an2TC7y1jRU0i46sNLTyKCnqZC3OxCDJopxtkl6tX2bdg2I9U2SCI/d
	N0QK87s/EHafBRXSAJm1++IQczLhXLwApSwHqlLlD41T4rk4MmT5K8lrb7tJxg/bg5Wufc
	ZO4C4+sbjEEetJ5AC/MkKXxiog+TmpI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YzxkQUhZ;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759147727; a=rsa-sha256;
	cv=none;
	b=lrc+t3asx5myx5tjR+ppAPXy+mdNEFfuBrGBY4FCso28vFPLCr/t1LQ4qf3I8v7BQDXO5q
	xq5Wv66JU+QFh5u9WQaKMObp8agKYR4IxGTyOMPnQ5WljVfOJvM0nlBXc+aKdrWNZzgSiy
	howct7+KLysZt4P3S6PmRrUGSpgF+pA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759147726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/2C8z3BvZ37i+W1qRKrfd4nTUv4+udd1r6DfyndiPFo=;
	b=YzxkQUhZrDLtWB433x5+zeN9By4M3ogP0cjvEx8TYWy4BmhtebmWOJdcC+tmN89CBfyHfW
	8EUwPkKQE1+4sddq7z1WL1YJPVPzRgYIVOUwO5QOjJkgvBnheKu2RPw4S5zhc5162Alnne
	T4KOOIupS9wJyY55ub3gUZE2tzP49OY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-i5jdPE8lPBC-K7ZpnsUhnw-1; Mon, 29 Sep 2025 08:08:45 -0400
X-MC-Unique: i5jdPE8lPBC-K7ZpnsUhnw-1
X-Mimecast-MFC-AGG-ID: i5jdPE8lPBC-K7ZpnsUhnw_1759147724
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ece0cb7c9cso3355565f8f.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 05:08:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759147724; x=1759752524;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/2C8z3BvZ37i+W1qRKrfd4nTUv4+udd1r6DfyndiPFo=;
        b=q9p79sxPvCmSMxugPz+oNzuVKJCr6oiT6tqN4xX+Hl6iWKOnyTjNXD1i8icVXsftNI
         NWfU0V390ckcAdh1DJ436bxRzQ3hr8vy3q3bt8vx2KBIDDD71ljKvoElxh8Xf8KChIs2
         xhDdp7vOz+gIpxI3bn3jMVu6pBn/AHam65JzxXVJ6SjPBgqD5ntbw6fUy/z28jLYy/Jv
         mPcJeoDhPvmLkET46D1S4C2mktWreFy69oZ1zVzNLc61NyBI3jyEigZZkiJ5k2qNgPlI
         Q3b0DZCUJQ53cqUc04O4EhSnOjLfdxIIAbzbGx5zZfcFnWlZS2tURSwA3Gp7A4lTs0DJ
         Ziqw==
X-Forwarded-Encrypted: i=1; AJvYcCVXlmvQWubc5VrpIOGQHc1rA6NbSdIRWOhQx3GuwyxEWpLwXBzTzjUHOpVjTG7PUH2PCMrSZY3aSQ==@kvack.org
X-Gm-Message-State: AOJu0YyMHEzpZdhX/RKcRRYdQM1eJT6TU4LxL0v0tg7REbeAee4KkfF/
	9qstMJfxT7nZGsdRPKFxoYC8g7ttjO0ETcrNfsgWq1Q3+B6CJnXB5RgT6PLXQOuHKnI2RjkFAHq
	fRRNNSPXpEznbNRST0Dn16270C9E3HAcDWrWwoPw/5uhZNH0jXRgT
X-Gm-Gg: ASbGncsdILMWEubBVaTHLPqhJ1g1gGcC3t8BfOtxzgGdVP7bzTpR2owT8mTEHag5CEU
	ikLklSUNBLkshQnXBiKEe0nSzc7yLG8VQ7yMgXHVEzFVXvaDRE5TcNpTZ8oO1w/QiBR9R27pkBD
	QLsQr5fE59fPG+qCUtYJeXQUxXEVHhA85/nxi9BEVMpZyj82lmfTkHxIf7i899Nx5Bln8PAGZ5X
	wZ6YJuvE6Sdi0IisbYxT9yb2Zqe9dl0aza3xoMwGC5px5+R1MiuzC+JZ7HdnRkbVZiJgF3Rb4ez
	22b1uiNX6Eio00CYSTHmakhsheseI45vldCAFXSnzywWdoNcasopbgoT98Ks9g2v9Ew1Ic7NGDX
	ZT/rdYBMx3tMBHEEucIhHiRV+HzmyTyQTfDfFVexJf4Swm9mGteTZdYbmSFiXEpHNthVF
X-Received: by 2002:a05:6000:22c5:b0:3ec:d78d:8fde with SMTP id ffacd0b85a97d-40e4ce4bademr16036221f8f.44.1759147723998;
        Mon, 29 Sep 2025 05:08:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzXL74x6Ol2HLL86/jmUACklwVrE0RHmZV4bM+T2zEkgMHV4wxha4M6+wdviHiMVFGWvfQUA==
X-Received: by 2002:a05:6000:22c5:b0:3ec:d78d:8fde with SMTP id ffacd0b85a97d-40e4ce4bademr16036193f8f.44.1759147723585;
        Mon, 29 Sep 2025 05:08:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f39:1500:c90f:7794:3c33:4164? (p200300d82f391500c90f77943c334164.dip0.t-ipconnect.de. [2003:d8:2f39:1500:c90f:7794:3c33:4164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc7e2bf35sm18195490f8f.53.2025.09.29.05.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 05:08:43 -0700 (PDT)
Message-ID: <267b0346-41ca-44aa-9fcd-91b02c4c4b53@redhat.com>
Date: Mon, 29 Sep 2025 14:08:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation/mm: Drop pxx_mkdevmap() descriptions from
 page table helpers
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250929120045.1109707-1-anshuman.khandual@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250929120045.1109707-1-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JTPLO799cA0bQG9BRLU3JNx8FhIRA7Zpe9oxDbZXjPM_1759147724
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3050140004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: o9n9ayfy7y1pa8kkciwhubnqmtdd8xqf
X-HE-Tag: 1759147727-643177
X-HE-Meta: U2FsdGVkX1+tEjPQx7GJ1256hFiC9ESaivcJCwj9fawbC5eDmrQtjJ3HbyF+/F+TjJFhG8UJYsJu1Ur+xrDeZL7g1wXCVeKbFBLOYR8nL9rfBvYPNMpiHkBptiS7uPiVsL++XrZvU5PuYO6Ca953XQstxDTFs1LEq6YQBsEzuirJh7vTaFShdsA2P8ccA1CNKe4mDb98y/r9MHB1sTZg4gMGdMuFsERu+6kZ3+Y93EhjwYTkvliczRwMzaww4chkfO1FVdTcROI1dn9Fzqz2XhUGy/6H7BKXgj7txbE+t/Kgw6MlLK2bLMYlARwwguttXRdqTO3ColkSb2AZIsYAazMNRyqxfpZERm9RzFq8ThQyzYo0vr5e902nMYDO8H9BePvWrSU57QNVBkOVS8eexaJxBlNmBySqDc0ZexZg7g+CfnRjMUYewYP42NYPPcr8uKyowkgYEiw7LFOvqL+Owyec5sG5Vo+bHGhdvZCJL5b4g7SqW7+ypmu+BkXQAMkW+HUlHaQaNnZIhAAt73GKH8uyNf11/0T+4ciprG0sUmvbpyAdoUPn12d5TYM+YvM5n2w7VPoX0G/CZZKNr6hJ9Kb3z4dG/5kTXqSiKexN4mhgIX1cLX1eUpkP/xxb80Um/7VdEmNT4JcPhpk/kXHk7GOFAXnDWED964MhV+Jtflgi9ET8R7N6e/0QEzvTY/LlS4xmZnT4dbcx72tVwtElvvHMYlTxATO2X1NlhEaSiLJRixcEKoeijWMML0mzVQBr21RJfUrEsOA8NDG1qm0wQIJVQlVXDfDIYdJ63R/pkskrgq4Oo+nVQJqduKfjXtOpdPBWvwbBQsUnVcCk7kOP7ky4Boxtoqj8KP5WEXsLleEAdZuH65nlIW/31gIaVJLq4t55u+AJY40fd2yPEcnHxa7RXfn/d9+C1O+TEd4KF0xgX67Q1jKbIl5lo+EsHSfvfBw7KttSB1+I6MiELPw
 1qpL4yR5
 o+TDoZYwGdTHacQACADPIenhKS+W8DVjiqoxI9Y8oAmXBW/lYuMq74sKv21h75vYFfakflw/F+7gJZzexrEgLT7edgwqibNQD5xl9yMGQy0R2rs3cDEtSuSryO5SLE8Vp6tkk+IiWyNwziVQlW17NDapjyqKft9qwj1Qj7TvN+u5dxawGBgdDWo1RXb2OxE0/5hCOr7DcRYW7yIOWkTkVhPKNkkt2AI6OUijlljuLmrODPN1+Rnr361TeiBNpQjf+bfm9AC6uo7w+imcD+B3LcCdCJRZDBlbbX8C1TgQAwOkxz4PitWmhB0MOOw9PHvTcSQNX/lVBXGoIZdLlctukAnk35xDS2KRobJC1NX9M+C+ZUmQN4xpX+IkVbNTt6DorKCsGwPXXFlF3moHa7w9+fle2tSZKKWn6MH6hcZMEwcMAZvDLdLv7Wc6Z10BS2yhYOkaUK2Mm6kwmbJGeNx6O6ERjlkjoDsYWA6VPI4MTQufCY5Evs46v2BqZid6wFMrN4gRuazZBobv7168l8t81HkH2RUwUXaWurrRd7k959DjMYys0MYPwJ4i68MIav6I245UstW+1kiPKwllrpjPzSCCPPf2vgXXOMWT+veNerU3BbuiKkx2IP/BUJKeQu5yjzZrLa0ipba1vK2UZ7d6F3ZrUIIExLUhYKRGXL2n1363J0tlJeQTdsaQOBLSDbxvuqerw/uhehLKiuAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.09.25 14:00, Anshuman Khandual wrote:
> Remove pxx_mkdevmap() descriptions, as these helper functions have already
> been dropped (including DEBUG_VM_PGTABLE test) via the commit d438d2734170
> ("mm: remove devmap related functions and page table bits").
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


