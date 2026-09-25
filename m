Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F051AC98324
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4726B008C; Fri, 25 Sep 2026 05:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02DA76B0092; Fri, 25 Sep 2026 05:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E393C6B0093; Fri, 25 Sep 2026 05:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8DE96B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:54:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AE9C1A0288
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:54:27 +0000 (UTC)
X-FDA: 85251824574.02.2DAEE68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A4DF100004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:54:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MsAuqFOO;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790330065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F26o3Lz6j0FulgVu/J70FouYk+xm4Aj0BzlXmkWYx74=;
	b=NuDLQM7dEKbtZPmve50U7kelv7VMUVPRlJbv8dm1HrhIiB77/lymtxxlJ16Y6hp38hTg13
	8NislaAHHgSJ0g/kom5GQNVxeWwfOqhgkInicIYFvtj4PHhcixamF1ujWSzakMAYq1C/el
	Searf997YpdI8b5ZgAXDbVVX1h9YzNk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MsAuqFOO;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790330065;
	b=Y7wlkrdB5y84kvmngl1/D0euGc9aUg4thhPcFumr15DhnJsXaXb8zY2pZCiFsZ1FKityHh
	/XoeqOJo+TJ87VWilf9h8cIZ8cFlYPXGULvTqzCoIr4xJNcK6F32fhVHRY893ZQHjlucn9
	LC5eWY+aBjpvgIR3okfc23t2yiL6EKY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1910560230;
	Fri, 25 Sep 2026 09:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABF21F00893;
	Fri, 25 Sep 2026 09:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790330064;
	bh=F26o3Lz6j0FulgVu/J70FouYk+xm4Aj0BzlXmkWYx74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MsAuqFOOx+AF1dgN+IqsXkW8tPskls72sr+6/efWMWpfVIAlZSDWLuBHTrLZClhgG
	 q/dIOEfA2AyCRm9jA5KWXH0p9qG5z3u3QSSdut4cDfuHJ9MY2s5zp+Of3VIDKk9aQh
	 cjBRq0th+AWyc2+NbiAThoZzNXCNSNida0MNqGcbx/Gp+nAuExhBiSODnPz+COmnw9
	 Q5xFbgOZ6EBRN1Z/dgGPytz/TJE4uK9b62Ug/ZoKT2bY5zp22H3YyXonIbjvgfMmsP
	 Ity7rFv41f14MLa4FLJtZ16dM7J7DZuG6gjVmfVxCKHLOVNegP/UQM/eBy2REvzB/4
	 t2NDXRrsRj7PA==
Date: Fri, 25 Sep 2026 10:53:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>, 
	Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
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
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set actions
 on a mergeable vma
Message-ID: <arZEKkLGpHNQX3Jg@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
 <CAJuCfpF2U9rgHmhaDoXX1hxsuuS=s-oWK9Nk19TDQ6CLpjhFVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpF2U9rgHmhaDoXX1hxsuuS=s-oWK9Nk19TDQ6CLpjhFVA@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A4DF100004
