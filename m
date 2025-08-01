Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732B5C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 11:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6846B0092; Fri,  1 Aug 2025 07:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDA86B0093; Fri,  1 Aug 2025 07:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3F36B0095; Fri,  1 Aug 2025 07:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6ECE6B0092
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:26:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7291FBB03F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:26:09 +0000 (UTC)
X-FDA: 83727959658.23.63D0D57
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C0311C0003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:26:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fGGcPRne;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754047567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f31sjo4y6IU/9pLIItS9Wkop/JonBlPPFk2NLd9JXtg=;
	b=MFW21VqIXgaYMYXap+FQOOcBcsO93nSHzEcOovRChrpRQ1LyDjsi8BVvLVwJjpCtDiIqgk
	F8xEkIHS+8NIwH3HLcDZtHve3fwN5tA646EmVuFeq9O04uuCg4BImN13iUIXA5DmGpJvDu
	72ziJVW1LsZ8a9SpMg466Qt8uNXrdzw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754047567; a=rsa-sha256;
	cv=none;
	b=kGTsi1+aEtWS6mn1cTGcdSiaXxOWm7qpzbhPki9FoOWupZvpRYkniyGzxAVU341FW/Wg+7
	10FPyHM7LaoNbj5C2QCC8IEfrsUYcWRbL0rRS/orU4wSWFU/MbbI5Hs7fQkf0eT28Htrob
	eRaOmGpdi08JdyHLhJ7+n/H3hGhbo/0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fGGcPRne;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3b79bddd604so1131630f8f.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 04:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754047566; x=1754652366; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f31sjo4y6IU/9pLIItS9Wkop/JonBlPPFk2NLd9JXtg=;
        b=fGGcPRne9aaAupusaRUPMOZYdD0MVSZjqmIzH+AVa+LYS24B0Ph6WZVF795iA/4h+j
         TthkGtEpcuaGekUYYjRFK6krlMrq2D30uPqWRTEPpoH/IaevdB1lsdBNLzAbqBHZIsfi
         o4s9F/KDw6zSufgX8GpEmagw1DdzlmyLTmJIgcUE1mSSXg1W4uQzvVkqnBpJiMnd7X5f
         NqupWmS0F6san8k/UcrZoMmMo94fihqWkzWzw+/hSU5FL/QEqLQz5bDqmhQASK//33Sw
         LkzrQaXOEnhSn2hTQWstBgKoJi4jU3YDVu7iQzksuBgmtY8obxo9vFO8XwuuObk0SzOd
         j8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754047566; x=1754652366;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f31sjo4y6IU/9pLIItS9Wkop/JonBlPPFk2NLd9JXtg=;
        b=agbL0NeDqNzbJ5h1WT3eue2FEIC66ryCW7G5MnjZEEUpu4qIbTWaz4hHH7BhkCEWwT
         Yy0M0hzofJ+W/nobu2br2PFwzrdDv/7rE88ek7dn0N/zGCJED6zVx+PPkIfWK4unF7BT
         II8rbv1QnCszOIqMReQaueAO/90zzoAUuAyZ6pVzxlz/wsk4w29pk+GpSBBtYI+PcZWT
         5yPe2qDSfnqe5zww1DkUziOn0rCyitoMDikUpPeJBrx/wvEflPkTj+H7gYCsqg39dfsO
         gOUf2gyUMlT+5EyWkxiAYkX4/WM+seWYpA657FYIcm0JhJU686AD2sb9V3PPqcNUsAh4
         8jiw==
X-Forwarded-Encrypted: i=1; AJvYcCUc6OrB4zPZLemiMvWembx2Yld21ra0j+JxhgDsE9XlyCc2RX4CX0FURbgFE4v/EdUb5lxqIKv/1A==@kvack.org
X-Gm-Message-State: AOJu0Yz0AyUfZUsMvwaMGatgiNbkuUZpexgFXNvle3AVVe4y7qw82Vvr
	pG9fSyzt93rdR6AIDvfuLOcfPioAK6OvUtTM6KItO6Q7fnKgccUTt7pJ
