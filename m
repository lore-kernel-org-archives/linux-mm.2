Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB3DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 13:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D60B6B007B; Fri, 25 Jul 2025 09:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ADE06B0089; Fri, 25 Jul 2025 09:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776AF6B008A; Fri, 25 Jul 2025 09:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 699C06B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:08:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E46AD1A0742
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:08:32 +0000 (UTC)
X-FDA: 83702816064.18.243879A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 78F63A000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:08:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YFMeJIY7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753448910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXVoKfgt+eDdtfLoo5jK4LHubyq9Q2bBiLasDQpfjKc=;
	b=xBBYFYvxXup+MQeTuLR3CuH1Fp15IIRxP5tj3dNhlzIBANx26Lgw9Slj9DZflOtT07WDOn
	7txyNF/I5JObG7OrIF3hJNlLgwUZ5HT1XqZjxR7kZSlaceJzPvf0eagWNOLQBTANrH+mki
	UyhSqx/L45ySx+gUkJDWM4FvQ6UedIo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753448910; a=rsa-sha256;
	cv=none;
	b=u3tGan3XfO0tIhg8XU57yF9UJPy9C3cmHNv5Gbb77b5Pq9wIn7chEsa3fsF7fRZeMwIvLe
	dXfqQJoQ8nawKGQvxCQcCOrmnbBg1RSOAp6zRoquyyprz63WZaheFsTuBk/WFa9bcBmMB8
	jJLpbxt0sdH3MJX9Fzv4xb9LBAj8wXk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YFMeJIY7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753448909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vXVoKfgt+eDdtfLoo5jK4LHubyq9Q2bBiLasDQpfjKc=;
	b=YFMeJIY7jgqKSEFIsnEGPjmoH5hGkda+jIYWU2c9IgQv2n2cOuPqAa7hWfjLkWOPiPudG7
	6vk3vHkaUqg2mYGIim9vOO+GQ7bhYFE1us9vDdTuqSi18nqHfPI0ndVI9vNW5KX2zHJCWD
	EtvyYbtZbMNH4IB8HOUbLzLSIFcEZCA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-iWoVam2aOr2BT8f7M0iCOw-1; Fri, 25 Jul 2025 09:08:28 -0400
X-MC-Unique: iWoVam2aOr2BT8f7M0iCOw-1
X-Mimecast-MFC-AGG-ID: iWoVam2aOr2BT8f7M0iCOw_1753448907
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45597cc95d5so10138865e9.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:08:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753448907; x=1754053707;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vXVoKfgt+eDdtfLoo5jK4LHubyq9Q2bBiLasDQpfjKc=;
        b=cskPI5JPq5Ovx+MO9//SDOgSzbQMuHm5v5sXs3Fq6M08iInV8VQPekPSmBs0ZgnIHK
         5ZRTfEZg9X1dmRXJYyb6e9E91aGaOhD1Q2u2HCK12Z3LchR4pwiD3DJvKVgBsngVNKD3
         yHhGnstjEwRdiY1/2ZDZdikH/SQGs87cN9RXXo5ehtwwFgytRVZGn3IrwsTDxG3COZiO
         4HtmeitYH53H08nwzlLBafvKinWb/n/+GYZfN8xrHKri9mzooVs7sUSi7Hhqxij6zzcs
         S/sRubiAfYcp9fS1BKC3NxJQGRQG9EeUBNNWyBcODf0JUvbWzbwXMplopQ73FNnnXpUm
         UFaQ==
X-Gm-Message-State: AOJu0YxuZ0kvXx4T77c5GcK6FpfZkPmtRismSsCtWHdG/5cVdMQURc31
	xE+mx1Nfq8BW+h2NE4aHAbpicrUY7bc3R7yuMWDTly8Z5hQyhpVj1kWikrOuHH8276e9gw6f0pg
	JzkNw9wvDH6ON7yA38qhxv3t3kvOTjz7i0MOrMB99hQCZHxHGv8lY
X-Gm-Gg: ASbGncsQkrwbpetMYwsxif/mgKH8gE1s94ESWAJDtHlgPVTdmVGdVB+Su7PPn2kdSkd
	gM8dnWtL2hpiKdeUHWobpGA1H39Yk8151Ctz9Qy4j9KJxU2bB8U4EvpDr1H8VNhPWhgIVFcJ0aE
	OcXSxXSpn3m/Ppqnp670h9YO9ET6gMzVukvHSHnyFgHiyBSOvEeVpj5NF513khEBQHu+N5biae7
	vcUuqVhvZ+fxg3uSuONJBoYNffK4uQ7qeZF7N+wwKgndr7CVFEUvTfo69viGwxmnCLoPVKbwQOa
	ztu/gt6ssHSlPFVgO+Oa8ZqLIgCXiL+wTSuuOvzd8OGIcHKBRPo8oPWCe4KdtliWBlFY7FVfDie
	PLbpuAyPrnQMrwYnMzyW7OjUzEXCZZeWwqTwIyZdtnXrrz0+bDhG3zXRdm80GO9Vn
