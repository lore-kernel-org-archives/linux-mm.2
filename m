Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBD91C98318
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 01:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919806B0092; Thu, 24 Sep 2026 21:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CAAF6B0093; Thu, 24 Sep 2026 21:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791DC6B0095; Thu, 24 Sep 2026 21:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5746B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:20:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BAA87804AF
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:20:22 +0000 (UTC)
X-FDA: 85250529084.21.317F3C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CAE5540008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:20:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cm52eBOE;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790299220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXTKsI2Rsvq9x6jxxmZAAixjI3Oi6YwBiX+NqIKH+Ic=;
	b=7HNLzT6Tdo9Ftv2kh5kYPGIVWZddXNbzr0SfXExCLyZGR4J2c8RM3KYKiCJQwFEXjFS6fS
	mWZ32mBwLKN8+Ow73Bd5gMygHFZQRAPyYcXI/PURhNCed8pGHIRlhyj7rXlcVpgTIFnalR
	Z2VfEwQEEmvIFSwvOcV8QUJ5DsPxR+Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cm52eBOE;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790299220;
	b=hLGPDT2j9dje+xnGGkuyHGJRRCxBHKW1cDHZN/Q2MRIfDtGopt0z8XAjXO2Qt5r9PuQLoN
	tnG3eoww59imZIyKz+IYBNw2Bpd31EdSpwv0YsMQeX6iQlTdTvrKA8r0VgtnHFZ0UKsKyP
	LEpkGSbx7Wv66rXTU/AEpzmZ1UR2GKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA3554477E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942031F008AB
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790299219;
	bh=MXTKsI2Rsvq9x6jxxmZAAixjI3Oi6YwBiX+NqIKH+Ic=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cm52eBOEOJyH7FvFAuC+pcmxCDoa5HbOoVxLQYrg/lSVdMMvHPGEmpg3ysTiKhuAn
	 zcOKVc2kQyEQ+i5wXn/NbKzSPTkIhl1V7yJKi1kXsnttWQ9mw0RyKgr/ga2s/43R8q
	 cT9IYsS59y9b6pSWqOKy6dFKZhB2ilO/kj9aBY578FnxaWRwEcl/yRbl6jVsohfuyE
	 1d524GBrPFZ1pgSgjmuQdoepwcaMAUvzYuODLSz54RoagXXFAJFv9ekniaYYZ5sYUo
	 k/jwBUQwZ0bXXKUA99VtKfoDou9RCOzK0HZXLCUuj+tvvETvq4ynIAPWG+ySqtN3mJ
	 90oWGINpNMqCQ==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aa8d881so618501d50.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:20:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz9z6VG5tWEgNSRT/TDiTh/zNvh+j5Th35nWiiNSo6LtHLlMGU+Qx165g6FK2kvV+u5v1pxU0+jqQ==@kvack.org
X-Gm-Message-State: AFuF++kR8GQ8aW9xdBYHNlgIRBX7E4yUF6b5YLwtWI6YB7JFs3Gr+Zgp
	Fh1Xzy6+2+gUanXAZ9I+FcYV5SDo2cj0sIbyVyQUaKCVCgHI8+y10UdoeYD4wxiNGY2msM+WzHl
	ZNtOMQGvNowqHPHSkfNpYa7HLNyXh3dkB07lgUynR1A==
X-Received: by 2002:a05:690e:1243:b0:672:a52c:daf9 with SMTP id
 956f58d0204a3-672ed5799f7mr2394820d50.108.1790299218900; Thu, 24 Sep 2026
 18:20:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
 <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com> <12541da81f59db27af46096db8da5d425135a162.camel@surriel.com>
In-Reply-To: <12541da81f59db27af46096db8da5d425135a162.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 15:20:08 -1000
X-Gmail-Original-Message-ID: <CACePvbWMd+SVgriqB=ZU=kmAL80kc+iJ5x4TMc3=gn7py4Ly7g@mail.gmail.com>
X-Gm-Features: AclHuK9gGTk5UE8ppsRyrlKYwHfPhyGpjyyw313XzdHKkR1g0LFZou0vHIdSdx8
Message-ID: <CACePvbWMd+SVgriqB=ZU=kmAL80kc+iJ5x4TMc3=gn7py4Ly7g@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CAE5540008
X-Stat-Signature: st63uuhhxg875wx6f1xo1szywwe6f4us
X-HE-Tag: 1790299220-471669
X-HE-Meta: U2FsdGVkX1+hqDRsjq6ghuTQChuJbbuFIE2+Pizq97ew/G77sp4vegB4Ge/UfwFvaE98fbNvmulYeUlgA2rfbJcbMFKyzXKrXjLIw75zJa9E+depKDCuVRGe55IBGAYlHUapRV+2ifhlm+63FWwMY4R4dlmtkoDR5zNUsGql7iOaexnXql1L0Mr+Gaovj9J+03vnkUw2rM8yrFQPZk1j8ojrjkVwPORLH9rfsXt7Z6qEyX1ALK1Ag7+jKU+wcTSsxUPtBGQ9CIBUM7IhacCsfQqMYnWykA2wW+JQp0PSjhHnbz9v/PVYqhxgtqYUSnTSFvHkWfplpUAUkI4vXQ1cl0OYALDjUbOGU4i71WEhzmLct2n/2e/wqCQFdemQb5KNRsP+kJE/EmzgJE4Zg0jr9BRFUzRIkJiXxu6AnLJhlrIKHsG3eSp4HzfijNacjtzHB2kpUxsLhU0kADZlvrghB3pH2VQZNmPftAzwnM+yMjCA4ckKeYcW0kupyzkL3LDVAKmxCAW5SsNLJeEsXdekTcJfCK1cniiIcYFzySbs2PWqttxwxu2sozQbTCjMcjMElFnUFpPFctRdxh47V0MX4YMrx/PeFoXJLrOCW32xYARNNnN3dO8pHQH7ckvBdhlvwtkTaA41dbJNC8A2+nQTFWIbu/d4LjivtHiS/Ag/nbO8+AmMpN41CXI/zMAS+YoyeunVZ6iEDsOxjA/M2gjkraPOwvvmTzIsIhU3etgVrpa9C6b/KmJi/5WQPfmfd7p61R1RtbJXzCad11qfmAO0fSlPefQ7RwrUCEFtwcDwOs9ZguW678it6NEm2K/uCWDYjsCsIvypLYweWCxEYlUQ9nKKawp0bFGdzycgK9u6+Awp5Fwa2E3gdDr0T4s9Fj30CGojC8LS+tBbKwVkfbB9PVxQmQ7NFN54e1gn6eQ62XzkU83mfoQjHGseSyqE0jWnKe0Uodv+2A3b6M8/Gqg
 9bWafjOF
 DGO6rJEXwY0MgiB0mL3fbOpdttPhFq8tQF/UxTws89D5btlFz0g0u/KUnqFKx3i2eeUsaGRvxyqQMAoiKrf9yKdK8ZWRVfOzopEtsiQCRmy6anVe4Hh8rbknR11WosEj884rzhHzk6bWXgDRHYIGo7Qrp3PxgWINK39dKVTCeQ+NKKmRy/9H+mMZ3PWyKQY3Mc3lzGAJzewwC76e0HBKIDfL5t4Gsh5mEn/KwsAkCEX8WRzIsf6aMRYmnM2OEW+6VDnQD301LlnqQ4cu2T6SpSoU5JtbA4YyfceqJrN+IWMVDyXRAlNkVCFdeb8PkVdO6q9Rv11y15ynuRwXkh13H/SsjeMzq0i7Uau6aDYOwtHs19tfgAJiQMSk3RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 3:15=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Thu, 2026-09-24 at 14:43 -1000, Chris Li wrote:
> > On Thu, Sep 24, 2026 at 6:20=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> >
> > > It is needed because vswap *is* a special device, with its own
> > > requirements. If you don't special case-it, you'd get undesirable
> > > behaviors.
> >
> > Ack, that is why I am against making it a special device. That is the
> > whole idea behind xswap. It is just normal swap device implemented
> > via
> > swap_ops just like ext4 is a file system implemnet on top of VFS.
>
> The filesystem layer is relatively clean because
> it has a VFS.
>
> Are you saying it is time we have a similar
> abstraction layer on the swap side?

Yes, you understand me well. The swap side VFS already started as
swap_ops. I give a LSF/MM talk on it as well. It is already cleaning
up some ZRAM special cases in the block layer. That is what xswap is
building on top of.

Chris

