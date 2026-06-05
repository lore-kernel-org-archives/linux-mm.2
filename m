Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C03CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981A46B0093; Fri,  5 Jun 2026 11:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A376B0096; Fri,  5 Jun 2026 11:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897D86B0098; Fri,  5 Jun 2026 11:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7927E6B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:30:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22A381201C6
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:30:10 +0000 (UTC)
X-FDA: 84846244980.12.E0C26F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4E7D840007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:30:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RayKJ7nc;
	spf=pass (imf07.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780673408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BFFFgB57ZAob11PrIhvgonvaYPbDjOxXtuYXVUomG0=;
	b=v8Of31DnEzTWKuXTwVre+Pjy4bpMHEbrkP+kWGLoNlDZSypCSK/lrUX76IgwCsWyHMTiCF
	sRwSTYWuh/BpszQDFvEixodxy3d+FBGfbBp0brTRuv9W00lKSJOlRHtmhN7Q4pnHb5hSGa
	vwo5ZSmC2qMDHtWBJbreNsNneiEYFxs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RayKJ7nc;
	spf=pass (imf07.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780673408;
	b=no75+17GJTrGfiOQpUr2Vjh3YG+KLPEwqTbbMdwfEhhH6R+o9Yfe1cfgPXtB2keQMqp2l/
	/qZJyCV1BuSiagJ7JDlGvT1vPUJskB3HZEg4V1cHy7K/t5Dus7A6hp+Jha7C/vAL4vV0wI
	JrcX0rXYrka1RCn3eJF9rmzNtxpoqfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BB1942B14;
	Fri,  5 Jun 2026 15:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C001F00893;
	Fri,  5 Jun 2026 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780673407;
	bh=1BFFFgB57ZAob11PrIhvgonvaYPbDjOxXtuYXVUomG0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=RayKJ7ncq0sZEb9vdqzRVX7YDpHvVxSzRbkdFFpFXx+JmNyRvyody6M/TZBC+J1mC
	 aijEDSFOVz044vXnDL+FBwplQJdbIFbUpu/BmIKdN10yjwCnxeqA3tttPoUnDrCfXj
	 jJ77iJAoRNuPuAW5vKVhA6bptbyqojfT4V6HHh7zbnAH5oeRGBECqR9A8H+BWuiNEy
	 xndf4zIX/VXugdxNVUP/9oD1IQfp6KuVrUa/LGQ+/TVcncmYM63Jcd3akd8jng6r8x
	 16RFTi1oRG6rL/FWWoe+DWiKMkGU1UMQ8HFvlAKpM2e4qVOhrcaGRY+GkrU8dwNl9q
	 jRADb53t0lpNg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0AF53930BA5;
	Fri,  5 Jun 2026 15:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Replace scratch PTE atomically when
 allocating
 arena pages
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178067340741.3804693.1794735582974531631.git-patchwork-notify@kernel.org>
Date: Fri, 05 Jun 2026 15:30:07 +0000
References: <20260601183728.1800490-1-tj@kernel.org>
In-Reply-To: <20260601183728.1800490-1-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: void@manifault.com, arighi@nvidia.com, changwoo@igalia.com,
 ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
 martin.lau@linux.dev, memxor@gmail.com, peterz@infradead.org,
 catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, akpm@linux-foundation.org,
 david@kernel.org, rppt@kernel.org, emil@etsalapatis.com,
 sched-ext@lists.linux.dev, bpf@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 4E7D840007
X-Stat-Signature: u4u7ts6g6akb4i1f5sb147opnr6wthoj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780673408-388548
X-HE-Meta: U2FsdGVkX19DHrMFPUlJL+RpenI/s/J2WmgjbnQWLIakIJYMaj465yaHFVjoZwjsKHxuYD8vUkwnn23npRHC55K9n6gimUweC/N0WyfXU49PDndjKuuNAG96kqI9tQYSuKNo/PUZEoCMPiccVgKPP6SAAbKv0FP19JwPUTdQC7a9cqlUiuNViK/NC8Ut87W77JCI0k8wRr2eNTD+kkz7oS/c/jRivG7dRMrPQzMPLmLp7Gxkq3BNUpTee6js4RnIX+Rly24vAFDNLSFA1/gUsgqgag+t498j0ZBIsFLHbfsjsl8t5HvV3VE6DaJQXPSQyVw6Hog43ysI0MYec5sbGNCsxfByBfw5ptD9m4eFc4EGmr32gwRSbuBrVITxZL5Fic9VN304ypYnWoHe/Q7MWPb9oHv15jAI+QlJccBawnbXnVX0CNEVAKU9jnHYvGsN6XmZxq8LUEk5QtNZN6rPHDj8tihh/S5CvdJG4HvNeEIdmb+dibEuo+E0cpCb9cWGDHtCVlxAtQWTRJGKvJNVFaPrr+4nCd50nqvAB/OffuJM9rTfGk5grj8lpPTv3hW4/iEYhd8hP2VhvAEV/Q6lQ1UNvKqs4IXC4jjUqgeFeW0Je4uJDhIRQ3Y20vYQrqGpZWKXdmBACRJHVkclloA8jSOKMEQ7jLd8zF/6SSQYtAMDiiUE/f77GD9Gn4a1cYxq8TyUhSu4UKM1YkEAf4kwlJJXeIxDGqj+yvgv/HxC8XaiqiTNPWOlhiM/OPZo38mPoCCkprw5qoSeeIytiFjE+4WH3Z1mQOBc+A+9YctwYsAfrQEKZHvKcLjC9/RG+6ISHDAGaFbqhQBtR5rRr8PNt98bLPun0a1KJmKdaR2QT0fx79KmqPzNycubmqdbuqRGmdbdJwWnGTeWN7J1ce1pQWGTkM5Ul1MdvvNmHxa4Rl3f9XM30vIhGNwiyrPt4ENgo4n6Oge5Kc8Vl+BKEwF
 Io+a0KiT
 AoDeSn3+v2cl/bY3zH9LED4w6h3cahcBM7pdMuw/RJRXpkjm+ha+LkJrMlPBLVhj/tqSFZ6rRLCExCIv2snGwCTIIvlP7zvPY73pkMnZECookZ/HyCy9FkkH8kIbRifZwgFGJuCrCYLAJzn10WXwFYKH6ZHcsKx5TYtUZE2oITyMaKwnXdYxM3WjGsJ8ApOJEfb/uKYGH8SCQVUx1sRoZoesRQP0yh9zgCogngqjf4/yG5jx2mbV3yHG+webgIdh7MTxk24dU0HOgxFJgpWudxjf6okZMTR2jYQjdddbCJ5C4Dh8Qn0v4mUUoVdT9simT9qdV66WuDI8rNENI+wfa3YCqyaQiSUHJbcoapgUquI7wIp63z+BEgU8TJY+8wplaSZRYjGpzQpDdqaeLZErncGB3AoxGkG+FWw0G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Mon,  1 Jun 2026 08:37:28 -1000 you wrote:
> apply_range_set_cb() maps the pages for a new arena allocation and returned
> -EBUSY when the target PTE was already populated. Kernel-fault recovery
> leaves the per-arena scratch page in unallocated arena PTEs, so a later
> bpf_arena_alloc_pages() over such a page hits that -EBUSY, and every
> subsequent allocation of it fails the same way. Allocation must install the
> real page over scratch instead.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: Replace scratch PTE atomically when allocating arena pages
    https://git.kernel.org/bpf/bpf-next/c/f64c723741c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



