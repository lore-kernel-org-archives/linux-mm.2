Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D894DC982D9
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10886B009B; Thu, 17 Sep 2026 12:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC23A6B00BB; Thu, 17 Sep 2026 12:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8AA96B00BC; Thu, 17 Sep 2026 12:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B13106B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:38:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13000A040D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:38:18 +0000 (UTC)
X-FDA: 85223811876.30.136661B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5C04910000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:38:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ll2Iicn3;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789663096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpQUY90Yz1fvoWb/n9qt0DfA+MP9PvsomcDJoStRF6M=;
	b=C7o0Oh7NeZYl5gPSde25J177M3b5YskjiDGsU0LHT/PPopsLrw2EDClgrNNsYp4MLOycN8
	Aa5qZ9g4QUIyYrcOh+ncfJn+bmoSfOYktifbcQbVmmZNngIFtwIHqAwSSL5uMEj5lLDi08
	knmvVxK7Cwvb0Lifny4H/ATjc+NU/M4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789663096;
	b=hLzt4sjGV4pJe4RX4HuBXx7Zy8RE7zOono5dpOEoWVc/m4+E1gR0fL2tFHsZbFOqU6yW8w
	UxKCnBW9rZF0BPIHWYHlQ6/81e+M2C4lgC7mvfSy1VhHbSBo/YJfE8AzknrAecryR8fH3t
	6pO/p9uoNIXk4uFYFS6MIl+Y11zZdnE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ll2Iicn3;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D68E460211;
	Thu, 17 Sep 2026 16:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02B21F00893;
	Thu, 17 Sep 2026 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789663095;
	bh=rpQUY90Yz1fvoWb/n9qt0DfA+MP9PvsomcDJoStRF6M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ll2Iicn3dYLgP4VwRxvy63UrleSMOQQihXo/WomzR/sIEgx5GaKP4U+NW4Lb0bdNp
	 uKjkDJge8PuQIeTx9lnMRLm03IMp1Usw/GKzwcJQy9xCKnuyLOibVtPP+3NaWmIfZT
	 ZxaOtwCuRFmWdwDLcRNeXUWweQKJVep+O0QYRR3W5MGGqwDUTXSmmaGOrV9k3gu/Fa
	 u4yjykT0wypyKnk5NYG7PJcfN5++PgNEyYQC0MtsFxZyVsHLk1xvjf6T0bH/rgeu5t
	 NRxxmzLWXr+qmM0VFyQYndVUgdCXL+qJqjapaQtC3XKXDw2eAGFrjqHohQPTZrDgH3
	 R+ck8e2+gcVKQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 17:22:39 +0100
Subject: [PATCH v3 30/40] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-30-4583d8a23bca@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1939; i=ljs@kernel.org;
 h=from:subject:message-id; bh=sRYt0UudvtAxeO0KRMBxTGrVTVnQqrjgMi1gjOlaTgw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWCB9WPht5l03vgd2TQ69yb55Xv/rEwXSmdfm3m/rap
 meO2wrLd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiZzMZ/oq8MfRPzp0m6HHF
 2O+Uz78FWXzx1+YWB72v57T8UWDxaAIjwwxWiS8XZ3ObaDKydWiYvLkWGv19mpb787Ol671e/RL
 M4wMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: bqoz93q91tj77urnnubqe8pq79xfmx8o
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C04910000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1789663096-72931
X-HE-Meta: U2FsdGVkX1851ZVrftPtmX9C8G7Fok9SMwm4z0rDJOqz2rIqDI3vCzUIeI4W1jTHGlNmfWjYwKBqZeOWoHCC04mTbWBCQ13LFpIrhYBEDmQ+MEYH++SBxZ3ZqLbUaNDbnLshalMzxjlLSVlcZhEe/UraLqbIVGsIt8v4/ovE/rf98/6+8cjjWrYuNkT3dapgEyfj7XF+vps2AVCG+awH3Pn6AeUWNAwuiqmONLQ9wTqiobbGY3xFeQIWdJ4kNCKQmXhvrVf8M/0Tqp9h+mlyUJeDoqGGphMDANTGDFEam73I0xr9fkmJT4lQkIK54Cl6eQMSBgQ1akNGYR3HzZzGSRm4XbhWB71PY4ZD5O34kFP/M+ncDACG3HihdBPaKHnfDHcTY7jwme3o+UMsFIJGX2H0ER5rZ7eXzvzkaQs2wYx4TfHQC4AsjI5FbiJ0sUDnQy3rWgLscMpAdj5ikMNmyBB3jZPrXLMlCdtZU3cRqdi9DKSwZS4uiSSNHnChcWCCoYhFMGsoe5CFkqLSuQ8sNippQlVevY9nP2F4Fn3JGGK4HkhCISgbY1Rz2VhxkZkx/WDuPkgrr8Pgpxy7mOj+IEVolgUmz/+NIo0oqYFVoAjrSFM1niBLrp9qaiBIZpw0IRk188FAEFWgldYHJtcyoC3uWh8A7JAZ6wlAlhbr9M1MBwZVHCkK5oowoInYVRwf6w0n2WmWxE+6yXtuhfZZmGQIY+n5JZU1RHGkX3O1tcetIgT2AJvMZCwLJvUptua73vK47TKeplnqVFNNka3YUmYhQSDYX+uL6EsByVeEGe7G06QhPmeCWAZd9ivPqljx7gKlvLp6DnHrp1DjtOhnZqFzaPlzF0MJ3KSIyk7BS5VOLAB+Awjkm+oJyx9mGu+ZtsvMjzrFXXZxVtd1/17Bf0N9PUM1WhjGcenCPJBTpJvWl7QFqLMOc/VF3hI7AQL44gLt1/Di0K8GiATrgOb
 PpAmd0KA
 GadRA1aQ6OTQqi48CQdoVeRT8Zqlkz2K4cjT0I8Nyrc8jy4kCmM+tcjwX/MC5XUpVT7hZVhIjKJZMzdVVeBQbaRDBSndL8PjC/u3UswPj8aMUERYCRrQBainduUEJElKOA/51ISN/J/J+/jvHQBivd/cK53I3kDaUvaS2uyRPQHw5J+ZYl7G/d46N1RxiNOruawGw7ex9qq9wbmkKDPJOjhTHKvh6/MecWriW32IJlxCoPjCoXzPwfehXfKRvklxvyw1WXgQ7gYuXvHLFz5iylKNYzFC/rLGIHkk1Heu7WAFvcBAoF7Zur+yZNgdsGO50YHBbCPcEQCk1oK1KkgZQO8DjBronGxe4/f1z2K07aubV/oejiv+NDol5Yj5p02mpBzvTnOSvyfl4vEHx2xWYpKf2dMZ3boIBYMLkXfzANDjg1cFGueISzWLJCOVzbsmii7sjd8lX1n1onf2fkhZ9+itt3uIIkgn+tFHHxtmZ+jMTfykrnFNiO9Zufnwbi5TIamcJKOq7THANuYFSDVot/wxBGSST1SYoYcWo7Xwy3nRni/ZpIqp7GyrS4/rlToU7mXxg1AFKNnZRxHNVFjoDLO1qvankpTCona1Lljb2QbD2wSMthPWzh9QzsJFm/r94sBm0MZErQCuh/B2h+m3G+oQKqYLkjNaDCNr1QBUKIIDHRKiL7zJv4SyZoAUeKIrmqG9C7oioi7ij5/W386eGHnZYSMYAv7G36umoRC47P+nf/Gedte336wIWrwvE/NBuOu3jOfF1T0vd1lD8JtsSk/irlbqH6xiU8IXnvoCeqSE+lB2ohMHQzlGQUbnAqjGNybkdnJJqYNBh7jqPzxA50ZTgQA6ybTGwieIRkYazMBQTw0CjmH18iDcV1FeH969IMh6AFoOEoSxjlecuzUcsTYaL5SOZrVUynh2Dk1VGUG9M9IXy5uMUsy/YPCPVfcd7UfPl46F+fDqiHaWyKV75YrafHg6O
 42BLkptr
 Dj0uMbL7VwAcf8FgsnxVqqilpG/gsCwKo7Ws9yallsa26LwZQ/28DKaofDd1ct0GnuW92cyPQg1R3ErqqO0nGtd0HZeGvZX7m538xX5TO9ht1nTUmZxy4cjlJKzHqEwjTwRcRyO2jz138N/nk3XDLCK0DIhIp1MuLpfvIyBKBO/zjTk3fAZvdDYYenuFsR/2GyxVpRAFZ9zFoXO8buKaQUIIbd8QIJ3RCQWwZ00CAjUh5kiDW744c92m9oQ0LiNwLLVPflxEDNRDbdbli/xLXExYM504hRfH1CVNFlVRPw6W9VQm7TmEXJyp9fADdsNle791u1Eh4jvwQrEsG01IqcpjHEpDU7xLxfEmjhWME5YDUN89lHT6wzqVVosT07xmKBlYH5NUcOxOWz6fGfGA4ztESrI/mfkDbyujh8lCf6HXEqQnbd1c2KLD++oAhWCiGk4udxNWocmd0QCxg4vCrTIyUQ+6Y5YMSnXiBx24lY6CNDdCRUhj2z5LNynNkNjLptHY2GI8i8bbaCU2BHqTKi0L9c2f3EjnVsXAR23qLWoOYN1DeJoodFCLq3CM6qwY0hOHkwhQNhDgJfZkbIBef/p3rPDQX52rKyvEVQK0+cdreWswAEO/P04rAro8Be/8rxRJkp4Ah0/eRp9D1sipU6QvUGT40zxDSe0ZWF6dFQ3PpEC5Tgcuz5B/jJqQ6x+SKpmTr259IYTn8NV34EACDZy8c95zT+q9TpShbn9gP8XU9rimPzG/NRGHAIHCtckuRI8TXlTVRd9SszZwd1WYIgkLbC5Y4RxuPIt5c1avWQkb0qJDYyBYtmA5l3V5TlJYnoVfYCkHY9f8UjuZk/TFnXK2yBZKtsDd9v+WSi0oyQcR5qNdwqsm8dW8JIQT9RCZCuIor9Qq6Aq+UMg0HOSw4huxi7RUwiV7wMlipdP+X78h9FhHRTngeG/Lp6YAKSt+RFn6ZYE0A428OGclQbjG6QsFH/MR8
 R9iNqfjK
 t+xW6tsWc2N2Ic6RwBq4iFupxawNEMxKJyD7KBtZhbH/3xHQFUA9+EB7g3C7aZ8XrRoc6qXp33eCJOST2XjW6tlbRsu8lb5sRzUOUAEoo3d9MGPT76USmGhGPYRtKTzMRfUHeavT1NZgMIW864F/68tYUycv0uyN0GiqFYi1s0Ic3ms6nJ7id/hlQj/WviaVy9XXR+udXt3PoNaJtADXb5Ja6/kzrwpAGSjMLY3eJc3cHAw0U9v0WpCDv5ygyiY8b/5+GHzOI2SD/eZwUFZYTSPdl7rDUGhMNzV4uFuaKGE6lxzIcHFyOvXi/eJS2cIB5nT5/78hfENVr7CZ2644R/CUZIqWkGlhHPNY3d2U8Wx8ElvLNW7nz6tB04fReTQb15NZoit6EufxcU82yaHPMzZfLFD1KhTK56/lkfTMteirpxnoaz+fZHFJOE97K7wmoSBt7/g71lqmdmR6v0j8pyyvDVNOye4tltbVxHkb/Gq+aB9yvryyxMhnaMh0XzFlwef5iXJX3lb0NUf8rzLGo4wavu12Dp9lGp4Y6uYTGsJk0zi3/8tChlhR87XcjEAmTdmETICwgWsUwp8bQdsu5kxuYsOXpRHJZDSims5iozJGQFOWsPht2RjlZKcWDv0xaB/BJqGeSGvFMhEQHlWKJ66/SMMeXZPhYBttr9eDu574OPKDq34qzzg+5lzigw2tMrjmGR7XjSYPDpI87OUAj5Mn5JQp/7w5JtqSqu6qQtyBYBx+ipRuzuqsrM9d+0K/RrjWdUW3fojFqZyaWZc+5VHuTxv7PajSS6rqdju9iWNa8KXCQdgCHWitzmXI70ayw2JptGcrkVgYrBaX/FJek+9ZmFyFbvyOFODLF5J3HL+76f3rIvsxsiEe9+CVcni29AYuVJ9zZiIwrWKLMAAIV02mNavcdmJKorqahg0gbtpmDixcRob/w1FWlS8Miyz64IAutw7PqRKfiKkEuPrrUKaj///m9
 7Lyp+PYg
 rX7uJEok4tN2afFkAsO0KWGJk5bwrfYgtFRd1TLm6GtcTJ5VDXtTmLuUeYKypLNH5IJgUqD8BbLVCMpAL5Bb7x+65rqW7ni4kgdRuTaIgau5Yp84w8U5ZzO2iAVoPnTFp5zyUwr/DHlFaEJfW13iSA7NSIGOJyc2Epla/mhDPL0RgpejKm2QWtjzLv6tGUN2or2JMo8sYJHDsb3txnkR53dIW9gTFKEVZPwPPyAk72L4194c1jfZdddwCDkvMGstRPhLCUIyc5SjD/Taq4eXATE5rVNPg4NmR13y5Dvqsl6Z6X2kjshKDDxNFEs+mUF/dcO5TnTnUE0ioilwbcSGVjKOf3zLjzedI44eHbCMp7aycxRVLzXhAAhIsuuMdPi0edASBIoXjcwO972dPKb0tJnPJnCweMAlKFzZrKgdVxxmJfj2H1Y4AAc5zAmDu6pfucTU05D/MERA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently disallow the installation of lightweight guard regions in VMAs
whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
VMA_LOCKED_BIT unless allow_locked is set.

hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
VMA_SPECIAL_FLAGS already sufficed.

However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
is set, this check collapses to being the equivalent of
!vma_can_merge().

Update is_valid_guard_vma() to reflect this.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 467601a8525b..0922d5f07a12 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1221,19 +1221,25 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	return error;
 }
 
-static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
+static bool is_valid_guard_vma(const struct vm_area_struct *vma,
+			       bool allow_locked)
 {
-	vm_flags_t disallowed = VM_SPECIAL | VM_HUGETLB;
-
 	/*
-	 * A user could lock after setting a guard range but that's fine, as
+	 * A user could lock after setting a guard range but that's fine as
 	 * they'd not be able to fault in. The issue arises when we try to zap
 	 * existing locked VMAs. We don't want to do that.
 	 */
-	if (!allow_locked)
-		disallowed |= VM_LOCKED;
+	if (!allow_locked && vma_test(vma, VMA_LOCKED_BIT))
+		return false;
+	/*
+	 * Guard regions require a VMA whose page tables are managed solely by
+	 * the core, which is also what merging requires, so disallow any flags
+	 * that would prevent a merge.
+	 */
+	if (!vma_can_merge(vma))
+		return false;
 
-	return !(vma->vm_flags & disallowed);
+	return true;
 }
 
 static bool is_guard_pte_marker(pte_t ptent)

-- 
2.55.0


