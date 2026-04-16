Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3178CF8E497
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 23:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970006B0089; Thu, 16 Apr 2026 19:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947106B008A; Thu, 16 Apr 2026 19:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D226B008C; Thu, 16 Apr 2026 19:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 774166B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:55:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B0D5140A07
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:55:05 +0000 (UTC)
X-FDA: 84666077370.19.E7BBB8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66DD3C000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:55:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCqhKot0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of "SRS0=40xI=CP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=40xI=CP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776383703; a=rsa-sha256;
	cv=none;
	b=S2fvZoFTkqG8C/pH7eu0KhU0ATzgef803nNOO912/uhiiMaQY3W1VeuRXDWAEvOAtiE6gZ
	9nYU3ynrwkTXlgtpuUqqm1cA8GytmU1NfIBD/g8Vc3AqT/5XJ7nhDB01TAfpVmpmRIdJTp
	5+6trHWZqJXlmi+E4YJmDfQQ7gb+/oA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dCqhKot0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of "SRS0=40xI=CP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=40xI=CP=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776383703;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQ6aSYAa60J6Purco+UFEavTLSWhu6LQLNVZcfX2wqo=;
	b=U6WHnY2yiCiO3zTfY4cw1Orwct7N+LZQEFBROA9Zx/egNbdBoEwmIZX7k9KivtEpgcRp9j
	bth2LDqg6BsA+SFC0Jd5fRDv547OzlQfA20d/r7mn9BRIPVZZspE16sW3+I6JUWIeUiZ15
	N6SAhu7z5ySEcj8p5iBEp9lpNDrCgDM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43AF044077;
	Thu, 16 Apr 2026 23:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16048C2BCAF;
	Thu, 16 Apr 2026 23:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776383702;
	bh=VTowxyWg+zn9j8jiuGeLbEeSc6Y2b6QIg8VcHWlfoL8=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=dCqhKot02DjEDRVLSZr9RuE7g9LL4Qrx848zBV/INJJfrG4sVFSC6GWQkW4UyxuYy
	 ogGiJ25N7Trul2F0hQcRp3pEI0zdZ7ZvO14S9J9pk55q9bmZXOYo0Nqi7iJ6rABh2w
	 jjBFC7EGmcZoZ1sCA3gfdq3ZwDvx2mt2wTlsOzWK1UeuggY0d+J+1jf/veyDtH6CH5
	 +7tqt12j7Uvvhs5gD9SrntZFo299kcV0JGXHsJEUViiZPAepLW9nz0bKSNuFTmsPmM
	 xqm9iuh+bNCp6Y4awDa+oF9EZCOIXckdVMTpYDRr+S6ZXLsNVHJkjGW+sk3+74stuC
	 WRMGCLsr1REmQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id A524FCE08B2; Thu, 16 Apr 2026 16:55:01 -0700 (PDT)
Date: Thu, 16 Apr 2026 16:55:01 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 6/7] locking: Factor out
 __queued_read_unlock()/__queued_write_unlock()
Message-ID: <6445a6da-158f-40f1-ada0-fd5628b127da@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <cover.1776350944.git.d@ilvokhin.com>
 <eabc9de3347ca042eb0593c9b81c8e48254a4874.1776350944.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eabc9de3347ca042eb0593c9b81c8e48254a4874.1776350944.git.d@ilvokhin.com>
