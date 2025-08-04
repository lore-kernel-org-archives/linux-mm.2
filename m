Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AC5C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99F26B00D7; Mon,  4 Aug 2025 09:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23916B00D8; Mon,  4 Aug 2025 09:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11756B00D9; Mon,  4 Aug 2025 09:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CCB86B00D7
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:01:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FF0E135131
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:54 +0000 (UTC)
X-FDA: 83739087348.12.D21A7BA
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1EBED40018
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BdBBprPX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312512; a=rsa-sha256;
	cv=none;
	b=ljUot8nqRqRifsvXNlSJ9z5X1oOTFZJeEwtGpF0uSn3gSqktCfhEjkOqW5sm1667IWLeqj
	44XDl7gPtvvydRLpzK8v5VTdtfuxo+EYV3wtyNzyZlVzkJnxt674x2vbx6DBbEQGBpdKqI
	tSB5V83kqWgkHG3NJhvS6/xBjMBlt+o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BdBBprPX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KefGQki3y2vCgBk3//HIoldKMrauc2w652/PLEweYlQ=;
	b=njk2kvBZe7drb5TkDYt+NiMFKp1K0ZozYdYGZZpm8Grwrjxs5kxSQKU64AlmoMazoICpfs
	5EwzIGOaIHuSv6qFfU407/3jegaTO/Uz0Tu3Bfk5RtQ+vvepdvOSrHTUAk8v76auSLypUy
	Z+xgjoBUkJL24sv1HaJy25xO03T2J94=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-acb5ec407b1so620163866b.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 06:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754312510; x=1754917310; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KefGQki3y2vCgBk3//HIoldKMrauc2w652/PLEweYlQ=;
        b=BdBBprPXVxas3mzRbQSWrd6ptIzFnUIHIoGJ3/JciOxhveodKs9zgJGteDJkFhMU2o
         YBN4BmcEjwZCOF+nSJ2pEhK+imY3gLH2paB3rT/NdvEkgSOHarySg9KHMNb1CDDdZmXG
         UfOjtexAI7w4Oj8aw5AcvB6UMkwmiaqi3XIsPHepy8XYPz4Dbyvcx/lyiTmJjQRelC6S
         b+VmM4VrRONJ1RKvvVLI4OxUDSI8MEwXIoAswhn65rFzhb/wJcMi1xsw+4BawB5uTksC
         /JtrNz/U2U6AhYAEVqZClumXpfbGIbWd48yhZjyXHwefQGLDchTUdBWAvWuNjwTpgK5J
         hibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754312510; x=1754917310;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KefGQki3y2vCgBk3//HIoldKMrauc2w652/PLEweYlQ=;
        b=Q+DQh/MyMK2DxBmSenJQAeJkza/9rEhgaStBe9Z82w44KHPNyAu45CcVg8ea62OIeM
         DBHyGqzT0MoyAediclRa5D9+tcdqvkSrf+SBLWficjDTh4E4h0IffVa8+LD3HHApZXuq
         SSgmyHLqyJIPrxT2V9O6kR4C0WLi20g45TY+TXiNOGP9lGP02iZC+WxWehwyoIfQxQ45
         RH9ThnSqCZxUgxo8gCfx7vTJQ3xsTAmJgMvfQtRYJYTMFKNtj0qwMtAXvnWFXJGoHUKf
         W1NIITpDrkwVtKIy+weI4cHwszrVeCXK/o2o8c+K5ZB28W0mjIeOMEJpf/oMlAw7p+KG
         Cy0g==
X-Forwarded-Encrypted: i=1; AJvYcCUto2A/lmoUQVICXk/9HmjwqT+3ZqdEeB9wqpCY2wujMDHS5lLST6rhTRw7b7qfKkduQ41OYlmdpQ==@kvack.org
X-Gm-Message-State: AOJu0YxWs29rKML1T6jcx+M1C0T9UA5uOfu5AC1GxY9pxtiZJTjWDlLC
	heQYYC66zWQ4b7xHkYCOKiLqmWW6hXP+St1qUSr+iNBK2IEUKuMfQdCKaRUwfPjySdo=
