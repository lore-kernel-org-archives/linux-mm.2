Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AB0CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BE590014E; Thu, 14 Aug 2025 08:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D75900023; Thu, 14 Aug 2025 08:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADAA90014E; Thu, 14 Aug 2025 08:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7700E900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:00:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 025321384E9
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:00:40 +0000 (UTC)
X-FDA: 83775221082.09.9A999EE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id E00B11C0014
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:00:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I9ochfcW;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755172838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMOpUdH6nt0bz5vi3YcX2PybgsEQE6JlF+rSmSMMZuw=;
	b=BJMa3i03xV+hlHd478zOpOaGn1IsWSaWnqMQLm4RXTY7yuh9zOJrHHYc/XzTmdmZ/MG5Kz
	LaTZ4ncbqbJjaSA6pqHvB+nHb6+cp5upwo7/IEGtJIsqnJJkPRB+p8dClZezK4ktS1tWR0
	iqxlgvKjhwpARyKNBiO+tTpDTQEMGO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755172838; a=rsa-sha256;
	cv=none;
	b=XJp3ddHtV3TT8zRatkiJKeuXSXDW5fbf2OzaMSPbvgUexJ7nXNzo+sQHPSImFbsTJX4oXC
	EDjXlAZMih6HFzAnFBkFyv4wkUqDrH9W1ScP/7ZaILxn6JQr3p9+uYlxoVksicHRJSKUTn
	b9YMKdbw+V4BiVoHWN/UUdrmdNCIDvA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I9ochfcW;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755172837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jMOpUdH6nt0bz5vi3YcX2PybgsEQE6JlF+rSmSMMZuw=;
	b=I9ochfcWG4dJWAQh2he99UUlHY9X3g1Iyiv9QQxPfr1KtepY6aSM9ADUdcJq9w8fd9ylp+
	zNfdBqLL0jzp1eNkpa6LVO0IUXg599jP4yLKTofvK/V65McM4BSiTkJe2HtaHxpQcjG0Q9
	LZWhvK+iGLb3mNZIubBrilS+slrKwaQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-ICvq3nuwPwKo6a_kW0lO4A-1; Thu, 14 Aug 2025 08:00:33 -0400
X-MC-Unique: ICvq3nuwPwKo6a_kW0lO4A-1
X-Mimecast-MFC-AGG-ID: ICvq3nuwPwKo6a_kW0lO4A_1755172831
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9dc566cb4so469051f8f.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755172830; x=1755777630;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jMOpUdH6nt0bz5vi3YcX2PybgsEQE6JlF+rSmSMMZuw=;
        b=XcZjhKXkzJYfw/6qJG4EYGM7ixC8D5uV1YByg7C56rCxCF0FpHWrMlK3S+GE2P9OcF
         cXTpKHOD0xH8qOfUDb3//nfIb6FpVnnXrQP3AaXuxXOGV/RQP14TJTq4jF3JoUM2+a3q
         47jhde7oqsWh7adZNdOmmoUmeThzNnp6lVNLQ+eWQb7bqDA9bvsJsxjymF3Y4oc4zpjC
         sZJpuSYwpQZ9OGsjtUGxWWonkF2azXghmMtXDXBm7gc2rPesPBi2R774qatttBKi5G0m
         zMJc667/6afGi65gUr9NMYPbJgvHe38ciSoV1OYhmpIG0lIIRSZtaRjFTrLz40Cuy67p
         ga0g==
X-Forwarded-Encrypted: i=1; AJvYcCW5i+xcYL1TqLya6TIzGQC7f6S+TK01Q3Dn08zMxuYox4XjLOdy4eK2YKcQWydZV3Z1eqWad5U16w==@kvack.org
X-Gm-Message-State: AOJu0Ywmc6SOz8fhyeFzqhByMvAxuUg/ZuVfx4gpyxCIGVMIUiUEUoiW
	kez4qyxEySbwPDe6cIvIz2AmFi/5koolv2nGBDjHvat/NJt9y42imgatsKM1Z+JC4g5F9bBe5Bd
	Bc48GbN6xQj5/qE/2WSdf4V3IZW1m5CFJ28Q8bRgxTCcYAV6q5ls/
