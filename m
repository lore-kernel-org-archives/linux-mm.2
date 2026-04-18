Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F43F99C70
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 01:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A87D6B0170; Fri, 17 Apr 2026 21:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6596C6B0172; Fri, 17 Apr 2026 21:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E106B0173; Fri, 17 Apr 2026 21:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4332C6B0170
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:48:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D56F1401F2
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:48:20 +0000 (UTC)
X-FDA: 84669991560.02.A48189D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 70C9A40002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:48:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBPkYmSA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776476898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfECRjdLoFqTWTGH2NEXo5jeUvLVjUK+8uB6svU/Q5A=;
	b=p+tLFivPhocMqXegbmFreWzZG8LyKGPALSZ4dPn1kBC1Fp5TxVxSYVTv9BgKl3yDk42c0E
	jzfCy88wxjCXh24Y7Q3lSILabNJx9upSWvHwIe0i+re+RYtqhNLdYSepnjQEaiAFgbawe3
	0xeVyq1vylltAm/c7h3bdIKACJB/380=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBPkYmSA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776476898; a=rsa-sha256;
	cv=none;
	b=hBMrJcvDiIsdLsx0n6BNYGA1wkOf3nxKnVDtEBe4ccXhJpEUXbpZnyC8sl0luaNmcVGK+x
	bmLFb6ySazIbhlmpbxfxjG1APlL/LHvjC4UsI/rFp7RCXzJLgijigkZxoUbhA211H+Coxv
	2qmPWjNg7WSU+VzqHIXxpFgXKpInWXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A678260052;
	Sat, 18 Apr 2026 01:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A79EC19425;
	Sat, 18 Apr 2026 01:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776476897;
	bh=1Rp1KBEyLyK+Bx4RgUvTNrqEBxwP43pQchU5gS2AO9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBPkYmSASkVlJEao0vRV/xxyyMOiN7JBiSCwVegfTTNhlgubeoLPDgliDrRCTPA9F
	 qkn0OdbsEemZz/j4XVVr5k+oH3WGsQW99Xz5tJWE4SgB+np0s9PAIrZyXvjwPHkn5W
	 9NHwmuXcZB7mK/VdvEnnw9uijwBt0gPcEnw24E+yz1S43bomNLF5NpevDbVDVqDos0
	 pLwrzuDwB8WKrov+hliFpkedgvklxSU7bVKy6as0RDK8poRKSHrjdt5zWssUQwU40e
	 VIoy9zKS+hwksmgS+7Yiku6HbJQOkcMK3M4GaVPyHMQL+nufwne0a535Hf1h55vZJC
	 GxCuWECx++ygQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/stat: detect and use fresh enabled status
Date: Fri, 17 Apr 2026 18:48:09 -0700
Message-ID: <20260418014809.6428-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416143857.76146-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 70C9A40002
X-Stat-Signature: umpcmq3onp18hce1xx1fxe7nnib5f5ko
X-Rspam-User: 
X-HE-Tag: 1776476898-763868
X-HE-Meta: U2FsdGVkX19y8cLIh04DNGZP+PCcgLS7p2j7WPGRFLrLjVXwwn8zwhM/P0JE0mPIDJI1UMBw6Y3fuMh92e2Iy/tK52/6YSi0HYODEThiCvrVOFs2SNVLEHkfBcebcmEjpazhZmuCMihCgRa8BrVuJaVlJF/5ai83mEGdwzijkQ95JwV2Bz8Ll9G6Nkvzcp6QaFJYMDNk7CaWACHHj9fSA2ztG7GE2xWEiNvm+tx6P71eCLZ+yniTuSNBtkvz8TuFkpdJp5saTSqpRSm1aWNtK9Ht92ETD9RT9z+w3zTeCtUv7RJJymbpmt+tFfsIb/ZDRyyHZEwRylwA1EtRzyIZuyJ+pETteHT+lZSeUSEjwchohpmt0aeiEpTlH+9BIChBTXZhbQ4PoZ1+XkAj46/Xei2DuatVaa0mXepEaIuhgiUqtnX6y5JNtUxA3KO/ugD3hdjVSmRr+91e/8fMOtD/PrzoDWOCrIZAtyORCBlrzjXheU3YGvKgr5YNHYdR1aKD4cguYhEVxKTlRAHTVUS+HgSuj/IMbzshVdR8QdZXD3TElxsDg8+oTN6eizfYE6kpYhpTnbV8zsT8pBjNmDQ+LWUObHem3jHjHeUKE53bfnLsJpaV8IWe5GcCMred/jR/4rmYp6AAM0whsOk+nfU+U1pQsA/EXHx3BMHmgW99rKWFyX4FfGdItx5ctf9b00PefXbgFBGNE47sBfrjsMYcavoo+jBks0SzlykjPiTP36IU3EvG+CPViPu5wreYBGiuOddDIL3lH7UJp/ktaMnjcCaA5931j7PwE9qUIClnfMD0eg13/xfNFkTKXs5FUHRUw+6o5lb6igXN1y9k/b4nNuekWdx5vaKj8l9GF5RLGRvuebAcXHL48sW/W0yRgMI+uZ7dByKEYM3rmpx9CJq6EP4+nH0xz+d86fQyvvcoisHdKnYSghYkX1/QbG4gYXYYxHh3X2HVsUMBrw+pz7i
 6kzXFOYO
 JG63kjSm3F7TcQQhhPMfBWGBqiF0cRZb3yA8Xga0TPro8m35SDznkSpQIsCOpXUxMFKzJ7Cun+K3KcByGgfzbR+JF0hgYlRv5IofYkxtXGazS7OkhYigut3rAhVoxs6DSpxkZipw9eeLU86NT6R8ThRL1yn7PD4scTzLRqhNymjL1st98LJ3F0Ck4pJaRIsmFE0nu2aP8N/d2T8n5izjiZq3nmm1fh4n+BYv3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Apr 2026 07:38:55 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON_STAT assumes the kdamond will keep running once damon_stat_start()
> succeeds, until it calls damon_stop() to stop it.  If the
> regions_score_histogram allocation in kdamond_fn() is tried after
> damon_stat_start() returns, however, and if the allocation fails, the
> kdamond can stop before DAMON_STAT calls damon_stop().  In this case,
> users will show the 'enabled' parameter value as 'true', while it is not
> working.  This could make users confused.
> 
> The user impact should be mild, though.  First of all, the issue may
> happen only quite rarely.  The allocation failure is arguably too small
> to fail (100 unsigned long objects) in common setups.  The time window
> for the race is also quite small.  Even if the race and the allocation
> failure happen, users could find the fact that the kdamond is stopped
> using 'ps' like commands.  By writing 'N' and 'Y' to the 'enabled'
> parameter sequentially, the user can also easily restart DAMON_STAT.
> 
> That said, the bug is a bug that needs to be fixed.  Instead of managing
> the complicated state in the variable, detect and use the real kdamond
> running status when the user reads the parameter, via the parameter read
> callback.  This will allow users to always read the correct 'enabled'
> value.
> 
> Note that the 'enabled' variable is no longer the argument for the
> 'enabled' parameter.  But it is still used for two use case.  For
> keeping the config/boot time user-set parameter value.  And for keeping
> the user request to compare against the current state, to see if the
> damon_start() or damon_stop() call are really needed.

Posted the next version of this patch as a part of another series [1], because
the patches of the series are fixing the similar type of bugs.

[1] https://lore.kernel.org/20260418014439.6353-1-sj@kernel.org


Thanks,
SJ

[...]

