Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF49360A3830
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S152Qfzk
Received: by kanga.kvack.org (Postfix)
	id B34606B05D6; Wed, 18 Nov 2026 18:33:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B826B062C; Wed, 18 Nov 2026 18:33:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21E66B062D; Wed, 18 Nov 2026 18:33:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 796616B05D6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:33:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 005501408EC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:33:17 +0000 (UTC)
X-FDA: 85449843276.20.782FEE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 668A1180002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:33:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S152Qfzk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795044796;
	b=7XUOmwryh+LvYJiqzrSrcq2vmuVvJSjqGUvOk8i8H3K/hyMLHxgLS0fsylSF2cb8j2wVfv
	25oQQ1GHwYDcNraMuwDNQuhCzDBnukXLHpl+ZMD3WpinPq7k0XVDx9IrSMm9X70nAsqcY1
	1OCbs555lVFIUguu5qx0XQhZiWQezdg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795044796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9akWZSnCYRnWbaIGtILHQRc1MGkbrWkyT1jQUBXFMs=;
	b=tGUPjfWmVJI/zqdM4Z7FQ9LX7bsjfCF3ZmxdQVdRfcvWB+d09DKxGAZPdAJ+uGv46uoas3
	Bapii/AgWM9fz9SbTgIP5cgIy1I+hJhyHKR5L0+oeXXlbG2kcB6H0iIN0ZMIeTUylyC1QK
	hv/TzDPUVilATufAJuU8rxlxc4IBh5Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S152Qfzk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id E089364278;
	Wed, 18 Nov 2026 23:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D36691F000C4;
	Wed, 18 Nov 2026 23:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044795;
	bh=p9akWZSnCYRnWbaIGtILHQRc1MGkbrWkyT1jQUBXFMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S152QfzkH/YqVHGzcaAyRIHXf05iUtkydNnkRs9gCIC04KoHBy3vN9DuOm1O3Q1eR
	 Q6asZNJIfzOO8s55fR940xAjljy7DSHPQlNmAazhL4OBJpGf/2M+b3XU6dS6ylQVHT
	 NwV1iVNwjV7fb+uYu4H3R2ow+82tgiBtGA+dYFfDOcNFN6HdfihgXLmH+ZRGm7Sewc
	 ghLiT4JntEq1W9eHpsNzEgrxVl9GV9sYIfv+wgjPvGzCmoCG1CHMoNJJF4CJUBRLcb
	 nYbcySuhRvuyXd3EJn5ttwyDsZz+kOlcBtjEISdkmYIHvY0cFueAOlZy+mnw8o/9Jv
	 IEBuRomvBIcTg==
Date: Thu, 19 Nov 2026 01:33:11 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v3 00/13] Namespace for namespace roots
Message-ID: <av41t-SRVZjOBqi7@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <9bc43f9b-d721-408c-bf78-0f08f6ec4bb2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bc43f9b-d721-408c-bf78-0f08f6ec4bb2@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 668A1180002
X-Stat-Signature: cs5kat8uthkn4sao636ptjxsm7smmw5r
X-HE-Tag: 1795044796-599588
X-HE-Meta: U2FsdGVkX19ft9zOBE3+YI4ZsF30I39CerdWAIfk31bAU4XcLrAEENYwLFoQf2N8F26onNNhpb1GUzAuxV9cae9nWyumdm9owzaoZDgBsM5VOWrECIRsPO6Jlxk0zOuEkMq4eUrUrN5OD/07PXRLFj+QmzsuzUrDiIKwmXRyKc3R9Ep5qWO85l+K54+slWyGMykrwVPCJWOGyTzNDamymzvkCoIqMxQAUjK4r1Ot8Y49ZTjgFljMciDlKEcQMaUgzxRkNbQThjcuVlzu6+WuYgEDBodBXALd46TkRbqDLQKXAY37NxcaRbGjUjq9FBUHkqOiGGclRbiry+2Cc5a6vUt5b1XK4wCyK2z0HCc4MktEl3r9L8guzgWlH1sq4juc7AfqQPLZ6u/APkNAvvZB+nu461ttZmZf6yqZhocRstOAiEOzOmFRUeVEvNcGsi+hradH4NrFPnQ+xK+KKH+QPRzgcIJLpnaZF9vsOSikLFRQS1JSFgTZ1dyCsALtJ9yid663lR6cl3KI56gd+3YEB9PkAZURBSATQZsEa7xPUS76wcwUJ2aqTlicMyYJ3P10Y3NtE7+AWQiBCjV2pzrBXQHcHdTH8lENw+zxide79BEK6kJKwOk5I7VIZ9g5iycKW0J3uyxQ1pT879TOyB84pt8SBO/Q2J++pnhbCMTrz83yUdob33wQUzrqjRlY+KrpT/mk9s1hOk0Sk3nC+9G4xEX/QceCsUQee1VOH6nrkZAo0EFg/j5+BeNL0sJ3e3FJ9rJTRi2GPM3i1zmP1tTxYPnOdAdAb/baUgBsx50/90eTr76IsyjoWYGAoHt3TX2TEDhJe6XKTTUG2u3H3lLqkEZrdTtLPikdNn7Ed/48mriuy41YAeTqOWxN4xuxlpUbNHvwIY/knBxEG9aaQ3kU2lFoy4N8Dp7ae5fUImd5wtOlxCLKQd9UjJTXurIM4KuBNM61L+SszW11l+so5Bs
 69Tx2Hjl
 1xhmu4z+5qpKuZpM+ujWlRX1/ycUInNU5zSQxAEOysvKStOb8rP9QAbfOdi/gVfTd0DufQEKafNFdRM5SnD8xAMBV2wfNiWcwcOZIrp83Sb7Qy22NK10dJpVCha2pvPqxVFe7JXa6oTcsF+aEwsHsWnMo7hI72gav6q168bl7W3HN+uZ7Ek93G2kODZMTDxna04eB4UhMxHJ2GurMYZGzGlxPqcg7F7sFob8HMsi97ObTf66VK/Qj9rjUpqIPnuO77TZW6DTL3tbUDsqOhci1FavLti+dU3fqjrWzAXdxnjx9wMlBGfi2Tk14dtW7LjnJSndF07LCyCQKErbJw/CDBD4EOkhXjC2zATn9nUzsnIwO6YE9mx/ZamaOTYsw5GwrDWC8Q316hzZPdxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 11:36:20PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/18/26 20:35, Jarkko Sakkinen wrote:
> > VERSIONS
> > ========
> > 
> > v2: https://lore.kernel.org/linux-fsdevel/20261117231352.3816603-1-jarkko@kernel.org/
> > v1: https://lore.kernel.org/linux-fsdevel/20261117050841.3289652-1-jarkko@kernel.org/
> 
> 3 versions in 2 days, with 13 patches and such a vast CC list? Maybe slow
> down a bit, please?

It has been a version per day (or along the lines), which is not
spectacular but I'll pause for now.

v2 and v3 address the initial architectural bottlenecks that came up.
Those really required updated changes + kselftest providing the evidence
because I was not immediately sure myself whether they can be addressed
without experimentation.

I would presume whatever happens to this would be more in details, and
can be projected without extending feature and/or test coverage.

Br, Jarkko

