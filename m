Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B65606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=anNWY8zl
Received: by kanga.kvack.org (Postfix)
	id F32446B0A36; Thu, 22 Oct 2026 19:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B2D6B0A37; Thu, 22 Oct 2026 19:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF98C6B0A38; Thu, 22 Oct 2026 19:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A20CA6B0A36
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2155B16035A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:08 +0000 (UTC)
X-FDA: 85351852656.28.05E9D5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0D908120005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=anNWY8zl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711686;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7twd+WSZtzZqzcG2MmjFTpIoH9oGJ/O9bNcXdaq/s+I=;
	b=5sKd/1g22c15aQZOZ5R5imU8blwCE18fu+sJYpAlf3NhoozhZtuXJ4dJW0uqGN6yqJcz55
	U5+cP1h3tITBWWWZ/Bc1qCuPnjk1B1benox6LpEElLxdm75kQKpo4ovLDdBY3HfW7LaBcy
	IdmI25N9YGep+HPa4xc1k9NWnNxohiY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=anNWY8zl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711686;
	b=jFo2WrQHN55N2oTRROOypAPWgxsclBHZkz2LucCnRjUqzpcd5rRVw76fky6iB7GaP1+76x
	8QF9V53IqsR8a+hCNZjB8aNI8t+nXBYnrTOEqmV2yA8lyJ4snU4qNnmNZaJDO6IqqO0x3Y
	tWRhJozhGec3H1+AkC3Nqu1dPcszCKU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D518C44518;
	Thu, 22 Oct 2026 23:28:05 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711685;
	b=0lpZaCl10Ntmy1elZ3Qx/1gpc07iV0fbsCJwQ5/aZ77C99ikDNG8JmbFQNBpIdOCQ7Ar
	 misMKEWBcpAbqOef5ZE2W+ykEadVajMEhbkId3y58QVDO7JtF2pzZXKmTJBLrsjTAzmQz
	 4+0JU9pBPQmKHh3SVcXcuK69peRT0zdR+tiwqPHy2eV/qH1JxyuE/iI0s/FDkugUHqAxW
	 mgWuAOgPosBiDnBVHIOHU2bJIm8bhGSPnYLrAxSZf4lelqgvEvtwHeCELW5qccUY4RlsG
	 6QpYdKl407cOMTzPL4GKaQciVIN42PS4y9IIu7CV6H+qAlNoB7RT82jf5Sth1tqVTTw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711685;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7twd+WSZtzZqzcG2MmjFTpIoH9oGJ/O9bNcXdaq/s+I=;
	b=tTqmPh4Y5lW1D71FuN0KQLRYxK+CDMCagIlBcJrcidGSHKjeArIK2s50hLpw20SFHo90
	 qZq3PQmS2gvEJ9fRVdy5Y1SeEXE5LmCTaTiUar+8fN+zG3H/vyB3/s9oFGEyZt88XH0no
	 niEZE0kw1jd1pie79hxKtDsH01uAk/JIE1QeeSAGoGVGn7m1O2P98GAqTE76pPq0gB6fQ
	 uVIxV9ELf5TUZbh/nmVy1b6bnYsqRBMo+3VQGwPARQA7pNXOB6+XvlmHB+a1D5g6cIInU
	 TCoSUKu9SlMNDSL+Rtzqxdnm25hWEwsEGbMXppMrro2iv8KKHeMCmstRe3cN3jSYVTw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 579C81F011B3;
	Thu, 22 Oct 2026 23:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711685;
	bh=7twd+WSZtzZqzcG2MmjFTpIoH9oGJ/O9bNcXdaq/s+I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=anNWY8zl6H4ptpNFtI1sMlOJnjw9tZKJmkP71LouszJusgtYlkBxtKngp+BCEuiHA
	 SnbU7elJiP1zVAYPkPCutBxSxTUDBSPtEUnyuDvvDVgOU9J7xjRXRmH306fa9LQjjO
	 8pgBbrL123somEIBdNzbbx46RO7YqepK4QioYViKD4U2O2Aq58TZ2D2duUY1iKQUS3
	 x6Gvg85KiRbvPBS76GRHxWcOCQ7xL1ROn3oA8pftNVLbHTylcr+VTO4LVgG0htMTJu
	 2eq2cOwWUFkV95AWDCkP/eKCrU8RGTUmtjS5yEB+ZIWsy2uHE59e2JPx9RyEChR9I8
	 40NTk2pNT++/A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 45D1442097;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:53 -0700
