Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586ECEE6B4D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B786C6B0092; Fri,  6 Feb 2026 14:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FC06B0096; Fri,  6 Feb 2026 14:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7BCF6B0092; Fri,  6 Feb 2026 14:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79E836B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:32:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26A21B7CB6
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:32:01 +0000 (UTC)
X-FDA: 84415027242.22.4403DFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B61D14000C;
	Fri,  6 Feb 2026 19:31:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="P0//Ycw7";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770406319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JY0u7gs8tKEQwhr2uYBZwKNrcfFc++zLECScrhdKYQ=;
	b=zfQBg+2qDNTVzgv7mLOx/fmufbjpfcFwAIc5L/mKJRN5Z6ILiYmjhU+eJh2au2H/Q6sg2Z
	XEywYlg4ZmNaS1BU7kEmOwmVuBOGRKcHPgzDMdCWm/HsP0+vcz/YVNNaJW8GsjFc2/dnR/
	9s4zQq9luB0OCPWMMTEhPrG6SSNPolc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="P0//Ycw7";
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770406319; a=rsa-sha256;
	cv=none;
	b=6os/Ls6FJTIGexeONjNOxy9feO8dv/2TxqQ0+vwRR4fI66BPpN/XTq+XEH+SrrJiKNM5Dz
	yO72R+PgNfsz9np+7ajVwEm3Au65dWWrDuzNmoRCUqW7/cC4TFGubWj4YpgY4fOrur9jv1
	2Ex002EQi07GlUUF5q+3YtpHfCS5RBw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7517341A3F;
	Fri,  6 Feb 2026 19:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E60FC116C6;
	Fri,  6 Feb 2026 19:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770406317;
	bh=sFmOLogLTpCWkUOE9qlbNa3u0BVXHcuyge59i+fnUfg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=P0//Ycw7MamL01hmVUxrX954cfCW9uQM9dRODdcU5KIQuuE0qEyY1JS9AxdM8F96v
	 5DofCLn88Bu4sHg6rPYalTvwkPcSbj6PjOltDumckh7j2RRU87blAz/W8ZmpRFjy+T
	 5AbBbYyJ/4/G1l/2aQ5CJCldkjuxifDVAKZKSGfM=
Date: Fri, 6 Feb 2026 11:31:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jarkko Sakkinen
 <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, Arnd
 Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Christian Koenig
 <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Matthew Auld
 <matthew.auld@intel.com>, Matthew Brost <matthew.brost@intel.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise
 <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>, Andreas
 Dilger <adilger.kernel@dilger.ca>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mike
 Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, James Morse
 <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Carlos Maiolino
 <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota
 <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh
 Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Zi
 Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jann Horn
 <jannh@google.com>, David Howells <dhowells@redhat.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge E . Hallyn"
 <serge@hallyn.com>, Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-aio@kvack.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 devel@lists.orangefs.org, linux-xfs@vger.kernel.org,
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, Jason
 Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 09/13] mm: update all remaining mmap_prepare users to
 use vma_flags_t
Message-Id: <20260206113153.c443545459474cdef6dfd7ea@linux-foundation.org>
In-Reply-To: <hmc2or77xnhrdlncfzjsljljwljnp6zztqsvmgxspfilmzkyty@czxpjpdm66ov>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
	<fb1f55323799f09fe6a36865b31550c9ec67c225.1769097829.git.lorenzo.stoakes@oracle.com>
	<hmc2or77xnhrdlncfzjsljljwljnp6zztqsvmgxspfilmzkyty@czxpjpdm66ov>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B61D14000C
X-Stat-Signature: fwy8pqbhianfya36q15xoxgufir67woj
X-Rspam-User: 
X-HE-Tag: 1770406318-96622
X-HE-Meta: U2FsdGVkX1+pkoLdVlv0d3iVMCfNYtjv9Xw8ho4BkHcIg44XT2JsVXePIIixVIowviAab52pqpukQge6p6CPtiBmikxmi2EE9SzUMYVjk/ggRbV2GymZWwJTgIfkdBeDbcHS7HJy6vseT67KPPPjMDRudbbGq7G2vaUD+sR/fyO1QZe3ivvqfAOtYaZDEQtEsyA9i8rS3TsCHTNCSfLRGVhn7dOCrHza3hBSateeWbmZt++WRyV2cIhiKRWvaQldKyt2RrmrVTf+uOrajp2o9Krw6yKEXY/+CIS/HB/GupzQNZIoHLi0UpYdbk6feVtbZC3tS7TUhPn+yoY1rfCoHchGofw+6DFJootYW/qrPnb8l7YnGnmNz+hlVNL/TDbchOuP9FeNNOEjDXaxIn7xvXndr1FJjUpjWzHxz2rheeY4vL0rPf26B0r0XxARd+HGsn9F0YmF6kJeymyRy7prbaffx6CEO7zbKdC86tIOYjXIiIGGl/n82ZYBl4IQNiF+9KYS0kThr9HlEWOmG9nlxV/5pPbPEGPnwIAqEcEyJWb1w2PFuwi86A0BcTSTWoz/9TOPI+xCNcVOn89zEAdai9fDZYFpP3BvTfb5cmNcjn8ZQKDbHW7XCIXW5/dbmzq9gSnpnf+jcmbJhQIXdWGpCmQO8pB9UTOA4nUDU6LfsvpunAvB7Cqr0pet7QexvmJ3Ed4ogDMkoXpLm3e+Ot6Ql1Q2Q9WO5p08GlWR05stm6+owBpA4ZeBOyfRcEUHjpKc4paSCyp6IUVBHbMVaEmao1v7eE1721OUUlBR4Bg3ZStZi1HpPHslNuPMEr96PescAjh2J1EaGAgiqlitsg+nL3lpAJKO6iX5W3kOjMhJ/6drGnSrP9xZvUAtStI9MhHPTBxLldsa8GogoRBE1f2Hfpa3SANP7lA2AsXHiQdOPZO7iM9nj28SA4LoR4E7vHXtyKbJW8PJetGvQxunUpw
 yc/ydWb+
 BxCu5wQPGbtNIjLCGTvK26ZuwaTaCP/nBo41xrz5FhdGeGAu/7zuuPmcb8DjNhwKFHRpFmx0t5kCzTDus3pu8NrwnbHa68wyMsNjH3Saf+BC4x5HCmo3pL86bjv3uJe1EfCUTcb0V0fcxObMEwo5/1ul0vzC2vMeQWBCbaFSiAvVoAXrD7u+b+QjDnChbB7yRZ4yl6t4wjsI9oEkFXXDl/gFprrL/JiZSTtEUyJIkLuP6nzEkmsWnoQm16LYKxDa3D4PAGaBKoxYQA0IPGIDHZXLSMvnBVgjum7ny6ZqrTm5cevgx44OPNMaiB7/IkED9GHo+C377Ii9e3sqXGSf9nut7/dv8cJSJXQoGcSNKxcmQZxKbjZl6fVFVxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Feb 2026 17:46:36 +0000 Pedro Falcato <pfalcato@suse.de> wrote:

> > -#define VM_REMAP_FLAGS (VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
> > +#define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
> > +				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
> 
> as a sidenote, these flags are no longer constant expressions and thus
> 
> static vma_flags_t flags = VMA_REMAP_FLAGS;
> 
> can't compile.

Yup, that isn't nice.  An all-caps thing with no () is a compile-time
constant.

It looks like we can make this a nice inlined (commented!) lower-cased
C function as a little low-priority cleanup.

> Rest LGTM though.
> 
> Acked-by: Pedro Falcato <pfalcato@suse.de>

Great, thanks.

