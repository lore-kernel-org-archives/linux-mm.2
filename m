Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076EACF9C40
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 16:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583D96B0028; Thu, 20 Nov 2025 11:21:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C446B00B1; Thu, 20 Nov 2025 11:21:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471AE6B00B2; Thu, 20 Nov 2025 11:21:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 32DE46B0028
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:21:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7FB812EEB5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:21:58 +0000 (UTC)
X-FDA: 84131501916.12.38BC390
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0EA321C0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:21:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YiLNKzrL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763655717; a=rsa-sha256;
	cv=none;
	b=KLGEh1YfCikSlxujCxcfalky5KJ1sUeHqR66PJzQuGRYj4FBb3pjwx20f7/ieJFaYTasdA
	sRmkv0ItOEY1YSYEKBmlT/zv8U2and4dEqolZUIXERyt/+AmKnjQS3Ea4sfIRsM5xC6TD/
	+DCjwCySZPmsCbXrbSgm8iHAfzHMszE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YiLNKzrL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763655717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPhklqFTkvPhAiUk4xe8wPf+zcMb+rfWX/qb94drxV4=;
	b=ma7d7GCSUCvvtH+yAhUQEo+dO8kHqrRsQTXY96ESl2+S5b1HfhinqikIga51hpV0pg6Wf9
	XQLMNpD//XF91lHO+55mvLV+BH+xA1Ti5vE7e5pt8YWsn3+PyqbUzzDA/tlFMP29kJnl7/
	BpwN39s75ErI2aXZiwogmEBx8WWQJyI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CEFA14167E;
	Thu, 20 Nov 2025 16:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97884C4CEF1;
	Thu, 20 Nov 2025 16:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763655715;
	bh=NZKGOfpHm1+oI2EFNHX4s7/pBTvqhugD71XFSvGZD1A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YiLNKzrLmFvvyKW12ItCD0e9K8K/Bt/UXrcOtHd4kC5Rn5L2X+jvujiPQWWfLuSag
	 wYOdQxeQgrA6o3riKZyzaLVi1WGOD6j/AswJ9H0Fmr4uFm/bBij2aJ6+jF7nUXJACI
	 Ddb5YTxdvpmmat72DvvbiUfCrmoL+cOpaLqxDCMQvkvK//QNAOymY0SJ/gWntdw2jI
	 KJ1h0KoIBCMLX/2RXZlHyCxsrQosgqMHx9HwWnItExwZtPXlVRhzhYCsnCs0Yb/xmp
	 FGxqBeSdI2pJf2F3OpzcMiyrUaN76KscFGrSS16j4WvLB4ZDqGV5iA1G2+zLDtN6M2
	 mK1Wjr6+5c5mA==
Message-ID: <779100ad-a012-49ab-b2ba-b67335947481@kernel.org>
Date: Thu, 20 Nov 2025 17:21:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fixup: mm/huge_memory.c: introduce
 folio_split_unmapped
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251120134232.3588203-1-balbirs@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120134232.3588203-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0EA321C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: 5pgrhnpinb9whf3y1exynyqynbmqi9q8
X-Rspam-User: 
X-HE-Tag: 1763655716-499802
X-HE-Meta: U2FsdGVkX19Hl4bur78uFajvkZiHC2kyhQoIjlxz3rXabHaRwL9Gwa9MienP1lJfYHneWsEI+aRSdXko/NLdTDp7eC3f36YUqSVHHqzYXT2yRrN3QB6b+tPgDWb3ZMKltMi+GDr+SvHGLI3nndaAAQWLGX/lY04fl7Qq2nVJkc8+UJGhSTxpL8Bm8UUJwI2MfVXxrR0uH9KoXz8WV8ij44199imfHAGqBlswG0k1ZbwFyIF7T6ZIR8Om3YkaslDbydC2pprD13EMeomDKQpRXqR+ccqBaTPV8EmO82Ga3GCB86Iq0a6WNCtllzeCbt+CkZcic5ABEGlQiA7jrvLr2f0OQqS13e5dvc7jR40vcmlrix2Dcut+/RJP6UN9rY8rTriN7vmOqOSrlcNPJEgV5Om0GqqkdmSS02dGjDN4ho8n79prRN32c4jTK27FXnUnbOERLftLY0rPK+tIiKYc/yJiCld8P2Fs+CN1on04z+B7ghWOJGbSC7KN+xNCyxNtGqgw0eVJqoOsfyI6SzH+kxYaBW+ljlAoJ7vadkZiP77Dp7zlppsyW8tSpJg0kDeJwqSaGkTuwvucIO65/8+HKHmV4izIHZVRqwfqGO09xA5vKlBdjwtbJ9bQuMp2g9oNgWtOhTq8E6WP9+auXkkuTllKdeubJ/O8Klr8YbjJZJpkyn7kNWRrklCVuqAwYc6/ujnTK2WtLPzKgZhBtLyf1RKClxToxp90iAwZ71P7FsxY0A7wLh5ho2DFDLsBqMNn6SpjfXmAF1j1TrmKohtjYzNg6YsnMWh5UZHSvswbFKH+ylsC5UwDqddpLD37eH2H13Tcj0BaY4nB/27F+XES2ZZZlZp4Wv/qoktAvztlgGuOS3doZW4wa5kyK1wyfvy5bpJsU/6NQQfIoozBMsnIFR4D9NY12RemK6k15QTtwC6FeTxluOzjEArNuHMsNN8HVabF3wWGARMTnaX/HAH
 JHIfcNfh
 E5g1kg3Xmyz8F6xFBgT2qZfTDNLsNqfOgBzAhUMHe+IzGqrdVH/SmU8hYRGYks/TUIxQiowIH2z93mZuBAq9QiKNSuwiRSvo8hlmB5gbv0rfMMhGFXCm6ku8g4BmCs/MMQTGsWsnl5WiKJnu/BI/Evqgy5m2RB5lSq4driA55TZ1kQXrxvj4V0stGiW6XXxCxJrRsYuDrHl6Ye6AtEl9bIR77PBG634kmr8He29LnLyexY+J6LaitYmK1m7aqhvS4OeQS/VbKwSPYYVKTDBB68Kn33oLdS3nbtli6y6IIUbzudeWyxmSXsVO/T2CnHI3IDMegp9dtMjHHU45TkofIO5bVeW7wahV5n0JsM6K8C+14GaLhNqxyZAOAvil4DHuvk5xDC1rpEztm4yeMeTsEB/CLjBxtHlts50yWWE0p3382vKGwohOLL+Z6pzPg/xyaMmrWSzsQ0ZuMTwIiV0Zz5Lw9Il65PlHz7Exv2VUK4dBPb2i4S4R3F7ZaR78XB5il0yk85a5ftkqnieuoffm6TrmobuYKdb2etEM1HP4h0VuBSQFFwVQ8bRnTjPRYNAgBbLZQON5V73H9qI6/Sd5oQBWT+mnkZ1A4fGpgcT8KE6F6UY6Q+6/RGmRBVJ9xK3ZUtdxukHIVkFJ9HqSkJSuyeK2bOdCzgBlUcuruPI4SyBSqYR+raL75t5pRAiy9cNby17n4hjFBo5eIINq062b8TogrubXhW/pf6xkPuismu/oyLcee2r6vONgGy+UpEkpTVoTYjJLbPGZeKL9YTftCnSMX1CP51Qh3qOu1h+Bl6fRYDxM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 14:42, Balbir Singh wrote:
> Code refactoring of __folio_split() via helper
> __folio_freeze_and_split_unmapped() caused a regression with clang-20
> with CONFIG_SHMEM=n, the compiler was not able to optimize away the
> call to shmem_uncharge() due to changes in nr_shmem_dropped.
> Fix this by adding a stub function for shmem_uncharge when
> CONFIG_SHMEM is not defined.
> 
> smatch also complained about parameter end being used without
> initialization, which is a false positive, but keep the tool happy
> by sending in initialized parameters. end is initialized to 0.
> smatch still complains about mapping being NULL and nr_shmem_dropped
> may not be 0, but that is not true prior to or after the changes.
> 
> Add detailed documentation comments for folio_split_unmapped()
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
> This fixup should be squashed into the patch "mm/huge_memory.c:
> introduce folio_split_unmapped" in mm/mm-unstable
> 
>   include/linux/shmem_fs.h |  6 +++++-
>   mm/huge_memory.c         | 30 +++++++++++++++++++++---------
>   2 files changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 5b368f9549d6..7a412dd6eb4f 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -136,11 +136,16 @@ static inline bool shmem_hpage_pmd_enabled(void)
>   
>   #ifdef CONFIG_SHMEM
>   extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
> +extern void shmem_uncharge(struct inode *inode, long pages);

I forgot to add, we drop the "extern" on functions whenever we move them.

>   #else
>   static inline unsigned long shmem_swap_usage(struct vm_area_struct *vma)
>   {
>   	return 0;
>   }
> +
> +static void shmem_uncharge(struct inode *inode, long pages)

"static inline void" should resolve the compilation issue.



-- 
Cheers

David

