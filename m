Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F177FED3F1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EEB6B0005; Fri, 24 Apr 2026 13:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF916B008A; Fri, 24 Apr 2026 13:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE416B008C; Fri, 24 Apr 2026 13:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD9E6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:22:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1059840281
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:22:01 +0000 (UTC)
X-FDA: 84694117242.08.8C33924
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 89593C0009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:21:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ROioivaO;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777051318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlT2C+6GgdAk9z52bJe0h440fytJPDoIRU7OOb/gQQI=;
	b=SeUVtlow19ZH/E09vXJxs79e5XNGd4B4d+tWceUIqLD5ZCXxoUBrSlbQVloTRDdfC8P6rz
	Mjv0nDPnJyBeajJyL9GZ5va2t7yPUCMVposWgs7tD8R9L3uXoLJoycu63fUQA5Q5S//zgj
	k+WuitMX8sYM2lnLUTTuFx+oa3iRDKo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ROioivaO;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777051318; a=rsa-sha256;
	cv=none;
	b=QktFJrQkjnL+6PsP7B1o87u7tR+h8D5TiUpR9otONMQoc4arrdYQrq/hDf3WVeputpqkf2
	fiUhpkGLP6h+It3UkOaSbq4+nBetqoEIXSJ9WkHkRaa5JNQMFtz0/dzKi+vsa+aXviN0ka
	X/HR3WeB+Y+tRX0qE2nSP42qqFJ7XHQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777051318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XlT2C+6GgdAk9z52bJe0h440fytJPDoIRU7OOb/gQQI=;
	b=ROioivaO8A0QggL/9P9uco0O14/b1mDAzNL3XTpZO9noq5t1guqtZQX6oMN3vp4VbMx3DO
	VcVLOPQY3EoTtt0JUsDcWoaJlf6+xWK0ymRYzbd1FOaow3ppG6ZGXXDSM5bYWxbtogsLTm
	22Sf4PycE5O8l5frZktC+KUl0Iol1K0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-0RCvy6HzMfCXYkM3_WTLAA-1; Fri, 24 Apr 2026 13:21:56 -0400
X-MC-Unique: 0RCvy6HzMfCXYkM3_WTLAA-1
X-Mimecast-MFC-AGG-ID: 0RCvy6HzMfCXYkM3_WTLAA_1777051316
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8ac566014e0so208546356d6.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777051316; x=1777656116;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XlT2C+6GgdAk9z52bJe0h440fytJPDoIRU7OOb/gQQI=;
        b=UF/qzQ6tFytBQPLVyJwZELR6M3Ah4IB/LIXiq3ufXqwy7LUpJI7eTen9Z8dzQjpm6v
         5MM+q/ibX3pXM+MGMlVNuCEqlF8w7a197uK6OkiwUCOY1PMKUUNdirGrQI0FfiYINCo2
         K5JDkEFSRDb6HJMpN/wPAyPj3x8zPBZikpQahpg/VxCHYblEhnNkArPovDOcYEAyxwGw
         iczj0Z93lhMu6aK9+cn8pbCpXgswvLSuUqpFhkdw1bEaznuD9V7cNVeeipOs50eCuxBE
         nFc4KJcrmTWTp/gB4M6nlW4H5v2nlCvDEmPIRuas/S2lq8t6nx0sy1yI/xfxnCbF91lJ
         FAbg==
X-Forwarded-Encrypted: i=1; AFNElJ8eShRi2QeZO7s9HmC7rNdBfl27zSIfcyfXWnKh/EL/Q7EGGN+AktudskXnfgWOf9HLLLPQmrAGJg==@kvack.org
X-Gm-Message-State: AOJu0YwiiPyVxNtwcQbR6To7lprXYpbW3f3+OpiDdMXA88+bw2gSJiho
	sW2uJA+x48JL4x1z1BtVmWAPSqE6IaNEK5p1b81dTAJz8lOdnSJDIswmE+CQK7KYqjLoRmH45jO
	mvflEDCE1HOvly63G/MK/s9pHxvHw5bteezMclquL07cUdCiKerFd
