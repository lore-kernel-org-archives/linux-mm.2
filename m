Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D14EFCCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DF48E0019; Tue, 21 Oct 2025 12:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265E08E0002; Tue, 21 Oct 2025 12:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154A48E0019; Tue, 21 Oct 2025 12:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 04D138E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:34:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9711C88937
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:34:52 +0000 (UTC)
X-FDA: 84022670424.25.AF385CE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id E60A12000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:34:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bOA3n/OB";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761064490; a=rsa-sha256;
	cv=none;
	b=IzvNUHOXphbYrEe79CFKhsXrHWtBbzgamk6NSJY8WE4PEfz3sFZsHj9/W0FWNUlPsYaY3K
	P8aXFMWueFwkiAa1KLwiSsecWYigBvNvzjzUG7/3H1PwRH30/BRn7w2QlpXdwRIj7oJpnV
	lUZv0/lBfUX8NCFO7RQkPAVe9JdsSbo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bOA3n/OB";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761064490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wy3KkG6oRebhX1NKLdpEORcPWI5cQ9xYLP4wRstRwtU=;
	b=Ws7ow8/dIhj9OKw+nHJqaeXp2aBl0TFbUdkAHcROSdag/HFGAUu0fgKCxcjdgB+7PEEZsb
	cu41C+f9EQiAfkzkvj/7JQJ/LxpDENbG5OIKtQIhkjsnCJ7f7rnOOqkKjPGWQTHRwBRFfv
	tx+OlItmplJ/FiIJZqRke32uOcUFIiQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761064489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wy3KkG6oRebhX1NKLdpEORcPWI5cQ9xYLP4wRstRwtU=;
	b=bOA3n/OB9mZQNnYCpL5Le6c46dvqf2QjFnVppvPrRyFqPqxxuEX73DbHkty6b2OW/kzDF2
	Glwhze4XJyC+gE7fX4XVCbvdYYygjCkdRqPFy81d4f8z9ePgWSL714a9C+OYwCsRp3bxJ7
	1HB9mxEC9jr7es14DqgtbXkD9sG21mc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-glranOpYOr-T4bNohoTwzg-1; Tue, 21 Oct 2025 12:34:47 -0400
X-MC-Unique: glranOpYOr-T4bNohoTwzg-1
X-Mimecast-MFC-AGG-ID: glranOpYOr-T4bNohoTwzg_1761064487
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4283bf5b764so1912620f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761064486; x=1761669286;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wy3KkG6oRebhX1NKLdpEORcPWI5cQ9xYLP4wRstRwtU=;
        b=vcROppa0dxpNzEg578Lj0wE6RWzIZ02Opgmob3cc2uAmhEFMiDi8ZsbG/4+dH+LzDK
         8vgnJn52TUnOqVY2U9Mt4cZi5VscNhx66GGdVs3Ajcwwj+3ndU1btdXkffZTvS2hTT4t
         MIUL+5WvgQAlzxPPREt8D+7v1dBVbGK2QVXxsAqjnE7qbveDmOe/UX9iHi/tikfeZ5eU
         aRIXZ0mCB8uYzJk5nRJ399ffU4HaSZLp97FKyeMi0zZgKsKd8sQLAtgVi/3uymwU9n2c
         a3QjAGqbKth3X2brg2Pqe2r6QR/KDUTy76SNDJUXjUy1R4zL3+mNgJ0xy0DlUOIjFu6D
         frOw==
X-Forwarded-Encrypted: i=1; AJvYcCWTGIO+6nE/fxmjVhVtWHFfzPXi0PlDFY8YZHAv2FyV8p6gPF7Nq1bUMqoX7CN+Hxp0zbwTRlkVUw==@kvack.org
X-Gm-Message-State: AOJu0Yz6jlhq1udiEWa0TlH78Rqnj1nZ5c8l+e+lNiH8f8pI0HAyvHXI
	Kuo203hZEBzF5b5pS+cJqPMN7d7fp++WZO6vYGQ9hUgqf/Iny12V1GgMuMAmOyd6KwpnqES8Mqr
	5ACvyU/yotetb+UQN6LINvJ64X9JSEnLl2mouBxTcPQOwN/FlXYSs
