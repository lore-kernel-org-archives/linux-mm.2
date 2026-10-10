Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34623CA9EC7
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 15:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38206B0088; Sat, 10 Oct 2026 11:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FD36B008A; Sat, 10 Oct 2026 11:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25D26B008C; Sat, 10 Oct 2026 11:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8A576B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 11:41:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51F1A1408B3
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:41:47 +0000 (UTC)
X-FDA: 85307131854.07.D43015B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id BEC7E2000C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 15:41:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iKCwVKBP;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791646905;
	b=LZ2TgDGEX2ySBPLqPkuNaLTNSvmPzAP2KKyKp/bmoczIZiBtYZNKoeD7Bu8lYZN4Yoh2l1
	nFO+Zr01mOCv6Hg0ulhiA1BQ2nZe9hFUzc6bwORxJP4eKipxueCnYWnVJYD5SK3qyvqG7x
	CIipz7NdeGbYvb0rKXe850wg8EH5SpM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iKCwVKBP;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791646905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQGlwc/2yUU8o+zgtCEtBmM0FXAGhm3La+GwOgSdudM=;
	b=VNw8vYlidNhnKgGd9xSi5/6kSsm8r5htxUYT6JCIjgAcHDI0gYUlzsz4O69iiEnhGvd1gf
	cS6GLKobJskQ3VPyQlFRrsJ1Sek88EU48aMrrxsGrt9k3ao2cPeOXdS5lWSxSKmAHJQnNi
	hotL9zy1INPsNbLGhASkgnrm1ae7Bus=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791646904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQGlwc/2yUU8o+zgtCEtBmM0FXAGhm3La+GwOgSdudM=;
	b=iKCwVKBPW8B0u6EbVnYXKPPCj3LtwXMwAph1hRfgzH42iX1Pfr7BAUKHW4JBJczOaaf9yd
	R/pFoUJiDdlQ0LIHIPQEziSjxlLVm+XjOqa2gSVa+ztDt9A7q4fYDV/BbIj3B0eayDIhy7
	JWA4mUyPzX525r/uKb4Oig8PI8t0l0E=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-UO_kqA5hMPqdB9avnjhHVQ-1; Sat, 10 Oct 2026 15:41:42 +0000
X-MC-Unique: UO_kqA5hMPqdB9avnjhHVQ-1
X-Mimecast-MFC-AGG-ID: UO_kqA5hMPqdB9avnjhHVQ_1791646902
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93cc7a6e4e1so204229185a.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:41:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791646902; x=1792251702;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QQGlwc/2yUU8o+zgtCEtBmM0FXAGhm3La+GwOgSdudM=;
        b=uANRiz3ZbauEwALyQd4gUMGcjsNjg/15lv9OTMm0QAR4AcT0mJLSvBWUDvk/IyWfY+
         gOpHgO5dZJ1ZL7FR+IwyIM3yQOW0jXz/2TxHGYBafgHQ5IRLoytuxOwkm7TkCode7CfX
         D7YD1+bAQzj7KUSa1JRAd3XS1f6jWjaCbFj7ohEaV+0EYdMIep76JAABv6KcepZC3OvA
         ZPDAMiLZqv+ebz/9RoDJBhGUADOhVZR9D/x0qKmhlosgf6kUsko7tm5uMI3/mymS+BCJ
         /M+o0N7SF/g8WLYIuzW8l9n79DTSrA+pKVPYU3vsN2RHSrbM8FUUqH/AD61YTqGS0p7N
         1PFA==
X-Forwarded-Encrypted: i=1; AKwUvBxS3kQwbFrRJvz6J4NY9Z780QmLgFJolN47rAe44u5jNw50VsfWCyBBwRrYiEjMMreuhCmOKhSyAQ==@kvack.org
X-Gm-Message-State: AFq9FYKR0FWc+sxJTqPWUSm7IMO7KsfwOb3nfXEo5hi9i++OGFbmJTqD
	2rrLh82lX8O+S/Odfr4ahX5Hiu99jLIXemMDxicQp6m/nUYCUeniXlCaz0chtvnmatnmaHIUBJp
	hvHz7kQS9+s2hcLoxlGOC2QkXThc7cJUuWtwewB1hdGRBOv+TuBgfCL7fjKm2
