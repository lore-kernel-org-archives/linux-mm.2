Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE88AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61FBB6B00AB; Fri, 10 Jul 2026 16:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0D06B00AD; Fri, 10 Jul 2026 16:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C066B00AE; Fri, 10 Jul 2026 16:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2448C6B00AB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:22:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2A951C3BA1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:22:58 +0000 (UTC)
X-FDA: 84973990836.04.7C5F59B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8891160002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:22:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BygF57wD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g95Hx/jZszTYl/mqKEmmLN3wpFLfcUCiQ7oLxyYPtwI=;
	b=0ftC7rkHtH7H3ZrKXEPznUNH+AOijsH1g3X4YJVS7pQcnmZB+Xfcw1ibKHFuH6NmgsOLmC
	hiFBTeHszk8hbAuVdWJZSTgtAPAX3bfVg7O8Hzn93p4E9r69ZLqyTHFD5EJ3AKUiHYiov9
	642IobDUSCf83quLEWf7d4goQXgLIgg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BygF57wD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714977;
	b=CxanzRVjc8ujFr6PmqLsUxEWG5LOBv3oVkKbw0yu9pO+4g5HAFygneTOzHjNGBiePZBwrj
	xNRXhtPdn0sn7zSVQxsQ2wR7HJGN1+voPSiEKHOfDuV7GHIDwld14JshSXsBEDjgEWitI+
	vl9uY1pxz5ZnMdOr75Of6ej480+GtGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25B2941B2C;
	Fri, 10 Jul 2026 20:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C69F1F000E9;
	Fri, 10 Jul 2026 20:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714976;
	bh=g95Hx/jZszTYl/mqKEmmLN3wpFLfcUCiQ7oLxyYPtwI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BygF57wD+F4oIx2IjGBmXSgdeyH+kDz20QKqfZkY+JeciaIqrpYGeXs92Dhu1bJQg
	 yDrXtWAFvHrGJ01GVLJpGEYigWux3ULkArB6G87U6BG+mND6GeRsCRQIqxn7ZB/Co7
	 WX5bQzX3DHLJV8P5v5PFCfG2UwKM4+ICy3syuuKgzN0aQLrIra+79BjIq5f/isekmS
	 4O/AIhZQ8j5j/Q1gq+aeN84CaAkEZVoCKAwBtKJrHGY5odfGQwzjga9mJoIKacknvz
	 VLOYvIoanmU23sKzVnBYRU2knQpn2FpJ7GQeLdVOWXN6EA1E/tTlccruzKODHlic/F
	 MkoQCxvPMfndg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:55 +0100
Subject: [PATCH v2 14/33] mm/vma: clean up anon_vma_compatible()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-14-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1642; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Ckq9F1B5R4ctEUJqWXYT1jV2i9Vim92hn6PkYJsjcDc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg20UN7HtLM/vyXsTFrxVYsWpHDm18w4P5+XM12s5+
 WWHrvf0jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenANzkqYwMU33rlv+/mL9e+HWT
 WHxes/ljhqb8yMyVr44wrbuqccd5DcNfmT/8Ns92pKWUmxwKXbLj7ZqLidpWFw45HF1j+zc0qX0
 fGwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8891160002
