Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C492ACA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24FCC8E0012; Wed, 10 Sep 2025 10:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227898E0001; Wed, 10 Sep 2025 10:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116A48E0012; Wed, 10 Sep 2025 10:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F21A78E000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:02:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8BE487178
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:02:34 +0000 (UTC)
X-FDA: 83873505828.13.A3595A8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 498344000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:02:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ihSWo0Dh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F29YYRaL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ihSWo0Dh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F29YYRaL;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757512952; a=rsa-sha256;
	cv=none;
	b=yOffZWDzh7/Ux6ER06ngRrMAAa3OqyAmHndayg8qcQ0E/ZS40XBW1SkeMwAgHpAfTrOzsk
	QuJYUu8Y4H9isYiYiGX+neZQU5kvBp9WGfzBJ/1ZtT0DQ+PGoA6uXu2N0PosbIc/TjA/Nt
	EGpY1cUGHk+/xLBl0k9sZpH4drFh/eA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ihSWo0Dh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F29YYRaL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ihSWo0Dh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F29YYRaL;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757512952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16dNb+mZufvfvrgtkkORy5ayUVM9XnSiELE3juK0z1c=;
	b=XZEdxiB5DR6RXSZfJMxHlX6mKXxhlfIUpk38WgykC+dOoc4A48InpvPeAfrCf5LdzNnV1s
	SWbQzsF6ckZOFMGKnTkJThI8jh+UtkInAMZzQh2h50cyR0la2oP5qA0be5QVVZPcRk88vi
	KBCUerClCuDqdLR/WSM/TJj1GhLBqT8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 532485C55E;
	Wed, 10 Sep 2025 14:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757512950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=16dNb+mZufvfvrgtkkORy5ayUVM9XnSiELE3juK0z1c=;
	b=ihSWo0DhXouYDM8zUJNYyJXtuDXgXPnX/EHcOntca52izaQLxczMRLIf9GHxdzr36fm6UB
	PXcvIgLRzhBbi/C765VWcJeKwPxL0SiBPnE/9Iya1L9qSBKRmdSgYAxa9Bf/5qC63+fzha
	B6OsOe6elhECuuzG502OlGa9iLVF18Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757512950;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=16dNb+mZufvfvrgtkkORy5ayUVM9XnSiELE3juK0z1c=;
	b=F29YYRaLS9L7fDH41ap2x+H7JVArFxYWdZ8kAF1iSQMoa4IUkyyc6gBsWgkRCfBAIDERSA
	FzmH6KdHSxibusDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757512950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=16dNb+mZufvfvrgtkkORy5ayUVM9XnSiELE3juK0z1c=;
	b=ihSWo0DhXouYDM8zUJNYyJXtuDXgXPnX/EHcOntca52izaQLxczMRLIf9GHxdzr36fm6UB
	PXcvIgLRzhBbi/C765VWcJeKwPxL0SiBPnE/9Iya1L9qSBKRmdSgYAxa9Bf/5qC63+fzha
	B6OsOe6elhECuuzG502OlGa9iLVF18Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757512950;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=16dNb+mZufvfvrgtkkORy5ayUVM9XnSiELE3juK0z1c=;
	b=F29YYRaLS9L7fDH41ap2x+H7JVArFxYWdZ8kAF1iSQMoa4IUkyyc6gBsWgkRCfBAIDERSA
	FzmH6KdHSxibusDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3CE7513310;
	Wed, 10 Sep 2025 14:02:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7s+RDvaEwWgNGwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 14:02:30 +0000
Message-ID: <0b6de70c-b38d-494f-a095-e0f854347ebb@suse.cz>
Date: Wed, 10 Sep 2025 16:02:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/22] mm: Remove redundant test in
 validate_page_before_insert()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
References: <20250910115507.1991829-1-willy@infradead.org>
 <20250910115507.1991829-23-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250910115507.1991829-23-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 498344000A
