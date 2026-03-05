Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C76C3EEF331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F2B6B0089; Thu,  5 Mar 2026 04:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3026B008C; Thu,  5 Mar 2026 04:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF196B0092; Thu,  5 Mar 2026 04:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE1156B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:03:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E5051608A1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:03:17 +0000 (UTC)
X-FDA: 84511420434.04.B1DA80B
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 69D08120006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:03:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bhIMCIDK;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772701395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smWzxETQFde5edH1yawclh397DslBFPt7zhbpAy3Arg=;
	b=Q95TQC33YRVRklcuy8WHeZUk2xWDPStys8TBrM+HsISnEid/UZcMsHVumFDPQZKr6SlEyh
	m/U9jOjYqAo5VfdVG9FNNJMmc8KYdRW8IayG04VBo+HJtOgfmY8gmVEvCmLUISDxoPue4P
	XRakHNYNGvFBhH7NiS7veJ9IvDLWgUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772701395; a=rsa-sha256;
	cv=none;
	b=2utKAggoimS6dj3gPi1/8PDZkGUJUgfikoNyDNhPcWgp+oENMShwCF1Vs0nSi5W4nPQigt
	Bw1HV07fVNTI6QxOPBGJDPbYtdIhLaZdhhP/SUIvt7DuUHkWL6OsCqfbt6007qXXt/GzSY
	9U+S+F1jL5F3mGRya1f4hi5qBJyGOj0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bhIMCIDK;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439b1cf1212so289029f8f.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 01:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772701394; x=1773306194; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=smWzxETQFde5edH1yawclh397DslBFPt7zhbpAy3Arg=;
        b=bhIMCIDKUygkImOsl2AE6wlG3jKuSS6JQxQpQqGnWKC6b5wXASGQAygpSOtcMMB+uS
         2FuRapL9ADE3inves7WPBfwLSC29XB5Na+DVE6sZttesG47JDOaNAzuAzR6OT7IR5NWQ
         Iz1KeKC6bU5bnGMFJVRAB8wVynkeqTKXxU3EE3UaeEnjGo6JAXS9ZsPBjmIr+m2KS+gq
         Qk/UB+Io+Cn7XNiwOuJA1ELpvUvkO5z7lsfZXWz9H96TzR1r9W13GoIRnVnr6hSI/ylY
         gvELSJEusNVot7BJx4OEzMGPGvyVawvUngQ4LnCWDjkGU6woZjNOVn/9jtaEwsuo6bkU
         eigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772701394; x=1773306194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=smWzxETQFde5edH1yawclh397DslBFPt7zhbpAy3Arg=;
        b=RcUt2gmfL0/nTROdZOHeHzoev7jbnmgaCJHimL7gP4n4Fe/PnBw1bt9NvGMJQgJyNH
         J6SvWObMrO4rFh5Xk/624cgSP9C2szTyHPp+GaAy7rXBlLXRKKnUtsmNcgknG92f6Yig
         QQRulfsDi41tV/pgnFMoQTr4LzCrn5aZqdjCx6gh6dvGMoQzJQmEZBmF1b5brtai8EBg
         Us8dOU0kcmzS15C7dTTHrS+7RpFRI8VBFMyzCzQVoJyF85763zY9/zdV7rdM3CO1BIC3
         7VtW5hO0lOFxP4O3taP5mjRqm3dAvmquFYTfEf6E4rFuZnIBAsIhIUAlFr1qNjlGQnUw
         s9LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAsVdVv64rMy6qPxVGfuql27A5RfQ1maGGlDsHQZbx+/EYyhrZQqCdHz0dXfp767MZs8UUgFmV0g==@kvack.org
X-Gm-Message-State: AOJu0Yz5ZK47g7WBfkHS3tao0QsyI1N0thsJ0CImCPuFMKoiylDd/weh
	N6xQ1Cup0yhRZvIQCN/pKKzWBcykDx46B10XDcMg9g1AM5+lzEY0BiHr8RDYkWdn9I0=
X-Gm-Gg: ATEYQzztZB1SVEyK8tMAAYODY5KyhIzHX7/IJp6ZALhKRITQm69BWVbFcas0YMyvpvU
	5PHcgkVdBILzkSjv0VY3+8S+Ff3+5Pwy/Ztch7b9KIp7FN/ErJBK+B2YDLqL+oUXKwQxqZ1Cz0n
	E2A6hNdssjjh5lZu0Qa+i38FwfWWvzAkw69yK1nFoVcXqs73v5Q10gpPSJkdCk0dHyqfKBMqb+n
	1x+pIw0WtxJNWrXOW7cvyLB1Ec8YWHkRqCbFB5oF/2IkbZyMrbFbN66f578U5EaHgq98tXcGXlo
	dDtE+RASXiTqKb5y4I/lEMMu0xcmJOiLWhshMUKCvdR/2FXk8CcTbtQiS1IEyq1FJVpcrNObNbQ
	wSw223ppDtkljzBPjv1Lvxp2uCanDSIb8hPE8mT7VV94dxnOqH58d9oCNypWIS6d1LXLm4aU+ZY
	LCHC9Z5BDyn/P5t/maXO/8c08aSl9T+0sAoEpSegIDvDxeFzRHJDAVgMRkyw==
X-Received: by 2002:a05:600c:1986:b0:477:9a4d:b92d with SMTP id 5b1f17b1804b1-48519897935mr42870965e9.5.1772701393663;
        Thu, 05 Mar 2026 01:03:13 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851fae4a68sm24849435e9.9.2026.03.05.01.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 01:03:13 -0800 (PST)
