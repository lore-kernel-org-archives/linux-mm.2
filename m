Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70A74CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EE138E0022; Wed, 15 Oct 2025 10:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EF78E0005; Wed, 15 Oct 2025 10:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88DF18E0022; Wed, 15 Oct 2025 10:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 757BB8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:51:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2ECD211873E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:51:48 +0000 (UTC)
X-FDA: 84000637896.22.9428235
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4E3252000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:51:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b7Jao4Zq;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760539906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NyLoltljIFIHQvuHJEe7loF3nTJT00G7D3T168aMfDU=;
	b=nEBPk+Zvq3AOmr4K7OXlDYhou1bt779lUtL2QCO5KBiYA5J1lcFdhQJ6lfrfbMfJZKPMVD
	6ZfKVKzLZGM8PRxmXIpKYQcyjLaVIlrE40wJWW1l68Rf48Dxs0pNL5eln2454YgoNNXxK/
	rVtMLagKQpvQTnrnUNoxqX1vE7Abfk0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b7Jao4Zq;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760539906; a=rsa-sha256;
	cv=none;
	b=jIk19Jd90vrtNLf76w2inmo23cf2VHmIiQXQBd1kEvPp4TjFZIdXNvleseK3jSNp+6Z88C
	HL5rCgR35Om/cs8bZVSchGQD/382XMMelxPQR9TNyuTP6wWVbOzvxAy68i6HcdNcP0oLdM
	u0m23P4s4HZ+N4dwijYZPPFDnaSWRis=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7815092cd05so23160787b3.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760539905; x=1761144705; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NyLoltljIFIHQvuHJEe7loF3nTJT00G7D3T168aMfDU=;
        b=b7Jao4Zqi1IlEBiwF62QqDKBFfBKquIX+4qCfNc01yQYdJ10+F9PeeMCqe1wcG/foz
         SfLGYdv547dQsp9/TBmcehWLZT7NlQMvwxL/Pd3u+JAVObXsgsxaHtWnJ0vBlwG/5jQ/
         YTxhx9etDsnm0E/MrgdolFokJHvJxW7neHVrdlpyFbt2QgC6mHff6p2GFYx5sInGjRUR
         uqOMWvDD2UymQA6wvaHu4PdkDlTcq+qbwQyn+2StSqu/PlGj4blNu67qC+eY7NoYZK9d
         1a+xj4jb5sCfzgDCvLqsikj35GMx+X5xK6ugSTt5Yyrx0ILZBiMgt3C+i81OmlhyVZTp
         FYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760539905; x=1761144705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NyLoltljIFIHQvuHJEe7loF3nTJT00G7D3T168aMfDU=;
        b=UgEfdCJdxc0+RS+/E8TQpP1RP+V0ruNCb8/YaqFrIMJYn6RKZ2lf/eNA/IR3yoEkxx
         FlXRv0RUfds+/vKnb2ev6RPG3c+FM3DZFysA6zE+SXXZzjkLyve+11VyVj9It3uO6Vgv
         xzFEESws6grX7RzLIb8a0+9K621Aj9PqNtEQIrE1QQVhCx87zyCEP7/AuBEQwiVkTBlQ
         6V+C8WwYgvbVjice1RaiUDu2AAMtfAkb2NxYYTv+d3muzEfxQdRazTTSGKOCdtB+kI+r
         8dmJ1bTBarOzbM5Kon3NdFrCbw5runCYOlFyyLN+eHJ/SJ0AL39+l8iDwhv7+dH6uiZX
         1Gtg==
X-Forwarded-Encrypted: i=1; AJvYcCV26sBY9rxJ4SIfeUk8AVs5FDuzwY9EZhjFRdIypX7+2iO048WkPVLLniCBDpZAZn74UDsl6e/2YA==@kvack.org
X-Gm-Message-State: AOJu0YxMhGP3V8AxOYOZ8nHKq+TydZbetj7lSgIX8S8HYnCB4zSZWIHW
	cn6IsDvKO5X6/HDThlzphSqoIlw/6G4RO+L3potLOVkV6wTk9yx4bPoO
