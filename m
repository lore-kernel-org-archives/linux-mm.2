Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D54FC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD1D6B009B; Fri,  4 Sep 2026 06:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4C36B009D; Fri,  4 Sep 2026 06:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC0E6B009E; Fri,  4 Sep 2026 06:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2A136B009B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55C361C285E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:32 +0000 (UTC)
X-FDA: 85175748504.27.05470ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 816B440005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ge/Wyc+a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywgp/pHfl+lA6AvsB1zv7ftqiWMvHJVARqEHp5d3uMA=;
	b=AtfYQDDgItt8+QNx3Uol6ohIGSQFHxqUKY/CY4HCQ6j757M0rv+6Fg6eXU+h4fEH7CRtGk
	yGKJBEOwgAgB6khCOYh9HKBCaryWx/IjE0DswZiOlJOwJ7mLYi+mkf+Ongx6KryJEyIEld
	WdY9WphXhwcYGkTKVbrCZZ4Z8Qz89O4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ge/Wyc+a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518730;
	b=3hj1WVfk6aMDJDHyce/hAe9nhvlNkzUo0oVv4S3JFE+0J98wJA6Ubk4XYJsy94Q2x02GtC
	YceYhLdSfpmkV9oYo6EhHEpjYA7axdZ2vB9Mzrn1mFmXtUFbBDLRRa5uHBfTQ8YMaLiW98
	b0nrM36Gvc8WPDHiZiQH/wYn9IoOZ1E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C379742DE2;
	Fri,  4 Sep 2026 10:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0FA1F00ADF;
	Fri,  4 Sep 2026 10:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518729;
	bh=ywgp/pHfl+lA6AvsB1zv7ftqiWMvHJVARqEHp5d3uMA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ge/Wyc+aaEqvFnsoCBLmmHxDP2ZrFsI76uOFZedKIyr3ObjIeJehqTg/E/e4qyHqz
	 RS2fdjU20oGmEzZbwFbjGznSL0/Jc0/BbBAKwE+1TGN77/9r/ctsXXwNjpFK3h5N8E
	 9//1N6WjKRUGuCSZLU2UPtMWn5MH8udTFO77aWBnc9Blk8heAf2sjncGA4/OUqaWiw
	 hviqgWQK+x/0ZyeqTGloK7D8LR+vbsJzC5suRNfxpI/nrfbY2i2LJ8mxekylPof/SP
	 QllQE4G4a05osclFK3ydp7vEZeEjmnTYfutnB68stAiHS9QQrGqYmvRiVEUGEauaI/
	 YP2HaE6K0j+mQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:44:55 +0200
Subject: [PATCH v6 04/12] arm64/mm: Export set_direct_map_*_noflush() APIs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-4-79042cfa8de5@nvidia.com>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
In-Reply-To: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Russell King <linux@armlinux.org.uk>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
 Saravana Kannan <saravanak@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1083; i=treding@nvidia.com;
 h=from:subject:message-id; bh=aIM9S+b4eUaYPFPTqciGrMGQP2g0bdZA73J57AFYD/0=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE6y9LZb0fTu1fD2MuKJlskXvqXRscG5DRpw
 2HGzz+KC/WJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOgAKCRDdI6zXfz6z
 oZ+tEACbMm5y/9flV4B7lKc8c7sppUYfz2sbPsDFHHFGgAEXu0hrxqgbkreSsnbS8Y9VM3SHYU6
 BIhWV65aiGSz9zanzQqW0gUp6Ik+a9ZDiQ42QrejAoXtHqLtiJIBCvBGPElSqa4nFWQKrt54t2u
 VoIWmYskkNKk4ySyAoyMQdiLxvfqDiqPcuDYOKjmHq9u3hZL5FYTCfWMsH86RPe3xq3cWhIAdgp
 CSJTdwjOtQkEk3XCT5nyw5+bW4h7LEBJ4UzuNfeT8TYCoHw1bt8gO33t8GR5XgTajrdjVC6OhrD
 ruXH+RxCak8NyrklGIImjHCjsflgXqYRWVoOG8MejJ7Kbck+ql3IpUlTuFBn8DBYhYmr7h5aEXG
 dIyUpdgttoGOllBhebafHIEs1QTAPwh39wkOefhQCLmY4NrgJhp6iORWs93GZqDVMwr2wp/37mH
 nV6fa/DQn7PtV82lupwtW7dizZAARJAj38jqpSk2fNBy8n0V9JOQl+4O9Lodc0vIJSE1GPEmuLG
 ktMY7hPZQs7PBDvedNWcLwkxqHaLWxIRj1QXn8BqTft/3FZA05MqDViAtIWTTa5df/rTUg1UW51
 MkEw02uH/BB7iJWaabxssoUEhygxoSsbRbPaCkAyHPyd6ADUyywmWGqqCq9xvJiGo1Y8sPiLj9P
 TCgI7/FYwlN/EDA==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: z8if98qd3638bn5nfz79kmq68dkdjh63
