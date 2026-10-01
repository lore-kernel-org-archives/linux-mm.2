Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92995CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5AD76B009B; Thu,  1 Oct 2026 09:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BAC6B009D; Thu,  1 Oct 2026 09:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9906B009E; Thu,  1 Oct 2026 09:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 680466B009B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:21:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0135F403D8
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:21:39 +0000 (UTC)
X-FDA: 85274119560.26.6A2AF27
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1E1D9120011
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:21:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a89sdwps;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790860898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CzgSrGsZ4Gj7IVYhmOuvePzlhKlt4zynM1RYMllPuE=;
	b=k8CfH8G5T9UXrTnigmEwlHZbvYTm8d6LzEVHWVwTOemszZ6SGL5ZbtpEbbCJwybZhEXJ7c
	MZH/2AloEVe4wYV6mBhabVXdRT4VFpRN3c1m5YFYDtFEKeaEbP7129zpKxIJjyjrX+SJin
	MOZuUOSN24ZvQPmqs6zrzpiswMXuyWo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a89sdwps;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790860898;
	b=s2scUmLWVDMSX5Jm3ZeTeyAL0o/ZWUIgyxCaQ4nvlk8qYqQfZoq6EKiqVsggxMqPlDtNoD
	IK8mVflpVryXBy7eZ4OC+t28NSSDsFmy+DGJdxbVIM1CNuVpCgCNowKpp1zb/p9DDyqM/Z
	I5wBEybyP1RdJCH7g1jaccUtf4gs5XE=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb766bfd3so56492361cf.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 06:21:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790860897; cv=none;
        d=google.com; s=arc-20260327;
        b=Ipj4oLyegTsZw12M2I4AvNUFb4Bhf5SENHwDSvr1AHqqmhL+qMv59iIvcNPTdzlQU3
         84LqTnFFOhkXm64LpnjjCQyYX0ZRdREI6VcyGywsRAppQL71qFe13PB8N7y3CL1jax69
         BJ3BjMLlfKZvG3wfD/jMLhZdmkv2V08gM3jBDe+0KGnV/aK+KhXqzzZLfWSqjuRpxiKk
         6lFRtMfmKVoOTPEPGHI7pZp44d0aUHnl7ql83DLL3U8FIwhmvgH4+flljKcMll3xWKMJ
         QQ3MpE+eU9VQmhx7tm6fCd0mDO7+C5ojy9wWKkxoRIj2ojVH3F5t+3B/YMM2kyPHG7Bl
         gxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5CzgSrGsZ4Gj7IVYhmOuvePzlhKlt4zynM1RYMllPuE=;
        fh=4vi9yQVXnsIdBCKLcdaowVE0QgCg7rq7z0IjtVuPeHQ=;
        b=ghHMn0LjzK9o0ci27Sq+L7Bag7f7LlMqL/TRK61zFp6gS2pXJUfd9cHpBmVEXtPG9x
         RwPyP5tBTENRMw0xMor4aMgqe8rCdNRpC9HSUZB+lBM+HSLC9qMR9tSuxJHSBQsBKNGo
         aA5KusXAM49ssiElIgRKDzB0iQcmXAQ+RZfPy3PWDFTD8udaYkRnnAaYWTGW55/bsB6z
         kfUl1iJqi6KgLm9ie1TxJPwbBBgaWfYZ+csk6aGNcDxi2/cAHyuqHhL0yJYkzf1KAChF
         MvHbp2pxMJ4NUynfPg5hvRGudvGWj/hg3tCIRoRkPAm0rPL27RPJ9JNjs7g4JWcJ1i+/
         tonA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790860897; x=1791465697; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5CzgSrGsZ4Gj7IVYhmOuvePzlhKlt4zynM1RYMllPuE=;
        b=a89sdwpsdEmQUx0qaHieGsaBB3lLJyh1XXXhWgIhPGBlaqa0pFCbP14GXPV37y5hTd
         8NTyRRUpkpQKlbr3TtljT3CRLjnZewsr7sJ86+6r51BEwuc7jvo0wcoe89Hhq84K8qqH
         qdIEJs3YQyfkuQvw1lxFdmtXHoC06LEPEl8ZUsX8oWAPSXDv9QljmKn8AqY5fqj/QI7H
         Z8gFNW/N0I5PIxxgjUrVDeY/pOsXb8zAfbo542NVRBxYnYHm5cnObT06yRXcT78FPpYr
         96AW/N7Tm36PQNSkwh2BYVMHdw019gcngq90s6B+4zBTcHe3+3X/ihwBq1WFEIF5ZbmO
         nK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790860897; x=1791465697;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5CzgSrGsZ4Gj7IVYhmOuvePzlhKlt4zynM1RYMllPuE=;
        b=WvT/fUZ6VMOGJQobme8YIWCzCn+ezBG0duUPdYrKguoQJ0rF8MDnSKlu/aJJZMYvDd
         ok2tT3k5mMFsT6qQXnJyLyt8Bwm2kvIzYEAOtMd4BHAO5RbotzK2wlFp6E5DVjwUgFQn
         pIvgX/rDPpD5xRORpDKQYo9uPhzf2TJWvUt277YTt5RTMbolMd5Q7OSaSgRHHPvzVxbF
         FL0uEmy5R/CDtbMx77aI1P2Y+U0b4N5RU6589QDJKS3C7m1aQMzYnv298PqB8DKWQf3Y
         TQP5UlM/tpuPjC4Rjscn0ysjGfGb/C9L2kLTCDCnb53v0Xrn17K8T1rY3CWLT+viJp+V
         +uiA==
