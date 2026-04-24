Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F830FED3F5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A1D6B008C; Fri, 24 Apr 2026 13:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0213E6B0092; Fri, 24 Apr 2026 13:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79B26B0093; Fri, 24 Apr 2026 13:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA0D36B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:42:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A563E1B73BC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:42:06 +0000 (UTC)
X-FDA: 84694167852.05.3DF12B3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 394D912000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:42:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AbYkbuTB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777052524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuWtjF+Wyc1hGTB7jedMSCQYvS6gqCcPJkY5z5BlujE=;
	b=uLkODWEm0g66qOrSgbpGEJWhecSqbQ+Jnxpv4xcnianMZVzXwsngtseFb2/vbpe4zPNgyh
	OyXLXcYlmXboBwqyuXDsSkpdmJHRz+DXCYpLUh5uoELHOvRsKpr+QPV04L3btLiPtCkAlg
	LFEVildOVJ5ZrFuGkZW6Tsn/nibOXOg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AbYkbuTB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777052524; a=rsa-sha256;
	cv=none;
	b=sYD46sllOe9z5T13fW6hEQRQyvvjMYCxKS/QUO/mYKmOPSOBPyGOE3jHbwtTlm9B3tTvZ1
	jc39KAHA9Y40vv1yG9XhLtfSH5s87bBFCCV/3Nz+sFtCrx2bZPP2isqItE8j3IG/SNhZ+8
	QvdatdoTy8fp+mQQCnpHDJTXMAPg7+A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777052523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NuWtjF+Wyc1hGTB7jedMSCQYvS6gqCcPJkY5z5BlujE=;
	b=AbYkbuTBVCpLhTXa/VJS12ozX7De6kXmf37pkB/0DLjXZpREwZEIsZeUn8n26XkLRGOMW7
	lOix7FE586hIYE/hdlhEb6bR9cw1fo2K550sFnnar0fCUWk1rSRYet1wDFCj92gjmUgy5w
	3GBJm+062HypkTatQfppuUXPmHdatiM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-YjbMb__-Mwy7UvKIXwPjiA-1; Fri, 24 Apr 2026 13:42:02 -0400
X-MC-Unique: YjbMb__-Mwy7UvKIXwPjiA-1
X-Mimecast-MFC-AGG-ID: YjbMb__-Mwy7UvKIXwPjiA_1777052521
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8b1f39c5827so79114936d6.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777052521; x=1777657321;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NuWtjF+Wyc1hGTB7jedMSCQYvS6gqCcPJkY5z5BlujE=;
        b=qK7tTc3eySwmVHF3m7AZsDCSJZ9mkb43lH95yRD1kQ5Jq9B6rxq62vUDg0mjx0S2AX
         /O9jUAT5WsN8DmXaIpLA6HeEB5sCEXklih2mGSNIfwJ3am/WsF2lsPh06COyhLjCgikx
         JOkxCzckd048YrVjCjh8U+5LvBMqiw7308l5vTR80YpfGkTbExXodC74/TU9sJ2ZbOtX
         VBB4LBpIB9JuK5aBGFhn19/hJDFFN+pi9e+d9Sr61Ea7eM2xHtQgjIvCh8sNkd8iRLVe
         vlWQBae3tpDjZuheHNDQlVt2py4d9GWVp2HY9xNxSJRSVP0lU2ceKfdjPje+jlgCOC0a
         rBUw==
X-Forwarded-Encrypted: i=1; AFNElJ9kbDJUlJGgQ6busAa1O204Na6he1KHWuSpMdCuPdURkuPG7tRUHissD6VKITf9i99PSToIqiEuMQ==@kvack.org
X-Gm-Message-State: AOJu0YzwRyz5WoiEqOxxS6uyVxmKYcRmW3s+DOfKJ8f6Bf6Ns4JILIZo
	funLwhxe5s3ezBFG9++F/IS9fxI9DkQVJO8kay9J7eNc7JaTebep+VBzS4gQtPYaogVFMCwxsCR
	boILrUUp/B3wGCCD6HZOVUesMwIya0gKqWhKLB5gU1yu/1Gt5MLU6
X-Gm-Gg: AeBDiesKXJ8Jn3YLblyZxgv6c+LgsFGqyXj1WBu3jWxCps35xMthkwr32vEpDD+tNdJ
	PwgnwBBNmyK0CSK3jNroZFgCnQrn9IUSKSVYtsBZ6MhIntLiulgTtD5dT3TSyCnn/TdQa6k3+GU
	yAQQhLOOcw7U9tU36n+i+cQhQLJAS09tueeW7MTZj3+eqlsRowfJI2SYLRKCFRvId4v47aOUkph
	nRTVb5YaVaCgSWKILY/XJU359QJcAYZtgbs6gX5f2tcE9DV1N+hF4/YQA+TfFu/dM4o81HNKbUh
	lfvg6OR5Q/J+px+GyFZsGjXiCL5zdA8jyLMZhV5Ba1NDH7pfnu/jjU1I5TidTKgkmZ+qMvsvuti
	rJ6UPXfa6iQ+QkwrXOj4XZ4TsRJxxtjmpS2kJ+QlpTDbmaaSydwh5A4X5L9wCm2zrgl/l2Rk5ez
	tVKDRxmOs3s8WPdSRZaKxYBlgr4w==
X-Received: by 2002:a05:622a:429b:b0:50b:4337:179a with SMTP id d75a77b69052e-50e36b86637mr456868651cf.3.1777052521466;
        Fri, 24 Apr 2026 10:42:01 -0700 (PDT)
