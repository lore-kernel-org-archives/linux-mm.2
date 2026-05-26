Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23359CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 19:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0AA6B008A; Tue, 26 May 2026 15:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5700D6B008C; Tue, 26 May 2026 15:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E446B0092; Tue, 26 May 2026 15:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31EA76B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:09:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0507C17DE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:09:16 +0000 (UTC)
X-FDA: 84810509112.16.8A268B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id E569120003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:09:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GNr35sdM;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779822555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Q+7F9jkpzpdArbUFuaX2fYSOOw55N51m56qOke4nGA=;
	b=5SB1kI8Q4Yv7MNJlYrbrHa6Nrly2BMzxaoo0T+K7RvjF9rhIP+YUjYXyjTJ8h/192SEAXV
	Xpx3XZ5Nc7WqBN7V0AuV7HhzgO7ZtdSRr1IXoUhDe53pIjjuVQv/QkZh1Bt3LSLne/E/HW
	Yv0v1cm8wNt4IoSjo8uxv7hCOY0b0uc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GNr35sdM;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779822555; a=rsa-sha256;
	cv=none;
	b=6HwN91GPjtCfEdlzwwG1XptxqwAZGY5X3gz6VqQpi0z/I44TxAoR+o+2J/NzLSvpBL5Hi2
	xPblTLWJVYfshXaxCGpt4eiez360BHHyCssNEiRMeZ1WHaWxMayf+8qNKrrpCfVKme+gyg
	JWmeDEuAdVY7MJiLK5M2F2n+n8qZuWc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3961B60126;
	Tue, 26 May 2026 19:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2441F00A3A;
	Tue, 26 May 2026 19:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779822553;
	bh=1Q+7F9jkpzpdArbUFuaX2fYSOOw55N51m56qOke4nGA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GNr35sdMl8L0pN7iIvRepKjYtv/5tv0fDmU1kyIXm4XoTDCjiW0oVsLh+U/pbn40a
	 eZiZcZ4kEozF+jGgwN1JryENR26NyBhp7PnNo7CcK8AhAOUERG5q0kI9VtXyP0dqwp
	 wUqL6k4RqU19aNN1SzcMbQpmmDcr+qC9EKICQ/rw=
Date: Tue, 26 May 2026 12:09:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Nico Pache
 <npache@redhat.com>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-Id: <20260526120913.937a4d483af214ad050166dc@linux-foundation.org>
In-Reply-To: <ahVX1iq_-95vd0PN@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
	<CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
	<bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
	<CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
	<a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
	<ahVX1iq_-95vd0PN@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: et448i4acp61swgr7ekmwx4a5ikfemfc
