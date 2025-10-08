Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC66CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500178E0012; Wed,  8 Oct 2025 05:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8608E0002; Wed,  8 Oct 2025 05:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6F68E0012; Wed,  8 Oct 2025 05:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AB0A8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:43:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0EFB590AE
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:43:15 +0000 (UTC)
X-FDA: 83974458750.20.B56B6B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D46A18000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:43:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbJtF8Id;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759916593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JD/HSn//vajjys6bQcekYCIiWa+gYSHGEuJh3U25KF4=;
	b=ARxtMcwoIbGM6cDvU6QNfhTKdzHzVRR+zV0ih2I+anjyq63lV30nyJYtK07vS+UxQzl++B
	7c+pisLDKhdd1iVCyIPNelnZKH7xBi6381HIZt41go6kAV90hdJaXDcdF6F9A0KlEyVq/W
	fw7ruZKIdC5kTdnh3jT7/mHWp1QtnlE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NbJtF8Id;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759916593; a=rsa-sha256;
	cv=none;
	b=EiAUuCjtIH2LqEf7MFE3pkwzkRSi2LECRlJSJJAMeSxCYDOmw94fGcKcOgrToB1/RxJaMj
	lXx8+vw4JI/4OACZ6kZF2LeK5LlyzBaOn0tE/ZsZ3xB9+QHk0ynHg6qMlKxTW5KEmZykPu
	TAHSLnNjq0SUhWyt6DmTYignzixIVZ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759916592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JD/HSn//vajjys6bQcekYCIiWa+gYSHGEuJh3U25KF4=;
	b=NbJtF8IdBfZ86sx3LOorrdHGilVN0mx1cwceg9sS/q9rWMWvABLuIV7se2/stUjKuRZaUA
	CrG8M5cTrsuiJB/x6MJPQqXso2Zvm79XLaslvKu3ueZczzOqFuh6rqN4JKrNSmd2EiyCcK
	8rAcBc6QKQZvhKEzxUD6KpRZEtUPeO0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-E1ve7ioZPl6tSZWFUSVZ7w-1; Wed, 08 Oct 2025 05:43:09 -0400
X-MC-Unique: E1ve7ioZPl6tSZWFUSVZ7w-1
X-Mimecast-MFC-AGG-ID: E1ve7ioZPl6tSZWFUSVZ7w_1759916588
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e2d845ebeso38285685e9.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759916588; x=1760521388;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JD/HSn//vajjys6bQcekYCIiWa+gYSHGEuJh3U25KF4=;
        b=mJDUe5e+x80eNXCIVFsXE7EECDSh+MkG1lMYQk6Mm+xkcfE75XBbK70GNaL0nOUncI
         3TPP/v94K6tsGYj1NbYsiWYuYeFeWVciWbIJacznZAdidzh+EiQGMqDMj1uSgQxQMeoq
         DPBTKAs11/z6Z9QktNyp6mrGTNN1r93KBztg1K95963GQmOJhMYmukp3H4SxzzJ3Sjkd
         iA/r7843DlNar2ClFSpZhUZ7CoMxOlf48YfKPeOILvWDX16VPySIk3mFCggNbFqHkIO/
         Gw9RCRWi4f73WCL+zr0ALBVwSKM1mK058tRBte1Ww2sZ54zhXmQ24ZI08CkLeWH1CFNl
         MnoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj6tjpz+A45AWL/YdicmZ3bK74WrQb+7irUJ4kg4gozb1iF4No9BhmAgKFQr7z+OOk6dEaT9DeBQ==@kvack.org
X-Gm-Message-State: AOJu0Yw87C7GIrF/eiuBIzbj53AlIV0xWIamDV6vQywCtZTWIRwakAJ1
	/YuXDkCtwE7hVMWidzhRZEELibdD3kasNGcK8nRoyMgydIbj1+g2APfbjNI2ch5UTUSZPCbh4dx
	BYkiCT3k06aMKd4xde7qi5cOiHCDqlnu9jq/eufyHsPljMwhqh7Xn
X-Gm-Gg: ASbGnctc6njAVRYRARGGjVy8cAtx4mfzLyJSn3uuTREoPw98UXussev3LEmzynhPGoi
	BdBf1r0GZLvUyTl+UBiZQXwE4ITlYvrvw3M7HSQlKM9sqYOReWfNg3zMNGxjZtJqlz8o5WLrskM
	NNWh1tPLX1L+112STgsx5aZTmZse1szm5Alkrbf2AgJdYjq7RMVZIJBLZbh3OzD0T94vFTCUNI9
	2UKJYC0JUr9qF3EkH13VKoDQ6J/5qaGHQCMl6P/TwdZTyAc9iSYnzd4elgPqEfiSvTgL8TRES2/
	ChSx3azORtKyycUguCkhulRpfKw/sZJaMfElvKylMoFrYTtAq9d+GoaAV23CWkdZ7v2o6pTjvIa
	N1it+82Dz
X-Received: by 2002:a05:600c:1384:b0:46e:3cd9:e56f with SMTP id 5b1f17b1804b1-46fa9a89286mr19134755e9.6.1759916588194;
        Wed, 08 Oct 2025 02:43:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYzPp9F7S3QX2xHYqfV5S6fHz6gcoGlAerW1ZxI0fAG/Jst1h7y7+sJqtkHP4Cco90/r1u5Q==
X-Received: by 2002:a05:600c:1384:b0:46e:3cd9:e56f with SMTP id 5b1f17b1804b1-46fa9a89286mr19134555e9.6.1759916587743;
        Wed, 08 Oct 2025 02:43:07 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9bf94ddsm30134765e9.2.2025.10.08.02.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 02:43:07 -0700 (PDT)
