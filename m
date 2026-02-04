Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BAECE8B397
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 04:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D206B0088; Tue,  3 Feb 2026 23:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B1E6B0089; Tue,  3 Feb 2026 23:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909D06B008A; Tue,  3 Feb 2026 23:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1B56B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:00:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E86F13B6A9
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:00:56 +0000 (UTC)
X-FDA: 84405423312.18.50BADCE
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4F63414000F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:00:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LzgIfLHJ;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770177654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxQndONrlkQiarlPwBkTwHo7wH1xrM/y1VeFxMK7N0k=;
	b=jBorL6RQ8hmiZsaLmCBMBJzmQGSebbzLxpBeJxSc4dN/nsHNYFHMxCm+IEHu/NFGWswzsI
	36bh64TH6rgYcKsuXd4z73HDGffEVGSjqWwsOY/zYalessNjPmd0OQe4Q6CpxXx2J9hQJZ
	0S2xV1tbAFwD177AvUFFxdrOhDbNqow=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LzgIfLHJ;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770177654; a=rsa-sha256;
	cv=none;
	b=kBmtRiON1p34Ppjd+yaebJzRaOQ31jHtDUshrwJXGs6wftvNGqxGLTJDm2oF1MQ8jAkI8e
	d7c/PxTMg0F10liZtbNEYBD1AAAyuOQX6pWiu3khz9/mNZ1OLOgZpN4ONig1ivTrWpD2Nv
	9zk+oHk97C/3TeWGMSJPa3ZImhK/Wqk=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770177652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NxQndONrlkQiarlPwBkTwHo7wH1xrM/y1VeFxMK7N0k=;
	b=LzgIfLHJS9Qoe9l1zGg2dKXdf9ziPdD0leE/cmSIJAzTsoD4ZmhIIhtkJ0kw5cDCAqlMbs
	U10pXtOBbD8a0reVaH5KCRNAHTpZh6SBoiiQswRMzI0XpT3CImnjbwABk8lhZgseFBxEd5
	vajh8uIluYBEf8weBch/Dg7OXTjZC8I=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v2] mm/shrinker: Fix refcount leak in shrink_slab_memcg()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260204033553.50039-1-ahacigu.linux@gmail.com>
Date: Wed, 4 Feb 2026 12:00:15 +0800
Cc: akpm@linux-foundation.org,
 david@fromorbit.com,
 zhengqi.arch@bytedance.com,
 roman.gushchin@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4FEDFC64-4EE4-4FC5-98DB-FAF9182FDFAB@linux.dev>
References: <20260203073757.135088-1-ahacigu.linux@gmail.com>
 <20260204033553.50039-1-ahacigu.linux@gmail.com>
To: Altan Hacigumus <ahacigu.linux@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: u5yuju4fqr7ni41px5gysyb43xsnc6wo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F63414000F
X-HE-Tag: 1770177654-716581
X-HE-Meta: U2FsdGVkX182E5Vr64dcak+J2H7wx4YjIXWV43r0H4bR4HJzx2c2AU3AeB92Q1COYZCw8z0T+hhr9qUR9EMANhCBpn5E0B6Ph7H56zjdziG6T1NRSmqt8x4vpeYPmFKRXaO7/MawobKWC7pJL23j4zoQKlC7+gZ9NhUxMBZys28TAsMGFBLht3t0e+3gnfYDuPyLi2ZD0o6jRizGwf5DTsxzCUQe+Jxsq3klpIev93/mtIX43zEUkC39Yp8BrTJjB9ZEPLvs5S5hlwH0XNKmakcGlLZrejjoz9R4Qj4Gc9x5G9xQcscL2t1xRC7cyf/c+EP+o76ccUvy8+OxuSg3PyphUqHRSL+sDaUD0fxBy8Oc2vJ0/1dVygVlJzhTBFMH+hrLUz/Tis4PyZx9q/RLAoQMKC9YKHTqMTKPO+uo3JVDu+s1Rp6UlY0jJe+YQELnCmThZC4J07O1a4mWzk1Ea24eheQd1+4woNXdlScQBObov2Ko3FX45mjDQk/3f8ghMAQj2CdiDaGaAzaXFDLJzmlVBSsPhlUD142HbZ0m9YJ/ptV+qD4Z3Ptw/U1X6XSGM5gNy98gOdgnkH5UMXbVR/AXEu6jcYiHbtuFghUHWSMy+tUQSiKmuodaijNdLqEotHvcKH/MkmVOrEMoGEw+AzFDXHnC83IT81+Vb+rezLEn+vtPqtqHOo74w0VanLQczu+iwQv2tz7imTygOT/P2vvL+50CH1A8vFxPu1X4NtT2WpobJoexqDoJjEzXVKFedOoNhLqIQqaMCLC4M2Pr+opfXdd2EkRrtySvtBLqMSLr+5NvmKsMpqb3lRZZIb3BbPDoOSZQE9HQK2rZFhVjhBfIYJ6rr74v8KIVOUXQi+0lOub+2k5AXZWdzVLQq6a3W9T9U9sqSuobf5rR9GzUSYUsqcjNHpiSzyXyUf2i01C6p7Nwqu/s/mppeu9JtTj8c8KT7h9q32VstGlEu19
 PY9jXpzc
 7PZ2UIjI9XKHP44yEKMoGVDD2d2FnfdlXSif/jChkZnlkVNEOGkQbHX93EoT2yGbcZp19jdI+UFHKVeGhOJ6JJnYuFQ6xmZn2byPrCqEs/YVISbN/kM2iDoAV6d9ISD9E0y8jiJ1OpaoyLNffushkhU+Fvv/tz+TczKpoMMFu2YbmXt5RnGj2X/2744MiptjwdS5IiGtdwHo9CB8qd7bCdcuT9lHd0tgAZv3ZD9rKBbO7C6Msz/HXzfnU7ZK11CZ5XokPogpdAQFNrzyqSurffDRgEqo3yQPweyMetw8YdEM0TtXEhh0d/GwG+TDvfjXZie8RFcMeLTVbYPlOmLDfTfMW+LS+gdokpAw0rTVm0ZdhBDmU0VG5Tk6aVJB3ZbnFstJg5zlEMU1TgbohAFxkVFzroqSqA5v/2xWii+OMEXBiOD66xjafBZaA2d9L3RNI0F4s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 4, 2026, at 11:35, Altan Hacigumus <ahacigu.linux@gmail.com> =
wrote:
>=20
> When kmem is disabled for memcg, slab-backed shrinkers are skipped.
> However, shrink_slab_memcg() doesn't drop the reference acquired via
> shrinker_try_get() before continuing.
>=20
> Add the missing shrinker_put().
>=20
> Also, since memcg_kmem_online() and shrinker flags cannot change
> dynamically, remove the shrinker from the bitmap to avoid unnecessary
> future scans.
>=20
> Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")
> Suggested-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Link: =
https://lore.kernel.org/r/20260203073757.135088-1-ahacigu.linux@gmail.com
> Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



