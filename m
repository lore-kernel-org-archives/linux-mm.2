Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2252F531DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 00:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EBC96B0088; Mon, 13 Apr 2026 20:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E6E6B008A; Mon, 13 Apr 2026 20:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D6C6B0092; Mon, 13 Apr 2026 20:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E65656B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:29:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CEDF140348
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:29:04 +0000 (UTC)
X-FDA: 84655276608.27.974F1E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE9ED40009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:29:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+yYJ3OE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776126543; a=rsa-sha256;
	cv=none;
	b=5iDIMXBsy1CK68sqJVmHeF50AvlJ+u7FthSMzPmvZZu8Rda8HLelo8XXjJCRvKXXGY1oHZ
	H1jlZJLbrwjMKrTjVjHVvXAtRIM1HLMWnn8zbZxxfAK1Gcf2X+M9YvSy1An1MJw7FY1c3c
	qzMzyAmrxt0zWrtoey8d73Bc4866JUs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+yYJ3OE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776126543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22sKUZy8U8Nwwvqlb1ZDC5e6P21jZVbF+s1GjgNMKzY=;
	b=sJgSv/CDpcvKEVfsZJTF+qvogvulk+wrtggye+TgihnnZmt9Yq5pqnCkQ56xUDI1us9XrS
	rVs4KVw/oPgH+9pdbuM0pP2X6c+RnFfZHMUStM7X+rYW1s2rT6MgPD/2bJpY6HYZ6Xzj74
	SXxiTbhqoIA1NStiRsfg6jwOOALkw3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC7AB4360F;
	Tue, 14 Apr 2026 00:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8C1C2BCB4;
	Tue, 14 Apr 2026 00:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776126541;
	bh=KJQ8DjNdIK1+MWNYUBk1EM61NlNb9p1GDy6iEy4DTG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+yYJ3OEIxNXhrBnBljLxL3lE5OcCdPspgAAE9SMqP3A/xLorXJ7KyTjH++vqAfsG
	 rShEU7EVM7LUBmJzJJbkGDwl0Kkpme/WZzFEfhAOXig2/odpfSwTbhB3CK2yFeJk4g
	 Nz1S2fMXNjSqekVil7TTxHbf17Q9BMi397+VCIFvFa7eQSl2Bh8RD2kzqdMCXjHAjo
	 +pAO44PwNXq2yLntTUZ23teL2fWuodJ5iHFHp79s99bo65JpXq6oDWkZk7RNCeQGyt
	 ooDwxNJuYMxe5TxGEZOZyRvw0DhNmIvulKTyWwKg4v9s//bL7zvp62a9RYhhNzy7Qo
	 DUu1Lco4mktaQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Mon, 13 Apr 2026 17:28:53 -0700
