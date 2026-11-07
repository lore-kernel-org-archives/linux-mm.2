Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3931F606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 23:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ne2+iWZT
Received: by kanga.kvack.org (Postfix)
	id 1124B6B05B1; Sat,  7 Nov 2026 18:00:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3EE6B05C6; Sat,  7 Nov 2026 18:00:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF31A6B05D6; Sat,  7 Nov 2026 18:00:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD2BD6B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:00:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DD31A03F8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 23:00:13 +0000 (UTC)
X-FDA: 85409843106.13.68D9A85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64AFEC0004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 23:00:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ne2+iWZT;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794092411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nPedpe9fvXNxnCnfL0oF2XIPr3VRkJl9pVL7wPawBk=;
	b=FgOZ8UFheQU/bFD7wAIoTXh2pe6OpE3UvZsI5nILfholMup5qiAdWu9cr+Z9qn9Uh7aHAk
	wK0PAPffpmWUfMZXUsHlI8zMfh3dBICMjwl8kZDJsi5cZPeXVo7oHecBcMDnz8zdBw+PyI
	oIYNMxrkzIoPTVRepQqFg/pHtDYlwfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794092411;
	b=6p+qdIqL2+RdxiF1jKGTltq3H442doR0wpSTF2N2oBESI0WAoZAe647FKLRftb4PZZ0iJB
	t42r4RHbVs7h+e97n/NjC4jlIIKyW0Y6ZhiLjfuyH9GnJFdGHGDKZXjXarg7rOoWN965gk
	Joz2Nh1Ol2KJ7cgSjrp4rwcsk2Td/t8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ne2+iWZT;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8973B402E1;
	Sat,  7 Nov 2026 23:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EC51F0089F;
	Sat,  7 Nov 2026 23:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794092410;
	bh=2nPedpe9fvXNxnCnfL0oF2XIPr3VRkJl9pVL7wPawBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ne2+iWZTrSTy58Ahwlyxyb0R9k5m1UmL7ars3odDrkX2sDT9klY0gUPSfNaYiyW1/
	 WhRvS2QRDgdBfvPQR+e+yNnX2GC9eLj8HRJWE8Tn+9s+nv3o8Wpt8r+EPKhBp/iODH
	 kJDI/m5MKooUAXTmph9rDYBeJy4rtHz6NA82UTAAw3yF2JeLNt5p5O+gwbmCTa3jen
	 rQqGk8BByLRlqIjPfIM0ABpvsRGbAzUPK5CnO/V2blMmgP0J3B/58TUdyAmrCOOJMt
	 UonnMEb+6Rx9dVPtfR1Q6vLoFV7bxyJtwDzptaHEQra1J3lnBE6+POQ7ZgvekNfaR6
	 dZjomrnvy/Deg==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Usama Arif" <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.1.y 1/2] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  7 Nov 2026 15:00:02 -0800
