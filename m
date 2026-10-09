Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775EBCA601F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703436B00B8; Fri,  9 Oct 2026 14:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DAE46B00CD; Fri,  9 Oct 2026 14:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA7D6B00CE; Fri,  9 Oct 2026 14:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 305DB6B00CD
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:17:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9E9A1604B2
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:17:55 +0000 (UTC)
X-FDA: 85303896510.22.8068562
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E3C26C0004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:17:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mvzi1fiC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2aQUzTUuuuNI/ysultBnvmSy0Vxb53qrqOM+R0btIA=;
	b=ntgy5rsT5zJ2N1Jlf/I0dpUEIVTKCJsM3v2FvRYRBNVGDzBDfRuVtgFZjmUoKBBTPWXMQV
	iSGnztEi7JB9vXPMEgHD8baIzxVZjhFEuNxOqAIwW1vxpbNG6iZwkiBW3hj9QnIWXxtQO2
	J2yu5ewgBZF4ouXA88qL5jYFqoRxQNM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mvzi1fiC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569874;
	b=gtzTQf1hA41B9L6fW7/33kpvQJtk01XwD5JMVJxdRa0fK01Hfd640PQ01upNyGWLYdpZdq
	HiqW/upORgyoJM1+AjT6l7p0B037/+6h/O1ku1mLfPQvuXA3Q4JUmZbE1C9OhG/d+Szzda
	Jwxmw2YuSFClUAT1cCn/xrZpE13SQXg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AC74429D1;
	Fri,  9 Oct 2026 18:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799181F00898;
	Fri,  9 Oct 2026 18:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569873;
	bh=Q2aQUzTUuuuNI/ysultBnvmSy0Vxb53qrqOM+R0btIA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Mvzi1fiC6gX/l2jQGIwOF7O63+WE13HT+q4ZHUAMv6JVw7qL2MDphBGUkkO6YC+Gp
	 M9+AcJDTYwgzfHItQHapQgVC77ka1excAet+KIgzyS/z5TqMW+YLy1mXKvqoIdGfIQ
	 te9hu5V+MpJ1mRea6WG8zB0aOEb3w9//poav+TxQQl9lQvL3T9KVLtjcMcV62r0Tjk
	 pZjj8iPIlVpbYKwaSWPGhValW8a40mzLhunv3AiK4J2UGMS3ntAEtUkKYtoLG1Dw4n
	 KXMb7Uiz862SqCAVEegs9wOrsfyCd2UV/GPj5hsvhhw1oFdq0wBHrAtFFrS8s0a8yU
	 ll9X4iU0jG7ig==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:32 +0100
Subject: [PATCH v5 38/38] mm/huge_memory: remove vma_is_special_huge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-38-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2917; i=ljs@kernel.org;
 h=from:subject:message-id; bh=I2iSzq1wq3BUA5ngKyuzaIh6bRjYfHM3M8Ib2DX8Eao=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6szfWj3ty7q/pguW7DpuZtT4jElWLtS1uyhobZze9
 OafW9z2dJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAih4oZGY7W1nnvPG33iTuv
 sX7rVRfheG+m6w6XN7fGfTlreHDn7qkMf6Vv23es6UhS+qaT8/NXQxXPhBvTt4tozmYROcvWdel
 NIAMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: E3C26C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: ejfno6pfp3x1cy9gs1y3j6f3ytng4pfu
