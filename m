Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C8BCD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E726B0092; Tue, 19 May 2026 11:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE7E6B0095; Tue, 19 May 2026 11:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B616B0096; Tue, 19 May 2026 11:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C467C6B0092
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:08:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D563EA0564
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:08:51 +0000 (UTC)
X-FDA: 84784501662.13.C784714
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5562B40014
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:08:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OxFFM0MU;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgYkbZJgZWooRSbMudoOVyaocfXuJTr9WvXIHM+FCTI=;
	b=YfmPBQvN6+Z+yMfepdhBycSOGwXwIXXyXIkWRkqL3vAPYVsLDr80/yE2hD8HUEl2d5QKa0
	CWgKUm4Pd0z4T1LBVAw9pQKPy/yhR20gpzkCT7ADk3vUzqeY0/XpdjFajEGHu3TjM0f9+A
	34rYRuhKovIyV+JqVY3ymr9xkS33ln0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203330; a=rsa-sha256;
	cv=none;
	b=Q7RvcNbaiLv86kXqTB1XwOKWFSAN87uFQbLxlWHZlnvT+Vz8Y8G8Y2hHy0oz2G7VNIGl9S
	kAHjZ1HLKmnIcfB+/vbasnL3tvcLnJRjIQ9FRV/lQzNQigOHi5P/wETKsmY0j7aCwo+QC2
	EEdJiZ9d/dp+lMmu5gCLubz09k/CTtM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OxFFM0MU;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C292960121;
	Tue, 19 May 2026 15:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C42C2BCB3;
	Tue, 19 May 2026 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779203329;
	bh=FV3bnHAWG6JDwG0vOhj0R9ovh5EwMNT07xgca6IrsjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxFFM0MUdtG1/OomlH1wMHjesjiBoIXpggoVovV6Q2YPLfYRV7l/whvmgtymdZ38S
	 GL9JouK6vRu6x7woFSDvJUCPSS+FdkAFnRKZaGZ3PdcYHoWRzYCwIfM/X8DIoyFB4j
	 mi2ZrlnIX2WKexq9YtYTIC2l9RBEekmXzkMXLQVLT4j+gx/Eyfn39xsZhTcoVE8gwe
	 VM7qrlaDqPKuyKXB7U4fvB54AuqXNLgcAP/ghlyAXH/JA9Nei7uRREUwoWB/dSqTBs
	 vSAxLPbI3GfB+L14zWH/kLR888VQCgrrFHQs8G5CGQnSEWjqDDW3BREPyLQ6qexZ6E
	 sNRPwsL5eUy7w==
