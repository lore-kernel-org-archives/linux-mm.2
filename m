Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 513C8CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A958E0006; Wed, 15 Oct 2025 04:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FADE8E0002; Wed, 15 Oct 2025 04:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9A88E0006; Wed, 15 Oct 2025 04:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA888E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:09:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEB51476F8
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:09:36 +0000 (UTC)
X-FDA: 83999624352.15.505D1A6
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id EAD70A0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:09:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C0nX2Jsz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760515775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nlu0iWLQsMmMwx8BsiN1pLQpSy/Cs0W61eq++3d0upY=;
	b=fx5ZeFaLpORB4hFrrREW0xDG6ugvY9ZQjo24bDAZo0LaADF5qaxv0ZAnH8Hn8++AqvIpg/
	JllKIsSXjJ5uo67VF3T4QSORgMDmgg+VqrQYpEyHh+Or7BCJaw3hvX8mi3dCBXKtfS8UjI
	XVHFLW67BpkbsziPsFrz6GnfweKy81s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760515775; a=rsa-sha256;
	cv=none;
	b=YhBvER50YhqXtcx43v92m/ZTcEW1JrEEmKYpWlpBYLSnndIzAOIeO+2CrOZbSsNsiFQGrf
	eSumQIpj4CUp2kyODVE2KtMfC6ApPE1k2Oy4+A+NijYnP5ejR/zDD4HtbYcb1wVYE1sZPN
	gwM4Sf+RW18H2r8BHx1K2FL5m1XE8TA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C0nX2Jsz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b62ed9c3e79so4048815a12.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760515774; x=1761120574; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nlu0iWLQsMmMwx8BsiN1pLQpSy/Cs0W61eq++3d0upY=;
        b=C0nX2Jszp27P1w/RqKu4Ju6vqbjrJExf/SAetWZHJB5/LlbxIgOF5lcl2srqTJh+pM
         LPjg67ljJ/pEOhSEwqOvkBw83/osLFLGGAly9P6SHs19GtYwpSLwzp8U/2JSPtMZ4XCu
         VZOncRoZJO1ArF8+642AbDtwB8Hwbk81d5sK8H8lTDFRT0JlOCunHRY7kaJ816fB3mv2
         BK9wiv2DgPOIjWhxu70SlIyEt3WB+o4IciKCwzx2zc6YoMd3uKqtoOMjkHkfqL/qGz6F
         1qnwZtVuN+Xz4r5SKcdTotVEmHNVCx0ab/RrWmC/Rt3qMrWakOmzsK6sGWIJdeer4bnj
         eJ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760515774; x=1761120574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nlu0iWLQsMmMwx8BsiN1pLQpSy/Cs0W61eq++3d0upY=;
        b=EJ2Qrq8D+B7a/O30xUlbAgMifwhrl4vX1OtGcqKwhWiZsEbtE0bml4QgY3u7DN+7pu
         BX7zS3WpoeXbLqqFMNilsqzGcczNRW5xmq+ki1/25k0v/uUvQZs3wxS1cjXm7Ffzk44j
         vtBuFU98zF2jQh36AljBKJpz0iiV7IaduIvuRWUqy//Jpe69TazQV/9IBQGfgKou+qCf
         vG3LQUUxFbwgCaVlyqemfsEAoUgcZFaVaZPxdk4gmBlHUfve3zSvJswZfK4duN2BTYwn
         lE/ebFIPSMVnGHp0pXPnXrF13D6YCqSX2fqGl/36M0yWqI6kZTvH0mCElnDbSeAoaLeJ
         KVNg==
X-Forwarded-Encrypted: i=1; AJvYcCWeQiM3tm4TgWL1r0pftImehp4E+LmvqwGJ1uA/mpqEMCjUt9cgqhVGL3hoxzJY2R8FVh7nQc5qHw==@kvack.org
X-Gm-Message-State: AOJu0YzYO8oh3aQPofTutZI0Lit/5wd5jkgIcVA8qIJvqiYF4k1yRcKu
	M4NqthPCEV9mSTYnLMBYyKQnG3dafOYyRg/2ByDBRB/hFyrEGxP6mEvd
X-Gm-Gg: ASbGnctIafCaZjEPIXxv57LbWDcPJk2ePgmAO9NhQqN0pSvmVakPnVNHPZS4o74PEK+
	R/XsyjGrNs6U1vfN5m86JsKVvySQQWWOdLpFnW5PhMvauRng4Ols1jqWoJwRLqfOQOU/xV03QuV
	u4X1puvxGE25sMX9gXaGgEggnP8/i+nwCQA3rNeGunpCdGNP5hkM3iukgS+PTwd/kuNENZur3hO
	8nZza7CT/q7mZeImna63p+8UYiRavAiwwWl7dzexCrGSXUqehjm+wBXFvBtQvaas9bioOmAxypk
	WkEptV40cC7LYcacNioLuTm7fDCHsN0VF5hBaEhDk+weLx/hDv2jNc3Sk58eGtFkON5bWEudk8K
	KCOdyIlPc6RADkoYvvpZZcsyM4SahdE0A7ff4n0LK1AU4zLHZxy7ABNItfWJ34WWF8a0hoF4Lg2
	G9h8m9hYcBU0Cn
X-Google-Smtp-Source: AGHT+IHxSeFB7K+XDZcZzDG2X9Vzop3nq0OS6ymARYFxyzEZHqsN0AC0/LZ8W07rCX3tY/oRhPoYiA==
X-Received: by 2002:a17:902:e952:b0:27e:f018:d2fb with SMTP id d9443c01a7336-2902735667emr355871965ad.6.1760515773352;
        Wed, 15 Oct 2025 01:09:33 -0700 (PDT)
Received: from Barrys-MBP.hub ([47.72.128.212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f36738sm188270415ad.87.2025.10.15.01.09.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 01:09:32 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: chrisl@kernel.org
Cc: 21cnbao@gmail.com,
	aaron.lu@intel.com,
	akpm@linux-foundation.org,
	bhe@redhat.com,
	kasong@tencent.com,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device according to numa node
Date: Wed, 15 Oct 2025 16:09:25 +0800
Message-Id: <20251015080925.4008-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CACePvbVDB9-r3dTTAJ8e++1swAt9=fPRK9ex_30L=FgXBe5BpQ@mail.gmail.com>
References: <CACePvbVDB9-r3dTTAJ8e++1swAt9=fPRK9ex_30L=FgXBe5BpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EAD70A0005
X-Rspamd-Server: rspam02
X-Stat-Signature: kt6cgzhjbpsmsdxjb838sy4c7fyzydu8
X-HE-Tag: 1760515774-719585
X-HE-Meta: U2FsdGVkX1/lGFRcGG1O7+ByGm4ArrXqDe67xj0VI09kAupjvcnjhCx65Tp4D/Vm9hNnbOjHQ/llecIjU4vfNM3p8dwXqZFELdH7Ezj/5sZgJJYeyFk81ubmGVKhjYYl/OxQPKAa4bAdde090LC1BnqFEZksgPbuFcV9nupbUexARQoyj5isq664CRstwtR8WAYzabcrvs/AXfWOAfhV59iXq1C2sx4dB4y3EYGPhQrdICnQZgKQMnpPrkVExbng7/LpZcTHif/T7r5iwJToczio5W5HbTDNbpCYBDHniiME6nI5KeBiUvwVAnPzHgVqMlKEzdAOBQqo905QIaahoBnyYBqHcGroOfK4KbfvZCBxNbZZYutXBQrXvMQHGcWdooFRK8ANeyhN9cwkphFPXzx7533ViyQvooZcnlBNiPlCp7wTybDoPJj4FEwCGV9OMBtBNxBaNz4WmFDL99X4xN8bM9INRmzq/b1YFvi/dIit0lAeqyhRgOQTzRvNBWiuZb9fiMfVBDjTCx42i0wzewJziOeckjO9sfnC1qkkJCTMMNxrKk//TdvQYBaeGCSe1Hv7ZKs7ZaSrk9Fe1fifG2ANjC70bgrB2zzyRsfOazaqQB3lxqaSiuv8ZESzRXQa7RNrtHFuL5RX1AGc0h8eO3hwmp+/jMyeVE6dhjbex2Z8Ta7vdBF9rd9ZgsvNLKJvh6eXo4uIfweZEx++dU52xLnU9zj4TY76gw9hKqs+QOcfwRLWRc/RUL/nhq3Ybj4qhSpr/yC4IEWqEpgzD8sZU9Bunsz9DetzWxS3JKdOyAnc8wBHlTZptMl+zGwU1g887WbhRpKPnzfG7+kuQQOVSdt7zhvvzcju3tjZL3Y/POQ1BigM90queaMh5nO5+gxMv+OMGGj/mIDYEOZRE45sL7OoD0RID9I9GXwVs4dRpZPJ3a0jobG/WQrmn5e5T4QBfalmzXaHO5Tdxi+99xg
 I0Z0MdII
 jdK0ZOo+qUEV5g4CzP/YJIK7yuc4nKpOaFBCQnhSU1D9AkvQiqmzVO962OWlAVgqmf14bRGlqKNtuh+EPnl+kNvrJkIP/2mj22pFAguj3nKO0BQ1iOJkiu1esgE9tpoPcM2R4j4xdcEonlVi+VHxkQgoon3t5MAZzxWZeIiJRIv06Khy1iERrcZDRPQcGR8ieVnw4K3MtGejuuBh/uud/MwGxF/ibA1tVHduTsfU79T3XdIi619HuuAnJWzwPGJ4bLUNTC6tE9ym8ctkBEnH3WG+2nEIS8TfeSfrsy7BM7mXPKmKPVpNNuY/OyleJyQ362H07CDQ+QFxoshW5SFI95ftz8U2gJevvkcc2syTXNEY2wwsKg6DaicRk3DS7IY7WMeAQknM0tFUzrJnsEtlERpdAzVyAlNujz3UahAIQCZ5vhb0E4Gjm3hOiyfCDPsyzbnAJWzkd0qXszypruWqcv3AcmisgQwaMe443rx0zhjQG0xkYQAdHMqkfqAGYEYsM+Wwp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> >
> > On Wed, Oct 15, 2025 at 11:06 AM Baoquan He <bhe@redhat.com> wrote:
> > >
> > > On 10/13/25 at 02:09pm, Barry Song wrote:
> > > > > -static int swap_node(struct swap_info_struct *si)
> > > > > -{
> > > > > -       struct block_device *bdev;
> > > > > -
> > > > > -       if (si->bdev)
> > > > > -               bdev = si->bdev;
> > > > > -       else
> > > > > -               bdev = si->swap_file->f_inode->i_sb->s_bdev;
> > > > > -
> > > > > -       return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
> > > > > -}
> > > > > -
> > > >
> > > > Looking at the code, it seems to have some hardware affinity awareness,
> > > > as it uses the swapfile’s bdev’s node_id. Are we regressing cases where
> > > > each node has a closer block device?
> > >
> > > I had talked about this with Chris before I posted v1. We don't need to
> > > worry about this because:
> > >
> > > 1) Kernel code rarely set disk->node_id, all disks just assign
> > > NUMA_NO_NODE to it except of these:
> > >
> > > drivers/nvdimm/pmem.c <<pmem_attach_disk>>
> > > drivers/md/dm.c <<alloc_dev>>
> > >
> > > For intel ssd Aaron introduced the node based si choosing is for, it
> > > should be Optane which has been discontinued. It could be wrong, then
> > > hope intel can help test so that we can see what impact is brought in.
> > >
> > > 2) The gap between disk io and memory accessing
> > > Usually memory accessing is nanosecond level, while disk io is
> > > microsecond level, HDD even could be at millisecond. The node affinity
> > > saving nanoseconds is negligible compared to the disk's own acessing
> > > speed. This includes pmem, its io is more than ten times or even more
> > > than memory accessing.
> >
> > I agree that it’s fine to remove the code if the related hardware is obsolete.
> > I found a paper [1] showing that accessing local Optane PMEM is much faster
> > than accessing remote Optane PMEM (see slides 4 and 5). That might explain why
> > they started the project to make swapfile NUMA-aware.
>
> Are you suggesting the swapfiel is used for PMEM devices? It sounds
> very strange to back swapfile with PMEM. I am under the impression
> that the original a2468cc9bfdf commit is introduced with the intel SSD
> as a testing swapfile device. I just looked it up. Here is what I find
> out in the commit log:
>
> ======= quote ========
>     To see the effect of the patch, a test that starts N process, each mmap
>     a region of anonymous memory and then continually write to it at random
>     position to trigger both swap in and out is used.
>
>     On a 2 node Skylake EP machine with 64GiB memory, two 170GB SSD drives
>     are used as swap devices with each attached to a different node, the
>     result is:
> ======= end quote =====
>
> > My point is that we should at least mention this in the changelog to
> > honor their past contributions. But since the hardware is no longer used,
> > we can remove the code to reduce complexity and stop maintaining it.
>
> Optane was not even supported in Skylake. Commit a2468cc9bfdf has
> nothing to do with Optane. The Op]tane talk in a2468cc9bfdf is just a
> red herring. I fail to see why reverting a2468cc9bfdf needs to mention
> Optane is obsolete.

Thanks for the clarification. The Optane discussion turned out to be a goof :-)

Just for the record, this paper [1] also mentions that accessing remote SSDs
can significantly decrease performance. However, it is rare to find any NUMA
machine using SSDs directly as swap files without a RAM compression frontend,
so I don’t think the performance penalty of remote access would be a problem
when choosing a direct swapfile.

[1] https://shbakram.github.io/assets/papers/akram-caos12.pdf

Thanks
Barry

