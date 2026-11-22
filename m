Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BF1606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 23:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bxq6GTb2
Received: by kanga.kvack.org (Postfix)
	id 4328B6B05B0; Sun, 22 Nov 2026 18:50:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E34D6B05B1; Sun, 22 Nov 2026 18:50:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1316B05B2; Sun, 22 Nov 2026 18:50:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0D66B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:50:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE3E91A0756
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:50:06 +0000 (UTC)
X-FDA: 85464400812.06.5A9EAC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 413FB40004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:50:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxq6GTb2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795391405;
	b=xqBtD0pj8DYlzFtCrckOQc0py401ipK2TpKk5Eu2VjCCZJ3wZRGrfoeF9lkaRgUSYybssS
	6p1JD/tpkdYyaWvVaC3/fw1+yshp5192JCRwFVayXlI7RA105KkVulJ/FAodBoeUXNY7+M
	lIxgJonkXby4Zd8l3dAZ99++CDJV6XQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795391405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+t697FbN3YH1ito+3RCbQXZtdIEnIJ+uIHE/maxp22Q=;
	b=YkHOdTFUIsHAIQ3QfthOmDmEnS2i5gN34vcx449/ZONwKDSqqJQRBeqUXwKkE10t/6rTgZ
	gaTy3plqExHipWtLteMhcjt56EJGXvSfomVtGBRj1IqGYPpkns9rPwSI3I/zHzZ4sJHI0x
	/z/3vKfPVFuNxhv5E3qQrllTh1ggUmc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxq6GTb2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4390F40DE9;
	Sun, 22 Nov 2026 23:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658FA1F000C0;
	Sun, 22 Nov 2026 23:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795391403;
	bh=+t697FbN3YH1ito+3RCbQXZtdIEnIJ+uIHE/maxp22Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxq6GTb2xnMBm4ZECuEMDIPVa7RuAdc0BWBCNGRF6IOKhulrMAl6UayEDSf/ZjRFT
	 u69o//1LLGwNQZRBYKxfe8BtLoq7YB0nVB+P/8zwyiTITuqxr7+yd4tUcUdIHbOyqg
	 3gMwSsWbSIOepxk7a4yj85b8Gz/by/YgJIdCPQcV2VxKrh69k/7pF1fzmbBE+Mxn1S
	 mCxRIZrEZoFMubx+unCi/tsnK3igkWPJv7iyzza6hd6qtcHzl4KZmo/p2/KD6673Nq
	 OTXWlljwt7jHsaTKUgTWeV33GzE9QgGGlIiw7HsXBXPLazxzcjo/qiXkqRS9XtxsKY
	 yQhrisJcxsRRw==