X-Received: by 2002:a05:622a:429b:b0:50b:4337:179a with SMTP id d75a77b69052e-50e36b86637mr456868011cf.3.1777052520974;
        Fri, 24 Apr 2026 10:42:00 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-53-69-159-169-238.dsl.bell.ca. [69.159.169.238])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50fafe9674csm151451681cf.3.2026.04.24.10.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 10:42:00 -0700 (PDT)
Message-ID: <6732af42-fe43-489f-8561-9e6e4870e15f@redhat.com>
Date: Fri, 24 Apr 2026 13:41:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/53] selftests/mm: rename hugepage-* tests to
 hugetlb-*
To: Mark Brown <broonie@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Donet Tom <donettom@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-7-rppt@kernel.org>
 <4d2fb0ec-91e4-4902-9d7f-68d782ee98c7@redhat.com>
 <30bb8071-06df-4953-b189-ab6a0520739d@sirena.org.uk>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <30bb8071-06df-4953-b189-ab6a0520739d@sirena.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LRQXLua_wq36SKcWm40BmMjb_elydDj3Q1tDmgZ6aBQ_1777052521
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 394D912000D
X-Stat-Signature: c44dg6xwnzcwhzh8k1inshhrzescfh47
X-HE-Tag: 1777052524-591048
X-HE-Meta: U2FsdGVkX19to0jG4ZS8oBaN2LI+kOIfkBWMU9WNkd4Gqau6XnHGmq4gCXZ1EsArGfsFqARDMuDmtbq5Hym4p1utGqzK1H5NbkcIwiI87jE9rO4G0Wmfd2UEcKZH1EwTZ0UJRFhZFWDVv0LvPopwy2A+V89HKGJbw5BcrfHcYs4qRx34f4O6drrrCWq2wRBnAfGTOCWYfiHxL6jy8L7C7wrNxc3aFr7WQpP276vwcrSUfvjJKTUPJ7PF5/NSChUHABrR5WNZLm0wqrTO7hHr3AygI6SK7C7KJvlc8nsY0LvLL5iAZezO/yj5PWwNer4xZeF/ig8TDdP1YMUVbH9Hx+my8QLhVqNLF+Ef+ygudtMkZnGBc+5XbOe1ht0a3KL+cEg2doewOwbw6xZwqUK+zkx3Ce5EB0mMwRsU4T1Gdbe+RjnIGKO+ioihhdHmqgdpolEXYG5QOKb7oNv6nz64Iov/8kDpYH9YCOEdemVTsdyUT+qHCao6bWgtmJrn6TnQyR39vLrQN4nKGzgegcp0cL3LEjGWh1JwkRJe4wL+C1oqhp74U8lJFsnc+xPSSwJEgtdbJqpvIn8FwT3i15f9fb/EbScaSChDUbcsbKaBMW2kjCQ2JOeZeog84Of1O7eruNpduHbGZmbi7hFQ1co0wJgOenRF2ukA8GMGNxbUAZmUH73UNwfQ1tpuqpeaWAl/QqBGqVUXylGoKnR+ubWEtLzmF/Or5ldQNaaBChFeP33WDqnUS1cKBkEUb4uKS6CSjU8cqCjGoOukpNkjgY820QKzpOJ0MVDQZyof4mLLHHVMZxm+sECMPgvUH7O4k+9MtoMKnZUGXvhSbi/NpzvDXq/Szx1aVwYiGaX3ryJLVjKcVpefrV7XUDZoLI2cQtwkj0W0NFsuv2nqQracN1IoD0FXXL0fNY4MBRoWLDTu6ZIW9RsgjzK0LYQrcCf9RvVaj8JwK9Wp6CV21EWKzs8
 NWXn9Y00
 UFu0eyI8+ew66/Djk2++3ktGf9rSGe3x+SIELk15Ocjx5jcktTgiBFih9S9GSVBl8Obtu5ZsdU1CbPlNw5Pxhiacz5f8f0b8O4JYkZFDRvczqVHCofdfBERtd2jeRmRJ22hqCrnlQDm3dE0RNPbz9ACkcF2PJ7IgC3V9FedVNeH7AnuS0gH8nonw+DbuzEfgvyyKs2DzbxPaF60515W4ohKlnibOHdYCmF9gP6lMny/AZcRXMDDx2miY1HbBj4pDo1a1aPQ6uKiBWf+fSvl5auUjD89zUmJFKut+IfpTzO5RJJdhpg1gBghiWb8COrKHA3g4ph8ulRTeDNP/zb6mDX0uhQ4z3FMKObF+u59Dg9MMdsnGqj17TQYQ+9nPLTaRfDxvvnKRPv9GyHJD37V4aBM4Vwbu8HlCbChYV4Uc5CCanBNYiTmWPNLsuhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-24 13:36, Mark Brown wrote:
> On Fri, Apr 24, 2026 at 01:20:02PM -0400, Luiz Capitulino wrote:
>> On 2026-04-18 06:54, Mike Rapoport wrote:
> 
>>> --- a/tools/testing/selftests/mm/.gitignore
>>> +++ b/tools/testing/selftests/mm/.gitignore
>>> @@ -4,6 +4,10 @@ hugepage-mmap
>>>    hugepage-mremap
>>>    hugepage-shm
>>>    hugepage-vmemmap
> 
>> Shouldn't we remove these? Also, there's a reference to hugepage-mmap in
>> Documentation/admin-guide/mm/hugetlbpage.rst.
> 
> Linus complained at some point about removing things from .gitignore
> causing issues with old binaries left around in the working directory.

Oh, that makes sense. Thanks for the clarification.


