Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04C2606A894
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rSVlAVBA;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=K/0F5ksR;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eCAG9TQz;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+Ip1OpXF
Received: by kanga.kvack.org (Postfix)
	id AE9196B05B0; Thu, 12 Nov 2026 08:13:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99886B05B3; Thu, 12 Nov 2026 08:13:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960CE6B05B7; Thu, 12 Nov 2026 08:13:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5C56B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:13:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F0AA61A0310
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:13:00 +0000 (UTC)
X-FDA: 85426507320.08.2878FF5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0890F180007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:12:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rSVlAVBA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="K/0F5ksR";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eCAG9TQz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+Ip1OpXF;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794489179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHN1jM98e/rDidDGGpuhhKAQmbd/D3xE71tgIR8sZI0=;
	b=Xp3cTwQEcKzzRI66iRfRR5/4bdeaJ4BYHNraKKdBoxyyuTfYFV4VvWFaa1VPui7dB8D867
	FLqhTwgGTTKJG/683ZZy/iYdiEKap9o4j2xZkmKMmmRNavo6i65UMeqq3fUJpljAfPxE0+
	te3QtkiZBhgdxsmvoF2KeiUPLw100ts=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rSVlAVBA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="K/0F5ksR";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eCAG9TQz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+Ip1OpXF;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794489179;
	b=faBrsXKbZfLnCCqviQ+6w9K0rMFkaXfl2NK1QwkdrkRCsN9g7OET28jOfQfKLva51F5Me3
	EYZOfq7BGv6HJ4wXZbH/UG8XOSIHpT9K6v+mL1k5+7sI3lvmJ1s9JrjFdYHZmF2wgReYIa
	L6U5iUrpVCJrh/US/8+hH9JDYb4ekXk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E1EF31F444;
	Thu, 12 Nov 2026 13:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794489178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OHN1jM98e/rDidDGGpuhhKAQmbd/D3xE71tgIR8sZI0=;
	b=rSVlAVBAuFTbEKmNvga87CMsJiAzR6P2jK3iBgYEhwBBW7M/FRgIUozQfpxdflyln1UAQp
	nh/gLnT58Yone9jFxprqcuST6euBhfXwojj4XxZKxY2ib/aoz/ZcNwGsAiJl0dYmgVkpuJ
	gBoMyEljV8teWIdoq//KYCj7hBdu09E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794489178;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OHN1jM98e/rDidDGGpuhhKAQmbd/D3xE71tgIR8sZI0=;
	b=K/0F5ksRV1fcZHji05HSZ765KfchtCSSErL2Vc/yTWA97NFYFFH1L56VKvf8XZ8/7prJlo
	l2ViLDN25EO0J/Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794489177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OHN1jM98e/rDidDGGpuhhKAQmbd/D3xE71tgIR8sZI0=;
	b=eCAG9TQzbbdiUHGqQ1rrVJEmK+TN0G3+jagjuKjYTTIdr/zfnlkgnGKDrHhDB+qsmiM45I
	Qmg5DK+Lv5CsnkHrL42cmj3p+tWJHH5eQhYAjpj+mzYDP0xxT18QNS23th4uQzxyrgBu+3
	iwu/iIfrKhdftLrAvrnzr7MufKezlbs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794489177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OHN1jM98e/rDidDGGpuhhKAQmbd/D3xE71tgIR8sZI0=;
	b=+Ip1OpXFy6x05CiEfWql/dw5z+HEyAEHtC4MFasKsOyOvnZvX7onaetbPN6Pdx2GKW08xv
	vkL63C9JoRlmD7Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4EF8A134A0;
	Thu, 12 Nov 2026 13:12:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3PJECFa79WqQcgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 13:12:54 +0000
Date: Thu, 12 Nov 2026 13:12:52 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Steve Sistare <steven.sistare@oracle.com>, 
	John Hubbard <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 5/9] mm/gup: limit pagecache folio refcount when
 grabbing references
