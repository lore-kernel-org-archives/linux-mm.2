Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B0A7E63FF6
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 19:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469B46B0088; Sat,  4 Apr 2026 15:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41AD06B0089; Sat,  4 Apr 2026 15:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330446B008A; Sat,  4 Apr 2026 15:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 229F36B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 15:53:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EED0E1C65
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 19:53:41 +0000 (UTC)
X-FDA: 84621923442.16.90735EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1983D40004
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 19:53:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OzAhhg4I;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775332420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHX2n671OUMHYbwUEmspVUy02n4BVC4McqIwu5oAsdk=;
	b=0NQr+SibsVb13tyK1uxHnoyeyzrPgpiAyFyEZR0aLpuI0xu9jVZdYRbXfdOJG1jdAPiRHr
	PF1PZRjBNX2NhDAgQtTRODgty2IUazjDsWm1PDE4cbGcBfHZieKbFe4pCrCx3auCYzSa13
	v4N98lXrtlCByl0iaJtaON3Dn/ApA0s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OzAhhg4I;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775332420; a=rsa-sha256;
	cv=none;
	b=Ay25XnxKFHZ3SIi+qO8MBCkaQRNwhVz1SbtHGMDP/0oUp6INSoMp7VZl8OmF5dsbkPu43J
	jKWOHtiHt20278oDk0SCQ/8xJFqx3P8tQk45Y4eIhv1hjWJvSS+IeK1ylGZNcjOcdLN83p
	uzbwoipzPSaZbW+Qdy73UhsbrBf39Sw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84BF660008;
	Sat,  4 Apr 2026 19:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F6AC19421;
	Sat,  4 Apr 2026 19:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775332419;
	bh=KIyQFCexOJ3GWSHEbtzW2pSLEsIiY9S8dv+B7bmaG+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzAhhg4IT4uDD6s1jppMeqlKNBGYOCW4X7Ea1BTUPvxmwMDn6eA6xZMZMQ2tIcddR
	 8IuMjJvLcBp+uRc9KBkJr8MFK2hx6Crp2yrGY4iH1C1a7oaT+tQE8CQn5PAp7iJdnL
	 JmJnNoF2/8S9tPNs/RA3lJCnDamB5rotH7ts+gji8lcyXCqLldnaJds/FOsSU2V/+J
	 jk4vRr8DjruUHrDak/o2Pc5BaPz/n8hlChoFFz85DAt8ZKai5OhHPA40XOFmzGrpuW
	 AnZQFxRo3gx5814dtAtskWEc3Oab9R3a051pIaRta2ColzDkw07k1krnuuOjKMXxUs
	 +kvwf2guH77zg==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH v5 0/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Sat,  4 Apr 2026 12:53:29 -0700
