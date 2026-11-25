Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73D3606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 17:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z9jdExdz
Received: by kanga.kvack.org (Postfix)
	id DF35E6B0A95; Wed, 25 Nov 2026 12:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4526B0A97; Wed, 25 Nov 2026 12:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D276B0A98; Wed, 25 Nov 2026 12:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB306B0A95
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:59:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE95D4107A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:59:10 +0000 (UTC)
X-FDA: 85474402860.13.4487D00
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id D9F4A20009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:59:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z9jdExdz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795629549;
	b=MH+PtcNEfaqVZ+Gyl+G2RTh53PCfN9bAtfP2VCLCzDFBqR5N5UdO3YIzwkhXvvJ3Kqxzol
	xhuxXeN3/slc4Faah/Jg6HuWTwfQgmA2mANrv35NuDAkN4fau+Vx6EQdu2WfIIx8+mkdtS
	FS9+NMnsjasbmjbXCDfGOisUKu7pLD4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795629549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3ql+trEST5GBe5icgHLs8egrkIrOnsTHov8GZtBedQ=;
	b=ltp95pMQODdcqILo6hG2u5JMALsAN3Ovh3X9e7tVZfB6Y4H3eQI71MAFVJf0krtYxshB2j
	hm940JVDB/PBglhUGKnCFvtJtLGOKq6KMB8QUHKXiapSFKPGntr2lX//cBMNaxGup3AyGN
	tsObpBzeWNIatnWLlTiu3zN+2Zv6J4o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z9jdExdz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b501791bb5so340224a91.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795629548; x=1796234348; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=V3ql+trEST5GBe5icgHLs8egrkIrOnsTHov8GZtBedQ=;
        b=Z9jdExdzuDIXKnOaLY7+XmXQUtfl1iHvY0i34Ex0/pBTk4Xo8Y4UDXDy7bPkfIJlQk
         8uujEeESRVH+GAueepzt6ddN06FdHMDD4c50ru3OZC2hSVovkkKd+P0P6peNfJ8kjgyl
         6funOlWIJLiht2mMWlkhC3Tv0ODCQiPdRHSPU2pCQnPuOPQYmJch1zPQu5IHE4TtX3g0
         +S/8+53Sr4J8XclG3vd1OFhgUV4wLsGSsKpYbmci5305JoIuIaME6t0+hG49PlDuIUJX
         TEBjljTN4DRP8obZy+SS+DNDFNpuJZqb2+3oWHYtv66TqFhF18u3RK7WnvB1CLMOHnpu
         LYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629548; x=1796234348;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V3ql+trEST5GBe5icgHLs8egrkIrOnsTHov8GZtBedQ=;
        b=F5+oKbtb8FYUb7u7izIX+ezvNv+sbuV05ERz8KxbUc2iXiLxzvKUxwdcCX/ws70pk4
         UV1OjtmwmcTGNnRB2a2ViP1Ry8pajhodnYfcRb7gRMZtLiDol1ap6l5xF+FiQgayuxdO
         hs2LvZsF5uj3SJJVQrDu3aMpiXWdRExyKAyRjNODX98v7RteZ33tsY+agb6hiBPVza9q
         IYgFLUwuhbhfgMYZ9oubY887EvHJ61CLwiWxQwE5se8zDUl7x1bHWVJHuq6TlK373Ew3
         EPjyDujY2+MDP154c+PGKp5oFS6XhwAwQpQcfZJMhidA3kv9zlcL30VeuPG1rg/ZUEqd
         siEQ==
X-Forwarded-Encrypted: i=1; AL+hErFrgXxQMlDTbETs36pTsltQlb4q31CGwq3Bts0uW4e66SIRymkI7RnkGgyJPh+POmO13CJa8J61bg==@kvack.org
X-Gm-Message-State: APuU4Z9LOH0Ys8JM8UuPB27ZqLUFpb2HBBWcts75qbwBbKOCZpXoHmRk
	Ceqcgegl8pg8otMGSWn1O55lJSL4xt98OHoE9QOGSLDoUf+bjlA/HI8yVRLKqonnTw==
