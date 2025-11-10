Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4164CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 11:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53EC8E000E; Mon, 10 Nov 2025 06:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BF08E0002; Mon, 10 Nov 2025 06:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D689E8E000E; Mon, 10 Nov 2025 06:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C09968E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:27:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 829615D488
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:27:34 +0000 (UTC)
X-FDA: 84094472028.06.AB65B9F
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id DD5EA1C000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:27:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="bLhs95W/";
	spf=pass (imf18.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762774052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWgMfXoYBXjSYZ66KLBQMvY/lapHUz2YPyS91z8NS00=;
	b=lVs/lkZ76mne0zva4EBbaMR+ZS4eWIzHzv6ekOxU14VNvKgLrW49kBzsRTMY0mTcDlc0rk
	kNNp9p6F3xVtX0jRPx3BwIWMCo3tRau0E3oMTYlzyFHaka3WN/C+/x2119FX0643Fpo0XK
	/UTHAcAvXkmWPIUyet+SymoBtWLuSkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762774052; a=rsa-sha256;
	cv=none;
	b=mFSxGv5K8YmGI7dmjPgn+gJCoAw07ags8Btl59g4c+KVdgro+CoMlvvLbDyGpVTkkpW4gn
	H+ifSxGA9NcMP5GYUMJ5VNn0xCDBRGTNDUZnFJVaA3c7FhnJzy4jVUGP3ISlh9Vji+JjNI
	jF0kEnxejYw69QQqkw8NcfWXFEOqEJQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="bLhs95W/";
	spf=pass (imf18.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AF27A40E01FA;
	Mon, 10 Nov 2025 11:27:27 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NAiTqxELW6D6; Mon, 10 Nov 2025 11:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762774035; bh=QWgMfXoYBXjSYZ66KLBQMvY/lapHUz2YPyS91z8NS00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bLhs95W/Y38hWFhNzrEO1KSToo747GdOwqzY6ycP3L0iJL40i3cGSgg3DRgK/LCFH
	 v/WIVVfuFPv9M9VpZRxT40A201WTeh0Am8AQ8kBifbAWiQQGX5oNAeyc2Yrnvog57H
	 MAa8wxhua2eN4DyeWLFiyk/wv9d0fR7HKJ+b2kCfRB14u3Ft9qvfEiHWK1W6vUEGl/
	 cDUchQp9ht8XccWmAHqji3kS+/hZg8gjBEhjBDHl/h151xxdWHQUPiZra/vBUTaEMT
	 PDxOODs8M1fDRHpE/HmYhKyl0zReEtJml/4Ye3eMgYvJ6Jfme1ZBrAKbxvxFg8Cu9/
	 xtyHvgLgMWjWdfpjlvMUzirjf/QsXXHeyqdMAJ2aCHbdcFM9i0MbpIG1+BWyVDQCyB
	 RVseuZj0IAO2RxcPkHpVBV2FkoDRu5vOW8qd3zOalzvfzVW7h+6djWaXbFlskU4HAK
	 UjZe6uo1KgsY0m0Eu3EYcT3UbYmCmHO2j6RViIf2qYhYGHWyO1pzTPyeV3yXu6EppO
	 HvONVpu4713wvF0bgjFriAMjtpGCNC1q291LO+eI+iHVWCtWe/jPVAtn12OIe2P5Ot
	 J4Hpju/asE5Perz/RCj7loiqu1aEQ8PqgIycmAK3Wf559DTX+3qVvSaLlt4t5N6T0k
	 d1g6myE5dYUbESrhkvCg4Tns=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 3AB2D40E01FD;
	Mon, 10 Nov 2025 11:26:48 +0000 (UTC)
Date: Mon, 10 Nov 2025 12:26:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH 02/21] x86/mm/asi: add X86_FEATURE_ASI and asi=
Message-ID: <20251110112640.GVaRHL8GME4ODowica@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-2-2d861768041f@google.com>
 <20251025100642.GVaPyhMp4CEmsYW3xy@fat_crate.local>
 <DDSLTWM2FL58.3MIDS5WUOEEZW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DDSLTWM2FL58.3MIDS5WUOEEZW@google.com>
X-Stat-Signature: cudtdo1xtejmfhpuphj1dsrfmos9j9yh
X-Rspam-User: 
X-Rspamd-Queue-Id: DD5EA1C000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1762774051-858925
X-HE-Meta: U2FsdGVkX19+ctrSZl6ANnJ7sac49OQg5bm4u7yrciCP8+/KOl1JnE9KstTHxs3Pw11CU80Ae0yIjV6aYygShHm+7u8ATSkH8nlVwfzmR8+9kSO1x+XoGLW35uhqGuSJOTwNqWWrCvL/y/nCOOVxmDxcTZC0YFVZQgHUyCuYEZY6XsgQ1N83zM1l/ZB9D1nurpVXU2cMB55qUxoLEhbppmeCElhKykAXFQCQ8PC8v+Gc0JyvK2YpUVRtnl2kfnCaozhjHeZIalIw7jYQ3+rLFLwOcE9ln8Rd2NFBQsfl4ZUdTPmo+Vv+9zFws0cjWnEf+H6zJxG2KdCLEBNcGnQLi4LhjwB516dkXkJkS68tpJhGhMXR7pVPpLQ9DU2hv8z9Hmz6XNqytSgS7Pjj9cQjvvqE9L8ecPeYGyeDCcTCjNVci4S8OTLNB9LCIimFZ7H5Tj2ZvPHGrPXWsDq/OBSHX2Wn+hsk3eXAogCKqdCnwbG8Rj/RlubUfBsX0rpCO6/IuJHmlCjhqOoaaXAcR8ZRwdpmLifAncPBHIGSIiXNH+JEF8q0uG2gBZhHT7lG6CQQ30DEc/wh//YoHfGWuNsTr2Sv1zOw41fMBhI6F9ELeaB95gyGqtfNZwIYvEwIe9rsas7GYHZKsa84ZauPQNGD+DBKdOUQS9+DgtuZMblqFXG8ZXKLNOVwXN0XS0veGuZnLdBUmgS/xrwncaLSAcOvMhmI8aD1ufS+GyAXDdNHxP5BESlMjfyLR2cJMIw8cXxXCAOWcNK1xeSP3MB+X4KKIMjRY4xsxvzJzONj/7H9wC1yA1Uh2NvUJFFeshxorDAcuZ8WKpLXoeoAgbw/K+4UttxO3khu6ujcU0wopu0NX17NP0+ktK7hLbej6iiqJrfmOLwYfqYZl/0BOyTcwW2qrCctv6aKK0NWP2hl0XCIFY/2hQNYwyZu0RH4uhtcsZWkG3eSDPiooBKcwFJFc1B
 4H05VmEd
 YdTSPO3XWVjQoDb3gBmPAlsiVPH7hA8wg/BB/Al8E+IdILXApZLKynR0CjRQsLy0xhWP7CKYn7+LLVV4OWyG+4ePDzNeuD+btWeVm4ZpTizy0LxNVwuMAqaUripo+g65UGmKBcCzYwU0vKPM/kikpeoe+dtEu1/pvR/N+IbOMSFfYP/6DeLIncYPdGkuCu+C2vSFPZIUJfQSeJi3te9JOUTUp/uoXC/YtUCmbzZ16PERl5TEW2/f1zrz7iEvmZUpQCc5qiX45jU0BaQ5YGJTo7hQYVlu1qvv2zkiOCYIL9J9nu3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 10:24:35PM +0000, Brendan Jackman wrote:
> Hm yeah, I actually also thought I had some direct feedback from one of
> the x86 maintainers saying not to expose it here. I can no longer find
> that feedback on Lore so I think I must be misremembering, the flag
> was already hidden back in [0].
> 
> [0] https://lore.kernel.org/linux-mm/20240712-asi-rfc-24-v1-5-144b319a40d8@google.com/
> 
> If that feedback indeed doesn't exist

Just ignore everything whoever might've told you or not - we override all
previous statements! :-P

From Documentation/arch/x86/cpuinfo.rst

"So, the current use of /proc/cpuinfo is to show features which the
kernel has *enabled* and *supports*. As in: the CPUID feature flag is
there, there's an additional setup which the kernel has done while
booting and the functionality is ready to use. A perfect example for
that is "user_shstk" where additional code enablement is present in the
kernel to support shadow stack for user programs."

So it is all written down now and is the law! :-P

> then personally I'd lean towards exposing it right away, I don't see that
> much downside in terms of ABI, since ASI kinda "doesn't do anything", from
> a SW point of view it's just a very weird and complicated NOP. It's hard for
> me to see how userspace could grow a functional dependency on this flag.
> Whereas for general monitoring it's handy.

The point is: once all the ASI code lands, we should show it in cpuinfo. As
in: "this kernel supports ASI" and not "there's asi in cpuinfo but well,
that's not the whole deal."

Makes sense?

> > Not an early_param() ?
> 
> Oh this is just for consistency with pti_check_boottime_disable(). But,
> I think that function actually exists because of init ordering issues
> that aren't relevant here, so early_param() seems fine to me (or, if I
> find some reason why it doesn't, work, I'll add a comment in v2 to
> explain why we don't use it).

Ack.

> Thanks for taking a look :)

Sure, np.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

