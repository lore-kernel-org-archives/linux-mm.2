Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED829E668B1
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 15:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600216B0089; Sat, 20 Dec 2025 10:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AAEC6B008A; Sat, 20 Dec 2025 10:12:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7166B008C; Sat, 20 Dec 2025 10:12:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CAF96B0089
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 10:12:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD9ECBA613
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:12:13 +0000 (UTC)
X-FDA: 84240190146.28.EC5CDA6
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id E430916000A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:12:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cwPBHw3+;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766243532; a=rsa-sha256;
	cv=none;
	b=5bhMhWwbZhBrvkZty/XADNWRBWVHJ9bbV4M86o3LgpjRR4xZSYQ7s6otMN4wAU3adj6CGz
	4l9n8bRdw4OS9hmmgA3BN4YB0woG1+GbU67glb+OPxxr3SVsWPgBF55GfOFXHr0cUNTWZD
	03rX0juf6YpqGEhv0bX3T+nW6ZRsC+o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cwPBHw3+;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766243532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NirtzK3cSKP6Dn8RC3SUqGY+8QtbdDa8PCdCAnfz/Ds=;
	b=Yu0iwh0owiybIffjkhqpLi1hvKFbY2B1P4L2ioou//SZR2WDcZT33Z/kQ82kIxNOR0eqcJ
	y6zDzQjcf2Ua7+UvT6+RX+ZOHwqlXsQ/0tuNxGswAKMq+xMjBc96P8cnq+f52UKR0u2BUb
	W/2T1j+25AO0A8UyuGkaARkWyD69hPE=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso2895036a12.1
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 07:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766243530; x=1766848330; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NirtzK3cSKP6Dn8RC3SUqGY+8QtbdDa8PCdCAnfz/Ds=;
        b=cwPBHw3+Lav8bYeEoCEFXeWfa5qnw8LTXbx+F5uSCWjYG94JZTcLPRmpwbLAiI05mC
         YFjO/ChbBHjPjBdW1ODZ/k/aXM19089+9nh5lwRqGVp8Ld8k3gcyI1ag/t/ujynXrKLa
         GYhQvp6knXntvJjTb+wnRiv2i8+2OT7r9ctvMVzMK0E3e7y+tU0peUjfra0LbXx0RKqU
         iKW+mSpVKeJ6Q0aQSH+Hpa2+h3vL7hhP14CrRdvCPZ4MZyjaK7OGzl3IBG6jAXE6QoIR
         WZ5r1ZV6tMpGykKAauqhKYAtsh3XlmXkKk88WT+9ChcgWRtaStupQmIc4CwGk0hUjpwJ
         U9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766243530; x=1766848330;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NirtzK3cSKP6Dn8RC3SUqGY+8QtbdDa8PCdCAnfz/Ds=;
        b=QBvDvwDt9YEhLG71JjcDgBkKMexw6f7KU7d9tpSQ9i77LYvSARHfzkTVsEriI/DMaZ
         obxCzSrFlZe+FqpY+/nip4cBw/0H+be3oXLTPxn8PQdYB36k2oRdBc6af0dd6LTGsGwK
         X5xCouhhnSKdnNYddet7J3op1jrZsZKjF7aexVlXsTR475xC4lDXoKkaN38seyHz2f3W
         ocnZyLIN5+Doi7EODujXx1yDadOtAA3CSxU0eeoq0fnPp0Kd6u7Fg+8tvL/+vY5I2CDn
         7t0qo4oJPHTVhF0F5+2q8efk7zBTXYJcQjdL08947dDjltGEAI0BjC0hsXl5XbJ1lLYU
         uYCA==
X-Forwarded-Encrypted: i=1; AJvYcCUsCUpWToKIJh/hWbqh87tuXIGBzvRYNlW+uYZcVkwX4T4Po4uJ9HV7fAaYSGh21WE43JGsCA7oWA==@kvack.org
X-Gm-Message-State: AOJu0Yyzi3Jl6VltMsr8d9gn98eXLMn3LbmZYzEbD6H0LAC3rDd4IGfN
	TUgjFyMbJ6XDwHZ752yK1sINjIJODWwGyTDmXEB24mf6Jw3iFDNJ81mgDl6JOrQVI/NuqhPH2ze
	CF3UobohhZwyM7FL1+WorLSuScs0584Eh4gzp081fW/0V7pz6bDUsMqs=
X-Gm-Gg: AY/fxX5sr4hJXWz+an16o4s0IBG5f6iAECo7UQKmxWUJWJZ/xkTM/8KLDvPtQAt+Haf
	ZUDJ35ud9xrrXDHwAywH5W8YF5UDnpxGJiEoxB7x7yhtVh2q8r0sPUZttS6jfsv+zl8z6Z8pzmc
	bMeynioFkrJq60gY4A4A7ZkV2fgrSFZ5BGpeaXHVaDRB6Rsp+7VfFMXx04wbU0kRStDfIx9O/R0
	GXfVGPP3TqWnFRIm0dRic+OaDOSTfpcx7RZybgjsSNqqq+AzGXzvnMS+DQIuHQWw4MMb5zOs53a
	7RcO4NIM5tgMNIgwB+7tzc2V65jtpg1RyvRb64Woj/F+fixbeoyVlvIP2o99WA==
