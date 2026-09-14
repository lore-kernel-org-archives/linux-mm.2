Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FBE5C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB2B6B00DA; Mon, 14 Sep 2026 11:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C4A6B00DB; Mon, 14 Sep 2026 11:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3716B00DC; Mon, 14 Sep 2026 11:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 301AA6B00DA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:16:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 822F4A3C76
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:16:31 +0000 (UTC)
X-FDA: 85212719382.17.3B2027F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E02DB180017
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:16:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kmm6SMRu;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0jZkSZMfhmBRZ0Xr5aed0ootLssH96XlsM2bmpkwl0=;
	b=YI5Mi3DQe6xZLGO2keMw/WGpME2aSrVgye7yq5Cq0zYkX8ThfQSnsX6FjGDdpnSSxzTeUD
	BmnCFiGJMOLljxqC8KRMmWWUvQXy6kkvCS1T1aruTzF8XeRrVqCr5qgpOFId1lmjxATZg7
	Ackrq6X/jVyza6+Qbp6f4Kb86dz4vCU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398989;
	b=wdLw6EibJNf3NJqWUk0TwyvgaBNH4XZ4iSRx+c1nqk/rxGsi4rDkdyoejMIx7MFpbPJG5n
	nSfhy0WYz7rzmy22qKz/r/uzb6fkZn212MLUrU35j5sQ1bO6ZS6c0IYvlWOIzZWvBfdI0z
	PqlmzOmrdEsqVofGxeDDC7hnqL85o8s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kmm6SMRu;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F9914022F;
	Mon, 14 Sep 2026 15:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72571F000FF;
	Mon, 14 Sep 2026 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398989;
	bh=B0jZkSZMfhmBRZ0Xr5aed0ootLssH96XlsM2bmpkwl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmm6SMRuxY5eyqjxySnQCJbeRb43iEM7D/MWaGkhWM0ozdkt2dDD8pPOu2p5z3azN
	 +tZ5F2Y2EZN5WpZML+MdhDCrCrNFH3YCP3vvLwSBY5KX1a74Dk7z/POyozNlmv/i57
	 KYAhhiwhISrDNg6Q9SuObhLAgWTPenpSjNbNrJ9yUfXCj8OhsRkx7F0utZ+RoWc7Kb
	 oyB5ghapxEsW53c3ayl1ajhCFtozzXwgYvh38XKkZQjjEWorZhIEqtN47g0/iTwezH
	 OhqbBAQM6YD4NORyZuMJPPWA/SlkhILRv/ZHfK7ppgBIDp0MJnxYDHuQxcUlbON4oZ
	 XjkynDU9AKhhQ==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 4/9] mm/damon/core: use damos_quota_is_set() in damos_adjust_quota()
