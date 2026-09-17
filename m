Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344B2C982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E3A6B00B3; Thu, 17 Sep 2026 12:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE786B00B4; Thu, 17 Sep 2026 12:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261206B00B5; Thu, 17 Sep 2026 12:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED60C6B00B3
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:35:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F93C1403CC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:35:15 +0000 (UTC)
X-FDA: 85223804190.23.A1DAA00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B93A320009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:35:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbGrMViY;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUrUzF8/4le7qbZJTJU61T+Fa+3vJMcHcbFMQMklauE=;
	b=EJPmtzgo1z1nCBrNGK1BJvftU8DCiWz/r0FsRkhKvSCIaDzrf8pkHbfk0G1H/rUZ9zsb5E
	A1MTRUvb1c+izA+8bkGV2QaBb8RTg2DM8HqMjE7yqGhaLS0awVDuSWmXOFUYqGdEMurXn8
	os829BIZ+C5JIS/JmigYVqAJHwvR9e0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662913;
	b=zIJoJAyB+Apdz54uXEqC0+muzTVyvRdScNA/skYSj5xlFG0OFsty8wp5j/SN4CWyUeaf6u
	1QnNholp6oIcMj5hGh83/PqocHV65bU537YqX9/HhK4DeyNnnf4BdY2vh/gwZ++V9TwA9N
	RZdmjvvNRtAS+jTTYPJyFbeyzZMWUCg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbGrMViY;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C458601F1;
	Thu, 17 Sep 2026 16:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C0D1F00893;
	Thu, 17 Sep 2026 16:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789662912;
	bh=iUrUzF8/4le7qbZJTJU61T+Fa+3vJMcHcbFMQMklauE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NbGrMViY3FCte36X1jspWft9Z2nr7hlK1j1KoUCdouicGQ4vngnADXTaDJ13pqF2h
	 gZP8hVDVTwk81EIp0XvKf4jIYJomoz10GNlI/vsArmiZaDbHLdlb6ch6TKWeY+xZPN
	 8jYdpuaVkfapPTsJTos1M6YJilAonCM43SKhaLLpVDcn6jkPX7b+6rZjyAJ/fp9PhK
	 zG5XdUTGkfUfWUrEvAuz6PusjaJRL1HI7ANV+0EZ+P6w/THbhupmu16d9+sItdmJ+T
	 lTnhjA/FMaqU8r+N6HCPwSbriaKRn0EZuAj+IVgNupantuDiUDu9oQH7andD5ab4wD
	 76EQDMaDeZ7tA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:33 +0100
Subject: [PATCH v3 24/40] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-24-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7394; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/pi2tmOR3YT+ZF3zfKDveG7AsuWVeuqglzukqGZd1a8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9ii9uce+yv+vNykVzHytZ5Wnl1/B4BHQ4qj3uVm
 GqaNm7qKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwERuvmRkWKiX+yo/70SBUcLa
 uYLVd8JT9m6+Fqca7a1zor481mbPW4b/sStP3m2c5WPzTPfrqkMx85nuW++dyVLWILBlR2fcz6V
 1HAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B93A320009
X-Stat-Signature: pq37bxnbycw4sweb1wonhuieay3bnosy
X-Rspam-User: 
X-HE-Tag: 1789662913-166128
X-HE-Meta: U2FsdGVkX1/mfKyqmiRwS6UFjPlLZ4X7qKLYEtGWeyCsRaXUWkt45K2bE3m5J4csDoFu3Vo/1JpwgcPyefp1+y3sBim6TJMfbguC6zZbpIURqzkL8gFkIkte1KRdFz1JziRQnqSZUPC7riBn0MzpHA2Sj8MczDu6TeA+XZG8M5LPoPjE7NKws41yKbuzGkUaf4QghFl2cxmrjmTsTXR6KXx1qCr4zWzk9LfCsDtOjlokNxgp+CGPQgEK8pXm95XQAJrQplpafE4AYDqCHZgwkhF1KO4Yp91uFbZ7Qoh4qfhv2JZhvADNdZgtT7Gx3X5dfIIFVepBEJ72vc4/ISoZOyvfM6NtQfChBt1gMoDnkANOgAH10QZcAMT4HpuoxZqQOcQ/ClSZ0pBIjExdL+2YLWSdeGzkfNWz/pPYmPQ/d55JTv26WVRfrr/Pl8JQIhdFxGrNML8NdonLko04lDzj65qs/RhvKNbLUkES6ZKcDhwynuRaFGXuE9xgVyZZ36/9lRxJslYgBtpfDhH3eri8JxFBC0x7DDmBL2PL+m5VyoS0VG8Xjygb7KV10Uqc1KGBGhnaNqpFmN+kZAcE7GNOYxyfY49d2lini5Ro1olUB0D2AesZvJZ6d9YIPaUXPwNEaqMVWxKbF2ZhMpSpCXP+cCd7PkMMVQW1UZz2kE+Hgi4R67F/F/RgRNEb7WM/UTx4CAbaquKni1SeqtC0Zpy3UmsvtUEhTostrBIjv4lsc0fCWRhHN51+oJwwmH83BLPoP83dRJwrvIbZ+7lBX2FG+iIOr+9+JtR1baIaOIi2gWOEZiT4yC2zy11ryYD148xWb0s3Rz4xfKcOIMA/tQcbkBQ9BXrP6PCrEPLrDNcWvdQPnmWpKSANXu4FJPXnUxsQKCNBwysHtjzbHG0ow4NM5XfbwQi9vCjUHuSBlkjE1VZHGWAMuSEoALImBFX2CfL9y81YNekBcQ4IWqHupTY
 B1rppODn
 RKs53ilA+MpsP4zueTSkkFZzxC8ktoi3PwEmYr0Kh5nLWJu0eeILwmCPdcY4H7+uK2mfnqYbM2nVmBIi7N1182pzLd7bljpWNIMjcQlp4eW4uuGVFBZrdwRZJ6VVqVdUXEmsWl0WaJGlVS+/qr+GKqfRO4A6Oy3Xnq/tYDTSyLLXnADGe7B0px0XmjZVSWcp1f3BryYfshYLWgGaYRwTRAHzq3fkJv+HIp/LkfFInD+F0zsJGht1rwAGd6B3y7CYwmkeZi51Uni/a4Kx7iW9bsVIHEjo8/CLrR36gvZ5ve9Gt12W54X1YOEmuo/Itws6cusLC2Fax6kzo98n3TYo63IydIQfWZArcGsprQUX6Na/VJOC+ELzKH3MZeV72ta/NpYCwwpc6F2cF5jaZRLKB3BkgJYRJPYuCYe/52qE2NnLHO718zWMMTfaPlysA2xgM5mc0zPt/v2+Dbgy5uUjTD4wDk02b/SsWUkOTLzxv1NObXY7RGL4HmPFAvjT7ceuwCPEqXT9UO86k0TRKqUV0j5PXZ04aafGf7AmxBfGY0NG/0cd0Nd8xK5yfV0Fg963pAMjVwQdI4sRLp5ZTaLG8xVWnqm423QRTH9ioQ5v7DnSoTDH7utoz9WxOS3TENf39db9bchXNq/m/58o9/NGi9zqIYdSV05I8gElj33r0KWGcVJYYkVst4frJlULytj1ULoU3+fkKoxXnd8PVtfYwFYRCoB9nr6zeTdB8UrAdtoR7UvRbUCSiucGqsuQGMl4rfz4SpNlIPScisr4M1Xy8hP0Yzq/yFMMAQOVIRs26GPseCdWHoIi1o+s5onO3IeX8g3rFRijy1FgFipjduNIvKFjsqq4DgZViqsStMV3hncdlZz2QoBKmhRpOjpQQDIWGNxvY7s3PIo8lqT+ADSZmQyABSGbNCDwXe/Xowh4p+6Oy5Hk1z2xCWbVIRdKrcnX01Larnfm40/99zLSx0agqnpw7HRtT
 IB1WfTue
 R6DrP5vr12XbSylbpCNAQsPXcFidkH4PuJyEfL763tCRRgMoSxfS91lqvnCKVc/QbJWGDVlUd4F/0WnlVa52bSugMFcIjMqT7MZITgmlfZ7vMEN8SbeG4+dTy6jxHgxh2+C58ErlRoWQVY/qQG4pa2wjNU8aeE5E1KJ4EUVEROqsCsZHa/JZonAKf7tRGM/ZiAUEBGSbF0kRAHm78aXKA0yIrFOrjH/7cysCbngyb4MJJ5rSoxoxrWLaz2gji5w5LX5PNbakN49nMz/mt5wHF6HIHaNN6xWhaLqgWPKjQkCewuGUfeeK9EECcl0k2H6fpuN/roKQwtSSuBF7niy/NiDGP+/tnXUgieNpESpDIXrrtiOp+6AvmkDdtVIYWkNY4VY8Dz0AkpvQN0x+FuY60+PGs0uXdYHBut4JzwdltjziItD4ncdReD3DSyc4CRwBd3jgTz16JJnsPjIg/gRTCk9SeffxXdFLMeImbk/lk2G6Vvato0PxV36y3fH45rxEMCnv5JsQacAwVd/9Ikr4qBgM6JuQ1vt2YHxzRLoIiOITlD3rqu36DrZUl8g5DS1Ee6QyfGqb/FnNz44a6sdTopnYP3e84aX+8LzEZSlkv6Vb2u+vRjXqgZIdGmR3X1R5yz2rn2Rxq06qcmwXAPK8c2ZupIEOy1Fw8xxponVO3OFrokxXkiImFv8nHclqplbbKlc+SR0HYoyoRYBWUMSeiE9bV3+0n4E02CGXC4zfQsc6vbX+FtqwGY4xAg9rdO4ucVqMUqZwRTiIE2MTVSKfAt0xGuWLJKRL/edzhJ9B0TBGAsRW+ryaO6WJC76jKhTsRMtAdCfJC4iuJJussIeMb9TcTu2B7d0qxtGnx0Q8w0676RKmDcaJWBb++cpE4DbEcHGulgqYBl3kjg0HlN8ZPRoiLeKFJpoEQbvUe7SUIQtmiLAkXaek4LQTmCz9G9GVoW1ODr+v7tbv/DZM+ZLD4RtN1EKYQ
 w8/LtSVx
 AjMbFZmWqVANYwqKh1K/NYRb3f5mQGljImpW031FYqDW29C3Wi7TEHGaU2VCTXfpJzmLgz50uiYiEQcHO3TzEeQl6JC5QeCmEbhMuTUNdvfFvoPnvO9jpaPZkEQJ4wAXuEvb3e3ZawVIjmPb7/US6fuaF/nyL8qDmYK/AYUUhA7cOpZde5BiIBX4FqVq+weJgJPa2QurJRwzRbjHFIabLFsTEmtI61CtkFpeOyhrqyyEKyXkQgv07nQxrT3ZLOv+740zjBriy8XU/by5ca0TTioeiDGv2FFF55XGy/YqEMXBwgYLKsMcl/LiQUbCtxPfyG8gbMzwDrUwTBfPgla4KagRdNGsjT8Ji5dqR89njO81k2XLD87FjGDv606bDeuttwX48qNGaKO+CDqfNYVmAgx646orU3I9ze8DON6YZLCt2sdtZ1R6QXlSf8kKzVPz1MjRUQO9pBZQJG2KegtqvNM65ytMuk2RzlFIdXV7IjLVLfjsQrr1vWU+TfzOHOo4enqQn0NVUEvtTpwzQ21JkWOqljdEBcx/aEYqY4q5cCplFr9+CFQkbOZl/qFVPumxGCfBq59MBqOhl7ezOfY+IMd9vFFt6KJyA+eoJhjZ8HNIWnqX5rcFMjFTKbwHbuDBx1esigRIkZcoyMtFKezIYAwJQl+5+jRGAYDgHS+n/as4Sp97r/D3+lHlM8x4udcQNC4DGUPNuAKm4leG9q3XhfUVULSqDwnjrIB2JoY3TV3qtiLQKY6rpp1FHERDDOyyjJj+/tzB9LHgtFtZQ2q9QDlxENKpAvmOTuaa6iMQIcV38Y68lDxVVuqNnj6iBBrpXNbEBWRlvVpox7UexLdpUrs+WPGCMhDYc8hVdzWYCjkhBolL0S7zzEBxqBGA0rimOkvgMXVgGrahb6LJctfbuMnmSVveS1YvXFh5oKD48Du/fBK2Kwmbn+vW9cYzjX+Qg5XhL7NK/5zVs3TV/4ImdlMBvIYHE
 r0x9aMMm
 P+KoPt41lS0GJnVosewFn3TPvI5vvT2ETjGq5HYj+WCt9keXsOhTHFrxmsYzPzHZPoMnAcSajQjncwpN29rO8IHh19H8I2dfMV/ZsO1No1rqPa3rAisDoulZfgmz2a719uDtltg9hYYWJ84DO73JaJxe5HY/Hg7rRKWkaM5mCKYu4mdQFXijmIQp5AdoX13IGMs+vA9o1IbRlvK5AWGiQxShV4b24MtJpoIOoO+mPUhfsZB6bcqPg7Tbz/ez+lca0D1OFFM5ZzBrFAPypXb0HPLTjDuJEkJalz5f0MWgFlYryDDKHEoU46eJxwM3adr0IbNa98CVX4MEwHHCXGHqA81egOzkD00rnPcyhXE3FmGE7soCxzJHFTbdQtIA1TDLNM61JMnDT+IyNsa/0eArg737cL1jb1awMZ18fSyzjcHxWGgwTuXG9CMhhMtmyY6BwKFiT6UKSa3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
