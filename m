Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304E1C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60E68E00CD; Thu, 24 Jul 2025 19:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11E38E007C; Thu, 24 Jul 2025 19:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28A58E00CD; Thu, 24 Jul 2025 19:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98A758E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:50:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4565611377F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:50:17 +0000 (UTC)
X-FDA: 83700804474.12.AF769DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B679B1A0005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:50:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RcukdJL/";
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753401015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujPGJaGI0WcMj0hOJ1GyXx1fRZesmWkx6+9CEGYUAQw=;
	b=u8B9FJ6h9N1WPJT95RVAqZZz6I6mptkmGR+ztnLqbZISwZUxA4dd6A1/mXwV6mrVaGsHUs
	udbrosLrLxeineT31H5P3e91Dgfuh1FINExsDfjjeqZseohwnPnbKhfRXFg9kjA5PcQbOW
	ek0CccAipJDi9qfMPbakiFnLOwIO8JU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RcukdJL/";
	spf=pass (imf19.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753401015; a=rsa-sha256;
	cv=none;
	b=zuAiwweIj/DcgYoD27XBf/4SoXNhc/G+TKtIHvhg4/1GoVNG8TQaOXTopmc6Y9VarVEQcc
	6uMCMCE2vZvsXi+rq8aPwBpQgFpmsQepDTZGl7f/13GLR2pkBOmn7jm3IFvEBYx5n+7cd8
	bqj/0wgkY3q4r02z8PqHakZXMvwX69w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40766601DA;
	Thu, 24 Jul 2025 23:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1548C4CEED;
	Thu, 24 Jul 2025 23:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753401014;
	bh=J6zs3FFWOtVduMYpXGiST9B8M7PoDvH4oTJVHYKE6SU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RcukdJL/ITnC9B/6oSNZkRN7qMgCr3fx+HQWcklBTgNH0czFn29ZzFJh/7RGswJFB
	 XhAQlsk1vQf3rsk79Q+E6SzCG+0/fOMNSfgQWx2q90/IFeRmylGKbYImHUbt7rXBLI
	 SqTbIw+G6lsg5tscwPTOo1hO+3HSrh2JDeOf+AG1Brwvcg/TiYy0bs4986CzTaZ0GI
	 YsItvCVhIOdqN4j76ivNLyQEmhDnobMc7nF22MNtsVExgD4pyBMZZMGYe9BEJl9IS3
	 IzHClgqaNelOaEjSZ86OyHBpr1zvQpSdshxTttFjLw8NMs9lIUuuXmDqLYdk5WiEBn
	 n7unBcDgXNtqg==
Date: Thu, 24 Jul 2025 16:50:14 -0700
From: Kees Cook <kees@kernel.org>
To: Bhupesh <bhupesh@igalia.com>
Cc: akpm@linux-foundation.org, kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
	laoar.shao@gmail.com, pmladek@suse.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
	david@redhat.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
	brauner@kernel.org, jack@suse.cz, mingo@redhat.com,
	juri.lelli@redhat.com, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, linux-trace-kernel@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [PATCH v6 1/3] exec: Remove obsolete comments
Message-ID: <202507241650.ADBB05F@keescook>
References: <20250724123612.206110-1-bhupesh@igalia.com>
 <20250724123612.206110-2-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724123612.206110-2-bhupesh@igalia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B679B1A0005
X-Rspamd-Server: rspam06
X-Stat-Signature: gaq1u1td8ot78h66b9rcntekfcspx7as
X-HE-Tag: 1753401015-866387
X-HE-Meta: U2FsdGVkX19UIWZnjKKWWKkNacdtyR8va87GP2AA5hLUZJrSsuaimEpLFXo6+TU6b++FeOS76Ni2KKLsRk4689DF0YIeiVOiaVkz4loWhhym2pP2zFLbsLmnP6/tuPYY7dSUv8kVgqP5JdCLSxIrLDytHvkD3GyecJopolFKFMGMjpYpBEzkKbbEbpNFmeKT45ovBbww3CmVe05lBIPdXVHrGR5+IpKDuFdzP+eK1gBEihZXySughPHK8Q7f9o84Mu/j7bzaa9fT+fDl3thGJBq0daCEugwx5Nb28sSZObmyZ+ZkSocLsgu5C2PCiiMxcGpqR3fkIrzekCDh+wlFcrMU/8EikQZHDvUJVtSssMhThgRkLWEw7sqROWXnf3PaqqcfBqnjCml2SXqh5yBiPJRatfgFkSGuufDiIa0FjCadJiqSXgqXka7jrcmb3iTnwFHOAPuTfJDwegdj8EaJMb4iTueZ0z1hwxEEDpyOPguyhWY1703vB9Uej/yOpd0WV5LZqvIZ8ms+DbF7aOYWk3k/Aq1qxR2ADOhSTRiz5c7OQZGZF2EpjGH6iw/YkzyX7PHRuq4dHQWiyWHerBdv5sBgj8cDbu5tdIayCFH1AzeOHOIPdFlAW/2Co0JG6WS86+v78N5z3kT2G8/QwGQISMkpxedJxnzuZe5nDog/r8q4gXU6tH4UCzwXOJiIPNfuK5jme3ghUvfA8FYyBihZ59EqsqQdyQWZnfwZ4BUYN1h9YZo5zZRZKxgh/VeUFdyW9qX7srX4OkAkBfrqjftX822v8bfAT3EgVoZbMkBSxOo8qU7ujIC0mwJkGEqsCWDQ6e5CrqVaK9IW5xe23J4P+KMxx/+IxV1022Jh03fCJByOSFYn9SGXO7xObCQWf0M9oxhapPUS4jkSaJIVJXNnELO+uztOXkzlxlByv9GPAelI2D3ECWsoH2YqqfDuj3VAIMD66q9Jd0LMHCFrxPV
 1CjXwUbx
 hqUvIQqIunL8XePs48lbBbAmQF60PnrYgCwnrcoTxFiiwoNCY0IxoBHrwEAn4doQ5bJo0vwtay7XsENx9pa4yv59bXfvfcesNEA8aoY9YH1v/+nZfd/CWOPeeyz1Mi+0jVvh2tKr/zjTbgGRKtH1I1nqfkZkWZUVZ/+dZ6Y0F3Mdmqj+3M9R+U1E6fbokWME0EeajiPN2cBelph4QkyLrxu7loGIgBJnHoEtPkP1QVku4wAi+Dz6DInd5j/fCQtmNrgTamN/eDX1Fn0UDbQ8+vtg1NVTLQozC6dqzCr3VKbYBandIAeMa3s7waBD+5dxCQDQmhdGa4FfHtNv9n+bbNnrWyxrXBjSKyv0FFPkRdAsdopqvQE8vViXTtFlYCbLezb+GlQd0fPwR1EgRmGXX4KEXZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 06:06:10PM +0530, Bhupesh wrote:
> Patch 3a3f61ce5e0b ("exec: Make sure task->comm is always NUL-terminated"),
> replaced 'strscpy_pad()' with 'memcpy()' implementations inside
> '__set_task_comm()'.
> 
> However a few left-over comments are still there, which mention
> the usage of 'strscpy_pad()' inside '__set_task_comm()'.
> 
> Remove those obsolete comments.
> 
> While at it, also remove an obsolete comment regarding 'task_lock()'
> usage while handing 'task->comm'.
> 
> Signed-off-by: Bhupesh <bhupesh@igalia.com>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook

