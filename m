Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA97C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 14:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885B96B0096; Thu, 31 Jul 2025 10:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836DB6B0098; Thu, 31 Jul 2025 10:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FEBF6B0099; Thu, 31 Jul 2025 10:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5F96B0096
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:54:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C4E980A7F
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:54:47 +0000 (UTC)
X-FDA: 83724856614.13.970ABAB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 91DC5180007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:54:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Udzb+3tn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753973684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcdAMsNdTAq+2YkeVqnBXkNfuDQDM55vEhbjhHl9CYA=;
	b=NHQ9liSltLZksreOla47aCtslSa+PDqCoKXji9bAAfGcMO3caGcYxAzEkpsqFt9YD1a9C5
	4X0rSY4Y3kglJaSRIy8uiRlOn8GfnXD/YWJZUmzOO5hr6WJZDM0ZtgM+bQjGJfHbqSIb1w
	DJQnoBSuEm5ZaB8uxAF5n0F8x5vDHfY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753973684; a=rsa-sha256;
	cv=none;
	b=2V+UAwOTCcj0i2Kcj6x64vUHuHljB8k9Jlo+6ITLtnRJe7sr+rW9KjZyeDYK6AP+SLrfQe
	uFKKQupzYOpdEJ2vF0KtP5WhyQv/nl77n43dy1IdJN4LkPprPQd3hI9vqj1xLEka4nLUPZ
	5OLqaqGBQZaG3qQna3w36MnOd4fCej0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Udzb+3tn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753973683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pcdAMsNdTAq+2YkeVqnBXkNfuDQDM55vEhbjhHl9CYA=;
	b=Udzb+3tnb0VFNvgoj3LLsk+fcc9ffYMRiwQy0g1mzcsd15GT73YfW3vPysSnFe0q0cw9+3
	aK3WyBLztSJBtkKS4wfKQP+ALMhS48MHqBadBGaOalA7Lro3qeZ5OJdpyvD8suV4+el8bU
	NL4CYk8M4RwV0aDMLJNJ2C3MmhPbmHo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-2zRYTlZ5OhWUy39SWtHY8g-1; Thu, 31 Jul 2025 10:54:42 -0400
X-MC-Unique: 2zRYTlZ5OhWUy39SWtHY8g-1
X-Mimecast-MFC-AGG-ID: 2zRYTlZ5OhWUy39SWtHY8g_1753973681
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4ff581df3so440890f8f.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:54:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753973681; x=1754578481;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pcdAMsNdTAq+2YkeVqnBXkNfuDQDM55vEhbjhHl9CYA=;
        b=LVbPFT9snNssCEDAhdXBCC5dzS/kkZzZGxg+xt/+sUC2Fgxy7jSdqYE8prpGLLx1wL
         YZIjrzDzRWDxGylxVy2eT5cjMx7IXaLbLzBm8xKW6fA0yUzHtfJB3Q+3ZVvZobMoHl0t
         ezC5hAYXoG0+QCbN/GHGTT0ikZjqn+I2+rSunE1953W/n5byK6WkwzR6uJvBa+KELSto
         wYVI5DGYxLqsPQjDw9dnFyW5gPy9YbREoBESL347199JY18u8gEsmwMz10e+uKpT/jzk
         aB8JzM0rPYMFOpEwUISKF8gdP6CGlbUBVQQyqcE+AY5p+5mYXIyqG5PhEt5FtttB92g6
         D4hg==
X-Forwarded-Encrypted: i=1; AJvYcCV90/RzD/ZDnAAobGqZ/0NL2FEOwN2Mvxn66tzoDQQB10ZF2f/syx+w2aYWmnYZ8Wu7zgOfPledAQ==@kvack.org
X-Gm-Message-State: AOJu0Ywj3MLBSoowWqP22dTSIjtCTIMZrwQwef+iWkTBnwqLcJI138Za
	Sj8UJK23yxBuWJ7Vr0R6RKfyEWNsv4QagpBPlGc0qAW3iM/B6xoYoUCUYZMqwsmEbxFs19fqCf3
	l6Yp0SFhoSWJudNygDeIAldi4KOwARDqJ6K9zTlP8FE1x4O3cEFS/