X-HE-Tag: 1791569873-891817
X-HE-Meta: U2FsdGVkX18mXN8nzD+o6BDtdBG7dcfiM3nobZtz9uKqPP9bULaYV7R6hAQ6cHmlwrLzWcjGyrujnHh+6+kmzrPPbv83Wh/utpv0n3j4UPht3AyTt1LokFxPCzyjvnm7nJDsfGA7FzyMPL8W3HFo1C0vYM0JCksb/4eR2GjtZL49SpntmvnUD/74CrVfl+kZEAmcZ9uiTlHTsnmKmGxhNKkXEWlfKI1Ji89g68Yd1ejhaomo9vXoznizH17cphVO/zo7uexH34idwyTdRQTcPPKLebMFcDOSVWzXBTxE35Ut4e2F1MofIN5zPzVW3X/7AQzPbtztrUQnYKzg0GmKrpymM7aMuw4Af9KOkOtCTiAzu2nbS2OIENfArtM16T7RIeKapO520KZk98SIL+sn91dMHLqPw/j/mWb1W1rOxWrD5pIa7j54GQSdlPW0V5P5FZziCh6/HbFPJf/7NUTBNpyM8G5sT1qCKWmUNP+jfhzJNg/+Vo0E0EpZFwIWV/1YIlFOgU6sTIGrYDrsueJ0MhODRfTGr/4xuHFzxjJ1OVpt0J+djl0vgI9mLDXTa5Sz5hM47fHKRN41TA80h7U0ac+F4rtOkY9IrbBw1sYAtN4wgU04IIOGuaDSh7/2xpIf3AZtSiRgt/LazjSAngN7ZXyp36cBsr4sXn/u/pcJjNKjnWf5Fzj9mfo7jh3SoI07fr8p2qMgbZKt7cubBZcTna3PSpM3VzhidW/6jDJADel4sfK/rNMyrxhgTEV0apOEGXprPMF6KpTVyZpMmabqlYZ4XAlvkrEcDwC99JZGXjhdICROn73vXu9cPBuIo5rSIe+6KmTkx738wwlbWTasnXVvhaMCvMsoCSUpNHPpHJ7cJWfse2VFBBpGQJsWm/2eFkRDUARQ9Mge4mrB63ogMW7GMBCLVJ4xNTPQhM7sdtt4qGOnXnpRMcAlPS2vN935AifF+d3GhNQ/ZV6++Zj
 7HGDPEME
 rYheHgZRA90E1gewmpjuHgnBN+bVrs8i1UJfx+LWjxaVkdFMHt1HwfhzfCK30rNoqTMVHN1Fmr+lFGEXQwJGNzP/eoRYP0QXVrYvq1EYDm3nOgoWL35ne5zLVtK8siltG91BIBSrw5DuOUWUOSi7vvjtCG1OLPp2WS/kL2HcuE62dpMgg9W+L3uqbnsM6bGN96aGRDYFBh9UeHmHkxC4WRj/Sp95YGoTyj+p274dAzrfDXj8MMl9Nfew1Dkt0oFgqambC7cMrWB9ndPHvDkUuXeOJuo8SVhaIiY7ZKlue6pzQcQT4Ifg8Z93AVcDNjGXrsgPJozGcF/FYHpyLDaZMwpFdCwpIvpSAwStKGeT0ZocIR53FcbNLh8e/BTxX0x6/JkgsFwFqNN29EhxK9jM/rpZwVeNOOzzmxRIzo/oeBIpgWrD4RkQ0dsPRN876CBwMQa943RBU3A2g59WM35I7l/E3YEcjsxizdQro1Mc6yO/unJBtCxr5Hqq/6wtvYjm5e6W88TduNtXk2gn16omaSBhBlpJfsldCtap10zJdBFDcTRmQ9y1fQVg8yv0J2dZv342NrL8sVExBiPFYqZPmpiD9C3uaCBvNRKb9/rD08gHOEWlRyDsibv/YLHq2a/1Vee21u5LaptuYIF3fDCGzzKUWztYMK60Lq4rQlA66i0VBIVA4iBPlRxxvucbwzACXXnHyYxtp2fmX8h1GCPJZrmty84MN+pWG+m1gRokxWCo1SgJl1KD3Wet4V4SiFs9wAydVIowe1T4HvdBsUdp1Zh935Sa+Dwbb827ZB13MMLVR1rtmDhsD5HSbqslcAcLvxfPl4zuxJoFFJiupWcGWnq7VkCmlU9S9tjOoK168hAVhkI7j5I0golQFw/ABZ3TbTJ3gz+OxIhAvjckYRlsogTfq5D/faqa9r9GHKxw2CJREez7WA4eCe2/NW3tRSOD86dpb+nyph1FFffN09SsY4tU9qzzb
 I/PCFQfP
 aeT3azY7YBf5NqnE82SeLRdofEGP1nFtYNlV5xVEhSloDLo0UIy+rn5htong7SpF6u6mdrYgEgNuCa89lhT34tushn3lT8r/07Ul7LS7c27UAuOYQjmW4lOEISBoptbPd9liIR5GWaJp6HEAgnYrTZLwDG4/jfpiqaiP+Za8c+OiWBSjaJ7kYBlCoMVarxKrWivaBT6DM/phPU499gNs2VlzTLfbtDwKOndfGXmgZPtWkdPmcuQZna3L3a+8iXTPga72JOMXJz1ykECSivSWYxP+cglw9P1n9/uxLl2XIl28vUp8d8Lv4RLX3X+GHHIsi22Uad1bY1bmyBwLM2p/AYtVjj+7zctf1FDMUeftAJAOEekMSpYaXxLCK+gXmQ+a+RdogV96pTOx7Pl/eUA6WeWGae6tudEsWyrUqzYi/cXRv7QiVO5DTphON4Sl/nXjQJLJwXvRKQUWYOmmDJfvPzjyt9A/j0rO2bjjJTZs9I2sZdZzN6jb/CODmQ22d9ThWt98NuNGJIVfCR/gYhWS5ZdlD0WJRo3jvOi5bp/ZicfY6J4WUK5TOwKPg0v1OQIJLLT/0CgxmuegMHtSSD5BM9KcjoRkAwtJqaiDOk37bQNhuz4DJwd0PBVQEDNDHKd+plCRXyRYHmjcBlZCPPj5JLyyYAQz3ImAx3wu0QQEiFRyaWOmqHPm0aRdmKQ8bie12AQrxlfouCPzycyTc+8MRusxi1mGTpKtR3xkxkPCxnATaEVanz6wrFRcgpXZjzhBld5wsoR4Rpo+z4XXUQlzcvEKyMtPcfl7pSAQNbHyOKkSElZKnvrRf76ABLc3dlHvPtlo+B69HTD8ta1dI2WDpLJy1yIRNXy4hjxvTWuW8agET2mlmSVyXAuvmzfxJ5J43GmPtsjxsaFsZ0Vd9KCblpjMdJIVyqXkqveQA7uOGtER5p6XmnBQBXRZkTH1dcoe2+hYRYInrw4FNKgJkWPKNOSyM82rV
 +MDihBQ1
 FcDS2+OqeVxHLGWeSJBueu9ru+Yy5uyuJ46raORaySzHkxIOqbYQPQJOX+LAagsRfNbFigEAwsXm1GX7RJw7yKvEamrqrxBhqJsdNq9BNlkqVRnOjd+gXFgD6XHIz8skA2G3vA7cMNvASO33i8QYR78bxSV88/QZ/O1G8ffZh5vDHMnFWoE3XDTcy62nZgU47Ay9HZh6+WTtWJP8ru63LmjRPaSDa3U7Ji/acv7F0xgkd/hnqK4nwm38Sj1rP9qcHdO0Lohy6A5jfmlyw8Bj/x+1U3uSeOPGMMA4ABlSr1vFEGzE6iaZpEcZJNRd/c0n8Eems0vLeYavJcb8J02UWQLtlTMf+hhmlO1dfNMddqUcy6hjuA/NAmhTy/Qcb1pnJ0yHhJqt7ybIjJq5UCimakvsnRBx6+wiAXK6JGR3DA7GXyimZP5dgoz5dSg5TC5VZuMo46Xrar/ywvQklPNp3lYuS1kfkcc/fZpCab//XgL2+ehcgSzyuylc6vEG+icpHnFpcVmGw/OL2BzSz8b8skSspgPQsR61QjPEoLv2BYbp6npOzILldgJsMtKkoUaXFFlphGwLCuvWBTZv8LqTCm5Juk/kwSutWat1MpDjSqLAgQuEpkKw9sXUjse8I7LOpbV79Um5DW5dpohq2FaPJv/7SYEvR/XcKzwoTdSMuNlCf9pq458b8KP9fUzlIN9NX+GQdWxcbM1erDQTlnyMsozLfiChHRuPNDe5iUof25j1ritblQTxB/CLTWALPoeBXNOJ08AWToA0OM7onW7N4YITCbqzvSZSjE1Fi7MNc9AQzDh4QHDGCuHy7/dIJ7ji65+g9YHFgWh+5pOj8I+jHBMo4PWEOOFBTjz7nGhyP6u5zrT79dUih58BO2Tnj6egCVYOXjUN5japBoImwIETdsV8M01wEHSK4+wMDT8Ibh2ITRTjIN0iTU5bNhmKs2yLTISHO6P5v4FnGNxgbcoNtwGdQzSuu
 /Zbh9MmK
 9ZVNdDqpnKauprrlfRj1ytMBs6yKzBAB4pP0227H3wwrxktM2BjPt0b0APk5fmvgesAdkQWB6wWZ21wTmGnOnO+anrbGO1MT+OpXOOiHApt9N+rkm+TWHJ6iHKp6f6o8oSvnNCllZ/1NZGEG75b3WnZMLmYkHWmSPUOifbVR1xHoE0BhGuzZfb5SlEwVxACI6seZJahIYoqhQaFUXVLMJvUZG2XexAh2zdXH/NzD9YwD4gdI3wN98mfsPrJdiFbo7gIigOKZoQnkGd2rBeY6WHm44i+Rw2VtAT0PnrYKvTMMcX1dYVRuKRJjFGmWkX6yNlH02IIwytz3+g+6WUpRZP8+8K4YtKtZ3/OPoStmzDiH02flkn3xiDryABIb1hqzaPdl0UqLLCzr4ciSsHi5UXkN+LlV+PdejpQVUbzaOVp+uGhBRkgbYCKwevJoAshKAnkAhnA67qhBfcfmMRg2uz1CaQNuJoLeIgp9FZkDi6yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is not mm-managed),
