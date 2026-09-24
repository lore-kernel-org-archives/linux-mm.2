Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC69C9830D
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 00:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60B26B0088; Wed, 23 Sep 2026 20:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11D26B008A; Wed, 23 Sep 2026 20:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B004A6B008C; Wed, 23 Sep 2026 20:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 884926B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:10:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D83FCA0128
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:10:52 +0000 (UTC)
X-FDA: 85246725144.01.6375D08
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id C84D6180004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:10:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IYdpj11J;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790208650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQq8mahuuqrFopJghWcTwTNWIgqjB8mu7IEWM1TnLbs=;
	b=QagLL90QkhFMgMSG5EUe7O2ORMac6ans/wYJnGs2qdAc3wSlMHLZPsOJtLoAL1r6GR+a8k
	JAzYhSYV9gRCzQFryNkSCMAy6cSk8PhKwfbJti4ml7ASRwWfA6V2Mz0ePLbxk696PbUeSA
	PhTW88lgJXBRQvZuVhDfiRijPv0CUyY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IYdpj11J;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790208650;
	b=ChkOB8l2bAHeotUKfAP2kdufNN4A7ZcycjoVzWfvwzmZxfFpgpVe7Rv4jDtGZCSrh9MaIZ
	WVfgGVbb+kOxelXfpghLEZFRh6a/PUiig3ma+pREbMmCp3iOaDSYvxWX8l30hlnA3cC8hy
	6c1Yv8F9wnPaTFiXBYkJRBnoFvpuWrk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790208649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zQq8mahuuqrFopJghWcTwTNWIgqjB8mu7IEWM1TnLbs=;
	b=IYdpj11Jlb6NkP1oYpLkTcneXGzMc/pjKioFaaTs6ilZnosPz0KmoA0qljHa4kRYTYg6s5
	iMp1YBcxjBn3Sw48m1nB+m4ZU3nu9CtnBa/LnDAOuUpWzCcEzFp3DMVsAEMAem67kSDalo
	tiXQau2HMBIwUcJimp6IjD1f0kP0jaw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-5Y1iFyR9OgC6EPm_-lDQDg-1; Wed, 23 Sep 2026 20:10:47 -0400
X-MC-Unique: 5Y1iFyR9OgC6EPm_-lDQDg-1
X-Mimecast-MFC-AGG-ID: 5Y1iFyR9OgC6EPm_-lDQDg_1790208646
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5b8c58d7635so662838e87.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790208646; x=1790813446;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zQq8mahuuqrFopJghWcTwTNWIgqjB8mu7IEWM1TnLbs=;
        b=j3j0O7pi8VmlZzuEfFzs5JZG1KflHu/JAUQ37zn4+5XcpCwe4bAyF1JZ4MHn1BvBbc
         JYjNL2h8FFtqcwswYLIuGYuLJgx8y07+ZWBz3Vr6ed0Wvx+sHiyU4jzr9bHAd+4tu4np
         GihBJyMdy3OlWb3MSrJ+QQd0yies7iSFnSWECXq3tFortwf+8/m/Rl9aaX4MHXwlEJNm
         lySYy2y5bOgsLoWCzmtfukqmxm1t728f/HXTcTnDXj9pvF9HJUeVdebhr+Uu/HwNpaeG
         nwP0pjWtI/u41PLMMmkZfnqYfRCMH0gqOz7MGOh0bt3V5C1+zh0VFTVLuL0yLPfHkQ1k
         b6hg==
X-Gm-Message-State: AFuF++nT/RNIkJZdcoM9axUU4fw7iZK/C7TrkuzKG90FZBJGxQXBw2sI
	2rjkLfSSkTUG4RpupUfommZEtHEOHgQP2xIt4WdeBvQP610ZQsV8mmNKoA0Jk62Ftsf+jQZ8P3g
	Y/thFFjizSnUf8KbyrfLceVhijvnwJuFnQOZtBVxA/SyT665IeGs=
