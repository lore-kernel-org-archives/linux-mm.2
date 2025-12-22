Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196C9E674B9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 19:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218386B0088; Mon, 22 Dec 2025 14:34:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5AB6B0089; Mon, 22 Dec 2025 14:34:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4AE6B008A; Mon, 22 Dec 2025 14:34:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE7B86B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:34:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F37BB8622
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:34:48 +0000 (UTC)
X-FDA: 84248109456.29.3F8554D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15F3A160002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:34:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UemjBPeP;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766432086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VG0oF06MATxg/zLOVliOY5C7b4LG+alI0dm9ELpl22A=;
	b=wsgspRQdashV/piTyI7dyW1ur68BoqHm8z4JcoA0c9Im7dJfo32cyC7OiJWHMhR/SAtzUv
	yMCyBXRjbRfErg9Zk4oMQoUJQP6q5Q/uswVqHZqWr1fXcrFHzOvQV6/GVKolhnCvc+lwzq
	MAyJFzu78ZTXUgyM2XvFKiEmFxhtPog=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UemjBPeP;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766432086; a=rsa-sha256;
	cv=none;
	b=1jX3pZA2cKOOao2kYusCG70alZPJfp0ojBxpVHuSgAo/E2WQ5SdJepYZYid9LADgCorABW
	iR/Y4p4iqcnS6YB/k4jfkSD/rd2YZfoyyrvg0ydKqgWg4h6aAK4vOhDRVJPgz6Rlc7WAkI
	sDxGRjt8+f0H7Te2LlFOZR0wad0pRvA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766432085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VG0oF06MATxg/zLOVliOY5C7b4LG+alI0dm9ELpl22A=;
	b=UemjBPePKdy+o/x/72FiQ4fxXrGCdqFe2tYX1j2W9OsGhSo3X1QGHGs70H8ywPgg51FOha
	gXoMIxeWnOFBrULsdHh34hcqpqUf1J6ugvJ/vPU2e7uPee1lQlug0P4gZtU442QgO0SKhc
	jotMRVOBQMM4b4getauDADGg//asRpY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-Z0U40GOxMDq8OZqGl8Pk_A-1; Mon, 22 Dec 2025 14:34:43 -0500
X-MC-Unique: Z0U40GOxMDq8OZqGl8Pk_A-1
X-Mimecast-MFC-AGG-ID: Z0U40GOxMDq8OZqGl8Pk_A_1766432083
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4f4d60d1fbdso23336701cf.3
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766432083; x=1767036883;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VG0oF06MATxg/zLOVliOY5C7b4LG+alI0dm9ELpl22A=;
        b=VpTMc4IEPj0l7cjxB1he58r8JeTazqpXs/8s/PZ3HFkPNobcLnnpAv1aUxI5ock1QM
         22v16A5w8Xh9qGICX1sMXG88qbLjWqXlAymZAa5iYwQesjwxVYmJg+3oZvvhAuSJ3xX7
         gMsnfN4H1ix+HV/NnPRo9e5Zcq3r+ZjurpyxTYhLai7eQL1YR9/528/G2zTlrzcHlk8e
         QgFUg+A8jjnK/KLZuh1OLBSQ6Vt7DA6yTu20WU58QStxrgo8ohSxrJT9LwyQw5az8jRP
         lPSS0PZxqpzURlO4PN0GnZBVsjrohzTyFWcjXyDAoTCELQ8BWh/Q6r/kWCgXqx0dZzTW
         hJfA==
X-Forwarded-Encrypted: i=1; AJvYcCXnPimFkoaqtn8qV0GvTEGyI+tw7xl/cYIAdSEU60X+JNik1RkqHwwYFEyqGpsWtrmL/TvF4xPyyQ==@kvack.org
X-Gm-Message-State: AOJu0YysthVMYzBZYE7VSesnlPXcw+02qkazA9Kfz3BhaXwdwv3U5Jeb
	9+58N8XCBn+22hiBM+yxiaCDk9uXfcg+Lc0LtKAFsYBqKzLyYqxw1vye8qdzDCCz71e+Y7kGF+s
	QIGT432BL4xk6jJ+V1aqZuF6EQwnuVK+fd0jUMotpCh/uHFoyELgX
X-Gm-Gg: AY/fxX4Mjoj6Yq0vncAv6KyMz/LgHt9Ct+0MNruWwVU3viW7CmE9KIZByUOQinfs7vC
	yWJWwTDARSgVTvFwLX34iq5NtfrNw3JlSAniHqp5JDQ/ZEVBvSW0tkZpTNC2cQr5Z6KHpdhMAJh
	v3uwepHOHL9uHH3jL6QvwNrODo4gXlOWD0CLv5xgLiO9gKTQLDVc1yB4Vc79GeBxbaHcDlmK41t
	E5JO2dr8Mxa8tAlSbnbN2UNhs9jmFDykVYL15AEPkvfth20ixoxwg8rIbgVMQFCgtpxNXi+tPKJ
	ciOqD37jebN38KDYl1il0LDCQpWZD2Vc5/oTUgc+7BEbHzzJKn36JkcfYSZYkWZ9YbUO2GXN/4I
	Z8pNDq+IziDbBhr7l6kmftNjWQzgF+DNITnqcanZbG8MBGRiGylRQF6g5RmrAqJ/RMQxxNjqzSg
	==
X-Received: by 2002:a05:622a:17ca:b0:4e8:b446:c01b with SMTP id d75a77b69052e-4f4abda0960mr191529971cf.61.1766432083201;
        Mon, 22 Dec 2025 11:34:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnavtkUmnDQmxJQ3e4vwSgIlPXL3C48qTsghoyMt5JLf3ySEy2SXRpIFZDKMDuuzyt9EjIdw==
X-Received: by 2002:a05:622a:17ca:b0:4e8:b446:c01b with SMTP id d75a77b69052e-4f4abda0960mr191529671cf.61.1766432082740;
        Mon, 22 Dec 2025 11:34:42 -0800 (PST)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-48-76-65-77-217.dsl.bell.ca. [76.65.77.217])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac563f66sm80950521cf.15.2025.12.22.11.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 11:34:42 -0800 (PST)
