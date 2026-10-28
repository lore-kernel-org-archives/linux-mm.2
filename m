Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A77606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 23:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SRF1J8Gd
Received: by kanga.kvack.org (Postfix)
	id AEB106B05B4; Wed, 28 Oct 2026 19:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B986B05B5; Wed, 28 Oct 2026 19:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E3C6B05B6; Wed, 28 Oct 2026 19:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF176B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:14:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5EB0120273
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:14:05 +0000 (UTC)
X-FDA: 85373590050.08.E2C4B5A
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id DC89920003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:14:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SRF1J8Gd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793229244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puyAoc6Jf4frehbhlLXQIfKglUE1ElIfqgej2JSgVAA=;
	b=P3Qnw4BbnYaauNN9bYyzrtOleaJu12Vmfz7j4tW8G3MqEgtkgf4me9c9+lMuAk2wlb1Gd+
	vV1DHbehPgFxDMemfe6Kc5F6jWzGtrS0rwRustTs9izilYqJ5wkuyTW/8Snzgw7H/26s+f
	D8Em8WqPAMwueSBNOaOSmfO46QjcT6E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SRF1J8Gd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793229244;
	b=iFGoikRaiFZqvYdOgNZC/gcXHPdNpSTBBA2RtG1wkHnNLsbwQujHi/35H7+G0Eni1b5xiR
	pWfsjVMv75+nHUrUHUMzYsyQ1UK3vPabgpIe5pmqGKbrmH0CSiwa9ONBqOtYWNC8muobd2
	yVFWjFgQ1biQLAmIFWCMiDPqTVhri6I=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a070781f63so808325b3a.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793229243; x=1793834043; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=puyAoc6Jf4frehbhlLXQIfKglUE1ElIfqgej2JSgVAA=;
        b=SRF1J8GdYmSgOIlbXHaWGaZlvC0sArn1WlbwFvW//4no2LacjLt0DSfh3LfePAZEE4
         WRVxDRmq+HUxbdPME3J26ve3HKw48L2tjl6JpnBUYuQ3ciP0aAbAEeecSHqrewhScfEa
         zdm/J+FG9yBNVdUWVkNldEqNKfpKBtiGF+Kj9lDqT/O+4Z3ODJSgzlf8Zm2R08Dd48ZC
         2wNFT15wn1cWaB9eRhC1tcg9XQogQOEf1lSDojVNt26314ydjmSjTF66yxJVh9N5NbMf
         VTa07ropeG3xPRSrp5ar8i5y8CifgV2Z+Shu4Pj+W31zdpl8z2nP7Fi7cduXsB9xD7Lk
         oIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793229243; x=1793834043;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=puyAoc6Jf4frehbhlLXQIfKglUE1ElIfqgej2JSgVAA=;
        b=vn5zfOUFTEZeYJbQQSvmKaSPRnz5ayrppimYLm33qqRFxFD3381paBEnBbkhXJrp8z
         OByfYZ/HyVm9X0/KGR7MzywYECeZ6iW1gd7soNt3nO/AOHQIuuTo9R/DWjIx3eVF2wGf
         wz7q6gkvPkdLQrm3kkFIF40BAE6NKwFXsSB2sseNCIUBnsWixZLXciDXuMeevclYSDri
         hGQ6BdP69FBJ6ylCsEmVUjwQkuOiQtjKMHiivNJzz2BMrMYaq+CSCM8XSbVifjDKU5Pw
         gmVc9GI1VWY5mtK3cB6LKT5FWbJcm+BstO4SUZZzH0Iq+uQFTee9c+2XIFF9QK7oqKpU
         fo0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxwH88g39+lU89Adz6Jyk3VHvU6QOQ+KMzXTAHBe73XXY2XTbJKO25MuUxcQmjHO7dJtCoc9Jj6VA==@kvack.org
X-Gm-Message-State: AFq9FYJ+Kq8HSl7DSXMFLXZZXxD5IOHT9P1aLcRjGYKVeDYxlteyyRzQ
	4bCZT5X/LUlVwUwPv78eHix3gqdZTSQGD8zF7DVPUdXaHc9ZFpz7u0qfLiFKbBCU/6zXvKrOwhx
	iahFOtOE1
