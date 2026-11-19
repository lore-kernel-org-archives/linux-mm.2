Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79639606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kH42Q5e5
Received: by kanga.kvack.org (Postfix)
	id A48B16B060D; Thu, 19 Nov 2026 08:03:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F96B6B0619; Thu, 19 Nov 2026 08:03:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90F836B0642; Thu, 19 Nov 2026 08:03:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5366B060D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:03:07 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05D381C4554
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:03:07 +0000 (UTC)
X-FDA: 85451884014.09.C8D7484
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 58D1EC000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:03:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kH42Q5e5;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795093385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpueo6za2OUrPssLdFfnbgW5k1yEpFXa9JhmFHYTJmg=;
	b=fEshxqbHJg7Kjo/o09kHykacMb4deyGp0pTVGZxdgZfTD+9h6En0aW+tz/8JDvJVgfX1lz
	gmA2kUmcM7FVIOyXymMpaVBCWakCjQ6JXhHJoRF+//o+cpLBiNwrsevj+OYCQPiX91o/zw
	LI8QCmm/jc3QIoX6WQhU/Yy8Fvc8osc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795093385;
	b=4fkwYE4DbsLdfE+lBlp7TNZuYOnVWqklyivgnydsCVqcyYPeSn6NGLv/21QGVUTNOUrX6Y
	+6VQ4daZYuEvDIvyIWKsghYEkaK5B0MYi0BCt7/ftRClYa2kK/IqqNaFqVsL2nsTmBrJVd
	VzC44/SzYxx49cTFHrXGQxzhrcDk38s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kH42Q5e5;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF36560E10;
	Thu, 19 Nov 2026 13:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692B61F000C5;
	Thu, 19 Nov 2026 13:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795093384;
	bh=tpueo6za2OUrPssLdFfnbgW5k1yEpFXa9JhmFHYTJmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kH42Q5e5TZsCmxL1DOvZ6JIWNknWattnRoXewif+LBtl19k1Xi+wyy1JfoKWfU6k5
	 RZDnZdvvFGe+YY5yX0v5VxUK0UiPkCgAviL+XkMLER9+d98hanJW0Aea19UTf7o8X6
	 5YBIBt/4+bRfUhBLIQidp/KA5a2HLqz4tcq3QEnCiWBSQLEl15a3pUcEO/QR7jVMw/
	 9ONoXHMk3ilEYSNqhztcQ1A5SkXoqHA8oxepVWmll475pwpyMDFipqlQ2FdcJGEj3U
	 bjc3I2bs7LNuSa9OADxA09szFwrV/cTcrVzyRO/Tc/+PJAUksTJYQg551b4KxNkOH/
	 jIIQInIe1SFVA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH] mm/mm_init: don't subtract managed CMA pages twice
Date: Thu, 19 Nov 2026 15:02:58 +0200
Message-ID: <179509335923.408839.14979518473770204141.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
References: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hppt355e6txia7bwrd957f6k76hsiwqe
X-Rspam-User: 
X-Rspamd-Queue-Id: 58D1EC000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795093385-150008
X-HE-Meta: U2FsdGVkX1+g6VKC35RYRT+/Nn13SMtcUgC0mm7dyc19r5PezsIL1lteSyP4DJxu3Ge7kmE0IhHTB/Sh4kEhluZMjDHs8oA/yLcnV/Er0IYv8eMGvWPUvVaW1xcK6rr+Ci9X0l/O5bce6ceDJlvEtM/drX7p2Fk0kc38LkDjyZTwTAqHeOLxc/BSR7RwYMpZZH26uylpBPdf7rV2B7bcn8gYvReca3XSXO3eHB6VX0MH6BKbNq9r2NoLmtLnKlDKGPs/qsjVAUSUKFIOcGMcS/as/4KtOHKpRYVK8GzYrpbk703hui8vp+61W27kWgAlzsKVFLlsFgxuBTsvBfpm/PF1rEZ011Pnl+xcEDDZKXdgSpbXMAlJfBackQiPonS39Dat8kgjMDmIf7xPqRfJaYpdY136kzfeN0nUPWeRq6LUDQQqrg64LwZv34Ju/HW6AJPcOxH9RKRONCvrnGKWUdi92LsXDc/rlyACsXeNYd0r4X0hfZ90X0WDYTGQ2F0H58ugQ/SL0CaCIw2qU5pAt7SqlNij10aZ3kM3m+WKpkw1tbzF2AR0HLtWdbKJvri9uDLf9bBDaimTQ76mjTsU+DOUFq0VVt+Q5eo46zBZs9hJymf1YtuX4zr83toHbOgP8KHGD8lq+MpuwgTaaC6DMdeD/6PpysXmtpUv0ggk20f2HW0SBxcC7x4b/o/tuyrdGTg9G7nSUXTJyMOzNNUWALf/0GIx+rDvfbk8GVGMZ3nlzpmQGwEi7c5S5m75r0s7op9Hg7ngp28bBj4HA/O34jghxBGrqLQuiesMLtDKo/j16660A1MmWNg84ikR2Aub0rUzuSZgtxb4o4Q3hFYTu5+EkmJCJ1/R5CtYlnGfoZVUsJYT7UOgbTkMu0ZI2HCz8wIcngZRPAYqvRhaLOoa9sZUuIIY6nUsf14lkE+d6A96ekbBpP1gTQQ5Za+ebwza2ENbWzhMyGGay5gZdX3
 M2orGHg3
 iGMkLSM9m8r4IcXsYM7HYP3BlMdx6osEOm0sPTmzNFRbQpmJMNTSRjQN7zX2CPegy1vP0FnidVhHe1zAonu66ryysV/xFdtscQVLM+qBNFoPDydN67ilsCmGoVsZQR+1TxKuH90lkvNVM+dG0YdZPAcP5LMuMjgAyVWgrPq171Njs9XoW4oSEzbY1Q02yZQET5GcP792ouuBl19W4Yqv17dng+H82CCjX17cYLGdINEM9Ai5jKuWGUe0RZldAVHkLAM/rzqHW1UsUfaxYejAT/CqTiczrnb29zJy6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Thu, 19 Nov 2026 12:19:06 +0100, David Hildenbrand (Arm) wrote:
> With hugetlb_cma_only, the "reserved" value in the "Memory:" boot message
> can be wrong (small or underflowed).
> 
> When mem_init_print_info() calculates the reserved memory, it assumes that
> no CMA pages are managed yet. However, some CMA pages from hugetlb might
> already be managed at that point, so we end up subtracting them twice.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/1] mm/mm_init: don't subtract managed CMA pages twice
      commit: 3a348bd13cd3bc5ae6d1f564473f40166cc2009d

tree: https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock
branch: for-next

--
Sincerely yours,
Mike.


