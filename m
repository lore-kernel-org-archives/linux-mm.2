Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5897BCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 16:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874496B0025; Wed, 27 Aug 2025 12:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 825206B0026; Wed, 27 Aug 2025 12:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECBF6B0027; Wed, 27 Aug 2025 12:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 553FE6B0025
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:59:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFAEA84ED0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:59:25 +0000 (UTC)
X-FDA: 83823148290.07.91FB92F
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id EFE37180013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:59:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EOVimeAJ;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756313964; a=rsa-sha256;
	cv=none;
	b=ouISGwvb7DrVGmLPipCaPK0SjR36B7q4c1Mn47PrQ+CMfABVo36QmdQkP6H6c3rE+hbnLH
	6X0aS7vzX9ozGWYYdtISmsNae60tzunvEeKJ5GWeBuw3A8uG2FwcXaC4XCOsc6beA0zNfg
	AznPRRIATdnahZkx2h7H2jbtvT88jSk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EOVimeAJ;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756313964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSz+0Jdl3rsxgIMqjiE4eLITB/Ptqi8xoIkjq9Q3i9w=;
	b=Ssr6YPm4r8FBKdKn3p8j8iM53Ttrgne4rUw3+23rv67MyROHwnuJXWfWCcGkGeSrh1USqY
	sWagqsNeePN1J27pqtyvgHBRwKwsNwn2gfBnI31SLFjuK18tgXJLGIMIRLHjKfuNcfKtQ9
	0U/PoxpKKAX4jQYJ/MeEDvxjaAnZ0Mo=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-33670e8c975so278481fa.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756313962; x=1756918762; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cSz+0Jdl3rsxgIMqjiE4eLITB/Ptqi8xoIkjq9Q3i9w=;
        b=EOVimeAJc1DvgjUt5b1F2/v1Nk89LVJBwGRdu3N7BpTvJqqxWPK76TTQy4N/wRTu96
         bN/8H8KUwDoOVTwBLOVaA7Qq+/Sl3PPJ/TagwmFpnNXw2lv9danm1b7uhUmdr3esm2fa
         4HyqPhzRAnh1LOyuBLi9MNQnOsHFxegEUyeJXYCxFqz7uqJ7a/yUr1ybkw9IhpwUlXgE
         IMTVO74NKrNhchzeUGAOZ1ymV+ZoRX0VoPXzRhtZmeyjkQlTPb1xC8Q4O0WUvZNkKFoN
         /pkCp/pvWo8coTUWgOrNRVPIdeFuWsgXOI4S878u5/4Irvy1TcU8Kp6CwvDb04BnzU1g
         p+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756313962; x=1756918762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSz+0Jdl3rsxgIMqjiE4eLITB/Ptqi8xoIkjq9Q3i9w=;
        b=jPM59xqPmJHE2rkm7XofxxSEcFdoI4thggUs5XwSTqFCi1ZEMTv49tEeAcWnG3cCSn
         2QIEslqd4oVYsowAqiB+Pxh15YRVZ7eC8Z6TFn8UvBY22WF0Znaf5rK4yCQssPMqWj+7
         tieTzodMY6UCYWrcWZsRB34RQujcDWJVD3CHZF+rGURivwYlpeCYGzFyibDvMU8Dlj2D
         QKbltJlpSMc7MY8nsp18HlYc48VuslU3y224OgKw3WAkrciyg3asKEbiByqmxvlNAFb2
         eWM/GaP0b8IFI/dpUT1unqZShTmoUoz8LUJOPHFSI1ghfEGkxPmHFGO8AN55zPdQVA68
         TKsg==
X-Forwarded-Encrypted: i=1; AJvYcCWa1oo7fVBM6HpdH3UuIi5CoKKbPFpd1M8Fo/wpwIyKcdql4UTxOPr42rxXhMojG50+pLaifHx2vg==@kvack.org
X-Gm-Message-State: AOJu0YwcgSKh2O5C6EyU6Y3P+xGTJc9Ld4lwaI5m/yJWj7Lu5hOkKFBz
	ft5/B1C5UoG5EzGkITLdtZpDAYaJEHiXxRa1fMDnSrdsK1NIb1Us29BK
