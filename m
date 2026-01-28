Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4FFD46BEB
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 18:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267BA6B0005; Wed, 28 Jan 2026 13:53:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245AF6B0089; Wed, 28 Jan 2026 13:53:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F6D6B008A; Wed, 28 Jan 2026 13:53:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 056DE6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:53:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9B9B1A0760
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:53:49 +0000 (UTC)
X-FDA: 84382271778.14.A4788B1
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1823B40002
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:53:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AiR8drud;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769626428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJruoHUytnpG3ZhxXfZjCqC5GgpnkyryTXuXTZBPFBA=;
	b=WSaapHq4CSmz/bPvSf9PtlkTcF0h1348yZ6Lo0tabzQFaeazyrVimmgda6PM/ku1+sgbz/
	s0bN4bWo9UqOlyhFbLOfvvpYF+/UnIyK9SPAhj567jzRFWh+F01pRmeBKvV8G9+U/fYu2Z
	aq2IAZf9liJvhch3Y8fjcLBHBCZrTog=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AiR8drud;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769626428; a=rsa-sha256;
	cv=none;
	b=tVnxy/ZU2GZC+Ei6Cw/ZcKuxg3+9JmAazOTfBYWagiap/m6k5gpvuLvSz/UCMU2s5mmfsN
	ZVYI70O/PNgQPz/w5SNu5JwS/3IY0szIqet+EdT6Skvd+JkcORq2oCAjoF1fT7fYNCRyKG
	jR22YGRRTeFc7wZFdCaKAv3VOJ57GRY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769626426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EJruoHUytnpG3ZhxXfZjCqC5GgpnkyryTXuXTZBPFBA=;
	b=AiR8drudioF/zHusMvMimGJ7lmtE6yo06ti5MBR8zPKeMC3E7W8qGAFrzChckidE7V+tcX
	fq06RMNyFUHzisbB8KCXW3j0bOPXDIhjTmGSs239vRQM4q9MmPdro008x7tfr5OyRGNVDa
	mXxOKqWlSgBItKfxXfuohXWj1nkv5KI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: bpf@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,  Matt
 Bobrowski <mattbobrowski@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
In-Reply-To: <aXnwzpeaggySKRzd@tiehlicka> (Michal Hocko's message of "Wed, 28
	Jan 2026 12:19:42 +0100")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<20260127024421.494929-8-roman.gushchin@linux.dev>
	<aXnwzpeaggySKRzd@tiehlicka>
Date: Wed, 28 Jan 2026 10:53:20 -0800
Message-ID: <871pj91sdb.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 5sz8abb4eh6pfmo1ttjd1ibxfqy4hqp8
X-Rspamd-Queue-Id: 1823B40002
X-Rspam-User: 
X-HE-Tag: 1769626427-273752
X-HE-Meta: U2FsdGVkX1/FcJ3JNgsaKu0Ku/4YWGI5q5qC9c394g8UnrWcGxfYvFsUV+P35qJTcgffxV9kJQlfMI+x36gTY/Z8kZKFMbwF/WijYC6qzAkz+WMvmYOvmBlFjn890Xnzf3hCjNlXt+d6iBo80wF3TTCljM82dUDov2ZSQN1qld3Eaiv2qDlBDE2K6W2YdD6yV4I+xYrLokoH7PScLAVI3g1UADISo0UmuzESPBvMp6Yu3D604AL1xeXDTY1KU5CitQ3DzdIIWYvIBCD42B+iO7+cRa1G9ibWXqP+TRNGpCIv1dYvQT+Tua09MOiU411ulfneZg06AujLbaEN3CfLqcNXirz4heLCOTc8IgkPEVhVarbOnW86hbzkXuVsuXvZ/XPUJehT4XDEzE9yOSVljZYsETljN3UxgDw/fK7qoH0gbOhk6Kj62kgOuXehBdZ7HR6dfrgSScNpJcD1pn8fS3NfLbFC0b8puatV6RUSjALtvOlt14sSEiSryS6394fnTNnGpHFX6Kl8bWVk0Lj2O2AvlKINcWmjUpaIfpPOq7OUT4Iv9N5OEjpOol7BwSRchN6WYEd9mEFShJgPNj3HObT/FWtCzod/DxiiJlr3bRmSgQbXTCDHKtNALOgbGua+UdFWsbgV/a4qr0pKo7G1CUYd53COqKBsdYtOmBcSYFDw9ZgeBQ0UwXd27wqiA75UNYm92zUVbi9BVZSN5VFoj74iJSXxoxPJxG8wZgDR0fPcBiRjeWodgoBF1QSbSnz7FKpRMUJxAHKRmljb9ng2vKv5yKnarz1av1VzuZrbdTgv1q2bcFrsiqoYI/WJdHGexr/J6yL0U0DQHnTT3KWbZ5omGVhc/Hcf5Ci6qOqlOHz2R1XFnF25rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> Once additional point I forgot to mention previously
>
> On Mon 26-01-26 18:44:10, Roman Gushchin wrote:
>> @@ -1168,6 +1180,13 @@ bool out_of_memory(struct oom_control *oc)
>>  		return true;
>>  	}
>>  
>> +	/*
>> +	 * Let bpf handle the OOM first. If it was able to free up some memory,
>> +	 * bail out. Otherwise fall back to the kernel OOM killer.
>> +	 */
>> +	if (bpf_handle_oom(oc))
>> +		return true;
>> +
>>  	select_bad_process(oc);
>>  	/* Found nothing?!?! */
>>  	if (!oc->chosen) {
>
> Should this check for is_sysrq_oom and always use the in kernel OOM
> handling for Sysrq triggered ooms as a failsafe measure?

Yep, good point. Will implement in v4.

Thanks!

