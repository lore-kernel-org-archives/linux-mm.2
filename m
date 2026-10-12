Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E03CC6B01
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C186B008A; Mon, 12 Oct 2026 14:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5576B008C; Mon, 12 Oct 2026 14:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E5B6B0095; Mon, 12 Oct 2026 14:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A465B6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:57:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE240C0B9B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:57:02 +0000 (UTC)
X-FDA: 85314881484.28.C45A1B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2168B180004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:57:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bm8mYN7N;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831421;
	b=8oGBPFuP26kEdVRdaafzVjuAxO6F/lfLTr26rZGKjfozpe2wgPAet3tLlwket5Tsdl/wGh
	P4WNRMMPOH8RLj6LKehxTwJwWNgp9+htXwhr9dDsMCPa0TV5+L/NnTQacUSuBDY1aUkr/K
	AdMT+OzbRJhY+jm9tXhlNHSptfH5Dnw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bm8mYN7N;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTP8jRLZqHJYYCJdjNKIR4gbRyey/kI+sfcrw+3IbSA=;
	b=CN2muzquzg9wXqePgmt8ZFCHbPxT8/HLT9INQEGrLGB/JH86oCIY4AnkxRUW5yPMj06qw6
	sxhan5zOPr4+SycWELSTEAztE+bdmYl1Y7FhP/NMpJp/klEJf0B0eltXB0J/ZOWPn4Voxt
	2Jxeu4KiRI4Jo4dkKNi+v31NlIdS3JE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B29941940;
	Mon, 12 Oct 2026 18:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EC21F0089B;
	Mon, 12 Oct 2026 18:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791831419;
	bh=PTP8jRLZqHJYYCJdjNKIR4gbRyey/kI+sfcrw+3IbSA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Bm8mYN7NCuVqJWvDQ6HeMDQgHW56vGjF8/wxqiemm+bd4XmiznESMJg7H6sinCrPZ
	 GZV7rPVLL4c96uF233hGQASQqEN2lktuU7TPySarXIcDirkjehuR9NEWkWwAEoWNkE
	 3RkmfTFQ3M+rQGQn1ltRovDD8fexILp4RameZqID6330p5FofggyKxZKeFhdRVSn0v
	 Cz0eHSlFKc21spb7cHAfXKwwUgbarEpbRn2T9NuuxmjpZZNP4MxauxEdyEed/b9hrO
	 GJqMnk1VIxCocs/eQrIixEL23q/oEUQNt41MRBaq/vsTI3LF5rjyg6hCs2s3qeSIOT
	 uC2OpBp+V/Fbw==
Message-ID: <4124106e-c51e-4476-bd67-63e4641bf14a@kernel.org>
Date: Mon, 12 Oct 2026 20:56:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/38] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
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
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 Bert Karwatzki <spasswolf@web.de>, Emil Tsalapatis <emil@etsalapatis.com>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-13-923b70125b1e@kernel.org>
 <5b8ef0ce-7429-4d74-b4da-a0561c59b1e2@kernel.org> <as0Buhi_-VCC7xLZ@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <as0Buhi_-VCC7xLZ@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2168B180004
