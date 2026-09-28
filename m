Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42AC6C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 02:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18FC96B0088; Sun, 27 Sep 2026 22:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A1F6B008A; Sun, 27 Sep 2026 22:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F233B6B008C; Sun, 27 Sep 2026 22:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD8646B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:30:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56362A0B27
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:30:49 +0000 (UTC)
X-FDA: 85261593018.18.BF79994
Received: from mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf02.hostedemail.com (Postfix) with ESMTP id DF3B180008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:30:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AWIz2X3A;
	spf=pass (imf02.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790562646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJ1G7XRTXKhL/y14SSAQr5z2lhftlnrM/l7NA1vY8wc=;
	b=x09kb19yetn0QmDwAqf8V6Bo2znAxGUmvBB/zSiJ2toZoO64XRDVpwrWp4FHFETrmscHXq
	rZHSvTVMHH/ydcVCxC9iLSX9lLpj16F27zsSpyFtWa+AUTFde3ZTSLVcFKxjIG8wn1C7AP
	K7F1gUDEkOq6CYIMoSYqZh52iZC3wE4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AWIz2X3A;
	spf=pass (imf02.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790562646;
	b=CMpAvVcP3SlZvYzLMVOV4WqKQ8LAf3Iacwah3EphzxFS8k9bY7klUJjhu8GSeXF3VSBJa5
	0clDVp/TrAfK63lRSnlZ2B6KGhY+imAWYUh2RaIMTcB/5TEvML1F514j4pFS8LG72n9AV6
	lwgSNdD0EeNFGlrsI5FO18i0AGUYjgw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4+s99KWizSzbFmjJiglWm5XJ4fIhkEZlwghACv5Q8bE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790562643; v=1; x=1791167443;
 b=AWIz2X3AD/9gHxc0RebVCQOjyzIJg4Tu8t3j+fGfm1JDcLbi7gHHdmjzuMU7GtXyRyTtWh36
 lyQ0jMaAqm0OSUSiwoRibh1ovQQ8Zeli+9WGADjuzIICsdS40yAmTcrBtLslPbM7hZqQrvFlnhf
 ZbC8fqobqFAXKp1cRqjlobrM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4c0fd7c181865d0e;
	Mon, 28 Sep 2026 02:30:29 +0000
X-Mizu-Trace-ID: 4c0fd7c181865d0e
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org
Cc: chenhuacai@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org,
	ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	liukexin@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v5 0/5] LoongArch: add KHO support and selftests
Date: Mon, 28 Sep 2026 10:30:10 +0800
Message-ID: <20260928023010.3018-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ap3KYSXQJfC0iysw@kernel.org>
References: <ap3KYSXQJfC0iysw@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF3B180008
X-Rspam-User: 
X-Stat-Signature: g7reypw633nmnurhou9zpmnpgeusdsj8
X-HE-Tag: 1790562645-278571
X-HE-Meta: U2FsdGVkX1+iNF7c/nxnM5crxMauVnuetq9+7qOJ32YZeewkCGuD9RMf6bGp0RW1Pw6BRqTSE2H/9wXUxA0dx9pweAJF7BrOYq+nIrjqzMk5cYF9TnaYOEy6qhUgfxg28G/EjqUwJrXIOzKuKt0uKYiV5f5s88kjVko75BN7E/9fOKcjCY9lGR8u+iIz7FgSJGdYx43ANddBcxUFAOpnajIWQLyytSXnR08/3JK25r2piwc4qm9lcUSinU5u6P8EbVMqngFwhvlp1fYygvCwE6EcO8HQDQmvbjBB9RvMRYXaPRHfke/t51l9gCCPk5uYXV/kW5VgDQlJDTilofNXuKk9YHXjtOPX+xGTZIzI6/nRjYXljatPLUvHDw3mZQdc9gxE/RZ17LH3wYUAww4heiEDug/FdSLzFpvL1Tfr7mcYUAl4CYwZj85UcZ+UNidASZQ8wp+Ayy3W3Gt1XsYaGZqTBhP99Ib0OfUeRwAFjZJLnTzkAwrxycmfTrvKkbPn6L6aH98pk7Xin9zHSGlgxekcal7c7Xh9hQhUl+VUESnW/JzKRlnGg8bffr3+Cf+Qh4jal1iZEm0VyRIfam7o5byFGTZsj9tmU2qJAzrRrEaaNsWXgsJTN+F7Emczw1PHewT1WbpBaXfa4ZImqcUjQoeHYWDX/xMqPhjQJ7Yc7uI+vocfDVN5i6NDfzG7D84109GhLcMynLXugxtPmG+Uvm6tN/t+TaBCF8XDYljPe7SNkoU2Ck6vH4kp+OjOP3L0rgXy/x70nFmDjF5K6tiLfBzySX2QcT7KdNgHnFMjuqdzuIjtHmsl+Gtu14SxCnCxIWnhzRWwOk4/ChK3ak8iyEqEPTozMZSni87tAj9syGOfOHdea/l+IQ7ZosKq2tg8pD3iLyfyTQSluGDJ+ZrsyFBfWDta7mVWoB6TrozbNnam1zggR4ey/jYnCZHP7D8wjHuFyhMKD5zOrbXPX4Q
 ato+7lwx
 sZLDPAK4SkdEhzGPi6WljKKdC/jhRG8TIIjbvgFhiwpijsfQRJZArwwi0M8y1uDTzQJtOELqJkeJUVCg1kvpLuRS+gcewo1vlI81qLckMCBeL1p57iycfeggrDxSJKa6eh61M1FqZYNPgBKY8hTLHDP599GZjBTofH7N+8pdQ8gYgJ8zRN+kZKu2iq9pMhA1xsp1qtR69HGhb3Aq9+/nud8O4O/DqTiumIIKaikCVRJjn5ZAyk3AWvR6luudkLsTiXivEb1mc4WIw5Okx4jyedZrw6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Sun, Sep 06, 2026 at 11:17:37PM +0300, Mike Rapoport wrote:
> > EFI KHO channel:
>
> I can't say I like "transport" and "channel" terminology. We don't send
> anything anywhere.

Agreed. It is just a table that the next kernel reads. v6 calls it the
KHO EFI configuration table everywhere, and "transport" and "channel"
are gone from the code, the commit messages and the cover letter.

[...]

> The text here and in the patches changelog reads reads as LLM-generated
> text. First, it's quite blind and unreadable with wall-to-wall text.
> Second, LLMs tend to describe what they did in the context of a session,
> but since we apply the cover letter to the liveupdate tree, the description
> here should *only* describe why the changes are required and how they are
> implemented. The history belongs to changes since vN-1 section.
>
> And last, but not least, please add LLM attribution as per
>
> https://docs.kernel.org/process/coding-assistants.html#attribution

You are right, and I am sorry. I used an LLM to help write this series.
I meant to check every line word by word myself before sending, but I
made a mistake and sent v5 to the list before doing that check.

For v6:

  - The cover letter only explains why LoongArch needs this and how it
    works. Everything about earlier versions moves to "Changes since v5".
  - I am rewriting the cover letter and commit messages by hand, in
    short paragraphs, and checking every line myself before sending.
  - Every patch carries the Assisted-by tag if we used LLM.

Thanks,
George

