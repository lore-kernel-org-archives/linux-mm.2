Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2673BCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626638E000B; Thu,  6 Nov 2025 05:04:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7008E0002; Thu,  6 Nov 2025 05:04:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514698E000B; Thu,  6 Nov 2025 05:04:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 407868E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:04:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0776891F5
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:04:25 +0000 (UTC)
X-FDA: 84079747290.05.A945386
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id CB9A620019
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:04:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E1YOi/W7";
	spf=pass (imf13.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762423463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+w3BDnAsGzvqreZcAJ44zSfpEp2rcReM4l9Z93DdstE=;
	b=xo70P5gso09KK1W3J+UUqD8sY2zI0rXsFye8M/x9O7VS1tg9xv3hDsb6QX03alZ7Ze9ReO
	wKDIDFBqqJPJrZwYYIsGTnviakJ0E2trOXIr2hsqJzHazUgI24xl7CsaTwqRk4rkYb2Mgk
	mhyLMMrcv1YSd0p1Ofe2euLhKw0Ccms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762423463; a=rsa-sha256;
	cv=none;
	b=XPItc2XToCeYDYMZgVOtY3VUbaw1kQL1aoFgn84otjjWoHJsgqIdVABBYX9gNSB0hA/Jfq
	u94Ko6VRJH7LZSuEuVgza1fNe0Q2Z3YjCyxlcn80fc1uVU8KYVf29uX8r7LNyrfyCPYu8F
	3BmQWA0puoQhw/a8Dg166f9H3p7xgLM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E1YOi/W7";
	spf=pass (imf13.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47758595eecso3915835e9.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 02:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762423462; x=1763028262; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+w3BDnAsGzvqreZcAJ44zSfpEp2rcReM4l9Z93DdstE=;
        b=E1YOi/W7rIlJfjng5RWWwC3TgS1ViKpmsXVQFvyqpwY0ho4vMAyeQ+5Aq6Szslfbk4
         yOvIqqFY/k17hYuF2CBtDzd9chIzoBF1riZv3V3WizIK8bW+u40PRcH13EfHh6P4a0Hh
         wghJZmyZe50C2BAVhm3mGRqfmOPHw3ci9MFa6majnyfwQ67kQyqIr2kfO98aA7cG1oYa
         63wt6OKak8nsLrY25wFRGk+KcTRP4Ju9be21OaRZ9zIloUG64ZpzZoy07gyRWsOThG0T
         9/PZ8NKJQPZSQvxYg7L4O0k9DiqUuqboa3PJyGKC8ZKjZWsTOXnO3+YIdlOSMbkToVeT
         ipZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762423462; x=1763028262;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+w3BDnAsGzvqreZcAJ44zSfpEp2rcReM4l9Z93DdstE=;
        b=cZH8Jf/654DO7pu/2JKDypV7ESy9+91OWSLPzQQMVYT/FoBoPFExeaSen+ZLQudbO9
         Ekhd57XAmZUYJ9RbInMzW/5K9H/kTz7etja5WMwLM4VieJX8zs+jfudYdLMHeVXrm2Lw
         00WE8UT2hGel4ilyMLWX6PJrRumZJhZFx66y06Md5/ZSoPcp+uJQhTXgotZHKA79OWsj
         wEokdbURnkUYbuUZNaDwhLPB0p4KOC4dWhjapu19XPGN1N1MJILIfiTcTEoa8u64djIm
         JJ2PAW8CjZMHkQ7r+z3230QpMwPT7N5Avm5ci3JDSVH1P0rmppQ6l55HyiNHmN5NPYtI
         kxOg==
X-Forwarded-Encrypted: i=1; AJvYcCWffLRkf4GBtASji1oTdMAlZUWNt7gyELD2pBcbZaksiy9OzTrrvaQkSQlQ9lM8Xti+u3cLHEZ02A==@kvack.org
X-Gm-Message-State: AOJu0YyLCWeI9Vxli6BR/oydd73EXvwedp3qOTQrBkkTjrxqRNnREoE+
	rCOKfREwhU0j/ZLEgn5in+icAmDlmDPUHLF/0WM1OGY4zy+Y83qRk/nfwEpoCA==
X-Gm-Gg: ASbGnctRsFWtbSisrSnmyJSTHAGoG2nPiRN8JHt3e9pD2aJ+BfN1ZMjq9C7+AY6srlx
	TR7QRKDsBSzyjcbce50bZSDMcSd4+4blCgD3f8v4vNya9aJNJ2blwy4MYQyVI3VwLVdmS1qtGOI
	f+DUuun8CvmXwjp03xg7JXEzM2hH4yeCmOmO/HGmTetUdhJAXnzclqKSSbzA24+bYbEVFTtchlb
	4B6zkKIIw3R6B5MgDa5a8/4T9Wd4cSnPG1Sngx7JkFLxTSawLcC8zVzZfKQps8uAiuYD+8tcrqG
	BuW+rALswUv/FXUTfnIZKlOEGjyFJnekyZuR3ksF3rqmePSdk+JpVv2/Di4csbjmVjGJGeZcFND
	bmrab6zYSjdr652LqDUUZX7qOH5g9GQUChuScqmqBY5XSxiFv2Y6A/yI66uknx/6o1LUlO5oKn9
	PYnzRonhv0ap8xzAQi3tZ+AGcDTBEZVG5Nq82vEPwh7XCIOE/EWAzx6dpTvuBaIRJ1IpXM7cMrU
	wCBdkro42q2/s6AYdRC+uJwVjxLzYg=
X-Google-Smtp-Source: AGHT+IFUZoN4t/54/JqequN7K9NH6vqKnEE8P0IOJ8LDQpDApFTAH+0h9GwpCJivw3pgLij/lafz/A==
X-Received: by 2002:a05:600c:198a:b0:46d:a04:50c6 with SMTP id 5b1f17b1804b1-4775cdf25edmr57482415e9.30.1762423462094;
        Thu, 06 Nov 2025 02:04:22 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477624f86a2sm37711485e9.6.2025.11.06.02.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 02:04:21 -0800 (PST)
Message-ID: <2b4a69db-7845-4289-b962-1144b708f53b@gmail.com>
Date: Thu, 6 Nov 2025 11:04:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftest/vm_util: remove unused variables
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 thomas.weissschuh@linutronix.de
References: <20251104062855.2468-1-zhangchujun@cmss.chinamobile.com>
 <9c08ffec-81fc-47dd-8830-c81b28f4e9e1@lucifer.local>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <9c08ffec-81fc-47dd-8830-c81b28f4e9e1@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: CB9A620019
X-Stat-Signature: coik761a6djz1xrmpu4jj4g46o64g7q5
X-HE-Tag: 1762423463-570564
X-HE-Meta: U2FsdGVkX1/mqhPiS1ys4gJEHTsfUzuRErmf2cthtIOayv8h6QvDOtuwbsXkS+L8ptFvOXray3bs9skBRXhCy3F19XRiR8IXBYw/ShSLZxha5jYFP3gqV3JKNyQ7Ci8P2HqI51qj+oW8EKpZFIezMZq6bmUzU0WXVbdWZlnYRAgNu4lMs54X3nC6kEFighSx6/d5qF/RION9WjE+qWeQIQ3H5lUPqJpF53lA4tjRWue//j3YS18tO9HqX5oQDIMLfa69zZgSs7XEzStnXyXdMn75bCXzTE+M4NGCF08FGCYWDaYMT5DiHHBwLQT7SDbNDciHUY1x8Z0bpfG+Oo9n/4+hnieMqIMmYYPz0KXFjRxoQx6IInCbyo/gZYGddIxfn/tckcBlTYmj1xwpMo9vnguUdtYdbrc2AGvnqpSNo2hr3aY80FoeMCK5foXvCcL3SKUb+01LiyDCvlpX1IQSTF2CcEUD/4BhE9HtdBubCyClD2tYkIKMQ8jVk9/MDdX4uvrHsGoGaJuYg4na+6fYmhzHNs8nW8IRLjdZtzHOObip3zpBwSkaLz+RW6RRZ851x05zxLlhc4YfQB9l/Dukqwo65haKSeVWaJr8N5tGw9zrZ0/oMdcFdLaWx3APG64GhLRPwoGm2CyMokDqv5+Vt8HTENAdAWPk+EqSQiuxy53snn+k697m8fEhfl8OpajYUgH/o6eJX7H2zoPq/zgkEeN1Zmkk3aMOkXtb+J/UfVB+lmLh0KLq1+4o75VL3wueSDpMImjuaBXJpNKUvTK8l+SN3dsxLSKaPBXPhNv/EPGJ+SQVVr3AL1gkQiAMFzHKv1OxKP/w1SmHA6r69MguND5LkUaeYWPP8vJnXfcOeCsJg6QZ9Z5/lVXJLnINeVEzQVW+5AYTHuh6+sBSjDsPkzoQfnLG8wimN/2mM5XDQsdGNuzbbBI6lXZpniNR6eNVYlXK3tkMIF9gAHTVsQ2
 JmvGJvlA
 E775eYyny2KcWa4PNQ8+PrBvFwqWaegvPhKIQaQ2jRK6bgbEyeyj8Fc8aHLpKiJrOpy+H3HJByeNQdrdDlAyxw0o9GVkTjXc+CaJSxuxwjebWsohibk8vfJ8aBgyGVM7VtKX8NAk8BVhLewTJtgG8e6brnghUwfNGbzR+tzvynEL3oU4kYJAjdAPZmqii3M+BU3MYZ/CIhTmwFZ49TFHDP3stvQsRILjOHxUlWpqlfhZRKGIgA4Ro1lEpFnroXWrcX6lIoljyEHbnZKUTDbpulIytI8r+KPZ5vbQeghoM6MapwMWwrf8RsZWLqKCzLiswUJNUZL7/i57UrWSIQLPXUlQUCW1DbV9hNq5VnCxZhbEPX1LGn7rWH+l7FXYsCmQRSS1hTywduRs1nH7lzZVyyyofXEmKm4+G0egzC0a2a/QlnESW/OAMfhy6R8+A+0nMLX2Vbj3Mmv5xr04NhSfCrT6sdij2hrZUU5NGmjK7m6dx63CUkOHWlGwioqUEAp5iRpGPFkSdEVEgriFhvPQ17zakRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000063, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 23:16, Lorenzo Stoakes wrote:
> Andrew - can we drop this from mm-new please? It's broken the build.
> 
> I get a splurge of linker errors building the mm selftests otherwise:
> 
> /usr/bin/ld: /tmp/ccA0DyGC.o: in function `__pagemap_scan_get_categories':
> vm_util.c:(.text+0x1e9): undefined reference to `__page_size'
> /usr/bin/ld: vm_util.c:(.text+0x2bd): undefined reference to `__page_size'
> /usr/bin/ld: /tmp/ccA0DyGC.o: in function `allocate_transhuge':
> vm_util.c:(.text+0xb90): undefined reference to `__page_shift'
> /usr/bin/ld: vm_util.c:(.text+0xbfe): undefined reference to `__page_shift'
> /usr/bin/ld: vm_util.c:(.text+0xc52): undefined reference to `__page_size'
> /usr/bin/ld: vm_util.c:(.text+0xc67): undefined reference to `__page_shift'
> /usr/bin/ld: vm_util.c:(.text+0xc72): undefined reference to `__page_size'
> /usr/bin/ld: vm_util.c:(.text+0xc87): undefined reference to `__page_shift'
> /usr/bin/ld: vm_util.c:(.text+0xc9c): undefined reference to `__page_size'
> /usr/bin/ld: vm_util.c:(.text+0xcc4): undefined reference to `__page_size'
> 
> etc.
> 
> The idea that nobody uses these variables is simply false, see vm_util.h in same
> directory:
> 
> extern unsigned int __page_size;
> extern unsigned int __page_shift;
> 
> static inline unsigned int psize(void)
> {
> 	if (!__page_size)
> 		__page_size = sysconf(_SC_PAGESIZE);
> 	return __page_size;
> }
> 
> static inline unsigned int pshift(void)
> {
> 	if (!__page_shift)
> 		__page_shift = (ffsl(psize()) - 1);
> 	return __page_shift;
> }
> 
> So this patch just seems to be completely broken?

Grml, I only skipped over the file and didn't think of the header. Nasty.

Note to myself to not trust anybody that they are even performing a 
basic compile test. Hard to believe that's not the case when wanting to 
contribute to the Linux kernel ...

