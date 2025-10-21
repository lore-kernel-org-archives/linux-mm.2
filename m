Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8051CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 17:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09B728E0013; Tue, 21 Oct 2025 13:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B658E0002; Tue, 21 Oct 2025 13:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C328E0013; Tue, 21 Oct 2025 13:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0FE48E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:13:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 773841605EE
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:13:40 +0000 (UTC)
X-FDA: 84022768200.05.6E676B0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 11F0740014
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:13:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2Q1SsXK2
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761066818; a=rsa-sha256;
	cv=none;
	b=PG1BmoAqW6r3F2kkGOyD/xLReXn2eFH6sbNRMo3FjRq4mwMjRQlXz/JfzWoUUnq1u2/nGp
	ofFwHItQSVndeJF1nCVn5c6vzeEk023bmqabOGX6xYZJHzX7ezmzRQuCHA3YNF1aBZZ7il
	vU61gojuwlxi4zgo+N6WyDwFTGDzygY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2Q1SsXK2;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761066818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7OF7YinQtdM6zEwx9mf3VJteIbSNxF5xxDOzyp6kaY=;
	b=g0BNCg57bs1eqLu+8zsfor0X0hJt0hrOZPMuHVF0whhxQHYse/JknNzMK6sRpMfteLEfYJ
	obCotWXej3B01sGwkIwr6zucXx8EMK0pVGBvdcBAaSczbhm9DEqHYj/Q4wOXjWKYvyCN8v
	SecaYKq37t//GZ1HSEHcp6E27cgcYdQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=T7OF7YinQtdM6zEwx9mf3VJteIbSNxF5xxDOzyp6kaY=; b=2Q1SsXK2pXUN8mCnQvRcx+QhQn
	VHutmMR5Rm8NehoV2QJEip/SnFEKMiY64LR/hUPPumhePnybaugYxUzHfGHyOTx0cLGbotoYVCFO+
	9lyaG/SBzt/6AdyC0IaqifMG/VBu1VMxQL4cnSdmGLEv5ebIL4NZuRX+insIu9cdUJH+b1dnBTRaV
	g/ngxAKGwaWSaDIqSP52BljzzeAD3aihVqBuTjHlzHYldIZjI+8FkMKoKbeVVwYEWZ5Mboqi23dON
	0PhF/1OuVgk3SXof8lmqPChWNgxxrLnkYAEP0sqPbIgJb3IRxOhYKRc9Dv4GF2LUgqx3m6edVBpYg
	uGdt9VGQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBFvS-00000000CZQ-0p2N;
	Tue, 21 Oct 2025 17:13:34 +0000
Message-ID: <3ba11b0c-818f-41d5-8885-038c7e0133f5@infradead.org>
Date: Tue, 21 Oct 2025 10:13:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 20/23] mm/kconfig: make BALLOON_COMPACTION depend on
 MIGRATION
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021150040.498160-1-david@redhat.com>
 <20251021150040.498160-4-david@redhat.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251021150040.498160-4-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jxabb8amshnwfkmqdetuanijyjrnaxe8