X-Forwarded-Encrypted: i=1; AKwUvBxBBEy9YerRkcNoU/AgvcDfd7sUV7uuujDIoJzbPt+/wQrDnxI1M4JEjlIAUn/pyqcHBc53dam4uA==@kvack.org
X-Gm-Message-State: AFuF++lbBmr4ETfBrbwlhJAe2EJ3vbuccx23HwM6Ci6J2gLlCE2dG5eU
	neh09Hb8ew3sq0a3DPkChEv0GlNiQ1XqiTBjb/s8R3r/2wFa/ejFTuKxoKWPufCP3JId+dxzCL0
	xKy1kP+v3fMN3Dz2PGYzy585qQJUyivc=
X-Gm-Gg: AYBFou0YAwayBE/RyzD5Y1FMhNzZUi9+xMyIXi3+EQTttKvYThWhNuCFz0bnukB6njU
	o3h1shXm7NYWqQEiTW5MdAYyBqM5jhPtP5MuFNmMzGozMiSH5R3Y8cfq2SEb6+KF5xnfCoKToFT
	Yw8YyjSmolywk/cpBQy/vMqxVTXcbjA5RUJBbDZi58QSm+9Jk3q/MYQgKGO6olOj+1ZuqJ/PQL9
	7XrRmTfObzU6xAmfPwXU1Cs1CQ+4FiTQPPv5OkP3+geUa8S3ehIfdQPJ9S5ZaAuo1DyyVEz0E1g
	egS9teZeSvjd87NqwzJ9zLkbETfBitC7ZDVbj6E9SaFEUZEUoW/PRDmasdXuUdRxmLMitI0UYCL
	thnOS3pm6KMHfefT0x4ADghPxSu6v9Yd+8o3YaWFy6DHKMxQ=
X-Received: by 2002:a05:622a:5c0b:b0:533:4346:57fe with SMTP id
 d75a77b69052e-53374dc085fmr90051631cf.58.1790860897104; Thu, 01 Oct 2026
 06:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org> <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin> <arz8Plu6J4YOTi0a@gremlin> <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
 <CAAE3jtdHi7aSsJ62TpEjkxvwA-3TBLvr5i1ohCNg2aupND+_XQ@mail.gmail.com>
 <xhrorb6wn2j2j57ydnt226khnu6gv4ut3crrmjwjr4iwj7d6yo@43lugxdthgyi>
 <CAAE3jtexTRdqzAodzCkAy5NtH_s3VhtutXbxMjangf8BtB+-dQ@mail.gmail.com> <ar4WSaLYBs1db1-3@gremlin>
