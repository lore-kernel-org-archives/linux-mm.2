Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC92C79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6A26B00B6; Tue,  8 Sep 2026 16:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA66C6B00B7; Tue,  8 Sep 2026 16:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96FB66B00B8; Tue,  8 Sep 2026 16:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 739F36B00B6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:12:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AEA01C29CA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:12:30 +0000 (UTC)
X-FDA: 85191692460.26.B5B0E2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 412211C0007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:12:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWzMB6ct;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFwYdR7MdQIJkwtfLhXuGSNYO6+D1BHAE+s6WKkSbT0=;
	b=NfBvty5CjzopBr/yCCKpKvWmWeKXVqzK45kAmpJvxBYnQywGAiIdEdE0OCGwLrqAvDkBLn
	FTl8E/OFl/Kwmh2o6Oe32E5HRXcAyzPDOBrTYMNBOrBddPvQp4/iwRhQ2XbIAer9Xfy4l4
	V+4yXVhZVxeUzG2KrQbVja4b3HVZ080=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898348;
	b=ZvIwIHtpLa7no6c+KM/oTVlP8dwlYfMMuiND23OvKgtkWi3lEWD+wp0HK+o+7F+2TBzW/9
	F3BwW4gaHHKspInpDI/doOshUdALolLJai6Kcd7SkpKBoM9epmyLCa+vQb6jV9qVy6jxRG
	I5PRiKvaj5Cwo6SIMqNYQxnr4q5QGVY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWzMB6ct;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73D6443953;
	Tue,  8 Sep 2026 20:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366701F00A3A;
	Tue,  8 Sep 2026 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898347;
	bh=IFwYdR7MdQIJkwtfLhXuGSNYO6+D1BHAE+s6WKkSbT0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SWzMB6ctH7t/MOHNYI3kwBx7MduIk36u1vcWmcbZO26FPbQ6LHV+ZWUSunKZRGZze
	 D9qhEgZQgsGW1c8l3Lm8HdEJhOSR9gFBGvda16hgajVgACwDxGiLvYFhAidd3Gpz8h
	 XJxJly0i9SW+h8Ma9aKCk7QLtDYFMoLr3s7VBDV34gKIdAnLxjQwI3KV+nRijGa7Oc
	 FLK3CcvWOdUyAMNyWyXvC5ugj/JgZJZMBdfBCIDPMmT625PVXOPcpPQrdzhNGu8ril
	 Q7XMtJjzAOyHi6EKrbCH8f9QDo1CDyhzHCkTank3MhnS+1WOEWITxPjYb9Lo4g98NU
	 uBB28fIPgF7fA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:25 +0100
Subject: [PATCH 21/39] uprobes: remove VM_IO, set VM_MIXEDMAP for mapped
 kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-21-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
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
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2032; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yDTjgG6ZNulCil8lAdq/Sm+oS00ngLRTCfWCLIVxqmc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG5eu2fSr9vLF9Tt/2A6uebt/Ok8E85ftD1aveAq5
 9uiWPMPDh2lLAxiXAyyYoosz7+I7w8SCZvXecHfDWYOKxPIEAYuTgGYSGcywz9NjwAp/U/RMWkR
 VR83sU/gKWX0f/hqqbXuX4GUtq+ZrowM/+wZ3y6R3ma/adn3tbq2/WLXv31Z/lvQcF9RTIVzgKY
 RAyMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 412211C0007
