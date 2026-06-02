Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA376C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00EEB6B008C; Tue,  2 Jun 2026 00:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01F36B0098; Tue,  2 Jun 2026 00:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0686B009B; Tue,  2 Jun 2026 00:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFCC36B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:38:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65F07A07F8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:38:31 +0000 (UTC)
X-FDA: 84833716422.13.0E092A5
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7BB3A1C0002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:38:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jTqW2E1O;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780375109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/14mXd0q1MBnuc0ydGe40mVtZmaecJq1itLWhQAj/UQ=;
	b=HQ+29FAIZyyAlMRpsCto6uds+5u8dan01AmJfflVyeRF20CnhaPlPHFMZ0KOttXRw/IPl/
	jkp5cy1HCcqPtliaWpa+eOBTG5f34/FDDlteGKiolMWMGdtTN338SRh7c0CqOZopQ4xqzF
	6lzPJ1wjr8kbzq5NJiWzdgp2xOkU52w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jTqW2E1O;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780375109;
	b=RSSR/ByIeoqT5fAzlBEhaIvS8S4pvZBGzogl4V9HwdOni01rYbhsAFjtpKbg9zrTIIFdAV
	Ww+XqSEMqYBmK1utz7WbHVeiYAIWbLOfe7GYKOuvxOH6cT9hxA5krxzfgEBuo+438OdaCE
	HU4B+OI47UKUNdYKtlGkfZC6r8CuO8s=
Message-ID: <1dce1561-b42a-4322-a99f-89eba1e7c227@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780375107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/14mXd0q1MBnuc0ydGe40mVtZmaecJq1itLWhQAj/UQ=;
	b=jTqW2E1OzAFOKAWGc9K+vAdZbQ+j6VvpFnF5EObq7hBUO5GDclhGAbTbV06Jht+tayX7um
	Egbg7h7ufGLgiyds8gmkt9HPomylcdCY6byqJY9Y2Ymab1HCK0uAtRGPMImqs8n/5Qotfz
	l3671eM2Cj6zd0Ew2rimViAUVa+skV8=
Date: Tue, 2 Jun 2026 12:38:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
Content-Language: en-US
To: akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: david@kernel.org, ljs@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, david@fromorbit.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, qi.zheng@linux.dev, yosry.ahmed@linux.dev,
 ziy@nvidia.com, liam@infradead.org, usama.arif@linux.dev, kas@kernel.org,
 vbabka@kernel.org, ryncsn@gmail.com, zaslonko@linux.ibm.com,
 gor@linux.ibm.com, wangkefeng.wang@huawei.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 npache@redhat.com, ryan.roberts@arm.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260602043453.67597-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260602043453.67597-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7BB3A1C0002
X-Stat-Signature: pxwge4gta4f7tyajgacxetgwu5i8mmu3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780375109-833609
X-HE-Meta: U2FsdGVkX1+diq36KJyHFlDc1Cwk1IEcwahoWkjf2n6AoJEeVtIlefbcDgh7/Yp9v+FK3pPzPuos55J3iJTlAyK+/6jR1HeC5Z/yLQJhiQ93Tdf6+1M0PIbiexlocV2x3NDtgOYg7Jf7X85bnY0XVTz0mvT13H5q/T1dPN3qQo5zWcqO7khvp4CcQR76xcsCAzuoUfKtzO44gFjlV2B90PNHg1nA83ZnU8u7j2zoD8j809tqD0OCoG7b2H7aGy7+d6dm3Jss5OKcyLt+17awrWUUUlQW6L++aUZKAK4R+EhLC5buOuavgy8btFeMGHebnypIM2+Rihe0HR4Pe1dq4aFSZWZetOoGojVVTehnYGj83mLh7zdT1fCQ6az7hZePWKhZapruGclhjqsP7lOsap9yGv1XjW6GReZtpj9D/4LcsW4sPJW6Ht3CElB/qZwVl08Agygea1LFCqyEXad0k6rxTz4XHUAS1t/UnS22NxRWO4pU7noR/gkDoHUSnrM+ZFK+T+baK+GlM9bAPD/2gfhUxV8wobvo0kLtdpD8yXklYsLsMoFFx5mnSUELn0fE3IcTzbGL+xNgmjSFMFJqbBkObBo1JrS3x0vUyvRTGkEYRDSBYlRsJS8Wt5Rp3cJdHMUMC9WEZyx6JvoGxOVdiLgKtscn39P2fdFqaBMGN1s2VTUghK10Cww7wdJRW4yb0o/+p0UpmA+SIUweQElfiuyE5lRZSnm4xXozqud4DB+KWODqU262pSNxRlbfA9bdJCL5S5OjXIQVBH9reTZuTS7JMhvkGga3xCpKc+zqce4sAG7n0RBlaEI+I5Kdo838ewmZrwSGban6XhQAcADvm/kWttTGkjj4XeqpdL92WpR211ZHLNg5ht2L/52+7F6TlGdU2aHx5Qx/ssghBSor1M7Uxzjx9hi4ZJG/vS8S5Ayi0QRl2kidSydNeTCS/82a4oeARcnSIHU4CvY1zZa
 4ZzBeq6y
 /J/h5SCRv5uP7S8NDzSvIeJ0DSYmm0S05cX47wDSOllYKB2ilpAV3uxPWGS+roVNqblJm8hYYUId4+lAqW2G/zwc8mbzPTDx+/PcgS0xRbuiETzR3QVz+ujtl49RgIKecXjDCXNiqP3PbzqLaNlVzm93Mx5/4sOX+tC8aIQ6M94R2LFOPWtIPNSzl2wV5yjoR3UUmU3Ac4L0HWEjtw6R/Caxn9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, I missed Johannes in Cc ...

On 2026/6/2 12:34, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> deferred_split_count() returns the raw list_lru count. When the per-memcg,
> per-node list is empty, that count is 0.
> 
> That skips scanning, but it does not tell memcg reclaim that the shrinker
> is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
> count callback reports SHRINK_EMPTY.
> 
> Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
> cleared once the queue has drained.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   mm/huge_memory.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 72f6caf0fec6..62d598290c3b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>   static unsigned long deferred_split_count(struct shrinker *shrink,
>   		struct shrink_control *sc)
>   {
> -	return list_lru_shrink_count(&deferred_split_lru, sc);
> +	unsigned long count;
> +
> +	count = list_lru_shrink_count(&deferred_split_lru, sc);
> +	return count ?: SHRINK_EMPTY;
>   }
>   
>   static bool thp_underused(struct folio *folio)


