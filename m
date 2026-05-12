Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BBC5CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4942D6B0092; Tue, 12 May 2026 08:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4446A6B0093; Tue, 12 May 2026 08:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3826F6B0095; Tue, 12 May 2026 08:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 286F56B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:46:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6795C1CFC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:46:06 +0000 (UTC)
X-FDA: 84758740332.11.BFAD4DE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0D91640006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:46:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cnPiN3oT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778589965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxNlaTzC5bFl5oe0izqxrB7/VUScvvXxN9sPBAhg49w=;
	b=XS5L0RZShazL/hz1JYo7ucaIUawiwQHjLKkK74qKPnYT+L57gTGkcaZfo7i4INo7r7ytzV
	CpbNxegpeOfsHNgVoYdsAMnQPlIcw8lQGU6oCqUohZ6fDfCaguL2EvcrYyIX8L9IQL5MrN
	i2dvX8tbTy/Fqe2zKsk95xsX6c9Tp2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778589965; a=rsa-sha256;
	cv=none;
	b=S0zb2RacexKm28seTVKHNo6XQVxBIjj24deyXcCvn5IpmkGqTRaJMCv5r0lGdT6/SG1AzY
	O3W2iTG3P+hLM0EkqBLkqCoq1cBG7H2iBwAbOArYx9mwLaviBH6AjncP5OxmGWX9jNGrZw
	lWpDuC7CMxMHflf4A0Ub0yaD3GFvBrE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cnPiN3oT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jxNlaTzC5bFl5oe0izqxrB7/VUScvvXxN9sPBAhg49w=; b=cnPiN3oT4SiReKTwxUbP2nS9sJ
	wEfrtZz2+QgfmVLNt+XIdUGz2WIIVxqy4fj1C/9XSsEu3IbnLRth2BC19QJmkPZkN3PdwYix+HtPD
	bIE9mTH4q6C/8nXSjZ3VwIBfjSHG7ai6F+z215UZlFaAwG/wxcYSxII+FPMpPffAFV42nDbLDHN63
	HzCal3iQTqamwzJzS6SwbBZ5X3QSft9NIZ7+aXo6l/BfilepdllJ68FRKhtTN3R6N+JZPLiNJMmyH
	iVe+JMhoRZkg12IUEab+irI18eysRjIIDLQb2mAOMXXsDN+wYiVOsycE1vGlVIfIqDx8iDj3aagRq
	dYT5HATQ==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMmUo-00000009kMX-1yVD;
	Tue, 12 May 2026 12:45:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0448C30119C; Tue, 12 May 2026 14:45:58 +0200 (CEST)
