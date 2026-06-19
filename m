Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B743DCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9946B0088; Thu, 18 Jun 2026 20:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AAB06B008A; Thu, 18 Jun 2026 20:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A036B008C; Thu, 18 Jun 2026 20:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 219986B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:17:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 790C6402C7
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:17:20 +0000 (UTC)
X-FDA: 84894747840.09.5BC81BD
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 680CB140003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:17:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="CmBDgw/q";
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781828238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbpfyvqJcFkrtmEYwnR99Bs4srke7ZgaUq2BE34tWXg=;
	b=BW5ax3Zz6+dh+vKTKpIdaXeVF8qf3PhLS+WbV1hKUsJ2QHqZZj15bdgIgJJ8kmZF2z567O
	lxPrHzE3aMlZl6ilnYG8sVY5QmSDvGqL5akd/+13wi5w7dbu3skLEEIuwCyKe4ixq7ehRo
	1V/TGy0PNDrndotjrS9D6hHuznbw7hA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="CmBDgw/q";
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781828238;
	b=UJ3VpiosefXg/pzh7WgZjaeLrmgUDxt1cWeED+4suAh5Kw+57UO3rbDUt8ud6qx+zpliv0
	GwtsETgQ1mOUNGr7DCwXt8Bmose9rWNh31J3ayTr38FQETSYUy9dPb7b9C4Qf4rqezO1m3
	WmxjM8hmVwkhSdGlY0QmCuGjCEA3nag=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1390f75d8bbso824819c88.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:17:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781828237; cv=none;
        d=google.com; s=arc-20240605;
        b=MXgUc8IR7ro/5qLK2Zxd5SdQB48w2uDV7miQT/w0MUUxrD7//5qMPS4zxN6rCXN1Ub
         AptkUX4BEHrfC1HrdTay4T86beiuFDp3m6OxpWdHI0UjsWVx/TbpAVXisYuhndO4XGpU
         lAVBpVklhWxD9KRK8ahdMbXHb9Gpk0KqcV0kNMbKlLOFxt0YWTQQJ7wvCc9qxGE8xC4r
         W2OawszVcRPKHeTh7o9GAEftvBc46FIehqblXdS2A/L2LiHv9zRa3KgszBmIte1+K1K/
         U64GCB7dTnV80CXIa0eUtau/Y03a0oBon7481IPrxRQuyMp/kxQgoXmklnWC50PBUhOx
         j1cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xbpfyvqJcFkrtmEYwnR99Bs4srke7ZgaUq2BE34tWXg=;
        fh=27Ey8Xy7OnVjHyY6TpisK6mnYA6C7RgmXHq42Psz5nw=;
        b=aHLL9tulU00lrKG/pk3PW32FfpQf6iFyX6bSe9DWUVoHnVjMVupH+uLPGasz/IHa7Y
         ipwGNmcG9XD0o4+J0tAIkniqDy+5VeJFciO79FIkwzYeKukv8uabJ/F5pxGPNVJCiLub
         i8ACcqBAfY32AhaB8p7d+r+Lc5rr78qGGvCtS8IEyYTx+xjDpcP+5GbkYidlo3bk7RkM
         BGdctvg6Z2SubawOeCOdjP1IFKl33Z83pmCvrK0SNSFnDoaRuW8khD8JebhfVrO4Owro
         DGtOh8IGeP/btH8fXDaljTAV9T4jxKSwWUsGz/VBHaOvtqgNvVTXTZy0g4DfLER9aFPy
         6+0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781828237; x=1782433037; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xbpfyvqJcFkrtmEYwnR99Bs4srke7ZgaUq2BE34tWXg=;
        b=CmBDgw/qG5YyrvDa50E3RuOFpYyG1USjvi4yuB+6D9pJrSe4ED+XY6zt3v8r9Wh4oj
         BUiFV6/uXUdPXM90K/r9AYxdxIBEphLHlYdaVDbHYbGcFR9ODlhuC4KAXz8xzekCq5el
         +qQWIE1jqVUzQAwpOjpjfielJpesjkYR+2KeCKtxi/F45mHDxyxbYsU0PXwl0b941qWb
         3T9KXadooyMPhFIu+u2G+sX+WNI2IrnX+tAqMM68s0kEw4/5zOVWGdd5UNBZSxzBexIi
         sK22fBccancIxrpzKrqoqXEEelVNOCt/Cyp95dfkXloJxa5D1PAUds8NvGPkoHbNBVR8
         uAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781828237; x=1782433037;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xbpfyvqJcFkrtmEYwnR99Bs4srke7ZgaUq2BE34tWXg=;
        b=dfk64kNGmfAxQsr8o8+qEvXCMEwLAbqa5C7W+BJHdi/JGxxBNYDAMtz9TO3BANpdI3
         KtVV8OXzM0y1K4nZaIW4jCNiuL4gl9WCfJyYsD9XtMTC6llK6HPkPkTeMSD6JwbPevvt
         CIDfF3lpsIJi0Mg5WEH3igTqItftzBoXXu+19npShTPLGZcMG2y/TIpHKs8LoJwR/EIn
         2LpHngmb55CiuNO13z6LEJYJEGNdX+eZOIW3r7Ib4VqyohouPwHjGgpgPRa05HJ4iuf7
         S+yM9SvmHluGQPa4NyYfTGDUlrdFrGLbUuz9B5TNncXyWscByp4YR0JbZPrsYXGqSdYH
         ZLcw==
