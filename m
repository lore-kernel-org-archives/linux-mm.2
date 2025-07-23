Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87493C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 18:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092E76B00D8; Wed, 23 Jul 2025 14:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042746B00DA; Wed, 23 Jul 2025 14:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CDE6B00DD; Wed, 23 Jul 2025 14:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1B7A6B00D8
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:03:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C04D140187
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:03:02 +0000 (UTC)
X-FDA: 83696300604.10.16E5A9D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 053F5C000C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:02:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PI4uJKob;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753293780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3whOxkstbMxt2nhGLk1bQZXFsEZXlxQlt2XWZxhuog=;
	b=T+HSfcIAmY4xQdHeY7mx7y0Jvyc8N9ghmUWscN2c0RjzElVq4u9RDCWFOJYGdq9VOGXpEn
	Si7eDXlDKNMauUFxQ9Qd3IuYEayeahyysYJdZFL+Ff3l5uM1NWKGTjT8KrpoxNOCW/63hF
	l5ffZ21ehsj8v44c6OMQ5vWWNWlnzKU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PI4uJKob;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753293780; a=rsa-sha256;
	cv=none;
	b=sHIHmNWxogToP9NHSD7Pv43Pp1CM3H9wEFDFpZODIkUR4LusM3m4B8BziSoNHC8e72euuf
	vPXf5HhaD1xd9LJpeucJkt9cWs+vMpBzP436rzuTRTZgrcUEZqz9EzRRY+3gs/A0cANFub
	/aTEKKO/7yEa+/fLFAq8ITXh6SSvc58=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753293779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G3whOxkstbMxt2nhGLk1bQZXFsEZXlxQlt2XWZxhuog=;
	b=PI4uJKobDM8mGXiDPr+5RqREWz7fXvaXA1eYPH+DO+N5v2DEnjAsYOuS3AWiWS1L+SYpyc
	0PEa9cHFUgRazPkGw3mps+9TKHVflMWWpVBylQv5HX7ds1VDuXlHZXlRTxC2tFS+2DnuBw
	EyuXAtq+wmACbOtWqn5ggweecnCCUdg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-0G6qAx98PW2zTl2N8g2qKA-1; Wed, 23 Jul 2025 14:02:57 -0400
X-MC-Unique: 0G6qAx98PW2zTl2N8g2qKA-1
X-Mimecast-MFC-AGG-ID: 0G6qAx98PW2zTl2N8g2qKA_1753293776
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso820375e9.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:02:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753293776; x=1753898576;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G3whOxkstbMxt2nhGLk1bQZXFsEZXlxQlt2XWZxhuog=;
        b=uHto/ux7Vx7AoRqi17ntBq35ehv+cuOn5UO/41RSCsyGrjcnWG8C+DUuMyugbrRfRs
         Wv+5yiH943jomf64jcYRgBgN80FmmwsNF1OKrWLxBmhDNUZux5No5ckr1qltsrAJVEqU
         7GNOGrJeNPXADO8cuNn4Uq433nDLng0kZT5ftSNq9Wi6odzPjaPg8XCXMneadjC4ONcb
         CmB2qnT5Ljw7n+fMZdWz6kG1t727mP3vx6qsPVwg/T2Pt+JOKC9tl/DYZTDBtQ0Wvc0c
         d8+v6kuhY/W8i6eQctZbj+VRwGTrYMe9YNNHSswUjlar2rLG5+apLo8laxDJO09YjeuG
         ntWA==
X-Gm-Message-State: AOJu0Yz8z8dzfo44fBwQMdBAXDlT57hz2xhpKBdXY+B6ic9eiEsIOfwc
	VCpmWnWcXtTVkh21O/j+RLepQWAWl8Iu27Tw54Bgjqv2IvuO55O2Kg2wyPJomxwKEiwNwbPNZJT
	dj3ZMA1mKlTbsYi3mUzRRk0fR++Rmc+86CGTQylfxgkV7dfw8kxCt
X-Gm-Gg: ASbGnct+aVct1Yeus1hNCxF9NgyRsUWTLlkziUdUtfd0QUQ2le0ZeRuwQjLOzeL+qLq
	7BrszUQxwRuRzDZUong7h6RBbRtJtKHHV6urvnEEF2+gJWLBw5d+mrkL0ixNVeLDLO0ixci4Usv
	D58bhgQEvAM/Sl7YLoKRObcONqAtHWs08HOMj78FL/C5V5+qhul/muuRQOqffEq2Iz66vEiEuDp
	hK07uLg0JzNuCg3xJPeWIj/vCE4VqG/ec4vVParErNdTCXTQsiZhhk8wPLPs51tB+uHCOFimAeW
	F1NErgASndcG+Mir7YxoJKkx5RCtHM/XxgrPm5SRUA32JUXoaUsh3F7loILJgN2kvgVj2g==
X-Received: by 2002:a05:6000:2013:b0:3b6:936:976c with SMTP id ffacd0b85a97d-3b768ea011bmr3550368f8f.17.1753293775546;
        Wed, 23 Jul 2025 11:02:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEZg16J4+gnyGIzNr4yWSx/6st9lfF2anNLh6lxP/xRh+IjVjl07vljj/vUaQGCZ849yfF1A==
X-Received: by 2002:a05:6000:2013:b0:3b6:936:976c with SMTP id ffacd0b85a97d-3b768ea011bmr3550304f8f.17.1753293774863;
        Wed, 23 Jul 2025 11:02:54 -0700 (PDT)
Received: from [192.168.3.141] (p57a1af43.dip0.t-ipconnect.de. [87.161.175.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458691b2adesm29652445e9.32.2025.07.23.11.02.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 11:02:54 -0700 (PDT)
Message-ID: <383a957e-badb-49fc-9913-30bea3a1c5a8@redhat.com>
Date: Wed, 23 Jul 2025 20:02:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH POC] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: Usama Arif <usamaarif642@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, SeongJae Park <sj@kernel.org>,
 Jann Horn <jannh@google.com>, Yafang Shao <laoar.shao@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
References: <20250721090942.274650-1-david@redhat.com>
 <4a8b70b1-7ba0-4d60-a3a0-04ac896a672d@gmail.com>
 <5968efc3-50ac-465a-a51b-df91fc1a930a@redhat.com>
 <003c12a7-cb3b-4bbd-86ac-4caaddcabf26@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <003c12a7-cb3b-4bbd-86ac-4caaddcabf26@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p-p8RH_iPuG4yCwDm0JUuMRTWuaPTXoiUtrWtWrhi08_1753293776
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 053F5C000C
X-Rspamd-Server: rspam06
X-Stat-Signature: sfjp1hy93kgeeufoc6q9ktnqbzfcgo7h
X-HE-Tag: 1753293779-435177
X-HE-Meta: U2FsdGVkX18csz+WICTCo6QiEf21+fWYQiEUV6OvOLWNhBF5aYoSdlznNQ3vN75VSlf+5xWW5Ut8a7VpOqEeYF8VF/O9uKizpM0ywfMtTi+iXG+x1NT4II4AbgyCuVe/zy7nwbatUG/P+J8BVTDmcuv/t2O8qs8fVRd35q9tMaNuuozY0KVJ7gG3i6Z3wAS2iC8NVln1Oh5++5oeewr8kThcfcP8fSSqSqVJ0UT2g3HjueG+qhFE2dpRvJwbFYuzE4VOP6MkddvZFlANhuPRppacD7MGT2WSCes5wikIL9KLrPjH6Bibs6Y10M6wNwDPIvlNm63o3VsyBFRslaT8ZieqQVL8KApwOFnx3kPGPddUF0HCvco044IjLCDJchphAjfzJDWOpT0bZestNKR7exQFbII+36FUtCnhOXNESwPCEuLmO4rmJtUl7WVvhzFx84xVdse2mHXG2NstbneluUJ9G/Ihv98lay2ORsdH/WSoQvSnMddMWsp0UdiRONBf7uBug8/kdX507dQ3WD9U6NGw+I7KNSxHKb91npJm97lmnDT2Td5uBVfQjBXOLIoLlveMwviBSjLoLGSgvgg/+OA77BeXLLPxoXYzVxRMzm3RH9L9YQKICTd4QcLNu4sUoqJtVwGjmz16rieGP3HW/A22w5HN4+472BeopB+M4hTkM4o9XXYk6ZHwLNEle2qcj8H9CRSdQd6B8zPEuqtMSxNtdyfsYaNWJ0KHJVW026c7twECcm9EqhnIufCRtzxTkbBWewvvou7+Or39tBNX/Y+yQeKTLd50o+iHYXD+1Q8YfOSS0L2IttOndesGklclCtkXkRhvrt0hWPYBhIRmWqkQIa7Y+oNxTHSg+aMUmvhnPdm0cSIb2p2r9LPv1VuvvG1gFF2bZpK5nNNe81bliPWiQP108vn16L78qKObNeQ/EmJ3Ii4VvM4+BmYzMjFZqnMpS3BCX0d4jh+r0BJ
 EpPlwOwI
 wDKinBj7qcl28DUUgd1Fm29E1f928PjfbrXaUOrbHzAf4q+CcDTIoxDhkeDwDUez/PD6XR8DoA5YJISKPCLRfNrPACzJCzSVopUtgMuk2w0Qqs+V1VhyOIetR0+X+lw2XyQS3YGlpbd8Lb9PiMqty6tMrFn5qJhmziqZwJBQXfiBpK9Aoy6xFldtLGBkXYfp6FI72NbKaziKUs3JsjAIjF5M3cgDlO8rXZaDBc3zVnwH2oDHxjSZi5JRUxJ/Sa2H48TRPo0Zg93DplUbnqg/nxm/j7L0Z6MTHo8rcRQZMvfDgIOeat/yLHtOuMC9wu5rIUreM3U+Y4UF1V7JD3YbYyUWIhwC16ZPetOgK51C4tMdcUkpPtEHQDXxSYbR4HFy9NBVA0FxsptLBrJFllVOcUN+GY3pyKqMP19iTkNnycNZHOJG58RSUQVLno0hlSPDJHMA8/7TNfth64A8uAnsEuZ9d6fYCThoNXjOSoLoGpF1i8gcYmD92Qggdn9BZ5OD7AZdgchpHDvqvdO+d/+/kUdzBGM8xn4BHOmy+atoHiiM67EO02d5SVguN2d+Sv/1uBcTNryzZ5qhYXX3ra82J0InezpONUabfcFePiM4WAxbieT0Qrv+vn9Q+QdvaiLJR3g+lGgrog6N2YFI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 19:07, Usama Arif wrote:
>>> Thanks for the patch David!
>>>
>>> As discussed in the other thread, with the below diff
>>>
>>> diff --git a/kernel/sys.c b/kernel/sys.c
>>> index 2a34b2f70890..3912f5b6a02d 100644
>>> --- a/kernel/sys.c
>>> +++ b/kernel/sys.c
>>> @@ -2447,7 +2447,7 @@ static int prctl_set_thp_disable(unsigned long thp_disable, unsigned long flags,
>>>                   return -EINVAL;
>>>             /* Flags are only allowed when disabling. */
>>> -       if (!thp_disable || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
>>> +       if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
>>>                   return -EINVAL;
>>>           if (mmap_write_lock_killable(current->mm))
>>>                   return -EINTR;
>>>
>>>
>>> I tested with the below selftest, and it works. It hopefully covers
>>> majority of the cases including fork and re-enabling THPs.
>>> Let me know if it looks ok and please feel free to add this in the
>>> next revision you send.
>>>
>>>
>>> Once the above diff is included, please feel free to add
>>>
>>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>>> Tested-by: Usama Arif <usamaarif642@gmail.com>
>>
>> Thanks!
>>
>> The latest version lives at
>>
>>    https://github.com/davidhildenbrand/linux/tree/PR_SET_THP_DISABLE
>>
>> With all current review feedback addressed (primarily around description+comments) + that one fix.
>>
>>
> 
> Hi David,
> 
> Just wanted to check if the above branch is up to date?
> 

No, I forgot to push. Now pushed.

This is the diff (excluding description changes):

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c4127104d9bc3..527aa4c9645fd 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -324,8 +324,8 @@ struct thpsize {
          (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
  
  /*
- * Check whether THPs are explicitly disabled through madvise or prctl, or some
- * architectures may disable THP for some mappings, for example, s390 kvm.
+ * Check whether THPs are explicitly disabled for this VMA, for example,
+ * through madvise or prctl.
   */
  static inline bool vma_thp_disabled(struct vm_area_struct *vma,
                 vm_flags_t vm_flags)
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 1949bb9270d48..60e496ecabe04 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -179,8 +179,8 @@ struct prctl_mm_map {
  
  /*
   * Flags for PR_SET_THP_DISABLE are only applicable when disabling. Bit 0
- * is reserved, so PR_GET_THP_DISABLE can return 1 when no other flags were
- * specified for PR_SET_THP_DISABLE.
+ * is reserved, so PR_GET_THP_DISABLE can return "1 | flags", to effectively
+ * return "1" when no flags were specified for PR_SET_THP_DISABLE.
   */
  #define PR_SET_THP_DISABLE     41
  /* Don't disable THPs when explicitly advised (MADV_HUGEPAGE / VM_HUGEPAGE). */
diff --git a/kernel/sys.c b/kernel/sys.c
index 2a34b2f708900..b87d0acaab0be 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2438,7 +2438,7 @@ static int prctl_get_thp_disable(unsigned long arg2, unsigned long arg3,
         return 0;
  }
  
-static int prctl_set_thp_disable(unsigned long thp_disable, unsigned long flags,
+static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
                                  unsigned long arg4, unsigned long arg5)
  {
         unsigned long *mm_flags = &current->mm->flags;
@@ -2447,7 +2447,7 @@ static int prctl_set_thp_disable(unsigned long thp_disable, unsigned long flags,
                 return -EINVAL;
  
         /* Flags are only allowed when disabling. */
-       if (!thp_disable || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
+       if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
                 return -EINVAL;
         if (mmap_write_lock_killable(current->mm))
                 return -EINTR;


-- 
Cheers,

David / dhildenb


