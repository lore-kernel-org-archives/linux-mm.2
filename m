Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C29FCA601F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0196B0098; Fri,  9 Oct 2026 14:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F5E6B0099; Fri,  9 Oct 2026 14:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22FCC6B009B; Fri,  9 Oct 2026 14:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D71C56B0098
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:05:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67E14A7CDB
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:05:21 +0000 (UTC)
X-FDA: 85303864842.05.0A44C3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A12724000E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:05:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oufl86fb;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQQXLmuz/mYy2m0DRCE2BDh2jZAsmGDyji4q3SA7eeo=;
	b=7fZ+//ifcS4lv5gJgqiU4fK1eyKoGhVmA/yj15V0L2VZIgthEvtoY1dMf46aQVKEfuG1IQ
	pjCDmZ0PcC8TUVTwstzs3lQtXntBF4ViLRg9gZB3ObpdAkBQUKl+6YXdU73wpInQt+BdNP
	P+dTQ8rzFZxpWlWePecOl+j2VQRWaIo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569119;
	b=xwtBDCRpfQg2+it6VkXxbUi4UmnJBAs7NCFGu1Ki1bFbYfdCgbfo8cFMIVhzfmVdfXhlwH
	hY7JOLwz4/QESITIL/LZlIgOu7aOzE2zPdqtG8r3mpFxYaaWtKtnZQ30D4qPJYamOEsnA+
	+VcZTObbhOhdhwCEDcy2qvV7bQ9w1Pg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oufl86fb;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DD7460267;
	Fri,  9 Oct 2026 18:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C551F00899;
	Fri,  9 Oct 2026 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569118;
	bh=XQQXLmuz/mYy2m0DRCE2BDh2jZAsmGDyji4q3SA7eeo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Oufl86fbt2wAMOG9DEe6vQCDdDu6UCXD/ZnvQm2HoFPixcMuVu2mgzOhW2AXaKo3Z
	 W+Tz8tkgEWviZ36e6rwJ3g1a/QEsIfYKlFhsGkSDhjcZPAyFDkhBazezZ1QJmaebEi
	 2CM5qZyGRLv6Mlm7RTjrmk34GEg+40aTZmy00x3a45OU93Xjb9EPoD9ccZ02su4J22
	 1t6y1WkTpRnppUH/Foi5HDpc3eifDZFtEYGTi4pHIU/2rwzIg0tQfngRO+jQdS2Ov8
	 9ae/7Av09LDM8kKNft9z7VKP6Hn3enauekx/NqwpAylOu1kDGBKgDSwkokTVvz8gFK
	 WwJ/QZtcmbHPw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:03:56 +0100
Subject: [PATCH v5 02/38] mm/vma: introduce and use vma_[flags_]can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-2-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3865; i=ljs@kernel.org;
 h=from:subject:message-id; bh=EYqw+AtDKpEde3pCckMQkm9HGGlkplYL0cvv0S5EwV8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6sxYqncsy6E/QYnnXbSNt/KVF3vV3OdnbD4W3awaF
 md8Miqyo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNJX8Lwv1rMyX/X/pmLa3kq
 fPdsfFrlN5Fpbln4sxLn8ydTXRjbShj+ZyS8Ob7Lbk22Ybn8+Ud7BR5nS8wtmDlh+a9T5zZrBqd
 u4gQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A12724000E
