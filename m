Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 150B1C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7416B00AF; Fri, 10 Jul 2026 16:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A68D6B00BB; Fri, 10 Jul 2026 16:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CCC6B00BD; Fri, 10 Jul 2026 16:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2EF46B00BB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:26:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38AD31C3D80
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:26:04 +0000 (UTC)
X-FDA: 84973998648.07.EAE0C7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5D4AD40010
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:26:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwOfOxNY;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUGGYLPM184fXg7TuW5WlZpqNKDyTrGesm4GIDrm7/g=;
	b=n80PjmdEumid9YOKToCKEgJOXLq/1OFKWCet/c4Oys84ELs6MirJ20I39JPqW7e8MCRE4h
	oOSMfrJounYTOV4NUrUg91nfuC3+CBHIDQxMKLdr2gNa2k456nVnXJ3UNzS4EABJbj6sYI
	frluedUiHnA81KptqGo21yzPZ7JeWTE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715162;
	b=uTW8pcnOXFVTOXmg4USXrvvt8hYioft7mIVSG7WuYX5Ss2MMCRIjFgIEalhDlOhjSXHdJA
	57U4NyrmAnmubmYa8+K4StZsp0oY8OCipzX+qtov2Oj6Y+rus5fcyloxOW3WQ1bDAf9PKr
	ATnaTnwXnxNBo1AqfA9ZvOJGoD8YEWE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwOfOxNY;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A6F4B40657;
	Fri, 10 Jul 2026 20:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1A91F000E9;
	Fri, 10 Jul 2026 20:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715161;
	bh=bUGGYLPM184fXg7TuW5WlZpqNKDyTrGesm4GIDrm7/g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HwOfOxNYJr0ufnnwjsShvm8UoTFDoVDyZyLe5qM8luP+IyMfUureE/4/LdfG8uNvp
	 l2fyy2sklIZ1g8zXU1h/Dujp91lJ3y/YMUEyIA0yaCkBv64dn7+eK6bnjONBXyGjkh
	 2MdWVKmdvm7AgFGWE4NqEcl7KMYdmzXxx45wTsfG/uOos67hsa+uJWogpK3oSsHZLs
	 PEoCxmuQR0OPyTuKW9A7PRu792Qxjs8eLhacq5hB9InGQR663cidPLcGe/v49JjENl
	 kWNryTiYfujVP70WKEmXvqMUsNxPgx4q7+0bAV5xV/Oa57dgKbVLEJW9cwR83wMw30
	 Xxu+4E6LLwm+Q==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:03 +0100
Subject: [PATCH v2 22/33] mm/vma: introduce vma_assert_can_modify()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-22-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3596; i=ljs@kernel.org;
 h=from:subject:message-id; bh=viV3MpLqfUAe1sqc9evXVxPvdZ0z1c7yNCArBlJLKts=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg22Kz9fNu6eSNvvBXWZ7lRONX6ct3GUurDZVbbXAC
 pPsR6V/OkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRhN8M/wz3Ji1evXiHVaSo
 7KH3RZOj9q/2tta+sizgwKoUXSbHeTEM/xOvbZzUJBNU59dnr7C7/JXw/aXmwrs9029wLZytnZn
 xnhEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D4AD40010