X-Gm-Gg: ASbGncs1DUkMtzFO0GBgr08zJfJShhImiS1QElOjiESVskUnTNTzaekENwEHDHmVSFm
	hQASKYTWse2KveuJ29YJsPT18H46haBqaF+VPA9Vnjfho536fTc/MPP11TG84T/InLIPJ3E8t8r
	fP4+TwWgKdfQswP1BDcGuWICfVTsoJhJCsZ6YkrG1RqwinlwwoL+Zt+XUIwZA8m/lfUHEQM72vU
	uckGr+IYMyyFMTmVN7Uvdpqra1E339JP0V8xyFIZU/KroSfPhsxblHc18DLj4tfgia3AhpxVU4B
	jmXFvRHOynW7+E7GnONQ8j7IrHzQiqaMBd/wgvDD/komYmRIjg3X9HiH6ukVP1dlXJ8QucQVVEN
	JX3Up1iGynvUmYKPkGU/pcXHO7a7v9AuyI6TDAc5nPFgznxfqtGOEE20OBebzIE7/Bk5vddehe/
	Ky7W0VQhMi
X-Google-Smtp-Source: AGHT+IFdqdeTyqiUO3M8Jt3admfj16X+6I9SKPrlqNLZA1JhYvTo5CcWbZOMzfxfyhV/tM6hbT9L/A==
X-Received: by 2002:a05:690c:360b:b0:735:4c38:34 with SMTP id 00721157ae682-780e153baabmr270617987b3.27.1760539905211;
        Wed, 15 Oct 2025 07:51:45 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:40::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78106dbbac6sm42931667b3.3.2025.10.15.07.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 07:51:44 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: simplify and cleanup pcp locking
Date: Wed, 15 Oct 2025 07:51:42 -0700
Message-ID: <20251015145143.3001503-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015-b4-pcp-lock-cleanup-v1-1-878e0e7dcfb2@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4E3252000A
X-Stat-Signature: d7dztxyp3nm7qbi9399grtp35owcqogm
X-Rspam-User: 
X-HE-Tag: 1760539906-95841
X-HE-Meta: U2FsdGVkX18upe5ACqaAoAx0WLCueEwgkeSLFpehvmwcFeDfQYEEEyduEDP3nsRAd5L1auFBjqLEgzCI2oPbuIyao7EWBwdjqfEh02IU0oZDNDNEVh4jXbD6DOsSDBbqPe3gri9b8P30Bc8p3U52Mb2/a0Q1sj12/p1ZTkbpRYPqFlsnx2Du6UCzjtFFt6w9vnuk4Q8fJ4zbUS27qQIGzyhaFor2Btsojm1kQ7QrN/OYjd2VQpxt0MXe+q3V/kYSZOSBL79BF4GHT7WkE4VSRaOoCJmXP2r77Uy5bEEYd0iu8/sVLS8VVaiK9oWdAsWIv6Tz5hX4uRegEAn5qCCD9JTkdskDKcre97n8dU+16lyZRfAKNNc9fK5HTtAKHH4GziidvMA74c3OeAMa6JRjTT0bStKy3XR6HBVDr7AtRyoZYb8WxKlCseRUFRCQJknqFDRdjWbkHR9HmAnUcb1xR1zDEc2918ZzreYTEVc1kIkJ0+40LF5R6aRvRqFXAxgeuu2mg0JU+FhgO6Jta2njF3leQSccVxfjA1waDqbrmd80GSNXYiXzTLQc/ubHzhFCZ8TRusrA9DDE3+OqSJQGu5ojjmgicSy2we8XhSKWdBJSHgLGXmPeUrE9eNwHXXGyYM3pvt7L1mU4vOhpwojRdgOPmZUJJf7dVmiJjZwEf6u29HuqVCHHIuNHoQFu1n1qC3pFVK2efIjOc2s6jzyPzkTjcfxk7rhmLW6G2zpu8ja2yvpGRiW5BhX/p4GjAA4gnAlZPKXsG09zGhcoaM9J+KP2FTKHuzEoXysEoc7avBc4i22xZ8TBvwxZ2Q0fvTl4m2WfiUu5QIULeGuZL1xtD1ruGhBc0G+1yAnoA92lDro8yulrvSlud9WNVf6HhVVqSBtPdJNbARXX9UL6iXWbk8OeuFKojHSCTie8aBjnWcoePeDL67FLx+o2k3xuIT6hC6wEv6ZIoKhdmGc3HWL
 jmfN12EO
 J38NGizYkf9LjCRQnRb5pPRPS9pQMNfd/1Mgr4JcIZRLRvKro2KRkF5qc28QaTzwu7B5HxurWQw6gvoR4NlZE632vz3vc3A9IeMVy8akB80gP1ft2dVQJebEuzrjDMQOoPvZ4RQsj24+q11SvxsOH3inavepuem4jHozrT/XxOnbC34CYP7fnc6Hvrj3lO9Uug/y12vkDCsHruieMMcUNwuNnEu0xKcmIYKv1cxCPP+RYaYp/sLwmoTXc13C6m514mr+MnYX5p1kAkOWJPHIIKsfQJQ4kFIBiAVJyS948qe5n8M6J2QxtWy7FtWxGwOjm4+d8GGBJDDXyNBk4arBw47/QfUPc/Y1iwztN+7xzdgYeoLsLPB0O99RPd0jOI6kN/TSFhWYmvRUKO0v50TJD1sjmxXLK237cMETGznFi7+NbWgTH6wUYVWhOHXDuOTpsuRFioqtnLKZMSSO8FItp2HInIMnVkxKpW91PbobneGBNMOOllLIN/NY+ng9kbi/TN1uU0KKdKN/b6zsqAksbHUxwsVLjkfYss1RjaDKbmVB2Un0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Oct 2025 11:36:09 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> The pcp locking relies on pcp_spin_trylock() which has to be used
