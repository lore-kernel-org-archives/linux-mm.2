Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52828CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98496B00DB; Wed, 13 May 2026 11:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E466B00DD; Wed, 13 May 2026 11:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC166B00DE; Wed, 13 May 2026 11:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98C8B6B00DB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:43:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BD82120199
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:43:13 +0000 (UTC)
X-FDA: 84762815466.14.3856322
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 55E4A140007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:43:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLQHara3yJ1uTjYJYl6dDDn22Mk+HTGnxn6vCrV9TmY=;
	b=QIb1B+U+xVIRConNdDTI8FWlDG+SiIP0FFzjhHoqT3aeyZPrefyPDO3YwP+hg10EZ8Kn7e
	GjCYgYr9+rc6ufZO0mIg2Jt4scph3oRy1gAPiWJkj2jqDNvGAJP2j2C87oHrDm7RxL3afv
	EiOkIH3ZpyedQYq3+9ufpsGdIl0mhII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686991; a=rsa-sha256;
	cv=none;
	b=Ra0n5d/BrDdBTAKYPcvEgbskzDOTr4w0k4BCyAoZIYpX7r8OzV+pG0nP31Eu0jlCtJg8QA
	5k7vRJL7bicwuww+gb7iCv1GQF92uAhSF2CpTA9YRljTBR9La+N8jrTWSMXIIeqCh+3waa
	XHBQnfW9iV1N3YWQz9+PMlHDR/pX+BY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
Received: from omf02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49B49C0439;
	Wed, 13 May 2026 15:43:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id AF64F8000F;
	Wed, 13 May 2026 15:43:02 +0000 (UTC)
Date: Wed, 13 May 2026 11:43:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>, Broadcom internal kernel
 review list <bcm-kernel-feedback-list@broadcom.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, virtualization@lists.linux.dev,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 7/7] locking: Add contended_release tracepoint to
 qrwlock
Message-ID: <20260513114305.21ffc98f@gandalf.local.home>
In-Reply-To: <b67fda8e847fff72da05eff7f799019f8d17ce21.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
	<b67fda8e847fff72da05eff7f799019f8d17ce21.1777999826.git.d@ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19Ry8RzWesZfFcKD7J3lfQK7el56ZbsoNM=
X-HE-Meta: U2FsdGVkX191OTt5Ksd6rUOT63By4bRHO3knmbxlImxeNwSRm6MiHtOjFX4vJPI7crm7BSyrSIbvYT2WqOIcyORlXBEY2Q745H1gRnZgzxFxnZc2Bi+ODYvQqGyzbt0gxBvY2ORVu7Y4GQ21a4wpv6/a90k23BYL7etn+PwAjOo5gxJiydIgCFloW6Mpqm0UrvbWwABEN81N7oFp14CVTY728nkwzhqSyPCqbUhdm6Gp7kGkEzhfOsmKyTBnoEo7WZmXFfbv5M1ZAKLN8diVSXcT2j7/QCb3HvSSmT0BmXISJ4AvPIW0Eh8Dhn0nmq6iowz0POq6263XgbEXZQ9JarrVBkMeNNzrxBaehT1mK01cf9rA6EvFjUu8THAnEVExi+n7p8EX5+Ja1SfaAhM8P576YgkfJW2f
X-HE-Tag-Orig: 1778686982-257566
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55E4A140007
X-Stat-Signature: w86rrez7eqwjzfhgqoxgq67qhkb7x9up
X-Rspam-User: 
X-HE-Tag: 1778686991-549644
X-HE-Meta: U2FsdGVkX18CdtN8Hm+fYP2TIq+I7MxAXCcKgFKoPInGUhkVkPFQRRu+rpxBRd3pacBex4/DvSY3wmHiySOURaq8xDiNPaxa8UX46LFHwjT6a8TYtON/hniXbcpSqJlxiwhYCq/GjuslG40AAfmGT+Jysdl86WVQ1KasQZgbtZmPqomrgp4pqEWrUdlt50nKzz8MNgvkOBC+s5ACoQwjeZPCGexhQl3+6T6K0QRUpMG//KfiY+RFhwnhsvh0cTvEVmNNeEHeBoXSIwMDh8KzNRb6AJBgFjV9EI84Qlg4Y/Y6i5nHjPAlbpzutwa8qKa0jMZ2ecD2Wq9jhn+C+0y6aKHagv8rpmlnUGD0cbXIrme28XM+nNDF+1xjquiCfJSG68c7jehgHS+F44khcL6vE0XAk3AU53sTrDhwUfZUGqJ+qXbxDEfd1S/0Aw36+c3qw6Kx9uuXwU8zpmgFNNheTigtSz3peE5UEJsVMFvHHVNJ/dPTeqeKFlDcQRmwmvv38nxx8XazH8xGEf4P8wViv/09k1RBBgCMwBnsgUsHiJFpa17zC3pnoqMrU60pEYoLxfpHP1J/IHrydt7FT0fQIZNWdlODNZs4Oif/Wg2+As6kj51qVZEJLWSYTWVZhLrBsMNpGud6L1/wR4M6eAPxMEShmE9a8f53uf17FXLVN0NhaUkdp2E4IGP1EZReIGAa6L/HJF+YuyT/vOkQemgl7DrwiZ/kvXQ2xNMcepHeMIW/Jht7tichSN5h9vY20SAGIrJE7O10Lhl+Ai7pk/n8XN/iLZaJNkQ50Lslky4xnnY1Ek79AGWNzma46GeCR4ZA2P/tUC09UBMPqYEigQsxBhzqrD62f5JG551SvbdDbVpb2wHsYtwAI1nbeviui5lut2RHv4mSD28EHM0TR/rHBE8eUGj0mnLxdeU3Jlki9tsosQ7/Qhy94biHX3rAc+PNgaApevLnHwCi6oaHdIB
 0l+YzVct
 ZrfXIg8f5ok8t3pK5INBNkOEDmu/hO84wl2LRHkfBhNT3tac5veXBXFYu+/2M5xgHzYp2zQSupI+H7/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  5 May 2026 17:09:36 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Extend the contended_release tracepoint to queued rwlocks, using the
