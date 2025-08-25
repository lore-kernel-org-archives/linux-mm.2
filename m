Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9D3CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 09:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB238E0007; Mon, 25 Aug 2025 05:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7BA88E0001; Mon, 25 Aug 2025 05:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B43498E0007; Mon, 25 Aug 2025 05:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0BD8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:01:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 123C7B7426
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:01:05 +0000 (UTC)
X-FDA: 83814685290.01.9ADFD89
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0CBA71C000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:01:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i1eAY+gY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756112463; a=rsa-sha256;
	cv=none;
	b=NOYJbk41kvJa1sRAuT9TiVkJwfNNPTx43mxg3dgvuTeqiaH/OkC11WAoMxccjMfiU+EegH
	HLVL4l+jYajEiMmc/sxaD4XWk+VyQb3hczT8K8504wsbuCPsiaI4USZwPaVqpfxGqvSbhA
	Hf9mXtARBGQRt+VfIfSrJrk9PDHXSHA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i1eAY+gY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756112463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GLLuuF0nylz+PH2kjluwwHpcMAE0V4MLeUIY2arLuI=;
	b=r5STnQubKQ+pEbn7LxIwndzI5XoY9Qb/NJBnwlRxK3UqE81bTLen1Eevfk3YzjRYkuSqzt
	HtDyDcqbTpcwhqFD7gftv25RH/kFhKPVJJ8ekwS0XBUYU2e2gGsdensXf0bOTcJAe5B3oh
	dSLOd3HCBvf5AuJPBTu8lzUQIH2XtbE=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f42dcbf4aso1004854e87.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756112461; x=1756717261; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6GLLuuF0nylz+PH2kjluwwHpcMAE0V4MLeUIY2arLuI=;
        b=i1eAY+gYsooyJfXaKce96NTEk63a+T+JfzLvfFVSeTyg+4+42hIWncVCURahWwt1Ye
         hsj5V6fHe/uvgKw4atMBM8QgkDSUW96qyI12iIgmDGIyw4vWJOs9+ZvlfX7Gxk2GN+cn
         ljpNtDJpGMe7/5aKp9U9dpNo66rG/4mM2SuZ9nl8bQvuyr14elHV1CDUkWYNsIL0zgJh
         WHyVr3ENJHY5LqS9DD86V3WE+bXqgPYz0O6JJWHUYQbrOrZnEsG2DVWXU+t7YMKuPtxK
         i8wTW8li7sZW3MHjYVPWXATivVg8KkA1WwJRMoS78dCxZwLQl7tTBTIwQ9NQYPRwH3uS
         JKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756112461; x=1756717261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GLLuuF0nylz+PH2kjluwwHpcMAE0V4MLeUIY2arLuI=;
        b=IZ78RmHMdtPgeG47eI42zzKK2kg3b+qagpt3aIjPP2iYu42auA/cDWhFlWp6Xc+2HW
         8paYb+P/QtUDZs5G5sWyX/Dencu6jt7GQeJbnO/btCQTlMxvhSV2PUHF2V6Ne8NUq8KD
         SUuGbBnc7QCNdcPcJdL9PhnkMZ1SgH/Tbo25ZZQOx0rf9ymxaiPMBFC99KNYQsiv7SLt
         PXwwxNi9oX7/AsiedT9UFx5U4UtFqIidFpN5Ss14d5hBtQRYV66jQLnyvg8ZzyMDEToj
         e1R0Y74tDtU+C9HOsGHbPOAGIoqzLpxHKgYKY/BdNVMgojHJilkuhY+XeB+89KOHTOey
         UvEA==
X-Forwarded-Encrypted: i=1; AJvYcCWoJAYxMNRaA4iKqb8Dfw1h0Ee9EEHl/92HDtV2h2EMpTXQ2CDY4uxk5Q/TIl5m63PmUHoGz3bEaA==@kvack.org
X-Gm-Message-State: AOJu0YzJXeKSNup9LhaaoNonwPn8Ygfz/9DH8Vvg2f0Oe2Wl97pGzsWO
	BgzYgZXQhSDdryom1coEtyGf9DAC3u/LxKnH7cUzYzxDxYaZJAizWPNT