X-Gm-Gg: ASbGncuhJPh1qNE3UT3g5PxbPj3AB6Cch63LOFRl1Qyqf5sm6zLXo+rh4ThYRMnw7HP
	Pd2iD/IzGh/l8pOUliN9laEVT5V2Jbjsiswhiqj2tJkpyebJZNPUpN4LHjACf8HRQVsnzV6DDW7
	yjSMjcDG+WBDnpATszEuMu1++cSfvSMOOHdKQf/AOMbQbnpNetd/ZK2FZljibY8qdBFu461pqnw
	kHDvZdbDeNlMydOB2Q//JkjQbeCpOMaV9XMjFHv3NPzYbzcQMmSKpFMmtZWO0k3nOuqofsiTAMf
	hqRo1Zplwbo8wlEXnEMbz71sX0h0rpTWKDTb+YfWO2awB32o90SCmdH8V4XNbfA8SlyZ6gsRJCe
	jeHwjIsGiJipXVh5v6bcFjll0H86yzG0VbZ00GdXDfBINat9CT3Hkqd1h3gHf3ovUNr4xgW5P2U
	NPaDlNRVcQIA==
X-Google-Smtp-Source: AGHT+IFjTKWLBkC1vBA6besRk7jxQ0cAB8sF1kKVfEqfQ3SbATKsd62PtflkSV1CPQXrUyg4yTYm1Q==
X-Received: by 2002:adf:a455:0:b0:3b7:9564:29be with SMTP id ffacd0b85a97d-3b795642a6fmr5837784f8f.49.1754047565577;
        Fri, 01 Aug 2025 04:26:05 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4? ([2a02:6b6f:e759:7e00:8b4:7c1f:c64:2a4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589536abb1sm108846655e9.4.2025.08.01.04.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 04:26:04 -0700 (PDT)
Message-ID: <3fc8b76c-825d-4aaa-98f4-ff64bb40497d@gmail.com>
Date: Fri, 1 Aug 2025 12:26:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/huge_memory: treat MADV_COLLAPSE as an advise
 with PR_THP_DISABLE_EXCEPT_ADVISED
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
 <747509a6-8493-46c3-99d4-38b53a8a7504@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <747509a6-8493-46c3-99d4-38b53a8a7504@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C0311C0003
X-Stat-Signature: k8hnp79qc5phm6dtjhabdftz6rz46m16
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754047567-185469
X-HE-Meta: U2FsdGVkX19MZ1AXknQnKwjZkVgZs8Z4kCDSYZf3I6btIcI8H8Dh6tHPjp61kZo3PK50tae3O8aiixFq3mScBre4GYkx9vyBq29eo5Je6gTvADgMBCFbLFM1QooK8Ay7GxdZZOe/eD40pfuFa/V7i1XKPSSH5f6jRJ2EAMn/wMKBTshXwujliq8bR9nTNhleqmno32E9nO2HFdn5hPU2h0NRw/CkC7ZRkA49i4sR9xeRsM3OF1BB5xBtVof98IKEK9VwAobxVnHidurQvg71m3tw6p1y8/N4nyr8670KQjy+FmiY8FVFVpgyYJk8QW6nyhRX9aROT30zHptqIx3kiR2+sFboWD22WHzYgvQ1qJg7vKCELlpqQd+LcEcuR65NDe+cHyyzvUrEJ7dL0STRDmClNdAJGOfdek+g0gkhG3jA0Ts7VqZ19SGM/EG4U4F82fN2FuDbQHFLngkLeUVU3Hn3kzVQKY2ZLkVn6b58Bx76szriFoKViSxrxX7wELJZ4q1rGvSg0FyzzMoO6RAhXAmPXudWtNYpY8LE5tWndApQMJCU1xGhK4OCFSEOl5Hq+DDNpAAHBjkAa3nAoI3hh74DiLfhjWiMpsCLn2BKM2HTNG3eSOpqRJhmY59xXxVe0jiECUz7JNjFRRp14y/XF6hm0jQqf/qNXOMMc5sajL2ktvN7rXioPGOJeKBx5SkrR0myFLwnXMVXL/jBbDxiADFmQGAeRQ3bd2CIkOVcYf5JE/UmB0XNBjnYHqDZbCjFHietZT3XHPr2mV9PLXj2eXu/ZM6jM0NFvumxUO3CZ5SUjYPwMvefpL6fZlp4IFX2FF1xaimx7yzbeOoUPsjeu05ELD/rLnN3BIxkkkXyrGaAGJ6RfYwQuZbdMoYhxE2EliGKmkVR8EjFv46Nu9CURi2w4h0BYPLNCa3sw03amC+nDBOH875evaH3R2JayY6tiEkY0aSoVH+Al3LamWm
 YQppLXv7
 yEU6OSfkovBhL8iEtKWySp6iTWeD5DtgfwN+onS9Hah+8hsVjqexXwBP/Xuqx+nxiKRE3q0DJfIkH9cXDlcdtbnXJaiEZIkIXkAtrq4V9MeK9L+cdN6TUZiVOpESVRZfUuNrS2wdlF3LTZ2pQEXd4wsN4evY1Ec1e2c6F1+ZC/Spn7Ynd/PkH3v+ZwHTL1rsCSoq0ObGd67UijCjZbR6MKATW5a/GexW/BUzIZdxC07Zrb1jpas19DxveJs2ioeX2hAixUAkawT2GLXAAJl5YPjTk1peSqfKat9zi898HvEDYwwlYYv2rDyA3zdgf7AId3adC7vDouMUj6DzyrBwzsNz4R+iGLMdl3VpohSN13hSdpu3h1xFMpcp5HKyJruz02H9QWFrKHbKRay7E9QWxBQ/Ps/WZq92ugtQ8Hu7mK8Xv72P4+tbZNfeGS0QK7VvtAMztf+8a0yoSs4rf3rPU2pf7OvF/MBNuM7UxseUSRkUTATRxs8qLmdUniWCMp0/h6SIJVvCYPOx2UxL67ygPUeyp57FY/Cv2NlZF/vwVZIG5czuHH6LqH4ltkdV1XbuuFIK/yUtmLfcDbkLh7chqko/R4qthyIBM+TTqtGeC9LxpwTYegb7ecYQh2Amv5CDmzcQl6vXr8QHyRZakcQ5LS8egRJ9fIZqyB+Me
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 31/07/2025 15:54, David Hildenbrand wrote:
> On 31.07.25 16:38, Lorenzo Stoakes wrote:
>> Nits on subject:
>>
>> - It's >75 chars
> 
> No big deal. If we cna come up with something shorter, good.

Changed it to "mm/huge_memory: respect MADV_COLLAPSE with PR_THP_DISABLE_EXCEPT_ADVISED"
for the next revision. That would be 73 chars :)

> 
>> - advise is the verb, advice is the noun.
> 
> Yeah.
> 
>>
>> On Thu, Jul 31, 2025 at 01:27:20PM +0100, Usama Arif wrote:
>>> From: David Hildenbrand <david@redhat.com>
>>>
>>> Let's allow for making MADV_COLLAPSE succeed on areas that neither have
>>> VM_HUGEPAGE nor VM_NOHUGEPAGE when we have THP disabled
>>> unless explicitly advised (PR_THP_DISABLE_EXCEPT_ADVISED).
>>
>> Hmm, I'm not sure about this.
>>
>> So far this prctl() has been the only way to override MADV_COLLAPSE
>> behaviour, but now we're allowing for this one case to not.
> 
> This is not an override really. prctl() disallowed MADV_COLLAPSE, but in the new mode we don't want that anymore.
> 
>> > I suppose the precedent is that MADV_COLLAPSE overrides 'madvise' sysfs
>> behaviour.
>> > I suppose what saves us here is 'advised' can be read to mean either
>> MADV_HUGEPAGE or MADV_COLLAPSE.
>> > And yes, MADV_COLLAPSE is clearly the user requesting this behaviour.
> 
> Exactly.
> 
>>
>> I think the vagueness here is one that already existed, because one could
>> perfectly one have expected MADV_COLLAPSE to obey sysfs and require
>> MADV_HUGEPAGE to have been applied, but of course this is not the case.
> 
> Yes.
> 
>>
>> OK so fine.
>>
>> BUT.
>>
>> I think the MADV_COLLAPSE man page will need to be updated to mention this.
>>
> 
> Yes.
> 

Thanks, yes will do and send this along with changes to prctl man page after this
makes into mm-stable.

>> And I REALLY think we should update the THP doc too to mention all these
>> prctl() modes.
>>
>> I'm not sure we cover that right now _at all_ and obviously we should
>> describe the new flags.
>>
>> Usama - can you add a patch to this series to do that?
> 
> Good point, let's document the interaction with prctl().
> 

I have added the following patch for the next revision. I know that a lot
of this will be in the man page as well, but I have gone the way of being very
very explicit of what are all the possible calls that can be made (hopefully thats
the right approach :))


