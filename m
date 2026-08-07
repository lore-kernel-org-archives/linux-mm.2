Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87170C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5482E6B007B; Thu,  6 Aug 2026 20:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8E66B0092; Thu,  6 Aug 2026 20:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8566B0093; Thu,  6 Aug 2026 20:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1397F6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:09:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12A7C1A0201
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:09:44 +0000 (UTC)
X-FDA: 85072539888.18.DE0756A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A7501C000E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:09:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtbvyL6Z;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786061382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZ5Mw0Ih/bGAuN0BQFkuLqJf8PbwxdcGV24qNLgz+NA=;
	b=J3H9u9I9oMlD9vhnejgMqZiYgASrjdcm5qgIfejB9/H2acttJe9NlPAe9yT5vlgHdOs0kR
	v+FZ/XNrLcFfwpVXypzMNAZXTcFhagmRqbOoAkTRdeQbE4G0/G24Ugw7XcfEQpJGtN3mAf
	YFv1gHVckl7iWPpHz3S4u1UaxuFDr5U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786061382;
	b=pW5CQjMDrA4P+F8RHY7rhacXjveIsM23xwLg6hYxXuCaZ86LjUfHzNbYymec/jXaZ8asmt
	pcTgRyDlj3/TD4HjVvN4dZpZArGVChbYuCgD70V9LnwibS3j4gyEGqsZY1TJfNnB9OwRhb
	at2qsUofD/Wk6Z3H2YYAT7EscpDKCRk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtbvyL6Z;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06E53600B0;
	Fri,  7 Aug 2026 00:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CA41F000E9;
	Fri,  7 Aug 2026 00:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786061381;
	bh=dZ5Mw0Ih/bGAuN0BQFkuLqJf8PbwxdcGV24qNLgz+NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtbvyL6ZMna8HAKgywO+rmaE4EQ85ji20cRsyI/3rtd1ai4+PCGAzcDE93xIF5Q01
	 B5BPh1oT4iTNs4IeHq+V7rWpXGIUqY9UjANEHMscGd2ARRJs1f4bClCc2IVrjqyexY
	 XUXyEamjhpdN2aKu6SGIKd3aPS6x7dmhedDRHgcR6tOCY0ra90pVNPjCvTQqxHeMir
	 gEt5KBBtiAUiewgz9RD3+3mEMLIayqTrYkKPPkkL1BF38WsWPh6O16xDd7F4uYAqJN
	 AYVP6E380raZ6o6msbOO9O48SiLrGXWXY+fzM+hCHndtqKax52BIy8rtMAca2XtbwA
	 MfiLBnnWXt7UA==
