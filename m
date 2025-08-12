Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB29CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206498E0183; Tue, 12 Aug 2025 13:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD7B8E0151; Tue, 12 Aug 2025 13:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11AA28E0183; Tue, 12 Aug 2025 13:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 027CF8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:55:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D23AF1D837C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:55:18 +0000 (UTC)
X-FDA: 83768857116.13.1F2AF31
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id EA3004000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:55:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ji9pNo2I;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymZGpmngRJ7fOyPoIYIbr864BuGgQbxABMyIAp/lv7M=;
	b=MbwdKgOYJbOz4dx9A5YHYT8Vb3E3caWQ4vc6sb8eOMzIeWyh3oh1t8QLFFETZq6OoXxPDq
	vKEF/0Cdw4RqiKifNRv+0soV2nLasmbQrXUu2tv1vlCkKPY7Fj0A8YSCasoVezxOtWJvE6
	YSp7deuy0QkUEz9dz0GkdTwvi/JR2fs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021317; a=rsa-sha256;
	cv=none;
	b=G/nW+dDm8BcsJzHXy30Kvai1il7dNDJQi6xlHSvEkSd1vsvgtlDoVLW07JEn3goW94K2ou
	s7CAzyg4rr8nEf2bxpbK8nSc2aeVxtbB2OV31/hkfxfvS9J2VdVfikBZMgbZEmmhvdHPuf
	KO5W02y1Pvi/fSDPc2xhdZ+fLq7oC3o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ji9pNo2I;
	spf=pass (imf17.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2430439c05aso7712355ad.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755021316; x=1755626116; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ymZGpmngRJ7fOyPoIYIbr864BuGgQbxABMyIAp/lv7M=;
        b=ji9pNo2IgaIj2C8cvHoYHrbWpgyP5j2fIJsmORgqKgS0KF29WnpQTZUR5RcKjyJ0Vc
         VxhgyDikm2tFmrUBkhdzNLxT6111EWsGQi653VRtA3Fpqq2QxNsT22Xz1EoFfwjsmLqv
         fGvgTwK6KxgT0PRIabo2yLi+z03pxqGumK3bvrEF2ssVMk/uNh4osjT5eDQp5HWD+YQG
         zP2x2ggvV6IK0YdQN3RsdUsFikKj/gO956QO+XRgmsNhAaRq686DO3K21x3NYaR4+o2o
         LRvnKtYOyYcO7HeBWeZAztptwgxJ9cTXp91Y9ojA+6Be1V7bLn3efUgsX3HBqySBXKXm
         q1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021316; x=1755626116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ymZGpmngRJ7fOyPoIYIbr864BuGgQbxABMyIAp/lv7M=;
        b=WbTvx/q/oVzmn4+HEHLfqP6SCeWvyn3YKMq9E1UONvx5Uqod4Io2Os24B9XPE4YXgj
         eKWUYfE0v9lo2tzMa7UHdSxeIGrbpqFEgT079v6OxwTeRRY0KmG8dLR5SR+jwxybnIDK
         jsvSaXA7ohVpWxcdzZ28TKtpHevTWDGR6FiiDCOfovnp1S9gSgHdxK1vlHlP8zU758/Q
         GzWzxHbS31Nb39xrXColKanKJhmYWVIp8hgfGdCJr8BFUY5Wb1pgfTMSjSGBW0D6SUK/
         ycnYyfa3zjFlT0/743JUiyZEkAt2r4G9o/OfhiU0A/4y+EmCbV5cvvFaeCktIVHmu/gk
         gzfA==
X-Forwarded-Encrypted: i=1; AJvYcCVo955eXAa3r1/F2j/kp7NRYOLHQJ2qkj7BXy1B6FWrJos+ftE7PoQrC/dDQD6SJgkLADONhHr8jw==@kvack.org
X-Gm-Message-State: AOJu0YxnZ9RKK2spdUB0pbcGSE5AlqFQj13TTlaWYUNVnpb+0jHr8C8a
	x8Y3/BiqE85TjGiFPWogyhagixmA0kkKhq+sv3b2mSj66vDokh6qGS9L
X-Gm-Gg: ASbGncs3/FdE1j5//rY7zEG+QQbin0APyudRmoq31LYfOZA4G57WSGiLyAXe5cOfN6a
	juXDVxvU1Cpy7UvvpGpZolFYev0/KTuVd25450L+LkQXFvoUDCqSYpklY0pBB+VYq+dHBlfhep+
	Sr/ZI2TIMLROMaXzWQ6TLTw5D5raFvrHYa6ntscxq1ORNKjCwnMaBqpPU2BdIUyi32EOp3zbzNm
	LFpRU7epNZdbNEvoZcrBWpuroIXerVUyYoCGwgrozbOrMM7Gw7YPbvmYNqgybG2zmJxsn0RSbM6
	gUg3nnNdv6oDDzAXghNM/37Oa7H5+OQVzeusF+iyp6kUNa8S+7nd+BcayNSzuOEnbnHAeRzHYIM
	j+GyOz6GIyZvsCBgIAbT6DzVTKNboiEE2Mk+liC0dgVQCvhK7vOuRk4oIjMLpTsYt
X-Google-Smtp-Source: AGHT+IE18aIbwR3kUmI00of6zx1vDAbhjJri7AMTb1JJykSzC0p6KytmOlYDyZhwco9kF97wduWaUA==
X-Received: by 2002:a17:903:2a8d:b0:243:8f:6db5 with SMTP id d9443c01a7336-2430d0a260amr1715145ad.6.1755021315592;
        Tue, 12 Aug 2025 10:55:15 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2422ba1e09csm279039935ad.16.2025.08.12.10.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 10:55:15 -0700 (PDT)
Date: Tue, 12 Aug 2025 10:55:11 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Qianfeng Rong <rongqianfeng@vivo.com>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] mm: remove redundant __GFP_NOWARN
Message-ID: <aJt__zOHjGcaghNf@fedora>
References: <20250812135225.274316-1-rongqianfeng@vivo.com>
 <b5ca3ef2-bd36-4cb5-a733-a5d4f1fb32fa@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5ca3ef2-bd36-4cb5-a733-a5d4f1fb32fa@lucifer.local>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA3004000D
