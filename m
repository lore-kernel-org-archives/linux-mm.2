Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77269FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E073C6B009D; Mon, 27 Apr 2026 13:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE5C6B009E; Mon, 27 Apr 2026 13:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCDB56B009F; Mon, 27 Apr 2026 13:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCBC16B009D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:19:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6632D14023E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:19:17 +0000 (UTC)
X-FDA: 84704996754.12.FE18929
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1136A80003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:19:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iaFOX4SW;
	spf=pass (imf30.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkL75I88AklWMnxS4Gn8bySfx4E22i3sGhBT824tKPk=;
	b=wLtxVwXs1+sHupnmqKPepTByYkerfbKr973lkI6DaX+z3FsaSCNHbum5UxB4STL2vUL5my
	gJC2T3DOhBtbLGsCIBiCpDGaLj3g8Yq3ETpTtYn1LGVTP6PLJ8YLqXocolv6frYue8O2Ma
	zSgjlB4oAPt4pbSlx8Lv66fmOhJ6/E0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310355; a=rsa-sha256;
	cv=none;
	b=b4MwQ/npEnSsDgcI05JCfGjSpPtmrz20hQvJU+lyrrDK70XExwN6wn+QsrpPwJWQQKsKmn
	64AzUtSgpJ3zQlf11Oil/D5QlNYpTKeZUQ4Hy3UoKsx7wF/ODq9L19B++A0N4iXElVweM5
	b9US+2jGB7kvqWsL5WM9qtmMX2bsPJw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iaFOX4SW;
	spf=pass (imf30.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777310354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SkL75I88AklWMnxS4Gn8bySfx4E22i3sGhBT824tKPk=;
	b=iaFOX4SWjjzje0SDwBu5IeJemt+148HI+/0O7bUI5RJ+XQi5f7cYv5C2rAjKIvY2zXvNTP
	G0Zu4VrXJMRkriFuOFhcXUiTwzi+/fw/MFyUgQpSe5s1uZ7flLM+eLbB15ItuCko+ys4Aa
	cq2P6OKKzoZdm9jGR1/aWbM0dimUSF0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-Olw5rQlkPTu4IrqvNsMbGw-1; Mon, 27 Apr 2026 13:19:11 -0400
X-MC-Unique: Olw5rQlkPTu4IrqvNsMbGw-1
X-Mimecast-MFC-AGG-ID: Olw5rQlkPTu4IrqvNsMbGw_1777310350
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50f817c3240so103156001cf.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777310350; x=1777915150;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SkL75I88AklWMnxS4Gn8bySfx4E22i3sGhBT824tKPk=;
        b=k1bBmdsiwEEN5e3YIcbJyRhoY5NlD7+vNZp3+iSRdgBgj9+HBj7u7Y9VtHnztATKW9
         +pqYqYqs9IRnf8Ho+8D4qcDl2AE4Kfe2tBldLB8WMZ57Qya/QAksBfBkjre41nsYN/Yt
         QoXagrrHgjCliOZJW+TOgIr14HlLj8wNyvZWGYQAt+mPaGKK0U2baKtIbM42TEeO/EwH
         /nWCRGAHE3X64fSxz9HjijMVv5OP8/aViSuwSm9w7nICxxkTL/msHgrC6K/ypNMQFgsE
         uupZ32Bzt5MUdls+7MjmVpBGSaCK5/TZJfJUQs94gg3zrtXflvep94yyc8WueGdVM1Ue
         FiSQ==
X-Forwarded-Encrypted: i=1; AFNElJ8/sSTIChJY6u6oyxmIzSjTuRl/BYeyP11MUY+zDEiFRBmsk2MpzPOso8YLfD3bzSDtExJ181Iy+A==@kvack.org
X-Gm-Message-State: AOJu0YzL4TwmpyTDqfx9UBuvHCAp+dlV0cQgOBNQHivk7rmT7PyLLntN
	oJMmsJgPYWtSkNwnQbYAxHP1DUbeuECPrUfXbZY3n7KBOo8jfCzO3o+kKIC28mYfyjcN84et9Al
	6/rneCE92ekKBOE1D/zb2yQVdJIshz5HJGBcmVgOjLUsNR5BouC84
X-Gm-Gg: AeBDietwesSeDV9O90lmxkD94yWM6U7RpetXRizSxLJhLP/KjjX7lDuIr8vVh7VyfOq
	Z3Y6yr87Jp/b1oNcC09D1uBhtFO26IB2/KBzDYhZQ81jqRYG8zrj0Tgga5LPPsYt84sva00PJKj
	VMZAH6JqqlazDXCY8kEk9iDLZGf2gxLIlv5guYlIFA4vRtY+JuJB4CHk9DvSou0YoD8f/hG+Ex/
	YXkogrX0nw4f8uyFCZaelWMFYx8PbyiAn2//LlUUmUuv6o7IV7WjVB9LC4s9MPKj2cXMlnkqPdb
	nzeUiDWfpIWUWZyioEQpnLgFD5SeAnh+ivkIVaU7Nm1TApdHl2YHMQMZRipDDR3zDAFFQZW5dAp
	DTloUeyIQahr+T10ASv2clwesa8V4rl4Si4tqZvLmeY+1aLiJRLYGe9URr5bk8SFqv7OihopT1e
	yeIC3XP7A6OjFvh10dHGz827jntg==
X-Received: by 2002:ac8:5a13:0:b0:50d:aa29:2b64 with SMTP id d75a77b69052e-5100c944df7mr2438891cf.33.1777310350426;
        Mon, 27 Apr 2026 10:19:10 -0700 (PDT)
X-Received: by 2002:ac8:5a13:0:b0:50d:aa29:2b64 with SMTP id d75a77b69052e-5100c944df7mr2437961cf.33.1777310349853;
        Mon, 27 Apr 2026 10:19:09 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-53-69-159-169-238.dsl.bell.ca. [69.159.169.238])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50fc91de051sm130914531cf.2.2026.04.27.10.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 10:19:08 -0700 (PDT)
Message-ID: <0e2ef2c0-d74e-4aff-bba0-6dd91dbd4e41@redhat.com>
Date: Mon, 27 Apr 2026 13:19:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 43/53] selftests/mm: migration: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Donet Tom <donettom@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-44-rppt@kernel.org>
 <a8510cbd-4a30-460c-b870-a250ceb8a522@redhat.com>
 <ae3v1cyMLbcvJtYW@kernel.org>
 <67d7b067-97a8-4600-a9a6-46f3e797ffed@redhat.com>
 <ae-UCVba16jg3-gR@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <ae-UCVba16jg3-gR@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mkmwbCq-22dBkw4jeUfbWWr02NjphnMcO5tDW18Feb8_1777310350
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1136A80003
X-Rspam-User: 
X-Stat-Signature: 71wih3ifx13wmqys866ozzn47pkfeemr
X-HE-Tag: 1777310354-339494
X-HE-Meta: U2FsdGVkX1+Ln4xE/ioOGXFF1rEQ7PHAmS1ZTzLRcJo3UH6ORv9rHg0EVKFr8wUOR1UsIszLwnLM48sFTzkcGuugSAWJxMSzR794JQNYZYTqUG2K6vIpL0I+boxKLqtZHQIqFVxo2Ku4iihnFkGtvEea1gAVmbGR2UEqHol7eD1FGnLDFFPt6hEXUWsGr7YSHtFaIleW33fjTHt6Hah5Tb2DmZtkpbrO9syWtLgF/1TZkNMzKD8H+02cs4Tc2fOLlZrsGwBCUhJMLYN+v28wxlh08bEf4DHjluBZXQYLmQ6Mv3hJI2fN4gUCxhQiJbkE+1V8zgmIqOIpPfAlwW8gxo+MvA9rL6nEjR/hbESBSQ3lVINImGAIznNQRH+A2d0uXicpi1idk3U/IS5zeAvCduEbZOIcSbg3ihropDnzkuoa29tPgHh23SHOe90LbO1eG8wAIrv3Lqyyu1gBMy6CDX+74IdQMPNSe0R1eh6nX901FTOd+KVSNLjPYfwsJdaRjbXuOYHRrvjFTdQJg4w/UvIcLEwceYmWebK2e9K9Q4pC3HUQYRqljASod4h/ica4gC6dBM9Y33hnKVAwFpP0ELg+ua4CWIMyOLMnqv6h1dv8yANxaQkd81NL+uugH4SoRljRusqkPR0dX5Q5fZD1he14ZQA7WSqD0Tmd+5VuuiSMXQKaiHqqXbbfL2FgGP8Ae1PTfAmO7UmwBv4Wn0yKsZdvegIJzUHnuet81FXJ4BhoVysXsW17g6O9w78sGQPd0xy9H4G9LKusbdQN0ixa0XGrOc4FTEFzCFgG+QVKz4FFxOE00uLNyC072WkJtmgZcWH+TeEuiBTUVuUP2m+INTVqJ58ICgCf2EaBnm7sH9D7ngmKlsUXVb6M9rDKEX7k1qKKz1MPwj6jJFh00ajULuwdgvjVibBrycCyPkVrTQq1v5T/UZizmd9Mwby0Ym5OzD8LgcxvK2921PMcJf8
 kMKHv4fW
 EZ9HaTMc+z5oEle1C90tAdmRXweyRazejVfQpibX2luZ1zeh4GRtqNJcQaXoR3nXgKutt5dADmvJdPo+Ow8eyywo83R0U75bbZKpq4pUVMX7ZbFknEM0gBYcSDztepi3q1ZnvBtboNgQx68dPCs7BwYTfHAURSw/wdxbOnqGdpS6ImIi0QOaXJlOmsOkoUxGM73vpD3U1Ib5wZtm0yyh6H9qU9a40KAKJmUmY/wD0JuDL0gkntd/PekItJYD+jwGXoSqWJmQ2vzHezGMSWoqvoM53FU2A4nnQlkEpi4k/DXEzd6lkxRzUveEqQTrgEPQZgI1zRvDpocgWWkVoSUdDivR1S14CJlQwjaFcLEVZL/ev988pmpM8RXPpB2neGMdmQGJntslwuNeUH9/V0ASfUK61ehk5e/Da3gsof9ZMTq3XHjDiIxVnokol8KAJuzYPLoBuMSOUzSck82Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-27 12:51, Mike Rapoport wrote:
> On Mon, Apr 27, 2026 at 08:56:27AM -0400, Luiz Capitulino wrote:
>> On 2026-04-26 06:58, Mike Rapoport wrote:
>>>> And there's another issue: when running the migration test individually,
>>>> private_anon_htlb gets skipped. I guess it's because the previous test
>>>> is restoring the HugeTLB state:
>>>
>>> It could be.
>>>
>>> I pushed the updated version that has the fixes for both zombie and
>>> signal issues:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=mm-selftest/v3
>>>
>>> Would be great if you can test it in your setup.
>>
>> This works! Both issues are fixed: the migration test completes w/o
>> hanging and when I run it individually all tests run.
> 
> Thanks for confirming!
>   
>> One last question: should we munmap() the mappings in this test? Though
>> I understand this goes beyond your series goal.
> 
> We could, but the tests _exit() anyway as a part of kselftest_harness, so
> it does not really matter.

OK. Just to clarify that I meant exercising the munmap() path, not that
we're not freeing resources. But if we know that _exit() is sufficient
for this, then it's fine.