X-Stat-Signature: q6644kdga65cazpm41yafk5gz9sdtk4p
X-HE-Tag: 1783715162-628263
X-HE-Meta: U2FsdGVkX19ipG1yQsN+6wlEk7bDGycggDkMzYOSjCmvVyGgREtB6kSBtS23hdS8CuXLaJhDA1bti65Uq8QjONrxjFhGk2S95JVgwm5DHRr7rZ9JCgGNZ30RylvRNuw/HR11x1wVHh9A51RUvJo//O47z1kk8jb6RKd1Vc7Vtq0SjxSKVvCzc3zkwYTw3NegkBar9NTDe6KANNSlexYmkLIl7yH07+PoU76hhMJyxWtLdu4FllseMXd2vU68WV7yXLnq1ROdF2770NRPfDYA1SIIIfF4sPq3MWY8qPr/WFx4+CgA4o4x9MSARZS+vNLGIYrfpowERFZXZXBehWms99uMPWu7mjI6vi4Gw58udonya8WlpRbNmrKP0fIph+1MlRHv12A3quSTHUhnxI3UV+pkVGK/qmcmbq1Og0EvtHYibKaFo1/wUdeB/iHtJvnYjqc0nmmveUZZ0QqbT7iFj0t+97GNqEA5txDMlO7QDiqATDkO6b25l5gdexPraMrntArl1bAAO4TjErmP1VdCV734VLqkXBvDnRvA1sgvGH2uF2SQcF6oiPXRcOFhRB3UD1rLXgWzKdqLHOTgnn7G/VbzsEfjPNBghUEgu5CMBZc0hbdgpqNydGJjQLjnmaK6phP4teayydc0urB9HVfX8e9zKFi24zPND9gfJvEZEl+Wu4f+fPn6w0y22obxM3mJWU53z0fB6PNCIAXorWFJx1x56z+nf8KlQMzb/i63Dyzi7k5Tt22VzmCnDjTwOo7TirXhDmFOX52Ru6rgfio0nk4aOolhE2EnKZuua2Y9r1LC/hEQdz2TvfG7dL5lzLLHqG5fTo7GpWWPmLfM1jXWVHyVBif0+hlae4MLg6pX0zPRrxxbwfUrBBwvN0wVVoLf9tkLh7zkNxOHAXY0nKw3mrJXHHyzNLDqGmEaJx2Eesa8Pn3cuw2l3UR63/rWwrkIPAQQ4qa6ZmwlaZGi65L
 9MS2KPYl
 DndOF3IFra9QJgkTH/Pmofj8ujfceVyayg2439Yh1ubkn5QXqvNOLkobdnyE6mcqN9b9HHQW28ndftbM2svtKN83/iXsHCGDZvGyjEjeuY2R1nieEYxqqWcDIdxu/ixD9hni/dWg2GjpTwiOgfVxJz1Mn6tlcJA81yXqka+aVqrN/1d9yN6xjpEXKy5CExRwR7wof6XconntTd/4+oZ+k88B+Py8+txX91/71wJxxB8EQ5Q3LQbrbEL9fRKE0GOLE323e97HpCF41B7iCmZSRiMbi3TfuL8rGz2qpLuWj4vYx9PjJ2EAlxB4IXYDwA8N4a4NmWMgsenZiO5rYediITao/VsEgFyWQVV1RPjkVJwggQKGDtmskelDoSK1uv6WR2Hjkab1Ifxu9JmG0Iyu0Ij+Zk+CoSHrqnTIRIMpebyvN59+jp9n5qd3bXXHQCvB1K5O70u2PSGhgGbXziVSnFWcdlHbI2C9NKO4UkmYBIQbzEa27E0aFvPerTCEXtuSlK4MqUW/zFSg5lP+KwXCp1PNu+UTakQpO8ORBHxztz4kPdbP7qGI83PrrE7X/fySOdYOQLval27mfU+o5y28f6noUykJauMY5YmMXf56CPrEJPPrjLZox09bk9j5P7z3QDg+fHNnzqA5OjsJkkR2kze9+5qud6D4BClqYNKuWWT96UQX3f5hJCQHRGC76kqAN/zuCMF2MnMPZGuaOJrwKpsBlgF4NcUXXbRA0q3HRzBgIC06To+BGYODgiIsbFVKJ0saCabIfUerUqMCUVxXbxJVLbKwFzjD130D6NRQakhgW5wEnY86we+Sk7Ej2D0+Y7ih93FKYrjPh/Ko5yKf3kHvy7HobSvL+I7GKO6THKQHO8oQSSvgAAwzlyMFh+LnuKC+W9396OxLe4vYduiTgGLxriO/cQHxsLc8JGllKaWoMY/yImN3qHqje+fec4s3mrWwhz+WwQnIW9Re26CaaEnslZqIp
 /WkoubUg
 o4P/yDNb91cHlVHcHv4Gw/cx0w/jRdqlXx2TSzvSPnxDCRiUHdnwEg9F8nT2PHGiFx4t+QffMBPYDbuC+TyO4/8GnwSbDVaWPHPCkwuSwQb9Jgso5qRQgHRCyezPQGwIOiAJ9JS5w6EK8FphbAI7mfrXtoxHXtRJVoQUvP2l1ghmcExMVK6Fkq23NCRKqQdz9jZD0Yo8uwrYgMW+Lk5zDUgCDr1l73aNERcPwgW+ZRs33ZcZr69I2CZ49/k4qFTWVexAUcBw3k0RFnIqaUmYeJ/inn+6Janw42Xui1nwpJT9GbaApDWXD53Q0OVDM49mr3TPmyIgoCKQTqLW71VlxAnHflqOOb/lmu6W7m/S+ZWDAGtTigWREuqCHjHNua1Rl7qG6LHpEfwFPSxKVUIBxjUYEgWlai504+srYqqYjrKujdSooZFuiJ/SBrlsLaPv2gcUrAMseiNYSA7lpdxlxxEmTY6WNkGBfc57fZqvwXDg42Wxqnfce4H9HnU/5hLrPE/KDpjQtrK0idNBqJFI6MiaH1Nb4gJ5OUvX+OsP4QW8NJ5uHnk0sZxpMHSxbAqpots6YErsXJhCunnMdmEDV6e98gafUwRw3yYiSNCaRV7hxr4vIYKjnRGZyxkqoJ3P9PQotsPvN5QKBkPVG1m3T3FNVifH0lOp/HbSHGQWnPbzsEzMPYNI+hnt8LuE1XTH4lTGapRK7M8PAiUbQhEUTRpWwHcZ7JAXb3hwM8AhWdlvXULmh+RNfxwRluo+alVPy5wYfvowUaqzwFWUjIpUMXdXVh9eSxWCbvu8cMyvtvouYlPTdVw4Cs0YjqyGyNEEspdslgPyAJ3mbuPjFN+0NMPgLh4O8cse3bSr2MdHXlJUUuvdCF1GPubQw0s5r/W30XC8jxlFfbrLNF5wjMNO9uE/wvoWJUFkS0ZBMdNDzleayJMuHH9oqpDE3IPgji3scNSvjvA2IRXBEkwGQPC79LDs71N3T
 OHhAoWNa
 QyvI5eEQHedRRmLbLzzNU7OFhH/Cg7mosnkZzOdkCJrQSJPUHgySeYuH5Xolie1DUHYsJi8Xi/BrcVleFG2Hz22lTTKoO/ApqbKwdRr+PD5SMAgQXb16G2kMezzXY68qkeMw+f9ho1aAW5JnT5r+Y3D+keMTVC1/uLoYTxsOtBF7qC7FzV1RWE/J7f3tubO7GoxqYQBXC/tntbSf3r052TXUmBZXngli8cYOw6jQR3RpF12fy5/i8Hi3QkJcvWS4E4RMlu7PvbDaj70753f4DuTI+/h0F94JXqjgR8g5iciasomNj0vlK0GtbtgIGShLS1/2xussOWJE0fVlR/NGytTHvDlvfJhqyXIwiOk28cjNkhWwG+zt73rJh0AeGXmzvDMJ8QcqIWeGe06+LIyc71COefMPh4jXZx+QZTydK/17pTdjm9ZU5UGQgCLgdNOLp5sOois8/e8yW8ivp5R9BnLQJawnDAJfdbK5M93v9L6nq2fX5eQzmJAtJvp4NQ2f2qEgdf0OQ2gusjUeSfhX7o7JX/bOpIbmhfTCsvEjrdCAQotzCqj1VbN1MReio1fSZhccn+OzrqP+t3aYGXYbIxcsO914TR7TGi8Yi3MZYyLfVGLQsEb91xbfNkxdDWdqz2MOgrapeU3/nct/0WIrXXXASBHTmLW1YnSYEsAe5Vy3eudO0d52rYrhDzbCrIM2o9KSu3Tntvrh7c9Z8f0qa0CsrHdtEYKbD4RmN4YW+E2rhIpq4BxfZkVGIR0XEQTjgP27obUT7ntxO7dNB/8viR4Jp219BUzByztADRvpUr851J3Cc4rfVxmdEDX2jd9pPft8dBhb5/6Lwnhep0Sk19Tfm6IZFeSz79Qr3Dl0d8FFAUuRnQVkXxeafqCxNCw36Jsxw5JvXjYmHPGm5XxIw2tGbgGucdusxXCRaVqM8hVqAM9+f8moRfGkIyBx+FmUXMp8ziZPAS9mrHjQ3IBixFNhogEq/
 kjG6i5zG
 gHods0lwLilHjwPrNHJcSo1ioJuZ7dK4blr/gzGHP8evm8XlZnYxVYbKrO1qAEhLWpVVufivtQSxJx/P5RvBTGVwlDrF0I2CzwQztYUcbOwE/UTCpSmy7B2tqYpIrmMVZBlq9y7gxBGSRsCidwXWB9mJH1ARZOfmTjaAoMXIlxqAMLotMiX3nR5syna/FCunbqV2ynmImN7Itc0rPXyIy1ftHaCXBgv/Tqov/JYsiHH9VtJPWsGP5I+tqixLXQN2ViYGdENDnI8lpnUQQId5g980xc0KCmwn9iQ43nOu2HKxYU/lwhbdU8Et4+Zfn4oR0a+KTHJEPNepmT3YpvrOTdBgPozllitNDnLcOl5nNn8R09QsubP/yVzkKi8l2QeAOQLDVLk60m0T5KcaE4V++eFgVl+xHfx7ygdGVIioAzen6U8WwzZiucOhBT4jsxfKf8MSBeVWgj9r1dGm3vXib4Wb+THa7fqGIs/r2Qemoa7gG1vGA5SKvP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_assert_write_locked() and vma_assert_attached() are useful for their
