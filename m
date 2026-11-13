Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C82606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=Q0owM0de
Received: by kanga.kvack.org (Postfix)
	id 6AF456B05B4; Fri, 13 Nov 2026 09:21:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6881D6B05B8; Fri, 13 Nov 2026 09:21:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E9B6B05BD; Fri, 13 Nov 2026 09:21:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA9D6B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:21:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AEC8A160233
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:21:38 +0000 (UTC)
X-FDA: 85430309076.28.5BCDFDA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 014EA40007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:21:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q0owM0de;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794579697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ecGrP1g3wwzch2fnfrpBcZqxZdOYZNnLl1DM9CyDgu0=;
	b=2HnqG+4WaEsRPDrJF+LPNgzXrNagPXckKqE43qiUA6Z8fO/LTXHEbvT4cEP5/Ct5mujTfG
	DW1LW50E34jgbktMjH0R7GYZphD4cvkNaR9cx97vLqg+GpzC/OJSIUbv9KknRJl6R0di4y
	W1WetINqNOhBUdse8VfaR93vp0jTb3s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794579697;
	b=VJ7LuyH7GQiGeSC2Mgy92PWfUhYGc1rZr8gRxu+CqXVGly7UbMLVfw4EWFJbrZPSBQNOxW
	FSqs1iVYImDOyuONT6jFFJ60hwhDMheF1pEumpMoYlYZn0TD1RXsrCDFgedIgDtniaQOyI
	+4L3TsCSBY6O/TGSu7kMyFY6sqb9WqM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q0owM0de;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ecGrP1g3wwzch2fnfrpBcZqxZdOYZNnLl1DM9CyDgu0=; b=Q0owM0deYkacAQoU7FXVSIgWzd
	SkYgR5Djjv+92CsMmzEF2dW4ARPVZxpViMebmSFf63XugaUo3vRmVOokXzNN5NtdKM5BiPGlDZWrf
	9w8x+JQmp+iCukXKWEcvpmW5oYDq/cI9hG58u0e+Ox+HRT/mMIYWtpgl1v9NTPl2e0aaHZZ8EZcZp
	acIgaYOjkdWRYniHKIAIF738TDLNhsbj4+Z1pKQa24pk/EOfvVTuS1krIawTMPGZCrf/5EnMWaQ0j
	ZjgGrXhf445OHXN3taRNp5mlKMq9WyIcWo26uKBt1T05WKB2HRk7EJ2DsCSEhliHm16zZ/S+egZVh
	CDPBnfxA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xRs9Z-00EoUY-2j;
	Fri, 13 Nov 2026 14:21:22 +0000
Date: Fri, 13 Nov 2026 06:21:16 -0800
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: sashiko-reviews@lists.linux.dev, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH] slab: allow sheaves for SLAB_NOLEAKTRACE caches
Message-ID: <avcb-W5ZOWqI9SbN@gmail.com>
References: <20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org>
 <sashiko-outbox-212599@kernel.org>
 <avcCGNUqCrcwbFG6@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avcCGNUqCrcwbFG6@arm.com>
