Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D411CCD184
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 03:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 966928E0009; Tue, 14 Oct 2025 23:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF6D8E0005; Tue, 14 Oct 2025 23:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8057C8E0009; Tue, 14 Oct 2025 23:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9A28E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:42:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A42BC05C4
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:42:44 +0000 (UTC)
X-FDA: 83998951848.17.D85D1F2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 251DD2000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:42:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760499762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QjML0VPPFGfz7c0cb504sx9e4edSi9Hl8wZbuznVlxY=;
	b=0LXnJ3P4tX1K9CASEXsgkupWbcZKfcwycvCI4mPcnXMmoAVm5KU820/L+yUVBBXCUYR+5p
	Q0to2vDvnLKCbTrbZF0oLLPPfgg/dZZi70gy2YPlQBJDFiedW6ycOSVYja4YB76AT/PY5Z
	YtooC0bFU++rgZ6nuzWdalHzc2AAPwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760499762; a=rsa-sha256;
	cv=none;
	b=GMkCgJqmAaaDYC7G8DFCpQNUibPZ0qgLOY3kvRMA0osRS/na1I83avJnMjXhhk8+Wz1V5h
	LinRcnzgbNFW+s9+Jl5uy+VRUX7k662Mrv9IMEnDFX+Q4LoLKSiLq713DghTie3e8Lyjse
	/iDPmILATTF+SlMNhna7CwR1opAemoI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31CC71A32;
	Tue, 14 Oct 2025 20:42:33 -0700 (PDT)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F32783F66E;
	Tue, 14 Oct 2025 20:42:37 -0700 (PDT)
Message-ID: <934d3de7-0f46-494a-831f-d04209ea4a8f@arm.com>
Date: Wed, 15 Oct 2025 09:12:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove the BOUNCE config option
To: Huacai Chen <chenhuacai@loongson.cn>, Huacai Chen
 <chenhuacai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
 John Garry <john.g.garry@oracle.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-kernel@vger.kernel.org
References: <20251013095620.1111061-1-chenhuacai@loongson.cn>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251013095620.1111061-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 251DD2000C
X-Rspamd-Server: rspam02
X-Stat-Signature: koxh18h6njgmf9zebkgftzt8nqbh6dpe
X-HE-Tag: 1760499761-617265
X-HE-Meta: U2FsdGVkX1/3YsoRxOwOUn5eIldf/74XHgRT/upkXHQtAWpauzx2XAbPZ6JFZ5EEn+yCDfvxS7ML56BpQU/3HyUJ8H0kBOfcpdQbgUCvXOmqXLndpbv94pMlJM2V16x+kBhl7exDnCiNCoUxPHI3bniwBLCkxd8PZFI1KDfI/JsTrHpx2PSfHMQunvg2Vx31HxGShj4/9fB2WCLcszZzCA2hXWsk1LCyTOAzcvo1R1T8+lOQ53YqVGv/C4siCONWSnGPWxEWD03B4GhqN3AGGPGg4+psPfM4DPsikTNsm0qk4ullI6dVWvy2LBV6rNX5I8u1iJA4yIHfMGgVOOVe8+wsP+BY+7AymyFHHh8KNOLcu6XKR6p8UVGnEkzL4wr4xfNSqeSLHN+b8Vso2RpKRB7uMliFRxIU8ejkpZtG49TQTCU2B0vnabosZLjlgOX54H73xLgXgE1jNAwCnjSd0CAbXxVAnt6W5G5woXnsjp9swe0d14ZA8tXWxP9oYYnnFb7DQONoC2VBWcgLhMPySCsyyHVx4jFcrm5TLoCbzvZRQCi34TrD7TSmpDkAqxbiFy4tBaSQfI33M6owJJtmxNB1+qhGEIv50YbKHWR/IlTRYst2vqBKkg/sN+I5fdDm1J3gCnNgkRcoUerVAzrsBzV1C5BUlZONp8kQmHkbVxj9zdwRNM20CtkuIXrapO/R8i/mZ8Fgdk1IUZlqQEjxjQZ3T5dBYyQKNTJjhUvaB8alW9aW+YvuLEDjGdIdW2BK5+chYlG864PfZ8r7iTrzK7KNkmaH7Sb7R2ZTsiapBBwb8aGRGGOHBt6sL4R1/a2FIYEE+xJour4tqHhP9ALaA6ZYQOfXdb5hgVqRMIsJeS2YGtpZ4I/6NRExsgQCkHZ61T2sqMZ/j+e8Hgka0Wps4e69M90ZCpW+5VBG2SLgtoki1lSCnzqKU9nwz4dOI253fyAruAGMKAkkdKWDpzl
 8kURPEBT
 fMXMsaCChOzjfAc9RBBFVH3Uxhz3X6MH6OE1i3KH8zHw3UXBaOcEH7LxAEH5wl/harRspsj1Dsta+S+AKx6iwvn6dGSNXeLQLxVbxp9i8bXlWdJh2M+w+UTZMc71c1/NOj1O/e0sPLoZbKUxTDVLaFOFvWlb5p4f9iuDiwARnIY5ASXXvsr5f+eoUi/aOnz1WWzGwxtowzYUiRWtn3i1kpby+X9QbK9sQFMpB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/10/25 3:26 PM, Huacai Chen wrote:
> Commit eeadd68e2a5f6bfe0bf10 ("block: remove bounce buffering support")
> remove block/bounce.c but left the BOUNCE config option. Now this option
> has no users, so remove it.
> 
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  mm/Kconfig | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0e26f4fc8717..e47321051d76 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -695,15 +695,6 @@ config PCP_BATCH_SCALE_MAX
>  config PHYS_ADDR_T_64BIT
>  	def_bool 64BIT
>  
> -config BOUNCE
> -	bool "Enable bounce buffers"
> -	default y
> -	depends on BLOCK && MMU && HIGHMEM
> -	help
> -	  Enable bounce buffers for devices that cannot access the full range of
> -	  memory available to the CPU. Enabled by default when HIGHMEM is
> -	  selected, but you may say n to override this.
> -
>  config MMU_NOTIFIER
>  	bool
>  	select INTERVAL_TREE

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

