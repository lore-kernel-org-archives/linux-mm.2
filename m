Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 173CDCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589D18E0010; Mon, 22 Sep 2025 05:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A468E0001; Mon, 22 Sep 2025 05:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402008E0010; Mon, 22 Sep 2025 05:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4378E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:07:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4B9A140569
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:07:50 +0000 (UTC)
X-FDA: 83916308700.03.0859976
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 81ECF140004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:07:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WW3cpoiK;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758532068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NOtnH2whuLZDinduQw3pf1FjbmgUtbHpHA6zFZgPMk=;
	b=a4vl1rIIAhTNorH1oDfIZB+d33aoWbFIfdnOeDFLbk3J08hnr3T+ie4Boneow5bdxQ95UC
	Je3WP2CC8z8pWG1Gjt2PHEuo1lTm4eUwnVrS+6/3dZfKnpLb4BJowIpdOOVemDRyxbo5p+
	EBl3vfefCCyRoOw2GEH2w53K2lfGxd8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WW3cpoiK;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758532068; a=rsa-sha256;
	cv=none;
	b=aK9DzUwwWwxpWjDTfckjRrwHyWZ4kTRmpZZcFqpFhqb5VutOBasI6Mn4dUxAizeFyB5qsL
	r8PFyKf8XQWs+IpPBUF2Mt/ntsIsmAnQOUCaOIFdTc2DQb9yVRFmThLtnz5PRkMhqn93ko
	vYXyig5Ea7BJda1dnLTyOZiI3e61TXU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758532067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0NOtnH2whuLZDinduQw3pf1FjbmgUtbHpHA6zFZgPMk=;
	b=WW3cpoiK+RtxtmvN20vYQQZ5AfxjPXJoPbRty23aHKKdB2Mr9MyP6E2OSm+JpUM8FQeE05
	EydU+09mtMsCw5hAKG4FvvLoZpqOfdyYU9/19Ascp/jtQfn/85nULPcB9fxRQF+TY3ViUy
	DRI9w/BqgJDvOtzrFMZFenuwnpzmMcg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-AIZCzgo5NSWviPB-XGTXtQ-1; Mon, 22 Sep 2025 05:07:46 -0400
X-MC-Unique: AIZCzgo5NSWviPB-XGTXtQ-1
X-Mimecast-MFC-AGG-ID: AIZCzgo5NSWviPB-XGTXtQ_1758532065
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f6b44ab789so501644f8f.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758532065; x=1759136865;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0NOtnH2whuLZDinduQw3pf1FjbmgUtbHpHA6zFZgPMk=;
        b=Tk2uRM8RK2IEqjniPScvSK2sQDlwc3VA5hA99cbJlh17489jUAbrQgrYd9rYwOW468
         otpQeiINFzF7p0D60EUhrI2aEZ1YjmSCORQ6mqZu/KE7fW5bmhmot1DhzEw5byatn7iV
         zqo4fg30GAo1/2j4QTreYJbnYMJMG7VdGp5yJ1imdwt0cQT3dE6Hb9/6KL18LDNhRGZO
         f98O49cHWQe5p6PLdb4IHFV6D4cZT5WEMdwk/YkCZpKqNGwtFs9MufgxKxnNUUPYp5Ih
         Z/kefUQryqKNY9da96rqqHNDCxGt53hudtqhYwxukNC8G8Y0Mw+F3M6NiEeu3bPMK7Aw
         kHuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLFTOyXoqhO/WUDaqtKaibSOBNv1zELlpi+zgGIHQJ6sSLhrNDhWtTR09pygLWPuVRnxkvY/ovLw==@kvack.org
X-Gm-Message-State: AOJu0Yw93M2mter28nLHkPaHwhaQNS7KLHlO3cOKZZdhj2wFsJqPJMDN
	+kTfJqknhxddkrmq1VXQMpksKpVl/yvTAN0Z1gbRPMU2afhDzw/stTzzhzlaipLgo2f9gMsmyHT
	YEPVpbocmzB/N2n2Uu+/cXungYnI/x57GfWjMSNGL+T+CN0pUOOUu
X-Gm-Gg: ASbGncsqjUhZpW6o99lefl+k3ij6+jngW8m8uoRks2PlHucXqioUoY7rX0VIqDQaDz2
	uipqPgn/JdtQwX8OZOSUh+f7R0QK+CUHkEbpy6IQbc38o3lU1bNhLlLpAGoWWFpP0ff8mpqNXtT
	/m3BhDxZd/BW+V7kOo9fOUw5BAAnguYW8rHq7RToFbhKQ0JCVxVbyZ/lyc0n9mYjrBAwZsiDrBD
	5NLCaP6UvQenZdkLXSbED+VyRNobQbNMlOyl+NatZLl67nqi5+07zCoVVySZ+CuBmRpFeTxK3Mq
	NfzEsG52vur8tiybP8/LLkQwifonm7rc95rytXjEPEbfurBFInzVs5GMoe1eRJd8H1FeaEUfEa3
	KqpG7cQZ+kQZzylBGgeqH3wIR12UD80GtKKDIstZkVb1yv8ZKdtOpDpYqUtp747c=
