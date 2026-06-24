Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AAECDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082406B008C; Wed, 24 Jun 2026 09:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0327C6B0092; Wed, 24 Jun 2026 09:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB30E6B0093; Wed, 24 Jun 2026 09:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C44F16B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:06:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 398D014036B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:06:01 +0000 (UTC)
X-FDA: 84914828922.10.2125D2C
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 56BD5C000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:05:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7N5AMoP;
	spf=pass (imf28.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782306359;
	b=L4o4xtDxPAIliKucUNf6liXK+HPJy/GAvJdCUDVvH8+9uCrfpLFjFo/HMGXsQHVc/7LIex
	a3+RoGuMkW7rUfpNDq0Hp11S48TBZdHdt88KGzMrFqrwA2RDI9SVTUu0U3LtNF7Tr4wRfq
	0N0AoSrdnAeeMEHAcQt4PS6OJsaKEkE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782306359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2iAFOHBRMR/Xa17pT7sXAqMACpdvIbkzmpfw9EGJVs=;
	b=RKSVzU72bJMSm0OXVARZkKxzRsn8B0qZuvFU26TWiJGfg+YOMxOSD0hK8b9fm0OJzQIusF
	e0rX0KPEJnjilJF069C34iMMqvfI1sj1UJu5b5D4X++Ju1i0SDyLIU4ebT1BHZATbIlSzQ
	zxiPafzsA/L/X9mXxLqV594ym6jt++o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7N5AMoP;
	spf=pass (imf28.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <96334e07-dbd9-47a0-93f5-ac4762b7b919@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782306356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2iAFOHBRMR/Xa17pT7sXAqMACpdvIbkzmpfw9EGJVs=;
	b=t7N5AMoP0/i8dFY3FrC7HO2yNmLfeZFETlWYqXUODrlmNpqyaftZywjo0y9UNn13O8QGRa
	AXb39zIwwMhdHGGwdLIWZOxZlc/RB5gme76K1wm+eYFw8s2/p0wLK8vNz3AEO2CElTbLsC
	uEFuGXWFUWXMM2nzKZ+r26KvGnuXTwQ=
Date: Wed, 24 Jun 2026 21:05:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
To: Jani Nikula <jani.nikula@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: David Howells <dhowells@redhat.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, chengkaitao <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <88f34c7fa5a3d1700cc8005818751d6aa31f09df@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <88f34c7fa5a3d1700cc8005818751d6aa31f09df@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hctd8q53atsku1ykfegwu3shs59pqcom
X-Rspamd-Queue-Id: 56BD5C000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782306359-960383
X-HE-Meta: U2FsdGVkX19MH4SHqbabzrM0KiFeFqcmAcCc/7rrvxU413EMQN1WRrgSXhdhsCSHolGCcJpIMMKJp+f+Snir56G8MVnZnokF3kxMkuqomTdm/Gqd7oRmDWR2g7fQLZir3mR+QLCuPq8QyCTPUMtCNXVBVboypbuGi2YmKGk+DuSs2i9iu6SSKLSC4W/HyMCYIbnEY5MiXhP6UjbM06m7SlLEo4OeAgrJ4ChB81fEFWNCY3AhzOOmcDv1vNDMa5+Ukxo2OAlDqhIe5dzO/knYHb4gcE7X8oHgGeytM5buGVXt2ueFUJi5pO7j4YFW+bnis6+Rg9hZD22a83b59iGPi71MGrHyms7OXZZc+UiB2aUKtFGpfw/3P3SK8S5/a8+A3PoQDTQhYQdYR3A5rPhxoOQ4URZb4kXC03vgFCubkbNxw+gmFsJjlb87Gpf9FVhiwglcGP7RaK1i4DhQRmMRzi1z40SZGLoamucWfegpiYxVGQ14w5+FW6NbfCKlKwM+NE1O8uXZarVAfwOa9yw6JI/rOQQy74zOB4DksbElWHKuqQRPJiujVMc1ktWy5NavadSoHU3Rf/XpP/TrpdYtk1VIo/juwr7wBruBNEGV1B7M55jHesyfpa9oEv6e5CtmGQmb9ru6o0/QP4FUSt55nL6nOtKo9h7fsSihgF9U0uW/FlFfzZw8iUxDvwF64d8SWD5byZoOWBYxbLoqDJvpkHHYPWGUmpFj3iLQR6qBRp6nv2oQdL8Y2chnVXSkvuBlFQVDf7KXjAr/qoI9URNsnGBsat2G+1cyhRydcIFDlSmwfHV25QH69yBciKF+BjCWr7RB+YLSTHzqpr2YlUzHp+7o3NmYZdeXtmNvs85lg0p2i5jQyF1fXYjYZFiuLDB88CJ3eUIJPlMlEdApw9YiciYykid+eUfLBYEdA+4foIvKm5UH3EU9srMV5O4qxBFNkibmeXfbZHJGK86UjgS
 tHWJOjNV
 26Qk9bwJSizKpfJxDEsnRhB6Gg+rNL3+3NNaHnXr3lM7CR+INx+M6hHDG/WHjYni6aUYbygWsXE8M0PWrIBLk8tjk6kDmTUvVUWcQTFsvVfwoTsA/dFTHFG/EWuj/45ldxU6v0Kyu1lzgWsmXJD024cFxDjruHTx+r0NULB/jqPL6CDazuyiMQ1yZM6td7wYbvG1758EJGvFUoOMP5n7e+LaLL5tHqRNha27mjgKPym9W91Ot5/wWpC3CHoZdipD3h6Ui
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/22 16:37, Jani Nikula 写道:
> On Mon, 22 Jun 2026, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>> Add *_mutable() iterator variants for list, hlist and llist.  The new
>> helpers are variadic and support both forms.  In the common case, the
>> caller omits the temporary cursor and the macro creates a unique internal
>> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
>> explicit temporary cursor, the caller can still pass it and the helper
>> keeps the existing *_safe() behaviour.
>>
>> For example, a call site may use the shorter form:
>>
>>   list_for_each_entry_mutable(pos, head, member)
>>
>> or keep the explicit temporary cursor form:
>>
>>   list_for_each_entry_mutable(pos, tmp, head, member)
> 
> I'm unconvinced it's a good idea to allow two forms with macro trickery,
> *especially* when it's not the last argument you can omit. I think it's
> a footgun.
> 
> IMO stick with the first form only, and there'll always be the _safe
> variant that can be used when the temp pointer is needed.

Could we go back to the v1 version? What do you think of that
implementation approach?

https://lore.kernel.org/all/20260529082149.76764-1-kaitao.cheng@linux.dev/

-- 
Thanks
Kaitao Cheng


