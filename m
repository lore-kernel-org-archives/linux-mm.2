Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20FB8C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035EC6B00EF; Tue, 14 Jul 2026 14:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28346B00F0; Tue, 14 Jul 2026 14:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40E46B00F1; Tue, 14 Jul 2026 14:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B31796B00EF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:53:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C61514044C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:53:37 +0000 (UTC)
X-FDA: 84988280874.22.818F473
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 958FC18000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:53:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UsMeaVij;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784055215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drFn20uL6NhR91DYLEIp22lK9ia3uqNE29xicoI1pdw=;
	b=goAx9VX8Eb/U0mMiSgjoHPRunoD8mhI+tIcX2gHyZwHRJK/rLWcfmqusImBhvgqD0ucTQI
	p7Zx3J3DChMM9YwyJCPg6zmYeipVf8yyusnTZ3s54jubJykTwM1GLFTwT0yK7Z+4bmwFvP
	m27Gd9bP3X0mo+4Rv6vlGrBct8ujh3M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784055215;
	b=R71JoCHz0nl/0rO0FNPPmE7OSyTA0Hs9OOZz6sJkVOblTKvvo6+CB0qdUeJVludsH0cyBe
	T70nYeSTp/233pMJwQhQG3IQsEBR7ErsndAhZmTFt1svHiGoP/PWkBurMTIN3CLMJzCmgH
	FCzWS9KUZJnkPEy8yeKLxuBT1xIsOLs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UsMeaVij;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 92F2642AC2;
	Tue, 14 Jul 2026 18:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6A11B1F000E9;
	Tue, 14 Jul 2026 18:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784055214;
	bh=drFn20uL6NhR91DYLEIp22lK9ia3uqNE29xicoI1pdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UsMeaVij47APGwJcrPHXd7+hvVpqN+150v8Uoyo3YcdjZ3MCelNg1wwak+G7n+BBA
	 dDxZV64KRRxMoOkvybY2pS6s3+PN99UwHmTbuC9Fp2cN/GkTJWlQs3XVDQwDm0ZDpM
	 QENQggcZF9bYD7vQTVsOLF4jjxq2LMy+qTCTgZyjJlEvpyvlvRwR9GPmUealIC0OGl
	 Vz6ZCn4Ed/wghhnkGiDsAKyHglmHMWqAH+Sr6O9J5aQK2Q9Wv/0Skme15W5ZEbT+uW
	 afsqlsPnikFiDOlzluwuI2WiI9Q/05DzhmD0jmBMmnaDOviNUcjYa4ejwIWsouX4aB
	 HTexjKWSk9Q2w==
Date: Tue, 14 Jul 2026 11:53:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Zhou, Yun" <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <20260714185334.GI7398@frogsfrogsfrogs>
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
 <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
 <alToBmAN_HyeXth9@infradead.org>
 <20260713230420.GN7195@frogsfrogsfrogs>
 <0792c175-6a7c-4108-966d-4afbc8c515a2@windriver.com>
 <20260714175528.GG7380@frogsfrogsfrogs>
 <alZ80Dv4uNWWhrDk@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alZ80Dv4uNWWhrDk@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 958FC18000C
X-Stat-Signature: yapkptth8ya7uz8ipmomd1dfjongi7sj
X-HE-Tag: 1784055215-163964
X-HE-Meta: U2FsdGVkX1/hPT518w+eo3uSTBT4gu+82di8qQIH4uoQd73B9AiKE2Cl4Cq5tK0R7GnHG8vOAoY3bahBEfeUosOa1uzmb55nloFDcsnBU3sv9ZvP3FDpff61SVZB9LQBkwim3coDrU8Qkk76ZipCwyouEmQ01rQo+G4zubWdF5JY3XxkkedveBTNH1356x0AiWQQpJQUV6Rx+KsbldFKiY1UZsaVy3bFsaBS4am0RBMr1xWKN3O/c6aTOkNSns+pj7fSlHsGoRombnFrKf2DLdk/ejzffxWs0SAnZ1DI2cZ8HndETxD90Kzn0FEPk87N0fWzVE5beMyKM7Doa2QxTYU7FekfPHV8D+Ef1CqUmd3ad83x5B39XMkUKsDbGGlotHmGlANtSTrr3OfFqVvL7M5fr1Le7avD4EnrIc0vUaXNVKwfHUuGmzuzfEKtd/Xgk9DYDCWbEdnqRhqu2/iiyuM/PZbJuUi0enXOKprxiZbn1/MWGUuyy9sRwBkgwoBiB0AU/NXdMX3RheoSnT5IDCJQjpP749YwmjVy+yGavqE3JlKAmqtbph6VkM50aIKnafmrIGN725iw7SBjF+mU7YdF73YWXfMTfJBVGuRCJtwMyrI32BOnbDA4gcJRXBN/TcJ6pHnSEGVA4tryRXVqUA7rebRYWUJZPkUzMgUe++LbBNBAj73UnThQvq4nvrjAomNU9G36CsRidjkh/UvtbXD9EyXKWgzw6dBa5QmO37zoby/KzCmATeaqwXB548hRUkMj6t2V8GDTNi0plXh9tyXwIE0IHz/e3WcbGTbBaSecZ7BAEyGkMxNB5b4oRSNad51AwYyTkB6/oMMD+tEmss1JlUzBnGVhko5yva8zShVCDeV8IscOXJzDJNnztKlEJY4GNLkR6hOFL6pvBdKVgAXILDR6DNjCVlWZnSxik961+j3yXpj/iU/LAlPurZUWsUaOeXPBSKsQBUX/V/i
 K1gEniEb
 8ZyZ3zhRKNO4yB3laLZABfkxRxuxjHQyFsT5htgguuS2wsRqHUfNhydFSxYvJXwY3x6evLUNT7rjvZbbolY7sekSQY/GCjCorlrrI7HWHce69LDanm6GuD+0Rp3fgGdXt/SQkB5GNMiT3Iwi3VRpPattMtCLCybwELmFbC9dCCbB1tLngyDTRi7F+tdaD12S7FIMy2uRBisX2lkXmKduy4N098LyqgJV/USPyyyb6EgtD24KRDyPQjI2zkc8rKHoXA0KzmOm2nRtT8arhgex7xXps/2nQVhKNf/xt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 07:15:44PM +0100, Matthew Wilcox wrote:
> On Tue, Jul 14, 2026 at 10:55:28AM -0700, Darrick J. Wong wrote:
> > [add linux-mm since we're talking about memalloc_nofs_save]
> 
> Thanks!
> 
> > On Tue, Jul 14, 2026 at 10:15:53AM +0800, Zhou, Yun wrote:
> > > On 7/14/26 07:04, Darrick J. Wong wrote:
> > > > On Mon, Jul 13, 2026 at 06:28:38AM -0700, Christoph Hellwig wrote:
> > > > > On Mon, Jul 13, 2026 at 06:06:38PM +0800, Zhou, Yun wrote:
> > > > > > On 7/13/26 17:09, Christoph Hellwig wrote:
> > > > > > > On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
> > > > > > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > > > > > index 7bfbd9f6f0df..1b36cf12d4e3 100644
> > > > > > > > --- a/fs/xfs/xfs_trans.c
> > > > > > > > +++ b/fs/xfs/xfs_trans.c
> > > > > > > > @@ -1029,6 +1029,15 @@ xfs_trans_roll(
> > > > > > > >          * duplicate transaction that gets returned.
> > > > > > > >          */
> > > > > > > >         error = __xfs_trans_commit(tp, true);
> > > > > > > > +
> > > > > > > > +     tp = *tpp;
> > > > > > > > +     /*
> > > > > > > > +      * __xfs_trans_commit cleared the NOFS flag by calling into
> > > > > > > > +      * xfs_trans_free.  Set it again here before doing memory
> > > > > > > > +      * allocations.
> > > > > > > > +      */
> > > > > > > > +     xfs_trans_set_context(tp);
> > > > > > > 
> > > > > > > The tp assignment above now returns the incorrect transaction when
> > > > > > > __xfs_trans_commit fails, so you can't do this.
> > > > > > > 
> > > > > > > Otherwise yes, this call should move up.  I don't really see how
> > > > > > > it fixes the syzbot report, though.
> > > > > > 
> > > > > > Thank you very much for your reply. The tp here is a local variable only
> > > > > > used for convenience within the function. The caller always gets the new
> > > > > > transaction through *tpp, which was set by xfs_trans_dup() before the commit
> > > > > > call. Moving tp = *tpp before the error check doesn't change what the caller
> > > > > > sees - *tpp still points to the new (dup'd) transaction regardless.
> > > > > 
> > > > > Ah, right.  Tis should be fine:
> > > > > 
> > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Why not move tp_pflags to the new transaction in xfs_trans_dup like we
> > > > do for the deferred item list:
> > > > 
> > > >          /* move deferred ops over to the new tp */
> > > >          xfs_defer_move(ntp, tp);
> > > > 
> > > >          ntp->t_pflags = tp->t_pflags;
> > > >          tp->t_pflags = 0;
> > > 
> > > That's what the old xfs_trans_switch_context() did before a1ca658d649a
> > > removed it. The problem is that setting tp->t_pflags = 0 means
> > > xfs_trans_free() calls memalloc_nofs_restore(0), which relies on that being
> > > a  no-op — an mm implementation detail. A fresh memalloc_nofs_save() on the
> > > new tp keeps the save/restore pairing correct unconditionally.
> > 
> > So add a new helper.
> > 
> > /**
> >  * memalloc_flags_take - move an implicit __GFP_MEMALLOC scope from one
> >  * tracking structure to another.
> >  */
> > static inline unsigned int
> > memalloc_flags_take(unsigned int *old_flags)
> > {
> > 	unsigned int ret = *old_flags;
> > 
> > 	*old_flags = 0;
> > 	return ret;
> > }
> > 
> > and then:
> > 
> > 	/* move deferred ops over to the new tp */
> > 	xfs_defer_move(ntp, tp);
> > 
> > 	ntp->t_pflags = memalloc_flags_take(&tp->t_pflags);
> 
> I might stick with the 'move' wording?  ie memalloc_flags_move().

<nod>

> And I think you should bury the call to memalloc_flags_move() inside
> xfs_defer_move().  I don't think there's a case where you'd want to move
> from one transaction to another without preserving the nofs state, is
> there?  Bit hard to tell since there's only one caller of xfs_defer_move()
> in the XFS code base.

There's only ever going to be one caller, and it's the transaction
rolling mechanism.  I wouldn't put the memalloc_flags_move in
xfs_defer_move because userspace transactions don't have t_pflags
because NOFS is meaningless there.

--D

