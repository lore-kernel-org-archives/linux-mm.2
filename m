Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF11FCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2738E01D7; Thu, 30 Oct 2025 10:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389F98E007D; Thu, 30 Oct 2025 10:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7418E01D7; Thu, 30 Oct 2025 10:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19F7D8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:55:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDC8D129FC3
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:55:05 +0000 (UTC)
X-FDA: 84055078170.24.E4FAC17
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 39A0DC0003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:55:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TZq4w9xk;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761836103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2W3chW7pcnMqJOQDxC26D0D4sbrWuL2m2Kca3x2i3PY=;
	b=Rqz8itJdBfYI2raPgy4moGf9bJIxJrv8BwJSICxgU/2rLVxd0U59VTea6Li1Iq33ORiU1T
	P05fkbCS+U5fRgopEG/32BZSvUp1TiUoPFSiDbOSG38y8ik4NITGvJlq9bm/8K83gw2TXn
	w1g8DUUfmfd2Tq/E/hTr7hgjpF9BQj0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761836103; a=rsa-sha256;
	cv=none;
	b=CHyugePq2KJ4Xj/jiwABsqUTWodaDbWCsY1GcO6xZP+GLEXThYETWv2xTDqHy8UbtgwioD
	NPNs0OeK5aQ6GYBYYemOpGIL3alVLQ4AZ2Ar1yF50GXa0hQjZoVX+y07gVWt3/NfkSrlmB
	1BwW47RIAZcefCCAkY/sol849vHsibU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TZq4w9xk;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761836102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2W3chW7pcnMqJOQDxC26D0D4sbrWuL2m2Kca3x2i3PY=;
	b=TZq4w9xkZotnmF93+HVh35jzDapTP1QU4ujsqxFlAJ03N9iC0mHr7Bw8HP86Jt6JBFCo8j
	mUcEdEwQ/+XzRO5k2R79WQWSF62NLVhL3syb4+9HbC6oJ96Boh9C/hpcRdxBBC3e469iWp
	F0LhVBRM16Mph1UgEk/0Ezp9rI1i5T8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-NSczQd8dMemCIEAyIZJYcg-1; Thu, 30 Oct 2025 10:55:00 -0400
X-MC-Unique: NSczQd8dMemCIEAyIZJYcg-1
X-Mimecast-MFC-AGG-ID: NSczQd8dMemCIEAyIZJYcg_1761836100
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4e88a5e70a7so36763911cf.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761836100; x=1762440900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2W3chW7pcnMqJOQDxC26D0D4sbrWuL2m2Kca3x2i3PY=;
        b=ETTwl5jGpHVWhfkRqUiQCvFFWBpAba3ofpqg+/OVAMxrFCJ7T/hCKjKj9ASwptEU79
         ZIP+uYCZ9jMkB/CcTJ7KPVET5L+t2JU2HZNmeT/D9I3S0RM/pt2miTZc9NPxVDXmbOnV
         iZM8xDzD7J97AOdmU/aTHWKcWP94rEmhEBQqgbresyx8UgSSXzsd/BQK+G0cSYUNaY3e
         ljk6/wjWjoSql+FAxlGmvJdDoRptOjEZNyAiMELZFetJ8rkUkk8y8YHG3hFCaTK5CQ0w
         sNLgp0+eKqdK15f5kCCmiKIJ6ckg8a3JLXv16nfXZj2/PilTujxGJeAiVZD606bWgq5P
         zIwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBcXSAA1vzEqCgWt6uY1x1BhLQytZTNh1TZYJak7lMm33QzNRjybqMotdAqMYIPFDJvFyVlDl/pA==@kvack.org
X-Gm-Message-State: AOJu0Yzw4pXXaytGjeFGhb2HnExiMiNKuIBgbPRE7nXy3oP8PuN0IXRp
	PL4AugtuzKXzAzW1AAl5IjtbouULQrRJIoSU3FGoQHtRug1PbOP3X008i/HV5YgLuseGyn/bpHe
	RdWA+6RBG4IHUR8OjOTedljjeKab3fvqhvKAW30sR0dZJAO45rBM4