solely to fix a race with migration which might otherwise double-count
mlock VMAs.

This is unnecessary - at the point of applying folio mlock state, whether
setting or clearing PG_mlocked, we know whether or not we are locking.

Solve this in two ways - thread a boolean through the page table walk
indicating whether a lock or unlock is being performed, and run a locking
walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.

This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
VMA_LOCKED_BIT. These are also always cleared together.

Then, update folio_add_lru_vma() and mlock_folio() to check only for
VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED_MASK
instead.

Also remove the useless invocation of allow_mlock_munlock() which simply
returns true if unlocking and instead rename it to allow_mlock() and only
call it when locking.

Finally, with the other mlock abuse of VMA_IO_BIT addressed, update
mlock_vma_folio() and folio_add_lru_vma() to simply test for
VMA_LOCKED_BIT. munlock_vma_folio() tests VMA_LOCKED_MASK instead, as an
unmap racing with the locking walk must still munlock folios the walk has
already counted.

While here, also replace some deprecated VMA flag predicates.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/folio.c    |  2 +-
 mm/internal.h | 10 +++++++---
 mm/mlock.c    | 51 +++++++++++++++++++--------------------------------
 mm/rmap.c     |  4 +++-
 4 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 47a437e0f7fd..35e242b48870 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma)
 {
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_new_folio(folio);
 	else
 		folio_add_lru(folio);
diff --git a/mm/internal.h b/mm/internal.h
index b2c6c9435021..84aa3e6c8bac 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -971,8 +971,7 @@ void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
 				struct vm_area_struct *vma)
 {
-	/* The VM_IO check prevents migration from double-counting during mlock. */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_folio(folio);
 }
 
