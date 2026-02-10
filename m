Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B13EB2711
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BF06B0005; Tue, 10 Feb 2026 16:07:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318A86B0089; Tue, 10 Feb 2026 16:07:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224D46B008A; Tue, 10 Feb 2026 16:07:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 127B16B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:07:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A59E8C2525
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:07:21 +0000 (UTC)
X-FDA: 84429782682.26.359298E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2B26D40009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:07:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LyF7e4Vo;
	spf=pass (imf27.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770757640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydS9yAFrAmUIMu8jskYYeyDaaknZK0/DweflNy2scOo=;
	b=eC2dXwtbNS3Nzpz9BM/wxSc4dq8o1NPOlGofkz/DrpONdiMku7pkbvA6waNJBAAQPCQAEe
	bH544An3w3T4qHz/fltrJhM7JqWGPgAcieGVYq6aLJQsqxLwkh4aGn90typPdJVkDd7vr/
	xLKy/g19ir91GfdCCHL5qYAeW2FT88E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LyF7e4Vo;
	spf=pass (imf27.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770757640; a=rsa-sha256;
	cv=none;
	b=3zMYoR8Kt6msZS+5hqMnh/7ZlQ/CxM4B0Tjw9s4BRMhJdrimnubgb1N0wBXtYa+hlqhCNe
	CewnIIBlVQHAvMcYwk8wZLTkMd7YiKO32AL9GPyu8Xd0ugzo2mETUMdjil2p0O2mQ2gknc
	dCPLOwkdkx+4fgdZATjuvxGf45xKSYs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C2BC60130;
	Tue, 10 Feb 2026 21:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13A9C116C6;
	Tue, 10 Feb 2026 21:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770757639;
	bh=ydS9yAFrAmUIMu8jskYYeyDaaknZK0/DweflNy2scOo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LyF7e4VoeCocyD3Vbvq6qOdyDlozU2ixwVjoZAxENS06BAIZQDedOydD0w/gSIBSZ
	 osUCwKX6PhwW56VKK0xYFFADnnKZT+smqwFdhNM5Ut9LHuzgd4QdFreD3o5NvlmfIX
	 NH3YU2McEzSVuJ1JoDCP+bd6oaPiVfqio+4dHebyJsa29TEFlTH3NqksmPPihrUG9o
	 kKQeTHjkwOsnsmGo12Ccplq56OFeUXNPsxVbkTTRiQg3rJtauN97aqkgYM+2PVK0cC
	 psq9TKt0upYvogmUC4uKQkD8SsgefUJ+Efd5t0DCYj8C3zSiaYb8wlgrwOZL8h5rSy
	 yYjgQFKdeeOhA==
From: Thomas Gleixner <tglx@kernel.org>
To: Andrii Nakryiko <andrii@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, surenb@google.com,
 shakeel.butt@linux.dev, Andrii Nakryiko <andrii@kernel.org>, Ruikai Peng
 <ruikai@pwno.io>, syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes-stable] procfs: fix possible double mmput()
 in do_procmap_query()
In-Reply-To: <20260210192738.3041609-1-andrii@kernel.org>
References: <20260210192738.3041609-1-andrii@kernel.org>
Date: Tue, 10 Feb 2026 22:07:15 +0100
Message-ID: <87fr789ukc.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B26D40009
X-Rspamd-Server: rspam07
X-Stat-Signature: nybxmj6o5coxck9hmyzk1jyugekgojh3
X-HE-Tag: 1770757640-4107
X-HE-Meta: U2FsdGVkX19LLfHKngXgMl3mq19Nb96T2aKoUCF4XkoA7I3Vxro/LBI4jZsHRuhJ+0NjXChhRUP7f2kB6fS6kHL8joC1BNa8OulizJd181sCWFUweK3gx0vWT6jcXge7smHCuX5A5WBVmssJOLzyYsfdnwz61k39dEnLo8WFfBZCnL8B/egIyPegXYbNTc71ya/P/H0ZpkxzMm5xftvZ6RQRnW6aceFih7iowRLpJLemQE73Rvr/FRGAzLJ6ouf3JOGWq4Bpg83LMc+mW3eN5LV6vqoCrCPdKY8NuD/YCT7hL/7u4eAs4r6TScH4gNYMKeuI6F8CffAk+L4wGIj0/vVwnrtt2H/kGieBeIqdX5i/AjVFuiGnk8tJgVJ5uPLZjI9hZwQYv8ZljiAD7N0w/l1LOevaq6I3zJmQ0LZvjL3uskTXxz1X37pDVP1/L9F5LuHh/hiQt+MZUUairO7bjWzvmDWo9OyDcK5S9f/0Wcns9wkhBFRrlViK7DayVeiCMcHbPcwhlQKX89ckavTdq/9stCbHD+L9jY68mCBrsSb5Y/AZYrDmTkz1ZbnkU3L6nBomgLEFPptaocFGUMh9N7FwZVd2DHUaPtS0dq2wYWAOFu0KJVvMafY/+rrXdjCj2zIQcnjn6J7hRfPxZ5E6Ri7CGjxuT8CMe89Ac1U5UTr7zG+vpqima7T5BUxROdhnpsx3zOmNXD9ui0N3iD68QppYb4Wur/0czymJ+tPB0VmGFbDOHH6re1z6YvbMr3/Ji2SADt6dFyde3XMEvqEmLAuSuqx/Qv0O6pBgIGGEiId72HpJKDN7E66lfdTqHhoVdEe8SJaTcLEX1x+YB85BhZQO+CpilLoWof+JP12hoWXYKIeUjzH2DEC3GB++uAA6d3g7EW6cEigEt5OKSoSKWdgmrqUCQWoXPWvH++VPAYHh2jLXvgu0jFL0FOPhs57Vitxq6W/nDdf70mHLveZ
 SiwTmxCf
 cAa+EoDSYK5SL908vfFBIErb11Ql0j2LS5qSw8ajfGHmQovbkhJLL/Ob/rz9x+CGe32BNfttg2B6j/NYn9efTJ+rXjI9qocF9VCkWk0QyLeQY1x1Q2QxEO3hEPViP+9NLBajDqn1ZIe6VAGlmPWfmfx084hNHLR7O96s77ch5xGMrUTSX9+uRq51pL630sCqfdjqZqglxap63ExhjOio2d9Yw7I3G1DXYXUWYVCLkFHLy8GDolHrmQZTLNvvaQA/dquPvN1KkrXt+m75p/5a61uK0LJ/wFW+NFlBG6CCp/raQmuxd/td+WspLCcVp5266z1WNnaILBvXHoN+lKc3bHUMTWrTyO8vx0TJc7HcZIg6rBbXnV/8M+N/kQh5xEy8tJT2tmNdsiOr5rdBo/RGGVUjUy54jnCetHPZ87N2as83oa7qp8I0Aagvq4cgR3MabS6OPd/nL/tTCUfRLLCU10GOoWSuHqO5nAZWcRD1h6CWuvJJCf/1oLP7vlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10 2026 at 11:27, Andrii Nakryiko wrote:
> When user provides incorrectly sized buffer for build ID for PROCMAP_QUERY we
> return with -ENAMETOOLONG error. After recent changes this condition happens
> later, after we unlocked mmap_lock/per-VMA lock and did mmput(), so original
> goto out is now wrong and will double-mmput() mm_struct. Fix by jumping
> further to clean up only vm_file and name_buf.
>
> Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA lock")
> Reported-by: Ruikai Peng <ruikai@pwno.io>
> Reported-by: Thomas Gleixner <tglx@kernel.org>
> Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
> Signed-off-by: Andrii Nakryiko <andrii@kernel.fs>

Tested-by: Thomas Gleixner <tglx@kernel.org>

I did not test this one, but the identical fix I did myself :)