X-Rspam-User: 
X-Stat-Signature: c94exub4tgg43k1gibq4sq4ub819h6u5
X-HE-Tag: 1790330065-352070
X-HE-Meta: U2FsdGVkX1/tQ3F937gdATHgrd28xMbpCGrTryO31rPPukiqpHoH5xQqx8sD0+o4DMAdQ8opb2tWbb6PuxRB2Wwp359S9kBmXYaE6PK6fWMzvyQ/CPw9W3l8iSF14sCejS5X5R+JNvQcQ5Q/GrRmUQf3dY+vYicWFBp7c8VkMffpO6RoRDLK6cTRbmqBK6tTvD4cpcAhme8thQuVsjSliUNHEIjMk8EwOO3Q1J8ajXrCzDntTQpkB8FfVbUyM2lnhDmVYeZugJ8/rsDJ3zfTAiJnkO4pQCmxblEP5YEZIjnHbXaURll+/kJt3vV29wMfG9GtU3wSw2qPXkL8QZJeZ8i/rbPgDXKDCRnViYa4mi84VYZ5f8D5sckySEa1nqagvCQ8zGu2HcVxuzCKf9aCzpguBV0vRTVMxaAKizqWvifxrZh/fLj48F7KTLfBMJ4hvKkc4NvDwzD+BavA9MfA0vz+Whd6M9N6RssOK4cuoclzgP5RPLFiRDzmM7eiKyw8w8/gTpBgm36mJoEyJeKkWZWND8LpHzDdkZCU1KWtBvWlXTbXbOqjhBFdBiBD+wolcKZ7b8Df/YgFAoPHm5vWEeb34EtEN+LDjpYP/Sy6s1raZlNSURPEG7zkIT2OzCUCCX5WwW4wQBrg8W/OKJOieTpTGg6yv6i11wutv8bfNcoNtFDxUh5PhubbGszrf6uzq/P188iyTzWfuVMvXDFbj98sgYvdkI0KEaFvXgqQ1xBJRPUd5D/VsBYzWXpvmApI81mGAMJcUn0kHg4NPwaLi2pVgcwCmp3q7uxJTJ7v0rPhFWOHkoGKSO8WGgmIEig3twYtTYS/nu8Fs/nmCZXEt3BkCsFVwDejfUKglG/mBOMRKnmJH9iTHT3fuIDCANT+9zqfrVoUPv5cMJ2Ycnw3UwFnGwzLQUu9Pv3M2GCiISvpfPx1oPeZt2ilQznC/+5XkIV3qZcwJ/d+FlOJbG8
 IkHBpOh4
 NejNqs+GZZBrMg006gPTKlWxJDNAbpitEh0lo8bmEPYLM2+AAqguYRwjcQwuiPVDTXyKRURHCTER+16mMXld7UYeuFpqL9eBF+bXC3D7qhfulUid5foLnLpQxANN0LrmyFzIAic+7aXZ5vxXxYP25rnEsLJJNFQlLmvzBwJTyWK6YmAsZ/1JYovtiugh3cOPw8GGuXoajhUdXTDEFEz7FJDmzfpAHd7TJJGUZQ9Ag3oHiMkBs5BcZJOSnDJpdoSTz4BzxZwfIHBzTEVBIyL7Zcq9Xky7P7sHbBlcWzomtk9IPzyVXX95lzq+mXO0p1DNaecqR7r8PBD7NZuWpB65J/0cEvDmItHh6b37SQAQ+/x4J2Pk9QP+ByxX+mUhtRhZf2tEgHtPSQjOMvv0HsnuU0UOefTDZEcA637+rsVmfLPU4Lhl+TCO9sGzJOwwGAoCJFIz3fMWgTaYN62DvjBW3G7xgLh9eFk3tkjb7xLMjZAXBr7EnIdg4hZhf2Rb6gl/rvL7zrvKHVgvBfMM+OZajuHS5QYsoZ85+ssByKP0yMIhBYTpa2iMGsZ/U9qpdZ93wPy1PhoyrTl7djYBhqbTxTkq+8sRJdAu93krtNhC+Pu22n1psP71p0ve4aj1n/eigY1zBOLj/FcZvbM5z10a8f/reVF4UjOOp1YS4uGxmHhnRQ3N8Pz1Ao1s7nu7dHJJiwA5KCphWg0pc7+b2F2+bYIUelYJterFnkoPy9U4FSroxupfmGJ2dkqU6IKxMzqGWBVbu5ndvrt++W7kT6eITdNKH14AW76jn8by7dwlqkjcmRt8IX/1jNMxoE342Mxp5xwmE8k7d2hv7RKuwX48Nt3keC2a0pZY1Q0WbS4uW1Cr/L2Mw7AvIs0z30AHyIF5bFHIBz1MBYSCXqt0VxEZN/ue8XIIXzUJdHx0nnaBO86ZOzX6IJj9jx1FiZru/g/KDBVWKnCenkaPcnah1MTAnPn/5b6zX
 onZK/Fvl
 XVUQ8yPZk8Uj7ds9xPpDzKJzDh1jxBtWV7ZCt2gfQ+9yJqD9/lpcfy6coEzwyKUg2jE59NZfgEMAYIjl7IYs7muSNKMNCmKNHGUYQxvAQbk7oevp+SOSXR9IPz0TirC8SVkQEYq0mcJByAtU8aEXlk11ZEa/6BBbEPgoARqq/WoRkX8oekf2bHWvKuGgkEie0vUcs/cudZ/G4ytNqGmFcBQ3PCr49VvLv9VV8Pbk/VEutlHbUa+73WCxifAxhzg+iKtdtzoNbNsGgMc/w7U3DKMCwHTgyYYAxHlZvHBJpvzkk8foP30ziSs0aHN6hnnTvHIUtRIn22fSz89xDUifny+VIZmFcubXsVcbRr+nrdHpjS4CoqTCuohT5jNlDm20uR0jc5c4GyI6xNuBPuiKmb9ux7VAsjDQKh6sdNpmZgrCTK+b+XwjPhRRjvYDfbcF5FSd9JvJ2SZyUu2tAIJUJJpJ3EtzHnNGVQEq94sWbCFSNE/KxArDkg4dVkUJVg/xCuADU9VtWBqlqBO0AqJaSB7jD1zLvAuYL803R8x6Qj1raDB/zWWG8Qja3beCdC6KzVUt/czxR5ZTb0UGXbj6jC6kIogrFJ3JMeEPmyj+DARNQwAWPmvLhiqwHt2nmug+dsWUvGXw1Wu/a5obmcPn9KWWuWml6lGaAROpwmoT0WFU+gfZXbF3lP8EaOV9ki+GSxDBfAMkNUfj4tVFfdrDD1+c2A+qJEsX1ItOx6w9ZIGRxJlr97ME37rdEHXXtFWlXBkZU/U4OMRFey7ic3JuaajNPwaGPb1cZd6ZPunply6qbGhRxCZx4+KT5OodnhbM2uR13/Z+XSDI2mtPcfnL24FIbF7GwboLtcRJehWTD/y902kevdYQwSgc1tLFtHTEhEAYqw1zOsSop19lPjIekfS35CxoP60uyV+D4UPM+dcaufuF7p7Ws8BePrAYKKXUdroivowXTWNXUQGr7MEhwYN6cRC0B
 6Dg1oST9
 vCeX0aAOJvxiB+Zu+BCVapXE2NUd/HHLyvEEq3pTkiYP9fx2zrht9X53gyNcVyusgsQdgKP7Ykz+vo6YvASMSrUq9cgdoENe5ITJcCTj+/LGYQWRlqtG4vPRINGtdL0uzFuUx0LUselx4ObFfRUvSH3VCPnAa+GXZtGmzE8ttLC0439romRFX2487aTYQMO3mKKKF6zphJ/eHZ2OK02gy4ANbVqHqm6MmV+IHVEQxxO7mQkTlMjL68l503sk63xKCc93eucfFc1V9dRcZ2iHKNpqfBPVZgaJTtvOdsqpq8N6zIkByR+PHUTj/55yBw13sUvRXjgaUD7KjEfmPKaPQfp+ca1RpQPoyD5TPC/bEXQEZGSbE1Flsras0J7vXk5Swv3qvydYZHhPEfcflxUHYdcMjaKASNte1IddZr38KWVKMivBoSGIng+wXP6g0bVoyXbOL/2fTu7pERhMQFDHPIoNt6QQbEnDDSmNnhj+JHndYEYti9H0z8GIO/M9nHkp/czmnrq3Ptm0WwrDhH26ZGZeQh5TUI2r1HEhaiEGc6NInhAN7kUSiGvt66yejdR/rrappsnO0eEOQlB7aaYIEeUoj8oKnXJQIXWegWUB1hPgVncGIYpx3P1Msf1HAE/lcx4r0v/bBLjTaqsS2ptTb2Ff73yrzE2U3BUzFLCgNmtJYEnkvOYEOgl4jcFgJprR9jJkbMwnqGQfw2mirkIKW0BjiazihjZWRY/AidZtS5EtvdDBw9Iv7feIcizueefvGL2fHfRna+OIck1NzoMiSulgfwBYuTsN6lZ6MmAay/pH5LPr2O7lXy4JUCsKYYjJ0k0a/iUXd/8XKw7c79bGEmxCDYa8JzDiDjZeXBctpKRDLPkPKNxJNCmjipjpWu+prgqPt4oj5rbYU1K5+qAhIqQV6sQxdz7+zv7dZnJuKrLJyAT2jVONIGc8bhkd0Jy49RFPiKsx/o73HFJ3+/EonyrXMSheF
 421+mlLY
 5DhKCUSJNnkJ+9g1TWjouIvyC6YLJr/8wGBhL7Lk1/E6b0Oyl8ISqItqXI3A28tp+WACRUzH9M8KigVZNGXRhfKETlDGrNrZ5fF+6jsRM4zWlW52ntl3Dm/SDsh0tEOHOSYaJT3eSGiEqSo0+GzBXLXHyndP3wPheTywgtIRYzi8boBnIYE7gG37Wf5pvvWdQbmvKDPYd62+WSOQx6QSEct93sDyVclRXq/YPVVoxUVfpv5V6yBACE3isoQ+FIBI/WGK6o5yzmm/Y7zM5cT3LXJ4cqt2n0cVZHPa+5o9FwVFsSGmAxW1vRzBn0vMh6/KRvAICEQj14/hODXLrQFfvpBABHR5Eitvz6OUfF15GX/LScw6mYkuHMB+WvBNxjKEqAqFnfla6efp1Y2qoXZfscySRz9nhXq+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 12:28:49AM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 17, 2026 at 9:25 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > When a user requests an mmap_action be performed in mmap_prepare, this
