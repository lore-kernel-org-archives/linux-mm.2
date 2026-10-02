Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345DDCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D32466B008A; Fri,  2 Oct 2026 08:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3156B008C; Fri,  2 Oct 2026 08:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD13D6B0092; Fri,  2 Oct 2026 08:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9345F6B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:27:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 264E7A6DFC
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:27:10 +0000 (UTC)
X-FDA: 85277611020.08.816AD99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D9044000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:27:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxL+MpzC;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790944028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHcwGbw/dTLavCD1q0Wz915FUcvfzunoMb3D7u+JUi8=;
	b=Ls8sR/DDlRC2ir3FIVtGXIj8ziHZQl2++eHVqx3NS//ruTed3zySnWjtpKghod5nHZ/0Nx
	nhZnK0QYOIwmwlI4xi2Ieiu1ApRxW0+rHCJE0sCtdlf4HMQm5Cg6KM9Wt2jXTYnmS05wa+
	e5y/tTslEmVBEO2gREqVbnuOZ1EH22s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790944028;
	b=lQj+pqpshzesC/ioqbc5F6dwQ/KbVnHfQEl3yu0x/uoiCTDbPrJigxw9DuCe8nlD+3CmeG
	okZ4cdabOdHSgBqduqZ//5q0BGHhkNZkbkZWVHwo9NlhM64guAtUmmAlACSCIe1KdtecYl
	Th1a9/bmDM1deaXw6WUSiOcEYgGXpa0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxL+MpzC;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F3D660A70;
	Fri,  2 Oct 2026 12:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8FE1F000FF;
	Fri,  2 Oct 2026 12:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790944027;
	bh=hHcwGbw/dTLavCD1q0Wz915FUcvfzunoMb3D7u+JUi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cxL+MpzC1cfSdjAOczoG1wPIbWTQrpCLMvzVBXSmnKiDFYDBMn64LTPj/OWtWuFXw
	 gMS4it0MZsivPy8icpf5Socvb5mYV2Im4m2dtIO0izWysvPZaaVznKHHE8BUgxTm84
	 r9D0MJpBzqhVcI1wDRYzLV3kd3Y/HTsDcWwM/QeLKcJvTZvL+5LlcKmc0a0aAwrQ2U
	 ZYFaZjVC0hCZ6nCAC8I0h5O90ago1k3NGUIsPkt6VWSJG/PggFTuZRQsBvT4/V6tEj
	 +1USCOD4kbv5ptO7N71o+f+lwiUaQKKZEz6kENcKDRXDz8XMOg2VDIFttVx9pefZu/
	 Fg8q/hmZlpmxg==
Date: Fri, 2 Oct 2026 13:26:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, 
	Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 23/40] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
Message-ID: <ar-i13TARsDuUsQg@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-23-4583d8a23bca@kernel.org>
 <DLTLQ9NOBV36.1D1MY7SZABEQP@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLTLQ9NOBV36.1D1MY7SZABEQP@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D9044000B
X-Stat-Signature: 5owymjwfio11bm46wdd1cf9h6u3xnfad
X-Rspam-User: 
X-HE-Tag: 1790944028-942443
X-HE-Meta: U2FsdGVkX1/AXkgboVIHsRrHD+sH1NCDOzSH5E9cwEmhHqi0stLWtmtt4y6mE9RikxeHJY2bNIxIzTb5tEFSUpm2cJvGMbyTfa8kZX5+JUP5Gz3ntnPfgUqlPHOmf+HBm8ZAApyITqGrG2yTgsEnv9z1ncIBqVLXnrsTi5+95uv9E2ZSv8t4UqbXratXAI1kHtcH4HXeCD6wUYfa1UrVfD1Hh7x2KlwK1SG0cGWQL3aH0Zhpx9NkfQzzu2q+18+c23wWL3j8cgy03YZiyvcGpb5AUsKr1Y0sdeYtOJYUQSnsswvNRo4p4e2JHAyvU59Saq5pOB+yid7VmG9Rz8NUi7ODuHqdQN9ULB0FoKjuHvZQhHL+NK5oVad6PdMkYrCQSksIYjtcGKAxM6fvtkYQ6YAo8vLzHugeyvJrzg5wTWp98yDraiSwAzEVVhOXmnfJolXX2dEVbjvlr9bMFvhS3eT3Kl4Nhgz3vz7qVRvrXzg0Emn42heam50q6H0abMdRwqZLtC+ANvVX0autUr70+iyvXTN7SuKeY/hZDdQWYXn60uiK0rgh5AAiXP25TDA6hrbYHG0I7JbhzWVYcSVvrmaRhGpbDCIt7Rw1v1YrEwsGKILspnfbsnQtNQZQOGAFz4h9obedMFKHiCtMVK+ODNATz2OLqwkSSYXvtNvx4Ls0qQB2zOFwmDnrOQDqJ6DhJiBZCjzr7pp7f4GB93eISw66MEZJhlKlp1x62CnKyG8SYXHOltSDQMfH/+Jhg8a1TEZJozvJZTcUMU1P6VEFRg3kkpf94O7At0R144qzuyN9eTirvmYu5z/EO8T/A/gJPDfrOjkDhM3yOMUk2/T7pIHsTdKBPDbL2F5y/HoXY7cCp3/rouJ3VXCE5S58AopRN1UBasJ/IgCf8mjCerSl4U4WVC9/r7Bcm0eFtcxhuRyU5RErbRPNPs6qCCK0rg5FIKHawlPmvWTwiGDwTZ7
 513ZfzAV
 HciTw1tR7wAZOA+O8HhjbWRuP8LBl0CFw3XMxqJ3FQIiFb5mP9GSUl453kV83ZtASVJmMABxb7UmT+/NVD2GnpyyWf71aGt7boRsFSxWPCbSQfjFNpSDhs0EieRqhXBDBHLjMw/DpmskeU5hAJhyju4hjv28CUWm3ly5AdMuABLJ8MIDjds+CqUqOaxL5Bl/6cYbKllPFt8ikW9OW/WK/AqBHudtqckmGs5ZERiB8PScyMYTec7Ednl73pKL0gu6KcFMqTANWAwTIxDuLHTaFgOrGti9LBOxkmkRfABAXsmwOkzMMqLgTE4AaSi6bjmoqo/9jLOwoBqmO2YRkRn2QJQxj3cJkUMC5ZnNoUEz5OgwJpwc9WLfEIOoav6p9XT7gIlpj/BIOBYWO54uC1QXUE8tbVHS+LjCBE/+Rr3/Tqx9sJu/KYTkikqL/4Gp1FD3QoWWmubmXD48fUw9/enoa2S7JWVwiCiqKQP/xgrg/CGSsdDg3OLlyXaFE5J9yWaAe6aPvLTGcfZYjSQGiwefGQanSDPrkkg0mllaQasyGsm65bkkmOdjGZVk9OvKO5mVp3nZEphAIqnlY+PkYYp1Kgz2S3NNC8oa6onCshB1CEmhab8D8qdXgLpVoTMw9UnfibfJbPbmNuJ5D7S1nOfbGJ33MRf8amff4onib3yOACkurhBAcsnTCRQI+jLLqJruP0pn2B8a91ExsvAQfiNB6GB2cg3Iqln4uvSuDJioNW/cXwZb62tIxrelnHdXWDzv5Gj5SDYdPVa9zRFm4PfeA5cdepXEkSa4tOsHfw7jYl0WhBi0OiJl+8J5hMEiC3fT9/iAtap9PS5NyoYgcCAQ5xZ0LWMc38CBt5NZGoCJVG7SBVO+5u6tnqJmgsaojg4x/gC2j2JA46Tgo/Mr4dfQINmDAVMy7bwhk2dKGmYTeqK1t9YhbIRBZc4GHggKIPjvfBwzvjkMv7gJgJryvnEE7/PrtTqi/
 2/VVGWll
 joYD/a0ri0Lyg08ExPrxWRWwlskTk8phSaDaNL+8/KAkQ2w3fagIa2wXMbPpXzURacBc9XAvpYpm+OzVZSCOmBdyn0BFqbNREpl8ueKtqwOszUtnESlr56i8tbMdkJECYwUQzfhMjMHbVQrPyxLaEysDD5qNGyhM2nhUElZeDc4tC/+HDNCJH7Y/Drl8yfcQm1DoK+SdIEc8r7ale/4JQZBQtPvp+G45ngYZ3fwlW4pzJvEtaCvLMW2fX96FQrBZkIw7gMMDJEb8phKZ59ktqPEVNlFI7UAX3yoO/GZ+oSOCKqHlBtolNgBFYYyjg8x+0QcBPrkKUsk8c/tFPyyTuxUq9DSuQNgoNfh7OCIh1vbvsh8na9hINguPIvKxdyTyAHobkVvbs7QuBGKd9Iebv+6dw1LfExWaQ88zYgx0R/jce5KfriWtdR+Aw+dAT5r/HOq2GQvUjSvBabXJtJgEqiKtR/9drjG3q0IGPoXIUt7srSUDDTdLJkZoLW0rlWCioD6pulUQD4g+p82FOczD9BbXp1QOwWWPDNsz7nQatmv0pLaoSsr8liBIbbBpZYjWcKKSgD5wvZv9PRsS2mZARijng+bwkyALMFXdnJ6r1WXRMiXe0xvHpEWZpzBJ/vPTz+yswluPdwvAHEBUCmy+5sLYKCnntUnpbZNmk2X8QUwdTOTihED36SXSGqbSahtQ5i4SFciQqwXzDK7TOY7RU70hXUFmwUBIqKYQSCEwk8u2fqIGWI1oKBmt7Etu1IGT1L8JFAdcp92/ilk8MZoyswPpeaGTUTVjZr8etrTareBzx+7w9mTmKaxNdFJoXdiePv+Hk0glhY6BfeAXCNGBnC9edPSMI5xJa4CPjIx3Hlg1ZJwEiXyznfRTblgkbMVr5i9m7YZDi4HrV+ZbkozWVXkT8WTAK57AwQFWiXlBcDtpa6JvKflUeWXKOblep32l4JkaP061loHDV8Yn2MZ3s2clv3YG1
 xFVJbOQK
 577d6MhAI8abSmQq+BtBykyLLjkTv5B86bI3fRNc80TSx98AhHjPQ8uAuK/Eqz2PuJVlDf6o46LP1zbUEKghZB1G8GDf332UAGkDmSlOh5yaTazzsHa/fDsjWAINveOGBOP7EcuSPid2vsNQNGlKMsd3iTlqL4p160tI6e2SfNhoi7RM1i/S6s9X0k5dsFtNOHHckq2v/Z/sX8eR5nYGq4M4CNCc2JfDpavjGLUcZq2nsIM+HUxMJx/4mYq1Wk4i+G3sX8yzTP260/X6QxbjCl6PibHkBKqJep7Tt/a0vH038NokuF3YtsuQN4KtmDxaGofhz0VARj3z2bi5jIcdTbIZM5Wb83zMzWhHxSLScWyrh8Y5OBk19ax6UIPU0n8PUeq7Ulal9FMpLSOg/KVAizn3Zyojg9oWx9aR8XjLgE8H2yLIl1x+n8xI0KP4XvvDYn+nq0IA+8yawKI9hQNWfQGWx3kGVOhPHmSA8JzvG/BUJh+4hblozv0yonYaJ7WjPV9BYoNe5EOeOsO6xpGvorO8GwzPFFlZCKreRWxmzaJBTnBZqXJkD9OkRFADrjLv0JSRRpBj+ykkU3KaBekfHAK4wrPlabE7iJgBLdIdjsfN69uIOutxzd078BDpUF4CdMcFTFQqLseliXv7X5UUr5wjy45cXJXkrOwi6Wcv4QQyZl6u4ZjVAyrIevCGQerGkoHQjmCOYQne0ghhaw+wBsFZ5chT/bCAddDd30om7PgcfmiKNpHJzgF5TM+a6pdtvdWNkzxALcEBwoFEdLP7na44Ien1G63QzqcVj50TXB7f5H5cEF4eHYxX3C+9e1OUsuRzY4BTdNgfT8PZAj8YQHi1GvZerhlrXwKo33kygKwip8nUhqX4M9+2T7Dgxd3a9f2EslXdxXFfCuJi+ufRBKz9sZYN+yWJ9Ygy7d9TO2GQkNpzLzXRwOx3En3maq/ocUwsF37s/i4xsM4W54iNiBSobux2D
 xyHRs67Y
 ZUuzpXWxK7ruGYS9JZUPj3FesRuhs2X8g6G7RGjlYDZNk6VOHpz/zPJe2xwLdzIU1wUSTU6NJD2j/sc5C9Ukixz2oXZOHThwRFIanGz3+l0MWnLOyc+fqw+9d0m2puWRj/mjIvxiKzUtO/mB8A2Xtb0AhsfxyiVCm3/73/DWTq2FDz1C4D1CtZTh4ixnR3r77rNCIOERI9iSetXtwvj88669CQATO8jvwskOZZkwUFDJjKhPYVlF2iOZ7kBiW/mhAxAuikolvFSSVtj3AxKmqMXe0UD2qy2NoDemzRDRW2120e/UuvDq/No2Y3DgAKzXRC/rWGyaXcJGz52/pSziFkw7o+ovsTH9+TkKMWIDyvimcaNfKKPuNHJpoOaWRIEsjDarBC2bBZKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 11:20:17AM -0400, Zi Yan wrote:
> On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> > Currently there's a confusing mess around VMA_LOCKED_BIT and
> > VMA_LOCKONFAULT_BIT.
> >
> > It is permitted for drivers to set any flags they like, with the VMA
> > already possessing lock flags.
> >
> > This results in the absurd situation of a VMA possessing both
> > VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.
> >
> > This has resulted in mlock_vma_folio() having a very silly check for this
> > scenario to work around it.
> >
> > There is no need for this - just clear the flags before invoking the hook
> > and reinstate them afterwards if they are required.
> >
> > Nothing relies upon this being set during the mmap operation.
> >
> > mmap_prepare is unaffected by this so requires no fix.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/internal.h |  9 +--------
> >  mm/vma.c      | 14 ++++++++++++++
> >  2 files changed, 15 insertions(+), 8 deletions(-)
> >
> <snip>
>
> > +	/* If VMA flags still valid for locked mask, reinstate. */
> > +	if (vma_supports_mlock(vma)) {
> > +		const vma_flags_t mask =
> > +			vma_flags_and_mask(&map->vma_flags,
> > +					   VMA_LOCKED_MASK);
> > +
> > +		vma_set_flags_mask(vma, mask);
>
> It took me a while to figure out vma_set_flags_mask() is an OR
> operation.

Yeah naming is hard :)

Let me add a comment here though because it's kinda a bit unusual.

>
> > +	}
> > +
> >  	map->vma_flags = vma->flags;
> >
> >  	return 0;
>
> Otherwise, LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