X-Gm-Gg: ASbGnctRp1ffv1PcBj8Auv3qd+Qwi82JR5IKTA9wbuB3Pm+YiwH/w7YHidFBuheG3LZ
	ifhz6Yc/Wn63kH3OD6M2oyK8AJKIkuEXm1JofKPJVlmnYg+CsurkzcLavHHk7ZxbkEh5famsGUT
	VaJFWywffbxML2vwp0squN3ZnJlY9AxtcssRdaEXulsl9U9Fam/qNv2TkasPL6ZirVGkr4QbmVO
	Cc4PhoqAsoBxhKabL9oaYcyTtPaL0k2dc/+iN3QoR9zXY2dqf7cOp0HCDqSnf7QRggpZtYmXvmC
	HxZLagbdOKz9uYNYSTxYJgyPw2GXR5oakt0AyMbihD+4a9z0kEACi3+LIb2dpAeZiKXY1zCa7vm
	LAExzOY+C6iFCnAOo44BSeL57lOfcFzmeV+2Bt7oRg90ixuda
X-Google-Smtp-Source: AGHT+IHyaLHRw9WBl5ycUvUvKXhVXBKMJj40By+LLSFKNQMKMdFNjDt/FfyPBkA5DzimU7cf9mwASw==
X-Received: by 2002:a17:907:97c5:b0:adb:45eb:7d0b with SMTP id a640c23a62f3a-af940015660mr1070658166b.15.1754312509941;
        Mon, 04 Aug 2025 06:01:49 -0700 (PDT)
