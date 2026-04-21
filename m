Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 699A2F5A8DF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 03:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A442E6B0088; Mon, 20 Apr 2026 23:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4D36B0089; Mon, 20 Apr 2026 23:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90AF36B008A; Mon, 20 Apr 2026 23:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5A56B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:55:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F51113C131
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:55:50 +0000 (UTC)
X-FDA: 84681199260.12.90F6E87
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id D60641C0002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:55:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z+aTATz0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bFbKc3gi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z+aTATz0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bFbKc3gi;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776743748; a=rsa-sha256;
	cv=none;
	b=r9doegDfnyISWfLkYYdEJ3DE0ZITXHqLqBKqPMTEhlhB1A/xU7XpwgJ+IRptQrpgo7d3iH
	qvYM8kEMl3Ezko4idNs4zob8EjI5uL1amEwhytDlVf4tvVcGbvUsWWleiSu9oVsAw8akzJ
	Ef5Jzi7/6PbCnW4ZgKgCSo27JRNgz1g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z+aTATz0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bFbKc3gi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z+aTATz0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bFbKc3gi;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776743748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDVUbgdLvJLIeQVXYQIqbs7pEdXqPLVFAHC8mrcXVSg=;
	b=JihmJ3WgmMa3b396euhd/l62vgwAX/YrDT3W+qvrdkOl5vV5PVplsCW6TcTsRBf/GmdrYh
	RTQuI5xyqIQf5l7Y7YQW3paTUv+2G3EYk7d/DCwleWQaVDnuAH3623lkiWcHZC7jZ12RIx
	ogDJOa+Ztscqo8VSRdaCHgrFvW12JEA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 301705BCDB;
	Tue, 21 Apr 2026 03:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776743746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDVUbgdLvJLIeQVXYQIqbs7pEdXqPLVFAHC8mrcXVSg=;
	b=z+aTATz0T6umjQ5O0z+TOGIn74fHWAefJyFfgsKaUncEB4dmC30Iq37o2gy1hsv8uUp89u
	oJmIEcBm9v4JB6hBc7kgD0Od9amhicQy9vYyZQj8ckQf+u6hBjG/3ICY+iOWCPHRP9UXQt
	LSPoJJ4TqwaF/FPM0wJm2OoxxHbZevA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776743746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDVUbgdLvJLIeQVXYQIqbs7pEdXqPLVFAHC8mrcXVSg=;
	b=bFbKc3gikECZQSviGQs0y1uKj+LVkV0Wg3WuYg04UDC7GzXWXzmKSt7B9Z/5pUiF5l8Lwe
	nuLmnak/+N32IPAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776743746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDVUbgdLvJLIeQVXYQIqbs7pEdXqPLVFAHC8mrcXVSg=;
	b=z+aTATz0T6umjQ5O0z+TOGIn74fHWAefJyFfgsKaUncEB4dmC30Iq37o2gy1hsv8uUp89u
	oJmIEcBm9v4JB6hBc7kgD0Od9amhicQy9vYyZQj8ckQf+u6hBjG/3ICY+iOWCPHRP9UXQt
	LSPoJJ4TqwaF/FPM0wJm2OoxxHbZevA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776743746;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IDVUbgdLvJLIeQVXYQIqbs7pEdXqPLVFAHC8mrcXVSg=;
	b=bFbKc3gikECZQSviGQs0y1uKj+LVkV0Wg3WuYg04UDC7GzXWXzmKSt7B9Z/5pUiF5l8Lwe
	nuLmnak/+N32IPAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C208593AF;
	Tue, 21 Apr 2026 03:55:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +2K0C0H15mk2YAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 21 Apr 2026 03:55:45 +0000
Date: Tue, 21 Apr 2026 05:55:35 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] mm/sparse-vmemmap: Pass @pgmap argument to memory
 deactivation paths
Message-ID: <aeb1N2T1rX6GHrXn@localhost.localdomain>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
 <20260421022044.1217503-3-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421022044.1217503-3-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: D60641C0002
