Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 764E5CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21908E0011; Tue, 21 Oct 2025 05:03:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9A28E0002; Tue, 21 Oct 2025 05:03:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F458E0011; Tue, 21 Oct 2025 05:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A24778E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:03:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56DF6B96BD
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:03:49 +0000 (UTC)
X-FDA: 84021533778.13.8EB59A7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 026B6C0012
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:03:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="GfAX/Mth";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Q/XH1/u4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kc+TbWlQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Syw2dJrZ;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761037427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LZXPmKX/gRRxoSBj5vH62zLtNfruabEvHm6anVxTgE=;
	b=m0IITnu5IIgbnbw3FDMtDp5V70fhrqczGBN0sojZH0omG3xMHnra24ma+UvWgsR+zETgoT
	hxCJFF20zIinbMl5ZFQKBdd+5WGfOAyq81oSYo7JoocrNfOl+GUh9wvqLh8815xq2SlkaB
	ap8eDlYSVxyBi9bi1FiRWwy+CQX+mio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761037427; a=rsa-sha256;
	cv=none;
	b=oMf62rvQMKQCu0SfkR7mGBnsL2DWbELL0vi+9FR2qyP6t2pUiJoz3xtH3YcUnFjI0vR4tr
	JuCbiTokIazNDhYJpyvDdwp7pyyDSk2xtDyssIppFnNNopxwkITYvXPWYGuABlH/EGiWec
	O6nsqVjXqUEO8IVtGT5uqvqwyHL8pq8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="GfAX/Mth";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Q/XH1/u4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kc+TbWlQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Syw2dJrZ;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 467571F385;
	Tue, 21 Oct 2025 09:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761037421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7LZXPmKX/gRRxoSBj5vH62zLtNfruabEvHm6anVxTgE=;
	b=GfAX/MthUts357cXyDddYonMI5xsN4OkQx2iXEMCP+J5v+8MI6Rt0TaQJj3yFVtNF6KCbX
	TGSoBlWObEBkLQMkRr0chx5ncSUZrBblVM+OP3nbsPi+xUGxtEHLMhFvDONgJvJQciuos1
	d4p/EItc9iantnQT8cw03XsN9UAh59o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761037421;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7LZXPmKX/gRRxoSBj5vH62zLtNfruabEvHm6anVxTgE=;
	b=Q/XH1/u4PHcTmaghuEL6ZlMNUaYs76vGGeVHcydY9Cdu7EIUL15jiTMo3x7KmME/Lmnqp9
	f4UsK3fMAH8mhXCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761037417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7LZXPmKX/gRRxoSBj5vH62zLtNfruabEvHm6anVxTgE=;
	b=kc+TbWlQ06Pn0y/gGZVHbEGAz/O4mX/NtBTJvddliBvpOEL1M+JlPz5heADReSxFQTyYIn
	Va4dqgWioxHZJNWithIrQbTZaQGNGxw0y8Jt6es2T6BuROYetmMZhfxKVdMfFIBbskJ3lX
	d+Codu8yCyDme6581nW8LdBvgMGtlLg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761037417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7LZXPmKX/gRRxoSBj5vH62zLtNfruabEvHm6anVxTgE=;
	b=Syw2dJrZedtVYHZxqBZEZ0q6ABTJWyuKxWCyav92hgiYPEXaa777DScgVAFuiySXIYIZnK
	PlWhThSNKEMbyCBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B5C8139D2;
	Tue, 21 Oct 2025 09:03:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FLPnCWlM92jOMAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 21 Oct 2025 09:03:37 +0000
