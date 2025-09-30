Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F72CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 19:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964888E0005; Tue, 30 Sep 2025 15:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BE68E0002; Tue, 30 Sep 2025 15:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A3C8E0005; Tue, 30 Sep 2025 15:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71B788E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:19:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12DEE140814
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 19:19:15 +0000 (UTC)
X-FDA: 83946879870.10.F426162
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5DD8100002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 19:19:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jr8lEBB6;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759259952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9S15aSoS7gkBTjCjjR9TOKEu4LpldkUvJi552O85UYc=;
	b=bkSdQ8lRBgCSMCx7JACEcBZV6HV9jfhM9OWXqGN31srVZA40JgHOHpALKOtqQrFlrwbKvO
	mHyXy3BvS001Q1+olCBmSsP0jDZipbaDtDc0gViDh65VmL8og4MBRaY7KGs9vn+cv3uzpE
	p0QG9i8S+MRWu9uMMeAXK3DFe7KiHHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759259952; a=rsa-sha256;
	cv=none;
	b=dyJNiYPAj7Sv3AyxCVEtBZT+jVqrk0KtzJ8sAT7gLK6v2SRWMzY7Qrx6gphoxYc8qNEMnh
	xW0VS9VLnSDpvftTd0Lb8skB21vvU2r47oSrDExmrqRRasAa/LJR1m97pqV38rfMLGbBk4
	Ra6KMaKvhYJd7bTgyaCVRAtU7/Rc8xM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jr8lEBB6;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759259952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9S15aSoS7gkBTjCjjR9TOKEu4LpldkUvJi552O85UYc=;
	b=Jr8lEBB6SFBx201s//EhcV3K7F+4cvbfzQIppl+P/o7VK0iDFxAbViVWxyixXQpjCxDU8+
	0L2Y7klzQ14vaw0oryU37X2c99tNi7qbmNWThd6xCngmSgp/yawlj0c6TLGvcxxDIU47Qh
	Gjyj38nlTKh7QYqHPhHh/6tOL3Qqaj0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-a8kgW-9EOF2G8EevI6a9fQ-1; Tue, 30 Sep 2025 15:19:10 -0400
X-MC-Unique: a8kgW-9EOF2G8EevI6a9fQ-1
X-Mimecast-MFC-AGG-ID: a8kgW-9EOF2G8EevI6a9fQ_1759259949
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ece14b9231so4257996f8f.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759259949; x=1759864749;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9S15aSoS7gkBTjCjjR9TOKEu4LpldkUvJi552O85UYc=;
        b=wzPRJnowR70IBS2l7o3DNohr7uyDWRKS71A8E4VvXztgFx68vlMSUi+z/6BmPqPCJx
         mcBMsqbX2HHv3LGIHi5iYTqqQL5R4ErhGvwXqH28L3Yz3S/m22zoChy5aS5tIpXgnJTK
         7lJZG6RCrdH7p84Knp7rb4/V4cT0tmsldSMCmSF5F4kTa/pa5CkKoTYp97MRwXFRCR1f
         rTRMKeMugEuzYezfI5o6wU95fAeBRwiOQhFkDV/RtlWnvJYJGWptlGenDQelRyLSYwJj
         jZQBsNStskqmT05gSPOJRt3Jcd6ignwEBZTU9g2u9ZGunO1MTz1OpGsyLhr40KKO/LCh
         u5RA==
X-Gm-Message-State: AOJu0Yz9jsdD8MnmmzuYj/WtjOMEq3uaB7VTPzp8wyBorx5gdMuwbKIe
	0maC/wPDgbA7HEYcIuE4Reaef/JcFD0ucvYji9zOm4bwu2A4zsybJ7LDMtFxcdeuqHCOHDL10D7
	tEmpgqkwPRCqqNeMoSElL6/Amy4bG4z8ZGDNVU6UtwE86a0RcTBYq
