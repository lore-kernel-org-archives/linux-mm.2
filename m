Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA4D606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bDDhCwYq;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4i+RWwt2;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bDDhCwYq;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4i+RWwt2
Received: by kanga.kvack.org (Postfix)
	id 97B466B05B9; Mon, 26 Oct 2026 09:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953A36B05BB; Mon, 26 Oct 2026 09:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8692B6B05BD; Mon, 26 Oct 2026 09:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55AFA6B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:49:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBFE5A07D2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:49:53 +0000 (UTC)
X-FDA: 85364910666.15.074844E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id C14ED14000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:49:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bDDhCwYq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4i+RWwt2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bDDhCwYq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4i+RWwt2;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793022592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gw+DWrBcThdkD94LPR2Xt2VdzoiGn+S55/InX1ltsOA=;
	b=3fTByVlu8um6ZazsnwlX9GlsnQfmsl+xXLaTsBvulyZub+fHCHXYONZVPo8zH5Re20faw3
	m8+J0zL8AAs5sC7xD2x6H62j1TwjMoh/SnJYNfgFvhk1wnfnjwgfGbHmAEqqeyJKetDQtn
	r8C1SgB/v/0+BLYZQLoB16AsUg+9/vg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793022592;
	b=o6kYFLqd9YWmbztSAr/Yy7VNcjYg6GbAWh4N7FoWpWOQuAghfDOrVEf25XH5km5omLEjQF
	P6vQ1ReCm6XABQFJgzrYcNA2YWV7CvIP7EZHsLLK9c0m3/kXdqny9xLj/jYLYMeNbY7GDH
	/L77BgSgi+k9IMUmEggNNt60MoLaauE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bDDhCwYq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4i+RWwt2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bDDhCwYq;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4i+RWwt2;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 703A61F7F1;
	Mon, 26 Oct 2026 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793022590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gw+DWrBcThdkD94LPR2Xt2VdzoiGn+S55/InX1ltsOA=;
	b=bDDhCwYqko4Spqtn/GFssUjt3KhO6TLY0yoGN3uHLvrc10lcc/Rk3KBcvnyXc1lGnmF0zo
	zDg1TSaOVRSSbo5n9O79NLsNzqbOJzWwuQSDeBEEweJwcmQus0uBSq0Lto6pPrTUXqt16p
	3+UUpVcliemrFSyjci68XAtAkpCFH60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793022590;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gw+DWrBcThdkD94LPR2Xt2VdzoiGn+S55/InX1ltsOA=;
	b=4i+RWwt2clyt3QcGQr+qFHHmtwtaBmXorY1fQMFlNGoQLuHIJL/ippU5nn279+kzZHUy8H
	hDe06thWEnOBUrAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793022590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gw+DWrBcThdkD94LPR2Xt2VdzoiGn+S55/InX1ltsOA=;
	b=bDDhCwYqko4Spqtn/GFssUjt3KhO6TLY0yoGN3uHLvrc10lcc/Rk3KBcvnyXc1lGnmF0zo
	zDg1TSaOVRSSbo5n9O79NLsNzqbOJzWwuQSDeBEEweJwcmQus0uBSq0Lto6pPrTUXqt16p
	3+UUpVcliemrFSyjci68XAtAkpCFH60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793022590;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gw+DWrBcThdkD94LPR2Xt2VdzoiGn+S55/InX1ltsOA=;
	b=4i+RWwt2clyt3QcGQr+qFHHmtwtaBmXorY1fQMFlNGoQLuHIJL/ippU5nn279+kzZHUy8H
	hDe06thWEnOBUrAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5F7C13408;
	Mon, 26 Oct 2026 13:49:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vtLFI3ta32qIDgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 13:49:47 +0000
Date: Mon, 26 Oct 2026 13:49:46 +0000
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
	linux-kernel@vger.kernel.org, Eva Kurchatova <eva.kurchatova@virtuozzo.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 05/16] hugetlbfs: enforce F_SEAL_EXEC in setattr
