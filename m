Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECF2C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 05:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CCD16B00A0; Thu,  7 Aug 2025 01:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D446B00A3; Thu,  7 Aug 2025 01:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C096B00A6; Thu,  7 Aug 2025 01:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 335C96B00A0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:51:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32ADA8148E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:51:45 +0000 (UTC)
X-FDA: 83748889770.17.D648CE6
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 90F7BC000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:51:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FbhF+fvA;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754545903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MW9bmlzW/HmeZyFCzdcpmQ8WSKB9wwE5pHnepk2ZDG4=;
	b=xkhNsbAQW3ESAFQEN+uS+X4VL/BJe+yQ+UV4LNsTr5OCGIAH4FzcmVA6pRqdBEIWKb7WQK
	Gn1706WQKPE2LCr18LcJfxgbBjs6M4hb17etHw/h8c495qXb2B3YFqzBcPLK4rr5it/dJP
	x2na1b3zICSiHUdVGG8qR4GdNmxCqug=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FbhF+fvA;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754545903; a=rsa-sha256;
	cv=none;
	b=n6mZtz9yZhvR1V9cnaDrnho2Gm09nJtl2IwjvJBD+AqKbNOA3zBFpEn6cljWmIcmi8C9ub
	Vtro7qAy8qMczfYSExcqjfqY4V5hRF9YEv9ZFNSqTwDwBAcUJGvL7SZreLtgFyJ1eel9wN
	oErC6D2vu5m7qEfLcm053AdRHuF0LVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 878FA5C5A9A;
	Thu,  7 Aug 2025 05:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E02C4CEEB;
	Thu,  7 Aug 2025 05:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754545902;
	bh=hMMwBhKuihGVBsVlEMKrLDQOO44hxXlUQROdSYwgsKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbhF+fvAHgyVj6TbgfmBW3/8HS/yRCdaih3hPIrJKLkMYtt27qE68ULEc5ukJV2AW
	 Wr1mgYVwX7OSCK2qx5VMEeNwiilo/K6Vt0hRah59um4NddfrKPd2L4rnrCf9c4imJS
	 R3nVxfcJWKapsx0kYOK9yfaFFvAKxqCJ79kSHz7BX60R3oyuzJ0ERBqBz6SCbMLVXs
	 0tAarkBZWtnGMFqoqGQBh5QjEuwK7divY3OJr4tJajJpIqm1UU4I4wXzOQYUnzk6Zs
	 vxN1yO7X6pZMkwyhF9H6OGql7WvwKyNHPErXFcZ4RYZyhPzKGHfVkVwL7UJu88qkeO
	 eSsLUuwm3aq9Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	kernel test robot <lkp@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [sj:mm-new 42/45] ERROR: modpost: __ex_table+0x1584 references non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
Date: Wed,  6 Aug 2025 22:51:38 -0700
Message-Id: <20250807055138.21727-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807054349.21561-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gaimd3gsjt7md4m4gfmdgu8bfe498ak7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 90F7BC000A
X-Rspam-User: 
X-HE-Tag: 1754545903-608852
X-HE-Meta: U2FsdGVkX1+KsfFOT0/qiPfC4d9RpWzsvYau0I408NEgPi2L/TT4MHsvIPMfU7W0PGV7LCuclmqIxaoMtbUT9IPDjDhgY9AkZMep4OKlxoy5T/Sd1iMXQZAkcIgBa3xn+tAqPEnMohP1l5GtyzmOtDpbLPb0b0c0Aw58A6cp4CzU5rw8f8ne3DFV9WnMNRHZRLfV1SlUuWDfC+sMznyskqNdtfdVoYfRhlGqd7uG9oqoHTuNC7QiEK0kWl2FAGRs+wcr8HbY5MpdtDbAVihfmyNY19bOjeG8dzTcj15qk+/Kjqkfe84Gr2gyOU6Vm293+zhxR0AJegwMrCyZPMhpA5jTOZs6uCqUZu7thMkMnB8Th4mqwsLnqu7zkE0F1H6QZXCO4REPRbM3uv+ywKWzqhAiGqF4k7Wnw2+NCruOgVHqDrgDoYT15s0H6ceuAeNS48zPLBjBcbT38PuMOnELbXwQfve+K+CMOAj2venfctStGy3o37Ae4NGTxX664ZgGHzVkCaHmIJCh/yICSM2wtcWCCYx34xV5u2L419ugtRcIsp69hsu2KHPBdaPUFcKTAZ2TrpsWrdYwsMlysB/NaD1sQ+QQsIW5RTHCbqSoo6PRpMOtzSxqM8AAQM7eAilaENtZchCkXkIyw1Gby6bjtFOb4mAZwrhFJict1d1iwbFnnnliYYIc3eDi3zWWSNEGX4f45bUAN5V2OnhOEhnh2iDiRxl+sgKIEO0UysJDS32k13GxfKzdhoVbQyGCHgLBzK8DfS7QNVIYVxqNySzBY8yWfPoE1cb7+DrRPWpAzrbaZvQiEOHsjWHDkF0Q6vfi3Z6Z+8mOApO0UopYdmMS4c1hIWOiYT4/SVnJoEXaYVQ6ueBM/pZYOr4g2ju9pkorHPBqUOvyXaQS81jV5aASaqFEGhVZt9FqKuu7iC4G0X9gwCHNUMw/fnH74w263rNbzYc8rmlBKL6wMpMLvHo
 SZsv/Zp6
 lFEutfXNElAW06IUWpbqZ5u/7jt54B6cZ8GdK7X/9wVO4G9x441TxFNI4kuj6m9JdlpwX2AdwfzTwSRjS4G9Q3JQpfokxgXfD/REHkEftL+vPlPpu2VlQpGC7T0GcAfOKCmDQs0z0XcfoWHhkdXGdvtYxPfZsIBVzriku/k+y95KqYYP+IQo9qx6My2yb7gXhfuSOLpR4elTHXlDh7KadKFBgp497wN6dZKDWJIRrxNgPrspZgDAfWmp4QL2oEZ8pBHshZ94dSLObst/32KEIqwkdm/4vO1jpL/Q15YNQxWkEhjs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 Aug 2025 22:43:49 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 7 Aug 2025 06:31:25 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> 
> > +cc SJ, as his tree :)
> 
> Thank you, Lorenzo!
> 
> > 
> > On Thu, Aug 07, 2025 at 12:03:03PM +0800, kernel test robot wrote:
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
> > 
> > Not sure why SJ isn't cc'd when it's his tree?
> > 
> > Not sure how easy it would be for the scripts to figure this out.
> 
> As people might already realized, it is Andrew's mm-new branch.  I started
> pushing Andrew's mm-{new,unstable,stable} branches to my tree for backup
> purpose, since DAMON development branch (damon/next) is using mm-new as its
> baseline.  Seems it caused confusion to kernel test robot and other people.
> Sorry about that.
> 
> kernel test robot, is there a way to mark mm-{new,unstable,stable} branches on
> my tree be ignored from your tests?  If there is no good way, I can remove the
> branches from my tree.

To stop more confusion first rather than waiting for the answer, I just deleted
the mm-{new,unstable,stable} branches from my tree.  I don't really depend on
those branches on my tree since I can keep fetching Andrew's tree or using my
trees outside of kernel.org.  So this is no problem for me.

kernel test robot, please let me know if there is a way to mark specific
branches on my tree be ignored from your tests, though, if you get a time and
have an idea.


Thanks,
SJ

[...]