From: SJ Park <sj@kernel.org>
To: Yifan Feng <evanfengff@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: do not overwrite wmarks.activated in damos_commit()
Date: Sun, 22 Nov 2026 15:49:55 -0800
Message-ID: <20261122234956.22710-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122234633.89529-1-evanfengff@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 413FB40004
X-Rspam-User:
X-Stat-Signature: 75o4hg5c7jbz498yzusaub1ho1x6o9wm
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795391405-360208
X-HE-Meta: U2FsdGVkX1/IX04BZurnQHrVHvjD63nTGTUg5KoSwF0c1/34MPDcV02ejtqtLHIJF+uPKFJyXLuYPF7ejCDG+ohLESEz20wHW1/youOQRJvZU+5hFQuRKjpOh5rlQWC74AGvdNe5lEn0RCOR2wnI3O/3YyjS7IH9kf+t9sZ+5vrKDFKCx25aDQnVw35tXMm1EsJIc14/q3eRmzD9M1F+JJ8+4sFLxqqelVjm9CdreuMQDlInn62czsPq6DSBG7XFri9/IJPeEpAFjJxnYuLQtEbu79Kw17UoUdjCtO1ZXcydk/R5ioKc0ffrF8VO36F9YYK6Me4UZlCe+D/jVUZg1Lz3wqX4hbaoupj26xgxetKUlGrJQLtj54x+OuQO3lLP39aowRljQyNCXVQDdr2LBF0fLDjLN+QxAe34mXTLKk8EexschX3h7gS5OLRSumoWYDUeZvEcTpGNLNX3CeBHg1Df1wIRLUBT3JkAs1TRPnrzkg9dp63KBXjZ9iCh0ZN6tcXKdWTJQhF4m3tYYeMPwvldSYYjfF9kjCa0nVN3xApbVl+oVvNvKQFPzPyUOOWRD4fPphFL37kIgp4yZ4IBMWzMsCpDPdSN48hcBlu+3EFyKJuvSZ63bgQk9oZRCBYKrgbFksnddfiGCA0mx1i0X+8skqPpawAQpr5Z4WmNqJ2k3GqbQpeXx2Bmj1XoZTWNFZlCUJeYNDz4J/nhpZaSt4lPDISFt+eV9kIDkKsH+ltwgd/7yRT+LT5Opp4bkFH0Tw44CTlHbimZ7pF52+Wl/XDNdxnkaNcbZb9eN8GoisenMci9Al34qJdnoj0lmvfC8mXOYtzeE3nVHHk57h8Z78Xxv9T4sTdCRRRiTgrTErg/hWdxKbSCfdDe7+qlbg69LJxdB3gFC375dJ2MogpFOJWiH2zK98TH46xGl4n0xxwzubGrjkoYSQMJR4ASlS1Z3zCmAFQ9VSGpjEfUO9p
 S0yFf9Cd
 ZVTmTw54drYHYk7VeJSUhcP0WSUvdTPHFY4WQCgazNwMoeVUiql67ob7UOxpvC2kMBl3R7wRqnKrRjGFSwmgq3x3/KwubcfB56P5vlPry5QDnjq63G+/DsTpadYmfbcW+a6zNdu9XWp8b0ASSKslUzlBAGHBqj6yf4REOPQgMKlGrmidXAPLxY1LVxTsipA75WMuWYrSqHp3XAuHMDInf+5mJvg0UmaImfh4Ciht96nG2LMxfLn15kJ1j8aVk0BNRMh07phEkPENCF2akXh3MhpXWJx5sbpuls5KqAKCl7wWdmjAdlhlcW9UeoU/lXwhsscctDxbH5oVIjQl2NaSVqbPQFs/IK02kqqROvtaPqoIEbhv+LqloKkY/RQmqQtdH7JrG1JNAAHIeQr9taNT4vn6dhndEfnrdJWa96mW+deSxxXbL70cRwM0jLWxx+rCF7tVJjW22/+BhndQ90Yh0yj3DuV+Qt+x4XGsJECHO1gA4UkQ4nnH2H6WhGq3fJvezmUTYd9r1FFDXiIBKtx2Zcr4SYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026 15:46:32 -0800 Yifan Feng <evanfengff@gmail.com> wrote:

> On Sat, 21 Nov 2026 17:22:22 -0800 SJ Park <sj@kernel.org> wrote:
> 
> [...]
> > > Do not restore
> > > it for DAMOS_WMARK_NONE, because nothing sets it again in that case and
> > > the scheme would stay off.
> >
> > Is this really necessary?  If not, I'd prefer restoring it always for
> > simplicity.
> 
> Thanks for the quick review.
> 
> I think it is needed.  With DAMOS_WMARK_NONE, damos_wmark_wait_us()
> returns 0 before it touches 'activated'.  So if the scheme is
> deactivated when the metric is changed to none, nothing activates it
> again.

Makes sense, thank you for clarifying this.

> 
> I tried restoring it always.  I deactivated a scheme by the watermarks
> (free memory rate above high), then set the metric to none and
> committed.  After that update_schemes_tried_regions never returned on
> my test kernel (it does not have the damos_walk() fix yet).  With the
> check, the scheme is applied again after the commit.
> 
> Thanks,
> Yifan
> 


Thanks,
SJ