Subject: [PATCH RFC v2 21/50] samples/kvm: Remove donate, reclaim, and move
 operations from sample provider
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-21-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=5139;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=WTi8GNiGg+F2aaBuaZCq/EDwN8kKCvY/mAo+mn6OX58=;
 b=v3QhsSEVYXAd028viNm8E7C+qHr9nyYz39aTz3RD6uY14m1o/VGPWhbErWNd6ZfBbEsWDSTBQ
 MLBj6iPluokDwyJ+aEIZoq+Eozr60nK1kdDQ10JAa8cCaEYuDLEqG3P
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D908120005
X-Stat-Signature: ku6hr1ypgawzwfh3t6c9jex4k7o8ros9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711685-774119
X-HE-Meta: U2FsdGVkX1+0d40xh/A4ZT4VLbQufEcFfYzepDSEeUB+/AnRqEaKGMPWnriJPONK4/e8tf/NdU5E5Mq0P9Uq1VnuMa+FOHxmA4+ENis8ZKX4ap8D9q79xPcs3gK/ezVnCOyeHacoIQZAawGPYNaCq+NLN6fKanSuJ0ijeepxvjT4dwjK+rSddp5+hj/lH7+bOl7QO9wtJuoZgmJsB0aoIaw0m+SOpsUZhZgXw/cQ969VZ214EIa1V07amJWlBBPBg2CApvYBY7M43owt6E75yBHbQ3mHuS9X5mYKPitiQtdU71wgkKYQ5HuLrnbRHqUbDlDQ54WL+2sG9E1sRKnktxG0vrlOQuan4I3cHGPnXTUtZU0TrvRHqushQ3FF/qkjFhQHjsrALXVSph7pqBdQgwr7bcQ7AfOePCse3pku8GGhOQCB9WhzOg1t+K2gXWe/wtuffC/VQbEy+eua8QLXYlYBv5ZUzlZFLWUEtZ1l9o6IgOig8qV3Jme739Is7b51spZlD4etUxp94vIjdHDDaeyK2FrfOtpA2Jex6pF9SRkgyi3iF1JRoYuqotYGfMKwVt9NmBCe36uIy6hwtZ4/rM3s6f1c0QdFHPBZVbVzjjGr6JGrr8j18chO2ss9QTO4s1OfHTVP8v12KmorMjKZbKnD2/AcGtKOzLXJdkkYohiPtX84WMJapfPz9mJQd9DO5DL4yrB+e98mvhPpsqKGQCbFLjFng1Q1unPoe0vaOllOcpyVewWCMkHrur7R4iuQtFMkTeZ3umirV5Y/ZEb4O/iEEFQUYIxDSREuyy2GgrY26Mr/KY5ValYipolVQq1CPjC1HAVeQnQQO6RxDgkZ6rZhrcLmNSpgfy1HRJEPZrafK90iBhMPbzNAzg6GW60SXKqtQ/9RBVhsC7gM+dSCr+27R/6KNq5AK5OewQKkxGAxt5NK1sKEoDMh49qb+CH1DbU+S9JLyWybkwY7Hrb
 veThYbL+
 OEXk+oaYzSaFtIeuYs0hwagziFOrC7FsimZnbZjQRgmkD2gm4FJThkypxut4PKyEoUHoUaEL54Nd+SIIHStq0OQMla+yn60muzdNZ8ei+MA9+ch7fwL63IhisF++UG6cs5TlZFc7jGKgSB9VeFLMrftSWeYCUsKx6z2F+PfWMFegbqkKsjajj5mAZOpofnPKrmBNiOObqoMfrzkK+M2TPv0LrPggepdGxCfesEj1WwjhAPCTgwvhZfgRyfuz/DH+dxhwY6ZQkxPwrEZ7JAMGtMJLBBdFJjTdX0TAdhI0UsiySi5zYnqZhLB6q7mjkS1r0uqkmy0z6y7tDE1Pq+mNRlgFBgxfVMkyUVbqQFgIVeZigmy7ahh7K0gZTf21v3Og2IGAREOCFkvH0uUdwh+5lKlFlmpNyk28rPMmcRolpdbihslyoirVHAK5tSJ5tgHVCWHomx5IRjT18Zzh7q4jWGdjOonaacrUZ76cbvgyCIcCTkwmQ43Rlvx5Gy9d3sAyuiOVszCkPVbG0P7orr9XcXlvvAqEQiaIe1H0IQL9ByKvRRcpf0dLa+aNOrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Remove the MPS_MOVE, MPS_DONATE, and MPS_RECLAIM ioctls from the sample
memory provider.

These operations manage dynamic ownership transfers and returning memory
to the root pool, which adds complexity that is not needed for the core
interface design.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/kvm/mem_provider_sample.c | 86 ---------------------------------------
 samples/kvm/mem_provider_sample.h | 35 ----------------
 2 files changed, 121 deletions(-)

diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 8180959ab78ff..5afc433dce6e8 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -674,86 +674,6 @@ static bool mps_child_owns(struct mps_info *info, unsigned long first,
 	       find_next_zero_bit(info->owned, e, s) >= e;
 }
 
