Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDA8CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B28F8E002A; Wed, 15 Oct 2025 11:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862D18E0005; Wed, 15 Oct 2025 11:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7788A8E002A; Wed, 15 Oct 2025 11:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 67A078E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:07:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AA6B1A01F0
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:07:17 +0000 (UTC)
X-FDA: 84000676914.17.D33A49E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 47C48160012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:07:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pwEM8WBm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760540835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fglftwiU5EjMaoXOUvGRzaFG2qV8d5OU6QG/LMyp0c=;
	b=VskgWQd2yIysAAg+NO4YOLL6b7nh6AwKnm5KJwh1bjSkJUdTjyIZzLdHeLz0XQMiLgkKq4
	0JnZLpCCn7ev7f+cnnGLA0fK9Pp12D8zizGnNaIyusnw8pDQFFdcDBJs6wKWwniur6VRXm
	LlXgq/rcLDuBFeAYpkZNtvVgy7gOQeY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pwEM8WBm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760540835; a=rsa-sha256;
	cv=none;
	b=G2LWqn90m++H/Gr775WIpjUJalgVxCB3jfpZta51shv56qG9WLY1EFZHI3RVECUq12LnNw
	UOtHr1RUy1ZU7lyKIPODceX7Bda9hUBs8ntfEwMzk2ythdJdPrnNgrBOJFbJOp18ClwIaq
	6v2zSZf/AQbKtGPlfkyWiyjKkU7nFk8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F10434547D;
	Wed, 15 Oct 2025 15:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F6EC4CEFB;
	Wed, 15 Oct 2025 15:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760540833;
	bh=5hXx2RD+bmNSeJIwcoPLQR4SB2ipmLncmu2KyKpJLh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwEM8WBmmycAcispyGwA3tgWT/07O+zjujTHq8qpSkO+jGrMofRhMHO7uGyPpscFS
	 HYKXJ61AFvd5hEVDut13Z5rHo0Sja60zeOzpADSijfkX3NQblD+x3c/lI9nY9MbZXy
	 70LFdB+1V9VAqOKh/b2vcsgwO2BsB1ADtbWDeW1cSCEEdPnzrQgXrpf5fY0Y3cLmRY
	 wMGVfooAiC94uiJPrkzLCpOMbYC0LbMqOCz9UuK93XbtP7wXZVe8kdYWcqFxPpwlFD
	 objtyTYuIAa7H8C58ksHGWBeFMrebIJrJmv6CDMN8CBcRk7WKer0ELHe1kRihoUSRb
	 9PhHQYIuivyBQ==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon/core: fix potential memory leak by cleaning ops_filter in damon_destroy_scheme
