Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B1BCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE718E00ED; Tue, 14 Oct 2025 07:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E0F8E000D; Tue, 14 Oct 2025 07:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537348E00ED; Tue, 14 Oct 2025 07:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C67A8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:39:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE5B7BBC38
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:39:52 +0000 (UTC)
X-FDA: 83996525424.27.1AAAD76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 771BC40004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:39:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=feguwORq;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdXdneu31LbdRvmhwPO/2myoQVJi4Hc4GAsvAWBfZWg=;
	b=j85+tlIlMOujxFRmU4tOOLYLKSwJ/UyyX/3h5r6tnGVJcrarlvD0lQ36LkDYqOi4N+I9Dq
	8QRXkaxWnMEs6HkKvz4NEgYvSLOZOH+NpmBahDdSn9omhCN60MWyiOXmI9ef27Y9rmtg7c
	41aHIhLnlNkKLT0kLUAg67mG5E/rhtc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=feguwORq;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760441990; a=rsa-sha256;
	cv=none;
	b=Iz/n2t8DyyDaGxE5i4Jb5iM2wluCGx4mNq1XIfiS1aVrwf/T+oJhrKwnSn/7nCxb3GO7pD
	76rZTgrvuVLxdlqVmsi0fxOJMaBTdAK03/zu0S7y6pZWJIoVNsrX30V+ALQokuamxlaFJa
	P9Y31fMNjxTYraFaLFS2zJSEjXuOZsE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760441989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sdXdneu31LbdRvmhwPO/2myoQVJi4Hc4GAsvAWBfZWg=;
	b=feguwORq/B5eyn+D48vEXaoVO00NvxEN7Pxb1YgHwkx1N8d9jqX74ujMqwa32mJ8oHbKhS
	0UeGN954mF7cCl1gebSLrr5HapwrSTL33cPppMnmuX1VzRA2OA5SSjS7A7y5MdE11HRKbO
	1D0az19UHG45xJeRUoJyKLXJvQIFeKw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-IMTMB2_8NZ-4a9DnWVOczA-1; Tue, 14 Oct 2025 07:39:48 -0400
X-MC-Unique: IMTMB2_8NZ-4a9DnWVOczA-1
X-Mimecast-MFC-AGG-ID: IMTMB2_8NZ-4a9DnWVOczA_1760441987
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e3a049abaso37730135e9.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760441987; x=1761046787;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sdXdneu31LbdRvmhwPO/2myoQVJi4Hc4GAsvAWBfZWg=;
        b=mlUEfVAJDk1AtlEmfdvjMNNYd8tRKRzOfoVQ6p6JOICbzS8kKjUxsSrcUBObku9Oda
         glnE20+7+W1ul+lr8+I+CL03HFD0PNfz+23vYtejbc6gwoqMLyDvU76KSeSB9pR+XGw7
         +Go2R9sXW0Nolcd1K9ZUZCa4JSc+2b9iUNjpZxw0QYLSmL6fDpGpOs4btcbD7GWA3jPW
         999vG4CI10QhiZlKuqjuZuBX0lPNUH+k6bSGx96PPUyT1HkEeAtInukBP8WY8g1zPuc+
         HDqsPdAPc7ZE9/VYGHrI0BRZOYFJHzyEY1W7hVdKZLGJtJPwvDKy7JisRGxqmaxwnIrl
         foEw==
X-Gm-Message-State: AOJu0YxbqYbCiHS1kn/7ypoxImnRsaTXBdFyCAlQHtz5x83QA8KQLZWy
	FaR0FWoRmR/FTMqN1blMX+0Lo1c5v7gOho/Gtzz7wjfyNpmSpqJ7VKnuc7rTNTsunJdueBNbeHW
	27s1XLLKYisfdEfH/XuwF8JWAcKst2L2Nh8+LZRWWQvtr4DWfTAiR
X-Gm-Gg: ASbGnctIkq4Hswc0wygvLan6jXdtkemlciqCFwrFBclfRcfNEBOyk/VwSaRrHKBI4gs
	L6dwWlp0JE0ZPnTG89r+kJBYV6UUwmxRPvwXABVWblYocQ54JT+qh6vyMZBvrxVnTuylnU7V6aX
	BCQQW6kYoQG1u9qQM94od5ULAXEgYNaLH3KYLkO+kffwi6GQHqBmOI/EGcrUbS5CZBguheXUlUy
	7hwntjBagWYUYB5nPEVdLOzTZUbAUKmzKVlJt6NSZGtNZ5ITm5Nzsa5c6+MbznJBsMm0jpJYop1
	2m1VAwu5LRdjbSIzwOx0Rq7QxUS7AH3t6YeUid646VZhkMctN2yoqM6KG3yvUW/BxW3HHzYXKA=
	=
