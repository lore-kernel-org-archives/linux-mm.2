Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0996FC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FED36B007B; Fri,  1 Aug 2025 10:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF076B0088; Fri,  1 Aug 2025 10:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575DB6B0092; Fri,  1 Aug 2025 10:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4487C6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:06:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9348C0244
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:06:27 +0000 (UTC)
X-FDA: 83728363614.28.1C5CD17
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6B79E80002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:06:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jRcnilCt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754057185; a=rsa-sha256;
	cv=none;
	b=gQA00uS5Y05D6nQzXU29bp4d+j9amowRwY6FG8jB/sGvFvK5Ru64Q2aArj7PxKZxagtFZj
	a5dj/z1uDa2ZvFTNyAU+CFN6Kc77YHhGDECnKUr+izxxWZM1AEs4XbjP9rnHXqM46CWYII
	pEz1ZDbwPAx+2TjjrRcnjEeIslCXY50=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jRcnilCt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754057185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldzxtItibaaD3BzZxT60cR6OJ4mUiDciQvmka0Ujt8M=;
	b=gUrPH72PMcRGq0NFxKnTn0H7mjM4g0oc0KBtC3cgzfGPDqx0xkIGBbXSBwKGiuZZ542Or8
	02uFjmLrHUmkEOAAitQTLuNWqzG7R1Klort3JsUYj+kmryGoaF4CU20c1h4w7/2Z/8xnsZ
	mha5dYflq9JLDXEXdM49vEMqTvVIfD8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754057184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ldzxtItibaaD3BzZxT60cR6OJ4mUiDciQvmka0Ujt8M=;
	b=jRcnilCtTjaeKT4TTmzo8oqa5/zu9Qbchdnca3/LyV24gtx+bNisUV4JIj+OA9xXfV0vLF
	dzFt3qqj9FuKHqWZn0oW/Ka5YYmETvY2CrV863PNYr0vrmyxbTXGYCVKUoZUUl5Y1eJEXe
	om4v6gdz7mSFtu9zDTew9btFTQN3OA8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-Bw2sikDeMEqcMpYgY0Fsqw-1; Fri, 01 Aug 2025 10:06:21 -0400
X-MC-Unique: Bw2sikDeMEqcMpYgY0Fsqw-1
X-Mimecast-MFC-AGG-ID: Bw2sikDeMEqcMpYgY0Fsqw_1754057180
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b7886bfc16so936612f8f.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 07:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754057180; x=1754661980;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ldzxtItibaaD3BzZxT60cR6OJ4mUiDciQvmka0Ujt8M=;
        b=cKjqDZZD9aZWo9x75OoMlom+EYOfht/HiJ25L8wQlgDHx2MIiw70rOXl2zj2C1+YC7
         8e4DZXwJ8rOJKUyLaQq1iivusJ5Plb/FDq/UdKoLD/zYWPAYMMZHNHd52rwPmtZw1TuN
         tbsTBzOEaiWkKAvdNEhV60dszL17kHn7jIj5lO/1UOytRu/y3SVVMZHxh+hVrAIih+qZ
         WZS2rWCcmbUYo8NUW+QbOZAI/iAAmHAVE+rexQLeoEuKB8gVBrIrcNrX0BO4Hsr0faSi
         //NkhFEdpIb3U4lgPioG0O8XVOngqPCaJMtLzgDWhMuNpJY1sL6XdzY+EOf+m2Gb8u9l
         xFDg==
X-Forwarded-Encrypted: i=1; AJvYcCUBzLrJQSIZfFHun5dTskskv5ADtm6tFJNGeNbjt5eJ805JGn9L6N0sE4hHh8sXdrSZlmSTKC7OCg==@kvack.org
X-Gm-Message-State: AOJu0YwiaTBJz0p8T7UuWOB2qjbzIqoxKtD8T3vnfmuKg0zwepxsCqQa
	H4NYB3P+ij2DSpwAqPrbGhhGww6YipTslubWASLLslHxTR0ScipjAgBYeiaH8LNJvMIXnp65ovF
	wWwqWOjNRdr+BwlGYnPzvkvp94pGO/RY+eCrwYawlJvmTeuORGu85
X-Gm-Gg: ASbGncvvMw9ALDaPrStCnphyL8FTdJOMHP4p2/METzzFh7/ghG/S1fW+Iyfnqi+wahq
	W+fdsaI9WH8zDbNTnKIUWM1vn8Coi+aaM6/ChAKKKYl9SDciBu9bzrSwL9VM0VS7bsXlQuxrIaI
	llmG3QsPOPPupS/MlSRVo58CpYfIjhoyhlsE7Ly/UuKSoGQvCAgcttXSYyAX6QTGapSp+oaB6et
	w5n/WTvcvqheOwUVB8q0MSyoMCnTZsipAqjGtcAzWHCYqYvuFrtZsz3Rw+3g7pNa8YrktqSY0jz
	GsAjbJk4whJkcAtMl3dqpcoYtuPQmc/jfSQb++jdjkXh2LtdrZ17+18NydQKgteaH+Cvw+CDN7x
	AF2aWEuJJaGQZrRVGTVwgC2sjR1E2bRIwkOSu99Rzl2y5rkAjf7PzALBBVAYVGhDG
