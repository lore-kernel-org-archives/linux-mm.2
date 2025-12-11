Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73AFCD41C2D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB09E6B0005; Thu, 11 Dec 2025 07:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B618B6B0007; Thu, 11 Dec 2025 07:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A503C6B0008; Thu, 11 Dec 2025 07:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 912E76B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:26:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E61B14011A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:26:48 +0000 (UTC)
X-FDA: 84207114096.05.A0B1D36
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8CB1D100013
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:26:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=K0YdkMUJ;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765456006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvaOJBAIvNxAg3dFoJJOVlV+NfsswdVw/SLF3Bn6Td0=;
	b=7kTtTXq7iBLHp/dMcyWKzPu9xaWaocYOGQ3BJZwgqpZmXezFZFF9kujcy3r3OlnHJAsQKR
	UQDu1WxYH8tsgIRW/5okVYIWfduqDwDlKRCsxpfv0yVrcBx9UEcBNzyQVZhVHC33/2xWzf
	lbFuJxcL7igVaivXIDCA0VBAZ/uI0nY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765456006; a=rsa-sha256;
	cv=none;
	b=1Sjgjd0i+WWrYfz0kPDRdlMSR78VSvYN5myMeHF5s/hcjYRmrfApcTYJCOLU36L+WAmWSW
	pCj1Heu1ycLFqze2YrN4GinIFvqDy9xQ6pRYbaSUe64MJwQPTK2tMsRoRFcIJSqS0tswgU
	ZCMlcx6vh7SYpEFcFdpVeunacYXxvYQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=K0YdkMUJ;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TvaOJBAIvNxAg3dFoJJOVlV+NfsswdVw/SLF3Bn6Td0=; b=K0YdkMUJPOvWjO/lZj5urNguxm
	ZAiBii+Ae2fBpzdAfhrQzMGnUP3OjzC9L9mkrVvZjWEQfpAlquZ++ph67woSYii/zBMmEHvUQvUwV
	xzs6+MQ7OffQfjNrP9FO5P+EazF/4oqKTpptXPWWYxOTha9knM9dDMsotyDXKr+nKvwfSHhl3uQxc
	yM6eQewjA5dor1BxkERq6vqwKUckiZb1Lc2G/5lSdOV2RBYn9tqjrefNrpKqtnduWuALuI4pgaRBT
	XEHR80cmqPsAni9JZK/UPwxwegbKAnsh7vy0FTdUaPzJdezsXecMJ09nNIv88zolGW5szyo7rHJk6
	mfgk/OeA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTetE-0000000EuI9-0zph;
	Thu, 11 Dec 2025 11:31:20 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9A28A30301A; Thu, 11 Dec 2025 13:26:36 +0100 (CET)
Date: Thu, 11 Dec 2025 13:26:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v4 16/35] kref: Add context-analysis annotations
Message-ID: <20251211122636.GI3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-17-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120151033.3840508-17-elver@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8CB1D100013
X-Stat-Signature: t53sws5n9semi5ghae8to7ndg4pn6pn1
X-Rspam-User: 
X-HE-Tag: 1765456006-616632
X-HE-Meta: U2FsdGVkX1+mMiNKCvmqgVLv3qdzt4HKAM4eK5+s+mVWjFAkCblykUROqwxyI0gju3zs9DpNnhIp/+wHaTtuAgsS4viQ8URAiMWLUYeMcd95F8XJP6h/5z470ibE7KVVhdmgog8RxqVg7bkerAUgKkiMZst6FUQf8rbOV2r3AMEe5oNjS6jmay9sXlTLbDBj6C0kuCi3ZapQke/TRbt4uyXR5aPahKGxcC1kUvBOwVcyglJZHT60rdR9I3qygIoAELqRuTYCcDEpqIGfPf3ROuQW58uuS/giVAqB8AK+RZqKYCfEU/ilTWmKA2qc6X/YXeS//g2nQ5Ll0Xy451vQ9TWTzhZaJdV0JKRSGEIL3PX4nTd842SZJ/OFAjVCUqM/ONxa295GT355Iyfe9bzF2PBdEszEzjSYlHSC09YTwFMv2eit1aKKMYqeX3HIBTN0fl1UXh6ukc3p8Fxx+cMcMvS0ByT06Ga9iitFnyd0ySyKn7kJspe3M6C4+VOqOFFZGEgCmSINe6ZxbmQXBJC2LcMkbW3+2t7jrao0lXgLXUexqRg7GXa+HJ6zTGq6cY155a5x6s2WK550ku1h1eaixgz3XhCwyQSQ2nDl4KSsr2Ht7CKn78fRwBjAzmojtjQZ6bdeOpIg3KbSTbY3O0F60GDXb0oM79K4DU7ZFNDo9fJ42SNSbBlsOq44jM1KGhdWIVNM5Od5aSZY7Vx2Sw66qu2th23x+andW33tHu/cAhBOd8GQ7bD5DFHoCxcdH0iH77Bu8xD8ZlkZa7ZrnW+t9fQE6UjgrjOFjwBCRv/sxsM72N5S25EFAfqtfVTUpzcEsBORm8BIYxdvLiecVBsLjqCSPw8ikhEInyQn7ILfRs1RmvmK1pepVqmTS91uks/eUgAhSRQk6lGWsVCKmFiyrMWMmMWyq4Wjwr5VvX+HL04yzYTBKwdmgpOa+UmlMfFO+lHNkfihpI7VlTdY0kq
 8TgWVEIP
 qReCJwumG/6iZG6RKnBhI3DO3m3+Nl3MVTd6gYLtpE0I9AoOeZ+2LjwERQjCUWa8/HCgKdnyIV3iNvjrLwhFtSsgAYzZ1yfT0/741GxrfuUISBHRrFjOjtP2ewpGOJFCFZd6fn8Uw09YFm4t4RIvMlIg55LjdAZQO6chGtRgRmkGVujXY13+zTpHPeUyuZQYPXasCnBm73+LFiwv3hHOoAGtkwetjTROlq4dgnsnO1u4bdrhKvIJLs/DkXIT3/GG5tZXNbQYCQKGarppkyiVSNmSsn1rFqtoSLrEmOFEgMZ4fYLzop7J95nMnyQmY29kejSu6E7TN/Ag4EowbfQ2GLAqPFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 04:09:41PM +0100, Marco Elver wrote:
> Mark functions that conditionally acquire the passed lock.
> 
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  include/linux/kref.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/kref.h b/include/linux/kref.h
> index 88e82ab1367c..9bc6abe57572 100644
> --- a/include/linux/kref.h
> +++ b/include/linux/kref.h
> @@ -81,6 +81,7 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
>  static inline int kref_put_mutex(struct kref *kref,
>  				 void (*release)(struct kref *kref),
>  				 struct mutex *mutex)
> +	__cond_acquires(true, mutex)
>  {
>  	if (refcount_dec_and_mutex_lock(&kref->refcount, mutex)) {
>  		release(kref);
> @@ -102,6 +103,7 @@ static inline int kref_put_mutex(struct kref *kref,
>  static inline int kref_put_lock(struct kref *kref,
>  				void (*release)(struct kref *kref),
>  				spinlock_t *lock)
> +	__cond_acquires(true, lock)
>  {
>  	if (refcount_dec_and_lock(&kref->refcount, lock)) {
>  		release(kref);
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

Note that both use the underlying refcount_dec_and_*lock() functions.
Its a bit sad that annotation those isn't sufficient. These are inline
functions after all, the compiler should be able to see through all that.

