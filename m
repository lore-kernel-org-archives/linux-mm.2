Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF534CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 18:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E7A8E0003; Mon,  1 Sep 2025 14:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5FF8E0001; Mon,  1 Sep 2025 14:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD348E0003; Mon,  1 Sep 2025 14:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAA768E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:54:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 595FA11A4F2
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:54:32 +0000 (UTC)
X-FDA: 83841582384.17.9A316AB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id AA1E940002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:54:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BpEYSIbY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SbxMDaU+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="e46MR0g/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ML84C6a3;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756752870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67H8YIsMK3TTQVpL+86N7Y8H+8wfyU4ck4ybattWauA=;
	b=vK1VEDVe5jIqtgkaMrzqiYhMHYKgk4Ogs2SAhzrrMIDDmlQ4Ugd5OoetAiY0mi6zrcxaKX
	OpaKTgUvwbY3Qyw7McPVAsk0JeIS+O9XhCB5QS4Bav4XpRTqVj1zPyBvIizVCTkqmnUokF
	OEJci65nYrRk0wUS4c1C2iKGGUx0En0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BpEYSIbY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SbxMDaU+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="e46MR0g/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ML84C6a3;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756752870; a=rsa-sha256;
	cv=none;
	b=5owgMA58zJOGXzRCu4ZzRl7C9L1DQKVVnlww54hVQOBlWbmRdC+4xfUkjiY3o0MMuxPydj
	Yj3QArw3/uzj/IPVR5Aa6kEShj7/9hIetNRhvJN8hfkkzoiKbbSRntHdjcN3+sGzeLALNW
	Ur3Z03nf4qMtMh1e5TRQvE5UikN8GKU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ECE091F394;
	Mon,  1 Sep 2025 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756752868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=67H8YIsMK3TTQVpL+86N7Y8H+8wfyU4ck4ybattWauA=;
	b=BpEYSIbYRrbwHMtAq4Nbml14jUJbnXb0pkAtlABPOJrGKhclScmaAPiA7lMwwrIOp0QTGU
	WX96TDeox9XCHJyY9zeQRG2T48TEWovw5wgtCMYYMk3HmJerPk+G/78kM/U4ctJxC5Sg4G
	WIW5nskcdc+EDPkEfuzQp2Q9YGreHwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756752868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=67H8YIsMK3TTQVpL+86N7Y8H+8wfyU4ck4ybattWauA=;
	b=SbxMDaU+iQ85Eax+ojngV+QlPPpjz9GI+xpoq4BpyWjq6pUgLxxA/yDiFQQAXgK3oXObIc
	JSO68hxL59TOeXBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756752867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=67H8YIsMK3TTQVpL+86N7Y8H+8wfyU4ck4ybattWauA=;
	b=e46MR0g/AKz4ch6cnwgsFLM1gmo3eU9KsoXUsLit/dTaY0LCET3GkFdUBrkD5ehuPm08Ef
	hjXcGfemgVKsHzfjyKAorPGhxHmRhqv2HPA3QHasqha4PYtBxxen9urCAytW8MejyOQhy9
	DOnVnMACIDz76z7Mf7E4f1W9z5TBjsE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756752867;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=67H8YIsMK3TTQVpL+86N7Y8H+8wfyU4ck4ybattWauA=;
	b=ML84C6a3GAdCEFheUEso5bmG6eEypMjNwJf0v+gI0SyvNozaMofEQFpqrFy7lY8SeTpANy
	El7DsaHBxmAQOYCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C47A1378C;
	Mon,  1 Sep 2025 18:54:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QtsBJePrtWgDHwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 18:54:27 +0000
Message-ID: <f25b1ad3-c2d9-4267-bf7d-f48c78beebc7@suse.cz>
Date: Mon, 1 Sep 2025 20:54:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: show_mem: show number of zspages in show_free_areas
Content-Language: en-US
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, kernel-dev@igalia.com,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>
References: <20250901183729.3900578-1-cascardo@igalia.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250901183729.3900578-1-cascardo@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AA1E940002
X-Stat-Signature: bwx48qqt8obnrqzbsbxthusjxe4rj4mo
X-Rspam-User: 
X-HE-Tag: 1756752869-457186
X-HE-Meta: U2FsdGVkX185m7cusFM7wnu16SZbZBmalJOvxul7QUt17o6PgGOneDYaCL50M7taVBJ5lLBc0s/t/KsT6q9mGdGACa9gIajuAjgbOavM2pvjxjThwlW0tsD9dLw0/SkErMUNcAMswGdTwkodFp75P1HSCeonnOKjYh5OurfuAqvtUiQlhzKMzqP6kM1Tg5PW0+aWmFAq1Nvbvqo3x6IyvC+ijhhIv53DTc8y7pIxZlZzNU8aGLMlHTwzg2jWptZzstYh46w0dTfbE7dxVK/v0uZHbhE14eJAIpl7WcTu9juRpuhg8oT3O2AK+207EdacQBUm8G+rs7S+rHmiiTLr98rjPi0zg2CnSugtlL84UPGJuvFJI0zk67gpFt/y+BPIleevvflXyo1ekpkQ+98avDThbqTOlkUY5Tp7QQLRQKmvepsDK1o0zi2g9i75AwjLG6weewt6sB4NHpQcCIZzl6oKIExNDOjC9ROVsiyoszGZVkWOPNU3S2Q4AzL0aZeBbpQEC7GxlrtmvWcamrtm+UihizZs8FJ9TBwURhhb8o0bARKl257kMrzD3vNllVhbFmp696N/RpNtOCzTZkvBY8cRypO65NqQm9lp19xGOwo/VZ8o2TUWS7fqzyknK9lXm0GDdNdZ3wq0ZUdsZiYPp+qFBWZcOkFVQKHa22exFfHYWfslQlo76yfV+Ynkdcy0GAWibZeOjVRaNblAL3QnYU+s8hZfwoIxBcqEhrHQ01SxxA9QCPAijwf7uJvd5oifVYLUlINuvnkebbQABtqVVHu/vvKT/tkiIQq5oPOQCGo5z7tXXIRRC9ZMW80iGOTt8X5BPwJC0QTRbqRTjoxlgmR0KZ9WVtLe5Xkpw//eQvc/nB9CQTTr7fsz3bYciT11fo73fkIQgJ8ZskBd+ZHkRNJC3Kh+3+tLUtJCIdr7OE1bq+hzwG5pBP6gxzxv36QHR+qK8/6m1NKv7xawhjP
 AWhsZs66
 qagavg9N1eUttk0lzYRtL3sK7QEFEwDHk9Eps7wn9ZVtEcD3RUJ+rjSyVXt/pn8x0mab+v/RQse2xsLr33XEYN3MX/pZF9olQf7f6uO/uDhdR2ScUSKJKQHn2FNGOVVPWS8yAep11nLgKkc/9aak83CQFgBBkIOVjuZVw97ACym28O4ZyMI8AzChS8hDAqS6DXPI7YHcC+kSnIRcd7dfmefNMdyH3NmHWcddcJwmqQ8Pu/uU9GSMYw799yNxAs/OnlJLtQR1O+blIDdVoK6+EoszTAWz6UvzsLn99GnXdBysCkEPHTx3YSuEcxLZjBwsIVJnqm1/xKw62XpHrE6VmFcPlGHJye4MgX6k8Z4OGF+z4frMAMIjxeiQQopJl1tSHGBq4f8iBjf9Uj5s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/25 20:37, Thadeu Lima de Souza Cascardo wrote:
> When OOM is triggered, it will show where the pages might be for each zone.
> When using zram, it might look like lots of pages are missing. After this
> patch, zspages are shown as below.

AFAIK zswap can also use zsmalloc so this would be reported for zswap with
the same effect too, right?

> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/show_mem.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 41999e94a56d..ecf20a93ea54 100644
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
> @@ -332,6 +333,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
>  			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
> +			K(zone_page_state(zone, NR_ZSPAGES)),
>  			K(zone->present_pages),
>  			K(zone_managed_pages(zone)),
>  			K(zone_page_state(zone, NR_MLOCK)),


