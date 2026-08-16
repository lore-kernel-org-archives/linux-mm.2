Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15DC0C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 23:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF44E6B08C2; Sun, 16 Aug 2026 19:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57266B08C3; Sun, 16 Aug 2026 19:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF81E6B08C4; Sun, 16 Aug 2026 19:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71AE76B08C2
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 19:13:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED0521605FF
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:13:22 +0000 (UTC)
X-FDA: 85108685844.28.A518A21
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 00F781A0005
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:13:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vC1+J7e6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786922001;
	b=AEbJuYFrensNci0DtJDsBYlcuwYSNbEpDp8ESqCcTfhWYoBAF6pZkGAMzsT7SrQHCaVkqQ
	ppGfSdtxdS3YsqcMi/ltKmP+gty926Y4JjybqQ8UwoaGHRuotMICXlnZ06msPoAo9gCq05
	JhnLDusgyYojxmxWhebUKDSNjRh0PHY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vC1+J7e6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786922001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12JghCh0XcebURQOPBtQP8z7apq3lmuNj5BeBckCdP0=;
	b=NZrB/ZasGbRIGNjMzMwkOF8m6TlNVt9jo67lTk2VyVrrqQPbOYpw6bsewsi2s7JUkaB+D/
	qyyRit0upOQy/xZtQ66OsjMncrVMzlmYgzuN/7pP04Lm+fyucjwZBZCWKvaDUW4LqyILfg
	0Qo/IseoCKuabaTVtcs7bLQxBa70wcg=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso3407781a91.2
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 16:13:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786922000; cv=none;
        d=google.com; s=arc-20260327;
        b=XRUe1dse35YrG4FQrLozhH+LN9Jmshtrb05Bc9Ya1GVNfE8DHTXbYOj073JIO2qZTu
         Oo6hO+ewvAbpvqtp4tW0GOAiOiB7obwVZwtCYci6m997CuZ6jNIA4maslpHPhSqJFhqD
         EA3kbymjD1HC0T5MA2D1N6oKFGwXIDqcXQBLaAwHJMsL0UdYLbCLwzxioQbzQNTNS3UQ
         bLidyGINszK59msMD+y/36bSjpUHOEB38NMX1rnlSSq2tApnwoE925J2VjBGfq/Njxyy
         xM0AM9rp544hAg4cDGdg5HwpZYXqcg4Gp/wJSNczXygyu8jZSjOe8SL8avJ/+ntqScHP
         Io+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=12JghCh0XcebURQOPBtQP8z7apq3lmuNj5BeBckCdP0=;
        fh=OoKd8ZM/n/jvIuddvqTPzn+VldnndGmFcjiEQd5RySQ=;
        b=HVK37KiOPKy6XjclkEL5kyhk6bTcbXDmGsVYeU2aN1sFcKf8pEwCoU7QkC/OMRkll1
         LKFonxMuVKvCtGhfi5hrXGtYtdlFxUMIBWQC0+Xr+TdrGvbtVuZaDLfN2/qfGSEJQ/QX
         tB/lBd9KIhiLal7+ZNMXT898ZnEgaBbSNORJxFWw1YeyqTJqaBzbRP+2uO54uejaZg+T
         ZOmyxL+ceEpc0KiYlEgCHaWzRozSnJUarXEO3szsl4wPCSVqbchejuQ75MamQS2HEZXC
         PCFsmCLLPH2+i9R4ckw4dLGntN3hBXree3OHyo5APfeq7RCMUAeaPV6mNua8hDgEd/AG
         G8YQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786922000; x=1787526800; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=12JghCh0XcebURQOPBtQP8z7apq3lmuNj5BeBckCdP0=;
        b=vC1+J7e63ByQenMdBsIYh4lo3FytgoLQXE47MqwkXdeH0IqBVr5c1PlD3E+T5LasAQ
         mRUWxdlPBOO/n7tsa9El84JXBkB407JBGKiVS49YhJku5NHDcxpYiTJr1XHxO2GcV9wS
         IgrshkZC0Cp5tozRSV2QKX3vbLcgohkVyf9W4wUanP0uDIe6vqKvrIh9W//S++1IGWsp
         H1wytdrMxVRg37Fyvr00QoYB2h17g7kJRI3vMdU58tO+1SSY18pLzrCDNXJL2wanC77j
         IIoRmfya9EO2KF6btChJJjmtjUWRFyTlSNUr5ZKujQc5wKN1ZFPLdEac9D2LxQ5oO53I
         wVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786922000; x=1787526800;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=12JghCh0XcebURQOPBtQP8z7apq3lmuNj5BeBckCdP0=;
        b=Q4KbWlLuYifoHEjlHPtbuCbJA2ZPaJp3XQn37xx64vcl1E3bySwqdgYq9B5ON8JPZM
         pu7Yoi29lnwHJ9L7OlnmS4fcMOdsLCKA2vTiQblD+TMaee7Q9QjYFdV/e8K/OJ+cQFJI
         GJXVyWx/44yVU4ZtgiDcY9KzWWwr8QIlF2RwBE0dKW6OEQllIajf6Q5IOt+c9uRJSqOB
         vW/tKXG1Vg0HEXFt1NFrt6cOYYPjmvJe5Paedhl93XTvaaf5D7UHznXcOfSZttgw6Rem
         8LVUease4l83/C+ICknl4fjV/r+lRI/0IUyofjRFT9+7SwS49fv7DqDO7I230w1rSDXe
         PnuA==
