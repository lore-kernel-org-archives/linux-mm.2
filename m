Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD1D606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jc4Gc0Vr
Received: by kanga.kvack.org (Postfix)
	id F1A1B6B05B4; Mon, 26 Oct 2026 10:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0A26B05B5; Mon, 26 Oct 2026 10:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07816B05B6; Mon, 26 Oct 2026 10:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0E2E6B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:29:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2321F1C3FFE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:29:37 +0000 (UTC)
X-FDA: 85365010794.24.1B5DC81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C90B18000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:29:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jc4Gc0Vr;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793024975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZBVupOUuKnSknN2BKYrJ59ZtgUZFU1sRJU3GwWHfSE=;
	b=DU4DB5o9d2I50qvNAXW6SBP6Y+og7ePDRPtmOTCUSw2zlG5XjGPcAog+OsxN9v9+BmRRCa
	B85HUAVatRQtHPuRTEQVZXf2r1C09TsHLdakDtb8Q2tyKe6EGAB6Zli9PYx7xZQLSHtBys
	BcIbj1YIU6LIukFg0RnD8CbrfEhNAKw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jc4Gc0Vr;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793024975;
	b=cNoWY7wCO7H53c6+saMXICeBZKHAjy/9JtAob8ok05hY8pgLvizMlKadValhrS5XyslkE6
	HsaBTPsN0XSxUIkEvKzIzTl1jnjAkwZbLPhmapsvAo83hy7Xds+QeYawfnK1rNAEHku0lr
	D5QF+N9Q6oc2TL0iaPDzgYpBW6RcN5M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC67D600CB;
	Mon, 26 Oct 2026 14:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5146B1F01825;
	Mon, 26 Oct 2026 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793024974;
	bh=WZBVupOUuKnSknN2BKYrJ59ZtgUZFU1sRJU3GwWHfSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jc4Gc0VrMoeEjDqcZyGdb4FpOMlHCGbAez6wW7ehQcMBBUd9gGlUaK1cCjC/iucc8
	 w6lImTj1ZUn4R7b+hl9p3NmSwACn0rSD+JOhT5FoczhbcHsjjJWcbEfWCAKHhVNPvy
	 ClqY+L0T5FBDGMVJTwoXs+RmgRkFbOAnf37tpiW0nTHDv4dihHoVz3/FamBzHRHYeY
	 eF+3/JpllVXrPk4v0bpidleO5Lxfy2K4rAjRCP2yClGSRM6Ty0eXuwkLfglc7P/LdB
	 0pDF50wsnHfuIBl0c8GlWeu08A9KXG+hoG9VbLV2w/E3pGQ8bYNNc61wa3uJ9uYofM
	 2jocnXFmJm0mQ==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] Docs/admin-guide/mm/damon/start: fix grammar
Date: Mon, 26 Oct 2026 07:29:26 -0700
Message-ID: <20261026142927.149910-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b0d8d0ceda82e303262c0f61324fe8a84fd9f745.camel@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C90B18000A
X-Stat-Signature: 3r7w5q83mjtmurt8hzxp5thjzfj5epnr
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793024975-950791
X-HE-Meta: U2FsdGVkX1+NN/V65faf5UFbRBqM5KYlNuC5Im1kZYK33QSrwRJaPSMkGoh1lqwhJdKu1WrZqqZnqqOJUNLufiSSGqLGStPcGFLXaQ3i0nvGlEq/R9/BYkgS6JvUazPXV+lW8N9JUrB59zC7csO8crXlqdOddZwi1tuV5RTE4lYgpEtxHaN60LpXvLUrznkSfMcwlxwltfVCqBLOFkiJ39/K8jGwI6es37cP+IcgHo9pkMswsIQG7SaYosMgubKaeDqze/87nhuUbP8j3gCcmiv1HoG0ozYss1Wp2no4UuWYq74UOE2oaQ2QqdgydkPt/0tTlJJzthzDxXIQ7yAaDgRb8NqgsZu60GIXYsGVvw6zrgUlIcle43vpAk5ejsn5iAw0rOrANZxKwzk1ay5bpcb4Djv7+IjactMdK2UAhD9c5odZvdo/gvroq7oj9Wgq83tIBJUU/vYxHKKYNQOTqpHC6RaOAGX7xbr8rRvJihFXEQ4VgPuCBZpG2lw77TCuHjkAWT2dCdQCvazxcb7Nalb1a0vHv56BzirqlsdVzjel3/DQS7AN4DLlZJykUqIW8MhNH0ygnNUukQZsqSuU0GUJe8fgeb7DCZ8UNgazQTLXk6BSdn6eRWUvVmye8XEwEPCorj5JsvpBPmfNfYuVdbxVNZSq0NKg2tmgCsgmYzk6he1KnEcq/kqZxkF+9U8wVmVuV08JAl1EAzie1g1B+MFb9MSiMGdhCg6zoUDzzKVZpR/o//dKGrNqxmUrc3UVuX/6NlEqwpZuuBgka41z4Ezb5CwU1wuohXt7ee8QzK957QLambodheD3PDPi2BwlEi3EGLYtoXPumFsixe+O4SILcv5TH+bg81moE7CLFcwTOr/yznLRuIVrsyfEcd1wvLRL7+s0LyuH1l6CDA+LM9+g3bidbEI5/tFfm8MNtvbPyEWAoCFGVOnxaN6UV+phOIwDi0UBfE+cqeAtry3
 dACdhhTT
 XzmVpREPiMNfC3h0++vV93yelPkHKKmPtK7tKoueh9wVQjNcU0u9P0MJtCnJRkd6jTDU4+A4IVWSuI/U1wdYDxz98m/MgSZ/fhfa2OaIVkH9fsaJ6K7LW/83JtQzL3BaG+6uIbN3ckCjeT+jeJ5myppOBDljSV3Rq9CQ4bxmENq5O5+TOyJ4Tc2pdi9or+f5QjENnSQkYRn7n6Kvrv2RlJfXIOPGie6xFti5O3Hvd08J5+NPb3rLamBrV6SMTiS5VAg48tx8xB5EOvQ71BchiSNmssv72NDDwDGcxPmo77be+1OFsLS3+xiySLW++cQBhOWAnXzF28B/tMD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 13:41:32 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> On Mon, 2026-10-26 at 22:14 +1100, Aveline Noir wrote:
> > Fix a few grammar slips in the getting-started guide, like "make DAMON
> > monitors" and a region "that has not accessed".
> > 
> > "The line of the commands" used to be "The first two lines".  With only
> > one masim line left, I make it "The first line". 
> > 
> > Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> > ---
> >  Documentation/admin-guide/mm/damon/start.rst | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/mm/damon/start.rst b/Documentation/admin-guide/mm/damon/start.rst
> > index d98b0eb8e771..a83fcc2265bd 100644
> > --- a/Documentation/admin-guide/mm/damon/start.rst
> > +++ b/Documentation/admin-guide/mm/damon/start.rst
> > @@ -63,7 +63,7 @@ the execution. ::
> >  
> >  The first command of the above example downloads and builds an artificial
> >  memory access generator program called ``masim``.  The second command asks DAMO
> > -to start the program via the given command and make DAMON monitors the newly
> > +to start the program via the given command and make DAMON monitor the newly
> 
> 'The second command asks ... and makes ...' Thus:
> 
> +to start the program via the given command and makes DAMON monitor the newly

My intention was saying DAMO is commanding DAMON to monitor the process.  So I
find Aveline's version is slightly better.

> 
> >  started process.  The third command retrieves the current snapshot of the
> >  monitored access pattern of the process from DAMON and shows the pattern in a
> >  human readable format.
> > @@ -71,7 +71,7 @@ human readable format.
> >  The first line of the output shows the relative access temperature (hotness) of
> >  the regions in a single row heatmap format.  Each column on the heatmap
> >  represents regions of same size on the monitored virtual address space.  The
> > -position of the column on the row and the number on the column represents the
> > +position of the column on the row and the number on the column represent the
> >  relative location and access temperature of the region.  ``[...]`` means
> >  unmapped huge regions on the virtual address spaces.  The second line shows
> >  additional information for better understanding the heatmap.
> 
> I have read the damon directory aswell but I didn't find enought to send a patch yet.
> But I found this, could you add it to your patch?
> 
> @@ -78,8 +78,8 @@ additional information for better understanding the heatmap.
>  
>  Each line of the output from the third line shows which virtual address range
>  (``addr XX size XX``) of the process is how frequently (``access XX %``)
> -accessed for how long time (``age XX``).  For example, the eleventh region of
> -~9.5 MiB size is being most frequently accessed for last 3.7 seconds.  Finally,
> +accessed for how long (``age XX``).  For example, the eleventh region of
> +~9.5 MiB size is being most frequently accessed for the last 3.7 seconds.  Finally,
>  the fourth command stops DAMON.

Looks good.  Unless Aveline objects or do this by themselves with revisioning,
I will add this change when I apply this patch to damon/next.

> 
> Rest looks good to me:
> 
> Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>

Thank you for reviewing!


Thanks,
SJ

[...]

