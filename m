Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 379D0C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7C86B008A; Fri, 11 Sep 2026 07:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252D36B008C; Fri, 11 Sep 2026 07:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CEC26B0092; Fri, 11 Sep 2026 07:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D67056B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:06:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28B0F1A01D7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:06:03 +0000 (UTC)
X-FDA: 85201201806.17.0A028D7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id BCE112000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:06:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mwIigjyH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b+7SUHz3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=M6mKBOHb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Bkf9+hFx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mwIigjyH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b+7SUHz3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=M6mKBOHb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Bkf9+hFx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=tzimmermann@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789124761;
	b=cj0jyO6RGz1Ug2rU8o3N1c8X5Q05JuFK1X7ctW1Z+s+6SKw1nInL5DCTY3Ky36uh3HbZOP
	u4Exl9BG/gCqEltptaBCBlGpRD9sICMDZQEoAk1Ho9OurAPLjkny4N4/mIkUAMYffQI/Jm
	g4pc5a2tNMVa6KWu78zKAd/alnOXuIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789124761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCvWKSyOXghSRjrUIO25WhTluktNhI1ZIzrUisSCzog=;
	b=7sc69cR2lyeqMv0FcOTqj6RoxiVHPkBT5FWxnfgXl2YBnvFuWXaQtFWH+FMKzEHGJ7xRNA
	lcS4OqWJ2FuOeJb7HSoOaf5zt+t7JpgU3RE7SGng3lU7nKXXeOOlNMQvMcOgsM7w+a3IL7
	H5MzFwexXIq2bfg8qX2pmgkV1VDppaI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E75961F8BB;
	Fri, 11 Sep 2026 11:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789124755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mCvWKSyOXghSRjrUIO25WhTluktNhI1ZIzrUisSCzog=;
	b=mwIigjyH85mOyKyDVXiVISSPm5WD3X0MP0365zfajWOkcWSuPmB2ARy/C5YHIzZl3SzDbc
	mexaobbpaHz9iWGcTvThfd3zMOtaWRmJiSjzZdg8xpZbcyM68ZMswW5SZPVvyxE5Mk7Slc
	/YYukJn/1TLBc8A1dWlsFiL2rvGZo4E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789124755;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mCvWKSyOXghSRjrUIO25WhTluktNhI1ZIzrUisSCzog=;
	b=b+7SUHz3bESEaqJoCQKVGmpl3KrUrunJsFD9TELjfIDfQGfJXAJcfCB1Y/yJszE2SdjUyI
	hA5MPiO3ytWkRLDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789124750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mCvWKSyOXghSRjrUIO25WhTluktNhI1ZIzrUisSCzog=;
	b=M6mKBOHbiTWHmrq4OaTeygTN+927bG8HXBCzz3Y4jYZpN6W2TIiMwt5mhZdYJylNuC/eiN
	276E04tyvopmopDYC/DjhTeHmHxTFJuP6nRvia45UtqLQRXbvqIOWCXqMt6H3llZgBfxVy
	F5cdouDM8VEETMkpv1vrbWcWH10Fe/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789124750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mCvWKSyOXghSRjrUIO25WhTluktNhI1ZIzrUisSCzog=;
	b=Bkf9+hFx/ERl6em/gPGKeoPFenHrChRVNOZRCzaiyvdKpzPFysgsyvTYq0CeN+eOGKeIpz
	kWOLNVOPOZL3xYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C59E132D3;
	Fri, 11 Sep 2026 11:05:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qc6PFovgo2rzKAAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 11 Sep 2026 11:05:47 +0000
Message-ID: <d8683667-55d5-4d77-9dcb-19e49b3dc3c6@suse.de>
Date: Fri, 11 Sep 2026 13:05:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/39] fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add
 VM_MIXEDMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-18-dacf19cce22b@kernel.org>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-18-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BCE112000D