X-Rspamd-Queue-Id: E569120003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779822554-770087
X-HE-Meta: U2FsdGVkX1+b5KwJ8nJ/y5bJOpu7Su7qEqYATSU5G25zmZ4CaemfHtAs54v8hyefXp7RhM/p2CpM113fAye4E3BQuPw2qkxjqQ1GO9yfuHX6Vvk+mdoqQUVcl8jgTWyIq8N/JDvC88lrWTrpMMTN0qtkA9BoGDSHym9dwjGzmKhliAbHzqBKSG3JnT0KZ1s6UEFdSuLC0X84Gocd6u+Lh27vS3XMXpolWJzUc5KrazrJ8m1+dHlxsqpoU5Ek+cz+UeRpd1QkBx1oVsM2PJjLGqsutCYJBDUzOrK/mV3IMTP7Og+nc2jxXb5aQi0JL+d5vHjNk3XE+zTBMA5OGqDF+n8Ah6ctnhZsJ/SEiZhwIECKywsvWAY+5YhL++uL+Ktce+WvnJHrlqLTqxwsj9UrJJTEY6mvmYbmQ98kgJu2QrDnIPKwRnCAm0RDpD1Mp5Ey54K/qHwyh8hp4zeRBV1nwNcoDOKQc78C5u/ZBq6a6p9dDxIBn2LBetXh4PRXIxISY+WEM1iZW+ZPOj5fS6uRQGnI55uSyNT5S8SpgPh2bbQxVQKCz29e1HvpdsjG0zBvk/XTcs6cuHPGLHBLpJcYfyIV4WhhWmoWrQro56qtjT7YRC5wMcuooBbJlY3TVOIZDOWSdkuYFEYHvYxnOPv7TqNxu7A0HFdCXoieccKx4q2woi57fT9Jn8vpuKlkeBUKvjZDJN5o7z++ZQ7n167My3+0Ac+FfBjT2uMOheN83tA6mXu0ID1C0VA2l5NocsbVzVurepam7idrbT9b4FGb6j3T44nQQUGu08cM1cP3Hz7tWFUe2n1A23mjlw9XoGABH1ao62UeZ5F8bFeLytvC0bwUyr4ikbiubCS4PjoP1XmjfVSVFl9RAHjejirw1xz/VAmLQeZ5Zx+HTUykSspG3ZUCy5bRzY6R+uTWdFgS3g7aOMQHZwqNlE+3EloqqYTXf8SAhjUhmB2BXw8rvwg
 cBnJHCvC
 M0X8ryCsX72XsFq/RpE19cl9lckbe0ANQ2LrsNpSjJ8Q0zbzT4Nh4EBqWHiBvO5ykrzEeLdDtH0gp7g+mi0eu2fmklZKq9rCzuytzmIt9yATKak5YKK5YeRvMFdpo2WtUB5g93qEzQz10A5VNhZyN/7bsHRR80twuLQtzfmhaD1tRAUspt4TUgTUGrC/6PPK1IP9iA88+Cs9JNP8yVM4v7cwez0tP3EN38lnTXIUUOsoXJ/aCB8S+wr8atQ6jPlpGXppDQpW3ZLHX8UsXDf91cI1xJpC7vWPl5jxvWLdCSFQbHzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 09:33:08 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> [trimmed cc list to avoid noise, apologies if I excluded anybody who is
> interested in this!]
> 
> On Fri, May 22, 2026 at 11:13:42PM +0200, David Hildenbrand (Arm) wrote:
> > On 5/22/26 18:11, Nico Pache wrote:
> > > On Fri, May 22, 2026 at 9:13 AM Vlastimil Babka (SUSE)
> > > <vbabka@kernel.org> wrote:
> > >>
> > >> On 5/22/26 17:07, Nico Pache wrote:
> > >>>
> > >>> Whoops I manually changed the coverletter subject to reflect that this
> > >>> in on mm-hotfixes-unstable but never updated the others...
> > >>
> > >> But why? That branch is for hotfixes that would go to the current 7.1-rcX
> > >> series. mm-unstable would be the correct one for this, AFAICT.
> > >
> > > Sorry this was a misunderstanding. The goal here was to base this off
> > > the closest base commit behind where my v17 already lies in the tree.
> >
> > Ah, I guess this is a problem of "v17 is already in mm-unstable, so against what
> > to base v18".
> >
> > Yeah, we touched on that problem in the LSF/MM process discussion ...
> 
> I may be misremembering but... :) [correct me if wrong]:
> 
> Wasn't the general conclusion that we maintain a stable branch (Linus's tree +
> stuff that's been reviewed and is locked in for next release), and have people
> base work against that?

That was the plan when I initially set up the mm.git branches.

It turned out to be quite impractical because it takes so long to get
material into mm-stable worthiness: around -rc4/-rc5.

We could address that by delaying everything by four weeks - so MM's
window is out of phase with Linus's.  So there's a lot of "stable"
material in mm.git when Linus is at -rc1/-rc2.  Problem with this is
that by -rc5/-rc6 we'll have a large amount of material queued up for the
next -rc cycle and it is against linux-next rules to add this to -next.
And until it's had decent -next exposure we can't declare it "stable".

This needs a diagram ;)

