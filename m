Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AD2CA5FE2
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14DC6B0088; Fri,  2 Oct 2026 08:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E3A6B008A; Fri,  2 Oct 2026 08:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 965E16B008C; Fri,  2 Oct 2026 08:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6845E6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:49:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED1941606A2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:49:31 +0000 (UTC)
X-FDA: 85277667342.04.BC4E643
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B16E120003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:49:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQ03jCXZ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790945370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkQazKW1ZD8hcOD8s+NbH3X4ZCcNodhXr3IgrsR/4z0=;
	b=p1OSYTvLa/t6+b7JpI7P9MTGUA2omg32emJaY7osFE5886JM57ePSUXZXNn3xs/QDgXVDB
	lzxJXF14SaQrZLmZrVXayHIPpzMtEIPMPDbwOcbuK4FIWYqUWya1xFB1VnGOdjf/3leKhj
	aOplqFHv0jSIolQkno7NnVIOAsAtbFQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQ03jCXZ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790945370;
	b=OP1i3UgHBSvwJtZqGV1ROK+pM0Ru+pphp2mBDjBMz3Hlp+lbW8iXPeUO7tNBzUPSis0YS4
	eoF4xcZXUum1bpfGjF3jn5H98nuE7hurLGKAeaU6lV1TMGJXLNFy1B3ajTfTDBriKKCm9P
	KM8tTO+ymDr8nD61c2qZjfY9ebvHh6A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F3FF60A8C;
	Fri,  2 Oct 2026 12:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CA71F000FF;
	Fri,  2 Oct 2026 12:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790945368;
	bh=BkQazKW1ZD8hcOD8s+NbH3X4ZCcNodhXr3IgrsR/4z0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RQ03jCXZYJPMzUfwgkPjSnYeSfWRE+hKbPn+8rkamI8qG7R1fxf43HiOZd6kFuIJy
	 1Q1/vovHEFzMWBQukSDjS6/ACthFKyoUcooGbiiNSfYZJxJIqZBTI5avyKLysEVi34
	 bvj7/Jokm0b5rPDekfi1Uv9nfjY+kLXc6xMBzktMjau81XS48FkDeIcOTACsvovdYS
	 /5gS/YY8jKYnOLwgtkB/lsxtDx40VtY2ukXYM4o1zgOuWygg6vYxWGNLxDUQfJMmVB
	 UKlb1HDchPmZh/ZpA7DbpJScH43Y9QyYAzN/wa9cpCxCZrPbCno8taaTUZTibI9aJS
	 +N8s56+aAgg5Q==
Date: Fri, 2 Oct 2026 13:48:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
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
Subject: Re: [PATCH v3 31/40] mm/vma: introduce vma[_flags]_is_persistent()
Message-ID: <ar-luB9QVCRshtIw@gremlin>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-31-4583d8a23bca@kernel.org>
 <9bbdf4e8-6984-4477-a183-f0b236047381@kernel.org>
 <3557015d-23dd-41ef-9832-78b58587f3f4@kernel.org>
 <81e1e5ae-0aab-4584-81e6-3fc9c2634d07@kernel.org>
 <ar-b_Ug__TBzIZsb@gremlin>
 <2e5a4e6c-8f9c-4050-8998-454b83f4823b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e5a4e6c-8f9c-4050-8998-454b83f4823b@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B16E120003
