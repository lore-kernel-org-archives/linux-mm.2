Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D47D29C50
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 18:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 236046B02AD; Mon, 19 Jan 2026 13:43:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203DA6B02B1; Mon, 19 Jan 2026 13:43:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F3A6B02B2; Mon, 19 Jan 2026 13:43:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBFE46B02AD
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:43:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3EE8C101B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:43:21 +0000 (UTC)
X-FDA: 84349586202.09.D680536
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12ECBA000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:43:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YM0Qqjqd;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768848200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1f2oPOqAYByozw+PIAV4Leo7Wp4BePrrwg2Br+G5G0g=;
	b=xOn/LB3RF23hpMHTu2fv6aJZ3Iqik+kBTUQ8RefzVUGNKguFZiPp88jzSHmhteNznUNzdq
	CRHLQdE3lZQtshAfm5JAVt1XPuDNDB33SEmH37RNTMhPQe4EWlu6+lDdTtawfTfxqdcaTn
	FR/PzjdCxwqbLEWjqTXf5rtI7Jgw89w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YM0Qqjqd;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768848200; a=rsa-sha256;
	cv=none;
	b=2FJwgJdgNYbg3yDzafk3Zd9eY0zv2titLi+wWKn1cFE17z+HvI2Ub8uoMjXiaWNr4+B2rw
	Vqlj8JENwqG0QdpmItMW1MzZdHTjw7I9jWvfZ7zO6UFmtz0VHswSA64+9HZnHLiZxsc+nX
	g2D0u0JcrR74ze8ypusnPau9t135Hxg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3975B60054;
	Mon, 19 Jan 2026 18:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF682C116C6;
	Mon, 19 Jan 2026 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768848198;
	bh=0jusXPuIwXIPjxzuxFwH6bINDFwmNsrGqBF1AyAan4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YM0QqjqdUWbm50XeI0p+NG1eLf0kzunlAOfcRNZ0NB853n0+RKvlIUwYvlshIg0+W
	 Zk3SQfmJqf89mLGzySXSdjkp+9F0et7hr7pZgBbHWzx4FMbWHAImWbAfe27haI2Fce
	 NredufFmP9X9HwEpeZbpxUfaZi7kF1xM56WGMid0jC6/4zEVdDLBXriJ6k+jZmw1IY
	 1j7yON5Qk3ZJa4NtiBder0W/z//vg4Ss6OM4tywuYtvl7lZW8T4eVoKzXwYKHxiORs
	 HyGK2e5M6HQfm11Y4SqNf21eieyjng6xKG/NVn/0xs/YcJj2ucoOlLy/LIWX2aG2nf
	 BEcLSVND6WvFQ==
Date: Mon, 19 Jan 2026 20:43:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 0/2] Make KHO Stateless
Message-ID: <aW57Pn4gj8lHoOO3@kernel.org>
References: <20260116034432.1520731-1-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116034432.1520731-1-jasonmiu@google.com>
X-Stat-Signature: c5m49xw9dgmukjyd3mb8zhn8bz9exmta
X-Rspam-User: 
X-Rspamd-Queue-Id: 12ECBA000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768848199-232797
X-HE-Meta: U2FsdGVkX1+DN6ImwQ6LKSU0W8WIpDnggJussa2/DnBcqaOAkbggbxv2/mEFsiSyVOdkWwqQV8v74tdJBjC3dEDw4HZHP7ntUvA2qZbf3RwSMLu7Mlt+82Rv1DIae24HV5IixnX3mf1QDZlyj1T0PZ5WQzdy5kBm86w4ePC5mrEF70V8LNAS7gMnDPzkUX3kr3Jsc3boP38gqe6qTrtTDV07jXrk9MaiLAd2RCuaJPTgcX0ojGDBXKVrMCm5M+JZf1zi32zaJ/x3QYK/BPNYz0xBzNJb9v9ttgBmrmssPeU+bBOBOpGh+LlogQTT0vTfaj3Ts2rwzAugYSrOWPEhjXlwLp2kHERcpLzc2ZrdTPwgDv/p7US26MQqDbIXIznkgdTFRspg02W15S4A4uZy4SGw8HszVdnRU61rpTGGHpgj8tUedAgpzmyV4LB9wTXn/Xifs+Nd1G4IBI0/TRGTq9iZGhvzDUuRo0N4ZvQ/gkO4dBTtFgCpdIpEOmoiUDxo1NYDUOpBTyhfNAkmRBhrVhrJsA3F7qCgdZuhWz72+DgY8FOYg4wIEXPBD3wbXf5jY3PtKwb7ViDBw9uUM86qEQghLBbWOjCS+NwPDPz9rmShTTcAGVEoSIqNurMoLtEeUVdSrZ/YFm0QzCYCUgCiE+Aoo8X7aIIaKb9X7OX3lJBv1r6+oR5EjSDkNWB/63fb6Q7bxawfmwLqHJZHAvCKed5RHfwgPQ8EyrMSnL+I0SmJ6f0XBMB/LkBtAiUMHVT/RXPV7N2nvd94uLfPkXE7l7I4QqJNvE+BihYkeBWxSCpGlGyVPANZVqG+HndYj185W+9rr9wPdj+8IUGS4Ip06GzYp7GLBgu5VKHEXBf6CS3Gf7wbsBPT4d4J4EqH2TdsLkIU5nV/x2GQhegiMxnoO62cBHFJHC34Dn1rY4x5EKu4g4Jh/qSP/2wlE0HVm3hCFgN2fw+l4bZR7USz5km
 NLJknMXa
 f3v2ImmE/ZOA/47Oj/SR4qXq43icEFIy3rOJFdr4myLl6TOyMjKzxRiO9vs8/i0LFjmkToeqWTSlHClz1fCS5IeC3pCOXWjI9K6HTc0jJMieRrqFM2jchoPPGC6qeiHcTL1otWiu4CLDv8SukCWEsN8dXERTvzDbNSeg1w4IuyZfSD7Dh3iuvnFmQ2hU+b8ycWjtFHTbkxmrIRYCniJ3t1rL2c/ew1UdEOl4jBJNTNlo5dJd2tI7hJIMSKU8oWWNl2CwaBdx6b3fbt6/HReQ6dz3MioGKsT880chvd5T/41fCQOs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Thu, Jan 15, 2026 at 07:44:30PM -0800, Jason Miu wrote:
