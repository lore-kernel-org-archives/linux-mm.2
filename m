Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB09606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 22:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9Z7Tk6M
Received: by kanga.kvack.org (Postfix)
	id 848596B05B4; Tue,  3 Nov 2026 17:20:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F966B05B5; Tue,  3 Nov 2026 17:20:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C566B05B6; Tue,  3 Nov 2026 17:20:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5219A6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:20:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09DED120592
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:20:58 +0000 (UTC)
X-FDA: 85395228996.12.1081424
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0968D80003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:20:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9Z7Tk6M;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793744456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DioWKyZtof8KJY3u5hRocSQmXCirKUnb69cOhN5750=;
	b=3pg0PZNtZVkDh2oWOxQh73HyV6KqiU68c1fH2Xyjs7AKTO2I0lGEmM4UVDK4+cPAEB1tvX
	TPQrTDOrplgMvwt2Agp4SY9tIpVcViGpGtjK1wF7HcYpXlq5W6WtAGnJ/zTqACSCQY4Ogx
	XXFgOzAn/CU1Vm51UhO5bg9tMCrYio0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B9Z7Tk6M;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793744456;
	b=dHLx5Jic+6qmh7KTbKwJ1SSLX1rf/hqTJZGUUAEwsVrUmkrpyJ3Wg07iAsC00D988UKpww
	71IAbJFy4i10ZM3WK0v+df+0NbrjojsTst88yZomC2AxK+UQD1YU5mIW53kl1h28xYUEb/
	YVJEgXOjRMVDaMifMIHZda/JPp+Veyk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 076B043FD4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA571F00A25
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793744454;
	bh=0DioWKyZtof8KJY3u5hRocSQmXCirKUnb69cOhN5750=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B9Z7Tk6M8a1OnGBzavM6o8P2PpHrNEh9cQCJhfFmTLWL58Un7R4NzGEwi3X+PrlHz
	 Oxqja7sq53wlZ/s9Cm9KofdWDGHIduOIs0lwLCMWI46efAM0qMrtWwE2/lNPO9lO21
	 FwS1L1QL3k8tEFGFEOd+covhuzxHcZa0C+VlcXSEuNSIABejPGdVv8XuD9QKabP46i
	 iyR6CmJyvgdKtrtlGAGJbVaV96j+J+QMMfSYglrbimcoMpf6kaLHaxQDlczxFXS1pr
	 bXHFIfNWPJwG/FC4l55ljGyOQl5BBSxneZGW0r7/RM5xlQz6BSvEvMiLSp7u3a2A8f
	 ZtF8LVMXRKUvQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93e6eb77f0bso11599685a.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 14:20:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBziW1+Q+2q+gNYYJ+x9L8aJVLLLd7NW4xxD4X4OnpOzwrcrZlwV+69fn8BQdVbjZO4GHiY06JAl1Q==@kvack.org
X-Gm-Message-State: APuU4Z8ctZZEh1QqiWlH2LjBiwQ9UDMm6k62wb5T2WxjnHjlWggUXtrP
	jpBoElSXTtmZbmpqLek6uNeABIzm+d/VK2bfmx+kZmnzJg7Fx2isl73flPpeiiVZWhtMJHthDF5
	o7cWAd1936pJOi1POKe8m1g1/PYkvwy8=
X-Received: by 2002:a05:620a:440f:b0:93c:bdb4:2be7 with SMTP id
 af79cd13be357-944217b305emr2192198385a.60.1793744454001; Tue, 03 Nov 2026
 14:20:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103212004.1356327-1-joannelkoong@gmail.com> <20261103212004.1356327-5-joannelkoong@gmail.com>
