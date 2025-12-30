Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32490EE4983
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9775E6B0088; Tue, 30 Dec 2025 11:26:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924FD6B0089; Tue, 30 Dec 2025 11:26:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830DA6B008A; Tue, 30 Dec 2025 11:26:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 740BC6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:26:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B3321A0AE1
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:26:37 +0000 (UTC)
X-FDA: 84276665634.12.2DDCF4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB715A0007
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:26:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lwbfIitK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767111995; a=rsa-sha256;
	cv=none;
	b=qbCK85IKlPwm1kaZtEjP2GMk/aG8B9yMI46TvTilSZWBIWGRQ+XkbtDBCCN3uryPBCk5dg
	S1L81Jq03aIQlkRr86F8F6/wqnjW0+0s8ULO4nWVIMHeBGaWlKR+cJ86dGi3b9slyFxffZ
	L+y46InRD6dp7Ftn7f+ddppqkMgrEgk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lwbfIitK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767111995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KKUSWFo7Iwo2TJWGYzI0ssRSkagMbg2+GN8e6KU050=;
	b=Q3wKe7iLTg8K25VkmiiWV5AuCoHvNywH1Ke3Ic9cZl1ZVr6/T+YYfDGeWOoKfHWXSVbeCd
	CtY+vDAYPT5VXehfwRxE8xFwZ4Jt8zx0nuGXsAZs/KFUkpMShu3rbdOR5nIEU3NYsCwMci
	mTyFhMgu5Wz8j6CURqI9a3YHlH6fscs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FE4A6000A;
	Tue, 30 Dec 2025 16:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B83C4CEFB;
	Tue, 30 Dec 2025 16:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767111994;
	bh=noWdpEVhxGi5t7Nr2JIuYUNiO+HkVoYB8qZqkKLGh80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lwbfIitKUR2wkcqXy01+kxMaclJdqpjxOALjcpGS2TQK4eUvbWl4a4Yek/XeHrSbq
	 V+CU3h+womQ1ItZTcAiQayJhr6HDRDmcKjiORQaGbhBaiztT3sNkMcetEuqpnkVe0h
	 U1A+lI0ODDuBF06GqvB8d6MpkNEYFWlysJ9z5ZPp49meUdJG0evxGILRPYkNP/fHnd
	 h9eC3JtLXfBRkWEGCzoseFllk9Uy9w5KJ3rAioh3FPItq5Kqz/htqNwYVMf+IZsXlU
	 X20SLREp144bOoce4aWRAlbQXzBetQ1L3WrtOhO9ILQqoFiFXuSdh+ZwMhZgR4bPFG
	 7dioiwzG/qcNw==
Date: Tue, 30 Dec 2025 18:26:28 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Li Chen <me@linux.beauty>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liveupdate/kho: Warn when kho_scratch is insufficient
 for sparsemem
Message-ID: <aVP9NHDn0WFtkMNP@kernel.org>
References: <20251230055345.70035-1-me@linux.beauty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230055345.70035-1-me@linux.beauty>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB715A0007
X-Stat-Signature: kiwnsbe8jfwhcibxjknm6gfk9tw6gdp8
X-HE-Tag: 1767111995-799529
X-HE-Meta: U2FsdGVkX19ijTVcTs9pOY1PvQH0U+e9FxiMyJh/LvtrbdB4DjKi7YohAv0UXLZ3u/KEzIFfdFhwLx/O157BR4rXPII0VtCxC/Btp/rQuACg3r1kEKvKTzN8/HmJYrWPFrEFjJYvFZMAmGzohhpTL81J6fjzjIw6nXOOEvM3ftAZXL+zLZ3gW3y9+ErKCGA2uVyo8sc0W+an98dRjPEpKVjWi2Z8KpOVLV9wu5eOcHL49FFOFggzgDiH3WAXsaTox7XRpscEHg+LjwXVVbzTmwMraTDA1L363sMzLzfFcLWDwtcUJrNnon6gbBWtWIfBBdj0rv44j2jfHFB2DlboLxO6QT+RLuzANs3QzEEyRkPa1qurplzK0G55J8kOI75U2NVkFFNb5vMQaNd/mm5ZRp7M0rt/ky4BSqJCLOuHG9fx49GTSNfpl7PkBRM7Tw/44ZNnXGjSP/53UHl+Fe8Mll32He8iQZCmO1J7L4UlsuHDDMwPZj3CuDrYPDfn/ZTpAo83+Np2AhEuFzrwsDxdUw0ThdgTMXx9Q6fgVU15Scs1sHQhK3ewnmcOhsUbN8x5mVieZgmUqITt+K8aR1NFdgIK9qqVluzKUlbwcxzDCojDUj94EFynxxyo7vtBTt1EyGyFnzfXyr3sxYr7eEXSAbKadie01aDRN1KJcYw1PadD4a7/7nNVM1UbttX7fphR9V0/Qk59Tm5xJ0z1uKUlKAseRYLuVbRJCxNi/4VCS5+WypMGQ3AT6hp0W6F2JNhoV8zv83d0iPafyGohAvTuGFKLA/J6cu/k1UQZfml38LBE+/XxtL0DWI1rJlRnX/tMfmAXvjIiqtCG8jEB/juAQB4+tYP8iqEUgsyj57J+cSMBS6/3Da9YiVTuqyQqY5p4gd3BIPPbIls2Ij+i56wOyYdI1RDPSEcceRCsM3d+8nhIB2UvQtttxXmWn6Ib6pXa2ZceSA9TH+1wogNyOVi
 Cvy7bd9s
 W1hxy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Dec 30, 2025 at 01:53:45PM +0800, Li Chen wrote:
> With KHO enabled, the successor kernel can temporarily run memblock in
> scratch-only mode during early boot. In that mode, SPARSEMEM may allocate
> a per-node scratch buffer via sparse_buffer_init(map_count *
> section_map_size()), which requires a single contiguous, aligned memblock
> allocation.
> 
> If the maximum usable scratch range in a node is smaller than the
> estimated buffer size, kexec handover can hang very early in the
> successor kernel, and we may even have no chance to see the error on
> the console.
> 
> Estimate the worst-case per-node requirement from the running kernel's
> sparsemem layout and compare it against the reserved scratch list by
> splitting scratch ranges per nid, sorting and merging them, and applying
> the section_map_size() alignment constraint. Warn once when scratch
> appears too small.
> 
> This check is a heuristic based on the running kernel's sparsemem layout
> and cannot account for all differences in a successor kernel. Keep it as
> a warning instead of rejecting kexec loads to avoid false positives
> causing unexpected regressions. Users can adjust kho_scratch accordingly
> before attempting a handover.
> 
> To reduce boot-time overhead(particularly on large NUMA servers), run
> the check from a late initcall via system_long_wq instead of in
> kho_reserve_scratch().
> 
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
>  kernel/liveupdate/kexec_handover.c | 396 +++++++++++++++++++++++++++++
>  1 file changed, 396 insertions(+)

This is an overkill for something that a pr_err() or a panic() would be
sufficient.

-- 
Sincerely yours,
Mike.

