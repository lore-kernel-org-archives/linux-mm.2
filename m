Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8894ECA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 02:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095A18E01A0; Tue, 12 Aug 2025 22:45:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DC58E019E; Tue, 12 Aug 2025 22:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC848E01A0; Tue, 12 Aug 2025 22:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DEFE58E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:45:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75F9D81829
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:45:21 +0000 (UTC)
X-FDA: 83770192842.09.9EC6303
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99B74100004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:45:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dkP4mCjc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755053119; a=rsa-sha256;
	cv=none;
	b=i3XZYkA/p/qdTgOU0Jw59V1t+8WszPr20PzlU38eRClT63yBX2UXJgG+iqKkM1ssmnvaGt
	8zKuw8kOGc104BRgMDV5GoPVhVUOfsTdYVsffCexYFaRd9hmrwvSIyWcDzQR/VMGEnaAYD
	Swf4c1kzDNMmi48g4f8Idb1KyAnaDk8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dkP4mCjc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755053119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kvg8fvdZercb/1tUH1fx/ZCsiW65Avvhaf/buqFYuWo=;
	b=x0LPxSp3Gm++UnQJjZqYcLdp8gGAdjxa0z0K/xAbAp58LxDQjPjIBpHZbiKCGPII8EyG3M
	c3ThCtq00PYG5I94wK6gT+JDzHNvzPkF+1fJ96eC2mmbTCOzumQXoj0tR2qooXSVGfpc5c
	pCe9tQvbCAv5rGTwv0+PQ5CyXKpCaAg=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-458ba079338so2428435e9.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 19:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755053118; x=1755657918; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kvg8fvdZercb/1tUH1fx/ZCsiW65Avvhaf/buqFYuWo=;
        b=dkP4mCjcCBn1EUiIeYLfmPm7vtkwAGbO3gK5syYIBLToWMr3iv+F2IhGDNMdji9D/J
         mtmIqG/ECKjbrvpLKJ9Ks+dLj6d0LSwFVyopTdrjR0KDqVVVreIpQlnxvfxGVL/XOwRl
         MUBSdqQMNouZXhDhZ+dp9siLOKB6vLCbykdc9LudD+e5bBTFEZKX9lqnFWDO0LGkW/hL
         42Tz7/JunBK1WkKeZBF2qNgZRJenGIz99eZ1rc9Lg/HvV45YivGcDnCy6gXadjK6uwre
         XyO4uxegTAibKja3Rt6j9qmo7HWNripNIwbGeeTiRBAjs7Qf6tkHoG/ygCIhkUGZXeMm
         A9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755053118; x=1755657918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kvg8fvdZercb/1tUH1fx/ZCsiW65Avvhaf/buqFYuWo=;
        b=QiDytGEsiVEG93aX/6XmlB9gv1+G+cMN7PBEK4rWNVMjhJachgxkJNDaPbAI59F5uB
         BFGU4yyzLp7EzBulFVA25QILhTKF96rQBgFcswjH4FAkpZ8YUuZ+Dx9fkyD4KdmsP06U
         oYAxl8wGxu5ktm7FLYRXaVWYQxRyUnvwkZ3nJP4Xv94qeqZf1eQ5ozKBJJP2U78bS/EY
         fPRbpN6PNEEG8M7V5EIUPN9MBuJcMdOqbbr1ZEECv2RcVw1v1v/ux0fFXPV2ZM7mAYwr
         rLNz1Xjg6DwZCEaBtTpOiFoTFB8oWCzyb4JQs/jgcX/A/gVBHnJKtgw1KJJk8eVCx++r
         Y67g==
X-Forwarded-Encrypted: i=1; AJvYcCXI8ydEhhLHSPnAMToNcNyGXCAxVVznxId1yIzQI6s8t4Osl4O2hLFQoPw1o7+Gytuc0THEw/jmHw==@kvack.org
X-Gm-Message-State: AOJu0Yzd8qYRamnuxqgtMh7KA4AkLxFuvStq6JfWWcGdr2666QxtpeFR
	F9ewvWgW4T8c/2KrDy6BeLncQtcX3moko64a4bgaYPFbx+XJ5zb1g0fFpMiSZNwCKY+/7QlbpQg
	CJhDlutqIlzKB6i8JjSrweB8Yd+IDCgM=
X-Gm-Gg: ASbGncspbwiSIyhT5HzU9FkvCY07UY5pQlZpqpSnXKa1TToxqCt7qH52Lxs1J+nkrtM
	38BWURYx43suiL6vwNW4lbBPhQehA6AuIOfcVrYyPXAfK9egzjYd+XYtbW/H/XRZNaR+zOQDvFi
	xNUrl93hC6vrv+M/n4KMhw1VZDiyUhiyV9uWlhyOnKIXfCL0fDxTUEb36FhKMGQe5xNgosQ5RA4
	QRchfE=
X-Google-Smtp-Source: AGHT+IER/xoh2r0fiZY/zHhrvqqJNO6/Cga2A0F4VDogmsdOv+We2VyU1IsS8IDXJ7I5efqv8sxiKAzD1n7IC1pvaew=
X-Received: by 2002:a05:600c:4e8d:b0:459:443e:b18a with SMTP id
 5b1f17b1804b1-45a1704f681mr4589345e9.14.1755053117827; Tue, 12 Aug 2025
 19:45:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250811173626.1878783-1-yeoreum.yun@arm.com> <20250811173626.1878783-3-yeoreum.yun@arm.com>
 <CA+fCnZeSV4fDBQr-WPFA66OYxN8zOQ2g1RQMDW3Ok8FaE7=NXQ@mail.gmail.com>
 <aJtyR3hCW5fG+niV@e129823.arm.com> <CA+fCnZeznLqoLsUOgB1a1TNpR9PxjZKrrVBhotpMh0KVwvzj_Q@mail.gmail.com>
 <aJuxuKBm9qfpVkBC@e129823.arm.com>
