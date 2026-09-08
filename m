Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 868A2C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7E96B00A0; Tue,  8 Sep 2026 16:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869316B00A1; Tue,  8 Sep 2026 16:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730F56B00A2; Tue,  8 Sep 2026 16:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4653D6B00A0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:18:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C350C16077A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:18:13 +0000 (UTC)
X-FDA: 85191706866.29.4945247
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id EFEE580006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:18:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cTk/pVQq";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwVNipmsGeHH7kH0HTVwgKtcNjfCejEkzkDgwLIYh9c=;
	b=B7j9gwoGhiNMce//mcgW1NYmXFTKSzoGsppiRhhlUX4LA2H9VTNZrIjLcsIhvw6GKkJ4fH
	L32NYJrOM7ryOT36BGg4e7uPRbxdB36JUSe+CmnBDBj+FLdmxVjP9aOXeM6HtmDvvNmGd9
	1TP/hZZgtDzth2wh7fL+2wdFN/Hrhh0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cTk/pVQq";
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898692;
	b=xza/Bh9qVTHOzx1oOi4INoI/3eTNf7EID7cDMZijNLRf1+p8UFDMvgUp4GgqRJ1NX0hL9P
	QmHRjHxRvC+6CpWkid/ElpWA+iElFk1+gn90CBJXCZtaXSojorMclxJFLTHyl5Lscnbjwk
	ZZqhawRJfTBkt4Tm8u5f78qT9ek38S4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42B774347B;
	Tue,  8 Sep 2026 20:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1851F00A3E;
	Tue,  8 Sep 2026 20:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898691;
	bh=xwVNipmsGeHH7kH0HTVwgKtcNjfCejEkzkDgwLIYh9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cTk/pVQq+Ml50+8U3cKgvym6EXXSSbF8x0Wdv1pUdFwOO6GFrL7mk9u1HvQz1Y20m
	 PARjv7kY71o6rXe77MqZLVNpWEac18T3/NcY/r71wL58s4eZQS+NcEPIT1/PDaYEZa
	 e9EuH1Gt5PeOE5bE46z5N0qaGlgkhkuUAw2ig0ku8qPeYeumd5HiQ65cepVbU1LyoH
	 VghL4LpBjhYAUKLKseYX6BWRHlZ3VHomfq/DS4WULxl3auuBivacmjrzn959XdDr+o
	 qjM3a9Ii9IFxLHvU/uhnyztGSX4V6VC/hmJPP0efkOiN1f1DgAJfAbOGBdEhasO/jD
	 dVYe6jSH5Xwmg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:37 +0100
Subject: [PATCH 33/39] mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb
 explicitly tested
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-33-dacf19cce22b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2543; i=ljs@kernel.org;
 h=from:subject:message-id; bh=hmAMxzQfefvCCrwcVcCxiVfaMiTF+Pgb+sQCkeg4Kig=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG4rDL0wM1zo9r/ItAgHramdVwr1yv92T36ieSTxe
 OBa5hO+HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIVHNGhp9eGnpT9J/vfMjT
 2NrLniVqE7l67xoXNg7v+pVielpf5BkZ7k6sb3armz1Zld8keddu08CEbxvuLdXo9v16gb/FYd1
 1FgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EFEE580006
