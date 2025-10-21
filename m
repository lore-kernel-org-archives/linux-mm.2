Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB353CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 20:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCDDC8E0003; Tue, 21 Oct 2025 16:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57878E0002; Tue, 21 Oct 2025 16:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F228E0003; Tue, 21 Oct 2025 16:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD31B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:14:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F5CA889FA
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:14:19 +0000 (UTC)
X-FDA: 84023223438.09.AA1DE52
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 78CE9100010
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:14:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gxLKS5lV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="YW/qRPUi";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="m/o/PBYg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cJti93ZY;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761077657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X80t4PTeyaiF1GwIIRh3Q3fJlZo/HhmWMgJCqgv08nk=;
	b=v+EdBsh9X7CmEVNq79VGuzMN6g43HRBRFzwRtE+CJXCdZ1yidD9ChuGmq+pjWMTBAJFxIu
	Wbs5o3f6uNgZjXf+fAHLuF2sPEelzEO93t0voSEPerWB3FhmMjiOGm5Nv9pfTneLzvvP6J
	Bh+YdFxm031aaoskaTIfaxOBti5K6bc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gxLKS5lV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="YW/qRPUi";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="m/o/PBYg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cJti93ZY;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761077657; a=rsa-sha256;
	cv=none;
	b=wi4E/taPQYJ9AdGI81VrSMZ38UpByzynvZHtZqh+0/nKEj5ji6ZvxgiS5l0tECw0sTQz4K
	ZGaYEzyaLL0Gp4M9XAp6MLlbyknEH+uU+74wzsFECkr210oNWbm/u1DkwwbzzFnxd/tvPP
	37CwfO4Bj/wcVb70uz2TQV8wPlGdN6g=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 84A701F38D;
	Tue, 21 Oct 2025 20:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761077650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X80t4PTeyaiF1GwIIRh3Q3fJlZo/HhmWMgJCqgv08nk=;
	b=gxLKS5lVMkF8Mn/lYdQIe2P5kjop4LLkWUFBp3+tg74dU1Erdvbt9kiBErcyUkr8GhPjm2
	/Dkg6Rph7bJl6hL0+rfkP/DkvVxs3Pbw9z6z3gdeIXi5xMVAvZynK99SwOUNsIEiIwV3q2
	PaE+SSj5EBpMrZx2vpBOpyGvEyPwZsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761077650;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X80t4PTeyaiF1GwIIRh3Q3fJlZo/HhmWMgJCqgv08nk=;
	b=YW/qRPUifuq99yW2pPkvIes3WOFd6WC0mQN+abz9RhVeh07sX9YsiAIdMMWTBGvIeLqXs8
	FRoRGeSOEY5hCYBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761077646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X80t4PTeyaiF1GwIIRh3Q3fJlZo/HhmWMgJCqgv08nk=;
	b=m/o/PBYgKg2geRaXYvtpGouwo78djKEftEe01eZenTU/MVzdsU8zxgSXtL9ECK3hPc1KjW
	bONDP2CuI4RS4PpV9xhHFGvVpGGYIn5T125vZHmgWTb6sodiAYo7REOoojF1dW31OKUh3v
	C80B0nPld45RaR3SmtXFpvz8sBbubIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761077646;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X80t4PTeyaiF1GwIIRh3Q3fJlZo/HhmWMgJCqgv08nk=;
	b=cJti93ZYPlCz+bDlE3jAO1p5UBTHUby/74EcmIJ2kqU8udNWkVPgct+NR3plOxIjL0R0ir
	PsOjBji1D4d6aEDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63ABA139B1;
	Tue, 21 Oct 2025 20:14:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5RyPF47p92h4NQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 21 Oct 2025 20:14:06 +0000
Message-ID: <78f746b4-24a4-4006-883b-a8a0c341dc72@suse.cz>
Date: Tue, 21 Oct 2025 22:14:06 +0200
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 78CE9100010
X-Stat-Signature: a17a6g1nfx4q3jkisqgnqz7k9gmhn4dz
X-Rspam-User: 
X-HE-Tag: 1761077656-362755
X-HE-Meta: U2FsdGVkX1+EmW8efYiSjnTEVAwY1thrhSYUrd6clbNtOOt7jw0ppKnX9ga1J1nqL7eTInnKMTnHHdwjIxND1k9jQfkFQuuFUEr1IrSuXY9mSbfqralWqNmxmzoaho9E/141EmS3WbCD6sw+IUbaftu1BnvTCDPMb1OUBHoek9q0o/3fK1D3hUrrLLD8+9L6CU7lcfNB184BxlfrUJhMMFQCJpVZeLQ2Ox60BwU90WjQkKJcA4F77mF01gIX3cc3OfdlHsgVehZgWIYRVkcPWMSTL5lKiWFhUBimB0ZwouaDWu9tHkZF7P7cM0RElctZmuvdiHaa1GAfCa8vTLcg9hVKhxWq32j+cYgRguyxPBGXcpFXbm27/jD6Opjizdde6L+U0MaT2177ydDzkkeSwdbqwcbX0jcgra0brSp/oFg7ig8ZAVWUV8PuDg/bNl+Wj4QfQKPFjjfIwzyOmxbLBQr6QuqVEedUwcPTO2vsWWrnAKAE5crsB0V9yysuEVeWsx5NXFROZsQhgVWORZeQC4jV+oKLHj442alN7s8HFp9GZfWgZwS42u9FKmPOqtbZz7bKoCual0LUkWmhIyoOILclCCi32w79g6lzT0ZSw784RBk8MnWIRc2ttoL0GzRSpQ8iPHaMG7AeLrBOf3RuoeoJZg8Htmzc45dkU2NGcPLR7Bc81XVUpGCE+kVySqS365eymY7gWaWHU+w7CTbDxvWGktdZbblNrLXXV/guqZJZK7enIwz+YQuURNa0UZQyhGWsyY+9PcFKI4wbE4kVB2xHLj+lUmVr95Kpz6Wlsnl6ITdiPdbH+UIHTUE91scKLz+d/WkdAmC8tOqJO21GwgXykd3r0/nQi65djQJR0Z9MgjXFi0nIf1bzRupiF1vhTP8MXr/muC+1XYXcCHlG8qjndgZeNqrHSglUuM1oanu3Hd3HW9GzdvzaeaOkRVhoHQlKwQwUHEaWNqDvVSn
 I5k+HC/1
 ZbrnQn2ES60UzDPzfJSAbcN9aROI5Ymlz5GgRasHPGgq0DUdUz203BgH9feyLGOeBwQ16tQD8wldPkfxGuvn+uHo6qHE8x5S6KgWWGn0nNe0Vfr6JuuVM9E8Z45nI/Us7FfKt/t/chPdb7V5ndyaub92OGzhsNERpW8+yA8qxslZsps5tZqhf1D7YlN+6WXn9FhToQY2dEEV5o6zy5ZNwwQkbPthSUUk564+ElyJwwYUo99SKgpKwy7NefW/cR/KKa89hVeYZd3YVJbydDOiqwgt3uaPBiziYuJDeS2mlWpgMK6ywfsh1jYZ6CS0xtXbcUD1Tp0aHR+a19bjeVVKsY61hyFiUnJ3/w/jk
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

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Thanks Andrew for adding extra brackets fixup.

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
>  


