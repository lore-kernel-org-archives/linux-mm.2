Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DF110BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536426B0005; Fri, 27 Mar 2026 03:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50E4B6B0099; Fri, 27 Mar 2026 03:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A7E6B009B; Fri, 27 Mar 2026 03:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 339546B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:29:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE48F160FDD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:29:29 +0000 (UTC)
X-FDA: 84591017658.09.E71CC55
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1C52112000C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:29:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ox3nCwo8;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ox3nCwo8;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774596568; a=rsa-sha256;
	cv=none;
	b=IdTWkNjwOvZ01SaSSqcjHFXxkdFasI24zyS7pDj3mz2k2RLcZ7DwCSBD/SVl2A1DaGxkE+
	PoZlGFgWUfKfM0wfQKe93UYdQBR4BcVpsDTk8mLp5lcEDsXSrFBx94Q6z2x8cxzWOC85xp
	mX+zBc6Y3I+6Dzz/+1K0a7EObUCIVBU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774596568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PVUMllx9roLVYGuErAn8ZTvJWl2ucu/IWwrTH7LZxM=;
	b=4JVuT38iuM+t+Oco42v3PZXaZAaTF6S0KXvfY64Fm46PXFlwK851rHgknuO7+r5k7aw8Iq
	rs6amUMvbkGdWA02rmKQOex/VOcktwCTlRj6Fr4s2vxt+w8EBS6glTpHJDkhxvlFfiwBjR
	jSOSu5s32MVtwKTo0o9o6+HTGcpLDMM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774596565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PVUMllx9roLVYGuErAn8ZTvJWl2ucu/IWwrTH7LZxM=;
	b=ox3nCwo83xjPmHsH25jtZvfi47UYkpcpsgdfU0K+K5oldz/OcHPPSHjnn5pFX42Wls5vXc
	rNFIQR8MoOh0foEg6JFagB5C7tnJiClvkiS15v7LnC6EeNv12LdziqkhNU90QcKELv89uZ
	YGP/nfRe6E9BvTuukXmXKEdDLOc/mbQ=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Fri, 27 Mar 2026 15:29:17 +0800
Message-Id: <20260327072917.68630-1-lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-3-ziy@nvidia.com>
References: <20260327014255.2058916-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1C52112000C
X-Stat-Signature: pxizwfu6zj3178x86yrwfxky1erb88jd
X-Rspam-User: 
X-HE-Tag: 1774596567-621698
X-HE-Meta: U2FsdGVkX19iHT86Gzj13X3PLEaTNYToSKduuGvJUIVn1cRtIq7Oc8TRwW+PwwKpruAew3wTJbC/yGEULmzwy+Y0bENRkN7/ZqVAcyuMhRyJTplkUDsPcf8BcGnL5zhVL6gDk5OAOXYF+D6ehxMFudx03IXHKLtJXnkuTzQlCQVxbieTaJ5mwXdymjWcjnIfRufmBs4Pg9C2TpJjzkreWed/UUriDDl7Je5Dr+hScXa9LY2x9GlZeQihruqtwTfgFnS97+Ou9//1JKsQRh1CayYmDA8AYzqgbg+yeWbARhW5A5xl5F01r1SbA33QBkYTPAQiTkZREaGorYGmV3wamlQK63pzpB+onxS9w0CskCx+GXORfA0bFQUI7J3jlcdAAj7NkPNbaV52tYICkT3kDqylONQzK5ooiZ6jSWOch0IBgyIUbaFGGbTIWwUBgDSDQAyn4dwGXu19Bc2F7VgJdy//ZXBgNQNSB7boX4V82N7oHylsIK5vjp9OTSCl/eAlrBYgkGX/A6FK42TwuuyUsPSlA8esxFjpbVTKF5T32o4sMcRBGDkAklwEILFCiuhT3d1QOn3ipT6ohspSI/zZLyvB41VmQrT7bFfeXZkR/I+J9PZyHnBxap5npgoTJhmmRTquJwoSE9Xpe8/jCpWa0M8N8Sb5kZS2GDTiXfn8QJS1izs9gQiWvYl4xxl6gSJHilZJwmv68uiro6ZqkNXW77e3NaSaG2PkIgLfXe01VLy9fWtNxi1l6QPeOtgVu96JjAMfE6zeiAsZKkRGi7rL+TZDMMU5D11gnNyiK3mkiS6DK0A6phyrjd80SKytswi+t+yLn4qsY9L4nfb/5NScGHgQkTKMiLecQE9Mf/4AulZXHtDin9xymUZguH5ESLEhAtudNhZWwz3AfomhmWWWYee04AE57GBx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Mar 26, 2026 at 09:42:47PM -0400, Zi Yan wrote:
>collapse_file() requires FSes supporting large folio with at least
>PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>huge option turned on also sets large folio order on mapping, so the check
>also applies to shmem.
>
>While at it, replace VM_BUG_ON with returning failure values.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> mm/khugepaged.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index d06d84219e1b..45b12ffb1550 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> 	int nr_none = 0;
> 	bool is_shmem = shmem_file(file);
> 
>-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>+	/* "huge" shmem sets mapping folio order and passes the check below */
>+	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>+		return SCAN_FAIL;

Yep, for shmem inodes, if the mount has huge= enabled, inode creation
marks the mapping are large-folio capable:

	/* Don't consider 'deny' for emergencies and 'force' for testing */
	if (sbinfo->huge)
		mapping_set_large_folios(inode->i_mapping);

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

