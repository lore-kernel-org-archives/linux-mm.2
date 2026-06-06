Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 978F7CD8C8C
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 13:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688686B0005; Sat,  6 Jun 2026 09:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638D66B008A; Sat,  6 Jun 2026 09:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F506B008C; Sat,  6 Jun 2026 09:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41D1B6B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 09:23:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A679C8C57B
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 13:23:51 +0000 (UTC)
X-FDA: 84849555462.15.1E67707
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D7372140009
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 13:23:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YV6zHZ+V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780752229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CK3N4reuqkgIU3xCajC0NliBbQ59y+R5TmUR3YDwDpY=;
	b=w9ZKcg+m6AxcJEerOy4LWHxrWdK3NeZRATD07FQwHZPpM6S6wIJYClw/FftCvxzERk99qp
	PC5D2eABfoBqQ3iAkoYmN50nAnGyJsO/lw4LADWq6+suECQTFjmk/yX7fMH7YyFqyYvlQG
	mj2e28ZHHLfBHDIp9i3JmCNX9Xz3zqg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YV6zHZ+V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780752229;
	b=Vq+AUD/9iOyJAkY/zlU9n/mtJKG4jVc9qJInS8kJxenmw/u5TDPUPaJXcB4Km25yWHUtJK
	DITxbRhJaf6p660D2yBLHtFPlBXM28m14xcAPh4WcJgnLFLlzGj9ybDBiUgj1RZ103KgYP
	jObCeQNIdVeXBpuEMoh9fyCUpl9KUM8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C80BC43949;
	Sat,  6 Jun 2026 13:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4CD1F00893;
	Sat,  6 Jun 2026 13:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780752228;
	bh=CK3N4reuqkgIU3xCajC0NliBbQ59y+R5TmUR3YDwDpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YV6zHZ+VJT5tTiv49gnzzRvpZYRC2o9wvK7ViYqsYGzezOzLDbSlgPrVrFRb6NKoH
	 C9L02BYBbb2NB3TwAQQ6V9zj/pxposDjLo2qvLYSnssT3S80zinwW/Zz4G+8oWnADv
	 NsWUXqmDqNCiZEfEdTMC13eJg1KjdPrryTj2qWHAa8yvHl+yRL9elbVz16WApDipgm
	 hfDNLQ3q2qkWZsztk+2wu8orxBCZUdEp2VpHs0rsYNx3GtErrpQuAqVs6eJauAPR8X
	 m2uHZB/9cT4ZB0NNuwSt8Lu+8kU/rVcJp3mPAsVz2UCXsR7M7Ah+gM9Qe9UAgMfwTF
	 bNCfwhMqrHTAA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	Miklos Szeredi <mszeredi@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/4] simple xattr improvements
Date: Sat,  6 Jun 2026 15:23:22 +0200
Message-ID: <20260606-gebeugt-mitkommen-eurer-06f3266d54a7@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260605135322.2632068-1-mszeredi@redhat.com>
References: <20260605135322.2632068-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1364; i=brauner@kernel.org; h=from:subject:message-id; bh=KqAzpPi8hGtLJfuBcg1Ih682mVy8O5OwKv5Hr6CSYyE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSpyCeYai+oWStUXcQToX1avf/lEueSQ09Ko73rf87d5 zV1Crd6RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETE1jH8U44z82ZNWHPvn7ec T+KhyIsZB+s+r2KSdBX5rnDgB/tDR4b/kbFZKvPlztZlxmgW8991fzlJ9vbHTz/mlekuKJvRfK6 MEQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ut87cn4up7nqqoq5s767bun73rrknfwi
X-Rspamd-Queue-Id: D7372140009
X-HE-Tag: 1780752229-71760
X-HE-Meta: U2FsdGVkX18SdtarWfhLPoHmjCVHFeaJtOoFgurzZVgCva3lIBNfqr7yg+uwl0eyJnNLx60DVDFQSZ3kZ869lNtTiFclN7oIFQNHjCktUEuLN2Y2LSv4zSIbMSQZaKoeP/N3J7czDokGC4VMFylEvs9Jt2bEbqQJOcmC1Yc2tCyJVp4bmjwoS0PHA1jrgWH6LCo67v7K5UHwNhSeIm11nLoHSd5bHF5e17Hz14iyBzRq92XtniIcgfFYSjLmBXJbrKPysqQrh0tw7jvhoDC4gg+jeGttjvGjx8bkjeBOiAQ73u0FLo8Cdc2FSN81pJKscEVhuGouZ6oxt5q8A5fm57IGh5j1sgGUH5Pk/XkILcnev8+jQ305likLn6YnwZE/sPiv5GQrOt9p9/xzw5kvSgXMxMdM/y2BeQRf7e8f918hHMj30fckbFXu6fF4W6CZVejv4mAaJcxE/dNPGV6sTFnRl+9HR+14c9RfwNYR3Vxfu9v1+DS3FNy94t3dZiD8RFmQapG2vb3WTVs7NWbSzrWhmYWXrW5fbejaFtI3ASZLt9AsOofcZBXQyxvDdupcSByYeU+LIQjsYVo5bqewtT/BpFKtLSvtobKzWUyT/CZHwjY7zXR2qjLuUeVNn8dk7oAgvZsxkphyR0XwyNaO585aFMrEAlJLDTuhE3aEO6l/MofVLWlivLNtcLWpt+oCFNRieIgp204D/WMmEXNYTWDrgsT8/Fxj5o18/abtdX2f7YA9SeR3JaxsXow+vBuIxMaY5i8F3WrqTZApkbpLyqP7JAoY5/NFhCPPAoqxAKyXoi4ocLKbI5EgN3sli+hhYyLi8SUm/nriUZv+GrwKzNMA+OlApr3z+KWkpJY1p4eWIDGTzvRBVh2yzmL73xOmOUgITayjRwOdPCytzRXUkyB6YO3HwASHvXiGASvO8i7I0X9q252kAh/UTT94qdQAItutnTRKnR5LDHBcpcH
 wMd6n1fo
 MwmHSGYWUz4E/3AivJMRObBh+o8S41o/jkkGpqFi7EvhEHJDaf4TqDYJJbfbmlE2Bda97cUUdMcLRfoktSzY0hfPQDCB2mBlTlBmgka1sw1W56Zla00Mw7lxmXHFiBLl1FUaIHqx7fuNIWgRqBqqmmHheSF4GxOdUB4x5DinQf8FkcpdngdQ0rxmvErHoIrB4iayOxayDtoBLYtF+50ZPO42F2LQVCRlDVsuZ8NiiLw9XX8Be4ywxByz/g9fnw3qACHj9SeOw3FWj3Z9G+eEOm9u0qKGY9SbUNOwy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 15:53:15 +0200, Miklos Szeredi wrote:
> v4:
>  - yet another accounting fix for shmem_initxattrs
> 
> v3:
>  - need per kernfs_node locking for simple_xattr_set
>  - another accounting fix for shmem_initxattrs
> 
> [...]

Applied to the vfs-7.2.xattr branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.xattr branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.xattr

[1/4] kernfs: fix xattr race condition with multiple superblocks
      https://git.kernel.org/vfs/vfs/c/6a07814ff643
[2/4] tmpfs: simplify constructing "security.foo" xattr names
      https://git.kernel.org/vfs/vfs/c/832f4de4c8ba
[3/4] simple_xattr: change interface to pass struct simple_xattrs **
      https://git.kernel.org/vfs/vfs/c/076e5cef28e2
[4/4] simpe_xattr: use per-sb cache
      https://git.kernel.org/vfs/vfs/c/1e7cd8a53b72

