Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5DECA601F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF386B00C6; Fri,  9 Oct 2026 14:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F7F6B00C7; Fri,  9 Oct 2026 14:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68656B00C8; Fri,  9 Oct 2026 14:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1D1B6B00C6
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:16:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F411404A3
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:16:11 +0000 (UTC)
X-FDA: 85303892142.02.3F87078
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 58C601C0008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:16:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIC3TEMs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791569769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7yzjjlSzlbX51F4Uds4bBqm2u/xB0/1FIMGl/ApzD2g=;
	b=3RbA/LFeXlqhCd0Dqar0QdJotPqoiEApxxkHrFb3cFX6CoV1N/CdlRT5qqqmXVanmL9k+4
	3wl4OIGGrnRmTyKhLW9XgN2whlfXI5W08YYafaTECToSnAkrt2qhKkOjT4PWcEfMXDTQbu
	6aMeCS1iWgy76igJAxDbQYvNx1RXDfI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIC3TEMs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791569769;
	b=OjZ5oNNmZA8jy6kj/cyBV5fWRqZhIj75zUhjjgA1tgd/lgp0d7ArynYQHSq8NG7Dv5Vo4a
	ZHDOs55gE5Wq5tf5aXT3Qy2ehG35xrAIjzIUs14BDaU2kscVmw0HR9pfANkmMVUan+KcAY
	dvQvIwRS5r0U0MbPINmX3fiqgqJkm3g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D66A43898;
	Fri,  9 Oct 2026 18:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E21F0089A;
	Fri,  9 Oct 2026 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791569768;
	bh=7yzjjlSzlbX51F4Uds4bBqm2u/xB0/1FIMGl/ApzD2g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZIC3TEMsbPYeSKHn0ifT8ANm/XzNERdMqJErbEgbnnYG9UI14KKN8CWn0EWSBSUW5
	 vYjx/P7IktTDWxK1od8PNBmxET6SMAQDw8/q5PNJZKbw4hl/ZK3I90PRkEG+e5rg9p
	 yp9V7dDjXlOKZdm2+FxEDRiCQpX+3veCrT5EwoBMVdOgdu8WLiPz1eWpFfZmVEvX7y
	 8iSt5ygzKSpmPmxFgXQ/H8OVr0eKW+GwvO9EcVGdsHVXl0CDWm14HIaQ3vn+z44RMW
	 JY+k5q3DVczHqP3o+4wYm8na0WrzYXWNBt/7Kz6kPDBZkeRehrVWN8QxUIbcVlqpyl
	 64NcF5Wnfqpvw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 09 Oct 2026 19:04:27 +0100
Subject: [PATCH v5 33/38] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-33-923b70125b1e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2586; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VzpMBnGSH2RNHu5Mv4xiPliY+l+0YLYMpytCFKUc+Kk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJO6swrniJ87IlG4rTlWpr9OjIN3+cmvQwVXxRpmtXRH
 rdDL02so5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPJ7Wb4p//89U9p388dqt0t
 d9kYTx+ZZp/zSFTqwMy1Vz+n34zn/8LIMGPBz9BzgSslFYKidLSmKl0WUJj4r9Sre7XCacZZtw4
 c5wIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: pn97z88ngktesr1dqdg3fpih39n6eu3i