@@ -989,7 +988,12 @@ static inline void munlock_vma_folio(struct folio *folio,
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
-	if (unlikely(vma->vm_flags & VM_LOCKED))
+	/*
+	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+	 * mlock_vma_pages_range(). An unmap racing with the walk must still
+	 * munlock folios the walk has already counted.
+	 */
+	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
 		munlock_folio(folio);
 }
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 39215a3eab1f..4235a1518fc9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -316,22 +316,10 @@ static inline unsigned int folio_mlock_step(struct folio *folio,
 	return folio_pte_batch(folio, pte, ptent, count);
 }
 
-static inline bool allow_mlock_munlock(struct folio *folio,
+static inline bool allow_mlock(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, unsigned int step)
 {
-	/*
-	 * For unlock, allow munlock large folio which is partially
-	 * mapped to VMA. As it's possible that large folio is
-	 * mlocked and VMA is split later.
-	 *
-	 * During memory pressure, such kind of large folio can
-	 * be split. And the pages are not in VM_LOCKed VMA
-	 * can be reclaimed.
-	 */
-	if (!vma_test(vma, VMA_LOCKED_BIT))
-		return true;
-
 	/* folio_within_range() cannot take KSM, but any small folio is OK */
 	if (!folio_test_large(folio))
 		return true;
@@ -352,6 +340,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 
 {
 	struct vm_area_struct *vma = walk->vma;
+	const bool lock = walk->private;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte;
 	pte_t ptent;
@@ -368,7 +357,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 		folio = pmd_folio(*pmd);
 		if (folio_is_zone_device(folio))
 			goto out;
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -390,10 +379,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 			continue;
 
 		step = folio_mlock_step(folio, pte, addr, end);
-		if (!allow_mlock_munlock(folio, vma, start, end, step))
+		if (lock && !allow_mlock(folio, vma, start, end, step))
 			goto next_entry;
 
-		if (vma_test(vma, VMA_LOCKED_BIT))
+		if (lock)
 			mlock_folio(folio);
 		else
 			munlock_folio(folio);
@@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		.pmd_entry = mlock_pte_range,
 		.walk_lock = PGWALK_WRLOCK_VERIFY,
 	};
+	const bool lock = vma_flags_test(new_vma_flags, VMA_LOCKED_BIT);
+	vma_flags_t walk_flags = *new_vma_flags;
 
 	/*
-	 * There is a slight chance that concurrent page migration,
-	 * or page reclaim finding a page of this now-VMA_LOCKED_BIT vma,
-	 * will call mlock_vma_folio() and raise page's mlock_count:
-	 * double counting, leaving the page unevictable indefinitely.
-	 * Communicate this danger to mlock_vma_folio() with VMA_IO_BIT,
-	 * which is a VMA_SPECIAL_FLAGS flag not allowed on VMA_LOCKED_BIT vmas.
-	 * mmap_lock is held in write mode here, so this weird
-	 * combination should not be visible to other mmap_lock users;
-	 * but WRITE_ONCE so rmap walkers must see VMA_IO_BIT if VMA_LOCKED_BIT.
+	 * LOCKONFAULT without LOCKED never otherwise occurs: it marks a walk in
+	 * progress so that rmap-side callers, which test VMA_LOCKED_BIT, do not
+	 * count folios, while try_to_unmap_one(), which tests VMA_LOCKED_MASK,
+	 * still refuses to unmap them.
 	 */
-	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
-		vma_flags_set(new_vma_flags, VMA_IO_BIT);
+	if (lock) {
+		vma_flags_clear(&walk_flags, VMA_LOCKED_BIT);
+		vma_flags_set(&walk_flags, VMA_LOCKONFAULT_BIT);
+	}
+
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, new_vma_flags);
+	vma_flags_reset_once(vma, &walk_flags);
 
 	lru_add_drain();
-	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
-	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+	if (lock)
 		vma_flags_reset_once(vma, new_vma_flags);
-	}
 }
 
 /*
diff --git a/mm/rmap.c b/mm/rmap.c
index 5332c52909be..6661bc11ce65 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2239,9 +2239,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
+		 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
+		 * mlock_vma_pages_range().
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
-		    (vma->vm_flags & VM_LOCKED)) {
+		    vma_test_any_mask(vma, VMA_LOCKED_MASK)) {
 			ptes++;
 
 			/*

-- 
2.55.0


