Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4536CCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CCE16B0098; Fri,  2 Oct 2026 14:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CD26B0099; Fri,  2 Oct 2026 14:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B99F6B009B; Fri,  2 Oct 2026 14:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2D026B0098
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:56:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C441A76E9
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:56:04 +0000 (UTC)
X-FDA: 85278591048.21.D3AF408
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D4F0B180002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:56:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=naBtS+AI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790967362;
	b=C4q0Iwtd0rl0cjxVCkRzD2a6GIpUy11dilVGNLeFa8xQgAlk7F1zK4OF6L6qxrcx8Uaw6a
	LnEYEY2NS34WbCKPU4tUbGEJE1l91lfBcPz7m/0gOey5233Uw5OsBZkRHqvByOqi7jVI6u
	vuavUarq8LIbnJyuJNBvLGgmGLtYW1Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=naBtS+AI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790967362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+fy1k/FTgNKjVO3WlIWR90qWFOxGe1fwcU4uHmJ++s=;
	b=eatit2PUvqCKV9ntR6SxjE6dF+QkrXAz1+iyKsg2AvbvaNPXWEwn1oQNlX2yMMPYDkayC7
	W60XZOdn/ar9x+V75BS7AuDqtb5L0HrVYOrnaJjLCEHYsPuwJJrGVMFBcTpDSJ4KPoMSX/
	7rokccP9Zj8HQQGajD8Q1gxBOKCraTc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52D7C60AB0;
	Fri,  2 Oct 2026 18:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EBC1F000FF;
	Fri,  2 Oct 2026 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967362;
	bh=0+fy1k/FTgNKjVO3WlIWR90qWFOxGe1fwcU4uHmJ++s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=naBtS+AIPsfSrE5BcNQ1Zi33yx+/tTwg0tt/VobHkuWWljZUi3mor2m8UIgDUaVFs
	 g1XOCyT31LALkpGFvi+VLey0ibZUmrwQ51rGq2S+b0CsAwheQy2ZqwvTwWiykgJlxh
	 n5JBWbtnSYTDHBc9hUD0KEONNXlvdcpuObp3B6kkYgYnQaRopftTuAUoJeTsa8Noiu
	 jAn1mBhMX/c8j7+o4PX8ed9yb+D249oDuAjS/E2yHHlHA5HwwyPMgtqOXNKcQgeMyV
	 Xq0f4dDVIOVm84BOYF3exj+hKCrLyLWYlzQO1qPMLJSv9vsr5qABECQI6td28+1Hec
	 7BbLpqerulZvQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: mrelease_test: fix retry limit
Date: Fri,  2 Oct 2026 11:55:55 -0700
Message-ID: <20261002185556.41533-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmFzsssM_BXHUDrV+UuVD5SZMBmSkg3UQnmw9Ns1PV7GCQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: uxbwwc7skigqnis6y8srb3z1jkatwbzg
X-Rspam-User: 
X-Rspamd-Queue-Id: D4F0B180002
X-HE-Tag: 1790967362-680523
X-HE-Meta: U2FsdGVkX1/bN+DsGWzlSD+8yM2csCAcnsAmOGh5vW2rLBRSrsyIj+rdxNecBO8QY7jRNQJaU5n+vc5wQD7bN8421lh+CAJdHcro6iEWvWtYRXLXHMase9D1KBJODSLaxZA88rs53e+YYhJjF5DytdMQdN76owNpj7qCnMeTEPwefkrbvAR2AZF3J6lWX+/qlE71RFk25Y0E+H2vk8tvBZ+1qLKwzQgc6XoojeOm/aeq91HlH2Ka9imGiITzcu+FLxo6iBCSYDRJOdRbcbv9XyiDrOLmkdtedhsiDfTDDiuDuBvOGnTghuycMQXKNuOHtGd1OxbypZWKqzTbiYSKlEQQ9iVSePBgXQsAD2I2awDKlWZxwoANVniOwFLoO92m38mPIyUY5tqgDAxhvAWRN087jVGKpfjsfW18WaU2O06lM4RewukF98jEDAhJbrICNFhGLMWpjVjm80449exd0rmFZAmiTOTwBqRyZh72z7LA3b+c7C6Eyvr5U7d5dkoMmV4pWHLQFktEKZ7QEgWUOBK3pTK+jNmI7k2hYpvJ+kr8rqgJn6WEmmEoMzNeg3VjSO/adoWqY2zRE1yvf6ZHnfEUrwOE7zpETezeZQZotMteAU4w+HftqUK+ARM40lUIWSslHvznO0Yga9cF5+Y5efeDmkTkqlA3lK78cxTEPfqXnBxxyJeygWNoV4jSz3o/Q/xmmzA9TJZ2M0mZAyIFZ6IuxRD3AIuse0acwa4mEdkAIOcc6PB17eRId5lMykT8lWUVn0kI21CiQ7puzYZb9KOJQ5waGhn+6nq1F+B0cqu/h/+CxVopnyYQB6ioU3vS8O/jBGR+vmaCQM/cSF2Vg+05UewdbrS9OA2kB6uVrgmAgB8NTkLNRcVQsZP7j6RWkhU3MwOPDf1/pY3V2ir6vDkZ5U4TDpSYkI6bsIIjJUPQwUQ8JaCuI7AfyWRQP+ENhPeyNvr2PTutvSzTLo2
 Kx1sTJzx
 Hw+mzQVelvnU7R7y0T2OCzPh0E3A+lFnRCm7jblnXvVMLQEYGYn/MqOnGVabOaeH8Beh8cjawee/ht9NNPPqbWxQsgtIhCRCl30mPMH5RsseJTXusJRcX8FHmCffZFDeHMA9QgUOdVvLXFRTxogMDTEHFjGrffmRW3Ox8atrl86VR/QfR9MI81p4co3XH0efOIt5T4r7XBta9ymmHR5psbJaSqtN6ZO9k88RiWkEBO7Rx+IyPZnaHB0KWyWMRalhIErQn6pVpwy5DEN5055o2V/wltjBDymuFTmB7lX6trEv4EG2uIoyxpwtiVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sep 2026 23:00:27 -0700 Aveline Noir <jm5905938@gmail.com> wrote:

> mrelease_test doubles the child allocation when process_mrelease()
> returns ESRCH.
> 
> When size is already MAX_SIZE_MB, the current <= check still allows
> another retry, causing the allocation to grow from 1024 MB to 2048 MB.
> 
> Use < instead of <= so the largest allocation attempted remains
> MAX_SIZE_MB.

Makes sense to me.

> 
> LLM used in discovering bug. Changes were made and reviewed manually.
> 
> Fixes: 33776141b812 ("selftests: vm: add process_mrelease tests")
> Assisted-by: LLM
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

