Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A505CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD258E00B9; Tue, 26 Aug 2025 03:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4768E00A8; Tue, 26 Aug 2025 03:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2D98E00B9; Tue, 26 Aug 2025 03:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A86938E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:45:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F8B05A532
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:45:48 +0000 (UTC)
X-FDA: 83818124376.01.19EDB22
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 06A821C0005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:45:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OseGvsdg;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756194346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/OuiSc8DvwL4ze5IiMvnOja29ttjPgB686MqiOHyN4=;
	b=nwQfnMgP0I7YyaMVI9g4GxudGiH2fOnfh0XoIQqAeOUZ6oFGvSRl1voCIK7kwKen0ZSax6
	R3aZNXa+4xjJAGpEywU9aT6ZwAtyGbJllTfpeFnbNGawbS0ivG2RnjVZdFGtnIYmxX8reM
	klvivcZlPCgztapfHaWq4RwWorlWj+g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OseGvsdg;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756194346; a=rsa-sha256;
	cv=none;
	b=r10lJMaCSa0wToev7qYrEdXooXM7jqHmAd0khDDDuJpW8S62Yamrp99XB7wpSdbqFCVu3c
	yWSXZzqjzo9PxECLW+y4KJd1rizOuxT3E62E4mP/cNA027mZj9GjQQguVGdmepF83nOeDn
	4bIICZx2+jEH1nKxCXCtrNCmjBuCRw4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756194345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k/OuiSc8DvwL4ze5IiMvnOja29ttjPgB686MqiOHyN4=;
	b=OseGvsdgEBqUKlyO54oihSxRfd7t1AsnSumyvOfWLs/DC/RzEHLt5Bn5IzWTPk3ajNiLEM
	P4o+dygdErZk2lsL4VmDRZDJN7vR1gKRmuMik+CTE/YAOs0jL1g4IGlDYZXBJuzskBRoEj
	inRk+F5tRw9G5JB/AZRjzKrirM2n4Ew=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-8zdTHXMZNhO4GulG9xMmwg-1; Tue, 26 Aug 2025 03:45:44 -0400
X-MC-Unique: 8zdTHXMZNhO4GulG9xMmwg-1
X-Mimecast-MFC-AGG-ID: 8zdTHXMZNhO4GulG9xMmwg_1756194343
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c788995c72so1496366f8f.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756194343; x=1756799143;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k/OuiSc8DvwL4ze5IiMvnOja29ttjPgB686MqiOHyN4=;
        b=jCWuKyU7Zk5jdhzZM0utGePGMtF+2cm5MIxzY5w/v2GuqMsbgGv1jTdcFjIOOEB4fz
         BERtt2KeBpEo42aDavUWUWcjYeGd1SKbu5nzIAkZjmMXuLrFkTClV76TTbziP/GbuLua
         ec3zsiJaU7Bhl5DXdxa3Mt7+uYZ3p9tf7KGJNj6v7BsSsd3nGyWPT8IsuUOJOeyJbGQ+
         TYV5UomQNDSxnNguwVSYy2sQv5WsYZIDItn41C2hb0W6UGwZ3tP8iqpF3aq0x0DV6ap8
         wHoumW3NnX5vJP/9/+r5wCAVoONhzD60yrmb4zju4MCG2P95Zt1Omh3zm/FaFAPMtOSK
         YTKg==
X-Forwarded-Encrypted: i=1; AJvYcCXwtczjTK3TAEzAfL9zjkdASIBDc8up2rnEsBzvPRUav89zzMp8moiBa5G5v9BDtKylse4f+xvFXg==@kvack.org
X-Gm-Message-State: AOJu0Yw+OvJ/EtIP+y1eccMX4H9V4VuvqtO+dN2qZQVKpcdQRPaqUlJJ
	NGVU5dC4k99JHeQWW91bt0A0Rax2ab/h8JozS1xslBKG/1fQpnhb1a03VCAFZkVX5vAVv8GsfMI
	PF8GdXpwmNz/kHahsZGIfzyHD+VjBbl8pNIYcR4a9JHX79j0QQPzb
X-Gm-Gg: ASbGncu8Zi/6vGbWn4EO//KbVXgTvYr+oS+yQuHERQLKTtoqKuS7ri0nrHgOOontyTu
	Z7PMrHWAOvMhDZv6Pzhw4BuPgzmD1d5jOtsWDiiS1cQ19ySQhkKHbRs2BHc/p25JpmY2JH/MGZc
	I59Q5dxv3UhIOA9sDQfGW9y7S89zKqIBAXtyJ0a7GeBSIlZKONi6fQLoEhoqeJxP9jh7n/Iau1H
	TjTh6+NaFwUjpLE8/8O1nvy2/Ro7hLyTF4IQraFCMj7ryRMifcvr+KRRUsgKjHO4OGwMYNlaPvw
	/GhvZsDHgDA3GwayMg3ooJX9YjvR2+sK36/lsDf3etlIaLHoHzWhO8gXKTDcUt9dIINQQDORqw=
	=
X-Received: by 2002:a05:6000:40dc:b0:3c9:38ca:2c1e with SMTP id ffacd0b85a97d-3c938ca3186mr6269525f8f.63.1756194342714;
        Tue, 26 Aug 2025 00:45:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUH1J19kuTuf3s2CHLvi8u0X2SupxylUeCeMPuY/SxI9i/ktTCtrSz18UCsho7ir9h8yIYxw==
