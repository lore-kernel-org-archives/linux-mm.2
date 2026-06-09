Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86981CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF566B0092; Tue,  9 Jun 2026 10:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87366B0096; Tue,  9 Jun 2026 10:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4206B00A0; Tue,  9 Jun 2026 10:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB58F6B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:49:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F001A0611
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:49:30 +0000 (UTC)
X-FDA: 84860657700.19.3385760
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 94A838001A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:49:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erX6JcxZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781016568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=taRgX81yJwI75jVPUy3ya0pHHgm8A4dha5HwvheVriA=;
	b=ZlKWYpykvlusWsdX3mStARqGY2PN9SmpSrEl0hpEqarafmCBaxlK4JMBAYMQtN2rKlW6pV
	pRcuKbkaGAXQmR1mCZJ+ZE/B3P4+NDWQcrv1ZkboKTKu3JTqkyxgS7jLc5pjSbDvEv0pMY
	hZ2E7Qc9NQdjpFOPXyWVdMtxjINmqQg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erX6JcxZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781016568;
	b=JQrji6nvZFf20/vCaVTPzyoDs/E54W5SkJ/2QZHF41BD0fPXSNphdXW4B89JZIk/xpNPRU
	AlSTanwLpdnKykdGyo0dSNz1RBWkfSZSiUXIUwDkJ1qjmuzNHJKouSk98O6/JNEtxAyu09
	Vsgfj+OKzNrPGMO5zguND4i6NnulTp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15A0F600C3;
	Tue,  9 Jun 2026 14:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230CF1F00893;
	Tue,  9 Jun 2026 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781016567;
	bh=taRgX81yJwI75jVPUy3ya0pHHgm8A4dha5HwvheVriA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erX6JcxZmIcrZHCAP2aqWFKZfJeXTO2GXWNjtqNyT3fI4ae3SFvQ+uj/xwBiSLWEm
	 0XXbMJrQmYdX2XXxmSAZpAmKAEM+hczHm8PLuZDYQipS3uh0sqgKTiLcuenNPV0SDG
	 KoV4yZGT6yb+sW6dwdzWh/pApVzsqvkOzR3F2y9BFXjzRlybBVrxzm0Rc7r3XAk0ff
	 7zQQ+tnPRKcvBgnyR62eqIFoUkJ0Hm8PcpBg43sJJTjkbRaYSz3JTs5Ogo4L425H8d
	 eIg0dyf4aJAnl/h4HfnEGY9yXmrV9v0i1NM47T3Hctkq1qF5cpJAEwFpCDlfhH2XBE
	 n9XUCvNAnVceg==
From: SeongJae Park <sj@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	wangzhigang17@huawei.com,
	liqiqi23@huawei.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] samples/damon/mtier: fail early if address range parameters are invalid
