Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F3ECA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D5B8E0009; Thu, 21 Aug 2025 06:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8249F8E0003; Thu, 21 Aug 2025 06:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762118E0009; Thu, 21 Aug 2025 06:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 683B88E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:34:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09E6F14032B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:34:54 +0000 (UTC)
X-FDA: 83800406508.22.4E55EFB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5142160007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:34:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755772492; a=rsa-sha256;
	cv=none;
	b=c/fGubPa5xFsy2YntVfHgbHLwE+8qX8lFsAKk6V+el/Zu/GGbR1kfHUC0Tl4J5KXnR8bcq
	CNZG/2U2jSQt4zX2KQI7wuJkvNEkKiuIB2h/ZGuj7MnrHc5lAeP+viIZGOcgJSEifeEWyq
	LYswXLMhFShmYlhu08ySlUUHql1iBtE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755772492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+OLfCyXr2CrZmXchqbRfbJ+rDJLfW84SDNBllWsEol0=;
	b=8fLY5k5+g7P4S077xuy8hEc5bCxAvLNCeWlx6iW44JYowm5jNAV8dYRIYbrFey3dHx/dgy
	mbC29/BSnu7jDuvDAuM3n2l20k14qQvE2+KTvUJ3pdokxD0A6EfCczEQ/eo4nQmEgF9QGO
	mFoLlQd+b9738ci8BKX+3kbmikbCpHc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3830C152B;
	Thu, 21 Aug 2025 03:34:42 -0700 (PDT)
Received: from [10.57.91.188] (unknown [10.57.91.188])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 334CD3F63F;
	Thu, 21 Aug 2025 03:34:44 -0700 (PDT)
Message-ID: <f997a8ec-26aa-45f3-a757-d221321c8607@arm.com>
Date: Thu, 21 Aug 2025 12:34:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] selftests/mm: Add -Wunreachable-code and fix
 warnings
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, Shuah Khan <shuah@kernel.org>
Cc: kernel@collabora.com
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
 <20250731160132.1795351-2-usama.anjum@collabora.com>
 <c09a2a13-8571-44e5-b780-c704598df764@arm.com>
 <46dce2ac-adb5-4a6b-8847-fe214c1599a7@collabora.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <46dce2ac-adb5-4a6b-8847-fe214c1599a7@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E5142160007
X-Stat-Signature: fd7wopy4u5ubd6y3ygufaykpxqxhct9w
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755772491-118867
X-HE-Meta: U2FsdGVkX1+XXeBQVTVj5GJNru1gm+SDdf8W5rHox+6+D4NotqmicJeMPN33jCzjoADYXibKN6ik5nQ+c9DGWGWwZMfhqp0FQQkMjiNJfugxSKMwd+UrZYLDOVRlThwSREx8dbm5FAeA6g5KUhIanlX+RK8CqAvhRJZYtRXHzFC/8MbqA4oYlU+uSc//y0eDpscxWIRTLs6ai/5Oedd+g7ii/3D7jeDlh6XfBzecbOPkm2K4avho3PXDYyhZySjApGq5vDFeR8UkSoyAo//uXcxAabmBHMC4YsJtT5PKsQcanerqWCWUm6jkwnlb4FNgPjrOJ4CTPfZqOEeJ/5usktNTJlRihjXnuxaRB0K+v2IdMnc2GTTkZbKYEQTwRQxNKBCmZW6vEDbKZuyxvbPoiX85RsukA6p/rg8Y6qDEjVz8iEkyXnj+u26Z+BOAgAYqlQbU30tcuWihAWWjOgpBJ5QYCIkvpqnarrLKIWLa/DCtVy3rdlveTPNo/Yux663/QHnIQdGs6jziV/XQllG7bckAPD0AVm32tofU2Rnzun0GtN+xIrNvxMF3WfS1BsD1Q2LVHwCMx0HbGd7/6wiNMVFvENoVRTqQOdNVW49s2F+SC9LG0PFvuSdgUFsETgbNQbPCSrsgoQ6A8wSgHT//OThb92It4y40lcpHdBH/rdEfOOdE69agSuAX5Vgypvh7b7lVKmhNJRqm0rixiNhLoqE+ruyMKyRtS9Hbf0kRHX0l3gkwhfP24uOcyGqWkot8IShsQlmF6D+y5AVX+mEqyCNAD35BcDqHQ9u9xo9tGaaF6jjMoqGdkVLv+wysSre+Xl7mfqONowz/q0C13Mxa6J8gkC3zmJryjkJ+s8kuY0VWyAyxmel7q6s18ukFWaWJGRRQrmJV+OAw3+uAspqlFK4Dz9qTeGQbPu+XlpOlzmpsAg6VzVcKNrkd+TlPjGd+n8PItVXiIgftrBAycr3
 VhfAR1eQ
 3XW+IsoycnIYE74UbGsPu/tIxU7fs3jiKS5WrPax48ImKRgP+jb1fODSgeiHF0sZOaTFpapwOPTWXJeIjkNRKsq5eIrerF+CBiJ8u4qeIIW1r8/iC346G0F2vLsZ4WasD6HZeDHURmtYbLO4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/08/2025 08:19, Muhammad Usama Anjum wrote:
>>> [...]
>>>
>>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>>> index 05de1fc0005b7..a85b2e393e4e8 100644
>>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>>> @@ -296,10 +296,8 @@ void split_file_backed_thp(int order)
>>>  		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
>>>  
>>>  	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
>>> -	if (status >= INPUT_MAX) {
>>> +	if (status >= INPUT_MAX)
>>>  		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
>>> -		goto cleanup;
>> At that point the mount() call has succeeded so I think we do want to
>> keep the goto and just print the error message instead of calling
>> replace ksft_exit_fail_msg().
> The cleanup tag does cleanup and then calls ksft_exit_fail_msg() without printing the
> actual reason of failure. So current flow seems good where information about the error
> is being printed.

My point is that with this patch, ksft_exit_fail_msg() still causes the
test to exit right away without the cleanup steps (i.e.
unmounting/removing the directory) being executed. Printing a specific
error message is good but we should also run the cleanup steps.

- Kevin

