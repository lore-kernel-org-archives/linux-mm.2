Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95EE9E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 20:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC226B0089; Sun, 21 Dec 2025 15:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A08C6B008A; Sun, 21 Dec 2025 15:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF24A6B008C; Sun, 21 Dec 2025 15:24:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF8AE6B0089
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 15:24:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CDE960B10
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:24:16 +0000 (UTC)
X-FDA: 84244605312.01.D9EF0A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3C89F140003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:24:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YLyi8xGW;
	spf=pass (imf23.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766348654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4PeecUk2a6L2i8pfYFYfBUlmDZOtnSSUja03gxfqdo=;
	b=JmmEd2/WVEWnu1yJBB0R2xgYdOAPelCxppFcHs4WLVxjzVTpK8ZGmcxa0ITLDmLtvChV/h
	sq3upTqmHukWos5/qxoHJB2MXCTUmCbumHrs13yuOMFzBH6XQKlpidqo6wSL+4PMHOLaDA
	DoGC8bfqdKD1A0XfxrbcOkd9FpRlIUM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YLyi8xGW;
	spf=pass (imf23.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766348654; a=rsa-sha256;
	cv=none;
	b=7YPNoXx6jUCz0J6B6+3uSzUNiSi+TFN6ujtTDyYPHAXZuitRc5sY3Vz1kWOheITHiGp6gd
	URM7Pq3LRai2ALG9fxRqpJRWMci4Fz7SsxQojeNS5r9fhV3juqE0lnQE2IXKjBZHjqBUB6
	1LwD/5tsioec8+TYjBe3wblbGE1VJak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766348653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W4PeecUk2a6L2i8pfYFYfBUlmDZOtnSSUja03gxfqdo=;
	b=YLyi8xGW5aD5E1AWFs16m87mbVJ33qcLaktZADhG/hxvBsLeQ+i1N1C1fOMZHhXF/Loyyg
	f8QJhBBIX+VfFE+LHvehP5RFl+FOFvikBtiKXQ7kFI/TYI03YYbjbdyezgATHyw3r1XhdX
	VGN/OD4XkQggdOGmnWeyvA37fk5beL0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-IzzlTcrGMoCeLvKOF5ZVIQ-1; Sun, 21 Dec 2025 15:24:09 -0500
X-MC-Unique: IzzlTcrGMoCeLvKOF5ZVIQ-1
X-Mimecast-MFC-AGG-ID: IzzlTcrGMoCeLvKOF5ZVIQ_1766348649
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8bb0ae16a63so352953785a.3
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:24:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766348649; x=1766953449;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4PeecUk2a6L2i8pfYFYfBUlmDZOtnSSUja03gxfqdo=;
        b=HrHP3PKvOB86g1xYNX4g61f8V8Uyinox6PUlWNslD0S+q3ssF0tiYwUzY1aoLa0scF
         /Czw4/jHUYxRpOulS32cJydQp/8FJbZdOWHHt8iukiMvRv/3CeROXIO83DNgTjANV9/t
         Z7NG/ftF5+8Jk+GCd4R1FRzQkubu3CEP9xqHPnw9BFM84kG9PKNBJLzVNK3OKEVC8zsv
         FQUFwKrRMnFCZDmkK80pDqe1SdtJjASbck0n/PD/8BZVxou8GicQqB4vILNKNOKtka/p
         Ep/b+vBVp2gIcDVK2A5RaqOG9Lz3K1a/VXCfQ3ijBpFoZBxcpj2Zr7qWdLx7GkqMIcx3
         Na4w==
X-Forwarded-Encrypted: i=1; AJvYcCXSBBRGfwm3v5EZP1/XcpN6+Qf2gsFzI0rJuGSTX+8u+bexzGOqIocDRCnhNQxpmbGX6ta4r0qEMA==@kvack.org
X-Gm-Message-State: AOJu0YzNzGmd8u4t++j9bZtYlFtKTkOseZJc8tTvkK/NGnaAXMAYWVhq
	kowz6GT4JHQ+Ns0Q4x9st9helw3P7wO5jmo7t28u9l8SzP9JnpIZklE2wjJa00H2OIAdLUHpzsu
	CFXQkVmfJ11Bd57X52YdBOCfYlhRNbqOq8x/IzLTJ0iPIYcSTNFNH
X-Gm-Gg: AY/fxX4gtHLvX7VGBDPoAZ9vPgfVKZyprboi16K2PDpgBoCZy4HhDgeiGn8SGpYZqJ/
	rSlAe6cRD/KtPX/hLT41r6yXsRbEKxbj6WsAc3TzNBTCtdN+Pp6cYrZWlSbZovT0RZzWm5mAUMX
	DgOat2yh+hF1QH6mamCHtkKKr5hJDjjb6hvn7KoQqM7JCTa/Bh6/cpJ5T/5N+LDb9y4Ph2L+pD2
	Q/0K8kcTeBPsGbALDi1dAO4euV2OxD3cdNyorLeOZvkvxrD+EeXkeBP7A5D5wiPtDtDy8nOyXcW
	YVZ4mAyNwoyG3OpBwYBqWnFPFyrr5J+kzL3sOivGW9q0frQQemn0YTxCvAi8+Q3vGFhOnIboJ76
	44psBBVRKGat4M6gluDxyct7TyFDjC0kaqHH7PqrD+Av+wp8XlGl0XBOH
X-Received: by 2002:a05:620a:7114:b0:8be:8e2a:3132 with SMTP id af79cd13be357-8c08fd2d107mr1368459085a.58.1766348649184;
        Sun, 21 Dec 2025 12:24:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IELLPt/d8YPTRQPIvq2OfKTnGEFneF8fAaQ6NksD/z4JSDYjcG+7kGAIDZrrF7jvkRrURTZFg==
X-Received: by 2002:a05:620a:7114:b0:8be:8e2a:3132 with SMTP id af79cd13be357-8c08fd2d107mr1368456985a.58.1766348648807;
        Sun, 21 Dec 2025 12:24:08 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c096783a81sm679124985a.9.2025.12.21.12.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Dec 2025 12:24:08 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <94e2d707-94d6-4120-acc8-ee65f91af1c9@redhat.com>
Date: Sun, 21 Dec 2025 15:24:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] selftests/mm/charge_reserved_hugetlb: drop mount
 size for hugetlbfs
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>,
 Shuah Khan <shuah@kernel.org>
References: <20251221122639.3168038-1-liwang@redhat.com>
 <20251221122639.3168038-3-liwang@redhat.com>
In-Reply-To: <20251221122639.3168038-3-liwang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iFk4dUy_cchC-Z8sepw2QTmgRIFqGzkJkz6i0hVsGiE_1766348649
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3C89F140003
X-Stat-Signature: k7xrjfimj4f3exyb85hh86by3eqqir8m
X-Rspam-User: 
X-HE-Tag: 1766348654-353226
X-HE-Meta: U2FsdGVkX18e8t+VXxcpnHUVUTFIzG+ACY68vhqIrTgcNspWAX9RtYe5ssDqe2NsFfItwZDBOfoYAZk1eH9BRhrDMH2jI1qmOp8ZenO9tHZFEQCaT28stVkyV1wZId0bpnQQ5z/4wdm5nuI85yzIDiMgiAGwKeCacOkTAVyQHvT+H33y2iTmtKseT7Kuub5YSGz9dYHzOUJqfpe//NZAa9oMgs3QVHWviN8qMt7W1I3mbRBG1ADak/hvmJvCm1aDn7U0fIR7qziO+P0OpltEW/rWQJC8GVBlJApqOAjF0md2lx4zBX0I9+brRCV6yn8m+76iL66CT4+5An+etgyOvtk6Ipo0rEeFdtPjvmDXbc/Ny2gFNCHnwHePZOvaWYJfXhpJ9KxDNHNEIeCNO5Pxtn5rrA4WFtAi50Wl0oOXKf11x3zvMYEujQ2pHeh2rcD7ejA2pxdc+XJME1aIpQrWhzSX9i0Fro2hk9VRCpE16Onjs32G+Wqs21VIc1x6jt+z7PpX+RdP7Dr0kYQTL9ElQqdeR7e/6J1hDG79lcA4W/LvnmB/fXXKs6hbR9SAhWtFs5ZhP0ZbKmvbeL6t7z8iie8y1cvHBYbFJFVhRg+ZsOErvk5LWB53G5Ool4F53DgrDDqRq1p9W/r+VOT8t6lJggEZ4v65QAlpVOJNKMIKExtvqf/s3TdsPMcf9VdkkGRuaeMqsfjW4y/l72+YKUISi3WtSyDxqiOeh9zAfizy3k86IKRfvofWmylr73H4n3KpBxS9DaaLJNWupkXp658TdhOzZIcZl2kfCEZ5FHEe1m4YkrjQdeCSpPkHFh/j4tr9k7bmfj8FvwRKacfhRZRNroyl0nKGW3ukwRQcKqllLaIvZwrQxA0GDJ9lAyhyoWzlnXfsasJwlVjM/QAjJSuuxvyfx8J5SYteY/j5y6j5frfCaH9cbf6BbBxOQ/680JkbzBGzrehy2a3xC//Dfrp
 MIoNb2Up
 /1hVSqxnmAKz4eaEU5d7LNRgeEdhpzx1Roy4ivRByn6VydyovkdAfTSJwjep5W7LpqAB0fnhvXVHjcbPBq8lfxMeRAEg4kr1y8KVoz2Uq/EAK0Vmf2EIv7VOzoefK0BU5jOk2puAKX/PQ3F1k7zN6itzdvrQWWpY0kJnx7lqjhnrr+vNRUflrnsE5pmPuBMJTtLf5Coy99uyepr8I1eTG3YoZfbw8sCl+8bRyv5qYsYrpERbYkR8jMf2Uk2syrEZ0gDfM3blSOnrMTwdbC/CECK6wLX5Nn3SYHw//5iIjAY/PPH5OjlYcLblQWX3V9NaxsvvEcbZ5TPzN2zSkvHNZeQD3s5dW8bRacn5qKVDWAbp1hCg3fZOnksm9fYiyFcla+HNMHjVSBNJD+/BZNO0VHLIldpXhFLyIqu4o1xGKRGYBCxa72R01yDNerFzYuJsQO8oFIbXSDwB3yP2QGM8QmqnF1FRXjtH5Ja/sHHKXzsypCcv6xaGZKoWOx1FIrkn2aYtK7eBkeyJNfCEd6dvssEqDJmhDKP64Elm9FcZtLW5hg0v4cviixaNC7rEpju8OsrAWxmspVMIONgc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 7:26 AM, Li Wang wrote:
> charge_reserved_hugetlb.sh mounts a hugetlbfs instance at /mnt/huge with
> a fixed size of 256M. On systems with large base hugepages (e.g. 512MB),
> this is smaller than a single hugepage, so the hugetlbfs mount ends up
> with zero capacity (often visible as size=0 in mount output).
>
> As a result, write_to_hugetlbfs fails with ENOMEM and the test can hang
> waiting for progress.
>
> --- Error log ---
>    # uname -r
>    6.12.0-xxx.el10.aarch64+64k
>
>    #./charge_reserved_hugetlb.sh -cgroup-v2
>    # -----------------------------------------
>    ...
>    # nr hugepages = 10
>    # writing cgroup limit: 5368709120
>    # writing reseravation limit: 5368709120
>    ...
>    # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    # Waiting for hugetlb memory reservation to reach size 2684354560.
>    # 0
>    ...
>
>    # mount |grep /mnt/huge
>    none on /mnt/huge type hugetlbfs (rw,relatime,seclabel,pagesize=512M,size=0)
>
>    # grep -i huge /proc/meminfo
>    ...
>    HugePages_Total:      10
>    HugePages_Free:       10
>    HugePages_Rsvd:        0
>    HugePages_Surp:        0
>    Hugepagesize:     524288 kB
>    Hugetlb:         5242880 kB
>
> Drop the mount args with 'size=256M', so the filesystem capacity is sufficient
> regardless of HugeTLB page size.
>
> Fixes: 29750f71a9 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> ---
>   tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> index e1fe16bcbbe8..fa6713892d82 100755
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -290,7 +290,7 @@ function run_test() {
>     setup_cgroup "hugetlb_cgroup_test" "$cgroup_limit" "$reservation_limit"
>   
>     mkdir -p /mnt/huge
> -  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
> +  mount -t hugetlbfs -o pagesize=${MB}M none /mnt/huge
>   
>     write_hugetlbfs_and_get_usage "hugetlb_cgroup_test" "$size" "$populate" \
>       "$write" "/mnt/huge/test" "$method" "$private" "$expect_failure" \
> @@ -344,7 +344,7 @@ function run_multiple_cgroup_test() {
>     setup_cgroup "hugetlb_cgroup_test2" "$cgroup_limit2" "$reservation_limit2"
>   
>     mkdir -p /mnt/huge
> -  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
> +  mount -t hugetlbfs -o pagesize=${MB}M none /mnt/huge
>   
>     write_hugetlbfs_and_get_usage "hugetlb_cgroup_test1" "$size1" \
>       "$populate1" "$write1" "/mnt/huge/test1" "$method" "$private" \
Acked-by: Waiman Long <longman@redhat.com>


