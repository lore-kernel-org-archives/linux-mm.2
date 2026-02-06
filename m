Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D7E7EE6B44
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B923A6B0098; Fri,  6 Feb 2026 12:49:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5EFA6B009B; Fri,  6 Feb 2026 12:49:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF436B0099; Fri,  6 Feb 2026 12:49:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 830086B009B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:49:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3633857AF4
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:49:27 +0000 (UTC)
X-FDA: 84414768774.14.A1E67A1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id E9603140006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:49:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/6Zba67";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VW1vXPJJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/6Zba67";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VW1vXPJJ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770400165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nnMxCJOvkMnPQbgpeWt8SUXPOQ8u/RYZLzkpyQtNU0s=;
	b=w4r2T/ELczOXtkCdAo2CUt2AtKh5UOhixebj1sB9GrxfNvI8sCwa8caJBbjeKgOwUfdk85
	9GMwQJT1LfAvf5/uo/dXqKPU0HtYZbUaHXrjdW9uUyMfEwKVPzrKjmGIwMWggh8HgleYfJ
	VdPuW94jSSMYwktleSXvIpGS7Q/Pf2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770400165; a=rsa-sha256;
	cv=none;
	b=OliJqBJcKFAe5L0/DLqZ9p9Bp8aOnsR1ehnqdw+ksuSNxh0u5VScPrlkkVZwdVaN2pPEEQ
	JEZ8x7vlNUMQrb9hAuSr9n8N9WA9NBuu3WTlMKzE9lT50FY2RXEDvam34E0Yjm5L4r0qjd
	ivA8KiE7fIB7BckVItx/SWDdti8HeQM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/6Zba67";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VW1vXPJJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/6Zba67";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VW1vXPJJ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4DAFE5BCC2;
	Fri,  6 Feb 2026 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770400163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nnMxCJOvkMnPQbgpeWt8SUXPOQ8u/RYZLzkpyQtNU0s=;
	b=l/6Zba67Dnl6MO5r45aEnmU/0Sy5VA+9L3FbrHCuAfzmUMwsNylgYfhSVWQB/uDgmn3zWw
	pXO17HtXCkzNZFL/1kN7VPu/BsabSIfWDKpXYEAVOliWZ3TXRbUJH6HockJNMFaOpcv/ao
	8HD8U2hWJypGgvy0Os4tE9utodzVrBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770400163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nnMxCJOvkMnPQbgpeWt8SUXPOQ8u/RYZLzkpyQtNU0s=;
	b=VW1vXPJJm/PyJhpbRk3VzSHGpdvIxAaRA1qWZ/9gSIg4SYPT/R4A+CUqL6ZzaMX6v5ujwO
	WFpMfpbKDvFP1tAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770400163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nnMxCJOvkMnPQbgpeWt8SUXPOQ8u/RYZLzkpyQtNU0s=;
	b=l/6Zba67Dnl6MO5r45aEnmU/0Sy5VA+9L3FbrHCuAfzmUMwsNylgYfhSVWQB/uDgmn3zWw
	pXO17HtXCkzNZFL/1kN7VPu/BsabSIfWDKpXYEAVOliWZ3TXRbUJH6HockJNMFaOpcv/ao
	8HD8U2hWJypGgvy0Os4tE9utodzVrBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770400163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nnMxCJOvkMnPQbgpeWt8SUXPOQ8u/RYZLzkpyQtNU0s=;
	b=VW1vXPJJm/PyJhpbRk3VzSHGpdvIxAaRA1qWZ/9gSIg4SYPT/R4A+CUqL6ZzaMX6v5ujwO
	WFpMfpbKDvFP1tAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 010C93EA63;
	Fri,  6 Feb 2026 17:49:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q7b0N50phmn3XgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Feb 2026 17:49:17 +0000
