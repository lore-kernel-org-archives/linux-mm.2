Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BEBCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ECD36B00C8; Fri, 29 May 2026 12:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C40C6B00CA; Fri, 29 May 2026 12:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400FA6B00CC; Fri, 29 May 2026 12:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBD66B00C8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:46:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF6611C02F6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:46:49 +0000 (UTC)
X-FDA: 84821036538.07.A0EF337
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2513C4000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:46:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=mvg+vmuI;
	spf=pass (imf04.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjceQN559yBHiBpBcrgWZddsy5fV5qxnCSMQkRdxItg=;
	b=LzNIim30JjDfS15E87Oai/Bq8NNYnnmPnUdWdhevLUzbnz/Rkecwx5zucEYJ56ArQsgGux
	7EkB3zPTvJSWg2PSx585xGe7CLzpMwa8EGXKkcxQ9zirl75Smwd/aDvjg8QfcHwkh8uTMs
	plBnR9PDWB35SV23xRSjlHkd5o4fiG8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=mvg+vmuI;
	spf=pass (imf04.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073208; a=rsa-sha256;
	cv=none;
	b=TZ4pMIufLcg8Ywm2mEa8FsJPKuf+5dpVweiyg0pgQXUWPT5YsBwz6xmEdcFXhiW85BBH3p
	ufTCTRF1FuoJaANo5jsjE98DLTJ7hMjEuPNYQip0F/zCodo19O93D+Yrl4hIJH1xSIXY/4
	2+6+e1MrNAua1NHvXWXP23yK3Uv+bq8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rjceQN559yBHiBpBcrgWZddsy5fV5qxnCSMQkRdxItg=; b=mvg+vmuIG/jTPG4UCyUgkfFHDh
	ugV+xPvBnWpvFM1mHw+0B+aZxEQZp05WnjtDCN+pr1PqJfia/FJqutvDNuOFvdSzmuebxL3kRiv2C
	EL6teyyYt8zc3JUhjTYGGDiOiDPql0uRQCrQXr0wxP+qPE1mHDCs3hKxxNlSuGdVmlTf0ewZ5m4k4
	rahHLMQ9BAFqR8Ilkj9qisQc0xnwHAptHghYva38JA1mo67KzKUfbpTQ73ZaS2sb9a6T/YTnhfRIr
	DvEiwhbSFw99LU4OHk5hodhyy3Qc2MCCcMoYhQmhrRqKheMVMCVZ5gp7pzaF9tErH3Sy60ZPiZq78
	BPB6fMfA==;
Received: from [179.118.191.12] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1wT0Lx-009x9D-V5; Fri, 29 May 2026 18:46:34 +0200
Message-ID: <6a58fd9c-1a69-403d-ad13-32bddea666f3@igalia.com>
Date: Fri, 29 May 2026 13:46:27 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] treewide: Replace memcpy(..., current->comm) with
 strscpy()
To: David Laight <david.laight.linux@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
 Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
 <20260524-tonyk-long_name-v2-3-332f6bd041c4@igalia.com>
 <20260526190625.3f4aca0a@gandalf.local.home>
 <20260527101842.376d567f@pumpkin>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <20260527101842.376d567f@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r8or5zg7yqabd7m8xfrcxk8yssdaacwy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2513C4000E
X-HE-Tag: 1780073207-88695
X-HE-Meta: U2FsdGVkX1+qnmrjk03UaXDmSg2M4cAi3uemN85mOvi7kI+85SEmfrzkOcGJDbAzPyBCMjx9BK1YcLef7xD/C90nnlJNwOnss3hQx2reOzh9UyLJf0Xk/ZL5lso9hVsiir2c0fbcXzNnoRfz7ytsw3WwLdo4qz+wZaxFiXZAKC55WNOTP3wclGDOI5lamgMnk8JJhfrhKjecNI+7XRnemgRoOnxwzvoLjg8xR54V7ymXfHJobg1F5XJGcj7m/UhT5LG3NZd+rfasKl8o/ZnJgCEyW5Sb6uqHW/48uSaLrYvz09A6eRirEwBJwU77DLh0fO7M+2J+Zxuxg3aSXagBdC3IQOSvzcuxd/s1g/lnhOz8BYqYu734k4WYf/YO6mF5QWReWgJPdPTVvhFd+kXJuZTXcurbJO9s6IliBKU7zr2PTyWX15mYYNVyn8vkQoVb+wRwOy1soySuYEVdLyoEcGnU1sp9Alt7B5Lkv4flWs85BEvajTd1jYWu1oMc+CDLkkAxTYPWEejMuEC7R4Eah/Difu1tEEDjWKopD0N4vSYuQZFAwZhzPD/xwhTxBcJbn4ty9dF6gk8ys9qjQU4ArYvRnkB81JYjxoqHSfqnll1QS4rCsaX8G1cFkCxWjYqpbv+3pobOVV8j3USnlo/xuKN4a9iUh/9LkxfxC2scfhCGibrAk3kmvkp4QQU09h32gpkV6hh3Ki6rus4MpnZT9f+1ZFacNFBogQHxvCmVjH2xHRbgUVK6Pkgpzmfi8kxb6GiQpl9lqqOrcvxDsBxLeQ4wXLIhhruj+aUj0lsII8WKp5wbiARQq9F+x2/R86UJUQbaFXpLlPkuCHs+b3pYKY+eSKaYVPxD6n0hjwZgIfYiQA+IYXUuVpmrzrX+AXVgN0AfwX8pH+k/8W9oWvAzGSfz+ftB6oShYg15MWFIESzbBOpl6cowwWsm8XJ0U9Y6GkkfBxkcTtNz3wymrYx
 AWbXq5ZT
 tkUl+uUyy+0YvpEen9CdyU+nWkwcSBmI03Tf1CGCW3Yrs0HCsT1MJjJZ8971avHFukrLy3bGaeqbgmBy28v2u+w0T65m651zIA4iF/CK/R34wS/NB8OAllywBVlqOr74urDiQl2MTB8lQI/5VbJYbU03MnGV5BgDq8kYCWPXUzQ79WQgnGwaVMshspP8qMtj97EaX3EYzZ28C9Wp1M+kON15/P52frGnRU++u/+6PCKDQLTiwqUd4j+rwgMAW/Rr3nl6wcVOScDLti5/C1o9i99zvuQVuFnpC4bc+YVFlW9fOxYm7y5MGCiJP529uy/xcUHgntgCjslI3sSRlgIo7reNUWtBJk1Xf87fy6iyDkwfaccxFemSS8Xvc2X9ZwZ7SEn7gDNVFXog1ZXbfMLcIWiogy71pLluISy79YoJU3Vsg1MbqBKGBf0ZMqfXJ8fUKInH3QWEdmVPHWDdGKp2SKjoe2xKfXmFOBKperSOdXJ51MJ4pWWEiSPP2dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Em 27/05/2026 06:18, David Laight escreveu:
> On Tue, 26 May 2026 19:06:25 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Sun, 24 May 2026 19:38:53 -0300
>> André Almeida <andrealmeid@igalia.com> wrote:
>>
>>> In order to increase the size of current->comm[] and to avoid breaking any
>>> existing code, replace memcpy() with strscpy(). The later function makes
>>> sure that the copy is NUL terminated. This is crucial given that the
>>> source buffer might be larger than the destination buffer and could
>>> truncate the NUL character out of it.
> ...
>> As tracing now slows it down by 3.9% which is a significant increase from 2.7%
>>
>> I really rather keep memcpy() here.

Thanks Steve for taking the time for benchmarking this!

> 
> I suspect the copies could/should be replaced by a copy_task_comm()
> function that can perform optimisations that strscpy[_pad]() can't
> do because it can (for example) assume that the source is terminated.
> 
> When the src and dst are the same size it can also degenerate to
> memcpy() - which should get inlined.
> The cost of copying 64 bytes might still be rather more than copying
> just 16.
> A compromise of 32 may be better.
> 
Ok, I will work on something like this for the v3.

