Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD8D6CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DFA6B03CB; Mon,  1 Jun 2026 10:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23EA46B03CD; Mon,  1 Jun 2026 10:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153F76B03CE; Mon,  1 Jun 2026 10:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04C066B03CB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:28:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7C8D90EAF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:28:15 +0000 (UTC)
X-FDA: 84831573750.27.D2AFA32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A25020011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:28:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mlOKopaJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OLRhnatnK7tdv0pe9AybKgTFqBAbVUiK1/01rd5ffk=;
	b=L7BG5k85pU+Yn4pv2v9qx+32WVgXIyIq+yVGI9hNOmcNIb+G2bEG3k5UDMolEluryi7Fh1
	QEBsa93ajbijUFLbYcgucnn4jcHFDerTkn7VMLDbL7jTrmtvr2kaxdEAkvKakzI+0znD+x
	k5QDNHGcFWyax21jacWKF9GpN2D/wgE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mlOKopaJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324094; a=rsa-sha256;
	cv=none;
	b=IjcXCycg9+XvZ2hkzn2L99/AQed16koZLSNbm+WT4DsveC8XZvRHlkiRBW4S3aAEdO2tBm
	DAu4YNstLiY/qg0uUopasssXfjYxvDDPSZZqe4mMTfbWIlm9AjAABBG4JkSJRTpUEavHFu
	h9qxcogjUBopH9OjU4Opm1SY3mrhYN4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B40D1601E0;
	Mon,  1 Jun 2026 14:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14C31F00893;
	Mon,  1 Jun 2026 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780324093;
	bh=3OLRhnatnK7tdv0pe9AybKgTFqBAbVUiK1/01rd5ffk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlOKopaJwZrsEmH007+4VQ5cd0S0KeDv82LVgOMZQVobyb8WDoFT15krOPiRD0FG2
	 dbpUWcP6Hwa/kT+rY2HzXjDMC7XwDWi3vdIge2IonOiDJT3yrIs56TquV1QmqrjWYw
	 F/DaM9/UfP3f+/HVoQApbVZKHopIBhfQux6o+1qDz+rbLjh8he1iDp2QA/7ZqoXx1p
	 Msb/8/+Wwkr87ynTGDyZn71BY5aq0mhWVs/kSeSLD1d5yZS7z6rKWDljdsE54Q2Ywt
	 lEf/HuusMPdgh9Aqp5AMTU3VKLR60fPuNaumCPqx+jukcLLKcFnl1WNXHTFFD4WRck
	 japyYGDDlZUOw==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH v2 0/3] selftests/damon: misc fixes for test bugs
Date: Mon,  1 Jun 2026 07:28:01 -0700
Message-ID: <20260601142802.111592-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601032314.424013-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A25020011
X-Stat-Signature: nmcqhxj1kdf3dajbubiy74nj5xmwr1md
X-Rspam-User: 
X-HE-Tag: 1780324094-4391
X-HE-Meta: U2FsdGVkX1/LW3j77pDeLR3oAtrH+KPQ/L4aQb8cIbabrFmnRK/L2rrOffM1pbwxcJR0sQuQtzdptXlHjTcbOWMTFpmWWpo+UtWzKk9hvaFTutbjtGcvrPaUUFJZ+bplRbKM4PN+zUVMD/XtVaPwoalrpIIDL56SlNh7+8IeqIwXaGaIGAIX+i7MEi7j+rZ1cpYSNOrwFVtWY3H+XpXhDHC3HZJU2IEgwPPeMaZkFPlP8o7cnUkBtyYArcW/XKMKda3mFqQuutDOO+vfYrZcxa5hvNA3skRb+HUm9rqFvjWmVc645PZvWI+n/qHS0i/9AoE4GPZ8AcKv0AEn8ThrRyJ7EefW1qLz5675ApmAltKFRpEjmJb9lFjn2m6F24FGHXeNxQT4L6epBHmdtuHzw34FOA6VrPLz0Ef/fPNa1o+KywvfcWWx/T62/eThO9stlX+ie5yy0UVPYBhen1mvW6tMarpxRJuIzNLpa8vTfdeecEIEo9eIzQou+vyM9DFJrGisc1dIN2TpILAcZ6LVhH77pPQoIgq3oBotpLwn1MaOCTG8ck/GQ6J1YrjZLLVz5fx54GuuvBR0BnfJ52RmWDwclHX/Fd62Ypr6Vc+q/1k9gtOZ2jFQnIqTwNU0uvuEBF7beTmlRSxPm2e7mns+sMkhvr+ok7OuVqgEBPRKuk7sNsmjTW9In3IaBbgrF84DR26Kn5sMRLVrt1fkSq4rQvoIQGOs4Ls9q6hJKmebuBkVCN9xOnOO6tZV5luKoaz/WSKk9sKpBfiOOH6ik0DyaDOPPEeyuJJ1/p2CPrDhCNa+gA00ukUsr0WVSbf7tF6LVqg6uNh5uGZWpdVlMgcFjt4c31Cti7flvpmyL56l5Yp4XUsHT2RtQiloMvjbA2AnUYrCqh7MxN7y0Y2h01gUGMEcZMZeJdb5CyUGLl+qz+qzWJcBijicCxqQ0pRDGNieR3utvIuha9ftvkNBGWt
 YruqdLQI
 4gSd24ybVY+jGSUBxmBRzN+o1GIgopWfJM+9yGose6XewJ+lwu+ZE5hQWOtx59e8Wx/f9fpKAS/fEL8I9rZTBxp9KfIxBWA2zRT8ASeJj9YN0TXwY75pBOlHPvHZuSUUuLJMyMwgQBr62l/wo0PWl+VEq7WlREMOmGm3aDBZeyDPr+5mTzG/wJm502rjWhzM30CYdFOqGekh7b7wf5gJa54pJ32owoywSPELw7nwAsZX3ShPezVA+4NS7fM9wWlKvimqT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 11:23:11 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:

> From: Kunwu Chan <chentao@kylinos.cn>
> 
> This series fixes several bugs in the DAMON selftests.  Most are
> trivial but cause tests to silently pass when they shouldn't, or
> fail prematurely on slow machines.
> 
> Patch 1 fixes mutable default arguments in DamonCtx.__init__()
> that cause state to leak between test instances.
> 
> Patch 2 fixes wrong operator precedence and join TypeError in
> damos_tried_regions.py.
> 
> Patch 3 fixes several wrong strings that produce dead elif
> branches, skipped file existence checks, and broken dict key
> lookups.
> 
> Based on next-20260529.
> base-commit: 7da7f07112610a520567421dd2ffcb51beaefbcc
> ---
> Changes in v2:
> - Fix From:/Signed-off-by mismatch.
> - Add Reviewed-by tags from SeongJae Park.
> - Drop the duplicate memcg_path fix.
> - Drop the empty aggregation-cycle retry fix pending root-cause
>   investigation.
> - No code change

From the next time, please add links to previous versions [1].  For other
readers, the v1 of this series is available on the mailing list [2].

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://lore.kernel.org/20260531085633.48626-1-kunwu.chan@linux.dev


Thanks,
SJ

[....]

