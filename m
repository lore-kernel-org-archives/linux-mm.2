Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91C8C5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 03:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B11C6B0088; Tue, 11 Aug 2026 23:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661406B0093; Tue, 11 Aug 2026 23:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550CE6B0095; Tue, 11 Aug 2026 23:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1886B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:07:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94CD51402BF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:07:44 +0000 (UTC)
X-FDA: 85091132448.23.C42D8C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0765040005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:07:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpztcKOV;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786504063;
	b=hUnyA4Of06UshgKgB83qaq9i0f2ixL9vi5eXSF9ZCDCOpOWWWuw1T8OxOPjBtJok9cyNIl
	R1vM8yN2ETfs8naDswx0M6+uQ2cj+oml/ioRuM3QY4qupAwDJo9kLFiPSelssTa7ITsAxu
	uihDhotGhIMN+BVIGSSmtLZFHPQ+GcY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpztcKOV;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786504063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pJkuoHatQ+SArs9G28f8aRqkTwBhTBoxrzbmBbZkkvQ=;
	b=kWcd0W4nMqgJUM3yB9F6A64Els7KthZPKTw2JdhhvVagI3260n/LuUB9vEpuES6dcR+N8O
	FCaEuXDPtJ+7WB2Tjrw2gwmTYk+uvQ3yFx7YbG56mWG6Sn0GlAhIuyqR7Kni+5/Heiyqq4
	0CsqGYUpsGQ4Wzr2DYy5BkDmRrouJGI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B6D0600E2;
	Wed, 12 Aug 2026 03:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AD91F000E9;
	Wed, 12 Aug 2026 03:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786504062;
	bh=pJkuoHatQ+SArs9G28f8aRqkTwBhTBoxrzbmBbZkkvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpztcKOVjRom60I76BQWeohbn/0zBZyukjnb3kaH6nCXUminVx9EEEcvQrZ8uRCpb
	 Ba7pff9vTGbo34dPmNrGj1L+ub/VeQHFxyXu9p502xxysPfBVmiSKpvBSghKlI729w
	 RW++PavfS4RszBXHLNieQNTbuX+YtjQdxgthY/ljsPbPKvTiKnB3cLWcSsiq9vXz8y
	 c1WNvndAFNkIVtbB9HfDYo2NQbDDWFgdDCGb0dgFYLbXzI6gAt4kifeBqYCjh99PPb
	 CYr2a5W4vol6kVaur3Brp4lRIm0Sasrd8goPdeX6KyXfd2PwTqla2SyopB3YNsZJrx
	 lSWyRIcQ7Hseg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	damon@lists.linux.dev,
	david@kernel.org,
	liam@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH 0/3] docs/mm/damon/design: add explanation of nr_snapshots
Date: Tue, 11 Aug 2026 20:07:32 -0700
Message-ID: <20260812030733.8996-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811170252.32705-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0765040005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yasna16c4zgubgcdhrbaocqbfarda4we
X-HE-Tag: 1786504062-779355
X-HE-Meta: U2FsdGVkX1+b5HklB4kALDYcPtHey7feEzqAc+/eKHtJQlTICTCcuEE9arkOwwZGaq1J93C6WbDgrCTM7K84cq68F+XRb1DSarVhWMnrxK/zN9/E0S2ScN/w1j4D6nGtq0REAAunYuM3jgLZvGZn6bTWTnFAbxpz77UX4Byxpze/Q6ec7b32Sw/u+X4iDKkLhQ4cwADOyWN9txfkAIb+Nq8WXtsu7mdeIvfNzdzirbB05yE8Fegb8mIUrNJYSa1WVE3FBZLOGzNPkiDnNesIu6s/68ZGBbltFEfO8eGc1XJvTR6WVT0sc3A78ppIEerqlfIbnLqV7Rp75pNCuXB2rBEwk+FWxXY5SL531JoOsgmBCLE9oOvVI5XgzWqTfjKsP97QXNRq91JVagoULLxUbDupP3Er/3sYhkE7pXT8gPs1AYBIcYC9UtdmT1oqSqjjGdE0zLi56MR136n1gHUjre9sf0aOX6n3N0L9u0oNKTjUNUv/4fW3HWyV9vBOjOYG877Miz+0y90bQ13dptm6lBrRx70HAWl15FHGJk+xecdMzh/EU2tevDzvoofeOWUMUOdUSXSuqrCCv+5P6/3dmhkGhW42CJihvtTWvbYMtsiaTfm4hvUwk5k9AcergimqEtFoRBuWdreQMR4tWNN7uYRd7RPYMWpsWWcWLzf3ZlALA3HStLg8/4VrZZeT9+sQ9fbD0QS8Zt7ILn9CgZfPEr3W/5LQ6gU2PjCkJDjZzOvkBjxdJG1HJEcZudRL7RGMpwheGh/89s3jaPm+e5+7/4O0EBWqmLpxiGh3Nrcdziabol6A69P4r+tWhb+NOogEMqbvcf1atbTWNJfdZyvb1asE7Q+DEWCTjKLnUo6xmJgPl/XNrcRkYUDApylVfq2IMDxcL4zG1B5fMGwmOQwcytmfLELSdQtATWPy2IN0qABRMA3MJYbkqRQPMMgTRkYTgjNK2vGia41jj+cI6xH
 c/sVbRMP
 i6BxoOaWnUNvZzFA8tpElQELEDDe2e8UQbOZfwqqKipcsWr1SDugti8UDROWuZgwH/slRyV6a87xp16/36tOoLntMtaCE8bDWi+PTtf10c7EOOHnmrB7Wl7yaLgTn+KmBSVpGj0av2N2pyI2mRGzB+RRJojnFEjGOgL0AWk0oq14/aJugQ7dXvb/boBKAhFVvTZJZ54r6YDtqPbJIn7eiyVYYFHfGRxaKMJKr3c9+pkDjsYF7S4dZTQLQf9/sQ5bTXWhFMfELGWkYZspDPT3i+b98L0UdjM8g2x3X+bqf6ftyOX+usOyKRM8JO88/Z5QBIxZ2QFtp611rfxnPl5BBPVejcQUad3FdWN+po03BbZfwRlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 01:02:52 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ,
> 
> 
> On Tue, 11 Aug 2026 06:56:53 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Hi Liew,
> > 
> > 
> > 'hkml patch check' [1] says you forgot Cc-ing below people who are recommended
> > by get_maintainer.pl.  Please Cc all recipients who
> > get_maitnainer.pl is recommending, from the next time.  'hkml patch format' [2]
> > could also help you doing so.
> > 
> 
> Thank you for reminding me! I will CC all email addresses output by
> get_maitnainer.pl from the next time.
> 
> > [...]
> >
> > On Tue, 11 Aug 2026 18:18:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > Add an explanation of nr_snapshots to avoid misunderstandings.
> > 
> > Thank you for this patch series, Liew.
> > 
> > > 
> > > Liew Rui Yan (3):
> > >   docs/mm/damon/design: accurate semantics of nr_snapshots
> > >   docs/mm/damon/design: difference between watermarks and nr_snapshots
> > >   docs/mm/damon/design: fix typo of max_nr_snapshots
> > 
> > I requested changes to patches 1 and 2 via replies.
> 
> I will make changes in the next revision:
> 
> patch-1: "tried to be __completely applied__" -> "__completely tried__
> to be applied".
> 
> patch-2: use two spaces between sentences.

Sounds good!

> 
> > 
> > [1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#checking-patches
> > [2] https://github.com/sjp38/hackermail/blob/master/USAGE.md#formatting-patches
> 
> 
> Best regards,
> Rui Yan


Thanks,
SJ

