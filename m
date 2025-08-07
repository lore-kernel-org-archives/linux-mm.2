Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56968C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA2A8E0005; Thu,  7 Aug 2025 15:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A8C8E0001; Thu,  7 Aug 2025 15:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89A68E0005; Thu,  7 Aug 2025 15:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9D258E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:42:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E77F13786B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:42:55 +0000 (UTC)
X-FDA: 83750984310.08.C2F0183
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id F2EA61C000E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:42:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXQy9TOq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754595773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LaDDgMqq/ecpftpql7G8nbETipKVAUsT3I+eSzopR4=;
	b=ZpV2wdwvdWQjkH85x7oq36zpgDmxR579S5sll3e6YZlShBoBUDYXCLZNNIFitZgO8rZ23h
	aNOxKPIQWb7ouXC+dbqXUZuyp+GH6KHfEWDf+3Mum9vmSFx/yqFXAD8xheCq+UZDjPHRSb
	2Cq8TllpfuutVXh3liwNJNOFTENoQO4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754595773; a=rsa-sha256;
	cv=none;
	b=DaM7M6z72Bd/lh4ZnUz+6JWNH/lnBouCK6efd1WxMho47rU9XOQdaVHKsgPLo9gEl5i3Q0
	cTdMqfXQaKuv1W9OZ4eLLpyEheX22pdx/hlTToXO77ivjrMECUDi5/vXfEB8rWPIYyUoBF
	tjts1+bcvZA/tXjU1MWswR+ApyZLYQc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXQy9TOq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754595772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3LaDDgMqq/ecpftpql7G8nbETipKVAUsT3I+eSzopR4=;
	b=PXQy9TOqDAOEEleHTaa8BRpu7dC7hJhTXrz9Z6epJzx8RYc6tz9lyjji2b+pvXzqxkRPvv
	WzRGzQaCzAhKTz7TW9bgqx+NqtkaRes8SpyYH3swbdv4vUSObU2PRoVuIYmxvUnc0mdJwC
	IEuP7MiRsMRCUbq3KQKJ+l7cbe7EpeQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-D9rbPm2OPB2ZwyGXc5fYWQ-1; Thu, 07 Aug 2025 15:42:51 -0400
X-MC-Unique: D9rbPm2OPB2ZwyGXc5fYWQ-1
X-Mimecast-MFC-AGG-ID: D9rbPm2OPB2ZwyGXc5fYWQ_1754595770
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d30992bcso12120355e9.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 12:42:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754595770; x=1755200570;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3LaDDgMqq/ecpftpql7G8nbETipKVAUsT3I+eSzopR4=;
        b=vfS8BqcMJJGDumWVR0sofwe+utkmXFBWYj/0Bw4yE04ZUvxFgfaB7u2RKyGbqFlS23
         8Fic1m6Kgc7azj2EBWQwvg2YfBo1bfcopKyiVROdgC0oJrCzE/fRBw3X+6dBfJKSxjj6
         Jj6PggIvGgqOA4Sfc2Cp0rnHic2Ij5d7BonhMo0myxCqePBYgI9p3y3akQnkk5BIhYUx
         HjRHSg6ZkxbkcXe78D2ZajDJ9YQVHi1/1ae++uKCzPccKKHdl8v2buYzBkfq08gVzqs2
         a9xHXEQbbEUGyQamjiY5cP/TFTGu/hC3MadYQbgrrE3vIQSzUQ5ODBe/K7YSc/fWCfLh
         dyHw==
X-Forwarded-Encrypted: i=1; AJvYcCUEFN7KGOiWnCqzEeIoqD6lKIRsoALl8xa+s+FKKQid/C4zah92j2Uxhen8K/dLrhNwURfGNKy9SA==@kvack.org
X-Gm-Message-State: AOJu0Ywk7oJnRbkg+ujCtj0YV55Zcp4P6/Oy6jWfzi56+7ax8Qiv8d3S
	M62GPU0a95uaaZhn4U72pUvuo23HXWbtQ13iO036ApktOcUgpGXd5cZ+805aH5pN6l567TNjUVo
	JPacHPDPCn2epGyNiKrJ934vI458FJ9BSWVQc+SNJk9JCDyqncxXp
