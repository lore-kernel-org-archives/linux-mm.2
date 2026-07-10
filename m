Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93477C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FDE56B00C2; Fri, 10 Jul 2026 16:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADFA6B00C3; Fri, 10 Jul 2026 16:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677406B00C4; Fri, 10 Jul 2026 16:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7FF6B00C2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:27:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A713A1697DC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:27:13 +0000 (UTC)
X-FDA: 84974001546.29.6342C09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF1484000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:27:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drJA3TiK;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPE+/P9KdKkfiafscak8Qeedwgljtr0X+OnR3tsbkh0=;
	b=UyqQNkLk+44PPi/DCgDWhCAeUKGQyvJTjooBo3uKkegg0PdB1mTpfuIlrSMdSBRf5CHWnK
	VH0ujM2zhv7Vs+aHaKlgin0vB3Z4SL1BlPBWvlkTLsA90VGHG0FdxGMC9IlTOVEjXfcv1D
	CkB+WyRHo3CayJywxUmXS6g/Pj+j1O0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drJA3TiK;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715232;
	b=IIlRxYvLxQo+xqvxs70CPBz/AAd29gkXsUskjuX+YuMbmi0cwwRq0+H3mhNPHAbyTpq/5E
	4caCzZKOmr8BtdwYJDJhuAd86SBpqIEnHekJxkFPKG2AXEpwVgDgYYUqVCT+M7QfuyHe4a
	vEyhn3GPy6fdsgRb2JGrAMFraJiLs3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 025D240633;
	Fri, 10 Jul 2026 20:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F841F00A3A;
	Fri, 10 Jul 2026 20:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715230;
	bh=IPE+/P9KdKkfiafscak8Qeedwgljtr0X+OnR3tsbkh0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=drJA3TiK+PeoZ2nu79QhphTfcNqJcaVpJ8OrZAJ/WiBLBgSuNTzJICprZt5FC4O9S
	 3h2HjqlXf6uHYTGH6HKtyVkmlM9tNpsnzlHgJ8SgIXhPRwO8Mxflc7CI7u/LnJl1jN
	 o3Y/oZKScReVzOIjwXvsQpQsUhs+NzRIePHqBDAniSxzca3Wp2d9hKCB6EFAc6Ena5
	 9eifILN5EaHhUs5Jl8ljfGagLXkvH/vjQc/WrufaW+JVZZLpI6hJqNBN9v+ubRWI+D
	 f8OFGl0Cv9BKeEGVwh9lipVXptpUW5ZjL2aUnSqMgN5SfwTyhiP7bXRjj2XwzYCTtx
	 851hK/6GxFGqw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:17:06 +0100
Subject: [PATCH v2 25/33] mm/vma: make vma_set_range() static, drop
 insert_vm_struct() decl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-25-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3631; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DYBIxKjyIjg2H1S6yqXRCrIrObFnJroA9O36yuI28hY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg22X7tsrcNZQdubGGY8ZeW1e29V7zlxxOK3+cPbOG
 WeF5aVsOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR14YM/9R8K5NV5Y2MWF6c
 vSte8e2PzcyIgNeTetd93BU5Q92s+h0jw6WMAI+VUk1/mc91c4Z2cZ/wmvv59r+qxuBd6nsvamy
 S5gAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF1484000D
