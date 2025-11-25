Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C858BD0E6C2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF076B0023; Tue, 25 Nov 2025 05:44:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6E66B0024; Tue, 25 Nov 2025 05:44:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E616B008C; Tue, 25 Nov 2025 05:44:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1C9D6B0023
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:44:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 984F7BB8CC
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:44:53 +0000 (UTC)
X-FDA: 84148796466.30.E1EB9FB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7D14F12000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:44:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pni0UpLe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rSwNxQHW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pni0UpLe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rSwNxQHW;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764067491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9l+WKaVmYFmKkau1igqnO66HrPcwewgu+mf1wm0Emc=;
	b=rzIyW04EjqYqU6x3R3Eim+7zfSmW7ngDR4xlckbSlPR4UzB2k3KZ83E6vV2e1VMpOs2W4L
	7YkQbUbD1Xo64bS/kXc5BPTj60zE1JHc7kCkDuj2NlmmoN3BIalRz80W18M8+turUKm0mZ
	/396gtThUhCpUKE1+Ip36303SgI3QCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764067491; a=rsa-sha256;
	cv=none;
	b=znefQX+xA4LHiYRdfAgtthhaStGNTM+fqC8js5Iwh4Jj+IlUfvRC0s02whBW6nLG6EtlFM
	qglFH94FBgfDP7lxI6h7RLYuu0dBEU6+MuLK7cYrm3l+0bkyUafOnDVhpcPb0QLq3r63Nt
	twmIEjg8MkQlAWutBHbOnCc1F99M694=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pni0UpLe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rSwNxQHW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pni0UpLe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rSwNxQHW;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6CFE22039;
	Tue, 25 Nov 2025 10:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764067489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9l+WKaVmYFmKkau1igqnO66HrPcwewgu+mf1wm0Emc=;
	b=pni0UpLef8iQNq0HR9r64Wkp8Cq9nhFJJ4zY4si3AjLLD1EewTEDdsotaHHqgza0PC1Eht
	c59UdGvOVIXEJ8ICP353eEg4mnVtQ9pnq/vq6ZiLmUrHbl7ZJNJcG7B6YzsC/jYKncHYd8
	5Dyye8QA3b7fcKbB4uHDMS1daJOv7B0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764067489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9l+WKaVmYFmKkau1igqnO66HrPcwewgu+mf1wm0Emc=;
	b=rSwNxQHWMHZtAmf8vLv79+41k+m9B2qwlXUZvvTZ+h6jAUFZ5Eecdp6lt2uuaPZ0g6t1Ty
	GWHnUDb+Cli97oCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764067489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9l+WKaVmYFmKkau1igqnO66HrPcwewgu+mf1wm0Emc=;
	b=pni0UpLef8iQNq0HR9r64Wkp8Cq9nhFJJ4zY4si3AjLLD1EewTEDdsotaHHqgza0PC1Eht
	c59UdGvOVIXEJ8ICP353eEg4mnVtQ9pnq/vq6ZiLmUrHbl7ZJNJcG7B6YzsC/jYKncHYd8
	5Dyye8QA3b7fcKbB4uHDMS1daJOv7B0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764067489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9l+WKaVmYFmKkau1igqnO66HrPcwewgu+mf1wm0Emc=;
	b=rSwNxQHWMHZtAmf8vLv79+41k+m9B2qwlXUZvvTZ+h6jAUFZ5Eecdp6lt2uuaPZ0g6t1Ty
	GWHnUDb+Cli97oCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE7BA3EA63;
	Tue, 25 Nov 2025 10:44:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lbk1L52IJWmECwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 25 Nov 2025 10:44:45 +0000
Date: Tue, 25 Nov 2025 10:44:36 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3 2/4] mm: simplify and rename mm flags function for
 clarity
Message-ID: <wpvjnzaffij4thc7djcl6uhyoo6kegjsgplplv5cyagcgw2szj@vlbnxzs4xbrl>
References: <cover.1764064556.git.lorenzo.stoakes@oracle.com>
 <8f0bc556e1b90eca8ea5eba41f8d5d3f9cd7c98a.1764064557.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f0bc556e1b90eca8ea5eba41f8d5d3f9cd7c98a.1764064557.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: ezukst3jsa8dt9fkije6gesxd1dccymi
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D14F12000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1764067491-779591
X-HE-Meta: U2FsdGVkX19QuwHzTk0M+NM6SGYRiGEsP+r+EW1cyOHe9fW61YX7huigr9kPSUTaSJRHZrGl0KwcdTLr7qPbzekfz+d2TIx7FpB12/52933xw+fvMYCruhWfRQLHxfxPj2n054pms67JA3GmgaGGzNfRue2T+RezUX45i3ZTlv1MU4jdL4wAwH5pv+/fcpxh8Tiy8mX7p7Wog+FIobTxm8UXkTdUAbP7cuU86uYowvMWq8X2rW4YaU4Zmk8JHYJ7aaS9TnJyyHFa25wm0dfYGRgNS3CSjsgY0qDY+l5/x8B2W3WioCg8RC80g6m/qwRlrWonlfZEQVKnUCISHR1qYdDcuZliSJZelQ/KVkNnVDghfFZPqCdoTIKzK3n+y9oziQEzKxIsT57O581mlbGOhaq0iEnc6QaaBdbiabW0rF27kDIRkCHuw+t08ykhMdfUu3FfpHU1K9MswLdCe9WE6Fb428DT0SHPBp/SP7W/i8RTS3bD7FMZNvEeE+FpEKVWogFlyp84clmIlCVNt4Hcskjv0HTFSLm12GzX3W9pZDyGnbMhyCYX88gY0dA7cUa2NSe1pxmRhA+l/vrZN1gzVLbXqS3bvsJOdCZmdHcssxAqmzTPuEFq49cRQkVl9SzFgO6MtTdvmo/m4QixBSOjeoaI8ICHts/zYZBho0cky8J5y+mNZYk3dvciaMtxG8dg0/bdJykC5QZjyT9YIAK3frRrWA2kVOnmOYBcNwzELEi84a3Udv0W+xefztxbKOQ78OHV7sQGeLKATy/ppj+lYQ5vNWtQ9wx1pCkl4MO+zZQLeKagQsnhk6O3MaThmIBYkn8nrJ52oL61wrWlJUIzrIqq/8Ihq68iwji5PxwiPphpox1veU4ARlPyumHb4QruVB+rs/8zmbDUndb9gUs8xdfHxQ5YJ4f72K5l9H2UZaZBY59CHoisHKYg9C1rDWbijGVP1sHVnKVkJpAzWXH
 qKs/ZxvV
 SVPvBb8JIadSM50S0GY7RwoQTg2dsHeiuZz7gFYELt6B3jjK8MAfpdPJOvRk4AoXUyGmyHAJz9tv3KPayaviimEfQf8oV27oPSrjG6HQjJ71wiCQCZy+2rkw5r2wK5rzr6+EY8evDA6kJeCeUkTmC3qsvV9t+8XZ6b8/Z5ua1NWTWDV+iZDn5Vd7y/VHaTT8oYe6qo3XUk2iDf4JiS2MAJTf2Ud1Xt7b5J+feMGIpJDBb9qJLzzNDaG/QnZW0GGufpbunnQoOCMVQXnHDqsi0jB13HzFMogOochoqtEWHc3O43XUz9Bf7HMJFUH3Q0/kEmRU/bPpUq8CpW+edyuc54qH667+Os9j3MDgKQT/HmilVtrLDhyO1ZSDde9sHk1OSz5ewRRSaPGlCPm8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 10:01:00AM +0000, Lorenzo Stoakes wrote:
> The __mm_flags_set_word() function is slightly ambiguous - we use 'set' to
> refer to setting individual bits (such as in mm_flags_set()) but here we
> use it to refer to overwriting the value altogether.
> 
> Rename it to __mm_flags_overwrite_word() to eliminate this ambiguity.
>
                          write_word()?
> We additionally simplify the functions, eliminating unnecessary
> bitmap_xxx() operations (the compiler would have optimised these out but
> it's worth being as clear as we can be here).
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Anyway:
Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

