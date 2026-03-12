Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21991105A589
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF4B6B00A0; Thu, 12 Mar 2026 07:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0A06B00A4; Thu, 12 Mar 2026 07:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6B96B00A6; Thu, 12 Mar 2026 07:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0506B00A0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:39:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 013021601CF
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:39:30 +0000 (UTC)
X-FDA: 84537215742.01.CED2B07
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf02.hostedemail.com (Postfix) with ESMTP id 49D3B80012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:39:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQqo4VVR;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773315569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4keLUCD36GmhOpd1Y5wJ67cTPSgRrvPHrAizfQ/GUjk=;
	b=XOFQpdiM0umb3YhF+CoTKZW+rQSoSpu7KZ/ZfT6yVhsMf7UnjS6ycQQP446mmStvVJY9kG
	Gu6ZlCNNRuIx6lUJ1QrjUbWdV51Y5dehM7L2tzdQBoGHvu7D8dbOnEWxJESxZOmfXNrfXA
	DakV+ITsZcy4JnNWLCtrLc8wAM8cwGM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQqo4VVR;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773315569; a=rsa-sha256;
	cv=none;
	b=ooPxHhDAwa8cedwwfT9o70lj5ldBV1ofCCpp8QNysLQl7EG04gGHXwquZ5hRxwHoE7aw17
	zzT8nvGsfHxH7e7W0Ppbvi1/zDPMNI+xm4GCjO6XyxfryKqfNH0Od2CzTN7epH+0StWhpx
	7eNz5e6AiRTe5CoUzuFrROBHCtlNNjs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773315567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4keLUCD36GmhOpd1Y5wJ67cTPSgRrvPHrAizfQ/GUjk=;
	b=mQqo4VVRitmOlYVcRGLh/Iwks4syeurg8+k61C5yJ9A5ry/Q+q7juvaciJH8Zs0iRpOJke
	H8L3qi/5ZPH4zeOmM6d0JM5v3E5A7Dhnm7ju09Bxru7BwXO26Sv1x3fRqFdV71cp1SU9Gb
	ZXM+6WBxoTcg2I/MUa32v6loCb6K8jw=
From: Usama Arif <usama.arif@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] locking/percpu-rwsem: Extract __percpu_up_read()
Date: Thu, 12 Mar 2026 04:39:21 -0700
Message-ID: <20260312113922.2118105-1-usama.arif@linux.dev>
In-Reply-To: <a065fd88990c0091a168b1d6715cd0cae8e9066c.1773164180.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 49D3B80012
X-Rspamd-Server: rspam07
X-Stat-Signature: knggyduntkywx197djak5wxbpokj4wuc
X-Rspam-User: 
X-HE-Tag: 1773315569-1169
X-HE-Meta: U2FsdGVkX1/jdNDwJnSszNinpYOA4Ww+jrSdpTSJ+z/quRp+tn0wLwZhnR24iU9YtiZcx3JdbmyYtEK/06wq5/PXzzcvjYJRonuUs5063zh1iB2RvvVEQ9qgDb+SHOXzjfQIc8tzLzj/MnL3AV4jNx2Q/bbv069Lzfrt3DgxIkB+xEtuu+U2p8JAvI1YTUIlQsKWx5IXE0rs7WfnCnrwWiFf+nkC6doq0yHhwY7Dvtosjt11RB1BZt1C/JPOXH1YzyEp+P7BHqyedSw5d86fCVZBFqXz27xarHyHKKfMhZaJ8e1b0/Pjk2WSTIvCJQPvQAfOSUMqIw1gZetBj8fTRU5hECrecJ4eDmFfkQDOnyyJzPc5/0kkBR8Xn4BE+cDThtITsIfsMPPFwNshRasiuVeJnftV/xn7S3MFAAWGz+RRDF67t7FOccZ6KrYxx3/Oz5OOqVV5xHOy5EtmrRSpQVFhoP5yj/TtcB6FOLiJ3zi7Nle7vCVw/wLKX8CzyT0e0PvlyaIKg9yRDXF/jp3vc4HDz8jEvW/PcfZCn9Z0QzFZpkpvdSQim3JB9xjHxssNx773tLFv87fhZCA7z8109nqVLnCqGsfgAKbT+9E/B35XgkF7ipYkm6bIi6Ozx+2cPqGOrwgJoFcTjCbkVG60ACgqnCcmpJbjJTTc5j41x1AMBR7Kb20OnLoIHvPDHL8TR4CLTAQ21G6denEY3eNJOxnAl87zLjbsFJulQ6P1248HTOs/YHa2BnTAT6sbOQXxv3pbjX1gs5Q+ggnT4dmIQr5HfGyGE1PILKMpXCAg4lw/IZ9Knr+5wbYcULNhj6nz70s2X/1ltRDKOYtpPou6Ps7q/3yDGeJ/6GS/tz09/dFesn103NlLN/ZZppyHrnwSrKgvAG2V1fWuLKtr7nW0rey1HeqFaRjkmIBWT+xJeU8o3Dw3ipg1tkowbDd11NOI7zMe7ZbMk+vEiuLsSEn
 BhvlD/Tp
 sf9epLYTLDJJ2twfi8tTpJPOoNBrAMSkSsgOpXnNd2xfdb6U66ycE9frSfOM7YlVH+iqwOI9q/5Siwo/+tfc59I8dorQqkVv13NVt3TlchX+Xjhk7irfeuiB5w8hpyKqd5+8AaRCTXrPOZmGK4Ad63ufzzh+R5bXhNOsA5225u0Ye1kSF8wEMfmxzOw3kZYd3eTznmbxqWyaBoBhX4Npbx4yvTxK/br8HX0FzyOghSQ8SMBaH0Td2bCamfFj8SuKlehnTupLbq+mT9RawdWqT+O+dHFeDpsmipm685CnnGmgWMNveXmHbCvUGvHKuR+zS+5a4RJhWsXmhWvB2a7bO1HtAHAJ0h4fD7PBlGVJ8rl1EWEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 17:49:38 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Move the percpu_up_read() slowpath out of the inline function into a new
> __percpu_up_read() to avoid binary size increase from adding a
> tracepoint to an inlined function.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
>  include/linux/percpu-rwsem.h  | 15 +++------------
>  kernel/locking/percpu-rwsem.c | 18 ++++++++++++++++++
>  2 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
> index c8cb010d655e..39d5bf8e6562 100644
> --- a/include/linux/percpu-rwsem.h
> +++ b/include/linux/percpu-rwsem.h
> @@ -107,6 +107,8 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
>  	return ret;
>  }
>  

Acked-by: Usama Arif <usama.arif@linux.dev> 