X-Gm-Gg: AYBFou2YkSpMdCquJSTvVwtObcx68FZpMbJYAD1FWf8fjqisGVIXwfJgOpI/sXvqagM
	v6Qvq2oxdDMh/Hf5Ys2AtL+DK++m7vn4HLf3TILU20WozV13JG/fj+K2Ouplfbytxhvv5l/YY7m
	iONY8xXBsahJ3dz3Ge1LItC5s5e1FZmwVgmzjDbcVFdPl9AKtwElRLpCAIsLZCae6LltX3EtveJ
	MGYPyKS+HxR5kI2FPCNOttVKJCJP3Eu5k0RZegwmYyUJX630j/VuB5fBdpT2+3R/f+U1CDFUXuj
	Vlm34Eb6O23Rb4pxt9jSBor3i3csD5s/aRQ5VEgP7NVbK/pbVlzpGkuBfu7jCRyAEGYLUtXwu8j
	fzoM=
X-Received: by 2002:a05:620a:4510:b0:93e:c12c:f13a with SMTP id af79cd13be357-93ec12d0631mr714841885a.68.1791646902256;
        Sat, 10 Oct 2026 08:41:42 -0700 (PDT)
X-Received: by 2002:a05:620a:4510:b0:93e:c12c:f13a with SMTP id af79cd13be357-93ec12d0631mr714838485a.68.1791646901755;
        Sat, 10 Oct 2026 08:41:41 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb9722fbasm453274285a.6.2026.10.10.08.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2026 08:41:41 -0700 (PDT)
Message-ID: <87f6a5de-7ba7-40e6-ad31-e1311033e986@redhat.com>
Date: Sat, 10 Oct 2026 11:41:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86: remove the BIOS memory corruption check feature
From: Luiz Capitulino <luizcap@redhat.com>
To: Thorsten Blum <blum@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>, x86@kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 corbet@lwn.net, hpa@zytor.com, "David Hildenbrand (Red Hat)"
 <david@kernel.org>, Mike Rapoport <rppt@kernel.org>
References: <9e1a161e-9246-41d1-9651-ffa85b1bc99b@redhat.com>
 <asktOXVRiXNOTcqH@kernel.org>
 <e7c7e8df-b1e7-4796-baef-ca5d7676688a@redhat.com>
In-Reply-To: <e7c7e8df-b1e7-4796-baef-ca5d7676688a@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jH6l6XS30jIJtSp4wgMQlHic-GuzFflc6oKDoWeHd1o_1791646902
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BEC7E2000C
X-Rspam-User: 
X-Stat-Signature: ib1anjikyrd7s1jpqkqaa15znyp44zxk
X-HE-Tag: 1791646904-532386
X-HE-Meta: U2FsdGVkX1+xmCBV1NrIaNQsdYXj2PLHm1r4hChvJC0n1CzXkHiIgI2AUyZqYajkhFAG1RQFNyBNVzauhQpn0Y9YCpQP314uHXFZvrWp1/KDG3UcBKE7PnZhZkp12U8qj9cVqHFZFUNn7nqSgn0GtImzAGnfLYXxWJgZDv96mi8t2EC9e/DEwZk1KR92wNbgLJsQgI/bU9NnNNVUESBQBIJGPrrhLoYfLnmR0sdKm9rf0gAqEuPOX238SfM8nCPfaeIqVls1MBjGtta7s1EnqEuUSZ+cfFzXXZS1r7f9ykzPYYZPjgxCcJTPjLsbHS85g0sb/WNNKozJCrLAt6YFsd25FG8OdRnchNHDUxIUd5yGON4VgONXL/ljkY+MzgTDNquEZ+12RR04Sl3iN7RJfM+ZdMxJXUhXJNaImixuEwd7vvSKuGNgPIGGG2ozqMBU4gnvdqG3SCSGWBhKJ/fs+mc8eKSKxSD2YYlZ+DoLVOrC2LAnJJ2U4jk9jEHUW5HgeciqaOOdoe9/5gL0AuS+ZacbNXeUtCG9fgsotHSGVllJfTWTdPmzP9F/14bKDO1UB4HOfLAvx7dgf6sqBdQ6r4lsLm9s0RPwyQPD8QR5G3nAMh3GY0qJXq9jyoW3PalQ9EF9ROw6RIiwccAqrOqG3i+Fq3M3Dck/CWdEHRyvjZ4cykfByFN2942pjCUHLK9jPBypsknhp96cn4E719um6CBQGaFfodrQ8Lgu9m/6Isk3mnXGGdI0VaiQM/2MjqukjVE1nuypUQmnHBs2KojB7pYed0PGacgka8X/WtebJwCW4ZuE43S/H08ofA25Io9CUDyLMmaBnHdiFtFy94+3cUwhPVriDvrVzZ8jXDYpuadL/D2boaiJGI+W4CA/KPdfcw1lrfCWNxjjjpZfEl+gIkZyGgqDVU8/8S3LFZRbpdi8erLAGnrZjsWc/Wh11pPG6xi7iNbZdA3bJFgCT22
 mHJOW19D
 89faCzogcY+OIOeK2hPii5Gxm+5cHs2lQVek4ChKPOW2XsVGRqPqO0APfXNgQs8+pr54wuekyR1mRIoUuFBY5GWX3VyAC/OHaoTmk+30arKa7raU2NdyphiVHS3Ryi2AUyYK4Cbw27FEpv45Wz5A59TDsOW4pXBFdyCTyAJ+KhMoIxy1wCxTHQwErtPeHcjESjkpM7RhgCycBBh82gWGc6TS+JIIHGfzBiTE8Qh1p7IX0BAAqxlg2X6AAd/JantkV41+moZg0LJfuSFuRShy0LszzM4ucWsJWS2zLGtPN1SBI8nrguFg43r9I09DwKcxGayDoi5N39k5gyemxiimVASn5RUxJ2ddHy3S28aVVztOt+BA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/9/26 4:16 PM, Luiz Capitulino wrote:
> 
> 
> On 10/9/26 2:06 PM, Thorsten Blum wrote:
>> On Mon, Jul 20, 2026 at 04:41:05PM -0400, Luiz Capitulino wrote:
>>> By default, the BIOS memory corruption check works by reserving the
>>> first 64 KiB physical area from memblock, zeroing it and then scanning it
>>> periodically.
>>>
>>> However, this functionality has been broken since v5.13 by two commits:
>>>
>>> - Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservations").
>>>    Moved trim_low_memory_range() into early_reserve_memory(), which runs
>>>    earlier in setup_arch(), causing the first 64 KiB to be reserved (when
>>>    CONFIG_X86_RESERVE_LOW=64) before setup_bios_corruption_check() runs
>>>
>>> - Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM").
>>>    Hardcodes the reservation of the first 64 KiB early in
>>>    early_reserve_memory()
>>>
>>> It might be possible to get this feature to work by allowing
>>> setup_bios_corruption_check() to run first, but it's just not worth it
>>> given that the kernel will never access this memory area anyways.
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>
>>> Changelog
>>> =========
>>>
>>> v2
>>> - Rebase against latest Linus tree (v7.2-rc4)
>>> - Improve changelog
>>>
>>>   .../admin-guide/kernel-parameters.txt         |  23 ---
>>>   arch/x86/Kconfig                              |  30 ---
>>>   arch/x86/configs/i386_defconfig               |   1 -
>>>   arch/x86/configs/x86_64_defconfig             |   1 -
>>>   arch/x86/include/asm/bios_ebda.h              |  17 --
>>>   arch/x86/include/asm/setup.h                  |   1 -
>>>   arch/x86/kernel/Makefile                      |   2 -
>>>   arch/x86/kernel/check.c                       | 187 ------------------
>>>   arch/x86/kernel/setup.c                       |   4 -
>>>   9 files changed, 266 deletions(-)
>>>   delete mode 100644 arch/x86/kernel/check.c
>>
>> Hi Luiz,
> 
> Hey,
> 
>> v2 no longer applies to mainline - are you planning to rebase it for v3?
> 
> If we plan to merge it, I can :)
> 
>> Regarding the changelog: did you consider that the check is only broken
>> for the default size? Booting with
>>
>>    memory_corruption_check=1 memory_corruption_check_size=256K
>>
>> still works and I get:
>>
>>    check: Scanning 1 areas for low memory corruption
>>    check: Scanning for low memory corruption every 60 seconds
> 
> Yes, but IIRC this won't reserve the first 64K and my understanding
> is that checking the first 64K was the main point of the feature.

I've just sent v3. I improved the changelog based on your feedback.

Also, I realized that v2 doesn't apply because it was mangled by my MUA.
I sent v3 with git-send-email so it should apply now.


