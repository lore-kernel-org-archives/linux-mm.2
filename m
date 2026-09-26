Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28D6EC98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 06:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B3736B0088; Sat, 26 Sep 2026 02:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264A46B0092; Sat, 26 Sep 2026 02:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154966B0093; Sat, 26 Sep 2026 02:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6DE86B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:14:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8276E407DE
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:14:18 +0000 (UTC)
X-FDA: 85254898596.10.0851D62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C3E76100002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:14:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=R4SsfPN+;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790403256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLKST/A5bmY6pU1AodPlaWRwJ8bQxj7G+3mVIWdaYDE=;
	b=4bkV/TY0jM1pw9totOV0St51ksML9dDdKyhG+RAouAt482z1IzFtM49iX8XqauNImh419L
	8J4EVn4HKu4SQRm4rBUxa0u4myvkLCGHIvyXkuKOXq08gTn6PDE869309TKqSqm9jsa5h6
	52d5WZRuUmH89d7n+86W3ncNYuJa3/s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=R4SsfPN+;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790403256;
	b=np1AQGtogIlnrnALUgFw8VicjEgniyvr9hrOtnoj6qdzmSrA6LRWQKcF9LME/vZjljHfe8
	RgQGurDvKLKdM10I21EM86+B7StysYYvLdkGf49d9Z7AAUVpgddHJVR1DBGCerz0XiI9ji
	xFLLo3fA7mJRoP9jlW4A8ym27GfEK90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8BDF40145;
	Sat, 26 Sep 2026 06:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8248D1F000FF;
	Sat, 26 Sep 2026 06:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790403255;
	bh=NLKST/A5bmY6pU1AodPlaWRwJ8bQxj7G+3mVIWdaYDE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=R4SsfPN+BOCGJIw/tZn3wJe12obiZIpQBmdLhQNBcmKZIyyLSPdvsEcTxQpQBzb/N
	 gD5sIxbPDK5gSOwncscqDKnj0sfN07vd5/tswOkbmjlnWgV+IgCFXuO7XWANCfwQQt
	 pcaIbBxb2UQ+EfF8wohK5HjLftIlIiXSUy1o1SrQ=
Date: Fri, 25 Sep 2026 23:14:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Meijing Zhao <zhaomeijing100@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Meijing Zhao
 <zhaomeijing@lixiang.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Wandun Chen <chenwandun@lixiang.com>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mm: trace: decode architecture-specific VMA
 flags
Message-Id: <20260925231415.3d97401fe7746d82c6182060@linux-foundation.org>
In-Reply-To: <cover.1788330432.git.zhaomeijing@lixiang.com>
References: <cover.1788330432.git.zhaomeijing@lixiang.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C3E76100002
X-Rspam-User: 
X-Stat-Signature: ubighzywomztdh1dqq8pkww4axdzzkcu
X-HE-Tag: 1790403256-74416
X-HE-Meta: U2FsdGVkX19pbrcd2UIKu0cPC6HRypScc4tlUqVkuLVywSxwqyHh6S08qTcz6190xMLnYepy8Bu9IG2WVzM+ByyuYPFs1R9koek7ddZOi+Q3H8AUTulYrb7FmIFRXIH8KiEqbGIMSwPOgpBrPKH+7s0qnj8PAYZi7D9wzKZegvxO094IHJlOCwtLCDjyXaKOKg2JwACQTQNtmBvnSCz4Ou6bk40vWloQJTe7xcSnDwQ6DRi78/wc0MVh0sWFwgmjSGJ0T4DlqNGco8ZxiCdxuw4lk4wdS3agwGcFJoMOId8UXE3YQB8/hp7ZYax8QqZAODJHeCuGercR2FgHaEVYoN5UBDTq9Y+k1v9+FrYH9p+lXEIt9iYMKvlaG3yS1LeJkQdhvsxL5tEynfqlFgNBFSA1h6eAT6vR5/uWqLFVq7G258Pq1eJZIhV/Uf2eS4CElmw92QyWEtaVanoVJv4cO/NQJ6wk5jzIVfEbRRPJM/Xft5W9BYE/BfBz9HpmtJnzFjl5bEGtQLdwpuMRIl7UXCkfrdHMuGvniXkL8GrGJlNUreRuEFbU7BA4qG0mMXxaehm5vpLjZZPKZ9IvIW+cc6OjJgaFAchjpBHZp4nphLZiRRZFM5hLHuu3au5bdot2xb1tsctlMQ5YDwcy+b3hz0g2KjG1/RhtPieIyO+TStZHM7qG11HmMqxKhR1Nv8jzNRF5IBrBO/IbISB1QpdrmXVQJfr8ydB02djftTCrRYQJBd/ebroyc5394qpkjyE+uIq7aU2sFfpN8VCH9xVnm/OGVv3AmGkDCtmXrkLUmpcOaY3EQFrsjp/43US7UnqRe06++AJPO+M+0OCsGM4WfW32k3b+e9IFiB6z1qBW5nRHaKqk03YasUchd4cAdH9vSJEyJ7t+5+rlg9081BbiqcGkDn5QqV0yf4x6AoeJ5H7b20yL+MEQcbCNeKaE4+iSclJrbK5catoefxnLk64
 UKPn6ofC
 5U21I+sE7+dF7WIGHcyIJfOrenazoxg+nnPosEqA6zcgZM0VM2vtnmJf4m8PAtl2G0T1n7u4H/ZSxXmLHrmyZZHkLR7QULSjHC1jz28L1vp6FSPCYXPp+T0WEhwFRER4BlduTubr7pVTOl7Yp+50ufBEEtupv6+siYfw6rECxTzdm8b8CtjrhNHxJmQz7wAe8G/o9wJ9YPvINqFQ36f8Vzz47vO9WSbwhCkXOjuMpgN/UUQHzQVCVJTsA+NyW/Sn2T2E27Zhdp2yFV0+Jt6HvbfdAZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 14:45:07 +0800 Meijing Zhao <zhaomeijing100@gmail.com> wrote:

> show_vma_flags(), which is used by VMA tracepoints and %pGv, names
> generic VM_* bits but does not fully decode architecture-specific flag
> positions.  As a result, trace output and VMA dumps can show a generic
> "arch_1" name or a raw hexadecimal value instead of the meaning assigned
> by the target architecture.
> 
> This series adds symbolic names for the arm64 and sparc64 meanings of
> VM_ARCH_1, arm64 MTE flags, user shadow stack flags, and protection-key
> encoding bits under their corresponding configuration guards.

We're presently not showing any review of this series, if someone is up
for it.

Thanks.

