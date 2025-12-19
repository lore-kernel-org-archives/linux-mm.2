Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89768E668A6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 23:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED01B6B0088; Fri, 19 Dec 2025 18:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E776E6B0089; Fri, 19 Dec 2025 18:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F266B008A; Fri, 19 Dec 2025 18:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C42E16B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:30:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64CD7160179
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:30:46 +0000 (UTC)
X-FDA: 84237817692.28.14C8455
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5A35720002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:30:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Otzhs7SN;
	spf=pass (imf03.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.215.193 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766187044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xjhz9NvSIj1nkwStS3EsBbpnWvjG3hzX9yFNjSmaNpQ=;
	b=vt7qzxc2zLF6VnEmcJj9Ecrqn/cqK4KpIUg4Qk1ypisEMO5heXpy3GJjd8XCtVjq5Q2Sqp
	rF8FzqP1QqLiNRoEbhCnkragnyuLdj35pXsDZPiPcsxtWoOzs5ICdJlMkudIsJI5PtpzX1
	opmDJjFqTx9w01jP5zr9HEDDE2mvwEM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766187044; a=rsa-sha256;
	cv=none;
	b=WdoMGytS6zjjG5exqw6sQjt+HtPf7g7XIlW+t/bIsbWst/pbZmUjRwvxBiZthDurvVzkpG
	kdOx/nMOw/LIYDH30SMMk+Lb67bcT/5MzEaIodfYtSewqqgSvWh5MbCtxlYdggSn2ZgEiE
	X2L7BB3RkKW0Na7xIi0lB6JJi9LXCw0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Otzhs7SN;
	spf=pass (imf03.hostedemail.com: domain of bart.vanassche@gmail.com designates 209.85.215.193 as permitted sender) smtp.mailfrom=bart.vanassche@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-c05d66dbab2so2354735a12.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766187043; x=1766791843; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xjhz9NvSIj1nkwStS3EsBbpnWvjG3hzX9yFNjSmaNpQ=;
        b=Otzhs7SNmLIBKSsjZA5SopY3a/XL4hcJU3jtaBZLKz9bD6VLB+HM9TXpvVmbf6v89v
         LNiigp6hYgx6czkjZJ1u1f0463EomFwiaW9OCVCI4KfjiQDfblHKF3L88KWbxbuKC/R/
         4SPrsMpETKl+xIIrLbnYWpmYTGyeNh97F52aAiePDr7bpffPU/BKf/9JmAFn+9RpPigr
         aP0ABdlnHEs6W+28l66v9uaOh+F0ajGov9CDWdiX6zf0AKKT3vR533tpO4TC39MbSWbF
         b/1sCMY1iQJlAHe+2+HxycNFnrUhpntTwbC0qf8jjV+SJmSJF1i/HtnRsrRnVWTW1GXu
         OCGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766187043; x=1766791843;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xjhz9NvSIj1nkwStS3EsBbpnWvjG3hzX9yFNjSmaNpQ=;
        b=tPf1K4WuuWPCv6pvXZM1lNf+sq370dj3U5NO9ctF52pUyPYIIVdBSxTl4km0tFQC00
         pe4yn9fs6dGGfOIAjdJGqtkBC2uKO2QhFqt2IogCayMMdCXbyWHG9N+lp8xP8SnMxsTY
         iiA0AZvdBpw4hrKt8DbQP45FugR2N9bmoiTuIL8bqCinPidKiomLBrWkRPrhV5o55tV+
         eVXGeuTekjnmcccXIKWdoj4ViORV5afL2MampwgabMoVxmSXYDn7/uG9e8jUVqxzqDAG
         poR+2bNNQBMzOfop5XBv7dgiwqFHhiJr541oMkoqKPfZueykvmYybvZsgfIeh1vQsyQo
         JBbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJw0cm0iW9OjccJzRCOKCaBzOjB/amDaS8V/tnJOSGgPk5KlI5GR/N00WhP980UrH719ZxJ4H2ng==@kvack.org
X-Gm-Message-State: AOJu0Yx6TOPzDwvhOugmhhqqrxnCWdBPXoxLA6uLX/nyho2ATKJ1WATo
	l7SfmR22FxHZT46sGWoX4WBZJOYhkIbi/Hsj0nU3cfJ23mMgJd/4xabbYv1m39TdA7g=
X-Gm-Gg: AY/fxX7kbtA51wYZ8DC0+rY6jRkKJDpVChdYn/XYzJr/qgcSeoy3Thr7g2m/O+hA7XB
	U/qbaWaemdFT3XhcrBzasB5X6z0G/j8QAHvjRQ0IKa9dsHtSGdgIkfW4tVZkuSQqpiA7j/WRVbi
	Zb7BqVbcZL3icb/aSJcDlr+MEfXUOhXIKIaWujqD4gTZnL3oORxayaMBLzcZLuZDgvG4p3/Fo5B
	eHQvT5RnGgMWfENqcl/eJXKnW0+bfQv+gFmmVHoY7TCE2HYcbntpGig0YQ5D44EoYZYMMcuaEfh
	mB++DWh0+RZzkxBQnagE+fJrcsbbAQrm1e7RFqW7s/KAKKIOAS152aJpR6FkV2UN+Gvakl97DL/
	7c/96/OBvg+fYz0S/OTrlJWjzoWksmilYG4eVzg/FcPJi81YVIxHHp/GhYpc7vIX9hXzZIjD60e
	BiyuNZT9EWOxLg3d//q/cocFEr9Q6yuGblp6KS7pfUHdJJCsOcPLZpMgXiaQzj0ukUO8glN0qQ6
	8tvpPMxVw9LUNhDsBrC9EEbZvfy+g64az6l2DdCtq4Zo9zivoYRdgIVbRwqk/w6blXXpmGdg5w2
	dNQ=
X-Google-Smtp-Source: AGHT+IFD9VEfhTkWGAUJ+KrkgUpiheofAxrSZVwNtEffu0+8gx+hrdlGu9tKXSDKwQO+mDr4xt9mXg==
X-Received: by 2002:a05:7022:3a83:b0:11c:b397:2657 with SMTP id a92af1059eb24-121722be81emr4954809c88.22.1766180747284;
        Fri, 19 Dec 2025 13:45:47 -0800 (PST)
Received: from ?IPV6:2a00:79e0:2e7c:8:5874:79f3:80da:a7a3? ([2a00:79e0:2e7c:8:5874:79f3:80da:a7a3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05fe99410sm10260116eec.2.2025.12.19.13.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 13:45:46 -0800 (PST)
Message-ID: <ae957ee5-cb47-433f-b0b3-f4ac8ec7116b@gmail.com>
Date: Fri, 19 Dec 2025 14:45:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH v5 08/36] locking/rwlock, spinlock: Support Clang's
 context analysis
To: Peter Zijlstra <peterz@infradead.org>, Marco Elver <elver@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>,
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
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-9-elver@google.com>
 <17723ae6-9611-4731-905c-60dab9fb7102@acm.org>
 <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CANpmjNO0B_BBse12kAobCRBK0D2pKkSu7pKa5LQAbdzBZa2xcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 45dr7sxpwt8ry4sbsoarre4abi3yw9gc
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5A35720002
X-Rspam-User: 
X-HE-Tag: 1766187044-318925
X-HE-Meta: U2FsdGVkX1/C6Rw9IMwR+udnX0ZRf08Pyu80899yxruG/LOGlsrryy2s18eyTUDh5eVkFqTKFcw/N8p5rCgDor6ivLTIyuSQatSjQVW9/skm8KyPh2bYGbndd/Eqf8uoPNYyw8mquxUU+wjZNHZQMWNjfbUGjbXcXpTJ4OYKZp3ACm+ww25TKAjChTfhXSCodMJXk1mU7QiF8P5qeVv9Pnzji9TocdA+3oPzl0BTvAuYLd/jxxn/zwGXSe8tqv+iF/KUkZZ+z1CszbkxhMsyJNdRSTUIUds5jqK87WAVPiKZZ0mmyVMHThXV6aKzZKGXv5S2YTe+3Z6UMGBVa0M6+PHTPsYt+HMWwZqwix764nSw2e1YD1ntB+G9rq8qxXnXQfnFC4TbqDqJZ8ZGWXjKTNebu5Jt91hIzUmZoqySEKVxhmtDy11UfZo3gKbKU5REdT1sd3CWGtWTBvllWgERDFpJQcKnJaogpxjNepXZdDme+0pbeEaAFFj4kitQ96j8r+H6LxwC4ZC/vWX/bOkrSfyZqSH8oJuvrTLGo2RmN7zyHzXx1JLSuCtaH0/RGRXREcmGsQaYep1RzA+jYMfcYFjYj67ytlRTTvit8UdOHC2uCWdXbatgjfqnORSzMNQKnc4OW5uc+tPheYd75r2Ne+uUA4ts+PdHzBcl13NbycC8KR1lT8P1qpm4vPrczAybvzGPa1X5NT7DIUfIA1DPK3FJtvz6PpFMg44kA0RuzMPLWQbXWlVuXyWp+WXHAfGtrNhNZOBjkX65S90nHaKmZiFxyo1JDDqnkzbGdlV/2Smr6juGcnBkUuDX0XSVCvNKBh9vU4TlMXj1SzNPQHs6a/MesOLP3w29XlFtdr7jUdBTNH2tx9n2kk6zOnAudUFXXwaS9CVaJRBnuRB8exgBafme7OApUOn6EjF0h51MWmtVC+pJnBDmdH1jyvVwLSaYi4Dd7gOI6AH8oVkGY0d
 MBUYIqDt
 VtobnZ/FeKck8M1D4CY8la/E3XuRn/g7CA9Fsr9QjOc9CS+wLjR6SoUfPqN7AFkN8+Au+JeawD+9DOegEfiCmHdf1jiMAukx1RI0+HiBoC9TjELTjtxDuvJGMNjCcv5+RucxNqmWkKYnow5uB7/qX/ugK3gqucEGVNDJ4DwBUFAugwmv/BfWWKvsNEb2ac609wfHfwds92Z0Kg7+GVmaYDYmatE0BNKUreXdtlJgFM5xhvNBqtDPBSVHeiJm4bZbZi3rUM7M+jFJXpIUQvXtkkMR9aQikL+2ATq4AB0sBq31iIjZklgKZwNT9HLGWEAC63csaix0m96UsLycFEcfRsGjrV+RUnk75QgiIZAeCYUZQtaGXhD/Fx9PNu6m14Alq1DSRL4FhrLMyktxEv/lA911PSee4bs2VBsSs/ZIygJEsC9TJhov8zCvfwybmtReBcwcX6zDEbOaX1cqjmuioA90YiMQmv8rzaRyfX38ylmD527vFmCpmUXM5LtjG/4ILFsciJpLxwPGZsVFWUFc5yUR7eYoig7g+QlEbaTI3tWGJvQ75yD5jm05PQhP+HZ7AblwF80OSOHP2vtOUxPNSVgFXF7nGZGD9qY6JIozftNs7/VDN8N/RNElPT6eISVtK+VsLrgUZPj2WUeu3hgnlHD2pX3zXjNaBcHamp45lv5BjdlIzxCyawz1EKOXZsh3nzR8/PoK+HGiYhfszA2fOkbOgRDi7WeM0Y3UxK30ppqKioTKWX910PzH4LeEEOCazr9vz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 1:02 PM, Marco Elver wrote:
> On Fri, 19 Dec 2025 at 21:26, Bart Van Assche <bvanassche@acm.org> wrote:
>> On 12/19/25 7:39 AM, Marco Elver wrote:
>>> - extern void do_raw_read_lock(rwlock_t *lock) __acquires(lock);
>>> + extern void do_raw_read_lock(rwlock_t *lock) __acquires_shared(lock);
>>
>> Given the "one change per patch" rule, shouldn't the annotation fixes
>> for rwlock operations be moved into a separate patch?
>>
>>> -typedef struct {
>>> +context_lock_struct(rwlock) {
>>>        arch_rwlock_t raw_lock;
>>>    #ifdef CONFIG_DEBUG_SPINLOCK
>>>        unsigned int magic, owner_cpu;
>>> @@ -31,7 +31,8 @@ typedef struct {
>>>    #ifdef CONFIG_DEBUG_LOCK_ALLOC
>>>        struct lockdep_map dep_map;
>>>    #endif
>>> -} rwlock_t;
>>> +};
>>> +typedef struct rwlock rwlock_t;
>>
>> This change introduces a new globally visible "struct rwlock". Although
>> I haven't found any existing "struct rwlock" definitions, maybe it's a
>> good idea to use a more unique name instead.
> 
> This doesn't actually introduce a new globally visible "struct
> rwlock", it's already the case before.
> An inlined struct definition in a typedef is available by its struct
> name, so this is not introducing a new name
> (https://godbolt.org/z/Y1jf66e1M).

Please take another look. The godbolt example follows the pattern
"typedef struct name { ... } name_t;". The "name" part is missing from
the rwlock_t definition. This is why I wrote that the above code
introduces a new global struct name.

Bart.

