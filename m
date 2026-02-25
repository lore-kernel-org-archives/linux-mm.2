Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D0DBFD45EB
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703DB6B008A; Wed, 25 Feb 2026 15:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE026B008C; Wed, 25 Feb 2026 15:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7A16B0092; Wed, 25 Feb 2026 15:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49BDF6B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:12:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8DD01C9A6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:12:16 +0000 (UTC)
X-FDA: 84484075872.04.F666769
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 550F010000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:12:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g3ryCiLc;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772050335; a=rsa-sha256;
	cv=none;
	b=Th0FQ781IScetUPzj5vdpEZQu+cqybXDM9WM290WUAwa8OMGQTPXmhsII6u6w31ZkccPbE
	i1VVB1xVq5q2WSVnG+BjMbmtr5FQQFszIdTBz0Blv6voJbatFLEish8cRQIU9h1NHcZ/rL
	bZ87kRwhqzuEIyz4WbgfkeXEOv/2wFk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g3ryCiLc;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772050335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9q4+ySLo4ROExE1JyfWwBdelFnFYshX8PHSjHp2QTY=;
	b=MVWlqWE2BSQKUcD61S/NjLIHfzjJrMqAgLr8mWNcmjFSZDp4JIgH4c04ixwPl/aceLU610
	K+6rFn45YLfv8lJz3TItOoLJ1+/JOF8xp3fLG2tJlzzmdgLhz0xwacKrFLpXSIdOyx7pxu
	8x6olxW2uoLBcPTysSo6mH6ER7A96HU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A64960053;
	Wed, 25 Feb 2026 20:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D57AC116D0;
	Wed, 25 Feb 2026 20:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772050334;
	bh=PjnaX0nrKvXjwoSWqMyc2RZCBMHlMtQJ84VIGiaaCKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g3ryCiLcJGsyHMU46ADgUo9zZyQbXK8ByyDOF6ZcP79iIzgOgLMp8mEQdmmUcqZf5
	 Pxf++y4Y5IDWpJZbdark3vMfgh0qpC6jyr0Cs59TzUh+PhVJVr7yjO9PHAHFXkVuB+
	 aII7SnpUP3wUPYgewdTvtioSYsECISw4h5NkzOYRc9FWs1BhDAuC8lA+bmmvWFVGjZ
	 eg1b1L7gNZAOmxN0ZP2giZPs0eltQWZJZ1T2pzdz4tBSjGGKqRHqmfl3skOpCffwj2
	 kIhQM6Il91b2LvNC+n/LzZHXloJl3DVXyOn1di3ZKkEPuxg7ZgbHQCLs1QBl6Jktj/
	 LHkOZijjnfmWw==
Date: Wed, 25 Feb 2026 22:12:05 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>, Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/5] mm: arch/shstk: Common shadow stack mapping
 helper and VM_NOHUGEPAGE