X-Gm-Gg: ASbGncue89e297aPu1LvnXw2TdgIapRABYPcFAGjAxWVbkKlNcOZtkKHnCLCRNxSkcg
	fvHOQQMHGsb0jsOMVzgir25on9ePkIFDb5sNaFcePJjZ2Zkv3L56hLNXleyhtjReS0Nc2gGDaF/
	yb+zYS7R4MxC7sXycU+d2F+D9oBVHprYIDR29w9t8qx5ThlokTf2luiVtV4+U3d/2f+5k78dC1/
	Oc5aTOjmw0+ccFWqMwbj9grb+6NNnG0x+yc5/wf53DjHhCjCQ6vwG2gRJoxUJ/z3TG9s4OcxkYf
	2T1Ro7dTKBMhtK7AdCHfNE7e8BEF3dM4Loo7qEK7ab0EWvEHz+5f84yprQGoth68MiAgKCcdD4S
	ZDR4FHStI
X-Received: by 2002:a05:6000:26c9:b0:3e4:f194:2872 with SMTP id ffacd0b85a97d-42557824f3fmr600623f8f.31.1759259949402;
        Tue, 30 Sep 2025 12:19:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIexoXYU6ONRc806amryD6k14OdusrcewNSLQr7eqoen+PTzSqFwWHXHCoKf9b54de3MzLEA==
X-Received: by 2002:a05:6000:26c9:b0:3e4:f194:2872 with SMTP id ffacd0b85a97d-42557824f3fmr600595f8f.31.1759259948819;
        Tue, 30 Sep 2025 12:19:08 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc72b0aeesm24420207f8f.49.2025.09.30.12.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 12:19:08 -0700 (PDT)
