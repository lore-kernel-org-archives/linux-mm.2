Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 825DCCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769756B008A; Sat,  3 Oct 2026 12:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719CA6B00B3; Sat,  3 Oct 2026 12:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BB8E6B00B4; Sat,  3 Oct 2026 12:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AB116B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:39:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0B47A0970
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:39:10 +0000 (UTC)
X-FDA: 85281874860.02.F4F4B19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6F8340007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:39:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XlbF7x+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqpk9MXgaX25nS5Ys5rO6UCVR/iTsHvR4Kg11ITNpTs=;
	b=Ixw8+tRTavXIvH7+wKvo29lHREPWFbUrpe7qRokH8mR9ey/2WxOmUr/McxuL2DVxE7NLp3
	oziiVLNXxEvLOFWXqOarybIbYWqz6sKkplophBnFTssh/MYN9wVX5YzVyHuDR3qMHLDIHb
	WbzXA+mVmTn4HW3pktQ4xsGHXhTIcQU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XlbF7x+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045549;
	b=HJyuLjbGlosK2PSuVMrFQXQ915eJAIpUA29/2OZ64EUGOMAZrIO9ri7sf/f7826Ftt9gky
	LOSdIeSknUgkLVoxrYQ4lQTFILdq3POa3FukZO0lZmwzKAprGII2xK9EAd7KdHLol7jVH/
	8YcOgyxcFdthswPyYofJAyt5indW4F0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EE7C43B83;
	Sat,  3 Oct 2026 16:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEDC1F0089B;
	Sat,  3 Oct 2026 16:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045548;
	bh=zqpk9MXgaX25nS5Ys5rO6UCVR/iTsHvR4Kg11ITNpTs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XlbF7x+AF5fxK95SLx8EO/qqAYH7hiq/jlVD3oMyUCD91daS/5Vhb4XQykoYRFpCk
	 HQE35clU8U8NmShkKGPOXXm3eJPcfSvwPleniFKD8fDK7SvlFUB3e6Rl1vMsCh98T8
	 kGCMqOra9qryvd6pdZE1zBg9ReOf2oQQqkPSkE1A3H94q6wOs+3UaZvxOwUvsRoRGb
	 XhbfbRd5AOawGf6Szb0NtGri8Zv0xvWnbnjJwkt8cex+QAjzFjhdy8V1YZ+8IY0uEU
	 OXRuRGCM2hG2rWorbs3M1Hxb637UoVW5vfdAf98NWETqN503qvGiWoWjw2QQki7XpK
	 xojR0fsvrnoGw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:32:48 +0100
Subject: [PATCH v4 17/38] scsi: sg: convert mmap hook to mmap_prepare and
 rework
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-17-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
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
 fuse-devel@lists.linux.dev, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5937; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HTYbod2OP3AjRPEv6Ph886TsUDFUWldGDo6PKBX7Wqs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6mke6ptQZhP0qDaRs9HKqf7345bgPyLNm67IKN9S2
 W+bYRfZUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgImEezP8L5EUPXB5ps3ju/wX
 JnDtif2tcjEyKOzRxeInCn5501/apDIy/HNJWjr3/SFbtYP+4oZ8mzaHebSe4Pf6OieHX5a1idO
 OCQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: bf63gpzk386hugkt5xqxetm3bh6pnqtx
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6F8340007
X-HE-Tag: 1791045548-931667
X-HE-Meta: U2FsdGVkX198HBYGK4Mk+CJNZEoSJ2MNsMkKjjCyDjpnwzq0ymSC8tMwSFIdikvCADbCb9uslvPNCbsEy9ZWgwj/x3xkMl0Wxcw76HMQzF5HFGNbheebM3VOIdU9uiudXYI4OdOruMdKkVyYONkoCUWhyHRdqTlVYp5HA2sRDMg+L28hP/U61trf/7jRa6luCl0PuxLg8sLVfo0dAgAd0vf6+cFm3Izuh2kuRbfnG1E81tkdUfrYuzWcizbWZ1YSJIqHQG/2/WpjGo178rjcxteFSiffyb7tHwtIBUX3xGzrdJUa+34tfPhUEi9cXjWQtND6OT531LmnsGVhw/ugH9uZLFeFGPVfjKatjkkssRpKqWgCqq7THO/GB6Ts7mvS01N6iAHGvC7ESjPBs8tXfHJzIL9zhGm4WtZr2M5wOcUNYJAlzrYNTg0JBFVQl1wjlHzmRQdgyg3FqAzNoC/YknWp/ut+Yob4PaUqNE4jCYGxQ17xGC8fKC5x68Y/AQKn0oxoSyU9LqR2LKKKMjb60xo/gafHXgOri+bag1gmvp2uJslyy4v7Etd94yCxbPXkCH88ue6jTXUXyjc+0WFEOUwLcVuf+m1PJ7mvEVwnTvDKXXneNP0iyoXSNAUjK9HoZ3z55+3BS3IQWTaQKLEwy8seURXWC5/HRm23yppRWd0yx1XRGnEiQKyB39e4cjF0K1Piziu8YiNfBdwCuF6K8g9JvtuPA1VTY3PjZf2WBO2Yeg0d51ci526EfTTwNRXAWuUvG1BnC0HqIgZu6DCGzkjcrqt20KtvJfJViW3SHWz5P229b18aYmhciFUocNxgH8CTI4RNC4TyyzfYPyqkV9C/WSukzXbziys7yqxQ+5OFsP2cZC6APgcpv6PWTq4M5A/5VaWj4idttj8Ak7Lml8RSgfKi0e3XaUoiCCTjYGMRWt9x3eCgOHb5Seu4HSiVJ9Kf8sIam6LYfaRr5hT
 VaBvuyFM
 w3oVjg9dQ1LrAKKYyiEq+4ABOsh3anJTcd+jcnu25RPm6xRNnBWNOp/neoDMcOTgzfgSk1WojQ5BzGqD2XaVFPucYoU+emETVE6sFmgnn7ayExikMX456NRpsd07ztWrnpGo6sxWHdwvEVFjJKE0jQu5i0eRY69pDlb3WpEQ5x5Rndm3udS2PgBPNCoKbGh3vz4CJ3OLifsNHBJ90V22cbZOu9UliUWQ5iiDsiRkuRcDKJb4B3aTsdHs+HTAiwy7mSN/9inpCTFx/FI3+KWWs9du0LvH8fuwPyQeA0mEaWvpTpXi2BJWF/Uyf0S8SOK5+aNQaavD3MOyyEenVnAmFck9anXp3R/b2QkfCAmboeq/gIUHJelikyoCkgewjhI5rzcXJzSKCJAQoi6ZIbPjybTOnXwQ86/JAin96VGJhJcZ36DVGEn0PAcKTBBfaEX6U+Upvfa3KBpQS2JRZOWQOq5hu5IX0zMssf6SbLljQ8hEvPhVn26/YYvKaf+HBnSS4X4oyw3HkmqKaYDJeq1Pqyt+G0ddk95GMyN2joS3XTKI4kEHTgTi+wZ59NbSe7Fc2kUK+yWZoHtVj0rCAr5493eqnOloc/VW7HHnqKl21GmhCZwAOfhqPmYJIvLFGGryKV8O3fTnOFTzsC6GF1+XSb0tvAF2DEoGbJIwT54OQsa49Pp0h0sMWbIUwzA09B6dWX+kUkaQ0ct+3ByW8aAq0iMfmNEpM4L+1fVBcGIuDNESZK5SkgoNGVxSFwsZK7jj52E/7JTFv/dGJxPj+gRRItfX2NMKvm6zaPEwyPaFcJqvLKhbbo1u7wTTTtB12filcY1IQBPkl/qZdWVcaBer1a5quohlkHlKfRCP30JrkqFlv0Hac6FD8AmRQOXm1EHZySD66TY07XbPwTnldWlbxFgg7ro8cPJAWfQUVRryb+MTQrQlIeslltd5Nqn9BFlrTkOQbpMYkmH/gxoQAIY9QSa4xVWgk
 Y8xtvBpQ
 9kxAN1mRnpzMfnO0mpFyafuFh4/AzTm+H+JEfUmetA6iUn4pFCw+peYGkFHTwe7pyvgYK9SDDoZ+jplEHx8D5gUdS2IGPUePUBlVI8uuW5ihS8535Wwm2sVm/LAMGSL5TA1A2CchOkPaamyTb/2amh8h2tR1a+AaZq0603MKlgNzwiA857mSubimV/UAtv01fLlAa/75BnE89/KFKE2RZYWNDPch8TT1bUQTn74wLu6JVxwvtl77RN4LapT8VpLRJA+vfTE9ztG4vxpx+raXXcCSgUTLaehqQtMT9q1XXsbanst7R2HfdTwKWLNIC6YhR37r8p+4NNWatTJA++iNM1rdtuWzX5FotPzsuGjOe+UHNUqV9GRXQAii3CXAAGa9Y3df9fGPYumfPbHWetmi+6FpFJJ9NYZzPLlzpADePwr74tw/PejKw2kxisKAq9RllP+gzoWtttZ5SkzYiaJmVA+WuVvwVfy1cT//Jn4NsdurCTJ4rd+eCtD9uClRBaW4MVJUqlIzqKpzMe03iL4n7CEG3tDe4IQ/sfC9JNCrfOwu8A4Sqk8ismXjCmThgFxu1QqXtU9iBSvzEvf11IicddKQxTCi4o5myXcOXIoVqR/puDJxZ78yZ693s76qPR9l1wA+DuZYsECmMcdoOOpOogHHraS+IjIz1H+IqCLCpensoUAUMAFYDAFdbvYKYL4sUXx7Z8h2ZA53NgW2rgzd2npAlTeLWy7LRBnblQ2bYtHqLRFU2rJzpJE3miMl3ogh28FctenDZG+vMWo3EoV+qU5K+QYnyN0nB7hpelFNx94T+xIBJrMcyyUYXVGPUn9Mx9NvPzaY2RGtjlSFihAxh60FMoOkIBdADxgJ4K+LJ+r/AvgLKHFMtFlQLN0+wTlsGd99rGGrg6H/wOlVVzrAytHze3ytVAcHBP0vftA7dCgm7O3HnKAfs/nyS3H3opB7nWPH8AgnwKmuKjVOqDJw+x9tPk8BB
 myNOgrqm
 4+eF89oSu/guJe3C+Pg3myfE476Ig5CIPoWj+7J+NsH01eIB2lGyqPBTq3pl/GLjYIz1NJ5DXxgSSLycypOQYassgL88uxzSkDbWNVv8cecQFwf6kxh+yIr2e8MBFc80Elk3w7NI0BdbWWsCSZwtBn/J09nlygGM3shVptFgFhYAmApiq1xN/raaTNn/ts8VVVEVhteFQDS02PQXJBs4cw5cv1K7d1CEEi+oHVrvgsYHJI3Uk9xKE0FjSVXP4e5FN6HHPytfJUYsUBYi+7X7Aom9dDKz85pqVDgaJpVwNsfhpP3h0sik0WTMIY8xKsq97Zl85HnSOR4S5/iVRltF73XvJncZT9i/L/flWW0jex173+Dbhzl+a2WzzGriWo0L2miyJCVpECDQFfeMNZAiUocALRsgdNvnCHOf+M6zgytwg1EPzI9oB12ukgfrCQH6gt5yDvZXaq5TWnez1lxz/COIDNHtd+1aZ5D9ZAmEShVSMIQqB2l/k8llIpkRrfBxknUf0VxWspu+h/s7Fd/LxPz3kBbRdZlaATWG6BPVWKXWIE7F6nOQ9Qir/2eX1bqChjF7pWw8rPwSp3speLUitGH2Ey+/5LFXIHKzW+I72J82yPj8UDvu3MpcQwR0JpHdF/+OAuI0RPMgsvnqOMHOB/ghPjrn86gwn2VYjtaEgScsBz6wXXgE2XTdyl6fs6m09PhyJmOGAxlqut4solUOtQvI1z17QfX+jC2u2lRWBVbHyXBQVcLCOLCUNQUpCoJ1ANiDAuDrGZkTVF5Ty2Fq+OqYGpgrQEW/Hj/GahF25sWEGdhKDrwv8ScFXZ93mIqyBlWQUIezYaOK9U2j7//LHHX+6gkDDpWhRJFWCVAVbRgz4ePHpF9L3ovIlOpv28nRgWzGasuoB7/0lpTbipX2xCrzWQxUFW+8Pe0zCqgyVh9dZvtWE45iCLct8KWQNRshtjSiaWFm5JsMjAxbwHO/CcjhnS+W0
 lOpOXzJg
 kHfbPUKkZIvwHX8CykTtuZTUyXzwhgNokGHtkZEL5OyQ7bWR6w3Fu1miWEAXWS/t2s8yOlkkfJJioJN73Ul6D5TOzlNgjbg7jLn7RWpZDbNIkf/6Vdcsf7MtQUYfXiJliXq0UaDDrI/qCnUORnH/2TjKlOBfKEuKAmC5yYHXY4/yVrhleN+g3o4kMzCqsH+pq/pSjuNFlOX24aCBu5FGxiBhYYeO86hknJWaPjbB46h36sFmoZnqWuQh37De1MgdoziBzhj1BdJ20U9CD6s4RQ3RwOEa4i0ycOfxMikGJXWbBxa16Noh4yUHzMAwmpOP1VPrOiFVudNpvzBQdv6Moz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move from the deprecated mmap hook to the new mmap_prepare hook.

