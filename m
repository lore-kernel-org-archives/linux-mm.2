Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8256DCA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C4A6B00A1; Mon, 12 Oct 2026 14:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDEE6B00A2; Mon, 12 Oct 2026 14:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F0F6B00A3; Mon, 12 Oct 2026 14:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36B576B00A1
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:50:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B57D2A94C3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:50:48 +0000 (UTC)
X-FDA: 85314865776.08.32C1FAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EAB3520005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:50:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X995GYif;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38uWEgDKI5eF78uuznuaCjVsoYczQiXE9MFjqO5oCvg=;
	b=yQoU3mvQlTcc9Tdh+KsXsu5YKOyEFyFYKhsp1+cBfN/zZ/RV6wNpbg7/Ahqjacrjormdv9
	H+klRvLlqB6x98grTjS05pxK/0k21hxypFK59/xpQwledH7XJ7NFxlb+4B5xeDmddMBV1/
	YJe+EWLnp58t6qSmMEqjH2BHqlqzHOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831046;
	b=j/PfA+3l8j2Gb408bQpjTA5YkfSb02vXpSbCCvdDxuJ5wTiDug5yQd8QEMrrOqxjVu4UKx
	IznVC7o/FKQ3iaoCneqAniq2vWZoPgt1w4fV25HwUpCvohoDWGWuJFnI2mumyQgkss6NSN
	HNKgvtJ9E3tcZAYLqfWl0gStCBl5+Dw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X995GYif;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6159B60258;
	Mon, 12 Oct 2026 18:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC3E1F0089B;
	Mon, 12 Oct 2026 18:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791831046;
	bh=38uWEgDKI5eF78uuznuaCjVsoYczQiXE9MFjqO5oCvg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X995GYifw7PrMKKJ1NpvxcWBaCAfqXTD5h3RO3nQXpyfK88CyU0oN+qCYuVNQoBfD
	 Et5yOHn0bPhyCs9Jo50EXVQeNDA6fO1ffpVJmOa8Em3ujV0bhTB11mmU1otlP3c0ot
	 JM2+sq4kPT0Hbw3bBDjmIr1uHp4GzqqX4oYOcHOTIMS3qd+6tN3lZAF8J214OWEKuY
	 r/nHBqo4YxpRZK2UypT3YwkJtL6SbjE2Pbe+lcFHHYIOSn4ksFr6ttzt6/ja3zVUR2
	 vDzF0jHc3Hyp4Fo4fyKKKVxhZcQlrrywc0fpPDd6ZNxltI1QoZzCxQKl3aTu5Hguxh
	 7HbTWgLExma8A==
