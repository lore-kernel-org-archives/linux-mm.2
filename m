Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77A9CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3756B0093; Fri, 22 May 2026 16:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B246B0095; Fri, 22 May 2026 16:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90E96B0096; Fri, 22 May 2026 16:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C92186B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:13:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 962041C0792
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:13:58 +0000 (UTC)
X-FDA: 84796156956.30.54075DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EA17E100009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:13:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCqRj6Yv;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779480837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQKwPiPe4zmYUnLVrkzlo3mFd7QXmw6jVxLpTkZDOnI=;
	b=Bn29EEtRpZqR7YKnkO6dGhEjHclBFPqzExzfgD9clp6hkqYinLJgxNH2wQgfnp0dUly1we
	+Rjq3aOhD2fdVK+4/++a276dlcboUhMs+fbgj3M4lmPSHhK40NOlPNuSngeCnjOsf3Uedo
	lnWex6I/JA0Ohvt5h5M/MzUDJskJyR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779480837; a=rsa-sha256;
	cv=none;
	b=nmQv4Cmd0BH5c0b4sN+dAT4OBxg1l4B7fF9kPeN0tFQogiYReaTUHlyalggOpYQEOvbNFd
	FGQa0/bYzyRouZl+G/g6W+Mie95HXcCYiBbRfCCMfOhQ56aQmxBjRppcKAM2dqaWFQSJwV
	FJq8BTn5+rMnTLUrabRqpNAyfP11e/0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCqRj6Yv;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1492423EB;
	Fri, 22 May 2026 20:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584F11F000E9;
	Fri, 22 May 2026 20:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779480835;
	bh=JQKwPiPe4zmYUnLVrkzlo3mFd7QXmw6jVxLpTkZDOnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCqRj6YvqI77oOWeDSCmRZqilj5oTId+3kmG36DcwD1Vad8YEhR5VTVjmABTG+gJA
	 YUjHONtNSprnm+0V7z00kDrjWrMq9s1DxBQsytlnxRj+qCCDvkKAu8k8Vu7FyoysGm
	 H7zFZAsqHBAossdYN64qrZNzePMt/PVbsrfqJrCSckXpiyZtaTBXz66TXwWBj4xReU
	 m7vO6U4nkSpNtGgZB8izIfbSrxdLSCRy/EmovUhP++lJj+0I2vfLtZwei2BFD+y0WM
	 QpyuIM0YxG7xmtleAerJCezxOOfvGICJ+bTCHlBBeHKi/IiVcqoZiSIthE9GKIt+cd
	 4LGtRHRINqSHA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/14] mm/damon: minor improvements for code readability and tests
Date: Fri, 22 May 2026 13:13:52 -0700
Message-ID: <20260522201352.3459-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EA17E100009
X-Stat-Signature: 1xgm65tu4gsk1amj4iyhp4kjgggqzfqe
X-Rspamd-Server: rspam06
X-HE-Tag: 1779480836-583668
X-HE-Meta: U2FsdGVkX18JP2jC8uqHytiE2bOJBs5zjDjDBzFpDOD5WDrbkno+LPKKBrTWR215i/9kITzZyBwZybMVzIbwKjpzO0nNMfCqcpfLriv78GQVqwBPwRpNABaqWBjY0RDwVwYOGRXOaKPHDy7gxKLqQBsPAbYq7u0zftBDhdycjL5CvD7wyijCvjCHhTtNnx5FcCD5UYs6IiSJPeOW+X79GgOkb7P5DRzkjwMgeykfSLrbJ/nZDOgbU1sBmJfs12VcgGNAHLX6apmJHkJiORdpBwVDGDpoDJ7Inz0HRef/eoqQ/RvxyIm+0jMr/1wHACfzKshHafPnduqmGNz7Qfdaoi+CABx6uefZLrbTJvDEnwHkqk9PO9qSfRngL9HBZiYbG0VhX5cSCETACij3F+U2ux6TV3wOZnxWvWpxo0Ly+cUAPF/gADXpIMbtiG/hPqB3UPQNAmcJxlpDhFgFVglDHKNrkfrOE8b0uZLEyehM0i48nZvzl55bAerFHJcaNoMWljGoFfyEVUFvgzabFpdPsOseBeHQn7EsKIlZYmQGQ3U7667BRywqfFff/onYs8zkUd1k1gDCHgRssjDNs4tlwgToYzoAL2/0SH/C2j15cQLOBhJXZUE022pbYnqLHtnOKfWSoTIbO88dTgyePspf7A4anmNaqY0/0+etDv1czIYN/R7Rg9Fe9nA2DSiL3rVN+xvfjnUcJokS8IEQAm2/M45LBOcarmbrtD7+EvtG78w9qVzQ0dmNM5UxRUEshBFhtOLifD9DrPxWbLVSUQaU2HLPtuEKiu7zHhS855T8geS1sQe/FWVZLZ8W3peGCgZj0rC1a6Rnc49wyUCWuKlNO40P0hnzG6irsf1N5EUvJrAnvHx97/0crwzxoQ6GV8MO/KoInfmhQacM48cePI16NxhQxcEM2m/Jf870DWXunZMUneAmpevuYNDghM9STRGI2BceeVcwheS2DcZUgEH
 DT3AgERi
 6xo9jSpQGfgra3ReAdzDS/tAACn+VgSWpsyloaviZ7b2WiGFMB/niGTI2YUC6qDQczfEQC6XRNO5wqn1vPWT9DjyD2jM0N9Q10ALqCGB2exsS/nGHHF58cKhiswloaFqIjlE2YsQIr2DwcBOH1aSlrSVD+TqFUzZ6i66FffEkpGCG2DjdjLbtYMfn8uDkkxdAG60PIYJ56ZqPUgXyQCTPJ39g0qBLB57aAzqYgiRKcepq85m6w0izeLI6tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dropped individual recipients except Andrew.

On Fri, 22 May 2026 08:40:11 -0700 SeongJae Park <sj@kernel.org> wrote:

> Implement minor improvements on code readability and tests for DAMON.

Sashiko failed reviewing this completely, but found no blockers.  Also it
didn't find a blocker from the previous version of this series, which is same
to this version except the baseline commit.

[1] https://sashiko.dev/#/patchset/20260522154026.80546-1-sj%40kernel.org


Thanks,
SJ

[...]

