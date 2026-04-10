Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D414F44871
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D276B0088; Fri, 10 Apr 2026 09:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74466B00A9; Fri, 10 Apr 2026 09:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0C66B00AE; Fri, 10 Apr 2026 09:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5DA6B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:56:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64C10E328C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:56:53 +0000 (UTC)
X-FDA: 84642797106.19.9F940B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 92947180008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:56:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WFHGBZgE;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775829411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ONqmcoHtg63MaO8N3rI9xdB4HVusoWzfDjLtiTEjY8=;
	b=wKPISbxWwWI/ujmMpmhjey6ANK1WKRJRT6d5tcL9WWnt8Bu5S7vVb+BI8nWFfo+JwAQcn3
	BDUNX1G6sM4tRw4c7kEtk20TDpF+mc21z/1VxT0JA8SlpY2Sdixv/0Bqsqmet06LAFMClu
	kZaQwp03ULXsvLc8H66UMalbMosbkxY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WFHGBZgE;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775829411; a=rsa-sha256;
	cv=none;
	b=mXOxPaxVbN8e7JQwmzBHe5En1Dnm0t0tr9oR80dYGcmq7JXmVQeaDhMqm9qAkXenlrj/b8
	r0r5eQ+jNaO80j3kc+kDFK7fv74XGiWk8TYBMJSUi0D1lX2C2xgIRCZZcVcpXtMblBfOO5
	PyjR5lIYniLQPhMh4Su4PX+K2Pjcyjw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F4E140E92;
	Fri, 10 Apr 2026 13:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D60C19421;
	Fri, 10 Apr 2026 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775829410;
	bh=Cq39BuoI4ZjI5z6yFIcfBlCfSg0YD+kOMe++kCrcSJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFHGBZgEV+Fb+XXWQrmwdpREGL7yTApc7n0vOgAJE4iBdM4cozvvJnLWpm+0/Uzax
	 ENItqcy+PHFQxNsiVjsLfR1xnd1sAjpts22lobZUiLZt26CGrMQLv92UfyvgUSQdVc
	 lqHSC1E+9WxPcYkvB6PcFfxvmLISFrknfeLHHTuViAjgeqrvf7TP7U3vEMArrcs7EY
	 uEIsfELynMCVvQBZHUc5cAn2Vj4RON0k34DXoaZVwH6g4ZpjO+pngswAsvT1PyLhSf
	 Ps4P7tZgs7YDIKYbtzi19PMjxHx5HJ175kOEKeaAfvkj/QoZAYoN9yX8ZeZbm+Jbpm
	 F9zDql8qGxxew==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 06:56:42 -0700
Message-ID: <20260410135642.82152-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410044259.95877-2-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 92947180008
X-Stat-Signature: o8a8prwizao7x3na1dcd3zz6eiyn1kx3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775829411-614860
X-HE-Meta: U2FsdGVkX19fdbEXnr6dajp38KC6U4Jsv6ZJgYKoOxkNZqblgEi10mya0D61tdSBf25UbNsJ9+ny8HBbUrPAIQZknU3FA2TQvKlic17u3cMEb0XYuxaYA8sEcbOxZErgjNNK8bnJR8puM9SYYXgPzqn1MAI22WM123dbL1YNWZLsSosThZZPu5WXd9KYNyOqxW/MGQr+b2VeKFgOaXvDMGfkQJeaIbADvhv9feLrWIHcCMVfkZL/0z5HhJd/wBWvmcIjaOuBVuJpM2bWfkCg9qa85Mcf8umaFmwgf8oR0bQt1ViT2lH5K7ZwAv7/NVLacX62F1y+w8RZJP4YfcmYomgGGu1CO+VznbsO+HU6f6rQ5wwqydxIlJSiaSY353D6TTWyYXnsGUGt2oyl5ixKRQPfevhkeAuO7K1/htV6z32/rF/Yu2o4l0Oy7x5lvPJntj8hj72hFfLy2wlUwt2HBjMMLJC4rWe6WEFBbxlBYziXNid2fTccTyMv/Locqz+qeBy1IIuG2Vfu8VIvOyCJQLmPvM3sgiwfCqjcXyeANSo4nWt3khCiH6RUEr04w73DUpq19JwrzgOb1PDO9QKnotizQOsyhQM9+iuyb0fsPtM7yQfDJs06uwOeJrhbQj8wzao5R+AICztyQcadKFGpGF3sAciNg4Cgc3MRud+DwN+0NorMRSFF45DmY4Sx6OLP8W6Pz3xELgIPPYN+QdNXd2iwsCO6SGcAPV6Qb8YLC6RzdhWmc5E4NP8EOUllUvxmMQvViEJ3TZEzys3OnLh4H11TCn+wBfQbLBgSRZpXqNBdoI9z9Bh0XpNLCL0ogi8MTwZMv7zoxLDNDr+AkEqKCTEvnqLsEFOCvzJQSaS/Jlw0d/tcdiqaM2Mb3YP3SF9qznogLs07Ab3pWfVDj+utio8LQ94w+xAJV4X3aJa9RJkEvxOzDLyK1d76yaak5G6nZ+BtywFdf0WFuzmt6DY
 DQHsIO87
 yff3N97d8Msy+A7NTJIWTpTzv1h6w/tzkzB5NlSUvXxEVSgPCf6oDvRjCcJkjsksLL+t98Mm+5boy7pcH+0Vxo7Hlt6C3RtJ4X9pQvSQYKP6RGXbg8CDMtytk4RGLjJW8RqwdnKtYgCW4DnkCFw3TcEW+Qs0hpTeN+5Ymi9jP1IikQ2Tk+xETzldR7q2k2vllwjIC3tAHAlyuJb2M/UJ1VMZAft+yUdm3HyCkf0uMpsDNuJ9UCdUn9mYQAWJYHRwe18RO9mm000GPN419rPvGJKaZW2bftePEysk17OLZI+Wbz5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 12:42:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> When a user sets an invalid 'addr_unit' (e.g., 3) via
> DAMON_LRU_SORT, 'min_region_sz' becomes a non-power-of-2
> value. This value eventually reaches damon_commit_ctx(), which does:
> 
>     dst->maybe_corrupted = true;
>     if (!is_power_of_2(src->min_region_sz))
>         return -EINVAL;
> 
> Although -EINVAL is returned, 'maybe_corrupted' is already set. The
> running kdamond observers this flag and terminates unexpectedly.
> 
> "Unexpected termination" here means the kdamond exits without any user
> request (e.g., not by writing 'N' to 'enabled').
> 
> User Impact
> ===========
> Once kdamond terminates this way, it cannot be restarted via sysfs
> because:
> 
> 1. DAMON_LRU_SORT is built into the kernel, so it cannot be unloaded and
>    reloaded at runtime.
> 2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
>    Writing 'Y' does nothing, as 'enabled' is already Y.
> 
> Reproduction
> ============
> 1. Enable DAMON_LRU_SORT
> 2. Set addr_unit=3
> 3. Commit inputs via 'commit_inputs'
> 4. Observe kdamond termination
> 
> Solution
> ========
> Add an early validation in damon_lru_sort_apply_parameters() to check
> 'min_region_sz' before any state change occurs. If it is non-power-of-2,
> return -EINVAL immediately, preventing 'maybe_corrupted' from being set.
> 
> Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
> Cc: <stable@vger.kernel.org> # 6.18.x
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

