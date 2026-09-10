Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08D59C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CBF6B008C; Thu, 10 Sep 2026 12:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDED6B0092; Thu, 10 Sep 2026 12:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F3F6B0093; Thu, 10 Sep 2026 12:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89AF96B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:15:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12587140569
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:15:17 +0000 (UTC)
X-FDA: 85198352274.10.4FD9795
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id B93BF40011
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:15:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KwaVR830;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Y2KOBCiA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SSkNdt0y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=f8NVEtsk;
	spf=pass (imf17.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tiwai@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789056915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BRmfG56H5zmUlLl5HniRsrUYDdv+UxK+dNlQeMPFvk=;
	b=Yspr2Rox+NeiLrEfmnWZtKNANEmPwTN5kWmNISQ2reKLj1D1+weJSch6Y1X8gIpRDLxisX
	PsNsGDGSBLDolZYngecru05kgHjQZ9O75CooEZp6VqA1fzmncGO3jgkT+iUaHpbgqkqlrL
	hOptS5R/LI2aGpqNBzgVnIm8+lHSEG8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KwaVR830;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Y2KOBCiA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SSkNdt0y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=f8NVEtsk;
	spf=pass (imf17.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tiwai@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789056915;
	b=DXkD9VjDSk3awCthmm4fsDCGixoYRvSEPh254ogh0+wss/rrL+tF0o1S3k34bglJVNX6jn
	wnBOwZCw06Vl6pbtBhnVMtz1qELto6eP/JvRvr0bIz4x6e6MJnUGza7B7Ej3uoMRiP5DY/
	lE1vbLp//Nhwr3UBkP7JA6ude+tEec8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE64E2198D;
	Thu, 10 Sep 2026 16:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789056909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BRmfG56H5zmUlLl5HniRsrUYDdv+UxK+dNlQeMPFvk=;
	b=KwaVR83038tEY0UY9Duk1VEc71qo6WCRjE1S3O0gvKvuRCHG42+lMQg4Pv852Z53umQGu9
	VjGqLOb8QDmQNHY+2pNnRCnchni2H/fLzJXN2LYO/8zb7Dml+uH7yZSNc2VlGsdDCBFr9Y
	l0PoG4YOAdgBCejTL9J/aXLrVyXMWP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789056909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BRmfG56H5zmUlLl5HniRsrUYDdv+UxK+dNlQeMPFvk=;
	b=Y2KOBCiAAtdbnR/fQhgCwIyKQWjWRx5/MHZPkKS6JrT5lfmwIstj6yrNTcNtSkn1IjAs+v
	GHOsOOnR5zkk3ABw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789056904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BRmfG56H5zmUlLl5HniRsrUYDdv+UxK+dNlQeMPFvk=;
	b=SSkNdt0yW3GN3tzraY4wrF2jv2x3+drRXWKiGRungajUk2k0YXNbLn5Jv1YL59Qvvucb2O
	83+J8HAnRYoAZaOT6ItAtFTSuMTjA4HRl87EyCKKX4D/avW5hOH5AItmaXn8F2wEhWT2/G
	QirfirGABUJoW7pZPiRpw9/G8O5kGxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789056904;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BRmfG56H5zmUlLl5HniRsrUYDdv+UxK+dNlQeMPFvk=;
	b=f8NVEtskkiiUWUL6F4auh9OnOU8pXQdeF2/pdQRRP5fwIvlOb4C4AeuTUScKje5DYuJ3Be
	SlZ8aiM57gvPBsDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 917381326D;
	Thu, 10 Sep 2026 16:15:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oqY5IoXXompKQQAAD6G6ig
	(envelope-from <tiwai@suse.de>); Thu, 10 Sep 2026 16:15:01 +0000
Date: Thu, 10 Sep 2026 18:15:01 +0200
Message-ID: <87qzj1jd6i.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Jaya Kumar <jayalk@intworks.biz>,
	Simona Vetter <simona@ffwll.ch>,
	Helge Deller <deller@gmx.de>,
	Sebastian Reichel <sre@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-sound@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	fuse-devel@lists.linux.dev
Subject: Re: [PATCH 12/39] ALSA: pcm: use vm_insert_page() to map PCM status page
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-12-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
	<20260908-b4-mmap-prepare-vma-flag-sanify-v1-12-dacf19cce22b@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Action: no action
X-Spamd-Bar: /
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B93BF40011
X-Stat-Signature: i1st1pnzxczhrfrkrb15bz3y4n1zz94g
X-Rspam-User: 
X-HE-Tag: 1789056914-516384
X-HE-Meta: U2FsdGVkX18UdhGwpttXYKGmTw9rFryM9px+S08aSNm1UgRfWU/W37+uzGe+8/JpEiask4Za4lCqoxjhPiikuxD0iGv6/Dk1hXsV5bKFOOtk0OTq2OMIhwmkkQRBnszqarum/7X08+sIDzvLWfVlgJ4J3GKEs+cJlsHwnPGPBcsVt5hgE0CPbr5Xb8OXLM9yGXNj85kF0ynLQJzVTgtr/wPv5WjsDGErgICWYNuzKCV4mNZOnE0Meg9i6WLHeWP5wM48LedsNZGOMCFIsxAZ8hwswn2w5e73oc0i+XF3Tm+/2SKH9Hk07PTNnKq5ZHylUrdmu8pqfhLqfrbl60SVtctXLqKlNFZjqMIX4VW3fonADeMDbyxkkg3Q/fOHjIBzeZ1DY1/Ti3RhkoWL0LkWyD+CxH5gR4SFZP/QRvIvwOPrA2PCsH1Wz6O51ARx3JIk1Igz5GIuoMfpRn7BVRsI7hTRPlu6xnqyOeWyfBQW1q8q41tCxSmrAVmvwSvjsewJt6GZYfnCCsTC4+yg0Zd6NWc9LidFuD4jxwmnUsmij4GIaTLr0hBI78LKnrbY67wS0HE9d3++zw2HPEHJGLt0gp3idxacQVtEKDCQcXWzuUM71CIN01Dodpfa+fXZjFzKCGjbVh8zubotcH4ljGeMWLaNc5Nwfr5tm5kD4oMMmYgUHYrmZaxUjL3BuXeG6Rs6Y4AA6bQ3fu/0qYycQ8Gir61NRHtx14ztEl77YW8J/Re8AVKhHOO6QY1+OjrfwbivtxmL2AdqOUFWp+LT7AHtjkdvNMin+c1qoIGymXqeNHI9Xhs9ElMmNCprKywg1cmrzYpYfmfFXbv5ZTe5LlPP7XlkRBTCghLFeoF6I+FgSskJPuN1yzlEXR87CE8KsgRZ1tXVi+B26L9EFOZT5CCGcNp13WfiU1+Jn+FjxafPuCmvhQL0qi2R/x77DuxqSpCLCNXt1qTo7MkcgFm0lhW
 TGuklnwe
 ubAkHeinO7qqyNAsUwRIKTVH9N5xQ+h+apZa2kYWNIV7WMnyNRFDpdNQtrL2RXmzYcujBjuFPopduTlbvJVttdp5TVdQ2w03N/lDbb9SCpGH4nka3qJbWVBd5WCN1djShg95JHGopbjFqW///wqEQH9+G4tdmhmxgLk72uLuwF/8/0+GjU26LBX4CiNCHUN3s4gtwpStIoEMxHUDkraq8Hf+HiXnOHvsAUMeJphhIxCOtqoDs3VMfvcd+/NEVnGlageyXTBtzhXrQPjMAN8YbhkEpVfGmdBRFWLycGucm/RcrTJXiHe236FD2Q/M23YtJZPXDspDhD6qLOA8iRM+oF8+HOlG5mTfF6vuH6m7neesuQPzRYZxGbNyotHhYVxUkuLSWNZJUZzWcSPcy6AZDyJBemzR9gNSCiGqd8a0YEXQAlFmvgjrVnmXIcs5VhQp76JSPml5T5/WAxFPau2Y4pG63hF+Z32OABxtl5Vog/Orf/rVLFeTUdVoDC/QO0MsieDllGJlHBNflN8KL4juMYFRTiup0DbVVzkt7PGjvXV4ty0BHFxvw8xxAA7qEpL7qrk3/vnuKjWUdtJcSalWtj/NS4GooRW11cbxJOpxaksxLyMn2zZvoPQqalVqopwSkkYotAgX4sDaCtANOwwGOtG69tVHfKBbH2+yHmZHQWY2Fd0NYzmKfulSnSwzgP38HX/Ppao+9po9FuVy23+eY3Y8oEKvFdTDojA86o38KrBNiBNqIXyl+ASFJSqDYMNcYN+tfsKmiQPm70QygLhw6diMH5IyK3raQfE3qUtexzMT00cZU8eK2fc+XkJ0ntFiNrEWFALg5Bmj75M4d7TgQGbMTANv8p9eP+IOAWpTn+mjWETlx+xphkldO6zfpqG91MwizVhnQUjpW2pmdN3tS+sTG0CG7+7R4SRHMzStnIP85TcU1GLEgEP1MW7hyGKpGYXY1tNFfU/6VUGNMl43zW7CcJk7P
 c72J/Q1M
 1QdX1WrNKGvLspswkzYGdrSyPKyfHk0M4XFzzB0e+5a1VSe0EhXs+2fJQIytvvy6+UJR/X4/wDZdd/5fxO2ADvprvgfZbtKqt3vB/KPNDpkkpEg4wxcKg7mC1Q2N9BBVAQ+NlC0zTw8GhMBj8JMxd5uDlb4s+x1RcAB8fznkNvJ5kRsmV8TR4ZlowwylhjpvsuLB9eQYCoVHYzNi0NtGcEAK0+cwbWDXyRQdw8CjUa/XTTwropueIxpA14LEBb8iSYzN79LovatCafv17kdQ0o9ZJoSuujkqeRVYrYodYBPL7Gsj7dGm8mNQ9SveVokBXPn3+G9XTpmXWG7dWmZ74SP8MYLEyGkXHu7ov8oE8LrTT97wADwBChy6Iz1g3MBLPfQbVORP7Cm07c8/nyQj0CiBvRFoX21MoxEdjqLCp1WDc3jvD+M5gGjCsQxTq7QR5NuNzuZWhYAGbku+GnMf04MMqf76yiR5YXkxG7KUwZYDv7u79WMYJ7pce1+zMaz2P3jLTBY01n+ewjwDzvU/cHbcsGdg7PB1/DxDGK0xhGNeCdIxKfisuIV3FDio/rb/9WNt1NyIhAzYCyTVeUdhGZgsnGahU4J9TOk4l+Scz098LW+Txkhtcau5AYEjlbpvwWBdb1VJwisp8GFPMSnFBgCeUD9vvGfOn+cEoZs9VwmSKqad92gwdPMVaNgmJBouDeQa5/ud7pxAq1vxeyy1KTvSzrS45924vqfIbHGBd0LvRC0OG3uw3CjdNEmidNDPLtqR0w34tnyXu7+hgjlYX0OKOe4daSbXXqGVSkCwq1gs5mJNelQ55G9bti//brFKMC4HZhz39dbJ7SvFFrmpjGVPaih8HUCmBQWFpfCv/jRSKNydCnRatS+H981ziYbTEDPsj6gQ5VnBJvtQckJojJQuSwwfywkxDzftIynHv7n2QDUl6Io9NpOrQc8o8HRWe11DCX7yUjiIvj8xb2uNCy20Hdwci
 enZ9nBPT
 3kvSaumKewQd5bjwm7MYu/BzrooEMed0pX/uYHbBWaufOz/jQnRatekDMzlaSW5TfQcjCvQNVgGvl3lQldtCg8b5R0sY3xVyxBNMn4G6Wvw6zIBj+Vw8rER9urjM21r+igv6H6WQfCrfwOkFy54NFMRab3qYorbjrufPCkw4SzezMRAyhsT/DN5Vi3a2jcltKlPLrZC6dJzsRUBY0UM46k+PCJ63ASd9JAOXbUnVPFfQTI0NCmynesWt9p28ZpC8FnD9K7mGv7Uh0J07sVntHXaq4RQWQQoNpIEKiBuF0/CzlNbvV1YjCfVNy+v0ky7jBYlq5ao0qRdQot9b7Zaho9iPJ2oBq4t4XEU0XhKyxt2Nl/bj6tx4/BSZfSHgqZzvi/u0OlmIT0/kPCXRMSR41DwTJ/JfPN7jzp36RgvKrd26QxegDzEWcPekN74C1/Bo4IN1KQhwehcdwTgjxXRMpZAx0OzHxo8fWYz88aUOYCL5zC3goeuXYGNFIbFihc5Jliq7CCmsi+UTS0NyGwOIBARX0GeozmQZgZSeW2iYvy4p7HwT2/JcXn4A9D3cq4NO0gypQIAEU0B/DWD2+PwQzFwWCBAAmd0wEFpebURuyh0VOACR8D82dw0CDAalGVKTAuDgPcFuuNh2WgGo3HEf5O85rrKZkPXkJbOd7MxBfGcSQfk2LvB5CeGWEH4q8KlgoJXd4tbBLmtZAstLhf4308i7rkqmMKs+olMA3EZ6smoSoRsS/L9Isl9qOGej4i8XNfvCJKpu/Z0MhBADgr4UWnb8mv1+ZFDECUy9daIqbIiVIBVB02zbRs6HrT1/XTkzrHCDxE4ydVUpk+Fjv42U2ZypqMI7T4BYF+Jp0j0AJr5S3mz8yWUAcxhIDr9Rurq0XnTYldByjWQJOw3VVmq/yvdSsCjSYGZOOzw8wwQ3jaOD7bmTMx8/iJe+KoOLcQB/QUFMmuUjc5+snqjIcM+/uXvmKJBGV
 Q1BZDNnt
 0D+O2dfSY2AkfdYWpaGr13nvjD3XLyRYXWmq2smx2JZTAYrx6Bt6zgCFMWmrzFZogEofBmIzjUYRS3GpcJGcJwiaYElch0J1QEtWjJMtFunbfFs+lof/DspxLJs0L4xkkR5sI+oNx/rOrFnYTMrJNbCGZ7SsJIXgM47EFdQ0+KazUzlVaoqK/ImcN6fKn8vrs/TvYYum+Ck15S4OmqLdj7jdQny0eJCs7PtrirgPO7wGulkSEnaFLzZTqpCuFdbivBMpI0NOOMwNuX26wP0NQHXJq0SrGxR6PUrkKmxaSOqRwrPc/pvXhdhdPuNsOqxv1mvzlPDsFs2e4qj0L2bR+7DsRcgUHz778sR1+8JqEZSFAgweyCB0cIRspS4Gzmtrr9yP+NlYGsHvZXhAKKIaeu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 08 Sep 2026 22:01:16 +0200,
Lorenzo Stoakes (ARM) wrote:
> 
> There's no need to keep a fault handler around for this, instead map on
> mmap.
> 
> While we're here, rename area to vma to be consistent.
> 
> This correctly makes the mapping a mixed map mapping.
> 
> This works towards establishing the invariant that only PFN mapped or mixed
> map mappings may clear the VM_MAYWRITE flag. The status page mapping clears
> VM_MAYWRITE, so it must be kernel-owned; the control page mapping remains
> writable and is left fault-based.
> 
> The assumption is made that the struct pcm_mmap_status structure is at most
> a page in size, which is asserted as a build bug.
> 
> This is safe to assume, as the size of the structure is 56 bytes at most.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi

