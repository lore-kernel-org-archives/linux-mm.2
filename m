Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533C9FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85A976B008A; Mon, 27 Apr 2026 06:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831A36B008C; Mon, 27 Apr 2026 06:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747F16B0092; Mon, 27 Apr 2026 06:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64B1D6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:19:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04B161C0031
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:19:06 +0000 (UTC)
X-FDA: 84703937934.15.62DA392
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4AC9E4000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:19:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rkPI5fPe;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777285145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fuu95ndJ+xUF2lXaCrOhMt8fKj+tvVnbdiI5gOgN5s=;
	b=DS/3Wqh0y8uq8vsiONkhdypWrehgc8drB+8LHYVn/fz+jj4bBaDN0w5x40a/CWuO0MTC8v
	l6ZVoYwte8ZwWGbVvwJqAgcjOt4WYTBoP3Do1klnryZ445Dh83kyXhZa+5iZt5bmaCoasF
	qISxfEOdOsC+I0aJiPiiwedVRpN+XDw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rkPI5fPe;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777285145; a=rsa-sha256;
	cv=none;
	b=L/lIm7ohpj4/NBvc3EYa8QAUh9XyW73AOYn0H4AuNepPhHOnL4zfSQEgtANIsjAQjfKP6u
	4+bVAxr94ArwcuVui2/U3mgdbVCm64cJ7pPA8G5VZvB2SQ/l6EvlVXXNnZ4vnrviiYPImd
	fqG6Hle4305VCft3e2CzQlCjdrAm65A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F5F560138;
	Mon, 27 Apr 2026 10:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1484FC2BCB4;
	Mon, 27 Apr 2026 10:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285144;
	bh=DSzvsfJ3WfLZpO8yCaBWIdjudc8BN3vcoj724E+Ga4M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rkPI5fPeqLKTFnK3bRLHUS0I2bXexbwl2ZYgydHyUgY0zigqm5W4UAZRSnD/DqZGs
	 aBPg5hzby2v+0/h/n0Bfq3oOWWoHkEe6e9RkAECNEBtLPqeSgs5HRPPb3a81UpAi/0
	 QFJWhp1t/bfn4M4usHIceZlr1fHlWb02IY+5hTXOt1ZFEB1EVu6LyG/EqyFmiZjgoI
	 Z8a+e1jUOSaEB4jlsgGNcdmVFze/o3+4wZu01wHsW2SJGouXVjDmT+FvXogZ7fz5Xv
	 QGhBhimXjOmvnat0bR3M8CQM8gXQiawMa3WA7QTuR0C4K4skxsmfDxB30Cn125Eawg
	 i/ffKlVcXb1fg==
Message-ID: <8c9069b0-6668-43fd-ace0-c707d7aff082@kernel.org>
Date: Mon, 27 Apr 2026 12:18:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix spinlock leak in
 migrate_vma_insert_huge_pmd_page
To: Sunny Patel <nueralspacetech@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260425133537.17463-1-nueralspacetech@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260425133537.17463-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sciixybdrq8xixbr8gzmz8dmapz3qkmg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4AC9E4000E
X-Rspam-User: 
X-HE-Tag: 1777285145-505239
X-HE-Meta: U2FsdGVkX1/PK/nPDCQU1m4oUvqhP4nT0zqiwYcykzpN3BmjEwHNjGfLPnxB5jMK1SAA3MtTHkdfyw8aNWIrvZvgWyFyAWgxgqWUNl5J/u0fWY8c2cVvK6D0wH+xlBfK6B+lSrE3hBvkc3bkAKALbhM6vJ2MGG/FA0ESpYAd2klx+OHhc+ZyoUin8CyPifj6sxpefYnn7jjl0i0EXkbRkwecvWGqii2OT+t4cJNnYvxs3NwhAJSCu6bz2c+YmWpUEaBUlVsAx+DiBTPr0kqIeincq5WEsPcNHHxY88gEuY3WuCJkpB02qT3ppvkg7Kcw44tFmBBJVa3dy/Yg8QGOQ2atWJHyRV32n/YKYFOm1cW5CbkrKY1BCeThtwM2xxvpL1RtD7rzWHiMrqQ5cNk0rBl/9rnufZwpIxhci+FC14wEt2VKKkR6MLyO2xLjEmQo13i+EjRai2gwc+iVT7PPmNB90J5m2+aWheSE7f2Nm8OxdYfIZcU+nHlKs3O6LMk7eyjDlh1t/IFfFz9J4CjxTfFrJ+GdWYYARFN4a6bIzUxkzyEvD/JPsvKcfL8FnnsehYWyPt5+tnlJ/4OkEWI1Ds55jdV318Tew+/FJq0YEwFcfgul9e53abCnLOjzDk5IES6Mv4eqdbfLKq+xw1+ySNacIZQdEEaPjdunKVkRhwUiLMtJeL/uxf3HN5F9kBBPpzcjMrr9ZuXWC04nPHezGEM/piKeYyrNa9GZhu/rry403vsSGDjTyI42PuARaL9T4o+6vBovL2ifZPvgkLHZW2hji7cn2rBOvAOO01/OisbVCHxjSdS4WAsUnp3bcU28A3G+84ZQxjt07sgbtCuR1SDtOsJ3GiLvX914ueaRTdbdQq1+Zi6FV8MU85jg9R1+mThVpqswlUtVpeNrhxyj6fj98myIuv4j+bgvZqRmncFNX+7RG5W+nHS3AinN6BGZVwea8Qme1tanY2/ZT1P
 z/wZMp1P
 nhimGQM3yQYdicOqomQS+Beq+7Mv29DLQ8m1sGx9rNGL8Qa34OPceYGIHFnayU4F3pmEc39kO/KVSy3wGIplNBRhW3hzsxUoNTH18rphLq7qk+eJzTXPJOmS5IDRM3XZMKQOmJZC461rVk0DKAOND/iJhcFJOxy1gB6rouKIuXLMeuybhHmQf9vK6hRcImt+VIdfD6wtiZ/vqPqJQqTRh/RTfl23hTCGMFPVpT0pJXAFcx/JYaAJ+ZN+NHNHeA1OBratwsAXnGXZpETAelisYZ3yX/swsRVHgby/sgZO9zA/cDfc8XXEzV5okRRlpjzzd05DkShQJXz4iHLol4/WdB9wh5Hayk+sYgb5zjkoAWaOf/IQJumsoPR9JDoYJdOhgNXxsA9AM49CQqCDBET7MgVpOlQxYCcoKMi5g2a9X75g7Z0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/25/26 15:35, Sunny Patel wrote:
> When check_stable_address_space() fails after the PMD spinlock has
> been acquired via pmd_lock(), the code jumps directly to the abort
> label, bypassing the spin_unlock() call in unlock_abort. This causes
> the PMD spinlock to be permanently held, leading to a deadlock.
> 
> Change the goto target from abort to unlock_abort to ensure the
> spinlock is always released on this error path.
> 
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

