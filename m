Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A5FCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 19:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A476B0005; Wed, 13 May 2026 15:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31DB6B0088; Wed, 13 May 2026 15:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48046B008A; Wed, 13 May 2026 15:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94BAE6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:53:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 437D01A0462
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:53:53 +0000 (UTC)
X-FDA: 84763447146.29.066F11B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id EDB1040005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:53:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NorOiyVu;
	spf=pass (imf27.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778702031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjFJ6xkcThQO6uaR5c4WCYeu7ze7JvLAoJZ1WfmzNyQ=;
	b=xZ863FYkFL35dydb3ydhz16ZNJU+xMd5u8WXUtpLTQL+dKzXqzxF8MI2m1wCKhVNta+0g3
	jaSXN1QvZw7eDE+A4q1sxB1rOjP51yUSQ92P16gy8+vgtqVm/aSWfGIBok5jgrB2TEk29v
	h4wkDqQ78fU7nqSvuXt0WsFk25UVfhs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NorOiyVu;
	spf=pass (imf27.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778702031; a=rsa-sha256;
	cv=none;
	b=pqS8PJBp4JVs8YoAYIDBOON2m3P1uS66exajfmXwz+UmqYXDZtwViNlfDYNLhsjzKnCnce
	blESwlcpoZ+dNiyDJ2tMsy4t+P5Dj88TMiTBR9U7xVi9jvZvAXMjGFozDtch3xc7ksHvUa
	VAOrd60q+KIz6eiGfOvvYB+bv/zo1OA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778702030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OjFJ6xkcThQO6uaR5c4WCYeu7ze7JvLAoJZ1WfmzNyQ=;
	b=NorOiyVu+kbmtNC6Zja7vbGHNklSw4EiwAARQnyYUfsccFor6faXN4kvZrsFdFjUYqnU1P
	G7ZRh5PdGi79Qdl8FyFiU4MhWjqoF28KHt6XVSZv/KmDQD1sMyHJnjnnGtk4dWL/XZu3GK
	ytmqLbqQcvlE4GYtLaRThMe04FlZ2Gc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-jzPmQJ6dPEqCGSnvFjqYLA-1; Wed, 13 May 2026 15:53:48 -0400
X-MC-Unique: jzPmQJ6dPEqCGSnvFjqYLA-1
X-Mimecast-MFC-AGG-ID: jzPmQJ6dPEqCGSnvFjqYLA_1778702027
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8aca29dcd69so175156486d6.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 12:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778702027; x=1779306827;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OjFJ6xkcThQO6uaR5c4WCYeu7ze7JvLAoJZ1WfmzNyQ=;
        b=gLzXHK3qwwil7RUcHrE0Oss5YR8YkDHsLCrSuSzUd9wtzqHC/U7w1rWzCqWv3MrSiE
         udno1/9otXtt3XIgDJp2BOdP+iB17DDaRJtiHCM/hlQvoNheeous3QQb4Mf1O+pTWMIw
         mxeuagfjnMgnq1v05fsCiZQnQbcvQDgAwTgpx/qg+YcJ6HDfT1GO1q5bgelBHxZ0BEp2
         9ngWnhDulnJKZwYQrcIR5n9PE0pTdVVVnI7WFtax2ea5F6LsCq6rj1WZ2FOsuluYr0bV
         SLu3kBXPfA0jRKj87iEz7AosY2PDPR/k8z9dMls7Bd3ZiyCYyE3VTPUYgATx8JXSB4NX
         yqhQ==
X-Forwarded-Encrypted: i=1; AFNElJ/8+X19sJ3D+ZTBVNzAYN3Bdc2cSwMLfh0sg/4ajqeI3PpOlcToMHT3gmelGHlB8TA0+FfMrFYIeQ==@kvack.org
X-Gm-Message-State: AOJu0YzXJOv5UAz4GG6LGU48DF1/cFJKVtqcRh8RkEj2TSvi96cBUpaB
	CzmQI7h+tN9lyNNvsOjnnuuxC+iAyAIbjl50+IXR0YJ2rEIkrEiAAMpBh7ZCutjnTApwoScB8QS
	gKHCA1+0wfewOWCL3yAgReHozqYmRiPj+FayCIsrVgKQrvrO7simD
X-Gm-Gg: Acq92OEqrkZvt6zJaVH73LjnLlPPJ+EzcU/Ip0/35IQ8DZxCxQti91UzM6dMAb+Sz+W
	nW1C7wAmRk7M7BYAfjsq/WJv7lPCvuRk2hDn6gElFGQXGliho1WfI7jYoQ6m3FWAJ7VHQgrok59
	RBJuW/LJUigYU+ItKgoMDORri719eIBDRdJ5gGus+Puvse/9yb/WblKvJMeQ9EethYYJZd/7oht
	nFMgDYTSd4uf9dqK/H1+LRtkBSF/LsKdSMYmL6OQcXeW3WG00/VuFKy//3EHYmXvet/DSEGxuG0
	wXuoYC0LnAZv8fML/SdPesj6N4de1LTU3mPg7nw0jm3v6/dtWhG1fZCFTr2/zRL4d2XvcOjelOF
	oRsFTXp4kxGTylpK+W5dcLTyzN9BrfufXL4M9BQI9dfUJ6nAHk+iDI+z3aPLqTb/QR92LVPaeLJ
	1/CspMOOV8DZLpImLVM1yDqUg=
X-Received: by 2002:a05:6214:3198:b0:89c:806c:93 with SMTP id 6a1803df08f44-8c7bb0cf75amr76266876d6.30.1778702026801;
        Wed, 13 May 2026 12:53:46 -0700 (PDT)
X-Received: by 2002:a05:6214:3198:b0:89c:806c:93 with SMTP id 6a1803df08f44-8c7bb0cf75amr76266146d6.30.1778702026202;
        Wed, 13 May 2026 12:53:46 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90bb8241dsm4617986d6.34.2026.05.13.12.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 12:53:45 -0700 (PDT)
Message-ID: <e25811f5-8f5e-4ba5-8eab-95e351c94e95@redhat.com>
Date: Wed, 13 May 2026 15:53:44 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/55] make MM selftests more CI friendly
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Li Wang <li.wang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260511162840.375890-1-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LpLMMbfMwcF27ShUJRqB2MooSYcg0_YA4tdNO9YFs2w_1778702027
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EDB1040005
X-Stat-Signature: rw9gk5t4qtftsd1whok1cca6iju8yrab
X-HE-Tag: 1778702030-990124
X-HE-Meta: U2FsdGVkX1+BpzepRigmj95cfEKxtc0ZYUF/VbtVtTEw1s2SisRuxEfeUrgG5MnwFG7RJhvLukz1rXmJld7+5fCG6eKzcsrA8unzDsvZCGv32FuqWnWKBLSw6dl8QTA1DWoFWXjCXki2LXDidjkjUrxSRuMRcNduuEoomuLO4BkQNOnAHeukMf5Eo6hJCZ2w0p+Hg6vOnW028Pfg6Vq+f3bcFkqEyaKO8Pk8wX8XYbEyB7GvVzpk3ROh5L4V8AVXIsmpMnBnP5qIAwWwEUVv7jIkJkEqwfPBdPTJSDUuYFQGeqd0pbV/C//rhap7aqH/4V8MZsoJLSNTMN/o4TCaqkTrafWC1JZweEF4HfDFRmya2oAQ4i/H4xI34XTlJzbBE9ze/BnFDDq7RUolt8W8ClSkb8j1VgOmM5rPTY3xc8Sdozbpj8iaII6Pwy8sJwzqPez/KE6yBr1V5cRXl1gKu8RhlypMbMzL761efTcqf85s0y5WtoUDJVaVBgOKu2cOHaHIzXsTOe4L/3tn9Ya9WjLeSuafQPh377kpv1Aj9uZoObDQ7kXmDfyk/cqZzNP8iGT9eCuXGrtbKg/AifxD2l6Ivk1S5FNNrDHVgqDDq7xw1xZ3n4tqnzkSHCh7zyvRAWBI3no7aClBNQ29N8Z7dXkOncuENsJzPhNMr5XTv/67iJR84tg0n3WDg4n228NvNLXeoih/IA5CG5WJ1obhAudjohPXdj8AX0AnH5Rug/FoNUhOEkoBcjs+/2AikvSqDUlMFnjh9RZ5rfkRP1yQ/2CJCXgh0Uhg24X/HRX+iqFigJU1fbIYeWKILTDaUmh/JWbtwYNxtkP+N6W1OP0z6SNjuGIFSLzuAJ830W4OYsN3t9k4Bp13SNMLio7zuhoYfCoTv29upFAsXuiTAyNxDkys4J37f6Yypo419RStbRv2vy3x0K5xOpMxyZZcYovQSzo9WwD5j4JYLiMgmoo
 uI4XSD21
 AmexPCRttt1e6meymIw/+CI7y4k2xsOmM6qxc8+ATumVGEXrcZqadbo0vHP49OlXUtwjN0njQqzC6HlFT2LExdoU55cPeTNL5xrTmYFYBMILb+aGj4OFBPeBcDN8U5jXxKMhlBSeRaxufJN1fSGmgybrp0qZ+DVURXtaCEw6Vm27q4tsGa/KPZdbps756WenH9bpso+FVK+5mia2Zl9RJPY3dompbCfKzfCzeowSezpl7Mg6pRJCJMWaI51A93EcaoswRkUcxROauhDDY5DNYTY41zsBryMywLuZZIDJhLVduNeOIfO/N6/c+9yEARpsRDcbO1wImYbf52uRxhSFuKCGDD3D4Km5UAzidCErrgP8GqZ80pKuNxeTlplZv9hwmMK+UhoVuevFgRnW8Jwb1pSudRtfJ+hnTUFDCuHKbPwH2wSTKFq/FDJvyzQERdkWPVCnsktWTvfZC0K4OcR5605Uog8e6Qr6OCg+JL3Oe3B+QLuq4EMC/gu6z0/OPTIDqkPFIrtTg9JMp8QjuGYJDUnpDQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-11 12:27, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> There's a lot of dancing around HugeTLB settings in run_vmtests.sh.
> Some test need just a few default huge pages, some require at least 256 MB, and
> some just skip lots of tests if huge pages of all supported sizes are not
> available.
> 
> The goal of this set is to make tests deal with HugeTLB setup and teardown.
> 
> There are already convenient helpers that allow easy reading and writing of
> /proc and /sysfs, so adding a few APIs that will detect and update HugeTLB
> settings shouldn't be a big deal. But these nice helpers use kselftest
> framework, and many of HugeTLB (and even THP) test don't, so as a result this
> patchset also includes a lot of churn for conversion of those tests to
> kselftest framework (patches 7-19).
> 
> The series break out:
> patches 1-5:   small fixes
> patch 6:       merge of hugetlb mmap tests
> patch 7:       renaming of hugepage-* to hugetlb-*
> patches 8-21:  mechanical conversion to kselftest framework
> patches 22-28: extension of thp_settings to hugepage_settings to also include
>                 HugeTLB helpers
> patches 29-30: add helpers for setting up SHM limits in hugetlb-shm and
>                 thuge-gen tests
> patches 31-53: integrate the new APIs in all the tests that use HugeTLB
> patches 54-55: drop HugeTLB setup from run_vmtests.sh

I re-tested this as I did for previous versions and it works for me.
I see my my Tested-by is already there, but just in case:

Tested-by: Luiz Capitulino <luizcap@redhat.com>

Also, this is a great series Mike. Thanks for doing it!

> 
> --
> @Andrew, I think it's good to go now.
> 
> I'm sure Sashiko will still have somehting to say, but there is really a lot of
> room for imporvement in our selftests and with Sashiko being overly pedantic
> we'd be stuck forever.
> 
> v4 changes:
> * rework fork()ed process cleanup in migration test to be more robust
> * rework HugeTLB setup to use free pages before allocating new ones,
>    add hugetlb_setup_default_exact() for compaction test
> * guard against double save/restore of THP and HugeTLB settings
> * convert uffd error macros to use ksft reporting
> * fix ksft reporting in several tests
> * gracefully bail out if default huge page size is 0 in several tests
>    and gup_test
> * add more tags, thanks everyone!
> 
> v3: https://lore.kernel.org/all/20260428204240.1924129-1-rppt@kernel.org
> * add patches that fix cleanup of fork()ed processes in migration test
> * drop MADV_REMOVE changes to khugepage test
> * properly setup memfd for non-default hugepages in hugetlb-mmap test
> * add forgotten hugetlb_save_settings() to hugetlb_setup()
> * fixes for ksft reporting
> * rebase on v7.1-rc1
> * add more tags, thanks everyone!
> 
> v2: https://lore.kernel.org/all/20260418105539.1261536-1-rppt@kernel.org
> * fix hugetlb mmap tests to actually test file mappings
> * increase maximal tests number in khugepaged
> * add tags, thanks everyone!
> 
> v1: https://lore.kernel.org/all/20260406141735.2179309-1-rppt@kernel.org
> 
> Mike Rapoport (Microsoft) (55):
>    selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
>    selftests/mm: migration: don't assume huge page is TWOMEG
>    selftests/mm: migration: make nthreads represent number of working threads
>    selftests/mm: migration: properly cleanup fork()ed processes
>    selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
>    selftests/mm: merge map_hugetlb into hugepage-mmap
>    selftests/mm: rename hugepage-* tests to hugetlb-*
>    selftests/mm: hugetlb-shm: use kselftest framework
>    selftests/mm: hugetlb-vmemmap: use kselftest framework
>    selftests/mm: hugetlb-madvise: use kselftest framework
>    selftests/mm: hugetlb_madv_vs_map: use kselftest framework
>    selftests/mm: hugetlb-read-hwpoison: use kselftest framework
>    selftests/mm: khugepaged: group tests in an array
>    selftests/mm: khugepaged: use ksefltest framework
>    selftests/mm: ksm_tests: use kselftest framework
>    selftests/mm: protection_keys: use descriptive test names in the output
>    selftests/mm: protection_keys: use kselftest framework
>    selftests/mm: uffd-common: use kselftest framework
>    selftests/mm: uffd-stress: use kselftest framework
>    selftests/mm: uffd-unit-tests: use kselftest framework
>    selftests/mm: va_high_addr_switch: use kselftest framework
>    selftests/mm: add atexit() and signal handlers to thp_settings
>    selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]
>    selftests/mm: move HugeTLB helpers to hugepage_settings
>    selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
>    selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
>    selftests/mm: hugepage_settings: rename and rework get_free_hugepages()
>    selftests/mm: hugepage_settings: add APIs for HugeTLB setup and teardown
>    selftests/mm: move read_file(), read_num() and write_num() to vm_util
>    selftests/mm: vm_util: add helpers to set and restore shm limits
>    selftests/mm: compaction_test: use HugeTLB helpers ...
>    selftests/mm: cow: add setup of HugeTLB pages
>    selftests/mm: gup_longterm: add setup of HugeTLB pages
>    selftests/mm: gup_test: add setup of HugeTLB pages
>    selftests/mm: hmm-tests: add setup of HugeTLB pages
>    selftests/mm: hugepage_dio: add setup of HugeTLB pages
>    selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
>    selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
>    selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
>    selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
>    selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
>    selftests/mm: hugetlb-shm: add setup of HugeTLB pages
>    selftests/mm: hugetlb-soft-offline: add setup of HugeTLB pages
>    selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
>    selftests/mm: migration: add setup of HugeTLB pages
>    selftests/mm: pagemap_ioctl: add setup of HugeTLB pages
>    selftests/mm: protection_keys: use library code for HugeTLB setup
>    selftests/mm: thuge-gen: add setup of HugeTLB pages
>    selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
>    selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
>    selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
>    selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
>    selftests/mm: va_high_addr_switch.sh: drop huge pages setup
>    selftests/mm: run_vmtests.sh: free memory if available memory is low
>    selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB
> 
>   Documentation/admin-guide/mm/hugetlbpage.rst  |  15 +-
>   tools/testing/selftests/mm/.gitignore         |   4 +
>   tools/testing/selftests/mm/Makefile           |  13 +-
>   tools/testing/selftests/mm/compaction_test.c  | 115 +-----
>   tools/testing/selftests/mm/cow.c              |  31 +-
>   .../selftests/mm/folio_split_race_test.c      |  25 +-
>   tools/testing/selftests/mm/guard-regions.c    |   2 +-
>   tools/testing/selftests/mm/gup_longterm.c     |   5 +-
>   tools/testing/selftests/mm/gup_test.c         |  15 +
>   tools/testing/selftests/mm/hmm-tests.c        |  24 +-
>   tools/testing/selftests/mm/hugepage-mmap.c    |  78 ----
>   .../{thp_settings.c => hugepage_settings.c}   | 316 +++++++++++++--
>   .../{thp_settings.h => hugepage_settings.h}   |  82 +++-
>   tools/testing/selftests/mm/hugetlb-madvise.c  | 215 ++++------
>   tools/testing/selftests/mm/hugetlb-mmap.c     | 143 +++++++
>   .../{hugepage-mremap.c => hugetlb-mremap.c}   |  15 +-
>   .../selftests/mm/hugetlb-read-hwpoison.c      | 121 +++---
>   .../mm/{hugepage-shm.c => hugetlb-shm.c}      |  69 ++--
>   .../selftests/mm/hugetlb-soft-offline.c       |  45 +--
>   .../{hugepage-vmemmap.c => hugetlb-vmemmap.c} |  46 +--
>   tools/testing/selftests/mm/hugetlb_dio.c      |  15 +-
>   .../selftests/mm/hugetlb_fault_after_madv.c   |   9 +-
>   .../selftests/mm/hugetlb_madv_vs_map.c        |  22 +-
>   tools/testing/selftests/mm/khugepaged.c       | 380 ++++++++----------
>   tools/testing/selftests/mm/ksm_tests.c        | 182 ++++-----
>   tools/testing/selftests/mm/map_hugetlb.c      |  88 ----
>   tools/testing/selftests/mm/migration.c        | 147 ++++---
>   tools/testing/selftests/mm/pagemap_ioctl.c    |  13 +-
>   tools/testing/selftests/mm/pkey-helpers.h     |  15 +-
>   .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
>   tools/testing/selftests/mm/protection_keys.c  | 130 +++---
>   tools/testing/selftests/mm/run_vmtests.sh     | 174 ++------
>   tools/testing/selftests/mm/soft-dirty.c       |   2 +-
>   .../selftests/mm/split_huge_page_test.c       |   2 +-
>   tools/testing/selftests/mm/thuge-gen.c        |  96 +----
>   tools/testing/selftests/mm/transhuge-stress.c |   2 +-
>   tools/testing/selftests/mm/uffd-common.h      |  18 +-
>   tools/testing/selftests/mm/uffd-stress.c      |  43 +-
>   tools/testing/selftests/mm/uffd-unit-tests.c  | 138 ++++---
>   tools/testing/selftests/mm/uffd-wp-mremap.c   |  20 +-
>   .../selftests/mm/va_high_addr_switch.c        |  42 +-
>   .../selftests/mm/va_high_addr_switch.sh       |  41 +-
>   tools/testing/selftests/mm/vm_util.c          | 134 +++---
>   tools/testing/selftests/mm/vm_util.h          |  15 +-
>   44 files changed, 1500 insertions(+), 1609 deletions(-)
>   delete mode 100644 tools/testing/selftests/mm/hugepage-mmap.c
>   rename tools/testing/selftests/mm/{thp_settings.c => hugepage_settings.c} (58%)
>   rename tools/testing/selftests/mm/{thp_settings.h => hugepage_settings.h} (51%)
>   create mode 100644 tools/testing/selftests/mm/hugetlb-mmap.c
>   rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (92%)
>   rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (55%)
>   rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (76%)
>   delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c
> 
> 
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> --
> 2.53.0
> 


