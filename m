Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A25D2F02F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ADD76B0089; Tue, 27 Jan 2026 08:51:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C186B008A; Tue, 27 Jan 2026 08:51:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E2B6B008C; Tue, 27 Jan 2026 08:51:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 329B16B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:51:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F24C3B516A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:51:35 +0000 (UTC)
X-FDA: 84377881350.08.2A59D41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 400A840006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:51:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MS4sJi78;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769521894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uJqRjQ68yl4IROC/UI9igPk5NUBlggebYJKNyUMba4=;
	b=GLzQb3JraU/8Ga7K3jIEIHhuW84Y9ZwAuJrp40OyhxPFdoL4XlDCQmMPhDQebuCx+veukp
	1WsWGbjaPrOl/q9WpeqI5kjYaoIaEuwJ0FJ3kLd391Kp7q26qiJ+MZ0eibdg7X/pdPOTM0
	x/do7rFdTktVtYfXBwt1RYyBXygQgSM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MS4sJi78;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769521894; a=rsa-sha256;
	cv=none;
	b=aXsD9uKN56z9yZmvkCC30/kUg23Bn+Gyf5fdVDIg9jzOqh2p79yIbgM1r5cCeB3tDOGJH8
	3cGYDEoPGTQfaLDg5XXof5Ia/FGc9f8o5QLuJzXsbBlSGHo4yvAAxpx2F+8/82OdBtRfJg
	fIvFm1kGt65vqjw3MwaY75stvwQ0TWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27C164384D;
	Tue, 27 Jan 2026 13:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC28FC116C6;
	Tue, 27 Jan 2026 13:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769521893;
	bh=xZ8tvKjFjicU4EYxMKVbg3cZK5aOCUTovxWxMSM6pqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MS4sJi78yYKjENIYjg+zN5FME+vxsGWJ09Ty6riuWJiKlzblTGFPuBT28uq/PQEcy
	 vUxNYRIz4qNL7hNQ529tFhRhm3Qy20kGw9aM50kI9a8wBwtwcvCe+78zrHQbLyeldX
	 vJQDAm/+4ji9DLR2O9LoJ5dePBatlrNDtJqMAcu5C5tXEliGO4ZD1ZpIXR39PXl3cP
	 0bAqppA5J61zVGmsCcXeB4L5aZSS/wGmubiKrxY3ZfjM6looctHd0v95paeb4x/mvR
	 01ALiaaxl/m9LCjARz1RFfFL/+bpxYaqE7eAJjFa4dGIOuXGgV043RiYf4JKdg4fcf
	 9PwOaKfl2nHmw==
Date: Tue, 27 Jan 2026 14:51:30 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/3] mm: Replace use of system_wq with system_percpu_wq
Message-ID: <aXjC4r5WA7QMTJHh@localhost.localdomain>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
 <20260113114630.152942-3-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260113114630.152942-3-marco.crivellari@suse.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 400A840006
X-Stat-Signature: f7m847gjh4ujaewwab3ty9up8wo1o3e9
X-Rspam-User: 
X-HE-Tag: 1769521894-847091
X-HE-Meta: U2FsdGVkX18V9ElgJpXgFPNqa6PNnoOjn8jmxHATLnt/HLHTiWnnKe0gbRUqopk+LOJfZQ44I3tXCvJ/nFdCuGGLdKYL9ITa5xF1fHRctrtjLBHWEqYACuHx9jkg0AJR5tHXsu6TJzX6XkF4Idy3tY9v5dFtxYaL9PqS1uvPb2zciaI0wuXy/yhcz+Jin2U32hoIiblVCXDuJBH9GlVTZczujjz66K8IVTCdMV7gtLM5+GzUzg/8STnZz7Y6XQg6R9ohMZx/QO/0GT4OrkbYTj1DzL9PCAusouJuJ5w8mHE2ZMdL8q/5L+oOrbwPmVQjMpaJBvr2HYebxBWR0nhiyvS/vQkOQO/666VX5VlG9rFgnk6Wb6qgixsIj6KWf88ph/DsMDyojqZTWfx06mKHi+9H5AuuESSlBLs0BEe/+sXbbbrY/3VToBFiuy8X/9diLNwcfPNBBfAXnuoISBN6sN5YillZKiVxes5oJU0zalKGQyU6yi5JH1jDCU0NzO64r+E4/wTw8BmyVPgqtlKOpKuy8Jt0SNSwvpDVSLYppTNdKd1sbVdlwA4bOYyMwsv/wQa9VJrrOZLfQlIc+c4reihFVZY31S8Qp4jqkksEuZd6EuMAUzpWBsvWq/tJsSXvhx7EEVJXedWM5YmFSgK/STSpg2TAlQUzIYYgVWW+l8HiuluCgJdrBHMX6DTAqwYC9DslNXuo/X07iac1Wt3EoTA5R6T0rSiQttrGK04W4NHHQZ5eZb/tojXSlM38Pl9syHl/95rhpDqqcJQlXc7yH3+U4lqVqskgOV2lLpOa810zlmllrgbbGSmZHmhUbfwAiOZQLSe8VTPHCO9YzDA7JbJF0PJhgxFL+VhS04jUR89IdVT9/M35Im09Ackubmq6FVza8BqfutRu62kviZDAhRln0P9cbTKGGGj/pIcm7I1tYh4ZtwWvkcGhKQTB2U0K8x8hceEJHQL6ikuAZu5
 FmQ5MgP9
 /IBApg0P7Hp6BnQG5XhkZBER6wyA84ou1EtE9W/0ITs38eMeF+aD0TXBotvIXkPBtOnV40aPQK5ONv6DojICnPx7yMu6hb95F9a0imG3Jh0+XrURsDUM/NjCdobTuuE4kTRqbNtMPJqEd1j8OSzKFjlDcy38r65F1xR2q01b94GVapr8/kKfcjSF48Ce1NhrRiaiKM8WIVOppZQV/d3VMmy7NDabBFrdKlTC0v57djNufvKZ8wSXbqxCu3QGeETERQ2Db4sYRrTQuTkG8xNNQidM3wbkkAysZIINW1sRaUImJ07Of+oh3HCbrkoQceCF30vllsRCP6TzJ6qfp+ffMaAwO26GyUzZSz2S+SDxh/tKRGcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Jan 13, 2026 at 12:46:29PM +0100, Marco Crivellari a écrit :
> This patch continues the effort to refactor workqueue APIs, which has begun
> with the changes introducing new workqueues and a new alloc_workqueue flag:
> 
>    commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
>    commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> 
> The point of the refactoring is to eventually alter the default behavior of
> workqueues to become unbound by default so that their workload placement is
> optimized by the scheduler.
> 
> Before that to happen, workqueue users must be converted to the better named
> new workqueues with no intended behaviour changes:
> 
>    system_wq -> system_percpu_wq
>    system_unbound_wq -> system_dfl_wq
> 
> This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
> removed in the future.
> 
> Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs

