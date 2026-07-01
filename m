Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A6D4C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BBBD6B00A6; Wed,  1 Jul 2026 01:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56C146B00AF; Wed,  1 Jul 2026 01:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4838F6B00B0; Wed,  1 Jul 2026 01:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3966B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:20:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90F2AA020C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:20:27 +0000 (UTC)
X-FDA: 84939057294.13.51EA979
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 906601A0006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:20:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=toX5mJSD;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782883225;
	b=d0Na4qrZ/sBZTZAqSI833cQ7KVimNI8svVp4cUBjUW9Q2AplQwUFKqnUy94aMZ/bUQmNVX
	+ZwoNJK7FRdgB43n7zSAsXC4U5mgWh353tK6TZdvrHu/85Z8RpRCwP5j7eV3E2lJvFHvwu
	z2rM0cWPM1ynfkvOaJqyZvn0cm3vwcY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782883225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiRROp2Ck0Qkb07LLqpzBl/VkKQ724vUCdYfSeyPwHs=;
	b=Q11JwDOKlryLFcLu2ZWnPl8btjHxNxFKH9d2ke/fqaex8GHbZuXIeO1TF3/hK0ajFHyhzU
	wZlv86bLXs5Qgi/9ItTwjoDWqV6Q+/O/tpzvamEiTn+UAmua7It7JdLtD1Ww76EHRzlHew
	TypwFhEmD1F63chW4AUsiKwXy+CAAPs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=toX5mJSD;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5895E6001D;
	Wed,  1 Jul 2026 05:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9871F000E9;
	Wed,  1 Jul 2026 05:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782883224;
	bh=BiRROp2Ck0Qkb07LLqpzBl/VkKQ724vUCdYfSeyPwHs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=toX5mJSDYiUmElynFgLq3f4b9XllfqQFbjfK23hHhukTmMF9ik0uooWJKpqXTrXnG
	 Zg72KCViAfcmbtkfoRbTpkJBI0ETtVodN/1WL5MtLKkaMbRhSdgXeeQYkBgstdiOKv
	 xWXccyv1k9W19S6znNmndr0pLOwT/wGVXjAUBBqo=
Date: Tue, 30 Jun 2026 22:20:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, keith.lucas@oracle.com,
 kevin.brodsky@arm.com, maddy@linux.ibm.com, usama.anjum@collabora.com,
 yury.khrustalev@arm.com, jhubbard@nvidia.com, joey.gouly@arm.com,
 zwisler@google.com, hongfu.li@linux.dev
Subject: Re: [PATCH v8 0/5] selftests/mm: refactor pkey helpers and fix mmap
 error handling
Message-Id: <20260630222022.60d0951b90af8857971ad10c@linux-foundation.org>
In-Reply-To: <20260630073235.3802271-1-lihongfu@kylinos.cn>
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 906601A0006
X-Rspam-User: 
X-Stat-Signature: jqh9judn6f65a6gm71a9r4c5zmoygmdt
X-HE-Tag: 1782883225-91156
X-HE-Meta: U2FsdGVkX18gDCcVBuzDBqhOGMncAgfkvBo/mUv8TsjiOPyMAdWg2rQOvS1kLeYhW3m78orklUwom/jkI4WdxHcLSwpTQ6tIVJ+tqJVBuwGm67Q2otR14Nf/YgGscz6PLMNPhzGqIcBVQxkVayF5LLlW3gWlVFdZRCc5PcWXq1aND7BjyBz0Z5Cm9VGmSIT8rX4V+7+koYEmRVYA9FHYW4E3a8vyYZSVICW35eYEwIPBprwPhvV9DyAgYbAxNmmVf7Km9WMkLYrqxhL4PIUxfWIxo7ty+NWp/GKDVdOiK7t0tUNTulLGZ0OJB+X1dfeQmO4Xs4uU9f0ur1dkebBiDwiJiTI/WMTKShRoTXyx68o+esDSZa+lqdM1dR2EOJPKdLExUpdpMSdvFPkQXmAqOim9oUJQ7VO6J56EnjE8/XoF66qxQdk6iZiF1+GO/zBJL44y5F9EucHCBPE85hLiNJ8mP2Jv4BrtV4wKP7ldVJQgImOJBQM3O2K+IoYkkG8Hb2kx4a5GUpV3pQsMXfJbAPHc6S7H8SEEZ+/qldSkMCmtwi+zJcGPCugnwfH31g2Tb+Vpkh9XaACuw+yCRpnbM9bcXleZ8Hk0p6cXQz8SZcONaGw88rnyWNF8tscyquE9mgJN2AuX4Z/6BjMMuDsFFM2l96R0N960Z+Se/fzh9ulu/xTczYpm/OZtBwmS7WYwB3lCNP9FtZV5MuCzhvTpoTemmFDqKOLVeC2dN8QxeY8tEgxe2CRpL4gm9GHCDt1cD+R/JEOebh5fuUbF43NKUqHJp+dhVHhnlsc56QEgIha1y0Wk92qxjsz6AUoQ5GLPBP0SvYyvMbwCjqmim1d4X8kDGF+xLKBe2IIBWRC/+hFuEP99NoyKSXakTa+H4Oc5VYHmi7GYACGUczxyMHM3VPLSpz0eueCAlcR4VYABXtoVuSDInC8rrGFhK96bvSVd+bmA6jhwk1ukljW4wGR
 RXjVjPj3
 NTXR75B3zIO9bDYDImzmK/6T4qsgs7K9qbFWeeIAvThpb4t6gXokibyJoZeZXukqL2FZ2mr3DYIrEHaHLF/Fvscjr4ZblZrVUGl8TfYaMpC8qFJozXrI4MZWW9WUISl2cJLNyts9kQmkWYAin/QhjqAOLbU3ga7f9LijLKoTrbGJRdGZKaCYFT1yghG9NbRF1EZgJtOJFObb/i+r2PrMNKKFvYPjcOamUgHInWERkCAY03oKAZfuYGI/VDemzFadHZLtREplxDxlpu8mU8sSyP7MFfo7YyzntEW60t9fmwpIrdRAmgXnc7Igvtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 15:32:30 +0800 Hongfu Li <lihongfu@kylinos.cn> wrote:

> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and 
> per-test tracing for consistent diagnostics, and add missing mmap() return 
> checks with MAP_FAILED used throughout for readability and consistency.
> 

Thanks, I'll get this into mm.git for testing.

AI review read the pthread_create() manpage and didn't like
pkey_assert().  Please take a look?

	https://sashiko.dev/#/patchset/20260630073235.3802271-1-lihongfu@kylinos.cn

> v8:
> - No code changes (relative to v7).
> - Updated Cc list: added developers identified via `git blame` and
>   `git log` on tools/testing/selftests/mm/pkey*

Kevin, if you have the time, please.