X-Stat-Signature: x6c5tgi8rms43cynwcz33gjj39qe5c6f
X-HE-Tag: 1783714976-560923
X-HE-Meta: U2FsdGVkX1+yrpdqrdCnz6yTDAW+KD3fWUOp+CSuxyFKyOA2FGg/SN4fZ55oqJyfEPGzm3BUM0wEstBII1tBPJTcmwFPuvYcSAarhO4rTrEa2GdP2p7iuEMOCPlIvG2ndZL9oQk39OVL4nge60CK77QOYX8SbMEE26pHHmJqk5i39LJ50NnQ3YCtfKiF9ZHF6Jbp5nG4r9yinoJZr236dpopXl+c1mgo4lMxkGKEWpQwt6KPhCebjkl6sEkxokDy02xACM+SIZTVPWJs/cKOwFKzPy8daQNsAZ05gg/SYMq0LnhtL0ydld5f7l3cqBz3mvKoDViym3gOZhx5GwWmi+FYqGyU7DnbXL10caMKvDoH3JP+kXKMEfg9LQOzrAImNIro/h+9gvnlYrdgVnjpTqcO/bFkETdHFBUDJ0zeXE4QeP1LEoWZYXHgCjRlXX/nTazDxmbn1CtvvOK8fCJOsD79c34cgXU0AMwujAZVTQCs3bhHt3B4J9o/SCbVkUe/eialKL/MR0ue6BYqWpkuw/U65BwUoV4u8cAyPn56URFqVwNIUW5FYFTBWh0UhuyLzfZT0VNaRCStnlwmPt/zW9auhxerPNvAsrZOy3X3+zG175c+76kGTsbOBvlrOAHImzYBWS2xri9LUnUvTsKAWa2MK6G+0nq4/v3oY90fizoKDH44jwYEbnYEM/iLH8jVjenM7ycYQ9J5Qz6E+3F563cYWbd/+pDDt3tqn4cefrKDYQhppizWs2LMpBo8/SQZpQofBaTN2syRHg9dDcsgjvbxqXWt+BEUrprSTuwgmZ6iItXkSa5YafZa6bc5lgrQEHH08jd0KoYAuozYx9KI01HN/KeimXozCNuV74d7WFYkZsG+Ur0jKJjKSpcz7ItUAqxsWb4oYVEnqRe5yv5iM6hY08iQP2ww/y8BuahaWhNBiXc4Yz4xFubRmjxPBPC2y3PNUXmEEw8ZvWUO4yf
 mKQSjb5D
 cHcNjiVULRcArtUSON49fsLik6cqadXUJRT+n8E3e+NauLSS2pey9m1XzzxqeOmswsu+Bhxt7YylDc/rEa7UOsehib+vldrhYadM/UGcf9tbkvD5c+ZooyqJE8k1y7pqJxxXOzv3EfQchHi3PCmDj9Rp864usyRA2vqEhVsFWHwGUsdm0Lnfq+ST25tGP2p/aXQTW2MPu2n3BIbOWXbVX2M6tuZKE67uiXWwWsVZAtAMH4R3rg4hwsotwXFK7vE3f8jpceRPF+ryRAXbnWLnGBVKnr3Lr5X1lUYEM2zFW8p0XvOWVP7epuuWHQ1UjovXQ0Me1avRSD2n5f+sZ32e4rNBPM7yir7htqSdK1vxM8hh9K0BgeXNUlcbm74b70MiTvmkS3fXqDDk5wMWyl7yXY7UlNr8XICIv/h5k16Pxumhzak4VqUnmDFhAVHpH1neuz9JC7uuS1YKCnnlGaCRb4fASCYB/IQJ99JWZRtHcgNZpPCVA+ra2sAF1+FHBcJk6wyPa09GsEBJn4iMQHACYvChhxBm//33xiJIDjLdkHqTDqNEVzYWOYrdXHHivsYOFXPn/6noeAHJTY4uCk8b4AJokT+cFA5NZL/9WslmacnIKvuz94qcmxzw6+MwXk0GviPth97LZIyPcyqMC2xgZWJsORRBCNcmSsgTvFG8PxjuWPhivwBanUIP5wO8L047tkko0Lct4XaWNcAibTWlwR2SUYQ4RpKJovzt0vl5hzwhos4Gu7FapteOH5+sd//SbWUfkd4uMPOzpRwXhK0TnQ2U68akwomwrQze/cNESJbFfXtQ+Vy3r3lsFO/L5UnJRuASKWZfUxt1b2pepkOmb9t2QdektScLJNXKj+VO9oU5QsHFzqs7YoiP6R3fUbaDvPEf701FdKbusyhBMkWzAqOQ4nyAFOhQXX/iioeDortcWe2pTxfh1GQ9fe20mR1Zc4K7vHjECnmDOkg/gUc+U0eLesEds
 TTVs+vr1
 ptQF0JfBcoPrxEXoOT3R2ei+i6BefJ0/x/xODR09crPt27K/C/GwJ6BDzcZWnF0HydDNHGk8/OCTpF59HYrrsoTnMkEDHom7UbYl2gkyZNKqraEx5HFngq0JPYcKxw5eV36i7TyBPhpumW6ZGG91pAtIQhry9WO5oOpQej1q8YnAIK3i/4OsrdpZJbZ5i5FeWc3RfXpvgYrLQyusf/XIQ2CTLLIZMEkf+V3cQdRCBxEs5izb0P+mUgHRA+UhqF5Jn0bgTEmSclyAlNLIklYkHGnMJzZROqu+PVgsHHUHuh07/9UFvnc97MBEZe0QgdmgMLyArLQxcXoQoA3+G+mqYrVXDd+vORDUXA2S92NR+BppiOP+jt/HU+YRVBqjswKWTqD7yfJIdpoC1IeiLJVG3lFgihUOgHGZzUG7rpF+ZX5h2wXW8+FRPPjpWpCjm7yeD6TbXlC99ZzPQqG8TF9WlaIf8sJLZQ8wP6EVQIvMzsq36vxvpYL5AV6AYEgwi9uumSBTvZ2GbpY/nOP/kFs3E98b85wDbkWaLro32/xMTmBhFjMkJSOkGU9EfF1JUGwaETX7W++Ge+DiVc1Vw3TjyadjOpROLcbTf/tnB2tH9KYf/McFIPYf7+ldTzdk/NDakvXHeNW534Mm76xH2/EAUfa1FZafKULnviyBgLPw+bA4f8Kh0toRpEheOohnKpVzraVTS4+a05mjDIeKE6G1cyqzYfBa2XzPYu1uXiaPb5lbRruzc3CYuUjrPTSWJU13pWP5X9vsf2t/GUYv7bSsxUVhK9t9gJgUAbiZM4xSrJhxpMt83ZTgdSzb2z2BR9Q1DBlU51kQCozmxf2Zv+yQS+/etK+scWGRgM+wRODdHaoCNGkdWayZcZtanRMY4Q4H7/824lrFJnd5A9y6igzXmKE5sBq72OmHa46Y432qmnzCak1W8IUCcYT4yMoIkngu1qHTh5U1Kql+eQjoinNhL91GybSFs
 6oLGA6bg
 HDEv5Fd/598OInd9IiV2n74HuMcXn7Dc3XAXwa1JC5hTuNXLYPBaMzMkc9PP5oJyu9fiAmcvfDCy9EX3Erifm/fDScESt1JtpxeXxSE1tl8tZZH26dPLnfKQJf73I3PiKkTUQneiqzjXGHcA2trxg+enxHn2tVxXC73pOdeDxhSkUYTZxOEzCX2Ki5MMnmK3QYIo9eHzjle8yvKfEC44b0T6VdKlKdT6hZzjK8UbH0DcS3g9Y/VRx4CQJZTfqVu9bBMXX5qotvClgSBbXF5zo9QNdsYykWXXChEeDiwEmgq0zf1H9ehu1WfqLUlV9U8EcXt2TR+kOC0J8mCGrnur9rz8NS5ljbPcgjva8JO9uXEKZ8fPWUX34Xss/NnzY9b9yDFdXAjM8ovlbybzpnCSYJJt2whxvrPaBZYhLcZYv/7AgH1uSvzpIIyvWXaLZ7tdK+YfkNeZKmkB6ltvBsF2ILrQSLhiD5kKS7yJLgETmELonYqpAQJlVt8CHTS2acJtJuvWy7FoaodWVPxABsNCn+cOs9oA7Y89nYg1NeLrg54/FbKsgYwb/mgDruTQ6a6e0LtF6DirZC8a3VhEwLlSl04Hlhjvf3u3wLsVkYX9U77LY8s/VWCg3hn2UfuEFgZzaZat1yOTgUVUAep05KJaA6HbGxO2VTuEAoeASd1tenMK0+G47Tc8y3v6vr3Uch9UIRIkuelg8uPF5jvkhbBQW3ETkb9LWTGHQVKNFrlACdN/v25EXMjHz1PdjRi858F2L4/9oLiUyxzS1qPjz8/PNmWkGYiJ9519Xlczq8aZJU7emgjB4BTPUX3yvT0e8OowGQAddQFTwrefkPW+PzYsebxDvTPyFTUTh/sxBzwX3EqWe7cCKeEo8JGfLat6DZFTt2Zoig7sodEAO4jH0AaHgd0mYO+f45aLbflnooyvJs+rHDAnUimF0q0iy/+5ATyEAaPvRasCHg0sYlowSLP0jI68D4DIz
 o523Av2g
 3yMGAL5o2NyZEVSzRVM3uzbkjs1/be/vEdOzV1e5b8EJkqn+zBNS9TEBP0zl3fRKhf7vqnm3djXuL/UDmnVE1WBSDpMZw3BLJusC+5p+PLpRQNPg8vNM+m932nTPPOL5FhYCyElVMHSubEFz/vtY30HzQq+nH6GddrdhZj2maftL2iabaPEB1dwhQ098bGRGRVjnLudnIcn1DxJKOqa1bkYT/PK/0IXO4QxWzj0L/iccBVlfBADMlX7csqKFU6PKRPaveaTuqmE7z7AWoJrN/sQ4ZTYedDf6Oj9P4KXS+b5QHRJiRon+5Jn5NWVAWJW3ya0TBDPe5+oYHcbuDQXHv7Bm5hIZX/fXrtQ088awh7cfuhyGe1SORWMzvridDFLb8pKH2q8hdgLZWnr+0jpZsDBPQBtzAvI/vIUeDQAW0a2Os5FcTHHSMPdhse6jZHMZFcSG+aOgHBnxzG8f4x2JHmyyZbNcNJNfuGie9EFeaR8uJMr8CSy74qnviroZeODToW0bZPrXTCPr8D6PZAXPySnnCIQq03aqNH+Us5tDaqfytNCzn5WQm7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Break up the existing very large conditional, add comments and use