X-Rspam-User: 
X-Stat-Signature: 9cwxr71pttzeuq97ipq9aaw13roxk1qx
X-HE-Tag: 1790945370-327257
X-HE-Meta: U2FsdGVkX18M1Z3WnDOAX8jjvr547gFOfr1h/hoX4t6PeSK6G0LRMZRfMDXmUkiI46sZW1qQVmUXPEiqcuFQsogtg/gCtz5aaqD1FwUHEi90k1Tx/gTW8ZFV9MpRRsPsE2y0t4seNY08N3FhoVGaIc4hi7yu5uZ1FY0Xfd3g9B/qlIXVfojQ9qcYrK1FPn32LPWS9ppG/i7QNaFJfJbnovys7VKRgVmhgkcP//HtkDFrCj/494HZlDAvr1O0rEnyP/agNY3PwP1GzVNx2Rv7NHkACslE6OxmjbvCQhdZooAq6W/B1DhGxhT/cH84w20zkKo+HZdE1wZH8NIu4+u62Apdg+m2V7RYOjTB772c7JVclBRJCCPoH5LGxtaBTeKBDYqgysRVa78MjZDL1ftd8wnSQIg4UryF1Pgz5qtbTCOrd+JaS4o0oEgrzqW+vX+VjSJXhMsiU1DmrzG5cYxnOTcBEVHXMXEphU83XXRxKjb0KnZPuDAY4tk3aQ8WUSmkuzH+EOUFJ+AywO2ZIkCtb4qhY1i9U5USfcQn1CnIvH37BrZ0JHghO/RRZEXf+AJmWNjXRD5GpiamTqZZFGuU2KeGs1eiBDJ2/6APTjYViIBw+oKRmB9CwiT3aorZoilfymbqtu9EhpcBvksoiGMKPHdXk9UQWtsU3U2Bf4rY8IfEacM5cL4LeCeJai4RYSkreSuhrVgoeBYM7PCY9Qczr96aTgbm4CUjOtjPdCu4/7oAoTMqxNzcvXDoFhSPr/m8plWnbQa+11LroYdTedu8D82At0R5KMm4+hGULj8np+1XyfzPvT05bcB7EXC4IvZxCI+H/Hg4NqLhA+UEbt5MHzrCTgXXHYToKp6miNWPHnx1sl6CtGK9Sl3LrgVmyFa2Yfv0wig35XGrsYF2mQsIzt132ShZgpiuqeICxl5w0j9tW/RV78J7payblxMMZJb1+cmT/OBWhO7oieWt88X
 udAW8h/Q
 cVq5uPQEl9X16cXEaH+HlqA6ZgcyKaCBhItViTXR6linqWMdRQr8BDNKmXDb9qr59Yn1PofqmK+njPKF+fFnGFD5Zs+UzXGAzsDBJGMxvwEKWJAUeNRQcMbzzCOBtecTH4ObvqzcHWEkg3poaqKacplsH+AopIax75mUwv8XBE0yA3q35WHf6uE7ANHEsGcgfwlgOKT+KMgJXXOQR8va8/cYgBDarf6rvt35P4NL3jabK+APQXNre2uFiwTcEobY6zDoSgH04NedIaae50wuKbeM3AFAICuCX7H6grW9Gs7+SGN3jzOVjVPzR3PPC5TyoFvOulJ1R69xP6eLNHkTOBC50pJYnUjxNidGmKyxKynzEkWIvl0CviRcDGzZgprmJz3KBfeJZVwI6zGmWhPufIjyrxIOpcvjBUqpbShlsYc6HFGRO1RVFqJ7K0/1E3PgDFW46aBdNK1ofc0t2kUDq+1oO82sO6sBWbewAJ7SMpXL3rOtKJL9ycRnKfWBzkIh2Rt2TOFCG6dMjol7mtOVV7nvvFGYGo3DgbLPvarevHipUoWYjhKxkJL/+s1Ff3bn0dSTEq944o/1cx2Nkjv11aL1w67FY7TR2D6blM49zGEvOhPuDYwYzqqgYrSVXJH8k6lgOp4hEVxavrUjVNhJLp4b1wH/dBdmVM0+odovV1t5cm4aoF8s2JszywUe+6vCjK2Th+nw55UPdVffGdFihW60rrRiyDfHWsvjWb5VKCrc9YZhYnMoT1UPB1L1wFtk1hZ9OABubsS3TFcDM7LWr3AV96HCu4PLSfx3OhtfKwPAU2H62td3EpiA54o2Rglbuddj81GQ7sG+Y/K/d4Wb6lZKYBNOXJUx4unioQnJI2wyBV0wmsVLaz7Lkh20R7xSMLjTFlLsYqe/+HtAC13g7Nlj0P7uZHFgOGDVY8h9EfKXcaWDlucBJXREc/J9fkuJ79oJ41h9/3m09FhyssVwq7mPhWyiq
 8MSM6xQl
 Z0F8NAbRGWr6HNrgkvKkGapOhY06/f3YMTx+pH5ayxT+9ej/5tfjiHn55avsKih9X/wHaQgpnKaeP7JtG2uzz5AKaR1ENDctAoE6+36q8IBqJnoRo22jKDDzJziG2PeE5Nh6wNqtslgyspwOY6r5y6jw4t3YZKjw6zMVaiY7reW3bo4BhdxSlUoLLllXA2XRREPtXGjuluYKmuJVYggrf1HV3B0dmJxPvlSRSWaZMo1Z5tf+iagRUR7FWg09vNiZgadAkozfkCuKGqyyKXlHx2A1XaCE1h79GcnDmIXwrt4JjL5B1sivFdZWIK19PvKN6SbDJG2v84VX9KjteM3OxDAnYfi/LZQ+UxXlu+nsx4AEGZtNpVuES9aTVvxax90saP5KVVA5yTsviDoVabsEgzIaZaQp6ScFUnBvryUZLQuCy7dmAYxJG7Aer4jwbypifFyp5347triv0usLgi++WUOMZpgxISHTdhCB+B3u/C/0uhfH7I31thVYBOIuAFePd6p8nuNFeQI0qIMCKc6pm27H1Td9yJiyotiSZhjSLamTDu+pKsPL88scSVdeH/jDcVsnS2QasDakic9v1SCROrXarN8dr85dLYN1XD1XGx+L/pwjjbQsv56Ic6nf1Xn9U3EQQjv8+ptmDBRNMLiqkbDioZu3Ty347aUuji2dQ4in+q3L3G55gLnnCWL7KGxq4V2aNYIJmNPRKWDCsmFpMOqbsPS5eI8MWS+PQZB6D2+fGzZNFqpaTzeJPpFJ93KB0wvhnVtL0xxWViAP2PakPBVnZob0piOGAO+tQlowWOX2aukXFEkm1rELQqjAvzTqbJ/YgadGyBJcvZ1pRQEhZXHQiz7uV2+fUHbwtYf6nyAZXFjmnGST69RHKxoW7a22LOsBrGAIsVDGkW2iRYBxvDQz7FPaIWienO1QazWTFE18qdTxqbGbVdohwoAXWJQI3GVkyTwB0+2B4v19boYAog/LjixFe
 WEfRWqmQ
 AcEIv4HBTDHkNUqHRiDWdpFKHj5XlppPmen83g3OmOIi+G8EMIfTIWTrDopc4Z3JTHs9iA8psEjd3YBjDAAKcjxyMw60YS0aGdhhsqYWHV/o1IwipEYkI9KBDi2op/XVQlnbXpgsc4lP7bbATvib88a/mQaa8xeAu3K49U9TJPzwe8TO/00dzBr05M/XNvh6WjiXkB2E6jdZNMjjq/JoyuswgijmddO56V+k3O//tVJh9KzTBJ9x6xx9TcZvfQgGBL+GOi6sD3lIYUI4cojIsBLIaO0PS1VeWiuaHA3pF7EHKfL+QKTTjCaIVQokVBB8dwkbIo37imt3bFINHaE1FQFYOx5vZoAHmG/AhVQFiUZNlBUMRW+F3oNc85m1sdUJpySu9ZXMMrYbt6UqfOLLrNMP/d+fIpo0/inPQewqAmp1n/Zu20fnqtKDX2rK+pzMWAyqzDdr/qYbSqqH91aZJ0Gceom7cjbIMMCEgvDoQT08r3fnPzZT3Umw77LjrVISKrxxB1JxOmzFDg8egDRcv64uVHR6fj308r6oocIOmPystWmUboR/EumT9PY+wyNJfqiSOaJbHkYEWVMLb/M+5Kizrn4xaGaIleLs6Zlgl7O7iWCcEWtsICGgcMvFUBZoXvRytOc51IrfRMnpXNMXyLnJUmsPdhZ+ksU/QoduOYWjtHmHOQaGcfWa0EueQyF44+Nxw/AUN0piE1jk1MAMCmJmGCandlqXjvJ3+M+LjilvhXW+3/6LjP4wT00nA1HF80f0AC2Gh9OC3Fsw/owvXQE8BFWnV3oXzLmcbjF4lWWBCUckz7RVHVL7+VgbofEgTcYDnp/Zux8p+1rYZhclNUHNKt22kBAUCbnfyJNoQzn6jqeJTbUKeFgtJVyVx1AHXV7P2Dz/8F65U9KPDI/ayvzIrKK+OqvAyEJSj+e+6GFIN5FLWsz9YlisQC0sS+vrnkvEaWmBc95s7bzDSOZunhJnS3I34
 1C/+6qoR
 y6aFHyc55VhI38TKHDkvoYKvDq8RWY+en0nbvDC/90L3FCSAAEft1h98pJgsNcIjdZYQIvBgwn1kZ9bJcPDzhwROW9cOqJOFR7heboYjp41OkEL2q6PdNFhmMArMe81kdUU56rVMGPTIm6W8bpbtlX/hiAu5ZaFtJLcwnSrH78o6v57vFggcMjlqYpUpBwfdONFn7BswW3tZ7QQWjoigC/AjlwkvVpSKcQ6JVi7XP9xffo3LyUWZE79uNNAa/gdKaXzke8GDmNB3bDV8oLNKaZIviI+1y2DOS6KMMOi+fGzzuc+s2YcLZRBT+xqMgymdEaXIToSLjCp/pk+t2RO/pgIxSxjsT+EKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 02:35:06PM +0200, David Hildenbrand (Arm) wrote:
> On 10/2/26 14:08, Lorenzo Stoakes (ARM) wrote:
> > On Fri, Oct 02, 2026 at 09:05:15AM +0200, David Hildenbrand (Arm) wrote:
> >> On 10/2/26 09:02, David Hildenbrand (Arm) wrote:
> >
> > No, see below.
> >
> >>>
> >>> It's also about droppable mappings AFAIKs. How many more users will we have for
> >>> that function?
> >
> > Anything that requires stuff not to be dropped behind the user's back, which is
> > at least 4 cases!
> >
> > That being open-coded all over the place is a problem I think, and I think stuff
> > like the PMD device private are a reminder that open-coding all over can cause
> > problems.
> >
> >>>
> >>> If it's "no others" then please don't add a helper function with misleading
> >>> names for it and just keep the special "dumpable" check in the new form in
> >>> madvise_vma_behavior().
> >>
> >> Talking to myself ... the more usage I see of the vma_is_persistent() the more I
> >> think this shouldn't be a helper at all. Especially not one with such a
> >> confusing name :P
> >
> > There are 4 open-coded checks that test four ad-hoc flag combinations checking
> > for the same thing - 'can the kernel or a driver change things or discard stuff
> > behind my back?'
> >
> > So abstracting that to a helper, alongside the other 'let's ask based on
> > semantics' helpers, seems sensible.
> >
> > Maybe invert the meaning to make it clearer?
> >
> > 	vma_kernel_may_change_contents()?
> >
>
> This is all super confusing and I don't think we should try to describe the
> semantics that way.
>
> Just imagine having udmabuf use a PFNMAP of folios obtained from shmem. For sure
> the kernel could now change the shmem pages that are mapped in some ordinary VMA.