X-Forwarded-Encrypted: i=1; AFNElJ8Nl7Lbz47JIGx2SQ2mK3RkvG/+yFvswRUclOPmYZ/lQkHyxPHxZyOdm1FDsGOV3ipR+ppsNPse2g==@kvack.org
X-Gm-Message-State: AOJu0Yy813kQRCsQDfWIcVwqlAuljLtAPiK+xaM1ySUN3mtG6GQo9r0E
	ogOagvO6P4XGkfrhYHZ6bIyWC/mTTXU7IT6uBn3/sIQJa/BtWsCgNSkas260mmbpExFebeptQ8m
	zBVpPHrksPXYPBccX5OcKK1jYwyfWUj4fcH0vannS
X-Gm-Gg: AfdE7cli9fb2tUfJu9nCsy4i5gr43UfMmC7LWwsEG+jCz6wHrlb/O9cIj0Hs0CVCL1E
	AbEOJs5Hhw50ELc/AmCdZC0QGzVl5wzOEDh+MJzMvea4z0EyQjDG6CSeWLBGe/bWOmq3A0OgNpk
	rLz9wEBQimr/dJD1EGluWqtbYyM1bHzVJZtc7EEu7Wm2vEmdfrYqz6ZKqljDAVoIIRthpW110yT
	jO6rN2RFnIpdzztQiQWjlyssac1JR6Klh5o3MsFLJwOBDZPGaiPjMabvmUbE1AOHL8L1jFVPDPD
	as0/n0J8uhFHvM+AxE2Rjj1kyuOo4cTz3/N/OAwKL4WzjPvgltvQrjBPjp0=
X-Received: by 2002:a05:7023:a53:b0:137:eac4:82b3 with SMTP id
 a92af1059eb24-139a5030901mr102913c88.17.1781828235521; Thu, 18 Jun 2026
 17:17:15 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 18 Jun 2026 17:17:14 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 18 Jun 2026 17:17:14 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <509f9a66-5ae9-4c05-bef1-ced89fd29bf0@kernel.org>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-10-2f0fae496530@google.com> <509f9a66-5ae9-4c05-bef1-ced89fd29bf0@kernel.org>
