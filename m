Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70965C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5B86B00B0; Tue,  8 Sep 2026 16:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856A76B00B1; Tue,  8 Sep 2026 16:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1776B00B2; Tue,  8 Sep 2026 16:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF586B00B0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:09:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4616A0239
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:09:41 +0000 (UTC)
X-FDA: 85191685362.22.959F290
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E6E31C0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:09:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6dXD729ADCogJ3R/2wo51+NAzY7DqxT9oUL1eYTac8=;
	b=L3cTXMlqamUJPezIkDqkY5HHXi96I6o91/+XxsAcYbe+8JG/Xm3i7jT/4niQDVSOr/OoMv
	bouAKb5uQq6LxxqPhev7JEjBeXjP/Cgu2ZvR2Vfldu+3mRMpQ8qxmfnFoCGqdvglZz+bOe
	IxPqajlJsW3b27Hb+TcIy4sK6dslpqA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788898179;
	b=YO9eZO9y8ogKVeXJRa+PrjO6TLsY/oWHRpN0X8NiATHBQNO7jGTY8nCxQY58WwhpldU5DD
	MDa9T2OI7YBhWCss5A3zjZkD6ImTGG+0+0B2vhl8g+42dDwtDJDKqvn0CXaWhds9EGs1J1
	zgQbqiMpBOMGJ/TPODtP3I6oWUChOuc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0200A5124
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:09:38 +0000 (UTC)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACCEF80746
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:09:38 +0000 (UTC)
X-FDA: 85191685236.03.870F32F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F1CB214000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:09:36 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6dXD729ADCogJ3R/2wo51+NAzY7DqxT9oUL1eYTac8=;
	b=T9CuI6Xm/RMDtTFXDijBL0Raval6E9U/72Uj7vLrx1bSonnVHxcjlnLF33u3hQNE7JKUux
	W4RCVNG2COq/m9ZKMmS7NU1XTD5HTNx5lgWFRcADkY2nLDL7ksSf7bkCOWe7/fJdAnj9JA
	yxrAjp092fGj398sQusFeqLR5JVGa8g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bOh9qaVC;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898177;
	b=o1fyrrjeixunZxtli+FctMELXDbvHnBCR0NDEeOZWz/OLN0NYTZ9FYRuaabrZHL0LQOkGE
	ThnFYZgaYubnnIc365MgJ8PIQ1dfD0ygtkFpx3BwmlhpWAqelhUBP29Wtrm7R3pU7em7CI
	bB2qe4ZRaww8NxfUzb28WjJ1brQYjE8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B6A4601F9;
	Tue,  8 Sep 2026 20:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085C11F00A3A;
	Tue,  8 Sep 2026 20:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898176;
	bh=p6dXD729ADCogJ3R/2wo51+NAzY7DqxT9oUL1eYTac8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bOh9qaVCnrZTWRlq9PaX4TcWsfcuLV7Sk55MPnRysjd8DAKGgc5dbOGtlcX+R2Cct
	 etBvSqJ826/6aRGiGtQTdPbMl+HUHI65BgItFp7dB3nEU6+P4nEKEQuNokScxDAGQF
	 1FaBk52Dtsu0Sj4lK3UEIwxTGPy3xPZsEJhkMYRkKSFy9wGxZ8EyeXQaET+rodI8WW
	 O/YNIb3WpWuRKRCra6d2SyqzYF+1G2MDLogKznQgseOC4k+u/CpmskHe9Vw88IcYKe
	 RfnYBGrEddugW7tvStnErBL9GNi//B0nMtdD+kFUuBn48Nqiv9Gl8vTlzDJSrGw4yP
	 Z9voucWtUuFqg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:19 +0100
