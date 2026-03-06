Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC31F513ED
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 01:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFECA6B0005; Thu,  5 Mar 2026 20:20:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2D36B0089; Thu,  5 Mar 2026 20:20:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8666B008A; Thu,  5 Mar 2026 20:20:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98F126B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:20:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39803139E5C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:20:55 +0000 (UTC)
X-FDA: 84513884070.19.4588054
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 89F1340008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:20:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ToiP5bfC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772760053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lttAcG2Oju2WPN708jOIRgsLnTmUS6wFt27GSE6G/A=;
	b=ptmrgCTXQSm7K0eJ8iCwCl/y3OrbDXLIsHREYcmSNg4Vj2BnpHKYiWhQFVHOZQ8mL8F9jF
	kdnxZyQK8lU8jUSNZGnMWPOts4bCEitXJv9ZUY4A94DIsaJYniNIKrEsTz1LeP47Xd7rcJ
	sH1rS8Tf6kW/MWt1Uxl3nCqbgUVy7Ww=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ToiP5bfC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772760053; a=rsa-sha256;
	cv=none;
	b=DEbmDjiyIj55VttWdL5xhv8Q9v4WygwaCRnW5fYKvPsu9lmCKFsKrQooLVraqXk5+lj0uf
	TSlY5GB4BQ5AM7diZfxE1j8Te+kEDS0z8lZRxJ4u3UZ5l0Y7V+sVoZsyGe1PviRLa5SBt5
	GYIhNBQHlXXdF1h5Wx4YyG1rE06aDII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C72046012B;
	Fri,  6 Mar 2026 01:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F512C116C6;
	Fri,  6 Mar 2026 01:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772760052;
	bh=RQH4aynp6t0XOR5kWhYDbiHP8APh0RZqBBOKCMlxrrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToiP5bfCUdGGuMpJmpHfySDRyKWwiPdbcfLQHICWLS5rdT0fMO962OGuF4rRL7jx8
	 xN9TMqNmykeuvEKix5t8ErpDiqMzXV8CM3+PtkXGniU17OwfQbMmwbPcDqEKBEZ+Ud
	 uzKB4x8jNtMvMrfzHos2KbQjw47nQkDnWFgFEfoM0iTf8Iy8pV0vfwHxnhX6CqrMD2
	 fVqc6bAHXHPJ6jI6qBbKxUJOdURl4lo7s8/E4ty4G6pDYHHLHp9xANAgNodMDvwrZc
	 voTSMzO2A+lZoNClFmI4Og92oweJlaYTevBxfXpQqkewyWLVs0xknPf3UyR8kTqsE8
	 H/65P06zzGCPg==
From: SeongJae Park <sj@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
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
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 4/5] mm: rename zone->lock to zone->_lock
Date: Thu,  5 Mar 2026 17:20:42 -0800
Message-ID: <20260306012043.90694-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aanSnywUXTVPaYUj@shell.ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89F1340008
X-Stat-Signature: fyagchy437xqh5t6p6czawfoqe75c4pp
X-Rspam-User: 
X-HE-Tag: 1772760053-410683
X-HE-Meta: U2FsdGVkX18rh0bdejaqTXo22HCpJQIZ6rT8fJDB7EbIuSkYZvy0P7upbUDppK8EetN0LrIZD63HcLYx59tQgEr6sLz2dWi8GwJu8fwjJIkRIS84jpItj1lw2LjiCO+CT/Ts3wFPs9Dnx3UA3vHSns0pSr2p7BiAG8lsnHCgTzaeXkGYv+KkN66N38ML2rLXdHag6nVNAXMfDQriCqNXpYncmvJ5Z9pZSmIveCRWvrSL5WTQ4hienqFRk7hqO2LLlkrDGicZb2T3i/B9Nb6SalgR2RujzbU4fXSk2kx8skKU3iGApffdAm6wCjoMBZXOXRFkziHcr4jOsschcq6qGD9jgBh7mHhrkU1e1QWkbY09ZW2DwS8FCQPrNXiD6/kiGUTjwhcb7hLyCuCWNvTvBwn725mlth3R8beDgWDT4uAA3wipR8+DPSh97L+kiGdg38bu18I/UXUKesz2Ig6fiQHb+4/vF57h5365KYT3fIzuLTy8GHe7Sy2uUGpxUvStwBIDmvJBS0v/QbZBU/YRUrBiDIb80HWvGU7gAtHOn2Ih4415kHoV4ryRlGESUlUKfFI7h7KqtdwD4xp0R7dNzJ5iM3sq0CUDRxV77sB86vzmeCQJnQLQdgPj3FfV7/rzPWdhKhdZHz4Yh/oTyvNdarnSY46QJyweM3TwWtD/vpjiPS/uKHxOWpNtMuGvSOg9M962EEaw6BTdud+zSKZiXIQBmU013OKyPWni6yOgqQ0KAVz0e2rSFUBvhT8Lu1uPTiaevkJosx+2VZny8mXauagGku1Yhr+uY3aFBkiW30oInA2yQ86ReTA9Bnr6YWPug8w3EpWYxHvdRma+fOEIxI11hdaPwLp/cl1e2+/ApNHXxvuDir1W8SAHkC1CvQe+7cz1egRC1aLuZsjO41zac3o7xybEQp7AhoMpLOBd17EBXaIV0U9pZVATIg4FAtVC5AB0RGb84WGWh+rUuQy
 CV3dl82g
 wFLz/AdhXtQN8Iamb0Hy8ZAfIVghpSOEqyfzlBOPcSnpyw2CEe+odIBwGmkWAIT0L5eiTI5aTJZuihrf1SDkBl0rGnqT+T84syYa16RumjrmXUTsave2spP2f514q44/oMhl0ZqPn61Hj0rz8qaG3BcrnD0PjynicVr1z4v6zPKhrz3ACv48/P7S1wB+WPp0afq3BueDOQwTQFgvE91rgKrWXelEy4zKV63SYDk7Wn7Yue1XIxUE6Oj3N3qDxXrmzFyhHGtxlWMEisaEkYm4iZgTnVfGDqwl5ivzvnpDbvRtYLyEm1nDQE5m1uqIPxqXT+RQQNhCxnkWyPA+X0RZbAPj5yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 5 Mar 2026 18:59:43 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
[...]
> Following the suggestion from SJ and Vlastimil, I prepared fixup to
> standardize documentation and comments on the term "zone lock".
> 
> The patch is based on top of the current mm-new.
> 
> Andrew, please let me know if you would prefer a respin of the series
> instead.
> 
> From 267cda3e0e160f97b346009bc48819bfeed92e52 Mon Sep 17 00:00:00 2001
> From: Dmitry Ilvokhin <d@ilvokhin.com>
> Date: Thu, 5 Mar 2026 10:36:17 -0800
> Subject: [PATCH] mm: documentation: standardize on "zone lock" terminology
> 
> During review of the zone lock tracing series it was suggested to
> standardize documentation and comments on the term "zone lock"
> instead of using zone_lock or referring to the internal field
> zone->_lock.
> 
> Update references accordingly.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: SeongJae Park <sj@kernel.org>


THanks,
SJ

[...]

