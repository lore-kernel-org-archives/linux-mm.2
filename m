Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFC7CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780648E0010; Tue,  2 Sep 2025 06:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730C98E0001; Tue,  2 Sep 2025 06:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6475E8E0010; Tue,  2 Sep 2025 06:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50A7F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:42:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3F1A160B9B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:42:46 +0000 (UTC)
X-FDA: 83843971932.26.29FD377
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 92A19100005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:42:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QRUmkwpA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TUsTzDZr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kGyDGDDi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="gyxnb/K8";
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756809765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3zSePqDAkVqyg+t6w7RTiow9puJpMOh9QC/ozrDcc0=;
	b=X3+ljQeU+bnZ8oSNPIOuIGBrwPJkaQgHPSUNKHw2c8Ie2XDDx/Ce2DHLqxJaegh9cFBC3U
	n+H4R65Sp6jA2rU1EqIVNNBeckbU94LWCR/0zab8rJAnmOWLhwYOvh6vCzRRGzOxOjnWpp
	4omSW0ajxzsI6boULv9C73pUVTSJ8xg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QRUmkwpA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TUsTzDZr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kGyDGDDi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="gyxnb/K8";
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756809765; a=rsa-sha256;
	cv=none;
	b=3BbNA5NgaISv30tRNU7znEC/LH+ze0M4vbMf+0ViGnRyaY8YWBd0WikUS6D8LvEH3kfTD2
	5FParOp0i1Tpif96acjZ4Jf81aBVcHSroQtLguo3K1uWcVg2mscHuUHROaPEj6F7xAhtwE
	0y5UC27UHcwpRp/T6C9RCNGzE1UjWqU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E9A1E1F453;
	Tue,  2 Sep 2025 10:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756809762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k3zSePqDAkVqyg+t6w7RTiow9puJpMOh9QC/ozrDcc0=;
	b=QRUmkwpArdhTbNMW+Io/jMFV4GENVLwP5OHktiXSjl/Ix2NbYJ9TeSV5VyqEPd6TSXyj0P
	Bcc+H1TEvhq+wfhDIVWlzoBBwW97Alwbp1QJLDuqGihyYfWbRLDfjGJ4F44dQBjviGnP6z
	AcBQ5gaDyFoeif4IryqBICTRHB9CXDA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756809762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k3zSePqDAkVqyg+t6w7RTiow9puJpMOh9QC/ozrDcc0=;
	b=TUsTzDZrR69YtKKGNv1RU1qMGCsg4wLk1eA63bMaUlLDeDLntI7Mjg45Grtcmtws3qxrrK
	S1LON5SOoNptTrDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756809761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k3zSePqDAkVqyg+t6w7RTiow9puJpMOh9QC/ozrDcc0=;
	b=kGyDGDDiP05lJDLmtyi69PtDMbNE+Kd3vh76dgUH+c8oALJYaj4TlfqtEG5lcTlvNjDTUJ
	bh9uWraEvnMG1z5yGw3QiwbPybEJuk/t++v2WZ01Gpc9Ljq2/ZoF8SZGeqQ90yo6fFqQ8B
	igBA6sXj+xguQIHpiLao++P/lUTtuio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756809761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k3zSePqDAkVqyg+t6w7RTiow9puJpMOh9QC/ozrDcc0=;
	b=gyxnb/K8sQWXU2NS6ZcuZPBsUksMD1bPeddgYsEo2pCSweSudePJn2vKYmIKLqP7ENJkGy
	GSMzfA0XnTC/a2DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAD3913888;
	Tue,  2 Sep 2025 10:42:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4o5nNSHKtmgcJQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 02 Sep 2025 10:42:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 956B3A0A9F; Tue,  2 Sep 2025 12:42:41 +0200 (CEST)
Date: Tue, 2 Sep 2025 12:42:41 +0200
From: Jan Kara <jack@suse.cz>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net, 
	jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, rientjes@google.com, 
	shakeel.butt@linux.dev, thuth@redhat.com, broonie@kernel.org, osalvador@suse.de, 
	jfalempe@redhat.com, mpe@ellerman.id.au, nysal@linux.ibm.com, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 04/12] fs: constify mapping related test functions for
 improved const-correctness
Message-ID: <xn6tybxhnrswd5wnhfkt4h2n7romogag2ls7ehzte4r2oxoe6u@4pa7726gzcgj>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
 <20250901205021.3573313-5-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901205021.3573313-5-max.kellermann@ionos.com>
