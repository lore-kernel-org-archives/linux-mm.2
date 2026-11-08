Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E942D606A321
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 21:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BHvQJEZm
Received: by kanga.kvack.org (Postfix)
	id 0BDD66B05B2; Sun,  8 Nov 2026 16:01:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0680B6B05B3; Sun,  8 Nov 2026 16:01:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0746B05B6; Sun,  8 Nov 2026 16:01:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB1236B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 16:01:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 438D51604D4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:01:50 +0000 (UTC)
X-FDA: 85413173580.30.DB2D300
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 93D321C0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:01:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHvQJEZm;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794171708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LlRw1T3EhDLk7qpw1Iv3e7L77NPv6Myz+uuZpVhsszI=;
	b=cxTu9yv/e7+oTLpDmNIMY6s88FhZEUJfQ66REDACVWkwVvQLOmlYfThtdD2QrBnF6R6X1s
	rvmIrREHgmLISsfu1lg9b0gQgqOxDvpmh+8E5ac13fIZGL2aBLDxYy9ukESrUB+GwC5+Ao
	9cgP3fHCwNox2Dzi+R3tBeak9KODnvs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHvQJEZm;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794171708;
	b=PGRIWwz5wjOgpyXzVHnfRE5OsN09RrMUwRpyxdbyviUeYpwhKEandbZqXQXhJ4hNnukiz6
	gWH3hprwIg7IQ908LrU/2O5dEhwpioNlSZ/Edpfuk93cjC1MpP+pWe1THP0TxiHUSbfhco
	JaHUwqcdJLT1xOMKU3mLEoV5dKAXjgM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 462F260D0E;
	Sun,  8 Nov 2026 21:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C728D1F008A1;
	Sun,  8 Nov 2026 21:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794171707;
	bh=LlRw1T3EhDLk7qpw1Iv3e7L77NPv6Myz+uuZpVhsszI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHvQJEZm1OHVlrkHXPv0o9B3+mNxp6d8OeOu8Ms2swuGncA3vCencR/PNNlMeLHbS
	 FTqXLaA31Q+LSWY0NZq6/xtPOa/7Y9LzeGnonavPI94pD7bAMm9Z2CjarWPQjLLE8t
	 9c7jmyaWMvXYzsUqhwywIGmOTG+QDHV/QvovtcbNLnCGpYiUNNa+L7XGjaIWOhadFV
	 YHo91DIFEGM8C/7m0NiLxQNJewxOmKBmcMBXgWOGWt72q23QgognUsvRTJYofz+Qwt
	 8j6u5mVmzv/T2t/ya717XIuGYvd2AnyefCvwyhB52UxoIyi3nu+mAF2b9C8cHgzNrb
	 3pcHTOnAozH1g==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Usama Arif" <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.1.y 1/2] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sun,  8 Nov 2026 13:01:38 -0800