X-Google-Smtp-Source: AGHT+IG2H0JMzpZ4Rw9d+GSeTdHtlvEwfcgulZM7WmjLKT/BwHOEpNubFax4Xm7riytdiegSHPUBkYePz2N2H5EqPpE=
X-Received: by 2002:a05:6402:34c5:b0:649:230e:ec52 with SMTP id
 4fb4d7f45d1cf-64b8e935a65mr4687631a12.1.1766243530490; Sat, 20 Dec 2025
 07:12:10 -0800 (PST)
MIME-Version: 1.0
References: <20251206230222.853493-1-pratyush@kernel.org> <20251206230222.853493-5-pratyush@kernel.org>
 <CA+CK2bAV1y_LySjyj-wcn1cdSuVBdC+r+zQL7AQTY64nk3OxuQ@mail.gmail.com> <86wm2hj0ky.fsf@kernel.org>
In-Reply-To: <86wm2hj0ky.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 20 Dec 2025 10:11:34 -0500
X-Gm-Features: AQt7F2rkD8DzKJtnBrRBVjSiNOllvUXl1o05w5fOraa6mNPG1z2m3wrrR9PJQmQ
Message-ID: <CA+CK2bDWF6pbNQRkJFa+WcD1pwUOr3yQdrRUs-mgLWu5ght+7A@mail.gmail.com>
Subject: Re: [RFC PATCH 04/10] liveupdate: flb: allow getting FLB data in
 early boot
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E430916000A
X-Stat-Signature: ga69a1z1y63cbexn3wke1kxh3m4tyw9y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766243531-866775
X-HE-Meta: U2FsdGVkX1/pByF6P0z09aqEqicptLR+oEF9na8EHj2ECl4fn88OG+ppgVO84h9Nxmy06fOeqvk4pFxC/k3/n4WlG94K6n+5QUW8Mpqt9+622fKtWqJx4iCgoW2MuPetmJjHiVVZpUK7v1mVrNjEoJVFFf8kuuYeuUC/2a+di7Mvrjk2C8Ev/cGjmS5L7pqKp2X00KEkfDLPmn7iPDewKM7rvbHOHZqD4TxlCqPKcM6smj5pFh+ykqK6Pcb2Tkt2hJjnZ2NcQ/7DSA0pPKVVwxefkPmLkzY3YIKBqa8CrnP3x2MAN+oh4s/HI3QBph9eUSS/0mKzYBK8vJuzE6tX8oTmUejtYG3VoxgZK+tcxmD9o0aX7hzRmSy0acQN8PYAeBQvoaGEgAbFUT/2QZJPRSQAWWXnvQbWaO88VwSccLE8FM7BvGJhfpREVwvxBICRpZ4+2d0TwyA8KWCYGa+QJuW8maiQOxGJ+RzFePHyP1u8nFP2zU4jjmJPQcP99/XN/LVRlTJkxzVfbXj1tagzZV3Nh3esnVwGYAx4m5iKq3Q5spJSuciKMSxYdl6KCbrC8wQSaccAgyHyzqynoAo5r95o7iXzo+5m4cHfUrjOAqNTf6UIjzl5f67VTHJU8nDB6lJUefRXYV8cVmKWUS1YACXEq4+pKaQ7qtCUzCogmFR1brBDgINzdYxXXfLwfW61QxO5mLK5Rbiqd7aB6i/JhtR12nuyUHXSy0fV7wluSO49YEs5U7ZlqjQcasi0gHCmtXlnKdouS+Hl5rnsQJDDFHEb6L7D4znoG1w36m+lOvuQyP4REkpRA7OYqaziyBtqQRXii9vk9p1r5JiZsRi/h0UA1wYO0coDXWVnv7SWs27gloS3SHLgbkHodxrhnmoxRXLbJdk3bqB9aUg93+1g8hGp1BI599Yq9cN8AnGEvAVayeVVVn4GUD66vpw9uC3zj76OtFoVMYi3BEDa9N2
 creNxPup
 oEIFKQZYrLAjfEcD6SjgfIQK7mQDC+mYvXTKEH/IPRXYUb1nGVmOD1oSR6Ib44IwtQLJK+60VCMAi+bpHv0Y39IYf61Ds5MSKVZG5G4tHlq8PgCDTyU8SP4FpC+OvwuOTlzJgfhFi3t3CiqZ8icGl0Pr7Yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > [Follow-up from LPC discussion]
> >
> > This patch is not needed, you can use liveupdate_flb_get_incoming()
> > directly in early boot. The main concern is that we take mutex in that
> > function, but that I think is safe. The might_sleep() has the proper
> > handling to be called early in boot, it has "system_state ==
> > SYSTEM_BOOTING" check to silence warning during boot.
>
> Right. I will give it a try. For hugetlb, this works fine since it
> doesn't really need to do much in FLB retrieve anyway, it just needs to
> parse some data structures.
>
> If other subsystems end up needing a two-part retrieve, one in early
> boot and one later, then I think it would be a good idea to model that
> properly instead of leaving it up to the subsystem to manage it.
>
> Anyway, that isn't a real problem today so let's look at it when it does
> show up.

FLB has exactly one .retrieve() lifecycle event. Once called, the data
is considered fully available and cached in private->incoming.obj.

If a subsystem has a requirement where it needs a specific state
available very early and other state available much later, the clean
solution is simply to register two separate FLBs.

Pasha