X-Rspam-User: 
X-Rspamd-Queue-Id: 58C601C0008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791569769-302517
X-HE-Meta: U2FsdGVkX1+qnjjou6C4m8lntumtFV3xysdL02nw53Q/at9VmCxcmn7bwm7Hap01S1msYJHCHRftWoHhPzZIdHYQgWzRaCg/OVniuF2cHZf8ULuUTMBVSBMcCjwlEjNbSNnhUJlfxk4KZWCQiwq4aqfr3c9roaJUscI3girK+d8FKJcFI6xqJIINvrokeGkpWSO2gl4O7upL9J87W6acvXe+JRd1jhsmGgEiaUQt3py1LTf/xQbBbDIlnrxjpgrJMRRM7uf/mTAmkTYZhx8KDNf97VjYl8G2nu6YfiKPzggWIF9ahK+s7J28rlnxJ6aSJCKkaMogVNtUvHCFcDXUfH8yw9XozX4vYRzsKQv2yIvTjXl9iHDI7DHUZtc1/v/i31wd2yeDDskOsDmpa39fH4x+H2moXznyXfGguHa4eVQnXoyQYdBZRQiLtS4fCUSjyvFRtI15aXxe3ig+NPst4iRcBuIgb5Mhbp9CI3DVKmvnfaCSfF1pADyGShJPRtFhxIhUMDuU8sM03DXlf71EUiftwIVJ2pcR8qxgbIVxXJUyjXDyoryH07x/F0Gtzm+HczTM/hcLlyO84aJ0DhK2aADIrixp74y360h/lJCBLG1umAKs8DQZ4eiop/LJsytOfVoYbIWbRKysUf+9fAyYOIGvaD8dm/NuTldO2qQYy0ld2IhPBkTKgkElpJGymxZEIKSuFxKmHfklk4+Apd1xWSmrpeqGgvUVkVab+JABa3/9mH9oeHL1Zch05JTL0EubqMb09AqGTnUX4qkqa9ErwQ27AYYOMkbR1ESfsz8C2y5BvR8rDQZnzSQjZW+OpHTCcqvTpEix5QIEBp+145Ic6p9z7/e5Iz9PP+PnwsgZjteoGLWtOjmGt4LW667jwK84Q4oKMVxBENKee7L4VawWDSX1CsvmMCJH2/UpVdR3O13xhKXJ+48bUoOCFwpbbL+lzO0yLCtfvyIGrc71lMO
 BCliAYIF
 Yh0M/XtsczKbzhjq7odTW6J7QeM+GpLeeZIF6tZwC9zY/eLl0eSSSmiebErS0AU5txEuHnDD+PbLaLV/caBctXHfmzzN7omtShXA+Oz++FSVEJ/ZdQRs8xI0FL7to19B1DqrC9sQEwaLipl1+bGNlK4tYX4mYx73Cm4V5QJ4fU/Whr0PcG/gg3FcNgmcaxAvRXj0+Le/0C0XwBFnNmtlfBx5M7WDVsrsSxS4Bu9mA3WY95z8f1yQBHAOvJLSMbBOSy5bHVkZXgWKvo2LO3sq6sJHt6JaZhbuxdODdfq4Py1VySbPRpYCvFpKOmMOS7hl0C0GiKksFiT+np/2xPR7SB+gBxF0wfUXdBlBCkp81SK+f7QGQDtmGtnlGME2gDiEg53HDnMg0ts7uaydtHwprOg+SPl0TopEGKPo5SOQkxiVG7f90hdL/lDPrJaFo5Z/caqYJsROTCSufkPGiEm8yFWRTDU3TFqAbsFmh7fPyWX2PLXopPVhVaidiHrkRV7hNF37xBQNNCa4c5jQ/AArMVUXKTIwIheKxHKCtQhrHjrfno0JLnEpHg48Ip5+L0bgVvI/5ouTaE2PFP5SZXXYmM2nZLiIOOnqvyUSzLi0IXleQ6iE6z7EqCegETWqblUyFyaKvSAsvYIW1BabRgpWcA5ct1h6jtOBT+4hxyOwqpjl64Y0Dw0WLXZzCIlvUKPG/XlMghLv9hTJYJHD9SQP48jbCIpNMGsOav22b5NHF7xlmryDjMyqCqCGvNxX5q46BpGypjRWiPXf/D5Uko9Xxbrhg7r1xzGLP1pjU4cV2tS+FxMkkZJsR1CRkHDkFIj4BtWXbQ1p/4mIrhRYZqaixdZFrFb4AkLYEyFKy9hkxLNkgx79NPrXEBQOpDUhulwlnb4x2BTIOyEIp4oj/BBrA/PJofg9yiisOSlckJNNZgg26omM71J0FuFJ3VuvdnD1ivxsADUSkuvbKE52fRRnkhc3x6UKn
 Ov0/saZw
 5YaXTqASYclQ9v6Z2Uu+u9R72VcwXs95QRm0YUvRNVD1JTxp+dpSC9KRKFm/d7NUpBO0ayg/u9b3UwDa9wiTHKhwYPhejkYBISz0wCPZTnI9/7nphtmpIumajRl+8UHK8i2w/F53mhFGuoj2dYjem43GGHMJflZJrnbsboiXokmupLYc4k7XkV0rKHsmiq7/aFEEuOzfACh61sO7dMr7wi3akqqTkMzY4m0ceRemUWzGo//NP2gylMAwssTkD8sQALHSrbMcQM0DLoS2O6k/d9pAJizyr2xDxAI+9iBZfzSTV2Y4Bs5FHNSpZ/nHFage3CMKKokznc2u+7ZN/LcuEBiqHPREQg6fKksu0dSkw9arEH6eCf0FZu5t7/2hvt2dBLc7bgNLdZ8SWgHLaivxtjxfnT7bRC3hHnFiz8t+V4VOh48uAbxHA7Pf5YvU6LTTt7IoU6rHQTRU6kznq5V4tGcEwPd4AaaIPSDiacL33UY4L+W1rtljpzbXxu6W5ZGvCpIQYpSqvYt1XBiNgrnvHkX1afIhh3TrfSQWN4o0NAWrijhYAB6SymLngx2IrjGMx6aKYGSg5VpVy+ib1CgNN6qnIMl+wpb02rw7nlNjLTmMCkmTCzlYTajWv5T/ocCBUAHDuM80nPnizXokocM/U//44oVNupREnLkx4JTrix8I/kLBVgnrEgqme81c9Iyn/JGOSlscMZ7xgVsbdNeWz+qfKRazvhaMaqzgZziszc0YUGBeqsTih3GNnkakaix3N3uPqvF3yT5VldVEbJG3UUsgUZ+ONC/WzXixzremwKe6+G5eR+TX54LgFsvAuC/k85xAsqAU7HfhzDgR3DSD82NkXioQtv4bGXdNi6o6ub1xMPA2Qqp+HuhMXY5FopfzUcBkq8hVsjCa2nYTNMluhPGrUN32jKi5npkbFV5j6YQSUH6lDyicXQB2x6wArCCmolle9E3IwtlH+yiSR62KdpaaDdSr1
 WQjoa/kE
 eCqA0vJ2lR7fGuND+g7V7rvE6co0cp9tFaRNK367qBvLGd05fueKJ7/Rcvy3VWL0CSkTQSYC74nnm6kbgPwySFIVPmxuhEdHKhgpnmWs/DmMX48ORaetlCal4cC7wP5r2h5QcBUYiuZs+9CfFf+a3MaITPKtxVrkkkZem7vbH+dbqhZ/V2iRROdM8yiHvwB+3BxeI0dC7uBH8BEw4K9cteLyDgpBn1IwkyM545iE2JE3bYFHLGJE9PrRs7WUrjdONdfF4ViBIEnVKElj4JEaZp7/Cp3bX+kwjqkHMkn9WsfQ7yYia1kQOEBJZZru7SPQs5kbkc2iM6Yw/JOAZYA5stgO1Izkspsgs8r0d1r6ygmPo61X4j1Cs6mKVBjO2hW3TQPbLNqf5Hd8jUqJJyXDi0RgV/tp5SgeE05zyIT/L4IoegwnKbk/2ZQv3QwmsELMUBdUZB9+1rPIH3mWXkN0Jub1kOu0pNwZnPdR14DdogpkWO+PHdaEaNLP92+frze7PyXVRHtyrgD8Sx7Uo2Cf4lQbqjmzYibio0aYjgwSSa1lp1heV81rtAgzkTvZ1GWb6U0Mz84JObqaop0TZkwM6DyobvELk8xNWDvpzMa/w/cwfSnvTG3dx29S7JwD97Th61GrFCw4+FuuXlntBcGBRwCNuIS3OShE+BqXx7zDZWuXEluZzlwpGgh9kwcaPdFhPe0Bo3GYuCTsAK7eGQIiyluN8lmv9/E3JsLbBoQqnvrZKH8CMSTu/Vc2VwZQCU+7T2FfZZ1rsMExkVvOt8RsG8AzIQa2Y1SzRcBdT9SwxJJYmpKnhzcDuviPw15OSCRZP+6YwpCAsrEj/yb8/lwyB8segsflOlf0mo2Xl7CbF01Kwh26kGwWFi6Doc1cbEgZFBnFoUlLfffCMzvhGMplT0Pi55f1UEew7x/iltcD22Hb/ldUcbSNh7l1N9gfh8RoaJrHcBgzjgB7LOVaOevCxgSLFLMEA
 S+yimmqe
 0agTvgwwrF6tSYtj68AG1lXDPBo86ETRps9u5LCtJaL5fmsCw4am6HtnFrfOXHpJ+rmjLwL5TJofcdZMaw4+/Ggk7MsjpNef8t0QHRhBHxBvyrvm5NTie4W7xPCxhlje5UOS5RycH9nnFNy9fkCBvSe938ep6CwbCR2mLxXiF03i5iYRBg+cbu32U2njZUWehqaiAXDY5s3J3D5xMKTMYU/Ds7Q4iUxywW4xNAQ+yyDI4l9Sg2RDppaE4ji1fw+AOG/Ri6PTEMDzXcECcAHWVL7ptJZZdpOOnvUXdECubmZyqT/JrGBzAcUW7v9FbzBqgrxJMVNxViHxkGn3imSSlc5eTHrU3wrCwGTsAwno5qZDZuNLVnNUzwWDQBQv4yPGYqbr53kiN0tSfkxc5PcA66KGQfuDI2aufi9s6mn8PwNfEpoW/6/L1Uxuzu4CQI0pNOd5Fv80m5n0CiVZ7iOl2yvs1R/J5ed0OL9jaK6p0TyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is now an invariant that VMA_IO_BIT is not set by mm-managed mappings,
