Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99656C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6126B0092; Fri, 25 Jul 2025 14:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D076B0093; Fri, 25 Jul 2025 14:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1938B6B0095; Fri, 25 Jul 2025 14:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08C496B0092
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:10:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79832133F57
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:10:19 +0000 (UTC)
X-FDA: 83703576558.27.7A17134
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0FFED140011
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:10:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gD+fsDzb;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753467017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fg031g3unP7fXQlD5lCc+gWPnpWQUj0uihyKmlvazOw=;
	b=k2wL1AdPgFEZRokTIyvCG/j/XiwfGWPyxthCaxC/Dacg1qWXUKrK5BhTMVcc3OR5k63eAv
	1UhdnCbEMAr3q/2AGrR7kJJj/LQUikqnldMpRhtzKOoIDsWsLWDpKebM+fM2BPIzccsbIU
	1Wr9I1HZ+hIwRTqVUzw4WDRlQw8Krv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753467017; a=rsa-sha256;
	cv=none;
	b=37UhAaZ7Zbm66RSl9Zr4MSFlJGRGgQA5f6FhtNvwXPGCxxCk9pFWnguSSeaPsA7sZeTAB4
	s72kFMKcA+v2kakyj2lDqhncZUTk5yBWcXymudNhG/aVF1jetNBKdB35RiHCJxACSnoOJR
	vwvV1F09UYz30ZXFOuZ0JgiMSd16pmE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gD+fsDzb;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753467016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Fg031g3unP7fXQlD5lCc+gWPnpWQUj0uihyKmlvazOw=;
	b=gD+fsDzbk5TfLnK7iJ29MRLGY/jF1CZb4zodVrMxOX0jhso5LEYltWjOFJjLF5NDtcW24H
	XfdrWW+x2hmfLULwnzr9KXKo0H75SN3rVeGGPrafbQcLZXmK4Mm1iPHhdZ2X76FjhiXeXo
	ENRJERPYV6RDbb/JqZw7fidd+MVmPQI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-68l0xUiQMMmsTWko1quoig-1; Fri, 25 Jul 2025 14:10:14 -0400
X-MC-Unique: 68l0xUiQMMmsTWko1quoig-1
X-Mimecast-MFC-AGG-ID: 68l0xUiQMMmsTWko1quoig_1753467013
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b5f97cb8fbso1071136f8f.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753467013; x=1754071813;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Fg031g3unP7fXQlD5lCc+gWPnpWQUj0uihyKmlvazOw=;
        b=wT0/crQWYnjx+nYlCpgzI5lkvcgoPacGfRiTER/hP4aZ96XUhJvRKsHz083EGwLbWm
         OXQy3oINa5MdV1HCN82A9wxbH/uqNpGs64WBWBIM8Vh6TRX37K5KcGhjLjs0w2nBA5l0
         NTPYmkbVhaIxlm6jb35pUHUHiPoYFFdXarspBNXyOtiHiQOBlnR66MzGsmCgXJZwdie1
         Gxvc2juteThL/69XFMoalb0yICypVFG7Z2mMXtzOT9XmdQ9/PMsTiuO8sQEzThWm7dZ9
         DBZFS1I1FmSULJk6MA03eqC0Zgs0c51ZSOyhWqJR8RlBFKbQAlLbyOGl/2fu/srz/gqv
         MQ3Q==
X-Forwarded-Encrypted: i=1; AJvYcCV8v/SDK+aFZA2GIsmDcQq98nR5PIZXIpGKSZaf1u52ibEAzcu1i8NpqBdhG5ajuV2ZcW6K4jQ4EA==@kvack.org
X-Gm-Message-State: AOJu0YxyLUL64fkYQSdpnzj+jbVidptfLg26N1mN5qmVJqedQbuybG2D
	fW2YCVmfbo/vYRIhOKgkQpuZ8mwe2uubZIwK+KJoQIaozo/7luskbEouDzTLuVyljfBNZR0B7BZ
	85ji6J24L2MWR7pFHxLVr2tkuTjH1fnDRoL+UuXNkTRktfOHrTmXw
