Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C46D3EE20A8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 14:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10216B0089; Fri,  6 Feb 2026 09:28:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7696B0092; Fri,  6 Feb 2026 09:28:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6676B0093; Fri,  6 Feb 2026 09:28:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDA086B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:28:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75EE71B1C2E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:28:14 +0000 (UTC)
X-FDA: 84414261708.12.4F8D124
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
	by imf03.hostedemail.com (Postfix) with ESMTP id 514DF20011
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:28:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=u7lacekq;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.68 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770388092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DsBpUlxtFsyeEjeiWFAkqcdrMjz0lxaLUaFPl/YKamw=;
	b=ciBA/bhuSOWsDoGbXDvDf+tcXSdgRLsi2qDWkDijF0m0oxBfvXljQ7utb6XJnuDaEfygQ7
	WNg3uVa3jyHmODV+n7MH3HHYycd9SKVztOdWq8r6RVE8H4jFdPdEV8SomU4qSGnQ7pQxfw
	EW8U11AJ0uBcqqMWzFXQ05xx0PzItKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770388092; a=rsa-sha256;
	cv=none;
	b=3N8DeRXjNT7frbv5XIlc0xKnPOXcMINlg/Fmr2kY7PN8WpOR8+/m4G7IXwWfr1HJ6N3l6l
	fp6T7TyLkGJFXrIbfpxlv3T42ARwacUUZIGct0EU1NhxCIYhRxkZj7RRc69GsagCM85XLn
	y6Fp6lFUkZLAjCAlRP6fXQWpWBY/r7k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=u7lacekq;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.68 as permitted sender) smtp.mailfrom=axboe@kernel.dk
Received: by mail-ot1-f68.google.com with SMTP id 46e09a7af769-7cfccba483eso725255a34.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 06:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770388091; x=1770992891; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DsBpUlxtFsyeEjeiWFAkqcdrMjz0lxaLUaFPl/YKamw=;
        b=u7lacekqXnWY3X2TCCUIYrifRabkTuYqtgLfM4hmChPgZls38pV1cGzp4dzpftaTRV
         mwzJk5WVCyvjoGgfz/Q9NmVqgHyShWoD8S0b2KJJvPTYKn9aD8+rCCheYHR1NuFnJqc5
         /CTGwub78Le8ETPk8y1ZbvAjcFfK6az1u5/Qa82zhFF7OGELpdgo96HRlwge52asPLoK
         2a31gn/NgDzGJqRqgJPVsPkL9d+xRNm1TWNryxSG3gB9wxm3tLUmzsVa/mn1jmI1uXMP
         LyYFOrk4KQ8MDHITEE+JzK6FXBAnGffbPAGqCI+HZnYY73b7MlGHvV0qw7FXZovzjUNt
         KNMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770388091; x=1770992891;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DsBpUlxtFsyeEjeiWFAkqcdrMjz0lxaLUaFPl/YKamw=;
        b=Ub0ULugBtEziQnnEEsuc9UeotCnU0xGSGLmfSLJGaF+Z4OnI/G5EG1J1e9fQg3ToRK
         WuohaF8RyuHB8P4PBLtCr3PJbnyvQxmzlyKz1O3gvTgCtQWY4T7JxPz/MTkSKAMU2fgT
         TNaPMn0bg+k8MXq8nHv2A65Y47R5b/7u/Ahwi3Qq0V26emR3uH/80Oc8J84ka5HNsqqr
         yU2Oleje1gvJkmhiXHQPsOAizp2ypsdUw7KIp5sw3c+RVV8HeXpNEcZglaSIj4LcrQXd
         NqeO3wih0De+5zyoEvpOnwhzF7TlMsJZUrZsb7yzu7K/Flai50gGFq8UOCUlWqt0E8C0
         5V2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXFBS4ruJojuGXrIYGSNXrKLW53crOPrVXdKVHBYQbbnaaMKybvRSYYOhZSZwkAXmDESQpuC2pkFw==@kvack.org