X-Gm-Gg: ASbGncvKkRjYcoWwcZ/zn/gokRqySQMgV3kFTZ8y2sKe2yv36d1y8klt6/QgGOpbwyq
	cR7wsR5tFjdzol0Q3Ne7vsIlNUFPlpMY5lk4nYw1H4qN53U2vK1jIzjVJOewF2NtTbcNQuEQp1q
	LqLJTtxUmCASjJIjrnD1f7R/kjD/y4SDBuf+XKkpcvavSZse0Kh6f5F4ZDwvB7H6Xj8FyFQqhqp
	W+ethFEfaLbB0y8vPw1aIvTD5l6GCrO9GOh2X5zLMOnhFJUgdzoN3/qImdlHbV2VoIxs3YEIZ8+
	kr3zIlsylsbD36Bj7W61sD5tsv1i61zLjylW3Ssfv0iUFKXeovzBEqUTusPV7RFzF1FjZxtIkcl
	1VA==
X-Received: by 2002:a05:622a:155:b0:4eb:a094:9711 with SMTP id d75a77b69052e-4ed30329abbmr840321cf.29.1761836099656;
        Thu, 30 Oct 2025 07:54:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDZb2Jtln8mUUIX/hROLSOtY5G4JrM/X3Ba6JkpA3dXWxKYmihpqbJsP81IQR1GIA8Uox8Og==
X-Received: by 2002:a05:622a:155:b0:4eb:a094:9711 with SMTP id d75a77b69052e-4ed30329abbmr839911cf.29.1761836099092;
        Thu, 30 Oct 2025 07:54:59 -0700 (PDT)
Received: from [192.168.2.110] ([70.49.125.126])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba386b695sm110232221cf.34.2025.10.30.07.54.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Oct 2025 07:54:58 -0700 (PDT)
Message-ID: <bdd4ea3a-f326-4eb8-866a-52b1ea2bdc5a@redhat.com>
Date: Thu, 30 Oct 2025 10:54:47 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] s390: fix HugeTLB vmemmap optimization crash
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, borntraeger@linux.ibm.com,
 joao.m.martins@oracle.com, mike.kravetz@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, gor@linux.ibm.com, agordeev@linux.ibm.com,
 osalvador@suse.de, akpm@linux-foundation.org, aneesh.kumar@kernel.org