X-Gm-Gg: AYBFou1V5HtxWL98jXS5EwtNZ1UO5lRdkgm49K+fXDZppayfodcDrUrz1dhZlnL387C
	PySZ358QqlsBEt5N9NIBkwh3bRgXojZWX5NV/SmMN/Hbhkg5OoyPrTE7pZZaS4kGdjgeFYr8FG0
	T6j+2fPTZHMQgk5XrX6UOqAcGJhfBLm6lbzYgKVke8vOnHV9OxB0vSoHrd/igTw7Wa3GwjAI4yj
	nm8WCXJydXBDMTxxbaYLFsURMTbpTvUD7L3ciWS6U777ZHDk1zxX9W6qXfFwqqXDnQcgHZVM7z2
	CvAobcGtlIaUKthq7itLPgLhnr5Bs6qz87aOGeH621NopslUiafMQV4H76Jz1bERrz/TBoSOnED
	Wll3v+DYKu3q+veUhxBnFPSC92hNSg94=
X-Received: by 2002:a05:6512:6cf:b0:5b6:184c:7daa with SMTP id 2adb3069b0e04-5b8df09deddmr250425e87.51.1790208646151;
        Wed, 23 Sep 2026 17:10:46 -0700 (PDT)
X-Received: by 2002:a05:6512:6cf:b0:5b6:184c:7daa with SMTP id 2adb3069b0e04-5b8df09deddmr250403e87.51.1790208645639;
        Wed, 23 Sep 2026 17:10:45 -0700 (PDT)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d8552dafsm963966e87.7.2026.09.23.17.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 17:10:44 -0700 (PDT)
Message-ID: <63211ea4-9eae-4241-8926-9e81334c5f7a@redhat.com>
Date: Thu, 24 Sep 2026 03:10:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] [PATCH v14 00/12] migrate on fault for device pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
 <20260922192726.90dec3c4c77b8c9063dbf218@linux-foundation.org>
 <5b1d0fa6-d183-446e-bc52-56e0afd3f398@redhat.com>
 <20260923141936.d1f9e5b85355f0bdc6a6ecd2@linux-foundation.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20260923141936.d1f9e5b85355f0bdc6a6ecd2@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8c21hYB4HRzZZjRUgoFTHn1FSfmY2MdGemFHrQMgLTQ_1790208646
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4i3ypxxm4uqcw56ffihggfx5optzjefa
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C84D6180004
X-HE-Tag: 1790208649-72394
X-HE-Meta: U2FsdGVkX19Wj3SCf8RloKXfDXTy+cEi/EYgkzc+6ADrZxwWbo1AOZA47xg50+wEzqz9UvS2tv8ri+zqQnbFYlvAfaSbKg8t1JX3k+VGgRKregtUfdLEG9xxBXea3QvfdlqH2YAe9dOZ1okejEEysGf+zlGFYpIPyJVTwCZwX3ryzXHcmOseeHQmrW1pL0/UAfLUfvZWJQtcIXp9hwJ90QjvOw8LCu4anaTr4q6KAxDumxECmDrVfV6D5iEzhmkVLeyHLTJPK55vFU/NwD3HXnDpTXasoa+VUXOiyv7Fk9YgtOv7tPkJ2V1j5aBrJfYsrO0bxjUxkUf05Au5RmkZnMZn2sW3zew+UzgMMhRfPztJ82IvYkaTV5p4UNnOzXXJRWRy1ZbB59Hqq6tqrpsdrxR1jMHAxwF7TEoq/pxOT5vvwGzWhOQng9yGD0X1DnedysQDtyv11pELODGTFayuVbk1vhOTSY4C7a7/gzQQTtNNxGmoU7qvyBLyEnBXOk391LdT4rROlqtzaVftSG3ByltNvJUixicK1rCkDH7rRNVIYiEShZWmSayGMgKitxtZmpiv99MSJ884xwJvCuY6vtHv/lFJWzPPEtkRx2U1YyzS1NoU+tYJSX6Vu7VC7nQgu6Vfj4lvVMbblD2FVXp9GBOdie6BoOj9+D4lphkHRf7Mtpy8E8qtLfIAhfjAdBuRValMpDTZoJUaoAhO2ejyJiqhlo4HUhj77CPrESqXGVpdFL5brTg3UHh95YZ7v2GCC0elfdQnUMCIluF3AUeAG6KnG4aLbq1v4ix1FZQOSMg045ljp54AUtk7duo6fDeorPsIkZHMi+nrbx1SDu1EQ0eNbD7zIlYnAzVWAxjU2Rd3KseQE+CEsSQDk+ETHreYAWQwRIu8DKMzFGQIDCdZEcjhzTk0XUvZwIkQezzg1GcFrXau4wQ1oiXIvXIQHwoQGstVWaW8u1PiHF4bmt3
 mKDWUMYz
 Fx8Zd7BiACYiZrtEMArlFhaWjt1XnDRH9eutTUYh8sxQw60wx0LVVTzA+rjPpXwO9ZfE/RdcsAnhTb48bSCUEGAArHFiE2Ud2WtpanyNFPhulHusBO245n5CCJoxDy5u4stNSWPLFCUtKd/ntQ3iIzU2AHWn5wPJLME7VBEuVyXsPAKcicJrH90yrcCOkdAcszI6yGWbrnaIFWOTOczEc0/mWI6Bg9jDiJY53QHZ7hB8YVT+rpdHhNzrrMFK/v/WikNqWaMNu2MKMK7WmJpGtWds7eVNNPUHhUo1A4pl2tzK6OaNnnrBf6QGZ/Iu5bmlnGv4NwicHK5p++BTncHTs0qNL+vulYY5mNoS3sjUDdllNOZ6nqAcytiC/2/W74GSX1EvUBucg0KL+o5qCIyzc0XYvrTzmCNfjvtgTqVW2Bj6PbZnx39erK+uIf6RAyP5JhM/Wy8Sq4rA0W/pCLGA+edDcxhEiqvd5JMRWvH0qkxh3ihU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/24/26 00:19, Andrew Morton wrote:

> On Wed, 23 Sep 2026 08:29:34 +0300 Mika Penttilä <mpenttil@redhat.com> wrote:
>
>>>> migration). It is also tricky to code correctly. One page table walk
>>>> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>>>>
>>>> We should be able to walk the page table once, faulting
>>>> pages in as required and replacing them with migration entries if
>>>> requested.
>>> Sounds sensible.
>>>
>>>> Tested in X86-64 VM with HMM test device, passing the selftests.
>>>> For performance, the migrate throughput tests from the selftests
>>>> show similar numbers (within error margin) as unmodified kernel.
>>> But no performance benefits are demonstrated?
>> There are no performance regressions for current tests.
>> Real benefits come if want to do migrate on fault.
>> For migrate on fault today missing pages are collected as not-present and
>> the caller has to fault them and re-run migrate_vma_setup(); folding 
>> HMM_PFN_REQ_FAULT into the collecting walk removes that extra
>> fault+retry round-trip, dropping two page table walks. Page table walks
>> are not cheap. Not to mention simplified implementation for driver.
>> Also, the vma looked up as part of the walk is readily available for
>> migration, eliminating the need for explicit vma lookup - one more
>> performance benefit. Net effect two saved page table walks and
>> one vma lookup.
> It certainly sounds that this series will result in performance
> improvements, but have those improvements been quantified?

Yes I think Alistair mentioned those walks showed clearly in perf traces
in his experiments, and that served as a motivation for this series


>
>> This series also addresses the vanished/reborn page table while
>> collecting problem which can crash current implementation.
> Oh.  I didn't get that message from the v14 changelogs, and crashes in
> the current implementation are not what we want.  In fact, addressing
> those is more important than speeding things up.
>
> Under what circumstances to these crashes occur?  Can/should we we fix
> those in a minimal -stable backportable fashion before moving on to speedups?

It is about races between concurrent MADV_DONTNEED and collecting, where the
collecting arrays overflow if page table is cleared, recycled and reinstantiated
as large page.
I am not sure if there is minimal fix to all the corner cases,
or would it be more like the approach in this series.

--Mika


