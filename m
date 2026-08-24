Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27023C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298746B0092; Mon, 24 Aug 2026 03:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248566B0095; Mon, 24 Aug 2026 03:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FAC6B0096; Mon, 24 Aug 2026 03:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDD916B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:59:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 562CAC0445
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:24 +0000 (UTC)
X-FDA: 85135413048.17.24AEDBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B32A6A0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:59:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFwF93wY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787558362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PV74/df/6K/umiQchKGTehfsFy4nUqFci6FqJy9u/3s=;
	b=S6X1T5jbHdcYdaCH57zqmCoPylruvmqr3aPzt5VUYNlNZIl8diUCq9Guj3M0Frg/90iKTl
	f9QsK4fz2avPDvI6cYjc5jTY/1EjZIiS93CuTr3yH+9EVnQqgHx+W7g+CY0zJLd62vuUD8
	bwq1PIuwmMaJwE85M6dmultLlqvsu8c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFwF93wY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787558362;
	b=RSGVCqx6SMiE8FgxX3ewc2eUT7oG8+NvylTEjJ6/uIubHiD9nN42AvQSDi904eLr2Mll43
	huEXCq3OpJ2Qou13UeAlzQoCUFVpSiiyp8qa2G2f+lfCgD+3EyCTWkJWSOeS4kB0K71YM+
	kQ+fa9BPurZ8kHNmHzrgphN36uemkmU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDB2F600CB;
	Mon, 24 Aug 2026 07:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FE61F00A3A;
	Mon, 24 Aug 2026 07:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787558361;
	bh=PV74/df/6K/umiQchKGTehfsFy4nUqFci6FqJy9u/3s=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=cFwF93wYiV3OddpWnmPqUL0m/ahsJfxZg0SmP+4hPTildsFPx5d2+/E83lgtNX01n
	 DFsTZUeGwyPJ1W2hsU+H6oRdz59hwazzyXIdcf5desgkPtj7PyS2Me9k2Q8kLUgvvo
	 eYA4OrrbFKuMYYXLUImJtbuAOgd9Z/Ooe6uNPutg4Hsai85BcXLntdjJ57V7q0YEOm
	 0NWi1EhUZ4CVa6zbBaTWmkDQe/LSanqmLgrp65+AATfViBRInl3LKdvWzNX1DbXbjE
	 ToXde76qZXN/l53PTLaolipBs1qyCyjuDo3e7mJV2sxYbtOEY62swuxhc+CW++Gdkz
	 2nji9G6Sw84hg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 2/6] tools/lib/mm: add shared file helpers
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260813181230.483746-3-sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-3-sarthak.sharma@arm.com>
Date: Mon, 24 Aug 2026 10:59:05 +0300
Message-Id: <178755834510.3606540.13456191565962471975.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: B32A6A0003
X-Stat-Signature: 3aidmfg494hm5fu8kztp7agohs5n76km
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787558362-135625
X-HE-Meta: U2FsdGVkX19LvWi/N91KaDLXUKNu0pIhH5aLHWQACDgRExfCLPyTeoeCcyQOITL5tRmRHj/kmCEPaPI+PKwhLSh7CwB+SD4wEEh+MOHV3ikzoS/7E/KNLGh45ysDSZ9Xn4sI/8XxXOJPasSIpcSLmSUar3vXW0OPpDaugsXPVFEew6pvVmzdEH7OtbXCMhKub+R3jLYw7WHdYdlk8HsPx2FAI8EfbltYq6cvJoACUhzSAdQyXFvD+H6eYLqF6HrXJBloqBDRkMH2OWY0cGXt074Oj3zK+lMTf0T/uqVaKtaXE61J9m0ouINkxq0wEQe9jIOAoXZonOXfn7PXdQ7YUBA4vIfe/XjGzmkhcvZweF55ZuSoMjdaCxDBKLD0f3IZBuv6wfb/M1FAkOeXQO9aI2jo9tVIVGQgWZGWSdJQBbJzSgHgXji4zHJeKGQb4iyNWf/ELF+0/my9cuTxNy4JEpjalB9Ef4lR/4BMvOFGvXlc3yw6q6z03trM4bqmX6wfFpbP4sa368augJTT6bQBVITSjVVsrZQpBvwnbx74jNVygX72VbJPuF7bcmiNjqoz/SQ97GYNHdL8FMQDajYvK8ewlwCAOT90MSpDCAdXlfu9Z0zJW02G07rBQgUJfjZl1mEPMJPWR6atcSq/cdZdmcKLE9gRAEkVFdx4d/ZJr8GupctzlOpSHWeYqBtWrGwVrWIyiIKRMyqHO40BxSgDd0PN3c7L8EJJzmyWtckR3T8QR6V68QQJRmuUqn9zQk43SgTQhQBciyZCMG+Cf9q8mMNmJTgLj0QN/MGqsteTmD8xZaSI7Kb5ylzG7/hCercPdhwXhFuUePbtRNm2o5wcF2c+uYYp39+glcqaIcWGaK1eu1Msqi+PSGLZ4jrtaynogvvdalC9XTlu8JE785xoyuN81W/ZFRG8rMsDm9eptOLNKJcAFZbZm0rMjslvfwVbvidhvu1HCgvenk3+lBb
 ppwYwpHO
 JR57Bf2th4oZ7aEE4GC55CNROiaNL+iUP/lAczAK9n9syXlPhIGSGuZ57etTLKdmaoPKqeYMXOPAqLXHQjOfA9mg26d+r47nNr+UePhfzlw9PmGF0YuSj35ef7auZvQDqb9uRwD6z6bwYfmqNVD+wd2vvro0vScEG6FZlK3sbkpUKiXyf6p/RC7m4uWI5bu7VzRmarL5biuiX69mE/9HQDe9xUeAUSX/JhnJn0BTBs0WlyxoCBJoL7P6/nCrMWn75AKHCV9KupeNyKw81oh65xb44SXJ7uEzMwh0gfcwgE2/eUwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 23:42:26 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> Move read_file(), write_file(), read_num(), write_num() and
> write_num_ignore_einval() out of tools/testing/selftests/mm/vm_util.c
> into a new shared helper under tools/lib/mm/.
> 
> These helpers are used by mm selftests today and will also be needed by
> shared hugepage helpers in subsequent patches. Move them to a generic
> location so they can be reused outside selftests as well.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


