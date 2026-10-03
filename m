Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE07BCA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91CB86B0088; Fri,  2 Oct 2026 21:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4936B008A; Fri,  2 Oct 2026 21:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831D66B008C; Fri,  2 Oct 2026 21:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED8A6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:30:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E85D4160853
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:30:34 +0000 (UTC)
X-FDA: 85279585188.20.E6030F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 639C9160008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:30:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L4WpyFtA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790991033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CItS/zWgrIg5kKOatrfL9GJj+0e9m4dKbtj1MKAf+Z4=;
	b=l/qhdZRJo69BAZzSAW37Ek6X28Jh0O1IPzOlnPRB5qzcN3Z1Wk3xBwXCvhRXjQp4rOy5c/
	2JpecAMW4vAyjfqMBv0dJlLu6NbbsNG4ps1MI+PthhoATc307R6R/sX5lYAyY/6UOi0/nb
	SEWCtQRj9VMWIQeKL7pdBz/zWI5iH4o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L4WpyFtA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790991033;
	b=YlAoFOzgFQqBULrt9RArwLifLY++RNHjjtg83/AJFNq1Jmjqwu/f+h/mFHv+zyzKuxuWiU
	OlZgpQ4XmzjLldp4fMJlwLXL2JEv2gBc1pNY4wJqUAOCYza8/6C1oWXpV3TDedGTW+9TKt
	WoQ0qcF6H+XGKizKO1coex6Ap3sE8cc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE8F560AB0;
	Sat,  3 Oct 2026 01:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82C91F0089B;
	Sat,  3 Oct 2026 01:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991032;
	bh=CItS/zWgrIg5kKOatrfL9GJj+0e9m4dKbtj1MKAf+Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4WpyFtAYLjkr7KPPAFAoitkhNVm4NxF6Bc3vyTlMLNUUWTrircsQGYH2hnKBHYtQ
	 Ain0e6HhY7nHOsKk5qJOTvv8vTu697dRpVacMB95bvPDx530QQ9/3/BIU2PuDkyNdc
	 RL2AqubLicNeTwjKVALA85EGhcAEwSAHBwVvVb0ECxKybkNOnrqJDxW6ScLiniPPGn
	 sDclN8NwDUco6m/mSbomG550Z3CAai20FCctU3iRmraho06oPxVeDKEl8odEPjtJft
	 Hin72Cg7sq674CSDHkbRqU9NFpOCYQgrBzAz8JTIwiuqr+uKuSF6Fzz5NNrqIrBHk+
	 kOq9k30144T6A==
From: Sasha Levin <sashal@kernel.org>
To: ljs@kernel.org,
	rppt@kernel.org,
	peterz@infradead.org
Cc: Sasha Levin <sashal@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	stable@vger.kernel.org,
	4ncienth@gmail.com,
	alexander.motin@truenas.com,
	caleb.stjohn@truenas.com,
	ameer.hamza@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while perf record runs
Date: Fri,  2 Oct 2026 21:30:23 -0400
Message-ID: <2026-10-02-rc-reply-0003-re-secretmem-sigbus-perf@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002175651.811343-1-ameer.hamza@truenas.com>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h9h7fefxitrahcb9itfrxmkt93hfqtdj
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 639C9160008
X-HE-Tag: 1790991033-170125
X-HE-Meta: U2FsdGVkX19JTZ3fGGKTWt5rJiold+MuHfy44695BKx2Oz6zvd8/nPAxmn+fJKeCsz1BvyKMHE9qhKp4izAOBadR9CPR65t1gDQcr0F2n7Im1mnzyxhTCQ4YZeLeGJjValaLZd1GKH+IXZfFlabsJPPoEqiwNRvvTYUPEMGHewgbunMkbcwVarKTAXEVs8PLTSlY+WV9d2e7kmU4qdcJCDJQsN7NgsYEuaDUrDOYcc2WfzHAJKtpyXtO4CK68RzVajVo0ID+y02mfrCPtejr6yPa7roF6gZC8mO18y37QE4CsAKpnPq0UV7Z+sFWlMs0UZVh+k8lBBoQ/t6ez1beu4QrD/xLc66xtwy5FQzPCVGKzYHBPIbZLgREYjZ9oG+PHjnD4QWtwXNjHzoqe5aInk5RePOU7ScGRJQjY3fH9kQc376xdprJyCDPlaTrVb2JSFPhkPSJThr6yZi7zQretPAa+xaU2AJJcL385Idigm8IqEiNWA6Yo5fcQzeU6C3rdDFpdY0zES1xc/joIELQ7/JVs5wmQ69pTMbk+LEGqk2FVqaBOItY7QKfruhM5njn/DMEUqUcQeXBcbRdo9WG9rSWwqhe52SP6jY3tJKu7ED1KtgtzBSwiUCwECz6hoX0QDIAB2omeSJJ/WC817AXG4Sjs/066M1lH3B89mtmL22SFxzjy0WTC8y+8mOLiZEKCSBC3C71g62rNu9L1zNRSieV2SW7gQCTpnNfcL2apqCIuG9H+CpwhxfuotqE4r3kENguN78k+t4xLoy9jhptUDc8O9BXe61pLT7V7sN62nfnzKKBrbwNrt45uoeClWg/gwrIN+8OSeMZRO/ZqHQJY9v0P/ht1EcxlqE/kv7Z1cAMB1Lxf/jxL2rK7M6WUdWYtOVt8mzlB+Tq+RJ+QGkoEBsyNYT9mbSgp4Lyj06R8bJXEckLUR9glv7kBzCIcwcqod6/Ji95fNQYjFtTlmr
 vAOSF/Jg
 gJ9DeekdS0gxq4Rs6H6VU8qYLF4Oep4cdSOIvz79GJ1u8sYFMtLqB4WiYTw6z3gVLW5X1aRSciiiXWzzkG/+ysict+5CFS5yUUI+Bhai4pKuqn0JnwdqlH9mLiwWBsUd/RHIga8RxAkD/xWvciKUFHQJcW0dYpCPLKjIHEqLdC+s+HInkSDUIrPiN1KpoRroaxy9Py/fS9n8ZNv1dwdOPP5IiRLBIklehK785z5npoKuSQOS5rBeu6BxG8DhJYJtz+RRty37hD+V/m+NwdaMvfdWbWpnDRdhOGh+vDD9HnbvVF/2CgSPtCKG/yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Since commit 97d34aa65c29 ("mm/secretmem: properly account locked
> pages"), in v7.3-rc2 and the 6.18.52 and 7.2.5 backports, touching a
> memfd_secret() page for the first time fails with SIGBUS while the
> same user is running perf record, and read() into such a page fails

Thanks for the report. I've dropped 97d34aa65c29 from the 6.12 queue,
and also removed the copies that were staged for 6.6 and 6.1.

7.2.y and 6.18.y already shipped it, so those need an upstream fix,
which stable will pick up once it lands.

-- 
Thanks,
Sasha