X-Gm-Gg: ASbGncufzJBl9AgyCQcNijXZorT3whNpD0ss1qgNzQIh7DoQfHqvIh3IOAA8dq+IUkf
	tlTvUwlMvbegk+zWav/GiwTrDNRC2qjsI9xqsZfq0pVHEn1azQChoQ9bZPgzvQevOu0HIrDFDVI
	Hx2f4JUE/FkqcuPDgBa1XR3j4juQM2eIkbO/14awC3loJPwIchenD8SEDZOpIdwZTXiXGIHTKtt
	/PVyI1ngfQsKIsl6/rBf3VMk0EWax/BEQqc9SUIXAJcZRiyXqouKgZnqb7EL1qmF8IwRl/mbLhi
	k6ib/SjZMEtmvABub/qlWYBe+/ppL6saHsJKQPhrGoJqF1COMa8k6snOfjm9sGkN07aeiBGMwWo
	7Z0SzFnw+jbSvXb1nCQFyXdrFWx88ZAuqP6cLaDKKxhC/HmK5/z3kHnEuQeuIDS+DYAM=
X-Received: by 2002:a05:6000:40db:b0:3b6:d0d:79c1 with SMTP id ffacd0b85a97d-3b79d4511a7mr2179887f8f.10.1753973681096;
        Thu, 31 Jul 2025 07:54:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGrPbQGx33zdyJHrEf2Jq33PS0AoKLgTX83/f0Zaxy9JX7aFfl5pg+H/UR1tcX8OOa7Lu1kA==
X-Received: by 2002:a05:6000:40db:b0:3b6:d0d:79c1 with SMTP id ffacd0b85a97d-3b79d4511a7mr2179833f8f.10.1753973680340;
        Thu, 31 Jul 2025 07:54:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953cfe56sm72071135e9.20.2025.07.31.07.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 07:54:39 -0700 (PDT)
