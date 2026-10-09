Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6771CCA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B9C6B0099; Fri,  9 Oct 2026 10:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC326B009B; Fri,  9 Oct 2026 10:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB5E6B009D; Fri,  9 Oct 2026 10:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2E946B0099
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:23:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49C63A7E3D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:23:37 +0000 (UTC)
X-FDA: 85303306074.29.2733BAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3E07E8000F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:23:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RTMGPW6R;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791555815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPximgPYOjlnCBCEig1+vZE6bEGZG5a82BOf6YtVY4o=;
	b=o8bYXQlR7WDReE6IKAyJOljisKu3wS2o3+hJbf+MyHGnp/IYm18CR/2LvNCcjSVUrot2Fs
	PMNgxpxU80XKyyxFJa4WUSJJCZf8nqv4s5ZgdwWsVME1z1QdH5huUtqTW/+QyiPkpjYfcj
	hV4J9EPGB209iJI6bwUnwbolbteTVBY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RTMGPW6R;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791555815;
	b=fYIayiNb/B3Q/Ps0byyNeXl+VRChxdMSlvKazTx6XFTNDFwQ+eaSdVF2lyfNlodWuRb8ie
	a7XoZNDNPg6ll+YwK9klyN3XWtMHCfvy8P7+Fy5bmQiqgI8Tm/RhR/PGXQH6y/wLrfrGBC
	5KwtTPrh6j9RcGOzV/l9HDOZN5bi3Ak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66CE6443E1;
	Fri,  9 Oct 2026 14:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CC31F00898;
	Fri,  9 Oct 2026 14:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791555814;
	bh=zPximgPYOjlnCBCEig1+vZE6bEGZG5a82BOf6YtVY4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RTMGPW6Rf6jdy8aKKQGd83rIgqGX9ybuYlrgS+P/krAulZaM/2lpkjFFP2wToYlIe
	 dGerEFluEqbmRf6AT4D8AzffOq/ct5j7B5d8a8Rsz1SNrdGIyccEfyxVa4bVwaQXC9
	 F6QpnOYnz9rNWD537Xt+jKrNzaBnqtG+/Iqpf8WuyI515i9qLpWKCBbFpMLeDImyZu
	 RuO4UQWVA7rwVykMRdxArVjt4GCilkbKpU7HWGRqUPoHsX4oDSjyP2S/tUIRFbNyuG
	 IjAr9yvfN5QeubvXCvPfBkmNtqjEsIIkvgnogJnXIYfUpMD2y2DZ8TWzEq4huTpPR7
	 rZI/KCsULASew==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id E84CB198003A;
	Fri,  9 Oct 2026 10:23:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Fri, 09 Oct 2026 10:23:31 -0400
X-ME-Sender: <xms:3vjIak5OfMatuMjarmix0UGXN9ymKCh7KNBSxpIeGyRvRDbxPYUFaQ>
    <xme:3vjIajlLi65LZnGk3miWEo-WjVfhYvQPK5SxsxT1FTkhW6pZHoYYtuHKhgoTQYG24
    Eqcm9vDXImwPiVjahIUJQjDleP4Ph8Hhdy0-Qog36u-4kLdnxACrRg>
X-ME-Received: <xmr:3vjIargk_6s28Rg8sHa_MatlAM745MGgF8lHvjBk9D429RWzwS2XtQEEJXk>
X-ME-Proxy-Cause: dmFkZTGO+g2zX1FiOhy8heZwWXTAz6Uw5TzxGJTmOuPIKGRaFAZhdrZAa5U7NDL1Brz9IB
    qzfwrM+86at4iyZba1Y1MmLORr8YwJmYmkQg/zLXkc0jHlVc8E9gxrnVvqLlQ7pOzrtq07
    Q18eInU1fNpsV0pno0Nn2WfvNFjpIc0H/FmNRVToRXNau5ypP/DrC04ygf07Al3LlsNzqP
    rYUg4t+AJ14euEZAud0Eqbty+KzUsFTLCCYsBe19xXI3axeQGkFauh20UKs0+0DYBXXfvc
    UUc0Ld2G8pWFta2rG3CBnvSHOxJwb7DC5URbyyyAQgUPdjnon9NEu31HqU4S0/g4U1sBh7
    4b6fAmlbDW0OF2ApsFt7nmRBK4DudgGVCTYx8WCa9Qthu0WDZGlcRb0PFp/pjGnlpEVddG
    3hS2xcsa+RSzRvaGsths2eiHzNr/ULe2y5+CQVGRC9RJamEJ448EE8TKOvMJRL9mGbjyLd
    XiV/u3Ha10+NkI0m+PxmCutsZ2tjzAsCxOlUQ3VKAd6aBbM2lJz/7UF6TZlAX8pLOO3vgd
    10jgXY0epXeynoieydnUPC6PtH7FV3/b9mL/2IE6HHHTlqSILETiYoJYQC9kD/8EWV9FZb
    xtOEnu1G+eMtCGPu161eqRouSKMyyb04lmLLuybaDHmEjl0hShtDiIDWIkNg