X-Stat-Signature: 1wwyc7doe73zjwqa3wq7q6fqxra1kpek
X-HE-Tag: 1791831420-909910
X-HE-Meta: U2FsdGVkX1+/7QRCdCk4SoJPJgz5wLk8r8IDmMWVEsqslvgW2UeglU8L/eU1d8H+JYS78K35OZxyFdWXC34f0yzFo3jqPWkrI6J+KyATLNcdpBtJEbW+M7Nae9bOOFdkm9maHWBHFLjZDx02Uru1nlLxMTXV/bqHUIybfppiFRnZ39qjcp2Lj85O9p7y7fseSts6LiYwYkxbhqGsZ+a/4x884YUEp7zHn+CA7fGC4LJ1xIe2CAfzHYLuefffhznDNr4mlLcStdIEz6RxrjZ4ESwOMQm2x6yLLZlXTX5X0kSzoihSfJI+lw7R1WlmRxuxuFqPleiAjWGIawVARQHjPqxzQ/9rbvfxK+cRuov5oJD8W1xGGovSDxLUGAk7Z/ftS6wM2VyPAQIQuqe0SRfwgQ9TvUgNt2b+WEnKzFMLfXIk2JwGlJLUq/D/gsb4f3Nt36h/swTVOh1xFZr6HhWcJ1/ymBYe8jACHYfpCW4LSmgVQwCkpEr3Y64Z0f5ULaNtjcq8Qw1+nF2s3xKH7OdycH1GtZ1BMmRt+mppInHFfJA/GW9HusY83ApvVI19a850RSVYSA1EGnFj0sXnEqP8TqEO82wpPeVZlRuTPxxVPIVrz/OZNphxFXRegMUgIhf6SO7n/j39y5WL36YuEraFZi8uQB/RzG72lHzG82sDq0HCbjz5+gn0gYMlMsF60F3FBhiXTIIsVnUfr+F2XSNGBNRtfNLG9ywoLE8nNEZ6iMp7y1qkCeETlGk9nSr+t7JiaFh8kXAgwSEwGCMDVYAF+elbktd8AlaSlUKhkc/JJ5UTKuzkF1u6/r2L2j/vLidLGlfAnYyj03obKNKT7JfDRHjBQMeNp1Fm6eGhnWrZeBl9f25UorEFKhaHmP56ryiElI0SqlP9MLnFozGvTW3yBGHlTkBPbUToNCmFs7L+ZbozmgiWN3Zb6PzE/hPyhx+dRuBGceqCG0IMaEL9LOF
 snAJRhGP
 ui2MnUVPJzmKd2DoPjn8dnthW4oPNGSBfsY+lPGRpGua1npZ03ULJyd4aurpEpautfcq40LXIgtd8egWe+I+N/fiMBsy+9cgt6RZO2ANXkluuHR8J4qP76Eg+uiepT4SchD4T1axtdeCNCogyI3QgCbcWaf04wNJoLGUUfB7O3oS2oEp6qZcI/wvtImirvwrkupvxUo8qWiU4OwyFvG2p78VnIuEwoscWz/Z7XLn7jZdbiq364o2zQzO3R4j6Vn9gX/F+SyM3B6rBRtIUMi4D7qG/2rF01APvMwZ/+Yx4uGgCUAq18+E9z/h21UAJnvT6ltIKpYVP/Tzy2w9CMv7sffUu21N5lDiBY33La+E36rqGcsivTOTbzZ6fRwn5bAqSBOZ9cylHVXyssFSEzlEePWfcXw56iSaxtMRf1fOoIfTYRaisA3nw6id1igYZo6QBfsT7K+ZwkWpBXiM2+n941WK2GNjm9k3EQ6SAyiXkJPUdJyfOL1LfO/ty04LIcl/5rsETxJ0m99Ct8c7HojH7cjqgBunV1nmdt8PcirhawyKWgST4WR9Tk1A7SKPpVgfiKfLo+66MQiJyeDDR+RePxdmsBBUwjLsKHaGAq8mqbn3227BNAq3CcF8/qFtGAzOnKarMKIxGhGX5ALbcAEj7TDomwIqRz61mcLJdL6/xsB/TBo6i+gjJxGOkR/QiiBM9fhYR3PoG/jOJs7IoAZjVJXI0oV6gxAYULDn0q+KLyWuaspu5jMBJA4an5uD/fXlqVhoCZ/UMoodN1NoXQPjRuoh5Wx1kndkDhuPJBcF6pRGgJpWaMSBWM9zrXhvCGDltDXRwA1XWUJaa9E+2e+LgUl2K5xTyz9Nuqf/AIQtRG4Hm6WN2bKjdJ6Ku1MVvWO6D4LfSdo2HnnqBn0N6QiaHS3iy05cAN6oflNRaiR6LMib76rk1d3PNpmSvdwBNiKbJSoQPjVA8RCw61OjQfqwg+7zzYk1s
 etBK0zMZ
 /0I9vPvgQuavIvoT6L8YjZNauhk1Fe1Nw63tr2UM2cAajarCqfmtpVd1khBOD1UCZqcTzWCeqDhm/otWwHR+B/cjGZM6LqQ4rlF2BBC6xZBzSn9JFSETMkesZL9zbw6zmwOsyEzdtqDlKPaw41TFeRoe33VhWDXW+5YPvQ5U/svm9I2Ie6cMbgxzZLpDB5gIqOWDW/lmGmP1Y2Xk/ORG2Ka8OA6Tc4bC2Cux+zVm6lWhhF2iIeB+TomT1/bkcqAEGRvQoT5/5eLX7qRx0nWQ+X3AF1w2n2+GcHLeHv5btuGsmf1DZyxR99W471J/JA2e1daQ1lX8FYl+0gN+0TOGNQIiQT+fA6eaVQlM8XUt4FaR/Rsb17IEMKDwqzFrJGwV6QpO9KlllG147vrCdgvAyLtxEkr2YVJMCC/pHBfRVfuelPuzldzes7qEUrOVehnVZGKj5EuE4Zo7gBDzg6mib6J0m4gxDdrhhpw3pRO85eGWqr3pCJ4Gjbnyp0ly2RZ7f9UvhRf5sl3Dj7MnUJPEo8hq7Ot5UpU4oCd+V0JtZRdhra1pjlUmfvffv3yLZaWRjX1spbILTwKi0+1v/dvkWMSEmuLY9TrIcnrDtkWAsUNy87Jdc8AzLW7vIyhqYaF7hbvBCtVWJ15vfrh0dycFa836fbO++pTC+CHZPPEB3nvoK+pql7oYBVZSqx+wqx44/x5SmGpBVMuiqr/aDau5TKOHzV75ouCAlW5ad95/UDrH3w6cGmTLN1QxZnSwxMtIsT6MuWd1Z5zAVezP9TYl6bMMJ5nCnPCpiWceasbK88NC3/JF6RCuJqY0fuS17jQ6fWoWI+oqVCVj2xocoxwOaA4AJGy6O8xLlwqwTR1szCoDVE1LB7O1DS1M+QC73XCNko1ciNNIfbovtuhB+6bSX8VU8GzeZeaJvCHUvYtGXm3EBWOpD9MAmiSpRclmUaA4dg53e6Faupz8UzzVp2eNRF2qbMJDB
 XYAU+yKB
 7S2n7lHQsBWC8H/MAhSydDX5m8sQvSqSVRRMkAh1wETJXed5DSQJDJf7jIn2lkJMd4B2XSvg3Bi25j7KzKXlGJ5das87/4kSLVxaezgwqKc+glv6bE7qkV3Y53Qvi8zqZSeVF4aXBxnsQKZN2kMy/DLLsJQAofkno3J7toBOyaf2Jru0tYNgEh3XxCwi03clhR+raPalbEJOO0bXlemFKmsmLPMwe/aJFRSgpP2//gxlbdx6uEedpt4QFts4uQXIA9NpMqGsHQeObo35BZmEJ9zRu9ntPwVXUAK1VA4QSX9FA3Y/0bn4r+2NAYy+uREulX0YKq6L230D2xDCw7y4Rtcxqcfh/GAJtecpDHXjqO1Zwra9L2AjvUyoEZv7ONn1L6nvldQQrdqAUOXKLQPAApp5q5Fh2GPJgFtzH7uhX3mpwyPsGZRXa93o5BZbU4OmzE78wIMD9TDbFRhlAwN0uTNVkTU9DxRvIXcM3Df8ZRb9iJ3yr3QyDiTZ6rdDDxC3TXdq1x8jGykaJ0ATsIDgEiLkARRyRFs3tjHj71k+Mz0F2HpCcRueYmMPzrsF/LIL09Ni2pcggUYgo4N3DtZkzBZg0k0isbFGdn2ERvcyBjj/J3sioI5nK8150DE0TLm4FG7tGu3IPG49pLKimgDgpvzAM3VyoB8UqU9Df+WHL1Evq5eIrls7UV6J1aLbqVXjPzlPIpDMtxKUQaeRSo1qDS0YkwG+tGUmm5beJXHD+A9zlZxWUsWWyfxyiZ4MYkaVhwizK7lg8JKMuGpdKJPJBQwqbiRnyd3QArpVfTFchbTHd+fPw25/KMrK1d184vMdFLqZOCo0MGOKmTfagM/kZc141/n+7R+hAh6nKNeFqdGDOyQkGx6lmTWCRXkhYQ0rFaeQBbVxuATUdI8Ywp6DlXf6vriiNzZJwL/6MtRiUwCt2ulgQBfwD5BIdBwea2c4FjyhhQAKSr8V8jkSYc2QB27M4ssYn
 Hk9MgooU
 zLKqDQNK6+xOYl91Pj1FG5TsxPWDH4mGLG6DRe1CO22V/Te/jU2FBXu6MoTRVYBBObKmMh01nXiJUxWUcABMrEZQXVDZbcRA6ZW/aX1Y6qAZCAXwLcOM2OaIsFFwTm60OjaIe0dT7C2uQcAprpSrynvXgsRaTBrV15BD/a2RnkY/EFYrGeJls3YZu8jnR8lXkblVklDpfgdIidVVPbXV7VwfZ34wc9AySsGRRDA0m3qnUqCR8qwUyWNqQQYfvVXWYH/2apYx8AbpCACxI4DHU39vLioP8ZoE4mlrwnUWSe7LmIh1iobkfZAmfzkOkbkiyZbA6sLH5KnEAZSZ1RwmaAZXHH0vJ2flA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/26 17:55, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 12, 2026 at 05:08:09PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> 