X-Gm-Gg: AYBFou0H5djWeCHZHF/Fk36lGVfyqeazaPnhAPa4VsuUsXc1Eeje+Y0xuVyoDGtacgJ
	EAULdZ0b8/h98upWoCrqcNEuc3EqxJK7PszVm7bpCrv9//ixlWghlw7T//15NlLzGg8fq/U2Frj
	LBGRU601cdmxeRMlRBrubyUjm8K4UxI9NiW+5GbYAe+KeT/Xy0Hlaou5H/cES0+sdCmcXBFXP8n
	2JxfqW2t2SVLW8wYUzqrhPFCnEUFecEEgwMTpfMQXJwYNFR4spC0NvzuaEGrnkPHjwrcU9Wdbfj
	xkaVwat+aZJ4ZzdaVF2fUACAtyiHdezE69FEzNeff3hifuH/DCwLosY9KZ3zrw/i0nLOOUbe0BY
	wkBG/Xea5+SLgM2tQ673h0Py31POm+vwZ3HFSdYfJBK1CZAyPzm+UHctKYd6dVNA7+KEjtW1tuq
	0AHvedWU0UfWMH96wvGLH+FkdLVnIcAd+2I6/kqJ1NYUI8sdnNisSpZMQ89xMG5YZmx0q3hM7kg
	nzR0Bt0TBwMLl31GNrkeXniXKoN+hxPOix86v+CozRyHEzJQrHlUFo6i14TtT+p2tHqPjspr0HC
	28jWY4epwdo98vLNiHklwQ7uKigtA1a4W18MTikCpEHbC36xJ74y87m3xcc9nPKx6/EFFzFR9TV
	EzmNNaTHzefDM3G56
X-Received: by 2002:a05:6a20:914c:b0:3d3:af85:eb98 with SMTP id adf61e73a8af0-3e9022d6cbemr3267144637.26.1793229242275;
        Wed, 28 Oct 2026 16:14:02 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a6cfa342sm1626775b3a.41.2026.10.28.16.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 16:14:01 -0700 (PDT)
Date: Wed, 28 Oct 2026 23:13:57 +0000
From: David Matlack <dmatlack@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kexec@lists.infradead.org, linux-mm@kvack.org,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 09/10] mm/shmem_luo: Allow retrieving tmpfs files with
 O_RDONLY
Message-ID: <auKBtVmCS4jU8e_R@google.com>
References: <20261022225035.377445-1-dmatlack@google.com>
 <20261022225035.377445-10-dmatlack@google.com>
 <sashiko-outbox-183328@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-183328@kernel.org>
