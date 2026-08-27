Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E524C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88F206B0088; Wed, 26 Aug 2026 23:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8187C6B008A; Wed, 26 Aug 2026 23:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706966B0092; Wed, 26 Aug 2026 23:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46B906B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:38:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D92C51402E5
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:38:14 +0000 (UTC)
X-FDA: 85145641308.24.133F7D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4A72D80003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:38:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KLijvmtT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787801893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qktSdDuw+LvPQ8hF169l4fiZgm7L5YFz3tdhT11hID0=;
	b=oc6xjiYOX+JB/7ezMxUSmskaVvGi6T51+nx70g3hUZ1jznDfSz/oIV2LWdDf5d4MCm28BE
	/NmttKuIyEJvT1ISV5ddw2QxmxkSqpVaK2DB5A1c6vBZDZt6v7gfX4g+gJMpLVmFioDflz
	UFfyWneIW9kn3knRq3aLhKEX7sdXVTo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KLijvmtT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787801893;
	b=FQ2QE3lUWcPvqf8BxWp6aOnHvSKFegA5dEXL4vDZz2+7WAafjif6sxjKMguTOPHSQoNGc+
	pAuSZOCRmNvjiGRwiox/2wSmP129K68rZyrTRgMlqCPYIN3+A/o3LzZl8ii9ir0c3CE0ya
	lkmc7jo5DgCJYfjNELhzzEyA2apm0vY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77C7641954;
	Thu, 27 Aug 2026 03:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C0C1F000E9;
	Thu, 27 Aug 2026 03:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787801892;
	bh=qktSdDuw+LvPQ8hF169l4fiZgm7L5YFz3tdhT11hID0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KLijvmtT4ozmnssDASNKKsX3XX1TGW48Lwt5kfA58YlXdV3+dCXmMJwhafGn53ZJ0
	 aPWVLvqndAuLVjEO+VEjByrS+Z5gIfgfo6h9GHqHicV0PBDhuRH6qGoUhLjmBfQYnV
	 /FfEsqMQdYF7wWcaGveByfi52Urf/mGKKaPTnQHK5MYWl3o9N62CCOBEd/eXd/aDLQ
	 D27ks91tVY58VBPF2gc3RsMpxBUHyfO8LbcZ5g7u2cL9n3n8s7yWXzOvRA0Y324Xx7
	 lgPAOlwzf2DJM+nkN6bA/jhQbbm9xMM/U/VDAWFvRTFwzROwQ5s6HKlqmrrhrVjq6f
	 Dh8CUancv59Fw==
