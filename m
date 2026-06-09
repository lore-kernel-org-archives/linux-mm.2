Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8464FCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D389D6B008A; Tue,  9 Jun 2026 06:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E2C6B008C; Tue,  9 Jun 2026 06:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5CD6B0092; Tue,  9 Jun 2026 06:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7AAF6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:21:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F8694050C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:21:42 +0000 (UTC)
X-FDA: 84859982844.01.396F8EA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9408580004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:21:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VhOHgGRx;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781000500;
	b=O9GZK1UEqBiwZn5MbFluQrXv1r8I2yzvPYMy+b48HudgY4hoLk0CLPMWVbJMt/MZQzHwVE
	5BTVQoqLhBeuVQFbjc7rBbaYK6lGLGKhA5EwcdqsL/h+Q+twkICpneJ6bU1SG4ZuLsQoRm
	iC4fogE1Kq9olRQXz19iOTphvQXn9r0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VhOHgGRx;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781000500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bn99WnrCUkbfsqFDL/rbJh3F4JaVhuaOf+afGyjHySo=;
	b=cEFqXJ+2+s0P1eYd8rjNzwCD+CLUqLZiA/rqsfv6F1/DhwY2u8w7h+YHZBWYt+NXj/KNPY
	eKZz1jXDt+7PnPkQmCFX0c6Q6sw2b8Y/j8Tcf2Neb7FOiMhCnfQYwjjFWjlt63aUhuG/L7
	RoM7oHzh7NoFx7bwpkwyP/bEUxgbNms=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bn99WnrCUkbfsqFDL/rbJh3F4JaVhuaOf+afGyjHySo=; b=VhOHgGRxICUsrfaJgFcDQvvyze
	d9kU96FibEcIKwwIChvLusQP1uyaxogC376OFW/AuBQ4/sC0tjMisozUvLOInxpkQWTJLqQDxZZJt
	9DsEt2XtWd4Aguk3T5BvR8TsEhbi1Xln5HAwjm8PsQTTeiP/t4aBmQQCX4h5y3nVJpqslXa9MHvrz
	JnAK65jAXDj5l0AfPhc+AWdP7ElR7Eds261BEZMueM4J3CH460yFVbQNeSRuPsaDlPGN72UkyZuBG
	q8od3dNXMFHF/CM/cCdTCYcoDvC2X2ESqPKHy2+WIP6zSy9I6UZ80nZcxpw/yldz+Pku6i63nBnY1
	roxpDzkQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWtaD-008Kc4-2z;
	Tue, 09 Jun 2026 10:21:22 +0000
