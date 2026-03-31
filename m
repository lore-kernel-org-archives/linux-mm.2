Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7525F1061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF1A6B0095; Tue, 31 Mar 2026 06:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6166B009D; Tue, 31 Mar 2026 06:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC356B009F; Tue, 31 Mar 2026 06:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB9676B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:35:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AC2EBD784
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:35:05 +0000 (UTC)
X-FDA: 84606000570.29.B6F1831
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf03.hostedemail.com (Postfix) with ESMTP id 93E8720013
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:35:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p33ibMJl;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774953303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGoJpSFt6qPU5Tj1tCTJazBok4fp1H7/lxXOEKF1LAE=;
	b=x27zQbatir26S/VgW6ddX6x1CY4LjnYpgJl/BSLcYmHbvnmK235gw20LnYkAJ+Tfh4KxIP
	/L91fK9Sa4NvStg5Yw9iQZHFH3Y9FnrVR2k2pz9o05N6VSMl+n/fpXhsniecVCueCrEazh
	tD9GKAp1VLf0PInh2/o5BavXTsMqaAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774953303; a=rsa-sha256;
	cv=none;
	b=Zk0Bey0Rt/wIUXUMwVlGdt3ZEtOhscabdkc/w9MwRsdXBMtF7WJIjXbm0XJB2HJl7idboL
	vZ2/bUK9diODdq02s5PUumrXVr6EpzfPx/g26AinyW9C8L19lu8iV38u4ytyvFR8/OC7Hh
	jVFUdxcpSyyqAEz1KLnenZh7O3mnyl0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p33ibMJl;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774953301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGoJpSFt6qPU5Tj1tCTJazBok4fp1H7/lxXOEKF1LAE=;
	b=p33ibMJltLANQa/bsMRalz0WLn9BlHm8C+vEC5ite7qjEZ0cbDSZL23LJhIXOh4mWTMMG4
	TBKLq9j8Mz6GbrKJDMbOx9Su5uRTDWM/gjU81JtLwKyzFf6t4mVUaxKYeCN9VzzuGjwlZt
	rIOn5+Mdz2haHATDFp1JJcwSMAvzAHM=
From: Usama Arif <usama.arif@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/5] locking: Add contended_release tracepoint to sleepable locks
Date: Tue, 31 Mar 2026 03:34:50 -0700
Message-ID: <20260331103451.1070175-1-usama.arif@linux.dev>
In-Reply-To: <d2e5763278812499335b22a013aafb4979e3324b.1774536681.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 6thyn1newxnz974k37ki6ujuu1dhfxs8
X-Rspamd-Queue-Id: 93E8720013
X-Rspam-User: 
X-HE-Tag: 1774953303-652485
X-HE-Meta: U2FsdGVkX1/dvLFYrJCcJMN8wHeAYMOn/E2VwJ97M5AwUS2MfJoeAiDLAURtN8NA49B0CzvwrFiOLCd+u9vkQnSiw8PIfteWWKM5Y6wSGfcIcvb8xUzoVL01e2YyBjuOD3ZbzWpJZRlrVONmeEAAOZmMeYUr1MGQ/e5rR+BQmlnI1T1A1o9WSud6O3s5I29soXyoj2sJ3yOUfpVLf1uUakp/SRntUqZQ0pERCDAuNu8JrerkNEQZwlNPhl/Ba1X2wcIY9rN7GE627kJXSJdbaTMJVu+DYAOOlq5DA5zjhPzelLNTC5OSGCkP7U6EMaWH279QSgXRvoTbs1rIOCyXL5QWJ3mZJFhdeyUMomJfHYTLC8LP/gPNpG349mtTKzTv8S3XuyW/7ieYz0nutrmZ7OlLd07+uwYlmigKNYIijHX6+d1HsHbmbgkCRN3iLd+rlx0aTW8sZXKxpD0j/BhEzprsUt4HalnhhkJ2n3ycFnhq0DyAz/JnOecMaV8LAVviOZEZuP3NJUXLYAbh+wyDrGkeizQJjzx1mbWTsNMMKX2zTI36/HV3oGhf5lzMHRuZIdEFDnosbeHUWBCdNHkTqU3R/ykMBJmuZGYyve2jB0uBlkqfXbakfVsoMOPtlaGo9/iQQdG23x/IkuEARiLnm9Zz46YWGW6UbcmeN0PrkbZILpuAQ5G9+J5+MZRuufJvqLSxxuhCDiqe72WDFI+FDQdg4NWxRQTiZCsLiinI6ad44uKkbOC3xf2EQ/M0I5IKltNjpyKcQ2GYbKTJ04i/oa6WEbWsfGxTziKBhHUUSKSq9+L0rY+D1g+ujFQc4AF+8IGu6o7RX5hFym8hX800f/WiqMR1h/rN82HG0NmUgKQo2nPLlNY6nIplMl0/TwC6Kbrn7egNqYu3uzj2Dld3d/lAglR6iAjlG2FiTfb7b5AKK/7UmHmDytHXRsmza4spKUQSIRQ4kttsh5z16D0
 Mg8yY1+F
 ita/ZHI6h67apkcPpg/07/4WZRIMb3C1zxDhUxvBOchq26nKTZOZfvZMJsl7IseKnKWQSFL7wwtr8e5wlw8mIg2GWNhdk86CuJs3oXxJd+yLeY1x0eflNFjGbwEFlZa/GtVw3LnvW+NOBSM1ZZCsLEzlmfddEGc6eZg0oHaBVIw7qfkra65HA79DexurCQMo7fz7x9E5VDDgGOI60+R9h2czCTTkPfY02vKpZvzyYYF/suTBvnigqrkFCEJ2NJX0hmfdjCs7aTSi3ilz2Wzq8UHRY3V1dV9s/PBnf5c2pA8ClQ+t4+lS9zf16VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 15:10:02 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Add the contended_release trace event. This tracepoint fires on the
