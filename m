Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B4BC87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C796B0092; Mon,  4 Aug 2025 04:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23696B0093; Mon,  4 Aug 2025 04:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12146B0095; Mon,  4 Aug 2025 04:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 920A86B0092
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:26:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE0EA161104
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:26:00 +0000 (UTC)
X-FDA: 83738392080.20.25B3D31
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 581FB40007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:25:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RGiMNGMe;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754295958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YadyPmR0dQe/epD1NUXfvpXcI1CVozsoweeY4VWaFzU=;
	b=VaqTdwCX+oITkedFypn1PHFUU4Ma5/aXY6Mcon2tAQ0NyN9uFW4mkCrUF5kAezIt5gNgdh
	P882AJZvcluB3MmjpDlejByIl8DTlyH9INeoP0ROSxIHN9sSBrozJagacXcVcjBqYNDumP
	x1wS00o7LJMpIe14coNH+ZYq6eD6EF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754295958; a=rsa-sha256;
	cv=none;
	b=qvkqZ0/pvBoPaSrqvoMxHKPwvgRgV6Mh92b0/wJKsqpDoCyUrpnriCesU/CqDOU+8d5tuN
	z6k2Jl0+feSYPjrJUje3TmNXrwOHu4MwTXG48NJmOA4TxjKuXLjVax7fXYZ/vt+RRZRwji
	53absGXhxBDSS1Yplx6k9qc177MyAC4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RGiMNGMe;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754295957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YadyPmR0dQe/epD1NUXfvpXcI1CVozsoweeY4VWaFzU=;
	b=RGiMNGMeUlg5eki+CtrSwSqbIo9loS4vCQz8jHjziwMocA5XiARWQBepRE3LwDyJymQJBK
	UEby8LH1XCoxqWizZ32Lz9ae+PSu3UfHHmhKkWKH+pn1y8/MBSnm5kVQEBSryOVc6xmLvA
	uZ3Ynjj0cpwv/v6wgP0rg6+HkBGjLbE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-NMfr7hLONFaZC2KKyrFeLg-1; Mon, 04 Aug 2025 04:25:56 -0400
X-MC-Unique: NMfr7hLONFaZC2KKyrFeLg-1
X-Mimecast-MFC-AGG-ID: NMfr7hLONFaZC2KKyrFeLg_1754295955
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45867ac308dso13447945e9.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 01:25:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754295955; x=1754900755;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YadyPmR0dQe/epD1NUXfvpXcI1CVozsoweeY4VWaFzU=;
        b=o/der1eMk77t0aNt5tAhdWgQ1gjW2XJLKfLsH1XxLEmq2e1uwPMh7q4EZ3YvVOjO0Q
         Q+3EKuKCcKn9ugLNsSqtWfruF4m2c6uKf2lMC6h+3iUgggNVcUE81rQNc6950dg2UZhB
         2wz4ZjRq8lKw24bWkUl6W2oVXtiwU87G5uPDhFephA3aDUsbGYnxIa4MMuoqULN2N/Qj
         3gdz1UUphcW2FzMB6Uk+27522IhVB9vZNtOdEik8mGLTx6V0gFwg4NaPeq9VSLOLcqxj
         mSNxehAISnm6YLbPGFQmn3b/he0AmD55o808mUPASLvhOQyUKTmEgHRCmjDVe71ChXZ/
         pWew==
X-Forwarded-Encrypted: i=1; AJvYcCV8xBZGo1uQrO0E5tkKRG0NRSiymLtalkhhJglv7N4HJElROf91YsUXeka9VOn6LMIKRxS9xBaOtA==@kvack.org
X-Gm-Message-State: AOJu0YwPb/J37p7RYpO4f/rpmXNi5sghSEj8mIn+T6bxrTplzBkIyeYc
	3G7W1y+LE2KW4HP8nrDIYH67e0kf2pK6ge1Loi/C0N9+D1xdZeeK6Y7Ix+x5A8nnoNpGt2tJBx6
	w/C5V39MJWFHUqI386quwM3RWesV0IhzctpKgGoSCwukVsZGyeDnv
