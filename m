Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1079106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3853F6B00BA; Thu, 12 Mar 2026 17:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345726B00C1; Thu, 12 Mar 2026 17:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25BA76B00C2; Thu, 12 Mar 2026 17:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16D826B00C1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:15:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 170EE1403E8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:15:03 +0000 (UTC)
X-FDA: 84538666086.07.223FBF9
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 289F7180006
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:15:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EHAIywQh;
	spf=pass (imf24.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773350101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upuRHqFHxionje3foNDE/tZRWHhvJD8JwOgP1S0egAg=;
	b=H9Fl9ZdgST8hZ94rYMbEf8zQA+JkK4wJeIBz4KkS5qz2F4cuSVJSIUvL0zKpuYDNDHv9G0
	xhRLlU3WZSTNqhCDoKFc+2xjf5GqJdHZE0MBJ9hc49uKnibZTk/4Q5Ucf2oY8szvWbQDro
	MFNmqt0d/QBiWyhX0QLRUnI6+vYH2vo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EHAIywQh;
	spf=pass (imf24.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773350101; a=rsa-sha256;
	cv=none;
	b=nUmOcBmWEPXhFT/RB2KHS7e4BvsB6Po8IJvnXyvpgS1Yi2hkGwB2eDV14umviA94zTyjT9
	dCW5hPze0PPec90BknrF1N+hZDyy5aA7RzBApDi4qfWEeR8DOfzbrU71uVu/T3MUojTtS9
	vciq4Y8M/AFJY37ZvztYcYY56HF/iGw=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4852f73d0a3so13682165e9.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773350100; x=1773954900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=upuRHqFHxionje3foNDE/tZRWHhvJD8JwOgP1S0egAg=;
        b=EHAIywQhGSf8RlJnNkksOYzXpSuxnxdRbQVzsYcb3Uc82+dslfEnLs0mjgE7rKvEmw
         AeSaqmY6xLUXO0zMD1QrNJxL/KVxxpWH29SFj9GBmHNA5mWYI+tkJUpF2IZX7gW7MqJH
         oGK0FuRlMTPa7L3oiqt0l0gHg1CWijStwdr9EPEXHnYQmN6n7VdJ9Jj69VCxUs/qWPAi
         z7JlV744pf+D5zqvbDJ1XAghin3KS1qTq9KQY1lPJqYSvVJ2OTgpiAoSBoSy+YPn0Hud
         gs3VbPhrwIF6BDV/6o4Ek+MO0gQvvH2dSWhU1CD1mkbEEBhbNh384B0xcvYpHtlv1Gkk
         iRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773350100; x=1773954900;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=upuRHqFHxionje3foNDE/tZRWHhvJD8JwOgP1S0egAg=;
        b=tTtVTOpTYe9knrHPbSKz2tfdA5RvsAbwF9/Oqax3F53yoCmlVmnO6FUt9583LldEgd
         HXkCJ8rcE8QXXnHFzx2mgR7Bv2gfK3xPcp3o4ruaofey8RHhRcs5btgeFc1er9H77XPf
         hVx41lLQ+xl/SWGpxhcU0z0kE8wKRxfJvRL40f6xh17k/KV6HeBDr2HB3vDayz9US1ka
         30yPPLIdpA15q+k8XV3D42h5vyjP7iHopdp9qfzsatEbtS0zypAegEOlZf8k4ZjfKVqi
         8VCoouDbOJyl5oSzvpMg4Qqq+2fV6tr88AYLPF00VN8Rt991tcJxObCuSN5nFFFrCFK8
         oeUg==
X-Forwarded-Encrypted: i=1; AJvYcCW3uVgE4519S9YgYyXv4lYJl5LXSOuHzv2qhD1zV6RovUep3EasvdeIb4JgkhqWOdtFfH1tWzhWZg==@kvack.org
X-Gm-Message-State: AOJu0Yy9I8Ee8ciBAmEZ4SZMENx0NeZjXkN4v3nRuLHOBb0mqsbnD5yD
	bFCn2/QmvehHvZxctzBSyNVmE3Ah1GXzJ0NFAyM2lAXllUL6j97GEpcrvzagOlr0
X-Gm-Gg: ATEYQzxTt1193R/jUFy0C6pIieY8+LBjXwq/Mn6WIUnSwUQX/hY37TwbaEInv0DkWyY
	uV+8f+HcqM/HpG7LQT8JwhrbPyLPusSATWv2EbsZZNiXf45Sh/xrWqYyNNSx+LK9N8XskHDObeI
	PfhBE6b6AjSBRfIkZRVeZR9UUrbJBmbmjutCNwx4aXCt7i5zfMgM4Q9wFAsINmh/F19R8eelELn
	iQ+e+l5Q+7qPoKkmxio//JagJgQpeBS9hEVDWxyzoprEVE8xORXZtFf/qrl1tXJ8tJRwqtYT5AM
	saiovqNvTc5qttA4dJFNVkwAGfYssdgGyxtQZzK3JKfPTdhBGTNjQ9dPg9B/WGhfUP+PU2xQ4Iq
	nCsPnEzhijuciqNNq2lcmNHxd+R+EPghnb+CGytJ3h8yH5pvlxCSNvHksaHbW522DyPad56CgGt
	aQRtIjaq5sGHX+Rb32FtkO5YTOGXYk1w==
X-Received: by 2002:a05:600c:4e08:b0:483:8062:b2f with SMTP id 5b1f17b1804b1-485566ca9b4mr12529245e9.6.1773350099541;
        Thu, 12 Mar 2026 14:14:59 -0700 (PDT)
Received: from [127.0.0.1] ([31.94.74.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b65fe27sm164501485e9.9.2026.03.12.14.14.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 14:14:59 -0700 (PDT)
Date: Thu, 12 Mar 2026 21:14:58 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Josh Law <objecting@objecting.org>, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <2760a688-0c0e-4f6e-b4ea-6d4fe7ecc6cb@gmail.com>
In-Reply-To: <14071af4-6886-43ac-8502-5f5c9763cc5b@gmail.com>
References: <20260312184054.23481-1-objecting@objecting.org> <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org> <b6327414-237a-4262-bf07-c506908fa263@gmail.com> <14071af4-6886-43ac-8502-5f5c9763cc5b@gmail.com>
Subject: Re: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in
 mas_pop_node()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <2760a688-0c0e-4f6e-b4ea-6d4fe7ecc6cb@gmail.com>
X-Rspamd-Queue-Id: 289F7180006
X-Stat-Signature: w7b8ddhdn1wz8r6hj8w3o43dfidjeoms
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773350100-501032
X-HE-Meta: U2FsdGVkX18GjrtDIO7V0unBc6rycgseZc5m24ZRQ2UizoF/YRVKwF5x1Rof8diJo9jye55xLcKJ09AXmoLwCMXJOjvbRDZuIpHzDckSnqV/7HkzG2mVqhB2F4c5NcAhpUNBjZQ3bbf1aoyPVxhosBckQsriPWWeSBKJTzLKt8BOcEs41/RhgRkAOj0xfkLrCERcpirTBpYEBxXXtvmxkEAuOriw4eIPy2e1vn+i/+W9wp5nuuTdRcet8o9DZmldwZhjWQ8IMho3hJISulEM1O3j9+hyV98aHd0AkFs2kVcfCeevS6zQyzYDG+h704CMmeTMrF89iEtGfvoWFgJ9hOwwST5lBRgpSrgNpN/yjD5uM7tIsLtlqxO9nnhdNk/0WfqkXEl/hzYA4Z1Lmj5Tc1rYDmxRLKTEwyOUY1NnkZrJocChIUfqKwsZ+GUtDUC1gLTcrUcxe510Ozl75Pj9qgUgAn6qc2L1jd0xeGodX48lkp5WHG0cjzyTU2rfCPFcP1bxoj537594fKYE/EzQcNfyldOHVtv3mqfQGjqH9hQ9iPQczx34HrI0HDipCMgUpzr/oD2p8UrEk2L1Kku3lD4GpWds60o+GoPhJPb5uZC+5aYlQ9T/RRK55lfwJr3M2WQ7b6r3h9wMeaHoOVKOlmEgnt+16dF74o+jY7as06lX8SGlQxw2xUhsPErpeE4xRk3DDXIBXxEmw/HedNM8P2BHCA0T3Ow3dkuKXI/HQ9dwCMc9he5dt7/p943soiOGv6xAHkDvgeTL2y0r+q8bRj5cVEyy1FJPoSnttDo43Mft88oQsL6oww8AGG7W908Y3e0ZoWXplbyuiA2g/Iw4OZ5DF4fsCyu8mwhDW7I8uvFsyrY2wBDeWpAKX4SVC8ZduuYlfpfDlHYkI5UiDJ0GwDPnj/hvSeUy39Xg5Xj6wOwx5H3CbXdC/JB+E0HnEBd17poFk2D9uDfzQHjLnEe
 kw/2IDoN
 d0iOFLlkCPU4uGKqIqpwBqvSefT8NzZnwdLgwoob1Elt/bvEWj2E7DOXyDfIVdZzvJmZRwRNbmjIDhZB+CeMfvhYBSbykjOI3YA336WvJP9IelEYLuPtsKvINQGPYnu59/ObUEUeJDYxqodkiBe1LZqyyPYP3ae8mRBEFJ0Idnd+tk3qsqcwZJ0WEeUfa7fq3Vw30BPcB3QEsBaOLOnoOQBmWR5ceTsyEjxAkTz+2zikyQwfjJ/kGmDSDpWMdvaemk4BvNzMFtqBmXMPsl6+OjfiM0HAe13Q7/CMZigJJ2fe7AoSlZwPATGqUjw03YRwruIgpYM9968Jchbixezhas6dkfWhJDSNxNdBpKnGxjl8+J6n6JGyI4VfbG0tWR+lN2dPKyLPGdfX1k9W5qDNHlIpnJtWH+487GuPDTPAXJgXv0ttB6+QLPU+HDX15bue49iu3UJGry+kU6sRiF8a+8bKTM8+zsb5nJK0loy65cWBkfrGEXDubFjiqI9VEXLeyQbjyaF99JI3crQAHg684/RVIwrUvxdnQ6ZBWIp94t2SSci7qqsJHngBWIfgL2hBABM2yT9pkOpiDmBV+ErOlm5LFJ7Hpt/zIJZjmVV4GHe2/z6INXQNE31ZMnqZVbLCsvIR5siS7QOOSiGhrrHp+iQ+o39q9Hw5EZDCPRHw7CQSD3afe8qQkCrRaT0T/fQPqDKMsRCARbHI5Msd3T/+h1EuYCDFmIJLz/jO1oWD7I2oHJjKfplA8CaznZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

12 Mar 2026 20:56:16 Josh Law <hlcj1234567@gmail.com>:

> 12 Mar 2026 20:49:21 Josh Law <hlcj1234567@gmail.com>:
>
>> 12 Mar 2026 20:45:32 Andrew Morton <akpm@linux-foundation.org>:
>>
>>> On Thu, 12 Mar 2026 18:40:53 +0000 Josh Law <hlcj1234567@gmail.com> wro=
te:
>>>
>>>> If kmem_cache_alloc_from_sheaf() returns NULL (possible under
>>>> GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
>>>> and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).
>>>
>>> This is such a glaring bug that I wonder if we're missing something.
>>>
>>>> Add a WARN_ON_ONCE NULL check after the sheaf allocation to bail out
>>>> early, matching the existing pattern for the !mas->sheaf case above.
>>>>
>>>> Signed-off-by: Josh Law <objecting@objecting.org>
>>>> ---
>>>> lib/maple_tree.c | 2 ++
>>>> 1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
>>>> index 739918e859e5..87a2ba6468ca 100644
>>>> --- a/lib/maple_tree.c
>>>> +++ b/lib/maple_tree.c
>>>> @@ -1063,6 +1063,8 @@ static __always_inline struct maple_node *mas_po=
p_node(struct ma_state *mas)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>>>
>>>> =C2=A0=C2=A0=C2=A0 ret =3D kmem_cache_alloc_from_sheaf(maple_node_cach=
e, GFP_NOWAIT, mas->sheaf);
>>>> +=C2=A0=C2=A0 if (WARN_ON_ONCE(!ret))
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>>
>>> If we're going to do this then we may as well restore !__GFP_NOWARN,
>>> get more relevant information.
>>>
>>> But a GFP_NOWAIT allocation attempt can fail relatively easily so
>>> callers must be equipped to handle it - perhaps no need for any
>>> warning.
>>
>> Well, fair enough, but WARN_ON is equivalent to a "oops! Something went =
wrong! We will continue anyway", NOWARN is quite bad for logging that that =
went wrong, usually it's BUG_ON that causes said kernel panics and that, wh=
ich is a bit overkill, that's why I didn't add it, and it warns once, then =
bails, that's why I'm a bit on the iffy side about adding NOWARN, what's yo=
ur opinion on this, do you think a NOWARN is better then warn on once?
>>
>>
>> V/R
>>
>>
>>
>> Josh law
>
> I checked the callers as you suggested. In lib/maple_tree.c at lines 2352=
 and 6039, mas_pop_node() is called inside loops where the return value is =
used immediately (passed to ma_mnode_ptr or bitwise-ORed) without any NULL =
validation.
> If kmem_cache_alloc_from_sheaf() fails under GFP_NOWAIT pressure, these c=
allers will trigger a kernel panic.

Yeah in my opinion I think this may need to be merged.. if you would like I=
 can add the NOWARN

V/R

