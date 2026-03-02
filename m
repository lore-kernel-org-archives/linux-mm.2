Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3DB3EA4E0A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264BB6B0088; Mon,  2 Mar 2026 10:11:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B8D6B0089; Mon,  2 Mar 2026 10:11:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1354C6B008A; Mon,  2 Mar 2026 10:11:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 049096B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:11:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD9FCB6650
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:11:32 +0000 (UTC)
X-FDA: 84501462024.14.26F0AF0
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id A2667C0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:11:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gEPTSwpV;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772464291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3BqwdRnHxc2GRaZzZyZvv1rY2lAxZpGHqgSHrtLwQ0=;
	b=toSQqsSTx7qxKV+lW7mzNYf5jW/JasgFgYZiJOmA/vZYMvbZi3zAPnmlFSrQLsp8TzNc5g
	1LSRQfa8d0+OnZAEx0FLsIhp3SNAHmkRCa+qjLRu9bSgUARw5ZFWtP2GugK0AR/feKabrR
	5SVqAD+np324G+8kZCXkwHmrUL+NgRo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gEPTSwpV;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772464291; a=rsa-sha256;
	cv=none;
	b=eD5pyeAh5hdJsbRbxPCmxYnLxwjdDvluG9OTASuTVIdvFPBE+muDB3XwDHkYSOtm0g9hmi
	l0GMigULnADlJ4+x5AVgVp7GOaB8Bh9wlSmaevYQNu925IjNmUe6sLgs7YON5Ef7TMsNjw
	Dr47MHhhCRAaBS+sEoU1wIl91JdQKc0=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50334dd44d2so54342251cf.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 07:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772464289; x=1773069089; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e3BqwdRnHxc2GRaZzZyZvv1rY2lAxZpGHqgSHrtLwQ0=;
        b=gEPTSwpVOW2jx3+fAzic7+6sUJ9FETm4NnTmxoQg5q2ho7+wqIfKESvffYAyNWIuT6
         Ma9J6LZEZyEXWK/WERZ81tNzOAnq924SHISXpQRBb2604mrrNGnw/5NEa/7G/qLAG8ct
         ejBiacJyACmWj1ibGwYt6yotZLgR1kk5nrEFfiT1CIjH8HfiAnImERFdbLuTWRBQ2tME
         Wu3oBmiNNynx1mmCcq+I3MOMyTNXsYdpViTDnShO46m7TKmvrzWJx1/VOpx7fuZv/ajG
         rWu+LJv94GYalZ9xe7U7FnoKygUCR2wktVFic/NVfKWCgVTprMS+0xFQ+BqAWEBBKyTg
         s9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772464289; x=1773069089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e3BqwdRnHxc2GRaZzZyZvv1rY2lAxZpGHqgSHrtLwQ0=;
        b=F961iuH09AEnEVmiVoF/I3w6OFVNqCw5sO9C79WewFdgDekWsB3jAGIg210dkd0yzM
         zfxoo9PoOT/4prA8LJvKL2w43/spPvlB46bIXjoOkY/Kvpdi7Uw17N5WuOHuCTEJjWdE
         +prdvEQ/BJ0+S3MWk56VAhIrNa2+VZLZmnWIfk70QW8rKEu9nXW8cBqze+h7Q/wZvw7m
         KrTJhYXEH7rZnooCxuE4+ynC23xBUbRoWBXQCx6Fik/Xtv3opBvdJyRcpcIrSn229Wx5
         e9VxcG1dCQ9NLpkzpWxaaFbhYSBP7M7hUri8RtNUUjLUULn22sqQc9TgeMExi3hlEGuy
         ZEHg==
X-Forwarded-Encrypted: i=1; AJvYcCUwjk7u+toUU/EP6bMkITfN7d2xkq/X36T6iChxI8ubTW7ZdXwj4xeNr1Oky4toAleWdtctQEvMLw==@kvack.org
X-Gm-Message-State: AOJu0YzP0yh4ZlymJfrYoARowNgpwzggNcRxhHiQ2HsM1D2kMjpg3TVR
	ZmNy5Qqwfv95aI05Tmq4h/ec2mZagTzeUlwYEoCF4kcC8+bbuLwdF5E0iDclNBlIYa4=
X-Gm-Gg: ATEYQzwhJMTp6wcbCraDdr+ncFj8UukKQF29POw7jq7XxIC4mowqDQW+rG5KGooft9M
	jVjxlh4C+2KhG/OMMu/XCrXI4j4mtIvYgvoZroDp5/eLiwI6UhnQ1rSzJBoxv6dgDUOzejXWzL3
	feh3Hs+PQVBOE/tz+PCSRHZMOsyL8WNntDKpj7FYasTU81HbrXW0zCIf5guHFQG9RadUAC5V+hX
	e6xGztsZyuczXsCFr5qiCvT15iBbcVT01Msn+YS8jsuKyZGAETU1FNj2RBZlnHWrp+0TNxAGSbC
	ZLlOO+6oOz6MjvGfdi7H91Ivebko+WOl2tWmin1CtzhcCdRkgXHJj4ZpqmO0MMgtSuYUBR5VAfV
	qxlNgQQRPSEJVnDCNSkoHBmw7gTPvdzAEsQyrpPBHz1xsVQSMt3dnkCTWXGpAWAsfPtmDvGb50F
	z3Ol4p8dtw95hcyfgXs+ZCJ0G6HQzhtHjY