X-Rspamd-Queue-Id: DC89920003
X-Stat-Signature: 87fjic6kqod8zrhgmtpgj8m3h9y4dy1g
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793229244-746058
X-HE-Meta: U2FsdGVkX1+5y1EW19s6xi7O2i3mR8y9RBwfqJJs4xMmxM5PXoAmomhiv9PJ0rrJjvuVyYh5N/xuRez7ov8ypyVBegjwotIPMKd6TTVauFBMAcw1ZbTylXmq25Sdo9PpB3Bf+Ztvckbu66cKf1eUjo6qONQuXpl7FeUb25YbTUYr6gQ7hgvFo3STuNOP39OZskrtBOQ7bzwvK1yfRQVfFCFhAInLVDcV9QajfvFmEN+tvCIXgss281/FaZ9GThaXacB0juphq7gBP5cphmTBtsa6fx5txaf9XdiefdKqsot87rmM0Ov4aCHmejv653Caxt5LChcdBs322Vu/h4BjEUNrqtCSdHuHO53ya6tZ0S1eEThSRXyJBtitYwnWkJHZlxJjuaao5Hmt5s4IFpgDguhlzkikrDwGc1X5mPI/3mYmU2EOOGuQDtWHqjsB6+KDX1Ay3p8GExjdkZ5QwMljpxqXv6GHA0s+D6e7CKUVDCLG61kx4z2IoF+myxb29KcK4pQHnHFKQur9xC+oAN8WWXjE7Jl2tsNsrJEDpqXTdjouaRqy5da3MlLRE2mXodo0Vh2Yci/dliqrYuGE9k2AUVqyL8ULuFYR49KXqJ8v6MhV9mR8IzeJVUKdY3d6QdFU1L75rHJdLqSwDh6/V7DAjFBzZGXBAWimzWcvcXzNPR/HsRIQs9WG0DAdFlUWv42K2yeP5hi+uzbysBUM5DEduFRub5cAXtpCHwxDZVLo9li3C7SmnJVM+MKgoUpG5e/JZ4wPMs4EVc28s6A/i3JxisALKq6LQCsek0fnXLgBqAUSZYbNzInl9B9q9i31SoniVdK8A3mxhxA3DQ4/Ovv0hjdFDwHAmhiyvPVMaOw0/iECqngCRUa6rF++CzJc6/hKbNItl2CgaPhZoxrB4tFJFkiR9qgkAKl+WyW08iT82/WNGHP+r3Kv1RMQZMhIY4p3tPs8sCCdYyhEkrngpLo
 o6xsZadm
 t5de/rA57iWMQEuxbg5z8ITRHOQUr8VyjXLfw0/Ll+DxFsuioRDlx3gWfWbkCda5HuIM52ZU1cqMfpzpFEYMqld6lAg/T4LFHqR6eHuTA96s1U2onqmFlZiUVL8trDYCYM1WqEcNFBSAcBzFDTDPVZH4k5il+Z/eGcQ7d0P5v/fWHKDnwDOqpzuNKRqbPz92Akj5/WDPp7g48bOQSLJ2k78IMB9KFvwAU7oinOmauA4q8jhllDfUq5re8IsVCPsNLzhT1d7DQa9/mpz24iZRh76wMxZLWHtLcAWTcBQoFMMjoh2HkxcCRcEIoF9NjQwTUDnsifA+UkAKpe1rCRTL/IGlUx/MUa+K0nSnT3RrTPVdIu2+gZPYiRwqLryKv9VaXG8g99WPhKrgQeON6F8sqESHG6/oMc6GEnzACfu4ZnEfMmG8M6ce+eFblBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-23 10:51 PM, sashiko-bot@kernel.org wrote:

> > +	ro_file = dentry_open(&file->f_path, flags, current_cred());
> > +	fput(file);
> > +	return ro_file;
> >  }
> >  
> >  static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
> 
> [Severity: Medium]
> When userspace retrieves a tmpfs file via LIVEUPDATE_SESSION_RETRIEVE_FD with
> O_RDONLY in arg->flags, does passing the raw flags variable to dentry_open()
> in shmem_luo_create_tmpfs_file() in mm/shmem_luo.c bypass the flag
> normalization performed by file_open_root() -> build_open_flags()?
> 
> In fs/open.c, build_open_flags() strips O_CLOEXEC and ensures O_DSYNC is set
> when __O_SYNC is present:
> 
>     u64 flags = how->flags;
>     u64 strip = O_CLOEXEC;
>     ...
>     flags &= ~strip;
>     ...
>     if (flags & __O_SYNC)
>         flags |= O_DSYNC;
> 
> Because dentry_open() -> alloc_empty_file() -> init_file() initializes
> ro_file->f_flags directly from the passed flags and do_dentry_open() only
> clears:
> 
>     f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | __O_REGULAR);
>     f->f_iocb_flags = iocb_flags(f);
> 
> passing O_RDONLY | O_CLOEXEC in arg->flags leaves O_CLOEXEC in
> ro_file->f_flags (visible via fcntl(fd, F_GETFL) and /proc/<pid>/fdinfo/<fd>),
> and passing O_RDONLY | __O_SYNC without O_DSYNC leaves O_DSYNC and IOCB_DSYNC
> unset on ro_file.
> 
> Should dentry_open() be passed (file->f_flags & ~O_ACCMODE) | O_RDONLY instead
> of flags so that ro_file uses the normalized flags from file?

Yes. I will fix this in v3 to re-open the read-only file with the flags
that file_open_root() already normalized.

