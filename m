Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA6DCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 10:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD6A8E0006; Tue,  9 Sep 2025 06:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6CE48E0001; Tue,  9 Sep 2025 06:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34BF8E0006; Tue,  9 Sep 2025 06:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE7748E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:29:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B4EC1DC5C4
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:29:01 +0000 (UTC)
X-FDA: 83869338882.17.3DCF0A5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0514140005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:28:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="rjEiP/Yi";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OhYsL34V;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="rjEiP/Yi";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OhYsL34V;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757413739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcgiYgKLCsMivPEp8vQa3zuszqAcHvhjqkBQVa8PslQ=;
	b=r1Jd7wuttBoPK5KFLAnZoQggWfMHCv4V78sus3n2u4BX0gBl97yBy02vcr8DV3t9LAMthu
	uEMVgNELOHeTWi5af3NY3PPqhLaKgtySp0lTw4gHXq0v2ghNtgQGvr7XZYRVrDd38+y3o6
	JWBdh/dFJPRNeKEanfUyd2/ysKtF8Vw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="rjEiP/Yi";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OhYsL34V;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="rjEiP/Yi";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OhYsL34V;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757413739; a=rsa-sha256;
	cv=none;
	b=c8HS05QfxqSsUtyM0/h/0C8kU6/rPdgtvY+tbXPgCYf5fhRKb4zb8m0mlhXTEOojlqWxLr
	niJMTnaHQLxF8Yf1atdqq6lqL0wPicDdRQRTHaOp3OHqRy4iiLxwhNK5oSx1vNXd4qX0YH
	RwWRE8EfqV7WbT601i3huSJLNewQMBo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 491801FF91;
	Tue,  9 Sep 2025 10:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757413736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tcgiYgKLCsMivPEp8vQa3zuszqAcHvhjqkBQVa8PslQ=;
	b=rjEiP/YisA8kF6hude9EUnMla1b66DZ0gvo71Ie4ej3yC//ZrA8Lcg5ruCpXn3opyIXIRC
	L3cq2BAqyFjbrsRWilyt4GEpWVTU7Nr2xzFo4JRhU+dB45NDiJv38OSim2QYurtssWt5lf
	IJ3X8k0Ul0fzdgAW5LeGmtypTfLlotg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757413736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tcgiYgKLCsMivPEp8vQa3zuszqAcHvhjqkBQVa8PslQ=;
	b=OhYsL34VnkU9EBucq3ZvVFpG3YR4QYW7NMVjD0uvvBVnXnajxcs1F/NDtC2+zLG99gX7Pv
	ASVa0S5V8VRWeHAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757413736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tcgiYgKLCsMivPEp8vQa3zuszqAcHvhjqkBQVa8PslQ=;
	b=rjEiP/YisA8kF6hude9EUnMla1b66DZ0gvo71Ie4ej3yC//ZrA8Lcg5ruCpXn3opyIXIRC
	L3cq2BAqyFjbrsRWilyt4GEpWVTU7Nr2xzFo4JRhU+dB45NDiJv38OSim2QYurtssWt5lf
	IJ3X8k0Ul0fzdgAW5LeGmtypTfLlotg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757413736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tcgiYgKLCsMivPEp8vQa3zuszqAcHvhjqkBQVa8PslQ=;
	b=OhYsL34VnkU9EBucq3ZvVFpG3YR4QYW7NMVjD0uvvBVnXnajxcs1F/NDtC2+zLG99gX7Pv
	ASVa0S5V8VRWeHAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29C3E13ABA;
	Tue,  9 Sep 2025 10:28:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LlEFCWgBwGjHIQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 09 Sep 2025 10:28:56 +0000
