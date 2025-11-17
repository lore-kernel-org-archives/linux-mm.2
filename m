Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C588CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 19:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0A68E0029; Mon, 17 Nov 2025 14:02:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8118E0002; Mon, 17 Nov 2025 14:02:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CEAC8E0029; Mon, 17 Nov 2025 14:02:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CABC8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:02:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42288B7A15
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:02:00 +0000 (UTC)
X-FDA: 84121018800.11.74D6028
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B1922A000E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:01:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ij3XDsFp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763406118; a=rsa-sha256;
	cv=none;
	b=gLmlvvRYF1sH4VXhUCPpNQyeaUHuWjFIMvEuspYxGo7xANN65tqeYdJ49pIALcMbQ0FK+R
	YaIiJm1/418hYJF42OwjKidVZy1hwXBPsftPxJlJ0XpD3o14HP3TlzWNzq3MN1wJ1CNSa8
	rdVPbAeqVCAIXUWNBuN2hqEuaXfOYfM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ij3XDsFp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763406118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omm+YOSkkA/S4z6yh1bZVUMItoFqXoIoAr5Y3phS6u4=;
	b=mt0OKu+GqCosVHVY57+noAK62bAWLldlFRVGUFX+RlhVodyFmikE/JQmhm96yeum/ybDKm
	evWR1Lu0KMzulcm8uMdvMKfZmY/cKRvHanjAIpcVaCx0QPzGAiNN5Yh5xU6pVOhYAV11V2
	y7oqTTs1OxHME9osKSVNlsnRQ/+CjS4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763406116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=omm+YOSkkA/S4z6yh1bZVUMItoFqXoIoAr5Y3phS6u4=;
	b=ij3XDsFpRTe6w4mFSUVYHrSPAl/Ay6yPXwS1Y2qx30Ey4ejEjyS/bLgSWEYwF4muTNHn8M
	ahJ4XAJlUQhk/ZAYa15FATlZQvZs3/Xb7Sqmuis91Vn/t3TSf4YOfOTr3xZ/z6vac0uBFP
	OcZmhQaz/k8e1or7/GqDIuGocXS8sAs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-VBUzuqGoNR2eD0vqCI2WIQ-1; Mon, 17 Nov 2025 14:01:54 -0500
X-MC-Unique: VBUzuqGoNR2eD0vqCI2WIQ-1
X-Mimecast-MFC-AGG-ID: VBUzuqGoNR2eD0vqCI2WIQ_1763406113
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b17194d321so640366585a.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:01:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763406113; x=1764010913;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omm+YOSkkA/S4z6yh1bZVUMItoFqXoIoAr5Y3phS6u4=;
        b=rereh5tJyl5L5WUag6VK+BmBINA7DcKBso9MYamXVIMJD4i8x4tC9zqKGVcd+ffQ3K
         g42+FMHYzYBqS6uWn61GTdMzzRM6oO3dxXP5HzCTidt47XT3zy5hychUgmC5wxktUSHK
         aVCKY+ULvxvqJ/5MbXtakc5zEFXHch2K4AaBdtMV514nhuduNQWM7F14GhN3Ri7uzXIO
         bADQRnU5q+i7AYWCKrSo6TVgCy3TKQj6doU2dDagIuIe8Rnqk32OKVJ9mDXhxHR6H+lk
         0B6d5By9VkaoKQbSHYXUm7YGjVW8FVi2VnsLM3IhtWSqVQIxigPXEuqOKPAET+qo/LGO
         +COw==
X-Forwarded-Encrypted: i=1; AJvYcCW8NghUJUj6Lww4GVfAvG3eRuON/OF6VbCJ7XU7PwTLNe89E0DFrZgohon+MTzVFSleYKCcrVvvfg==@kvack.org
X-Gm-Message-State: AOJu0YyR5jhbajc4p7faS7mT2R0hI0v/CfLCTuQZHjBHUeiQ5rwFJtXI
	//1TK5uTeQTbojvl7zF/rIt5K8tCZQqiOq1IXpDjOkaL4vSehs262Jk6zbn+NEstUGS5CnHUgnK
	cSmsMlC2prBlwY+F4zvH52M5HwtCiNM2XWxFqmRzVDt6DB350jsE3
