Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61981C79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 20:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45FB46B00AE; Tue,  8 Sep 2026 16:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410A76B00AF; Tue,  8 Sep 2026 16:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D89E6B00B0; Tue,  8 Sep 2026 16:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F33116B00AE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:09:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F9F5407BB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:09:10 +0000 (UTC)
X-FDA: 85191684060.07.3A1A2DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 85C21C000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:09:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LeCjzr7L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788898148;
	b=fhmDOJMLd2AzEzvBUKSr3H8n84JefO2J57HSu/Foclmffjcd0EFZY65fTRhcFkXwaRkBgW
	q9HvrrBeDWIiwR1TCHMcfNuc1vsL57kgS8Jm6ufUXMzsQyxCed2Hq+MsZ2o/S2U75fYHLq
	Ku51/0IDpFfwQyrIy4x64ccAzPZfsMQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LeCjzr7L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788898148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkAy/O15nPnQoj39O2Jkmru1wT+lgic9B+37FMixNf4=;
	b=0ynBzWzj0ClrZoTVvSQnDPuoiSszzjpKqDRXQRudgFPt5gAcmg16eQzcaVjWia2Go4a4zM
	mDAEGbbwell0qcvfpqzaYci4X8+McUpE3Uc73OnE/r3FNEqe58I2Oy2Q8GdpCbhczqNTge
	Qp9aqJByMqC0x0DS8+oyv3eerDhIIIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FA934122B;
	Tue,  8 Sep 2026 20:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B1C1F00A3D;
	Tue,  8 Sep 2026 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788898147;
	bh=wkAy/O15nPnQoj39O2Jkmru1wT+lgic9B+37FMixNf4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LeCjzr7Lxvh1mK11clJatYArBKS24pOQj2ahoUiXsKc+TMcQ3s0bRMEPuPKe/H5cG
	 ZsEW/MtqSep77H7nCkm/77+CSVWcqJoxGZbLCWl5ASvegv3qYyEmX0y8XC6Y0141Uo
	 af6EjWwftHJuxPib7aF1l8vclmOnQgNieZ2HZiXZ30rDUhO/T0XypyMo2NiBJytLM4
	 vPOstzXzO+A/e9TtkCQ+tQ4x7dLeKigZgNz7/Tm6QuEugL9gtJG1veO65ATNV8fJQy
	 ELtXRPMisE79w3KzHtZleS+cd+UVh9zhKe52slLyVzGy5GWrN5w3yIDSpibI8kwAuV
	 +VL06VNS0fwRg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 21:01:18 +0100
Subject: [PATCH 14/39] mm/vma: add vma[_flags]_is_kernel_owned() predicates
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-14-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
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
 Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
 Miklos Szeredi <miklos@szeredi.hu>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5413; i=ljs@kernel.org;
 h=from:subject:message-id; bh=JOTHkDDSySWU/FaBwU/dlcCoevcoCS8rHIuAzWMFwPs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWZG46/Dk21jE44vPvzcGS/6+X8j0O/utbrRvtXblW5
 8piq5c+HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIcCPDXwExux8XPzA27F31
 bw0Tc6V9VTTb95yHxzZq+2xPZsnjNmBkuOonutzuk7tY0u2ujD8rmbM+7a/6VPJWsjn8WMXKbT1
 7OQE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85C21C000B