X-Gm-Gg: AeBDietvedTPtInMTWWFwYQs5QuJCxNNNiiBkaGxC+/Yug5VEgg+Id/o0a2DXwH9AAX
	6uUc2A4LBKDauM0uTdNiZTKFrcXxeXNA5iCS37pxfaao3wZKSANnC7KwReLSNTmKsvJnfnKDnbz
	mG2v2/NKu+9IzWBFE1bGKtxZXQ51U0OrPR7rFwhwc0whfwXiesdNHyI8HhiNaNSQXBbW3Jm/JXo
	RxQ6e9gAWqwMFhwIA2ie/EttRR5kZbsXmC4QM1DqzgDzuL2ZyF9eLhLVEMVuhg0hEFNYitRHAFe
	gtkSwBJQc05qeD89D71U/w+iW9tsuPVgw668svCHNnlXazeZs15hPRdaS3khoFXj4S3VF5nrk0A
	1Rz9B8fKK9VO8Mg61+kVWjw33G4hU/c4My9Yq
X-Received: by 2002:a05:6214:1d0a:b0:8ac:d13c:1938 with SMTP id 6a1803df08f44-8b0280ffd78mr487357886d6.17.1777051316125;
        Fri, 24 Apr 2026 10:21:56 -0700 (PDT)
X-Received: by 2002:a05:6214:1d0a:b0:8ac:d13c:1938 with SMTP id 6a1803df08f44-8b0280ffd78mr487357426d6.17.1777051315590;
        Fri, 24 Apr 2026 10:21:55 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae97d89sm193980186d6.42.2026.04.24.10.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 10:21:55 -0700 (PDT)
Message-ID: <46971f34-a287-4209-8716-880926e0b8d2@redhat.com>
Date: Fri, 24 Apr 2026 13:21:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 51/53] selftests/mm: va_high_addr_switch.sh: drop huge
 pages setup
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-52-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260418105539.1261536-52-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jYkCncaQAqg2H4CDUjcesqRNQ2j616uQ-iCPkk33qso_1777051316
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: seeayjoo6ikygqm3y4ek8az6cszc9km3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 89593C0009
X-HE-Tag: 1777051318-762728
X-HE-Meta: U2FsdGVkX1+/WTGnRPwn2jMOOznnoVwUmkQgfMUddZJIBmwc4+nz7bJDFcp3UebAhFzzlS05YNi1/j4ue1KQ3Vfv4GEiihRkE47okLEtwMhUlpKeY1TDJyP39cPbPcA37FOzf01Zj+/zujJr0H7BwwSwo5viVJ4FpkcYkcTT1rQ/hXRtT0jEALQz1rgOYE4aAg00nvSpNvWiZyeNcfQ0iOC4ZSQPQMLFAcOQmiPYT3PtDDTWqzXrHgRGa1NhP81zNsozxYYIFYj7mVdF2BWl7NYZAUqRb6j7xh7POxnNaWXsBByuAjJW/+BkS60XX+N15ptjMUszNCzTKFHfFKcOYIWjEWstUt4xFV43kmy2Gv05hkGw3z8q93NeOPzxJ6fjgIVC9FPJC87lJXbl4Io7ie8mKTJItAESj0Bqu/g8buYh5Rds1V89AImNz5OHnOaJVU+WtehNOQw4kqX/GJomy8RqX4BThT82q8ymEtl/7DVFx+DHvjnoUwLPlnv0g/71A8tyX2BSkG9PTNuwIAWFX8cJlnys+JqEHW1F5Wxbf3tYS2IqgBDwsDl17flLGC3Yl/R30rJvr7BKtMiAVaO2wGJZgx5545tkrOztH6koeV7EeY+TseNSlHpXz/p4wtQYdT4vFwqLtnoSCPZ8wmmZPzG1M6KY71JqtFyQ+m5EfX0HMpM4yRa9HpSPV+9nenJJ0sKKRKh3Nfr+fAnPxti24xomf71OBAWEaPOBibbNnxEX7L68I1/jHGAqKdLRZezUPz2iDk2AZiAOHrPnxn31EKuDpHlvJWiJfZ6VNIKr0zNri1igo6XuHx+poQ5xZ8frKFhExVXaqHIrJ3PlEX9+KdpcfzZMUbH7TCg2GNozz0WOVKRbzDenklkaHCpFtKH92/2z1kGqKWTZLDHyB5ZC6YnEMp51u1iFvvg54G6cpOJ0/XWrfWs7YFMAVAl/bbN6plXb846DVj1cIop/lvE
 rEGteqcy
 zwNVewTZWGK/cAydINdrFIMbYRMaxcPGNtcbdyc53Wt0HOe/GjFNHdVBEoOo6enXQ0j1CJSqA4aE/kgk3U+ktjyS76vGxWfjYhtNWeNqoaOnpbloCaee1LNBHRwjyqYEbDSyBWWMaqPEkgecIkZMNPuw5MAtwEi++aeLwZGJzwPrSBWj/j2kjIyO1JAbtXPIoiGeujFYyxuYQv6WTq0LwyFrLMSj4sca/Rxdquu/H2AaIUOxYhGy/tA7fEa+b5ExDskQ03pVpQ2QeXuvm4obMb96Im59ZQsbhnUWazKjmERIH8IJvu+eaPJW76g2z9Hjg84jfXhQ6RfLG/C5OOF3EzZOUTSpcJSAuQHC1ySQjyfrbIEORKB3seRU5zpjOyNHW4bbog0BuaTZFpi/bddsBKaAkaIBcy/5v9XbcCdixI7KCTz7M7jhMnblUyXIunvm1Fu9mPANzxncoqAIyQuh4auoxMMo8AahVT9kXmb2j3ng9FzKrUOCgmdY7GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-18 06:55, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Since va_high_addr_switch takes care of setting up huge pages, there is
