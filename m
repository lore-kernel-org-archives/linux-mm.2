Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE495FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C8F6B0088; Thu, 30 Apr 2026 11:41:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2242D6B008A; Thu, 30 Apr 2026 11:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113AB6B0092; Thu, 30 Apr 2026 11:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00DBC6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:41:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B62C140CA6
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:54:32 +0000 (UTC)
X-FDA: 84715518384.01.12D0DB6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id DBA6F2000E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:54:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NgN5YxiO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777560870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7p5fXb8rzgGRGsySMmX1Wn2cmLsL9wBpLlARqjRpNoc=;
	b=u7xHSbGaFR1YhTplG9hl60UmPM6jUit9dUaB02DBJ6t5wQq3vsJD5akqrAU5k7bCGVKPLg
	gVgIFjyhW6RXFdSWzubhV77w61P1VTDWyqDMO9gZOZTwXB32kQThIiNCCJq1+JTFtwTjwm
	paDT5RzeeYN8rjWi8fr9vXZZH3Bv//M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777560870; a=rsa-sha256;
	cv=none;
	b=xBk8mUjJ3S1O6K3HjTmEbV2l4ULVGtXkqD2eNbFZu7EyM+ZViyk18UF8bb7lXIUzhJL05T
	J+dPr+7sL99lAC25VbUhaiflyqOWH8VJ/qo8i8RuxwpMDpwqq1sqzNtRsabeRMws6drNBJ
	c7kd5RBRDHmKa44fQuKKcFZL46dXoMk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NgN5YxiO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777560869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7p5fXb8rzgGRGsySMmX1Wn2cmLsL9wBpLlARqjRpNoc=;
	b=NgN5YxiOVR8C3i6HVjymiYUJqskMzcbhLT5fyKCBemGTnHzoG6eT8fjsKRg9prnQzE4Ga1
	mQ/PF6nfT5Y0b+uje/KsN/5n+Pc3VIa8aSukBjLKkXW+R7ldIxdJQf6plzfJmDZ/Lix6q6
	p6+48gja5EVzFnztUMvxjE8+mGH2CoY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-nGsDzlgWMMe2Pu-3BeEfDQ-1; Thu, 30 Apr 2026 10:54:27 -0400
X-MC-Unique: nGsDzlgWMMe2Pu-3BeEfDQ-1
X-Mimecast-MFC-AGG-ID: nGsDzlgWMMe2Pu-3BeEfDQ_1777560867
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8ae6aa148a7so34558336d6.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777560867; x=1778165667;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7p5fXb8rzgGRGsySMmX1Wn2cmLsL9wBpLlARqjRpNoc=;
        b=opLAHCwpd1533xmKS2xeXVqry0sDu2S4CDr3RXE8iHcBGAu0lpfCnxKfQCGzAz83gI
         E+vrDdJEkVP0KSUdmiZc0nv+fGJg9AOMviPzqGUbKAeMDzaGokAwvJMMHC21ry8eEUZR
         4x/0dTS/vz/ktRvT9s4qqvE1j61jPLra/LXnbBQyM+Ci7NHXn4B0gEi/HgwWa0/0gC79
         nsczjhQF9/cM7FKpda1BCbuHpqhBM+JaJ/RhP/ZY+b5RAOPMCkAQeyhvqO52uMLcBYY0
         8Uw46NI4dk/xjioDOzhvMkhC2eNauqjTgyLEAYXkiS+dZL7nZpdlENwZIqlXWyEoLjFa
         L+0w==
X-Forwarded-Encrypted: i=1; AFNElJ/WdoI7tmLxZp2FgvdKbaZL+Yip9cjL4tKFCZGGYnYyeXfSswsmDE91iVHP53fK2VG7hsGLW3wupA==@kvack.org
X-Gm-Message-State: AOJu0YxQKSpDD286o8GBwJgs75Gk14IRz15FjJCIHDgQ7y2rdHnLYugv
	JZXTt2dSuqnXhgqWo5qZ7qpxlIvfbrvdaGriKHK6vWl7gN+QOf81ecTpnzCEtC2yPWsbtJxVwJD
	yhj/I5ZL+PWD+KJxQIxXEgmbyzJ8kpjeLbYIh/bU4bfWa+gouTF6o