X-Gm-Gg: ASbGncuyk1cELe13hp23g1OQvJAoMZbyN96lnQecavG6/pXlbkTvUxl4E1xvZV9qIRj
	evZPnluaq3biytVp7xFZOXN4Nte9FSvquyIbB6XcbBbBZeB9PiqY8aZjEw2jHuxks2GQ/4Qfg9o
	/zxYa/63RcIlzoBYXq4ldskmF6E89YSBQ6EfAhqqbNvHwwjvwKhxD2w5LV8twHbl7t0YBgse3Vv
	abny4GKQ1DEk7gGzEVYRsECteRvdB9n1yoTnlH+DeWNI9Gw352mjBkX/3sMiiHDr7ngtXbX1NYz
	sdFYc8EOSxJdjYJWI9VIlzJfl3FfqsBRMzxXFUcJjUcY1yXqhV1QDRlqG2e+WF6jnMkJarpCkRA
	1QpkLf46MeOBytbHRgmvmqQnSPM3omKUe/14qICbypZ0f1BVcD3IflAUiwFzbDlUh9Qi0zwRUOO
	5TPa+8MKdm/jYnOH1uygbVPVw3Ydg=
X-Received: by 2002:a05:600c:4511:b0:46e:1a5e:211 with SMTP id 5b1f17b1804b1-47117907a5dmr114685275e9.21.1761064486568;
        Tue, 21 Oct 2025 09:34:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWNAPl5pmlvVAdaFR2UlipcgwDtQpKyq9wnXhriadYJHXpZiGDT/KPnk8o+XrjpJWfkIU3Rg==
X-Received: by 2002:a05:600c:4511:b0:46e:1a5e:211 with SMTP id 5b1f17b1804b1-47117907a5dmr114685095e9.21.1761064486093;
        Tue, 21 Oct 2025 09:34:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-474949df22csm22132695e9.0.2025.10.21.09.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 09:34:45 -0700 (PDT)
Message-ID: <dafcdb6e-be12-4b86-959e-8510a9622358@redhat.com>
Date: Tue, 21 Oct 2025 18:34:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing
 testable code specifications
To: Gabriele Paoloni <gpaoloni@redhat.com>
Cc: Chuck Wolber <chuckwolber@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 gregkh@linuxfoundation.org, linux-mm@kvack.org,
 safety-architecture@lists.elisa.tech, acarmina@redhat.com,
 kstewart@linuxfoundation.org, chuck@wolber.net
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <20250910170000.6475-2-gpaoloni@redhat.com> <878qifgxbj.fsf@trenco.lwn.net>
 <85166a8a-ad54-42d0-a09f-43e0044cf4f4@redhat.com>
 <CAB=6tBQP3aCDWch4ZcEYMqFsJ4OKXSyC_hb9V9hA7ZZty7vFeQ@mail.gmail.com>
 <042629f9-f295-494e-8fbd-e8751fcbe7c0@redhat.com>
 <CA+wEVJYLF9T21-V2k0Y0zxcF0zcRG64QUVrM=qHDWHz7+4+ptw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+wEVJYLF9T21-V2k0Y0zxcF0zcRG64QUVrM=qHDWHz7+4+ptw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: crZ-0RUKtJTwkZqCwRvg1msLdXH8PF3LXvSSvRfbQ-8_1761064487
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rqrsrskk7poywj3kk37pbatfxmnqd9hz
X-Rspamd-Queue-Id: E60A12000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761064489-383514
X-HE-Meta: U2FsdGVkX1+TlqtG97gW6WC2ZJ006poIvMFAVFzGH/JpVQifQP5X8XcJ/muQ5jBiVEcRgz7yD9bfyM4xC1loaLNfkZ1LIoWNxYvOjOkHW8FMjETkNvP4u2RAfopjHG2QelE2BEYqFfnwiAJT2Msc4hmA3NR0Y0nr1hkRKO9xPqtXO5ccLl8h0ZQ6lAucyyh4FOxb1brxrBVBhnAxyeEihYRvNpR5ijR1cBfHPy1+rfwAXRUf5wotuYiEVAPFWtE9W9oydGHcIdHdKy1oiRtCl8+ElMBoPokkiYNk7KiGyHEDpahrVbtpaGl1vvGPuZcXpehXjdqYgpFo9OxZ39qFGfS+mHdnPG8L1HjwTuoqjb6FnuVOmHgYOR4IY9EIG4F42Cjns2+PIDi5KOGm1rSBVOJmPbRV3Ng1+52LN8N8fHt/q+maRlKu0NEcH/QzWLSq/5m1ZHP37AYhoHVnbEhY6eHbh9lMgqSNNBHDok+5ngLdiOjZnBLr2eviw7njieiHgR0HidJQwEtN/UlaRX3XvIGP0A3VfTVJQm6oR8s7h2VrOfqfMwrMCQNXgoW890QVwxqn1vKBA/hHuWHVUp3MXfTyqE8Y9QQs2B7C3Jvy5S822u84vMMlC7G81QJ1Deu2pnYT+CmgKTONcq9S5oDPGi87rSBsHeBpVKU27keQPcHJAbaiInboHQ2jXhzds1z6gk0rp2vbJb/dRYUI7P3uY/0yiODwQ3dfX0SPcfLNOpbBYPqzOrwWKfe7APWFBYg+EoFpq4JK6To/VqIdSOxC1SDCr6MvlPLHfOYWAWgGvcvk9igHpQPLK3MinvCm0l/8mG6o6zqtdDO2gmpk4UFsJzBTTMz+oymUIeyjz1iogcK47CJz/RPWtLP800tHWX/6OhFyJ9ukYLVIT1FWpJESeJ8FKdLZpyx6hJMvJlZX9anlSwGxJRK9X50uOQaQX7aPU2j1HBm2CzpmdQJSF3m
 srmhQsn3
 aZMsVCXJb8DQckUndk8o4Kcn7S1i4siE766gHNcBb0V0N5NK9g1J1BI0bowtd/l7uvuY8Lqii7Qw1hgCU15gc+nkfGjTndmWju0u+gBFFtaAZsI0da/b09QVh5OBatIq9yZyl+Q+UUVsrcgK2e2wDINqYwC+MoH8G9G7/dg50o5PWhITLx2NYE5l0MduZuqv3mNOCku7Is+MOvD1Pc9eY+66dhJ8YpwdY6L0LU12ViPq/P9oGrsUM1LgST9HPffhEleDD+rdjQ3GusWjl9IPwic6o7cZHeWuLkalYGjyjdFK2cjBE8RVsv3jbH2kGmEOEW3ZOqXwL1OG5ezbVAxFUFoQ4F567UHGmkFCvjP2JjGoApgyUQRqw4UUHgPnnWvBvZms1BH7LVQOsjW2iQFCC0DUOV1Dueoy79/02Wa8J/7v6Br2v7IIwL7UEWSRyLWK8N9dkSF4SBdC5gJvCnm5FGg84nAwTIJNxYuF5VOq0gHwiX2OwDSyHun/Czml674dgPvDsfM0JpSPxydvH7VrXF96LUrU2GswxVi2fAqPharGj5WGscWFyKCfLHuPrWPZTzOlkY5D61JT3q2QcuNBlDtw5/5BP74oe0EMz+6y4V2zmn38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 18:27, Gabriele Paoloni wrote:
> Hi David
> 
> On Tue, Oct 21, 2025 at 5:37 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 20.10.25 23:02, Chuck Wolber wrote:
>>> [Reposting with apologies for the dup and those inflicted by the broken Gmail
>>> defaults. I have migrated away from Gmail, but some threads are still stuck
>>> there.]
>>>
>>> On Mon, Oct 20, 2025 at 7:35 PM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>>>> +------------
>>>>>> +The Documentation/doc-guide/kernel-doc.rst chapter describes how to document the code using the kernel-doc format, however it does not specify the criteria to be followed for writing testable specifications; i.e. specifications that can be used to for the semantic description of low level requirements.
>>>>>
>>>>> Please, for any future versions, stick to the 80-column limit; this is
>>>>> especially important for text files that you want humans to read.
>>>>>
>>>>> As a nit, you don't need to start by saying what other documents don't
>>>>> do, just describe the purpose of *this* document.
>>>>>
>>>>> More substantially ... I got a way into this document before realizing
>>>>> that you were describing an addition to the format of kerneldoc
>>>>> comments.  That would be good to make clear from the outset.
>>>>>
>>>>> What I still don't really understand is what is the *purpose* of this
>>>>> formalized text?  What will be consuming it?  You're asking for a fair
>>>>> amount of effort to write and maintain these descriptions; what's in it
>>>>> for the people who do that work?
>>>>
>>>> I might be wrong, but sounds to me like someone intends to feed this to
>>>> AI to generate tests or code.
>>>
>>> Absolutely not the intent. This is about the lossy process of converting human
>>> ideas to code. Reliably going from code to test requires an understanding of
>>> what was lost in translation. This project is about filling that gap.
>>
>> Thanks for clarifying. I rang my alarm bells too early :)
>>
>> I saw the LPC talk on this topic:
>>
>> https://lpc.events/event/19/contributions/2085/
>>
>> With things like "a test case can be derived from the testable
>> expectation" one wonders how we get from the the doc to an actual test case.
> 
> Probably it is the term derived that can be a bit misleading. The point is that
> we need documented expectations that can be used to review and verify the
> test cases against; so maybe better to say "a test case can be verified against
> the testable expectation"

On a high level (where we usually test with things like LTP) I would 
usually expect that the man pages properly describe the semantics of 
syscalls etc.

That also feels like a better place to maintain such kind of information.

Having that said, man-pages are frequently a bit outdated or imprecise 
.. or missing.

Anyhow, I guess that will all be discussed in your LPC session I assume, 
I'll try to attend that one, thanks!

-- 
Cheers

David / dhildenb