References: <20251028211533.47694-1-luizcap@redhat.com>
 <6bbdf4ce-10e3-429b-89fc-ef000f118fec@redhat.com>
 <20251029104457.8393B96-hca@linux.ibm.com>
 <9a8254b9-92f8-4530-88e8-fca3b7465908@redhat.com>
 <20251029124953.8393Cc7-hca@linux.ibm.com>
 <20251030153807.0a835fee@thinkpad-T15>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251030153807.0a835fee@thinkpad-T15>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FegtCRK-KDUl7jk3bHE6YQsC9K0zfnqjAmXcXbSDxRY_1761836100
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: jcaa5pmcijuxzprsjezhtfphmfx1k6bu
X-Rspam-User: 
X-Rspamd-Queue-Id: 39A0DC0003
X-HE-Tag: 1761836103-669239
X-HE-Meta: U2FsdGVkX1/YJdMc3gHxQvQOdCVQh1PK/nFswNGbOrwM74BBB65O9w6AZ40gdwei7kGOcTvROb5dPgHxPIE8ukc5SNMlHGfTbi8zKD1lbSplJAGKoAkTRfnf+lBoXDA/js4uMzFKf4nYINz/oIInJyuLBZDdHxXRqNBAei9rnDHLc/bOszt26xXfoZuK8ebxGlGbWLpgIU3FV8flKO1KVKRWUVV4s9pOJLGTfycP8QBkFXTyzqqtihZKJVHC1P/+xpIdMj7+/zYiIIs+Qoj93rKdYN2hi1ifCdHQKulePXUMb71uJGKbb3tR1Vjue6XPSOlsdqSompqKJf778h7IYTNQAMQLjf1AsQv+bpqhUOyZSqJbYaGBFLyIVKURMrHDvIxM3uOty0etIXJMdjclbsiXhfc11AKuZXknJQSwXWSkKOFPMxyIawROSTkYAW0RC6OQw+Dtg6lh5fP/4qQAf/qgevpGxrb1mDhl3pFAMJ8Aks1O3nM13V6jbCKv2f4TcLv8vnP036UEMycgdX2v57fFh0iiEyElm7K8CAYeMHN69+6a/Pp+/tzf7nlHpNAUNSik36UDP87jjcApW98Yao+SLGWqEv4+uyKzyrC8N6M4GLEx9in53n1qUkroBCYx8TMKi8dVDyARj+m81DBUG3IVgvsImWcFT6Cwycp3Z0pB/+pP3dzhd4mtkK3Ooyu7D1N6QoGoe+5BRfMQCrY58/DBThwsmri6F3Ngl6rHVRv+ksnnf+UP//b+moqeOXcnpZCailfULKJEjmJcgnkDyt/0fz71OJ3O5UsSwOGrYz0oQf8Fbdgqk+ButVxjlhuSnTl8pCc/G4+yX96oeiuHvsJaC3PuymnagB5BuslVQIKvCB6GGwHJdsDnxyBDXNroQ3P1NM2jBJC6bqm9wQwCkiCTo8Km5RSjzgh7kb9pUbVpbatZZKJnngqpVXknq8W2/gom3f/dy1n5oIDdPvw
 +Xeuz1ab
 Y/zSIZyt2/Nso3XsLz2hUtASKH4V1CvK5WMuco7huI5dXQFSJHACIzokur3ObMdG134Pgj+ShZGn+fQSlYtWQlWfgwqzd+Uiye6gBeXRqEHckGnmjVKKZf4LmsGL/cWkguExB0y6v/764xEu++LNNuBDoMvORmFT+j6uME9dGzUGBkdY5RPtsLLNLX4qPaNNOS+Z+Byz7N9sh5iGwc59YWCpSKcSYD16cXIXYwZ/gGmE/jP+prLNFkvxQJ+5wtCmjOxmh3sgJbFi2Cblrz32NYrcy0SpcsRvauLi34+FALQ3edd6xvMgrx3cD5YUu0vu1ei8r0udw80tJAf2R/jTrOQBQ35O+1m2wTJm6l/guaWLVQgnKh4tf/vXxz+H7A7sIYVo8qd9L+nFVmEYc23ZtbVeU20iGGHdIkDtNuILw3yuYWpPXolXoJDD9wv7AWdqBl1pIwUjEi0NykqkQXjflS5br+SmNSh8R/+KsUuq5UTYqtkXAUV3x5JUbchfSm2K5nmYD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-30 10:38, Gerald Schaefer wrote:
> On Wed, 29 Oct 2025 13:49:53 +0100
> Heiko Carstens <hca@linux.ibm.com> wrote:
> 
>> On Wed, Oct 29, 2025 at 01:15:44PM +0100, David Hildenbrand wrote:
>>> BTW, I'm staring at s390x's flush_tlb() function and wonder why that one is
>>> defined. I'm sure there is a good reason ;)
>>
>> Yes, I stumbled across that yesterday evening as well. I think its only
>> purpose is that it wants to be deleted :). I just didn't do it yet since I
>> don't want to see a merge conflict with this patch.
>>
>> I also need to check if the only usage of flush_tlb_page(), which is also a
>> no-op for s390, in mm/memory.c is not indicating a problem too.
>>
>>>> Changing active entries without the detour over an invalid entry or using
>>>> proper instructions like crdte or cspg is not allowed on s390. This was solved
>>>> for other parts that change active entries of the kernel mapping in an
>>>> architecture compliant way for s390 (see arch/s390/mm/pageattr.c).
>>>
>>> Good point. I recall ARM64 has similar break-before-make requirements
>>> because they cannot tolerate two different TLB entries (small vs. large) for
>>> the same virtual address.
>>>
>>> And if I rememebr correctly, that's the reason why arm64 does not enable
>>> ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP just yet.
>>
>> Ok, let's wait for Gerald. Maybe there is a non-obvious reason why this works
>> anyway.
> 
> No, using pmd_populate_kernel() on an active/valid PMD in vmemmap_split_pmd()
> should violate the architecture, as you described. So this would not work
> with current code, and also should not have worked when I did the change,
> or only by chance.
> 
> Therefore, we should disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP again, for
> now. Doing it right would most likely require common code changes and
> CRDTE / CSPG usage on s390. Not sure if this feature is really worth the
> hassle, reading all the drawbacks that I mentioned in my commit 00a34d5a99c0
> ("s390: select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP").

OK, let's do the right thing. Do you plan to post a patch? I can do it
if you would like.