X-Stat-Signature: enpeehy96app3doj3sih3uoedfw9p3pp
X-Rspamd-Server: rspam01
X-HE-Tag: 1789124760-626230
X-HE-Meta: U2FsdGVkX19/RJHivp7VIJJVUAe1vciwAoPZ+bPESWntxE26Kpw0tcdm+COE0IWnBO0OIKPlKlXO/w/Xvb4c8MTdu9rBpfkPgcgLWmtHPIdAQfnz+u5GsASvHakq4mst227xcMATw3P2jydGDDDHYerhag5Weia8mJECb3ER5uC93+G610Qa8Mx7XtHHgBau8NGmTvsiE0by25nQl+/Enh2e3OFrOTEhecdxB+7FLOh7VPQkw9muHxXrb/fFLk+kiZHdERxY4/LwLPJCZ0NiTwsLOGSRK/ktHzg80UEsCJJSFHoc10xUnhIqSn+C8oBkSnMnvonCiB3Ubt9BQ6mCDU14YN/c1gg/la4ICWzeq0D9hWBiIKB9KUVUquU2W26G2b5BaIAWKY+M10DM1vBSVyLMsRjiUN4+zBvhXtdpkReAR4NXTEuelKjt2TRyR1B9zPpywFgxYTPRgEn9usfuQOyaaVurpS1jpDAzNzJbw7IQ4WDkBAxLSsLVqWfw3+OhA6xbpB0tt0y9LuKbyWAvZJLRQ+WnjTeij+7dUBgANscN21AY1BPPWPwEVf3ebCEJohAgfYKfxyE9pwhXZNQRQLi0jl7krDMQj2RhtIgo9Ky/pgVaidkK8UZ0BtqxRe5l/TQGJ9L8FTd7ewxCaFAQS4r4eYV11tV1ezO3mjNw2dfZHYpo2je6orGPT46uH2zCmSG4MvztoGrqj5wa9ZH5YkOijH7fNDF+hhBXOtN9RievWdTQ4+P1+Kk5Y6MiCqbWvoLMtPE6zVupwiIOCpc+BB8n4ZiTa9hbP7+slqP1o0ZFd6xatW/J+fkRqZ8s44xfojOFiI/X2MCzyClUfzh211KIhNjIrLIKlqyxqUMOQE91RZfOUngfED9WZvMehX0PXCaJol5fGOZ7MYmtNMH4WdVFNXoPQV/WUO7ukIZqkMl5+vJs+N0LEuZQKYoTJQTil4Z54LZ3w7CdpEvZws9
 jtl74rl5
 NhdopOrhEpgfvw7ezHJ/YLFgLX7r7qI1yTYCpGpUUzlpZlj8CWTRSByYiVpSZSjpNCPqYGu3ZNme+4qhkx2xGLhjwINGPK5mZM9ySSzcY/knUfHUrEV2G1Pa+UkutoKt5IruvcFTnyvVnP2c3OxTx9yopszrn9FjqQ5t3LR7o/Fw2m2C9aDJvoCCFLOzhdhwusi37kcipQU5Zfk/N3ZER1JWWsaMU6eFKW5+pX9gW16av//fAaSaMu/z3vNl5X/Zn1Ufro6dEkYZk0i5+rGHKsjK9Le2tdVIzCqcxXi7+LhILsEir4h+AbiH6KU50enxJBgoxPQA79svF9DUFoyjQC61UIp0Wpqz0JuafrYBEaTlf0tkTAEl/beqQ7JEvuEsgb7t4lmzqFVLg96e/hV2fNHPnNMsLnBAirZqS+vFQFtJLkQMnJv1OuvacNRNaoH/4PsEeVPlRF0X74mmHA3HKftH0ossxxhMm6kPqLryWbQAp2E7kt+mlnl5P5Wu1sDSmrPrBzrk3VBVMl0g9M7W76FiZzTWIfcORGnMoRgYhL6DaZk4RTer4ynfajWAN8f+qEAWKp1z1/nisX3DlqLBczfDv98UOXzYnEViaW7ibl7JARouLsMRBav7aHuf2Vwb8SIbPKbBkIWmkjVffN1w9KUvmiD1pYUf72p/vg+fPb7my7G7dP0p/T3RcoTB+rpSOs/XvNe7SlLO7J4VzGgSVTa37RToam0vC1h8cqM+CiWtysUv19ekrBvXtbK4vF4PMj0bKIY3vicmeD6a1sk8CUwxLqRICZQlMuZHKOT6xSBU/caV2K9DfYYHfe8H3lN9CijI7MBns+6iUUaRmWV9oRR13oLEsHcvovIl9NnsEWTiV+4R2c7WOBY/LJUHpIiq2Wx37aPsrCwrfDmWM+/R8qsaP1C0KyInTHQm224soCbji/AsKgnROWT0YgGP4tek4NW1lcB4fn9c9rJOcT3KoFkCfCAVT
 Ce8TfvCB
 522tSUWo8+gjxsEZeMfQ6foggF7dyryS8OM3i1DHOUfAyCAku74WJH6Gl2f0BaJ9nB23spHsdYd6vRLscWlvdOGZ7Rp/gQaYB6YMZL8fiZEwAehJEsjyZFycFcQHZDLCaBae0JjGT5LTDuZgEY026KFGEkx+mgdv++7wLjh76qIpBJldfB0pbawNuR9tImxD5LtPoghpQcScqnu2Chh0ZONp5f51AXywdPpGV8lBC6tRD5akJIQIJ531N/9K49yyMtCxTKuNFXYI3UUkE4DQdDjhtqa5BHxHvMQfugP4E3wZG1QdVL9xnmDMRYeUq72+hhnJzppJ9lCSGYnFYE1/WiMlOe3rCBlw1HHHCEjt2UXqWqET7kBpjQN2op9c2NOc6Y5H98mQGOuRhLfDqS5IsYbuZwa+BsuVI2mj+yteQ+4zGIJo+XGsRCA+0sfuiu7gZJGRvwwR0DsN0Th5BcI79pJT6hXrEmHpaKpyA+aT9qBVciZMrb8Tz9TWpe835IjxQZ8yPqziGOj/Bh3FNKJSaERl0e95iShTxxsmhUM7rmgL3q6mCq4hh6SaWBrYd7v4Oxs6iD2JVzUAHfVsAFsuEYDZLT5lVxBqpFOma7jVCXbFVQRNwEuhabBrA31YNuvd8GyCGzRE2U/huFHTb+aXe/T9kHCm6Esx4FfTreIXJH28bLkBhz2h7m/9RFfj88ABWQt4fJIlXl/SskuIFr9PwRVgdvZyYQJyh9Ss8rBWm4K60+vtkb0OK+3KAPZGiQT4LpxEsRsz3VcCphISQM2FXMZYndD8c5YkITtp+rHBqnXHRtyxRRN8z2ogb0uUc4L6iC/cw0R6P13jqL34ULgpeWu6OUr+36+Fi4NUIl3EKYYAST6rK0xUM36WSytqR+rfyl59oXZx4t29dpLYhdgrzlKAfs6w/hJpiDPsIud3rUTTWOa07LqvoENGSWzxH4MGJ4qMwptzVBpmnBUNIH8ObTZB1GdPj
 zVt0EBV4
 IVPPONoyC0fgT9mClJC0oCQozsAByLqSxFVMrGUf8Tdsm43fWnZA6J4Dt+S2pxZfSrgBAm3DZbjHtAbGAnMnQuW0IEQbQnuBMQDJMei6K4L+b0w1OhqJ8R7nYjTiMaoMT7SpMru/JebFg88A7VIt+xTouSyEnCM+R/UNK/64xsypBRxz6S4bxQhYZfZQEvp52m+ufLUZIhhbGQi2WIiwPcQ04qs7Ibb9yH/XoLdOL7O8GIeXPQGpcOEHyo0oz56JuWN+l+RmH3t5fMChaFlrrY3DQIbaZaYkfyEohCyLh6L00dhLNvNHljkBHOLKTwWoV3uUPEdsJYKEA7kSTROwtSTWEAhsf7GJN72kNS5bFmnXfDVfTXnt4MbFfLGPBMwQ4z3zWRDbUtRZSfxMyYk95yWyCvBM9fCBngtqjKTNbDKWGy2vAit2LLoZdowrC28BZJ6sA8kzS7yuMm0zBQCTp9L8ZHoi89CrPX2OeBPIqMy0kreU2ZGJg9eqgQChPYJO/14QCDFY6revG6Ca57A1cC7m1r/n9WcltTKiBrSj5REuE2+2FFTGXX0UBOpZC87lF5cy3jeTBJNmJ7glp8zmvxieqi+VczpKGAtqNEIYWSVQEdTw1lPNOZVGfgF0fmx0Co7bSljM9c6JuKltSxUaP3RdnTYjMDpb5p6KRjHnzU17t/bj5QrYZNwO5sIXHoVBsFeeD4luxzyXonofrf1O5yz+LM/hv/WINB2o7mnadqSjrx4K1xon1fm9c9XhCL0SXcXTuxXU4WbfCF+n/tehgH6tIKF11KEztONMEp1Zu7YZknC8ok/XjK/1ZabfwPZxIogFmPhktPtnEDaJt6Nhp0yk2xaL0gYdGAxBxWHOlFbFwsdyJ5JYIzQY646dEl+ziUyGQ3zsWQFewGJLc9L1lEvYimvRQpY88KJLiu9qaC3UzcIXA5HqcB8wx+CD+4j79oTa98Coiuti/VYCbnCLVPCgzaKcB
 4i5teR9l
 jHSjBiHv1qqj7QjhnTIecbUDBbLg7uKN5catiUtzpfXFzUDz66Do8ZrrJQw5+VD6AeWBBb2ojuBLckV+gnpE6AYOlTQSF62StjgAGb1gj4/CCIDaxq6VT6zgHo2r/8sFEigj6uJIh4iz3tGhkD2Yx42JI0J9ANPo9PvJZ2h850JHxK6qzdSiRvTfDIUv9s72av0vsQMUzC/ByLSj0M0MupgN6+WIBYWp75ppqH39wG47jVvSPrce8eNe2DI+nC55XUYE99YSqAV4ovigodxBeaORm9J8M6wJ7SHdAttZCRU0jFgvXReffY/LDz59Oxg1a5N2IehIZC9/ZtGAfnoblxmyyl8rvR7GAKjUBWOvPHgM/mNl0nT8mPy1FlCAQ2xGc6TNxwHIJW9cZnO4BpYLeBRfKBBlIqhGPdMbnk8/AYIkdlQt/vayICm/fs83qhXMmAa0rGdW+2d1fL5waZl43jA5LD7LdG+RJSKgp3CeCKXfbB1axb7nJX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Am 08.09.26 um 22:01 schrieb Lorenzo Stoakes (ARM):