Message-ID: <20261108210140.908-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-204020@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d1yd9qgxt94yqf4q87dn8ie4zxfpaeo9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 93D321C0004
X-HE-Tag: 1794171708-725208
X-HE-Meta: U2FsdGVkX1+bWEVgCWpeGP4PqBi0sfjSEXrvSk0pcd8qXuqzyVt9w4UaIZX8W62wY1AcaQ3BkGm7f+inXRVHY7dlwPyeYepw5F/2L6jXkllNecBfaVIAXKw8nK9vxizVRqzqDQdIJ91YNPH8ZX0bbbgK88GMjRoK9fBO103TygmVs7ze4xPCF1StMgUuVJb2Qhl9OozqrkW7eIgCWN9WYYRZ2ReakwuN1wO9dPZ6AH+qTlvJ2/0d0pFKeNMdJBuCdYwWymfukhN53hc9m1RZO5iW5pC3OO3si0Q4nKLw8Arg5G/+EEqf5kOhfzqauK8PXDEqYPKZs/EECCy1qSetLckE4VVG2AUqwCrMt9dFyvaqXvpkwNAzliu8Ri95XY1YGNxNpeUh5oDC3bYsC+YM+VMWnBcEEEUCDO4V5IuvK/JHAcZ2FM/nZvyk8sVfiJlGxKnkV+o6zjJxB7+n/v3z9vbhPgsRGnCACwoP+C66qcG5nkvXl5DbNW+ddMofFbLmcYIGwwiAGdfrx4Sl4ld7E8HoWqVoohUEw6HFIA5xVOBVn+PSeOwBj7XqL5pNIzZvG3LnkiVVYVfJTNKImLpfnTkHVCP5xzcL7B783nt9+XuMtgCzuVGBD2idZBL0jCWZz6oxi24Eumr/Yris0IQTCl7dhlzA4EfPrcaDIHxGEZK3OwOD0xwoKlfLdKj2TNg0Q9DjmR2TJAWT1X8jAdguDZvnKUIhXDQZNRRhfQyGEJRf9BTf1q+kHoEo2mpDrtXZwN72nm8qtb2AAW5Ms+VTL56+02O0q/RDcHgDwemLmFq4llbm4zYzdtVAl3pJ14xW9bOyPLwHOt8KnI7erkWuMNX4NAZVLw+Je9o7bO9fIEx5K9bgWw82+jf5WhK56YlesUv79t84pfJK5OoAeIgQQosm9RfPc9shIsi4oMECxQo5tk7OggWQo7sf/ZGN38oNibDa6AOL3lW9mroeZGK
 q37OOaPM
 ckg28jidSRSzqm7b2QEjOkMTW3Cr1uA9JOSYeFX+/MNjn67rvi2KmlkywpUsJj+UsUMbFMc6Nn2j8kKXtkz8LPPgcJM8cp5Op/31BQBYbAnjT/YlM2Vsx2H3PDvuE4EK0z361I7AsrvbokxFSkvs3TfatphYOkKemzKQOg+gRHdDJasOJ8cUNgStA8PoDW/QCIF6p5G3BiCl01npLkxaRn4aGg8hVfBg4lql1lpY+eKZ56/i5VbBT91088cpIHDpnV14zEx8+99+KEHH9u1Vct/ULAYO3fek0xHtFa0bLIlcYQJbtx6GokS9Le0ol9iNShJ8P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 20:36:18 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/damon: inflated tried stats in damon_do_apply_schemes() on
>   split failure
> --
> 
> commit 3b087258b4341cba87012b7cb96ed676fd164c12
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: skip applying scheme if region split for quota fails
> 
> This commit updates damon_split_region_at() to return an error code on
> allocation failure and skips applying the DAMOS scheme in
> damon_do_apply_schemes() when splitting a region to fit the quota fails.
> 
> Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
> Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
> Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index f0da5cb2b88a0..9206737d05ae7 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -810,7 +810,8 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
> >  						DAMON_MIN_REGION);
> >  				if (!sz)
> >  					goto update_stat;
> > -				damon_split_region_at(t, r, sz);
> > +				if (damon_split_region_at(t, r, sz))
> > +					goto update_stat;
> >  			}
> >  			ktime_get_coarse_ts64(&begin);
> >  			sz_applied = c->ops.apply_scheme(c, t, r, s);
> 
> [Severity: Low]
> Does jumping to update_stat on damon_split_region_at() failure inflate
> s->stat.nr_tried and s->stat.sz_tried?
> 
> When damon_split_region_at() fails, sz is the non-zero remaining quota
> size, c->ops.apply_scheme() is skipped, and quota->charged_sz is not
> advanced:
> 
> mm/damon/core.c:damon_do_apply_schemes() {
> 	...
> update_stat:
> 		s->stat.nr_tried++;
> 		s->stat.sz_tried += sz;
> 	...
> }
> 
> Because quota->charged_sz remains unchanged, subsequent matching regions
> can repeatedly add sz to s->stat.sz_tried if allocation continues to fail.

Trivial user impact issue.  The same behavior exists in the mainline.  No
blocker for this patch.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261108202759.117377-1-sj@kernel.org?part=1
> 


Thanks,
SJ

