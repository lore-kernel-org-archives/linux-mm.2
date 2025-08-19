Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FDDCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA478E0019; Tue, 19 Aug 2025 03:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1D38E0002; Tue, 19 Aug 2025 03:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7CF8E0019; Tue, 19 Aug 2025 03:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE9DE8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:28:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46B7A81FFC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:28:30 +0000 (UTC)
X-FDA: 83792679180.11.0C33B5F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2E7BA0008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:28:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gmw9HCgB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755588508; a=rsa-sha256;
	cv=none;
	b=NKOKjF+NKaUlO/sP58bTxYD8pe9FZJqxBGU6Jz2ENnbXt/7x3zWKKtgQVtlDZchkr9S9EO
	h0vTzvngb0/JFXBOSbYAy6pRtO7XZ0PgXh4Ocm3A9t48Nv984VngcNYrqrR5ILMxRcwks2
	b6PJ5AeM5lPodEu1G4OGEn9OVu8wcck=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gmw9HCgB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755588508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C67CXYyWZPL0PYQM1CJnzY816eVbPhG0ubvsjsSE9lw=;
	b=8qQrfGfgt1sEaoLW+ME+D8VBOzLA5m41SzJpdXdJA81FcLO3V9DVJuh3lUARoSuPrdM9lo
	dZverYY5ngfyzFwirStPs9BF7FyUC5rjag+n8mHaqq7Hxyl1QI0hBsCB8uaakT5gmzZUl8
	fTb7nRXJRW943S1RMq5l5fiHLokraUs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755588507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C67CXYyWZPL0PYQM1CJnzY816eVbPhG0ubvsjsSE9lw=;
	b=gmw9HCgBihkdRlU5fpFebSn3u616/b+C/3/4HN/u95qlXuJ+cs7pvf5GOoWhXhciR86LCZ
	kqFYEcDe3co60tBJO22LX0SNka+WpBj+LSZj34RZOV76Qjv2NJH5ixl+IIsb4D/WXAOWUX
	3ehIUbJ4odTCzuPYjdEFWPCguJpQ/CY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-wnwPebaPPgiOKTrQGX2b7Q-1; Tue, 19 Aug 2025 03:28:24 -0400
X-MC-Unique: wnwPebaPPgiOKTrQGX2b7Q-1
X-Mimecast-MFC-AGG-ID: wnwPebaPPgiOKTrQGX2b7Q_1755588503
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9d41b88ffso2246291f8f.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:28:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755588503; x=1756193303;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C67CXYyWZPL0PYQM1CJnzY816eVbPhG0ubvsjsSE9lw=;
        b=FNwmb3aJss0mY3ae7ctlds8zS2zIVwIlN7FJPLM6/VKr08+84ia+Z1zAORHEuLyljv
         raWZnhqU6b6lSs5b1f8rjmlbV98kc9ElZ/O7kUwrwEZmpSxass32IWSh1LBJw+eod6RG
         FcAYS3AF1rzLBLOR/qUWwWCvi94Zpck1M1POTDJ4mdUnfOBm/rLdWHugNij1niApD0AM
         ujP+V1B5mq+HB7diA9Tv9hcdcKwOgEXHc7gCFWo03iGiSrlJ8IQ00HPDd1avungT6xQw
         qSblhm7dmXPg9/gqnblQXy6Pt7/c6XYjKlm6iV2dtbnQZmUDOF5RL5tTQTz+LW7xx03D
         +87Q==
X-Forwarded-Encrypted: i=1; AJvYcCVGOWAicxD2pmC7SdYr8ky6kXhnCMq3GSyV31UyHb2RrgIHQwpEIFqOmyHvJDyrtIfjL2RUfIltVg==@kvack.org
X-Gm-Message-State: AOJu0YzesngLM2O4bgSpkKIpY4ILnxljdyjQRIsklxcE1cGzqIrULiSJ
	vbqy+k3MEWwZMtcMFAiFqsXR+rq2d6e/YGTsSeiUIJlc94Vh1f6NMup3qkzKL0H+BaaOcI/IiZs
	n8bHlpHsNrUUkVLyCIWD/r2OsBCMgZjTddqdecdENk8SzgLlOES3m