X-Gm-Gg: AeBDietmoRXR4UWTqozhFjeLeEMWFNZm4+jx7/xkVkLUGWiGPJWR9PgblPMFNuXG17q
	cJeXusbeOyyGafOu5oXZwNRrAg5XYl2lD9OTS4xXlrFWU84sdtzcT9zC2bSbVlHOjnKywzI7Mmp
	s6bcS1me7NAJIcqLPg4B9TsSic4DnhPjq3THhAU4Q1Y1UM5OxtrGoJmqPqGlBcJlO+e449jTIHT
	8g0tHk+0L1wC4RzHI3uDahsMCyP3bMGYtURToO/5OwMsOtT0UiUWO97plgkTvCZVG2VuExTyFM3
	090xzEIk65X8uvc/FBj4ZIA33OBZXR+GO6LusLoYX6es+nXxUgLQtL52zKiF+DSCJHFhffwvFPS
	GmgjUbqXJAIq3pm4UbBFfYE8p2LUs/zG2ubg=
X-Received: by 2002:a05:6214:5549:b0:89c:4b37:7106 with SMTP id 6a1803df08f44-8b4000f7fdbmr35628676d6.34.1777560866846;
        Thu, 30 Apr 2026 07:54:26 -0700 (PDT)
X-Received: by 2002:a05:6214:5549:b0:89c:4b37:7106 with SMTP id 6a1803df08f44-8b4000f7fdbmr35628096d6.34.1777560866347;
        Thu, 30 Apr 2026 07:54:26 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b3ff439c2csm19482476d6.23.2026.04.30.07.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 07:54:25 -0700 (PDT)
Message-ID: <6f8de9a3-2adc-4d96-bc0e-5171bcbba60f@redhat.com>
Date: Thu, 30 Apr 2026 10:54:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/54] selftests/mm: migration: properly cleanup
 fork()ed processes
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
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-5-rppt@kernel.org>
 <6b12453b-2683-41cc-bb4c-602eda6bf9d8@redhat.com>
 <afNpxNsylkUUC0-Z@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <afNpxNsylkUUC0-Z@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FesRWRIX9gczpjzsip6LD-7wzj0CZVPR3RDHR8xO1jI_1777560867
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DBA6F2000E
X-Stat-Signature: ysdpxbyd36161st4aegf67a8jotn495r
X-Rspam-User: 
X-HE-Tag: 1777560869-526032
X-HE-Meta: U2FsdGVkX1/xdN6jodCTLsyPeafKw2HtZizlJHyOkv2rvEnXqBNomKt6zFSwkBu3+J8NgozI1Q9yUB/iuBmXAeE0+ngkItothtF5Jq+h6TB4zNob4EJUirzuilTsu50+YUbqRYIOoPzymaKhsXyU0UWJ6Rmk1KWnrqELkgPXt4FNh1bDPB/xMM1Vb3m99Hvjl1IuyYrCR9j0CQ5bJfhabLegqe+fESmOi4Gf9PdB3D3AKP5LuMYQEkbpNTHyJ70RuGMUKfm7WkErNHJF9WmNduIeGqQrxu3wsG4xLUGgt31FLZEoXqb1tO6rhEu/Uz48nbxV+sTo4cMUq3PtZLhcv+JqfxdtXWlbYAuFlEqHjFStAxJk0wXEBFRxMp5cyGZGDCnlP4XUoHQLM8m60BCM+RquyZ1e+CkBNCDkA6hpIgXxIeLN+DWlHJVdfzQ+BrXaHwAO3qtmjYPNMrq535qCzYfDogUrUkbjJqGXoDgwMqlAc/RK48+PtXVojw5PJ+3mjKY19t7Ix1StkI5PiMbIjOuiFwiiqrkXnoTe4yfqzJ3oJoKRVq2EpB7ReTlew9ZRPh9ajH4ZEm8N1KnQZvs0q1Affofbv0iDKXy/2iZHRTjjcSP7cHpFm4hmWysf7Jm5BwuDGcg6Pq0Caohgr45tjMKr63BqHZ2bCfqr/q2jHGiXL67REjFj0gZPxpnR0KzURETLOl+dMHQi68SmAapb0TtqHfNGh0bVVcDcPmK9XXtyYnzPYf3617QUl7QQhaUDTsYvwVvoKUv6Z+RWZ9LuwfNrpaqgYq1BVSMzQzJsQhwqoVRymg0CpegHHGU9Jo4sHEArp2WKd6QLgtRujRO3C8fFxwt4tp98kP5ARBtFNKgV3ojwPpmlqDGPbmJLjkYx8g7VNv0ZfSa2QTXo3nQspg2nQFMAOj6pXkTLoy3iFO9HMhQs/wfHSROZmVQ84lklEId64PTBf4SHqvNHkat
 gOegcxC8
 lGtpvJgpV/5TYmjwEDXIhEKZGtOkR3q6fIIXZ87gos+uv1upoF7LPqOMbaPheuOfE5GbBrt8o9uycWKnzzSfwrh5WV7wDZd0iGM8p8u2Gwk9D/41JyY9nK4o8Dqbv9RmasBheMAJRv5hYG5SHhy4O5s6Im2daD0HKtUpB5QYw6zc95YopSNISf4Zqq/Q5iILnqY2t15S6RET7GevwAEXiEAzX+VTeYNzsiVGBP4FPvmQwNgSHu9wqJYpJbA6yxOfLbotK9emMe+yMeTxULPH2VUBtn3AUPixJWpeHnr43iT2kMHrj+Mg5QsIVeL2iiFeAodgrxM1wiZKiLPlPgt9GlpSf1ND0rBigOl3WTGIZlZT3a3mPlwtOrUT2b+vudk/5/BnFP/+XwnecHbz5oISLLEGQvDpsgLKTZ7aO8EXEvGBZZ5y4PaLuFsPNYUyiX+091p3EaoLzlsMYBtDKNjhur5O2tdz2mG4A6GRg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-30 10:40, Mike Rapoport wrote:
> On Thu, Apr 30, 2026 at 09:37:43AM -0400, Luiz Capitulino wrote:
>> On 2026-04-28 16:41, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> Several migration test use fork() to create worker processes. These
>>> processes are later killed, but nothing collects their exit status and they
>>> remain as zombies in the system.
>>>
>>> Add a helper function that kills the worker processes, waitpid()s for
>>> them and verifies the exit status.
>>>
>>> Replace the loops that call kill() for each process with a call to that
>>> helper.
>>>
>>> The addition of waitpid() calls also makes sure the migrating process never
>>> exits before the processes accessing the memory, so it's possible to drop
>>> the call to prctl(PR_SET_PDEATHSIG, SIGHUP).
>>>
>>> Reported-by: Luiz Capitulino <luizcap@redhat.com>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>    tools/testing/selftests/mm/migration.c | 54 +++++++++++++-------------
>>>    1 file changed, 27 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
>>> index 3630f2fb0800..76e380b74658 100644
>>> --- a/tools/testing/selftests/mm/migration.c
>>> +++ b/tools/testing/selftests/mm/migration.c
>>> @@ -67,6 +67,24 @@ FIXTURE_TEARDOWN(migration)
>>>    	free(self->pids);
>>>    }
>>> +static bool kill_children(FIXTURE_DATA(migration) * self)
>>> +{
>>> +	int i, status;
>>> +	pid_t pid;
>>> +
>>> +	for (i = 0; i < self->nthreads; i++) {
>>> +		pid = self->pids[i];
>>> +		if (kill(pid, SIGTERM))
>>> +			return false;
>>> +		if (pid != waitpid(pid, &status, 0))
>>> +			return false;
>>> +		if (!WIFSIGNALED(status) || WTERMSIG(status) != SIGTERM)
>>> +			return false;
>>> +	}
>>
>> Why do we stop at the first error? Wouldn't it be better to kill &
>> collect all of them and then return false if at least one fails?
> 
> Yep, makes sense.
>   
>>> +
>>> +	return true;
>>> +}
>>> +
>>>    int migrate(uint64_t *ptr, int n1, int n2)
>>>    {
>>>    	int ret, tmp;
>>> @@ -160,20 +178,14 @@ TEST_F_TIMEOUT(migration, shared_anon, 2*RUNTIME)
>>>    	memset(ptr, 0xde, TWOMEG);
>>>    	for (i = 0; i < self->nthreads; i++) {
>>>    		pid = fork();
>>> -		if (!pid) {
>>> -			prctl(PR_SET_PDEATHSIG, SIGHUP);
>>> -			/* Parent may have died before prctl so check now. */
>>> -			if (getppid() == 1)
>>> -				kill(getpid(), SIGHUP);
>>
>> This goes beyond this series, but I wonder if we should have this check
>> in access_mem() in case the parent dies in migrate().
> 
> With added kill() + waitpid() this should not happen.

I was thinking in the case of a crash, but looking at it again it seems
to be impossible so it's fine.