>>> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
>>> index 7b6847200b43..b69fe5e34339 100644
>>> --- a/kernel/bpf/arena.c
>>> +++ b/kernel/bpf/arena.c
>>> @@ -620,8 +620,9 @@ static int arena_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
>>>  	 * clears VM_MAYEXEC. Set VM_DONTEXPAND to avoid potential change
>>>  	 * of user_vm_start. Set VM_DONTCOPY to prevent arena VMA from
>>>  	 * being copied into the child process on fork.
>>> +	 * This is a kernel page so set VM_MIXEDMAP.
>>>  	 */
>>> -	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTCOPY);
>>> +	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND | VM_DONTCOPY);
>>>  	vma->vm_ops = &arena_vm_ops;
>>>  	return 0;
>>>  }
>>>
>>
>> Historically, VM_MIXEDMAP really just means: can contain refcounted and
>> non-refcounted things. Everything with a struct page is refcounted.
>>
>> I think we are now changing the semantics to mean "maps kernel pages". I think
> 
> Yes.
> 
> It was sort of implicit before given insert_page() etc. but still really meaning
> that it _might_ be both.

Yeah, it's in the name. Mixed: pfn and/or ordinary.

> 
>> this is fine, but we really have to update the documentation (and possibly
>> rename this thing to something more expressive?)
> 
> Yeah I completely agree.
> 
> I will rename it, but I think that's best for 7.5 obviously! :)

Yes.

VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
			  reasonably reconstructed on page fault.

the description is already pretty clear. just not that kernel-mapped pages
*must* use one of these.

(again, the ->fault thing returning allcoated kernel memory is nasty)



-- 
Cheers,

David