X-Received: by 2002:a05:600c:1548:b0:46f:b42e:ed87 with SMTP id 5b1f17b1804b1-46fb42eee16mr110898325e9.40.1760441987451;
        Tue, 14 Oct 2025 04:39:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrjjz5kNQo6dpKCFwudJls7rWw/aMO9tywOBXrR9xbX7z+mJurnY9F4BUnivw7ejFkRxg0Eg==
X-Received: by 2002:a05:600c:1548:b0:46f:b42e:ed87 with SMTP id 5b1f17b1804b1-46fb42eee16mr110898145e9.40.1760441986997;
        Tue, 14 Oct 2025 04:39:46 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3d92c0sm150913425e9.3.2025.10.14.04.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 04:39:46 -0700 (PDT)
Message-ID: <8cf7cfd6-6766-41a5-a280-b07de5b20378@redhat.com>
Date: Tue, 14 Oct 2025 13:39:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] hugetlbfs: move lock assertions after early returns in
 huge_pmd_unshare()
To: Deepanshu Kartikey <kartikey406@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, broonie@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
References: <20251014113344.21194-1-kartikey406@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014113344.21194-1-kartikey406@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CDMU7bGOBPL2GPMpfEmlD7lpvTPrhohYU_WVyUoxYAM_1760441987
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 771BC40004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 64yp5p9dwu4nqxz7kufhrsjwcq6o8u37
X-HE-Tag: 1760441990-483398
X-HE-Meta: U2FsdGVkX1/E7kJQ7ZA0UTXgIBUuR0X6957LCUHK8E6LZcqLGfUAQ+gcK5d+Sg4xfz2WMGc1hxx1K1XV7Pt4I39DZH5DVV1OnFmI6YcJ+lUypF3hkSaJhXhpNhWTyeiwZ719YKjghYwYGRteddhO6+bBxSowfOcyftxRqikVBILNS9yvevSq5xrA5wyArF3ptD2qxHtT2Ae3pe5a1EonEJZsrGy3kmypP5hH3nnn7EQdNZRPEu0oyr2z2744QiXe1Tq/h982Xq/+naQFEdOIfbVGE7YO4ZsJdesSpjgMh/7+OnSYafI6GOKF3d7Z2I1e4GLHNn9Cg3iuo4oK4dO3KnIcy9NYL39kBwzcdIVSBs/Sw3IlpZLkD0muXSHisKa3maqy+LanhNaW6mBUemnPjCjM2tr0CDwqw/gLQg7RW5vCSNphsCM2nRIFgZ25v5ojubahS3ql/G4PkOhH5Qd/K83M0810pbs2w9T821RbWepDIEyDeU6Q/Eqo+YzpDDo3u2dlVqJ3CA2TYwIkYpyq3SlumuYM2wHAJNfuE31iV0uNc9TwI4S5dik6Ny5Ch7RAqT54OI8d/GeCXIGgigStr7xSxiKN+SiuiSWyQTNAyH9ot+D517S+thQS1Mk8L+OhmCrw8VUp0g8v77E0z4KYmEz7rpf2umRp+ESOetYEijbuFGV93/5FUsVRVRWyCzrxt720CF+xXxi+ZTqD+P8Tvps1biKiVdBXaAI4HDP8VC4s1z9tfGxYDbnhfc7a+Xo0ZlFnV9kPDBdnwH4fupmJhfDSkbenEG8BXAmMyxI+v3QhvY7op4Nrplop6PnY3G+bzk1LbLaHXZl+AfR9TRSp3YRp8CXswir1reinjYoGN90rer8plbbXyKEcu/y75UWwtkM6bfdY9Z7jP9HpxkuGiZXSoz51Km4teF3v/63CwcZsdgPP3sTaWTI+Nd84FaoMkp7y9odV1QZkXuOSM3i
 cLvJxpdw
 gpO3XMtf+xp574W8fL4yjF9gJCC8CQugs+KbWgn9ClSEHm2+RbwAccj7aXNbEoVzGAJJt1U4LP9T5yqqVVz9//Ge61/bmXaCGKUXznuNGFYjpWdbAEfCOabAvVietY+2iHxqD7UUc5OdCPMN5pDvXxuEMhLpMABoVVeimc+2j00dm1sQOEAbvfWC48dLWL7QU62gPcRXFB/fTSJoQKOPqgY2Fc8TnzNP56jpu8JYnXjskwyI+4ePdlpbsuTv6IDf5qaPq5qOszr8OWe8mMGAqH1F06fdU+Gmk8562mFdRyBmoi9lEBnCRcZeNk36EQCgv+xJPTHQIC+QhCCXWlAUI+Q+bTDELgTM7WBcDevp9WM5ij4aGE9i5s4yYHpN0YtcBKCfV+fyJxKLiXBkCyahpca1dI0zC7IaoKTxlXrUOPY02Zh++CyO5rQxuBVNqL6HsFEa3V0ZHp6Ec5cdgFxTOmGSQm3rN9sofofmMxaTHO3FWasq7fGEgBI7DCqv10Mm3wxXroX/MfcT0gNkkIXGgV0KnTRQp0+NMGWSpn8+AQXLo3Z7fhSCGERQosjVrlnnfktwnjkRU2CHVlXTc1F1CDQ4ws2AgfYxzR+0DyhDLznUO3fkB6AIQzU7O4EhJSPMUYL4oYRUd2halujzVMg/Ex5WdyNCPU86aelQTiWCvD/KEBQm5KPjdO9pTNwIdqgMcpuun5xPLhVFMxzcfIZOdpCYxufkLvO2Fy1zoqTo2isV8O3e5Xw/1A7LfqR2LnaeGcni8I9IaFQSdHq6ikKwqsKikqr65rTYqidOzKU8djzEymxg6zWqqT1K8zVP3hmmMlp7GpZV7FTUbcLCynrC6ktsDuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 13:33, Deepanshu Kartikey wrote:
> When hugetlb_vmdelete_list() processes VMAs during truncate operations,
> it may encounter VMAs where huge_pmd_unshare() is called without the
> required shareable lock. This triggers an assertion failure in
> hugetlb_vma_assert_locked().
> 
> The previous fix in commit dd83609b8898 ("hugetlbfs: skip VMAs without
> shareable locks in hugetlb_vmdelete_list") skipped entire VMAs without
> shareable locks to avoid the assertion. However, this prevented pages
> from being unmapped and freed, causing a regression in fallocate(PUNCH_HOLE)
> operations where pages were not freed immediately, as reported by Mark Brown.
> 
> Instead of checking locks in the caller or skipping VMAs, move the lock
> assertions in huge_pmd_unshare() to after the early return checks. The
> assertions are only needed when actual PMD unsharing work will be performed.
> If the function returns early because sz != PMD_SIZE or the PMD is not
> shared, no locks are required and assertions should not fire.
> 
> This approach reverts the VMA skipping logic from commit dd83609b8898
> ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
> while moving the assertions to avoid the assertion failure, keeping all the
> logic within huge_pmd_unshare() itself and allowing page unmapping and
> freeing to proceed for all VMAs.
> 
> Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Reported-by: Mark Brown <broonie@kernel.org>
> Closes: https://syzkaller.appspot.com/bug?extid=f26d7c75c26ec19790e7
> Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/mm-commits/20250925203504.7BE02C4CEF7@smtp.kernel.org/ [v1]
> Link: https://lore.kernel.org/mm-commits/20250928185232.BEDB6C4CEF0@smtp.kernel.org/ [v2]
> Link: https://lore.kernel.org/linux-mm/20251003174553.3078839-1-kartikey406@gmail.com/ [v3]
> Link: https://lore.kernel.org/linux-mm/20251008052759.469714-1-kartikey406@gmail.com/ [v4]
> Link: https://lore.kernel.org/linux-mm/CADhLXY72yEVDjXWfxBUXfXhNfb8MWqwJmcb1daEHmDeFW+DRGw@mail.gmail.com/ [v5]
> Link: https://lore.kernel.org/linux-mm/e6bb05f7-8f05-409f-9d87-2d25f66942a9@redhat.com/ [v6]
> Link: https://lore.kernel.org/linux-mm/CADhLXY4WPxzvzuiZPJmhS-9xMqRZ_qf7ZcFf5MXPgXbgB3_Xzg@mail.gmail.com/ [v7]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---


Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