> same out-of-line traced unlock approach as queued spinlocks.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  include/asm-generic/qrwlock.h | 22 ++++++++++++++++++++++
>  kernel/locking/qrwlock.c      | 16 ++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> index 4b627bafba8b..274c19006125 100644
> --- a/include/asm-generic/qrwlock.h
> +++ b/include/asm-generic/qrwlock.h
> @@ -14,6 +14,7 @@
>  #define __ASM_GENERIC_QRWLOCK_H
>  
>  #include <linux/atomic.h>
> +#include <linux/tracepoint-defs.h>
>  #include <asm/barrier.h>
>  #include <asm/processor.h>
>  
> @@ -35,6 +36,10 @@
>   */
>  extern void queued_read_lock_slowpath(struct qrwlock *lock);
>  extern void queued_write_lock_slowpath(struct qrwlock *lock);
> +extern void queued_read_unlock_traced(struct qrwlock *lock);
> +extern void queued_write_unlock_traced(struct qrwlock *lock);
> +
> +DECLARE_TRACEPOINT(contended_release);
>  
>  /**
>   * queued_read_trylock - try to acquire read lock of a queued rwlock
> @@ -115,6 +120,17 @@ static __always_inline void __queued_read_unlock(struct qrwlock *lock)
>   */
>  static inline void queued_read_unlock(struct qrwlock *lock)
>  {
> +	/*
> +	 * Trace and unlock are combined in the traced unlock variant so
> +	 * the compiler does not need to preserve the lock pointer across
> +	 * the function call, avoiding callee-saved register save/restore
> +	 * on the hot path.
> +	 */
> +	if (tracepoint_enabled(contended_release)) {
> +		queued_read_unlock_traced(lock);

Same issue here about duplicating the code.
> +		return;
> +	}
> +
>  	__queued_read_unlock(lock);
>  }
>  
> @@ -129,6 +145,12 @@ static __always_inline void __queued_write_unlock(struct qrwlock *lock)
>   */
>  static inline void queued_write_unlock(struct qrwlock *lock)
>  {
> +	/* See comment in queued_read_unlock(). */
> +	if (tracepoint_enabled(contended_release)) {
> +		queued_write_unlock_traced(lock);

And here.

> +		return;
> +	}
> +
>  	__queued_write_unlock(lock);
>  }
>  
> diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> index d2ef312a8611..5ae4b0372719 100644
> --- a/kernel/locking/qrwlock.c
> +++ b/kernel/locking/qrwlock.c
> @@ -90,3 +90,19 @@ void __lockfunc queued_write_lock_slowpath(struct qrwlock *lock)
>  	trace_contention_end(lock, 0);
>  }
>  EXPORT_SYMBOL(queued_write_lock_slowpath);
> +
> +void __lockfunc queued_read_unlock_traced(struct qrwlock *lock)
> +{
> +	if (queued_rwlock_is_contended(lock))
> +		trace_call__contended_release(lock);

Just have this trace and not actually do any locking.


> +	__queued_read_unlock(lock);
> +}
> +EXPORT_SYMBOL(queued_read_unlock_traced);
> +
> +void __lockfunc queued_write_unlock_traced(struct qrwlock *lock)
> +{
> +	if (queued_rwlock_is_contended(lock))
> +		trace_call__contended_release(lock);

Ditto.

-- Steve

> +	__queued_write_unlock(lock);
> +}
> +EXPORT_SYMBOL(queued_write_unlock_traced);


