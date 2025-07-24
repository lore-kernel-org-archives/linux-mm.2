Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207CEC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 11:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75D38E0077; Thu, 24 Jul 2025 07:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CB58E0074; Thu, 24 Jul 2025 07:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFBE8E0077; Thu, 24 Jul 2025 07:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 902368E0074
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:58:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E32BB8D54
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:58:50 +0000 (UTC)
X-FDA: 83699011620.25.86D2F07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F932140006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:58:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf23.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753358328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CBM71A5r716CRs7y3LydiT/PkH8MS+K3pnvRe4ld0lM=;
	b=5RLCt8kRGFMKnhcfYztlj4ta8JRxXPpD+CzHIEq6W4pGIsZH6dTROsYrbkWVg+bII5n3tJ
	R7rUrxfMOl9WD3oZpdvtkIfhY/6mApYJgOmGrru9N/ot65M3XZmtx5fzmxf895veSguFSm
	WJulD38Nut580l80H77ZrB4ezQEKL0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753358328; a=rsa-sha256;
	cv=none;
	b=5/JKBXZQBiiXHGx6gC06i3/TXGiqX1ELcNdr0eeSPPO7VmzLZUjeHIgh/U5S0gjKfHU6xS
	dPlIEJE65CCqqjVjObz2MVfeRXIBGwfDg6yb4G3ardi6n2sKcUyc5X+DDS+oe82vkzrnsG
	T9uP5RbL8O6Ci51iRsDUCQnAxYTzB3g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf23.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E604E6114F;
	Thu, 24 Jul 2025 11:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A45DC4CEED;
	Thu, 24 Jul 2025 11:58:44 +0000 (UTC)
Date: Thu, 24 Jul 2025 12:58:41 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, will@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	suzuki.poulose@arm.com, steven.price@arm.com, gshan@redhat.com,
	linux-arm-kernel@lists.infradead.org, yang@os.amperecomputing.com,
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v4] arm64: Enable permission change on arm64 kernel block
 mappings
Message-ID: <aIIf8Q7EVsQ5MGOX@arm.com>
References: <20250703151441.60325-1-dev.jain@arm.com>
 <aIHsiPtG0Ycm2DTe@arm.com>
 <b5570f50-8534-444b-8c7d-68d676840eef@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5570f50-8534-444b-8c7d-68d676840eef@arm.com>
X-Rspamd-Queue-Id: 9F932140006
X-Stat-Signature: oboh1gdg5hcahqq4qhhcaeg3yzuoen79
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753358328-368510
X-HE-Meta: U2FsdGVkX18rF23OhYwa5/NwHumwE1XwYq3yFwK4H/TEiRJN3vlFh1YfetyBr4ysfE6rRK/VAvg+E2ZznItzfDNWxo1bcKTPBqx1zC+rz6OBoJawf/wr5pcF3dVnLLA1SCLaxt5iAj2dW00ETiY8BN890QVeNR7TNEzYCQMVzmFi7f5jgZfP6HaV1AbJQghcsRea+L2gCv72Ms5S6evlPvCsQb64FPxrvZDmfdjGSwuk59G1yFT69b6LJzURCGs3swWosksNNSiJLG0yNGsKgbQAmk4XNtelrFTRUO05YOviwU49zD0juKtkhVWfruqioOjQcA7zWkWxTuUGvdoDgbaLFoKwpwdBhgDMIU3W2OawThhQLx+uljy+3i2DSw9bRj/74a0Q+DmJFiOcrKr/opdQCnW0VcaEmkurpkjeLh1TO0vhdr6YZQ3tCvu9oBItPB0JDUz6cVGDqn+jGyW+tOlWdQQWMqOHyT7ifWcGIhdr/VIrLvwpixliesBeRiAU1zcYXwTI1rZhHgwY56CnpxGlXIWmiKTz0QuMIOZw9RxvpphOsUI1/Ccs9G5GGX99+9wzr4UDdmIuTblRV+CdxGWHapgfd1/k1A1REy/wF2byRvRRXow5f20Z+tHDC1b3082JeZcv9E+uoWxRvU6I/1EyR6iW2bzqbnNWpPi7/V/wSPpsh942GUzUiai7+Tm1c1bXpyeWJu5+tGzTjJFEatqIsjwwhMixwoVw7rvUpDmxzpowmn2+ixCWy0dFBGMRET4cuhFRrtaWi9VH7Xspefvl7Qxzs/SR892rOiagrSYM0XjUHNO/JGJB3AIGHP/H5bwgvAtg7s6CmaktmwqUlaSYAYqVAzUQEHnZHSvjBSYFbZbFcTIrIbSutOGUExovzXuVx63ZuByRUZL/9tDUyddHpKOfpyI9BI/tJeA2p3HfFWCzlQzklDzjOuAZxX+m4JNDr2/otO43v1UZlPJ
 17bseHEw
 rX0E0gmEt8lwpau5n7wx6M10rKpRLpMXKbVBJIDj9bmeH296TLBLNe7YTADvLaVmPKnkLFm5pXf5wURiF+FdCPFoUZWeQN38f+i70JX65QhpmnZVa00uQ/iam9pSoswiyvd0HE84Il9Os8AI3DtXTFs16WTxOSqJVOFJoWskH+tOPlqtnCHsP2U93u2DElTjo3TEu+PTG1hSf51rDhxztZeGfPKfq4ESzBRzDdrT46ozuGeNbEiXrOOr2vEPJsWKQmtWClVmgSCZ9J56mTdOMd9PXYbQuOVhqsYUrYJgu384BH4vL2u3c2LsJlKOJ7A5APYhu4h52C7GvttWMRBsjKL5O0t3S+DKEpmQs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 04:10:18PM +0530, Dev Jain wrote:
> On 24/07/25 1:49 pm, Catalin Marinas wrote:
> > On Thu, Jul 03, 2025 at 08:44:41PM +0530, Dev Jain wrote:
> > > arm64 currently changes permissions on vmalloc objects locklessly, via
> > > apply_to_page_range, whose limitation is to deny changing permissions for
> > > block mappings. Therefore, we move away to use the generic pagewalk API,
> > > thus paving the path for enabling huge mappings by default on kernel space
> > > mappings, thus leading to more efficient TLB usage. However, the API
> > > currently enforces the init_mm.mmap_lock to be held. To avoid the
> > > unnecessary bottleneck of the mmap_lock for our usecase, this patch
> > > extends this generic API to be used locklessly, so as to retain the
> > > existing behaviour for changing permissions.
> > 
> > Is it really a significant bottleneck if we take the lock? I suspect if
> > we want to make this generic and allow splitting, we'll need a lock
> > anyway (though maybe for shorter intervals if we only split the edges).
> 
> The splitting primitive may or may not require a lock, Ryan and Yang had
> some discussion on the linear map block mapping thread. I am assuming
> that since we didn't need a lock in the past, there is no need to take it now,
> since we are only changing the pagetable walk API being used.

I vaguely remember Ryan's and Yang's discussion. I'd have to revisit it.
In the past we were not replacing block/table entries since there was no
page table splitting. If we are to add some splitting, even at the
edges, what would prevent some other caller of this API overlapping and
attempting to do the same split? It's not just vmalloc ranges but the
linear map as well that's touched by __change_memory_common().

-- 
Catalin

