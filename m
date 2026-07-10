Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA3FDC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7E36B00C1; Fri, 10 Jul 2026 16:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0206B00C4; Fri, 10 Jul 2026 16:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C720F6B00C5; Fri, 10 Jul 2026 16:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9260D6B00C1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:30:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CD89120574
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:30:19 +0000 (UTC)
X-FDA: 84974009358.13.6A7B7B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 51DD316000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:30:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HJU/LxQF";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5I9XJhmOOi1LkWbRSVKnYIkRF+jGCGnmzoiak9EY5o=;
	b=rNWjtL6+wgAMN88RSBrTptwkREykynqYfIjjidj9+912wMobooI96DXNFB5RLgg047Z4j0
	g8t4tGzE7XzAlwdlRyPXbZ9SJtGaCfioAPHutmZ4Pl0d8JnVtkHsnjCwF4pSvfYzGxMBa0
	EPMJFgJxKWVFgTwSjGCq+kcuKE7UX+M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HJU/LxQF";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715417;
	b=keN0YRzG8Jmbsjx9ZO3fjC//Va5ONyKRxuKqolb/0QyviJsGTP2ZzPZa+jYyiF87sRJL56
	guu7tTZVknUIhBw7jAm5Lai5h/yERZcd+Lc4qG01NsaYMCfWQRMd/MtviLWdZZCG5E60kv
	tAMO+PwkcB3TYwwSEUC3DGFz9mrrYKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D59216111A;
	Fri, 10 Jul 2026 20:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5081F000E9;
	Fri, 10 Jul 2026 20:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715416;
	bh=B5I9XJhmOOi1LkWbRSVKnYIkRF+jGCGnmzoiak9EY5o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HJU/LxQFVzsJlRTCMRzOJHdKDqTBAxtBcBwpt63liPwwYag6kcqfVKglYfllNuHwG
	 zruaDbLFSHOKgoo0BqDuxifQenxMZ32LDVjzeICMBYJ3UJv5j+AnJcMgzxnGHtBdeN
	 j8C36crjgwo2R/uzmYN1HthGyrQ3fCMsmbG+73WdXAXoxUFqceMyzp9ZW1PdmaRa9O
	 G5/VT52++Jk599/Cwob6URDW22K7/Nduaq0RP+KDtJ0pkxdcPa3d89vPvW4V4rHBk/
	 CW0bBjmWxC4r28Ips94X2CU8upp1gMEWiWKnHmBXHuAIxpE3/rXj+RtTqbCeQkATao
	 rwCQBxnl2483Q==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:14 +0100
Subject: [PATCH v2 33/33] tools/testing/vma: output compared expression on
 ASSERT_[EQ, NE]()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-33-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
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
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
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
 Robin Murphy <robin.murphy@arm.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Ian Abbott <abbotti@mev.co.uk>, 
 H Hartley Sweeten <hsweeten@visionengravers.com>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, 
 Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
 iommu@lists.linux.dev, kasan-dev@googlegroups.com, 
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2588; i=ljs@kernel.org;
 h=from:subject:message-id; bh=G0Z54AjtjNI6CjvRN0QWBiGJMevNN1T++vP+QCfqk78=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg+027xOdH8B2QFVjitv8mSdNCqatzzDPuLx5q/P3m
 bsqvNas6ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBESt8y/M8V4Tz0xp5xXe19
 wcer453cVuotTvQq2Z9Z+MFqXm4M42uG/5UJ81+tnzZdSGb1KWONWwnKD/+4b41bGtXx//vvOW9
 DqtkB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: yfzbzfu1rntrbq9re9apmor3zgayppci
