Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF85BC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51EC6B007B; Sat, 25 Jul 2026 13:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29466B008A; Sat, 25 Jul 2026 13:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69006B00CE; Sat, 25 Jul 2026 13:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B05D46B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:28:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EAA3A0355
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:28:36 +0000 (UTC)
X-FDA: 85027983432.10.39571AF
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	by imf08.hostedemail.com (Postfix) with ESMTP id ED6C4160003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:28:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=HSoLBd5w;
	spf=pass (imf08.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785000514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoMkvhdAZpLwPCCHt7VVbhOPhYfVa+HdCEjj+o5rgYk=;
	b=cdEx/2PAlOG4O5xp8iTzRpKDw7EfBO4nsoZIMtMLmc0TNyEDTe96OLAKsxPwhnThVOXSKN
	kwJSgMimM8cw2KR29QCtW7UxVxGXu1o3ktVYDhSdYeYpK1VENbSaddyOhomjzgdGSL5xj0
	3Xd/A02kc0t+Xr+2QtQINyq2ztYv8WM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785000514;
	b=SrH8lav7WKTSSNH0s9aemqOZW4tYyTrQ67lVihUFSkhzMiCY1Zb2gToPyLqPmcjQIWH3jf
	e98sXAfc0yM4zAnLy3AFgLPVoRR2ckaK0uq6100PUFmTs8KJJexbDxx8kEJt3VLad3lk4g
	Gtfu0DZJMTiYhb4+bJfYaaQ3c9mCPD4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=HSoLBd5w;
	spf=pass (imf08.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
X-KPN-MessageId: 41d56262-884e-11f1-a5a1-005056994fde
Received: from smtp.kpnmail.nl (unknown [10.31.155.6])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 41d56262-884e-11f1-a5a1-005056994fde;
	Sat, 25 Jul 2026 19:28:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=yoMkvhdAZpLwPCCHt7VVbhOPhYfVa+HdCEjj+o5rgYk=;
	b=HSoLBd5wHvvfY17nczUCTkVsPf7ysOimW7kcD0E0JAk4QNiUXyy8t3N9+H5S/3XspEBDNHLUpcA9Q
	 e/kbNXa0eWYiZlVHMS90OONDlCvsnBZGfkTsp+obSiYrsCyltPE3O6w3THYilueCYYOpmF6wl1GlZ/
	 ng6Gpsh4r5k9ZENHwP2H3whOXXk5nSNHY5YO7m9XIiDUs3hMThFrGf7s8fwGDhoDfvc+qjxO5GHahv
	 lqvo2hFQjdhqwjBTdKukS8r5FhXRRW4mc73a3D1mTXYnIk1JO56JnoDq9EJSrxoj17BttyJaUGA3da
	 JElWQ0LApsCOREwugm2asWvZtc0befg==
X-KPN-MID: 33|t4CpmFuAn3wB14rtQJXp3FG64DY3bypVFK3Iwqb6NOyGTC6fPIB3uXq5v3sX03s
 sslBUEeQLUzSF3SVgM3xXJxAJ1/W8SkTBUUW8rZ9WWp0=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|9/bzuXATuzEs4UcloPPcQr9B5NkItDr1CPUHQUZlLCVIxubJxBrTSewAId96BAJ
 YZHsrNhJTKuzpFY2VaddeyQ==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 41a1d055-884e-11f1-a789-00505699772e;
	Sat, 25 Jul 2026 19:28:31 +0200 (CEST)
Date: Sat, 25 Jul 2026 19:28:26 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 21/24] binfmt_misc: use __free(kfree) in
 bm_register_write()
Message-ID: <amTxz8293ky9ncO1@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-21-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-21-a162f7cb58d6@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ED6C4160003
X-Stat-Signature: ta5o8cgne51hq5f69gcxmpfpbgiffgxo
X-Rspam-User: 
X-HE-Tag: 1785000513-501778
X-HE-Meta: U2FsdGVkX1/0NJFr+m8YyGFqreOAFXlm9AUYSi4bl2k9VN3HAkM7+2h+MExud6tuPy2PBO56P6DrCdUHckH6mzbgGZafIiavSz0Ywbgh1fA1xWHakBn6IKpf1WKYEQ9MfGcfaxrSEFvsl+S7wzk4EgduzThqGYdJ+pv5wagVeshU4DVNfPpsMrcJL8IN8glr8hr85uq5tjnsdvr5UbGhHZMzZj9Xh8hYkhqQUoPvAHLkbTfucSMtk5v2+9c1xA5GBo2CLr9LdlOOUvjFcfkwEOjyptYCxQuG2p/d/uZ5dBeijR97/J70JinHlNc0sSCcEdrKSp5vihjCCiHtC1DIxWkQ2rx0PgLQgoJbefu9g3gfe0cWSZKjR5UH5+Xiv3YPyRVmEi3H7kEiFtZsJHndRgLiGGYYokiD250wuZtYxIAZEadqifi0kkKgary5JgDrqUPTh5DKby2R4Xf3C+vC89IirEFPD1aHHcCcyE3634v2VEe5pKLg2SCWn/FLUzX96ZqFsZrCigX888OgoeD8tcrcbagaVQiFMPFgVbhGVedqihz53m2DPF17CMG5lStwEZno65x72bcVwl8rYNrAO3HGW0uRQBz2rnaGROcTLLL72pHtQI+x3Fy1P7o0xcx6tl3C5WHT0ZlVAKfY8tsBopcZU1i96TlDvdMM5R1M+nd4KpUp7bDyfU63zWccX6IPa797+MJDTADe0NTtCFthik3L4QZYLYVfibInMnLqZotL8D3txJGQjamL5r8m5vSXKMuArA/uiqH9IAI0ToRvPvsPEiNNdv+qbPN/p6qwL+Og/fVALgG612Ppw4DnJWGUJfZQoHWBJaka8fxf4x39m5Li2V02NjAr5gNnjT7QvmSxg5zN6gXivNgX+L+AB8Q9G833yQYofGNCyxVXLl3Tkf2C9eAeMIzkGll5U8itnwAIQtuLEuLWuBdsuH6nfxjjvpKrfot7VuastIwly63
 B54fIUHT
 aUKfklyTS/ShQ+56kawT3CO3bO6aPDkjW0KqpVATwVQjAlRnknpy5TIyg+mamySG9xHbXsOzs7/eBFdzqREbFrh6yd9l4waI/Bf8c9zGxuHZ2ZfwN8enD4FaV2tLgagi5AKhZabDe5esi5beS7kuu+i22SK6YdQKFeV6FcnHIwmcoR2yRmOkvYongVzFVORINaCIbRzEbvk5s2Z363DwyiWIBmMmDSvcPQ+4dUeQ1ds7F9fBIMdeuGzqHEPVwqfBkEcIGpf4WBIlcq1KAkTGWAFtziq7KSB5W5ptHuS2sWEHCA3aPuVYv8AjBt68xedTry64xxVgRcC2XgxVM30Xh1UC5EBwP/CY+rDygfS+OWC9MCJhdWnn11fVNY3qCUpGFyVHL9Z1BVH1RCjC/w6YNp1eYowd9+L5j2SdqMuRcSqYep7jW58G3jKdtF8RQkF8jl2QncbsvGUb9KmnHxzwMID43+F6gnPTprUpNgEs/RaK08yF0/39vCo59Uz6ENkHoQkyb9ztSWTu7KesgfCpseU5W/QmLrYrQM4wNnQ/0ihkak254kqSKRQef7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:22AM +0200, Christian Brauner wrote:
> bm_register_write() has to free the entry it got from create_entry()
> on every failure until add_entry() has linked it into the filesystem
> and made the inode its owner. Arm the entry with __free(kfree) so the
> error branches can simply return and disarm it via
> retain_and_null_ptr() once ownership has been handed to the inode.
> The interpreter file keeps its manual error cleanup as freeing the
> entry would not close it.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index a9e1e0bbcc60..eb56aa6a3ca2 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -800,13 +800,12 @@ static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
>  static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>  			       size_t count, loff_t *ppos)
>  {
> -	struct binfmt_misc_entry *e;
> +	struct binfmt_misc_entry *e __free(kfree) = NULL;

The cleanup.h guidlines say to write

	struct binfmt_misc_entry *e __free(kfree) = create_entry(buffer, count);

Either way, I am not too fuzzed.

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

>  	struct super_block *sb = file_inode(file)->i_sb;
> -	int err = 0;
>  	struct file *f = NULL;
> +	int err;
>  
>  	e = create_entry(buffer, count);
> -
>  	if (IS_ERR(e))
>  		return PTR_ERR(e);
>  
> @@ -823,7 +822,6 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>  		if (IS_ERR(f)) {
>  			pr_notice("register: failed to install interpreter file %s\n",
>  				 e->interpreter);
> -			kfree(e);
>  			return PTR_ERR(f);
>  		}
>  		e->interp_file = f;
> @@ -835,9 +833,11 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
>  			exe_file_allow_write_access(f);
>  			filp_close(f, NULL);
>  		}
> -		kfree(e);
>  		return err;
>  	}
> +
> +	/* The entry is owned by its inode now. */
> +	retain_and_null_ptr(e);
>  	return count;
>  }
>  
> 
> -- 
> 2.53.0
> 