X-Received: by 2002:a05:600c:a08e:b0:456:1a87:a6cb with SMTP id 5b1f17b1804b1-458787dc1fcmr10178335e9.19.1753448907053;
        Fri, 25 Jul 2025 06:08:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2RXrdRvbIxRYGYQLphu0lW6ksSFFRRKo/9yzkhDSnD9/0KgQ1xqI1uMWWpky4n4Gl2pL7ag==
X-Received: by 2002:a05:600c:a08e:b0:456:1a87:a6cb with SMTP id 5b1f17b1804b1-458787dc1fcmr10177755e9.19.1753448906522;
        Fri, 25 Jul 2025 06:08:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:ae00:cf93:b0dc:6bed:abc? (p200300d82f34ae00cf93b0dc6bed0abc.dip0.t-ipconnect.de. [2003:d8:2f34:ae00:cf93:b0dc:6bed:abc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870532a4csm53826245e9.7.2025.07.25.06.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 06:08:25 -0700 (PDT)
Message-ID: <0905a63e-420e-484f-a98b-19e85fc851fa@redhat.com>
Date: Fri, 25 Jul 2025 15:08:24 +0200
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
 Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>
References: <20250721090942.274650-1-david@redhat.com>
 <3ec01250-0ff3-4d04-9009-7b85b6058e41@gmail.com>
 <601e015b-1f61-45e8-9db8-4e0d2bc1505e@redhat.com>
 <99e25828-641b-490b-baab-35df860760b4@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <99e25828-641b-490b-baab-35df860760b4@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mQZ8NvIe4CizRagSvd-uRuFezJTaMwROv6_mLuWJ3zg_1753448907
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 78F63A000C
X-Stat-Signature: xeupo5ntmqoe7i3xs36f5otzihbcte9w
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753448910-725904
X-HE-Meta: U2FsdGVkX1/9ukWCjBNCJQi51kXc8uDy87z8wnYJ0FGEDVtG6277vaqyEM3wfb2KfbBlJz8zYPD5tV9Xqe3A0bIFbk+2fVI139fSu+AdIhVnpYCVjmdHzBRVYjZQMX4EWCl+swZYhB/Ve2cLchvWQn3QNvti2sI5UdNzKi+8ONobgLDOziYKlotoI/P28ndh3s27aqNzA/zt7xkngycNVAGmdGERT1o1IXTrbEcqrAY+1RQSJpnyTKzt7ZAswWi6dv6IQ2MXL7uj1CfBy7jRjcGzelOrzEDPQHQGmwW6tVu0nCbU3l3lk+sxN4uyeQeiX7NIssqhRLmfzqO7jk41xsgk2btes1cQ0LByB13Xave+oU3CHdTWA5RPQufgIpmKX1crhmiW/n4k0vcCR4oYMO5+2LCWUtNLEEBhI/8Eg3RwXfDLC3XTRa1eaxg3/VOQ0tmmwLkoerdnzL8V97EmRpgIWcPvoLJ7ZYfvCItkSmu5z39WYL3ARrrimvbTZL5yooyUqjOU6lTLtZDKeYmJNLTeVpQdqEN7A3bEzRjT9zoYw8A7H0B1Ului3PDAhPok8E30KY2cnh4BTzpnVD4QgNj+ChdGqKf/91LsWiQCOhtKyjI8kLujSFYZklHwyFe7Y/1/+8l5lxUzgTuREbIOI2p/dVTXgv0vrE7ronkRT5e4V6tUPLi1683N2nOFtr9+XFREPXzsNuyT01k/VVaVE9og4LfVCAXBsuuf5ie4PtomRJskpMaLC97WDjEMlSFWm1J1JNgGpNPfx3zuzn66Qv4juhONyZc5z9pR7VxTOWJVcSTRRfAuiq39H121shCjQuy3bvRsUrJQ7CB5yqKh6MhH4nE9el3KbmVLQiSYeFJ+Mf6BaAj4eCqCm0A2zPi+myfB6uLTbhrR0hePQHYItPUdPpEGZFJUaqR/EDJmM70aa5LM+rxI2Q/qU+cPOH4qt+VmO4hQRtUvv0RnGqb
 f6K+PThM
 15AnYAKkudhXL+kA8AcCXBpaGAkql4QhNi5n29kMQ6z3GTnEgmqXBSO2f0QRcFLTOPVA6Al5vb8BNIAgPOVK5T4cpQaWqRqazgtLh9VRKWZLczzry7QDUxIsiemTZyxuGY8YI81lyCRuKdTRfRpjUfzQ0eXIGvwQIeFvpPSBtfRZWuCayWGYSWfqs+AxARtGE2JsHamperDk8aShlrhMfAUoD5epIBW0k/4TDkB+oTGRQScMFOPW55Fn81PZP7nROMcD6AXl32BXaMg1Es5iuiqg32vEbBbcKb8pcMCCfQqVBNQsj4IImD3+/81ppGgJjEdMNrkw5pYL1qA/SNdK1AeIM0zi7Fk1fvbBYJ/LuvEUn7RCQnSwvoryfC0VlqzdXCJABpOF8lSa1TzEHW9AauI9kBfEYW1zwHwo/VT5tttF8D8eiJ3FzSCEUsNwCJCV1T8ML+kRHdV3nIwPyGhjsXMOEY3yU3Xsax2naC8QLcoQx0JWng4Csgt8Yu9Ol0Oi4hdz4wakKJKxlSzejl4kS47BBgh/YozySxWYXO8rdn4ZccjhHf7BZp/8SdIwd12/FDN3h+/iVKhclBk0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 00:27, Usama Arif wrote:
> 
>> Hi!
>>
>>>
>>> Over here, with MMF_DISABLE_THP_EXCEPT_ADVISED, MADV_HUGEPAGE will succeed as vm_flags has
>>> VM_HUGEPAGE set, but MADV_COLLAPSE will fail to give a hugepage (as VM_HUGEPAGE is not set
>>> and MMF_DISABLE_THP_EXCEPT_ADVISED is set) which I feel might not be the right behaviour
>>> as MADV_COLLAPSE is "advise" and the prctl flag is PR_THP_DISABLE_EXCEPT_ADVISED?
>>
>> THPs are disabled for these regions, so it's at least consistent with the "disable all", but ...
>>
>>>
>>> This will be checked in multiple places in madvise_collapse: thp_vma_allowable_order,
>>> hugepage_vma_revalidate which calls thp_vma_allowable_order and hpage_collapse_scan_pmd
>>> which also ends up calling hugepage_vma_revalidate.
>>>> A hacky way would be to save and overwrite vma->vm_flags with VM_HUGEPAGE at the start of madvise_collapse
>>> if VM_NOHUGEPAGE is not set, and reset vma->vm_flags to its original value at the end of madvise_collapse
>>> (Not something I am recommending, just throwing it out there).
>>
>> Gah.
>>
>>>
>>> Another possibility is to pass the fact that you are in madvise_collapse to these functions
>>> as an argument, this might look ugly, although maybe not as ugly as hugepage_vma_revalidate
>>> already has collapse control arg, so just need to take care of thp_vma_allowable_orders.
>>
>> Likely this.
>>
>>>
>>> Any preference or better suggestions?
>>
>> What you are asking for is not MMF_DISABLE_THP_EXCEPT_ADVISED as I planned it, but MMF_DISABLE_THP_EXCEPT_ADVISED_OR_MADV_COLLAPSE.
>>
>> Now, one could consider MADV_COLLAPSE an "advise". (I am not opposed to that change)
>>
> 
> lol yeah I always think of MADV_COLLAPSE as an extreme version of MADV_HUGE (more of a demand
> than an advice :)), eventhough its not persistant.
> Which is why I think might be unexpected if MADV_HUGE gives hugepages but MADV_COLLAPSE doesn't
> (But could just be my opinion).
> 
>> Indeed, the right way might be telling vma_thp_disabled() whether we are in collapse.
>>
>> Can you try implementing that on top of my patch to see how it looks?
>>
> 
> My reasoning is that a process that is running with system policy always but with
> PR_THP_DISABLE_EXCEPT_ADVISED gets THPs in exactly the same behaviour as a process that is running
> with system policy madvise. This will help us achieve (3) that you mentioned in the
> commit message:
> (3) Switch from THP=madvise to THP=always, but keep the old behavior
>       (THP only when advised) for selected workloads.
> 
> 
> I have written quite a few selftests now for prctl SET_THP_DISABLE, both with and without
> PR_THP_DISABLE_EXCEPT_ADVISED set incorporating your feedback on it. I have all of them passing
> with the below diff. The diff is slightly ugly, but very simple and hopefully acceptable. If it
> looks good, I can send a series with everything. Probably make the below diff as a separate patch
> on top of this patch as its mostly adding an extra arg to functions and would keep the review easier?

Yes, we should do it as a separate patch, makes our life easier, because 
that requires more work.

We require a cleanup first, the boolean parameter for 
__thp_vma_allowable_orders() is no good.

I just pushed something untested to my branch (slightly adjusted patch#1 
+ 2 more patches), can you have a look at that? (untested ... :) )

-- 
Cheers,

David / dhildenb


