Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE21CC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44D16B0166; Tue, 18 Aug 2026 05:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE326B078E; Tue, 18 Aug 2026 05:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABCFD6B083A; Tue, 18 Aug 2026 05:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4AA6B0166
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:22:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 319301C1D9E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:22:52 +0000 (UTC)
X-FDA: 85113850584.29.63EB0B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 949FF40007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:22:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJgKSacZ;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787044970;
	b=2lj/Wh6rQVxhkoK3AIDGjeRLD+a0FpIYM5w5JnMzd+jlj4FOtCToC4lZbFjP/pD8d6bqtU
	lM3mOK+/dmWTiRIX1fmCortuVcjb46RLchF0CCBxuU5BSSxubRkTGDIc3N0Ms/PoxXg7tD
	K/ZofQeSKpu8yid/4ClEx8rxCZoyhp8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJgKSacZ;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787044970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQvGa6ZjyoTwZCrb1Ok01OaL8kRa0yVIIGAgWCHVewI=;
	b=vo20w5NeL0B9WjFPmEf1rwoouD7NTvJLfmogz3QUI6SEHkeXzhcwooXz0AYS/caIKe0Zaw
	D4HxkmIS4kimZr80NCcqnIaftGdZjaSehAYfWCKIGMqiJpPNiMuWcy2zbeGswY/bJhwb4p
	0ZolGeW6spcasyRcEX1OL2d/M/A6syY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17298601FB;
	Tue, 18 Aug 2026 09:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A749D1F000E9;
	Tue, 18 Aug 2026 09:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787044969;
	bh=sQvGa6ZjyoTwZCrb1Ok01OaL8kRa0yVIIGAgWCHVewI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jJgKSacZmyMJRg84QdWZgRC62LCAxaO/rnF9eHQGMSJ88n1IM1WLMFf4J51IGr9lQ
	 E2LUJXliQM6Iheuwc0/rioY6Om+VAy2pFUAcc+uYifbrKm591z3AUq/U6nDMQiUViv
	 /FjHFwJ0j34cUXXlClk/0QuIxsLrc3hNLTC5BcOJmPXDVrbs0Yfp40tcdPdZ1UAstK
	 epkHfHu8iO3BT/pqPP9kHF1ZFGiioTeE6EcRVDXnRYk4K2LkqN7sGUUCAYq9l74Oad
	 Pft/WEV9dT9LvmsF8qioDeV4MpHuYRHbRqzCNseUiHxoGjYZiV1vv9ktpFJi152BMV
	 hfolP9T7D7YiQ==
Date: Tue, 18 Aug 2026 10:22:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 02/19] selftests/mm: skip collapse_compound_extreme()
 where the PMD is too large
Message-ID: <aoQi1sHTO_mIQVFx@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-3-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-3-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 949FF40007
X-Stat-Signature: idh6bpnn1765uztmbf9w46yabr3m57em
X-HE-Tag: 1787044970-880483
X-HE-Meta: U2FsdGVkX195UHx/aCJ+8/SDDkR83YJLue0xGvyoYOWoFtQWAmEW9Jf5FzvRDZk48SE35WKMay227NSEVncJzUkf/F5QlpXKDPft3HOaC0XwYX8phk1LEZL3Ocv0QFxWUA0UkrRj3TZdCiZMoWmBD2dfADG9bLGqtH4a6XIXE3UJCd44w26aro7lefxB+H/ZDdblcfxQY3CO9DKAJFFIpujUF3NFWmwaPXrHYCJHC6Nl/d++OwsJ9bPasycBfGs3VbhFDgf+zsVJR3flf2NWEVmoSpVEjzRPlTT1Wcgx5h85D4vudX5BAqhZnmkdJIjoOgr49X2Do6Uir+lFZAYigDSJKJkh5rup+DK4I18C21KDL9EfQXkr1b+UzYntoJpTQnKBur4ACKvXfEtQR067UfiEKt7D9Rc2vOMmQnprhr/qUO+7tToUxKs0nD6+LGXtqmXc0TJw2bB9RNxdMTnqXrQOkZQZtrm4apAsGgrjtZq+Ue5ux+NVF3Vj9XZUpt4uJwE55vgSj3pDIrLFH6Li8c56TO3pRsSZhqCD+pWjx8H45WhFSVKB1SyJLmKltQfg7xId3BvwZLyPvrtOzhfTZtOI+/eK1ESqXB1ajdLxWhvmut5dnyndf0iWZAkAhwXeyeamWI1/gmXrXGk0l3Yvikn9uLIN6RImyV8l/enV4I0rKJGx0SiMP/7jF4FNwE7Tnw8BQYx+Z6qhAw9RAaAuJH5ZBDK/SHW4KNw6hDk7pHiuqC1FqBjPuuHQh05FlGUKH7gMHMeMAe8spr9JTE9SpV2zqi7cPv0kB3j92VyKx4jLUDtmZNzpJsTz+o4SfpkJqda8gbZ/BysuwX1vguAm2hppiade0aQUOuSwgqH5Fi8FpQsj3A3NORP1aT1TVW78obdxINgfmyEYobvTmEg9YbqugmYKHE21K52gGaSc9mkbyy24g9CoDatEXO4BIYYhiJ6R/6Y6q+FPBLe2VAK
 j584JKJx
 Lo5tAdxlK8QwEOWJ3TDcw+6kF26fDgHZJnx259oIXsgH75+R68zekI5rlsfNbs7LJkMAfQeRSgYR62qFIecOfLFR6HVpB0msibURkLNOQvyor7CulHaRXo/i+iRAFCkHM3noo2Ool6D+KAuQw3W81bnNv1fmxvpAIfrXZjqZosngBREFfeYS9HK2mLm/3xVKNW0kOG7qOjg/Xu9PPEdMTPwF7cLo6Csml2yRnn6n3Ffm/HBICG4J6rjFGijR3aVsYCW0rzJDAE1rJjrMDSNn0yjObt1OsSNJx0OGG9xj9SFSbvFwXo5BtM3gzvncCD6fVBOgsLam5Bt9yMvVEumbEuEij3ziUmpKkcWnTzGHxHYUnnbUqeYYsyu6+OvbNDlyK1Lq7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:44AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> collapse_compound_extreme() builds a PTE table full of distinct PTE-mapped
> compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
> therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
> at a 2M PMD (4K base pages) or a 32M one (16K).  A 512M PMD -- arm64 with
> 64K base pages -- makes each of those an order-13 allocation, which the
> allocator cannot reliably hand out even once, let alone 8192 times.
>
> The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
> whole binary stops and every case after it is lost.
>
> Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
> still cover PMD-order collapse on those configurations, and 4K and 16K
> PMDs are unaffected.
>
> Assisted-by: Claude-Code:claude-opus-5
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Ah yeah again we are hit with the consequences of assumptions around PMD
size which do not apply for 64 KiB page size :)

Seems sensible to me so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 6cfec2b940ac..dd924edd8557 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -940,6 +940,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
>  	void *p;
>  	int i;
>
> +	/*
> +	 * The test needs hpage_pmd_nr PMD-order allocations, which is likely to
> +	 * fail for large PMD sizes.  Skip if the PMD size is over 32M.
> +	 */
> +	if (hpage_pmd_size > (32UL << 20)) {
> +		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
> +				      __func__);
> +		return;
> +	}
> +
>  	p = ops->setup_area(1);
>  	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
>  	for (i = 0; i < hpage_pmd_nr; i++) {
> --
> 2.54.0
>

--
Cheers, Lorenzo