> together with pcp_trylock_prepare()/pcp_trylock_finish() to work
> properly on !SMP !RT configs. This is tedious and error-prone.
> 
> We can remove pcp_spin_lock() and underlying pcpu_spin_lock() because we
> don't use it. Afterwards pcpu_spin_unlock() is only used together with
> pcp_spin_trylock(). Therefore we can add the UP_flags parameter to them
> and handle pcp_trylock_prepare()/finish() within them.
> 
> Additionally for the configs where pcp_trylock_prepare() is a no-op (SMP
> || RT) make it pass &UP_flags to a no-op inline function. This ensures
> typechecking and makes the local variable "used" so we can remove the
> __maybe_unused attributes.
> 
> In my compile testing, bloat-o-meter reported no change on SMP config,
> so the compiler is capable of optimizing away the no-ops same as before,
> and we have simplified the code using pcp_spin_trylock().
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Hello Vlastimil, I hope you are doing well!

Thank you for this patch. This is a pattern that I found quite cumbersome,
so this patch really makes the code so much easier to understand and read.

> ---
> based on mm-new
> ---
>  mm/page_alloc.c | 99 +++++++++++++++++++++++----------------------------------
>  1 file changed, 40 insertions(+), 59 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0155a66d7367..2bf707f92d83 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -99,9 +99,12 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
>  /*
>   * On SMP, spin_trylock is sufficient protection.
>   * On PREEMPT_RT, spin_trylock is equivalent on both SMP and UP.
> + * Pass flags to a no-op inline function to typecheck and silence the unused
> + * variable warning.
>   */
> -#define pcp_trylock_prepare(flags)	do { } while (0)
> -#define pcp_trylock_finish(flag)	do { } while (0)
> +static inline void __pcp_trylock_prepare(unsigned long *flags) { }
> +#define pcp_trylock_prepare(flags) __pcp_trylock_prepare(&(flags))
> +#define pcp_trylock_finish(flags)	do { } while (0)
>  #else

I have one question here. I was a bit unsure why we do the typechecking and
silencing for the unused variable warning for only pcp_trylock_prepare, but
not for pcp_trylock_finish. Is it because pcp_trylock_finish will always
be called after pcp_trylock_prepare, so the flag will have been used at
that point? 

I was concerned that there would have been some area where only
pcp_trylock_finish would have been used, but compiling with W=1 seems to show
no errors on my end : -) So it looks good to me! Feel free to add:

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thank you! I hope you have a great day!
Joshua