In-Reply-To: <aJuxuKBm9qfpVkBC@e129823.arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 13 Aug 2025 04:45:06 +0200
X-Gm-Features: Ac12FXx6Pc1KJl2LaFe2eqFw1_0jb589tm6uNaUFSn8Yw7SbSnihGg_Kc_aD0sw
Message-ID: <CA+fCnZdWOh3=KkM4AL1ZYfhyMhdSqgW97Rz+uxO88mMkqT6WTg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kasan: apply store-only mode in kasan kunit testcases
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, corbet@lwn.net, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, scott@os.amperecomputing.com, 
	jhubbard@nvidia.com, pankaj.gupta@amd.com, leitao@debian.org, 
	kaleshsingh@google.com, maz@kernel.org, broonie@kernel.org, 
	oliver.upton@linux.dev, james.morse@arm.com, ardb@kernel.org, 
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com, 
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ws5ptap4jttxcr9r3wwcwkwfzr4aiwx1
X-Rspam-User: 
X-Rspamd-Queue-Id: 99B74100004
X-Rspamd-Server: rspam02
X-HE-Tag: 1755053119-822024
X-HE-Meta: U2FsdGVkX1/bZ6Oi8gLbdWyhH8tRxBOJ6+tREP2+cx7B+dDEM2H7TYxrWAoKy2PCHcFc73yBCBz2yt71fKPGEsIAZukZhHlki6zHG9C0KWfXyQ336gr90ngxi6lw85IagKZunoaclBX9k8+cvS+8uHSkcx+sVTq96v86CSL8zhYtDpWTxdO9gEKYyGdotWNnBgcNx3smp5G/rkw4Ef3YG39QMm304YtXVtDAesFg2qbJyMEKWbg19Dm/23l3dR1U3Bm8sY5h7a8Ag3+7g9pSnx8Zcf/d/IkYFZ478fN3/yHrgN2O3zjRT53nul3Nrz8gFPkUUmr+6kQlL4Iz5tsxmdKApTvcg5zhgIu7lixPtv4Fizc0G2BYZ6B9EW1VdN74qhM0NirzjmqL5/ypyw4i5P5GRkg3tMQ2YOX4u4h97mnpjrkzQ/FnVt07f8zT/ZiPqVHxSYe0lH+mHyaKATSbCJABRhL8bwB2LarKlaXfxXDIi4SNFfwVv2VKs4Zrv48I/2HgHp51FlEGuC4angmtU9bX9//PyNiIoeC7WNwA1yVxTgMBRKMWvg+i/oe46kbg0QlhRs6ZrHSpAoqmrswP5euJYiglRy9RanP7L2gp9kK63upmeAhNRxWK5LVRH14RSVK9ltZrnkVdue/LYm2cy0u4cymQC3zt6sUJxUnneoIoQU+2zs4zKUi1tYCsG6g/yYHj+BBFPk0PzRsIfThv+0SNr3xBJRkkXXgSpVuJ4B/WNz+GK8Mr/aGZhseZx8P0qomaBw/erQ1spJu9BZHjPs2gXM4XEhcOpVSm3pFhKpGbsnc02mexEeU9ZCb2ZPerL42i3Iys+v+muXEFAXXPQHN4dnEk7s+7rQdGhkOONdkPttWLmOUImbi4dALPJEtD6W5hoJEDxoyWqHglHw+7w/B+w6Q5GsNALRXQgg1Syd7ryjXY02M6KrYdOQrZE3JDzLMniNEJv8jhwiWwOso
 kJNSleZe
 wwid66qzRKB2CmXa9ApheqKvFtT2N+p7SLxKpxMBo3dlOmqVLZi6YuDda8M3bWb2FeCSv6Wkv8UzSIBk49we8TjO7gi4diaUZryKPE+QC20zhjYkXwkbVtIlcMSvjOh0PlyFVg4js38owY9S8kB1d26Q3MOKI+jGNb1g5jIiadFvaVaY3PIYM996XbE+xUlpMrXMN91rOSLdqL1Pj2fdTt0t2UZF7eGtH2B+QuOSMA99Jdl/K+MyBkBa8ZTgLOmNHv6OhDFEEH+7SX6H4WdNNS2u7eVIu66vEfrW0d8z1IeyDybiU3IPCK5b3JCCgNg/f21+KmwUEZgmdRYW+i8ciIP3pWd8qXO4Ar/THRj526l5cSFdRa8ByK9jZjUh6FCxJVc5jc8DWXUi9WtXxs/sf84QvzN8PJfpwLG2JEt+JXhVJ6VayPX2JzGc0gWbHLxeMjp2us6tzv5vZJyAJSpMoG79n+oqBJ7sn4PR6m3eXqR8wfr4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 11:28=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.com> =
wrote:
>
> > > But in case of sync, when the MTE fault happens, it doesn't
> > > write to memory so, I think it's fine.
> >
> > Does it not? I thought MTE gets disabled and we return from the fault
> > handler and let the write instruction execute. But my memory on this
> > is foggy. And I don't have a setup right now to test.
>
> Right. when fault is hit the MTE gets disabled.
> But in kasan_test_c.c -- See the KUNIT_EXPECT_KASAN_FAIL,
> It re-enables for next test by calling kasan_enable_hw_tags().

But before that, does the faulting instruction get executed? After MTE
gets disabled in the fault handler.

