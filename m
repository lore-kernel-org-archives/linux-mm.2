Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C9CC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3ACE6B0092; Thu, 17 Sep 2026 22:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEAEC6B0095; Thu, 17 Sep 2026 22:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9DA6B0096; Thu, 17 Sep 2026 22:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A079F6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:39:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05907A0560
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:39:04 +0000 (UTC)
X-FDA: 85225325808.13.0693B3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 63F43140002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:39:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiP7VDcR;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789699142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFn+Q7rC2VQ5SocqsOrcZJwTW1fdmqaD8YlZTdVp2Do=;
	b=eQ3B2uSCiyeSjG/MzRCq0Irr7cUbwYznOAPtr0OON5R3Ya2T1+BCJtzOfVefahTKKzvfqT
	k0vGwk9BGunEJERwkb7fjXtUo3lJpH4XIhqsq0m08d1QFDHjha7EKkl+euPnaZ3kQbZqfS
	EvnVyEskOgzkdL3yy3qvdtjN+d0pqLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789699142;
	b=P/xUWvdP1nt0YYucI+sLYJqLO14VvioziILi98bLpy8sqcOOSLDMn74tOhE/Bz+WOywBE4
	mlsU3pe2dSgOBR1WfMrgvDHnp/OemcTsbc2o96M4Gk1KTgnX6/x+Yfr2yVckXFOTAkWIsg
	CjpUTRd9x0w9T4QkntkFLZDt2mn54LI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiP7VDcR;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F19D40631;
	Fri, 18 Sep 2026 02:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE8D1F000FF;
	Fri, 18 Sep 2026 02:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789699141;
	bh=XFn+Q7rC2VQ5SocqsOrcZJwTW1fdmqaD8YlZTdVp2Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiP7VDcRQNxMZAViYh9ABN4d1iXEi+V+WYJvnsLJAWfhT+7QAEotrRl6/3uITknyl
	 6ttkv7XDTs0ivbLlBK3OAqzmDL9aj7TLgOpOkmxJYOqmcfG6CiWZX0VRwITgxVfG9O
	 Ai0TSUZsRilaiaPW83IHQgYwu6lIZpA/s5BpV38Q8m2y40zOoOBC0Qu9oVv4AN72TB
	 S46vabyDMQ5O725glZrJD9WbtjIOYpUauf3tuqnzBHLQN4aGPyd5VYRN1+7p4+kE4p
	 uW4LOKg+ciwSt4XlhEXu+ClA50kwYL0IpZxAPoQnsuUsDECimD0zW5p1MueQwKA+HO
	 qD+IjFaOgQtqw==
From: SeongJae Park <sj@kernel.org>
To: Karthikeyan KS <karthiproffesional@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: reject zero sampling interval
Date: Thu, 17 Sep 2026 19:38:58 -0700
Message-ID: <20260918023859.13556-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917180013.1279018-1-karthiproffesional@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63F43140002
X-Stat-Signature: tj5cjuyk3ejhgrrqnkmm16gr8xczgyw8
X-Rspam-User: 
X-HE-Tag: 1789699142-245096
X-HE-Meta: U2FsdGVkX1/vofQqn185TyXNqt1BWQcnhXk5RsmuwPxuSxz5fbrVxS6uhds2lw7t4TjoiwZkKF6TerQZIOWN62MN8EQdDl2uoILHUrWirGWg1+uTc3v1XGHrEKT6ul7ZJNh+5MnUE9I6DYdfMNz7xlL1Bm3dTxRW8Na7MKtVpMBuJji4bXICdCLXzu+8wchhQwp8tdkU83Z+v0nKzvXc5ol+wT1x94M5kT4hv4SjF5PC3tj/SkdkSQRBY8hOYsEiiFzMFMKOowffQhh3wNxcdNOGJ0Ie3RyGd1sZwycp9ArOMpBglS8NGWTgReqBbZKyReGbfPWKnSUR7oMO/gtlgsAApOMzodpKauLc0Gd/8/1tKr70JNUiGXdJ9jFauKHgWSMYYMJhlWnzpV0p//iZtKS+4XF+qentKT4NE48PlqT7JoDtpVT4ISyLEI5yRUlcpWUwKe6vC1dLYekI9q9XrT7w0O9AfAxrusvUaM9sFQQS26YXy5VHwQS81XKmWMfEeX+CiC5WplAENVVTyjzEuXSK1RDPqGKZnKcsy5xMfJkJtkijhw9uhUDEpXeUhEgk7fXl4cLKcdkn1X9Y6gDYgSb6eBEFxgqup7J0F4+i6t0Ux8hvBAJyGQOa10fEvVj7ckJft4rQF4LD5A+tB3jlZUMSL06ARr9eqxjAnX9YyBwI81yJTBuni2+EY+f3NbvsoS+7zVBjsQQbrFhtvL5L41E4UARzM1YPsMvf0GYUumooZCHwulhp+HFIbABmNoX4c8JULTEJoiRb0uQfOGzcd7ptYyuOXJvLykj3QhFMa3+NImuc/UtAIChFEbwkx1vEoneapoXhMiAsqJgYC337WA5QQQK1HCqEQOr9zyNLrmgknt0tnbUtt/BYnIDthU7eZTjik12wiELWHq2jgB1f5X3nqdOVBxsW4BO2ptu21AfFw2vyq5oO8KAJiiZSlRMV3LLpxq+3yrMn3ialUEZ
 D6pwqBEz
 dUvdUhYPiiT+JpFz3u0qpBPU/tX8SnZ+bgotSFsURr1H8ZjNSF8hlGKipTaYyxMcEJ3MY2BBGU1yDsL+UUfWkWucF+HRA9yOuvHoPpK1ntyd2g7qGSmJ96/I/vNPSYkh2Ujsnijby+VTkQvyBT+tBE4qFUL274a48vv3Q7TpNgvA8pjPyAg2GpWd+NV+UiOG/m4QwHTNXQjr++bMz2F00Wfzxs4Mxc7ybB2TYtH0l+Iim7A2k7izMRkW6JxSonj7lkvdiD8mm6WzpR184OGOq7RG/sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Karthikeyan and Sang-Heon,

On Thu, 17 Sep 2026 18:00:13 +0000 Karthikeyan KS <karthiproffesional@gmail.com> wrote:

> Hi Sang-Heon, Hi SJ,
> 
> > I think SJ already commented on a similar patch. please refer to [1]
> >
> > [1] https://lore.kernel.org/all/20260722094304.3132750-1-dayou5941@163.com/

Thank you for pointing this out, Sang-Heon!

> 
> Thanks, missed that thread. Same objection applies to mine.
> 
> > Can't we keep supporting zero sample interval and fix the warning
> > or the real bug instead?
> 
> I measured a few floors for kdamond_usleep():
> 
>   floor    kdamond CPU (3s)   vs sample_us=5000
>   1us      84%                28x
>   100us    42%                14x
>   1000us   12%                ~3x
>   5000us   ~2%                1x (matches control)
> 
> 5000us is damon_new_ctx()'s own default, and at that floor the spin
> is just gone.
> 
> Would you rather we just document sample_us=0 as accepted/expected
> behavior, or clamp it to that default inside damon_set_attrs()?

I'd prefer adding a comment saying zero sampling interval is accepted.  I think
damon_attr kernel-doc comment is a good place for adding that.


Thanks,
SJ

[...]