X-Rspamd-Queue-Id: 11F0740014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761066817-176032
X-HE-Meta: U2FsdGVkX1/Hwz0IOT/CMQz05J4xa9v8MvOJglUjMSm7q5VVTm9LzMbm7G1cr0Id21VyvBGGMj5LE/1nKB+J9+3mL79Z5zxcdvqtJZLhVjPDD+r+xdLXSIQ5PQlt2PjWrAacj7F4N2prKbdtLXwnMlL9v9yYJ7qnxHENH9i3U6Srncwnlp0D2H1Am59k7bprivv0mtWrnMa1c6bjdIWj1LVb53wko4uv9UMB09TBymcg+S5SPucvxPacVDVPHJwhNqiO9Fy1T5qp3muF2qrPkOaV+FlfUJI5AUDsgyk3Te5rTA/ppWPaR5AyAvS+kJIOe5llmvK3YfGkxrGAnVLThnc5Y5HSTySYRwoq2Y2La5pclnnLx594SmgAisx6o0llG7YlurBu+nC/fLiXLBTdoGtfAgAnswC2RNuWQeLNTKqoaRMfbtJOhJ1k1UcTuqI5dF0FeTAnjToGyA5Hi/uJde8r6l/kuuu1SgmuR4IzSg/kSzV9KbVnjgSO3wUUfII8OuaV2xGCV+JeiBhQER6TMqjaCnAxmxajJfJ2sTQDfol7h3KMGWC3Hx3xXaTW1wk36CUC552jIGNJ8m/UvbyWX/nVNJx7wFTBYRLsdkWr59VFysErasVyJyAcXajkA3utBNYxS+15Cix5CJPqKWp89usXRx88NccsOU/9NPcdzD4hUBFXv72zKP9kwSSSKLTNearkN7gEEsg203FpJcv0bN9yzpPxflWCeyW+B/SXep3FLOonQ3PZyEmFBBdkFOe+b7bG9sAptMDgf8Mq3sIqh0CZXWsyq7LJerSOHru8yS24jfP3R2p+Pzp0dtm0hMrEtOZUKeaywcZAraEcT0XY0HI25wMMAHFcgCXasE/Cg4bEUof9yvwYNFOpG1vwkq9LW0SCrieivUcweoWJVsrZlEAgVDFuRwLyWIfHSimR1EuUHQljBfh32cRDkm0ih2qQ8/Cox8kfgHp37WMku4y
 0g0dE937
 JiMmN6aTRtej0ihHoqETrsZpQriLnneID+rlMs8RokYTxpaH2J8vn20KESenuVjNf1jt3uU+xUKJRMHjf6kPAZwVACSw8EYOw/HkMh/HX9p3jQansscEl1CUsiQeeTFSJGuAXLOPZClPFh37J2CmU5FDrj3epYwurOuZfTiaWcrOjybuJDxH6bNoM5togqQqwHY1+L3x46mZ1Y8/7JYCOAcfUWqm5otu1qQTayQtJc+Wwz2U+hDvTSXOh32OUDN3iaX/1vW6W+FgzetipWWscz4uRymNxR8LGpppM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/21/25 8:00 AM, David Hildenbrand wrote:
> Migration support for balloon memory depends on MIGRATION not
> COMPACTION. Compaction is simply another user of page migration.
> 
> The last dependency on compaction.c was effectively removed with
> commit 3d388584d599 ("mm: convert "movable" flag in page->mapping to a
> page flag"). Ever since, everything for handling movable_ops page
> migration resides in core migration code.
> 
> So let's change the dependency and adjust the description +
> help text.
> 
> We'll rename BALLOON_COMPACTION separately next.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/Kconfig | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e47321051d765..3aff4d05a2d8c 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -599,17 +599,14 @@ config MEMORY_BALLOON
>  #
>  # support for memory balloon compaction
>  config BALLOON_COMPACTION
> -	bool "Allow for balloon memory compaction/migration"
> +	bool "Allow for balloon memory migration"
>  	default y
> -	depends on COMPACTION && MEMORY_BALLOON
> -	help
> -	  Memory fragmentation introduced by ballooning might reduce
> -	  significantly the number of 2MB contiguous memory blocks that can be
> -	  used within a guest, thus imposing performance penalties associated
> -	  with the reduced number of transparent huge pages that could be used
> -	  by the guest workload. Allowing the compaction & migration for memory
> -	  pages enlisted as being part of memory balloon devices avoids the
> -	  scenario aforementioned and helps improving memory defragmentation.
> +	depends on MIGRATION && MEMORY_BALLOON
> +	help
> +	  Allow for migration of pages inflated in a memory balloon such that
> +	  they can be allocated from memory areas only available for movable
> +	  allocations (e.g., ZONE_MOVABLE, CMA) and such that they can get

nit:
s/get/be/

> +	  migrated for memory defragmentation purposes by memory compaction.
>  
>  #
>  # support for memory compaction

-- 
~Randy


