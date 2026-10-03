Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B61CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 15:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4256B0092; Sat,  3 Oct 2026 11:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4966B0093; Sat,  3 Oct 2026 11:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894736B0095; Sat,  3 Oct 2026 11:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD126B0092
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 11:50:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DAA3C0A0B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 15:50:09 +0000 (UTC)
X-FDA: 85281751338.08.8525A5C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id B4E6B40009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 15:50:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DeUOswXx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791042607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJNvDGX6YiI/koTtXDXCLWPYjykCeclt5Rn2DoTl0tg=;
	b=AapPYhhluqiv97ao5OITShsN71baK1y/WzelaFv89vp50FA9RxWcyL1OdeKLPHwNVGtEWp
	fqKTnshFPISyJ5kxCe9bd535Y9gMYegwkgdtuhbiAL75pr6yuNA80ten/TdaQvRVJdM4VB
	SgWXuacHoH7a63FLv27eBRNGWrWGXSE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DeUOswXx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791042607;
	b=mew1lYXkYtLAUMLWcl9YCZaW02WtNjhLIrh/ocQ8XkNAaLC/yoQGWwlW5YZ0UJA5GfoKaO
	1tVzKJubD/V/AdQ5fCpNVoFiH75IMUkEMRINLZZue3bZEFDz3Yt76dEjEBbAnd2MInyG2D
	4dKGWJJm09csfTHA7BANg951AVcAvhQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791042606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pJNvDGX6YiI/koTtXDXCLWPYjykCeclt5Rn2DoTl0tg=;
	b=DeUOswXx+s6CfA5WlP93cu+m7pv1BL6441C2bubuX1uSpPmP9ytOETWDrICHH9c/Hea4hg
	7ux9bsKreYkPIK05mBE+jPhi+xHFYVk0J/HkvPbPfIiAIfmTDzyH2w7WLvkvmNiBScllrP
	6U7gaNKStYlDHx2OidiTi9os8ZA7R1g=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-h836ZludPzCMFJP929TCmA-1; Sat, 03 Oct 2026 11:50:04 -0400
X-MC-Unique: h836ZludPzCMFJP929TCmA-1
X-Mimecast-MFC-AGG-ID: h836ZludPzCMFJP929TCmA_1791042604
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-895241d7405so5012367b3.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 08:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791042604; x=1791647404;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJNvDGX6YiI/koTtXDXCLWPYjykCeclt5Rn2DoTl0tg=;
        b=b03NHqNQ5yZ8i9Vpi85P5O2vUgAsgt337M6rosKIuD4Ct5ngZRN5TzO3694uiv/hg0
         VF7Ei/5LMjl7tqsbu4GyfcLaTzKCfLLZ0mbkbA7Ce3BNB3gJmuLURmBPWnaYU7S0XZft
         lcyWGgULeCOMiWKLekz7vi8L+oUB+6BW/hFp1NQ9h7YR70x0vQx/lfBXolwSptXxpj4E
         oHQDgu3SenHTrRzofkLaDOhlPc+mWOopY2QTBBUI3/WtDwWIiUKf95/JcEYAh9UwH4JI
         mns8mYmbqnMxOEdVhuhb+9815Ce3yJ/XCzmjvG+ng4gTdCZnoRhhOpy5qHI/XVCQ4/GN
         vKRw==
X-Forwarded-Encrypted: i=1; AKwUvByoM7gboiEfac3IN4gsXHQJNIEQGENV7IUQrvCd5GB+db7G4U5q+/zd6oY8mYK3UMfmkLq0JRN4Yw==@kvack.org
X-Gm-Message-State: AFq9FYJrMW5ceo4KLS2uCCcmicsW00tv1C5rhZWaMuX1Klwi/gn1DP2s
	tV7j0PsWAVM6F68KGxEc0iUvyb5LEVwoFk5jhucCrQ43RtNRRPfaUeWj/GRp1QJzG9ESYrjJ+//
	IzCRJ25esQIxhc4v3G0X/uSVWRKyyF0cJ/eaOtNicg4zivtF4wZYG
X-Gm-Gg: AYBFou2e3xXEUKZ+2FddoIaI4pZL8TeNeZtIWacbdLGretnXkb8PsXCuxCDuBzmPO0F
	Ja7DEesxyk70QRa7C8eSDZw2ooz4LhF6TkqYjYE59YJnbLIeUK8RIM0bWhgpvM7BnW+ULvXJt7J
	Uh5kUzp4KFu22DLfw1UCgLPRk3LVItVDiMHKPOrN01IVgjiO4bH7wTgrn0HVb5IXnQ3eEg+hgnk
	wU0cKlJ4oJx3p24e/SM76odgzd+8i/altX3r7BL+40v49frad+ei9mn1//HLcG5UAP0G5ACwzrD
	NsMZeOne+GUwd8Wf8ZFo/ph+r/khe55Mi+n38It4eP9tgGDbUg7fnKc5fWlOSjDX6TpWscFdN7T
	2238=
X-Received: by 2002:a05:690c:f15:b0:8a8:6a39:37e0 with SMTP id 00721157ae682-8ae39c0a963mr28209857b3.42.1791042603869;
        Sat, 03 Oct 2026 08:50:03 -0700 (PDT)
X-Received: by 2002:a05:690c:f15:b0:8a8:6a39:37e0 with SMTP id 00721157ae682-8ae39c0a963mr28209777b3.42.1791042603359;
        Sat, 03 Oct 2026 08:50:03 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8aeaac82e1bsm5662017b3.34.2026.10.03.08.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 08:50:02 -0700 (PDT)
