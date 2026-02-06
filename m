Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1094EE20BB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828956B0093; Fri,  6 Feb 2026 12:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9F16B0098; Fri,  6 Feb 2026 12:14:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502236B0093; Fri,  6 Feb 2026 12:14:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6B66B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:14:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F073A1602BE
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:14:20 +0000 (UTC)
X-FDA: 84414680280.19.DE8C840
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id C89B21C0007
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:14:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=j6+Jb2DU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+WIS4NGb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=j6+Jb2DU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+WIS4NGb;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770398059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z73YqVi28uxxhcm78/EYnmwbNwCl8FOdS0dwqPt0f7Y=;
	b=lbvsW66BhpTJXKm9jw0cWm0VZ80QQx/Jvi8i075zLS2v8qkgWKjoxjtRX4+s5bFcnC90b0
	Q4s9LwW76BMdtKybptyt3X73XQd1KhnqZd47H0amao/Wx39LJfnlmh6bt8roY+ZHrspsYO
	OinOLKzDLI3lDKmljQ3VhpOSVufcCp8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=j6+Jb2DU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+WIS4NGb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=j6+Jb2DU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+WIS4NGb;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770398059; a=rsa-sha256;
	cv=none;
	b=PviZe1WV6PR68an1PkFc7WYsdbfT/H3A4QHG5TFHJ6dciv9s91SsFPg8olQtJlJh5tXx6T
	vaIf9VXI+pUsNMLmA9YjyiLHoTIz13CDthJH++LJZkiTd+LYzGusMJNYgG6xEsAyxb5yzn
	0MdEDIWeKimEiBH2b4JbpU0QXwaCnVc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 112285BCC2;
	Fri,  6 Feb 2026 17:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770398057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z73YqVi28uxxhcm78/EYnmwbNwCl8FOdS0dwqPt0f7Y=;
	b=j6+Jb2DUNuDTgyLkT8P3dkpO+CJ+tX2ecLNPiO/pp8qkcSVNK3jHeQUyaXVLnlnuRI5B8n
	0Va0mO+M0DejOC8cpnGzBuSoJ1/HWdb+y9LnG5gNjyig2YXtshRMvCrzsFY6HvX87PYZvf
	RmxhKvO5BrRs04UEmzHFp1pv1EJEWV8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770398057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z73YqVi28uxxhcm78/EYnmwbNwCl8FOdS0dwqPt0f7Y=;
	b=+WIS4NGbvV7/KSSc7+n9BNQHqhpKwo39WaYXAKAf/VXJOO7yQy2+H2qFwF+pyT/DpmqW4z
	KMiDKgBB2zApEGDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770398057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z73YqVi28uxxhcm78/EYnmwbNwCl8FOdS0dwqPt0f7Y=;
	b=j6+Jb2DUNuDTgyLkT8P3dkpO+CJ+tX2ecLNPiO/pp8qkcSVNK3jHeQUyaXVLnlnuRI5B8n
	0Va0mO+M0DejOC8cpnGzBuSoJ1/HWdb+y9LnG5gNjyig2YXtshRMvCrzsFY6HvX87PYZvf
	RmxhKvO5BrRs04UEmzHFp1pv1EJEWV8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770398057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z73YqVi28uxxhcm78/EYnmwbNwCl8FOdS0dwqPt0f7Y=;
	b=+WIS4NGbvV7/KSSc7+n9BNQHqhpKwo39WaYXAKAf/VXJOO7yQy2+H2qFwF+pyT/DpmqW4z
	KMiDKgBB2zApEGDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFB943EA63;
	Fri,  6 Feb 2026 17:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ztnsLmMhhmm+LAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Feb 2026 17:14:11 +0000
Date: Fri, 6 Feb 2026 17:14:10 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Matthew Brost <matthew.brost@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise <bcrl@kvack.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>, 
	David Howells <dhowells@redhat.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-erofs@lists.ozlabs.org, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	devel@lists.orangefs.org, linux-xfs@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 03/13] mm: add mk_vma_flags() bitmap flag macro helper
