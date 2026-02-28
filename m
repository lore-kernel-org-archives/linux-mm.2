Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C3AFEE4F2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 16:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01286B0088; Sat, 28 Feb 2026 11:31:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEEA6B008A; Sat, 28 Feb 2026 11:31:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBB16B0088; Sat, 28 Feb 2026 11:31:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABD0F6B0088
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 11:31:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 517311B714D
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:31:31 +0000 (UTC)
X-FDA: 84494405982.14.9D6DB7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id BDDE240003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:31:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dE7ahF95;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772296289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wj6CTCoqn1w+ecTxwWSk1p8+ExOfljAiYJVkOKIthak=;
	b=o49lSTR72+moyfkip+nh6MiDfhu6Kw+sIEy5gfI2+dAxrX7Lq4FAI3wfTaqh1+hNUUa8iy
	AMqg+QGSj4Ksq8ylRARj91DWJ9SrBuky41EWh/3TR1NgsCUARZcOvJrS63AxnkKtqB3l8l
	Nb9OSYsBKfaloM7itpZdqHBALYq3BOQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dE7ahF95;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772296289; a=rsa-sha256;
	cv=none;
	b=TSo72urMx2pSII1KqPUFwKyKxKkpgtexidng7mUMJeqhBLcfrjvqlHCoMxzRNgtUawBmk0
	KzTZ313fGxKtVAAAtFuqL6XDlBF+Ws8r6lOP+EnAEOdMnMboWK/SQVS5hINWQ4jv4SuxI2
	lZrGnwQ0xdxNm05r8F7/0dRYjY92Z0M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4417B600CB;
	Sat, 28 Feb 2026 16:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5742EC116D0;
	Sat, 28 Feb 2026 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772296289;
	bh=ZGHQINXzynbWw/TBUkaU3ArxtEBNGigaXhn1b5sfigg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dE7ahF95IFImF7XwKhFLpqADbq1bNgCkAi6Ebj6rFrZX3oiwx+smXcRMaDx9bpKNU
	 zTkKFGpUU0gSrGGe7zqurS6SIrvFOvXk/EjPQMAMhbOMABM0/eLU+E2/JlEhlFLx71
	 TxI8oGcmX9LfShn3cmjGZAzjAg5vQrtdjuihqma3l2Er4M/cAg8eMqtt2/rl+eeyns
	 JsEM4RfzGgcEHJCiT5m7XqpR1zuiwifIwpY81tfgymd56wjuikZ5b8KBRBRWDYVWLw
	 uTb+20pkakjwRWnJH3i6tMX1hvGKvLIhaJNcfKl4PhTb4DiHT1VZ2ZfvRbIclCs17C
	 TTtq6nqpIiKYg==
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
Subject: Re: [PATCH v4 3/5] mm: convert compaction to zone lock wrappers
Date: Sat, 28 Feb 2026 08:31:20 -0800
Message-ID: <20260228163121.213665-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3a09e46f52cf9f709b0725bc2b648cc5212843b2.1772206930.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDDE240003
X-Rspamd-Server: rspam07
X-Stat-Signature: ers517zdsibkdcoi4xqjkio955ijr5sm
X-Rspam-User: 
X-HE-Tag: 1772296289-892980
X-HE-Meta: U2FsdGVkX18w82AFht+SOSeIh4sLvm9XZDw/jcqmPKBzT0IdB+9vn6KaD6261DASp+2LE4UTPqnmuI4hsUW5QoUeEVrPRZ3KWLBNOAZpqqu4vKojDEiGe+L4oVt59zYLuUmBax3KzXOm7EHWpMZrfDsC5m0JgpKy2tftLgYgTst67FKSwwC3jTfo0JJA0Jq07OEwYchhLJZt+zTGKsFoPvg8JxuIFf2VcF86L3YLoz0DEueUawwvsE0Ispff2Kvide3iF7uDPuwbb9sC9/kZMrNiNhxcT0o2MyArRf6/H2IIOVE5xz26zaTA2AVR8mpJDTEK/2jL3cT3YSu58NXxaruduyvBRiqaumuKOVQqLWqonofGNDR5k6e4gqacF/iR7rMNY/iCdqu5vrTE/Opd793kbVC9pwDxfbLWBYwmrFc+pS/FrHPVYB75uyjGLAoAMygbN5P5XB7sw4yfUmWgp10ph96ZVed7XLaxWrkOEcOlY+Jj3B1pYV8Iyghv1yIDmuJ/1ALlnOzqYgp9VPgz2/79cybAPX5M/ZpM2q5RzxmAOCUOUIPYe7GXp5NwoS9iTHIEIX36Y/wtHFkL7rSYBlmX2rjuQsil5Qn/4XPzdS+n+OPp6oyzi51pj+NJlC3KySFt0hN+j6QNR2RHsndDcjoFzEShY+1KpCjyMT4VY5HLjN+xJYhAn07e9qLuUPHBsxESxqxE2OwJqq2hy3Vti8udKUiWbua00yyDR1hlWyCanN6DOnL7ERFBV6giOw1JCYJid3315O2Xz+8bPkcgo2lBTVJ00N6HzAuAstyXiq5w5vb1libX73xavfhDiwryiTgm8sw6Mmh1OMzLAXSVr4fSsFt1uD77ul/V8b20dVVdQwbPOS+ovUFhXkpU2SpOZd8LUuhS8q7ZmHubKekLjs44d6R4w8KgNU394LOypyPxSoSTfLeywvTDHC75mKK+Tziqd7hzi9tNQGhQ9XA
 lgE1Sfq9
 +U+H6hwf64y7He5DHSusazHpCS5Pwaizmenm8vucqbo5RtTdx1y5OEq1slocYccE4JqvMryM5Z7tjiWZZAqmZrU7VE1csHd3uupqC0OWO/W3lYz27fMIwwovZafg09cpJMtQEqhYmyddDDD78d3KuZAZh9gAO5pzUXhZIeF+MUfXYkU15XGk6jHcVNailB1Wuv3hhmQbXFxl7+7PXVefscRiKDMSOlfeqhbpxfedX8dPFCnCuCYqre7CNLRUIjKaoc1U93zrZ8/S0JTSelZymcPX5QTe/cXp1LM3q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 16:00:25 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Compaction uses compact_lock_irqsave(), which currently operates
> on a raw spinlock_t pointer so it can be used for both zone->lock
> and lruvec->lru_lock. Since zone lock operations are now wrapped,
> compact_lock_irqsave() can no longer directly operate on a
> spinlock_t when the lock belongs to a zone.
> 
> Split the helper into compact_zone_lock_irqsave() and
> compact_lruvec_lock_irqsave(), duplicating the small amount of
> shared logic. As there are only two call sites and both statically
> know the lock type, this avoids introducing additional abstraction
> or runtime dispatch in the compaction path.
> 
> No functional change intended.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

