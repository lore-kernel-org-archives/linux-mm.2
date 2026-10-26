Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798B9606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=uopeR3+Y;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Wll9aDuj;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=uopeR3+Y;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Wll9aDuj
Received: by kanga.kvack.org (Postfix)
	id 951BF6B05B5; Mon, 26 Oct 2026 09:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9028F6B05B6; Mon, 26 Oct 2026 09:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819336B05B8; Mon, 26 Oct 2026 09:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5841A6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:48:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4F4114073F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:48:47 +0000 (UTC)
X-FDA: 85364907894.24.7AFBAA5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id BC8B8180009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:48:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uopeR3+Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wll9aDuj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uopeR3+Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wll9aDuj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793022526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yP0V5dOx0YO4fZNuCXNFqmxCdOLoRslWQpoAPj27BjQ=;
	b=tWT5usYi0nwthdHxN/Cuz+xxKOJKfODYXOP1wlceMii96t16nHraHcc10Q/K9ZXIuBTyMT
	y/OV6eVLdA7AQjP0Ww0W4OMUeDe+w/9ZzpU3ZTgHzeXxOZlmjeFF0hOTyA2V7PRIkx66x8
	E716RuZNrKxj6CUem6CyY7Ep7xaIfyE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uopeR3+Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wll9aDuj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uopeR3+Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Wll9aDuj;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793022526;
	b=qQ3+MGeT0wTCWYFteik4zTBLiLeNzpE7B4mWFqjOpHYZvg/O2s+anuzYkT4VSf/SkUmdey
	z3smUCSM0uehm0sFup1ry3zhYS1lhbjlgHwgP8B2i87vofknhGXLtqgY8htv1J25kqdHlj
	r9OWkPTa0Js70pxRZijqvUYB3u6Q5Xo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 533622226F;
	Mon, 26 Oct 2026 13:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793022524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yP0V5dOx0YO4fZNuCXNFqmxCdOLoRslWQpoAPj27BjQ=;
	b=uopeR3+YKol5ATzXAwpo12xIA04uZUKtn8Xlbm+bG1UtFPDMXdfbfhHaQAhe1OOYqYa5ey
	5b/Oq2W0AzFN/jn1ClmSoQahB4HHDbmOa/GVk1oJjAaXa4yKn2uPqc/RNZISA9u4fXc992
	D1uSJw1phjJnQMJYvYXRCg0KTRphYkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793022524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yP0V5dOx0YO4fZNuCXNFqmxCdOLoRslWQpoAPj27BjQ=;
	b=Wll9aDujcUb33Y7ZGIxHFjnZ/3r5B6MKuypze5E7gU/FGlPwaCL0xpu0PkFdRGsfNbPPlv
	Bm/js9tHG7t/XGDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793022524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yP0V5dOx0YO4fZNuCXNFqmxCdOLoRslWQpoAPj27BjQ=;
	b=uopeR3+YKol5ATzXAwpo12xIA04uZUKtn8Xlbm+bG1UtFPDMXdfbfhHaQAhe1OOYqYa5ey
	5b/Oq2W0AzFN/jn1ClmSoQahB4HHDbmOa/GVk1oJjAaXa4yKn2uPqc/RNZISA9u4fXc992
	D1uSJw1phjJnQMJYvYXRCg0KTRphYkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793022524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yP0V5dOx0YO4fZNuCXNFqmxCdOLoRslWQpoAPj27BjQ=;
	b=Wll9aDujcUb33Y7ZGIxHFjnZ/3r5B6MKuypze5E7gU/FGlPwaCL0xpu0PkFdRGsfNbPPlv
	Bm/js9tHG7t/XGDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA4B313408;
	Mon, 26 Oct 2026 13:48:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lZ+9JDla32oiDQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 13:48:41 +0000
Date: Mon, 26 Oct 2026 13:48:39 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 04/16] mm/shmem: honour F_SEAL_EXEC when an ACL is set
Message-ID: <at9Y_cFWYXX5wjse@pedro-suse.tail5790ac.ts.net>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-4-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-4-703206d5fa0c@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: BC8B8180009
X-Stat-Signature: onii5w8jxazwq1fu3s9a7ihxnyoqbg5u
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793022525-899275
X-HE-Meta: U2FsdGVkX1+mrZcCGrayEP5suqb7GLuDmm/slBJkPIzgcnJkM0Jk4GT0Rwr06EQZvlxPzLZnhAwa1h8SY8k+bbfMMv+cLo/2cPxAaEe8fN4rkUf/30OHMIEB6B4IJ7W1CP4L1VTZAOBfC5ReOFq8Oa4QuVNFi8qzXh6b/CUry/YjqL1CzxJlzUX2JzdFp1SBiWg6MudIJ9GFJAq69cotD5hu7bu7k3MnLN0aR0GBYm5hKdWwLnTGxQkAxcQmkKWeTpOtlk620n42xnhH2O0fcfTSCxKjnR9GwmpMCFysFdCbct6OGNgK2m1YFAZED1H62WgvsbgenWXrJDBy/xTj8WbscvJzoc7fJ1ufGIR3Ks6rypmDK7nbDAquQcgAIRjccmKY0nxhO0f3BNWGaNG7SB0Vux3VAeiW+GzobDbg39sMli/UsFyWiq/eWkRIr6xvPNqq1unf7A6rVGz/qt4cpAMKIt8a9wt3FMvRQijrcVzx+RnwTWcxjj5T6+lTPGTh74VpLOap15Jt64ZQv2vDfptAPlrp5BCO6DZjyQOs3HOb8x+U9nwB5nckvlHrkAuMpCGoClh/11vk2iSh7ZlYVmXfuXW0YHAc72Lo0L3LaxGGe3lg5BiQGYJLOmXtmt+wxsgClL0alt5ThJoik+lms2q5BET3gUU4dg3uva4eUyWdRM+LXXZcedTE/apj4ihTPPKE3oyHioRy2zlfz6DKyV5kqd9pWzYP60mAjoEQnXscg8oQ4/jYBnwqcsGldkdshYXmV7MRar3EnCOg+DGgQTx0Rn2iPvg8/DyhMIabAUR3/uVFNyDh41GrNtW/Z2v9vaaEg9mHti9CHVlvkymwsMK076U4rse3/GWIGennYpZTrVy5SPu0VhHyMmDK1oKoPD0JpGcYBLzvjqkq5VfKF+HwpGub6aWhMk0Dl3395FPysqqImwdb1xU/FZBgk3q2MKoUqdkcKmrPkwJC3bS
 HYT8CLPF
 kB31m7gkQUY4hXbRoqe8cTlMUB3snxQ4hihTVIXjhQmxzNIuKT2bCwIlO7aygm6rL4NT4lJu20Kb3jPXuHK/ycMNgb3KErBRmzEJrrtXxe2x4BxaOJldBMGkQYBF715XgDwOPS8Vvxtd+hcFvdZudYAS3S94bK5tlrrdNGSNfEo/e333SHE4bh6xapiy0tBbwEb1TGGkcDdASvnD1ZeInynfGFYq+BaVEcmb9oPQcJWlT3UM0jANfIipC9dmiCjSnO9w+a6YbwA3Yk9YwEisFsb3RzBPchu25Kzkku6UhxcBqZJOjxFEMrCfH+sVyXXh1C4ojTh0jnzgdDG9rf5qkcZGstxZzwkDsRohwThJz7M2urtoXO8lgC13U3uc6pJ0k5xVODEZvY0WRkqyS0zw+nZJnML64JHoR5fba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:37AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> The owner of a memfd sealed with F_SEAL_EXEC can still change its
> execute bits by setting a POSIX access ACL. With CONFIG_TMPFS_POSIX_ACL,
> this lets an unprivileged owner make a non-executable memfd executable,
> bypassing vm.memfd_noexec=2.
> 
> simple_set_acl() updates i_mode directly, bypassing the seal check in
> shmem_setattr(). Add shmem_set_acl() to check the resulting mode. Share
> the F_SEAL_EXEC check with shmem_setattr() using memfd_check_seals_mode()
> in include/linux/memfd.h.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: use common helper; simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Looks ok, as far as I understand ACLs :)

Acked-by: Pedro Falcato <pfalcato@suse.de>


-- 
Pedro