X-Stat-Signature: owsjtj1p6gne1ijw33a8ozbzjzky4979
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776743747-964342
X-HE-Meta: U2FsdGVkX18XlgtU3AZxFqcVHEcFuFHp8/WqVXJpaJHX45s7Nq41wKPSom8BB31frxFUC/3bBRR/AmsfDJQCK8zb035kBsmIqAtBOjHxxIzsqm7a2gK7vMO0KVrXyFsR/3rSTOqfddjESDAnYjg7YBzeR3Dl9pytDPRmDQGm/wVzFRS3hCvu2JlIXOfq9/5bIS3QLFdFnyXuffgjMWhSwZWZZ55fafZL+w0p8y5W3lPCReJWWaPR7Lrg+mjmW+tlYpXsHEdzzHuDsKGUc1nUlYPyr0MAYv3av1kXFI4jNR2ZCts1DUXQfzAC8Mv4uSpccoVw67gjQDr3qizU5CMZ/HYjc6fPjGyPoU+dE2Qk6wuJTE5sEj22eGeWNkznW6yxr5TN0xn3+HcqSa4R8blgmVVAH0i2Rrc4wmE0rK3BGj6x4135YoyCBbuQcm9pxajrLndo5FqWeG2R1eJTQlRsMYdBopoFUJKkZ2CmHhalHHWxnlEe3v8t0VPntwk+W8Ei0cRQxYp1xX7Gnj/8gm9Ug+TJdXTkU4+tdR9cVywWZg7NaH78/d0GXsZC6/O/t9ER6qkOwvlWX8g8P9Zy3jxwWOpvvHWF7daVW9bSPBuZQeoUuxTW6iDFdOUKtHxMP+tQqjiv+IAwTniQZxzBiuQA1XXyvWl9TwtQw9kGzS5+BlGrbICx8fJcHojWIRpj9h2w8/yMzMnmHWEd0nikskVK4zsejx4ycrsP+QFrSSEeKO68YpmFw3OISFnSUXvZsYt5o0YvgFdcAe0enLnijb4Y3z7ckSTeE65EdaMrp/kWcbWj5ympU1GHTpnGSaLbTal/da2lH7fYo5eBB2xsMJhpUF7c9czhGNft+OFTp5Tdm0UrQieTDlXmzPO2jf5zg7PsZC/B3Nt/j/fwTLAD8xtL2Js6T2awgikYEqjb7+8jz8n0/Iv7ZuoJ+0Xhu+dmuKEADTID8dAmU3Dika/LRQW
 /osSlm2j
 ezdAV0yvrx4sytSFJ+7m15omdBXfF9sj9cFVY7KXyuTLz5AywtQL4ai2vEy6zZjtBGmKZ7Op+tJ9Wz94ewpNuIk0QoStFoSFRQAJe3MOnlyicrULn+/j1Q1lUSE2llUsANNHiKL9QzNtOODypf5tHeIN31+2wM2oMtVurO5wncuuh3kr7NXjtbw7HpVJuREQ4vVQh1HYn5Fg3XS7jPsQmHY5N46/caww/qp+ujOh1lpiy+dNoCw2EHx49oe2O2Jlk9NZ+xuQOezSFiPzx7UDf3MV1e/xQWvIJzcsXerspt2THRD86ZEe7ps0swA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 10:20:42AM +0800, Muchun Song wrote:
> Currently, the memory hot-remove call chain -- arch_remove_memory(),
> __remove_pages(), sparse_remove_section() and section_deactivate() --
> does not carry the struct dev_pagemap pointer. This prevents the lower
> levels from knowing whether the section was originally populated with
> vmemmap optimizations (e.g., DAX with vmemmap optimization enabled).
> 
> Without this information, we cannot call vmemmap_can_optimize() to
> determine if the vmemmap pages were optimized. As a result, the vmemmap
> page accounting during teardown will mistakenly assume a non-optimized
> allocation, leading to incorrect memmap statistics.
> 
> To lay the groundwork for fixing the vmemmap page accounting, we need
> to pass the @pgmap pointer down to the deactivation location. Plumb the
> @pgmap argument through the APIs of arch_remove_memory(), __remove_pages()
> and sparse_remove_section(), mirroring the corresponding *_activate()
> paths.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

The change looks good to me, but I was wondering whether we should pass a
mhp struct instead to low-level functions like arch_remove_memory and
__remove_pages and have __remove_pages then pass the right stuff down
the road.
That way it would mimic more what we do in hot-add path.


-- 
Oscar Salvador
SUSE Labs