Received: from smtpclient.apple ([132.68.46.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af928c84154sm636824066b.84.2025.08.04.06.01.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Aug 2025 06:01:49 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for
 performance
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <c441e6ee-3118-4603-8c77-c5b2ef40982b@redhat.com>
Date: Mon, 4 Aug 2025 16:01:37 +0300
Cc: Li Qiang <liqiang01@kylinos.cn>,
 Andrew Morton <akpm@linux-foundation.org>,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 lorenzo.stoakes@oracle.com,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasarya <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9D248293-2456-4642-9F18-8075F0596EC2@gmail.com>
References: <20250804123923.296230-1-liqiang01@kylinos.cn>
 <c441e6ee-3118-4603-8c77-c5b2ef40982b@redhat.com>
To: David Hildenbrand <david@redhat.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1EBED40018
X-Stat-Signature: u5u4nedzyd8wxemgnaohxi35dejhznc8
X-HE-Tag: 1754312511-654165
X-HE-Meta: U2FsdGVkX1/ZuL6ZSk+/OG2Uu06NR4XARHUkuGiDewaY2Jw+3YWxbhehh32Ays3UazexUoAhPgTOT4pRyJQuWygMoR07cxdjVmE+/2OsOTs0jU05k4C2c6azdkVzopgF9DjupxAQI/GTDVr4h/KFw57ySqV+b/lW6KwB6F3q8LzLCo04bNiCAPWrX6VFWz/zN+TwQRddaMdgEz5sC7N5WA1vw4CC4BZ9ZoqXU1Cp6BWf4J+8Xp1jFoKYPVXYJ90Z4n/L/VOgDoJ1MdWOZVS1NZV0/7JOXtA17uupow0lIGfcyf4V4NR+Db7hsyGdlGpOQI8aHKK4M8PoJEyBCFikmtuaRatNCUOd1gun5TmTNcAShsMFZ/bMhFW+E3OhcAKwrbNy66yJoaqrJezoq0ry3j+OCY4kLlzcVnCKaSzJjJkuVVPyb+nh1IhbFPRVFHgnhX61wm6zEtq0TLQ1Oo/5vZIrD+fBaTRF6O+atnyUvj5uwmnzJa/VM+QUDPfqwdO1InuBjsEtQzfQi/+19EqIrGpJ+oANo9zkw7dEAJ6cfZZRig8FIx3/ydvC9HpKJN1aOt25XEFyb8A/7xlXMx+aIA5grPIZZrFD9Jdf0Qy2rqFcvu8hzvMJL/btCDyB1dtzL4TKH1wfhDl3bZFJasyDd9ypcwEQ1i0CkIzyAJGLBQoFQmp+uDaXPtkMYh0clKNI3FmhJ8Lq3hemOG5ojRluP54r81/UYAXoQQEF8MWAiUSWKJNfi9MI/yjztIqMynDBARENUEgYi0tTut1ZhNnTcyl5/THSDuMnuPs4aCjy17jcBGxWQqxlaDyQo5tQ66/bbXS9KDmvTQx4YHuQqA4EQvfLPx/0bToq7JLlo0t8Qh1Ibmeg27bOQOPir/9OYuR77XMPcwL6qua+ovbuxey1zskOvivPe5TeIYPGp+LHrn8xohhMDqCsO35Do2u7qqXKKppOnLLSCl4UaMndJwh
 I9+qmkK2
 3GeAv9/zfWXRqKs+S4LZSKMLAnTNUjGbOcMq3AKAPG9nw2R7Oust3YHjE97WuI1nn9FR7ed8gGPZ9Pf4gVvTx3dO3vTyviAfJYzkajBeY7zWdxPSl1PdSEku1kBfO2XDNTss2HpSRwih6R8GkX8EsGsl29HxZP/CT0yiI+ua/BZhE1zLlCdKZv5VeoWf44Whz+yFYycE+9xallCJZ1TcmxK/h9iXdOkJ4Yr1hekUUk6Gwy+u65oj6b7k3K6HEpQjJhAZCGMucq71XVf4+Q6brISMS8F6Vx+hmr0dUKigWXzCeQb7W+Ax3OgDIN4b8piigIjC/nr/xONQn6zfZuqCyc0jOoEIFcB9mi0hyIDSyvnBZxhs9GjX9bWwkdQSqHhbwx0GH9AESwHYasTyE6aFLD+RUfP+tMQHCJjOZLCNCTiyiEszxnHAL9tkmSkp0cmS3xaqhSs20Vm4R4Ju/v+yvTff/vnJg10YaGjUg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 4 Aug 2025, at 15:51, David Hildenbrand <david@redhat.com> wrote:
>=20
> On 04.08.25 14:39, Li Qiang wrote:
>> This change converts several critical page table zapping functions =
from
>> `inline` to `__always_inline`, resulting in measurable performance
>> improvements in process spawning workloads.
>> Performance Impact (Intel Xeon Gold 6430 2.1GHz):
>> - UnixBench 'context1' test shows ~6% improvement (single-core)
>> - UnixBench  shows ~0.6% improvement (single-core)
>> - mm/memory.o size reduced by 2.49% (70190 -> 68445 bytes)
>> - Net code reduction of 1745 bytes (add/remove: 211/166)
>> The modified functions form a hot path during process teardown:
>> 1. zap_present_ptes()
>> 2. do_zap_pte_range()
>> 3. zap_pte_range()
>> 4. zap_pmd_range()
>> Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
>> ---
>=20
> What's the object file size change?

I think that Li wrote that the size is reduced by 2.49% .

My 2 cents is that usually it may be better to understand why it is
not inlined and address that (e.g., likely() hints or something else)
instead of blindly putting __always_inline. The __always_inline might
stay there for no reason after some code changes and therefore become
a maintenance burden. Concretely, in this case, where there is a single
caller, one can expect the compiler to really prefer to inline the
callees.

Perhaps it is beneficial to compile with flags such as
"-fopt-info-inline-optimized-missed=3Dinline.txt=E2=80=9D to better =
understand
the reason.=20=

