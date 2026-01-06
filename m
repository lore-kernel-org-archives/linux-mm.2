Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9853BCD042D
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 01:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D512D6B0088; Mon,  5 Jan 2026 20:48:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE9B6B008A; Mon,  5 Jan 2026 20:48:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F996B0093; Mon,  5 Jan 2026 20:48:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B3CBE6B0088
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:48:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37085B69E9
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:48:28 +0000 (UTC)
X-FDA: 84299854296.23.B8261A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 81F2C120006
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:48:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q9Foh+b6;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767664106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dstzw5N23oPyuOr7X1D8tVBJPxVnregBxvPuuSbYH4=;
	b=g0YaNLJOEFCTwcLu6DC8bACYv4Hakxi6coijkIIcWJtjcTmhOkyfMNEkJN3dKfifMYEh7w
	mlHIuSAfjvV8qtrRK4zwJ8VUa2PI7iDo55bsOzpVHSB+3gvVYoU+r9FLg9MnpHjEDCY7pf
	TiiE36amWizJP5XtXQ1buQnQgxEYMzk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767664106; a=rsa-sha256;
	cv=none;
	b=6WQrgPA9TjPkQDX6YJOoloQLXGV91tRw/GY+Df9VcvAYGeYhWnvaMylxI+9HrSKi8Cwwlf
	RgSSSxdcuhzV0wTiA/gKjgzE31N5IWXpHC8AQxN4PKVbs7Bi7KyvXDipa6b0MzElcbD6BE
	PGxw3/QpV+nnO4QdZP3XG0ENuvvuCC4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q9Foh+b6;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 317A042BA1;
	Tue,  6 Jan 2026 01:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB75AC116D0;
	Tue,  6 Jan 2026 01:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767664105;
	bh=1/kzawURfiBIGn4XEZ9FPaoyI0WW3RZ6ou8fvJ0ipT8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Q9Foh+b6h09pHMzu+j9QQgqKvZpYFqmKPByoqpG7MmWQ3FYkyfaGsubCnK7WEI2UI
	 /0ZFeeyAVDHXbug9r2Yk+Zt2QAKUtqdi52HgkRt46P+aoQ6VhSyjC5s7ss2gPN/Lou
	 NF1jZF9kF6Q2/s1x/v3lV3/dEWG0yhc5a9WT5AGg=
Date: Mon, 5 Jan 2026 17:48:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: david@redhat.com, miklos@szeredi.hu, linux-mm@kvack.org,
 athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, Bernd Schubert
 <bschubert@ddn.com>