In-Reply-To: <ar4WSaLYBs1db1-3@gremlin>
From: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Date: Thu, 1 Oct 2026 21:21:25 +0800
X-Gm-Features: AclHuK_01iC1Hv5D_FCIUHeGCNiklU5j67JhEui9tVa5h0HZh1DUCdAFkZ_2faE
Message-ID: <CAAE3jtdYdt4XHkBa9sWNn283f+n=nzDwgxV_xWfPon986NJYhw@mail.gmail.com>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jan Kara <jack@suse.cz>, "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E1D9120011
X-Stat-Signature: zjn1w7dh5db47k8paqwkqf6o5synxdii
X-Rspam-User: 
X-HE-Tag: 1790860897-860615
X-HE-Meta: U2FsdGVkX1/OY77ONhOoq6NnUEc1x+Ud+haQtkJebl6cKSpGIMya4L8udvPCcWKQtAIBVPKUAdIjnl2jNRvaIVnkS94KpZJzX+lCIDShiwaxHGvc3DspoB7a4/qBKlKLiCXJsS3tPQBdy/NEOMhbfXaFxkW2n67exf/xQZKzsjkjUUjYgUvu9ghnPz/yczzw51rLlRdN+MgspZivUzz+UL55xYMA2GxxYV8yNWmFwk1q5e+3WNtCVSkvhWbmWco2GXKo+ovDSOuudOVmyeZSB+zD+6Icn0htzsR/mwdBQEXRmQN8IK2kRVj85onTuCNO5iWvbIwvEcLKwfj3Y7A8frxSNuJWZ1PE5W9FdOe3X+nnV3NNj/ZbPxPQRrLjlaRhsS4lPhT7yi5yh0AghN71ru2xurc814x8bTPFX1qp2vk5adhFikXeaCPpFhdwplCCObxZN7maGYm5nInkNqqmRc7umTLgbUnVP2nnt3oEkNeciae8h5Zut4f0rzUCfBvWHdyHJh10wGSPP4Pf/rLjtS7x+qRMED63s85god1BuWRxjkEDg47WXJMOwkW99kw6Ds/ZPaispTa8cOiRQwGUg+QBT4Oq7ZeUZM+k9VL3yb+blpBG+tnovS5eFTM5OH6UwzVDvOeYgxI28RNFNi+fhxJmhdrBKkrD1MzVGwmP6LLogpYMUaxhs1et4hMChSFl02bLCCJ+cOUZP8BSn4zR603+dXOFd8/qaIW+gM8xL3O+EQCwdpxJ+q1+ZeO41bdpxvKAj0St7uhVXZyvwSAGApMgwhbdPHBUF2bWfnXGSK5WET9T+wgDiSVgwNJDnxd6g4/Gerz1A4bq37FDzKdOp/u4hYrvg8TDR2K+MD5zoqxsnJgtLLSaT8JZPEACT6xnLhsGAW2/O7wFFMgeJtGen533J7Wj+0bDYKoIObK/XX/HHKE8GLCgxBhw9MBBmq6DqhbDtpEnyVBiEE//ti6
 iM0KD+H4
 KZEGe09nM6tAC9IT3PhRVHjmJoH+Bt7bjafjxfzg9YS20wktx3d7/6yr2x0qW3mpm8C53Zpdaxqa05dr1TDQPaj8DgUBABg06KTYy5z+RitsMxDcfmWr9GaDKmylqe7t7cCKCylBHIiki6ARo4dhGurhHeynbd4tYUX/fjKCpQQ6LW4+EZPfr8x+v7gsSuYOxQA9gQEHbfJgwUVhKEuKF7d/dC19wePK4tUNk1uHomEfGtukcPQ4YMOhVonWikyOsRYT2Kbj8MO28EV4ixGi5JK/NA3sh5hFgvzxjIVl+mY70jK+pk2EBkOvaXSTZ/u1KHT5P+/lzphy/Bp+KBW4LnIwiRRigB63HZq4TO9B27+JT8xYeCbZ32OGh1tYWeJczImX+TGFAEF8yzWvd8lzxUu+In9FLIYv+NUfOhKQjsWk8h8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thanks for explaining the shmem approach and for pointing out the
mailing-list etiquette.

> Overall - each objection so far has been to the cost of changing your
> design rather than to the userspace approaches not working.

I agree that userspace workarounds can solve the problem. In fact, our
current workarounds already do. However, they are awkward and much less
elegant than addressing the issue through the kernel interface we are
hoping for.

The underlying interface gap remains: an application knows when writeback
would be useful, but has no per-file way to ask the kernel to defer
age-based periodic writeback.

I believe this is a general issue, rather than something specific to our
design, and that we are unlikely to be the only ones who would welcome
such an interface.

The best-effort hint Jan described seems to address this directly, while
leaving memory-pressure writeback and explicit synchronization available
as usual. I hope we can consider its broader usefulness on that basis.

My proposal is only one possible approach. I would be very happy to see
the kernel provide an even more elegant solution than the one I have in
mind.

Thanks,
Peng

