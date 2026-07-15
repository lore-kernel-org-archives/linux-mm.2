Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8692CC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 15:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624226B009F; Wed, 15 Jul 2026 11:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3B56B00A1; Wed, 15 Jul 2026 11:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F666B00A3; Wed, 15 Jul 2026 11:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1005B6B009F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:23:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84D9F120188
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:23:36 +0000 (UTC)
X-FDA: 84991380432.26.3196EF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C34D940002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:23:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZHFyZ3/E";
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784129014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gADdUqFqdyogeafk3zRAASxcmVNA8sWMqOF6K7MzJug=;
	b=aN6ZWYvBXfksqOV3cF+pbRYlpkbx+6ydoeJ80gGCiAOdqMObuE9Ybc5i5TOSl2WiF3bh/7
	8mFUcBQraKsvN7BZUrYZB3iSEI1gOZ0RZSPkf+Iw+PuydxkzhG+qupSCI8XsJuyaLg7VVk
	I9QVkx7hY3oLRrKVf9pPPztWAZqI4f0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZHFyZ3/E";
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784129014;
	b=ajV8BXO/qvpy+kMdoCBdQWoig9B1oz2GGppe77cCrlkgcLbvmbh5HV5RWyyzWJt8QCNkam
	vnJmxhrkOKSXIdVYqB3kjHVgiXRx9Y6T0oTXWBsVywITacfmWJuvxepv3CboxBLPdjSMWK
	9AQo/ts/LLu3mOFAD4apgSTDEfI7s3g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BCD4600B0;
	Wed, 15 Jul 2026 15:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C0D1F000E9;
	Wed, 15 Jul 2026 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784129013;
	bh=gADdUqFqdyogeafk3zRAASxcmVNA8sWMqOF6K7MzJug=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZHFyZ3/ESAlbGMLodf52X6TrDO35Fk0c445fZjc/iDIOmZR8ceLOBcpqvIoraEE/T
	 zeZLVqqi8htF9IPg8x+JFm/Ztq0YO7W22l91dvkihGZ/j+CaDbNRZ39M+h2IRRAPJn
	 gOwM6i12c2CphR2jeaPmOSZdn2QRqByY6vZbMn4L22uOeN5KpZu94g9LE+GSWDYy6a
	 desBFAJqgZSmmDqsf6sL7guf2TNq50pwPkhffsRmu0Wzj0YQUUSEp7cTuNMhMWtN9x
	 FtkNO+2bfvmhwRnIK4YG/8FPR+l9FBnCEYqbL8I9dQIXx97pCo7on9ZfnrfGoOLbdP
	 TCsIyKOC40Lgg==
Message-ID: <e98110da-f26a-46ca-8360-fc84fc159bd8@kernel.org>
Date: Wed, 15 Jul 2026 17:23:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/33] mm/vma: use vma_start_pgoff(),
 linear_page_index() in mm code
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>,
 Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>,
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>,
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
 <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 damon@lists.linux.dev, iommu@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-18-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-18-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: osyt7dgyh3og7ax5xea3uf3cjdtrpci5
