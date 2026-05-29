Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F125CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7327E6B00C2; Fri, 29 May 2026 12:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2876B00C4; Fri, 29 May 2026 12:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1876B00C6; Fri, 29 May 2026 12:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49E736B00C2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:44:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AB60A0234
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:44:27 +0000 (UTC)
X-FDA: 84821030574.28.2DA36D3
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8CAA440009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:44:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=cF9LekIV;
	spf=pass (imf12.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjSZpRRKFfq6gFxbgWO1ruANO7yleaf1A8CefXQR1II=;
	b=jNrC/T2w/udzUkfmT0GeSypdje/P8YjWBO2vOhPZrrrNTfaiJITmmE6HTOjuhjgjS7lEAy
	QOfO7krfacIbsFP84ZlO6LNbmTo04HAPisMalluAx2PWyEKg4fTGPC7ctUfUf4gxUXfR9b
	vOPPFUGfaMoXD/47HtfBWpTvJC0y83Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=cF9LekIV;
	spf=pass (imf12.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073066; a=rsa-sha256;
	cv=none;
	b=SILy0xdxjd58tkG9WaMisN9M4ywK5plNV/NUm96ew2hjpLH+VY6TXzkWAO+mgjstuut/Bs
	43F3KFhO0H+/RY+5vTzGnx4nPqJ10RVF89cUY1Hgy+Fb9gSDyyavMJ8e7tW6FQ81KjmCq+
	VQqDQhvIl7dQib+Vb3hqW76K9YV8fWE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vjSZpRRKFfq6gFxbgWO1ruANO7yleaf1A8CefXQR1II=; b=cF9LekIVsQvhOQcmC5OwaE8co8
	IpKFGDbwPmvmtYdWvDuQa0fI2iOe2CDy+bThTpd5R5rjOBJyR1SX7qZWTUWY4EjjPT73n1ic6+Tbm
	8a8SnmSDlVXboU+sN1sUu9W62v2F5vhfEQpgiCBoc2a5iKaEmXaVaflqKLZGWa1KgaTI163RnRjQB
	mxkLC0/9KTdn0LiZ3a5TQ6xdx3e0uQP78N1pCW/wlYsaSZ5FLF9FMwJUE+z2gRF14jz/xQnt8FfHh
	hPD4PiErj6dzAqTcvu+vWS2OgwSZqikTTlss7KiUzt5B6PtgvKnLwC0mrOFsD/yUI9oKg4Km98zWx
	HJohMJNQ==;
Received: from [179.118.191.12] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1wT0JV-009x66-G6; Fri, 29 May 2026 18:44:01 +0200
Message-ID: <2a7566cd-3d64-40f9-b746-ac8ca0409846@igalia.com>
Date: Fri, 29 May 2026 13:43:51 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] sched: Extend task command name to 64 bytes
To: David Laight <david.laight.linux@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
 Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 Steven Rostedt <rostedt@goodmis.org>, mathieu.desnoyers@efficios.com,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org, Bhupesh <bhupesh@igalia.com>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
 <20260524-tonyk-long_name-v2-4-332f6bd041c4@igalia.com>
 <20260525114107.7fa5b4c1@pumpkin> <20260525114241.4b6f3050@pumpkin>
 <20260526123103.4facbaed@gandalf.local.home>
 <20260527094221.2f5b49d9@pumpkin>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <20260527094221.2f5b49d9@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: fg1ciwj436bpx6n54rnmahje5q6qs9pb
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CAA440009
X-HE-Tag: 1780073065-109790
X-HE-Meta: U2FsdGVkX1+zLQdo5pRUNosy9dYmwL9Me3qGS0X97CW/iCUMhc1Y2nNG1aeNP7Dq4M/W8qz3DStjPcJKb3KUBlk9ZKBxDahNsKXBhDDkOuJfAYXp50tTCqyOIrOEp1UthZcFDfZ1zOrH9ESDdkcHgLnUWYt/t8y5I77pmoQPkAeq4F9mqKK8kvdE18/n7yj4Spyvi9CzuB8uxGRqcmtX4nerOPVbR1fXslPtc1mdx7BtowVx93BOj84fkOD2Z1qZXs2drNhlvGMTC9jjtKvxRLT5lHfx9+jqO4vs3cezTyAv/zf1ugta/z0V3BTyecrc2897wA5w16+BbZns9UxmdCOQT8biNzFMRklF5Ilrm5LFiDTBZoDSxKaSPAXsGNVGRhBnbChMZXNc0Ql9P+3SDoH1e9oKplITzxf2PzgF9XDQuYFvLsHdQ2MSQwHo8QQUt6/ogSwaH8LJYncTe5m0kyfFH2zbo5gaoheo3tYpngXyQK114/bz7/XLmeH2GBE3FUuOheIwnYzz6bzDf+LqUAeOusKvyWUaKeYO5dq/X4gLpmHIxA6Oxk0HYWvWqI8Kk4moXSpkShwsUDRWK90aEkHg8ljlJqE2ory9SJ5MJFaOB70OrVH0ItzHb7tzosAFl8PQRmggl+3yexTRo9whhzMcmYBUsGc5SESpaQCHOJ2rxqUkeQn3BuCJUxzTi3dbCK42GH/J4tcYK5Zt+BZboS1jreB6fZKo87tSHi24w8GY18lLtzghg8i/9J/kFQDu3i5v/rlkrdYH/5Mej4bnioJINKsc0SY2HVhCHr1dS77JcsNDt8hZE6FUX5HBlsSD+k1XFzGukePcDCwIyGmDr2zOdVZc0e2+/g17mo8I/oGCu4AOADyYWtTLKAVtX8eUg6/lsXimh8G9FURtgh+N3wu6dkJSiPTH+sOMBdYdDZrqDjME0SUVIRSG1DdgiyWaqOMtpZbIXdtaki4vL9/
 kMSE8QP1
 5q4q+Ygsw1VVI0wVxCbYDduM2tMBdXBIcdS2Ros/VgQZvfJwBrg/WrCTswO0sQ8j1araUZKFQ1oxu8yvxRNEWWYfScIJWwrNkOabs3TeQv0wlhrlDdYYs5WElwWjDwn1vmSnBlXKD8MAQeLMw5j4o9FuHGkQjYVdYyCU2YuXZvwJTIDYfiw01G0jFCqXlQ4nRzABryi6h/WUCtqWwZquvPQCV5rhixPw7++MIefagukucJLmPHzmYYtr4P0183AVzlI3KGIUJQWvSt7g9oLSNEQAP+riY4BWb/1h+FVr32+hK2SqteBxgAAXXizhYU321IGCKxEfMQZe6D6PXYAAgXEf2enYkPSOLA3jq5TrYwez2GWz5tct4PvSRaMcsI11ucbOg0VuR52FVJronTV+98ErhynUnz++MEkCSX2OFJCPBx++uxKkm7alLIOuxgLKOUvAr5JlzyAF/AK4+7whdxGjdy8dtMFqIWIB4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Em 27/05/2026 05:42, David Laight escreveu:
> On Tue, 26 May 2026 12:31:03 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Mon, 25 May 2026 11:42:41 +0100
>> David Laight <david.laight.linux@gmail.com> wrote:
>>
>>>>>   	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
>>>>> @@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>>>>   			error = -EINVAL;
>>>>>   		break;
>>>>>   	case PR_SET_NAME:
>>>>> -		comm[sizeof(me->comm) - 1] = 0;
>>>>> +		comm[TASK_COMM_LEN - 1] = 0;
>>>>>   		if (strncpy_from_user(comm, (char __user *)arg2,
>>>>> -				      sizeof(me->comm) - 1) < 0)
>>>>> +				      TASK_COMM_LEN - 1) < 0)
>>>>
>>>> Nak - you can't do that.
>>>> You are reading data that the application doesn't expect you to read.
>>>
>>> Or have I got confused over the names...
>>
>> You may have gotten confused by names, as sizeof(me->comm) is the same as
>> TASK_COMM_LEN. Basically, the above doesn't change anything.
> 
> The name of the patch doesn't help:
> 	sched: Extend task command name to 64 bytes
> 

well, I will try to make it clear next time :)


> If you want to catch/check all the uses I suspect that all the
> occurrences of TASK_COMM_LEN need changing.
> For clarity this one should probably be TASK_COMM_LEN_OLD.
> (that might be problematic for the uapi headers)
> 

That works for me as well, and I don't see TASK_COMM_LEN being used at 
include/uapi/.

> -- David
> 
>>
>> -- Steve
> 