X-Gm-Gg: ASbGncujK9T+S6rnHnNWRi9OdXaq4d/Bcsa748uA0e/7r4MceoVio+/EFeAfKj3PUWR
	1+iMy/eBQV3qBHWL9Yk1dN/disx+EBjLXgaDR5o/blTReTHCrOaStuC6eAgY57c6G7HRrEyQ/1Q
	pjtGkVgCGO8hc14hExucsBKNpWXsFt5CMkFiPUCwPzb5eBiB4vsvyKul4AGxeqsVNXW8hWOA/Jc
	rv13f8W29E7VaHTyT18zFmi558YGcvXZDVn15bh3hznONdLImj5RILrRsZs/DC2DUPrYxssuPVg
	G0nmzHhIkAsMRMNyDsNczP0ZKzMnnWdAZRSrI/YomCIYQcp5BAdYk/KoxXCGJFoNHLAwoq0u9N7
	oCKXjSyCCQWJ3my91S0m4FQXdXrzFfZLkIcDvMfQIgYqqB501bBja5L0ActPlSJUPAL+I
X-Google-Smtp-Source: AGHT+IGaTLQFGBcntCUybb60rpe5ac2c5Xb3UX7huo1J8YjrOMQOtwlzEVc6oELd8pXpCy3iqNWQoA==
X-Received: by 2002:a05:6512:440e:b0:55f:4361:890e with SMTP id 2adb3069b0e04-55f43619020mr1097338e87.15.1756112460558;
        Mon, 25 Aug 2025 02:01:00 -0700 (PDT)
Received: from pc636 (host-95-203-1-122.mobileonline.telia.com. [95.203.1.122])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f4335139bsm740757e87.111.2025.08.25.02.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 02:00:59 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 25 Aug 2025 11:00:56 +0200
To: Brendan Jackman <jackmanb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, peterz@infradead.org,
	bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com,
	tglx@linutronix.de, akpm@linux-foundation.org, david@redhat.com,
	derkling@google.com, junaids@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz,
	x86@kernel.org, yosry.ahmed@linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Andy Lutomirski <luto@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
Message-ID: <aKwmSIOEZnG44aF2@pc636>
References: <20250812173109.295750-1-jackmanb@google.com>
 <cdccc1a6-c348-4cae-ab70-92c5bd3bd9fd@lucifer.local>
 <DC83J9RSZZ0E.3VKGEVIDMSA2R@google.com>
 <aKihQv8fWzZIgnAW@pc636>
 <DC94NN6SM15D.3DQVRLO2E282W@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC94NN6SM15D.3DQVRLO2E282W@google.com>
