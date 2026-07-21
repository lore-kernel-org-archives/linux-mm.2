Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC3C3C4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7676B009D; Tue, 21 Jul 2026 19:52:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F496B009E; Tue, 21 Jul 2026 19:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB1C6B009F; Tue, 21 Jul 2026 19:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4973A6B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:52:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC00216020F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:52:04 +0000 (UTC)
X-FDA: 85014434568.30.CDCDD9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 25E30180003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:52:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3Rvm3fV;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784677923;
	b=7uEJXM7Ki+WbRc8UT8V4hAZejx9775Mw7jp/mCJhDF2yPR/SqsGuKeZ3n0uNviRqsece81
	z8ed4J4jsz97rtRLEQhBDoviD540qe2YJLXrb7UGHW8baPwL2KKgzWqz0bd/jg1ouJT4t2
	DcztVufICFZqEq7VesAkQGiktFUcaqg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3Rvm3fV;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784677923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYN8f9351KWFfUArUzuNWsE73Ym72FcZGNNmApexyGU=;
	b=UNPs797aLCOexmmF1/J8bYv+FzAUlnFXvmzOnAYCmn9KLBta9G7JoWPgqdD/zTp/CwLy6H
	mi7y86GvrbCshv8R4jkH10r4jbR8uHx7ekm+YCbTC2CMRHkHgJcelS6RL/CVWJ+OBdoopM
	YFxwpezVvBoffW0yGnF+ZQWI+yygaTw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F1F6404B6;
	Tue, 21 Jul 2026 23:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05321F000E9;
	Tue, 21 Jul 2026 23:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784677922;
	bh=XYN8f9351KWFfUArUzuNWsE73Ym72FcZGNNmApexyGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3Rvm3fVI8htPpnQ/F2ytZ3FU7ZNFrH2CIc4cyuf1q/fdwKwnduQu51H3ysvqAkMB
	 Q1KKixl5zk3jvHhOOV2F4E61EKZFa7oG/PA9706muY7ywY9BupuBgHDD1yNFnDGuaW
	 FGuR+FtkcAgBwN/SbyUjRawr/iiTB7Z4GYOEj7nFW4qSlnboRhZQncqQ6a3T5IRboD
	 TTYEibbrSoD+9YS4NmwdwSDjG3qRdSNdlczR0s9hxVfN02zuSM/QVkW0XjOzwAAQPe
	 Fz/PBD0+DGg/Arz4lLN5rGEfhlhLCW+hIAhRxbFdOa02AJQAHHyJh6v3Y+61aq0MVr
	 tLoHh40zwvoFA==
From: SJ Park <sj@kernel.org>
To: Hari Mishal <harimishal1@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
Date: Tue, 21 Jul 2026 16:51:52 -0700
Message-ID: <20260721235153.149569-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721190404.135937-1-harimishal1@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 25E30180003
X-Stat-Signature: py59c85uugzrwcr4ifi7krpkres5u3hh
X-Rspam-User: 
X-HE-Tag: 1784677922-563445
X-HE-Meta: U2FsdGVkX18Kn7FLFK/FpAKupzPX8f6gqSte32Nc3B7bjf8uCX7+VJ75HfseR9TEziyCZc/zWrvpOSxZtRhIycGAFJAtLhRT8BsQd6tW57f1YnTQJTQE5A+oGOz8CUcP+0lQiWfnKiAraqYRLdzEtEzaOrV8533N7RSX+4IeJ/eHLDJ8N8Ocps/mrEs4oipGLXeOcpNKNM7bDamJb/gsw4Ux7nwQqX3VnTO46104t3up091IrPmIiQ+NOFFRJfznZ1xhY3recGnZOH/AVfr5Ahvtvevy88Z3qxDXqOegAxKc+Fy3ptosRokXdjkAEU1/M3JdgtQ9cA6MNeabCxTb6D+fFGGxgaO2bpbzGyjgm8RZ3N7Hfa6h1MpdJvzecEqALvrKF4Kwb9/VSRI0fmRzfRSrsFcTd/v8fgPUI7uXv+9JTHrm1pIbkTwM82kBWOmwJ1+nflAowAg/Bc/FaRTiow2eesgThActX4XHOHheQqUDN+eCl3Cixil+NstNO0GG+60GNfnuFGsiTZUWmiuubVWIbmi+t89qQhnsFGMyfXu8LyMARrM/uSj1CIX6C98TORTtz8l25CcFhJrsgoaIUejlNsHIcpu6V9/D+NDYfQgivhjJ3CnF7CXIs22b8WPy6ZZicuyliAQjqA3q8NI1e6Uxk8A3r1fbvdA0q5Fw42i0+sr559YbXBtsS30MgJXbU57KYwgXuMOAORxGCwmm9o5Cqwrs5uQHNobBymtVhK3v3iOWwHjTO9+0nvnWp0qGG4wW0/xrnmBp+qVfOV13xD2PI0UkSeBQVp15oW8pHCQMMar60C/ywvBxBCW+CKlk2wGxz2QMF4t+13ccMS8d+8tQzbWmOuVItSkezxPY5lG6R4kr+nj+Wi7KZRtXQHW+labqs5G9XpH9Wu58h8yHcYXfjJ/aSIh/Bb3gg88ABRuo70sJNWoNqYfm+iL32t1uK7ekpCsGvzaTvLph4oz
 jpN3hhjx
 DzM+7AmIYEVp2i7gp8lcNBzrOp9toCUqwd5VCQoLPAEZRcKIsWU12HJUwM7B5e02YIwBJO4gPYxaW/Jya7p8aDdLMcvGP3qUPt8l99PfD0ksjyDksKMO81p0m4RKn9+yQpqm2CaS/fzKZ8asPZfeZgR7WSUxluUj1A9xgWOUkvSDuySamYW8ZG5Aiot4hXcfZ3FVW0nTXV+MhfwQxBRteYM2vY20181J5e4q8s8ZRLl3Rv/3afB1qxo30I0LoNuvT4f+NOR/wIAzKvfO12KlC0chO0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Hari,

On Tue, 21 Jul 2026 21:04:04 +0200 Hari Mishal <harimishal1@gmail.com> wrote:

> The obsolete_target test spawns three sh processes and uses their pids
> as DAMON monitoring targets.  These processes are created without their
> own stdin, so they inherit the test program's stdin, and they are never
> waited on or told to exit.  As a result, they are left running (or
> become zombies) as orphaned children after the test program exits.

Thank you for finding this problem and sharing this great patch!

> 
> Give each sh process its own dedicated stdin pipe instead of inheriting
> the test program's, and after the targets are no longer needed,
> communicate() with each process to close its stdin.  This sends EOF to
> the shell, which makes it exit, and communicate() then reaps the
> process.

Can't we use terminate() or kill() instead of communicate()?


Thanks,
SJ

[...]

