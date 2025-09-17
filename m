Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706FACAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE0B28000A; Wed, 17 Sep 2025 14:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B842C280002; Wed, 17 Sep 2025 14:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A734528000A; Wed, 17 Sep 2025 14:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 972CA280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:34:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64D7411A9F7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:34:19 +0000 (UTC)
X-FDA: 83899592238.10.9CF1EFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1AFE4160003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:34:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SWqPVX8a;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758134057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGFF1TGksFvJE01BynPWTlxwwJdIv5IyqKnRBO/qFac=;
	b=EJgAPrymgMS5AmtAYu3u5it2gImssEBR/6g7UEfD4xT9AVJHT5Evj06z09YrBh0XBUwTdr
	/gQfUlGxfFY9TWKzvuYE78iC6BVH8g7UPNCRFiPZsp9mDFKtv1IswoAAERbSacnl4+h3lU
	B4ifyXjhkiY4nDTmLO86qXIEEvZkKw4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SWqPVX8a;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758134057; a=rsa-sha256;
	cv=none;
	b=Mzm4m+J0btcaML1uGrPhwy6P3r96N9ffSmnX1RyOy0Z3chybesWamJi+svqVEUZfkyuxws
	Xvp6e5jSptOUFkTc+EH4d/mBPezVbt62BDHYS0+LnD8DCyyulRPKSiE6aejdrwsyJbQWMV
	Cy63J+FZodqn+0/MmsnMnTDUtyo4fUc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758134056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DGFF1TGksFvJE01BynPWTlxwwJdIv5IyqKnRBO/qFac=;
	b=SWqPVX8a0VcZFkS3DNk5UjyeSaUQYtuXJk7kjQdIpqj+461CyUWzRtPVRg/BHVOFa5NnLX
	/tWp3gDQYwFWSn2Q8cIO1dnXE+IVYcMDgosDsrWK/26EKAoE6wRSxnXj0o12GxjSNGcjzm
	MjdZT3k9hf2eKC0eDG9gt14+cqCKuPE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-xwk2N84pMceLAQ5F2RHEhw-1; Wed, 17 Sep 2025 14:34:15 -0400
X-MC-Unique: xwk2N84pMceLAQ5F2RHEhw-1
X-Mimecast-MFC-AGG-ID: xwk2N84pMceLAQ5F2RHEhw_1758134054
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb612d362so386785e9.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758134054; x=1758738854;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DGFF1TGksFvJE01BynPWTlxwwJdIv5IyqKnRBO/qFac=;
        b=KOzVlyUHmPyyqmOk3w2kMDe86wqnK4Z8RdVEk4FkP3bPwV5ReMjO1qMPoME7J1gaK1
         oF7wUDnjMBhY7ng8bMvi+DIzdnkC0LxASO30e2234ZOwSHPwslxIYecBTNsKsP8/M1od
         FaXG3VU0Tqo9Vnm8mbuUea0c+Ru3YjirEdm5NlVDF+rHV40HLUHhfJAqb29eNpQSgjmZ
         dlC8sWChRaNm1+Q1JUfRkNgdDHdFpQKDrpyj0dtBD99Nqbyi6kZKSR83rIvfwQVoSPu8
         t2Vl3C621BVz0AIku06Da7PuKVIYMab1Hw0qwRTMmNARhTeyJAo3Tu7uwOCrFjLxArbm
         AZjg==
X-Forwarded-Encrypted: i=1; AJvYcCWx2sGciWgSrI7/rA3nVngySh7tegJHlVdPL3uSsslYSwlWJ+HBwn+MfuWnyrSZ36RHbSxVL3J5hg==@kvack.org
X-Gm-Message-State: AOJu0Yz/bL9ZWWompoc7IJB2UdllFoBUWl84l2wFeDYEmGTSpa6oA+88
	QEEi4dU9CpJsdGcsHftKEmjRzVQs+KaPaQ16tacFyGU+h+7UrSQP216J2270rsGTX4ZCMMC87HU
	81bXtBtIA6JbzbMh9Cndfb7OWObgkAAZ4EkAuF+5p5leu5hYEepHM
X-Gm-Gg: ASbGncuZuCbApmm4XwswZregLVrwL4DnomW3emO0RYcbcDEKv/zaFCTK3eQ+RxfF91c
	YgMwFFpZdyW4I6ux4wQTBuGXJAUHtb0X5Tkjkh4GNTKCs4T+0I5gvAFp2TPFuNwahHrXvyiNEgL
	lZ6tZ+CWxw/QDZk3rhWdhIK8An0i39KDppqcD/Q3y2Jwk27psshApjl6gM3mcHHI4mTOFf3XGRp
	u7UaqirmBVwyktfdt7jZhBuJzi9CtP2zw9iN+nulhb/GTo75GysINRoetPIg8ypmHsn7IHDCOTG
	2nNqIzMm2XE1Agl5e/Dvukke0WVH9jmUl0uCqLDYcJQII/RRI9Be/WrrhGvJ4YUfVnb2KZ8=
X-Received: by 2002:a05:600c:3b09:b0:45f:2d2a:e323 with SMTP id 5b1f17b1804b1-461fc6674f9mr32666625e9.0.1758134054025;
        Wed, 17 Sep 2025 11:34:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHedDcjLH9XDvUmI6R0DJmIUBsC8vdl45mHXNEs7FKudkuR4KrH37oiCo8ZAPtPFj7zk/sQEg==