MIME-Version: 1.0
Date: Thu, 18 Jun 2026 17:17:14 -0700
X-Gm-Features: AVVi8CewB9OSB5ydvz-H83kPwJbWVO-CyG6kASZWbX7de4UUA5H3gpKgSOQyYIY
Message-ID: <CAEvNRgHM4a66Jx9++6iioQLpFY-KgPvjY5+bg_X97DfSjpXzRQ@mail.gmail.com>
Subject: Re: [PATCH v7 10/42] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 680CB140003
X-Rspam-User: 
X-Stat-Signature: fo97h6sypo7j639eht8oa79j5dk84b8h
X-HE-Tag: 1781828238-604759
X-HE-Meta: U2FsdGVkX19N/GUZEztW5w7ShMc5P0ySABXl+BrYA9iPk3YtPtOlC4vBLWBbpQXAASuU2j/M0+muby1HLCdGk4qLHiG7kR3hYkmprVs+tGDsA3SC5t7UzIW99CVcNXIVjtYhJM0dHddWq16atBXZQPQNHourGDv6i/BdEyAziyDOhneBW3FQ8zk7HvTtRScY1yx9v3DoewIfOuxle/hL7x9xrNWzFdxefpBxKHPLVltPoacX1TdTxRf1RMYWCRsGYm1p2K4JfCUJjLB/NIwvZujERyT5WW71SkiJ5p963wds6/9V6O+Fow5W3Wu8zoAl7KmPHb16iITW3pwRV6xcDXjx0EHcUYuh9UrLiUZmn26FF5aruduyBohStGECWE8gUwTk91vXFrMRVbfssPgL+ioocXhl7veEgyY87G5aD0x3CPsMHq4T3HzsE49HNBDV+ZSqEjQkIsV41A+DPA+FA8D1izLwrg+vpla9JNfrLxvL5qC7lbHSvPn7G8jretFwQW9lVpuX0SpKCgoW3Snj8wshBoU/rcgRxvDWjHJoyeFChwTpnblFd+WXKL0sp4mCM1ln0SIRivCHJ8woGOQ/d7Uif1+x3E7eIQxDU2QWlqSNKCymPjjSZz+xbgTfJyRRjTucirv68sNr9Y+DTE6kArNJ90a2SJa2E23zl5+Edk9hPFdeTsj8KkL98WoYe8VDRjhUfpbuelfBOEKbm/6EQCIXDYKhNK50YET4lOuvpHKXrVE5p3HTwXqMj5Tfl0me9ZND5vJcp3RLuFUwfCforBJY7KiqA2ttXcoFCCKaf6CE/NAX/ZLspiMfNo/KpnG/BNn6K6ZSeuCdDoWyvyVmjdBCt/lFhixRV9R/PQT1KeMJI02nDxQS4GhTWm4G0nDU1+p0R8XxODQoQY2axn4unswQ2JpT1hYU2IN3vItotCMkHJEoLAgChTkWbIadIrMTBSUznYFYO7poVdYIiE4
 Pt+1qNGJ
 rUBNLOeCNeRvQuL/IGB0L14nQQ2XFByug7FwP3OTkI1MQlDL8y0YwambUq1L4nRy95oOeJbF5xOb1DIhuTzcH6jI3CRx5qaqVriS6a/jyRjQd17BDF8HRzdvyqIiqMRPZm6wBCHWjHgLAWvxHU8IQaIjW6AgeQO3Are2Q6Di8rIf/OFfVcbTJw0xMviY8azElYapiPvxHCKZrmSSD8x7gXDkUsijB3Om6JGUav9duhSQCaz6WiitrOw23Ps9H4fWsZ/IruI9P93wvh7+RbI0Yy8UqMtn5r+B2gKoHl37LDBWpqEnk+iPPaaFJ06Bci/6heZM3nz3MeCpfqWejc/PlSeoYgzOwzpByJhfyBYCXItkd0vsa6adxyYAOP8KQJyPmA24PbL0S5vY8qyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Vlastimil Babka (SUSE)" <vbabka@kernel.org> writes:

> On 5/23/26 02:17, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> When converting memory to private in guest_memfd, it is necessary to ensure
>> that the pages are not currently being accessed by any other part of the
>> kernel or userspace to avoid any current user writing to guest private
>> memory.
>>
>> guest_memfd checks for unexpected refcounts to determine whether a page is
>> still in use. The only expected refcounts after unmapping the range
>> requested for conversion are those that are held by guest_memfd itself.
>
> Is it sufficient to only check, and not also freeze the refcount? (i.e.
> using folio_ref_freeze()), because without freezing, anything (e.g.
> compaction's pfn-based scanner) could do a speculative folio_try_get() and
> the checked refcount becomes stale.
>

I believe there's no issue here, since the main thing here is to check
for long-term pins on the folio. Perhaps David can help me verify. :)

> Might be ok if we know that no such speculative increment can result in
> actually touching the page contents, and the extra refcount and something
> inspecting the struct folio won't interfere with anything else. Then it
> could be just a comment mentioning why it's safe.
>

In this series guest_memfd doesn't change anything in folio metadata,
guest_memfd only updates the attributes tracked in the guest_memfd
inode, and updates the RMP table for SNP.

With the upcoming huge page support, guest_memfd needs to split/merge
the folio, which means updates to folio metadata. That will need a
closer look.

I haven't added the comment, mostly because it's a long weekend here and
I'd like to get Sashiko to run on it over the weekend. We should
definitely continue this discussion on v8!

> IIRC the compaction's scanning can result in a migration here so it's
> probably ok?
>

Migration isn't supported for guest_memfd yet, so I think that's ok.

>> Update the kvm_memory_attributes2 structure to include an error_offset
>> field. This allows KVM to report the exact offset where a conversion
>> failed to userspace. If the safety check fails, return -EAGAIN and copy
>> the error_offset back to userspace so that it can potentially retry the
>> operation or handle the failure gracefully.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
>> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
>> Reviewed-by: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>
>> [...snip...]
>>