Message-ID: <20260414002854.83483-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260413220511.30677-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mk5ombc4gnzpwdmac8pyxako1k8f3ojw
X-Rspamd-Queue-Id: CE9ED40009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776126542-949687
X-HE-Meta: U2FsdGVkX18gLHpjoEb47K1mz9e84hZKCz+2nIn7m7ZLVWFTbx1emvp/5ltDJ0eE1U+2SmadwWljuGUbySZ2uPk6EdtS7xKUb6AzxBjwmbnoftqEoS74YGWINb+9LsQe5pnhb+wEO9dHU0uH6p9eiXee5li5wVXSGADucV2peSIop/fx+Z9c4DHt0aTf5CqaQUJiWMTmxzIbJqDYg+UyFV4lNX1ZWU38Ny1lbAR++fPZoq38ZLSEdU1hAQa2jHBu2DjipCX19c2OnLqsfaA27IacpOWEimyUuhFuaz0hGvBuZ7WkHJGr1OT9X26X/euLUr4Zg3qkD3zgZxtkTOlTKFP7BkNCWyqeXmZoSNFOcgkGw7BJKn6b8wquC8AHUs90lmVtT/1SRL1ImRqnE1l67ZqapsXBlaZyhILJf4W27Dg6+dYCen3DinzZ7Hle2uRucuCKIaSpmCYzn7ef4f579GX7YOL83l41rBRmqc2gaZYoT+5oa3kDn/mNOtzNmfn/dlOAmSHGAHgr1+toHE/iUJEF8DWQXnXZrGRQWoA8K5+7/kT72fwxKJ0F0FpFPIAAX+vZNCBTrc1XZL4s2VWFFEbooVwh7s9c6gYB174Lb/S73EPXMBoptCEY42F4W0pr9erq6fwFJIMdJGtJXdPKyG9TIu7No9axfREFwT6n/2X8Zhbm+a51Gv0tIDojGPbASMHqi5mD6PigRJaVs6imjHTsa4TpjOvpua2ONDog1zRLakMaJf8XIbYeC5F5U7cNqEyqhvcADMisJjOjwl45eTRgioikT+FAykAGmnfc9812MUYL/WXmx6fRDxfpvVmFdUZ2czTao5OWPNQA8bmBIvknFSfyCrjx2za7je5RlA3cAsIvrBCZw8BOMqUemegl5+s11yt6vuxz1+Kn9UmYoyn7YRMW312iJZwWLyb2NGi2m1ypumpGIrF2CmxXfooR8bicj9DE//xY9pwT8BD
 hzQXsIGg
 Qm0hTUdZuCd/xxgQ/YZjm10ruLt+c9CPB3glbMUoFFv81f4amiDvWxy85VL6lOUX1HHGq2Ef/Y6abkDtWnxxP6AScA6PuHq4wCNHAYmGtjwDoqA0J79noZ5fMNEOZhcW1MtJo66y19bD7Iz8NFZCLJkrq/Ev3f19qpRL9it0uHUQWbtCKgQhQA+749D12aKJBZkAIxwR9EgFD2CBIKFA6rtkeFfVSHbFIqE3Pb8n9xFILPpzPNnrwZ53KR+DmjxzQFDuD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 06:05:11 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> I've reviewed the Sashiko report on [PATCH v2 1/2] and [2/2]. Since the
> issues are essentially the same, I want to reply to them all in one
> email.
[...]
> # PATCH v2 2/2
> > > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > > index 86da147786583..e3e148fd80f97 100644
> > > --- a/mm/damon/reclaim.c
> > > +++ b/mm/damon/reclaim.c
> > [ ... ]
> > > @@ -250,6 +250,10 @@ static int damon_reclaim_apply_parameters(void)
> > >  	if (err)
> > >  		goto out;
> > >  	err = damon_commit_ctx(ctx, param_ctx);
> > > +	if (err) {
> > > +		enabled = false;
> > > +		kdamond_pid = -1;
> > > +	}
> > >  out:
> > >  	damon_destroy_ctx(param_ctx);
> > >  	return err;
> > 
> > Can prematurely resetting enabled to false here introduce a race condition
> > leading to a use-after-free of the DAMON context structures?
> > 
> > If damon_reclaim_apply_parameters() is invoked from the kdamond worker thread
> > (for example, when applying commit_inputs) and damon_commit_ctx() fails,
> > ctx->maybe_corrupted is set to true. This signals the kdamond thread to
> > break its main loop and begin its teardown phase, such as executing
> > damon_destroy_targets() to free lists.
> > 
> > Because enabled is set to false asynchronously here, a concurrent sysfs write
> > of 'Y' to enabled will succeed and immediately trigger
> > damon_reclaim_turn(true). This unconditionally calls
> > damon_reclaim_apply_parameters() and executes damon_commit_ctx() from the
> > sysfs thread.
> > 
> > Since damon_commit_ctx() locklessly mutates and frees items in
> > ctx->adaptive_targets and ctx->schemes, would this race directly with the
> > still-exiting kdamond thread traversing and freeing those exact same lists,
> > resulting in list corruption and a use-after-free?
> 
> The core issue is - modifying 'enabled' and 'kdamond_pid' in the error
> path of damon_commit_ctx() is racy.

We simply made such racy user behaviors be prohibited [1].  So this should be
fine.  But, I'd prefer simpler fix, as I replied to the cover letter.

> 
> My plan for v3:
> - Remove the reset code in damon_*_apply_parameters()
> - Keep only the fix in damon_*_turn(false)
> 
> This resolves the restart issue without introducing new races.
> Please let me know if this direction looks good.
> 
> Small changes for v3:
> - Delete a "=" at the bottom of "Problem" (commit message):
> 
>       Problem
> -     ========
> +     =======
> 

I also added comments about above as a reply to the cover letter.  Please reply
there.

[1] https://lkml.kernel.org/r/20260329153052.46657-2-sj@kernel.org


Thanks,
SJ

[...]

