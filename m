Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7D7CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D76F8E0016; Tue, 11 Nov 2025 04:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5884D8E0002; Tue, 11 Nov 2025 04:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44FA18E0016; Tue, 11 Nov 2025 04:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB098E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:16:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C662888E3B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:16:55 +0000 (UTC)
X-FDA: 84097771590.09.824A379
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5A35C1C000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:16:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="L3nW/fFa";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pTm6AU7L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="L3nW/fFa";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pTm6AU7L;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tITnDQcZwLtSq9sYlYGisYchpGvQH4gHZAxbZ0YeMQ=;
	b=LpVU1bjwZ8CLgUsfvUYOa6N2OW1p+eK2EZVZKSCWxbVRn12B7sujQTlOwPl0uQQZKf59pU
	G4NqZW6AI5nXNBCLlpfGNYR5U2U5N6L5k1eVa6OZhp9OD50xKnPAo9QxtzXVSJpSLec671
	7ZIjqUojFq7clC2CgFkUHGG5v78MVZc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="L3nW/fFa";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pTm6AU7L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="L3nW/fFa";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pTm6AU7L;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852613; a=rsa-sha256;
	cv=none;
	b=eOl0QImmdwuUFdFauDswIldiFi9rLtVsm54PR4UZd3j49CckbQuy5PJhQIKz8Yv7ECd5D1
	fNfH5bcLU4m0r6n1KW5JuHZBtm16yxg+hc72pYvvNbxr2iH1kiz9D10xDr801uFglMl3th
	Cf3MffD4DtLk2GZm0OiWhcmwLlTVeNw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A8FE1F456;
	Tue, 11 Nov 2025 09:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762852611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1tITnDQcZwLtSq9sYlYGisYchpGvQH4gHZAxbZ0YeMQ=;
	b=L3nW/fFaLv4zwDa72oYLR0sm1vPjqEBaO1aYN+GVSO8LonlDF7G5Ybn7MpW2YyAMl5kDM1
	YKVotafOkNeqk9qR6kf9vLFwySNiEx04FlKYzmfEltIrHasNCTHgvp9CitsbrJPQgu8XwH
	Q/yC8Dxn22wD4Q4as0b6FtsU4yljuH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762852611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1tITnDQcZwLtSq9sYlYGisYchpGvQH4gHZAxbZ0YeMQ=;
	b=pTm6AU7Lu55VgSXW+gkZS4jyRPHrv+gNJLEkyRcyjr6xGbxeecN6W2t2n0xeGPQej1hF7v
	9cIohtCC0UjvhHBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762852611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1tITnDQcZwLtSq9sYlYGisYchpGvQH4gHZAxbZ0YeMQ=;
	b=L3nW/fFaLv4zwDa72oYLR0sm1vPjqEBaO1aYN+GVSO8LonlDF7G5Ybn7MpW2YyAMl5kDM1
	YKVotafOkNeqk9qR6kf9vLFwySNiEx04FlKYzmfEltIrHasNCTHgvp9CitsbrJPQgu8XwH
	Q/yC8Dxn22wD4Q4as0b6FtsU4yljuH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762852611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1tITnDQcZwLtSq9sYlYGisYchpGvQH4gHZAxbZ0YeMQ=;
	b=pTm6AU7Lu55VgSXW+gkZS4jyRPHrv+gNJLEkyRcyjr6xGbxeecN6W2t2n0xeGPQej1hF7v
	9cIohtCC0UjvhHBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DC8B1489C;
	Tue, 11 Nov 2025 09:16:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c4vSDAP/EmnmYQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 11 Nov 2025 09:16:51 +0000
Message-ID: <bc419597-238f-4858-bdd3-98b752312c27@suse.cz>
Date: Tue, 11 Nov 2025 10:16:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: Use vma_start_write_killable() in dup_mmap()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
 Chris Li <chriscli@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20251110203204.1454057-1-willy@infradead.org>
 <20251110203204.1454057-3-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251110203204.1454057-3-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5A35C1C000C
