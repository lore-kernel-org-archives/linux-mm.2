Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA5B4C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3C36B0005; Mon, 29 Jun 2026 04:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94676B0088; Mon, 29 Jun 2026 04:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C976B008A; Mon, 29 Jun 2026 04:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 663356B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:15:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA187167F61
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:15:51 +0000 (UTC)
X-FDA: 84932241702.11.6479BBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 20B3240008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:15:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QBMPbCQv;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782720950;
	b=XBZu+bgvddentb7tnkVtcUMCd3nbAq0MWZOkIoV7VvbxmQ0Jy3wsDvOKE/uIWSvi9MPpjK
	+RSIIsovEoNUWs4lSH2roT260OqweFDrlzwR2R0MmD8j+BqXv81Qj0nQcI1R55mzwuUThN
	paYKDJezM+81sqWVW4Mv6NRtRRV/0T0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782720950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtMbXTDOfzndkZDer6uzHrvmb1CYxZ6yVGY/SmOu0IE=;
	b=iB7Brvbr5rdYheNi9G/J+1cf7LdLrzEy9I9oYiSLuOOHC4A5IbgZdPT+cHJfdonSlmXwf7
	BHaS3iXT/oqxIJmHvRKB4hyAop50JLYjP0fdb/8w8W1vn6gKN3JM60EqPCCbi7XmmY0cpT
	UcSYTHzLUiGFLH0Z0KIV+ZXprz9V8Kw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QBMPbCQv;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5AEB60008;
	Mon, 29 Jun 2026 08:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9735D1F000E9;
	Mon, 29 Jun 2026 08:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782720949;
	bh=JtMbXTDOfzndkZDer6uzHrvmb1CYxZ6yVGY/SmOu0IE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QBMPbCQvs8hYi+N2xX2u0QDcm1wrcGDS5O2DtLv065DQclG99S1G9A5HOq4J1OJwP
	 isEkn2hV9P3LbgfwQet+yfkqrMwb/pq45HV+O0r/ES7Eh9cTsvdDqOzm3HTgmpzSEs
	 RNY4dpenZXlcPovycZKcE5kcUP0PDqr8SYDaVaNnK8J+mISy8EDMblt3sNUa2Emc0P
	 66VhmyI95dDgAVtNcUiUMKNN0Qcy+ibLbD/WvKjOy3r/LfktR3w+D21HmkF3oIMBSz
	 eSccLWkHJMSEhSo2GPeiGCh0NCrNj5cbbl+iT4BhhF9d0b2Djqlf634fpD1O29TKye
	 0faJpaQAgxpVQ==
