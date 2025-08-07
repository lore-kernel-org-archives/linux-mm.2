Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69779C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4B46B0093; Thu,  7 Aug 2025 08:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BACB26B00A0; Thu,  7 Aug 2025 08:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7D86B00A6; Thu,  7 Aug 2025 08:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5336B0093
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:21:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D5C3B9E79
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:21:48 +0000 (UTC)
X-FDA: 83749872696.28.0D18623
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 94CF212000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:21:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="yrEShFG/";
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754569306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73iH4wasKzrXgaNXIqRiPRT+SR9a1gFj9x2fb3CS49Y=;
	b=D7ieHnTmTw9H8UqQvQbiZAKAsfk5hXYB2Tr7fC0dfiI6NYWzCAOpxWcEiBgBlIGeXs85bD
	EUG3q+TcNKW8nLqoIHH45e2KVb+68Xiy0Yn+obIlxm9XSghJ4IK7NBmhsBXoMBjP+F8kii
	WXSTb+aV8Xx6G+8paUaE+wR1j9TKdj8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="yrEShFG/";
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754569306; a=rsa-sha256;
	cv=none;
	b=lLot+RaOQ3l4ZarOL7It3b34QMzahgX6wqi4EF/4Q7klnltogwuqxSVCQgra6LZhwAb2T5
	QXp9VhFSMHjUA5jjqsSoKlmKJ92Pr+kKbmrgPPi7RPf2fqBc8Hh9g34F2UCk6c9x0hRoge
	BBvSfmJuBeSoBgmqy6UKquAMQgkZChQ=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-708d90aa8f9so9293737b3.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 05:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754569305; x=1755174105; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=73iH4wasKzrXgaNXIqRiPRT+SR9a1gFj9x2fb3CS49Y=;
        b=yrEShFG/u/6ooIvugnyi9sM8MPoCapExptC8lbrW3inDqhMjHfc+Tv70FrNHG92t6E
         wIOdpIHwfIckKeE2+7Lr/YdboUANdZIfdxhEN0xEF6Ap/OTsga+iGTASZO+ifwRWgOrF
         kz+XcmKtWaD/Yx0maN8Y10wrmRQ1qoq7SpL1jgH0SaTVenoPRshRKzK8UocClajIQhcL
         ekhFYXtlgutjNUx3HZcDr16nvGqEnMKD5EEGK7QwDFrbp2amzf7R6YNAuAfXhNdPkFb1
         MqMWaodrS7PCng6RUHhH1utWjEd2Dmfp+vEzGDi2WNpGmJINhtiSoFoRZFaz276SqfmH
         iM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754569305; x=1755174105;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73iH4wasKzrXgaNXIqRiPRT+SR9a1gFj9x2fb3CS49Y=;
        b=NTdMk/CnFkaKAQKBBSh7AGltsJx/Q6HO388JaD14vkOz3Ff6zLgYiOKI7xbHwOjwB5
         69Ie/XDGQTzkM7p4JOlkmsGvzGugJAzp37pLJRTsr2ukDF9/7KeekXYX4soMPkIE6qdC
         VIaoPA+qgbwAYJDN0aPzmMVxzaMOod4ZagOPBH4Fi7pnnQwWkxVr5j0ktzQ486QD7tEK
         HhVOL7OiPl93AfWMNPhYDeWR1EuzhSkM1Dt2jRSfCVWborfP9RKayL6DpzGAu+tiK56H
         pSw9jlyTT6GfgWSeCZlyikgnDyHUrFN2Hx8dCcFPwSdCp+qnHuYPkVbr+0qsNU0Z3MHO
         Lagw==
X-Forwarded-Encrypted: i=1; AJvYcCV4KdY0Q8E/9DqcOe1duPZUDZhtU2uQmIWRl+9qLflI3BQAz2Yfku0hVTAPybkcWyi38rQONj8x7Q==@kvack.org
X-Gm-Message-State: AOJu0Yz2yDvlQ4G3PdvtaLX3sTKSWrLLb2W32y4GoIECS5/medQQPAVZ
	WeUkUrYuWSM00BvcUP21Tt8L8cCBh44h+oZLBvfSWxBLUOGEPfINv0L3CvOgvfUBvg==
