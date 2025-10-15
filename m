Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A96CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8068E000E; Wed, 15 Oct 2025 05:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97BF8E0002; Wed, 15 Oct 2025 05:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FF08E000E; Wed, 15 Oct 2025 05:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF1B8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:54:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31229140C03
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:54:39 +0000 (UTC)
X-FDA: 83999889078.26.1BBD001
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8DFB7180006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:54:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J7ZIvwuk;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760522076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2KdYxHG0TxlDaXr5RfM9jCoLmVCgPnJrMdA3K9nJOw=;
	b=n8Tu675nIg+dVj3THbI5P4q6TdIgn85lNyvLELvnaLbw3x0IsbNHeGrT/517wCxOEBgzPJ
	Bfztvc8BnJY9YTpJ79G91AmJNGzOu18WiyEsM4q+0ppHN2SMqm6Ew2SDOzuRxDdy164NjW
	3iLdvUKbS0aq1S5QLU0ms7CUtgyufUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760522076; a=rsa-sha256;
	cv=none;
	b=h0+oYEnnc/yp57QjIgVBsfF1jKAufTiDd7JLXedpfv7DijdqcdiC2oSU8xBlglIgXJEMj6
	QvnAL+ouklMdj4DAoS6uFc/DFrWs4SFgqlE8tEFsEfcOBfm5FCbu5IaRdAXtNttvt5Jsv3
	7HfqFZEX7Zh94J5hxwK+RCSplZCOVOI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J7ZIvwuk;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760522075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R2KdYxHG0TxlDaXr5RfM9jCoLmVCgPnJrMdA3K9nJOw=;
	b=J7ZIvwuk+OjJWir1SZohfS8J5XSqNZTZK+eHy+5oZHpRmMlNJWQK0/1ZEWl7n4U4hyAiOU
	AQZIixgKm0s7pbtYDxCQTMI+u7DOekC93Z3RO6Tu7CRRZnQRBUS8F4sxOxS/hru6By21sR
	TKOqb3Dq/HNTcxQOky37JRJnw8Nufo4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-j92n-t2WNrm6aXcXbIxRGw-1; Wed, 15 Oct 2025 05:54:34 -0400
X-MC-Unique: j92n-t2WNrm6aXcXbIxRGw-1
X-Mimecast-MFC-AGG-ID: j92n-t2WNrm6aXcXbIxRGw_1760522074
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8574e8993cbso1306082585a.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760522074; x=1761126874;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R2KdYxHG0TxlDaXr5RfM9jCoLmVCgPnJrMdA3K9nJOw=;
        b=ftZDA8wgKXp+8goo4N+zB4XtEpv+ZsU/oiyE6KyyiYqvnMf9vo4QQ7WjIWjSEGZEYs
         eq3U0dUBV026pafDkMkUaACY7277keiWEJmxIQAwJzyUi9FdXUN0qvpYn3wFpfKsxo/2
         Nn0iMI5TaqXhJz/TPQPSJ/2A8QdoBUeTSpkdExjMTiB/6nDBo98K3TNCn+BeZuBJkBQp
         B6M5Lk/KydYImpFSC4hTuzN6LU81eoSIUbAUxkSIcurWOYA/sgJgXsDb4erfOH3M8qCE
         +EJF/lSCqEAGQxO98nkQSHZJNPODUvabQJTb1fdCX8HNPv/NJ+JLLRbIGLDjAzaGA812
         Nb6w==
X-Forwarded-Encrypted: i=1; AJvYcCWyBEhz6S6suOLSrui747o/YqXh64cq7qH65dsItJ64JiPMwlYFKlEEA/F7DM7370cZByd4KsQsPg==@kvack.org
X-Gm-Message-State: AOJu0YywCst2ULjaxBGsaaJDVJYd0OrrySxy2+vNF8DbAJtN/z2yXJAl
	ZDCfSweGvIswSau3me9IQ13z0ZACIm0WTJ+wQ1uahgdWh0uvHeOBZThoidprHYeRXptOFsjrtLK
	3sb5eneURdzd2HTk/pFS439/lw1gn1sMnPZjoe8rhab2jgou7AADn