X-Gm-Gg: ASbGncueFZ53wOO9C9JEU7703/wgla2rfH8nOI5ZJm29Kbu1dyusABj0HEAWCsVRJQl
	GJ9xjRTvqkoVWlKVi1m12nnpdpwlRB2j4taK2Ziz+jLG85WKGQgsg+3E5z/gSyBTqZV0gmXfW1X
	TsO5Atte+g648EW3DL4xNCEgMZ6IZjHHO04sqWs9kxOqi2Xc04SATaVjcNJbqU3OuGvESiKjtNZ
	XcP4KyRL4Knqc+8JSpipvWrTWW+Hp4I74T6FV6si+sjs+1891qzSr2qjzNvl33aoIfYEQrVxQM5
	jAKN/jrY6dpOqE+H2rkJx6R5KSi7ktBpl8XhCnkFiHk0jlzc06Ln9o1/8le6tHY7O+XpxM23U3b
	+QzTMs868M298t6VIrZTP9GimFjJ+LY0thrJVCnHCvZVk2/StmPhh6BxrXUlcpisfe5c=
X-Received: by 2002:a05:6000:4304:b0:3c0:7e02:67b5 with SMTP id ffacd0b85a97d-3c0ed6c3818mr1051983f8f.61.1755588503175;
        Tue, 19 Aug 2025 00:28:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGj/WjMJBeZuYEAK7dIsLoScszwyn3R+S0rUMZyxDPtfbSfFcyjc5kvMjglgW5na3LwlXjxrA==