X-Rspamd-Queue-Id: 51DD316000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783715417-482245
X-HE-Meta: U2FsdGVkX19uK7jFXplIOlhcrPIH383UN98ybZzcwA3xUT3g80ycaJfCCf2SFyHaMZ/2KYDDeWDEAYPA5LEzaH1CgTsiFTKtAL7hOLchZujsJQ0TI+TjP5C8cpwdDHBGdUiGZSBBk9EHZ3/8cTzMTyyrC9nYRbn9ZuGqRrJXbeV6H6XR21/TegDL7L0MzB3INUmUMy0b2TPn8pep4/Zf2PNYadeObivj/6BpFQi1W9rhb6Su5Z+YB/iaHURtAy9hGgQnn4mL/OuNdP9Xdll663j/OgpKkNTTz965xQWqyfmkX9sdD4Dedo8vlizdiEEfrGbtoKn1MW2EhsiUkHmAdtOOH/xyVHE4G3c6420G3k3k5Ois1fjwPFTWN4/uVEXGpQrQd7oiQfEFyQTuadkoDd+0uf7UR6avjecqJbcVOy7rr3n67cMx8awBalorRPqMl6u3Ff+lIQpHcckn8lW0lz5I0qkLpWlcC/cLiXmWx+BB0nRLLzABW+YwbzzqFiT6tVy+hb1iG7+MSudnXVRZBPmwnRO+dH2YWs2sb6G8YJZm/LLH3N5151H5vNeLn8IOdfdSEzoo3XYJoIE6hnWi1H0OpKvXpgWeJiTvPgn2zeYkqhXyL0kZ9MhRnxDPut2fZXJrFkG5uWbclqOGJ0FBtSBQ+EH9VL9admpwAReNL1Wua+JSykJq6aYWlu1giuxukXtKTnorxP4s8GHi1M0yzJ/WVZE0XNRFKN5dh8zk4LeFKA8i+Wwe9djNDjNaUc0Yk6v2uJcZLAIOMt+0sKyJ6lpaX8NdO/PuQhIqkG2tNsWrg5d8xekCJZob4p4QEfq3euWjTf7/p5KLzknHC5U99cf9LwRT0S8rfM1TYCs6/2ty7QwOMHHXSBxJK4ZxT05X5l6cgpJgVw3STEjcgG2p38hja1X4RwWUb/DGQ86SPVI7L0OTRSXvEyzKNqh0ihi4Cytew/9PaDp0KXX0jYX
 fAwxoWFT
 /6QWhPlZQQzijXET1OrFALMUmpNewKjlGQQwoN2FrWyZIcRAr3XMr8AJtNOo8L1NojoSCrjuFNTLrgkbCYz/qvKXoD3HpPHKO/YeB8Fl38gEZ/sqzIJ29fUda0o91Bc7+RsP+U5sF+KELFQYxqUZDsz7U0aiKpJ0JHyTiR+M8vjY75hQ7JuMz42pfgpImuUkwMTGzPgT/rwiqw0+7GtLOeHoc9ePI1FsV/XFnbrLM62IBPNUmDHqnVbaXIYx19hSO1i+5iD96iah8zTs5n7/WREwmLs5G6ILTlmkgos/c0SkAkauk3tD1IinhJ4Qcld3YsVmW8fAJ4QaFbtjwZKKRDW5rOhEJY1UBySWNoCV8QBWCuM2pi1vjgOz8H/Z1lmcjm7jAY5RaeEMTiR/Mo0S/5BBTObGxgB8o+5qd5HNYYabrNcVaWMbeoeVyXIKa9RzBWbENE75/N6nBxovmVsVyvPvhKhIWit4P2zsRtTnChaSMqvSZ8/qp1FIlFwUnU46geS76KbI0fz2ili2bEOXLDXi8QsSybOYeLsjdD3S/RgE15i5SmynBpkxmAtU9l0JUvKzo26ls+dDKXwKeXpCZp8Hfdtcitjar1HHVqIedbfA5FtZG+FRi0af7uFJg/TJ6asLgQS0rFUtYqCIXtuBDAK3SZoQHQYykMT+FQmU/2VWFVmZHjSTSESkxx+Ehyg8KAiGP9Ehka7UHylehrmd1X+E/zTTvjPl5EU6BlEiONhJJLW+T6b5z5oqH0GqkoZFKL8cgpS/aKzIZ0vFWtxbtPJHKWE4Ykq75NIJvt8ut0kcK7QC0RU4Gz8ljRbkguOUwNk4hkvSx0oKEFe8GoqflzgKLAuEyQlD4a/YC6570UzfcMk/qT0BtoYg7rm7Ep9+9N+DyDCER1gw32NLHvcI2fhS/Ui+jZscA+6rbqR5md+ueCBS+25REvw6URIxupXWA6UDAcknECyZZEPY+ykm5JgaV82hf
 OXuJtRw3
 dnBBG9NijyIz3zD+kf4vWnIPK/V1vVQiXfTVh4nfiI0z2P9ON8HnOpBoM17M9xRK75SBAdl+ra4De2krXqCEwdiSUD3/qFQVy1PtO6OR+k5H1iIn185sgH2i1AQhEh30W+liMeMJ2cTD9Mbuhql7pfQ3j1GseyxdFm9hcLWs9RnstJpUWPa19MfrychSfYE6ul7IUt9PLrryKkm+X3ZocOHyJNa3tQQsU1F7f5WV2KrpQGEdAv9SNmAhAx3+vwB5xzja0yIIyTaiea8tyJ7/WDLteE0s7XLtRR/79aFvS/WotAOlyivgT38D9e/JiENlthHVGH7gEiqoF8s5+hqAPPQbWyrjOIXMx3l27n2A6+5EbX475enEYNQhFRbe0oxx2bDhn1nW/nRnfUjvN/krRxskIoy9RXGTGrB/1mG0l1Qmx538ky9sBARDE5Zv2sk0iPi/fmc9fEANceCMgUGEFbxkB7/1XSjoje+MBsa5BaW67PxYqtS88lSBtluK3O7Hu7VNJGoLu+hJhPgo5S5REi0Me1iXMQQZU1KF7hDJPQw4G77nzKraACJLi5bctf35mhnokRt8qDNoFDk4HJNbA7eCCyu162Qf9WKc1FbSaZL9QPEofFSYc0aMPC+wpIkMAN550+z97sxuqbOJxUIaq0mruqP4GGh3EsExPY0zi1nm+HhCHauzUFbwJ7BANEFgXAWbuESqYWlmsAZF2/bghXMotd8mO3LEWF7S9SmEXMENyRL9Z1hM3z84woPCdlkxH9EP1kOKWgy3O+F5NECAIshWz4Uq129V4905kWo/ofx01qMOX46nW4ZQwnQ6b+E8Wv/d2jo+Bt/l9oH/hLBOsnvGgK3KwmK86ShqqpRIl3/SnIWgX3AWk1gnNRLhMaOcMzEXY2qTQv6xndFDqP/ddh7PCfS8zPYAP+aS/GpNekaU4SYcBwef5iMhLW8dgf4PDaXOqRodmKpaq6WhcP5xlrlKIgq8Y
 GTZzgacR
 bzNs6ZwjBB3p4d5sF6D/F1iM2nLefMPnux9EQj+dmADBPE2ea2ETfvYVYxqxWBGsQXPS/Xt8IIYh1VvjwKaFRe7Gt/WoSWJ05234MYBKjPwZruSCm0PjPdbwMC+93LP8xTu5TmZs2SZODux+yKuuRNI8RmpPe7i4GZg5iKj2h6EefrzQ/WMoKu7NflphxGHCuFAANzgvvEe/PF5Xna9zBKYuARvy4Ee4FivLdtZf1yD7JdQoPGZklDnMpJQG7seVqywlJqEuvHkFyKAeAk2CIjfUBL61Z7OsAXESYaFgHN/jlahXf6mu8nklTj5GR/qwCQg++3es5UWn7qb1t14Sih1Mb4+7kEJ+Kb9/w+mEbTFvSb+MT3AezFAo8bJdZFlSowawdIFmQ2KSsZCau4fkm/wOSkN54ooCR+RRdWtZg03nUFtjxaHfSSv3K0G9dfYI6Akabvz10Wrnj2toiGP8Y76k5CKb392IAP1HzTxwJA1ZguaIaDRUzL0h6ZvL/H032mtCbJgAZs9yqJoeJBMBxmrEpwXHVd+vU8hDtixjoabox0b9BgSHb3ZmJVJowkc7Z5jNlrekiT1O+0s7rE9F55fHCghwgOkb+cRy1aK/mW9o887lh03Hs5UxFHj26OdcxdRUbuPvb8tzSlr7CdtxzPNFDykq2kuNpJr8R8gGQ/+aOz7bgNWOiF8FCCGKls2vd9WP05TptXIYuy8SyiBRfJJLjnYQx552Ct9nIpwWRcxh8cfWNcvrp+SmUyyFrSXS9kPimFsFGGOTMtXNLxG2cf36MvmieWgHZWn0jHpoB2Wm4IrAShAQMypMC3ipDW+dklb9ZMSTs0XAm9Y9leFmVHGgHq4izuITizM7AKBYJg6Us/YBbsXJ55+t76i+YHWX7ssdKlimjNghQbfKKaBA4tJfI/Fp49MsJ+/3b8iv601TBofZ5KObdM6DX97lRAF5TTno29U1FUcKmBRPfdF0wck51fxEu
 1/tdfpnS
 dPWB+3dK9d0RvKdNC9fByNy5PLrl+fxJYo9RGlTN1olVCZAWAk19TPzlC13OMPEcGMaBQ66fgCHJAfTpxFASVGndEa28DuEnFlQzb+ymqCJ/hmJCxpTaK/mSKgKJVGpb4mjJeUdFVqXDtRQJ3wGaihTz/4BfQw2P1tN2DFfqmkNvuB2DbMMx8pB6YFw8P0y2ryNRyblEU7SULENl/Z6ikD6uXYq3vbEwLEPiXuXkJ0rZwGiYAcxbzSOs7CwyNBXQ7hC+1w3LuQRkFhfNC6VT3ZWjGJzjVCutywDq722r+Thgxqu4OyAMwS3yo0MQjSxoH5sVL4V77nrEyrBpe9jdPAprxyzdQa4UEktxcV/StMdrhQFizJbPN10G/lEArfJHY1vqbI94zoIY2xQdB5TiFGKUP/QQTjLcfcQsK/nnpBa8cxv5kpxEssTUdMFKC+IDqV4EmELbCIf7VPNrSGoSOtHEL3dBeFNZjtJXq/DCS7B0paEztWH92F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the macros to output the compared values at hex for easier debugging
when test asserts fail.

We have to be careful not to re-evaluate expressions as they may have
side-effects. So update the code to take local copies and use these for
both the test and the debug output.

Also remove unused IS_SET() macro.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 tools/testing/vma/shared.h | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
index ca4f1238f1c7..97cd7a679dc1 100644
--- a/tools/testing/vma/shared.h
+++ b/tools/testing/vma/shared.h
@@ -21,19 +21,35 @@
 		}							\
 	} while (0)
 
-#define ASSERT_TRUE(_expr)						\
-	do {								\
-		if (!(_expr)) {						\
-			fprintf(stderr,					\
-				"Assert FAILED at %s:%d:%s(): %s is FALSE.\n", \
-				__FILE__, __LINE__, __FUNCTION__, #_expr); \
-			return false;					\
-		}							\
+#define __ASSERT_TRUE(_expr, _fmt, ...)					   \
+	do {								   \
+		if (!(_expr)) {						   \
+			fprintf(stderr,					   \
+				"Assert FAILED at %s:%d:%s(): %s is FALSE" \
+				_fmt ".\n",				   \
+				__FILE__, __LINE__, __FUNCTION__, #_expr   \
+				__VA_OPT__(,) __VA_ARGS__);		   \
+			return false;					   \
+		}							   \
 	} while (0)
 
+#define __TO_SCALAR(x)	((unsigned long long)(uintptr_t)(x))
+
+#define ASSERT_TRUE(_expr) __ASSERT_TRUE(_expr, "")
 #define ASSERT_FALSE(_expr) ASSERT_TRUE(!(_expr))
-#define ASSERT_EQ(_val1, _val2) ASSERT_TRUE((_val1) == (_val2))
-#define ASSERT_NE(_val1, _val2) ASSERT_TRUE((_val1) != (_val2))
+#define ASSERT_EQ(_val1, _val2) do {				 \
+	__typeof__(_val1) __val1 = (_val1);			 \
+	__typeof__(_val2) __val2 = (_val2);			 \
+	__ASSERT_TRUE(__val1 == __val2, " (0x%llx != 0x%llx)",	 \
+		      __TO_SCALAR(__val1), __TO_SCALAR(__val2)); \
+	} while (0)
+
+#define ASSERT_NE(_val1, _val2) do {				 \
+	__typeof__(_val1) __val1 = (_val1);			 \
+	__typeof__(_val2) __val2 = (_val2);			 \
+	__ASSERT_TRUE(__val1 != __val2, " (0x%llx == 0x%llx)",	 \
+		      __TO_SCALAR(__val1), __TO_SCALAR(__val2)); \
+	} while (0)
 
 #define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) \
 	ASSERT_TRUE(vma_flags_same_mask((_flags), (_flags_other)))
@@ -53,8 +69,6 @@
 #define ASSERT_FLAGS_NONEMPTY(_flags) \
 	ASSERT_FALSE(vma_flags_empty(_flags))
 
-#define IS_SET(_val, _flags) ((_val & _flags) == _flags)
-
 extern bool fail_prealloc;
 
 /* Override vma_iter_prealloc() so we can choose to fail it. */

-- 
2.55.0


