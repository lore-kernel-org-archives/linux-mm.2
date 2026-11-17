Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD473606A881
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oLXy011t
Received: by kanga.kvack.org (Postfix)
	id D7EEC6B05B9; Tue, 17 Nov 2026 08:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56106B05BA; Tue, 17 Nov 2026 08:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93296B05BB; Tue, 17 Nov 2026 08:01:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9FC36B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:01:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F2C2C041E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:01:36 +0000 (UTC)
X-FDA: 85444622592.29.1B1C221
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8A31A1C0025
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:01:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLXy011t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayTEljGwz/C/9F1gwd1UVwjVow2ZOVRqTAfEDPNcmCo=;
	b=uhCZTQDZoCILPVdr3aORupgjMUJW1sBp6OQb70jtNuzQrpUPtKcwKhBQiz0NQI/khlQIDK
	FwD51P2wU1oXssnYPv56aTIO5aTfvgCPeBIPkPa4RQ9EVoPbMCdLHYJZ6EgFSlgofYDgeX
	LnwheR5l/1goFyWttBPAiQn1PJZLUOQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oLXy011t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920494;
	b=MKsL0569VUVt97els/QXt9SIc1MA4rb2PbIrpuP1kOeMyIcJ1gXH9TiHiReTSFQW0/wXje
	OYKot1NfB5ZhDI8qUhltz1+KQe32Q82kIckvGfwhmheIKaKMLJ/UODiIal6Nzuc0Y/i3CI
	fyFnyp6mbUvPKHbcHLI/8pK8yb0mjCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8FBF4089C;
	Tue, 17 Nov 2026 13:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11DC1F000CC;
	Tue, 17 Nov 2026 13:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920493;
	bh=ayTEljGwz/C/9F1gwd1UVwjVow2ZOVRqTAfEDPNcmCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLXy011tD0Lq2XmQGbPDQXGMNJhwNlcl7ow9id2rCTBLZY7lgGwg4Hq5cXNP2uXWc
	 s4s2qxProB4VQtOIN6Zop9n05AEqH8Ak5MYY1s4tqVfmhYyEzV22KerCWaJ/yZ/wVI
	 cLrTTJLrhPepY39XdjZNdK8KP7aMAiwR+g0VQgCLBr9pA3+/aHtqCniC1l1rKEk/h0
	 Y0O9z564FqUJaenebFu3Lph65xPq7+IbKx/+V4r8IN+4gr8inBR2qM/mW7CABfMFUh
	 Om6Tq1cgGQx3Y/EZjrERb6ecCV4OPuCmsv9JGy2YLq2lgUA3pJQtIlyQTkEMiKxVve
	 U/vSZ2C9WgwRg==
From: Mike Rapoport <rppt@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	George Guo <guodongtai@kylinos.cn>,
	Kexin Liu <liukexin@kylinos.cn>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Mukesh Pilaniya <mpilaniy@redhat.com>
Subject: Re: [PATCH v3 0/5] kho: fix bootmem sizing
Date: Tue, 17 Nov 2026 15:01:22 +0200
Message-ID: <179492040138.3797543.1666695922414228895.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8A31A1C0025
X-Stat-Signature: mppazwek74mxsg4tadyi9tu9uzfdwdqb
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794920494-804399
X-HE-Meta: U2FsdGVkX19qwlif+H5t+NuRZbKbbxfbg0/439v/DJrtD8qPOoO9f29Mkpt9K9Xzf5iczvpGoL16z3ZSLnBwb2I5VvG6P5YWpQGV6Qknujlubx869238YWwMYesch1sE5QDSdoWQ9DhowOe00G6Ta5ynUW1bXQ4xp6/9i3mxwSS+51ivgH7egyRikzzcHuc6JjKq+Z+QZB4MBAly61vUV5a6jPjuALVmdkWtMidkyKn/X3Zbh+GuFCgzlZ1J3I6QOC8q6WZ8k8kZZEDyAxQoOKmSlAmb3OeAglcSs49c4dLp8fkFL55PrgKFVCvZgh9xSpgS5gagxcDWcHD4YKH34EPcqAXsDqLSbrQGzHbv3hvH8Wt5has0u6LkiqMXRacX5RxJel1R0hsvGrKpAB+R2PSPjbp4EPNL4ki0eCkpfVA6uRlthAA3VOAezAaJczGJs8u2GlF9XIH0lsjNre+yPkrS2KaK+OsSOn07ptvqdsgw1SF2KizrC0ekcYFoeCKylKjKuOD4dimCxTf/VgtZcev6Kob5nzoVUJ+7FLtw2bitRqnDQwvDvbGHUeyw8cljWlPvbtg6q6rrYG7qly+UKIuhdA4BkcG6wyPgbcuOA91he1rvN9Qc0N5yRzpsnZXg1Mu9GyrGU6my9QD7EGYHYUe0h4/KMZ2qXLBbdxb1ScD0bvcUQ0ukjmluWRTJPea5pPdNU3SjTQOf227exCOiGiI3wcD9qKeiRHPElQh7FebCBksPcsRcOewO0PeNlQ1IlRc1fw5K+5++IIPSaUVejK57w+mTyqkAnKIKb09Topl7c2LabdQvS3ybxDM5sr6JBm4hl2fgBC8jtv9DOk01SSBhCAGiZKqQIzmKbmefTjaDdvFA6OCQPpie5qtpG6D3vXii6YXcPmooI5D2+OoSAICrrq02PZIR2GJVuotZmtptxTyczkQNDHus+GYTq8f3tTJQaTvHO7slnzapYYY
 6OsjyBuX
 ZytphSTZaRjyBaX8DCAMCHIXeWQZPnAuKuh1kAUrkDfyp7tQkGNghFx/iIX3S0BvyaZsYjLetes08zAiCwQ6Gvz7PVpPK9XPbVJ8pyCyyXxTxigmkkiz7D9I/2H1a2YFLfbD7XXiWgmGKV1Eu5LTn3+/dF/NVvvVcC32A5gzpwRXnjoH9Y3doUiGoVEEgQNY8JMGnX0qdYIYL+JkaIqNEjSP1b2QShVSO9Rl0tQ+xDsBZxSOyMZ6hwCejuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Thu, 12 Nov 2026 12:38:52 +0200, Mike Rapoport (Microsoft) wrote:
> There were several reports about issues with KHO bootmem sizing.
> 
> The bootmem areas are sized from overlapping views of the memory reserved
> in memblock, so on NUMA systems memory allocated on a node is accounted
> twice and with CONFIG_NUMA=n the lowmem and the global areas are accounted
> once again in the area of node 0. Besides, the lowmem and the global areas
> are reserved even when they are empty.
> 
> [...]

Applied to liveupdate-7.5 branch of liveupdate/linux.git tree, thanks!

[1/5] kho: reject zero bootmem scale
      commit: caeb2173b83441d991171dbbaa59455dae5399ea
[2/5] kho: walk bootmem areas in address order
      commit: f117bbae706f44c7dd1e811d89057d1dc7886554
[3/5] kho: skip zero-sized lowmem and global bootmem areas
      commit: 1010dc3150fc835695df7b21cb9d56016477fab8
[4/5] kho: fix bootmem sizing
      commit: ee4505fe8c4490827244668dab3659c100f4e7cd
[5/5] kho: docs: update description of bootmem regions
      commit: 5b27be339c42a7540eeca5c179e7e0bbdb7a4cdb

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: liveupdate-7.5

--
Sincerely yours,
Mike.


