Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C109BC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE696B008C; Tue,  1 Sep 2026 19:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F606B0092; Tue,  1 Sep 2026 19:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E746B0095; Tue,  1 Sep 2026 19:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 556096B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:07:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC44712054E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:07:35 +0000 (UTC)
X-FDA: 85166732070.08.C5AC1D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF38B40009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:07:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kerGN5SB;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788304054;
	b=V3AC8z+y2OU/aWMIOuFrhKiho209rA0agqtpAGH3Sw2msrcOPN6ydmUee/8pSYgYYO+io9
	a1VLltaSD3m8wUqTdSoPtMZ385IeVeubxrpqferXpV1wXIs0p01NFDiN4xDJfoaV5BBctK
	qhsmgTDySljBOiS3UIUznrh8cl1fDDQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kerGN5SB;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788304054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cQ19BHiyrucmJAw/pZFIQ4zM3ytepyEIFxxLDlatXE=;
	b=YA4+vPTRfp9jVIULX+jG44u28e48Ecc90s9W2/8WVbW/35MbaXjHMGRtnB4fntvYCyi8CH
	Oum3ORGu1dps3oR6RdPqFC6wThvHKe4+hjKQGtULdSc2tePqw6eA14d0K4CNjKC1EkwAMa
	nKEl1u9uv8UcZL5mOlsLnPpfaGvnIpA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50E15601F7;
	Tue,  1 Sep 2026 23:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B92E1F00A3A;
	Tue,  1 Sep 2026 23:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788304053;
	bh=7cQ19BHiyrucmJAw/pZFIQ4zM3ytepyEIFxxLDlatXE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kerGN5SBq3yKVTcKS9bVEW3P3myLlKw6ZtqPBgY7pUSSc2o83gl5duhZsYi7rr+tj
	 LRBEWhA9KftnxV2h7SwVbVs+/D5ymVIUzWOU30LGP2lOSS8TzdQee7VrwCI3TtfO3R
	 W8xeOMF2zlRU+87Iw/b+zQmf1KRK+y2fH94NeP50=
Date: Tue, 1 Sep 2026 16:07:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <balbirs@nvidia.com>,
 <bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>,
 <kees@kernel.org>, <mingo@redhat.com>, <muchun.song@linux.dev>,
 <rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <x86@kernel.org>
Subject: Re: [PATCH v11 0/7] mm: optimize zone-device memmap initialization
Message-Id: <20260901160732.8098b853491008465ea81461@linux-foundation.org>
In-Reply-To: <f7099580-870f-4cdf-84cc-a82cc47a42b0@bytedance.com>
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
	<20260831164531.be5a8fa210401830e85eb974@linux-foundation.org>
	<f7099580-870f-4cdf-84cc-a82cc47a42b0@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF38B40009
