Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7358EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6F46B009B; Fri, 10 Jul 2026 16:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666C16B009D; Fri, 10 Jul 2026 16:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531026B009E; Fri, 10 Jul 2026 16:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2917D6B009B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:20:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7919169408
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:20:16 +0000 (UTC)
X-FDA: 84973984032.10.B9A46EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0E1E080009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:20:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KklfwoQD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783714815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6m+Kx9pTca8aDLZIa9EAYyuWtzQz4rBN6lpqZdjtOI=;
	b=HBW6sonk1QfdT2kkBaK42riAf+RQTs2fDzGu8pgFkkg3KEmzckZ2l0MrOPLpPy6H+SqLXB
	uRB9PwMTgBPVhuqfCA8hT8vGtFf45UcKnoJqlB99nq7omJq84ivaa7O66TW9nFrko+cM75
	iQzy1oCRpMEkTbEZhOyyKSn26nl+Pp8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KklfwoQD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783714815;
	b=WgVJPoiL7U5C2NvgzXxBLJGXCXbzOntPHlmP4HxG/Pz1badC/Z2O44C4Gj/mrqh+2KKWe9
	k2MgYA/cekRA54IJZa3S+dq25sHErZKO8gQd7tImrOWkENY/IzNEZl2srHMxTnltu0szNH
	rA6xb0ZL0ux2tOpcluVlQkm0g66zEkE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7338B60051;
	Fri, 10 Jul 2026 20:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9341F00AC4;
	Fri, 10 Jul 2026 20:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714814;
	bh=b6m+Kx9pTca8aDLZIa9EAYyuWtzQz4rBN6lpqZdjtOI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KklfwoQDYnFJiSgF8x/fmMsC82irr6fiC3vgvxdByDvRhoedHf7pQDn1c9NZI5DfX
	 MOp1LTiHjHpzA9VLvkhYbildB4cu1vHCk5/KVbHKUSlprjpTaQUNMDmjsiOI1Te042
	 uo77hJ8LafjCsZg+xC7CeE0CvOqdnXPhDR3G8yHgib8IhAkNPTshHLMdz11XWgX0vK
	 SiUbzRTgSYO80iNLU2glBBPv+CXZpdrT32nDMj1+31ugD/CwsX4SHX531HtcRV/aAa
	 LS7f/v828c4J4dL0OksyoCQ6qMBgXKJbADW9m+mA8/97HyNxBJyN4JJFdTQqAIWyVR
	 mgWAx34mGiLzg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:48 +0100
Subject: [PATCH v2 07/33] mm/rmap: elide unnecessary static inline's in
 interval_tree.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-7-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1497; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+vEjD5vk3USGS9eYkwFhK69Zz1FxHMWNBbZKQBCnxeY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg62zJyhL7JCZOvGsm/Q/rj3+70IOrpitfMx/uvyjz
 oi4HzwnOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRdCeG/y41XWeYDhe96a2Z
 3BWx1eDu9tse2jMKv71UKpp856v5jjuMDJ8f1fW/3H7zvFYYW6fsng/1loVifcVXfG1nbto7c1k
 vFwcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E1E080009
