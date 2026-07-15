Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8862AC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68AFB6B0092; Wed, 15 Jul 2026 12:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63BBC6B0099; Wed, 15 Jul 2026 12:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC236B009B; Wed, 15 Jul 2026 12:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12F426B0092
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:45:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 797EE120259
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:45:20 +0000 (UTC)
X-FDA: 84991586400.11.C177016
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B33712000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:45:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fF51j381;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784133918;
	b=8Z1QXkLF12LUHCtxyskG3CPqp3NMFPkBvCru1YOFMhfuJMxgJwbt/jEuOxgzW38wrXOZXN
	3Iemebyfw7AE+lhlYMRnAU6YKTobQrquY7rQTR3m1RJz/9Gg6V/9PX0DW9z4sWpUy39jx6
	OswEblBO2PfAtU7IjlnADmJnxpWDwQg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fF51j381;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784133918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RV6t17XzcXK7hDius+P4ap3Hxy2iOJYEZB5njvjZ5fs=;
	b=zIZLNJz7tZAHi20H9DsBP2Vdf1LtQVsEmdNJTce6+3V1UDfkWzu2saJy8qYva/vmNhbcos
	wN7wZRkD0BlUBcms/zRaOVNFQfHuAOk4aUjP3XvLTdz0COqZu+XKbksP8X0QIfN2TjDHft
	xy7XQV/ttvTs9u8oekMoQxIG8QqUyuA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDED161836;
	Wed, 15 Jul 2026 16:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23D91F000E9;
	Wed, 15 Jul 2026 16:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784133917;
	bh=RV6t17XzcXK7hDius+P4ap3Hxy2iOJYEZB5njvjZ5fs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fF51j3812qhu7tXk8sO7p0qRFeZnT0zcm+NTY+3Ll6Ses01BSCXc2/m183XQU73O0
	 gWNlFD6kXTJCsr1gt+EXL5TZow7GMfu0uw6vX5wVNSbBnS0aHCNkALtfD+CAKAVpP9
	 7QKeRkV5f63I3azlBivhFbZliFsBiX0dQUZoxwiyHwnyRi+MhaAnFote5zPICBo03y
	 JnKokaCoLx8QGcPcy8xAObNy0I08PMEl0Zb7lYpiUZFwDJj5zi0xigkOH8W5foTbcM
	 3xQ/NFTiylIGvv0yuMkDKSp5tMU3PvVtkGS8nNdhJ30p0ilbfdPs43/NbvFb9WUOQm
	 UNK0weh72BD2A==
Message-ID: <c455808b-0891-45c6-a716-41b19ca103d9@kernel.org>
Date: Wed, 15 Jul 2026 18:44:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/33] mm: prefer vma_[start,end]_pgoff() to
 vma->vm_pgoff in kernel/
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
 <20260710-b4-pre-scalable-cow-v2-19-2a5aa403d977@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-19-2a5aa403d977@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B33712000B
