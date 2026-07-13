Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F48C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96266B008C; Mon, 13 Jul 2026 08:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46616B0092; Mon, 13 Jul 2026 08:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CB06B0093; Mon, 13 Jul 2026 08:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8866C6B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:31:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2039714013E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:31:44 +0000 (UTC)
X-FDA: 84983689728.16.35888AC
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 716C8C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:31:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RAZ3e/aw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783945902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUhcYPLrB310Teap/CNxFNyqUL3uVFa5TFThGRISyng=;
	b=c69A44jJCUYPTj5MOW8Vx9jxr7mQSZbR2/5fBDwLF3CCuby+CvPqF+rLeCwvbg+U39qF1G
	MV+/Yp65WEW3EiIw6GquHfrV7guwctNcc6iJDeKs0+R6tmfwiQv920rZtFqlJtBwTLghQW
	AmpdeFTxf/dwgK0uFs0QJ8xuvr8ni8Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RAZ3e/aw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783945902;
	b=2ZvozUYJAyuX9XzGWboxGpF5Dy/acjHrrjHwaKmpeYorIGtbHrYtPyO9V1xoVxN4uVYKqu
	7ucxy7S2ybxkGGlYdLR9cgEZgmsMPqgSRp/u6tq4RtTl+B8U6IjKLtmJMadGDrk04h/zAU
	EyHqtFV4wh5VTaXnwlP27ZkrbdUlpNY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783945901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUhcYPLrB310Teap/CNxFNyqUL3uVFa5TFThGRISyng=;
	b=RAZ3e/awoc1DjulIHHhH07ar3DMKCCaS7LV0be+jSRMj5t+uF6xC6dtAJMWahRHQnOVrk8
	fyzmpN6fbyGDtjsJVasRe5vXWFqrJU4OPnn5ourPhzqVF052/UBQPgAMKybKNAt91LIPz5
	kH0H3rRd3yUrb2Oxn5OgBHT3hsmou5Y=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: memcontrol: drop unused cpu argument from
 flush_nmi_stats
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
Date: Mon, 13 Jul 2026 20:31:08 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <89877E8B-F3FB-439B-8683-EFA191D0286F@linux.dev>
References: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 716C8C0002
X-Stat-Signature: ujwz4omg3ts4fi714gym7k65h8hfjifd
X-Rspam-User: 
X-HE-Tag: 1783945902-257812
X-HE-Meta: U2FsdGVkX19DyYeAPfpIa3K4fIWCBPaIg6ztUyUVwU8ETGGfm6eNbNnsv8dQ7FP9AEXmxFcU1dXgDaiN3Dzf51fyAYo1jxKTDCo99oE0+2kMPIqNY+Q1Q4LpPpQ98ZBDC/5RNKfUzvTP22pLMg+cY/MNShIe81H/BMG9HMFI4GRje7XTeJQbnb2Sb7bisOW4LPNEG5xXhzfQS6sT17YFZUG9/wKRba8oubU8c1qwbC5AC/TlOmHYLH9TcSGavgv4pPtNGzmPrQib/Si1EfG2yIrCdI6yfyPVdlJwdpgA/uPREWXCF/OKv6dd/r2jXbky5yFVhhWsputXS4KKvyhIMdqSkZIM4TXlRB48SpdV6c2rixrmsQIspts4UDqYYRsAtFgfLP3LT7xE/6AGlaZMR4WlrFFGlt/Br1qtRzJaP53qJZv1ZLlVskCWTTD/TQ1+GQbt5i8lsy20JgfRpcEeI9QPR2fHtQCjRd8YvvzdPpmK0hNEG1wuKJJE5KIZkzsUAI3Nlxo8R3jOHKMiWVsxrEUfUgSUrmBLNQc48fvfGyE5eGC8PbbkqRk1f6tntw8i1UUuiHScHB8cV79Y3ne+irY9AaUN4bIhCSGf3rLII5aWIIzOVMlVprI9QEcMGvxdQmXemb5X0pVeDE0ANo2IKYh7iVWhPKfYvBEbHfgTz+wGOkAIkFAe2sgpBs7+PE5QlTtHs/TnD78Be6U4R2ezCk9vggnMmp4/xcCcFdBhlYOmlN+dOSZh3fbjVAZAPm5DMd4CmT1ZTeCo+XBNx+NBwcquyeMZC5l6KN9hg5pn60u3pVj+HuB042JlniPOwgOzNBsTtskUcIMS0xNeHqQWbH/mAGcj+Z2MkQeUbnNwwxP+R/OocYk8d+C2vcMxdzot7cS83Tvvdj3iI85pU7stk78wk6QxY8L+sXHeErPBqLliO/qdbL8UGCkxpfw97cKuZzCUgxC0Y3F+SHrDw7A
 y6lEJYV8
 18jYkW/NgqZuu8r/tXxUTnxLXGsR5mxXQnX1LMEyOlrrFefIuDk4iH09PPhqG+8aZuwtVB40hMz/U4OiNcQaTdGgkf13DQpl/K+Dbr5Znij8P8RfhpYt5R66eiFioAExCcAOEdlZWrVjyy2WPABYm1jI09Ac7EqSQWjqVsGzCQL0MNlxStygZpXMelJxKrp///TMJbL3sLUq7cD1wkKwJFgBmZXR3RRngJCuFDwkfNEciNIc4gzHEI0KRO5xs3Xed/y3aF/fvASYcC3s0t/D9r44l71eGmD5/R9vI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 13, 2026, at 17:00, Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() does not use its cpu argument. Remove it from the
> function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub. The
> caller still uses cpu for the subsequent per-CPU rstat flush.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



