Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD578D5E156
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 13:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ECA56B0005; Tue, 16 Dec 2025 08:47:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A766B0089; Tue, 16 Dec 2025 08:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C466B008A; Tue, 16 Dec 2025 08:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 23BD86B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:47:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9206C061C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:47:47 +0000 (UTC)
X-FDA: 84225462174.01.163FE7D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0DB2B40011
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:47:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KCKhqhvQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765892865; a=rsa-sha256;
	cv=none;
	b=lgNBVts7z4zNqMQJab9X0WOvKxFl7BjferMZn1sYamUlQfLyoZyYINu5rodbmj4blSFozG
	eSaCBvMPfhuBq+yF84LUR8rx11FIh6bLbDCrOSiGDG/jFzMlB4ky/MrcTd/01psS5uOnP+
	UVarprtu+lvawUV5rc/vyUrmIkbTZiA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KCKhqhvQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765892865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0n4CifwqOvwMIjpHZmSAKjapUo7PMwuLQMXUO8ulhY=;
	b=fi7YV8S6CguYVwOL/9glFbrrvsnfOR+dj0l3YVtxYE94uFbpS1poETF56F3EhcP5rptZrZ
	vgQOXnh/N7316h2xh2nFjmK1vl382V8aXZqOBKh1KaS2IgwXYXR15+cBo9N+pqHIpss+Lg
	piiQpcnyJBX8aAWZPDDWsxSalgSqh78=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765892864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0n4CifwqOvwMIjpHZmSAKjapUo7PMwuLQMXUO8ulhY=;
	b=KCKhqhvQU/oqfHNZSgLtaFPwUJK06QwFJ7k9Y/cY5rxDvnZu/hhvuwaK34wjs3lzS2ugvw
	nbeZNp8n6fzNoJQh1lW5QtgNjK4vf4x5KP5WxNSVa6hwUinj5+LUWJG980oTi3nxEKZK+i
	x5bgqstQIufyZloEyBnCrkNHm3DSass=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-WCA1H4bTOYqlzVRZkfLbvQ-1; Tue, 16 Dec 2025 08:47:43 -0500
X-MC-Unique: WCA1H4bTOYqlzVRZkfLbvQ-1
X-Mimecast-MFC-AGG-ID: WCA1H4bTOYqlzVRZkfLbvQ_1765892862
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0f47c0e60so50991275ad.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:47:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765892862; x=1766497662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W0n4CifwqOvwMIjpHZmSAKjapUo7PMwuLQMXUO8ulhY=;
        b=qkg8BmjaCzJWjWjmJUVw4UYkFY6Vq4IAvML+b2ydFqMHXA0rRh98tymsTmaASRAz5I
         6W5RWuWlBftFMY97fkGeerhQvw0V+3bQQlaH5GRO3ZTSA8+VQmDNCMh6SCCzsz+qyD1D
         8nkQneccyWEjDmME858+JRr7zivD1GXCOFQVHkeAC2/jRqQ9dPq8u3g0CFm5h6iqIM0+
         2H5mzBddm10sK3InTpc6NXkj37iiywfekeLmX7kfn1TGOZD4+sS8L2aRPk1RIIHfSJvk
         TZPWLBewKyiRTf+YutUGXY5nbPNV9U7gm3ze+gtBtCcg18LbAsCmf/FuS4LNsOvUdPTg
         N2qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUec349Q9YF8pAQtakJZ4S8foevDZ0W6mEuDQs0D7LYElQ6DRY1grrwwl7FwsQB2xq4WzG9xuBjXg==@kvack.org
X-Gm-Message-State: AOJu0YzAsZ0KQb25H5b7HGCQVwe5QkarIWPu4vA6EG2nRwVoHHd0cASK
	Ua57gAktNmC2XmdhgcgHf/p8pFb5Znk5T4QV6vpo6dML5AOLRvjA2xM7rwkWuTCO/GzPlyIPcYo
	CqXA1MWPfudaJ2pgKOJ5KeOg8KnceFRlbQt3A8dwaWe9HhKce053y9CJw3hy2
