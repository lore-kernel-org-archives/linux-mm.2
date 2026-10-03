Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD4BCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662FC6B00AD; Sat,  3 Oct 2026 12:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63A756B00B0; Sat,  3 Oct 2026 12:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5297F6B00C8; Sat,  3 Oct 2026 12:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBBA6B00AD
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:44:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD255C09C3
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:44:50 +0000 (UTC)
X-FDA: 85281889140.07.1682778
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DC5FE140003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:44:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bx647l9+;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7yzjjlSzlbX51F4Uds4bBqm2u/xB0/1FIMGl/ApzD2g=;
	b=HdhuSYFelFCJEq5ryu1DUobPSbcujx4r94COfLZUvt0zFT5jVb7OCNcgEfSldsV4/WhiQv
	8KjXtkRtLtyCCs7MQ9oq1Qp5HCUyvMZhXq191Vgtwcn+lZ/o0XC33vCUnAFxkV4jQrLSoq
	8/IIRteJPorB+Y37/HJ3rRJ8XRmsgxE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bx647l9+;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045889;
	b=gFPpKdmMY2THk6cxW9gO0WWBl88x4oUqSD277C/1oFXkGd9eJK0atPHhKTNgu4cOV8JBY+
	Eigde6SeXz9YDxUWXQSWF6b90OmvqpnbrAg71TP+lgZNEfyeFpqOZmYL81yHeTJRZjzz53
	cm3suc6FVHYzU8aOgswOFPqJdzAjtn4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35B5F435A5;
	Sat,  3 Oct 2026 16:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3721F0089F;
	Sat,  3 Oct 2026 16:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045888;
	bh=7yzjjlSzlbX51F4Uds4bBqm2u/xB0/1FIMGl/ApzD2g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bx647l9+wLUh6qrW9IT0cVkSvcpibE7k5NC//4xJnC5NWtmeqV2VXyo7UBV38DtiW
	 dhWp3G8q7G1h+Ho+gC+INU5KH8XmH7gIPMRdvYEaBkasrJ+wC+4OzFSgyDZXh2vaCT
	 ohhNnG/zj5Qj4xaumqg2WECfL5q9zg9e0im1dnCNaVCcaoTe5h4tqf8C3MTYAVoscZ
	 PofZVfPz4yoGVwV/I2V/kOTucR2aMzQk4aQOLPsXA1kkuEcPj+eMMIEoiaeizShReT
	 DfPe0X2kZfZs0BxyY+cIUOGmRdszLgChSWuSEqIIwGgvCuNJNzz0ELbWMiwoHcQqIC
	 L181+b/9fkwVA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 03 Oct 2026 17:33:04 +0100
Subject: [PATCH v4 33/38] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-33-a1f052500fd7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2586; i=ljs@kernel.org;
 h=from:subject:message-id; bh=VzpMBnGSH2RNHu5Mv4xiPliY+l+0YLYMpytCFKUc+Kk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIO6umkilZK/M7+eTxUzWH/NiFVfePQS24fneXXPT9gn
 RzscvVARykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACai+5uR4fXvhwHn9v3S37ky
 7IVk7C/DklpjA5N52z4+O/bZWX1lfw7DX5n4P4YfA5z6v/yqOuFRKyvEk+n+SJ3/YvU0y0a9Ej4
 xBgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC5FE140003
