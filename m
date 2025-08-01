Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F8DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 18:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B9C6B007B; Fri,  1 Aug 2025 14:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C416B0089; Fri,  1 Aug 2025 14:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199856B008A; Fri,  1 Aug 2025 14:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1CB6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:38:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B389314031F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 18:38:38 +0000 (UTC)
X-FDA: 83729049516.07.16AAD23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 30D9F4000D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 18:38:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zab1KhEh;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754073517; a=rsa-sha256;
	cv=none;
	b=bO5wq24cqUGor2fjgtnPBDbklaokCkozuXaQoyctZMSKA+uueZUThG3W55mon5HmqjNdDJ
	eSQDXemOqoCNrDocGEHhGXGqGZCY4viWBd8N5dyCneOUbGJZM+4EEKDEWl8UUP9/snN/qi
	ZUh7/EGfxEWZ4JWw+X9WUcY1A9/PMqk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zab1KhEh;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754073517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnyDmtImzggUk6D+0gW4qo34RNFYKC2QxOluugaofs0=;
	b=NugeHy69jBkGcmsl8cqu7/RSUD99zQtHwpI9KP/gRqRvxa+y0tV1B6zuMYJoJ0THkBWqUi
	/qm+6lP8fnnfbMpeW44gyNXATHrIGM/hTi2MwfhPRbc3ZF5xZDyZX/zsnzvciabnynAvAR
	zAzQvaKRTXe/Z0aSPcOJZmwodMDcDxQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E22761132;
	Fri,  1 Aug 2025 18:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4899C4CEE7;
	Fri,  1 Aug 2025 18:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754073515;
	bh=imashWwUDsbC5s/UDXGZVZQqEjlTbXz8PwBJPtlckXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zab1KhEhm+kx/z8ToNRKWL/WYJyIj24HC/h9IsisLbcpBGzz6T2YUqvi2HSPH+dk3
	 u/zeY7M2it5nwB6B4ekp13T4vr2H8Ry7q1+FLogZVc9ilVJVnOtStcNV09TyRIyVXk
	 Zn47ynQlgxHlZiiZ5rrICIxstW9D1Bqd+LCOkTPNRPWm8ELhTe4aDqdu42TCGJtK3E
	 TGbf11Rn1Nlbf8AbDUBCq8TReEtoQjVXG1utigD/sWXA40D5Fci34yS74uHvyYsPSS
	 6LCf/VtDgrf3bUNFad6JV7mZ6CDZjEAnmhtilLBsKiTTQmsiD/HIlpgpG9ivPBnBIG
	 XDp2dN1BF6aSQ==
From: SeongJae Park <sj@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	david@redhat.com,
	vbabka@suse.cz,
	peterx@redhat.com,
	jannh@google.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	paulmck@kernel.org,
	shuah@kernel.org,
	adobriyan@gmail.com,
	brauner@kernel.org,
	josef@toxicpanda.com,
	yebin10@huawei.com,
	linux@weissschuh.net,
	willy@infradead.org,
	osalvador@suse.de,
	andrii@kernel.org,
	ryan.roberts@arm.com,
	christophe.leroy@csgroup.eu,
	tjmercier@google.com,
	kaleshsingh@google.com,
	aha310510@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/3] selftests/proc: test PROCMAP_QUERY ioctl while vma is concurrently modified
Date: Fri,  1 Aug 2025 11:38:33 -0700
Message-Id: <20250801183833.30370-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731220024.702621-2-surenb@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 30D9F4000D
X-Stat-Signature: mdkrahk37uqb47qzhtd8ctb71yj8x4k4
X-HE-Tag: 1754073517-600425
X-HE-Meta: U2FsdGVkX18D6KQmp31OpNiS/7fOA+9dJ+7fJkMvn+wfhDRwHzxKku7mYIPMsnIFolc200E69Tp0XO+3wukNoG51D0t3cSmnmzGzAYAJfXlYHcLahZaIbXFV0v5rx18r/amSA38cWssUQ4QW/uc74sPLjRkhADoJvoUQjOr7fDpIa/ah0NKOqf392dR5R7t7BrLNbadoD7JXjja9l9ljZfOIEeMj0GZ6tFPK14ycUAkvf8/WD08gC2X6Ik+VwQesxUuid/N4Z/0j5xC7IY682gKceyuai9hcVEOkCrjFaVidLRrFjDdxl6elAe4D9a7rC/WcKa0FHRfiV9ujdmw0qlptBY7Q4wFWwINy7iFkKD7UBwkSIYVgcT/rY9mQbagLKeE3kT9Dew2wPj8FZbviUGZKS0auDq1AE6431L4aJBaGL9lvC9FHg8MMHa9AcviX8NMOzEV0jKJU8eqDa2i0RbwqymJQf3oIOn7JJG73+OJtNKiJE/lWLUA1eKRc7c1FKfqvqX0QeqnWYx9U5XqEpHMzM+zjszGncs/nFIaYJOyPw5s3+3PbQD0Jr5z6Tha/zp4YPRz2tn02DJH1dQ34r45PhfbB361rHP+5n7/fmRkKWV/v/cL9lULVUNBdOPwvpbQPbzdLTfZwJvVUy+SiOmyR3xIVpFNNYMZlJXTFulOj2f+h6LzbHybofDsq5vsj2APxvjMuEVESzFAbXlZUmXtCuYjiNrPnqtEQCxeQPLMjVOPc0GfoPVjSyEr0cD667MWxYC/F0GReZ6DADW9nB1yfh2zc49a7hieLau+X0/F6hB0SuOz/zbyq8B//+iyuPS2w73X0uDh0d5lJ1YMFx61iCqcUA8MtLSsyxQDVzvPXpoU1pnHs+/FzWUD0EvA5i6sEdJDIMo7zwvJfhtOJySnG6M8ZuRsHlFjY0szyqCwAlUqrynL3VEDYmT95gHHfJOQYNHo/pyCeR1qoTrB
 gVv4ZhvL
 sQrny7gUtJBdbFxIueDeYvSH3w3Zr/Og1/ObWgEpZw9kNIu4Riwyi5Wzk12dLgRRIn/IBXxgq7e6fitc5rdeSQ7QRNuN5kGQtY8BVblE0W4yk7qvPYVmt52V7k/QjXSAxfI+N73HMZRMjJpGLr6A/t/kEuDOqhype5fKQmzIbVBo2YXLbfc+94lQmo+kHIiLfoApfb7vNgiX4CJGqHmm2k65noRju9ZCtjwP+YhvVFk2l5Vod3cHuGVVkArlC4F0PR1zBFM8S/zOBB14DTEoqwh6eEgWHYCR+cu5g1q1qFxF6fpvXFS0l7oesq6B8rbDpETCPvs/wJ8jHRpM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 15:00:22 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> Extend /proc/pid/maps tearing tests to verify PROCMAP_QUERY ioctl operation
> correctness while the vma is being concurrently modified.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