There's always edge cases like this.

In each of these conditionals that this helper replaces, that's exactly what's
being checked for.

A driver could GUP anything and access the page raw and do things like that
too...

Without this we lose all that and are back to arbitrary flag checks again. It
seems unwise.

>
>
> Likely we don't have to squeeze everything into a single helper that is hard to
> describe.

I'm not trying to do that :)

There are plenty of edge cases I left alone.

This one explicitly is one that can end up very easily broken in the future.

Already there's been issues as I recall with people forgetting about droppable.

>
> Maybe we can pull parts of it into a separate helper with semantics that are
> easier to describe?

But then you lose the whole purpose of this, which is to not miss things.

>
>
> vma_is_user_memory() && !vma_is_droppable_memory()

I find vma_is_user_memory() _very_ confusing :) I have no idea what that means.

And vma_is_droppable_memory() is a semi-pointless wrapper for checking the
droppable flag no?

>
> Although I am not sure user_memory is exactly precise (pagecache+anon) and what
> we want? It's all super confusing (thanks for deciphering it).

That name isn't great, as userland memory is defined as that which can be mapped
in the userland portion of the virtual memory address map, and all VMAs describe
that :)

And then you can go on from there as to pedantic issues, the very same shmem
stuff you mention above can be put forward as an argument, etc. etc.
>
>
> > vma_contents_may_change() is shorter but easily confused with something being
> > writable by userland etc.
> >
> > Or maybe:
> >
> > 	vma_is_volatile()
> >
> > ?
> >
> > Which is analogous to the meaning of the volatile keyword.
> This is all confusing because persistent and volatile are established concept
> when talking about memory. And see my example above, it's not even clear what it
> means that "the kernel can modify something".

Yep I guess volatile vs. non-volatile.

But a VMA describes a mapping not backing and 'volatile' in C is pretty clear -
something can be touched by something else so don't make assumptions.

I mean if people are confused they can look at the comment. We argue about
details meanwhile the code is full of terrible naming that's duplicated 100
times :)

And you can come up with edge cases to a lot of things. That doesn't invalidate
the intent.

Right now the code is duplicative and I found multiple instances of e.g. drivers
doing completely the wrong thing.

In any case, you seem to feel very strongly about this - so maybe best I drop
this patch from the series to be revisited later?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

