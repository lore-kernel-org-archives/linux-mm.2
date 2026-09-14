Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB1AC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1E56B00C0; Mon, 14 Sep 2026 11:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91EA6B00C1; Mon, 14 Sep 2026 11:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B246B00C2; Mon, 14 Sep 2026 11:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED846B00C0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:07:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FA6840191
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:07:20 +0000 (UTC)
X-FDA: 85212696240.12.9487C75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 70B5940013
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:07:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JP4elXwi;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXoP7KZkJndcQGjeTZtASZtk39J3Stk4EQblO5zGMq8=;
	b=svd2sM0iFRm0QEMXThlkczbbp4nF+k/sXIxHnuUcDwg2Q94EDdTmoVkLBK9206eyg/Idcq
	I/c369Per4CER3xDMTTLr03+djmCVthAmB2O7nfwHNUHFTSe+us3UL5purOIotT+UBleMO
	ds+SaAPM99+Bqt1Lkch3snj8AnW7DTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398438;
	b=3ijQ3ymRLgc1gJT4Bcjj3E63zK90qvlQBBhtHXELuz5mjjRZG4WBm2pQGSYH5GNgdfP27Y
	nUtnAwoV2cos924xjVEU14P72NATjbP3J90eEWSze4qJz+wOJPtd769lO3oAaNqzyCSfkA
	q1yWvXFjTrO9tmY6gM/BwSQ3lubfjRE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JP4elXwi;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 038F260142;
	Mon, 14 Sep 2026 15:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900991F00893;
	Mon, 14 Sep 2026 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398437;
	bh=uXoP7KZkJndcQGjeTZtASZtk39J3Stk4EQblO5zGMq8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JP4elXwiAFA0FtwbVJkNWUu4T0Hzo9hzF4qxtFcaZGI2BYyYdJ7emz+yKFI5FfxNH
	 0cT3grCiQLAEsYrA9SpcqTxYQH9Q4a3S72QM2jhXwMERUNnVU4TEqv7+ODjKLX1vRo
	 yt78e2/7GRJ18TnOwJcTwkytfEF13UQDVzvzQUo0m7DDBUxxiQTcXZzEtoEHTnuzx8
	 OIXXD+w5mukAKrvguVJb40RZkdv9UXSob5Khh05J4FZEOaDaVTPsjUeprqvPXGLHih
	 dcrtIQoFwJbxwgqJG2d7R7GWAZRzLeleOwml/wW15s5ZmWirPRc81EXEt9jwEys+BS
	 HH5yA6sYVVYZw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 14 Sep 2026 15:57:37 +0100
Subject: [PATCH v2 17/40] mm/vma: add and use vma_[flags]_is_fixed_mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-17-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
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
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
 Xu Xin <xu.xin@linux.dev>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5182; i=ljs@kernel.org;
 h=from:subject:message-id; bh=UgNv55sIQWtamT8dsOv1+a458wZvL5aAIbvGVpSsXcA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJWcG/4ss6jauPjR1W3XHfeXDyzsi1zaUK7y6omzwY7x
 qXCcx8Jd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiAS8YGfb3Fi4wvSL9oEAl
 8Et56Paz2xear5/+in/Xl63mtz7IftvOyHDp3AxndUfDwss2HXXlTUw72UUPcK+63vts4rzEy3J
 /ynkB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: uokqs5pnrqobwm3nqdsarq9a3ef7auxh