X-Gm-Gg: AY/fxX7fRAnaO0CiNowC2Zu9J6aYW0Hahf6FmSyc5aNMoXRQmDwXJP8BTfqSJP202Ah
	wb45ICIuoTSf9w9JeKcacd25gcGcMoiBadI9CfibibSZflOIFhbnjvOJxbMyemcCashVvrbcUV7
	o8wdPPIIoek//vyBbk3DIeOiVMKvjtOW2OdXLgXW8DhEt3Cbpm/SKkzPv5yB7/HuFGsUsfWnWoL
	wM1vC+wbUTGg0rFAO+c3+C7KZxcyw7LAR5qo1bqrQaESnkwh4O52fwMVRygK5eSeFinTSCLmMT0
	c3tf5ZDGrrH+MEn5c9gRxueHYkJBMPwwG3oqxCr2VjMenytQWCh/D1U0AheY9NuLSyTob6YWAOW
	kwCVx0jKndKqIYAUdaorIkI/dhNcse14BEgkL2Srjr1rFlXZPCLgFtVf+1RnhJcYKYmNi4P2L9w
	==
X-Received: by 2002:a17:902:f70e:b0:2a0:97be:61a9 with SMTP id d9443c01a7336-2a097be6574mr112823985ad.35.1765892861894;
        Tue, 16 Dec 2025 05:47:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFOAT6ChXidKSysrv5fzvM2X2al/IO1pMJyWOa3bMDlY/CL6pyVZsGYISmFkpjgkrgOyaQvaA==
X-Received: by 2002:a17:902:f70e:b0:2a0:97be:61a9 with SMTP id d9443c01a7336-2a097be6574mr112823665ad.35.1765892861519;
        Tue, 16 Dec 2025 05:47:41 -0800 (PST)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-48-76-65-77-217.dsl.bell.ca. [76.65.77.217])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a094398eedsm105797345ad.37.2025.12.16.05.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 05:47:41 -0800 (PST)
Message-ID: <64b1e5fd-113d-4874-9b6c-6e344bd24ed5@redhat.com>
Date: Tue, 16 Dec 2025 08:47:36 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] mm: shmem: use pgtable_has_pmd_leaves()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1765833318.git.luizcap@redhat.com>
 <e2eab9e249d10ea559e1e3c9e9b224bf2822d13e.1765833318.git.luizcap@redhat.com>
 <e7514940-1330-4c4c-84f8-fb9d66fff80d@linux.alibaba.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <e7514940-1330-4c4c-84f8-fb9d66fff80d@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 34gunVP_6MEBXR7OFH37uOV4jfTKv_ILz9zLhFFjEXY_1765892862
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0DB2B40011
X-Stat-Signature: cxqo1cesnqp6bmk5mw8dx5swmhbx48qz
X-Rspam-User: 
X-HE-Tag: 1765892864-397298
X-HE-Meta: U2FsdGVkX1/Px2r3mEvqXKCYCEmKMBGRHDBHoffSjSsbRDwEObjYQt62aJiPLpaPqQjyA6Wn7MVEB8nvZGDGj8jyzTehfUrJdtNQxOExq+dMh9hkqiCh1MjH64Lin0ZuBrNX0KT44h2ehfUsLbjF3S0ofIBZTyHXRA56KQiOu6fstHmXQ6p66YpxzRh/N/c+Y1nV+NHAZeLsP+ECuZ35scHIVYfjdlTRxF1I1cSCzF8/W48OHDgSZKCYj/JPA9QmDrol8+K1kKY1cOYuOBE48hfNqzZFbXTVHfJO31wBFW4f3qfI63HYf/dm23jST4qXD3SFtj/fkxnnHgEUFiweFqayNsv90+IDmMT5c5puZr/X8sRmaYEfMKwWi361vOQwKfhKr0JTuceViI+WH+kmW2+AWdne5E02T7cOrLrbBUUj4pBFDLyHhq46BLPfAe/w8dc8tbIQQHw05Ik1nNAxiECj4uaKGaXyGM20zUz07AM+r3VmMfVdt++u7MMto4WRp2ZMfQWgdNdENvCg6Kge6/QUWLNtVbHt26ZvuZPZ81fBIkJWKFI2sgYDU4fpqEiHLh8+ZJFl6jcOHveGCUps1KFV+aLisnVXsbABTKbEFhvzXy+O8GymZO3MTG21zuwMhRQ5O2dQSWzLDCYZo7Ae2nfsg1TAcNXO7sXuze2GaHGU51J50hqEa0yx8mjwjGU0CxCB+0MdU/a86rFuIgKUAzxq/wB/DSeGZgOP8yy51eKPaDOBYBOxl8j7zG9cgvbxvdRFrh/WNnb7j5ygQyXagvFmspuWJLhSdoctOZHpExJ7zVoco8PuiZB1ZCoTX9rZz5FESS39wSnNMNQkM05pECrWCYtFZfsDOnA10Yxv0xQXE3GSd7CFSIhHteZ3tuL7k29RLf//DfVrbFOlpf7tbSMAbBrJOozYYn4EkrrUsoo79N1ySlhQXfKsYVSy87vmTYkM4V9VjGoysK+Vu1j
 5zjTKXVm
 1Q1PU/UYLqwaVrlws5CJAAZs3YHNmpuSchcO+An2I39PSlplFUIy35LPfM13xR+WFCHT4IDkedCLXMYSy3UggwRIpzThKOoWSKbSJk1wSQ/MP8GUGg7YGM38KqSJc3Ey5YFAdSIAaT1X9Lh9lMlekI6M4vcS7LOcF88hQw+9KccHgELHmKuRXTPXiaFdq0iTq3ajFg6lBKSE3QZ72YRUBh7VHFlYU1LA6cJ3lNPb1m5ZfmKnf4g8QD/jd8Q4E8dFyR+KdZJNc2wbk+/lNb3+h1qzR0w3hSogMuPsgi5J8nw9M81VFdygZuzEo4iooI781dTT7SUJFstvQG1z0hNToRiX/tz6ApPlhb4NrglAwtpXsvaRfQnBPsxUefiYOIFO275INyafiwHd1iPW+G5/n1LwDLwFj8p6zBX5G1wH629L/c8CfBH07g1ldE/2zUZycjy6qko7RLFEZW5gD48l2r6TrJT0gOo0YHnR31JP8mU3/rW/xq+dTrqafBGo//I/Gjn2NWpJFuC63LWIVmms4okGOqbPr0AQt58hGhYJxsD7l+zE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-16 02:52, Baolin Wang wrote:
> 
> 
> On 2025/12/16 05:16, Luiz Capitulino wrote:
>> Shmem uses has_transparent_hugepage() to check if PMD-sized pages are
>> supported, use pgtable_has_pmd_leaves() instead.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/shmem.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index b329b5302c48..ad5825667b49 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -689,7 +689,8 @@ static int shmem_parse_huge(const char *str)
>>       else
>>           return -EINVAL;
>> -    if (!has_transparent_hugepage() &&
>> +    if (!(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> +          pgtable_has_pmd_leaves()) &&
>>           huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>           return -EINVAL;
>> @@ -4655,7 +4656,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
>>           ctx->huge = result.uint_32;
>>           if (ctx->huge != SHMEM_HUGE_NEVER &&
>>               !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> -              has_transparent_hugepage()))
>> +              pgtable_has_pmd_leaves()))
>>               goto unsupported_parameter;
>>           ctx->seen |= SHMEM_SEEN_HUGE;
>>           break;
>> @@ -5439,7 +5440,7 @@ void __init shmem_init(void)
>>   #endif
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -    if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>> +    if (pgtable_has_pmd_leaves() && shmem_huge > SHMEM_HUGE_DENY)
> 
> Using pgtable_has_pmd_leaves() here is a bit confusing because the definition of pgtable_has_pmd_leaves() is: it returns true if the CPU supports PMD-sized pages and false otherwise.
> 
> However, tmpfs and shmem already support other sizes of large folios, not just PMD-sized large folios.
> 
> So, for me, using has_transparent_hugepage() to check would be at least clearer (even though it doesn't change the functionality).

This is more of a naming issue, correct?

Would adding something like thp_has_pmd_support() which expands to:

	return IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pgtable_has_pmd_leaves();

solve it for you? I suggested it in my RFC, but David advised not to do it.

Also, I'm not sure if the comparison with other folio sizes apply, as
PUD and PMD sizes are special.