X-Stat-Signature: wku1u913eepsxfi76wrknaujwt89ywhc
X-Rspam-User: 
X-HE-Tag: 1783714814-605814
X-HE-Meta: U2FsdGVkX1+0/buQAYbRtrTXWU8YQyAjrszXJGG+RAJMH+3cdYhT8Jof/1SL0M2AAngN9b/xuMRsjOFtCiY3i3BZAEhoZIynbKGDhYEIiafRfp4RCU69O9Jk/7pNWAbDLaF0fmEaX1TNPv7BbAKoFTCpUwITXuN4/JFXWmIMbZ0zIiYhzovfk521ISFqru7SzUSH5TkV46y8vPHCLiR3sq28RaRMjT2FDCmZu26OR4HxaykFZvc+TPsc65JR2HFt326LyGOtlnBNs+tfGK6OTgNB6fSTU3IHaHf0kD3IllMb4WNAyB0EOLIuTkLHG9JdyUzJVZN+2cuhKd/E2VG/KfifTP4LDhEFAETVQu+sqVMMgE0rHcioq4CN+FOwjkCey1PjZyscrRkMkldSNXeGVxV8MHweXhQ0w+eQLA4YMMRBIkHONrNwSwogwKPlvFjFu/JvXp9iwMcY4U9oYaFqfOwQJPpIlezUe2dxd5n0xXMPiG4dVGpl4AGztOgsM5nwmPkp4MqIzit+pEmSQWFC/T/7iTL3aCLT1OfhtR9zirVDMwi7a70SVUlNMfEMv1Yl7ROWRSudY+cIscYBZtoO8FYr3nv/shrVEhhErWt/ce+OwAfNJx0iOQnuELhIvRj1+6zpRSDPLt0/BH2IE/oGcBgt5qpS+Ey8/8bV+w12cC1IWPem85VIqyaTC4jprv8Aaq8pDqBz0Jb5pU4Q2oiSpVhu6bcu4WlYAL/G7Hx/BQe/ZOXUwzTrO5+AMKXMvln2KDjF1G/gERwB3v3RwZCtCPcKf6TifRT2SGRK+RhB4T66Iy/IRUaqHzWy872Bl10bOgtRZftf55kBoPnC0fsH87HcCthatUxQYAV12Bvq0ozGthpOqD3vOfVF2EVC56e4EAmtmn6Krt3JGLDqqC98D3FellcI74vuAlBstIkO2okey5vXhMx5GqYCGMAsgQY6hDRLz+urLsap7R3ALzz
 6oIYfMSs
 ThfzDR5yCwWbxu4pNIeHX24FvvYN0j3RnKynSsZ+tFvUR2dNB5g8go4f2GaK43jfNFNK9myKUHCSkeos4Cr9jyrDpwM+w9bE6JAzSaPzRXTQcHG8TQjVoWpbQZSDzZ13AIqs9TSQthCNNfttmxXULJl4s9d0N3rJFdihvvDeCkDN9EFdKib46QTqJB/cjEyfdi1eNWi2ec/ggEu7sO+rFHFxSdggsruKUQuAO6iDLfGT5hghaLwF7UmhiWdVcMwGHlxT51HG9ED9bMTm9zqRGZkiqCX/F8/Q1FV9ENFJp8N0XUEskokxQNsaJ7/TseXAOhi0ShWpLBmwZjykZx9qElZDQbbDBqajxQA0adiR5qaW2T4nVhhxEmCuxybc7oBiM6+v8G8EbUkOyg5Cy0J1E8exf/IVr3zW7DReCvU1dTuur0B7MAHan0gb9kzUW4Fjk/wQU7z87n4gSVOfn0oG52zP56g/4ZoH+Q0lMa4twk+G/izDsogBm3asxnYs2XaLFWT8jw2euBWiCYoldgsI14+7RCFoQP09TE5UCAnkDOsxgEAllxEyXramMiz/yVGUKpviDPgYyFqC6JZKFQ21CM+TKL+Adj6ushsA28ZFSA9eNnJy4cUS3qkrSFXd4o7mF+UScEqA8u/00njVbWiPgL9kx3tnMbgoFKEnPeUmELNj41nYzxuFHSExfI7TQtND5ZxoXdZ79YAz/4FcFdU4qGBX/H4NwO7gp0WF7r62NjNBMfwxN5L3jVihidaHlI6Qjy/AlRv42XoZ7m2j46zgvHIrJ9wE+P6HY0vpLD9gorIU3rNezFoQtYSJfEX5TVXLCK8hZ6jrcM9sJvbCx3kLj2Ns5RXUZ/42I2ait12hhQLQroVWMGTM3DCEy+dvJOGviLSn2OyOy5L0Vra8mtklwziUN+8HolOm/u545Yp3aWuA7/RC4DqzkCtq/qvSb8Zexv0qM1xJkBSdNa1+/1NUmj4WfQQXx
 BBx9Owbv
 CcQzXQQcaGwOgVDA57LgqlXYen25FzAmfaTDb/d7D+tb4QufiJ57PJirWgZ+pV59VptnPEPFHJ9zfgJ1hZGrxODmlakNFO/fuRxFlaC70ABzxwMuWjYOj10aJHUPOkU9uICtASYullNAdHlDp8VLiv0zDfWT/T3TwMnGr/wWp1p57F9IJtLdz/7NknmWjbfJtl18UyQN6f7ne3RBSBDYA9dIBn0yi57qETnVNt6kDGwAVCND7rX8ZbAyjyF0akB278ZAIsjkDTBnAt84rqwGEOtmdXsjZcKOW56aBUg4VAzG2yUtB7oOSPKUfHCVhWADecmRE3K9SCs5s8mubY9lKCL1rtGxMT8GJO2K/JnCxLcf7v4GU2mHrZV9+SjSPtA2XutiLfdZ7UxJ8PKXBO06yIIH9ao+yTJdoJMxzxvcIDHkB9JeGyuJe/OGs5uEcLRkkRe9jrme0QNcV5Pgmdk63lpFYiUbeYLBUD7imIEHvrmaO65pFpvgcALRfjIPJwHL+MgB540t1q73JXRXMJ2w0iRT6Fi4PxIgu2zPNj6ZHIHG+4EZuexfOUml6hXFWRkQq2r5LZFIzCTUzBX9y8g1eD7Ycz1afxoHY308WX5rXnU1LRaXkTxTp5H1SLtKPcBuSHMe3icVmgYTsQpcSADb8rLV2uKwiNfzC/0tbZt5CmPHXMzhJebsjqRa5CL3Wpn5BApbcWYyFCXhyT/K46WaNWEnZKR9K5zjPaUEmIuwDHQb2zWqWWqrcEJNDRuorn7xVYdb5nhsBOqMYsYwOo+7GqZj3sP0AxiFFOoy+jpzOdxOnuPGbcDpTuygwVZ8+3KO9tDt7H9g7Y+MV7plAM0Wu8ezPMcOR+eagi1gomlXlHPAsVcEnTuf7gj9mfQdzjxoQZ1eXHsjKRJsHea8yeB9Lu1O+9OmDyqwg6nNu2QSZWS2qzcrPvee3MAP08anAa0eximw1aaPTtjQ/5WHR/oKGm2M6Z2Hw
 I+yrFnZs
 mPpnEKUaHwf8x5DhTU2QiyJc0jRct6aJITAuWI1wJarIsrA/x2hox1/fFwlhqauXssGZyTHNNc4U2kWxbsaBmY4WXCulHbqmBjW2m/dZx2LBdmjUHjFnzdHj7S0MAd+ie1iVgsJO507VMC7WLJ/nR6DQoFrI+bmbPJJMfRpFn9fbbGDhXiIRWNcElZR1KeuO7T55Xpup7M8ZSd+S0bmcPUhXJITY62g3HcdxoNB3uEonSwY1sHuJv69iyiwFgA6J1OptguzwBBNiel0Dfib35F4XwTfP24KYvov5SxY5bKwenFHhGGo24RIO7dp8aT4AUnMd2o7dUrVFmxv2uiNnHjvvEJjXt1v/18jMa71IXGRG2iWeRLaF/qmDYnd72jxvHPmk05eY8YXwiUT86o5BGwl5GLj9ol/s/Jm79/RE5xLOBfl7PATtLQpvvsZQqpvah7t6CIXswh8GihPMvTFjpOXPFSrPf0Co/S7j1liFf4rwMM7AIZ1yJ6mo5BAy+W4YDQeA0ET/Ee/8dNcQhiwdZ2phaiKlx3y/Ri6FLf++by9LLgiPIsDPLOjLCaQMEgwnS+5vBzPiG2j+KlEqtrl8vzFf4OVl2QDG3bDjiAiopKW3BcrdWVN9a7UZvOA+IN+jeuvJaO7PkFK6Xu+6iedl7aY+SG/lVL4sEoivn0RFTbcx56QYok9H9Z8OUYWoFx9DexWIr3+PmgHiBg9wGVuvl9ivjjGsx7XMuK4sWKlzPX4LkHjG/8ktZy44ypIQDG4biBcd0Se5VxV6DgZ3nIRdMGSIKkbqWPRGdGiQrk3LrhBePBbCsOHo0gdFMTdU48Q9bJ92807VPl4RteeygxwncGArJG6vtjE79f0NWP+cEeVz7t7eWWr+DWtomqZTZCxUYOHkjmJ1BgUPfxWi3JSvKHrgF5fAemtfYXKJAe65J1Nawh6yik3mf7KglIWS431+gElNinMvlLMfrF+YCvjkw6sA2LEZS
 IUqYeahe
 CIpMhYLYbmpsm12SZVg6B6m9F6EXIUIbLnPTA4CDtSVc18aT9wAPVKv+T8/kIQ7LSocino3avNs3XSSgQBtqihyOZ2QTVuN4nQFRwcw7udnMwfiE4xoMyOregqQ8Wy53a1UwALbG+5NxtHJgYIcmi9rSMBvpa5e27L16Qvj6taaB5eSWUfWzE9BQyzdKVslswCYO6Q+jac2OFGT+yaaPOlaKfhSLL3OoyfuCzAvOLVd+qlAEdXgOUOxpjTiXjxp7ky1AqDHDHpWgn7g88sc9lUblwDQ033+C2gdVcYIdEnN8vwhlEkbvFCPmlyC2j/6X5I8cjALZ3m2bLiCAy/5ucYSl5BdBQA8bbQ6DFhogRarQbuTo1X9odEj7vmsFfKShsnYoN+YHfZ9fR4D510Y48lh4b/IMXX9tRgZPiWQYmF6q2HZc/MBpOqhTb3oFJwEMvP5srYlcFiZN5PfQK/2+M4ZroPkcFTZHN4onhTtadQK7Cn0ZcjzY51Hp56p7rTtfvlTYsOhLZ7FZYEwZxRIs2vCiMDuQE0oSIQMegqs2/oEuDOHRMfMFVc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's not necessary to declare these functions static inline as they are
contained within a single compilation unit.

This makes the anonymous interval tree code consistent with the newly
updated file-backed interval tree code.

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/interval_tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index ff36fd14ef37..b387d39e0547 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -81,19 +81,19 @@ vma_interval_tree_iter_next(struct vm_area_struct *vma,
 
 /* Anonymous interval tree (anon_vma->rb_root) */
 
-static inline unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
+static unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);
 }
 
-static inline unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
+static unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_last_pgoff(avc->vma);
 }
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
-		     static inline, __anon_vma_interval_tree)
+		     static, __anon_vma_interval_tree)
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
 				   struct rb_root_cached *root)

-- 
2.55.0


