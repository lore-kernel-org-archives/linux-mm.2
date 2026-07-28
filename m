Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19CC6C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 03:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21BB6B008A; Mon, 27 Jul 2026 23:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD23F6B008C; Mon, 27 Jul 2026 23:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8DC6B0093; Mon, 27 Jul 2026 23:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 898D56B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:21:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 023BAA0255
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:21:49 +0000 (UTC)
X-FDA: 85036735980.12.DE5B02E
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id AF28780005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:21:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DUH5VBJo;
	spf=pass (imf30.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785208908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOUrqvoxCz+7e5hlI2+qhp7FLHW1ZnUKoyhsbE1eVfE=;
	b=IecfHspieNm4qrR1JO6900cB/wHOeny0fzPvxsY+lFanVgzleIIsZDmofrvj2lM/kbW98w
	dNsiSYl11SnrqsaruYkVfoWbOVY4N8rb9X6J1kM0jWNNTyapO87N10Mztu1xX0KuyTxZEp
	doK8w41z2vnd9cf2z6gzYnEggYjV9DU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785208908;
	b=eVHVUXz9+9IhfaLTP6+CfAX0rh8FESHAHFxDpJK7xmpgoVuWavlxr1ZZnTsSd5mSkmrmCI
	PV4zcsX2oKyrhbIDyYPIWtdRveGJ+d8p+YHQBkgCOi6HrPHLXXBhpVsybhmspoZoLdkh25
	Mhk07wYAMelrhDBwm84IMI2RguVpdiw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DUH5VBJo;
	spf=pass (imf30.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785208905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SOUrqvoxCz+7e5hlI2+qhp7FLHW1ZnUKoyhsbE1eVfE=;
	b=DUH5VBJoxuHFy3wowuNMvH59RblgGSz9zjcp1q1HcR38UXPqWoTH+iQvvXha50A66TTa2C
	YClNohua+edkbMJTlsqGVy9HSmJZDW5IK5zuAmkvjQ2PC1uIzrHnmsEmbJ2VllXksH7M4+
	ms43c7r9t+CqbhVPdV2fQ49bG5oWR+M=
From: Hongfu Li <hongfu.li@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hongfu.li@linux.dev,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v2 2/2] mm: Extract non-swap page handling to do_non_swap_page()
Date: Tue, 28 Jul 2026 11:21:19 +0800
Message-ID: <20260728032119.34053-1-hongfu.li@linux.dev>
In-Reply-To: <cd6652a3-547a-47b9-8907-e98a582a238e@kernel.org>
References: <cd6652a3-547a-47b9-8907-e98a582a238e@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF28780005
X-Stat-Signature: i3pxhdizni7xzqgqxob1ea398t31k8d6
X-HE-Tag: 1785208907-820293
X-HE-Meta: U2FsdGVkX18Uv68XrOYwFa1VR/gaKdBgI9QzOX4ulDDGoqJsJ6U2fCI9x+3xiDh3WuJHaXV5WBZEY6xzQJf8V3GwXLE4F2DLFmsanEL7Z0Huy3m+7bpBLVgjmC+t0cNeaREPN9yN7w8a7XyJe52CSW7aGJFpcJv3SyMKy9vt1YquDJKfILvjBy37+VBxQ8C8uGFFLfFzIGyk4OdoaVdG1KLxGc+V4ls9ezVHek30UJRfNstTfDHzdjy2p31ilTWWQJty83Cz9Yr+A5v4M6xNOztDJ6MvV+ofArf4bJ3icEgsMs3YJ9zrrcukpIhZN2VAK8oWKd4UEW2RZuzVqBHYA8MyXFvGb687rP4KilBJN2o04MQUxhADoiIScSzOXaFMxtIRzsfiG8XFp4pFYq+K/s6ofr8BYU0jiydeJTmGugeoXvOLcIcZsfNZoGgbIVtB2qM6lPaltL2zWdey0QtitwYEPQJv15DK72m6FgeDLSNT9rW2+Cn8kVhHHESmPtiJgnRq8PGLp863Qd+FAs+UhIrTl5AVhrrt8blqMIK8P2CiZ6dmFTPhG6MeMn6XoExfkS1ZCaR6M0Rib7n9+lmYpv1llLUQFV+4bZeu9k53krIR6zNVAp+FJLQE8XvIgEnhv3bCrRNhrDK2pyTWYOkYCBFAXk0wvIdDWW4w7EvS6zNkWl/3BCJzcGAZqpvUIaSD8KuorW50UQyjibSZ7Lmb4p4UsLSkBZvIgnjPVXs5PrWPlwLEc21nwDfJxcNG0DmX2OP3vdKAGCFJ0JLN33j73nAobSgckEhdXYzEhZfW4XshfkTtrug5wk1o8hlX7lQl8q4kZODMV7JWvMyL6RBnfwsB7H47JWqk/uYWofaolfLjqB7l9ehe1sN448E3yRg9+eraRXatY9ay+dhYPTSRPrZtrsVvoBo+CKnjPcHoN8y/Dd9LcnGdCal9UUfmO4hjhn8Dz/cR8aWgEoZOfRc
 O6/OJPnY
 wuH6lgoahiUHQ9OQWNyCqKMZ+zMJhm14wfoyviSY3iznbiYeYSiLf0YhFZzbXGFLBXA9tgs8Q73JVpaP/wj1Fvf04ammE1Tc489wQkBFBD8Nh6IooXVk/s0FhHM/PpLwOr7fQBAzvhdcALmjiT5jIwrkMIeKoV5iVKbyl49Qlcsh+zHbCERpA2Yvuv0TRSqlXmzJw5UelxcfZhgLDqg6X1WNelmr4FFGFXxYu3AnKeMj0VpbJfhkH9mhgThJcl5REHbSABeHruvp/vrBKEbIjubeB4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> Or sth like that. Then, maybe in the future, we can just move do_swap_entry()
> >> out of memory.c
> >>
> >> So we're factoring the wrong thing out in this patch.
> > 
> > Thank you very much for the detailed review, your analysis makes perfect sense to me.
> >                                                                                                                                                                                                                                                                                 
> > I'm glad to send out v3 shortly for your further review, with 
> > do_non_swap_page renamed to do_nonswap_softleaf.
> 
> Read again, that's not what I meant.

Sorry, I completely misunderstood your intention.
I mistakenly sent v3 without checking your follow-up email, which was my oversight.
I'll drop the second patch entirely in v4, and carefully go through all comments before resending next time.

Thank you for your patience.

Best regards,
Hongfu

