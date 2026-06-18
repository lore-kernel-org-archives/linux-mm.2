Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD6BCD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751986B0095; Thu, 18 Jun 2026 11:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701DF6B0098; Thu, 18 Jun 2026 11:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A996B009D; Thu, 18 Jun 2026 11:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0276B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:22:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A04461C3594
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:22:52 +0000 (UTC)
X-FDA: 84893400984.13.EFA17C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDFCB10000A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:22:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N2Nr7ytf;
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781796170;
	b=UJKuTqXy/fpe47zAA//2k6431Wv6ZWSZtrD4jjMLc95+oPtuabhlTd+IFsyHPJ4fJAqLRf
	kZtUXMNsWTYUPXvpLhAIPS3QQVY/AS0CaMQWS1v67eGcykfkV80LB6q+XHl2cbfb0/xmYm
	qZYnqMLh4nDBPZ86Bg2290uxZCCjWz4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N2Nr7ytf;
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781796170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Nfq1nbewpV3ldPfGqEuLaQwrCSsnXhHgF/2bLP+ehnw=;
	b=hl6cMzthgVOre4A16a00n/+0nzom4385LXHyjSUX8MPWl+VwcuSXSh/TfK8bOz/hrFGsCs
	DClBKM7Q0nfGqH2F/nnvOV+vZXvd84CnJIJ9iYxplJOWTrlvqAszK5+LrW85BW50H/01cI
	MQWV295LJu2c27Q0hm25jtcJ54/HxvM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6368960008;
	Thu, 18 Jun 2026 15:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190CF1F000E9;
	Thu, 18 Jun 2026 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781796170;
	bh=Nfq1nbewpV3ldPfGqEuLaQwrCSsnXhHgF/2bLP+ehnw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=N2Nr7ytfhqX7K0LgZSwkknMdgIvFgp9ntonxB5VrfsNnW9cQSbrJaGoUSfL+HwBJ9
	 nulFvfd41BWOje9qlK9jie6MrLaeLHSect6HVz3oJXN5oGA2orNlQ6M4p8gRiNjZJE
	 TZMFZsf8FXP37U3si2wzgvUxAsPsOclACeYhqMqolY2qpABFoaOGaGE7vhcn/iildf
	 YNUHNCG3zrxQF2HGvKE/1c8+l8Lnmf245Kc1LQ9fFz6PIev8YuTWq0aL3RBvqW4yP7
	 TddxrF5P64X3IiHWrqcarNhRzO0A2BimNg8FKLE8NtlSKelV+pO0VMBPCTbvmBJNLz
	 StecrDSSmcuVA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A603A566DE;
	Thu, 18 Jun 2026 15:22:44 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
References: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-17-15-16
X-PR-Tracked-Commit-Id: e771677c937da5808f7b6c1f0e4a97ec1a84f8a8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2f9f5887b42711595e768b9dc0582dccfdf60c3b
Message-Id: <178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
Date: Thu, 18 Jun 2026 15:22:43 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: xypzmxxs8m1qzs61q6ryjc9nfe69xo7w
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CDFCB10000A
X-HE-Tag: 1781796170-157609
X-HE-Meta: U2FsdGVkX19AI6MqT/DCHaj3yWNgaBrhodwuUzsuO+MeKmgTlPK6ZlmvDbi5jVFREuGBdGV1whecL5BuLbvc8+8IG1fGtxTg8jiogvDb24mYtYRz4dTIUw0LAbzEGclZZxz+znUoQ4LR1Ol/mWwyCNucCqJvjFLin+AZVZ6/lnalapl6HS2vyXx1FuqaWCeIZNYCABdTG1//YR4ygBF3BM4mXMEEqofZWK5ltpwczqvezohxuUtRfoBSsUO7/JTkb0pwRARCE/skGGDlfVtb5uZVTbALw+i/KWOxPDDq0sJ5R2lm+qk9E3pskSO4a7BP/v5EVOa4ApdhcfnvTvvLsB5aE9QfVozY9ub9+sp6BUpmq/Ey5AjoJcJNauf1DiHMnREap2pBFPZzvnZBoA/KlS2z0xlyrBQ32wHFSJkAZn2NBzaMUObi9TeJTG2iWYIFVnOBxwNqkDZi0jSLqcKW+b8Wr/kj1RWvLNUsbrzraMzLG6ad4JlkSiJLOHZj6v9uqul5C2lNObhP6pWwcCq7VKMCj1qPMrlcIGem66W7NfXi+izUXGMZAuJOJuBwuCbZWKGokx6D6iiZWMe1kxTPjwtDABdjdzccjFNzNhERu9yOGDz8XwTYSxmxTTcmK9mTE1wBJJJaPIZIYYU9nVr7RsrFU7A0Xk7OD1ktuERsT5h2+0gUHHZIBMqjTL7LpCXOc3eEKKNGo7jldRbsYQW+f9Q+S9BNAJyLuthM/tXZFJFiM2KYGcDKq+sED+uUIYZJCVuXvYabrnJZw/TPZhW4RvsdNVM3UUOSOTkP1krjgcyfejv29Qry60YwQ/ORiaS6NlVrCgPmFZZbNd9cKWZQs1IJf8BtiAoMQ0GzXc46LToEprG+jr5RGj4DIojmxuIpo93sxMSIlfzBbxj+QdaFNHpxJRNQS+IiSjEuC5C+eurSj7SokiG+mnPBI5Oj9o2MXFaGmfDY8xh/YwRfpVx
 gxAVrWUt
 HEYPfZYGY+mnbBoewcBjNjPrwo3TYWHtlMAgXi2FC2zsRQAOo03mvAx2uAlY2INhGN8OtoFkW/vjSy6/zPI4EpHr2UYauV0pqpiEnecpXg1KBiTB31scsiEfcqu8un3/Z2jwUNbngvUpw18zYJlYAXTD35VQ3X1XiuQCEHfMsR9auEGOYPruGq/99pk62pYJsARRMm2T5/DIX2l6hid5nadAwXtEICj73o4lQ1A8tKyQmQdwr383b/sDjzQy/yVbHJQFjRCwqASgfWxFqRd+xdotk7o8wW6W2ekTXKurE1jfoQqh50LJA+xn/44JKFERlPhuJiHLmm2HXlv/REzDKOlDa8pcYS1khG/bgI4T3IXbwqNVHG7wLqP5vXED/oBiIe7bDhZmpc0tKVSHO0LlfjOZ7atluBjm/co/n73cwkdCgnaE1G46H0bkTPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 17 Jun 2026 15:31:44 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-17-15-16

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2f9f5887b42711595e768b9dc0582dccfdf60c3b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

