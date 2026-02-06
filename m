Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F11EE6B43
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A359C6B0096; Fri,  6 Feb 2026 12:36:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4346B0093; Fri,  6 Feb 2026 12:36:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C346B0092; Fri,  6 Feb 2026 12:36:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 602BA6B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:36:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A71ED596D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:36:01 +0000 (UTC)
X-FDA: 84414734922.22.0772BFF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id D1CBA8000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:35:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1shQewP2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JHUa9amE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U5YPWMVu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9GrzkJr3;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770399359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	b=Au7IqLLC4ux49jG0njEjDSfyUzWe+/Iyn78VwvdtXUzXQ+W+3ZnQS6SJWKvHB/m+/WjVlq
	k+DtcNWS27Dz6V3t39NYasigVQ1szRI7UULzqS7pQMzN2A7BV3iSFS4gDKe/ThkyWAw6bg
	lPXwv8E+vPRPuUcu+82n9f6C/nBK2Uo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1shQewP2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JHUa9amE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=U5YPWMVu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9GrzkJr3;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770399359; a=rsa-sha256;
	cv=none;
	b=Jhachjvdt89/t1i/rYXR2hBfze4ICfLc3DrcsPA9CqlohYBHBvdQZzm2M1s/01EdKCDly7
	BBxwDDXGptL6YGWFIig6JN66Tf9TujQ5CWjdUIMQa871GjeCP3RZCeZPX3A+ADx4FxTHLC
	cbhC2w8hEkEfzR1KReRc1jv1QqLQLNQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F4285BCC2;
	Fri,  6 Feb 2026 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770399357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	b=1shQewP2LmWP3MFSMYtX8w+6zZn7aKBAlTFRTxiOvTX7R2E4CohJmoLwXsU1vTDbMz0iaS
	R2jXA7lFXktcPsgpxf12asWwe05gSqhUXi2iIsQ4/rI0b42DF2zGDL5ZS3bP0iKXY3o8fL
	Y0jvZhjo5dSUxzqwtgF16yf6fyBAmG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770399357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	b=JHUa9amEudPDM/4AySdJYeBKvZjF3HgEUfc5fY+W7hCNTZniiVkpoa0tvklosfEcBmNFGg
	KejMN7mwEDAwKlAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770399356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	b=U5YPWMVuexsLJCN9qapqSzJxhLnp84h/q7W92XbfAQUBhKRC87Wf1KYyxW+DhTX1iRGVH0
	GHDnk8h5kAzOs/VSDW/GoZZCY7O++wzHGjG4gE148WnPmHOtLHOjuxzJQXQk+HoAKrhM4I
	0pr/H/TJ/u6VuF6wpAnJn14EI8JyEUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770399356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VJUA43BGvzwxesp6EkqhFxBoO3OZeDjhsPe0maEveNQ=;
	b=9GrzkJr3/8NpPU6pAbKRUHmvzT482Kxxzhuv98BaxytL/Sy/DuDnzluD397tP3YK7WyJ5w
	cQBGHJgBEnX0wYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2D5E3EA63;
	Fri,  6 Feb 2026 17:35:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HOILOHYmhmm0CAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Feb 2026 17:35:50 +0000
Date: Fri, 6 Feb 2026 17:35:49 +0000
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
Subject: Re: [PATCH v2 05/13] mm: add basic VMA flag operation helper
 functions
