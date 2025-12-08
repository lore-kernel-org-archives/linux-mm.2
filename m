Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121A4D3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 15:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B16F6B000C; Mon,  8 Dec 2025 10:49:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762216B000D; Mon,  8 Dec 2025 10:49:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651246B000E; Mon,  8 Dec 2025 10:49:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 524056B000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:49:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6BC9567BA
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:49:01 +0000 (UTC)
X-FDA: 84196737282.02.28065DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id A823D10000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:48:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bImn0q+X;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765208939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhyQmCNeRAwE6U6BA2EWgkizTxmpe6QSDSUOhKlflR4=;
	b=1ZEt89rhFh5VHsmY/puero26DOhdGaJttEvDPij5GsEJAkpkYGIoxvn5IppM3YSgj463Kr
	/IRD1gBmmH07xUDf3nt2JnEDkkTgpmoHJz+NyUHE+EJKzhe6+6dQ5mSL4wPx4eSEcXlKEd
	yVMFNQu9pTDHAYhH6DhsQMcsoCiQDc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765208939; a=rsa-sha256;
	cv=none;
	b=YnC8w0nGyNgtpgHhrBkCftJQdstPjtRDY4ho4elzFuc5EFrbpttcnkFk41HbxbTrW7gV8W
	79Fh0lhcs/XxxavSTFafr3vDkQ3y31ULnhjHh+bleCeAvtNMLwNDkU5XKg+hn0zBueIV7x
	VWb8/6mpgAqUKOHjGkVE0TN/hl2cB6E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bImn0q+X;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765208939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhyQmCNeRAwE6U6BA2EWgkizTxmpe6QSDSUOhKlflR4=;
	b=bImn0q+XSkq4EyUGdTGQbilSrSNM4mk2g0h7SCQkhCOQgRbCD1tfKsXucKwvsOs2yQQzBX
	FGTUOsr0SCGP27E1tqOc+81cXNcTcnhbkvTKgW9G0H50V87TaeKtfeh+j2sJX3UkRoP2pM
	aWI7Z0ymGLwwvdg5LYXJOy18W8zDgrc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-OSzEpONSO3WmoagQ2abDAw-1; Mon, 08 Dec 2025 10:48:57 -0500
X-MC-Unique: OSzEpONSO3WmoagQ2abDAw-1
X-Mimecast-MFC-AGG-ID: OSzEpONSO3WmoagQ2abDAw_1765208937
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-297d50cd8c4so127209265ad.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 07:48:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765208937; x=1765813737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JhyQmCNeRAwE6U6BA2EWgkizTxmpe6QSDSUOhKlflR4=;
        b=R+wyAr8AYTTWFwfOGnAvUMb+VXZHx/NPmfHDZIWd/FtPzcLEssByzm7U0U0h3Z3qkn
         GIMNO9CHDSEaHr1JDhX+ni15usij7AqS4oIF1Fh3y9ihp2Wj62T1ivLj64Nqzb+w1QeY
         h87ijpF21sajgi/6jtyHoKWMgbBZEFJlQgxbISl46Pzpj02izi0U9AEvEpqOhmlTmiLM
         gTFLxJT13Yu+gVPdJZdclrw4QrHNCYSjQVBNXn2fYXJ0wQBzoaqtyU4QpJQ0Y9F2TRTR
         DL/ERqcRBG3tV+avPAu0KkqX7xbIdWiHHyRhwyVIcSXamURWS+Y3CT9TBxgUIXpO4njY
         o6xg==
X-Forwarded-Encrypted: i=1; AJvYcCW5ZfzyAoDDpsTEKDzU8b0oFWxzjgiPC7TbPPK2Uhff3SRKqngWpsJ58dS28MZ9oQydxU8nSdbv3Q==@kvack.org
X-Gm-Message-State: AOJu0Yzsyi62JhEvQAte9UKPM/uXEzb2zpFooCcr8bcsiWU+9VTNAFIo
	b9qw2JQEezb7x/glT+5VtpAWM4Lyq+2UKqFAs0QMEWuu8fhXtqTNzyVAI4SHndQVuBjubJiAGC2
	sO8LY3inCftnDvNW8asv7JgpQTu4s7IWceLPeUM2VWcMvtNbgnXb9
X-Gm-Gg: ASbGncvS9HRX3yU9Ax986vnrBIc1jj0+Q7qd7wcZOZXkYaEf34y3Z6Px9ei31SsgpBX
	dkkXiZWdS4SfITezotLkR5z6FVQWc+Rmh65dHt1XY2+WlHaPBNT0++UAkp682Z6EUdJBxNmLg2N
	V7C87DUxR3yq0D2lbXlxBARBMdgGp4EBybJzrRXqCFtO8YkZZGOhLzDbIfCEQ4F4CFKD+aprCeU
	Jw/7Lljl4R+LJ12XlgpC/Imc7zxYCvcMzj9aTB2G9vEnXwUGW3ZVH3vIXtWsOkuWuMl526IKzks
	zb5Gaj5+Y1rEZE2ElFTC3UPJvvUQUMugAulHAL8B/HSRZaQw4bPe8L5VQc21VQLoOVlGDabEIsL
	vCg5WIbvIvNhLfRF2L6w3NlIzXxNKBoO6/Gt69qX9n9lb2QE8X69u92HEZ4/zx9UXX6VFyFDvxg
	==
X-Received: by 2002:a05:7022:3885:b0:119:e56b:c749 with SMTP id a92af1059eb24-11e0315a389mr5832007c88.14.1765208936631;
        Mon, 08 Dec 2025 07:48:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2lGw6J4rXoBC0qYrZWnyNE9vY/xTzaJH9ksV8ZOu8KN7rKkS8AprfXcNKR4rpLa/DSIhIfw==
