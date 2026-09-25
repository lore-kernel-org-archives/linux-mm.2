Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68446C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9DF6B009D; Fri, 25 Sep 2026 03:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1DB6B009E; Fri, 25 Sep 2026 03:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1886B009F; Fri, 25 Sep 2026 03:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2406B009D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:37:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A921914059F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:37:45 +0000 (UTC)
X-FDA: 85251480090.23.3E657ED
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id C640C160006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:37:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MxSKvpwg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790321863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Oc+jzCqS0Wyq/bTJh2/I4jluChyvqK4NXUNsIigcps=;
	b=CroHdMuF4StlynxHQ26Wy9I1DFx+8LCqNZg8XoPiY4GGhVp5FudcDGsyNa0bY7/OrPmiQ3
	vcbNwFzEAgTHuqrITSVDSQzLugRrMYfqe0nsMViF8zdrMGkfJ9YYrKkFb09czW7pyDuS+n
	7lqJ0TTGBbVuT92VTMe6CmV5TS3rGMM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MxSKvpwg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790321863;
	b=DDZf4xKEtbcvOyboAR58/BlKCgM22512IlJuUF35ydziPvurdZ3WrJb4w1YQxgi6Xb0wSE
	sd780EJf2PcwebMYBVXr3pZxGYZ4nqOPXPm06FLsJ/wbJy+GXP55RCbrgttTsfe2d9U204
	BWPOp+TTuc9V5GrCT83eroEOoEoUQvI=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a5f9b036f9so5549a12.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:37:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790321862; cv=none;
        d=google.com; s=arc-20260327;
        b=h73cdGtfdpnGr3aoWxMAj9tYwDeF+aURHKUbZdbHsGl3eYsQYTBVbCf+4uLDeXsjZy
         dJony1P9yRmVGk+TXmh34rRKdMhiofQOV046jRorI8H8YlE/BLk+MgtQCl3AdEyM0FmG
         5MyT7hg9f1iRVD2lhKEwbSmyC+Mj/unscFBMVwWC5QT5WRuMiwgW01pvSqQW+KDko6yQ
         s79ug3OYonCdcAuEd5X2F2ms3BxY8kv+PToQMq+PbhNIxGYBkza78+j1t6D+jdbU7uXp
         yFlwLdvV1CRuyipO+ou9jnUiENCzUrXlfegqBT31fiYwdrCKZ3eAXElL1xImvNE4qm5N
         eCqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Oc+jzCqS0Wyq/bTJh2/I4jluChyvqK4NXUNsIigcps=;
        fh=NXJmAGI5VUPH4n8jvIFC6FXC5WJZAPaUPTH2k3Ykhh4=;
        b=QKxPOV35ywgoYQeOEkEAwg32QA7PvXf0DhqxBSqqdpEY1i+rL4hr7ISrzQIxf8wPqF
         BLjEq2tpOkGOh62gh20RgfnaUY8cpIcMvGD6guoI5D6W728fkJN9mlRQZdLkyKhHDgZ2
         /lv3xybrTSZfkWLUMqbsqxr9GqRJHKa98K8EFS7tDhv9wUACkcIl0LTlkDDC+7056woX
         M16kCiWY0JkgOHjHuaIqflcdMaCyMSXljv3zBCWXtvpcNdYLwb4Qu8WjEYIUuowg7XY1
         qoCmpS69xsm1Umht3mHYFcTvf3x7PUGAdCdBZ927SCrUAhoceqrmwH1iubvlvIubVJBY
         zGiw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790321862; x=1790926662; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1Oc+jzCqS0Wyq/bTJh2/I4jluChyvqK4NXUNsIigcps=;
        b=MxSKvpwgJdQ+CSy+72t51ZxC7tVzC7mZVwWkE2WLygfiPSeZ+0K8EcZUnAjVOqR8Ne
         KuJThe1TlExlUOYxEB1npoLlAVknr9XuVJzeISNdaClarcFgbVOyEwQs8y89V4Wtcqdg
         rBjAgpWnrW3XxmxUd5LjcGZSSbwpatzDUljgRWkTlq/7wjvdywjgo1/3p6BwuIV/iSNQ
         rpiyXrA2ZN8UVLB/sjns4fagKTdDDgmkaoKJLyxZ2fp6B0RuF5JLkq6A7EsDpJsa63zQ
         hiG8RI1TBjoH2a/TjBuSLySR+YfZ1fbVODh5NmScX+0cUpL030OhnYipEBSd8EiiNQKz
         Qgrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790321862; x=1790926662;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Oc+jzCqS0Wyq/bTJh2/I4jluChyvqK4NXUNsIigcps=;
        b=iE+dDwWIMZg3zOJedoflbIb2mwlplUyRa9j6pChjAKXPwmYAdNNqkuRjYQlQcM9O0Z
         SXVCCBcEgOdPaIyqVGilUTIu3R8XCW1vAJtni7mImgLXyFr/cYDJsIhjSpQYl6ZWyI/4
         cPyiQhA3aOUdOet3SBR+uQU4Zqahj5VW8od7MRQTJoDzM/wzydhiZZ4nEEpOGYCStVWK
         TfRcQK7IesDrdoNt0vqhmSFxvEhDJtn2IwNwhsyxq7nElm2An6OdvMMmw+R2x0iZPbqp
         /+2ocMRx5b3YqIUKGoXHux3WIasZxNyh50zEYhNORFPJGHepyXyAD6Am20TnpTtON+YO
         7iCw==
