Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F11606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DVvoiYFN;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FAqoZbGv;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Cf2Osd4z;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=p9+PcCPJ
Received: by kanga.kvack.org (Postfix)
	id 0FD4A6B05B0; Wed, 28 Oct 2026 08:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0879A6B05B1; Wed, 28 Oct 2026 08:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9A46B05B2; Wed, 28 Oct 2026 08:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C333F6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:43:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5A4FA0CC0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:43:36 +0000 (UTC)
X-FDA: 85372001232.26.D1B8E67
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 939BF80005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:43:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DVvoiYFN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FAqoZbGv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Cf2Osd4z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=p9+PcCPJ;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793191414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIZVjq4hJ3t1VQV9XqvU6Y6r776YU0NJyxVEAhuGGa8=;
	b=0KZCb2zGCzzBSh0295HuQqkYnN7P49j5Cn+53BfOIE8dsYEIHaWBBQLh2KwI2cVfB45cOq
	6fGvJ4nmMRPeDfjqtqdJ+QZjj4RUy3eIpwE8Uge/FdTukyC69vwB8dGDjI8Ox0yMjGmU/I
	sU3+P9WefHlIikrRXkiW13hGSJGms5Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DVvoiYFN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FAqoZbGv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Cf2Osd4z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=p9+PcCPJ;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793191414;
	b=1zV87Zk6GDJnMH1s4o3LCybesJu0pqIlik1JgS3HJSdvF2JuswKjjINaeqFhAOFReKjgsT
	GYtLzRcpl4/Jt7edHJS6cSqyR+mNl9vX8FERcuv2QlgWrxxu0sKnOaFVIu/wfIfJlRMNko
	kd64bHn+qy3WDUQ3dPEs+9kGgdrGfsU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C2D991F45A;
	Wed, 28 Oct 2026 12:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793191413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SIZVjq4hJ3t1VQV9XqvU6Y6r776YU0NJyxVEAhuGGa8=;
	b=DVvoiYFNHh5XTFT1JwNGFQl49KVYetJWc7meB1CHoaHnT+LPC0mbUoAnDEIpZEQrbSEHsS
	FvEntye5b12nndi70rfOOOBbV1Stui2APdvxUAAj95hL5JxdUyEmRiPV3GSo9X3Ltts95x
	qV2N1A+6Fzw56utZ223yUEqcsWGEiTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793191413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SIZVjq4hJ3t1VQV9XqvU6Y6r776YU0NJyxVEAhuGGa8=;
	b=FAqoZbGvZaKzPhXAkP6jX5bf/4TMMTqW4k2zUaSfpzbzD8NQPyZoMFDswfnT9emRo+Aj5w
	KVUQCY8EAOL+bXAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793191412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SIZVjq4hJ3t1VQV9XqvU6Y6r776YU0NJyxVEAhuGGa8=;
	b=Cf2Osd4zyVG7l6XYjmWmttp3P+ahTrSv9HT3W3msjARcHfAmKuajToUZqb4RRCOKnW1Zik
	wPTT1/MnJ4/dVnkN89WxELP0Alff01WggTTtH25XTS66mkwjMqt+ru2y0sRG5FzCaoEbxc
	6w1ND0zMc4PEGkv/GX4wZgk6+iVZyRY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793191412;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SIZVjq4hJ3t1VQV9XqvU6Y6r776YU0NJyxVEAhuGGa8=;
	b=p9+PcCPJhGehydbjM2LDrQmjdW4NIlHsU4oPUukpcTl/iLExPoPe1fBvMQAUHM6ukWW7O2
	NL4NDdQbXtnY6kAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDC9F13419;
	Wed, 28 Oct 2026 12:43:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DdBgIPDt4WoWCgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 12:43:28 +0000
Date: Wed, 28 Oct 2026 12:43:27 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 13/46] mm/huge_memory: fix truncate racing with PMD
 zapping