X-Rspamd-Queue-Id: C34D940002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784129014-109840
X-HE-Meta: U2FsdGVkX18IOlRx4R1w4GAhPeOVg/sFofidq87Bb8qPUKDM1YltGqt0MW8OjzjjQ4BuFwQ4WRh0ZDCb+OWVdFJcFFOab3depQsgMAK2Z6XyJY4rgxwkFBA1rC6XQlF5A49vYZF3v17JE4nFFJwq/EP90oQQ5p8fhDspaUeHPA7qGXPJOw0YZOqMUd5oMtIIAF5zDyYzcJgQsnx2dFhtaguWx1WgEuKd92vF5xOYt01EeSsfuMEtaKdv8l7QMorfoS5ZDqVwDHOo1Ip5kd1238x671FGw8oSojuddyAaLCnL7Vp4hrfJyX1sh8mQQZKdTVsr87miYwc9HmJnyWwQMSQukivfgVwyL1NS50a2ii0TypgzOVRW4y/FHZDOLSvRCq9YKFR52IcEA57VEKwGdnlMSUSJ4UocGrO3RSHbzVPboLNXuzVdeRNben5K1sGVjE4K9HLAvWVhajcu1cdJQMf6REFjdBnUS1CKPzmjPK5gGcLKoI/K8n/fhYLHeYQtDIRQREypO4/s3+c9zv3afoxw5pln5gPpWeKy+Flnh/J8UU+vMseKpAzo3A5mm8C8YbYBifaR4IIOQkTuRUw8UsZnhYzbD/UmilUv7VBSXE/23LF3PkTAA8BYeyLzaqdhiIpn5NhX2Wo0+3eZL/mMMPmk//2yYA/h/9gi3+kXOAgRe+wPnteA/2nVzG4y89EDnJO9mP4c9Y5GyfcgynNrFXVlhOBqqlbk8z7qGgtDV08wMCr2cdpEYnI8UEFXl+bHZrlTKVJUMXI1evgJ8LOgmTLrkZrwNTK7Rd99mfUko0cP5wOURNrRqI/RshJJuMf0hZPBIveCtWH6DU5l4l07w9X+gXnbxpTreInGpdV8hA7xN7l1TfvcAuWhdf5ivdEqKNSOHLwGSyBOsSMcsjt2VsQwb/ldGOc47MSl1lGtJ9a55e1K14zBv2iZlyIr4xED/sZ+vwg3a9LrFk5UMiA
 mPh7toAN
 9JV2BcQY09Dh4xBSrM7/Sw4Qur2Ml6MzyXNs9KCgug5IJnPY67ye/C9ge92hxMf1jEUTm25NBU8SnYATI53Y1X5sZc1TiqQhabg7kbwOv8lyJEx1V5LmIQ2kjJGWdwOSkMldeHkxovXfUNh15tZ6o0+erVBsjQZgdeAdFjA8FlDGBF+11TxaI8A9B3ZJhFAgapN+n/kJIwNuAoCt4q6/xFQcpMMzsJab3TSN419rk1uR1n50aRGZ/TTatAKWOicJPfMR4MYo3Fm2kyNqn32DANoNt3EjBDrUNs6QupDE3PF75bnlFDpq49wo9v8YYu5Rb5r+jrSijnClWzDGlb9cCeK7Fd9o8jL5SPt7L15TfkDuo1uewNGgRJxsiGE8HZvArthsdKKz0YTr3vR8n4MVmGWmilKjqv/x5587k0CAOgVyKuZHqTyzrl6evZTszlhqxITDuiKWyUP8gIiRhVFJZ651zBnglfU0Rjx/3CsOsxPBKW91A5mbsIFqteVZP2V6GgcvDeWLIZAfjSzAcWTex0bfwIBuwDdK3q/pwdR1xxXq+eZ/e+oixOPdj7r8Nx71ULS5f45vW+nodbjVugr4cae+PqpUwEX3V89k/NRMcCx2HgM9RKV+hr4KB9jc1qkLCCLsZcs3kTPTWfM20IRXerFDz2VjVHBv575KDvHijO8ML0z0Dglvx5hu/yNKzOk7TsRVjaAXvMXMh/+mU81G3cL9yA0HiDDk4tKNUXUaoVnATi/3oXSLvPzTMcxAQAlsl9nQrJd8e1kZQFjasO0+Yhmr0biXY1cOy00XkEkCXqfDUyNCz3RKtNFDgfhizas0oycZpPfw8DQGbZy7cI4nS2iQ9IJ4+MT00Cb66BX0FtQKBFzxKBleiSeyR5hj0a6//0d8FO9wcATKbk49MckO7WVNuo5APHNYiBgkfCD5pbait4NTcNo4OOin8rBZjjIFtRG9LWeFBMCCZlzi6xd0lioVfl+QJ
 QjUXC37Q
 4FjIAUztHP9nLwZ3Mk4x4RORFMBq36Oavc6BqzQfka2CpadO55wsrI0hP9Gv3YgbbDUdTeJ9vNC6B9FCVxFch0J2FCcLEYwTVoDe2e3WCBcO/X22GanaZwdFJWvQobvDGqsks2ZblAlpqFKhN7k158AmBeQGzCFMrYYHtYLG55j9n53tSIY1Zkl2K1hXZWV86UtWRQPar9PNSB4DhcZKB3mn71FMBdKRfLF0yGLYOY8LFAdq5VuAjTuwcExpLvaKdAaZJIDt/EZe/4CAAZQ0zVeCXx9OsF4OLrOmqDS6Rj7MjNH2AZY8PFqT91zM2Q04JlSWd8IOgdU5XZ6Gh6lXKmnJsfrsZ8KVn7iA+VtgNHapwHY9XV7IG+xrp6QNwgTfCrXbHvW7iZuQb0iSfWQGhDZw8+BHhbIuSdFornu0AYbnJsl8FzRH94b6kmli54VMeF5lhiu6AZkioBTuaKKqAqXGM5clbtQDMBOL8UouRRaVTccCfYLxBYKCfqXQTtWlD8otzVFW9A8sHGY9nDPHIugJRRZBC1FhYX9vNjHXF14biEHqxlKPtzgcMq82wnIdKPcqR7aYmjDkqwxGDsEqbsPWRLzhkoQYjBSBhf4BclfcbNp0fGSY3LhM1KE5kFLlJTywELfpIWRKiEdE/HNtr257oZwKrcZvL9/iuZRQuDtPfNVsxJ5XnBIku8zMISU1A7CBt/BB4MuHQc1oAJnUPcN9c3q5ErR0UDRP8vp2db0CF93HW3JXA6l6HgkJYwULFFubWe/6h/OYab35W0lUJcMmmePiVz0lxnZSIfnEd+iMYk3Uj+OT06uAZTVri6AvaAH0y4366Fp2KR6jPZIAwSlKjdaX+dlq/W/+hmGVY4CQXDIpJ9bLPfHuIVlJTSGD4xP6Qz2PSEFd/1/5ovh2RrI5kF9pMt6iNVGAWws+ftB+Ty7wMq+2QmnawF1LkLo7WPRrArfa9ChXuW+xHrTTmHnIBFKfF
 i4Rl5Wlr
 Uv1bgW2fU69mXWCEbeRRVLXmI2SSoltuFLPwWVmzI8ORoIrvh+umwNrZQEC9buCVaCmInrDGK+tJSl0xiICsm3T6fPULYEfnzhTbq4VU8JEzKOqoAJdselZzDjwbvN/Z4sqYN4LeajeLa4g5QwJZt4tzaZ7c/DAwG56MNpBqywsI/XIrRMf9X4npiLF6XNAOpHeu1Y+v5NRj0JbUgVVY33jC6BYNop30cLaNfLBDQCZEBWTrKHdDL6ASqsW5Xz4Vtdes2tI5lrkzblwUQtZikmVNjcm3+mlUifK4ZtjT949HXGrUpgq94GiCMvB/lUgzpE/xrAOLA8szlE530S5BAX+bvpvkfWnQY9q5VIW8jhmOwXNG9zK95uOYw3IH5zCswtC3O068HZ+SqZFiQ+53DhGBss8feNXttFRR6sz/0NGnOHXbf2qG/GsTsLMLO62cfNdbDmAWeZTRLd4M0+Se8IwapU1U0PTdrqAQSc5ARFl4YWqxmvdTpYOvkAw7XOAriz5TAYcG7xyoD+wAD4vyVTRTNFWQMgsAsdxScAGisCs5cR73HTYVLWkNdF507R7aq8NXDa4W64LyOUIo5UO7Yv2CRI8v/ye3+NAVey87o0ZVAOtcyFnuSK/u3CYGjqQXl03DkR4u39nEN5kFjW3tVaNu2JP3bDvOich9c9MJSia4MHGf1IZuG7D3ht7hhTFvdUd29Rjleih3l7+3wqA3wPwyPTvi/BDANsyun15S8x8anFYVzpq/g30WXYxjZ08OD+p0XCWlV4vUf0UrIV2a+hA6jQXP1/q2FkzTpSp3ZF3nDxG5oDs7YEyrnm6uYjbaMvo/BT5mhY719Xc0+3fJuf6jqlkRHfTknafyLbM2JkwyPF/aGIXqEPgYXTE7Y9wxfmOD+akqsmyQlUB9cSFpGZ+/ejdx/v929XsN32bjTDsNv7smuy5wme37a+YgHmoN1kI58xfUTZ80qlC7Ufvk9icdIclJ4
 GrRmksoT
 OiiJtOJzUZk4cwhDfd6ch+4po8ycsLKFj0MH1m5lBxOsDQQlb0WGCBuO2CJSVBMY2RpfAh3T0FtqEV/n253eucGgcGBTLCzCmyYR8/lyCSndgEEFgco4YuAn1h6pXlcr+hHOfPD3iNWdvANy9oXr5ypyr/2hekSFByvTb7F8fmB/mZa1HBZLJ14plHUrWaDNmn9/D7Hj30xIWY3V7OWXfsuhy4eVl2spR/UhoukL82L0HMCp0UiiHvM25svMSEUovzeJVvs80lhgwxr/wPHRfYQQEDJ7iIsl7ZKwI2f2mlV6LwUQ5trgZqHFgOOd2xXyK//Dit6YsRGD+Bk2DctvfyL66OzD1nQKRm6zBaGMZ4tHyls0VmK4FVHFSdYG7jAOZ5xvZJIPrGG8qfm8NhY8mTG+wdXU3NI08TJ3qE2ex4QiFC5ISEZGOH5huIVibGI55DqA92Nv1VAYjWnDXsq358YGP9PZRUyFCV87VZikdpFHaRD8oNwkE737FucwpalI96Ub3iz7ApwxjRWl8nkjglFJFRv/9BDH2NPk+5TPklvRIsMfs27J6dhJ+9gv9JF2V+ov4MEW6qvtD6GiD/Xknk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:16, Lorenzo Stoakes wrote:
> There are many instances in which linear_page_index() (as well as
> linear_page_delta()) is open-coded, which is confusing and inconsistent.
> 
> Additionally, vma->vm_pgoff doesn't necessarily make it clear that this is
> the page offset of the start of the VMA range.
> 
> Doing so also aids greppability.
> 
> So use vma_start_pgoff() in favour of directly accessing vma->vm_pgoff, and
> linear_page_index() where we can.
> 
> This also lays the ground for future changes which will add an anonymous
> page offset in order to be able to index MAP_PRIVATE-file backed anon
> folios in terms of their virtual page offset.
> 
> No functional change intended.
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit:

> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 2058db9c01d5..d10b8042adb5 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -10,6 +10,7 @@
>  #include <linux/mman.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/page_idle.h>
> +#include <linux/pagemap.h>
>  #include <linux/pagewalk.h>
>  #include <linux/sched/mm.h>
>  
> @@ -623,8 +624,8 @@ static void damos_va_migrate_dests_add(struct folio *folio,
>  	}
>  
>  	order = folio_order(folio);
> -	ilx = vma->vm_pgoff >> order;
> -	ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
> +	ilx = vma_start_pgoff(vma) >> order;
> +	ilx += linear_page_delta(vma, addr) >> order;

Could these be combined to linear_page_index(vma, addr) >> order?