X-Gm-Gg: ASbGncs0ulMR4ASwdx35/Is/O1IStwm3H43mXlGYysBxpjBaSpe1GkfwsxJnfpWl/mq
	/bEk7DJ13Sc09aiWyIB8s+kxESbQRQlM9x8Ezy8skmDgBaZ79xkDH4OsrfGMOX496hWTp5wpC3/
	8AXLQBBiiGNrrHNgdbU9OpFG5AFpC6lHbczDDnxSWlzLfgb3cDBhxBtp2FdDGHJspIqVZy9+O2m
	+dEhYYSPyIYpBqY0SYsUEF+Q7D9AD88s7lhpXkmjxjIPCTI176ec1Tcm9GO4eG96RuH/DPAFZAg
	Je9DAhHm9rluX3kMexifR1yhIZj8gxkjOIpiEzSE543BH/t/LWk1zVImh4LGVuGYOt4Tftjdoo/
	r6RxBcob1BLoNVYQGqPYYuCniZnAMwM1E7Q+cJdKz72wX0hxrO6/aiRTppusxfDFnXhk=
X-Received: by 2002:a05:6000:290d:b0:3b8:fb31:a42d with SMTP id ffacd0b85a97d-3b9edf2d89fmr2303926f8f.34.1755172830304;
        Thu, 14 Aug 2025 05:00:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGR7Gbb/a7KdvZFKZbHjM30mGxCSwKqtT1kjDippjk/ajMehZu4vEs2MURGJhjqrCAMRSCGQg==
X-Received: by 2002:a05:6000:290d:b0:3b8:fb31:a42d with SMTP id ffacd0b85a97d-3b9edf2d89fmr2303881f8f.34.1755172829807;
        Thu, 14 Aug 2025 05:00:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4533e6sm51836169f8f.35.2025.08.14.05.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 05:00:28 -0700 (PDT)
