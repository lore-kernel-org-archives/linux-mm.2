Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157A4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 22:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3942C6B00B8; Fri, 10 Jul 2026 18:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345AD6B00BE; Fri, 10 Jul 2026 18:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2388F6B00C2; Fri, 10 Jul 2026 18:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB3A06B00B8
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:45:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CCA31697E3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:45:29 +0000 (UTC)
X-FDA: 84974349978.02.62E6C13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8DD9316000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 22:45:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZSx7QPoS;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783723527;
	b=G3pDyo0ovIwrthMtR8vD9gb9smf64cx6w/cBwG7wzgsgttvxn7fWs9BvvkTcbCrXKx2Gci
	ZD2wCmKAibbKeDETE1bSwC2h9MNp8y5HZRYnZUMsZY78SCkxoPrNGDwS2kDfDZUrzbO8Wx
	m5T+0NWXjATbOh54zb68OTtzBn0RQnc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZSx7QPoS;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783723527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yq17DLw8B7m0Ic0jrotN2vK5MclACu0PBR+dyFlWO78=;
	b=mkS70DAkQcIrSkXTOZ8+p6s6OkCe0307oRCTloP0PfwGvoRJK09j8REkT3GD37pkaImmIy
	E84cVElTN4DLq0oev8tEd9Dqs8Qv2Jklp0Mxq6pOPPob9vS6WgmMHGgGQD6L5oRdcaHjBC
	tdtkayV+XiMJ/QPRDVSFr2BNO/0z3eo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9FD543D01;
	Fri, 10 Jul 2026 22:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FA61F000E9;
	Fri, 10 Jul 2026 22:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723525;
	bh=Yq17DLw8B7m0Ic0jrotN2vK5MclACu0PBR+dyFlWO78=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZSx7QPoSol/yIwMXKEmUJhTjHYhOTBLc5mXwwU3UwAh9roiwGFOEkEGDc9BHD66gH
	 ol4A8UhH1Qv4PL+p4SHToO2ow21dRlKuMhNHReG860Gc0SP2DYkvm0I7ZKgAi4s3Wk
	 nNh7xrNAGItIywqfA1/YCTySczvPZbj9fgWwv5ao=
Date: Fri, 10 Jul 2026 15:45:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang
 <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, Russell King
 <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster
 <schuster.simon@siemens-energy.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams
 <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Masami
 Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
 <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, Peter Xu
 <peterx@redhat.com>, Kees Cook <kees@kernel.org>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrey
 Konovalov <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jarkko Sakkinen
 <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Thomas
 Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>, H Hartley
 Sweeten <hsweeten@visionengravers.com>, Lucas Stach
 <l.stach@pengutronix.de>, Christian Gmeiner <christian.gmeiner@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Patrik
 Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark
 <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>,
 Abhinav Kumar <abhinav.kumar@linux.dev>, Jessica Zhang
 <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, Marijn Suijten
 <marijn.suijten@somainline.org>, Tomi Valkeinen
 <tomi.valkeinen@ideasonboard.com>, Thierry Reding
 <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig
 <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Matthew Auld
 <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas
 <yishaih@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>, Kevin
 Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, Alex
 Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, Shakeel
 Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev, iommu@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>, Ackerley
 Tng <ackerleytng@google.com>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 00/33] mm: make VMA page offset handling more
 consistent