X-Debian-User: leitao
X-Stat-Signature: 1sff3bnm15a6e8qb8cc3rwo1m18fiaxu
X-Rspamd-Queue-Id: 014EA40007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794579696-593482
X-HE-Meta: U2FsdGVkX19viVh9OAqBD+TKsX0jDI87B8kNXnf7H0ZhFSR6N0L0Tdfox6M+JSEoWG8y9m5dD108Dz4WQxj4lhUadygh5a9dZslIyHGkU/ZJaGY7Xks5qYX1r/AbikD8pfOxqZTsNi41SRh6sYJWmAgy6lxOIbIzI6AbQ8xtPkaYjfxWcMNB63myWc1RvCfQYso7rcbqSaxJbZczCmyFXO6cYG6JXVgfyk4SfvLeJVYIhu9HJxXNfxvSi4cQE5c08kwRvx1G10HqJHvjK96ncZHCN89Rpjhvo5cQKdGELhqeuNSPoOKnV2msxGCf4zOLD2RsX85Q53QZm9x7z9XnjFkhDT+Vx9NvHpGpa1FjtQPbD89ufDDs0fKZ2AZNrOBkevwD1zPVlxSl3yLHSKwHcEBHwXgU7ZrFpwfmw0+7YJsaulzfC6FARFcZ5P1xXruELMCmhuNGJ9W6feg5hRflJgy5aSlHCeH9gjO2HXKHrYt8Z4Ocqe/NiDQINT3+NSXgGqmO/Wf4QaHlSRcEdXR8rcLLm7z0U0R3CLpsJLjpqSFylGHL2Q1ytDYBAxkkxWSqX4sKwDVnMJUNlFL9QgwRgKbYlWAsLLKPqiWZPw/+Fh2dzV3lEAVfzC6P4XtMOtAJvfPxX3gA09NvjfHOsDCXBiujAbrkz12p5XhrYreSKxaL9ImwpvnaQLEWpkEMyhHqUylES+kihUETXO3ETz40L3ZROm0XyH3xVD3snvdMjqH5pjBGw5IQhoMIZ1MR9cMpbyvdQ9bSHQyjV73Q+Hu5Tsfpg3aU6Sm8bIajpKnyfTiaKPi8blSwHNH7Ch/x9sfRQIRdmAts8aGmF+gNoZ0XSKYFCLL+8RI4iV9nD7YLTiyn8iNyRgxYbYs93KU+sA/oKk5T/XPrLW34ysdGMeG+3hvSoWAe7c3H8FEd5gU0FTpIT1BS0ImcEbidaVggfDK7GAm0arOm86UwGpff+2s
 IWMoXEYt
 Kx4ElqfDSfRWHeSiUk3E0SbEhyiViFcNimrY785XKiDGnX/jdp/OfzLiDRKAWqZxizBkoGmM/e18D+TeKWcn1RsHb6PMLG0IdwU5u2Dz94WNcLEASyFw5epnbEv5vYywUawFkThjn4ZvwaUVFEq9XGTBEaPIuR+M8jpDLOhXz2xjHEOXD2H81eNz0jCvadWs57u40yO1VB29NbFY1e6o165j3hALgrI4u5Ju9WsmHKYZhdTCxg8Q+uzMM3dMez6ihMmN+6d7A2Wy6lrtNQlgJ2LProA2qUAlhZYnIv0G6Bq+LJfeQNbt4iTxCeG67Vsu5vz/s5ZT3kloWP3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 12:27:04PM +0000, Catalin Marinas wrote:
> On Fri, Nov 13, 2026 at 10:05:08AM +0000, sashiko-bot@kernel.org wrote:
> >
> > Setting SLAB_ALLOC_NO_RECURSE along with SLAB_ALLOC_NO_LEAKTRACE (or
> > clearing SLAB_ALLOC_NO_LEAKTRACE before nested allocations) would prevent
> > the flag from propagating into the normal kmalloc cache's own metadata.
> 
> Sashiko is right here, this could lead to false positives. I don't think
> clearing SLAB_ALLOC_NO_LEAKTRACE before nested allocations is correct
> since that could reintroduce the original recursion. Adding
> SLAB_ALLOC_NO_RECURSE alongside it should fix this.

ack. I will respin v2 and sets both flags for SLAB_NOLEAKTRACE caches.

> IIUC, I think we need to include SLAB_NOLEAKTRACE in the
> mark_obj_codetag_empty() condition in __free_empty_sheaf(), alongside
> SLAB_KMALLOC, if we go with the NO_RECURSE option.

Ack. without that hunk, CONFIG_MEM_ALLOC_PROFILING_DEBUG warns
"alloc_tag was not set" from __free_empty_sheaf().

Thanks for the review, respining v2.
--breno

