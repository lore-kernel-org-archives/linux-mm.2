Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C409606C6BC
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XK1DYUpv
Received: by kanga.kvack.org (Postfix)
	id BA3366B00EF; Tue,  3 Nov 2026 03:41:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53DE6B05B2; Tue,  3 Nov 2026 03:41:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69846B05D1; Tue,  3 Nov 2026 03:41:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8856E6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:41:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E6BDA0359
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:41:56 +0000 (UTC)
X-FDA: 85393165032.06.70FECB8
Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6C64D1C0007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:41:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XK1DYUpv;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695314;
	b=B1sYE0JC3Sbw639QzfgJYNAwblchpdj/wpjKlEpOn+sp7KuktPVKyaxh7ipKMr5Oic+DS0
	3AmxKoRvSPQ8uvZpZfD0KqyCVcJcEg6/3lz1V5PmoHM3E6iBUZnttRjqgU9aJ6Jw1HrZM6
	QWaSVQDaPryujPjMUKpi5oakXKhSrlc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XK1DYUpv;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r35ebxTXAFp75IFXPLib2rMbuUcQ84dYXkx8V7iwL8A=;
	b=WX9ntP1pNtcA1fIHd3YsoDrBBjCTm1mnt9cnZCaGctHMyvHHrKs7URioYs33cgt4V2oiPi
	80/y2YQdATNqETBbvK1Mb6KQKcUESSa5qozInxSfiTTLdMEjw5l+gUQbeNJZXGHOxbf+eP
	G0EpTey9kaDLsHhxg8nL24cz4DSG5Bc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=r35ebxTXAFp75IFXPLib2rMbuUcQ84dYXkx8V7iwL8A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793695313; v=1; x=1794300113;
 b=XK1DYUpvLk5CYvkb7JFC+S4lsX1Qqv4eUJlrtaue3W3zZb7pCf3qpo4zLyxKVIkvEtUzWZ+4
 S7M1RAa8eGkZH3JNO6bg+/5kwjAD1+ljLXL5I4B0+hAixXEB+fxlf7+rJokMyImgQB9peBBDw9m
 TU5YoENfR5BdtdIOzbGdNBa8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 06b8647df261ab87;
	Tue, 03 Nov 2026 08:41:53 +0000
X-Mizu-Trace-ID: 06b8647df261ab87
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 1/4] x86: hugetlb: disable default CMA reservations on
 32-bit kernel
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <61eee83da19a87337e68a7747fc0b89ee5d0393b.1793692578.git.zhengqi.arch@bytedance.com>
Date: Tue, 3 Nov 2026 16:41:38 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org,
 x86@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4EE65C7C-3532-4056-9794-47A9B894969F@linux.dev>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <61eee83da19a87337e68a7747fc0b89ee5d0393b.1793692578.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6C64D1C0007
X-Stat-Signature: kr3pqcu5agdst4pz3z315scmeu9aheos
X-Rspam-User: 
X-HE-Tag: 1793695314-356223
X-HE-Meta: U2FsdGVkX19Zfz/Vk9pCgmwQnzbwQZ7Zrh2jOK1A7hJt2vP5bKKTKiFcldEHgB06uOKhFtXsAm6fUyWHjd81lleKU+CidqVd9RUQGO2wobEINan8fGUU2w61rKyB81ZEj/KE2YAF7gjj/u9hEkZi5GjHzSDsw6IrOpyr8gz21ofn96votI5TVLk7YUG2snv2zmjytOkcLXCrI12Gf/mmWk57aVdAecFWmTCDPLFpM8mIYGzfFo5e1FrR2rNR3tIQKK/kfaa2qp+aHI20Zpv8qLE+lts78PNO/5yjXX+HzLSVAQY66r3MTLccH83NrP0qPUBxuJCTOyuRVSu16arKNddTOYt9qQEhLR+8hLQza8fLliU5A9OX7sMkLsc+4fQSuogxEOCBYbg0mmm401HwFpOktublSniAEEJH0hcvJIFB2hQs7DAa3lfj1sXUDaVgXTYu2q2q2XnVpHl3YNAlFDGhUuGkmmCwxpCB2/d+iq7UjC6TVOy774SFj2pl3H6AYYbRDxNm6udGHh/pKFBt/WKUGpdUEmFQ50ZtvAph/FFfX6YPBqko8dLcntI0oExHxUAIgiyV8xZsDX6CYuKB+hrVZsTF0yWKxvOWnkv7BP1+F7g/mamcBvZ5abxHN/trjzAU7UQOe47Sw72UVq9ldSuKm0Nz0Mj9UA4avaj+K/Xkm3suak+8GzlB71Gm5ahrAeBvbspnOVtkux/3el07xnuBmfBMlj4kzcKoJmYseNXF//QceIqRo7X70EEgX8SUictnliH8iYet43O7vuJWHkirWIR4axBjf5REFFS5FQ6YcaQv2HaozD0WM8jWWU5tBpR9XCqe5hz9IMw3gUbLpkn3vMEpoXrCcORi4qsp/4Tewg0ZrXP4O24pNAYKa6jBFblJvw3In3mCR6uLq82v43E1OZuVHgG3x8xyqO1R26VTbwBe76xvyrjGs+Mep2+2bph2idsF/yJG5T0+HIr
 5PzMClaQ
 BkspOXVVypGOkj+rmSuAdglHCaH7wjUg7zGLU6xwrbubTTOm9AKisbH6385ltpk0qeo6WeEKiZsLvx4wlZwiRqSzCnO3rzx1HLPb6CoHbT5gbJMx3bTOluD2ESNOjXJR0uvZGTP6CQf3s2WiB0XMiQsDPzYjgDWi8l8inj/v0dFVk6rhvoDPiBRIn5imI59qQXC27jQSGhb9LVLORhFgpSpT456pJ6RQVb7NQvztqp4UXbQegkTM+QHu20liHyfczasEHSvEPLEVYRNLZMVYC6qJ49Fc6Q3cXEZjvqLBZKH4380a3BGyY6ZYY6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 3, 2026, at 16:01, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> A 32-bit x86 kernel can run on a 64-bit-capable CPU advertising =
GBPAGES.

I don't think anyone would do that. That said, it is genuinely an issue.

> arch_hugetlb_cma_order() checks only this feature and returns a =
nonzero
> order, although gigantic HugeTLB support on x86 requires =
CONFIG_X86_64.
> Specifying hugetlb_cma=3D can therefore reserve a CMA area that cannot
> serve the intended gigantic HugeTLB allocations.
>=20
> On non-PAE kernels, the folded PUD_SHIFT yields a 4 MiB order, which =
is
> equal to MAX_PAGE_ORDER. With CONFIG_DEBUG_VM enabled, this triggers =
the
> VM_WARN_ON(order <=3D MAX_PAGE_ORDER) check in hugetlb_cma_reserve(),
> warning that hugetlb_cma is attempting to reserve a non-gigantic =
order.
>=20
> Require CONFIG_X86_64 as well as GBPAGES when selecting the default =
CMA
> order to avoid these ineffective reservations.
>=20
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic =
hugepages using cma")
> Cc: stable@vger.kernel.org
> Cc: x86@kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


