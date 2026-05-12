Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE95FCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201D06B0088; Tue, 12 May 2026 04:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA0D6B008C; Tue, 12 May 2026 04:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF7A6B0092; Tue, 12 May 2026 04:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F30BA6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:29:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9212F1C02F1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:29:01 +0000 (UTC)
X-FDA: 84758092482.14.540F57C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2A0BD18000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:28:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0cb/jXDm";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WrQ6pNAl;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0cb/jXDm";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WrQ6pNAl;
	spf=pass (imf06.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778574539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IC6xPzST+TZhZT7b1WIo6RFfE0Aey6ccxBiATRxTi4A=;
	b=7xPOnr5wfev67wFdwwGOpZ6WkLfvTB5/eRiSlnwKFSyuMFkrK0yQRAFHq/3myMVDM+FfoX
	woi1tEx6+9g7MipvBB4RGE4zHmgqz4Vhvw6tRhmRAznMXQvjtMKGNn1MNwIhBd2bNCVCmW
	DhSHVRkLZ1jP1ymSDEHN5s7iggFGdbA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0cb/jXDm";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WrQ6pNAl;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0cb/jXDm";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WrQ6pNAl;
	spf=pass (imf06.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778574539; a=rsa-sha256;
	cv=none;
	b=o2dQl6qLiA6iHyCFHkYQJyP+H5sXEoNfHGk+2UeR5QvcJz1fyPOiM8TUb3tEoEngRIUA/b
	GC0s0z/fb5DPIq8u8gzbkvhtqIxS85B825dHM/aYv3HkRl6B+8cn8eELhWiBbdkh9S+S2b
	coFIzdlIEoMEQICpfz4/tkZuasngG2s=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9DC9375945;
	Tue, 12 May 2026 08:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778574537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IC6xPzST+TZhZT7b1WIo6RFfE0Aey6ccxBiATRxTi4A=;
	b=0cb/jXDmbTUTOFNVqvSALI0F/JLIGlZa+ISDVhETi7RIgHnQAFCL2FUIVLOPyI2BcE4DPH
	D3zKfFHuY4IbaF43v/qG0Pwf+Y9ggOovwObNOOityEAK9xFZZ10RYgzz0YQKwiTn1NGkL4
	Z/H6E8qJqYBu2oY65BbElKFojkZxHG4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778574537;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IC6xPzST+TZhZT7b1WIo6RFfE0Aey6ccxBiATRxTi4A=;
	b=WrQ6pNAlxMrbbhvFBJ1inQltEsG5LvqeRs8lVC7DSvf/p5PZbOtGB7cGqYIDMHYw2o+KFv
	4XitzC/nndVhJEAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778574537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IC6xPzST+TZhZT7b1WIo6RFfE0Aey6ccxBiATRxTi4A=;
	b=0cb/jXDmbTUTOFNVqvSALI0F/JLIGlZa+ISDVhETi7RIgHnQAFCL2FUIVLOPyI2BcE4DPH
	D3zKfFHuY4IbaF43v/qG0Pwf+Y9ggOovwObNOOityEAK9xFZZ10RYgzz0YQKwiTn1NGkL4
	Z/H6E8qJqYBu2oY65BbElKFojkZxHG4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778574537;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IC6xPzST+TZhZT7b1WIo6RFfE0Aey6ccxBiATRxTi4A=;
	b=WrQ6pNAlxMrbbhvFBJ1inQltEsG5LvqeRs8lVC7DSvf/p5PZbOtGB7cGqYIDMHYw2o+KFv
	4XitzC/nndVhJEAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6AB7A593A9;
	Tue, 12 May 2026 08:28:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n1NXF8jkAmpyewAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 08:28:56 +0000
Date: Tue, 12 May 2026 10:28:54 +0200
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/8] mm/bootmem_info: drop initialization of page->lru
Message-ID: <agLkxhtQLnupEPbT@localhost.localdomain>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-2-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-2-3fb0be6fc688@kernel.org>
X-Stat-Signature: hjesyxodn18n6msup3hea6md5yite7jb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A0BD18000B
X-Rspam-User: 
X-HE-Tag: 1778574538-392059
X-HE-Meta: U2FsdGVkX19WEJiJQnyijl+Yl6w5T9GVUBWyQ42odMbSMxbutTNBQ1C/zZ72WnvIdkcILB4Ks2yfeKoidWddHf9wn2i6Une6bzR5K2j4+/g8ukbxlxdu6poRH5v3/Rgj1mPB5Is/sWdP5fOUrlgAeG04fDHyNnY/1B+H25DiotOU8jfohoaP8wYcJuuWz/VFImJsMtbRgnvduYijsLsM3Dv4T1lwjzX9uc0rQohhxAgTXnzfXoSRv2MuCpDPA8E+mt386qU85Da+B89iZema2YetCvJRO4MqKwqfi1odzy/2XZCzDG0c0KF83KaWWRsVb8SU3fihKw3znURy2LoOVX6yR3CJXKe42am/S0hCK2PBR3xTjZs0jeAwubTauNGMUDS0IMmBZ6bQp3VI9gKKt4sD8Dt4KTYE+foeccarNzmIes/q+k2QkFbzgzGFxRfg+EYDLCPD0MEHFbrmvsN/PTeeYlbLntpgWpuACzRmarNHR35rQ8D5VsCgrdCZoNf/FrAPge8E1tzeBjfp2fKzY06txuc4rMSfiFP4OTovvzdn/xQPzM2L1IZvkww0UQBZtt0f4Kmc5C5xaox08bz416bdSOiq0Jz1chl1uksYheKAK145m82+IqHJJVETHtfspwLE3JycYhDfCOfq1JJfp8PNyLZv3DeR110Ux3Flnj/PaeWAeXhPJv+Mus5+5lENLVLeDS/Qzl2IRKqd4gJL32zn2JyJ7bgD83fN7pFA6qClNhGg0vt6shOahHPKIjwIlKvwqh3XyAzCYYndfL/fMDU108+vclmCwIhRuCXWyY0b5DWKswRuJHU6cGKBm0eUy9msLtFh8kXpSY53xAMaSPi0xtFnu1FXkLeIyoUwTaBwuW77JpcJDPqGLZaUEzt0CG9QEwKrOUtzTixRzOl8hVZg3bP8iq/yb8ksXcbG+Lg5Q8rfpyHc9ZHijdkaK2uuV0H9s+HTThh8RdFY3NC
 QQUvFdHj
 Za/vcv2dn6ApOIlf5TXrPUICpXt+pj5QV1O4KEh4qbbCPmNkUKZP1Gg2sog0U8trWvukENa04t5uuSVs0SZzc4ZWhF3gTO40TOC2tq+gKW2Jb6swJKnkDuJxHG/KFWvtUJY1pKDXtv4DOepjRBPnW2nVkVDYx9KDHLqrUOzIZ/omIDMLoJaKW4rvmQTaAecP+phdOiL6pnVIW5zmyKTzkUQ4Gl82l4zIezDaItM5O3Rd4qvy5oCGJE1I+aQp5pH/sZqZU4Oi3o6aS7LwpCD5k6B7ZFOSECKwenIphPyAUDj6p+eCc+LTzwCY08SdzwHxYqcrHX2LGzdTbh0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:30PM +0200, David Hildenbrand (Arm) wrote:
> In the past, we used to store the type in page->lru.next, introduced by
> commit 5f24ce5fd34c ("thp: remove PG_buddy"). The location changed over
> the years; ever since commit 0386aaa6e9c8 ("bootmem: stop using
> page->index"), we store it alongside the info in page->private.
> 
> Consequently, there is no need to reset page->lru anymore.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