Message-ID: <eb90eff6-ded8-40a3-818f-fce3331df464@redhat.com>
Date: Thu, 14 Aug 2025 14:00:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Mark Brown <broonie@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
 <0b7543dd-4621-432c-9185-874963e8a6af@redhat.com>
 <5dce29cc-3fad-416f-844d-d40c9a089a5f@lucifer.local>
 <b433c998-0f7b-4ca4-a867-5d1235149843@sirena.org.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b433c998-0f7b-4ca4-a867-5d1235149843@sirena.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9egNbZA3TCYUYJcuQuLKgwI4SfWKZDR4Uru6DPgeA5o_1755172831
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E00B11C0014
X-Stat-Signature: heb9ffn7aynu11qfi5tbdr9hzfrwbryq
X-Rspam-User: 
X-HE-Tag: 1755172837-699067
X-HE-Meta: U2FsdGVkX1/0Um0BSkbi4qxhNoN83BQP0cYPmyDST4GhxMKlCExTpkTZQ82qraSwnfZGhnoAZStxtZm8Dm+/5FYx90ELobPJnixeR36OkYf39wm//zkK6YnE3+NmhcL6AfBkO5dX4284Qqi0Ww6j+NMXy7UFAmFVrSmZ2z5FpmtHzsgP2/X9TqtxNwhEwtyfvZFvQ1hmcSu3nMUtUKoix0iurgDMhh9pojOllsDO1oxc41PyW8TNuid6+ojSR6fsq11Tw1Em2L5Etx9wpOIuRSg1n3YVEwQxnHIxGg+0hB5RWnd0ERZOA9+iqR8wv9E+qkUn9Gl3z3lowhAC07husMrJUk6n70m7OEFvSYrbygMWsU2VaeeKdfHaxZbyyElVlLJnacg2qIF7w7ycMYl8z8ztPT56U53IOQPdNUBbkivABDU7AH+eUz5yVxwhLCbVukO6YxKFMOx/TETaIl48hijRa9mgTS2kKdn+QOsnG43pi2sl3CKtubx32BZpzAqHPtWomYi7yt0zRL++fc8pZeFyjWp7kEj4401eaft3DxhmIn7UtY5np6pbqisx6Z98wXw2Btj5G5eNiCALJKPpc6ZeN82fEV6sVvlmFsemKjhyPh+dw9aIFBgAaDhiiZNlNNUC73QWt5QGIvwXbxEVKe8CiEU+xyWxYtQJnBAKFwym+ZqVKzjbazaib847SPnsztIGTVOFFSnE5F7XXdMQTp6JhKtQvz3YJfP7VLxEG5R72q+02vY97oD9ssnDSov5RPGwbV3q1tf/GI2v0kapzlGu/G0+pNYFwbYeUEwJKUxQBz6TCaawzblOABVxWgvcbaaVd1KG9GuPB7swy8IjfgbG+BHL/NgLWgLqGQ9n2/Ww+9Dwfr9t27gapC6qvwuoKS2bV9AtRqAYoNZcbMQmP5EHrR5igyoqDqb/hJLAZ60+/3KH0CD0jV2juW6azV2Mep3Ymi4TMJfq4DZ5YxA
 9+gtEqAO
 V81gMB1vWm5ANEoyF4DOcuKbfJot1XXJYP8jGqRnpyvpC/wbV206JFdxC0Spynk+hR63rT6/uk3XiuHF/OF35f0CQ8KCJUwJGesTOP1CMkq/kpbw98p1HUV1A637r8MKn2+K5iwRu3X4hQRwvqTbg1mHyrx+J1iGv1ZodZe7F9DkYpn27wj8hMd8WgPqnk9+UYKNAJrQYLthsZ6OexQJi52CNuADbPAUGLcxw9I84zZuLIaXBcvfT/N2tyFUkLogytSujv7xl6pgceq3+uVfJIvaO21NZ9JjPxuNDxT9qc9vBRGZ+oqymLh1YNkzEMP3TOMEdsBCpzYdNeWfQT4UOyPaKo0rYzmy6ZYu+3tmF4fWh2Tngu2d0pUptyLut09vNx77sRU+BbpP5kGcGb+xyFsnWiRTCSqIX58Kiu0ju4k49mipgROUXHemaw3nGpH0wu/v7jcxy/vFomCbsrNjOq0yLahEl1IkFhAEr6pMuqanblLljfwDHUCrqR0rLWW1X/EEP2ulAjvujG5okg98+Pf3O9hO3twvZySZtIzX3eg8Ymn++AYjE5ZiMaS09cw35yXDi9eGmxeYLcyH49BB4CWqQbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.08.25 13:45, Mark Brown wrote:
> On Thu, Aug 14, 2025 at 11:49:15AM +0100, Lorenzo Stoakes wrote:
>> On Thu, Aug 14, 2025 at 11:32:55AM +0200, David Hildenbrand wrote:
>>> On 13.08.25 20:52, Lorenzo Stoakes wrote:
> 
>>>> I can't see anything in the kernel to #ifdef it out so I suppose you mean
>>>> running these tests on an older kernel?
> 
> ...
> 
>>>> But this is an unsupported way of running self-tests, they are tied to the
>>>> kernel version in which they reside, and test that specific version.
> 
>>>> Unless I'm missing something here?
> 
>>> I remember we allow for a bit of flexibility when it is simple to handle.
> 
>>> Is that documented somewhere?
> 
>> Not sure if it's documented, but it'd make testing extremely egregious if
>> you had to consider all of the possible kernels and interactions and etc.
> 
>> I think it's 'if it happens to work then fine' but otherwise it is expected
>> that the tests match the kernel.
> 
>> It's also very neat that with a revision you get a set of (hopefully)
>> working tests for that revision :)
> 
> Some people do try to run the selftests with older kernels, they're
> trying to get better coverage for the stables.  For a lot of areas the
> skipping falls out natually since there's some optionality (so even with
> the same kernel version you might not have the feature in the running
> kernel) or it's a new API which has a discovery mechanism in the ABI
> anyway.  OTOH some areas have been actively hostile to the idea of
> running on older kernels so there are things that do break when you try.
> TBH so long as the tests don't crash the system or something people are
> probably just going to ignore any tests that have never passed.

Some people (hello :) ) run tests against distro kernels ... shame that 
prctl just knows one sort of "EINVAL" so we cannot distinguish :(

But yeah, maybe one has to be more careful of filtering these failures 
out then.

-- 
Cheers

David / dhildenb


