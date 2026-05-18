Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E16E8CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27D086B00D5; Mon, 18 May 2026 19:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253CC6B00D8; Mon, 18 May 2026 19:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191856B00DA; Mon, 18 May 2026 19:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F228A6B00D5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:53:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A61881618CA
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:53:46 +0000 (UTC)
X-FDA: 84782195652.30.B69F70B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 06F9E40007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:53:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BtC4UE8f;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779148425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAETP0vJ7e0DbR9cTy9CDAioK8oKMxGMJ3qGCMxOn2c=;
	b=eqbiWoEv13W3mTtM1XGvjbiNV5/xr3cy8o+leY60zgsXtTTR4Z17gzztD+d0YAdXsxRx82
	jHRhITLPNXoNa7tYOsHV7UjiTmlbOt5LiRprnQIxK5M/QrQGrmr5hcv0dYp6w4pSCZIq55
	R8awuZ6rXGYenrfuCWqViIiEhQ8hUxk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BtC4UE8f;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779148425; a=rsa-sha256;
	cv=none;
	b=oo+uub++6+eTeVSbt07LWu4wMsnG8LUrNOIfEqI8IIp6fU/3cfe3bxfOuvoIiQrLbJY927
	gj39oXvUs0U2tXIlDzkqPUbE8BvRF49LAhO4DUCmeC2GcKL2e3iAmxMlOuxgqcqT3MzGJC
	SV6neCAk80zOLdxu/Z9BwENjsQDFATU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72856600CB;
	Mon, 18 May 2026 23:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69000C2BCB7;
	Mon, 18 May 2026 23:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779148424;
	bh=CCybTItl2l5Gf43MmCAPz8mcPgmYEVNMNLsLUpJUbN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtC4UE8f9YImDELdTsR30s9qV7Sfy4huKZAEnlT6YqC/XF3AEhhTAyUsPwtmB1gEp
	 5V3/u/FryBPMIgLDc3+KiBYI//28T90ZNylyhhL+dCm967kY+L9Lt4sVVXjtlfT/H6
	 OGa8/dTsHX2DOOGqd9VYAe78UBi/gNm5TcWKDpwA2F3ey8PE8IHmt6OM7ULx93g/tP
	 icavgCFw35jPGHgsURhE8Eytx0+35+qAEZhJReQLirfR9U5dqKSjYHgcE5abXh4T5R
	 DSagiQST1o/j8A7b2V6Mr8HQy4WSBtSlWhqKKpc5NvRwuJxCOik7bZiny3OMranSvz
	 wEgoRBGgIw/9g==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 00/28] mm/damon: introduce data attributes monitoring
Date: Mon, 18 May 2026 16:53:34 -0700
Message-ID: <20260518235335.98776-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hkfxsu95wxpa6predt5knh95skzjm5bp
X-Rspamd-Queue-Id: 06F9E40007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779148424-622794
X-HE-Meta: U2FsdGVkX18vqyVd1BgLbbWTbSl4OgJhLH/AMNDOzLpWZrZIEjVM13zOd7fXAUCB25tk5Wv95pPk5pGb87ErDxachhcumvWt+tBRTHDchwwD+4QzHr5jcPqp0BPV3bMtq3zEIXS4ZI8e7QvEW2osMM7XjlZI6Tb6KpNjWvQ5brS7zR6VRGwk+Nm0kwNNy/d7QBw1c/53DoijV5rb2VOGRe7iiizJYvCUX3y5wpyAXFzvAuFcA92J4KF+W5i6wAFHOMZ5CjvTYx3viPmI8ghjKCsqCJsh2qVLZ7YUOHzz2YMpoPbme/8kzBuy57crrVD/cmUD3/7lhAJgyiXQF0sxsOFn3KCyIxUyRC4NfsEtjlyKLVRwravnu9y3XQuw4vboKSArFTxBH7ikLQGE8kS271vrgjVhvMPXJv6pZmz4Z8XZvL6zcgcJtlKwSsH9pIVS1kmvbHZTqfxJig98kVVL/0iWItl886NwHswAVWwHrvDowuFxNy4+6vwZ/XeatQcuKkKVkMCHJWMoWEGutC7WCNGCkQx2aIYguONfYlveiWMoAwW0N/619+kiEm+sBuoMZ1rHn+WsW2Ya6aUD20/Fs+TOOq4TKDli80Yw+S63NBuKpO90Op84rlVwixdohMPEAoigtCGioS9rSNyHNJG9utQiXCasHbLk/3tQ2UhFFiTQvuHY2ZvIgj/GOQ6Mc5evF0GpGlKrmMcAsRtKWO6ajCwzKS1fcuTUSWBB09qA9SUUYjM1KdIp6bTSl2ilJhxuH3xtqXp7mj/SrjHXf/1r2DiPAN0bB6WiV+nkGZ/JOSPSN6z+J1um7f3IEWONz4+bcvIAA3cAhny0C21WGe7yiLIYlJ7WeyoUX2oVNuKTTPGolUbUzu0qYmWinqd98q4u8RCn2wddYmVsk7cTOYlLoQrRYNkMwUp/Q6aIONvoVJLt0whZtJEwJeAlBQgz+eraxQKlCg1QkAiEwIRmM7Y
 qzVg61Cw
 LQpDVDlJC1kYyODlcWMOAiNDgaeGdAE350nev8TvKvfCfgC32fRQ41lGRIjMIxsUjtMPL+ltqwY2NDOcovY3GxFM7IjKSqUUKRHScSFdpAVG3EZ3Fel3d1y+lYaubJqHCnkqxrJU1H3zmlCpsDHJfm15vwg+s2BJFR9nS6l43PBcjKfmya7n3j3xsoE6V6lQA4FCxbxWhZbdO2g/sRl3UFPWVs9/HCWJbW55QWwaaB7Xz8+S4QOF6G/AIfjCbtFmTek5BapIpW78d7uHYPxhPWqps7vFSyQVR7daE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 16:40:48 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR
> ======
> 
> Extend DAMON for monitoring general data attributes other than accesses.
> The short term motivation is lightweight page type (e.g., belonging
> cgroup) aware monitoring.  In long term, this will help extending DAMON
> for multiple access events capture primitives (e.g., page faults and
> PMU) and eventually pivotting DAMON to a "Data Attributes Monitoring and
> Operations eNgine" in long term.
[...]
> Changes from RFC v3
> - rfc v3: https://lore.kernel.org/20260516183712.81393-1-sj@kernel.org
> - Wordsmithing documentation.
> - Drop RFC tag.
> - Rebase to mm-new.

Sashiko failed [1] to reivew this series because it is still having an old
version of mm-new, while this series is based on mm-new.  Same issues were
found in RFC versions, so I was making those to based on mm-stable, and got
Sashiko reviews.  On the last version (RFC v3), I confirmed [2] Sashiko find no
more blocker.  So I believe this is good to go for more testing in mm-new.  I
will of course happy to get different inputs.

[1] https://sashiko.dev/#/patchset/20260518234119.97569-1-sj%40kernel.org
[2] https://lore.kernel.org/20260516220317.4300-1-sj@kernel.org


Thanks,
SJ

[...]