Message-ID: <vrbggto75ugvpa5wtugmayr7yops6cnvygit42f2md646y6qnx@3vzc7taleijw>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <885d4897d67a6a57c0b07fa182a7055ad752df11.1769097829.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <885d4897d67a6a57c0b07fa182a7055ad752df11.1769097829.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1CBA8000F
X-Stat-Signature: sfny7xidqw7ogx16yy8bk5y8scnhgt9z
X-Rspam-User: 
X-HE-Tag: 1770399358-814613
X-HE-Meta: U2FsdGVkX1+FU+7neKYlngd0vIvmVdWbxf3z2mftUSM9BbL/JIRqxzTghMLZqpNoai5B5oPtG4kxWkQ8wFKsJBxwi/JYyCcd8d/v+IG2VjjE2wjiKd/l6OWnHNiKL19iBLSHCcYejuV7mRAoE2VYdj2o9OmUildJDA/sRhnnhPglFTPIITZvhxCZMUIxRnRrnL4SljKAyjatuEmcD3PbEKmJJQxDWGCtt3/cqaYNdmA8ORIYVCSaEoIqI6gaGh53PyF/w7z2h+cyLSfhy6Tq7x4TPt7A4GOo9YX/KEWk5qPGbBekkoWV7oA90ypF/u7e+UP+BN5TlCFJ+6fi22B6P2npno4tct5Hgha5exCCpKIT2DeG9tggQqskEWl1SKbQYQYfC2YpTXx0I65YR+lKatgbnqSvfC0yP2GpluA/d3IYQKrUFBQd1H1LSjJaTKySHh5Cz/EV2mLP964k4wMocrmelR3A6nzkuqYTksbYp5nFZ0m8jEqTjVDf09XGTvWrzJ5TYNb45PGe2M+cJ33V5Jfsa59scQ9ZUFAEKrGxlzM8+pD2cWc76M4w8/NyFqRyChLSDMML9JkccQ/aTEirjRtv8muCBjUw0BGlYGGGYtWWHhFyvGaapQqZ8HWfiVNaKyJ4tT5unyntzjYXIUXoI2xwKjkC7hEnKVumWd80Sz33lmPDccdPwJNU66krvqYFJA6kR9HxIt99yWKvEy9Q9LdGi8VNXnly+H/1xZPiiAkR8gp1AbsZTR9MzJ1INX6WfjkNxJjzOySsWWdSV82bNmPJJ9szU7RyaMG4UU+LsFLIqj5SLFj/f0ThATlUaQFVOMg6FnjXKIf2goqYHtiKQJzQ8IPr1tW8TaNmN60QDhkwowIDclpAchnKfbVsqJpUzigQZMRKMt0O/dIaGCfNqGkbh0Y/rC9I/V1FX7mGUNB+LhkLv5VH4tEXRkozWH3NFW8gedPevf3i4WHBnKx
 Ei6SQtMX
 60PRQMQ5sGm/vXuo8eZmsrPn8Sl8SmfFnWeUzOlfYjMAwLZR4dM0iU7QgrXn9gXVs2U1pRYdMnicnF4TpF/Kx/59Kze9OrReYTifjrMXZQOwPoonNDZlSit/WZZF2X1aaN+6/uv3JLPSUIYzwHkfUwltl1lUPhTF8Lee+D7u0xKwnbB2CXeMNTq5NIRGNex/eZStLTtm9Rl9GUiZQXJnfmyYnNt0yRg8BYeaVrkyW2Vmqdy4M5Fz7ChiaUke2N72BpyAINM08L/Udy5tZ/+IGKEpaIEQ6eX2g/0S5NVKyq8CNY9BMlEE1yFqHHTMiLtb5XxP8MHk9wBjrS5/QmS2JPiru27MQ0zGalbIOyS0zbc1Qtm8sv+G75LqzI493LooTCbCYOuIBrPidVaI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:06:14PM +0000, Lorenzo Stoakes wrote:
> Now we have the mk_vma_flags() macro helper which permits easy
> specification of any number of VMA flags, add helper functions which
> operate with vma_flags_t parameters.
> 
> This patch provides vma_flags_test[_mask](), vma_flags_set[_mask]() and
> vma_flags_clear[_mask]() respectively testing, setting and clearing flags
> with the _mask variants accepting vma_flag_t parameters, and the non-mask
> variants implemented as macros which accept a list of flags.
> 
> This allows us to trivially test/set/clear aggregate VMA flag values as
> necessary, for instance:
> 
> 	if (vma_flags_test(&flags, VMA_READ_BIT, VMA_WRITE_BIT))
> 		goto readwrite;

I'm not a huge fan of the _test ambiguity here, but more words makes it uglier :/
I think I can live with it though.

> 
> 	vma_flags_set(&flags, VMA_READ_BIT, VMA_WRITE_BIT);
> 
> 	vma_flags_clear(&flags, VMA_READ_BIT, VMA_WRITE_BIT);
> 

The variadic-ness here is very nice though.

> We also add a function for testing that ALL flags are set for convenience,
> e.g.:
> 
> 	if (vma_flags_test_all(&flags, VMA_READ_BIT, VMA_MAYREAD_BIT)) {
> 		/* Both READ and MAYREAD flags set */
> 		...
> 	}
> 
> The compiler generates optimal assembly for each such that they behave as
> if the caller were setting the bitmap flags manually.
> 
> This is important for e.g. drivers which manipulate flag values rather than
> a VMA's specific flag values.
> 
> We also add helpers for testing, setting and clearing flags for VMA's and
> VMA descriptors to reduce boilerplate.
> 
> Also add the EMPTY_VMA_FLAGS define to aid initialisation of empty flags.
> 
> Finally, update the userland VMA tests to add the helpers there so they can
> be utilised as part of userland testing.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

