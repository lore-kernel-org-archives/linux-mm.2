Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B747F532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1A7C6B0088; Mon, 23 Mar 2026 20:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB8F6B0089; Mon, 23 Mar 2026 20:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0E26B0093; Mon, 23 Mar 2026 20:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA8CD6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:25:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C0A45D3D0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:25:50 +0000 (UTC)
X-FDA: 84579063660.08.7FA69B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A19251C0011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:25:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mD3ueE6m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774311948; a=rsa-sha256;
	cv=none;
	b=alhmoMDIrxgHFmf3l7JoKnOBOudNgEQvMdb9wo9QQCMKWA09OfYx6dnsvVXwETX2RRA7oO
	d7qZxg/m5oBIn33Lj+4vqQnkyXMewRFlBWLlc0P2YkNsUvI6/dz5abPaoHBf4ClblZM6vI
	kkuWisawYLsx3rXwzDaTyxGMK5GY3hY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mD3ueE6m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774311948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvMq3jbweM1iXpSvI+gz2qsXqhtK3EMaVhH8oQ6Y6Wc=;
	b=Ii7QnDyXjgD3RGLSM5x/vxwMQyYu72GGkTdzqvpnx0pss6HxiW573ya8sFonw5QSD8eWG/
	NfKco/kbCTql3kqXxR92ax57t5ReDlw8vQ2Lf4wzrGbaYVqu36qDyMjhjgJct/YM9K1MvM
	7Dz5wIzhtx7Wlhj8A7NF8F8soB3m9Os=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A582404E6;
	Tue, 24 Mar 2026 00:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9B1C4CEF7;
	Tue, 24 Mar 2026 00:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774311947;
	bh=K7+w1Fe9eVXYmmVzI1WINbAfUoX6r6BuzBux9UJ7NPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mD3ueE6mb1Bx2mCTdm6xu/sxfD3MhzSfGAhGevRfyBy5nSd/p7utIBitWgQiSitpJ
	 7Bqv9dXQjZYmLQzpShhTba0qFCUvYUiCmGwSbJo3JrfPrb0DTziobc2z482XQ/ka8X
	 jC4w9Han9+xoL1f/aq/skh4N1O64wlLm090GOvWeFIxh20hPHEQbA2fUTsCZPe8ILU
	 UcvJZ7dhc7JVJdLKImfVFqbPuH0I8vrwBpCvv0lJFCTUCTVPMnWIwBABiw1qxnccR5
	 FEmo1TMDmans/VWwQiAUYXchVAniYNKyIuGeUFE0NToPHe55fgNpuxd4r41hzQvSA8
	 nxTJ75J2aHVlg==
From: SeongJae Park <sj@kernel.org>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: SeongJae Park <sj@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 18/19] mm: damon: Use trace_call__##name() at guarded tracepoint call sites
Date: Mon, 23 Mar 2026 17:25:45 -0700
Message-ID: <20260324002545.86416-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323160052.17528-19-vineeth@bitbyteword.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A19251C0011
X-Stat-Signature: e1joc7jm1wqsn4jwn74t9jggoqoqqxzn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774311948-374423
X-HE-Meta: U2FsdGVkX1+NfvrfpFjdYY16BkR6ikbvva5X9Y0EAHZQzmhvgH+70dNEHaPJyE2BTqTmJWh8+cqwjlY3wmYBkZgaXOudRG7JEpOn107QE4dIqVWBy1CDub9FQmhitZs4CvEyqlUoCZorDsXuF4JZ5c4e1zs4g8ABHWlNDrYt5UKSFU9K+2Z4PwFI+VWUv5CTB2AwNB4u3cAHK2/f7wk6Uz1aB05SK7p6tCQ92YbieeKTlzsa6G8u0V/t6vKSiYU9GwWzLHMXLX0Hx1Eizj+/yBY0MwnHot9/r5Jtp0ATX4ZJutQZg08FkrfgFbhfkyiKy+VFvrQm5KcOOnv7r5dXVhOTd5o15MIveuMaMEGk3r4PmKx/g4cAXvVJr3uFm59vDZp/+0JRGQt2MZ6yhiDQ5WihPODalSgJykZPA2K3Q2s3Yl+nzMfnFRccOQNuR6X/cILZGZbUJH564QIbo4bkwYzE/1qJvXgyBQkG4w+GUvaZFzo/FsENnINaF+iHIMLDrodakNjD3/cHxiqikH/ugJQ4PPbdRh9C5jFC0zBrH7MMVdm3oEgor6SbAb5j06eOAWRoLaOnUyqCbKn4k5vc7X8uTZopPkEyfKwMnenGZOWvgCcMAzq0NmoQXfexpreX5wV49UunxN3YGQgO9CJndlvrPLjTFnJlBtv7lP+00+/9GfCN6q9+kFWsn8JzjnyTpC9gWMcnqTp10/LpxmcO575NidjnsiB10UNxf1BEl1UF3Cqi1lw+R/+AyiW17ZQjhyHrh8t3G9urultMCk/ljond2qvp4JUcPyWtfiBieM7IZIPFaRIvBckTc5Nudu9iEC4BA+KGtZIkF2U14DzV4jE3XhPNT7dR3DlOyiMjn2XPAVZab1v2Hr6Qja5ZjUDq5rX/6nIH2COEuLgeza+L/9grCMrkpjg5rqCILzfL7j6sKhn/WAU8TWotNkzejxr0axzAUlqWEsxCUJCptDf
 Pl9fJTP7
 LM4aGS6cZXE5Hws943mKWUCMvyctjIxdlkNmjF0JVx11CucXYcpcnEC51iA6yavD0w325R43JnXxQ6RmhhESam9RBa93HHfZcTXslvxvyeISTnQba/TqB86ZmKRap945ABxy8Owu7qaPQ4iR5zqNoBJZ/b5DhinRfhxw8/zE4tNDfPbpJZbCPLJ0IvoI7XxaIbHzZqX2QJ0cKQ0l5XEuMawdOj+emx3Cckzlj4/Fna6fGEwZ1RXmeHWE6bCrwwnX4K01BBT9IbKdWOiBOwq2GhArIQxwRrMu1I0KB35PeO3E4T8xEgsf+r47RpJdIMspy3oQgrJkAOPyVgzYyGZqnk7EqGE/DpaNTS6+V1AxFVzuubOAKmldOypEIf349UEsMUzeUS4kQUmDPAgMYyWUPyejlIM5uVt9bsm5CAALpvkTmkfKfW6XrYwGIyZUaHMltfhNVYms8O7U6N4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 12:00:37 -0400 "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:

> Replace trace_damos_stat_after_apply_interval() with
> trace_call__damos_stat_after_apply_interval() at a site already guarded
> by an early return when !trace_damos_stat_after_apply_interval_enabled(),
> avoiding a redundant static_branch_unlikely() re-evaluation inside the
> tracepoint.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

