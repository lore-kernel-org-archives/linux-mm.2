Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F18CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762936B0469; Mon,  1 Jun 2026 12:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739DA6B046B; Mon,  1 Jun 2026 12:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6504F6B046C; Mon,  1 Jun 2026 12:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 530726B0469
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:25:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20D901C1E40
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:34 +0000 (UTC)
X-FDA: 84831869388.09.579DAD0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 032602000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RzPOoSO3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pPzpwVgU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RzPOoSO3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pPzpwVgU;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780331132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2CzP0iLnWKcwILC9jm502jdM9oamk+/w4JeVs2q8ZI=;
	b=gan2WyHXYGkAEi+h1VhbOSNgae0+hHKt2Lg1lrtcP3ho/E29h07VW5Gq24nzhR8oULOLwj
	E6tW9JKpvg72tdIzUmR89DesndJDpg8wAVSaUGWcLUupV2tAaJMwOuls/bZU1USKYQZuYP
	8yV36UCRKwk177ZW7BlZSp6xyxNbRy4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RzPOoSO3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pPzpwVgU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RzPOoSO3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pPzpwVgU;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780331132;
	b=q6KgREU5rlayv7tPljwpHn1MqnPp8HMPfDPafaFti4fkwhbqfZT1cTwpfmoTV0oM7ZUjnj
	KF86/jeYsvDFYFvqtvJpsJ8tCdHLF0fiOMZEBXrNALJTC/l57H8K2TRxJ8xNHtFsGBo62y
	0W+DrzNAVaTa57+7fy//XXj8KUkg0bY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6BACF6AF4D;
	Mon,  1 Jun 2026 16:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780331130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2CzP0iLnWKcwILC9jm502jdM9oamk+/w4JeVs2q8ZI=;
	b=RzPOoSO3L1vuAhLOAMa3Pdxk8vKYyp0ri82h1tkkIww02gN0oXb7cM98fRag5Cc0LSyv1m
	R1dAZ4O/C9cI6xdPNwhbG62sJMzeadPXEWGVRaBZ9no2a6K0DBCH+hN0WM9yQ4VCu+5whR
	J9wo7NpgnRvFrxH07JM1wnd1vunZywU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780331130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2CzP0iLnWKcwILC9jm502jdM9oamk+/w4JeVs2q8ZI=;
	b=pPzpwVgUFKCC16upKhxX1Kx8vfZGoOHR8Cs0MCMiO2a0Ozsw9LB3WuN64Z/+97NNX3srEq
	MFQ0BO3vQ5ha/aAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780331130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2CzP0iLnWKcwILC9jm502jdM9oamk+/w4JeVs2q8ZI=;
	b=RzPOoSO3L1vuAhLOAMa3Pdxk8vKYyp0ri82h1tkkIww02gN0oXb7cM98fRag5Cc0LSyv1m
	R1dAZ4O/C9cI6xdPNwhbG62sJMzeadPXEWGVRaBZ9no2a6K0DBCH+hN0WM9yQ4VCu+5whR
	J9wo7NpgnRvFrxH07JM1wnd1vunZywU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780331130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2CzP0iLnWKcwILC9jm502jdM9oamk+/w4JeVs2q8ZI=;
	b=pPzpwVgUFKCC16upKhxX1Kx8vfZGoOHR8Cs0MCMiO2a0Ozsw9LB3WuN64Z/+97NNX3srEq
	MFQ0BO3vQ5ha/aAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5BFAB779A7;
	Mon,  1 Jun 2026 16:25:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BF/xFXqyHWqleAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 01 Jun 2026 16:25:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CE74EA0EC0; Mon, 01 Jun 2026 18:25:25 +0200 (CEST)
