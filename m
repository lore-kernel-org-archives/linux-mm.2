Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88633FEE4ED
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 16:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822616B0088; Sat, 28 Feb 2026 11:23:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0A36B0089; Sat, 28 Feb 2026 11:23:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC526B008A; Sat, 28 Feb 2026 11:23:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5995F6B0088
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 11:23:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 072FA1601B5
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:23:17 +0000 (UTC)
X-FDA: 84494385234.09.F8EAF06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD03E4000B
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:23:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7VuuA3T;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772295793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKkBLwRCqOHpdFL47VByK0kbXqzf3NFySCZ30KaOck4=;
	b=FUQ5iXJ1AFOIDAi8h3+2KJJux2a8zcAfAzF0EoJJIyOsMH8MfZZhSGPuTXdjHaRMHiqH0t
	aPo9mFuNBfPg1vEV6lZDs8x0soSNowR09cTovd8/P4ZB8ie9SKQpvh1Xv1EsPCb/EOjDu0
	tCw1cZnl8ZPyOZ8YZAQPVhl2q6N1+E4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772295793; a=rsa-sha256;
	cv=none;
	b=e+0mwpQSAepsz/htTqPq9qyZqKuDOCNePRWULu3zsqkHh+LlT8Hqr1+kSQhmLtwQFMz1jj
	E68/KGaIXBE/NcS9bjNygD0//5CcJ7JxZFMTi3sLULqncIMcMtY+4rMaNNlTxwq+rVhAXo
	6kvrl480To7tr6Ll8mtw7UjhE59a9Uo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7VuuA3T;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C9216001D;
	Sat, 28 Feb 2026 16:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6F2C116D0;
	Sat, 28 Feb 2026 16:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772295792;
	bh=tDPe/nfeuLBd4fs1xZJUaluoGXlO/lbkdH6pyIPqL9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7VuuA3TXUQaqxvibVoBrjp222kjf9cHY1OT0LQPbIAK8IPIL8yEVzJVK54yIYJtE
	 Xk88erL+AsJdeWRBcO3BP3hpf0H/35Tv2/B3rJ33u2IlIXX8r2cLg/eHd/dJKc2K2v
	 RfrGZmuK1fm/LS6K7Vw3k1t6qfYJrmJ3n9jjjadv+5j/42W7+HnYOUFYz5xMdOz0qm
	 sFofpyyGK557/M0WW1SYF5iYRAREbxuaZjIHDnWpkg6WJfoYP2t9kX4bHH1RiSdD7m
	 e6WqMPWMiM+pQvL9FW7MLUh+WAb21vpQshcxFkteXPF1Rl/w4UypNAdW/ska6HjG5Y
	 sruRnfYQYsHiw==
From: SeongJae Park <sj@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	"linux-cxl@vger.kernel.orgkernel-team"@meta.com
Subject: Re: [PATCH v4 1/5] mm: introduce zone lock wrappers
Date: Sat, 28 Feb 2026 08:23:08 -0800
Message-ID: <20260228162309.213482-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <849dee9c47df1e6fba97c9933af0d5a08b8e15d3.1772206930.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD03E4000B
X-Stat-Signature: x35nawtcfeffg7johssipw7aqmy1rum8
X-HE-Tag: 1772295793-284034
X-HE-Meta: U2FsdGVkX19HRXgSn7eTuo7amZmtFp3VoKiRRGfHMrBxUed1WQ7daX8KetBM7dLpodp/IRruKBNxHtdFNyNqAZmpKGvrZBsVxmelcmHbg1lGvnrPeB//atlRhLr3By37gVuhpngxacGX0v6osR/voXzWwUXUa6pGgfPhXbPlpwvC+0PXWYtHN0Sm5MYU2jB11lZmDtRqmNF7y/780EUSIhI/RRy95WYmMX19hRVEAfMNe1FwZoV1db2+W51k5ZoueI9azen4nOrbDaRGhKY7cds10YMNKSLDoaQvPi7Om0hF1jXVcZNPcbw6mO0DN5LxlO+hzOhMQ28gH7pW1VCeLPwZk58fLhsTzK6b9V5aoK3PO2otyyEMFZ5Ofj9sS5I6bgvJsGG/C0QZI2rGnlsKVj+sI8sg1f42Kkr91aoOK+gYCGgQh/iAa7nEt1aEQmrns9uCKfyF22E6XEF2KgnnC31lcMNrWsloh7wSMa0oNBNHG3ZsnyvMC/msgoD1VJuGUWHID+6ZxYJvfRoQyOM5yz0gdqxrRbbEqtc4BylywqEpqzIxRt+m3LYWaXA6LwadmH9rGPbCjEXWp0ON6EeGyRY2wfhBt818K7hZL2MOjWFfJiOxUwrAB4RAlg9ePcil7k+HAXEUAIesfh8Q7MS19hKg9txsEOAZVgaStFq7/TfJGwM7jyvrR8VvV7xSJirI8i0eTzTYNfOkkXOkpEyIeTVdFVMnFCCj1x6h5Ko3hk0H0fnyzbLjpoMjcCm9HUjPnC+2/WlMP4Ik9qlcge54C5R+SsEXkilhRLdr3ILl3lgnZcGuHd2ZAb0LTFPQuDEO+mMcVi7nmhR8QZfNy5WuxZz7RuNv2MpKq3Lf0HjQNlDtTouv7GB3P2Cqdt+0sbTveHKJBqIN3CCgf71s/LxJCWJBiYiNn1fN4+m690khLZXuJZ1+6jHzns5YmLqfFsaJM5JMGC4jBR7dWepxmOG
 dSUMH7Jo
 /uVcCH7ca9l/SM58p2cEwyBSPlPtDUhVaPEd/yVmPPAjCWAceaGjjUp9nmXdSGaH8byrRVFixLtl7VH+qikfbw5sQBHfVRyAVSrMyKxaU16MFsVQO+pvMJliUhAMYje9MkVTpZZbuKv7sl6mlg2kHprEe1XahE3o2/qPCQxAtFSIm8uA46eNELaUKtFN+WnG1FT/NqlR4Tg2gh8txX21aszopX1/vU7ldVQVEXV6xQJAUY9IaD2/zEf3AXjKp7PY2MissG1HSsUe8i/9u0fOV3PQriuld5ab9NSY6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 16:00:23 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Add thin wrappers around zone lock acquire/release operations. This
> prepares the code for future tracepoint instrumentation without
> modifying individual call sites.
> 
> Centralizing zone lock operations behind wrappers allows future
> instrumentation or debugging hooks to be added without touching
> all users.
> 
> No functional change intended. The wrappers are introduced in
> preparation for subsequent patches and are not yet used.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