X-Stat-Signature: 6nmo6sro4qh7a8xqax5jpppchkyt9snj
X-Rspam-User: 
X-HE-Tag: 1788898691-323519
X-HE-Meta: U2FsdGVkX18YsiVbE8dTNnisQ6o36pu+Jq9j/Jg/JFTUhlUvPvp4LM4XvlOWYGc3KWadLrttW40K4bAtIunNNjv0O4+fNp3CmXQmZW0ccaqVp/15WZOElBX+wdYNv1gHbgDnDGYnIGzs8xCqdY0qm7DUMHghuy+omhfjp9p/g5GnHqRrA0itn0rw5DzzpugMj2UhV7Rd4FmQCjUboiwYwtYmMl4rUKznoShYEctv3uFsrkpCZr+iYLEjKDDX2tyjo18WzQVcLkIvdlT58M6PI+VtQ5bDgSaGGD8oJB9vchLEnfz+zYePNyRlulaPP/Erj1AfMmfQ37gYb5XTm+SsKPPrnfecT5oOUu8tWbT8YPu2EOKW7TA+LkQwAac/PAoWjTNz+79tBlUiwUDUsfaPbXDJBEbcKElmU+XRBU4VwVQ2cQgCqkZ/uq5pwpZOgJMZD1b9BJUW7wcRPC5eIYjCW9BWUC7vpEh+oSG2pbRLtg7iWr6VANCIF2E+ivzPb/smyMepkqK/9bs4CjyW6XWe6ND/O/MyorC4tRtU0U9iV7YMhp1HbFHKSY2wilaC25fXeSPwO5EoOqN/P2/ji2AXfFWWdqi8Kz9oOWN/YGB/ZEVx8+GzAiuTN6zndfcA+N0AQI9ZMjfKuhl1d63BoEIVFo8t0o2I935SmyMoYkdb8QGrPuTj58mXujPL+0UNH+F3cuOVS7z2G5iaMw3qehwS24DpYw4+DefD90X51RIxN0A3PQTV15kv8/2XtycsVB1uKX3BQg5ElAJ6Lq6JrWw+3Sh3cb95vVetAl9otsPYtzH0uua6+dEc0rpHv7DDreSKbhFNq/aBlXfCSKvCro0PfHjI/h/8HDAvGGk2tU1kA8zORD3LQ4jdzdb8spHFJ/sbDZKu/aNdzXn85TOml6swDImR5OqVe6VZ/zQcsEqa6n3RcK6jScKeAXonsQPTHF9NomHa+nhmLUCVHrvZ8bA
 LuBXoJgu
 AKt0TK/OqPBVCw83PleNlNvZF5rV5D1w/EZUmR8c2u7Ng0mmHG/uvu+k8znVHfvUDG5q7bcQLSfN9mP2AWYNTkC7HfIvIqstSvEUFG1hmKJREd8UpsP+d2UyqQ2no9twe72lTTRKA86YYy/PhnD1dxoTSWJGwLfWVZtzJJSGy8ls7cTvrARNB7GtXM4apeEX0W0IRcLuL1nSNLr9E2HSVGL+UjMvTlw0CX+NRz15fviBOU8BHqYEUuUv7ipzSXd4P4jnz3zAjoT7ryGkyUDn2qoDLDBYvjZrEvpnawZCNNtG5LnXAHySovp4bM8ynStlcIJ8RVgZC7ZPI2BD7vxBAIij2nxps0sDLX5bA7dMHDvgskDIIy8CSPuQQSg1Q458pVUA54c7dOGq19VgoD8svrDBlZC0NYN75efgfAzAUN8NmBsXM5xbXmiwz5GuyRdH6xSWqh//srMC0bK89KHusEXUCfc20fPuu+Fm60C/7b3GqpJtJYytJAxgYkzmlCnzp0CPFjHVh/JoH14FTewKecfr5INihdl3+FvdEOBnsOVJtqZaibA91DxdDc3X8Uv058Z4qL/0e2FceL3GY2E0KsB6CETtLxvv2HLOTegpesZNY4hHZAx7WtPkrGU4nY44tYUyoQM4j+TFFyhNqKJWeDvJZI8lHcqSlbNjybyY+FDTgXbvQcoeIfnc6V0WpOSeO8F60/fHPTnjcm34eyCtUQkTKapu4O+QAsQ01tU8MenymgyB55Wnet5f4LuExBZCBfnONjPsMYBcdnCbpE0G2tGqG3Unu8jBDSX4QC8oicDlHLIJ5qgFeiU9kmcDzW6OYvrV4AlXL7TNf5noYojYcbAI/9w50NN9zVR8DlxjlliItDzk/uAxi5ENpp7mxAE615cdY7DHra4csE7ctxYMlNIiKynCvIgEnyzex7sfndZphl5SPfXUIpQt1fmfVmUZ6U3MVieb0EBoZKLu6fvIOVoOslVeQ
 XhzbBA3a
 b2QgROpYtZXnsMMLkdnACVFNxGNZo9VLj4N6DFCVgCAM3sFm4j/9IRc8UjDr4OO7Ar3L1Lnptvt3qhtjvH/fsJ3U9tKFjys+d7NklZZjjjIovT1hZp8vYLItVtgshtncSxJ72a3C7B5cwPJALszqVv/OlN/zKWipVxkeBPjzJ589CWHmG3yV5hOESdb1nZrWoh5LZB37WHFJYljenacMz0wcLvvPtzwPrTIe/dDCOdtWHA6wZ1GBL5dlM7Tx3dHKTTfJ58cYiidYYZ7k32AYov9N9RRRN3tGCdK/SPawGAuYKMWrQUYf0pIptMbIm/DUbAIK/nqr9AByZug9Q6wkBWcybv2a13ENhxhdbOzHJ4XE/zan12WLoKVqGAxN7kj9iHce5BW9XUd/3d3RSb69J7dJhq3hZFso5OIMUUoOzcdP4tiaiQIAZtepWOXqX7fZtFqm1CUL18NE+Ej1VvMFusaJxGAvfv4sX7WI4jKXPbt09bKoZzx657HFVyrmvbH1gbtwMdjANIiZnhO/ppzurnCbKMMLeUjzoG+hlezbN3Cz7qg8H0zOe0yFAUVl6CA5JfSa8fCfceZ9/WxS8rC5f4fwS0HGF7jjYd6TB8MSEsXBw5YBh7qobrB9yFlZGKe9RpZ1SRjvpl+qXKuC2p0M7kInj0fobFccRci7oKzUzkaL0luCp8wq+EIB5Onu5oiPWxYol+wf+Zqa4JhgKLZIc0y96MxNUuq/5T+S8oXEkopkQJ/LDAtk/QW8H2pbUjnfjteOB72kFDNg7oV1H1usYD7ttoRQM6s88AcgcrvptB5z085knwH9MaW6coJ5LA5JeIfm4r8qe+0zwPsf3CFi4Gf+q3sz+xkY723a082iFn2owxvXH7R0GWTY9l8F8EatgkGNpK39wHVKNhDDN8nYQ2/HgSp/+N+Vfa2EYjG85Lk/L1RuuYNxWdoRrYc9BkBSeD9350PZ1kkoXKmyjXb0T3TSAKPns
 TnScg8GJ
 cE6XE43OSriRLMULNN+h/rrPK3leoFGgsrlBGluyINX2GXzeff7GjDuhbzcNz5Qg7mUAiHf+8diIfpjZItPhD94aff/YC0UrhZTXmG0Lt1C3bhYOJg8eVGZpWWKn8ukAzIsGSz4z+oScEQFwHmVATbePIBuZcwQ/NdoIFIr7a0uiopViLGR0WuMp6j4BGHPe28GEYAgJg0i0jWau5gVVX+dcBn/uLzrhFor8LuXVUXicjY6VpVAVc2DC+IabWfhmTvbEu/g/BFA/yFH/Ij9q9dUOuQaMtavGAu6q/vo24UTb/+P6NlJiq6xu+qCu+p3O8K7SGv0dwzb9cTQGq8h6tjyT8v3BwEjkO5QBZ2BM2Z/3XdgZrfn6Tm9U7BtyjOZ1IfLFtC/L0bdBbRlHWJEamXjpcdPywiyDGiXDz+zL6+jHZg0Y6hXKUalOk6oiQe3Ys+onKkn7MLz8j4bntgXItT9OlghwhwmsecbRe/Lh41exEUC+IQLnTFK1AGMcjTLGdrxxTN8rPRv4aXnYCbi0qGDI+mcjAFVNPbyBPWzcX7zhOi2d86v9OzFufsTZDvk5McF+lFLuWz8+hTsrjrYLmeXQfghE5okOkPhNW4c5TVxpPKpT/usoicfWq1Gzat4k1a8jvOdbkbYmvTWbmAZg2R5qkYlpzA/+7TCWJW7Epd6fdpb59YC28aeUBdL88dMjIp92e+VWAhDUWpK/5S8VDXNxbD+wPk2v5hAWYR5WpBzr5XGvoEK7hm5pzWK0uzZky+GYcImk3X6RYUoJsesoRBxiIBrEIIkzsWefddJ0DZOycRWeTK6kTKQQqjDYnW+S0e8ConFpcQCi+q6p39WpwnusTwg/cj7mb5qhq90+G4ZeqbMdLIpodZmFQVrffBkzuGS1Qbp4Aie3qTZQUJcq4AST4K7IEGoPBz4tmYliY+D8K1pLOuNR4qgMeLakJNIHEI4QHObarQSCFezFWdT4uh+RxKTaD
 4RNG5x7b
 vMFzXmBzrQOCx7WaXQrrCyeYVH+uC9yqzL5ZGN3QZUay/GFFPZkYrBS6ZAPZYnDD4qmQBaHLEkBQMw4QQWc/A8JCX1bvSH2Tl/R+F2gd/oucGF7nzFnkUS80/vCe6AUr/puJeAevrcHTac0CiGgwlWg1dz2xU96cvjot/0iybxb1qHdPk1PcjCCalnj1JpBkbGkPkU5mNAkZVJsoqJhsM0Vt84HQZwSVG8VI8PaMtzMGmojPK7EDOVpo6TOQIzuCtT6KqSQvcJ8AuBC4E91IcwHs8Tb/0IuYRhfPWLK9mOXZ9ojJzifyEU8DhnYPcKCBBj6/84rdzpcAslx94quRh7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is now an invariant that VMA_IO_BIT is not set except by kernel-owned
