Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDAD9CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B778E000B; Mon,  1 Sep 2025 12:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C738E0003; Mon,  1 Sep 2025 12:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3CCC8E000B; Mon,  1 Sep 2025 12:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E28758E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:21:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7475611A4F4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:21:13 +0000 (UTC)
X-FDA: 83841196026.26.93E5C56
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13CBE140004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:21:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BOO8Wkpw;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756743671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPcwA7DHP8CQMDqmjZ6zA+PMccXA/CBy019wh06lmcI=;
	b=Gxpj4+mtI61IohuGH138ueCws+jtpwdGZofTQgPIJBJMOmbGBz2pxesrBUsy8W8waE3Nb+
	mEo/h8z1RubNkl2CHqQ2aCSLU4zrCMFyJxhxBq1PTzjjGTk83LVd5mnu3SNJnNU/8vEaw5
	j/+rzaRHxBpUirdrcE1GJlyGbxO3RG0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BOO8Wkpw;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756743671; a=rsa-sha256;
	cv=none;
	b=fFCL8vyIoiwDHWlCBrj74ytN+9BeVMzKuxn1MpnguWI6iq8/Vz/9xWdC0Mw/hKUtoGnTk/
	NfSqhwRhEuHp3wMUsExSKUJmasqCSqPs3BcXx/lnO+ymI146vcbWhkm6klPX4UOGheOWPT
	LlxPsYPWQP7H/qOQyH1nVEPp5T81D6s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756743670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xPcwA7DHP8CQMDqmjZ6zA+PMccXA/CBy019wh06lmcI=;
	b=BOO8Wkpw0Kg201snHqGMNZ1zRazJidHGgxKRQBEK4lbbu8WCLRHHnPqRgszxiiLPCBos4P
	XED8ANJGsszLLDlT2LIK5fkQgZgG2HTiZ+QjrrqkMWrTVuFxYHoZHPNjT1Tmc1bHa55Bs2
	9uiJfze/4XQUDEUjssdiP0If0qLyCVU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-kMjVWUcXM9u6mEXMZQuM0A-1; Mon, 01 Sep 2025 12:21:08 -0400
X-MC-Unique: kMjVWUcXM9u6mEXMZQuM0A-1
X-Mimecast-MFC-AGG-ID: kMjVWUcXM9u6mEXMZQuM0A_1756743667
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b869d3572so6265795e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756743667; x=1757348467;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xPcwA7DHP8CQMDqmjZ6zA+PMccXA/CBy019wh06lmcI=;
        b=RQutizoeuH9/qB960mFgbTocaW6l45pI4qYmmb8fkf8ulvQ0KcQq3oS/zEoCsbLJGR
         aN9UAemsULm4eayfBSdmHXAcWhOpnVmBUs8Ti3wI+uXR39ynHnu0OmYrqT0jZCBlD9rE
         4khjs2N3XDmWW+ZcRAvDAycTaJDIWowWP5A2Bdq2ERG2+RuEWTnnHBu+OK34h5vrVjId
         hkQzXaUBT4WmSKKgMOSmM3eFak/mFOCRCp3/8bE4LvcG5Olt0AGI2LZB1fnmR2Lm1JAV
         5RwA79HOOmpq7YdwzN2gGFfWFsnQ8d6u54H3BB4LcWf0YEbH3OZxmCqk9d3HuHF0vMMj
         98sQ==
X-Forwarded-Encrypted: i=1; AJvYcCUk5SGt9YKu+hjOi6uMvr5d42S9gd1z7HumDy4EE/rmgUgd65cj4YzVbYxwHegG2fmK0swaTl1q7Q==@kvack.org
X-Gm-Message-State: AOJu0Yx9U97G02OIzId7PpK5ufWtsQyxOJbkWL2DaFuH7WUAWdn5Plrc
	hrnyP5txpXXfa94hWxsByJJUg1oH9483BY5JoPeYzmuGLbdwVGs+sooH0RVq6YKSNwO7E2viNPY
	7bCfV9S31xIiH2BSPd35LsU99WKXQInEru4x6jS/hp/CCDt+NtMDi4ye7phyU