X-Stat-Signature: xenhwgh99xgh91e7gnofyfgtfmuk3wsk
X-Rspam-User: 
X-HE-Tag: 1788304053-4616
X-HE-Meta: U2FsdGVkX19C7Z3DcELQYVeA2QbGetNzJ7Xv0xBW4pRyGu+P55CgHPGsYCUCod+Dbf2AQ3CWOOeQEMnaRx0OnNuoDLje6NurMDh+7FADtXpQr0x317s1NdvaajSrk8UdBAqVaAL3YXChnp5T6DQ81kPoLyFD1rde89447Pt/x5GtDXVP6VSJOlyixOMZuPTdc++p98scSlJJAZqTfFqgKiIaLr9x8xQkGXqEVpEBoU0EmF7EfusuOsU3bWqA4nKyd1aXBiDjzZ4joH3f6HzCoBVdpHWybtyDbzfGcdAEOViXbSll36iLLjxFSnpglzTNDVeQmdwZ4dDV5swUbr2frxg0kttLqEGZWlxigZduNCcup4MILNstfl1XFCUJFu7EZuZWphz26yltbm+4kQal87MR8EA6IC5lKh5HONxL/OS8zwvMDaCerNucQUW5LZdbrmjMEaqby4oiA/M3vokUa0wfDZjp+Pwb3HRWqd6hhS5gPdao7xURp+l6HkDGt4Vcj0HVzsqzZUIpgAk58oPeV37qNN8N7VT1giKyqGvBjy7mVlWwqahFF456qpySPjFqh/uujbJEFXDywyRsKUccVhUSLevgqLd1xcKutRay5EXxI/SGaAiIVASkmfoX8AwyHPSjI8kO1SHYvDEkedpGbhdFA7lTudVswiuI7J1rWdCjmlIfv0FpEtvoUri89HGY5rT8ahgv3IagjM+WnTy0c/or5NEXEAyeUPNhxKm+CFBAQP8CxdZyFrmbcyfuLa/yZFWf+IIBqdS0Ehomr8aRy6OBzXpN3vLt1F06z5x5VI5mNsZix3leaFfA0IZbsMDKcOpmJNQpml6GDXIQ7RZ9IXNTTQXxXWXF23tEd4ZEr9wH7uw1/0mHbhw+UFu3E1YfhzVMgjB+FqlSBQ7T48YYiJhEl1eb6hG6rZf7omfvePJuJ0c1CWztvU1SFGq9+ZZmDG00J7ZGLUlrZr2dPam
 5EXL+EMR
 Qv3iRzcl7jC3K+ksywbud5hrWiO4uwwdQmsbs8tQ7pzEjqEzZmqdTID1sGL7Rk1ndTcN1JdQ6op4CcXA+QjPOzWZryt+3bT14iji7j5CV/UJ2GEfYy6mcSY5nda+dMLLpT+r2gYNxhGCM50gqBwuE9zmf2NXtawzjl6at0KvmE28TQKlqCvrcmiYDm0LCTiJ7tLHoPVRH4r6axIQKRHaEwaDvXmyvNZa+w8jBY8UCQPyqr9UbJh2Xnj7JYxgMhRlNI3X91omnfAr1++AeCpBQLpkStq/aI+NX77b+YFiMBSdTfjAJLDmfFiOyPPLvaDul+DHpF2PkT0LB7+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sep 2026 10:58:09 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> On 9/1/26 7:45 AM, Andrew Morton wrote:
> > On Mon, 31 Aug 2026 19:16:31 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:
> >
> >> memmap_init_zone_device() can take a noticeable amount of time when large
> >> pmem namespaces are bound or rebound, because it initializes nearly
> >> identical struct page descriptors one PFN at a time. This series reduces
> >> that ZONE_DEVICE memmap initialization overhead by reusing prepared
> >> struct page templates and, on x86, using memcpy_nontemporal() for the
> >> template copy path.
> >>
> >> ...
> >>
> >> This reduces the average memmap initialization time measured during
> >> rebind by about 48.0% for nd_pmem and 41.6% for dax_pmem on that arm64
> >> VM setup. Since this arm64 setup does not use the x86 MOVNTI fast paths,
> >> the result also suggests that the generic template-copy optimization can
> >> benefit architectures without an architecture-specific
> >> memcpy_nontemporal() backend.
> > Well that's nice.
> >
> > Sashiko seems to have found some new things to complain about:
> > 	https://sashiko.dev/#/patchset/20260831111638.76012-1-lizhe.67@bytedance.com
> >
> Hi Andrew,
> 
> Thanks for taking a look.
> 
> For the comment on patch 5 about the cnt == 0 case, I agree that
> memcpy_flushcache() should preserve the usual zero-length memcpy
> semantics. This is a pre-existing issue in the x86
> memcpy_flushcache()/__memcpy_flushcache() implementation, not a bug
> introduced by this series. The new ZONE_DEVICE call site added by this
> series always copies sizeof(struct page), so it cannot hit the
> zero-length case.

OK, thanks.

> Since this is a pre-existing issue and is independent of this patchset,
> would you prefer me to send a separate standalone fix for the x86
> memcpy_flushcache() zero-length case, rather than folding it into this
> series?

A standalone thing please.  It sounds like a candidate for the x86
tree, as long as Sashiko is wrong in implying that your [5/7] could
trigger this bug.

> For the MOVNTI ordering concern in patch 6, this was discussed in the
> previous round. Based on that discussion, I believe the current code is
> correct, so I do not plan any additional code changes for these items.
> 
> Thanks,
> Zhe