From: SeongJae Park <sj@kernel.org>
To: Maksym Shcherba <mshcherba2000@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Maksym Shcherba <maksym.shcherba@lnu.edu.ua>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/6] mm/damon/sysfs: implement update_schemes_quota_goals command
Date: Tue, 19 May 2026 08:08:21 -0700
Message-ID: <20260519150822.92326-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260519073352.16587-1-maksym.shcherba@lnu.edu.ua>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5562B40014
X-Rspam-User: 
X-Stat-Signature: z3xbt5x51kbugzoqyfu38dskgipzj3q6
X-HE-Tag: 1779203330-437969
X-HE-Meta: U2FsdGVkX18N/qzGR10cw81uvYbo/zw9BKsL4+eDdBUAV5GZLEKyTz2Lxj9En7kKansI+Mz8nLJ4lZbRDo5Pn2MYrZY4GMb3Oe0UfIO2wl0JSJ9DpJ7KACITTyDap7AbsZaHYPA0ob5kef4Jmua0GSPOgN43mB8LhDS+SVm6mg3WNcS2p7S9O4c8D9CZ6dResLQKzttS/9DLpmURZ3ACi4pvAEaN+YmLWwMoVIrAex95clKLak06SyDptC1vAe4Ms00ITzbrvD47WdFugCrwrdtPfYyo95luaN9ev1hSM50jLRc+aQpFwGSzovXNwhbczT1xGGl7PCaOwdIbLWIS2l0eXKwsMrM/3GMHYqaaLZXG4dNV17tNJidAIrYducvkg79LBub2D89wVz7nsN94faKUJefY8dhLJ55SYUPjF+sk5rk7YeXUFFe2z/0ZLKfgDdByRf8qf4YsBB0+wvGFJY1Z2/PoNpAiamVIhnGS7cjsg4P02CLiTbH51Qf9xsb74Z/CH4vtwR6giWq4TlbykHkzLTuKtCrQHP1kKJKlvIYuDrm6AO+SWc1SC4fRNP2cDUSnOPZwKSlOfCUjr4IZgIb2jOk0ig1TFPDeYNY5W8y2LKh3vOk/JLHtkAg2we/2Q5bGZAIUCJm663PGGwP7w4GWQMc6LCPjLFqo7fVhiHchnO2Yj2moIjOKyV/dE/MU/93r+rqYRmRo+6mT6nQKanB84Zm0naYVCmD6oTHTzkOaclkdoCVhh7EtKyQnG5eu4IOXFBDAAhls9RlF4UxAwSskOitL8md/3aQNSG5EVn3FMwmQ5q41n+weDLFguR3TCrgbuobu0AvyP4tZlBEjPHIAzNWAQfLOBJ92enFeIlBnvQn5R2JvI5suEGGU4NFRDkPaSgcoHM04OuSrKbHPPeOXwzPNM8FEYluYAAtroNsDl5jhO6oDbsFGR3NAiWfnMeS23SGgycOfZmfTyob
 3EaDgdA/
 7AMTrKFUwHMfrYuH1D67rP8d71ReIiqySkDPu2ZRg5q1F9tePE8AkHaIsMYu37Y0AOg6G060oeJ2C7cpmjWPRi1xvbavN9vOL80uC9zNEt1Ma370NYVvNAIGS9lzM0qJcZBf9H1FPvbOVh2yfQ6WIHsixmpJn8f7vRfV1HdJEwbvn/mkintchIN+10gtrGH0tGVqkUhfprGL4ZhxYrMkppTl42S1BSMnRO9INjwCK6XxcngTw7oq7QKfCYcqLHBg+JZGzJLkvHfHMU0DoDHXlhFyuJixqby4W8/OyOLjJojUYyQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 10:33:52 +0300 Maksym Shcherba <mshcherba2000@gmail.com> wrote:

> On Mon, 18 May 2026 17:17:02 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Mon, 18 May 2026 22:09:28 +0300 Maksym Shcherba <mshcherba2000@gmail.com> wrote:
> > 
> > > Add the logic to copy the current_value from the internal
> > > damos_quota_goal structure to the damos_sysfs_quota_goal sysfs structure.
> > > Introduce the DAMON_SYSFS_CMD_UPDATE_SCHEMES_QUOTA_GOALS command
> > > and integrate it with the sysfs interface via the 'state' file.
> > 
> > Could you please further elaborate why you think this change is needed?  What
> > is the expected use case and benefit?
> >
> 
> Hi SJ,
> 
> The documentation (`Documentation/admin-guide/mm/damon/usage.rst`)
> states that users can read the `current_value` file. However, the
> kernel currently never updates this value in sysfs, preventing users
> from reading the actual metrics.
> 
> This patch series implements the missing logic to align the code
> with the documentation.

Thank you for clarifying, Maksym.

> 
> If the design intent was to intentionally keep `current_value`
> internal and not expose it via sysfs, then the documentation is
> incorrect. Let me know if that's the case, and I will send a v2
> that drops the code changes and only fixes the documentation.

Yes, the documentation is incorrect.  It was written in the way due to
following history.  The DAMOS quota auto-tuning feature was initially developed
with oly 'user_input' target metric type.  In the case, 'current_value' is set
by users.  Hence reading the file was returning the last user-input value.
That is, as the documentation is also saying, it is returning the 'parameter'
(user input) value.  It is not designed for exposing the internal state.

Later we extended the feature to let DAMOS self-fetch the current value.  The
fact that the ``current_value`` is for reading and writing the parameter (user
input) value, and therefore reading it doesn't return the internal set value,
should be further clarified, but I forgot doing that.

So, yes, if the current behavior is not making problem, let's update the
documentation.  I'll wait for your v2 :)

> 
> (Apologies for missing the cover letter where this should have
> been explained, this is my first patch submission).

No worries, we continuously mistake and learn from each other in the
DAMON/mm/linux community!  Welcome to the community, and I'm looking forward to
your v2!


Thanks,
SJ

[...]