X-Gm-Gg: ASbGncsAMfR+q9DAWuhc25y2jQjoZ77g6SdEUReCREoTX4v6kMbY83jluglfGcIv55U
	Jkh1Gd9yBK0IsZsF3kEFvAy0OZkGcHWVj+4CY2zJc5kI5xVoCP055Von53VDn+EDxY6pP37pPHA
	Nl3P1YSj24xYqamJtG/6cV4H83FoBw8RlGstI9pVt7kx91EfdiWKWVxHdVX8xDsHnTtgMkRr+xb
	mNjzem3sS7dyfa78y3C/L8vPRAyXYmjDNZhh/T3Owv9+2C3rOV8EGqHUqWdsFgYmKsIQOLNeqmv
	0JdDGPRDq8pv7jbm+0T8fJq5l4MtIytLmQ/eNVO8596Zla7KyKEkXhjGPhgJbyUUhAh8GoExUCI
	wyrJ+1LKduWp8MgRcLitLJVE+6Z2Ak7u7oa2H2+xoCwgIMU2XHsMNcAzn1Fk8CqM3gM/nYF39zI
	UzORhRv+g=
X-Google-Smtp-Source: AGHT+IFeyMuWjhDETChRuvVfNLHPQN/zNP6Vl7YFSjffHqjMAZtfUTwYyCDFmjGyWYSS5kkc6h/9Og==
X-Received: by 2002:a05:690c:498e:b0:71a:906:2874 with SMTP id 00721157ae682-71bc971a07fmr92320687b3.17.1754569305215;
        Thu, 07 Aug 2025 05:21:45 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71bd6af0fddsm7484467b3.11.2025.08.07.05.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 05:21:43 -0700 (PDT)
Date: Thu, 7 Aug 2025 05:21:29 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Frank van der Linden <fvdl@google.com>, Mike Galbraith <efault@gmx.de>, 
    Hugh Dickins <hughd@google.com>, 
    "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, 
    "linux-mm@kvack.org" <linux-mm@kvack.org>, 
    Dennis Schimmel <Dennis.Schimmel@kuka.com>, 
    Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