> This series transitions KHO from an xarray-based metadata tracking system
> with serialization to a radix tree data structure that can be passed
> directly to the next kernel.
> 
> The key motivations for this change are to:
> - Eliminate the need for data serialization before kexec.
> - Remove the KHO finalize state.
> - Pass preservation metadata more directly to the next kernel via the FDT.
> 
> The new approach uses a radix tree to mark preserved pages. A page's
> physical address and its order are encoded into a single value. The tree
> is composed of multiple levels of page-sized tables, with leaf nodes
> being bitmaps where each set bit represents a preserved page. The
> physical address of the radix tree's root is passed in the FDT, allowing
> the next kernel to reconstruct the preserved memory map.
> 
> This series is broken down into the following patches:
> 
> 1.  kho: Adopt radix tree for preserved memory tracking:    
>     Replaces the xarray-based tracker with the new radix tree
>     implementation and increments the ABI version.
> 
> 2.  kho: Remove finalize state and clients:
>     Removes the now-obsolete kho_finalize() function and its usage
>     from client code and debugfs.
> 
> ---
> 
> Changelog since v6 [1]:
> - Fixed a potential dangling pointer in kho_radix_add_page() on allocation failure
> - Fixed a premature return in __kho_radix_walk_tree()
> - Corrected the size type in kho_preserved_memory_reserve() to match memblock_reserve()

git range-diff claims that v5, v6 and v7 are identical.

Can you please verify that it's the latest version you intended to send?
 
> [1] https://lore.kernel.org/lkml/20260115230047.1220580-1-jasonmiu@google.com/
> 
> ---
> 
> Jason Miu (2):
>   kho: Adopt radix tree for preserved memory tracking
>   kho: Remove finalize state and clients
> 
>  Documentation/admin-guide/mm/kho.rst        |  53 +-
>  Documentation/core-api/kho/abi.rst          |   6 +
>  Documentation/core-api/kho/index.rst        |  18 +-
>  include/linux/kho/abi/kexec_handover.h      | 144 +++-
>  include/linux/kho_radix_tree.h              |  70 ++
>  kernel/liveupdate/kexec_handover.c          | 695 ++++++++++----------
>  kernel/liveupdate/kexec_handover_debugfs.c  |  23 -
>  kernel/liveupdate/kexec_handover_internal.h |   3 -
>  kernel/liveupdate/luo_core.c                |  12 +-
>  kernel/liveupdate/luo_flb.c                 |   2 +-
>  tools/testing/selftests/kho/init.c          |  20 -
>  11 files changed, 573 insertions(+), 473 deletions(-)
>  create mode 100644 include/linux/kho_radix_tree.h
> 
> 
> base-commit: 9b7977f9e39b7768c70c2aa497f04e7569fd3e00
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