Message-ID: <mflwgdnyipdf4reufmbx7qarjcgouct5coe2bllticrabcu6rt@vf3bvmpunimw>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <fde00df6ff7fb8c4b42cc0defa5a4924c7a1943a.1769097829.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fde00df6ff7fb8c4b42cc0defa5a4924c7a1943a.1769097829.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: qtskhrqq6phxbfxxcomwhducy7rjznqr
X-Rspam-User: 
X-Rspamd-Queue-Id: C89B21C0007
X-HE-Tag: 1770398058-873724
X-HE-Meta: U2FsdGVkX1/5f7Wl0kjrEqyJaKq5++G52pYHQtSLbpL9SZ7xKMR/aRmZ7ZC80d3XRXrdEuGFOArevY1XYtYeHyNPbzUW77iwF85yxkehzc2F+/qNmVQGmO64SOzAL3+KVWLx0psaV1VkkzlsfrNwJN4D3omG15+M+1JAjNVUBnQy21IvFQLx2tIYGVkds3HKV6GI8L4iNBnafYLTa2X5nGSbWi0xFtd3QFazYRelael0OcVVpyd4fbR1cZ0z6EFrBQlG869Hpa/24U4DkRiX3snEmlajkk007Ims8K8P+D9UlRD0ELb1Kjok65k/sNUdgni6UTkurrQ5Sg++ARx3LrXdyfcYGGGA4S3VKpbm+vkVcd3ZEM9OF9vJJPAikMCdgs13FB2Sbx/7MHGS5BXoxH8c2tuksTuXSKHU7T9T/RNTgGyb3mlH5we/9CAwvPeUI7jf+ksdocGdNHNfuWOSgwuOb3kz71oIsN4HaXR0ILfiF4fZpEdd3SBHx+Qq8zxqXbCq+S6o8JnDCs2qQKT/FSS2WPEcR7MCBhs9LETEYfxHHUGj4QHMtWFQgWWgvJvGzuZd9Ut2Q3nqqUN3CQhuna35sumLucFq4CRag2slpw6nxI1Yb3zjZSuLwkX5xBTZhMxjP0qhSg5X3xhTJ6mjnV6TAY+3bEcBbF4/J4p+ifrX9s+W56nwsy/j+5vbUrQiKLhOPW6oxYww96GW2scUNceM/+v98C8LKT6MxhI1NElaaw6eK3+KY+MGPhls/rZpG6EpjLeVV0FRKSzFYLrAULujWwqthHfpyjxYpQD/4chYyf0bSmvIP9GuQc7kurQlUDdBl+iFodVZEziLp3iCY+yyUQ94bzv9zpZ88ODbHigYVNhbTSanwzNY96O62OcU1FxBBmkefutWXKQrigW5U1853e1WiksBmo4mQB8BLbiRh6azYk2h7j1L4Y4huxamXLdm0xb24sUtFuwFVET
 Em8UstzL
 2SFVn4zdc8AmpZAswdG0Xa/0XrlZO17IMMopJ66M23Dx0N6z163jgTNb2EzCuGTel3F/2Fb8tSJjCyRSDWyCvnjP3ytnPqeGLe7b5atHUWoEpjt68F/Yi3xsI9YQRJ/Ukv/qhFZNUx7bj37NtXcV1e5a7BHXa3GOoQq2A2J8mAzg0LBl+W7fD1D/tuQiscJ96ZjhbWONBAhP3ek7Lp6UDhh2Ppk8Iu9Koqw15WLHMLggzZ/8oXsmSXXD6sIXhcSmOKTYhjTl802+6g2X5gj8ta8c3Yul0tcLjIMhVETAcCEO5JHEMth1p9dTe1PBUW+UfwhPd7xl03gEJuf6V59C5EO6LFNZvKMvfdvk1rRTzLhEcTrkFSaTc799uOUs2ucgyaAtQa39XI7DnAeWO4DTAlZ2OZEAU/teNVPDjY/dsDe1ZCEgkmth1BdNAlwOgySOC1RseYAGIp3qEx4ODlDE//UMJ8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:06:12PM +0000, Lorenzo Stoakes wrote:
> This patch introduces the mk_vma_flags() macro helper to allow easy
> manipulation of VMA flags utilising the new bitmap representation
> implemented of VMA flags defined by the vma_flags_t type.
> 
> It is a variadic macro which provides a bitwise-or'd representation of all
> of each individual VMA flag specified.
> 
> Note that, while we maintain VM_xxx flags for backwards compatibility until
> the conversion is complete, we define VMA flags of type vma_flag_t using
> VMA_xxx_BIT to avoid confusing the two.
> 
> This helper macro therefore can be used thusly:
> 
> vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT);
> 
> We allow for up to 5 flags to specified at a time which should accommodate
> all current kernel uses of combined VMA flags.
>

How do you allow up to 5 flags? I don't see any such limitation in the code?
 
> Testing has demonstrated that the compiler optimises this code such that it
> generates the same assembly utilising this macro as it does if the flags
> were specified manually, for instance:
> 
> vma_flags_t get_flags(void)
> {
> 	return mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT);
> }
> 
> Generates the same code as:
> 
> vma_flags_t get_flags(void)
> {
> 	vma_flags_t flags;
> 
> 	vma_flags_clear_all(&flags);
> 	vma_flag_set(&flags, VMA_READ_BIT);
> 	vma_flag_set(&flags, VMA_WRITE_BIT);
> 	vma_flag_set(&flags, VMA_EXEC_BIT);
> 
> 	return flags;
> }
> 
> And:
> 
> vma_flags_t get_flags(void)
> {
> 	vma_flags_t flags;
> 	unsigned long *bitmap = ACCESS_PRIVATE(&flags, __vma_flags);
> 
> 	*bitmap = 1UL << (__force int)VMA_READ_BIT;
> 	*bitmap |= 1UL << (__force int)VMA_WRITE_BIT;
> 	*bitmap |= 1UL << (__force int)VMA_EXEC_BIT;
> 
> 	return flags;
> }
> 
> That is:
> 
> get_flags:
>         movl    $7, %eax
>         ret
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

