Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A301BCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 09:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9DC6B0005; Tue, 19 May 2026 05:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180F16B0088; Tue, 19 May 2026 05:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096E66B008C; Tue, 19 May 2026 05:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F009A6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:18:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ACEDF1A0276
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:18:40 +0000 (UTC)
X-FDA: 84783619200.24.862B59F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3BB79C0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:18:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=EOvWqHUp;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779182319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L82M7VndxXImrJA2IRCWkM1Jp64hYOMMt3VfiUn7b1k=;
	b=mVbmTaEkA+yO3hz9j8akbq06wTTX8eUCUY1WOlg80uJsE58tZjQol0jGaHBWT2t90Ob0bx
	9GOewa5PpviuUUPUkkM7QmLrzb6mq+cPdO2K0BZrxGi0GpwNZZbMlWGjA+bgEZMiRmZirc
	/01gJXEmvTrL7iUsxUmJ9EkrpL3l2BA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779182319; a=rsa-sha256;
	cv=none;
	b=QC9QCLEvaNz0Jf2Fq3l6zlTexee+v/K0XHeQ840gfPJAkfM8bq8xcO07Wpmb1YMvz7LCVR
	cpo5b4dhfusTABo2O586vjbbQCUJaym9pBQS3pPVgfzAee73mbHLIuUQbbBWHf6ADt/m/j
	4T7s1OdPhn7fnemPLE3PV1vkeb2+Ghw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=EOvWqHUp;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=L82M7VndxXImrJA2IRCWkM1Jp64hYOMMt3VfiUn7b1k=; b=EOvWqHUp3weEfboRVxTvPcKJ0Y
	uXszc7YHyb3vYtW6l0u/3VB4uwAUvODUyU8a8ajg02YHGHqPk+mWLs0jJ0Cjlf0cLEAPcJzqSua1L
	r/gpmvCG4D1gmpmFu9PpxambapPCLPHAFYhsUfTITImDXLRQadart3DF+wRrsRpvAApnFvMb1BPUK
	u9ixPFhF25NkZHvQ2UW+T0RSxTDDiN43vd1C3RNOQaqcWGRa59nUfuFoW7VZAAS8dwplcCZ+cdB3R
	wo2NcBK1UoMKEMf/9NIml7KNJ656tg8N/kLIGhx7VDZifBX95zbwipTIYufLkC6eZfOQeyE82j9m4
	1rV1MjZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPGav-00000000tER-2V8e;
	Tue, 19 May 2026 09:18:33 +0000
Date: Tue, 19 May 2026 02:18:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org
Subject: Re: [RFC PATCH 1/2] mm: swap: add SWAP_FLAG_SKIP_ZERO_CHECK to skip
 zero-filled page check
Message-ID: <agwq6UY_4E9VjMMb@infradead.org>
References: <20260518073455.2495934-1-youngjun.park@lge.com>
 <20260518073455.2495934-2-youngjun.park@lge.com>
 <agwDnPXJSDIjGkpC@infradead.org>
 <agwMcxlf91I1ZzFU@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agwMcxlf91I1ZzFU@yjaykim-PowerEdge-T330>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3BB79C0005
