Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26C1CA9EC1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E797B6B00C5; Fri,  9 Oct 2026 14:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29E26B00C6; Fri,  9 Oct 2026 14:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19366B00C7; Fri,  9 Oct 2026 14:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9B786B00C5
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:15:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A6E51404C4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:15:50 +0000 (UTC)
X-FDA: 85303891260.01.C861C91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 172554000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:15:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0TgtNkO;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FL+pG7iYbns5NAvxUiKpoa2h2WT2T+0wVsizSFodaIE=;
	b=7iTpnmOivVSMs7mU9PZHCLcIZB6B5ft4UgNY5EOLs5G0pr8HBi3OHRKzwjjV3W712gMlfF
	TGmF0U5BOJKeJA3uZ7222Ek6rVED3B8MGS7BlEqC5D97XCkRfMPSgKxHCNXLC3RB2vJ0LT
	HmFIc5lcqL0ERYSfhCnwzFTyj/MpG3Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0TgtNkO;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569748;
	b=hDkkPMLAWIiS4dDuSFcUcChsCyb763btvASLVSBfsNqYVVwWdW0r4UTlWcrloDkwt2DAW2
	116OVr8lymDa3LEX3nMRqhsFAFluD0FsPiYzpCkTgC0uwg82MDh7ompKpM52HpiJro/pI+
	3QpOzmWeg0sNTVcQOXjMmbpigIxJve4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC20060267;
	Fri,  9 Oct 2026 18:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5241F00893;
	Fri,  9 Oct 2026 18:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569747;
	bh=FL+pG7iYbns5NAvxUiKpoa2h2WT2T+0wVsizSFodaIE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P0TgtNkOLtz1V5RqdFfmzHsbr2ZV2xb1XGOzsdEPHrVHwslHBF+5+ZC2lwDUuDN5/
	 fmzhfAT1pDfwOvwsrPJa7aNcDNhIIqnIEOI8uqL5dLhrP6DOftcDd4KkvNQXDxuA+g
	 nJi/13n9pEHD72FuN8zUubPaSDEbqZ3WKnWiAnPYiObUoTTMYlqZj/t5I9CzVxr9ET
	 0DDBl0yUC3dQkmq5m7xXxu7UK4dB/9ZbLmiRf8qqe1xA7LjkBPGH6dVx2erHafhBJz
	 p4NQx5Hj4F7vstfNKhmQ0KlnVBEt+wvKAGe4YIHvd3X3wW2eOvwHvCAg6kSyk9ULup
	 tbJ2MFJUV62gQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:26 +0100
