Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6A5CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11CA18E0007; Mon,  8 Sep 2025 08:54:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4786B0027; Mon,  8 Sep 2025 08:54:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A158E0007; Mon,  8 Sep 2025 08:53:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E45656B0024
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:53:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9EE7C14015E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:53:59 +0000 (UTC)
X-FDA: 83866075398.17.93390E2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4A55B40004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:53:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VK9GQjG5;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757336037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLOEr+YqIuXqBDrjXURDf2AfCeVrrz6FeaRsnrIi6vs=;
	b=SX4weBC6DdPND101S5ZgJyMRUQtA31oKuRYo7OrEqgVrMtWQZ6ohrEmFsbLPQBQS9EQDn4
	exJqQIp+4wvUXw2DsAUToLI26KrcqAKQxVk68foGWbcus9F9K+4IcnB7cHPYFPdw5hsYoy
	MwABVSCkamyFiIedqEHVXr6KbofoFEg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VK9GQjG5;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757336037; a=rsa-sha256;
	cv=none;
	b=RVQIB8UKm49lLuu+HjbvvcVlGNMoyusaOYM+azedX2ywJ4Xr3iz9M1e+XGyIiBvxmNP8Lk
	ubzrUlQ/25rNw1Eb9cNSKOq7k0JluQNbI4ce0MihBYFiN+qgPCg8yhBBPv8UwlwsfBR5OR
	AhJoHMSS/BnHZJvZjwXmDlidV4H7KxY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757336036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BLOEr+YqIuXqBDrjXURDf2AfCeVrrz6FeaRsnrIi6vs=;
	b=VK9GQjG5xv/vI0N8Y57zPDjTiMlFTxqH8yJE5L3Rfy8MZYnmBnNKpQJ9bZGPeawfGYeNki
	xI3rZvRlNj0DilPQD3A+ZIaY7ofhnoYMEkdoqu6d35vC25qH1Km8rz9jcgUpFnl6cc8NJa
	YRW6otvNKzAZCvnTejyEC0kvSdBk3/U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-J_npEOquNPmK47CESs1Z2A-1; Mon, 08 Sep 2025 08:53:54 -0400
X-MC-Unique: J_npEOquNPmK47CESs1Z2A-1
X-Mimecast-MFC-AGG-ID: J_npEOquNPmK47CESs1Z2A_1757336033
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45dd5c1b67dso21661175e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:53:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757336033; x=1757940833;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BLOEr+YqIuXqBDrjXURDf2AfCeVrrz6FeaRsnrIi6vs=;
        b=CgpGDr3k/YSm2OYNSZgrJmN0dlBaSByHBH8gT3j0brbxPjg00z+ojMZ60Xr5YZhFTS
         xORLtQ2+Xn6CMIbeSmedHF7J49rs6qQU5Ab8JFYTe+P6sAg3+H1jGnskqVS2DatXdVY7
         o2n4x9HkrgD5FBKHYjX0lfLeSgrSjb0xvTCLGPQh/MkXts/tCwkGZ4yRkJQ3/vopr7ZR
         VuVekeCaNBnrukvd3j3N60NAbX4jpDZZe0wqSxWkMlSGYTpQaRkDl2XXJGb9CfnQd1Uc
         dSQN3trjWPI9mgSAJ+Wn4d5faEwmAI6+AA2YHci565MKkIxTxH6YcyE4KgzENmFdKdDP
         mOpA==
X-Forwarded-Encrypted: i=1; AJvYcCUfH4HrkSJQ2PA4LbVjkxloPvS/+01HCqJcgXGRC18a9LzONItCdwgDBCZoBfEbNL0DPB73xViQmg==@kvack.org
X-Gm-Message-State: AOJu0Ywtit2aA+A3U+fQkel3xhl5I6Z5MBba/FT/9K0s3T9cJR+gME5/
	h1bop/huj3dVXKpzuxXEvLKd+Cs6MWub2GGSV0i5UlbqGt3ou54oze0tHNpkhV1KLi/cyYmf73A
	vKValuhoPQhXy7BAvDSg1QMYRm5IAqKjCvI3kKyvvmGUHrcBZC2nX
X-Gm-Gg: ASbGncsBqNeoEYE+jf8AwfrWIraGufbc92yHHisueAONQqC8ifa6lJzEXkQEYoPlvCu
	d4HWO5yevgBHEb11dEIq92qUcAmDdirOzvW8M/1jy/Xt9PhLzTfUGYnX06tAIEptwc2jC3y/PS+
	UNZ+lW6Yx12hqaw3HUPrfLBxRhgqF/G+TzSe7jbEGFj+G8NW4YLv5VAnVD3jquKlYfszAStxv9W
	09M5LBatSGZZUqhfWBQciyb3rlAaCvmhIB0eXu/TlXZTjfRe2lo2fMk00zhtf3IWroZu9W18LWb
	aMbUGH6KDCygWy0h4JApjRtCcRTISM/C8h8gyz5uUzppCw9QSKgK3GDkWG7Ae42pUrp3jVjtEZk
	GURL51Mq6B1nn/07siPyY5ZsVIidbuLNuUfd9mJDzweVttc+0+DpHF5dmp29VUZp3
X-Received: by 2002:a05:6000:230c:b0:3e3:3d84:9761 with SMTP id ffacd0b85a97d-3e62c284c68mr5425692f8f.0.1757336033169;
        Mon, 08 Sep 2025 05:53:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEhOhEXB3/NANpF0KM4SgHP7UU1Ksfhc0jmNzHaEtL3ivj5fCYOv+qhWrbqhmq7XSyBIxbIQ==