X-Rspam-User: 
X-Rspamd-Queue-Id: 70B5940013
X-Rspamd-Server: rspam03
X-HE-Tag: 1789398438-803314
X-HE-Meta: U2FsdGVkX1/NsJL57qE/vJHIqSP0stc+TCjbZKKAmWUUeV1mDx87kmPL5GsS/pz5HBANRRjI2sJhw7KKfQqNFUhTJ6Puj9jipxr0DDoGgUwyxuRes5EKI7IqtyfndtTnGQ14GCUa4pXxi53K3nzTRqfexZhEjerwzFT/KPxGQPFVE7D7UCEBv7L1AxLwH0IqwmfnXQmjnVAS4E+y/TfDN86Df7upFh14Z5XRrOCcy/PIXcoc9pVOIlYEaJvf6oH6rF9w5UdZtZS591w7+NdmX+GbTeAd9CAaHiWEtkpihFL76tNhUn89lDTOlipZNfU4T4He90yxzF3iMOFY3Xl0mJY847ZAD+tZLp7S4SA08CdAYL5cXSv3ag6SOuOcXpJiR+mRvo2JW/8GRE6XXXpp+2/E69vl2NNdjw5pZeM/MnzfB0pbh1hu1kn9HyE9+dyk8SapFaXt6jjmafiX316GhmMKfgeVHePQ9vP8cVtRpPZ6NZxBWlHY0tLU+gmHcb28S4vO4ctv2rRAwcka1T+xRFyCAKhioenWeuloEJe/Oz2K7wmOwH3309vmHeAiT4/zjTbJh3Gl3SXPCLkYSarDYSgDv6YHOyH7tTmT/DtiC6hGZ3Mq4fNdOMEc+6/OsRJJPWsvMNSKg+QXBrn0xqiugqXu+zbN3sgKu6AnaKMKWJKMQTf+pGQyNzU9FCUzDZSheeiJ+MW2nIvYKq+0GZ1LiZwYHlzrFvV3OLCKaWIt0Vyv9arLXX3rKxgRE/mZFoKNbDcG9sWkIs+c6EEYcfpVwb5aCpd6dhqAM654wqggV5PBowR1PZ740yABliYNV7kFURAoulEow/2Vp/9EFmbfoELrakoSPJdwNAe11frzSA7hi60oAMY6jjR0RGGDTGhl1q05gdmOLjKbzooC7s2ZwJkZxVourM2Nwv9Ae8oFN1Midm0hmVk7RZMN3ra2WppQtKOC6+u4qMRCnqq3iDj
 fK12gZoM
 dotcoPaW/j8uQclxXLS599Ncn2mmxiKKBR23nQ0RM0Cqnw8zVSQcnfP7G/4gR93pZM6SBWtDqVApRbbHX/XG8FNoDXJq0e9FntmGNwawJQFLFEqJzvVCxx08jIUr6ZO+oh1uDhsUmOC1Dind0bDj/EEZrmOlx9MnPup21OhTcKvH/APJzlKoUYzJDgg1UzZ/9y5fI+m8cFzhbOT6du+urLu2uewWHBdhHD9K4avNYGdPkmYmsZAsycgBDgSMZoZNVH5yYNBEaEXlSq8p0mz8BCfgfWM5/xYk2z/kQxKBf1Pckk1e5HMixNVO8yuxC8py15gibmYzg037NB3cQQpMqJoXiRGY63EwLREzWNrWv3SByR7SuKjDTUsJVvnUQihObpmxJBh24hokbSb3++t2Hmu7CekRnoRRhYGlbkWFkwXSSKEXid3oGzNsxsnCj+QNG3r+ySJ6IN5FYsWEI/+t4FIzr+ohUdYjg2MMbWyoLZeMjO39g0N2nkFY+v671vZGYTc/IpTd0l3k/gu8PZrTaekwtQuSMOz+XSK1ZOTF0IejYViy0Fyj9AAbWXTeF92SvyqK0lt0XTW6hb+mM3undFSjOeDvgKnQ7OpGkMorzU86C/SZ/CiPdC4qytr6el9p2H9L3tMUiiGMSJic7nAmeRVI0WL4ulLJDZJQZV5E4IQ7U1WjTxneR/U1Tt/WCjepJTHwLjsPaIiiqRguQsQHqQECGWQLQf02ZcENqHvIKG7cZGdpmhdF8jhF+dvGMsMrpCMdGcspVZzlcuVyA9oncHGjR4+KSYrSmFLuDDP2Ky7I0BWaAZf8A/RjsDEhwFVAbX3n7pBjkDtPdzUgkHA3/k9ABLKCQ0ZM58D10QWbVRq9oC92r/T3iRY2F/UW/X79mqq2X7EsABuIk0wwud4Jtn5H3o/q7T+/DDIVVdyZIx59o97gJHOpdNjXkE+hHUDUYYRDI3vybFyWVx8rAwHyCfAyMQtrX
 XHPLy0FQ
 f3SMQB5BmYQXkj/O5HrbclbZWd39+UFPCH7c9WamCoKiZWNjuTYYiCkobYSFRnK+0g0LfP14JbF+TS+H+2XwANGtBt0evyxElVpcj+Y1a3OU+rIdel1+OY+0XhT3UTG6kfRUGmTZ5Ya2Y21qWnxQjWslxQIMQXsF2/w7x8QfEJedxzJPBZi0TFlDE4svkLLOzTwCIW7jojca6PP5VdZvF9q4wuPZxP4mUxkIrbYy8g17zVPoCBIALhYX1mBIJ2Ho25Zq6m/6VxG8+ai2G1taovmsv00eILT5woKnGYY55RQ1Vg6GDgTeILbqcLQWCyqGtdGdLYn/IwpcsfsLS7yVM0htCZtxFAhJpyR6k9N1zxOILSGWh5KKbxg2qQHXswtaqMqJDYuIbTRSBCQD71tAeTAobYnJ/pmkmTPqd0QRfj7V9MfbnXIQO2HLc2GHPskSZZWkTUw4LTZOfrF7w2ywDaLai+sZDOQUv9lSli9bCtuiyh2yXOkPD2+bXvtzQdU0zB6KOqBpA5w9K7dmAFsg/WhIzQsWxCAajynIfC2E6RUubu9O5eYdIvns6Mz0zSb90Kf7zGgf14crKjPYgwkIYw6gDe0WDWwYgFu5YStUG+Q3cW9r2lF82OFH8Q24RgenXWdW4jNy4jJSelJNgJCdyzpZfeG8sL4oslvcGINdXHnOUV3ddhTXRU+r6L/w+aoeruj0Ts04qUX59dPQ1yOzjMLbvulqTHCgB62SYuk69XIJnZyt/I8EQIxJmvoIU/Vx1zbVu1UBVt2E81KKBkak20DhjSQbp0i+BqEvn4USrfbZ5TM3GGRFC5+CxwMwi9NVxj8hNsV6B/h/flbnlXgJR1Eu1bHuUHfuttCbESTcuJp5iMsh1VWSa1Nkpe+yUHsrJF2pyIzGHIiP9runPE65vRLKEUt0qzMePPzRY6Jt+rWt21XBHFazKvtsBChKnn/Yt6g1betsdEdvKU1MT0QPMRDXxwjwp
 LIB1UJBS
 1f/kh7PloiPhR360ZPIfXwzN7vp56ZN39QaahHjdvu4sD1j9SEH3Mulo/kA/R+u3Bi3tt37kdut8YZs2x62Hpf6Ffr19pB+I9nXCEnqCeicWiKRoKE53XDQketbzNKoLla+B8b0lEknYjOhC+U4H9Ym27fFn7YDJtKsDnuxovo/bFgg5xCQaLH+JKMrUj+7QncKMe1k2yIraeKqDFCzItxsIDf6RaGWSaM34SicO3w2Ua9vwwzgK6ZqvoaBBNQN9znpCAShYdeNh/aVhdqQM6H/CUU9PAuaXJ6xeRjqiGUpG1oZfVDLRNNp7+kBZ6lO+BDqgrkAmu6lhdf40Khdhy/NPpicuyocebxsG6uLc4vYrCowiNCU3Rv/QkLVay8vS3XxmAC7pcUy4hRyvwiz968U031G2e1l4o8MztkbOsefTgt9r4ryBjWVnXG+rpV+3B+9hdTzJAcu1DaptbRLsldycOflEVa1Bcl05b/IrQeYTPHSZ9i1/onlhnq6tWKs3YkZxgVk/VGcyePoSQaxUe+Htf2rUNlkCMjPYfDvESQ3U8/Br9Dl7pXP9MyeZHcuJvMKEEpiaCY3pztaXZN93ETdirDG00OIOmI7C1z7W8lEct+UXzbUDAh90/iTkuHN9srq2SeHY93kFMJJzDyvn+P65uDoRkJ6NQaQeYWQf1Yl7rcD/nB81et8TNW8JDyP+Z0vr3SP+ssMI9O8uuFy1R7RcXn2UgE1XcIoJ+2fc0NGPXTQhCEi7PyryPV57pj0Z5EY//iSZMrzVVxozXWsUNfS0mGK9BgXqx/pDaZV1uoaA1jR0arslxSjhjwJxuVqpOcN8o8luz/N9PyCgj+Qyg+jf80w7SOlJGDylnKqBxxftsjgnhn1EhEoHl/Y2RGNvtxjYy40bDrCbMZOObEQwaAxWOcD2XCerdfqhdH+0cHLSczoHOV64nRnu6ORwORiHqnX+uiE0A7H3WHpJ+cs6YnIRsEMoS
 114cv4IK
 fhzBTiAnP8oVzIvFeoP74OOnxK8lfjoiEkypaQG8a8xEX9fx/IANJyhH2R1P6ufsoSQVZNsOUXpgHTXr6z1ZpDK8l2K9hPOvVLs5NPQSRPR27v7unwfntNv5K+FFUPbhVKa+4+cqdYwaudxdXFZ3vYBep3KiwlwDeBIlOuIH695qYl9LbfH3B/PK+oVnMyElHFx4p6vMj7JDCHJChwETzui7M6HfQFTVR1BCLIQd49gZCuMIWngdZKkgvhumfYHbDFn8q65TXPsJmgMCfw/Q+V57rHxIhS03Xr0VtAlBpOdr/HsFwpGMBWhFixIPvpxEnZUuvmcWoyLYBOJIZ6tGCeU6u+CG+IU8RtYFGVolOCDT6TlY0m9DGIHtrUtgUSpXcHqK83LrKbe9sqw4RoMkZKEgdszND0rcsBoEFc5MTe0pVwcJAWd/pfVUMjSq6K91lzJPAhD20o+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This determines whether a VMA cannot be expanded or merged because what