X-Stat-Signature: ew58i53bnhsufd8fnytr4nzs3swy4u86
X-HE-Tag: 1783715231-825218
X-HE-Meta: U2FsdGVkX19IwarxkAaVe/O0kLG6zC4kPTv4DKtLY6BD6AxhL4cYv7qlhT4wC/H3s9NLYUOjfX+wLJsN3qAhiK/KFeQC6TrNMkh5G8yl1bTvvk5YT6Kn5QcWr78UKAl3kxC0gnX2JL6bD1mrhkkI7zuphDCzVUOzw+4UJw0xQPqBB/XIQn7Moly9ICjdYzOyRMr5jFS3W7WiOP00F6u+6n3Us3nnLOlirR31OPNcghZP4qre70g6LS932j2i0XHTbapUBSUfu/OIKXF1FHxDZ14y3wwaDcDDFGp6Xb5KLv3R8/thKz5/L2QAWk78VJCf3KcoGjpTqzvU1zTb4odXbpY5F3svRYtY1ZzXdXqMjDLBSrp437wjbTiT0jziLq2rJoBrWehLuh+CBl2n5SNdmN5/GtW7jjP+ueLA5RxEVLr3ckEtlRaEA2gayObcNWU5jeraZtVAo6B92abP4Fvow31rAUBp+UFAiYmAEpmIXQs6XIIb3qBuVxSfMrWYWwMPWczMUZEDlpst3DMWxsbTryZBKQGJuSuAqsDue872+OKjuVp89OVRg0iM/34gsyCigLMDoRz7YmG5jdfFdggQelRQb7gOIO72vk1u1e9XDhkwqq55dMRR2tIc7FRbekni+d6jFr0APy21vsV7pjNBhqBHWB5kyzZ+kYPFGuUrwGNaZhizg+tU8dnLAbSXEaC4YfT2PtTzhnFN12JBaRMdbONwk04tMk15MfFkl1SILmFOulCJtqurz+pCeh+HIcLjpQmwtdRhRK6RGDcdZUO9Ne/D1W7F+TLs/RHii4KjBklob7BrPNfcYDMHKJQWV67+0S3fRCB4MsM9EZcBcrv4ieJhrJeWRg5VIqmLv7HqhfVF8lzCfhSjKZTBQf9+xgzCPsFdjYW2usU89SE8IH0R8Jm8q1VmLGusqdVH5yQNI0/Z1U6eeSBOhSeupaKvJWTke58iR3HNg8BA3I74dGg
 Y7P+wfcf
 7r6SKSs/eq0kFPOrlFaT73lcFRl7sylEJmeLI7CIYnjCqRWfQp67QN071Vt9hvxuO7k+AdSSj/nCD+F2r8wctqWWiNauBg1tmPAXribsieJPivC6m5btejtFxeZwSuOkPIhdtRHeAayl7ZZkl15pJOJIo6j5lQsEVrx1a2EgzSecCaWL4RJ0Q7MW+w9pvE2c6MQgl2XQTOfa/X0Ai3stAmhaSuf1B6nHC59+KwraCVYet3mJLzKwTvMytWgzlLiHyOgYcLoxo5Zx35BGeWeke881Gh9R6F95bWbct9wQfV+rryVA6Xi/B7Xo+HdTTtsP20ogF8WKSmzaW5lsHzav4kkBApLTF+LRd9eQ3EwK5cM4Uii8amgIJWMnKitRLG1B0jM9LkMOxCVQD7z3nMlgrjnz7mQQu56ls6RoVLlE7FNT0CEvg5LE/GhB8pqe4B/KhnAMkIvGw7M0iPZSW42hVx2tWg8j8YfILbfJ3M50YVb3bMpFguhIrb6w5KD2uXIz5W1IVOk3zRDilaBTlgLgGhtJs7f+HuZUcgEFoJMxsF2RnfsXwlD27vqNkGbI5LyGll2BfhK4MdA4T0yP/BeAL7zyBhzoJrqDJYkRZ+CAwZlo8t5Fq4IhTViHF79hENnP0FtNhoXpy0RaeCzKT5DlSmLTpFGSui0RBAEYvuafF7kddP3ukIlnk5rj9a2sONLozfGKN5UBBZu3cJ0lBmR5145c9llkj6TOyMsMOgyjWHBmqvPN6ljZDE1AZIcbM0Mwkdsyd/L0rivMaotVaCVmcjPwi7vEEVkJD5sXQaRe1PgEEjPeAM/xBfvLS8mEaNeOlmsre5JK5uxrjHgCZ69yCNkcPGuj0Sglbzgs4mMnNO+MMTJIM9yE8t0I5EOG3J37L1L4lj8sD1cwLrcE2WDEG56Oh6Cy3354bUaHK71IICn56P2Y3XYG0DACWk9R0ypQK8lpPhJ1lBkXUV3JyGOQz4UmA5h6K
 a/MQPkD+
 vc0apRG410hpHfK9abtIsRvkhh27CB1m9hLoEHIRUX/NEcLjx1nYvli/O+lYf+cEvmw2aLO1PfU9fyRc0CT8bOocxv9ybRJtsxTRIso0tjjjnUJERd8NusDuPGLbxic73ly0SW/EChFcrS/+jbpKNa49qYa+0itDADQ0DfQnOLGKLMSow8nQ711nJ5z7Ls+fGmhOgpW/NihCbXiEMpQYaE8/F+Q5dwfk0MKoeGYbTeBRJd9uGQv8wNjCXrRxFSXMOP7xBZqNcx++ny77Mg8OFcnjwp9g5UAUBwfdsW57bhITaNByc5mGl/VcsTd6bNeL1iHowjZHb8Qy2OVBIvZXeMuxIRiutLRK3QzCc4Zj0pcTJVUOJ8RXmVd17f7+Eur7vA4kn7xZcuHAQAngX0QU9AOqOl092agC4ghCLldGK4g2tPvl0qJagACdLZ5y5mXYiKiYadKW4LCF+aj5fIRv9qDo4r0bqjFDbMvXp8y69+mxpgwDK8NfFxkGjFZe/mrVt+MMnk2puNIYBxesOvCgILCmr8jas542HFcxHPgw2drAuArTkZn3tqseUi+2hM5ljTAV2lZpkYJqdZ6F7GUOWQjed97NLnbEjK3L3U0ZZZSvUAcfvU6N+7KbVtksN9VX7B+mxmxUpuLrlclvtIOawStQHJxALKAqUSnaIaOB0nYWCMf+twpkVxqLyehPO1sILzSAbXDLNiJ5UMKKSfr1RuRlo93vgICChG2Xelfwe+6nU+WpWhVwjIZmjybfTv8a0Y8XaJ42IeN0BnWejxcWwM87Q2dbQ0mPtcVsJDhHSGXlIHa9z6PFVvi7Thrx11s8ksX+OZty853vh1MouS6uud40x5wI+DWXlUvMXWomfxdCfphX2FNAlzEGzU+j9nzB7RAcFi1SmKANU3nifj4nedfTKgbAREFDhmvN4p4BCdNeBpFeefbyQFNehXe2Y5NUttsviVe5ni9lKDr77XV0QZ+JWfj5A
 q4THh7qp
 EM8NQjt0UNyaVzNEX2o0c1goWZhPE1SY98FqRa7mZRv13WPgw1W/d/cZni5QpFrUboMWqF7yBv17v07RTEf2qvZ20bQLYkWUVbIy0prrvYIjCTwPiytPwverqnL3eWvi+VQFgBqgxwGzzYrHBPuC9krtBTWoROQcpUk0YWl4RxK+PdTsnohdriE7xg35tq1ZebwDTN3vAHmmGchyf/KdpkXGekwLiNwQDNh0eGb9yzcXcz6Dcdn03ACpqKKBaDVu4v86IMJF+Czs0fEKHi3QAcxU0OuSsHWSiRSl6d6Tp5Mh6G6eUuxvr0AqUjyGLR9toWiMbEMyDMfVrvSWFXfnV02I99tn9qq9vxCpE9ClmXRbPOLlHB6LnqYi5FWsY0PBJsm1X+Fr0YTqzGTrbHydNpM+ClPKG4SL99yglpR/bWLv6QSvlnE6c0ik0hxtwRKNZ2uyts7PwQiI8r1+y8OUtxS9v4DHyqLPupNz7UChVQ2PXWAgscBW0Kn+0yEdBgKwy2SvZvnIbwX0wJZkGumhhp+tA/P633gy2lvetN83znL2wOAjqnDbSP7f4xBB4rT+o3Ins6+/9KP9GZ11zmZBf5lk2hAjQ2ppofw/KMziKW2AXi88OjmCbu4FVKDHQIeiz2X61Hy0hzvhUV9M/0GrtRtzU0pCrhhAt/3XRCfOqIhA/NghuaDkdaT/XD4BvOZ5jL1Kq+PqKsXpBs1YukFRpxgd3Wsv6MbRuuFgRzFYR2V9ANTx0gQtUPWOYz/HEs1qqyYmeiQ0i3M5cT1DhCAev4veYZjxYvM0hRBeceJHKNXwCzcVzli+IYW0gIfAB4rTcThYQqPs7lzGAh0XdmVOL1Z2njLj4dH+B7bZwTkOFYaJFDKVPZT4Od62ifpXUihF6l5b88meYBae7FI+yofBqAHM+sTtTVxzhUB1ZKoeI9lH13h87UdL2bm2eC/ddiBajaWsiE1IdaGhKZ4J/PMo8UC40RFAJ
 rHpYmVdl
 8eDmUwR/GvOGF20Zddwclz2S8GYIuJmaiKBKrNPsnKWSeiuWSX/qUfICyCYPqb6e0Et8V1Cifvyyjh6fS+DoSOeEinfhLevDb3/0LQ94ygBvbfg8D5e63TnO86s4AqhQxNzk2dM/jKAWPzJukEt02VY9JgIsmn26Zsbc8sG27hv3I5cz4/TnA2mgwM2ijYSs4aHx/WhGT2h+ZbrK+yQUHE73dFCj0Kw2iyDZyyoRGe359MX0eqB89RgF4Bc8xhz+sua3EO98ktqere44YaV//hQ+4KYH9eLq4XmWhrJp76MlHHhCIcXlBe00q+tn+qxYGh7+f3Pyke4oj7Koe4nwOfDM37PK7iNfpIGwRGOAxB+PZB/7Q0ks6KqWTgNo0kZd9fKpmULoZOMX0UCW63lZPuheojoaJnon3GQpxiy1Scau2kozTvxcp3K2A1Ndb+GWpARqdH1pQdEI0QM5rd0V42cEnEec1w6acnKEYaYpzjxQzhYX85tQdUMOJ1FxyMLuqk4+De6HFLqY9Elu0MRojU7jl3+XElvgonfeF+J1xBiO3OBe1qxBAU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With __install_special_mapping() moved to vma.c, vma_set_range() can be