X-Stat-Signature: uz9r6y1ije5xn9e6oiqxikg3j4w86jmb
X-Rspam-User: 
X-HE-Tag: 1779182318-785623
X-HE-Meta: U2FsdGVkX19GW+dqOxdLG9SYuGD2ExQ/NnxvpEo8WQUiYNxq3wsOuLpKA7CV8Hjyvau7L0vdHKPVMIwUOjiIrZ0CkeX9r6/5LVQTJJmOrTK0PIDaooKXSiM7REtdGwCFVGCEWhXrbYY6cCDmKJ3tlR5PTOjWnbsppXB3rKuT7DAVbF963sbCZsuWUN1NQAlMfHEiDPuoyjJS8rQpbQuwTqCWueMWyMAtKpWlKpjA+Q7V50b0ZppphZqzufrRSg4awZpXqBg2mx/C0ZNAEWcKy5TM0LOxOheuLMAtZhQJ/6MkLXVpZpAozcD0xZvGuYD/oz4I0scUXsBoSmZiMxJMlpOmbKrkvHqoe32DdtD/r9hSx+W7Za2PfMUyzrcagMezBIhjb6IW5RhOjPpBRa8v21RvdG2TsczbUEnB+RbxL2LBHbDndHmGhkGUllGZ5hM2o+4bWLyUd3RKJJbGf9QQeUH+jWbEfNw6t6Y55kwMPlcdmQ7Vx1S56ndozxHpPZAqK4cn8vEYOmSd/6QHRC+SH/uk0BLHn1AlN1/yQQsq1RN9Tb7ardZOli8Y2acjJyF367pWSwBHvEVsCO6wxzgHiEm07YEgOX39poZkRPSbv4ttF+mzpT+grvonWu0RhMDIYpfvV/CpM3fAil5ixNzTYIqq+hIx7JmxoRAuWQFsS1sK6Mm0/40o+0Eucy9Ai+LW7WIs1kEk5pTTUOyZs4N/57r9/buRxOJ8l4PAE4i/K1qjC3USa5oU6fS15oJZPWrnx8FjKe9BI+4UY5uAoedJte/0z6K4UAa+H/IJaB4aukDHlkeyC2RhjVO68tWCsALXtmzQEETgmGkuJNHftCi7y6QIYHH5qYW0/3El7njzxeJrXjDMOyfzNPp74A9leqG9wCBuJWxgKlwd6+0S4VGrwc+Eh6avzcfUx1pUNFdNCNSl7yoKbBpjpWCI0bQQEJGbsEoVijb8AoDy+TcPZZB
 HaMiHXHC
 6VAoh41AKMHgx9KHQsOPM8ZQiUbtik7eHrbNXTaBtS081s4pIF/fAdows8OPL/Z00Znb5CqCsaI/vOhTfJG1T06OHznRz4Z+s970d1Jia0U6+vFZvrJZGMfExW+3FLzeO/3QaXnEzvZfWz+TGwzXGsFllKoR9dqPjKsLBrtbQ2pHopQENDObs5DTQ77cBc1QezuxTuxFPT1dd+3gmJtqh8CAi0ujrJAj0RDgRYvXkZGLsFd3Yots/sBp9fZuBh3CEYf62mW3d4bjNtrNMwhkE1/BSFd5bzUDJXgUyBoaNe/IIqd5Od2Wm4B7uitN30IP41Xq9XWn8w3negmO0qJZMqjJkCm5tgT/MPNikyl2vvweM4O6jAKT0bAdN2Fr7uOOliYye+eLX9rSw9ZqhJMyBdoEoAexEwyQ4t8pcMqgwgbRjqeXTCoKRZwXBmW0BNMOPqd+C8Dc1BYdCIK+zUIVmtLnHrHX6k5N3tVFTUEeY9xGINhWUAFU3bU1FjUJqsoYDiAi3t2I3gYCUrXZdAtakCmav5r2IBkJE2XlmQHcpUwcWjv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 04:08:35PM +0900, YoungJun Park wrote:
> On Mon, May 18, 2026 at 11:30:52PM -0700, Christoph Hellwig wrote:
> 
> Hi Christoph! 
> 
> > Nothing in this patch ever sets the new flag.  And I'd rather not
> 
> I defined a new flag that can be set at swapon timing. Is your concern
> that there is no mention of the user-space flag setting part?

Heh.  My main concert was that I assumed it's a kernel-only flag as
SWAP_FLAG_* aren't defined in a uapi header.  But now that I know
that they are user passed flag, my concern is that this is not something
that should be exposed to the user because it is a depply internal
implementation detail.

> 
> > add new weird bdev hooks for zram when we really need to consolidate
> > the compressed swap logic in the core swap code.
>  
> Are you mentioning we consolidate the same data pattern logic (including
> compressed swap) into the core swap code?

That is the plan based on my understanding of the LSF/MM session.

> I am curious about what direction you have in mind. I can think of three
> possible approaches.
> 
> - Handle it in individual devices
> 
> Can be optimized for each device. Currently, the swap layer
> handles zero pages but not same data patterns, causing a mismatch. My
> patch aims to resolve this. If we prefer this direction, we could even
> remove the zero page check from the swap layer and let individual swap
> devices handle it.

I don't think devices should care about this at all.  compression and
dedup is core functionality that does not depend on the underlying
device.

> I wonder which direction you are considering.

Please look at all the ongoing discussions on the linux-mm list.


