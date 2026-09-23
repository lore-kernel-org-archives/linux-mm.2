Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B68F8C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FBAE6B008A; Wed, 23 Sep 2026 04:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985EE6B0092; Wed, 23 Sep 2026 04:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826316B0095; Wed, 23 Sep 2026 04:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47EB76B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:58:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CE2740715
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:58:00 +0000 (UTC)
X-FDA: 85244424720.02.8E4C123
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64032180002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:57:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XXowWt4z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790153878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEbllmgiFfsLRk0pKgzNXwTCI+1F1P5ofJi8LFNISns=;
	b=t7qEkTYuooRRQcaPgRVLu6BxFJ2x3F1er64gUauuI4LWmuBmcvNa8+MzfqlwK8TQnugGmm
	e3iBQ5cLDd087/VQEN/5rsXZlrNb+FbAJ+4cWS/RVlc41ZBm/osiFCpo6t8QdA1knn/Yqb
	cITAG53W4Ml3/7FaClmOkhhJj8dZ958=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XXowWt4z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790153878;
	b=WPbEbC4A4pKFCoIGDJcNdm5fq5jH5cshGSGxCnxJZ0wXE68pnxGfv+B7ZRwjk2bHKS9H2d
	l+/6OQ6cwKw4YcnU98sfIdTxqKUX89R7gXhmpUBPfB2vGdklHK+ZTSx32cJuuQZFWwCKfo
	rAGwamQf7S+EwJg6x8+68TMf4VqVC0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4AAE600AA;
	Wed, 23 Sep 2026 08:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D981F000FF;
	Wed, 23 Sep 2026 08:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153877;
	bh=zEbllmgiFfsLRk0pKgzNXwTCI+1F1P5ofJi8LFNISns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XXowWt4ziL/56y/Y94hdTEZbLLr97gz3vPYecgnU+2OLdzbRXNjVt79AFC23MY5tr
	 oTJY4tAIVUSxYNA273DbifXhFQN5PmgBpv0TsVokaKinyjXefw20slNXoVFuzwiHLS
	 F6ZYPX0Cqw7UBvBS+5fOLuIQVKaCqWPhvvdVx7EVb3HJaQ4wuHkk+WrSgfva1xzANX
	 bHdWs2TB7EVaJ4pr9L0v2ILwyY9eS00lIEN1Y7x7dNWVkC56JD9zi1iKd9QoWfdwqu
	 /X8/fzcyQTfJjStJTXhyCnJotJ5LbvBVoTP27bIDNCCQV90j0yhBvB6DJjUfHmgpLx
	 LQAT+4T8xfxRQ==
Date: Wed, 23 Sep 2026 09:57:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, 
	selinux@vger.kernel.org, linux-sound@vger.kernel.org, bpf@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev, Takashi Iwai <tiwai@suse.de>, 
	Emil Tsalapatis <emil@etsalapatis.com>
Subject: Re: [PATCH v3 00/40] mm: make VMA flag semantics explicit, eliminate
 VM_SPECIAL
Message-ID: <arOMefPN1gxMpyx8@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
X-Rspamd-Queue-Id: 64032180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9fjksrf1eupyjtsdn8oqwxfc8ptcsjux
X-HE-Tag: 1790153878-565421
X-HE-Meta: U2FsdGVkX1/FuRI8pCSvmLCCDWoeTdcEAHggbQ8vYwH+cXyf4ZyInblK6wB+CQK/C7NhXBsLf+OaJJmEB4oP2WHetzVCbeiQ1sENzXuT7i9Xd7BsgZ9Ir+gq++dnH07paao5G5zzIVN9X8FS6gia+j9yCo8NyA/0qY1rmUHF/mD6IL/g0ZkL47TR/jg4HP/luV0wCcWCI5/E+36ofSxZkTmeAFS8dApSv1MrQCWw3NwoQnbAJr5UzOCqp2INe7C+D6De6kSMaiv7XYJmVuDOvudhPAqhRXQGMhsP0zpijyfy80uBvCcZ8acGEUVeHSV7zx7u+LlF77WR74JWXmPtWANoKPBncqlPDkirbaOqHoWh/iYhbLHM1XNjduyW2cu8oSuRcHOIOEk/TEMhyfVtv7xq0pP8WR3G2ure8Y81kpfMv8IFcpxzgN6tbQlmFh4cMepjMsBnIdIG7oxzberDtNq8+VHLXXXbxF4ZI/gcMJGZRAmA0uszN02vXvnQySrNyW8I7HtmmndbSUZ8gofppXsv6DIVqLgI0PGE9BPLfR0U8bnQ4nnoBp0upsgrPZdrBeHdE7psZ34tTw58X3E36hzXlhUdjb2J/Yl/ckKx08mutQmK+kk7HuYxw7YhgFmR+zQ3YsfjtMe4kAmsYazvErFABYFTrr2wBhwCcG1IWfwMCFScMNXgktv+DgdgzL5ngydD/IaRlR0260qy8O4Wv7rIBXQhZlYcCslEw/A+1qhJ+f1oE5xFQn68fRicbHaDtdYka/n+qPzUxaU24c1f62qWNtcfHD0QaLY9P7NpQrAYVTXLmqJQ+CK5Mv69q8Jei9xG0urfB8g4WQZqGJf5gCtqHeiXBFKqaJ09p4wDax2NNyqygXi1hkPs8PGRuZ8A0bGRLeKyae7JBbvd1oSwGvAGJJjvQM202wqcACWda6a619Qk2dtLk3S94UhLi5vsH/87EgMCbCCkrkT14jS
 nqMCmrs+
 xITTK7adfXMGVmud05zTykD3R726m/UTyMezUFUoc3sypWng042q2XP4+fkW3csErtKPhO+5RjvMIbwfXs+ltnG52EfQ/c6irouyvheYk9nTLQqOoRSpPm8DxM8IL9Ap360UsbK1d6JItUWWMSuZRoCrRxlTECVM7PKiBWw9+6ESl26JFFzhy8dLkNNE2cpJUXx9HnohBGwdJzGMSnTvtsP0P6xpxrGBu/0xOAaaRWx4a16E3H8Q6DEtoekDS0xEmaHw66Ybh1frGnMN+Yehg2lB2/GzPbas0DkVXwcQJOqTK3rNO4p4juf/dcbXadQ3gSMcu9TKmQpqCT8yjG99O+vxDuACqnBwKd6QufDJWc4XXMarEoUxDfvHqM8Wx7h22YKgA6W4N/vlDagvXS9bKnyrOUUMOJ9k1UZhJsJriztfDbbGAxUTpTvfAuW1uyrARVnOBzpXZid+PvcpKv3HbiXD1bPzz2fRL1FlYQdV2c1JFaFfXbYyxu9xgYKXRRASCO2dPXKKD3rMZ04VxJFWGRdydlu/212u6FUP5In/fedJ9CrsE6GjhpeUGTdx+Dc0c1RoxvvwPIAkUwGEP0XyM8fEQiono8n6YTkh5thQzjW12o8bMv9W8LW7L6K7Ne7ajbZr4uhILMgTv8h6Sk9nA7IOLS4ldaD8Anl2uBEsyLsHROqueybA8nvYoAkm2IibxqRJNPxP/RjMVGOhokANZbWPnzpm+FvrAS4M7XAiHfAoqL9XSeG3HCWbx1HsWOxBJLsD6qCRTh6vIXg24iG6ZwqaVaRCnLjpEC+gqmUgCEm5taSruj3VjWyDcok9SfNY93620QYmztUm7F6vyMSvCLUw2Au9zXUnE6sk3MVRjxjVjtC/E29bW6aNB0agnIfq38f3tVPfI4DA9toyAgbMbJL6ICF4nO5HjQvuA6lkV4bqlbrWv0h6jldcstp8u/JytgMlhiPqQOx9HNgBYkWslMY68cjEZ
 15Okk/ec
 ISlWrIcDxvFX5EufWm1yZdsrZankLJ6chkR7v5XWAjsf0RtrDEbWz26p+TohtBo+Q+o9TkAwPO/DNnOcmTlybgsOSNW+XKo6ZaANu2J03XlxkpaLVfg4cQGK1r8twYiE8AWz9gG6CFSN6ydnDkQCwNpkDYSzxj5M1eK6hj8925QClxjBAs12e3IPS1E//Djf0Ee0iESa2sSPknwXJ8Y4ONqcHkWp7fQFl8f7eH2SxMgEjn1vgMSMAUL+qkpl+5dtuRuP2uepuKTk3YcqUqnUyBERk3zrnLspmCWIwuKN7Igj0FuIQz57i+bEm/76eLRdAy8cZntafjAaEBAxuTDcMrJNHmAPPMP9hnwtgQBq1IhffmiNsZbywuoi+OFMfKf6G/WvTXDXW7QI5ozMQ4bhJ8CpOFDOJ2MBGDxYJzHNzzV/V+hVZTvp+4yiVZngczTimHKiSgKlH3FrO5Kbwrs3MqEbmyUWF4XyTRP0VfFZp3TIYmeO/aRPbuILnr5TeGe4ISj833lsQFzoNdq9GrZCE5SjwHLXKbO1gIdqeQWCXK3HEWyn1FQjjNyvlMOGYmdwf2YxAPtHtlADkUsSbTF6end+Fca/Gp7/ZVxFMa0q+5FQnOwsKsP4NjrJf38UOUGI7UXIOlApj6OlDLd1YA/+LWGSnM4QgzwPdkkwIZXG/Woy4CwYonVwtOOnb4RnHZsBif/+eKMW4tI/Al3o9+9gMlEgdl6R4tHxXcsZUEW3CmgOyI3gmZ/+TzWP3fZ71izjp7oeDqEOsSTTmFG6PpUs9AASJLATuqPe4duNfdXKfj+QMRjAtmwj3Ba4DbxHZDpSUUIh22y/JVNpBi0jpkQcXuVxzYpNAYPBtfa47O7Ai29rqGWoTjor+JqZPTGKBD9yz+IOQziRhmvkiRq4+D+liDf+9IOdoN4FQHQuMjKRgJXpe6yWTmIF0mi/1tINaVOp9ZCjUjmHHrmB8hnhSzpQlwavX+Q3G
 B9O8gTil
 pzml5gyln0Up5u6a5FxDD0mAoJfiQo0xJf9hqZKBh8sbAbeS+2LV6SItzYtWKR8/kdq7QDyUxm98grMT2gn44iKYjDbAhg2hQ/7TB5bGfRME24IUzitCGxwC+Qnhz2kUfmmMg4egAJ9uAMFmytIU5TmLqu+DkU1jfJq7Op2nhassTdQ1wlQv86u5ksn4dE9FN6JbRZoJvJJMFPeUOuwO7/d+WNjfcjctKZv+zD4ijA3iW6L7hy0EBlS8MQt9lWnuH0+4bViqv3dqXxqY7V4eB4ECz9pjfWBiNvWarjHymNRMseEbGESkechBWK5GFseUaWElyYzjOqPB7qrwQVQZKgeJiI24JlnY28wvSB8qoWhHYbYLNff3zRhtosPl6zHf3G9aLVTbifUR5Ikrsth4cuDj8aY+SttWCr4GW+0hiW5TURCco2oa7b25MSw0sGNumghvAuQiUCvmOoT9eyaTWqPVJJLzNC25smXbsHMC1YR8Ns/xty/+peQqRjoIM8C4sWmW8EV1fOd6RWpKtSG4l2JlLg//32xYo1opxNa2uU5NIHaCxzHzhWPg+ommz5EKaPel6bmd3Ta6b4UV562Fzz1Iau0Tj5oGuGGqq9ijxXtqgfaSYdscO3c620qOadNELhUi01Xi/aNPOyMQaUwoilwOuDrWbdJvfia+isXc+ayYFrNVsFnEXSG4kcuKZFSJWfvMZVttIe/fj0WT3lCznI/y6X4Yb66AvnGOBZMFj7AaB7dOq/tJFod/J4k8k4GwedHxdQhyrPt0LiMF/DZvo+KT7+ARUOzCnCKg/X1Q/3NpJXcC9nml1EOlSnh5YfHrXHOVTURlv3lvT7VSQ2gwqK5jbtmbNy4gYXI+IxhoLhNl3gZCcEUmsam1Y+WOtumyrnN7dtKKv+nD7LGnW04ceeLHJ83zO7U3TjNFJs4EndSNSca4n9gk95ilDl81Hu9zHj4owevK4az65Pm+4D5/Tt9cS5Yo8
 uJkyPj29
 6r089ivbwTIlMz0iPkEUlDBVyu3G8YVHYpPI9e32jllt905J41BRXcKj4H4186mo6VXhOP2hHNpc0x7iP6r38gvn01UHXDQvdJ9wQm33hzKntEoFYXsZoGyYJBvjxdZqQnudOv9Sc8Nr70vOmKQu+s4WskKwiCW6lPrdnH662N77xNvbR2+gnVV3BLwnKBieQNQ78bpk0OT6aubzTOMy1+QNJxZhUdpn5NA90/hCkXI8ZjlsRhf++LvdijqmsI3RFcBkbFFLRrWpXWBMDQujSbAeuhy6H7pI1mGaXsIdszjTjJ9wcX+AHfW+7eX+WE3yKjKbD2/liz+AJ1MVwZ8YiMxNh/GoP7KAdKQgDBogn29N+z8edHIyDx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I know everybody is very busy but I'd appreciate if people could take the time