X-Forwarded-Encrypted: i=1; AHgh+RoB8Q2uoF6aubHN/2u2cbeni4wEKO5oXzx1q94D4AMEbGckxfIC1bzrAxx5JYSFaUNyKqOvcSEUtQ==@kvack.org
X-Gm-Message-State: AOJu0YxMC/9nOZfu+7M8V8UYEEvdFM2DlMDqmGNhO+3fxZqDUtIRwhsR
	uj7a8KAkTNBDQUDnYTg2aXNQaZg11BrLSt2ltL6P3DFt82WMb+FSEZSglBGGfEUyGbZijhBo6Bq
	uSG5+zV1N/Fl7M8+1Iydb0IPtICdjhsJIvgyleEnJ
X-Gm-Gg: AR+sD10DSHcUMwzk8sBONvOHJKlMdFhrhqQvcoYc2BuQ0ihVDFj4rii5y2szBGz6FW1
	StIPeg3uZy1q/lcns1L6t0tV5J4cgruY78QQLc9ViC496XmK8CrmfgisX98Yl8YBTPwV8NxO6ZP
	omEUKhWm2vkSAbV1EW1HcbNjW0no8wXtcpT55N+Q3kju1Pk/gQqk6WCpXk/WYfjxhitR6FQEHjl
	c2w5kPq01zwu+/GosmGgI42ut/fNpAPIz4/NtF5GGz9z6PdoUXz2lrngABadLWzVqNQ3g2O+5uB
	6hPESFpvudBu7/IZZMNGdgbeQVh2VlWioq9KY5K2wqSylPo8wX8pOj3JaUV7WLn/JP/PGz4sQ6o
	e1g==
X-Received: by 2002:a17:90b:4a4b:b0:38e:bfe:81e9 with SMTP id
 98e67ed59e1d1-3933b6ea12fmr20468357a91.1.1786921998920; Sun, 16 Aug 2026
 16:13:18 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 16 Aug 2026 16:13:17 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 16 Aug 2026 16:13:17 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <4c638fc5-5a74-43d0-b5bf-d7ef893cb994@kernel.org>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
 <eb1b5763-37bc-4cb3-890c-1e619e5a8ae4@kernel.org> <CAEvNRgHyRdt7rp=5e5FMbTT=fXNfB=np7VWd_GdmJcPOQgps4g@mail.gmail.com>
 <anpQJvFw9s-XP3pW@google.com> <4c638fc5-5a74-43d0-b5bf-d7ef893cb994@kernel.org>