Date: Fri, 6 Feb 2026 17:49:12 +0000
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
Subject: Re: [PATCH v2 10/13] mm: make vm_area_desc utilise vma_flags_t only
Message-ID: <224p7l6o6vsve6uv654wbrhmlo6lxbvzh6hm33fsoujhftuunf@zhf66q54ldlc>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <fd2a2938b246b4505321954062b1caba7acfc77a.1769097829.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd2a2938b246b4505321954062b1caba7acfc77a.1769097829.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E9603140006
X-Stat-Signature: abkws3pe5s1xjhyjpsmxz8w4whksp9bp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770400164-404432
X-HE-Meta: U2FsdGVkX1/M7tAL9xzU2Lf6HcP3mbcdqKNw9OlEGPC1IhF31fQoA9Vq0TgKWa5fIQXDU6BMZSQHytDHeuXB0LX1/68T43N9AsHm27RBcqvCuo5Bph9EStW4cdYfpnjm+w6rwFb97fZqumiiGSgOWWNKpR4KeSr5/OYgpuQBY96qnnyObVmp02aEFs8TJDMcLT6XYy1SdXvOoepiOzmnZaMNt0vAj8tyVMr9Tvi4o0j4KR4eGJQ9/0BbS8DdGOK5Jil3RXwwo+Yeuo7SWCfB7x7zkPoOMfJRkypvn4iYvZt0PO8cVYh+JvFt1/bF/IQjNKYu9lRcf/tsnUhre3pZSD0iMYxM9f1XAlQcT6hjjdawBns8W8o1/GJQ3pz4GLKieNfCvM33VwlAUL+pub4N/TRSMT+zghnXllIW3Rs7FvnYRE6YrWUJQGpF0wHSP52oUKUqJYDoT2++quo1odXyhP8ANNCxmxR6l1mj4O/io8jGHJWrR1SN6rcVlkbe8j8Xgsm9rkIPFZ7J3DyB1h8EQTHPBiwAlQGuaXUiDXvyfl4YRlduAbhuIrXaekMGk+URPVLIFueOaV2BmeHXUeYtBs4qg5h70QuzArYOEbhrWCS+Aicv6dnKr61eEse9bo50v1v37NOYtqnRb2LFGaTib0L9w5udsdslx7vRlDlpdSyQkhHDvJc4Oi95IbW3uiweJqEqzCGLjn/IDaHCXSE4xMScan9GNsssel59xp1sU+30DM3jjmhCeSggr++VGmqTFxst2jpNgszeO8DiV+ZrYB26uEDcjcVaYv++Q6OABhysJeGAhW58gM0faAcET/PN5sHjymdXBhH+Kd+anSJpnoM7P7fPYSVhyjvAGoAdUseptUMwFw4H4ETXfkdPSyGTdE+p+MQQm4s2hI+YYryhSQiJEQbqHUrrs/UsTgW99CFQjscRV+TX329sH+r7YTKgEzxVvyJz+R+54xHrNVW
 Y9f668q9
 rdPz7yOPY02Ts8HvluzMkSXoJKtLoBKlx8Ez7BRIZrp9t7xAx5Ve/Y7DrQ9xuS1dFnVr11w0pecTP54TOQ0QDz8uZY+KhKfbBwKz/tE+llJbtdVEI7iSxjrTjzWBFnh5oNSt+jCs7Q0Pj5C8K6uxcUqT3IS7G/pVRbahOzu3WpW4O+scJchrIj/ZGg0Ka91aVdNWC56id257Yry/+4ue45bBttm8vK54+QR45O0FW19gHnmdv56k32OQIjZAAeafr4zSawW0j0t65LPQPOL36qFK1qzh2AuCKTERGgu3UXmCR+jX2PNk8cK5WtvG3ISQVeVJnG4ZJCjGU82RZ+l847HRr67VBgMh42hRxX1P35UjHfx3hbQ+MeMJJ94YzsVsxHPafa25pHkinEkIgbtIzQXl89fJ2SR2KrjTOCelCl5iZ3pJ/Kbe/PiwwxYzVokDrNmXd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:06:19PM +0000, Lorenzo Stoakes wrote:
> Now we have eliminated all uses of vm_area_desc->vm_flags, eliminate this
> field, and have mmap_prepare users utilise the vma_flags_t
> vm_area_desc->vma_flags field only.
> 
> As part of this change we alter is_shared_maywrite() to accept a
> vma_flags_t parameter, and introduce is_shared_maywrite_vm_flags() for use
> with legacy vm_flags_t flags.
> 
> We also update struct mmap_state to add a union between vma_flags and
> vm_flags temporarily until the mmap logic is also converted to using
> vma_flags_t.
> 
> Also update the VMA userland tests to reflect this change.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
 

-- 
Pedro