mappings, so each existing VMA_SPECIAL_FLAGS test need only test for
VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.

This is precisely a test for a kernel-owned or fixed mapping.

Update a number of callsites which already explicitly handle hugetlb
mappings.

vma_supports_mlock() and ksm_compatible() also explicitly bail on droppable
mappings - detecting kernel-owned, fixed or droppable mappings is handled
by vma_is_persistent(), so in these cases use this predicate.

should_skip_vma() tests for locked, kernel-owned or fixed memory (having
already excluded hugetlb mappings) so simply test for those there.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 4 +---
 mm/ksm.c      | 4 +---
 mm/vmscan.c   | 3 ++-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 104bbca1eb57..6c004037913b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1112,9 +1112,7 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
-		return false;
-	if (vma_test_single_mask(vma, VMA_DROPPABLE))
+	if (!vma_is_persistent(vma))
 		return false;
 	if (vma_is_dax(vma) || vma_is_hugetlb(vma))
 		return false;
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..f80372bfd4b2 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -747,9 +747,7 @@ static bool ksm_compatible(const struct file *file, vma_flags_t vma_flags)
 	if (vma_flags_test_any(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT,
 			       VMA_HUGETLB_BIT))
 		return false;
-	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
-		return false;
-	if (vma_flags_test_any_mask(&vma_flags, VMA_SPECIAL_FLAGS))
+	if (!vma_flags_is_persistent(&vma_flags))
 		return false;
 	if (file_is_dax(file))
 		return false;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9cbfb90b0ad1..803754caf4fa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3419,7 +3419,8 @@ static int should_skip_vma(unsigned long start, unsigned long end, struct mm_wal
 	if (!vma_has_recency(vma))
 		return true;
 
-	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
+	if (vma_test(vma, VMA_LOCKED_BIT) || vma_is_kernel_owned(vma) ||
+	    vma_is_fixed_mapping(vma))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))

-- 
2.55.0