> > involves populating the VMA range with data.
> >
> > However, if the VMA is mergeable, it might then mistakenly be merged with
> > another VMA without having populated the range.
> >
> > Every mmap action currently available sets VMA flags such that the VMA
> > cannot be merged.
> >
> > However, to ensure that no future mmap action falls foul of this, assert
> > that this is the case upon mmap_prepare validation.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> > ---
> >  mm/vma.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index d6ed10cefc8f..62f2ce1ad5a1 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start, unsigned long prev_end,
> >  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
> >                           const struct vm_area_desc *desc)
> >  {
> > +       /*
> > +        * It is not valid to execute mmap actions for VMAs which can be merged,
> > +        * as any such merge would leave portions of the mapping incorrectly
> > +        * unmapped.
> > +        */
> > +       if (vma_flags_can_merge(&desc->vma_flags) &&
> > +           WARN_ON_ONCE(desc->action.type != MMAP_NOTHING))
>
> Any reason you chose this "if (A && WARN_ON_ONCE(B))" pattern instead
> of a simpler "if (WARN_ON_ONCE(A && B))"? Unless there are races
> between A and B updates, I think these would be equivalent, right?

They are equivalent yes!

So it's more of a style thing, as that reads less clearly to me:

	if (WARN_ON_ONCE(vma_flags_can_merge(&desc->vma_flags) &&
			 desc->action.type != MMAP_NOTHING))

And this version highlights what is the broken thing here (action type set) a
little more clearly though obviously that's only if mergeable so arguable.

I don't have a really strong opinion though I can change it if you prefer?

>
> > +               return -EINVAL;
> > +
> >         return mmap_validate(prev_desc->start, prev_desc->end,
> >                              desc->start, desc->end,
> >                              &prev_desc->vma_flags, &desc->vma_flags);
> >
> > --
> > 2.55.0
> >

--
Cheers, Lorenzo