Message-ID: <b0c6c6d7-843a-48e9-bafc-f2595b059d32@suse.cz>
Date: Tue, 21 Oct 2025 11:03:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: Fix indentation in fold_diff function.
Content-Language: en-US
To: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 jinnasujing@gmail.com
References: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Stat-Signature: nug9bp48k5a1xz75isduo6ypxxajqpcq
X-Rspam-User: 
X-Rspamd-Queue-Id: 026B6C0012
X-HE-Tag: 1761037426-235231
X-HE-Meta: U2FsdGVkX1+36zA/BNXzM6YV6oshEQaP8pTOzwNAkexApKnFCLJ91cg/EoglNOQx4FjhmiDkojqVSQ7t0vzY5tvC0MSccLB0cydZLtIgK374DG4gNPN66kgJxnH6SDPdUR8nkGoIysBFNb83ynYJWaPaGQsynP4XxM42TyTGzZWhET0hkAj/02zZL4if+5PvCJiqJHt4sA/ZnmH1hld1WMEtjiYfbxXUK8Q8EPOstN96zt25Zk55hYgRU+fmyDE7cVgmEPmjIqj712UqSHySq+JICKaeV+lCdtaULAgp8XZqkEtshxLuYrijWHybTc+CIl6h0kPvQve0leOlJY5VwJQZSM1Swpgds/F8TElwtrBPaHX0TmPZJVyGR+kVruThgJ/yEOxj78ywpPHyENx6eZxXpRmghHA6pJbOUjAkU38vAQnxiarPgvCGoNCEbc1A9RoyvT1uN6y9In8zKIZcg4BIHOJptPeKWtISgI3tgRYFSXikYxqHkE1HZCqym8oRHO6yYUdWL13vbIDh/2yLzzNq/N97bPihSaHH0VG5U/qC0Y8gQKmnCCPTCdOCj/KBGQhUJJpeA7sItFOquUOCR1RiWSUT1eWIFemy15jJ9O/3Z+5G6WBMaL4o5SDb2IpZKaKz+cgfNxYtRkoTdaTQR3Bal3SlxYlJ0KLf4MiiKzsJyaY4c5G0moo/i5pK9CTKSXHfbakmhb8wlfX4fD8AqtNNi7dz+YmKw/EhvJ/fCUnw0lQIbXMmeOUmVr6lopBIQSTKQ+qf+jcCWusNaKfwYDM9TsIMzcRPwun/H3uI+KmBjQqdpleWpThhReorMP4/zfJgCbUTdkyitqpOEv+zm0eChFyCoxhx8wXzMr3VYPQ9LVAs17tSkLOHdzv+zmsJ9+WEXcHauz8JjD9KPOvL7pK3JwW+kyVMRAMeb9xJ9ispR2XuMHoRSLsrGGpjtLTNcm67GkdxFEzIrcyq2Br
 IpYFEWqN
 Ni/Zb9axSUodtwsxydMj4aJ52szIF4AR8/Ro2E8VBDGJFHaoE1U8Zwbu2ETD9tcgg0FQwvkb5Qr/o6GJu34GpW27wPal+VXPkkCWlldqHREKu3YscK5WrCTw7vAdsHegYEO9B0cYit/OUX7OmnRZBHzifhdDCFLhWPy2lcufPEhS2S9vvh9ocNpskHm3za2WxomFNuQD0x7RxZhR14YZ2s6l/pJJygDAX95OjnXb7mBjFdVQrIBe08EbnaeIBDdLCPaA0XVtY802L4u568Q8fFoGbL1OxRFsIQnrE0EpF7Ta79r3BhvcN5+E8iNJ0gkM31OzE5m4JH12RDICkiu18Zobw/dMehJ3xaIVQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/21/25 09:37, Jing Su wrote:
> Adjust misaligned braces in the fold_diff function to improve
> code readability and maintain consistent coding style.
> 
> Signed-off-by: Jing Su <jingsusu@didiglobal.com>
> ---
>  mm/vmstat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index bb09c032eecf..63860c3d22e6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -782,13 +782,13 @@ static int fold_diff(int *zone_diff, int *node_diff)
>  		if (zone_diff[i]) {
>  			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
>  			changes++;
> -	}
> +		}
>  
>  	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
>  		if (node_diff[i]) {
>  			atomic_long_add(node_diff[i], &vm_node_stat[i]);
>  			changes++;
> -	}
> +		}
>  	return changes;
>  }

Thanks. IMHO it would be even more readable if the for () also had {
}brackets.