X-Received: by 2002:ac8:58d6:0:b0:4ee:1b0e:861a with SMTP id d75a77b69052e-5075273917fmr173965691cf.13.1772464289546;
        Mon, 02 Mar 2026 07:11:29 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-507449add38sm109824871cf.13.2026.03.02.07.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 07:11:28 -0800 (PST)
Date: Mon, 2 Mar 2026 10:11:24 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andre Ramos <acastroramos1987@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	david@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH] mm: add Adaptive Memory Pressure Signaling (AMPRESS)
Message-ID: <aaWonCzCLayQDXOT@cmpxchg.org>
References: <CALXtAv3u1hgLkBEbEgR3=r_iz3=KrnHB8B-=tg8Q3CEOWAPFiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALXtAv3u1hgLkBEbEgR3=r_iz3=KrnHB8B-=tg8Q3CEOWAPFiA@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A2667C0003
X-Stat-Signature: 4sxgjtiycsko6hmj17zdwdjas333b479
X-Rspam-User: 
X-HE-Tag: 1772464290-712101
X-HE-Meta: U2FsdGVkX19ITTa8d1wwQGb5sFVvHRnWeDAMUsMTiT3fZRTkyPv+5WCdi3nSuYs2Ed1H8BiaZCiovHKDfu2tV3L6MmJrUmHI5KwtCWST1and1vHH01OD6RmhpPQTJfsbTsV4h9XlWg+jmdXlkGcd8M7D6uzyN4RPSGDRE9xu9DCy5MalGUxku7JMRsdMOKbJxUUR7Y5HAKQiOPbNC8T0pTMjL2jFI71fagVTxaWvfhWI8N2CAmuAJxwpBPAxP+Tb27zXvtabRW3DRhaSrsSBUC8sbFybhA07KPZNleJTDjhqN20IaQKCJPn28s5EnGhdZuzk4iyZwu8Vasr7Y6N4TjnVIHnCed68DDdpSpuIs3OwboH57SoaqNo7vGof5UNIRzyrSY6UUiKAYFINkHkuvH/jd5moejHWX1v+jbq/Ru/4dOCYFvAijivjNz/trOWfLEFUFSHNsoXDXpFF4tlUek/KipiYjWOzsjWZpaITsYYNpaC3eiGbfFVoZr8IBgry76dqjpBhXBNzD0s2PHx6VyrK9Jsa861t4b4fVotDfAgIC+QuOzgeT1A1LimWvawhCNjvpS4r+95DANshzBqy6CyY5Cj4MEGSsXnZKlOmPsVFzCzfPtD4Nn+H5f1lclYO78+09vlhXG0FSvOgFg+vGM5LmghWB0nkdNK50mo1nW3SOOjXQ8vWTonDuglOLI6k63pIIVH03DbqTw2oV308qP5QMCuz4geDpnT01RpsnWrvIPKKQvxmz6RWUIjbiAUqqHkH0KBSXkZvgJ0bm52QNpIW8IA/spEjLNpjPFK/xssgVKemXVL/ed3eTzmPdfhl73y8oI763JyFBO3fC7PA/otj5+LF/cZkAdfjHoZbSefm6afHF8rtzl74lOfBBDI7o1CzR8LrcDcfZg3SOnkz21tEq57c4BDQq9PyAqnfCnT9VHeyn3i9PCiIP9CBWq1dgw0Y25nI7AJNM9aAEJ+
 1k5BJwoG
 5Uhlm1+EXox5RAGTv4TJ+mRIlFyhE5qCMElW02jMj1mqQcOIC9iAv8hnfpwZIWnrH1XQ8iG7s5fgd5CGNRefh3qf8hX4emqgxr2IVQcWwxVVxIethscdOukcShr20m++YLQ7pkvB1zYDXyjObLxmfNivw48zHqRenK258veDO2+2Q4nGgBv3QOrj2HmjUTStMnfP9NslhPP05mgRoC1akd+147oyc6ASkKZkIWthg4WID7PEsOqELtQ8ZkP2NBVEh+2Hnv193l8W6U+93/KxCW2Mp1eBWBBecp/kXqg48Bs5vpjSs0LRq/FpscW2r32VK6eahMOel/bb9pNtcmkBJW05mnhy2Q5laZLwaC89ATB1T1ksaWq/KErXZjbbWKVKAg11mBWrPuwRNN3Ru0Mz5EL2EFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 12:45:33AM -0300, Andre Ramos wrote:
> Introduce /dev/ampress, a bidirectional fd-based interface for
> cooperative memory reclaim between the kernel and userspace.
> 
> Userspace processes open /dev/ampress and block on read() to receive
> struct ampress_event notifications carrying a graduated urgency level
> (LOW/MEDIUM/HIGH/FATAL), the NUMA node of the pressure source, and a
> suggested reclaim target in KiB. After freeing memory the process
> issues AMPRESS_IOC_ACK to close the feedback loop.
> 
> The feature hooks into balance_pgdat() in mm/vmscan.c, mapping the
> kswapd scan priority to urgency bands:
>   priority 10-12 -> LOW
>   priority  7-9  -> MEDIUM
>   priority  4-6  -> HIGH
>   priority  1-3  -> FATAL

The scan priority is not a good proxy for pressure. We actually export
reclaim efficiency-based pressure levels like this in memory cgroups
v1, but they're being deprecated[1] in favor of PSI [2].

What are you trying to accomplish?

[1] 340afb8027fa ("memcg: initiate deprecation of pressure_level")
[2] Documentation/accounting/psi.rst

