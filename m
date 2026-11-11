Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1EA606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCOOE1SS
Received: by kanga.kvack.org (Postfix)
	id B02C96B05B2; Wed, 11 Nov 2026 08:30:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3536B05B3; Wed, 11 Nov 2026 08:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8BC6B05B4; Wed, 11 Nov 2026 08:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE0A6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:30:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14FF7802D0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:30:52 +0000 (UTC)
X-FDA: 85422923544.20.E55B138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 76A1DA000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:30:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TCOOE1SS;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794403850;
	b=ssd6RTXPro38uz8FnK+g552kDZqn8e659zivDXVsDkfWPAHGE51c8+NfD/qcpQO6GinAsv
	vYTTmyOoxb4l3WxiEGocSv2UjQaF3+DLmy24Sv9j/6wvz8vAEKniKdxoxzgdEEZEvaYX04
	MfyAD7bPUCehJONdiY4Uq+V55GuOWzE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TCOOE1SS;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794403850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+z/sJOVgAS28x/o3MBGl9WUjLHrIvvzM3O5rOwm04js=;
	b=F7N9vfPrRSJtwfVxeUPU9uLUpoYH6rfMftC4t2xhN01ivoq+l8ofyyuWWeVt30gAtxLzx9
	xNhngM+Q8fENrIo+QKhKlFdGcP9hI4aPD3oSvyY6B0+RWO/LhiiAr0l0r3mQPomeJDP7bx
	uFSqj+dGAopXKkA/7DwaZD1l11z2fSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1726C63CCA;
	Wed, 11 Nov 2026 13:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239EB1F00A05;
	Wed, 11 Nov 2026 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794403848;
	bh=+z/sJOVgAS28x/o3MBGl9WUjLHrIvvzM3O5rOwm04js=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TCOOE1SSD10QWz6ETDZQQa8vMzC3OQf7QgzVHTot3DF2mHh3BGpH6oizahN+4xoIw
	 V3tUDGYYwfQVsmabwgFAkaDuZDnkhRAzjvVniXDXC3kgP/C7x4a0UowHWVHTmh4elc
	 AprsIFNdFLJQcHPmZWalSfBqHNk4MvhSfNt4SVagQIekeLaWQy5pCgDAj7UMrU20Zu
	 D3Uik2dp3cyRA39clPl+3cwOHuo3mg24zpfiZA9hCPtZfRLRbkFMFYgHLBhHzPK50r
	 8h7ykUxGXare4jcYCCOclmSEYI00dG8SFkpKA6pvK5xfrRa5Voib2AyqIlrEpk9+7c
	 gkx+KmeMqrh+g==
Date: Wed, 11 Nov 2026 13:30:38 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, mhocko@suse.com, 
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] fs/proc/task_mmu: account device-private PMDs as
 present in smaps
Message-ID: <avRtypkg16mVSDxM@gremlin>
References: <20261111113904.650722-1-usama.arif@linux.dev>
 <20261111113904.650722-4-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111113904.650722-4-usama.arif@linux.dev>
X-Stat-Signature: e94riejtqeu8ragociqysbecygdueoga
X-Rspamd-Queue-Id: 76A1DA000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794403850-858686
X-HE-Meta: U2FsdGVkX1+osE5SRrls2vqs4wtTyKhVIN+XCX8LslF58MP6LwV1gf9Lp9gPWQEi2AbmDcCE4Du9Q4yMcS20iRJeNiVt925eyW+z32HhKXEApdlYrNGApuY5ryiR8PVBPJQUVLaAR8kNLQnC/phO04oQ+p2t/PhzoXeMShJDqQexS4mRNfOL4QPLU1sudNlOA7zMyOQpKxYED5aEqdZZdVLd+z7ldrWRWdoq4eP7fdgc03xTodQk0HHCP61sTHc7ADvOqVHmxFYrR5e3yPTMgIXKNF7bbgmtv6j2cqPxgWkwo1FOHWtKIDamyivlu4JSngJk6I+h+oOKayRsYrIaC9M8Jo7cxfBshGmbKXJRy8v1G23j5Xe5LW7NWfq3MqGf09UvYkGVEa5pKXBp2g65tOsX+hf/jGDIwl07QXWMUfDKBw8Wdmcu1LQLycQRAVwpHrcL33J71Ci5NFpGiPjuvA9/kqAZp9ZV+29bQE+bwY9b5CoZZDjtbkbL8M5xO1C9xp1xtYVZA9DzaZ1g9/Y79zQpwB8S9rRdo29Dslsw2UjQkeyXXCcySUIoT+RlpnJVG4EzgpuatnfvU4BNbc8/kXYIF9Fe1C5xPg20xrSKRdp3Xmi1CJUmB6IGar/XT1Rl1cojGzLHE8rxaycsYkajR+g3FfsUtbCZ9Xpg78MZ/ed0EGl87BNXlFryjrnZaV1/NSNjoKmJ52RvIywSDvdvC8d3rKa4BZ7kXie07V2yfoiIWNZqll1cWChAC7Lnx0QpLYWhzVGITpB0RO8iE5FZDx3DUiUlHAmgwISrpytsZtIc3dvueLc+wOprcH6tpCTd8cjzm0bXCLqCRCLMYqzPWJFrMPJsnVxOrySVRJgYLzKZXBqthT2VWarm9B4I5GZWsR/N2w5xUN5KaShCSjrJWEHVAxOkZwdTmmVPwWshyBW025ehetOx4UfjwE/NUWWWW2oZ1YOh8MZfC5ol1wr
 uHWU4IcH
 sYeI76/FDUjNaN1ZOL7twzh4DgIzVDgB7BMqEOhGFXDEsE47fB1LZczJttPoxvYyiIqjnGOFSEHSoEjYf5oe+jCul5bZVMiUEZGfV1DkGxJ3ryFjaSIWta/VEHUguIPif3NfalQRe8FPYRrS3vF/A093BaA3QAgWyfyUunQ/TtrdOULDXt3W9emIJ9YKjxduZepznsvHYcWN3snf2RGLL1rc4BjR+Kb+bn7hEoBlw7WxKMhmqtJK/Xv+JbgE7+38kfkiwkAyDxVnQxXukG889o0A3f4/v1XHvhMLpGbWTj2++q+iPG0SjgWNM8NGZZrSqymVVcOeGnVu4nD/a9TdoU3UEop/RUKyoASk/f6n8WAp/s0bCKeOiUntRLWAdSBwZvC7jhh9CCqah/BE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 03:38:31AM -0800, Usama Arif wrote:
> Device-private PMDs represent mapped pages, but smaps_pmd_entry()
> passes present=false to smaps_account(). That treats them like migration
> entries: mapcounts are ignored, PSS is charged in full, and exclusive
> mappings are accounted as shared.
>
> Match smaps_pte_entry() and mark device-private PMDs as present so
> smaps_account() uses mapcounts for PSS and private/shared accounting.
>
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

It feels like PMD level device private entries have been the source of a lot of
issues, maybe a good area to audit in general... :)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index c0d391186c2b8..ad97532fc1184 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1032,8 +1032,11 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
>  	} else if (unlikely(thp_migration_supported())) {
>  		const softleaf_t entry = softleaf_from_pmd(*pmd);
>
> -		if (softleaf_has_pfn(entry))
> +		if (softleaf_has_pfn(entry)) {
> +			if (softleaf_is_device_private(entry))
> +				present = true;
>  			page = softleaf_to_page(entry);
> +		}
>  	}
>  	if (IS_ERR_OR_NULL(page))
>  		return;
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

