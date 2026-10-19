Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B0FCCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1CA6B020F; Mon, 19 Oct 2026 08:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188DC6B0213; Mon, 19 Oct 2026 08:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8BD6B0246; Mon, 19 Oct 2026 08:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA36F6B020F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:43:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76AB71C3EE7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:43:52 +0000 (UTC)
X-FDA: 85339342704.16.6656829
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DE72E140008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:43:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ouS/o/1Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792413830;
	b=mE9n02x+dpIP/BbtLBm4ezveawl2uehJbI/bICRe3qIyc5knRfrS1LvnXMM58gtnP8tqzB
	/Uabmx9Thu6MF0T4/SVHMLUBsZIb7a6tHMj735ZDeJF1dUvVx81lG6RO3fDtOV4z6BW6bT
	nBLmYDNSpb13xljGhM1PadLB46WFNbs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ouS/o/1Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792413830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Zkftj1gAqFgA4rA8vvXnjRSqbYzke6DaC9Z4l+O33A=;
	b=S0B+SNd53APmGjT6gjy5aOzuReumgK/LyqJ6OOJ74kfFR1NxOzXwb7yFYdQEK/Za3yInZW
	cIOIU1ZPYAL1oUgh98Ep1rLeRU2UpiR+DBAsoRuAOw0fUrFjbG0RhTgt3WqJwnzzQ51ol4
	EwGaBAdnoNx0CTJHPgWL6xnLFJXRqx8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A924D601F9;
	Mon, 19 Oct 2026 12:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293ED1F000C5;
	Mon, 19 Oct 2026 12:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792413829;
	bh=+Zkftj1gAqFgA4rA8vvXnjRSqbYzke6DaC9Z4l+O33A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ouS/o/1Qkx0tn1uUzoxJHqMsgeZeffWr/8rLScjjDpsS/z66/czXzEc2w22K64n0T
	 gNiTue+QsIjdZJliePm+bIWmCEkbDZIOzY8UXllU3LQsFekGXUOp8rz3ya279MGLRn
	 QdUVvAKQzBMPA/sq6k1T4231WjUx8IwXImBcEbiuzBltN6ImIPPfWs47BudMT1lgdJ
	 Zgy/bbfIaMDgZuTNIdFVF9HHFbE74f0Hafqu+DvhLUPJrrX3DRAjzttKDTfpym94NH
	 /sInb0+8LOHyIIeTNnWVbkSoRinBiE+DGb+afN5yhgLMrFZ8/DX0sK6m+LaiThFpMf
	 vxQ2hOjI7McHQ==
Date: Mon, 19 Oct 2026 13:43:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/mremap: do not charge a shrinking move twice
Message-ID: <atYQW_lfJdRZnU_n@gremlin>
References: <20261017180412.a79a36e873c5268df126cde1@linux-foundation.org>
 <20261018015044.798412-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018015044.798412-1-nickolai@csail.mit.edu>
X-Rspamd-Queue-Id: DE72E140008
X-Stat-Signature: pgq16td58f1ftkuhzcri4z9gm6cfhb85
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792413830-485183
X-HE-Meta: U2FsdGVkX1+4klNzcR5K98f/HqtArgvrok6UROFwJLG9PZOpSqNwx0BmPWvY4XFgQ4yZlfJeITHKrdi0OFFyt5tC5WVZa/8ffZDETU5xu2YojIXWB9hndSriCwcZpls6GYADrWE+AwItm3Ud2lZadgTvfQ2sV7IE/ZOTUwCfC7cbLiTe9E8CbjZC/Wm/C5ViQDjT2WwdfRUOipEYSTFlUWNXUs0jOGWerOkylsd+JlZOOVvw3uvBag7gGepAhXLY0hUIoxD8EtnzO3U0CZJ6y5V39xQPplo14yuxJO49xCJfO8nLWqfYVZK7o+9YQ+9As7YOzlQnfimehbd54+Kcv6F3u85DCLKyC3JCpqzY/xSQs70wgQ2SBzFrgmGNog2uax5TuYpJSIKXMAlSm+CyXAdlNKDbkvBxoKjmvGHA3KI6+9K8iij9Z7e7JJwvOd2dAo1CvrDumfGyx8mFUJZrtjrmgEZ6ja0yrsQel8OuH1vq9qGpQduQovYuWxE6nHPetcQIAM3CkeaqkZWRl8YQmjTAwlspMvNL2qkKZDb2FmuxRpuuxCF0KYv48XXufhT1s0sgSLJUjLi0VopLVqH+DoNDdEhMq0xvAhah4D3m7x2qGlfXUhAw6Rj8dpBLsnFmyoV3lFIG1p2eMs1JtrGHumtL7o+D2i+4YWJ81auQBRQouvcObEKk9seyMa/3ZfiYvOO1mp7dYha3+Wod31nze+Gvf8E7NEiDubWywoPKJK0cLh8y02vae7SHSk1Bwwy87y5/tVb7/EZJ48GdLBPi/pEbISi+vaEKH8t7CPbakegs0/WeNwHF6Ib97Tu2dMSbFs4/HRvYP8B0beLhB7GsmFS6JfqlubrNMKNxBewgZ+EXpWIbPIri9vMCe2SdffP/oUk9qpkLPL9HQapSZPPOtew5f1UoSU6OAarHghDiAYa76dxAHj2h6wRv0ygxPv6hn7ZUGLAYMWPsmw8NpmD
 0d3LQ54R
 cvd0S/8RCC4uKoU+Si1lPkbW0XVJyru3nR9xPNUSRn26QOsU9n4IHm52Eo1YuvVzK6SqquocXZfUrShxj1i+wLmCwKSTtoYIy2zu2Pr0YILws7TavNgrnucWcN1sH1lx+jb1YQRzoQWDswjpeR/7YO6mecSYshKvRJ91X/LpxYxSOXLJ++ARShkzAKjL29BzD1yziceFASajg2D188sY7iw5GrpXQfWhMeMVWUD564gW8025zYbJsacXujLEdvNlIBcwGNXC0fkXnbsZImRZcKzMj9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

You are flooding the kernel with patches, 17 series across 11
subsystems over 24 hrs:

https://lore.kernel.org/all/?q=f%3Anickolai%40csail.mit.edu

This is in strict violation of kernel policy.

If there is anything valid here it will be treated like an anonymous AI
report.

Do NOT engage in this kind of behaviour moving forwards, it's harmful to
the kernel.

--
Cheers, Lorenzo