Date: Tue,  9 Jun 2026 07:49:17 -0700
Message-ID: <20260609144918.69429-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609064653.1829-1-yuzenghui@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: te5mk4pcq8ohqtdd4tbsuwb6ahhqktmy
X-Rspamd-Queue-Id: 94A838001A
X-HE-Tag: 1781016568-618071
X-HE-Meta: U2FsdGVkX1/5xJWw+NRtHQuLLjU9ex1ZEEowkFthvvMd0KmeQxb1/cEYNh8cD+s+0dXV0+7QoHEds5uXfriKRsWaX4QaI1Aq9UkpLzFplC+1xCqtiBZZ7gJa2waxUvtgITJs45UCseRq89+Dt6PCDYJDt7hZwEkrtH7R9ZgcYtnMMY+YQw74P/ndyHtk2hv2RoMN5mrH1o9iJGpGTEBdIU49lj8F1cC6FbNBtIbhUtwtATw2p9Lz+VKEwwMbaDOKUjyY+zxxYHl9GTCbzj5de/W0W3hHObERhgMow2Jy6wt3QrYvd7dffNXFlhd4NlLVMCuU6H0M1mqLW7RCqi0KKo76WM1At7JvYc3/wZY2pJ1pKYoV5LqwWC56RYmHC+KAXPQ/coP6fDNG/q9QzCI3qX4crDXDBmc/dzvrPOQWX8jOwHN8+qlD/1zKxR4BvTr49KGb3TE2xKqkK76U5RNznMAHDhX5A4IM9In/xhpqKNWU56gN2Mi+QgGTxVyE8Kbgu4ulbGZWyI1YMLw4tdvuB8moawcr5JpTA4QN32dVQqChFP5MZnvjqiibyeskyL2y8e1aVOBmGx0j8mURhh84g/2OvEkZXoy7d6E2aQkweKHvxtDt0tIY3gZrkzCrsHltRLm0kFI7agaXjk0bqUDjXwktGph0ZA0c/EeCusU4RqwsDdYafggwhQqrvYo1WPEB0dbaiisH6yX1X0Pbs7pppjQpXeS0lIv6v0I2qe1EdCn7Jrhor1onZvYFcy3WfuR5KHP14wR9cibVLWOe7ke5oJ8MWTwikMUg6L/YEVy86tB8U6rI0nDcCbHfN7KE6jInijGNzGAHPSr+8w23XjGqEU3LbFD8KO/DIEU5C4rLr+tWrJsEMS46psCSC9cY7AWnn3bZjUsyzW07A8prCP+DLLQFhlPnRchGfJLHqb3BDSBCewLk5RvKrq9o8L2Cn46mLU+MtV9HsX9N8dJAVri
 SFztBRz/
 u6+JEFJwBKlrEwDdnnjPwsIxlZnAXORoyrIMzQz6XkCe6SDw7RsDrOIgud3K24AKhwyCNERX1Q5VkuXRE5BcQ117f95bwwvZneg7WoJ8er+Px1ef7gZB/UlC9hFEl0Ev6B9G1QUY4GGSq8XOu4auV0FrJRn8xy4Me2Ym8kE+ls3Sd8wXDAM+W8G/R0mrdPofATcgJHQIjQZCcn3Fjg4d2rEyqUYxkIGXXkIXqhnKdg1nt8tEicOXs+a73bPMZSa5+bz+eBOEC1/q5jZ8cnywzk1KSIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Jun 2026 14:46:52 +0800 Zenghui Yu <yuzenghui@huawei.com> wrote:

> The comment on top of `struct damon_region` clearly says that
> 
>     For any use case, @ar should be non-zero positive size.
> 
> which is now verified in damon_verify_new_region() if the kernel is built
> with DAMON_DEBUG_SANITY.
> 
> The WARN_ONCE() can be triggered if the mtier sample module is enabled
> before node{0,1}_{start,end}_addr have been properly initialized, which is
> obviously not good.
> 
>  ------------[ cut here ]------------
>  start 0 >= end 0
>  WARNING: mm/damon/core.c:217 at damon_new_region+0xf4/0x118, CPU#59: bash/341468
>  Call trace:
>   damon_new_region+0xf4/0x118 (P)
>   damon_set_regions+0xfc/0x3c0
>   damon_sample_mtier_build_ctx+0xe8/0x3a8
>   damon_sample_mtier_start+0x1c/0x90
>   damon_sample_mtier_enable_store+0x98/0xb0
>   param_attr_store+0xb4/0x128
>   module_attr_store+0x2c/0x50
>   sysfs_kf_write+0x58/0x90
>   kernfs_fop_write_iter+0x16c/0x238
>   vfs_write+0x2c0/0x370
>   ksys_write+0x74/0x118
>   __arm64_sys_write+0x24/0x38
>   invoke_syscall+0xa8/0x118
>   el0_svc_common.constprop.0+0x48/0xf0
>   do_el0_svc+0x24/0x38
>   el0_svc+0x54/0x370
>   el0t_64_sync_handler+0xa0/0xe8
>   el0t_64_sync+0x1ac/0x1b0
>  ---[ end trace 0000000000000000 ]---
> 
> Note that the same issue can happen if detect_node_addresses is true, and
> node 0 or 1 is memoryless. Fix it together by checking the validity of
> parameters right before damon_new_region() and fail early if they're
> invalid.

Thank you for this patch, Zenghui!

> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>

I think this deserves Fixes: and Cc: stable, like below.

Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Cc: <stable@vger.kernel.org> # 6.16.x

Other than that, looks good to me.

Reviewed-by: SeongJae Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree.  We are now quite close to next
merge window.  We (mm community) want to focus on making mm.git more stabilized
and therefore ready for the next merge window, rather than adding more changes
that are not really urgent.  I understand this series is not really urgent,
because it is causing only DAMON internal weird behavior and one time warning
on debug kernels.

Hence, Andrew might not add this patch until next -rc1 release.  In the case, I
will request adding this to mm.git after next -rc1 release.  So, no action from
your side is needed for now.  Let me know if you think this is really urgent or
I'm missing something.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

