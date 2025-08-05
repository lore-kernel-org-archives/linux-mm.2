Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAC1C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 08:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24FC76B0096; Tue,  5 Aug 2025 04:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227566B0098; Tue,  5 Aug 2025 04:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D5F6B0099; Tue,  5 Aug 2025 04:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 066196B0096
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:47:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6438CC0115
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:47:23 +0000 (UTC)
X-FDA: 83742074766.05.C4E813E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id C7A30140002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:47:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jx3JJa5y;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754383641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74DKsi6Sdoce25+3npCDNQncP0FOfToMHedbAWacwec=;
	b=0TpeWf7ogbpQT/8sPBZV/AZI8uyrSzgiGaua46grcgI/qIsFjaUGRvrDRb87OQ/T8J3jQO
	QdThka9gJI+4b53g0FzA289nNE2pfAU9YSM8TlGDOfdoNwnrYW0lqZYBl8bhPRs2GPn6cm
	4sMvoiYPBTVUjuBAIr2EGQq05Qm8CTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754383641; a=rsa-sha256;
	cv=none;
	b=jQC+AB180TaNdZXIuSA+5AVKH4okPzHAvZNkUVeHALZhCvx3ohMszQZdqxVYASl6SpbXeK
	C5k5lv2q/Kj6Zdtaso2aZl1u3FAzQh8OJPjVhDgR28VH9LHXrDrPyYTaKWJ1/fQZ6Ir+De
	Eg6FXs46NXvKQnaXcHt1qUojfBjhMQg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jx3JJa5y;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754383640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=74DKsi6Sdoce25+3npCDNQncP0FOfToMHedbAWacwec=;
	b=Jx3JJa5yW5syJSyJZBhN9Rc+CkyXCMNnQ0pFtKnLEtezaQCEjTO+SGNOVeKcCJzt/OhaXo
	uHc7agr0Jtu9we2L1bN5g5DV+6hWFGhMiailOgoxXen8aVBOcFwNdeF17ntQx/d6zTcRyq
	j49O4j4tDfWV0gfX+P9BZTS5B4MeLHA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-ucDCcx4_Mfa3gw4lRGohNg-1; Tue, 05 Aug 2025 04:47:18 -0400
X-MC-Unique: ucDCcx4_Mfa3gw4lRGohNg-1
X-Mimecast-MFC-AGG-ID: ucDCcx4_Mfa3gw4lRGohNg_1754383638
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b7886bfc16so3039459f8f.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 01:47:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754383637; x=1754988437;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=74DKsi6Sdoce25+3npCDNQncP0FOfToMHedbAWacwec=;
        b=M3c0VvYol5R+nkPETCIrAsl6YzSS7vM6/AI6lzWBTE+M3UHxB0VFS5aId02JraOwTy
         zVQL4NCiFX5h6p8Q9vrcSuhGPKzhMmf7v+N7afoxZmQ4I5D1otBw/11bh84hRGz9p9A5
         syIb7xn9hMkiYnRIiP2bWaUEfAfDiAKdS1rWpzQbjQtZc7yyc0id3YutECBdbwR0va54
         I9vB0vmgqU/+USaOF/NzFycL0e5gd0xgzlko67wrAVLftHxzMFD22bNRDeMOW5WJk2EO
         64TuPhSRyS+i3RBXTKRg+irI8GKtSc5N3bJQ3F8rlOsKWvcA47BfkvYraTBSB/dXZvqY
         3n7g==
X-Forwarded-Encrypted: i=1; AJvYcCUj/x/ScFlav3foU5mFBTdRMLOci60lq9TGgXs6EIW5h4+h1nO8/Qk3HzHaqKAzw5VzfcBreTiLPQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3dlYXhsGoZKQJ9dqOqQDabmRBC9KpXO4YlfjTS1iuOyyPnW7y
	2LKmssb/dgD6dTPG3Mp/ASrmfkFYBQQGPMWBocBlWPrdgXldt00VGUp437XcI6eB9o+hAiuq6Eq
	9M7W6FecLzRZCzln7z8VlzWWTQ0I4TciBd4KTAJB0s9gi//uPVyit
X-Gm-Gg: ASbGncsAYOBLb427FnE1CILvdEUnVAWsG/RUzzE3QYWTG0BIPj4miSBE6p1dTYXkR7v
	iDJIpon7hKthnfp68VXEj/d6L8OBGdhQcGB4DlbuWJtRAWb/PDLGSs2L3OVPHuHwLmuQ4jYuJ6/
	NQQRYJ5NN6PFHFBCRDl/Cbr0m8pfkvAiLKdUgOVKflmJmcH3TljgrHyL8fcxgSg5YNXXdxt9SWT
	BmbRDQPDlJV+aEF7ImWFHFEtcWGQCkctONZTA8H4ZMhfEjETQlLQvDqWsZsY8rHrE3NfNhQv2n+
	ljqzs0m6dt3wgTUfIc6W11eLKALYpTICfRGitXT2GV6tEq7hE/9GWQfrgyBQcLgffZ+jUPrjylf
	ITv+08ywg6VO8xOzuvL2tUxm02pgqUm+YxVtCu3KCnpe2zEzgb9mDPGBQ7Moy5kHGHsE=
