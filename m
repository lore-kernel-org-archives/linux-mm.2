Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09636D3ABD5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 01:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22E426B033A; Fri,  5 Dec 2025 20:50:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEAF6B033B; Fri,  5 Dec 2025 20:50:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFB76B033C; Fri,  5 Dec 2025 20:50:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED2B36B033A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:50:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80A2513AACD
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 01:50:21 +0000 (UTC)
X-FDA: 84187366242.29.F041A35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CCEDE180002
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 01:50:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2LVbotm;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764985819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+EA2M+YwG2tZU0ByqQdVVcLyLHcuelq6lmEGe5JBXM=;
	b=ngHeimRSPlSYPvMzmr9k7VrQhsHADse+1na7Q9sgyhOSSNOtLUFrGU3ZG/No/YFD2lCSJr
	1s4cWw8/DuFZ2jGDW5ZFANBsmdsPi6sgHHI2L4MmW1lmRKnR5W0m83023R1yLKx/tysH3c
	GC8xAeBEO6lwH+u3YypggewhvmNaZkA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764985819; a=rsa-sha256;
	cv=none;
	b=BjdzKNJNUvik/TAEJyNiAJ8286rPl486P8IZdAJoTbtPYe5aeiZyVuERps+zQrKMvW6ptf
	Z/+TDujBApgUaMqcnIlnnHIh0wL9jLU7qJbKxam8z3Cr3LN6NqA/IuSPhcPsIlGK/1BnZX
	51j2tON95COj+U1mfM0tdrgYUmFXrfM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2LVbotm;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75BB1402FA;
	Sat,  6 Dec 2025 01:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F43BC4CEF1;
	Sat,  6 Dec 2025 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764985818;
	bh=in0qOOSwH8FtqkBiehP6uo5dV7ebZ+JdQOSUFNW/f2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2LVbotmeW7bX2yMDAAtRgWtuVUYdisjNhKqgiHW4KGSPhy1fBfq2sC2dF74d8dC5
	 jUSj5xI2VzLUnKhbGS2U67PiOyX67Ut5Y371RGCIr9TdGUTJr/drglqz4BKDpdHEFG
	 NxmyY59f07yY/YmyHbp5Ka7IISkhpl5xSJubakZ9yww7nZb8uUsoqrtKr0lCXn+dho
	 PfB68H9nrDXv9lLxkn66NW5Rj1U7713kf6lRznH6r51VA+tguE4Vyu5uTHLhEFxk1z
	 P0Nsp0nKLk6f+httVUR2BHOceg8Fg/zI5Ellh/1p2LDeLj8pY4Gsn5Obn9EGMXlOvb
	 ljhzJZQ75auDw==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	lienze@kylinos.cn
Subject: Re: [PATCH v3] mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
Date: Fri,  5 Dec 2025 17:50:10 -0800
Message-ID: <20251206015010.47826-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251206011716.7185-1-rgbi3307@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CCEDE180002
X-Stat-Signature: xmzq1cej48jh17frts6mgbyieghg97u8
X-Rspam-User: 
X-HE-Tag: 1764985819-39428
X-HE-Meta: U2FsdGVkX1/bbgHsFcfNGJJCYz71c9+kpycz10UKi764SG6C4egxdDe+qDAOZu2ILtEeE3uVO6zlOCQNApGbJ4jovUCBmTp8Go0qBwsaDvcyrS0/S1Jlqsx06Meohn+hcXLYqBdI6SaDwnAv1VIvBwZMQeCERdLdroWGruqxLp7dS5ogtKLX0Y4ZevFz0zCZ/Y1zszZCwbtrWSMq+8SON8R+W4hbjzT6U89H4dFA+NLk73+GAl97w3/XbG14JDWVhK5081OaWfaZI5CMk+giMk8sbSof4Q1YKpil8h4j4mJRF4tXUVSea1HYqGAPMf5XtApKG0QSYaqGOk3XfuYKTL1iXToG4yY5WbbeOxzDLgLD2Z0idY67qoa4xGLYe/MeelxqDKYlYshKaYiaWYDWgIylkC2zr5ToeW+EqNIss1xIGNzbrRDurWEiWkJV4OCoQhK0Kp+Ft6ts931+T5voftVmbSENxTNzCgNPDUsGJC7ZZrG+AN7zsVDfhwrF6ou6bkoKm/ko9RcuYf0GaJchBRFeC35pwMWd9sBSIVKGQQcer3NcAEIqVPIS8gDQimit19M9mYoQKbpZUvqD/rmnRZPivqGvWDMzsjeqg5keSmqfSYXXsVxY27KMbRKoPqXaE3g531+uz45wQkbW5ZbGA1HvGsTXmGlV4BFIJXkS1pntNrJ/jjsPveNIO1DTDMtJnPd8Dsn8jLbWSFWQrODtyAQKUA8/s5x7erAZow/nPsKCv/LbMe0iRpAPL8XN8rqxoSjTvwQSHKvtBF1FnBMZppEpPvd9Ek10pz7yEWaak7f+dpleLa7xMbGNjtX9U6W9qxYzg3KiGUeLr7tcv/0TPpfi955ZsF5/r1dF55949qcRxYI+XwLHOsLdHzwuGt6zilLxPHRRsTF3Tftrz2PReMcxZz7CTNtKmEO1CmjhIGFETyxq7bxlI4Fztk3/4Dz9h3SjYiiDopdPDzdUoxw
 An0Hq1sJ
 TzrFXd8ikVh5ZUIb+GfFSb3xwOj2QJg7KrjZiby6ZK4S2g23yrCtuBZnzkM+4mkMw6IS9sKaMMhaycZ0e4m6CB3y6Gul1zOI7MR8YfxuhQ565ozFsGAJjkKAnJMCElMPh59o/4dwA777r/DR8/IxR+p6V9bSgXG2L5x5RJPW5DlnLznDiySbPPfsIxd/RF06tUq50SiLk/q/epMtNWtBpn0yAaCjv7psFS88+PW5Wum07WaJYWLWbeZXPvB2rH2D/Gg+/GvD/e7zjh3Z2RH45eS3K47BkJsTlMgVsmX0Jc9oPrpg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  6 Dec 2025 10:17:13 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> The damon_stat_build_ctx() function sets the values of intervals_goal
> structure members.  These values are applied to damon_ctx in
> damon_set_attrs().  However, It is resetting the values that were already
> applied previously to the same values.  I suggest removing this code as it
> constitutes duplicate execution.
> 
> Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
> Reviewed-by: Enze Li <lienze@kylinos.cn>

I show Enze did suggest changes [1] to v2 of this patch.  But I don't show Enze
gave Reviewed-by: tag to the patch.  Am I missing something?

[1] https://lore.kernel.org/875xal44lf.fsf@

> Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