Subject: Re: Realtime threads delayed due to kcompactd0
In-Reply-To: <33275585-f2db-4779-89f0-3ae24b455a67@suse.cz>
Message-ID: <771a8fc0-8195-44cc-55ed-c3573d497d2d@google.com>
References: <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com> <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com> <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz> <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz> <DU0PR01MB103857873A56FD121984568148226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com> <c48f2877-4d37-4310-995e-fc5c2ae9a366@suse.cz> <DU0PR01MB10385C08C119276D99A234D978226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <33275585-f2db-4779-89f0-3ae24b455a67@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: sjkwb4ndix89a9z78rdak7zximtygdg9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 94CF212000D
X-Rspam-User: 
X-HE-Tag: 1754569306-488828
X-HE-Meta: U2FsdGVkX19HWQVhevdgt+ollmdtH8AEdPq1UmNWMNlzhtnFwON9k8KQwCKJry+K88KFRUXdH7sAi1Sqpp6kqGdPvvKmBtgU+ZA9gijnM6iovfwhUTK/+IJBQkCRSkmIUGwps0X8QyEODrA9yBB8ARBQLm0FLyh2xUcOf2jK9m30iC4TfD29cXa4sBEwxkc+H2WxDXs+vSOzBImcSo70UNe0OvyRYIWTQ02S91eM4OS/Ym21k3QiwkpukbFB1SJaqPU59vZijgZZGxyYsojFZkQG/b+CSBppEzocvZPlOVmDShsp/oCjA9xwIqGYhVBG4Fib37Xi5Zk/G+KjWkN86XAHLkOkVzw8kiIHlpq3fnpLfTPiA5rHl4oXWbT2Es3kaPAwQW1FA0N4zy4ocOT9fIGi8gpQv4FIqF2l+JW5taNTIVSFn1MG2mOUno3B9q3Z3fcV1AiK9J9B78oKA4010bf1jsvoCgLQPqdh4ucieaX2QgDMQafiBNm+ykV7eSTIX6zoxyzw4n8gzCuj9sM6CInzbjQx7GBpGEtyfRn/jBSRTE+fkdbR4igB5QXcr1fzBZpq/GYrAWSyFTN/BXkhY5IV+GEEd7eYavOe/ZUbkxARRZznnBHTsCKuks7AoENSgcXWsV9yNMXY3JTHSTXD0HArxgZMUT1lK4ACfzobh+Qlck7G4Ve7gIWWgVJyXpsijdyPxC4NoUZaF7yuyXMygloCYPR+iy431daBMJYTcksfuCS76erEzcFKijjC/tlklnBIjWND8t+mfI9k1Tgb0u3YebmD/vibJlKs5cFIzUJcxtQGDLjFyBm8mBCnzwbnKHWfXn/4YmrYDZnfByJEb6CoHAG+t3e7vF5a1f/LOnWAyqW05TJGDCH6utXUmgXk3FONmh46sRCMRDhr5tfeCbJHEigzvUGqOElWa7VosRbQ6hacQs3NX+e1ShAQ9CmCwEDSDN0/PanMhLT+okB
 DwtHtNu8
 B9PyVeUU+UWInXAVh9LYxVYIP3kaCRLOpGaRFaRrn0izKinFXH6vTho7yfk/ZG2ph9itvs0DjIT/yzvJHFfq9RteURdo9C8gJpzAVYuEUHqe/wzOvTwXIZh92i5cYD6gSzoc2M2IiL4oBnJc1T5whF9fDNIja+VVyr2FFUsARVjyWyRzy3Efup9Wv2QgEoIPdNxKgdyir5f9yD8w5k8TcZWm5yKhIVeNyDtfJhmdbsAlbZjyh+Azy81oRily6H0QZEWaFiN38V5/KHjTMqXPxFVLmlL8lWUSXG4A7/NQp3elhgX1cp0UFV0XO/sbwtl+emcCcn1lZHCe0vtltJgb52yBCt7QV6GCvmkeHqGYgclrKuZotwTsN/cnNCt5Midyt8scbMbm1ftWo2nkKyljAdYtbd1X5dx9tMTTtcJmvaBIYtQAOA/8dlsPD2Ga3AN/Yrp7EClbZ1vR8OucXcOyznWIoDN+pGtGuYhiJXektJg1wxHMG01zC5FMfVakfT4TPbss5PCPeCkYnvDs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 Aug 2025, Vlastimil Babka wrote:
> On 8/1/25 15:40, Alexander Krabler wrote:
> > On 8/1/25 14:57, Vlastimil Babka wrote:
> >> Hm that means something isn't working as intended. Do the pages have also
> >> the unevictable flag?
> >
> > I have checked /proc/<pid>/smaps.
> > Neither the manpage
> (https://www.man7.org/linux/man-pages/man5/proc_pid_smaps.5.html)
> > nor kernel source code (fs/proc/task_mmu.c show_smap_vma_flags) tells me
> about unevictable flag.
> Ah ok, you checked /proc/pid/smaps. Since you said "pages" I thought you
> meant individual pages which would be from /proc/kpageflags
> 
> But IIRC getting a page in a state where it has an mlock flag but (not yet)
> the unevictable flag should be rare so I would be surprised if that was the
> problem here.

Agreed.

> 
> Hm or maybe it's actually that the error can happen only in the other
> direction - page is unevictable (on unevictable list) while not mlocked, at
> least the counters such as UNEVICTABLE_PGRESCUED suggest that.
> 
> Hugh knows this code the best. Do you think we should e.g. test the mlocked
> flag instead/in addition to unevictable flag in compaction to avoid
> violating vm.compact_unevictable_allowed = 0?

No, checking for unevictable should be sufficient.

But another idea has just this moment occurred to me: anon THP splitting
is another user of migration entries.  Is it possible that kcompactd is
not actually the cause of Alexander's issue, but that his RT tasks have
(bad news! shouldn't be allowed) got anon THPs in them?

Back to bed,
Hugh

