Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B0ABC79F82
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 00:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3316B0088; Fri,  4 Sep 2026 20:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB1E6B008A; Fri,  4 Sep 2026 20:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3B36B008C; Fri,  4 Sep 2026 20:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 809926B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 20:25:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01A8F1C1950
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:25:44 +0000 (UTC)
X-FDA: 85177815450.30.60F7B4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5CAD680004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 00:25:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GISoGbW9;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788567943;
	b=hIjRXo7OOAD/hv6Wt4QFGReLf7Refo3f1M1p8b8I1erD0V7VRo7E4jk9U8ziMWChTT8jRW
	LycuWaYiWE4ZD4DOWoF0pife+Z86JrCbRLlO5TpHUZreqtgG+njsJ9BB5CKIB6JDTN/BWW
	jX/adL4gt2jlmWyfaTskRFAuIecatMQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GISoGbW9;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788567943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQYnje899FKvd4OwbogGnsKo81eCP3MOvqztWDAn5BI=;
	b=aH1zn0I6kiO00qXVwyCpMM9LP6vnvkyJqcN1S49dQvtfyoF9istlxOvGPoINCGbFtEg3ZN
	clErC5/AGHFELvuDYtxtyJfyZQOkZCs+oET36watKByBafmAgS/iY2w1Qo6eJjanniKDdm
	tJB/Ta2opOac8e/YOwqhPZP4hW68HCs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E158600C8;
	Sat,  5 Sep 2026 00:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1029F1F00A3D;
	Sat,  5 Sep 2026 00:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788567942;
	bh=LQYnje899FKvd4OwbogGnsKo81eCP3MOvqztWDAn5BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GISoGbW9NnWYZnRkQqafWHNK1B8tC2pPYpwMvEoaRsnLNrbDyBTFxMHqhpasMVYUL
	 dxgk7l2yUNPr8waN3UmVf77YS9sthi/GR7930So69JfvSCXHT3RftGgtG3E8BzOY2w
	 VB/Q1Srmigvct/Bi5qSBecTmhgXsqSHtJ+Kzi4eyY4dMk2m9etNt++r7CuzQQ9EM6W
	 OqstIa8Dpi6y6VIf7EkN7Sc++ykIHjXxGiPDrEhjkfiWJK7pAl4F1TSIFS2X8vEddx
	 Ty3b3PBiGh+RePCBwwNDSiMRITtEKzHJ4bdLeC55/5R7MPPPM2lsridRMsIleB8q1g
	 8Vbgr1ksAAzLA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Fri,  4 Sep 2026 17:25:34 -0700
Message-ID: <20260905002534.67885-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904153637.9670-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CAD680004
X-Stat-Signature: ummqu3nheag6dnrj6b65pggesf4cw3ui
X-HE-Tag: 1788567943-56740
X-HE-Meta: U2FsdGVkX18IhWon4P21kfEekX/J3tiy+vCDPznvJP2bbrIS3QdW4nCD7oVMznd7DpHjkQ+cB6pw6i4TGsv4pJ+AYzgKDLW8OXKSAGByGcCQG3L/wZTxJ3AypfynL9wCDnN6VxCWrHxFzOoUpWQs1wh3VYR6EHHepKDd3785tZwV3xmG05mvwfkysT8I2/YV0PEsOVgZ0/cvhwAC5lDgsEAhdkrH28DL52J6RVxbRJaGLiAlxVEMOOw5Iv/aY8gSlbFGcigPJ+WD16xXEXS/1to/WjP2rIAwB5QdOZ/MmFcz0mcp1Q35mwn64bxUaK+C6EYfB7IR0aSVzmXATYbSxF1OIeRRygNfYVoYkBam+QCOORX+2YQrIMqfoyzcN24kBHP48KT+K43SVjQtLXUZuxKej5slvcuRQVz9CB3SbLKG4NsVtelXpe1RKDHqXvoHu9YFc8brRlr6qrH8QNtDmA4rPeXVFBsxRIMU/YKgpZ0heKWMrtsH1CAT5beEb8qMHUc4YBg3KAu26XG/Vf6Uyu2JYPWRnuFt5T4+UVzd6jVGb8OsfPeE6YuIC3OaoF6scC5Jz9VSDBJim9E83Jg5zdBLwaLLy23vejHr3PfHuJpoxD+KNIU3E2vlHazPXSDo7FTaIVOWMconzjs1jmhU/57lS/buowBewX+TtAHadGBJgP4Ybuk1WvqthH8ncsoVQOVC8gdJOOmogewJli2wRm3MlYBrX00q5k2WzmmiCM4ci/qLW6pOv6duVP1CpDZUC+XDTCsxwnFUj0+ofexIeMpqw0bamD/fwZ+59vqC7JXnBASs5GM0ckuG5bK9dvW6PR9V2rmuAvZ7Z2bDq1Iy/Xce/u2TN3mSk53l3Fbh/Uf4eyyB++4m3xihjwvoP8PUvD0eQVCDO5/UHdYi3YFsUlKNYg4k4Tio5hFLMpMUE4Pbstej/ZXTomNLKOJiL0UkTRIdfxU/SNmui+MHxkL
 ZQk1mhBH
 1I83HV4aeOWGdii0RkW7IjmKb3rhqzoHX7fbj7i/NCvg5do0rm1BNIipYRsQPwNp8aS9elc65eL8fDck/ZrTmrM6/8b18GZWb1nr8FElX1fzqs6oPLfwl3yltI/7Uf2V0/1nAFjifv6WMYQC3JBLHXIWuh2CKFJSUM3SndsA8BpUWYQskZoaIiMkYlolYx7A1cyyDtnRN0gn6+vwIIGXXei6Wzo70hpnwZErm+Ok9gNQOaKbgfdJ9NniS13lXHc/fyHPuHyqqPovJGlW4l9ZSYYbTSFIyA2jTPS/lKWypHji6k24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  4 Sep 2026 23:35:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Fri, 04 Sep 2026 07:05:35 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Fri,  4 Sep 2026 16:07:41 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > First, I'd like to clarify that this isn't a problem encountered by a
