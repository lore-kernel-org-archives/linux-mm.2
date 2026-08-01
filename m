Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03DE3C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 00:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4E46B0088; Fri, 31 Jul 2026 20:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075596B008A; Fri, 31 Jul 2026 20:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDBD6B0093; Fri, 31 Jul 2026 20:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C633F6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:07:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45E6BA0105
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:07:52 +0000 (UTC)
X-FDA: 85050762384.14.737CFA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AED1A80004
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:07:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiLyWsLI;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785542870;
	b=34YhQQJBX+C6pXCadIDFFNbMVahC1YWs4WRIlT5M3E/BIB2w2VliKAsNFnkf8kbDbAxmap
	Dx9ivO9u6fAkgZPs/vzfuTL22+QSZxWJ58h5oS2JtMgMc1lh00RRY5gdT99mJxz86YlIfk
	s71uirVaKdhup7krndrnp6wY0gnm2rk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiLyWsLI;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785542870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVoiJJzODmnFFCLzc4mL+KmhAo+t9chR1W9Ku/1lVo0=;
	b=W28l+HGrWY95xZtWmBggA+iiHs2ld+7rjnIEu3Vbrs3l2J0SxhlHs68pKGGArnaE5NjaRk
	4hgGjAXY3z22GSRjI8GGBaNBLU0eeInAn+Mkoh9vg7/bTMo7gFG3FFrwxUp6+v45dR1pp+
	w1XCggIP27EKYMpsSikHd5WHkEnJr+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD097600B0;
	Sat,  1 Aug 2026 00:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A281F00AC4;
	Sat,  1 Aug 2026 00:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785542869;
	bh=LVoiJJzODmnFFCLzc4mL+KmhAo+t9chR1W9Ku/1lVo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiLyWsLI2WxmX2cL4YRY2yU5gqfTRqe7EdOp8fdM5KALhQ0kidbL2Q0DpoYFiJ0km
	 oduMOIVIB2UHh7NtwyUihwXDKSlW43pJ6wnNkhj1mdg4ZHHkla41NKydtqkEFYcM6g
	 2gDti57B+33aV2rqGje6oe0J5TjRe1OITil2m9JdpXrnKnamvTug14RL0GCWsFxesN
	 oEGRL7dkHs7Bhmv3SBH5+q4eyikCuUESI3aLNHpt1aOeFUOIa3QkUmPvQkcsZlW+GH
	 quKQTMWWrdXealxMiN6Wa1OesdvpeBjXZM6lh7JYZWmmiyJ8pSy3wmmYXQD3FQRztb
	 MoBPYRKf5a3XA==
From: SJ Park <sj@kernel.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm: zswap: drop list_lru param from zswap_lru_add() and _del()
Date: Fri, 31 Jul 2026 17:07:41 -0700
Message-ID: <20260801000742.84624-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731053721.1412304-1-wfelipe@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AED1A80004
X-Stat-Signature: ejt7qjrr5qat7iwrkps57sp1t5sdjnax
X-Rspam-User: 
X-HE-Tag: 1785542870-275009
X-HE-Meta: U2FsdGVkX1+BpOIy4QIEoerbDm/L06IJyA84xElawuhc5l7gHYXuqGwqCkPr9njlAbMsah7eHnNeh/4kUVsxA8P2v2DQ2Yge95K4gXtBlhq+jNNufBOdD8A9H3l0hYvJAJ3vq4V3IjNotvuCMUzH94MY6FMSpRLd0HeofIujghrm5qoTdIWZ8bJen8v1GH2MciAKyqdjPGtEi1d2M/zOJkdcT8D5aI++uOQNbU7bk2EnghRN52Gyo98mdo/cpnb5blSXFQak0MeUgy0eXN8oFGtgVMbII5l2swBVrikxpSohpQ1fNAodPMDlhrxR7oL7DhcCaP4+9uQuzp2bQkmTbdWMkvnopiEj+OhSOdHfVZm1zPuG2tB1e780da4iMGNZWmpwgJ05+T27CBGxkrFCkTsi1ICM8Tq3cNd8ES6LTjAfFUuVmIV0JEl5DtQf5UYYMZQuqq8NBdjf28eqtCKLdcIFLChzztqsF9V7dyu8K0rlKviJlNo0ZRQJTZUgUb5QIrkafZqaUNDAyMJk/y8DCgzt31XOSpS8UH5ofplZ5ecGVeSx+FgTx8+17fe0qvNlBGmtNyiv7mHxv5VV8q9OF40fc3qieJUQALOeuejN3bpAvWmk0f9MnuXv7zrNlhw9AmV9t21sI5NlIV6U92qSkc9Rcrzvw9l1L45tYnSWgmzcDTLEg/1YHW88r249Rwvmus+wLPinqPKktIFqGR8jol6vpQd0/MkQRXx95RadC9PZnQ7FMgooSppnicSyI5Q61waju60ZkXGsbamfwDNiauKmmnrJrlE2MewRmZewYB0sIMc2D+gLxDwy02yW5VuT0mNF/xTGwGZAC6p4sb0lrieVwylUt+NACvkeepCd2A26IP8HlEc+O3ck5opyuCFN3IgE5sNDOnJJqwJdJqXLHvr7/E6sZQ5mKSeccC9T1PJNOTcWDByEsKyjj7E7s1dp+ANstOjFgKtjJwcPhhh
 ZlMIjafd
 29Io0K6Df1SPhC30XW1h6EWuw3HfDNisU61RdlS8Rjzo6CvefXg0/k949I4m8Bo4an1VhrQsjFwCsQktMa2UY6tv/4PCYNKaougqAFh7p4W0qEMj1fWS4WAH5kkGd6WaOJ8uy2rsOmCF2mAfH1tv91fn9LYLpTXlePpaLsEq1cL1/OSoYwFUj89ttKE4QKReAmjTOJdCbW1l7CJv7G0TqNKs4dOBUWOphgiB40LvH3MyZt61ZBAC3FvlFsvzuifesq6kyTm1Uq/j3Bh3UXmPp9oIjsI3V8TwzIx0pFNE8R1K2rcM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 05:37:06 +0000 Wilson Felipe Pereira <wfelipe@google.com> wrote:

> Since zswap_lru_add() and zswap_lru_del() are only called with the global
> zswap_list_lru, remove the redundant list_lru argument and use
> zswap_list_lru directly.

Looks good and making sense to me.

> 
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