Message-ID: <20261107230003.340646-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-203373@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4okazzbrwb3z7ms556quttheudu1zi8u
X-Rspamd-Queue-Id: 64AFEC0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794092411-293918
X-HE-Meta: U2FsdGVkX184aqv6LPHSW5XEDJEPLB9wO91ABe3rHw+CSeDEmgpCpi4eFShuMV38OuO/HjP39ZHx+SIWUT5aBChORN+Ma6DBPcgQC9VDT7LT34fBSljtFLgn8Q9qHLAJ4G1xAPZSrQskpEJjk//sgDqYyGwoNau+PNcgKZxcm1vKzQK0YStmGbcrdgN12jot8WmY+4FgiiCgCsLT88js001xzGfrwVw5sbuTozv/hwubqlRpdbJ9I1JwAawxUQjv1ZmWoB+KaefYksLRcoo1UQ5iSoXjWk9wAzNbhlRW7lNLNEbTQX9jxSZNbiKSDfHR8SbEbbBCqPiUoNw7/fwZHO/5gUjkVPPTTqp59h6b2dv+TcZXWtFnRmvTHGwItilN7wPy5rv7GvJRZZXTrtzFSl0ZzrDSjeHskES/vI04gWhXpxq/8QT5vSRWhgfb15cr544z29fFIDNS68hRQGU8oI0npCaQUWTCgdPsaqRLxEx7ccHa31k2DfFKyHBq3DVWQIgrzor1mSPwHJuc6aYXF/V9ZF4sPL/J8kz5onXmKsB5BbndBd4Ol4iE1+VDkvZykbVC3ZzikOROI3em+Gz0OtuUQCZgkU9eZISH3Mv8VMJSoTsHXnRSvcbskyneL7B/wYBAIcXfSwWN1etvPLNZuhNZjfjyAYSgQPPJ/DQQM9iooftyEb78DvOeZMSE5X7ADmyfzD9m0c/MKmbjzATNNdPaL6KXY5zUqN3SEpThE+P/4QyyxdNN5T1UIJWI3F0iuOGhJSA+eXuRXrtLgmKKBIWztFlysJc8WuRZBaAWX6NrS/tHt0umJntaQakM6JTRuI6JLvmhqYo2WVWPOo0gAPncz6zJ8/LqJzXJRQmt4YEMfVIrn/uyKJX9hRLpqnTx+F0pdxOnhX5JboByjgDKciKB43dsHH1Ho4Ccvwv2/qXFzpCGnSekBoOoLCLoz6jDkwFUaY1PAetGi/Q5sW5
 1mcL+u86
 /QDazeSz/MQiHBwybXNNxCcdU8sKyCZBT/Or1ckA6MgD2FLiXaZQBvMYeANKb8x1/sM0vmBxo/1L3fL7cmQX5EJiI+dDYUXTbcquXYKGfgUVOpW+rc1LVeAyh2PCSi9Ze+27KPreVvoQI+DJ7CZnsjt3cSZm8mmne47fax4uy5ICSh/MmLlMYan6BENcLbxXXZ4Tt1Ijar5EPtzuJwAhrtJLu64gFBPhQVM3LjOddjHljxlEBq2DURru2cZCw77UOqNTr9tEEoqenE6IR11h7cVp/5vKs1pYJjI2+Vd3D8oCxV1rX2sMO9sHeUyH7TxQvBf6OkenSgItFqZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 22:56:53 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/damon: inflated tried stats in damon_do_apply_schemes() on
>   split failure
> --
> 
> commit 2d405ecddea503227b3b4138fe63cbeb95dc50b9
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: skip applying scheme if region split for quota fails
> 
> This commit changes damon_split_region_at() to return an error on memory
> allocation failure and skips applying the DAMOS scheme in
> damon_do_apply_schemes() when splitting a region to fit within the size
> quota fails.
> 
> Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
> Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
> Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index f0da5cb2b88a0..9206737d05ae7 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -810,7 +810,8 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
> >  						DAMON_MIN_REGION);
> >  				if (!sz)
> >  					goto update_stat;
> > -				damon_split_region_at(t, r, sz);
> > +				if (damon_split_region_at(t, r, sz))
> > +					goto update_stat;
> 
> [Severity: Low]
> Does jumping to update_stat here inflate s->stat.nr_tried and
> s->stat.sz_tried when damon_split_region_at() fails?
> 
> Unlike the !sz path right above, sz holds the non-zero remaining quota
> when damon_split_region_at() is called, and update_stat unconditionally
> accounts it:
> 
> mm/damon/core.c:damon_do_apply_schemes() {
> 	...
> update_stat:
> 		s->stat.nr_tried++;
> 		s->stat.sz_tried += sz;
> 	...
> }
> 
> Because c->ops.apply_scheme() is skipped and quota->charged_sz is not
> advanced, any subsequent matching regions in the same pass that also fail
> to split will repeatedly add sz to s->stat.sz_tried.

Good finding, but the user impact is trivial.  Same behavior exists in the
mainline, too.  Hence no blocker for this patch.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261107224800.340250-1-sj@kernel.org?part=1
> 


Thanks,
SJ