X-Gm-Gg: ASbGncvPN5ppDuqzKppMX8Zrk/+xp+MNuaLQoORcmfraFkc/sr58fZWD8sVTXZec3dZ
	gJh2Rj9OkgGcnT0s7cJeBA0X+3V4HbjEnbOq1MM+hvu8WAx7XSPF2QPPvXjMfRXfYHuNrztiibI
	Xmbhs8Sz7/ZgaIAruSeKSsFiRwVAS96m6qItyjKp5MQvgRwET6BmJyWZyF0HtvB5Ltl2ojCWq6R
	roQGQ5oLdQB58lUwa/v6NYF9v10aNOVaZPRzPcXt9Qh6YJ52ybqJ8dsJQb8sZCv+i0R13glngGG
	w/+7wtnHwXT4KEoGSInwp9xrURxhTdsMytE/TF9VLzh9sZWGOlI5nQlFiYsq5s9wVEYlWflvsNh
	pLtP8uoRgiURwUeaBASNmB3EGM6SKJmUZ6D/1LqhnOVBXymin60ZW
X-Google-Smtp-Source: AGHT+IG4BeCx/VIPO9rnbCc0YcRdZMlua4eVbdX3PpKt/fKDdzrBfr7yiiTFTWfK/4UfPVTpR7vpyQ==
X-Received: by 2002:a2e:be03:0:b0:336:7eed:2f8f with SMTP id 38308e7fff4ca-3367eed3c67mr29987221fa.32.1756313961794;
        Wed, 27 Aug 2025 09:59:21 -0700 (PDT)
Received: from pc636 (host-90-233-205-219.mobileonline.telia.com. [90.233.205.219])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3365e5da244sm27443611fa.58.2025.08.27.09.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 09:59:21 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 27 Aug 2025 18:59:16 +0200
To: Kees Cook <kees@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: update core kernel code to use vm_flags_t
 consistently
Message-ID: <aK85ZPVwBIv-sH85@pc636>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <d1588e7bb96d1ea3fe7b9df2c699d5b4592d901d.1750274467.git.lorenzo.stoakes@oracle.com>
 <aIgSpAnU8EaIcqd9@hyeyoo>
 <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
 <aIkVRTouPqhcxOes@pc636>
 <69860c97-8a76-4ce5-b1d6-9d7c8370d9cd@lucifer.local>
 <aJCRXVP-ZFEPtl1Y@pc636>
 <aJHQ9XCLtibFjt93@kernel.org>
 <aJItxJNfn8B2JBbn@pc636>
 <202508251436.762035B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508251436.762035B@keescook>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EFE37180013
