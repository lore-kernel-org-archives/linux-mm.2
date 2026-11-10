Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B92F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=DtI1C0Cg
Received: by kanga.kvack.org (Postfix)
	id 4E0C46B05B3; Mon,  9 Nov 2026 21:45:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8FF6B05B5; Mon,  9 Nov 2026 21:45:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D34F6B05B7; Mon,  9 Nov 2026 21:45:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F31FE6B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:45:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7948812087E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:45:57 +0000 (UTC)
X-FDA: 85417669554.25.C3B6B90
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id A7F7580007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:45:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DtI1C0Cg;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794278755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1IT6L02h4Z0rswWeGeMVfIe5Og40SseihhMQYse9qI=;
	b=K1ispA0yChBSc7NcswqE3bIm1qSL5kHX3FSeLxg3OUA9ARGpgL1pt6zfgBV69ZW5IPI0kc
	K0Hy1l78WgA7Ty1nSVdmHyJ09TtJrq0PObzys6y3XiqIqem//6p8iOAmWHh7eGFmRyEo9A
	GiAZzAbPRGAYoU5vcaVGh89CfaNVoTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794278755;
	b=iKEQvlbsU7LKQbsKWDK6Iy29cES0Ue08COYJT2xdlHAttlqrnearY2ZU0vo1vynnIUQWWH
	/vn4Nw/EMtwmpbydDLVpVeOVMZb4T3prN0PbrzII15RUjxrL6XaBGol6v4qKHQ4j+9QMat
	pgysWulyGysr5CalJNLotKTIvcy78iE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DtI1C0Cg;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ed39646f04so5791975ad.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 18:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794278754; x=1794883554; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+1IT6L02h4Z0rswWeGeMVfIe5Og40SseihhMQYse9qI=;
        b=DtI1C0Cg5v1KKmPSLWiGoxlWxsidrdSCSvhVHFD8mNNXnD/GAkV/UsnAkK1qbYEt7B
         v8OuDd+Y/NVxFYBpDJSzpYy9KfuudQNWFRivMMsMzGhgsbPvweofJEZDdcgBJPTzRX0s
         mVFAV1IoL0izdzTz9tK5XZUhB28cr3ZHETa04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794278754; x=1794883554;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+1IT6L02h4Z0rswWeGeMVfIe5Og40SseihhMQYse9qI=;
        b=JNRHyok52+khIiBu5mBOtGuCbglNevQZGUOfAKE4lTDAhxcROOKtq3PhM7bL8aZDJT
         Eg31ZjAQGa+qCbjoEwxGEZiFA8z47cAR053uE3QjjMTUJRMX+2dm7Osya8+CjkXJnUb6
         m4CkRewEobT9iEkn358jdaEgjEzIq1P77LnOVM/L6rOZJ3NWJZmaLBo4hT4J9rDVniww
         IMDdgpIxLTyT5ID78G5X/PhIl7MTqjOydc/9iyoBitl9kdj68S/5b0MFraji9RdxMRqO
         4ZjytSJJzatTby6byKoeqIVSw84qibejATYsKNVFW5vz9SaNRg61kZ+3CZnBrW1dkY/G
         D+WQ==
X-Forwarded-Encrypted: i=1; AL+hErF1tHRup6+0JfY7i/jwknhg3nYEDgJO/tV3FBE8aJjWhYYyO2WA3ugE7BFYOzN538Knl+fZbQIUdw==@kvack.org
X-Gm-Message-State: APuU4Z9yUGqlttnUNfPHoOvezTuIyQh8MnW57IHD6bEUiS/IJfevahLx
	2xHH8HLE3px55+cPKs3lw3bX4PrpAUBhhfYSL8oj6LQnS4OJkcfctw9iQiIUHQLKOQ==
