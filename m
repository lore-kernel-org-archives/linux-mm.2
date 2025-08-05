Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA16EC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8108E0002; Tue,  5 Aug 2025 08:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88FE48E0001; Tue,  5 Aug 2025 08:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5EB8E0002; Tue,  5 Aug 2025 08:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC888E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:13:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEDF5B82DE
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:13:58 +0000 (UTC)
X-FDA: 83742595356.26.B83F2D6
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id E5A4940010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:13:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ep4eSDMa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754396037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQRMFhKZNRLRVXrqn1NUSMh/FhCDWMwTV0xGjqW0gQ0=;
	b=aX/9Usn6yFFiFTGWDvHKqB1UtOSUzEDfu5/gNjpeI6pRFnli2dosBPxPWkUi19miInU1U0
	wGm9MreyKNqHJQ8ZrEMtW5yLQP3gwLI4GceS3uy0XDeLfp6vMGfCMW1oc1bGfGow3qe2j7
	WvhcFIqjBjRVBelWaJtkboTfwbLCXzc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754396037; a=rsa-sha256;
	cv=none;
	b=Yy9WXkYvcBENhe+BXrXvei114lREzETXV+ab5wC6rCbTWVV4T8Dprg3JtSKBL7lCh86YWb
	SMUKEOHdf86VNX4Y1wt8iBtCOrlonAqMkIgQA7a7AtSQe+doUn+IId1Syvm12xF2ZDN6P4
	qPFDqIlD0LQb1ZG1Jjbp0hxJK41gP8c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ep4eSDMa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b783ea502eso4128477f8f.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754396035; x=1755000835; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GQRMFhKZNRLRVXrqn1NUSMh/FhCDWMwTV0xGjqW0gQ0=;
        b=ep4eSDMaDqlI6T5e8tTpnVSgiOvSKXI487qSxE7C7YkXFYSwqGaA1iAQbl7z2jnfXw
         qQcn2aqQzrHIi7QgNDSKLw4Ajq3FcNXQSAqrU6ljuFlodLUKzFIgu5T6ZJ5HBh5aA9Y9
         SUbi6SDp2oNO0U+uLqGZYKMbtKOtKEArNyols+ohURtKKONndoOL6DCs7wbJMuKXEPvN
         dzMp7s/dvOz9q7JQI37p+IFVgiJUw2O/X9fU4RuCWxLO9+8ExJKXIctBVxGw11EeWxdm
         m95uQ5TL8NE4grnqnD9xkas04tqIs1i2Y9wCdcu5HXITfNYfH+O4xMtYla7QZYFsuf9e
         x0qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754396035; x=1755000835;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GQRMFhKZNRLRVXrqn1NUSMh/FhCDWMwTV0xGjqW0gQ0=;
        b=vCpelliJ52zi4LZSySSVFXTq/5+tDHI9TR1ExjqX4r/VdWVD1nUeQmzyHKXIUP/JE3
         CZC7kLRqFpMsYnr6fNE6pRF++BGCKfa+RUHP2wSqOSnz0girYo8notPy1GXnM5cL8U3h
         AeL+1VQDOHypY8RYjMUC3DwfopSIv8/Ll1a3vDhR/Jn2HNhOGC+GJQPKAjLHXtKmq7q8
         WDC05c8SwzcPVYzq7JEExd6zd1odFQHWa5MjR4v/ftShzoNXqaFzMd0lbgoOCvB6Pxfp
         AO69EHaoJbRNTVYVVt4Jv0oNPgKZt1uRUSwnQ7jV86M+sDnb/dO23dI+6clIpeY/sxTT
         lvVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsflCKfXWd9+uV/fRf1AdjQArjCkLJlMHSnqKM3fBqNm1DS0Zcmbum87YmO3qHamn6emnEXrrR0g==@kvack.org
X-Gm-Message-State: AOJu0YwkQDESHz8JS84wDVXUArgweyY7sBqxGIg5fUHlmvvCwoM+4Hr9
	49Dim1gPdkkh9gGEAR2bol8js66Ip4GP4MJ0ropuxSRmTkl3tVKewvBl
X-Gm-Gg: ASbGncsYZz8yp1jbHl9w3H0l3/iT4waHKDMoGlQVYxyxyJ/ddd6B8j5X8sNvVM8fsLE
	03bOTXMXb36b7tEftOjMXQB7TliZ9oPJlnEFrV06j6i/IjgxFdGsOXGf7MRxBYhc50KtoSiKLJ/
	JOrYgChfMF3XPrvz8fM1Z2CS39xKzFLC/3Tin2KBp1v20F/HeLzjsXKuV9JQpHZjuVnXFTgKWzq
	6WqTjSYh5ICAG3fbaoYcd628olVybFhKy0LMxcX0jfqxhEdCHJInkIhkD6iXlnbCtkREmtnrne3
	6Qer/1uspxgCA7vjfzxD80dl4ewekYtZvebGXEdQM7pdMywIp5bwt6UpE47m/aVqDhdKIk4R7Vc
	Qon0Ol2Wxn3limRfcJgTA8lL+WbEMPU3YuTKKXZZMu9GEyrDI1sB0gACOAirPDE7ARB3VqNy+u4
	4VJn/Y3Q==
