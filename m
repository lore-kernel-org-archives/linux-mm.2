Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA74CD4F3D
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 00:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B7F6B0005; Sun, 17 May 2026 20:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EBF76B0088; Sun, 17 May 2026 20:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602446B008C; Sun, 17 May 2026 20:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 520EF6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 20:31:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F414E9024E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 00:31:56 +0000 (UTC)
X-FDA: 84778663032.18.5BEF0AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4544C14000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 00:31:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P6hoLyFo;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779064315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szWgFiR2GXdlboE5Z4hgns7B9hnuQY6mgVViixCAoxk=;
	b=EI4N6IiPTtvheX+iBdZ7fRI3J+VIft0DcrKwT6fqptH9lGLZ22+lKu/oKe7mtGR+bK2+RH
	jGevsmTP8RWfVUsq+/PU4yE79R2j9sJMwlIATOHbU1+JLDiRULeG7QK5iyVK+SBAyzrcVJ
	LElEeKLAcRxHotYje5G1J0b18Nd4a9c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P6hoLyFo;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779064315; a=rsa-sha256;
	cv=none;
	b=VjVMTnAmC6pgBihH3Wn198IuXMrwGkfjCK7mBQ3lzCkcZXW6DtiYe/rsfpXAHR6HyuLqJ8
	bJS0POp35LfUR0S+2kYIMJqGMLOIKjKZrzoL/TeWcMznChKp/SYzJ7no4oEF94Srk4Ro++
	CwgIwcEtyqL4Xt053b1erMAv1xPNTx0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B35A4346C;
	Mon, 18 May 2026 00:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C1CC2BCB0;
	Mon, 18 May 2026 00:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779064313;
	bh=P0yfwFwGdfVQUZWZRsLbZpRmNi1AbMAXOb5ZQy0ErQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6hoLyFoUX9K5umBVNVOeUFCrRX5nD5Ovcu+0K9kqwypBypQnr1JVq0SY4Bw84uL7
	 8Qfkrz9/BnbRzpAfM6l0KcXK0iryttGWEn2cwHSjDI+AFWncZnnpVgNWOehhFkl9kA
	 4JQjNknYKWjKIAqVWcNfuYAVfJ7jot1WFLUfSp1iRTKb87ZUj8us5fAfzhMrPBWNoG
	 PPzn0yLHJ5emhyhRH/Xj+aLDiRYDmuCsV8C8loz6LuUx77vR460QfcREN3E/JcHRx2
	 yJoWStHRx4iL2WbGB+jyFw6brGQJH50u+lo+JU32K7tud9SdX3/glJ9BUSpR6tG9aC
	 T559hc1/UhaEQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] Docs/{ABI,admin-guide}/damon: fix various typoes
Date: Sun, 17 May 2026 17:31:41 -0700
Message-ID: <20260518003142.87871-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260517235214.89662-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4544C14000B
X-Stat-Signature: gdhyb4m7p77iyxmjtoazwmn13tsu1ur9
X-HE-Tag: 1779064315-613605
X-HE-Meta: U2FsdGVkX18IWpmo5I9vpP8P16Zet0wQbSM6J6fFCMbKgxTggxySz35G+g0vabKlHyWRnqSoxsr2yRtGrs3b0wVqEddTqUw1NiZMpQNlb0Wu9hu4qvgfYp/3DGIFE5h0gqZWR1zacqv9I0s8e4hcgmikmWcbxhiYUiEMpNeG4eeuXlAe6BYdNzkEv8Wzc56CRivGlnNvWahtTMGD7EkdmCs/gUwcK2pwxxzel5qvsqRzvT9lqgStwwS+M35L1ya4MpNBiXetyQfNdG1pCDtPjCil9vGCI771528T3G4ZUyo5AGXkWdIoHyt7LFbiNqX55pA2SHVQwFoa8hk8K6lDgdz52Qm3V0H2Di1Q8Xq2sty4YGP5NXlAC8XolUF6QUA+ocEGiKpoS7PoNs+9WddG1FuLpF7nOT+2c+kneAgobdq7wjbEyUR4Jm7RJUG0zHShXyORtk9AmZ/m3pBufQNFnE6mwdRlcNHplqDICDXMV7cUyWX2jaIEJZ6TOplmd9ooq95aEm+wFzIy/k9f1YJ21HTRLReIylKUQWbSo7Jix12k/WSLj2bhmAmrO8bdINXrXdTut4g5AEZfhe0mEhtHmwiSW6tIlNpcvOBQCglrU3ao4X53lnIQUOCCLnRDVJrM8W79slzDgFOXmbur3zVEdbLONVJ9DsUY63ghlWoPKbM7GAK4hBt5cita231qgLbEQNQMr2656r+VSdrWiD1VRVucy+ZHPROeDIdB9dsHJtx/mxOI0YR4viACDTb1yE5hgediEgqD3Vw87fkG9X63doWSwQy8qOIp7LG3ivxoA+N0806Rzyt2GIHIpZPRSnNHUqln7/nfVlfAN8iKkbsSx1rBf5MHdnK9nXodAU/fjiiOAKNNfNF4PZtdZ4XdVat6fZKBbGEQznnN1JEi7s7C9P/xhpMUnXpPS9HDl0iAnc0Pe1K2UatFkDvBzZQbSyO1EWi34ULFz7dkgiO3z8+
 qQC3KdZj
 8YMNbevigA3NvW6PoHErkAfclgVUBElpAbvRGfbRZc3EoG5VkrfNzx5koSxAxuPMPcBsrFsAEum4g6gAmASGk/N+RFTrjN7xMBOSCac6SW5a1gAqqZbyxff5SBEKAeMtx09FT/wbjXw+zjhDU+47JV9RCrTk/LnwdWhw34blN0PJwIZU77m1Y6paDh6V/PWrlzyaLbaqvMvogtaiSOHnhBELcZ8zyalWggivfAJPPMrm8CzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 16:52:13 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 18 May 2026 02:26:22 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:
> 
> > ``damon_target_idx`` was wrongly written as ``target_idx`` in the docs. Fix
> > it all over the place, as well as the wrong directory count, grammar, etc.
> 
> Nice, thank you Zenghui!
> 
> > 
> > Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Note for Andrew.  Seems this patch is not based on mm-new.  I added this patch
to damon/next [1] after resolving the conflict.  Please feel free to pick it
from there if you'd like to.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git/commit/?h=damon/next&id=011caa6d782382337b598a92aefe3c5db5ed8c0e


Thanks,
SJ

[...]