so each existing VMA_SPECIAL_FLAGS test need only test for
VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.

This is precisely a test for a fixed or non-mm-managed mapping.

Update a number of callsites which already explicitly handle hugetlb
mappings.

vma_supports_mlock() and ksm_compatible() also explicitly bail on droppable
mappings - excluding non-mm-managed, fixed or droppable mappings is exactly
what vma_is_mm_backed() tests for, so in these cases use this predicate.

should_skip_vma() tests for locked, fixed or non-mm-managed memory (having
already excluded hugetlb mappings) so simply test for those there.

No functional change intended.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 4 +---
 mm/ksm.c      | 4 +---
 mm/vmscan.c   | 3 ++-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index b5f7be8f65d8..e57c35e5f90b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1112,9 +1112,7 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {
-	if (vma_test_any_mask(vma, VMA_SPECIAL_FLAGS))
-		return false;
-	if (vma_test_single_mask(vma, VMA_DROPPABLE))
+	if (!vma_is_mm_backed(vma))
 		return false;
 	if (vma_is_dax(vma) || vma_is_hugetlb(vma))
 		return false;
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e12..ed66a90e0031 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -747,9 +747,7 @@ static bool ksm_compatible(const struct file *file, vma_flags_t vma_flags)
 	if (vma_flags_test_any(&vma_flags, VMA_SHARED_BIT, VMA_MAYSHARE_BIT,
 			       VMA_HUGETLB_BIT))
 		return false;
-	if (vma_flags_test_single_mask(&vma_flags, VMA_DROPPABLE))
-		return false;
-	if (vma_flags_test_any_mask(&vma_flags, VMA_SPECIAL_FLAGS))
+	if (!vma_flags_is_mm_backed(&vma_flags))
 		return false;
 	if (file_is_dax(file))
 		return false;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 12ed3388ee41..3b318efa2916 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3477,7 +3477,8 @@ static int should_skip_vma(unsigned long start, unsigned long end, struct mm_wal
 	if (!vma_has_recency(vma))
 		return true;
 
-	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
+	if (vma_test(vma, VMA_LOCKED_BIT) || !vma_is_mm_managed(vma) ||
+	    vma_is_fixed_mapping(vma))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))

-- 
2.55.0