> Currently all drivers which use defio allocate system memory. All of them
> also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocates
> system RAM, so simply failed to set this flag when it ought to.
>
> This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
> in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
> erroring out with a kernel warning if not.
>
> The logic requires a page from the driver and since commit 1ecbc7dd2902
> ("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
> always required it to be refcounted, so this was implicitly already the
> case.
>
> Finally this patch sets VM_MIXEDMAP, as the logic is mapping
> kernel-allocated memory so this is appropriate.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>

> ---
>   drivers/video/fbdev/core/fb_defio.c | 6 +++---
>   drivers/video/fbdev/ssd1307fb.c     | 2 ++
>   2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
> index fd00b86e1ae6..fb359ecc3966 100644
> --- a/drivers/video/fbdev/core/fb_defio.c
> +++ b/drivers/video/fbdev/core/fb_defio.c
> @@ -366,13 +366,13 @@ int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
>   {
>   	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>   
> +	if (WARN_ON_ONCE(!(info->flags & FBINFO_VIRTFB)))
> +		return -EINVAL;
>   	if (!try_module_get(THIS_MODULE))
>   		return -EINVAL;
>   
>   	vma->vm_ops = &fb_deferred_io_vm_ops;
> -	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
> -	if (!(info->flags & FBINFO_VIRTFB))
> -		vm_flags_set(vma, VM_IO);
> +	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTDUMP);
>   	vma->vm_private_data = info->fbdefio_state;
>   
>   	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_ops->close() */
> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
> index c4fdecafd856..958514a35433 100644
> --- a/drivers/video/fbdev/ssd1307fb.c
> +++ b/drivers/video/fbdev/ssd1307fb.c
> @@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
>   	info->fix.smem_start = __pa(vmem);
>   	info->fix.smem_len = vmem_size;
>   
> +	info->flags = FBINFO_VIRTFB;
> +
>   	fb_deferred_io_init(info);
>   
>   	i2c_set_clientdata(client, info);
>

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Jochen Jaser, Andrew McDonald, (HRB 36809, AG Nürnberg)