Date: Mon, 1 Jun 2026 18:25:25 +0200
From: Jan Kara <jack@suse.cz>
To: tanze <tanze@kylinos.cn>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, willy@infradead.org, akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH v1] mm/filemap: use folio_next_index() for start
Message-ID: <bzmte6yvhabfy6hvv3gln35b7aujhs3kxgaeenvpctfxqisvig@falgc3o6bhvz>
References: <20260601110425.44784-1-tanze@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601110425.44784-1-tanze@kylinos.cn>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 032602000C
X-Rspam-User: 
X-Stat-Signature: z45ri8p7df5cngig7m5d1pw9193irzwm
X-Rspamd-Server: rspam09
X-HE-Tag: 1780331131-146346
X-HE-Meta: U2FsdGVkX18b474Oh/1maC91eC0xt3enz1zfnmfTIzxqEgUkCaXSGOdpGZdaBHty8lVrtmxOAMBSmPGFrk8O383WlDNJTuEP9LCludWizr3K8rj+b4l19k6KwmtPmHxopSZ6KyfLQNsBKwRp+LGEo3iVOTcE2n8nhQawr+UJ02roupR7yZ2tV5UqkKY30zhWzuewfzb3MQKNINYW1MczLI5kI3mpu35yiL3IupE7KeChtyPpMWN0fx6pwOrSkeeFuDg/iQBk9TrwD/md7EcpO+M/ExRnehe9UDnQ4uL4KytuiCg+LqxWOdE1SSEEtnqvls02x6CZ+goKbVBMUG7z9WdXljpSbWKymJN1ZVtsGB8WRCF5vyf0gfKVl2yU1nYhqDMnR2079X3cOsyy9vnpxkbLP/cSCCu4DyjUlG1UoIrjzpvcermufgGCaj42+fdv+NK71rVEWrzYmoboz4Jen0kU2O+ymRV+Ce+BAkWn9YzFWQ1vICs08WRq0VAqjsVFe4N0zwC4eVNnQBCiBgnN/eoqTx2lo5xvNLUHgfBn041M71zS8Q4tXeanCuACWA/ZpYibghil+OWxVLTTxPPwSOVukkKyFIRMyuCHJtgz4Tk+PQbemGxtE2hDSzEysBDjs7rmlH+WpbbMYX44Bw3xWqiQyxjbMlCaVB6CfY1KoEqMYWhYtQA9vdUdD2Zhy01Gn/xemJYjERiie61n7NSNS+Z+hk/iqt2CNk9tnUWHVEyA6AjE3HNmEUUNh/jZvvckn372g+ubwpQEmMIb2a4eaaQyEZkjGHQvWUcoVCkuzf6EHUzdOyivLOQ4L+j1TbBhU4EhaTM6Pz7v3BAnaHSBhhDwFpN9lBZhl4RT7tei02HfD/TAzlW8kp0tfUDmoSrSUl9hOuKkSzPlgvXGaMQPFt06RPRZjXvnhd7c0/rtiaiNVC1e/Q6bubIJGCFt1SCMu3Nhjsk64sKpSaKbozB
 hlPZBHPO
 d7+B8Tgvb7BK0X3hVlOimXjVXRb7T7yoD4qCveqET8zRLtevFG+6xF273opTqINwgi2H9jt58m1Qqp//5vUxPYB6PZkAUhdrb5OwKUJyfC41NU5PzejAgf/L24WmuwdhMP47rGfMgiXl/hEsVm7SCI/v4L234/mSsu3m2VtEM7h1t73PBuXBuyzpn729s3j02iGYxmIsNIva6rZiaNbcyL+IYgWVAprlIeqD1EoqocR0jf/bHFTDpc8Nn4TcXM5q18w8xLhVO0d4+gjMzs4XElZ/Ugr4eNtyYYR/5zcwYXFDcsFCBp4lmJN+y9Fw3Yv8slB2Swpi/p5cdn/U6bOp2XzurGAo2+MDRumPpYgpZO//SsRu+OV+QctR3M/boywBGGfEARvl4r5DkfChNCXPWY3pvHQe3W5ErN4iCp6bRrVKsNtBJvOjgOFiGEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 01-06-26 19:04:23, tanze wrote:
> Use folio_next_index() instead of open-coding
> folio->index + folio_nr_pages(folio) when updating @start in
> filemap_get_folios_contig(), filemap_get_folios_tag(), and
> filemap_get_folios_dirty().
> 
> Signed-off-by: tanze <tanze@kylinos.cn>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c..e233d4a003ce 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2283,8 +2283,7 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
>  			goto put_folio;
>  
>  		if (!folio_batch_add(fbatch, folio)) {
> -			nr = folio_nr_pages(folio);
> -			*start = folio->index + nr;
> +			*start = folio_next_index(folio);
>  			goto out;
>  		}
>  		xas_advance(&xas, folio_next_index(folio) - 1);
> @@ -2344,8 +2343,7 @@ unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
>  		if (xa_is_value(folio))
>  			continue;
>  		if (!folio_batch_add(fbatch, folio)) {
> -			unsigned long nr = folio_nr_pages(folio);
> -			*start = folio->index + nr;
> +			*start = folio_next_index(folio);
>  			goto out;
>  		}
>  	}
> @@ -2403,8 +2401,7 @@ unsigned filemap_get_folios_dirty(struct address_space *mapping, pgoff_t *start,
>  			}
>  		}
>  		if (!folio_batch_add(fbatch, folio)) {
> -			unsigned long nr = folio_nr_pages(folio);
> -			*start = folio->index + nr;
> +			*start = folio_next_index(folio);
>  			goto out;
>  		}
>  	}
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

