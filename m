Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D803C9EC67
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E678D6B008A; Mon, 12 Jan 2026 05:33:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3F226B008C; Mon, 12 Jan 2026 05:33:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E096B0092; Mon, 12 Jan 2026 05:33:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE5106B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:33:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C1748C7FA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:33:23 +0000 (UTC)
X-FDA: 84322949886.13.5C6239E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id CF4EA20002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:33:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f1DEsroA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of maarten.lankhorst@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=maarten.lankhorst@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768214001; a=rsa-sha256;
	cv=none;
	b=7KoGsSv6nliXbp7bRX9KnlAwsd0INvW/GZ2bEi+8tvuWp92DH0gHuPoC5txemnjoQnsfb7
	FAZUNxDQXMJ9Yupq/NDuye1U/GsuPb+Fc2o+06hQUnLnrDcmtEV+LQZ3VN0N4NmDBViocY
	r8iRKINCLvOKla5yFdVLEWXJzeHWq9E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f1DEsroA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of maarten.lankhorst@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=maarten.lankhorst@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768214001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSeDYcO86cEIXpPJgflnLo7t2+igEm9lsEiKHctLN/c=;
	b=T+u5LiX3EzM2S12+NIm9A2969fy66gWgttAmns4rSqg8BlZRH23ouCROc9y7DTrqgmukGD
	6DzAKThqDe2HeZEBiiB0ZuqX031uoYUJoZrSTIWxltt9pjlYOJnAYdiCNdw5JoX174FKQw
	8+JI9o9JqJ0Ws9G2eUS9zAukNlB/A3Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768214001; x=1799750001;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3WvoLxWPBX/nvNBdAet0EG4DRqalXwTIWl2WlwowKOE=;
  b=f1DEsroAliufYEGFgcBTMpIIutR47BAPeWXAkWt3z+7xXgajhIAEoEqa
   szrAVYj/CSsq+ApZVMpOS4Q12pWbfNtJE0bwl0DJmZ1T/d2/WgJKT07UH
   vc1GmAwF0oFLYQyjWJW2K/RXeIzrzjMv3GRSklzd/aDXhp/2uGmXC8z5z
   2J1huaQHskHtTvGnXVc8NuCIoKwyW5q/J73kLg8oNOLczwUXEQWVzkza1
   yi7/sLYqEUa6G5QPgBNG6wFQM+5fjPdNirOpP90DM/jM7pdGKSUNpuq0P
   AvI/yI2KMNESHeCAB830EPsV+oT0ZXJQYMFFqoqPlxcMUXSoE7mlgNMyM
   g==;
X-CSE-ConnectionGUID: sESuoh5iQvu/N3CCfwWnQg==
X-CSE-MsgGUID: gWdeGIj+T7GeTivDxbUgDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80939950"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80939950"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:32:39 -0800
X-CSE-ConnectionGUID: KeVRm3ThTIyu/02WLS2Cvw==
X-CSE-MsgGUID: T5zF6Dw6TdejExXJJsJSFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="241588226"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO [10.245.245.90]) ([10.245.245.90])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 02:32:28 -0800
Message-ID: <1502e5eb-0ac7-4581-85ce-2f0c390bd7db@linux.intel.com>
Date: Mon, 12 Jan 2026 11:32:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/36] locking/ww_mutex: Support Clang's context
 analysis
To: Bart Van Assche <bvanassche@acm.org>
Cc: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
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
 <20251219154418.3592607-21-elver@google.com>
 <05c77ca1-7618-43c5-b259-d89741808479@acm.org>
 <aWFt6hcLaCjQQu2c@elver.google.com>
 <8143ab09-fd9b-4615-8afb-7ee10e073c51@acm.org>