but with a DAX carve-out.

DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no longer
required.

Therefore test for !vma_is_mm_managed() instead and also drop the
VMA_IO_BIT check, as it is now redundant since it is enforced that
mm-managed mappings may not set VMA_IO_BIT.

This also eliminates another overloaded use of 'special' within mm.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 83dd63b04568..000c4bb50f71 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -110,14 +110,6 @@ static inline bool file_thp_enabled(const struct vm_area_struct *vma)
 	return S_ISREG(inode->i_mode);
 }
 
-/* If returns true, we are unable to access the VMA's folios. */
-static bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	if (vma_is_dax(vma))
-		return false;
-	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
-}
-
 static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
 		enum tva_type type)
 {
@@ -192,7 +184,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+	else if (vma_is_dax(vma) || !vma_is_mm_managed(vma))
 		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
@@ -3066,7 +3058,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (!vma_is_mm_managed(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3222,7 +3214,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
+		if (!vma_is_mm_managed(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4765,9 +4757,7 @@ static inline bool vma_not_suitable_for_thp_split(struct vm_area_struct *vma)
 {
 	if (vma_is_dax(vma))
 		return true;
-	if (vma_is_special_huge(vma))
-		return true;
-	if (vma_test(vma, VMA_IO_BIT))
+	if (!vma_is_mm_managed(vma))
 		return true;
 	if (vma_is_hugetlb(vma))
 		return true;

-- 
2.55.0


