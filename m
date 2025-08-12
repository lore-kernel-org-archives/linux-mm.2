Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C70CA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 20:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132388E0193; Tue, 12 Aug 2025 16:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2D38E0151; Tue, 12 Aug 2025 16:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F139A8E0193; Tue, 12 Aug 2025 16:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDEBA8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:57:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACDBD1364EF
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:57:32 +0000 (UTC)
X-FDA: 83769316344.14.9D39F74
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 27414100003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 20:57:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QrgpPL/q";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755032250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MdgtvTf0GppffJVf7+x8IwG9neJu2jI9si12zBjn6Y=;
	b=2N8eY2RTxNCAcU6SkVy25977zyUogrH8q1JAkjFAGsuGTbJm9vr+Z41dncEv80k6shxIZ8
	IkEap9HlJhlgg7s+9ELPOsks6lpzsezfpSRFksud+QBxxm/+s7fhbrGN5Bd4FMYgGeTELB
	DBBcmypQzAorCC4G0xgXIRwlcAXkXbY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QrgpPL/q";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755032250; a=rsa-sha256;
	cv=none;
	b=Pus1WuOWx6KlMP1Ubo6FZdwu+q3zHsjovyWIXVyIbX1/i/CLFejMF/AvL847eXlClkZtqw
	N7+WvO7pfHaL0VoexnCb+VAILk2eRC7DfgcLdh1kaWkXpieNempWcbsqh0lfOW0eyZ1+R9
	D3ECUjIuzhQvGAChNtaDxSWrS65Ejqs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755032249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0MdgtvTf0GppffJVf7+x8IwG9neJu2jI9si12zBjn6Y=;
	b=QrgpPL/qrvsuB4GaiK8HAJITRaODm0P72aZEcF2XC+/ZfuvfWOLBz8cULNJLQsGxpmLIwT
	APU4gtxS+S3qfgOK7VXbGa5bL26Q61+HobIo1U26FoZ9N4DxkIetYvvN3nOnW48Zl1go3Q
	lWYewYRzltIUClJVO+Ztl1NmWspnHng=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-NInAMoM0M8GyadZ_ICXwww-1; Tue, 12 Aug 2025 16:57:28 -0400
X-MC-Unique: NInAMoM0M8GyadZ_ICXwww-1
X-Mimecast-MFC-AGG-ID: NInAMoM0M8GyadZ_ICXwww_1755032247
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45526e19f43so19842235e9.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755032247; x=1755637047;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0MdgtvTf0GppffJVf7+x8IwG9neJu2jI9si12zBjn6Y=;
        b=hXnIU25tvft+XOKiFNMYOLcjIl6FBRwqEGR3f+T7iS83YNGVKL6BCEII1FZocwqytU
         6v9ZAO86X1fiBTlAfj4r4hkuN22cQ63VJSitjjZKspYSTWLgpryIO9d7GXfxL4XSEATP
         4OtAKd6Uf0uAZZ96pTE2N8snmTFFgtMMIUfE5X+amFb1cr6lbUdknYAMNxjPQeyydl7u
         EMiWo46JG5q6n5mt0CMcl3hJHRIg5NS23d9mTcA1LdbAiaTOH4G9WUJBYYEDXpY8h0/c
         b6I4fNyfG+dLBT5gufyW0Ajo6S54L+lkwraN75CKbi/DY+Vh0EqT02yjwtf/kxWq3F8u
         FEsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWV/otmCtyTBBmkaIHO1mJvBlEN5iHEkE0fHfJF8+kkMy/l+m9cGIvH5rycbboeYOHn1twXorMFWw==@kvack.org
X-Gm-Message-State: AOJu0Yyu5hvxND2Nr7dPzYZkvUXPV+PH7M4PNVwVWWwoCNHUUeJ3gFm7
	b5mFnhtI1FFL6izPIX1Fd94AJHJJPqdJYhv5/2Yg30nSGRHKTO9D2U5rY6rCgpvy5CM9if57Gzu
	QswuUim+/HrIAh7AD39D6e6pxwNvhHaCFw7YVQ7wmp7ah1VAX+mY4