Message-ID: <8011ab29-de9b-4a9e-b437-a514f6e462a0@suse.com>
Date: Thu, 5 Mar 2026 10:03:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Andi Kleen <ak@linux.intel.com>
References: <20260304155636.77433-1-david@kernel.org>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260304155636.77433-1-david@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69D08120006
X-Stat-Signature: dmaizte7wr57z7zxdkuf9s9wnthyrrnj
X-Rspam-User: 
X-HE-Tag: 1772701395-686232
X-HE-Meta: U2FsdGVkX1+YmI4othZ/PkLbWpinZPYvZU8q9CtENN0CHT+Gw5MiH10yI0smKTcCGRVbwm2usZ+bStyxE8b0VCGTr6s6r0CdgUzQsgLAtj6puOcVaJlZFydR7Yr+jxvPZcd+8MUANDCPc2CRLB34ey52UiBhOdaNUeFoNWqi2nxPIIJ0QkgBX2e40mo7fCzv++NsTt5v399c1pBUkl6EE/Nhj+OelLPSQXw8aD9Wrpjhf5OYbe2YmrgNgvos84hDJs7JXqxn/jMLhuKlApcynZNQw3dZ29vY40iydl6x9ENx3EwMGQrNRv2tE/5vWhfhpyakKmLbc80zZETCFj7TKfrVCcaJSX0Bjx8c5ag41vqZ/ZCmvmI3lSKU4CM6ZohCzxRPWVZZtaO/Lk6xWGesSvq8/YrlWc5t9X7Z5egGGUN1vr3jvya/kbX/WXNa/qUfYM14O5QAaDR17crfjVsv13/vdoEd3ZJ0++PQjQ36qn0PZIVn3VaobaroWI1soTt1VULlyFqjt5m/J/ar0/h7hbm4U27PoX9ve0KM7rQcV9IfJLb4k1UdZs6JgL1Q90X0iITa5JSL7cdLIR4oR/FQvMg4xmhtbHGjdKoEUZrh6UedlD9+TZ5bA9t0Lq/FStI1L8ghQDUqidsMqlYWb1FB3pt0kttypApCWXYWCmEHHwuqC00pDFVvPkyfWlRuRcoGUBy8o9wyK2E7Z6PdCbcF1VTEbnVy9q4+ctaMkLm3M5Ptrjn9aj2o3gYCB4Oc4u2Dn736/s79ND3TSSA19+smkjfU1bCiXyhhVhaZbt4bYpax/OB2vvvF3nBgfCfxGHIji4xTUW4G1CHz5lCAHD46vcDuhufaNnqbQ8O1wVPQRCWMHG2HRJZwjkw/aKBoRfg2XCaH0P9jLtiWWfwGTfKnkIc/+1s7nn7ssUgAZks6Rbo891OKnPUQBAasAKSN32vdFI5TFTXuiW99vbsmOzr
 HhyNvWto
 AOThC09ITSpzrk/pTIdyKEWekj90yzcpZGK9wn1DW4VpU0wgtk2hLkQ7VMWxK5IZr6HCZBLGw/RFMsN85OAcGpo9oK3APmWNOm1c88Yxmpmx6k+hDNVMq7AKmCN9DxS3RkW0mp6iGM0V5mOFyerXLyUQjdJIm6D+cDzweVJANxHKv2Ve9K5Wj/aguyMKJcOedUbR9EYvKx5JoE/up4oZwZGGn9JqijCO3X2zFW3/RGSVv/R1iyt7V4CyYVk4SflSJdg9JfiPa9gI9RZXMoEAfj3qent02BoyBoMhFamuf7r91RRnAv0TlY50bdZ/MUckn14m2qhLr+0zDK7X3p/rH7JpK1J3kMHTxP3cA4fhD1FAqSYWlniTVEFrfeCzFQMk+C9OJeZFNH8Ispr2j3ox0tP0M3Ee0kPHygXeomvhe5DDLL6MOoo/kTClSyAkyxAYSgrywR8yN0kfWhcXuXTUqcVkl5J8/RKJWkyG5QYWWn2a+vyR1ixEeKe6eWobKfBx/fdigR5ncJ1QIXE6HQYzwAYKi3uXls519LEzoRJKH/5I19QbY9WcLdy/D1gCnQda8jxsH8Jh/MNmvxUslCizrc91r2Vllbgyd2qL+eQQNzjvriUihdqeEoVgghVPHb1Q6joHEO72wD0M5a9xRm1tXEHA2IW7PY1IFxfbRv8C5gGqJLRNxpMN6IE98AAgDaWPuEEZsA4/t//RX6mRtE8Vt/CAJCF6CVP5hTt2OWzb8HNW1mJCkwWobAz+AOODQ+Ll45rXT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 16:56, David Hildenbrand (Arm) wrote:
> There was recently some confusion around THPs and the interaction with
> KernelPageSize / MMUPageSize. Historically, these entries always
> correspond to the smallest size we could encounter, not any current
> usage of transparent huge pages or larger sizes used by the MMU.
> 
> Ever since we added THP support many, many years ago, these entries
> would keep reporting the smallest (fallback) granularity in a VMA.
> 
> For this reason, they default to PAGE_SIZE for all VMAs except for
> VMAs where we have the guarantee that the system and the MMU will
> always use larger page sizes. hugetlb, for example, exposes a custom
> vm_ops->pagesize callback to handle that. Similarly, dax/device
> exposes a custom vm_ops->pagesize callback and provides similar
> guarantees.
> 
> Let's clarify the historical meaning of KernelPageSize / MMUPageSize,
> and point at "AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped"
> regarding PMD entries.
> 
> While at it, document "FilePmdMapped", clarify what the "AnonHugePages"
> and "ShmemPmdMapped" entries really mean, and make it clear that there
> are no other entries for other THP/folio sizes or mappings.
> 
> Link: https://lore.kernel.org/all/20260225232708.87833-1-ak@linux.intel.com/
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks.


