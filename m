Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1EDE7491E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 07:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C316B0005; Wed, 24 Dec 2025 02:50:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873C56B0096; Wed, 24 Dec 2025 02:50:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7764E6B0099; Wed, 24 Dec 2025 02:50:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 665B86B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:50:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 368C11605D5
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:50:42 +0000 (UTC)
X-FDA: 84253592724.29.E9A8E5A
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id DA87C140009
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:50:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WTqFVnRA;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766562640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmuJKPdTgOxTVKhwb84MlUQ0GXDFmnEWQ3I92ijpTmk=;
	b=PDNPBYC4xirSqjtiRiYDtwM05eWTlGUEdM3QJPD59HYoxccscEVw+rDULy8yhaUBqOyviY
	udx31nYWPK8vmud71SZ4brBZYijNwusp10AM04QMuLmB6e12VdVFFZqbJozOgJSXn35dUI
	YUP11f7HhxqP0ja8W3VVuuauSv72lTg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WTqFVnRA;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766562640; a=rsa-sha256;
	cv=none;
	b=e93Q/aexuLmE2uzNOlAfyCzByYaSEYWREZqwUpmEHE2pLRL8+S8+wdCIcSh8iH7tnVyHkN
	QlYxNaHY7GYj/f16McCi50KBfHUxRA+wMnli/ULxS6ARG0lWRPy3ySDu+D7VGmxlyRHL0p
	kY+DaamjCMguHzTCoK08RZlMsMX5vbI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766562636; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JmuJKPdTgOxTVKhwb84MlUQ0GXDFmnEWQ3I92ijpTmk=;
	b=WTqFVnRAMpqMilbF54ZFAcp/KriQOkH9QFEQH1zXpGWMZxXHHTmDNYjwQgPMKTnbWEPDUQn5rdCwf3bymzJIRIXa/c+eyJlgkY2ABkMB8BP17fylI9tYjisiR68FcF/xBCe1m5Fe7LevFoeS/PtmLhj3yJ0iC9A/7fl5EueLH60=
Received: from 30.74.144.133(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvaRD92_1766562634 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 24 Dec 2025 15:50:35 +0800
Message-ID: <62a2d7ba-e7c3-4153-b227-c08802ca9e1c@linux.alibaba.com>
Date: Wed, 24 Dec 2025 15:50:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm: pagewalk: simplify hugepage boundary
 calculation
To: Sahil Chandna <chandna.sahil@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, mhocko@suse.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, zhengqi.arch@bytedance.com, Liam.Howlett@oracle.com,
 weixugc@google.com, axelrasmussen@google.com, yuanchu@google.com,
 yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: david@kernel.org, Matthew Wilcox <willy@infradead.org>,
 David Laight <david.laight.linux@gmail.com>
References: <cover.1764312627.git.chandna.sahil@gmail.com>
 <35ab82f052d248c0047c10bf01853e37e4f9b4e4.1764312627.git.chandna.sahil@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <35ab82f052d248c0047c10bf01853e37e4f9b4e4.1764312627.git.chandna.sahil@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 1ajws15sffux8kn5f3ygy5o98koo4sxu
X-Rspam-User: 
X-Rspamd-Queue-Id: DA87C140009
X-HE-Tag: 1766562639-62292
X-HE-Meta: U2FsdGVkX18pgooOfS33YM2pUbV46YydyANKj54ggNGYtU4RCKqX8XfiCD/2xGQCLZ+PGCyS75EhXpVv3IJXk5/xIbSxOr+UfN3WZGJhtWSRxErDGsCpn1tSBszqSOpc4Lei5+AXeBUx/YFx2Pw/RkbuDMXMQo4Qdns2sxRQD7zQXCML5+9krWInA6jvmv8uciJ0BijS9YsRQdxmP++UT6S4dLih9VPz0kcHI4tfhBoqavO2Z1PF+NPWnksw4WtIEAtg95Ctc5jHTIzcPdBvhyh3sEECg8m+Ylu0afrAq8I4ad7uztW47gA2pQPMQhpJZ+ZNSHE0AjX0/4M8tMGiwR4zvIj3tzu4Pqy2vi8l3Ls5KdlVfMmoPbbk4OjOoeRWS6ugQGx5WFnlbGpe06CYObFRD1S8fvtIX++SeTwuTcLQMGRbNbwPg1Bb1A29KscPkMkSXuuJh8hlFkgSLSchJXDAEvnTYzU0frw2FtII5GTFg/VvKtj3ObeBQLETypNWEgyF0hP//XQeqTMxd7cafeAfuHAKNecPRJXhc9oQUC04HWO7pTFQ6749NK4h64SHK+jsWNNlsufUCyxIsY52UIRO38WPMnzDTrTthN1L+E1zaQ2VOZ1BpkjIT80DM9ww1HmRJgTQhw5TzHrDIh+KQfEnH/gwOb9kkPa0Z6VibIoRLsVbxjhTVrhAkdJfdVbZAp0hEeDKTO6XAYkPwrZ2PpcK3SAJUrOeTC3C1aBe6dfUXjD87fzp1d8No95NofgXGtwScfZDcGcWNeMyOKj2aKP6v95MjEKFFGaZCe2lGlIxPjIiERDJTDNekeMXD/Mz6LbV01yK3OWUryHCgYleIayJpczGvJAvve1mQV7vE55SMrU+/STIrIw2oW4QzQ+xWBc0alWE9GbA/vumpQvofOEby8LZrFmCrtOiwkEMq8OezS9nxhKlqwv1PtIK7/Q3nrUrn74l+zD17+GxjME
 R2wTXEA4
 F0IT4kZkx1U2OH1Fw2LTgDDb9M+1gmE3tAMjpi82nLcbGV9PHEgjigUsSHyt6kp7mWrHKhkCFqhQcZoZggGiEr3+3PFR9BXkCD7VfYu/sznCDkv1e9/hJ2hCqD3vuYdv+2bPjI/r16PblgvNXN42L6PBzhZkyrZyginS1+pb04Lfljr0Qs8q8hvepholGR8ZklDGBY/BAyGbq57OA3cZJJyMxMepmlIi+rqp0gYWiA2a9z+ova8btza9sTysvQEIRTigHPtySX7FRg/G4HVrYLYvJWMAcWS0+hmazZF/v85vKIXiyQCeE2jbTd/Q6Ta7ohI6XPq7Fdqbjw1/WzAoI+KESBdSv6pxO13R6h6TnatQb+uCqTWIwIt8KgjmLjVtKUPfCcNpCpVF+XgmpurDIz+wvx0Qx3wLwDahlRzuCzS5GNi8BxkrlOKnQPAkrfYlFzZujAe9qSv5YxA3j+cNVAF5tgH0a9g/tsdI39pO8S1keR0E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 2025/11/28 15:01, Sahil Chandna wrote:
> Replace hugepage boundary computation with ALIGN() helper instead of
> an open coded expression. This helps to improves code readability.
> 
> This was flagged by Coccinelle (misc/minmax.cocci) as an opportunity
> to use min(), after which the boundary computation was updated following
> review suggestions.
> 
> Found by: make coccicheck MODE=report M=mm/
> No functional change intended.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Suggested-by: David Laight <david.laight.linux@gmail.com>
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
> ---
>   mm/pagewalk.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 9f91cf85a5be..9fd59d517f37 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
>   static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
>   				       unsigned long end)
>   {
> -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> -	return boundary < end ? boundary : end;
> +	return min(ALIGN(addr, huge_page_size(h)), end);
>   }

Please drop this patch from the mm-new branch, as it causes 
'run_vmtests.sh' to hang. Specifically, it leads to the system hanging 
when executing hugepage-vmemmap test, because the program falls into an 
infinite loop in walk_hugetlb_range() and cannot break out.

This patch does introduce functional changes and makes an incorrect 
assumption that the 'end' must be aligned to the hugepage size. However, 
this is not necessarily the case. For example, see how pagemap_read() 
calculates the 'end':

"
end = start_vaddr + ((count / PM_ENTRY_BYTES) << PAGE_SHIFT);
"

Revert this patch, mm selftests work well.