X-Gm-Gg: ASbGncvIGcV0IUiHW3WQmAuYZgbMkB/W7W/ykf/hsilAUuUs57ywUxseQD/kyzlOHQ7
	BFBzL1GuWsmz1KNRRkPwrmTDAz9EJ6iZ+5VV071AFp9WzPtXxB3OuPAsRNiWx61BINyz0IBLgIM
	1GIveMlvrJiyWaacYh0JhNzq5K5KBYSV6+1kdOWZjCnniINf8nzlLKHjr2xMGcikqbONKcyHWQq
	1QfpPrBsybTtXfwOSal/hUqb1VkvocoeehsQ4+IcxpUVLiYXiG1SPuoNnmkHe7lv60Xl//7dmgz
	wTBglHiCoicfSoUlmfXW1gxIBLn18R+6qg26A4GtjM27KwpucKzfJyNNIjgOIqw=
X-Received: by 2002:a05:620a:2544:b0:85d:ddc6:e602 with SMTP id af79cd13be357-883544f1ff6mr3601367785a.1.1760522074153;
        Wed, 15 Oct 2025 02:54:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAQVcs4j6bVCbW2fMIXnMO4HdNFGycHdYnpyKtRtCL9j5BrNVvHXfCSk1Pida0rEBihGdhzw==
X-Received: by 2002:a05:620a:2544:b0:85d:ddc6:e602 with SMTP id af79cd13be357-883544f1ff6mr3601365985a.1.1760522073720;
        Wed, 15 Oct 2025 02:54:33 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a1ca3f2esm1352520085a.41.2025.10.15.02.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 02:54:33 -0700 (PDT)
Message-ID: <77fe5471-ed9a-4448-8a0c-75e41729bec4@redhat.com>
Date: Wed, 15 Oct 2025 11:54:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: huge_memory: use folio_skip_prot_numa() for
 pmd folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>, Dev Jain <dev.jain@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Liam.Howlett@oracle.com,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
 <20251014113349.2618158-4-wangkefeng.wang@huawei.com>
 <1c020f8f-4722-45e4-af1f-ee3d4a67068b@arm.com>
 <92490858-fa4c-49dd-bb3b-2820c794a8dd@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <92490858-fa4c-49dd-bb3b-2820c794a8dd@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WXcdY3y2gMTiDCdMXEFMXrAyLej0pM24zBKE9KuvkZw_1760522074
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 547xpijkyontmaeafi5qch39gdz6da7g
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DFB7180006
X-HE-Tag: 1760522076-513424
X-HE-Meta: U2FsdGVkX191KbeB0okV9L7942LXrrerqNnUqHw1amgKbUwAZvmsdwy5HePujnICU2fEd5ssC1AK6f7XGfKpX845p0rbW6UaQ2C1lqmPETzQyXjVr8hgXFgL5caW6uOjzV5zippEuoEH3aI4KuaJ5OZjMkycIzK0OfwY3QJ86JHNaKmbyKyArF79JBxSZJmKDNlVimOFC9mkmRUmCCPuoq0yOCfUa4/Ya1te2pc4nfvU+QsH3nIc9dZUUV8nULpxPwIi5D0o3/S/MzSZnXKXRzC67eZt6LZMfSQi/tLl76MAqK3JXBAYkaa2qob8f4OpqNHTEXs3oy08g+2wnEyHDHPCcFv/ONHv/vNJ2t4vKQkMedldgLVWWXI2odhk81StsYp4radof5wy6qEFjNBwGc1LAUnqk0sYX7Wp3bMDXMJpCt7nMR72m3xYvVVNVpG1ZCXlq1hCbYZOrpUHHL8YouRfE+d/rrUS9pdAR/RKrgdru9ZZTHZxDBtqwHyotK9BASs6X/EfTIml/lzxhwjQSdLSzNxwbYErOXDSuy6bITI7lDUwpSQlhVfp3mVhCUYsi/YCeTLOKOT8Ds2ICeqwoHzMOwRiAJrpDOelkeZPIdBf7S8bNkCEALF1evxT8U6ABMj2iFOgdxGXyooAu5zujwbBeWpQcaCWc/IaTbiz+G1pXYR2RnWUZdGn9nHgITCS5u/o/2R0LRl0x2ga1++AvtygJhKLTJVk37OTlz7rTEm+KgK1l7TAi9txnqTamC7bZiW1aUe0QRqPRtd624wYzgYeNa/71lTIxqHgG9lRumJSg109+1x589s9pbYG44fQy5K4WhUaWqw4URGuwpLnPFZCw9E59Ojdl0G9aGjMJRJ+SH4Gk2oxVVMnoStSc0Em3Z8BwMcnK+AWier+AsSuyYpnuAsieiajHH6Zsf0m3O0dsJGZdqrbKw5eiIbUTKvHYbhanBgeIyivsTiF8fj
 zX1mbm8q
 sHpIQBkyTKPgBJ82jV+LkQagMIB0ku7sfsjZ87FRvOZQxG+aK+Q4sncREQRYVrbrcO1otKAyTZdhcDV4nbEHBsxAo6DlPSdQENH7tQJibqQguncfuzhc0xdb0iZ/KcOWPqYsB1HwpaKkVctYRBdgb8IdKHtLxkawTZEX/Tq9d5YciKRZxQFGvsNxz6HfFVbf3Qgg57kNDUlcJGdN34+dNg5cslKBU2smFmvQtgJQmX/01ytMcEi3/4a5AQjDila1xNCvNUa992EEEAb/YEmTnIA9ySUCeN2dCtoyzV4Uoa8NJMbrzTVsyNZKXLl1uC7sQng73p08Cm1HX19lFtzXsSW0nrFDl3A4pVYbvaWGIM1f43d4PkMMpUHLYHg/JnLTrXOC3rS7vtI6TCibTAPP53tqS76TYq14zvU3Osr7ny/YGK6zyGKQRziAQX1Re+5ALvlKQCLaJ8qhLH91YUm70tlqDsB9C3DBLTZx7mGbQsuvymwM6QeTWji0CglOMvljgKeg6KrvWTXZOuW19lWMY8UTJTxdRfMAkG28NgK/LOYM4+avJsFfq+zBKw6h6tCMtmb68fQ49Q6nVtXNC54MxeMvqpMnHsg8LvaBM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 11:21, Kefeng Wang wrote:
> 
> 
> On 2025/10/15 15:30, Dev Jain wrote:
>>
>> On 14/10/25 5:03 pm, Kefeng Wang wrote:
>>> Rename prot_numa_skip() to folio_skip_prot_numa(), and remove
>>> ret by directly return value instead of goto style.
>>>
>>> The folio skip checks for prot numa should be suitable for pmd
>>> folio too, which helps to avoid unnecessary pmd change and folio
>>> migration attempts.
>>>
>>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>
>> In the review of my mprotect pte batching series, reviewers had
>> noted that the branch "if (folio_use_access_time(folio))" in
>> folio_skip_prot_numa() did not belong there - it should be done
>> outside of the function. But I see that that would duplicate a line
>> now that this function has two users. So in light of that, would you
>> mind changing the name of this function to
>> folio_skip_or_process_prot_numa()?
>>
> 
> The name is a bit long, and it only update access_time not change the
> pte, so maybe we leave it as is?

Any such name might make the return value weird (which indicates whether 
to skip) I'm afraid.

We could invert the meaning and call it something like

	folio_apply_prot_numa()

And return whether we have to protect it.

Maybe that's better? Other naming suggestions welcome :)

-- 
Cheers

David / dhildenb