X-Stat-Signature: sk7rebjmc57w5ybu8j16eepr7a7drejx
X-Rspam-User: 
X-HE-Tag: 1791045888-803820
X-HE-Meta: U2FsdGVkX1+1Jztn6MLOGukfGQlqI9dRKcAn7vV2EqJbDzNekpSzrLszS8MU1bFecsxODUt+yV33ecDeIYSehVxWTNTd4d+cqYjP1skiN8ptE6Zwxc47wKROyNq7IQq+KYsUShMxYm55wdA8HshsV+GmXMAr2d0XDmHcYCcppHq9LA8yen1fUoyn+mAu77sQ3i6xTPykLp/xUNFmvHFGjUxzevFoSDl5GsFtJlZLORVN1QAPestOIExR/fMNXyzt5m5z6vXJLY7G2Eh4GHme4mRbm8/f2LM16ym1ITTivO/D4A9VVpBkE8tyKy/KF6iemqDaQ51JfIjRHAZfLIi0AdtHjvLOTUNr6uMIXWfw5OiqUFs57oCn8bzCBHBN9bcqCtVvyk7EYOHtctwwXa63tobRe8TOXYtPaoVPb+/Kf/fAPOcrAG2AMjE2JADqlG20iK5KsDp1SenP9gdv6Ybs9vJeDmuVbu3zkQ7c+IbzNiSwTXiMaSc7MMTk499/qmHn5HjZ27Q5nGXPZYGgNSaOpFwMY/9dF/Km4lIODMh4CsgQ2vNMYd8EMLv04eSd3OWlqwnCrdkMjFut45Q5FZX0Qgd1pwAkFcZNuEOg8CVatMeyKKIPCgJAnCJ9sP1H8uomOp8AG1RLRpXD8a2YAl7xqBnmkHXShDq4YM0pBECqY5/2Ika7iK5nsOLyw6Ih+PoZaIsg+dXlYsHfRMc3hudxGknXQpURrUzZGPjZLhDMjamprMJHS5+ixpFIZafTuwPZ81wXyw4uY565yoLs9JUVP29Z2i+3YxQbtmEDekd1uFkIa3PCnXV6es+7w1e4wluH0BeHEnj99Rts9T2+OUoZ28bgvXPCNF8RViPn7Pk/90EeDZvY+bnt+QwGNOv7m79ZcjDgc0L3S9POyFpcJDfXAoSMEoRRN6JC9luRcjbr3G5vco3KrhN2AJEfHa1PJvN895m0Hoppw2XE8BECDAV
 dUVSEvSO
 5VAqOjhuPbsQjwRy8mmNceX5oo9DagoVg6qK2mSkMvyLEjxSiXorikNnBfBF7Uxnfd09kYOd9U++9HsMKAzj+vRQNw8GtVDI2IHIGgigcHJw31GngV/J1hpB0vNCg11f4iANChbzLDznOl6QtU0VUFXjKHW3aHafp56w1ywDMnm1jv0gPqg0oqJbVYBqdi8oUAdIjZ1URvuH4Y8WkRxxhOkQjuqYdx613qUzvrsENadBWFJphx/HcW358aBBKBauA4d2FVzQtY6wTzI8Joi08m1AQEP9cUGRRCH2GWTQMXpxWLs6ntwGKxqtmllNH23mdzKnrWwkTi11s2gzebphW4McOEvp+5O3Wx5jX6rDAr8dA5pF/vZTsm3S7XMLBz/YZNLO7lPGM/ehrxM0zFiNsJI4fmDK3cMY8qRYCgwDThFfLa6TFan2A8DVvBRq2Qu8q/05yjZ+zCA6gdhJglri9/pc7CNO/8oQESLWg9c7oFnO/V6Hh2GV+QVj8VGnp7WeE+BV7peAnG7D5u5H0hHueNrRn+QTUMb8jibtfm9/NFc6Th1TqFpOh5kV1Io59/2yvEpWXDWjo0y1EizlG3FJAxf68aI5+SbIUBnIJYPhJf3jtIqnaw7viv/qIic8dms3jDFpHITP6iVW8PoN7eAgfGkzkqril7UFV7jYv/H28+XUqymkjLh/1A2t4bTReehvc0cAaYxUuKBCQHhzSO2HEaBrvDsXNwpd4DRzTXPSKo1DPV/FPglPGc3H/ZhD/TZDjLAOpwdqdONnXkDWr1KSyNoDqNRvLOozAIz9Q9knSllnLmEh1UJRhcgVNTZqvn45mvaD9Z6bDXD7apQcghBJ0/T5hGlfu+cg3FGJ3Eh49fq3ZXBT1XWvQKrHsc7oaJfHWba+1SpXIfQK+/oP5tjy8Fbd7Ekjw4oz1FHDnW7uFDn18D0bfjIGlY05x8Xsd8rogwL7Jy6Y7rCVjvdAXOjmqhrNAuiak
 zlZr/0Y2
 ho+RwG+AjxdQ65YHQQEbDDZl/NBrTm6jRlUE+GmzMzcDWY4TC8qeTiA2AnczD5qfbi05X9f5PkbU0074/NAhTztGB8Tpqkg4xaTU07TbYKblRbFK4sjPc6VBFGgP3/UT4AwIRE76Ky0X/aqTj54BlP0Q/vOrsLAdbHw/ybIoG/4UTd619hCxKeMN6owCa7kiU/OEucP4v4guK8ev9tI5mkQHomG9Iy9XZtGFOWfJZtGp5q2+2wjPrEsvjCJ95y3zTzWrNJqJiOk7MxkuO9JIrrhaIRHSKm7uVcmAWv3PsV8yunrliuIt8Oo1/GVjUYbIyzslW1qeE1gS1Sq6vRNKnCC3T+oyJj6rG3h6mp76VzVXgx0cHqJwNUHStIt4cY0zLSFb0BkVKEHlPiT0ZEgyyqZtayEf/yT/AMofsQ4bAVsaRTbcYMs3RXAgCbho9PYo9t4RK2DEsPqU+yUVj5+SEf40FvC/LNKd0Ruz+QyKhcohCJSlo8bbr3dNk4lLmJRkKorsYWwh+CfmhMhazTjT3ZVYzUsU9om2vqZhSfcJ4d3bIIpZ7dkGMWcQ4SjupRCFcbPxAj8s+MsFfWRqtM25kbWXvCTnkTFvdaBoLaaKulQSNwmNG/ohu5TGmImDPRQ7goq6sU+QnmVc7cJ2TqG6PEuotH1pSmJmLO2KDNtgd+afbHG4L5lDUzu2f+enKjGcIfjhrPVfTgspMg0nnt5PQW77M7Xa+f1HoKhnD1pH0uJoUIKkQA5+3xAo+pXfXqFYG3rHa+OuIjWUOc7TQ/3lyIIA9Exyf9B0oXCrNBdpKns3szfZrw+G2wga7lu6vX7bZwxNMg+qRSf6YQgKl4a/KMOw4tobWyeOR6um1Il/EFJ501WmG8lY7VtztFoxseoojyS5qAcU1uT7fShswMq3uwlShFUgfx6sWp6uy0cGmRKbuXfLL0bYEXZ/LpAO3rgcFNbAqR5vuJEBhpAYQ5ITVRrJA67sM
 2SPZ0U4f
 kajCLVWFaNFMeHNAiCGIIuH9tv0CXfDaT4rRQeEPG3lEh8lz6Ya0x97Hc9be4JKQCupALbgp91jNQL1+G4jJiiuQZFFGvPi9EKL3II7GCiRHvBRazijDJvq2HMhDDIfZ6hW0xnjjrnqcU6WoX3+VBo07r8mfUtGaQVODmv0eM6y/ZrwXWm8ZlFYwxbuOOUW4aTxZWtlo4Xusb1OcT7/snfe4QPSrUFXqFgP/SXVGVt76yNAC/X7CY1oPG4o7or7EhyTmSmLxfIdkdnt+J2YINMFQfkg3bbh0tkK/ZyqZUKKk88n6J/gRwOJDVajBL0ODLA+x/6oiZaAWH409YPBBgBLzXIJ5w3KZzK1BtIIZjcedyWaUNPuvm5Mu2SEzXRPHBjzchidZHzqSHlpGrQr02nC29SZPPodi04B6h+Fm2bOt/W0OnwtVjiKSM0BmAUKmQZY0lnbIgK/lPjDbZUaxWS8IMXeNFaxFzH3po9J3h9Vok3k2I9dTltWB1xHfIoKuphoOGXPbddbkgQ9z/bTUZUuHSlleqNsv5Sy8AngKCQ3ukWgwfTY22JOZntAd/kWStBT6LpEo4jaRob6tnQ+GjKKHVaQXtiTJL5hwwF3ZFquB0uJekjKFETNOld8R4mf+kBTKi5N4d/rf/5tvTVFPjYFndpKvsCLjBmHNT9DFuop68JIgFMqSKM8eTlDfhv6ptupZ3o4sUvZxfan1EM8l0jPT96qtyAbkdoPDyn+dJr7YYzWAIOAR9SaBvtVCcvQqjyVOb9wEaAo41G8dAxdTjMPvEFyL5PM3+cGQL8PuPMjoutLuXCAt/5FVWrktzxfQ4PhyVosvqXzjkh22Bbw00KeYyZeHG1j3+NrVhiHp6rBY9wB67cmKCk39DCB89lIRxERT0fXMCNVj+p4SjnB5DdKCzSIhzkPX/JPIwTMMaGL8sMBI0JX0jp59oBgvXbbVYKic3nSbK44k67EYNJtxYTlvrLor0
 fHP074vM
 m9SqKf161XQxDrWurLvCoMOUSBvsPCL4IigeiDhYo1wr6PvQRXHfdTYl9rqca+DF99VMXOXUCmHO7fNSPdW93VDEco4ECuLW4y3+ZfzzBO029TbP8bo6I+DXLWOY2WKHTNbYtnvF8OCFEwYq69vGX8IspJ2C41AaTRjIleq2+v7EdI8TkfWvLp0JBi8Dlwpy6uSspCrVxYz/Yd3jZ4mEiR35rgmTHFbXtL+6Uphyk4fpz1FPRMfhN3k2SS+62347IhEbUCmei4uLXS71n+S6aPATa/Pj8hwWfzCl3vHSUGrjq9goyPMBdm8USdIUftvvndxlsNj+7Da4+R/tWJph9x/+ft4dCOqSlxftmAx7/Hfg==
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


