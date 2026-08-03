Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36169C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B95E6B00AD; Mon,  3 Aug 2026 09:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A4F6B00AE; Mon,  3 Aug 2026 09:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7256B00B1; Mon,  3 Aug 2026 09:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05D586B00AD
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96866A06A7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:05:18 +0000 (UTC)
X-FDA: 85059676716.23.2D960EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 024FD10000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:05:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZ2gDhbU;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDKR1dCVeIWJBea0NvOAJ7bfFFbiQtK40uSg+uOfi+w=;
	b=4U4xenw4FAAYorlNjeyyXC03ClHgEe8c3QgyVG3fGD+21eaMK5fSb+wfNHuIJ3r3FDbRb5
	E61odKvT3xK1HnGCmVstvnMi5NdQV0VWdWB/J8NkPMDO3lBWMO3pGmseei4fO8H1/O1O/Y
	/5iFiBX97DlQ3Q88ddB2xy3yWqWEs3g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755117;
	b=GYCS9mVHRBe+O3CDCwXQLS+eeYU74nuKMwJ3zv1/ykZWlD8GcNLH9Kba3xEgDgHKCC3Ycw
	aPSnaLSmn1324F7Lf6wZEnzhxmsjWtJ5SVxWgE6ql3wrKIpVmQBz1v2i+UjZI7zGE4n5u5
	Ccebos250jsPQe01C812YEkrOECmslg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZ2gDhbU;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F8E360A96;
	Mon,  3 Aug 2026 11:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E241F00A3A;
	Mon,  3 Aug 2026 11:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755116;
	bh=DDKR1dCVeIWJBea0NvOAJ7bfFFbiQtK40uSg+uOfi+w=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=aZ2gDhbUdv8u/vW7g2zB7xL14AZwWy9NwZMfuJWDklUPfivAaoAZa514qWdkP1ddV
	 RO/w5axr6lvedaKdxqUDyE9r0HmIDQdQxVGbqiuzdiuBFcZeRtVtRzlcZaRz0ePHZ3
	 xFpcDBrrxMMGcaBBt1rgkgvymGEHmXjXgxgGn+Hv//N33uBT/sO51oIEDTI9KALNB/
	 lGqPe65JvGsBKVzE2Tiom+7sRYk4l5yrgm0RM81byxY/iB/YhKozVrcKkWi2j0ixuE
	 nRzAgr8UcmISpZ7VEMipuc/2nQgC2FNAW9u5X0fw6gyK0F1gvoDKxFp+M6sQatNZtf
	 swG1QZrFLNO6A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 09/16] selftests/mm: skip khugepaged swap tests when no
 swap is configured
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
In-Reply-To: <20260802195254.1937477-10-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
 <20260802195254.1937477-10-kirill@shutemov.name>
Date: Mon, 03 Aug 2026 14:04:23 +0300
Message-Id: <178575506332.1561566.7690482774981947944.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 024FD10000F
X-Stat-Signature: 8n36oo4pqonk8zhz7m6txcu4ku5yn3i8
X-Rspam-User: 
X-HE-Tag: 1785755116-386819
X-HE-Meta: U2FsdGVkX1/BYpZEKZuqPdSeTChCt7RXFB0s0ofY35IFRFmLUiNaeIvD2uGjHRtlH4kH3Ekt0aCD4n/5cCQ3I7EQe2wMJtXMsIUeOSqy/knWZL+eiwgcYFMuH/xfgMp1wR7Gex6BxG2wt2fSdIleb0b0Mukb8PGtmOL7zDg1GFs2Qm3Q8Meco3dJGfCZXhjm0IVgTPn0Z48RhIgvZXYK9kDeTUaN0TmgCGW/47Cw+nLxWFsc8TpRH536+BI2EmGSXff+oJ5Aoq/9b5ac6ftgEPsbyzah8Ix+DLR0Se3U25f4XbZAGlJwA6KCy4q1byM/ephzKjoKMIhBIwtdaYtU2WDLt8IMIJ3j7/8/+Sw4SXJNin0yuKxVgddtCCPW2iNXMdvXqxfHpGay0fqgyyqJWp+IV+D0CmqOPl0urFxmYk4ec9WMtGhI1nOa4BoTmkucKKYEh8ipOWVGAeoiQRR86Q6fIax1599Ec1UlToh6/bvezMpuyyUVvpn6FhFVXcp7zc1a6/SEa/1VVhQTzyTKq8WKmM99YwS0uHZ6m+V0FjmkpzMb8ckuJkKHUE8Lqt8kMYmApe9BvixoKja/x9XA7nH53mAH2cc3Gh+qLoxGDWfjeRZyV3eF6uD0RwtX9PKmdi7CRXIYoJ8SAtLRlccdx2A9Co5gamBacsWTskgiwF2rCX7w1Jml0lUivK4Ur30Srw5Aclze14XmhvVSHN0PTzoYuMn/H+Yf5NS30lAicxrE8Tsy9VU3Odploi0AV/7tpotjn0RAxwYMxAjKmXnU8NYU4perG5T5kGbLa5lYREvkgxeQ71siVk4OcaXymTiQMbMuD5NVIQinfU2hnpPMT+aU4Row0pzlfko9EUPWbgkJSVZ7munZuae2kgXKOeW7RZ+ZH00DyGyNU46JPmFxrRjgMLSKR1y7mdwytmwjok1L8JJKaFV92XzkTNT/IBJm2v8Un/GTJbKtqWmZvmM
 KVYhA776
 uShJgGuJENeVTLwEDY5IVZpA+vfRxzAZS4N2uYwIB9StaxCl+ObOqGuk0ht3HDXl2uxEu5zMAu/kegLeZBsySW0zzGJgeO073BoB82iwJycvVtWb2gYDdfvDR8KWtg5IguQ+N6Gd1e1kS+p1CLwH2qk2jIwaerNQK3bZinot2iyR1dGB4Xjw1RHcNnexO4/Zghr5sxXVsM2FdYTaVnpPHKx2ftEPNUX09j89FfNNM1hi9ahK8ENDWTNbhZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> collapse_swapin_single_pte and collapse_max_ptes_swap swap pages out with
> MADV_PAGEOUT and then require them to be swapped. With no swap area
> configured MADV_PAGEOUT is a no-op, so check_swap() finds nothing and the
> tests report a failure that only reflects the environment, not khugepaged.
> 
> Skip both when /proc/swaps shows no swap area, so a missing swap device
> yields a SKIP rather than a spurious failure. A real swap-out failure with
> swap present still fails as before.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index b43e060b4118..b074b005b62f 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -181,6 +181,21 @@ static void get_finfo(const char *dir)
>  	ksft_exit_fail_msg("%s: Could not read: %s\n", __func__, path);
>  }
>  
> +static bool has_swap(void)

Would be usefull in vm_util.

-- 
Sincerely yours,
Mike.