X-ME-Proxy: <xmx:3vjIahjVsBtyc936QCJzoCo7GG3N8WYZea2VQim_Bq9sfVojVVwqgw>
    <xmx:3vjIavV3kR7ZYZBaFT6UKjVJq1KDzi7goKo7pmS0iRFcMqMIKCpLqg>
    <xmx:3vjIav17DzBbrYPRTwErbq6gHDEkMjcvQqQtENqeQacN8CwVB8LcOA>
    <xmx:3vjIahRpFhGjxziaVH8O-4n2ZWNYv_9RcNNWpINFxGPRjAL-C-KWGA>
    <xmx:3vjIasDRvBq0p7trqMof6sH5LYJwF8dj_zIxSyPSo6cqmtjjcIDHHsM2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 10:23:25 -0400 (EDT)
Date: Fri, 9 Oct 2026 15:23:24 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v5 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Message-ID: <asj4dT2Q__SlKhgr@thinkstation>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
 <20261009-fix_hpage_macro-v5-2-54378ae45add@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009-fix_hpage_macro-v5-2-54378ae45add@arm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3E07E8000F
X-Rspam-User: 
X-Stat-Signature: oy36f57kwm4jip5n53ymwerrpeyhchs3
X-HE-Tag: 1791555815-793659
X-HE-Meta: U2FsdGVkX18uhbvrXvYxATtwn/nZzf9SMeERvb3Og0osdyB9mIhK4mIPllgFCiJp8/AYkyGk7g1nqP2IBy4a7ZLPSnbuL95ZvxB2IleLgn5Z3WKX3+5FPOFH8QPlOChN2jIdD60ChBvvIgfj7WZo0zi6E5K22RMSiuQ0pUj6BED5E1hhYv7qfW/uEFf+8MsfLA4eMLZT4Y3SLXvVTGEIHXyNFZEZa1VlEK2P64nnpZLAR1o8cTZLURancQkK4V9tibMOAyt8RpIt1ulOunT0t7rYzL4IcAsAh4imgQHQFDPmHVtetgrS6zSJyRPGiBmOkZY8qKWVlNCtxvleH/4sb7M8WHc6vEWfEf90rXRH98fBkV8Ebj4Lh+LIDdxn/cgTkJR1JEJKrI154jgFV576iYDvlmxSomuHYxTuaFp1UpzD0r5Ywu6fnXRRGHsGj6fLgPuHkT8F8ng/DZBMEwA4aidagWgdaBWr+sL7oe+0ImVAgmMMU3WyxUG64X5wfu4HapgFTgcSjNYfT5tcmE4a7vpQw77qpUiMQYf5SCRHSXp9Mk2PzpS/6wWuUCy2iDHyLfI4hPJt+paO42IApVNBaKUJyf0qM1De8CxvHT12XKtAPbcNQgfH/YB4bqaGMlZjgysTqhbggEKJmP7z+MMCNvQ3zbMEyMIkscQTsVaBG2sBcDFp+ZCCYP2LxC38uMvpgktusIZt8+4CUmKTLhHiKfL5LDydiBEWWbzmaatuXn7Qf7AGkoXYefjqAlkNo36583TTfnS4l7S+LKNlsnjQTaN0i8fKOa6q1exxhFp4anqY2w6T/P85ICcrgLxs3hOm3wmgmcYdZ/IITevM78Qxnp+W01F4u/hqWfVa30HraiQqRs9ZRFH9Cp+k9xYTTBioHZg9/wU+jcVy+njVOW5AqSQiVTQfG03st4uVTXA3juaHwKSExH1zLwKNxU2tsJDKHhaOQzkyWd03pVxmwer
 yyo/t6zZ
 aClfUwecYR7z2vcY7sLs0CzK42lFIS3qncOhDzfNrrQpyZpuq0KyQafhHAA7/jlwV+q5rmS+oyY3Fh2ruqXrcX4zlt06Syh9n02vvzcxuyYHlOEsRRNKDqRZWidYFMt6HSqkJV0l/PM777QyziNNLZZS8ojLek/FYQEVl5DY3FyiFPzMQMlLF3Z21XCE706O/xppGjj4NgStYVu3VDRxKayDzBsi1DUtcW7999CZ6XJNJmxprHJ4ufBOR8LL58D6J6IWWktrexZ4KapDqHjk7Dn/bA9qZzL4cqdF6Iy13Ua12Z747XwjgGJyIehGNYT8AGTKo6IQLuib/dgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 02:27:33AM +0100, Yeoreum Yun wrote:
> +uint64_t pmd_pshift(void)
> +{
> +	if (__pmd_pshift != -1ull)
> +		return __pmd_pshift;
> +
> +	if (__pmd_psize != -1ull)
> +		__pmd_psize = pmd_psize();

Sashiko pointed that this check is inverted.

> +
> +	__pmd_pshift = (__pmd_psize > 0) ? ffsl(__pmd_psize) - 1 : 0;
> +
> +	return __pmd_pshift;
>  }

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