We are mapping kernel pages here, so use the discontiguous kernel mapping
mmap action to do so.

Unwind the rather confusing loop and instead map as many pages as we can at
one time.

Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
the pages are populated for the length of the buffer at
rsv_schp->page_order granularity as compound pages.

The discontiguous kernel page mapping logic handles the compound pages for
us.

sfp->mmap_called keeps the buffer stable for us. As before it is never
cleared, so a failed mmap also leaves it set.

We also remove some useless vma, vma->vm_file NULL checks - these will
always be non-NULL if you reached the mmap hook logic.

We retain log output for consistency, but change what's output on page
mapping to indicate that sg_discontig_get() does the work now.

Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
necessary as we invoke alloc_pages() which gives us refcounted folios that
are fine for GUP to access (VMA_IO_BIT would prevent that).

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/scsi/sg.c | 115 ++++++++++++++++++++++++------------------------------
 1 file changed, 51 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..3f9e08725602 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1212,85 +1212,72 @@ sg_fasync(int fd, struct file *filp, int mode)
 	return fasync_helper(fd, filp, mode, &sfp->async_qp);
 }
 
-static vm_fault_t
-sg_vma_fault(struct vm_fault *vmf)
+static int sg_discontig_init(void *vm_private_data, void **private)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	Sg_fd *sfp;
-	unsigned long offset, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return VM_FAULT_SIGBUS;
-	rsv_schp = &sfp->reserve;
-	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rsv_schp->bufflen)
-		return VM_FAULT_SIGBUS;
-	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
-				      "sg_vma_fault: offset=%lu, scatg=%d\n",
-				      offset, rsv_schp->k_use_sg));
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		if (offset < len) {
-			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
-			get_page(page);	/* increment page count */
-			vmf->page = page;
-			return 0; /* success */
-		}
-		sa += len;
-		offset -= len;
+	const unsigned long req_sz = (unsigned long)*private;
+	Sg_fd *sfp = vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	int err = 0;
+
+	mutex_lock(&sfp->f_mutex);
+	if (req_sz > rsv_schp->bufflen) {
+		err = -ENOMEM;	/* cannot map more than reserved buffer */
+		goto out;
+	}
+	sfp->mmap_called = 1; /* Prevents changes to buffer size. */
+out:
+	mutex_unlock(&sfp->f_mutex);
+	return err;
+}
+
+static int
+sg_discontig_get(struct discontig_kernel_page_state *state)
+{
+	Sg_fd *sfp = state->vm_private_data;
+	Sg_scatter_hold *rsv_schp = &sfp->reserve;
+	const unsigned int order = rsv_schp->page_order;
+	const pgoff_t nr_pages = state->nr_pages_mapped;
+
+	if (nr_pages >= (rsv_schp->bufflen >> PAGE_SHIFT)) {
+		discontig_kernel_map_abort(state);
+		return 0;
 	}
 
-	return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
+				      "%s: offset=%lu, scatg=%d\n", __func__,
+				      nr_pages << PAGE_SHIFT, rsv_schp->k_use_sg));
+
+	discontig_kernel_map_page(state, rsv_schp->pages[nr_pages >> order]);
+	return 0;
 }
 
