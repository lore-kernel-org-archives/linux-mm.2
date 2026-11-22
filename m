Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E43606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pve4ICZP
Received: by kanga.kvack.org (Postfix)
	id 9500E6B05BD; Sun, 22 Nov 2026 10:45:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927956B05BE; Sun, 22 Nov 2026 10:45:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D066B05BF; Sun, 22 Nov 2026 10:45:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64ED16B05BD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F31C6406DD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:28 +0000 (UTC)
X-FDA: 85463179536.09.2A2E3CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 90ED51C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pve4ICZP;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362326;
	b=MYN+XEqdgE9GJ+3yaC+w2dSFIMPf/OAqCBMUulnfWXAZ5lA/tasUamMZka5xgRedEDQXis
	7Z9XTEkXO8gFPi6gB2Ym6Lxk3HGkyAeTIlrqJnOBL2ul6U7Wa3pnQbS2sHmBhYz+k5QyHN
	pMfI2w1gSr/3Q0njhFjnrTh9tkLiqw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nquhKD3WFj0Q0slxNAWQdsEwMsCitNqMkLuN6iD9q2E=;
	b=KsqebipHvg/Phdj5HgoJc179u4hKMeVHRyw0P/X89Qvv/ECxxN3niZn+zVz1k7WXV81RzC
	8RWRYkVhxXWv/venr2AwDcEleWXwfWv4srk5jECOtFkB6MaO5xYKIvJxiJxPeZr/Agx9xD
	pIaXHeEiHqucuckITldq+2On+xZYDC0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pve4ICZP;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32FCB618C9;
	Sun, 22 Nov 2026 15:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404051F000C6;
	Sun, 22 Nov 2026 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362325;
	bh=nquhKD3WFj0Q0slxNAWQdsEwMsCitNqMkLuN6iD9q2E=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Pve4ICZPakxFRaJNuPeYHC++gCBHCHSv6y2Gn19Gt+4GZyJEqchbBg95AwqZIfOGl
	 dA4oNmUxorGT2sSuCSaxQDu+POBKnvd9ndkzAmcMWdTYd6j/VoR9zrMxxn7GPRYKrH
	 U6WHQYi+FADFuP16ploUoEI/ZWpldKACroDQvY1epAlKBheDoYLcR9HqRFxgYPAfba
	 CN0xbnyA93VcIrrWWupu/OaiBY5GmUUp3ocSREYAjYhQNOZ1CkZ7o2i6PeB8QuEURG
	 CBg7OwayAyf5QpmISziUYUQZlGU5YzlzZgDJLAV19iJbbWkNlX6OyrpjkC+jB7CbTS
	 EQezWZFfmvDqQ==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 05/11] mm/hugetlb: drop boot-time HVO handling for
 gigantic folios
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120100856.16929-6-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-6-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230137.3933282.6452527781490950704.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Queue-Id: 90ED51C0005
X-Stat-Signature: ofzzsjnwsjmrj3mj3gjuc4bsxdbi991f
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795362326-655208
X-HE-Meta: U2FsdGVkX18NIQNq4P8518AfbRB3vh3iejtuPy9CljHPQd5yTX3Mqq+p0H3FrWFQPzu6WcVYYGGs7zv/8hueP6nC4d21Z1EovLD0Q4SKUveJnEaDiO0vpWI2h749UV71v5BdVIKMGNakAntSoPnoiy4u0gx1xOMmYB95OGjABV17G/Jv64lxxvf4uHuIlffnJQMCxmEvqx/3f+sPweuDUPWCZzNqpR9ivfKzAJ8UhJM4k434F0UoFu15f4UCr5/s1knuUb2Yw3EnFTWJHhbTxOGjp0aXfjg7gV1z3ctoT7z7vMv5mC3rUvTZUukfXOfTdz01IWtcAWeG/c4wqJhK0z2WLhw0m5KrQLfcvfTdNGm2vgeewhPO3RSap2KZW+gjXgv4V6GNNm8uSXiajkjp9fmlHAELL9LoeFLgIOCwUiGEjo6JE3Prrq0mCzSVKqQsyOwZ7Jzqo9EgPKPSuJbFnANxRBf5mRlZ3obqs4lVOj5vYMBIklNWAb26GQWBa+dxA8MyELoxjWXrY1DjzlC/2BEM4SRTcK4s/Cpmxh9I50lVr7wjXjGE/LyzZysQAYBeCuz9eZaZ5hLt9l9Fm3lVb2TI2EJgESUZn4LoQbNnBH/1fBfAQK8jCuRTgg1hAtORkce8JQK5ovqtaUO/qx8kkfFrwY7/zjFeD1UvJS2EGBWTt/2zKaMMUuahHcwn7zb7RybrxVQIZkjo6ORQO9P6j813kQ9R/jHZ62embzw8VsRvxzAq4BsL+npHU/n0j7huaNKlecwKmMY5MpCoeU7P5eEGyTY6Abac/6CP38eNMk3vrb+Wn0UtRA6xIzRBiroLZPVwF9OMZrol8Qf8+Ya86FGuyaaydsnU7FVxv8PxVM9xBski7CQz7xYQFeU3vs9qbOvNJQ46tgvu27Bg1X1neg13Mj2ZZtutE6nwVVmJyyxZhr5/GGA6xI9AR201bFGHznE2MfevjSMp5Gr0p5V
 MGTM0Fe8
 nF3OnA6382rk9Se0V3tWMwUIcMR0t7N5J+0SX8/vIlNb+qywyU3U7QQ6m87JAqzDTiwE+W3mWe7ifimKDBgDEsM1fbzraYuMtRaYywdhRPo3kPC2n33hUAWVPK552XE1uh9roVa1ramzU/8XQyPtWRW6xmv3ikHj+SiHY7f9k39zZU/TnFSz35OfxT+44YyFbc7P7URb4Uz7AoeBqPuH52J/tLy1wHo4U4XOZOYuPDgIaKhdi1WYi6f1Be2PrHXrwP4j3W/eZOtAZr0IE4Rd708UUBMxCzzAU3DgOa60Niz6ZQBpR1ciAequMYIRYNJIT6wohe+Qn/yI57zdMBX1qyVaqfqX4QYGCVV/YFJTTJd/5QVgSAZB6eaBQElXSGKj5M+P8gKfc6rlHVkxGvcge545mVFj3MVtBSHalUX2un4Guu/H1NnwTbFZhunmngrjac/8fze3DmaEsJZ6BKg6RghbiOkwyh1Y+FrtznY0brC9Me+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 18:08:50 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> HugeTLB HVO is currently supported on x86-64, riscv64, and LoongArch.
> On x86-64 and riscv64, gigantic HugeTLB pages are larger than the
> section size, so the existing section-based vmemmap optimization
> infrastructure is already sufficient to cover the whole folio.  On
> LoongArch, HugeTLB HVO is supported without gigantic HugeTLB pages.
> 
> Therefore, boot-time HugeTLB HVO folios can rely on the section-based
> vmemmap optimization infrastructure directly, without the extra bulk
> optimization and fallback handling.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