X-Received: by 2002:a05:7022:3885:b0:119:e56b:c749 with SMTP id a92af1059eb24-11e0315a389mr5831983c88.14.1765208936210;
        Mon, 08 Dec 2025 07:48:56 -0800 (PST)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-48-76-65-77-217.dsl.bell.ca. [76.65.77.217])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76edd4fsm54746101c88.8.2025.12.08.07.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Dec 2025 07:48:55 -0800 (PST)
Message-ID: <8b67305a-9057-49fd-92b2-343d237890cb@redhat.com>
Date: Mon, 8 Dec 2025 10:48:50 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/3] selftests/mm: remove arm64 nr_hugepages setup for
 va_high_addr_switch test
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 david@kernel.org, shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20251207122239.3228920-1-chuhu@redhat.com>
 <20251207122239.3228920-2-chuhu@redhat.com>
 <20251207122239.3228920-3-chuhu@redhat.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251207122239.3228920-3-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MoG0dDNiYTvdFi2aoB4qUrem3pJ-d1C4AUve0rweFQw_1765208937
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A823D10000C
X-Stat-Signature: hqw31i6u3knajnop45hrffq35jtuozqo
X-Rspam-User: 
X-HE-Tag: 1765208939-778998
X-HE-Meta: U2FsdGVkX1/z4kXekdFNZj8vcbA8pRDMpUy5l9yHIE8rusaBV1u3wR2aH8q22HKSIpfiapGpdRGLISBeTEFEdNcdzjcjYp5WCBJW6kesiBh/Sy626DDV89CLJWo/09dcWXlBk9hH4L2ibaPKTyM0Lhy53SXqVdfo9dMxJlLDr4MwEujJhpU4LTAS4z3bOZgZHRJY1rTuVofdfz2oWj/s3jLKnGo5UAy/3+KLmLQbppDN5o5NtoXgMi79QXjB43F3GMoQCOgWMfz8V6pkbr2VtS+zgrpiHPvdEqsNK4CM1UP7Xv3FiIHQTNijMP4Z+DqyFYaG6g6wfXnLmu7udXM06uFZvjvEVZhuHdPsqPlZj9MgNOskkjRu2eIaZmayba8H0xyu72CHn3zonnm7nNM7GO7hXC8iV7xAowUDO1W4YSfJ5+rGe3jdMic4w5NSYhl9A9EaIL6nZi1rAlYLoihwK4iFsSQ+Vgj7z4sp/rC2Q8piCQDL9Av8Ve4bkte20ZH6Ad6QiCI9nN65UMgCUJCRkmfWlFmFKnl2u16GW4t4G4yr511NwVC143CSX8mc7++9uoWzMNvbi74R2uXcFUOpFbfLtEwpCsYtVGD8e1FYystoR/wuP/zJSX9Pl2iyOJy6y7BSnJe8Ray9iLyaD9oWoBuOVTS8sWNc8S85mYrVMS0ZqDxfjuzYuGFe0ND9a1eGlvnJ8A1s2IVEa/m1jAmsL1kJr4a2yO5SN7w60r4auUIjq5zfM2z/gLvoqPk8m7kxUGpJzkdlPVdY3rzQAvKUwz1ZQ0FYjRoY1+No6UicT98h3/OYzJiPF7jDror5fKnxaTcW++kO25dYfcgJ+i6Nvsq3eXbUgZnBeUAQbwQ+WZH9EdTzKkQJWIS23f9PoOTlg9PuVeFatCN/gr5CyzKKxxJYqRe5AVWzDQnV9tpgbFxosTH0HTWYhFDpZArSYoYIzn/gtYEiVwlRYQKBseM
 WRcXzPQC
 euSAleMNtzu45+eONbgvuBp+QyIBjH9Ev1vwMfQzw+NvDfvmUY93yXSuYTrU+TZXEQfVRepu9KaSFVj/0sUzDTBga8DyQvBGwEXRyjc6Mcg56w3jr3CFbLMoTiN0W6ZSnUKlLY1p3y/UlYpFHXvLQMYb1TIwXuRJQ5tiAQd8ihURVPszNN8PMGQHMduyNxAd6b23+Jv83WLPafs+QQtzBF3JUdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-07 07:22, Chunyu Hu wrote:
> arm64 and x86_64 has the same nr_hugepages requriement for running the
> va_high_addr_switch test. Since commit d9d957bd7b61 ("selftests/mm: alloc
> hugepages in va_high_addr_switch test"), the setup can be done in
> va_high_addr_switch.sh. So remove the duplicated setup.
> 
> CC: Luiz Capitulino <luizcap@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   tools/testing/selftests/mm/run_vmtests.sh | 8 --------
>   1 file changed, 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d9173f2312b7..2dadbfc6e535 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -412,15 +412,7 @@ if [ $VADDR64 -ne 0 ]; then
>   	fi
>   
>   	# va high address boundary switch test
> -	ARCH_ARM64="arm64"
> -	prev_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
> -	if [ "$ARCH" == "$ARCH_ARM64" ]; then
> -		echo 6 > /proc/sys/vm/nr_hugepages
> -	fi
>   	CATEGORY="hugevm" run_test bash ./va_high_addr_switch.sh
> -	if [ "$ARCH" == "$ARCH_ARM64" ]; then
> -		echo $prev_nr_hugepages > /proc/sys/vm/nr_hugepages
> -	fi
>   fi # VADDR64
>   
>   # vmalloc stability smoke test


