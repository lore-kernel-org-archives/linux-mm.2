Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE1EC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCBB6B0096; Mon, 14 Sep 2026 05:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0146B0098; Mon, 14 Sep 2026 05:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77BC6B0099; Mon, 14 Sep 2026 05:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82E426B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:45:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EACB1A0187
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:45:55 +0000 (UTC)
X-FDA: 85211886270.07.525FA6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 02F9940007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:45:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGjqTOEx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iGjqTOEx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789379154;
	b=EHrQfus9f3j4SzPdcXLzENbxDqJYjfr1iueewGLB7iXj45YewhZmvAsFyRgp+kGl8DonpD
	fl2NM3Jj7ZGVRhzuEZSi8EPEkSIF3484Q6yQCo0MaElI1x6C8TsQEaaN/xVFhVeF/u8MQ3
	DvQN+eYXclhSrQ2l8UF1CY0BXPMtFfA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789379154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYFRtPItrR9BesC1c0SvNo0V7skAjyhampHOopOgb+E=;
	b=YKJ8kgyAxD0lNc2b+VKtbrJYtYx0qBW0ODKFrvF/wRbEKSoyR+ZD2WX//Fa65/PYvB9KcV
	+al1vozno+jFkmXhSLmdsgtrAJnQImaLidchg0/KHHeiplIjv7gleshki2eKxdsSpyffIw
	ZvQWhjNY6jJWVSN8+L57T4UhSbhyARM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FDEE60142;
	Mon, 14 Sep 2026 09:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2331F00893;
	Mon, 14 Sep 2026 09:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789379152;
	bh=zYFRtPItrR9BesC1c0SvNo0V7skAjyhampHOopOgb+E=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=iGjqTOExfOZa0QvKhfJUvbiv67FIG3c89Rj0rsUQxP5OgPpsgR006zq3WD2eeCfhV
	 xtycj63iozwTSTQ0srz1rAj0DzmLvTd1HsDnAM571u0uWAqqFa6GJ7U1ICrCTviShy
	 VlhuIhZbvEGvJPOqEAe6kgvO3E5SgKegqG+qAfIANENtQYb2h6+7+nbx8oJuwQc2ha
	 cT0M5h74snkyBiarWehir1s+f7q2TOzSFVyhkloVzYAwWHDSmStDrREmV4BgU/F8iK
	 QnhfITXbe5BRsMHiARKZDHBWD2Z4CS9tM/WILqW2KlADJsEMt7AqrbpsouYlFiZry7
	 RdDKOScVJI71g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/12] mm/sparse: remove SECTION_MARKED_PRESENT and
 further cleanups
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
Date: Mon, 14 Sep 2026 12:45:42 +0300
Message-Id: <178937914266.4188640.7965323974267420342.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 02F9940007
X-Stat-Signature: qgjebb64xefgcit9tbd7i6qypmxni489
X-Rspamd-Server: rspam01
X-HE-Tag: 1789379153-768815
X-HE-Meta: U2FsdGVkX18kn3SjTzLKSIiNJPGsv9rfUr+i/XwbuwpECe7JkT3jzS/UaevpfxljPUJUDj3O8M89RRWFnAz7zD17iinA8nkV/TftGMziv+YTgnKveq4jX/FlczntCn+rTNaLd+DQ2UlnjE6BS+taihWYeMssU/p392t8MhoDucblYq8Zj6/FtKDCUzPQaxA5vre1OH7AOh9GlHNrW+DPwKRSk+eZrJCmPg59XzVFNQj2zDeUyx02kpndacrRT1tEVyLnfxU7/fh16yMfQtVzyu+Qd1qgSwSKbfWUm/q7f0GLJ0ZYE5HIuf6TERT7/bsLlnt0wXsS/5fRK6uYuAt4qzEVwzwHJ5yHJEvEzlLs8QMo/Q7vqaRB/xqW7lqn7inLi3+QSCVmiD0dcYnyH9E9J5WrG3F/03GOqp73o7HXcEvauL/26fyLxNK9Xwa7szQ6j+eCgjSwDUmj8dzTShNu/a4ZkWZeyNBuqClRgFU8iSVwuQFY99E2S88QyFBfuo/xlkh4TQbsK5xDNqOKfB0XXN/BbO0uwAbPUP94hm5AQaEVpw6Obue26NIKdFdMAQOgL+Uu0CUNSQKLse2vId6MlUS9Gx23I+4h9EyfBb2wl3eEUWsMMpn9UIi65oeSE72XRaEjmeUuxZCzt64lFSOryvowvEBdur/9ibvkQGZbB/Q81zgQYrDuwZtvuc6jtJcWf8E8DrrScagYxEwwOoNogvcd1seon8QwO8uc728nMVE/wj49u8P6T3qBfLUf/JiiCxwaIFnGriUtc94E1ZSyD/dqPtb1Qu/HiGAprwrhGsek7bi/P6D4PeE7FBejLqbuDj6q6kJfybQ+wHtFtD9mm9EUBB5fRpEKVM/6WIeDtgGXKMEMoQs8sJ4+YWLNeSrbpOmb1PRYBxLRwvvR3aH5D5hQTNNF4jn9jYYc7qMJWQIiGHzfQ9nFsxOFoCXNtWeyKcRNWYpHOIMmE6tWGRU
 6VeVTcxj
 nRqFYGPUsi7j7+hRpYprlgtT35ScWpilwJBdqJnFEY/5W1q8wJ7/jDm6nX6UiLZDJYxzHos9zae6WJZ9WPe6SRa31+QJSiclyi0NCMf83rzlS5QcwnxqIMx212YksO3mhKMsORr6EE6IBrlYSKbOKi41us+3Ocu2thcbPhoQjm1jhuvHTq+rc9RGXP2uUeLZPIlfKTckkKCrGW5FhJe1UGlpctWOx0RRSfLqe7KjHZ8W2RAqn8LGNQYkM1HlGJ6NLrGIABgB9NIkSkVpNzOOP4rCKsikMAqxg+O11
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 09 Sep 2026 15:32:53 +0200, David Hildenbrand (Arm) <david@kernel.org> wrote:
> mm/sparse: remove SECTION_MARKED_PRESENT and further cleanups
> 
> SECTION_MARKED_PRESENT is really only needed during boot, where we
> can instead just rely on SECTION_IS_EARLY_BIT by setting that flag
> earlier.
> 
> Some preparations for doing that conversion and some cleanups in the same
> (sparse) area.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


