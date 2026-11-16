Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94484606A336
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tn81L3WM
Received: by kanga.kvack.org (Postfix)
	id A8CA26B05CD; Mon, 16 Nov 2026 08:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64C26B05CE; Mon, 16 Nov 2026 08:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B496B05CF; Mon, 16 Nov 2026 08:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D50B6B05CD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:00:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 281CEA0329
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:00:29 +0000 (UTC)
X-FDA: 85440990978.20.1362C24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8326F80005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:00:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tn81L3WM;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794834027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5R7blodr4KyIr57H0lgE0jfeLfnu8xOhBhiMifpgVk=;
	b=6N4lD+uK7/RoOaotkaFPwYfNtsBk4inaL/iU3Lb+0rMnHDtgYmRMP9VoCWfcxx5MBVDPwE
	Hw3u9uk37rF9YAPYNeiSdosX0pl/te3V6YaZMAsGCLjDDQPWZFoMhLDKZ1Y1AGKVSUCHWZ
	3DBxNVt8One/AxTnzvsSYS6jKBgpewM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794834027;
	b=PbF+DWiDsbBvWEDWcO5nZxcDpI8tTBGc2tCsA5ksDlBspntlBfvCzgI+1BoEU5zIUshb7s
	oSfZfAdsG9kxqeNwgiDMiPgyKlsMteHYKWqSU+rvxwdU7psxj8GxHdLV6cUHyFaWddsbEC
	YpznZz/2lFENlVbuT82QBN4e3c7qdcw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tn81L3WM;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB592625A7;
	Mon, 16 Nov 2026 13:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373501F000C4;
	Mon, 16 Nov 2026 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794834026;
	bh=y5R7blodr4KyIr57H0lgE0jfeLfnu8xOhBhiMifpgVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tn81L3WMTmVSVrFkStoUKS1eJlHCrwqf92DxGJzeE2QnNqJMBbbVy0Xjxt/pr1NlT
	 CC8inPJD0LToR+NrQVsp4zf7dInOG6i2QM2boXgjJrRapJHocK3+y96JvGlfrph2/w
	 VXKZJNkxdWHXEYeGBcIoe7vawFNBAvw9sSR3HQWmuqHqve768kdXbPrsGZA0puqQ/U
	 yuS8sDgebbsOqC3RdflJEQf0pctSVBEO2uDerS+IZULL8JNTLEPvROidufB+eCHmzL
	 yMXMkEn0k8odvkMvxrOrO/2iUiNR4AFj1hQ8PmnBp98gNt5wQCNSqKvRpPec6xzXUA
	 Lqp/ok8GxpgoA==
Date: Mon, 16 Nov 2026 15:00:14 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Linus Walleij <linusw@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Nicholas Piggin <npiggin@gmail.com>, Nishanth Menon <nm@ti.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v3 10/10] mm: print pte in __print_bad_page_map_pgtable()
Message-ID: <avr-Xjdqrb8Ja1E1@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-11-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116124832.662455-11-arnd@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3sxm1u9y4mqo3g7zb7y3hn659jxwmoyg
X-Rspamd-Queue-Id: 8326F80005
X-Rspam-User: 
X-HE-Tag: 1794834027-606892
X-HE-Meta: U2FsdGVkX19NtKoNjSLvVxZ57oTcskN4DhqG8KEeLYrkC0hv9GM7m7C4/Gv/4gqwuMABPROlXWzpSd3p+0tEXY1fFT5zW3FzP8rbPxAi3eXqjf3ks/HDCqFkKsNasO6qvuuiUBWTRPvtx8+h9zi1KmciUT1T/8o/NK8P7Yj6GVHDagc5GM1KEwRDrIiMMURVpZ+KPbEykiJO8hqQbNSEJ/A4BGMlUyFxOfeTqHYJRetKFHUTQl2q97QN1ktlWPyeF5iVbZ1vZMRGti4BzHV3+taPNSlFnEmnaN+NAzv9oxbRi90ckbAcCUTzlrJyMLb0sKB/bmexYcQ7RCnjfQ9rOqIN3c+vvfhLXS70ySicLNtSPs5ZbpxorkDhazQrLsX8m8rXLCMFOrD7WaNBkaUg6t3WiFs0jEj1yhJoCuTxiyCl3dpZYK19qASmy5Pf2n3ldXzMbSFNthRf2CoWeaPVFgIppYArfVwmjBscRfWase5Gc+fmEcTc+0MoBEOmMIEZRiRSJerQ1oqsTruMYW9wrPHQCm29khCT8pe36Uo1yxbTi0vN9ESXptm0xZpu7YO1eWbYTm4FT5uGbY4iaYO1k2H93VlABZXDZwY3gVBMQNFKgxPiXnNWjFo36Zz0I3Pa9/ShvWKi9nISnx09LYd+Zpd37KS8kh6lMT7jTgZvmTKd3HOZkIx0pfOrxaETKPu9Ca5q5nDJZnr2uq2TUzCcsBGJpR9IJvLNVv22OIdqzLwozqZEl9PVHjGjSSM1wwJIy10bS5cnE0PMLXPtdf7h1tohtDcd0xfIk8j78qswOeLJVv6RleurHVip3lIYqgNrMpNAtiwh67hn1/sPBVoB8ov9LN7bc9WHqeNhpTGstJztiR85qUh9AxaDgUH4d7CvRAoKPRkptIct5ZYiZ2spnMo+e3vfhiz3IUpj1WDaca++ZaGrdKDLfm8+g6SIoUYla7f9rvrAgImmeEE2DmP
 n4HWrJKD
 qRn7io5fT8X6kUfGxw8achEWet54n9vHH3dnea0cqyWaeD6UwBuqcpa9vtG6fUsJ5xTduEd/j2ruuKnPSfH9WfG1NXl8biszR/hBkHmdh3vlz38UjU7l7NHcf4Zk1bYpVWot5tNPm1NziQOBpMmWsvkCsoz6bS5Q03PepR8FZWkol3dDSu+s7u2NzDRshcmdyX/zGYrRGtQlgdYNDJ8WUeU20jT3DVBgu4+Ax5u9Alu8fIpWc8YeXMOj2fp0IpoGbnFTd3blUxCkY58GMFIj+zg0QwtnsTF3Ur6TQUHOK0+SJnMPA0srTiAf0b7p5VWO7YeDOYZQuuCP18vk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 01:48:32PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> HIGHPTE support is gone now, so it's easy enough to print the
> PTE here along with the upper level entries.
> 
> Acked-by: "David Hildenbrand (Arm)" <david@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/memory.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)

-- 
Sincerely yours,
Mike.

