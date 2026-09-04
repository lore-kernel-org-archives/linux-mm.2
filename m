Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5035C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B32D6B008C; Fri,  4 Sep 2026 10:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863916B0092; Fri,  4 Sep 2026 10:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779A26B0095; Fri,  4 Sep 2026 10:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 507CD6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:53:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE1241A01D6
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:53:04 +0000 (UTC)
X-FDA: 85176372288.28.68132DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 27BFF12000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:53:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtbqZlC+;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533583;
	b=duq4cr52/xIcf8LcIfIMZODc2CHHiyxsy6WrZ06ym4fYwiazp4sTlTWgB5nlRNV8VTyYIY
	jJHYMDsLEuJclbbdxlOEy129db7EuN3DOF9oe15hWMEgH7ET14pT8+cmeku3NuLgN/Fqcb
	/Jj3zU5KMbUsUPIneUHsTAPXpIdKslQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMsZaOMnw4fKa8U0Sh6WzCKmsA22ng83jsVlZiJ50Lo=;
	b=Um8niZala1BdDgSuIYexFm09Ug8bxDWfMlR1Izwt/W4DZzyKWe6NHFrZX1R39tyfQnetnh
	KurjuraCDm7mbsysouTJLega8XSc6qxBWflVsWZ7gcpmrGOf7SSAeiuny/vKhr64dlDhjC
	RvgP0L0IuvrAaVWi55BfdErS8XupstU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AtbqZlC+;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA813600C8;
	Fri,  4 Sep 2026 14:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09A51F00A3D;
	Fri,  4 Sep 2026 14:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788533581;
	bh=HMsZaOMnw4fKa8U0Sh6WzCKmsA22ng83jsVlZiJ50Lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AtbqZlC+ibRTZBMzWYnOHByF8jf9qbQywKa5Pfs9SirPoWpqkSW1cJdljVdmy1t6b
	 boHVl6YehSTJOtaqV9uLzLYAx5tDgAV3tw+3OhxvH7E/5WLUjQ7qSsG4VXOL+wvuCQ
	 JWj039snVXZMk8W2GCnc5OfC9EdbFWojqynctTRQU0IszCzpqjDJgjk9avcH6Gp+jB
	 8qPyeAiwOZdm9rzXqebgacHW/y6yIDULY6EwGNz1jkc0KBA9mufqYdZT2R3zel4jts
	 2wjmzE5d2ZinZtU6oSgOZFSkVXD9uWsHBPgA3lepZZULhrPgw68mOHT39V+jg1LLkH
	 JcJt/6XOfW9rA==
Date: Fri, 4 Sep 2026 15:52:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] kernel: fix typo "overriden" in comment
Message-ID: <aprbL_maJ4z3TURl@gremlin>
References: <20260904122054.28531-1-hemanth.selam@gmail.com>
 <20260904122054.28531-4-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904122054.28531-4-hemanth.selam@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27BFF12000B
X-Stat-Signature: 3w1irrzom4qato5bkrkic1zyagooz8gn
X-HE-Tag: 1788533583-462642
X-HE-Meta: U2FsdGVkX18dUSznzGa+KxpMItSaq7uXm2HV5OSihDubIDjEDhnH7zO19Mz+Lj8ex3S25G+cFD+9yVE9B3rWHTIY21q07aTW+Y38/a9FJ5on4/wp974XqR3YmlZaECfqF3cBL2RYUl2m1fB7Lg9xjEM9wVL8nDRrpyZcvzsZh14s7evgiGW2VsPNfN0blyOV8raStXk51nrcBIf8V3rGqFn/xySk2FHFtCxpVhky7YBNgk3WU7g062SVdaJGdGkTifG7BQ2pgcxoDA62x1ztZpJial6r6vqswH3ixJtbebCTS66/GSbqSa3WKJ3NF6bij5Nnon6cKZog/u5wu9k0NhX3RVS7MtsXDpCOs3x6MmdoLaBeiNHWHBcz0PVc4FKssjQPsHY3QfAgrEzovMMXHzGkhGZy0XssPbzyQq8I4q2d8z3wT3odmJvsw74WMc03wA9AfntD5iMc8Tzgln7Jx6DWrql5JQ6RoIPceZSjooSuPcu8NANo2JFvk2wAj8VPbiUyusvGXXWmfZUiCvY6W+2X6ytdBtQGvni34rb7WzSdNXSeZT3fdSav4dOlEg+rWp2rgSlPz6vDsizuic6TVBo3VNqWMxDIhD5MmYIDCx/Rd1+OpVcYZY68vM+insr/x2MZ2BwIKSbe3TOPFWsCKvzzgIiMT2+nP/q6uYcaCIvyqsILKq74vi62dEPRXSikcd0f7h07n6LNYOYjMQK3lEBsuIaj0bIzhjllHGvA4BzUqnddI2CgOceAmewZNmw0UjU+eJfGvAt7e7exdZJk9Rky0yONxkgvOZDT+ThFIk/bU+ehUgu1IlmiahPbOAzMbqhXZMk2QlOGM4mTH68QhYpvxDtvZaApMdh4sWCS4CiEC3KuiFJjXMvJxiwgKtFRmzZjPE11HWosMJp+b/EZRJ78fhq6ehFK9FHTAIb1DwEED7OH81IVTk68sCQVLNKE4SCqScEJXuaj6ePAOXz
 wiBPsGOs
 CJaxeVnq07Kt2AHMqwDM5L/OugMwq3tn8m6klZXgiWvlmlpZhviEEpaY2tyJwnRqd/aC/lXDlD8D5QBhdqZ0hqo7tlG8NNFcEbhfgCgTl60ZIsLnrSexAfXEhubQ5Z9c48AZ9WHQDW7YZOM6+Vrjg0pDEUR3cDbKhGp53vzko6fExrKhb8cuGFWP730/dZ1LABnpgEjQ75PRh5nX3SxI4narvfBQlKG4K1Tq93PSBWZ3joz/u8/KzWJBU1AdkVfCgH6C22kRcavLc8+P43bU0leI01AMnVTDB0esPMK6+zNkwZNFrWGzrm1t1QVeWn9ZNZU3eZbB7JrHzVMZpJzRZKshHmD7hYtR0CxLp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Another orphaned email, please always cc everybody on everything.

I can't review stuff like this esp. not for purposes of typo fixes thanks :)

On Fri, Sep 04, 2026 at 05:50:52PM +0530, Hemanth Selam wrote:
> Correct "overriden" to "overridden", reported by scripts/checkpatch.pl
> using the misspelling list in scripts/spelling.txt.  Only touches comments,
> no code changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  kernel/fork.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 416758c8a3d4..6d3340d34234 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -3266,7 +3266,7 @@ int ksys_unshare(unsigned long unshare_flags)
>  	if (unshare_flags & CLONE_NEWNS)
>  		unshare_flags |= CLONE_FS;
>
> -	/* No unsharing with overriden fs state */
> +	/* No unsharing with overridden fs state */
>  	VFS_WARN_ON_ONCE(unshare_flags & (CLONE_NEWNS | CLONE_FS) &&
>  			 current->fs != current->real_fs);
>
> --
> 2.48.1
>

--
Cheers, Lorenzo

