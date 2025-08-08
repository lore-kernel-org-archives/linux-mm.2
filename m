Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EE9C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAFDD6B0099; Fri,  8 Aug 2025 03:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C874D6B009A; Fri,  8 Aug 2025 03:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75C56B009B; Fri,  8 Aug 2025 03:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6ACC6B0099
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:37:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C157C117F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:37:31 +0000 (UTC)
X-FDA: 83752785102.05.32B9F5F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC96D1A000C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:37:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c75AGfge;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TaUAwmBU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c75AGfge;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TaUAwmBU;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754638649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0p43mgUNO5seTET1xEwfQoW6sHiuh2LO95EYWQKlcY=;
	b=pBDVryhDSz/f7v/gRywykcT731wfJhbMUThc4yXz1Ob2aOichcfG0s9SP8yHEuDXBcnNzh
	GVABYkOJdvSEMJUiIzk8GnW5L9apLi5XFkqQTScEZgAnflwd3/SiCiNwkWIVteveN2hkN7
	5JYMcXMEq4NcjBLSMpJSnTWd6EJl2s8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754638649; a=rsa-sha256;
	cv=none;
	b=qwTQumzMa7BqB3OmNA3w5ulRB20Rs3u7YB95CGAub6kdy8WV1DQRS065mes3M7WtYGN2zm
	2KzBN187InBdGQQfeNuX3qaDjcmeL7Vb/U/MiF5X6ys3WAggTV4LDtdqr9frSfhQNZ+vkx
	BSgQDp8G5MB4QmNE5yQdh8XCyiGX4X8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c75AGfge;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TaUAwmBU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c75AGfge;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TaUAwmBU;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1AEF65BDB8;
	Fri,  8 Aug 2025 07:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754638647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A0p43mgUNO5seTET1xEwfQoW6sHiuh2LO95EYWQKlcY=;
	b=c75AGfge6HHDH5jdTcEsolec6aCNXOm0BYWa3LenVugzpdfLZlD8i/CYhWo385I32XusSn
	qoAOiKOHTL86554C5/7u8qXwPJr8wsdhTcjgcCMW/7JzDae6uTNhusiKi/9HiUcTpKsnnb
	AVZqqvxfCTwqcbzOiyBocnEO9LBt2+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754638647;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A0p43mgUNO5seTET1xEwfQoW6sHiuh2LO95EYWQKlcY=;
	b=TaUAwmBUBuggXBcN+cGS0SqatEOLWIuV+IbrWWQ6bE+cbMsPRo4UlnrEzTgDrjFyxJ8+pM
	9krCte1Gjc+rJ9Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754638647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A0p43mgUNO5seTET1xEwfQoW6sHiuh2LO95EYWQKlcY=;
	b=c75AGfge6HHDH5jdTcEsolec6aCNXOm0BYWa3LenVugzpdfLZlD8i/CYhWo385I32XusSn
	qoAOiKOHTL86554C5/7u8qXwPJr8wsdhTcjgcCMW/7JzDae6uTNhusiKi/9HiUcTpKsnnb
	AVZqqvxfCTwqcbzOiyBocnEO9LBt2+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754638647;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A0p43mgUNO5seTET1xEwfQoW6sHiuh2LO95EYWQKlcY=;
	b=TaUAwmBUBuggXBcN+cGS0SqatEOLWIuV+IbrWWQ6bE+cbMsPRo4UlnrEzTgDrjFyxJ8+pM
	9krCte1Gjc+rJ9Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 05D471392A;
	Fri,  8 Aug 2025 07:37:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jozkOjaplWhZMQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 08 Aug 2025 07:37:26 +0000
Message-ID: <c5bd00d6-e6ca-48fd-a11e-c90fa9c50e05@suse.cz>
Date: Fri, 8 Aug 2025 09:37:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Realtime threads delayed due to kcompactd0
To: Alexander Krabler <Alexander.Krabler@kuka.com>,
 Hugh Dickins <hughd@google.com>
Cc: Frank van der Linden <fvdl@google.com>, Mike Galbraith <efault@gmx.de>,
 "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Dennis Schimmel <Dennis.Schimmel@kuka.com>,
 Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
References: <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
 <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
 <DU0PR01MB103857873A56FD121984568148226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <c48f2877-4d37-4310-995e-fc5c2ae9a366@suse.cz>
 <DU0PR01MB10385C08C119276D99A234D978226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <33275585-f2db-4779-89f0-3ae24b455a67@suse.cz>
 <771a8fc0-8195-44cc-55ed-c3573d497d2d@google.com>
 <DU0PR01MB10385C55AEAFEBCA2575EAA77822CA@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <DU0PR01MB10385C55AEAFEBCA2575EAA77822CA@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CC96D1A000C