In-Reply-To: <20261103212004.1356327-5-joannelkoong@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 4 Nov 2026 06:20:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yLR3AgSLR00fGpqvRa+nXkbRTpKni2Rof38iOsaMiXHA@mail.gmail.com>
X-Gm-Features: AclHuK_0ZlXY3217aPNqWwll_miKX8dRy8RG_zwkgjjh4DDFyFHPebJxzKXb810
Message-ID: <CAGsJ_4yLR3AgSLR00fGpqvRa+nXkbRTpKni2Rof38iOsaMiXHA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	usama.arif@linux.dev, hannes@cmpxchg.org, kas@kernel.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wp4sqtpma8tnx7z4pdnxnkyn3su79n1p
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0968D80003
X-HE-Tag: 1793744455-29256
X-HE-Meta: U2FsdGVkX18qIdIc9fmA5bF2AFLrJIhhPATdOzKxuCsYkhsavilhyFgDR3eWHYXbXSqhJT7SpMuDB9PHkmtoekREF5SAFR3cXIke+F9q8BHMy7BHcDho9TnL6fgxlXQusewz7j/GTJ4sDVKK7OsxbLOCYbryA6fZ9VkAdZoAK8mdG8ChRonrBTp54sDCRypM1GOBTAThK/X5qBdvQKrVBX/wAF3jTHOqutFscAq+7CyYt1Ul9WIuiGs8bv3sdjVpkTWOH1x44L+bK+it5PagnNbuhS1zEa+AIUlRRIc72hlmoI3kyyZ0pwA0305ceWnHpEucyozXpgDK8qUX9sxVNY9WVYssBRcSSNAYhruP4WbNmjOvn4wkrnfZ2p6D1Am57XAbvauQg6spXt9Xb4XwEDBzL7OqYLg1HIMSfsLwCTS6CBiOuyK9IUFpW8a0lEKKHK4yarW86TFKAh6GaNJIm8pRoJXel/kAvWXEA7v23IfUO4S/6+UoyJtZB8iZOVQa8EkRipXqHCpQSGVYsSQDbrItYOFzfKlbUzXRZ/KKgszxhaHmdq0L/ptQx4rLyBE27aE7X007JSfQk4aCxYGp4DEyBvceJVh5qWarITaoXh9Iy/sh/th9ZwnDpHHzF6dRDKKyBgK51hPRM1X5GjWvrLx/HSN04l858TUb1tTde0/k7etyj48ENgFTUdxa4bvSJiVvX8Oj9WLzAcSoxMx7/HrkCW1JcUJCfozWzQnKaTpsFup/FTpib2UD9khgZdtiNTNzIpRuNkVhaBfPO7wqgqolgBZ6gMrLJrdZr406nUEykvhA8ZR86ZWob8827TSQaIfpKAIsgjG4ArftC4DBkJBQ8UwSVewEjZx/nMvYvsog5T/Os6N6p+FxShjtEtsgbiETC7PRNh7j3MfDsgQirxZPzEoAmqE4Pwt1x9eiv2niyLrlselKNWz7U3OsHGVAjzP/18UcqklX73z0Ad0
 +FfcMsm9
 0lgSJaG8FujDl7b4XFsWU8kbHGP03JGFxHZ2g2yTw5hI8vtl5+YZw+LGVeO/G9NgEEquZIVGBZRlmlP1Owrc8iog+dVUjgZIsM9Anbv1kBIFR2k0zBSCHGCfEluNfhIjVEHHb4n1R8RCwjgowRRbUz0U0MSqhxqWyXLnnEK7O+e0nGto4TQO6miXcaMaWNpZgkwl7HnrCqSNCnZy/kAcEHhk4faW+RQiK5kg4QHLs9tPI0N0tWNehEAGKrqzMVkMlIE4VKdYxWhIehvrUE9j1/9vMGdlawklcyq5LtLiI08/UbLw9aajpN3sZXCl6VcgdJOw1IG37mrfDB4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 5:20=E2=80=AFAM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
> to the deferred split list at fault or collapse time. As a result, a
> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
> the deferred split shrinker when the system is under memory pressure.
>
> At Meta we would like to deploy 2M THP=3Dalways on arm64 with 64k base
> pages, as 2M gives the contpte benefits while the PMD size (512M) is too
> big to use. Without underused splitting this causes memory regressions,
> as the unused parts of those folios can never be broken down and
> reclaimed.
>
> Add anonymous mTHP folios to the deferred split list from
> map_anon_folio_pte_nopf(), mirroring what map_anon_folio_pmd_nopf()
> already does for PMD-sized folios. This covers both the fault path and
> the khugepaged mTHP collapse path. If there is memory pressure, a
> zero-filled mTHP can then be split with its zero pages remapped to the
> shared zero page and reclaimed.
>
> Only queue mTHP folios of at least 2M for underused splitting. With
> thp_underused() scaling khugepaged/max_ptes_none to the folio size, any
> folio of order 2 or above could in principle be underused, but for small
> folios it is unlikely to be worth it. An order-2 folio on 4k base pages
> can free at most four pages and on systems that only enable small mTHP
> sizes (eg Android's order-2-only configuration) zero-filled subpages
> tend to be few and short-lived.
>
> The minimum is hard-coded rather than a knob, since admins have no good
> way of choosing it, and is a size rather than an order since what a
> split recovers depends on the folio's size in bytes, and the same order
> means very different sizes across different base page sizes. It can be
> lowered later if data shows smaller sizes are worth it. PMD-sized folios
> are exempt from the minimum in order to maintain backwards compatibility
> since on some architectures (s390, with a 1M PMD) the PMD size can be
> below 2M.
>
> To minimize overhead on the common order-0 fault path, the
> deferred_split_folio() call is guarded by an inline folio_test_large()
> check.
>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

I believe we discussed this before and agreed that a
hardcoded 2MB would be a better starting point.

Reviewed-by: Barry Song <baohua@kernel.org>

