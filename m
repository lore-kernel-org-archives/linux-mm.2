Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6ECEE20B6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7906B0092; Fri,  6 Feb 2026 12:04:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8546B0098; Fri,  6 Feb 2026 12:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A319E6B0093; Fri,  6 Feb 2026 12:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 888086B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:04:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41A4CD5961
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:04:59 +0000 (UTC)
X-FDA: 84414656718.30.4F9AF2B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id F28BBA0013
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:04:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=c0m+A8Cb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9dogZ3on;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=c0m+A8Cb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9dogZ3on;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770397497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3g+CeqAHKY80QYlzK7Q90kGJJbcwGzuOMv3DI6coiUI=;
	b=W2n+VZxnuK9tSZHE6X2+K8S2z/4gMdWKzC9pAWTMqMuBsHN3dLCPxTPesmvPFns9U6HALh
	L4YDDpT99m96OJvmFnE4JQrwZmcN5lCz+XdPx7szHH3FsEN6oTg2O6yvXaeliFkr9HKo4g
	0ptu+DICU1cHzWzWjt+9b748bRYcyl0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=c0m+A8Cb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9dogZ3on;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=c0m+A8Cb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9dogZ3on;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770397497; a=rsa-sha256;
	cv=none;
	b=XTyD5smP9QknxjiTYpVw0d7dXVLdzYytFR1ceBy3lEYkDDJ3cYKNqdhNEKEEfXAOIAY3Ak
	bnZ2hwbDiqIvF7c5N05D7we1gbYj8NjZctB79Ui5c4gWMVyYB4QENXyhN/pn4YTryiylaB
	z8VmYCKK/JpNxfCunRqhiAvNQuskHvk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E26B3E6C2;
	Fri,  6 Feb 2026 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770397495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3g+CeqAHKY80QYlzK7Q90kGJJbcwGzuOMv3DI6coiUI=;
	b=c0m+A8Cbf+rLZ3szeGwqR0keK2N4x1OkUaeOPTkf3sMJNCpTeUBur5IDP+DKAQ2eQgejrS
	zIEXRT0ObUT+WOhQz/vocMcAjoOtK+Zb3qEnwu8Gthjmkgjq2Xsl8B20qlBNlf2GpU40xr
	mQI9AS7BtgLrI9P4+fMTgCEFkGS9Q6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770397495;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3g+CeqAHKY80QYlzK7Q90kGJJbcwGzuOMv3DI6coiUI=;
	b=9dogZ3on7nsX+Y0Jpn32RxODAdydoZXUQ8/EzP5Y+0myTaTkASY5FCgVI2NW4EsJx7Wp53
	E9r9FSnoaQE1aJBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770397495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3g+CeqAHKY80QYlzK7Q90kGJJbcwGzuOMv3DI6coiUI=;
	b=c0m+A8Cbf+rLZ3szeGwqR0keK2N4x1OkUaeOPTkf3sMJNCpTeUBur5IDP+DKAQ2eQgejrS
	zIEXRT0ObUT+WOhQz/vocMcAjoOtK+Zb3qEnwu8Gthjmkgjq2Xsl8B20qlBNlf2GpU40xr
	mQI9AS7BtgLrI9P4+fMTgCEFkGS9Q6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770397495;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3g+CeqAHKY80QYlzK7Q90kGJJbcwGzuOMv3DI6coiUI=;
	b=9dogZ3on7nsX+Y0Jpn32RxODAdydoZXUQ8/EzP5Y+0myTaTkASY5FCgVI2NW4EsJx7Wp53
	E9r9FSnoaQE1aJBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 517453EA63;
	Fri,  6 Feb 2026 17:04:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cV+8EDIfhml0FwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Feb 2026 17:04:50 +0000
Date: Fri, 6 Feb 2026 17:04:44 +0000
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
Subject: Re: [PATCH v2 02/13] mm: rename vma_flag_test/set_atomic() to
 vma_test/set_atomic_flag()
