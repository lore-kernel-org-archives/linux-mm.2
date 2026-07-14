Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E1DC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8856B00BA; Tue, 14 Jul 2026 13:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469AA6B00BD; Tue, 14 Jul 2026 13:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F2F6B00BE; Tue, 14 Jul 2026 13:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEBD6B00BA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:55:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 854A01A042A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:55:31 +0000 (UTC)
X-FDA: 84988134462.15.BC5C412
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CAE5DC0008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:55:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQH+uGuf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784051729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqPa6Awexo1sZ9NAhkSiBlt6klZOADUjfwrP4NV/fLY=;
	b=6IHpLpDvE0Y7R4OGaDwMin29UbCgeOHz/hnuBqnwz3chKwkoSkyINv1g869JMTLvso1tGI
	lHzz0gZ/EPuMVIyL05y+lXSTI+8ROhhkALE9cfeJ+sH4xLvQJu2eqa/gFaFIlWl5R8zdOe
	gkCn3ELAYRf4yeKDatv4Es1xaorIHDM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQH+uGuf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784051729;
	b=VgAkArZjt29ZH+BI/7Z3Tj1v3I3cdHPmXZ9+XmY5Yr8kJj8jGYquRHmJ/Gq+kSVwqnWCPy
	mj7WLcYXW6IbY6FQHHSfkPuMiza5kb693rLyTI48OFigb8tLjKU/Etrpj/20pwhCgdbgMg
	fnQbZkgngcc5AjlERnpLMjJJcQEFDC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 0EBAC413B6;
	Tue, 14 Jul 2026 17:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D8CDB1F000E9;
	Tue, 14 Jul 2026 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784051728;
	bh=kqPa6Awexo1sZ9NAhkSiBlt6klZOADUjfwrP4NV/fLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GQH+uGuf7cG6jloVA22oC1BzvBnCdLn6AaVkT11e9Pl4dlrZGqhSiKh/vPEmjkhUD
	 fF/zQxGSmJIehfWOBVrypqs9fxhp+3sTIWs8usgUkzwuvgPtVyGyiPtP4Hydrbq6OB
	 peDtP0/8RQIj1W4l1b7eHIe/XwxTNxh2/LBPllthqzyZHWcI1GfP6HPc4IZBwGWc5v
	 708AyWb9OC4FTGIlsNXG1VjviLyWmvxf7+P+bISXLDRNPGX8h5NbI3IHfNXjDfWet0
	 tpPgF0TWMHuCOj8/oxx7kqkTGJXEK8n7ykLKBviqU9GHH0HzdA4glcbugdTEuJlBmP
	 +vg20gZ1ZRRLg==
Date: Tue, 14 Jul 2026 10:55:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <20260714175528.GG7380@frogsfrogsfrogs>
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
 <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
 <alToBmAN_HyeXth9@infradead.org>
 <20260713230420.GN7195@frogsfrogsfrogs>
 <0792c175-6a7c-4108-966d-4afbc8c515a2@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0792c175-6a7c-4108-966d-4afbc8c515a2@windriver.com>
