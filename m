Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD57606A32F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KG/smLcC
Received: by kanga.kvack.org (Postfix)
	id 81E0B6B05B8; Sat,  7 Nov 2026 14:33:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8106B05B9; Sat,  7 Nov 2026 14:33:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEC96B05BA; Sat,  7 Nov 2026 14:33:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E36D56B05B8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:33:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAA6C1403BB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:33:25 +0000 (UTC)
X-FDA: 85409321970.24.B51D7B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D6D640003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:33:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KG/smLcC";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794080004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUxj1eB/EyE2xuv+24/5uGP9CxShlT7sfivuJJSfDgY=;
	b=RsWh5iOja4SLFGk1QR5XBnI/tR61rvpIpRkcwL2/mqjMYZEscraunkZTj15d816DvJ3wS6
	xa6kQvW2mtF9xZF36y58gNhAVjqMBpvJds1lsbWT0LA9vCAfA3irC2wCzSy0v36xuFLXon
	cPtplYtsoP0U6y9YLASkQUo8QxZt2VA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794080004;
	b=zVaAfxmVH74KQn6G+3cDMVZfmgeEphq132csa/3iVJWoa/X4ZHpJsHb8bJpEQQVmA4MQvB
	hXh4YpT8hGa9LSZynW71jMIesoOIVsYXiY17UvDghPUrL629ZUU1PPi4mUkoz0qQuWVk1f
	kNqY6e2v09loSDJ7V3PFCP+vu+/XoR8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KG/smLcC";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 332176111B;
	Sat,  7 Nov 2026 19:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A691F0089F;
	Sat,  7 Nov 2026 19:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794080002;
	bh=aUxj1eB/EyE2xuv+24/5uGP9CxShlT7sfivuJJSfDgY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KG/smLcCXGWOMAnnLNh8eHoPYGqC+IC2/UbAcIvjDWbG04Rqzmu46mOn1zJJJITkk
	 fkaF1+q3DDz7vxdCQIH2nTmEj6QuRwsurtADWxrhtp9ubrZJreAa3wE2rs0cuieDW8
	 KDQnhF2pPPrsmkmFEZqGJ1wubxJ9q9gySUKVoSpbLnbMrhLDIySYqA3SQP/PUkI99P
	 z19RI2+L8N5+HXj+Ot49b6ln6loj6qHJC6YpmzVLXGZ5HaMlK3QfR6yoiVGpIJUjed
	 i8/GQ4diTppsbv0VVh4QRG2q78RGw8vJZHWNdiFcTd3nGGt829JjzbvASidUdOH3jZ
	 4MyoTSwlRuYTw==
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
Message-Id: <179407999817.4465.376927481020440241.b4-ty@b4>
Date: Sat, 07 Nov 2026 20:33:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ux3ajptg8anuynrosw7ffmcdeuaojqz6
X-Rspamd-Queue-Id: 1D6D640003
X-Rspam-User: 
X-HE-Tag: 1794080003-192745
X-HE-Meta: U2FsdGVkX1+LuaZoWAGfQCiOdWGlRmq6MkkYCjyA9T5tPNgb6CcprRaPPDN58Tpy4amK9YFD/hxtAX3YE7Yc9k/zyb5BZe0DJZvCRVj64uXl5Djl8sisCU9uB83B/vfooTFr0seqgBwXTaasy7y5SlknIpsww0NpH5R57burcB4tBYJDR2fqLpB3MCiyQwuvByburQpt5V/dUSHhHZsYw0zBNqdP97DxxzzQF06COPwvbH88PsqbleuG3il5gFwNnwMb/UdCQfCbWCJ6osiwMLBtnioxVGc5H/7cjB+XzYzOi26M+EKZPb6ZGflH9clnJkRdUy1Pi5NsYX6mZ8C9BFwkbov+0KZYg2Nlo9DZd5gtXrO4yJ91lzuojgxShDY/HVHjNmJYsmNHf14nP/RZRstMdvwMmieUsVFmlpCe8thSHHQ7J3zS06q5lsp/lYZb1qyPgf1oGZ/jESmoUKHiRpi6Mn0D8WI6GmWflMkxd9LUKMtasJc94j1RVvLJNELD+jQFzw0gvajY0Ke+SHJzDti/ZS5f7aIgBs45YGG1Zatiy6rtJuXvTjGO4z3Cls4iQdb9lLPffDRtzNdFnYHipuqah94h9YQWNJp3fOp5W2pOvZMORdWpKdnol36dpDYSilzvqokl7kuy3Z/wQiBK9zV/bznVb5s5bG1VNPfjzt6n4WoHMH21tuKFJORcY6GMeLdSf+ejwxNWQ1yZuQuNkI3EyTROlPHVzkwqXl41BIjdm3DWEHwW7Nl11WYzZE+I6beZBTjxf18XRADnKEo4dgyjRE7uN9jCOtX/TdlGhdYhGUEaA8ObDx6mgwInVkVb1Xg/LSOPLp0bMKNCbgmcCpVwbNt2eILIcU7TWcKSNLVL70GLC1wplcUF4+l2+BXjbxj5ZRgTpd+r2LvqxKqjwBT+Nk4lhHuS53bAramkqlavtrMIRJVKrkbA7N3L1kWpeW0APTSkm/pR4ZwJEOJ
 d78Joz2s
 Gkn4PG0prXLplQR4kJFIVQgsHSQvDSERT+m7E2CPdqSZqKvO7bLmPc7w2cognS2NGYnhAEx0InHchc32Pl7ddLMxo5u5Hl4zP4NClTDgUPqnmRuZnhwpPu/urSZZbH5MeNqhRRiUUBwCxJD25mz0tCIlmrwhU8VsGaLL9EfB5m6UkJgqv9LAaEtbyf7sLBs/l5pIeWkDK8AwD89uMdgucsrin2necI4x9WLWH++HzijvvS0ZruRXZpq4C1xwCB4+hJQJihEOb+f302z9lxpTD7N5MDOYJMAfwxtT/
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
      https://git.kernel.org/mm/core/c/043a2260

-- 
Cheers,

David