X-Google-Smtp-Source: AGHT+IGwRKtI0tVNRZIj++4L7ABQYvhpdiJwXLcYY2IEL2oHCw8906db2fHyLCpfcG5BZzaLfo/kpQ==
X-Received: by 2002:a5d:5f90:0:b0:3b7:90c7:325d with SMTP id ffacd0b85a97d-3b8ebc9e883mr2324975f8f.6.1754396034932;
        Tue, 05 Aug 2025 05:13:54 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::6:98ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac036sm18872226f8f.15.2025.08.05.05.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:13:54 -0700 (PDT)
Message-ID: <2c795230-5885-4a1a-a0f9-c8352b9e7738@gmail.com>
Date: Tue, 5 Aug 2025 13:13:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] selftests: prctl: introduce tests for disabling
 THPs completely
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com,
 Donet Tom <donettom@linux.ibm.com>
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-6-usamaarif642@gmail.com>
 <eec7e868-a61f-41ed-a8ef-7ff80548089f@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <eec7e868-a61f-41ed-a8ef-7ff80548089f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qg18yo3hwmkds5ynjmuyacnt93wgbo6i
X-Rspamd-Queue-Id: E5A4940010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754396036-623212
X-HE-Meta: U2FsdGVkX1+Ww/opg9Ux3LymR2k5KWBIDvgU1kXfenaq3h6FREDPKOyNlArj4tJpA9eZQWRErJgOaFMhnbkitMIcVn/h6c70SAnbmOlZn2iYvr2OzHRv8wj5yf1SYGWt+SgZYN6MD7vOJ5NCEYu5PyvWttRkoPIDq8oiXqLOHX2LteF9qlX/XSojksupOVg0mpIqsiv2WCIecTcvH8WPyRAfl2ODE1SiuACS7hXa8haR+a2n3YBccHQlS2D6ck7nX0uh/un7d23Vy0EWIYIBuC9Ou6pk6xw8nTN0W7ym36EEzwBoGz06SojUFiwhtDaprEL4n4bRq9ZgLxebV6ThK0VOyoKK5qJeFOspiiy6S1OK0Y0KKwzVUFXDBc90e/Pm0FIrIPWpdVNtlwGLWQpvUtGXJXo/U7i7EpweD29KFBO4wfeVJkANbFF2MxrCbJvmAG72CJprgjB7k9BeaCepGskPw0h5N5WN0ZFX9WogT23hNSWb+Wr4vdMfjRzMJgvp6xbq8CVj9y1f98BeXbPoy2gC1L+kii0Ra3wAtP/FHFq/hudZkOBI/FRK8ozbUYz6Wxiq6LxqgZsQt+gmT1hEGjTA5qC1uAeF04hjtXpP6e3Rybh9WXIqZJ4jP8wI10eTgGeiZUn3+NkETTykVqwENgZkiFk/1dX6fhX3veIsII/tNAlh/dPzKyFSDqc/2Vr8mkPMbvCzd404mN0zt3jYXVgwtv1+3qep0grlnf3QhfLTa2f0SySQsmOac59v4+XHD3PQZ3SYwRfbTvDhVMuWyGzvsl/KF/MzFUprpS2guPSlBgyC9Fgj2aPHTUrowtCSURLB+Tu4QMBv2+RkYqEc0YPY3KS7smj4QnVEZUtjC3XiOK59cWVIbqKRveFxZHui0Uue2zEAxxn3y+2fTAlhSsdBmRgeu7+NsqZgS81HSuXDgDe8xYkMJd+paLOyxQiti9hKVNnVMfFXyhBho9Y
 nK2/z29W
 G8isce50xZ9PUBDS9NomVycb8nr5OWMAbT/9Ai6WwDcASLvQWowgAlLEFaMiy0Wm+3KQo+NpmDet8L+2HJauaeV/u8wyvGNDeOWvZHa+NFCU9aMGHPtvtZQJGwjW3K9GEhIr9ZYoXJqvNgMyn/WBsZnKQH3VpUtonb3qTcDvLu9yeUPAuLSrSKZD9LN1W8hS0sUIYAr+ELJHs0OIjFKqvUEjDt02WatfxWPtdQVWtdFyj/pTLRBrZ33R7dPxdsYEdgowrkYDy44pUx+oD23+ZKm8PNpUOCf6LyVsAy7VXWtS7wnf3BdIu4iKbNUve/uod0fuGMIFNjA+eJxLYsBfOK3v5hS6W4Kk/CQWoLBm4MgT2FnVgyFZrrN1F444+xr7v8fkKPN1E3g2cGJvqoEZp/IN2bgFNAIOVFnOSE/8vXLChV4QmdCO4K2W//KASRM9ouYp9RMe5lLYxbnrDWdbMtXQF9+CW9Bsm/H3VAMVpsGBRkGrlF2B4oDicNCj3bRoQh/Vh7G6F3eIjh58CNZZr0s8TqN6uBXiVYouN+we5GC7xiWW1KycmNdZfCqEV5ehJXCZ6RLB5vFgXtrQG/eg53YOL70oeleHQXWHZYi6yA60TEyGaCuwL4wke58a8uOm+shyp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/08/2025 11:30, David Hildenbrand wrote:
> On 04.08.25 17:40, Usama Arif wrote:
>> The test will set the global system THP setting to never, madvise
>> or always depending on the fixture variant and the 2M setting to
>> inherit before it starts (and reset to original at teardown).
>>
>> This tests if the process can:
>> - successfully set and get the policy to disable THPs completely.
>> - never get a hugepage when the THPs are completely disabled
>>    with the prctl, including with MADV_HUGE and MADV_COLLAPSE.
>> - successfully reset the policy of the process.
>> - after reset, only get hugepages with:
>>    - MADV_COLLAPSE when policy is set to never.
>>    - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
>>    - always when policy is set to "always".
>> - repeat the above tests in a forked process to make sure
>>    the policy is carried across forks.
>>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>> ---
>>   tools/testing/selftests/mm/.gitignore         |   1 +
>>   tools/testing/selftests/mm/Makefile           |   1 +
>>   .../testing/selftests/mm/prctl_thp_disable.c  | 173 ++++++++++++++++++
>>   tools/testing/selftests/mm/thp_settings.c     |   9 +-
>>   tools/testing/selftests/mm/thp_settings.h     |   1 +
>>   5 files changed, 184 insertions(+), 1 deletion(-)
>>   create mode 100644 tools/testing/selftests/mm/prctl_thp_disable.c
>>
>> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
>> index e7b23a8a05fe..eb023ea857b3 100644
>> --- a/tools/testing/selftests/mm/.gitignore
>> +++ b/tools/testing/selftests/mm/.gitignore
>> @@ -58,3 +58,4 @@ pkey_sighandler_tests_32
>>   pkey_sighandler_tests_64
>>   guard-regions
>>   merge
>> +prctl_thp_disable
>> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
>> index d13b3cef2a2b..2bb8d3ebc17c 100644
>> --- a/tools/testing/selftests/mm/Makefile
>> +++ b/tools/testing/selftests/mm/Makefile
>> @@ -86,6 +86,7 @@ TEST_GEN_FILES += on-fault-limit
>>   TEST_GEN_FILES += pagemap_ioctl
>>   TEST_GEN_FILES += pfnmap
>>   TEST_GEN_FILES += process_madv
>> +TEST_GEN_FILES += prctl_thp_disable
>>   TEST_GEN_FILES += thuge-gen
>>   TEST_GEN_FILES += transhuge-stress
>>   TEST_GEN_FILES += uffd-stress
>> diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
>> new file mode 100644
>> index 000000000000..ef150180daf4
>> --- /dev/null
>> +++ b/tools/testing/selftests/mm/prctl_thp_disable.c
>> @@ -0,0 +1,173 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Basic tests for PR_GET/SET_THP_DISABLE prctl calls
>> + *
>> + * Author(s): Usama Arif <usamaarif642@gmail.com>
>> + */
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +#include <sys/mman.h>
>> +#include <sys/prctl.h>
>> +#include <sys/wait.h>
>> +
>> +#include "../kselftest_harness.h"
>> +#include "thp_settings.h"
>> +#include "vm_util.h"
>> +
>> +static int sz2ord(size_t size, size_t pagesize)
>> +{
>> +    return __builtin_ctzll(size / pagesize);
>> +}
> 
> Note: We have this helper duplicated elsewhere (e.g., cow.c).
> 
> See [1] how we're going to clean it up.
> 
> Not sure how to resolve this. Probably, which series lands first in mm-unstable should clean it up.
> 
> I would assume that Donet's series would go in first, such that you can just reuse the helper from vm_utils.h
> 
> [1] https://lkml.kernel.org/r/20250804090410.of5xwrlker665bdp@master
> 
> 
> Nothing else jumped at me
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 

Thanks!

I will wait a few days and see if it has made it into mm-new and rebase and send the next revision.