X-Gm-Gg: AZFdTZe/DA71SIMg/QsH1uesoM7gBX/7xtMf3TBzLXoumZ6p88VeB2xuwTaIgODIRH5
	xwu1qWOfxYq8i35T9jJVEl/ppniB7WLrhXG2JozrshgpFBddk5/U1+dOzGRaukzvdFca2txt9Fx
	KDMQ2586wQ4EYB/kEeka392LF3+2GYJWC68uID/k2OuCxxdka1zenv5FwHzwfRqAwfa7CeunxAZ
	5PdkcN3SkTzEl3SvmaQNJtgj7iDXOZu1Cc2TNDI4Rp2x0co90z1aGhAbXPtWtUlD3V7wrzgq5fu
	wQ+0YF9yoqlV+rkoDGn+GoaZyR/x/4w7bCeUf6ylF6vZiGz+tMp1CWdRK3AU7T9Y3DBRCJhZIQJ
	hR4Ie64ckPUoqQPExj+n1UqZeHzAwPhF8bgSmNyW3MAMhmnROr2fj2Uk+/6E/ngPo2GgmyDdYJ+
	S2K2nfeYqfFprIfpd91Cf5Szolz5VzhjiOp59U1FfK2OWQKYCHFauQDUe3ybLF6vsevTTL5+Zf6
	YH9lTgKUG2p8kJAA6hOFreFK222tRMGlYSxUCIvdAThfUbIbfyU2P0UerknQ/LeseukpfmXLrw6
	Fd4XdcGAaf2sWBiAQDmRrmFSZgDcCQeLxSYU/kkVE/Hg9QJpmCcmgolowR81uO3S
X-Received: by 2002:a17:90a:e7d0:b0:3ab:5832:72af with SMTP id 98e67ed59e1d1-3b41c9cfc12mr15413655a91.32.1795629546987;
        Wed, 25 Nov 2026 09:59:06 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb2076sm29085960a91.2.2026.11.25.09.59.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 09:59:06 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Nov 2026 09:59:05 -0800
Message-Id: <DN4HJTFG5WHY.1BIGOM7LNESZA@google.com>
Cc: <kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <ajayachandra@nvidia.com>, <alex@shazbot.org>, <amastro@fb.com>,
 <ankita@nvidia.com>, <apopple@nvidia.com>, <bhelgaas@google.com>,
 <chrisl@kernel.org>, <christian.koenig@amd.com>, <corbet@lwn.net>,
 <graf@amazon.com>, <jacob.pan@linux.microsoft.com>, <jgg@nvidia.com>,
 <jgg@ziepe.ca>, <jrhilke@google.com>, <julianr@linux.ibm.com>,
 <kees@kernel.org>, <kevin.tian@intel.com>, <leon@kernel.org>,
 <leonro@nvidia.com>, <lukas@wunner.de>, <mattev@meta.com>,
 <michal.winiarski@intel.com>, <parav@nvidia.com>,
 <pasha.tatashin@soleen.com>, <praan@google.com>, <pratyush@kernel.org>,
 <rananta@google.com>, <rdunlap@infradead.org>, <rientjes@google.com>,
 <rodrigo.vivi@intel.com>, <rppt@kernel.org>, <saeedm@nvidia.com>,
 <schnelle@linux.ibm.com>, <skhan@linuxfoundation.org>,
 <skhawaja@google.com>, <vivek.kasireddy@intel.com>, <witu@nvidia.com>,
 <yanjun.zhu@linux.dev>, <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 11/27] vfio/pci: Retrieve preserved device files
 after Live Update
From: "David Matlack" <dmatlack@google.com>
To: "Vipin Sharma" <vipinsh@google.com>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-12-vipinsh@google.com>
 <DMZMRTXS7OSC.M79XF39ZVEWE@google.com>
 <20261125003759.GD3545683.vipinsh@google.com>
