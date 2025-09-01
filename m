Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87FB3CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F0D8E001A; Mon,  1 Sep 2025 05:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E368E8E0013; Mon,  1 Sep 2025 05:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D338E001A; Mon,  1 Sep 2025 05:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C63AD8E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:49:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F3F2140788
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:49:21 +0000 (UTC)
X-FDA: 83840208522.23.1941C02
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 07C131C000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:49:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M1I6Nx3C;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756720159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZPuTcB6VB1tT581BdsI3cxRxmrUkwCOtuVIN71SiY0=;
	b=ecdcnUY3vF/XOk+/dhGiTy+rwWxSJFaOLnstXFIkCvUUZIJaJc2QuqcEBEICIzXcnjN6Ev
	zVkq9qQlyFdCRIfwBcsT+86c1iMk/8zMbEKy/Xr/g/2d58ymephCIilM26B/tEBXCl906B
	yK4LaT18fFC+0ITdU0OoaMePMo9v6Ns=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M1I6Nx3C;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756720159; a=rsa-sha256;
	cv=none;
	b=g2AwfVtCi81PIKhDQeiIcTTzH07EaIha8MUB+h1JuIqJp4VRre2IOArS+il4veRIQZ6OOr
	ga4U+jIfciUef96P3drt/W3htrvz/5IM9CP6JMoOXCWd4+fNGDtXTkqXZAzME1COObf1NR
	D04mUs7Pf4WYwK9IKOeYqYYgST9Qtjo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756720158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VZPuTcB6VB1tT581BdsI3cxRxmrUkwCOtuVIN71SiY0=;
	b=M1I6Nx3C3JUaqQPAWKmeOPTUu0OQkxvy/hV5f2csfe/bV4Qon5LKBDuf3bJzrrh3gGWI4e
	3ciNUY5xaCtwZe7GOm0GVbI7UTBNyMsJwciX/K1MBWLU+0jMJTeuKCh5fSHx1NpYAsvDRm
	2YCd9bV0XPu8ISNFK625NJft86Qlkvg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-uvLEE485PyiJwAVl9dX8nw-1; Mon, 01 Sep 2025 05:49:15 -0400
X-MC-Unique: uvLEE485PyiJwAVl9dX8nw-1
X-Mimecast-MFC-AGG-ID: uvLEE485PyiJwAVl9dX8nw_1756720154
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b72ef3455so15659005e9.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756720154; x=1757324954;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VZPuTcB6VB1tT581BdsI3cxRxmrUkwCOtuVIN71SiY0=;
        b=h47CbCc+ZTYzUHyngfqFRXU2PKkFj/pRZO8WCr+iU38Cqi0uZO14Dlf6qEBNrvxXtR
         kMGjYzS5b0wUqD12kNTlcKHqmgcMHugcZY9g7+cvPaufW+87dr2HgB2xzsCeBWTI/Jee
         LP8lMxq+FaEprTKyZ9XXglvmQp4CnSOlWKg4Jmhej7c+mNAg5xWGxjlOeKUouJpDqAJy
         7dilXQZkXkFIxlWmKht8m/2iqDGEkrneGCSDKzsI8f6B6uqhT7ojojOFGIMz+WZko1rs
         G0hjqmXMtFya34lAz0lgUm7H/a9qvP8lBlC4I3phvvR5z1yvEkjd1AQu84OqVWXB0Fxh
         s84A==
X-Forwarded-Encrypted: i=1; AJvYcCU/4t+tJtaRskPnnVkIG0bOgWgohQyQS+/sTpe7DgQYfpMxLI5ZojjhN6Mt2caIUdnwYhBvKGsWTA==@kvack.org
X-Gm-Message-State: AOJu0YyYvnBnjdcsl7B5KWRHrxLKBjwOavE0MmUtTACe4yXh2KthknFZ
	msO69o+FzrHTjHIb3ZKinD8EnV4aF0lCqIrnuxRZdrRWh4AK7SbsExBv9VbhHkfwI/oUVMcNVAM
	JyprtzLiCeV65FakVp4c8j0QPzUUXetHLHfqaMt8hsKnLDk6TAA3v
