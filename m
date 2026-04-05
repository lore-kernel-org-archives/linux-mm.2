Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21FCAE9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 19:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A586B0005; Sun,  5 Apr 2026 15:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB416B0088; Sun,  5 Apr 2026 15:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0E86B0089; Sun,  5 Apr 2026 15:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7716B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:34:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FF2FABCEA
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:34:52 +0000 (UTC)
X-FDA: 84625504824.15.6B5EF21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DFB3180003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:34:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hVCFfRMq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775417690; a=rsa-sha256;
	cv=none;
	b=OQsCeDYFfMvTHghFWzQcDpO6mSuiaQfovyd/n82bPLjoke+tWJQHEWEyGQa4mVdVTTyJ2k
	Y5OHMvXE2kzYFYss2+jIw3qKk4+D2k88C9xhdE5uMSLioQZANFFRsTw5Q814CJSX1NoF33
	+USgQ9war1anjhVzy7l7uxtMEY/Sows=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hVCFfRMq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775417690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rspZNPdza5oEllYhN/6WJf+aUY6o7twyO/ZLztRupEU=;
	b=jQdXw9u1b+As4FzY5hxk7l6KT7ktzBS7ELT1Et3Xa+HXMGByYcj/NoSSQHKUDyx7oTE6J8
	NZHy7+DcjtHoB6XPEcLTxtjUq4fWGKyJuQ4UGLV4yweqm6noNUoSM0xWfHhySSuTBi4x+t
	5zxYpmdp5XZj0svkxkpfIyQ78gJ5U4Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6113340A34
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A251C116C6;
	Sun,  5 Apr 2026 19:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775417689;
	bh=/fECXG9ZqJc3oNxKEN0/I4QGArOiiZWi2ZzFXVLlCxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVCFfRMqh+BmLtZVTBRUNQ4utPUU/7ZQhftpX/nZWdxjrENl275FkHIY8afZ7rWK6
	 93k2TTtiKOokm9nHGy3GlvFW7lCjMxjhaHAyOXITgKYBS3ie40n9g8Dis7CaysFIKP
	 rMhtJWDsc2Hwm08Gaf0YYwjJuUmqpHqRvGT3fHU1+T+0CboLLswbTIiJ6ahqNPz+d0
	 8mGnYjNW/WuYvmxYrR716spSN/YBciK2341Bc4hgRVDGLrGEIGUWk+WjAL9gBaxJv5
	 LJ8ufGFZ9tivD7H8j/SYo42pjqY3HeWk96QYY0cA5oGEJjz0uTOyNw4M9hfwJ6yn54
	 wDfWJgsymaHJQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v2 3/9] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Sun,  5 Apr 2026 12:34:41 -0700