X-Rspamd-Queue-Id: 66DD3C000C
X-Rspamd-Server: rspam12
X-Stat-Signature: cj5qmse6pu97cxj91yehgino4chxgt63
X-Rspam-User: 
X-HE-Tag: 1776383703-515728
X-HE-Meta: U2FsdGVkX18RaBLCaeCHtYnUWaYSCl1FrMtuTYmy+VXAmlUkosSug6sqb9X/NFilp0gBabC/cvM4Ev9OHYLH/dxbebhhYqOWkLJFkCbEloYc1ARtLutMHE7A7JSRhLfq95EvUUfq9/b81RgeoYHTO+lxnWLFeJBLZatcuDWS8hIjtDpzIeKiIJYXTPv7xZorh4I1KYCU+ZkbsWC24nc0TwhAiB+cjh+L2AjzBX0bq+Z+q7Sug+C8h4DwipR6StQH++n4IklMvr9sOZJX1+eMwA9RWEWVeebu65iFxvg0sllidLTnWo0IrRoLeRPMplccLJg2OnJ9lm9qRB2rc7Wh2n0hK8BG0qNXuSMD+aCj3OTiLVQRYGeBzPa2a7trDJ70Yo+Rb/Ec8UWtEqaRTP9OttCLFhApYgeYNg318tXq7USoAUwGrlAlb0KRJJo/ULZ0Yqdz8aOuFA/fcIzRrHcxy/XqjF5y60sEFQPuqATTEwEKywvCwHRtqGIDQM21fjxrYUIgfaA4rQl8+LJV74722IWjVA6iDr24nF89lAiHS5Xty5s35JRGSecnZ2hwpPxklXgnmhdTz1noh0xVe8BRVm/h1IQMkNSDAA+XNMNa5wXNW+1mJ4uyaUXGOwNswhFUTgzyheWbAhEKPELsYFpnqPBtNCAb5Z1TKVTYQ6wgjhlZY05GqiqgljeWkI9xJgW/VNTQCwYvuYmDB6zcxYnTYUoO8uywSOu4FsgDpfut0IFY9LyJbzCYkAhlR69Nud89eCnN0dxvB4L7JEq2J4P/LQL+nhnSZTIlQw6My7Ddjmmf//EXCrLwtKYm+QvzyCS41XFrHiKOJuCBKcEPAkK30+P1Z0yZLcFLgi4L+e+wDM8thI5NtNy5kcYbe5ewRpIUn7yoMcKUgeVUnpkTmmApwTh6JzteKh/kMI2zMNPDjlts53xT9CofwQYRLzQisF8lvA17aj5wrb+ciAhHRxL
 anErHkdW
 dsBoOOocCSsv6macqxp/hXzzth0a75g09jWcBa+/rZOX8XTZqhZr4ZDitCU5Wj+HWsRMq+p3gbs34/gdYXU+5kfWdhQHICZ4BqLkpxg5hqSj+rnuYhizxH8ofPzz6jbdUvW9euR8AEOMZgmYOm2Ijyz7gv4kPCXiOVVXEPinDAd01bV4YuEAzknn7XST5AjN4QstW15ILgNxiWTnXgGJgIH7VuXFPDg3RRIKjR7IGIE18P6jmzeiV1d6+gm9yNSdyWfbmDPqKipv+2VU9Bn6vL8cP/ULeXZz4eeOrmDXxIBgtIzE1OvgXPQux73KZG2DICtMep5js2VOlaTtSI3KYHctQU+dZTxYKeYTb0rNQpwfkmTDPaEMM2PNhcnCY9OigOVLb8Apbp4cs7S/1B0Hhio98snCHI4vAuiC53yW9NYUxyauk65ylE+ZWtN9H4yy6M1ukSzrr/+gid8BIAj5Ji5+iU8a/PHuSEUdeuVQ9ounkNRKUbQ58wj/GiMw1Iv8gXKt6cjNVI8VEctWiIz7BZHKDPmBFfqSCw70kgHdWV1jpTyvaa2L0cvddhExbDYnkYFVV0MsL1gc/Zr4PHvPLMtsqPLzQBOv2QK4WhEDlSS2QIwF+THptEF60gJ9JuvMOMzmn4Nq31rEQUsucaL06vX6MthijPEr9Q/giY4qE3GBcJ2eWwCTm/YB878QDSjRAuqboCcevckGbpnGh28EidI5XEKApZrlRaBIDs/GHSDJ5SrsjjUKnwn/CcN+f9+iCkdRDaBrVnnPwChcZyh6HfCpEBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 03:05:12PM +0000, Dmitry Ilvokhin wrote:
> This is a preparatory refactoring for the next commit, which adds
> contended_release tracepoint instrumentation and needs to call the
> unlock from both traced and non-traced paths.
> 
> No functional change.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/asm-generic/qrwlock.h | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
> index 75b8f4601b28..4b627bafba8b 100644
> --- a/include/asm-generic/qrwlock.h
> +++ b/include/asm-generic/qrwlock.h
> @@ -101,16 +101,26 @@ static inline void queued_write_lock(struct qrwlock *lock)
>  	queued_write_lock_slowpath(lock);
>  }
>  
> +static __always_inline void __queued_read_unlock(struct qrwlock *lock)
> +{
> +	/*
> +	 * Atomically decrement the reader count
> +	 */
> +	(void)atomic_sub_return_release(_QR_BIAS, &lock->cnts);
> +}
> +
>  /**
>   * queued_read_unlock - release read lock of a queued rwlock
>   * @lock : Pointer to queued rwlock structure
>   */
>  static inline void queued_read_unlock(struct qrwlock *lock)
>  {
> -	/*
> -	 * Atomically decrement the reader count
> -	 */
> -	(void)atomic_sub_return_release(_QR_BIAS, &lock->cnts);
> +	__queued_read_unlock(lock);
> +}
> +
> +static __always_inline void __queued_write_unlock(struct qrwlock *lock)
> +{
> +	smp_store_release(&lock->wlocked, 0);
>  }
>  
>  /**
> @@ -119,7 +129,7 @@ static inline void queued_read_unlock(struct qrwlock *lock)
>   */
>  static inline void queued_write_unlock(struct qrwlock *lock)
>  {
> -	smp_store_release(&lock->wlocked, 0);
> +	__queued_write_unlock(lock);
>  }
>  
>  /**
> -- 
> 2.52.0
> 