Subject: Re: [PATCH v3 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
Message-Id: <20260105174824.5ea19dc45b79e29e0219e6a3@linux-foundation.org>
In-Reply-To: <20260105211737.4105620-2-joannelkoong@gmail.com>
References: <20260105211737.4105620-1-joannelkoong@gmail.com>
	<20260105211737.4105620-2-joannelkoong@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wx3mdugjy7nc6xbnkk7od3ecsqfrgsuj
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 81F2C120006
X-Rspam-User: 
X-HE-Tag: 1767664106-164598
X-HE-Meta: U2FsdGVkX1+FN988ZYNzHGGSKmO2V2m9OlDdNEl2XR0MRcFu0hXs3lzwr+FQ6IPPAazsLkGWdFHc8CAeRCZLinNphl1qUoAAWGH+YLaY/J2zgTjGEQbJ6Dfg8FK/6VF14Mbn1LdOBJgT/fqvU+QA58acJuP9c1bOtpMHMKkqoAyPAaUwkFiDqj+miq4b+fylN3zYIC63PZgbZSRO6KfDssu5m31jCtYoSOme+6LliUifTc6BYwHMtgtCxsywKes4j1YAsiUpY4XbojWzazTYXGZ6nYNkeAqsKRJsNZ8Z0bdw/bFv1xxr8CNMU1ml9jHT+QfxW9ow4bDq+DIKlNX+c7MBcFCNGKEX4+qu+eiUCGmNxZEVSyEOKG9dKVSOVYP7OP/lP7CnUgAvM7i7s64Rzs8V787Jr/TPQ4K+umLblzO6s7c3xcGPWQk9fSifbaksdJdJOPK2demYMVDIqTh2kz/KVu7SEr5V3v0nU8LNRaAM1U9dJGf1VGzAou387dfB001oOJCe7QYJSFtd0XaAgdo8zilgEWEr+cLOZgmKaIhJa2cC1J61jtwi+l7V1EHIbqfZ8GIox7QZ0e4PuqjPu6jKVp44sIvY1PunUFqes07s8jXaMGZ9K4FakrYWBt0OKfssUl/3ZcTccY6mSGNUe+A8foEKdGfV1rZ2x7+HuZWaNDn5Tuis6WUSGHNKTBQs5CTGlP7cqx0C4hLug+z+RBuZogtMQnBhQ1Sx56vJnIkh9aNL+LBB1JU1AlYpZDfm7iTgnY87JvlvpXiTJM8RBQ5o4O07lomnl74QqXwDSh1RTLQmrquIAadMcBmxx12ovyenRLa9slyQtshCm5DGGau/Kzga8yamiqaC6CLXpHaAXG+rJdrCmEzvkXq3aA4dY/VCHWEfHQLPtqZ385Lm2wdfyX+DPkRqVaOH/PrDRZMmpAirHqcHS6VC50tz9q+r9unHnMKE8hKBUaZsUzq
 lh2BTF8e
 syGPWVSVxVQLON6yBMlontqZXWAvyL7F3wH6bu4atPXnAlQfRjVpxrSGmNKA6wp/ftfXvw7QALT6o3ufjhzcKtojH5y0GYGJj/FZEhynYiu4WMu8odcqgJZtl3jhS3W9nwUlnguqNS+AR30tXRW1iTcIvEPQWKcxY3Edzu6FHooWjiepYO7xCVspzZep6t0eZ3dsxuVf2O82IhdM26/CL4UiTspiGadDNCBUpzCWnknqLw6pCS33liD5rfPTyKQQES9WNYzhkbDbW1UdTO9DI1h+swR9BhbHJR6OhFOupkk6/zXBJyeXg3dmTjLmXk9EHMD8zsNebNk5JEH2nUf9P8A+B036q7yvifq4oQnFqP2Tx1qaj8vYVOBakLUu/dJcVxO34YgkZxbSn02QpSYvk5qFbCsyZ9vdHVGB7/DU5shVvDkaQc61WoyNll3M62bVnK/1gycvsOMashatCGb/AGhByF3MPsEBKvh2ZkrJlAgOORoM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  5 Jan 2026 13:17:27 -0800 Joanne Koong <joannelkoong@gmail.com> wr=
ote:

> Above the while() loop in wait_sb_inodes(), we document that we must
> wait for all pages under writeback for data integrity. Consequently, if
> a mapping, like fuse, traditionally does not have data integrity
> semantics, there is no need to wait at all; we can simply skip these
> inodes.
>=20
> This restores fuse back to prior behavior where syncs are no-ops. This
> fixes a user regression where if a system is running a faulty fuse
> server that does not reply to issued write requests, this causes
> wait_sb_inodes() to wait forever.
>=20
> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal =
rb tree")
> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> Reported-by: J. Neusch=E4fer <j.neuschaefer@gmx.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Reviewed-by: Bernd Schubert <bschubert@ddn.com>
> Tested-by: J. Neusch=E4fer <j.neuschaefer@gmx.net>

Thanks.

>  fs/fs-writeback.c       |  7 ++++++-
>  fs/fuse/file.c          |  4 +++-
>  include/linux/pagemap.h | 11 +++++++++++
>  3 files changed, 20 insertions(+), 2 deletions(-)

I'll queue this in mm.git's mm-hotfixes branches for a 6.19-rcX merge.