Message-ID: <20260405193441.110298-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6tyobfpix9wpmbp8dprikf44hazroi3e
X-Rspamd-Queue-Id: 4DFB3180003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775417690-273138
X-HE-Meta: U2FsdGVkX1+g+x92dkiP0xcxeo51XmrtmqZw8yiIypouCPA5PlQIEwtlu8GvCndX+281Cjk5UZ72zqlCAG2hkQrF8Ouvw3BgQHK54tWltb8CibPBx9sj+MGYSBn8Auc6P2FRECsNa9sYG8AyEvWmv0JDYyZpdW1dAvZISwEHCmTZpsmxQDTE+otWci8IzHJ6DbXUdO4Zqi0tTVrwdKVQZJS8IjV8gCuq/Ohqfex+U6PYvlQ4jsqUHOJGw0VPsa/dcQkNGpl2Oh6Yymc5lENHCTogDiPNOl0v+P2dmDXYlINUNe186VL9bM/nUH0VuLwGeL8HqOqJCSzNqsyDeKYsmYUNPGL24sC28bJcp9NLfGvK/PnVcba4iUaxxMFEDEdX8F9qnAMXrIysWzRSg33e40hp2VJLjNbKRKW5CqkLmQ/+N9VNkFJ7F7mirFsEyAt+ZcUR9qu8ycRx8o+qt+cVLaULAm+0XVTP6nwhvksSjapadDfJIDc+0nhW+wM2k5gG1iM88XpcbZtQXVM17bAuPHRjRtt7H60RBQLR+rr6ZtntIlqeRvi5pdE3YBBbsuVuo6Rvh9p6MhuUmFdv3rp8diewIHGaGEXKELm2fUQW4qoTJJSBxrIGackAJhwAw91WToh2aK5woQZFDz6+smLy9DCdal1IaL5E5tybvoDYOysaZ/PByMfCPg5/YvlH1lgCCrYXow4OjJXCdDXau5YTDLpMQXw4R859uMjp2VEWuoe625aow5KVqm7geo1jlBOUmlooLumAE9CCOCs00ifBT23CW6ejTqJdtrS/3//Nh/wb7lUPXZ4ZU9zlzuTLG5quwClWCCCg83LvfLc/KeznGT6sAG7hgS6EjNHoJmkhe5IjODt+uQ9hBCsedC13ZAVPswlSFDhY1QjezQFQ1zQ5gGCHznk268xRcZhk2+4ngBFHXW7NXY9xTbzm6JWPcssJ60INcyitpngaK5YtRa5
 xy4fIfuN
 KOWIDzpV0njYp5nwEhdVsoK0LD7SsC226llVYB+I2UohoGZA0nFdwQpQqF2iAUX/FyThMUMZnzkOiI/w9YlSUKiBXF+oBbnqIKJcJkS5cN3DrdCL5Er1jqGW+wgAiSk/y6kbw3lKgsArfd/r02m6oSNkKSv/WcAf5RLAQzGgl4hudbcFytlsoHfzojh5JLjpGqacsWc5ehGUyP2srT2CfHIVz55MeK4SadfKVLJwPhDncISLyOWU5swumJnFQmuFNw6brelGwDT0uumq0V7riDsPPwqBIOleY3P8jKJKVoGW+8QI2gMtncfSuYndYKvvVHPrWumO+pjdt5jeo56Iolm6ZkqLaZ8HwuVaxqlvp51PMgX5aXt0TLlYx2t8RoNyJGePSoA9jfS/fSTqLHzEzFzgEaPd1v29of9fbSsEp9KLPkSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko gave me a sounds-good suggestion.  I will make a change on the
next revision of this patch.

Forwarding full sashiko review in a reply format with my inline
comments below, for sharing details of my view and doing
followup discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260405151232.102690-4-sj@kernel.org
> # start of sashiko.dev inline review
> commit c4d090b9bc99178548ec06da52d6f75e0b392a34
> Author: SeongJae Park <sj@kernel.org>
> 
> Docs/mm/damon/design: document fail_charge_{num,denom}
> 
> Update the DAMON design document to describe the new fail_charge_num and
> fail_charge_denom parameters. These parameters configure the DAMOS action
> failed region quota charge ratio.
> 
> > diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> > index afc7d52bda2f7..8a8b04b5e8537 100644
> > --- a/Documentation/mm/damon/design.rst
> > +++ b/Documentation/mm/damon/design.rst
> > @@ -565,6 +565,27 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
> >  the documentation.
> >  
> >  
> > +.. _damon_design_damos_quotas_failed_memory_charging_ratio:
> > +
> > +Action-failed Memory Charging Ratio
> > +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > +
> > +DAMOS action to a given region can fail for some subsets of the memory of the
> > +region.  For example, if the action is ``pageout`` and the region has some
> > +unreclaimable pages, applying the action to the pages will fail.  The amount of
> > +system resource that is taken for such failed action applications is usually
> > +different from that for successful action applications.  For such cases, users
> > +can set different charging ratio for such failed memory.  The ratio can be
> > +specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
> > +two parameters represent the numerator and denominator of the ratio.
> 
> Should this documentation include the fallback and default behavior when
> fail_charge_denom is set to 0?
> 
> Looking at the core kernel implementation in
> mm/damon/core.c:damos_charge_quota(), the code checks for
> !quota->fail_charge_denom and falls back to charging the entire region size to
> avoid a division-by-zero error.
> 
> Additionally, since struct damon_sysfs_quotas is allocated using kzalloc(),
> fail_charge_denom is 0 by default. Would it be helpful to explain this default
> 0 state and the resulting fallback behavior here?

Good suggestion, I will add that.

> 
> > +
> > +For example, let's suppose a DAMOS action is applied to a region of 1,000 MiB
> > +size.  The action is successfully applied to only 700 MiB of the region.
> > +``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
> > +respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
> > +1024``) will be charged.
> > +
> 
> [ ... ]
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260405151232.102690-4-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260405151232.102690-4-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

