Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F28D610F2867
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 20:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C5B6B008C; Fri, 27 Mar 2026 16:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254966B0095; Fri, 27 Mar 2026 16:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8616B0096; Fri, 27 Mar 2026 16:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D37E6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:11:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F4A3141000
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:11:24 +0000 (UTC)
X-FDA: 84592937688.17.12465D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E4D6640019
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:11:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GspqzoKu;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774642283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzM/PBxBgcAVmSeqwFfUZe15z355SaupWu7EvT+gkEU=;
	b=INaGkf8tphBpHn/9wwB1p0e7RciDFOGPn6XxHqjRmJ5oEb3j/zrvm+DiPkvO2So2TrQJzW
	gLKu96oqGGSYtKxSux05rMRB/YShHyP+/6cbYcZPOK9OXpC1mtBGWK7FT0ESuPgGtjRa3a
	IgskRBiuA8qIlPI8YpOeESj+7Mogq1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774642283; a=rsa-sha256;
	cv=none;
	b=KgmdyE8BTLX7ZTDIfqyAa3pTBGUxU08YDew3uCpbGGf6JhmfCsEaypox2CHdR82KGspeiC
	ZukmurDgi4FUrV4CHBILb1WHGCw4uZmcd9MpzPVxbKAHhGZRcCdX63Uc8fC633+xJOofLa
	7Eeoe1njSWMSAa/V07zSeoc3vt0pQB0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GspqzoKu;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E481A4369D;
	Fri, 27 Mar 2026 20:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76909C2BC86;
	Fri, 27 Mar 2026 20:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774642281;
	bh=iGx4rhYd3WWPfBU6xjCFHmzcIe3LMIV0C3cCEAqcfYU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GspqzoKucGuEQUYDqA6ZJlUQr5mJXQNpLdCykmAI7hWXnw+B+zbr4sAW/Srdg8+Up
	 2yetTm2BGgdJAjRMYBB7WlMsfpCBOhiW1glF4LhRSR7Mel4O/7+xoFtYpO2CLtc93B
	 TTUCzMH2DDg/2etYoker17UXZ9QADibor1Za+4SU=
Date: Fri, 27 Mar 2026 13:11:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 0/8] mm: use spinlock guards for zone lock
Message-Id: <20260327131120.591770a2aa63abbaa7bbeadc@linux-foundation.org>
In-Reply-To: <cover.1774627568.git.d@ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: jrfqar5juw9g7c7irm1m6a1cfbwi3fiy
X-Rspamd-Queue-Id: E4D6640019
X-Rspam-User: 
X-HE-Tag: 1774642282-236274
X-HE-Meta: U2FsdGVkX18Scs9ZZeCreDFFffotiIP+n2HFeuAAuMMcJ3ki9rgYjxWQUCNx62F3sSJjhNPzM07DTAL88kctgYjawkcdFylgDV9160gErNllpLUzJuzqmDMz7tAiCtIxtJ1/zW4qYJJ2zFBq1jvk8P5vElvIhlLkRjRzYNF1wVbxyRSFk6s4RhHy46AsRfxRpop112gxkOwQMylW8ClNUjuyPcq/fyLqLpMOUXraubAeyww2BpDXjU7JaClUangeYCdcGTAzqpBuTTb3z6puQo79opMit4JBVKHvmnAqdYXu7JyUspe6D6RP7qy/a9/arFQNb8mvprdFO29AR+Muds4xdf8RIB/h1wh2o4Zwf3W8e2rnAAPZg149FjXVwvMiquupj/ZMQ8ouZabMdhgEQjQKLNRFq1AcwJ/Ex4zjI6E6GjUDFFTqHGh7cp5+25EGGqh7RCfCQKAgBhFFj00i+0orf6LDmpoDcLa+nYS0SFltthNWZ9viz3YwZ8G97SYDw5vyYy2myErgrOrTUbJyqZiRvuMgkPATe5yQpiE3oyhOmquCoiwo2QEH16/FWrcS4VxQP4TQqsvgXUzp+1ivCsA+pzz1mfVsAzcjmxk8/MSbNThU1G9S36poyHUqrpgbtCc9pK2ODjnn/TKpUXmEdcYLuzpKv3tt/JvsS+l3I9tDmye+P5tTKvbqw2SCl3BEcv2Au3pOS2uIxLW9yeSuf6gQGGcLxDSOKrxXUk13oxlYN06s970s6WO+iMBGIkoyk1rJv29zd1FjrFvpheFSvbt/QV+LfnGBJz8W/LNvUXlAO9TKFRHF8sG6SwifdmlXA/2yQytBsbjOUzcjQb863oU5d7hB2zJd4NrcP5rpaClxar1fW/6Xspft5sBs99eYW65zN7JQvRfhb/A1tNIs5WhzwChvqlneSKK2vWE9N+pKsBpmwlV4KiBvbwDnZWow8Eal4JqU6GYihark+KL
 TJ3eNmeJ
 cQVIgB89BToHjXNTp/QzyswFEKbsdUbnm0XISuttWAh8K2DIVKHsEDcPWkSyACnlQ2Tq5nAHHXGxLDE/aGXIaC8xsmZoLNemrIZwF9D3+nZ7y51D8vq4/KeQN64RqvkKloh8k3gehh3omCXI62uW8J8ljpchSHB4LzwOFshHCCZK5sp4aOm1nNVmKvLg3MOXcGbThu8N6r5QL1cGEZrHw+UuSEAQQRh2eNILyuALG74OzorWJFI+ZOpRiqpPUatcQqq+aiLN6AAlPKZCvN5vP6kdeKL2yL0peA7+LBd4EnZSNKeLnZWm7P12x9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 16:14:40 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> This series uses spinlock guard for zone lock across several mm
> functions to replace explicit lock/unlock patterns with automatic
> scope-based cleanup.
> 
> This simplifies the control flow by removing 'flags' variables, goto
> labels, and redundant unlock calls.
> 
> Patches are ordered by decreasing value. The first six patches simplify
> the control flow by removing gotos, multiple unlock paths, or 'ret'
> variables. The last two are simpler lock/unlock pair conversions that
> only remove 'flags' and can be dropped if considered unnecessary churn.

Thanks, you've been busy.

I'm not wanting to move new, non-fix, non-speedup things into mm.git
until after -rc1 so there's your target.  But now is a good time to be
sending out material for people to look at.  Let's not have a gigantic
flood of new stuff the day after -rc1!

I think progress here is totally dependent on whether those who
regularly work on this code want guard() in there.  A
preference/familiarity/style choice, mainly.  At present the adoption
of guard() in mm/*.c is very small.