X-Received: by 2002:a05:600c:3b09:b0:45f:2d2a:e323 with SMTP id 5b1f17b1804b1-461fc6674f9mr32666305e9.0.1758134053593;
        Wed, 17 Sep 2025 11:34:13 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0f678.dip0.t-ipconnect.de. [79.224.246.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f527d6cdsm7187695e9.12.2025.09.17.11.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 11:34:12 -0700 (PDT)
Message-ID: <322fd5d2-d7f4-40d8-8a06-6e7c5e9ef180@redhat.com>
Date: Wed, 17 Sep 2025 20:34:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/7] mm: add assertion for VMA count limit
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 pfalcato@suse.de, kernel-team@android.com, android-mm@google.com,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-7-kaleshsingh@google.com>
 <eb7820ed-3351-4cb5-8341-d6a48ed7746f@redhat.com>
 <CAC_TJvctkyGEKv8mVE83D2DzCd-HiXh9co_DuZfwuF86FJoiJw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAC_TJvctkyGEKv8mVE83D2DzCd-HiXh9co_DuZfwuF86FJoiJw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mtw-5H-4ubc1z0V5UJ9iDpgqv_D0A6B_NKSJWoiiUlM_1758134054
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1AFE4160003
X-Stat-Signature: y1a5sjgfwwjpt9zs99397tahoriii4rj
X-HE-Tag: 1758134056-974600
X-HE-Meta: U2FsdGVkX1+c9CB333BGdxjLIGD1CBAtKZg53f3tM2VfdHWflC3r8vpi2sMvgVPl2o4Ry9yQkjXyYOym6oETUqmsRMlHejaHKu7NL5wAhApgHfEVzZ1e0/1MDD7jZJQ7fxgICKlYVkluruQlMkzpxumGdqKOZ4qEVN6DAVwhAGmdg1D3fMJc6MPJm0QxRm7HqawL86qzg1igkLiCVUKhGTVE0A7Gtp+RfJaufM/26R5WDzlx+W5UdZVsSDCvKC7VsffFgj+5Lofpg1LWCD01ZD+y0/A5E+e49TqQX1eQ1uTGkDvLz/K7xvAMJF0m+45A4pGjdmyML+hnG/HmSnSIzUEuwU1bHuH0WPbEd1PretYxvd+DyoaD2bCSKOd8zRugdu/NIoRECydx3zTfAjN/NHzF/AkOkMPQmcfIsYsHSRp76KxifKI0KXnXr2zeK0pwk8C0aIBL/OruV/yixM22FePIm8bP/YUpeIJBRUMVPiNx0GwNi2af0Q4BWN2iNMWwmWX1dEVKbxTyUgsPxRBcT0nfd8hlmNOtJg6jiAEsabdpDLjn02IR5NwEtOH9QlFuSGnJGqbvacokf298znwh+NnzO6xoarCXAIQ5orDDeQIW9cXpyr8Cgr5yHm1Z6LDncYQ643ZYNlOdyZuchb0eblUPMox3aM96QTiECLl4jXHWdDbGruIv4LTxumjdA7Uc6E70N4xhNgMVV6w051QgMtcuPrGvX8t0lcKQkJHkyP0hQwP3uttS6clPr9sM9Cg6H/OIlcMrW0uN+f1z5dR8IST5+ddP8ygJcNVPg4TWa73LZr3Kna3YuK3wVmdwkq9xbqXcypowpPnHDZnCoKxHPvrSuxOZJXjjZLRqbh/qgB96rs+Qhmkii95/4u48yerrDVE2Fhhf9iqVTXqH+MH/5v4B3U45KdGyzhaZuy+osWMIa0ecQD6+oMg1BDuFdEYFdNXnYNFyym354FPRXdw
 IzmbNzMD
 XdRyiKBEjkrRqMFTF5/v5FLIclY91qTqsAMYTpwtHZIXVIrz8BGKzLX3C53QYWLBkmycFVBF1HYB9HBfmrOqYOa6ZGxWaMxJbYeJEhmSbutdJRCZCRlItDjjZaJYhevlIuV+FarZAxLxoqITs49TzXto1FX0vtz04mP+zh5fBlxqQEqkJmbh2WUUiZVoK1Yb17FUcIN+6jZ/cemhBfhK98eLjDvJki1KGofbkKzHubCXyDXHzNDCSnm++cME/+07MqMqP3gRI5TPr7SherjlDF2Jn0DB79pVK3c9rlrkcC2v6vuQ2qSpnUAG/LkniRPQhOSVKj9MR8SV35eiF/UsXx25UOsIwPGzj3SrRpDDtP9+wFWXrR9TAbwf9qrJ2NngIRrqovTedgAKqBt/tizikmLkg6aO+HSlfH4At
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Can't that fire when changing the max count from user space at just the
>> wrong time?
> 
> You are right: technically it's possible if it was raised between the
> time of checking and when the new VMA is added.
> 
>>
>> I assume we'll have to tolerated that and might just want to drop this
>> patch from the series.
>>
> 
> It is compiled out in !CONFIG_VM_DEBUG builds, would we still want to drop it?

Due to the racy nature I think any kinds of assertions would be wrong. 
Without any such races possible I would agree that the checks would be 
nice to have.

-- 
Cheers

David / dhildenb


