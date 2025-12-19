Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C672D7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14ADA6B0088; Fri, 19 Dec 2025 10:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1228F6B0089; Fri, 19 Dec 2025 10:52:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E6A6B008A; Fri, 19 Dec 2025 10:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4F806B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:52:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91FBE12B75
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:52:01 +0000 (UTC)
X-FDA: 84236661642.02.F1D2174
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9FE71180019
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:51:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mQ2pC0Sh;
	spf=pass (imf16.hostedemail.com: domain of thehajime@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159519; a=rsa-sha256;
	cv=none;
	b=xNv3O/+9fuL54kcvxJKkowBxuIoOT1r/swcf5gIVGfkWBakXa10sQ9rqfp98ctiN7SBD0H
	tfFrtNoRTt/QUPgEYxowkoBP32DnsSRVHweyL7g0FuuBwY++boWYZoluudr95aqxcC9j4U
	2cx94b+tFtd+s3cPcQxFWNk8hKEnC+A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mQ2pC0Sh;
	spf=pass (imf16.hostedemail.com: domain of thehajime@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0WQJhwCQ32X+kFsVdaZCrIfidsg4gOtJ/PUF04u7no=;
	b=hiHBUmh4FoMFxo+OSSFK6YI1dPjrh8+30dS/ujdX1aMVMV93uJglwcQm/CA8VIuLlNAZFz
	XfPAhsOnfi/sn1qUcPSiCse5rL5ZEOMIiZB86y02BBnhHyY5klRI4i8amRqBUKf6FatQoU
	lIVbUjcHiIxtOsGgNDv4oFPLLTpiXbM=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed9c19248bso16097501cf.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766159519; x=1766764319; darn=kvack.org;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0WQJhwCQ32X+kFsVdaZCrIfidsg4gOtJ/PUF04u7no=;
        b=mQ2pC0SheXBmJKJUngKTl/t3F1dGCo386s9KHfiZ5y+iAjfepIIPgpLEyn7tPh2ift
         i+X3lf5GZNvs6Ly8z5gN0hiTm0ddnXVbX3F1n55ev1cWIKKVf8g+2JZ6qd+H7rTgINFD
         Zhr+5jEzj7HMdSwOPBbrskQhtcfPsKotSZNQC8B6je15jBHPZ8bTESqDzsTAZY32F5mX
         Ef8xV7+SFoGizwD2DEiD3NWTUlO2yE73qZJek4SO5y1uE+VsHIFKkRqye7s1oxDxmU3j
         +If/7rKFoGUjBCn8F7C+cNrbUPLLTttBnfKLMFvBNPktwJ0FLINOM0pXaLsN2499lR6C
         Mh8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159519; x=1766764319;
        h=mime-version:user-agent:references:in-reply-to:subject:cc:to:from
         :message-id:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z0WQJhwCQ32X+kFsVdaZCrIfidsg4gOtJ/PUF04u7no=;
        b=pfJ1ht8kl2RUdm3qchkKLDq5S2/tcCzo2xELU12BDxJYLclWK5WzlnyyAoGQik3pn8
         KYvAskZXXShdEFyQeLmvvRcjKJ7pL/VUqXB4l0+CaHritywcVLFrwtaxHanjejmc+U69
         ZKjPLXlDDseq8ooGTTkZXjCV6n+49NBrYCXsWxJxj8BnIH0W6YLIVRrfLUXyQztD8pTw
         6idpXMsrewn/naL+TDejInhRUf2DqBgMzHhoI3dR8BHyaiR+O5N1r2b775iKINd5tfCp
         yylV8ISDYcUfz0MziyN2WyVpCtbYBOLfiLE3aJVbfA0aaG/jLtud/njkcjV7KH2x9TRG
         YtlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeNRk4psgjmZeKdmJRWyWFrUzPDBbPjZ3VjLOC566UNYU4Bwo0CHthrbfPDhkuU05KxZzealCtlw==@kvack.org
X-Gm-Message-State: AOJu0Ywv2GHahq8xzIgxkmV1pK7h3mE0YAqv5cH4lQM6X0IRsA9XhKMf
	sjh/EIGN1oTyAxUknNR6BGKQg8oYIyAkhSlT+rykCVBQLBPojCsUz+gB
X-Gm-Gg: AY/fxX4iWdEiEVbrRDWHX1WLLlPFrXbi0SMB/+Nfh2oeZ1I5et5DKKtXGpsYB96zKnu
	Y3Jvy/jl1Nj9BNuEmulE4ZP7P1PCfyivNDWS4yUS8Z/oIpDojwClTUW3kWIdx0QMXtAPMFYEkwR
	frPr2rBEi9WVOLzHyyz1ACDmvdgBjDATJcVqKh8oTV2YbB9C1hef1PEGn+I5SRHGBZccX4oQVUi
	0cE/Au9WQ5x3bfg8OahLOsVsZR1zPbtJXzPGp8HyIAcHWD8bCvgym9boQXk85rNjPrIC9q/H0t2
	A5txX4evg3jJuDGOqgdzrwVn+qI1o/VED5mjGiN6JBNkCVHVJWf6/0R2KY1SCaC7+Lhzxlqv93+
	ZXAFoJpqOTFFmzLriz2A6lSYV6bGn4WhWrXtCV7vWF9s48NyTfJr5y5fjeF7xUgpb9W5MrXpudr
	V9FtN81SR0cSxVTwnQzClkg/WrDBZxJwEItJ7L6YcHW+WHGtEOB5b3gBWj5KSXWnWeyuKLIM9pE
	7yjSyrmys1aiC+oZ/onyhIuuxwvPZN8Rw==
X-Google-Smtp-Source: AGHT+IEYnVJQIdA6P1lt+9Y51yCVFjarKMoX4NYninUuImu/Y7sCH2WJg2qbEVwoanYmzFQweqf2jg==
X-Received: by 2002:ac8:588f:0:b0:4ee:4a3a:bd12 with SMTP id d75a77b69052e-4f4abdb6906mr48012841cf.57.1766159518540;
        Fri, 19 Dec 2025 07:51:58 -0800 (PST)
Received: from mars.local.gmail.com (dhcp-129-59-122-134.n1.vanderbilt.edu. [129.59.122.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac62fa56sm21392181cf.17.2025.12.19.07.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 07:51:57 -0800 (PST)
Date: Fri, 19 Dec 2025 09:51:55 -0600
Message-ID: <m2fr96wjtw.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: daniel@0x0f.com
Cc: joshua.hahnjy@gmail.com,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	mhocko@suse.com,
	surenb@google.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: Report 1 as zone_batchsize for !CONFIG_MMU
In-Reply-To: <CAFr9PXnK+WCOGYs_e5HiCiwxN1SdjGhmR3DOi8w0BYRqooQONA@mail.gmail.com>
References: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
	<CAFr9PXnK+WCOGYs_e5HiCiwxN1SdjGhmR3DOi8w0BYRqooQONA@mail.gmail.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/26.3 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FE71180019
X-Rspamd-Server: rspam04
X-Stat-Signature: hhfeqguupww3g4z31hty14m8refko6kt
X-HE-Tag: 1766159519-286397
X-HE-Meta: U2FsdGVkX1/DX2qW/VMJFppo2PGorvChs9P2frCX3v2zcNpxFGaMnZEfBqzeNnAbtJayQOnTgOnwVdbC0QwezOSxTbiFWxV2Qb9g8sO6YQYbHk91XP8Qn0kXlUdLQNwmDqS4VUIPiDsac2h/kYi/1W5QrES0+4F2I4n7Eom3P4hYh3VL1YcUMNNsfxPiyNOjZTpAvU+R6SHolDgZoU1Fio8FXoUm5snG8O+bBLCo8UehjbsOwablHTN2iNml4fkO8rYqIR/M5zc9au4PhyaTXoq7iAbw0P7gYzobxsZXjZAcJqMJtB+O+hOUX+gk5Spruv/OnSjQ4O7bRrXmYfnfcFkTmNSiJnUKGj0TEJl3IrjhLchmUJT8L81TeNp+XK8N2sk4ugti7dSUDATkoTNkGEm0EhNN7xaTJorU0G0y0Lb10Noe41hi58e5I++kyBuFS3l8mTfS1Jd5j28R0GqkyUewvwVjEdEvZMu/Z/D6VgLV1wT418v8F9E8prM6j/y/d3g9C1EE+6J3UpxRUGpXOyW2EKXBZ0NdRUxSmp2XW98ENcU1BFA7+aJpXBB8VQRA+8WL42MlF63Ujb5LhW9PfzT8mlLL/yDc1WIJZFmNUqA/5C60s7fxjtff6W5ctmYWnvLNinTnXdysFkCAjol8M3rEx1PkjexnA3ziIZq99ZAmWvD01EpstCS94WhPwlCYNwaHlccAOqGH6MGIFEsrtmrhkIbZ3wv41ve+nKHR6Gyb6K8UWDOyAMidXqUfp7fvHdAi254wtsEd6nJH9e59/MIPQW6aHPePZzj2KRmxHFaGYsVJcd36dHC+XzVt2HYjZp3UxIWHyyDtPbSQjK4DyjW2a86GEEBD5ILx7GLDSiQhBgyRDdgtNJ1/l/eOvHdZ53Nn04Vj4EQnptYcQGH3kH208zjK2YMrRR/M85N5Z3Zx7lZN9WtF+H/jxI9U1ejy8rbtQHeYzCjfh0Zhl82
 ZOuWbWEu
 S7QQuRsQ86ThhOlqfakmueBTgR6cDioxDWsqWKDR/B9dsdivOeryxJ6uHvsBR6kvjAYVcCHt04jY7FABJIE9dl7mINubRd9yMyvpLHGqf1Md+XFLMo8cufMzLMU7d4/lueYnauVZ163bGkBN/NZ0g4azMrTsAUNDa4hb/qnL9JHfxoY7wkiftBI68l0XgQSaE3mPU5fwjK30kdKUlWoxFSBMZIcO7oyA6QzqngzkjwOrh4OzEBf4jJziMHRZVf3FIdxU21wHcAlC75LC2gIhY+WB74iSddz22cluzKq4v2I0JzmYKz65T2AbIuFNbyNqshAT5flAs4lL+dQvzeBDF1dXhQ3crkJGznKa5xr4+6lmW4wzWK6I1ooGyn0y0+43vtEFEI0QnxPzbPCkkY2NOEIzcdqtkFG36MHyJnyc3YmyDem80+v+EZZVKTVoFonDDE97F629q8C32/V1fLi8qDnrCzTaO1Eau8+DnbcXJmfpTN0Q4I0l5gn/4QMVdflVqyb1G40zV5ocyC4i3KVucLjJS6uqCXQ2OFccAnY7Gceo7Ma+/ww8pteDR3V+sQDOT7T71
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Daniel,

On Thu, 18 Dec 2025 06:30:42 -0600,
Daniel Palmer wrote:
> 
> Hi Joshua,
> 
> On Thu, 18 Dec 2025 at 17:32, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> > moved the error handling (0-handling) of zone_batchsize from its
> > callers to inside the function. However, the commit left out the error
> > handling for the NOMMU case, leading to deadlocks on NOMMU systems.
> >
> > For NOMMU systems, return 1 instead of 0 for zone_batchsize, which restores
> > the previous deadlock-free behavior.
> 
> Tested this on my 68000 setup, filled the memory to cause an OOM and I
> got OOM instead of deadlock as expected.
> 
> Tested-by: Daniel Palmer <daniel@thingy.jp>
> 
> FWIW There was a BoF about NOMMU at LPC last week and I did mention to
> the people presenting that seem to be using NOMMU in real world
> applications that NOMMU was broken in mainline. I hoped they would
> have chimed in on this..

I tested with UML with nommu extension (currently out of kernel *1)
and reproduced the issue with a crafted program causing OOM.

without patch it indeed hangs up with losing console access and this
patch fixes with a proper failure message like below;

oom: page allocation failure: order:12, mode:0xcc0(GFP_KERNEL), nodemask=(null)
CPU: 0 UID: 0 PID: 32 Comm: oom Not tainted 6.18.0-12966-gc43a4f128407-dirty #223 NONE
Stack:
 60a8fb80 604a246e 603b9569 00000001
 ffffff00 604a246e 6002440d 604a1479
 60a8fbb0 6002bbb3 60556910 00000000
Call Trace:
 [<6002440d>] ? _printk+0x0/0x5b
 [<6002df89>] show_stack+0x11c/0x12b
 [<603b9569>] ? dump_stack_print_info+0x0/0x12f
 [<6002440d>] ? _printk+0x0/0x5b
 [<6002bbb3>] dump_stack_lvl+0x65/0x80
 [<6002bbec>] dump_stack+0x1e/0x20
 [<600e0c13>] warn_alloc+0x118/0x195
 [<60083ae0>] ? __mutex_trylock+0x16/0x1e
(snip)


Tested-by: Hajime Tazaki <thehajime@gmail.com>

*1 https://lore.kernel.org/all/cover.1762588860.git.thehajime@gmail.com/

-- Hajime