Message-ID: <avW7MFzYJJZ0B85d@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-5-318625d63a98@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-refcount_overflow_stable-v3-5-318625d63a98@kernel.org>
X-Spam-Score: -11.80
X-Spam-Level: 
X-Stat-Signature: f9g536k4158r8bpmih4xrxidic115z4k
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0890F180007
X-HE-Tag: 1794489178-451601
X-HE-Meta: U2FsdGVkX192sRxu6i4MV0vHLvbzITS+ZQNYb32nyO+T3xPitC6juLEf7xI9Eb0BCCS501jampFuwsKb76Z7Zjxxt+o+bGgy33E6LvPF7Q44qqyeYjwyzvjCCKA7ShBXMSd+lSBTpDJgEW039yfY1SJbzm84b/iyL0QG0QV59W65FcknTWdeXt4HL8dKX0aYHtb4lSD6vTJno8yhHm+6HNsc5XowIbugI8pAr6ZX04LWLN55e68tf48x1ijYv5QaBvIqhXtex8RZCvaDfJLg+8ZS/Dw7FR3eF/oaIiQigsJB1ZHn5PJaptbEqsF2Ge9XvW160nw6o9aybAJ7Lbuq6SieCXxGrgZ1JZJT2Fr6lK37J5Eh1YAyYwtkM9TBCznwFMxFzRRNuzXhZwDOxBbCg3ZrcsKIZkZLFn9g4AbCRaYkCgCxIrMCWOjI1hQVLbsovtJKs+fNpOK0RTDtZt/rsQwHCWpRcjrigIEEJhHart4iM8ep6zS5QdwszOAK0vke0NVMM+ewOrGbRqnanMG7Whfkvd3pvbeLJgX3VWXsvTg7BNvNefF2lQqti+B5UKQs5njosYh5uB2WP3UCZlpSCM6oIf09gkZl+dA6ps7Vj63w8wwuAEiXsxLT7U6vIE0KHxjsoU+M9xSjDPMJzjQxsp8iKvF/0Ju+63MyrAVLRpivZx4Ll+H7sNU79PZt+WcC+yMzG/XdDn2tvVT9IiX5FVeDjNu3Iru5v+1yW45MJrPltqTM4r8r5panYS2DN8jaavNXibLf1FcnELlA/HLMJxehnBiTYb6LugfD3ozZIl10Z/Ycujm6qv4+BQ8pTO7doycERg/fYCzvamKtFcbQ3KqK4Vihtr3l94cscICKSaPhFLYaSDCkWgKn04t2rMjZpQoA+oVWu5hM9komk3wI6bOxCLM7Wpvl1pe2X7KmUSXnu6q3NHinU90LTj6eCLofdo2X87MxgeJ7DW6ip7I
 Y7DOIg3L
 Jbv0qe1OLmDaYMPCU+lYDUjisY5SGSFxXOT3tSY6lW54f9K8YXmmwPzr9Rp5zedFkWiiEhA3ZlgojkCR6IKpaDsN2cUZYvTo14c1gWyfM5ycfiY/AV9rgH2/zJ38YuP9EF/VE9XIIe3p5Xrz4peX8kQpW0QtHLKNaY3wYEzaRFA0XzxlUROKOawFcnw4lmrQBKgqgl59fwTFQ+DEJUoCJ34ZY1dKnM/QrbaNpQ2F+PNzTXN5QubkW4VOxLRfYl938qiwOMrqzC/JueoCgUR9PD82Js/YyJCHJcOBbqR4eGP11uy9kTo0RiFycn2GqErdNiYrg1h/d+Jk3N58GItHkur0R6RjymS2Aw4iHp+6Sf7CnALpi6dEJ7cUyXgFrRiyqu3OP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 09:35:45PM +0100, David Hildenbrand (Arm) wrote:
> Let's add a folio_ref_count_over_limit() check in fast and slow GUP
> before acquiring additional references or pins.
> 
> Keep it simple and use the check for all folio types.
> 
> Also propagate try_grab_folio() errors when grabbing additional
> references in __get_user_pages() and in memfd_pin_folios(), so hitting
> the limit returns -ENOMEM instead of -EFAULT and -EINVAL, respectively.
> 
> Keep the existing invalid-refcount warnings.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Same points about funny weird inefficiency applies, in any case:

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

