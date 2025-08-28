Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B6A5CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B716B000C; Thu, 28 Aug 2025 03:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661F46B008A; Thu, 28 Aug 2025 03:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E1F6B008C; Thu, 28 Aug 2025 03:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 474856B000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:57:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBA50140A43
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:57:33 +0000 (UTC)
X-FDA: 83825411586.03.B002FF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 483EA18000A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:57:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bv9KJvgL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756367851; a=rsa-sha256;
	cv=none;
	b=6RH9h+ybs1TSnRkNkHsXUtGEmmo2dkIJIuXkj5IL7iy4VMMYj/0kV4ix2IueF7FAvPSFeg
	ubIdYzMAqEdUkU7+7IrWL58DLZCpf6quipUl3GxUDN0jAv7xGTuY/EocgDhro57UC5Vtew
	icbMXV59g2t8jwHxzo6fWWfuyc6A9Ho=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bv9KJvgL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756367851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbZY19kla5JanDLGwXleiL+Lbzg8wDPMzsYjknbeE08=;
	b=KGkWL+Hfga9K4id2TPb9dTo/nioIZ4IsEQPSsjfhKPlsxhA7IcheLK8EC1ZZZ+ikI5y9YN
	Rfe/u83s8vgR+hcGUzN4AYpy8IMBA/nD10aQLczs9fF6m+NmMYQes398y5Y+rjhxxEr9qu
	yd5K41ILjx/bGYNfcLSWdHqqcmphg/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756367850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UbZY19kla5JanDLGwXleiL+Lbzg8wDPMzsYjknbeE08=;
	b=bv9KJvgLYHEXRQN9Rn9P1fbYdMgelYJev2QuiBo1lUYjyxwoLQgYXKZ4yz/i9p29EMJCmc
	u6b+urrobkURrkoeNRdtDroyJ0jiQy9PL3SiOarQT5S3NLKYwjVscZLH2zs/IL1/cFENfY
	a22iloi3LZoxLzSpNN+12/ZsJqdxaU8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-TB0RisL4OWyrIFsW8VQ1JA-1; Thu, 28 Aug 2025 03:57:28 -0400
X-MC-Unique: TB0RisL4OWyrIFsW8VQ1JA-1
X-Mimecast-MFC-AGG-ID: TB0RisL4OWyrIFsW8VQ1JA_1756367848
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ce65accfc7so161893f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756367848; x=1756972648;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UbZY19kla5JanDLGwXleiL+Lbzg8wDPMzsYjknbeE08=;
        b=LfPQAv6U1zkF5IUj/k7mI8XgR96AT7jG/C2JGWB601A3ybQJhMXj8/m9xmUmp/m9fK
         9oAPrQGDZr8Gct2Z83ZtITL0ByHo3ESHjortDiRqoLbFGHF1GCbIzIwKmuc9sNniEwru
         BiSLUMOHhcXxVsXlX5j/s4G+LfubTRF6ZEuonTkgIKYkZwQJoiu4r3G4I/lBBjy+UBrF
         ZYWIq7bmGAsc//tXcjpchYYe9UN8Hpxkn82IC7eTMd8QkbYAcDvHJrvrngsiYDf/pJdH
         LrBM/u5TriIQch+NXRkWwu/nOo7zOz+89/whR7Qaan+3v1HoyDzNwUGhrPw2RJNZW4i3
         1/RA==
X-Forwarded-Encrypted: i=1; AJvYcCUJP+WToDPjLMtwBiIoLQNqChHdPi/pK83bHhuYOr6o5l0NTP9H5EwW8+oVdADrP+nEICeyOizsjA==@kvack.org
X-Gm-Message-State: AOJu0YxRy+xt28Jhkfb61nwP6jfGeEINa6M21jKBipLJPIB1z6KCJhzk
	0djUaDCaBjtp1+tlnmT7Aer/ovoCCdq+1AyzVIBKdq7MKbTeQ1gwk3Cr9T9py2ho0K9/LffYqrV
	pFL0TvO3oDO+t/4l4NLbDggbu2COwFxzpZH6nN1yg6P2gpsbYfis5
X-Gm-Gg: ASbGncunyVUPRuxmJxtCjdkr94LcQF+mpEWQK0cwtlSJ8MSnZvIwWsdm5SXXCCb0pRI
	xPQzfMMJ+4s/ko5KbLQtMZxXVAaD6s6sQpHoDArujTEV6EiV7FiMoBLSMBV9M3D2HbXa7s8UwaM
	x/BNm8ARTHWLvbggk1pOfdOtDhLAkVYwFR36LOZyxvsH22Qx2PHSRFl6Pg5AVe/pG641CAmNNRb
	flD8KXQuDTp13OVZyDiO2VgQ65/5qegpRV0N19jFPQfKKhkWFihlo4aiAed7kaMDSaBP+Pj2+K8
	WAUJ68b8nIg0Kd7P3PKkKjO5bw2QXy36JCrFcpQZjvtYYD0EMQ9JaA8FMgVAfZK3Uh7Mx2mLC/I
	Zr28cEXErUJDWm9i2IB+WoleVSgYHT+thvjvyZCYW/qAPim3ufpy6YiFvdBxVFBsPjmI=
X-Received: by 2002:a05:6000:3105:b0:3ca:43ce:8a68 with SMTP id ffacd0b85a97d-3ca43ce8e89mr8320275f8f.47.1756367847620;
        Thu, 28 Aug 2025 00:57:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIHY+n/N124O87jCHNAlrsZyduC64z8czEg/qHAbsVW1ouYN3MmeY/U08JPQi5BlvdXgr69Q==
X-Received: by 2002:a05:6000:3105:b0:3ca:43ce:8a68 with SMTP id ffacd0b85a97d-3ca43ce8e89mr8320243f8f.47.1756367847112;
        Thu, 28 Aug 2025 00:57:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c9c9324dc9sm14969370f8f.3.2025.08.28.00.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 00:57:26 -0700 (PDT)
Message-ID: <d048aac6-7b70-44b7-9e92-7277bd49b182@redhat.com>
Date: Thu, 28 Aug 2025 09:57:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] huge_mm.h: disallow is_huge_zero_folio(NULL)
To: Andrew Morton <akpm@linux-foundation.org>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
 <20250827150330.280399-1-max.kellermann@ionos.com>
 <20250827165309.44e465ff214e45f1a6665b24@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250827165309.44e465ff214e45f1a6665b24@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6Q858cgxCj7JbVdYICfuQCz4aQZS7ukqS9Cz_5hIEeo_1756367848
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 483EA18000A
X-Stat-Signature: mksztb8bu85sd3s3wdgbr3uuq94n4ozj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756367851-476079
X-HE-Meta: U2FsdGVkX1+l7F3Ng7d6hmgjmoKD4PgyM03S3nauuTlnwdo+Nxyf1kE8gLpV23YxMrp+YUFwbOESmLNEPGYnwRifXPMvynu0Hdi4GD+3HR/ej6XsZcrJedv1NFixDDL1Sl62IjG19vd4UkY6sV/LVTGb/eDcGr3lB6y/duMv6NW0gMg7+vj+MbyFoQ7wfS+pMcGyfQJPRnxGoOTvPKR3vT4S4EbxWeOwJPUr7oRmEHIULW/BKPoTV6LslsaK8HM3u++e62OUDpYUx4q0ut30MveZWLy8dsrz5ozUZWZtzJmpTsRji3J5W4QC26l1nxKiG6P1QuEHXbtSdRjoq+o53V8wCrFKmyiZtDCaaxFgfIh0ZmqP4ZZK2/v25hPN8N7vQ743SLSVl574xwVoPBugb95+Q0KE0zcL0Wj/87nPSNrdlUCJunBA9RobDGR0ExKMhWejt7diJy9mgq+bgQXUjV1e/f7zkBOrBst6LBgOjHcuoMjK+ibnwGC/iNx/ZJ200NEpWdHpI3zDvw2eGxxVdD9lVc5sI/FPGJCrsF+D2VpJEAnFAutLQSNDsoUPvGaEZtD9yiCegLMtIKUJnZqf36U4smgx06GETbAMX29mIJt6Cjgt64BncYUUUHXzX7cPEpljbgnhAw1jKWYTGr7P86v9+rerdU3TD+aqOr67YlEfDzJVD8GmksTMUO8aw8xc3BQ2npoOycGpjK6W9s+GxAuY7EJ9eXIqIpwwYdvz6VUTbiK3mDa6snZAKSdPwerXKBFuE3+9IHxn/yTpJ6n0Q+bN0N55XFE3J2nhoJbx0yRElRtBA0ILIIeKSCx0jaLAsp0IUILeqWCQEZ18RNxqTRhSDNLpBRY/S6EmtsSyfEbiHt4xlUtIGpFAtgTp9saiYJ2gRq49Eo2sEVvn8UwNdNAWUegbXGeT/GwEUWyhubGR4enAgSJtZKt4OdubPOGsh8UfLggbAMR5Cu8c0Ir
 F5+/fa8D
 xi7keMyDcfk5QD0G6XfeWN4BU7Rmb6FAUF5Wcpm9uetvMtLcCPgEkdaJlFw2mt3zmmMabWhXkPd3IiLTSSI47zQ1Sp7zBkaKXGQHY875BzyPuVsTno4LdEKi3O77Th0GXm7ThdHr1UKnyz5c2+61mnogfYAyG2L1MGe7EDX7Dl7LQCDYjWuE1FWlpQcrNkqx4W/JXFy6ZAAVzw2oJUFKodRhdusI5xEp0ea+mn4qF8BUWUV5l5sDB25WbPMB8lPiW+i7Mt5fFP93+lJVQn+puaLagAb4kedOSjiuziaYKkzIhhNCe+7/iUCZCoFqiDCayV0E22MNpvLCzj2VPA+szzl8+6wubJpnJvG4w5zdANK53f85o85xpSfoHjYNH3+YiIdVLA4lcTZS2syS+5iDx4Y+YqUCH/DBxbv+8SEICbYjKCsbFHvxv5OnaZ5pXympzJYCrzgVw8fiVLlDfeTU0s4JlNaBH6+hsE8A4ZmUEzOtSs6RV8ZLSap1jm+Gs2MWViPkgBWZdvmG4qP+o2miACh13h0eaaaCk3y6oPSnCe59mWXQf2Mq/GB3Mh9RDkN3u+urM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 01:53, Andrew Morton wrote:
> On Wed, 27 Aug 2025 17:03:30 +0200 Max Kellermann <max.kellermann@ionos.com> wrote:
> 
>> Calling is_huge_zero_folio(NULL) should not be legal - it makes no
>> sense, and a different (theoretical) implementation may dereference
>> the pointer.  But currently, lacking any explicit documentation, this
>> call is possible.
>>
>> But if somebody really passes NULL, the function should not return
>> true - this isn't the huge zero folio after all!  However, if the
>> `huge_zero_folio` hasn't been allocated yet, it's NULL, and
>> is_huge_zero_folio(NULL) just happens to return true, which is a lie.
>>
>> This weird side effect prevented me from reproducing a kernel crash
>> that occurred when the elements of a folio_batch were NULL - since
>> folios_put_refs() skips huge zero folios, this sometimes causes a
>> crash, but sometimes does not.  For debugging, it is better to reveal
>> such bugs reliably and not hide them behind random preconditions like
>> "has the huge zero folio already been created?"
>>
>> To improve detection of such bugs, David Hildenbrand suggested adding
>> a VM_WARN_ON_ONCE().
>>
>> ...
>>
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -2,6 +2,7 @@
>>   #ifndef _LINUX_HUGE_MM_H
>>   #define _LINUX_HUGE_MM_H
>>   
>> +#include <linux/mmdebug.h> // for VM_WARN_ON_ONCE()
>>   #include <linux/mm_types.h>
>>   
>>   #include <linux/fs.h> /* only for vma_is_dax() */
>> @@ -479,6 +480,8 @@ extern unsigned long huge_zero_pfn;
>>   
>>   static inline bool is_huge_zero_folio(const struct folio *folio)
>>   {
>> +	VM_WARN_ON_ONCE(folio == NULL);
>> +
>>   	return READ_ONCE(huge_zero_folio) == folio;
>>   }
> 
> OK, but it remains the case that we have seen code which calls
> is_huge_zero_folio() prior to the initialization of huge_zero_folio.
> 
> Is this a bug?  I think so.  Should we be checking for recurrences of
> this bug?

As answered elsewhere, this is perfectly fine as the huge zero folio is 
allocated on demand only (and only once enabled).

> 
> 
> Also, sigh.  I do dislike seeing VM_WARN_ON_ONCE() in an inline
> function - heaven knows how much bloat that adds.  Defconfig
> mm/huge_memory.o (which has three calls) grows by 80 bytes so I guess
> that's livable with.

Common practice to use VM_WARN_ON_ONCE() and friend in inline functions. 
Just look at page-flags.h.

If someone complains about kernel image size with CONFIG_DEBUG_VM, they 
shopuld reevaluate life choices. :)

-- 
Cheers

David / dhildenb


