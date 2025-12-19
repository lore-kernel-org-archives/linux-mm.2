Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7405CE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBAE96B0089; Fri, 19 Dec 2025 15:54:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61956B008A; Fri, 19 Dec 2025 15:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E5E6B008C; Fri, 19 Dec 2025 15:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6E136B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:54:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EDC316038C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:54:02 +0000 (UTC)
X-FDA: 84237422724.03.996FC25
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7C2B4140010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:54:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=UfehkjIJ;
	spf=pass (imf23.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0Uo17R9WMorX1SnpOAKwu8b4IBQKRGE96JfpenCXBM=;
	b=hLcxdVcongvPtZ3/bLculViRo668jpq3/kv9CCbYN2G3FJoIryH+H33eDfCErB+dZ6elOY
	Xoo7Gh6q9NiuCus0eRP5RA5Z/quEemgmlRtDsCue4vRA8A16POwFS6rRq711UQwgHQZhzA
	X5yT2XWRQtNNQwIkFSJbGmHhosYRqVA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=UfehkjIJ;
	spf=pass (imf23.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766177640; a=rsa-sha256;
	cv=none;
	b=UIU0Kjh1eS4WVbgy5iO7ngsCwY4eICT7VTdHpjsThELKCglfgJFCdctSyNBk/mVEDiOtrt
	ziQNft0xSQTi3Z1hePiIYFeQSR/+oGbPqH2crpAErTw9ZwQ7gDNcUVvo6a4eTPiW8l4fJ1
	3UMdbCAWZgiC/9tRrMjbPz+iaYi7EjU=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dY0Bb26BgzlgyG0;
	Fri, 19 Dec 2025 20:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766177631; x=1768769632; bh=n0Uo17R9WMorX1SnpOAKwu8b
	4IBQKRGE96JfpenCXBM=; b=UfehkjIJdc0Hxhy6e1QrqozCPDNCsdBaBTSNAMAE
	KsX0uDHgLFBBSrs9xSwfM3qph2C8+tbTb7M9XBr9DWnYeElRdF0N5FkNATZoOm2w
	d9a9JYW75qJFA4k5r1QWHovpAcRZQt+sieHUKqQwpbWOE9k5jNutrfaRN59H54bt
	MYntbfUUaSDX7hnAvMzk9AdUr66yGKIn+c/kBY2oO9xYFVJmWlBkVGJuHOLyUFlu
	hmMmOyvGGnzkX+vq0/0DsUm0fnGWj9DmTR9vkB421Q46RF2Bpcx1RMMwQ10vmHKf
	/mt2CDUYrOjmtKcd35CqH/Zwc2a1AjvbVgEAHtuyr4UgYw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vHlYWjU2OGjG; Fri, 19 Dec 2025 20:53:51 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dY0BC4DBmzlwqQL;
	Fri, 19 Dec 2025 20:53:39 +0000 (UTC)
Message-ID: <cdde6c60-7f6f-4715-a249-5aab39438b57@acm.org>
Date: Fri, 19 Dec 2025 12:53:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/36] lockdep: Annotate lockdep assertions for context
 analysis
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-8-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-8-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C2B4140010
X-Stat-Signature: hk364g37kirckiymth4qadac9ya1oyw6
X-Rspam-User: 
X-HE-Tag: 1766177640-555804
X-HE-Meta: U2FsdGVkX1+c74HN5Yvv0RgGK7DHrgOitQyPafwIsT8z89108PDqzaSG0RLRDDk5p7SCQgQbuKjZPTYFjGg4xKxSkNIcvRGdeBXlbJeqSpSlOEOdd3SW1ub12iBX7FE5uX0tYU5ujARDwkmGqrsq3vhenKA9qIEW7NKtxc8sKMDQHqTFtGbzz0j/88AhkQ8G64qAhimEr4eKpW2tX46Lbi8aNto32bOfcbKbGfpTqi0kZuOvl29xYI11IccQTnsRmtpbpwwr9Ju55pn6zP+8oeYix/RK/iSgQiwwXeCCVbePW0wxc0s1MzE0EAnZrluLLWBZbDaIl/CYmkFa4qJEHrv0RD5PzITPW5yohY4+lGTJ15GpHIq3avfUO8sCyBcyOCm1gbHSLN2vf1QjksvNzrKVtMJk2+EXEZSsqs5MR7QsrsLwg2u2scqt7FmxG2Mk4QvGA1EhYgaDOiLHhlz/1RNjyKmjpRmJxZRy4vO5MzE0n+l2WbE5ezROGF1daHNKu8ub1ePvs+qJWhs5KhesqBE0CBL2Qfty/K98gqdbg8oS4Mu+fZzEeFD/lOrFJp3v1I9QiD/PPafWrRvVK1dCkOn17AE3tRAVcBpuujKnOOGv9s+cvRM5J34TIen0WYCarpZ0hD98R/PVklOskhdanM9SvkbzVr2IT3AwlEBjZKEqtMMT6hYOkaZMAX/KiMdSAr00oHYW0FmOPhvj3sN7G7yjd9IRsOhNXwtrIDRzQFVDw9Uwh2hrUefN06OkwiqS2ZL6foc+N6YdQzrLnHmftsmsg4aM4222ulIP2ItFd3mSPFRx2FSDj1JPiS9rAPrqzTN9Lbf7pDnvCtkjL52xxPDN89zP6BksoLStgY+c8lhMm2rb+zl2pJGWEdOtTcXCQm8+aXcU+VbOaihMV7SdujQJ+ZMwCeEPLjddreTNFlfTA/9/8xSU8fYLfRqgmshw7zXgVJcp1e9zLyr4yLN
 m6lH1zIV
 U2stgJlGDkdN/W//pj/b8/I23A4cxgm3ETNnhFQZi/WBZMwemx8v+7ec+w4fyDRSs6lIbcKcXT7z2w1i39uR8r4RVZLmanP4BU+L4BPI/4l0TMhkW+f5Xc1SE17a3iA9NJytXNlpdFHnVDDeyd2gFC7aZme49o+jot7mY/s1DkbJo/bOQWOic212dNYB+QkkZcRzs6LRksOT+N62Lby8RxQ3S/dU3WhAyrSayhcoro+EdsNBSBlPzHnYvG6wFiiUKezp7eLSKPQICK/ccWfh3kAoHHD71I+e62DYK7aar6d5he0T/lgToQmOQ/3MRX2/sjRBbdRvl1Co8VJBhVtUYTe0QttiPH4iUPmVdo6q5ZZh3r6lcO+g4M+BCUdPZ2UeNjIZcNcRJsZyRGBLw/H72HaPnPPSJNAPcmnNa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:39 AM, Marco Elver wrote:
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index dd634103b014..621566345406 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -282,16 +282,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
>   	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
>   
>   #define lockdep_assert_held(l)		\
> -	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
> +	do { lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD); __assume_ctx_lock(l); } while (0)
>   
>   #define lockdep_assert_not_held(l)	\
>   	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
>   
>   #define lockdep_assert_held_write(l)	\
> -	lockdep_assert(lockdep_is_held_type(l, 0))
> +	do { lockdep_assert(lockdep_is_held_type(l, 0)); __assume_ctx_lock(l); } while (0)
>   
>   #define lockdep_assert_held_read(l)	\
> -	lockdep_assert(lockdep_is_held_type(l, 1))
> +	do { lockdep_assert(lockdep_is_held_type(l, 1)); __assume_shared_ctx_lock(l); } while (0)
>   
>   #define lockdep_assert_held_once(l)		\
>   	lockdep_assert_once(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
> @@ -389,10 +389,10 @@ extern int lockdep_is_held(const void *);
>   #define lockdep_assert(c)			do { } while (0)
>   #define lockdep_assert_once(c)			do { } while (0)
>   
> -#define lockdep_assert_held(l)			do { (void)(l); } while (0)
> +#define lockdep_assert_held(l)			__assume_ctx_lock(l)
>   #define lockdep_assert_not_held(l)		do { (void)(l); } while (0)
> -#define lockdep_assert_held_write(l)		do { (void)(l); } while (0)
> -#define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
> +#define lockdep_assert_held_write(l)		__assume_ctx_lock(l)
> +#define lockdep_assert_held_read(l)		__assume_shared_ctx_lock(l)
>   #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
>   #define lockdep_assert_none_held_once()	do { } while (0)

I think these macros should use __must_hold() instead of __assume...().
lockdep_assert_held() emits a runtime warning if 'l' is not held. Hence,
I think that code where lockdep_assert_held() is used should not compile
if it cannot be verified at compile time that 'l' is held.

Thanks,

Bart.



