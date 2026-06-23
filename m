Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF76CCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B5B6B008C; Tue, 23 Jun 2026 03:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973D36B0092; Tue, 23 Jun 2026 03:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8641C6B0093; Tue, 23 Jun 2026 03:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1056B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:58:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1642A03D8
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:58:38 +0000 (UTC)
X-FDA: 84910425516.17.3A986A0
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	by imf10.hostedemail.com (Postfix) with ESMTP id E755CC0009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:58:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kux8ukpQ;
	spf=pass (imf10.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782201517;
	b=OysQbeBJsKkO7NFSrAPgP+gXFj+MquNYiax2H2nWhkMRz+mIgFLzUnmnTpBG8SfLZ+HHnS
	E8xMFjaBJ7ybB0Y/HmP8O37papy0pahfI8DKvrxqj+xshjubPZo5VtWYflFTUtJfonGuNz
	DbPms+3Om04cQmlh9msrQeiW1cdo7K4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782201517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ek6r0TkIKR0tiCQ28suwzM5bkNpctpIQyqr76NBcjWs=;
	b=hiq8fRdyXU0//Q7j93cdyw8JovK5koPN/dTqOkvzr4Iw98vObPGsrhKagWjIY7xDp51bmy
	jeM8H9kMijNq99xk0xn7OrStFt8U7RF3xmk92PZ/+HX1P2M6ANc2QWLJWMyOWPaLCKleYn
	wQxSklT/iGf2w5lk4b8YkUfD3qvwfiQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kux8ukpQ;
	spf=pass (imf10.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-8423f236418so2753810b3a.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782201516; x=1782806316; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ek6r0TkIKR0tiCQ28suwzM5bkNpctpIQyqr76NBcjWs=;
        b=Kux8ukpQr3y+Di78haDdVtucE89EXsenmzERTapZl9g7vHRL136R+aH4E1J+bIGmd6
         jiKHuEbSY7sCgdFyuYQv4BAhLcsRIG5c5CLnSsO8DwUV7Hws9/Vex3f/UXIy/kDRhe1m
         UeYkcpzUZvmYTyEwXmiCILriZAuEZBIT7iGA/FZim5Zj/qvNNHz2gt/pfJiOoYtM5sax
         Pfh6aks0RplUtw3H33CKhhvhax8HCyBQY3tUGcO6ydKM9AFN8jI2icxi4hteclKyZafj
         wvaLdr9Y1196WaL8jrkLXu4PWvHzkiFVmntxN5/aS/ydliWEQC1VZRji+GmZ0SQNK1aW
         zUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782201516; x=1782806316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ek6r0TkIKR0tiCQ28suwzM5bkNpctpIQyqr76NBcjWs=;
        b=Sj5U/yoMmEKWno0TAHKqyYojukR78EzmJ1lpGCqM5om6CCU1MXfykLsCspLh7DZpxT
         LZIz/+8E46mOpTsoCz0GoCHdhCxqZ1ZnEUyQXmFce0E7uER1feuWCgfQ5nGSIWLyZxS6
         Tyfl73hdm0Z9e2GZBWtq73cBm7rh0jw7cqpBmlW66+ZK+NTfaqKFWEM1gX6UgFvT/8f4
         DrNEEfnVSkyrCkzeaUalkWn3iiyee48zgLchKT74QCnQnKpMYMWfkGJka9yLh3lh4w4i
         W9k5eVGVF8IYEh2tQIxLafrFyV3FfuOXY/oW+vw77kR+Cv0jrfTdw6NTyM0KLP16uyx8
         /CCw==
X-Forwarded-Encrypted: i=1; AHgh+RpMQpmed6v9gmfgRPdecv0bhL+qskCL5jciq5Jeftcxo8SDfidGwAIOWA4Lg8sjbtD/56I9KwMcxA==@kvack.org
X-Gm-Message-State: AOJu0YxFHJoKFqvRHtXmAB58iEUogX188p0XyQMVpR5ZNMK7HBaNqZ2F
	4iovvAiyPuuvl88WxBdPFSUGBwFCDQhKzOIkrbcddUeDWRDKmZmvE+Cu
X-Gm-Gg: AfdE7cks5J/GnRCVWFh/xZ9TlFSk/DjVecANSFJSVKI2g8TXuhmhr3ibygQttrxN49h
	Pty49RzmGfMMSdUYg1hjZ31Vgofle1JAl2VxTi3rNWknCXELlpC7vXQyotL4sV/A4jiDomYbhLo
	4x8JWaQDCrOdtXkkv4tqcEpUW/BhdklzYAw5Vzh2hQNqP2a9YDtmXWczTiiuGlqwZS4Ktkcq2yL
	9cRHjzPziyLL0/L9+wabdTdlWl9LCDPAZlgT7u5Lav6T+qJUo4QgmYnJcYR7ElkfrlJf6VzXu18
	4+L81zu3gKdQJqmtF9KPNccYUCLjJphhE6uBotSXmVQaSOn6ITUB5uzwGmEF2Jl2mrLI2BlO4v+
	PLB5ho/d/zav23vYLkeTPRXPRzk4f5jOPXJBJm6RDNPbU2eHYE+Kzyau3hozdXnbYrSgh2S0em5
	CCHLx4kzoPWrsdXnVDpCo5RgGYFyJXhSDh3zKVg1bn
X-Received: by 2002:a05:6a00:1707:b0:838:29b3:9ed1 with SMTP id d2e1a72fcca58-84550900333mr19117203b3a.41.1782201515623;
        Tue, 23 Jun 2026 00:58:35 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:ede9:3e72:37cf:55a2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564e745besm9355930b3a.28.2026.06.23.00.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:58:35 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	bhe@redhat.com,
	chentao@kylinos.cn,
	chrisl@kernel.org,
	jack@suse.cz,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	liyangouwen1@oppo.com,
	ljs@kernel.org,
	loongarch@lists.linux.dev,
	mhocko@suse.com,
	nphamcs@gmail.com,
	nzzhao@126.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	vbabka@kernel.org,
	wanglian@kylinos.cn,
	willy@infradead.org,
	youngjun.park@lge.com,
	zhanghongru06@gmail.com
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page fault performance
Date: Tue, 23 Jun 2026 15:58:05 +0800
Message-ID: <20260623075805.466317-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
References: <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: bcr9zqznyiigtj1io1n8xuon8zxgnom6
X-Rspamd-Queue-Id: E755CC0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782201516-126338
X-HE-Meta: U2FsdGVkX18ljYajImGKJtJ31/G5PwWx85mGqv2EnVONnDFy4bj9CWKgx8tCt/HehaMrQpuevPIJlbPtJJJF/2O4jiLYFl3MKHtNJEqrMGKg1AhE/wd3CLO7aoqf2U1CrhoT5LdcWJAHuDQ4shimjTWOK5MmcHtQwj61p8/J4xX+gmlUqcOYG0tY21Kfii7ko8k7kMKwVnWeoxTXGJLa87z3dKUPRJTLwvSmYtVMFOFir4vcyb423PsBnKJxsNYQlGybZHtEzBlXx9hcAJ/mISxMow2d1RBPfrmAwMXzNojnJmu+TXCURkxuIZ04a6ocwBDMLnh+XND+xX4veEj1wGiPQkK98/3P2mtJWF0DhcA0Y3VBXkE5NvP+6lQagyIn9VRE1iz8/yAZtELIo2ULTIjopQvAHiMjhUgSrRU/0hj5skPUPisEe2RWqZ0pHCPPfEBk+iVoE55mFz0NMca+1II2xgJAHXxNg5Bkxg9/xBIXzfWPHQXHeNoFCNHXk/Ue8ifkh2Cr2Jx1jed8IU7kBYAOquJwwEfc1tBCWjWchtltKVDzCVriOfe1gPOZVhXmZ+zVrzemsY7E3OvUnRvKfhB2Y23fcJ33o1iAkSwSRFExzp+Hgwc1PwaRbEZZiYw11E1pYoEx0S5Up9KiIfXNk7uLB45bQPzynggLXtMIrSHu09ngGsWAjmZBobWu0kWJkNSbNZXrGQ4yWILuN0J+cNmj/v/x68cIZlFKZXmorQbN6kS1O5IrEGZigT49KrTQe+/hpK+1gkbAlYV4BiRp3D2I1LnC0yyetgbg8AV5HaX8Qt32GR8rkyIi2NbbTDz8DvMzzIwgNPcSgPTcJGHS4DQXpfWepGLWnUbnPGlrFiwr2QfFJIgtkjILZB+3aJkqZnjsstIS81IzipCYbndHPT/5tqX7hfCV6cAZ0FVVIWLxfrC6Bp82QxnBk0+QOUkH9Wr2ezWgvSict5Qm/v3
 HOuLuhy3
 9kU/ocEwUenMXb+bGHbLP8uGl0/mzmTlJ1KQm6X0n1lo9/ehgluf6xJBH9GvBuR0t/Br/F0H+e2+vA7X27vbzAjhyKMKo7fVMVhChl/rTHgBzI9BGg7zQei1Z4iunlum1JlPGeMBkrumtluOqYNHCnL7RKDl3K1AaGLRZVQmv5ii7+fo/xP8X06aKEXlH9sdJj/EHNnzmNaTXFYXlgc/4Cq6oSSyy+xDmd2V/zN3wQKdhay3a9EWJUI2zYsW/1iDqb9QR2pRrkVzTit65lHBW02KhzXXTp+J/+XPpju6vmb+EVkZjYWVbRO+JpHaYUGtcQXh63wqTM5/h7rLr4bjCF6+aI+AMCbTYNYx4zW2I0dzpRRKQLmpctQ1okeVskLjholcK2VL1kDf9k5VgC+SXrh9hmdA6u0tFMHiwhXWfiJwt3m7Lw0ffOdPNLKIUU9mBsvBv3ipv1Ozg5NFq/xPlWdDJxYJ7a/BEjSnrVesHiMg23++0TILdpbnN0T4gW/yjnGltLbCGWVBP3OJhDJY6ztJ+kv1ZTYhruh5a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 5/20/26 23:15, Matthew Wilcox wrote:=0D
> > On Thu, May 21, 2026 at 05:14:20AM +0800, Barry Song wrote:=0D
> >> My understanding is that we should not blame applications here. This i=
s 2026:=0D
> >> there are basically only two kinds of applications =E2=80=94 single-th=
readed and=0D
> >> multi-threaded =E2=80=94 and single-threaded applications are nearly e=
xtinct.=0D
> > =0D
> > all of the applications i run are either single threaded or don't fork.=
=0D
> > what multithreaded applications call fork?=0D
>=0D
> Traditionally the problem was random libraries using fork+execve to launc=
h other=0D
> programs ... instead of using alternatives like posix_spwan (some use cas=
es=0D
> require more work done before execve and cannot yet switch to that). I'd =
hope=0D
> that that is less of a problem on Android.=0D
>=0D
> I assume Android zygote might be multi threaded? Maybe sshd as well? Syst=
emd?=0D
> But I'd be surprised if there are really performance implications.=0D
>=0D
> Not sure about webbroswers .... I think most of them switched to fork ser=
vers,=0D
> where I would assume fork servers would be single-threaded.=0D
>=0D
> So, yeah, getting a clear understanding how this ends up being a problem =
on=0D
> Android would be great.=0D
=0D
Barry asked me to share observations on fork() usage across Android=0D
applications.=0D
=0D
I wrote a BPF-based tracing tool (kprobe on copy_process, checking=0D
CLONE_VM to distinguish process creation from thread creation) and ran=0D
it against the top 200 Android applications in the China market during=0D
normal usage scenarios.=0D
=0D
Results:=0D
- 82 out of 200 apps (41%) call fork() during normal operation=0D
- Among these, some call fork() from multiple threads=0D
=0D
These are not zygote forks =E2=80=94 they are fork() calls initiated by app=
=0D
threads at runtime. Examples by category:=0D
=0D
  Browsers:     com.quark.browser, com.UCMobile, com.xunlei.browser=0D
  Shopping:     com.taobao.taobao, com.tmall.wireless, com.achievo.vipshop=
=0D
  Video:        com.youku.phone, com.qiyi.video, com.hunantv.imgo.activity=
=0D
  Social/IM:    com.alibaba.android.rimet, com.ss.android.lark=0D
  News:         com.ss.android.article.news, com.ss.android.article.lite=0D
  Navigation:   com.autonavi.minimap, com.sdu.didi.psnger=0D
  Finance:      com.eg.android.AlipayGphone, com.chinamworld.main=0D
=0D
This confirms that fork() is widely used in real-world multi-threaded=0D
Android applications. Since dup_mmap() needs to acquire=0D
vma_start_write() for every VMA, holding the VMA lock across I/O=0D
would risk blocking fork() for unpredictable durations in these 82=0D
applications.=0D
=0D
Tracing tool (two equivalent implementations):=0D
  bpftrace:         https://gist.github.com/zhr250/bf4384202d598bb4cda71cb9=
902f15ab=0D
  libbpf-bootstrap: https://gist.github.com/zhr250/76189bdf51bdc8818500e4c8=
917c6493=0D
=0D
Analysis results (top 200 apps):=0D
  https://gist.github.com/zhr250/06f51092c84a49c602a55ac3d186e9ce=0D
=0D
Hongru=0D
=0D

