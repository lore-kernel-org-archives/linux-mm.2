Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B06606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLeOYJRj
Received: by kanga.kvack.org (Postfix)
	id 26B3C6B05B8; Sat,  7 Nov 2026 15:10:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21BC26B05B9; Sat,  7 Nov 2026 15:10:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3F06B05BA; Sat,  7 Nov 2026 15:10:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA0416B05B8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:10:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A398C01C8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:23 +0000 (UTC)
X-FDA: 85409415126.03.F0EF6F1
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf19.hostedemail.com (Postfix) with ESMTP id DDFDB1A000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMFxkbGnr/NpLAXZXk8rbwy5EGs+66IVJk9lKIVoNp8=;
	b=SzW56T/+sVNl+rDk3HHfUEQwRF1TKDrnsHaAWPdfPhiYTh0JV8+EZY527Qsw7bUdXimeS6
	c4CU+U0Sb93F5AdjgmCMb+T5lSdHyww5lDQ/1AKAJtza7BamG9hy/YA9AB/ZwySFkk0zUg
	TmMknzaCyGwWwZ53KGhQyGh3ZOSYfE4=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794082221;
	b=GBv0p4kN9F9kP1b/BvrHJGi1TfyaSFOwqoLiJIU83vnMIriRtUgCBdMtSKPisiZzYlFFMg
	zfdmLCjxrfxgNL2xqgo+1lUyTwl+REiTPbabMheE6O1X39mHW+9vi8DbxFZvvWgxxf0JUs
	P7cU06fjPqGuc1N+5gWs9pArnRU8C9I=
ARC-Authentication-Results: i=3;
	imf19.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B36940229
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:20 +0000 (UTC)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DF261C38F0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:20 +0000 (UTC)
X-FDA: 85409415000.08.C95296C
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4247E14000B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:18 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMFxkbGnr/NpLAXZXk8rbwy5EGs+66IVJk9lKIVoNp8=;
	b=vXnFD865N5fquUV9mBePDqF7KtL7WmewANcRWjEtobNB4Ryr4h1afcs9UsvHUlaHGJkKjI
	hqBQlrOZs32M6n9H4GYnWxxwiGyP38Ls84ZPPLSMT+K25mjZVYn0Y0GgXDMtPVA8q5lrrj
	7HHJmvfgTAdZgrSE28bkhle0LHNd7+I=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794082218;
	b=islo/5R5+dQTGvnrvVfgAhvLLvLBcMyhslNNapkndnrdueNl75lQl2h6BKcWDqZQVSIyQA
	L+K7D4UqVFqfnIsk+udF3wwTom52Dgp5mR1cAZX0LaX2+C4jP95sP9XwdgQ/GCxumY9i0s
	PyDn+Glw+TlXfwUTrmrr3OExcfgd8Cs=
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D75441403BB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:17 +0000 (UTC)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABF1AA75FC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:17 +0000 (UTC)
X-FDA: 85409414874.09.F3F39C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1C465180008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:15 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794082216;
	b=ifMHoYZ6/4F8kbIGHOwrEkmw1kjj+LimXrW3rHotcmjUEJv30UwVRaYelHntQPpcZ2NtvN
	W4K4SkK6qk3hrqqmmp2ptC7oHHm0VVuqz2b9AYR5SDvbu3wMJD2dyy8MrEDUOmKcBDAHRu
	b0tIGysU5MSWQGr7le43J4MINEEZGEY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLeOYJRj;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMFxkbGnr/NpLAXZXk8rbwy5EGs+66IVJk9lKIVoNp8=;
	b=vwbWpRTo1UqiPioAkSb75fa2yGOlkTvh2AAtyajg/G5nQOBHdnf7kQZ280gzwgzTJscdVA
	xnfbmv6tSZlrnQn8k32EnmTsbz17o5FfNxb2frAlt/bx6obMo/r4aiahcBlJwXuyMEYyU/
	3CRF44bggqS9fsb+uLGe4kLuYuDxqs4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A843261189;
	Sat,  7 Nov 2026 20:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D661F008A3;
	Sat,  7 Nov 2026 20:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082215;
	bh=CMFxkbGnr/NpLAXZXk8rbwy5EGs+66IVJk9lKIVoNp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iLeOYJRjjnhZl3LWMSGaUd1S27vEBJh9NrDzelAqlZmg4R2RciRfWoeIsojODwzqH
	 AmV3EGrrSvx70iXnLVmV7/bs2dBDE1x/r3nyPcxADmxBtch4xZP+oTaqLUfx+eYAuG
	 SGRWdAxli2sYIZwe/Tbuw0udh+c0QNfiwmJOXLSfQKYp1etxVNRgoDq0IPlAd0lt9t
	 yDMA0BPoIWju9BFMAW7mO+dutMm2GHuzj6pjWBP8PMNdT9kLO2lCpBJij+NhIf7LIF
	 N/2SXcwPj4meyprPc8KlcX/gZ5yZ2cdhj422kyiEPIrnEjIKnHoNmFfhk++nuATcLn
	 UZoP1hyr/4Jww==
