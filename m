Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 845A5CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC18A8E000C; Wed, 10 Sep 2025 10:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C980D6B0012; Wed, 10 Sep 2025 10:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4AE8E000C; Wed, 10 Sep 2025 10:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFECD6B0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:42:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6824B5BB84
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:42:50 +0000 (UTC)
X-FDA: 83873607300.20.F6D4933
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id EDE8740010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:42:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EB5K3b1+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c+WAJhnC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EB5K3b1+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c+WAJhnC;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757515368; a=rsa-sha256;
	cv=none;
	b=HmqZHUN7ix/i/eK3CiM3ZxaG52BBbCmcBhR4ZFhP/nW7SEC6fE8mCt7Bpo5fMBCgEg4K8n
	VUTDwy5H9xsTOBn2UYZwDU8GPhQqwYZrSkMsYQBAgoVjLGNrJPBStERdArFANrH8B/fv6L
	QdHT4ZWwlJpxEbEWDdwUEBlG/e7frko=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EB5K3b1+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c+WAJhnC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EB5K3b1+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c+WAJhnC;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYusQoj0b6uAWwLcgUDbLvCnL0yLNIA8kXNoBq28rzM=;
	b=c4VyasTsWjQ8xAe8wb6+EUSaTgTN6QoeMvJuqcrqwPge9CXpLgjBvt2gTQqPsKaoxuwlWk
	3YzKMabWlpKQgd2fkuKbxIn5OlFklq6tDRnffWU3IvtU3dNSJOhZQwsR/AnDhwk6bOpTEu
	z+LXQP//T8JDlexl+DtJiPWOvHTIEj8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9D1FF60221;
	Wed, 10 Sep 2025 14:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757515365; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYusQoj0b6uAWwLcgUDbLvCnL0yLNIA8kXNoBq28rzM=;
	b=EB5K3b1+4zTGftGbsozhXw2s2ZQJRmsXlzwZFwHGYX+R/MDJNzsIZ8LB0ruzegOsnj01g5
	5zSkuloS1UOTe0iaZlg2c4uh5c7Fhl8xZHLxj41pnMFByJyCCJ3cs9M+P96RmFg+2p2bnO
	dQ+py0bWx9mSNJm9vDRdbyfKk2pxWXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757515365;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYusQoj0b6uAWwLcgUDbLvCnL0yLNIA8kXNoBq28rzM=;
	b=c+WAJhnC7Ij7mdEgjkHaEI1Z2X8UbPQOJtG+0ZaIGzi0E5IXxBY6lZ79P8U6aWzM/07E32
	an2jL0KUY/EXxoDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757515365; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYusQoj0b6uAWwLcgUDbLvCnL0yLNIA8kXNoBq28rzM=;
	b=EB5K3b1+4zTGftGbsozhXw2s2ZQJRmsXlzwZFwHGYX+R/MDJNzsIZ8LB0ruzegOsnj01g5
	5zSkuloS1UOTe0iaZlg2c4uh5c7Fhl8xZHLxj41pnMFByJyCCJ3cs9M+P96RmFg+2p2bnO
	dQ+py0bWx9mSNJm9vDRdbyfKk2pxWXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757515365;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MYusQoj0b6uAWwLcgUDbLvCnL0yLNIA8kXNoBq28rzM=;
	b=c+WAJhnC7Ij7mdEgjkHaEI1Z2X8UbPQOJtG+0ZaIGzi0E5IXxBY6lZ79P8U6aWzM/07E32
	an2jL0KUY/EXxoDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8706713A54;
	Wed, 10 Sep 2025 14:42:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PrFxH2WOwWhkKAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 14:42:45 +0000
Message-ID: <836adaec-0316-4c48-9fde-406c6b95e12a@suse.cz>
Date: Wed, 10 Sep 2025 16:42:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: Constify compound_order() and page_size()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@redhat.com>
References: <20250910142923.2465470-1-willy@infradead.org>
 <20250910142923.2465470-2-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250910142923.2465470-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDE8740010
