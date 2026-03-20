Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D28A5109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC106B009D; Thu, 19 Mar 2026 22:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D276B009F; Thu, 19 Mar 2026 22:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3346B00A0; Thu, 19 Mar 2026 22:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F11D66B009D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:48:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FD8F140841
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:48:18 +0000 (UTC)
X-FDA: 84564907476.12.7C748E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 14638C000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:48:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G89sXyH2;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1n/mKYSJSaME5mxogRmBKIVJdPgwSkj/MGdZmTZt9lk=;
	b=wmhjWVHbj2FFZx4OLKcQQU2LsdvM2bmxTp+nwZxxuxvPwD8Q56nrSHBmfwE9E10lO4HHyq
	+I6Gv4VpN09l+Mzl/MNLMff3FYqY3wKVmW+ofgB8KsdZjj7fyZqz+fqqiy4vYw6dWa0Aq0
	PySKNkFActpCwIWGHrWafzAD+1xAWyc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G89sXyH2;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974897; a=rsa-sha256;
	cv=none;
	b=ILbSBveWQfukd+tdzzDW+Mc3lu9yUhDwhqoMfySZJLTmuSi9MWF/Sr4Adt5T7aaby6Mja8
	8H+DlNBKb056GvL5klgCiXueJDIfNuHlC3PTqAIvEfweXAflwK7PYG6kl/r4jKt+RoGCAj
	DIUvAbCm4Q73D+0VT9VgabXvqicItfM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F04A60097;
	Fri, 20 Mar 2026 02:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40ACC19425;
	Fri, 20 Mar 2026 02:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773974896;
	bh=/MJZfpkxLYSLTMw4fqVA5bUBJsT3txP8IPH/KELwiHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G89sXyH2fDZVtSEe3H+47YIQSJXtr8wIa23HCK5ebn/1zfTX0RypRyrkcpga9Qnvd
	 R6eibAaBpV0yUuru4tddKxWNRXmANQZW5/mR80XMZju8EZ3hmVpgJmCbOKYz4WjYry
	 WQF9pEvwp1CpJqfa8lHq/y7y6XUn1uUTZyXh29/CZgiXBMEhg5tnT/H3W9NH0dGsKW
	 jYUv0LQqd13BxAd86okQORVbgGKHG0Lg5qlDZ2NEpRYW+HPlFp76GCoE0xYhcAaoDB
	 Gbv2JdLj4MbK0srj1EZB3iMxBfvPDHeComtOzFW31PGiOUH+LFnO8qDzrf1wtJktKY
	 TjAwQABq/0A2A==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/reclaim: fix min_age_region truncation from unsigned long to unsigned int
Date: Thu, 19 Mar 2026 19:48:13 -0700
Message-ID: <20260320024814.1922-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319161620.189392-3-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 14638C000D
X-Rspamd-Server: rspam07
X-Stat-Signature: n9kbfpa5377jqct6jarbz7w4ufikapgx
X-Rspam-User: 
X-HE-Tag: 1773974896-704633
X-HE-Meta: U2FsdGVkX1+nrLT/n9zJEza8NLm11epPGZuDohiUXC2oQAGQdkc4QaFebx3+yp2Bb7cFFYMWC9lamoEa9e0z7WEtOdWEXKBMbHN5X+AeTpaq10TlkQJ3lswF/j74VH+56e6/TdO6qYtX3qRcQTLRTMzK9Xd5mbgYdqMoXnLVUr/fj5k17C0MJyE0Qnubp5FvP5l8PZxx2U5iUEJL9ASQ/Bq9grjYgYKaXh9IKHXY5EbWZhOi+HDOn0b/GHwlcRwSeOeYIJeI85XFq1+EkHhGqzP3nFMPILk00AH/0pisvvD9WyND+UkSexmPMfg8zSUhCB9M0PnCDUY9+jz0PgzDm/YU9iBqaE4+hME3djSXA93jOgpZbnpp2OcCUgVkJ18in0o42GGrGMgoD0CyohCw/k3X53gAuhbC+N1yGqpn3WnVHUDFUK6y5DaIkXwHKeBFDF6uiwur94+nGQgoqV2aM7bpGJaMDuPHYV1MAStSjMWt9EuFDU3d/BMIADrN2K94qtN3ZpSw9sAvsQQ0qo8kbO/AagMMspMbbOMSe93te+mRVt8LbKJQiQh6TwcNwAgrEDvY+8iVZ3zcD7F9tGs8qWPruJ5KMu0mqFrKYRJEXcmd7hwna5+wd/UjkX8MH7/x9frJgkQBBHXhFG7FI+Gp70AFk40WlikA0WEhWvT6CO9RnN2hiBEXobQe7mJv49HuN6n6fCct2qGbGKvXRFiMGH5EUYZHaytOb15WnZ9SBBjtdHu1FWI+v9ZYv8jMfqLvELl/GzPgjlVfJoaEpL/eo2N6dc7RNYvmudLNWXo0BbpuF6+2nMKNZMQ9D5B4M9sIyWYD1vLKj38yy+R31f7ojg5ZPeByAh4QFAOKLwkJoBdYXAjWvY+4bY4BpMnEGFNQjJwVeawpLZyzE2bn/gWGj97bsLXD7F1hmQqinUvBv81yXtO2uX7VL7K2fJ1Jb9NLwhJairveHlOSJAJdpcy
 D7B34Tzm
 qwVEoeRumPS4vAXrj80GTViScY58fMfyYwIols7uXYiqW3IjUJ+t7EIqNFPTI/8fkFiaPdjo3Pn476cagunRL3Ou64VJGOk8/BJcfahabnvX9nfrgYCWxxL7CMbx4RHOeKaPajWCAZtXBteVYRQggq1gVW04/9xuIwSSCBP3SxjP4iuHyxXT4f9gx/0PMa2Ryi3VSR50GpeC7y8zIH9TaQixxDm6KIncHSBY0ShQj9b33ZWwnbwNcZ1OMtondT2zb4v+f2q62mrjN4fgQs6mPfJiyBmE43pomQSOy7UX39u2wfWDI0TQEFRr6FyU+UqUvCw7CFyG8Qlq1f9pNy1sdtBVebN5tcGzl4eBp29JBuKWtstY5PeyZSfTNG0BHtjNHiVt+UIy9VtaErBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 16:16:20 +0000 Josh Law <objecting@objecting.org> wrote:

> min_age / aggr_interval can exceed UINT_MAX with extreme but valid
> module parameter values, silently truncating min_age_region and
> lowering the cold-page age threshold below what the user intended.
> Clamp the result to UINT_MAX to match the field's type.

I believe the issue is not making real issue in real life.  But fixing this
makes the code cleaner to read, so I think this is better to have.  Thank you!

> 
> Signed-off-by: Josh Law <objecting@objecting.org>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/damon/reclaim.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 9b55df304e51..303c64a56073 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -170,8 +170,8 @@ static struct damos *damon_reclaim_new_scheme(void)
>  		.min_nr_accesses = 0,
>  		.max_nr_accesses = 0,
>  		/* for min_age or more micro-seconds */
> -		.min_age_region = min_age /
> -			damon_reclaim_mon_attrs.aggr_interval,
> +		.min_age_region = min_t(unsigned long, min_age /
> +			damon_reclaim_mon_attrs.aggr_interval, UINT_MAX),
>  		.max_age_region = UINT_MAX,
>  	};

Sashiko comment.
# review url: https://sashiko.dev/#/patchset/20260319161620.189392-3-objecting@objecting.org

: Could direct access to damon_reclaim_mon_attrs.aggr_interval result in a
: division by zero? If a user writes 0 to the module parameter concurrently via
: sysfs between the validation step and this division, it appears the interval
: could be zero here.

Makes sense, but orthogonal to this patch.  I will work on this.

: 
: Also, since both min_age_region and max_age_region are now clamped or set to
: UINT_MAX, the target matching condition becomes exactly UINT_MAX. In
: mm/damon/core.c (kdamond_merge_regions), a region's age increments on each
: interval via r->age++ without bounds checking.
: 
: Does this mean a region's age will hit UINT_MAX, match for a single interval,
: and then wrap around to 0, effectively defeating the "reclaim if older than
: X" logic?

Good point.  But such case may be too rare to consider...?  Anyway irrelevant
to this patch.  I will take more time to think about this.

: 
: Finally, should similar clamping be applied to other DAMON modules? For
: example, in mm/damon/lru_sort.c, cold_thres and hot_thres are computed from
: unsigned long parameters but typed as unsigned int. Similarly, in
: mm/damon/sysfs-schemes.c, damon_sysfs_mk_scheme assigns unsigned long
: boundaries to the damos_access_pattern fields, which could also result in
: silent truncation.

Yes, similar issue may exist in DAMON_LRU_SORT.  But definitely it is
orthogonal to this patch.  Also, as I mentioned above, I think this change is
good to have but not really fixing real critical issue.  If a nice person send
a patch for this, I'd appreciate.


Thanks,
SJ

