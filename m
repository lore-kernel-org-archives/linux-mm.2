Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5E5CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 02:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90DB86B00E4; Mon, 18 Aug 2025 22:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE596B00E5; Mon, 18 Aug 2025 22:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4336B00E6; Mon, 18 Aug 2025 22:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 644C36B00E4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 22:41:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2A87B7132
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:41:35 +0000 (UTC)
X-FDA: 83791956150.01.718AAEC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id BFF02180004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:41:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=H70igcBq
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755571294; a=rsa-sha256;
	cv=none;
	b=Khi+1wSFL8UqEK6ZfAT7q76GvsIaTOrr7Ry3kA7xnpXATBJedhwOUCASCmKuFK0KjSgu1W
	RU9ywHBHzFtVJcZPSNeWrQTrK/iGVvSGSmiJqbI6V+2xV9v2l8bvCYeXIpWJd2vnNAAiGh
	1X6xM+OVXGrMFc//z1m3vmcZxrIXcFg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=H70igcBq;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755571294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTBnV4bc3gSI0g52nwjGpXSW5TVHNqW9pyIpZEnrk9I=;
	b=250dU3UAmnxgApBX96g+Px4zswId6SbK/Hstc0kPB3XIEytV7xQg8rOuO6pZv6tmNxV4LS
	Xwqxcwq1V2As6fTi2fEDtkKYtzXWFK1aLYPPxrFOw5IjeTHo3vIZvM2ZQIE4v7o/m0J3/D
	2FKDKz3US5l8s9envF8Gk2puOSSbhv4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mTBnV4bc3gSI0g52nwjGpXSW5TVHNqW9pyIpZEnrk9I=; b=H70igcBqpiQYNo4ugKW1YZfnad
	8lQrxV0D0gUVaU/APagwXs/155/NS4GN7t+bC/zBBA0yfNIjPjhxWAXtRIPkkOw9QdyIlxFGas5Yx
	+QFeKcKhEKJHyk5nArTo1z2LacZut1/Bf5u/YrCyvEv96NGQzlJR5YwWTV0KJoBP1tFOoqPKicLyL
	tks+q7GgC/4zitDwaq3H2Y7WRqHG3AlADNJjQmRAN3VFwgy8h1fywRt6driRb31fYYIhPGlDIie6Z
	ojKTebYkz/dCWa71jznojegmy0VlcGxa0ctu0Pl+CFcG4F9UECWNqFM9IinKKKywDGEfXOhA6bFvg
	dZ89j+2g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoCHy-0000000EwLT-2pYe;
	Tue, 19 Aug 2025 02:41:30 +0000
Date: Tue, 19 Aug 2025 03:41:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Boris Burkov <boris@bur.io>
Cc: akpm@linux-foundation.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com, shakeel.butt@linux.dev, wqu@suse.com,
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: Re: [PATCH v3 4/4] memcg: remove warning from folio_lruvec
Message-ID: <aKPkWv77HMOQwyVi@casper.infradead.org>
References: <cover.1755562487.git.boris@bur.io>
 <0cf22669a203b8671b6774408bfa4864ba3dbf60.1755562487.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cf22669a203b8671b6774408bfa4864ba3dbf60.1755562487.git.boris@bur.io>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: BFF02180004
X-Stat-Signature: o6hh8jpc5n77i31q4naukuqogn9arz9n
X-HE-Tag: 1755571293-971129
X-HE-Meta: U2FsdGVkX1+PiVsArE+krqkUJmJcwQaoblEqjMICK3NusXC2QG8RwELNN5O7YRITV+DLEDXKjXLH5nlB25xsMEiE5BZBiUlrd7Q/SYpZEfhwt8N10Nw91qGGtsFudYHuO3apT1V5NfZD+SqxlJ9txq+VYC8h0a9EYGUWZUjnr6iI7vPyLn5xe32qsREW1soJCtBUlBLCwSyBN1dp6sJ5vHxmV6UJE6+1YA1YUUTlceAkXPhkUA8R8Pj6oAcXlS4r3yjmRbo0dk3/zxCSrkqQDtOrmgIDBckrKxFUT1JDmoBFXo/Yb8GhtJf+hjoI2+5oqpa54w26dsX1eFlr+MLCbQ7TZVeYpfC29j6aArE0rz2GJes1qMUUr/Yn2bc7V4ubT32O/9sXKrPqqOHHDoY4TOkkNccfKiWVGYTcPxyGs/YOCSyiOJKycRH9wy5hv+5LFWZ9hHLKpShM4vpOAsgM5YZfbOfXBLNl4pamODZ23836r8H2/MP3O212P2LwdVMHe/zTtOVx/+nQiOTcg0oMeWqufC8Qu4uHQouVqQ/cEyefXcmxrn708HY7OLvPWdUqnG1pKmi79VMV/RKyPKSqCSRKQkPixN3xt28KpJbecxkKsB0RyFBlbE32BOdJSG+MjLMtpI373SHMeompdFyET3NHgngxRhTLkRpjFnewfAYtpeL4lB71Nnq5yo9QwATLcv4OhMJ3xQ49MqeRe+mgRAy0gBiBwP66zLGGUAwls1eZTWSEkwwYf4BrNQtbUatRVuqRAIf1zTf9bx67DEjKRC7DRBYcr6rYYCkEP9kDm1vceD2LZbFhEQDMeBhpDoikD5/GlfZQJCZtppNK99JrjzaVYoZ97c5yvdmG9vS6z1jwAic9GyU5h4gGZFIHd0L3+XZHHNxEAyerkg6rt2DWT5ePz7tkRpnlPMrBC578RkmzOEH6SM+BSV+ZQCMiw92mgpDpJQ12BmqGzRscOzK
 nb7yYg8E
 fY3oG733uYqOZldgF1z2NjIHGRHmUy3BdGcnoFhCEbUYVGm7GBMi3n0uBzvgjZkVjPTYxhCLEQKdfRRLHi8M8PnEvJceadeEbxqSitbKvezAb0eToCqUTR26k9oeNFKZaPMXK1XvWJGXZ39sFKOZ/6Ndxnd+G7l2PvGFfV46cjJbv6+a9P1ptceb3eWkLbbHSgRCpizRWFCQ0nMcZSWgl/QOFJx2FDJR7tup4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 05:36:56PM -0700, Boris Burkov wrote:
> Commit a4055888629bc ("mm/memcg: warning on !memcg after readahead page
> charged") added the warning in folio_lruvec (older name was
> mem_cgroup_page_lruvec) for !memcg when charging of readahead pages were
> added to the kernel. Basically lru pages on a memcg enabled system were
> always expected to be charged to a memcg.
> 
> However a recent functionality to allow metadata of btrfs, which is in
> page cache, to be uncharged is added to the kernel. We can either change
> the condition to only check anon pages or file pages which does not have
> AS_UNCHARGED in their mapping. Instead of such complicated check, let's
> just remove the warning as it is not really helpful anymore.

This has to go before patch 3 (and I'd put it before patch 1) in order
to preserve bisectability..  That requires changing the tenses in the
commit message, but that's perfectly acceptable.

