Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73CDAC5DF77
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812FD6B00EF; Mon, 17 Aug 2026 12:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA2A6B00F1; Mon, 17 Aug 2026 12:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726CB6B00F2; Mon, 17 Aug 2026 12:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50D946B00EF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:11:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CED3FA335F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:11:42 +0000 (UTC)
X-FDA: 85111252044.18.FA16303
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	by imf29.hostedemail.com (Postfix) with ESMTP id DED1112000B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:11:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SCS2Ilz/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sn5U+eyyJYe4LVjAI7pwx2S6EHhQG2aQtvy6HJ283tM=;
	b=WQFDsUSb5T8hUESnA3I6u/47qJzUdt8Yl8LaV92DUZhsnS6k4AKvDjFHH+erFDC4ItFIRC
	pv2dPybDGDqjd2NhhKGyyAFujGlUmYsui3qKZb1l0YdZ1nnfnbnJHZqp87Y3JRWxgGjJnL
	l1eP2TCLkL8ZcV2Z/jXU2rXn8biolpk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="SCS2Ilz/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983101;
	b=PswzfC8Ri8YpFd45ncduU4Fw/w5/O2RU9FX0HRvQaUfk9k7aS92tkZtoJ0UjDEhimladAU
	iAC8j8WKdHOIWZhGE9CYrVlfu4N6RSOeJz3XwjplWlfFMSrSBYtzIj02i0rj4ZqjDwY2gU
	Af18M8ZPgw90w9XmOnwlBQkzhBK1bxY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nJBhheWJDTvysjCU7dK7qU5OWfmrA02NtKHvbmLvCZU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786983099; v=1; x=1787587899;
 b=SCS2Ilz/ELUk1LkJ+3hzOJb3wH4n7pWX9AQzeF+fllFAku+J5Q7r6AfIVlAdCcuHexeDGZDn
 9bxuvljSe38/A22OiRXPUIb+Y0Fcdq0AXcrnJ02d9kdTNZSFTtrIUphUh/H5CLvQ26MfepSOtKA
 orih1CfY1x4QcH5HizsXkt8E=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:16::)
	by smtp.migadu.com with ESMTPS id 266e50a251363352;
	Mon, 17 Aug 2026 16:11:39 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 09:11:38 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Song Hu <husong@kylinos.cn>
Cc: Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, 
	audra@redhat.com, bingfangguo@tencent.com, cgroups@vger.kernel.org, 
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	zhuhui@kylinos.cn
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoMyk4JvnSPeVz8b@linux.dev>
References: <aoLGzZHS8kj53-ey@tiehlicka>
 <20260817131221.44761-1-husong@kylinos.cn>
 <aoMMr6kEX7pW1dSF@tiehlicka>
 <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>