X-Stat-Signature: 1a61bkw4hiwbaicq1z9bidoscc4pq1c1
X-Rspam-User: 
X-HE-Tag: 1788898348-149098
X-HE-Meta: U2FsdGVkX19m1R2KPYhpVB6tSo3rSK8OtCdo0j7IvZfZL/zORE3UuYL+XrPUDp4DoYgwx7X9CivgL0dRGBP0PntgJzum3z+aacMRp7Vv6B2i2eFAAVLYZwctlvH8gSrOsxgyvSrllhXRj/lsvhTx0YXDMJRu3iA7Zwc8w8gHuv45HGZYGvF8z4QeVwrNZriDSoW1SmQ+HOtP6oU7z0lrlZHDKgZ3JzHYqFuSe+n8v6kVxK3Bp+OEPd8p13tvB22r1kc3FIDg2G0/pkPSDEoyYOSMq6N9K5mitW1w2lPLEMZYsAJz6u/BrA7Z0SKDBQK37NPvZRV/2+24nu2HWY/o/rAImIA7vFyGgYyMkAoOXfRtXh+7G/Vou4dsKUiSBPxr+30clvX0IdhAeFfh/fw//+dVy64LBHSHD4XJz5ZJT8wm+XowXmAzwrdAgLKGlz6A3LkK8vCBt1BdfbTIymkw81NOiLdwaVZGLdYGMlv2iEBix8cjeO/yoLzsBf4egHz3ALGP6nsBOGWJvI62U+QTovwBjpmIVN1sKQbrjkf4yTy/9bozbnT/54n8inOHHhgwAKeGqh9yZ2KyZzS0XUYE2MNxM8pmcyPniAXL6MCUG4jS9iwgkUDJgnOy83Ki8WhgKrU3wdIYjtM0w7ElK4MgRSWEbhbon+Lkc8DimKYtecDU+HfyJo7YgUpOnceQsxSde8ZY7chj+wq7/pYgJnHXDLlgc5zifIbzI2V/N0nDkcQVtaslNuvl2MjMhVW7g7iXGS7hWX/MVH+7zehInHkU0hJaz3ojSjqBwah/4F5muv+d0AARk1KdYc9lBpUreNfNBP5mTkJlIikwyLZgVJVxWw8AKy49uxDCgXSrovMkhjIgOSkkf/FdbmjRDQrL/SYI6fWFRZgF/imMsnGOPYTaVI0Sd3HYk64ZeA8SunuwI1E8PW6ybht0oSPQb5SYsqOR+U3uvZJgew+ZFL0zMI7
 TTMMdAbI
 XekgqJXDWUcTYiIzpAj8xkmICZA8AtLc8GaHXLk/AvxlQI5J7wkd32ozt2cvj2wmoXt/Ng/tR2ZJeNZKLrm+Ol3esDNWOzjnlvv12VwwMpyZeNTBxy9zrHKhk7qvShPg84TsxB7kD5OtGrVU9PJfJaF1aeswblR35rh91qUx41Q9xwt5bWp7ldyEYRuKOh15A3HRnmfV8IEnXbO1XVa7g+qIDVy1AyjqvBsC7W1e4XTSXxNI9JWUxk4hZbRD1FjlNoHV6zOf2Uc1HJ4Uw/Sv2daC4LNW7yciDup801iC121AZCAKjPSxe7e3Y+LNdFlnPCD1YTXKuYcYCM6PS/TGRW8rAyp2TOKW/0Twm1ArZjtuACBXm62dBDVoiXD3/kBEg8HkTOPmSO0eLvw+MAf0BAGGurz7hToFh8mbKDbQ5aLAunS+/cTpwMX2wr9sNgjJa5tsfFPFk2spuvu7Nr25t/gbsmlLLFzVi02/cRIBRiVUaFYj3EIMGcKE78lVNewU7+Te02LLpwdO0sRjPhxq/z8eaxGLYmpkeGtS/dgoifK9Mi3RXWi3j9CZXXqXfyiisUXmtTyM04wa8XLKbu8boJ3OBGVEdu76dVYJM1MAZVnEYdfWthysfUQVny+HfIWZ9ohW+iu++xjxCT5BLUzDbsiGRjz31sAbNRr86CQsQNXhhknUKGUvb0mZA4N/KU85Tylacum6UhrjzHOk1vqZZrF4qh8uxAEMii94RQtr2FYEEKvWMETt1wjlQX+LOx72S1qRAKH58gfikBqyAIx8rkUNSfwKgVe1GzLOLReCPyHz3GcMAqxNN7QnnqNgZoxTB+GhZhlsueEEP2F+iLNRmUGorffp0oh32pJ06ec0Zki4Fkp+xxs/n0URwhTZP/1DG8WTPayszSgU0wjwka6I93TxPBKD98PorgAPpVCgKeFyeHdbrR1DdL51PTCnT8wY7zK9L68T+ago0/mFaT6++oEZ//D/g
 o3wnSKxb
 KwWxwH+vdsZ5jh8BcC3XngkNDteRpGPINrfkxJkHIGWjNCeYr6EdkeTTnYeZRf9+ADKlA478GGiRa7jX7BOAWisbNiDvbHoWLV8d5NDkjChWfi7JlQYn3kUERcKseIz9irPTsF7DFgEhltFokYaJDPokAZ5T3yuNeoPJDTgSImWehOu+Ym1OGFWNLbLOef1A4waeLMgJCmWT345iWoDsUiSbh18WVOcryt/ZUlyyeJ1y8KHSrQWyfiv1xa+kh1+8s9n7OsXOPf1oG5/KeG+ier6B3Kj/du46O5hjopUnyD5M/wGbPeouuaqK4378bZeaQ1WP5hI4c+tgQKNEzwpNvth+ZKcRX93fuHS5EdilMh99Rlps8mTsZJBVNldEyHcWxldR50ranhbbc+XxZDOr2J5XrYpeU/OLzBqA7yjCJ78cLIb9AlrHO/SB3ixTZwn3TcKzOE35EuHhCb3u3SkbGunEvKbjMliZ+oOJSxbewmtwPcV8T7vM7mYMin1SMsiwpwzJnDC2pQkm6XPjHait8rhFkZnR8N4Sxn7643Y74hSxVMfhVYvj9k9bvBLoPZtLiENuzzU73yjq8kKpFXZmJ5ZfXPnE7M8k25M9lhVNTxCKwijT6iI3eXHg5hjxuSL7kMoaO9dydRlGVOQ7ePeWC3F1k7frDNguYEVp4ds1oBY0eAKQwPeCR48pG0h+opQGXOt/yVEoRVzvseBxRJytcmGK+WyoWkG6v7PW6WHWIHpD14Sgd+CblFlaykE97A6fzpNByj+uxqBjz2reR+s0UARVaM6WIcJhNjobPLnB0E9Ot7kQLt0bAlcgFj2zLYtbu1Xjf/uvQMqfOAovpajzMTxwwksHHwWGjpyXHt2XoEd1POHW4oPxVUlLPYP4o+9aQTIHJ0MOe4QS9YKHS+jdD1fKQFGLPruO3ARf45/vG/WCKK2evPCAce2Acx4UDidAIoAEYTXSk+z9jeLKnL4WO2yGo3o6H
 bhi5UScC
 D22xm4jqnc5G2SvHoUhZr1osE2f1Gf7McxRuzHqY1aD7sn0iAHA8ghapya2PVBJ53JwVbhtKYJFt6x/qy/VhegqGLmkkNHtDmR9N4vWMMyGH1kRWx6mxLkJRGiKTtzJ+PcHD+rI2U6c4uf12WDQLl9y536oUtn+PvjpWDqmKlfS7jnf9C77AoJVV8cRiKpL2xXsGIIXiVsdzDOj+oC87AjBfYXI8PnTKpH1GyeA5T2fI8vU1MIPrhN9QNAxDHHAH8tY4i1egoieYBGsoOhoWObB1e++VWlYx7VXoR4RGa2apnOt55adhk2sP6gv7cw1sZqb5UAjbSmgR9IuYkLdxFFpg+1uk0RVeMD40aBr8mO/ZxP3AahbeS4cIjA4cj7QmfqkZ+Us9kQuDZyHwHpkJLxUOkYmrbYoDZgfCoDS/uFrPatMOoiogENlYfC/d5m6SQOUDP/BmlduFkfxKipDRemu882dgSkGCE2BVpnjfoSUTJ+QRxz5qCbZ0DjyIf3m9KDkZW6OCaAiT5GdBUuqe6T0QKJfUj/PsUfPWxDBmoJZGqq4sQyTHRI//5n7KCM6tJv/X+3cGlWwywltvSqkmJ1uQcW9NQ3oEsMglnRdtd/YGvn4ZuKXRpQ03wQv6YY1ykGi+m7fjyXIpGJcPzedf0tN3TZXDbw4lzeBrWyTsFp8AlwHjWsveQohs4/Ut4oFG4ZkZwrbmILyQbE60A5pMOoCHrhZlFqxAyuczt023gpcG05P6u12goBgiDvd9ltvX5VZ36I3c9RLgu3fxy+9l1g4EnwQeA1tqiHzo4vq53rnWOWKVFTdBekZbD4TxHK/531a+tdONw6lfF6WJo8du7FVnE1chGL/eW2RM2PUasx9oBgg3czYRjQ7ryZk1r/SfZSTkPpkgCgKVdlDDDANq/iRtQnSnbv7r5F/sqj/bx3/jv0ACWpVQD//Qvyg9BXZPFBmEsL0Oj+I/t2Gx+uuaa5+70V4O/
 Ls4FVjCJ
 KR7dFs9aY2AqQdfVxS7/SbVGx9QgOXkRX0HldwaSCZUnI5TpiVOlG69LmAV1dWFOG+3h46jktn+lKvP3j+O0xptz43iygtyI0Na2GyRyyFffn8VEjFgWlfY9CtSKmtwgIIoGMq6B+2zyFbRToxjAyF3yaI5nP1nvId/AXO+rHxhUvQ+Le42wXEsake0eeRgNneyitplxCiYx+aDmd1Wkf2GpJdm8jSS8OdgE9Qh6VTKnK1/op/2lRcMDzomR/4S5SD7B87/08ZCejN2e4qLH9+VlZw7SdYsC423/5Q/22nYnbYpQOWInHNT/esQPzC7Uo+uV7PHxWE5hgbm9gx62nn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are not MMIO pages so VMA_IO_BIT is an inappropriate flag to set.