Message-ID: <auHt3OOD7lFwVpCg@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-13-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-13-6f74bec9a5bb@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 939BF80005
X-Stat-Signature: 77s6karf46ihuohjirjw1sunit5kaqs1
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793191414-289460
X-HE-Meta: U2FsdGVkX1/iuXRjiw6/2/qu8hiMJ1xDzXckzTzv3aiBSpegwRtw1mS7xbS3AxZUjhgIJlDQosSUI7aJduGMsIA3F6FpvekUPoC072MNHfirQn2D8TwcjwFrkPm9B7OZcfTPWPFxcvOpLD7afqK30Dja6ffUOH5943/mxyy4k9snrtX3Tb7ZEODAjONPQLNuBVSRFmS8xbKKCXs6bXeFAJbUegg4RcCBkNXfnrjNzhuVrsnd9koJLfksEqyzecdh6MoonthvHJdJa+rDYhdOie3RghGqU72MCASehsv6eya5JOKL9fi639XYYbTNJaLZKOz3YFRNC9pZbzFVAAeZbpx5gEJZ96fctAypHbduI6ci85oEmNN5n261baNJ70cwx3gS9GSFM7QX+jVyojzRSiEpeR/EqWfQkls/rQGcmoxgCSWQCSkUFvLubuP+qGxJFMrOq2ywbEH/ZGAKbl+ty9RL6T3UoQ0T5C71mBXdDgSfcp5N2iGBbRPz2XI4xjsZPheC2WodpTHmOWl8AtaJij4HjYiea7ZdCpZBeH0y20fcU7hyhdYbraAf32tE+F8Uh1ft4iUt8a69i9dBa8VZIi1ogm25Imw/ZYHuaqVS0FY0Y9z5go8s2HI2QRp3AUshu/pIk4sjQ1gKbn0EDciHjqOFgHJW/uMQcpMWD+Mggo/OLEaCGdzmFghYLLeH624kyUQ8lZYGf3t0C3fG6YzVzUjMdxModbqXYkKPI+BEr8XKLPZkQagSJHkeEJqp7Mg4K/QW/VOl8y14RQVhduAYcOyz51Zcdt20vQy6i1pOoQS8MSSTN6vPnqhGg2+v6gixusR21THyyv9o0K1QBxxzDV5NpJSyYL2diRDF5lPOZU70g2hi0UCXX7j6RuTCe5almWiirFDr0+AcQAXhrEqwXZnL54TE8vYYwIH3iVQyZD6Q4J2JwHEzk5HtA0neppw3ARnNDiEQ5UjkILBMevl
 c6zeErrn
 NowRq8rHN/ZstR5MK3MN7h8+yQlkwuIob6dr+DNc3f3hcUldpFPNVQBYHuqftLi/L2djObiM9edJoVhyYktUCxYGlGzZ4dyEJ2v10H4NnemXrlxMI5+wAQvVGIB+J9tb+kmvqNJPYsCEfSG22zZtfw9IL5xT3LMwMhuWlZ5rjgfEf0SJ8aE7TKNxNWNPmNdzrwCfMbuChksvJtMLgV6yyRsFO6avuXduj3LV2JhnzKjCmT6iq8ud4KUe89AHSTPwHWRYLTA69+rD62pMK6H6tMNA03Q3DJWQJWElSLSwKZhtAY9PRvdZ4iV90A6eOkJeQRacxbcFV+B112ncdlYmr/LCCowncDVqH7vAjPfnCcRQc47HC01CZJv4BrZJYTNZ9C1h6+SI9HW71UfkvyKjbOa2k4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:33AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> zap_huge_pmd_folio() removes the rmap before calling folio_mark_dirty().
> If this was the last mapping, truncation can skip unmapping the folio
> and proceed without waiting for the PMD lock, racing with dirtying.
> 
> ifs_set_range_dirty() can oops if MADV_DONTNEED races with
> ftruncate() on XFS, when we get the folio set dirty after it was found
> to not be mapped anymore.
> 
> Move folio_mark_dirty() and folio_mark_accessed() before rmap removal,
> matching the PTE zap path. This keeps the folio mapped while updating
> its state, so truncation must wait for the page table lock.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: fe6cf984939d ("mm/huge_memory: transfer the pmd dirty bit to the folio on zap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify comment and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

