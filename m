Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 922C5CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB926B008C; Thu, 30 Apr 2026 14:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B816B0092; Thu, 30 Apr 2026 14:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E653D6B0093; Thu, 30 Apr 2026 14:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4E2E6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:50:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D2691C0EC8
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:50:02 +0000 (UTC)
X-FDA: 84716111844.25.8060E8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35B22A0004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:50:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RgxsQmm5;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777575000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnKl9OZc44JsdkvruemasdPKEjlnDZ5531kZfhlSZpc=;
	b=tgnSvkv+AuDYMQTRzPTmu6KzE3cA6jOn90QTCHlicILYPibo+xQA9MpPFFjTYrsRF5+0R4
	MaWrYpYEG89z1D7sUZoDXOLMOKnnBae1n8X5okDIto861mUhv+PvsxTn7j/ys5wBJ8QrF4
	8ZkUNNVQEjqBNQPssFMp5mXsvICC2fI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RgxsQmm5;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777575000; a=rsa-sha256;
	cv=none;
	b=1e6c2uj/aS3S4JaBOyiKeo8Vn03INknCwbTVpTBYtzZUUQ5AhNTebM1sJ2OwUdrNXNRy96
	wRMUsTFTHqbN2L3lRkuf/Zdz5SJmPUbUNSsdg/YCt0MhEU3tZNC/kL8Y/uosxMREOy7u8r
	GFjZt0GKn4nycsfVLaOOQZ+0LJtEEUw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777574999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hnKl9OZc44JsdkvruemasdPKEjlnDZ5531kZfhlSZpc=;
	b=RgxsQmm5GV/TePgd+Ryj4uLmgnVn6IyfJAEE0OJ3y4BBqty66zlDNtBZHuUOnvMBYBTbda
	Tw/dRfZzGEkj2LO13FFOv8PQev0bHGZ4AQq7iy/lMPS4aCqEKE813ATR0qye0/J1pl0d7h
	9POM108dr5jMarXsjoJsubldLY75/Fg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-10hnurBmOdGLB0Uk3YblHg-1; Thu, 30 Apr 2026 14:49:58 -0400
X-MC-Unique: 10hnurBmOdGLB0Uk3YblHg-1
X-Mimecast-MFC-AGG-ID: 10hnurBmOdGLB0Uk3YblHg_1777574998
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8eabf08affaso326439485a.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:49:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777574998; x=1778179798;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hnKl9OZc44JsdkvruemasdPKEjlnDZ5531kZfhlSZpc=;
        b=d9EufqmGbXycA/f8KZQOWniZC9pv5g43PihXIilCZA7ABtB7iVY7f28zJBqDQWt0Ak
         +Czh1E6laSseUSHonfPBo2DgpAprBV7V/qCwc9eLWSfWkgadLgV75OO2yR/juaBPBcmx
         A5zMxWpXnHuY1cNUcDZ7+xvZeqif7xnZFzQN1feKR+/8O1EseoYAW2KDXffZvNznazb3
         aYYz6/UHLzsg6b5uCmUPkLSKFDH4amqz3i5hI72dqgXpjxdkXnXC9cuuMWZYmGZKMP7R
         RM762+SCRuzwh6Z0GT46HG9Y2PWROqUOnuTjrE1tHMrKvTJGOvPP9O5+qPDX+XPVPgsN
         zeQg==
X-Forwarded-Encrypted: i=1; AFNElJ9q87AnhdYp7eBdIcTXsWoUADX43DVb4xX0ti0WZeGPAqyfRKB3KcY5BfQBSIH1cvkLp6W/hLh/Fg==@kvack.org
X-Gm-Message-State: AOJu0Yxu8CH4gEvyoKpN3oiXA38XvvNNDOCmOxKoEBlTFBJioaNQgbe5
	veN4VYcW6KsFzrFsgNxAhMLAHHr02WeSHHdQ8oJ/PD1wFtVdK9LFoBDoDmY1lQ3Cl8RAs8kpRbj
	/xsyqOVWYWjM5E/XcimBXchIc/KMXSbPQinoz+bOwjBp31c4orjmB
X-Gm-Gg: AeBDietQ/eVBNgKdNaRrdeb7kcjm+j0L5ZzbPIcIoHnYaHuK6+WXtNcPSnKIy3RE0aI
	g04uWtxZZ8IuOAeW4Mx/pF15upIt6wfpeywU2jShjTY7ZhK3VwI1G5E/QoqIyCewn1K0oysKfWX
	QDFZesFnm9WYiU+Zs7Jfs9lvjfEhm7o7vCPTYg5cqDGlropTjAVm6y5HXjZ1BoyW3L50wpoRpJG
	9kGI/O6UFSzzTiUUVRG1YYhd4EbLRchGExO3tGOcmgbt65BTDs4/FZ3GofoisJvRFCCqQ5epAxI
	AIHYL9um+AZ8slrfYUXo12+LcMALyZECDk45Jhd7qoJDqaIWks+E4oaly0Dy3bk2z++WmJNIc1E
	svM7uo0JygK3EFr0nWxUPM4nr/gHdcH3SGIVUHw2Vl34mQODTxuDrcg6YanUd6hNjJJ6RLg5jJc
	Tjs/9ZOXrgyyycHQReJnb6HrI=