X-Gm-Gg: ASbGncvG2LmP8VJHUcgiuI9JJlNywRtRdBQOWootGZ94JtTZNMqfQ0NgQNsaVAKHzfU
	k5h86CANuMsxDVvnFc+LoRlvevmy+Ojx3GtveQVPGz1gnXH/9HTd5t5FE6FdePs/3b1X8EuwEhc
	9/ZshoBgjqpG8zWIozCMoUrdleXScx6M4/yaRgaZJhPa9vwz5tsXi5loyxUDf6W6Bf1cNQLcpu9
	d1jHLVaqzvmtodzm/QNpiw46riXkajBGseqZsCM5+ldEPMfY5OKUlMds6i+mlH+5JWxeM3JKjBf
	oX2pMYbUhZOJ5uCHDWJ9s/CxyhXbtAaeyRcrtuaA/9E0FBjV2edVuNZyOzW4ModuwjxwKuESzXB
	dpgT3AYomUlw=
X-Received: by 2002:a05:620a:4096:b0:8b2:4b6:22d4 with SMTP id af79cd13be357-8b2c31ca52fmr1794670285a.84.1763406113357;
        Mon, 17 Nov 2025 11:01:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlfkBq/1YcPuABFdAF4J1QzzNZOoBXFo8Tv61v/46sUxqJNVdZmKCXTJyhpM4K7Po7LkpEfg==
X-Received: by 2002:a05:620a:4096:b0:8b2:4b6:22d4 with SMTP id af79cd13be357-8b2c31ca52fmr1794665185a.84.1763406112828;
        Mon, 17 Nov 2025 11:01:52 -0800 (PST)
