Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C203109C030
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1C06B0089; Wed, 25 Mar 2026 10:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B9BA6B0099; Wed, 25 Mar 2026 10:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0486B009B; Wed, 25 Mar 2026 10:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA796B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:57:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2334A5B94E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:57:31 +0000 (UTC)
X-FDA: 84584889102.11.E4A3460
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id DCA6D1C0002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:57:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0X0CLof;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GXLtH7DF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0X0CLof;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GXLtH7DF;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDThzbfm4z51swQNpP/Sz73BBVvad0AbQ7d+bdgHlTI=;
	b=5YAJCfyyjxcSx5i/v7HmaM2TgCqjHElu+hZPpo9J0EVLZapnm/eBAx8cXot+C66S18fEim
	W3D9bWhcyD3E3NGsEOUWvW+rVEQ3iboL5yrs0DVYmvz6Ter3V2VKfNTlGSr0txbrNSUxmQ
	TNaprSyyl2qrVPzsDKZPP2eQlYYRD8k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450649; a=rsa-sha256;
	cv=none;
	b=2aFuFHOcNiAtXy+oeXVtOet31Phi6fKhXCiK1of43sUcoM6nSJ9PWr205Lc9IYJVyX6YNv
	E414hgW6miM0+DL0O253TWXgpqa4j5vzjPDUFJzM8NiTPGSEqIr6lihpe0B5fuDdjwXc4S
	A6qwc8ETxDm4LKQiBW1IApvYdbSbJ7Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0X0CLof;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GXLtH7DF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Z0X0CLof;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GXLtH7DF;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf20.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 69CF44D247;
	Wed, 25 Mar 2026 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TDThzbfm4z51swQNpP/Sz73BBVvad0AbQ7d+bdgHlTI=;
	b=Z0X0CLofVTVeW9Uy5z61QcbE0hv2Mx0SSfcQwg9dLcSDgPk6W38Ah0+h7hQEKiH6UB3Bxo
	3U+NJQF5wTPtYdvt3cLUCXKd0DXwvdMqOcKT1bbuavgUJED1ONu3jhMVCi4DbuhTiapmeG
	QB4/WKUudqPIpKmXBpExPhD5Amfd5IQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450647;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TDThzbfm4z51swQNpP/Sz73BBVvad0AbQ7d+bdgHlTI=;
	b=GXLtH7DFDEli9jy70jmcgm6qgJltNATHWPDFjxipYjbSjh1gVBm0R2nEyXGIdoaeZj6f41
	l/pqruwQ3HZvRIDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TDThzbfm4z51swQNpP/Sz73BBVvad0AbQ7d+bdgHlTI=;
	b=Z0X0CLofVTVeW9Uy5z61QcbE0hv2Mx0SSfcQwg9dLcSDgPk6W38Ah0+h7hQEKiH6UB3Bxo
	3U+NJQF5wTPtYdvt3cLUCXKd0DXwvdMqOcKT1bbuavgUJED1ONu3jhMVCi4DbuhTiapmeG
	QB4/WKUudqPIpKmXBpExPhD5Amfd5IQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450647;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TDThzbfm4z51swQNpP/Sz73BBVvad0AbQ7d+bdgHlTI=;
	b=GXLtH7DFDEli9jy70jmcgm6qgJltNATHWPDFjxipYjbSjh1gVBm0R2nEyXGIdoaeZj6f41
	l/pqruwQ3HZvRIDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B409E44464;
	Wed, 25 Mar 2026 14:57:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3imQKNT3w2lcZQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 14:57:24 +0000
Date: Wed, 25 Mar 2026 14:57:22 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm: reintroduce vma_flags_test() as a singular flag
 test
Message-ID: <palfy4jm7iifa44hjkku4ljlwy6mkvyoq5q2v7a2dilb7fpzui@v54cr4xnd443>
References: <cover.1772704455.git.ljs@kernel.org>
 <f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f33f8d7f16c3f3d286a1dc2cba12c23683073134.1772704455.git.ljs@kernel.org>