X-Gm-Gg: ASbGncvZLpD+3ZeGVpl6K5Tr5J07YsfpH/hJOOYfNF2XLH368Ewd/sehPNnxMMSp3Gd
	v2nh732+evalWe6TbBoTMHAMVpcKnbkKPdzYgoeluUyawkBACyyhSdZerpAcS0AceDnBMWIzOWc
	JOjWEK/Jx37ISmsv18ZHK7Je8VxwhjwPwFg54CziIN3KQyllwJ30p8qEvMlmgdrj0GqgA5q2h+4
	9iyUEiqkuIMatEZI53XPMLwqg1xjAuQw9i/4PXyfu6Cx75ctyL1XALrr3ImPtLgYDuy/hXUPuxY
	8YDdIuEVX66GjEREqF/V5fsbMjSTRv2DsNtwxz9wteoUPBIilbrfWq/LfrEpu/ZAh6fR13OUfQC
	Dq4K3RhurXZXlZHxVJXgxDXm25dDdU44yOODrXm3jV3bfWmtnE1jiwabjmR2i1q9crRc=
X-Received: by 2002:a05:600c:1c92:b0:43d:9d5:474d with SMTP id 5b1f17b1804b1-45a165051e5mr5065365e9.0.1755032246876;
        Tue, 12 Aug 2025 13:57:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFswYwIbgttuhXqb8QMDI1keoza2GfmCEcOaefby30ent32meTCCjqsOciMD6knuT2QlVpEA==