X-Received: by 2002:a05:6000:2408:b0:3ee:15b4:846c with SMTP id ffacd0b85a97d-3ee7f606f17mr10150616f8f.28.1758532065136;
        Mon, 22 Sep 2025 02:07:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxLy1+k/Z8ZBPOFKNkdzMmHPFMKaDOYnNPTTo4N8sJasZ3UWMs0VvX76FaPR5xY2doV0EVtw==
X-Received: by 2002:a05:6000:2408:b0:3ee:15b4:846c with SMTP id ffacd0b85a97d-3ee7f606f17mr10150593f8f.28.1758532064714;
        Mon, 22 Sep 2025 02:07:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f1549285c9sm12079390f8f.52.2025.09.22.02.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 02:07:44 -0700 (PDT)
Message-ID: <adab9c31-c281-4bf7-93ae-89ed9f303d7b@redhat.com>
Date: Mon, 22 Sep 2025 11:07:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: MAP_POPULATE on writable anonymous mappings marks pte
 dirty is necessarily?
To: Pedro Falcato <pfalcato@suse.de>, "wuyifeng (C)" <wuyifeng10@huawei.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org
References: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
 <oypwdcx6j726iffszfayd66xizaw5tfv2lnkk7bx7ibzn37x3m@ulkgb6x6geef>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <oypwdcx6j726iffszfayd66xizaw5tfv2lnkk7bx7ibzn37x3m@ulkgb6x6geef>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DT5w3Ft6oIOtq-XfGn4J2eDPAiCWFLRVeaUXAGSC8cY_1758532065
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 81ECF140004
X-Stat-Signature: d9qej5ra59z841ksp3wa4g6mypxdq1gw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758532068-228240
X-HE-Meta: U2FsdGVkX1/4KdnuK7YFBQms0rsYcrM06xgLAzelUlKQQZ1lWPv24HkbtUd/J0qCsHsFnmmYpSh3sBcno31bwIEYE58Zy0p4SfYDvDPtIeRkmmE49Z0HtkAgCBej1b0MeKHvAIoxeze85Qlz93QxC/XGMLgSzbKN4aosq8raCswP/RICfTQ0lNF4ZeOu0jdepbbqkU7qeoEYs2mwsCinWfRDcd36oMcrWGkWyv9oyR9oBqf5cTJyc2apTHcXv9qFys+tGy+o9RJMhgIH8jFFWbQNlE7rIbkNLLiKaOTF4NYvGm35lHlDf8CpJ/ZmEQwYd3UXmBRJRaLHRwPszo4rU+5aEu+/O+bumKWMNcqGbo6M7GlA8M9Hk9LZkrkUacKgAwkAmZcBXyZxnIYW564COMiYPB4mtgpn96tyGAQKeqKvUIp400AC9rmZhsOlZEGv4LwEro2g537QII1axUOl8LE+9O8+dOJdI9k0HvzXanQY00j31bMfxlF0J5QCW/tz3XSyCyl5viCW2TvzTWR+kQCKt+fRYRCpEZVuzEq+RgBX57jQ4NOyzGPkDE0B5Ie4wx+L1+TK2IdBrBJk+1t5zqXCTGscitCAnNkbqKOk9AKqEc8JFYsbZ81g73xIFT1xv5AvHnPw+7Z+u/KoVW3fIkYir7XZzASB2OyQ2l399dNjdklARTTOQCvFZ2zxMd4x2pYNS023nAxn9zX7cWu/1UQCCFxc9gzq1zDkXAAKZksRPnUWQ28REORvvmhtkr6SvdogmUlhG1TaeK2Fwr91vO68lSwEMXKPLnYKEn40EU7vwabx5ZoOrlpFzE+uVVkhFoL9oL8SYAghCZIVN967oXGUqmIMh6B/Xo7QBs+Qm8o6TOHtp/RWhV0WO65T/D+PYAUMrfkmrvg45n0tUvnabjtvV20lCTyfvH7/NKx2RLtHaNXo33lrQ+NdIeAugjHOXfoAft8B89SK8dFswmN
 KpWCILDG
 Mz6egXPbvlipIuSgP5Tdn/qW6RAub6KBr0brTFzXOacCdbRAxTyAxxYGgIOtKRhc7VodbWci5oI1tYsCmC9sg3Un4LWiPU2rQKWbHjrcHjaaMVDGg5uLWdcPzmlKAb87XsXNfcvD9SOGnwa7Ksr18NVIkApnohkVIdRGfbHnFEp3xCMm5yIu4xn1Zqc6VZIWu0Ai3swWp5xzZ1bKITi9rI1/OarwAOQV9+yYeJX/gXHzp18LMXszJBl3V0BOagpwGrwdVbM/e7gnWJtljQoLsfUgv+UOUbo6Di5EOkLaftFGL4R+1tlJW8SWvjpqCO4TmlvC28o8SnpJWR3iQVDpMDlhWAZ2uqZEF9yigrvLB2ke5E2fKXgHkmSZb52pRa3VVDrYir/HmI8Rq7BECdNYpDVUNaDkeXxAwCoNGysTxR9m+AB+JyJN1oa0+Khqktss9Iq4bJwVWHVYih2HWX3N3H2iXJxjNK1XNDtYa6Sn0v/KxkA8bIrNRvMImyOgQT3ezgBKx7ooGQsgGnxk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 10:45, Pedro Falcato wrote:
> On Mon, Sep 22, 2025 at 02:19:51PM +0800, wuyifeng (C) wrote:
>> Hi all, While reviewing the memory management code, I noticed a
>> potential inefficiency related to MAP_POPULATE used on writable
>> anonymous mappings.I verified the behavior on the mainline kernel
>> and wanted to share it for discussion.
>>
>> Test Environment:
>> Kernel version: 6.17.0-rc4-00083-gb9a10f876409
>> Architecture: aarch64
>>
>> Background:
>> For anonymous mappings with PROT_WRITE | PROT_READ, using MAP_POPULATE
>> is intended to pre-fault pages, so that subsequent accesses do not
>> trigger page faults. However,I observed that when MAP_POPULATE is used
>> on writable anonymous mappings, all pre-faulted pages are immediately
>> marked as dirty, even though the user program has not written to them.
>>
>> Minimal Reproduction:
>>
>> #define _GNU_SOURCE
>> #include <sys/mman.h>
>> #include <unistd.h>
>> #include <stdio.h>
>>
>> int main() {
>>      size_t len = 100*1024*1024; // 100MB
>>      void *p = mmap(NULL, len, PROT_READ | PROT_WRITE,
>>                     MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
>>      if (p == MAP_FAILED) {
>>          perror("mmap");
>>          return 1;
>>      }
>>      pause();
>>      return 0;
>> }
>>
>> Observed Output (/proc/<pid>/smaps):
>> ffff7a600000-ffff80a00000 rw-p 00000000 00:00 0
>> Size:             102400 kB
>> KernelPageSize:        4 kB
>> MMUPageSize:           4 kB
>> Rss:              102400 kB
>> Pss:              102400 kB
>> Pss_Dirty:        102400 kB
>> Shared_Clean:          0 kB
>> Shared_Dirty:          0 kB
>> Private_Clean:         0 kB
>> Private_Dirty:    102400 kB
>> Referenced:       102400 kB
>> Anonymous:        102400 kB
>> KSM:                   0 kB
>> LazyFree:              0 kB
>> AnonHugePages:    102400 kB
>> ShmemPmdMapped:        0 kB
>> FilePmdMapped:         0 kB
>> Shared_Hugetlb:        0 kB
>> Private_Hugetlb:       0 kB
>> Swap:                  0 kB
>> SwapPss:               0 kB
>> Locked:                0 kB
>> THPeligible:           1
>> VmFlags: rd wr mr mw me ac
>>
>> Code Path Analysis:
>> The behavior can be traced through the following kernel code path:
>> populate_vma_page_range() is invoked to pre-fault pages for the VMA.
>> Inside it:
>>
>> if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
>>          gup_flags |= FOLL_WRITE;
>>
>> This sets FOLL_WRITE for writable anonymous VMAs.
>>
>> Later, in faultin_page():
>>
>> if (*flags & FOLL_WRITE)
>>          fault_flags |= FAULT_FLAG_WRITE;
>>
>> This effectively marks the page fault as a write.
>> Finally, in do_anonymous_page():
>>
>> if (vma->vm_flags & VM_WRITE)
>>          entry = pte_mkwrite(pte_mkdirty(entry), vma);
>>
>> Here, the PTE is updated to writable and immediately marked dirty.
>> As a result, all pre-faulted pages are marked dirty, even though the
>> user program has not performed any writes.
>> For large anonymous mappings, this can trigger unnecessary swap-out
>> writebacks, generating avoidable I/O.
>>
>> Discussion:
>> Would it be possible to optimize this behavior: for example, by
>> populate pte as writable, but deferring the dirty bit until the user
>> actually writes to the page?
> 
> How would we know if the user wrote to the page, since we marked it writeable?

On access, either HW sets the dirty bit if it supports it, or we get 
another fault and set the dirty bit manually.

What happens on architectures where the HW doesn't support setting the 
dirty bit is that performing a pte_mkwrite() checks whether the pte is 
dirty. If it's not dirty the HW write bit will not be set and instead 
the next pte_mkdirty() will set the actual HW write bit.

See pte_mkwrite() handling in arch/sparc/include/asm/pgtable_64.h or 
arch/s390/include/asm/pgtable.h

Of course, setting the dirty bit either way on later access comes with a 
price.

-- 
Cheers

David / dhildenb


