Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E26CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA546B0005; Tue, 19 May 2026 16:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB246B0088; Tue, 19 May 2026 16:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872876B008A; Tue, 19 May 2026 16:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72C616B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:47:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0327816188D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:47:16 +0000 (UTC)
X-FDA: 84785354514.08.8CB0F0F
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 18F1814000F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:47:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=VB5BaOgf;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779223635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcDxZYCIBGpWTE6wZCl6deG1Hv22DQPSYPWGbFcmqK8=;
	b=IJcDg1P8BmZgMJHRCyWx6Jx0JADedKftntLeQew1xKzujCf+ow5jle4PafjWWPTQLYDApu
	3XshLt5GSyAK2SMjVUkekIyDto6qvxaqQiz1ZhyiBneqNCyzlva0+DuhrnzMDcvzdftlxG
	ro63ZtSyBMxWjbuEl/bOYrcbckILooc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779223635; a=rsa-sha256;
	cv=none;
	b=UsupSDFQnEhfcQnAkweHl74n5kPBSmsq8/thM8i7EXZncHf6wB0vUIwbKzBBGE+f0nEB4J
	9AkmrofC7wK9hXmbxtjDkbyVQ0leKR3tOKKABt0Ba4wpbG3pPqn+GkpdPYa9i4niTaL4h8
	y2bwP+r/PFh7CbDXlQLhWdJyk5As30E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=VB5BaOgf;
	spf=pass (imf09.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qcDxZYCIBGpWTE6wZCl6deG1Hv22DQPSYPWGbFcmqK8=; b=VB5BaOgfyrAXSSi5m4EFQEb8Aj
	XrLFenIf+dBNd7uulUxeTn5poyR8aKCBNf54YRhg9Au+AIoSbEmXOo4Fy1ZLZhY2qvy3C3mwRDOkt
	y0HRmTY10nZdGq5TMRO0WebFuOAfzbU+/InME9Y662/bkW+dkFZ4hvnmyRpDuiAT90FNQ3ZZIt4Hr
	zIErHqz6AVZUyvQ9cVL3e6zh5WjVNIaoPDxH/jDidiPG+Ef2BQP7jHMK81OWSFFqPnqe3nJb6k7pe
	gQKyEmnExlD2O5yXc6r+6F5wrMnQHtCD9x3tZYvjNKzcITGKVUjFoFLyhOFr7Bq/WGPlDaDSV5QWP
	SOzwRwdA==;
Received: from [179.193.2.40] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1wPRL2-003P3J-6r; Tue, 19 May 2026 22:46:52 +0200
Message-ID: <186dbf31-e5a8-4bb5-a392-0bf3cb4127cb@igalia.com>
Date: Tue, 19 May 2026 17:46:44 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] string: Introduce strtostr() for safe and performance
 string copies
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
 Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
 <20260517-tonyk-long_name-v1-3-3c282eaa91e2@igalia.com>
 <20260517223419.3262de7c@pumpkin>
 <d4d6cf61-568e-478e-88d6-01b769d7eded@igalia.com>
 <CAHk-=wgBdK5iRf1NdOuMT0-+sjxUc8QAU9vr66jBBzY6EFDtUA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <CAHk-=wgBdK5iRf1NdOuMT0-+sjxUc8QAU9vr66jBBzY6EFDtUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 18F1814000F
X-Stat-Signature: whta8c4cf1jzhxe4kffwc7baqnsb3dyy
X-Rspam-User: 
X-HE-Tag: 1779223633-557503
X-HE-Meta: U2FsdGVkX1+oeABdCIO5nCE3lSiZ57YBFZfJoe9GsEky2VL/AYqk9Mw6Z3Fncp/8o+Ylg2hps7OTNGNJtR/iXRK7NU6DT3Ao6yoc9uKzLLi4cOjzTrRFGc/bCIjD6JSyqlSO3/WEWjZ0p8rGRTnZ8WdRWz+a9xQXIfGDtot4EuMrYSZEfUuS16KLpyEjVXdv+V0vmlFH5QsGGeK+Yx1RwJx5RNLTmprDCO0x3FvJu7AqWBcAzVsIAQb2d09szDcEocsITpHoN+pUKteqni3T78viRgx7UM6XOjbF32C9c9ZNBUki+0hmD9sFmiPPZkKdUgXsAicZIR7g4dlbCIWn0kFoyHyH6nVbn5eF+A2G8AMinPmnn84Q2EitQwYwng9AHUp1p+DUvK+fYsjTQ4XMdc9yE19ZIzGV4v3FIGE5haxrTO+93lUnY6H7f8Tt6dshDThb6SDtL2MqR8aYN5iU4PEgITRCrfxcdgkMiQAj64xeZclSd7S8wb4eEGjnqaIZCAAcQyOnIjuXhrsx4378jGA0tr2HrH6lbE8BLgmL9PEUw+kZW5rljjDvTgqpkZYuotEAtLQWYxzIlkK7jwdOMndg/7pWesmDfAdN16flaUVdRoI5xjolgcOh+a8G6AaMJbyWijre3uy6NNuqnCL5K5IrBxaGXjDS8H3+ABk9vI7qNebCNP+Gva6/S0I3KhNd5hNPl5CqSfu0MPhILhOpKJT3ntvddidyUu1DN/sKywZPqkP/sZ5qXeUoJSwXTm0poiKMUMd9hds5WQiiVCJdgLRFTvAYC2EWO58Y9uUQqVQBJXOGom1vB4WmWavMgmptwnq+fZIDro32Sq+84CzG//Bq8dee11+A5yhMR2JljnI4tlWzydj57hwWxPWudO7nXqbeFbE6YK5dDjx7M4tIewJ0S97V3EbicAgyYXLUpf5DHePEwxGZO773rZxLG+UfhY4GPIznnUHnChHElbz
 +uH6Ahzo
 BpWIGvJbx0+2k/cDDwZg7baBaC5clV/dcB8FuNhC68uSXAke3NHS2YQzQIaQT9vMhpiCnnHfzHYc+9fzx2uPj+r4OyzcjvyY37vvOAkI3SDcf+OZRGiE/Rh32/USSi5ghCjKfk3pqzmUQyiTt/smIWFWTPl1ruMaQZzXP/Lju1hXAuiEEoB1eh5wEV6rNAtSkYh6ZqSIhuEAiQjLIZLEgM+liml3sduD3lWZqi8cVEBlWNk5UuIr6jYSRchdCEmRCZHhwnd++i72g4iLEJNEJ2vex9M3kNRUaEJp4sKMYpktpP+wjr/WSXXYdlLh/Plhq2RdU3IoNl6QJ2C2e7rj1k8z6WizM6kzDcKK+E9en33XJAHDnRmNeDQxA7o/Hqr7SSrnFNfMJuZOpf8gHMXKIOjDqKFlkx3nKSO24OoHqt1owo8f3Ymte/Zczx1sv/XOT284x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Em 19/05/2026 17:37, Linus Torvalds escreveu:
> On Mon, 18 May 2026 at 09:37, André Almeida <andrealmeid@igalia.com> wrote:
>>
>> The problem is that as I'm expanding current->comm, the source buffer
>> might be bigger than destination, and when we truncate the string, it
>> won't have the termination NUL byte. So we need an extra dest[len-1] =
>> \0 after the memcpy.
> 
> What's wrong with just using strscpy() with 'len' being min(srcsize,dstsize)?
> 
Well, I thought that strscpy() was too expensive for the trace use case, 
but I'm happy to use it in the v2 if it's ok.

