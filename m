Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F18ECC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503306B008A; Tue, 13 Oct 2026 11:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2626B0095; Tue, 13 Oct 2026 11:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B066B00A7; Tue, 13 Oct 2026 11:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E96156B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:22:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 743FF140CAF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:22:56 +0000 (UTC)
X-FDA: 85317970752.11.6FB837F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A27DC40009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:22:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7kG8VRD;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nu2lIlJoFPKLE+KDwHqBioHzBykS9j6g/3VfcAZiVdE=;
	b=aTbl896utOZPeu81hFbCsEBFXX2x+BjpJqehTtZWO/zddJ/hYl4CfSye1h2P0dRilrNrLt
	B01NHhIAJKw+E0/blRdOFLvwLv1AessAnoMOc3tQHFZxfhz+EUPYIwVmaOFlcLMPJWpKHZ
	mqW6av+J8BVDn21qWB3mPkvDwxKHDDY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a7kG8VRD;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904974;
	b=PK2pXM42V13/vQOOGvcwccS9raG6vdgA/LndQrpmaqlC1D1n041Qyk0xiqUn7B5fgtxw9g
	exQ9BpdnBv2S1HIIKwtr6ceAWPG7vYV6W5ri79ZyvXx2VOwP0mdX1Devy45wSzPhXtQJZz
	MWMfmUI5C/AaFtzqilCg4yoHHfnWRv4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF527401AA;
	Tue, 13 Oct 2026 15:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC8F1F0089C;
	Tue, 13 Oct 2026 15:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791904973;
	bh=Nu2lIlJoFPKLE+KDwHqBioHzBykS9j6g/3VfcAZiVdE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a7kG8VRDYlsv3h+0u94q5BK0Msy/mAEkVPHqxzuhpCg+ASw8Em4RgjrXRneGPhpKM
	 i+UNxxaBtu/vPhzNc9Z35kL28wW4ApEmq5gcW2MtEpVT0jU82WmXaludhh/wUMJMmN
	 ArVJ1Z4A2aHHWJmQ/HBxmvc7YGic/4Lw1LLrXGayYOmsmQGcslkGfY2Va/SDcJJSK7
	 X6bBWMK51/CHLc30N3o6XZn/34pbf1IIAStJTSep+kAnORP/dcluCgRiG8eka0v4LG
	 nV7lo+Uemo6ZUZvpIl5CaJWT+TRDZHXTfyCsHb8dF4MB/qmY0t23MUhlUQPckhf8Ui
	 LHxhfAUBes1+g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 13 Oct 2026 16:05:12 +0100
Subject: [PATCH v6 32/39] mm/uffd: use predicates for userfaultfd checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-32-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-0-1aa3c9b139f9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2582; i=ljs@kernel.org;
 h=from:subject:message-id; bh=NirFpBJoMJIJty8FHlUeArK6s29xx2Rs0nVWGbo/eGI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLOeZxx/qY43VC48i6XuOKHXYkc7LKdlzgsQo41/Jhu2
 eK1hb2yo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABN59YaR4ZdAqVvUtuy+/89O
 PrcJVufzNtu/+4PM/3mJYRf32P1OfcrwhzdAbMqKvOMFz3pcrVMOccdGRfQGdU0wU66R9lqdeje
 HCQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A27DC40009
