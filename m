Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2641CE8D79
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7E38E002B; Fri, 14 Nov 2025 14:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066E98E0023; Fri, 14 Nov 2025 14:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A308E002B; Fri, 14 Nov 2025 14:14:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D27B28E0023
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:14:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A13E1160446
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:14:40 +0000 (UTC)
X-FDA: 84110164320.23.1D4CC7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 155AE14000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:14:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NKERhunL;
	spf=pass (imf23.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763147679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXWIxTYgDKW7ymXXX2xocRgeemGgWv4r6XhejQa5g+o=;
	b=EDWmWyc3ULCY1oWYrtreP3wv2aoZPhnBoa5qzCIcsL2kugS4SXR1BeuSpqr6a/IeD7owAL
	hvGlGcBKp+G4Eyf2SkcxiiPu+sTIcq9Y7YCbb98EGqLjogMpUfqVaxHe3WgIj80SIVNPjm
	VT7P7HGf9rqGAykrZ7k3exc7lUZB2xU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NKERhunL;
	spf=pass (imf23.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763147679; a=rsa-sha256;
	cv=none;
	b=AWy99nSPLVlf0IM2OP3AawkW7AqEeq1puvkw6bndjH3QAusC9vY+WCWljSbT4uaJq3kkji
	AlpZBzkCt0NWQZ9QQXVTnXga3+DTQJjFcdCK4CpEkJFJuzccIdpB64Ce9bCm36ehMciXFR
	N91s9cHKX0vTfJHWhbmYk+kG4lmuCI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7089460188;
	Fri, 14 Nov 2025 19:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CB8C19421;
	Fri, 14 Nov 2025 19:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763147678;
	bh=My3Y9e3ducF2mohQ2n4aoCRXOn2E/nZUqXPJKHyG7oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NKERhunLvJBf9Z+pbC7lExPnhNqVDAAUA4VZjjsu7qvwJWLy7uerCBO1ZSONctBjS
	 hWlS3AbPZi0vH4bImRuWfjtMpNAO6ahOISB1d4BDZk/qGCSzhFeZm7XfThua/Vl3fy
	 8NonjbGkjsMPPuFWPUpaz/G/jCWYNG/rosXtdp4BhO0PMoJYGiD36+8j2BJV34eHnL
	 xVNHeomBCbHCR2MId6g62VCpDXCQjRR6EmS8x8Afi8oEeDIlGw1pSVAq/r7y3a4kl3
	 cMNAswUjrj6Mw5XGfiM+B/3xXQtxpTvPVw7e06/V3cgiKg40/wckRuM0tVoSQ5QcTV
	 Vk5glnzTKWbmw==
Date: Fri, 14 Nov 2025 11:14:35 -0800
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>,
	Brian Geffon <bgeffon@google.com>, Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCHv2 1/4] zram: introduce writeback bio batching support
Message-ID: <aRd_m00a6AcVtDh0@google.com>
References: <20251113085402.1811522-1-senozhatsky@chromium.org>
 <20251113085402.1811522-2-senozhatsky@chromium.org>
 <aRZttTsRG1cZoovl@google.com>
 <rjowf2hdk7pkmqpslj6jaqm6y4mhvr726dxpjyz7jtcjixv3hi@jyah654foky4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rjowf2hdk7pkmqpslj6jaqm6y4mhvr726dxpjyz7jtcjixv3hi@jyah654foky4>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 155AE14000B
X-Stat-Signature: wn9wd3yqids6z5qumiod31r1g9ri4w5z
X-Rspam-User: 
X-HE-Tag: 1763147678-17288
X-HE-Meta: U2FsdGVkX19Ma/4cyL0sZU0tfYk4JqBrxp78tsysWuOws67dFD+QHqNaLKm9mxx1IdFdVWHRaA+m+DcflNIVy+vrmKuY3TOm1i9EtJ1fOqFleUaUUAW17Bw369o2WnYVw/3U2hPXUW6wnjl5QmtdWfI/SdA8G6q8Rlaepz6iaEXb0vWnAFCG+4bTHNSSS+bty478HESfF8iE+mupR+hv9muD13oPXxWSRDRS2pqHO9mi9+NmoEcsDnQfWKzEKhTC58FMRhhqy7su+PbPLXbkvMgwntxES+GlfPcofiK14HSGxxEKYm3h8nU7nKsJKPgpPAKVmb1dAGN3Bv8caQ9jOftfLIKDdSAUZb8jXbqrsyKlwSNztz3ZQH4To7MZDraWaWRXJb+UbpRIKjRltwly7TvKkDe0uCnz/dFDmjwO9d2O+Q0Zzj+R63zawobxOvxVfbUYVvLBr0IlJtDCLEmalyqrT1q1abIQ1GzL98FEAEQZSjUYf3+96q8KcLHeJLQZ6ZohGIGhVEgfRncSptzPx5kNG0EjAel3ZFDf/OlLCVVOevJcT9RSs10oMkTLigCDMnkBGrVOyCv1vuPzfjnAx0KzSG7kY3dMUPzPfTRMI+w73zpJfpGymDSsP00D1orQ0IVwzdoZjfbcHkSMmw5+EeURgXw1hpizDrVU30LDzZa9TqjfNLazpkeG4ZVQjr7v6248vBrxDjJ4jM0p5gpIp0K8GmZDqFqjpTC/WTohdHSjNIi6XzbaRW/7g9NAro33jzDWfGbyfHg+I0OtkaPBoKhgFpQsutJKPgMsTIsAwjttSwVH30pndMMlZS+H/ezFlhk2+rxm4bC2FBaEJa2Qpo71lsfKIAWwotX6gKX+3ohV6CtY7GBDCymXFriyzHl/vReuwJ/WGKWDgEr3I648N9y396ucV6uVzDC2E2TxIp5P6tORDOuFwG+MZpTN01crNsONuySqge8e88Fuwa/
 v5xcscPm
 EyoomRx4A9qUqRtg7fEzmvwMQkPLDHS4Tnf8ejgk1BRAm4lya/B4z9OZQvTPnM3Bnimt+gKMy29B2Jy/ShKnhvUIkBpCtit+FK7MLfVUaJmScg3UrTtF2ln6Q1r7IusEPlxH3Ukr0EXJRAWQUFgLkYodNMAMs6HVg4ftPZZlB57ny0rmG4031VwbZ/3jtujs82oRLuuSYGwe2zPqI2cQpTlQLFiAE/w65bjaYRKeU1Cc+3W1VF0Zc+e6ff9HQPat/g8sXN4fkwhiVpuESqBPrB0wzcSnK3KA5lRGl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 10:53:23AM +0900, Sergey Senozhatsky wrote:
> On (25/11/13 15:45), Minchan Kim wrote:
> [..]
> > > +struct zram_wb_req {
> > > +	unsigned long blk_idx;
> > > +	struct page *page;
> > >  	struct zram_pp_slot *pps;
> > >  	struct bio_vec bio_vec;
> > >  	struct bio bio;
> > > -	int ret = 0, err;
> > > +
> > > +	struct list_head entry;
> > > +};
> > 
> > How about moving structure definition to the upper part of the C file?
> > Not only readability to put together data types but also better diff
> > for reviewer to know what we changed in this patch.
> 
> This still needs to be under #ifdef CONFIG_ZRAM_WRITEBACK so readability
> is not significantly better.  Do you still prefer moving it up?

Let's move them on top of ifdef CONFIG_ZRAM_WRITEBACK, then.
IOW, above of writeback_limit_enable_store.

> 
> [..]
> 
> > > +/* XXX: should be a per-device sysfs attr */
> > > +#define ZRAM_WB_REQ_CNT 1
> > 
> > Understand you will create the knob for the tune but at least,
> > let's introduce default number for that here.
> > 
> > How about 32 since it's general queue depth for modern storage?
> 
> So this is tricky.  I don't know what number is a good default for
> all, given the variety of devices out there, variety of specs and
> hardware, on both sides of price range.  I don't know if 32 is safe
> wrt to performance/throughput (I may be wrong and 32 is safe for
> everyone).  On the other hand, 1 was our baseline for ages, so I
> wanted to minimize the risks and just keep the baseline behavior.
> 
> Do you still prefer 32 as default?  (here and in the next patch)

Yes, we couldn't get the perfect number everyone would be happpy
since we don't know their configuration but the value is the
typical UFS 3.1(even, it's little old sice UFS has higher queue depth)'s
queue depth. More good thing with the 32 is aligned with SWAP_CLUSTER_MAX
which is the unit of batching in the traditional split LRU reclaim.

Assuming we don't encounter any significant regressions, I'd like to
move forward with a queue depth of 32 so that all users can benefit from
this speedup.

> 
> [..]
> > > +	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
> > > +		struct zram_wb_req *req;
> > > +
> > > +		/*
> > > +		 * This is fatal condition only if we couldn't allocate
> > > +		 * any requests at all.  Otherwise we just work with the
> > > +		 * requests that we have successfully allocated, so that
> > > +		 * writeback can still proceed, even if there is only one
> > > +		 * request on the idle list.
> > > +		 */
> > > +		req = kzalloc(sizeof(*req), GFP_NOIO | __GFP_NOWARN);
> > 
> > Why GFP_NOIO?
> > 
> > > +		if (!req)
> > > +			break;
> > > +
> > > +		req->page = alloc_page(GFP_NOIO | __GFP_NOWARN);
> > 
> > Ditto
> 
> So we do this for post-processing, which allocates a bunch of memory
> for post-processing (not only requests lists with physical pages, but
> also candidate slots buckets).  The thing is that post-processing can
> be called under memory pressure and we don't really want to block and
> reclaim memory from the path that is called to relive memory pressure
> (by doing writeback or recompression).

Sorry, I didn't understand what's the post-processing means.

First, this writeback_store path is not critical path. Typical usecase
is trigger the writeback store on system idle time to save zram memory.

Second, If you used the flag to relieve memory pressure, that's not
the right flag. GFP_NOIO aimed to prevent deadlock with IO context
but the writeback_store is just process context so no reason to use
the GFP_NOIO. (If we really want to releieve memory presure, we
should use __GFP_NORETRY with ~__GFP_RECLAIM but I doubt)


> 
> > > +		if (!req->page) {
> > > +			kfree(req);
> > > +			break;
> > > +		}
> > > +
> > > +		INIT_LIST_HEAD(&req->entry);
> > 
> > Do we need this reset?
> 
> Let me take a look.
> 
> > > +static void zram_account_writeback_rollback(struct zram *zram)
> > > +{
> > > +	spin_lock(&zram->wb_limit_lock);
> > > +	if (zram->wb_limit_enable)
> > > +		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
> > > +	spin_unlock(&zram->wb_limit_lock);
> > > +}
> > > +
> > > +static void zram_account_writeback_submit(struct zram *zram)
> > > +{
> > > +	spin_lock(&zram->wb_limit_lock);
> > > +	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
> > > +		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
> > > +	spin_unlock(&zram->wb_limit_lock);
> > > +}
> > 
> > I didn't think about much about this that we really need to be
> > accurate like this. Maybe, next time after coffee.
> 
> Sorry, not sure I understand this comment.

I meant I didn't took close look the part, yet. :)

