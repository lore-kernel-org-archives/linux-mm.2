Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E18F606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8asuU4n
Received: by kanga.kvack.org (Postfix)
	id 49E5F6B060E; Tue, 24 Nov 2026 02:19:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44EBE6B060F; Tue, 24 Nov 2026 02:19:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DC06B0610; Tue, 24 Nov 2026 02:19:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB156B060E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:19:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13811A86E8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:19:29 +0000 (UTC)
X-FDA: 85469162058.17.C593B96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6994F4000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:19:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8asuU4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795504767;
	b=Qj+bdeZzW/rM7vOo9URrdcVmei8QxthZXB6imXhg1ZNAelag96EYLH5Ab/s7OlRqW/B4bO
	R0Mif/EyJ3iB12/dHgJMeRM8BONModw/gA+GUGrEwIwMihtjwrilERxrEmUaRr4OxWcfhV
	UbM715MvCkjn6ud0If0T8Vqp1W8qZDc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795504767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqEGW7YrXkG1u5nBLzxdbiaTFloAHoNSMLITrHG2DkA=;
	b=YVOGeF3yqfnf8mUESz9YT4Vcibd6BIZghmTdS2768jzkL16VPAfbdZRfC3bTlq/k63jTD4
	6WTCaC1ktReQWA1l+EElgLu/5bktEq0h8nR08Egs5+SvHOOLXSo5ZmQ5lEmTsb91PP3nxp
	djd7rbJKLlIp4Cz+tK27Na5BkZhPtA4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8asuU4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FA5B609FB;
	Tue, 24 Nov 2026 07:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6BB1F000D0;
	Tue, 24 Nov 2026 07:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795504765;
	bh=iqEGW7YrXkG1u5nBLzxdbiaTFloAHoNSMLITrHG2DkA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=m8asuU4nq8UldY+Y4KSPoTLuU7iU0LyPs9C2HSVxikOL79jBA6D0zp5HmX9t0bukX
	 udEQCVy5QC3MHftfBfOHGsNHsoNYQYICMXxUteMwIdsSFRph9lqSixG35OK12GBf2m
	 oO2HGzkeuXHHatek2UuZwKso4tm854cmT/mfLSLSrmRoM/c2Et3g3o8Kwztj4uxjCt
	 etsXcoyHI35pUmmc21TkPHCPcNXpW+55xCqCSj0fH426s5bzGCjHRSObR23a+IpacQ
	 /rNuKnT3Mgyn21MCifeA8o58iAPB3AeBL78Uf1lFiGediLBErQwJI7flJEQqdLUWzK
	 1ppPM4CPFCYcQ==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Mani Tofigh <mt4022@columbia.edu>
Cc: Chris Mason <mason@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Tal Zussman <tz2294@columbia.edu>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261123-shmem-swap-write-failed-v1-1-41a0115dfbf1@columbia.edu>
References: <20261123-shmem-swap-write-failed-v1-1-41a0115dfbf1@columbia.edu>
Subject: Re: [PATCH] mm/shmem: don't drop a folio whose swap write failed
Message-Id: <179550476098.5668.10320150453441389834.b4-ty@b4>
Date: Tue, 24 Nov 2026 08:19:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: 8wroc16cgjsrok4hbxuiin7xpqubntqd
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6994F4000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1795504767-337168
X-HE-Meta: U2FsdGVkX1/Hr61hpgabaaIxmQukf4ri3CbpBRQlJTy8VvWF4gNq1T+9whFausJzNYDjCX3IFnncYSHl2VdtiH7cM5Pl7/1G9e7Vz+8gkuexzhsVoU/1QNlXgI3+2n9JhpHuHisxvQNCTmVhdKkX/+t9HF6Bp0kDf8MX3hw6a2hlLrE0UMPY6lq9A5d+y1Ekz7TRnTfT7ccHqj+9EKjoo56izNWk/CMdbmqx9IzWkE+99ZvkuS3z38yBBeA+2fh6ujlhtaValae/Cns1LtOQ5ZVyJQJa0kjfY5mTb0m3P/jv53+wUlM9bL0KkDu45MV6VJoSUnuEKZGnrgZZm304pX4tZ14Aa2phBjcpoeBiONqcXqAXugeGLF6TqqRVkjghggYV0thW1X5O9if0hDHoI8XyBg5BBn4q//yyBPQrxb3Rk3x1IVacr1BFuIyKmXrWewiC7UsRLlANfvZ4XDS5JUC/nyqdcvZHyRTtZmTp08NbO3y+21b+QHIsTauSNHlCTM4rq5diGh+foSPmAkYOg98o9WZBZl6N2KB4L3QcX515hrol1ucRkVlBK+XG4tBmQc7PhgQDD+lRgE2tatzTpZ1I+N2bdnlYunL2nmVyqcACX5Z3Ie4GMMOCnSh+do9lCZDyPAlAi5wd9U76MF6JvUZuODaX+qDPwaVYF83WTA3SoK0H3qIX6SqJObbV84dG0oT+EUHYHu9gdLjg0Yq0XNihrN7IlRiZpEXAentEvihUwmsbymf/REXtv0rjZ1vzZIzG73pxMv4yVNsc4ZPKDkj9cs1Am2J22DbgH3eCWiP3SBggp417KslPZZ+D0TA3QSIkCh+KdepGdNpy82xaLhcKOE7QYRTmL94ex8PuZXQa5onrGhnKvu4JZ31KzzueXgqzFncqDpuObWUDAqjvrvOXE0tziDOMwkh11EjfLqxDJJNVmGfFFwpehOYAqXGBxQ4AvwWy3tNIYhVder+
 7ELLhsQX
 4cKdwuHKXQaU6DSyRed7HH+KLf4X/VDD+EshAExkgXM9P3yLMb2BxNh/zS1ft2fDLHhoG3DXuAUBcPytCRkWiYvyhmpYY+BVcSxPf4lkesNXlxu4i3m22chcOk1Rz6y9adAnDBRYpbxSiqpgwLlLxVejHq2yRINcmFLoS3JCmcSprT2LNOFkd+FSobIH5Gr1gr1JfqSWtXQ52mx1m0XIl9R0r8Ns/NYDKbVF15FiB3Ku73UF+1lRw5G2J+0WZ7hqobpnMTG3NhC69bVjBw1PT6tQhnwQyOyWedeQSRiUegq+THIxV+zSw4tokNAt16Lr+6pZ8sDMI1XxBoKGeTQMBQJ2CvEDxNLllLVqlUoN5obth2QI2uEXRo4ZXdT9dLcuV7GRycfaCjMaDJIAfwUveGJN51VoYIHby6BInN/oI+W7jTuPbNQmPAdcZcsPkp90RGITLn3W6q5hlm/sVB0PWJQL3pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 12:21:34 -0500, Mani Tofigh wrote:
> shmem_swapin_folio() drops a large folio that does not fit the mapping
> from the swap cache if the folio is neither dirty nor under writeback.
> The folio can belong to another file and be under swap writeback, when
> the swap entry was freed and reused before the swap cache lookup.
> 
> Swap write completion does not take the folio lock.  On a failed write,
> swap_write_end() marks the folio dirty and then ends writeback.  Since
> dirty is tested first, the folio can look clean and written:
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/shmem: don't drop a folio whose swap write failed
      https://git.kernel.org/mm/core/c/e3464357

-- 
Cheers,

David