Content-Language: en-US
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
In-Reply-To: <8143ab09-fd9b-4615-8afb-7ee10e073c51@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: mjy573ffx9h9ettikii1dqu793xsaif7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CF4EA20002
X-HE-Tag: 1768214000-154412
X-HE-Meta: U2FsdGVkX1+GLOLquExosyVddmywI+1kA02nm2Lbs3KJpc7UcqhEB8uvcAFmF6EYrg3TogZxjHQhcNv/dQBb8qca+67UDqS/vZKdioA0ah7NY1uZCbfdXVDnyItDU3Xgxtba9tcntZULTKx8dBrl+QZKmlfEBUlxNPZCVNqsgaMbEteU+ZQ4hnLldAYTf+Ln/Yqd/v/oIIXxOVJXeyDa0dmiCOdNcTC048GvfiM4a/uO1rxXh0FCmyYrAP602zYOsJE7UfoqOWQ+L0jyE1IbYZ8aoclhAGlIzGBd1nyiYoLCnEU0Ab9/ZVst92ExVzvPm2WYHZ2QOAibHZvIvIlBDZfx45EyN5Uik06Meiu5UEL5LhnzStE94ITwHyzfDLK7SbCzkgFhXjSvjzU5fNg6/LCdAPlHWHv6L5IMcnDbca4bFZK5mPJo96LU3eYJR2lfLSdDsyZ0yZXnoXsjdFUURzXRi8/tJikT1FJk1NkyH+2PI+GLD1UHOkWkMD8P2OPYH0QmTszmpmVfnY5yNrfknqZROIWOdFMQkJmbSB8g4DqVDUNq82iqCUitI3sspn33zFbga6cxs+YAdjde+txsKF+pMJraLNEUfY23vd75cXvLDXXCorHXwqdFQ2ia8uP+8nGYpPSB+2Nmp24toBwW1wmX3hvDJBGVwiXwngVTJMXWQZ1mLbwiIHbsdzXYDpszS6GTJ0hteRwcw0hDwLaXj0muRFjBjUzaCOQXUyuZenfVWNA3N1fDtzaQ8OZtdr0hDgCA/0SQWpJMKESHEPJ1IdV7en5iR0qA+2kLcm295KXYNy4K4+OrJ/SCseItkuZcQ5fHmBbtMGY2gpCJkHk0EOBaRp4/sdcBo8xQS4xlbaKzXfa4x0NM3SBFzpl3FxGksU3BWAwWDldJibR9z6mNTZYTWT1giywgPH0ClJ1w2Ne4bGDSuFYwd6tvrQPZlVyvp2HgTF6ZUwtyHvj6OsE
 LKhRF790
 5A1IBvVkOZ2OF1sa1Se8ABbeNng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

The acquire_done() call was always optional. It's meant to indicate that after this point,
ww_acquire_lock may no longer be called and backoff can no longer occur.

It's allowed to call ww_acquire_fini() without ww_acquire_done()

Think of this case:
ww_acquire_init()

ww_acquire_lock_interruptible() -> -ERESTARTSYS

ww_acquire_fini()

Here it wouldn't make sense to call ww_acquire_done().

It's mostly to facilitate this case:

ww_acquire_init()

ww_acquire_lock() a bunch.

/* Got all locks, do the work as no more backoff occurs */
ww_acquire_done()

...

unlock_all()
ww_acquire_fini()

If you call ww_acquire_lock after done, a warning should occur as this should no longer happen.

Kind regards,
~Maarten Lankhorst

Den 2026-01-09 kl. 22:26, skrev Bart Van Assche:
> (+Maarten)
> 
> On 1/9/26 2:06 PM, Marco Elver wrote:
>> If there's 1 out of N ww_mutex users that missed ww_acquire_done()
>> there's a good chance that 1 case is wrong.
> 
> $ git grep -w ww_acquire_done '**c'|wc -l
> 11
> $ git grep -w ww_acquire_fini '**c'|wc -l
> 33
> 
> The above statistics show that there are more cases where
> ww_acquire_done() is not called rather than cases where
> ww_acquire_done() is called.
> 
> Maarten, since you introduced the ww_mutex code, do you perhaps prefer
> that calling ww_acquire_done() is optional or rather that all users that
> do not call ww_acquire_done() are modified such that they call
> ww_acquire_done()? The full email conversation is available here:
> https://lore.kernel.org/all/20251219154418.3592607-1-elver@google.com/
> 
> Thanks,
> 
> Bart.