own purposes, however VMA code absolutely does allow the modification of
non-write locked VMAs if they are at that point detached (i.e. unreachable
from anywhere).

It's therefore useful to be able to assert that a VMA is either
detached (modification doesn't matter) or write locked (you're explicitly
locked for modification).

Therefore introduce vma_assert_can_modify() for this purpose.

While we're here, make vma_is_attached() available generally - if
!CONFIG_PER_VMA_LOCK, then there's no sense in which a VMA is
detached (vma_mark_detached() is a noop), so have this default to true in
this case.

Also update VMA userland tests to reflect this change, correcting the
previously open-coded vma_assert_[attached,detached]() there.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mmap_lock.h       |  8 ++++++++
 tools/testing/vma/include/dup.h | 15 +++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 04b8f61ece5d..d513286d8160 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -506,6 +506,8 @@ static inline __must_check
 int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+		{ return true; }
 static inline void vma_assert_attached(struct vm_area_struct *vma) {}
 static inline void vma_assert_detached(struct vm_area_struct *vma) {}
 static inline void vma_mark_attached(struct vm_area_struct *vma) {}
@@ -530,6 +532,12 @@ static inline void vma_assert_stabilised(struct vm_area_struct *vma)
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
+}
+
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 7ed165c8d9bc..e9ddc818f2c3 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1163,6 +1163,11 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
 	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -1170,12 +1175,12 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *);
@@ -1564,3 +1569,9 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 	pgoff += vma_start_pgoff(vma);
 	return pgoff;
 }
+
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
+}

-- 
2.55.0


