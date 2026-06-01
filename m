Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD30CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9A36B048A; Mon,  1 Jun 2026 13:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581D06B048B; Mon,  1 Jun 2026 13:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BED66B048C; Mon,  1 Jun 2026 13:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39D036B048A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:38:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D09851625B6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:38:36 +0000 (UTC)
X-FDA: 84832053432.27.24730BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3A7A920017
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:38:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4Mqebtv;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780335515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOASESyss7NgMI/zX0vlLVJL0LBedg9zIkeUgLKCbrU=;
	b=meDUcqOBd3GV2EocqbudjO9VKh26WCzNq/0MjtD5ZzxAR95Gsdl4YTbTWmkPXL36EUQaHR
	OdP4YM9avo/38FoY2K5U5pyNStrrtlFSyAgu6pLc8lgeG+i0H2e//h2vrbiOAZAiLBMrET
	OAN+ikDLZV0/R/pJD115bPj77PmJ25A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780335515;
	b=zRS1AIW3zKMuLoQN73CfOjV1vXfQQGuYHN1h4g9sOmUmKG0oMq4Kl8BhN/mS1LcDpOlGN5
	wjr6dcmXkG2w6iHPsqMbdudcdj69KdtU2EXP8sBpfyZ/Lqrqej6JkQA7a6LykKi7IIrKFA
	xd6LFL8J7P+aRn8wZUQqgq8YHBCQ7lE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4Mqebtv;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FB02600AA;
	Mon,  1 Jun 2026 17:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5991F00893;
	Mon,  1 Jun 2026 17:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780335514;
	bh=hOASESyss7NgMI/zX0vlLVJL0LBedg9zIkeUgLKCbrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W4MqebtvxmKLj8Y1Cs6cPANFMjbBQPaS5C24+ZR2tzxBk1wULWL6A1JSlt2A5GOeE
	 3FGIbJlMoWQUrSKRbaZHm1AsOVQ78FlgclfRvyKwkM6EpZimZTk2M3qEcRJAgRYAmM
	 SHGbpbX+lof+Vo3OrfTk4dSjGVX35VmaFrVl7L6ANTUNZE2fdftqVBi8MUONEAtyEs
	 12KjDz71/OFDR6rVUZxrrQnMq+qPRqXkVYd2Jr/o+d/1aIG4jXQWxl8iJLRIXVqX4l
	 CaT6bHwJkBjN4zZDibz9V3BpSaj3a1wFpI1ubKvTLXMjBTtBTeyLdj5sw2KwQ1fOa5
	 +1il0JNLu6q3g==
