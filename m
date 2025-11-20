Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F2C7CFA446
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 21:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30416B0010; Thu, 20 Nov 2025 16:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08586B0023; Thu, 20 Nov 2025 16:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45346B0026; Thu, 20 Nov 2025 16:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95FA46B0010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:56:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4208A1403BB
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:56:15 +0000 (UTC)
X-FDA: 84132344310.13.16B5B91
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1F400C0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:56:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Lc12tz88;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763675773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiiDKW8nPUJDafTMaTJcRrJ3rye3I3dOabFD99ZaTII=;
	b=TJjHX2DpIJD8f6QkvQVDy3zI8jUOOGYdNSoKBaXeeBnmCF69w8KcbzOBQgZdL0B7hoDBwe
	tfJaPc65QllgCZYHRtyQ5IWJAKmsssxBJmAHz+vbeaok8njNaEvgM0bEvp2UG/rzxxJCfu
	CYjjI2vQBA7v89edX0KZOwXHC+KEefM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Lc12tz88;
	spf=pass (imf10.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763675773; a=rsa-sha256;
	cv=none;
	b=qHubcsRe+YX5iS1oN9JPwprjEV78MGEEDNEA0edoFVyaEhLKBC4DenN4XrBBDXIGIgnNiO
	WI1Vv4EpYdd4c9M3HgvVnE4KSGTEDkg5U3iyNdJgS8zZYCJrgOkWW0uMbhxTGTn3rS0bDu
	xXobAAAB+rNkhk6KgSM0QDWw7lFEQi8=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so2475947a12.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763675771; x=1764280571; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RiiDKW8nPUJDafTMaTJcRrJ3rye3I3dOabFD99ZaTII=;
        b=Lc12tz88rHERPFXJz3W5jscfEecGmbBNS3cAnWTOrlK0y9mEMSKwDj9XCiVsPqOPaJ
         hyvbkNo5KvgQkOCp0AxpPn027x34c+nlHvDW0ttYjLPeFYzDhr3zizpdrPdW5O6oVWIm
         AuzyVlQLTTIrx4mxjCLcChSQiOQMxJtAO6eso=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763675771; x=1764280571;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RiiDKW8nPUJDafTMaTJcRrJ3rye3I3dOabFD99ZaTII=;
        b=u6aWnMpLnPeN1OcmIpm4IhaqI0BAqc7DlqbbGglY4KP9NJZrwBIc3fEwSzwsnIa5PI
         sFGtThz2t2GO+05UW1qR0T9oy+2fU0pP9n9xE7lS9KOy0zxs2CyZQN4HFqdPFt8I093E
         bLOYcNtHlyJTLlrq+tKBEjoozbrZCaA4W8cDz0n9/jBO2FeKMUweYZdwQ8jayQFxgdrl
         P1/AYTj5Ug+29Fkv4tYzKi5m3t+UED89k2yELptczoca6c9yRfmG4uqSleIRKV5GXW++
         5o/ThqCtzuGIHXXWth51v5CPkcdLC3/yzoFLK3OckHJ8dLpNjSERLE+vXQE7x//L/5Ct
         uWpw==
X-Forwarded-Encrypted: i=1; AJvYcCVkTUvJsbscc0kUGkecRtVhq1sOZQT4nLeNlt8f++p7FeJSAg00mxvWMs0ztdvysKcDS8J/XNhrQQ==@kvack.org
X-Gm-Message-State: AOJu0YzfCuK1pIKq1HttCxNE8BU6sphF/HSs/SCVmVBN4yR5BDN55lQS
	wJKkd7QqFyG+xfGoJD81YzoLpGUegqbpevmwbaFM+FG3ykbLIy6enEGe73FtnB4gbBdJl2g/QeY
	Z4LHKvpuKAw==
X-Gm-Gg: ASbGncuTrmIcC+oE2g0ghC3o/a5VzXVKrbA7udIaN35FecPPZWVPiijCfH027IEFJte
	13zWL0iWuPLsAAo4ce039sM9gjROMXnJNeGN9w/y0VrilxAU2vxl0Qt3XDpiZrntJdHp3omkCED
	bvPaHcZe25ti2bcJ3H53ibqYdbBZ0jANZCmfcoZtIGLRZkRwfowKQ2JygaL0FI4TH5p+3o9ZgoG
	rceOjYQM/loOd1F1vwDJCkyKTJvazr2LmWtNVUfYwYZiRI8OwsImH9iH31LSKqlt9lMUVDYo7Om
	3A5E6oNY7Uz6oYJ5TLrT9z2hnlRs5nz3SrQPb9SpU1BgyjF6a755UXoLoMR8vxq8psSP8oNj2r7
	jC+H8FxdSiweXHbMygmRAxtc48/D0rAEFFZ9G3qUM6GDIEOQU7N405J9qc6gR9Z+RSWu6k3/3xH
	yXLNrJEc3OaUK3LbV8G49pUmK51v7i0/ri6acgr/zpsloJT9Oi4m6P2jlZL51h
X-Google-Smtp-Source: AGHT+IH+PHyYGLxNWf9/WZlB2MGdq0TUxhwe1VEaT2Q23f7EfPHcY5kVigY1eVzEL/Fx+EmTOATQVg==
X-Received: by 2002:a05:6402:909:b0:643:ab7:2e86 with SMTP id 4fb4d7f45d1cf-6455443fc56mr227402a12.13.1763675771148;
        Thu, 20 Nov 2025 13:56:11 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-645363b66e5sm2926102a12.14.2025.11.20.13.56.07
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 13:56:10 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7370698a8eso175336666b.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:56:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW6Kte1yA2tgZDl3OE6q5fI5v+JAH+JsFfj9OmT9m4n+CCH6CiEfo7hn1vlfzPniM5zMsrLiUFY4Q==@kvack.org
X-Received: by 2002:a17:907:1ca0:b0:b73:5d8c:dd0d with SMTP id
 a640c23a62f3a-b766ac23851mr104828766b.52.1763675767229; Thu, 20 Nov 2025
 13:56:07 -0800 (PST)
MIME-Version: 1.0
References: <3f4ec3be-0725-43cc-a75b-72549ebdc5c9@suse.cz> <CAHk-=whUBuZmRNGCxjnAkFQLO_HVV8SgWEAUg+3z4EARD9MM3Q@mail.gmail.com>
 <aR913JM35YDVSCjF@casper.infradead.org> <CAHk-=whk_gUfFKtZrjd6TbaR0YhEmhOAs9wXFg5Je3FzQ3adAw@mail.gmail.com>
In-Reply-To: <CAHk-=whk_gUfFKtZrjd6TbaR0YhEmhOAs9wXFg5Je3FzQ3adAw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Nov 2025 13:55:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi-y+euEWAM9=Ns_kTXTABkwR0_MBPXf5iq5uuxfadVSQ@mail.gmail.com>
X-Gm-Features: AWmQ_blIe3yHIH7SnjIHXN8QnxviVtxqrjH_9LSAHZCwSd4hWkssl3snusfn1vU
Message-ID: <CAHk-=wi-y+euEWAM9=Ns_kTXTABkwR0_MBPXf5iq5uuxfadVSQ@mail.gmail.com>
Subject: Re: [GIT PULL] slab fix for 6.18-rc7
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1F400C0005
X-Stat-Signature: a9eakiifkendt74qt3kf4eeif3kmhekg
X-Rspam-User: 
X-HE-Tag: 1763675772-221678
X-HE-Meta: U2FsdGVkX1/r3S32R8VxvgWNwkvABkzwZq2+FCj8SQdhoc/opAkix94wfZHB6mHsxiKyPlZpFNr7RuBqqDpfhonCDkVtURMh6CpbvkbZ9Cf8rgZcnd7FzBIwbO8dFbBpunz6XVCkSGxt0rzHPm2BbCK/mJqdpBa/QGi48glyjYogEbWTBmcw32r9UWaU+y3PhncUSSlt6FkRUVcMke700JsCzYQMhclCQDgJBCwcU9I4Ce6dSclj79XhnieZO8ygcWD5qlAnNip/lVfzEh3O01zae+LC8RFxfb9tTh3JHs7GyHKOIDOhAjyRFullji+NomnAPZ/X7uvPbZGgDUmopr5Jvlf31XtG7KDl0SfnUPyhSd7Yhu505N+WNeJzgeuDoFOZVi/K8zWoDrW5cdmHnHX8d5cOZ3Sr5Sxp7tqrO/CvcWmWM8fdtFxcWJ1p0BVHXaZlzk34VVXW0jjFypc+cUqGvqISItsaoleX+YfWkZv17A3JMUCu/67jq5zMZkF844Iu/rKko7ZfamdJ+MQXk/UF5mKCIMWkPFPwQ3W830wCYwvTymypZVoT4H5uOHhVFU9H2e7nlEez+MLCre4xPvPu4xn+53VCGMcBWONWxhDN7Si2QgG4T7x0H5OMs8vjitSdXp+/6G3ZnPuPi7aInPNn4bwmCfVmgbLOWDHILza08sYOU4bRtg/YA4Ng4GpaVnJQ/MAp9yju/ixWwkD7XolJHiBOXb00qWAc5frhviJUOTw+8YwcN5CEgr+cjm2XnrIuacvFPM4byHlpyAi1VGAmFtpwa0JrOtwqFZU1eZP60n0Ehgsd9JxvaGTjz1Gy1U8FGPKmOHrmJJ4QqwcmIgSAo7mLCsvD2ALUdKhZ0jLQjfHiPmCntq+oBAaqJEY6Ru0M6qbp6txGTF7+kbbL77JZoPzYJsPrDjS3cYuSkdkrgLGpRavKgJcWKiKSg1XR9mgouAmv1kSdAw6PFoS
 SFbLs7ul
 zriBcklLqq2NNLCnI8HLvo9/mC8aCNDTt6tCwcxImqNWpeLyRAvq1PZHggrjcgLrie8evvbxHywOaOX2J/oPNsefm1xTRv6Z/P2jmq1R5EfZFVu+v1l8B89t6uAfeQbsiNpd/LuUjy8HmGZUd9l+J+SL8tXqawgFfuub+okoQrppmZjRFAA78T1FyzilVRH0Tkn5ct/PVnUvj4zkKg1xpm62Q1U8SmTwzBmFpaB5xKIwTcMx6C+GFqBRCLrfOoPzvFUncuYP275lz8G3e4YQtn8ZYJ/KPN9YK1Lq7j/GXjJioS56Znt92ZVgupoAdHPsPFZ8cLUGEdXT0upuOe5AdD9AKAIXqTLCHqV1IUDXDezI8QSAbujPtXQdH+9JVKVy+Hf2AXKBYaCJFeK0CUaC+M2HuKsdZghNOw3PWCzF/f4coPZEFkkki7gzk1AwQIt+s11rLSrAMJDc+93LHWNfSE58IOY/3ljp00l0SKU5ZGFE2Rx5FszkUV+WwpxOUA8fTtep9XzZinq0tXoT2Twe3Hk+jQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 at 13:37, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> HIGHMEM was a mistake forced on us by bad hardware. We should revel in
> the fact that it is not really relevant any more.

Btw. there are probably many other cases where we might just say "this
makes no sense in HIGHMEM".

But most of the time, it's not worth actively removing support for it
- it's just more work.

But when there's a case like this mempool debug thing, just say "we
don't care about this debug feature for HIGHMEM" rather than trying to
actually deal with it.

IOW, just don't write extra code for it.

          Linus