X-Gm-Gg: ASbGnctR6/TYsHkT5AbIAJFttioUniKfTLyw66Oqt2GOmTWV0cSIz/eIH6kVUgVVX0F
	SspX09RBhZ/u8PRTZhasWUVFaZ8pZOfZ+lgQwrltU32PEUvG/8bbzPmhos0uByN37arTODkxi5b
	OfIFAoPs5mXNoFXDqBtP+4PkWx7+jA4Xtno57IhStoKky/P91Muu9cSlxGzaLXYMz59TGqBLAjd
	KQ0+g+LtpOgdvKLyR62iLcw3sHELt54XYQOkCDgh76hhlcWuFTNyFLDusmyxPkrCmKE06xhku9X
	nVwFNuK6bgoJRYT9xjUBV3mDlmy5TRN3cfCcdv7x5EtUbgz7oG0FhKbLNLYdR3PnEQ3laVl7Xkg
	MWWOGWnCPAOpYKMxB1OZgZSAS1LHXmxBpX8IgglGUxTIxqxd9K1l9uV9JlDqQ3As+GXk=
X-Received: by 2002:a05:600c:1c0f:b0:456:19be:5cc with SMTP id 5b1f17b1804b1-459f4f51f9fmr1973335e9.14.1754595769790;
        Thu, 07 Aug 2025 12:42:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGo6/clDb9BEZnuq3BiNmIprNXnt5JJSKR4eR1BFzhC172fm2kELBr9Eg3I29jiJ/sow7TFFw==
X-Received: by 2002:a05:600c:1c0f:b0:456:19be:5cc with SMTP id 5b1f17b1804b1-459f4f51f9fmr1973095e9.14.1754595769330;
        Thu, 07 Aug 2025 12:42:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e587e154sm116116445e9.27.2025.08.07.12.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 12:42:48 -0700 (PDT)
Message-ID: <43f91e3e-84c5-4fd1-9b63-4e2cb28dab36@redhat.com>
Date: Thu, 7 Aug 2025 21:42:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] userfaultfd: fix a crash in UFFDIO_MOVE when PMD
 is a migration entry
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, aarcange@redhat.com,
 lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20250806220022.926763-1-surenb@google.com>
 <3eba855a-740c-4423-b2ed-24d622af29a5@redhat.com>
 <CAJuCfpExxYOtsWZo6r0FncA0TMeuhpe3SdhLbF+udtbqQ+B_Qg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAJuCfpExxYOtsWZo6r0FncA0TMeuhpe3SdhLbF+udtbqQ+B_Qg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _ADe1rJwQ9xqpR727LjzsO4LdVP5StXbtB-tVYw7ocU_1754595770
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iqy7xeuf95q91tb77zuy74wiu4ta7cga
X-Rspamd-Queue-Id: F2EA61C000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754595772-409639
X-HE-Meta: U2FsdGVkX18yX/vN496d+/lCI6O7/gnvO8WwjG4GO01OB0+PwW1OBc32JqmOHbAlZ3jk0bGcjuhlB09X8jwlmwe+dEQ4geqFoD5121GYhNx6nnpRVC0J8OvGjCjf/AcoOslYF+5fqXETVxc56y1+Dn2LJnG6QJ6AxtVxck0X6PgeBr2ufXRqxQJE3xiRVHJzqJhEJLBnFC3vG8kUpctGIV3SXw1SJlMWzkXnXncXZB/hCMd7JrtII+i8xtgWX1eLFTmQrG5QY+tqOOfwxIS+8HLNld4jDMLdB1z4BTV/rxK31BBh39eB/Y8ze58ns1AMdafx7GAzyVZ/UHGPgebFL3BrQ33tu7vy7u5b/djHhVEvflM1oZhLbTD4FEbonE4+K2FSEJhhg17SHP0kKgKGyU+GrNylgkN+Fs3qQxsXHN67fwRWAh31IYvcQglpLhBP95dRiUNyf+Y4nKoe76DQY1XpXi+fDiiJbcYRmPvRYIQd0xJmbR1cowFIyigdZOZVnDA+CAqmMKuGDJYQnEuBb2/1s8/z9ge+QRPtvKw+OYWFZK7jGdl/2G1p7ZNaEHJb8fTNvMGMWv/epS7uJhvkJBejPsfl1pQtbYPrMmxsPMKwdK9cvzbQb7uvivjSBDWnmwWh0DL+cDQSL2opwUGEUi+smqM8IbA9CM+wdAdEJID7bO1xybMfFzIyYPDb1bAEbQFP57zkcap5odVbUV2leBTnqSu7UhelTf6giH1xxgfm8LYNVWwOQUTxMpWIrGtMHe1fWrIAxHFUYlwEv04ej9CMicf70qNrUhii+mesw/vViLkr5aLcHbLciDpPgkar826EyySGr17MpRmpMch/2GnTjbn6TZ9CWwaNTmqlAZ/rZXQYbv84fMGpFqzE3vaD8yL0WmcntDiE2qTEJ5SkTXHP9ISWB3rMt8SUVvsRPDLMr1bg30/PZ2oTc3i8KUbcj6Xefyuc9wUkkqHLab0
 TzEw/JH6
 pIniGMCEdGlMAdNMR7NfgRKmKi/IwfnQRCeyt149i7rdP7YWX2m/OxPEJrt+ZrJYGbf96GBCjSjbDLPG/Apn75Ww6hEOZZySUW2EGLxInvwbkbi2FOZ1ycTXvELCJCcadRvWgvpp7IdaASEyGZh2tTauxkGwQH5TBR13kPWMwzwjW4Y7zQ2sk/xaKc1rvC2YasyuVAbBJ55wkOM3EXPH6S95ntuYn4DV8FOT3mUPwuXWTCB0i36LZ1Hgbk9yL67/Rp5TicR2Ar8OWd20sixS6jeI/tz4crwq5GvYSbVLlpB7xJigTgAY6Cw4kWPLigmbq9HVmRjxTdkFHmqwtvELxbye2BjhmCovRC4QG/iiBZkXHR/gjx3xyPkiwBosJjqTW/zS6kK67ls7c39VmfdcUnTC6Khejtul5R7V/N20mQ+JmmjUYjhBprTz5H5Cs7vU70N1lB5SqbH5Ohh87Ld9LA7Hxe7VuCwP3ytyz14iUXUCRDyXd5h4KW9lw50o3RXsJ3q69MIJdq/KR+aJwAcDQuWBLN5mCZVA1NUnAUSq6maF8HjdN65MjJveM8qTi4BKqJZOEE0gnFQ/VTZBwZwzzSGEcOJj/ISInLrt+X0R27Ip6t5b343znQD3Q+CLyQHR6IY42dUCUNs9pGJAIcJTa3PhG5FBf2GmC+nTsd2dhfr3TrihSCAwy+PEPuo6x9BYahIAaaMPk98Q0RrzAJtiFJwZUIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 17:27, Suren Baghdasaryan wrote:
> On Thu, Aug 7, 2025 at 3:31 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 07.08.25 00:00, Suren Baghdasaryan wrote:
>>> When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
>>> obtaining a folio and accessing it even though the entry is swp_entry_t.
>>> Add the missing check and let split_huge_pmd() handle migration entries.
>>>
>>> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
>>> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
>>> Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>> Reviewed-by: Peter Xu <peterx@redhat.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>> Changes since v3 [1]
>>> - Updated the title and changelog, per Peter Xu
>>> - Added Reviewed-by: per Peter Xu
>>>
>>> [1] https://lore.kernel.org/all/20250806154015.769024-1-surenb@google.com/
>>>
>>>    mm/userfaultfd.c | 17 ++++++++++-------
>>>    1 file changed, 10 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>>> index 5431c9dd7fd7..116481606be8 100644
>>> --- a/mm/userfaultfd.c
>>> +++ b/mm/userfaultfd.c
>>> @@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>>>                        /* Check if we can move the pmd without splitting it. */
>>>                        if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
>>>                            !pmd_none(dst_pmdval)) {
>>> -                             struct folio *folio = pmd_folio(*src_pmd);
>>> -
>>> -                             if (!folio || (!is_huge_zero_folio(folio) &&
>>> -                                            !PageAnonExclusive(&folio->page))) {
>>> -                                     spin_unlock(ptl);
>>> -                                     err = -EBUSY;
>>> -                                     break;
>>> +                             /* Can be a migration entry */
>>> +                             if (pmd_present(*src_pmd)) {
>>> +                                     struct folio *folio = pmd_folio(*src_pmd);
>>> +
>>> +                                     if (!folio
>>
>>
>> How could you get !folio here? That only makes sense when calling
>> vm_normal_folio_pmd(), no?
> 
> Yes, I think you are right, this check is not needed. I can fold it
> into this fix or post a separate cleanup patch. I'm guessing a
> separate patch would be better?

I think you can just post a fixup inline here and ask Andrew to squash 
it. He will shout if he wants a completely new version :)

-- 
Cheers,

David / dhildenb


