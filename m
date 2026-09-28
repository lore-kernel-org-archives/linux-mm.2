Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4EA6C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 06:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69F76B0088; Mon, 28 Sep 2026 02:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A816B008C; Mon, 28 Sep 2026 02:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DFF6B0093; Mon, 28 Sep 2026 02:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9802A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:18:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10AFAC0B46
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:18:41 +0000 (UTC)
X-FDA: 85262167242.03.4931E20
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id A9B99100003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:18:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dXVNrCtP;
	spf=none (imf05.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790576319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6JBH5OzCgBGbSotaYYctgten26WJi6XRQg5zFg6ET0=;
	b=l5uuWyVwSuOMeea4QprwR5uOOHR2KUS3v/4rrT4PQQUjo+TEJxqlQae+Wt1mlEapMbZIg0
	c1uFMiO2QvyJtXI46jeCW40pcrSFoq/HXmC4nsQzrYAqAWa2RwzTRW5/wBtRvF07WQeGmT
	tAfsCYOJbm+ffeZ3s4F55QcoSzqxjzY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dXVNrCtP;
	spf=none (imf05.hostedemail.com: domain of BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d672529c310eaa635cdb+8436+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790576319;
	b=7yAAZlzJkfT6G5cKSVHKc8YnacxktQY0BjlX4EOEZOPFW80LF7KEpXtirf1VLcB9Io383K
	i9sbrqec4WOPbdi1D8EcEtIWO+grAd3nl58NUeizc5TS3Klsr1czcw8pGNalq8qcjbsJ4z
	N+c/Iu+QHEOZY34ZMKGctfLSIITvO1M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m6JBH5OzCgBGbSotaYYctgten26WJi6XRQg5zFg6ET0=; b=dXVNrCtPGbkF9j3ctYx+03RvEY
	EwulYd4k5qcGz9GapQu8q18TbyaDo0GB/48MdJMmKRNeJhuKfmdsIxnuVtakJYak1cXrkE7Rf5wQY
	CWRQ+sblT/4HTAM5d5I2VZvl0fQ9xt/XCOVCMld3ttwaaN5QcL5/KM48w6J1I3Exygz6bvBg2tdqT
	GEqIlA5AvkQRr2rg9ENTdjlOexNOzMThHpjeFsHWMolXTOahdH+kPQ0fWWZ4MiESYtAjfpm93zQdc
	Gx8zVu9NfUFq0ptaVi/niMV7BCc2W7lMXp1QJVoEkOvTPz49SG4rGNo7ld/zPUyFViWeDQ0Ty4O2M
	oD76BipA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB4hB-0000000HRZD-1bQF;
	Mon, 28 Sep 2026 06:18:37 +0000
Date: Sun, 27 Sep 2026 23:18:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, willy@infradead.org, jack@suse.cz,
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v9 2/3] memcg,writeback: flush foreign bdev mappings
 separately from owner wbs
Message-ID: <aroGvQSFpj06a_to@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-3-sunjunchao@bytedance.com>
 <arYa1DbKNeAN-PLl@infradead.org>
 <87e10baa-13a8-4766-8d6d-9173a4b0c5c5@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87e10baa-13a8-4766-8d6d-9173a4b0c5c5@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9B99100003
X-Stat-Signature: x6fkd3nz4gdxiepowi7xq8p4izg7g6pf
X-HE-Tag: 1790576318-434948
X-HE-Meta: U2FsdGVkX1+sh5aq7DJjFeSnCatDI0hOGtW/3bseWTiSy7QYZ6TvFezwNQGpYzU4UD8rPeC5oeye0YtURUYYWhAJNWQk/593+wI4ZAZxTrbyZePTBNQNs4gBSkirrogGpo34XIdOx+BojYJn/IExxpYiLEloS/oTj2+UzMY5E2PV4uPu6QNsidWJOD70i4Eyz5Dj2qQb88n9tMMLVeSWenywZoRAL2QMmcX2hLRdJ487KncKSZ6EeHrx265ZFM2AQeYwLD9gryScgykIBUzL13/YQ/y2JqxA0EQ/DyO9lJJWputckEddZ5v1WgmxzDP2XZgqSH6wTUry950E2q8J3vRXGsbZCsouylVPCRPk4IGD8FSv3KVXtdBhxs/62j73DzApOuhZaoNOjxIO3ykT3Nlbi6DkWmXQKXX2jDDGnGExV/FdzpMORIQeqz4nhshHkJXkJYGT0CrxeluPF7NImW2On4L6d041VCdcp9d0sGZKLS75STar9aA2eFOZgOU3E8y8vI2z4PkLKSya+K06KNneGW5ATrMt3Vwpq55PVcDMOygi8sqAvcEHUVQ3N2gSAxT9VoJn0EnCtleRiDQMc+20MzheEIfw/G1b7pyJXa4cBYnMLgY3y+jm0s9QbDcJPQ6I0myfFDt3ysfncNojlkEQHLvQ3xpGzvubS3x/vyEjrBCnZ2FVTgMIIioNunkcdQiI+fYlxqyOeR/d9cm8cltAqjYeMt03a1My5nMJxXkoCDGkjbHf6rreFTlXELi//+j4TNouUKBxZpoHExa6NFNarbh56akJ4AMW/coLMTbl6Ye4Ufjqq7oO3WBNNJGbmO6ggu8+NcJ2A3bxd2Vw5+H+6ApM5i86K9FGsrPtoXw6HXmwUhGBca/lAyKWILaUkzkgWlYfMNI0E6hXAyxWqV24DqHQ6iSa9Y2oScX2W2W4I4fz+4R52BOj2EXrknH9bE3U1NmuwZS8enMx1Mw
 mjnQWEi1
 Z1YBpHay3HGeohSZ4HHdwD4L2uPksofwwgwOleoG2L0BBtEZLJhHg5QiRQdOiGU5Vt9Knt8qDptWAV8HU0X+5ulJwRf5txykcxnBfvU4Kxjc9GzYR829s/vifCKVEp/HtkqU50assX0NliTwH1v/KeEXfGkFXWy0PKYYLGLdsxGxOgeM8sVJLxMY7lAuP6JtxAPVbeDP7opnQuD5ouVPet4R1cwfw4td/AkFoHy//wE/jCnAbny6emEXHe+xwcVkYKSYuRuFOkfoL+gKaXqjElFh2UK7SbsHbtZ6aFaSDHc0U7/yFRmHJRCRiQWI3YsySBni9nmljSMXZMs0DF/bGMBPp4wXgxb4dQ1PD2P053ZEIROhkjHkCLH2J0M4wkGrgqhcZnpDKkE960bUUvCdis09zeVi3DIRpex6ldH/FqzT+ezZvaLrYPA5+k3zbHC3FEttpnI/z8IAv7Qpof9Dfd7IsWYaHDN0vAitfcc2aEWg47mUk9JG/x/dZV1Z/tfCjVn9+dQp0WFiH5YakVa2p2RiwAqak9N8SNxYHO/N4JYcTFT1KSUD9/PODbqtwsI01o5m19xZZuhq4H9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 09:00:28PM +0800, Julian Sun wrote:
> Yeah..Andrew and I discussed the naming in another thread. The idea was to stay 
> consistent with the existing naming and keep this patchset focused on the functional
> changes, leaving a broader naming cleanup to a separate patch.
> 
> https://lore.kernel.org/linux-fsdevel/20260917065759.2643940-1-sunjunchao@bytedance.com/T/#m0d196c3b8376c9b51276f6c5d26ab9f29e170169

Let's not add more of this, even if fixing up the previous ones belongs
into a separate thread.

> > 
> > Instead please fail the boot.  If we can't alloc a workqueue at
> > boot time, we're toast anyway.
> I followed the existing memcg_wq allocation handling here, which also 
> warns and continues. Would it make sense to change both allocations to
> fail the boot in a separate patch, so the policy is consistent? 
> If you prefer to address both in this series, I'll make that change
> in the next revision.

Leaving dangling pointers during catastropic boot failures and then
dealing with them at runtime isn't a good idea.  And yes, the code
above should eventually be fixed up as well.


