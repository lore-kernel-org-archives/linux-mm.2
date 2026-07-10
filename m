Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37671C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE446B00B5; Fri, 10 Jul 2026 16:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FF96B00B7; Fri, 10 Jul 2026 16:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0571F6B00B8; Fri, 10 Jul 2026 16:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C93376B00B5
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:24:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 690071A0584
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:24:54 +0000 (UTC)
X-FDA: 84973995708.12.3EFA896
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9EA2614000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:24:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7uhOJok;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9U7hTVIV5hnW3Iy6tzDPxArKTc/td9u7V5EE/DSgA8=;
	b=cZPK5arqk4IozmLFUGmTWLHP0NV8pGXdiOxJ//E5Dc/HTOE6rCLjj1mM5d6v464VtyfdO9
	UnrkAY3qHegOKh2C/vBw7/67FGtgJdMSj1invP9dsfaO0EKUPwcpg4CZz8iuJCtS5SJC97
	v4f8dJnZw/rZp865w0Sol03tlshLZdU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7uhOJok;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715092;
	b=mgCntnUHb9lzxPt1EeO/1MAm1sCdB8zMOAWBcR/knZad+Km9zkxIfyAuO1M4jPEkrK7yqW
	y0IxVER/ICyvjDu0vz3KqoqgXaaKT9vMCZsWGi69XYXQXj1pxJBTN/fIP59hz1IH85+lpi
	heZvSKOr7UOoQCxM3NJoisiL7PmtXVY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 100096111A;
	Fri, 10 Jul 2026 20:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3C11F00A3A;
	Fri, 10 Jul 2026 20:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715091;
	bh=C9U7hTVIV5hnW3Iy6tzDPxArKTc/td9u7V5EE/DSgA8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W7uhOJokhKc2gJUfGeoUmCzknt4Uxys2U+9X59vh+pxKi5io2g2zMfJcd7yhqe+Rz
	 PJuzoJIGnd3IH7hewvWSxE5ZTmcXH6LdeBTOkn/+XgwR9cqd6axeVqm1wxysu08ieN
	 MLVpRkBnA0838K8Rrt8GC8FcdYZk8MTw62dLxILsRnOz2/SC4Dv9NtLxpF37T0uAdj
	 VJEdaWU+Rv29jCHBWZafM0pjlpkfNbnmHg4dVJxwp5wGPBCtM2aP7vZJ7HTPwMkCkm
	 XljXzGGXS0Cpa8u/2enRoxyu8aqSQAUNeUJ1sSuPOzOysHNf2I58eZf7+Fp8a5rNPh
	 318DpOBchn2jQ==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:00 +0100
Subject: [PATCH v2 19/33] mm: prefer vma_[start,end]_pgoff() to
 vma->vm_pgoff in kernel/
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-19-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11256; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0R0W7VTOgU1IPpg8ezqD30zdmiulVdYqX8Tjb5nSXd4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg230KqLcZxxjPdSmk3RkvUZI5Yr7Siffuqxo/H0xZ
 G121+RZHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIdRfDHy537lDf6d4PPjFf
 OW++NrVRreKvwy6H2xnT9ZK8tjoWRTL8M5XKqlxwI3v6u/lWb176Vz6e9TjqwvY3u9v4rzx8zvi
 XnxsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9EA2614000A
X-Stat-Signature: wfd6537jq5r17rir44izy5h3fcn3fof9
X-HE-Tag: 1783715092-724172
X-HE-Meta: U2FsdGVkX188/JNhHNhnkXcuzSMldCz7v21UJ5IAQKQQnlSUB9rkL3C8ZEscLRygirLt/j8r0VOo2m0s8hLQpVFHrtTn3TGKoUr7ZQ+SLc3DlZ2VwneUwtnzUXAPzFuzswTfAIAv72QzWp5om7uyVPgm9I/W6QlH9g/2MU3lYUmS0q68jH4sJXkOZDKkC0O0JwaRah/BPXQ5TCxBsKW2vieYA2bmKh2sD+hNwlLsaBxFoYef7voJaS9M/A3eXvpPIG+CBLMuhtHsSkqfQ0eYV+bDRtYpBn4lkvgOFzh3sXpNBZheBfJ0JjUUO5Vd39teSEc56n7a8eWc+eklSOKPSWVJjp/j6hQExcOckSuwfQ/7/CfQmvPxQB/1SUcTNqPLbdZNqB6s1ZZDCaZh4R2mTL4pWcBuYdpAw0gxMcy4mVDGRPXy87tK+mT9eun8BaOWjOCxBV/TY8B9vSZdle6JXTIJc3FTfRNSecnVrVdk88NQUWBn+4VYR/Ck28nLjapngSEnCJx9Ec8ZTIzl8ib6USQKIflRPcq3sslPQq5fMy/2epHcMEmuoaqa5TqAgXEsZRtl22g3s1UuHVbDOhhbkSP+uh9HuZcFCYaK+vNwTaXner+2PdDREqezXOFWP1ZmdQJgLEweLhcoOGIEblcxuOcu0MuU4NnvW01iiljN5BF+/3lVh/0J8+KXYFtNcQ+kExfpZqB7JLrOe12js8hAyswgjB240VdY2YeyxIi691PbdXmfOyqkNjfCoLcfMcgKOrYhjuKcuMXPHJ9Iki/TiQCzQCUMH4Z+WgnlZSO5EFYQWEmZTmgZ6pdmD2lk8oc0DFQE/lwCECnKGtkYuONPXMfN5ZuhIz3L6HnR4ZoWASVtmvRTvsWLhHt9Vtl18GQqAsUi6hNunjyTA5mJSdqcqMOAtXKb8DhMOcFCgwGhs8bWHnQy45Cs85IAkjuCc52e7W/Ee13xJbAWr/MTpoE
 Xcgu2Y44
 GVwwbN5J+kJ9UByZ7THjc0qJcl2KQMhFdoMT2k55KyYAdTrQDqqUx6B4hI7pS/xZytN/B44XRmKImTaLMHYoM5HRMRjOvB6NBzl9lr6BJluDuvcl3wCnBGHb/unsTIh+s9AyVfwmh7spsSMKBwLG3EMjZ//C804NEH5FqWiW3bM76SMonmyxL2ULkalSNz2kZ/L/pNdz3aVBW6TSxzWJlB//jzooobfz32NWBtAocdp/gYYSF7l/nIXP1oWh0Vg/f2kh/RbnUpDdHKlaej7JCDpOdCmmOu71sM/MOzwFfE8aZI/BFbwPasKjWcv8f2TuytfKt6F8jdh4qasOJ6uHNp4TXozx2qIWef8fU/NXlgtcjYSKzmlAT/ft27X2zBVP/kGjFWRpZtdfN4jNCMH63kpXPc6wt5Be4Z52fWQmv1kAO8CKzESZ6xSqcKj7/bJVz0U6CnZC/+wzTh3lgQxIBnOI2c4eyRVOi8RCVhBdzw5cBdxLhSmaWIleZbG1CdDBYX1nNOejboYMsCRkY2JskDQ/bBOTN2ewG1rFxYYVMp2GZeNk4Z60Cp/OEf1XHcKpRv+xLpiMIxnirsgVucfBEpWrjgoMPFAOt2VRaPTJ/jsg1vECa57Fk8/VNj6Ew47T6A5mP9dW52cID8jtpZI9565G2J16FT8aOPI+ExAkgjQikV0kqunLj9XevH7MKXqLKnfMRp3fpyGXvfPzZPF4YQrd5J+xLUrmtpu2UIQGALmAbpXTBAkCC6fM1Uw6d+375IaKAV36zapfMcBdnJ7Vj+OI6oyuxkNOHRUczZXhSqdSVUK5JTzCTsnI9bUjixb0BjhlxXd+21r+ZF51Y+NmgbMmkDyGEh6EhyVzsXYKnCozjIktB9dMQ6ikVKjlwPASETT6jau3Ro1hfFKGM7f93UT4UwAUdK9kMCPS8EnsCIofOdxCjhiZ7uDLwSHnBztQas3YCK+KkU4Qy8EooSLrIYNObgnUe
 9W4FoLIC
 7dkc99ur2NgxvDmBoniRo0aG4C/OEMSgWF6Lj3i2dr1b4aWn6kqbwOE+H+af+vdEtMfhAWsvcENlcreOrXVk7/+G/kCxJgEYjPLtepzYUePj6GskL3emQIztWdkRoZlg5Qj2sXPm1vQw2amspMhHi+0zY9N9YydYBaiSyBB6TeUbC8US8npbdZPHlrtVVJO87NROnKs8brxegWMDh2StfF8bTOV971UVmDhTpSa2aSIni9nD869X9PpxR7h80x9W3lo0gdhNAnSD2P2pQvu1PrtlfNZpB6iuxRYQk1uvI2m/kh/78BMXJs1lEvn9MdPEUtzC//fHGMj20qg9eVb97BYqN2kjKb1b7m9rQqlwkFsQpxEG5PwMATtOPrzGAD/MUfiBgAbj4I0NPXpARGMcj3m5H7PP3WlCDjpzlpKJKUQRvXySZohd6MUZW8N+h+qNkK10stVA2Wx1PPSRtEc+WvAItTocHFmdpWnKJHyeuwKN2LpqRMLqMdyaB9pkOcSXfVVNm2omV4dacwudwIZv0bnxSkC8p0Bb0vR58uyZVfUo5nuK0Dpw/J/htyEPeGwkvb/efO+/7yW1HpEfCpKt893/4r8Ivddega1gPc7+DUiBG6DrN+CxdhASGXTXSDEwkTbCUo7QrPsGWQSwYpFmyL/tmXXMyeHAy8JdYgtpQvcIgFyHQQwwx9khBzQ+T42Lxm8ej+0ZNOYE3G4EdtRRQCth1p59c7s6UQFqAavj4aiI/pXhG8hy7c6Bt54SJLrVdy8ZDrBi+sYLhwDzqlfW8hD+i3doA4mYTGzEj50jM2Kw5eVqvQhH//FSQnvNWJRHfERSAXrdUNkvc+eKsWD8IEahKcx7RpfRIWDOtIREnsyjW30COgKsXSIpUzQPsaBBBjXz8o6YsV+GDz0SVB9XvjllD3Y531XTJVF8o52mzJifSwmGIy9T1/y4EAF95T0+8/aTasrEjtsmGvEnLt1yDfy3I3Uie
 d6qWtFn2
 zRQLuG+v1mEyzzexhhpcKiuntaZJ+KgO57WBF+DJFLFNkPw88TcuU1OTGQUIjDaS1V/oVokqf4QCsMXbhw48sj60WItsATf+7AwVRn9hTc138n7eH7mFyzs/jkMhH6d/Q1NXvbchrfAxsueZvdWfMB9VykWqPo17oISmEtVJ8U28m7pMJGJr8lsWMsc49YMPrE47YFy8s3fCv9Hgxs/CCiI/JiZY5Om/r46BjxD54EsNXEVk8o01wrL4E70jGClSQ2Ija4dLe3AH7cIQdS8O2IyLsbPxTG8pFZzpPy41z6Ts5uXsoIXOpAM1e+auXwju/qKxvy+UVAOhOsqZ9YGk1XQpyvGlqe2hjPcMuHx0lPgKzcEKdRDl8sY8IVpB9ayT8Ij3H/+fFjqTgZ67f+khbBUhnIRFtfStmQ/hPs3PObIkl63ZyzIeSiSAR3biRhosmDqwnapqRlDFkUqgNrTV/Al+L6jcqSHEypXPGcxu8o3exKTKjem4ba+TwqKykGXddwWZ8CWRbRc+BvOLgIjX69vkUiyq5krSzhgR0y/56U7doVDIW9FdsQrAh20Jkh1wVpTgpGEL37U+g/lsRsDwZq/0fjmi26nBD9YgUiUVEbyyjEVyah9Yvx8JN+ntSgG0TdPBu5RCsj6T1aykmU2YGdqPZSCL/7b2tUW0vEfxJzGRO8EIPmSsXmM7sdCLRul/T91gYWFVGO/1tQbcZCwrNnPtmgDczdsa9qp5+nVrSnLgXg8/lzSecO7D/iQNKcoIVUG1+H1IwsKtuDPHGus6UG1a11MbFxJSUQh1YTwngFg1TdkIOQ4Tihn77ZJkhzF8Il/Y0gzeUdbVj1ToaqNHzmgtQtPAP3p3W6lqGxWcJBlj2OglYaTvk7jwZh0kVA4u++lO2t0suVpWTPbUQwaVFpzNU6aNMrj6jAGjNXQhM2R1OwwE22ayUjSdIjS7anMm2PjVz0htT1F4AAooZaOCyL9REMiQZ
 /y2Um+oB
 rb+NUHDUo/x4Rweh/7pgub5LDBxESNV5QCzxBWWjkP7qol4Gc4Ej4RvavBz2GgnAgqpxvf6D5wLA9xpMwgYXjwpn8or4Pcz6fju/R1TuORraelK2UPjptPuWXWw+xnwX7bixYUrZbYX4B+v7MvNNfXOyvJQ4PP/10SSXalF8E6lwe0ffQXc3r/AIQhxIFgL8JE+Ht6prBvG90cNUyPnjve+SNdu+ZZCEp7vbsdJFbNJEggFJYP04f8BJBc3RmqEwJJIOacxCNQEpwpmzQMK+bZtqgyOakbBiapPCyFT6efOO7F722kVaxe3Hx6jgn0s4UQAs+apwG/M/QILdbE5I7gU//A8EImWJgH39nQEeNGnpZ1BjjWNv3xJqkTrSzG6TsaU51Wi0XpD2oWiZR7hUD1NUm+vW4/eUyg+AUfXu/mA9TlDIMBac8LUoqdv1E+JmhN6a+7T9LDESiobJwLVdcU9wTprWK9YGkTlm6jaE2t/327p9ua5F4Joqf+O7b6XQ7YetTzB4L7IPPLOp4SkFtxOvEvLeJp9miJOKJIBnOPJYH+A/Cx/W7KVD5gozrWEUqXMnRXUiaR2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Be consistent in using vma_start_pgoff() and vma_end_pgoff(), which clearly
indicates which part of the VMA the page offset refers to and aids
greppability.

This is part of a broader series laying the ground to provide a virtual
page offset for MAP_PRIVATE-file backed anon folios.

No functional change intended.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com> # for kernel/dma
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 kernel/dma/coherent.c      |  7 ++++---
 kernel/dma/direct.c        |  6 ++++--
 kernel/dma/mapping.c       |  8 +++++---
 kernel/dma/ops_helpers.c   |  4 ++--
 kernel/events/core.c       | 20 +++++++++++---------
 kernel/events/uprobes.c    | 11 +++++++----
 kernel/kcov.c              |  2 +-
 kernel/trace/ring_buffer.c |  3 ++-
 8 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index bcdc0f76d2e8..2d3195eb7e83 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -236,14 +236,15 @@ static int __dma_mmap_from_coherent(struct dma_coherent_mem *mem,
 {
 	if (mem && vaddr >= mem->virt_base && vaddr + size <=
 		   (mem->virt_base + ((dma_addr_t)mem->size << PAGE_SHIFT))) {
-		unsigned long off = vma->vm_pgoff;
+		const pgoff_t pgoff_start = vma_start_pgoff(vma);
+		const pgoff_t pgoff_end = vma_end_pgoff(vma);
 		int start = (vaddr - mem->virt_base) >> PAGE_SHIFT;
 		unsigned long user_count = vma_pages(vma);
 		int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 		*ret = -ENXIO;
-		if (off < count && user_count <= count - off) {
-			unsigned long pfn = mem->pfn_base + start + off;
+		if (pgoff_start < count && pgoff_end <= count) {
+			unsigned long pfn = mem->pfn_base + start + pgoff_start;
 			*ret = remap_pfn_range(vma, vma->vm_start, pfn,
 					       user_count << PAGE_SHIFT,
 					       vma->vm_page_prot);
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 4391b797d4db..436310d6e4a2 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -534,6 +534,8 @@ int dma_direct_mmap(struct device *dev, struct vm_area_struct *vma,
 	unsigned long user_count = vma_pages(vma);
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	unsigned long pfn = PHYS_PFN(dma_to_phys(dev, dma_addr));
+	const pgoff_t pgoff_start = vma_start_pgoff(vma);
+	const pgoff_t pgoff_end = vma_end_pgoff(vma);
 	int ret = -ENXIO;
 
 	vma->vm_page_prot = dma_pgprot(dev, vma->vm_page_prot, attrs);
@@ -545,9 +547,9 @@ int dma_direct_mmap(struct device *dev, struct vm_area_struct *vma,
 	if (dma_mmap_from_global_coherent(vma, cpu_addr, size, &ret))
 		return ret;
 
-	if (vma->vm_pgoff >= count || user_count > count - vma->vm_pgoff)
+	if (pgoff_start >= count || pgoff_end > count)
 		return -ENXIO;
-	return remap_pfn_range(vma, vma->vm_start, pfn + vma->vm_pgoff,
+	return remap_pfn_range(vma, vma->vm_start, pfn + pgoff_start,
 			user_count << PAGE_SHIFT, vma->vm_page_prot);
 }
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 4fe04669e5e6..c986639044e9 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -761,12 +761,14 @@ EXPORT_SYMBOL_GPL(dma_free_pages);
 int dma_mmap_pages(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct page *page)
 {
-	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	const pgoff_t pgoff_start = vma_start_pgoff(vma);
+	const pgoff_t pgoff_end = vma_end_pgoff(vma);
+	const unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	if (vma->vm_pgoff >= count || vma_pages(vma) > count - vma->vm_pgoff)
+	if (pgoff_start >= count || pgoff_end > count)
 		return -ENXIO;
 	return remap_pfn_range(vma, vma->vm_start,
-			       page_to_pfn(page) + vma->vm_pgoff,
+			       page_to_pfn(page) + pgoff_start,
 			       vma_pages(vma) << PAGE_SHIFT, vma->vm_page_prot);
 }
 EXPORT_SYMBOL_GPL(dma_mmap_pages);
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index 20caf9cabf69..6b5f9208d31c 100644
--- a/kernel/dma/ops_helpers.c
+++ b/kernel/dma/ops_helpers.c
@@ -39,7 +39,7 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 #ifdef CONFIG_MMU
 	unsigned long user_count = vma_pages(vma);
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	unsigned long off = vma->vm_pgoff;
+	unsigned long off = vma_start_pgoff(vma);
 	struct page *page = dma_common_vaddr_to_page(cpu_addr);
 	int ret = -ENXIO;
 
@@ -52,7 +52,7 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 		return -ENXIO;
 
 	return remap_pfn_range(vma, vma->vm_start,
-			page_to_pfn(page) + vma->vm_pgoff,
+			page_to_pfn(page) + vma_start_pgoff(vma),
 			user_count << PAGE_SHIFT, vma->vm_page_prot);
 #else
 	return -ENXIO;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7f3e2c2ecb1..44a092db5d58 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6998,7 +6998,7 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 	refcount_inc(&event->mmap_count);
 	refcount_inc(&event->rb->mmap_count);
 
-	if (vma->vm_pgoff)
+	if (vma_start_pgoff(vma))
 		refcount_inc(&event->rb->aux_mmap_count);
 
 	if (mapped)
@@ -7032,7 +7032,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	 * The AUX buffer is strictly a sub-buffer, serialize using aux_mutex
 	 * to avoid complications.
 	 */
-	if (rb_has_aux(rb) && vma->vm_pgoff == rb->aux_pgoff &&
+	if (rb_has_aux(rb) && vma_start_pgoff(vma) == rb->aux_pgoff &&
 	    refcount_dec_and_mutex_lock(&rb->aux_mmap_count, &rb->aux_mutex)) {
 		/*
 		 * Stop all AUX events that are writing to this buffer,
@@ -7190,7 +7190,8 @@ static int map_range(struct perf_buffer *rb, struct vm_area_struct *vma)
 	 */
 	for (pagenum = 0; pagenum < nr_pages; pagenum++) {
 		unsigned long va = vma->vm_start + PAGE_SIZE * pagenum;
-		struct page *page = perf_mmap_to_page(rb, vma->vm_pgoff + pagenum);
+		struct page *page = perf_mmap_to_page(rb,
+				vma_start_pgoff(vma) + pagenum);
 
 		if (page == NULL) {
 			err = -EINVAL;
@@ -7344,6 +7345,7 @@ static int perf_mmap_rb(struct vm_area_struct *vma, struct perf_event *event,
 static int perf_mmap_aux(struct vm_area_struct *vma, struct perf_event *event,
 			 unsigned long nr_pages)
 {
+	const pgoff_t pgoff_start = vma_start_pgoff(vma);
 	long extra = 0, user_extra = nr_pages;
 	u64 aux_offset, aux_size;
 	struct perf_buffer *rb;
@@ -7366,11 +7368,11 @@ static int perf_mmap_aux(struct vm_area_struct *vma, struct perf_event *event,
 	if (aux_offset < perf_data_size(rb) + PAGE_SIZE)
 		return -EINVAL;
 
-	if (aux_offset != vma->vm_pgoff << PAGE_SHIFT)
+	if (aux_offset != pgoff_start << PAGE_SHIFT)
 		return -EINVAL;
 
 	/* already mapped with a different offset */
-	if (rb_has_aux(rb) && rb->aux_pgoff != vma->vm_pgoff)
+	if (rb_has_aux(rb) && rb->aux_pgoff != pgoff_start)
 		return -EINVAL;
 
 	if (aux_size != nr_pages * PAGE_SIZE)
@@ -7400,7 +7402,7 @@ static int perf_mmap_aux(struct vm_area_struct *vma, struct perf_event *event,
 		if (vma->vm_flags & VM_WRITE)
 			rb_flags |= RING_BUFFER_WRITABLE;
 
-		ret = rb_alloc_aux(rb, event, vma->vm_pgoff, nr_pages,
+		ret = rb_alloc_aux(rb, event, pgoff_start, nr_pages,
 				   event->attr.aux_watermark, rb_flags);
 		if (ret) {
 			refcount_dec(&rb->mmap_count);
@@ -7457,7 +7459,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		if (event->state <= PERF_EVENT_STATE_REVOKED)
 			return -ENODEV;
 
-		if (vma->vm_pgoff == 0)
+		if (!vma_start_pgoff(vma))
 			ret = perf_mmap_rb(vma, event, nr_pages);
 		else
 			ret = perf_mmap_aux(vma, event, nr_pages);
@@ -9884,7 +9886,7 @@ static bool perf_addr_filter_vma_adjust(struct perf_addr_filter *filter,
 					struct perf_addr_filter_range *fr)
 {
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
-	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long off = vma_start_pgoff(vma) << PAGE_SHIFT;
 	struct file *file = vma->vm_file;
 
 	if (!perf_addr_filter_match(filter, file, off, vma_size))
@@ -9974,7 +9976,7 @@ void perf_event_mmap(struct vm_area_struct *vma)
 			/* .tid */
 			.start  = vma->vm_start,
 			.len    = vma->vm_end - vma->vm_start,
-			.pgoff  = (u64)vma->vm_pgoff << PAGE_SHIFT,
+			.pgoff  = (u64)vma_start_pgoff(vma) << PAGE_SHIFT,
 		},
 		/* .maj (attr_mmap2 only) */
 		/* .min (attr_mmap2 only) */
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ac340a703d06..ae2f3b9f8d50 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -144,12 +144,14 @@ static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 
 static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)
 {
-	return vma->vm_start + offset - ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+	return vma->vm_start + offset -
+		((loff_t)vma_start_pgoff(vma) << PAGE_SHIFT);
 }
 
 static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
 {
-	return ((loff_t)vma->vm_pgoff << PAGE_SHIFT) + (vaddr - vma->vm_start);
+	return ((loff_t)vma_start_pgoff(vma) << PAGE_SHIFT) +
+		(vaddr - vma->vm_start);
 }
 
 /**
@@ -1482,7 +1484,7 @@ static int unapply_uprobe(struct uprobe *uprobe, struct mm_struct *mm)
 		    file_inode(vma->vm_file) != uprobe->inode)
 			continue;
 
-		offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
+		offset = (loff_t)vma_start_pgoff(vma) << PAGE_SHIFT;
 		if (uprobe->offset <  offset ||
 		    uprobe->offset >= offset + vma->vm_end - vma->vm_start)
 			continue;
@@ -2453,7 +2455,8 @@ static struct uprobe *find_active_uprobe_speculative(unsigned long bp_vaddr)
 	if (!vm_file)
 		return NULL;
 
-	offset = (loff_t)(vma->vm_pgoff << PAGE_SHIFT) + (bp_vaddr - vma->vm_start);
+	offset = (loff_t)(vma_start_pgoff(vma) << PAGE_SHIFT) +
+		(bp_vaddr - vma->vm_start);
 	uprobe = find_uprobe_rcu(vm_file->f_inode, offset);
 	if (!uprobe)
 		return NULL;
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 1df373fb562b..b19b473c366a 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -512,7 +512,7 @@ static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
 
 	spin_lock_irqsave(&kcov->lock, flags);
 	size = kcov->size * sizeof(unsigned long);
-	if (kcov->area == NULL || vma->vm_pgoff != 0 ||
+	if (kcov->area == NULL || vma_start_pgoff(vma) ||
 	    vma->vm_end - vma->vm_start != size) {
 		res = -EINVAL;
 		goto exit;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 56a328e94395..dfa493d54ef9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7613,7 +7613,8 @@ static int __rb_inc_dec_mapped(struct ring_buffer_per_cpu *cpu_buffer,
 static int __rb_map_vma(struct ring_buffer_per_cpu *cpu_buffer,
 			struct vm_area_struct *vma)
 {
-	unsigned long nr_subbufs, nr_pages, nr_vma_pages, pgoff = vma->vm_pgoff;
+	unsigned long nr_subbufs, nr_pages, nr_vma_pages;
+	pgoff_t pgoff = vma_start_pgoff(vma);
 	unsigned int subbuf_pages, subbuf_order;
 	struct page **pages __free(kfree) = NULL;
 	int p = 0, s = 0;

-- 
2.55.0