In-Reply-To: <20261125003759.GD3545683.vipinsh@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D9F4A20009
X-Stat-Signature: jir4q1aenxsjo39xniixzfkey74hby7h
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795629548-326068
X-HE-Meta: U2FsdGVkX19blC7OOFmqIBXxJF5qCuWP8TS4m1zg2SNHL4byzcKaVftdq/s3ya01FbHNJbn9Hz+M9AV4z4kiNGV8bpyxTxfDzRcCGT+EZHgRr14/biGcwvz/DTB9iY2Cu/jk9Tw27Cl6TgdhBy+rctj+ZmARngd37Nlh0gzAFPzzuv/8xg4dxEtmFn8ilNwkthSlu4LsEJtFVqc5CkrH0fHR4wKKiZoOv3/MrgWQM2GLxvImMl338H1RYZpUMJ2B8u23QkBhJd2dDILT25p0OEm3pgoi99NjFXEoPTdWm+wmSLNCO+gMSwEs8zFvW3XxnuppJhsxKd4Mgmj3WZRYOucROTTP0359jDycRlrUI+y6LOpiLY14/+KoxSQepoTX4mUNPivShSgdyen2z/0OYJySmpEM9yk0z9N7/8vKjGWwDm0P50WP7v7BhkRiZ2caOYqZB/NQsaPYH1MHbJJBIw200+1YROOdwcU4jVtXupp5VKuu2eVaZlibOH+J1PuM8UMVPxBQ522snCj4SuRqnpMj8ynlSJX9KQT2xDiHPSSbb4/eA6EhueL7I/kVKPQ26VFQ2WmlJdD1G6ev2ZsCHgo2lsxKlPwcnlh00833Ro18r3zR7c9UT1bCkfp6Txm7hj/UA4TbpQSUVGL5UN1nZlYuFfthruYfDOIL5RjjVxKL97stMI/CNJQmnXEmARKwQE5UvcJSX+0Lm9b6YweUhUBV8GdswB5Gc985eBRCu/ypTvESt3XrjvGNbyuVgBWM43wrDzDIs14GLCLHdwekBrYR+mqZ3jhL+0NMENo9PK/W5mJ+HFnVKHEhBp8gDqQBeqni6hjUe6w3fucV5JblJLFj9EtNai22XzrsD0mjYyQdOD48yVEkVPuEn5f5pKy2mT7M5mkUY1WfXwxjxFD/JyRONd/JykHBo/xzEDw5Aw/SNSVp0yQ7Z3xO7l4jurbdeFyHzVpSNeFvs54m/C5
 cpmnZ2sj
 ma9nkqfMKOe5lkzg8A9nT+NpZUPCFuaglxyyvHUF5Liir9mzrMQmSq5Q2m4sl3BMQQHpqhps9IoJiFmR6+8CRSwQuzn7arSaTFarWkks8CAUdvA1EfAZqeypGGOE1q6WDddlk8wjIfHeiGemJimJ/OorEEAdyJVh7YRSLd1c4SbUKw4mJzWUjXelNolHE2o5T6MPNB/x77hWLfF+8AVQ+fIc4tYP01j4Kv8K99uEYks8RgC/Y1yxu/9ppm3MNkQCjT3CcXV6x0Z54gpBvy7mJALuqOe4Qb2ONYHIimvDWDWTjZjuUirlXVcfmQM0wRxIJPJ+IIelOTbsye+4aQ6jTSQ2Mhe/ovHhbh0yZRmqxPyEEWanjVg9ATZ0LWEuBr7pQ8ymza0YcdgvLSHJ/MziDKWgV1X7SCh0BX0isqCFLrH0+nrkM3WgZAaWJWMvzlg3z8d+xp9c1uJzs9B86ky2/XFrjvLe1UpOal1d4621Ot/8DUYb667FCXwZxk/MESAYEWqeET7nB9wou8kXQV1X8qYfhv9yGQylyQAkXui4RCb4KiWguhB0QqicN64iB1i0tJ0xaBNrhlWuqeCPTUzaX004IPavYsHyhtJdw/R3dOjHLdk/OkV2P0tubg7prbm/27OYL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 24, 2026 at 10:55 PM PST, Vipin Sharma wrote:
> On Thu, Nov 19, 2026 at 05:01:19PM -0800, David Matlack wrote:
>> This is a lot of complexity for one commit, and it's hard to review. I'd
>> like to start with the simplest approach and build from there: implement
>> can_finish() and have it return false until the device is fully
>> retrieved, i.e. retrieved and taken over by VFIO_DEVICE_BIND_IOMMUFD.
>> Then finish() only needs to free the incoming state and call
>> pci_liveupdate_finish().
>
> Closing session FD is not retriable. If it returns an error then
> userspace won't be able to retry. So, only option will remain to reboot
> the host.
>
> VFIO doesn't need to impose this restriction. We discussed in LPC to not
> block finish() as this call can only be tried one time in LU if
> session is leaked.

Right, if userspace closes the session before taking over all of its
devices, the session is leaked and the only way to recover is to reboot.
I'm ok with that in the first series. It only happens if userspace
misbehaves, and the device is left running with its memory still
preserved, so nothing gets corrupted.

I'm not opposed to improving finish() so that it handles devices that
weren't taken over and closing the session always succeeds. But that can
go in a follow-up series. It doesn't have to be in the first series, and
including it makes the first series larger, harder to review, and harder
to merge.

>> It also has a nice side effect: LUO calls can_finish() on every file in
>> a session before finishing any of them, so a memfd in the same session
>> that the device DMAs into can't be finished before the device has been
>> taken over.
>
> If userspace has two session, memfd in one and vfio in another, we will
> still have risk, where memfd is retrieved correctly and may be
> closed/released due to a process crash but VFIO device still acessing mem=
ory
> by continuing its DMA and potentially corrupting memory.

True, but resetting the device in finish() doesn't protect against that
either. The device is only reset when its own session is finished, which
can be after the memfd in the other session has been freed.

With iommufd (i.e. not noiommu), memfds mapped into a VFIO device must
be preserved in the same session, and iommufd enforces that
dependency [1]. noiommu is inherently unsafe in many ways, so I don't
think we need to worry about this one case there.

> I am still inclined to let finish proceed without blocking via
> can_finish(). I can try splitting patches.

Please go with can_finish() in this series, and send the finish()
improvements as a separate series on top. Splitting them into separate
patches within this series still leaves this series larger and harder to
review.

[1] https://lore.kernel.org/all/20261025021930.674647-16-skhawaja@google.co=
m/