X-Received: by 2002:a05:6000:4304:b0:3c0:7e02:67b5 with SMTP id ffacd0b85a97d-3c0ed6c3818mr1051947f8f.61.1755588502732;
        Tue, 19 Aug 2025 00:28:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:8700:71be:5385:87b8:5a98? (p200300d82f07870071be538587b85a98.dip0.t-ipconnect.de. [2003:d8:2f07:8700:71be:5385:87b8:5a98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c16fasm2472720f8f.35.2025.08.19.00.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 00:28:22 -0700 (PDT)
Message-ID: <38734ae6-012d-4630-8bf3-efefb65f0d23@redhat.com>
Date: Tue, 19 Aug 2025 09:28:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Fixup PATCH] mm/selftests: Fix formattig in split_huge_page_test
From: David Hildenbrand <david@redhat.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, shuah@kernel.org,
 pfalcato@suse.de, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 donettom@linux.ibm.com, ritesh.list@gmail.com
References: <20250816040113.760010-5-aboorvad@linux.ibm.com>
 <20250819041239.167537-1-aboorvad@linux.ibm.com>
 <8142d36d-2a0e-476c-8250-1a69c1f92913@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8142d36d-2a0e-476c-8250-1a69c1f92913@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: toFHjYh7lkxwo53CUhHbpc57uahb4cwKsd1JTXVlqlk_1755588503
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D2E7BA0008
X-Stat-Signature: tmc1dtfukxiq5o87z4mk7kwcqtycemcg
X-HE-Tag: 1755588507-266869
X-HE-Meta: U2FsdGVkX19MCuBjRkKIOp6cZaDOIj9MIOuewreQjbn4VmxCyjbj/T6iuaNx5hm1WUS97B1W5Ejsu7yMw6KkXpsynE3OtKanbp1G+EPZxkRS9heZf9n0pOcRdUROX8o7ZfbnXA2wW9UdkcaZ/cOz3hxu+vLrDPfEqExykrFXjcvodSv3PAbfZtldVV+ktn/oWrse+2E99RfWXxUpJqSaZIO3jYbdGIyzT0xafZlMOttEEd69T5fAbNBDgTWFdj1W4BmnRZHLaO6bek63QfPpkm906Zjinl/pWF0FR4GQmJePvdtlm/pXmhS2ZCFsSeqMT2xUGmSdF820dUP2GvPA9+yvg54/Ou4BYVVq0AhocUEdDQ04y2cw6Db4VF/ZSrs1bUa7F5MNy72/GsmOelR3z9/4QcOfvECz0FYeYT3xJtRvNqUncE3+ZhzIw7wGgY4AjZuMuoTMWiyHsPlHoHKXA1SWblClVQnZ8+dnHuC5t1D6xA+FNU88sT3ke2xtbBm1MNWyYjRxYXEDeSlvUrmZwS3EN1J36TTnIovyVIg5PnehJ/iGHUtj8f714L5opyyVdIN049urmFV5j/g8k/w1NLWkjkHyhXwKfMyZwz7bHXlJ1w1lM9zEO7nBjIxx6+u3BcPiw8WtgtnAfyeFAFTgfk7LeQ8qOUNzHnWIQYx4bezw9PgUZraJ7eyYCzWP6+iFUhl+90a6obhgDLHRBV31yk6RWyifTPBrl/+SfqKFE6aM0smMAG+tc6ZQzRgidAJT5mgJ8NmTSxK8YPAnI4KS6xXebdAj59N0kmEv+lCHVRtGWiXVncjmGFzeg3mgxDBLqeKfP00h5EVyKQMA5nDSaoGCeDQfKq/PIvqvJ66uT8uOq0t0pYe0eqB8/TVFTqzbVLHz0yxR7a/Q1DmTQqe9H9uGYqq3VzY4QOOxTp8KANoCl+sJlqZMi2fxHJNHihDXNzjKs+505qLJr+kaVJs
 qlEwzfgb
 LQ3s91b4KcFlgqQF2gpwQosE/SMCWl6yDMI9evKhZdEK4VQol9L3AKCH/P3gOLfjU4wUmYsYqV+8/BY19EPD6EecbLfWrlZF4b442oMBlhoVkUsU3VvBfvaHNfaJVnnhROQMzF1BCXOhHh6M3UwIxjWFZNISyQlEO/8RJ3MTj+6t/H4DjqAY5qxSVxTcjj9ifXAACEO2D3WK0CTyaRYRC4/15x8AO8ZWChBaYnYKXxmiB0KqvSsUIf/6Q7MkUsaji+Q8RBlXJQDqE3F3du5rZjRU916ryqO0bG7DqiaJd0XW4nDt6IDGLySdnnLasJl9+chDdrjMI3DlGME9vdoGYOFtjlKfUdL9A6hVHi9W5M7VlFELbasGcTQxOThlrDlq+NhJ2xaeYCtYu7Uanxwka+lr0McmwsuGPW7yt+3Am+nS5/yS76/qnQ1qsmI9oUQMWpyD8MasITO+jKrNDkIgxkExPAUB8WMMwlyQWjayWbwyLWlu65I7zEHS47U9his74VR2XRkSScnHJwlPGFrDto1/kbFq8svOetY0Dh+bTfjPvc33Lb9/rYsQq37ZZIe1Coe2+M6ibvGXXP6urddpkQI3Mk6OlH7Js+uHHiITsQFPz4Y8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.08.25 09:25, David Hildenbrand wrote:
> On 19.08.25 06:12, Aboorva Devarajan wrote:
>> Removed an extra space in split_huge_page_test that was introduced
>> by commit 4b76e221794b ("mm/selftests: fix split_huge_page_test
>> failure on systems with 64KB page size").
>>
>> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>> ---
>>    tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 54e86f00aabc..faf7e1f88743 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -544,7 +544,7 @@ int main(int argc, char **argv)
>>    		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>>    
>>    	nr_pages = pmd_pagesize / pagesize;
>> -	max_order =  sz2ord(pmd_pagesize, pagesize);
>> +	max_order = sz2ord(pmd_pagesize, pagesize);
>>    	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
>>    	ksft_set_plan(tests);
>>    
> 
> Please just comment next time one the respective patch as review comment.
> 

To clarify what I mean is something like this:

https://lkml.kernel.org/r/3dca2de4-9a6a-4efe-a86c-83f9509831fc@gmail.com

Gives more context when the subject directly highlights to which patch 
you are replying.

-- 
Cheers

David / dhildenb


