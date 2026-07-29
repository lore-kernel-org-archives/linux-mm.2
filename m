Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486ADC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7C26B00B5; Wed, 29 Jul 2026 09:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78A76B00B6; Wed, 29 Jul 2026 09:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19A36B00B7; Wed, 29 Jul 2026 09:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9806B00B5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:59:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A260C060D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:21:46 +0000 (UTC)
X-FDA: 85041423012.06.F86246D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id C004040008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:21:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=B7DQNWFR;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785320504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zbp+zBfZJfVeaygQWtWMqiY+gl3qT1JrScU/lq6U7Ec=;
	b=S6r3/1c0vImIaPOViBXw8vwoYmn9M6mNvghHzR4/VSDuQha3atuUx1m73MF7AHKgZKJl6V
	kxHDuo3FQpc6b99lq2t/gfl4zHL4+nBeT5Dyt/IrpO8ZK6IgJoaH79/NBCROHIGtulpztB
	behce1InflrwqUn/ACs80mUxESte/60=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=B7DQNWFR;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785320504;
	b=GoXf697nT6BSaXVQFLoaVwmVZIxrgsMa1bnsjX6eOSOf2hZxg4SN/G0TzHdbxC5vdDo2Lc
	e6B28zz2caa3zm+4H8CcsTNw6MmBzNymsWyqxwR9nzS/AnURnJMtgwFeqfEoapH+M4Ybmj
	m998wSC1RBQsET5ZqzojXGFKdo7Wcag=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Zbp+zBfZJfVeaygQWtWMqiY+gl3qT1JrScU/lq6U7Ec=; b=B7DQNWFRDfQH61qNpphDevX+dT
	o4HjnbsQrmKANyXCz+QQ+3PyKe4TLtnjWu+nask+36bpLrG5JPYEBUWRZ1TJHdkVR5A5aCYbSUsGp
	XKUDLhluRjyO39VVwY3PpMD54VAWuVonhQWbLoTczgvsxpigibwzsbaTJTMwVNv2n2AHR+5F9bn5c
	XyYRwWYbs8KkuNlmqeOZalOfLeHErp+vDwktRPm4TbN81Gl6aUC/ueoRln4gZ/Dohdy0IXzIGe/lM
	BiNcVGU3jAUTgBLqp02QOGz5RJpgd3krb2VXrMlMpzVpP6cS30gU4q5KwJY+IDN/AViAH8R3bmaAE
	G7cgiXvw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wp1Pu-008NmQ-00;
	Wed, 29 Jul 2026 10:21:38 +0000
Date: Wed, 29 Jul 2026 03:21:31 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
Message-ID: <amnTfwagJQpEY_21@gmail.com>
References: <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
 <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
 <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
 <amh1nZVVaaZSGD3M@gmail.com>
 <20260728122016.30752d36c3b3c3af231efa9d@linux-foundation.org>
 <44f81bea-d64a-4f73-8665-46652a928c83@kernel.org>
 <amkn21ftNme48Vbl@gmail.com>
 <f83d5b26-b369-489b-a305-1eb5ec6fccfb@kernel.org>
 <amm72Bu9qmWLI-9b@gmail.com>
 <d0d62d7d-8701-4692-89b9-84dff71a7cf0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0d62d7d-8701-4692-89b9-84dff71a7cf0@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C004040008
X-Stat-Signature: qs38sq6e378d1oyqr5u6m1rxfetn71uh
X-HE-Tag: 1785320504-516342
X-HE-Meta: U2FsdGVkX1/GM71zgUh8tFBeRzDT8WKcYq89utLUFSMDC5Z1265dFPhYpLb4ou8y+QXSaZw8wwqN6exV8CEBQgpH7CX5SplmRkBfVxRI5HOgk+iUBccxCbvooxCVuVzFUBzocyuEZ09qngpMrL4eka4IOwVOC/p9iLirey1ifme/k/C1Q+HX3S8dQD48KI7/DqtqwHFMVFObHewcRva4EW1vN5DHNBdDj6iCs80+jWFritAx5E+FBe6BiVsXyrhv2pbKhaSD2K5AQ3QQpSKJ+EN5uWgcBfF1y6ZDvoGEe8GlebFBO2bedIAJytn7TAE9NDuHFZEEcrZRFXRY37jk/NqmD/m056IUTBODHOed+hZoYylHyFyzU5pWRQbkDk1ePVqFGAIix5OMPhuwrVOdNL8y2dF9qIPqv7spfBWaDtAK+0+DytkNSjbjSuzVtObQ8L4sXgBZD/SIbJKRBtmnZMGdOPA1ehG5aCtr6Ww6S0wbiILKtYJFrkMgHbZlFOF/l6dkHGKA+7RkRqSTyM7su9ivcEjRWuCr+CHsIexaWhIX1XZ5FYQgAyML//uNopdg4/k8A95khYcfZoZ4z16unpVJPim2Ap5Eb+iNEuPX5+aK1uGdGdoaXvfaQOaY+tr7zcmnc24K4q1qNKkwKd0UjtV9Z74mOJk0e+3j5OxhDQA1HfWa6qRgth93rEJ6HoU/aWjyI5tN1aNvER/ph45sPW52cqJA4zah5jLpme7DoF9oZ/vuqg4DiUNCHtlhDwqIGQAvJnReTfI9VXKA79OVG/0gm8+Kl/WRtFnIdRCtr4/dazWnVzDzRuGhoGZqsDDxKWojdVOLl04fR5zC7DFaRB5EYD9GpM2bhgqabdvA2WtfFrW6gO5v7iZb3ZI03t4ZPSfwqLNzeNgCJs688TUg4TGHZ7xw+lcd6EPYNWq7Lk0p8ORLDfxzPCllBukf+PpDh1MyG/lpVOZPQEl0pVa
 wLPBDFg1
 PMZAKJeHn+BtYE0/Vi+wBCLvzwg1Q3eB/GqpDLabqwg3TYJLFuIqB/v8hAfEOcWT5uhzQyzRo4r98DsgX2Rk1pGf4+1wzYjqllMejK6VeKRsTyTdzZixo2Rx9+91wUhfAk2KzlCr9j/7SweSPBpMHaTLu3kRZQ9g9dsyyGZFoi/JLpWhajbw8hREpMZavde+Vd5JSaZqZLeaSo/YXcuWBfMoEzur2pab4FrIr3gcTKZAqBGogePp1E5vXw6pTnTffIFuvYwW6H1rPpYLZ+dKlbgsH5cSmX5w5/H/eARWuRddzNnUmLimd8hdoBu1+Cvlf0QqT60kgDw13F2xziWJiMtzGVW03yruQGp+UUD9S61pCwNjxq0azcxiHGGnK1tpQShkS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 11:09:11AM +0200, David Hildenbrand (Arm) wrote:
> Avoid bash scripts, please :)

Sorry, I will try to control my fingers next time.

Jokes aside, all the selftests I maintain
(tools/testing/selftests/drivers/net/netconsole) were done in bash, so,
I got totally biased.