Subject: [PATCH 15/39] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if
 kernel-owned
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-15-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2245; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RGYbj2HHlqxNjIH/BiZsGGf9u4x+neMkFtHuPWWBclU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG6KibjG1FkTM+mYgfPWohkScT/Xb9Je2BYwaa8ks
 yHfY4OSjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkBg8jwwWjXZ+PPozePoEj
 91kM1/nIHiO2iOq9T7OszDhdPvc8Xcvw33PlsoVL3+0qfv9hsV1yu1KidJlsg/7GnOnrzLas9Ck
 5wA8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-HE-Meta: U2FsdGVkX1/mFfAF5BuLJa6p5zs+1A/ctgZ+Koz6zxyV67k3TlJ8EGb83unByccZh4f8cBA3LJRhVoU3308ZBAlUhwGdxQ4mRlC7CyX6vKAFM2OTW7QMliHcZDFiQsQrn60VvJX8oF6B6biO/eT7AtX0wBaovU7oru5jRoIsqkE/2hUjKmaIX+H/bxWJu9hqLx9PhhlOZvRMeEZx7BpUt1JogndSLpP47y+Y9HhoQiZlLwnlKA9o1fisxu3KRlG/iiUOZrU2TmfrExxXjMEslF/BOkrR9bvYwADGodYKdfTibIdIfrlfhLRJ58hmMYJXx4Qj4tYh2tvGoSIuEFJqk8rh9Nanm1Tv5nQQWOX/5jDEik+SakArpNV5b8HNqOjGQ6EMeTTZaBFTTdUSY7vOWZ6DoJldwuInf97ryjbDxIyiMJyGF5iFFDyUF/5Vxgvv5HZc3JX550ENo2OG9VzVRGNdIBns93wDBh09eSQQgS+6szGgtMs3/t9TyYoJak1A+MoxuMvhVDS6YHA+JOqzlJvaqUR/30LeN43LPp9G4YfHtS5OcfySjlK+cvcyB68YHlueoJIzO8a3bqDpvPVOfLczHiCEbsH1/WwtRk7LYHNJdqDpPnWkV1U/jfYquq85747chARbUw8kpX07BUUXdFCb5h0INbfssxI5BhwY+Xwv5Gi/JN1tpDQ0svfpkvKWA08d3WfYYY7ku1eZFsM1eRHBEyUOgrFwrmbB0mX0bxo1PvAEMmSux2ymrgfmyvmwljlaWpCt8+JtMYpsuw3B9Sr0sDoji4eNVKsGdiD46Wnp8Vz9W5O7tFNdLUIWv6Gz82MEgpw0vsNRAZ7+CtmjtGEDj3RbdJNPuuS1TUe9gg/2rnHfjU4BJ4R9RtMdDAD8zSJvweKBaMhofmWP9sBE7Z/EeXiy9OSJBhgDzMu3BKZrGMP4kjqQMNBMsD8W8wvazmvDcAMGwu0iHsBKmzu
 5HHZVWsc
 uWDUBHu0hFtoQBeQxYkZgW9x/2NnbRRGH67hIkSNhTU0A/0V6LS+shgwEW1K1GdpIEYTiNXCW3aUq5Y+YcY3BMOkl8Rj0flSu6G4Sfgm8VM7xQrQ6DIZvRI4UGN9c78P7oY/VKOU6anFxaal2hFYgahRY6bIhWPu4TTuF5aIoK8DTgmZ4TnksNMFOIVfzrHENXIHEVvLvevg88cfz6TZ7DX9qXpsRAzGmKggcXtWo3lINwngbBp6zSZb8zu87WEs3Z5/ufWyFOATVSw4CJ8wVVqi0nD4dSZpEivOM4EfVJ6aavDTSOw6vNCLU9CpxvLVaQZV05RUBrSLwusXidFoAFlb2LF5Ia/ZqFZi+ZH4AZuaQh3buANnlwogia4FFQKikUePQhj2NWZIZjeaBjqAtnSbzLjxJrYcnx4Ch6mT5No9DaLScn/PhDqJgtxLgBvQKHumMf1gVvP8+cWBcXZ1CEiLPWLXVXyD2aTbmH5+N0dxdBsKrF42MLT4S1lDlsTY6rdIV1N72dUUx0Zd+G/CWyVqUd3Y6QFfHkLEf0G3h0Yg7+/6zLh4ozFnxO5fOalWeLHKrN1aW89VkayPjeDCpn5S8bwXblOvKT/bWrORhlFzoDWnSGzBO8VG1I170ag4MU3RBvAuJ8rUkVeUC4RQpP/CIABH8/JUsJFf3R+KDzQFZw6xjxFn90B1TkjDmQUxGMJT3dY8dLhQzKIUNr62pGSGKgaXB5jHLbWiajsL0+YE5cnNYObFli7K8VKhX/T164JeGFrO2DZlfIXAjURBJ1OxbvL5gYZJ24d9g03Sgyh1AYThN8JnTppVpruHAuwMg7iNITHRrvZgLoj62Hl5ronUqvR1ixzKVDfQUD9YRoqlwHImnGLJICEwdUA3Z4f2PC2J5JI1UD6MakJcmbZF+tqSj2CC79LtEblWBbse+4iXmImGoLPQVPY7kc2tRDqdYJo4hWtfXBGSvg2pVbanGMn/GPYd8
 HELks/zA
 wZ1pOr0cnXGPKDWmLFJ0rs2gB5AgiLxhgLFAkIMXIG4P+gvNclqn6XGVIgCiYiVtzrMBYcBtgMy8bNyuMoG7mpgEbuhMa9NJ36JSQDfAsVnNkBCftpW4UU0cyQB9Q26q80qGiqBIxRU5PvlIp58ABVsayPRPA0Pz6agQs9tgkpmQTq5fC8XoOULNcattmv3q/vhpSmC5BIXb2/cgj+rvnmkEGezykdeD9pQgakSVzOUgVXvTBQzRaHp4gcWoB23fTX480Ed5JeoymNdnjBP5DsK3myays/xykf37h4MNAq2PS18ZhRuVxIWILLD0Xx6z99LFG77JQCUWZYjnaPnsEx7JsmyJVPm0ii47K+PaOoN+TxD46PuV1+0ozKiEfm2N0tjxHQNkeJrbxB9EEF+wnBLXTAPGVJ7GeaTaimfzCyP909FrAUizj/ydB72pT9CZMr+wtkJydw/AowUBEkOCIIk/N2rmO/k7pXILIvT5ZJ9JpEwRr0QxTQheNiZ0vg/2PTauNRyQgZEgPvwEppFkYwvohW3jHoDE5Y8mwJnEg2gV4cs3m+5cyxTuMy3t+oxremDHx3zsevXaocaGiGhp1SrInRjnAUz09KH5mSXrMc5heAmkJpqPPZwHfgwcXCBvSRKQSu70xRsoHuPXux8xqZmbYMqpKakUIKfDsj+aW+TCp6J96PNsiex0FWVFle2ogxO58mB4bB8touxBmXqqxr72u2oBCPoCaMlpM200bb6UKNiGUOBVJvyEu+83mnup5OLHL/a+xfMgjmpRh40YEdvOevSNp3mm32WuBUYw3+8HKWFxfN3Y7PlIhtJ3dxF0HBDgSmibkM1qLDaxKULXMlg1JRVUgCJWG5O28fHn/YjChQRAxWEMLEw1fsIafvqw9YJQr4JUHSkInE37dg7dPVvprlUCu6KerbxLSB0NVAc1HlaQ8MTSF1z6NSH90aF6cBc7UZcsg0fVK6Op+BH68fsNV4XtU
 8s5oVN/p
 yDGfR4IqsxWSd6FvByAXuJvOkcYufBruD+lVu3WRHwPKFDOjI52WLpwoezRtKiXwdusWmJE4hzoHCtuP+v99VHQs9fb+H/+aaB1wD/YqyLRtUq70kCxCjfv3NtNNDhkuL8OVsTDocJi1dpl9uoX6NAI+IwxAqMHaqoDastfCUFkv6IcYIIKRuzoa4ipknYGFCML2G84haPkySXtV/A2J3P6MBEyiloU9B4wsWdQv4QkMBQf5VY/blOLOVIMG3pe9qSPww9MyTLMnhwR6Xe3OaU5JvDEu63+7rRGvK9GsJCeJn+wKi++/WxDo4xYo/Jtal+C9oAr25qRAvfkXX2Sm4oTRWvXKymCgdu6yMOY64MA+NN1C0zlsIBO/yhOfsnz3EjLaJJMeKJzAN095INGBvpPK0Uu7Mrq68g6hCmMKS8BKXNQfd3te8vTMu35tAPNuMd/jSDxz8KwoWAe0XjMJ2OqCTjKY7jwOxe4JL8Mwd7O+1rOf0D/b5y/oDHVm9/cMQ/zPMwkWmWG1thhFmeHTfBgsKJ3oqpmZwKI654EG30WWQHj4jkU308HMnGdPNVYrwe6wtA+vYFhIP4t3NT1MCmwvXur6uY9tZ2DmcUQLAeLBN/++LLvI3dWx1Z2acqpmk8CP9p/XwrrZ2/WORFTDAGDX3u2QW55xlUS31/udfBW8ydG5JOfpi/9WiwFfqENDqjHcL+FzXV0Z23amXq0ijC+Cfr3aRFQoA8vAjGzJJGreJb364YbZSn/FgpH1XykeTDkPWuesAN+692THHFSWVcSD2MJSWN5ykLlzG2M1umQOtgY5tK/eeMRIcuMACbxxJrgVxyLp2nGbsQIvwUeilLuRhQA8jEDhsP7w+khmq8VJ2ZnHhSrWEXNz8OAsfCsHOpQ74Cy0X9roorO9upsjEAyJka94ik4uHEizqXJ7by/dVL7/CNkAdiR+Lr6tXFujUft4svJlMmeFHM80ypQkqIeq1BTLd
 CuiBGan/
 BMpMzFcyfOq7z/Bb6FvHc5JPv65dlKKB++5K1ukzGGLJVM9fdMYRA64XReftPhP2f52q+qTMhCdr8kBvupMR8Voc/YB4A9tZtDCmCLRQ4PvlEPa56bTAxUt0ABYzXXv0u1f7d+n5keGk2m+QWYDqZj/VkBYM/5pGL2S7m2t6qf7Nx0rRRjspBtQDMgZHD96AhyvLJrVbaKRof0CWDVPrtC29FJf/eJU8gf0HlrpxNMGpGHdxy9WnfFrlXjn73ZXv7Ahjw/PJz23bMkkJQYgw0IDzL9FsJMTXbicxKHdjGKrH78OfqwYjqEpyYBj7y1o4Jub7saeAKl6SAQ4DW+Luch
X-Stat-Signature: kwdaqwqmw5ocsoxcdngu1pffb3wab83k
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9E6E31C0004
X-Rspam-User: 
X-HE-Tag-Orig: 1788898176-764591
X-HE-Tag: 1788898179-201160
X-HE-Meta: U2FsdGVkX1+iie3buDttMxMGakod13h2Lr+8d0lVm3KCUALUmbzFjqqompBx38surSUgaGo9rbaIw6evgamGjI6VFRLTUS2Bnj/IB1rMsNiIFkW0/+uK84dlJ2P42Sr3W/slq65lCmmdf5et8sPJDHOq9Q9gc8Ob8uV75HPTbRRqFKNQb9gUBZAnuHJRrMyOQCfr9HGtdRK1PyWaWE5P39ASo4HW9B95MuoYpeQMYSJwpFAZhW7mj30VXFWlr9snPUVbEnzGboe1BlHZ1fzg2ERcgErXoMyRxgDxq8ep0NkMdro9wj4AZ2QAofJeT4Q/oTtQShi1AcbxtRWkIY/Sk3mqL8RIoSEIqtZEUEePdVo8YFTnCyZSeeKXO3Qw313lMB8waMsWhmxUFjxxJKfi8VrfX8hrbemwCx9b6t3Fp/xYylZoRRN5yIzHkjhaloSLWbcBcbBu1+nKCsLiNy9bXVC3vNGxnGANbiOqfn3KWHoEwnXTUHXunkKwBSSRmSkFN1l9hlvchoQL3orqDDuh9Ns6gpOOawtlL3uid7VdcLYqrAdfrs9kOqnygkQDis+ds1oSU981B0sPILnPCij8ha9iRQ0lc1gKa2owfSVwZqOBeRy1CXijOBiptPKZtubFHeqEvpI+wOm0wdk4D+S+kdEdFi32j6l8rvHKIm4qM1LgjccEyVglvHNYej84PF9Dy9KCCgdEcWEObyJJsyuW1Zzp68G2+P2bv3tdd0+vHI8CNPsjlY8HaEqfvd0bsA9uci7mZGXMlQ7ZS8GSOwT3gte9w+YXrMtqv9sZA8v6l0yY+dCbvKIEqyShrS4joshA0/QULIvFsJuqgSth/YXnl4t3QLp8KxO7vl5mS9nvXZuOGdDTt7hiLv/mxnXtvSHFMo9EumOvbRX4zReQ9T5qJ2bTWOy8lxv3acXpSykpb4FR9Ru3Z1lIZcPsJkoT96BtJPdw4YUbxY+ibV19X9J
 JryWxqsp
 qK33nnC0hDSKtFZ1iFqdT1h81r6hpF7T4MDW/FDuaG5+rh74u6Ic9lAz72JPnq4eGQzE9bcdGWtPTaO2jSkge/2dQckL93wccn7/6XLEnK5CBYI5Pucanfg+yUK5FQuPpIXf0sVCQU6iOaWoCMFa1kgNu9HRyuNt5A5dq2nZ+aluWF/53PC7URp2ioNzaEHrREQ1INbT8vHz8aZKH7WVTThKpBdpyiQ1a+VHKhkvfcqJVkqmA2JP2k/CAI1zw/Q0cT3UkVr7hv43Ux4/PBqsIHaFb1zPZ/yf9aLxoF8KujPf64p+ksDTCTRPxDhxU/LRfzA70adjf6NUyOosBkNY52x11H8ouF+ZIjEns8Tto1sZyM8jh8idRTfSTvbAad8cvEbFrt+41aqfeCMKBmMSVtqk5pMBbWSQRwXac8SuvBP6g14npvLvzu/MYzyq8rPZMwWPMLcY2qUit8sDgqbJmQS1dC8+/Gkz5AZAC62FGWj60Qw2uGYwiLV59V/d7wmlP5nS4/traq71/XJXpxFe2bpb0C+tBQ05/WBo3HOVhCTHC6fLVrnIwesnb8vW75khvQiI1U7DPzSM2zxMZseGPzxyJpbHN1Be4sFX1wkIrZZ+hnsnNT8Vdb+npqrHLKbtOq8helKNpOGrqCD9OwtsXQJiXzTkDG9i0pOoYwWhhgK+9x1z4BAXaOqXwp6yfFCQjqEmdEA3wzSmXparWwbGKBoAGgAi0mKxe1b8hHSPRZEIH2hgshxB3VJPSlh13F1A9zN7/C2IgzBrYXOCbIFoySwwiLYQQS96GCHRxUvkYX94hVIuflwWC82JaBUzP5sEiH/fomdNFlqLQ0nzxx3C4qe2QL8bAOX5YxFo56SNIZq2msj9jfolxMbPVmkEDkCMJjgBJdI3dFLETslNeGzx14NOd61+kSm5aa5SrRlYkosWun703AX3cAr7wQ9pnm8HeBl7WRhc9ZB3BAJwP0/UX5N2Yi7Dh
 41kZhohn
 RaJm0RwDl70wC5Af5/7fy7DXG6JPX+/qmUdSyRFE28mHJpKVPWkDWH1I/WDhxsgxQj2r7xQdOH3yh+V0zUOZyK80Nd8oufbKuR4X2LGsbooAAfODeXFR+Yl8pXVp4mYt074FT6DAyUnShxjnvkWzz8w4y+0+VBxWtKfZLwv4bQNeqYhSkqRSJG56E0Yux2PC6wF03CqmEBEc4NJWNuX6mx8OvRNzOqwPMmQBl75XkDj8I6NXdT4lGQ6TJM2gYWcArs88XdKlDDxgcWjMva1TvmtiOpA2/ypqZMSgkZUr16ACKgvEoPz4CyWRy4QQ8drdsCMUdX9Y0jj5pIGAEK7Pk+shEgi5WK4p9ada0S7kS+awgkLG+y1XyeO0qtYpQ10PiPbRQr7vyyXuM00p+htwUhTMMhZlZ4uhMi9ikesQHyMl25eaTJYm2XUZHa6+ZQOxh5y2pyQdC5N/wmeYU9TcRIWrJXXqx5kRafLHLv4YLuPa4hLmGlQcqrS/qcrZ78Oif1y8mHAXXVaQZaaHdcPMps8mWFnxHlKVTxyIlzzGMHGFtXCFzOGuayMrUz3m6wEOg2oQA9aRmThe4Pz5SiLh4kIEFFOZtsFvgeeW2aeWYeEADu0jB3bAo9aR4UhGHjjt9SmLdlnCZMBzRYbuPDD6g74fxjpklJj+cFCTnwkm+F8a/ifTszKK1uj5YirqKX1CqmWXsFpEL5WWwCJPddNu0WS98OAt0YL85eSp2jkXPM5YtoXwFrUjrX1HR4C1UL6NsvTjfv7BXfDv2Iq/Q5QONljkb82sYDb/WGUcE/8MUqiXb3sXLaDyWZzDtI/W/eRR8goQXwu0k9aSVQE0okovLrIdErVTJr51jtOYWe/2YWDJfKTa6H3gssRnW+oN8K3P0nOC/IFgEMhVaHce5RhD7bj5/jWCHQLtVNcO/Yqj519mR9z/m4ANBY2BhwtsEFR37FY+5CWOQDzdEBToX+D9e9M9uSgZs
 q1BYf9MK
 e0ERgFfc1cSJJwzeD86McO2qTy/5DP53zyGLo2r2USES2IQoaZa3B6px0wAg4ZmOoKYEjj++RXC+k+THVRpu1VVcFS/Hd42scC6vs0czjI+VkWf9Ithxy1E01EAx3a2IsNd7ax+Wga5+PPgO7bgJt2TNSh/YnC0j8vCLv0lYJxxfjpVoACq/QDfYk40K505i6gq00ccaIjKLvijgRuOjCsj7Iqf3KMqnx2XKqKRLH2yUsNlfcqA1chn10Uc30ze6pW8eAyV8MiOpSplifJLiMQaDS8oXQgu7DBIvD/nxJDp9wSd8rMyyJnE1kR1tXmSxKZu+2hBcCye2d8Qju8j797P55kDIGfAk4YcEuL9y3QObi/MLxaxfsenl0Ew6+7X/CulPJsWPrhx89bNFOnSjyzQg7lWv3p5oZMbiO1/7LllvPerDI2oKx6dBwE6pt8KA1kMAp3Jwzr/HKa4RYynSrrYHOGIdcbW3mhi4aQ2ivgEAR6mPHxTOFnQvw0fI2eofTSo2pI3Ho0oij90p2QiEJPUUPBCKi7tz61Cp+ZRpX7XIWjmrC0p4qcBGuXnEYfrvGIeznTRoQpw+Po3cISypQqQKnTp6CUVjPZkJSY1IWHvxQ5iLdqY+vyRa9/pWEn0D8vlqa3vtw7aivzHl7SZUqheNiMc2MWlF34WQ+f2L8YJRLbX//Glp3fKyc32Cv46RyhNfFP65BL8EsFBbRxi+6m72ZV5rcxK/VH6b50UNPHc/WSScVjP3PIU5q0ie2biqvaF+mPy8nKg4cnswAYf4bLrAsSu0LbPDrSUbpAJZ8/t1pq6uRUk4dOiANiKF2nkiPmeS8Fk6ISLqRuMREhi+E1hi6+HZ/7GdyPTnsjiIrR/eED4eVmk2NBCIJ8buomipxbF8ljcq4S7dDpT8WBoXfBlNdyqBdyOCEKeR5hP6PTm/oJO421BvGkVwvfy5zDbjuM2TO0KVrnY9l2qJFXG7YYMunLPl1
 B77K5Ugi
 MJmCJSWxrN4e0mgLt2ynaZ5wgIR98T1xuWtFJ2K4aUTvwtEdNFF01cT7KZlqx/nzkb9KXnGD196NeY/tkYS7FdL8g4CZ4D/H38FcojpB6NXzvAY51CBqYCLx1UHI6LAFZyt7p2axdqRJBYNE61iR3YHljMIZ9isq9dVd9IsYWxNzSa6O3rpo+O58RNhoYXThbt5kiWfOROrt1z0t+EP/oGc+ocA1hj6u90MjC+/qIZLYm15SFZ3Aal9P3FfTKXvu4nMkZrnuI/CDTGMCCgZkuSKdG7qc87qtAgkVRKqPfK6BNN5FGBMGptPEZbnqWQqhc0d35c86qrb/Q5cqo5eSQ3U7LBFnOJbmjSPOPKd6tjq+9pzZK2Hii/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