Message-ID: <aZ9XlUAJvPux4xCQ@kernel.org>
References: <20260225161404.3157851-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225161404.3157851-1-catalin.marinas@arm.com>
X-Rspamd-Queue-Id: 550F010000F
X-Stat-Signature: jkwzc4syounz7ww5uc3m1rnsibyfpt99
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772050335-612670
X-HE-Meta: U2FsdGVkX1+RSzLDuN22YEc03oLyb4DUI3HIXIHyfUmYiR2qQ7SsnsZWLAggar7ESotN/yne/opoijt1P+4TPyZYafvFcF0/wvGGSJXgBrLtgmrVUzJShiulGUWKTjBzgB4J7GpXTJEVSLOIdUsaTqxNrXMlnd3zo9hRgBfSU3+yqcQQqYGUYTuNU08Q7e8rbmOsID8kZFk3hGvu8v1FMnrRVj7C3xJuOj3A/NqEk3/OcoL3s21kNQv1Nm++GX/hrGH2hra6AtbFQRJLuIbjNYNwLXrx8cjNpJNrHmqQgPexfznT9gqxed6OtCfsz9XS1TpkXRI2h0w7TJowS+V82CJwAnmm+bbGKqv+OLH/ybC1cTquEmFW0rcSyhQeZzFGc8F01Wdc2o2jIt1ildNFSvAbjpDNkWk8t+aD3SOHS7w5CfRm07dB1uqlrLZVTOIzcFctyjbE4rNP1Iy5TYwQXPQuHu/IpJRE2AAkJkFO1YMOZzZIaD9MdK+EyFTUtyJWW8a63h/vdNWnlynip+VrYHvpopzYdDWCE2goFCqMYfiReoPRDeDJDKMmkBExx125NcTTBJQW9Eiszr5ZMgZXHrfCgjrPcR0H3MC2cFqfRmx+m0lORMoOsqop8kKIjcXyV3uGLQqayVbgMObGe3dWQNZofE8sTvtWaxIE4rC8PfkJQrv4WPqxm0tOPcUJxs+bZniGn1ZhQJpTyV9WDasMYZ4kRsObjppVDaKS4xFkcQKj4UarBN8MNJykXj89nN1xHdNDgxlz8D7d2B+o+8TDLTgdfFiy8J5daNr8vf1qlCPK8D32stTsh8txiyOIF/CDxcRCKLRHOokmGN2UW4W+3Nerpzgcxh2t2KgoiMzISyr1sv0nIAt71hceqMF89OjWHmKbEZVrPzrW+SBsnjMtvfbGVRAA2XgMut/SF7SrqEzVujBfD0tUDklXOMR49Cj4DvHmP0KrQPmxZxc4dEd
 85qpZG2Q
 qi4IGw/+FbWPqLBNr3CYr+QtCxQ+Tgbh1iWqbg0bAVQ9fFMoRNKsp+TUBjs0jZAVk8VuDcXYnPHZxhilPlKGxNKn73cKp6wSIE+Hs6MsHmJXoa9GvFipDimksuYvy8DHyuCjdfJrj/eHmqPDnkdvmNsrfZzZHOyhgHcKXuTKt9bommW6UB+8xxcmm+BJ54cWg/YSWjyNRKUiyYX+5B8nRWCnV8/ejg14clm24OtO6K4otU8s0XWmJKDU4PCfdWYhYjb4+6sc8Ci/Qya/1+RCLkyUNKFB5R9sbl8hhtmWG2txbt5EHurePjtPw6Px7Y+vi9YCYVKDf+/AD0r7uKozwIJRCPJSjqid6dAVFdkjTAEfdCCxo2pwB7RhniBlc0kYw3aBg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 04:13:57PM +0000, Catalin Marinas wrote:
> This is v2 of the series extracting the common shadow stack mmap into a
> separate helper for arm64, riscv and x86. Thanks for the review.
> 
> Andrew, if you are happy with this, I think taking the patches through
> the mm tree makes most sense.
> 
> Minor changes since v1:
> 
> - Removed #ifdef from the helper function declaration
> - Used two tabs for the alignment of multi-line function arguments
> - Added "There is no functional change" to the arch patches log
> - Collected ack/review/test tags
> 
> v1:
> 
> https://lore.kernel.org/r/20260224175800.2500729-1-catalin.marinas@arm.com
> 
> Catalin Marinas (5):
>   mm: Introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK
>     mappings
>   arm64: gcs: Use the new common vm_mmap_shadow_stack() helper
>   riscv: shstk: Use the new common vm_mmap_shadow_stack() helper
>   x86: shstk: Use the new common vm_mmap_shadow_stack() helper
>   mm: Do not map the shadow stack as THP

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
 
>  arch/arm64/mm/gcs.c         | 14 +-------------
>  arch/riscv/kernel/usercfi.c | 12 +-----------
>  arch/x86/kernel/shstk.c     | 12 ++----------
>  include/linux/mm.h          |  2 ++
>  mm/util.c                   | 29 +++++++++++++++++++++++++++++
>  5 files changed, 35 insertions(+), 34 deletions(-)
> 
> 

-- 
Sincerely yours,
Mike.