X-Stat-Signature: bgsp6qm6q3kxag7jpunjo1zwp4knosw7
X-Rspam-User: 
X-Rspamd-Queue-Id: 92A19100005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756809764-739140
X-HE-Meta: U2FsdGVkX195jhAseR3fYWNI8r4WWCtHP99GEbb6agv6nIE9SYcrMh39GW6HdW2IjPfGZFWUqeNRXDDN0DNPED4mI+eUMiqreM4uNCBwoxXNdVr0K0up86Ua6acs9Dz3PR/w/RzfpsVcCi8oNjOdAeospr69cQzS/BvSmbYEY2dhbVhTo6s7Dux0b3ZNYE1TrJxGrJ8LCWUdFI7rw6C1HIJU06a9QTKNr1dlONZaGkr84Cbg4Lq7I+Y6l7IlyITzhFCJd4sAurJjDvIPjrDVTEeluppwwbIAAaS0wB/yH4NfbUmPZCl3/74ereLXk5DoVRc2wqqs+j2D+TU1rAEyTZH4sbRpybkRivRpB+QCYVOvAJ392xHI8tuDAvSGiNa+byzIWKlI75dLS4b26UbnWdkCsrL0Ce6WnbhZjoj8Xuu+r7qFyluG1IuOS2rvkP+MGoLWiisjEUy34EMxU/lT1S0rzKr0fasVTbU5SaHdBVKMnfDyNVH+ve7YB3+k4WZS7gahYpOK34d4g4JVsCO4XOeJjgwI7TNJLAKu1vP3/LAD3DnOY4j+2bzBtUjGpsH5QGgZYPhuzfQdD/FagE4uPZhjw9WxvLsOSs1PNGq2i2hqrDUn4EMHeglBJKmvndfoz7hDGPZq63gcLiJWawzoAELqiZ2tkhF8/spINKbnsCCY0qhRRYiQ3OpgOo9EJ101ORYVsNP7tOlNtsManPW4a0SNP3somgPa0huSX+6/Kow3GvltyzcCMCcILWClZWWitNPTbs4ovq4tJeE/cYH7QBIRu0W6Mi4h6rBO5DeAodORkCz1VdVVZ2YWgWz5BUXJB4UHcjfMRGxA93qhwtxzwONAuZpLXKnv/HHdGIRyYj6veD4k2fdB1DV/nGUJYkYe4+a5Lp25WpUxajogRzbR4vXWyNknHasNwwDGSRMVH2fErPdykt1TMGIb2LfRIkgKLmg2FAIJga95kaKt5y7
 LFvxmoOw
 QnPZWoDEM+7qPP3jGTfq2dUFgpLcNC0fiRud/sJD/nhPIWAQu8RROhIavaNyeIG/FwVRS/tMvGFR+O+v7vMMsjZnN0Gq2qjbx5gPVKoM7ORrhqELZKhDua688xkpabE5tcrLyxyxRW0NJETNq6ySWExwaSwL1bNfNB4v9EoaIhsTzu1SPX9x2WrR69K+c6WsH5srDlQHdiIMhlU7D+uMhY9HM8nq2yv5pyj3ziklcN6jaLW0RnzZO6eGd8FwGoOkYJLhQVN36+nQ/aiJYUiine3i5eMk0zMkR7Bip2kWCVIsiP4iHy6itnj9oCQpeCclDevnuJuIMVtxS0OP4OLhOIh5CbsbcpAAHAidrdCVPIHafoImJd7pCoCgIvtRxNcm3XI2LWzJ7V3Dr7ZiLeWfcrfxYYVQcUetvOK2WHKbiWkE4P9+Siou8i7xgu5Sx5MA4UPXs8vViYoO9QagCb8xNMzPI3H5xyZdG/tKvd9yCFVArSW0z4m0mBGDG+9y90aa4ODeTYJMcGbsX6mbOk484j7N0bnqbGSnVWBpdNc2jNHw80lkqBMYbdyyTX4cxcejFen+e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 01-09-25 22:50:13, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/fs.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 3b9f54446db0..0b43edb33be2 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -537,7 +537,7 @@ struct address_space {
>  /*
>   * Returns true if any of the pages in the mapping are marked with the tag.
>   */
> -static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
> +static inline bool mapping_tagged(const struct address_space *mapping, xa_mark_t tag)
>  {
>  	return xa_marked(&mapping->i_pages, tag);
>  }
> @@ -585,7 +585,7 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
>  /*
>   * Might pages of this file be mapped into userspace?
>   */
> -static inline int mapping_mapped(struct address_space *mapping)
> +static inline int mapping_mapped(const struct address_space *mapping)
>  {
>  	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
>  }
> @@ -599,7 +599,7 @@ static inline int mapping_mapped(struct address_space *mapping)
>   * If i_mmap_writable is negative, no new writable mappings are allowed. You
>   * can only deny writable mappings, if none exists right now.
>   */
> -static inline int mapping_writably_mapped(struct address_space *mapping)
> +static inline int mapping_writably_mapped(const struct address_space *mapping)
>  {
>  	return atomic_read(&mapping->i_mmap_writable) > 0;
>  }
> -- 
> 2.47.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

