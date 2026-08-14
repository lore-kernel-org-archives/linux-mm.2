Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB58C5CFDB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 13:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC38C6B030D; Fri, 14 Aug 2026 09:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B5F6B030F; Fri, 14 Aug 2026 09:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A1F6B0310; Fri, 14 Aug 2026 09:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A02596B030D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:29:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25E08A010A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:29:45 +0000 (UTC)
X-FDA: 85099957530.26.D8A7C21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 821FE100005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:29:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWdbd3WP;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786714183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbLcMLw6Z0eZ8ZkrWdwyZfJ0ZOpmixljxjK4YU8/804=;
	b=ca4QVooqkyLGlacrGGMhBTFiXc2paKPg1DZBDD34nOEPy5HmE3qcyD6YMTDdvNKHU63tdI
	wjr0xWqiTxfGAIvKbmLIxv0YHRGDlCU0cmleQZOOGE2SDpOkt/7krGNT13bv0QT5bLtlzq
	m8KRHq4IP9LFrRZfoaoLEmIlvYu2K2k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786714183;
	b=2Co0xWKxClqiKPMFTQKOcuXjRELKLu/WkN5UFKoNoVbe1BKE1BzTsB1ffxR87yL1JWyWPg
	aCjZNtK5qLZP2db7Do4jamBFyF+KUCoH1XR0vg44Jn4LEYq4+ANn5D7fgRjG1hCbyHEZzB
	VkfmBkzJb9e9OaASvOxREOl+BaQR6CU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWdbd3WP;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC59643ACF;
	Fri, 14 Aug 2026 13:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4973B1F000E9;
	Fri, 14 Aug 2026 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786714182;
	bh=NbLcMLw6Z0eZ8ZkrWdwyZfJ0ZOpmixljxjK4YU8/804=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SWdbd3WPTxPQe6MTSuiWsvo4dSbC4rHIH4u/TYOAXe98O+XeMpCT5RW0t4j1L7jAT
	 Q3IrtJoLssfC0Ip1xysQ8Gowchf2Du9S5cOrIwLMkyJ3WN02BCpj52ntDI1ox+hgEL
	 Rv5SW+Q6w3jjjglicBCq5Z1JHy/t29Um/DTTarqvkz5flHuePj1XXVJz6TBcIvoiKD
	 C2noGIybgKe+38x6G1kisvFg9rX8rWf7OCTvhiPjA0MfzspErcedVu/2HNK2yOAVO9
	 uku4SfIuvojFrqPfx/qoZxknd/CyBqjKSL0IAeFstk6Fb2GLco5tsuGWRslo1v6j3G
	 Bj2EzIW1PInBg==
Date: Fri, 14 Aug 2026 16:29:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com,
	baohua@kernel.org, dev.jain@arm.com, hughd@google.com,
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
	usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/18] selftests/mm: keep khugepaged out of the
 swapout the swap cases set up
Message-ID: <an8YOxZiXhjwEBYb@kernel.org>
References: <20260812132304.199287-1-kirill@shutemov.name>
 <20260812132304.199287-6-kirill@shutemov.name>
 <178663341429.2230969.913958776768961527.b4-review@b4>
 <an77GjsF5Qip60ql@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an77GjsF5Qip60ql@thinkstation>
X-Rspam-User: 
X-Stat-Signature: 3sijoemne4fk678x6jpyohecyqb6gm8r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 821FE100005
X-HE-Tag: 1786714183-328861
X-HE-Meta: U2FsdGVkX1/omP+c59gLrVU2YVFbGlsYeJf6MFS9drGsK1HEkJwERwp9aHa63u85R+HfKc2Jyiw1wbaufVoTPSdViptjxXPRgoVkMlmJRaOmQcK79YD6o9jGmr+eNl0l9S4rLv/OtBgfmbuAboQ+n3DjEfrn2ZPhdTqBPYqifZ/kzjwORKLsceaIh1ZRpQcwf9uglXX0eR1CMQPTROk/jbLjdYyNxCTQREw8RazQDdmUpiXRct+ta18ZlkRr7qivRsIowwKwEshx7W0CTSaCKEXXCFU4PoCfmHhMWz/DoIdw/xFnsWcdH02xyPMtzvHADIjQDZ5yUR9Z2dD/RsWZIFaLNMyNYzMLmPpb7Y1x3jQmdd7g7PmVKCrZB4v9L52VtTU8f0Z9V+kNCzajpTCnI6uzibyTVFK2BF2SF5ad4ItyEkvYKQELEofBcynD9uYDlqT9ANhBGuoZkLueCI3ihTPFi1gZLiCTBVEY2OXu3IADFJL864dVK2WF/bwblJJppwoCEPiWIG322Ge8/WmI3cF2owt/Y27BXaVEA4ch8l+PyZRMg5pnIvwx5+clAw2A4UNPG1RitZwQDE0fDP/gNjoEjI1uqWf96eH5w1PeW9C6tfSYe1tJYXb/0/tjn/eKaDkZd8g/V2PJxsGg1ho0s4Y5AG7zxfL/LUxN2vwalAgDsFgiAgxS8Ka7pND1vnspjndEGmHbNZc874rWj1G0CX3XtMZtxG+cpkAoXweAfByHY7r7/v6CGZoPzR8OXR4zTtBDUeCq/iKqNvm6FxcuRvB1NoBT7AZ9OK07ehNQcy+olJFS690RAd3U/hDkWjfbkNyFF+zw5jhUSgMs2HbXIt5Bhe2u0vrc36Xzrd7Vi2ysqC0EfrtMXzRv7rjRDLxSC2R9R8QpjTuXVMQE1MFR23MJUHloXYwloCDnEYdd8bKJGYpK/mh7CiMwocZywnLxi3g+A3J5rz61txIECto
 T2MEGh7K
 1e9swpfgECHCuUDiNO3KP8Qu4Qk5wZf6K+AL56Ck9e5Gbn7FSA3bfq0JV9dP8JuxD64aKS0rKG+kawmPEz8ekIVZdlKgQ/quoT576p9dVbKEJXzOCiLSBBmZJHMTkAXAFyOHBwJ7BwqlvBWkWay4KDVHQWIYvLqLymqe7HO2JXY2yq/UUr05fKUbW3mjZqeYDrH0+JLtxNNs/DY5RV7qO+EuQiNye6SwGbXgnIlhA44cr5auTBlBgTPZ/fJZ28v/1MjoR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 12:26:34PM +0100, Kiryl Shutsemau wrote:
> On Thu, Aug 13, 2026 at 06:03:34PM +0300, Mike Rapoport wrote:
> > This commit message broke me, I'm going to skip the remaining patches
> > for now.
> 
> Something never changes. I cannot write coherent commit messages with or
> without LLMs.

TBH, I don't remember problems reading your commit messages before LLM era.
Maybe over perfectionist x86 folks did :)
 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Sincerely yours,
Mike.

