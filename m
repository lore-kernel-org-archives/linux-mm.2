Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE35CCA9EBD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC866B00C4; Fri,  9 Oct 2026 14:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4526B00C5; Fri,  9 Oct 2026 14:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56396B00C6; Fri,  9 Oct 2026 14:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 929416B00C4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:15:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC1FEC0496
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:15:28 +0000 (UTC)
X-FDA: 85303890336.23.1295D56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 19D2240002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:15:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4cjbHk3;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XF0JJsfuKvhm2G8uGXZbY0Fvh9Ki1oyQ756jSTtjCVM=;
	b=eAyz5qEdo0ZOc6UBRMJJx+PrfSM51WtHL2gEaYZ21UEx7m98dslb7eVDJX0B1YhXT26B6H
	wboC8PkTeG2ISD48ddR9roPmoY7xHOwi11KxW7b94tlQo6mzpd7oj+i5eeCEvQm3DYaUZL
	PhyzEQEgviZH/rENWdEfK5tqOI/wGWk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569727;
	b=16qw+t8Esm2udw22TbjzM4Scr+bsb8eWmWIpbSVaoWaIUgkKRnex+93h7lS1CNPGVt6yJ9
	9e8xpczkESkEzlcVISn6xOWABZpJSDl2fzD4gCqEUozazoe+pT+dJkzqRSVPxriV1s7Tfw
	SVisVThc2IBC2VK+kk3yaDWpTA4Pk6Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e4cjbHk3;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AFBB60D86;
	Fri,  9 Oct 2026 18:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989971F00899;
	Fri,  9 Oct 2026 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569726;
	bh=XF0JJsfuKvhm2G8uGXZbY0Fvh9Ki1oyQ756jSTtjCVM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=e4cjbHk3kXpv5jaUuHmFqIXJ+YwAUbqhYDOu+qfqsGQQ8nmPgyEH/SlXwfLyQXIsQ
	 1Ok07WusxUfLJqniEECIOHLjriMdhkatRXiYnyQ28ua9IXSwV+7p8FtVW1/QtQg3M0
	 FhzEg03kx7mcEfynajAwqDNx9hDoxww5ey/v2hFaVEbvLdzYdr2y/IKM6tWVG74mm1
	 +hPO1++lAim7du02RQvH9+O37KljWxoBqXlWCWGKuDJn35U58XFlBgQkKRUg8jk+wy
	 9L2KeDxqFeDfDmZ9vyGH/V5M3ikQsTovN6S12yPbxYIb0eFbqzPdS+SKQX7LrDFHck
	 nJfjZspO3yOJw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:25 +0100
Subject: [PATCH v5 31/38] mm/uffd: use predicates for userfaultfd checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-31-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2291; i=ljs@kernel.org;
 h=from:subject:message-id; bh=hWvFAcFtWeMeGKyFkbOpdZHf6iGKkjlhr26+pQ1dsRw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6szb1sT2110oIqdq8uT3KibMm6pvXNgik3Nc6bmpo
 meQ+IwXHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIBnFGhv7pq+QSix90/ogs
 nOjwI/lh1cRz8Ru6rgdNKr38+0tGqwgjQ3utulnz2WtVwW5Z8enOvk84048mMLA83t276BRLJmc
 gOwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 19D2240002
