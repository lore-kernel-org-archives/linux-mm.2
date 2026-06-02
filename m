Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45726CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB266B00D3; Tue,  2 Jun 2026 06:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92A06B00D9; Tue,  2 Jun 2026 06:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0956B00D5; Tue,  2 Jun 2026 06:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0C76B040E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:16:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F823406C9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:16:23 +0000 (UTC)
X-FDA: 84834567846.07.252B0AF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 37EF540013
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:16:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vcKrEmxT;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lipZXDwGQU+TSrswN3nmwaJ59DceeyAWCn8ljNjUXwE=;
	b=49m2EDYhrGMizbBgqSY8/7LDW9cx8zS3ylJTdPUq0LNngSSmGO1r7CkqXOXxFCv77dGHP/
	31g075GqPvxkQC1xmkOpPhkZsd+bcIOoal9cBBTBi2KzXzM6Lbsk203AQqpI4Rhwmoqg9Q
	sOLLrBUzRXSZOoILyswU7SpAwsOGVwY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vcKrEmxT;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395381;
	b=qhnqtrPiRmY+UbcDSHzWJZzSMeEJ+zyVikL8kFUk4alzhXO9rOKHv0jqmsGDmOBxU6SDP8
	5XBKf6xg+P7BaghZ3x/XH9gqKN4NjeUfyKrQapOR19IvHuaVzum3aqNy4Zfjr3eUfcHlNu
	hNpMSYHRkvqVWRsmFfcI3F5moTL/WQ4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0ECA42364;
	Tue,  2 Jun 2026 03:16:15 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C08B3F632;
	Tue,  2 Jun 2026 03:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780395380; bh=Yq7QU8MantCBpgdcupePeTD2JsMq1DglepMcByDaSWQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vcKrEmxTE6UJVDi+9H+gc5sLUbgzmFlxuTO2mLG3hSvLZvl2SDdESLW1opU9QrusJ
	 SLtJ3H9CeI0Mnq6IYB1hvhmo7p4237sWvJgidL5ePIxqEiL8SETNmCGq4nBBTVWaJa
	 PtHtbgvO70A/9AQ3Le4QSeS6ZlH22hNoPVye1Qak=
Message-ID: <7faa8ce6-a2dd-4e6e-a47a-2a6aaf7cf136@arm.com>
Date: Tue, 2 Jun 2026 15:46:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/14] docs: tmpfs: remove implementation detail
 reference
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, baolin.wang@linux.alibaba.com,
 ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org
References: <cover.1780066530.git.luizcap@redhat.com>
 <426d01d487656dc97b6ae00717de32efb232a04d.1780066530.git.luizcap@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <426d01d487656dc97b6ae00717de32efb232a04d.1780066530.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37EF540013
X-Stat-Signature: 7yt9dw4pff31hqoqy87tofdooaxubijj
X-Rspam-User: 
X-HE-Tag: 1780395380-53321
X-HE-Meta: U2FsdGVkX1+8HU341h5rHB/FAPA4UkKKONKvomECBidc9vJwBD+SYXJhTaksSWU2llrkTjC90t98rVFUf6OJdElPwOevJmMDHAfrICg3bYA9B3YTRTC/FIYmuUEJVZFbHr1oNQjzXwYvNMnCrOCgzcamrNUpo5L/TkKWyjM6evHH96StIbnzjSqko7T2U3cnzd7aN/502sAgQbOkOOgdB+gGYvt8sbpTjW5Lq0Z9w4FDXLzyoV77xNjnvyYQo043XX0OIdiiLXMh79VVm5NMCK2VOTFdmf0o+Vvc+YJnLNcFNBVkAjB499QLpZx0AglPrh5g5IkkiWRuG/Zg92XYnLs8tnMl91Tt8SxAhBvdA83I3y7AEr8K3KFmb9SjaypmN42qstGBRgLXiEJ39beW+fWeEozwX9jMOi5bEAbpeLSfXeFStBc61iHsWhbYd3mwr/7OHyHdZAw7D+yjFWVYA2Bmgg4g7PrdqQLDwZqffZZCMFAa4nBulFT6YG+Nn6ZOd0VrZ8chl2/vHRO3mZknG6kgLxLuJWKpIqGOAH0CSYimuYdupm6hY+zwAtw6Mue5Nt9EjYk8RsyyrWCUftEq4mEbzsvsbwFUVQEqw1u59Ixhnuv9aCrh0vAYDfw7vZUqg3r0JICBPLbOkYZp+jATIAk9vPTL3WDWEi4JLExeyQFTQFwhzZbkXMEnTZ/4wTZolqZWRVjmscms+BWn3QB7jF2rdyguQnhT4q+fNXMA3LVnHxFPX7q4/RhSUXZ25QP49ut/pgtm6lN+tFZ/3cpzaeYNMWlKd+qJ5d/u6QEFIMYVQPzP8VqqYP9JM849JC1bgdsk+DVedGqi2Q1a4tiN1yr5SKLRwgJoOZXNzeItg4j72fa4d7zwSN1bCrvJ7Pmr6Bk0zevsqqvTOoDlc/ia93vNnU73olrdVvej25mc6eU54Qx0c/TglV9WzucvQJu/WoH3TXbhvk8ODkhpfAX
 W514/Fzp
 Q5BnxtCvxmPRBPtNATJmJYTv4+pDdMBbViOJs8tICoBzhWGzkswwDpsI1i2E6Gm0u7825YznSEJCycoLfmbeANH0fS0aRir1JqWrPNBAaBmbw8AFUHaw0txVAeTfwLOjh7njcmVmS+/gdWO53mK7i5PrU2heu6RdYSfKOkS+I6Zsdr7E9moHm7l/SETA+lEMSeV3WqbLRl5hfs4K3ujBV9/zfpo/eBIA4TWy/5Um5sIbYv5tAkM7WWmLRumVwyH6dx28hGWWAOVsYFSUqbdpKncneZcUY6jHwPbAjejqLkGtt+qIu90Jz3GMRHt3dkRPiU3iHANXd2JPEpzmOMCTqwb3MZ6TVCJhlAEDfYT15m3SV7uBja9EKpTqyxntFf5eQcQsC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/05/26 8:25 pm, Luiz Capitulino wrote:
> The tmpfs.rst doc references the has_transparent_hugepage() helper, which
> is an implementation detail in the kernel and not relevant for users
> wishing to properly configure THP support for tmpfs. Remove it.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  Documentation/filesystems/tmpfs.rst | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
> index d677e0428c3f..46fc986c3388 100644
> --- a/Documentation/filesystems/tmpfs.rst
> +++ b/Documentation/filesystems/tmpfs.rst
> @@ -109,9 +109,8 @@ noswap  Disables swap. Remounts must respect the original settings.
>  ======  ===========================================================
>  
>  tmpfs also supports Transparent Huge Pages which requires a kernel
> -configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge supported for
> -your system (has_transparent_hugepage(), which is architecture specific).
> -The mount options for this are:
> +configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge pages
> +supported for your system. The mount options for this are:
>  
>  ================ ==============================================================
>  huge=never       Do not allocate huge pages.  This is the default.


