Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9CCEA853A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 17:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C73F6B0005; Sun,  8 Mar 2026 13:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075266B0089; Sun,  8 Mar 2026 13:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98EC6B008A; Sun,  8 Mar 2026 13:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D73BD6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 13:35:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F4A11B90F3
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 17:35:44 +0000 (UTC)
X-FDA: 84523598208.09.6A30AB2
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 787F5C0007
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 17:35:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=awWBLClA;
	spf=pass (imf22.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772991342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GC8HMKQ4ZWxWCtuNOfqYbNHW4R2NaicK2jQPUUta23k=;
	b=SsiYB73HEIDKidl2afQH6YrGsM2B2K4sHI+cFROzL/rHn2xR04RMN9NV0t73srjdI3r3vg
	9hNcuDc7lagvgQenwDLTBHuo+2+SzpcYq6+8zHd7UZH+o08ryZE9+ZQxxD+eYcXlTowafm
	2EghNoTyoqGEaTpmr+3cWOPY3SdaH58=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772991342; a=rsa-sha256;
	cv=none;
	b=4G4do6QP6T9G1bKoqKbNFdUwvbao+vJTq+FrA1js8WIzlvGArZKmzbZzJ2omZOnV7wjfQk
	33h8aXN8KfDu8TbeDZwNccY4DKKmmhgwv58brNfdooFTZnH40jMyoh1Jxf6CqjFdMBbzGD
	xrJunEsTNd8V+1kI1T3PAX3QEvuWqvU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=awWBLClA;
	spf=pass (imf22.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48374014a77so129814115e9.3
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 10:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772991341; x=1773596141; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GC8HMKQ4ZWxWCtuNOfqYbNHW4R2NaicK2jQPUUta23k=;
        b=awWBLClADkGl70HC+Bt/cciuiQbu2ysCBrKKJCFAKEn+Yr3MOhuSiS65WVKHPbB4S5
         roTzBNtmgNg3FgYzFW81JI/stXMdt8NFitPn/4bDN98UfbGczBwGYVJbM/W6o8fXswbX
         DMX6KjEpwSebuE2a0T71dnO+wRcfPc9r+dkLCC8Pkg4jb53vNJ1bz2cBUiGI6LTBBA9B
         Pw25qr2Tprw2PTocJFXhL6tNsx9vJPeKtCr6ZkxKQb78LZmFUANob2FHXfD354qaAIbX
         UOGRI470CyNS+o6n086h+O2+5QojLlL1wh9d3b55Zj0UBfi/pvEOEQoxumyptEqrlvrA
         PT2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772991341; x=1773596141;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GC8HMKQ4ZWxWCtuNOfqYbNHW4R2NaicK2jQPUUta23k=;
        b=FgVr1bk6w+SuU3qpqKQHGgxyHt+4zqM7XJjhg7y7noCnddNBibrH7YBW+C+lCm9GVq
         yn8t6kx88Cz2MttCxlKZW6jeizGsQ/NMUhvxyQBF72LtSFhKFtQ9xnEHB3T7lA+YjCpt
         KtXHSthKmPHtcx82EzbsRpMNPydkYN7Kdc8Z7KtjbNtRxRlq49LvM6Vd24zCwi5783zT
         bIyjWkT3RwMs7jPA7XvVFZKunaAf7RR5Wq6W2e9IOpqbDtsZ5dyno27uobhr5GCRkt+u
         fG5453xOWfMihDrdPNwI9U5g++n043Am0y9KGR1Q9jWRx9na1HEuSQDt7EKD73/Nh7wo
         On9A==
X-Forwarded-Encrypted: i=1; AJvYcCVNRwKkwrjpxzWN1/1mek+Kv5kRAIUAGN5yF/AC8WOJc0Mc+I7k9iNd5ocqm6nm5mXo3jcJhjvEIw==@kvack.org
X-Gm-Message-State: AOJu0Yz1VJHc7ctqX2qA3Bgt5tO4pNw1TdkqzokAsmlNK9gD5bFtYrO8
	Z68yo/Grg1+/u1zXTBTANaC7JWTegLzpmk+rUMch1QwjtjSSVOLqeGR5
X-Gm-Gg: ATEYQzyl3IzjpwU73Mh35LZaoc0jCYQMeyJ5kZknXmZ2NEnF0At57mQ/5cfSN8iMzqx
	IeIdTd2uuwa3hHI/jXtFtHXn8EjLp/neWDWUxWLsskJl0+n9XFJB8lFDdC7vTZm6JB2kz0Fq9Lz
	tJWzbUp0LJaLVDVjKski96grSTuGXe+5peZA2Vpu9lhTHGV4UHxl3H7ibVNrceqRpz/YxDEEp3m
	ilo92ljxlLUHIYW9pT3Mj7iu4qfXih7GJ34BA+Ll0Z+5Qq0owgKPedAEmwfact/6CCeO2ptzhfM
	/27sjj4m7guFQn4gYqMve0QTxmXxvmrRbatLyaSRnETvgVK3d2d1twRH7Brw2OHNmehiHkbPh3n
	j7+s2SwcnQ0c8XP7N7TwCbEY6622H0c5gMtL+JP5zPr40xAe0E38lBWC+ofyAg/MU1XyGVOzD6k
	0A9lfkxJ/O/SD2Qk8ShLJKB4ni4GVIWhofs9s=
X-Received: by 2002:a05:600c:a12:b0:482:eec4:758 with SMTP id 5b1f17b1804b1-48526967a7emr143636505e9.26.1772991340683;
        Sun, 08 Mar 2026 10:35:40 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4853a310b8fsm37581865e9.11.2026.03.08.10.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 10:35:39 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 3/4] swap: apply new queue_percpu_work_on() interface
Date: Sun,  8 Mar 2026 14:35:30 -0300
Message-ID: <aa2zYkzFeexyObwj@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aaBrfg0ozWK4moxC@tpad>
References: <20260206143430.021026873@redhat.com> <20260206143741.589656953@redhat.com> <aYaQFM9sBbauUn5c@WindFlash> <aaBrfg0ozWK4moxC@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 787F5C0007
X-Stat-Signature: 1atp8fgbmmimhnd5nfduqzympdx8ewyo
X-HE-Tag: 1772991342-207838
X-HE-Meta: U2FsdGVkX188Y/QTEyLTcsDSI6reb5obLEF0B+hfx4WiuBdAx9shz5DADBtAPAKZeCUEJAZAhQPUyuKW6icjD5SgxHnh2Yd7xWODTVq3uKgxyumOt+fyk2VYWfwelQQiU4lxYWaMPYIFD4RLMQr4f62gyjZDZcpJtN9FLVnzcmH77ym2KPcfgc6z1UxVmAUS9Y8obGbiLh5YAVCvKfcvO5+fOuXTkSIlW4f0N24+fXt2HYO1V6eSWR3n3fMmUXD8QYU0LU9mDlGK+natlanPwWKQVQYmiSArXymZvh3XIRnNeVOviQZ0OEg0jOP4clatKsh/qVVBlnqWe/wBK39PZsOvfRXzybKeSQhhh+J76KQ+b222gwnOb2GV50G34WWDdfDKJdrKvL3ro7NmKZ12ArthDHg2WBqRgPgzLRbHg69IxLfYjgqtpfhRjKi2vTPLEjfYo7SdhaO9BjU42t9SMvMUwuZ1X2rVTyab0v1di9+b7d7YouA4hCVZ7P7Ku+FldAnF1j3xcwHB7s5Cw36rMnY2WIAHv/zeIaUj7QYDe7bC8c2zyZ7M/TVMmVsLJ8Ml7EMQmgib3jr7Of3v0MoVziq/T64/ujZG5yncOdOXtVTKTtRhCt2LbnT4wtYz4k1AUPXrtEb5TGN5tR5WJZQwEe0TxEKhmxDvLnvKk3EKqrlCQ/eojRXdVrPXbOpiKo+ppCubDtBj3k75na6dmZwsJRGdVgBdTR9UchbnsfWBLxi72iikhNZQlzbf4yqZ3Mh2NMvgQ1VbqyUeHZFv7IwQriAc7Xs5lseGbSZKTUjiMYaLCzLoLKS+Pm7spDYPD6SM3/awBYaOnO7+4+XcxAcywb8Qx84uicrMjrcVnXKdPvQWK+XOsjkYONhDEIAJKuxaje1pFKtH6G984OqXfhkYBSTdcL3dY98Blri32Mf/P9mHhF6P30XDW9V4LEsRzlUvRwwJ8DCJNFVnfK5RwMU
 D/3aJTJK
 AYr30sMajIoAVp1/MXwwyvG1n7fuNNjuLpXitG3FmwO0W7I/zoiJT/NuptnDU3REexnMhL4DH6mVYP8mOkVzEU0x7nfMx66TUuo8SH6TgMILEtHWOlEGJdhCQjX5cqKLHNUaGULNy0TStAy6iAQMm/RU/L8n+9uUCMMOGnXdxsuhDtG0ngGgq4bxDd1oyUQfE2PoQkV79UR1sxMKqBGXW+eNpSIvUwspnSXWQ4JxGfGHhlPLTakhRbGzxXTEStsX972T3cMm713p9OKq50Rr0LyF30Ix9n4gf+ZpXRJwxCdUCARw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 12:49:18PM -0300, Marcelo Tosatti wrote:
> On Fri, Feb 06, 2026 at 10:06:28PM -0300, Leonardo Bras wrote:
> > > +	cpu = smp_processor_id();
> > 
> > Wondering if for these cases it would make sense to have something like:
> > 
> > qpw_get_local_cpu() and 
> > qpw_put_local_cpu() 
> > 
> > so we could encapsulate these migrate_{en,dis}able()
> > and the smp_processor_id().
> > 
> > Or even,
> > 
> > int qpw_local_lock() {
> > 	migrate_disable();
> > 	cpu = smp_processor_id();
> > 	qpw_lock(..., cpu);
> > 
> > 	return cpu;
> > }
> > 
> > and
> > 
> > qpw_local_unlock(cpu){
> > 	qpw_unlock(...,cpu);
> > 	migrate_enable();
> > } 
> > 
> > so it's more direct to convert the local-only cases.
> > 
> > What do you think?
> 
> Switched to local_qpw_lock variants.
> 
> > >  {
> > > -	local_lock(&cpu_fbatches.lock);
> > > -	lru_add_drain_cpu(smp_processor_id());
> > 
> > and here ?
> 
> Fixed lack of migrate_disable/migrate_enable, thanks!
> 
> > > @@ -950,7 +954,7 @@ void lru_cache_disable(void)
> > >  #ifdef CONFIG_SMP
> > >  	__lru_add_drain_all(true);
> > >  #else
> > > -	lru_add_mm_drain();
> > 
> > and here, I wonder
> 
> This is !CONFIG_SMP, so smp_processor_id is always 0.
> 
> > >  	drain_pages(cpu);
> > >  
> > >  	/*
> > > 
> > > 
> > 
> > TBH, I am still trying to understand if we need the migrate_{en,dis}able():
> > - There is a data dependency beween cpu being filled and being used.
> > - If we get the cpu, and then migrate to a different cpu, the operation 
> >   will still be executed with the data from that starting cpu 
> 
> Yes, but on a remote CPU. What prevents the original CPU from accessing 
> its per-CPU local data, therefore racing with the code executing on the
> remote CPU.


Yes, but really rarely, and contention even more rare.
It also should not break anything, as locking will make sure access to that 
per-cpu value is being serialized.

I was wondering on the extra cost of migrate_* on the hot path being an 
undesired effect for other code evaluating switching to QPW. But maybe it's 
not that bad, and we get rid of that very rare contention.

Thanks!
Leo

> 
> > - But maybe the compiler tries to optize this because the processor number 
> >   can be on a register and of easy access, which would break this.
> > 
> > Maybe a READ_ONCE() on smp_processor_id() should suffice?
> > 
> > Other than that, all the conversions done look correct.
> > 
> > That being said, I understand very little about mm code, so let's hope we 
> > get proper feedback from those who do :) 
> > 
> > Thanks!
> > Leo
> > 
> > 
> 