the underlying file is itself read-only.

This means that mprotect() cannot mark a shared mapping of a read-only file
as read/write, as doing so would violate the read only attribute, and
permit writes.

In general, we do not want file systems to be able to do this for
read/write files.

Doing so would violate fundamental user expectation of file attributes and
likely break userspace.

However, drivers pose a tricky problem here - the /dev/xxx file may be
read/write but provide access to a resource which is fundamentally
read-only.

Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.

To achieve both of these things, restrict this ability to kernel-owned
mappings as identified by vma_flags_is_kernel_owned().

This constrains this ability to drivers which own the mapping's contents,
whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
map themselves, and so define its semantics.

Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
across drivers, filesystems and bpf, establishes a kernel-owned mapping,
with usbmon and the ALSA PCM status page converted earlier in this series
to do so.

Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
disable MAP_PRIVATE-file-backed mapping CoW semantics.

This is perhaps not always intended, but we retain this capacity to
maintain existing behaviour.

As all drivers which clear VMA_MAYWRITE_BIT establish kernel-owned
mappings, no functional change is intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index 9e45fc83f74c..526428753218 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2780,6 +2780,11 @@ static int mmap_validate(unsigned long prev_start,
 	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
 		return -EINVAL;
 
+	/* Only kernel-owned mappings may clear VMA_MAYWRITE_BIT. */
+	if (!vma_flags_is_kernel_owned(curr_flags) &&
+	    WARN_ON_ONCE(was_maywrite && !is_maywrite))
+		return -EINVAL;
+
 	return mmap_validate_vma_flags(curr_flags);
 }
 

-- 
2.55.0



