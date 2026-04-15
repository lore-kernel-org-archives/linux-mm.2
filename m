Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2F92F419B9
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 17:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DD46B0005; Wed, 15 Apr 2026 13:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CDC46B0088; Wed, 15 Apr 2026 13:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFF7A6B0089; Wed, 15 Apr 2026 13:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEE9C6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:43:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 953C91B8265
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:43:20 +0000 (UTC)
X-FDA: 84661511760.14.A0D552A
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9EC8840004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 17:43:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=SM6B0AO6;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776274999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOJSWDSELeB0YTngjDwuIRTiVa2seMMmI2D7vgbLJHE=;
	b=oyO46+AIszeEyZFmwD+NEGfHMCee2V6fgZ/lhPZU3zC61htdefOQmw1ywAwAXp4yiyNQ02
	ZNtff8j5cn0P3r+b2x2s2KMvdMe/V2AxqtY8dQk/Z2n+rmETiU6SnuctI2reocmw7W2esR
	vJC1jWMWokcfCom/8kQnQn73Wo1AAVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776274999; a=rsa-sha256;
	cv=none;
	b=4uQdbNtWPcDG9BzM+5ypjcYoSnPL0K2Xo4kgIWaxovHEDLe3UiyncIti1vi3Q4z/nMF3UK
	BCedxCBXIaainPgxRLYj9HlHLcYKY6O89QS2Vori4bWJzOQxmYigKsch1OrXirHzTKkTC7
	EXzG0P6QyXvDfDmOljnnkbpdxWTPouI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=SM6B0AO6;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 93F3CC73A9;
	Wed, 15 Apr 2026 17:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1776274996;
	bh=SOJSWDSELeB0YTngjDwuIRTiVa2seMMmI2D7vgbLJHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SM6B0AO6SmMcSfXheaPbbVLMC7aRcI7Hs4se/r4k9imn2nObg2IzOFbNYHgZgva9b
	 ow5wVC2t14ax/460besk2BLk2ZWreZ/iowSL/PsDXW8Jvz0IPJzEXCWLkYn3Z/5pOK
	 biOqNAzm1emEyoQaB5lwW/xPsxIFCbmK8c4HniVw=
Date: Wed, 15 Apr 2026 17:43:13 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
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
Subject: Re: [PATCH v4 5/5] locking: Add contended_release tracepoint to
 spinning locks
Message-ID: <ad_OMbqBSjtTPsok@shell.ilvokhin.com>
References: <cover.1774536681.git.d@ilvokhin.com>
 <81eb8e0cd90b31e761e12721dbacb967281f840f.1774536681.git.d@ilvokhin.com>
 <8d98d9f4-ccab-4864-b406-d3eb684cab45@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d98d9f4-ccab-4864-b406-d3eb684cab45@paulmck-laptop>
