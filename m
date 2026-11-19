Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42222606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oy8Bv2ht
Received: by kanga.kvack.org (Postfix)
	id 600DD6B0610; Thu, 19 Nov 2026 06:17:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589FC6B0611; Thu, 19 Nov 2026 06:17:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F7B6B0612; Thu, 19 Nov 2026 06:17:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECCA6B0610
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:17:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C95A1A0A63
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:17:26 +0000 (UTC)
X-FDA: 85451617692.11.C318FE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 087BDC0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:17:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oy8Bv2ht;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795087045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TG1nYNTcyHyUOWzd5MXIw5ZMjc5V360SZkt3R3ZKcZ0=;
	b=Tf4M7rKYgHgDlBVga9uesPb/9EUW5cZ1mk/umzKhODhVWd4hpeTiwF4wMON6UozTpyT4FF
	SX4PO+lpLoAwRzDtQ17EaD/9hPmpr9foRCdmSVvqhXIUejCK3MgPJLFGmXXxHCj+4KgJa8
	0+Uov1uXilVoj6MS2eSHwT1NEgQIuTg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oy8Bv2ht;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795087045;
	b=N5OYS4unIxHx3p60mK0GGQHjfL126LvScGnuP8hhO3YhoTKxMTrfT2RT6c/ePk+oSzLHAr
	03UajrwKFQMWLDfyKBdvM3IX0w5jdT6CXCxzFIwJGmBjieFysZxu72ftaOFpJW05PzQVBk
	1CMNKYQh1ChgWUJiTmTdnnvY7V5vM8M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98E98633B6;
	Thu, 19 Nov 2026 11:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB501F000C8;
	Thu, 19 Nov 2026 11:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795087044;
	bh=TG1nYNTcyHyUOWzd5MXIw5ZMjc5V360SZkt3R3ZKcZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oy8Bv2ht8Z31GiXHlzXSp+X8i+LdKi+A80wBsB56MX4yrnfzRl6Vl4L8OlITkHEqp
	 9t9oEkYzCGYR27uioqP/4jUcusdffaFZdSe5GdlSAMu20ZQTSGlPFEuIiMekhTRHAG
	 RvTulDh+dz2/k/LpLKHWfPauRY9Q4RyOOLznMU8Ygr/EeOq3zypKD3I1++z+7EIt1r
	 8lV3s0YAQTwxkPoXgbVq+Pu1QQArC6iKTatyIKgFHYxmINrvnmnL0JfArsuymvAXSS
	 JiE1rhf0LzNCJ3e5ooQfRy4r5+iiwroEeLT3sSosXplwKH0ByzxGmd2K3p94pmkp3A
	 ecq21BmBr1mww==
From: Mike Rapoport <rppt@kernel.org>
To: pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	Long Wei <longwei27@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	graf@amazon.com,
	leitao@debian.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hewenliang4@huawei.com
Subject: Re: [PATCH v3] kho: do not expose incoming sub-blob contents in debugfs
Date: Thu, 19 Nov 2026 13:17:07 +0200
Message-ID: <179508700586.361583.12491114908870226409.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119095937.826980-1-longwei27@huawei.com>
References: <20261119095937.826980-1-longwei27@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d4pyq681y8o35tnukmd3x31kmw96w95r
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 087BDC0003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795087044-756912
X-HE-Meta: U2FsdGVkX1/k3KfLRdJBZFj/iOfHwweusskNqO8Z5aCvELiHgf8mbpJ1IAU2MYlGVc1OwGdxI8v068MbpU68Z1RM44XDzVgFeJ0COa6WPZP7aIKJeHSPMRgzLKxj4+DD7dQI3lgliJIAvRoFkLWkvuSxWyHC6F3QZXtrXBawgIVIc0vY4yIKoFJ5rD52i440egEMyn+biCIbKm+KPcO599HQn5Br8occlz1jutKRB0gGBH2l7cBiqnLdEpOp4fer/gIp8jSvV8HvINV3OvNyb145R9E/mIRTMrivsnz21sgYG6DfD29GinhLox5cITfT6+61yh6+mE7huQdzOa/erIUtGspJa5aCGY9KROrlrHPKdrRaUx1w5/9KzUOMqbxh4PQQfN/WY44//vSBFYdmG79Is+fVAbkgP4BbDghIMxIkAcXNxJhaMwyt18XY6geEi4cFCiJ7vIwvJaBQ4LIDw+XtJgyk9mkfChrJglEWde11V4ouQyIIdVikzWg8zb2GEkozfd0ZHdFACYRFJRBLe/Ahql6c4MpegctIbknhArLY8im0B2P3lVdgqVsmksB32OvFK36smvtW3b/uH1SqM3GhgWOEDtkXGPpK4CXJVZRAM/hJQNV4uEFvsmtrpXoyNak0zTca4hI7BODn3EQW5vHouArg+WEWz3UYeorv4FacDFzXSFqnRM5IseGG0AV/ON/I0LDjil9POA9jPOLhCJGgZ4CoSCi0Ys1WyA+utYZx1F1/WFKuvBfD+bavzgFqr4gQAKE4fOWtJQtafGMr/Ylz687cqolVPrbbh+p4ivYg/Xp4iJ3zv9uEX9AaECAvctkV09pfysos8GqoxbEDEAO0frguy9169/P1yurNDijiraOG/oaX4I4fiIuCidXAGl9s+TMqzrWCnYLvDaJua3wpUMc6DNYRjXIdMv93nmCCRzbsyFm0f2VQIE25nQxuR0d20GwxccftYZ+0+iN
 mzi2Plu6
 PKkAg92wuSkUiIHl+vVBSanO3gX0SXeYZ7iN/9ebQnOuRcAMINiM/2JJaL4FM8E+fx00jBo1E+0ikJfA/nburMJiZxkhX97+pnwf1EWGfXZTWzxQkNTxiLBYwarLUBxmtSRO3fbdTGqs9Zh1o9hWtxo/ByFiw6OdID7ld7vtimOstKtTGxFTkCvs8UD++ZRVYkiKpVsleLFRj6nFx5HEkM4MdGndhhg/ycKwcemsFwAOibo6AohYx5t72Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Thu, 19 Nov 2026 17:59:37 +0800, Long Wei wrote:
> Incoming sub-blob pages are owned by their consumers and have independent
> lifetimes.  Some consumers, such as LUO, restore and free their state in
> early_initcall, i.e. before kho_init() (fs_initcall) builds the debugfs
> view:
> 
>   early_initcall: luo_early_startup()
>                     -> kho_retrieve_subtree("LUO")
>                     -> kho_restore_free(luo_ser)   /* page is freed */
> 
> [...]

Applied to liveupdate-7.5 branch of liveupdate/linux.git tree, thanks!

[1/1] kho: do not expose incoming sub-blob contents in debugfs
      commit: bfc4b321d12e344627c1ee4977d6a0a084746d7e

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: liveupdate-7.5

--
Sincerely yours,
Mike.