X-Stat-Signature: aoqxoao8nkcokz79ntpj4mq8nd4f1h9z
X-HE-Tag: 1784133918-840724
X-HE-Meta: U2FsdGVkX1+5lfdTkUK7YSIGBq4en+0X7ln5d+Tg2Io3HhfK1Tgkc5uQWHgRWlZXpsCYI0gLKykrohtpDElf0H+CNVxmxLexPkTEHIIhYCwwi52p+bXarhbaR5Qh0vW/yBP8mSptYCACHd/MZZsdwL/sCf/+r2Qzzt44vOLmhRSJTjN3aIkgOmk22MMbm6n/hOsXnSWxqUx9G1ml7J5tuEioa3/YPxtBzlyeeGl24fM1cMXWNNDRuA6X27H7UwhB5dmwFFVv4RJgvkQsJlQuZXhdhZR3RUOzZX2F+ekxs3A9d2j714tnTiPhNfCCag8ggzxB+UcpJzDQuqelSmL37VT/YQR4NbSKhg7rJeVLjJp4dJ0b4JrnzoNkBCzPbHG2cHdGhU6VeobZJ6buMuDjc7gTUFQg+vYurhAtUAVwCrHmCyTJVs0iMfBjBjoa+SIW6rZ8px/evpVxq+7JSxKhp9MTGM64pAJVbcn66PN39+QS/z6Eg/1Qjr6c7ZKNXbO4d7VZ+JVIPTomgXobTx1l7Mzp2fay0DKmE8WbhFj3jQCgEX11UzY3bnfoJhGCB+2tAm563mh4m79jeP3rFTEaQbpUX//pcDhCW+iWMsoR2mLwG6iFHmLeIb5G8zRt2vg06ycAG/Dua+ZDdEuxfffUaQWA1CLpeZxpAp4aiCifii2ngAcS0cczRBt3T0WgVoOEy8UyINi+2cU2mMWXhqweZXgryfhJRW/OC87AlAT/rIIc7LgqcAFP5sEvn76a46YvbG5y9uEL3+YZEqmjp+rJ2oTmrxLeoHkuTCdWkv62ND3AxhAGMoRG86L/HzsHSPpN2uy3cbhve5rWW2Lxi+luAZOQVflFvTU4c8ZR/AhfRXut2P2zbX//elaNSzn0J0jV9migDxWHvVSB/fGrXQn98HFaQupaV4vg8IZzQFsjayoGSWSuQGMhL0zRNpkr5BYoreb8pubcSFoc88oPMlR
 TQK0ieO1
 vQD8E7qZFlMnjp3p3M/xFxCakbdg9VVOiImoStndAIrehwBXkuPLDkg4aiWwGS3cRipZky7LRT50wB71d2JQd7RRHrsf2bs26YbxOV7mDaDzRb2KCSJyv1up+8MT9crhodZjv8XwmhChFnLXKKBTbpfdKRZpxp/WSfVV87QJ3Vq5zH01B5mehM2BS6u0XeQUgkwyA1POj4J0mRzyfgtSAj0FtiRz3PUXYGP7laIFYzwTM51+rfuCaxEmBe9EHpHWwHVfhdmsrKWFURkWpKWV1wfvOgjU6Mr3HPcpYJ1ztUOnXHwImynP1jStcuYVqfdc7HJWePvftxxG5oXv84HEy1UkRTArthih4ezyk1YuiSBk1u3VPPm8H/fp219qUuKL6zj0RE4AAbA2ICXBkrJzAKkcOe6u5aMIe4WO8X6PRhEvmrjygiABbbRyPanWB07x6ILW53nMsSPWIUhiyOdWE2L9VnyE2L8HJvZHczA654kiqInlGAEEfH2RcRnXimvgmrSOd4vr/hxX4ePxFdfuF3/U4pEH7kv3QYbb8ZUxwDvLWZ5xpGunhYqZ8hz4+DpzXCaRNpC+J0UOWrm5SHdDiAbjRwm0BfDMpUrYSzra7fT2ldDe51yxbfr/vQmSYFlliOM4SM0avbWslYDytAYNP9cDfrBPEI961iGQrjtDpxGV+5sMXH5Kl2Wfo61jk24DkyfK+yw+mE6+QKt01EAyFNc687WBTbR2qQo06KvHlujLk0R6GqClQJW7Ats39uJE9mWFNkyijY5SOnmgZSoeQLj52CYTtnpxsed33DLW0WfD+K2ZVlaLtE3JSZiVNa/1jYHhRRi3o3UVEznF96lYmVMtmMWQbOEBHV2b5n+B1iX//oh1THB302ZJglgGj56M9XlhCYQSD4xLnwsrxlOrnuJ4XwLCKmzIMeUmQTKgdLpMVdv5AMeFY3cBmUaZwAf1Y2H/yLdCCyUMkasVL9gCQOPWjBVOy
 gvGG0gWk
 jx3zSh7tQ8g1XXTaWyB17sxDQdtsp7zt/qYRlTvbiGqJu358AKV57/NIPwxoDfwn1JuZYZqr1qyzThXunvb1pqiyUwgCEclrc9ACE2NXms0YODVWdlR+HP6AbQG8i4HikiD9zDlR8UoedsPJ2CYsLRAD2JQKq1giNz3GM0/YUqjG6iKkuHJjeJdtroofaY7ocJP3WZyhK9sc1Yq5BnahlIl0r23EVVoCSNGcM9wY0vVIS2HXAobDAB1BKj8mPNcDvmMcp0TtwdhtrqPcQuE5xt7kpNW6smCcF5P30NBK0haTAHh6OQeWt73PZbpG3LJSu1/K6NUSY3uJ3qb1yR7z/iXRCZ5t2deM1VfO/e+79jZUbgR2s91vM2X43qYlk56sBt0PO0ZnzygYbqMwqdxi3oaV0gx9aLzpo2SuW5ObBaxnT/O+pWI2Lbei6LCxuZ44zFQwFoN9mzLUzBq8bVGKPeayTNNHG18ni023chJQ5K3y3ami1HVD7nont27+sBt4Ots4Kujdqwpc3eqxrOxeuKAryIwyrRuEiRKczpKTgbc7Lv8gqe+x36dMJtTWRohTRhAiALjr5RY0hsU9XBapqKk74QZ7323/ce5tPGGwmrD1XvO13XNCC1x7G7WtyzejG2nQDZY6Yv9FlIhOT1LJdo7AW0eXFmNpfDu6/lTu6dd/qu6gvGix54H9hvh/Jg+2MfjFNqEkZYuopaf1u/1ezaRPLyRxF+mLRyRYbPk5MuTq2Uqu94O6u5gNa8Mii++6M7p9qbnWZzV0GHsDQamSj7xYqc4MgidlLVoeNalzS6XbqgT+gSso00rvlBojfqFDVCzGGx8NNHiiLmvJSfLDQlqcBB23xwiCQYqxF/ewI7kxHTK+dpRJgrADkks7fQevKaIMrqXSaFFeqfKupom47mCYgAZQ3v9FJmn5VWjqBdAXn7L2Y8Q9cR4Lf5UGJopstgqzOhFRvicHMRqvoGqTSjaTgqA+F
 5TbdoPx3
 VUM1KTiT37CoWadh0cZvSXfAVk0jzSjBW+WWYxPhYQlmfNM1lquuDdrT+z+o1Nd0b5Uum5IMvejXr7/ynFjQtOZGZseCyanwEDguoe55IShO6QfVtwteKjoANxsiW73yMyvM+RMJpBIn6ZlZnfhdYdT6hY0m7zI0PgTiW1hmRC0dWFZJJPMtPiETk6PH+216LlNl9RmWhKQfRhjJ1xGHf0y9erBla5s/qtcg9OilBgGNlXrwobpMelKgnoVDOcUW2mZQDkBsjGjRTLkWfzMf27ZL5f11p8gGfJe+B94mPHjaW5Y/Jnax+dY+kg44nRXCiro9L/glKG105ZmWDr5YwcBWa2XR9T1vH/jf7gCYOzF4hBJVOkfnkvZl7FjxIhz1qgd9jkYCPOayXsfHALmp6uO1PhzqlpOq7WW6LwzxrFUp+ZMwm7ovNgoFRLDa2BKgDwvMZlB3I4RrwXafHewi1Se6h3KRxN6AlYVtki87saxD9fsQcvvlCONHvSsUXpAR2z2v74qpSiDR9euyfU4jREJHLigpv+BdMzpmqiYFD18R5guTn0xqS2saFZftPz3F6kiMW3MXFYGbNSQAZH9Q9gGabDxamg93DhBYyFZ6jjakFshQvs+NqWXYSaCdP1c+59JIGMwWD02k/aBwgCVSySVZ7bHRVcJzZN96R4KntO3fEJGe8h3VwGcpFt+GWqV0Zu2HCz2NAywSHxJGoiaWT/xL67YiMXW02HOPSO6zzTdgmsky36yifzezxZPlU3Qi0wtpTDgoGKvqs38y+zcfwgveTREAPa/yWDOqi691xA13MTlu/GCF09KHGwp74y2j62GwnGNQpVBiP9KMuMN3aIAk5WvbVDGfBsUFYmjMbZMHrVjdICg5rYLQsQsLvYFFltU8NCImxXZwy99T+vgAyywqOPihhBtduiws0vsUiHeQ5oXObSfFuUIw3HuOP82dvqiDRenSP7LlvPSYvx3mzK3XoQDe3
 jKU3CVXa
 aAuGSQPNUPpGVU/jjH4aUXjOMsw60Gb7WgC+rsyXBW9mTL505EJI/PCwHW0xHogkSzGCQ76JbaRZsqat2BiQ2Dm560UbkDXYXGEF9h1AxvgueAjk/Q0PXnGeGDnxY/1mReNkBDH8TzxLPuFCt4OREo5dlkubAaZ9fjY1ymCHxsqT4FBs9OVmq9pcC+RWm6HlFUH0BSy1d6BUUbAqKHRZ0GXVQlGvR2qfHhi116NzPxnoCmv7LYhmYPDUknbWepBSxliWx4PrmVW/jZFODBbUFpn87+qGVq/1ZbjKnbjqSf1YMQZmhFI8G8uWjHf202698b38kMbn+No8A+PWI5ifUZWaW0/MpNHzNGDVoybWGDZdPVl8L4QPBPZeMYTXZLTe0awXuF2ONNqWcxdHyQUqhXwyhD2jWl6dmiBziOpymnnVNGrr+9bCpKj3GzkMQYaLH6OkMgxg0Ph0uvv3H65Key2DJenoeSZW786D06LFIArNl8U2MujDijayoVB6iqkS6+tPtPkdX8iHn7FbM5C/crwFsNP1tw2SbTt13FTsKik5YUqDHw2l4XhWEmV1+0astXj75LmgIK9rxWdsyEgn6pfSeDGhakjJYUnRbcJGtkOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 22:17, Lorenzo Stoakes wrote:
> Be consistent in using vma_start_pgoff() and vma_end_pgoff(), which clearly
> indicates which part of the VMA the page offset refers to and aids
> greppability.
> 
> This is part of a broader series laying the ground to provide a virtual
> page offset for MAP_PRIVATE-file backed anon folios.
> 
> No functional change intended.
> 
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com> # for kernel/dma
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


