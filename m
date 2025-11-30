Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD83D111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 22:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94346B0006; Sun, 30 Nov 2025 17:53:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45086B000C; Sun, 30 Nov 2025 17:53:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D819C6B000E; Sun, 30 Nov 2025 17:53:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C66776B0006
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 17:53:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B71F13C3A1
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 22:53:50 +0000 (UTC)
X-FDA: 84168777420.30.23EBE0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BFC7040004
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 22:53:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BxtcyWLN;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764543228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFm9Wm8yHfI4ii92CFk0Ntve0UJDL8KBJMQNpXKPgTg=;
	b=B9oph4ahoXQsVfQ3PFpi67wXnErN8YfeB+uZJ+28L9sojzCjrumhOEHs/p9hS/mNmeGP2N
	yA3de2jBHH4iIzBWQX/UMfWA8ocxxVnZp+x2/A9Vg0TWusZ/Ha55jQNZpIeY1OFah8TypH
	SZazDmvb/XDNigpelmag7ip0JqBjp28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764543228; a=rsa-sha256;
	cv=none;
	b=zHMmSQkm5Rm/LP1hU5ioTq9WRQE02ZKfNdxx+CMOQ27+wsskQxA+EKX0F9C15mDJZ7UyuZ
	KXJrfTb0HNaEKUTrs84A0lkYJQBtMxrNS59+FK8o8UsObwzUVkQ+GHOiAnAYrSOOl3TfoA
	GohGEFVj8h3d+ju5ZjH2J8QwkQjjuoA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BxtcyWLN;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9ED7143D23;
	Sun, 30 Nov 2025 22:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D45EC4CEF8;
	Sun, 30 Nov 2025 22:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764543227;
	bh=dDXZN6yfuCJpIxHqhXrL/OshBzxUGz09wFG/LrqUbkE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=BxtcyWLNCEPHr7mUdEW0SOd47sCFuUXFpsIonfxcF4PTL0hXAtied1L9lyTfVPQLC
	 oQuf+Wv7E3qwZWSdjorXHZZDP0pp/acJw8bCyvWzBHA6sQiOwPbyI6X6JCBn0Ym+b6
	 X1yLATfFGAtlsKUJggVIxr632ZvZE/wGiwQWAmoD8A7cvzVRINjkJLsbuQkOC/p95P
	 LHPiOPlruVhOs5+WYEk6V7y1eGVZPNumqsGCZi8JwELyIT1rg8yw9l50kcx9FAAVjF
	 9/iOkxVpuwxm1y0uEBWrfJayokUcXjk85ZskmtGgfkZ42Uc7XeXe9VfQV5eJMTHpGB
	 111HYgIgvFnQQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  rppt@kernel.org,  dmatlack@google.com,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH] liveupdate: luo_core: fix redundant bound check in
 luo_ioctl()
In-Reply-To: <20251130010919.1488230-1-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 29 Nov 2025 20:09:19 -0500")
References: <20251130010919.1488230-1-pasha.tatashin@soleen.com>
Date: Sun, 30 Nov 2025 23:53:42 +0100
Message-ID: <86v7irm8sp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: BFC7040004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ezah15n5typu48xajspn4ydj7tbyyhtu
X-HE-Tag: 1764543228-46322
X-HE-Meta: U2FsdGVkX18H4iWyT+nOYaFPly6+vdhNiurHWnLeg7M0P1FRCjEJciC/ZRoyBBELT2chf5qluYbRqZ3CYwr2g8FESKbdLC2jGWElG16Dyq2hXzzzpG4GhFJd51A++tRK+ibA+GtAJ2XSRBoE5iB+btpu9wZd4H6lsm6ptVpeno/xf1Vjkw5/O6PymSGEHyi6AplQLhV1ROvcQhOsUN20+72pZvn8IedA2T4C5Y1Day57F7dsyp0XAQvEa69OLf8n7k9s3VpE+sjb/nTWJVe4hrvNjxsXgiR2CuwypRYIuhEfWYiHJE5Mj1fvBT1TT9DBsTI1JGEp/y7ZLp/qjtx0HBenq9lN+/CLErabvVX0GchEBAGmsHiWHhAa+yJpR3Mfkm6yf6urckTvs0Yke7cnKudHi+3bpn9hAE7qNykXzVSRlkszwzXXnE18mO0ikwhxys1aEpjyKFawiTJuhr9aP1mYTYnFbbpOz8d+sbWapEzlpWTK3PTeM3MEMpBGK6q6PwTRrEcBGPe+DtEMlTvGNRYiFZDgYkMMgyQL4MmQ/qHKG0zXBb7YJgJgFucEIqmPRchAl0RoyYmWmfMikVSkWRTBrKi8aTFjCygR+/2qh5vXKDRQKZaf+uxSKBl/AYNruTJvou/cQjq7GDWz9fmsHFZ941VTnKl7osqpgEcz7FghozXC3ChIWCC4YcF5VSZxWGPANSX4odRrS9d7RK+DnPhtnSd5NdG1ngQNAbSLq2fgGhTmJfmP6etQyz93qqSKL34wa8zMzw9kDjydVfXshzE2z2YtCah3U7Iv/SvZub2EfgIvP+SoyJxhvU7ysVXEPKSya27nA/0/yGkuiL3qi1bC6vxH66lMAOEyG2gccOlT09E7RtPzykAzW0ehL2xiFnGDlfXswh8Zqkd1kcYz0qkEjNihsQnRSnNNTe+1zKrwEHSHv5P27gt4yFEHQkk5vlZpw1GCkhJ78wy3Wlw
 mNi0QHR1
 8u37xi2s3bncPhdGrlhRmHF3COwhVVqcIDbZpGWQQrw7yeLQIBEPw3WaBDfIsIYPI3+syjYEalgZ1+r9DJo76IE5l7QCnU7yQoCrBnKtQMoOSltOM8buy9SNoFVIXjIYTylG6wfRUbfZ4emyttjglDPBEXt3T0BLE+USrzIteh23ZJKpo+ql1B+Kz0ZVVYuWHsOZEUWu3g+noOWlbx/PDxEt6RSflIPAJq4dGiwA0RoY1H1LVGNq7yd8DsV7L6R+nauBHhhnO+4Rn3LJTH7+G9wkep0/ulscOLsJJqENXUDmUQp8LT7yfJigFoMDkfP+LXqnh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29 2025, Pasha Tatashin wrote:

> The kernel test robot reported a Smatch warning:
> kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is
> never less than zero.
>
> This occurs because 'nr' is unsigned and LIVEUPDATE_CMD_BASE is
> currently defined as 0, making the check (nr < LIVEUPDATE_CMD_BASE)
> always false.
>
> Remove the explicit lower bound check. The logic remains correct because
> 'nr' is unsigned; if nr is less than LIVEUPDATE_CMD_BASE, the expression
> (nr - LIVEUPDATE_CMD_BASE) will wrap around to a large positive value.
> This will inevitably be larger than ARRAY_SIZE(luo_ioctl_ops) and be
> caught by the upper bound check.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202511280300.6pvBmXUS-lkp@intel.com/
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

