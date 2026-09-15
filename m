Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D8DC88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81086B0093; Tue, 15 Sep 2026 04:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58A36B0096; Tue, 15 Sep 2026 04:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F576B0099; Tue, 15 Sep 2026 04:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADAD46B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:23:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F273B1C22BA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:23:27 +0000 (UTC)
X-FDA: 85215307254.13.CAAAD1B
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5063DC0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:23:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ipzJcm8I;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789460606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLQ264WxN6wDQzABD1f2vOcHnnY8r7L3wdbiMWb63xA=;
	b=y9Q/sBFUy63PtUnasy5AG25Al84dArnEtmsRNOfGh/26O1mQyZlzARb+ErfhDEG+IGf4T8
	PuSJJ/1TSUcktmpRz0QzP46DGtx3J1/rqZcBHPsmGtu4FbMOZ0RyT4PDvDd2pDVDc9MaQc
	rLadS9v9wdy3OERrOMEIbxzdBMQc3Uo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789460606;
	b=ggjVivAfQ7fsTk45RwqknQAxGyyLclgYnxVXanFNW0DgWDBTq4nJUS1yae5eXPYlfVTXpV
	j5A7257mIvmyQfSzyEEqtfSx0N616UtI8HdbAz+JhvWfjfEjRcw+bxoykHDP90aruyIrj1
	16kxPLm3DsfDe1KSxROSJym9NLn5VWM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ipzJcm8I;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GLQ264WxN6wDQzABD1f2vOcHnnY8r7L3wdbiMWb63xA=; b=ipzJcm8I1ST/GUt421dYmJnfyI
	vMJ7fwLPm50oqJU0jqpXgWe24q407KlTdH7SXHQr7TDXrJ0cM1tEYBnW9xuMF681fSZbRWEhC0xLD
	6pneXq40+9I4oviAF01pBkAh9+iexFHZvr8Q0AJ9eQUZ1IpxpzGhf4HDVrlwFQYzTx+rlpPRZqXIS
	bi5aWaDAYx9YdPtSyaz9+cEy9G45/haDccskEkn/nT4u1JIUGIvbu/z3wOp8oYMS5UFYrgQZ3LkKc
	D4oDDw5Avnj0AUqbEB+wgK/erFclXrfrCAUd2232oXhxiftApCzjDlcWbdLgQanaRy0SwbWde3WVp
	73UWs78A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x6ORT-00000006QWj-1Tpq;
	Tue, 15 Sep 2026 08:23:05 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id F1FDF3012C6; Tue, 15 Sep 2026 10:23:00 +0200 (CEST)
Date: Tue, 15 Sep 2026 10:23:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	rcu@vger.kernel.org, virtualization@lists.linux.dev,
	linux-rt-devel@lists.linux.dev, llvm@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 01/17] locking/mutex: assert static storage for
 DEFINE_MUTEX()
Message-ID: <20260915082300.GV4121339@noisy.programming.kicks-ass.net>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
 <20260915030336.1192299-2-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915030336.1192299-2-ynorov@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5063DC0002
X-Stat-Signature: 7bz4d5bmokdswpkahs1ienudy8pubfj7
X-HE-Tag: 1789460605-179842
X-HE-Meta: U2FsdGVkX1+NKEIyfCTU/QNo5M1r6yXHsKvuJke8z7jsfRcbeWc5ZY7TL6CZQbHxebtdkRoQklVSAgjIJYap4R93RBaFBtw+qxbvcQK8FrPooOGun/Yfo9orZMoex5Rk0P1FZvzaC4yPIabgP5eoM94IG/BKtoqyCrbcwMjgn3LF2dd6cb2SsiED2MiN1HXpylwxqHsszpzxwdf0Z2t/5bwH9gGJDUobupn7kqFAtgU3QLqMf/6uJsyrx0k8HcshWPMfDeHGDJ+3K2miBWkVSHwzoPkLPPKn9XmyDTnMhMJhWsSdIXOuvDojtWYrIlzp+9XKGlawKqev+Kb6+P/A3NXTVaJHMXXGpO+ZDCPqGBsUg/PU0w/m18XL6GTrwFx/NzhGpz1LWychl9IZuMhOcnxlEpEI2cho+I2hjq0IbP9k5Dl0iAkv4u54zEqw07D49iZKtAcygFS3xWUnt5vec5Z3qu1h7UV7uBD3/hEcRDRmvsAijMgSk6dgR6b/y9qshaxBnRPDm4R4cFrCCuouBf82LQmexTJh+zyk8+upjPlpGEscrdjpc8J3nfO0Viki+LvBFFUhdMW/QMGlE8bq36uZoCguN7dg/UAen5oAGgXj79W69KmQUMrFvNJwAK4VNZ8YaOkk4s+V7r6a/rYapApNHevi3xL9xKJXhFZcXNuJzpfXqBSD1Jmqdav86G9Yu2jKw4rYFx1UBUWcQ3+OFjB1y3euzpIvj6fzdd3uieSaA0zG2vJbtzacY0Ev1eRd+mRe92Elk7cNe/riHmlPWgGBCW/hFMW4DjtQZ3+z6e+H0WY+wyAF6TFW7orH5TX+eCjKncLdXq8buNwmsAE+/ZxH29Jerm6MtvzUwGPEbXE5Qn5uUIek2Z0gzAQBJtmnrxcx4ktwYA8uWSXPfgnUjpPC4LlpIbFjw/PpxRkoftKSu0JTZp0g8TaQkzk4ZDaBKr4S9FlC+ciisUvFxhv
 zJU2Lawu
 A8mziRbVZel06cJSSDW0AxaHHbMu/NXOsS6DYs4rTA92a57Ldbbzssu/TVEwE/n02yDq/XwiDH29x0FHRPaTsHs25xi9Yh0+4vQhEARYTZEmewettRPiuUZ2JN/JhUTvSTa2H8IfDpCe5Z+Xy0379eym3pZzHVTQXK7/7vk8LIR6QDjBH1RFih+LZ9M01EQE1Nw3pmc+p33eVBvyejRRw7pJcySf/RlRiYYgWjutwx7ZFNOQAz/XHFTBhnLlrhIRk/TmkAAiGf1HZcG2U5je+DPzvwX2Mcyanppka+OvF1cxTIL6H6aUDCZk7PQbJyLjo/8hCpQHvChPlKSvAJ4Uuj4nnZfWhqDUzAGo0CGqKVQaCCo/7iHKyolcWCjcr39Ve3bvxqDYEUY/Hw10iZOigpgu/m/n94e0XRT0Bv825ugx4+UUU9XpnaLzKYYm9RGAu60n/DROxhYMxAuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:03:19PM -0400, Yury Norov wrote:
> DEFINE_MUTEX() uses a static lock initializer whose lockdep class key
> requires a persistent object address. Reject automatic local declarations
> with ASSERT_STATIC_STORAGE(), in both the regular and PREEMPT_RT variants.
> Align the VMA and memblock tools stubs with the kernel declaration.
> 
> The two automatic mutexes in the WireGuard allowedips selftests already
> call mutex_init(). Replace their redundant static initializers with plain
> struct mutex declarations.
> 
> Assisted-by: OpenAI Codex
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
>  drivers/net/wireguard/selftest/allowedips.c | 4 ++--
>  include/linux/mutex.h                       | 7 +++++--
>  tools/testing/memblock/linux/mutex.h        | 8 ++++++--
>  tools/testing/vma/include/dup.h             | 5 ++++-
>  4 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireguard/selftest/allowedips.c b/drivers/net/wireguard/selftest/allowedips.c
> index 3e857e6fb627..ecb2908228e7 100644
> --- a/drivers/net/wireguard/selftest/allowedips.c
> +++ b/drivers/net/wireguard/selftest/allowedips.c
> @@ -257,7 +257,7 @@ static __init bool randomized_test(void)
>  	u8 ip[16], mutate_mask[16], mutated[16];
>  	struct wg_peer **peers, *peer;
>  	struct horrible_allowedips h;
> -	DEFINE_MUTEX(mutex);
> +	struct mutex mutex;
>  	struct allowedips t;
>  	bool ret = false;
>  
> @@ -499,7 +499,7 @@ bool __init wg_allowedips_selftest(void)
>  	struct allowedips_node *iter_node;
>  	bool success = false;
>  	struct allowedips t;
> -	DEFINE_MUTEX(mutex);
> +	struct mutex mutex;
>  	struct in6_addr ip;
>  	size_t i = 0, count = 0;
>  	__be64 part;

This should probably be a separate patch.

> diff --git a/include/linux/mutex.h b/include/linux/mutex.h
> index 734048c02f4f..2f2d95f3097c 100644
> --- a/include/linux/mutex.h
> +++ b/include/linux/mutex.h
> @@ -11,6 +11,7 @@
>  #ifndef __LINUX_MUTEX_H
>  #define __LINUX_MUTEX_H
>  
> +#include <linux/compiler.h>
>  #include <asm/current.h>
>  #include <linux/list.h>
>  #include <linux/spinlock_types.h>
> @@ -84,7 +85,8 @@ do {									\
>  		__DEP_MAP_MUTEX_INITIALIZER(lockname) }
>  
>  #define DEFINE_MUTEX(mutexname) \
> -	struct mutex mutexname = __MUTEX_INITIALIZER(mutexname)
> +	struct mutex mutexname = __MUTEX_INITIALIZER(mutexname);	\
> +	ASSERT_STATIC_STORAGE(mutexname)

My tree no has ASSERT_STATIC_STORAGE. Please repost when that lands?

