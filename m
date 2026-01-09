Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD812D26D9B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 21:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1C76B0088; Fri,  9 Jan 2026 16:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FFA6B0089; Fri,  9 Jan 2026 16:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED626B008A; Fri,  9 Jan 2026 16:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D90216B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:26:48 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6ED7D160B4E
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:26:48 +0000 (UTC)
X-FDA: 84313710096.16.B5EC179
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7B3D540009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 21:26:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="UQJCMP5/";
	spf=pass (imf07.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767994006; a=rsa-sha256;
	cv=none;
	b=X8yPiUQTZUCtzE6SLs4ELvVg2QoP3OKEf6B/MNGuIEsLUUyIh7jLWfriqQ31zNu5RkAxp4
	JQ8kVAoQ4gjSl14HFI1fsWqEZRhSdO03R7VRlAix3fGRrZlf0IAfbbF6NFQJF3wELDaQUQ
	1S+CMmm/Z9WxoXEiokoKi6CR7KDUxAg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="UQJCMP5/";
	spf=pass (imf07.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767994006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVqxi06fhKwoZgXTNpFdWEZ/nlKbofAaMwqmPcPl6V4=;
	b=4VfXXQLDgPmujivZTBpQbRS2tUALK7ULzrsS0B7YdiA4SMl8aSBOoDSwG3HmUOdgnjdSMG
	YkNuh63Q0AKAmMyVtUxuOB5CYnORrSQ8ALCCB06BFIrojbM76WgvAkHlmNGNNc4CSjH3Ti
	HVepu5xZ/V+OZ04svD2oHmXDKHjELCo=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dnvwj1rSVzlsqj1;
	Fri,  9 Jan 2026 21:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1767993997; x=1770585998; bh=kVqxi06fhKwoZgXTNpFdWEZ/
	nlKbofAaMwqmPcPl6V4=; b=UQJCMP5/4z5OkbytmihEViGuPxzO9MDFixo1jD/j
	b7B+ZCP9e73vZ3Lw5l0wl4bbaMC2+1fC/nuUtQ5Qlw8nIM+EbIuZnUW2Zu/mse1A
	d/KzsFdZLLYSLdLoVcxZsopqYXBfFggKKaS7l/Xzj0d4R6LcnSGzVLTsWnjCAzlG
	j0jGrM6I8VxGPhZFu7ln5JERHarPuFgd6jxrRZWTvlb8pN9qri//ThxalZKJAw4M
	2ayFAwPTWuSmIOsoqZCnT3A2Zko5jGsXg7uSYnllHsZ6Dee9gPu+KHIXFaJFY3DW
	2utpFE0Zij1eDpkq5UWLB4QwFY0l4H0xzCVpLK9pcF9oMw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4NnprJS4L2Lu; Fri,  9 Jan 2026 21:26:37 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dnvwJ0Q9kzm10Bh;
	Fri,  9 Jan 2026 21:26:23 +0000 (UTC)
Message-ID: <8143ab09-fd9b-4615-8afb-7ee10e073c51@acm.org>
Date: Fri, 9 Jan 2026 13:26:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 20/36] locking/ww_mutex: Support Clang's context
 analysis
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aWFt6hcLaCjQQu2c@elver.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zuisj18x3jw9jb8pqrfsqzwf5fea6qwq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B3D540009
X-Rspam-User: 
X-HE-Tag: 1767994006-865216
X-HE-Meta: U2FsdGVkX184GTsn5o3L42/5do+6b5s7Fr0f1YAWLZhzKtujijivB3bF6KGjHBu/J0scOWHaJcaPY7T8YqlzeRVvYZyf456ILbpdBsKioiyo7ccgHLHS/iYaLANVdR5DJQ88HL5BXSrP/pzcVEOwmCJYUhsnDl2EhvncsED0/fGKk8/pStM0SMJ+jRvs9xEzC9QBSboNY2FIGJYPqW0XDf8jlvNF6x54q2vbYLY1RPZmjEbP+jMQWGrELOXsqVPdvBxHaoSZ3upbnayr2IjpwupOSbWlZmZV+AkI88CiM1Xk6kzRYjMuBNtEgE63aYW4/mMZ5GQe6ZWFOeEBjU1XocJ6/Z5LP4jy6jvnb9oe+ahrtGtfjjiI3ARkYP1EAuB17n+48R9FMgjSijcodca3MDO26/9kLwZxaOny2uhQQkKL1HpLY+E4gstZHmIBARlBccDiN0oqLJQ55jJlTe6MZbbDAG7fxdEyKTgB5sR9zns0EhwSS0bkPGgc4tDIlDfcHWox3VjQOAKOvOJEJLVPb5082fWsBNuLjJPFUSUzD8izvxW3k61nFjvsSymZmGlEGSerjjri9ULTjjTAt0e7LZkx2Rz07Iew4M3sx4YxtmUzBdQ+GEQQpX+La1DWi8vu+qNMr8hwzEMOxBYex0KmEHZkul2TytGoRIYl938LjxVvO2Z+qP1QqXKOTWlEhY9x76LlZ0s9eBNtNVc26xfurNS5mGkgq9lBJJJkM9h92Es0YFf71VdvsxxeLb3g6tEO8KkGl2rWL5aur02uEu1XDhVTmmOtL9EHglBFaZxKoCtTxkbiO0bqnSkz+UqsMg4JjF34+oY8FBAFPTp3MY31xptr20d2kLnIKu+gtAJwZ9XEjYF42lMuO/IN78q9Xm3VF19qhJYpw+EonqvM5sWHVUyAigVButwO4btxfPcZFujjl9yPhECnc7FG0qjkUD5camMh+Rnx1I/6KgUvU8J
 DCqR4IAK
 DDL0Yq7f159/f1fNb/cdW4ipcQ5VVfgp53CPpkr+GxDCUFFhCYgUPyVKEee+bf2ynsQQusglJWBqpwp0IbFzoqVwHNnrGaRyC8V6vsC0hIiIw1/k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(+Maarten)

On 1/9/26 2:06 PM, Marco Elver wrote:
> If there's 1 out of N ww_mutex users that missed ww_acquire_done()
> there's a good chance that 1 case is wrong.

$ git grep -w ww_acquire_done '**c'|wc -l
11
$ git grep -w ww_acquire_fini '**c'|wc -l
33

The above statistics show that there are more cases where
ww_acquire_done() is not called rather than cases where
ww_acquire_done() is called.

Maarten, since you introduced the ww_mutex code, do you perhaps prefer
that calling ww_acquire_done() is optional or rather that all users that
do not call ww_acquire_done() are modified such that they call
ww_acquire_done()? The full email conversation is available here:
https://lore.kernel.org/all/20251219154418.3592607-1-elver@google.com/

Thanks,

Bart.

