Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A710C106ACD3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 17:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5826B0005; Thu, 12 Mar 2026 13:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D556B0088; Thu, 12 Mar 2026 13:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C8F6B0089; Thu, 12 Mar 2026 13:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5F086B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:28:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63F971C32E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:28:56 +0000 (UTC)
X-FDA: 84538096272.24.40593DF
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 73EC4100017
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:28:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YbnD1oFD;
	spf=pass (imf05.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773336534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DI4uIRiym7HF+uV8f3Y+IQhxu5vX/UZXiPwGeaFqfEc=;
	b=O70/n5X/1yb+FLyRu6cPwdgjqW9LbG8IgxVa4RUGnZXktS9Fvs5J+sRY1k7kXz6tnsCpcT
	fbVlAWB78KQrwXQm+hsrcV9E9NYo2zuadPH/gMfDCZ2OHOFCtnu2xSfQzCCC4hY9SCyK6D
	K70BfqWEwNtNd36v3f3gm79fBLNHW8A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YbnD1oFD;
	spf=pass (imf05.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773336534; a=rsa-sha256;
	cv=none;
	b=RDjUp/JC9rxE2oDy3AlStwlzC/FnHXNDWJLFcq3e3Xf8m+hZxntUWjXmeDTnl6qvnBdCZX
	B6L2dpNgB5ehUIS0t50Ck6EFCVF/YyebDjzukfpx/Ks+MRiziJaTiXwOZgh5sC0RFh7NXi
	stFaMAiDQg+H5TeYJDbqkvnalPfx9Ys=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so14374205e9.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773336533; x=1773941333; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DI4uIRiym7HF+uV8f3Y+IQhxu5vX/UZXiPwGeaFqfEc=;
        b=YbnD1oFDgV6Ui0xad1nLkSIbuT0xKQZqb3w0qT1tyucFE9OWWZcvB+KLZVG9wdN+Nb
         LPS99+2/SOrWKDiwZ9Li78BBX55emVXg4GoAPHjahIsaUiwmLRRaKc0um8b9dJdr6nuA
         oWd2iucB4xR/7m/gsu3AVonTR+247uEpcH3m7la2/D9Czp2GLxKZMPvEB8NRARr1F9N4
         tI0n2jiIGQCIf6Z4XV7F/2EOLSMwbrF7Q222RjmkvTdCOG9L7BPCPcBoDpiCNt8xdfnd
         UI85Qu/GIeyRL71qKdd0HjBUSS58szr48k9WTIF4HW288uLlpGS7ebS2j0PR4cK7ZWDo
         mXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773336533; x=1773941333;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DI4uIRiym7HF+uV8f3Y+IQhxu5vX/UZXiPwGeaFqfEc=;
        b=XT5p7Aji6sDKhXGr9PEiD/T0pJzEi5MC1CiNHGwgPJ/06+TTB80NYYUxzAjrKMwXiF
         gzb+YCWaZSRj17coCkSaXszLxw2FwPXNpzbe52AbhLRwz6CY7DQWXoTNHAUDTmc3Fh8o
         DKHIgVjrf0xXl08eIENq7gm4/0cgpr5yF/iZY0mTw4Prtbd7+sGZOKLsJr6TNGcB6oGP
         nST8Thid0/GvfP7vZ05UVR+AKBclJgNFi+5pD1byZPbh/+q2AgZL16NFsm4zY5+XzHnf
         anGD8Z1zyeZyovrgjd23SeseQhS4lprRA+cecH2j+sUMYs5WtKVuaDLH7XrrAx07rUtZ
         SGiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyW1l+QUeTLU6YVLkPlXWgjHdVG4P8M7ft1zFHHvFrL+Nz9pgNiAVqkeLX4YM4GLblGsxXY32mXQ==@kvack.org
X-Gm-Message-State: AOJu0YxSgvNFSb3KY3FXIDflT64vh/eejOngDeuTSB7YwCjVpUpidplY
	TSonj5Ni+gIB/cRqmsq9x1X8zvFUowq3PifgWs2umcCFGJBn8zt3EII6
X-Gm-Gg: ATEYQzx4bmkMeFMFRL6i9/rcsCWKMeDb5D6yl4PYgBhot0P/X6tnJWwae34169I/JMH
	rpnU26uupGD0HdsGW9Xl03y1V1Hs7VyEzc9rCXiqUXpJZYCXOQhXKTZCWSmTgqx93Eo5o6N14SU
	g0FggnCgnpe6cy5WzBzobIkOeaSbVZfLIDAz3nTDeu0nUiNqa9CREWUByaGgDVXD0jOSm2/6T9C
	vTzVk6PGCbeRr84GtMkQUm7vrZ+vpRWQ/F+NXcL3SQCQmDht4RBEnedUF8rMtzycSlzMoH18Q0U
	bSgYjVvK3WnUf0P+MmLbYVK8zVWmnlomkmMphZVvYh7/SBHov+hHnozbCcARDCloyJQg0Pne5Z4
	w7xJLo9tXob222tkhSTdVCOgKXqE94k6GMFCPZjTDZcBP9fN92d0Etka6i8QsiE8l9Okum7l55U
	bLTW6XsatxEtynnttd
X-Received: by 2002:a05:600c:8714:b0:483:ad56:8d16 with SMTP id 5b1f17b1804b1-485566cf048mr2521805e9.6.1773336532525;
        Thu, 12 Mar 2026 10:28:52 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fdf09abesm9556172f8f.0.2026.03.12.10.28.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 10:28:50 -0700 (PDT)
Date: Thu, 12 Mar 2026 17:28:48 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Message-ID: <40767ecf-7e25-48f5-a604-c43b835b6b66@gmail.com>
In-Reply-To: <abL3U3xm9c4oSbKM@casper.infradead.org>
References: <20260312171238.7961-1-objecting@objecting.org> <abL3U3xm9c4oSbKM@casper.infradead.org>
Subject: Re: [PATCH v2] lib/idr: fix infinite loop in idr_get_next()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <40767ecf-7e25-48f5-a604-c43b835b6b66@gmail.com>
X-Rspamd-Queue-Id: 73EC4100017
X-Stat-Signature: ym91jkmztrkpwaygejoaukgo7s58tfgn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773336534-607988
X-HE-Meta: U2FsdGVkX1/Xmgf7rxASFzS7cj467WMd+cK9CL7kdmMezG/DRVXYjK4zIMu3+dXA1r4dfkCWaI35XB1aw4VkWE97/SojdxnVvCPvgKwvNEMWv8BwdTohcJple2A2uZgFjnQIPezoSkQfXu9qNduS4rSw9BxHDGqwYhDybbZmFrTT1f1Lr/Pf1YTbRE4rGLX4k/5ppcbPtYfpUhJxPXVn1T9gHwfq9GfgFv9mF/j/B2bRp7B6zzObL7owtt1UYGAle/2FQeRLa14utuYqesVw5nBwp08vRzK7JpJ2yVOZRDrPZpRm0MPxzE7CYp4mVt1MXbTIc4f5ZrDoMohStuLF0QcQ6HfCFee2j3H8qubgmXpahH0e2UfEvvpc8e4X6IS22qzDJUgEaQY/0Og9kLzuLptaQ0G/ARmT3/G1G8nCutQzOSwSKk4T6TpkEfn+jdk93lnowBG7CpHd8BlIFx1SAAs8lik1e6MlwMdgbPlDMEaTX9Kny+X2x/tXTefUFygJ1l3r6UWXWQ7VbPXraVsbcGztXyOyTEkIB+DOnmXdfQWfyZZYEodm4Q9RasvXgikvvjNhQ3APTc43XDLASStM7dh4XnXa1Jq5NjcmPTI2AEsLaHYLg1vC5CpA9rRpj3ar8m70Q+COMLtHBxBlsM9snzfjIYzG8EcuF7zFkQ4dC+AXcYGsP03wdTbR5Dgqg6Bq9e1DdP3PX7ehA5BM69ymViQgr/4l81EL6OQzdwjeqG8oVZA3Bar7WsuqEXwLCb4YNZ5vv8e8K2bHuRMJcsoIdUbkZkQMojYiEsOjQK3IB68AdDigDdP1LnYwpWBxMIJiadCVJscWPjC1JPfzjyWvDfqW1eyzAEdupAkhRvyab8/ZufkVWN87kCVjtlsUF3UqmP1QLcQnINuvNbQkL/9fVOMWLq9ztpuq9kY7WE7tNnhLQKxHa9fR3bbY0jokvC8rLxIFwMpZBXRiHnBmQ0+
 ga4Jkf1j
 B+cMhV1p5lnaOcA8S5Gc4RyRsLEwwzg+UNLqmJPX8jaMFvqfFLaK16sX+7STmFTM6cXQM8e3+MlDrcyX/1KeH9PeNsSE8WdgsIS/N2wT/FdoFev+1go0YrGcYWzC5+mP6mwGS2JfJQF3gaOeGyfOdTAWdoxjAeV8Jl4PFnELCWwcmSVEoDzY3H+PFTWpkbgI++zV8DeKEuoyDXVOm8I0Z22S79DHc8CIVovl7+S1AiJptCu6uH2HBCUqEIOlDHoltLp+bbPJ4kbSGByEGkd9bzPIbuHTiRICURjYw+6ufZhxutkJZgh1xob7TPX9dUqBxf/0D/kRnOxa+WmW0qyOWJ0KB5fV0eNchTF7r52pB7MNYJTwRAWmfjhPESMF39sKmjp7u3Rlg6nI9QKNPI7wGLAhXyy9v6pVLMQ77WRDO+2hxLqN1DDGgDlCfpgNlKLUcYJgq5uQr+iwvuT5LEvSS7THPfVri38IQlVJSa6rHXQnjKXndnLUAkApkPckkAHB6bQK7vrvm1MjIehBcJGUI4xtKLHuY9Wv/3OvXL8GyYwzaQZ741ysLCCXQ1qKRG+u8Tvo4E3IHtUfZdQg5TVHr3KX6k1dwi50YiQgG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

12 Mar 2026 17:26:44 Matthew Wilcox <willy@infradead.org>:

> On Thu, Mar 12, 2026 at 05:12:38PM +0000, Josh Law wrote:
>> From: Josh Law <objecting@objecting.org>
>>
>> In idr_get_next(), if the returned id from idr_get_next_ul() is greater
>> than INT_MAX, the function issues a warning and returns NULL without
>> updating the *nextid pointer. This causes a soft lockup for any caller
>> iterating over an IDR (e.g. via idr_for_each_entry) because they will
>> receive NULL, fail to advance their index, and repeatedly query the same
>> state forever.
>>
>> Fix this by setting *nextid to INT_MAX when the bounds check fails,
>> ensuring the caller's iteration will terminate.
>
> Can you add a test-case for this?=C2=A0 And the IDA patch you also sent?

Lmao you and your test cases, absolutely ill add some test cases

