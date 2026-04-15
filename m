Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A7FF433C5
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 22:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9286B0005; Wed, 15 Apr 2026 18:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79B56B0089; Wed, 15 Apr 2026 18:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F636B008A; Wed, 15 Apr 2026 18:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97ABD6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:02:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39194BA44B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:02:32 +0000 (UTC)
X-FDA: 84662164944.08.524049D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8088CC000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:02:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XoV9YXsY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776290550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzqPrVDLfuLoABCJCVUbre9ZmRQQgnVkvmFiEAl6tSg=;
	b=tyV2bea1XFC4zPoMDWV77air43vloo/94Y34VoaVE843Ap9RxEW3W452YVYbRISZk7qsYA
	Kk7LlBi77GIVGIQJah8Qkhg+FLFfkZJulrKEfCkmrrQgsMl4XcG8r3pjX8K8Yzmxt5v42o
	wfNLZU8G1D/0pT2+CerOPi+y7PNqaTg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XoV9YXsY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776290550; a=rsa-sha256;
	cv=none;
	b=17i5rpChEL4QzrcmQpC7Al4TryhweIJO6DXSRc1lbqXFMNKZNi/yfp5cofcKsggbtQ8GxP
	jgiDYvhirhlCrjDg/VAbZ3DX8eO7NCcdINDITiR2dL2/KTMLZQG1L5uuXDC4sQLEYlsJR2
	UZIpbNkqxD/J75az73chhj4JHx1vDdc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3BDF4171B;
	Wed, 15 Apr 2026 22:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773D5C2BCB3;
	Wed, 15 Apr 2026 22:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776290548;
	bh=eHdW8R6LaWTSjbq77BW1DvuiaGuL6ZDV4aigbLwLhpI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XoV9YXsYNN1CZkDb1byLNi8Jdbd5s38Km7seKFLW4DLj3vnRMIQOQsLhTidaONb7k
	 h6lA5oaxu83UbcKwfOVzsb/k+YYXaI2es+iopGc2xVDzivpEy1IRExVTOUlPviLUKx
	 LU2rshy6iMXQmvz2FxUOz5W4N6hUhSFRigxwqv7yr8ILO4n3QAJrU8uqLGDrGs4iyJ
	 tN+j/zQ2h047VuVLzhzkpoaactyEXnC0jVAlS+WhivRekSM1mXKacK4qKEg5XZFmyQ
	 +oJQIR8hkIg7IPb+BTQYL2/yLU/+owgjjQd15Si2Bo0xflVuMu1XWVbbL6Dh9dah18
	 PD0KpqchWh6qg==
Date: Wed, 15 Apr 2026 22:02:26 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <aeAK8mFxzgMOepmZ@google.com>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad_HwhzlNPUEKQi6@casper.infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8088CC000D
X-Stat-Signature: gecmrj8ni7p1ejcjbsp3kaqoom3zmad8
X-Rspam-User: 
X-HE-Tag: 1776290550-230943
X-HE-Meta: U2FsdGVkX1+0YPLAhn51BkwrKZC+s+KE7BCn3kuJGnjPiPpAZuXWclwZbHhvC7l7ilMGkAfaSKZx0iud1M8fhZpWQnKikRFlC5WxPMRdFdq5aP1hNz5IdUj2zb+6DCNyAYE42A1GsNSaMaxmULZ3tIQ+R3mnpkg4y/SFnkqQhBHjlN+HsdSGFwdlyLQdI7gwwo1D1PePa6XB0hao5VyyDGr06+cRq/kYAgOm1jZ56CJCNDDFntQsz9me4drXhWU6gyLVG9EkOBO6SfJoT9PIzaqhfWx+VmdDL6LkQUDT6vetVcJCzPNi03sqHxjUjYk7v4CVj72p81iQRWg//owbo+W6iJ//OVY2eSCyp/JzEkkA76aLcReDr9yYPIdlhC6GczgTJwA381YG9Al/XZon2tqGVIOyPSJqy5VqxVhTXmC9z4c4Xyipdbf7TCZ5Yqnp0K3/SMhe5Yc0yaierK1g7p4utYQk54KedlMX08UBPkxH6B2CAQvVKlOvvFTWGZK46W5QWMUiwfYM+fhn5CHuBWZfuJsZUbti0K4uzngbtGi9N5/mxjaGNTox4cA081heK7HwQDOMPCobP7jrmwSD7KZs9b9FCyhG41Mr9vJ+dna+8930OOTOd3nzunV05HF5uMoEa8GBUi8t6NC/Dn8Yroz1UJW1l1NIFq1ezEwDlIWq099YxKyMxXpRhNHXtndRJ+wM3ds8xrAK8sWwNd+X0GAtZJzu2Qu1lo31fBXP+gTugVVOUgiO1/LNF9GCJ+Q0MyBS1jf0qH2UP6VNEVsZbBMIw9FshlCN6atf7tMenu18URmfcNqR2eU6bVSf5fDlSSX7f/y67SZJed0mqR18S4kKwOLOpqnVAKu6vK86UkO1rhQrmjR3t74OUQHs2vuU8cjlDPKTbyF9YL1Q/RqtzNQmxewQC8D0iXTWs9ObY1vCrSX9jfVblAPvPvwQEH34/u1tQIUdmUx7r7YIn47
 pY5eBtXG
 95nwH7pZyBsC48nZ3r3+asy9Ga2Ygejnye0oWLCnoHgW3folVT2948VDIa41Bp7wiYoB9x+M8Wh2yQUXUSt30PC9KJbsaWxA0BgRwmQm8zzwMXy8/AaMushmtLHnJ8kbRxQyLkITsmfBojYlUfqXbXndynOBjWaeTfRk3445uYlBgJTn/CURuwthAwYV6t+8uy+9jguWXc8gyeCwE4fQUtdXkgsxu3n1hog57VJmQMYUx4QCSL434nbGo11jisAgyLYEknugz9d2SITEqDabq6/s+QcwRjovetFFw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/15, Matthew Wilcox wrote:
> On Wed, Apr 15, 2026 at 04:44:04PM +0000, Jaegeuk Kim wrote:
> > On 04/14, Christoph Hellwig wrote:
> > > Please add the relevant mailing lists when adding new user interfaces.
> > > 
> > > And I'm not sure hacks working around the proper large folio
> > > implementation are something that should be merged upstream.
> > 
> > Cc'ed linux-api and linux-fsdevel onto the patch thread with a proposal that
> > I'm not sure it's acceptable or not. 
> 
> You haven't sent a proposal.  This is a reply to a reply to a reply of a
> patch.  There's no justification for why f2fs is so special that it
> needs this.  What the hell is going on?  You know this is not the way to
> get code merged into Linux.

I added two ideas in that email. Have you even tried to understand?

