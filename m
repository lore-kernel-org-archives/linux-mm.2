Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7725CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465E86B0088; Fri,  9 Oct 2026 16:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4358C6B008A; Fri,  9 Oct 2026 16:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B866B008C; Fri,  9 Oct 2026 16:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1A396B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:16:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69066C0201
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:16:36 +0000 (UTC)
X-FDA: 85304195592.02.691F274
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D4AB48000F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:16:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bXLkQn63;
	spf=pass (imf30.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791576994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06oOQhiRccqg5uPYKG9qboYKXJc4u6UZT5IOyGCRZqw=;
	b=MhqygHjqGut1+rMojCw0rOOUjk7gVcegEWiwsS9AIBLa4S4hZJTrOpvHE1ylXVr+0hauBH
	FbF8Wj8d+CKEYiH8TRxAfkvhDKMjXW6/CWbEMXx7GK68TKxqGtE96xGXXJpEJqOAAlq/Xx
	VBY8Fe5DoQVh9umKBDVutirol5Vbt3Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bXLkQn63;
	spf=pass (imf30.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791576994;
	b=Wi3YYJ+oMJA3PFLv+iqn54yAqYQgLMHC6PTpmsp4y0VVKHuEXwwbYpC+Omk3CEOZ+mN8yu
	H72Xdkhq3fu8ZvfSpq5Xpf7KOc8ZuGkdPxuG/CJKjiJBcVGZaJHy1+FMIeczS3NszIwqUQ
	0Zf5OUVxXnHMN6e90V3mBjKBDmurR7k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791576993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=06oOQhiRccqg5uPYKG9qboYKXJc4u6UZT5IOyGCRZqw=;
	b=bXLkQn63cZIwFcHM9D1aJvMpgIiWyN8oxpUCx5KaWTANEYeKcxxv7xXDdQ+PL8tFpjRs+Q
	sy0nrtyL/zKNps6GOLSavfkHikOzciBlmWtYJ5XlI130Nw9EtfzCNWHfGNw5A/gMPGHCXk
	WHVXKsDbipnAflPsDk3MskvTYDw5N/U=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-8qQgJA_gMTm4sFGjz3B7PA-1; Fri, 9 Oct 2026 20:16:32 +0000
X-MC-Unique: 8qQgJA_gMTm4sFGjz3B7PA-1
X-Mimecast-MFC-AGG-ID: 8qQgJA_gMTm4sFGjz3B7PA_1791576991
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93be1861d2dso7759385a.3
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 13:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791576991; x=1792181791;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=06oOQhiRccqg5uPYKG9qboYKXJc4u6UZT5IOyGCRZqw=;
        b=aA7zaIY53Uw/8lFx7rz86vyOAd7aVLCPOJDLWMp6Mxd1kW8dj4GnCvdatp8Jwa5mJz
         6AT00hz61ZzQMJF3s3Lc8iGNk7uWlfm3HySK1m1boNMJFtq+Adgsyi43N5gHzyOsbtcu
         o1GrKx4XPxnDlK1ugjKgctWC/NbhGxsH0mJUVdzIgY2FxLZblyNL3qdm9yTboFUcEAVw
         U8+yQDR3p+HLoSxju4KTWeCToN8kteClbYINxFkHeBjmZezHDoLEawMZP6SmbqMaA7dc
         aJbDsCeHHFiCkWup8srnUfyo9pSpZVdzC/wOEDk4S5JBTJ5AAWsZzP9rG3GfUK/amfPx
         k1zQ==
X-Forwarded-Encrypted: i=1; AKwUvByjn26g0sveA5mspBbbi1zaAf87tojEagOZNzXabQJM3Qs6raGSPEflSG/jfGmI9KcI+HmY71KX0g==@kvack.org
X-Gm-Message-State: AFuF++l1sRgFiKOjFP4bWKjLnfJgOqHmR/hB2KlmCvip0ezjLy5fUqcL
	Wz7wx6SawqmhBrvfG3onyf9LxInNger8umyZo/BheLVn2IzO+7VKRwEIhPTnvo+Ujb9exwjGZxZ
	cpIGKpZCQRjWdEjy8Kk7uyk+z5927M+7IsyfGv778Sbuco8oomgrI
X-Gm-Gg: AYBFou1d6dxbZOpQ+zph1FypvRslTmzgRwHZM6PfJQ1X22AfyhUrjytI5TKbI2prLDv
	sNjzL2ImG4BBhU0XXIY+TqCT0jm7Qtw8h8MQfcD/yunTDdhwAQQaDTTelVCf92ysawpE/R/Prw2
	OAk+grU7CesVjKW583wrwAqv6ejY/wVp4R/0ujBEGPnQAn6mIDDjLa1G3z3HOzcz8pxhb2lFYct
	YANxyK3QAMyefT3wEIrPgHmV4ZIL04YRxPz+7e0Wwi3NdWHqp+Z6LgzqTQMChGyK/0s6VOyhHpv
	nCAc6lzcpjWmW0DINS4hPefSKkodmog3bNhikaeJTDuAywkYEAN7HcU4HWkQptuH34gAl5xuaE7
	j+TM=
X-Received: by 2002:a05:620a:1793:b0:93e:c12c:440a with SMTP id af79cd13be357-93ec12c48f5mr367251485a.70.1791576991388;
        Fri, 09 Oct 2026 13:16:31 -0700 (PDT)
X-Received: by 2002:a05:620a:1793:b0:93e:c12c:440a with SMTP id af79cd13be357-93ec12c48f5mr367246085a.70.1791576990896;
        Fri, 09 Oct 2026 13:16:30 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb98cd599sm266356485a.39.2026.10.09.13.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 13:16:30 -0700 (PDT)
Message-ID: <e7c7e8df-b1e7-4796-baef-ca5d7676688a@redhat.com>
Date: Fri, 9 Oct 2026 16:16:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86: remove the BIOS memory corruption check feature
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
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <asktOXVRiXNOTcqH@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4G-zMBsw_Ln7Emmtg0LOZXsJjfaDysPydDG5JmepSMo_1791576991
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D4AB48000F
X-Stat-Signature: y8rix9n1fwhs8xjjk5a5nqpgad5x4uai
X-HE-Tag: 1791576993-642540
X-HE-Meta: U2FsdGVkX1/lpw1zmaK/yu+HtbTJTL0qzs+9XMJyccT5M7Qhljzilej14VpsBYoJH7j/P/6vsngyZMdqYsYStVe5CY5BFJNYh67/4LcIUkXSv63O85A1QtPtDp7Roe0GfnlfZZhZxLbwZ4AlemVkzn5X8jrMYn4lnCt3u0xsj9seSWh2J8rPZAhiwhQl9rOG/ED+Xa0Yj+hiLJDNY6NP2n9V81EmhhupkFVh7c6Q5Rzv8n2dOokrJPyAC5Ee5Lx4KJpD/dG2t9phtHWIZcjoyOVF74GbjalYeD3WU8A67GpHtre7q+jc51S4S6/7qVeMpcH2GgbhdkILuHMf1YSij5Gdv6sFpkfyoBq2KjQPNr8Fgta15IMIM1oHxcurSIueXQtwFpPJytWFcbyGc4BxotPo9EpEGYdwp155AtDLEwiLfMMQohtQuui4wv7aCLgRMvtylp2fh44oHjcyYZ43aHBeWM79Ui/92E5L/dNEIzs6tXhS8fWJ9zz8+I+teDnSBUdprH+J2iBf6z/r+l8nMjRi/O4LqgTW2LZlmrdj38p63D5DQB959K4Q/gH8+cXTu9MeIQJH8IUNzynswR71glzbjGcM5fDOkXXZ/T/L0Z/24yZx3+9YJQ4gvkt8AJaQNj3wneI3ylvVFw0bVRyj79sVlJYfLV0RWU7ECXeoIJnEWqC9Lb8XwB1sZ5J8TNeIMhKoq1aJK3eA+6XpztMVluipKUVi2W+r4+IUxL/ki2DFRG2Srd0NSces39Q6IHawNQPXzg0TCGtm4qZiSj2SvFB7fUasSm0MSDRxtO3z3pNbPs+q8xWLtgNeSvgliZlVZyq7b2PHJXQg+56gOn8Bq8DM1QyxFCyvJUMAtAH92brHFkcTj92HGC43m4aiYUXaq4q4rkGmSjpEmQ5/XtRjNuL2s0yhKJensFbIUDGd0paCmKw+GLjTpEpgCOdAeL/BuHRKLGbb8fXemwbDnyB
 qTnV95q8
 6NhiPlxDxo8uBmDZgkoa0L/2FCdhEFFR+cMt0ahJXYRBe/X1R5gjTRlEHCbY3FcTE61cpnyTIinbR5VxdE5cTMzYkpIH0zayrdGkwQ/B2ab1jBFn74QnETk1kcq1h+CRctYnrjjUdYK1pf0s7TqT3l9XYv6/Vjs7O/ku5Ea4K205OnqEO5NczAT/JgBkMRCfHru3WQBr4tmOJMizJu+nD9UOafiGfUCAi8x+98g9gfGJuIzck1TvD4rsUMakBC3rSHk6hxog7srbz6dBQQ5VAVuuT/LH4bnO9aHXlWWyEFYPULnzMG8EnJqGe9etFZux1EW686tIB0Sl56Sw1Sx1Q8hKeBwGmmJJ7GdYiwQMkUMybHSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/9/26 2:06 PM, Thorsten Blum wrote:
> On Mon, Jul 20, 2026 at 04:41:05PM -0400, Luiz Capitulino wrote:
>> By default, the BIOS memory corruption check works by reserving the
>> first 64 KiB physical area from memblock, zeroing it and then scanning it
>> periodically.
>>
>> However, this functionality has been broken since v5.13 by two commits:
>>
>> - Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservations").
>>    Moved trim_low_memory_range() into early_reserve_memory(), which runs
>>    earlier in setup_arch(), causing the first 64 KiB to be reserved (when
>>    CONFIG_X86_RESERVE_LOW=64) before setup_bios_corruption_check() runs
>>
>> - Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM").
>>    Hardcodes the reservation of the first 64 KiB early in
>>    early_reserve_memory()
>>
>> It might be possible to get this feature to work by allowing
>> setup_bios_corruption_check() to run first, but it's just not worth it
>> given that the kernel will never access this memory area anyways.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>
>> Changelog
>> =========
>>
>> v2
>> - Rebase against latest Linus tree (v7.2-rc4)
>> - Improve changelog
>>
>>   .../admin-guide/kernel-parameters.txt         |  23 ---
>>   arch/x86/Kconfig                              |  30 ---
>>   arch/x86/configs/i386_defconfig               |   1 -
>>   arch/x86/configs/x86_64_defconfig             |   1 -
>>   arch/x86/include/asm/bios_ebda.h              |  17 --
>>   arch/x86/include/asm/setup.h                  |   1 -
>>   arch/x86/kernel/Makefile                      |   2 -
>>   arch/x86/kernel/check.c                       | 187 ------------------
>>   arch/x86/kernel/setup.c                       |   4 -
>>   9 files changed, 266 deletions(-)
>>   delete mode 100644 arch/x86/kernel/check.c
> 
> Hi Luiz,

Hey,

> v2 no longer applies to mainline - are you planning to rebase it for v3?

If we plan to merge it, I can :)

> Regarding the changelog: did you consider that the check is only broken
> for the default size? Booting with
> 
>    memory_corruption_check=1 memory_corruption_check_size=256K
> 
> still works and I get:
> 
>    check: Scanning 1 areas for low memory corruption
>    check: Scanning for low memory corruption every 60 seconds

Yes, but IIRC this won't reserve the first 64K and my understanding
is that checking the first 64K was the main point of the feature.