they mapped was determined to be a set size at mmap time.

This typically refers to kernel-owned mappings, however VMA_DONTEXPAND_BIT
is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
must explicitly test for this for now.

We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not be
set for VMA_PFNMAP_BIT's despite the one implying the other.

Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
mremap logic testing to see if mremap() can expand the VMA. The criteria
for khugepaged and MADV_COLLAPSE eligibility in
__thp_vma_allowable_orders() are precisely those for mergeability, so use
vma_can_merge() there (with an expanded comment).

This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.

Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
VMA_DONTEXPAND_BIT.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 39 +++++++++++++++++++++++++++++++++++----
 mm/huge_memory.c   | 11 +++++++----
 mm/mremap.c        |  5 ++---
 3 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cab29d6e15c1..ca598e5f9715 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -600,9 +600,6 @@ enum {
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
-/* This mask prevents VMA from being scanned with khugepaged */
-#define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
-
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
@@ -1650,6 +1647,40 @@ static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
 	return vma_flags_is_kernel_owned(&vma->flags);
 }
 
+/**
+ * vma_flags_is_fixed_mapping() - Do the specified VMA flags indicate that this
+ * is a fixed mapping that cannot be expanded or merged?
+ * @flags: The VMA flags to test.
+ *
+ * Fixed mappings are those whose size is set at the point of mmap (for
+ * instance, a kernel-owned mapping of a fixed range of memory), and thus
+ * cannot be expanded or merged.
+ *
+ * Returns: true if the flags indicate a fixed mapping.
+ */
+static inline bool vma_flags_is_fixed_mapping(const vma_flags_t *flags)
+{
+	/*
+	 * VMA_PFNMAP_BIT should imply VMA_DONTEXPAND_BIT, but some callers set
+	 * only the former.
+	 */
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT);
+}
+
+/**
+ * vma_is_fixed_mapping() - Is this VMA a fixed mapping that cannot be
+ * expanded or merged?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_fixed_mapping() for a description of this property.
+ *
+ * Returns: true if the VMA maps a fixed mapping.
+ */
+static inline bool vma_is_fixed_mapping(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_fixed_mapping(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1671,7 +1702,7 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	if (vma_flags_is_kernel_owned(flags))
 		return false;
 	/* VMA explicitly marked as being unmergeable. */
-	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+	if (vma_flags_is_fixed_mapping(flags))
 		return false;
 
 	return true;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4cd917f77f3f..4d0acd9a1099 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -212,11 +212,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 		return in_pf ? orders : 0;
 
 	/*
-	 * khugepaged special VMA and hugetlb VMA.
-	 * Must be checked after dax since some dax mappings may have
-	 * VM_MIXEDMAP set.
+	 * khugepaged moves data from VMAs once collapsed, after they have been
+	 * faulted in, relying on refaulting for file-backed memory.
+	 *
+	 * Kernel-owned mappings cannot be reliably reconstructed from page
+	 * faults, and fixed mappings (including hugetlb) may not be marked as
+	 * kernel-owned - precisely the mappings which cannot be merged.
 	 */
-	if (!in_pf && !smaps && (vm_flags & VM_NO_KHUGEPAGED))
+	if (!in_pf && !smaps && !vma_can_merge(vma))
 		return 0;
 
 	/*
diff --git a/mm/mremap.c b/mm/mremap.c
index 7c368440fafe..ed19b47c2caf 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1788,8 +1788,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 		return -EINVAL;
 	}
 
-	if ((vrm->flags & MREMAP_DONTUNMAP) &&
-	    vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if ((vrm->flags & MREMAP_DONTUNMAP) && vma_is_fixed_mapping(vma))
 		return -EINVAL;
 
 	/*
@@ -1827,7 +1826,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return -EINVAL;
 
-	if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
+	if (vma_is_fixed_mapping(vma))
 		return -EFAULT;
 
 	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))

-- 
2.55.0