Message-ID: <e19ebca0-8327-4bd9-8952-c2ec1e57f75f@suse.cz>
Date: Tue, 9 Sep 2025 12:28:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add Jann Horn as rmap reviewer
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250908194959.820913-1-lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250908194959.820913-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0514140005
X-Stat-Signature: w8fkbaiw9s3gj45oi1bq9z7eykiaupjc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757413738-221761
X-HE-Meta: U2FsdGVkX1+A++2a7giiHdsV5DazmxVL+uSivzuMTEMHNVs06n18bFEJ3z6PXysZH/8bLaS8wScYhveGoJvocwRKrI8+BYQVGwXqheBUQTW53qCK9ozf5L7Eullsi9klGMgf1m9Rjzq5wJP0t9K5hmpDtq7JML9UtJHt39980RZ1BQlP5EqCsks9MFjG9yRET/8GpbmbpqHWf84dUU4wcsH6YzNP+2CORCullABY/l3nzGS2VgDIO6DW/qdvuEe1Uu3HQxbJ45FNRnGBPfUf07h2MTn8b2r8hbNprNPbhdiGcBFtB4bNpSdvkDNvr2eHJKDrUjNhQ2/FgE4F2Ws8R5CIDRb9bXM0oh0oPTqViY8Q7UkeJfs43+UQz8tnstncCU4fDZqxJ22UXMj8h5I87nJM3dwfvS+8w9VkBPBJ41nD7RUVzEfgTLhLiv9pl0zy0kux+6wz+RzAr8hKqi5QN3TkkpyJbb9bhYjbFZtnx+oLTpKuudjkEvmEicK8s1nwPLSNog8Gz8YqKnTfmJShrPLtBx+63ryPNgT55h/aYwNlJEB9duV73YMqjnOO5xLTQ89YNU6Qav4khFhqGETrTdzfHxnuGvONr6eOE113qw5WMuYtmOCrWYVZVR0neYWteKMTG0SPk7UQDiVqTHLDZ6B4kg/fq8saN3mV2jGVoMTdymX7Pk4tkUuVpxaIH+7qrpb9HaXY1pMOwUsLNl3MHMwBzAiUcRj9egkNylIlOaqmj0ZOyk4uJ5M9FDK8wGb2DHbkaUXKffBH9OeCp2ozNTWpVbFcoHCv48qSRVXO6i4OIUF39t/XiNd/uPk0HigrU50B0Ne0k+hM19EIJGpVoD+KoUCKOpLymevRmlzLtKOJ+eIX+sJcNqT2SK6UNg52QUpXHlK1ug1A0RQqJLMJZEv3Y7E/qapG0yuBAMmh3r80PWBpWP9OFhwJlnM0BgZNTCyk/mXvfDqT506IBAY
 5bpZtseJ
 J7J08Fst8+ruYbczzItM8fPb6H6U4UVbNT9urxPWUtlw2M/4gZoTC5QMCsk4ZQe1KQZ3PQzcz1WpsjRmHm1GRYr8X8DZnwLPCmzgmF8FrH6YVZwpKOVX4JG6KyyRB8IQchpNK7Kwy1vmKXE7e6I9c1shDDP7N1MD2F26zlYmBdquiLotsfzac2zuXSniOLv5Xe2IqB/9mx2OqMvVXoJc0xTOQH6fiXIdIMulpw/iy+354IusJz+JATj+5DwAaYJaTWvY8zZr46RweDjyBmJAjANqOYhWjCOMhL9acyLjL6PvwfM4RCVrX3y8jsyFjpbw6BQYQ/P9tNb7mIw3L/qqQZIi/vDiJXR+IXonubu1352xOBR/tVCyJUEmCsu0iAc5JYRjulYhLCdzfthi4VVJGXPuDUFeG1MlWUQ0DvzWmH1jspcHaIMxiibwbi53fSYZ3dHK8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/25 21:49, Lorenzo Stoakes wrote:
> Jann has been an excellent contributor in all areas of memory management,
> and has demonstrated great expertise in the reverse mapping.
> 
> It's therefore appropriate for him to become a reviewer.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
> I spoke to Jann off-list and he kindly agreed to become rmap reviewer :)
> 
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8fef05bc2224..ededb2cf8f9c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16198,6 +16198,7 @@ R:	Rik van Riel <riel@surriel.com>
>  R:	Liam R. Howlett <Liam.Howlett@oracle.com>
>  R:	Vlastimil Babka <vbabka@suse.cz>
>  R:	Harry Yoo <harry.yoo@oracle.com>
> +R:	Jann Horn <jannh@google.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	include/linux/rmap.h
> --
> 2.51.0