X-Rspam-User: 
X-Stat-Signature: qaym8rokds4di8rbpjokssxfwh1i18ac
X-HE-Tag: 1791569119-89344
X-HE-Meta: U2FsdGVkX19dELhiiZ9X8prCJNq5IYToq72O38yXBB15Y/JXnntqU4GOBhSQa6NtAuiOrH1/jcnnfHZu1kTWuarcAges9nN2/NM++R+ORfunVO2vuyT6+azkk0KEzUYthuV8NKeCwna1pVJghC6mhdNikEvhKA40WWcBgxpkWoPBhfEcnBM4tqYCJIknWuGNj7OG1tXVmpJDpaUusqKeNuVMrGzcHymLgb9awoS3A4hFMRbf+nq8FoioN7i5fRhhJEIk/i0oASIyw318o8lg1pM7yf6oZpWxByLSjC7xVQDpbnf/fQ/VIdu5wOsX5RTnAwFjddIDWqJVwhUdfjXdOByu4SvD/CdkLQfFCGO1LV1O+AhRvpPQyZbMYiXLN+/ioOh4Bo51UCgkvwbqqgAKUjg5WM7pmM/P8CfU/rsYZLY2XFm2d4hIRzTog/VvlY6Mn2kgTz5fGNZMID9LHrfdmwkFpT/ZVNvo8xTKZ3BdU2EgHmaa7TMJN/WECmLTyelu/T2OzZbJEC8zorHuCruS1xrtpnw3CiNKqhVtVbaH2PA86C7PPxmNcshY9ihHV7ek4HyZc5K/Nu+iA31TZlPM2yeUj6hYfhWMFDinGiAp/++U3Xsa4JcAinPi8TcA8jIZZccqnOmAuEM9VqCdDJtBYoKCT7IdR3JKRlMUA5jcNWJLT0UDIWVlbQSb/qHDSo7aXv+dtIpbJcdID0Que3+bfI4vvyXGdUp08KBP14fjA8N6oC9lJhUC/PmBbI9eTGJOeXF+mjSDBERHtAIXFTytPSvrdZrpiCpapltcLtzicwFG3HwiH/FVlH4UGBSdPi6W6aEErBCoE0N5ZkhcIvjDnOZBMo5I58xvNdoHlUkkmEIbeNr38MVXIoa4cjLCq27wQCP3ZAUAj5+I68vF7ElrWWn7OfBFywyNTYChyHLCW9NldGt0x2OtQiJfwpPmQa+UZ+cXUHCAUrjQ5aTXHd8
 7ujoMMO2
 bVop7kz4y+qQAh36zJG8nv9Xs0hoqAeqHdpn4+QB0ewB2TfTxlBllYOTgfZ9UyWmGSTgscX064DcYUeXJpCQK373XEMam0xZIugUvtsch1q+QYUWdOWVkVE25HjL55B9lV9kCQ+5OLJm/A37pIezMYNximjX4tPolhliST4QeP/8iuua7qzfthT5SUyJUGEfuh5fuvVA0LEWsRC4AtoDFGvfFlD6/FH0DdbmejmEHarcyEbjR88/qPlj/kivmTBNKzK3VZheN7QXgPGv8I9OYqWpDReludi3i26561VYubi96UIXQnV2Ri86Q/O20FFqA8pmzx8P7EJmWHSqJlDnrZgbdlW7HnD2ZBVnNMR9t3gxPQpgVMg9deXL5DCfsV3YbQ+I272uyXcPUkzrg2T+A8d0aXzF36/QG8wgMlWyROojIB5pidLWOlfCIjyo+C0TubZN/ODbmUykiLPGISMSNJuX5SspXYqJYg0AJnEy4VyhDR6Au0wSmnMwuyGTr+r9BkLLxjbkBZxZgd9RN7z5tX7KZCkvnpo/fpNs3MB8ja1C6eipgdMF4KFHYxOvMuCWFHOHoNR1hAUjAI0b3O4nnaw6fU2V5+fSMAQ1HIjEnvjAbXcybRBS66HSPkbV/hi7wyj3IwwVhdFQ6zAZxOySi+ic2dMX3wh3WEOt3hbIVQJg+gmvk9ebcdRMIv/Jqo50kpKYO8rfxa9O565e4o+VDWtBzOnD5IQo1NgzxL4AFJKDlYB3UiP3B64E8tYoQaR0tNvCE/wvMYPuWI3KQAThEpbXJKJugBj+hi96TvQnqNrIULPNHO0G+Bv3FuzV2VmAEjSO65bzLsTSngUmy7drKg3aYyGbIdpKsxIo0YXQ0/gBxQBsKHrwydjaFYnTn4kr1gkUe/rkg9njg/8WqzOJVzkRHzsjmPw/+dytg7V3sRBGIWX5wm/nbodK0CAs6initc5MZDfpHhupY/ML2mqyiW9WCG/PJ
 Rrpfsjnq
 O0rKh0laEgb+aiuLK/mLTyJcZ2dqUbgIUGT//ZlfUaSyjpKvPEvUw6CLwomNR0H9r2p7K42GqkTbVShPKgPOXTuyp4+G0XE/kQDlq34r9uhUHe5JUpaN/f8qToYKqMOkOjeziCyt/gRy12ZpOh2UBtZLkyOyrfMDST9mtfEIfqCdq7bXAHos/xtAcw4DAlhxt7eeCG5b8ealNsWRJsGZWdrL4TTTv7E9/Nl13UxPn12LA3dLHvyPb8QzuMa1xRRDbtcqMpI1shHmW6f704UKMOpyhyWLUI+YvPhWyslJ5BScJyvmxTeGutb/r9mpl0kiXX9btEkoZVf8vXItwH9iUD/HxfRGt36xynermnUsVCJ4YX6M6G7zmgJkY+eWZXiv828a5mvs8mU25wZcp+k8onYk/x0qRHaCNGozxPVBTAb1u2KfwBRLyUkOBM2lWaiPcoFzVCrBBrTNGiLfmqNaFUVpp9+VguqbmQ6MzalAxY106hP0vFDj/vOZGuSniAE5ci2Ucmd23/HvcPodhCKIB3Owm42VSPtJm46MybEVcZ1zY8UtBLpQ5vKYxoYoWOq+x3/TP9u5C5EY/NEt+C+HuJ4qIDzH8DdCfbbY0kJjeVyVZHl1tu5IauPj5aWR1LDswBeKDu+gNKBbGgwaegZBxT9MD0T0VE51vt3VZ5ydwBXNTObdszLHh3HlfiXt4jYDAQ0UevKkwYYAFsC55pn/fQzdEsohe5diUKOBF1Nr2MuyDEQVOLro4XTLqAGHHAuWnh9D6xMyh+BdPei5Mne1Aid4m9JjLfbJ9oDlLnxn6uf6YirSbyQmRBRtAAPL2EPXYAfToppKP8dsIrzkaA+CbPO6+oZuW8As0mOMFswoiDhT9H0tzVcYRzcG9kR0e2/xYjQPsWb9+HM6NboPoHsBmnOLAOb6Pw8+KL0Jg4IP2DNLhEmV0N4z4+w4T1xDnPO4nfG/STom6zP4AupTjb83klOvvKo+y
 YKvLafQb
 T4Fkf8tdkvaMf1r+5JLKyBMMteM7wj+69fOuhqqcbu35cXu6oCrNgxOkiaq8TIlo6OexGjKEklHOGIWk2T/TGUtpDUzezWq+K8uhFL887/nY9/8Mg1dAFrSbeEBM8LweHnN4GeBPKxxswHU5FvF3omJlYSsJ1LTqrzLVN6F7Ekpknyevs/S69Kpx6o4x4+OtNe4fLifdIbz968ftchiXm7qIeQyDR6kGFjJBYR7vQKPd3O2hblvRI1IJHOsx+E7LUG5qw9fMkgv/xZYra8VAJyh19j5uS/gfOSgU1vNGDEALHnKSFR5d42/defp9gIP3wQv+pD34hqEgT7qEeM/mH7Z2yBMJNSBLPnDuKJHkRCCfx9uMFsvlSQArJW1vIomNQn0bbkIo0EDfTF7cbA+JGCPTyfUd62QaXDlQQDa8wSTm0nc27SnPDJiKOmVq3GsSY6AnERW7n6OYIZZhUAku0hBlifmfaeZaNlttGx/38wHJXilO7Y/BP9yLVR4fJaxKFwqdpxbceqb9vdmuxlhOLkYl9eSmOBQamuqXvvrE8LKmSM8SuGA0Pd0ZOyc6YY7he8YnuyyhjcDL6LQDBO0MgKIH02CjX8rS/VZoAPpP0GgX7BwMauzV/p9pZvyp4299re8OtuBKxcxkjQW0VP9UnHaYhr3+r0D5u9PfpHiq3xrNkubMbMuKQcgrgULzrVhaLM1nzXJjHBzkICUd39zyjGgLVUPViBTQh8EKOFAdTjh9hrojZlmyp7C68tCTBb3+oMJDVnE/TbXtPZ8I+Al4ka/pCM0zA9FawEcB8rRAYxAr4Z6Vt9slNcGN/503JAr3Xa2IaWHowZyauVB5VhTL9qbc+cLGfH2nq0gNrMqpeU4YrOk7exZ2Jr8tqfRtbZiGWeT8J0zVlOIKMYrSsJ8iNeWTIiAUT82a1JdmzYuuvVGHxy//WEufNTJOqGLbi/0FVyh4TroN37zPIoUfW4RGD5wLVRXmw
 S3h7/jdO
 1rnnHyX6I88PQxvKIYUtsHgSv5aaiw78eD+L8OjnTf9auyxDTdd6qHL5J0hhqGH8YlllpwGQpo7SmTphWW6hEVcDZUFHAfhMufNYUJm68FfkoqQ6Hzao704xpV12TRMECcNhg7xE9ZzWKodQZGrmNWr//okWmoH2hcnkyuIZxhDvAiZ3DJjV3iKTh9buhxf5JqGd146bwJWw1cPKBgIB5Uy0GnqWRzRlPwe3uaHLMfv4wslhBvLPGfiLCvINiijvx46hrGvdkOmfyVXGdEPxp+eUrDR9qgyTOOM6ej5rSZpM3A+2IWWgCTDs9pmHGzKppoqyAWmDXGA4S6NtNLOtpPl3ED6dayd/Ley7UqRDXBA90TADVXu2snnPmhTCe8KjOaR3BFgTqcx3g+GFz7DZzfy5449r7mSawKC9X9b59RPs3QpMAbYckzUBlFFdoC1jx3wsSpxxVRcAOThyOoZqtZgw4Soz02M6qzQfeyYQwRJbaD3ru9oNUzSjkyZnvryZgwf4ckfwz5DNOt5xbhpqu7stLZPtb+lzl20wAFSVUB9ynb6KdJKfO2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