X-Stat-Signature: m96c35sb7jwqyhg1frhe6uxdnf6r9hqo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754638648-892434
X-HE-Meta: U2FsdGVkX1+MG4wDuK8F7VHkylFRCL3nqem2QGX2AajMTMtT5iBKHg4A9mWBMkQ3p1dfy9noTTV4IW1Wh6GCdwB0Y/f/WjQ8OSeXhbinn8M9SB6ZzUvTNw0x0YwdtxqKvuZXCdNyKn8F6mIOueCiks/VL+dchMbFDoOQdglQlGyUo+XJWZVCft4OHdDRFUthglzSYZLNJ9OINmivoogvPj+aYFB1DehpqtIJogkKR0QP16zDTbY7uEXrbbs2n5W6+AQlGdhXjKhOtuGY46UVTHSRP+O2eX+aMdV4UcoESkp3erZfeyc4SwmVxQVOt0jH5Y7KuB1OjC7EzMe82iap9Ivm57/0LrJ7q/5iLP9HpjeQRi9nHlgQh2fTTCPSv5pNuufSs0KOUnQR0UPzck4gvnm+1qE9GY1zsVKn7puD7S3Kvk7+qd/kr1oApTi1kePv1XcAh1MH0p6UbBX/fCl5ktuw4JGe5jmaWRLwk4YTfAfQQsUzX/e9Zy3AVR8Lr+7I1sQSQAa4tG8x/TUXpwMFQ8z2hYDCtVNZfiyYMlg/WOKleiu2Wt4ik29qNOj96caJ2dpuEWwrxqTeq95ZAHvslqKBRp2a2fFiP9GGOhuVu2okNXKFWHy4SoGOgkfWPC9p5qmt8JWQpYO2fgLtQGPFHtCoi/5KuE32KNQDXqnNUDZtgpUYh+9W3a4viqiCqUQ2SJyCIzI8svidW0iNiOAZkqMVzBfFEaR91BjLg7T2tiGAOV/t0i1NDJ4x09IQOWxFMmOUanlZYIaBT2g/xqUfoiyLE8NuXqcy7n6UGSQu0nQaKPG4tqRJ3btx38SWDn0sBk55N0cKuBRQTIP6G6J3YQgHWyK8+9AaPb1h0umJjSj1XXoHxbZtT5nM6JSFrZM+9N15X1vvxsyHs1J09X+ph9SekuApIkKbnh7TmpjUNezroMJijxfHZOEkwOjKJGbXitVLQerbtAK6Fft6PVI
 L0x9y4YP
 G9vTKlaglPC+SygCCj1IQRU6fTYnvuL8raZ/mEjDu6hblB0Sp9eOxe+c2TQ8U8eNVQ4cxXsO642hn4taHNje8QDpY2QC9qUXZsOuruBZ5CZkoplQMjdVXuT7LqcH1BoswfExXJYZRewqC6LHg/YZ/FCGLDBLGXsp6e4uxPqI8c3Xte0ccG48X+1aOnjWQc6EBMR7ANumYWvqWEQovJOhSX++//0mQ+AAdEaIP4yttXCjeZxWAi+COFQ9pO48TDUaa+JgoHRiA6yymnKK6+I3uq+Ir2GQda6OnhFxY3WEfpQqDuBxfT7yN9KTEKNQnTPq3JBdOZf8NecJxH+npweW3TvPcJvCGfGVvq2q+DdvySHrMctZ+9bU/+eF5E0rmiBjk8K4MgJBqECJUEhXfC42LWA5GII22SZrNAHtW13toW3cAauSaoPP6VfnWGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/25 17:49, Alexander Krabler wrote:
> On Thu, 7 Aug 2025 14:21, Hugh Dickins wrote:
>> But another idea has just this moment occurred to me: anon THP splitting
>> is another user of migration entries.  Is it possible that kcompactd is
>> not actually the cause of Alexander's issue, but that his RT tasks have
>> (bad news! shouldn't be allowed) got anon THPs in them?
> 
> No, we don't have transparent hugepages enabled.
> (From Kconfig, this seems not even possible together with PREEMPT_RT.)
> 
> From ftrace events (first message in this thread), we know that kcompactd0
> finally wakes our realtime thread(s).
> 
> Given the information I got from here, the comment on the code [1]
> and an older commit message [2], I suspect CMA somehow influences our problem.

However, kcompactd doesn't perform CMA allocations, only compaction, in a
mode that does not include ISOLATE_UNEVICTABLE. So this is weird.

> If there is anything we should enable for better diagnosis (e.g. more ftrace events),
> we would be willing to try that out.
> 
> [1] https://elixir.bootlin.com/linux/v6.16/source/mm/compaction.c#L1136
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=e46a28790e594c0876d1a84270926abf75460f61
> 
> Thanks,
> Alexander
> 
> --
> KUKA Deutschland GmbH   Board of Directors: Michael Jürgens (Chairman), Dirk Busch, Johan Naten, Hui Zhang   Registered Office: Augsburg HRB 14914
> 
> This e-mail may contain confidential and/or privileged information. If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail. Any unauthorized copying, disclosure or distribution of contents of this e-mail is strictly forbidden.
> 
> Please consider the environment before printing this e-mail.