X-Rspamd-Queue-Id: 0CBA71C000B
X-Stat-Signature: ttwff4r7sc6rg9un7qyttbe36dyz3br5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756112462-909456
X-HE-Meta: U2FsdGVkX18kuYjcAr1ee+TrSRxO95nHQCpG/NT6q+G6abaJvlqGE/GpY/J96WEWim/G0RJ1uRsR/025tiVXiQ4oRwZNkuBmqlWv4nnPdWH/pHS0KLzTTCfJbMNXFCsO1bJTSYH+WqhQBnrJKJ0YBgzcwy22DsmT/PHi10mb85vUVtDEvK+rQmvifqo60XOJHK0CXaAeWKP2xH77Byzmtv9gBY2/gv57uGctKf9WLl97phfCz7hhftbZev9PSOMRox6ISd4mxKSKKAiMLL214Ga9BrIqSEWDy/THlbBZC1738Lt7dNtNbwFuUMiodGr16SLrDB9Co9HChftbdqUquV3LbokSgnFaI9WmeVKKwRpI+X5KRKq/jLYqfM/nqorQh+3rwtcRuGDwvTE61oufDfFRxIj1mgUd8k2AjnU1aDao5+y4z4GdB5PUbxXm1Y8PCAVaSfI0XHgXBRPjAglMby314u8wFT1tvQ+zbjXd3iFPhsSWjvfiLoNn8aJPhPPbIcW95N771gsYswR7aJs1bG9gdKL3AkOILwaUF9KrMwRJSVNsx44WF7Kbz4yfbI9VO2BmKaRS+PMlXjscjcnAJKFkDAtJmn1Uj12OMd4hQiUBcgRQKkYwSsG+4DJPP7zw+9LFQLJ/qolFL3x2iLen2/YVjr7ixs7rAqPdZvn7mztPVz7ECgzSUHemsqzRJGSmuklUKXs3XWHtFoluhXJ9ToiFCG0u8bGbZIVzkS22RPBt2Zeo6o406bWjoP3al4+2i+gHtk8mhBBXBNUxY3u4JjxSJNrJB7XBjbchB51AN/2wJCiAZ2I6cZkSmeorgBQtDLDuYITuVhUq/UNCnhiNqxEfDxTrskbih2hzaRT87P3P31QfT/oBqvkNkWYGX22vE95s0hPFkOKc/b580z/DHBgs7Z2dtPvLoQXZ5MkTnECZTt51hyzNOJnGcSNQuXKUutzYjY/CfpZHiqihqYl
 nJme5EIK
 HvNB1NaZEiB7wNctUB6YE+lTc83sZcSgUlGn8iJKTiLvgF8LjCAgcHo2kadefAWnYsmNs2yL/XRs3SsDDhsIUCYXnyEK2aqy/0uVFxwZxdi1bxwS03h42fKfZSOW8jk8vOLntEJEDNEW9KPD74NI80pxn/d88Btozlzx0LIg+Zrirt45x0rdHp5xAASfcGfVgooTEyet3WplNqX4UBKlw9Wovbye0RhWBfuR81dNFvUhqwpFipHfLyMd8AsI5wfW8DzUfO5HSat5F9YjBl5Ghf5awNbhv5EB6du1L+TJON/ndG/RSXwn8uSLOP6L7Yr3FDfvh6jEz2mvNwUQOgdssUDBbkxYeAcmM/lwaZBxV9VifSWjUmR2NdFeFPNx6bojr1Bet09GDOdtwQSNlbchTbOMuDYE6u1f2IJUjgnCXlT18bFcaO3N2HTAWFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 05:20:28PM +0000, Brendan Jackman wrote:
> On Fri Aug 22, 2025 at 4:56 PM UTC, Uladzislau Rezki wrote:
> >> >> 2. The ephmap implementation is extremely stupid. It only works for the simple
> >> >>    shmem usecase. I don't think this is really important though, whatever we end
> >> >>    up with needs to be very simple, and it's not even clear that we actually
> >> >>    want a whole new subsystem anyway. (e.g. maybe it's better to just adapt
> >> >>    kmap_local_page() itself).
> >> >
> >> > Right just testing stuff out, fair enough. Obviously not an upstremable thing
> >> > but sort of test case right?
> >> 
> >> Yeah exactly. 
> >> 
> >> Maybe worth adding here that I explored just using vmalloc's allocator
> >> for this. My experience was that despite looking quite nicely optimised
> >> re avoiding synchronisation, just the simple fact of traversing its data
> >> structures is too slow for this usecase (at least, it did poorly on my
> >> super-sensitive FIO benchmark setup).
> >> 
> > Could you please elaborate here? Which test case and what is a problem
> > for it?
> 
> What I'm trying to do here is allocate some virtual space, map some
> memory into it, read it through that mapping, then tear it down again.
> The test case was an FIO benchmark reading 4k blocks from tmpfs, which I
> think is a pretty tight loop. Maybe this is the kinda thing where the
> syscall overhead is pretty significant, so that it's an unrealistic
> workload, I'm not too sure. But it was a nice way to get a maximal
> measure of the ASI perf hit on filesystem access.
> 
> I didn't make careful notes but I vaguely remember I was seeing
> something like 10% hits to this workload that I attributed to the
> vmalloc calls based on profiling with perf.
> 
If you could post a perf profiling data for your workload that would
be more helpful. At least i could figure where the cycles are consumed
the most in vmalloc path.

Thanks!

--
Uladzislau Rezki

