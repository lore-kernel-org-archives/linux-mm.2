Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07069105A583
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DF106B0088; Thu, 12 Mar 2026 07:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D1D6B0089; Thu, 12 Mar 2026 07:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1990E6B008A; Thu, 12 Mar 2026 07:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4EF6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:12:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A85F14013E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:12:21 +0000 (UTC)
X-FDA: 84537147282.08.FD7E23E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id A4023C0007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:12:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PjN9deAv
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773313939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6AcXBztT5Sj+QpF3YNwZU4UQU3fnhpf/t4o8/38YWo=;
	b=tLGMhNNdboWMp8J9eNQYRjm+NjikLwuMFqKQDGz70/OL1KFksNdaxZVzxjcXcYOED0wAQU
	Qh1A7edZJrdYcjM5B4MQqV9A19NMnecR9IhGeTX+eK5Ws9rSaj+g0tY4yHxrYDM9BFjuCs
	w2OgkaVMH9YxiVONL6zxtfGAPcshSSs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773313939; a=rsa-sha256;
	cv=none;
	b=xDKcjThGcWUGOYRS9OnaTNBQF/YR1k2cTKNr1Rkm6VNv8pUrKmHdWeYFJ42dThsQR40s+h
	9GDagiX+kiXf703t9GeTn2PtLFpxCRjZzDx+cNyIrbH4VCmkaUJZI6IOeEotJO79YMSCwJ
	PfImHC5q9lQu/VI7JJegKmytK/eSLuY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PjN9deAv;
	spf=none (imf22.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f6AcXBztT5Sj+QpF3YNwZU4UQU3fnhpf/t4o8/38YWo=; b=PjN9deAvJ2jmYwchkDw9K/1IDW
	RDvBjTzu2dy1mbJuwxKv0HZQrtfZqSFEAu7HYwU1mPcbgs1Wy7Sz7jhOgXg/EldB7YZywQi9qnXBc
	gI9pj6E37zd5K2g9bkLCwgqwgL2IJQun2hk81vcF3+5Q6BY9r3yF4wjhMUbg93ciB906m6k2FYfqX
	ilqbWKGK0kkd8/YZlNworwuz+HryM6l5ooq5hK9DH4Niqo5d+5WOP7RxHnrhbUlca8vVw6fPFcHCO
	B+Tk1y5dMsoGlCWft/JjWbKDsv0I3LJcESQXWtslE5bwDRZ3Zmo5IuBSNKcFQx3qk4dxtx52mZf2p
	LRQeitOw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0dxO-004VL3-S2; Thu, 12 Mar 2026 11:11:59 +0000
Date: Thu, 12 Mar 2026 04:11:54 -0700
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, SeongJae Park <sj@kernel.org>, kernel-team@meta.com
Subject: Re: [PATCH v8 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
Message-ID: <abKfG0w7frLldlfd@gmail.com>
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
 <20260309-kho-v8-4-c3abcf4ac750@debian.org>
 <aa_0OESNkyp8V2eF@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa_0OESNkyp8V2eF@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4023C0007
X-Stat-Signature: a9ekj1rid85ebf3ztfoj5sirs1sj46mr
X-HE-Tag: 1773313939-659687
X-HE-Meta: U2FsdGVkX19ql1Pt7uUtl9s2Od6ySF4BlNLvGwjSdZcUD1DwzqtwFkmdtMXN1Ef2RE/eJF0iFUwcbSwTlqmGcBfKD+ui3j0J3DdCpUKTP6wLfA2Hq3q2Q+0jB3Docvkps1Jsz+jZsQrLwbD2yAI3fvBBRj+cSaVFgOpGZnTmn4L71eZ10+2XEqikdf4SWJHVH3Q5aIHZDun1dXzNjQ/W8208Z9wfBOkE9V1CdAetIMds7JFsbTuZzwi8cKXH3ZTGeIzvxZFIzx4NPnU2iiJrQLMq5K56OhzLkQPfi7xk8KnhHZr9K4/ui8iLFXsm9H5USt75zCCti4XuvdX1HUT+PakZVRTzXe1MAAl8cbsH6gm5WGw0t7RuCYfnvxh7bQGJAanaHcG8PYduv8bJpZLYLfgJ5XqsjRCXA0I0AhBQGM0smZUwMLC1krAPp0Qqs5WzhAXDdYD/O4poRkvlkvj2TilOButU91MpU541z9JNnNhC7GFUvz802M8ZpMGJlnkCqQxx4Gl29mGRFV8hcZQS0yQow6oHhS4gYSgR+Du162gIdrb4kRTprpkdw37WprbWCLO8JYLgWKhlMz/TiVS6kWWXoHK/I5Tfe8TPHGZOl+zknWl316Rd/9FE0SvBj9CoseiYQdl+G4ickA9MEG5w6MjFUKTUVGI/0+SaIYXPKdySB0d9U4Qx8Ld4PA5HuRUjPmcmzc5AhczCkIdxq9hirWM6LDCAIpTriQOEHCKyurzudB6A88bOnU3AYbwe3icfLXfKkkFHqO1g6fcHQP0IKlXD58/DUf7+9hIUXiTO0HNkWQsvue2rcBEIyeMxcZ7BkrVRDEW1hRUDhBvqDrQKBnY6nycS32l3J+PhA+uhQ2jfvZfI3lfVBQroEmGYduBMIEonb2UHKEh7BbsnWcGL4vjDhJbadgU4VxaRDyJtFc7Xiv42cN4bOTuwMx1yh3PlRmLP+YQkldarTCuBP8o
 UT83Wmoy
 E5fuZ9aKsKuHqI1oWQw8PxQ/y4DO1GC24xdZ76J0EimaUIV3U+VsAlCgfZi5xYnrwadUcGuvEif50JuKlpn43XtYzduF8NYJoOrsdv59vEkPx82kkpx6tY4QDW4+kQiGLWKZIHixyQhFRIIsWPeESlGTs7nVY6eHR/h/+M94ZxKDA6EHfnAC4hC0ydSIiPbOHyQNyBI1QacS+b8dvi8wU4fErHCWAlN+Q6FJ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Mike,

On Tue, Mar 10, 2026 at 12:36:40PM +0200, Mike Rapoport wrote:
> On Mon, Mar 09, 2026 at 06:41:47AM -0700, Breno Leitao wrote:
> > kho_in_debugfs_init() has two problems when displaying incoming
> > sub-blobs in debugfs:
> >
> > 1. It uses the hardcoded property name "fdt" instead of
> >    KHO_SUB_TREE_PROP_NAME ("preserved-data"), so it never finds
> >    subtrees stored by the current kho_add_subtree().
> >
> > 2. It calls fdt_totalsize() to determine blob sizes, which assumes
> >    all blobs are FDTs. This breaks for non-FDT blobs like struct
> >    kho_kexec_metadata.
> >
> > Fix both issues by using KHO_SUB_TREE_PROP_NAME to find subtrees
> > and reading the "blob-size" property from the FDT (persisted by
> > kho_add_subtree()) instead of calling fdt_totalsize().
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thank you for the review.

As this is my first contribution to KHO, could you please let me know
which tree these patches typically go through?

Thanks,
--breno