Date: Tue, 9 Jun 2026 03:21:15 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
Message-ID: <aifo8HlTY7YBWsrr@gmail.com>
References: <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
 <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
 <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
 <4b27467e-935f-5587-2f48-5a794c30a592@huawei.com>
 <aiKXrovzrNN-gExm@gmail.com>
 <f1a742be-80cb-4256-b1f9-e50a0f83cb15@kernel.org>
 <aibN4osY_QF1Rejh@gmail.com>
 <4953bcee-5a0f-2bc5-7295-63e5e7513e8b@huawei.com>
 <f2a4d5c8-3d7d-4fc3-8769-66e0c24866fb@kernel.org>
 <f21d7c12-e6c7-49b0-8d83-c26946d0d4ee@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f21d7c12-e6c7-49b0-8d83-c26946d0d4ee@linux.dev>
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9408580004
X-Rspam-User: 
X-Stat-Signature: za9nxibarbqzcn8d3j5q1s6m5dx791bn
X-HE-Tag: 1781000500-192771
X-HE-Meta: U2FsdGVkX180ScD7SH7BfSJiWXU1NTCj5rNEqG2+ixSGG4ZNbzz2yYtVtqW9RMLJDrnwYFJLq+ryGdfAn37RpGrgVT20HU3QRbMymkyWYqBvH78RyqXG1TjIUzf6itw20i8fdRWz/B8fMmh8tg65TxOXf5C7V7CQpUakgMiYh+A2sQWJa7flS0RptFjfoDoThbtzxibSXgv02yXImNWQS0RgyGetqkYqz5L2EccXM1CpvQiJnBMauHpd8dTdF2goAzcV+mHj2N3RmwkRVRPyA4Ww+QLmviPOVXAns7P8d4SNcXShNf80/8Cff+xI+omfxP2OX+L6PI2UUOq3GQvXE6FarQdf9Ic3z0hW3fRUEs2kZTEB+m8z7t5J7sk1aVtRvfz2DIJZ0WYcERRuj/F2R3kMPPsmVEDxjd69Ezs/bdO43NpjxNto/rQpaJzXrKpcJS0wuKSD1UWKfSws4oM+i0qaH8kbcSRX0zB4kp2+tmri8XqjtMAYICY7zqRLsnISlHBR7u4G2WAk2/WPKR6cw3Embi0kcGh5dJhfN/3JkcfTAyCR0wzVnLUz2v8xrTTXWQHTw3C+WnvJyrnYOpA8une5G1+Fse/5N0SM4IdI92HhwyHczJBQScKtWfVCxGf4kR+ar6yczNohsXMnSDODQ1FkOrkSrc8k3P4mX4cPbL2jWl3cdmkowpveLj3ucx6BPSf8xj8NgK/Nq72Sukyp1ljDzOCru6yHrVjiyOWkuOjo+RIMhHtrIO9w8WKgDTxHkDGF4BcGpUehRrbHChcaguWTq/GXEQ3sDy+Xywz9mnBKShD2LXpIovo9C7/G4jBXpJl7rX6trlyU80I9Ql2bzyetOGW5hZI6jNFeMbE/F5Tf4ucXtmpqrWO1+9nicx/V+6k8JScRopnBnBg0rcNLJbCV6vmmuHMCnYxq5pAd4hyJUIVHnuV7bCv04YRmr0+cwaNr5XcgcWk2XhizvWm
 DU6+sqew
 gE3sjdwblE0VNgRfFIZnKc/D1E9jSdu9PcZVRKEpEQhNcPJyjU8BmmeU0oBoRIRsDH6wN3IFhHTJzJIM8MNQqrwc0SotUECwOCREBvvrRBCpVQkkv8O76FzIjuZJMHRR4GzIIjYdgZ+FmeiIXJxLZ4cEiJmOCXRx3YKgNgjeZVHGW3DU/ysiMRflpqrbwmAQscIOid7zaw0fyng99hS2pNsn2Ba75HwlFuQHekCtyB/NNoo8a2MM6RK6R8IvY2KV2fdXtYWo6CWF87D7Yjj2yIndR9iD7e27kIu/cP85i0iveE6LrbpWD8uhm6B67W1rum1Qoxz7o7uKSPEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 05:08:14PM +0800, Lance Yang wrote:
> 
> 
> On 2026/6/9 15:09, David Hildenbrand (Arm) wrote:
> > On 6/9/26 04:39, Miaohe Lin wrote:
> > > On 2026/6/8 22:15, Breno Leitao wrote:
> > > > On Fri, Jun 05, 2026 at 11:42:53AM +0200, David Hildenbrand (Arm) wrote:
> > > > > 
> > > > > I mean, any such races can currently already happen one way or the other?
> > > > > 
> > > > > Really, the only way to not get races is to tryget the (compound)page,
> > > > > revalidate that the page is still part of the compound page.
> > > > > 
> > > > > I'm not sure if that's really a good idea.
> > > > > 
> > > > > But my memory is a bit vague in which scenarios we already hold a page reference
> > > > > here to prevent any concurrent freeing?
> > > > 
> > > > No, we don't hold one here in the case that matters.
> > > > 
> > > > HWPoisonKernelOwned() runs at the very top of get_any_page(), before
> > > > try_again: and before __get_hwpoison_page(). The first refcount taken in
> > > > the whole path is the folio_try_get() inside __get_hwpoison_page(), which
> > > > runs *after* the short-circuit.
> > > > 
> > > > So get_any_page() itself never holds a reference at the check -- the only way
> > > > one exists is if the caller passed MF_COUNT_INCREASED (count_increased ==
> > > > true).
> > > > 
> > > > So on the MCE/GHES path -- the one this panic option exists for -- no
> > > > reference is held when HWPoisonKernelOwned() does its compound_head() +
> > > > PageSlab()/PageTable()/PageLargeKmalloc() checks.
> > > > 
> > > > Given that, I'd rather keep it racy and take no refcount than add a
> > > > tryget + revalidate purely for this check. As I've said earleir, an operator
> > > 
> > > Would it be acceptable to add a simple recheck? Something like below:
> > > 
> > > retry:
> > > head = compound_head(page);
> > > PageSlab()/PageTable()/PageLargeKmalloc() checks
> > > if (head != compound_head(page))
> > > 	goto retry
> > 
> > Sure. I guess it could still be racy in some weird scenarios where we
> > free+allocate+free in-between.
> 
> +1, sounds reasonable to me. Still racy, but acceptable here I guess :D

Ack. I will post v9 shortly with this plus a couple of selftest fixes
Sashiko flagged.