X-Stat-Signature: zrngrtzwq57ixeeadssf4i9wqgnbwqna
X-Rspam-User: 
X-HE-Tag: 1756313963-225825
X-HE-Meta: U2FsdGVkX19ML2O/Na5YNKdKglJ8MtHcEjhRitjJjKOzzum7udddFKTQIDvJLqnKOCUizPi2lL0zHYSxrp02VQN2qFnkk4/Bwkz0Hpb+AHKw10NFicVJ5mHJe0lmvb/FvvoU3IUKzRY1unATAq3CmWkjEX6i6sFuEUprhXtAmIU3KPagPg+IEMAdOgsBavOjZ7AXmtdOu8wgJTfZIJMM6TKSSDnDcU/6T5uHudxvBeKTdK76hlvegn0Pt1qDk6446zGcShBkvCd+FhO5yqg22PY18K4ncp0D5K9P+oCvl07BF5GsRJ1USuJd5k1JjB5hcUQdXShXjrAqN6p2pFOp5yU/vrCiERsB5MfnFnwJDmfJUpd+Uw7hxiHDdvK0zifnfDqyueGopH1bXIJY4VoVnaF8LYwPAACou4sDuQFnxUF0k25nav29h9a5ZwkmRH1+wWjxSskrYNiExMEuxAkuFhZEZKWibdw3VyzEHSagb1NjebGlzlQO7YwmT3nhbl2K87BVp/4GyyO2KmunHT71K9dmQ6x5AS7xHAE7OEEe+CncUTOsd15y4XdOgjpNdhCoERp0LSex+PuWqJJ0acOx2vCL/2BqlbsiyMjbECp61kyGtZg4xOIy7mrjzvE2G+Iuxs/XMCmoa3nzT72TR+mDKRgkPgMEDwcmhO2zchQDWX1bWrd0N+iUS+G9zrHhnMmyXU9GZWrkIQXLX7EPtO9IFrtIZcZhXa7LzxK1sTSL88V1NqpoSzjI+ENkON2edkhYqs0gD4chZW7X7cVaRbvNfAsuIoXK7Z0Wd2+SQa2h/qIzF36HqLZ3Q1xuF427J6OOQLBld1ENwg75l3Sl3eJpCzykN1+rHDDMnwvIwwa4lSB6dAMNIfT73j+rbtuo81pAy8r8vu+QjP8nJJhxkOCKlnWiX41sNMJEnVVp8Cv7gejFNY5WpYk6hwtAXKJTQICX8P0A/1OvWR8B2YBnxAC
 Mi6CwSti
 2ZdMzc+sbUM8CZ4e+eoShQaXRRLT/TcGRXd3XUbzTxlLLrlhZeVws8mfot/8v7P6iGGV7nQvvraWNbK9Mp4fFzYCvOiUJMD9Xq6DQa09Kc8PmjAIQbz0PA4uaZwa3vT8et1WyfAHSi5FS5qqJFX0LVyt5i2ARHbxLupA11iGhrKhzJQaGKWcCFmNcMy4o/ZPVhJ+zPGyqjMylP4kgaeM7ps1xdbZTiqCp6M/pHrh9tydwgfg45nxekKgdor787Afhj3HBS1k4YazNSkUcmMRPYeT20E/HJXZQkEzudwkDen4UBLpWQOyRdl8LppfR8zEfII3zvgmgbRe1IxIl32XIqxWWBAkK0ItNVEHXmJL/NmuPqtKGDm5LNm7twH9oPFHN9CTOcXpNAzJeFnNUhd9nYU+PPYHepeOMuYEKGxsdxi+R8QjCdfpFlniCCpdf376SyQuqL5QzX7yhS5+IvHmkCqeZIdPOGiT/WUaP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 02:37:11PM -0700, Kees Cook wrote:
> On Tue, Aug 05, 2025 at 06:13:56PM +0200, Uladzislau Rezki wrote:
> > I agree. Also it can be even moved under vmalloc.c. There is only one
> > user which needs it globally, it is usercopy.c. It uses find_vmap_area()
> > which is wrong. See:
> > 
> > <snip>
> > 	if (is_vmalloc_addr(ptr) && !pagefault_disabled()) {
> > 		struct vmap_area *area = find_vmap_area(addr);
> > 
> > 		if (!area)
> > 			usercopy_abort("vmalloc", "no area", to_user, 0, n);
> > 
> > 		if (n > area->va_end - addr) {
> > 			offset = addr - area->va_start;
> > 			usercopy_abort("vmalloc", NULL, to_user, offset, n);
> > 		}
> > 		return;
> > 	}
> > <snip>
> > 
> > we can add a function which just assign va_start, va_end as input
> > parameters and use them in the usercopy.c. 
> 
> Yes please! I'd must rather use some exported validation routine than
> having it hand-coded in usercopy.c. :)
> 
I will do it :)

--
Uladzislau Rezki