> > > real user, it's just a scenario I came up with.
> > 
> > Thank you for clarifying this.
> > 
> > > 
> > > 1. Users sample qt_exceeds periodically (e.g., every 10 minutes).
> > 
> > What's the purpose of this sampling?
> > 
> > > 
> > > 2. Within this 10 minute sampling interval, the counter aggregates both
> > >    the real quota exhaustions and the increments caused by esz==0.
> > > 
> > > 3. When users notice a high qt_exceeds value, they eventually realize
> > >    (perhaps by reading the code or documentation) that it includes the
> > >    counts from the esz==0 state.
> > > 
> > > 4. To get the actual quota exhaustion statistics, the user is now forced
> > >    to perform additional testing and implement external filtering to
> > >    separate the esz==0 increments from the real exceeds.
> > > 
> > > Even if we explicitly state in the documentation that qt_exceeds
> > > includes the esz==0 counts, it still burdens the user.  The user still
> > > has to figure out how to filter out the esz==0 increments externally to
> > > get the signal they actually care about.
> > 
> > Users set the temporal goal.  They can know when the goal is achieved since
> > most of the goal metrics are already exposed to user space.  Users can also
> > show the current effective quotas.  I agree that can be cumbersome, but how
> > problematic it is?  Also, as I asked above, why they want to do this after all?
> > 
> > > 
> > > Honestly, I struggle to imagine any valid use case where a user would
> > > actually rely on the qt_exceeds increments caused by esz==0 to make
> > > decisions.
> > > 
> > > If the only purpose of qt_exceeds is to let users "easily notice" if the
> > > quota is too small,
> > 
> > I agree it could be a signal to show if the quota is too small.  But the real
> > purpose of qt_exceeds is, in my opinion, letting users understand how DAMOS is
> > internally working now.  After all, how much quota means if it is too small or
> > not?  That all depends on the real use case and complicated things including
> > their SLO etc.
> 
> Thank you for your clarify.
> 
> > 
> > If documentation is saying the purpose of qt_exceeds is to show if the quota is
> > too small, that is what need to be updated.
> 
> I completely agree your perspective.
> 
> This is the current documentation of qt_exceeds:
> 
>     - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
> 
> Although it state the purpose of this statistic, I think adding a
> note to clarify that this stat also increase when the quota is zero (but
> not unlimited) would be helpful for users.  For example:
> 
>     Usually, a quota of zero means the DAMOS scheme has an unlimited
>     quota, so qt_exceeds will not increase.  However, if user sets a
>     temporal quota goal, the quota is set to zero once the goal is
>     [over]-achieved.  In this situation, qt_exceeds will still increase.
> 
> I can prepare a formal documentation patch based on this if you agree.

Yes, I believe this is the right direction.  We can discuss further details on
the patch.  Looking forward to the patch.

> 
> [...]
> 
> That said, it's not important for me to add explanations to the
> document, but may I know why commit [2] changed the behavior which
> introduced by commit [1]?
> 
> Commit [1] Behavior:
> 
>     if (quota->esz && quota->changed_sz >= quota->esz)
>         s->stat.qt_exceeds++;
> 
> Commit [2] Behavior:
> 
>     if (damos_quota_is_full(quota, c->min_region_sz))
>         s->stat.qt_exceeds++;
> 
> Before commit [2], qt_exceeds will only increase when quota->esz is not
> zero, but after commit [2], qt_exceeds also increase even when
> quota->esz is zero.  I'd love to understand the rationale behind this
> change to better grasp the design evolution.
> 
> [1] 6268eac34ca30 ("mm/damon/schemes: account how many times quota limit has exceeded")
>     (Fri Jan 14 14:10:20 2022 -0800)
> [2] c7ec7d5f6b3d1 ("mm/damon/core: handle <min_region_sz remaining quota as empty")
>     (Mon Apr 27 18:33:50 2026 -0700)

Seems commit c7ec7d5f6b3d1 didn't make a behavior change that you are
describing.

'''
$ git show c7ec7d5f6b3d1
[...]
@@ -2601,8 +2613,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
        if (!time_in_range_open(jiffies, quota->charged_from,
                                quota->charged_from +
                                msecs_to_jiffies(quota->reset_interval))) {
-               if (damos_quota_is_set(quota) &&
-                               quota->charged_sz >= quota->esz)
+               if (damos_quota_is_full(quota, c->min_region_sz))
                        s->stat.qt_exceeds++;
                quota->total_charged_sz += quota->charged_sz;
                quota->charged_from = jiffies;
'''

And I don't think there was a behavior change.  Hopefully commit 54419bbd0ee3
("mm/damon/core: allow quota goals set zero effective size quota") will give
you some clues.


Thanks,
SJ

[...]