X-Gm-Message-State: AOJu0Ywsc0D0pRtCxiWnwz3KiUnSyUlVNi7gzfOsqiCKIW+lAWHjBhKD
	QSjjcGaifVaVyxlkMDyue4YTBGrKhE7tlESyPtFR/vtPGzJHNg1rzNLEtzMwUlxiOg4=
X-Gm-Gg: AZuq6aKAtxCtrvGSOboTeZpsqgLAlFnor7cLO/xQsyQyikRWsjbXtmpqhGNAFo0+hVM
	IdWekP7XABI0a6+EmQZxxBjMaMtVgXKgC8PBPXooP+ZUqZu1y9x8dN3MUodCpuV5ur3ovK4ooNV
	0dAUuknLkVQfAfOvgXsS4huvq4iU2aw+kYRxOns/4gzgwhKwv/sscg1imUsH1QleSn/Kz+UpY8w
	ejQB37czU7r1pBpZCnynzgD5fs8ZWEefnmffIB+CAPVxNN4NwDvuoknL9jpmH45IkERlBCxHc7A
	xezO15G11/2SG5kQQNs4vV0p59SpNKGRc6l5fN33QEiPro6VtH3of6mFgnCRY6HSPeQVnYPEifE
	6FCC8VyaNCmUVC1PFTiUj5mAFr1hyARUJGnLm+dT1+0fDH8KGhKmGsJQ9Hic0hzYvZx5M1ILqV8
	OMfJucX2oFrNxAJLcScZOc8xBzMyfJx00s5sD+Oozfo8Pib9a80cCNAKCeeQnvXkDlegFCDU2NL
	Nfw3qc=
X-Received: by 2002:a05:6830:2585:b0:7cf:d191:2a50 with SMTP id 46e09a7af769-7d4643f38damr1225567a34.13.1770388090976;
        Fri, 06 Feb 2026 06:28:10 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4646fca4asm1663267a34.2.2026.02.06.06.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 06:28:10 -0800 (PST)