Message-ID: <22dc04ac-c046-4baa-9bdf-a5ba07c0c0ca@kernel.org>
Date: Mon, 12 Oct 2026 20:50:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 34/38] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 Bert Karwatzki <spasswolf@web.de>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-34-923b70125b1e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-34-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EAB3520005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: i7e8ijjanoqspfqu43zxmrhryx58miie
X-HE-Tag: 1791831046-712485
X-HE-Meta: U2FsdGVkX1+Ue80GadHhyXaQP+kJAvzHc6v3nVEdHTlPhJHOK7cJmlhX9kCWmh7zPBB67o1KmM52lR5y9XUo4CddhlHtAjM1QoMtwkG/TtKTepf0DvxCnCqizRVcAD2lJGIatmm+NM0a8OAqjkBJPdYGD7JGa7vOyRXJHV0TI505FBe0PbWQ/MqLg1fyGtLcaZHriNLL+laZ79hCVEimbhWSwIxjhuRYqYanhhAZFoOc2dthCc4eFkk0g/qFP8Di0JK3vaW0GRMmV7CIM3J/r7n1Xcp+loev8Jws8O8WlCbjHqnA51kUAp7l7VAC7PnF+2UMZkolmquYH4Ecke5ntqideL62uqL8zU+R7eQu4FQcxrM47DUHYVSWovZcbdf0S+4/IFzsKDTnriZ0qj33oLTsn9pso3V0+MaPr8n+fyWukuJ9SL1lcwdm/wK7EDOnBOhZfj9OfRLvpGZggQVHHu5+G//lw39jZokxZLsM9AdOAhGshz7L3NKUJgALgitzYVMPd2DkUL3dklUYiy4riXDIQW35iUx9B3N0xUcNMggL99lRQPM7J1af4HgyfZC+poa4mker/agkPNXGwwF3J5gSV9zVOFf4yjmKkTFZ9fIot1u3e0EQ9ydSYnBBRfqmPaV20RKxJjkzuLEE3ISRyuUOXH+44rAmAK2hz6jQgl3C7UA5EunK546ih32d2bYuYE93Ub35TM6x/vCbEUA0g5SpMaX1plkVbSzhPsZBR4ULI0Xky2YTgLfKf+Po1AORlKYGG47/JQHVeuejtP+fW2XDrIjAhbBdHvLsyQ16D98ouHC/0mzTGjdjvOwmvLVDecKr/Spv48vHrci69XrlNKUNmIjN+n2ILfLdgIQBRzxF3uXgtODjNyInc6WJC+ash17G0C7cBxKm7LQl2tJZRF270j3MBkihYXb95caKfn7O6k6L572DYlwF8SDXGv4x8Ayp4m2WABoP+2IXBCc
 Kw0e+qqT
 AjJBza6TNnYZS/cBFLG/vyOF47In7ynb/gOXpWdjexDuxKjftJyYxOBFsd1P6qw9c/TsACta15BPNQbf1e/SaBBdreek7UV5zdLg7/Gnj3n+w+7xP5aCJNACza2WhXw8bRXqWJQJxbIvAlv5iT6KrHKYfkZ4Lg8A11TBKpArNYwiClx7Q8KMKeAA3PVa2UbDZQFLkjY6uZC7kBy0NfmMZvZBix6SOIQURV2oMovyMg2HW8Lo4htJfmnEW88ewjt8N+Plh9lZBFy4lNqOS8NNIhOAsslg1F1jKkwuB4TpW0hToyPJxWjor7tiW8VJKEOf7uazCdhlt60fMLjMMY9Lcgqe2uMM8EiV4XbDmFPjnc3J12cO0NQ1fhntKsvUU5KVKeH4wdv24ZWmClDDs1iSNX6Scy5wUqPPat/dlxlO6XAI9cP3OE+1sg49Y5705Rv5eeuKGi3Z7SQfQ7gqb4TvTuUiP0PLBc7bx5P+IaQspGJS2EFq1Px3zqZHfr6fDUX1CryQQdrO6asT+lDWQzX2ttWVEUyOVyTDUtvVzMhc/63+TLmhRZ5BMCm4lgvF0DewWrFmhF4C5cpozkgGpgr1V3mTKiXc4PXeiD92UH0fDvQ0J4GBuWFOXXo4eJ7eiXOBmJsbx5e5ZjXMO7/Bz+UTJen1dLdmBfhUFmZDWuI+dB7u5IQc9yMZcca0/1l7C9iLwp4N8Zd1LXyFU8khx059Odo0CjGiqcyCPAKsWavSmv8BhB0C1+n8+nyyb5tXFcK6wNyYaUUyFXc7Tf/XD/uF0dIHih2FQZaDwM6I3qTmU/fVV3oH6nccIjpWhj6DCvOpstOGINWZ1PNUCFYj+Tdeu3FS5pBNbTzgUdezgbYcisaEwgddyLCuzq2GP5BSESbMP7l9l1BDEpwE0QMoinZC+YkAj46RRdn57WiyH+tH8wyqvf42wrdh+8s7tV2GxWwe+UAWnJPdGSNvs5wofrmY+JU7CVK22
 9i5RROv1
 Xg1A9aFO7Pewb00hC7weo2AREEuRthO8bKLDwg4y3f8dhRRYnmNT6wPKTAha37AJ5m0KsvRqKyTWoi9az4ngjp2szwkJtD7wbi2ilsg8CSzWzAUQznN0QAMo1KsAlY9nmyQ7muncjDqYld+L5eP20pV6zygDqHgpBFWBJzJgzCxTnv8lEqvxC3WiRGXcai+Iavow0CFvnXMRPa0GSreYEpfQvrZhWYzouP59xWCExmzYVKJCOdDfDhWlH/T9vmXGUrEcWHhvw54wd/gXEeoEajHlg4kaO8Nos7IENhsQL0DLh9NDWmjU3W5msgp7FvCQdSrbDCuhrf/oBneHCYkQI2qhw+2egs6Jcumn0uEQohitEpt19a9CBDO1ksH0u+s1I6f4t5Ust/8IKuZQxqiPp9EmznSgpRWS7b0BKz+8L13WE0E2gd5oUMpdslGn8KeV2vCvLyRfGa30oxm4EaCClJkpXdgms+uulVaownRwIWA5ekr0hnBAfiMlN+RdCRB76pfaqGluuKd4stbqdpSq/PUl+0F+O12TB2UixI/CfFNmgf4FU14qxHXSJTQ2vrsYtEw6JRiXIn0boHB8vvagi+jzv/N5GJ5HxH77Q1RzgXPOVB0PPnu+TYO84h/c2Uh0QM6MTrgQMmuCUdf8FjLnjIyQBVMWnP6E9bznIR49bgGgXckGDvFRiPjctW71ltaafNKZ0WJIX5GWbzYRTrT+knM2Uneucc8NZovoR3dtDlcBr/65LCgC3fOfxnOvO3i52bejYOQJNyWNSUBXqcNmurO0caocVm9E84PbIwx2yybh1DJgKv6ZNu96YGrNk03hUJicOgkxKZoyq/P0QrkQCuomjJILAkerH95TAFhAeF7UuQeY/tMpV6pfqXeTEm4zzDzmdVRfsZB8/SgmK+Dhd4lzx+mDAy23JKFuVj+GctFkTLJQQxtYfOyhpT+D+6Gaue2QYYueVHtsgkhAwqRXa1fd6+s+3
 GtGDWOyF
 JKJrb7UNFkzKteZg4kmfEn5Vrgg/bJP+6YHhWp/a6mwtUEz4hLV7q79rHUViulq8NtDIf9uScUfOt47g7PGeK9PYC1iZdS1lEf5QmkhutnpS0RWEdhlkX1zOpufJeNmw9Tf12+pwezkvRj+gqEZNIke4uJ1oaifxpXGi8JiuKVxaQzT0rycb5+N7W777RGa6kHL/pjFqvbKtfV4lK8/7ktc+paqHAGDzHcHg6HFomao+vRCWRL430Jxv/aGKTw9JxosbfIV3DqnpspTOINeXFJyj2oEGYliZhfPyP1NWREDe7rAbkHaiofSnp//WEL5JusJ2Iyt6FUITp3KAbyOTGjAIIrrnBkF8H92PPiSmoD8YZyQyE7QzHXq7Gw+CcD0yAIrEHVhfeYUB4mEp27oANpvKyuBrGwBySXcKetPiEhXoUDgEtYKI3TQbPVWFVX8RDfTQW7ZRqMeleSUJ3bRPeGEJG33AtBed6ZpSm+p9Iba5Ql9KfkZ7unyAj46oP3ZKJEIdjVN/wHO0HcWI/zdtoBvRWpaE36Eq2pxtx6osAqQfZeMqhc3pZcQMmPFHN9y7xlWIBcPvJWxKr0vavssbuOGfbS/yR5gfWJbGS7SKQOfoqahDk/JkJ9XEOxWJBdxeI58Gteec2yQTsGCv/RXecdPTajmyt1QhvRZfidV4kcGWjF7sdDuXUBapNLtiTfu2iu7vnwtGGg7b5Q0ntg9Mxecxx7xmC2zePuZ5trqdticKl2jTNUxs51HenbGNqVtMoLh6xQr3gPAOIYI5EYRfUkliJYWpcnbStfhR9AhDT2FsQRtWht/mRKF9SCXENrDKbNDszFbrvDy+IZzk1LfbAeiwtOVDO3YIJhqN0sCUPS9LjjqXY5a8FLFuqiMqL1w29MU8+R4N0Sq5oyQ3XUk1flXZK/iT6dfr3lCjUzOp4TwQNSFwV2EdrceC4LMQtu+85V2Ir9zfyQGB2cHyI8L0ZIa/0IWD1
 ZK4T1zbe
 QmqZAlBBuzFr40aX8ashCJ23plkvflw5U6BdPd7+hZQCMZ6cKVMF9xHCpT+ep9mCzqeY+vQRPPden4+CE3ERFkmItfUelaEZ0J6xnklDQkkdmU8FiT3raogPgDUvuSCd5myH9C6p5qUw7n1gLqagI0RUNsQogtwhFt3PJCAKW4PtTFyAthrujpy261EHdb4e4nxqlhAxzsMzDu5j7qQE0cp29KryCy2QvyMTluu/5mHnNsqSAhO1cR52AOTlZCYiM7d9LndHS4pMK9xsBafcL8eMk3zG1YSvqFTQk+cUjOByXFE1dwQduZY9n0qyeLTXRg4bDOH7V0eReXdhoc+lM3SLMVOH72Z3r3PE3M8UWx9yJYws7DOo8nEY/FujglrPOSUw9a17e8Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 20:04, Lorenzo Stoakes (ARM) wrote:
> A fixed or non-mm-managed mapping is one which sets VMA_PFNMAP_BIT,
> VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
> VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop as
> mm-managed mappings may not set it.
> 
> Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
> self-documenting and helps eliminate the confusion around 'special' flags.
> 
> No functional change intended.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3b318efa2916..7adffe8182b3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4418,8 +4418,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  	if (spin_is_contended(pvmw->ptl))
>  		return true;
>  
> -	/* exclude special VMAs containing anon pages from COW */
> -	if (vma->vm_flags & VM_SPECIAL)
> +	/* exclude fixed and non-mm-managed VMAs containing anon pages from COW */
> +	if (!vma_is_mm_managed(vma) || vma_is_fixed_mapping(vma))
>  		return true;

If you keep the droppable thing out there you can just use

vma_is_mm_backed() here I think.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