X-Rspamd-Queue-Id: 816B440005
X-HE-Tag: 1788518730-285362
X-HE-Meta: U2FsdGVkX19mdbKuv1ey+VN2VRL7Ibk0QdF3Xpn0nQgH8fg0FnXnQ/xsup4jK0Hcx2n4YF8NTbx36sRWYjXrzMjvI2xMNBAV1w+isyLQLpSpq8PxcdgRHHkUupdqaW1tzeB2UsP1cOaqH7D0ROY1NpKLlDgMV1qReb/48p9lLNgtPkg+5GEz0zrvFoIEIxgdD7HUrKCk0mV9y9gkyBIGZidmvMrfw+vcX4tmZrcTenk9ohfQ4cYX2+4+Wftwkiz1p/cATN7WnPJJGw3NVKCBTi9ekHJ6pl6M/IsBQQZrATtkKVhCVu+3kBF9Tqs5wUR6QR3MzXqXi1PRJbRiS05KfaQmcOgA+o9sfPMp+NYAZyJ08V/IUneSzVwOR9que4FYsbvbEBh2cZ83ds203QloUC92Q1Usaop9Td/MCcxu+7ZHs8SJ/1sMPm7YQDIiy8P3Kl4w6vNzuQlnc0dY9+KUy5SzFdhooYsf7wbD2LhqID6q9302r20iOJ7ilwJRcxgkEUUSvl3OVtMD5wSmsrjGJ60HobJ3FrRoAAsBVQH0B5lDYh4HuN9fMdRCxAeRHA+7O79cFnAUygdbIupDWgtKIIoHC4TQpuWe/ic5pEje6mHOj2u5Po+H2QI2jNZ/Pgmot/kAXN/oLRq74cFaepmWnIWUy49/b7gdbG8BkkSRcAfQLBS57WkLN9h3GESglsoqPC0/Jkj/GEVHHMVE1Ins56CFrxO11XpXZTqhRULgYB+SzAvNImDxwAmJOhSAas4RhD6b3KlV+uB0K/M7wT2uf109pZHfIUxLJddEtUCKNHvTo9VXmVHjSRq+J40d+Cy6kS00hZKBI/RIt9QSfoSTC06SSom9pPqMDHVLLmCUDpJQ30TTVYz7kVHuvULDIKRY3WjqI/Icj47aaI+Y17WP2SOZu/rzLjgEjl6I99DjaMT2H2DsyYoeaXU98dq5xPj0QAv4nfMz/s6FemhT4kF
 xwk6w87y
 zK9doiyP4bMG29yxfYp1llcXs4iJ87zamqxMrnTD65JoJl/POCpmIiiqL83sIEmkAjeLBDoHCUr7mJb1LSAx1ndCXVUm5Vq5ReA6huqlKDj81MO3EV9MZVsC4YtBVCXNKsPzpBfQ6r+IZltfGWc3wi3pODfA2pYVRv7cdXNDznPiVl/73UTCWJ35ahqHerVy9y8Jy0d+Lim2yIlw7lz/+S2M0vOwcCZ/HSDXeBn+HZQFzNsI88ulEX1Kgom6prsWQZt0Nl0rR7XLTDgjAz3QzPemQgWSb9kBNtKDVATDCO7jsAh7qEqpDYKDe2SzWofGsaiXftN8lgeGOTljW2qAxOhRnEFX/2WnpndILX0dSvsZAZ8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

Drivers that use this may want to be built as a module, so export them.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/mm/pageattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 132938b32eb1..9253c529f8aa 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -262,6 +262,7 @@ int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
 	return update_range_prot((unsigned long)page_address(page),
 				 PAGE_SIZE * numpages, set_mask, clear_mask);
 }
+EXPORT_SYMBOL(set_direct_map_invalid_noflush);
 
 int set_direct_map_default_noflush(struct page *page, unsigned int numpages)
 {
@@ -274,6 +275,7 @@ int set_direct_map_default_noflush(struct page *page, unsigned int numpages)
 	return update_range_prot((unsigned long)page_address(page),
 				 PAGE_SIZE * numpages, set_mask, clear_mask);
 }
+EXPORT_SYMBOL(set_direct_map_default_noflush);
 
 static int __set_memory_enc_dec(unsigned long addr,
 				int numpages,

-- 
2.55.0


