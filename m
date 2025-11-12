Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC880CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252808E000B; Wed, 12 Nov 2025 10:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202D88E0002; Wed, 12 Nov 2025 10:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119838E000B; Wed, 12 Nov 2025 10:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3CCA8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:39:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C8924C2DA
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:39:04 +0000 (UTC)
X-FDA: 84102363408.30.A21D0FA
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf10.hostedemail.com (Postfix) with ESMTP id A3AF2C0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:39:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762961943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qRs9p9MJZlZc8cBjRpc6uDxFCSn7gVGK1HgTONEpPx0=;
	b=Gr36v1jRgAd3q3ydNb3ke4mePB1c9V3zDSmAWu05eugsHo0ROYKtY2r38tT5zO2FRPEmMC
	KCJxllQFXQxG97Pv8wtNoJWh1csZO92+nOU+zD3jMttWNgA8qGc1cY1K/N1pDRwFVqM9Uh
	VHX9uA2haLwA8rX9iMapeguVhwL+Vog=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762961943; a=rsa-sha256;
	cv=none;
	b=NBA1mfFu9jdVckjDzCY6jLXvk24AqB/lsqs4MVqd2l+j+t5WdHleQVJ6qHV2W4PJXZpqUT
	1cZT532GEIhcFuvRc8MBxpSQKrWTANq/ueUzR0wKPqA/Iivu3eSSJPXOISboDQJk2tUUGn
	x99uYmU3UyCTFT1wBGP35sH+wlZFxBE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 07E206732A; Wed, 12 Nov 2025 16:38:56 +0100 (CET)
Date: Wed, 12 Nov 2025 16:38:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] mempool: fix a wakeup race when sleeping for
 elements
Message-ID: <20251112153855.GA7209@lst.de>
References: <20251111135300.752962-1-hch@lst.de> <20251111135300.752962-7-hch@lst.de> <dec19492-bc23-49a0-a2b0-1cd8b5c7726e@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dec19492-bc23-49a0-a2b0-1cd8b5c7726e@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A3AF2C0012
X-Stat-Signature: ytmzt17jop6mo8gf6iycffitmnpis444
X-Rspam-User: 
X-HE-Tag: 1762961942-8814
X-HE-Meta: U2FsdGVkX1+mdAE6z24CpAEY0Ukb8JWQtrSSsUEuZrAinu/EBG9ed1fWyZk+yXTrmt1FvRHS1bauqXWItlsAhlKRBg8C7SwRmYbg9s4eJoDSZNnXTSk8zu31R7IH/rY6nCPTPJXczsGc4+OvXDg/66f1BiGrytOqL/6LUPH14QYZvDu4qaBJv937vUwEdPFgDA6AYv23jTaPwUtL1h2eKIJr/vLbMnBo1ioJvHX1Fo6XqNqT2wBT6C+s6ZI00Ul6EHNiuQP7A4gzgon8Ocr0hYzL6FGjdMyWOTUoaA6HSH2hX8LaqTUXodx6Lbhmsyb83mwj+RkwnK54Ntqcyh+8vuiNOf/PgL9P/Ty9BGOKGNAkzraJZ5xZmzdbf9zZIiknz4JNQEb4TM9MLXzFMK1Fel0FE9SJI1PRMH2YEyPuvw27UgMT8Yt5ocbgf3+C4yLYje/t3qQQ0NAgREwhyTZjTspSksWYP4QarHT9tthsncg1LaluuK6zjzlibl9D+j6s8zaPnKHTNhg3C7v37Z2X/5OgP/p90v58Va5AkOHfzSGrmS7ic8EVYjhQmmT6v/8nRkUyY1pZBPOz6H0VSZ0dWj3aTv3+nmpo+OlabzR1PwKSDIDfEwwAkTrE0A5sHBc4pWEd8VFnCTsbc43ZNMtwZlSrsflsQANPsfdCGPiDpAv1KasYR30Bnu9nM2scB8oN2mnPQCkmOU2vtnwiNnAsUas6arIc0IRBV6hKBHYApw6NSUDOGfCDy5Q8mSVruwgO6PaJz1oXUFExtemQ1Ohj7zInVfyBxdB8GttM8d1MEu/NpQLm8kKbSKPEQzZtmN//ex3v3tAXwl41m5xt43HV0nbAVFKuLkvQXQ/ezgFAsSBV/1ceXjYkyFs+G5YY0W/R7IlXg/4sbpKb6zs/nEDFpM5xCC5gumv/uN5snrU3ZLH2atePHRb7Xt6GUl9ijBNyiP9/vl7MSFCgmJV8g5m
 FBUEyufo
 VnU/P1fAiaR2v4giwS9jPucYXPNErwkppmXeJoNxbQmjmA6Qci1G7pYUdQ/5kOIi5opsW3zQcHndS2wp0miXvT/RQ+uhuCOaHhzVc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 11:53:39AM +0100, Vlastimil Babka wrote:
> > +alloc:
> >  	element = remove_element(pool);
> >  	spin_unlock_irqrestore(&pool->lock, flags);
> >  
> > @@ -406,13 +407,17 @@ static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
> >  		DEFINE_WAIT(wait);
> >  
> >  		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> > +		if (pool->curr_nr) {
> > +			finish_wait(&pool->wait, &wait);
> > +			goto alloc;
> > +		}
> >  		spin_unlock_irqrestore(&pool->lock, flags);
> I think the race already cannot exist, thanks to the pool->lock being
> unlocked after prepare_to_wait()?
> The freeing path can't bump pool->curr_nr without the lock, so the condition
> you added can't even be true, no?

You're right, I'll drop this again.


