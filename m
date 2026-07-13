Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C70A0C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F766B009B; Mon, 13 Jul 2026 07:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7376B009D; Mon, 13 Jul 2026 07:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E216B009E; Mon, 13 Jul 2026 07:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A051C6B009B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:40:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4986FA0104
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:40:52 +0000 (UTC)
X-FDA: 84983561544.27.3C2B580
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7ADB0C0007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:40:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ifZu7rvK;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/6B9YNSHoy7N6JoeH5/zIRc86w/yJtKIFK0rWk3xNc=;
	b=Vvxmfj+PI/vtzt8BanVb7AEExP4kpLqEg991ZKvvYbPJ5WpVpf/jBH/p70F0Im/yfur2Ns
	KpqlzoMyg5nPUE4XzInPrOG+gYkQmqJgczecXroYhx8vbFk62BusijK4sYsEmfw0+k03Dn
	AJmwl01NcMSyHldTlEjBLzFH587ploo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ifZu7rvK;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942850;
	b=5Fym52Vfs+SYa4jGubeJqR+Yf5hu8/7KWqUmzlNp/0bbG83UUE15R3/fP/WoxSwVvvS2SN
	P5ePFyeAn09lp/7KU30Y79qBd3EKe8w7OmzE7ZC7Z1EKKPwdjk9haNWKa/HfZb5j25/V03
	MCHdvY5u/9bV0ZgHiAmCxAYDBI+UFM8=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4799b3f7c83so2335030f8f.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942849; x=1784547649; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O/6B9YNSHoy7N6JoeH5/zIRc86w/yJtKIFK0rWk3xNc=;
        b=ifZu7rvKG0u26VT+JFtQTKwfy/iAhhPysK7LXwQftTEU3sCduDl9yiLmLT95vASWyL
         RtszlbJ6Iw5cLyIJyBRsX0vl4U+FG5J3nHF3jvV8cxHV+H15YesBDxacVeLlx3qEuAqr
         oOrW+sP+8FXriNxUxgqjK0hlF8R46gLU5G9TgUqlL/9DIgBSRtXMyyytl54gLYb3qHXi
         C1kxABjg/KA89a9fIxjCzP2GIYJusr0C5+kKmSeKvu/7FS0n/kYbBmN70CXvBaspVFDe
         FMBdSe7tu5kl+lOdqjVXNsit/bB3egFzYZbEm6uIQmPpVcq/P6nChhMaSgmvGjMRQWQy
         c9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942849; x=1784547649;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O/6B9YNSHoy7N6JoeH5/zIRc86w/yJtKIFK0rWk3xNc=;
        b=DuQUYtEGRgIemKskr24WkTs7QWh4sgmZW++Rf8vyD6oV5tQOObgdFg0PoETKReLTzq
         kvABNCLqvKTfYLIhSlew+c4C4/dQ3aCsqyopHpLoFPtN9fRE67NLVGvKbI4H6jQK7eqn
         CCmhZVGerTyV2iOYQok/J0eISlHUgcwmqrdaks0SpBNuxlzdb7xhN6b8Rr/QvLEXFwqY
         CRbabVEHLPXCp1mry3KWRnamXxvALSr4TAy6FXnDU0SNwBdbt1ZSYAAHUcS7mZXcTJkF
         g3lNV2GKVFMRDFoW0TehCOzZT6ujRe0v5Nl3cL4xMehBKGsRxc+tha/O5yrxrJ95rJFg
         hQhg==
X-Forwarded-Encrypted: i=1; AHgh+RroRyZzBtq9PAdw5V7KfcfBZeEhlrpqb4E/tNa4M6KMBGeYOFnMAOREtcXZ6ixNRDFlmGO6uAfV0A==@kvack.org
X-Gm-Message-State: AOJu0Yyk9timeQwu4Uz5LG9fXdpoKh/H65nqj3Vr8pKH+OGEvkN1/Kk2
	thUc+sS9Qdm66f0BVKUL7G0sIYNso/Ik87m0ozjcbob9gPzrNnbJUpeHymTN3Lypk5E=
X-Gm-Gg: AfdE7cmigO8BJ+7lJd3lsp05kSTD6JpUTh6lRzBzfgS9eGgle1BaZaMw2mb43tIHbzC
	YVaHewuRnJsEwY889Ft+1hyPFtDW3Qfh/EoJj5bPOf/BbcBvR5iQZOR6N4xEWwCafdkrVNgjRt/
	bpBAmvYAFHaZBJ2LyJzVHwThi6sKAlpybYdhwjjqVZgDN2C12DNbxn7d4FNRbryqHJc5n+B/rP4
	t4mvt+Uj1MBlgMkCLkPvNvi8xT+V/Kws86vjhUtMoNed9VIeFJDTct6G8B+7nL4S9/XKBQRRqpM
	yGXYM/NZtE4+bBE3zEZV7oSZroQIZjdb/R9mBvj+WEjfzGmYIbKkjHCUF2IkUO5NR03nrZfvcqY
	NGDtVBYBPj+AK7TwxHzGPPP7cyXtH255reDzPv7IuVvzXNIyVbbKPhVACxULXtYmsn1CXxPCMdr
	FJ6+czUskIX9y0VjL4jHh4
