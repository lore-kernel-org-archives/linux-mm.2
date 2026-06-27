Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A7EC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 20:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E586B008A; Sat, 27 Jun 2026 16:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACEA36B0092; Sat, 27 Jun 2026 16:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C4C6B0093; Sat, 27 Jun 2026 16:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5F06B008A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 16:00:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8238C132E
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:00:51 +0000 (UTC)
X-FDA: 84926760702.05.10CD296
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2FDCD4000D
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:00:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgTXvMRO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782590450;
	b=FNgTy76CBJvS62ErIIwu1oJ3YF7IFUhOU08kXdvzWHs6QcUkxwAUVWxHJI0NbFoc9tr3mY
	khqXBf6SpSYmzNQTUHPaTIoyNMCWqVnWl7TdYXdDTfgASEGL0D2vzXgmZrugx5OOHisIY5
	QSweqdLRkhd7+d82/RbHHtS2/sHBhxc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782590450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f527CLu6mDRgsWD/bgLLx83lG1rZOEcbh2Lt45pTY+U=;
	b=4H/1zg6oo7qwS2nSoYkccI9azu92QghwjpqwOjTOkzAvwZVWLmL1stm0jDqgcvaINQa8ur
	G5kWHdwCgHhrUwBuT8r7d7LmZTM/GvuXSi1cmMjvEgEsoNKtOBnuxb+a6VtZOhvobhO7Rk
	ymG5T3nbGZAIGouDxamt7m8hFR5VSvM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgTXvMRO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EF0A6001A;
	Sat, 27 Jun 2026 20:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80AF1F000E9;
	Sat, 27 Jun 2026 20:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782590449;
	bh=f527CLu6mDRgsWD/bgLLx83lG1rZOEcbh2Lt45pTY+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgTXvMROlLUUssXMcUCvh/+cvDKX6k2vlwK6v8qdReaM3u1h1ioSE4Me+2fRXcyIk
	 inJLDQ1zjxXW8B3VIney1ILvGQ4cv7u3xhm67TBCRhDVBK7K+pSxdw+5L9SuobUoLd
	 2tPKBI7gaIxak504FRJjlnNKMv/xwsnCKUHE5naYXeKu9I3JsqxOZMqMm9gR+IGtzA
	 2QVqn9YlRc7OVbPFNQqiH/7FEr+zxfh6wPaSsQVhm9ExSY2FGd28zVDxvrpfilRxG5
	 Dy6eMrPEBFsKwYeFbZLI6Kwjn74gWbs8oGQUmidx+piLTLf/N6NyWXvH3F58yKHP7h
	 1KwZOfmzMu1CQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: s/SeongJae/SJ/
Date: Sat, 27 Jun 2026 13:00:45 -0700
Message-ID: <20260627200046.24616-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260627195630.24519-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FDCD4000D
X-Stat-Signature: ethemjp8mau6yb4izqs5owenqgm5i3tw
X-HE-Tag: 1782590450-240958
X-HE-Meta: U2FsdGVkX19dLh5jZpB+IsO7YalSPVqCbMkdPsDGbAwBzYQhE8QLnTa8OarEQoXRV/bC17a+vR4FM1FQ015V1A/+4pJxZ9tzeaebNRYqdl6vY1nd7qDdRGrtewHlLrJbTdJ+yug+Sn2yJyt1sFiz2FYWAygamIkIoKZSOfGW3FLDjMaxq8qllj4ZRpZriG2QtTnCZSRkxnrRnwL0d8fIYgYCG3nZYp8yWLXTg7UjKIMGhCF+kC7Zeq2v9oSanHCM5YXSpxVjrg+U3AM7J69ojzykqQXbw+dHxAMoaB5MOLdoHiD84GIt8fqIpOD9h0BdGSmvcgLUNKH9ixqQi5lkZPHxWaqjM4DwaLTekxhdv/mEenXnippzuyL21IzCyMJfN9s5AHWUh820aS7Y5kcJmwmFHdZ6JRGlB2DXHvCfsT8eG2ipJKUHv/VAJ9mw5YSoqoqvbCATdDhfWs/a2WpZXyPd7+9Z828CUbO9xRGB/mTYbmr+Q7F3tpK+FUYRk2+QpLRxp277y1KC7jW0v8zaGndOZTPCBZ+rFiO5IWyt5y2qWWrOM4dWi5EjcVfC+7s1nzB06RP4yxjP5RRhr0DTvcFyPm96L2pe2DnuQIzOvXU/eVZrrtuZupWPEfvBPKVFvyxjH6A8fAIFiBkNSm7+RKnLr6BAsf6yd9UstnFx/ZVPUchl1KXrLi606vMhSOCud+emvOOZl4QVfkda1JitcsQrKNZEQVzSVsZYsFpBipjG0JzDG0cs/AOE/4UQzcxUnuplOoyQTBkU+819vB+zchbTmdRBRFflAELC9oImtqOI11f51xBHD4mlKgtkTQ5XQz77xnLN/jCjowGFLycGSCj40xAqWbt4O1LJGgwjlcBt4u7Nicg+HPrLF+FpMugAbXCrfRDE76CpU/FSauxc15lIIcN+yJoOZZoJly6fu8nDjaJFK/VsyNfV9e4CckSFRJXkG1DcQwsXKdgH8+6
 O/GOTscc
 BfIQmOrNkQkveFtehJtk3CZRrUbnXp0T81anKiKnG8m/7IEIoUbg6CeDkXs8xP8TZjn50DCp3Zt787YZTepu+22bl3dLUIjD015pOvyVoH7A0lyByzrN8Hny6tJJ3sI9n55GJcThJqI9wiVG4A8ecDg+JwAUTPin4eYg7iDWeIrDkD85Cc1zmB3y2TkkPWTnM1SqOXT5Kei28pOZC7rm4AcEUHTYQO8/Y+rkLynzJogpW8eE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Jun 2026 12:56:29 -0700 SJ Park <sj@kernel.org> wrote:

> My legal name and preferred first names are SeongJae and SJ,

s/name /

Andrew, could you please apply the above when you pick this?


Thanks,
SJ

[...]