MIME-Version: 1.0
Date: Sun, 16 Aug 2026 16:13:17 -0700
X-Gm-Features: AcwNN1X3sou7ibuklgbqVQOQa1awc-4sUeU5l1gDhhG2qaPtSC5Jq-Du8Zaqh3M
Message-ID: <CAEvNRgGzqYQLC9ThxcHCQ7KJm7rRMvqzGoznCz1d4dxAkiLkxQ@mail.gmail.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: "David Hildenbrand (Arm)" <david@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 00F781A0005
X-Rspam-User: 
X-Stat-Signature: 411po4t7dwje46xjheexjh485xs5xesm
X-Rspamd-Server: rspam06
X-HE-Tag: 1786922000-782552
X-HE-Meta: U2FsdGVkX1/p9Pus1pQKzsHD9/6cVWzsCIRD/h8HL+zu2DX3ITRrGfA12EJJdR1LDTQhI6TZO/uy7lo/11P/RxFJdeLjRH8eY62eEen4WlfVmg6bcKyNEQj/fHdEPvU/GnyYMz4iPRB0jHI9hp7LAkB9bOFckK5mUURWh24DUgUOUoyphFmuIy7Xc2G6M27dsNUOW3Kwcw/ubk5uHML4FtMhRa6uf3GEEhAwnrrwd8ZH9LLwmDxT7j7ZXD/qFzX6jXOLGkFGBI8gO2KgRhMaco3mXPvRMStfIGSc/X9DChC2sEOQhYd7WiUgTBxBkEcrqzaOFRe3l4BWWd5M0jL0BEYq6BC7y4i+c8+U5z/Y5NOEbIsrbaCnJNLP73tRveu2H2wCFIhnKz7zQDDn0J4aXANhNMuWswS0Eir8AJjU74I0BN0bPM5E0aSW5YHiOF8KR2WFBQ2JggnbiMEW8b3LEUjvLDLhEdr2P591quUT+OpbhEaelrWnWY0LUcXwFr4jqphArSZ09MZh0rEpHF8n0gLvPvimyBOoU81B5kPbPQouMz6EPA30W1mzIR/sfxGZhK13G2b3dcRB4WgTpT7J8BDc2AC9YKNU1ia0DPQ9SBfsZzBLPIZEuC0oKz59eK5CoDvDNyfOws/bSeDV9CpQmZ8UcyswBpj6+YmpyjVt+TY8iiSRVunB8N9fPpJ6NMbgnYzVYCCKo4rrc0NGoFQjln5HBnZUTKMwhq05l2BFiNn4zCWMSOJXcxLh9mOc6KlMwNYRQLAU6Oo18xvvaGGe6G+D8fnyCZEOlcGGE1E0HsHu4Abgyqp700rO4aOi3TsXcNQEnXAY+H/CcJN5TEXhcPghU+AQUzfK2Lr2hkl1efJT7HB30bRlP44FIp9moQbl3CrnwLw2JL0um0JBCEaNv2sfGDg6oxS01MhbykPow5R+RJyxDxsPHrv6AJl+eLBw3AxPYQJ5/k5TnCb40W+
 kTAsvPrW
 o6JU9jFDWS9TJDLopu3RpgQpqpveG78hSphNJi25hAHOTe/J1D/CH7cs/vy7VSWBMoUeUAEuy9GUNbCOlDwnyveIfK6SnsuUc+Yq0txFhJKt8CDICtSpYtWsj+2SlQ8cAAoI6KKd6yCU7zX4v3/ovZ1Tq2es1U485dnjjd0KOFKBS7FBa3Yp7HXt/uxnNZjEFNHQzeQC67nsb1jQhLi8STtCHrt3xROTfJVwTmoYv9t9apw3BBtJSK6t//YxtMsPIKEvcH7ETzuoiO7yTnCTmAoniwSPNgc17Hhl+SRJnax3T1t3QBRo71YAju1OTz/khDQClw9AvbmsVT2BTRMoVz2QX73K1LQqatgwvW9ojupR+ykGwii/b6tv8vI5plFdguMQ064hVZMDRNSoDZiUGwTlMEB+MzKfByxG6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