X-Gm-Gg: AYBFou1Anz/dvVgc2Qrnc2tmk2Y43h4o/BLzyQ1j3FTlQzVN7kMXyoDuco/VNYpQQV8
	jYoJkgZV2jzhtKhu0u9sP/euLtS/wbuFe4NX/wjPmHmrlVkcLw+cdsdFvYIJA092f20tVg38nC3
	AyGAnei5AfuFwAKJ8250eNtrvUUFz56FAab07To8Dh5Y1VY1ZU8tNnQ7zuRgq3Qfj52tZ5jEPrr
	dABz00ONOEb22Wt7+d3fa1/iBIulVwCopPHKJiy+jg+5Cp/FN/IIhOPPLHBx6oHf8EnbxahfjPo
	Wau8khvahr+iaqJwIxCpi5hsjSjhORkNFcPo+WitjFDCbuk5b2Ca2TLHtNdzy/QYYQ90Tc4dElR
	vZTQ3A6GPyKLtzyiOzl+JnGn4Zg3W2O/aigAuJ55fm62eQ4PTVoulD4DerNJSD3YeENLulTQQjE
	aKZnRAkE2daCGtkcxE3s2qZDOBjghacV+4hF70OCxVUR4wtB78BJrrTXfJmzsaPMT92F4JpGSf/
	Bq6EIqmbWlZOIjxxR6tNmaaUj8BoOmaIGOqO0ptPihP2+mXQLj8340EHQLuXWCGgHhqJuShe4fC
	w7NjrKYcluOiv4oFM3Jbq259nsumNruT78i2TISeFJ3crMvqGx1wqCUYnEkvfnm573JiJA==
X-Received: by 2002:a17:902:daca:b0:2ed:4456:fb2a with SMTP id d9443c01a7336-2edb913e57fmr10948875ad.36.1794278754561;
        Mon, 09 Nov 2026 18:45:54 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6e11e9asm3619075ad.74.2026.11.09.18.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 18:45:54 -0800 (PST)
Date: Tue, 10 Nov 2026 11:45:49 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 6/7] zsmalloc: fold zs_obj_write() into zs_store()
Message-ID: <avKFDz0PGwkbwNgz@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-7-senozhatsky@chromium.org>
 <auy6wQIz89NxpskT@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auy6wQIz89NxpskT@google.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 9oudzrd1oje8mr478jhihedeaa5rxamw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A7F7580007
X-Rspam-User: 
X-HE-Tag: 1794278755-523447
X-HE-Meta: U2FsdGVkX1/OrNWCVuGdem5Xx0iYvBgD7zgNBPH9Fjez3KrjdWVamgl5S4ioZvoU8851TkjVuv9rLGdTcScsjOyTbhYW8UtvTyhvmyVQnAbrDqhzeNqdOkRLyf7pFKm3JPDyVzsl6mrGwTnPOZmfnJ4TVwJX31A44Cre53ZrJH15xKRuT8WMU+lem2036wNF7AYzq5qSDPdewv8vyUcBJjGSnkzinau+7HynHKK+k4L6152nyCTp6ZVxv4mstgkEK38dYLQOcUiTwA81Xp/dgQOi1d3b+nGAwD6p4xV4/XPsJJY/M1TV55PMVhJI6AMwVkIUsY1y6gcxcL1V4vHyyja9N7kQ8N6MlJWaoMKg+qBaQ9IDQwC2DqrcQnw/yVlIoDALXiPTaOFpzSjzuaUahUIGI39lFyOkue+ydfMn3R6T2n3ydF7kt14eCcOxpVz5tphLg+TL2JskLyxsrxfB32MFQXyY8xxqLRL2ZbYkOI/gnhyN6vRoHyb8ljFhn7hddg5If4mPsnPKxC5mM1PtZZ1+sE4RzA3SkbQaEBvQDnaHm8s6LyQWMk6jEeIVYiA1cgDTneDPIdjVhxucz5OVjs/yolxyov2LO0gYXn7us3tjb7OCrT61RqFS16IEM430Krx1Lqezy6VF9wm9lvS3zQJ6m9/l98jZ0teomngL/ufpdMYQT9n39J1h7Ze/bF2VECnvdcV2rUirhjUAJ5SuhjGCdeGxHEaaBEHUn7ybmw94unvhV/2TIPGcJxhscEhz1bIkhtj9pRi5UEohYvFZPAHy4FLfwBVwbsSG48r3xZcNqiRQHzaLaFLt+/P9yJf7UJtEraimCnRbppa6pGQICJokn0Q7iWo/GfvE9sEPKJoVxdCp6c8V/11H+GKiKY0wxXvOdLtdVvv401VbiMcf9xClmggM0fK7ThkPRBPMV1RG8R1CSd0OUAZWPrFYBas3syWM+pfW7BamhD+rGMk
 9Hgc/VfX
 T7ylbbd004KRtU/wz1yMo6QKLefCsQEsRpGLG5D1x37DJCV0cn+ikZUOlRL/A4OD+s2ommi0I4cPkPeMrspAgOv53BcUc4RBDaSdlSLqIW+OCOEtX/vHl3QL8O35cgsaV6DBwsJhrKP88Fa355NuwBxQRvTB6rj5G0D/bdJ4227nWtfjCIn/PW0ZqFvr6f2kmBRYdrc+lLbP7IHKe5GrBpVZJIMZA49zsjc5UVMmraqPyhaorR0kSXNZpjDWjIYVDbeVRz+med1NW0XdYKZl0CBsE1x+URDgGGQvhsB9rv8nRX6MzTAUFfbN7ykdZ4chTkH0XLpJDvOsvOSRa3P15t4W90j26+KXt9hfvbHTU4ALxE7xXyarh5cZP1BAuTvPKlNF4/niLOhfbSjxRep69z6XvkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 17:29), Yosry Ahmed wrote:
[..]
> >  Most of the memory allocation APIs use GFP flags to express how that
> >  memory should be allocated. The GFP acronym stands for "get free
> > diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
> > index dbb5c1a8dcc3..52eaba8f97e9 100644
> > --- a/Documentation/mm/zsmalloc.rst
> > +++ b/Documentation/mm/zsmalloc.rst
> > @@ -20,9 +20,9 @@ For simplicity, zsmalloc can only allocate objects of size up to PAGE_SIZE
> >  since this satisfies the requirements of all its current users (in the
> >  worst case, page is incompressible and is thus stored "as-is" i.e. in
> >  uncompressed form). For allocation requests larger than this size, failure
> > -is returned (see zs_malloc).
> > +is returned (see zs_store).
> >  
> > -Additionally, zs_malloc() does not return a dereferenceable pointer.
> > +Additionally, zs_store() does not return a dereferenceable pointer.
> 
> Well, it doesn't return a pointer at all now.

Ack.

[..]
> > -void zs_obj_write(struct zs_pool *pool, struct zs_handle *handle,
> > -		  void *handle_mem, size_t mem_len)
> > +static void obj_write(struct size_class *class, struct zspage *zspage,
> > +		      unsigned long obj, const void *handle_mem,
> > +		      size_t mem_len)
> 
> Should handle_mem and mem_len be renamed now?

Ack.

> Also, there's a comment in zs_page_migrate() referring to zs_obj_read/write().

Ack.

[..]
> > @@ -1318,12 +1306,16 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
> >  	spin_lock(&class->lock);
> >  	zspage = find_get_zspage(class);
> >  	if (likely(zspage)) {
> > -		obj_malloc(pool, zspage, handle);
> > +		obj = obj_malloc(pool, zspage, handle);
> >  		/* Now move the zspage to another fullness group, if required */
> >  		fix_fullness_group(class, zspage);
> >  		class_stat_add(class, ZS_OBJS_INUSE, 1);
> > +		zspage_read_lock(zspage);
> 
> The zspage lock is now acquired under the class lock instead of the pool
> lock, this is probably fine but worth calling out explicitly in the
> changelog.

Let me take a close look.  Lockdep didn't complain, but let me look more
into it.

> > +		spin_unlock(&class->lock);
> >  
> > -		goto out;
> > +		obj_write(class, zspage, obj, src, size);
> > +		zspage_read_unlock(zspage);
> > +		return 0;
> >  	}
> >  
> >  	spin_unlock(&class->lock);
> > @@ -1332,8 +1324,14 @@ int zs_malloc(struct zs_pool *pool, struct zs_handle *handle, size_t size,
> >  	if (!zspage)
> >  		return -ENOMEM;
> >  
> > +	/*
> > +	 * New zspage is not in class->fullness_list or movable yet, so we
> > +	 * can allocate the object and copy data before taking class->lock.
> > +	 */
> > +	obj = obj_malloc(pool, zspage, handle);
> > +	obj_write(class, zspage, obj, src, size);
> > +
> >  	spin_lock(&class->lock);
> > -	obj_malloc(pool, zspage, handle);
> 
> Should moving obj_malloc() and obj_write() outside class->lock (and
> skipping zspage_read_lock()) for new zspages be split into a separate
> patch on top? AFAICT, it's a separate change from merging the
> interfaces.

Let me take a look.

