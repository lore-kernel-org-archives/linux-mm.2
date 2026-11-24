Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B13606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=funnePDd
Received: by kanga.kvack.org (Postfix)
	id 1488F6B063D; Tue, 24 Nov 2026 03:26:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD636B063F; Tue, 24 Nov 2026 03:26:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F027C6B0640; Tue, 24 Nov 2026 03:26:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6D3C6B063D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:26:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F54140A5D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:26:22 +0000 (UTC)
X-FDA: 85469330604.23.E3A91C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A544C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:26:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=funnePDd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795508780;
	b=g5wA8HLBvaJ/pJLjB+MLqQQa0JoVGaEZ/6vcYf5iXocvv6BL+2Iuyg6tNRC4w3Ol/hch00
	lgtIcR9mSHIuqjvp6O2DOM96Tu0e4QEX1eVGKLYDTJDZNkQsCQEfWH9Cmbi3KE/FlN43ET
	37zXwMAkk0riXZMHbwlnF648pBDjv0Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795508780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFbKGYqNsE0OEI64HjMZzYVaBoeNIoEd+mOemUKQtdQ=;
	b=hbKs2XnwMkoNKkqAdyw29S7o5IijrLXYv7vWDjSFjzGGecSgZx9hxpdl/NvcRfwYZb7y3v
	7lJKtMh4wgaSpFLo8+eCmEEvc0spkkOq599e1QIJI5FfO1lEmWLOz9l8m8Zhuld6hfgNlQ
	acDjqusOKlLfZXxujU4IICc0IxekJbA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=funnePDd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E00404360C;
	Tue, 24 Nov 2026 08:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3A01F000C4;
	Tue, 24 Nov 2026 08:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508779;
	bh=nFbKGYqNsE0OEI64HjMZzYVaBoeNIoEd+mOemUKQtdQ=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=funnePDdYYpjLlc5jX6O/cKl14Oe+ZTrcPDQa62x63ehgOMPY3P0x3Wyczstqs8Mb
	 sd7obCJrirXzuo/YA3svkYpWgK8iC4TD5st6SrplVWv0dh0Hw3rErbwbDoscm6womI
	 6lr12i4TCNpmIzHW+FD3GKnqo21I1sAjLJzZn8BzGOpCxnrmAsGa6zb0Rsk1qeXTxT
	 UCTTDDgBdK7ZON3t1c9fAf1KYMWxl9n0qyoWvY07KD53NIjhB6+CVk2XN9EAl+Yz8B
	 yoUPwPUsxz5ATcSSKHYiH+X0/3KLReNn1K+EbC2zI1BAB+qkM+TSRh8QlkC2fOBuN0
	 RFDUbXtK7DdWQ==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
 byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, 
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com, 
 ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, 
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com, 
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com, 
 baohua@kernel.org, lance.yang@linux.dev, Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261123163301.1568240-1-usama.arif@linux.dev>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
Subject: Re: (subset) [PATCH v3 0/5] mm: fixes for THP migration, swap-in
 and device-private smaps
Message-Id: <179550876938.7489.17735221885406654534.b4-ty@b4>
Date: Tue, 24 Nov 2026 09:26:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 9A544C0009
X-Stat-Signature: brkfr7d1bom79wpxwsd3kfnqjnbxs33m
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795508780-884508
X-HE-Meta: U2FsdGVkX1/vFM2zaaxKMSXVnaiOzoUZSdT5YpHPO44FR8VMSJi/51jzCGmCBe1gYJc3V+6Pba1/4deMD9SHuhpdzF2zaorN7S5GY113X68jLtAOJbRoXjZzXNfsPT9+mGIe2pxB8+c7p1v7KLdVRbNWEHQzeAvgPGtLrl7gKzFlkpOLPwi9XxLS+Tn+S0/Ju3EWKXTCJ3j5/eruokvArxS8pumGxeHGgk4bEVi2FbKzFMbG6YBTb5kn7z43+qtPg1wPYFU6IC2FKxHxodrVBhpK5yU7l0MJhemk7rKlrRBaTZlQt6GsykfB8qawtyrqzrjCM3jS1gBvmTD5de6SzO/Xy2qxDBmvhnVQmN5zyyCeFKbVNk3CSPmoi97oz4GxIFdl+T7AvNO1aGGoLj5Lh7qt67uUQBv+K9BWC05dYmN/Rm0KpOBz5j/9yRcpAKh3aD/wFzWx17nZxdGbHuyqpsJbezyhmRQbUJCTTsvMnmeZt8Xo/TBWV2N7HmPkTiJYIWEYpWguVV9NoFd+WQWGOQaFdz794UK0qH2yiLW0F8AwreEIRLz6FEpmBqcIW169Y6BRi/4RxF++QUuNna9A7UyBbqeh6PrMsmh2VF8VERxTI3psB4ikx9TECKw+xhFXRENL7ofG7e8O92OGz9fyih0L6gUY5WVGuA1O8UgtuiKibZOR4QzUy9oDnVRz5CGbe8UubCrqB7PqhWf3LNWV2EZAfZNbWfbRJhFeokAtuQ6xcpe6vbLKDy3kFspcXYXgJGii6tEGbYyRD9tJCsr/uCg7N7mIQbKggHp8KKswSXTyfu0bhwagN7CfPSyeEyi+X3pYEoTYrkf7xiMG8c+BOLcpvNwNPIdS4Z38NmU+VeS9MJfJZDLQpyXLAr+45dmPFYsjWnKX5ST2CO/h7XtTunlIS0pzfAPYA5b6/vXON3zJQIG/Alxx1FsDsHZZB0NXcAef5ZnL6AvP2MpRkNQ
 s4HnUEd6
 kf1puFeKNOANBUyq9UNHHSaYvBJreJ+3702waSuYj4geeqV2LuSQU7n0+66OTFZfNAWHAv8ePC8B8lPchmrmZAcKj1+Mbe/Caw1N4v5Sxsbfh8DyJq0CcStm6tZ+3zntTamyNATxaqt70vXGGPGUJgTDbnOAQLopY/b4KDvAdq6bzLUHzVKux7TX7lX/uQgcgLsZbY0d6uy0E8gSv/elxixn0fxfvMb6f0w4TEXTr3Sbu9UO7vQRrVEieoGUBT/zEXzQh6+9SxBgPOxPL9V/qDPc6JuNbyG/YR07zf/+tKfdPPenjadTDowShZUTWwL+iy6CD/IhCbzT6xS0jyZ2+uJSpEry3ke8jozfC/2WnLisjmOWO3qgsetpPDAw8lweoCcVnm8NHcDz84dKlGOfx/+0/QCtZLi3YZXV3qzGxyhlSLTsxfhTNQ3/mp3A7GcdU6rgIpP34Bta9sJiyVB2XkgGXY7NbOtBf9Hh9JpFYEeAZ3esaMS68uoNzCny+65CfWv3IKfMkQ1A3eVetY7I41UgJFatiugnblgX5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 08:32:06 -0800, Usama Arif wrote:
> This series contains four fixes for existing THP migration, PTE swap-in
> and smaps paths, plus one cleanup. They were extracted from the work on
> PMD swap entries for anonymous THPs [1] and can be merged independently.
> 
> 1. Avoid a folio reference leak when concurrent MADV_DONTNEED clears
>    or splits a migration PMD before the device migration split helper
>    acquires the PMD lock.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/5] mm/migrate_device: avoid leaking folio references during THP splitting
      https://git.kernel.org/mm/core/c/62541fb6

-- 
Cheers,

David