commit 5f290d29741a514d0861d0f99c8b860ba6af9c37
Author: Usama Arif <usamaarif642@gmail.com>
Date:   Fri Aug 1 12:05:49 2025 +0100

    docs: transhuge: document process level THP controls
    
    This includes the PR_SET_THP_DISABLE/PR_GET_THP_DISABLE pair of
    prctl calls as well the newly introduced PR_THP_DISABLE_EXCEPT_ADVISED
    flag for the PR_SET_THP_DISABLE prctl call.
    
    Signed-off-by: Usama Arif <usamaarif642@gmail.com>

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 370fba113460..cce0a99beac8 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -225,6 +225,45 @@ to "always" or "madvise"), and it'll be automatically shutdown when
 PMD-sized THP is disabled (when both the per-size anon control and the
 top-level control are "never")
 
+process THP controls
+--------------------
+
+A process can control its own THP behaviour using the ``PR_SET_THP_DISABLE``
+and ``PR_GET_THP_DISABLE`` pair of prctl(2) calls. These calls support the
+following arguments::
+
+       prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0):
+               This will set the MMF_DISABLE_THP_COMPLETELY mm flag which will
+               result in no THPs being faulted in or collapsed, irrespective
+               of global THP controls. This flag and hence the behaviour is
+               inherited across fork(2) and execve(2).
+
+       prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, 0, 0):
+               This will set the MMF_DISABLE_THP_EXCEPT_ADVISED mm flag which
+               will result in THPs being faulted in or collapsed only for
+               the following cases:
+               - Global THP controls are set to "always" or "madvise" and
+                 the process has madvised the region with either MADV_HUGEPAGE
+                 or MADV_COLLAPSE.
+               - Global THP controls is set to "never" and the process has
+                 madvised the region with MADV_COLLAPSE.
+               This flag and hence the behaviour is inherited across fork(2)
+               and execve(2).
+
+       prctl(PR_SET_THP_DISABLE, 0, 0, 0, 0):
+               This will clear the MMF_DISABLE_THP_COMPLETELY and
+               MMF_DISABLE_THP_EXCEPT_ADVISED mm flags. The process will
+               behave according to the global THP controls. This behaviour
+               will be inherited across fork(2) and execve(2).
+
+       prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0):
+               This will return the THP disable mm flag status of the process
+               that was set by prctl(PR_SET_THP_DISABLE, ...).
+               i.e.
+               - 1 if MMF_DISABLE_THP_COMPLETELY flag is set
+               - 3 if MMF_DISABLE_THP_EXCEPT_ADVISED flag is set
+               - 0 otherwise.
+
 Khugepaged controls
 -------------------