X-Stat-Signature: a49guq4ya484gy9weggo66b5xkkzstbj
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762852613-262334
X-HE-Meta: U2FsdGVkX19wOovCs3Ih4tbYkCybsKDaJPp1e5PNDinTxhOd+AlV8e62TRZNt+Ww9rmR5ObXzpz+kzZghhRkJhKMaiL4sMhTReVz9ytTn44MgIn5pcu0F1l8ZIElSCWHBeQYsoxjleCHHrnNGGkgBUW8yVx5lV2T2l7MuXF8w0QeG316M7DSKulZ0aeo83IeMEUdBExipbWgh9ncpUdrrqUqKkq9ezFxzbsapbReiLyf46h008B5t8fcS3JMLhG4p63x4SGMZ+Kjbtt3LKSnyISVFQpeURKPbpaeRCdn19u/FDpSvTIou5qmjdZUZ9drJD24WEJXFh9kz5qpg62Pg8NkOSvHx+Y2Hbf2ktAUJXX8B3SUHmTcdGdHYcYKiaQnMZalPNkfjz2EhdCjazl4BkytMJeNclJRNr6yINxmeNUJJC1RSRNOzA+NXCUJDKbPgTIpeqcYvrPXWmihKIvWeQKktDgB0sprXFcK/kP1CaWXeVAP4XAq+II7Fv6lVxmZVWxfS4qu0oxm+i3Zppy+c+JOBCAHdyOUMco3SfUg3dZvibpS/kOpzB1HMG6y4EqsbONIgJOGARX9dnYHLCdJh9b2afPzboQgZjNnYaoK+lqee6m2pnrkhootJHdR00U1zlPJW92yAjplIRl6HfM3tG2JPCj1Dn6Y2SL2EZ2Fl5pN6rMK71GKTDr9kuVfDW38EgGFI+eNYEEc95Q35UsrLRy5mDRPkXtt6mCX05VIQtXIYnVyIgqpqFo3CTv3t0/KMWnH99yz+oknB+cCc6umBWe59RSNB30JY7YUd5/KtwpHR0niO7HTaVtBgwrVfWhSh/WBkyQxRDGcV9S7EQXA8pxHQKGbBHe2VRQTegnuBEpuhjWrCbGQCIGFxaChlxLvlCQrY1SiKK2pMLOsy+8JOwFMqySTh+ZlIIYfXHR52aw3Fa6PzQ+2BYtugeLOUtHmvZZirEDCeFjNzjtPYIN
 eg6G2ui9
 uHQq2GmA70O2eMuTn4vK8xBdlRNP4J+jv4lb+qj6JhIz3dFktNNB1OjTMtLaHMycQQDJ0AsigfuZvxbzmWFBxV6l7UnxPp59IC0RBgyRmFdUba+GwIScKUhBwmVHDdjKEksT6qT4JJkqKI9Xu2PqsqvYHmPTkfdMO3XZVmXg3fRaGyqSkZgjY+N45m8wOzS0dJ2Bm91xFM/UywtwCMCHibCzIUWuZlCTwXuaTdUR4VZQE4X3v5aqOtJT9yCUnADAPWamparSDxrtCWzVIX5KTWZF7U+VaYX9Az8/Lsw/Nnpfg5jPA/tf1iiBIrO23+v4qkxK5smy6iV89yyDGqIVLyQ4oQq3mWIC3ERI/JHSmCNaXW05azgSnSTdup8PN2yFHra07ShMQCRwY2M9BGhxmjO2ovmSWIn17FHu2MyuGwTeshJ+z9qlJjeGKAmZjDa1WQ4sjC0fCy+hfH7KmBh5ExTPitD7dYtEvmLPb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 21:32, Matthew Wilcox (Oracle) wrote:
> Allow waiting for the VMA write lock to be interrupted by fatal signals.
> The explicit check for fatal_signal_pending() can be removed as it
> is checked during vma_start_write_killable().  Improves the latency
> of killing the task as we do not wait for the reader to finish before
> checking for signals.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/mmap.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 5fd3b80fda1d..03773fe777b7 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1750,7 +1750,9 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  	for_each_vma(vmi, mpnt) {
>  		struct file *file;
>  
> -		vma_start_write(mpnt);
> +		retval = vma_start_write_killable(mpnt);
> +		if (retval < 0)
> +			goto loop_out;
>  		if (mpnt->vm_flags & VM_DONTCOPY) {
>  			retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
>  						    mpnt->vm_end, GFP_KERNEL);
> @@ -1761,14 +1763,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  			continue;
>  		}
>  		charge = 0;
> -		/*
> -		 * Don't duplicate many vmas if we've been oom-killed (for
> -		 * example)
> -		 */
> -		if (fatal_signal_pending(current)) {
> -			retval = -EINTR;
> -			goto loop_out;
> -		}
>  		if (mpnt->vm_flags & VM_ACCOUNT) {
>  			unsigned long len = vma_pages(mpnt);
>  