vma_[start/end]_pgoff() to make clearer what we're doing here.

No functional change intended.

Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 995de8198fbb..084afdf37385 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1967,14 +1967,25 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
 {
 	vma_flags_t diff = vma_flags_diff_pair(&a->flags, &b->flags);
 
+	/* Ignore flags that mprotect() can change. */
 	vma_flags_clear_mask(&diff, VMA_ACCESS_FLAGS);
+	/* Ignore flags that do not impact merging. */
 	vma_flags_clear_mask(&diff, VMA_IGNORE_MERGE_FLAGS);
 
-	return a->vm_end == b->vm_start &&
-		mpol_equal(vma_policy(a), vma_policy(b)) &&
-		a->vm_file == b->vm_file &&
-		vma_flags_empty(&diff) &&
-		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
+	/* Must be adjacent. */
+	if (a->vm_end != b->vm_start)
+		return false;
+	/* Must have matching policy. */
+	if (!mpol_equal(vma_policy(a), vma_policy(b)))
+		return false;
+	/* Must both be anon or map the same file (MAP_PRIVATE case). */
+	if (a->vm_file != b->vm_file)
+		return false;
+	/* Flags must be equivalent modulo mprotect(). */
+	if (!vma_flags_empty(&diff))
+		return false;
+	/* Page offset must align. */
+	return vma_end_pgoff(a) == vma_start_pgoff(b);
 }
 
 /*

-- 
2.55.0