Message-ID: <b57cd15d-8e3d-474d-9c33-96f04a2a5499@kernel.dk>
Date: Fri, 6 Feb 2026 07:28:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring: add task fork hook
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>
References: <aYXvR4WQ0LEYxMPK@stanley.mountain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aYXvR4WQ0LEYxMPK@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 514DF20011
X-Stat-Signature: sj5kwpmije8arjghnosrfurcebmo1sti
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770388092-946681
X-HE-Meta: U2FsdGVkX1+Oo0x3RyVE+Ig/iLBqJIsndETZEfUN3yE7ghC5xVf+Ngi8ctKXLnNk2CeVMtZpMkfLG783nrSHWpN3HvbqZUUjV0g1THHUUKDOgJN011bOFGhdNp9AyrryID1Y2//ftJfDkuzGWCrW7W24L60EiVqrKxKobOwKtIaQD30lqJKEzuoG2NGHOvCbFnYD2ogRzIW5VY5/79NeDAKpK2J1hRCTjeUvWoor09vnR1EECv4GlBTk/o3JnMEIkCsbtl5MeRxo2k0MxRhjQTSJiSiu38R7iuskHliPJAZ9VsuZu34ydjqWRr2b2Z2KTKhbg7MZJY7TAeC8Q+VGiiFTugqfLWtpupLGmA/llt/8INRR2MGIi/v91yDMfQbM/bBtqr51vG1c2pXTrYB+fmuUo+aaHe0RRVGQDDu4Z9dbu9L1BDweHMsxzodEx3A0uqDWTZR9KH/hy/x049CZTDbAsMZEWnhTn5SdZoZ1nNZDkEBMRLXEa9DPgdqsiFZTknVDy+e8lFr1DngHJw+AY4eiu6MC7d+ixk8/mG/6BUQUENe0ALJkCk4r9d/YlfGgJim88bq/Pw+vTSbqJqTW6U8N3LNe9wdZBnA7o3Ys+0IkCTOfdXBU4es1ige7lRZ5tR0dg30T//5Uoy1noU47z79vUelcy5q/JCF9KbKwnt/Zk20eTTKGbgv6YDxo0ANJXWF8YelR7qk/89SLpUCb+nQLFMDDA6BAfvJe7fUtJHFO2wlozbuNPYVlJVoE6x5NCBaUoqZyLAs1WROJWpJApdjpiybKmmR2qaznhNyC+J6ccNEwUx6ImW/y/XTAxxPYhSUBbfitRX6mHhva7SMkuGx7XDz3Kh8nhwOCjr2rvRezxePgFBka+0qYTcW2DBJx/+CpQ1uat9hZY6O9YMorm0b/EmKutIKsioU//TxYEIMWA2knELBelb5vXFZL2E8ckFq1Gs7/QnK57WACCKP
 6zT4IE7Y
 5QeC3Mh0W1LcUbWkLDuTQVGrV1rW2dHz2z6OhG6jrVYrOuEoUcq3tYoQkT75zjTFGY+V4F5k+zfBevjhyvmAjDFWgUhBUcrnoxYni1ZJHJGCuk5MZpfcbxXpddYnY894Ip7IU1gEH4B+GwDjZxXh8hE0irALroKZ8oqZzB+RPTqeIQhkb9WjiFfl6NHwWVyWAqQkIHT2fHiVZYedlLS9dbiIDaSQdc2aX0eNpAgsUn0cf9FPg5u2yorwKy40/sqQJt6VU4IO7MvTzOTrGoPtljR0ge5YgGyhDjNlKhP6zgVMziGJ9HskriJNNK86ZAPRNUsKrSOCYhoVmOeSwVw5UFReAeFrUMzMVS62ihPKZaKZ6sSNOwMaLk4gHVS7C4ME8iU/P4ZGPJzZom1Vd97/H7yfo/2q1W5yh4caVQ7b7Kh/oTffo/SdYsxw8keJNUEueKO/OzKTlMwpCtTjS8W7NjN7sXAV+4AoWc7NzVE0eSY7fXRHrsBnBBm8WqKIB/fQJLxpxFFiE07UmoTAik0A7lkJIXnribTMM8zK0r3ATnPekhD4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 6:40 AM, Dan Carpenter wrote:
> [ Smatch checking is paused while we raise funding.  #SadFace
>   https://lore.kernel.org/all/aTaiGSbWZ9DJaGo7@stanley.mountain/ -dan ]
> 
> Hello Jens Axboe,
> 
> Commit 4f08520591a2 ("io_uring: add task fork hook") from Jan 16,
> 2026 (linux-next), leads to the following Smatch static checker
> warning:
> 
> 	kernel/fork.c:2544 copy_process()
> 	warn: passing zero to 'ERR_PTR'
> 
> kernel/fork.c
>   2128  #ifdef CONFIG_IO_URING
>   2129          p->io_uring = NULL;
>   2130          retval = io_uring_fork(p);
> 
> The patch added this assignment.
> 
>   2131          if (unlikely(retval))
>   2132                  goto bad_fork_cleanup_delayacct;
>   2133  #endif
>   2134  
>   2135          p->default_timer_slack_ns = current->timer_slack_ns;
>   2136  
>   2137  #ifdef CONFIG_PSI
>   2138          p->psi_flags = 0;
>   2139  #endif
>   2140  
>   2141          task_io_accounting_init(&p->ioac);
>   2142          acct_clear_integrals(p);
>   2143  
>   2144          posix_cputimers_init(&p->posix_cputimers);
>   2145          tick_dep_init_task(p);
>   2146  
>   2147          p->io_context = NULL;
>   2148          audit_set_context(p, NULL);
>   2149          cgroup_fork(p);
>   2150          if (args->kthread) {
>   2151                  if (!set_kthread_struct(p))
>   2152                          goto bad_fork_cleanup_delayacct;
> 
> So now retval is success where previously it had been -EAGAIN
> 
>   2153          }

Thanks, fixed up.

-- 
Jens Axboe