X-Rspamd-Queue-Id: CAE5DC0008
X-Stat-Signature: 9pgaxkeoxff64x316z5u4183uup95xca
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784051729-182729
X-HE-Meta: U2FsdGVkX18gKxMItFx36/9YrQl5BPtEgKwiPiS8gQOr9EdT8Wup8/iOve0cponcbs91KsLAkMQqwLE+UL7tqDmW0UlefujEXGl1ggMQCMVqsWRHHyGfbdjeCdRuaqlrMPZfF7R9DTIQFRQq9vFidZnifdv0Hr1Uk+5Kbpt7Fv5zVU2030gBpdKIBJgmZ9rwSZ5RGpN2bpwHAp2TM4fFZqKf9+ow3cMYDQ5pfVR5izXR8o+Bmni8ntqYQ9jEqPsr6GzPFeF2dvCwfRolyNInA2hWtwtFCE8gfdRH6oAIWr6G8oo9Px7W5MtX0vtoyJhKO7v1p6KGUqUrytQr1nZh8N/QNnu7dYzx9Fj6DirFtyXSs2mlsThYaX4aX82ygaY5QERhsfhtK9GE+/BukNjVfZZ05x5MtiIfyCiCt3uKscso1WRKoWhfVlEgYdgUKTQbt8RW03awSXIjHzD9OdaKGnm+duzCqdLa/R278AX/D2uyvfV7mC6rsJ0P+a2FlI2Yk3IJd3mnY7o/OVOwSP60hobq2+0nz4APjxjS+IwQ+cle0KHkU4AXc4WsgxFSf5HWe9dXuWpfEAolUEUAIg8ET2NR7sNRPn9zNaUZ1br8eqRBTiPc1uS5JjNtNXcSj8R1DFzj2HUpZwKBcUBVvRe4QiEvQ1VzirjA9c+QdvQJmM4PBgM2taWoV5kf+Sg5+3KWwgwPmyB1cRWLRExUHwf1QzWBEB5xgDuEU0r0euJ9sEtoMGA0WrDq3P6FM7uN+0saRV5qdd9U0/lzNhqNgmeSe9nhbkLL6Dy/2554rxiQ0aySoUFXZ6sE8aSo5uh9jH6u7qkiCww8KUzq8sBFhYK+Hd5YkYs1A/0W27QO7JUwR4R2//3SvsYrBT9C9uo6QCDiMih1ojGJ3dJfdIZu3YmU3D4IsthhcsjY3iADTPXoVBWxx8RCBxADnE8HPehL+Yg7IpB9X+doQR9TkYr6OmL
 kWUdNdmo
 owXtD5YpCopRTjYxkF3ZHXFUPLVcTckXbbCIi104JopQ+b20ze4Z2oojWxBLcx0lrtYj0+qyvbPUjCSMYzan1xGbXTRiWod6uAMZSCU+LJoZRAJZHujKpp9HPIOFgvjRqinU+enMC8EFe6EKYMniScLSbKBR7WvK3hiGTA+BmaExNDmNXCF2V16mFzuyWGcQXsKv/ZSr4FFVyYltqQ71cG3cLUME2BYDHzfkvl3zGoWBI6l/lo8C63rGUqgiYElvu4pI67AqUAm1eVIkiZma4NgsOfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[add linux-mm since we're talking about memalloc_nofs_save]

On Tue, Jul 14, 2026 at 10:15:53AM +0800, Zhou, Yun wrote:
> 
> 
> On 7/14/26 07:04, Darrick J. Wong wrote:
> > CAUTION: This email comes from a non Wind River email account!
> > Do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > On Mon, Jul 13, 2026 at 06:28:38AM -0700, Christoph Hellwig wrote:
> > > On Mon, Jul 13, 2026 at 06:06:38PM +0800, Zhou, Yun wrote:
> > > > 
> > > > 
> > > > On 7/13/26 17:09, Christoph Hellwig wrote:
> > > > > 
> > > > > On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > > > index 7bfbd9f6f0df..1b36cf12d4e3 100644
> > > > > > --- a/fs/xfs/xfs_trans.c
> > > > > > +++ b/fs/xfs/xfs_trans.c
> > > > > > @@ -1029,6 +1029,15 @@ xfs_trans_roll(
> > > > > >          * duplicate transaction that gets returned.
> > > > > >          */
> > > > > >         error = __xfs_trans_commit(tp, true);
> > > > > > +
> > > > > > +     tp = *tpp;
> > > > > > +     /*
> > > > > > +      * __xfs_trans_commit cleared the NOFS flag by calling into
> > > > > > +      * xfs_trans_free.  Set it again here before doing memory
> > > > > > +      * allocations.
> > > > > > +      */
> > > > > > +     xfs_trans_set_context(tp);
> > > > > 
> > > > > The tp assignment above now returns the incorrect transaction when
> > > > > __xfs_trans_commit fails, so you can't do this.
> > > > > 
> > > > > Otherwise yes, this call should move up.  I don't really see how
> > > > > it fixes the syzbot report, though.
> > > > > 
> > > > 
> > > > Thank you very much for your reply. The tp here is a local variable only
> > > > used for convenience within the function. The caller always gets the new
> > > > transaction through *tpp, which was set by xfs_trans_dup() before the commit
> > > > call. Moving tp = *tpp before the error check doesn't change what the caller
> > > > sees - *tpp still points to the new (dup'd) transaction regardless.
> > > 
> > > Ah, right.  Tis should be fine:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Why not move tp_pflags to the new transaction in xfs_trans_dup like we
> > do for the deferred item list:
> > 
> >          /* move deferred ops over to the new tp */
> >          xfs_defer_move(ntp, tp);
> > 
> >          ntp->t_pflags = tp->t_pflags;
> >          tp->t_pflags = 0;
> > 
> 
> That's what the old xfs_trans_switch_context() did before a1ca658d649a
> removed it. The problem is that setting tp->t_pflags = 0 means
> xfs_trans_free() calls memalloc_nofs_restore(0), which relies on that being
> a  no-op — an mm implementation detail. A fresh memalloc_nofs_save() on the
> new tp keeps the save/restore pairing correct unconditionally.

So add a new helper.

/**
 * memalloc_flags_take - move an implicit __GFP_MEMALLOC scope from one
 * tracking structure to another.
 */
static inline unsigned int
memalloc_flags_take(unsigned int *old_flags)
{
	unsigned int ret = *old_flags;

	*old_flags = 0;
	return ret;
}

and then:

	/* move deferred ops over to the new tp */
	xfs_defer_move(ntp, tp);

	ntp->t_pflags = memalloc_flags_take(&tp->t_pflags);

--D

> BR,
> Yun
> 