>> helps the reader understand what's being checked without having to look at the
>> details, and also helps communicate the ordering dependency without needing a
>> comment.
>>
>> There are definitely times where the usage of a function bleeds into its name,
>> but usually that's because the name and the usage are on and the same.  E.g.
>> get_user() describes both the usage and the "what".  And it's easy/possible to
>> go too far in the opposite direction, e.g. by giving a play-by-play of what a
>> function is doing, but that's why we have bikshedding sessions :-)
>
> Note that the problem I have with kvm_gmem_is_safe_for_conversion() that it is
> all about *conversion to private*, not *conversion to shared*. In that sense,
> the function name is just confusing.
>
>>
>>> Perhaps a little ahead of its time,
>>
>> Ya.
>>
>>> but later with restructuring for huge pages, we also need no additional
>>> refcounts other than gmem's own so that restructuring is safe, hence this
>>> function name was meant to extend there as well.
>>
>> Given that I've read that at least five times and still don't understand the
>> nuance, I think it's safe (ha!) to say we'll need to revisit and review those
>> changes no matter what. :-)
>>
>>
>>> In this case "unexpected" (especially since the next patch adds checks
>>> for maybe dma pinned and unmapping), begs the question "unexpected in
>>> what way"?
>>
>> Ya, that's why I like "outstanding", it succinctly captures that one or more
>> references have been "loaned" but not yet "repaid".
>>
>>>>
>>>> I'd rather add a comment than have this filemap_get_folios_refcount.
>>
>> +1, the local variable just made me scratch my head.
>>
>>>>
>>>> /*
>>>>  * We expect one reference per folio-page in the pagecache and one
>>>>  * reference from filemap_get_folios().
>>
>> Nit, please no pronouns in KVM code.
>
> Whatever floats KVM's boat :)
>
>>
>>>>  */
>>>> if (folio_ref_count(folio) != folio_nr_pages(folio) + 1)
>>>>
>>>
>>> This comment explains what's "unexpected". I can do this and switch it
>>> to kvm_gmem_mem_has_unexpected_refs() unless people have other
>>> suggestions.
>>>
>>> I wish there was a folio_pagecache_refs(folio) that
>>> folio_expected_ref_count() can share with this, and also
>>> folio_swapcache_refs(), to solidify the definition of refcounts taken by
>>> the pagecache.
>>
>> ...
>>
>>>>
>>>> I'd add a comment here for the "why are we unmapping".
>>>>
>>>
>>> Does this sound right:
>>>
>>> Unmap here to ensure that userspace page tables have no mappings, which
>>> also ensures refcounts from those mappings are dropped.
>>
>> How about:
>>
>> 		/*
>> 		 * Forcefully unmap the pages from all userspace page tables,
>> 		 * and then verify there are no outstanding references, e.g.
>> 		 * acquired via GUP or similar.  Tell userspace to try again if
>> 		 * there are oustanding references and hope that whatever has
>> 		 * pinned the page will put its reference "soon".
>> 		 */
>> 		unmap_mapping_pages(mapping, start, nr_pages, false);
>>
>>                 if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
>>                                                      err_index)) {
>>                         mas_destroy(&mas);
>>                         r = -EAGAIN;
>>                         goto out;
>>                 }
>
>
> Sounds good besides the function still not being clear about *which* kind of
> conversion.
>

Circling back to this since Binbin also had a comment about the comment!

I'll drop the use of the const local variable and do

    if (folio_ref_count(folio) != folio_nr_pages(folio) + 1)

, and add a comment rephrased without the pronouns:

    No references outstanding if guest_memfd sees 1 reference per
    folio-page in the pagecache and 1 reference from
    filemap_get_folios()

, and then also take the comment and rename the function from
kvm_gmem_is_safe_for_conversion to kvm_gmem_has_outstanding_references.

	if (to_private) {
		/*
		 * Forcefully unmap the pages from all userspace page tables,
		 * and then verify there are no outstanding references, e.g.
		 * acquired via GUP or similar.	 Tell userspace to try again if
		 * there are oustanding references and hope that whatever has
		 * pinned the page will put its reference "soon".
		 */
		 unmap_mapping_pages(mapping, start, nr_pages, false);

		 if (kvm_gmem_has_outstanding_references(inode, start, nr_pages,
							 err_index)) {
			mas_destroy(&mas);
			r = -EAGAIN;
			goto out;
		 }
	}

I think renaming the function from kvm_gmem_is_safe_for_conversion to
kvm_gmem_has_outstanding_references should be better since it doesn't
really make a statement on what kind of conversion the outstanding
references are for.

>
> --
> Cheers,
>
> David