> holder side when a contended lock is released, complementing the
> existing contention_begin/contention_end tracepoints which fire on the
> waiter side.
> 
> This enables correlating lock hold time under contention with waiter
> events by lock address.
> 
> Add trace_contended_release() calls to the slowpath unlock paths of
> sleepable locks: mutex, rtmutex, semaphore, rwsem, percpu-rwsem, and
> RT-specific rwbase locks.
> 
> Where possible, trace_contended_release() fires before the lock is
> released and before the waiter is woken. For some lock types, the
> tracepoint fires after the release but before the wake. Making the
> placement consistent across all lock types is not worth the added
> complexity.
> 
> For reader/writer locks, the tracepoint fires for every reader releasing
> while a writer is waiting, not only for the last reader.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  include/trace/events/lock.h   | 17 +++++++++++++++++
>  kernel/locking/mutex.c        |  4 ++++
>  kernel/locking/percpu-rwsem.c | 11 +++++++++++
>  kernel/locking/rtmutex.c      |  1 +
>  kernel/locking/rwbase_rt.c    |  6 ++++++
>  kernel/locking/rwsem.c        | 10 ++++++++--
>  kernel/locking/semaphore.c    |  4 ++++
>  7 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
> index da978f2afb45..1ded869cd619 100644
> --- a/include/trace/events/lock.h
> +++ b/include/trace/events/lock.h
> @@ -137,6 +137,23 @@ TRACE_EVENT(contention_end,
>  	TP_printk("%p (ret=%d)", __entry->lock_addr, __entry->ret)
>  );
>  
> +TRACE_EVENT(contended_release,
> +
> +	TP_PROTO(void *lock),
> +
> +	TP_ARGS(lock),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, lock_addr)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->lock_addr = lock;
> +	),
> +
> +	TP_printk("%p", __entry->lock_addr)
> +);
> +
>  #endif /* _TRACE_LOCK_H */
>  
>  /* This part must be outside protection */
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 427187ff02db..6c2c9312eb8f 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -997,6 +997,9 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
>  		wake_q_add(&wake_q, next);
>  	}
>  
> +	if (trace_contended_release_enabled() && waiter)
> +		trace_contended_release(lock);
> +

This won't compile? waiter is declared in the if block, so you are using
it outside scope here.