X-Stat-Signature: psdy87gxkm53uoorb5r59zg7i3pjuea3
X-HE-Tag: 1791569726-738106
X-HE-Meta: U2FsdGVkX1/giEVIH8FvUlhFBzDOU91/dQ5A//8pAyIIfIm7bCwkksaapjACEe88YyMRCghtuSSBHpRgMwdN26IMGyVIYzmtpoV93pOo0NjVMeVz73ITMxbF/gEfFrrhk5V8XSaZpLqmtof7AGLfb+t/OxBmMeqQ4sKdQyHIP2bHcxSyu/WAFCMD/tx/OR5z7f1YFtyULW9YsNpSJicBwRnzM4mM2gOqPdjmX9YArx0X9ykt9aYfovKYQD46+NQ4SfUPR41Ru9W/AOuhWfciLBvYGWMu009u9yBvPwB0+tjtvcYRHTkqa0oXlnZ3WgPerhnYGCsJIN/qH6lAvt0EZz3JaA1rfF4IxlW5SQxp1ux6ykr7UMcceZ4X9czNh9ChQkVzwK2wuzjbubG71tXBr4j5l41sxOw27/UvLEfAWxxCoQH8PcY2dZLyIWIPTTuWGegus8tJw6KxfRfIUUiD/YMvKuLoXYrAXhPQI3Z2X3nrc7mjNpkkYKtRa+7lSoHqvqtMJ/4netfTOuHidePJewl0EHudOgHNl57c3Odg2ceME4mLlme0qejwTXL8+LEZx0WSEnx7RyMjPkD7y82QZAOlFUsqbJYRhmL2FmImje7TGUsIMi63viXUzD1wBjJwMAZzCNBbSWexHo4LgY+NTFeAH8+oqYZGmYotTruYsSq3mqYLSse3TSHQjbbnBWY3B/KSMN1Mtgn6VWIEnDhFnOVp+SqDyw0TD6ZLvHhnofwSumbtd8O1QSWQEyJqIqZmwMvKJNslHZVKx63JIuzVzcYJwPRmzAnBuwrznhLyqwWip11Iapa2Z/gSkFcsYXWbc/XSNaHeS4Xe1YgrZl09FYu7+OXRI4Ff5DjfZgJVmXenJiaphHjXWETVpnGV32+sb1XxmBr7/SbG9GSzWXnOgswgLnIFXDGVqxeGCp7wZGL7gDb3LOWgxx6MOmqkGh/BmeD7+araKfnDd8Htr+q
 Oztc0ydt
 WqpSe22qu9rOwcUFpA0EMCijLZTillJRInGkXoZ0Tj0c6Gn1fJ8Y01TgcpdlMj/GvnWD3vMdwPpfmpLY8TW46J8zH87evVV2kB7JZbuPLmGqZawYMATZAiYH1wVvJt37Q2X6zZSnKUk309RZJvhTlOTFu+5b2mWC8FXaNI3vhOnbSgsXk8sF90mBY1ROh9994J7ne3xoepTqm7EtTMlnzYQhN/6LVqIBeHPX+O36fovHRJW9oE4YhZoJU+41NlsvZnpF1wib+jwyeZKzsjEfzc3pwiMOPNpTa25YnZIgysQjw69KFKBM04AW/HhslYSUCkz/TVjvoiAk6w2VvkNXHwIFNK6wxHLO3t8rDkYceoxQ/hLsPEAu1yrYAZKEguKqC3blraszALcucCBMOcEtBTYNXsZy7gku0qE/1vN4z0n7fciuQe2efjpGCtXkr9iyx9EQEHqRBzvQ9c2TMmKPHPhDKdV3RX41jQKFmyF7Qs/Hh4qUcudwT/RSV24lJFK/TG/RZf45CCmYEbGUdang7b2FzTJ1hECwCzhN+hW9RsXSikhj23+cc8g4iNn95e3L6gU/4iq+TsvHzdkAQ4jZFi/JSa0Qbzgxy/VDP5VOMW0TH84Im1bHRzpKzQJVyKDGuagqmOF9xMouFNzad9s2Oy0mOCVtsu1Dzo5ql9YpPzXrMVDhrMxMQOkfgoHdMracm4z0aRQ3RYa+KQv+Uf4PxrhJzH9MILQxp2L6Zyqqm3dok00mIlxqhBNlI01EwV6ds3bnpogePvufSCttFny1+3JkaqovKD88tSFahZAYp+kG/HBCt43BLZf2R2U/5O+YsGhcOqz4Pz/uWrtue4EzqhODpUm4aSDnRCZkZpewapjEGM9xU0QAbwou3fKoiN/BHGWG0vCswwdFlCvqQFUdNJsXGbcydhjeb2T5hFDJEFT7Xmq4Gz35b0+FFIiBxHfgVVUxnTE9U2kIZC5QbdME6dcYFY3MT
 0VySlB+x
 E9fHpzilG6It5UbNMan89Ltqbrbu1W6dM4Rzzr+224VGWCbnBvXhHWq64O6cIEohXeRToBk9FMEqacPP5wlimNZGADzPLChDIG9HNOMX0elxxOt/7y6dXqAZrYFycHf5DWPszixR4jQc/hBLDkldrVwRrcdVGyL3qtYd9v6dCtGml0QrMrdk1RWfppTV1ZcVuH8Vp3Z0JczZuJ51YPm0RWixmFrk9GwyM/00uswmt9vtFPxVsH4r7HFGGzvj0hbAycFlF35K1E2PA1sFqqKRWUpbn81fM3NB4LISLOeMbaffl1Mn+UjH0dZ2KwyUP5YMzR+WJ+bJQ4YRYQPSd8NGRyhtxlNp4hyDC4zddacp8p/tK7tJCMZxlYZbANs8PFjiwQ83vXASBn7x2fSbCSNxT4VAJPrfCei8bNBafcQPQUYaZ8sCxICr09i2JVJPWIo8HWl2+ITGuBQuWE1cd1uO2IF7swOia7AyIgroNbYklWTSBY9Vj+KD/l0AQHvkuo2EVMUvPmDjy4iUUSFais2fN7066mfWXHpk0gt09cM6R1LnJppftjbr4nAnLzSrCrN0d20ahwVze1E30Iy4VITVo7z3Q9uLXakYT7ftS+qgpzAdjgTJWyw0e0BRAtogVhw3u787obvgF7KcYyZviDMYdLByLZoEiyFdapcA3Y4OgPTBFgUSdDdZRvDZctX0Za7kRm5a8YWgA7xwfExho4N+XOURwtE2PCixpCTO0x8GPo7nb30N5TKXrEls44h0ZJMLJYdUdgtIT7Ha4o7HY5TYRuwaNLzIkLvgn5EQOSj4CBfq/uIw6mB3HSaXQ5UwRq9fB+dHHeLSnsrV4rZr+M8UEtysKq6PlYuMXJ/y1Af2H400SKmaZLaqDXy/iKWCFcBu0T34YBY9vAtwOZ15tnq2OfzXbC5E+fQu8IVSTd6QH2SX5dQrBOQUraMpxc/wNupCODze/fMS0qshlAyqvLiMLRyMlt9X0
 9YX2pmOg
 2qKlwT9xv4kgmFdqyHCXBRpc8k3V0gFxfwvRxLx9D1NfSj5UITsxU+Ob9H9gLK1WoWh3z2sxODOIzLCTEMtznNLqRE1aAZfBL2yqGS9+NFWfWqe4STyK9UCfo+smhIOEGOWWNHYeRTr1qdTYWwuZJeoBurV00gslrXaiZ8PZyc95IegS79WijyD0j6Pga/TXsqxjEZZi91wSnGoqlsCIyEWQXI14w3DbUFK/5580UilMWhrHjl9oKV6kFMpVucYz9p2dMnVLLZiTmdkeqn2pqC1AHzSYN8mwglZlrpId24wyHCMIEy3MNG5HQSxvJH/AGuh3dEWBwN4U+RO4hQVHMKkF8d/WDj/nEnrVYUfRwZTGNbixK4o+5qnqtRHVTCypNz5kmk4p4S1Ln1GpijtyymfcmQrEJVED+qx8way7tHB1M8aBFtYDR+qp07iVYv0dNyv/C+7+NlRlxaoi8JBn0j4ZasR5I1rYdKz1kaCCZv6Hdkit3SRNGfvtd8j27GqtLhPg+GFcmTCrNzKrsAEFzrfmz2p/5wcebw7SOhZ1CcD8fwjNNdw+U3ssdKGGelOFQ2guYRLkGADlrEiHNEG/+KLl5l2g1rxdDWit6OjwxQiIWpVVXPUD45i4naD0QCs2jgSbHJZ73cBn4kdRCPUlkVLi8HePYWo+OU/Ch/jmAwktxhUtRjFmfxtfijR52EIVgxJVCuxSm6Uwbf+P2sIE4J1df8wOdHpV4EE9MNFoqeC+IF5F2loM21lPH7O1WyIPt7upWdagF6ZacAXW9n3gTOAxeH2TXmwzzP3ac+gvdULvwr+bdiESRkaHKisLE0q3TuV1r1sDlbxhfap6zmuLXhk/lxqU7Lk0klAuDrhiBUTveU25kAYa1+EAOHNXzOWEGla9Vz351NvUso/wsxlh61VavswIrFJgfMSV85JjqNug1CfAMp71juIYD8mcjlIhBpjKbqkvrkXZV6LxewAEEcU0SFrue
 QyhSWO3O
 gtXwI/tFDFnp5HwhXiHHAnKzzJFHXrfqGwV4xhdtss8UnfMhzFTP25aMOcbLNp4/zciMK9xLvtRmEPOMBc2HRfRuqBP2rVTtlX9CcsXco2yB9/YGzjhldtxPdyKQ8kc6Xb4KHefQYwoO1AQQinAuiZm1tM/+TzG8nWoGUTZJ7CY79E+JTiYBjC8tTsgrqQ98mZ/2vmJIuFCYMjvjatp+L3DYsaYlfrPNhLk4RQFPUCnHMMwlwysRSR6r2k+OEUkyzqIhJlrpGGbSNoeDB7eTmM/srKyoWRKeELUJvND2E5NkiLaIknYwXX0fl75TtGQwY+o/vZAbu4feR2AJ3yHEYd/XPsAnql8ZJl1b9VAvDe77lZagTviE6mgKvXBshOnWYeatIQ+txbF9p1mPBQh/p9zBDmZjx7QpE0WPGYdKn/zDBsyipOmrG9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than directly checking VMA flags, use the newly introduced
vma_is_mm_managed() and vma_is_mm_backed() helpers in userfaultfd
when assessing VMA suitability for userfaultfd and UFFDIO_MOVE.

Update vma_move_compatible() so it's expressed in terms of VMA
characteristics rather than arbitrary flags.

Additionally, update the use of the deprecated VMA flag API when checking
VMA_SHADOW_STACK_BIT.

A VMA_IO_BIT check is no longer required but that is fine as a hard
invariant has been established that mm-managed mappings may not set
VMA_IO_BIT so the check is now redundant.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/userfaultfd.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 949017e60608..f33b04700838 100644
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
@@ -2146,10 +2152,11 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+	/* Only mm-backed memory can have its faults handled by userspace. */
+	if (!vma_is_mm_backed(vma))
 		return false;
-
-	if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;

-- 
2.55.0


