Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02997FF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C6B6B0088; Wed, 29 Apr 2026 10:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D5D6B008A; Wed, 29 Apr 2026 10:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95446B008C; Wed, 29 Apr 2026 10:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D78B36B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:20:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 746461C00DC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:22 +0000 (UTC)
X-FDA: 84711803484.26.64DFE62
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D78840003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cAPLVnUU;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777472420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uKxyX+iEimJhDYjcnVskQWcBP1D05m3UcJyhDoPSQs=;
	b=XlUjpvgmUTWU5KUAh1VAArzQatWsh6WNHgXrSNIGZPHyO0P9DQ5GEv9hDk6YQyJG01tpqE
	gg7xvrTYN6u4UCzX7mM+HZewJe7vO5yyNsEm8zUdjLIOtLMqATP/jMNjlOPlWZI4Kfs1j4
	zObLb+Tr6cJjqDlM4AQMyBnEIXBYlHU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cAPLVnUU;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777472420; a=rsa-sha256;
	cv=none;
	b=Y8260SwaBwy0uq2w9LdOiHwfTaH60v2ND/Swtc8B5MWiXYJFNtQpUBzzzTV0HHuIO3MKC0
	2v/72uoVHmSipzCCPqqFM0F844QIo1X6aa7MFINgf8a+sM70Vs66+BpUb715DmEzEosJK5
	FPBAzeECj6PacJbbThSjRIesPz+hO7I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D62C71BCB;
	Wed, 29 Apr 2026 07:20:13 -0700 (PDT)
