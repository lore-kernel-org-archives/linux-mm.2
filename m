Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38514FD7074
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3E76B0005; Tue, 17 Mar 2026 06:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665026B0088; Tue, 17 Mar 2026 06:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B436B0089; Tue, 17 Mar 2026 06:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47A9F6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:28:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D198D8C063
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:28:33 +0000 (UTC)
X-FDA: 84555180906.01.AA14853
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 394752000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:28:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VJyK3294;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773743311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WLfM9OhXfwsNZO2Z5cPG4Mf2ehRGF5Bqst0QMfR6J8=;
	b=HBAGGrJ8JGrIn6u1jy/y4jc6jM1x0lZsBByfsDPH16Mb8daqsFmI3yssqgSjRwlnFOR66h
	35+fRklAtXXcI+aYbdB7kh/eKyD5V53/yaFImuW7/vZuNckjfnZbR6um85MgFcb4Wnfnew
	YOg1dkZzTYkCYSxrHjaMfZZH7zlyQjA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VJyK3294;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773743311; a=rsa-sha256;
	cv=none;
	b=jaQU8hl9rXpIYV0KzRFZcskDmRrSlp+fEsIUac0NSaYrZUGN3zZRLHECa9T4rzsqsFcPho
	kNfWHf/K7VZWr3DtwDz+zactSHOneC8LQSFMC4qO9nJwiiW367OAfdh7Dkr4vPcc6JFiQ6
	36TdziSGqI1tSXZ2mDVNLfsENJSvSJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773743310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7WLfM9OhXfwsNZO2Z5cPG4Mf2ehRGF5Bqst0QMfR6J8=;
	b=VJyK3294rZrCzO5sVBQCCJDr5x+ucdMOOiEXA5VpeLAcxvSx5K0pp3EdRaHmKG/uwZZNPz
	dBwRbbliFt+YrKVF0gZc3Xm3c/aifdaqblGLXuZHm5IJgEzwjNxBbtsTVe7ExSjltiltyo
	zwopqu/5yoIcSwv1rkNMVuBmN4yZNsk=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-Lv1EZyskO4aeQYiXGLqGlg-1; Tue, 17 Mar 2026 06:28:29 -0400
X-MC-Unique: Lv1EZyskO4aeQYiXGLqGlg-1
X-Mimecast-MFC-AGG-ID: Lv1EZyskO4aeQYiXGLqGlg_1773743308
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-59e11fb980fso3960877e87.2
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:28:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773743308; x=1774348108;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7WLfM9OhXfwsNZO2Z5cPG4Mf2ehRGF5Bqst0QMfR6J8=;
        b=JxKQ44wi9tXVJuO29HXTlbH7IFXAXCF2di9LhGirRlkeT+c/i70byonzJ+DDFLapwh
         drnNPIpAfwoNAb4/27QS6d5H3O7Q3E4RBI4hLbV9hiJRAkYhTx1FdjJYDsYQmccc8pMf
         ODkD/W1eT49dkRiO/Skeb9AG2xQnYfKiUqaDwGyHKntAegWuuuMSiVgRL1CN1U41hvKk
         BGGzLZGuhnh6IoGe9uZcKu3VI3IHA+I/FXwq9hoayhXa6N3hydD96uBZbz3hbwZ33/hW
         yuB6l48VfnvQQE9HvySAPNspLJtVM3n+YX51hT0MLcknQd/Pxz45XkOFWNZZ8ScjRvX6
         ElDQ==
X-Forwarded-Encrypted: i=1; AJvYcCW95j9yNjg1VAo+UD+3oLjWTYcX5nYUABCDwTdYq8xdRxrgtgGtvPUFsGB+AqG3mWNUpvT1GdrHHA==@kvack.org
X-Gm-Message-State: AOJu0YyFqicsL/R+hfT65nl7rs0H8QhRB1R+WqqBHhBFGWtRWutZMMVV
	Rcpkdwrfbs15HTp5mjd7KYjroP6aR7rsxTAqHTn+yxBxM71qM3DKX78nK7eTJvWmEBSyiAaiUZt
	KFwoc1nNli868WdaQ94MFw6h/UJxC7W7XA5Mr3LlAIWz6VtANaVM=
X-Gm-Gg: ATEYQzyv2KxDqCxq6HglLQOEsFV0rtRc5Od+4H3Drm/+kfHKD0fPM2kMsYnitF1+PMT
	zh/eC/1xz0jolhiUdCVbSCW9DomMORAZ/8EMuu//s5+jKZHBernU0wfm0q1GExI2veVzSAPKsqF
	ur8nVKLCusP476zCzDtiOJKmkBUGFqHra04Ww/HuaLdXQVxeaKi6wF7Hkmc66e3H1tKH+cYN6Bg
	fd2nxZaSLKUDZPFSMTOrAuAFdpC/35yCKpfuPkHNXp+Qhh0LTesM1UjXHyiAo/BXywaGolIX/bO
	UDU0INli0LLQPMauOVt5FJ9krORH86H+2N6f9bCW6kd88Kd+TkI+DKveGVYyAE5dzJq4QX7nrJ/
	LEIygh/VC3pIXFxMoQpt9r7IDyFUkKxRyNyLQ+Ovy9WX59WA=