X-Rspamd-Queue-Id: DCA6D1C0002
X-Stat-Signature: m7npw7pqmc5qqmnwks4ibf9cn45hfauq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774450648-502245
X-HE-Meta: U2FsdGVkX1/6nknpoZvDRsx1PU/RvNc4+dS9ACRgYrw7iQVJvjQ+7vWcjd8S4B1ZSDV1s8cerS3uG/jGJZjBxHtyqSu1tCr9j10iudsSJAWmhhzSfuWo7pvR1wjX46ITmIi+eHdykFqJuDiEW72WXqmL8ZBhffn8I75CpExeMBJcJLegg8g/HQ16BnPKdPEhyHIZWRln/tRHfETtwAI0u5i7c0KsNDbZVWJu3HYixHDOtzQf31hNjvfjUPccEFRkdSVxihs/RB4TypbWdcMMOBIItxX9FOSFNAsn09ZlLGs6gIES4odp7XoBMmnuIQa3b2bzLg6eNaOWcGOKvnBtBPPiYXwIswQSkCtcRCQ1FJTO2DXJMOYzMB6Y9uVrUAEf4j0S2mBKG3+2lGZIzpVeawx9JDQ6u5D+JY5z4Hcm2kfSpr0sqtb9SQwhBM+ywVWd60YStDM1LOKGUUHtYpQFhdME+9WkZJLkbowfP3k+LUCKN6YhteL9ILCTD9pURoncXFJB4Mm87PznbqWTS3/S8yqLUwIZtzZRrPH5PpRev7UO5utRCquJnSrS4UH/4QQL2r4ZgisbK8Y5zku/xN9iq8FFX33iZfJBQYeLJHgYVFNRiE8hdaASvzeLFw/Iyn8wgH5ZaaRiCtJbz+IY20p1UJ6JtajS7EkvY8zJjaUpFWjh2WBzQLbm31cuHUGIykZHHOSDIcuW3xxTbWqTuA5SuCio7XwX6cIxFLjwBXc59meHv2kkWKwUWG3x+zlMt8mfDRjHRbwz545jAAvHN+5hReu2kdxncmXbuy4nF7UAGmcr5ICpIYLTjr2GL2NNzR+jcz0LELxTFhirIz0cpEWUS7hjSC8GGr1jlgyFOPmz07EZG1NX8l7AG9yfU83d1IHm5gt104GaqRklO3UNRYxzAIJPtX8PSYmJMksqiFyTzxjGDWBdBOctOuabQhQbiO/1vkFyMri0+K5WBcj89h2
 kjCLZYaT
 bmIZETRtwBj6l/FAXLhI/jwZZzLIggP/SQMZwN8YhZBu8LYnoRHii/J6cpkhBkm5oLXZ1fGbSDnb7+exfpF8Mmhm4dD+rlqFQ80I+pq+Mo3G7BQC3/xU05To5jcr2z0oiHlN5f2AsChGwqnm01yGmts5bWU4uS3O3T+Ybyef8sVSv3/utsJ7jMjIeFKTRyCkZmrxU+4h4lkWd/DrsUz5Lr0RT5WwdQfj8GmI+92qN9aSE0+10YhRDwTVFI/4R3hg1fXw/ylxqsUSlUIMhUlu9ucZw7kygLENquQUd51CfYaJF9ZnvGmOrrwTkFw4g0RKoXXWkyqWtLCn0ndraSjHDgB1etuqjHs9j6bVl/Eqsf/spisVKqqNBsvCCoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:50:17AM +0000, Lorenzo Stoakes (Oracle) wrote:
> Since we've now renamed vma_flags_test() to vma_flags_test_any() to be very
> clear as to what we are in fact testing, we now have the opportunity to
> bring vma_flags_test() back, but for explicitly testing a single VMA flag.
> 
> This is useful, as often flag tests are against a single flag, and
> vma_flags_test_any(flags, VMA_READ_BIT) reads oddly and potentially causes
> confusion.
> 
> We use sparse to enforce that users won't accidentally pass vm_flags_t to
> this function without it being flagged so this should make it harder to get
> this wrong.
> 
> Of course, passing vma_flags_t to the function is impossible, as it is a
> struct.
> 
> Also update the VMA tests to reflect this change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

This is a lot nicer, though I am wondering if there is any difference in
codegen as well...

-- 
Pedro