Message-ID: <eea53e37-c000-41f9-adb7-6a95e61adfa9@redhat.com>
Date: Sat, 3 Oct 2026 11:50:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 14/14] mm: thp: always enable mTHP support
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, corbet@lwn.net,
 tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, hughd@google.com, dave.hansen@linux.intel.com,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, yintirui@huawei.com, dev.jain@arm.com,
 usama.arif@linux.dev
References: <752f528f0fed5cdc9de12b54260b0495d4e5a6cb.1789695931.git.luizcap@redhat.com>
 <20261003031301.48957-1-lance.yang@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20261003031301.48957-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0ou7IrbdWE7Kz9Z4Xp_Ce7SzHQ6md_QdwtPNI0VfXEQ_1791042604
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B4E6B40009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6fkphe3fmqxggnmm1gpoy9ztwdiog71s
X-HE-Tag: 1791042606-201009
X-HE-Meta: U2FsdGVkX19BNiaJN74zMtUIerMS0DDdnQDTuOzF7zCN2wim/4cVprbEz2pBhNJYq0oJq7J7N/YK/T0qHSjaqYsVNDpHLJ1SHpBcJUlqbTK5wEo2GJMp8y6ipS/DRwdtTvcC62meqougeRvIdEBTlBQR2XlLCfxakLBq/qoXU8A4NQNjSUXgqLc0gUf6+x87EjrnGvu5c+MWhAEM1otSMx8WFhHIOfbK1wEPXLYx8z0jSAZTa10z1P58wAzuMekfGBzcFfU4Rnoa0kzSfqRIqgDYBXgH6AnIHqrBZRoaiJn6h0Ogj4BukEkhFhhek0t3ZPkqFnhAN3yctA+1TAi6I5+Rzg1WkBiIu3nFyiGQ3xmqcvpMjXLuifjiSzGdQHOKrc3EEwSQ6TetsoGyXA/J8wHXjs3pZJVE4Rg2tWT6617YB3MFjvO5vdof9S+a6CzIsPQQCWE8zDu8G7enrr0e17LqiWzQConPzS4WV28GJilNdlGqWrAJefmVNwZAs6d9W04hOf5m5qarJ9w/7dOGsEEwEAhHXq7AJteJ6BraSJ+Y8fguwCTdu1+ZVgi/ru2Szjm4/yQAYP+G2xY04efkxrnIwhlGDvOwAdFzn+3J7ggY6fhetH73XxV6tKDmHU5/Ctj+n9IcHv2YGbaBSIcxqg8BxCdsGzMpmYv+2/x+7KRICQiXCi3bSYu0uwZASOj4HVQ3F32wY7IC8yNhT4eWfuW3YMVtcM3tNnmOs9MTnXT0aG1AN1u3MxEStSAHBFK7IhFsVMlB10xYAfDjcW1VD0r3466jHYGOBGCeD6+fdjvisXnEYQPsbCXNwKGy/NzjyUEOGyNo67NAibOjavOX33eUVb6ydqHs1/q2L0vx5cXau4aNQifKe6evV/YVBALypmkB0oUmzK0/aNiJapsa+3pFxiurI0lIM1PDas47Oh78ifVDnPzci6Hm4YNPZuomBA+T2598ndc4tHcv8Db
 9iH2j2Df
 xgzcHj83qhWnlnXndF2bJWKZ6WEcqs1RubTMKVU6+S28VA0JH8joaSOUqkXV/5l/C99MRHGWyjrIHyvuiEfE4CnhrH8cG1AbUVcCyAA3OsG4/sNudoPLPWWFXbhZHKYgBmqIYd6mrqi3iYUbzAKtyVRAlXeKbGxeEUzg1740GOCdn5cHUbK/2Ac1glEAwMnPw3HDk88esqYNuQ64wVBfUCd8+paaddESjpQ3GH3z3u2AVluYxOomZIDz7a5te9eOyEc5dApKN9My62y4jNOckml7h+MJxjEDUtbXqMX23ikddsFq+ymdeYLJInLHQPOmHQOWyRygybO19wOknhvdoGwJGK6V+HS/cieUc0Qn3tV/ZrOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/2/26 11:13 PM, Lance Yang wrote:
> 
> On Thu, Sep 17, 2026 at 09:45:35PM -0400, Luiz Capitulino wrote:
>> If PMD-sized pages are not supported on an architecture (ie. the
>> arch implements arch_has_pmd_leaves() and it returns false) then the
>> current code disables all THP, including mTHP.
>>
>> This commit fixes this by allowing mTHP to be always enabled for all
>> archs. When PMD-sized pages are not supported, its sysfs entry won't be
>> created and their mapping will be disallowed at page-fault time.
>>
>> Similarly, this commit implements the following changes for shmem in
>> shmem_allowable_huge_orders():
>>
>> - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>>    considered
>> - Filter out PMD and PUD orders from allowable orders when
>>    PMD-sized pages are not supported by the CPU
> 
> Nit: "and PUD" can go.
> 
> David mentioned
> 
> "
> There is no need to disable PUD-orders, as shmem does not support PUD-orders
> (unlike DAX). So you can keep it simpler here.
> "
> 
> in v4
> 
> https://lore.kernel.org/all/ff7bcd65-d444-4da1-890e-75504303ec3f@kernel.org/

Yes, I changed the code and didn't update the changelog. Fixed now,
thanks Lance.

> 
> Cheers, Lance