X-Gm-Gg: ASbGncvq0uZW0QwiYpk28btoxN4aWzz+TLLDrPG+NJbRR4XWIq5eJXotwibp4iS5a+i
	l5GzVkTqb7ht36op1ch1sHRtXPMUG2dyADbQJPTo14PLQPLZCHoRK8BeCNgiRxU4woFkZHQCf3d
	EAkjZ1SqYz7FXU8Z3I6YjSqySVwq2RCIwvmrI3W1p0/DzGH/6xiJoKn/+mPufgB4B/Cncc7K4qf
	tgNGGMXkVdJBXROTvbRq4f8TU1eLT/Us2A+VA5A/tpFx3CMU4dzGWsDJaNicx8t+wOsTLO5Cq6V
	ewBonEFrw2H8RuqVQYL9eGniuizYM5Rq7e9ROPZGSHhDlrKI+Fuos1YOHMupsJBUKab8DP3MSuN
	kfcsf6LHK4QmZtcknPb4zOKZmPSUGawwfOwINcy8ZQNpSx4k99BDMU6kPxGBoyHUAFxA=
X-Received: by 2002:a05:600c:1554:b0:458:7005:2ac3 with SMTP id 5b1f17b1804b1-458b6b34cb7mr62843975e9.21.1754295954883;
        Mon, 04 Aug 2025 01:25:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVo07/GjP+xQ7W9mHtwrvAbGwAzbvjOvrLEMx90aOibW103VrfdK7vNJDbsTMBmrNMWhDZLg==
X-Received: by 2002:a05:600c:1554:b0:458:7005:2ac3 with SMTP id 5b1f17b1804b1-458b6b34cb7mr62843705e9.21.1754295954411;
        Mon, 04 Aug 2025 01:25:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458b501f22dsm64751025e9.0.2025.08.04.01.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 01:25:53 -0700 (PDT)
Message-ID: <8c609741-c2b8-426c-8f83-8a79022b67d7@redhat.com>
Date: Mon, 4 Aug 2025 10:25:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: pass filename as input param to
 VM_PFNMAP tests
To: Sudarsan Mahendran <sudarsanm@google.com>, linux-kselftest@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, trivial@kernel.org
References: <20250801234559.1178521-1-sudarsanm@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250801234559.1178521-1-sudarsanm@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GMandZp9HGSaWOZ7rbfJXZvvqFuYgj5eOrV6486Umq0_1754295955
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 581FB40007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: k8qas5786uwrij8jok6frkashyiw879y
X-HE-Tag: 1754295958-848737
X-HE-Meta: U2FsdGVkX18r62FV6doYBtHmlptnL8Fpk8rWmNaFuE6WHMCA5a06aCqeBUPBmVTWx1cg7Ujvzsy1PLjvQQ3AyEwffvFrGNLMEWk62t3gjja6hBfoBsP7k4newtV5qt81cd7KzYfTWXZuy0M86YLZgfoBRl1EXCJ6xUI6hQbnoTV3mUUEApXFEBZM2tna5dS3mG9RfJU4qwiqgIRUXcxs/xPDjc7i9raAR/8seuBu8ZXKfEQD5i7MPVtuYoJiaYOD4XWXd4NTb/jf91pujJ//4R8B/YJvH97uzoejOhl1iT5MUbpkggvmDc+Vkg0TpHwmqcnRBmN2hvELYn6JDKKTSB8NUi6LyRSZ3+g0pWEZux6WA+UCqw7zj7i/hqOVOEwF/nBk+q8TTBMQYJysfsrk/xanF87kXT5IAEfU4KdBWYJbqjmpWx/SmmA6/qhaCpfNqxgZCqLSjGmvzXZ5Ahqw8dJBR4uZjaTBuRlVauG3rzl4lUk/5BxqgEWZjTpb1QQ6fqgZHYfXuEMfAr+sPJNls15ckFlUO84ok3Xp0rVzppSsReyZwDA99079Q5R2bahsvHrs6sjKk1TzKOHj0tglSR8Gw6Avx+hsqbezn4DOoiB0Qrh38HfEPKp2uL8CAsJyE/86hSp3D2BZrHCv5KbSkZWW24Bj3p1TOfLrUETzxb40UTJhYqreaxT1iWN8uxM9+3+cmVy3WM2nW0u+OwFmUQUOj5HJxIqMt7IFCYZubapazY+bUjhhPNBJ4/cMxzNThBoaCMO2OxFem/fWu2uKi62otvKPMUZDe0ZUxKOs6p4Iuz+cpkZp0EaMKsxihAIknTaf9peMYf9St0tCr+UZl4BzY8nbUk6wphDQ8YrMHZBoHjLjD9lto2GI597pvys291N0F9V0ZbRVAvqC45WdK0QqDCa+M2rte+Iqp4crvw7/ElQEvE2HQyPHcZmHpIIDJQnZhIj+jXQB7cd8RsX
 oLktupmh
 p+kcVWKKd8Q2Pa/uLjRaZEYHVMTDoRniTY7zMpg2eBDxEhg9PseJ8b2cW6P2M1CBoyZ8P3obKBWYJJfUUx5n2WzJxO/70KFI563qr5EO8tDbWNXLW+BSGfLe19qFHJ0O4u+V2NOLFVvGT8SUOZnMhcVzX9/IabvZrBNclnUSI+FWyfcbFz3HXsES8SsZENn0xYnfpnZhzSBaaPsDjtcEoAE5JNwCOwTdfwnC118amHnCbvW+TOIFSfiqaxXa5gEvBb9N0pzVPrNhMYO6ABCEVE5CR+xETybC+kuuhoKXarEd3xhzCIZ/0M3Oppx4ooTI18eViQqQlT0FNfNbfU+l6fEBTTKPtL+Z4IOtHf3+720dOv1+blYNwSqQCBg7wc9RiHAZWWGrw4EqTj8RN2yyzbbFpZfxec171hguPWLPLSXRUlD206oCuwkqbLjlPYuRA9dBZSdd3qFDjeZGPWqL1GGG90g35YT8fa/BHw8NbCyvnjaIthgQCKtfM+lS71AY2URhM67y+yAPR4yPIdYmPKUiBtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.08.25 01:45, Sudarsan Mahendran wrote:
> Enable these tests to be run on other pfnmap'ed memory like
> NVIDIA's EGM.
> 
> Add '--' as a separator to pass in file path. This allows
> passing of cmd line arguments to kselftest_harness.
> Use '/dev/mem' as default filename.
> 
> Existing test passes:
> 	pfnmap
> 	TAP version 13
> 	1..6
> 	# Starting 6 tests from 1 test cases.
> 	# PASSED: 6 / 6 tests passed.
> 	# Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Pass params to kselftest_harness:
> 	pfnmap -r pfnmap:mremap_fixed
> 	TAP version 13
> 	1..1
> 	# Starting 1 tests from 1 test cases.
> 	#  RUN           pfnmap.mremap_fixed ...
> 	#            OK  pfnmap.mremap_fixed
> 	ok 1 pfnmap.mremap_fixed
> 	# PASSED: 1 / 1 tests passed.
> 	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Pass non-existent file name as input:
> 	pfnmap -- /dev/blah
> 	TAP version 13
> 	1..6
> 	# Starting 6 tests from 1 test cases.
> 	#  RUN           pfnmap.madvise_disallowed ...
> 	#      SKIP      Cannot open '/dev/blah'
> 
> Pass non pfnmap'ed file as input:
> 	pfnmap -r pfnmap.madvise_disallowed -- randfile
> 	TAP version 13
> 	1..1
> 	# Starting 1 tests from 1 test cases.
> 	#  RUN           pfnmap.madvise_disallowed ...
> 	#      SKIP      Invalid file: 'randfile'. Not pfnmap'ed
> 
> Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
> ---
> 
> v1 -> v2:
> * Add verify_pfnmap func to sanity check the input param
> * mmap with zero offset if filename != '/dev/mem'
> 
> ---
>   tools/testing/selftests/mm/pfnmap.c | 62 ++++++++++++++++++++++++-----
>   1 file changed, 53 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
> index 866ac023baf5..e078b961c333 100644
> --- a/tools/testing/selftests/mm/pfnmap.c
> +++ b/tools/testing/selftests/mm/pfnmap.c
> @@ -1,6 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0-only
>   /*
> - * Basic VM_PFNMAP tests relying on mmap() of '/dev/mem'
> + * Basic VM_PFNMAP tests relying on mmap() of input file provided.
> + * Use '/dev/mem' as default.
>    *
>    * Copyright 2025, Red Hat, Inc.
>    *
> @@ -25,6 +26,7 @@
>   #include "vm_util.h"
>   
>   static sigjmp_buf sigjmp_buf_env;
> +static char *file = "/dev/mem";
>   
>   static void signal_handler(int sig)
>   {
> @@ -98,6 +100,30 @@ static int find_ram_target(off_t *phys_addr,
>   	return -ENOENT;
>   }
>   
> +static int verify_pfnmap(void)

You really want to pass in the address, and verify that that very 
mapping is a PFNMAP. (not something unrelated, like the vdso or 
something odd like that)

We have a helper in vm_util.c that might be useful: __get_smap_entry()

We also have a check_vmflag_io() in there. So likely you want to add a 
helper check_vmflag_pfnmap().


Nothing else jumped at me, except that phys_addr might be better called 
something like "offset" now.

-- 
Cheers,

David / dhildenb


