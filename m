Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DCBC624D7
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68DDB6B0095; Wed,  2 Sep 2026 10:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6172D6B0099; Wed,  2 Sep 2026 10:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D366B009B; Wed,  2 Sep 2026 10:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 354C06B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:13:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C55ACA3C78
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:13:58 +0000 (UTC)
X-FDA: 85169016156.11.E5F75CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2F68D140014
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:13:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GveyguU3;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788358437;
	b=hkso0EM924b+YrIcaesF96o4lP3Ypvj6cZs9w5nwfMfgK/LiYUc2A9nPp7Y2OUHnKH64h6
	0Auj+uCYQWApUAy0MnDA7tJvtJWs8FtDe6ttsFsowvO/dlDpVRPxD9qEwGDYIYp4lhFM+Z
	ozQsUux1UCkJ1fd9B8Bca7AjAmItQKQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GveyguU3;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sY7iQ8sPr77cH4aM3sTeT7wFW0GP7eesI1PHSHpEgk=;
	b=J/mM0gPjuC/AsSjouHFv8C3fW9IbhGLQTZOb7H1Vk+voCWPC+euOILywwk/AueGAonl2vq
	8D13WhHEaR4bn9zrOGnPYJNVl/CLK4zL2lTDpCpWgVRRbOtYZSOjnRipFpPwP68kAo5jl3
	rlCwLlmwrF+kpgNh3ysFUfSPRomVrAc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A07C40F17;
	Wed,  2 Sep 2026 14:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED03D1F000E9;
	Wed,  2 Sep 2026 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788358436;
	bh=/sY7iQ8sPr77cH4aM3sTeT7wFW0GP7eesI1PHSHpEgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GveyguU3ESZbjw9mrZcN+gKwl14Um+a67M0pjqmHBKAfGaH12EGa4poXgUz15a+p1
	 Ld7ko03aZH/1UwEetlHA9wPUj0aSl3BskI3AxGgwQ4F3DMwyk0Mu18hBOKbl9TEgjU
	 9x0Tvi1mCuX21yj+oMftISrmfQvSiX+z76odon0feaIvVjCWDGqXpNc9fMu/stc8P/
	 2xcqbgTyuwSNIMrfwXDiysh6D4DLIxBWrB8gBjzgAiQ+l2Vn8EQ0JZRWYrbKTXBxxo
	 CchbzB+bjMYLw0vBRqw0XkRn4Cnxofeovu0V0XMl2CzXWaVQwyHK6sR5vFrMIN/IMD
	 Y96xjI3CeWSLA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: allow esz to be set to zero
Date: Wed,  2 Sep 2026 07:13:48 -0700
Message-ID: <20260902141349.86896-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902082050.19566-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F68D140014
X-Stat-Signature: uwmqmqijud6dfdkcwpo1gbiaecy4nt9w
X-HE-Tag: 1788358437-711554
X-HE-Meta: U2FsdGVkX183T3ytLZ/1Lo+Iqxj3FyPPoS1QWawCriqO90FUuSmPvvZVUzyY3vApsii61W8Do1saTOPaujhkBaLnDnk8LaYWoqxapdbyGQV25imVhcVC0IWpLz2A4lZKPsWstaV+La7oVTgqjHhDa2tYNnDmFGBT+TlYSq3/BhBnu1N6ZvcmVy/kLkStWmryELUDFMWrN03AiRMO+uSzolixi2v/nfwhns/W1fbEBNGU/uBs4lfoVCBSXFMAWLc69q2yaZqXZvzEkjXGZOtQRy35clvPy7eEASsQPIZjtD0kszGtH4SWIAvIM3m+DzzF7GPwvCADNZDHWQerWT+3mOAtpRgHuyKhjvW2HYw1+VCjyTb6lyuFHODVFb0Mbx4ws4ZO6ASpoRvpAT/1TzMbakeoZ4ljvC18jZGVceJn2n+e7df6B3kAap/AqaDlQ+IRDmpI6RxwwV8AejiDXrchJfjq48HRNmrZXn+TBwgAD5WWTa7y9RCIk7rVbI41LAqDnmdu32Zx/vSXc26bW7akWVqYfOGgvvFjDrFch9JxlLw1b/Co1QJ8iniOW9VZmKuOCIvXzkPTcckXewZb+AeWsatIWDpLGZeOSGla2/8ntjzPH3AtRWz7RLaSL8Yo/NAzzxZrgTbEG7WF56zLiopexHfyLCaHy0iQU/yakMfcrlPWiQV3Xl36V/eFKKRDrvLzbkSvlvncFSLVBEAcMH1f42tk6uFhBaEYHV5dHG2SALOB0iwoJNgPtXxW+CUchJdYZPQnXb5iZakKiuQA5Cx8l6K+5eTIHqEm9K2Hmpe/wR08ZsiOLVWVoxmkkTzfsa/GzylKZ4JcZIKLVtI4OtF66YEbB3U41ujqLi/MQozfKdyeQ3GWy2yOoI+w9IttuLfRqMwmiGmxKW3iZETP7HrImO8mnbFlgKnkd+Dm69Nm7dIax94syHuYaZVQROQ5crc0ltbTllo4fByt68Y9QI0
 psi1cAhL
 WsgzEZiZ23fHYQt2vs/7De3kkVwz5JOLGq/s/4/83qTchRDEtZE/xUrkAIJSKZt0pDc+w7W+DpA+yINzCS4AiWN38ZUkAgyuUnrO1E/Nv2yJnxoxs7iARPx+tmLWv9tgnAqKZntkOgDst0AnAzeSEtEskrCpclgo/+ofBiHKE2LYxq3bUAmpwOV3O5Uq7UCSmEwHTorLmF0cDc7Xa14D4bXmFs9P5lgQ2Fm3Xch0mJAAs0Es=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 16:20:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> When the temporal quota goal tuner determines that the goal has been
> achieved (score >= 10000), it sets esz_bp to zero so that the effective
> quota (esz) becomes zero.  However, damos_set_effective_quota() clamps
> the quota to min_region_sz, preventing the quota from ever reaching
> zero.

Where in the code it is clamped to min_region_sz, when?  And what user issue
this can cause?


Thanks,
SJ

[...]

