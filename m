Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8FA606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Hpn6pxh8
Received: by kanga.kvack.org (Postfix)
	id 1DCFD6B05BF; Mon, 23 Nov 2026 07:02:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186E06B05C0; Mon, 23 Nov 2026 07:02:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075A46B05C1; Mon, 23 Nov 2026 07:02:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAF206B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:02:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7004C8084F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:02:25 +0000 (UTC)
X-FDA: 85466246250.23.160B4E3
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 966E5C000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:02:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Hpn6pxh8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435343;
	b=5CpZvtrsPvJUtXjIUANSX+Rps0ouh4PwEsYBoCGKjpSezfUH80ODbJLiAmLjXZpgFdjfa/
	QTZDw+7GBypqTPIr3zMuIdRkprEHPKHTJod55k6QIFfUUocsce36VQkEl0oswdsYfv5y8y
	GBFCLGVqCiyaZnseg9NXV6UrAntXwL0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AN07mvctlxPGmEspqmzDlAE946Nit6fqjtUvEUULyM0=;
	b=nZd8BvNQ/Et1BgNfiWfCAus1IynDvBy2+D4dwdzigGydyyTK+3lG0NE0Um+Ml2qGzQq7+o
	njGUULgSuDin34Tij7bBUPgGM0UM+/8isjh4KZw08Zp9DsYNOscJnb0NzOufiL5liEPoNk
	89IQHR1AtyG33DrOqMWgp3RGz/Ad5Ds=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Hpn6pxh8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-385d8a00598so4367261eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435342; x=1796040142; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AN07mvctlxPGmEspqmzDlAE946Nit6fqjtUvEUULyM0=;
        b=Hpn6pxh8TDGiDyvRqH5irNjqjZF/ziIAvq+W/7b0n2CCICkMaa+TGB9+BIka1xCmfF
         6RDi/ydXADDxZhoQa5duNZRZzCtYN9qLJkqoXYsKqsCor5EBcEazckuNp7mIf1kDF4Bt
         QQpxA46zOf7UeapClvwXomi/i9R2Xclf6dG/L3UJjibngWdRo1ZeiO8YO1mWCgQi35RI
         sHdGhaxySfKiFCZFwZSlnt5JTp0ONK6eqHyXU5Mz0wTveoIC9MyYdf79Blq/3xSUaYt5
         5JZMdwxcXwx20tGeh/s1CTtdrCK8n4OIS3b49gIlZ8P2TaBdZhf9F1gQkMsbS7a0stAZ
         aiiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435342; x=1796040142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AN07mvctlxPGmEspqmzDlAE946Nit6fqjtUvEUULyM0=;
        b=zkn/fM4kA6ZkZ8rVXrlCIxtzgDpUzdO1YGx/v98TYnO00QR/gF4WtXR70gakz209hN
         hEhDehdgJbqmd1r6A2WU9M6qhdeoHQWsPTNlhbkcDFHakiTBaXANNbeUTbu4RiUN1PKD
         5u9tFXVHU4CmxqEwcYMokJFIhF4pRMeyPSj8WJGRH+TBqyHDiRDApEP8Bp2/kCowI7wP
         P2zbYeyOgWZwNxqrkE1eL9DAwPKeZdGZ/s/pRWWGZ2hcZCnDSM/1mKJdWECX6EqzZqQ0
         zdC0ZCcornuM1zPTNpUY5SGIjZ+/4Rck3MF0cYLDdtdtYfvyJdozrKBe0h4sblLCfdy3
         BzDQ==
X-Forwarded-Encrypted: i=1; AL+hErGpnE6mduEJmr8lXZvMoSAVaYMqZWE0MsHVxDjaqat6AxRs1BrAL3LM5NeZzh7PTKQNM2vGnOdAqw==@kvack.org
X-Gm-Message-State: APuU4Z88Smc4vS8J2axBd7vftgImuX/haWXMZUkuOiPZYKSPb0KM+azK
	o17684fRKjcjXPv0r/adidj62GoHNtGU5gTB0mZKVxmS5sLpJS+whYW/
X-Gm-Gg: AZFdTZeKbkApCjvRk3tE9bEhIKLQ++eBhJzdJqI+yNT06Qo/mfU5DT/VqYdLVXUbI5M
	C0+i9RjUu5PHShhze6RdYmk8WZ8VqsaB9v9F3wJH2i4BIjrlS4Jdyi1IIKvU3rVQmjKNuZAtTRj
	44l0pPVqU96sAVaZtDzyIPv43fi5A93ArJaDw6VgllWfXSZ2tvuiZ3hqzHhJ7PmhqfJuR64cPxf
	lNnvf/M1jLjSdDGwz8J/Xw568Op1J3Q72nopr/lId8YcCKJYkknJIFQVH/5P0Ta1pB4lORKNL2L
	3AyAF0/9oglZaN1/frJ5lAJ8zvaF44DA6lYoqKfc2R2xbGvft/g0BU5Tl2f6e+oikvjuC/OU2qm
	hG5w08knl4kI6KFqX4/31tYUPgn5SRtu8SbgYT9/Ih4MpO9YAMwk01uAPgWyNFABjsvjGnlK5zo
	BRx9HDSccGKnyqiaVrtR7wjVSGIn/o0l24ONsX346+u9Gm3Q+9nS4KMYVfRXuVqJ7b/gxB186Jn
	0+3GjVx1mo1rRc4oSYXB0TEe2h5PcLZB6WkabzPKo9P7waUEWvuxrZ+dLOguqhsodawM3gO1Jw9
	VBba3STJIhn84qCrbrp9GSXzdC7qkO7lqk2W993224YyUCtqSeQQMJ66NwUnHbfYciLB