Message-ID: <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
Date: Tue, 30 Sep 2025 21:19:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Axel Rasmussen <axelrasmussen@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 James Houghton <jthoughton@google.com>, Nikita Kalyazin
 <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
 Suren Baghdasaryan <surenb@google.com>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com> <aNwmE11LirPtEuGW@x1.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNwmE11LirPtEuGW@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Gtu5H69JUALdDiqWPBIUqPF2zq6mvEvrfC-bcOXZVn0_1759259949
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mkmziwrtxusehwo5esb6e393ubk17jth
X-Rspam-User: 
X-Rspamd-Queue-Id: A5DD8100002
X-Rspamd-Server: rspam10
X-HE-Tag: 1759259952-171909
X-HE-Meta: U2FsdGVkX1/h3wwP17KzAivM7mk/ZhmrS8dPndqhmBimrcLdwwOwYgS3OVM65EcyeYP5C5itUCuSxG2y5FSnfE29d7n1qT9xDpb3Db2ZTtj8QayUFITuxUYsILAZTO5NDoZcIbMrna5wOYRL1jYUVFGYJ/OA3qx6Df2KOjICwxJxyAbjwPpGCpGv6Qljjd2VorNW+NOSOGKV6HFa7km7W++IBizELRFTb2/sVszr2rZVEdIwtcK0NCfWDw11UuutW+K9mL+cdA0EAtdZm+oow1DxEBlnAo5/q9nrFBxbGn5Mzpn73nLyPYQSkvYkrExVMZP12VHtubbDGw0RvptOjaz/Co5y0a+xCE5GNoV/WKx6+pseO9+fyppyfBIGRotAYgBttR3lrmb9lSpdAC8NW59HsXU0yJ7tHl321etLTgGTuN7K05907syqGrhHYrLuO5AaC6D8kDa/pxQ+DYCAHgrdqCmATnfmmuoaG2LJp6ba0wv4M/V8/1EksQ42rRmVTNzaT8PZTyxZLk8P0U8H7lYenBqUm1RLSiIIrgpfpp7D1fvDhIMJ8wN6e5wie3pSFYIn2unPZip3oeVHWbkxeYJcFIeBW7ZCxCXf/y7llgXPa1Oh8VDC+9yeNZC+hOw4Z8b9dmW4J3T0loxDomT6hlPhu7r2lnBVqsGlWhlWHKNR5T+NIb+ilGJTtSu5jiq9g+83Q0TX/SGhXXH8ikN1RjVJb8GA+S7NmHJSGlmj6BUt2Y3HWY3z5j4Bm3QUgNOnpjtR3kqOfOnHO7XUCa1Lyn13EqrgAgi0aF2RnlUNYkumQDwDXHZImYrI6Pfd65XkOlC7MIUhYEXGpdqOFIzTQBBbflQxy99h7O0jLYXpOzmp3H3lgiwEgCjNnpZ0p0b/NMbIPuC/XzY0aF01YU2HokQsKKkLlrJdJQZxCHTq4kYOgULk95wth4rqZE5YnjYufcHqcgR2vo2uOYkWtow
 dqtebxpe
 +JcNCV7F8v0TTE/id0nWaHF8KOKMvQIn2qsmGGPQhhRpt1D1FIvCxQNxZwyIgxo27b7qHR62T7TPh3SEpi+PgEcKg/NkLe2GEhdNITHyuaOX6eiiKAB+QEsUHxjlhB/7kLEA9YXoUfV4wbWE4/44yUYbe/MYuDRm0noqyt4hfJtofaIDiY80WAa/FI2xLdkZqDb6XlGc84xAdIQUmhMn+ZMRFnbNqK7iQl6oK61QEEIffioOdqr9gy+MS+Qz/UnDHuB67/JL6KpcRUXMD2DgEV8ns5L1GzFIx2wWPxEq1E5zFOVBZ0OizGRKYwKe2RbrO5+vfoGI2ZP2uEHrO2dbZOtm7RIURgzZfNEpYj1b/qPAF5gSeDTkd8ba/0150gUfgE+owkG5RyKF61sQA7yFE6+8qyQVatVDbT+jFYpfBQjoZAFGDIi6lZIAIOJDtYmebTcG5YK926HyuoVvw15qMVKwN1TxXPXnVw7GUf7djbrzUTuyQMJoXl8VBbUloyLe3JN59
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.09.25 20:48, Peter Xu wrote:
> On Tue, Sep 30, 2025 at 11:36:53AM +0200, David Hildenbrand wrote:
>>> +/* VMA userfaultfd operations */
>>> +struct vm_uffd_ops {
>>> +	/**
>>> +	 * @uffd_features: features supported in bitmask.
>>> +	 *
>>> +	 * When the ops is defined, the driver must set non-zero features
>>> +	 * to be a subset (or all) of: VM_UFFD_MISSING|WP|MINOR.
>>> +	 *
>>> +	 * NOTE: VM_UFFD_MISSING is still only supported under mm/ so far.
>>> +	 */
>>> +	unsigned long uffd_features;
>>
>> This variable name is a bit confusing , because it's all about vma flags,
>> not uffd features. Just reading the variable, I would rather connect it to
>> things like UFFD_FEATURE_WP_UNPOPULATED.
>>
>> As currently used for VM flags, maybe you should call this
>>
>> 	unsigned long uffd_vm_flags;
>>
>> or sth like that.
> 
> Indeed it's slightly confusing.  However uffd_vm_flags is confusing in
> another way, where it seems to imply some flags similar to vm_flags that is
> prone to change.
> 
> How about uffd_vm_flags_supported / uffd_modes_supported?

The former would make things clearer when we are at least not talking 
about uffd features.

> 
>>
>> I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
>> are rather unsuited for this case here (e.g., different feature flags for
>> hugetlb support/shmem support etc).
>>
>> But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
>> the supported ioctls?
>>
>> _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
>> _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
>> _UFFDIO_CONTINUE -> VM_UFFD_MINOR
> 
> Yes we can deduce that, but it'll be unclear then when one stares at a
> bunch of ioctls and cannot easily digest the modes the memory type
> supports.  Here, the modes should be the most straightforward way to
> describe the capability of a memory type.

I rather dislike the current split approach between vm-flags and ioctls.

I briefly thought about abstracting it for internal purposes further and 
just have some internal backend ("memory type") flags.

UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON
> 
> If hugetlbfs supported ZEROPAGE, then we can deduce the ioctls the other
> way round, and we can drop the uffd_ioctls.  However we need the ioctls now
> for hugetlbfs to make everything generic.

POISON is not a VM_ flag, so that wouldn't work completely, right?

As a side note, hugetlbfs support for ZEROPAGE should be fairly easy: 
similar to shmem support, simply allocate a zeroed hugetlb folio.

> 
> Do you mind I still keep it as-is?

I would prefer if we find a way to not have this dependency between both 
feature/ioctl thingies. It just looks rather odd.

But let's hear if there are other opinions.

-- 
Cheers

David / dhildenb