From: SJ Park <sj@kernel.org>
To: zhaozhengzhuo@uniontech.com
Cc: SJ Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/damon: prevent remaining cross-object state pollution
Date: Wed, 26 Aug 2026 20:38:04 -0700
Message-ID: <20260827033804.89392-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <38E4AAAAEDFCC283+20260827021515.1316838-1-zhaozhengzhuo@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pd6jtn6ji1ms6ste5a9d86rsnc6idskd
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A72D80003
X-Rspam-User: 
X-HE-Tag: 1787801893-233656
X-HE-Meta: U2FsdGVkX19y9U3yfIPjHR7QZu+bmfjyhsxGvv3isS8skNwc7niqnmGG5sCsWObk21bWtUAFhqt+x4i1Y1NNDyaEpbbdRyYRLPKCa+a+1+J+3qpGH137CcNZaNRsyZlQbg83zxblVfniXhbREPL3oljvF3a40B7g6Gc+dVEguu6QRlAg8y2DNFCghLM4I3r5gw4S25wEgKDHufYRwW3iFeMY/DsN4K8BeYEjsrnDgoZZeCmZ/FsLJ/R+QirSUp7uuIidYBB/a07TMAph+1OYiwXFoVzUYGmEIkCV7t/bXyvN5zETfw5OnCSckm4uvtw48zKtVcaMUeeQN8aLHECVmq81B5RqWfgt8UY0YlMou+cgpQz/xA/mzhssb9ALRAy/BXdPxlClsHZdKXF3Q1MfyiEjDVSZf76ZazGcsnliFnj4yOsy08/iw/jAA7eOHFwTqQIpG2bdfiq6VzxA4eD4ckKgpPlNGzp/MSV/0j5jyZSu6KFdXr6Dd8vh/Fou54qj/F8aSwv354uhrZ9N3bbY/XRaWA1uJ8k3MJ51fTWJurDBCwxy9D25m/X2i3Sx1X58Yt9adhC2nMTyhYcysjnvvvE/I4ibw9dupQRPOB8wGtOKmYLiqb3YD5FW1nf73mHuuCQ75zKPVUPs8U2big/RNdz0zkVcLQ6/Lyq/lX8Cq1+Ng7Dlvcn9HOKfp7XJEY/uGxCpaHfGAjU8zvrADRYOd1T0ZiNs/c7dZHTSCNVS72eaWIxvySk1KXKNkkHqDNav0nE/PUTqklajxANvcJpx2IZ5tH+Iq932r33eWOlrQKDa6mSSvWj+tXtPrrJTmkUHW6aww7lfSLuOVli3o5nnPe7RW9bSKch+GwdvQrAV5NHGIg/LWu6p6NOd6+PMoIwK+HJR2g8Cm0lYdN/4LkE5vPWtj//T+RIRkrvF0GMdXR1mmGeZW8+JW7QSXnY3DR4hOZz+C5M5YnzhTF+CXXC
 y3rkPuwu
 J7PHNOkcBquSF7IhUESj6eDTesF8HMMQVDiGxQnphCr9XexEcDUgLVthiA4uWwob3lE6hlSfWd3r3IDEmFqPAyqULblu8iiXWw9XhFje41ZJY94eSJNF/4ld43SY3pg26OZLF9yS9OqLYml3R34E4rUq0yTbk2EHQE6kYHV1nzP8Bbk+wghRodtG+GUUcjvSr/3IyZFXxVMJyN2GTvtdOo3Rf8R6qgDL/qKpGd/QBTlE+7IlXCxcYt8r9Bp1AJ1rWOj7GqRm1Wo/Bg2ckGJIBYRFKsO472cLBBFMLGzAZBl5NUzr5c2RAv/55VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello zhaozhengzhuo,

On Thu, 27 Aug 2026 10:14:52 +0800 zhaozhengzhuo@uniontech.com wrote:

> From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> 
> _damon_sysfs.py defines constructors with mutable default arguments,
> including DamosAccessPattern(), DamosQuota(), DamosWatermarks(),
> DamosDests(), IntervalsGoal(), and empty lists.
> 
> Default arguments are evaluated once at function definition time.
> Damos() instances created without explicit arguments therefore share
> the same DamosQuota(), and the other default-constructed sub-objects
> and lists are shared in the same way.  The sub-objects keep
> back-pointers to their owner scheme, so constructing the second Damos()
> rebinds the shared quota's scheme pointer to the second object.  An
> item appended to one object's default contexts or filters list is also
> visible from other default-constructed objects.
> 
> The shared state can corrupt test configurations.  DamosQuota.sysfs_dir()
> derives the sysfs directory from its scheme pointer, so operating on
> the first scheme's default quota may write to the second scheme's
> directory.  The wrong values often match the defaults, so tests still
> pass, but the behavior depends on object creation order.

I agree all the points.  This should be fixed.  That said, these are only
possible future issues.  No existing test is broken, right?

> 
> Commit 8319dadcbd81 ("selftests/damon: prevent cross-context state
> pollution in DamonCtx") fixed the same pattern in DamonCtx only.  Fix
> the remaining constructors by defaulting to None and creating fresh
> objects or lists inside each constructor.  Explicit arguments keep
> their previous behavior.

Thank you for fixing this, looks good to me!

> 
> Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

