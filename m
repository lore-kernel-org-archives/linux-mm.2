Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83139606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yl5LJAvU
Received: by kanga.kvack.org (Postfix)
	id 6844E6B05B3; Sun,  8 Nov 2026 20:16:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6357F6B05B4; Sun,  8 Nov 2026 20:16:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B986B05B5; Sun,  8 Nov 2026 20:16:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2782A6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:16:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BA68A0521
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:16:07 +0000 (UTC)
X-FDA: 85413814374.28.A3B2C18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A86C160005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:16:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yl5LJAvU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794186966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxDhrEIYZttgbFY7pnbXOVDKWaxrd78v0tNIwPh5P5U=;
	b=ZZ2qutM24U4Fn+zBawDmKYdSgEDCzQRUAoi7syJ5/ZFSWEIuzCvujdhe6vp7B97OcaZc7T
	D+nPglbIHhFiFFRGKKJObszpH6TCgtZNawPTpaN2Ebv+lUbh9sOvpQ8lCkyp2xZwKwH1Ps
	rQp5kRFp742VVvMWAbBCl5P1vfVphMg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yl5LJAvU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794186966;
	b=29M+gyORPiLKZ8KlL+8xF626kayd+PWTZsXyIAKhs/ksHUeQ/9Jjj9mQV+xiajdccvtm1P
	KguIaB/X7vgWSYTCsk8XMPXW9Vs7U1PnQowLoh10C5UBjHjbK9lFkR0/tWycV9kUH8zvQH
	ov7rIPNvfB8cxapQ/KkXzsW8+7Y3nik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 710DE60D58;
	Mon,  9 Nov 2026 01:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBC51F0089F;
	Mon,  9 Nov 2026 01:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794186965;
	bh=xxDhrEIYZttgbFY7pnbXOVDKWaxrd78v0tNIwPh5P5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yl5LJAvUU+oWPByuTAm4vJ/x1vXc8vFn6kh7xTrrVz/NwSNIYbfncKf5zO1ZnsctW
	 rbyCz5/C9QBweG4a6jhnx2GJgNnLkr7i5927R0jWo8KkEMrhaLT0ovPigvB99ZEpkw
	 R2tMsYRywFEN+MFB3kCgrQ+dAbmdG8nGVYB/Zf1RNm5qWNoH6xTN6HJr0ZhbsZTEVS
	 vrdkA/wD+fswvNrrJ0ROc+CCHSEmbv8dTzBPwIUbbBRYJtCV9E+73Ud/f17ygjjfya
	 HPUl5/nlPEa/uLYV6yEpD2F7fkw2/IG66aF1qXmcxT2nM0/BM+V4zlMRGV/V6l39u9
	 CrFBfRBAC0vtg==
From: SJ Park <sj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [RFC PATCH 6.12.y 3/5] mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
Date: Sun,  8 Nov 2026 17:15:56 -0800
Message-ID: <20261109011557.92525-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026-11-08-1-daily-reply-0009-damon-6-12-psi@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0A86C160005
X-Stat-Signature: wiq631bzi17grkppxbb36xrcjmxos8r4
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794186965-245769
X-HE-Meta: U2FsdGVkX1+TGp1T51WA9MvA2X/uzbQBn9XtFwL1UpI6pNdLSLou4MpO444ab/cOTzL38EcJFhUgP0EYWwIW5hTI05VV+SyjIOsLwBZf8WARFoKC0IzxuOO2gzU7TVUW23Ykl1adlmJjjZGhpc/sh5eOARtXHqblhSMZcCObik+sQ4sCaupSruHEuinAGSJa1AOFikH3UF+d9aB3QQ9YrwWSc6PNDCOC78fuwcRLVbLzNJ5U1D3DE4ArZRIFrhebF9IP1PUKSfOn47pZxIjASwSYY1k5D+V5KHUfZXPX30UWzqVTb26+U47eonpMqFuwBU11yrM5P+VL7oFdW8RdLZiJrhddPlfDoRzSnxQbyBb6nVHBYLrQxY/qjkr7/PhDXLHjtpjiNFLyfHEaChy4eYUr2YsidgQemGJBGhqj92GsDAB1Pctg3F8m0WvA7x3AhSFM2Pu6fDSZxAJHaS7k/gHajnPX4hSxv+eZhJRm9jovH35R0O7uHPwH+FcMbXxyxmdkJ35bKoUQYTh8ttrZeunQYCbydRJ38TFJGi06oRKrIzo1hVh+FI0pn8A6ZPOWon2THk6BfcdYVXeiKFvgO/gT+Z2G7SqKGXGGSehOOn5P4LR0FbOkqyuR2zf45RCiH38RHkGmGi+Svhp6d2mak6PBs0outaMkwN9HqiEAwLwEqPXThSN/Dp01dPs9uocmAH21ugS2agC+frcIUAscV6XH290lHcYphzLUivQ2NMW4K+p2Dx69uf6q7UmDCrm24O+HkFj7cMYExFrxXLQJyZ1+kDsmiYe6SS5XLNOyb77k3cNZ0vF3MA4GuKyrCe1q3tWyiGSsrWucNjdFnGizA4k/tyb0jVdwQxP8HFpz2fm8PigNTGt6crHFGAFAedd+5fKYPPbZmPYJM8DmXyAYRcvkydbPF8HquMdOhEsJ9VApIbZmN0v+wL6gAWazgaciEr3zECf4YGuK4EbjSBF
 64qtBIym
 T4Pr1RPQDzF5kOupMjd4RbRRL2IYsbKBvCEj2i9CHeWt36xgd4dz3SoTM8Kwfe32CuOH/oQbgF+JGJKUe66wuJKhEJqMZKc7Nz/DUm06cMV3JJg8p39dCWPdtfahw5WqJpNJsQT9rlPEum0IPu0N13iMtDm9ICIkz6aQSuacZYRnwSOZusbs5SjGGkimXO2d7IG3fMWpmZDpmYNXb3WcrDum1L0i24eEZaz4p1xA1DAi0EQsE4UFqoL0g0jVWkBuLe/MjGFw3jboL8zHXkbL9p5ffNBGwaZ0rFZU9LFHaZ7VsiNy0AT15KB5I/GlVwX9gD6LwXKyKK+g1JNwMRH4Mx/hyvWViRgsxzKMs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun,  8 Nov 2026 19:34:37 -0500 Sasha Levin <sashal@kernel.org> wrote:

> > When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
> > delta for the feedback loop is calculated using
> > damos_quota_goal->last_psi_total.
> 
> Patches 1, 2, 4 and 5 are queued for 6.12.
> 
> This one doesn't apply: 610c4438fb66 ("mm/damon/core: error
> damos_commit_quota_goal() for zero target_value") is queued for 6.12 and made
> damos_commit_quota_goal() return int, so the `return 0;` has to be kept. Please
> rebase it on the queue and resend.

Thank you, Sasha.  I just rebased and posted [1] this one as another thread.

[1] https://lore.kernel.org/20261109011347.92467-1-sj@kernel.org


Thanks,
SJ

[...]