X-Rspamd-Queue-Id: DED1112000B
X-Stat-Signature: 6wpdim1din1g7tobotst13u4uuitq85h
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786983100-521219
X-HE-Meta: U2FsdGVkX19biW/gFxaGLt2N887WindBrSl4doDQma1KoGpu4vce4ILorhw20fry86GXL81PIXWk1OhL/f16sCKhEJ9AzkHkVMDTtTfvCDSqw/SSxFym3zlrDkDhk279sOKKF71gE9b9GKRaZAG1yVjpmWz0l2SMJTrT1FiV5JKBJjksuZk8gRNu4KBPTVrkgYqCuzz4tQBRozLnKBoDvOGx8REiTENY65pxHotLWB9jZBX7ZqOvurbpO9aePK4QbjOfSmZ093HmXSC/1LVFqFRwuFg7dhvDNADNq07BU5vQIMytZMjm/H3/ElvbWCP9da567ETguhQlDX+c2C+S+znZ5zFubchoHhXlU7HXT7SLPmplSd1JlXg0mg5bS1ZpbevQjeFoUV2DJeRsI+obZqSlf+oSDS0+GBci+yP4FK4hfXMn0fzwM/UkjwSNU9645m8vb5yNGBsex/ooIywbC56vYNTF5FDefLEMqDfpQm6RrN2y0ZAMCHj+kh46iB08dp14qU+c+WvAzYASUluI84+iJsNyZi2oXlUDKcZR98PcwuWC+kAIlhcs3Y7lRdKtDLnCAmTdvyulmFsPS1TP9n6Nos/JZy9Q4NDvGxCOgFrIPQk9E8a4OlrMbehrq+ToNHGskKUXEiG2fIAP+qdtXFDo3N3GuFuNYRxKXxJr9H24VDa/syUdflgLR+iIOpS/ubd2Fzs6hbhZjgQT06ADBrZML4ZpICurSG1vNwnnT5fm0D+1V8lqFwfBzFqAGzxSX9MRdconKNeJ7Aelw1dFdyBFqznygzSJJqV/ZcG2a7yop9pCRtWmWs4Eu6Ll1+G/+ipdAFCg1PuIIaYlZ3c1QJ4VQT8ddnBW+88/tup673zC7V9iCi9M99n/zUJ9QYe/+LXW3v346a947TDXRDgmlV0V7I65Nu3ET3GJyYbIhPDDBMXHncb8y2ZKizXKrI2wbwUdP8bMnRTeqZEwRTx
 /43ks7VY
 uyz2OMIaHZogLQiirgiVt5y+zlpshVKFqf+TcXSUdZCPT6MIQMq2WZiFjlfmb3k7CM9g4HWGUqT927qUrx7cxC2gNmkOaQr2+qMzAjEFO0uTNvwmFZ+vdfd6JeYPshDWBHe3R7bMEI0uN50lHjopwe2WZz5aMVYqmm7A8K6ZPqBmbpTNptrD9Il9TFX6RVaZa44AoJVqVjqPMpk1TlDDpfnpQpfO5+D3PDFITU/SkEhRrFNlXmVkhjsfkC7Qwv7C1piFRk4tJMWxBlmL6wDQ+FHNhV2mpZTul25ZIxZI5dm8WW/ReLnxWLcyqbErhBJ9oPcVaU/oNPQlCEZW2UkC5WLoaZFy9V9/Onaoq0obpcBpXA1RqJwSr2FWcv/2tiWaF8KHkY6JTUnWEzQnUyXKlYxKBaZmC3fhhlkdV67tTUR3hGXM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 09:58:39PM +0800, Song Hu wrote:
> Hi,Michal
> 
> 在 2026/8/17 21:29, Michal Hocko 写道:
> > On Mon 17-08-26 21:12:21, Song Hu wrote:
> >> On Mon 17-08-26, Michal Hocko wrote:
> >>> Is there any specific reason why the memcg stays in the cache slot
> >>> without any pages?
> >>
> >> consume_stock() doesn't release the slot when nr_pages hits zero.  It
> >> is kept for the next charge of the same task and only gets displaced
> >> by a charge under a different memcg or by CPU hotplug.  The problem is
> >> that the offlining drain skips empty slots, so the css reference they
> >> hold is never dropped unless something unrelated displaces them.
> > 
> > This doesn't answer my question, really, does it? Is there any good
> > reason for this implementation? Why do we need to drop references
> > remotely when we can do so when the last cached charge is consumed?
> > 
> 
> Fair enough.  There is no strong reason.  Keeping the slot
> populated after the last page is consumed only saves a
> css_get()/css_put() pair when the same memcg charges again on that
> CPU - a micro-optimization from the original single-slot
> implementation.
> 
> Dropping the reference in consume_stock() when the slot empties is
> the better place.  Empty slots stop existing, so the offlining drain
> has nothing left to miss and is_memcg_drain_needed() stays as it
> is.  This also makes Joshua's concern about the full-stock drain go
> away entirely.  The cost is one refcount pair per emptied slot, at
> most once per MEMCG_CHARGE_BATCH pages.
> 
> Joshua, this supersedes the css_is_dying gating you suggested and
> that I said I would do - with no empty slots left, the check would
> never fire, and the kill_css_sync() ordering argument becomes moot
> as well.  Since you are reworking this code, I'd appreciate a
> sanity check on releasing from consume_stock().
> 
> If this direction works for you both, I'll rework the patch
> accordingly.

Yes, this seems reasonable. Go ahead with the rework.


