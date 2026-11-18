Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 042B5606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQ2pXbMM
Received: by kanga.kvack.org (Postfix)
	id F1C986B05B5; Wed, 18 Nov 2026 09:33:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA75D6B05B8; Wed, 18 Nov 2026 09:33:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD7C6B05B9; Wed, 18 Nov 2026 09:33:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4EEE6B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:33:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F58D1A07A6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:33:39 +0000 (UTC)
X-FDA: 85448483358.15.F1C4961
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F90F1A0008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:33:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQ2pXbMM;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012417;
	b=N+cQb9FwERPIbEjOhE1cUPcZi2vO+gAAocXnoP+4teTKxcF71vmMgsuHzvbdmqvWalx3rt
	Z+ZCc5z691S45JbkWhyL936FwsQb3aaiTLhzKhueXsqCgebgwWA3tupnCAgI/JTn5wb0Z7
	wCLIVOeOgHeUf5qKPO6zlak2qaOC8sM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnjKgTm5vSNYR4pLlmAjDVsgJphmcl/khyWsdGHeBCY=;
	b=RoGFN5ucrHvpjVyN34FT4ztE1J0w7jr7lqZYygxH2YPxglNOSUEVjhI2Jr3Zvko7tf5UY4
	emaRk9yXFWgEpYrxmIyX3hVXModKZ/R1O4Mc/DlR5lnej43o773hbHpRhbYO6fkRzfIBiA
	66D2d7XSX0S7EHfpHSWmhPnmoVbJBYU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQ2pXbMM;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C12914112F;
	Wed, 18 Nov 2026 14:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681EE1F000C4;
	Wed, 18 Nov 2026 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012416;
	bh=lnjKgTm5vSNYR4pLlmAjDVsgJphmcl/khyWsdGHeBCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQ2pXbMM8T1oX7wrQMY/hn6f1+xlHKRWE2PRIKDD/C+GPWSnoePr+Y84oMgigX5W+
	 oDYCAON3LXdYPMVXQXH6+cKWl8YgltIJFPwG6hsUqY7krMleYaa/qmEgxml1Tjo4HM
	 24MlTMxa3rBKD9Xi3czpMVqJYzNvVjf6y4dNl8muT25FY1OutVFES9qzdDLwjABHWW
	 f/5n/I8sSgbk50WZnUHIeVO2ANd9qI7oaAs0163Bcy+rsK2MZZL3LHAX3qtZsfMkv/
	 7wRIosaqy1C3ud+1g2rZwDZ9qKwdhPhxtIXt3nsR8zCqt1R6t+Jb1x9GV4Oe83R5ak
	 YzBQEwonLtJzA==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2] mm/damon/paddr: skip non-LRU folios as a whole in pageout
Date: Wed, 18 Nov 2026 06:33:18 -0800
Message-ID: <20261118143329.92901-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118-fix-damon-hugetlb-pageout-20261117-v2-1-547a65a3206e@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F90F1A0008
X-Rspam-User:
X-Stat-Signature: umgiwhg48ws4wufmf8yp1ig8fkbutnkm
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795012417-392759
X-HE-Meta: U2FsdGVkX18QIMN63EkkWVdWVWMSWL9Fj1pXqVno2VK9wOkHDyzYEk1cEgIS7p8A9PbMZmwSsT5Xw7gT2zk/DgCfOZS3jMyIar1AtT7yzOR1Hq/6h8WALjAlimucXPHe1MpT8JA0DNPA3+Ls/11ttLgiJkpt2EvG90Df2dPKQJzWHXdIOyXMYs7FIwSABZCwFDEp8qYQ8ji+xe+22n2Wwt2iJiKnyNRrEIuqGpziAAB2ZL/nWJ5zR6s+3hgDqAp0nIFtfN1NsUvFAyffRxjsI+0V6BU7g2xpDlSpgd2PPu1ze9RPEHNTarFC5icTfGGbZCxp2hekoqF3cEPuSbMfmV+TEcphQ5roTnH63QACR0htBniMpEsDqO2gQwRBBHbifsm7YkZJbcNa7IGaY698kk+erjfu3FZIYhWms4rD8riXkZEQ7IuFVZIDjtJwKh6CRJvFseCcTpNDPOEb55pcAxlX6jOMjHWVmNdB60qCFDzHthzfzAg/XgMLwcqnT/DJP8caMGbPO7YnFDuEdCwD9Svlr2LjU/W0wPsGad+w7tRmRYM5Kn3tEgzuXrxumvfXvYbkV18TRJkXj/xEi5VwZOrghhgRBPc2H7NKG9FZKkp2x25oHE8LjLafBHa298g56Xf//WmYJ4xmk7sQ5iai47Y/t+CL9xWM30/TOsAOZoSU7+X/YE9l6Ztte514T3P+53aNsWxtyti+OyszHxbUmANDwm2e471BamzJgag+AlPmquE+V77xEoPl4Fg6DPgSqsTrqDuRwIsQy+zywaGxrKygpxgEcK3J+a+TMDnM98swIzMCGay6jF8H9sSPKB/k3uUwzo0pY/7kFHcO62FRXHid5vOvrUjX1xYTrxQHdV9/8s9ShIpcaGfVzm9CWYK0TQqlj8RnjLfdO0iFCgPppmat2X3FnRKpYeGvYkR1aQ+zsr/FcgTZ2ULEYEK5mOSkq73iCetIF9TDUWiBKhf
 C74/YEaj
 HXXGmJ0lc2VC4G0HpL8UwSe36/3a6KGkA6fxa9KjjGgiDsi+xaI0282YWS+YxvRBcOkrp/HYFDddxusdM2jBFWze+GfSbTnqJjKhvc4Kfrp+BWNIqkkf4VZEC+258GFeSszoWYOJKoomWha5b87bAw760rU+mLYVlBtxufrSf2UoR9ea1Re74XtVFbiik2xkFu8RVz13M86XgtOPeyJt5J6mKzAlOWxrLpfnybIW2jOyaIaiy2Z1TA2T/CpZndTK49fM9R6MmceZbnOqyFkUh2yN2203ZRG/5Ms/qGi9xASZc6FYTBRXtnteUcS8JhXZPaqLAeUma+D5k1IeAuIK+WJ2J3yWAD+11nHynMoJzlu06VGjcJIS8CXCQLA+qUPIWFfCzm+KVZZPK1ao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 03:24:28 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> damon_pa_pageout() uses damon_get_folio(), which rejects folios that are
> not on the LRU.  For a large non-LRU folio such as a hugetlb folio, the
> loop then looks up the same folio once per base page even though
> pageout cannot reclaim it.
> 
> Use damon_get_monitor_folio() and skip any returned non-LRU folio as a
> whole by advancing to its end.  Do this before the filters, the
> accounting and the last_applied check, so that adjacent regions within
> the same non-LRU folio are not walked by base page either.
> 
> In an x86-64 KVM pageout microbenchmark, traversal time dropped by
> about 99.7% for regions covering whole 2 MiB hugetlb folios. For
> 4 KiB regions within hugetlb folios, traversal took about 1 ns more
> per region.

Looks good to me.

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