>>
>>>
>>> MADV_COLLAPSE is a clear advise that we want to collapse.
>>
>> advise -> advice.
>>
>>>
>>> Note that we still respect the VM_NOHUGEPAGE flag, just like
>>> MADV_COLLAPSE always does. So consequently, MADV_COLLAPSE is now only
>>> refused on VM_NOHUGEPAGE with PR_THP_DISABLE_EXCEPT_ADVISED.
>>
>> You also need to mention the shmem change you've made I think.
> 
> Yes.
> 
>> >>
>>> Co-developed-by: Usama Arif <usamaarif642@gmail.com>
>>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>   include/linux/huge_mm.h    | 8 +++++++-
>>>   include/uapi/linux/prctl.h | 2 +-
>>>   mm/huge_memory.c           | 5 +++--
>>>   mm/memory.c                | 6 ++++--
>>>   mm/shmem.c                 | 2 +-
>>>   5 files changed, 16 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>> index b0ff54eee81c..aeaf93f8ac2e 100644
>>> --- a/include/linux/huge_mm.h
>>> +++ b/include/linux/huge_mm.h
>>> @@ -329,7 +329,7 @@ struct thpsize {
>>>    * through madvise or prctl.
>>>    */
>>>   static inline bool vma_thp_disabled(struct vm_area_struct *vma,
>>> -        vm_flags_t vm_flags)
>>> +        vm_flags_t vm_flags, bool forced_collapse)
>>>   {
>>>       /* Are THPs disabled for this VMA? */
>>>       if (vm_flags & VM_NOHUGEPAGE)
>>> @@ -343,6 +343,12 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
>>>        */
>>>       if (vm_flags & VM_HUGEPAGE)
>>>           return false;
>>> +    /*
>>> +     * Forcing a collapse (e.g., madv_collapse), is a clear advise to
>>
>> advise -> advice.
>>
>>> +     * use THPs.
>>> +     */
>>> +    if (forced_collapse)
>>> +        return false;
>>>       return test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, &vma->vm_mm->flags);
>>>   }
>>>
>>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
>>> index 9c1d6e49b8a9..ee4165738779 100644
>>> --- a/include/uapi/linux/prctl.h
>>> +++ b/include/uapi/linux/prctl.h
>>> @@ -185,7 +185,7 @@ struct prctl_mm_map {
>>>   #define PR_SET_THP_DISABLE    41
>>>   /*
>>>    * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
>>> - * VM_HUGEPAGE).
>>> + * VM_HUGEPAGE / MADV_COLLAPSE).
>>
>> This is confusing you're mixing VMA flags with MADV ones... maybe just
>> stick to madvise ones, or add extra context around VM_HUGEPAGE bit?
> 
> I don't see anything confusing here, really.
> 
> But if it helps you, we can do
>     (e.g., MADV_HUGEPAGE / VM_HUGEPAGE, MADV_COLLAPSE).
> 
> (reason VM_HUGEPAGE is spelled out is that there might be code where we set VM_HUGEPAGE implicitly in the kernel)
> 
>>
>> Would need to be fixed up in a prior commit obviously.
>>
>>>    */
>>>   # define PR_THP_DISABLE_EXCEPT_ADVISED    (1 << 1)
>>>   #define PR_GET_THP_DISABLE    42
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 85252b468f80..ef5ccb0ec5d5 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -104,7 +104,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>>   {
>>>       const bool smaps = type == TVA_SMAPS;
>>>       const bool in_pf = type == TVA_PAGEFAULT;
>>> -    const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
>>> +    const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
>>> +    const bool enforce_sysfs = !forced_collapse;
>>
>> Can we just get rid of this enforce_sysfs altogether in patch 2/5 and use
>> forced_collapse?
> 
> Let's do that as a separate cleanup on top. I want least churn in that patch.
> 
> (had the same idea while writing that patch, but I have other things to focus on than cleaning up all this mess)
> 

I am happy to send this cleanup once this series makes it to mm-new and a new revision is not expected.

Thanks!
Usama

