Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23AE9CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D8A6B0012; Tue,  9 Sep 2025 10:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD1B6B0022; Tue,  9 Sep 2025 10:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ACF76B0023; Tue,  9 Sep 2025 10:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 488506B0012
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:03:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E93A41A0569
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:03:03 +0000 (UTC)
X-FDA: 83869878246.19.AC41E0B
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id D1C761A000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:03:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NqvVOccZ;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757426582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BUW5/LW9jOJBAxRiEK/kGmWkiKeTyE9r4ygtNRhhTU=;
	b=E8r7/8Fwu8hdXEtAi1ZqClh8maCucbrBJ0GoNUfbp2kOpf5fnkIKdaxrUJeX2iBc42vufH
	iXqj0/aGoQb7mcUUfGEUu029xnTMll/CXCtj1WbFNJDfYIwBt6aBoX9jA0KXBiaLtso6mx
	zfB3SldLotddYCcZ3XiCJeQ/SrESPVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757426582; a=rsa-sha256;
	cv=none;
	b=V7vcBLF1ii5/GlGf1dLiYaVUo7YLL4sfj4QT79VLo8S6iuhUafOPRO0KFnnZE6hkhm7LZ4
	bftG9I8kvGUuastwaESNzBvfTJ6iTq3SX6Sw85/QltWEZLxbt3DBqY95R0FpyS8NeeY53k
	yhtw5GVHWffFiuVPjv5VAaeb7UZ1ADw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NqvVOccZ;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b0428b537e5so904692066b.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 07:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757426580; x=1758031380; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2BUW5/LW9jOJBAxRiEK/kGmWkiKeTyE9r4ygtNRhhTU=;
        b=NqvVOccZ3ZZqaOsnFbbgcweOFzANZ95ZciZXw89s28SCZDgbRkZC3PnxmAewJ0KeCz
         8RQOxq1uNtk4YxM3synQzVCDPbZhhdBMmL2M5S/dKwGeA9P/xg3p4mklMOEIq5YgetMp
         LxQ5C/9IAo9vYWBJzu930AGf+X9wdXVWlqefm9PaIKQiE0oVlkgTcRh7SuZ4aa4qhGza
         9BElk9SY4EwbdJa/EPO6DSMOU7vzIn7m3NiQxJxVM+xXNes0bsEIGzi5Pf6PgkyA0rKg
         sMvHo6KEPxtacDALWFT96ldfE4xAjxxQ4iAn4v3albuBJPd/8rM8yH1OhVvRdq27wDdz
         i/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757426580; x=1758031380;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BUW5/LW9jOJBAxRiEK/kGmWkiKeTyE9r4ygtNRhhTU=;
        b=iOT943oZkWkSn6ykBc7dULoThu/BTmM+Ibtzu3rQ4FWhoT+a+XIrvW6tva9uvWw1bM
         bOk+/9taef3prTR9EbjNHrCEV8YRaPspf7r1EnuYAVupqbXgZnBMhDS3pNhuHaMtqUbq
         3HiTRY+/67AgqU6p31CZ3CIKOsZgehWmYDHJi+BQoy2rUu54t5tbBLhwOHPDLQ0PGuDV
         ED7SLCtxvSEzJqG02VMP/fcq6kQx1g8ukBnHcypZoElEU0gvSkazAHYqw9R5GHu+e0nN
         MjXn7+i0El5bU6QSMbIHj6DkS4wgiR2eStTfrDQjE/SpvzVy3DX8dGwIAmoXTYgvCL5z
         vwhg==
X-Forwarded-Encrypted: i=1; AJvYcCX0XQGNSIUF3/2gSa7n74XgQh1pTPmPd/GtyyksccXrlafkqOKTRnCsXIuF8K2T3ce698TDtN9BPA==@kvack.org
X-Gm-Message-State: AOJu0YzyJqLstDAQN0RzqLScAfWI3m4WHJlV5C2EcZT10vuMt59Ve883
	DahnkTIVjMwtGBG/n8RuieFa2DF/VNTe4cvWKFWvwH1NKSAbK6CqGObmo8/B/q4rnLg=
X-Gm-Gg: ASbGncuFb3Pu6f82yvu83+TvrBOjD9beRP3b56yPYSeMtrUjpGc2tCW9jkjztp6Z1dn
	aczgvPctXQSvCV5kULTw4fo2PJ7FWvjI5XwiRUstqLO8snrqZlUsaUV1U4FrJjLYrB19jQ5PCCX
	QBG9LFiXk+5E2BaHLWI9IkEHc4PZmoYMK7MLhenzaIgUcaEH0n5eI/+0OlqWv+3ilDCWjNbQM4c
	5tZzfl+0LzbkkCHiLWMMQ+0wcDV/Qzw7rvGd21QxnOduiU7SPGearRYx00k3BJojl2foIEmeJWl
	hW1TUqTP1xrNj6CP/v+4QXNPBHDvIqN1mELOX28PQeh9PgZFFPMhlboboD116AQ2qnQ2cbwqr5G
	Pjpat6U0Dd3fok2hl2Iz3mC/TSJWF22dkPA==
X-Google-Smtp-Source: AGHT+IEcXOauWERSVTDc/oyeBPYo40tn1vR1+fr4Fma7wkicQf7mx/quHveASuxtVY4qRP9qxAuU+Q==
X-Received: by 2002:a17:906:6a04:b0:b04:5bc2:3246 with SMTP id a640c23a62f3a-b04b140cc26mr1306728766b.14.1757426579751;
        Tue, 09 Sep 2025 07:02:59 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aff0a591819sm2633577366b.41.2025.09.09.07.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 07:02:59 -0700 (PDT)
Date: Tue, 9 Sep 2025 16:02:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, feng.han@honor.com, lenb@kernel.org,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org, liulu.liu@honor.com,
	lorenzo.stoakes@oracle.com, pavel@kernel.org, rafael@kernel.org,
	rientjes@google.com, shakeel.butt@linux.dev, surenb@google.com,
	tglx@linutronix.de
Subject: Re: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for
 thawing OOM victims
Message-ID: <aMAzkQQ4XAFh9xlm@tiehlicka>
References: <aMAWvwQ3eJZH55mp@tiehlicka>
 <20250909135152.20477-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909135152.20477-1-zhongjinji@honor.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D1C761A000E
X-Stat-Signature: cyo1tjpkpb16hgx7zzgx4iewsn4e576g
X-Rspam-User: 
X-HE-Tag: 1757426581-297461
X-HE-Meta: U2FsdGVkX1+Zv1r/KzMGyFb9NnimmKSGMCc47YbIj7sxR6hqHjLxnhEp8EB8PsoC4bES328pnkU5Yn7AExNQn/rykdMhh1tyFeeq9rnYQiRIjpEYnLVEDINc3onDhMMaVICclRwu3ceTmwyCBEzlvBDQdRfkmEm6Dd3Z+NdWkkCXtWDOzLWTi8SATwqlACm1dxP9VH67zqIgvJ8Ui2sWRRpl8K2MM4UZULLeAXsM9p8CT67ee7+767JDe8ZTZONlWTZb8O4rV093+Au1Ns8tWNclBcTZjVRhfjJ5RFb2MM7fCQzQE5IxBOgyaOfnKZxtikOpo3uhBVqBtaZF1KyPB6saEhwgi2cNbKWJjL80d/NBGuVJ9ua3qWSm/JoYpbumvzpO3aLnCAqCcqB2l7mfbvdbNznFzJpvns85sKqWPGinNA9Adlp/VYSbKtv/DdaHPSGutz+ogLI9wr/Dacg1X0Zuw3FOasWGEZqCjAgSjSt8AdnoyVIkPzhv0eL4p11KQyeWIpzMOzG7tt7bFueimtNROljkYp4U6hvwFD5yNX2MSEE5hze8C9hvXq++BQ4tVRwLNesRhpFjriEKtKztNDg6oS07LBvHxtGlMtwZubUNO5mrbukm3vFjIP3Jpa06XfPNQKowVPYI2eidnfZoIH0mFaiKKJWLSV2o/RXgLNjCGH+ZATxw8kKQvQ30Xu90PpUHF933/ByTa1c45afG8hvoUQm1/RA/QRvOkX6saS9l7v+p6jnTJddG2XxKSgOI3Bm6KX3XVe8tywkNzWje+h0kE00bswGDEPC9THCjXB54ZqLhhJW5nhGVcAohnomvTqAl+jmIGFz4yUycrdqkD6CbUcdn2jHhixG47gKZ4mkUcnA3kDYnFDYdaha5KsZ9mfb48pdiQsY6haFmwurr50bXBgaocTEbLtQDW02cuaBCoTKJwqOhonFAeibLgXwsfXpTGvM1nbBvUHkcukg
 8AQfZCCe
 B6M31QqkDBKWNw5ghJc/SvyeK4qa8cT5E4DnV8i8vid8EHxPlBs7Xi9LHtD3zks+G28ce3mEws7QNnipH0qQ7+QUtzWK/OMlpVxmJOUJnf+JDMwET3j1JLJdzcp/DwUaabQ2L78uBDk+Is5tkriXJQoO2+fiSYwp7AYg+Y9mA2hHyKO0hiPa8dtMD68oWkdXyYEvtHHGaWJUpHmX1Y6PNpB51Wp776OzicE/JltlbZxdYomDRP2jUoy9X9omKgx8f21EueeKQiXBIz4OTmxCDmUyu/BJMXt1b7Rx+4C3HFA5KpCCJJeUBQ3/dpQ6WrXAyE4vPMJe8V4IHM5GamiivcXXvNRWdQmtv13Y4SvP/3BhDNIA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 09-09-25 21:51:52, zhongjinji wrote:
> > On Tue 09-09-25 19:41:31, zhongjinji wrote:
> > > > On Tue 09-09-25 17:06:57, zhongjinji wrote:
> > > > > OOM killer is a mechanism that selects and kills processes when the system
> > > > > runs out of memory to reclaim resources and keep the system stable.
> > > > > However, the oom victim cannot terminate on its own when it is frozen,
> > > > > because __thaw_task() only thaws one thread of the victim, while
> > > > > the other threads remain in the frozen state.
> > > > > 
> > > > > Since __thaw_task did not fully thaw the OOM victim for self-termination,
> > > > > introduce thaw_oom_process() to properly thaw OOM victims.
> > > > 
> > > > You will need s@thaw_oom_process@thaw_processes@
> > > 
> > > The reason for using thaw_oom_process is that the TIF_MEMDIE flag of the
> > > thawed thread will be set, which means this function can only be used to
> > > thaw processes terminated by the OOM killer.
> > 
> > Just do not set the flag inside the function. I would even say do not
> > set TIF_MEMDIE to the rest of the thread group at all. More on that
> > below
> > 
> > > thaw_processes has already been defined in kernel/power/process.c.
> > > Would it be better to use thaw_process instead?
> > 
> > Sorry I meant thaw_process as thaw_processes is handling all the
> > processes.
> > 
> > > I am concerned that others might misunderstand the thaw_process function.
> > > thaw_process sets all threads to the TIF_MEMDIE state, so it can only be
> > > used to thaw processes killed by the OOM killer.
> > 
> > And that is the reason why it shouldn't be doing that. It should thaw
> > the whole thread group. That's it.
> >  
> > > If the TIF_MEMDIE flag of a thread is not set, the thread cannot be thawed
> > > regardless of the cgroup state.
> > 
> > Why would that be the case. TIF_MEMDIE should only denote the victim
> > should be able to access memory reserves. Why the whole thread group
> > needs that? While more threads could be caught in the allocation path
> > this is a sort of boost at best. It cannot guarantee any forward
> > progress and we have kept marking only the first thread that way without
> > any issues.
> 
> When a process is frozen, all its threads enter __refrigerator() (in kernel/freezer.c). 
> When __thaw_task is called, the threads are woken up and check the freezing(current) 
> state (in __refrigerator). The freezing check is implemented via freezing_slow_path. 
> When TIF_MEMDIE is set for a thread, freezing_slow_path will return false, allowing 
> the thread to exit the infinite loop in __refrigerator(), and thus the thread will 
> be thawed.
> 
> The following code can explain how TIF_MEMDIE works in thread thawing.
> __refrigerator
>   for (;;) {
>     freezing = freezing(current)
>       freezing_slow_path
>         if (test_tsk_thread_flag(p, TIF_MEMDIE))
>           return false;
>     if (!freezing)
>       break;
>     schedule();
>   }

OK, I see. We could deal with that by checking tsk_is_oom_victim()
instead of TIF_MEMDIE

> Since thread_info is not shared within a thread group, TIF_MEMDIE for each thread  
> must be set so that all threads can be thawed.

-- 
Michal Hocko
SUSE Labs