>  
>  	for (i = 0; i < dests->nr_dests; i++)
>  		weight_total += dests->weight_arr[i];

> diff --git a/mm/filemap.c b/mm/filemap.c
> index b39111abdc4b..1dbb4c6f824e 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3411,8 +3411,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		 * of memory.
>  		 */
>  		struct vm_area_struct *vma = vmf->vma;
> -		unsigned long start = vma->vm_pgoff;
> -		unsigned long end = start + vma_pages(vma);
> +		const unsigned long start = vma_start_pgoff(vma);
> +		const unsigned long end = vma_end_pgoff(vma);
>  		unsigned long ra_end;
>  
>  		ra->order = exec_folio_order();
> @@ -3930,7 +3930,8 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		goto out;
>  	}
>  
> -	addr = vma->vm_start + ((start_pgoff - vma->vm_pgoff) << PAGE_SHIFT);
> +	addr = vma->vm_start +
> +		((start_pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);

This could be linear_page_index(vma, start_pgoff) <<

>  	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
>  	if (!vmf->pte) {
>  		folio_unlock(folio);

> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2049,8 +2049,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
>  		pol = get_task_policy(current);
>  	if (pol->mode == MPOL_INTERLEAVE ||
>  	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
> -		*ilx += vma->vm_pgoff >> order;
> -		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
> +		*ilx += vma_start_pgoff(vma) >> order;
> +		*ilx += linear_page_delta(vma, addr) >> order;

Also?

>  	}
>  	return pol;
>  }

> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -975,7 +975,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
>  		/* read the contents of a file into the copy */
>  		loff_t fpos;
>  
> -		fpos = vma->vm_pgoff;
> +		fpos = vma_start_pgoff(vma);
>  		fpos <<= PAGE_SHIFT;
>  
>  		ret = kernel_read(vma->vm_file, base, len, &fpos);
> @@ -1378,7 +1378,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	delete_nommu_region(vma->vm_region);
>  	if (new_below) {
>  		vma->vm_region->vm_start = vma->vm_start = addr;
> -		vma->vm_region->vm_pgoff = vma->vm_pgoff += npages;

yuck, good to remove that ugly construct
it's not the only occurence in this function
oh well

> +		vma->vm_pgoff += npages;
> +		vma->vm_region->vm_pgoff = vma_start_pgoff(vma);
>  	} else {
>  		vma->vm_region->vm_end = vma->vm_end = addr;
>  		vma->vm_region->vm_top = addr;

