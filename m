Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315EBCD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BEB06B009D; Sun, 17 May 2026 14:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6961F6B009E; Sun, 17 May 2026 14:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC216B009F; Sun, 17 May 2026 14:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 466BF6B009D
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:47:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D966C140585
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:47:15 +0000 (UTC)
X-FDA: 84777794430.27.3824F92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 48F0120005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:47:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SN3KVN+O;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81mrWoHt13aOQO1KAxG9aB0dls/QrWDcIP3sWIWttLA=;
	b=j3lqSCcknC5Kz90iXOrqCF8UIgbiA8j+KQ5PhwCqVs5k3hjIIilD5DYtvQBGiKrNpqAYq7
	q4OzuLwZlYPDss4cbkO1IX/Z2lNQUhOY6/fPKWxIHgqEknuyk+3OE0ZgX8kVyk4DbisVPc
	aWc6lRHQqYbmbuk0UgrcibWQof8YMwQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043634; a=rsa-sha256;
	cv=none;
	b=0obccKPfK88GS8eKqoXNXy2k4w7/Io1zPMnQ7GNJxvuxRWe2+ymVrqc6h5/DoVVGHU4zQt
	6eNxMuSO6rS7Td9yTKoVzQKtCfoLfpwt0/1wNl6QJMVH7/RKrgGwu7++pObtGY+8509kKT
	HXNhSc3//tTJa5foLvaM9njDU4uX99s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SN3KVN+O;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AF4E6001A;
	Sun, 17 May 2026 18:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07F1C2BCB0;
	Sun, 17 May 2026 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779043633;
	bh=q0yo9dDFhdfYJZH46om+DDXSMlLk9yZyYFxDwNP5H2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SN3KVN+OmG+YdSHj8RmFq7bQsp31iwYIqyzerCEi4S9YLr2aGW6GrarlYu8N5KfpI
	 PRLxMH7RFr4ZHzgAh6nlDxuKg1wsVfg+7+ir2lAuUz+paDQgrva9SUc7VK3PMybwC6
	 LZm5O3+qfN79znFh/walN/wYHuKcZIPu4XL+hu8KbvZhOOdLgUM9xblR5u8EShTrGl
	 OhjnVG9KbVI/iG9yDYAJGrE0ZtonMUd3CcYMOz25f601ogVQi0zfDerCkOpdJLsnsG
	 WgJLI7g2BS+Wio+EhVuUJzaY4hhSjo1HaCFGPEB5u9XJzHWkPlXPQkScIN0lVViTc3
	 FM6Z/DJz5l/yA==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 3/5] mm/damon/core: floor effective quota size at minimum region size
Date: Sun, 17 May 2026 11:47:04 -0700
Message-ID: <20260517184705.4652-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516210357.2247-4-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48F0120005
X-Stat-Signature: sgdw9mwtwcuwq73bygeemupt3158trca
X-Rspam-User: 
X-HE-Tag: 1779043634-279067
X-HE-Meta: U2FsdGVkX183h7/IKAdA4nyaEhTFq3PJDsrEJlrx+uh1FNOcet1QynBF7wH8a+sxbfgvRk+N7DuNIocK7yzBiFImpLaCf0rSenv2x69SB8cbK5HIFGvgdFgw63wx+fn08kb+njmgfGHFpmEDL5PHhLuIKkhLRLgFmlbVhm797T58Ky8Kk44UNk5A4beM48WWqpBSPHyEcMOi5J53aTEp0q8j3bVTs/b0JovZCW4CBNKJwH74hy1UTGHPTmgPveVARHD4Oz6jYUSTNrCce7j3NMtwf7K03jqvrFh/6g3MXtc4McqbYlwiONg4KZG2K2mACFwKOsNl+9irWuFTbKjRXjZovLOAB8B85LpeQ+/DebESAiN6NJgQdesv+m9K+OBj+zTMyynXFMLaa5frq/J7Zn9itNCribp6561oLbNNPprj7/uulURAEKU7QSaKXBkhQekKud9PCTPKDLec/iBym40TuCTKzxrfwAHh4/KVL339WlT8ay19+qF1YmNf7/s76kQZuer6+0IvsIuum+iDtpHZH/LUmd+obVQWqzTsFbyjIA4RmPkZvdSplHu/7v1wblnC89qopra1GT6s5T+dsFD7dbJzsXm7riHuXRWPAozz+zzN21qPaGIWRTx1sODOf43EerNMs/+lTVebzUChoG7RNJUmJwncwlgS3lMK4P1KjTcpf4StHBsnZPER7H/tFk3Tg5zJnzWyvMALaeJDB74uBT4b/O46LL9RIiIamH2pbu+EYgS0fqnOj8nrbw5rOAo9sIA8SnXXgqJrJrCLahGJn6JiQ10Aywa6H0kEZADW7nmKMc38V5PMfI7e3TS4nzG4yRPrYbFZHkPFn2EDU46OAh82tvetU/C9yamoB01wk762+T6EUH39dGv6q8ixCvAcM14cSnwGdAAjbzkWahAZ4zZVR7IFVicQd0Gery/NwVKa73vRu+BVoi12gF3L63Jq3KcF+2Yr5TNhHm5
 X5knF/fh
 W4F3pJZ7Jg5oSNDemcIkuRoEgf4skqZQUPpoINQvDWv2Nm1pPKFMCIMo2E/DH864AsIqbPaorHvxSFtrQZVoRnr2fB5vYsKnUkGiu+vzaExsC7hv5aq5ln08x6whPLh+QyRYTkohDhu1diTcVYhIX2hIE2gfR3/vzLqtj+CFUSqt7NfF7fJOVeF+5Bq2QctS+/UXAlu812VwblQtz6Ifusdy1o8lh7rGmN45bnBEPNzCcDkLrIW2DmWH3zRiUke3hqdEkc23Worbd3uHS9AfiXqTQThn66iF74HBp1h99+D39iO1L62eDA+p0wQcOEzuP9iVo40hFRX9sJYBiwPFDfG/m0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 May 2026 14:03:55 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> The CONSIST quota goal tuner initializes esz_bp to 0, producing an
> effective quota size (esz) of 1 byte on the first tick.
> damos_quota_is_full() rejects all regions when esz < min_region_sz
> (default PAGE_SIZE = 4096), so no regions can be tried and no
> feedback reaches the tuner — a bootstrapping deadlock.

That depend on whether the goal is already [over]-achieved.  If the goal is
achieved, the tuner will think no change is needed, so keep the
effectively-zero quota.  If the goal is over-achived, the tuner will think the
DAMOS scheme should be less aggressive, but it is already effectively-zero
quota, so keep having effectively-zero quota.

If the ogal is under-achived, the logic will iteratively increase the internal
esz (esz_bp), until it exceeds the min_region_sz, and finally start making some
effects.

So, unless the goal is already [over]-achieved, there is no deadlock.  If the
goal is already [over]-achieved, why we would want to make DAMOS do something?

Am I missing something?

I'd like to discuss this high level thing first, before digging deep into the
details.


Thanks,
SJ

[...]

