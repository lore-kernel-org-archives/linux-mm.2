Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA706CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 02:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1983A6B0088; Sun, 10 May 2026 22:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148FB6B008A; Sun, 10 May 2026 22:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F056B008C; Sun, 10 May 2026 22:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECEA36B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 22:45:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54E2E8D326
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:45:24 +0000 (UTC)
X-FDA: 84753597768.08.783E563
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D2F64000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:45:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSEzpJZo;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778467522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZx4U0acqa09XiBdDPPrzlR/K/xeEgEPoWFYly7N2Wk=;
	b=6ULYSYaD9KP5dw3/pSIrG7nemccO80licVZ9ABkSImMZNNOpkcl9k+qOSNrPgyswshKqPw
	AAd9c8SDwb3Xgi+gRFD0yShu3SRoGDwHwpHhrt7nZKyScRgVY6z71z0em+Nv6hphc3R6Eg
	AZhkg0pJgqnIGGns36ct5qgBRbThRcI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778467522; a=rsa-sha256;
	cv=none;
	b=G6nt9iQNiqCsP/BCcumBwLXpB6mtXbpWlcvCW/K8E43eZstEOQYc9vfTQY8+5SZ9Y+jARx
	zzHw490jPPes2H5dfaT5oFxrKztWVBENG4RRlV3uX7rJjsQd80X5EI0q51y+6RF79/3xm0
	NVoH/TFEiOEfkCWK720waRlsyAFw94g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSEzpJZo;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <874e88a3-414c-4e9f-8bbb-5184fb8516e8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778467518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZx4U0acqa09XiBdDPPrzlR/K/xeEgEPoWFYly7N2Wk=;
	b=jSEzpJZopF3I/eeWce4wCqU+7McFWjb5PY44X+9DfR+LNkUrHTp0eOAcBI2d+BXuXXLRSH
	9DPYSdzC9ixZBnPOh2jn6OljdpIEFn1Lh3ittkZQSRlMKg+u58ppssGqC7oGmxM3HoYndq
	oVKL3cu3BI4ML1at5nJDNBs03oB6HJU=
Date: Mon, 11 May 2026 10:45:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/shrinker: avoid out-of-bounds read in
 set_shrinker_bit()
To: David Carlier <devnexen@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260510183700.102475-1-devnexen@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260510183700.102475-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D2F64000D
X-Rspam-User: 
X-Stat-Signature: x1enkngabwum46we5fyhm4zwk3ug6eaa
X-HE-Tag: 1778467522-525102
X-HE-Meta: U2FsdGVkX1+6IiW2ofIBw42N+yc1GBpbLpNLWo6kRy6nxacTi0jJ/SQDfDxQxSYq8V+DloUQu3mWVonwyiCm4T/qBLiU9obVSxWbiLxZDONpN/K9mOgmVyKFja/5zS2H51TF9axeUWouHpxjRQjO0nptBMGUlW9YQZrg+94ZQB97YbNe4YB9J1+h1PaFWH+rtlA2PFtHYH1y8srpW0JfnMz7j+bNVAHx7MayBJS6LW7yyQehL9Xy4HUdNWdccMNZLVnB9G4NIrFjLfEvXr+sx8q/Wb6DJBGdZqw9PXlW3beGhMQoQPHG/D5np55lLUc0LWLA9Wx6uMBhSGMbOFal/zm3pTxAfd4DCLHwCURWxxqqbDOC3YCc2jwmnD7UrPbU046lo4SM44NM7q6u6c7gikYa7Ld4oqGjygk+6ycjQjlkamQ/ZomrSjKSkHdv77Va5NgDjL3LvOK16hZ9Ao6jympRZ7HGm7Q9BWjhPrswshmmmyD00iBvUkhFgcewwcsHPkhyGFQr/CnBneL7lCZu09RFUus+BECuDkPh7fn5lpmfJl3xiD1UaQUjaxIVBhBVxwXax8u1ta2sKEySM+5GPBpIbONNlJMfTA6i5BvhCMSo544lcIaa4N+X/GLOiKMVUsWmH3ozYN08trNza/xdDWw5phPZI1vAl3Ee7lcGCtrlDN84XbXE30INNzQ1s0wlpWpwpjPoS5ZbaK5jV/AQZwu716EphAD9qC0ug5M1cFIMyAGNJx41nfmPld7yONuFqVZ3KJ+gPJJSeqBllAobZWL6d+skwNSrEHW4wNvntxfuPdlA+gnd4xvVPc6olVpRXjyIwWU/Zazlm4bD9B5ZfBfhdULHrEytoE1AeelRjv3xVkpl+BO5Yi9gvpp+/uf1surH3PKvI7VXreBhaLyHaVJZL/6oD1TaNHXOH4OfOz6KKPMXhvksHCd3JJ1c23PJDMcMR5Jls+RP/ISN4FB
 BYsppI4O
 Knhe4NqRVpsr2hAkIu+0HVn7/FyOOYJkLyY1rHV8Vqqyqllt48Uya26Wy/NdZ3d8rSu5oae+DN69zJ0opMdHvh5iGEgFEyZdLlC+HAajI5mQQgyA0DUFw9EJZ0gTPmMHzG+O+f8E84iyqzs3EiSjbi6Nr9gyIyCTWHki/04BEIaTWBIVwp6EpaM5O7+msZbgWTGUHpHvjwXySlfPQ0tRM/C5EvdeBfScnjQTeATltPkV+M8SZzW81KZ5ZyBPt6phmBkQvTkisB+YaRGf9PtS7Zb3KMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 5/11/26 2:37 AM, David Carlier wrote:
> set_shrinker_bit() reads info->unit[shrinker_id_to_index(shrinker_id)]
> before checking shrinker_id against info->map_nr_max, so an id past the
> currently visible map_nr_max reads past the unit[] array before the
> WARN_ON_ONCE() catches it.

Did you run into this problem in practice, of just find it via code
inspection? It's virtually impossible to happened, which is why
WARN_ON_ONCE() was added to catch it.

> 
> Move the load into the bounded branch.
> 
> Fixes: 307bececcd12 ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>   mm/shrinker.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

Anyway, It LGTM, so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 76b3f750cf65..49256f81199f 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -197,12 +197,13 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
>   {
>   	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
>   		struct shrinker_info *info;
> -		struct shrinker_info_unit *unit;
>   
>   		rcu_read_lock();
>   		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> -		unit = info->unit[shrinker_id_to_index(shrinker_id)];
>   		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
> +			struct shrinker_info_unit *unit;
> +
> +			unit = info->unit[shrinker_id_to_index(shrinker_id)];
>   			/* Pairs with smp mb in shrink_slab() */
>   			smp_mb__before_atomic();
>   			set_bit(shrinker_id_to_offset(shrinker_id), unit->map);