Date: Tue, 12 May 2026 14:45:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>, Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] cleanup: Remove NULL check from unconditional guards
Message-ID: <20260512124557.GD1889694@noisy.programming.kicks-ass.net>
References: <20260512071510.92451-1-d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512071510.92451-1-d@ilvokhin.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0D91640006
X-Stat-Signature: 54rz4oechtgmrh3tx79qu59p64kzyacs
X-Rspam-User: 
X-HE-Tag: 1778589963-98951
X-HE-Meta: U2FsdGVkX19wvVCA64YUeny7YzGTYqkmz0aEloys0in/eOIiKJMhVoKVLlD2nDJtAxM+oJlm/oYjStfSyv0JAjlwnfFnwDkdJjbLPjGwrQguLEnM0liVaEL/KZhAyS3cEk+IpR+eTwtzKm+axA6GjqUUhiQF81x6q4+EPkDheN9v7IzCTrp3SkNmSMw7vCLptnL9TjGs4bufh+nYuZ3IsYM10SJOO58pN0/HbOqC+62UeEjU2d4HW+YyEI6jDhfX90rxIa+TZpmFoGkS5HHHUaAat+eb+gY3ypKquWOjVscWdnTWJACgZDSuImeo6wTAZjp9GqVABYW7x7hvOWSsd03q6vz1w2Co16DEud06QyuI81ryuZRfXjfOxMPkuTL0DLHh2gyIRgQXILrH4COp3uIi+djmUBajAAShlVXMyo5ixxu5b6WpIOxYdHmPXDFEIkfEEL3MeeITN7LVxKfLBrSuyvjoB5CYEr3CU/ubh0U3yIAh5Y77kcZsYX6lWS2pwvpaI9I5l/44sOD0mCAvSfwfisf3Z6CyWcIgQg5+GAqnltSajfvVpYpGPoLErtThTu8tx0DNMKqoTqIS22+Z0NwEEYttG76cpg1m0fTYqKFdH7kFc2GBYlQtP7T2USGoigL4mZbOW9FpvN1mDMfcuipod0ewW02SqS0v9kIvD0gPLUnxG0zfPSm+ywNaNJc7gJ3Hs1RZtnmaE0cgYG1UGxeiVoDVCdvrsfZVghPSUKTnVDlmb+LE3p4vzouMGon/jUqI8E84wNbsBfjbq/6sR5p2UZGGf1zdO2KWah0JNfV+PjPEPLVcaNuX7C0zs4V/oiQSq+EAU/kW+SJcxEy/SPmxPibJBNz4Ca2gzJt3MOJ/bIasgBpx6Q/Ss94EYt32ry5ybnfMj/JR9ysfd7WIZp/3k/45o+T8Lr6VECfPghU84SxjuowDyCr6yCqb6tfrItFLaKBFDyZZGNmvYdC
 pOZsa/zf
 ImuQeRirJYyRoBBzFsWm2ijgM7Q8yvd5yAU8DW76v/8GjUN+CR/U4/iNOoUsnpNVG1+0nfjTsdCX4V1ZfQ/LSN8Eebf38j8vS+TtUZzrlcMhKuAqKTLBtsrQ8R03NjpJIZ/3tt9Dd1UAAX/Ze5b0tROenrLWXp6gWET6rKKcmcA9n1o9L2370m5oOsEG3XK4sCsvRYqYLX/eWzKmkvN5zQFMZ2YcJJWzgFDM2YlrSczXmGqU7UWLrY6LgxHeNB762yoKjXljx7BCBKDKVN12zwynZllCP9LeDzwMme/7U068PENYWcd1XnlEvo+WDajvg1FXz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:15:10AM +0000, Dmitry Ilvokhin wrote:
> The unconditional guard destructors check whether the lock pointer is
> NULL before unlocking. This check is dead code because unconditional
> guards guarantee a non-NULL lock pointer at destructor time.
> 
> DEFINE_GUARD() and DEFINE_LOCK_GUARD_1() both run the lock operation
> in the constructor before returning. If the pointer were NULL, the
> lock operation (e.g. mutex_lock(NULL)) would crash before the
> constructor returns. The destructor never runs with a NULL pointer.
> 
> DEFINE_LOCK_GUARD_0() hardcodes .lock = (void *)1 in the constructor,
> so it is never NULL by construction.
> 
> Conditional (_try) variants: DEFINE_GUARD_COND() and
> DEFINE_LOCK_GUARD_1_COND() use EXTEND_CLASS_COND(), whose wrapper
> destructor returns early when the lock was not acquired, before reaching
> the base destructor since 2deccd5c862a ("cleanup: Optimize guards"):
> 
>     if (_cond) return; class_##_name##_destructor(_T);
> 
> As compiled by GCC-11 with defconfig on top of the locking/core:
> 
>     Total: Before=23889980, After=23833993, chg -0.23%
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
> Changes in v2:
> 
> - Expand commit message with detailed reasoning, why the proposed
>   change is correct.
> - Rebase on top of locking/core.
> 
> v1: https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/
> 
> See also [1] for relevant discussion.
> 
> [1]: https://lore.kernel.org/all/afCS4d4YccQFtvpi@shell.ilvokhin.com/
> 
>  include/linux/cleanup.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
> index ea95ca4bc11c..1410effa8780 100644
> --- a/include/linux/cleanup.h
> +++ b/include/linux/cleanup.h
> @@ -397,7 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
>  	__DEFINE_GUARD_LOCK_PTR(_name, _T)
>  
>  #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
> -	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
> +	DEFINE_CLASS(_name, _type, _unlock, ({ _lock; _T; }), _type _T); \
>  	DEFINE_CLASS_IS_GUARD(_name)
>  
>  #define DEFINE_GUARD_COND_4(_name, _ext, _lock, _cond) \
> @@ -491,7 +491,7 @@ typedef struct {							\
>  static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
>  	__no_context_analysis						\
>  {									\
> -	if (_T->lock) { _unlock; }					\
> +	_unlock;							\
>  }									\
>  									\
>  __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)

What about class_irqdesc_lock_constructor() ? AFAICT
__irq_get_desc_lock() can return NULL.

