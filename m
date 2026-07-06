Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABF7BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 10:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ACA86B00F0; Mon,  6 Jul 2026 06:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8369A6B00F1; Mon,  6 Jul 2026 06:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700A76B00F3; Mon,  6 Jul 2026 06:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 478B56B00F0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:07:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9D9412038C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:07:19 +0000 (UTC)
X-FDA: 84957924198.17.16E5F2A
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf07.hostedemail.com (Postfix) with ESMTP id D7D814000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:07:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uRaPeAW0;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783332438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2qDm5qCn56ojOGZCWOAPiLnSVNmd57w1YlcEyEv3Zo=;
	b=Kmm7z1U6Yszm1YCl8LDFhUNobr4Krrr1jyF04b5dd6DEc2vQG0YoSnXz+zCdm/jj2TyRVW
	3gENMSpG4z9wyWOZlvao16WtBMQb5VHcOe+TTM4uquzAuJDYrjXhchB+6gDBvTJV63RWnc
	YYDsTVoqq3IonxatR4cmVHKhOBBsEW0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uRaPeAW0;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783332438;
	b=1lYaq9Nb3yRYHSDBody0yMWKTvlcX1lMCSkG08/EzZ0w33YZJl7vKACMsZbXEI1wNsIDrE
	dCsZfh9Ig7Cu/vN5o62aMtzCGMT07KPf3zov5psGNvXUCHKGkFb/q0QvjcjQuz+uG1YlT1
	KIMGohHZdICxnYsch5bszu9NflGU9k4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783332435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r2qDm5qCn56ojOGZCWOAPiLnSVNmd57w1YlcEyEv3Zo=;
	b=uRaPeAW0527K2sZaauy6ZQlf9rRFKHn2Z4O2AFHWcAe2bDmpICq+Szd/Sj3qJQ+6L8KIW6
	yYhwwWumAMl5sdBzV1aq64mEQRP59pZ0l8CExNPaCPgCOqJwE6hZ+ZzQUefFXgSw12v8TX
	J4AcsYJzgoZz47mqAKxBm5RBeGFLvEA=
From: Usama Arif <usama.arif@linux.dev>
To: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Gary Guo <gary@garyguo.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Eugene Mavick <m@mavick.dev>
Subject: Re: [PATCH 2/4] refcount: add ref_trace_final_put tracepoint
Date: Mon,  6 Jul 2026 03:07:07 -0700
Message-ID: <20260706100709.1519907-1-usama.arif@linux.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-2-0ae936edb750@mavick.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8x8kafxyoez1j7xu95zm9yf9q4osjtd9
X-Rspamd-Queue-Id: D7D814000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783332437-604409
X-HE-Meta: U2FsdGVkX18G3E3PJ2zrxPwjPQNwIRtaefzhNmMx376iK5BQ5IwnL6zd1r/nTjaHbPDTEdkV3gFB/UYQUIS23al7fBFyUDIN8mDs/J8WFP7CLTYC/9x9zg2qG94Z58X7coO8h0xXEhcWpjCNSlSD/u0RnOG5AFN8fHCA70CSpvAS3rNb2ClyGMe01++vUL1NcCC2C6DBxzI2zMeosY4HndocKCnP0kXFRF8I2Hu0be12eB3UzuDz0aqJVBH8leSI5dibuGgdBShLqnmz6MpuCZRTK9uhgGgxUvlyVRL4D9PUACRpg68KWKcZb+fuXNLL+Cse6//r0lM9JkpkH5nekcsXt5QslyJv+VdcMIdfDR5XYBHT6Fgp/v4AsJvu6RtyiTIcb2OuUpDDZJSfoHZwGvV62SEm9xhQ4c/Uvn5+GybBwyuZK9t1xB84azLLDDm5TiNGzopqDUY2etPl+Mic7HJil+IgPLUcHW4Pecy+dfZNEfJ1FzDRv5ePFb/WbIcrXpK/9miotSw8PZI4SuXUr5hGbc02mZvJvRM0+ccxO9y3vdM552PP6Yb1TIG08n5MbiQhS04niR9abdmv2kc6hSYAdqA5FCjpOWZaCS/k5VyXIDJWSb5jyqna0qOC65jjYnbepgA4Fkdf7Nq2o0lIrVAcBS//97H7vwi+tkJO827LyaUAw254LPyXuT+4rcmlxD69R86BxD4oXaBAOfMdfBhooZiYQ8ITp7rjWs3Oas5TJr/gDJXr8vY7IZP2DTXueybOz0t1x+N2fUCY7sNQlPtiKnl5/+8C9PwB1NCZjkvyR7Wj9lKUvTCI76+nCT3sZWRRQrLTJjrSBCfBry+UbkK8+20d01gqfjSnpyhzwnFyE2DGsrrzDJVxSSR0kkjL6eTDR9OtXaqwH5Ej7Q9UDLeBt/nf5xKvzBTE+DTQgO3rjFFqHGHmgNJclgseKRBlgu0bSdUfuM0G1Ji3i2r
 hzgMCvYc
 kcbqFOsarkNb0GNCd28gRwKCslkAhNjmTHQKxQMJaX6wY04N3Qd9eLjNB1ciNj8ho5orqkywRlR5TfHukt/sAAhgwbiaaMStNq3/74+8PAHf1vlgOE1yr/+d8bNy67WxADfZRAh2csISQjCxSk0V6zTArOq3aIk30j4WgnkvK6tZhbmvefqUoDpq/yq7aBtngzgjKWzi5gN7YEfgbVcVfAGIyoqPfVl2Z4i1lEsbMOKScfy9xoc1POkGxu5Auo0xMpvrvgwXp9VPnmCbvGntWwwt788NlfAZEfBYHprEx/pBK2jTq8ORVtIaOrHLtcKCYB4HC+X6psY0G8JUkBZKMbD5aidp72aUHSSHk7Y81QuBx93zrLq6usWFhLC1MNuoE1fWlwWicq+v8mzlhfIpA5Js4N9Q8euiSlW1Q+MfdQIJxdVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 05 Jul 2026 09:20:52 +0800 Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org> wrote:

> From: Eugene Mavick <m@mavick.dev>
> 
> Add the ref_trace_final_put tracepoint to __refcount_sub_and_test().
> This fires when a refcount_t reaches zero, capturing the caller
> address, the function name, and the refcount_t address.
> 
> Signed-off-by: Eugene Mavick <m@mavick.dev>
> ---
>  include/linux/refcount.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/refcount.h b/include/linux/refcount.h
> index ba7657ced281..7b1fbf326a21 100644
> --- a/include/linux/refcount.h
> +++ b/include/linux/refcount.h
> @@ -107,6 +107,7 @@
>  #include <linux/limits.h>
>  #include <linux/refcount_types.h>
>  #include <linux/spinlock_types.h>
> +#include <linux/ref_trace.h>
>  
>  struct mutex;
>  
> @@ -393,6 +394,7 @@ bool __refcount_sub_and_test(int i, refcount_t *r, int *oldp)
>  
>  	if (old > 0 && old == i) {
>  		smp_acquire__after_ctrl_dep();
> +		trace_ref_final_put(r);

Should refcount_dec_if_one() also fire the tracepoint?

>  		return true;
>  	}
>  
> 
> -- 
> 2.51.2
> 
> 
> 