to have a look at this if possible!

I asked an LLM to look at review replies per week in mm (see below), and
clearly 7.3 is an insane cycle, which I understand.

(And dropping the THP M, remarkably, has not resulted in a drop in review
workload for me).

However, I'd also ask people to perhaps 'give a little back' to those who
are doing a lot of review also :) review can be thankless at the best of
times, but having your own work sit there unreviewed for weeks while you
are working so hard to review others' work is a little much.

Thanks!

┌───────────────────┬──────┬──────┬──────┬──────┬──────┬──────┬───────┐
│      person       │ 6.17 │ 6.18 │ 6.19 │ 7.0  │ 7.1  │ 7.2  │  7.3  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ David Hildenbrand │ 84.8 │ 70.8 │ 44.5 │ 74.7 │ 80.3 │ 85.7 │ 107.0 │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Lorenzo Stoakes   │ 50.9 │ 25.1 │ 16.0 │ 45.4 │ 35.2 │ 40.1 │ 52.1  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Mike Rapoport     │ 11.8 │ 17.7 │ 12.8 │ 17.8 │ 30.1 │ 21.0 │ 24.1  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Zi Yan            │ 17.3 │ 12.8 │ 15.0 │ 14.4 │ 10.2 │ 24.0 │ 28.7  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Vlastimil Babka   │ 15.6 │ 19.3 │ 12.5 │ 23.8 │ 17.8 │ 25.2 │ 14.7  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ SeongJae Park     │ 16.2 │ 7.7  │ 13.3 │ 23.4 │ 22.8 │ 17.0 │ 19.2  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Shakeel Butt      │ 13.0 │ 5.3  │ 11.7 │ 9.6  │ 7.2  │ 8.2  │ 14.5  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Harry Yoo         │ 10.6 │ 15.0 │ 11.7 │ 15.0 │ 10.9 │ 11.3 │ 6.8   │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Baolin Wang       │ 6.0  │ 3.0  │ 4.1  │ 7.1  │ 6.7  │ 6.4  │ 17.4  │
├───────────────────┼──────┼──────┼──────┼──────┼──────┼──────┼───────┤
│ Kiryl Shutsemau   │ 5.6  │ 3.3  │ 2.2  │ 3.0  │ 0.9  │ 2.9  │ 16.2  │
└───────────────────┴──────┴──────┴──────┴──────┴──────┴──────┴───────┘

