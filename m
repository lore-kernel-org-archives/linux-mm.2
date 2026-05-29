Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13DD7CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03BCC6B00D7; Fri, 29 May 2026 12:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DD06B00D9; Fri, 29 May 2026 12:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A3E6B00DB; Fri, 29 May 2026 12:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6AFA6B00D7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:00:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F56440232
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:00:39 +0000 (UTC)
X-FDA: 84820920198.14.667F27C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2FBCA120023
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:00:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IrhyuAPR;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780070437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swbfRtX5liCUiybXlbewNQ/G2rwqPA7yjLKy/i2mBTs=;
	b=XjZrH1k0IxvvI0eHCzJczSguNl4cbclt7whBGTP/lWkv5ssCXrWMWbPScCN3Ji/OPCNzAk
	A2NxhUdkDrXIekkscJIWKr7+Jua1DNzqqyoKKi8g81m6X/30grdByVoA9bDlQPXrBTT4mr
	tbA16Y8fvHevDHIHUGYvjFiSHqU9MD4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IrhyuAPR;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780070437; a=rsa-sha256;
	cv=none;
	b=fXNXLzwDf3GuuWsBVUWH9YPN+kqm90cGdI+HiPVDMUn53s6ZQcUlDVBW/XkgxIa50VFCX8
	Juui7QEgjw9wxUGIrIkbFQiict5XDSDqqqEE75+y45wA7mdNJLYxS43k8FYyXibFlPcI52
	aHaXShJXXDu1GtQ9FN+s6hKz3a4SHbk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFE4A437FC;
	Fri, 29 May 2026 16:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B701F00893;
	Fri, 29 May 2026 16:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780070433;
	bh=swbfRtX5liCUiybXlbewNQ/G2rwqPA7yjLKy/i2mBTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrhyuAPRj38zdilHD+aEEqVIYR4DydAimWaw0gU7zHdNCtaQ+pP0t/QOE1q8qqEAg
	 GzL9BctiAudP1mzgkXWbVJfynffpMnD9ckCdFr+hrjjmih//NGs3Wkl8Y3NmTDg4tg
	 qg4pbV+5X/SlmR5BKF2H7YvboSVJMDlaS3l2ReeL4FdV5x0pFZoCwPs7Iw2hrkQxjr
	 9HJmMhxi8PyYN5xxTwiBDMsIZpoE/8Xu5VBmEQP+wHM7pPYAFtqdhE32Z+tzq2Z+nO
	 vwrYWSHJeCDPjyFfm2PZbD8fTOGI6Y7DLphtDHsNcGyZa+vWvE6h3/ux9QQdNkh02O
	 LygtWi0jUdEvg==
From: SeongJae Park <sj@kernel.org>
To: =?UTF-8?q?=EC=B5=9C=EC=9C=A0=ED=98=B8?= <dbgh9129@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon/stat: roll back context on damon_call() failure
Date: Fri, 29 May 2026 09:00:29 -0700
Message-ID: <20260529160030.85303-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CACrCO_XCxTDk7b8wo66CrxzfOXG50-uCxdE9tjJppH_ei5Wo+A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ng8778ksk5awnr9ejnkohdmge37poxf
X-Rspamd-Queue-Id: 2FBCA120023
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780070436-508799
X-HE-Meta: U2FsdGVkX1/3eoWlYYfWTtPxRBv1fNpNwVQ0Ienqg0dzJHHtoFZjhlFPVOJaH15AbNZAElLFk33Ca8Cq9umZkv0YAS4e/1cbcnwmXfccO3wpH1D9Wk4y6ipm3AmL/aytxWIWd1C8OV/3R1XQwJD9DPpPDHaOv9td26YDWXTcSC2EVgyCZ4TacLvlzHkargJ4qShXfCy4IS/qQflxumEKWK8GsSR+NLZu27CkVOhO5vHFS9veTx5I9roWzvBt9oLRbKTL2SqnkFfm+/i2v/XtTkPB3bNhT7IAOCO89Ry68pcdtrM1ip7KXDrk1OCB4PyUACLXEJlCV3dmyJhZhjIkzwhw5+Xem2JZkH5yRsT66msOpFBkKhdxl0/U5PDIHci+5jzCb54Dunr8khjcm4HlGVyXmCHpefTkBIFiCKyR1KoJvuRRBTx8xxeNvkXr9NnBhUjoR0uD/ioPVqPjxWl/gvylpHUE3z4FYEN1GFhIBZoAvXrt2f+0zp8bZnKdsg5HNP1iuki3ymV69UpKKfC/datGWqm/TbyXl2VBtt+zi7pJhK8p4zd2Yx3Y1j4YiblB5hKRkoDICfZbYC89ECldiDRN08pwB32iZDxl4sZyhhZ3MSV0D5Wc4e2iiI/j0ZJ5ALVclNGX0WbozH7RvUK2N+G+QbQiYFSybNbI1ins2ZlGjcUTY2Qo3SfxAlb28Y8ZwyEx44AJULq2Y1u9/z08vrJsnOJC2RsDkba3fGBkAmmvqk1rUf3VNUpfOlEXuyq6WDDkZgA+NTrh5P2Yec8KhOf0/wGD1HUtx2kj6TZCS+CRupjfu+HparCKkHunW33XI1tMIHaBfMlfGNEZGUqsgBhqf0ZdWBLZgEUwOjmrSVeOA4z5D5rnFOHffqiAomsinDhAdNGw2xrsDXMa+VjdQKw1Lid8RiOxLVmdmItLoZlJ8ENiT/dk5MpyNSu5bhVsi3ep/Z+nPAcd6qB3uOF
 B/T7xrVA
 RfX5BaOfCtGkUqOxEz5c755DBGOcB7aysOfccHOSPYh09HktF/W2aRrPCmmVGW2p8CgI0+uND+6SUJBhvt2uhl8nvegcT/6fV86ErV/yp00VtF7vsagWZyMp4AcbjHW4PnNFLy6w9pOBhJ/vRrCIner1uVad09Jtu1LA/HRSLnK9lRvLKFjc4vsyi/yDWhLMbwpMDDkC4lskHd9+gsaE/cwiniFAoaZp+D96PIgWMpfNpM1Qvgj5a061sKEHEYp+Z0bwCgk8IJQWVQB0E9MRrsURjyzxYbnV3bCWsVO5/YhQ5vL94ZbI+ouVYn+aqdEzF94QXi3KX3zvY572FfFAb3WgfEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 11:17:01 -0400 최유호 <dbgh9129@gmail.com> wrote:

> Dear SJ
> 
> On Fri, 29 May 2026 at 10:44, SeongJae Park <sj@kernel.org> wrote:
> 
> > But, having one damon_ctx object in the memory is a real problem?  Why?
> 
> I agree that keeping one `damon_ctx` is unlikely to be a serious problem.
> My intention was not to address memory pressure but to maintain
> failure-path consistency. If initialization fails after the context is
> created and started, the internal state remains in place despite the
> operation returning an error. The cleanup is then deferred until a
> subsequent retry.
> 
> For this reason, I think this is worth fixing as a correctness issue.
> That said, if you feel the current cleanup is sufficient, I can drop
> this patch.

Thank you for clarifying, Yuho.  I think the current cleanup is ok, but I
understand it is confusing to read.  Apparently that confused you at least, and
that's not ok.  What about adding a comment explaining the context?


Thanks,
SJ

[...]