Date: Mon, 14 Sep 2026 08:16:16 -0700
Message-ID: <20260914151617.97903-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914150150.1507525-1-kunwu.chan@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ah9czu46mkyofo9dma6rfy7p8b38o44
X-Rspam-User: 
X-Rspamd-Queue-Id: E02DB180017
X-Rspamd-Server: rspam03
X-HE-Tag: 1789398989-594265
X-HE-Meta: U2FsdGVkX1/W9i8lUuIXYWEkHriP1/NgG1SyVcuz2lgJvmshdQW/u3BT5MT1NmfU8jir3slzq8HqqqZjShh0OgF3/FlM5lnpJ2fpyw6sdifjGD4mGawOSMKJhtgbixPhX96GliaNTBXU7L+igHYshPo9a00Cr73VjJ9AShav/lUynPyp9rmGtKK+uxyleyNgY5yDPW4rDvVmK7lzMcBGqf+SKZFXZ29FJ5I6Crh0HG/dhpCf8YkcTPc10AIKuc1QZB4zW+5NUzmb+J0BANlFGvNau1BWwXvBWjlyMnMCWyirWGnp6NRpzBNfg5UQAQla8tiGAmkbh9Q9xmaZbCHGrMHxSzPwwyht7RLHSS5UNAVPYwnBDB55lUg/8rbE0Ao1WK0ofUmCVPy8aVz5XbHW0AEEAIKDmEOTY3hzNw5Rbbqem1KOMbtJGJyHzIqRwevJswKNckSzmcIXECG/pqpjPVLMdDM4qIWtT+B4T39tYhIH+AxVoqF8y/ZY1Zzuvg2e87eNkTd4Y6Xc/WBrr8MuGH1yRpsdYrCALqimuf9guaK8C2EpANm+gO2IRTF9kb3ET610wTxqZPCbYB2bpD/dXY70XA+oLP3j5hcjIQhNd19HbLLS7wrlqlNBcYItfUTbsvDJbz0Xua228HOWKaXtc9rxuDks0vjaz/2V8eMwd6Q7POUU+bQ2eMILyj/9TtPe568A7An4Db+Td1Bx0G+clcEmnXjeat4DgwgNuBONqDPiQU+ht70EFBcMm3J57YGASoyPkQBN8Dwzt4dm5OrT6/Kh5nTHPcNGKf1K6QCnCkRHOnTtlY/1A2E8Ek1RWhL/FnvqLuHDwQiXiwocFcOS3wyrefP/5YUM83g/85hJ4eHjzVp12J24h2g1iIWSqEfkDZFUFCrgh4bhzB86fhCouySUHcTr1c/ZHlenkzFAEbhB927B0sRMuDgj5S4wOW/2ZcaT7PR/utUPwjrx5Go
 rPoecBac
 vGDWHxi4lNuiyBhorMc4j1PJf3TLwe6eVX8E/pETpuVtU0s0jx7hDUZWAG/XorYkX6vah4VX/T2PXwHmm5IiybO3K4ZEWvKYag5ueZcrP1s+gEPiq6k589vp8WhMX1DwviWYYkFqRd7OwjIVf+Sb/7jegIKIPSBTy4IZ5wc3rzBIgTjVGzhu3x04wuFq3UCH1qL1mKHoMMVZpyQbeWRoMHlFutqDBA0LZJ2qmmnYHjEEYWRlg5j5kdIOG9XUTr4fMqqrKZyQQW6rpmLgFwlOJFS4obZvyGeGrTe28PejJDWyJ1Rz3ocDlkOhQHrMClhO30aHYEtBTxmIqfF2QKTm95qxgBle8edRw7f/ymfeDnNN26Y5NdVm9ikl/qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 23:01:48 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> On Sat, 12 Sep 2026 13:08:05 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > damos_adjust_quota() is manually checking if the user set the DAMOS
> > quota.  There is a dedicated helper, damos_quota_is_set(), for the
> > purpose.  Use the helper.
> > 
> > Signed-off-by: SJ Park <sj@kernel.org>
> > ---
> >  mm/damon/core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index cf10f6d725c19..dd27068cb83e3 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -3344,7 +3344,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
> >  	unsigned long cumulated_sz, cached_esz;
> >  	unsigned int score, max_score = 0;
> >  
> > -	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
> > +	if (!damos_quota_is_set(quota))
> 
> Hi SJ,
> This is more than a cleanup, because damos_quota_is_set() also checks
> quota->esz, which the original condition did not.
> 
> The path that makes this matter: damos_commit_quota() copies ms and sz
> from sysfs but not esz.  So if a scheme runs with a non-zero ms, then
> the user sets ms=0 and commits, the running scheme gets ms=0 while esz
> keeps its old value.
> 
> The old check would then return early, leaving esz stale.  That stale
> esz is visible to damos_valid_target() and damos_quota_is_full(),
> which also use damos_quota_is_set().
> 
> With the helper, damos_adjust_quota() proceeds into
> damos_set_effective_quota(), where the first branch resets esz from sz
> when ms and goals are unset.
> 
> The code change is correct, but worth noting the behavioral change in
> the commit message.

So, if user sets only time quota, and then commits the quota to zero while the
esz is non-zero, esz is never reset to zero.  As a result, DAMOS keeps applying
the action with the esz forever.  Correct?

If so, this may deserve Cc-ing stable@.  Kunwu, what do you think?


Thanks,
SJ

[...]