X-Gm-Gg: ASbGncuaI17pfMZWv+g6scyr1wkApWob3m0avetGK+Rpq1SE/fVnErLsZwI9DRVtWlK
	ehIRD6rVOEN/16069NJqgZ1lewziCeD10rZtAsWCbzgk7JosIQeyD7tvY75eV7g4sFogZSNSn8h
	FjwnYQ5zWJ9YgasHTs673q0lNmAy4raDobx3+QB38kXklH4zVHQYw5e1PPw5XeEGpN3lwgcVzZx
	Be0ns8eiRmqJuzV1l3lCYypcxSUiZGJ7U8jmuwgSHm2w6qtohsjKJ+1efvxK1u0a2BJXZZovncj
	mrt1K7V6H++YBZd2MVkDpZTJU3z5jLdK1P/ZUielw+6BjZkAhKYfZP11BYTQeuyd5B3PcALM9LS
	GH9+nMluShOpt/L1lkCpYaTS2FIYicb2HuhJ32caG2N4Nydxkqi6HoG67YjgsttIQpdo=
X-Received: by 2002:a05:6000:2a8a:b0:3d6:4596:8a29 with SMTP id ffacd0b85a97d-3d645968cb1mr2767209f8f.44.1756720153851;
        Mon, 01 Sep 2025 02:49:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLu5iNoRf+fgplKqxO2NiQYLZV1Fzka6Znlu4Q9UX+booG2HzYxe9U9o/szemNQgDBT741Sg==
X-Received: by 2002:a05:6000:2a8a:b0:3d6:4596:8a29 with SMTP id ffacd0b85a97d-3d645968cb1mr2767185f8f.44.1756720153460;
        Mon, 01 Sep 2025 02:49:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf276d204asm14604463f8f.24.2025.09.01.02.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 02:49:12 -0700 (PDT)