Instead, set them VMA_MIXEDMAP_BIT as they are kernel mappings and this is
the appropriate flag to set for those.

This provides the semantics required - no VMA merging is permitted, but
does not prevent GUP.

However this has no meaningful impact as these are refcounted and thus can
be GUPed.

A previous commit already prevented __mm_populate() from being invoked on
XOL areas which prevents so that is no longer required.

Both VMAs set a VMA name, so always_dump_vma() returns true before
vma_dump_size() reaches its VMA_IO_BIT check, and thus there is no change
in core dump behaviour.

Change this for both the core xol_add_vma() function and the x86-specific
get_uprobe_trampoline() function.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/kernel/uprobes.c | 2 +-
 kernel/events/uprobes.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 65a2de82ecd2..0f60c0d076b6 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -715,7 +715,7 @@ static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsign
 
 	*new_mapping = true;
 	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
-				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_IO,
+				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_MIXEDMAP,
 				&tramp_mapping);
 }
 
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7709ea882477..b89cc5cee002 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1726,8 +1726,8 @@ static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 	}
 
 	vma = _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
-				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|VM_IO|
-				VM_SEALED_SYSMAP,
+				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|
+				VM_MIXEDMAP|VM_SEALED_SYSMAP,
 				&xol_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);

-- 
2.55.0