Message-ID: <2293328e-ae86-4568-9353-7f4d2cdfc415@kernel.org>
Date: Mon, 29 Jun 2026 10:15:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] mm/page_owner: drop redundant page_owner prefix
 from static symbols
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-7-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260626024550.25677-7-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: i9inh8w3b8x4rnt6ajyty4biocobno81
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20B3240008
X-HE-Tag: 1782720949-636889
X-HE-Meta: U2FsdGVkX19DgiWbi9jUQWHByKu0LAMWhPkU6GCnrEliEStjTKWLg1qfF3RIMPbfo5ITXBjgqc/I0JNI4Zxr0YCH6BKc883rNan0I3bFBR2ZICJuPTa2WWlJT6bOC7H8d6rCIf8XmY4Vb+5Np7n9TEuwJ7pUKlm9sW5Pypd0FRfvFdIrWIvix3Zdupb08r5pi88B8t1Yx9T4MSwXb4O6PMmb1yG3ski9cRDoz1hjeEEWTauTHn/SpzA+Zi1u9p69oyimQpLgHn6sRx0TkonXLOk8/pmM5uojEjMe+87UTPKkHeFl8xdUWMVTFU9vaO33Wp3BaSQmgFUr3U0fsJkFPOQy3UGPU0T7QlF8tdGg5YrQd74OQyYUIegMRlNeFwWthDzutbXw+T/ryaDuLjhQUWaZLkmUXepygKutxS6SQxjaUSgjnWdS2pbhRSN4cWo2ldFI3HpODLd1IMexeNqgNsyT7Dzj7DOIpi20vL+uQb2ilMCb5WP9vngpyPFh4cTl8DXxu4fEOVR9DSmKhqHP28dY+/iFBWwAvzvRWcxU3taYOeEaWWEx+SAUWbXvyOlIXnwU+HRtxDAJIYZ765YuyMJVvXThnBLQxaNg3IyoepZ0hfByoEw2aIbWsWd4pNOAPgWyZSzQMqH36XmlXKt6LDMN8bAQzMbu9Vn3yV9atcoGfcfGqbcOE3slK7ew+aV3agrAX9Jd4MppkVNGXqsa8wQsIEGWoIblv8SKg4L6PkpJaxfpA89xjoMPGQRQEoAdX2k9sgvAGRCjM1QNipJP418CnwFt5lyL2JgOlSWAI0cBXUT30SU37CatxWcWH2rr/qZkHJuOWpL66npWFsK9X7ua8zBa6KEiuDiNi+Ydu+JC2hx+AqOBAj0F8AJxtNWhJNFcrl77K3SuhbbnoK8139GehahyW4ukypVSUbsl5bWUMGXUrZksoh4TEfAmLz5p/lCNuPxPRbjRsjdwwMq
 /HKaX2d8
 VBs7JwG+4TMMqjHmTPtbNDoLbCsM/OwxGTJRxFxiuwxuQdjqwN1F8GI/WM/vynp2qzebCvIHm1lCcQQjoI9BIvPdbGtJNWCDrneaImb4O2hHtJVkx3KVRS9VqP4cbJYTa2L5deNi2Mdd5Bu9RJneQfBN51vpeE1s49IaNdHFK5s1ospOlE9Z/mo/td9Hf3NStJKz9BB6Crm9yZ0l/VUlVNHQ1g9UzTKI9gq2kGzLMIORHvtr4pKho6IWZmtJcXA6mOJTY2nMsMO5oxJ7Cz6yPi4gWgleKmKnS4dk1YLAIBs89XDo7JO8PFFMn6neOaGFeHaYukpO7nhHz5e0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 04:45, Ye Liu wrote:
> All of these symbols are file-scoped (static) in page_owner.c, so the
> page_owner_ prefix is pure noise.  Rename them to shorter, still-clear
> names:
> 
>   page_owner_stack_op      -> stack_op
>   page_owner_stack_open    -> stack_open
>   page_owner_stack_fops    -> stack_fops
>   page_owner_pages_threshold -> pages_threshold
>   page_owner_threshold_get -> threshold_get
>   page_owner_threshold_set -> threshold_set
>   page_owner_threshold_fops -> threshold_fops
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit:

> -static int page_owner_threshold_set(void *data, u64 val)
> +static int threshold_set(void *data, u64 val)
>  {
> -	WRITE_ONCE(page_owner_pages_threshold, val);
> +	WRITE_ONCE(pages_threshold, val);
>  	return 0;
>  }
>  
> -DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
> -			&page_owner_threshold_set, "%llu\n");
> -
> +DEFINE_SIMPLE_ATTRIBUTE(threshold_fops, &threshold_get,
> +			&threshold_set, "%llu\n");

We can now do make it a single line? 82 characters are fine unless hch sees
this. checkpatch now warns on 100 chars

>  
>  static int __init pageowner_init(void)
>  {
> @@ -999,17 +998,17 @@ static int __init pageowner_init(void)
>  	debugfs_create_file("show_stacks", 0400, dir,
>  			    (void *)(STACK_PRINT_FLAG_STACK |
>  				     STACK_PRINT_FLAG_PAGES),
> -			     &page_owner_stack_fops);
> +			     &stack_fops);
>  	debugfs_create_file("show_handles", 0400, dir,
>  			    (void *)(STACK_PRINT_FLAG_HANDLE |
>  				     STACK_PRINT_FLAG_PAGES),
> -			    &page_owner_stack_fops);
> +			    &stack_fops);
>  	debugfs_create_file("show_stacks_handles", 0400, dir,
>  			    (void *)(STACK_PRINT_FLAG_STACK |
>  				     STACK_PRINT_FLAG_HANDLE),
> -			    &page_owner_stack_fops);
> +			    &stack_fops);
>  	debugfs_create_file("count_threshold", 0600, dir, NULL,
> -			    &page_owner_threshold_fops);
> +			    &threshold_fops);
>  	return 0;
>  }
>  late_initcall(pageowner_init)


