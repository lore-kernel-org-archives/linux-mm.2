Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D6DC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 06:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF39F6B007B; Fri,  7 Aug 2026 02:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CABB76B0088; Fri,  7 Aug 2026 02:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B476B6B008A; Fri,  7 Aug 2026 02:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81EE36B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:33:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4B5EC0303
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:33:58 +0000 (UTC)
X-FDA: 85073508156.20.576000E
Received: from mout.web.de (mout.web.de [212.227.17.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id A334E1C0002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:33:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=QP9ZUTzS;
	spf=pass (imf18.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786084437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8xVvU2F/fFUSSpqRZVrd3WQpwZlkQIJEg0DhUYBh/o=;
	b=JrFsps2x0Gljil6Nd5G9SDnN4eiTUPCVbIbXL4rE3zjGhnVI2NAUYSVd89LH5HUQBXQohC
	c/mhC0OzUxEKKpcNPE+Sif6O8PGK2aBCC4e0nTmAE5xbtUOKnGWk6xbiENzi/gd72ma5JS
	ZFvBvPrj0ZeFRwE0H4jTS95fAMiIVT4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786084437;
	b=amZIvTYNr437fJLcE4u7FZ7ia6NPhbO+i5Ja+fclifq8NEwWX+jFE3S07DOpCj2+2siXKB
	1zwXMghvGWsd4cebLBbwlrnmnsdo2pC8uKTGN3crYYytpzGQ5hcR+yITaHQ8yzGSe8xXmq
	UTwj315gk7XvgxZqwdzIoji/3jUUB90=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=QP9ZUTzS;
	spf=pass (imf18.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.11 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1786084411; x=1786689211; i=markus.elfring@web.de;
	bh=l8xVvU2F/fFUSSpqRZVrd3WQpwZlkQIJEg0DhUYBh/o=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=QP9ZUTzSxbdWcX/FMZWWnAgKd53KsdXOKzEMngTw3BxKwolo786Zsc3ANczc/9AV
	 7rscfect2zFMVrSYQ4QtrsmxfyFV0k9J8BblesceVaX88LrqyepX1pgGxGlF+ihIc
	 8uzymRoxzxoNQcvYzIZ9MpVoPwrbU8ID59WrWbXGlQ7omD1ECBJ3UdUHO0dgI2NOZ
	 42NagQOd7/R2TeFstj4MMVp5v0eD8Tvnq3pdzQ28TT1JAvm1st3OpRq/ALvRxaUAU
	 qooBMYW5uN11BHNZBMgdsvZyF+P9vyOK0IANpe1zrl6tnf/XrNPS8Pw40lSYsMsqe
	 cVsuINAl/XaweGfwNw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MqZQY-1xEJPG3iXQ-00kazQ; Fri, 07
 Aug 2026 08:33:31 +0200
Message-ID: <c27214da-4e76-4b5d-ab86-ab03beba8f6f@web.de>
Date: Fri, 7 Aug 2026 08:33:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: tools: Use fputc() calls in some functions
To: lkp@intel.com, acpica-devel@lists.linux.dev, bpf@vger.kernel.org,
 coresight@lists.linaro.org, kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 mptcp@lists.linux.dev, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, virtualization@lists.linux.dev,
 Adrian Hunter <adrian.hunter@intel.com>, Alex Mastro <amastro@fb.com>,
 Alex Williamson <alex@shazbot.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Alexei Starovoitov <ast@kernel.org>, Andi Kleen <ak@linux.intel.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrii Nakryiko <andrii@kernel.org>, Ankur Arora <ankur.a.arora@oracle.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Bartosz Golaszewski <brgl@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
 <202608070547.MRKfa3bH-lkp@intel.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <202608070547.MRKfa3bH-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:heSIkINqyeiTt9/TVU/2HaIToPYra83aIuf0AvbOJOpmzGssabi
 2pB+Q4N00ikWy96JtYbAI4l92VxDK1eIhjSpkmWDfXgFHRUQ7AnWMM14fXBeSUbUtrPT8vY
 ocQ8Oavw5OBRE5CCpreC0Xu8PbI7O1BHO5Y74x3WyR2UhRH9v5EgfFH9wSGPOPrV+FzK6Z/
 XIXRX7oHnEmzadhHoTc1g==
UI-OutboundReport: notjunk:1;M01:P0:faf1dCpquYU=;+6tK6j/uCs8jhR5JHZVE/TXw00j
 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
 IFJ+FFQ==
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A334E1C0002
X-Stat-Signature: bizpaxn443hxjsy4yohjw515png75qj5
X-HE-Tag: 1786084436-409147
X-HE-Meta: U2FsdGVkX18/eIrEiTgIYg3XVRSTmk162bzwDoZ/Su9K75kEab0Lh18+lElZS1SqC3GUK7/yZm7bpBMkKNZ2oX7Nn6xrJdOi6pJAQqFoBz+V+pdBOvzkJgcJqJFZN67L/2KH1SuBbqy9iPnA60YPjVjbQY5rg5SmAM6CdCqsqiE/Zhhn/mdxH1ukRqAeJUMR/zgclmZ1m2AihDgz97Lh3VQYFc6Eu5Q7CqI54nbx6sndeAGUcqCGh3QF5d51nXcmFVLYwWd9AOsQ/o2kiYOzZYDnBNukQEK8jpIDFWMEH9n4c/PjN3gvstgmgW1KDpe+a+tMykY630BWYiE+bMNYtukVVutLAtVI0/9lP8zSKwLOMHki8RG9elyARcjOdhJdGCwj1Nba72lb5+1YusNVZ7z28rAn/SLBPgeiQxqa4dbzhYIknZzJvHk91QSOaw4ErdrQsPANoRTiDLwyTaUDfznvAeOqvRVY+G0rEmEh9J/INHpYeQUVrNLf5bG4ADjB4yZI7njUqK5iRmFK3nC57U7v6JLpIvATJ8IVezRemPbZXY8UWFF/jHDV2QzWiHTT4Cefq4438d8GDMrrh7wZbYDHATyLsmCbRmAQgvTEe5cECNerEf4Wn+p9pWNZgZwpZiJE4sy9qOg1coPH+NJQK/dhUtSLSZLYQwmWcA3k+bRLIKC1nJ7KtfTJGUjFabDHeNfgA/gtk9Q7b+FK5YIS7xYHW0YKlx0U/WovpNcMqDx3VRPzww6jtzQPhNEi80h7mAxOZeyovIyWk7pB7xFuBQLOVdot9mfVxNq6I3FNC9dDZHMWH87ADuSWb+UUF4vawjZUIDfWKaQ7IlgOo7sMAp8Qvxu5uPdzk4qv77r6RSWIEajzgB3IjfadTSfs6IMV0na63KNSfe1kIiHu6iLJTXdAyIjTUrrliCWKhEIqK+e9rzH5hPbuYzUUVbL8FVn+55VIWRyDHwpITKwO8dl
 8yU7KcL9
 sSHwdSWWb3YYUzC5JXmr4ECvFBo1SZxC2DMX2gcKbqLC3+qvjH+dLQr0alnu8cK+5gVa6To7AUnrEP1NLoG+JEUTu7eXA3hG8q6z4icK0jRhpBFbd8cx/ocXjyBGvuQCIobbLMvTl4ShFhnOnT9+KEgleTMZV9+j9W+RHBb0utlCNepD7AzMA787oNlxu5wEyg/2Cnhb9reIVveGRg2Z43AgGDO11YqbuFTIzR5qJZKpykLOzc+ncl+8cUQ3gdLYs4tglIc/h1mGX+sLxLvIz4Wg0hmsOYdS4PGuQMJtsniAEGWY9yux2DqAfpSlu2iMOy5jPetnniDtCE40D1mitqCNuMlmnMyGl+8x1+GEOrdPWlPRXHYhqeLpmH8rENTcMZtUxvaal86HhfZO61l9PHTnR90ECln3/FWTMxRiLQOancfiha+ScKH6cZGDp5+51SqRATPvqKqYp8YaxSg3Q6+DnB+WTl1l4U10Hb3Ug7mTob8ykW/9U6v8YJUcFcH/78a8yVjkhIzntijC23ssdAWxHC4gQeWVfv1Mo7g650Gq+IdvHBqkKXXnb0udJbKKuRRTtjenj33vdFDjHMpwhxYdcEem369YNL/LS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> All errors (new ones prefixed by >>):
>=20
>>> builtin-check.c:300:8: error: incompatible pointer to integer conversi=
on passing 'FILE *' (aka 'struct _IO_FILE *') to parameter of type 'int' [=
-Wint-conversion]
>      300 |         fputc(stderr, '\n');
>          |               ^~~~~~
>    /usr/include/stdio.h:155:16: note: expanded from macro 'stderr'
>      155 | #define stderr stderr
>          |                ^~~~~~
>    /usr/include/stdio.h:611:23: note: passing argument to parameter '__c=
' here
>      611 | extern int fputc (int __c, FILE *__stream) __nonnull ((2));
>          |                       ^=E2=80=A6

Would you become interested to take another look at a corrected source cod=
e transformation approach?

Improving output for single characters (with SmPL)?
https://lore.kernel.org/cocci/406093f5-ee7d-4ae9-808b-2b42d4846eab@web.de/
https://sympa.inria.fr/sympa/arc/cocci/2026-07/msg00055.html
https://lkml.org/lkml/2026/7/23/2205

Can similar adjustments become more helpful for further software areas?

Regards,
Markus