X-Stat-Signature: amddoo7k5jmfdgfscfbj7pie1idshuak
X-Rspam-User: 
X-HE-Tag: 1757515367-627744
X-HE-Meta: U2FsdGVkX1/oJUsO3CoET1ziwjwC5YXIcKswEEowo8tVG6ayKyO35ZSX/jpiZs4CXknVImmHFU163B3d/nxw0bu0PEOv4IOudTzy7W9UI9MVbcVUy8jafvVo9wpGVNyMzNa+ECYL6nuPlxZ2WXSd63AMB5/Ch16Yo2VpTSPJ7T8656ddvxlh0ysZQtBGnK5D562GlKzBUYp2XBsAAdUDGrg8A6Hg5C1SECzCFTHDIV5LyoFidi+4vvjJugiJSp9fRStVdrURe1VgKkhV4qfSIdIK6IjVnLzYClphy9d5SXSRHhu1Bz6mXEaZCRMeakGRiqNvBtNsd7883FEX34FvhaRmrHmbf+IzjJ3jVuSCHQ3wS3hrNjfkPa/aBz9CdKO3XuzqNg2AjK0nnQFQFTdWU/KgSp1l5p9e+/I62B+AWEjCwC881lZKeIsl9H4J2VEkc7S5NqDD6PpGskGfI1mv2Fr21vImy+gImM5zG1BLWw1dOjXeGdze5DdMVOwEr1JEwqsOHbXieacdqxV2ER1WSN+avsqvIr74pgNwH44Gr8Qnk17DFZX0CZwtZy7u27vfDXbAI4kTrocwjHONsIknXZ5hxvHdN+p20VJqjfAozBEOi2OfZO+nD18NIhjr+mTY6OWSgHEmXosz7ZREqrdmiXLVRq+bZF+AaP0zF4cloFghxUwBVAQdSDLpWM7rumIQcLr2WqgJjhlMhgoj1KCD7oltyQRsmhq9DwDl0BiBP5CEjdQ2t+OS48kXUFQSDAthiH9KWrSzb02c9ouxMZ73mXztvl5ac9A1ivq94ww6jp/BkEHF/wjZdulqI2gPEHvLeVmF9GHiRGE53i/+lYcRse8LY7PNn+TJqqS11spQguMljDfCs/7wjBlPuzQL5Lqu0DteXRD1yZ/6Nolk2bH0MoWJXjtpYb1UwuWRCI3SkM/iV062WpXCH1MTu6fSlfp3hQ1jvmj4Kqn4ywpEhlH
 bQLEOz9+
 ApXQlD+NkOwBdr49DORXr/4QRtTk07CtH3weNv5EKpfxQMh4ERVjIW/W/mdQNLMeE9VJ5rYJZb+AqrIRCJD4moKbf8ZVGAXHYTyPBO7DKBvyQ18CCe0GOp0ZkUIawBzdmWTEmobGigFey3QmkODi8nzUC7hcCODBIAbv5QEl2in3OQnUPb/H+x87pwkvZIG4fXOSeRBBjOhLodIzVUpSzz8y/BUmlbBdUPJ2eBvk90VxlEjLAEnkTC+w+bTUUbh1PEabTTMAyeVfTR3B5TQj4rvSc791prUEHPIZ+zJlNiPtaVziUROgVDCxA+/c3shWemx44jYM0NiL6n1L73AnwKa2Q0snynS+w5QtGDRk/9i7p3dqMn1bCZvhkSe5i7BVQTUhSr68JY3tzh5EaiXD6S6IsLfbPdf9vhuedWDHSF1l7D4YKnhtSqxsa3zBh8twc/yiv1ftd21Pn0SNpJWzroECq8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/25 16:29, Matthew Wilcox (Oracle) wrote:
> These functions do not modify their arguments.  Telling the compiler
> this may improve code generation, and allows us to pass const arguments
> from other functions.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/linux/mm.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 892fe5dbf9de..5ba30a8c6c6d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1036,9 +1036,9 @@ static inline long folio_large_nr_pages(const struct folio *folio)
>   * set before the order is initialised, or this may be a tail page.
>   * See compaction.c for some good examples.
>   */
> -static inline unsigned int compound_order(struct page *page)
> +static inline unsigned int compound_order(const struct page *page)
>  {
> -	struct folio *folio = (struct folio *)page;
> +	const struct folio *folio = (struct folio *)page;
>  
>  	if (!test_bit(PG_head, &folio->flags.f))
>  		return 0;
> @@ -1257,7 +1257,7 @@ int folio_mc_copy(struct folio *dst, struct folio *src);
>  unsigned long nr_free_buffer_pages(void);
>  
>  /* Returns the number of bytes in this potentially compound page. */
> -static inline unsigned long page_size(struct page *page)
> +static inline unsigned long page_size(const struct page *page)
>  {
>  	return PAGE_SIZE << compound_order(page);
>  }