Message-ID: <747509a6-8493-46c3-99d4-38b53a8a7504@redhat.com>
Date: Thu, 31 Jul 2025 16:54:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/huge_memory: treat MADV_COLLAPSE as an advise
 with PR_THP_DISABLE_EXCEPT_ADVISED
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-4-usamaarif642@gmail.com>
 <aca74036-f37f-4247-b3b8-112059f53659@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aca74036-f37f-4247-b3b8-112059f53659@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dS88GFI4hZjB66Ed3qT_VILblNUN0V0_ZW4oHBIWjm0_1753973681
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91DC5180007
X-Stat-Signature: xpbo14a83516baefuqb7s1nqh5337rqk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753973684-469808
X-HE-Meta: U2FsdGVkX19CpAdgsGx40nZbWgRG6ee2YwyyrgXrFUhnA3qPgOheeM5UoXYzZ2axlxHW999mAXZQ6vI3qarHXMCrwDeRsqdX36WRzq1xCA8YN7aMkNAo2SrnZMLBKsjiApexYQ2Yh700udtJXqD5EX3ZDc+7AIqTK1kzqEmK40qMDRF8ID6/mH7AUmLbUkhIB2wtA+HD4OJMeJjWvn8Ddxd2+I07kMX9yN5MFHThAzmLK/c9p1yMLOpOOvJWF/1K4GSolNkoTDw6eMpGY6KB9BfsoDetjw6c8/hCUP6XdG7HnA2d1YBoSzlIg3r9UeMNMP/ydTfrGad0sDtBHYkaMPoIfb5+J0J5Hh163Dv7kMGhC6bnUbSTymr3K42y2wWfhbsFHyD1EMGdU4VStgK+PrIH27xUl3EVHFvKiYBLIKhK7F7XnynaO9ckINfD0+5dTA4C1PfQl4NHCI9lC+iNV53qGGHOP58W5TkCWhe7Iv9BTZqbihQ2M8N6b98n5FUi4VUsY97GGvomMTCn6A/CxarnukmtKbLGZIMLUjMiIYRiCkjRUsk4AAPepWlyNGJ5ryu8C3VluT0vWZJ00/Qj3s4Dih7DowS3l8Q7v6bUDVyMzaTTyQCvUbSqgdVe+3MzpDWPD7HiAG+9PN/JN2Sl9Tkx87akl9/sNUmHqSNykhsMqyzvOYr3nZorgKbsOPLR3OzC8vmJKBApMebPNIrwUcJ/JI8JClSfp2//lgOCYGl6PQBMluGxnurN4Of9YDTAJILFdJqvyBld9xgaV4E7tuWxc8yp1aKf8de/PlpjvZcBrK3Pn1xTyX77E6+Dc0SpAZh/fbwy5ZN9VoLsjkNeyWvKrXJSKVaIoJuDEKzFbiYaIbL/zoK1WEk6ZziNidkDZPDa4b+aw2zlldjS1WgiPV0ncWNNSC1gTxJlUzwsrTbwQ0jgxHfQ/jGYuQHcrXDDnmFbCfA+tei9oWIMiw/
 b5QPpcPk
 IdZP0piAlsqR5HBmo6u/vPwY55nb0IBvAgfAUJIYYrRY1UMmaIwbNm8J9TfLYyxyVlV0t+UGLJag2Ye+Dd1P3JzfNdgPqcwG07jVufbAPLtOpAmI0aIlr6dWHHSQ5J96uHdOizdIrznMCcixlknqKEphjkc3HWdfcV0az4tZiWuIra0fcmVV25JTYVM8UNpyBGWZMQVv6phDGe4un6U4Hf1RznfT1gBGHHyKgwubzwY/9fXCcKVoZiwX+/TStBeHcg3/fikkSMfpNanoL3Woi2KmtGfM4h9T/2tp+zhzn5F2okl3C/CsaiG7mr9vCovv/rhL6Wa65qAwdVMhPR/p+epFyVdesuymfzNRG6Z+426L9cY+XgC2gKeg6vo4edwOdchdDnShe9hDQ3Vm6zhvowUAG3VHKrvGbouAVlXvLq59YCh0qrncCQvPH+nP6yr8g8p4Oc0+a53xVP0rbi3OZhJkAM6Ls5TvwzCx1wOzHX4TDxEuEjckhE7pc7PR5QcYfQZtvJXJbVpAj4vYXGDChezoMgkPBbBfVgTX5B0c618ump/9dIYxdg2cvlFjlh8cF1wa6PxHtW9LDdZh4saqiOfrKng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.07.25 16:38, Lorenzo Stoakes wrote:
> Nits on subject:
> 
> - It's >75 chars

No big deal. If we cna come up with something shorter, good.

> - advise is the verb, advice is the noun.

Yeah.

> 
> On Thu, Jul 31, 2025 at 01:27:20PM +0100, Usama Arif wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
>> Let's allow for making MADV_COLLAPSE succeed on areas that neither have
>> VM_HUGEPAGE nor VM_NOHUGEPAGE when we have THP disabled
>> unless explicitly advised (PR_THP_DISABLE_EXCEPT_ADVISED).
> 
> Hmm, I'm not sure about this.
> 
> So far this prctl() has been the only way to override MADV_COLLAPSE
> behaviour, but now we're allowing for this one case to not.

This is not an override really. prctl() disallowed MADV_COLLAPSE, but in 
the new mode we don't want that anymore.

 > > I suppose the precedent is that MADV_COLLAPSE overrides 'madvise' sysfs
> behaviour.
 > > I suppose what saves us here is 'advised' can be read to mean either
> MADV_HUGEPAGE or MADV_COLLAPSE.
 > > And yes, MADV_COLLAPSE is clearly the user requesting this behaviour.

Exactly.

> 
> I think the vagueness here is one that already existed, because one could
> perfectly one have expected MADV_COLLAPSE to obey sysfs and require
> MADV_HUGEPAGE to have been applied, but of course this is not the case.

Yes.

