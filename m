Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55F04E9A02C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 01:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4E86B0088; Wed, 18 Feb 2026 20:04:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392DD6B0089; Wed, 18 Feb 2026 20:04:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29EF06B008A; Wed, 18 Feb 2026 20:04:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 125AE6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 20:04:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64863C18ED
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:04:10 +0000 (UTC)
X-FDA: 84459409860.03.53DCEE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A5EE510000C
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:04:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L32xS16g;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771463048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdAm9pTPOD9i9t96maISbNwBxnNnpKBkAUUZPriO1Jw=;
	b=jLsG90X1vbHv2NSQIJbBL1ykTjPFNhWOxddYRD7x4PS55YcurBsM2tIDY/Se2Xnmfj/f/Y
	XhnAoulHji8tCQ7phtIlXtdB9W/C7Ua9V3c3e9hl4bCstotC4vxX+q2Rboa4b4ViLtIEB3
	jg1g4BeORKw6tagi7uDoKMhjk7nnZeo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771463048; a=rsa-sha256;
	cv=none;
	b=tG/pAj3tyku30MdG4Bmq1Ea3TCDlMl7q5rh/WAIPFdZzzhvYLmoKFbXUCUfW4XEUAprc79
	zB+gZ/EFPCU+kyYINQ78J3oKEx5y98DiIAdzTcMpihGYkFZjEWHhBgrZ67kOCn50QRe3J4
	tCXPjJWyRM114Z2MygEGiDIRdc4z9+g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L32xS16g;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82CB141696;
	Thu, 19 Feb 2026 01:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E49EC116D0;
	Thu, 19 Feb 2026 01:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771463047;
	bh=ELJFpYBMPW6NyCooS7WYiywWZpTw9pOT/6BVKExWtr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L32xS16gl5H8aHk6bLRU9WdpO7TPRkz+GTjha1vrvtR9K5BNc+kPUunqC97DMcOCN
	 tDc/0IuxFCvs85CvDeUFFtItdH9DqDTpe4pX7uckIF2xkZvZ6ik444VAC7dtsZRRry
	 xR8yoV9F0uSJDJ9cV+yFXtd7TerdfmXxdzWlWxRSH3DdjZ/Qk10Z/CkacxNuG8Z1ge
	 3oNLzKibaR3c+roA1iAAYgJnXprrvF019Mo5nqKrw+a4JiQCP+E9Qd8trLmO5QAdhg
	 wwUMwn61ldeWU69BW6FZ9dzAg0qP02GQiGKUhj+Bl2MieGdpBNe6tayp6TcZrJfvvr
	 mHCcCdJ0dTFtg==
From: SeongJae Park <sj@kernel.org>
To: AnishMulay <anishm7030@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip migration tests if NUMA is unavailable
Date: Wed, 18 Feb 2026 17:04:03 -0800
Message-ID: <20260219010404.2939-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218163941.13499-1-anishm7030@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 13gpscyf13nz5tas43w65webxse15jma
X-Rspamd-Queue-Id: A5EE510000C
X-Rspam-User: 
X-HE-Tag: 1771463048-430431
X-HE-Meta: U2FsdGVkX19s/g3gdrhQP+bnMi0OTohQ0TpJdfxSEZIZwhYE4TilVXbCd75msV4CYSJyS4fsMXpnhuo82yfVkTD7v6CgJyRZINuHTVqX9c4NJgkk8n5kXUrE+Zt+YCloZoNHzc1t/QR/r7uQL/rYNLjR0fr0PEv/oGYZhtKpWPDm5flkCuGUaAWQxsK/2f7XiM4WfhwptO/J+QZkiivd4r75v/9UcytN3khw3mKePl5fnlBuHVj1gIwclEMF2aMA/3yy4WYEPBvZiuFYQbPT8+C5XuY54VGZ2z1XwJTs4uXqP8Ghdu6GaaMDkCuKMfMXURvWemc4Ly3fqnPD2Hm2E5whW20AlbGEFjbx9YrmKT/bG9awxQceBLuz1lHmOTEtY49Tui/Rhi0cJBNhJo0gsckz2gOaUxlNIrJPa2/jwoXxDsLE/qjF5fHooz/rNtaCsmEVtP38I56pAZ7oB5qPPLf/vkDCpEehUaUxHDw+IFEjHk5vs5zhpgqv2gE5f2f1H+bvtUYrN+s6DxS3zBI3TmUEwQZ2Br6OmPdTS8Tg9BPAakymixj9xHQ5OBP/tw0ClieyCBj0HpCq4Z8sMHZIdCpsgqq55Q9vk3oVVhJ+S2GhfY/cZI2Yq6rGvB9lVpxglfI+BScGp6sOAsTHw0SRkV8sMHvWmoCZ3g1+VRF2cf63TsScU02gMPZhElPfxMYycNQGOOyuUJR9Q9As6KiynQ6vvzbYjWF6nPiJdFHErPiXpzdX1RyhvwxwHd2iuhxeEWiWlHoz+6bcQStmyyP65Nx56wDgBI59ig+ZhoYDmUm2r+1GiC1UDauj9C0rlapR+iSzf0x/fd7VfaLoUX7nXxbmueo+onzgDk916aug08NVt4Sozzx1h7brf2ZsuWC/LPSkygFMNNEzK2J8havAGkvDYWlCM3HVgTh7o9BiBbDt7InuoRtdtmebmII7ogZczxw3yOdXyXtegJ3sGkc
 gX3wtLUB
 yIvTIYNyYiE/gwuF7gL/Ml4sCtUQSpub5n5vpLaVLXoKsm7Aqx8SUVqYr1Kwp/7THWrMTIRHmtha4XxSWVxkRwJLHgrIU0vINvlfVxP53SPb+bX2ICERdLKzyKCIvp/cJ31P1Ty1po9hsngRg2V73p7/dFntQ3ZIfbIkebhuN72+Z2aYm4CoQdZqEl9yu4xhvKefPJbxx3rirt8nbpDHRJtcspiXPBVSIpd2+1DLfgDVcdTWlh6vlaOyvOvjjHsRBOqkT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Feb 2026 11:39:41 -0500 AnishMulay <anishm7030@gmail.com> wrote:

> Currently, the migration test asserts that numa_available() returns 0.
> On systems where NUMA is not available (returning -1), such as certain
> ARM64 configurations or single-node systems, this assertion fails and
> crashes the test.
> 
> Update the test to check the return value of numa_available(). If it
> is less than 0, skip the test gracefully instead of failing.
> 
> This aligns the behavior with other MM selftests (like rmap) that
> skip when NUMA support is missing.
> 
> Signed-off-by: AnishMulay <anishm7030@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

