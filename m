Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA075C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1D66B008C; Tue,  5 Aug 2025 08:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5798E6B0096; Tue,  5 Aug 2025 08:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F176B0098; Tue,  5 Aug 2025 08:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3873B6B008C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:09:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B64581A0360
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:09:40 +0000 (UTC)
X-FDA: 83742584520.14.EBF5A71
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id B6EC9A000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:09:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KrblC4N9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754395778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnDvv+RYZWrQhG27roIN5rQzgCLkdpLVj3Hura9BY24=;
	b=CvQG1c8oknIwiOu1wKbmZIWoXrnDvMFvnvdpCLWD2F8weoWjpZrQPfR828sSnZjkmgfFgg
	3G0JfUZMFNpETXkzJTgB7x/l9f0uKz4S1Hi7m2tJuSMk48XJpIdoD/La3xg9E4WEDW2Kng
	w4r2NwDudaxhmRwrjqen9pD0UDDgBAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754395778; a=rsa-sha256;
	cv=none;
	b=0cyOemYY+ey7WArSgR5PsUG0+tGA1rgfeu5QgPDNmMPH6O42NqPFUaPYv51AlpEMY02dQY
	Szi0iU/1Makn1uFSmoKXulYKjeQavWEGnv7M8jP7yXNsBU/QR6jcO9gWlF/CJ+pVQA2C4j
	twSBIlk4jDrwbFCaMhwcmM+I+sv45SM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KrblC4N9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4589b3e3820so54525565e9.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754395777; x=1755000577; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QnDvv+RYZWrQhG27roIN5rQzgCLkdpLVj3Hura9BY24=;
        b=KrblC4N906J23Z6b/3LWV2A1E6ioSR6l6aPIdfWTnpy8/1J4XxnS3fXDwN8Z8nYpI6
         LlpizJ2oMpAVwuMfWfjPe7JUDAVuFmrXtc32j0cY1QjOQ/Ooikc4wv6REyYGcnv04qGe
         vKf59oP+HpAA3XV3AGM63fEDg6NJB+stOYX7Y7MvDp+Vt9mwawbIF0JjdGgFQ+f+WowQ
         q9LKfRQY/vJDo6pNI+7xiHyNPDo8pj+SilI9RQ51RU/0QiyjNxJ3ucnHHNpCsTCCZxPe
         PRGXSRdQIKJSXKB9twM9KMzIfKqks5LWyFawra+tVkjS6c1zpqNNRpw2bRMUiu4CaL7F
         uKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754395777; x=1755000577;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QnDvv+RYZWrQhG27roIN5rQzgCLkdpLVj3Hura9BY24=;
        b=oVeLfyG/ZJrxKK8YJoWVnZPPpI/1XGIoHBqYAhbxj4WcNamT7x56j9Tl+k7w6sqyMR
         4304/4J6msYxfShfb5lWNwu6T/ayMlBUjaf8vMin+Uohx3vzoZoDWQL3Z6IkiywfXEx2
         6zfgEB8loayejZYs8bqDrgXpo4nXYK1AI3qO9wp7Fa86H6se/4+lXIljzqFmZjVLZ083
         DGRYupSPJSIjj6k754BGbYbClNvUsx82JSx7L4N9wd5J4KbRPE3pz6oo+gVNPMTYrs7k
         g1z5DnaebmJTXUvnYS3JtrYJPTb3OiSH7JOR7E6Tus8xM3NAC1pAq1kAiT3F3Zs7WLet
         54Og==
X-Forwarded-Encrypted: i=1; AJvYcCUxuH5g/xVftUMe6GksC7ZeMGPlLI/hXJPg+oFhICgn/pCkSEyNIyoyoEs998m498xtTZiAaZXndw==@kvack.org
X-Gm-Message-State: AOJu0YzHnHTbq1dsPhN9lBx6anTySR1Tt+wqKj5bSX/QIcNL1AtSloe0
	BHrIhg7aSApAmIHFouIAnLj5eLnoxCHtN8d6fCf1A1mglWYYvaEogfOR
X-Gm-Gg: ASbGncsUfCisxOcS1gvLoczWoEM5QKjjBlmN8yP73zsEXkRzx79Jm7kHCjMJtbXseq7
	V8zu4e+JEbKx96F7RSFPWoh/26IWjNQxiobYuVpKucVa9muEwHBb0ErSLazBj6JK5/eoCwu2xdx
	DzvhyJ6JU3tqZCHRCqpYzHEKY+V4b6uirJHhMkxSF4hhryqTb3tFLqpfkTUU1253Ezjn4CM2HKH
	uuYkoC3GO4SzioIh08ojdx3EAi5DSHkkHzVEITW5zpuOecavJDRoFBC6Tski9xzby9OXSwQ8PHo
	nf/BbuoTbXSI0UVCYUR5w2QW/4d1AtCB8GDPouQWJkZ02wH2HdY4EQIC6kJgQCs+kPVzHMF0cnX
	dztOW5NgxBF4JbwuwjlJzjzsjSIJ1p9pMXeY2AgEmyr8O2qFqbT1Yl7k7EoGQuBF6OyBsiTE=
X-Google-Smtp-Source: AGHT+IHaZvpfuNdcteCmnFuvch+C+rl8ZmnFCmfkcK/icZCUVfFy77dZQumTyON7VuwTLmN17F0Guw==
X-Received: by 2002:a05:600c:4709:b0:459:d46a:ee3d with SMTP id 5b1f17b1804b1-459d46af0c7mr77845295e9.2.1754395776562;
        Tue, 05 Aug 2025 05:09:36 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::6:98ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e58400f5sm1048305e9.2.2025.08.05.05.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:09:35 -0700 (PDT)
