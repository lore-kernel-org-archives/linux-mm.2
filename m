Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4F1CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBAA8E001D; Tue, 19 Aug 2025 04:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B39E8E0002; Tue, 19 Aug 2025 04:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2028E001D; Tue, 19 Aug 2025 04:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F091B8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:44:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 715EF16065A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:44:15 +0000 (UTC)
X-FDA: 83792870070.21.FD6C683
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9F573180004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:44:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KuD1iEpc;
	spf=pass (imf16.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755593053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFC11YRDk3hLW4PFqQxAfzM0vOushhRghFk3Gc6p2xU=;
	b=vCtihhiH0tdgpk3y3FVBMZ+y4ay4pWqpg/chAi4iszjVPt+PeYC2K7uNI+TkaHhtnxMjn+
	VKRmB2JBfypYT9sE7UnDLa7ZJbYnz/80aZWfcz8VrQolP6lFmX4YMUNjUPxWHbRcyqq776
	ma96oGO2PaB1ejP04ei6nGuovRIhUVc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KuD1iEpc;
	spf=pass (imf16.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755593053; a=rsa-sha256;
	cv=none;
	b=OIGMFRvFnNv0hU85uDQfOsxsdb6hMUAd0R7ncoFD6LUPaW12QaURvM4sDUSUnKRIYbgMiH
	rfQ2oSKLtOA4js5S1yk8Pc9qfT1ktkRkgW2fBY2imGOrC+XpfLKDiIyCNDjqKCfnW7vY+i
	BOAFbEf/R1cMcnamU11rB8KYKTYIyYw=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3b9e411f79dso380700f8f.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755593052; x=1756197852; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oFC11YRDk3hLW4PFqQxAfzM0vOushhRghFk3Gc6p2xU=;
        b=KuD1iEpc4BXodMVZ4FVU/VUaUSVK/IDaDcNugqaVooIsIukmQ+Dfsp92WufI64bkRK
         sTk5iHx785Wr595BWgDxWGTaiLoyxs4/705dYb9vfGmswV9DFIbv5jFPgLxwy3wqVVpQ
         rceotW+s/oHIwthRGjuxNZo3ar+DID0K74eUiveZpUnY6YyGBdgXKepw1cDo/EN1yGRv
         jtYb7CzAsA1vhbHMCbUNBr3SKA8r/vzHodJyApHquiyy1gLDkk6lWUioTWPiStQD23aX
         smvkpm3HHTYUdMOhcIMoRuvLZs/vyV2AX9WPA6F+2I16emYbRTEJkt6fzgiEJZ2KqDVt
         0CfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755593052; x=1756197852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oFC11YRDk3hLW4PFqQxAfzM0vOushhRghFk3Gc6p2xU=;
        b=Qt3lflDAHtfffTTBFdlTIsUIVomXiBkC1bs6M96GadqlyehIfVcz6VkH5GP8na9/q3
         80jMMU5RAda0ZikAkC0pTQQR6fgR6V5kjpx/Py3NM+J8ETHcqCWUlh7qorn11fqGDDHn
         aXrYWNhzxoo8fbZFGkQ2Cp7UziuaNfNi5rijYZRCQOCDlq/uujzW00Edv4YMu17HinKJ
         jZ1Kmb8P0WWaZBuxClQT7HdJ9Et+SgH0NzizmaMwfapDN3JV6aTMqTeksjtySkUhulr/
         fcB9lz5I2C04cWthgRz/nplqlp14pZfr5zgzXXJIxsCZMvQp/4YNbeWspNiPwmRRuFH+
         JfLg==
X-Forwarded-Encrypted: i=1; AJvYcCUzD1Kh+MkzVQhetqkeelBS77bzBjpqQB0MKFUq0KfTe1DMGRfgUsa4txT+Ijbe5f+b017r4+G3HA==@kvack.org
X-Gm-Message-State: AOJu0YwdM6y74PLRmZI0igdULUTj1EqkZlRNsxgSLsaAa6uKcqwlkEnK
	Pkljonmohiy+zvt/DaCqTkcFtX7E5BPu9FivVPeUHiOtdHNAdehrFbms
X-Gm-Gg: ASbGncvADquh9jEFi1K5Y1CTr9LYWCb0zgGnUQKSW9mzBRC+QLiPTDZ+cY4I5oz3qm0
	hQx+LLJZEDT4SBv/uD9Set585BwLG5YSa63+v7shVVQKfvGV1ZIIwcvCQ6IocGq/Jt9izKGKLty
	oGFDchmmsHe+nlp1SFvCPU8K8ge4uRojMDHbiYQctzOOHOcBcx1EWpGX32c0N4n/3mNxIryoXOn
	2LSd2Ju8WAI620sBNnQfwbSp7HW6M/LWn7T6wiB3qYvZE6x1OrSRzULs2ZbqakYy1Ekx2oFw3Yc
	gadk4alpsHoQxYo62oR+om9KkUFUFqS1/NHPLB605ZyZ44ES6+xivFlMZYIoRJZVs2Um2b9n2dJ
	pmb1Lw9p1k4jnQ32Q27CtDl2osypTTCbz03t3hczEdTFy0ZRvc/te
X-Google-Smtp-Source: AGHT+IHofOdCeurN0rfQapxXw3T6dAf9uK8p0WB3BrcvzYJ1fUnpaHB4/Gv3aeR19imEmN6Xr0Vjbg==
X-Received: by 2002:a05:6000:2884:b0:3b7:78c8:f23e with SMTP id ffacd0b85a97d-3c0ebfa85b3mr546045f8f.7.1755593051742;
        Tue, 19 Aug 2025 01:44:11 -0700 (PDT)
Received: from [192.168.100.5] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074d43987sm2789350f8f.16.2025.08.19.01.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 01:44:11 -0700 (PDT)
Message-ID: <17e83e3c-1314-4198-82eb-ffc18454e344@gmail.com>
Date: Tue, 19 Aug 2025 12:44:09 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64/mm: Update create_kpti_ng_temp_pgd() to handle
 pgtable_alloc failure
To: David Hildenbrand <david@redhat.com>,
 Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Ryan Roberts <ryan.roberts@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Zhenhua Huang <quic_zhenhuah@quicinc.com>, Joey Gouly <joey.gouly@arm.com>
References: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
 <20250813145607.1612234-3-chaitanyas.prakash@arm.com>
 <4289fc02-8e09-4d33-a4a1-0e4b268b008c@redhat.com>
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <4289fc02-8e09-4d33-a4a1-0e4b268b008c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9F573180004
X-Stat-Signature: corojphcpz78uzhf7zwem5dyjdy9eurr
X-Rspam-User: 
X-HE-Tag: 1755593053-830379
X-HE-Meta: U2FsdGVkX18L2VAaHEvBUqbf6Y5O0SD8Ond9nV9P/VwtzFokrHviRyvdTsqp/gW0GMkBk/ERwiYqfFb3/t+maB+GnS3PNjaK8BFeKdoPuDacEWHkm1FEVPBajYsacZTutlMNnGnwPeDtGSpjG+P7wgw0QGAY+wTpF6VMJsfz92sQrbmt028a4hPG978y9udDguL9Y3hI8YzKnz0yhCA7DCy7a4BFKdHk5NPiyueZKv9ankmMdFg6o0kXriv9Xg6Nr6iJYgPIXaE8PIdoYyuNvsKy/yY86PYiW+odPJjmCrX3ozVUNA5BmifZ9v1WIqssYdluceOQ12u+0ZwZjvBGO//E9/48TgROgxEHo6nNYJyQ3JH7mlJTZZNoYnL8uha2fCwv+lqSmxn1ZfMl3ziIukFy40aOmI9rKxoBvc2kgjPLk7EMaPbYX9dMPSXMFIQ2kljbTzZxg3JBnNPQ+NGpQYFrLtq+0JdpcepJbUds9+Z5sK7TL+WiVBIyDzz48+lqqVLLok5tlIOi+18XyQMLqzUWjhGe860TxJxS1O/zvWTg7KPGJuBfBR9/CcT96PSGznx6Y42pS5jKX6eLm1PyGEd8VTMVet9Tt6ZkWOyOdqJbHbZQQAlMFp6TegQad1hVINa+r286aLwLHFlLntN4sqP32C0KKVImuTnC9hIy9SUq4h/exlNBvpHoiyvIitP2Eg87bxTh7bAgbsGPWq73KPoeC90NjqTIAx5DjsL2VcfO5Ip8aoNYiwofFHtuUzjMAkBObBIScf4ti/yMmYplJy9Jzc0MFygTo+yt8MdtbJp4JmFab93Go7yrU3NYYqd9zw4wJqvmx6/QUKNyANiF2KGyTnY1c7ocWAOTlmm4tENj6kaCGmdAwv7vlhelgRivrED/IoHWdfYki1rzze3RLvsMUlxaskyGFraFQJ0G9fr57aK9WuWHOM4lmjYblV6PkFnPNLNJExqPAI/qaDn
 ryAWG0mn
 hXRgGx4H0k6s4sQG7fRKBDb30w9pRNiSPGRvFZQJ6c76VsRPAjLMS5MEjVMT6kp2rCo2etJHF1+0CjKwdiFKTCJD7aJ7Te9V41n9N6hIY78MtO2U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Smart! BUG_ON() ends up in the generic “kernel bug” path, which on many 
distros is configured to continue after printing the back-trace (e.g. 
panic_on_oops=0).
Since a memory-allocation failure in early boot is unrecoverable , we 
must force a halt.

On 8/19/2025 11:41 AM, David Hildenbrand wrote:
> On 13.08.25 16:56, Chaitanya S Prakash wrote:
>> create_kpti_ng_temp_pgd() was created as an alias for void returning
>> __create_pgd_mapping_locked() and relied on pgtable_alloc() to BUG_ON()
>> if an allocation failure occurred. But as __create_pgd_mapping_locked()
>> has been updated as a part of the error propagation patch to return a
>> non-void value, update create_kpti_ng_temp_pgd() to act as a wrapper
>> around __create_pgd_mapping_locked() and BUG_ON() on ret being a non
>> zero value.
> 
> If  my memory serves me right, panic() is preferred in such unexpected 
> early-boot scenarios (BUG_ON is frowned upon), where you can actually 
> print what is going wrong.