X-Stat-Signature: hpigm6fbmhqk8m9gwyxjciiy65pjn8km
X-HE-Tag: 1755021316-925420
X-HE-Meta: U2FsdGVkX1/q38QNc2rbEJ7le/aaG1R81yG9nsDz39zgcEDH0hdpHhHE17jDOIjvlZ1vaR1ZcyvV+dkweK7g3Kbyy75tL8ENrTAdwpoOyCImAQv3R8CWAyX5uwzWT2e1l7ZBwVwkZ7gGqAHApsQ399y2PLGHx/ZnNnio5D/aGDboTJY7I0cgOy8P4tkwdpTYcRUGa8rnHNPNGKImVYziAF7RWjEWpcSa803T8zPEtcRzc9duepekw03k3D1cEL8sYpT6mzlGsY1n2n5B0qtiAR5ykY2PVW3BEuF7Tseu7t+hSAtDwDmWyd0e+6ubUqW441xWnnhNFTHSLZFUR6jBmfBVVjQQDCNvQ+J/U3KQ5qZKyj08vOcxffnTvrc3+kHvuiQte9Hks5E0Ls45XiyWm4e4xIlIZX3ygPxhWqDkfDCCn3L2nV2NKYE208wUpC3pv3IlLc0/hBuQKvd6enwzHNNl4/rj69LABkA/0M/6jd2abImOrP9f2XzGXZt+gEIm/uZFMjrHQhVMJ1YDqHZMVAV0w7S2Vc+M8ByrlLdk0QTcDCTJahHso9QUKknoicHr3ubYXDuPdooLk3xvQ4USRf/dC+pIvxh14g/VktG5ovPaPesIJ+NCzbycPvhwoyc6ZI5lfsX3THqT1wxP6mgNz83k5wWHtZjXzTB6GJLyxtgn49wzYd5adeVSQeD3WVivNfNOvenFDyE1i7XMyuqumz6swy47tSkqwg4wTei9rgwuwdAID1lPu1/I1ANUvt3nGERYJqFB0/YOinfrxStfZLYqoN7EsKBRCPkeVW7XCiLc0J6dwP4eg3DiQoLrrl64ZfZXsHSM942xS6XOme/bx4KFlrw7y1qxm+gyty3/fuVtPyfj+BoM0Ctzv7egYCrfFfD5+2JXZa5ve1dBGzBw1SmdfjMDTPx7kGVt5g0+JjvESh1r82F4vW12OgU6B8LwQ0dBG3VQSorMjCE5zb9
 4QMMGMJU
 bNwtAf72KwaY0+Yob7calmELFnF+vjxKiCfBi3yF0JdkS3zEMt4kefBhOB6A6BOfRycgOfFrjVfHYrgA2FjxT95eFvic0Y4DO9zAeJVWW5vGn+EjwbdF5DSacdQfWSWmS7z98L1x6F0TVMjMJrDL9lDbBcHGNwUIb5SCJgrvjY0HaPPH38OSbd/hjTjhsw0NOuAN4JnYUtWOkZyWQilHEw3vSNtCKjFotDSwxu8M3Fa9LYmvBrLglwJEwHKeMGFfVrRDsaZS6YAr2ngl2xhD7q7rQ8gtKPc7Q0lV9+JlswYSuiAR0TBegHiwhkQZJnhjlcrOLMM4THMv3gYGeF07TERG3ktzc8v8RD9pynaPp5rwXmcgPtoboQH4qCm9Ea7C0KU6PF30+sILnedLkR+NG4i/JMYX0VpCqrShNeZHkDCnqlQa1V7mTGFlXACk/rRvcN8iszHpiJ+HMGgFVCGDU5j3VSL8+nDFcUVzPBDBUeLN2g/0yBVeqEyOyqO8ML2gimNGOe+CpUoPwB0DusUkakC9qsaKcRxy0rGuP1/4yCcEw/qgkR7k/i/FBUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 05:46:47PM +0100, Lorenzo Stoakes wrote:
> On Tue, Aug 12, 2025 at 09:52:25PM +0800, Qianfeng Rong wrote:
> > Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT") made
> > GFP_NOWAIT implicitly include __GFP_NOWARN.
> >
> > Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT (e.g.,
> > `GFP_NOWAIT | __GFP_NOWARN`) is now redundant.  Let's clean up these
> > redundant flags across subsystems.
> >
> > No functional changes.
> >
> > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> 
> LGTM, I wonder if there are other such redundancies in the kernel?

Looks like theres a lot left for this specific case. At least 48 show up
that are spread out across subsystems when running 'git grep
"GFP_NOWAIT.*GFP_NOWARN"'.

I think they should be cleaned up in sets per-subsystem to minimize
merge conflicts, as suggested in the commit mentioned above (16f5dfbc851b).