Message-ID: <at9aZtyyhrilX9iL@pedro-suse.tail5790ac.ts.net>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.80
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C14ED14000D
X-Stat-Signature: ph4daizwj71ko79yrfm5gi6rkhh7xeap
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793022591-742814
X-HE-Meta: U2FsdGVkX1+/2n95Gd5CaQIk96riDpb9suVmdHOJpBOV5dsxFVlugGxkYClWAO1T3uGJZOrCQqfuizDVGb6Tk1Ptxf3q56KOLrVeO+ndwVUx0Bayruvn8XnqYvXn8xPRrO5cfpSfMo+0Rkq89g8tLx+zYThBz7LieqsnI1vQVu/4kVO1mUY0ZJpH9XK122Ixk3ZXOdBU1S9pB+XozK8JrnYb/+Tka7cDqSQX2i0Qc0l3UXh98FNaek3apEajrihXj7GzkhPy3hFMCdk5KiKgyDJ4h3HxZxFeVNFZNBivh+G5rWzLyAqORHAAGJe5ens5XQqmBg4Tv4qR1ytVdQM9NaaR+XxH7H+MCMTpfaX2LcC3AsTMzFOpASh5Wfa94jfUr4iwkT8EB76IUJOFktZYrKig5BZ8WEw//K+diEUF9XOLt6zbfQLqXhHsFco6gEp6BwCJl/Sz0B9k+drswjG51A7vYEg8vIH3oiarizRGRd+WBoswfemedmxPISHjbArfHQJbvjubPEZe/GOXI3ZsQz0QZM4IciPmcDrcV8feh0oHAgA+ZiHGht6a1+JNTK7cUYhn93wvC5zK3dZJy/g8cC8c++rm47Ca3EgT4XJzC9hbmwB+XzFI2Q4uNEw2WhwbQtFEXhDXLhZCj6EAvTTW5aEkDh5U+6MJ1v5cFs6MV81OEN7aaMKwmnaRC4dCF2Wjr5ozZ6F1XIAjdYlmK0846SzwQ9IFnmsfDiHneQpzJjaZhf7uD9udG4M9zDoo1QX7usnHUMRKkn8MhaBumpPvOUQZ8tRwbDvJUBsFSsOf/QrZiJTF3mMe6LPMQAv+Nd2gdffqhhrYTtPooMLRWD5S4Bv+uGNM4qBCIsXpa1D/ShXRu9xl8yqj9RFEkql9N7idG65LgN08R5oT+UdWrEoesp4wnNe6jSJ8umvVMNSn96nGG1N0TlN3Qbc1w+H5fqcDWCCNyiaQg2qZyRO/yS0
 fc7f83Ne
 0z+jqLAv6Gs9jvY/tofRfPl7jQNbOpeV8NdGTPs38RmXhqJumdc+ras6CZNzU/flNvQ7M+LhQXfgY2blz1+WbdqTUQ9SMZDixW5OR+7yamzPy0wy6vj3d5/Qkb6FuQOFUTBGwKfLQiM/DkiHs6Gg31sUoA7CEyJ8K3nAPHhntJB/L7HDdnCDFILL0fqdPkrfQjklB+cEMjuy5B53D5cU65bKhX2F3VHQOgwZYFWV0tol5xE9T5hy0NZaIFmA1GI5zXr2/7urA9E2LLkLvWaQHyDropFbD1zBNnrYQIYxWvjGZYxZZlMnQsARTanmazCXO5FlUEv1qhFDrFbnsJIxr4E3XTt6kFLFUeeG/6lFOnFb9ByUrWNqtcPse3sNkuL5V8Qhksq0krYH7nmNb5tUwYe3+biT6KXcHycPUs6ZYfkPyD8EBmCd+/J90F0KHrNMOad/5Ru6jipgAmk/i1qtB0bQj2z2hIbMXo5kU9U13K425YLahju4ocT3AEfPMXNlmj2gllQKPzg69QUGIAdfMm1ctLWRbZjw6NxTtzIyyClcwLRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:38AM +0100, David Hildenbrand (Arm) wrote:
> From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> 
> F_SEAL_EXEC is enforced by shmem_setattr(), but hugetlbfs_setattr() does
> not check it. As a result, fchmod() can change the execute bits of a
> sealed hugetlbfs memfd.
> 
> Use memfd_check_seals_mode() in hugetlbfs_setattr() to reject changes
> to execute bits when F_SEAL_EXEC is set.
> 
> This also fixes the memfd_test hugetlbfs SEAL-EXEC subtest, where
> fchmod() incorrectly succeeded after applying F_SEAL_EXEC.
> 
> LLM assistance was used to reuse the helper and revise the description.
> 
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo.com
> [ david: use common helper; fixup Fixes: ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Similarly:

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