X-Forwarded-Encrypted: i=1; AKwUvBwd2LB3wqZnOzx8zOOIjJH354TsP+UNaaTv3+6zWUw3dkPauK3f4dsGRpk3B6LDW2YTBjiRAgtA9g==@kvack.org
X-Gm-Message-State: AFuF++mcKbAUrRec/RIDz7lQTVqz32POdJXvZuKDuYjA80fVPoThFuMM
	3bCAGkZoBbUczjYzOCd+KjQeXpN0cMqE+g/xxcPMNLgazVoHzNmlOfrMbokheP3u5hK2iJvNJL2
	Ca3vq7sqWiHJYiyjKtCbDuU9knhK4LRhDQW2gg7r3
X-Gm-Gg: AYBFou1FMThQXcB599kc8FvEw7SmNRyCf5A/aGbrhmCbxV+sxQHpfSZQK4OlNJnieT7
	VwzzhfYXTyZWkfn6PIF/iGwCPM3MmE/BDWepQ33ZagQJ0Sk8E9gTpKl9eiXPAU8AAkftkSSVVzW
	djONirMSeaKzWUQsKUe+vgmPBPEHxikeP4FGSJZToURS3HZexuJtd/xSsYH+xmD/uP1NxmMvn+/
	xURNvAWRurARMwvM3bu1mGp6JsnBGuKyj7tEShE+kM/WzEulOfl/AKJ7jtVlI9gzfnyDbFQPlqm
	KYtJb6vwyucDzrhRti3v+K6FhxqmGAxWtVNaYF7V3/orOLHGMZoKDA==
X-Received: by 2002:a05:6402:2714:b0:6a6:f2a5:1b4f with SMTP id
 4fb4d7f45d1cf-6aae4729638mr36915a12.4.1790321859803; Fri, 25 Sep 2026
 00:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org> <DLNSOBMBHIVC.22QI9YBL1U72E@nvidia.com>