Date: Sat, 7 Nov 2026 20:09:55 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, SJ Park <sj@kernel.org>, 
	Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 00/13] mm: continue vma_flags_t conversion
Message-ID: <au-DXpEi4wHwsz0r@gremlin>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <d0ea7929-7c12-4245-ba3f-6dd5c0269e6b@kernel.org>
 <au3r0-geuwtRYPiC@gremlin>
 <1c0b1368-a381-4b25-bba9-7a4f8e92b764@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c0b1368-a381-4b25-bba9-7a4f8e92b764@kernel.org>
X-HE-Meta: U2FsdGVkX1/9XazHZhF5QaqY9LsPt6Q0doPjxDuMYrPQlqcARgbwlDxJ9/bBTquVnfZMZ2mw/YKgmKkg6HsYHmz71DAZA+iQSFKvTopa5KGRjydjy5aYnVMkkeyBeAVZluBZ9JFakFDMgCTZOdz7oyFf6g3tlyjNR9jWMDhAxii7PIRjUOEaaLkaJRkhAldQAlQ1BryZQSR1t4aAD+S4LTv85QOgMDTyxMDWTb60PGIvAps7ILEIeChdSzl5mvLDxE1Qs1QVlj949lNa6Lxf2dEZktJdJV5rR5S4hrWXsf2LRI8AgreSvU5G9Um7eh58irL8wEMF88mleGkZwYzPu16Td/J5Sh5wDJAzNFXPdB1lPpqVdHyqAZaBOa4iRx6mfjuhK19W/rYOsNCu2c2Cc+FpxTVhp53LbIiSjVWXbpqDCN81eQA0AohA0A8L0SJGDFc70cduCfoXs4jVswj4QyHreO/sjH2jWIz96G3azl/ULzFwmrvaTIQhxNszsB3BDFpLJNPZNxnzdqeXGn0e4N9KiH4HyKyBWChRftSoC0hVdeKo6SCtpzHC5nGvx10kGkAVAdUULI6vjDwql6CboQ12rRbtWR5g+7FCM1wpaslAd/B265pEkUdxUd1zvQz/o/Dk2yJy+PK9Y9ZWzfNAMI+DcKB0pc8GMeoMRg+IbPWMGtNi5SS7eLM1tMXVVX5srQbj2E/WfVlCXVcbf+crzxtJ7fqgC2UKnHCyI007k+qJ72I29DFdhjgTv/qHwSFoEf/PVlsBpm8EE4UPnOyELHs+kaOa6lD40JRppTQUIgBSQlWMjx0BRG7UBY1RVsRNcOC48DQk8CdCbBxxFP7205AkJp4fLkGjrK4tDgeSZpBc4uL3Q+sucOUG7o7PEAhBEq86YuLngn97sQnM3eFc0tWkvCWjfJ4E09nBwNZ8VNnKUgOkesQFVUOoi/M1A+yBOULsSw84BOl0YzDfMv+
 58tPDYId
 fdSSQzXfzQT/P1yuiGTrf8LhrY+0X7enM7JlbO0kGBzuw54iysXq24rTAxAwObRhGz/neTTIMSI5Cjhf1msZhBHckXy6OyFTZewNBcsxV2fAW4RK8ZR+NEHQtwCHK/fQ042I0yP0XjWsMMr4WyrWyjYbN8vUp0fRddijhpFAPS+neOebNF3c99sT8HVxtBjJg152wGLgk7/x3YR6BxyCYA956lgWw2FwuhQgLAcvPSWv+kPiSKFDnvtjL7TAIzXeeik6iTA/Q/MafTnI9U9E0HwvhTwk8VUwpYSxMUhFrmPrIzfmkKpcPRlk7CDqq0Yet/H3VAKahi2M9DueRcqtQm4GoAz5glldPWV7EnqSs7//cmUw6YmwceylK1w==
X-HE-Tag-Orig: 1794082215-828105
X-HE-Meta: U2FsdGVkX1/fF3qSDLnmcdO5kxTvL90HBknHLTOqAkwBFIvo1BCR2PMfewrYc3c7QYczUxNCz1FjMkgQl6w8/dmBKIgJBxNHMtlwtOmOJqyqB7YY619EkijK97x0nINkV6XVqMuh/Zvi1t/MZF+af1qzJXm1hWo/9H+HVpHfWswH0cIKop3+Ny5a51ZZT6RlixuhvTxpClMKxL1fJOdtxnNlRDMZAHBcyp2f3/3uJanEZnw7AO1nepj44OyL9llAdeLGwvfLxnjTQBc8B/iOehTacCCdNjWgBEAAO6Qs9fh8KLxsVN4Dxcp5rJCMhKnHQY+qvXoEKto+cmuTwOw1YmPXLrjv8Qhjf6kcjju9F7pqoh4K/TIM5Uux+oN4qZJhtT1gyjjuppYTTkORzJ0glJyAL0iQhEC6ue7MVhnzwOtW/d++H3umus5jQIP+Hl7LqEYxaLz2/ceJa3TTU4oeYArsFhaV9ULsiz8s9gJf9BIfhCyQbKEo977lxtct1eqQc9yvVfUrfPI0uxVUWR8mKBXmbL09PyslnLS0u6upqZkayRh75BHCNqoM1Bw9rVuHljymWDHgiEf/r9WQ8i5F5POLClywNo8A1OtGxVbQ873JWDt+xSLQ8dDwPHxvl/B1zY9MLzmrxEO995sDAvjJkb6Klgx3X4eoJ4Oth0zTTX6mEGz+fuGw3HnQaEiZOnDmNncbZ10CeoPWBWuXr6W15aCvbeOLkKf9BBmivh3JAmWmbaPKQLQHVLfw3T9YZoAkER4j9dN9lwmng1fH9jnTFQN/bDKL3IydjdD487lMdDHCEX+U79H77fEDnReYhwdvr6TdHjZH0JffnvzBZztu4yRbWH4WUzlda2sST+kBnJ4D+l0LNk5jAJvGCWANnS0/LIQ3sncQuw75YRk0kbm4h6u8jCsXlVhMOVPmS1+8po15ODGgVGDlBqulqW2YRyaEeeRlyZA+ds8AfuBzaoL
 wg0sWeeS
 OpyYN60iRfg5RSY9pIWneR57N6+IhYUdfx63RiEJeaTn1oP3p7Y6Bmu6T2MhjfbjuBOsdoLLcUrTZRH83DDe7y69hm4Ntn4QISdNxrMo1f5wPCa90lq6AU/jTsg74VyUPrFIiW969WroHcanm8ea0HXaaeqpaDlRD0AKNFWuBJwjPLB62jUCKuj3+p90gRJEohQKx74uAtewOK4Jux3w7nkogUaZyjOQswz1jAmrZplNMpwvj1X0uyD1ugAHUgoEXJ7D/xJPXUZLIvPPsLrQL1LK4B1SViRxXE8oGne+1T35OSpZZPwb5o7zVYph6MAw3T/xR1annIzJiKrvNqnxiWPi2xJqrGQ1Wk0V4zkqzcRJiOlu9oiUQeb6WTYSG1F3ocABySI+knZdQVaBDtEWxY0nMzQ==
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xta9ihiqqreayswsz184gfocn99rstxo
X-HE-Tag-Orig: 1794082218-16289
X-Rspamd-Queue-Id: DDFDB1A000A
X-Rspam-User: 
X-HE-Tag: 1794082220-92022
X-HE-Meta: U2FsdGVkX18b8x8tMERf+tC9eRCtQgvtxsrvU6Gpe6axBLL9DES7jnYiIUc/PtzXXLURFsTpUfWJsRiQiOY0tv6TSBqE5ZYozi78fz0i74NoMFLMGTKymjR2zH+3rFYXmJQzstqShmIXEO+QkEXbGHXKBJh0Lqk+iM3U9txaiMbuLOEA0jpg/OYh7EYNmbpxvUO+bep14VPwOH1Y6UQCY+fHA2hqkkABP/Gj/9DNY4vhOSRZ2hbIB68LqQDsPNK88LIbExQtNLGvHeFZp+7937NYPIpnO/Z0rqbE/ZjlhUpa93TnUQvSOpDJ5FCDUxRTTe6x9y4x3Woz6F+IkJwrb1m83Aql6Ky/dCD94FTLB3nH5DFAff9YVaaoS0yJtJ3x/NS6tN9cQgwzudnalbba31zT6j7cBnmU6W6/VxNYulSd7yLEsV23NJjbeSlhcLcPsvvbLAlwhgPxtTfaHJ3HfLCZdUzHcxXoRU5FvHolaCum5qD+1ybsxsJqeST7FT3IQhfXdwlGUV9j4oXuBjuZzxbxKSn62RY2Fzy+DFp3BbAx5CZSmp04rX+qrfy+lWjDR8wJs7VDCycMw+fXBqb0SCrwQKvajhhQZIuNmM+gJ0ZdVtOQFEDhrHhqsHfW0KuaD4wOCT4/P4vWG+hD5PwvtG/3VNIjniF9L3tgIpCyGru5etCpKGKqcAtFe12WIUxBecuFg3dahvEr30Bhf2xjTcWv0Of9cL9d+l32HafNw9vn9i//1szK7AI3MeazApz6dct+HDJ1r/n4zcdEKWnD3LqywAI4rdFsRjZ5dfESfLBDrXShM6GmWgdGWwSbih5t8WrfWvOlHXwVeft/G6NexSd9tsoC5To2xbXFqSoQ0x8VD2N4kOhdgIG59e0TAikIkWWsWik6mnvvg6kGOlOGSGA4OIuoU29I8pTvH7Nh9i8v7cXFvRYxKX7gM2PRtxAJRYrsrZRlY2EkJQVhjY6
 0Bd88drv
 qQuWDJldRYECHTkfVNcEb3/XQwgPG1dnSsH8Tpri86xIxelnw4n+xb0h8eGgonOHpxI7HxjAvZi38KvnlXVizwACy2jQ7XnGXKPKEJjdGhVJcxp2syz2dbkLOaY1vuGXVzylOI6HHuH8DapjjZW0lC5Ok9Xozh2mQV0hC1eaWIJkE40BaDUcRPq/RKupQPWHArmJ37qZXWaVPQNDqFk8bSX/5aZR2EofgFp0lpwIqgX5QlVvPDVIysJjS7sUvaTe9gi+qtPcdBoeRGHcYkfmn6OMvlrSBfNFdbFM1g6IDSigkHud6VgKTHHyjP7dCQBPr6HDywI1JjOS2tJathq++uC6oD3rXyPb+XnHTD+QCtHJ0RXTQ0EeoZ51UZTGKxIWKffGVBibcScmb+6IGOADz/1JNLbzXVyynpR8R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I think we're slightly talking across purposes, so to be clear - I am totally
fine with you taking any of this through your tree or whatever works for you and
Andrew to avoid merge pain :)

I was just talking more generally about how to merge series that touch a lot of
subsystems and maintainers-who-may-never-reply, etc.

These are the edge cases that make things... fun :)

Anyway, I guess easiest resolution here is for you to take the bits that belong
to your trees and Andrew takes the bits that belong elsewhere?

I don't think anything here has an inter-dependency.


On Sat, Nov 07, 2026 at 08:26:29PM +0100, David Hildenbrand (Arm) wrote:
[ ... ]
>
> Because of [PATCH 05/13] mm: convert THP VMA flag tests to use vma_flags_t which
> is THP-only, and feels like it could go straight through one of my trees,
> avoiding conflicts with Andrew's tree. But maybe there is more to it that I am
> missing.

Sorry about that! Please take that through your tree.

>
> I assume stable topic branches would fix that, but they are currently
> unfortunately not on the table ... :)

I guess we need everybody-on-git for this!

I guess when Liam and & I have the VMA tree we can do that at least for stuff
that goes there :)

>
> >
> >>
> >> Ideally, patches really only touch one component.
> >
> > Right, but sometimes functions are declared in one place and called in
> > others. It is impossible to change the signature of one without also touching
> > the others.
>
> Yes. Something like that is unavoidable. Or if you need new APIs/

Yes.

>
> >
> >>
> >> [PATCH 07/13] mm/madvise: convert madvise_vma_behavior() to use vma_flags_t
> >>
> >> is all over the place :)
> >
> > It's not really all over the place, it's converting vm_flags_t to
> > vma_flags_t across madvise.c, which involves changing a few function
> > signatures, whose callers must be updated.
>
> Ah, yeah. What on earth does arch/powerpc/kvm/book3s_hv_uvmem.c do with madvise :(

Yeah it's quite worrying that... :)

>
> >
> > I could split it up into 3 patches where 1 does internal-only, one changes 1
> > function, and the next changes another, if that works?
>
> No, these things really have to go in as one unit, no need to split that up.

Thanks, yeah, it's a pain I know but eventually 'one fine day' (probably in
2028) everything will be converted to vma_flags_t/mmap_prepare and we won't have
to think about this :P

--
Cheers, Lorenzo



