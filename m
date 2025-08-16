Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9252CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246676B0391; Sat, 16 Aug 2025 03:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6BB6B0395; Sat, 16 Aug 2025 03:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEA46B0394; Sat, 16 Aug 2025 03:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDD206B038F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:27:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F69DC03BA
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:27:45 +0000 (UTC)
X-FDA: 83781790890.11.7E8D72D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id EF03D40008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:27:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N8t0me1D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755329263; a=rsa-sha256;
	cv=none;
	b=qRo9lvDPugHKkQf3tKMnDa8sZhvy5Zrq9R2P1IRY+yiIpaeO11qJD0CsAvmBoFzfYAF3iZ
	8DRyOJ/NRcAMebiyRCAfiEOXTm9G00VxbUjzxJzuIdfUpvl91Kjeqvpa2Z1lTwT2EeV0jp
	hNQ5R1jRu4ZheTfOTgJzKMgHnnOnOUA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N8t0me1D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755329263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4AZfAqos/ixFErYX9dKALbYZxnmcFT530+q+YUTGEQ=;
	b=70ORvRBr++gp0W9SYOeZnOStIrh8nvlLJBomCiofoLPmWZCFF++trUnsyiZSK3rX+IZuKW
	26320d4DS4iqWB9z7cVwQFBuPOMr2yeSoa+yn24MDq76WWWczP6LpW2yqT+KKWxhjIBswY
	9XlvSW5Syq8k2NUVNJATYg/0f6pjaCU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755329262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=t4AZfAqos/ixFErYX9dKALbYZxnmcFT530+q+YUTGEQ=;
	b=N8t0me1DFuV1SJbcHpBteQkSXbVRxCD0MTOJy4Evjj675kjBVUY/LwKnWRASxntsCbWdc0
	HPG4N/9TzfrAxlAq9reqQG2XHipWPGdtdrBsCGCQ2fEckYmXreMfENqHXycK3hOZ/dQpSP
	NKmh3cerByrfHW2V2GxVfUngHijDSQo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-Ye4X6cn8MiG2lrYFAV0_0A-1; Sat, 16 Aug 2025 03:27:40 -0400
X-MC-Unique: Ye4X6cn8MiG2lrYFAV0_0A-1
X-Mimecast-MFC-AGG-ID: Ye4X6cn8MiG2lrYFAV0_0A_1755329259
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1ac1bf0dso10514345e9.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:27:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755329258; x=1755934058;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t4AZfAqos/ixFErYX9dKALbYZxnmcFT530+q+YUTGEQ=;
        b=Rjhy52TH+2NQe8VQW96MfiyANlMxRRRYpKFPBBZbzZ+vts6sqni7SmfTANv4YYSKbK
         JSbRE9XUKgyxBFAQcZ91nv9e227VtNCDwoMOMh4HD9J3zgrHALaVXTL2H0x1rdPYX2Ru
         8hwPyxISnJxg0in/qtDV+cLlYV3QUervlcSxDf8wG3g2B10/mPuu0pJDyxKQMjB3F/PL
         0x4X+tpvGoz+4I+8Wy0SGgZmtXlXgWpAlCS5ND3pl0ZbwCGMXE0MnChWp1K8/qPAJvjV
         dv1cwx1lM7sA1CK7Z6hIz0Ex+JHzgth2UkkYFc5SU9tN9iuoccZvN7VBY6ixuz+KvKNO
         j8fw==
X-Forwarded-Encrypted: i=1; AJvYcCUWoAytBeHycm6iCdKzZAIdfT9wPt77YoxE0QNLjGB+NG2miFvsPbZlccXQI0EL5sZHKwcHPxw2eQ==@kvack.org
X-Gm-Message-State: AOJu0Yyo52gNLw1a4whRD3G02vf4Qn0T3ddxBfYCMY6eaIGXEjz9Hvbf
	4Bay4XqFQNTg+RxJpYJpsxWZhtMZtHFtcw2UsXzflMM0urHcbek9DOrXxxPDpIySewQuCrSgIXJ
	EN9fg1TOWeEicbzNyWykLW3A9VhZ6og8XQmCevRNK0yxc8WcZrn+z
X-Gm-Gg: ASbGncv1Vpu7zgWr7ZobpoQv2p14A1pEOljBazCZ5dR3yFbE3vhf8pSEnBoHljanPed
	hCuL6oeYXhnPGPdTlVs0PlIQcYwcoEl1Jfrgvgd50IRT7K7fWhllNQypfKrf0CsDsZiBEVglcWW
	Rb9Jary6C9841jAlKqIJf/jElG7RCEzL4KACU26Iet233UAee0maXSi3s5eumQU5+DVr/I/vJ3a
	cm7nO8MLXoeSXmyGhfhCv20jS5LAtdK/Rx9Uvv48b7KbEO5QXj6CtRNqlfyjarv9j6Oqli1ZJLq
	Qo6uMkN6wftZ2MpAHN13Cj3CCtP17znwjLAu90pgipG8KRXNFj3VVRlANyO8JYolM27WW26BgKK
	O3Rz+O74wbJynAgaCn0AeJlkdIsxXnFjnocyVoLimQr42MKXYUTBIF99UZIYmSMKgcAc=
X-Received: by 2002:a05:600c:c8a:b0:459:d9d5:7f2b with SMTP id 5b1f17b1804b1-45a21868766mr44537435e9.16.1755329258563;
        Sat, 16 Aug 2025 00:27:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2I2SUKhif0Hm9g/IxY8EqmynMVQZkR4uOI9k9t9tj5wPS57kzRPdlWUVAFYi06e4VqTYpFA==
X-Received: by 2002:a05:600c:c8a:b0:459:d9d5:7f2b with SMTP id 5b1f17b1804b1-45a21868766mr44537175e9.16.1755329258126;
        Sat, 16 Aug 2025 00:27:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231990esm47602845e9.9.2025.08.16.00.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 00:27:37 -0700 (PDT)
Message-ID: <692138a0-e21e-4595-9ba1-931a711dbee1@redhat.com>
Date: Sat, 16 Aug 2025 09:27:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: Always inline __folio_rmap_sanity_checks()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20250814-rmap-fix-build_bug-conversion-v1-1-fb7b10a0b362@kernel.org>
 <9733f669-faab-4c4d-a663-ce0b877ee11a@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9733f669-faab-4c4d-a663-ce0b877ee11a@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k7irJfAa6O4O_eUQay18OY37d9Ivu_NncMGV5y2_InU_1755329259
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EF03D40008
X-Stat-Signature: uxuprxig69dhctsuoudwj31s37td9wwa
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755329262-414057
X-HE-Meta: U2FsdGVkX19DVQchJCMQZIZbXZe4jnQuYxylJCkENj0sJyorfbFio4njAu/WhwXVVZ92KhI8IwWN/diAclgqqUU7sZvOzk0CF05araaDXzyV/OAOg8mq05h0G/HZA7NvVptuUZ6IgZM4Nj9tjlvhPJy2tiqy4TSi+XU64Ql3IsIAHhU9VVhTjwCMbfp0FRd5h2wOxMVh9tVDEIX3E4Wek9JndjqNu1I0W9BMW1k+kIbcdXckXWld7Rirl+eoa/tPGiEUoblj6s/vQmi9ZU4D1XmLMUA7zkBCY0h/xVpooJaplEMIopIDtZKI8oBFXETZGbKfY94GBOoPtVI7s9PEYnrXZUDFGdW0oZG1vYNqqQCx1npY+RDUW3AK0EmfJocZ3YvCU9FkAG3abuQBTlTN+Ub2m70SmE1Jm6oLTCPj1Icykjf9hdfaIRh9raCgepNS+kZntATziZY26fQCk5huUdmUwK9Zm+i332Oki/YwzDyLmtA4Art9Fp+QIwj4ZSklvCP+CJImTy7tLnxd+IHT+RL51Qcg9nwsUeuicETmOIPdScomNydnimf53ihDbq1gUZV620VBGfC2yjDnLAIbJjOsrb6jio0BKCO/ALrpEKOFQgEX8hk2Xuv90R3Xw+TTOO8kMWXWtT7tJnZBwVYrwV91Ls8eNOVMOpdzo3OnZJ8692IZe6ftuhzazE9TnvPQSqCuP+pdw9780KOhUSPQ3lx+adVaSK1NCRXoaA0kEg5psBvcMBxXuxmela2dm11UdBtXDVi+D7ycmAcKuzV8N2Eh5IsGbtj6PbXt0absfL55oP+l3B4DUQgGQOAXLBcGq+xFbCfEZRqQm8eHTcu2V8Nu3+FFQuvlwA3GcDUpFd13wcuqXuZAEXhnEOcztaeLgaaiDJevkimS0I1sehzw+GumD2cP4UR2J4SkC/gWn46nRtX6ECeZXZbH8Kz6ovU2OTEcGIM7i1lW4leCb6Z
 2g/XocyK
 2Jim29GHEThaOhjVHnADr7qdzOdDrcwroVO2mxC87fd3kCyz2+Sa9wsVgXlA5auX93bw5VyatmUYPr6OLvroBCSJdY3++8Yr5fdMe/AwTFJpxObrdoxSFjlJ3vCrhZEyayWZ2/jXLKt+dADbgu9yB+f5ew/vZpX4sad430XfaygHZmMVgZY4zZblSKy7l5q9OMsxGmhMnHDguO9Bpirz/dcVpRnwJlQaDl8AOt+n3+ivlShnBf8tHHjgJFonbZVzgUp6a5xlwLFi5ZU6N4NSqFXZF6RlKbe7Hvn3UCyjeQ0JJIbe8pAUui+dZl7jozBIAtZS4qyziSfWy7xsMhIO4xE56T8sf7XXS0yTn+pnOur5MlOIKJaR2Cng6p67JmfOzEKmt6wBwcUhT9hmMMi+BB7y142Cj0W2trSAI+s+zHnpONpl9PU3ro/bFrE7t2wbcQhibfI5nAxpIswMY/p5U4Aku9YL8oig40Hck1kurgMsW/XWWNQ8i1vJPWKgF2eqTusLeT1aqiyGoTMlMvYY9thu0e5V7NRDbjU7PePn0rh8waKmtpl0pfb5lL5NDVIhOZfFAyhA1DeFrU8v9Rdf+gO3iL24peU5ur3PFDOVYIcbjemBA3YAAEwfQvWRETLWkvMbP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 07:16, Lorenzo Stoakes wrote:
> On Thu, Aug 14, 2025 at 01:05:22PM -0700, Nathan Chancellor wrote:
>> Commit 5e901e249ad1 ("mm/rmap: convert "enum rmap_level" to "enum
>> pgtable_level"") changed VM_WARN_ON_ONCE, a run time warning, into
>> BUILD_BUG, a compile time error. After this adjustment, certain builds
>> with older versions of clang (such as arm64 allmodconfig) started
>> failing to build with:
>>
>>    In file included from mm/rmap.c:63:
>>    In file included from include/linux/ksm.h:14:
>>    include/linux/rmap.h:440:3: error: call to __compiletime_assert_890 declared with 'error' attribute: BUILD_BUG failed
>>                    BUILD_BUG();
>>                    ^
>>    ...
>>    <scratch space>:21:1: note: expanded from here
>>    __compiletime_assert_890
>>    ^
>>
>> While __folio_rmap_sanity_checks() is marked 'inline', the compiler may
>> not always honor it, such as when sanitizers or other instrumentation is
>> enabled.  If __folio_rmap_sanity_checks() is not inlined, there is no
>> way the compiler can eliminate the default cause.
>>
>> Mark __folio_rmap_sanity_checks() as __always_inline to allow the
>> BUILD_BUG() to work consistently, which clears up the error.

Thanks for reporting. Weird that no build bug stumbled over that so far 
(neither on the list nor on my private trees).

Maybe the latest change from Jann made the function bigger and the 
compiler more likely to not inline this function.

>>
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> David needs to have a look, but afaict this seems reasonable,
> __folio_rmap-sanity_check() is only ever doing stuff if CONFIG_DEBUG_VM is
> set, and in that situation we don't even care if this would somehow be
> inefficient, but in any case modern compilers would inline it anyway.

Yes, all code is written such that we get specialized variants without 
runtime checks -- except __folio_rmap_sanity_checks() because that would
usually just get completely compiled out.

We could either have a WARN_ON_ONCE() instead of the BUILD_BUG() or, 
rally just __always_inline this function.

> 
> So LGTM and:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>> I assume this will be squashed into
>> mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch so no fixes
>> tag.

Yes, @Andrew please squash.

In any case

Acked-by: David Hildenbrand <david@redhat.com>

Thanks!

-- 
Cheers

David / dhildenb