X-Stat-Signature: yr7s4fmtnduay78q11dyshydekfi3eru
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9EC8840004
X-Rspam-User: 
X-HE-Tag: 1776274998-534629
X-HE-Meta: U2FsdGVkX19OAeMMSgR+ke/Y8SKDIAId1yL9QB0jMoUITGpZ47TrtR8bd39pB2IbQ9HzRmUho57ZwsEf/TNeibuk/iorhlCkvyrjV2gMzY1ZpHaZzNXm+vWsUqH1vk03TTHzbs/3GLXmg0+3iPrtZcmHJaJN9H8vqPuYe7XT63CMd57ac7PxWTefW4/zGtFh4xUGF5ETXOzls5/E7Z331q/SvNxxwIAWlH7v8ozTsFdpwOicZ/39+ma/x+djCjtrr0WpQXQ70niWOLK2gTcZwm1VpI+e1G6fSq64Ia39WRdq45GfyMPqZvANkq8uYF+1mASOS/t8+96oLrKIQ7Vc7+tKJgr/7z8G7skysOEq/iAFDPE6Bk7cPbkrZnF+3VDHKaNQehJ37gDGoRVZJJvv9lGfUsBxJ+ESNQcokaVzzJYMV4pA6adDaYHBmcTJ1uW2y8x43+Bp7nIcb9RllCk5LoOyr1m+VZC/WlSABmM3moYabZroNuPTGNu9Gpha+Hy0TuBGiUtBnwmRAgVmGA88YbBPPKOW95b03xOELns1SjtMyaw0CJvKYSicgpWchtYRDBTKNdOKngKdBVrTpFOKS5TVUa7sTNvnUNORsXp2AdjwH23zVQnVsH8ILHczHy54xEBeUlSdm12B9jrCToKeDPNt0LpHPboduAW5k3QHzsCJuZByU5qiL5FhSi8BBft4YGEK7fEDEo4YY7Qzts2dPFay2pbayUbecr8dny+7c38OIEGKh/8nT8A56M+SlwNqlmglyfcsguY/2hg7O7Od9Y5DRxoMhJTMeOGyxOTAXi/i4rx1KaYuey9n9m2HsmbdjBwfSTZlE1gQiBV+MEgPFaXZydtpGYnGYN5wBMNkEcWZQPp4b0SxSNhqa6RJpm18ZA3GcYhA+Bk21Vu+BB5GM4MocVc/VvuTyVB9pCCRIOYAzIeo4nDbqf1WAkG5aGOsyenfhQ9kZmV4EBaGpQu
 wylhHCZ/
 xF+ixEtEQwyqB808fEk2X1DBp8vjNTahnAV1wiXe4inKsM6nn19NgY6L9+W24mkMHlz4oi+uK6CB8ZGRPeARItV1y6BJOkOF6l6UsJxclLhsQI4Geo7RHOnqvn8O/CFyzXN00SKYKdhDkv6fz5dwPERNgbjWLyhbiEZPlUx/17cMFmFLR4BAAyPAen2nTHy/3A9qNgnV4408onmtOYkqRYa3zp65r4XyKqNk98EYyNtj7ZASe7T9VAjZtdZ9EIQ0H1IzcLSfX+mP4N+S8C+pnayc/LU/Ie7OfFEut
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 04:20:26PM -0700, Paul E. McKenney wrote:

[...]

> > +static inline void queued_read_unlock(struct qrwlock *lock)
> > +{
> > +	/*
> > +	 * Trace and unlock are combined in the traced unlock variant so
> > +	 * the compiler does not need to preserve the lock pointer across
> > +	 * the function call, avoiding callee-saved register save/restore
> > +	 * on the hot path.
> > +	 */
> > +	if (tracepoint_enabled(contended_release)) {
> > +		queued_read_unlock_traced(lock);
> > +		return;
> > +	}
> > +
> > +	__queued_read_unlock(lock);
> > +}
> 
> Shouldn't this refactoring be its own separate patch, similar to 4/5?
> 
> That would probably clean up this diff a bit.
> 
> > +
> > +static __always_inline void __queued_write_unlock(struct qrwlock *lock)
> >  {
> >  	smp_store_release(&lock->wlocked, 0);
> >  }
> >  
> >  /**
> > - * queued_rwlock_is_contended - check if the lock is contended
> > + * queued_write_unlock - release write lock of a queued rwlock
> >   * @lock : Pointer to queued rwlock structure
> > - * Return: 1 if lock contended, 0 otherwise
> >   */
> > -static inline int queued_rwlock_is_contended(struct qrwlock *lock)
> > +static inline void queued_write_unlock(struct qrwlock *lock)
> >  {
> > -	return arch_spin_is_locked(&lock->wait_lock);
> > +	/* See comment in queued_read_unlock(). */
> > +	if (tracepoint_enabled(contended_release)) {
> > +		queued_write_unlock_traced(lock);
> > +		return;
> > +	}
> > +
> > +	__queued_write_unlock(lock);
> 
> And the same here, so one patch for interposing __queued_read_unlock()
> and another for interposing __queued_write_unlock().
> 
>

[...]

> And is it possible to have one patch for qspinlock and another for qrwlock?
> It *looks* like it should be.
> 
> 							Thanx, Paul
> 

Thanks for the suggestion, Paul.

I think separate commits for the read and write paths of qrwlock is a
bit too fine-grained, but I like the point about mixing refactoring with
instrumentation and keeping different lock types separate.

I'll split this commit into four.

    locking: Factor out __queued_read_unlock()/__queued_write_unlock()                                                    
    locking: Add contended_release tracepoint to qrwlock
    locking: Factor out queued_spin_release()                                                                             
    locking: Add contended_release tracepoint to qspinlock