X-Gm-Gg: ASbGncurlPHGps59m+3ZIlOhMKnSC6eU4XPAeZVsL6mCxxe6G3LumVJzhPcwUUHM/3W
	vL0mNMbovx9c68NuVYeV0NQ7JrS8rH4dZBHGYjAp6ECoIOI+Ch/1DqFAnODFAewADBBIvBXav6R
	pLarzbl6VE1WPtm72ST/o92huHSAMRdEnzfrlkDekvBrwH9t21KvCwMcgWaG/xx0/pT7KqsJTVX
	ytYw2EiHX1SSsfhcVCyQP9ZcI/n54GIzTUpWCDuD9RC6UDCVdbeZgVrjA9oe5QcI+9s3K+fB57+
	Fc7SZJlOkEEhJnr2JtVPDyvqNdIX14B59ACtfGX0xY0OH1+VxY0zZRkpH1Vl/y/sbKQMg0xW/o7
	J9N84AvqMwnvYWYuap678gOM8+ytwTRFTqWUY06vwSVgf1DGd7SV93HOOUkI0i6KN
X-Received: by 2002:a05:6000:1a87:b0:3a0:b84d:60cc with SMTP id ffacd0b85a97d-3b7765e691fmr2731917f8f.2.1753467013201;
        Fri, 25 Jul 2025 11:10:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9we9KMsIFAxiMfOlhltS2ypJTdPdaz4UjcyKgj2aegsDd95Nh1ypDaK5ex+xC87RDOsB0fA==
X-Received: by 2002:a05:6000:1a87:b0:3a0:b84d:60cc with SMTP id ffacd0b85a97d-3b7765e691fmr2731899f8f.2.1753467012729;
        Fri, 25 Jul 2025 11:10:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f36:e800:2f2e:cb5:13f6:f884? (p200300d82f36e8002f2e0cb513f6f884.dip0.t-ipconnect.de. [2003:d8:2f36:e800:2f2e:cb5:13f6:f884])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778eb9bc7sm528611f8f.22.2025.07.25.11.10.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 11:10:12 -0700 (PDT)
Message-ID: <f860d082-384d-4230-bb1c-09206c7daf72@redhat.com>
Date: Fri, 25 Jul 2025 20:10:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] mm/mseal: simplify and rename VMA gap check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
 <CABi2SkVeHWt+SKWWodXUNhXZi1Wv9YazEOGWEUJLvgPbopqBrA@mail.gmail.com>
 <ca6af6bc-1c5b-47fc-a00b-11d46867b5e7@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <ca6af6bc-1c5b-47fc-a00b-11d46867b5e7@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LB2z7tQaxcw-Ea8w6FkdrtktBN4OsXjju5X7FfvbZs4_1753467013
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0FFED140011
X-Stat-Signature: cxduqq64wfay888cuqtcgjij5f4imwp7
X-Rspam-User: 
X-HE-Tag: 1753467016-452872
X-HE-Meta: U2FsdGVkX19OLGwndfqRWC9O1K7JBpVD14F/wRKvN++IHk3GGDlhyXIa3uEuEAD1a8Bl5hRgqP+bp+K2UNSgiLyVOOfvZatn0aIkM+z3VCPYBXM5/Nl438Smt8LQqGpSqIh6Vc8zq9IHmbT051U+iDJEPr2GZLPwaupjjnMlyYawXUPGyChSaTlNZMOR5zQi8GsWQloJ8JaVRAd2vQrd42vuMlCjj/IioTPbFZoVNiqzERc+/XJ37BZJVRh2c/1WEew/MtLgtFsMxIjlW6xgbrUlxPuDxPQaxiBIFv5euCw4Xn3wR4eZKoVcw5beIb8NVxXdcx0a3T4TXC7j2y+zLiRH+ksnTXb4JVcnunF1kJSg1N/UFG2JcJY0kOi1ET5PkTvhK36VVZxG+/iBXmZS5EUw4/5YefsM7LQTPDiIfw7yQ/pxI3UT0zbU4eLTSc+a6McTSt1djX2cxvT7XBqnxICl/POXzyNlBdf9r+jKeqtQaw4kIfFd7GzUtjPRnipjg8N97ytt3vXGhxt5Y8/EaWDIHsxj/FwA9LPjYboMXY5i4LjmtNeK56BWs8HFElA+wwiMkbfXjkgV/klXQJecktbvbAQXnxhAi4isxA19/1a4U1g1ASqjI0NUoAqv1vvTIXCJ1ovp+tDHPn3tSNkmLJipUOJ6F43bDcIt8Gz/ukYZYJf5pgyejjd1RpuqqEeIZRjdWohsGwgsxa+3Ae7/uFJn3hiOxa1stNCpazCtEBo2iPTj+btHzPEDtyXzZb25xtTwpLlCWT3DH98LhwTd93W3vVt8Jp+itaqYesvO8BJYImaeDiViN+4ojy1xd4FJ3DkvpgqOpFlaix5xo4iq81g8bRbPT73Ur3Wo94w6SaTWZ8ufqioAXO+MyDzJ+rfYOdcZHRt6HvScFXnmI/c3Q7s+X05yPI4eM2YlwzlNcI/r/YqUOrb7ld8fmT8d28Utj8Gbs3wnaI/QR8yvmmT
 63Q+i8eY
 MsDYt3WSl3+GbnXb9bwW6luIgIHpGzOeDvqJwQtvzaC8IF0wsWxcS49yCXKQKE8gBvT0CpGelhs+9uQ4D1pHe+CIcO4902Tk+pnKVyWbjNijF7Q9ttfRX7k8ViL0afbZM4Oa7ZwHpdJfoZnAe+JdMlvR0QiB1oPv+j2LoWKy50VyTKYOvlK6oAMXO1IEs/qPvChzGiiNJ+s04MRV9Flf1x4xJdqs6m5SNWBCetBs8wBO8YyW3YBK+UO0AB7UhP35GOizcD5N97KhjsrHK8MJ7buBezMlYM3iI0AjNcxzslH4fHEQGaVYJaWlcoVnISvnxbgFciGZpWSLebiwvjqv1n1ooUSlEziciK7KnsjLEovn16V9Zb/sadzAxJNQT6/i+0SFcx0VOQblYJSGq/l7Cz7WJXdYB2rNpRG4V9Xa37ya9nDKbCijZ7bXzA3Tdop5OK+2f3s59dzmcVBrNKKAsEO8wiYpU3lMWIHkDUsLTgbhGpMW8hrac9gfK6QBEGP5M7VtD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 19:43, Lorenzo Stoakes wrote:
> On Fri, Jul 25, 2025 at 10:30:08AM -0700, Jeff Xu wrote:
>> Hi Lorenzo,
>>
>> On Fri, Jul 25, 2025 at 1:30 AM Lorenzo Stoakes
>> <lorenzo.stoakes@oracle.com> wrote:
>>>
>>> The check_mm_seal() function is doing something general - checking whether
>>> a range contains only VMAs (or rather that it does NOT contain any
>>> unmapped regions).
>>>
>>> So rename this function to range_contains_unmapped().
>>>
>> Thanks for keeping the comments.
> 
> You're welcome.
> 
>>
>> In the prior version of this patch, I requested that we keep the
>> check_mm_seal()  and its comments. And this version keeps the comments
>> but removes the check_mm_seal() name.
> 
> I didn't catch that being your request.
> 
>>
>> As I said, check_mm_seal() with its comments is a contract for
>> entry-check for mseal().  My understanding is that you are going to
>> move range_contains_unmapped() to vma.c. When that happens, mseal()
>> will lose this entry-check contract.
> 
> This is just bizarre.
> 
> Code doesn't stop working if you put it in another function.
> 
> And you're now reviewing me for stuff I haven't done? :P
> 
>>
>> Contact is a great way to hide implementation details. Could you
>> please keep check_mm_seal() in mseal.c and create
>> range_contains_unmapped() in vma.c. Then you can refactor as needed.
> 
> Wait what?

do_mseal() calls range_contains_unmapped(), so I don't see the problem.

We could add a comment above the range_contains_unmapped(), call stating 
*why* we do that, which is much more relevant than some check_XXX function.

/*
  * mseal() is documented to reject ranges that contain unmapped ranges
  * (VMA holes): we can only seal VMAs, so nothing would stop mmap() etc.
  * from succeeding on these unmapped ranged later, and we would not
  * actually be sealing the requested range.
  */

Something like that.

-- 
Cheers,

David / dhildenb