X-Received: by 2002:a05:6000:2dc8:b0:3b8:d0bb:7541 with SMTP id ffacd0b85a97d-3b8d349a7e9mr2195268f8f.40.1754057180159;
        Fri, 01 Aug 2025 07:06:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiudoCNIOJ/WTT3yEgQw5mkZd2ditjk2uppwHc5ZcvTUPtZRu8ZwKQIKsy5lNLF9eVNAv2Ng==
X-Received: by 2002:a05:6000:2dc8:b0:3b8:d0bb:7541 with SMTP id ffacd0b85a97d-3b8d349a7e9mr2195021f8f.40.1754057176846;
        Fri, 01 Aug 2025 07:06:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9c7dsm5935495f8f.26.2025.08.01.07.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 07:06:15 -0700 (PDT)
Message-ID: <593b222e-1a62-475c-9502-76e128d3625d@redhat.com>
Date: Fri, 1 Aug 2025 16:06:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
 aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250630031958.1225651-1-sashal@kernel.org>
 <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com> <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com> <aItjffoR7molh3QF@lappy>
 <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com> <aIzAj9xUOPCsmZEG@lappy>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aIzAj9xUOPCsmZEG@lappy>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EBlZC8a8aKIsySTiVgwuPLjTO4p-Yg-nJyyxLAXQe0g_1754057180
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B79E80002
X-Stat-Signature: 8m4i5ub9dwsbqgx5qok64ma3b8oy9mko
X-Rspam-User: 
X-HE-Tag: 1754057185-509760
X-HE-Meta: U2FsdGVkX190X/bLDUXodimygPKGTdZyjEqCEwCY716NRWfJbPQmRZVQIPiYDiJtGsn0hmzwVlofm+Yo4eGeHy+9oPwtEtzqx4IEZhUgzlN9OXbSsr/6559sjgumIPXJj/eRWoIfzUD2sLMX9W859XttJBJAuFN4ssOonOCmOc+ruH8WXuhh5iFuvl44N3D6YjW18K4PhZM5XC/q08Pn5xNl5ycZEoo1x6yXphM22U0CNhMt6bOpoJLvI4uR06ZDShY0+l+CT25x7oVeZb0sbQc0kTNqxQYPQ7KQAVZwVLFr7ux1PatUoVPOr5VawqnKSZDYERuIyE0MumudHnupsBGTam7vgyCnDTzYX4zbB2DV720+edxkz5THqdAwqO0wjoy5kmSiiCbjZYHrLUqaGYbJs70Gz3rEonqGs0JW1MTCIel7RGl+/o48IOAqrgJUqaCZ5x521f6O30Z09F+rTC5W+zksbTSjCOeI6dPPPJMet6pNlmsETkLOWd67xILm5q8L4C0uCJgvKGLVVBsblsr1+6jtWP5bEYyUk/1P1sMPvimhKtvHR9zN6Hnsy3nsUR6l5oL1Bed/c2YXkP+yod8Za+QqXvC+ij3v0CnIxnFn8B/X86OkxGX9wa8i0hbrwY/jGIvAP6ypuRo3bsIK6Hr1Qvg4rcTDRAez4CjtTjGUniL3mSmPQ9mjrzSB/sit1cAkN9kLs2ZlJqMlyd/uvIYicB4pTFKkD2VbZsLyIpsx2T+UfLht2YOJdVFFeyyLQ8Y1r8fhnkCE4rTxCI+Ct1Q7m7wW/2ZGeHg+y3Qfw0/LE3YxhjPG9J08zWiVusW5cTk/ALfGoU4440M23iF2GhGVpjyApTRyj/nPCM+fECAkDaVJv8fEJBG74bKIBZnAjywIV0+TLL7gEssOpeOeCn0Up03D2yzxG3RDLYl8yfWVo7J2F3D9FGzm8rujXIlo53O2Ezz+8VJQSwgIE3E
 PgIa0WAq
 Cmpn4DIJMXLE1JFRVw+6ovmoe3zP/GUNZITXeq0ZHoxKRK4jO8upRxyr+jtMUHWEuHU+JeT7yqXlzMAjuQOKQqm2Bm2/Wd8w0ebv5S5FMvakcroATfP1z3fIj7weDeR0fJYcGeM0x7z+CCeZ14nl2029NrTrd0RpMMlIlHPN2okyzsqr5xm5MezOM0lSB+PvufcSOPtVulvox2o+T/d/tTn4BHEjzOdeAsQwRpC/xPEbkRfZIdMxsU5pZx0+j4hvB7iZR1JopUVBhwMkZRNGvIMel7Nivgw7EKHscH2+x/+4W0EkR3bJw6d5t3HR4aQ7pI7Z13rflJ5CQM2CGo+dbTFzcRrWRHtY/GTp23tsQp+MrUqswjmz3ZP076szw3f8vV5br8WLsRajM3sy8ip/tXT5Z7zdtEH6sS19eI3XUGEHMj4Y5WhFcX2bbx7WaTtlOomd6egtcfJ35NFgrwiSvNyDmYJIGH7ps9oOY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 15:26, Sasha Levin wrote:
> On Thu, Jul 31, 2025 at 02:56:25PM +0200, David Hildenbrand wrote:
>> On 31.07.25 14:37, Sasha Levin wrote:
>>> On Tue, Jul 08, 2025 at 05:42:16PM +0200, David Hildenbrand wrote:
>>>> On 08.07.25 17:33, Sasha Levin wrote:
>>>>> On Tue, Jul 08, 2025 at 05:10:44PM +0200, David Hildenbrand wrote:
>>>>>> On 01.07.25 02:57, Andrew Morton wrote:
>>>>>>> On Sun, 29 Jun 2025 23:19:58 -0400 Sasha Levin <sashal@kernel.org> wrote:
>>>>>>>
>>>>>>>> When handling non-swap entries in move_pages_pte(), the error handling
>>>>>>>> for entries that are NOT migration entries fails to unmap the page table
>>>>>>>> entries before jumping to the error handling label.
>>>>>>>>
>>>>>>>> This results in a kmap/kunmap imbalance which on CONFIG_HIGHPTE systems
>>>>>>>> triggers a WARNING in kunmap_local_indexed() because the kmap stack is
>>>>>>>> corrupted.
>>>>>>>>
>>>>>>>> Example call trace on ARM32 (CONFIG_HIGHPTE enabled):
>>>>>>>>    WARNING: CPU: 1 PID: 633 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>>>>>>>>    Call trace:
>>>>>>>>      kunmap_local_indexed from move_pages+0x964/0x19f4
>>>>>>>>      move_pages from userfaultfd_ioctl+0x129c/0x2144
>>>>>>>>      userfaultfd_ioctl from sys_ioctl+0x558/0xd24
>>>>>>>>
>>>>>>>> The issue was introduced with the UFFDIO_MOVE feature but became more
>>>>>>>> frequent with the addition of guard pages (commit 7c53dfbdb024 ("mm: add
>>>>>>>> PTE_MARKER_GUARD PTE marker")) which made the non-migration entry code
>>>>>>>> path more commonly executed during userfaultfd operations.
>>>>>>>>
>>>>>>>> Fix this by ensuring PTEs are properly unmapped in all non-swap entry
>>>>>>>> paths before jumping to the error handling label, not just for migration
>>>>>>>> entries.
>>>>>>>
>>>>>>> I don't get it.
>>>>>>>
>>>>>>>> --- a/mm/userfaultfd.c
>>>>>>>> +++ b/mm/userfaultfd.c
>>>>>>>> @@ -1384,14 +1384,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>>>>>>>>   		entry = pte_to_swp_entry(orig_src_pte);
>>>>>>>>   		if (non_swap_entry(entry)) {
>>>>>>>> +			pte_unmap(src_pte);
>>>>>>>> +			pte_unmap(dst_pte);
>>>>>>>> +			src_pte = dst_pte = NULL;
>>>>>>>>   			if (is_migration_entry(entry)) {
>>>>>>>> -				pte_unmap(src_pte);
>>>>>>>> -				pte_unmap(dst_pte);
>>>>>>>> -				src_pte = dst_pte = NULL;
>>>>>>>>   				migration_entry_wait(mm, src_pmd, src_addr);
>>>>>>>>   				err = -EAGAIN;
>>>>>>>> -			} else
>>>>>>>> +			} else {
>>>>>>>>   				err = -EFAULT;
>>>>>>>> +			}
>>>>>>>>   			goto out;
>>>>>>>
>>>>>>> where we have
>>>>>>>
>>>>>>> out:
>>>>>>> 	...
>>>>>>> 	if (dst_pte)
>>>>>>> 		pte_unmap(dst_pte);
>>>>>>> 	if (src_pte)
>>>>>>> 		pte_unmap(src_pte);
>>>>>>
>>>>>> AI slop?
>>>>>
>>>>> Nah, this one is sadly all me :(
>>>>
>>>> Haha, sorry :P
>>>
>>> So as I was getting nowhere with this, I asked AI to help me :)
>>>
>>> If you're not interested in reading LLM generated code, feel free to
>>> stop reading now...
>>>
>>> After it went over the logs, and a few prompts to point it the right
>>> way, it ended up generating a patch (below) that made sense, and fixed
>>> the warning that LKFT was being able to trigger.
>>>
>>> If anyone who's more familiar with the code than me (and the AI) agrees
>>> with the patch and ways to throw their Reviewed-by, I'll send out the
>>> patch.
>>
>> Seems to check out for me. In particular, out pte_unmap() everywhere
>> else in that function (and mremap.c:move_ptes) are ordered properly.
>>
>> Even if it would not fix the issue, it would be a cleanup :)
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
> 
> David, I ended up LLM generating a .cocci script to detect this type of
> issues, and it ended up detecting a similar issue in
> arch/loongarch/mm/init.c.

Does loongarch have these kmap_local restrictions?

> 
> Would you be open to reviewing both the .cocci script as well as the
> loongarch fix?

Sure, if it's prechecked by you no problem.

-- 
Cheers,

David / dhildenb


