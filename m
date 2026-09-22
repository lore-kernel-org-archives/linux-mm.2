Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A479AC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C316B00A1; Tue, 22 Sep 2026 05:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F646B00A2; Tue, 22 Sep 2026 05:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635E66B00A5; Tue, 22 Sep 2026 05:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0CA6B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:47:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B95D21A03FC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:47:56 +0000 (UTC)
X-FDA: 85240921752.08.5E00539
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87CD9180008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:47:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IKLmrhNR;
	spf=pass (imf24.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790070475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESfq9ev2vYHZ87uhtFqo52tyGA1fGwFni0ed+CtCQgQ=;
	b=yBvzXTyhau76G1aelHKEdsyyJX3Mr3WjeuFTGzguV/yLr28rKya1yV/oSR8HdU9ZMDi3sY
	G+JokdRTr0dDygLOCMQNDdAdCAZmp3b135MLR1Gm8KJHBivwkBWfOrExV4TTqMEFwz1Zuu
	tkbWKOPFzoxxB5XW3y1KipQHbGNDi6w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790070475;
	b=3nB57lwI7rF7F5MsEDzlhffWqYq+e8bOXRdTYst3jUPQ3LojoYHjXbl3RDcSllN2erOiup
	Pjf1yYjQnyUXV+bR/zn/v8haBw2u+nQLxb+xwEieNu7vBu4PgDcNCJLVyCNns0o3r0T4dU
	e0GuomjOOkrABAzXxDSroVAmcpCkIMU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IKLmrhNR;
	spf=pass (imf24.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAC131576;
	Tue, 22 Sep 2026 02:47:49 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C0ED3F528;
	Tue, 22 Sep 2026 02:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790070473; bh=rrBXrUQcOcOTfzP6wbCiHxJahN45dpxh528Z+9Tu99c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IKLmrhNRyFpezR6tHva6Ees7rZuSKc0N0nyLKOJD3tv0og7n2NYCkDAc0s1hn5cD2
	 qppUXEm6W+5Nc7RkxNuv1tnVLIMYEsrk8j90cZCgRmn8OEkfDYQseFUgMBuNOxn2VE
	 mP8chhFgjdlCaW8uO01M1rQ2v+nvFzyZ5UVm1cM8=
Date: Tue, 22 Sep 2026 10:47:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm: kmemleak: move the struct page scan into a helper
Message-ID: <arJOxbz_phnaqWD-@arm.com>
References: <20260921-b4-kmemleak-page-scan-v1-0-fb97d4801b3a@debian.org>
 <20260921-b4-kmemleak-page-scan-v1-1-fb97d4801b3a@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-b4-kmemleak-page-scan-v1-1-fb97d4801b3a@debian.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87CD9180008
X-Stat-Signature: iw7bzr5pcmnhdx8111b5zpianmrzckpe
X-Rspam-User: 
X-HE-Tag: 1790070474-434473
X-HE-Meta: U2FsdGVkX1/yfVtdY0uFA8XGMZkdHRX/kNAeyJ9sbwcsIPpEoMZCklMtg0UdaPbmuJfFQUTJLVAuCxYZlaYSIA8SSN0ncVe9zrG2JpIJXknbneDhqPbQtvQ7sTj0eH87VwiWBgXmCjDb1sUH6qA6VTBMcgKpKaR+NQ77YW33ZtdhBOc6R7daQtrJ6+R/1k9h1rVK4h3XfbCCHHkKgqpOcD8PjsAqgw8aedQ+fA9Ga93TZqr6b9NGRcU5ASKke4NUdZdQwmJlOSvpbPlWbbrZFmxp55ZPFdrB1DH5Q5U9WfJovsyeWbshmPN7EFzo41qKGIxx2gaNHnTDAGT6BIz+9o+7YJ+gszcxU7R+2I+TcUsSInYcr3+pS7pLybsy9E1hRIKx4+chXJYmdSaSj3PFtDUrTkbLsS3thKJ0BOYG+dDIHdiYC1T9siM6CVnc/d8yXz0JBWj56RSwwEUM4zhAqvjZBleFbcR6MAg1Y9pT7+bSf7pD+SqHj4Lg5xd6s57dKAP2Tc3Oux+5tmeuDGapzKuz3hDt0eQjmeh/GfcDgmD5HS2H3F9UQbUalKl2T7aRD0CU2/M4F7L0VDdnEqR7LYhXFTeeT/8MnkCmJ5u/Fy3F930fNaTVLJuH5C2sMCTPCXz/GYX8mxKf4hC3WoDDI24BTi1hy/l4BdyeQuUUjK2mE9SJNPkoi7fgLI6ZajOi1ic0eHYaEPaY1L4fTFswfviVsu73CQjkIvyQOO8fiTRXiRcaqFN3BKrXTHlxrw7ads3mx3ewEncI0aEmUpcLKb9+OO+6+m0Oe5zKAJjfsgxll3kj4wECnTGZl+uAqUETEoUblYGtOMrjrEuySsK5YGvcIMzRGd2KqzdcIXD1Hf2eyX+4dyxJWHN+lBdJ/bM+EYh3rqSZxSgAVYHMZrTdwZVMYM1rhe6XjL6KNN2d2cFUyg5vbymXo8QoV06fKsggYiVm8asBeErPq2lI6W3
 TM9QWQzj
 7QOT1cTDpQu/hrops/A+ll62o3IIam5X/5a+ioYCaljXErBiy/7bxckKNcBeiyncG+l+zFrcBTIDveUqLVFvHXpeCsdlQv2SzP7MJShyZRVmIMocu/JR0eOMUtggBlhUuHhBPqONp1NJPtA/Bwz7rIXofnKzQHn3jDB06Y+1t87zjWa7dYiVF5lFTfjl7ftYIQDyW8hX1+UPsXkrgcr4w2JkHGSdDduP3Sbdy0n5UAc5IA7z5d3bbfE8bI3f2mKOVh/5FyNeocWimHzSC7zJcb5+HfSOg+7eMOVJSdH2hNxMSvo5DAUqvT6mRfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 05:30:26AM -0700, Breno Leitao wrote:
> The struct page scanning loop sits inline in __kmemleak_scan(), nested
> three levels deep and sharing the caller's "stop" variable with the
> zone walk around it. Move it into scan_zone_pages(), which scans one
> zone and returns 1 if scanning should stop.
> 
> No functional change; this only makes room for changing how the pages
> are handed to scan_block().
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