-static const struct vm_operations_struct sg_mmap_vm_ops = {
-	.fault = sg_vma_fault,
+static const struct discontig_kernel_page_ops sg_discontig_ops = {
+	.init = sg_discontig_init,
+	.get = sg_discontig_get,
 };
 
 static int
-sg_mmap(struct file *filp, struct vm_area_struct *vma)
+sg_mmap_prepare(struct vm_area_desc *desc)
 {
-	Sg_fd *sfp;
-	unsigned long req_sz, len, sa;
-	Sg_scatter_hold *rsv_schp;
-	int k, length;
-	int ret = 0;
+	Sg_fd *sfp = desc->file->private_data;
+	const unsigned long req_sz = vma_desc_size(desc);
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if (!sfp)
 		return -ENXIO;
-	req_sz = vma->vm_end - vma->vm_start;
+
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_mmap starting, vm_start=%p, len=%d\n",
-				      (void *) vma->vm_start, (int) req_sz));
-	if (vma->vm_pgoff)
+				      (void *) desc->start, (int) req_sz));
+
+	if (desc->pgoff)
 		return -EINVAL;	/* want no offset */
-	rsv_schp = &sfp->reserve;
-	mutex_lock(&sfp->f_mutex);
-	if (req_sz > rsv_schp->bufflen) {
-		ret = -ENOMEM;	/* cannot map more than reserved buffer */
-		goto out;
-	}
 
-	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
-	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
-		len = vma->vm_end - sa;
-		len = (len < length) ? len : length;
-		sa += len;
-	}
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->private_data = sfp;
 
-	sfp->mmap_called = 1;
-	vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_private_data = sfp;
-	vma->vm_ops = &sg_mmap_vm_ops;
-out:
-	mutex_unlock(&sfp->f_mutex);
-	return ret;
+	mmap_action_map_discontig_kernel_pages(desc, (void *)req_sz,
+					       &sg_discontig_ops);
+	return 0;
 }
 
 static void
@@ -1415,7 +1402,7 @@ static const struct file_operations sg_fops = {
 	.unlocked_ioctl = sg_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.open = sg_open,
-	.mmap = sg_mmap,
+	.mmap_prepare = sg_mmap_prepare,
 	.release = sg_release,
 	.fasync = sg_fasync,
 };

-- 
2.55.0


