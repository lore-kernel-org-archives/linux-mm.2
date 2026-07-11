Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5350AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 10:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA326B0005; Sat, 11 Jul 2026 06:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C006B0088; Sat, 11 Jul 2026 06:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB536B008A; Sat, 11 Jul 2026 06:15:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1CC56B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:15:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59CC61699FD
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 10:15:56 +0000 (UTC)
X-FDA: 84976089912.26.B8EA4D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C7D4A1C0007
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 10:15:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcNK8JNV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783764954;
	b=YSfnV1zL9Ce4mKmVmTiRuzA3BLwQ8pNeN+BFvPQWm80gp/+5rXlDc4Z8iA5m8R2vun8eOe
	6JhfrdjwoLT9Xh+utg3OJZxPsBxxJUdDliiHRZ4egWPGfiiKycUJhZX/zhN++vadGwm/WW
	hbyfZhsv71d/fHBgxdruN+GlOq09eF4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcNK8JNV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783764954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcdbPVe2DJM9MtOvkOYgWRb/x7YeFqOeUTEpaV1gBBk=;
	b=34m9j95Mv6AdATQQIyzkipI/46zQOGywejcHruPFBh0kLz3gW3IFaMLbFIB3jDMuUvBh16
	QVMvg05neikQtWj6xa3kqyvNzLk74SFHbpHXM5w/Iyu66EBKrbAJ/xJHjcE+bKfuIC3urZ
	zC3cIkkLltZDMGcvf6Ngtuoy8IUsbko=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3603560051;
	Sat, 11 Jul 2026 10:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994561F000E9;
	Sat, 11 Jul 2026 10:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783764953;
	bh=zcdbPVe2DJM9MtOvkOYgWRb/x7YeFqOeUTEpaV1gBBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HcNK8JNVL58HlIMFspMoFE3mEFF7f+x2CSh8cYHC5i2UYivFD5iHxlX4k8seziz3W
	 7JKXwDoO/X7hg7WeYEN0NessED0rrZfTPgZQaAlU5eBD+RVVXNlWyb/q04D8y05R1P
	 M6KAgrLz5/n/FVBNyU4wS7MxQ4A83mu7EVFGMEI8Ol4QxuHbDhSQlvpkeEnvCF+EqY
	 s+Rq3s+y7Xddhetu0ImsMpQWIOUACdzVrupZdkEr/Jjr7DkaAxkeO49Y2Uh/9T4S05
	 KxPWxCI2hDnQ5IbsCGQAR4UhaKG43+Ha5LFDF/vndH8mrNuEeAw/KjJNsmelSaTIOM
	 4wzywWF8FEjvw==
Date: Sat, 11 Jul 2026 13:15:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Carlier <devnexen@gmail.com>,
	Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] Revert "arm64: Enable vmalloc-huge with ptdump"
Message-ID: <alIX0XoykjTz69sk@kernel.org>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-2-5b3794c113fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-series-vmap-race-fix-v1-2-5b3794c113fe@kernel.org>
X-Rspamd-Queue-Id: C7D4A1C0007
X-Rspam-User: 
X-Stat-Signature: ioo747wkyuy943dnuregrbbm6nwh5mft
X-Rspamd-Server: rspam03
X-HE-Tag: 1783764954-387227
X-HE-Meta: U2FsdGVkX18S/srnVOkMbJTmHQ/U8a8y7Ruh8+Kr6C9efDJUYgdRQL/mCh9Lf1U7+BUS4780tZC9mDr84QAnK1K+YYfk4qXzQXqabDI7BnoERUxNPzhvC6yfFbK/KYsUyXp7wg+OduA8H/1FY7jAHYTwrlp229lKmAb3/IqrkchUPS7Lpfa76cPu7uQkZj9+z2v4+yoK+Xct4eq41Cmijbau+5WG/0vQ3b+u+eYbdoYWRZ/LqdaoOyqCbjNbEm1kL51ceDaNhhSq0asUqDTuXY3dZcqUf3qx2g9dlxA8JIN1Rj+ZwDAgT4r+mrjVrAGgen1N3rqbB2Uthtco3ZRlNKsh5EBjwFCw0GVH5J039JbrweSLmrlo0zoPLYkLFeSl2MfwiHugwFEgQCVIb7BNGBZ0S18X1gZPY4XUYogF6Fs6UOewbF+/bNEbZGOj1+s72YFwMjuzWX8nygL36JvE95yD2v7Nwj0nYplNGuIyR0qFXBBlywLiDpvs0J9xPXutTzgyqjBfhiNJ/WF5wdrxq4r1hB3WSEpgEpg+TcDSvkyJqjUyUMxV96DNqDWC2+d6HYL7d7rZ2ECwvxTgW55DzkbHA+z6tPDtt6pBsLSgu/+aeCcNd/7L5t7C5bVKZF2d/XLsCRCLAUo1GXUe1anrg/8SQ+ULxJx6GjvgjGG4pt2iBCCTuBtLAjA5fJv3ysCEQ6Y+MVd5bglT4i7o7NDMyOtMg/qmugZkuePHXLcGY5J46wbYxws9qPC1FrvG2Sx4+kWcOkM9ZuX7dQy02LUYf3eV+LSLl+7CFPbWSgefstJWV44Sd2XpoPcYakoAxGtVwsGAmibHJwVoYUmohlxEAHj6fClRIbpNaERtmid6BBZvICa7fnC5GVwCTP4SKr1p5WC/SQFva0G3i/XNW2Mi6TgnX/dldsN1DAzj9l39pdsn0/s+WeqCjWNsICoALyMTtmjPQDayHqojYfuHSuh
 gFt83A3I
 SYYJ2DhNbroTWnPRG04qq6SJse85dF0ep3PM22AHBc6RY1ZjNbWWrTSuMMU5hW/5Hzb2hGPJoQNuD2ewNDQhHssULJjVvIlxJuVIOqG/weJS4CvZZLxR6J7T95oAF5aN87+EDdUuxlL8s2GhpDPic10MlZGXMiw4IPb8sOx1g8+nBI/iYBnB0Cto0Q6eXirUHZNdjSdZHRRfJimTtqFKFyhp5BbO0q3wBqRkZQr/a8mzY3zSDkgq+6X/liClRiQ/+hUotyk/DRc2Vnp2xBbT5/1D6ZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:49:19AM +0100, Lorenzo Stoakes wrote:
> Subject: [PATCH 2/2] Revert "arm64: Enable vmalloc-huge with ptdump"

Without reading the full changelog this sounds like you are disabling
vmalloc-huge with ptdump ;-)

How about "remove redundant locking guarding ptdump against vmalloc-huge"?

> This partially reverts commit fa93b45fd397 ("arm64: Enable vmalloc-huge
> with ptdump"), retaining vmalloc-huge support but eliminating the now
> redundant mitigation against a race between huge vmap page table freeing
> and ptdump, as this issue has now been fixed at core.
> 
> We also simultaneously remove the arm64 ifdeffery when acquiring the mmap
> read lock upon vmap huge page table promotion as it is no longer required.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>B

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/arm64/include/asm/ptdump.h |  2 --
>  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
>  arch/arm64/mm/ptdump.c          | 11 ++---------
>  mm/vmalloc.c                    | 15 +++-----------
>  4 files changed, 9 insertions(+), 62 deletions(-)

-- 
Sincerely yours,
Mike.