X-Stat-Signature: 1jdp37ckf6ghtujjmsnzx6ennoefy9gy
X-HE-Tag: 1788898148-683077
X-HE-Meta: U2FsdGVkX18RsWVAzOIns2OxgM/AEcMH+bjnDyI55+rzoY011S3xlKGfC6A6bHE3Yle+TUVHqJTMgXtX2CIn4aB9C8OyZ6gI5pgdl/RFF1dPchjKNXUoSoA1SeCcVp11mhGvIE4JV6eXKsTvHhMndg08W8zNchd2cx81yPtWRH37gw3ZbY1FOJC1J6330UvDYgpaY7dVowzbe4d8YQIYcyNbBFI+3Ww536WL/0LTuYbTNPmFIvmjFwLXJWQy1aEl8se9l+iOY9YTlmiZxWwEOyuXBRbHTLnP1uWZ/3o3GnGH3lHTgQtbyYdVmhLvytjnktrfiqRmh7ScAt26sMVgtlRtO7JwjT19QV3qxFICQPCMv3I6pzRBrRfI/+aDqGyiO3LjiJ2UBQnqZslXfUdVKMBFAah1kIafb8OxaT/a7QsQQVpCZuAxTzsraKWF/WIJWqP5dAm+VHDoQDZoR5XFr18/ubluTReJ+cLMYP+utKo/cB8xKy+UeTetANNqox+8JGi1kJ67TFyuiQ67JSXDN+1hkzdZtMC3SYaiaCUE9sbpa9RU9fQUs/n9jz4Bw1yoiZlkd7AyXmhav9au5DOpZHZWZNdT1yGMEAuFbvj6gKLrI3924Ypy0+iyh8rxLyhMPqUHUXeTi3GJQf4xnrewk0M4hbAUoxpGsIXEcYT00TxJ5k1zRN9xAvIIe9utAVVKxirI4KHML975n9ZDB83+fEN202TqfyH6BsbRkKO/rpXcz+4GcLtWMCbuJTS84VY4LMhFyuY48/hzaAq3TjBhb5DiE7xbwSfGOnDI1jC05wnTrHzO0Cb9gcFG4NHEdQe9hfWvMlxDGd3+xCU8vapYkry3UHh5VpW7Qr38c6ockQUMhnRj1GQk9NHfpEC8gB26PBTa9EPG3Ixy6G30mPK5Cv+eq2BgTWBkQD1fc3F5G7gH0TG1kd7AD7La4yY8RaOJNyIRsTat5nLp+arU3sa
 EhSzYmzy
 TCnB644cj2gPcWaOzyBwlnqrsURFlxe0TI9Ldr4kTqq6rEhhXOwMPjULgwdSsiTQ7/brnwCyXfBvy+87YnNc7Kw5iQzszczacIlS91gMUIGatlJNhbcb1Tn+lUR6x2gIaFATt/uvm/niurT80CyhCLSP2Z/cdOM7X7dEGZYGs1c9iLiFEnsg/xsbY6x98W0qoGGo8frK/wmw1fcAGI5vV4RGoPK1sa7IaYyiP/zgWCKXoKAXORFwFCie4Gbos3Ow+9qu04q/Ghk9ZfkHUK9OBoprgqoVFPq3MXEfigr+n36Gi6w3aP/XvCDumgqU5V33ksHGT4HlCUXWb38ewJ4gLhinHvq2Gfp5wPTC4vsHvbRXlwmZ5V6VxxY5jjVXg5CT6Svxlv+4quBpJ/tDTeS0qt1VXgqDiiWWvzqQJ/qJBY0T7GL3T8+Tu6Dkdh2WvQiw11xywL3lyF+Xk0EKW1p++mQvDs6Vh8Lkh3tbH/F9jy2PuHCMa+5oD4ZVnLSJQ0wIYGAT3R4n4TxT6s22c7UhfOC2NfD0VXiNceP5x7Hyc6GMPwCCXJje7nFtBDAvcuevQLMnb3pHpBGq7t3juO4x2eu+Z23iYrU4SwUvcJJh5Gi0+qUIBl8lP5pVZVxf9kIyX5os8kXdCW8zxRphA8aW3SI3gKBGhfWHTPCuTUpoNiAWia48h6FLM+SJIJqRgwW+pzrv04te68zGuX9k/HRk+DUBN/2Ho31Q1fwjjqYPcAPQuO0fGXxCqxty/oB2CE0J7ot4ymDQTAfwUGhrND5BVZJsqCzX2+pKXPpliGra9VHGbRKXLggZ0vk3wqWecemFMI9o1ZimdcwZUG6ffmLc9n5duwfLt7ECSPCXWKTRR+hAFL1B06uCnRmrKyFfbZ+P+vkpJ/J6giUUOQuHDmWD0EikJ8nK9qkkiJKO87vGA8eJmjRBdnOuSQ1IUpLX6Que/A3kn6nRLulOuez9Af1keBy2/kP4o
 byoJRO/T
 dYmzJoGy7UK9rcUVodYg6SJyTRI6DtjVhdyve0bMWpF8KY9mwCAWfCINWSNQAHcSfiyYAH3F8cGtS038QTXKYWug8ZWJ10bQ0DgO6GcyNtHftcXYG4E12Eu/2IsKUqLbTtMmC7WFaZFfXFLS/eT6iOoxe+X10xHLzP22rL0Ny1b0JvZVR9iW4NRSOJPFYQWdYC9aSINm/yS0h9rJ2ugnKOLOQgib/tKh2heRRRRwi6dwOIjpm9xLgBmQRckbj25VivDpufUN+LE1hR+nKihoQ4lvmH0D8HpZDCGGuqUsZo3bfOWN8jBzEq/Z2+/6ArpGIes53YvCpHU4hzBPO05YbzGC9w7WPFv0lhHiN2gf5LUZd9RavpfiNHG31xyLyJpIyXEKd2nq6lo1IsD7lDQZTGDw95M/uYsd67tYnWIqpv0CtFIbDt4POcwHwVes6iWdpqdL//um0twzlpcVziIOB87z9y5oUzQtpvS+qNuDBJpXab3b5RChyeGx4TrSFy2pJWkEiwSo6MO77dtJUIbmejTZe3592iAIyw91b/U43wFQ/xKXGLNqhh2NJOhNPTmUeHCoIXxuMkZVqCQJ78eCWkC8J186qY1nYt17DNzymJc/NVxsT2lCDa5CuyxVMPpM0gt4p19BaFu2/gpSC37muUc8aKIiQgLg2ttYXKfKTOHlNC1F9qvXz3lyFczOOGnPUl1WfkmeFHN5rpuXcGxyolxVN1/8TaE/mbxEqvV6jcNt6vo3Hoq+dCrQwedNLnW621kfY6de2piO5xbBhcV5v1jpDwiPnBbAN2eoBKG3iG145agMYsUKXxsGmeAYN3UYmcjuMJ5f2r5lgkI/nEkUXHAPqx4ljZydmt8rPslBbJXHMNMFdAzVr/Dl1Szj/2FHpP6mLAr5s/DPK45Oro34ttKX/4abfgrPQC8Ja8v4OiZwmPlNSupIjfiONQXHoaqdWe8E/5a7xtE8akhLPKwG08oBQ2FFS
 q+Vymc6K
 PVd5GPCjbe3wljyN75VnFo5NW0nRnUMYTHirCsLVO8YySgnXoLoYS4OS85u4o+VFzLS4C90/Z+RjNUgNlvTeLHWR54QEZLGIDR8ppvcY/6ZetocLjquatSEQSEGZGXoYUU+M173/3yixIjUvzfO3dbGuRRzv/n6cyQfAubuyPFHhoKo8guI9yoAQQNniVoPs9KDk4QE5Ri8qAfGO8Vg5CT0hMAMmC1/c2t8kiInr7mOXHQKRC8NtqJYQngWBWPfw4Ptt1kiwmPfsXMJ6HMbYzW8ct5fzybL8QbO/GewKrmYY/IXuaVjjXO9DfLQV1m6jfeAiAlBlIp+eg6axKEphE4mZzwPbezEKNAJph2kPyvO5RAXJ2FSnV6gUIvbDBXGIlRG3+3JneSrPFZnkGEqc09rdmAgfLWuIclx5kPexsVOXk0DKH6BvsE8pt41D63yK4auZc/e4+fGcG77ITYEw/UFh9gUj9hxW0q7vAOv/x5ZONyca9YVxmnYmNKsbDS74NvGpbH3/AYem0DuDqMs7GaY9pC/vReTpXwqW5i53BSKsK5ucWxZiFk+z5ILV547j5/Tj7YOZGZ518hweSWcpDEcL9AIYpLwGG72L+kZtSlICmDNisvlVgNBdF6BX/ZTRlZuEicD4Ev6UujnY6GeCxW+kxqLJZn8NCufgT7eQN41/SjUOHrcj1tBwrbLfjU0LB39OtAl7HbLWzPMpKF+xu2ePuc7AfJkEgHmVGfXv8SyHP2r/d1J4Cqvxco6UAGaJ17iF4E4S/anrf1xbRoBwQyL3leeHQ6RpGfWMlh/nzNUwmLPS4M13oFsvxj7iu8ZDR3tGtsYpwvNQwxcbVG3LMEEv+Z31Up6bXk2viNQJkNpuRmsN9u0dCt2OlZL67e+sTiWKOHnxS7QrF4vPf0UsJYf+MCpACwlDXIc2v04StYciHKgg+9lmi17mhMuzF++aOauq/1qXNzaDIOhiaQsvGj6m2YqR/
 icmIZXRF
 +RWbwulc7Rw48x5Qm/fsgk7pAybGrzSQe7t8oG62WjrRPoFrl5EhZBIhUIzxT5YQuPwlm/3VZ3oTSYsb/RCzCDn6YvAfso+XU+GoOiYfPhnCEcIu5a1OF/BiFEVWfFG8bWtM3G8CrqKmuthufiofI60fAt53D6Mt7iaUMEIJ6l39Ak95BqH9sQEIKHYR2wd9TvkdL1nNxTOJjhDSRflS8VcubslF7AJyqBuohx0pVrX0Z2KYGe4IgGZTOXJL115mwSAh9/AWzwz4xtv1TbJ9YTVQkxSbmp+MowASRnYJZ2XMQvZdtW0Rqg2uzcTUJjQ0NxpxXR6cKaxpYz7zVEEFIH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than referring to VMA flags with uncertain meaning, add a new
predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
determining VMA mergeability.

Either flag means the contents of the mapping are owned by the kernel,
usually a driver, rather than by the core mm: the memory may be MMIO,
kernel-allocated pages or even ordinary pages the driver maps itself, but
the core must not populate, reclaim, migrate, copy-on-write or merge the
range on its own initiative.

We initially also include VMA_IO_BIT here, as by implication, these must be
kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
while locking them, which is addressed later in this series.)

However the intent is to in future remove this, as no mapping should be
marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.

This forms the basis of further work intended to improve how we express VMA
properties such as this.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 56 ++++++++++++++++++++++++++++++++++++++++-
 tools/testing/vma/include/dup.h | 29 ++++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4604cd011ca4..45c59474c853 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1612,6 +1612,44 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 	return is_shared_maywrite(&vma->flags);
 }
 
+/**
+ * vma_flags_is_kernel_owned() - Do the specified VMA flags indicate that the
+ * contents of the VMA are owned by the kernel rather than the core mm?
+ * @flags: The VMA flags to test.
+ *
+ * A kernel-owned mapping is one whose contents are established and controlled
+ * by the kernel, typically a driver, rather than by the core mm's fault and
+ * rmap machinery.
+ *
+ * The mapping may be memory-mapped I/O, kernel-allocated pages or ordinary
+ * pages the owner has chosen to map itself (shmem via a PFN map, for instance).
+ *
+ * But in all cases core mm must not populate, reclaim, migrate, Copy-on-Write
+ * or merge it of its own accord.
+ *
+ * The pages mapped, if any, may or may not be reference counted or map counted.
+ *
+ * Returns: true if the flags indicate a kernel-owned mapping.
+ */
+static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
+{
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				  VMA_IO_BIT);
+}
+
+/**
+ * vma_is_kernel_owned() - Are the contents of @vma owned by the kernel?
+ * @vma: The VMA to test.
+ *
+ * See vma_flags_is_kernel_owned() for a description of this property.
+ *
+ * Returns: true if the VMA is kernel-owned.
+ */
+static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_kernel_owned(&vma->flags);
+}
+
 /**
  * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
  * merged with another?
@@ -1620,7 +1658,23 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
  */
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that a VMA's flags and fields completely describe
+	 * its state.
+	 *
+	 * However, kernel-owned mappings may have established state upon mapping
+	 * not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, private (CoW) PFN maps encode the source PFN of the
+	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (vma_flags_is_kernel_owned(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }
 
 /**
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 52eee05e6c32..3fe40e0f4034 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1659,7 +1659,34 @@ static inline bool file_is_dev_zero(const struct file *file)
 	return file && file->f_op == &zero_fops;
 }
 
+static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
+{
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
+				  VMA_IO_BIT);
+}
+
+static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
+{
+	return vma_flags_is_kernel_owned(&vma->flags);
+}
+
 static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 {
-	return !vma_flags_test_any_mask(flags, VMA_SPECIAL_FLAGS);
+	/*
+	 * VMA merging assumes that the properties of a VMA completely describe
+	 * the properties of that VMA.
+	 *
+	 * However, kernel-owned mappings may have established state upon mapping
+	 * not embodied in any attribute of the VMA.
+	 *
+	 * Additionally, PFN maps encode the source PFN of the range in
+	 * vma->vm_pgoff, which may otherwise cause spurious merges.
+	 */
+	if (vma_flags_is_kernel_owned(flags))
+		return false;
+	/* VMA explicitly marked as being unmergeable. */
+	if (vma_flags_test(flags, VMA_DONTEXPAND_BIT))
+		return false;
+
+	return true;
 }

-- 
2.55.0


