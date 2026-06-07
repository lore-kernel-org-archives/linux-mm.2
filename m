Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B59CD8C89
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 20:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305A56B0088; Sun,  7 Jun 2026 16:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD7A6B008A; Sun,  7 Jun 2026 16:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219FC6B008C; Sun,  7 Jun 2026 16:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 135B56B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:10:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E65C91EF8
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 20:10:38 +0000 (UTC)
X-FDA: 84854209356.24.CB64424
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1598A20008
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 20:10:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bShHqSnI;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780863037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7wIHOSWYohEmLG6pMXnfULhqgb287plk20JlAu4I5Ys=;
	b=zh3hKW28lMBpn2+u0bO3sP1iglg9N6mbPH4dWp2ZNTp9hCMRUrKtZWbdj2lMXmmJFug/XQ
	dls3aRYVAhtu0YGsIkKA7LpsmSti3qJD28HpKJJhcPNMcBHcDWG4vis8fBuCZsdNd0Tc8U
	7f3cyd++CcJgn444+uvIwS8qVAZ27YE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bShHqSnI;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780863037;
	b=ejkNYw8uEFI4YsT2pkLvCJ/YNSuKKs/uSdkSrzscsxTI2u/QVXvuZQb5phv8a0mEIIinKY
	Xt2tM8hw1/qfrqJx1KWASQnrrcS0rs+B1841OrxDlQbgBSkcPk6ROCssMEeEHVgGWrec65
	n1E+yWqK+HUvOLCl5VN0xyNiI8GuTA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13F3444281;
	Sun,  7 Jun 2026 20:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BEA1F00893;
	Sun,  7 Jun 2026 20:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780863036;
	bh=7wIHOSWYohEmLG6pMXnfULhqgb287plk20JlAu4I5Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bShHqSnI6oWOfUDSbW6cYy9eMbRTgUko/xyPhiYjQd4+q8UgRyl4FX9sU96QojKmj
	 7jK6GH6Y5DzVZNl/oYRof/zwlsdAgIq4fxxaZFx4NGJtrqT4D5dnzx3nfJWfCBYTOo
	 qOhK6VyjprDy5b4PtURtf5opb1bLBCMSUX9BCEzhGEFgCit94GdQXXSZ8nj/J1X447
	 DHVTof/qqRgiYNi6dpMLHS0InhtO5TGWFhmblbiv2yVcqPhabshMvd3rR4d7/yfzL6
	 CUrw06X/S8BL4t3f+hrAxCmBx9mGTYM7AciY6l3xlakeFNLHf3tkdeUpikDVPqcxDZ
	 IOF2V8sJaovvQ==
From: Tejun Heo <tj@kernel.org>
To: bot+bpf-ci@kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: david@kernel.org,
	arighi@nvidia.com,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	martin.lau@linux.dev,
	martin.lau@kernel.org,
	eddyz87@gmail.com,
	yonghong.song@linux.dev,
	emil@etsalapatis.com,
	void@manifault.com,
	changwoo@igalia.com,
	clm@meta.com,
	ihor.solodrai@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] arm64: mm: Complete the PTE store in ptep_try_set()
Date: Sun, 07 Jun 2026 10:04:19 -1000
Message-Id: <1780862659.ccb18e27e916dc4b@kernel.org>
In-Reply-To: <5f68f44310d4878185fd5ebc52d66530b99f174c6d04ab1170dc53cefaa54568@mail.kernel.org>
References: <088f52fd25860ca961449d53f91b214a@kernel.org>
	<5f68f44310d4878185fd5ebc52d66530b99f174c6d04ab1170dc53cefaa54568@mail.kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1598A20008
X-Stat-Signature: rqd3gaby4me1zajf6o8fkd8gp4tcnpib
X-Rspam-User: 
X-HE-Tag: 1780863036-16754
X-HE-Meta: U2FsdGVkX1+0UttKTtVb4cwxKoC6sbgewp3CCIJcaMW/eXAIyd0poryS4aNIakjnlkvldSLMNMSzfyXeZf8LwVc6Eb9Qx8vcpQ0x/8sGaWqLzlCwS9wPdjjq2Zy/8ChaSLZGHXx9j+dFLZE/2qs5bUON5QaEEF/k/Sys79T4oGqrDdk/NEBBwak1ytiANcFMz/Pb5MK5LwY8vuWX6drw7yeVOAfhytPySU5xK582CTCGkCiIgIZXVsjeOiLSNzk29iKYJ3ivuSZ93Pnt1hn0G5QgS2CWyST0glilX1VoTQqJTwGyuQzN1F0r4H0Appd7W99bAWETALPLwQ6Q2JOq/FwLWx+mRdZQ8Qv7ISlqswINm/zzjQUqdpyaX2Gw0anHV+1fzhdSA9VqqeHWJMZMtROM/uIob3Amb0jQ0hthtS7HMmKD+NxRaXhUmSnd0tJ5OvrWxdFoUUmcSZlykX7xiI4aRjng6FBFNtROzjBBhbYxGr0mOusuiqfdxgGJ0t5BrhcslbUprNmUoUAn7WstOjxNul/nljs7wbC5qBeHR0i7wxbt511jLP6092CfHDqTIoQGbzRhkMRm9rQlLyatlYYvSAdgtr5QYGbJwP2GOc8DeNoxgZxD4fREpcFN3+khBfUH7w9B1rSPy9wc4bRc+y+vjfER+HS6nLBROSE9bLuZqfWasjV0XW5gGeOJ7xYj3Cd4hKaLWli+wQku1w06uYp9//S3eEsNCBk53mAp9BWi9OqXZBxHvAPJuM1Rm9O60kpL5WbEV80ttdBoMKM9Z9sPrrYuKfyA28MgT3ZUl+UKjA932K9cTyxSqGNfOxz8LKbkeHwxCl417ibFD8MCnnHiGSKdq7yatqDFWtLZBeCLfzsyTkRAu47EqZOsGJ5vThPy7Vm3XgWVgexfBsNU3y0KFmmBkt8Dh7Fnnm9/AnHKA4JWH+a1dcmkKI2/PFTPgm1jNVul+8plNQzBAQa
 PBlNcSTJ
 QVDI/jdPMT2PruxyfLYImrVsm1kZ7nG9q/CVeuwRX4C9QKywiO/dnLrEGCpuGEiU64vOljAeOUqFHhmTTi6uyF9x+ukqZEGZ3RktCQv8e6V4o4p2msAPWwsLoKsYR0DpquM8FhA5HD1XEAqkoENQ07rkVMzvezXXXxFFMjAf/MpqQIj/ywIruMS+wVhYmt0hVYRZx438XXRr0Bcft7Gvye4PgsJecb0i569cHnuRc3BdI+XI0FgpPH3Ec4ELi2wwD9amYwCDAZoz2Mkihj9Je0OQpxEHPjQ8kCIUL6hEI9WDP+eau+xFPl9QPsMJ7b9STuua0tY5w21HUaK5H3AArkWYW/Fp8HFL3hx9TU5RxMxB7ePProsd8QBVvBzGRHt3gZq5GGc7T2ORlobU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Can this path actually loop, or is the deferred barrier guaranteed to be
> flushed before the faulting instruction is retried?

I don't know the arm64 paths well enough to say. What I can see is that
ptep_try_set() only runs as an apply_to_page_range() callback, and
apply_to_pte_range() brackets it with lazy_mmu_mode_enable()/disable(), with
the disable() flushing TIF_LAZY_MMU_PENDING before returning. The barriers
would land before the access is retried. It also looks like the same
queue_pte_barriers() path __set_pte() already uses. I'd defer to Catalin and
the arm64 folks on whether that actually closes the case.

Thanks.

--
tejun