Message-ID: <30c82582-9bbe-4d7b-8549-ebdb29743e86@redhat.com>
Date: Mon, 22 Dec 2025 14:34:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] selftests/mm: allocate 6 hugepages in
 va_high_addr_switch.sh
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 david@kernel.org, shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20251221040025.3159990-1-chuhu@redhat.com>
 <20251221040025.3159990-2-chuhu@redhat.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251221040025.3159990-2-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z6OxDD71cDQ8VfI7U6CWHoz3xyEodyeqPAw7N18R06A_1766432083
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9ga98yn9a1jfqqe99oa549qu19dounwr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 15F3A160002
X-HE-Tag: 1766432085-945650
X-HE-Meta: U2FsdGVkX1821J70xMswdBiFj8S7XUDZXSSHeoJBbzNerg+HMcPkIas5t13tvbyrysUoEFUTa10+1kugyKOiGVJHg55Nxy7q5NPozJ+OE1muI7TfK7KfH+VtGWWdzbA451jF8oUesz0Jlc1nUOiTMmEb/Evn89x+UP83ScEp1frSFyCPSE9jXTTtLaBVPRTvBlF8tw8tXiGRTTuZkNameOc6gCKXgvb3ztNA6tDe4pMkEYOP47Og3hVp1Qn6wuovS+N57nb6IMcqZAYv8CGlXrZ8LcBlCePaIAtJ9MAE4TwxcbbQ5tKjLHmHaB2bRoeN14MyoMVJyu2+OdL0r6qcTXkZ7udf53+j5xCm7JQrJzZJOtSMBNr4B+2NEl4u5xeSriTeXoROeF3Xc4wHmpgKvCAYVfK4frl3vrVB+J4q1V0MDLUa53wjUFyCTDK7qTc4b+rGChEtTg7INdHD1Uvdv2mKXgWeMjX9Xi/spE2nB9MbK9i7AwQj4sVbpppczcOsYqEXpbeayR/XQVH8oemaMbVHLioNU3LLqg1ZQPoJaceP82FpVcgNovydo7Ds9jilvBoLCPc3PDHs9QPD5UJXImunEbk0p7Y1Fa46EMhnyHobdiishpLkz7aN9FKslFkPpzzb8xrlBhQ7u91R2INWB3+ShDEDFIFui+p/Siqo59nsaGyqBLZQcipGtBhXIklX0SkyHaYULUOAFE6/JVWmCKJNOHp8FEKUvnaAK6vHJIMNbozTq9SivoK00xCZb3PQ2edJ1rDG833lExD7T82dU8dGBY8EPJQyw0kdMUMaR4sNTg02o+zMioMzQ9cf+ecvERjbDqKiTqCAYXKwHOQR9GOk1qh5i0kyu+K79gyeVVNlN+fA1xeWOlKdIkK5f6IiSGXDqViU+CzqfZTSOoiL6D/0bIofhQxruSdLWncYtYJcjp17fLNhF0oOXyZCEoO3JV02da1vSEerNYVerxB
 +14slGhQ
 Vzx4/V2fjrZGr27V11mjsTZXknjYyR2q6eCGKJdW7jGxXxL4w1c4OWUU0xQT7OsQs77cxo0T6Uuy1nTNqC0NWcoT5I5k7UyhFKq1KLc7cs5cC/9msspXoeN4VA1ugGSxoCLbsM0HRhMxC8RyVRgYoMSaSZQaWQj9C3FjIaSEocEtunWwZ3HPjZIqyGh6OT+C/ryRIyS9toUQGk/9inrxCUgrMOce4/Oqode2H3UhWJlINFEcjY0zMp/bTF6w1+vUAcmoKGd4NM+7QB/N6OYZ6AXkz8ol4e0uDKiKvt+kkixZFcv7rj4Rh40FVWkPHZ3dpV/G6J2wqQKrlem1jrHGJhEqjN4bo+g4RwJT1RNQJA+ho2aU74BUEAiT4n/Axd/87VgfMvzaR0jgYSvJ5Rt6F/sJ8YTd1VI4+mQ+VVwV9XwTubj2sXnjo3qwx6T0QKwT5/r69WQC2nGRmZWh914Cv1MqcJ+OVEGckHC21kexq+N8EMLGrYl26dDgpgPEbfKFcs+eYQ/6TNuyaQuzxIDGTsxjaOCeDJKT5useZNQGdow/m4Ic=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-20 23:00, Chunyu Hu wrote:
> The va_high_addr_switch test requires 6 hugepages, not 5. If running the
> test directly by: ./va_high_addr_switch.sh, the test will hit a mmap 'FAIL'
> caused by not enough hugepages:
>    ```
>    mmap(addr_switch_hint - hugepagesize, 2*hugepagesize, MAP_HUGETLB): 0x7f330f800000 - OK
>    mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0xffffffffffffffff - FAILED
>    ```
> The failure can't be hit if run the tests by running 'run_vmtests.sh -t
> hugevm' because the nr_hugepages is set to 128 at the beginning of
> run_vmtests.sh and va_high_addr_switch.sh skip the setup of nr_hugepages
> because already enough.

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> 
> CC: Luiz Capitulino <luizcap@redhat.com>
> Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
>   tools/testing/selftests/mm/va_high_addr_switch.sh | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
> index f89fe078a8e6..a0c93d348b11 100755
> --- a/tools/testing/selftests/mm/va_high_addr_switch.sh
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
> @@ -111,8 +111,8 @@ setup_nr_hugepages()
>   
>   check_test_requirements
>   save_nr_hugepages
> -# 4 keep_mapped pages, and one for tmp usage
> -setup_nr_hugepages 5
> +# The HugeTLB tests require 6 pages
> +setup_nr_hugepages 6
>   ./va_high_addr_switch --run-hugetlb
>   retcode=$?
>   restore_nr_hugepages