X-Received: by 2002:a5d:59c9:0:b0:472:edc7:b4c9 with SMTP id ffacd0b85a97d-47f2dce91aemr9957535f8f.38.1783942849218;
        Mon, 13 Jul 2026 04:40:49 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d6da9sm85394652f8f.12.2026.07.13.04.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:40:48 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:40:47 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: drop unused cpu argument from
 flush_nmi_stats
Message-ID: <20260713114047.GJ276793@cmpxchg.org>
References: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713090010.2991906-1-guopeng.zhang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7ADB0C0007
X-Stat-Signature: y6jeuowpe5quo8zsu4q6gqmjqeegsebp
X-HE-Tag: 1783942850-564940
X-HE-Meta: U2FsdGVkX1/nxkZoKxDGtS434URTryQh7I5acJQC9iKlupWrxJL9sUJUOg/E2xWCL+NzEM61BArWPDnl8vvoiZCO/mS2TTp/m8zN5Zus2dIhR3lIgvIPhbyryro5Sbe8sIG3yNQoODZvWdlpD+vyKH0ckJV4Y19C9GqmRkHkV44gXvqnCM+oDreppv26/Mwesfr64ufstNA0ygGM4xxo2FrA1j9mHo5MtvRNo2rw4pGHZmqcIC1g4zQOVDE9+5llBSSTHTHDptMFWflF387kiwC9w/S1eKB7SWCMzwPRq4l1hlazpSoC673htR7g0domyTrvMqnKSmcQieUyhqrnrrN7IhZxJnzgco9/uprDpas6G8Hn4f3FqnqYbJu07cN7mGtsN2271/eDMTF9xdh6+CD2OElheGDKu8zc21qFcHCxnmSQKXVdQhg2f9eZuP2MI4lLZtmzHm8doZ1+xSGp8it4zjTYvJM9TcKgg9EZ+lEs3TLh5X883wm2HwdcUwQcJdXcJzf+EXRA84/eSAtY3EeFJoIPQAw9DbjPpjJKosfGQHZAQ2+E5MHW6L+Af1MtssY/Ty7diLMFZGI9glSzv8YX6BXRwdFY6y8NKUbixqfK4WAJoid9bDoZXnEn21ea2gx5Q+OlsCZs8MKTLInFqDKYCTJTJUfHiKtooPlPtomoHRnalMASPpeid5MF1tgADzRAYMhWrNJvstgyp8rHrUhf4R8wNYgz0vLEA2Alr7mX/sR0gZ0UnbGx1USuizxNHsc9I8stL7vjFBIQl9UzmkZEdCkStMa9zx3XZT3w+rrYxv8bjPkM1Tx10evk7im/0ZBFGspCbzL2FqLZCIteEaXe7mcPIQtviRZ4bzSMSU4/nFlJb83YJoKDpzC8nyTXmkt5PAeCl2S/lfMzAYZHQpnhCQipimlweNxazkzgOUB3ZWdiNDGB8eyNK0pLlkWQ/4dpazNu+KfQgDVic6N
 VvdyGl3C
 2KWgho2AKRRYDNYPSQV0q3mFgPv6mFd9nE1wXqfIEY/qH5F63eMY5ZOU//UlvoGKJPDx3ZyCNZ5XRET/tHVsWbvSiaJ2ZUutStOQdMSvRzW2nmbW5LKd6WjbPqrTaA3u44M9ONtSgiDuNBl6fOrgCaSF3e+RoE0wElzzLNfy7KJmHk53Ufmq7ta/fkCQ+9kfaLAsG8Ml1tBPAtallsVqWK3Ee4FEqP/cpWQlV6PBkXH9N0+TgtFySQbSokOvLtdkUIkKUvYhsPgYD3ahp4zG3VETATM33LgcJHQal5yFyttJWWB+auHBwgv20h8zzkQvdwAqTDeCXfcg0zzxJDk0I1WyhmSJgvUdMAc5xxNMI4q/BKfYSb3P9hhChL+0djbw8VHO2UBUcF1as0FzrhFWUrNjXCJ5LlkZ5DL0oZE1UaQZkz3Ojmx3t5erSmr+7coUl+Qz3mCG0llad90Esg/Wc8hjmNmM+NHCF3YKZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 05:00:10PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() does not use its cpu argument. Remove it from the
> function and its !CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC stub. The
> caller still uses cpu for the subsequent per-CPU rstat flush.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