-static long mps_ctl_move(void __user *uarg)
-{
-	struct mps_move mv;
-	struct mps_info *src, *dst;
-	unsigned long first, last;
-	struct file *sf, *df;
-	long ret;
-
-	if (copy_from_user(&mv, uarg, sizeof(mv)))
-		return -EFAULT;
-	sf = mps_get_child(mv.src_fd, &src);
-	if (IS_ERR(sf))
-		return PTR_ERR(sf);
-	df = mps_get_child(mv.dst_fd, &dst);
-	if (IS_ERR(df)) {
-		fput(sf);
-		return PTR_ERR(df);
-	}
-
-	mutex_lock(&mps_root.lock);
-	ret = mps_root_range(mv.offset, mv.len, &first, &last);
-	if (ret)
-		goto out;
-	if (src == dst || !mps_child_owns(src, first, last) ||
-	    !mps_child_covers(dst, first, last)) {
-		ret = -EINVAL;
-		goto out;
-	}
-	/* Revoke from the source before the destination gets the pages. */
-	mps_child_lose(src, first, last);
-	mps_child_gain(dst, first, last);
-out:
-	mutex_unlock(&mps_root.lock);
-	fput(df);
-	fput(sf);
-	return ret;
-}
-
-static long mps_ctl_donate(void __user *uarg, bool reclaim)
-{
-	struct mps_donate d;
-	unsigned long first, last;
-	struct mps_info *info;
-	struct file *file;
-	long ret;
-
-	if (copy_from_user(&d, uarg, sizeof(d)))
-		return -EFAULT;
-	if (d.pad)
-		return -EINVAL;
-	file = mps_get_child(d.fd, &info);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
-
-	mutex_lock(&mps_root.lock);
-	ret = mps_root_range(d.offset, d.len, &first, &last);
-	if (ret)
-		goto out;
-	if (!reclaim) {
-		if (!mps_child_owns(info, first, last)) {
-			ret = -EINVAL;
-			goto out;
-		}
-		mps_child_lose(info, first, last);
-		bitmap_set(mps_root.donated, first, last - first);
-	} else {
-		if (!mps_child_covers(info, first, last) ||
-		    find_next_zero_bit(mps_root.donated, last, first) < last) {
-			ret = -EINVAL;
-			goto out;
-		}
-		bitmap_clear(mps_root.donated, first, last - first);
-		mps_child_gain(info, first, last);
-	}
-out:
-	mutex_unlock(&mps_root.lock);
-	fput(file);
-	return ret;
-}
-
 /*
  * CTL_SET_READONLY and CTL_SET_PRESENT change a child's pages, by the owner on
  * the control device.  A VMM that holds the child fd cannot, so it cannot undo
@@ -795,12 +715,6 @@ static long mps_ctl_ioctl(struct file *file, unsigned int cmd,
 		return mps_ctl_setup(uarg);
 	case MPS_NEW_CHILD:
 		return mps_ctl_new_child(uarg);
-	case MPS_MOVE:
-		return mps_ctl_move(uarg);
-	case MPS_DONATE:
-		return mps_ctl_donate(uarg, false);
-	case MPS_RECLAIM:
-		return mps_ctl_donate(uarg, true);
 	case MPS_CTL_SET_READONLY:
 		return mps_ctl_set_range(uarg, true);
 	case MPS_CTL_SET_PRESENT:
diff --git a/samples/kvm/mem_provider_sample.h b/samples/kvm/mem_provider_sample.h
index 0e036d1c76a45..acff5785099b5 100644
--- a/samples/kvm/mem_provider_sample.h
+++ b/samples/kvm/mem_provider_sample.h
@@ -68,41 +68,6 @@ struct mps_new_child {
 #define MPS_NEW_CHILD \
 	_IOW(MPS_IOCTL_BASE, 5, struct mps_new_child)
 
-/*
- * ioctl on /dev/mem_provider_sample: move [@offset, @offset + @len) of the root
- * from child @src_fd to child @dst_fd.  @src_fd must have every page of the
- * range, and the range must be inside @dst_fd's.  The pages are revoked from
- * the source before the destination gets them, so the consumers of the two
- * children never map them at the same time.
- */
-struct mps_move {
-	__s32 src_fd;
-	__s32 dst_fd;
-	__u64 offset;	/* bytes into the root, page aligned */
-	__u64 len;	/* bytes, page aligned */
-};
-
-#define MPS_MOVE \
-	_IOW(MPS_IOCTL_BASE, 6, struct mps_move)
-
-/*
- * ioctls on /dev/mem_provider_sample: DONATE takes [@offset, @offset + @len) of
- * the root from child @fd, which must have all of it, and keeps it at the
- * root.  RECLAIM gives a donated range to child @fd, whose range must
- * contain it.  The sample does not scrub the pages.
- */
-struct mps_donate {
-	__s32 fd;
-	__u32 pad;
-	__u64 offset;	/* bytes into the root, page aligned */
-	__u64 len;	/* bytes, page aligned */
-};
-
-#define MPS_DONATE \
-	_IOW(MPS_IOCTL_BASE, 7, struct mps_donate)
-#define MPS_RECLAIM \
-	_IOW(MPS_IOCTL_BASE, 8, struct mps_donate)
-
 /* ioctl on a child fd: read the child's state, for tests. */
 struct mps_stats {
 	__u64 region_offset;	/* the child's range in the root */

-- 
2.56.0.257.gf7497c7d27-goog