X-Received: by 2002:a05:6000:230c:b0:3e3:3d84:9761 with SMTP id ffacd0b85a97d-3e62c284c68mr5425670f8f.0.1757336032735;
        Mon, 08 Sep 2025 05:53:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34494776sm41285539f8f.61.2025.09.08.05.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:53:52 -0700 (PDT)
Message-ID: <ad4abcd0-30d1-4683-97ab-abb1d151700f@redhat.com>
Date: Mon, 8 Sep 2025 14:53:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] selftests/mm: fix hugepages cleanup too early
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20250908124740.2946005-1-chuhu@redhat.com>
 <20250908124740.2946005-2-chuhu@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908124740.2946005-2-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XJeLFxIYz2i6MS-LBl_3Wg6jLbTTp5_MocgczJlx6cA_1757336033
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A55B40004
X-Stat-Signature: amssfpk19b8f9zxihpujb1mt5g1pdm1e
X-Rspam-User: 
X-HE-Tag: 1757336037-500381
X-HE-Meta: U2FsdGVkX1/zax1d0YnLsZzhqGPzHZ6ujfXfOH4+eYsM8uGsyoaiUdZ+0+X2VJ1FTcup+S8GSwRQ2CoRJgApFGmEB8K3w9SFHPjAFheb+iAGt5GMGma3l7ion/JszCD5Zq+L2EHgTY4G6iYeG1Z7wDprBt2eIuExvy6Qs3Ogcbwq3iXWnV2aWXvkF0pO1EgINnvWmvoedFwrbe3blanD7+qaHoG6LA1SG3gEITok/LIiHemPkwjC8AV1GgA8jcTIuaiT/TdyFlc1uQYAbF2u7QdvpHDcHkaDZSZezAJyxNO/+16lMDMNet6Grwp4xRHSJm+hl074c+IpTMqT0SCiRpMP/Rr5spF92GYCAUJviW+V7oDXNQI+5EK4kCrdR3QJZv6uOL3D9/7FWarQ0yT5Nqbu7bonuxqk8mM+xwl4vlvuLV1RsLVtkUjpfojEgUV4QvFQNgNVMBO8H4PhkQzOS6V1K5uv+yrNkNh+fRiCVh7K82ji+oUrE7ftgrbwSLa7iglHKNvqp/TxyUci4EClLet5MuZZQ2UjQFaUBOpTBeyw9g711QXDhIYpe37RIUqvArolH9+pSJKr3H6TIMtHiytMQzVcGCFoXn+A8nR48aEiQvaIqcFZSTovt/nMGPtUV//7/Oztuyr0k4QFc1Bv4VtxjDSU9v4r9bmQnMgAeC/1Jr6uqovi0Jl8EWGAImq7DMpXO9Kg5kV1pjTcPXWLKMfrGDftyZshPe4bh54FmFuq2JpEj6VxuIv+K3xTD459nLdaYbhqIKdLLutJ6HVBbyKFLqf4F9KZmVp6/Q0AOVg0XYIrc2sqhSyRixYs27ZcoPqu+AaFzo3Wz3L3XtUdGKoof88eIfP/pKCkJWB2zqaVeMqd60dwom3nji1Taqb6miZDXr7A/schREBs3zfP3imsGLrH0nuSbrAeOeuR0IdrKnhKXmArIWQNQurMNVXokcC1q9ZRIDdvGfBdMn6
 q6n99joA
 OSI3ZQV2uIcY+77oG5wQjrBVnwoBFqUInQEH1jfMeyH1IoqncM8wYl6BOLsuvPBQjd5lWr+AwuOof5jSIiHrEUKnAeq9scpqDBzZ/izw2CV6ogDj5Q1L1K3WT6n1O05EWKgZbKIUv266/7EjATjX1UhIoIw+/F/ZHZSQin+GqZ+N2zQVYxOaYjx1xGe3AgYl0RaWei+KEMXKWHANIHIBty/BITiDxZhN7+U1j077Je4jFrsflzvWYBX4ZjkLC/j2vfD33qMIqk0nDfhf7wvf+OlHFsTaDXvWBU6lvMMYCvcXUWJBc5Gp2seo0t0yes583Rxu2YxF27zZ5mNfGDNgxCRuOeJGxrZ6FcOTbyeAsJiVDHLJljrPZIt2j4B9YyFFusJpk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 14:47, Chunyu Hu wrote:
> The nr_hugepgs variable is used to keep the original nr_hugepages at the
> hugepage setup step at test beginning. After userfaultfd test, a cleaup is
> executed, both /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages and
> /proc/sys//vm/nr_hugepages are reset to 'original' value before userfaultfd
> test starts.
> 
> Issue here is the value used to restore /proc/sys/vm/nr_hugepages is
> nr_hugepgs which is the initial value before the vm_runtests.sh runs, not
> the value before userfaultfd test starts. 'va_high_addr_swith.sh' tests
> runs after that will possibly see no hugepages available for test, and got
> EINVAL when mmap(HUGETLB), making the result invalid.
> 
> And before pkey tests, nr_hugepgs is changed to be used as a temp variable
> to save nr_hugepages before pkey test, and restore it after pkey tests
> finish. The original nr_hugepages value is not tracked anymore, so no way
> to restore it after all tests finish.
> 
> Add a new variable orig_nr_hugepgs to save the original nr_hugepages, and
> and restore it to nr_hugepages after all tests finish. And change to use
> the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after hugepage
> setup, it's also the value before userfaultfd test starts, and the correct
> value to be restored after userfaultfd finishes. The va_high_addr_switch.sh
> broken will be resolved.
> 
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> 

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


