Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5439DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B64A6B0005; Fri, 10 Jul 2026 16:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467196B008C; Fri, 10 Jul 2026 16:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B296B0093; Fri, 10 Jul 2026 16:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 095736B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:18:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D76C1C8CB3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:18:21 +0000 (UTC)
X-FDA: 84973979202.30.D6CE4CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E0931140005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:18:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k9x6bBu/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6HrE7a8m/FBNduG5UmQu6NM/Zihxq3N+Us3HpMrWf0=;
	b=Z1AvcytVq0/rTvxo3StmhgtAhXuzX/F3mF829axsa3j7p6CbxDvbmqHrzOSnCHK3ttShCC
	Cax1Wd6zjHBz/UxrgjvagWXO50GF6HCUdhoVlZo/FznxhsMrZ57xCOfpZ+WeaUKKblLqcG
	AWtNdwz1eReb6wxH9SBFjwqnE+YTm3Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k9x6bBu/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714699;
	b=OjkD852jHeyvnr73/qwT3KQPtuswrBbpgOGDJjy0NAnSfRw8Fl8aNnPNhgdVwJ1ZyCY2RQ
	esTgECT6Y2H+E1ORYOvX5w70XhOLn7LL+dMPhDkX/jsdLrND5dBUVAZlMwHTfcK58PPj0J
	795J9R0HHur1pOsSJ/TFhHBxeUdd5m4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA90D60051;
	Fri, 10 Jul 2026 20:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CF71F000E9;
	Fri, 10 Jul 2026 20:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714698;
	bh=v6HrE7a8m/FBNduG5UmQu6NM/Zihxq3N+Us3HpMrWf0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k9x6bBu/aDqJclWvIhrAFa2Km3ddMPBAtjIwTK7nSswlBruWli5QcWTat4njQBiqs
	 UVhnCczvDERlE2oktg41MRtRbDgpqFYyTvHyJEOwdN52fR0U9K7S4eEI+ivMMZHU/E
	 s94TNQ/hFEIbzNFUeBRcARELcVpmMKv/c9ix0LYmMpx+ruxTa9urMXg6uzpqox4EYO
	 awUT6IL8oiBtUsMRD+pvShNA/uBh90ZipA/LcmkSRwid0fnX76nmL6Z2mZUnWjHITr
	 8DDWg5TjJX1NwwQDiG4pGwsGAdk15hgBvBm5kFxh6llBtXDzCykxf9jf0N/TeK7v2a
	 BiSwLHeUIJfNA==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:43 +0100
Subject: [PATCH v2 02/33] mm: add kdoc comments for vma_start/last_pgoff()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-2-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2376; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Znpqu3j3n6WWkTacPqLkxSLWmIlM9cO5JY2coWFa+KE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg63ONn+VZLkzqWnvRdMkgYMTTO3mt5h3KcYekJN7x
 fl+5a25HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIrxPDP8P9uUlGDz4+PJOx
 4lprrMA30daSzh3bt045v8PEdtedDxoM/1Me7yloK9X/Z3C//Zau7XbuQmYP/4Xp92ZFPjFWLy3
 bwQgA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0931140005
X-Stat-Signature: g99pfwzjk19zx7pk8kosxfqupzngs6jm
X-Rspam-User: 
X-HE-Tag: 1783714699-93267
X-HE-Meta: U2FsdGVkX18eAw9qDetytaLuZeOPV2m44M3W96hZKcR73vq1VPCS1oz50KNKK9k+TCtbFWIgvQ2frE4E6X490Nu2aXiT9NkTr+iTkQDipVEwDAX6QAaQQ0g/y8kYHD3KUpHtqFcmpfH4CnHMbV9me9ntoD6NDFrrXPC11BXaj4ffZBsJygO4fL8oQVa8psJPd7mvVjGvIbpVaqoKfGrQujhCvu3/gDTNC/D8Q6OdnXLM030/dcSrtkCuVzFph42eyDr+KiGYlR5253pBuk/b7DSsZcNm9Ws/56gD08nTyRXzL0mn0hBSQsCxDqEbdqfUbF+oMluv99KKebUtIkmsZ7DJY9rJvMRptjesyLXFppb7kLxMhoLbgMJN+NtW3orNhhqKoKHqq7Vxy5sZvEX11NLP/+/jNwFy9jZQjss1C2qB1q+NTL64IO5MqCy853gWL8ibwqdZKfCOVf/ZlOVXS8R/uLnjdkBvV6lfieSx0t1bMJk++cmf07Bnieqrc3SnX8yBEaBZeIvCGthCzX9KyO6BonEris7t1yESG5OxnlRZX5bBRpiIJKHbBKROXUHnrDuihccXCcvQOMtEzv+r3PVj19bgGUPPe4uSbZ/icaLWp2g6nALMwFDamWjfYyAd2fTTy+JuZniDZ8tBCV8E+hmsqBUoNNinrQzEjz3k3nHpkpRWaqz8EXOYzP06eQZlki8V1qldBMlT/6L/vYNxDsdktnlNnZEFey/eEgm6ZOE9Yc6EnLN6J2Ke6QKvoj1zGX7b2ZwGcVlfhGCRbtOQ5meVm0dx04Ku4rdn/mioyyX5y2EIU7u6kDcKVvd1Zwa2Lq8e8O4CL7nikRbnsj46+wrN5P9IiXjKwn6DEu3SGLoCnyxWzXaaxsfoHoCfLFG6a/Mzwy4Bh72VUrRhQslZnWlfFrYsTyoQsFVhsr3id49fomLZPHHN91YXKYfF2+HT7DnNzjbdZyzWS0dQn9i
 vbTmD67s
 XG0LlkFvXGdCIZ9am0WqekzMuE/UwrCi+VD7fibU0ehyTcpIhUc80zTDtkjgzY9YtwGEZ49wADccl7uSXO9bSkw8t/KXNdjPQkTleI+fOl+C2TxONcBzZfJr0n7ER5vZS+oal7kwYgiQDCeFOpvQdgNfr68bOgxXyCN1Wdq1Zkksfy0LD224frnhqgvnBs0WhGuHkhPmjCKi0Du2b/9r6O8MZvr3HJIG3cxhgq+ISt1P5wBdzNMC5lqPg3nJxXwzdC0RWNT5kHhPbiJUw3lyFU0KuuNKdc0rzKjTja5rLOWg9fBNKw4666G8dg2vzwR2+V+ooxExlHgm59hjDPm6O42caszgvV/XVozL4zjMlHuNDP5aTA9wXNmFHy3BA0rhwWKnWG0nwim3Hmnnt28woD4qYKgiNfNcsR2lGmU6IXOPQIASC7WWTH+AJX/4E3kYJKWJIYbDGBMugSrQfgaJ6Kxmk70FkJCUTBcx3g5EJKzQ0MPoE/J1GdU50zrlryCy0Ua2QKuxbKdt3W/A0+V6bfhOMm0q9QYVDjEQzxUrXeJ7VDcx/7PqL97uZx8eC6NacBgkPRKYsM8kyqgIz8Vl0gy1bBnmWqdfsMBtj1MB/xd02+H9pHiLUeQlPymC29ayAUDp7Wu21+HHD6HkH/Dr5TQsJLS8Mr6FPxrQx1dewOEqGFrRRCoL98cDuA20fTu9GlJNJXReaPuVpCg4A/JhMKajYS2MiTYMIHaBo8zGf39TVkaj4CO9lEJsQ72/uKbIYia2NqMiFODbrwZTMWeykuj2FetzwBQyPiKImsjeEMuLUj9nhfEyisG3m3g0j7yhCJkCzDk/uzP67iXdMr1ix628Shy7ln2qSreCH8iZ7/msfqZ8pJZ0lLEdUz/pKR6hd4k/HeFngb9Pag+bJrIxp3gAATK86ZSYpTxwUwnmtGwme1HbOZGUILCbi3NzKoJPa3mk99nOjYDW4qF6WKR/r/LG/FDPP
 XlsW/o5n
 GjGzGZCAlNmLgAMMHvecKtAB5K3Slq9fZLMnd3jYshOAvSa22KQ9GhUCP7UNCq3ua0+HnxKkI9ehFjHlYHYPWbbX88aHl9dRAfpkir/sqbnF4l2UwD8lyKgFcv9A4hTg9qq7te4vSaTmKuqSBzlvNgH9rk0KrK76E3qtdBcshebQMqBSe0IS4toKZawfcbB3eKLz1isWJKADAiBMLkeNOl8ENQ6q+gLMQnA0DuHMLhdevciP8AXpEMAjuQcAspZFx/6FAgIHZ3B0HyuQ9R/qRe1FtgM6JA9iidGCWsIZzLBPFW7H/aQgJapxKVkmdyYyqdAPu/A2DXrOz2ac7E+vAenZo2cTkmbZMiykTUKzs8QGKL5RC7MUoCforARNq3S7qX1x3XfRjAOwpm7QnRBSUvrcEylppTBOYMYfRKwabQJS/PuwY4V0xAv2XAaDG3KrgYAcNz3lir0sZUWwECCkNVs94BGAMq38tvadymO0T/91sKboE+/AldlfEKoSFBtLrEEohUE1i6R9GbAZ8IU7UkzIuQord9lPZ/Q1lhVNsvwVonaNDb9aKwxVI6eAbF9Vp2Y5NT1LtUbeFGlUNzWubPM2sB+l7zUzdYUWzdutSWgksferhjtFK9/hi6XFbqPGJ3KauPKM25AhTf82TD5w1UysLQEe0nn8iM4bcojYiLRp+99UPb1VWR8htjCC06Ac3d7iEpad/V+mckBYZZfeaEwAGxLah1GeWUBCDn52l0M6GsjQ8+zr/2Iqwq6ZklVbtFqAcBfASqvhrtsCUbWPJo77M5HgOksg8IIGmaD/5g5KQkk2aHsdlX0B5s+9jZC6g3/mhI2L3CS/mPkcVcJ8Nr+JBcWTaX0eJvd172znN37ncV2hxPiEoynYVy/AhB8Jnx9c0GVSxHpzvB/xlPVp5UADhz9CwJ+PhvM5G9yB2Dclyo8GuUNSKDtBeNgiYZSnPzA9IJHyP7i3vktb4oY0IoHGHH+l7
 6uVUpj5v
 XUHCRl8Pf9f5foIGd8LJsExvSFaxScqPG/W5X567tuN51XTXU6Fyk0mhz/zPqW32TZWhvINxdHCiS6GOtptRupgFmXN7APLKJ/5T4+rcNnl1xhq32ViVH7TmRauzMnLZo55c/r1ZG1o4EIODLaFNz+vg4txUUVvuCyZGWhFzKuoax4c7BL/tqP36cUZEx2CaVjQ966qrPCObcXteQJ12HmLSvmJRze0N67X9n9BfzEz5KuzzdF0qM153fKMpPoZTvocv/5fNiaIVZa6fW6hAIXkon1feA8ncCy9NKveKmFL+h/3pzk2wt2oWibrMwcfvGHjl6Ggex6cZCzDV7M9YQwtYDt51YewCI3N7Dbj58C6QeDHtKFw0PJAKXdLMFPG/qAJFhZvNyPnO/x7TkKs594eqrxyx0QsxyKF7C5FNEPpSOCf5K5mN35jtgMBqrpLw7Tni6MG3opz/4vNLe5kjKo+v55a2ONZjaGJ/mMCmqYgEhUDcGsm7IMMzG8v+3KLc/uQftI4j+ZWUUhU7vgnwrTRKziZddhWeBcr+B+KtNjIYeA9qcIGhnYo3EX8hqORUtpGwOhW89VkpQ2psu1aTBE/TOh63A1yP3kuh9voGIpmsVWn36RXyDFhd72cMJNR386NtfeoSV019HDx+yTLINYPxosZSdrBloGqMXpCDhwmdZAgqFSCB8iJgD8KJMCR0wVIBLL9EClJxa4yZmnTZQeFThNV1sapMfoFRqERtUqOHYHTGFmmyasJcK6s8UZAZwY5LZmf6SwE5z2HvgRrpKr9y0G0TealBi6ZqngKEVzcSz0PsZaHjQrakDacfubnrg8Hq7jQEQI1uXwKtpcvBMwXEpUo8AN5bIg79DpxSnNsRrUyODLcTn/GEAgu/WrBi4B8/pSb4Lj13zLfS7qVz4EnpGc/OwaVgjutyuq8JUDv7hBPyJIapkRHQ6u52KOWaD0eodE+igOXi/+8CXe7HEoJ282053
 VCiVyTGP
 EcJXwez+3Gsv1ooJjiexbpQj/61l3XPnAAERkwKvcMnYWADXlp2D9AAyk1Y6AsFc+8e7cwHgLh9lqt401QMZokhv7FkNGmRfFuzIKeOmD3Sv/xYn+PfOOvXhn03qaRzRkdLjf/DXI/U14qbVsigqrZCQ4rn1U0wiMt4Sun46UgpnKfhnN1UnuNJBch5uQcPC8f3XxBFsjK/qAsXWZiFr0Tqda5fl+e5wVH4fMWq3D9RE8CqqHVerY8D583XxjykL5pELlWRZ4Ltp/y/u+tBpYQmZ2UBS7eo8EGpkkgU4f09ZBE1rCEYPiERA3dBRoCQLlm/aEp9iJWlYzvX3d1jxkibOfKRydDVjUk3MSUjDAwbmJw+nDqPiZAjwrNfP5Xrmlq6A8/LVZgDp5BVGze7++OW/65PJPaf8vTwbYQu4h+y2hmNectw/tsmt15c71x5efs1+72uNntx723RdMJIhS823b9TOLRbr5qjL4r4Tyh69VlyogvGGW8k+S8MQk/fPTmq519lkeLYS1H9pl2bxzJ7tAUopBSUwimPiOtjg373+lFQCi24rvH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
detail.

This is in order that we can differentiate this between functions that will
be added in a subsequent patch which provide a different page offset.

We go to lengths to describe the edge cases that can be run into here.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 09b06d8fea74..abac72785277 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4307,11 +4307,41 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+/**
+ * vma_start_pgoff() - Get the page offset of the start of @vma
+ * @vma: The VMA whose page offset is required.
+ *
+ * If the VMA is file-backed, this is the page offset into the file.
+ *
+ * If @vma is anonymous, this is the virtual page offset of the start of the
+ * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * virtual page offset at the time of first fault.
+ *
+ * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
+ * page offset within the file.
+ *
+ * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero satisfies
+ * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-pfnmap
+ * regions have their page offset set to the first PFN in the range.
+ *
+ * Returns: The page offset of the start of @vma.
+ */
 static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 {
 	return vma->vm_pgoff;
 }
 
+/**
+ * vma_last_pgoff() - Get the page offset of the last page in @vma
+ * @vma: The VMA whose last page offset is required.
+ *
+ * This returns the last page offset contained within @vma.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The last page offset of @vma.
+ */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
 	return vma_start_pgoff(vma) + vma_pages(vma) - 1;

-- 
2.55.0


