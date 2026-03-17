Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C150FED9F1
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967966B0088; Tue, 17 Mar 2026 13:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9188E6B0098; Tue, 17 Mar 2026 13:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8073D6B00A3; Tue, 17 Mar 2026 13:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8866B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:15:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A6CC1A02D3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:15:24 +0000 (UTC)
X-FDA: 84556206168.20.760E8CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8B05240011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:15:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7yBfzxO;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773767722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4E5wM2OhbB1x6ddzaBxm0WPbKJDLOKBQtOsj0PWvdzc=;
	b=lc3/qWX4uxOd8a2vKR8o0L1/3ZRuwEEk5N63V2bsSPKjV7mc2J7TzcSnBz1ZgmI8DUlHtb
	pzBKLmmLG8CmUJZYQbwqD2KU//vc4mJu+b55Nh70orPVpceuB/MnprvLyU8TAOBff1XRPf
	Sw7JdrLRJVZ+fu8drpYo66WBoWAp0ak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773767722; a=rsa-sha256;
	cv=none;
	b=WlaNQlnjeJFcZc1muNdA1Mar1lM4INtEJ6M4yRD5H0I22Rk/X3hZ7nSoVQ7e8ayUaGG5BY
	VlivCb2ewhhjl8qVKcoV/GPgPEL5c7JNh2ENk3MRD0I4UQdhWf6WRg2n50Qw77I8qK3jy6
	4nFZApR2ko58zEB1axk5G5v7KjNl4Ug=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7yBfzxO;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7C1360128;
	Tue, 17 Mar 2026 17:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6536CC2BCB0;
	Tue, 17 Mar 2026 17:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773767721;
	bh=LNGH6ATNSFZJFkqeWmeL04zhQgwzX7ztcGi3iYyEbjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R7yBfzxOxg0w/kBFFlEjimCfZnorLz2V68eS6pAfraBg9BPGVUjdmB04cVOeOPovT
	 OwdtbfNR+39B/8BgknTto+7sD7BRzPA+uo+soWyAJzISSCLHqx0kNRgiBU+z07rsy0
	 jbBmQvn9gJqa3Tv+2TPZNunMsb0B7wV1bo5cM/xgBxl5UvV4ect/4LU4h+kzUlSL3e
	 N3pjyf8e9AqtJlR0LQCusQHCBKG4W5kzfAU6kbNM+is0ijbkKL1rno1Ftu9v6NOcnu
	 gX55BE8jvBTQRTaIEZ83TQGJN+qyH/RJJze370XE8JkQ4AtWp0JW4O7FkQCz5kp8WS
	 4WtzcOfkWM6Bw==
Date: Tue, 17 Mar 2026 17:15:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v7 3/4] mm: huge_memory: refactor enabled_store() with
 set_global_enabled_mode()
Message-ID: <e2e420f0-0ca0-419f-9cf3-009b4d7ba204@lucifer.local>
References: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
 <20260317-thp_logs-v7-3-31eb98fa5a8b@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317-thp_logs-v7-3-31eb98fa5a8b@debian.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B05240011
X-Stat-Signature: jpdocogxsq1g4cn9fcofm4yhrob965km
X-Rspam-User: 
X-HE-Tag: 1773767722-21062
X-HE-Meta: U2FsdGVkX1/28cHJp+eiBZwV/FmqmTRWcVZgCYI1eCP4FPq4jFOKrmZ+Nc+i3P8R9XVnciduaVzn12pU+etPfVlEac3GRqJHqKWEhqUVT4+lVAFW3KXd4CnchxW24kmV1Wg1y49jf2+V3KZ8xJlGOGLl2yeNZ10EnsB1OlkEfSbmvlMFfvvEbw1rqXA+CD/I60RnnAFv94xlw0pn2IqhtyLNAe6bwAGX6wvGTWwzcT+anBdWmioS4qJd1c8TH4XM2QoBNGL7YeLXEgOKhRSjuv8C55iYX7rs7jTCMy/V52drz148BPRbVqLkXN9PMch/XvEuty70Ta/YCtqk8ESvKSUlFI7epT6kl0IOu93djTZFTVuSEHTYHSCk/rZFe3t2dgX5l8GW8q9fWjaxY4vewH7MDi3ZXFRx5nt/hAuKAsM50FMlE57kdwXz5b3Vcvn2Yz0mf8Es3OWrRE7rDpXdInrPHJhl49/zTssXB010Xau/evUleAXARNN686djHZv8sJaPVgYzgitJFvDLKNLgzEAFsLvwRetwMST0fqgLB+kd7L6Wnx0mSGl5LfdQco0IMqWfKJFRdmmJgIQWYqwtJgJUVLH82IaUYjXuUBEFQT8PJLsgPolpKYWS6go2JNDzVGzWfo+GzxDnadb9ttXqF00t0UoSHN9kG67ugrcDlED7PELonTarTZQFkVFNq2FkqeY4gziRg9n6MbcXe2NeEIdGrednslqbJQ8Dxn/4ZdqpdH4eZ+nyQnBFhxTmtjIvzdChiWb1uOzhT3CywkgFYBlCJ5yxlOTSRxyV2F8HhO5WOy4FuO+fQ265+kA/IoCmR7VRD+krneqberkAFjsBPpWGKPhyK5WDxY1dHgw+uI+wPMyctrQKppsYjs/N0GafV4Mdz/6JdNijiyLtr07gi8kuCXixKeyTkvxEHsBxcsrUDSANKGk2IMl72y45PMww618YIVl1yxz01rHK04R
 M9wqvew2
 g4BbzBrAhu5mFQswkYhYmdjiRE2JaTaenn5TuSXh59iFXTvMwq/iHBlrHQJy/6loronBGf65cCvFo3CsvXq7BlQdrA9W/gyib6KbthlkBPdD/w9IP2asvVd5tXxhNk6DWec1Q4oOocjAnd4hscDO8WvxMCdIykQdy+96D3GhGYVBkutSE7nGqpfVAYSHIIi1HDea+Hx0ry8nE8uG8g+2cHK43s1EuhFqn10UK4p2/hkc8Wam19iMDn6GPd+7N4X+n3OluFCuWjGLAB3Esukw5yYuK1fga9oH5lhVyzZMOkA04/V7JQ2soggqsHyt8rTdSYvnMhEUVeUl82Tr4UNZ44XtrAAyOToTxE75h4aL+SRTzr39X/BSuCzaLu8eNIvkKasDuX0qVY4YUT3rm4JhL6CF91L+8lXJoRpAfAwp7v6BgjdgEwPXtr6ZBRKkP5eFs/Ht9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 08:33:58AM -0700, Breno Leitao wrote:
> Refactor enabled_store() to use a new set_global_enabled_mode() helper.
> Introduce a separate enum global_enabled_mode and
> global_enabled_mode_strings[], mirroring the anon_enabled_mode
> pattern from the previous commit.
>
> A separate enum is necessary because the global THP setting does
> not support "inherit", only "always", "madvise", and "never".
> Reusing anon_enabled_mode would leave a NULL gap in the string
> array, causing sysfs_match_string() to stop early and fail to
> match entries after the gap.
>
> The helper uses the same loop pattern as set_anon_enabled_mode(),
> iterating over an array of flag bit positions and using
> test_and_set_bit()/test_and_clear_bit() to track whether the state
> actually changed.
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/huge_memory.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 48 insertions(+), 15 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index f6af90e6cf05d..b95fde5843399 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -330,30 +330,63 @@ static const char * const anon_enabled_mode_strings[] = {
>  	[ANON_ENABLED_NEVER]	= "never",
>  };
>
> +enum global_enabled_mode {
> +	GLOBAL_ENABLED_ALWAYS	= 0,
> +	GLOBAL_ENABLED_MADVISE	= 1,
> +	GLOBAL_ENABLED_NEVER	= 2,
> +};
> +
> +static const char * const global_enabled_mode_strings[] = {
> +	[GLOBAL_ENABLED_ALWAYS]		= "always",
> +	[GLOBAL_ENABLED_MADVISE]	= "madvise",
> +	[GLOBAL_ENABLED_NEVER]		= "never",
> +};
> +
> +static bool set_global_enabled_mode(enum global_enabled_mode mode)
> +{
> +	static const unsigned long thp_flags[] = {
> +		TRANSPARENT_HUGEPAGE_FLAG,
> +		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> +	};
> +	enum global_enabled_mode m;
> +	bool changed = false;
> +
> +	for (m = 0; m < ARRAY_SIZE(thp_flags); m++) {
> +		if (m == mode)
> +			changed |= !test_and_set_bit(thp_flags[m],
> +						     &transparent_hugepage_flags);
> +		else
> +			changed |= test_and_clear_bit(thp_flags[m],
> +						      &transparent_hugepage_flags);

LGTM!

> +	}
> +
> +	return changed;
> +}
> +
>  static ssize_t enabled_store(struct kobject *kobj,
>  			     struct kobj_attribute *attr,
>  			     const char *buf, size_t count)
>  {
> -	ssize_t ret = count;
> +	int mode;
>
> -	if (sysfs_streq(buf, "always")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
> -	} else if (sysfs_streq(buf, "madvise")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -	} else if (sysfs_streq(buf, "never")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -	} else
> -		ret = -EINVAL;
> +	mode = sysfs_match_string(global_enabled_mode_strings, buf);
> +	if (mode < 0)
> +		return -EINVAL;
>
> -	if (ret > 0) {
> +	if (set_global_enabled_mode(mode)) {
>  		int err = start_stop_khugepaged();
> +
>  		if (err)
> -			ret = err;
> +			return err;
> +	} else {
> +		/*
> +		 * Recalculate watermarks even when the mode didn't
> +		 * change, as the previous code always called
> +		 * start_stop_khugepaged() which does this internally.
> +		 */
> +		set_recommended_min_free_kbytes();
>  	}
> -	return ret;
> +	return count;
>  }
>
>  static struct kobj_attribute enabled_attr = __ATTR_RW(enabled);
>
> --
> 2.52.0
>