Message-ID: <abdd6107-d380-48f5-9a25-22a5f560c78b@redhat.com>
Date: Wed, 8 Oct 2025 11:43:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Support dynamic (de)configuration of memory
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-s390
 <linux-s390@vger.kernel.org>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <ab366c03-8c78-449d-bfc4-2d155212d9d7@redhat.com>
 <aOVUNmDiWgrDJ1dJ@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <5e3b16ec-9ef9-483e-b97e-bff0c1915b19@redhat.com>
 <aOX_L1_2S30XhLRA@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <1efcb368-fcdf-4bdd-8b94-a705b7806bc2@redhat.com>
 <20251008091226.7407Ba1-hca@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251008091226.7407Ba1-hca@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4GFzr_z1VzAzbVdtKRl34rEWlFyxvSXfmLlmklZ4AVQ_1759916588
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6D46A18000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: w5jgptyhz8nfesbi9z8s3qbzwtsg95oa
X-HE-Tag: 1759916593-400104
X-HE-Meta: U2FsdGVkX1+2z/16SHVv+rv+GZRgY6ukM/eEJJaDCofNaxYRFcOUp/3UFwWpI/4W/E1du0VpQke+mu66jkEanW1AjoWSy2TUwo1RYswBbC4sd4lZeFQd0hpS/J/cI7MTfITRPjToDhVLuH5wt/1I8i4+sL8/jPyMKRn83+qMk9Pz1+B+XdeMci5CnuY4/Ibip7El0KN72C6LMcP6wpYbyZS+sadfXYWdi2uVyFfrI0wvnAmVa7H7aX1eM5UaKFOTaLw2aVCUTcszUYeDX9MlYSbGj2ciUbqB+m+Asx80gO0tP4icFNmk/pi/lNCETyWTYSRNTbj0fnNnttyeB3lKFbBIacb9zAEoiAolqi+ijiwSnThNUzwQzcaJEkNgcfuI/shYDB5g93GJwDid5/hFYZks2Fu52UzbutYTyG5wY+nRI0oSeBVoQJaCo1ZxRVdYh+rzPTyB4wtdrWyDjDXR1rUo6jIkPzh0CP+kCx9QE9SetzeUihxUkptRxtI243beuiTv1tG9JkoOI2byTdgep5Yhqt25ne4Vhdhyp1JRhtygFvhthpNw3d5rE+Cb1n5PcAc60yp05PK26xBcX60zNvbw+PiLkdLQucQGiQ9REUvU87CDWDJdQgIgFAlchV3rLTrH7BAS2e3q3SvmgNHCiejjPDXsPJaXj3J58ZLmRf+QaMa7hQtkus5bNycq8qz1Ekkwnw/xJhpCUjedlWKdRNgnwfmQcbq/Zp7U5fmSNQ8rOk8vKnH3dFBh9V8cSd/ZVp4jJYE8MaiR82p9oWEg5Yb7HxnAZYFo+vMPKC9dpsGUcdTcWLgU4IuDV2PRzvRBHY1fqVxWjsh/HDDOi5Zmw78I4MhMr8CsjCWu2emyavHtw4TC9u7mjALd4buZQtL86NYsr531LrFBET7Nd0HJtXt5ESMrD17216/P0xUREFf4ItABKCkoD5ep9aA9XnbM5pPqJMQSSN/4ADf2bEg
 ZirFjtS6
 6/YjSAv9j3KxuUCQSN7wge5g3UyC/DyWKkB6hwP4zriRoa0CLSTqKvzGe7TPCXwOn7a/yW9yqD08UMYM2iTxYECtAFyjx20qOuPzJRA42kjxJw9o7IOpBEFamgFS1wA6VV3NMvaf0D0WBLIdIu87LPSbsm0Z9xaBLrFyAMZVTVkvhU5VPIOOzhaZGaohUN5bk6CKMiJzA56vQ5Cpuhl6oJTK0n/8NQY0W+humWNC0jBmNwzV04z8a5wPyrDFZ6TC9/4uDcjFBZbVrOLDB5FGFxit7tk+D2IOa6fLkIRzFUp32lYYrTSokdPUv9nzcsw2sfn+hG3ke3i9P7muPEru/3hLCzrErHW6iVm3jeYk28pH0t68r/0c0rqKOn4mQ1INUPT5/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 11:12, Heiko Carstens wrote:
> On Wed, Oct 08, 2025 at 10:02:26AM +0200, David Hildenbrand wrote:
>> On 08.10.25 08:05, Sumanth Korikkar wrote:
>>>>> chmem changes would look like:
>>>>> chmem -c 128M -m 1 : configure memory with memmap-on-memory enabled
>>>>> chmem -g 128M : deconfigure memory
>>>>
>>>> I wonder if the above two are really required. I would expect most/all users
>>>> to simply keep using -e / -d.
>>>>
>>>> Sure, there might be some corner cases, but I would assume most people to
>>>> not want to care about memmap-on-memory with the new model.
> 
> ...
> 
>>> 2) If the administrator forgets to configure
>>> memory_hotplug.memmap_on_memory=Y, the following steps can be taken:
>>> Rescue from OOM situations: configure with memmap-on-memory enabled, online it.
>>
>> That's my point: I don't consider either very likely to be used by actual
>> admins.
> 
> But does it really hurt to add those options?

Oh, I don't think so.

I was just a bit surprised to see it in the first version of this, 
because it felt to me like this is something to be added later on top 
quite easily/cleanly.

In particular, patch #2 would get a lot lighter also in terms of 
documentation.

So no strong opinion about adding it, but maybe we can just split it 
into a separate patch and focus on patch #2 on the real magic?

-- 
Cheers

David / dhildenb