two new functions vma_flags_can_merge() and vma_can_merge() and update the
merge logic to use the former.

This abstracts the check and expresses it in terms of the desired behaviour
rather than an arbitrary and confusing VMA flag.

This also lays the groundwork for making further improvements in VMA flag
usage.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 21 +++++++++++++++++++++
 mm/vma.c                        | 19 +++++++++++--------
 tools/testing/vma/include/dup.h |  5 +++++
 3 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 969594074fd2..68250ece4219 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,27 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
+ * merged with another?
+ * @flags: The VMA flags to test.
+ * Returns: true if the flags permit merging, false otherwise.
+ */
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}
+
+/**
+ * vma_can_merge() - Do @vma's flags permit it to be merged with another VMA?
+ * @vma: The VMA to test.
+ * Returns: true if the flags permit merging, otherwise false.
+ */
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}
+
 /**
  * vma_kernel_pagesize - Default page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/vma.c b/mm/vma.c
index c27aea6d58d9..8f8c554d5c07 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -924,13 +924,14 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
 	/*
-	 * If a special mapping or if the range being modified is neither at the
-	 * furthermost left or right side of the VMA, then we have no chance of
-	 * merging and should abort.
+	 * If the range being modified is neither at the furthermost left or
+	 * right side of the VMA, then we have no chance of merging and should
+	 * abort.
 	 */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!left_side && !right_side))
+	if (!left_side && !right_side)
 		return NULL;
 
 	if (left_side)
@@ -1152,9 +1153,11 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
-	/* Special VMAs are unmergeable, also if no prev/next. */
-	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
-	    (!prev && !next))
+	if (!vma_flags_can_merge(&vmg->vma_flags))
+		return NULL;
+
+	/* VMAs with no prev/next are unmergeable. */
+	if (!prev && !next)
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 16c09dac59d9..2fd422789717 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1647,3 +1647,8 @@ static inline bool file_is_dev_zero(const struct file *file)
 {
 	return file && file->f_op == &zero_fops;
 }
+
+static inline bool vma_flags_can_merge(const vma_flags_t *flags)
+{
+	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+}

-- 
2.55.0