X-Gm-Gg: ASbGncvLq+iFH9zGIN86VzNCBqLOfYFNOsbfSGH83kUJ4QKSRpJ++Wcyc+GU7kLpaEN
	31ATexY5xwX003Na53qSvbSX5y0D3Hcs9CbRYX1nPCY9sK2D/G2OJiTvcQ2Pd85tKxhvfZs2Kss
	0sKGJTwqizU9eEPm1m4rwTyV6LoqF+18GMtOwiM0EXLbz7F38cc4jhHWF8R+46VpsEBWeyr7Row
	2DTIo30GJd2if6Muz4EDtapQCrc8TJqrEuaS3FLcELPGdTxZSBildLeg46vlSdn1gqb1xi39dhG
	rtzhU0JTXNJUnO2u/paYT3LyntuVvcJFhvShIAA38NpXZfe//i9GCdUzecR9DwwMNeaJpYkSuwD
	4EiFRHcl9afOY/JkbnMrZOjvRcgGYDfYR1RQ2lHK5r2IDCeq244nb3F1vvvpwxjTok/k=
X-Received: by 2002:a05:600c:c8f:b0:458:bc3f:6a77 with SMTP id 5b1f17b1804b1-45b855261cdmr64178335e9.2.1756743666687;
        Mon, 01 Sep 2025 09:21:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0X+8mvSEeRaJrsUrV5c2nUPwcb4BLt12X/j/210D44OdXtgUpfkmIvO5r1ObQQubR1FLV+g==
X-Received: by 2002:a05:600c:c8f:b0:458:bc3f:6a77 with SMTP id 5b1f17b1804b1-45b855261cdmr64178025e9.2.1756743666189;
        Mon, 01 Sep 2025 09:21:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b93fae643sm6961135e9.3.2025.09.01.09.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 09:21:05 -0700 (PDT)
Message-ID: <7d423d50-47e0-4c97-abaa-1fa865ec3e42@redhat.com>
Date: Mon, 1 Sep 2025 18:21:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ReAn5S5urur-ZieC4RkB0ybV6UwYXwxYI4oU0AQKTLc_1756743667
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 13CBE140004
X-Stat-Signature: 5e5qaxpfchh6zskjnbqdfcfj4iairsxk
X-Rspam-User: 
X-HE-Tag: 1756743670-752539
X-HE-Meta: U2FsdGVkX1/E0pdjbXStdt2Qx7jgSeTGcY0xGzE0lxwt5WCbq7QhiQz6OnDb+S4nUhkqBcGsO6vy7sA/F1t/NynhgjiXbhwqTK2dB59hY9CXRddwR4/UonmZLf/sCLgYs5iXf3uCKMctrLudlB8LthqPdPJoHpvsrfTzd6nVygFEjtXOVlqZgTXhSd9x0lNfVAHtw8ZgYBBA75f927At+dTmqflNNFEnq5D5aSpFn5ggabqflnF5kaRqTqOykBO864hAjev9kKRM7eFYgTLmzHpFh54r1jE9xV+hBahb2upSIf7Tnh2l7AML4Ve1NSkioGUJGuRF1Md0QjDPzGzFNb4y+jRk+Fhy8mGYw3fLypMcL4TQu6yQaZfu90LWwnhk20JQgBujxs/l/nGNRFWm21GHFdqVEmlrOEF3TK7Xh0UTCRhzABs95kktm9drQRkwkdycM6Em22tQ6ByzdsZJPeP+vUFCe/PqN7w4sZCFzg20pcwmIEar0VYZAHU5PEzCn76uJ+D311VPl35gYAM/cL2PmSR29a0wOF6mkPzdzvwBtcPpUw5TviKuhnoFhkPW+a1jGbUFa1kq0zkpcKa5/Zx/tLVL1I5ley5mn4FjUC2VY4VOrYV/r/C6LvqhQsBAAQ/5MrEY5dlDcQI2FOohXz2ontWkfzydaook1NlC3dpZdeRA6ASQlnTSps/zMMG2A9d/4RUxt/9pWJHueixeW6Ibai+5R9fksRAaXy8R/CP7Rz4rsKqUJKisz2EKTFmCRFY9vLFvJ9qHb7PalBpkUBW2iIiXnGXzhcmjdLteHuFdGHFgmSJ0OVW1Dh60V8qYb8V81VHmOGdfZR0/c6qZHls48kimzfMKIX2KR/LrRj2/DVZjmglafqa8VUMI5tlhEKp32Im3L4Ww54v1exrgV2WOO/EV6d85CTzmFf4SjW6DxUC8EcIGAf1S8wfmssoaHqtSVPHmwBaG+/N91Hn
 2dknroPi
 88DCWbe3zbIOW/4Ppey1+q/41OYgsYIvchbfJYoqWPPXLC1kaUJ/N+tcjqQS8GfHi6R3lz/pTUTqWecwQyYT25B3lvoTnNEOwZ3KeSmSGqavF7FGBgXdI9Eyf3MceAc2JNUDE2C2UKz/p+IHf719QFKvHuyf1IHskRDaTc70ieoxw4nGsj+79UZ9VKOz6Etj6KF2RpzDKzwEM9ASmnmLclDrt8pE/n3fAMPFT8r+3GFuSaGtI+aCKEekQx+kzFu6zhMc9Fr5uJKc8RIA9yIqANWBLodqWof9p73fqtm4YHLLmKWuoyAvTafpcA6P+2OLVfQW1aFJXyh3taTy8Ng+LKsvw/yyuoHfgKQWK+qq9V79JwjhVr2WWb9KRgJ5pnH+ZM2aQh8iE2CbH9SBjKCv/Ru8BmnhbmODt1fR+8ZtaG4wiqmmIQunqY7WXslcbG9ym6CjXAa7XKLcQQZMwI7LGl+KQduViGwOLSCuAG7cp+IRPNyddWamu0isqOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.08.25 15:41, Nico Pache wrote:
> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.
> 
> To achieve this we generalize the khugepaged functions to no longer depend
> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track chunks of
> pages (defined by KHUGEPAGED_MTHP_MIN_ORDER) that are utilized. After the
> PMD scan is done, we do binary recursion on the bitmap to find the optimal
> mTHP sizes for the PMD range. The restriction on max_ptes_none is removed
> during the scan, to make sure we account for the whole PMD range. When no
> mTHP size is enabled, the legacy behavior of khugepaged is maintained.
> max_ptes_none will be scaled by the attempted collapse order to determine
> how full a mTHP must be to be eligible for the collapse to occur. If a
> mTHP collapse is attempted, but contains swapped out, or shared pages, we
> don't perform the collapse. It is now also possible to collapse to mTHPs
> without requiring the PMD THP size to be enabled.
> 
> With the default max_ptes_none=511, the code should keep its most of its
> original behavior. When enabling multiple adjacent (m)THP sizes we need to
> set max_ptes_none<=255. With max_ptes_none > HPAGE_PMD_NR/2 you will
> experience collapse "creep" and constantly promote mTHPs to the next
> available size. This is due the fact that a collapse will introduce at
> least 2x the number of pages, and on a future scan will satisfy the
> promotion condition once again.
> 
> Patch 1:     Refactor/rename hpage_collapse
> Patch 2:     Some refactoring to combine madvise_collapse and khugepaged
> Patch 3-5:   Generalize khugepaged functions for arbitrary orders
> Patch 6-8:   The mTHP patches
> Patch 9-10:  Allow khugepaged to operate without PMD enabled
> Patch 11-12: Tracing/stats
> Patch 13:    Documentation

Would it be feasible to start with simply not supporting the 
max_pte_none parameter in the first version, just like we won't support 
max_pte_swapped/max_pte_shared in the first version?

That gives us more time to think about how to use/modify the old interface.

For example, I could envision a ratio-based interface, or as discussed 
with Lorenzo a simple boolean. We could make the existing max_ptes* 
interface backwards compatible then.

That also gives us the opportunity to think about the creep problem 
separately.

I'm sure initial mTHP collapse will be valuable even without support for 
that weird set of parameters.

Would there be implementation-wise a problem?

But let me think further about the creep problem ... :/

-- 
Cheers

David / dhildenb


