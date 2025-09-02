Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A77D0CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC698E0015; Tue,  2 Sep 2025 09:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DD68E0014; Tue,  2 Sep 2025 09:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87268E0015; Tue,  2 Sep 2025 09:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D660D8E0014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:54:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B2B4139079
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:54:47 +0000 (UTC)
X-FDA: 83844455814.19.16DA938
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id CEEB5120003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:54:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PWFgYU8k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RxdH1eOS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IJF9w9R2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TptAsxda;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756821285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRncs/XLu3VtQZMRFo34tEIibZeN/NBkeF5ufzYobyA=;
	b=KyZ7SJkozhJ/us+lSAOXBRtteqvS0Ht39gEdWutxUSTmT6YusTfdw5NiJO+Xi9kfQUuseJ
	y79BK6N6aYBY3rzTVa3ghSy/5Pm+VMpFLfwE9K6LgvJPCAgTzhoVUlgcJbpEMdEcK1ZWRs
	mzSaUalzIMqgz4TsVdpBMR1t0N7Y05E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PWFgYU8k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RxdH1eOS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IJF9w9R2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TptAsxda;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756821285; a=rsa-sha256;
	cv=none;
	b=8hISsPo/1xwksXw6KMFJ+EOeknt75PTJyfEjwfdCf4cicdcjrWu66W4C+s3AFGZWF9s+gs
	kc/XgmY3+jRhXtpG/eC5qtF5w/T/38r7caHrLJWU68p8WdShCduV8Dv9+DTIcysDdjxeSV
	c/NMbfhRsVZ17eMITOLFOdskngoG17M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D67B81F38E;
	Tue,  2 Sep 2025 13:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756821281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yRncs/XLu3VtQZMRFo34tEIibZeN/NBkeF5ufzYobyA=;
	b=PWFgYU8kH5Z+dLcfPOpJKhlRc39tkcOGWJdcqze/Tm1mxnoGDVcgjmG68PI09U+9cknFo4
	DFOIMWo2cHZXs5AEU2PwuRiTTqSTHHUKw4emhD/ScHLrMi+iVv0AKW6lv8FiMZ7TinVwp/
	ZbOkkzIKnJXej+10kHcZKoF1D8LPuwk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756821281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yRncs/XLu3VtQZMRFo34tEIibZeN/NBkeF5ufzYobyA=;
	b=RxdH1eOSJurfKL0jgxUhkpVzDwO9klofsqIlT7rKnaUZfIEgFs5VRlAsPMmbn/ehFXwyhV
	kkQn2kIe4o1bTTAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756821280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yRncs/XLu3VtQZMRFo34tEIibZeN/NBkeF5ufzYobyA=;
	b=IJF9w9R29mv9I7xuR2Zm+Y2ajPMwkADuFndDlVdGv7yb1tWGPV2U7qGC+87ZADHWv59jRt
	/KQ3KpAnRfxaasyiIZThpTQq55kKVwMuJUyZTK7WgIyagtc2+2vmIBgG4DjPKNnU5jwJVo
	WrTRLa4evqnRf7CmwNmbiTdwEVwIBPI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756821280;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yRncs/XLu3VtQZMRFo34tEIibZeN/NBkeF5ufzYobyA=;
	b=TptAsxdafq6ovaBAc7LZpm+QSGrrOIee+D1s/1CITGfckhTc+qv76/wZgAZcs88EaDYfKJ
	HZtwZSywpPpSX9Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B630313882;
	Tue,  2 Sep 2025 13:54:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8TcmLCD3tmieZQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 02 Sep 2025 13:54:40 +0000
Message-ID: <68db0611-3ecd-4cd1-8003-285981e21ca3@suse.cz>
Date: Tue, 2 Sep 2025 15:54:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: show_mem: show number of zspages in
 show_free_areas
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, SeongJae Park <sj@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com
References: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CEEB5120003
X-Rspam-User: 
X-Stat-Signature: dm1phz5mx7b1w9qipdz1cxeo84kgmmop
X-Rspamd-Server: rspam09
X-HE-Tag: 1756821284-498115
X-HE-Meta: U2FsdGVkX1/DPj0zbwN7KhSVYRF71AINLhOVXWrYfi7IPfmo/e7PwoX3QsEyIdJNSL9EHFZgci1OMnhCZCDtXbOXmvAHqS9GBnNRKjQ+gBo1rMUJLJIcIyrrzXw/kKLAnM3zkDsaXnQWsW8K7u/z3z1p5MCFMWsl5bOoGK8gynRth4kTWoPVYBnb7LWiWG2rmXT/3NMOPdAHr8DD7/XZi5VyAg+SJSbB237VXzzWwtYB3DlTtyFasDgrP+WuKQgeBtifC5gVRjv9A9lQrlYc92wQHynE2oALrqQDl64QlCf9gy5sU19wyt5Y480Ur5DGrxTjySs+Ug6RrcW+33oNJyPnbabhjpEgrR/vwfm8bttM1NhlT7zAu6aEVUznmRb/VI6oujrxWCtz3s52IPbs5pXfdBtS7CyPhI1UCEE4J/lRXqbkRa8upoU6C5p1KNTZFqv9XfHAGjE1Br9QhriWL6vMWOoqlNkqb46/Oowx1yXE8HOsk9WsHDxQc6itr7ELDUvH2EqMU3o7jIPFzpp5EFRHfj12+OVy1ujMNsAa+HgDaKji8q+w6nsMfWIIJMyW5mOiWzeTOAt+aiRUMyFPVN6ks+N7JjgoUMH+/ooMBtMAMzKrIQgRvvFkPd2cEKiRLs3LbH24almpsQ1QybgY5o+GCgOzsGEbuYMpoZOKhoEaI2yKgk6hZMO1gLs160LHAkN3X4b8FQDpPS+L0kT3xQK5wKo4QQLTRokVV3ADgPn0wf17aXnTDGxHsgru3MtnVXWNr7eYmrZsUhQSr3oEWLmbrQN1n5yR8Iaa58ExdbVrbpSMYfHAQtDqQk7NISCLnleO81KE6z9bn863SMXk708xOozCV1AmUh3zmMrOGmHyTfVLdNMES5iM2kZSYXG5ZfrqL2xAESI11pey3/GtLANwCEi4MdELiC3/GlNrfatSfRkgpDuhOxhM5ZXNH3gOKJeTdPuJA7Q6ydSLbg1
 bb3JTKde
 3MJzLXdZ7qKK0WcFp+m9aK5stq1FVQOxUxcGLTLnJHoi6AHNs4OeJNIg674MsY9i5e+1vX9OWNZtRQplVifbx8sUWXWe+cHXuhLIjsex++/guF/51x5wKjwwNhj+R+BOFp77qnYwbmE48sJdR6/9+2R5SOInL/Iau+5LfSCz+04KQJ1gmW+JP/DxCFG4gbChe1mUsPoEXS77RR9LF9AeDUveXcfTwz4sax6+kPOa19D7OujPs8rBQNrcjv1gjJss4mhphgvVjccxL5xI/98W4bkORVng6eldY59+1d1Tz0GKWz5MlQ/zutQTfwZpKqPJtVu8HcPT6F0N8tH1L7K4HfV4QkPJ9v+NR7JULmmpNNfCzphjExRfQU/zLDg5B+mVSKN0XXRjyBVvb2PE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 14:49, Thadeu Lima de Souza Cascardo wrote:
> When OOM is triggered, it will show where the pages might be for each zone.
> When using zram or zswap, it might look like lots of pages are missing.
> After this patch, zspages are shown as below.
> 
> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
> v2:
> - fix build when CONFIG_ZSMALLOC is not enabled
> ---
>  mm/show_mem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 41999e94a56d623726ea92f3f38785e8b218afe5..c563d9adfa87765a8736e91c1f68d824b03eaea8 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			" inactive_file:%lukB"
>  			" unevictable:%lukB"
>  			" writepending:%lukB"
> +			" zspages:%lukB"
>  			" present:%lukB"
>  			" managed:%lukB"
>  			" mlocked:%lukB"
> @@ -332,6 +333,11 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
>  			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
> +#if IS_ENABLED(CONFIG_ZSMALLOC)
> +			K(zone_page_state(zone, NR_ZSPAGES)),
> +#else
> +			0UL,
> +#endif
>  			K(zone->present_pages),
>  			K(zone_managed_pages(zone)),
>  			K(zone_page_state(zone, NR_MLOCK)),
> 
> ---
> base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> change-id: 20250902-show_mem_zspages-d090ea0bd1d4
> 
> Best regards,