Subject: [PATCH v5 32/38] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-32-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
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
 "Martin K. Petersen" <mkp@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
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
 fuse-devel@lists.linux.dev, Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Bert Karwatzki <spasswolf@web.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1363; i=ljs@kernel.org;
 h=from:subject:message-id; bh=YNfpkCadbWvpcwwLlLHWuiS8T4ZWoqNpMFslOQmKhoo=;
 b=kA0DAAoWz53NioHifxQByyZiAGrJLJ6g6RZFhU4KbWCxJ4gVFn/3GBGvvkwe5RYbI4G/7nuFn
 oh1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmrJLJ4ACgkQz53NioHifxQ9ogD8CxPW
 +3isn5QUBXjLRAKoCcFSJm47bItdt01SL2uVpbQBAN7TvVxb9O5vKhbJaqaskLivUiqoAqXACKJ
 oRjxBku0C
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 172554000A
X-Stat-Signature: pcx5zozia8jsww8ww7nqybxnekpp4wgg
X-HE-Tag: 1791569747-567583
X-HE-Meta: U2FsdGVkX18Qj0hmLsRr7m0jFzEMAhtc/zWSfIqAE/OG/rcu70eBJMjz1/cNzpSJWP4LjmJOMRwNsbH3Ellwp3jkEVokSMIfa+0yOz/04jHASRiFlGVd2O3XN+KJ7lofvbm9cbEourV4GZlZAG3vwQjF/mFJb1Dnau7gmLN8a5GLIdNnrnqStFoHKMp2OchM2ZSEAeULCgwUHaMpfADDRrWeMQemeVbcQRrxhMwox8E2mWMqUZDEaPzvMQJW5CaYAof3ghkkJz17i819/XTeEEVvmCGqv+a6wyhc6qKGOTytgNdo1d1ZObrsG7hZmWSl6cVxHff3pWpzpWE6gMKLB14icFr7ndZ0tWu7n/afWvXVDXA/cC5xkYsoWLl6khZzYxm0xUZ4Pxy+JOIv8N8HTzrMC0QdFA1svA+69+RVQfAqrXHDFN9pHN59NS52YkicATz6kfAT2bXKFhdb8IoODsbUVRq9W/5G9zE838Gxk3mc/GhNGwFstGrBCmO/A1DUtt81+Mm4uOUpMMQC2asDu3RKNzEDsxAzrlagXMT0B+ZWgE+TuSLPwSb2DTdcFDvbmOo/O+2dLFW91z4bfuSbjfK0ta+jjuWzWs8w2uXbslX99HpA7ryos1M27MDndfqJ+QrFJE+U+zGWjuZECQ0rp1KumnyEqLsHT2b9Rsur2A89N0LM9Fry26qnfI0zm2IKJKCL7nT8QtKLZxF1lLP2QRewYCswq3EbQdh+YASeuL+eKPPY6ZWJmCaYU3TlGm0yWBiVzJ+04hGgtJ7YkBBggkoEvUVNpX92GlIdCoa3RkcgLxSwmsULtJMuaJdAMWbF1DMEIhcaaxTcfP8brjzT45otjp7sd3C/pTsCbx1Kos2N0IxbmwxjwmufdHgDCIMb+FM+ec8KIdS7dhGZRVmiMQzffegCHEPio0gHH5I/CXPwMvO6T02NwbpaNtjngLw0ffIZVhiEJausHifoIEJ
 GK/X7DF5
 k0tZcf+eqHkkEoyCIwNqvjdE+aOWprUQ6ymqOrTVbIfWQLU5gZNcURJ05Mc255Y8IILiYIAkDy9pOZaFx3rJENB9RpVQBq+8a4fveg3DUktbPUNo3hIyA3sqmkrkE69IPZ0CWu1tU9Ad3XIn3EznoVyrW0fy4cOcAI9JDYn0q7qMU95Jog+GYzrO2RVy3FKfbYAgt50zggHEqAhWKpnlf5VzCnltKZ0f6M8dQ+kHIB0s5UPtbC0gQi6U1l7Am8BaJgbqi5UIDrnvEA/vRChUjLniImyZHwSUN1fOEvQ1CqZunrT8Ces2uU7s5+OL5f7PolLtvmSSZyHVdKdJVivBMsKUlCl5Ia/j5jgdA1ixBuMQ87IQPP3xPEMGTe53XT+hDgDLgvcuwpOoPUkBsxl65BEewiDSyll4ebDHdhZbhclMDkUBsfwR3QoLdfdbHu4QROlPZ4KzagGBkYrxfYH8tZgEr8VqGlou3QHpODIobJdKj+pd/rlyoVrw4Up9QwxXlI3N+22v635bgXL67yoiYA6M1DRVLok+6OiETwWBlbfLskaMdohvUUgtZ3e/E4MKsHOjrxI1lVukkxkAnQ5OMTWDIuxQHwQH2OG8lyhI6TcrixpwTxtGIdSW2Ve6dAm+fvxRETN+I0z1ZJTGQQfpjUqg0piTwIbnV0Vk5UzXso12McvFJ5i1QuQvT2FgknS3ZlSI9gEEoZNe/b9a6JyJwRTzKYuJa7eWnlTVBryomhpIFzAqWULjrVQUMK+HUJN9ku16FPXu9ovCITW1gc0vI3oq1cowr/ow3RtQnPqWAFm2pNicxDRkn94p4Kqs+LNGNDSNbHxumUKnAMwALtFtKdt2ez5NEjvrGwTMX59x32/pE/ZFBodQmGsIKNMblp1HxPI+Do2lR9Mnz7EBuhzhlxrpnzlTY/oOFKeMk5k9iOyATWhaoww8GtWBWhlxgw8zAnOo89dKp4/xiqtasI1pc/KnzJH0f
 LtY+7jic
 jgPO3RbvtNzbX+I1sbN+ixWtW9qcRjSB9XZPd1qaMd5JV8AqKc/INGW8B55YMeI8U7wE1kHBTLf0FbPG8IjqxLnO6Cy7C5scHL6gH3N3uo6e/l0ApnUEybD44OwLe/ludpXBkKbcWLBnTPaW8htfQYRwYXtQgaj1nqKiVIhRyXFfBUqc8mLpS51T0O2+o0Hx124zt8qXr/mLrktWlDF+OT3jT1PP28soSy9Pnu/WQ1+IlOXeElV3QI2vi6GL5U/C34FrMR2i1woEhW668BUAjFBuB5/ela6pwRPHoZU3S62Qvqzf4G2Ja+dfuIsLHA5s1Y3TnRfJkHkrbNBEvMCj3BTRrGhiYsDuozQg87bdk3JWj3k65xW1EivN+fTvXBNZESnzXhnsIvn7F3xvlEmb086bd6zzZPHM2WCf0D+wz5VsbGLC12iEr9BImx6qHCMJqp5L2W+zpXcYq7WZ4EO6XDxHk2ebCKS9ncrTWkk1+RI03UTGMZ8z1aQJ0ZrZTeUGDoHheVHRQZPT23UA8llX2sLbolB/LWcUjW6JLkJ6veRuwvS1jdU0pbtnjaI0tVWBtj95o6llV096TwoztHl2AfJCKxz8vib+Ken7ShUzvuzMPT/+TB/JntXIwVv8aq2oTHZCGq6IlY6mjw1lFdA5UQquaYvdH9vVZVYiLBPkUb3dO1+I3WnKbX7Goaxoum/aErRAJ3PgMytR7v6cCmsnCkjRkXcu+VpXMBfrXJkJmcJkndxpvB8IIKjG+/q1Za2hMqPS4/Uugx3Dl/MwNSMOeCsym9QTUp2ia4sHiJgidNDe6HbHa5/GZnolURvezvs+JvLipfowHc2VQ6A/YqTE3GacoHLkiNeaeA2l+wOBbXJaR29i1M6TzsM2Nhr/2UpAW8OF32yNQnc2QtOqdjtxXn3NDVcFYchj8Nl0Qj1mjBtIwSFAh7ux4jgAYMx132WNVx0Idy9KytaypdNszlt0RZxgE8rmt
 2X2Gtgtv
 Rty5FS3FdnXhlDw9jALb925jy2AVqAW2NMcahfn1AbnBf4lZKI6oY7BLFQAk/XbkA+FjnGWnhQKg+0xjHbH1I+fvbqXbq3I67D5ZhgKOIKNxYmeWyQv7W2w6bF7xasEgz1P8oCZkmTMjq7/3aBeaK1Uu+jdGrRbAMK8pqU2kTZAHAj8oswikSWLOcx0sGOC/O9BmaROBvJZPLYMxBg0LHj4F08JHYOz1iqwIY4mDbGEVMK7IfbX07HnZA/wn4kVimtMb9nXSnqwr6ioSCpLGQQ9SLcncl8x75mySnRsW2iHVJPaTw+/QbXxHwLueuGCBpDzLMFRD2ckDnuor08Irb/oniFjyW9HNRL3qxt755mZBOd+r0qpQqpeDdaXo15MA7MdGqSCq7BDHYnAp0olHcST26NoAK3HloL4NIO3c1RnOHt+wYvdDtzU5u8C6Bytqb4vl6NFHp8QuJjlUQSpQOXmBk0Itoqiv7bv2LCFjyGdoKsFltU2l9RFdL+/Q7o2XDoZW4s8gNL49vDoYnQWgGutBSJImhwAoPfZwzHnvthS3ujpMAc6XoTXmzClvLQcqMl5bivKFYFMkJT8usbzUfSpTafL/zQsEri187qnd3tzH0SLJglayZlNCygqUQApssyjAUHu4YqTJHaaPZ4Vb5Ejdil3g5+OtgFCcVOh+JOQ9TBPe6UpqMgXzyzvCcLGtrzFK03cFhQeh2b3RvhYYf7owkdRDdIIsmH4jDrwSimkL03Tu1I/xYj4mr0cpcP1FsHB7ISfvPwuD4SN9/NZkdo8Hdd0MTseJdvsBws0EMdEoUEpuXzPzwbrvZGSy+Awm7+0CYuRmXq5t4WGB9+4+vQyiEZ1D7yIb6xqqho/hYNU2vsxS6LExcyEkQbif+HBwNehnZf5n/J7UJjo0U3T1rbu9zDBVA3qBN3lwD1f3njwdxK+u7Q8qJpY8EODjGmBqDHpB8axMU4kV1hd9lynYhxPA729VF
 u934cCXE
 XE8EG+lFmgE6uHSUYqvv51/4TR9py1e4SxLgyv7XsJoLwiQHmtjqQU1W1WM4C40KYyp3Hnim0J/nK6nMgij8R6Lbk18b9BjRFyIeDC1O88fpJkB1FvkAW0pQQJOE1BVLWWWKxjuckFW37qtKo8rMjwF1/evSdx3CEiC42iiv/VcuiuaC0KWFk26DLlNIh1BrRpHnTF9w22rpDvVJl454BLYqf8Dk8c2wZ/L2/rducKyswm0cG4OsPxAQJKks88ubzuUISC4VM9ldRlZL3XmR+oVRkFTDDXX+BrS3SFrxzad9vn6qexahBjd1o7stGBoxy88JgfsUUSHsMDfGemlqUZ+Mni0YZNqSsLK4+PMv2TvWeJBL5z6S067/O0kVWN8Dxx0ahkcUoh3C0Om+DlPgHNn1SHJ1sN8JucrIEvkS/+1vvfOICxhPeEJoitkLp324CY7GHIIrKzcGYgvnPHWpTQx/42VSSbdKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make it clear what we're blocking in MADV_DOFORK. Previously we simply
disallowed VM_SPECIAL i.e. mappings not managed by core mm, fixed mappings
and
VMA_IO_BIT.

Now the invariant is established that mm-managed mappings may not set
VMA_IO_BIT, the VMA_IO_BIT check is redundant.

The rest is equivalent to testing for a fixed or non-mm-managed mapping,
i.e. exactly the same check as whether the VMA is permitted to be merged.

This was established by commit 0b2758f48f22 ("Require (reasonably) normal
mappings for MADV_DOFORK") containing my hands-down favourite call out of
all time.

Express the same thing differently - if we wouldn't be allowed to merge it,
then we aren't allowed to manipulate CoW behaviour on fork.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 9d0cde25da61..30e42df6910a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1565,7 +1565,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		new_flags |= VM_DONTCOPY;
 		break;
 	case MADV_DOFORK:
-		if (new_flags & VM_SPECIAL)
+		if (!vma_can_merge(vma))
 			return -EINVAL;
 		new_flags &= ~VM_DONTCOPY;
 		break;

-- 
2.55.0