X-Received: by 2002:a05:6000:40dc:b0:3c9:38ca:2c1e with SMTP id ffacd0b85a97d-3c938ca3186mr6269476f8f.63.1756194342238;
        Tue, 26 Aug 2025 00:45:42 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5753503esm137958415e9.1.2025.08.26.00.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 00:45:41 -0700 (PDT)
Message-ID: <5c983e27-9220-4ef1-b5ac-0be95b37d8d8@redhat.com>
Date: Tue, 26 Aug 2025 09:45:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/8] selftests/mm: Add -Wunused family of flags
To: John Hubbard <jhubbard@nvidia.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, kevin.brodsky@arm.com
Cc: kernel@collabora.com
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
 <20250822082145.4145617-5-usama.anjum@collabora.com>
 <4a9e0017-53a6-48dd-8e3c-774a859a28dc@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4a9e0017-53a6-48dd-8e3c-774a859a28dc@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I19sQ1gLCNcsstnOEB5GSFw44OHxifzk27_HyprJgXo_1756194343
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1z4iq51sqc4tucjs5k4uym4aqqx5b3df
X-Rspam-User: 
X-Rspamd-Queue-Id: 06A821C0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756194345-78602
X-HE-Meta: U2FsdGVkX19RWnAyUepNWZ/XqDbg7NAVgQk8h/e7Cek7qXymBjI4Elb9uNKVk1fWyRyWNxmUBTeu7VkSMRXaqyF1Bwm6Dv7amUCNmCzYLWt30ym2nxvvD8Qzmv/1crMJFlnc6KRU1lT2RroCmeTYaGfxKQNAsKzlHq8GcUkvsk5pvsNy1sGMv8eg5D487VuoEE8jjiwJo6s+liY7CXG5zrrZok4ASPx55a93lMf3e6or5uh6eGyfBg6SD5HnBpoUF6IrhMcX0S4VNMdEYj50t6gLV5/Xj8T17t50I8wfuWxaTKNUIBlrLWtQXuJS1mPFBRRTVipwMc5KucqdbL4fbspCYIr+/9Iys27jzuPq6Pj3puOe68PsYMQ1iICkcrJl6qiXEVV0lqhtQoLp4sU0T1qir/Kjw13XwZ6KaQ0Z19qbgCbWCMA3lHdB/dT2feQY49yVwmHMLtmfjlTkts0x3PE1taUSipkbFgyfd7/HOTQw5owZzPIdXD7C3LANsX8midGZOknER5cS/zBo43vQA6XBu3BJL8JzZ5liSLPxtpw2+3FyS/C6Mr5d7owJoP51PX0bqSIdgikz9x8Oo9Eava7phSjd+W/KmHK4PqsY8ygboumY7StZPc9CFGMOxUEGBZqsgx8mC9co1Qb6Ikcuz6eyJJ5SoQfJloUDNEZ867HRKa9EHgpygwtndIX2qcA19s62U9NjEUUdRHdCh+MDfPQPSf7AH1w4aIfldze4eSg9/mmUsPlNrnekfRHgSHiow/hUAWvCe3KYbJqgRRbTSjtoTEzBB9NCY4bfxF75oLsSNnQukuk8R3oD8VkJ3emMMKdRspbj9m0mpNQcEWrWTmxjB2vSnOCRmVweRkGZQWOOCluMz9WZQdn4My+XUrITRpk7pNgpirLtGTz6jAYf0Y6whXxamwka+yvQzEf2V+HLBCX5So3JtuJZYGDzUfpmSP6G+mvKCv9B0sgJH11
 P161XFAd
 qM8ANGLEogpJcNsE5sGg8a0m4taxmrbMDZ4zIfwpDp4Dx/uwCj44452npoLAMe1j3f/kOPPvsuuB3GWFgnMelTj1w1CqCQHXTueuag6wFXAj6R7SHARxaUluMNx75iKTF58hxcWHr/ENEodyT8zabZSAKM2lFI1M7fdtONQSOD9p3p7ILWP5VkZfPHWKz00YMN54dOmPxpKe4SZrRCT3z55ITdBYLdeHEZsRRFhyD94UkIEtRbwVDyEAIyGjy33B29J1yDN5BWhbIOLheAOZ6oDIJ733+KsRUD835c8MrUCUWqi4Ti7e2bNHJVwQ3cwWbnmrNT+LpGXNfIrqCvGfngqrgMu/86XRiUFM1tvlfCOeiBaeKR7y67Cd3Y75x92ujx/78IG/Dr3lVziFZPZRl202Ze71BHjH/pQgB+ZF5jgPf/NanidWDayDgew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.08.25 20:21, John Hubbard wrote:
> On 8/22/25 1:21 AM, Muhammad Usama Anjum wrote:
> ...
>> diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
>> index 9bc4591c7b169..4fa03679e9b07 100644
>> --- a/tools/testing/selftests/mm/compaction_test.c
>> +++ b/tools/testing/selftests/mm/compaction_test.c
>> @@ -203,7 +203,7 @@ int set_zero_hugepages(unsigned long *initial_nr_hugepages)
>>   	return ret;
>>   }
>>   
>> -int main(int argc, char **argv)
>> +int main(void)
> 
> Hi Muhammad,
> 
> This is not helpful nor desirable, in selftest code.
> 
> In fact, I think this particular patch is actually a solid
> illustration of why you probably should just abandon the -Wunused
> flag in kselftests.
> 
> Skimming through the other patches doesn't change my initial
> impression, either. This is adding churn and admin overhead,
> but for test code there is basically no benefit here. Certainly
> not enough to be worth it.

Fully agreed.

-- 
Cheers

David / dhildenb