Date: Mon, 1 Jun 2026 18:38:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH 0/6] userfaultfd/pagemap: pre-existing fixes
Message-ID: <ah3AkzoaTaytGfrR@lucifer>
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529173448.40a37785ecbecb6868fdd6a2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529173448.40a37785ecbecb6868fdd6a2@linux-foundation.org>
X-Rspamd-Queue-Id: 3A7A920017
X-Rspam-User: 
X-Stat-Signature: qzrt9rgm8319xjcm31dd4o3hih4a9inm
X-Rspamd-Server: rspam08
X-HE-Tag: 1780335515-309857
X-HE-Meta: U2FsdGVkX1+BVhx+fRdmIZERoWnTbIdnmMLH6g2oBVUPIBS/4Nd/uIolv9hn+2wtDQ8Ws49DYaQPpNLNHUbzT4Z1dT2Kj2cNzXS0cq8UOcQoHtiaspvvjf+zxImot/VZlQ+UjG/xb5ZnYPlo5ygtj7FCSUQ5D3UKtia8gcyiUqGjtnAmlDnXp/LzgpZx9aDyx5zN11OiKWs39nPTBEzElMx+HmGPN7Zg5An/ImkUA3vJ6WKtcXqRSzpgQ8KdtfF/a0ICWCn8y6RjG9B1cQfnBbi/QX+Gj1b4tvwIVCFfzDN5KEj2rxPUOZbiUBANTQkSugyreUBPf1Y/INMCtY6t4180A451KqsHCLXBci4OrBZxbDcW/NhfJGOSUNxCICU4VwdaL/bkXLNzqZnC9XdViPEj3txILqO1I9pLFGSWsCSYcBBzyZE7uqvtu2jVzuoK+vWp/XnCS7CeBaiItAZAiEZwHL6KAzT+lNNdyEV6IQTyCzdQ2XzM2pG3AFvbjZxlljnfOo8OdaKDoq07VgKGLv22/jqE4A2nKD2KpqgfD5XHwsFNvau5skw8hDLK6ierCpCZNNdGd0ZVBVp++FIEbXsaNP5Gvrtclj/wihA9qofShQzDtXsQaVIrzq2gAfl6ARoTz+OXtcj5kILOAB2tM0TOz1lVSMLa3aTwCmJUqr2pOu6iMxydYJd6Fxia6SM2zW8VbxfJWh7iqGzr2M6kvDWwvgz+rWjB0PeA03nqP6/1hIcW4xNH0t7seOboGjmdSLPRR2mByXAuoLY4lEH7YcdpceTMwATfEtyAcrVph28x0ha61eT1NFEC/VvrIRzhn/QsSWtYBohej1xX15PI/+99YYsQzmA1so9qzge3t+T8H7g0ZnDh3QlQSByMpULy7v5+GkWhgT0sh43xpEivWm4yWoUPyY9Mu5gsBtaft910DiEEtq5KhySLd8Y7EYvVtoL7DmABRhrfupkbfiE
 iHb3HCbH
 FnrI3gFMSnC/uIoHfLIGv9n+bk/QBnQP747fnoeoEawvstfv5A9KTqUEk0+oTIlHs5OrdoUFVJizUFIvdOLwUu24R3rjGMi2Pbn/UCjKn+G6FlbFB98JtuV7AeFMl94T2GY0B6Otw8GxYzwZ5CstK456AEGngbTU1DAOtvPsPsf0zg1gZYIPDhNlzw9z4Kn90I6jRjNhvhLvvsal+Q5fZ/jL4mORdQaBiWWBICPVux9p53ETtjep1nSBUTkQwZYiIIHyn7XB7ijEH6gUk/Pia5GjJ9gb8JdTTVl5zsmidGdj2kpRRnMYgI6Jy8Y2MUNWx1ncH25Ri4d8r5xU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 05:34:48PM -0700, Andrew Morton wrote:
> On Fri, 29 May 2026 18:23:24 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:
>
> > These are pre-existing bug fixes that were carried at the front of the
> > userfaultfd RWP working-set-tracking series up to v5 [1]. Per review
> > feedback that fixes should not sit in the middle of a feature series,
> > they are split out and sent on their own; the RWP series is reposted
> > rebased on top of this.
> >
> > All six were flagged by the Sashiko AI review of the RWP series and
> > carry Reported-by: Sashiko AI review <sashiko-bot@kernel.org>. They are
> > independent of RWP, apply to mm-new directly, and carry Cc: stable@.
>
> And...  this made Sashiko point at other stuff:
> 	https://sashiko.dev/#/patchset/20260529172331.356655-1-kas@kernel.org
>
> I can't figure out why four of the scans failed - "View Raw Log" comes up empty.
>
> It's concerning how frequently Sashiko is finding pre-existing things.  What
> would a full scan of mm/ tell us?  Gulp.
>

Yeah, but I also kinda wish it didn't do this :) It's similar to sending a
series, and somebody replying saying 'well this is totally unrelated but <blah
blah blah>' and expecting a reply :>)

You'd want that person to just submit a patch for the issue or a [DISCUSSION] or
[BUG] thread or something, but interrupting, possibly delaying + taking people's
(usually very limited) time on something unrelated is just unhelpful I think.

I'd prefer Sashiko had a passive mode that checked for existing stuff elsewhere,
and it saved the tokens doing it for a new series :)

Just my 2 pence!

Cheers, Lorenzo