X-Received: by 2002:a05:6000:430d:b0:3b7:899c:e867 with SMTP id ffacd0b85a97d-3b8d94d48a4mr8220571f8f.59.1754383637603;
        Tue, 05 Aug 2025 01:47:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqrJg7MtUAalV8y4XTX4pkvb/9bodwHXpDbLB7WlsGshFzRZyKWTYExc9xDh2hxm3vN0GP1w==
X-Received: by 2002:a05:6000:430d:b0:3b7:899c:e867 with SMTP id ffacd0b85a97d-3b8d94d48a4mr8220545f8f.59.1754383637141;
        Tue, 05 Aug 2025 01:47:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589edf5638sm197947535e9.4.2025.08.05.01.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 01:47:16 -0700 (PDT)
Message-ID: <24bbd9df-efa7-4090-a696-1eb40904ad85@redhat.com>
Date: Tue, 5 Aug 2025 10:47:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] selftests/mm: pass filename as input param to
 VM_PFNMAP tests
To: Sudarsan Mahendran <sudarsanm@google.com>, linux-kselftest@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, trivial@kernel.org
References: <20250805013629.47629-1-sudarsanm@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805013629.47629-1-sudarsanm@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zZI53RLbedoGuvPuEFjCc6y6-Fj9GQpkDxk5IpHoUNg_1754383638
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C7A30140002
X-Stat-Signature: 6ipxwjg9xbbk6wkwhtkja45uixhsco7i
X-Rspam-User: 
X-HE-Tag: 1754383640-744014
X-HE-Meta: U2FsdGVkX1+kKO1o3Y62xmbkReBu/OMqQ7SLJrXH7pNO8JWywoJQC2plXZ9U+TNJXild5X8Atz6NSuMAbT5PUEqz+872DJA2ZdLj6GiDrPvg9zLcm+vvNHi4h8OFF/EDFRoAtlTMM24Zb6P3zh7D+Y42GP7MBg0eli9pKrBO1tO60+XIvzuiNAtbI0OujZGnqKQZ6Fw3fEg/LHj0dcHioMZKhkyfTC3vdeuXBkZQwy46FGq3GF0+KH2F35IGctLMbgbUGUail/iEUbWGt7Ea7BoY7qpLktSf/4LXpM38Xa6/No2T6LjhnX4VdhiwkSf5kS38B4Bj6YvPqalT1rJnWfyoWLk4DxZA9W8tCC17Jx8KyxRVxiGovnyEDx84u1TYb16BmMTEJrjVVAE6NGZvRyYsRzbotGepPBXOVVsZkxZacWXcTO77D+mtrS6aELfK3sY4s9Mfg7JexmBbd4P/POWH5dHRrFPYusp0zriC+bKuFJIvJIvtUUsFXwjcjeNXCxLcwDvUld8EbIrkKvDNJqHACiITAAUsPx2mT638JfO+5RYIe6FrKaSx1o51lIZighnI+KWQa+3p6NYmpQaZxseXKinN04d/YKbmq8QffvOlBGHZutZXE8893lAykfL0cWBVwNPasX++AH/BzhTXH/4EpCtE94bTwPqj6/J157rGZCTtma3h4ylz2Y2MxaxQQEriqJunloW8M+pJghU2M4ktG8ZuIKPFno23Tlc0bzgiK3iWbpI9MvhgC7/tJtk3Ir8WOTwoj19N9QHqBPpgVvo4nuICV9dTwauDcwk3T8hMKkVt60btnHrw1kY0FsJke8LrVYXDE24h+jvMr66o//WUOj64Aiu/PRV/+3b5dHAL3nItY2wserH4s3yoJfc+sH7pmDfpFnGIOdHBp1vIumKbAQxtFGYApattmww6YRPB/cFYmg+9NxIVFit7xT/F4NIg1AahzeT5fgtEG0n
 zb4t/G+Y
 NdPZ0yzAPXFr2zJHRXrmbLB/b5K2hd/bJf5X0riH1ABy6ninhCpy1i0/nj0iol9WeD40l/R/+I7mULVHyg6YH+TFC5R0pNc1qvhRD4kuuBC4EanP/2BZVbiQRtX3uxztIECM67Ved3RYueD77zshXOjbzULEF3HNIc9/4SkA5RgUqg8nfPwPLCjFZlGS4VaHKzV199fQMivqbd7oWZTReWqjKAqciFEzt8F3p99kIRgT/skUNxIb7dho2qN66pIle9jm43qKDL/5a/3lHE9aqIZBC7dIpizbhJRKiLdGpXdziiYXokkgq8P9pO0ApUz5IHuLQ/snp+DAHphBYv+Q77pSImFC4iSGP1vH+2gri6Swzqo+vxQ5xDj3AoHc6JiWsqedLPWJUteq44XtlWN2Rj3MRh/rds/l0YoY6G5P6LVfV68NM2IuNO1h3YCDNDXNyaWxpqe3ej+LEjTynDdDZi50P0T6yioHr7SxrwmezXNOSLnoY4EvSeb3/A3oc1aDSfZdGZqxBMPZRvf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 03:36, Sudarsan Mahendran wrote:
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
> 	pfnmap -r pfnmap.madvise_disallowed -- randfile.txt
> 	TAP version 13
> 	1..1
> 	# Starting 1 tests from 1 test cases.
> 	#  RUN           pfnmap.madvise_disallowed ...
> 	#      SKIP      Invalid file: 'randfile.txt'. Not pfnmap'ed
> 
> Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
> ---

Thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


