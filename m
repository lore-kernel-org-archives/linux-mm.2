Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F27F46124
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00FD6B0088; Mon, 23 Mar 2026 10:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8456B0089; Mon, 23 Mar 2026 10:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EDE86B0093; Mon, 23 Mar 2026 10:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0816B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:05:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38F4E1A0BD0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:05:19 +0000 (UTC)
X-FDA: 84577499958.02.2CB0111
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5126D140002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:05:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sAzlVBX4;
	spf=pass (imf09.hostedemail.com: domain of 3m0jBaQsKCIYtyyx6yxukxqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--joonwonkang.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3m0jBaQsKCIYtyyx6yxukxqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774274717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwrjwOv/nfR0NzxXgLyB1YRlwiln3ZEhnwpdsPSwI7E=;
	b=FPMfLVYLrugZ9HZaWvnX8Q0ZBGgpSvvZqVsJTquK5aUpYC/97nzGi1PWcp53S3eR+SWN05
	lU0oGEkpjqHn7U+9LE0oNRHj8jFHEn+P6M226R7s/ckyrva7kCoBr/vgEJuI8OxAt7WZQj
	rLSywfvRbs+O4SBSkCapVTMVXPVmAcs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sAzlVBX4;
	spf=pass (imf09.hostedemail.com: domain of 3m0jBaQsKCIYtyyx6yxukxqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--joonwonkang.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3m0jBaQsKCIYtyyx6yxukxqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774274717; a=rsa-sha256;
	cv=none;
	b=Lg987I6VbrShcIBeERE85Khx/aLEkt1aqRlANKFa9TlE61qSCjVFo3kxicPRYXmc4xD5tP
	2oXGXdWyf8BBeEWRaqlr1PNQdraZ/EWQep7qlvc7N3qYM/nmGQ86IsUMJfP1jPAI30bKZd
	URciEITEmFyu9WoojRFdz7o2di9PA0w=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7381a9a932so1771289a12.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774274716; x=1774879516; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rwrjwOv/nfR0NzxXgLyB1YRlwiln3ZEhnwpdsPSwI7E=;
        b=sAzlVBX4jDQsIhCbNvG5mrHRnQVZZyWXO4ZcpPdBnE0sZ+37AFnF3C5/+NTeUVtI8B
         tXvrWxErKD8ak7uNEkJQZMtArkfnYv0doDS2Q5WnPbHQpN+228fpaAzqyKjMYDC9Rg7s
         FJMPryvMlVBKKH3/noDfj2FYUtrz0VMFLrGqwY5KhI6tImKQmCO8cHPso8/DLNYg01rx
         3jhLLxnSlYE9jnJPq2u3ZKzoEjrJ/MGUafw3qeG4SglY20hF6sPW4+dZ+AhvbUAg8aTG
         ZyBvUKuNeylpMvczyzDuA2AOBKW+aoapf19B+58Aa/sz5e4YN7HC7gF6FKrJeXgxTr1r
         4ecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774274716; x=1774879516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rwrjwOv/nfR0NzxXgLyB1YRlwiln3ZEhnwpdsPSwI7E=;
        b=Mh+8UAu0Mx6sBq7dJoN8xpw1c9uKOTFb1gyfaohLUnUcwdRnZWYwIWrTvFtzeWgjxo
         frt2542H6Tkcb+nhf9djjYTynRf6MXnCrkYM2zFsm7lYCcnrJoLRm2QNdCl/BNTJzZ07
         eSb0146jjK+cvHr/nZ3XwL/PPyWpPed5enH8oE7L/f7G9xRwKogmcOhgTx6tRU/IyuXO
         kStMpFvUpCF5/te7lN0xccZZnvy2CyQLAN5gzulDW3Gpk4Di2S7Hbq+RBP5Q0sbDpH4i
         vn/bsfw2fEqaC1JMUYhZMCgwXlnF4+bnsCZ4Y0R5PsZaNfIPbPtxZEYXb9jZSMuLsB7B
         y0Rw==
X-Forwarded-Encrypted: i=1; AJvYcCV1bato7j7gziWyJ6NqFpC5WaJO1ptti1we69B7+hrD9SnEFHp/SfZokFZBeENJzEV3wwdiXUwGtw==@kvack.org
X-Gm-Message-State: AOJu0Yy5sMEZs9oHWPNXLOevSPbZhlgwwEP9fYPg/AXIzdEAccfzSMx+
	I9cRE3PJTNZKMns8uqgbX2Hac1F8lRopbb+5mrX6KFmE5KyQgIeCrltHNFMZP8FI3fbaj3HZ0/G
	Mt7fx3/Ca11jTij9ii056RPVv3A==
X-Received: from pgbda10.prod.google.com ([2002:a05:6a02:238a:b0:c73:9264:56a5])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7fa4:b0:398:b95c:51f7 with SMTP id adf61e73a8af0-39bceb47778mr10636206637.37.1774274715858;
 Mon, 23 Mar 2026 07:05:15 -0700 (PDT)
Date: Mon, 23 Mar 2026 14:05:14 +0000
In-Reply-To: <ab7QClPFaFAWsxBh@palisades.local>
Mime-Version: 1.0
References: <ab7QClPFaFAWsxBh@palisades.local>
X-Mailer: git-send-email 2.53.0.959.g497ff81fa9-goog
Message-ID: <20260323140514.3487563-1-joonwonkang@google.com>
Subject: Re: [PATCH] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, joonwonkang@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, 
	dodam@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 5126D140002
X-Rspamd-Server: rspam08
X-Stat-Signature: mo7ete3fuusejmsg3ieypxgpkgd597rz
X-HE-Tag: 1774274717-529130
X-HE-Meta: U2FsdGVkX1/6RdklQcoVCxndt7iHqMcydhce631v5bQGIwXhqPHsEeS6PPxNh6+Jtmgch/8kLedHJEOxB/FResFaZoG+BfHANhKS7RQejk/DVyJ758wo7AlqmB+V1xtPQOLCpo1n8b/qUYvbyi1CwOsQIkcMgPO+rQYwSjTYVZyLAkoXgpUxmk6DXptsXJWnnMBYwmrXiFHVsZ92TSZ1L2SSp1txs1Dmz/TlDcEE9dWLm4nRnoFPemtSrHMiRedzDpM2gch2lJvIpYkEe3FbvFk5qCTP8cLZvOfGtjOGDYehxiiV/MJ2/Z2ZN9Ov/S6w1Mr31YssxxTlrQaUq/kKvYhreYuEGrRaNmTmJQmqHMse1iJ7HMGZvvayQDl/qX/VLVL7S7NWZX39HMp51ZxbE6jz2SNou+gwWcnMDOAUdWU0otaMXwEMrVJMnJLEnLJSCZ3C/3BXYFbFPKtFcGkkme6NDGil7EDiwX3/rxm6nES6lKA7AFZ9lZgrsItNbOk9bOJAUzcp35UA760W9nC60dG+NE/7HJQZO3ykwjbslSP77KWu2ApWN26W6SzzPE74CR/15nlEy7ij+L2fNa716XWrit6LvK6IyAUQo3ZevbQMnYPAOCEPbkR3zMQRGSsvZI1dWHalcifwNO9pwtHjhmz3oELDSsbSPizn382b9+Qo4wZjaabHgBA1VQradlHkN/c1GH6+bRcagjm8TVNH3nKOGuVDmUQ0yHVByu5Wz/CkqYKgHkIsOL0VjfhWyctII0LXcA095LJGgFuIeWTq+gYxCq8UbXfRcXjP+8AHoKZOqOqO5CHI/KQHRvuaHoEeKoSIEiBYHje/khXZn+Zqj6PVfBnwoWKq8YeRo7lM1H71CFZcAAk8fDD1Z0XnPht8oygMq+EIuHZor4sJjus6bW3+2BI1fiKDdOGa0GcyJ8OQjnh39q9ZBrdDx87Hqh/uNEFGDyE0psaDM7JkykJ
 6f2QqtLj
 cS2pwKyoJNb3f+gf/YbOmN/vq9m0SM9+EBAAKx6BW1kEP3zY8k0ueSkgPKuQ3C9k4pgd165MPpEKauEmAcbkwt4fysEmcs+y1SGHyERaWoBTIN9Bjui3ESfhLCTbs5FxsG8tW+8F7s2lzJ/IIlHR7zYkXo8qrlavPHkuk0502Dzy3IpblLJsxAuaQQ6cJGsOTh18s5I1qwV/uc/RoTF/Sfu01AHAEqHIKY4MyEKGMOtkqPV/rVlW1ayRHjo+wN50lFOegVv/dYEOUNimuLJlZblsnUScDFJ2n8vEhnMF0UY+eeC1ycdXTptctojS7ymP7MfQD8DbcU3kgxFz8fzx7Xy97jfQoY1KivRnJ7p40zIRRPbEmql1noW0gv1XIWJtZqIr9wZf4pu898eK4z2SMTxOXZHpmg/8AoRSovd3sfXuvKh6i1M+JAFAAlwevE7qxm+0SSecxt50Rh+ih0XAXuh/GGXfS3qHc2TbH51nNh7/ONDFDsVWZ9g311UVBrrFGn+U9+hn9Kf0+3CrNAYnXLcEMHgTZRIV5+3HiOr5sqonHiAM7LriozTqtNepLq4YstZcVg91ZYO5+U6iywdvRCIJvP80rmLaJQO699q0qkbA31pCf+Av4eHnhOCmDRq9s/r+KTLlPSEqyfdZ+cmKszGSKyvZID89RoHoY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hello,
> 
> On Fri, Mar 20, 2026 at 11:52:14AM +0000, Joonwon Kang wrote:
> > The invariant "scan_hint_start > contig_hint_start if and only if
> > scan_hint == contig_hint" should be kept for hint management. However,
> > it could be broken in some cases:
> > 
> 
> First I'd just like to apologize. I spent an hour yesterday trying to
> remember why the invariant exists and the reality is this code is more
> clever than it needs to be.

Thanks for taking time for this and sharing more context. While you are at
it, I have a fundamental question on the invariant. I had deliberation and
discussion on what benefits the invariant gets to the percpu allocator by
its existence. My understanding is that if we put contig_hint before
scan_hint when they are the same, it is more likely that contig_hint is
broken by a future allocation, which leads to a linear scan after the
scan_hint for hints update, although we could save scanning upto scan_hint
when contig_hint is not broken. On the other hand, if we put scan_hint
before contig_hint instead, it is more likely that scan_hint is broken
while keeping contig_hint, which does not lead to the linear scan for
hints update, although we could not save the scanning that could be saved
in the other case.

In other words, if contig_hint breaking allocations occur a lot in general
with the current invariant, the performance may more suffer than without
the invariant. I also think that there would be no strict reason of having
the invariant.

So, could you clarify the necessity of the invariant? If there is no must
reason, then I could post another spin-off patch to remove the invariant
at all so that we could simplify the code and experiment the result. How
do you think?

> 
> As Andrew asked, how did you come across this? It's pretty obscure so
> thank you for taking the time to look at it.

I came across this issue by manual code review and thanks for saying that.

> 
> 
> >   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
> >     scan_hint_start < new contig start) && the new contig is to become a
> >     new contig_hint due to its better alignment, then scan_hint should
> >     be invalidated instead of keeping it.
> > 
> >   - if (new contig == contig_hint > scan_hint) && (start <
> >     contig_hint_start) && the new contig is not to become a new
> >     contig_hint, then scan_hint should be invalidated instead of being
> >     updated to the new contig.
> > 
> > This commit fixes this invariant breakage and also optimizes scan_hint
> > by keeping it or updating it when acceptable:
> > 
> >   - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
> >     contig start < contig_hint_start), then keep scan_hint instead of
> >     invalidating it.
> > 
> >   - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
> >     new contig start < scan_hint_start), then update scan_hint to the
> >     old contig_hint instead of invalidating it.
> > 
> >   - if (new contig == contig_hint > scan_hint) && (new contig start <
> >     contig_hint_start) && the new contig is to become a new contig_hint
> >     due to its better alignment, then update scan_hint to the old
> >     contig_hint instead of invalidating or keeping it.
> > 
> > Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> > ---
> >  mm/percpu.c | 60 ++++++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 39 insertions(+), 21 deletions(-)
> > 
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index 81462ce5866e..a0e4f8acb7c2 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -641,19 +641,13 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
> >  	if (contig > block->contig_hint) {
> >  		/* promote the old contig_hint to be the new scan_hint */
> >  		if (start > block->contig_hint_start) {
> > -			if (block->contig_hint > block->scan_hint) {
> > +			if (block->contig_hint > block->scan_hint ||
> > +			    start < block->scan_hint_start) {
> 
> I think this should be <=.
> Given hints as [hint_start, size].
> 
> contig_hint = [64, 64]
> scan_hint = [160, 64]
> 
> Free [224, 32].
> 
> Without <=, we don't promote the contig_hint and leave the stale
> scan_hint.

Ah, I missed the fact that the new contig could be given overlapping with
other hints. Will reconsider the cases and fix it. Thanks.

> 
> >  				block->scan_hint_start =
> >  					block->contig_hint_start;
> >  				block->scan_hint = block->contig_hint;
> > -			} else if (start < block->scan_hint_start) {
> > -				/*
> > -				 * The old contig_hint == scan_hint.  But, the
> > -				 * new contig is larger so hold the invariant
> > -				 * scan_hint_start < contig_hint_start.
> > -				 */
> > -				block->scan_hint = 0;
> >  			}
> > -		} else {
> > +		} else if (start < block->scan_hint_start) {
> 
> I think this too should be <=.
> 
> scan_hint = [16, 8]
> contig_hint = [32, 96]
> 
> free [24, 8]
> 
> scan_hint stays [16, 8] instead of being cleared.

Will fix it, thanks.

> 
> 
> >  			block->scan_hint = 0;
> >  		}
> >  		block->contig_hint_start = start;
> > @@ -662,20 +656,44 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
> >  		if (block->contig_hint_start &&
> >  		    (!start ||
> >  		     __ffs(start) > __ffs(block->contig_hint_start))) {
> > +			if (block->contig_hint > block->scan_hint) {
> > +				if (start < block->contig_hint_start) {
> > +					block->scan_hint = block->contig_hint;
> > +					block->scan_hint_start = block->contig_hint_start;
> > +				}
> > +			} else if (start > block->scan_hint_start) {
> > +				/*
> > +				 * old contig_hint == old scan_hint == contig.
> > +				 * But, the new contig is farther than the old
> > +				 * scan_hint so hold the invariant
> > +				 * scan_hint_start > contig_hint_start iff
> > +				 * scan_hint == contig_hint.
> > +				 */
> > +				block->scan_hint = 0;
> > +			}
> > +
> >  			/* start has a better alignment so use it */
> >  			block->contig_hint_start = start;
> > -			if (start < block->scan_hint_start &&
> > -			    block->contig_hint > block->scan_hint)
> > -				block->scan_hint = 0;
> > -		} else if (start > block->scan_hint_start ||
> > -			   block->contig_hint > block->scan_hint) {
> > -			/*
> > -			 * Knowing contig == contig_hint, update the scan_hint
> > -			 * if it is farther than or larger than the current
> > -			 * scan_hint.
> > -			 */
> > -			block->scan_hint_start = start;
> > -			block->scan_hint = contig;
> > +		} else {
> > +			if (block->contig_hint > block->scan_hint) {
> > +				if (start < block->contig_hint_start) {
> > +					/*
> > +					 * old scan_hint < contig == old
> > +					 * contig_hint. But, the new contig is
> > +					 * before the old contig_hint so hold
> > +					 * the invariant
> > +					 * scan_hint_start > contig_hint_start
> > +					 * iff scan_hint == contig_hint.
> > +					 */
> > +					block->scan_hint = 0;
> > +				} else {
> > +					block->scan_hint_start = start;
> > +					block->scan_hint = contig;
> > +				}
> > +			} else if (start > block->scan_hint_start) {
> > +				block->scan_hint_start = start;
> > +				block->scan_hint = contig;
> > +			}
> >  		}
> >  	} else {
> >  		/*
> > -- 
> > 2.53.0.1018.g2bb0e51243-goog
> > 
> 
> Ultimately as I re-read this code, it might be nice to rewrite it so
> that scan_hint can be kept separately. The code is a little too clever
> with trying to avoid stating new_region overlaps scan_hint or
> contig_hint.
> 
> I recently started shimming out the bitmap code in userspace so
> hopefully I can test it for performance / correctness more rigorously.

Thanks for letting me know of this. It would be great if we could test
this subtle change around the invariant and the hints.

> 
> Thanks,
> Dennis