> no need to set them up in the va_high_addr_switch.sh wrapper script.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   .../selftests/mm/va_high_addr_switch.sh       | 39 +------------------
>   1 file changed, 1 insertion(+), 38 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
> index 9492c2d72634..d66c0fd3cb4d 100755
> --- a/tools/testing/selftests/mm/va_high_addr_switch.sh
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
> @@ -9,7 +9,6 @@
>   
>   # Kselftest framework requirement - SKIP code is 4.
>   ksft_skip=4
> -orig_nr_hugepages=0
>   
>   skip()
>   {
> @@ -77,43 +76,7 @@ check_test_requirements()
>   	esac
>   }
>   
> -save_nr_hugepages()
> -{
> -	orig_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
> -}
> -
> -restore_nr_hugepages()
> -{
> -	echo "$orig_nr_hugepages" > /proc/sys/vm/nr_hugepages
> -}
> -
> -setup_nr_hugepages()
> -{
> -	local needpgs=$1
> -	while read -r name size unit; do
> -		if [ "$name" = "HugePages_Free:" ]; then
> -			freepgs="$size"
> -			break
> -		fi
> -	done < /proc/meminfo
> -	if [ "$freepgs" -ge "$needpgs" ]; then
> -		return
> -	fi
> -	local hpgs=$((orig_nr_hugepages + needpgs))
> -	echo $hpgs > /proc/sys/vm/nr_hugepages
> -
> -	local nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
> -	if [ "$nr_hugepgs" != "$hpgs" ]; then
> -		restore_nr_hugepages
> -		skip "$0: no enough hugepages for testing"
> -	fi
> -}
> -
>   check_test_requirements
> -save_nr_hugepages
> -# The HugeTLB tests require 6 pages
> -setup_nr_hugepages 6
> -./va_high_addr_switch --run-hugetlb
> +./va_high_addr_switch
>   retcode=$?
> -restore_nr_hugepages
>   exit $retcode

The retcode=$? and the last line are deadcode now and can be removed.