Message-ID: <4cb3dbf4-87bb-4946-8e43-36dcb5d9fefe@gmail.com>
Date: Tue, 5 Aug 2025 13:09:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] docs: transhuge: document process level THP
 controls
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-5-usamaarif642@gmail.com>
 <7828753c-98fc-4f96-bf7c-0d94f3b99e4b@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <7828753c-98fc-4f96-bf7c-0d94f3b99e4b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6EC9A000C
X-Stat-Signature: psoba7r3fyqmqk8hc5m1ouuftd9fbhtr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754395778-399692
X-HE-Meta: U2FsdGVkX1/pKxyLF4//ZfGfVpa/10EQi/AgqodzvGWAiIvIbw30P61hjqWgdyLein3LWAsz6GiY2MivF8r/3KPTas8XcrQDWCT25KgEcRhV23tneo4WV2EnXJPdJA6U8mpOWOrXxQQEf9BLpV9ooJfHsw1M69GArniP8TjR2bFZVG3QpMl9ygmW2kiw+yb3mD7rK5Sw/Gkq+NMaEaf8vAkpe/zAgEAmOi+HyWJ0sLVEnxmd1Jvbfpf5ixo7tn+sJFhJuvYDST/Lfe//uIjEnCmXzI4gHbag97kvDZ2+dRKecZ2l0om68uCogI1SADebAbLePoOnzB5jFOzbpxLZQT9KBXTJwuaalqTrtNJEcV9b8XkGbaPNHt7n67dctj4sJOrH2aeeUeAyNxiBvL0rIU1QfGd5f368G75+tK4knjYb3HvlKGdkUA4noosY3o8E/adyjjElVlHV62w0StFJ6QPHRZ9uOVu9HJnBVSZR54Wxbaqye7TIFVoaWo00q7DGWb8fisObVhv5gnMDTOsqUjRZbazERk1ZHWkN+qMVbEYNqWjd5LL9T0Xqy5QZtKeUTURfukgRpfggG9iIZo7V2Qf20DiNo+wG9mn/x8IynweDpF7qUrivVi65uxXR5+N3KQ5gFVgjJGPodYJnrQFFngJmWgHOZwY1fnP8n2ggLPiPt5Lk6IHktjEmfUXQ2NTZmRVwVUFDRlsuTfnitwHhjL0aYzugQHGMiOB7H8F5cLi8ndwMX00ewdwgUsW68q7qABtEZOH1YqoRzu/9oyauiQX+gNQrhMu9rr72Hn1CDhWdfVU57fRU+qc7vewZ1IDesJMDdMsnS5Q5P50mHyRlqnHl1rBeaCrWvNKrRgZ+T0iBESko8xyMRQvXhubNPvM8k+uNrIzhTlEvvKa0CzVlWIh710L23Kh2Ym5eqQDSxQeYuzkcpcOmiAAHZ2v9H0iKVTDlV4QDrMKrlKJq7GU
 1hfhzAo6
 /Cbti7N+GtNSLWesR9RrZKMyVj4XLsQho6SI/Lt1FHelcC0iCZnFvXX6cikyQ93f4L2BaKzDZ/JzafwW15yNJ+T/tzVIFksT8/URpuaUOtQwbA6ywsgawis1gK2Mrh2vTWf+biLRcc/JvyrkqLRSdpP6v40ud47fDAOp1aE8THG0BeT2CQpQWb0S8YHjDSxUdsZj1ZrPEkIt15Rny+GLapKWohOgUV2kOAZqkJnjdOTHLPBRpZYfBkms3VEcOXvb4oI4gdgcM/qCziuHVrKyyaYIf3/JJ/eB+7tSsE4C1YVZUfDryjhEhM8NOuCNxWKbMYildwlvOFM8vO45vTUKSAlj4moJGD18eY0NkY/U9D3c7vTy2+HTV528rySFzl5Bj9Kx6Q4lz36hiUfVDKDFmr2cMYWXIWhBZAIBnDuV6iK2sElkoxiOHzKcRApj4UlicSTy1uBx4RCvxHbb7vcwJj0J440XNvE3IcvlmLKPUVqXZEtnCVVchkvxu5eRC4stRpi9RDPQeecVPJVzZEfVrswaD9scP6zKrNiMOnWbONslheb8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/08/2025 11:24, David Hildenbrand wrote:
> On 04.08.25 17:40, Usama Arif wrote:
>> This includes the PR_SET_THP_DISABLE/PR_GET_THP_DISABLE pair of
>> prctl calls as well the newly introduced PR_THP_DISABLE_EXCEPT_ADVISED
>> flag for the PR_SET_THP_DISABLE prctl call.
>>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>> ---
>>   Documentation/admin-guide/mm/transhuge.rst | 38 ++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>>
>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>> index 370fba113460..a36a04394ff5 100644
>> --- a/Documentation/admin-guide/mm/transhuge.rst
>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>> @@ -225,6 +225,44 @@ to "always" or "madvise"), and it'll be automatically shutdown when
>>   PMD-sized THP is disabled (when both the per-size anon control and the
>>   top-level control are "never")
>>   +process THP controls
>> +--------------------
>> +
>> +A process can control its own THP behaviour using the ``PR_SET_THP_DISABLE``
>> +and ``PR_GET_THP_DISABLE`` pair of prctl(2) calls. These calls support the
>> +following arguments::
>> +
> 
> Not sure if we really want to talk about MMF_ internals.
> 

Thanks! have changed it for the next revision according to your suggestions.

