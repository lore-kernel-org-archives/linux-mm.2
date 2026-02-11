Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFABBECD6F7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 23:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 457A46B0005; Wed, 11 Feb 2026 18:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415616B0089; Wed, 11 Feb 2026 18:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3422E6B008A; Wed, 11 Feb 2026 18:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24E086B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:40:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF7588BF6B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:40:27 +0000 (UTC)
X-FDA: 84433797294.04.55BFB88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22E2910000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:40:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLwxXdL8;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770853226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NaROPL5MlbmBL3yhQ/r4Yl2fKubYel6HODIBr9UM4s=;
	b=nUCFxOqO2/1+Kt2J6TLz43/EpzZzDOgvLXhPfTu1tnTRyP9mKDsN0Xs/IpOskuotC4189j
	JqudXeJwSTAXlC9iKZaP2V5vHxGTCYVXaiCwzLaSflBjYMbctqSDBlJw0nWcTgnyMdowuF
	5TqUnZbt1CNs+sKsp6LFdOGXDB12mBw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLwxXdL8;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770853226; a=rsa-sha256;
	cv=none;
	b=FHn3amKUdhM6GBmE2m60zPeLS7wKEHBs0OO7A5+6T+ESfJWjF53LtShxWNu5t8YzgKEfuk
	Goxlp3SVbHOfrHfVFZAa+dAibbGo24MJO29xwx160lW5qSsPxnCiFVBcbCrOUVyJ9Lcn7O
	fYzafTV0Y3ycTxA8Ejj7X0Fm/jjHWVQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88B1560010;
	Wed, 11 Feb 2026 23:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203A3C4CEF7;
	Wed, 11 Feb 2026 23:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770853225;
	bh=uaY65W7hrEobOoJ4MuCcNES+t0Ca4G51Xoh9lBrbcoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uLwxXdL8F75bnDK5USEl0ETGj9zSOoN7uGEgp4FC7xJTnT7E8Ecyey83lvNriU1OC
	 b7NCLRIBXrh65b0/hCAnmubR2qXUuQ5tlN+dqV0ELE8P/iPRUGMj4uvsYwQjsLLVxf
	 iwKJck7IC5sPKUWYOTJSzGuXgbXqyZFwkGdsWb7QpHJ3wC8l/m8e5dQaI41BnxgweZ
	 SS49kiOSb9yM8BCSaZy5Kv3zJsr0SVM/49pkCPhAq0bDfZGsSHVQb4hSr+tt85R2ZJ
	 bhnETEY/r1SQSQLfp7jLW+aAl1snYPoaNwQ/LzQcdUDMi7qcvmW0uSfwmjUqnj4J1H
	 ZpD/vhXDOZ8pQ==
Date: Wed, 11 Feb 2026 13:40:24 -1000
From: Tejun Heo <tj@kernel.org>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Yang Shi <shy828301@gmail.com>, lsf-pc@lists.linux-foundation.org,
	Linux MM <linux-mm@kvack.org>, dennis@kernel.org, urezki@gmail.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Message-ID: <aY0TaIpLNUJYuJZT@slm.duckdns.org>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
 <c6ef0444-9423-4026-5a3f-123183246ddb@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6ef0444-9423-4026-5a3f-123183246ddb@gentwo.org>
X-Stat-Signature: za4xs533u66akg6ymk4itpwg6sisi7au
X-Rspamd-Queue-Id: 22E2910000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770853226-950828
X-HE-Meta: U2FsdGVkX1/FL2+thEWmUTReFfK/uROOhhKiPPRqbh28b+IUBop6OqpLtF+VsRyW8sBsg8NTC/V6+61bKolvT/FTjKXKiwHMwNLcaxh57hqygm3il4dMt3mmt6AUYOFVQj40PzIFaEbfcbVYUQfydM04PCZDGsnqbTcJyjR6N1PQJ5tw7xUu56wm+IMxujdCQ4Ch9Za/Z9tVhsV17JW1RQigq9w/gJd5Z0IfBdg3UhRNNv+jIQT/WNX6YO38Gw2QJGcoVfm5a5fOliE/93/rMYShlYgTHpq+9Cl3X1O5XiD8kjbaSyEKlePXI3Owu3OqwbTHZZhGjYcde+sDiiFH8uvjn0TD9eYZIn9hu+yCNNljPfVp0yByzaY46pXKvgr8GpovruN8lv2FP6bBn6qaOPn2+ZFVehW8odekfowVGhz1EjTAD0YKExX1CiXzVzSblNg72PaFkYgdH7GYU59wUkFc42luBQ3xlJ0E0UN2tqCuuSbBEyBupAZZid5/i/H/QlNt6U0N+BZcXgWtYB+Mkl6N1EKsQS4i2mmKSzz8A3rjkGCmG22qLPIfC3T4ToFwBnWIq9pKqdKXaMdZPSciOod4i/ayySX6tdH8ZngJb8aekVaFeQBXDPfXinsc0YeVNQrR6R07EtubAa+YUTOVOrOYbaKKa9YPGlYGQezTZVNAxLVOXfGjEDcyyKeOVR9q+UGgmjANnJQGTngzp5WHJr+sQN+s7nhKFKLHlrLjGA5nzGvQdWUk4nZTbbeE8DQwrgcvsh62/VL/dyGDr8oN7w5nRaRGO+GDlM3IqBJJXRi8Uuf8PVJGHpCloScTiXxpCMoKKP7ikPhAzVC0hJhHpYjLLMVWK74KWAeWIEo/2JAakpy9da4EvaYNdGEhXnenDSNOaUhZSCHQEmF5kyKnT78xi9fGq5GJp6Zo7K2gRf8FOCehEdVANAj+t+3iWFzSI0ifrORNGJhvK7Zhk+U
 7cyC1Ysg
 auvvXBK5XK9L9Ca7E0Ptg4yaTkp3q/UDYPwhSS3tVXsrtgbJOKHsRAbwvXr9f2im7anoQisrxT1250kanlZpQ9kzsI1W9X+HbuZqflZx6CTJVeuz1ZEPksAmAVO95X+R3T69Q0Z7M39s2e7VrqR3nWTuXxINCoABQxIkjLPT0XDBBQ/64Vx3ZCbuWjgGMaTqBDiWUU+XkicxCX96yJ3o8c8i/wYJP7ARIquCj+oUJKbCnhftRzQ7pxYZcHyDCfdl6+dd8EJMQQH2ZIw/fhqGZsLTtpiL1XaOy7DbT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 03:39:02PM -0800, Christoph Lameter (Ampere) wrote:
> On Wed, 11 Feb 2026, Tejun Heo wrote:
> 
> > One property that this breaks is per_cpu_ptr() of a given CPU disagreeing
> > with this_cpu_ptr(). e.g. If there are users that take this_cpu_ptr() and
> > uses that outside preempt disable block (which is a bit odd but allowed),
> 
> this_cpu_ptr converts a percpu variable offset to a normal pointer that
> can be used without preemption.

Ah, no problem then.

> If the scheduler changes the cpu then you would remotely access that per
> cpu data in a remote cpu. Read only acces is fine. Writing could be dicey
> in some cases.

Yeah, that's the current behavior.

Thanks.

-- 
tejun