made into a static function there and is now completely isolated from the
rest of mm.

While we're here, we can also remove the insert_vm_struct() declaration
from mm.h - the function is implemented in vma.c and already declared in
vma.h, and has no users outside of mm.

Also update the VMA userland tests to reflect this change.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h         | 1 -
 mm/internal.h              | 9 ---------
 mm/vma.c                   | 8 ++++++++
 tools/testing/vma/shared.c | 9 ---------
 tools/testing/vma/shared.h | 5 -----
 5 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3d69b597b9b1..762313b47301 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4130,7 +4130,6 @@ void anon_rmap_tree_verify(struct anon_vma_chain *avc);
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
 				 unsigned long addr, bool write);
diff --git a/mm/internal.h b/mm/internal.h
index 01a762bcc2b2..2c650d280e90 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1540,15 +1540,6 @@ extern bool mirrored_kernelcore;
 bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
-static __always_inline void vma_set_range(struct vm_area_struct *vma,
-					  unsigned long start, unsigned long end,
-					  pgoff_t pgoff)
-{
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-}
-
 static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
 {
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index 5308aa5a8c91..cc0e449ad0be 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -70,6 +70,14 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
+static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, pgoff_t pgoff)
+{
+	vma->vm_start = start;
+	vma->vm_end = end;
+	vma->vm_pgoff = pgoff;
+}
+
 /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
 static bool vma_is_fork_child(struct vm_area_struct *vma)
 {
diff --git a/tools/testing/vma/shared.c b/tools/testing/vma/shared.c
index 2565a5aecb80..bea9ea6db02a 100644
--- a/tools/testing/vma/shared.c
+++ b/tools/testing/vma/shared.c
@@ -120,12 +120,3 @@ unsigned long rlimit(unsigned int limit)
 {
 	return (unsigned long)-1;
 }
-
-void vma_set_range(struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   pgoff_t pgoff)
-{
-	vma->vm_start = start;
-	vma->vm_end = end;
-	vma->vm_pgoff = pgoff;
-}
diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
index 8b9e3b11c3cb..ca4f1238f1c7 100644
--- a/tools/testing/vma/shared.h
+++ b/tools/testing/vma/shared.h
@@ -125,8 +125,3 @@ void __vma_set_dummy_anon_vma(struct vm_area_struct *vma,
 /* Provide a simple dummy VMA/anon_vma dummy setup for testing. */
 void vma_set_dummy_anon_vma(struct vm_area_struct *vma,
 			    struct anon_vma_chain *avc);
-
-/* Helper function to specify a VMA's range. */
-void vma_set_range(struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   pgoff_t pgoff);

-- 
2.55.0


