Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64D4606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EJlizn0t
Received: by kanga.kvack.org (Postfix)
	id C49706B05B1; Tue, 10 Nov 2026 07:33:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A0E6B05B9; Tue, 10 Nov 2026 07:33:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30A46B05BA; Tue, 10 Nov 2026 07:33:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 918EC6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:33:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 325D71A039C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:33:04 +0000 (UTC)
X-FDA: 85419149088.08.4AE272D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 78A9E4000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:33:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJlizn0t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794313982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZ5FFlHQL7j8baPJSvGmXmKdOgI4vorQKtT9ZrZsiwc=;
	b=yifJai1GrW0Jb4M5I8gZ8JqfrRpOVMioZLnbRr3oOlA8l9jMihyRnjToP84/Bz43EjDFvc
	sJn9/91GquXO54q+ngsUz4fuGIOnzc5WjIE43QC0MlVlwq92nyKn3W9U81Iyjmw5b3o/jN
	BwqHQPjTvWIPPBBiYJii3FAFWWLLxlQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJlizn0t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794313982;
	b=6h8Mfcck+oX4ByDEhLIolINKih7mChS2s7SU96tlthLnbaNhFsrufIvmaagjhBuJqwMGl9
	M3bClA6q8hL1ElS9QYrHFBO5amyxk28K5rwtoaYHEnJE6/pQbs2lyj/7oMFAS4WKOxGh7k
	0uOuyTM5FEbTXXnyUqYEszb4j39zM9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C116847110;
	Tue, 10 Nov 2026 12:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F831F0089F;
	Tue, 10 Nov 2026 12:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794313981;
	bh=FZ5FFlHQL7j8baPJSvGmXmKdOgI4vorQKtT9ZrZsiwc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EJlizn0tvmKilnMc/pUeIZZjk8kEV89QnhAodf4KFZQQHaD+DuDwKF8hmXqcXvj0z
	 NAay+rOC4ofaKPXwHMQhMxk0FyBvoLzf6daJ6d/7HIsF+EadDvJPz3eyK90Cu0VZV6
	 vMQhFF3jHmYPoapUcz8g8xD4ve6Zmsc9VNzo+4RgHv1hxX6948qg3+zjgbbnlBmBLa
	 3pHkBJ2mF7pOWlTxnV5BGnB1BcvluU5E5UvXAGged1MDaDE98uhh6j8AoOxlnQ7Aye
	 yV+lsMlQ1cmiFeHeUHD+W9400zgPIp6TQtZnyTg5hSiGHxU7y3P0edqOvsqnRKDm/f
	 5Vo41jFuG3Pgg==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Shivank Garg <shivankg@amd.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261109-clear-flush-young-notify-v1-1-b37fbafa2686@amd.com>
References: <20261109-clear-flush-young-notify-v1-1-b37fbafa2686@amd.com>
Subject: Re: [PATCH] mm: remove unused clear_flush_young_ptes_notify()
Message-Id: <179431397811.3951.2634081114462730604.b4-ty@b4>
Date: Tue, 10 Nov 2026 13:32:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 78A9E4000A
X-Stat-Signature: eydz67inr4kk8u4ahhen68f7jjrjwsm1
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794313982-610097
X-HE-Meta: U2FsdGVkX18ykgJVIkGJ/amWKkqDou0R/z5Y8shi9QepoyDb6ygJ19WbyJaAyKoW7Oi883FOlFQZU/jyzXyPA74FfWluorlmb7rqbPho1D4f6JJUQMr88Xdbtewte9dbtvLCIj6u5H4OuZAPUsSWUh/ccHr+cEtXf57LiSzpX3evVo06wOIjLQ+KAYBMTE2DnHnA8ovclMq+70kNBNqpu4ocOlFvdcLNzXZTwUp7z725rVAxE2WEaxcu0vehchiy7uDKfekCa9jMTYyrzKehuNYsSyFaw88f9w6JdDJDgDBOlKXZdhFxVo1GSg71Rc/vlTm3Cza8yD86z5MvmqmNTue0P7XASMscCsNdJHf95qGTP/lUhwOi8cSfuH60+q+AfMybAeqB1cJW0sS3ouSFV/05b8TlFcLQYnhkQtsV7OxIc0jClnmJqb24JnNqNwPmruvINC23wQVIp2Dk2HA2JOIPlG4cxqAO08Xna4xu5botGwtTyY8y8kBxwqxXkP2i4yqY5qgUREU90ofjpn/NJkVjLsWq9+5422nNi8QNHEhfRPEwIpfa0x8hxsqCN+CPTF/ofUcGQrU5RkBY5TcjbR8Z03O8ux4F8ywUK2r7V8Q17dQEFwuLT7SulDw+vr4/AMf8LhthQkQ4R98EA9VbKoyEMoDHbLbLuzRgCgTJXd90f4iKJaYiwp+rNa80b+5tfQfV4r3dPkXuI0WASFNi0HNRhwTDqKqxpH8XNqDuUo6JOqts4LF41E5vaeq5IEzQe3kbx8S9rHJuk199vZfAz0Tx39n9zw1ojLlNQQQFa3v8qe7f3KyM08Z+58Zvr2P7vn5I2kDpPWg70MchFSArGBqGI4xTm0X1bdVeEdFv9w7QqLXtQWPuUT50HVehyGt74q25190o27WUCyiQ9eC5zZCEFelz5UKenw/ATbf3fRT36SoHwqt+HvC9Haa/7ck4TpZPqvNO+dFLZ8TJdD7
 BRe0poQ+
 5KHqIV3PNzp4pXw01qa57hOU760hfEDsR94tJcJOO+EJtiZMs6Jo+kgZ5AWdopDkU0ZDC2PkA/xswgugLzClzFsONnlZejG/+evmE5QloTdVrEZ2tO3fUkXhFsF3e1rvRR4SF3+oJfE6Im/9p467+Vb4ba03xVpYkmp6i6Z+JVLRId2vdvqUCHSZ3gVEJ6MqAdMUqbrYJanBTvCJEJMeoHtv18PzFoL8J2MzmKG+nEqLut4GWp5mwMjwisWStu9bpa/Ipk5lrlyS5tl98MACkKiKkVUVcYKF4U6ez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 09 Nov 2026 18:41:55 +0000, Shivank Garg wrote:
> clear_flush_young_ptes_notify()'s last user was removed in
> commit f3c493d2f42b ("mm/rmap: handle device-exclusive entries in
> folio_referenced_one()"), which open-codes clear_flush_young_ptes()
> and mmu_notifier_clear_flush_young() in folio_referenced_one().
> 
> Remove both the CONFIG_MMU_NOTIFIER definition and the
> !CONFIG_MMU_NOTIFIER alias.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm: remove unused clear_flush_young_ptes_notify()
      https://git.kernel.org/mm/core/c/c6d408f2

-- 
Cheers,

David