Message-ID: <20260404195330.85809-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404012215.1539-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1983D40004
X-Stat-Signature: demmbwbxrjhbmr1osnhyuwakc7a5typq
X-Rspamd-Server: rspam06
X-HE-Tag: 1775332419-772581
X-HE-Meta: U2FsdGVkX18HA3nxxwmaUxd1nEzi/r5bnZdH0cENWuLmgrAXDLXqjBB1YGB6WgLkFz4EL243XEm309ymPtqXR6Yn3rQY31Vta91O86sF7kc2AOQa/4hRopa+b04zla9iWs03wXGu+1IjAMaTBU9I8GfqwHf/ZldBzzHqkR1qCBSV1srUviJL9FDzf+1jotNTkW6NqRiRCPkW/KxX46fo34ibBoyEF4J6IMN4CR4eH5Q3mJFyv0BRx2RPKM3fMSUuN8NGYEHvg8GLt7T0lVk9acgk1Ce7I0079XNusLPqsjQuqEKBK9x6k8Gt13H43vz2NlTVAWtX+10RcPUGXKGV+1XAR7UFjaOK2IB9bH3C9oN3mNxM50RHolH5Ei8XRJR8aSpysTYQtJJc5wpa5yoyvIZ139jveNlaD4vlD6rfs9i9pAKAnPjkO/ByQ3P41EWNOTgpGIOpbARB5i942AIrNGxW7LO6DeW4E/BUxbIBVUkO6b8uCYh1G3vt+eL0dod5PCZnjAjIqkMOkjBb6UteJJPlJfidvcUSRGovoeFJixft802NlAWZEKabyfCNuw4j8sdwKTWJlmfTGgvnCmcL+ryJz8hFTjAaFJIgLuYworg1xrRJYvpyDZ4pqufvxlYuRXlY4mGAzaSelMXoR0tNtUHmBHC+VqPdVknid+3p5O6068rsW44zKKmZHWE8moZkTZ/8/Z52JTxtyxS2ILLy5HoASQYwv1WP6GOs4j8+AM1WrN8ZED3oJmrBg+zs3p1JG6tBSNha8Br/gAzQuk5srTxvj0c1vJZ78OkawTbLi1pEFGmdR/vbwLzC8yhvYYCYUoPAUAOl+WD3Au4b9A3UUYMe2r8DteQ28/EthUn82wjlU2gWeaKrQZJbPcIlGKDHh+k5L59xmD6ronPpMJtNedsqIvMIXXBfSXyNQM47bOGow1hd43RaUI3RKKD8e1N04ZSVdwJUqUDhxEp5K5+
 +RuRNbDA
 /+zoDNtTrwVZhudxwdtQGnGnt24Mo/qs0Np1sbJdBhUfFR80ZLhIYShmHVch/7+IxU5rgpSdLPIBTNaq8jV7Y7McF+p3zhJyyA1siXG2jTkzwXc3iGla0syasYh8X4l0tdgwkar5WZfSsHb0dsG9guchAJCX/8Ic/ma4xql6ENEOoxWvW368ADRdlsMtlUz63KSNje1ntd1oo2hnZAE43JcaI1Xtk5bGZpM9u+oZY/qNAQpvJlxThkQUfb8A8EoNLkD2bCZ6FpojcYIz9I7sYOiaRb1VItKBAOw12CInqLWrYEAX+7JYcIOKmTIWLuRTci6c1xTP+nTl7JuUj6OEcKHwMMZ92ar2h61Obb3/47x1k3RIf7ENPRmBRxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ravi,


On Fri,  3 Apr 2026 18:22:14 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> This patch introduces two new DAMOS quota goal metrics for controlling
> memory distribution in heterogeneous memory systems (e.g., DRAM and CXL
> memory tiering) using physical address (PA) mode monitoring.
> 
> Changes since v4:
> =================
> https://lore.kernel.org/linux-mm/20260320190453.1430-1-ravis.opensrc@gmail.com/
> 
> - Fixed commit message description for DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP
>   per review feedback
> - Added clarifying comment for ops-common.h include (for damon_get_folio())
> - Fixed build error when CONFIG_DAMON_PADDR is disabled by adding
>   #ifdef CONFIG_DAMON_PADDR guards around functions using damon_get_folio()
> - Dropped RFC tag per maintainer feedback

Thank you for revisioning while addressing my comments on the previous version!

> 
> This patch is based on top of damon/next.

Maybe because of this, sashiko was unable to review this.

To my understanding, there is no real reason to make this based on damon/next.
And I'd like to get sashiko review for this patch.  Could you please rebase
this to latest mm-new and repost for that?

> 
> Background and Motivation
> =========================
> 
> In heterogeneous memory systems, controlling memory distribution across
> NUMA nodes is essential for performance optimization. This patch enables
> system-wide page distribution with target-state goals such as "maintain
> 30% of scheme-eligible memory on CXL" using PA-mode DAMON schemes.
[...]

Other than the lack of the sashiko review, this cover letter looks good to me.


Thanks,
SJ

[...]