X-Received: by 2002:a05:620a:4803:b0:8d6:874c:a763 with SMTP id af79cd13be357-8fa8922add1mr662274485a.49.1777574997663;
        Thu, 30 Apr 2026 11:49:57 -0700 (PDT)
X-Received: by 2002:a05:620a:4803:b0:8d6:874c:a763 with SMTP id af79cd13be357-8fa8922add1mr662269985a.49.1777574997162;
        Thu, 30 Apr 2026 11:49:57 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fbb430fed8sm39960585a.41.2026.04.30.11.49.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 11:49:56 -0700 (PDT)
Message-ID: <4beb6000-7d00-4ee6-a482-daa90c7502c3@redhat.com>
Date: Thu, 30 Apr 2026 14:49:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 52/54] selftests/mm: va_high_addr_switch.sh: drop huge
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
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-53-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-53-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R5Uj8ipEp_SQ9CvtO93IQzpQFHYlbqAFllfY4nb-dpI_1777574998
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 35B22A0004
X-Rspam-User: 
X-Stat-Signature: 1ywx54wcdk6pc6ftr79knho81yqhkhmm
X-HE-Tag: 1777575000-716640
X-HE-Meta: U2FsdGVkX19VEUgmqLz+6dJx8ia67tjsat/v8nAWYE/CZ7GG+An/4AqxouHVunqaaPvmNbc+PFlhoWu6Nxl4e8JN9Px7OxrvALsGa4pWyRHPqyA9d3IFEMlx/6/66pIIToqwGkLzEngCs+lkVA9k02okuJX49Jazk0KCgCUyqpVkKcSCvLw2bG0TB135kqhg5pYF1dpHtklrpc7+d7Gu5Yo6X944+Ty3rvQ8rpggtemrBSPcb/MMwYBCz0j2aHOG1f6+ahDevdlnvGh/LgX/vRmNMkRX869peMTuUvtGPthEXiZDk18MTGHn+F6Ddcr1s8cOgPqZCLUZmd8Hazpyj7jAt6vigW5m4/ml/+UcJMXzj9eMtsRVtpOdeLkXS0verhygRwmzcjyV/0xE+Si3LSj6RHLbfSeE5WriASrPBN6eaJ9i/lASrPYnkx8ZAJ55G6QLQiAL8yml1+uRKQzC3o9tnauNEigQRzsxXqBxITx/dbItKEGd2EoW8fbE7r9AvrpBZPCQu7uXq38OoJcC5WQe/RJys953OPR5T4BnKO/iHTcLvNafGw6PsvvpXY98jg1W3wfn86PwcJ4LA+VXcgH3lLV8vNUK/8rI4BGwPHV2EvADunHE0KobJX4Z3sthdE/aFonMzFGd3hNxTuEJHXC7HrIMdUaIaL2tSHd4TtCuFw4xP8Nklt2xOuOpIObBCGX9yf7l6cT061rxBRWxcsh/pq6z995FOPjLYQKqg7SyWjKEbmGanjMCAleonSkbzbUwJG5Qv9oLGMhS8MobR8Hu00msdpJxmtcwXFhhOOEy7iCZGURC6dXxNNnLqufhAIPP+XO5ZYTtzDwoFve2AWg5OmDZDQ8/3HXCWBODttCIIzEgOFqU1x2gD7jUAilfX8ctX/l9SajLHLoKmm2Efd41w68mc3CpaHSw9CntNsxsXW68IOY2un/c4LSGni+cs/X26p6N1WvBYOHcxg8
 ahy8NKVB
 ETDpFhU3blFliMfB4ny6YgjhPxU7YKA1ERiYefTsQJmEISrKBF02NLnv38/AxSKQyOvlGXneguWribHWL7ZEUSfDZirxCpRcgG78KVQt4NI7qe/WkOSfc/3bcBbdFzh+6J+Q8u+Ny1Nqr3bZ4hP/zHOxhcJTFvAk7XiLTT5pNh8lqNlBw86KX53/uvSYxe+Srg/6cfmBz65We2bPuWZJrB6K39tuZoXrcLqx1xFsRj8v+OmsVIi22GykFbFP1lFgzslSOzxZoqerBNWIlIjBALYJrx2iQmez4OM+EL2OdE55Rl+NVp/spk4jqa8LDculeAwpNPBkCKB6Fczb4b2oo2yVt7EahNxqpXmEPRx2DRDpBVP0DD+eOXij7aecNXTrSMPzGi724B2vSnU/SoZ7UzxgSNv0w8ZHjodS3wsbfRi7n93HDJRnYwzOgbZ3bevOFbu36vR4kXLaYCxkZazjL4j/DsxYMIKEAYWZVHaQMTQ+BgVHLlQpiyFrRiwlOjIVO6KWx0POE2/8rBrp0S+efLUjs7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:42, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Since va_high_addr_switch takes care of setting up huge pages, there is
> no need to set them up in the va_high_addr_switch.sh wrapper script.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   .../selftests/mm/va_high_addr_switch.sh       | 41 +------------------
>   1 file changed, 1 insertion(+), 40 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
> index 9492c2d72634..01c15fe3c799 100755
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
> @@ -77,43 +76,5 @@ check_test_requirements()
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
> -retcode=$?
> -restore_nr_hugepages
> -exit $retcode
> +./va_high_addr_switch


