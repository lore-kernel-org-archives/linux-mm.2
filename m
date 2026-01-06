Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2247CEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 17:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76536B008A; Tue,  6 Jan 2026 12:28:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E1A6B0092; Tue,  6 Jan 2026 12:28:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C841F6B0093; Tue,  6 Jan 2026 12:28:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B97E46B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:28:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 580AF1BA75
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:28:40 +0000 (UTC)
X-FDA: 84302223600.07.5881E06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A892C1C0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:28:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qZhADq5g;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767720518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrbQP/A5J47h0JzlNcT42selTyAbdkSYBGiEqOgQrvI=;
	b=DSr205TMfZ7Tw6xodSGMt3oV9H6LFAIsW/j0tOMGCqX2V0m2uhKBkN+BJJENKvG1TD1FQ4
	CFMx6eo0W1j1h4o0BM5k9f4fdSmU6nLpYNLpiYKIR3kWBl+xx7Ti9PdNyaqB74RJWEDilh
	U/D6B3STBheDyb++X/2YvCrMKllzkvA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qZhADq5g;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767720518; a=rsa-sha256;
	cv=none;
	b=5Y+vTgGBICEQWg6wtiwC/jfM82G//I6uN/qI9kr4iOHBIVYmIoRGwW5/H0VN40LuhxKwH+
	c9FLiEVv+5R/IvCe5a+j/o1yBob/43+/LzvbMZEroF/g3yHgFO5QxnXAI1rcg9r+wsxTv/
	9tLgWFtVL75luL8IJmkqh+erXZqtj94=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD54460008;
	Tue,  6 Jan 2026 17:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32526C116C6;
	Tue,  6 Jan 2026 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767720517;
	bh=n2QELpvuHwzO67j1Aajbgcgc9n/M3r4muFo8o4BFDio=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qZhADq5gT8e6zKneBRvzHQo40ypuUgdr8IIXQ365O3bGWudmTF4Hafn99ma9XthAq
	 lxndbsRwhP3IwjLimOsvCl5aH5GIdsrXCKm7PGQeGVmkm/BMCxxbaJvOnS8twNnuCu
	 PwrIHjVu6jvJQbLzVqhf7anB8Vfu/Sx2u3r0TEfU=
Date: Tue, 6 Jan 2026 09:28:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter
 Xu <peterx@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/testing/selftests: fix gup_longterm for unknown
 fs
Message-Id: <20260106092836.d6a4fa77b755bd989d1521b9@linux-foundation.org>
In-Reply-To: <20260106154547.214907-1-lorenzo.stoakes@oracle.com>
References: <20260106154547.214907-1-lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A892C1C0005
X-Stat-Signature: f1cyx5twj3ofeikfnc3apytkd31qjtca
X-HE-Tag: 1767720518-912495
X-HE-Meta: U2FsdGVkX1/Mq1VTYoNyYGSv/70g73lVpmJY1jPC5ARyRw+7YOG3SS6pJpYOccgbiQafYpU791RgXO9jI6VuqeAUPVwUe88Lxd6GhIt9mjEkWX3guqOcPF5B16E4YQttg+DfcAbymezDq9O6U1sKbelXYZJrlz1xQqu2rzApu9V9Fs5ZH5OgFhrZ5fs/xijMRIOiAPG2p8cgBG0WLlOYvvE8FMIR04AuZgasCr1eHC1TARGUUItUBqBZIcXePHWcDzoAdk1CfJrBk8WZZaELC7fAV05BNKAYmJTZSw3mEEQDLcGTaTnuEnXf8U+nwLmTgrlC0bx0IONOm08ryx5b/KMj6qKrMyF7uyCYS3DkEwr8y69O6FUyTrpuDBNPBqKyoGsVI+rc7BFDwbrtZM0Hc7A6BVzu5bFUy1f63/ilMYxUSaEmRGoCLW0xYOw97VZQHscMtGn2x9E2Io2hyFYQPYXj+BgWl1v4/9s1CpfWc6ZnfmrdCZKs5DrWnTdxE3qurKRUM2aEAMjSgVgHQZ5feZJtAJ2cdyyDSQ4PLYK7pLEKR+KHWX9uUEw87SauZnSZ4AAuJpapn9oHWm7apw0zdXHGfptxKk4/hz3RKiNp5j3XRd/M3wqA0eElKXWSea2UH272wEtnGb62ZrH/otguVmZlQnKpw7bCU7YvtI0iO5W/mnzlRqpYfpmq1Sj9wmQxVA+O7ASI04a+KcW+zTauM3EE7kreQz7pdgS/jxHY56SSZgvvJufGkH3tMq3efyORtooFW06rjEKeSCFaj+gmsJ33IGU/eEzp+EyABS4UodWfbH1USDl8DAoRiH0DXdGw9FuirAbxDX7RpUYQB+pmPuXzaZrj6WiOdDjlee8yhMcl81bl9QpH/F5mWs8EoI9nLwYqMyFFjBINw+lT6m07wntx0pBH3woUpnWsrNr1peEWMBqmTClrWgRqjleULrtVDZ+7+QIg9aGcP2BLFgg
 XSJuDf5T
 sM/vulqVVrq4zgl36H8kTv5UQs3p6mvX31nh+UgM3Z2NBTAFR1tZNNxNCtdxX1t2u/LtnIHfd0bnghL8bBG39yZbT96NjxnXgRz2JzQ5i9Yynq3dAmOF+wnVcX5pUO6vw8syVQw2NVEDOC4INrWB9WiRzHQ6Pw+YmGMBbF3P87Jx49qTY3kKo/VQdkI9SvKBavZf2ITQJ24N6wcZC3Lc8mQEGLR9s/o1ccwEL8LoNRPa50b/0Ublmcn0Djbxgp1erk9Bolyw+PoNaq4cTq/XFJKpAmi2eJT7WhYozAEEuYM1w8ULhR1rOkO2ZTPWxX9c0HMHH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Jan 2026 15:45:47 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Commit 66bce7afbaca ("selftests/mm: fix test result reporting in
> gup_longterm") introduced a small bug causing unknown filesystems to always
> result in a test failure.
> 
> This is because do_test() was updated to use a common reporting path, but
> this case appears to have been missed.
> 
> This is problematic for e.g. virtme-ng which uses an overlayfs file system,
> causing gup_longterm to appear to fail each time due to a test count
> mismatch:
> 
> 	# Planned tests != run tests (50 != 46)
> 	# Totals: pass:24 fail:0 xfail:0 xpass:0 skip:22 error:0
> 
> The fix is to simply change the return into a break.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 66bce7afbaca ("selftests/mm: fix test result reporting in gup_longterm")

-stable users might want this?