Message-Id: <20260710154521.435f67cc7b03ed3a9ccd423a@linux-foundation.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8DD9316000B
X-Stat-Signature: qxxz3p8htgzooxucmcykiw3peh7ocd1y
X-HE-Tag: 1783723527-205677
X-HE-Meta: U2FsdGVkX18qCP6TJ+GAxamSGeyToc4VkQsdqbvfiTZZkT7mtLVDKB7CDilpO5fZPDhCcKOZdoKXs0II2Cwzc8wrdvU2MIJ8KxWG8KSvGtIJgSC9ZK2pKGqlHCMDxJL34RD39NgutRLko957Ea31tY2s1Q9T6vfL18EXCAHJuSHhCdEaAMw4ETar/gQivMdAS7bHHQ1ZOqArS0kcocg879JEEvNAUVlkfpVuLvmhD5QEj91f1c+QM9ez/ElS0YSJKZIlShZSfUTsBWxm5FZUAkHt3vy4+o3BlcUyUk9/0bPGOBnUmxcZivaY6GJ2V97J0cXfv6Fv+2mmfuiQnbyw5euhPbvZydsmi0IM5cTJ6r2uFnDEgxW6XOWbDHXde29isn3sw1jveL9lTmmzxiIyLCRIt+Mr99U+wnj/ijoy39OglDjNzjkfYuIr0XDdcyyQrFaBBDe3lHkgIy486mtNBp9MgXneSOkJpvutWGC08orMxnz3O38e924YiBVIKeTnOzG/MAUC9l9naf4Vj3ZY8JXNsjmwpbQObF8jR2G+zEfwYJLEIY7eobereIiDsGR78tSTYR1ZI766B+yt4rKDOueowJM3rk8S5GU0N9ohsqYNkS0AIzToTQXTdQsiDwi/zs/dt2L6PKDMkc2wvm5GgT7wM9gU0aC9fGSOcWCccxkPNrRWFuk9iMhvM0DVErqFH5lDANlHDD9ivyfzK5VVbhPCUKD0dJlBJmpGoUUiqHObhemvq8qkNq44QTuLfD1evANFAopgWZKJpqQfjmOO69jmmj+TAUHO/hdco1jmj4WI0MUas8F2MEas/yDsbEQDvUNeRiKNJQNV4cQ8LE+XKfoCksZJoKSx3ivOPRgltYns7S5FiAqHM+G6p08Za1uckDK2uSoZPaV9nNGMeGILu/YhBJ++9fQLxBWEeyNl0/vVBZ2Bkuu/RFI5V8pXCpomkwTF5uAXbKhyA+tPRR7
 GlHNy92s
 CDZ79untp2b7gUf0+Kal9L5rDTW/pDo7g4VzLSRPPz/jPtamkitZGD9AEKmTOHlqQaOR2K8BewRD3KxWT3VpW6NhoHcO4UI/9izmXMpkLjzJ/cEwtwOvQs5KxNMe6M1PtjUmfOSb29PIi3h0PB9G/cJ+cSfHt3X/B2WseSgIhRi7Q7S99I4+qDsKV9uoNJrON+2SaxE4WyQ99UsdplYfHaXIvXleK0lAQkJFTLuwe0PuSYlZFTn1FqfsCapOipluVqz3n1votwFkwurEb5aQXp/OehlftBNnrP3xWanSGR130//H3xLP9AokPU8BY6Nyih9ccg5QDGvkENbr5dma3Dabmsn0OhkMKtaCqk2hI6BlGueSkWqoANAz/b8dvQBD/Taw9Te1z5Fn2JjKwgcC84IFO3laSI3PD2RKNutGB9AgygwmKHpqGvTRCAd26AOZ20/3ZdnTQKepxcXRpl0C+Eb73kcqYt0PRki3qRMQsIXiITPbk+1fUZWIBdY64m8/HMV7apaog+b/w6H3z5cKmzYYRCmFuqrLHArGt/xxquyqZeaJ5Zw4cMMQx4/Rfrs5jT9C4/ZjHjkvlzXca7B7HyLT2QX0INjwlA8OSlTO/LmJR3lesO/T6WNeBrwuvKZvFGjcvATz2V2Yp+J+HYiAN47Fa3t5gPGkvZGo5488WHYrWW+joEpqOq13OUkLeVO0muIPKX/P9A29jCPbd7TxPKhKrc8FTP96YqWQdR1d6jbVAFS7rFMAAVzxbcuwdnUs/k5DIAUnXfK/Gs7fkgkExnurZF+6IGITNTyS5/5zsFU5Dcl26QY16UUilUaHbiYBBIwqrETtfkovAV1Cv47ihgJivhaOJWDTSuHdulMjM2SITvf+PGhnH99CV6ZQ6oBzS3U2mPfpxbD/yuP6AbZcgDMIe92BEES1Js4S82KD2Q+C+orH5WQXVeyVfLZuhT4LSe55Hli6oc2iqUcKlbTXMUzHLpgIv
 gRohQqG7
 Co/HchHpb08ThwR/oW2sEdBG5JLQRgsPQto0aq0ovehoeryKnkXl76060lSjQGURlZfrcRA7T8pt+ozdunD0DSVIQsvH6Gbrlyuv7VLWIKYtrSDhuBMF64Dfmh4veCRmlxXtfjSCTatKK2e5k2VopdgcYOZ2Wf52gO5QIoFpVU1TUK3YVRhCnXN5RRHEIf1sM0gpYJ1ZQZE8RMNo5/nWyhS6lTd0kJW32H6rLsNnRPCVm4jRCf3rgH02ItYowmW4+AgNj1QEouBxKLkIFbtsZqZQ0JiIBUMtNLSLy8zFYIf8Ji3hH8C6ZIu6Zefprz4ogA9R8tKr4nLL0iY2nSbnAZfUs2+fw3QJBvvFhoY/So6SGvFUspmlIPPpCJJ0OBVv9u3iIBtd+6oTCNCgQX1hBA5bvJWhKlWN+x35oNZhFvxN3RzPuD0w7GlaUI+XmeS6za+I2dCxH957IQYTjAAXb0JNjQOVIugEui4nLX98kkRUJaPXjNlf/OiWeu4L1ZzmJ7se6+NE/r3WhMzgp6zmyb2z8VupvV1JhSDLC4KXZlGMWcKHKgPta/Q7uTAMrXZ9RRb+JriKg+srH4UqYVaYujWbl6DENgJ6VIikaBvj0qw7JjYUb3Mh4Q483w1gMJfFgzNIxfBfEmEmCVLLZb72I9nZhXfBROZeBdz8azY1D2N8W1tiiGBgDicwSfqm8FtWVTelTX6/GkWZzxrKlBM/4ckGoRAawCdinZZ6e9/pnopLMV0p62tVQFTsf3gGIz1NMT3+YU9nGs7rznr6gPJZiu8a/jwByqb1Gy4wMlgPWSaXUOYF6nrUocIu913MPpJtucgDD6jbB44AfH7Sh3sf4Jk0/acyw8EZkiktA62R7g1KPfnPKqdKcTS4rVZ0kqIEvubIL403NagWs0qOt7wWZ7c49z7VYUsNarr1tjzjdVFZhM/WQNYBYMsk1RHbTdgevwh51qYFByRMtQ4Rb+Qj14A3AHtDN
 I/a7P3DB
 lQ33Bkcw4teN+2z2EsX1Wl7hK6qyaMu87ibYwKewQ44hz5vkSJNIslFF4TM1rI57n5KmFV/kqgDusi59mOnLxn9xPaiyW+V9D9kbFt6L2JJVu24T+KAmbKYo3NEtDK0Q8TF2TzySh/iDTFq4F5U6G8Yxq/mcmi0Ra94Ae9NKRhUqrlyniDd5T1VCffhkkFDLxyu39MfxQ2ADYPB5F6NhvwsF2pGNhvDdHiKtqKWpAht9zL18dbZpq6AvcxK+H7XukbAMY96yztRfcrc9puW/+yPfzDQemJQLJse9DYHE5p2Iv0GVEUxr9jjoaoBcuHo3wLSm70FryvPqlHjv7gCOO+Catv3RZF0c8VUcUUuq913N7tbvkxDRaqR6J+5kC4IjAxbEzFWcTWq1Scb37+4DXLHQJVKRr5967M29fqLItIBlI+XIeyGs1WgqDhIEzxqxPDms4mob0y1zlg5dd88OX6Z12ISKOjTjhHoCeRt9xg/3J0R2o9sgrx2KNkBYK2CYldnpotsgTM+UjDwu3S1n6e5KALLDFooi+2IgVA2xcIlkMibI7QMCeXnhSjzrNID3hai4PVY/MmKid5wtfL8VHpezZtM/LwrWnnC2JgF3xItEuruHU1LFE3Hv5CM30HFfOEMRQOOV2xGtocuTKADBLFge4Ov2XxbVPY0/yswo0ggwG2YI+v9D1fvMqERQ/G8MYYMtg/ZpMUWwfxIYF0EKwDeMhvBqmeda2CMPMwzdey54RbQlzKrTb/7vRi13HJqBzljZ/wd3u0zDTET796VOLkYAAbqKLhK9sxaU9sZeJmo3STbMbhCtETvIH1hPC6pfZYPfODK/2edKoFCk2lobN3GJbG/PkwHd5EMoF0YDH17LuzvTkdBRgNLh57wh7XT5Ec5EW+dmFlqKP8Aa8VZMt5XQ1KYqmbsdWxXtTH+qBvOnMAf63K7kJDkKxmCsbjcWDHkSGo1bzso8uAS9h6NnxByQCOovR
 UMRQoM0k
 89Q9DAX2Fkw4e97LaBkZ37X6bbXVZLgboz3ZVGTGPuIy3vPFu52Qe1J8LGtFiAouySxRu6bTnLBe2PMy2LBVFm4yHD3RDV2Ll4imvuGbTjayZvsZniHthKdCNzdqQ+hHYt/hiMVlxFgWv5YfyCa/MStecIQN37uLOGxZrJeBdZJkfCkEGiLZJRv4gLdH1kHW68g4fMt6yLDTclTtGFRpNU8HvfHsIb8cPG1xnwzPK0pLAceakAIPoe9n4Ni6rVxN6VZUPVZ4apaglsvPZOPOfsnfTu9bmtmgmopQsZka6VpwZ9p/RdQRTJz8so+3Lk+Idj7BFc1HuK6eKAxVkWl+hMN7WV39ZpFLeTD+gyjhW0TZMW3BusI8TU0Cz3U9DBskw1pvFIN6pxK6PN8mvi0b6n2TG+tFPmJQPmngBUzNFwCbL6OUoe1CkYuOr2Bwyp3Cxyi4EXS7BmSH5ipZ2YVnprhCjF0Bb9QkRGCMtqnoSvmoObaqMRLFB5UBC9Rel43FRQxq9+ghWkDBxMPUKWKdW1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:16:41 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> This series performs a series of cleanups and improvements around how the
> vma->vm_pgoff field is used.

Thanks, I'll add this to mm-new.

Sashiko wasn't able to apply it :(

There were some minor collisions in ksm.c, thanks to
https://lore.kernel.org/20260703162510242nxmjbcLy5ccp1dbZSK3EU@zte.com.cn.

(You'd think His Royal AIness could figure out how to resolve a few
dopey patch rejects.  Oh well.)