Date: Wed, 15 Oct 2025 08:07:00 -0700
Message-ID: <20251015150701.68087-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <87jz0wg9uw.fsf@>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 47C48160012
X-Rspamd-Server: rspam03
X-Stat-Signature: bucapju61gq9ocqdsu4nmdhnu7p9by58
X-HE-Tag: 1760540835-518817
X-HE-Meta: U2FsdGVkX19gsJdZYKVSfJgluN7pAsyZKO6bj2lYKt5Diz3IgWA2B3Mt4G5PQr9NZuM4DQ4PIN/PPC3gk4GJrpyiOX6j7ira0lbnJUVox0rKBIkf4tukw2HPd6Lo2fnDsleXyZPOl7jTYuoHUGRMaNHtKWDQUCw4T0FIFjx5b79teMdZ5rl+hCnlSzYjYZAEsPK5+GeIzm68SbeMpbeq6PrWgY+gu/LpIf/dNK387n2nqPofFN9EeH6M72PrIX/PM+gNxixB86qqiFa56S+8U68+jcqpL3rVX1pjLwvxeI18rPlVmW1c5V1tep8a5AkLlL0W+vakFpGfkr2y0+F5H2dfofJCtBs+23wWVJfD01tSBD+6YJKrenxH5eqxGRe8trnmVSFDRVKlTKfqHkvgAC6PW1mm1m54mvS3U0D/KfsEgCBuOqZoZmAk8HWh0biHWoVaOqmzX5/FgMh2sMty6XoOUMsOS2jeJVMSz/LT1+EJqFrW25Ev1l6//JCtL4Yebw3Q2nRp7MY8Q607h/JvA30McgqkxPuBeFmgVcV1WbmSwt/7BiYLq/3GscvFA5MMqRZwx/1Iv0bCcxFkvs2pKdVuwmv2/piFsutEtF+ziHPb2zYUNhxtQ6MVEAyYfoajdfIQMtzVeoyhNu2eQo8JsQrREHGyxBiWwc8dzHpXSBozbLuRFc6l1iiAOkdHoWec/wY+bOXtMke/EEp/LJmRUh8OLIt8WW1keZr8K1mQjA7DHyq/F+UbOkogprw1jtKqOIHsN/P/zzUAU2nshyQ5D+EtU3bQGLNtwCUn1JPxzoVeFG0U0LtiI9AOqkr007qm5/7xvcPS4E+T05v6FmCj+svvXessyYktYqIQtzNwoId/K83YI4drrmTxUAaAI120uF6Nj3P1vZTFPuBj2zLGsEAY5DjA3F1HF1J/DkBHPb6RV0WxF9LnyemTT+rDL2NFh1G0QtgieYC8vT/Yei3
 34sujPrQ
 7GiBXijJExhD8fkE/BQUmXHX6wt727FTFoA/DA13cZ8+c6ME1qmCoZ6jWuJoXn9GMshcInLRzKKpgkXYFx/QFTULiD2wlwRvxWn7cGO4qC12pTIYsFsI2KjOd7Y4Qj6e9dNt5c0DvjG+9+lN/pm3NKQSh2jkgEXI7oNTvFn+1gqrHFLBiYFZFiX9hcHZykOk2yi8hYWE6UVRJteGYdN0bgpIU4GRl2ldDsmn/nRENhUFHERm2vcg4ziqM4cQOnTj5JGOU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Oct 2025 10:46:47 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Hi SJ,
> 
> On Tue, Oct 14 2025 at 11:25:38 AM -0700, SeongJae Park wrote:
> 
> > On Tue, 14 Oct 2025 16:42:25 +0800 Enze Li <lienze@kylinos.cn> wrote:
> >
> >> Currently, damon_destroy_scheme() only cleans up the filter list but
> >> leaves ops_filter untouched, which could lead to memory leaks when
> >> a scheme is destroyed.
> >> 
> >> This patch ensures both filter and ops_filter are properly freed in
> >> damon_destroy_scheme(), preventing potential memory leaks.
> >
> > Thank you for fixing this!
> >
> > FYI the leak is not only potential but can easily be reproduced using the ops
> > damos filters.  For example, I was able to reproduce it using DAMON user-space
> > tool (damo), like below.
> >
> >     $ sudo ./damo start
> >     $ sudo ./damo report access --snapshot_damos_filter allow anon
> >
> > After the above steps I confirmed it leaks the memory using kmemleak.
> 
> Thank you for the review.
> 
> Considering that similar memory leak issues might occur elsewhere in the
> future, should we consider exploring the introduction of Rust for
> certain modules as a proactive measure?
> 
> My search through the mailing list archives didn't reveal similar
> discussions, though I might have missed them.

I also don't remember discussing Rust for DAMON on the mailing list.  You must
be right, or I also missed some :)

> Would you be open to
> sharing your insights on this matter?

In short, I agree adopting Rust for DAMON could be helpful.  As you mentioned,
rewriting certain buggy DAMON modules such as DAMON sysfs interface in Rust
could be a good idea.  There was also a private discussion about writing DAMON
user-space tool or library in Rust.  I think that could also be an interesting
idea.  So I'd say I'm open to Rust adoption on DAMON, not only in kernel space
but also in user-space.

Nonetheless, I know nothing about Rust, and having limited resource.  I
actually wanted to learn Rust and start writing a sample DAMON module in Rust.
I got the idea from the last year LPC, but still made no progress at all.  So
I'm open to Rust adoption in long term, but cannot guarantee something in short
term for now.

The user-space Rust adoption could be done regardless of my help, though.  That
is, someone could develop and maintain a new user-space tool or library for
DAMON with Rust, independent of 'damo'.  My poor knowledge about Rush shouldn't
be a blocker for such projects.


Thanks,
SJ

[...]