Received: from [192.168.2.110] ([76.65.77.217])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2aeeaf9d9sm1030577285a.16.2025.11.17.11.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 11:01:52 -0800 (PST)
Message-ID: <65b0c614-e6a9-4535-9d30-bd2be7a72149@redhat.com>
Date: Mon, 17 Nov 2025 14:01:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 07/10] treewide: rename has_transparent_hugepage() to
 arch_has_pmd_leaves()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <9b56da53df2f0da40be68de9a7208d527b144afa.1762464515.git.luizcap@redhat.com>
 <a64e9422-5474-46cf-9058-73aa29b7906e@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <a64e9422-5474-46cf-9058-73aa29b7906e@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6dZOcp8N0eSW4rYi9Zy3yp8aEhD6W1SUGgpcrTPemvQ_1763406113
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B1922A000E
X-Stat-Signature: ykmb35jcfwe5hx7f9quqk37w7z6ur158
X-Rspam-User: 
X-HE-Tag: 1763406117-884509
X-HE-Meta: U2FsdGVkX19+Sfm4FmjXZc07ejAL7HdTpfIFCI9qv8615nBwChocj/H6t7Zhl2jgRhr3XbCOtLkPCUxxlfrd/bo9pQHTiXDU3qXQZRiB7nVye+PdKO4XJri8ZpccNQd1TKvT5HBenBcXiueBhLwOMcNed17dyA1fAq4byyN1ZNC89uXPK1ufkoQ/+sqmeao/e7tKjJmTcPKKNwo3ZKNGEx2xeteuYE4mEl/bssEvlQmyG5KDXKaU3EJgiI5tMrC9cyijzsiAq6qR9m3D5SeG1XPE2JK/7y/1DAAK5+PDE6N1kkiZH7BhTop78YAVgYsplP8RxEkugJ65vEBvcG1TnbG79051ujmLsR9ytpu26TOZCWCvP4MFLhoBBggkTZI4H11NaSf248Br5HhjJIhPorSjxCCVs2FdTubtp4BVAR+2o6x+sFVdCFAF2Ay2Dd+U5lrqYTFBiYYO0zfborZXpnNBb01DJoiCvLRYR+bn9Noa9lBxCOvJaRhANetZeuP3oVnNGdAvi35T/C6Rmz5GSFnXNuyC50OFvASLQL4Wt9Oote7sZ0E1FuqftxmozDZwdiDxPr9yMAMfe9h+g2jAbP2cz3Vh6Gbvw+x+/1hQe7iBQpTcMvgdZEPrcqicHsvmUW4T+J7Oka71wjCCs0aQduCvizzJZxnzCbDkcs6RjCjoLHOnFPQORwlitYQMcqpFj9mXQCf07b16fKT7Pb3a1Jj4DvE3POJUlgjN5XdWsg/swwKcDH3UN1Wd488dcz1stXjauqoQIHvC9F11Agefb45sFaSi7ZQ01+HhNRPF1rqYimoaY9ZSraSZDlhVcicFhkBy+wy09ExRxoeezV/9p+YsU7XpOJAB3ZUE7Z73yhSr+uc3flP+1pADvLzmRhBRWcaKv3nfZVVLrcTREUns9Pq0aIqH3KpC4BQcjO/z4FmiO8wJ0sDAbxv50El/oAzVhnnhA3am9188k4S7LEv
 yGvVDt0E
 tZBXpMDTv2JpRfI3RoPOWuoEOOEM9EynwZLfGRreLaWocIr/hBucdlpdc+FW48/VnvlCVKPDxryeKOMDxySseKzGf4I/9HUXn7irbwLdZQRlAgqSXJYJTqyyqBbgaYgGykHF0QZxNst3mNJbw6bWigsZrmOvTVnuQlpmcu5WsvVd6CZkF9qctfr2NFhTECaCety9N56XlorqRm52IaKhSOve0ML/KTTap3pjd/2dba/QdkNAM7aelL/VcbO1cdqYmE0Gl3C+nzInG/p9KcwjL8CnIYmkgzSvCgpwF29Lar6GTg0NnKzxgT9M8tssj0XgFefN7jcKzmumP4hxyXHP7iawbCl7f5dEGz9lzEF5p6/UQF3C1oGsG6boq199A+uD79ZO4X5L6d6Z0vnaNlf0cIoxXB736nTeTLKEh/Yr/+lW316pJs/0BAtoJqnDfT6cJ9OOry4CmX96M15o0FCxL7Hef3Zp9XgE9ciDsFyuqvKyFE9snPxXE9WmiRURY94cnIOh1YV4J/7/evFzTQF9sVHwqDbF9Q6HDwf7TClg+mUK7wW1ka4kXt/11k6cMq4YPEJJVHHSXhPHeqZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-17 12:45, David Hildenbrand (Red Hat) wrote:
> On 06.11.25 22:28, Luiz Capitulino wrote:
>> Now that the majority of has_transparent_hugepage() callers have been
>> converted to pgtable_has_pmd_leaves(), rename has_transparent_hugepage()
>> to arch_has_pmd_leaves() since that's what the helper checks for.
>>
>> arch_has_pmd_leaves() is supposed to be called only by
>> init_arch_has_pmd_leaves(), except for two exeptions:
>>
>> 1. shmem: shmem code runs very early during boot so it can't use
>>     pgtable_has_pmd_leaves()
> 
> Can't we just initialize pgtable_has_pmd_leaves() earlier then?

I can look into doing that. When I worked on this RFC I wondered if
arch_has_pmd_leaves() (when implemented by the arch) could run so early
given that some (all?) archs check feature bits so they must be
available this early as well. But I'll check this, having
pgtable_has_pmd_leaves() being available as early as possible is
probably the right thing to do.

>> 2. hugepage_init(): just a temporary exception, this function will be
>>     converted in a future commit
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
> 
> 
> [...]
> 
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index e4c5f70b0a01..02a2772ec548 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -2026,8 +2026,8 @@ static inline bool pgtable_has_pmd_leaves(void)
>>   #endif
>>   #endif
>> -#ifndef has_transparent_hugepage
>> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
>> +#ifndef arch_has_pmd_leaves
>> +#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
>>   #endif
> 
> Ah, so it stays for now only set with CONFIG_TRANSPARENT_HUGEPAGE. I guess that's something to sort out later :)

I suggested something we could do in this series. Also, I skipped
commenting on all the cases you spotted as I think they refer to the
same issue (please, do point out if you think I'm wrong).