X-Rspam-User: 
X-Stat-Signature: nd4qwowos95nzz5kbu4rmperre4qtaog
X-HE-Tag: 1791904974-995714
X-HE-Meta: U2FsdGVkX1/FqEB3AD29EykX/tBe+REMkezBIhkmTHcyOTxIu6nsZyYUg7PReND2G5AdV5Q7rXilhJy68l/jMfuKFW6ZLuXtDWQzklyNU1xAwMiePvfrTV7ND+VEm05m7R9szJwd9toZZRJ/XFFXvVogxRvnlDRHrf89MFiaCUU1FrTZmW16+7gQtTMvbR4uLfHqWC+fsiJSs2MbK2TnHzybZjNirOnLPg9e1grYU88j04m1du5GT8MBic+nIo6xUP59S2uSU+Bv+2jAwCZ6Vl3GfyQJi0Rb9JmuK2mDpNLRrTNi/Z0W4cB7TpEZ9dQLdqnp+7aRqP8SJDOvukUlhPzFEqUQnMPrtwh25Imt1uB1zm1pKJuW8Hez4t05ciE1SFtXdfwmmO01FVvEEhi5sJro+c8Tnjc4l3WO1YfZC7Or+avHA778coLmbe/+fnaU907qalEZfWarehrdr7Ua674Zh8dFiw688UvEo5vWf4AAyzd9fn2r+Lwe/mno29wuKY+mHUiGxSiAEnqs49HS4agcn33TNKk/ujw6DZE/1rUobrKPcliK1LCSNZlEDFrZ/9VVbMBj2nmrPmLpbJt9wVKK6WEVpO6ZTCRknZoDEIle6Y4bzz/zF6mauDv1u+pYRyLWIzcNf1qCjgX17WxCmSoz8vuiaAzfV2WjUyZxwlF9Im/XTKZbgZ85iU3mKox4vEXLPvpHDTg7jMrBFpUsj9BAR/UHWGfeCaInQr2OnY3eVQwEAyRqCrK5TVaSNmJcQ3BvY3ACCc4YJk2Pqtf09AKqxMQHnvLIfC/Z7D8n+bzd5U0+8Hb/52JPIIQW1+zv072kKgy+XwvEqMkC9zApOVP6Al8wa9VFvZlvz5HL+makSiGehvApuQeUb1f1xaKNQrSWAY1J8b48BVRDgn62VHZmeSegJXC8/xJqstXLzuvtCM3R/0i4FJ8lV+FU1OS/EmDGTfWmW+nsKEsJVed
 pWbQF7ep
 B5xwEPWCaU0xdVpH9FTH3w9BTuHedBTvBM8Wx3gPl2/WsVW+yu5fn310cDl/8bpra7VLJXJHpgQlk9eARohYZNa5jSInrHk6FtNLrZ+WQmRiQALX/1hAZCGDlNja1rZz583QZRevuzW1yULPVTQPNbGF7UU6kM4WjazLoICbZ5OkrgSHsOAYshn3+NvSPqqq2BRiMkXjHLF/ilPLaoIfMsxLUdc74isXpL+yOWZX1ChXP+KEid0wOb6NZjrx0wpp62p5I/qFcZq5ElpkI5AMTlJFAWs3dxaahTu0/qH4Kgl8DicYF5UC0PftrEnjyzfZtNbyarE1WWwAwY9vXjpjtgloRxe5XeGsCXZHQo4oFz7ZlNrNf4sw3FT6KPgkaAeYO8Ofbt//mxVwb+2qVo6HXooSfhg2IoK5uh905VCErgmJ9PM4Tclt1o6qTlQskzdbgKf8BOizbqGecIbpkc4KuChABkJwaIV4cB87AfaFAkSbI7+RZWnr9H8kjQYiRgw6N9uex3E6O4Hl/Ev2dCbhntYNaCoUN3Rx96fxgebzUOwCnGI4QpOgb6jU57qEdrROBsj43e4llqO06WQWNysm5pK7Y6kEnZAsum0rAoFxARqMhFfukCp7QoQAOoKvoTvvYDvRZVPHJbGdh09/eHAXg/+YDqvQQ3ftMayWOVvJj12WhyaPu7W1M6xg5dK0hl2+des1V7PeEk6EGUB3Qit+CyacgS/cDFokOVCzgInmMymWX68mLGWcd9VZOIwflAe0hAM2UHVCrByZcXeqz31d7J47EaCPoYwGxlx9Pzs8OiHfONrB7iExiT70GS64e+dQez9cZ0PlF1aSXn0x+ZHshbtutwfpVLQeOmV7i9q6Ep5Li98o3omAeBInxFZv/i5e6YNtaaG2zkLih7CXYfqyQQqKG3iRSQQ7aSXuxSB8U5/isUsUUMoLCpz8rk2HvH62s3Cwaurnww2oamYlyRAc5hTEFdABm
 h3gA17jX
 6ZTPy1JJ24zmmy4A99NtNvLwpPwk0Tvr4jsUWubzoJnkPEhA5PaudwIUbReAJOmLqIc+BsfkrCf1MjuplJZby1OUEffEYXkQm+sctIPresX1A8zgeV8UJtjPsmh8X4gtOZZ1bKiS/QAF8YUX2mOjX/MmjibCPhpYih0Hp3zIX+BLSsfwC9rd80dRUaFelP9TdsYqJ9vFbRvVezE9gN3HIpsQcpMiprwTMKGmZpFrjEuGW06BhsQlS4s9HW/G18f+csi60EC/ZE16AussKKgiKOO6Bvx+9QZhT/ZyCvkAQNSb1hrz2mrMPqV7Dy8sakTXihN2Mv1DZstlqvyt36sMaeD2Jf4LFJ1FbUUWXzV9fNIyto9iy7I4bpRzRnSnodYig3CiLwx5R5YkBfVDk44CdNnJg93uNsVsrBXD4FQumkD5wJPWQV5zHFEpsATtESIKJQB+tmkWZ9lvlY1KvOS4ud1iDb9Mh0Ufysmzb720ULIPUj5XvDA2ZD7Fy2T70Rwe85EuMQpJAHL7l9ZN0AmlRni8nshRUUZVAvR/PNzAPfFKcZIvVvmSTlbdjmPkpfwO/Of0lilCgJtQL+jA1DcNEvb2z/H+zim0dc35JfE/ywsWsaYLZhv1fZ1VupS2/ELrWeaP6QRqnI6I9yziEDkltZC9tgl+SJXStRQyRLeGqAg212iOSOKu6iyX2gUQYA46S5o6R/qUlhaScnBn0VMPhH1PfbJO9nAAEuOYNCtCBClUo/euK0DAxeSj5a+E9yykvNSUYPYqT+I/DuEhn385GWXVCyaG52Rl8+hHa0WXHoGO+Yii1yrCZONO1iXzdsTG1atiaWgwExZVQG0+uAZuNPxJ+/G0B4+Fkoqm6KYD5WbJ5AK9RBzFCPOMq5KK2Y5+EB1gjhLKKPrHz4qEn8aGvbIwUiun2iIo9keCBkxF8f6OueWvSN705ChOc3nEkMa5amSRGP5xLK3e0C4v2E+eTvdorx8ke
 B/9YpFfp
 YsIJUWprSB9R5Jc47PN6HyvsZcNY1qnzu47B3QdEX/UPvoHOCxySbhQgZM71sdQ0t1i2pYD8QngmdztQvt40EwqiE7Fewd3G6k/tUUOUR7qj9crD31nD9fz0PJlxkZ7WNKQLVfd9tqrrvE8ePm69WpRG5waKIXy2zDrfAAVpEHs6QAS+qjPxXZyKensIQLvGDLV8DBiDBbuwZutfVLsQYqLuGbILJJt5byC+xVTviN3jMpXk840I5pwghhMujiwDhKXPQigg8lka/8BXK9GTBi2/mWkahvlUeKED9Eo8WIjj8dbpm0OCdNvJ/GHUT+AXbTX6JAvbNqi2LxuAkur9Uujbo8m6F0wyStI96PbP92UgW0YnaCBgB5sDl7Uz9uXIl4kgt17w9iDdTznoPkSH92OzeiErIeTBzqOOzY/eJ0fVcQV9HCi3XTRTh/nsn/My1uO82BAU1chqm1aoG15p5xf5eVg8D8M6yu4ikgA+zMaaiUqjpsG342DY2HJeqaSXWRO+lVWS3N3nHsZyETcUBIs6/imTznflG8XFR3RdvAS1tV1RzQUFHo5vKuf0wvr0Jdg37ZzoflaRHvJs+G9ZltDqovqOsmJyEPoijY5uPWk1nN3/mFpc6/r8g4mA6YlKYOwDkHCGXEBiKoakF09OlztOCCQWRnyRKXA06tYD5pCuAYbjQ6bT0GiT55Rg4Rwq+jorZ1aAmzxNS+hIyfODcxHhu5QJ0qZl9hcZrRQqiwLqHRW6Bpcqyin2PZj/IicyeQdHuNfjBxPx2vJ5jnDyms+maLUgyawA8+SiKM1AfxXRg+AdIi3yOEYuVL9u8xeiZY5o5kOfnOzTk+MiRGQkz3RfSBKklmsCOH4m/CtfFXOh3zF91dCSxfLCKVsF8hZziU/MpPmBXjbfPic7a1A72vCWWKbnnzD/psuUneKfrOAb+QcfAlGqEm5oLUeGhcoMWmLSSmohlyE0SKoFw0UIugEyY1P9s
 tZ0kJSLJ
 XA/2AWLmehN7YKUwo/v1CZLCmCaS7Wm5c13iCC05apWVS/+JUjCJ+eJwMpsKUOKjnImzczFGvWOWTWFeXUKo7VYoaRmAf3PMmrQyfm8YgSz7EoSEvAuerEwacrQd8+xvNpQ4S0M0qANSkj/EcHh/I2t7Qh1GUHeY0pY+fQvnthf7LmvXMr9Z0+1n55/dFbptcmFU+LHSztnOK9ig0J83h/TGEMdV3KA9oKNH/NabIPsD3azoziKjo9LbwZ25o/jiyKArDzhbydbJ50oG8irFezrmvuG2RC/gpwZieHusDrVrd3cVrIn0JPYCVMUWoSJoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than directly checking VMA flags, use the newly introduced
