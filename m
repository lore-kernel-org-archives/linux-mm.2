Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 028EBC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC80E6B00B2; Fri, 10 Jul 2026 16:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B786E6B00B3; Fri, 10 Jul 2026 16:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43026B00B4; Fri, 10 Jul 2026 16:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE4B6B00B2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:24:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18BA21C3D86
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:24:08 +0000 (UTC)
X-FDA: 84973993776.28.04B3708
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4B2FB1C0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:24:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yvcme1ie;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7rHiUFVguoq1IEHDVydiWk+wjTNnrgUwNwUljwJg4jE=;
	b=WqKyqiaDruddCdUZs4j+MRE13zQR+eRUcYU8bnvDcEGFkBxmCGqYW9ZaWFr2W+MaKrlmUB
	T6r3gn2CgOJOumaV1qTgCBCCYvmIpCciNLmpLXoVJNZDICqvJK+yRLePL0yvh3bIo6QM7L
	gfEqxwjXCNkiZNKV/beA+q7HmCwdluI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yvcme1ie;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715046;
	b=EUQCjRmsEb9veeR1OxiwyL9Id2oDjuqSbGM8mU0MjxcGdk3aqkzPjsUMcHveSmkyeeUxxs
	2zSA1PkHBCOUJpo7nCVdJt9RkXV+ShpbWbZm8g0Q+1UOIezcSvvRznJtB9MYJkkUxyQ0O7
	cThInqAmit8aqbtNhewDFtD5F/2YPRI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D40DF60051;
	Fri, 10 Jul 2026 20:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B448D1F00A3A;
	Fri, 10 Jul 2026 20:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715045;
	bh=7rHiUFVguoq1IEHDVydiWk+wjTNnrgUwNwUljwJg4jE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Yvcme1ieNXyFDoo+lIS03nV9pipt34r5wD+C/clXyI1xGd4MIhe9cWBew+GBWRUkJ
	 OfNs6ewKzvo+PT4kUyxpZzl1C28zcBojxJSpeoM1fltsLT4Q3YftMtg84J6KqN16lM
	 i6bmnzRy3cNRGNjTONoKz6tAu0Xm9REPzvoTin9cYBi7f97Cr3waoYlROrRJyJh08B
	 iFqx09yKxv+YjA7GXu/KYTgZod4stmW3dMbcoBXT5wmPGSf8M/ZsOcAn4azvutQbxN
	 YKaBXd6IIQNWqpqMBTU8pGx5qikO6e/CXGgvZLiiCoSPGHjrXioIbjQ0XF2RIK/9G/
	 CmjN3WgETetvA==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:58 +0100
Subject: [PATCH v2 17/33] mm: introduce and use linear_page_delta()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-17-2a5aa403d977@kernel.org>
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
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2722; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RyHoLL9QYKzn8GmfhUypF1HMy7j9yuNgRKqt7m0CxCM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg20sa5N6ffOdZY/uuM49Q6T0gTqfSuNy/0tvAlWFV
 naFqt7oKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwEQiUhj+CqbqT5iddiQ5f9qS
 CascLV90qXjKHGEJqw4LrAm3UHI/xcjwb/6q1bkn6llcu88Ye2TFXFveuNVaLfBPeaex5DqGCYy
 MAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B2FB1C0004
X-Stat-Signature: ziux7n8sux94jmxcbuat8sxf6rsjs58e
X-Rspam-User: 
X-HE-Tag: 1783715046-677432
X-HE-Meta: U2FsdGVkX1+Ghu7htj9kVF/fxg+atUbFtUU1uOs/cuXA/GrAC4QE0AmSx3KeeeM+6MQfnw3vzR3mEbIbUoOCuFdTqicVtw9OBbleVRaxK5cUvh7HQGAYnUif9s89G5SU1PHmzQPbcdoRCa2QdNp2Zwd1HhrKosb7PQGhtUhjh4y0vGbYWbaaqGY18+unhwWgZvH/2Bav/2aQRJtZ/EMXcAWiwjy5rDh2FG+dF+khJz7vgWnmzTtlnAfN7AII68xwVhyULCtTSm5emkrQkYo8MVFF5tT34XAEKeTLBL44QwKuII7VMUA/WNwhNZDIcMgdmmt/7JHi6D4UBhFAj8CnCne5It/e6dkAIkLVH/MGHcZme4TvlwdoMiMjWOcxXHFglkoOrGv1zudtphMNdy/OQRF4+u1NIrEEevj6urnTVdYUFRmc6GALrzthxfYzIJ7lI9M6buOeebd9HM8PFaVmocYpg6uX1M6Qjw4535eViBgscLYzzEEIahYbrzMNj6w3Sz1Xslr7DfXdgJp1FicrSopinyPDV/JC6kNCwcYhl9xewrNqOlM4gVBIh1fsZedcv54EiwbHZdQIVqwq8aEFjh+pbBX6asAAhXzVF9Z8S/Iasoq3p+R5B0A6tW2Xb4wl5f68UtgFks1cG30IKQc7jjKJEt1gZf4XMwxkBhY+XGToK6DGHr/d8fi3EUFS7vXaTpQ8CttYO9l34vI5Zp0eP2lZSY/ORCzozg9OGXoXDqudoHABbcG2M59u7JirgThMluk7Mh1axYzPl2ql/6uFJwcJAQQ0OVRObfgSLVrAUwJx+GJbBy4QePrcxqiPGU7f1LKaMsrP6Jd0k+tNziRRc2W2rX1k0UqWIA/PSQuh7lpsKg/MmM1BYnlKYDMIm7KMN8zvKcndnxAhIBkl0PCMEsDt2dv5eZyUae5+Rv9aCSfWbvsSzHSsVNWscy3Ik8KroHsf6V5m4Ouxb/lGIRA
 pNTskHxd
 FBs0ZPQbdX4v2KdZ+cmmp/9b9q9spfFdIbKy4jBEtNz1u2iBGBtEwD65cbeYpRU9/tGTICAAGVALwDXFL8lNeuQuHrwcG4SxFd3Ey4PvLBD9XCVWhftjh88R0Mvj8Fcb4celapvbhQfAsZi4pSN4ihCRYkkWEzN6i59eFswqkjiSmvloZy3SkoXI38c6YFJ8tjZ7gH5XIZudxBXx46CJZYtSPZAXkLgew2AkUsaiPlQlFAvV5ZuaklHLap2PrUBJ4NzdzFSTOJ+sVape+BUOwVhb+BUp3KQQaIcaJOfyIwEx612MbXb38RUdTZCQPK919k57EvH8pJ+Wv+m73/IpXJVXbwxBstar0e2Xdq32zXQkccYWNujttiPrzuVYKZFLa4QtmHT8oIJvp0LH7qwTY59lEzxSUuoeR2ZvBU7Wk0EP96PGNdSTth5iDWiV7BamB61RQ6TYd6QAXG2TiCOOQxkw6mOXCpf6r5Oc8ST5N0wyDS+ee7hvVXme++D8HoAIsVys1Q+mQ4JB5wf66YSPLInMM5L5n0YXC11IyeRlRiihnHOTCFFTvQehIXnPjIxCjDib1JeG8UwlOx+9fYOX4VtdngFgpsLUR9fqROdkLInxep093mpZRIEZT+9r1jkhx1HY27D0a6EBBNmJS1NpJj1MtQ2SCpunVUunPgEuBjjtwe3HuA8TsSAyFX+f53GK0BEPs48vuoPYvUfFZW24U1Dz8YgAkXi0n4bPL7a2tcg6rsEq7zVlMaVhbIQUjk7QuJgLnpeUnMC69MiUSYpGG7rgS1ZCjTTpTVdpgA+DiuxhLDc7EfubTsbBURplLq5rQUGO0bFfeKyqtVmPdnSSYRmhC0dAH5+zO15ZCVfEnZnhA5mKIi52FICvqhh9eQVLm3vYf0/V8NEpf0sKlF9cxDphVJL9EG27AMl5tfdby8400Sek3HRr63ALyfeZtbvC56lXFI2L/7v8uQxluCMbx6B9Ho0Gk
 qLeFiqUs
 1E4uia+CxWRxWrlDo6CBUcrevWIzHzI1ub9yRbrdHZiWlaNxMG5jOPImbmKIvkvewW4CEwCsArwQSDy+j3HNEFDLz1hfklAs8eapFMu3Y71mOvLffgT4sekN8k+YPXduPMaGfcWH2OO5liYOKE+S61gMnMfrgySfJSRn6WX5sykPITzOWBoI/dBWPlml4xvwtsIainb7xbLAKERtAl2DTdFEDmyMnLwYj9YnaZZcV29HHdwK9mRRXWcKFVB+wLpPjxD+adrzYActcK77bxHrcsKUeD7YPwpU6ftNbSq+nsLLEmp2O5S4XmQ+ba4ziCiBJFumzEvKG6mkU0TJlw7DL0quRUtDK5BhRIXMg8b3xe1fqXmJXvtN2v1gLJuhIrA69IFD4sN3KzDMWE4UpFj/YcFRX9Z56W6psSpYWEGb4F1ZoC5PVst0hCxBXNoP3ewTZTGijPyf62Ww73I/gSGF7Gnm4plQe2FrkyCGpnjzmzrOb+jqHIjytvD5j+xVCm/IHl/Dz3Sp/4ws/E/HqGzN1Yi544G76UB8ohP8loh/00z2Omnu/BQl5d7DfwemPc45IQWkSps/pp/IdGCCVF90SHsRP+VTJQLK+TxEJ28tzLgrsVcuOxBFfQ+rwmGBNG7gK0o8JD1sG3NFSwXNlJGQyMYQku6la8ecfQHbB70kitV9gHI6zFvEQcvCGwuij06NIF73/8d62tq3Wv/rV0zbNZ88FenqbZp6k2yLdmBZzcaP/xfm3Emygyv2O1IEgKanRqLx6X+iQI8bExQiALnEuoUelvtvTY6Qac1VfcGvu2GbOr4oqJhnq8MtZgoppiRBeTzRjDgKmfyhCXvfXY0eq5TIXaR5IPrhDlyeGixfBNVZAFiMO18xaD+wn2c3cSzPyjslm1flhJClHYz06dy7pRMGZJeJSsDyMOfKy311HYoJmvnqNOEtDEa6XIKLA1w6i84xpypWjAY8C4yquqx/9ce1bO5W3
 RP6NJXdF
 FUfl980JKbozz/6pN0+4dWfgFjE5xNz45oiJNKba0upcDVwYbm98KdBWWNzR4uxripssn2BFLGRlspN3NiXJbhHABqzBfdOwuH/NzwPw0H2fKgn8kEFJZOrxiio8GGPfYO51uy8U+d6Lgl4FW4Sp0FJTjvhhRr7SDJY4cRJyau4p3/mlwqmT1uTg2YHvlVpWk29GcZZnP5jQVFHeeC1vN7vBZfH1UCcQ/9eZZi3v5La6Swb60jXtguMQrK0AVtELyZyJ7rCPUHdACTeMTE1HXfUIHDwcY8az7TEfP+0dzBuQGqz/n+86fCCWH8ZW2EbxPl7Zf26k8ZJm3fVRJIwAoX4OyDKhrDJ4/L8LNvu/fIAecxeZCpqIILzjmpEt19xMm4efwPBAgKHgK3QCeCoksDuHvc/tmfIveE2YWnDCdMgC40lK3Jc9NDKSSmhab0vKv16z7mTb6O/tH0bxYNkRCfSCeE/cPZtD1unlIg2yUOi1Wh3OKy+mtdbhvvM8dNJqfPYImO8UHC3OdbACqJX2IBFjKxdWZN7GK4DB+zF4d2m4+IoL6WjEYdxA7QxrhAllqxk+CvKMSFExG6S1fSIi5v2qysbPKR8z2PfF8Q1X1wG8Kc5MuI90n7z2QNUYHUffDmWlfrAk8RcU7/Ktqx4FipxaXoRy5/3IkZbRVaXAEbW6CAuq6B3ntsD3ruiBgd8jYLSutpvrD9C4HLgtmo9PP1VfNIr8asjdk/rvDL9tN4+oJkIYZgIT1nMMlKleqoe9C5ruofsGfMKBFdwbJOuaIA4fO7kVQtZA/oIN7hn4Nj+qglu8lxPxK8avaL3ZAyCqpbGOQfQdEVJBfkjNwakJyJ3LVOPVYBXGX6+w0aWk1/iJ3zHQUrpxLVgnLODntA16PtKfd0GiK7adsUl/rCl0HeuGubavbIyrI+BYig+exd56NTR1kNwRQjCtutAGldDl5IrxaNa3QwX3YNnuEPNbj9kfY5Ile
 5bq6EnTT
 aj/jifTCOAMLMQPyvghJvluHocNs27sKtTDRv/TSs7Zt39QBqX32iGCDreIxYtbmQ+sUeM5BBDfwekK4FlLiRkiCTOnHBBRVL1LFiApOBfz7wqcqwKyOa38WMTBNbV+/i74vVly08yTLJWF5LqVVWlsR8J8KMLCTFBhfwdX1uKoGeHARXN+HOewS9itawuc/CU5IPrVV4Zv1ANwarmSMz89teFVbQr7kVhPnMMyqp75GclEWP9cOTRzdpiD270o00SqQQFFehkaXLtO7cQAVU8LV+cS4G2I+wJtj8XamybXb0w8U0iqnMLUnfBQ7uxLMeiuII+TMkZpqN3M7ZgNM1twX2J3CKELX93mVY+PlFjU4UfjzYgGY+jMvmcN3BYQPlQvc4Hh5k1d/1SEkgFAbRYy03hA3uY+Np+hAVj74Xch6uaOmG1FwM2rjS5TVXGbYB+4mOOFQKbpTvaLNHtQTkBTa+oIn2rXeIUwutPj/csmBo/SXoyfjVT2Y5PXEyT/X90uIbdR+o0bQo1pzD+i1oK3luGUtpgURZr2ehitg2amEMvW+35F0zXuchdRtEYhvpNVGKhGu9HCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's often useful to obtain the number of pages a given address lies at
within a VMA.

Add linear_page_delta() to determine this and update linear_page_index() to
make use of it.

Add comments to describe both linear_page_delta() and linear_page_index().

We refer the reader to the comment for vma_start_pgoff() so we don't
duplicate information about the meaning of a VMA's page offset, which is
also less likely to result in bitrot.

No functional change intended.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/pagemap.h | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..a950070b045f 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1063,11 +1063,40 @@ static inline pgoff_t folio_pgoff(const struct folio *folio)
 	return folio->index;
 }
 
+/**
+ * linear_page_delta() - Determine the relative page offset of @address within
+ * @vma.
+ * @vma: The VMA in which @address resides.
+ * @address: The address whose relative page offset is required.
+ *
+ * The result is identical for both file-backed and anonymous mappings and
+ * simply determines how many pages @address lies from @vma->vm_start.
+ *
+ * Returns: The number of pages @address is offset by within @vma.
+ */
+static inline pgoff_t linear_page_delta(const struct vm_area_struct *vma,
+					const unsigned long address)
+{
+	return (address - vma->vm_start) >> PAGE_SHIFT;
+}
+
+/**
+ * linear_page_index() - Determine the absolute page offset of @address within
+ * @vma.
+ * @vma: The VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * See the comment for vma_start_pgoff() for a description of what the page
+ * offset signifies.
+ *
+ * Returns: The absolute page offset of @address within @vma.
+ */
 static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 					const unsigned long address)
 {
 	pgoff_t pgoff;
-	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
+
+	pgoff = linear_page_delta(vma, address);
 	pgoff += vma->vm_pgoff;
 	return pgoff;
 }
@@ -1219,7 +1248,7 @@ static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
 void folio_wait_bit(struct folio *folio, int bit_nr);
 int folio_wait_bit_killable(struct folio *folio, int bit_nr);
 
-/* 
+/*
  * Wait for a folio to be unlocked.
  *
  * This must be called with the caller "holding" the folio,

-- 
2.55.0