X-Received: by 2002:a05:7023:e41:10b0:1b5:43f6:74ee with SMTP id a92af1059eb24-1b5567c1250mr10247759c88.1.1795435342118;
        Mon, 23 Nov 2026 04:02:22 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556829d31sm45356071c88.9.2026.11.23.04.02.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 04:02:21 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 19/27] Docs/ABI/damon: update for REPORT_MADE probe filter
Date: Mon, 23 Nov 2026 20:02:07 +0800
Message-ID: <20261123120214.9330-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-20-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-20-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 966E5C000E
X-Stat-Signature: jdbo9xhoisy86g9dx4a8f3rkqny5hkg9
X-HE-Tag: 1795435343-727151
X-HE-Meta: U2FsdGVkX1+6ukc/S5uDppvACaDPN6GjgFXM34oQeKETcZUUkEiQhSIyz9JTus32PelcKB2WzaVF/p73Za7dnUepa9pwvXAjA9FTmu++1Ojgn4HmZJ5Pv7rki3UoYcvXaQ/GdXtZw+hjmfb/3WrD9Ch8J/jfWruEOLxGdwT99L10VknYKjxkWdWRyA6M8m1cCTOKXjrM1btGiAIQf09EItNwZvXYP4eglyGb7LtHWrlFvjHqJ3r1HnoNuWta1dhz0ZIcWlbVlnoiDT7lDIWzupFG1jpnxhZEcCiPM3GoNDabYAcWEsF0D96X1D9+oLRudUrVmOVJyINAKVGPuqiuOT91g0hWDZCeUrFk4RAEzkcAiJzckl0XKPmW4CR8B41cTWyiFZDk69dv+MUd6pDJAGHpQha8Dg4lLp895XPgMdZNLa4RNgPnK5zTgP//ksg71mEXVeVWSLwuNVSMKP+uCFaV6Z41g6TTN2USFwn1Q0lu7n2c/Y5h6ZB+jM2rKGIg3owF0Pg3gQkXTOelFmdALnHwUmH3HYw27agU2CI288gfXIK++Q4DFWieiCngRv990K6+vwr+wwghbmWmg89wf9cE07QOlAcIPlwB1Ai1/VP+Nk6rJVofnr6UmzE4va8bMNEWqhhl9MppqI1xeoza+kv8lVBJ57+76h/bYSsVopAE3GppN5YZA2GA8+ndmWCNQ57DUSF+MbWlu9Ovw4LaXz9onN03Juhgm7Mtw0Wm+NzMG47Lynv6MlxVDNwXtb6hNwVIZ+y73QGj3PruiOmdaC01Gs+x7gEVZsUwTJM+c5gFyHF6r87Nb5+LgJEvehWfygCMckXPMANpn9LPCqoxjjA+TGxs+LFI+JnEZ2HsZdTkp6q+6h+Bu4LVYvhYVOfrSL5dyng0Uxut5Of0gAVeznTvpGq5vM7gBwwT0X7icOcYaasQ2e0wPL1tt1U3AOt12y+7nM5lWJLm3vBYnIZ
 ON+PxY3c
 6l9df7iIsutrBFuciZDKNtOV5CzOk/WN5SVkaHKRC1uX24o0CyGN3FV3S9I85++qjUMcry8rEa7usuNp/OQSYK3rlRKu0ZnV6y5Nnt5zGMwr4oPqwwl106SBH1P9fv5G7mNHLl5VdsZk6hZPHC4D1PylhBJdT2otzH6GcXJMmlVBrGfk6ZAoPo9EHYj+GROz/5ayrYLJXK4B3xZXs3QKYwMDyujrwIL1bVWP7AdQfbSpZmccXqyufOV0S0wz6kwcg6UvQX64L7pfs6FUrxMb9txUqcJG1Pc1v9GfBLSNMrWWjNycF7W/ac/H0j2GF/OLJOrsWT6dkP9Mk8mF454yOVIJGglYFGmlRHHyHfYXRT/T2nXsX/M/t4hmGtcmd7Vse5FhTNzdiynQnODQhIOig4cBreSwA6+dh0wkIhGxR1Q5X59sVaoZK9U1CTk4V7KDpn+7s/RAxlZByGGrazwxTR86DKSOBqzuHqomfIjFNZ0Bd+PmCMR982z7+5S8PXlx1H46+zhEtyFLOQSSADQci1T2QCKsJYecMFqjUSD0qMwKpdnlVhxt9PLWWam9KMNRhIYkfsEP2yK8nvi+ktEsAYbiOVKKW66KIPy8joE0qFHfnIA468K0b9bBX9vnGr9Sv7Lud1KrXprBO3CEN/sKyM8nI5g+P+Yrgst0dcaX5ZDc1GhX8fxktpdkRd0vGCNwTTQ2ssV7k2BhxkYSvLHUPpc3UfbIh0Q2Sbo6Afcs1GFTOL0PmVSqdOBBa0T+6MAMV9i3DsIW7euYISh20sMh3ob+ACfjdNFOcgC7F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 13:00:03 -0800 SJ Park <sj@kernel.org> wrote:

> Update DAMON ABI document for the newly added REPORT_MADE type probe
> filter support.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