From: SJ Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SJ Park <sj@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: Re: [PATCH 1/4] mm/damon: defensively skip zone device folios in damon_get_folio()
Date: Thu,  6 Aug 2026 17:09:37 -0700
Message-ID: <20260807000938.79851-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <anS-vK1MaC8sWoMK@fedora>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A7501C000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: a4qfpasufzytus996dncuq3tho83qxs6
X-HE-Tag: 1786061382-284452
X-HE-Meta: U2FsdGVkX1+2z1trx+Zc0eaPyM9VyloInM9Z4Nx2wT1pzENB/ydgHiumEiRTXNhv6mZQcjY89RRg/Q0Ez8/g5kEXCWVgEUK/6tDpvAnNPPWvI/Ddn8HMkqMcGv15s4Df90QeStMFxjQGMgxbsh3y1sfVbJ0x5uOKEazGFj00CYpN/6I13BcNEabbyTPVg/y7RAlK/mF9A2NP03+bNuKYnUZG2sQ3jDL7WCwZUBdCB9prw4EzZZrtPl7/+hC4ZfAD2vpio0IL5oWdnZmH97AuXQ2dv4wh9AGLWoqwNb/2KPlqGPrB/XDQtRNbIVWTl2RndTSpBtubnGrvlywl6s34kDGQsFfsJBIDMO27loW82NK9atqjS5HwkXIDYVJD1SsNt4UrMGGDZUVdV+9q0dLGdVWNG5LI3Eq51CxTUmGQTi6jD/Y9cUO6tgtvbsGHxkBX7rrX+Bzjj3UZi/mpS66DjRW3HcVFfp7L95vQunq8tjoW0jB1WX0KbutJ9PIpj+gM8pZr1kKRYrgao9vJmJotzetfvVlegMcdqXvy718IqMUxIKaDCemc1QqnLeaZIEMoWCt3WyuXdtzRzTATGLN7b7IiWVUYkkFNLTZRndDYSfEz+ZGGHuYaYLuMVigszuxXzz+fIgDnajZcirNeWL6SPeb8fTiJA8gm9SUxQ7BqBSYJgh9FYdYHINdQ0XfdKky0VWqS9dWLtW2PteKyGcQUie/rMn01luo63PyZ2zkxHhF6Ll6VorC+bxjpu9sLu+gSFRxkO/TVebMuFoHmCdGpLUXYRv2Ugtyi4ExeJ+PsByce1IB8A0Xqxn+2UAJjDn6ZihTvpcfsY9ysR64ZqfZPUtGfDndkllEW6loMdR8NdDCbsqEoVr7DFdxZdyXlP8LTqOz0jI7l97ZlvbsNB6t6ELzT4kIRjpKw37ORXcOQjLd4AsEq4ZZqG8cv1ndCaKtNN/k4s1koaniYbQvWMMA
 2LPufhvO
 it4/KrWHVhSd6prmzFyUhXjXxkpLtn3Iyd6Kwoh73mHfany7qX6o1CC/xN/F+yVLZxaxVSBi0Hxx2VvqVyMHqjttsmAlwtbe6MWAv355PEBn9XHfebYqNS9PkV9xNKarKo+3714oPqnKtNF1r+G7toE03LSyAgLTedUgnnBLakjrCQ8OiGzkKhX0mJv1Imb42voRoxpaLnffizj4Z87o8/YIks/4Mq71SMvS7e1u364JzOhEJHQw0PMW2Arzd4+2BVKEvfof4nx3PICc5KxNPOlSDNq2YUn7CwiWE7zQFcKHi71mu5I9VTpcrvJZcr+YCEmd7thRyGrxIDkTvwCaa0ojgOftfdg9Lvqw3VcrSMtMZLTcP8CvWT+64DcYD7aJ3ex9uSxrXuF2rWDCxDLXhbujeM+oTIJGnNpeO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Aug 2026 12:05:00 -0500 Gregory Price <gourry@gourry.net> wrote:

> On Thu, Aug 06, 2026 at 02:37:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Jul 28, 2026 at 03:47:11PM -0400, Gregory Price wrote:
> > > All DAMON physical- and virtual-address operations obtain their folios
> > > through damon_get_folio(). That helper already excludes ZONE_DEVICE
> > > memory implicitly via pfn_to_online_page() and folio_test_lru(), but
> > > this is inconsistent with other callers in mm/ which test explicitly.
> > >
> > > Add an explicit folio_is_zone_device() rejection in damon_get_folio()
> > > so the guarantee lives in one place and covers every caller uniformly,
> > > consistent with other mm walkers that reject zone device folios.
> > >
> > > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > 
> > Thanks, nice to make it explicit!
> > 
> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> 
> SJ Asked me to drop it,

I didn't asked you to drop this.  I asked your thought about revisioning this
for my concern.  And you replied [1] you can drop this.

I interprete it as a withdrawal, rather than being asked to be dropped.  My
dictionary is definitely not a good one, though.

Anyway, if your intention was not withdrawing, please feel free to push back
with the original change (explain me why my concern is wrong) or restart a
discussion for making DAMON code better in a way that can resolve both of our
concerns.

[1] https://lore.kernel.org/amoXZr2vB_q5q5Wu@gourry-fedora-PF4VCD3F


Thanks,
SJ

[...]