Received: from [10.164.148.40] (MacBook-Pro.blr.arm.com [10.164.148.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B17F3F62B;
	Wed, 29 Apr 2026 07:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777472419; bh=yu/k00bXF4IsrPajU5vK3oy2hwcnNad/5yhRTlK/Gv4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cAPLVnUUUAxNAGLsklYDcy5M5RAmUPtK0z2SgAS1C/tR0Zsh4UH4fBdR1Of0pldGd
	 Ka/2ZlaOVUpOQnmDWA3lpc7HUXMV4qcVsk82Z+Jm7wVCAwXxJO28XKZoc5FBLA9k+F
	 ITbDbvj6ky77TH/+gIvvJZiBmcedKkQUW428qTAE=
Message-ID: <70b44146-4549-479f-8d31-b40a8e747c60@arm.com>
Date: Wed, 29 Apr 2026 19:50:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: return -EAGAIN for SCAN_PAGE_HAS_PRIVATE
 in MADV_COLLAPSE
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev
References: <20260429140434.439456-1-agarwal.vineet2006@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260429140434.439456-1-agarwal.vineet2006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 33rs6751tbp94mccs8hh75fuqzd9cmni
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D78840003
X-Rspam-User: 
X-HE-Tag: 1777472420-216163
X-HE-Meta: U2FsdGVkX186q5EVFpsq2qw4sah8JCj58FVfBSNp55HZX3Wcs8U0wqZ5ks1aoOllsOaRw6yI1jnp7eWJniRimiFYbN57vkOVaiKRwhjpGAhSg2OQmgUhxzexcjwYYFUHW0J11EKkUjhSUj8oLykGXnknjqIaqsUeoZBuAcoqiZpUEBfxL5fWe7yQYd1s3MjLkcgieMgxapkwPjmXeDvmnxoSrNouZqkoNVqYhumDUfK8nTHoh9WQkBd4v5IvWONLAFv0tZ+RAioY3p9W4hcrD24Y9VhbjyUnAEGpuRT3eocDiQp6TUiwGMio+vu9fcKGzQDhoD4V1Ea8mzAU5EOuivkVjpqRJWs0nAd6V0cwY3XXI44MJcBZV6GIeJ2l30vGYCzg5fqJGEjse/onPS+0tjxOpxABS9p4+8rbuRTH+KR/nFSbPqz8IOVNJ2CkNqH+6xha9amLSVVGQbrzo3rZzA7uVggV5tFlztx7t6c94yWvgMUu6ZQl1kRC9EmLkB0ZTfJSIQFUJc1gJWoXJZ/qIKb+7AvCuC1c+Tu8wD5VPhB7w/jj4syi6a0Xv9Qdkl/CcrhENXz3pxPSRB/7iBvIQrXfCi515hYDkOr27DzksGfgVkqbPTLCmvrwwBADQ4vwFwTv5wAGowFPQC1be8gaEYQPBvjZL7HCvz3JWj82gSIJzsv5MembqfabbmD9xyKbYBnnCADICYOezSiYJG2maacGmUEdLppu+5zNRi9GTMn76FvgVo+PoYIbe5lhs5tZBjeAMBudPoP1dq8BsShtRV95PUgpMgBqyof8i/OT2flch6H6Yp9FcI9qC8FQphLMkSpIjz1IYfcuX98ZDMSeEwQvlPN3yLgFMrh7R2gFCOR8XKXIwHJCYsIz9p6UDrVhsRnr48WxgGdG5p4e4BLtfj5dVh6TLHDABWOlV6PM0KrRPSgJ0AgMjy1Hra+ZTI26MlMJWlg7PN+w9hiZb44
 0amx/VSF
 b3Cq+H+LZdtLI8qWVWhv+3olkV9K3E35LB5q4Flw6b6PytZeI3YS6mxFWvlsgfuwafwbvlsVaG9vxfeWHwaUVgB36j+FCZwqZdL669QSCRWPLLLonFS3Wb6p8VL4W2JidDdC2gJRRNe7/i2FPAmng+8uo06Ump0W6w+Rz3VcAA2LfyduEW2+8az2Q69pRFhuA4uA84CRuGOySAQQsniJNyKLSC2RYaZi/F/Eag1+FGjMKFFCdGR/OzGYFvfEY5aoBu+g2HyVSRb4EgKY9b/aW0wlUR3D+3MlEf31vtxZMzqdCVSD3JraKmuab6D/JeSkJ37mdBs4hv04nabtyIWGcDQ+FkMDtmOi7/iEyruZzaM8wJOH43vircg1xPQjfJbWkCyyJ5xH1Z4WvBkmkxY23II9NGlCj6tBxFGKBuasiwy9tiLduUDZ7oHkRDTf0OOqfsRrZ4vRIrHw5NJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/04/26 7:34 pm, Vineet Agarwal wrote:
> MADV_COLLAPSE uses errno values to provide actionable feedback to
> userspace. Temporary resource constraints are mapped to -EAGAIN so the
> caller may retry, while intrinsic failures of the specified range are
> mapped to -EINVAL.
> 
> collapse_file() returns SCAN_PAGE_HAS_PRIVATE when
> filemap_release_folio() fails while isolating file-backed folios for
> collapse. This currently falls through the default case in
> madvise_collapse_errno() and is reported to userspace as -EINVAL.
> 
> However, filemap_release_folio() failure commonly reflects temporary
> folio state rather than a permanently uncollapsible range.
> 
> For example, ext4 returns false when a folio still has dirty
> journalled data, btrfs returns false for dirty or writeback folios
> before extent state release, and NFS may return false while reclaiming
> filesystem-private folio state.
> 
> In such cases, retrying MADV_COLLAPSE after writeback, reclaim or
> journal progress may succeed. This matches the existing -EAGAIN
> handling for SCAN_PAGE_DIRTY_OR_WRITEBACK and other transient collapse
> failures more closely than -EINVAL.
> 
> Therefore, map SCAN_PAGE_HAS_PRIVATE to -EAGAIN so userspace receives
> retryable feedback for this temporary failure path.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> ---
>  mm/khugepaged.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..58f55115d7d8 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2808,6 +2808,7 @@ static int madvise_collapse_errno(enum scan_result r)
>  	case SCAN_PAGE_LRU:
>  	case SCAN_DEL_PAGE_LRU:
>  	case SCAN_PAGE_FILLED:
> +	case SCAN_PAGE_HAS_PRIVATE:
>  	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
>  		return -EAGAIN;
>  	/*

https://lore.kernel.org/all/4ab54ae0-2607-443d-8698-788d8e951bdd@arm.com/

I had mentioned at that time, other error codes may fit the -EAGAIN
(or something else) definition as well, for example, probably SCAN_TRUNCATED.

Could you please audit other error codes as well?

Anyhow to your patch here:

Reviewed-by: Dev Jain <dev.jain@arm.com>