X-Received: by 2002:a05:600c:1c92:b0:43d:9d5:474d with SMTP id 5b1f17b1804b1-45a165051e5mr5065245e9.0.1755032246477;
        Tue, 12 Aug 2025 13:57:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:cb00:c425:8b4b:d9ad:eee0? (p200300d82f30cb00c4258b4bd9adeee0.dip0.t-ipconnect.de. [2003:d8:2f30:cb00:c425:8b4b:d9ad:eee0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a16de5f27sm1701335e9.13.2025.08.12.13.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 13:57:19 -0700 (PDT)
Message-ID: <522f31cc-f250-4883-8832-0d26ebf5210b@redhat.com>
Date: Tue, 12 Aug 2025 22:57:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 101/118] arch/powerpc/mm/ptdump/shared.c:70:1:
 error: use of 'pgtable_level' with tag type that does not match previous
 declaration
From: David Hildenbrand <david@redhat.com>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202508130304.5FJqRz2c-lkp@intel.com>
 <0c96fa0e-6f7e-4cca-8d57-f3e3786d44fa@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <0c96fa0e-6f7e-4cca-8d57-f3e3786d44fa@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: djhSsi5lygkkmTdLt-3_ZCxhRR_UZwDpZXCwgI2l14s_1755032247
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wtcbm9k4bw19dace7hkxdhsqu8bqj58h
X-Rspam-User: 
X-Rspamd-Queue-Id: 27414100003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755032249-565674
X-HE-Meta: U2FsdGVkX19lorx3+PFug7k+T7Y1CIM5oUbwKGqobgVQl3nTmKJiE8mmrPIukkRWLkhoAYVmJHN8Wxpo/puEsA0BTO1SfoOEl+sR/dDEEdLxd1P/+PZJqvKaXsX2Ri8EtCU7qVjHTagKAxdqSuCXUVkGTZghK0lUylelnN0/2wpcYiGAjFCHcPj4EJ6y4zdy+0g0CsOEQFMEhFYALXyxBRXS4pUhFCXnQKYkDi3X7XqYTxtkmgDXUInM499O7wkMp4Yp40vAXi3hexnqqvuCi4vKOGMp5o/lcn5Ph+uZgBKUAiiZwnqSS5nQcUxNY2bwvQfq5aWNo1Y2D0VZ9YeY/jGGOeATDQ6l80wucJStM+o07z9065cT0fpQ6LLeIPguNOENBOi/zdlv4/ma/6Kus6TM8SZVadajouMB1oIE3QdwkWBiysKPuaPgS5c2nEFnCQ9+wKOFqiQbHYS5V6LCYxLie2Mw07CeqzZq8SLFvRvihUopWUayTBjkcagZjBm8psnAON5phNgqlIsMX7m8pci4VeDr+gA1yhx08TuyBo7QvgQrk9nyRKDLTAGRKRL8CNpNmdkVHx5FsXlK0Q2g3iwxdLLlEAaLWHkRr4sehkthnbA7+CfV0FqYzEGs+WgGKBjaeUUusxgiUkDEaAh7mIhsxeuL7YRiX0RqY0CWLOOiGR+KgCvCurI3nriBgHoUZoSjHZokwlydZwCy4B7C64rH4SiTbjovWfVeGhVO6jNCxpXTlGLlEDLbpZitXWjOmDoATpK8IPEtyDxOlDPc3SQ7iGKNLqkJq0M8v6krB8XEG6rLvf8tr0/MA0c0EmsqEJU4xr7438FKyHQjU8DaRIzA6/4reGfEtOGbiSKWEc27f+M7oRGHjVTcY8KFvjAp36/PVb6/dqW52HWPWe2Yzr09gYWwfI36YZG323Hnu2pFqODGPxZzIysNUXUdtx1BGt7GGVjOe/lQSbTX0ia
 CSLUfB6N
 J0YfCEnfB/AWMc2XBknFKqfUKY+Gl3782aI7Py8YJg5TjPuiDECL4x6duwS00/m5JSVqi6e8aMNH/MCsmDAemOFJAgdNUIr2szVt/EseRaxRllYezZjItowPKCIbGeQ2oAagxVbvHaMH+kEedb72IknhSANqGfcGcshUtByGqNo4cYxlW/42PqC34MDG9grhtqGg7TeYfsf8r494p+HE4ZbsuFd42wnNSx7Ka+6c34w1gSbH4yv7ZiRg+d2mTtmNbAnGZ8Dg1be6sa3P53zmYpLLyDgjN9VE23dYAsoB7aT3t+Lz/qOR1t/lTTjiScUHzuy7US3iAVrGz9UAAq+bjUFiEMq7+puEZGJTxp3WdCL7yKODgUq/uw8UX/1w/oPitIeZMbf5QhR2YsAXWR/tG9UE3I3Ke5+VpQIOIPH+bJuof3I+jb1QZmNX7GcI9tARQ6UnnL5DKHJfxW/SBBSqnO6qgUrKHvq/S67N0v7vNCebk3G/DzLekWf9+duSPNCIZYsSAA0BNWfOUHjdNCGpBgEz2/eDyzO3JlEnStPhs+sANIs1VU1ML2ujUdmVrBemXo2PqD/4fEAgu/YlXxOR4NLi81TcjM/eoqzYZEOLbZ1evx7mSCsXupgmp9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 22:50, David Hildenbrand wrote:
> On 12.08.25 21:18, kernel test robot wrote:
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
>> head:   33ad02f876604ac2990e510480b0ab3a03cf892e
>> commit: 627bf62489a6d9a45f6d6f83edd0cb6c0ee610c0 [101/118] mm/rmap: convert "enum rmap_level" to "enum pgtable_level"
>> config: powerpc-randconfig-001-20250812 (https://download.01.org/0day-ci/archive/20250813/202508130304.5FJqRz2c-lkp@intel.com/config)
>> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250813/202508130304.5FJqRz2c-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202508130304.5FJqRz2c-lkp@intel.com/
>>
>> All errors (new ones prefixed by >>):
>>
>>      In file included from arch/powerpc/mm/ptdump/shared.c:10:
>>      arch/powerpc/mm/ptdump/ptdump.h:14:1: error: use of 'pgtable_level' with tag type that does not match previous declaration
>>         14 | struct pgtable_level {
>>            | ^
>>      include/linux/pgtable.h:1961:6: note: previous use is here
>>       1961 | enum pgtable_level {
>>            |      ^
>>      In file included from arch/powerpc/mm/ptdump/shared.c:10:
>>      arch/powerpc/mm/ptdump/ptdump.h:20:8: error: use of 'pgtable_level' with tag type that does not match previous declaration
>>         20 | extern struct pgtable_level pg_level[5];
>>            |        ^
>>      include/linux/pgtable.h:1961:6: note: previous use is here
>>       1961 | enum pgtable_level {
>>            |      ^
>>>> arch/powerpc/mm/ptdump/shared.c:70:1: error: use of 'pgtable_level' with tag type that does not match previous declaration
>>         70 | struct pgtable_level pg_level[5] = {
>>            | ^
>>      include/linux/pgtable.h:1961:6: note: previous use is here
>>       1961 | enum pgtable_level {
>>            |      ^
>>      3 errors generated.
> 
> Huh, I cross compiled this on a bunch of ppc configs, but maybe not emough.
> 
> No, on the branch I submitted that did not exist.
> 
> Probably due to the rebase.

Ehm, no, Andrew, could it be that you accidentally dropped the ppc patch 
from mm-new. I can spot all but that patch in there:

https://lkml.kernel.org/r/20250811112631.759341-7-david@redhat.com

-- 
Cheers,

David / dhildenb