Message-ID: <27a631f3-ebb9-4f62-8efe-989ad25e7542@redhat.com>
Date: Mon, 1 Sep 2025 11:49:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
To: Max Kellermann <max.kellermann@ionos.com>,
 Vlastimil Babka <vbabka@suse.cz>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
 <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
 <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com>
 <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
 <adb9e55e-0023-44b7-bc88-ed95be8dc71c@suse.cz>
 <CAKPOu+8wK16XWCx1+7801tyE66uLBu79CySLFetCWbS3TnH3bQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+8wK16XWCx1+7801tyE66uLBu79CySLFetCWbS3TnH3bQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tEeQHWqnaczqDV8lhtv9wNpHEnNA_H2eozyrxKN_Ahc_1756720154
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 07C131C000B
X-Stat-Signature: apj7wf8y84zp3z3c7xz1ses41ntqccia
X-Rspam-User: 
X-HE-Tag: 1756720158-239906
X-HE-Meta: U2FsdGVkX1+kJQszraG98hErT9/qcmGK+hc4QJh6Xoe2J8jjQNGGkKY/h5CFv1HBU+/2qYpySdrxTvtWj1J10Y3Wz5bzV+yIGS3IvEzqJQIVOdG8v7MRn/1zWvmAkYJklMqK4+cgUXhx4Vc/lBZj8KbYe3ysddplTfsSsdjIr8qPm0k1jSC2XcO/t+8OdK8TQv2wPO3uAMgdSQ7mkyrvFIdQ/v5syrSm4AeeDXFUG0UHUnglxsw3PRznKNCw8DEiqfKBFpuPEYIDxG5VFi+F7uiszNPo4WN6RNhVD7XXKTBbBcVGqx/BcOszugyqIoFO0zvwo+uuOVt4aZpbuhxfzpLZ3566lbpcaNtUhuptHaNjrgqiSRJmbQuz7Tbckzjf2mYpi1DWVxLp6uNVzsasIbqXnXEHdG1oN7ZKeSmBmZ8J/KkSQgKgQufKAa/yzNfKCgWoH49yDHvM2q7RyTplf4OVbHMq8brMOW4bU9inrT3trRI3c5dMqO93NaMUdzJjnkYOUrnY9zN9P7YajGf0O3pcagxQbTQqm35Hf+ZoNR+G2lgSsoCxVzvn2+D5sINEjqj8lksJ5AbHBJ2KPaMo1TA3cam3APBPV67ZjGkI6/ig4hs6o626psfXzSbO50cXSlLjDO9KHfvJaJZQujT2R3Mx/Fkn0G8Lu7xAPsFg/gPy1E8QIF6MLM8Va/E+N3KgB5J1oRxVNnf29uHcZmfaO9/NJd+5XWlaFg2EVIybxoNqRY035DhD2N8Bgj3gHoZuxszKSSoOJXOE5v5gA6Am1CN1gAPVeNpwFU4SZ4rX5QS9gs6tPcoadNgd4tsIM8I2QdUrOcsQBCqgD1ZJuKFc5lpMNpdHPYZI+Jo4dWmZhyc7KKlrGe+Zl2SY11F36AbWynM82y23msfeYIqzUcmKcNu9PBAeN8QN0CvSECqxWZIms0uk79kIIYH0o5lzhXzeiuZNvWhqSWTEQpnijCw
 I4e+H/jO
 AZXZ9UGLI2+eOr58M0XWZuaWapCUPlXSUaQzbBGCnkImxA1UVTTWqqV+4iL52F+Tgh19XPJN5/D2qiiIZ6jy7E4GNvD+WW5nPr2ThT+s8qCDTQLAjtqQqzPWzfarZQtNQYMnm6KynRir6s9MLp5sWCeJF3dcWDyZ/SJs4KiZaGrKqZX9g/O2UQhYK6pmgHescqQ8pyuQgHAvnJxI3IRWn/oG3jx38RXSivYTCwQ8zVnMzO7nb/nBxg9JXPwWI25k+C0d8EptPn1XAf8xqKPbQmFIm8U48bCBPb9hIsMn9yg/RBdBIeV8WrGGQTcR/VcErsJ7+4l5APx2BMmo07iaO9If9UvNrxUYtnkBCMNS11DhZhk+97LxVlkBZT5XBPlpO2u/vCBYdLbkERR5PyA7Do0FkoAf0d7ePGEr+lNWoT1dAVq+N/UHPyeHtPPd7qRmPHzp4+nCmOEVR1AtVxQrcv0TV9wJdLqCE45V58Xj3Vg+W7qJTwJcSUJyD7qCm5AlJsdKJppjytSkXZ+fm4nq7qTqAKAVjvA8qT7ouVrqT0mUHh4TqAFHZ6/5K23EJgkooh+CQb/c/oI4Pj5lsmcxY39zigclAJXAbQDw26vxm866IAZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 11:45, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 11:32 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>> Sure, but first I need to know what is really needed. Reviews on LKML
>>> are often contradictory, and it's easy to get pushed around from one
>>> corner to the next.
>>>
>>> I just posted v4 with longer commit messages. I think that's a lot of
>>> unnecessary noise that takes a lot of time to read, but oh well, if
>>> that's what you guys really want...
>>
>> No I don't think we want a passive-aggressive malicious compliance.
> 
> What the .....
> Your response is similar to what I mean with "getting pushed around".
> 
> You guys insist on verbose commit messages, or else it won't get
> merged, you say. I don't agree, but when I yield to your requirements,
> take the time to implement them, I get accused of being
> "passive-aggressive" and "malicious".
> 
> Please be more respectful when handling code submissions.

It's rare that we have such conflicts/drama around here.

If you feel like you need other rules than everybody else here, I 
suggest you focus your effort on other parts of the kernel.

-- 
Cheers

David / dhildenb