X-Stat-Signature: ftz9hyfhudfy4hkrac3ctw8t1qbi3ytf
X-Rspam-User: 
X-HE-Tag: 1757512951-818441
X-HE-Meta: U2FsdGVkX1+QyUHLONX7ZIUkfne45Jnx134Y8/JDRjBHy7ZF7UmQVlzKoOp6Av4UdMG5D3Ky6PC1TDiIDUpaHwwT3HJwilPIWay5dGEREHU76+/uY8l4rbjqC0QijVinSsiGENyH0JXR6TFyXA/S/FCdybQgYr+YYWouIm5haT0DVCsghsXX4jDro24fDWaKZRs1ZQN8+thRqs+IxipX1i++RBWDt6Exf5uuDqUhcY3oMvIyajLlwwkBTY0NyoBbDkt+rqYAFhApBg3Cm9f74fDbKpI7pA0o109XX6qxOAytvRDcfI6QnGKCfdIPn1r847+wUSPbXQf1UpZAmy4zEwaAY6vsqqM/rI7IKBGrWLUktJXRiGp/zCV8QkbPAUzvC5kiLu6kpcwaEe01qWgBqnWW4LXT4Vc4U5pF7MeEbPdsrc/2apzby3+nAMLWrHXubkuEijyTIt5Me38LBvyKdUQccrywI8ga6y7zvshSKNd6VHU/14IHwJwvR7fRWuFPtTBY9yUjRoAQsjUMK0bHu8IYbDl8UcUapo9EJ16XtQDfnpN6vg7TLLfpcqCL+GRynMe0W05XPs4CEnVPZw2GV8oYfsg2WEgwbupqM+yKdrCItItnOAS1bCVWo9SlNov+F5qKM/pJ041y7nja9bZzFUFoPKT8t8BpB+lAuxH+G9bHxVpWezIaKBtsnc2dhdyacfcBIPcLJWiUzrdWUpv8HOyXdZ+5Ng2X+kIU1ftBM6CfXufTI87RuevjAE2BJ4VuX3cz0hTl3Rzz5YUCrUapxsuELMZjtrexIZPCYN79d9rdjt+9DM+TpUbLLLmtG6f7PB+TM8YMQjwKWoXL6yPc3pN5kH0+Er6kAwQ/tZj/lFTsOIOMc4pBflD847UhSFn4aJ1G3x322Ygpg2dEl7qAfWSbVUQoG4ld4O0YhloPXetHHfdK5R9VGZ6++Yt5vaturPLF5PlEMpkJvJos8Jr
 R8nitK9R
 wpB8dnIMMNrwD8lfO1PiMZ8hfNrhF1fjzhOwxTLxqMkdHVwRIIlZH1uL/+Tj8xVDPCUeT82lb58/P1Tgf8zIdkz4l/AxrVtYy2ILqOSTIetRFE43xErx1p1BQzQR5/j67TTf2fWlS4iqrsavZLrxRFye+eBJ974FY17j+3JfCCV+0ArEwpeE/b8XQMK/JUhlq98QqrcCy5YcLguUOFQmRHGdq2gfbcHJ3WxOPZBMr2EIJydmg/F6nO2bZvcISyouH90K/UITVB928xuk8HYxe2fQsI9liEckUwZWL0BEMdPgRVFDGx7NkXxHbD79PoobkSDpE6R/qlnzOa+MrryhGYux2Tx9OP1eLXvvjBnwFr+VnNFzLWW8dzStpCvz1X1AzDP1PbBn4hnK+jZp5Ua9Jav+DL5hR1yMadpnUT3A0V5V5GCIhsuRO5oz7WyFNcPK7e6wQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 13:55, Matthew Wilcox (Oracle) wrote:
> The page_has_type() call would have included slab since commit
> 46df8e73a4a3 and now we don't even get that far because slab
> pages have a zero refcount since commit 9aec2fb0fd5e.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: David Hildenbrand <david@redhat.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/memory.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index d9de6c056179..cc9ba448a7dc 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2266,8 +2266,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
>  			return -EINVAL;
>  		return 0;
>  	}
> -	if (folio_test_anon(folio) || folio_test_slab(folio) ||
> -	    page_has_type(page))
> +	if (folio_test_anon(folio) || page_has_type(page))
>  		return -EINVAL;
>  	flush_dcache_folio(folio);
>  	return 0;


