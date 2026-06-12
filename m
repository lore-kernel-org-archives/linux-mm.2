Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9947FCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DBED6B0005; Fri, 12 Jun 2026 04:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98D3B6B0088; Fri, 12 Jun 2026 04:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2E06B008C; Fri, 12 Jun 2026 04:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 751CD6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:15:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15E88140466
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:15:05 +0000 (UTC)
X-FDA: 84870550170.25.2E72202
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 031B88000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:15:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nMrOIgHb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of BATV+b893ed6302a0b05caa02+8328+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b893ed6302a0b05caa02+8328+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781252103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bC82jPab6S3wVzMMxpsWQLnEuTGROvnPgIfnuq5vlbs=;
	b=8c/vO2yDxMqzYGORovJJ+/s1UGMDH9kJAXGUx5JeosDQJZQcSp2fNAMTljhmMo3pg4Q5Kd
	1z/tHwbP8cYSbsBdMzEwLJ3B5Ppot2OnpcALU0ty5oX7cLZZd2ArbUbpZqRzp8IGeZozi5
	zq1hPHxwgmpOtee9de0G/vG4qrw1ksE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nMrOIgHb;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf02.hostedemail.com: domain of BATV+b893ed6302a0b05caa02+8328+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b893ed6302a0b05caa02+8328+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781252103;
	b=up/23EkCIevy0rq5+QFHpXAyl2LK/+BFJGKeMe3HGOeaHxRj0JxYJ+id2J041R7Y1XB/DY
	uF/BQY2bJNrb//iBwvHXPjZ1wb2OP/Pd7X956PLUigL4WHZa7CnbKxrzjJCqYcyrvRhDNA
	2M4AGOFl/6+CpVM3x/py6XFOxujHuzM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=bC82jPab6S3wVzMMxpsWQLnEuTGROvnPgIfnuq5vlbs=; b=nMrOIgHbeqs2wVJIEqvTcSh2u4
	+S719oQ0n5euK/SYW9MA8GnP+JgqOc1RZpFVdL7AyUKODwIb9wlLfowNhbx6rscZMUzIqO4ysOm3C
	0vX0Tj1g71AgfZtyiSNg/ORNHUQkZ1MdzMuZb1BtrCg3Z7VRqH5syq9aYU7QdE6HaM7CZPI5gYfDf
	gGBEx32/bimUkTTGXMqqr0CcqdFPJAZALpB95pAEUACO5cv6X+zOUkD/baBc/+XvIT2RsTpULnK0t
	wXX7n/1N2v/UMGtxYkTCByzpbsaJBSFA9rsTYHVtZZ0RyJ/XWVCCOzIDz/fFcBcShAc5rVUewb+dp
	xCW+HRqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXx2a-0000000AZA8-0hLA;
	Fri, 12 Jun 2026 08:15:00 +0000
Date: Fri, 12 Jun 2026 01:15:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: Direct IO page bouncing got some garbage?
Message-ID: <aivABK8nwNR6Z__A@infradead.org>
References: <b866b2e6-292f-4c5e-ae5a-d77e983cfefd@suse.com>
 <f1dbdcd6-4e6e-4304-8fa5-59c2c60252ad@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1dbdcd6-4e6e-4304-8fa5-59c2c60252ad@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 031B88000B
X-Stat-Signature: 7wcg5bjghdb61hwi3kodmb3xuuujq9hk
X-HE-Tag: 1781252101-888201
X-HE-Meta: U2FsdGVkX1+cAWETwsUQUU/bqTKGDwnK/ZLrm6HiVM4uBQDYd4hLd2a0upkmWYpAj9S5pRior4MauX4vGNdBeYeYkkSUp5J9v0gRPIS6XFoUmNOsVRszUm4wamPzz1GtXeTxpPxlXx5APcZYAHAkI2t5N9MCBDdR7DsnFQsy53D/cmUZV1B4q93CNqUhmWDdFCs25C5rxJRCuDvFTDjlseUA7NU8ffTR3f2FX3QFpdb+CYm6dCMBOifC9gXgKNGPCoPV9RVDFC09zgFImt8CnFA+0V18U2sqpKye6wOpKfzF6PiaoFBR07CDaxJsbi2i5JKqJQFgJ3xFRqVxcgZ8n/ibdSzHKoPWxEjxp8St0Rkc/H362l4/JeCqS0eoTdjT0ihqcLgY2Y638Fhk3ftzUBkQ6YW2XRnzRpWmSr6IWY8jaGe8q20X4LFwqrlKvjUOjA0sz1IyAqTm3o5kR9AxX1HWO6PRP/guX/mlToCOVLQVFBkM50/fVdKbbGziI8dc7cYj3xD0m9ujNixKmSESM7655yMS1KMLyrZxsgCSUnNP6fIpfSmNjCoFL/kzZ9HLCb2tCBvnBhTCrs7z2cefSVe1Pw6N9jQTjKqrl7l2FIcZqbPgj6VNlTrKGYPZJf1Arqga5anRaV/Sfc8ayboAIsJBSXciziS6M//nDNs+dFrIAts1qEwJR2GDgR1qXqN6C6IjOygXfuN1MU+Ppxbja2lJIZMYPxagwiZiELrpMjvmmBQTgkWSoNQUcsN2d1+I5lEqhJ8VG5n+sTyIzAgXfhwxOAjcEwyIFv97BNfJmSW1uVjiy0O1HThuSeQjFub1Krr3i+YUiApRYbA/FEQJZlZJF3SziRjvvxEufbO6j6tUlQGif/VOO0xwFAD6jOkYyVmnYQGlQqukJ97UVObSWrPGKsGrhrv9fBzFvDcZNAl4z0EOMe6ZZzfi1XUlWbQkVs1u+1MlrzAARnMuYj/
 QY8K+i21
 0yok9xfzBA0K6uCfad51HEtCgYMsh9okn92tMejUrxzpYIBr2yqmEz6iIdnzbCMHPbbQ7jXhbBZJj2uU4Bi7k18QG4OzlQJG21Odm5dWSYWgrxQs/lHtl3kt5MTDXtj/s1l8LnNJVkJkWAXm71+gvse5Ufd2jxu5PYtHLm4MR/v6q+7/BBMe0kuG5lYwp54GqkFOrOaV5w0JUPdCOHZos/YRCzX2CtruI+q+squuxGV+Mj8rKPFvdSgLhM29t+0nF33LLwGar0E9oYTLMYydi6eJDL+Pp1acfHSTWNsVwKroxVMe7eXXtIVT28zsqLrw9RaM83dBx0SsHHV2gMAwm9xCdODpj+5jmwnN5OU4BLtk0kkdN7bGrCSEhxadrUpXMSWflIF8wsXKP3X5Z2Wman4dGCiC6QxfnTFMjEj2XTSzsD4uXycnSbbrcJcxKJyatzZxL8AY9ZxYLKCUhSz8T9a/FpypPS6lHxlgTZn+OMfPI55gI2pioEg0NTnJwyeygC1/gMKLr7Qh9Y/8hZA0XVi1dTsFKMFT0aPiLo1leow2/7Sw1QLDnzFm9JP3PSbchc1g6JcE7oh1/0ze27ldXiFK+LF28mU8lvqYrewDzAygLakAt5FesVVhQAL7l/eEfM1DthFVgFX8kpOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 02:54:22PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/6/12 11:11, Qu Wenruo 写道:
> > Hi,
> > 
> > Recently I'm trying to make btrfs utilize IOMAP_DIO_BOUNCE, however I'm
> > experiencing weird data corruption.
> > 
> > During test case generic/708, I'm reliably hitting garbage pages at the
> > last 64KiB, the garbage even contains an ELF header.
> 
> Added ftrace shows that, since btrfs has to disable page fault to avoid
> certain deadlock, bio_iov_iter_bounced() failed with a short copy.
> 
> Initially bio_iov_iter_bounced() got a 1MiB page, but copy_iter_from() only
> copied 64K then failed due to the disabled page fault.
> 
> I don't think it's a coincident that the short 64K exactly matches where the
> garbage is (the last 64K).
> 
> I guess it's in the error path we didn't properly revert the iov iter?

Looks like it.  The better option would probably be not to give up on
a short copy, and just reduce the bio size to fit the short copy
even if that wastes a little memory.