> 
> OK so fine.
> 
> BUT.
> 
> I think the MADV_COLLAPSE man page will need to be updated to mention this.
> 

Yes.

> And I REALLY think we should update the THP doc too to mention all these
> prctl() modes.
> 
> I'm not sure we cover that right now _at all_ and obviously we should
> describe the new flags.
> 
> Usama - can you add a patch to this series to do that?

Good point, let's document the interaction with prctl().

> 
>>
>> MADV_COLLAPSE is a clear advise that we want to collapse.
> 
> advise -> advice.
> 
>>
>> Note that we still respect the VM_NOHUGEPAGE flag, just like
>> MADV_COLLAPSE always does. So consequently, MADV_COLLAPSE is now only
>> refused on VM_NOHUGEPAGE with PR_THP_DISABLE_EXCEPT_ADVISED.
> 
> You also need to mention the shmem change you've made I think.

Yes.

 > >>
>> Co-developed-by: Usama Arif <usamaarif642@gmail.com>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   include/linux/huge_mm.h    | 8 +++++++-
>>   include/uapi/linux/prctl.h | 2 +-
>>   mm/huge_memory.c           | 5 +++--
>>   mm/memory.c                | 6 ++++--
>>   mm/shmem.c                 | 2 +-
>>   5 files changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index b0ff54eee81c..aeaf93f8ac2e 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -329,7 +329,7 @@ struct thpsize {
>>    * through madvise or prctl.
>>    */
>>   static inline bool vma_thp_disabled(struct vm_area_struct *vma,
>> -		vm_flags_t vm_flags)
>> +		vm_flags_t vm_flags, bool forced_collapse)
>>   {
>>   	/* Are THPs disabled for this VMA? */
>>   	if (vm_flags & VM_NOHUGEPAGE)
>> @@ -343,6 +343,12 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
>>   	 */
>>   	if (vm_flags & VM_HUGEPAGE)
>>   		return false;
>> +	/*
>> +	 * Forcing a collapse (e.g., madv_collapse), is a clear advise to
> 
> advise -> advice.
> 
>> +	 * use THPs.
>> +	 */
>> +	if (forced_collapse)
>> +		return false;
>>   	return test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, &vma->vm_mm->flags);
>>   }
>>
>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
>> index 9c1d6e49b8a9..ee4165738779 100644
>> --- a/include/uapi/linux/prctl.h
>> +++ b/include/uapi/linux/prctl.h
>> @@ -185,7 +185,7 @@ struct prctl_mm_map {
>>   #define PR_SET_THP_DISABLE	41
>>   /*
>>    * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
>> - * VM_HUGEPAGE).
>> + * VM_HUGEPAGE / MADV_COLLAPSE).
> 
> This is confusing you're mixing VMA flags with MADV ones... maybe just
> stick to madvise ones, or add extra context around VM_HUGEPAGE bit?

I don't see anything confusing here, really.

But if it helps you, we can do
	(e.g., MADV_HUGEPAGE / VM_HUGEPAGE, MADV_COLLAPSE).

(reason VM_HUGEPAGE is spelled out is that there might be code where we 
set VM_HUGEPAGE implicitly in the kernel)

> 
> Would need to be fixed up in a prior commit obviously.
> 
>>    */
>>   # define PR_THP_DISABLE_EXCEPT_ADVISED	(1 << 1)
>>   #define PR_GET_THP_DISABLE	42
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 85252b468f80..ef5ccb0ec5d5 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -104,7 +104,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>   {
>>   	const bool smaps = type == TVA_SMAPS;
>>   	const bool in_pf = type == TVA_PAGEFAULT;
>> -	const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
>> +	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
>> +	const bool enforce_sysfs = !forced_collapse;
> 
> Can we just get rid of this enforce_sysfs altogether in patch 2/5 and use
> forced_collapse?

Let's do that as a separate cleanup on top. I want least churn in that 
patch.

(had the same idea while writing that patch, but I have other things to 
focus on than cleaning up all this mess)

-- 
Cheers,

David / dhildenb


