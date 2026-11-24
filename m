Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E4B606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTcl0jLk
Received: by kanga.kvack.org (Postfix)
	id 9CAC26B0639; Tue, 24 Nov 2026 03:23:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A25A6B063B; Tue, 24 Nov 2026 03:23:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8556B063C; Tue, 24 Nov 2026 03:23:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BAAD6B0639
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:23:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A87F40B01
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:23:10 +0000 (UTC)
X-FDA: 85469322540.14.41DC5D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C2BCFA0005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:23:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FTcl0jLk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795508588;
	b=i3vB6C67GsJ8iRxd2JOf7u3NNGj6iLG5Qj3bJ1FaCqidbbPooqGBpzOH5jtOnbnW8pE53Q
	p9q90dazOmur/y1lHHkztSNJJ64K3KCPjVkuqEXMoDcXjV33FsDgpj9rctFJ0cQFJbHxUx
	enV1TWD0Gx27o0dy4A7AFKwtKflYl24=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795508588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85ylmbeALAYwawIKijj0hXBlUEBRMQLc81ieNVbxchc=;
	b=GMB0qsUv61ibEdeN6fXeygils7zjuD3vHs2caPGhT81x97IDPuY6XeQ/xioJvp/K73PzSQ
	PLPz+HqbsMcXvp0YfXcFeLusq/XzYPDkGb1s6z/MnrcFWSRL9ehQj/O2Juky5xvlF5mHLV
	ixZAQrdAXycJhpqiacsIYULt7xKGHDA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FTcl0jLk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AF1044D39;
	Tue, 24 Nov 2026 08:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C3D1F000CF;
	Tue, 24 Nov 2026 08:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508588;
	bh=85ylmbeALAYwawIKijj0hXBlUEBRMQLc81ieNVbxchc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=FTcl0jLkzHHNyCJMixZj3pcRaGFGdP5oXwfaEOZ0pcUeTE00z20ZJTr3DqtaTzusn
	 bu2Z+p/Jirb6BNooVKLPKwPwc3VcgHXhceJ+dYepddjDYR/oZA+ZeoJ3696ZrFRkPx
	 /6nJJtsubVIAZDvm/eCXe3qYyF7ulWd3WtAX4VaEdBhcO+OldPtJMVmNJ4U+aFHGlZ
	 /JzOB9lXIlEyNXUmFWEG6ah/5IqZbsyDGdsymZILsq5J0eSQyFWThGFHPXf78hsZSR
	 CL/TieEXgsX2Wb5nnC2KaJzMyn8W/PI3/ow+MvLi2JRF8XuM80sa8BYdJcjDEDhBe2
	 nq+xnQaizMqRA==
From: David Hildenbrand <david@kernel.org>
To: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, 
 "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
In-Reply-To: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
References: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
Subject: Re: [PATCH v2] Docs/mm: fix stale split page table lock references
Message-Id: <179550858346.7182.6655589672684235643.b4-ty@b4>
Date: Tue, 24 Nov 2026 09:23:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wybgxoq3bas4occcobf1jqw71urtbf9r
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C2BCFA0005
X-Rspam-User:
X-HE-Tag: 1795508588-261166
X-HE-Meta: U2FsdGVkX1/d3c/xNdWSof/S5lojiUIITInjzEK2XjOG2EPZTORB0Wx7b08JM/u/i9JmiYQ/G2CyYTO+nAhjstmQoXe9PIcAdZGRbCdeVpv7TloZeI+gnnvaltV7RhplBHNTit60NiVCnhEN6PwWKLzaB2AY1di8U/taTbJc9Cjjq18ELntpC38es/jKao6vm30VUaOMPGiLtvoAEegoK+csTXmOW/rgZzvD+hgehZr8s7LQsApuXDoy3WQMXARN+VLLzfFHdeOIAchFp3czzzHRQcdpRYal//B/OKHAMb4plufG0WjyDeN4F6BrAPK2q4RI4QrwAgSilg0P46eo7oLAO5ptEDGHc+YlsFarTDB9RQJaIt20TXP1DytFKoi+flc5iirmLktaRGCc10HXdUt0W9L5RF+PwtAfri5BhqdR9KWVDk6fr0XVitv3uT2K2BAnjL2B4Ec3k37h9UYXyKiDWHWtsv3NpAjT4xL/Fd/QyFBOKFjqeyC2QE4VF4scaG4+TesIMP+UfLt97kLm2H3SLr8HoAXIImXx0IlhLpxflsBPvw7jL9hvUZhR4RQezoC7l708AUasMB5+b7Mp6isRiMplyUmdxzrPbqwevPGbYk2SwUBEU4bJj07bLFQZHwnR1z7lgT4fD3Vo2SslRWSlQLO1ljvXFuCqOmjQx9U2U0Sj1CZ5dTpZL1IwVfC4b4AIDjuEA4asFubvz2SgrnhU9kMHzdIm13iAdIAmB9vTn8U7g2SzLlV3k+pM0Bp4KsTLMAx5sas9q15YKD5HT+vIDZcGTPyzC7FXBYIBRFL+Wrpa4+B3QZURYy2ZKurOulf38OdKcBCMqST2+FCyVcc5OvNiUc0dlehGUK+UdpAdo3Yuh0tVnhjIi+pef7F20l0gcmaB09LoHk8I0TizH6juJdwLRC92Pr8mDGLfRDsQYMhSg9AA6R/xb69ArCwayEtiMQSsaBovjy4JGTv
 Fix6AmBj
 4cupky5rSvjAqjrIAqPnB21o0oJYEDnIfDeI55HgWKBjbM2XBCUQhPSVS3omRfqX9BObu+tXlBo4e17i1jchdbW07UPyAexKEOFJH5pkyRD1Hqxg2jKtjqHoXjH4/2o5yebctfiZlBar/PNQMUkuz07OT8kPXEoxY3fG3b5TanOqFTYZhp8d/a8nFKt0kOvQmqHY6TsRvfOdlcpkrphL30bHmcdeI5LG16jVM1gpM0PLnsnxQFjS+UcciBzWiu3L0GNRj30lPjd8hpZr9M8G/MHQJUHy1X2wWlan1wTtxuZF+cgJ0jj8HpeSaet+4RIoyGyqO2s0RpbmpERFoG4R1q0AiE7fu4VpwJHXMYrao3e/P6vl1Y8BDkjH+g/JuGaEJeOGHvT3LMh/Jc4Eej9F8V3fNXmabV5c1wBhxDean4gszKC1Gc5uOYxGvUAUZ8UlnZ2MYEwwlFIiT73Diw99zy+bZ63SDnJGqLZsskLbI8OjruziEdWp8NQgbEjSyLXs2efx8cBlZIB2/QYPHBx4eXdVvWa92Mh/POqrrGtDojDkTJaHELdTjtg0CbBMgpr51qCgng/C4X5ixZjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 11:09:03 +0800, zhaozhengzhuo wrote:
> The USE_SPLIT_PTE_PTLOCKS and USE_SPLIT_PMD_PTLOCKS macros were turned
> into Kconfig options, and CONFIG_SPLIT_PTLOCK_CPUS was replaced, but two
> Documentation/mm files still refer to the old names.
> 
> Update both references.  Point readers to mm/Kconfig for the dependencies
> instead of restating information that can become stale.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] Docs/mm: fix stale split page table lock references
      https://git.kernel.org/mm/core/c/51626ff4

-- 
Cheers,

David