X-Received: by 2002:ac2:5b1e:0:b0:5a1:343d:8177 with SMTP id 2adb3069b0e04-5a1626fdddbmr3853590e87.11.1773743307695;
        Tue, 17 Mar 2026 03:28:27 -0700 (PDT)
X-Received: by 2002:ac2:5b1e:0:b0:5a1:343d:8177 with SMTP id 2adb3069b0e04-5a1626fdddbmr3853576e87.11.1773743307143;
        Tue, 17 Mar 2026 03:28:27 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15603407csm4024915e87.38.2026.03.17.03.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2026 03:28:26 -0700 (PDT)
Message-ID: <412cb576-397d-4f02-b91e-ccb9075dad48@redhat.com>
Date: Tue, 17 Mar 2026 12:28:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] Migrate on fault for device pages
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
 <856095a1-3784-4e70-acfc-888d2a8027ae@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <856095a1-3784-4e70-acfc-888d2a8027ae@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rUDLzZI3SxRnIpXJaEksNUMWc4yFAuv-Wur_8eDVO1A_1773743308
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 394752000D
X-Stat-Signature: hrn8wicsgkhdezn97rpmrru57thnxjpn
X-Rspam-User: 
X-HE-Tag: 1773743311-172950
X-HE-Meta: U2FsdGVkX1//ajgBAM6PNvo3HHqbZy9EsITaYuiFrMpb/wOxWVwDVjRpd6p7KyFN4FMpYCyOkY3GPzaIMtY200Ys3k0ThZc40Ggh8Iwe9MCmYiQUKkKejDygUIKOHovbgIllzu3wWgG/7DTGOAXotMc+x8VMsoduq0+rJEdA1pUVvNEvt3mx8kRY6z65CEhqSZDsO2P5GqgigYGbUnP0gPr+r6yg7g6SgaB1WlFlFOVb5ac8xuiJ3SFpRdTJ08RyeEZTFLDkw5gwfaltV6lxKTRsei6q86JYNuxH/B3VnQ2/+F912qtIQTgdJtcYY6lddLF7Y7wfT/TGb8Qq8nAK5zP//TYDefweERDDKafGnWOdFKB06kMmCFcxd70Z5flnTCLkZbPsxNquZ6tsKunDx+6lkcxjCKXQNyZSaOfu8+jahLOFFIIESeMLTD0ewTwcPmGIMIkDLRarwlTWcJ7UERRYvFLrMvTvE+0Wgl15uoElwTaDMU3vSkM+buEK7J+Cl7FsoLNsnsMSQZqCo9nvKAwHcuYGIdCWdrtZJcR03sgRrMHKjdk19Dcxgs2raqERvy7ziiInCF3A5rj4BJbCweqkROUkSlve8S0gL0aYTh0FUQPalRvm/KjiMipPvt8keiCYT3Q4gcPnkbHYW3YugtmTqcUhrYKNE3mAdQgkhmKptXKy42J0sg8qQ+VU+PJpNiv8Fvz7w4NyqSnvu9Hi3YWsLxKgJxOf54/lKQaRnFLSNYE+idZUG2mMOkT/TJfAfzJQkpcyLoMIRy5tyUOnQ2LTfEqTV1jnBEKSJr47gWhQBp0OuJY+qVNYNDQxThoraxOM3dYj1b+8PgAxvdB09UOMpjhiEazSjaDLuBNn5qnTpEtVQNBwz2VDMClUY+0R0MHQxj05aBQIszOypAH0WoGb1afwqisGeMzWtTEVLssUXNSkjsyGLZ06C+xRtl2TTXZILjPwy715Wmiocpa
 vuAPXM5E
 42V9MvKgaP3CFlPQb6d1cE25G7U0Kwc35BkvYQyOURdb98xgAlXDbYoRzbEpA1rplHC7syIRYrqMdlnyGAhMDRrY7pXPzTIkas4DqIleCkfpYoWZtepMaOMTXv+WVZpFzDvop9VAMY/B9Lh2mNNV2vefwix195C7txZLzl9hUHJbs/0R1j6SXthoDwnZAeafwu7cTu3XwtGX2yNWqFkvITNKeZVvlcyNNYH63NKxoThUh6rQioLDgBmZJ3oYNvqIpMm4VJ/liTXvEVQj0bqJW34rSXlIl1NZb95APWl/F7nES5pnevm9j4WHv/42+CZUMw4Y4+ZDII1TdgAPXt1slxMADEXayVUpBjb13ZwH8nFNalsuW+qh4a4dX1hJzmvU1UWf8bBlzMSMskAaHttJBvH1wOM+UHD6Xy3k+2joKC4tIctisMBqhINwHDSu1QylOC5xfYoYanoeN2DFWpfTyPfHRq0OIMupq4GtWqXXRrdQIPgAK/FadYaPNLF9Rx0DWyQlZRxno/erpkn3k4uJ9gssAGEkuB4SpNEra
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 3/17/26 12:06, Balbir Singh wrote:

> On 2/11/26 19:12, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> Currently, the way device page faulting and migration works
>> is not optimal, if you want to do both fault handling and
>> migration at once.
>>
>> Being able to migrate not present pages (or pages mapped with incorrect
>> permissions, eg. COW) to the GPU requires doing either of the
>> following sequences:
>>
>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>> 2. migrate_vma_*() - migrate the pages
>>
>> Or:
>>
>> 1. migrate_vma_*() - migrate present pages
>> 2. If non-present pages detected by migrate_vma_*():
>>    a) call hmm_range_fault() to fault pages in
>>    b) call migrate_vma_*() again to migrate now present pages
>>
>> The problem with the first sequence is that you always have to do two
>> page walks even when most of the time the pages are present or zero page
>> mappings so the common case takes a performance hit.
>>
>> The second sequence is better for the common case, but far worse if
>> pages aren't present because now you have to walk the page tables three
>> times (once to find the page is not present, once so hmm_range_fault()
>> can find a non-present page to fault in and once again to setup the
>> migration). It is also tricky to code correctly. One page table walk
>> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>>
>> We should be able to walk the page table once, faulting
>> pages in as required and replacing them with migration entries if
>> requested.
>>
>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>> which tells to prepare for migration also during fault handling.
>> Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
>> is added to tell to add fault handling to migrate.
>>
>> One extra benefit of migrating with hmm_range_fault() path
>> is the migrate_vma.vma gets populated, so no need to
>> retrieve that separataly.
>>
>> Tested in X86-64 VM with HMM test device, passing the selftests.
>> For performance, the migrate throughput tests from the selftests
>> show similar numbers (within error margin) as unmodified kernel.
>> Tested also rebased on the
>> "Remove device private pages from physical address space" series:
>> https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
>> plus a small patch to adjust with no problems.
>>
>> Changes v4-v5
>>   - rebase on 6.19
>>   - fixed David's email address
>>   - fixed link issue without CONFIG_TRANSPARENT_HUGEPAGE
>>   - refactored into smaller commits
>>   - added more comments to code
>>
>> Changes v3-v4:
>>   - rebase on 6.19-rc8
>>   - fixed issues found by kernel test robot with random configs
>>   - fixed typos
>>
>> Changes v2-v3:
>>   - rebase on 6.19-rc7
>>   - fixed issues found by kernel test robot
>>   - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linaro.org>
>>   - fixes to lock handling (pmd/pte) on errors
>>   - added assertions for pmd/pte lock states
>>   - other issues discovered by Matthew, thanks!
>>
>> Changes v1-v2:
>>   - rebase on 6.19-rc6
>>   - fixed issues found by kernel test robot
>>   - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
>>     parts if migrating
>>   - other issues discovered by Matthew, thanks!
>>
>> Changes RFC-v1:
>>   - rebase on 6.19-rc5
>>   - adjust for the device THP
>>   - changes from feedback
>>
>> Revisions:
>>   - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
>>   - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
>>   - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/
>>   - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/
>>   - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@redhat.com/
>>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: Leon Romanovsky <leonro@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>>
>> Mika Penttilä (6):
>>   mm:/Kconfig changes for migrate on fault for device pages
>>   mm: Add helper to convert HMM pfn to migrate pfn
>>   mm/hmm: do the plumbing for HMM to participate in migration
>>   mm: implement device page migration for HMM pagewalk
>>   mm: add new testcase for the migrate on fault case
>>   mm:/migrate_device.c: remove migrate_vma_collect_*()
>>
>>  include/linux/hmm.h                    |  18 +-
>>  include/linux/migrate.h                |  27 +-
>>  lib/test_hmm.c                         | 100 ++-
>>  lib/test_hmm_uapi.h                    |  19 +-
>>  mm/Kconfig                             |   2 +
>>  mm/hmm.c                               | 814 +++++++++++++++++++++++--
>>  mm/migrate_device.c                    | 602 +++---------------
>>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>>  8 files changed, 1053 insertions(+), 583 deletions(-)
>>
>>
>> base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
>
> Thanks for your patience, I am just trying out the patches and reviewing them in parallel
>
> Balbir
>
No problem, and thanks! btw there's also v6 it has only two minor changes:
https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpenttil@redhat.com/

--Mika



