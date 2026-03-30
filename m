Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6BE1061B15
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143866B008C; Mon, 30 Mar 2026 12:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4416B0095; Mon, 30 Mar 2026 12:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0367A6B0096; Mon, 30 Mar 2026 12:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E67316B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:48:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F2DEB9B1A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:48:06 +0000 (UTC)
X-FDA: 84603311772.18.7F19B72
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8B17940003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:48:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Wu5xKP7P;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774889284; a=rsa-sha256;
	cv=none;
	b=5tDToB089OUBzO58oBUuChGpEU4SCCIhL9tlojEzeyIg3VmkZ3LG5eIWtflzV8xPy6TA7y
	mTsBcQ/7+xyouJ1FBtlihRilC1mpnSeRHm2uKMSnVY9/jQTAu3zdrMZOhAMlSUUK9Akhh/
	JoXg2nqdf9CNhW1KCRHRpiWwz3bhN+U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Wu5xKP7P;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774889284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Shj7QzE/Spveh95U3mOIo4vm0AXuwZdRq3vvb/nlFnk=;
	b=bNFs5oDfGhJK311omDz7jRiOdAwaqzRZt5LLevLPVhXCQseBQkT5TMOjoL5Q8Lk1qJ/j62
	wW2rj5Hz/5goi26Jyzz536/i9ZzafOrE/ylT/X8O+QC83FgYkQvwDtVlACDSV6kLhU6ESI
	w4mhLCNo8Y4M5Q0UtSgT/3I6VKL0O58=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A8DBDBE15B;
	Mon, 30 Mar 2026 16:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774889282;
	bh=Shj7QzE/Spveh95U3mOIo4vm0AXuwZdRq3vvb/nlFnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wu5xKP7PIPetVSo2TNT7CaBKtCPwUGtgrZUfb71Zw0ILyCfbkU+3XCAZpaDOEe2pj
	 2oH7w/B+ZEil+cY8j6oBJdiq7wM7gRFKg9RPSWNGLZK6kI67xUnb70fcQLxDCEsGKa
	 o/+GKQ7EtrvZ5TTnfFX1a0NCuM+QtWFHdGVKkr9g=
Date: Mon, 30 Mar 2026 16:47:58 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 0/8] mm: use spinlock guards for zone lock
Message-ID: <acqpPkXKnyB4Oqci@shell.ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
 <20260327131120.591770a2aa63abbaa7bbeadc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327131120.591770a2aa63abbaa7bbeadc@linux-foundation.org>
X-Rspamd-Queue-Id: 8B17940003
X-Stat-Signature: xaqdb64wjggd9obqnc9mso9ntiqx1adg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774889284-285502
X-HE-Meta: U2FsdGVkX18WDhDxQAo9NAgLU9Ubg23DfJGwwGM5i3sAyJhryIWYpeDsXna/SmXboXzDnJg/CRe5IIfpH9gaSdUqKdwIOKeJRQaWPBEMq6G0b4y3F39WDe5VONZ5c9ZwP6tPhyr2hZb8QyFNhanYYrqTMJ5lwrB5nETbmZuq0F/A4+5qEkYS1F39LANj0Yxqeo0NkFHD9UJ/AWXLZqKO/Vtk4p8cNkcJ9Yw1tuPv/gZqkch3ic7Vh8taZkmNgG1hwulJXvDPBlFEN5zrx1NUfMdK7t8yiYD4Lw/HnTm9qcxmbsSATY7RqhYroh57D6w87CnA4Dd/Lao57NZyVMnOVUiYiBWrdZ/ZWOdCcPjFGjPDopza96I8mBp1IWi/w+1g9hTTGu6MDUozLnnXIjG80tA2aWJ3KU0vlWqIpkLLcI7yJhnH7BGPcm/YWKtmDNpWh/l9SnOT9rWlnnsmNnwuBOdCMQjyi7V911/bxiNa8yPLoorBd6TtO6vJvXy+X3jICXzx23SWP1CZGXt33Bqnp1OwsmAuyhESJhoOqsP/K3z0MSc3zZd9kD1h4sV9DwBP42HJx8sQUt3tO69/83aFiHCk6+izoH14ZUBsdsUodzbjLxahb/bCWlIAP4R/ZObeXv/2VbOrCJlSUKdNrPDYpj+mUSX1zjorOMPGJgza6otYOrAdD/63aJqA2P0rhyDiu60hLcsMQtadOHd8EQ7zTGwY7/pjZMMNlPSr6KIdbAGUSnFME6tTr3AF+1N+wN0eSN+KWj4HZcdp2QG1jF5uUhRo0pRt2VAFHmHxGBQNnaQBAA8d/3JZNVXxEfc+92P4imQ/XwfL3NE+x46GOjyD1VlSO9WXxfoEXBLUxhNSDQBks2EtQdQiIqJ7ZgzGG4sdSrJQ/k3yeDFbksR6VovirVV0LpPRBsCAAvAGvTBV4kWjl5Sf7XR1rJg7V2y1/8/VIYniCSqihrZdOLItYzW
 VPE64f/T
 TcggdaxW/YkrthaWo/eM2Soj6qObfnYn1Cme+rDsUkN/vo5qIJjwPtQ5smVoV5dbbBqORLtr/CHIUzHkRbXhsieH1c4N2JE+cZKzP2nCOao+gw1x48TQEaOY2Omv1dTIY+h0KDUem8Fn3q2raARP3Hm9VH8PKNQQdZEC7NRaq9NIl3Njqd9Y2zUxBheMKk20fT/Coq+pUh6ZpPU0je5GiD1ahu3cBaoNtkpclzIsL3gpoAl243b1x7GOFOL59j8YYVLDRnbhINvfWXfUia2+RbAw3ex9ePQ4SNBZa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 01:11:20PM -0700, Andrew Morton wrote:
> On Fri, 27 Mar 2026 16:14:40 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > This series uses spinlock guard for zone lock across several mm
> > functions to replace explicit lock/unlock patterns with automatic
> > scope-based cleanup.
> > 
> > This simplifies the control flow by removing 'flags' variables, goto
> > labels, and redundant unlock calls.
> > 
> > Patches are ordered by decreasing value. The first six patches simplify
> > the control flow by removing gotos, multiple unlock paths, or 'ret'
> > variables. The last two are simpler lock/unlock pair conversions that
> > only remove 'flags' and can be dropped if considered unnecessary churn.
> 
> Thanks, you've been busy.
> 
> I'm not wanting to move new, non-fix, non-speedup things into mm.git
> until after -rc1 so there's your target.  But now is a good time to be
> sending out material for people to look at.  Let's not have a gigantic
> flood of new stuff the day after -rc1!
> 
> I think progress here is totally dependent on whether those who
> regularly work on this code want guard() in there.  A
> preference/familiarity/style choice, mainly.  At present the adoption
> of guard() in mm/*.c is very small.
> 

Thanks for taking a look, Andrew.

I'm not aiming for any particular merge window here. I had some time to
revisit the previous version and rework it, so I sent this now mainly to
keep the discussion going.

I agree this probably comes down to whether people are comfortable with
using guard() in this code. It'd be great to hear what others working in
mm, and in page_alloc in particular, think.