In-Reply-To: <DLNSOBMBHIVC.22QI9YBL1U72E@nvidia.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 25 Sep 2026 00:37:26 -0700
X-Gm-Features: AclHuK_RUT9CXNFLpx8ZY_roLEZNzp5S3oNdpNL4cW25fJBFg9wRGnSWohuMdYA
Message-ID: <CAJuCfpH6AF-hOo4jU6OeNVpd+fgpqLpmcfAGs11J=nPCgAqG_w@mail.gmail.com>
Subject: Re: [PATCH v3 07/40] mm/vma: tidy up map kernel pages enum values
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gs6e3yrrterpn6df7ydmxgs75dm9ywtk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C640C160006
X-HE-Tag: 1790321863-209411
X-HE-Meta: U2FsdGVkX1+ya7/GOYp6fWiP7iLkBFtrMzl5QPhhIRnFVhfJgq4K7HJ7b5kMuTaXk3eT2zayF/BTFwvKBFppg7tFY4o7DlSoNXKVzpbAFRMV6AEWJjPTzPahAFTdyq6jKBsBaA5tvfBgJkGP5G+yFVMk5MczaSsOwpbV4gD8nlC1RVabeYFEao8ShdKf7cWGeWTNn4U4lOMa1q0gy0oJYRvllisGmU3GRphjiN1cwBo7nGL9M1gxcGTdJadZ7gjLkgqivtChGHflRH033aaE3VkhTQqYKEGu5vH6HZouhQ1xtxrnYUY3coBNkPX/4KksthtivXA3YUhyoUsrtUZo8CVpKGtGDUaZUL26aGV+SunX0C1Q1Qi3yn2u896Jbvf6NuCt9yxmQZ3mmrWByan+VIAUk2jiNADN58H1IHUwyBzEXX/nWry0Q9biJ+BsXKaESdpkpErA56304TwHJsQvFrAL2cZzp1BaLGUXr/xhY2NRcLjiaiEY6tamn+pCWFVb/SVuQo/Paa4ksQC+sGdEnqOFov6am8TXNUz85STLeV8WqcShCHy2brRieWcBlFYDcscXtfBew/baNTuhNOej9cZz3HvdDNMqHUAIu49MjcHpimPvSfHPgWD7GSYDq3aL6I+hbLhirb28U/iK6eghUTgnoKltnZfnLyKs12V/K6TF7Ccn4MhH/kdN9Yom/2cERgQiHBT9MnwF0l4Hey6U9sS1azqcMYmnkoTw3+ddMLzMhtqnnLJvZKBJzJxVZ1ZtHTZ/YaEVrNQCbCr5oZ1bQygK+JUSKIa6+ymKPSAQYkTJv4Y/sYgjfFExTo/7M0X764X8QWR7cIAwm6QvWslEC3CsSPfZdbLLXxcCKQRbF/nLQrTLd+D2TnvgzL1zXGuRSrgsCUfeoQzwIEAVHRv5qcCk4u5vR0nUhaB/2KNaK+eSiBq50mQ+S0mH6BfZhMzUNsE3Kz/0rLqSmazqxQP
 O6DhFsGD
 qeSmUnOijNxScrO8GvVOQLiV1Z7fIFQeEM4Bg4zee8VXAh0THj+k4Lfn2qnYBaHdSOFFYkRzQ31dHIg+W1ekFS2P9ZqOZvKHHksXpdib860hxeRbPtj07gscTRnBpsSPDQ/PNJ1UfImU5Sq/Brsi2bK48uNFrUwW5t5utjPmW/u2e5nfv8WxzJnxkH0WjWIEmImq3L3qsrjhYw+ZseDGgbcjbdF52cxrs6tvyaIp3VIgADf07cS22n8N9KqApAtHsQwDzdVjUeDxN+lvuat9ON3vjXdr3nVwAeo8JxqlQ2rx3uP7WsIVJg/AIxgyIlSKznDlGw3nfJXWOyaL0Ooc0JYuGbJi44MpQLtKcViSsDNG40y6XEYMTWzsq0UnHy1AfqS/KJ7neQws4l8ow59KXJU2/aJHKAsK1yc4UlNi1oz0I4L4VYFtinWHBAoXczgdyNMssGQng1fYevJyH2tGYGJqS5iRobrZ4u6Bj3rOlSeT+bU2qrt96W7J6qrhRRx+ubZO3jlCH9qaL9UlSx3wqoBkTQU+Rg6OoHZ3KGnGd1zH4GeABDsVsVnHGC9n3C/y01GD27xkyhmr5eTR+sY1yBQ7cB87J29rPyURIYk5Y3SYgNVL6XYyJUWKO8OAzX41S1sfcpyVNy/S6JZiexyAShnmme6HS9hViDbdMxcgWJ04esoP2N6vYC9X8ghj1i9JTkX0rG5ECYh/voc2gpduVJHhBOpEJ2bGJ2A0qvANJRjLjPT80Hxqq1YVtMW8fld513KrnxVP5PHHf+IjagQFooo4YlwxfTlLHJ82CSR1MKH4IdNJxWmq1BMR5iLvBYuq/qJMEg0pCxVIHqmb5VgkUx2EnKJIyfB00YN6kb1yqhjEcG+7lse9fIY/JlN8QN5dAbp6eKSDJefFnbnXBANzmBWq1aUU09It51x7MH2AZfTVbniCam4dXPfWrJonjFRrxjIpw0ZMZHKJd76eGo24rURN21+0X
 ap9ovd1e
 864wj6KJg2FTgkDkUVVfPp9YNe0NDcIsQ6HABh8T72NY9IIJgChAU0jxxrDZLWP5AzIZ2eiF5FcAlus9w4c/OXefq/dXUhy2iQ8q/CCW3kixoI2XSVbn8ngm6HG/CfaYU+huTjxgiJI7QQsKeLS1fHp0bbHT4/fSNAV6owLiR/VCl/x/YymUCMFP8b8qdsoW4mBC0XNfj9M6IMe7akVJpGZoKcpCBwuH2lk5HGMx9f+BFvbbsP6CygqvwHqAZ2do1FOdFBIGIGG5BFFhSPazSk8VJRJpE/tPCHM3UwYI3hSCqujb32n/9QIN1sxKIGYl+ABwyzGUF5bY1atMZNRB164jonUuBQ4vyi82QYAbfBJQ6fK+EsSbUW1kb+t1zfVD/tF0K6ZNTMhpmFi+8HhPuoCMif0YK9H9w9hQdeE8Wf5CH2lANiYSo1c/vsjgUeZf4iEMaJ/DeVyQU9AMUp/NPdRrW/OYx6C1IRqX8DxgSvwvzYmLp8+luGF9AS3jRvnrpXlpHLgSpue0tHstFUryUjYf7slhVj2sJCG0m9raub6nVIyt5PI94Sn43aH7lDhsUAhnywCSj5KRUHBXKdR0uM4GnZIJHX9EygRjdlajvPu24hv8JDa+GekMkGwGYSZGHeEwGvCmopG7RGQPq2AbFmzDf64OYmMW0e7w7EAfNOjcI8gxeTVKVwqN1ZDUKHbYVSjL6Fp2cH4yw0s+5B5cOsyrGlz7CUpu6ER5xgPNvqunAI+XxFGsrifzOVKdc3So5eFpyIFF4/L8OORzGhCV4EMCpzzQ28RIVR070+CMW4Ly3V+z6d+ejpTKG7ULZ+DJ9Pr2AvpNiZyd1RlqT1aR/AiE9t/oEPhevkSfPMnHXPnkNBTWlqAJmzNrWMi2keiekwQZdKn0/3iT9ZKKJYGwuCB0iiRIStH4y8SOwhWIoGIGIepSe4qLwb1YOSDXIFgyXDBpjEM2fJ5A8T8UUrZHT6OmksqzU
 dWBT7sso
 xQeNTrtIC475rwMOOkhyMn2o2gzVz5yobU9k6s7IMzcmG6iNolHpKhZgumaxVtZTZgYRzaSeOV5a/mDDPD5TUtpLEkVnImJfj2hVuTtmdARdBlTT4/YJ7WUItPcn1rQCd+/YVi3NzC1FjLHQ8vlpWGz69uK2/Ek2wJuWlFhWgJ/5oTKqOoKVvU8GPP+G+ktnVRJYoSnYxOgLxTe0rZ/pdWEZpQ/RFyiKsTVCLwZZTSNu9a34VZ39+4qTggKLDk3dBipY5tXMGKrffpA5zBMK7fNzO8RBdFC+U03kJr9+7M7ohvgzzsHkRMvW3DsTWVEcpuJlAdH7xXAIvw36PCf99XrEaxiw6L0FknsnynAHR5wTjlRLAKTKPg6/iI6T9vakOYi1k/RHudJOtin3T+uGrEtyWBRw8nVj/lxt8xYNEkS/ml/0PP6m+Zd7r175PO7Uic5OprGjCZWvfiHJAktxS1VY87yC1tqghAPu/JlOOX0duzXHnvRwdU9DwFCZyQahoUA3lr0AJVshypOjaE2lKUJI15JIIuvbi1DUxrkQwK1QgYP3xNPfNiGbYaVnxQo9XFJP3jf8lmF2UHIq08sv9tMl0uUro1T5J2Nf/b998lU0xQX2jfaF1pEBhyJ03c5tCxQopdVAqxa5eZZPSzg/8gK96HhS4FByJAuPtxPrZZNOhSYOBgq75jUHs2XTbotQxpSrJmoyej1zUrwnBaMEbHgUyd23Ipx4Z8C8gzcVfLg8fwRFZ17eLWt6Ayc5DEO/BubY/LotEVUL4xaX61rmRiX7GyWayQfM1W0DCzYl1vHODsr2Fx5xgUytG4flGXy2xBCuNCsBiUG1p7saA7Xnar0TLb3e8fQ3hAw6Avs+vabLRtilnD4tUCZyJJnE7tAMQfwrDtmxF+8+2O5TUHxHQv+2Fh8CYdoby6UbbmPgkmBkUFXqPOfzpcp5J/qYNkY84B/lKQT9lP38BTjr03qzWw2ttCz/i
 96H/ewCz
 lk3v6MSKbTPP6sF0aV0D8u+DI15TFLD5VuE/ksETXzIQnXDLXemaTkB189WDiGQlCTTg1X/ihtduA/RZ7I5mXgSV/gHtnFn1U5In1TBb+djD0T8bz8If+Gu7zKXxhuV8XpOF9LzuLWHrfQKLyFNGZVYbjHeRKbY8yHUP9IJTuDl7bK5AmoUYEis6GBhwXXWUonkuNhvY9SzZgp1QrwThTwbPHdm4579zu1bizVRhfNFPN5WxgmrMXGLN2/HhUCBMhXw2xEVeWuh938OAQ6tcyVATp5MXHGUT4BiIf71ivm5m3qHk7fwHy+xoqXQX1CpURmoCd0wBFCFqSzw7BAfOAEO9bRYgnIcaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:31=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied=
 by
> > MMAP.
> >
> > Also while we're here delete useless comments for mmap actions whose na=
mes
> > clearly indicate what they are for.
> >
> > Also update the userland VMA tests to reflect this change.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h              | 2 +-
> >  include/linux/mm_types.h        | 8 ++++----
> >  mm/util.c                       | 8 ++++----
> >  tools/testing/vma/include/dup.h | 8 ++++----
> >  4 files changed, 13 insertions(+), 13 deletions(-)
> >
> LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Best Regards,
> Yan, Zi
>