Message-ID: <5pqsv3quguk6mwxywdqpvkcxhmqjoupqq44pserucrlelnyvnc@tkwpixdhcw5i>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <033dcf12e819dee5064582bced9b12ea346d1607.1769097829.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <033dcf12e819dee5064582bced9b12ea346d1607.1769097829.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: 4gmyqqy3t5tt3k8b9wgjy4rwkg4dphd8
X-Rspamd-Queue-Id: F28BBA0013
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770397496-357569
X-HE-Meta: U2FsdGVkX185+Te+EhlRnZLLEbi4k6bYicYvv3M6je6+etf5fWxsa97RqqHVi2FwM9qeXYPxgFnaQh4MRTC2l5kcbubjCFj/mwIzV8LCCu2r8ggzWDk+W06OfC8kiY9ziweHSdei8PO8mwVQJLxfKb6g20+gDrHzJwJJkJ8PiIzaYTcBXHB6W3p5xcN5J/sNSRlVKkxz3cyd41DW3M9cIMpZq8RVl1XXQGMNITQ16PeHYnPI7y1bdaK2PvVCy7PV2I/1PYDxCB6yKSiyU9ZzuVjYfY6EorRp6u771jPl1mGNO22SzJk8om0tB3B/o+KxSjglTQWv9g8+Ti3LOjVtUJKBrqPbrhk+nSP8xjcptGKaD2U3gJc5edNDs9/2pakX1Y0GPa+PSTgEnM7eTOMjKTXHQHJW0ZQ07N72PGiYhsx0ebRb4SxOWMxxf/LlHq+bfIyE5akew3wn/ibTmktHZkF1XDo0pPuoxXvqsXCwGBvMfq2W+ccKr/30k+A9so/OEBDQzmYvBs0C4Ulo/6+7mUYtTzU6Y6jOuX89Gm0QIfoc16vQh4Ab+K5OCqs/Ci5lsv9FFy7VMMhoThWw+EBMawtxanW0qjtcfl+8PQpGnrFG5uxqX5wGcP+PjgisHLS3LXdbIiP/Y1iKL7bn8RwAJ7vRN5nBy30lM9ByIxA5fxjBsrjomSNu5MBKEyT8A5CzygajfzPr0fQGb5bx6grV+fg4/WdoOr3Q3ko2a8jGmQmDAtRzyF5UBolLdqY+ZJ2U4dc3QaxebMFXSSrmk46Wu0qycaIfFf7Vca2rJgnsPHREDhT1QgNFk0rrluSawLg+dNQb6OF8DClAuZj04MzIFrdwr7uS+bUjI489tzg62tw9MqSDJd1PKqLZKhP6RWjgwazDtPDz0ONSzOZhKJPvrQeySpZOZZ7X719MgYagPL31EkjDxocxzkRQ5Sin63IJGnEjdBQGIo6wJolIJ5K
 6H0f+bba
 5djgHGHOD90y0jor0FM09Oj85rH+lhOMeQeAAPnfji48AdjY6zr/r3ckM1UwOrNxv3q7LJ1ySU6ic3JoYJmvTlaT4bZ26heq59gUhb1rCDUlegBdfNsQBA+qdlmym3vmGWIXip2O+65SACh8mErktlvOTQSLHlwp4eRpIN4mNTRdmisQXMjFId8T3oBW1m5q9I52GoPlhGENdSx4h2UsY+mjmFUUbC+w8vF3lgP3Y+G0N7ILPAi9Owjf2+ZSu+NsvBJ5FYpfQhTMydeohUUqcY7X1qSlxllu3unFyTh3Tx6STcMB0RJtM6iEHibj/hw8lb01gLbTO1MC+AjWVr5xBRuZVXg6NilBmWwMDcxExaQkjwgMP755OWYtokuPcXbMmObNFlgfa6nukbo1qCOscbxPtFJsndvY4fxw3PLPyIdzwI8JdKUi9u9MRS9p+9yjOrzrq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:06:11PM +0000, Lorenzo Stoakes wrote:
> In order to stay consistent between functions which manipulate a vm_flags_t
> argument of the form of vma_flags_...() and those which manipulate a
> VMA (in this case the flags field of a VMA), rename
> vma_flag_[test/set]_atomic() to vma_[test/set]_atomic_flag().
> 
> This lays the groundwork for adding VMA flag manipulation functions in a
> subsequent commit.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