vma_is_mm_managed() and vma_is_mm_backed() helpers in userfaultfd
when assessing VMA suitability for userfaultfd and UFFDIO_MOVE.

The droppable check is kept explicit, as userfaultfd cannot function
correctly with droppable mappings.

Update vma_move_compatible() so it's expressed in terms of VMA
characteristics rather than arbitrary flags.

Additionally, update the use of the deprecated VMA flag API when checking
VMA_SHADOW_STACK_BIT.

A VMA_IO_BIT check is no longer required but that is fine as a hard
invariant has been established that mm-managed mappings may not set
VMA_IO_BIT so the check is now redundant.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/userfaultfd.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 949017e60608..b3076d4a622a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1754,10 +1754,16 @@ static inline bool move_splits_huge_pmd(unsigned long dst_addr,
 }
 #endif
 
-static inline bool vma_move_compatible(struct vm_area_struct *vma)
+static inline bool vma_move_compatible(const struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
-				  VM_MIXEDMAP | VM_SHADOW_STACK));
+	/* uffd is generally incompatible with mappings not managed by core mm. */
+	if (!vma_is_mm_managed(vma))
+		return false;
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+		return false;
+	/* hugetlb mappings cannot be safely moved. */
+	return !vma_is_hugetlb(vma);
 }
 
 static int validate_move_areas(struct userfaultfd_ctx *ctx,
@@ -2146,10 +2152,14 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+	/* Only mm-backed memory can have its faults handled by userspace. */
+	if (!vma_is_mm_backed(vma))
 		return false;
-
-	if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
+	/* Core mm may discard droppable memory at any time. */
+	if (vma_test_single_mask(vma, VMA_DROPPABLE))
+		return false;
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;

-- 
2.55.0


