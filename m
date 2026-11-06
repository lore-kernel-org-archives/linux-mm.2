Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8AD5606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQKuXGZh
Received: by kanga.kvack.org (Postfix)
	id CED1D6B05B2; Fri,  6 Nov 2026 07:49:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4B36B05B4; Fri,  6 Nov 2026 07:49:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02C26B05B5; Fri,  6 Nov 2026 07:49:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A04786B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:49:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46C6B160B04
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:49:36 +0000 (UTC)
X-FDA: 85404675552.01.EF1EB8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9B477160007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:49:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQKuXGZh;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793969374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfInTUzq1I5bmAHdpslIMIN8700/Qi0ASVtkQGQk8UQ=;
	b=FcqGMKG0/4CohaZjNv1OOrQ1Hkt1Sx10jCxwtG/lIgqHdawVGI0FZXA+zgz5P9HyGKlO4o
	aHqCF7ha9ew03zK/S4ycHCp1/2oNFXN67giYOs7JWtqj/Nhsdg0Qyf146uaAnVRpbpIl4+
	eK1Q9dzW8BQPcgyA+miSFZze/bBfRl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793969374;
	b=7/0oUg6ouUHh4QR8SSV+uLYdF8yGasZax9WzYUtb3oayMAfhtEVsY4O7tpFq7PX73WH5Ob
	nwxj9lLHQ4mbnSICeaYAVpLsyQwDDJHd14wYItuRhugjlXU7I0EU8jcaEqmOzKlYuZWLGD
	cgmtkUpxYekEBH8EJPzUWyRfij6UdWg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQKuXGZh;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2322A60A63;
	Fri,  6 Nov 2026 12:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFFE1F0089F;
	Fri,  6 Nov 2026 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793969374;
	bh=MfInTUzq1I5bmAHdpslIMIN8700/Qi0ASVtkQGQk8UQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=IQKuXGZhlNxc0vzYiGGG+WWptr0Cybd1J5cdy5LQiHbvReQTrkbSs0p4OiW+tZQpT
	 DdesXCviqPJIoOTqGY/F3iBQfExbDFCnbkQurepOuHezZGxYNMtBbqrqE7pbIrPvvJ
	 DJFaVWsGWQjtXfqcl5q+zddqS+az0RX7yMkmWHDDVPC8rViggdYUeU26RL8n/5iFrk
	 +N3Ch4zil+t2FNEKgT5VinUrYkkoX2g6skrbpg9smn71JvMf/6m5IM9yX350EDKIZy
	 GLIdJoluvgypaQIljk//9iv1WUuNZsphhnjfCZSYY8T0hnqyyh/GA57cclFQHOYzEa
	 PgbjxcN1NSMhg==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Hugh Dickins <hughd@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Zach O'Keefe <zokeefe@google.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
In-Reply-To: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate
 in MADV_COLLAPSE
Message-Id: <179396936975.4326.8320211724584654723.b4-ty@b4>
Date: Fri, 06 Nov 2026 13:49:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B477160007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7rkemkptn4d8dhd1i55soprr3cdo8kbd
X-Rspam-User: 
X-HE-Tag: 1793969374-671300
X-HE-Meta: U2FsdGVkX1+v+z35iSaBBtuq7b0CzZHxIK5KEpo7UjcPyHW0l0kdCn1Q7M3FQg+iLfHM1Gqu1J4Kbok/XPNyB2O0nj1HREWnmFrQr7AL+ngiq+V/Ga1PzSdNOVv5uJrDMS6Mk1TX82rLHVCCA6sKob/vO/3vHLFJ2axJ0yDZivn8ng2lnjkZNhiseSccPtqYuwx8xzu5uo5++1V1e6HfgShbgcGhqIwYjLSRNzuJcIYqs77XXPpytIJS9pcodD1OCYHAgVRyoLsieoSfKhbbbrtUhrSNkM5bWDbWLnqMNO61eZsA8yAzAKAJ+zR4EwYMMlNJ8IhcbBdDpuyZLR21VsfE84iB663X8L5hdav8a+ow1RhvVNhwM1kTA/P65HYE1PyPEgW5GbtlpUUaO8NtmFGmQk/8xqx3nbis4Pgj03lXiPywF4fUu1/7MubXOZnq33SqGXV1w3fW0vWAcwXyX2PEOLmQ9cKFQLxw4hzO+IuGlmyTfDIDDqh6iTfkmZgNhN19Bdi7CxMOyje5UnY7idkNUnpRrgId+leFa4Geqw8su8eNBU/V1FFkWvkNfgjMcDniJ7yYHD19SjXKBVJs0wubWU3MMpjBUxvHlJKpnJuigYCkTspIr3dMMA/9wqCa84G0JEjwl36Gc0XuOWjYVIQAVjrE8YVyUqbEvLcdljqiRpZtdxDWgbhLUaQ4AwaihHbz8DrIdbMOQu3H8DPVYo/57mi0SLyl4BAsBNORIhgYAO7DBgP3YX4oLxOpRYV3+HDuGI0GrplQq+q0hGZFkX4uyiCOQoHefNo61PmzhqnV5P0jMxY7msmRCKDelST/4zNZAh+G8XOZHpnVWiGBxeBnVrnUkuSaWTxqywtKtt349IuLr3lCJoIWyp2Z5PC8iab6XRLCZxKkaQweRvzNXr4WyzyxhfWCSpqOuuaOMeNb0JuKwqC8/ccYH9BH/Mnr8VkGMcFY45xOgLf78I3
 +uG8O/J3
 /VHWzWuLikCNoHpx5oMPZFCMSBjK0nchPvFM8HCbYO/b62SSAKVX4v3wzvM/NWQbHJW04e6QYwIWK6KOu8mIuPpcHj+F5aVVG6ZsOHteiSGFUsfIInvigHw4myuMVTLqAAhuXJJb6uWvh1Pke4PWpmkjhujRPX+7Xp1Q/JDLNZSx28sBjnYMGatFj985C0dWYhldDxXlWCoc0YtyqaqJmp3iKwNyxONDED7JGBsJ9nwWXJ6A/LKo+eyWPxl+44JG1/sTcAH2K5vPnRyol2ZIGfbA6pRDAwUs1etn2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 19:16:44 +0100, David Hildenbrand (Arm) wrote:
> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> uptodate. For example, shmem fallocate() can put such folios into the
> page cache.
> 
> collapse_file() already refuses to proceed with folios that are not
> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
> such folios, leaving handling to the page faults.
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

[1/1] mm/khugepaged: don't map folios that are not uptodate in MADV_COLLAPSE
      https://git.kernel.org/mm/core/c/d6d183ac

-- 
Cheers,

David


